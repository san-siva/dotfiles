---
name: component-tests
description: Guide for building and running Playwright component tests in the appex-adopt.extension repo.
user_invocable: true
---

# component-tests

Steps to build and run Playwright component tests. This only applies to the `/Users/santhosh.siva/Work/appex-adopt.extension` repo.

> You do not need to start any services manually. Playwright will automatically spin up the web server and handle other required dependencies.

## 1. Build for Playwright

```sh
# For Adopt V1 and AppEx tests
npm run package:component-test:chrome:beta

# For Adopt V2 (Default unless specified)
npm run package:component-test:chrome:beta:shared-store
```

> [!IMPORTANT]
>
> AppEx tests (`tests/appex-*`, tagged `@appex`) require `npm run package:component-test:chrome:beta`. Do not use the `shared-store` build for them.

## 2. Set up environment variables

Test account credentials live in `~/.zshrc` (never in this repo) as `WORKDAY_USER`, `WORKDAY_PASS`, `DAPDEV_USER`, `DAPDEV_PASS`, `USEAST2MAIN_USER`, and `USEAST2MAIN_PASS`. Generate `tests/adopt-tests/component-tests/.env` from them — the unquoted heredoc expands the shell variables:

```sh
cat > tests/adopt-tests/component-tests/.env <<EOF
Browser=chromium # chrome, edge or chromium
ExtensionType=beta # beta or prod
LogLevel=debug # debug, info, warn, error, silent
ExtensionPath=/path/to/extension/dist/chrome
AppExExtensionPath=/path/to/extension/dist/chrome

WORKDAY_USER=$WORKDAY_USER
WORKDAY_PASS=$WORKDAY_PASS

DAPDEV_USER=$DAPDEV_USER
DAPDEV_PASS=$DAPDEV_PASS

# Required for localhost tenant login (Global.loginAsAdmin → infinity-helpers.getInfinityCredentials)
# Missing/blank values cause: "locator.fill: value: expected string, got undefined"
USEAST2MAIN_USER=$USEAST2MAIN_USER
USEAST2MAIN_PASS=$USEAST2MAIN_PASS
EOF
```

> [!WARNING]
>
> If any of these variables are unset, the generated `.env` will contain blank values. Check with `env | grep -E 'WORKDAY|DAPDEV|USEAST2MAIN' | cut -d= -f1` before running.

## 3. Run Playwright tests

```sh
cd tests/adopt-tests/component-tests

npx playwright test -c './configuration/settings/playwright.config.ts' 'tests/adopt-tests/component-tests/tests/**/*.test.ts'
```
