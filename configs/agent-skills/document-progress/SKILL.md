---
name: document-progress
description: Document progress on the current issue/task into ~/Work/TASKS. Creates the task file if it doesn't exist yet, or appends/updates it if it does.
user_invocable: true
---

# Task

Write up what has happened so far on the current task/issue as a progress record in
`~/Work/TASKS/`, so future sessions (yours or a teammate's) can pick up the thread without
re-deriving it from git history or chat scrollback.

# Context

- **Directory:** `~/Work/TASKS/` — flat directory of one markdown file per task/issue.
- **Naming:**
  - If a Jira ticket is associated with the work, use `TASK-{JIRA_TICKET_ID}.md` (e.g.
    `TASK-EXT-11342.md`). Determine the ticket ID from, in order: explicit mention in the
    conversation, the current git branch name (`TICKET_ID__title` convention — see
    `branch-name/SKILL.md`), or the current worktree/repo path.
  - If there's no Jira ticket, use a short, descriptive `PascalCase` or kebab-case filename
    relevant to the task (e.g. `TooManyPublicKeys.md`), not a generic name like `progress.md` or
    `notes.md`. Look at existing filenames in the directory for the naming style already in use.
- Two existing shapes are already in the directory:
  - An **epic/multi-subtask tracker** (e.g. `TASK-EXT-11342.md`) with a status-at-a-glance table
    plus one section per subtask.
  - A **single investigation/task log** (e.g. `TooManyPublicKeys.md`) that reads top-to-bottom as
    a narrative: context → task → investigation → conclusion → next step.
  - A **pre-work implementation plan** (e.g. `TASK-EXT-10672.md`, produced by
    `analyze-jira-ticket/SKILL.md`) that this skill turns into a progress log as work actually
    happens — don't discard the plan content, layer progress on top of it (see Steps below).

# Steps

1. **Establish what task this is.** Check the conversation for a Jira ticket ID; if absent, run
   `git branch --show-current` in the relevant repo(s) to extract one from the branch name. If
   there's genuinely no ticket, this is a non-Jira task — proceed with a descriptive filename.
2. **Check for an existing file** matching the ticket ID or a plausible descriptive name in
   `~/Work/TASKS/`. Use `ls ~/Work/TASKS/` and grep filenames/content if the exact name is
   unclear.
3. **Gather what actually happened this session** — don't just restate intentions:
   - What was implemented/changed, and where (repo, files, worktree, commit hash).
   - PR links, if any were opened.
   - What was verified and how (test suite run, lint/typecheck, manual repro) — be specific about
     commands run and their results, not just "tests pass."
   - Findings from investigation (root cause, ruled-out hypotheses, open questions).
   - Blockers, caveats, and anything discovered that changes the original plan.
   - Concrete next actions — the next session should be able to start from these without
     re-reading the whole file.
4. **Write or update the file:**
   - **New file:** use frontmatter (`name`, `jira` if applicable, `description`, and `epic`/
     `design doc` links if relevant) followed by sections matching the shape that fits the task
     (multi-subtask tracker vs. narrative log — see Context above). Model the structure and tone
     on the closest existing example in the directory rather than inventing a new layout.
   - **Existing file:** don't blindly overwrite. Read it fully first, then:
     - If it's a pre-work plan (no progress recorded yet), add progress sections (status marks,
       "Verified:" lines, findings, next actions) around the existing plan content rather than
       deleting the plan.
     - If it already has progress sections, update statuses in place (e.g. flip a subtask row
       from `⚠️ blocked` to `✅ Done`, add its PR link) and append new findings/next-actions rather
       than duplicating what's already recorded. Rewrite the "Next actions" section to reflect
       current reality — remove items that are now done, add new ones.
   - Use status emoji consistent with existing files: `✅ Done`, `⚠️` for partial/blocked, no
     emoji for not-started.
   - Prefer precise, information-dense prose over filler — every sentence should tell the next
     reader something they'd otherwise have to dig for (a commit hash, a command that was run, a
     reason a path was ruled out).
5. **Confirm the write** by stating the file path and a one-line summary of what changed in it.

# Constraints

- Never delete prior investigation/context to make room for new progress — this file is the
  institutional memory for the task. Append/update, don't erase.
- Don't fabricate verification that wasn't actually run — if something wasn't tested, say so
  explicitly (as the existing files do, e.g. "Not yet verified (needs networking-account AWS
  access)").
- Keep filenames stable once created — if a Jira ticket gets assigned to previously ticketless
  work, rename the file (`git mv`-equivalent) rather than creating a duplicate.
