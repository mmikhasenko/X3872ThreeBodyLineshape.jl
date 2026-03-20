using X3872ThreeBodyLineshape
using xDDPhaseSpace

struct Wrapped{D,M} <: xDDPhaseSpace.AbstractxDD
    d::D
    m::M
end
xDDPhaseSpace.mapdalitzmethod(w::Wrapped) = w.m
xDDPhaseSpace.masses(w::Wrapped) = xDDPhaseSpace.masses(w.d)
xDDPhaseSpace.decay_matrix_element_squared(w::Wrapped, s, σ3, σ2) =
    xDDPhaseSpace.decay_matrix_element_squared(w.d, s, σ3, σ2)

ch = build_channels()
revals = range(-0.2, 0.2; length=25)
imvals = [-1e-3, +1e-3]

mkpath("results")
open("results/near_cut_hook_vs_straight.csv","w") do io
    write(io, "ReE,ImE,hook,straight,diff\n")
    for im in imvals, re in revals
        E = re + 1im*im
        m = ch.threshold + E*1e-3
        hook = xDDPhaseSpace.ρ_thr(Wrapped(ch.pi, HookSqrtDalitzMapping{3}()), m) +
               xDDPhaseSpace.ρ_thr(Wrapped(ch.gamma, HookSqrtDalitzMapping{3}()), m)
        straight = xDDPhaseSpace.ρ_thr(Wrapped(ch.pi, LinearDalitzMapping()), m) +
                   xDDPhaseSpace.ρ_thr(Wrapped(ch.gamma, LinearDalitzMapping()), m)
        write(io, string(re,",",im,",",hook,",",straight,",",hook-straight,"\n"))
    end
end
