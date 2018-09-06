"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCCompilationContext
	instanceVariableNames:'options compiler parserClass scannerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!

!PPCCompilationContext class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCCompilationContext methodsFor:'accessing'!

idGenerator
    ^ self parserClass idGen

    "Created: / 03-09-2015 / 21:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

options
    ^ options
!

options:optionsOrOptionArray
    "Set options used for compilation. 
     `optionsOrOptionArray` may be either an instance of
     PPCCompilationOptions or and array specifing options.
     See PPCCompilationOptions class>>from: for details."

    optionsOrOptionArray isSequenceable ifTrue:[ 
        options := PPCCompilationOptions from: optionsOrOptionArray
    ] ifFalse:[
        options := optionsOrOptionArray.
    ]

    "Modified: / 07-09-2015 / 10:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserClass
    "Return parser class as PPCClass"

    parserClass isNil ifTrue:[
        parserClass := PPCClass new.
    ].
    ^ parserClass

    "Created: / 24-08-2015 / 23:58:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerClass
    "Return scanner class as PPCClass"

    scannerClass isNil ifTrue:[
        scannerClass := PPCClass new.
        "Both parser class and scanner class must share the
         same ID generator in order to to use same names 
         for tokens."
        scannerClass idGen: self parserClass idGen
    ].
    ^ scannerClass

    "Created: / 24-08-2015 / 23:59:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCCompilationContext methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    options := PPCCompilationOptions new.

    "Modified: / 07-09-2015 / 10:22:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

