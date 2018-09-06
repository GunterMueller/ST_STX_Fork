"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCAction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCAction comment:'SmaCCAction is an abstract class that represents an action in the LR parsing table.

Subclasses must implement the following messages:
	accessing
		id'
!


!SmaCCAction methodsFor:'accessing'!

id
	^self subclassResponsibility
! !

!SmaCCAction methodsFor:'public'!

isReduce
	^false
!

isShift
	^false
! !

!SmaCCAction class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCAction.st,v 1.1 2006-02-09 21:16:36 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
