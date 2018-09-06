"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBVariableNode subclass:#RBMetaVariableNode
	instanceVariableNames:'recurseInto isList isLiteral isStatement isAnything'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Parser-Obsolete'
!

RBMetaVariableNode comment:'BRMetaVariableNode is an AST node that is used to match several other types of nodes (literals, variables, value nodes, statement nodes, and sequences of statement nodes).

The different types of matches are determined by the name of the node. If the name contains a # character, then it will match a literal. If it contains, a . then it matches statements. If it contains no extra characters, then it matches only variables. These options are mutually exclusive.

The @ character can be combined with the name to match lists of items. If combined with the . character, then it will match a list of statement nodes (0 or more). If used without the . or # character, then it matches anything except for list of statements. Combining the @ with the # is not supported.

Adding another ` in the name will cause the search/replace to look for more matches inside the node that this node matched. This option should not be used for top level expressions since that would cause infinite recursion (e.g., searching only for "``@anything").

Instance Variables:
	isList	<Boolean>	can we match a list of items (@)
	isLiteral	<Boolean>	only match a literal node (#)
	isStatement	<Boolean>	only match statements (.)
	recurseInto	<Boolean>	search for more matches in the node we match (`)

'
!


!RBMetaVariableNode class methodsFor:'instance creation'!

new
    self halt:'this class is obsolete'.
    ^ super new.
! !

!RBMetaVariableNode methodsFor:'accessing'!

parent: aBRProgramNode 
	"Fix the case where '``@node' should match a single node, not a sequence node."

	super parent: aBRProgramNode.
	parent isSequence 
		ifTrue: 
			[(self isStatement or: [parent temporaries includes: self]) 
				ifFalse: [isList := false]]
! !

!RBMetaVariableNode methodsFor:'initialize-release'!

identifierToken: anIdentifierToken 
	super identifierToken: anIdentifierToken.
	self initializeMetaVariables
!

initializeMetaVariables
        | name |
        name := self name.
        isAnything := isList := isLiteral := isStatement := recurseInto := false.
        2 to: name size
                do: 
                        [:i | 
                        | character |
                        character := name at: i.
                        character == ListCharacter 
                                ifTrue: [isAnything := isList := true]
                                ifFalse: 
                                        [character == LiteralCharacter 
                                                ifTrue: [isLiteral := true]
                                                ifFalse: 
                                                        [character == StatementCharacter 
                                                                ifTrue: [isStatement := true]
                                                                ifFalse: 
                                                                        [character == RecurseIntoCharacter 
                                                                                ifTrue: [recurseInto := true]
                                                                                ifFalse: [^self]]]]]
! !

!RBMetaVariableNode methodsFor:'matching'!

copyInContext: aDictionary 
	^aDictionary at: self
!

match: aNode inContext: aDictionary 
        self isAnything ifTrue: [^(aDictionary at: self ifAbsentPut: [aNode]) = aNode].
        self isLiteral ifTrue: [^self matchLiteral: aNode inContext: aDictionary].
        self isStatement ifTrue: [^self matchStatement: aNode inContext: aDictionary].
        aNode class == self matchingClass ifFalse: [^false].
        ^(aDictionary at: self ifAbsentPut: [aNode]) = aNode
!

matchLiteral: aNode inContext: aDictionary 
        ^aNode class == RBLiteralNode 
                and: [(aDictionary at: self ifAbsentPut: [aNode]) = aNode]
!

matchStatement: aNode inContext: aDictionary 
	(aNode parent notNil and: [aNode parent isSequence]) ifFalse: [^false].
	^(aDictionary at: self ifAbsentPut: [aNode]) = aNode
! !

!RBMetaVariableNode methodsFor:'private'!

matchingClass
        ^RBVariableNode
! !

!RBMetaVariableNode methodsFor:'testing-matching'!

isAnything
	^isAnything
!

isList
	^isList
!

isLiteral
	^isLiteral
!

isStatement
	^isStatement
!

recurseInto
	^recurseInto
! !

!RBMetaVariableNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBMetaVariableNode.st,v 1.7 2006-02-13 14:55:17 cg Exp $'
! !
