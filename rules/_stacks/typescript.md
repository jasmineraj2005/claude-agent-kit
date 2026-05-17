# Stack Overlay: TypeScript / JavaScript

**Tier:** inherits from the rule it extends. Load when the working directory has `tsconfig.json`, `package.json`, or `*.ts`/`*.tsx` files.

## Types

- `tsc` in `strict: true` mode. `noImplicitAny`, `strictNullChecks`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` all on.
- No `any` without an inline comment explaining why. Prefer `unknown` + narrowing.
- No non-null assertion (`!`) without a one-line comment justifying it. If the invariant is real, encode it in the type.
- `type` for unions, intersections, and aliases. `interface` for OOP-style extensible shapes. Don't mix both for the same concept.
- `as const` for literal preservation. Avoid `as Foo` casts; narrow with a type guard instead.

## Data modeling

- Discriminated unions over optional-boolean flags. `{ kind: "loaded"; data: T } | { kind: "error"; error: E }` beats `{ loaded: boolean; data?: T; error?: E }`.
- No `enum`; use string-literal unions (`type Status = "open" | "closed"`).
- `readonly` on fields that should not be reassigned. `ReadonlyArray<T>` / `as const` for immutable arrays.

## Modules and exports

- ESM only. No CommonJS in new code.
- Named exports over default exports (rename-resistant, refactor-friendly, better tree-shaking).
- One concept per file; barrel exports (`index.ts` re-exporting children) only at package boundaries.

## Async

- `async/await`, not raw promise chains.
- Errors thrown from async functions must be either caught at the boundary or surfaced (no swallowed `.catch(() => null)`).
- `Promise.all` for parallel; `Promise.allSettled` when partial failure is acceptable.

## Pitfalls

- Don't use `Object`, `Function`, `{}` as types (each means "anything except null/undefined" or worse).
- `Number()` over `parseInt(x, 10)` for clean strings; `parseInt` only when accepting trailing non-digits.
- Equality: `===` always. Document any deliberate `==`.
- `for...of` over `.forEach` when you might `await`, `break`, or `return`.

## Tests

- `vitest` or `jest`. Co-locate `*.test.ts` next to the source file unless the project pins a separate dir.
- No real network or filesystem in unit tests; mock at the module boundary.
- One behavior per test. Snapshot tests only for genuinely stable output.

## Tooling baseline

`eslint` (typescript-eslint recommended), `prettier`, `tsc --noEmit` on CI. If the project uses `biome`, follow project.
