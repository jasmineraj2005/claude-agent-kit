# Stack Overlay: Python

**Tier:** inherits from the rule it extends. Load when the working directory has `pyproject.toml`, `requirements*.txt`, or `*.py` files.

## Types

- Type hints on every public function signature. Internal helpers: when types aid clarity, skip for one-liners.
- `from __future__ import annotations` at top of files using forward references or modern union syntax in older runtimes.
- No `Any` without an inline comment explaining why. `cast` is preferred over `# type: ignore`.
- `mypy --strict` is the bar (or `pyright`); a project that doesn't reach it should at least not regress.

## Control flow

- Prefer `match` over chained `isinstance` when matching shape or sum types.
- Never `except Exception:` without re-raising or logging the original. `except:` (bare) is forbidden.
- Use `with` for any resource that has a context manager. No manual `.close()` in try/finally.
- Generators over list comprehensions when the result is consumed once.

## Data

- `@dataclass(frozen=True, slots=True)` for plain data with a fixed shape. `pydantic.BaseModel` when validation is needed at a boundary. Plain `dict` only for truly dynamic data.
- `pathlib.Path` over string paths. `os.path.join` is legacy.
- `datetime.now(tz=UTC)` over `datetime.utcnow()` (the latter is naive and confusing).

## Pitfalls

- No mutable default arguments. `def f(x=[])` is a bug factory; use `None` and replace inside.
- `if __name__ == "__main__":` guard on any module with import-time side effects.
- Don't `import *`. Don't use star-imports even in `__init__.py`; be explicit.
- `subprocess.run(["cmd", "arg"])`, never `shell=True` with interpolated input.

## Tests

- `pytest`, not `unittest`. Fixtures over setUp/tearDown.
- One assertion per test where practical; use `pytest.mark.parametrize` for variants.
- `pytest-asyncio` for async; mark coroutines explicitly.
- No real network in unit tests; use `responses` / `httpx.MockTransport`.

## Tooling baseline

`ruff` for lint + format, `mypy --strict` (or `pyright`), `pytest`. If the project pins different tools (e.g. black + isort + flake8), follow the project.
