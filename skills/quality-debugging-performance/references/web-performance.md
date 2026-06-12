# Web Performance Reference

<!-- ported from mercure-plugin/skills/quality-debugging-performance/ -->

Core Web Vitals targets and frontend optimization techniques.

## Core Web Vitals

### LCP (Largest Contentful Paint) — Target: < 2.5s

```html
<link rel="preload" as="image" href="/hero.webp" fetchpriority="high" />
<img src="hero-800.webp"
  srcset="hero-400.webp 400w, hero-800.webp 800w, hero-1200.webp 1200w"
  sizes="(max-width: 600px) 400px, 800px"
  fetchpriority="high" decoding="async" alt="Hero" />
```

Key optimizations: preload LCP element, use `fetchpriority="high"`, eliminate render-blocking CSS/JS, SSR above-the-fold content.

### INP (Interaction to Next Paint) — Target: < 200ms

```typescript
// Break up long tasks to avoid blocking main thread
button.addEventListener('click', async () => {
  updateUI();  // Immediate visual feedback
  for (const chunk of chunks(data, 100)) {
    await scheduler.yield();
    processChunk(chunk);
  }
});
```

### CLS (Cumulative Layout Shift) — Target: < 0.1

```css
img, video { width: 100%; height: auto; aspect-ratio: 16 / 9; }
.ad-slot { min-height: 250px; }
/* Use transform/opacity instead of layout-triggering properties */
.animate { transform: translateY(10px); opacity: 0.8; }
```

## Code Splitting

```typescript
// Route-based splitting (React)
const Dashboard = React.lazy(() => import('./Dashboard'));

function App() {
  return (
    <Suspense fallback={<Spinner />}>
      <Routes>
        <Route path="/dashboard" element={<Dashboard />} />
      </Routes>
    </Suspense>
  );
}
```

## Bundle Optimization

```typescript
// Tree shaking: import specific functions
import debounce from 'lodash/debounce';  // NOT: import _ from 'lodash'

// Vite manual chunks
export default defineConfig({
  build: {
    rollupOptions: {
      output: { manualChunks: { vendor: ['react', 'react-dom'], charts: ['d3'] } }
    }
  }
});
```

## Image Optimization

| Format | Use Case | Support |
|--------|----------|---------|
| WebP | Photos, general | All modern |
| AVIF | Photos (better compression) | Chrome, Firefox |
| SVG | Icons, logos | All |

```html
<picture>
  <source srcset="photo.avif" type="image/avif" />
  <source srcset="photo.webp" type="image/webp" />
  <img src="photo.jpg" alt="Photo" loading="lazy" />
</picture>
```

## Resource Hints

```html
<link rel="dns-prefetch" href="//api.example.com" />
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin />
<link rel="prefetch" href="/next-page.js" />
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin />
```

## Font Optimization

```css
@font-face {
  font-family: 'CustomFont';
  src: url('/fonts/custom.woff2') format('woff2');
  font-display: swap;
  unicode-range: U+0000-00FF;
}
```

## Performance Budget

| Resource | Budget |
|----------|--------|
| Total JS (compressed) | < 200 KB |
| Total CSS (compressed) | < 50 KB |
| LCP image | < 100 KB |
| Total page weight | < 1 MB |

## Common Pitfalls

- **Unoptimized images**: Automate with build pipeline
- **Render-blocking resources**: Defer non-critical JS, inline critical CSS
- **Third-party scripts**: Audit with Lighthouse; load async
- **Layout thrashing**: Batch DOM reads before writes
