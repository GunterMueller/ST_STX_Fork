"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCAncestryTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCAncestryTest methodsFor:'asserting'!

assertCommonAncestorOf: leftName and: rightName in: options in: tree
	| left right ancestor |
	left _ self versionForName: leftName in: tree.
	right _ self versionForName: rightName in: tree.
	
	ancestor _ left commonAncestorWith: right.
	
	self assert: (options includes: ancestor name)
!

assertCommonAncestorOf: leftName and: rightName is: ancestorName in: tree
	self assertCommonAncestorOf: leftName and: rightName in: (Array with: ancestorName) in: tree
!

assertNamesOf: versionInfoCollection are: nameArray
	| names |
	names _ versionInfoCollection collect: [:ea | ea name].
	
	self assert: names asArray = nameArray
!

assertPathTo: aSymbol is: anArray
	self
		assertNamesOf: (self tree allAncestorsOnPathTo: (self treeFrom: {aSymbol}))
		are: anArray
! !

!MCAncestryTest methodsFor:'building'!

tree
	^ self treeFrom:
		#(c1
			((e2
				((e1
					((a1
						(('00')))))))
			(a2
				((a1
					(('00')))))
			(b3
				((b2
					((b1
						((b0
							(('00')))))))
				(a1
					(('00')))))
			(d1)))
!

twoPersonTree
	^ self treeFrom:
		#(c1
			((a4
				((a1)
				(b3
					((b2
						((a1)))))))
			(b5
				((b2
					((a1)))))))
!

versionForName: name in: tree
	(tree name = name) ifTrue: [^ tree].
	
	tree ancestors do: [:ea | (self versionForName: name in: ea) ifNotNilDo: [:v | ^ v]].
	
	^ nil
! !

!MCAncestryTest methodsFor:'tests'!

testCommonAncestors
	self assertCommonAncestorOf: #a2 and: #e2 is: #a1 in: self tree.
	self assertCommonAncestorOf: #e2 and: #b3 is: #a1 in: self tree.
	self assertCommonAncestorOf: #b2 and: #e2 is: #'00' in: self tree.
	
	self assertCommonAncestorOf: #a4 and: #b5 in: #(b2 a1) in: self twoPersonTree.
	self assertCommonAncestorOf: #b5 and: #b3 is: #b2 in: self twoPersonTree.
	self assertCommonAncestorOf: #b2 and: #a4 is: #b2 in: self twoPersonTree.
	self assertCommonAncestorOf: #b2 and: #b2 is: #b2 in: self twoPersonTree.
	self assertCommonAncestorOf: #b2 and: #a1 is: #a1 in: self twoPersonTree.
	self assertCommonAncestorOf: #a1 and: #b2 is: #a1 in: self twoPersonTree.
!

testDescendants
	| c1 a1 b3 q1 q2 c2 |
	c1 _ self tree.
	a1 _ self treeFrom: #(a1 (('00'))).
	b3 _ self treeFrom: #(b3
				((b2
					((b1
						((b0
							(('00')))))))
				(a1
					(('00'))))).
	q1 _ MCWorkingAncestry new addAncestor: a1.
	q2 _ MCWorkingAncestry new addAncestor: q1.
	self assert: (q2 commonAncestorWith: b3) = a1.
	self assert: (b3 commonAncestorWith: q2) = a1.
	self assert: (q2 commonAncestorWith: c1) = a1.
	self assert: (c1 commonAncestorWith: q2) = a1.
	q1 addStepChild: c1.
	self assert: (q2 commonAncestorWith: c1) = q1.
	self assert: (c1 commonAncestorWith: q2) = q1.
	c2 _ MCWorkingAncestry new addAncestor: c1.
	self assert: (q2 commonAncestorWith: c2) = q1.
	self assert: (c2 commonAncestorWith: q2) = q1.
!

testLinearPath
	self assertPathTo: #b1 is: #(b3 b2)
!

testPathToMissingAncestor
	self assert: (self tree allAncestorsOnPathTo: MCVersionInfo new) isEmpty
! !

!MCAncestryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCAncestryTest.st,v 1.2 2013-05-29 00:00:46 vrany Exp $'
! !

