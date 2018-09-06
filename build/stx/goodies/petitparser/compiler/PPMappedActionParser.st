"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPActionParser subclass:#PPMappedActionParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Parsers'
!

!PPMappedActionParser methodsFor:'converting'!

asCompilerNode
    ^ PPCMappedActionNode new
        name: self name;
        block: block;
        child: parser;
        properties: properties;
        parser: self;
        yourself

    "Created: / 02-06-2015 / 17:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPMappedActionParser methodsFor:'parsing'!

parseOn: aPPContext
    | element |
    ^ (element := parser parseOn: aPPContext) isPetitFailure
            ifFalse: [ block valueWithArguments: element ]
            ifTrue: [ element ]

    "Created: / 02-06-2015 / 17:15:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

