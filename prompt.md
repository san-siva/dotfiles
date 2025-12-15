I want to make `~/.config` repo public, so that it can be used by others.

Preparing repo to be public:
- Make sure there is no sensitive information in the repo.
- Make sure `.gitignore` is updated to not allow any `dirs`.
- Make sure `.gitignore` is updated to allow non-hidden files.
- Add a `LICENSE` file, with the same license as gitsy.

Updating `bin` scripts:
- Update `bin/*` repos to be structured similar to `gitsy`. (i.e, we should have a `main` function)
- Create a utils.sh file in `bin/utils.sh` and move all the relevant utils from `gitsy/utils` to it. Make sure to ignore git related utils.
- Update all `bin/*` repos to use the new utils.sh file. All scripts needs to print a banner, `Sankit`.

Organizing the repo:
- Create assets dir, and move all static assets there like `JetBrainsMonoPatched.zip`, `catppuccin_frappe-zsh-syntax-highlighting.zsh`, `catppuccin_macchiato-zsh-syntax-highlighting.zsh`, `catppuccin_mocha-zsh-syntax-highlighting.zsh` etc.
- Create a `configs` dir, and move all the configs there like `.vimrc`, `.zshrc`, `.p10k.zsh`, `.tmux.conf`, `.prettierrc.json`, `.eslintrc.json`, etc..
- Remove `nvim_old_09-jan-23.zip` I don't think we need it.
- Remove `windows_terminal` dir, since we don't need to support only MacOS.

Updating configurations:
- Copy `prettier`, `eslint` and `typescript` configurations from `/Users/santhosh.siva/Documents/NextThink/appex-adopt.extension/main/` dir.
- Copy and make it generic.
- The generic configurations should be in `configs` dir.
- Make sure to copy `/Users/santhosh.siva/Documents/NextThink/appex-adopt.extension/main/eslint/utilities.ts` and assume we might be in a react environment. That way if we open any .ts file we can be sure the basics (jest, react, ts supports are covered).
- Update `bin/dev/setup/link-dotfiles`.
- Update `bin/android/*` to be structured similar to `gitsy`. (all scripts should have a `main` function, and should print a banner called `Sankit`).
- Update `bin/setup/*` to be structured similar to `gitsy`. (all scripts should have a `main` function, we don't have to print banners, but echo "Sankit", since we assume we dont have configurations until this script is run).
