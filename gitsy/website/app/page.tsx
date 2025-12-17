'use client';

import {
	Blog,
	BlogHeader,
	BlogSection,
	CodeBlock,
	Callout,
	Table,
	BlogLink,
} from '@san-siva/blogkit';
import styles from '@san-siva/stylekit/index.module.scss';
import { HELP_TEXT, CODE_EXAMPLES } from './codeExamples';

export default function Home() {
	return (
		<Blog>
			<BlogHeader title={['Introducing Gitsy']} desc={['17th December 2025']} />
			<BlogSection>
				<p>
					<strong>Gitsy</strong> is a set of versatile bash utilities designed
					to make managing Git repositories easier, faster, and more efficient.
					It provides user-friendly commands to automate common Git operations
					such as checking out branches, pushing, pulling, creating worktrees,
					stashing changes, and viewing git status — all enhanced with helpful
					prompts, color-coded outputs, and automation.
				</p>
			</BlogSection>

			<BlogSection title="Command Reference">
				<Table
					headers={['Command', 'Description', 'Key Flags']}
					rows={[
						[
							<code>g-co</code>,
							'Checkout branch',
							<code>--target-branch, --stash-changes</code>,
						],
						[
							<code>g-pull</code>,
							'Pull changes from remote',
							<code>--target-branch, --fetch</code>,
						],
						[
							<code>g-push</code>,
							'Push changes to remote',
							<code>--target-branch, --force</code>,
						],
						[
							<code>g-wa</code>,
							'Create git worktree',
							<code>--target-branch, --stash-changes</code>,
						],
						[
							<code>g-wr</code>,
							'Remove git worktree',
							<code>--target-branch, --worktree-name</code>,
						],
						[<code>g-db</code>, 'Delete branch', <code>--target-branch</code>],
						[<code>g-dlc</code>, 'Discard last commit', <code>--force</code>],
						[
							<code>g-rmf</code>,
							'Stash working directory',
							<code>--message</code>,
						],
						[<code>g-rto</code>, 'Reset to remote branch', 'None'],
						[<code>g-cb</code>, 'Show current branch', 'None'],
						[<code>g-s</code>, 'Show git status', 'None'],
						[
							<code>g-diff</code>,
							'Compare branches',
							<code>
								--source-branch, --target-branch, --full, --files-only
							</code>,
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Features">
				<Table
					headers={['Feature', 'Title', 'Description']}
					rows={[
						[
							<code>g-co</code>,
							'Checkout Branch',
							'Checkout to a branch with optional stash, automatically handles local and remote branches.',
						],
						[
							<code>g-pull</code>,
							'Pull Changes',
							'Pull changes from a remote branch. If no branch is specified, it pulls for the current branch.',
						],
						[
							<code>g-push</code>,
							'Push Changes',
							'Push changes to a remote branch, with optional force flag for overwriting remote history.',
						],
						[
							<code>g-wa</code>,
							'Create Worktree',
							'Create a new git worktree in ../worktrees with sanitized branch name (e.g. feature/foo → feature_foo).',
						],
						[
							<code>g-wr</code>,
							'Remove Worktree',
							'Remove a git worktree by branch name or worktree directory name.',
						],
						[
							<code>g-db</code>,
							'Delete Branch',
							'Delete a branch locally and optionally push the deletion to remote.',
						],
						[
							<code>g-dlc</code>,
							'Discard Commit',
							'Discard the last commit with optional force mode to hard reset.',
						],
						[
							<code>g-rmf</code>,
							'Stash Changes',
							'Stash all changes in working directory with a timestamped message.',
						],
						[
							<code>g-rto</code>,
							'Reset to Remote',
							'Reset working directory hard to the latest remote branch, stashing changes first.',
						],
						[
							<code>g-cb</code>,
							'Current Branch',
							'Display the current git branch name.',
						],
						[
							<code>g-s</code>,
							'Git Status',
							'Show the output of git status with color formatting.',
						],
						[
							<code>g-diff</code>,
							'Compare Branches',
							'Compare and show differences between two branches.',
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Installation">
				<p>Clone the repository and optionally add it to your PATH:</p>
				<CodeBlock
					language="bash"
					code={CODE_EXAMPLES.installation}
					hasMarginUp
					hasMarginDown
				/>
			</BlogSection>

			<BlogSection title="Commands">
				<p>
					Each script corresponds to a Git-related utility. Below is a
					comprehensive guide on all available commands.
				</p>

				<BlogSection title="g-co - Checkout Branch">
					<p className={styles['margin-bottom--2']}>
						Checkout to a branch, with optional stash.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.checkout}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.checkout}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Check if the branch exists locally</li>
						<li>Search for the branch on remote if not found locally</li>
						<li>Prompt to create a new branch if it doesn't exist</li>
						<li>
							Stash changes if <code>--stash-changes</code> flag is provided
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-pull - Pull Changes">
					<p className={styles['margin-bottom--2']}>
						Pull changes from a remote branch.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.pull}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.pull}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Use current branch if no branch is specified</li>
						<li>
							Fetch changes from remote if <code>-f/--fetch</code> flag is
							provided
						</li>
						<li>Pull and merge changes from the target branch</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-push - Push Changes">
					<p className={styles['margin-bottom--2']}>
						Push changes to a remote branch, optionally with force.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.push}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.push}
						hasMarginUp
						hasMarginDown
					/>
					<Callout type="warning" hasMarginDown>
						<p>
							<strong>Warning:</strong> Using <code>--force</code> will
							overwrite remote history. This can cause data loss for
							collaborators who have already pulled the branch. Only use force
							push when you&apos;re certain it&apos;s safe.
						</p>
					</Callout>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Use current branch if no branch is specified</li>
						<li>Push changes to the remote repository</li>
						<li>
							Force push if <code>--force</code> flag is provided (use with
							caution)
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-wa - Create Git Worktree">
					<p className={styles['margin-bottom--2']}>
						Create a new git worktree for a specified branch in{' '}
						<code>../worktrees</code> directory, optionally stashing changes.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktree}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktree}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>
							Create the <code>../worktrees</code> directory if it doesn't exist
						</li>
						<li>
							Sanitize branch name (lowercase, replace special chars with{' '}
							<code>_</code>)
						</li>
						<li>
							Create worktree in <code>../worktrees/sanitized_branch_name</code>{' '}
							(e.g. <code>feature/my-branch</code> →{' '}
							<code>feature_my_branch</code>)
						</li>
						<li>
							Truncate to 30 characters with ".." suffix if name is too long
							(e.g.{' '}
							<code>feature/this-is-a-very-long-branch-name-that-exceeds</code>{' '}
							→ <code>feature_this_is_a_very_long_br..</code>)
						</li>
						<li>Check if the branch exists locally or remotely</li>
						<li>Prompt to create a new branch if it doesn't exist</li>
						<li>Push the new branch to remote</li>
						<li>
							Stash changes if <code>--stash-changes</code> flag is provided
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-wr - Remove Git Worktree">
					<p className={styles['margin-bottom--2']}>
						Remove a git worktree by branch name or worktree directory name.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.worktreeRemove}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.worktreeRemove}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Search for the worktree in the worktrees directory</li>
						<li>Check for uncommitted changes in the worktree</li>
						<li>Prompt for confirmation if uncommitted changes exist</li>
						<li>Remove the worktree directory and prune git records</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-db - Delete Branch">
					<p className={styles['margin-bottom--2']}>
						Delete a branch locally and optionally push the deletion to remote.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.deleteBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.deleteBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Prompt for confirmation before deleting the branch</li>
						<li>Check if the branch exists locally</li>
						<li>
							Delete the local branch (requires branch to be fully merged)
						</li>
						<li>Prompt to delete the branch on remote if it exists</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-dlc - Discard Last Commit">
					<p className={styles['margin-bottom--2']}>
						Discard the last commit with optional force mode.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.discardCommit}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.discardCommit}
						hasMarginUp
						hasMarginDown
					/>
					<Callout type="warning" hasMarginDown>
						<p>
							<strong>Warning:</strong> Using <code>--force</code> performs a
							hard reset, permanently discarding all uncommitted changes in your
							working directory. This action cannot be undone.
						</p>
					</Callout>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Prompt for confirmation before discarding</li>
						<li>
							Check for uncommitted changes (unless <code>--force</code> is
							used)
						</li>
						<li>
							Perform soft reset (keeps changes) or hard reset (discards
							changes) based on <code>--force</code> flag
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-rmf - Stash Working Directory">
					<p className={styles['margin-bottom--2']}>
						Clear your working directory by stashing all changes with a
						timestamped message.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.stash}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.stash}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Create a timestamped stash message if none is provided</li>
						<li>Stash all uncommitted changes (staged and unstaged)</li>
						<li>Clear your working directory</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-rto - Reset To Remote Branch">
					<p className={styles['margin-bottom--2']}>
						Reset your working directory hard to the latest remote branch,
						stashing changes beforehand.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.reset}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.reset}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Stash any uncommitted changes</li>
						<li>Fetch the latest changes from remote</li>
						<li>Perform a hard reset to the remote branch</li>
						<li>
							Pull the latest changes (⚠️ this is destructive, stashes changes
							first)
						</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-cb - Current Branch">
					<p className={styles['margin-bottom--2']}>
						Display the current git branch name.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.currentBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.currentBranch}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Fetch the current branch name</li>
						<li>Display the branch name</li>
						<li>Copy the branch name to your clipboard</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-s - Git Status">
					<p className={styles['margin-bottom--2']}>
						Show the output of <code>git status</code>.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.status}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.status}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul>
						<li>Fetch the current branch name</li>
						<li>Display git status with color formatting</li>
						<li>Show staged, unstaged, and untracked files</li>
					</ul>
				</BlogSection>

				<BlogSection title="g-diff - Compare Branches">
					<p className={styles['margin-bottom--2']}>
						Compare and show differences between two branches.
					</p>
					<CodeBlock
						language="bash"
						code={HELP_TEXT.diff}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>Usage examples:</p>
					<CodeBlock
						language="bash"
						code={CODE_EXAMPLES.diff}
						hasMarginUp
						hasMarginDown
					/>
					<p className={styles['margin-bottom--2']}>
						The command will automatically:
					</p>
					<ul className={styles['margin-bottom--4']}>
						<li>Use current branch as source if not specified</li>
						<li>Fetch the latest changes for the target branch</li>
					</ul>

					<p className={styles['margin-bottom--2']}>
						<strong>Default mode (no flags):</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>
							Show a stat summary of changes (files changed, insertions,
							deletions)
						</li>
						<li>Copy stats to clipboard</li>
					</ul>
					<p className={styles['margin-bottom--2']}>
						Example clipboard content:
					</p>
					<CodeBlock
						language="text"
						code={`src/components/Button.tsx    | 23 ++++++---------
src/utils/helper.ts         |  4 ++--
src/pages/index.tsx         | 15 +++++++++++
3 files changed, 28 insertions(+), 13 deletions(-)`}
						hasMarginUp
						hasMarginDown
					/>

					<p className={styles['margin-top--4']}>
						<strong>
							With <code>--files-only</code>:
						</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>Show only file names without stats</li>
						<li>No clipboard copying</li>
					</ul>
					<p className={styles['margin-bottom--2']}>Example output:</p>
					<CodeBlock
						language="text"
						code={`src/components/Button.tsx
src/utils/helper.ts
src/pages/index.tsx`}
						hasMarginUp
						hasMarginDown
					/>

					<p className={styles['margin-top--4']}>
						<strong>
							With <code>--full</code>:
						</strong>
					</p>
					<ul className={styles['margin-bottom--2']}>
						<li>Display the complete diff output with all changes</li>
						<li>
							Copy the formatted diff to clipboard (full diff content with color
							codes stripped)
						</li>
					</ul>
					<p className={styles['margin-bottom--2']}>
						Example clipboard content:
					</p>
					<CodeBlock
						language="text"
						code={`file: src/components/Button.tsx
stats: +15 -8
changes:

   @@ -10,7 +10,9 @@ export function Button() {
   -  const handleClick = () => {
   -    console.log('clicked');
   -  };
   +  const handleClick = useCallback(() => {
   +    console.log('Button clicked');
   +    onAction();
   +  }, [onAction]);

file: src/utils/helper.ts
stats: +3 -1
changes:

   @@ -5,7 +5,9 @@ export function formatDate() {
   -  return new Date().toISOString();
   +  return new Date().toLocaleString('en-US', {
   +    dateStyle: 'medium'
   +  });`}
						hasMarginUp
						hasMarginDown
					/>
				</BlogSection>
			</BlogSection>

			<BlogSection title="Contributing">
				<p className={styles['margin-bottom--1']}>
					Contributions are welcome! Please fork the repository and submit pull
					requests. For bugs or feature requests, open an issue on the
					repository.
				</p>
				<a
					href="https://github.com/san-siva/gitsy"
					target="_blank"
					rel="noopener noreferrer"
					className={styles['a--highlighted']}
				>
					View source code, report issues, and contribute
				</a>
			</BlogSection>

			<BlogSection title="License">
				<p>This project is licensed under the MIT License.</p>
			</BlogSection>

			<BlogSection title="About">
				<p>
					<strong>Author:</strong> Santhosh Siva
					<br />
					<strong>GitHub:</strong>{' '}
					<a
						href="https://github.com/san-siva"
						target="_blank"
						rel="noopener noreferrer"
						className={styles['a--highlighted']}
					>
						https://github.com/san-siva
					</a>
				</p>
			</BlogSection>
		</Blog>
	);
}
