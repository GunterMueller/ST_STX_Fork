"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBEnvironmentSearchAction subclass:#RBEnvironmentStringSelectAction
	instanceVariableNames:'startPosition stopPosition method'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Searches'
!


!RBEnvironmentStringSelectAction class methodsFor:'instance creation'!

selectFrom:startPosition to:stopPosition inMethod:aMethod
    ^ self new startPosition:startPosition stopPosition:stopPosition method:aMethod
! !

!RBEnvironmentStringSelectAction methodsFor:'accessing'!

startPosition
    ^ startPosition
!

startPosition:startPositionArg stopPosition:stopPositionArg method:methodArg 
    startPosition := startPositionArg.
    stopPosition := stopPositionArg.
    method := methodArg.
!

stopPosition
    ^ stopPosition
! !

!RBEnvironmentStringSelectAction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

