"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNodeVisitor subclass:#PPCPassVisitor
	instanceVariableNames:'context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCPassVisitor class methodsFor:'converting'!

asPPCPass
    ^ self new

    "Created: / 29-08-2015 / 07:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPassVisitor methodsFor:'accessing'!

context
    ^ context
!

context: aPPCCompilationContext
    context := aPPCCompilationContext.

    "Created: / 26-08-2015 / 22:05:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPassVisitor methodsFor:'converting'!

asPPCPass
    ^ self

    "Created: / 29-08-2015 / 07:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPassVisitor methodsFor:'running'!

run: ir
    "Actually run the pass on given IR (tree of PPCNode) and return
     (possibly transformed or completely new) another IR."

    context isNil ifTrue:[ 
        PPCCompilationError new signal: 'oops, no context set, use #context: before running a pass!!'.
    ].
    ^ self visit: ir.

    "Created: / 26-08-2015 / 22:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run: ir in: ctx
    "Actually run the pass on given IR (tree of PPCNode) in given
     compilation context and return (possibly transformed or completely 
     new) another IR."

    context := ctx.
    ^ self run: ir.

    "Created: / 26-08-2015 / 22:33:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCPassVisitor class methodsFor:'documentation'!

version
    ^ 'Path: stx/goodies/petitparser/compiler/PPCPass.st, Version: 1.0, User: jv, Time: 2015-08-29T07:53:24.558+01'
!

version_HG
    ^ 'Path: stx/goodies/petitparser/compiler/PPCPass.st, Version: 1.0, User: jv, Time: 2015-08-29T07:53:24.558+01'
! !

