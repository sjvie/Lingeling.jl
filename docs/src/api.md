# API Reference

## General

```@docs
LglPtr
```

```@docs
lgl_version()
```

```@docs
lgl_init()
```

```@docs
lgl_release(solver::LglPtr)
```

## Options

```@docs
lgl_setopt(solver::LglPtr, opt::String, val::Integer)   
```

```@docs
lgl_getopt(solver::LglPtr, opt::String)
```

```@docs
lgl_defopt(solver::LglPtr, opt::String)
```

```@docs
lgl_hasopt(solver::LglPtr, opt::String)
```

## Solving

```@docs
lgl_add(solver::LglPtr, lit::Integer)
```

```@docs
lgl_sat(solver::LglPtr)
```

```@docs
Lingeling.UNKNOWN
```

```@docs
Lingeling.SATISFIABLE
```

```@docs
Lingeling.UNSATISFIABLE
```

```@docs
lgl_deref(solver::LglPtr, lit::Integer)
```

```@docs
lgl_freeze(solver::LglPtr, lit::Integer)
```

```@docs
lgl_frozen(solver::LglPtr, lit::Integer)
```

```@docs
lgl_melt(solver::LglPtr, lit::Integer)
```

```@docs
lgl_meltall(solver::LglPtr)
```

```@docs
lgl_usable(solver::LglPtr, lit::Integer)
```

```@docs
lgl_reusable(solver::LglPtr, lit::Integer)
```

```@docs
lgl_reuse(solver::LglPtr, lit::Integer)
```
