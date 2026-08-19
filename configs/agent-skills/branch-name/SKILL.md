---
name: branch-name
description: Suggest a git branch name for a given Jira ticket.
user_invocable: true
---

# Task

Suggest a branch name for a Jira ticket following Nexthink's convention.

# Context

```
TICKET_NUMBER__short-title
```

- Double underscore between ticket ID and title.
- Title is lowercase, hyphen-separated (kebab-case).
- Title should be short (3–5 words max), derived from the ticket summary.
- Strip noise words (a, the, for, with, in, of, to) unless they meaningfully change intent.

# Steps

1. If a ticket ID is provided (e.g. `EXT-1234`), fetch the ticket summary via the Atlassian skill (Jira REST API).
2. Derive a short kebab-case title from the summary.
3. Compose the branch name: `TICKET_ID__kebab-title`.
4. Present the suggested branch name in a code block.
5. If the summary is ambiguous, offer up to two alternatives with a brief note on the trade-off.

# Examples

| Ticket summary                               | Branch name                                  |
| -------------------------------------------- | -------------------------------------------- |
| Add JWT authentication for user login        | `EXT-1234__add-jwt-authentication`           |
| Fix session expiration issue on logout       | `EXT-5678__fix-session-expiration-on-logout` |
| Refactor file structure for modularity       | `EXT-9012__refactor-file-structure`          |
| Use relative timestamps in the activity feed | `EXT-6372__use-relative-timestamps`          |
