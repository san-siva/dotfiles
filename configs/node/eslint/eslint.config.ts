import tseslint from 'typescript-eslint';

import {
    reactExtends,
    reactPlugins,
    reactRules,
    reactSettings,
    languageOptions,
    testFiles,
    defaultRules,
    defaultSettings,
} from './eslint-utilities.js';

export default tseslint.config(
    {
        ignores: [
            'node_modules/**',
            'package-lock.json',
            'dist/**',
            'build/**',
            '**/__mocks__/**',
            '**/__test__/**',
            '**/__tests__/**',
            'coverage/**',
            '*.min.js',
            '*.min.css',
            '*.map',
            '**/*.d.ts',
        ],
    },
    {
        files: ['**/*.ts', '**/*.tsx', '**/*.js', '**/*.jsx'],
        ignores: testFiles,
        plugins: reactPlugins,
        extends: reactExtends,
        settings: reactSettings,
        rules: reactRules,
        languageOptions,
    },
    {
        files: testFiles,
        plugins: reactPlugins,
        extends: reactExtends,
        settings: defaultSettings,
        rules: {
            ...defaultRules,
            'jest/no-disabled-tests': 'warn',
            'jest/no-focused-tests': 'error',
            'jest/no-identical-title': 'error',
            'jest/prefer-to-have-length': 'warn',
            'jest/valid-expect': 'error',
        },
        languageOptions,
    }
);
