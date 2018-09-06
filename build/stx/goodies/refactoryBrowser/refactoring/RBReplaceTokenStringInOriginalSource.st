"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBReplaceTokenStringInOriginalSource
	instanceVariableNames:'oldToken newToken'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

!RBReplaceTokenStringInOriginalSource class methodsFor:'documentation'!

documentation
"
    a concrete replace action, to replace a token by another token in the source
    This is only used to replace tokens inside a literalNode,
    as we want to replace tokens, not the whole literalNode, in order to preserve the
    indentation and comments.
"
! !

!RBReplaceTokenStringInOriginalSource methodsFor:'accessing'!

newToken
    ^ newToken
!

newToken:something
    newToken := something.
!

oldEndPosition
    ^ oldToken endPosition
!

oldStartPosition
    ^ oldToken startPosition
!

oldToken
    ^ oldToken
!

oldToken:something
    oldToken := something.
!

tokenPosition
    ^ oldToken start
! !

!RBReplaceTokenStringInOriginalSource methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:self class name.
    aStream nextPutAll:'('.
    oldToken printOn:aStream.
    aStream nextPutAll:' -> '.
    newToken printOn:aStream.
    aStream nextPutAll:')'.
! !

!RBReplaceTokenStringInOriginalSource methodsFor:'replacing'!

addIndividualReplacementsTo:aCollection
    aCollection add:self.
!

executeIn:aSourceString
    | start stop newCode |

    start := oldToken start.
    stop := oldToken stop.

    newCode := newToken value.

    ^ (aSourceString copyTo:start-1)
          , newCode
          , (aSourceString copyFrom:stop+1)
! !

!RBReplaceTokenStringInOriginalSource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RBReplaceTokenStringInOriginalSource.st,v 1.2 2015-02-23 18:00:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RBReplaceTokenStringInOriginalSource.st,v 1.2 2015-02-23 18:00:06 cg Exp $'
! !

