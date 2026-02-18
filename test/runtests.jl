using Test
using X3872ThreeBodyLineshape

@testset "rho_thr neutral" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g_neutral=1.0, g_charged=0.0, Γ0_MeV=0.0)
    ρ = rho_thr(model, 1.0)
    @test isfinite(ρ.neutral.pi)
    @test isfinite(ρ.neutral.gamma)
    @test ρ.neutral.total > 0
end

@testset "lineshape neutral" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g_neutral=0.1, g_charged=0.0, Γ0_MeV=0.0)
    val = lineshape(model, 1.0)
    @test isfinite(val)
    @test val > 0
end

@testset "neutral ratio sanity" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g_neutral=1.0, g_charged=0.0, Γ0_MeV=0.0)
    ρ = rho_thr(model, 1.0)
    ratio = ρ.neutral.pi / ρ.neutral.gamma
    @test ratio > 0.5 && ratio < 5.0
end

@testset "analytic continuation" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g_neutral=0.1, g_charged=0.0, Γ0_MeV=0.0)
    D = denominator(model, 1.0 + 1.0im)
    @test isfinite(real(D)) && isfinite(imag(D))
end

@testset "rho_thr charged" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g_neutral=0.0, g_charged=1.0, Γ0_MeV=0.0)
    ρ = rho_thr(model, 1.0)
    @test isfinite(ρ.charged.pi)
    @test isfinite(ρ.charged.gamma)
    @test ρ.charged.total > 0
end
