# Plan (active)

PR: https://github.com/mmikhasenko/X3872ThreeBodyLineshape.jl/pull/5

## Phase A — Baseline evaluation in complex plane
- **Setup grid:** square region around $E_\mathrm{thr}=m_{D^0}+m_{D^{*0}}$.
  - Range: $E \in [E_\mathrm{thr}-3,\,E_\mathrm{thr}+0]\,\text{MeV}$ (real axis span 3 MeV)
  - Imaginary span: $\Im E \in [-2,+1]$ MeV
  - Grid: 30×30 (default)
- **Raw threshold:** evaluate $\rho_\mathrm{thr}(E)$ in the complex plane for D0/D*0 with D*0 as BW.
- **Consistency (no-cut region):** verify hook and straight continuation agree within $10^{-6}$ away from the cut.

### Action: create_file scripts/grid_raw_threshold.jl
```julia
using X3872ThreeBodyLineshape

const model = X3872ThreeBody(; Ef_MeV=0.0, g=1.0, Γ0_MeV=0.0, channel=:neutral)
const n = 30
const re_min, re_max = -3.0, 0.0
const im_min, im_max = -2.0, 1.0
const re = range(re_min, re_max; length=n)
const im = range(im_min, im_max; length=n)

mkpath("results")
open("results/rho_thr_grid.csv","w") do io
    write(io, "ReE,ImE,rho_pi,rho_gamma,rho_total\n")
    for x in re, y in im
        E = x + 1im*y
        ρ = rho_thr(model, E)
        write(io, string(x,",",y,",",ρ.pi,",",ρ.gamma,",",ρ.total,"\n"))
    end
end
```

### Action: run julia --project=. scripts/grid_raw_threshold.jl

### Action: create_file scripts/compare_hook_straight.jl
```julia
using X3872ThreeBodyLineshape
using xDDPhaseSpace
using Cuba

function rho_thr_method(d, m::Complex, method)
    integrand(x, f) = begin
        (σ3, σ2), jac = xDDPhaseSpace.mapdalitz(method, x, xDDPhaseSpace.masses(d), m^2)
        val = xDDPhaseSpace.decay_matrix_element_squared(d, m^2, σ3, σ2) / (2π * m^2) * jac
        f[1:2] .= reim(val)
    end
    v = cuhre(integrand, 2, 2)[1]
    complex(v...) / (8π)^2
end

ch = build_channels()
points = [(-2.5, -1.0), (-1.5, 0.2), (-0.5, -0.5), (-2.0, 0.5)]

mkpath("results")
open("results/hook_straight_points.csv","w") do io
    write(io, "ReE,ImE,rho_hook,rho_straight,delta\n")
    for (reE, imE) in points
        m = ch.threshold + (reE + 1im*imE) * 1e-3
        ρh = rho_thr_method(ch.pi, m, HookSqrtDalitzMapping{3}()) + rho_thr_method(ch.gamma, m, HookSqrtDalitzMapping{3}())
        ρs = rho_thr_method(ch.pi, m, LinearDalitzMapping()) + rho_thr_method(ch.gamma, m, LinearDalitzMapping())
        write(io, string(reE,",",imE,",",ρh,",",ρs,",",ρh-ρs,"\n"))
    end
end
```

### Action: run julia --project=. scripts/compare_hook_straight.jl

### Action: create_file scripts/near_cut_discontinuity.jl
```julia
using X3872ThreeBodyLineshape
using xDDPhaseSpace
using Cuba

function rho_thr_method(d, m::Complex, method)
    integrand(x, f) = begin
        (σ3, σ2), jac = xDDPhaseSpace.mapdalitz(method, x, xDDPhaseSpace.masses(d), m^2)
        val = xDDPhaseSpace.decay_matrix_element_squared(d, m^2, σ3, σ2) / (2π * m^2) * jac
        f[1:2] .= reim(val)
    end
    v = cuhre(integrand, 2, 2)[1]
    complex(v...) / (8π)^2
end

ch = build_channels()
revals = range(-0.2, 0.2; length=21)
ims = [-1e-3, +1e-3]

mkpath("results")
open("results/near_cut_mismatch.csv","w") do io
    write(io, "ReE,ImE,rho_hook,rho_straight,delta\n")
    for imE in ims, reE in revals
        m = ch.threshold + (reE + 1im*imE) * 1e-3
        ρh = rho_thr_method(ch.pi, m, HookSqrtDalitzMapping{3}()) + rho_thr_method(ch.gamma, m, HookSqrtDalitzMapping{3}())
        ρs = rho_thr_method(ch.pi, m, LinearDalitzMapping()) + rho_thr_method(ch.gamma, m, LinearDalitzMapping())
        write(io, string(reE,",",imE,",",ρh,",",ρs,",",ρh-ρs,"\n"))
    end
end
```

### Action: run julia --project=. scripts/near_cut_discontinuity.jl

## Phase B — Cut structure + discontinuity
- **Path definitions:**
  - Straight path: cut is straight.
  - Hook path: cut bends downward.
- **Nominal choice:** hook path defines the reference sheet.
- **Discontinuity:** derive/compute the branch-point discontinuity and add it to the straight-path result to match hook-path values.
- **Validation near cut:** approach the cut and show mismatch before correction; agreement after adding discontinuity.

## Phase C — Full-grid alignment
- Apply discontinuity correction across the full 30×30 grid.
- Target tolerance: absolute $\le 10^{-6}$ for small values.
- Record max deviation and any outliers.

## Phase D — Documentation & report
- Update `NOTES.tex` with algorithm details, validation plots/tables.
- Generate PDF report (local first; CI later).
- Summarize results in `NOTES.md` and tracker.

## Deliverables
- Code changes with tests/validation scripts.
- Updated LaTeX notes + PDF.
- NOTES.md entries summarizing each iteration.

