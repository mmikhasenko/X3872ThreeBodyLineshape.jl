module X3872ThreeBodyLineshape

using xDDPhaseSpace

export lineshape, rho_thr, build_channels, default_constants

"""Return a NamedTuple of default constants (masses/widths) used by the model."""
function default_constants()
    return (
        # neutral
        mπ0 = 0.1349768,
        mD0 = 1.86483,
        mDstar0 = 2.00685,
        ΓDstar0 = 55.2e-6,
        μ0 = -3.77,
        # charged (PDG/measurement; update if needed)
        mπp = 0.13957039,
        mDp = 1.86965,
        mDstarp = 2.01026,
        ΓDstarp = 83.4e-6,
        μp = -3.77,
        # photon
        mγ = 0.0
    )
end

"""
    build_channels(; channel=:neutral, constants=default_constants())

Construct the (πDD, γDD) channels for the requested charge configuration.
"""
function build_channels(; channel::Symbol = :neutral, constants = default_constants())
    if channel === :neutral
        BW0 = BW(m = constants.mDstar0, Γ = constants.ΓDstar0)
        ch_pi = πDD((m1 = constants.mπ0, m2 = constants.mD0, m3 = constants.mD0), BW0, BW0)
        ch_gamma = γDD(
            (m1 = constants.mγ, m2 = constants.mD0, m3 = constants.mD0),
            BW0, BW0,
            constants.μ0, -constants.μ0
        )
        thr = constants.mDstar0 + constants.mD0
        return (pi = ch_pi, gamma = ch_gamma, threshold = thr)
    elseif channel === :charged
        BWc = BW(m = constants.mDstarp, Γ = constants.ΓDstarp)
        ch_pi = πDD((m1 = constants.mπp, m2 = constants.mDp, m3 = constants.mDp), BWc, BWc)
        ch_gamma = γDD(
            (m1 = constants.mγ, m2 = constants.mDp, m3 = constants.mDp),
            BWc, BWc,
            constants.μp, -constants.μp
        )
        thr = constants.mDstarp + constants.mDp
        return (pi = ch_pi, gamma = ch_gamma, threshold = thr)
    else
        error("Unsupported channel: $channel (use :neutral or :charged)")
    end
end

"""
    rho_thr(E; channel=:neutral, constants=default_constants())

Three-body phase-space density at energy offset E (MeV) relative to threshold.
Returns a NamedTuple with π and γ contributions and their sum.
"""
function rho_thr(E; channel::Symbol = :neutral, constants = default_constants())
    ch = build_channels(; channel, constants)
    m = ch.threshold + E * 1e-3
    ρπ = xDDPhaseSpace.ρ_thr(ch.pi, m)
    ργ = xDDPhaseSpace.ρ_thr(ch.gamma, m)
    return (pi = ρπ, gamma = ργ, total = ρπ + ργ)
end

"""
    lineshape(E; channel=:neutral, Ef_MeV, g, Γ0_MeV, constants=default_constants())

Unnormalized lineshape using a dispersive denominator:
    D(E) = (Ef - E)*1e-3 + i Γ0/2 + i g * (ρπ + ργ)
Returns |1/D(E)|^2.
"""
function lineshape(
    E;
    channel::Symbol = :neutral,
    Ef_MeV::Real,
    g::Real,
    Γ0_MeV::Real,
    constants = default_constants()
)
    ρ = rho_thr(E; channel, constants)
    D = (Ef_MeV - E) * 1e-3 + 1im * Γ0_MeV / 2 + 1im * g * ρ.total
    return abs2(inv(D))
end

end # module
