---
name: create-worktree
description: Create a git worktree using g-wa. Use when the user wants to create a worktree for a branch.
user_invocable: true
---

# create-worktree

Create a git worktree using the `g-wa` CLI command.

## Steps

1. If the user provided a branch name (as an argument or in their message), use it directly.
2. If no branch name was given, ask the user: "Which branch do you want to create a worktree for?"
3. Optionally ask if they want a custom worktree directory name (skip if they seem in a hurry).
4. Run `g-wa` with the Bash tool:

```bash
g-wa -t <branch> [--worktree-name <name>] [--stash-changes]
```

## Flags

| Flag | Purpose |
|------|---------|
| `-t <branch>` | Target branch (required) |
| `--worktree-name <name>` | Custom worktree directory name (optional) |
| `--stash-changes` | Stash any current changes before proceeding (optional) |

## Notes

- On first use in a repo, `g-wa` will restructure the repo into `main/` + `worktrees/` — warn the user before running if this hasn't been done yet.
- After creation, tell the user the worktree path so they can `cd` into it.
