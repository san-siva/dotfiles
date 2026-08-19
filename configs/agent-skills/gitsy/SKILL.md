---
name: gitsy
description: Use gitsy CLI commands to perform Git operations — branch management, worktrees, push/pull, diffs, and more.
user_invocable: true
---

# gitsy

Gitsy is an installed bash CLI toolkit for Git workflows. Use these commands via the Bash tool to perform git operations on behalf of the user.

## Commands

| Command  | Purpose                                      | Key flags / args                          |
| -------- | -------------------------------------------- | ----------------------------------------- |
| `g-s`    | Show git status                              |                                           |
| `g-cb`   | Print current branch                         |                                           |
| `g-co`   | Checkout a branch                            | `-t <branch>`, `--stash-changes`          |
| `g-pull` | Pull from remote                             |                                           |
| `g-push` | Push to remote                               | `--force`                                 |
| `g-wa`   | Add a worktree (auto-restructures repo)      | `-t <branch>`, `--worktree-name <name>`, `--stash-changes` |
| `g-wl`   | List all worktrees                           |                                           |
| `g-wr`   | Remove a worktree                            | `-t <branch>`                             |
| `g-db`   | Delete a branch locally and remotely         | `-t <branch>`                             |
| `g-dlc`  | Discard last commit                          |                                           |
| `g-rmf`  | Stash working directory changes              |                                           |
| `g-rto`  | Reset branch to match remote                 |                                           |
| `g-diff` | Compare two branches                         | `-s <source>`, `-t <target>`              |

All commands support `--help` for details.

## Usage examples

```bash
g-co -t feature-branch            # checkout feature-branch
g-wa -t EXT-1234__my-feature      # create worktree for a branch
g-diff -s main -t feature-branch  # diff main vs feature-branch
g-db -t old-branch                # delete a branch
```

## Notes

- `g-wa` auto-restructures the repo into `main/` + `worktrees/` on first use — confirm before running in a repo that hasn't been set up this way.
- Destructive commands (`g-dlc`, `g-rto`, `g-db`) prompt for confirmation — surface those prompts to the user before proceeding.
