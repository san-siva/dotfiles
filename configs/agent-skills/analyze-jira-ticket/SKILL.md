---
name: Analyze Jira Ticket
description: Comprehensive analysis of a Jira ticket across the Nexthink WebExtension ecosystem, environment setup, and implementation planning.
user_invocable: true
---

# Task

- Analyze a specific JIRA ticket and its relationship to the broader Nexthink codebase (Extension, API, Protobufs).
- Automate the local environment setup (branches/worktrees) using internal skills.
- Generate a standardized implementation guide (`TASK-[SPACE]-[TICKET_NUMBER].md`) and output it directly to the `~/Work/TASKS/` directory.

# Context

- **Team:** Nexthink Engineering (WebExtension)
- **Base Directory:** `~/Work/`
- All Nexthink repositories are placed under the work directory `~/Work/*`

# Steps

## Information Gathering & Dependency Mapping

- Use the **Atlassian skill** to fetch the Jira ticket details.
- **Cross-Repo Check:** Determine if the ticket requires changes to `@protobufs` or `json-schema` before the extension logic can be implemented.
- Identify if the task impacts the `background-script`, `content-script`, or `popup/ui` layers of the WebExtension.

## Technical Analysis & Traceability

### Code Search

Use `ripgrep` or symbol search to find existing code related to the ticket’s functional area.

### Impact Assessment

- Check if `manifest.json` permissions need updating.
- Identify state management (Redux/Zustand) changes required.

### Diagramming

Use `mermaid-wizard/SKILL.md` to create:

- **Current State:** The existing data flow or component hierarchy.
- **Target State:** Highlight modified modules, new API contracts, or new message passing between extension parts.

## Environment Preparation

- **Branching:** Use `branch-name/SKILL.md` to generate a consistent branch name (e.g., `feat/PROJECT-123-description`).
- **Workspace:** Use `gitsy/SKILL.md` to create a dedicated worktree in the relevant repository.

> If cross-repo changes are needed, suggest creating worktrees in multiple repos.

## Documentation (TASK.md)

For **spike/research tickets** (no code changes expected), create the file as `TASK-{JIRA_TICKET_ID}.md` directly in `~/Work/` instead of a worktree.

For **implementation tickets**, create a `TASK.md` in the root of the new worktree using this enhanced template:

```md
---
name: { { TASK_TITLE } }
jira: { { JIRA_TICKET_ID } }
description: { { TASK_DESCRIPTION } }
---

# High-Level Strategy

A concise summary of the architectural approach.

# Dependency Order

1. Protobuf/Schema changes (if applicable)
2. Backend/API Mocks
3. Extension Implementation

# Diagrams

## Current Architecture

{{MERMAID_DIAGRAM_CURRENT}}

## Proposed Changes

{{MERMAID_DIAGRAM_TARGET}}

# Impact Checklist

- [ ] **Manifest Permissions:** (e.g., host permissions, storage)
- [ ] **State/Store:** (List affected slices or stores)
- [ ] **Cross-Context Messaging:** (Changes to `chrome.runtime` messaging)

# Implementation Plan

- Step 1...
- Step 2...

# Affected Files (Probable)

- `list/files/here.ts`

# Testing & QA

## Unit Tests

- Logic for...

## Playwright (Component/E2E)

- **Mocks Required:** (List network requests to intercept)
- **Test Cases:** (List new or updated scenarios)
```

# Constraints

- Always use relative paths `~/Work/...` to ensure portability.
- Ensure all Mermaid diagrams use the subgraph syntax to clearly separate repositories or extension contexts.
