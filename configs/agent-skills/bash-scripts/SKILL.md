---
name: bash-scripts
description: Write bash scripts in the SAN_SIVA / gitsy style — sourced utils, set_flags argument parsing, indented command output, nameref return values, and consistent exit-code handling. Use whenever creating or editing a bash/shell script.
user_invocable: true
---

# bash-scripts

Write bash CLI scripts that match Santhosh's house style (as used in `gitsy` and `~/.config/bin`). Every script is a single executable file that sources a shared `utils` library, parses flags in a dedicated `set_flags()` function, runs work through a `main()` function, and prints clean, indented output with consistent colors and `[DONE]` / `[Fail]` status tags.

When writing a script, follow the template in `reference/template.sh` and lean on the helpers in `reference/utils.sh`. Read both before generating code.

## Anatomy of a script

Every script has these parts, in order:

1. **Shebang** — `#!/usr/bin/env bash`
2. **Header comment** — `Author: Santhosh Siva`, `Date Created: DD-MM-YYYY`, then a `Description:` block.
3. **Source the utils** — see [Utils](#utils-library) below.
4. **Default values** — declare every flag-backed variable up front (e.g. `target_branch=`, `force=false`).
5. **`set_flags()`** — argument parsing (see [Arguments](#argument-handling)).
6. **Worker functions** — one job each, declared as `name() { ... }`.
7. **`main()`** — `set_flags "$@"`, then `validate_dependencies ...`, `print_banner`, then the work.
8. **Direct-run guard** — only call `main` when executed, not when sourced (so functions are unit-testable):

```bash
# Only run main if script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
	main "$@"
	exit 0
fi
```

Use **tabs** for indentation throughout.

## Utils library

The shared helpers live at `~/.config/bin/utils.sh` (general purpose) and a fuller git-aware copy ships inside `gitsy/bin/utils`. Two ways to source it:

- **System-wide / personal scripts** under `~/.config/bin/`: source relative to the script —
  ```bash
  source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"
  ```
- **Project-encapsulated scripts** (a repo's own `bin/`): copy the needed `utils` file into the project's `bin/` dir and resolve it through symlinks so it works when symlinked onto `PATH`:
  ```bash
  # Resolve script directory (follows symlinks)
  SOURCE="${BASH_SOURCE[0]}"
  while [ -L "$SOURCE" ]; do
  	DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  	SOURCE="$(readlink "$SOURCE")"
  	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  source "$SCRIPT_DIR/utils"
  ```

Prefer copying `utils` into the project's own `bin/` when the script ships as part of a repo or npm package — it keeps the project self-contained. Copy only the helpers the script actually uses if you want a slimmer file. For one-off personal scripts, source the central `~/.config/bin/utils.sh`.

Key helpers (see `reference/utils.sh` for full definitions):

- `print_message "$msg" $number` — the primary output function. `$number` controls layout:
  - `-1` → flush left, no indent (used for blank spacers and error lines)
  - `0` → indented 3 spaces (sub-steps / continuation lines)
  - `1`–`9` → numbered step `N. message`
  - `>= 10` → zero-padded `0N. message`
- `indent` — pipe a command's output through it (`cmd 2>&1 | indent`) to prefix each line with `   │ `.
- `run_git_indented <git args>` — runs git via a temp file then indents; use instead of `git ... | indent` for fetch/pull so detached `git maintenance` doesn't hang the pipe. Returns git's real exit code.
- `validate_dependencies cmd1 cmd2 ...` — brew-installs any missing commands.
- `print_banner` — figlet+lolcat banner; called right after `validate_dependencies` in `main`.
- `prompt_user true|false "Question?" $step` — Y/n prompt; echoes `y` or `n`. Capture with `ans=$(prompt_user ...)`.
- `navigate_to_dir`, `is_git_repo`, `check_uncommitted_changes` — common guards.

## Colors & status

Use the color vars from utils, always closing with `${NC}`:

| Var      | Meaning                                  |
| -------- | ---------------------------------------- |
| `BLUE`   | in-progress / informational ("…ing…")    |
| `GREEN`  | success                                  |
| `RED`    | failure / errors                         |
| `PROMPT` | yellow — prompts and soft warnings       |
| `NC`     | reset (always end colored strings)       |

End a successful operation message with `[DONE]` and a failed one with `[Fail]`, e.g.
`print_message "${GREEN}Pushed successfully. [DONE]${NC}"` /
`print_message "${RED}Failed to push. [Fail]${NC}" -1`.

Color the variable part of a message by toggling back to `NC` mid-string:
`"${BLUE}Resetting to ${NC}origin/${target}${BLUE}...${NC}"`.

## Argument handling

Parse all arguments in `set_flags()` using a `while`/`case` loop. Support both `--flag value`, `--flag=value`, and short `-f=value` / `-f value` forms. Boolean flags just set a variable to `true`.

```bash
set_flags() {
	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			echo "tool-name - one-line purpose"
			echo " "
			echo "tool-name [options]"
			echo " "
			echo "options:"
			echo "-h, --help                                       show brief help"
			echo "-t BRANCH, -t=BRANCH, --target-branch BRANCH     specify the target branch"
			echo "-f, --force                                      force the operation"
			exit 0
			;;
		-t=* | --target-branch=*)
			target_branch="${1#*=}"
			if [ -z "$target_branch" ]; then
				echo ""
				echo "${RED}Error: No target branch specified.${NC}"
				exit 1
			fi
			;;
		-t | --target-branch)
			shift
			if [ $# -gt 0 ]; then
				target_branch="$1"
			else
				echo ""
				echo "${RED}Error: No target branch specified.${NC}"
				exit 1
			fi
			;;
		-f | --force)
			force=true
			;;
		*)
			echo "${RED}Unknown option:${NC} $1"
			exit 1
			;;
		esac
		shift
	done
}
```

- `-h`/`--help` prints aligned usage and `exit 0`.
- `=`-form extracts the value with `"${1#*=}"`; the space-form does `shift` then reads `$1`.
- An empty value for a required flag is an error → `exit 1`.
- Unknown options error out (omit the `*)` arm only when a script legitimately ignores extras, as `g-push` does).

## Functions & exit codes

- One responsibility per function; declare as `name() { ... }`.
- Take inputs as positional `local x=$1` at the top of the function.
- **Return values out via nameref**, not stdout (stdout is reserved for user-facing output):
  ```bash
  get_current_branch() {
  	local -n result=$1
  	result=$(git rev-parse --abbrev-ref HEAD 2>&1)
  	if [ $? -ne 0 ] || [ -z "$result" ]; then
  		print_message "" -1
  		print_message "${RED}Failed to get current branch. [Fail]${NC}" -1
  		exit 1
  	fi
  	return 0
  }
  # caller:
  local branch
  get_current_branch branch
  ```
  Watch the nameref-shadowing trap: never give a local variable the same name as the caller's nameref target (see the `_new_main_dir` comment in `gitsy/bin/g-wa`).
- **Predicate functions** return `0` for true / `1` for false and are used directly in `if`:
  ```bash
  branch_exists_locally() {
  	local branch=$1
  	if git show-ref --verify --quiet "refs/heads/${branch}"; then
  		return 0
  	fi
  	return 1
  }
  ```
- **Fatal errors** print a flush-left red `[Fail]` line and `exit 1`. **Recoverable** errors `return 1` and let the caller decide.
- The standard error idiom — a blank spacer, then the red line:
  ```bash
  if ! some_command 2>&1 | indent; then
  	print_message "" -1
  	print_message "${RED}Failed to do the thing. [Fail]${NC}" -1
  	exit 1
  fi
  ```
- When you pipe a command but need *its* exit code (not the pipe's last stage), check `${PIPESTATUS[0]}`:
  ```bash
  git checkout "$branch" 2>&1 | indent
  if [ ${PIPESTATUS[0]} -ne 0 ]; then ... fi
  ```

## Indenting command output

Never let raw command output run flush against the left margin — pipe it through `indent` so it sits under its step with a `│` gutter:

```bash
print_message "${BLUE}Pushing changes...${NC}" 1
if ! git -c color.ui=always push -u origin "$branch" 2>&1 | indent; then
	print_message "" -1
	print_message "${RED}Failed to push. [Fail]${NC}" -1
	exit 1
fi
print_message "${GREEN}Pushed successfully. [DONE]${NC}"
```

For git commands that fetch/pull, use `run_git_indented` instead of `| indent` to avoid the detached-maintenance hang documented in `utils`. Use `git -c color.ui=always` so colored output survives the pipe.

## Steps & numbering

Sequential operations are numbered. Pass the step number as the last arg to `print_message` and thread `$step_number` through worker functions, incrementing with `$((step_number + 1))` for sub-steps. Sub-results of a numbered step print at indent `0`. A leading `main` typically starts at step `1`.

## Checklist before finishing

- [ ] Shebang, author/date/description header present.
- [ ] Utils sourced (central path or project-local copy as appropriate).
- [ ] All flag variables defaulted up top; `set_flags()` handles `-h`, `=`-form, space-form, unknown.
- [ ] `main()` does `set_flags "$@"` → `validate_dependencies` → `print_banner` → work.
- [ ] Output goes through `print_message` / `indent`; colors closed with `${NC}`; `[DONE]`/`[Fail]` tags used.
- [ ] Function outputs returned via nameref; predicates return 0/1; fatals `exit 1`.
- [ ] Direct-run guard at the bottom.
- [ ] `chmod +x` the new script.
