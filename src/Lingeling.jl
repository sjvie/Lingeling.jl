module Lingeling

using Lingeling_jll

export LglPtr, lgl_version, lgl_init, lgl_release, lgl_setopt, lgl_getopt, lgl_defopt, lgl_hasopt, lgl_add
export lgl_sat, lgl_deref, lgl_freeze, lgl_frozen, lgl_melt, lgl_meltall, lgl_usable, lgl_reusable, lgl_reuse

"""
Return code meaning unknown result.
"""
const UNKNOWN = 0

"""
Return code meaning the formula is satisfiable.
"""
const SATISFIABLE = 10

"""
Return code meaning the formula is unsatisfiable.
"""
const UNSATISFIABLE = 20

"""
    LglPtr

Wrapper for the Lingeling solver.
The object is fully managed by the Lingeling C library but
the memory needs to be released manually using `lgl_release`.

# Fields
- `ptr::Ptr{Cvoid}`: The pointer to the Lingeling solver.
"""
struct LglPtr
    ptr::Ptr{Cvoid}
end
# type conversion for C interfacing
convert(::Type{Ptr{Cvoid}}, p::LglPtr) = p.ptr

"""
    lgl_version()::String

Return the version of the Lingeling SAT-Solver.

# Returns
- `version::String`: The version of the Lingeling SAT-Solver as a Julia string.
"""
lgl_version() = unsafe_string(@ccall liblgl.lglversion()::Cstring)

"""
    lgl_init()::LglPtr

Initialize (construct) the Lingeling SAT-Solver.

# Returns
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
"""
lgl_init() = @ccall liblgl.lglinit()::LglPtr

"""
    lgl_release(solver::LglPtr)

Destruct the Lingeling SAT-Solver.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
"""
lgl_release(p::LglPtr) = @ccall liblgl.lglrelease(p::LglPtr)::Cvoid

"""
    lgl_setopt(solver::LglPtr, opt::String, val::Integer)

Set an option value.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `opt::String`: The option name.
- `val::Integer`: The new option value.

# Throws
- `InexactError`: If the option value can not be converted to a `Cint`.
"""
lgl_setopt(p::LglPtr, opt::String, val::Integer) = @ccall liblgl.lglsetopt(p::LglPtr, opt::Cstring, val::Cint)::Cvoid

"""
    lgl_getopt(solver::LglPtr, opt::String)::Cint

Get the current option value.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `opt::String`: The option name.

# Returns
- `val::Cint`: The option value for the given option.
"""
lgl_getopt(p::LglPtr, opt::String) = @ccall liblgl.lglgetopt(p::LglPtr, opt::Cstring)::Cint

"""
    lgl_defopt(solver::LglPtr, opt::String)::Cint

Get the default option value.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `opt::String`: The option name.

# Returns
- `val::Cint`: The default option value for the given option.
"""
lgl_defopt(p::LglPtr, opt::String) = @ccall liblgl.lgldefopt(p::LglPtr, opt::Cstring)::Cint

"""
    lgl_hasopt(solver::LglPtr, opt::String)::Cint

Check whether an option exists.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `opt::String`: The option name.

# Returns
- `val::Cint`: Whether the option exists. 1 if it exists, 0 otherwise.
"""
lgl_hasopt(p::LglPtr, opt::String) = @ccall liblgl.lglhasopt(p::LglPtr, opt::Cstring)::Cint

"""
    lgl_add(solver::LglPtr, lit::Integer)

Add a literal of the next clause.  A zero literal terminates the clause.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Cint`: The literal to add. A zero literal terminates the clause. Negative literals are negated.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_add(p::LglPtr, lit::Integer) = @ccall liblgl.lgladd(p::LglPtr, lit::Cint)::Cvoid


"""
    lgl_sat(solver::LglPtr)::Cint

Call the main SAT routine. The return values are as above, e.g.
'Lingeling.UNSATISFIABLE', 'Lingeling.SATISFIABLE', or 'Lingeling.UNKNOWN'.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.

