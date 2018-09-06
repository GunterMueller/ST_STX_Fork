"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBVariableNode subclass:#RBPatternVariableNode
	instanceVariableNames:'recurseInto isList isLiteral isStatement isAnything
		isIgnoredInMatch isUppercase'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBPatternVariableNode comment:'BRMetaVariableNode is an AST node that is used to match several other types of nodes (literals, variables, value nodes, statement nodes, and sequences of statement nodes).

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

!RBPatternVariableNode class methodsFor:'documentation'!

documentation
"
    extensions to the original RBVariable:
        'V (uppercase variable) - global variable
"
! !

!RBPatternVariableNode methodsFor:'accessing'!

isUppercase
    ^ isUppercase
!

parent: aBRProgramNode 
	"Fix the case where '``@node' should match a single node, not a sequence node."

	super parent: aBRProgramNode.
	parent isSequence 
		ifTrue: 
			[(self isStatement or: [parent temporaries includes: self]) 
				ifFalse: [isList := false]]
! !

!RBPatternVariableNode methodsFor:'enumeration'!

variableNodesDo:aBlock
    "/ intentionally left blank

    "Created: / 16-11-2016 / 20:01:46 / cg"
! !

!RBPatternVariableNode methodsFor:'initialize-release'!

identifierToken: anIdentifierToken 
	super identifierToken: anIdentifierToken.
	self initializePatternVariables
!

initializePatternVariables
    |name|

    name := self name.
    isAnything := isList := isLiteral := isStatement := recurseInto := isIgnoredInMatch := isUppercase := false.
    2 to:name size do:[:i | 
        |character|

        character := name at:i.
        character == ListCharacter ifTrue:[
            isAnything := isList := true
        ] ifFalse:[
            character == LiteralCharacter ifTrue:[
                isLiteral := true
            ] ifFalse:[
                character == StatementCharacter ifTrue:[
                    isStatement := true
                ] ifFalse:[
                    character == RecurseIntoCharacter ifTrue:[
                        recurseInto := true
                    ] ifFalse:[
                        character == IgnoreInMatchCharacter ifTrue:[
                            isIgnoredInMatch := true
                        ] ifFalse:[ 
                            character isLetter ifTrue:[
                                isUppercase := character isUppercase
                            ].
                            ^ self 
                        ]
                    ]
                ]
            ]
        ]
    ]

    "Modified: / 08-08-2011 / 16:48:03 / cg"
! !

!RBPatternVariableNode methodsFor:'matching'!

copyInContext: aDictionary 
	^aDictionary at: self
!

match: aNode inContext: aDictionary 
    self isAnything ifTrue: [^(aDictionary at: self ifAbsentPut: [aNode]) = aNode].
    self isLiteral ifTrue: [^self matchLiteral: aNode inContext: aDictionary].
    self isStatement ifTrue: [^self matchStatement: aNode inContext: aDictionary].
    aNode class == self matchingClass ifFalse: [^false].
    (aDictionary at: self ifAbsentPut: [aNode]) = aNode ifFalse: [^false].

    #CHECKME.
    "/ check if the following affects any search rules
    "/ an uppercase meta-variable only matches an upper-case variable
    "/ Yes it does affect rules with an uppercase argument name.
    "/ my callers should raise a match-rule error in that situation (see matchArgumentsAgainst...)
    isUppercase ifTrue:[
        "/ must be global
        aNode name isUppercaseFirst ifFalse:[^ false].
    ].
    ^ true

    "Modified: / 08-08-2011 / 17:46:44 / cg"
    "Modified (format): / 19-11-2016 / 15:59:36 / cg"
!

matchLiteral: aNode inContext: aDictionary 
        aNode class == RBLiteralNode ifFalse:[^ false].
        ^ (aDictionary at: self ifAbsentPut: [aNode]) = aNode
!

matchStatement: aNode inContext: aDictionary 
	(aNode parent notNil and: [aNode parent isSequence]) ifFalse: [^false].
	^(aDictionary at: self ifAbsentPut: [aNode]) = aNode
! !

!RBPatternVariableNode methodsFor:'private'!

matchingClass
	^RBVariableNode
! !

!RBPatternVariableNode methodsFor:'testing-matching'!

isAnything
	^isAnything
!

isList
	^isList
!

isLiteral
	^isLiteral
!

isLiteralNode
        ^isLiteral
!

isPatternNode
	^true
!

isStatement
	^isStatement
!

recurseInto
	^recurseInto
! !

!RBPatternVariableNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

