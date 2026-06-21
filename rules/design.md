# Rule: Design

**Tier:** [WHEN USEFUL] — applies when the task is visual or experiential: new
UI, a landing page, a redesign, motion/3D, or an explicit "make this look good."
For shipped, user-facing product, [DEFAULT].

Good design isn't a coat of paint at the end. It's a decision made before the
first line of markup: what does this look and feel like, and what real-world
references prove it can work. This rule defers to `accessibility.md` (every
design must clear WCAG AA) and `style.md` (minimal-diff discipline still holds).

## The workflow: brainstorm → framework → build

### Phase 1 — Brainstorm from references (never design from a blank page)

Before writing code, pull direction from the curated set below. A blank page
converges on the generic "AI default" look; references make design distinctive
and intentional.

**Output of this phase:** a short *art-direction note* — 3–5 references plus the
specific thing taken from each (a layout, a motion idea, a type pairing, a color
move). Show it before building.

**Curated reference set — 5 categories, 5 best picks each (25 total):**

1. **Product flows & real UI** — how real apps actually work
   - Mobbin — real iOS/Android/web flows (onboarding, paywalls, settings)
   - Pageflows — recorded video walkthroughs of real product flows
   - Refero — real app screens, filterable by pattern
   - UI Sources — flows + screens library
   - Screenlane — UI patterns + web/email design updates
2. **Award-tier web & landing**
   - Awwwards — award-tier web benchmark
   - Godly — curated cutting-edge web design
   - Land-book — landing-page gallery
   - SiteInspire — minimal, well-curated web showcase
   - Lapa Ninja — landing-page gallery + design resources
3. **Concept, brand & visual shots**
   - Behance — concept, branding, full case studies
   - Dribbble — component-level visual shots
   - Pinterest — broad visual moodboarding
   - Muzli — daily design inspiration feed
   - Designspiration — searchable visual/color discovery
4. **Art direction / moodboarding**
   - Savee — designer moodboarding tool
   - Cosmos — visual discovery + boards
   - Are.na — research-grade visual boards
   - Milanote — moodboard + planning canvas
   - Eagle — local asset / moodboard manager
5. **Motion & 3D**
   - LottieFiles — designer-authored vector animation
   - Codrops — buildable interaction & animation demos
   - three.js examples — official WebGL/3D reference gallery
   - Spline community — no-code 3D scenes exported to web
   - The FWA — experimental / interactive cutting-edge work

**Hard rule: adding any inspiration source beyond these 25 requires asking the
user first.** Don't silently introduce a new site.

### Phase 2 — Pick the framework to the job

Start from the default base layer; reach for motion or 3D only when the design
calls for it. Don't reach for three.js when CSS will do.

- **Tailwind + shadcn/ui** — default base layer (styling + accessible Radix
  primitives). What the build toolchain below assumes.
- **GSAP** — timeline / scroll-driven animation.
- **Framer Motion (motion)** — React component animation.
- **three.js + React Three Fiber (+ drei)** — 3D / WebGL.
- **Lottie** — designer-authored vector animation (pairs with LottieFiles).
- **Spline** — no-code 3D scenes exported to web.

All motion must respect `prefers-reduced-motion` — see `accessibility.md`.

### Phase 3 — Build with the toolchain

- **`ui-ux-pro-max` skill** — planning, structure, and UX patterns.
- **21st.dev magic MCP** — component generation and refinement:
  `21st_magic_component_builder`, `21st_magic_component_inspiration`,
  `21st_magic_component_refiner`, `logo_search`.

Before invoking either, verify it is installed (per `ECOSYSTEM.md`: never
fabricate a capability you can't observe).

## Why this rule exists

**Violation:** design starts from a blank page → the output converges on the
generic AI aesthetic (centered hero, three feature cards, the same gradient) →
it ships → the product looks templated and undifferentiated, and no one
remembers it.

**Compliant:** a reference-driven art-direction note grounds the work →
framework matched to the job (not three.js for a static page) → built with the
ui-ux-pro-max skill and magic MCP → distinctive, intentional UI that clears the
accessibility bar.

**What ships without this rule:** competent-but-forgettable interfaces that no
reference informed and that look like every other AI-built site.

## Sources

- The 25-reference set above (5 categories × 5)
- `ui-ux-pro-max` skill (nextlevelbuilder/ui-ux-pro-max-skill)
- 21st.dev magic MCP
