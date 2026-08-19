---
name: commit-and-push
description: Suggest multiple commit message options, prompt the user to pick one, then commit and push.
user_invocable: true
---

# commit-and-push

Generate commit message options for the staged changes, let the user pick one, then commit and push.

## Steps

1. Follow all steps from the **commit-message** skill to gather context (staged diff, log, branch name, ticket ID).

2. Compose **3 distinct commit message options**:
   - **Option 1** — most concise (subject line only, no body).
   - **Option 2** — standard preferred format (subject + short body when helpful).
   - **Option 3** — descriptive (subject + short body explaining _why_).
   - All three must follow the Nexthink Conventional Commits rules.
   - **Always use the Jira ticket ID as the scope** when found in the branch name (e.g. `refactor(EXT-9348): ...`). Do NOT use `Refs:` trailers — put the ticket in the scope instead.

3. Present the options clearly, numbered 1–3, each in its own fenced code block.

4. **If the user passed an option as args (e.g. `use 3`, `3`, `use 1`), skip asking and go straight to step 6 with that option.** If no args were given, ask:

   > Which option would you like to use? (1 / 2 / 3, or paste a custom message)

5. Wait for the user's reply (only if step 4 required asking).

6. Once the option is determined (or the user provides a custom message), run:

   ```bash
   git commit -m "$(cat <<'EOF'
   <chosen message>
   EOF
   )"
   ```

   Use a HEREDOC to preserve multi-line messages exactly.

7. After a successful commit, run:

   ```bash
   g-push
   ```

   If `g-push` is not available, fall back to `git push`.

8. Confirm success by showing the output of `git log --oneline -1` and the push result.

## Notes

- Do **not** commit or push before the user confirms their choice.
- If there are no staged changes, tell the user and stop.
- If the push fails (e.g. no upstream), suggest running `git push --set-upstream origin <branch>` and ask for confirmation before executing.
