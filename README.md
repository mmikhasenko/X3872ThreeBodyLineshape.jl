# X3872ThreeBodyLineshape.jl

Minimal package to provide a three-body lineshape for X(3872) → D* D̄ (neutral and charged channels),
using xDDPhaseSpace for 3-body phase space and supporting analytic continuation.

## Status (Iteration 2)
- Validation plots generated in X3872EffRange.jl (see docs/plots/):
  - phase_space_pi0-gamma.pdf
  - pi0-gamma_ratio.pdf
- Minimal API implemented: `rho_thr`, `lineshape`, and `build_channels`.
- Charged-channel constants are placeholders; update once validated.

## Usage (object API, like X3872Flatte)
```julia
using X3872ThreeBodyLineshape

model = X3872ThreeBody(Ef_MeV=0.0, g=0.1, Γ0_MeV=0.0; channel=:neutral)
D = denominator(model, 1.0)      # E in MeV
L = lineshape(model, 1.0)        # |1/D|^2
ρ = rho_thr(model, 1.0)          # (pi, gamma, total)
```

## Parameters (defaults)
| Symbol | Meaning | Default | Source |
|---|---|---:|---|
| mD0 | D0 mass | 1.86483 | PDG tables: https://pdg.lbl.gov/2023/tables/contents_tables_mesons.html |
| mD*0 | D*0 mass | 2.00685 | PDG tables: https://pdg.lbl.gov/2023/tables/contents_tables_mesons.html |
| ΓD*0 | D*0 width | 55.2 keV | X3872EffRange defaults |
| mπ0 | π0 mass | 0.1349768 | PDG tables |
| mDp | D+ mass | 1.86965 | PDG tables |
| mD*+ | D*+ mass | 2.01026 | PDG tables |
| ΓD*+ | D*+ width | 83.4 keV | PDG D*(2010)+ listing: https://pdg.lbl.gov/2018/listings/rpp2018-list-D-star-2010-plus-minus.pdf |
| mπ+ | π+ mass | 0.13957039 | PDG tables |
| μ0 | radiative coupling (neutral) | -3.77 | X3872EffRange defaults |
| μ+ | radiative coupling (charged) | -3.77 | placeholder (same magnitude as μ0) |

## Roadmap
- Iteration 4: Docs page + example
- Iteration 5: Validation PDF update + charged-channel review

