using Lingeling
using Test

function add_cnf_sat(solver, formula)
    for clause in split(formula, '\n')
        if clause == ""
            continue
        end
        for literal in split(clause)
            if literal == ""
                break
            end
            lgl_add(solver, parse(Int, literal))
        end
        # add clause to solver
        lgl_add(solver, 0)
    end
end

@testset "Satisfiable" begin
    formula = """
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    lgl_release(solver)

    formula = """
    1 -1
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    lgl_release(solver)

    formula = """
    1 2
    2 3
    1 -3
    -1 -2 3
    -2 -3
    1 -3
    1 3
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    @test lgl_deref(solver, 1) == 1
    @test lgl_deref(solver, 2) == -1
    @test lgl_deref(solver, 3) == 1
    lgl_release(solver)


    formula = """
    1 2 -3
    -1 2 3
    1 -2 4
    -4 5 -3
    2 4 5
    2 3
    -2 -5
    5 -4 2
    -2 -4 1
    1 2 3
    -1 -2 3
    2 5
    -2 -4
    2 -5
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    @test lgl_deref(solver, 1) == 1
    @test lgl_deref(solver, 2) == 1
    @test lgl_deref(solver, 3) == 1
    @test lgl_deref(solver, 4) == -1
    @test lgl_deref(solver, 5) == -1
    lgl_release(solver)
end

@testset "Freezing and Melting" begin
    formula = """
    1 2 -3
    -1 2 3
    1 -2 4
    -4 5 -3
    2 4 5
    2 3
    -2 -5
    5 -4 2
    -2 -4 1
    1 2 3
    -1 -2 3
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    # freeze variables 2, 4, 5
    lgl_freeze(solver, 2)
    lgl_freeze(solver, 4)
    lgl_freeze(solver, 5)
    @test lgl_frozen(solver, 1) == 0
    @test lgl_frozen(solver, 2) == 1
    @test lgl_frozen(solver, 3) == 0
    @test lgl_frozen(solver, 4) == 1
    @test lgl_frozen(solver, 5) == 1
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE

    @test lgl_usable(solver, 1) == 0
    @test lgl_usable(solver, 2) == 1
    @test lgl_usable(solver, 3) == 0
    @test lgl_usable(solver, 4) == 1
    @test lgl_usable(solver, 5) == 1

    additional_formula = """
    2 5
    -2 -4
    2 -5
    """

    add_cnf_sat(solver, additional_formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    @test lgl_deref(solver, 1) == 1
    @test lgl_deref(solver, 2) == 1
    @test lgl_deref(solver, 3) == 1
    @test lgl_deref(solver, 4) == -1
    @test lgl_deref(solver, 5) == -1

    # melt variable 5
    lgl_melt(solver, 5)

    additional_formula = """
    2 4
    """

    add_cnf_sat(solver, additional_formula)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE
    @test lgl_deref(solver, 1) == 1
    @test lgl_deref(solver, 2) == 1
    @test lgl_deref(solver, 3) == 1
    @test lgl_deref(solver, 4) == -1
    @test lgl_deref(solver, 5) == -1

    @test lgl_usable(solver, 1) == 0
    @test lgl_usable(solver, 2) == 1
    @test lgl_usable(solver, 3) == 0
    @test lgl_usable(solver, 4) == 1
    @test lgl_usable(solver, 5) == 0

    @test lgl_frozen(solver, 1) == 0
    @test lgl_frozen(solver, 2) == 1
    @test lgl_frozen(solver, 3) == 0
    @test lgl_frozen(solver, 4) == 1
    @test lgl_frozen(solver, 5) == 0

    lgl_release(solver)

    # error
    formula = """
    1 2 -3
    -1 2 3
    1 -2 4
    -4 5 -3
    2 4 5
    2 3
    -2 -5
    5 -4 2
    -2 -4 1
    1 2 3
    -1 -2 3
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    # freeze variables 2, 4, 5
    lgl_freeze(solver, 2)
    lgl_freeze(solver, 4)
    lgl_freeze(solver, 5)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE

    lgl_meltall(solver)
    result = lgl_sat(solver)
    @test result == Lingeling.SATISFIABLE

    # cannot test this easily as SIGABRT is thrown
    # @test_throws ErrorException lgl_melt(solver, 1)

end

