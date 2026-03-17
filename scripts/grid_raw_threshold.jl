using X3872ThreeBodyLineshape

const model = X3872ThreeBody(; Ef_MeV=0.0, g=1.0, Γ0_MeV=0.0, channel=:neutral)
const n = 30
const re_min, re_max = -3.0, 0.0
const im_min, im_max = -2.0, 1.0
const revals = range(re_min, re_max; length=n)
const imvals = range(im_min, im_max; length=n)

mkpath("results")
open("results/rho_thr_grid.csv","w") do io
    write(io, "ReE,ImE,rho_pi,rho_gamma,rho_total\n")
    for x in revals, y in imvals
        E = x + (1im)*y
        ρ = rho_thr(model, E)
        write(io, string(x,",",y,",",ρ.pi,",",ρ.gamma,",",ρ.total,"\n"))
    end
end
