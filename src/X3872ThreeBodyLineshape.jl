module X3872ThreeBodyLineshape

import Base: denominator

using xDDPhaseSpace

export X3872ThreeBody, default_constants, build_channels
export rho_thr, denominator, lineshape

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
    build_channels(; constants=default_constants())

Construct the (πDD, γDD) channels for neutral and charged configurations.
"""
function build_channels(; constants = default_constants())
    # neutral
    BW0 = BW(m = constants.mDstar0, Γ = constants.ΓDstar0)
    ch_pi0 = πDD((m1 = constants.mπ0, m2 = constants.mD0, m3 = constants.mD0), BW0, BW0)
    ch_gamma0 = γDD(
        (m1 = constants.mγ, m2 = constants.mD0, m3 = constants.mD0),
        BW0, BW0,
        constants.μ0, -constants.μ0
    )
    thr0 = constants.mDstar0 + constants.mD0

    # charged
    BWc = BW(m = constants.mDstarp, Γ = constants.ΓDstarp)
    ch_pic = πDD((m1 = constants.mπp, m2 = constants.mDp, m3 = constants.mDp), BWc, BWc)
    ch_gammac = γDD(
        (m1 = constants.mγ, m2 = constants.mDp, m3 = constants.mDp),
        BWc, BWc,
        constants.μp, -constants.μp
    )
    thrc = constants.mDstarp + constants.mDp

    return (
        neutral = (pi = ch_pi0, gamma = ch_gamma0, threshold = thr0),
        charged = (pi = ch_pic, gamma = ch_gammac, threshold = thrc)
    )
end

"""Model container for three-body X(3872) lineshape (neutral + charged)."""
struct X3872ThreeBody{T<:Real}
    Ef_MeV::T
    g_neutral::T
    g_charged::T
    Γ0_MeV::T
    constants::NamedTuple
    channels::NamedTuple
end

function X3872ThreeBody(; Ef_MeV::Real, g_neutral::Real, g_charged::Real, Γ0_MeV::Real, constants = default_constants())
    channels = build_channels(; constants)
    return X3872ThreeBody(Ef_MeV, g_neutral, g_charged, Γ0_MeV, constants, channels)
end

"""
    rho_thr(model::X3872ThreeBody, E)

Three-body phase-space density at energy offset E (MeV) relative to the neutral threshold.
Returns neutral and charged contributions plus totals.
"""
function rho_thr(model::X3872ThreeBody, E)
    ch0 = model.channels.neutral
    chc = model.channels.charged
    m = ch0.threshold + E * 1e-3
    safe_rho(ch, mval) = isreal(mval) && mval < sum(masses(ch)) ? 0.0 : xDDPhaseSpace.ρ_thr(ch, mval)
    ρπ0 = safe_rho(ch0.pi, m)
    ργ0 = safe_rho(ch0.gamma, m)
    ρπc = safe_rho(chc.pi, m)
    ργc = safe_rho(chc.gamma, m)
    return (
        neutral = (pi = ρπ0, gamma = ργ0, total = ρπ0 + ργ0),
        charged = (pi = ρπc, gamma = ργc, total = ρπc + ργc),
        total = (ρπ0 + ργ0) + (ρπc + ργc)
    )
end

"""
    denominator(model::X3872ThreeBody, E)

Denominator of the three-body amplitude. E is in MeV (relative to neutral threshold).
"""
function denominator(model::X3872ThreeBody, E)
    Eρ = isreal(E) ? E : real(E)
    ρ = rho_thr(model, Eρ)
    return (model.Ef_MeV - E) * 1e-3 + 1im * model.Γ0_MeV / 2 +
        1im * (model.g_neutral * ρ.neutral.total + model.g_charged * ρ.charged.total)
end

"""Lineshape (unnormalized): |1/denominator|^2."""
lineshape(model::X3872ThreeBody, E) = abs2(inv(denominator(model, E)))

# convenience wrapper
lineshape(E; Ef_MeV::Real, g_neutral::Real, g_charged::Real, Γ0_MeV::Real, constants = default_constants()) =
    lineshape(X3872ThreeBody(; Ef_MeV, g_neutral, g_charged, Γ0_MeV, constants), E)

end # module
