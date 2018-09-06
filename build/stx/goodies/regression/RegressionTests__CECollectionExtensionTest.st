"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CECollectionExtensionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-CollectionExtensions'
!

!CECollectionExtensionTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CECollectionExtensionTest methodsFor:'as yet unclassified'!

testDetectIfOne
	| element result |
	result := #(1 2 3) detect: [:each | each = 2] ifOne: [:theOne | element := theOne ].
	self assert: element = 2.
	self assert: result = 2.

	element := nil.
	result := #(1 2 3) detect: [:each | each = 4] ifOne: [:theOne | element := theOne ].
	self assert: element isNil.
	self assert: result isNil.
!

testDetectIfOneIfNone
	| element |
	#(1 2 3) detect: [:each | each = 2] ifOne: [:theOne | element := theOne ] ifNone: [element := nil].
	self assert: element = 2.

	#(1 2 3) detect: [:each | each = 4] ifOne: [:theOne | element := theOne ] ifNone: [element := nil].
	self assert: element isNil.
! !

!CECollectionExtensionTest methodsFor:'collect as set'!

testCollectAsSet
	"self debug: #testCollectAsSet"
	
	self assert: ((#() collectAsSet: [:each | each odd]) = Set new).
	self assert: (#(1 2 3 4 5 6) collectAsSet: [:each | each odd])
					 = (Set with: true with: false).
	self assert: (#(1 3 5 7 9 11) collectAsSet: [:each | each odd]) 
					= (Set with: true).
					
	self assert: (#(1 2 3 4 5 4 3 2 1) collectAsSet: [:each | each]) = (1 to: 5) asSet.
	
	
!

testCollectAsSetUsingSymbol
	"self debug: #testCollectAsSetUsingSymbol"
	
	self assert: ((#() collectAsSet: #odd) = Set new).
	self assert: (#(1 2 3 4 5 6) collectAsSet: #odd)
					 = (Set with: true with: false).
	self assert: (#(1 3 5 7 9 11) collectAsSet: #odd) 
					= (Set with: true).
! !

!CECollectionExtensionTest methodsFor:'flat collect'!

testFlatCollect
	"self debug: #testFlatCollect"
	
	
!

testFlatCollectArray
	"self debug: #testFlatCollectArray"
	
	self assert: ((#((1 2) (3 4) (5 3)) flatCollect: [ :each | each ]) = #(1 2 3 4 5 3)).
	self assert: ((#((1 2) (2 3) (1 3 4)) flatCollect: [:each | each]) = #(1 2 2 3 1 3 4)). 	
		
	self assert: ((#((1 2) (2 3) () ()) flatCollect: [:each | each]) = #(1 2 2 3)). 

	self assert: ((#((1 2) (2 3) (1 3 4)) flatCollect: [:each| Array with: each])
					=  #(#(1 2) #(2 3) #(1 3 4))).
					
	self assert: ((#((1 2) (2 3) (1 3 4)) flatCollect: [:each| Set with: each])
					=  #(#(1 2) #(2 3) #(1 3 4))).	
	
! !

!CECollectionExtensionTest methodsFor:'flatten'!

testDeepFlatten

	self assert: #(1 2 3)
		equals: #((1) (2) (3)) deepFlatten.
	self assert: #(1 2 3 1 2)
		equals: #((1 2) (3 1 2)) deepFlatten.
!

testDeepFlattenIsRecursive

	self assert: #(1 2 4 5 3)
		equals: #((1 2) ((4 5) 3)) deepFlatten.
!

testDeepFlattenOnFlatCollection

	self assert: #(1 2 4)
		equals: #(1 2 4) deepFlatten.
	self assert: #(5 3)
		equals: #(5 ((3))) deepFlatten.
!

testDeepFlattenOnString
	"don't flatten strings"

	self assert: #(a b c d e)
		equals: #((a b) ((c d) e)) deepFlatten.
	self assert: #('foo' 'bar' 'zorg')
		equals: #(('foo' ('bar')) 'zorg') deepFlatten
!

testFlatten

	self assert: #(1 2 3)
		equals: #((1) (2) (3)) flatten.
	self assert: #(1 2 3 1 2)
		equals: #((1 2) (3 1 2)) flatten.
	self assert: #(a b (c d))
		equals: #((a b) ((c d))) flatten.
	self should: [ #((1 2) 3) flatten ] raise: Error.
! !

!CECollectionExtensionTest methodsFor:'groupedBy'!

testGroupedBy
	"self debug: #testGroupedBy"
	
	| res |
	res := #(1 2 3 4 5) asOrderedCollection 
				groupedBy: [:each | each odd].
	self assert:   (res at: true) = #(1 3 5) asOrderedCollection.
	self assert: (res at: false) = #(2 4) asOrderedCollection
!

testGroupedByArray
	"self debug: #testGroupedByArray"
	
	| res |
	res := #(1 2 3 4 5) groupedBy: [:each | each odd].
	self assert:   (res at: true) = #(1 3 5).
	self assert: (res at: false) = #(2 4)
!

testGroupedBySet
	"self debug: #testGroupedBySet"
	
	| res |
	res := #(1 2 3 4 5 3 4 5) asSet groupedBy: [:each | each odd].
	self assert: (res at: true) = #(1 3 5) asSet.
	self assert: (res at: false) = #(2 4) asSet
! !

!CECollectionExtensionTest methodsFor:'symbol - value'!

testSymbolInPlaceOfBlock
	"self debug: #testSymbolInPlaceOfBlock"
	
	self assert: (#(1 2 3 4) collect: #odd) =  #(true false true false).
	self assert: (#(1 2 3 4) select: #odd) =  #(1 3).
! !

!CECollectionExtensionTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

