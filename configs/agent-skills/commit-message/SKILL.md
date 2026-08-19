---
name: commit-message
description: Suggest a concise, well-formed git commit message following Nexthink's Conventional Commits standard for the currently staged changes.
user_invocable: true
---

# commit-message

Suggest a commit message following Nexthink's Conventional Commits standard for the currently staged changes.

## Steps

1. Run `git diff --staged --stat` to see which files are staged.
2. Run `git diff --staged` to inspect the full content of the staged changes.
3. Run `git log --oneline -5` to understand scope conventions used in this repo (e.g. common scope names, casing, prefixes).
4. Run `git branch --show-current` to get the current branch name and extract the Jira ticket ID. Branch names follow the format `TICKET_NUMBER__title` (e.g. `EXT-1234__add-login-feature` → ticket is `EXT-1234`).
5. Compose a commit message following the rules below.

## Nexthink Conventional Commits Format

```
<type>(<optional scope>): <description>

[optional body]

[optional trailer(s)]
```

### Types

| Type       | Use when                                 |
| ---------- | ---------------------------------------- |
| `feat`     | Adding or changing a feature             |
| `fix`      | Resolving a bug                          |
| `build`    | Build system or dependency changes       |
| `chore`    | Routine tasks, maintenance               |
| `ci`       | CI/CD configuration changes              |
| `docs`     | Documentation only                       |
| `style`    | Formatting, whitespace (no logic change) |
| `refactor` | Code restructuring without feature/fix   |
| `perf`     | Performance improvements                 |
| `test`     | Adding or updating tests                 |
| `bump`     | Version bumps                            |
| `revert`   | Reverting a previous commit              |

### Rules

- **Always use the Jira ticket ID as the scope** when a ticket is found in the branch name (e.g. `refactor(EXT-9348): ...`). This applies to ALL commit types, not just `feat` and `fix`.
- If no ticket is found in the branch name, use a descriptive scope (e.g. `fix(guide-recording): ...`) or omit the scope.
- Description SHOULD be under 50 characters, imperative mood, no trailing period.
- Breaking changes MUST use `!` after the type (e.g. `feat(EXT-1234)!: ...`) or a `BREAKING CHANGE:` footer.

### Preferred format (ticket as scope)

```
refactor(EXT-9348): extract error codes into enum
fix(EXT-1234): resolve session expiration issue
feat(EXT-5678): add JWT authentication for user login
```

### Fallback format (no ticket in branch)

```
fix(guide-recording): resolve session expiration issue
chore: update dependencies
```

> Full spec: see `references/conventional-commits-spec.md`

## Output format

Present the commit message in a fenced code block ready to copy. Always use the Jira ticket ID extracted from the branch name as the scope. If more than one framing is reasonable, offer up to two alternatives with a brief trade-off note.
