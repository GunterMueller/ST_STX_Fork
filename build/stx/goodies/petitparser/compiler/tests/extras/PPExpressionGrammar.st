"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#PPExpressionGrammar
	instanceVariableNames:'add prod term mul prim parens number'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Expressions'
!

!PPExpressionGrammar methodsFor:'as yet unclassified'!

add
   ^ prod , $+ asParser trimmingToken , term
!

mul
   ^ prim , $* asParser trimmingToken , prod
!

number
   ^ #digit asParser plus trimmingToken ==> [ :token | token inputValue asNumber ]
!

parens
   ^ ($( asParser token trim), term , ($) asParser token trim)
!

prim
   ^ parens / number
!

prod
   ^ mul / prim
!

start
   ^ term end
!

term
   ^ add / prod
! !

