# Design spec — `rules/design.md`

**Date:** 2026-06-21
**Status:** Approved for implementation planning
**Author:** brainstorming session

## Summary

Add a new rule, `rules/design.md`, to the claude-agent-kit. It defines a
reference-driven workflow for design/UI work: **brainstorm from a curated
reference set → pick the right framework → build with the ui-ux-pro-max skill +
21st.dev magic MCP.** The rule is tier **[WHEN USEFUL]** — it activates only when
the task is visual/experiential and otherwise stays out of the way.

## Motivation

The kit has an `accessibility.md` rule for UI correctness but nothing on
*aesthetic* quality or a design-build workflow. Without guidance, design work
starts from a blank page and converges on a generic "AI default" look. This rule
forces reference-driven design and names a concrete, installed toolchain.

## Scope

In scope:
- New file `rules/design.md` ([WHEN USEFUL]), house format matching
  `accessibility.md` (tier header → scoped sections → "Why this rule exists").
- One index line in `system-prompt.md`'s rule index.
- One tree entry in `README.md`'s "What's in the box" file map.

Out of scope (YAGNI for now):
- Hook changes (`hooks/guardrails.sh`) — nothing to enforce deterministically.
- A `tests/` rubric — can be added later if the rule proves load-bearing.
- Per-stack overlays under `rules/_stacks/`.

## Activation / scope guard

The rule applies when the work is visual or experiential: new UI, a landing
page, a redesign, motion/3D, or an explicit "make this look good." It explicitly
defers to:
- `accessibility.md` — every design must still clear the WCAG AA bar.
- `style.md` — minimal-diff and change-scope discipline still hold.

It does **not** fire on routine non-visual tasks.

## The three-phase workflow

### Phase 1 — Brainstorm from references (never design from a blank page)

Pull direction from the curated set below before writing any code. Output of the
phase is a short **art-direction note**: 3–5 references plus the specific thing
taken from each.

Curated reference set — **5 categories, 5 best picks in each (25 total)**:

1. **Product flows & real UI**
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

**Hard rule:** adding any inspiration source beyond these 25 requires asking the
user first. This instruction lives inside the rule file itself.

### Phase 2 — Pick the framework to the job

Default base layer, then reach for motion/3D only when the design calls for it.
Do not reach for three.js when CSS will do.

- **Tailwind + shadcn/ui** — default base layer (styling + accessible Radix
  primitives). What the magic MCP and ui-ux-pro-max skill both build on.
- **GSAP** — timeline / scroll-driven animation.
- **Framer Motion (motion)** — React component animation.
- **three.js + React Three Fiber (+ drei)** — 3D / WebGL.
- **Lottie** — designer-authored vector animation (pairs with LottieFiles).
- **Spline** — no-code 3D scenes exported to web.

Motion must respect `prefers-reduced-motion` (ties back to `accessibility.md`).

### Phase 3 — Build with the toolchain

- **`ui-ux-pro-max` skill** — planning, structure, UX patterns. Confirmed
  installed in-session.
- **21st.dev magic MCP** — component generation and refinement. Tools:
  `21st_magic_component_builder`, `21st_magic_component_inspiration`,
  `21st_magic_component_refiner`, `logo_search`. Confirmed wired in-session.

Before invoking either, verify it is installed (per the kit's ECOSYSTEM.md
discipline: never fabricate a capability you can't observe).

## "Why this rule exists" (receipt block)

Concrete violation → blank-page design → generic AI aesthetic → ships → product
looks templated and undifferentiated.

Compliant alternative → reference-driven art-direction note → framework matched
to the job → built with the named toolchain → distinctive, intentional UI.

What ships without the rule → competent-but-generic interfaces that no reference
informed and no one remembers.

## Integration points

- `system-prompt.md` — add one line to the rule index under the [WHEN USEFUL]
  tier, next to `accessibility.md`.
- `README.md` — add `design.md  [WHEN USEFUL]  Reference-driven design workflow`
  to the file tree.
- No other files change.

## Acceptance criteria

- `rules/design.md` exists, [WHEN USEFUL], matches `accessibility.md` format,
  ends with a "Why this rule exists" block.
- Contains the 5-category / 25-source reference list (5 per category) and the
  "ask before adding" instruction.
- Names the Phase-2 frameworks and the Phase-3 toolchain.
- Indexed in `system-prompt.md` and listed in `README.md`.
- No changes to hooks or tests.
