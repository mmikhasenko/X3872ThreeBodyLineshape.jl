using Test
using X3872ThreeBodyLineshape

@testset "rho_thr neutral" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g=1.0, Γ0_MeV=0.0; channel=:neutral)
    ρ = rho_thr(model, 1.0)
    @test isfinite(ρ.pi)
    @test isfinite(ρ.gamma)
    @test ρ.total > 0
end

@testset "lineshape neutral" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g=0.1, Γ0_MeV=0.0; channel=:neutral)
    val = lineshape(model, 1.0)
    @test isfinite(val)
    @test val > 0
end

@testset "neutral ratio sanity" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g=1.0, Γ0_MeV=0.0; channel=:neutral)
    ρ = rho_thr(model, 1.0)
    ratio = ρ.pi / ρ.gamma
    @test ratio > 0.5 && ratio < 5.0
end

@testset "rho_thr charged" begin
    model = X3872ThreeBody(Ef_MeV=0.0, g=1.0, Γ0_MeV=0.0; channel=:charged)
    ρ = rho_thr(model, 1.0)
    @test isfinite(ρ.pi)
    @test isfinite(ρ.gamma)
    @test ρ.total > 0
end
