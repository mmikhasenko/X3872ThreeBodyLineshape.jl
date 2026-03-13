using Test
using X3872ThreeBodyLineshape

@testset "analytic continuation helpers" begin
    z0 = 1.0 + 0im
    z1 = -1.0 + 0im

    straight = continue_sqrt(z0, z1; path=:straight)
    hook = continue_sqrt(z0, z1; path=:hook, R=1e-2)

    # Straight crosses the branch cut (principal branch)
    # Hook avoids it; should land on opposite sheet (sign flip)
    @test abs(straight.value + hook.value) < 1e-6

    log_straight = continue_log(z0, z1; path=:straight)
    log_hook = continue_log(z0, z1; path=:hook, R=1e-2)

    # Log should differ by ~2πi across the cut
    @test abs((log_hook.value - log_straight.value) - 2π*1im) < 1e-3
end
