# Example usage

```julia
using X3872ThreeBodyLineshape

model = X3872ThreeBody(Ef_MeV=0.0, g=0.1, Γ0_MeV=0.0; channel=:neutral)
E = range(-2.0, 2.0, length=200)
L = [lineshape(model, e) for e in E]

# charged channel
model_c = X3872ThreeBody(Ef_MeV=0.0, g=0.1, Γ0_MeV=0.0; channel=:charged)
L_c = [lineshape(model_c, e) for e in E]
```

Notes:
- Energy `E` is in MeV relative to threshold.
- Charged-channel constants are provisional (see README table).
