"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBValueNode subclass:#RBVariableNode
	instanceVariableNames:'token'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBVariableNode comment:'BRVariableNode is an AST node that represent a variable (global, inst var, temp, etc.).

Instance Variables:
	token	<BRValueToken>	the token that contains our name and position

'
!


!RBVariableNode class methodsFor:'instance creation'!

identifierToken: anIdentifierToken 
	^(anIdentifierToken isPatternVariable 
		ifTrue: [RBPatternVariableNode]
		ifFalse: [RBVariableNode]) new 
		identifierToken: anIdentifierToken
!

named: aString 
        ^self identifierToken: (RBIdentifierToken value: aString start: 0)
! !

!RBVariableNode methodsFor:'accessing'!

addReferencedVariablesTo:aCollection
    aCollection add:self
!

definingSequence
    "Return the sequenceNode (i.e. the scope) that defines this variable
     or nil, if no sequenceNode does"

    | owner |

    owner := parent.
    [ owner notNil ] whileTrue:[
        owner isSequence ifTrue:[
            (owner defines: self name) ifTrue:[ ^ owner ]
        ].
        owner := owner parent.
    ].
    ^nil

    "Created: / 06-09-2012 / 16:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
	^token value
!

name: aString
        ^token value: aString

    "Created: / 19-06-2015 / 07:03:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

precedence
	^0
!

startWithoutParentheses
	^token start
!

stopWithoutParentheses
	^token stop
!

token
    ^ token

    "Created: / 07-10-2014 / 23:27:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenPosition
        ^token position
! !

!RBVariableNode methodsFor:'comparing'!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self name = anObject name
!

equalTo: anObject withMapping: aDictionary 
        "return true, if I am equal to another node, with a given variable name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        |otherName|
        self class = anObject class ifFalse: [^false].
        otherName := anObject name.
        ^(aDictionary at: self name ifAbsentPut: [otherName]) = otherName
!

equalTo: anObject withSelectorMapping: aDictionary 
        "return true, if I am equal to another node, with a given selector name mapping.
         Side effect: update the mapping dictionary as required to reflect a matching mapping (if possible)"

        self class = anObject class ifFalse: [^false].
        ^ self name = anObject name.
!

hash
	^self name hash
! !

!RBVariableNode methodsFor:'copying'!

postCopy
    super postCopy.
    token := token copy.

    "Created: / 28-07-2015 / 06:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBVariableNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "evaluate a Block for all variable nodes."

    aBlock value:self

    "Modified: / 16-11-2016 / 20:01:57 / cg"
! !

!RBVariableNode methodsFor:'initialization & release'!

identifierToken: anIdentifierToken 
	token := anIdentifierToken
! !

!RBVariableNode methodsFor:'libtool3 support'!

highlightInCodeView: aCodeView

    ^aCodeView highlightVariableNode: self

    "Created: / 18-02-2008 / 17:51:44 / janfrog"
!

leftClickMenuInCodeView: aCodeView 
    ^ aCodeView leftClickMenuForVariableNode: self.

    "Created: / 01-09-2009 / 08:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rightClickMenuInCodeView: aCodeView 
    ^ aCodeView rightClickMenuForVariableNode: self.

    "Created: / 18-02-2008 / 21:05:04 / janfrog"
! !

!RBVariableNode methodsFor:'matching'!

copyInContext: aDictionary 
	^self class identifierToken: token removePositions
! !

!RBVariableNode methodsFor:'testing'!

isGlobal
    "Return true if the variable node is for
     a global variable, false otherwise.
     Actually wrong: also returns true for inst- and class variables
     (i.e. anything that is not a block- or method local)"

    ^self definingSequence isNil
!

isImmediate
	^true
!

isInstanceVariable
    "not true - also returns true for class vars and globals"
    
    self isSelf ifTrue:[^ false].
    self isSuper ifTrue:[^ false].
    self isLocal ifTrue:[^ false].
    ^ true
!

isLocal
    "Return true if the variable node is for
     a local variable, false otherwise.
     Returns true for anything that is a block- or method local"

    self isSelf ifTrue:[^ false].
    self isSuper ifTrue:[^ false].
    ^self definingSequence notNil
!

isRead
    "Return true, if the variable is read"

    | root |

    parent isNil ifTrue:[ ^ false ].
    root := self definingSequence.
    root isNil ifTrue:[
        "OK, not a temporary, search from top-most node"
        [ root parent notNil ] whileTrue:[ root := root parent ].
    ].

    ^root reads: self name

    "Created: / 06-09-2012 / 17:13:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSelf
    "true if I am the self-variable node"

    ^ self name = 'self'

    "Created: / 17-07-2011 / 10:28:56 / cg"
!

isSuper
    ^ self name = 'super'

    "Created: / 17-07-2011 / 10:29:29 / cg"
!

isTemporary
    "Return true if the variable node is for
     a temporary variable, false otherwise"

    ^self definingSequence notNil

    "Created: / 06-09-2012 / 16:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariable
	^true
!

isVariableNotInLeftHandSideOfAssignment
    "Returns true iff receiver is variable node but not
     in left-hand side of assignment"    
    ^self parent isAssignment not 
        or:[self parent variable ~~ self]

    "Created: / 28-03-2012 / 17:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWrite
    "Same as isWritten - bad naming here"
    ^self isWritten

    "Modified: / 06-09-2012 / 17:09:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWritten
    "Return true, if the variable is written"

    | root |

    parent isNil ifTrue:[ ^ false ].
    root := self definingSequence.
    root isNil ifTrue:[
        "OK, not a temporary, search from top-most node"
        [ root parent notNil ] whileTrue:[ root := root parent ].
    ].

    ^root assigns: self name

    "Created: / 06-09-2012 / 17:07:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reads: variableName
    ^self name = variableName

    "Created: / 06-09-2012 / 17:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

references: aVariableName 
	^self name = aVariableName
! !

!RBVariableNode methodsFor:'visitor'!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptVariableNode: self
! !

!RBVariableNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

