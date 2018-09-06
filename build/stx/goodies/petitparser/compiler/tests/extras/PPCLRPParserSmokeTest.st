"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#PPCLRPParserSmokeTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPParserSmokeTest class methodsFor:'accessing'!

resources
    ^ (OrderedCollection with: PPCLRPSourcesResource)
        addAll: super resources;
        yourself

    "Created: / 30-07-2015 / 19:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPParserSmokeTest methodsFor:'accessing'!

parserClass
    "superclass PPCompositeParserTest says that I am responsible to implement this method"

    ^ PPCLRPParser

    "Modified: / 30-07-2015 / 19:07:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPParserSmokeTest methodsFor:'tests'!

testSmoke1
    PPCLRPSourcesResource current sources do:[:source | 
        self parse: source
    ].

    "Created: / 30-07-2015 / 19:07:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCLRPParserSmokeTest class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

