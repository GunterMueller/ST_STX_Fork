"{ Package: 'stx:goodies/monticello/test' }"

MCTestCase subclass:#MCScannerTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCScannerTest methodsFor:'asserting'!

assertScans: anArray
        Smalltalk isSmalltalkX ifTrue:[
            self assert: (MCScanner scan: anArray storeString readStream) = anArray
        ] ifFalse:[
            self assert: (MCScanner scan: anArray printString readStream) = anArray
        ]
! !

!MCScannerTest methodsFor:'tests'!

test1
	self assertScans: #(a '23' (x))
!

test2
	self assertScans: 'it''s alive'
!

test3
	self assert: (MCScanner scan: '(a #b c)' readStream) = #(a #b c)
!

test4
	self assertScans: #(a '23' (x () ')''q' y12)).
!

test5
	self assertScans: #((a) b)
!

test6
	self should: [MCScanner scan: '(a b' readStream] raise: Error
! !

!MCScannerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCScannerTest.st,v 1.3 2013-05-29 00:02:49 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCScannerTest.st,v 1.3 2013-05-29 00:02:49 vrany Exp $'
! !

