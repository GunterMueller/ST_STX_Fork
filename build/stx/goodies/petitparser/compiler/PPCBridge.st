"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPCBridge
	instanceVariableNames:'selector'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!

!PPCBridge class methodsFor:'as yet unclassified'!

on: aSymbol
    ^ self new
        selector: aSymbol;
        yourself
! !

!PPCBridge methodsFor:'as yet unclassified'!

call
    ^ 'self callParser: ', self id, '.'.
!

selector: aSymbol
    selector := aSymbol
! !

!PPCBridge methodsFor:'parsing'!

parseOn: aPPContext
    | retval |
    retval := (aPPContext compiledParser) perform: selector.
    (aPPContext compiledParser isError) ifTrue: [ 
        aPPContext compiledParser clearError.		
        ^ PPFailure message: 'error' context: aPPContext 
    ].
    ^ retval
! !

