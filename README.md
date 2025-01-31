# Lingeling.jl
Julia bindings to the library of the SAT-Solver **Lingeling** (TODO cite) created by Armin Biere.

-----
As Lingeling's API is similar to that of the SAT-Solver PicoSAT, some parts of Lingeling.jl are based off the Julia bindings in PicoSAT.jl (TODO link).

# Features
This package adds bindings to some but not all functions of the Lingeling SAT-Solver:
- Constructing and destructing the solver
- Getting and setting solver options
- Adding, freezing, and melting literals
- Checking whether literals are usable/reusable
- Solving and dereferencing

Documentation can be found in TODO, the original TODO, as well as in the PicoSAT library TODO.

## Installation
The package can be installed using
```
]add Lingeling
```
or
```
using Pkg
Pkg.add("Lingeling")
```

The package does **not** currently support Windows and macOS.

## Usage Example
```
# Initialize the Lingeling SAT-Solver
TODO

# Add some literals and finish the clause (by adding a `0` literal)
TODO

# Add some more clauses
TODO

# Solve
TODO

# Check whether the formula is satisfiable
TODO

# Get the satisfying literal assignments
TODO

# Destruct the SAT-Solver
TODO
```

# Issues
When you encounter any issues with this package, please consider creating an issue or fixing the problem by submitting a pull request.

# LICENSE
This package is provided under the same MIT license found in the Lingeling SAT-Solver (TODO).
