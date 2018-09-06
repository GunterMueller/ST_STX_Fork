"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCPass
	instanceVariableNames:'context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!

!PPCPass class methodsFor:'converting'!

asPPCPass
    ^ self new

    "Created: / 29-08-2015 / 07:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPass methodsFor:'accessing'!

context
    ^ context
!

context:aPPCCompilationContext
    context := aPPCCompilationContext.
! !

!PPCPass methodsFor:'converting'!

asPPCPass
    ^ self

    "Created: / 29-08-2015 / 07:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPass methodsFor:'running'!

run: ir
    "Actually run the pass on given IR (tree of PPCNode) and return
     (possibly transformed or completely new) another IR."

    self subclassResponsibility

    "Created: / 26-08-2015 / 22:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-08-2015 / 07:15:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: ir in: ctx
    "Actually run the pass on given IR (tree of PPCNode) in given
     compilation context and return (possibly transformed or completely 
     new) another IR."

    context := ctx.
    ^ self run: ir.

    "Created: / 26-08-2015 / 22:33:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

