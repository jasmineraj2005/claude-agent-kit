# Rule: Performance

**Tier:** [WHEN USEFUL] — when measured performance matters: hot paths, user-facing latency, batch jobs at scale, cost-sensitive services.

Premature optimization is the root of a lot of bad code. So is permanent unconcern. The right rule is **measure first**.

## Measure before you optimize

- Profile before you change anything. Optimizing the wrong thing is wasted work and adds complexity.
- Use the right tool: CPU profiler (perf, py-spy, pprof, Chrome DevTools), memory profiler, async profiler, flamegraphs.
- Don't optimize based on what you think is slow. Optimize what the profile shows is slow.

## Targets

- **Latency:** track p50/p95/p99, not average. Tail latency is where users live.
- **Throughput:** requests/sec at sustained load.
- **Resource cost:** CPU, memory, IO, $ per request.
- Pick the metric the use case actually cares about and tune for it.

## Common quick wins (check these first)

- **N+1 queries** — single biggest source of "why is this endpoint slow." Eager-load or batch.
- **Missing indexes** — `EXPLAIN` the query.
- **Allocations in hot loops** — reuse buffers, avoid boxing, prefer arrays of structs over arrays of pointers in hot paths.
- **Unnecessary serialization** — round-tripping JSON / protobuf on every step.
- **Sync IO in an async hot path.**
- **No pagination** on endpoints that can grow.
- **Missing cache** on expensive idempotent reads (with explicit invalidation strategy).
- **String concatenation in a loop** — use a builder.

## Concurrency, briefly

- Every IO call has a timeout. Always.
- Every retry has jitter. Synchronized retries cause thundering herds.
- Every cancellation propagates. Don't leak goroutines / tasks / threads.
- Race conditions are easier to prevent (immutability, message-passing) than to debug.
- If you're using a lock: prefer the smallest critical section, in a single direction (always acquire A before B to avoid deadlock).
- Backpressure beats unbounded queues. An unbounded queue is just a slow OOM.

## Caching

- Cache after measurement, not before.
- Every cache needs an invalidation strategy. "Whenever we deploy" is not a strategy.
- Cache the right layer — at the boundary (HTTP), at the data store (Redis), or in-process (LRU). Each has different correctness implications.
- Beware: cache stampede. Use a single-flight pattern or stale-while-revalidate.

## Benchmarks before claiming "faster"

- Microbenchmark with the language's harness (`go test -bench`, `pytest-benchmark`, `criterion`, etc.).
- Don't compare debug builds; use release builds for real numbers.
- Run multiple iterations; take median or trimmed mean.
- Note the hardware, OS, and any background load. "Faster on my laptop" isn't faster.

## When NOT to optimize

- The code isn't on a hot path.
- The "optimization" makes the code harder to read for sub-1% gain.
- You don't have a measurement to confirm the win.
- The bottleneck is in a dep you don't control — try to work around it at the call site, not micro-opt your call.

## Sources

- Donald Knuth (the actual full quote: *"premature optimization is the root of all evil... yet we should not pass up our opportunities in that critical 3%"*).
- Brendan Gregg — *Systems Performance*
- USE / RED method (see `observability.md`).
