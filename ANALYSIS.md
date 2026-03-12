# Analysis log

## Goal
Summarize current analytic continuation implementation and validation checks.

## Current implementation map
- `src/analytic_continuation.jl` — main continuation logic (hook/straight path).
- `src/threebody.jl` — three‑body amplitude evaluation.
- `src/X3872ThreeBodyLineshape.jl` — package entry / exports.
- `src/util.jl` — utilities.

## Validation checks (planned)
- Compare two evaluation paths (hook vs straight) in complex plane.
- Probe near branch point; confirm square‑root behavior.
- Evaluate just above/below cut; confirm discontinuity.
- Sheet consistency: below‑cut continuation matches expected sheet.
- Numerical stability vs step size.

## Next step
Inspect `analytic_continuation.jl` in detail and extract formulas/algorithm.
