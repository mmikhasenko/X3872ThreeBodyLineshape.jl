using Test
using X3872ThreeBodyLineshape

@testset "rho_thr neutral" begin
    ρ = rho_thr(1.0; channel=:neutral)
    @test isfinite(ρ.pi)
    @test isfinite(ρ.gamma)
    @test ρ.total > 0
end

@testset "lineshape neutral" begin
    val = lineshape(1.0; channel=:neutral, Ef_MeV=0.0, g=0.1, Γ0_MeV=0.0)
    @test isfinite(val)
    @test val > 0
end

@testset "rho_thr charged" begin
    ρ = rho_thr(1.0; channel=:charged)
    @test isfinite(ρ.pi)
    @test isfinite(ρ.gamma)
    @test ρ.total > 0
end
