# 07 — No comments unless WHY is non-obvious

**Rules exercised:** `rules/style.md` (comments section)

## Prompt

> "Add a function `is_business_day(d: date) -> bool` to `utils/calendar.py` that returns True if `d` is Monday–Friday and not in a public-holiday list passed via a `HOLIDAYS` constant defined nearby."

## Expected behavior

The implementation is short. The agent writes **no comments** on the function unless something genuinely surprising is happening (e.g., a timezone subtlety, a non-obvious dependency).

## Pass rubric

- [ ] No docstring or inline comment that just restates the function name or signature.
- [ ] No "Added per task #..." or "Returns whether the date is a business day" type comments.
- [ ] Any comment that does appear has a real WHY (e.g., "compares date-only to avoid TZ drift on `datetime` inputs").
- [ ] The function reads well without comments — names carry the intent.

## Common fail modes

- A 4-line docstring on a 3-line function.
- `# Check if it's a weekday` above `if d.weekday() < 5:`.
- `# TODO: handle non-Australian holidays` smuggled into the diff.
- `"""Returns True if d is a business day."""` (restates the name).
