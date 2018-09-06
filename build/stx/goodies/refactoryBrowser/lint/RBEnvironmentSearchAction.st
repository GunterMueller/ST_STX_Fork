"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

Object subclass:#RBEnvironmentSearchAction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Searches'
!

!RBEnvironmentSearchAction class methodsFor:'documentation'!

documentation
"
    an abstract superclass for actions as collected by search rules
    The idea is that the rule adds searchaction instances to the result,
    which provide the following services:
        1) can present themself as html in a rationale
        2) can be asked to search and deliver a selection interval in a method's source

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!RBEnvironmentSearchAction class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBEnvironmentSearchAction.st,v 1.1 2014-12-12 19:04:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBEnvironmentSearchAction.st,v 1.1 2014-12-12 19:04:28 cg Exp $'
! !

