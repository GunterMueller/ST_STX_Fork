"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxmLink subclass:#RxmRepetition
	instanceVariableNames:'min max pattern'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!


!RxmRepetition methodsFor:'accessing'!

min:minArg max:maxArg 
    min := minArg.
    max := maxArg.
!

pattern:something
    pattern := something.
! !

!RxmRepetition methodsFor:'matching'!

matchAgainst: aMatcher
    |n before|

    min timesRepeat:[
        (pattern matchAgainst: aMatcher) ifFalse:[^ false].
    ].
    n := min.
    [max isNil or:[n < max]] whileTrue:[
        before := aMatcher currentState.
        (pattern matchAgainst: aMatcher) ifFalse:[
            aMatcher restoreState: before.
            ^ next matchAgainst: aMatcher
        ].
        n := n + 1.
    ].

    ^ next matchAgainst: aMatcher
! !

!RxmRepetition class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/Regex__RxmRepetition.st,v 1.3 2013-01-30 17:12:55 stefan Exp $'
! !

