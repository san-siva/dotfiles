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
# For Adopt V1
npm run package:component-test:chrome:beta

# For Adopt V2 (Default unless specified)
npm run package:component-test:chrome:beta:shared-store
```

## 2. Set up environment variables

Create a `.env` file at `tests/adopt-tests/component-tests/.env`:

```txt
Browser=chromium # chrome, edge or chromium
ExtensionType=beta # beta or prod
LogLevel=debug # debug, info, warn, error, silent
ExtensionPath=/path/to/extension/dist/chrome
AppExExtensionPath=/path/to/extension/dist/chrome

WORKDAY_USER=bharper
WORKDAY_PASS=Welcome2019%

DAPDEV_USER=autouser
DAPDEV_PASS=nuY7k%B28ezwsFYwf4h^v

# Required for localhost tenant login (Global.loginAsAdmin → infinity-helpers.getInfinityCredentials)
# Missing/blank values cause: "locator.fill: value: expected string, got undefined"
USEAST2MAIN_USER=san_siva
USEAST2MAIN_PASS=tycnuw-kobxeQ-gopge7
```

## 3. Run Playwright tests

```sh
cd tests/adopt-tests/component-tests

npx playwright test -c './configuration/settings/playwright.config.ts' 'tests/adopt-tests/component-tests/tests/**/*.test.ts'
```
