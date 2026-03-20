# X3872 three-body: continuation baseline review

## Summary
This PR establishes the **baseline complex-plane evaluation** for the raw three-body threshold density
\(\rho_{\rm thr}(E)\) and prepares the **hook vs straight** comparison machinery. It does **not** yet
apply the explicit discontinuity correction; that is the next step.

## Definitions
We evaluate
\[
\rho_{\rm thr}(E) = \rho_{\pi}(E) + \rho_{\gamma}(E),\qquad E = m - (m_{D^0}+m_{D^{*0}})\,.
\]
The phase-space integral is implemented in **xDDPhaseSpace** via
\(\rho_{\rm thr}(m)\) with a Dalitz mapping `mapdalitz`.

**Key point:** the branch cut is determined by the **integration contour** (in \(\sqrt{\sigma}\)):
- default: `HookSqrtDalitzMapping` (hook path)
- comparison: `LinearDalitzMapping` (straight path)

This matches the expectation that the D\* pole in the integrand makes contour choice visible.

## Baseline grid (completed)
We compute \(\rho_{\rm thr}(E)\) on a 30×30 grid:
- ReE: \([-3,0]\) MeV
- ImE: \([-2,+1]\) MeV

Outputs:
- `results/rho_thr_grid.csv`
- `results/rho_thr_abs.svg` (|rho| heatmap)
- `results/rho_thr_arg.svg` (arg heatmap)

## Hook vs straight comparison (in progress)
We add scripts to compare hook vs straight mappings at selected points:
- `scripts/compare_hook_straight.jl` → outputs `results/hook_vs_straight_points.csv`
- `scripts/near_cut_discontinuity.jl` → outputs `results/near_cut_hook_vs_straight.csv`

These will quantify mismatch near the cut before applying explicit discontinuity.

## Next validation target
- Near cut: show mismatch between hook and straight.
- Apply explicit discontinuity correction to align straight → hook.
- Achieve |Δ| ≤ 1e−6 away from the cut (absolute tolerance for small values).
