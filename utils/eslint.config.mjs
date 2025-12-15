import reactPlugin from 'eslint-plugin-react';
import tseslint from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';
import prettierPlugin from 'eslint-plugin-prettier';
import prettierConfig from 'eslint-config-prettier';
import globals from 'globals';

export default [
	js.configs.recommended,
	{
		plugins: {
			prettier: prettierPlugin,
		},
		rules: {
			...prettierPlugin.configs.recommended.rules,
			...prettierConfig.rules,
		},
	},
	{
		files: ['**/*.ts', '**/*.tsx', '**/*.js', '**/*.jsx'],
		languageOptions: {
			parser: tsParser,
			ecmaVersion: 2022,
			sourceType: 'module',
			parserOptions: {
				ecmaFeatures: { jsx: true },
			},
			globals: {
				...globals.browser,
				// ...globals.node,
			},
		},
		plugins: {
			'@typescript-eslint': tseslint,
			react: reactPlugin,
		},
		rules: {
			...tseslint.configs.recommended.rules,
			...reactPlugin.configs.recommended.rules,
			'no-console': 'warn',
			'no-nested-ternary': 'off',
			'max-len': ['warn', 120],
			'no-lonely-if': 'error',
			'prefer-const': 'error',
			'no-param-reassign': 'error',
			'prefer-destructuring': 'error',
			'prefer-template': 'error',
			'no-unused-vars': 'warn',
			'@typescript-eslint/no-unused-vars': 'warn',
			'class-methods-use-this': 'error',
			'no-underscore-dangle': 'error',
			'no-warning-comments': 'error',
			'no-delete-var': 'error',
			'linebreak-style': ['off', 'unix'],
			'operator-linebreak': [
				'warn',
				'after',
				{
					overrides: {
						'?': 'ignore',
						':': 'ignore',
					},
				},
			],
			'comma-dangle': ['off', 'never'],
			'no-trailing-spaces': [
				'warn',
				{
					skipBlankLines: true,
				},
			],
			'no-undef': 'error',
			'prefer-arrow-callback': 'error',
			'arrow-parens': ['warn', 'as-needed'],
			'no-invalid-regexp': 'error',
			'no-irregular-whitespace': 'warn',
			'no-prototype-builtins': 'error',
			'react/react-in-jsx-scope': 'off',
			'@typescript-eslint/no-explicit-any': 'warn',
		},
		settings: {
			react: {
				version: 'detect',
			},
		},
	},
];
