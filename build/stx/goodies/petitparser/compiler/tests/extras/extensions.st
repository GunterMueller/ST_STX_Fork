"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"!

!PPJavaWhitespaceParser methodsFor:'*PetitCompiler-Extras-Tests'!

= anotherParser
    anotherParser == self ifTrue: [ ^ true ].
   anotherParser class = self class ifFalse: [ ^ false ].
 ^ anotherParser name = self name
! !

!PPJavaWhitespaceParser methodsFor:'*PetitCompiler-Extras-Tests'!

hash
    ^ self name hash
! !

!stx_goodies_petitparser_compiler_tests_extras class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
