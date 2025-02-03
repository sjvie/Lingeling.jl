module Lingeling

using Lingeling_jll

export LglPtr, lgl_version, lgl_init, lgl_release, lgl_setopt, lgl_getopt, lgl_defopt, lgl_hasopt, lgl_add
export lgl_sat, lgl_deref, lgl_freeze, lgl_frozen, lgl_melt, lgl_meltall, lgl_usable, lgl_reusable, lgl_reuse

const UNKNOWN = 0
const SATISFIABLE = 10
const UNSATISFIABLE = 20

struct LglPtr
    ptr::Ptr{Cvoid}
end
convert(::Type{Ptr{Cvoid}}, p::LglPtr) = p.ptr

lgl_version() = @ccall liblgl.lglversion()::Cchar

# constructor
lgl_init() = @ccall liblgl.lglinit()::LglPtr

# destructor
lgl_release(p::LglPtr) = @ccall liblgl.lglrelease(p::LglPtr)::Cvoid

# set option value
lgl_setopt(p::LglPtr, opt::String, val::Integer) = @ccall liblgl.lglsetopt(p::LglPtr, opt::Cstring, val::Cint)::Cvoid

# get option value
lgl_getopt(p::LglPtr, opt::String) = @ccall liblgl.lglgetopt(p::LglPtr, opt::Cstring)::Cint

# get default value
lgl_defopt(p::LglPtr, opt::String) = @ccall liblgl.lgldefopt(p::LglPtr, opt::Cstring)::Cint

# exists option?
lgl_hasopt(p::LglPtr, opt::String) = @ccall liblgl.lglhasopt(p::LglPtr, opt::Cstring)::Cint

"""
Add a literal of the next clause.  A zero terminates the clause.
"""
lgl_add(p::LglPtr, lit::Integer) = @ccall liblgl.lgladd(p::LglPtr, lit::Cint)::Cvoid

"""
Call the main SAT routine. The return values are as above, e.g.
'UNSATISFIABLE', 'SATISFIABLE', or 'UNKNOWN'.
"""
lgl_sat(p::LglPtr) = @ccall liblgl.lglsat(p::LglPtr)::Cint

"""
After 'lgl_sat' was called and returned 'SATISFIABLE', then
the satisfying assignment can be obtained by 'dereferencing' literals.
The value of the literal is return as '1' for 'true',  '-1' for 'false'
and '0' for an unknown value.
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
lgl_freeze(p::LglPtr, lit::Integer) = @ccall liblgl.lglfreeze(p::LglPtr, lit::Cint)::Cvoid
lgl_frozen(p::LglPtr, lit::Integer) = @ccall liblgl.lglfrozen(p::LglPtr, lit::Cint)::Cint

lgl_melt(p::LglPtr, lit::Integer) = @ccall liblgl.lglmelt(p::LglPtr, lit::Cint)::Cvoid
lgl_meltall(p::LglPtr) = @ccall liblgl.lglmeltall(p::LglPtr)::Cvoid

"""
If a literal was not frozen at the last call to 'lgl_sat'
it becomes 'unusable' after the next call even though it might not
have been used as blocking literal etc.
"""
lgl_usable(p::LglPtr, lit::Integer) = @ccall liblgl.lglusable(p::LglPtr, lit::Cint)::Cint
lgl_reusable(p::LglPtr, lit::Integer) = @ccall liblgl.lglreusable(p::LglPtr, lit::Cint)::Cint
lgl_reuse(p::LglPtr, lit::Integer) = @ccall liblgl.lglreuse(p::LglPtr, lit::Cint)::Cvoid

end # module Lingeling
