# Gitsy Documentation Website

Documentation website for gitsy built with Next.js, React, and the blogkit component library.

## Tech Stack

- **Next.js 16** - React framework with App Router
- **TypeScript** - Type safety
- **Blogkit** - Documentation component library
- **Stylekit** - Design system and styling
- **SCSS Modules** - Component-scoped styling
- **React 19** - Latest React features

## Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Run development server:**
   ```bash
   npm run dev
   ```

3. **Open [http://localhost:3000](http://localhost:3000)** in your browser

## Available Scripts

- `npm run dev` - Start development server with Turbo mode
- `npm run build` - Build for production (static export)
- `npm start` - Start production server
- `npm run lint` - Run ESLint

## Project Structure

```
website/
├── app/
│   ├── layout.tsx          # Root layout with fonts
│   ├── page.tsx            # Documentation page
│   └── page.module.scss    # Page styles
├── public/
│   └── .nojekyll           # GitHub Pages compatibility
├── package.json
├── tsconfig.json
├── next.config.ts
└── README.md
```

## Features

- **Static Export** - Generates static HTML for easy deployment
- **Responsive Design** - Mobile-friendly with sidebar navigation
- **Syntax Highlighting** - Code blocks with copy functionality
- **Interactive Components** - Callouts, tables, and link cards
- **Table of Contents** - Automatic sidebar navigation

## Deployment

The site is configured for static export. Build and deploy to any static hosting:

```bash
npm run build
```

The output will be in the `out/` directory.

### GitHub Pages

1. Push the `out/` directory to the `gh-pages` branch
2. Enable GitHub Pages in repository settings
3. The `.nojekyll` file ensures proper asset loading

### Firebase Hosting

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

## Customization

### Fonts

Configured in `app/layout.tsx`:
- Montserrat (UI elements)
- Rubik (body text)
- JetBrains Mono (code blocks)

### Styling

Uses Stylekit design tokens:
- Colors, spacing, typography in `stylekit`
- Component styles in `*.module.scss` files
- Global styles imported in `layout.tsx`

### Content

Edit `app/page.tsx` to modify documentation content. Uses blogkit components:
- `Blog` - Main container with TOC
- `BlogSection` - Hierarchical sections
- `CodeBlock` - Syntax-highlighted code
- `Callout` - Info/warning/error boxes
- `Table` - Data tables
- `BlogLink` - Animated link cards

## License

MIT License - Same as gitsy
