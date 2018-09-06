"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PPCInliningVisitor
	instanceVariableNames:'canInline acceptedNodes'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!


!PPCInliningVisitor methodsFor:'initialization'!

initialize
    super initialize.        
    acceptedNodes := 0

    "Modified (format): / 29-08-2015 / 07:40:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCInliningVisitor methodsFor:'testing'!

canInline
    ^ acceptedNodes > 1
! !

!PPCInliningVisitor methodsFor:'visiting'!

beforeAccept: node
    acceptedNodes := acceptedNodes + 1.
    super beforeAccept: node
!

markForInline: node
    self canInline ifTrue: [ 
        node markForInline.
    ].
    ^ node
!

visitActionNode: node
    "Only mark unnamed sequence nodes for inlining.
     Named nodes should not be inlined as they should make a method.
     There's little point in inlining non-sequence nodes, so don't
     enforce inlining on those. Some (JK :-) may prefer them non-inlined
     (for debugging purposes)"
    (node child isSequenceNode and:[node child name isNil]) ifTrue: [ node child markForInline ].
    ^ super visitActionNode: node.

    "Created: / 13-05-2015 / 16:25:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2015 / 08:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitCharSetPredicateNode: node
    ^ self markForInline: node
!

visitCharacterNode: node
    ^ self markForInline: node
!

visitLiteralNode: node
    ^ self markForInline: node
!

visitMessagePredicateNode: node
    ^ self markForInline: node
!

visitNilNode: node
    ^ self markForInline: node
!

visitNotCharSetPredicateNode: node
    ^ self markForInline: node
!

visitNotLiteralNode: node
    ^ self markForInline: node
!

visitNotMessagePredicateNode: node
    ^ self markForInline: node
!

visitPluggableNode: node
    "Sadly, on Smalltalk/X blocks cannot be inlined because
     the VM does not provide enough information to map
     it back to source code. Very bad indeed!!"
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifFalse:[
			self markForInline: node
    ].
    ^ super visitPluggableNode: node.

    "Modified: / 23-04-2015 / 12:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitStarCharSetPredicateNode: node
    ^ self markForInline: node
!

visitStarMessagePredicateNode: node
    ^ self markForInline: node
!

visitTokenStarMessagePredicateNode: node
    ^ self markForInline: node
!

visitTokenStarSeparatorNode: node
    ^ self markForInline: node
!

visitTokenWhitespaceNode: node
    super visitTokenWhitespaceNode: node.
    self markForInline: node.
    ^ node
!

visitTokenizingParserNode: node
    "skip tokens"
    "skip whitespace"
    "self visit: node whitespace."

    self visit: node parser.
    
    ^ node
! !

!PPCInliningVisitor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

