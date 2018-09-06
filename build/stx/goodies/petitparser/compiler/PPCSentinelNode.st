"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNilNode subclass:#PPCSentinelNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

PPCSentinelNode class instanceVariableNames:'Instance'

"
 No other class instance variables are inherited by this class.
"
!

!PPCSentinelNode class methodsFor:'as yet unclassified'!

instance
    ^ Instance ifNil: [ Instance := self basicNew ]
! !

