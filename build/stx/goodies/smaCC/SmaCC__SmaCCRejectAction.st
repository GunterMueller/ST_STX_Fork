"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCAction subclass:#SmaCCRejectAction
	instanceVariableNames:''
	classVariableNames:'Reject'
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCRejectAction comment:'SmaCCRejectAction represents a reject action in the parsing tables.'
!


!SmaCCRejectAction class methodsFor:'instance creation'!

new
	^Reject
! !

!SmaCCRejectAction class methodsFor:'class initialization'!

initialize
	Reject := self basicNew
!

releaseObjects
	Reject := nil
! !

!SmaCCRejectAction methodsFor:'accessing'!

id
	^2r11
! !

!SmaCCRejectAction class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCRejectAction.st,v 1.1 2006-02-09 21:16:15 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

SmaCCRejectAction initialize!