# Returns
- `val::Cint`: The result of the SAT routine. (e.g. 'Lingeling.UNSATISFIABLE', 
'Lingeling.SATISFIABLE', or 'Lingeling.UNKNOWN')
"""
lgl_sat(p::LglPtr) = @ccall liblgl.lglsat(p::LglPtr)::Cint


"""
    lgl_deref(solver::LglPtr, lit::Integer)::Cint

After 'lgl_sat' was called and returned 'Lingeling.SATISFIABLE', then
the satisfying assignment can be obtained by 'dereferencing' literals.
The value of the literal is return as '1' for 'true',  '-1' for 'false'
and '0' for an unknown value.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to dereference.

# Returns
- `val::Cint`: The value of the literal. 1 for true, -1 for false, 0 for unknown.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_deref(p::LglPtr, lit::Integer) = @ccall liblgl.lglderef(p::LglPtr, lit::Cint)::Cint

"""
Incremental interface provides reference counting for indices, i.e.
unfrozen indices become invalid after next 'lgl_sat'.
This is actually a reference counter for variable indices still in use
after the next 'lgl_sat' call.  It is actually variable based
and only applies to literals in new clauses or used as assumptions,
e.g. in calls to 'lgl_add'.
"""

"""
    lgl_freeze(solver::LglPtr, lit::Integer)

Freeze a literal meaning that it will not be eliminated during lgl_sat
so it can be used in future calls to lgl_add.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to freeze.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_freeze(p::LglPtr, lit::Integer) = @ccall liblgl.lglfreeze(p::LglPtr, lit::Cint)::Cvoid

"""
    lgl_frozen(solver::LglPtr, lit::Integer)::Cint

Check whether a literal is frozen.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to check.

# Returns
- `val::Cint`: Whether the literal is frozen. 1 if it is frozen, 0 otherwise.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_frozen(p::LglPtr, lit::Integer) = @ccall liblgl.lglfrozen(p::LglPtr, lit::Cint)::Cint

"""
    lgl_melt(solver::LglPtr, lit::Integer)

Melt a literal meaning that it may be eliminated during lgl_sat.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to melt.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_melt(p::LglPtr, lit::Integer) = @ccall liblgl.lglmelt(p::LglPtr, lit::Cint)::Cvoid

"""
    lgl_meltall(solver::LglPtr)

Melt all literals.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
"""
lgl_meltall(p::LglPtr) = @ccall liblgl.lglmeltall(p::LglPtr)::Cvoid

"""
If a literal was not frozen at the last call to 'lgl_sat'
it becomes 'unusable' after the next call even though it might not
have been used as blocking literal etc.
"""

"""
    lgl_usable(solver::LglPtr, lit::Integer)::Cint

Check whether a literal is usable.
A literal becomes unusable if it was not frozen during the last call to 'lgl_sat'.
Being unusable means that the literal is not allowed to be used in the next call to 'lgl_add'.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to check.

# Returns
- `val::Cint`: Whether the literal is usable. 1 if it is usable, 0 otherwise.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_usable(p::LglPtr, lit::Integer) = @ccall liblgl.lglusable(p::LglPtr, lit::Cint)::Cint

"""
    lgl_reusable(solver::LglPtr, lit::Integer)::Cint

Check whether a literal is reusable.
A literal may not have been frozen during the last call to 'lgl_sat' but
could still be reusable (and thus be made usable again using 'lgl_reuse').

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to check.

# Returns
- `val::Cint`: Whether the literal is reusable. 1 if it is reusable, 0 otherwise.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_reusable(p::LglPtr, lit::Integer) = @ccall liblgl.lglreusable(p::LglPtr, lit::Cint)::Cint

"""
    lgl_reuse(solver::LglPtr, lit::Integer)

Make a literal usable again.
If a literal was not frozen during the last call to 'lgl_sat' but is reusable,
it can be made usable again using this function.

# Arguments
- `solver::LglPtr`: A pointer to the Lingeling SAT-Solver.
- `lit::Integer`: The literal to make reusable again.

# Throws
- `InexactError`: If the literal can not be converted to a `Cint`.
"""
lgl_reuse(p::LglPtr, lit::Integer) = @ccall liblgl.lglreuse(p::LglPtr, lit::Cint)::Cvoid

end # module Lingeling
