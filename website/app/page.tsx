import type { NextPage } from 'next';
import path from 'path';

import { BlogPost } from '@san-siva/blogkit-md';

const DotfilesDocumentation: NextPage = () => {
	return (
		<BlogPost
			filePath={path.join(process.cwd(), '../README.md')}
			jsonLd={{
				'@context': 'https://schema.org',
				'@type': 'BlogPosting',
				headline: 'dotfiles',
				description:
					'Personal macOS development environment — Neovim, terminal, shell, and tooling configuration.',
				author: { '@type': 'Person', name: 'Santhosh Siva' },
			}}
		/>
	);
};

export default DotfilesDocumentation;
