"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

RBParseTreeRule subclass:#RBSearchRule
	instanceVariableNames:'answerBlock quickSearchStrings'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!


!RBSearchRule class methodsFor:'instance creation'!

searchFor: aString thenDo: aBlock 
	^self new searchFor: aString thenDo: aBlock
!

searchForMethod: aString thenDo: aBlock 
	^self new searchForMethod: aString thenDo: aBlock
!

searchForTree: aBRProgramNode thenDo: aBlock 
	^self new searchForTree: aBRProgramNode thenDo: aBlock
! !

!RBSearchRule methodsFor:'copying'!

copyMatchDo:aBlock
    "Creates of copy of receiver, that evaluates given block on
     every match, passing matching node as an argument"

    ^ RBSearchRule new 
            searchForTree: searchTree 
            thenDo: [:node :answer :owner :context|
                | answerBlockValue |

                "/ cg: changed to allow an additional argument (the owner) which provides the
                "/ context. So match blocks can get to the currentClass/selector etc.
                answerBlockValue := answerBlock valueWithOptionalArgument: node and: answer and:owner and:context.
                (answerBlockValue notNil and:[answer ~~ answerBlockValue]) ifTrue:[
                    aBlock valueWithOptionalArgument: node and:owner
                ].
                answerBlockValue
            ]

    "Modified: / 02-02-2012 / 23:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBSearchRule methodsFor:'initialize-release'!

