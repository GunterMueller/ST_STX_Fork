"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

ParseTreeRewriter subclass:#ParseTreeSourceRewriter
	instanceVariableNames:'replacements alwaysPerformAllSearches'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

Error subclass:#NodesOverlapError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ParseTreeSourceRewriter
!

!ParseTreeSourceRewriter class methodsFor:'documentation'!

documentation
"
    This is a parse tree rewriter which does NOT generate new code from scratch
    (i.e. it does not generate its source by recursively walking along the formattedCode methods),
    but instead inserts the new nodes code right into the original source code.
    This has two advantages:
        it does not destroy the user's formatting, indentation etc.
        it does not forget comments.
    I added this, because I constantly got mad at the rewriter reformatting my code for every tiny
    little variable rewrite operation.

    Caveats: 
        needs more intelligence when rewriting non-trivial code, such as keyword message sends.
        For now, it seems to only behave reasonable for very simple stuff, such as replacing a variable
        by another or by a simple unary send.

    [author:]
        Claus Gittinger
    [see also:]
        ParseTreeRewriter
"
! !

!ParseTreeSourceRewriter methodsFor:'accessing'!

addReplacement:aReplacement
    replacements isNil ifTrue:[
	replacements := OrderedCollection new.
    ].
    replacements add:aReplacement
!

alwaysPerformAllSearches
    "please read the comment in the inherited alwaysPerformAllSearches"

    ^ alwaysPerformAllSearches ? false.
!

alwaysPerformAllSearches:aBoolean
    "please read the comment in the inherited alwaysPerformAllSearches"

    alwaysPerformAllSearches := aBoolean
!

executeTree: aParseTree
    "Performs rewrites on given tree"

    | oldSource oldContext newSource treeFromRewrittenSource failedToRewrite |

    RBParser flushCachedTree:aParseTree.

    oldContext := context.
    context := (RBSmallDictionary ? Dictionary) new.
    answer := false.
    oldSource := aParseTree source.

    "/Rewrite the tree as usual and then (try to) rewrite the original source code
    tree := self visitNode: aParseTree.
    replacements notNil ifTrue:[
        [  
            failedToRewrite := false.
            newSource := self executeReplacementsInSource: oldSource.
        ] on: NodesOverlapError do:[
            failedToRewrite := true.
        ].
    ] ifFalse:[
        ^answer
    ].
    "/DO NOT forget rewrites here!!!!!!"

    "/ Now, validate that rewritten parse tree is the same as
    "/ the one we get from the rewritten source:
    failedToRewrite ifFalse:[ 
        treeFromRewrittenSource := RBParser parseMethod: newSource onError:[:message :position|nil].     
        treeFromRewrittenSource = tree ifTrue:[
            tree source: newSource.
        ] ifFalse:[
    "/        self breakPoint: #jv.
        ].
    ] ifTrue:[ 
        tree source: tree formattedCode.  
    ].
    context := oldContext.
    ^answer

    "Created: / 26-03-2012 / 13:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2015 / 21:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forgetReplacements
    replacements := nil 
!

replacements
    ^ replacements
! !

!ParseTreeSourceRewriter methodsFor:'queries'!

isRewritingOriginalSource
    ^ true.
! !

!ParseTreeSourceRewriter methodsFor:'replacing'!

executeReplacementsInSource:aSourceString
    "execute all replacements in a sourceString.
     Invoked after we have collected all replacements."

    |atomicReplacements newSource|

    "just in case that a replacement is a multi-word replacement;
     let each replacement add its sub-replacements add to a collection of
     atomic replacements. 
     (just think of a multi-part-keyword message being replaced)"

    atomicReplacements := OrderedCollection new.
    replacements ? #() do:[:eachReplacement |
        eachReplacement addIndividualReplacementsTo:atomicReplacements.
    ].

    "now, atomic replacements can be sorted by their characterPosition"

    atomicReplacements sort:[:a :b | a tokenPosition < b tokenPosition ].
    atomicReplacements overlappingPairsDo:[:a :b |
        a oldEndPosition "oldNode stop" >= b oldStartPosition "oldNode start" ifTrue:[ 
            NodesOverlapError newException
                messageText:'Nodes to replace overlaps';
                raise
        ].
    ].
    "there may not be any overlaps ..."

    newSource := aSourceString.
    atomicReplacements reverseDo:[:eachReplacement |
        newSource := eachReplacement executeIn:newSource
    ].

    ^ newSource

    "Modified: / 19-02-2015 / 16:34:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

replaceLiteral: oldLiteral with: newLiteral
        |replaceAction replaceInArray searchInArray|

        replaceInArray := 
            [:arrayOfOldTokens |
                arrayOfOldTokens
                    collect:[:eachOldToken |
                        |oldTokenValue newToken|

                        oldTokenValue := eachOldToken value.
                        oldTokenValue isArray ifTrue:[
                            newToken := eachOldToken copy value:(replaceInArray value:oldTokenValue).
                            newToken.
                        ] ifFalse:[
                            (oldTokenValue = oldLiteral) ifTrue:[
                                newToken := eachOldToken copy value:newLiteral.
                                Transcript show:'** replace token '; show:eachOldToken; show:' -> '; showCR:newToken.
                                self addReplacement:((RBReplaceTokenStringInOriginalSource new)
                                                oldToken: eachOldToken;
                                                newToken: newToken).
                                newToken
                            ] ifFalse:[
                                eachOldToken
                            ]
                        ].
                    ]
            ].

        replaceAction :=
            [:oldNode |
                |newNode newToken|

                newNode := oldNode copy.

                oldNode isLiteralArray ifTrue:[
                    newToken := oldNode token copy value:(replaceInArray value:oldNode token value).
                    newNode literalToken:newToken.
                ] ifFalse:[
                    oldNode token value = 'notRecognized:' ifTrue:[self halt].

                    newToken := oldNode token copy value:newLiteral.
                    newNode literalToken:newToken.
                    Transcript showCR:'replacing literal ',oldLiteral,' by ',newLiteral.

                    Transcript show:'** replace node '; show:oldNode; show:' -> '; showCR:newNode.
                    self addReplacement:((RBReplaceStringInOriginalSource new)
                                    oldNode: oldNode;
                                    newNode: newNode).
                ].
                newNode            
            ].

        searchInArray := 
            [:oldArrayToken |
                oldArrayToken value
                    contains:[:oldElementToken |
                        oldElementToken isLiteralArray ifTrue:[
                            searchInArray value:oldElementToken
                        ] ifFalse:[
                            (oldElementToken value = oldLiteral)
                        ].
                    ]
            ].

        self
                replace: '`#literal'
                withValueFrom: replaceAction
                when: [:aNode |
                        aNode isLiteralArray ifTrue:[
                            searchInArray value:aNode token.
                        ] ifFalse:[
                            (aNode value = oldLiteral) 
                        ].
                ].
!

replaceVariable: variable with: newVariable 
        self
                replace: '`variable'
                withValueFrom: [:aNode |
                    |newNode|

                    newNode := aNode copy.
                    newNode identifierToken:(aNode token copy value:newVariable).
                    "/ Transcript showCR:'replacing variable ',variable,' by ',newVariable.

                    self addReplacement:((RBReplaceStringInOriginalSource new)
                                    oldNode: aNode;
                                    newNode: newNode).
                    newNode            
                ]
                when: [:aNode | 
                        (aNode name = variable) 
                ].
! !

!ParseTreeSourceRewriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

