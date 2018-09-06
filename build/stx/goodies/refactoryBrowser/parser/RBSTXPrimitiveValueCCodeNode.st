"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBSTXPrimitiveValueCCodeNode
	instanceVariableNames:'codeToken'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!


!RBSTXPrimitiveValueCCodeNode methodsFor:'accessing'!

codeToken
    "return the value of the instance variable 'codeToken' (automatically generated)"

    ^ codeToken
!

codeToken:something
    "set the value of the instance variable 'codeToken' (automatically generated)"

    codeToken := something.
!

formattedCode
    ^ codeToken value  " is already formatted "
!

lastLineNumber
    |lastLineNr firstLineNr|

    lastLineNr := super lastLineNumber.
    lastLineNr isNil ifTrue:[
        firstLineNr := codeToken lineNumber.
        lastLineNr := firstLineNr + codeToken value asCollectionOfLines size - 1.
    ].
    ^ lastLineNr
!

start
    ^ codeToken start.
!

startWithoutParentheses
    ^ self start.
!

stop
    ^ codeToken stop.
!

stopWithoutParentheses
    ^ self stop.
! !

!RBSTXPrimitiveValueCCodeNode methodsFor:'comparing'!

= anObject 
        self == anObject ifTrue: [^true].
        self class = anObject class ifFalse: [^false].
        ^ self codeToken value = anObject codeToken value
! !

!RBSTXPrimitiveValueCCodeNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
    ^ aProgramNodeVisitor acceptSTXPrimitiveValueCCodeNode: self
! !

!RBSTXPrimitiveValueCCodeNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBSTXPrimitiveValueCCodeNode.st,v 1.5 2006-02-20 12:54:08 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

