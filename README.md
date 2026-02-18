# X3872ThreeBodyLineshape.jl

Minimal package to provide a three-body lineshape for X(3872) → D* D̄ (neutral and charged channels),
using xDDPhaseSpace for 3-body phase space and supporting analytic continuation.

## Status (Iteration 2)
- Validation plots generated in X3872EffRange.jl (see docs/plots/):
  - phase_space_pi0-gamma.pdf
  - pi0-gamma_ratio.pdf
- Minimal API implemented: `rho_thr`, `lineshape`, and `build_channels`.
- Charged-channel constants are placeholders; update once validated.

## Roadmap
- Iteration 2: Implement `rho_thr` and `lineshape` APIs
- Iteration 3: Tests (regression vs. validated notebook outputs)
- Iteration 4: Docs page + example

