# Lingeling.jl Documentation

This is Lingeling.jl, a Julia package providing an interface to the SAT solver **Lingeling** created by Armin Biere ([Website](https://fmv.jku.at/lingeling/), [Repo](https://github.com/arminbiere/lingeling)).

!!! compat "Windows support"
    Lingeling.jl does currently **not** work on Windows.

While supporting the most important functions of Lingeling, this package does not include access to the full Lingeling API. For any functionality beyond what is provided here, please call the Lingeling C API directly using `Lingeling_jll`. For reference, see the [Lingeling.jl source code](https://github.com/sjvie/Lingeling.jl/blob/9f7aa366814f36fa8319c48ad1946d73a9e3545a/src/Lingeling.jl).

## Table of Contents
```@contents
Pages = ["installation.md", "example.md", "api.md"]
Depth = 2
```

---

!!! tip
    Some additional information may also be found in the Lingeling [header file](https://github.com/arminbiere/lingeling/blob/89a167d0d2efe98d983c87b5b84175b40ea55842/lglib.h), as well as in the [PicoSAT](https://fmv.jku.at/picosat/) header file.



