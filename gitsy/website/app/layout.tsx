import type { Metadata } from 'next';
import { Montserrat, Rubik, JetBrains_Mono } from 'next/font/google';

import '@san-siva/stylekit/globals.scss';
import styles from '@san-siva/stylekit/index.module.scss';

const montserrat = Montserrat({
	weight: ['400', '500', '600', '700', '800'],
	subsets: ['latin'],
	variable: '--font-montserrat',
});

const rubik = Rubik({
	weight: ['300', '400', '500', '600', '700', '800', '900'],
	subsets: ['latin'],
	variable: '--font-rubik',
});

const jetbrainsMono = JetBrains_Mono({
	weight: ['400', '500', '600', '700'],
	subsets: ['latin'],
	variable: '--font-jetbrains-mono',
});

export const metadata: Metadata = {
	title: 'Gitsy - Git Workflow Automation',
	description:
		'Versatile bash utilities for managing Git repositories with ease',
};

export default function RootLayout({
	children,
}: Readonly<{
	children: React.ReactNode;
}>) {
	return (
		<html lang="en">
			<body
				className={`${montserrat.variable} ${rubik.variable} ${jetbrainsMono.variable}`}
			>
				<div className={`${styles.page} ${styles['page--contents-max-width']}`}>
					{children}
				</div>
			</body>
		</html>
	);
}
