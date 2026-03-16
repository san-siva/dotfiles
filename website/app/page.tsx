import type { NextPage } from 'next';

import styles from './page.module.scss';

import {
	Blog,
	BlogHeader,
	BlogSection,
	CodeBlock,
	Callout,
	Table,
} from '@san-siva/blogkit';

import { CODE_EXAMPLES } from './codeExamples';

const DotfilesDocumentation: NextPage = () => {
	return (
		<Blog>
			<BlogHeader
				title={['dotfiles']}
				desc={[
					'Personal macOS development environment — Neovim, terminal, shell, and tooling configuration',
				]}
			/>

			<BlogSection title="Overview">
				<p className="margin-bottom--2">
					A comprehensive macOS development environment managed as a git
					repository cloned directly to <code>~/.config</code>. Because all
					XDG-compliant tools look in <code>~/.config</code> by default, every
					config file is automatically in the right place with no extra
					symlinking needed.
				</p>
				<p className="margin-bottom--2">
					The setup includes a full Neovim IDE configuration, Kitty terminal,
					Zsh shell config, global Git settings, ESLint / Prettier / TypeScript
					configs, and a collection of utility shell scripts for daily
					development.
				</p>
				<Callout type="info" hasMarginDown>
					<p>
						<b>Theme:</b> The entire environment uses the{' '}
						<strong>Catppuccin Frappé</strong> color palette — Neovim, Kitty,
						and all terminal tools are configured to match.
					</p>
				</Callout>
			</BlogSection>

			<BlogSection title="Directory Structure">
				<p className="margin-bottom--2">
					All configuration lives under <code>~/.config</code>:
				</p>
				<Table
					hasMarginDown
					headers={['Path', 'Description']}
					rows={[
						[
							<code>nvim/</code>,
							'Neovim configuration (init.lua + Lua modules)',
						],
						[
							<code>kitty/</code>,
							'Kitty terminal — fonts, theme, window settings',
						],
						[<code>fish/</code>, 'Fish shell — minimal PATH additions'],
						[
							<code>configs/</code>,
							<>
								Home-dir dotfiles (<code>.zshrc</code>, <code>.gitconfig</code>,{' '}
								<code>.tmux.conf</code>, etc.)
							</>,
						],
						[
							<code>bin/</code>,
							<>
								Shell utility scripts (<code>android/</code>, <code>dev/</code>,{' '}
								<code>utils.sh</code>)
							</>,
						],
						[<code>git/</code>, 'Global git config and gitignore'],
						[<code>assets/</code>, 'Screenshots, patched fonts, theme files'],
					]}
				/>
				<Callout type="success" hasMarginDown>
					<p>
						<b>XDG compliant:</b> Cloning to <code>~/.config</code> means tools
						like Neovim, Kitty, Fish, and gh pick up their configs automatically
						without any manual linking.
					</p>
				</Callout>
			</BlogSection>

			<BlogSection title="Requirements">
				<Table
					hasMarginDown
					headers={['Tool', 'Purpose']}
					rows={[
						[
							<code>neovim 0.10+</code>,
							'Editor (required for all nvim features)',
						],
						[<code>node 18+ / nvm</code>, 'JavaScript tooling, LSP servers'],
						[<code>git</code>, 'Version control'],
						[<code>kitty</code>, 'Terminal emulator'],
						[<code>zsh</code>, 'Primary shell'],
						[<code>brew</code>, 'macOS package manager'],
						[
							<code>JetBrainsMono Nerd Font</code>,
							'Font (all terminals + Neovim)',
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Installation">
				<p className="margin-bottom--2">
					Clone the repository directly to <code>~/.config</code>:
				</p>
				<CodeBlock
					hasMarginDown
					language="bash"
					code={CODE_EXAMPLES.cloneRepo}
				/>
				<p className="margin-bottom--2">
					Three setup scripts handle the full environment bootstrap. Run them in
					order, or use <code>setup-environment</code> to run all three at once.
				</p>

				<BlogSection title="setup-environment">
					<p className="margin-bottom--2">
						The top-level bootstrapper. Installs all system tools via Homebrew,
						then delegates to <code>install-global-deps</code> and{' '}
						<code>link-dotfiles</code>.
					</p>
					<CodeBlock
						hasMarginDown
						language="bash"
						code={`~/.config/bin/dev/setup/setup-environment`}
					/>
					<Table
						hasMarginDown
						headers={['Category', 'Installs']}
						rows={[
							[
								'Languages',
								<p>
									<code>python3</code>, <code>node</code> (via nvm),{' '}
									<code>ruby</code>, <code>go</code>, <code>lua</code>,{' '}
									<code>rust</code>
								</p>,
							],
							[
								'Java',
								<p>
									<code>openjdk</code>, <code>openjdk@21</code>,{' '}
									<code>ant</code>, <code>maven</code>, <code>jdtls</code>,{' '}
									<code>google-java-format</code>
								</p>,
							],
							[
								'Editor / Terminal',
								<p>
									<code>neovim</code>, <code>kitty</code>, <code>tmux</code> +
									TPM
								</p>,
							],
							[
								'Shell',
								<p>
									<code>oh-my-zsh</code>, <code>powerlevel10k</code>,{' '}
									<code>zsh-history-substring-search</code>
								</p>,
							],
							[
								'CLI tools',
								<p>
									<code>ripgrep</code>, <code>fzf</code>, <code>fd</code>,{' '}
									<code>zoxide</code>, <code>jq</code>, <code>yq</code>,{' '}
									<code>gh</code>, <code>fish</code>, <code>deno</code>,{' '}
									<code>wget</code>, <code>tree</code>, <code>fastfetch</code>
								</p>,
							],
							[
								'Formatters',
								<p>
									<code>black</code> (Python), <code>sqlfluff</code>,{' '}
									<code>shfmt</code> (via Go), <code>stylua</code> (via Cargo)
								</p>,
							],
						]}
					/>
				</BlogSection>

				<BlogSection title="install-global-deps">
					<p className="margin-bottom--2">
						Installs all global npm packages, symlinks ESLint configs, and
						enables Corepack. Safe to re-run.
					</p>
					<CodeBlock
						hasMarginDown
						language="bash"
						code={`~/.config/bin/dev/setup/install-global-deps`}
					/>
					<Table
						hasMarginDown
						headers={['Category', 'Packages']}
						rows={[
							[
								'ESLint core',
								<p>
									<code>eslint</code>, <code>eslint_d</code>, <code>jiti</code>,{' '}
									<code>@eslint/js</code>, <code>@eslint/eslintrc</code>,{' '}
									<code>@eslint/compat</code>
								</p>,
							],
							[
								'ESLint plugins',
								<p>
									<code>eslint-plugin-react</code>, <code>-react-hooks</code>,{' '}
									<code>-jest</code>, <code>-import</code>,{' '}
									<code>-redux-saga</code>, <code>-unicorn</code>,{' '}
									<code>simple-import-sort</code>, and more
								</p>,
							],
							[
								'TypeScript',
								<p>
									<code>typescript</code>, <code>typescript-eslint</code>,{' '}
									<code>@typescript-eslint/eslint-plugin</code>,{' '}
									<code>@typescript-eslint/parser</code>
								</p>,
							],
							[
								'Prettier',
								<p>
									<code>prettier</code>, <code>eslint-config-prettier</code>
								</p>,
							],
							[
								'Testing',
								<p>
									<code>jest</code>, <code>markdownlint-cli2</code>
								</p>,
							],
							[
								'Tools',
								<p>
									<code>@san-siva/gitsy</code>,{' '}
									<code>@anthropic-ai/claude-code</code>,{' '}
									<code>local-ssl-proxy</code>, <code>neovim</code> (npm
									provider)
								</p>,
							],
							[
								'ESLint configs',
								<p>
									Symlinks <code>eslint.config.ts</code> and{' '}
									<code>eslint-utilities.ts</code> into the npm global prefix
								</p>,
							],
						]}
					/>
				</BlogSection>

				<BlogSection title="link-dotfiles">
					<p className="margin-bottom--2">
						Creates symlinks from <code>~/.config/configs/</code> into the home
						directory. Removes any existing file or broken symlink at each
						target before linking.
					</p>
					<CodeBlock
						hasMarginDown
						language="bash"
						code={`~/.config/bin/dev/setup/link-dotfiles`}
					/>
					<Table
						hasMarginDown
						headers={['Source', 'Symlinked to']}
						rows={[
							[<code>configs/.tmux.conf</code>, <code>~/.tmux.conf</code>],
							[
								<code>configs/.prettierrc.json</code>,
								<code>~/.prettierrc.json</code>,
							],
							[
								<code>configs/.eslintrc.json</code>,
								<code>~/.eslintrc.json</code>,
							],
							[<code>configs/.p10k.zsh</code>, <code>~/.p10k.zsh</code>],
							[<code>configs/.gitconfig</code>, <code>~/.gitconfig</code>],
							[
								<code>configs/.gitconfig__wrk</code>,
								<code>~/.gitconfig__wrk</code>,
							],
							[<code>configs/ssh_config</code>, <code>~/.ssh/config</code>],
							[
								<code>configs/eclipse-java-google-style.xml</code>,
								<code>~/.local/share/eclipse/</code>,
							],
							[
								<code>configs/lombok.jar</code>,
								<code>~/.local/share/eclipse/</code>,
							],
						]}
					/>
					<Callout type="warning" hasMarginDown>
						<p>
							<b>Note:</b> Existing files at the target paths will be removed
							before linking. Back up any local changes first.
						</p>
					</Callout>
				</BlogSection>
			</BlogSection>

			<BlogSection title="Neovim">
				<p className="margin-bottom--2">
					A full IDE experience built in Lua using{' '}
					<a
						href="https://github.com/folke/lazy.nvim"
						target="_blank"
						rel="noopener noreferrer"
						className={styles['a--highlighted']}
					>
						lazy.nvim
					</a>
					. Entry point is <code>nvim/init.lua</code>; leader key is{' '}
					<code>,</code>.
				</p>
				<CodeBlock
					hasMarginDown
					language="bash"
					code={CODE_EXAMPLES.nvimFolderStructure}
				/>
				<Callout type="info" hasMarginDown>
					<p>
						Set <code>NVIM_NPM=1</code> to open Neovim with all plugins disabled
						— useful when invoked inside Node.js scripts or tooling where
						startup time matters.
					</p>
				</Callout>

				<BlogSection title="Key Bindings">
					<Table
						hasMarginDown
						headers={['Binding', 'Action']}
						rows={[
							[<code>{'<C-c>'}</code>, 'Escape / cancel'],
							[<code>{'<Esc>'}</code>, 'Clear search highlight'],
							[
								<code>
									{'<leader>tl'} / {'<leader>th'}
								</code>,
								'Next / prev tab',
							],
							[
								<code>
									{'<leader>tL'} / {'<leader>tH'}
								</code>,
								'New / close tab',
							],
							[<code>{'<leader>1'}–9</code>, 'Jump to tab by number'],
							[<code>{'<leader>bb'}</code>, 'Alternate buffer'],
							[<code>{'<leader>p'}</code>, 'Copy relative path + line number'],
							[<code>{'<leader>P'}</code>, 'Copy absolute path'],
							[<code>{'<leader>l'}</code>, 'Copy line number'],
							[
								<code>
									{'<leader>e'} / {'<leader>E'}
								</code>,
								'Float diagnostic / loclist',
							],
							[
								<code>
									{'[e'} / {']e'}
								</code>,
								'Next / prev diagnostic',
							],
							[
								<code>
									{'<leader>N'} / {'<leader>n'}
								</code>,
								'Toggle relative numbers',
							],
							[<code>{'<leader>S'}</code>, 'Reload vimrc'],
							[<code>{'<leader>M'}</code>, 'Delete all marks'],
							[<code>{'<leader>ff'}</code>, 'Telescope: find files'],
							[<code>{'<leader>fg'}</code>, 'Telescope: live grep'],
							[<code>{'<leader>fb'}</code>, 'Telescope: open buffers'],
							[<code>{'<leader>fd'}</code>, 'Telescope: diagnostics'],
							[<code>{'<leader>tt'}</code>, 'Toggle file tree'],
							[<code>{'<leader>gs'}</code>, 'Git status'],
							[<code>{'<leader>gc'}</code>, 'Git commit'],
							[
								<code>
									{'<leader>gh'} / {'<leader>gl'}
								</code>,
								'Diffget ours / theirs',
							],
							[
								<code>
									{'<leader>cJ'} / {'<leader>cK'}
								</code>,
								'Open / close all folds',
							],
							[<code>{'<C-o>'}</code>, 'Supermaven: accept suggestion'],
							[<code>{'<C-y>'}</code>, 'Supermaven: accept word'],
							[<code>{'<C-r>'}</code>, 'Supermaven: dismiss'],
						]}
					/>
				</BlogSection>

				<BlogSection title="Autocommands">
					<Table
						hasMarginDown
						headers={['Event', 'Action']}
						rows={[
							[<code>TextYankPost</code>, 'Flash-highlight yanked text'],
							[
								<code>BufReadPre</code>,
								'Detect large files; set hash-based undo path for long file paths',
							],
							[
								<code>BufReadPost</code>,
								'Disable swapfile, undofile, syntax, synmaxcol, treesitter for large files',
							],
							[
								<code>BufWinEnter</code>,
								'Disable folding, cursorline, spell for large files',
							],
							[
								<>
									<code>BufReadPre</code> / <code>BufNewFile</code>
								</>,
								'Read prettier tabWidth from config and set local indentation for JS/TS files',
							],
						]}
					/>
				</BlogSection>

				<BlogSection title="Plugins">
					<Table
						hasMarginDown
						headers={['Plugin', 'Purpose']}
						rows={[
							[<code>catppuccin/nvim</code>, 'Colorscheme — Frappé flavor'],
							[
								<code>nvim-treesitter</code>,
								'Syntax highlighting + text objects',
							],
							[
								<>
									<code>nvim-lspconfig</code> + <code>mason</code>
								</>,
								'LSP server management (see Language Support)',
							],
							[<code>conform.nvim</code>, 'Format on save'],
							[
								<>
									<code>nvim-cmp</code> + <code>luasnip</code>
								</>,
								'Completion — LSP, snippets, path, dictionary',
							],
							[
								<code>telescope.nvim</code>,
								'Fuzzy finder — files, grep, buffers, diagnostics',
							],
							[<code>nvim-tree.lua</code>, 'File explorer sidebar'],
							[<code>gitsigns.nvim</code>, 'Git diff signs in gutter'],
							[<code>vim-fugitive</code>, 'Git commands inside Neovim'],
							[<code>supermaven-nvim</code>, 'AI inline completion'],
							[<code>nvim-ufo</code>, 'Code folding via LSP / treesitter'],
							[<code>lualine.nvim</code>, 'Status line + buffer tabline'],
							[<code>indent-blankline.nvim</code>, 'Indent guides'],
							[<code>nvim-colorizer.lua</code>, 'Hex/CSS color preview'],
							[
								<code>markdown-preview.nvim</code>,
								'Live browser preview with Mermaid',
							],
							[<code>nvim-jdtls</code>, 'Java LSP (Eclipse JDT)'],
							[<code>todo-comments.nvim</code>, 'TODO / FIXME highlighting'],
							[<code>Comment.nvim</code>, 'Comment toggling'],
							[<code>fidget.nvim</code>, 'LSP progress spinner'],
						]}
					/>
				</BlogSection>

				<BlogSection title="Language Support">
					<Table
						hasMarginDown
						headers={['Language', 'LSP', 'Formatter']}
						rows={[
							[
								'TypeScript / JavaScript',
								<code>ts_ls</code>,
								<code>prettier</code>,
							],
							['ESLint diagnostics', <code>eslint</code>, '—'],
							[
								'Go',
								<code>gopls</code>,
								<>
									<code>goimports</code> + <code>gofmt</code>
								</>,
							],
							[
								'Python',
								<code>basedpyright</code>,
								<>
									<code>isort</code> + <code>black</code>
								</>,
							],
							['Lua', <code>lua_ls</code>, <code>stylua</code>],
							['Bash', <code>bashls</code>, <code>shfmt</code>],
							['TailwindCSS', <code>tailwindcss</code>, '—'],
							[
								'Java',
								<code>nvim-jdtls</code>,
								<code>google-java-format</code>,
							],
							[
								'CSS / SCSS / HTML / JSON / Markdown',
								'—',
								<code>prettier</code>,
							],
							['SQL', '—', <code>sqlfmt</code>],
							['XML', '—', <code>xmllint</code>],
							['YAML', '—', <code>yamllint</code>],
						]}
					/>
					<Callout type="info" hasMarginDown>
						<p>
							<strong>Monorepo TypeScript:</strong> <code>ts_ls</code> walks up
							the directory tree to find the topmost directory containing both{' '}
							<code>tsconfig.json</code> and <code>node_modules</code> — works
							correctly in monorepos without per-project config.
						</p>
					</Callout>
				</BlogSection>
			</BlogSection>

			<BlogSection title="Terminal">
				<BlogSection title="Kitty">
					<p className="margin-bottom--2">
						Config at <code>kitty/kitty.conf</code>. Kitty is the primary
						terminal — configured for a clean, distraction-free experience with
						the full Catppuccin Frappé color scheme.
					</p>
					<Table
						hasMarginDown
						headers={['Setting', 'Value']}
						rows={[
							[
								'Font',
								<>
									<code>JetBrainsMono Nerd Font Mono</code>, 13pt
								</>,
							],
							[
								'Theme',
								<>
									Catppuccin Frappé (<code>themes/frappe.conf</code>)
								</>,
							],
							[
								'Window size',
								<>
									<code>150c × 50c</code>
								</>,
							],
							['Cursor', <code>block</code>],
							[
								'Option key',
								<>
									<code>macos_option_as_alt yes</code>
								</>,
							],
						]}
					/>
					<Callout type="info" hasMarginDown>
						<p>
							<b>Switching themes:</b> All four Catppuccin flavors are in{' '}
							<code>kitty/themes/</code> — change the <code>include</code> line
							to <code>latte.conf</code>, <code>macchiato.conf</code>, or{' '}
							<code>mocha.conf</code> to switch.
						</p>
					</Callout>
				</BlogSection>

				<BlogSection title="Tmux">
					<p className="margin-bottom--2">
						Config at <code>configs/.tmux.conf</code> (symlinked to{' '}
						<code>~/.tmux.conf</code>). Uses{' '}
						<a
							href="https://github.com/tmux-plugins/tpm"
							target="_blank"
							rel="noopener noreferrer"
							className={styles['a--highlighted']}
						>
							TPM
						</a>{' '}
						for plugin management with Catppuccin-matching status bar colors.
					</p>
					<Table
						hasMarginDown
						headers={['Setting', 'Value']}
						rows={[
							['Prefix', <code>C-a</code>],
							['Mouse', 'Enabled'],
							['History limit', <code>10000</code>],
							[
								'Pane navigation',
								<>
									<code>prefix + h/j/k/l</code> (vim-style)
								</>,
							],
							[
								'Window navigation',
								<>
									<code>prefix + i/u</code> (next/prev), <code>prefix + p</code>{' '}
									(last)
								</>,
							],
						]}
					/>
					<Table
						hasMarginDown
						headers={['Plugin', 'Purpose']}
						rows={[
							[
								<code>tmux-resurrect</code>,
								'Save and restore sessions across restarts',
							],
							[<code>tmux-yank</code>, 'Copy to system clipboard from tmux'],
						]}
					/>
				</BlogSection>
			</BlogSection>

			<BlogSection title="Git">
				<Table
					hasMarginDown
					headers={['Topic', 'Description', 'Reference']}
					rows={[
						[
							'Multi Account Setup',
							<p>
								Personal and work profiles with separate SSH keys using{' '}
								<code>includeIf</code> and SSH host aliases
							</p>,
							<a
								href="https://santhoshsiva.dev/blog/the-ultimate-guide-to-managing-multiple-git-accounts-ssh-keys/"
								target="_blank"
								rel="noopener noreferrer"
								className={styles['a--highlighted']}
							>
								Blog post
							</a>,
						],
						[
							'Gitsy',
							'Terminal UI for Git — log, diff, branch, and stash views',
							<a
								href="https://gitsy.santhoshsiva.dev/?section=overview"
								target="_blank"
								rel="noopener noreferrer"
								className={styles['a--highlighted']}
							>
								gitsy.santhoshsiva.dev
							</a>,
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Utility Scripts">
				<p className="margin-bottom--2">
					All scripts in <code>bin/</code> are on PATH and share a common
					utility library at <code>bin/utils.sh</code>.
				</p>
				<Table
					hasMarginDown
					headers={['Script', 'Category', 'Description']}
					rows={[
						[
							<code>wireless-adb {'<ip>'}</code>,
							'Android',
							'Connect to a device over WiFi',
						],
						[
							<code>adb-install {'<apk>'}</code>,
							'Android',
							'Install APK to connected device',
						],
						[
							<code>adb-reverse {'<port>'}</code>,
							'Android',
							'Reverse a port (e.g. Metro bundler)',
						],
						[
							<code>adb-uninstall {'<package>'}</code>,
							'Android',
							'Uninstall a package by name',
						],
						[
							<code>kill-port {'<port>'}</code>,
							'Dev',
							'Kill the process listening on a given port',
						],
						[
							<code>setup-ssh-agent</code>,
							'Dev',
							'Load SSH key into the running agent',
						],
						[
							<code>pwdc</code>,
							'Dev',
							'Print current working directory (clean output)',
						],
						[
							<code>reinstall-claude</code>,
							'Dev',
							'Reinstall Claude Code CLI tool',
						],
						[
							<code>reinstall-gitsy</code>,
							'Dev',
							'Reinstall the gitsy CLI tool',
						],
					]}
				/>
			</BlogSection>

			<BlogSection title="Assets">
				<p className="margin-bottom--2">
					The <code>assets/</code> directory contains static resources:
				</p>
				<Table
					hasMarginDown
					headers={['Asset', 'Description']}
					rows={[
						[<code>screenshot.png</code>, 'Environment screenshot for README'],
						[
							<code>catppuccin/</code>,
							'Catppuccin syntax highlight theme files for Zsh',
						],
						[
							<code>JetBrainsMonoPatched.zip</code>,
							'Patched JetBrainsMono with Nerd Font glyphs',
						],
					]}
				/>
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
					<br />
					<strong>Dotfiles repo:</strong>{' '}
					<a
						href="https://github.com/san-siva/dotfiles"
						target="_blank"
						rel="noopener noreferrer"
						className={styles['a--highlighted']}
					>
						https://github.com/san-siva/dotfiles
					</a>
				</p>
			</BlogSection>
		</Blog>
	);
};

export default DotfilesDocumentation;