computeQuickSearchStrings
    "can be called before doing a bulk search to avoid the expensive parse
     by a quick plausibility check, if a match is possible, before doing the actual parse.
     Computes the quickSearchString collection as a collection of OR-strings or collections.
     Each element of it is either a string or a collection of AND-strings.
     Before attempting a parse, some searchers will ask for the quickSearchStrings,
     and see if any of the OR-string elements is present in the original (unparsed source code);
     if the element is a string, then it is searched, if it is a collection of AND-strings,
     then they all must be present.
     If none of the OR-strings is present, then no parse is attempted, and the match considered
     to be failing.

     Sounds complicated?
     Example: we are searching for a match of the AST-tree for 'foo := false'.
     Then, we can eliminate many parse operations by doing a quick check, if the word 'false'
     is in the source at all. Of course, if it is, then we still have to parse, to see
     if the quickCheck was a false-positive. However, this might eliminate roughly 90%
     of all methods and thus speed up the code-search by a factor of 10."

    |andStrings|
    
    quickSearchStrings notNil ifTrue:[^ self].
    
    andStrings := Set new. "/ all of them must be present; otherwise I will not match

    "/ must contain the message selector (unless pattern)
    searchTree allMessageNodesDo:[:msgNode |
        msgNode isKeyword ifTrue:[
            andStrings addAll:(msgNode selector keywords)
        ] ifFalse:[  
            andStrings add:msgNode selector
        ].
    ].
    "/ must contain the variables (unless pattern)
    searchTree variableNodesDo:[:varNode |
        (varNode isPatternNode "or:[varNode isInsidePatternNode]") ifFalse:[
            andStrings add:varNode name.
        ].
    ].
    "/ must contain the literals (unless pattern)
    searchTree allLiteralNodesDo:[:litNode |
        (litNode isPatternNode "or:[ litNode isInsidePatternNode ]") ifFalse:[
            |val|
            
            val := litNode value.
            ( #(true false nil) includes:val) ifTrue:[
                andStrings add:val printString.
            ] ifFalse:[
                val isString ifTrue:[
                    val isSymbol ifTrue:[
                        "/ attn: could be either #sym or #'sym'
                        "/ JV@2016-07-26: Why the hell this check? This breaks extract-to-method refactoring
                        "/ ast it uses symbol #'place.holder.for.method' as placeholder.
"/                        (val conform:[:ch | ch isLetterOrDigit or:[':_' includes:ch] ]) ifTrue:[
                            andStrings add:(val asString).
"/                        ] ifFalse:[    
                            self breakPoint:#cg.
"/                        ]
                    ] ifFalse:[    
                        (val conform:[:ch | ch isLetterOrDigit or:[ch == Character space]]) ifTrue:[
                            andStrings add:('''',val,'''').
                        ] ifFalse:[
                            val first isLetterOrDigit ifTrue:[
                                self breakPoint:#cg.
                                andStrings add:('''',val first).
                            ]
                        ].    
                    ].    
                ] ifFalse:[
                    "/ sorry - we cannot search quickly for any numeric value;
                    "/ it might be in a different format, base, etc.
                    val isInteger ifTrue:[
                        "/ everything but 0 and 1 look different in a radix,
                        "/ so we cannot do a quick filter on them
                        ((val == 0) or:[val == 1]) ifTrue:[
                            andStrings add:(val printString).
                        ] ifFalse:[
                            self breakPoint:#cg.
                        ].
                    ] ifFalse:[
                        (val isArray) ifTrue:[
                            andStrings add:'#'. "/ can I add '#(' or is '# (' legal???
                            andStrings add:'('. "/ for now (because it islegal in st/x),
                            andStrings add:')'. "/ do not (see below)
                            "/ # (1 2 3).
                        ] ifFalse:[ 
                            ((val class == ByteArray) or:[(val class == ImmutableByteArray)]) ifTrue:[
                                andStrings add:'#'. "/ can I add '#[' or is '# [' legal???
                                andStrings add:'['. "/ mh - it is actually not legal in st/x,
                                andStrings add:']'. "/ but I am not sure about other dialects...
                                "/ # [1 2 3].
                            ] ifFalse:[
                                val isCharacter ifTrue:[
                                    (val isLetterOrDigit or:[ '!!"%$&/()|{}[]+*-_:.;,' includes:val ]) ifTrue:[
                                        andStrings add:('$',val).
                                    ]    
                                ] ifFalse:[
                                    "/ litNode value
                                    self breakPoint:#cg.
                                ].    
                            ].    
                        ].    
                    ].
                ].
            ].
        ].
    ].
    
    searchTree hasAssignmentNodes ifTrue:[
        andStrings add:#(':=' '_'). "/ means: either must be present
    ].
    searchTree hasReturnNodes ifTrue:[
        andStrings add:'^'.
    ].
    searchTree hasBlockNodes ifTrue:[
        andStrings add:'['; add:']'. "/ means: both must be present
    ].

    "/ Transcript show:'q: '; showCR:andStrings.
    
    andStrings isEmpty 
        ifTrue:[ quickSearchStrings := #() ]
        ifFalse:[ quickSearchStrings := andStrings asOrderedCollection ].

    "Modified: / 26-07-2016 / 11:42:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2016 / 18:41:18 / cg"
!

searchFor: aString thenDo: aBlock
        self assert:(aBlock numArgs between:2 and:4).
        self searchString: aString.
        answerBlock := aBlock

    "Modified: / 07-03-2012 / 17:29:49 / cg"
!

searchForMethod: aString thenDo: aBlock 
        self assert:(aBlock numArgs between:2 and:4).
        self methodSearchString: aString.
        answerBlock := aBlock

    "Modified: / 07-03-2012 / 17:29:53 / cg"
!

searchForTree: aBRProgramNode thenDo: aBlock 
        self assert:(aBlock numArgs between:2 and:4).
        searchTree := aBRProgramNode.
        answerBlock := aBlock.
        self searchTreeChanged.

    "Modified: / 07-03-2012 / 17:29:55 / cg"
!

searchTreeChanged
    quickSearchStrings := nil.
    self computeQuickSearchStrings.
! !

!RBSearchRule methodsFor:'testing'!

addQuickStringForOneOfMustBePresent:aCollectionOfStrings
    "for a manual setting of an additional set of strings;
     one of aCollectionOfStrings must be present for a possible match.
     If none is, we can do a quick reject"
     
    quickSearchStrings isEmptyOrNil ifTrue:[
        quickSearchStrings := OrderedCollection with:aCollectionOfStrings.
        ^ self
    ].
    quickSearchStrings add:aCollectionOfStrings.
!

canMatch: aProgramNode
    |result|

    result := answerBlock 
                valueWithOptionalArgument: aProgramNode 
                and: owner answer 
                and: owner 
                and: self context.
    result isNil ifTrue:[^ false].

    owner answer: result.
    ^true

    "Modified: / 08-03-2012 / 03:06:53 / cg"
!

canQuicklyReject:sourceCode
    "if I have quickSearchStrings, try a quick reject based on them.
     This may generate false negatives (i.e. lets source pass, even though
     it should not), but still reduces the amount of parser work in the order
     of 90%, thus making code searches 10 times faster.
     If not all of my search strings are be present in the sourceCode,
     then reject."

    |allFound|

    quickSearchStrings isEmptyOrNil ifTrue:[^ false].

    "/ if not all of my searchStrings are there, we can quickly reject
    "/ the entries in quickSearchStrings are either a string which must be present,
    "/ or a collection of strings, of which one of them must be present.
    allFound := quickSearchStrings 
                    conform:[:quickStringOrOrStrings | 
                        quickStringOrOrStrings isString ifTrue:[
                            sourceCode includesString:quickStringOrOrStrings
                        ] ifFalse:[
                            quickStringOrOrStrings contains:[:someString | sourceCode includesString:someString]
                        ]
                ].
            
    "/ allFound ifTrue:[self halt].        
    ^ allFound not
!

hasQuickSearchStrings
    ^ quickSearchStrings notNil
! !

!RBSearchRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

