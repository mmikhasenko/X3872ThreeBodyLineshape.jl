module X3872ThreeBodyLineshape

using xDDPhaseSpace

export lineshape, rho_thr

"""
    lineshape(E; channel=:neutral, params...)

Return unnormalized lineshape at energy offset E (MeV) relative to threshold.
channel = :neutral or :charged (planned).
"""
function lineshape(E; channel=:neutral, params...)
    # TODO: implement three-body lineshape based on xDDPhaseSpace
    error("Not implemented yet: lineshape. Iteration 2 will add implementation.")
end

"""
    rho_thr(E; channel=:neutral)

Three-body phase-space density at E (MeV) relative to threshold.
"""
function rho_thr(E; channel=:neutral)
    error("Not implemented yet: rho_thr. Iteration 2 will add implementation.")
end

end # module
