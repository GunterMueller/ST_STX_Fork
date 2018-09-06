"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#TerminalPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

TerminalPattern comment:'If a TerminalPattern appears in the follow set of any other pattern, it means that the other pattern is permitted to appear as the last piece of content in the element described by the pattern.
'
!


!TerminalPattern methodsFor:'accessing'!

description

	^'<close tag>'
! !

!TerminalPattern methodsFor:'testing'!

isTerminator

	^true
!

matches: aNode

	^false
! !

!TerminalPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/TerminalPattern.st,v 1.6 2003-04-23 08:44:17 cg Exp $'


! !
