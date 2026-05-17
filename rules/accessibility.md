# Rule: Accessibility

**Tier:** [WHEN USEFUL] — applies to any UI change. For shipped product, [DEFAULT].

Accessibility isn't a separate "a11y pass" at the end. It's a property of the markup you write the first time. WCAG 2.1 AA is the standard most teams (and many jurisdictions) require.

## Minimum bar for any UI change

- [ ] Semantic HTML — use the element that means what the thing is. `<button>` for buttons, `<a href>` for links, `<label>` paired with inputs, `<nav>` / `<main>` / `<header>` / `<footer>` for landmarks.
- [ ] Keyboard navigable — every interactive element reachable with Tab, activatable with Enter/Space, dismissible with Esc.
- [ ] Visible focus state — never `outline: none` without a replacement.
- [ ] Color contrast ≥ 4.5:1 for normal text, 3:1 for large text and UI components (WCAG AA).
- [ ] Color is never the only signal — pair with text, icon, or pattern (color-blind users, grayscale prints).
- [ ] Images have meaningful `alt` text (or `alt=""` for decorative).
- [ ] Forms: every input has a `<label>` (visible or `aria-label`); errors announced (`aria-live`) and tied to the field (`aria-describedby`).
- [ ] Headings in order — `<h1>` once per page, no skipping levels for styling.

## ARIA — use sparingly

- The first rule of ARIA: don't use ARIA. Use the native element.
- The second rule: if you must use ARIA, use the smallest amount that does the job.
- Never override the native role of an element (`role="button"` on a `<div>` is a smell — use `<button>`).
- Test what ARIA actually announces. ARIA can lie if used wrong — worse than no ARIA at all.

## Keyboard

- Tab order matches visual order. If it doesn't, fix the DOM order; `tabindex` > 0 is almost always wrong.
- Custom interactive widgets follow the WAI-ARIA Authoring Practices pattern for that widget (menu, combobox, dialog, etc.). Don't invent your own keyboard semantics.
- Dialogs trap focus while open, restore focus on close.

## Screen readers

- Test with a real screen reader at least once per significant UI change. VoiceOver (Mac/iOS), NVDA (Windows, free), TalkBack (Android), Orca (Linux).
- Don't rely on visual layout for meaning. The screen reader reads DOM order + ARIA semantics.
- Hidden text matters: `display: none` and `visibility: hidden` are not read; `aria-hidden="true"` removes from the accessibility tree; `.sr-only` (off-screen) IS read.

## Motion & sensory

- Respect `prefers-reduced-motion`. Disable or tone down animations.
- No content flashes more than 3 times per second (seizure risk).
- Don't use sound, motion, or color as the only way to convey state.

## Common quick wins

- `<button type="button">` instead of `<div onClick>`.
- Real `<a href>` instead of `<span onClick>` (lets users middle-click, copy link, etc.).
- `<label htmlFor>` instead of placeholder-as-label.
- Skip-to-content link as the first focusable element on the page.
- `lang="en"` on `<html>`.

## Don't

- Don't ship `tabindex={-1}` to "fix" focus issues without understanding why focus was wrong.
- Don't trap focus outside of dialogs / modals.
- Don't auto-play media with sound.
- Don't disable browser zoom (`user-scalable=no`).
- Don't rely on hover-only interactions for essential functionality (touch + keyboard users can't hover).

## Tooling

- Lint: `eslint-plugin-jsx-a11y`, `axe-core` integrated in tests, Lighthouse a11y audit.
- These catch ~30% of issues. The other 70% need a human (or screen-reader) pass.

## Sources

- WCAG 2.1 (W3C)
- WAI-ARIA Authoring Practices
- `axe-core` rule documentation
