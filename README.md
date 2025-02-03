# Lingeling.jl
![example workflow](https://github.com/sjvie/Lingeling.jl/actions/workflows/testing.yml/badge.svg)\
Julia interface for the SAT solver **Lingeling** ([Website](https://fmv.jku.at/lingeling/), [Repo](https://github.com/arminbiere/lingeling)) created by Armin Biere.

-----
As Lingeling's API is similar to that of the SAT-Solver PicoSAT, some parts of Lingeling.jl are based on the Julia bindings in [PicoSAT.jl](https://github.com/sisl/PicoSAT.jl).

# ✨ Features
Lingeling.jl adds bindings to some but not all functions of the Lingeling SAT-Solver:
- Constructing and destructing the solver
- Getting and setting solver options
- Adding, freezing, and melting literals
- Checking whether literals are usable/reusable
- Solving and dereferencing

Some documentation can be found in [Lingeling.jl](https://github.com/sjvie/Lingeling.jl/blob/9f7aa366814f36fa8319c48ad1946d73a9e3545a/src/Lingeling.jl), the Lingeling [header file](https://github.com/arminbiere/lingeling/blob/89a167d0d2efe98d983c87b5b84175b40ea55842/lglib.h), as well as in the [PicoSAT](https://fmv.jku.at/picosat/) header file.

# 🔧 Installation
Lingeling.jl can be installed using
```
]add Lingeling
```
or
```
using Pkg
Pkg.add("Lingeling")
```

Lingeling.jl does **not** currently support Windows and macOS.

# 💡 Usage Example

https://github.com/sjvie/Lingeling.jl/blob/9f7aa366814f36fa8319c48ad1946d73a9e3545a/example/short_example.jl#L1-L29

# ❗ Any Problems?
When you encounter any issues with this package, please consider creating an issue or fixing the problem by submitting a pull request.

# 💼 LICENSE
Lingeling.jl is provided under an MIT license, same as the Lingeling SAT-Solver ([Lingeling license file](https://github.com/arminbiere/lingeling/blob/89a167d0d2efe98d983c87b5b84175b40ea55842/COPYING)).
