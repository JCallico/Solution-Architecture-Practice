# Jekyll & GitHub Pages Setup

This repository is configured to use Jekyll with the "Just the Docs" theme for GitHub Pages hosting.

## 🖥️ Local Development

### Prerequisites
- Ruby 3.1.0 or higher
- Bundler (install with `gem install bundler`)

### Setup & Run Locally

```bash
# Navigate to the repository
cd Solution-Architecture-Practice

# Install dependencies
bundle install

# Serve the site locally
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`

## 📝 Configuration

### Main Configuration File: `_config.yml`
- **theme**: Set to "just-the-docs"
- **title**: Site title
- **baseurl**: `/Solution-Architecture-Practice` (for GitHub Pages project site)
- **url**: `https://jcallico.github.io`

### Dependencies: `Gemfile`
- jekyll ~> 4.3.0
- github-pages (includes Jekyll and plugins)
- just-the-docs (theme)
- jekyll-seo-tag, jekyll-sitemap, jekyll-feed, jekyll-github-metadata (plugins)

## 🎨 Customization

### Custom Styles
Edit `/assets/css/style.scss` to customize the theme appearance.

### Layouts
Custom layouts are in `/_layouts/`:
- `default.html` - Default page layout

### Theme Documentation
See [Just the Docs documentation](https://just-the-docs.github.io/just-the-docs/) for more configuration options.

## 🚀 Publishing to GitHub Pages

The site automatically publishes to GitHub Pages when you push to the `main` branch.

### Verify GitHub Pages Settings
1. Go to repository Settings → Pages
2. Ensure "Source" is set to "Deploy from a branch"
3. Select "main" branch and "/" (root) folder
4. Save

The site will be available at: `https://jcallico.github.io/Solution-Architecture-Practice/`

## 📚 Documentation Structure for Jekyll

```
docs/
├── frameworks/          → Framework documentation
│   └── README.md
├── patterns/           → Architectural patterns
├── knowledge-base/     → Concept explanations
├── leadership/         → Governance and leadership
├── templates/          → Architecture templates
└── index.md           → Docs section index
index.md               → Home page
_config.yml            → Jekyll configuration
_layouts/              → Custom HTML layouts
assets/css/            → Custom styles
Gemfile                → Ruby dependencies
```

## 🔍 Features

✅ Full-text search (enabled in config)
✅ Responsive design (mobile-friendly)
✅ Dark mode support (configurable)
✅ Auto-generated table of contents
✅ Breadcrumb navigation
✅ SEO optimization (Jekyll SEO Tag plugin)
✅ Automatic sitemap generation
✅ Code highlighting with syntax support

## 🐛 Troubleshooting

### Site not appearing locally
```bash
# Clear Jekyll cache and rebuild
bundle exec jekyll clean
bundle exec jekyll serve
```

### Gems not installing
```bash
# Update gem dependencies
bundle update
```

### GitHub Pages not updating
- Wait 1-2 minutes for GitHub Actions to build
- Check "Actions" tab in repository for build status
- Verify _config.yml syntax (YAML)

## 📖 Learn More

- [Jekyll Documentation](https://jekyllrb.com/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Just the Docs Theme](https://just-the-docs.github.io/just-the-docs/)
- [Jekyll on GitHub Pages](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll)
