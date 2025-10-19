# UI Directory

This directory contains user interface projects including Chrome extensions and web applications.

## Structure

Each UI project should be added as a Git submodule and follow modern frontend development practices.

## Current Projects

- **listicle-extension**: Chrome browser extension for list management
  - Repository: https://github.com/akeemphilbert/listicle-extension
  - Technology: JavaScript/TypeScript, Chrome Extension APIs

## Adding New UI Projects

Use the Makefile command to add new UI projects:

```bash
make add-ui-submodule URL=https://github.com/your-org/ui-project-name NAME=project-name
```

## Planned Projects

- **web-app**: React/Vue.js web application
- **mobile-app**: React Native mobile application
- **admin-dashboard**: Administrative interface

## Development Guidelines

Each UI project should follow these conventions:

1. **Modern JavaScript/TypeScript** with proper type safety
2. **Component-based architecture** (React/Vue.js)
3. **Responsive design** with mobile-first approach
4. **Accessibility compliance** (WCAG guidelines)
5. **Performance optimization** (code splitting, lazy loading)
6. **Comprehensive testing** (unit, integration, e2e)
7. **Build optimization** (minification, bundling)

## Development

```bash
# Start UI development server
make dev-ui

# Start specific project
cd ui/project-name
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

## Chrome Extension Specific

For Chrome extensions, ensure:
- Proper manifest.json configuration
- Content Security Policy compliance
- Background script optimization
- Content script isolation
- Proper permission handling
- Extension store compliance

## Web App Specific

For web applications, ensure:
- Progressive Web App (PWA) capabilities
- Service worker implementation
- Offline functionality
- SEO optimization
- Performance monitoring
