"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsBranch
	instanceVariableNames:'piece branch'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsBranch comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A Branch is a Piece followed by a Branch or an empty string.

Instance variables:
	piece           <RxsPiece>
	branch          <RxsBranch|RxsEpsilon>'
!

!RxsBranch class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsBranch methodsFor:'accessing'!

branch

	^branch
!

dispatchTo: aMatcher
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aMatcher syntaxBranch: self
!

piece

	^piece
! !

!RxsBranch methodsFor:'initialize-release'!

initializePiece: aPiece branch: aBranch
	"See class comment for instance variables description."

	piece := aPiece.
	branch := aBranch
! !

!RxsBranch methodsFor:'optimization'!

tryMergingInto: aStream
	"Concatenation of a few simple characters can be optimized
	to be a plain substring match. Answer the node to resume
	syntax tree traversal at. Epsilon node used to terminate the branch
	will implement this to answer nil, thus indicating that the branch
	has ended."

	piece isAtomic ifFalse: [^self].
	aStream nextPut: piece character.
	^branch isNil
		ifTrue: [branch]
		ifFalse: [branch tryMergingInto: aStream]
! !

!RxsBranch methodsFor:'testing'!

isNullable

	^piece isNullable and: [branch isNil or: [branch isNullable]]
! !

!RxsBranch class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsBranch.st,v 1.5 2009-10-01 07:05:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsBranch.st,v 1.5 2009-10-01 07:05:42 cg Exp $'
! !
