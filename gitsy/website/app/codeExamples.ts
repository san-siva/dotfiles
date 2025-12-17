export const HELP_TEXT = {
	checkout: `g-co - attempt to checkout to branch

g-co [options]

options:
-h, --help                                                          show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--stash-changes                                                     stash changes before proceeding`,

	pull: `g-pull - pull changes from remote branch

g-pull [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--stash-changes                                                        stash changes before proceeding
-f, --fetch                                                            fetch changes before pulling`,

	push: `g-push - push changes to remote branch

g-push [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--stash-changes                                                        stash changes before proceeding
--force                                                                force push changes to the target branch`,

	worktree: `g-wa - create git worktree for branch

g-wa [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--stash-changes                                                        stash changes before proceeding`,

	worktreeRemove: `g-wr - remove a git worktree for a specified branch or name

g-wr [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--worktree-name NAME, --worktree-name=NAME, -w=NAME, -w NAME           specify the worktree directory name`,

	deleteBranch: `g-db - delete a branch locally and optionally on remote

g-db [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the branch to delete`,

	discardCommit: `g-dlc - discard the last commit

g-dlc [options]

options:
-h, --help      show brief help
-f, --force     force discard without checking uncommitted changes`,

	stash: `g-rmf - clear your working directory by stashing changes

g-rmf [options]

options:
-h, --help                                                  show brief help
--message MESSAGE, --message=MESSAGE, -m=MESSAGE, -m MESSAGE   specify custom message for stash`,

	reset: `g-rto - reset to remote branch

g-rto [options]

options:
-h, --help          show brief help`,

	currentBranch: `g-cb - show current branch name

g-cb [options]

options:
-h, --help          show brief help`,

	status: `g-s - show git status

g-s [options]

options:
-h, --help          show brief help`,

	diff: `g-diff - compare changes between two git branches

g-diff [options]

options:
-h, --help                                                             show brief help
--target-branch BRANCH, --target-branch=BRANCH, -t=BRANCH, -t BRANCH   specify the target branch
--source-branch BRANCH, --source-branch=BRANCH, -s=BRANCH, -s BRANCH   specify the source branch (defaults to current branch)
-f, --full                                                             show full diff and copy to clipboard
--files-only                                                           show only file names (no stats, no clipboard)`,
};

export const CODE_EXAMPLES = {
	installation: `git clone https://github.com/san-siva/gitsy.git
cd gitsy

# Add to your PATH in .bashrc or .zshrc
export PATH="$PATH:/path/to/gitsy"`,

	checkout: `# Checkout to a branch
g-co -t feature/xyz

# With stash
g-co -t main --stash-changes`,

	pull: `# Pull current branch
g-pull

# Pull specific branch with fetch
g-pull -t develop -f`,

	push: `# Push current branch
g-push

# Force push
g-push --force`,

	worktree: `# Create worktree for branch (creates ../worktrees/feature_new_feature)
g-wa -t feature/new-feature

# With stash (creates ../worktrees/develop)
g-wa -t develop --stash-changes`,

	worktreeRemove: `# Remove by branch name
g-wr -t feature/old-feature

# Remove by sanitized worktree directory name
g-wr -w feature_old_feature`,

	deleteBranch: `# Delete branch (prompts for remote deletion)
g-db -t feature/completed`,

	discardCommit: `# Discard last commit (soft reset)
g-dlc

# Force discard (hard reset)
g-dlc --force`,

	stash: `# Stash with auto-generated message
g-rmf

# Stash with custom message
g-rmf -m "WIP: refactoring"`,

	reset: `# Reset current branch to remote
g-rto`,

	currentBranch: `# Show current branch (copies to clipboard)
g-cb`,

	status: `# Show git status
g-s`,

	diff: `# Compare current branch with target (shows stats, copies stats to clipboard)
g-diff -t main

# Compare two branches
g-diff -s feature/a -t feature/b

# Show only file names (no stats, no clipboard)
g-diff -t main --files-only

# Full diff (copies formatted diff to clipboard)
g-diff -t main --full`,
};
