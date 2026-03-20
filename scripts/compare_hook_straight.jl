using X3872ThreeBodyLineshape
using xDDPhaseSpace

# Wrapper to override mapping method
struct Wrapped{D,M} <: xDDPhaseSpace.AbstractxDD
    d::D
    m::M
end
xDDPhaseSpace.mapdalitzmethod(w::Wrapped) = w.m
xDDPhaseSpace.masses(w::Wrapped) = xDDPhaseSpace.masses(w.d)
xDDPhaseSpace.decay_matrix_element_squared(w::Wrapped, s, σ3, σ2) =
    xDDPhaseSpace.decay_matrix_element_squared(w.d, s, σ3, σ2)

ch = build_channels()
points = [(-2.5, -1.0), (-1.5, -0.5), (-0.5, 0.5), (-1.0, 0.0)]

mkpath("results")
open("results/hook_vs_straight_points.csv","w") do io
    write(io, "ReE,ImE,hook,straight,diff\n")
    for (re, im) in points
        E = re + 1im*im
        m = ch.threshold + E*1e-3
        hook_pi = xDDPhaseSpace.ρ_thr(Wrapped(ch.pi, HookSqrtDalitzMapping{3}()), m)
        hook_g  = xDDPhaseSpace.ρ_thr(Wrapped(ch.gamma, HookSqrtDalitzMapping{3}()), m)
        straight_pi = xDDPhaseSpace.ρ_thr(Wrapped(ch.pi, LinearDalitzMapping()), m)
        straight_g  = xDDPhaseSpace.ρ_thr(Wrapped(ch.gamma, LinearDalitzMapping()), m)
        hook = hook_pi + hook_g
        straight = straight_pi + straight_g
        write(io, string(re,",",im,",",hook,",",straight,",",hook-straight,"\n"))
    end
end
