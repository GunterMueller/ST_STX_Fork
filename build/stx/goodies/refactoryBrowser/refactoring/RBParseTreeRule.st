"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBParseTreeRule
	instanceVariableNames:'searchTree owner'
	classVariableNames:'CachedParsedRewriteExpressionTrees CachedParsedRewriteMethodTrees
		AccessLock'
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!


!RBParseTreeRule class methodsFor:'initialization'!

initialize
    AccessLock := RecursionLock new.
    CachedParsedRewriteExpressionTrees := CacheDictionary new:500. 
    CachedParsedRewriteMethodTrees := CacheDictionary new:300.
! !

!RBParseTreeRule class methodsFor:'instance creation'!

methodSearch: aString 
	^(self new)
		methodSearchString: aString;
		yourself
!

new
	^(super new)
		initialize;
		yourself
!

search: aString 
	^(self new)
		searchString: aString;
		yourself
! !

!RBParseTreeRule methodsFor:'accessing'!

searchString
    ^ searchTree originalFormattedCode "/ does not rewrite '_' to ':='

    "Modified: / 31-01-2012 / 15:08:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchTree
    ^ searchTree

    "Created: / 31-01-2012 / 15:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sentMessages
	^searchTree sentMessages
! !

!RBParseTreeRule methodsFor:'copying'!

copyMatchDo: aBlock
    "Creates of copy of receiver, that evaluates given block on
     every match, passing matching node as an argument"

    ^self subclassResponsibility

    "Created: / 02-02-2012 / 22:52:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBParseTreeRule methodsFor:'initialize-release'!

initialize
!

methodSearchString: aString 
    "/ avoid doing the RBParser-thing inside the lock, because this can take a long time
    AccessLock critical:[
        searchTree := CachedParsedRewriteMethodTrees at:aString ifAbsent:nil.
    ].
    searchTree isNil ifTrue:[
        searchTree := RBParser parseRewriteMethod: aString.
        AccessLock critical:[
            CachedParsedRewriteMethodTrees at:aString put:searchTree
        ].
    ].
    self assert:(searchTree notNil).
    self searchTreeChanged.
!

owner: aParseTreeSearcher
	owner := aParseTreeSearcher
!

searchString: aString
    "/ avoid doing the RBParser-thing inside the lock, because this can take a long time
    AccessLock critical:[
        searchTree := CachedParsedRewriteExpressionTrees at:aString ifAbsent:nil.
    ].
    searchTree isNil ifTrue:[
        searchTree := RBParser parseRewriteExpression: aString.
        AccessLock critical:[
            CachedParsedRewriteExpressionTrees at:aString put:searchTree
        ].
    ].
    self assert:(searchTree notNil).
    self searchTreeChanged.
    
    "Modified: / 31-01-2012 / 14:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchTreeChanged
    "sent to myself to allow subclasses to apply any search optimizations (searchStrings).
     Intentionally left blank here."
! !

!RBParseTreeRule methodsFor:'matching'!

canMatch: aProgramNode 
	^true
!

foundMatchFor: aProgramNode
	^aProgramNode
!

performOn: aProgramNode 
        self context removeAll.
        ((searchTree match: aProgramNode inContext: self context) 
                and: [self canMatch: aProgramNode]) 
                        ifTrue: 
                                [owner recusivelySearchInContext.
                                ^ self foundMatchFor: aProgramNode]
                        ifFalse: [^ nil]
! !

!RBParseTreeRule methodsFor:'private'!

canQuicklyReject:sourceCode
    ^ false
!

computeQuickSearchStrings
    "/ intentionally left blank
    ^ self
!

context
	^owner context
!

hasQuickSearchStrings
    ^ false
! !

!RBParseTreeRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


RBParseTreeRule initialize!
