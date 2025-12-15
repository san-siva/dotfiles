# gitsy

**gitsy** is a set of versatile bash utilities designed to make managing Git repositories easier, faster, and more efficient. It provides user-friendly commands to automate common Git operations such as checking out branches, pushing, pulling, creating worktrees, stashing changes, and viewing git status — all enhanced with helpful prompts, color-coded outputs, and automation.

## Features

- Quickly checkout branches (`g-co`) with optional stashing.
- Pull (`g-pull`) and push (`g-push`) changes easily, with force push support.
- Create new worktrees for branches (`g-wa`).
- Clear working directory by stashing changes with timestamped messages (`g-rmf`).
- Reset work directory to remote branch with ease (`g-rto`).
- Show current git branch and status through simplified commands (`g-cb`, `g-s`).
- Compare differences between branches (`g-diff`).
- All commands come with automatic validations, dependency checks, and vibrant CLI outputs for clear feedback.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/san-siva/gitsy.git
cd gitsy
```

2. Optionally, add the directory to your PATH in `.bashrc` or `.zshrc` for easy access:

```bash
export PATH="$PATH:/path/to/gitsy"
```

3. Ensure dependencies are installed (the scripts attempt to install missing dependencies like `git`, `figlet`, and `lolcat` if available):
   - `git`
   - `figlet`
   - `lolcat`

## Usage

Each script corresponds to a Git-related utility. Below is a quick guide on common commands and their options:

### g-co - Checkout Branch

Checkout to a branch, with optional stash.

```bash
g-co --target-branch=<branch-name> [--stash-changes]

Example:

g-co -t feature/xyz
   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/


Checking-out to branch origin/feature/xyz
  - Branch not found locally.
  - Checking if branch exists on remote...
  - Branch not found on remote.
  - Create new branch? (Y/n):
  - Created new local branch feature/xyz. [DONE]
  - Checkout to branch feature/xyz. [DONE]

```

### g-pull - Pull Changes

Pull changes from a remote branch.

```bash
g-pull --target-branch=<branch-name>

Example:

g-pull

   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/

Pulling changes from remote/develop...
    - From github.com:san-siva/gitsy
    -  * branch            develop    -> FETCH_HEAD
    - Already up to date.
  - Pulled changes from remote/develop successfully.

```

If no branch is specified, it pulls for the current branch.

### g-push - Push Changes

Push changes to a remote branch, optionally with force.

```bash
g-push --target-branch=<branch-name> [--force]

Example:

g-push
   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/

Pushing changes to remote/develop...
    - Everything up-to-date
  - Pushed changes to remote/develop successfully.

```

### g-wa - Create Git Worktree

Create a new git worktree for a specified branch, optionally stashing changes.

```bash
g-wa --target-branch=<branch-name> [--stash-changes]

Example:

g-wa -t develop

   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/


Creating worktree for branch origin/develop at ../git_worktree__develop
  - Branch not found locally.
  - Checking if branch exists on remote...
  - Branch not found on remote.
  - Create new branch? (Y/n):
  - Created worktree develop from origin/main at ../git_worktree__develop [DONE]
  - Pushing new branch develop to remote...

```

### g-rmf - Stash Working Directory

Clear your working directory by stashing all changes with a timestamped message.

```bash
g-rmf

   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/


Stashing changes...
    - No local changes to save
  - Changes stashed successfully.

```

### g-rto - Reset To Remote Branch

Reset your working directory hard to the latest remote branch, stashing changes beforehand.

```bash
g-rto

Example:

g-rto
   _______ __
  / ____(_) /________  __
 / / __/ / __/ ___/ / / /
/ /_/ / / /_(__  ) /_/ /
\____/_/\__/____/\__, /
                /____/

Stashing changes...
    - No local changes to save
  - Changes stashed successfully.

Fetching changes from remote/develop...
    - fatal: refusing to fetch into branch 'refs/heads/develop' checked out at '<path>/git_worktree__develop'
  - Auto-Fetch failed, Please do it manually.

Resetting to origin/develop...
    - HEAD is now at b4a4bfc fix: revert
  - Reset to origin/develop successfully.

Pulling changes from remote/develop...
    - From github.com:san-siva/gitsy
    -  * branch            develop    -> FETCH_HEAD
    - Already up to date.
  - Pulled changes from remote/develop successfully.

```

### g-cb - Current Branch

Displays the current git branch name.

```bash
g-cb
develop
```

### g-s - Git Status

Shows the output of `git status`.

```bash
g-s
```

### g-diff - Compare Branches

Show differences between two branches:

```bash
g-diff -s <source-branch> -t <target-branch>
```

## Contributing

Contributions are welcome! Please fork the repo and submit pull requests. For bugs or feature requests, open an issue on the repository.

## License

This project is licensed under the MIT License.

## Contact

Author: Santhosh Siva
GitHub: https://github.com/san-siva
