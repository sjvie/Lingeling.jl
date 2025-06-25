# A Short Example

First, install Lingeling.jl using the instructions in the [installation guide](installation.md).

Check the installation by printing the version of Lingeling:

```julia
using Lingeling
lgl_version()
```

Next, we will initialize an instance of Lingeling and add a clause to it:

```julia
solver = lgl_init()
lgl_add(solver, 1)
lgl_add(solver, 2)
lgl_add(solver, 0)  # end of clause
```

The `lgl_add` function is used to add literals to the clause.
Literals are represented as integers, where positive integers represent the literal itself and negative integers represent the negation of the literal.
Adding a `0` ends the current clause.

In this case, we are adding two literals ($1 \land 2$) followed by a terminating zero.
Let's add another clause:

```julia
lgl_add(solver, 1)
lgl_add(solver, -2)
lgl_add(solver, 0)  # end of clause
```

This adds a second clause ($1 \land \neg 2$).
The full formula we have now is:

$$(1 \lor 2) \land (1 \lor \neg 2)$$

Now, we can tell Lingeling to solve the formula (i.e., find a satisfying assignment):

```julia
result_code = lgl_sat(solver)
```

The `lgl_sat` function will return a result code indicating whether the formula is satisfiable or not.
The possible return values are `Lingeling.SATISFIABLE`, `Lingeling.UNSATISFIABLE`, or `Lingeling.UNKNOWN`.

```julia
println("Satisfiable: ", result_code == Lingeling.SATISFIABLE)
```

To get the satisfying assignments, we can check the values of each literal:

```julia
println("Literal 1: ", lgl_deref(solver, 1))
println("Literal 2: ", lgl_deref(solver, 2))
```

Finally, we should release the solver instance to free up resources:

```julia
lgl_release(solver)
```

---

!!! info "Full Example Code"
    The full code for this example can also be found [here](https://github.com/sjvie/Lingeling.jl/blob/9f7aa366814f36fa8319c48ad1946d73a9e3545a/example/short_example.jl)
