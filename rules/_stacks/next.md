# Stack Overlay: Next.js

**Tier:** inherits from the rule it extends. Load in addition to `typescript.md` when the working directory has `next.config.{js,mjs,ts}` or an `app/`/`pages/` directory.

## Routing and rendering

- `app/` router (App Router) for new code. `pages/` is legacy; only touch if the project is committed to it.
- **Server Components are the default.** Add `"use client"` only when the component needs state, effects, browser APIs, event handlers, or a client-only library. Push the `"use client"` boundary as far down the tree as possible.
- Data fetching belongs in Server Components or Route Handlers, not in `useEffect`. `useEffect` for data is almost always wrong in App Router.

## Data and caching

- `cache()` for request-scoped memoization of an async function.
- `revalidatePath(path)` / `revalidateTag(tag)` for explicit invalidation after a mutation. Don't rely on the default cache for anything user-specific.
- `fetch(url, { next: { revalidate: N } })` to tune at the call site; `{ cache: "no-store" }` for per-request fresh.
- Cookies and headers: `cookies()` / `headers()` from `next/headers` in Server Components. Reading either opts the route into dynamic rendering.

## Mutations

- Server Actions for form-driven mutations. Pair with `useFormStatus` / `useActionState` for progressive enhancement.
- Route Handlers (`app/api/.../route.ts`) for non-form mutations, webhooks, and JSON APIs consumed by clients you don't own.
- Always revalidate after a mutation. The most common Next bug is a successful mutation followed by a stale read.

## Auth

- Don't put real auth in `middleware.ts`. Middleware runs on the Edge and has limited APIs; use it only for lightweight redirects and rewrites. Real auth lives in a Server Component, Route Handler, or Server Action that reads the session.
- Session cookie: HTTP-only, Secure, SameSite=Lax (or Strict where it works).
- CSRF protection: Server Actions get it via Next's built-in token; custom Route Handlers need their own.

## Images and assets

- `next/image` with explicit `width` and `height` (or `fill` + a sized parent). Never `<img>` for layout-significant images.
- Static assets in `public/`; imported assets in `app/` or `components/` get hashed and optimized.

## Env vars

- `NEXT_PUBLIC_*` is the only prefix that ships to the client. Anything secret must not start with `NEXT_PUBLIC_`.
- Validate env at boot with a schema (`zod` is conventional). Crash on missing required vars; do not default to empty string.

## Performance

- `loading.tsx` for streaming UI; pair with `Suspense` boundaries inside the page.
- `dynamic(() => import(...), { ssr: false })` for client-only widgets that don't need SSR.
- Avoid client-side data libraries (SWR, React Query) in App Router unless you've justified the client boundary; Server Components + revalidation cover most cases.

## Pitfalls

- Importing server-only modules into Client Components leaks the code (and any secret) to the bundle. Use `server-only` package as a tripwire on sensitive modules.
- Adding `"use client"` to a layout makes the entire subtree client. Split instead of co-locating.
- `redirect()` from `next/navigation` throws; don't catch it.
