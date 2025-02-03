using Lingeling

# Initialize the Lingeling SAT-Solver
solver = lgl_init()

# Add some literals and finish the clause (by adding a `0` literal)
# (1 OR 2)
lgl_add(solver, 1) 
lgl_add(solver, 2)
lgl_add(solver, 0)

# Add another clause
# (1 OR !2)
lgl_add(solver, 1)
lgl_add(solver, -2)
lgl_add(solver, 0)

# Solve
result_code = lgl_sat(solver)

# Check whether the formula is satisfiable
println("Satisfiable: ", result_code == Lingeling.SATISFIABLE)

# Get the satisfying literal assignments
println("Literal 1: ", lgl_deref(solver, 1))
println("Literal 2: ", lgl_deref(solver, 2))

# Destruct the SAT-Solver
lgl_release(solver)
