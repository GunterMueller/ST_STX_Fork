"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

RBEnvironmentSearchAction subclass:#RBEnvironmentVariableSearchAction
	instanceVariableNames:'variableType variableName variableScope'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Searches'
!

!RBEnvironmentVariableSearchAction class methodsFor:'documentation'!

documentation
"
    meant to provide better searches when a match rule detects a problem with a variable.
    variableType will describe the type of variable:
        #instance
        #class
        #methodArg
        #methodLocal
        #blockArg
        #blockLocal

    for the last two in the above list, the variableScope slot provides the characterPosition
    of the block in the source.

    see superclass for more info.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!RBEnvironmentVariableSearchAction class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBEnvironmentVariableSearchAction.st,v 1.1 2014-12-12 19:05:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBEnvironmentVariableSearchAction.st,v 1.1 2014-12-12 19:05:33 cg Exp $'
! !

