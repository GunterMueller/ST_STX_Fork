"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CESequenceableCollectionExtensionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-CollectionExtensions'
!


!CESequenceableCollectionExtensionTest methodsFor:'tests'!

testPairsSimilarityWith
	
	self assert: ('1234' pairsSimilarityWith: '2234') equals: (2/3).
	self assert: ('1234' pairsSimilarityWith: '123') equals: (4/5).
	self assert: ('1234' pairsSimilarityWith: '5678') equals: 0
! !

!CESequenceableCollectionExtensionTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

