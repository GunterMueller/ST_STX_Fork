# Makefile library for Smalltalk/X jv-branch

This directory contains makefiles for building individual 
Smalltalk/X packages. 


## Background & Rationale

Essentially this is a replacement for eXept's definitions in 
`stx/configurations` and `stx/rules`. eXept's makefiles don't fit 
Smalltalk/X jv-branch needs. In the past, we used to monkey-patch eXept's 
makefiles and tweak them here and there, but this lead to a big mess (not a 
surprise) in `rakelib/compile.rake`. 

As we want to support more OS/CPU combinations, thing would go rather
wild and truly messy. Hence we provide our own, starting off with
eXept's definition. The plan is eventually to clean them up to the point
we understand how it works and then rewrite build process of individual 
packages to unify *NIX and Windows builds (since Windows now use different
schema based on ancient, unmaintained Borland make).

Time will show if this ever become true. Let's hope. 


