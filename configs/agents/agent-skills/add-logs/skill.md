---
name: add-logs
description: Add console.log / print statements to code following the SAN_SIVA logging format.
user_invocable: true
---

# add-logs

Add `console.log` statements to code using the SAN_SIVA format. Always derive the file path, class name, and function name from the actual code — never guess or leave placeholders.

## Log format

For static messages:

```javascript
console.log(
	'[SAN_SIVA] f:/path/to/file.js, cl:className fn:functionName: ',
	'static text'
);
```

For dynamic variables:

```javascript
console.log('[SAN_SIVA] f:/path/to/file.js, cl:className fn:functionName: ', {
	dynamicVariableOne,
	dynamicVariableTwo,
});
```

## Rules

- **`f:`** — the file path relative to the project root (e.g. `src/components/MyComponent.ts`).
- **`cl:`** — the class name. Use `(none)` if the code is not inside a class.
- **`fn:`** — the function or method name. Use `(none)` for top-level module code.
- The prefix string always ends with `": "` (colon space) before the second argument.
- Use shorthand object syntax `{ varName }` for dynamic variables — never string interpolation.
- Place the log at the top of the function/block unless the user specifies otherwise.
- Do not add a trailing comma after the last log argument — follow the surrounding code style.
- Never mix static text and dynamic variables in the same `console.log`; use two separate calls if needed.

## Steps

1. Read the file and identify the target location (function, method, or block) the user wants to instrument.
2. Determine `f:`, `cl:`, and `fn:` from the actual code.
3. Ask the user what to log if they haven't specified — static message, specific variables, or both.
4. Insert the log statement(s) and show the diff.