@testset "Unsatisfiable" begin

    formula = """
    1
    -1
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.UNSATISFIABLE
    lgl_release(solver)

    formula = """
    1 2
    -1 -2
    1 -2
    -1 2
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.UNSATISFIABLE
    lgl_release(solver)

    formula = """
    1 2
    2 3
    1 -3
    -1 -2 3
    -2 -3
    1 -3
    -1 -3
    -2 3
    """

    solver = lgl_init()
    add_cnf_sat(solver, formula)
    result = lgl_sat(solver)
    @test result == Lingeling.UNSATISFIABLE
    lgl_release(solver)
end

@testset "Options" begin
    solver = lgl_init()
    @test lgl_hasopt(solver, "seed") == 1
    @test lgl_defopt(solver, "seed") == 0
    @test lgl_getopt(solver, "seed") == 0
    lgl_setopt(solver, "seed", 42)
    @test lgl_getopt(solver, "seed") == 42

    @test lgl_hasopt(solver, "verbose") == 1
    @test lgl_defopt(solver, "verbose") == 0
    @test lgl_getopt(solver, "verbose") == 0
    # verbosity can only go up to 5
    lgl_setopt(solver, "verbose", 42)
    @test lgl_getopt(solver, "verbose") == 5

    lgl_release(solver)

    @test length(lgl_version()) > 0
end

@testset "lglib.h example" begin
    # Initialize solver
    solver = lgl_init()

    # Add first binary clause: -14 ∨ 2
    lgl_add(solver, -14)
    lgl_add(solver, 2)
    lgl_add(solver, 0)  # terminate clause

    # Add second binary clause: 14 ∨ -1
    lgl_add(solver, 14)
    lgl_add(solver, -1)
    lgl_add(solver, 0)  # terminate clause

    # Freeze literals we'll use later
    lgl_freeze(solver, 1)
    lgl_freeze(solver, 14)

    @test lgl_frozen(solver, 1) == 1
    @test lgl_frozen(solver, 14) == 1

    res = lgl_sat(solver)
    @test res == Lingeling.SATISFIABLE  # SATISFIABLE is defined as 10 in the module

    # Check variable assignments
    lgl_deref(solver, 1)   # fine
    lgl_deref(solver, 2)   # fine
    lgl_deref(solver, 3)   # fine
    lgl_deref(solver, 14)  # fine

    @test lgl_usable(solver, 2) == 0
    # Note: lgl_add(solver, 2) would be ILLEGAL here

    @test lgl_usable(solver, 15) == 1  # 15 not used yet!

    # Add new binary clause: -14 ∨ 1
    lgl_add(solver, -14)
    lgl_add(solver, 1)
    lgl_add(solver, 0)

    # Add unit clause: 15
    lgl_add(solver, 15)
    lgl_add(solver, 0)

    lgl_melt(solver, 14)  # 14 discarded

    res = lgl_sat(solver)
    @test res == Lingeling.SATISFIABLE

    @test lgl_frozen(solver, 1) == 1

    # Check variable assignments again
    lgl_deref(solver, 1)
    lgl_deref(solver, 2)
    lgl_deref(solver, 3)
    lgl_deref(solver, 14)
    lgl_deref(solver, 15)

    @test lgl_usable(solver, 2) == 0
    @test lgl_usable(solver, 14) == 0

    # Add unit clause with still frozen literal 1
    lgl_add(solver, 1)
    lgl_melt(solver, 1)
    lgl_add(solver, 0)

    res = lgl_sat(solver)
    @test res == Lingeling.SATISFIABLE

    @test lgl_usable(solver, 1) == 0

    # Disable BCE
    lgl_setopt(solver, "plain", 1)

    # Add binary clause: 8 ∨ -9
    lgl_add(solver, 8)
    lgl_add(solver, -9)
    lgl_add(solver, 0)

    res = lgl_sat(solver)
    @test res == Lingeling.SATISFIABLE

    @test lgl_usable(solver, 8) == 0
    @test lgl_usable(solver, -9) == 0
    @test lgl_reusable(solver, 8) == 1
    @test lgl_reusable(solver, -9) == 1

    # Reuse and add unit clause: -8
    lgl_reuse(solver, 8)
    lgl_add(solver, -8)
    lgl_add(solver, 0)

    # Enable BCE
    lgl_setopt(solver, "plain", 0)

    res = lgl_sat(solver)
    @test res != 0

    # Clean up
    lgl_release(solver)

    res  # Return the final result
end

