"""
Analytic continuation utilities (path-based phase tracking).

These helpers implement continuation for branch-cut functions (sqrt/log)
by tracking the complex phase continuously along a path.
"""

export path_straight, path_hook
export continue_sqrt, continue_log

"""Generate a straight-line path from z0 to z1 with n points (inclusive)."""
path_straight(z0::Complex, z1::Complex; n::Int=128) =
    range(z0, z1; length=n) |> collect

"""
Generate a hook path that detours around a branch point.

- z0 -> (z0 + i*R) -> (z1 + i*R) -> z1
"""
function path_hook(z0::Complex, z1::Complex; R::Real=1e-3, n::Int=128)
    n1 = max(2, n ÷ 3)
    n2 = max(2, n ÷ 3)
    n3 = max(2, n - n1 - n2)
    p1 = range(z0, z0 + 1im*R; length=n1)
    p2 = range(z0 + 1im*R, z1 + 1im*R; length=n2)
    p3 = range(z1 + 1im*R, z1; length=n3)
    return vcat(collect(p1), collect(p2)[2:end], collect(p3)[2:end])
end

"""Unwrap phases to enforce continuity."""
function _unwrap(phases::Vector{Float64})
    out = similar(phases)
    out[1] = phases[1]
    for i in 2:length(phases)
        Δ = phases[i] - phases[i-1]
        if Δ > π
            Δ -= 2π
        elseif Δ < -π
            Δ += 2π
        end
        out[i] = out[i-1] + Δ
    end
    return out
end

"""
Continue sqrt along a path, returning the final value and full path values.
"""
function continue_sqrt(z0::Complex, z1::Complex; path::Symbol=:straight, n::Int=256, R::Real=1e-3)
    pts = path === :hook ? path_hook(z0, z1; R=R, n=n) : path_straight(z0, z1; n=n)
    rs = abs.(pts)
    phases = angle.(pts)
    phases = _unwrap(phases)
    vals = sqrt.(rs) .* exp.(0.5im .* phases)
    return (value = vals[end], path = pts, values = vals)
end

"""
Continue log along a path, returning the final value and full path values.
"""
function continue_log(z0::Complex, z1::Complex; path::Symbol=:straight, n::Int=256, R::Real=1e-3)
    pts = path === :hook ? path_hook(z0, z1; R=R, n=n) : path_straight(z0, z1; n=n)
    rs = abs.(pts)
    phases = angle.(pts)
    phases = _unwrap(phases)
    vals = log.(rs) .+ 1im .* phases
    return (value = vals[end], path = pts, values = vals)
end
