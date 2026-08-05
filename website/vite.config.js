import { defineConfig } from 'vite';
import { resolve } from 'path';

// The site is served from https://simo-hue.github.io/SafeSpotter/ and published
// from the repository's /docs folder, so the build writes straight into it.
export default defineConfig({
  base: '/SafeSpotter/',
  build: {
    outDir: '../docs',
    emptyOutDir: true,
    // Keep the wordmark icon a cacheable file instead of inlining it into every page.
    assetsInlineLimit: 1024,
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        privacy: resolve(__dirname, 'privacy.html'),
        terms: resolve(__dirname, 'terms.html'),
        support: resolve(__dirname, 'support.html'),
        notFound: resolve(__dirname, '404.html')
      }
    }
  }
});
