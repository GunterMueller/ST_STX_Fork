"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCAction subclass:#SmaCCShiftAction
	instanceVariableNames:''
	classVariableNames:'Shift'
	poolDictionaries:''
	category:'SmaCC-Parser Generator'
!

SmaCCShiftAction comment:'SmaCCShiftAction represents a shift action in the parser''s tables.'
!


!SmaCCShiftAction class methodsFor:'instance creation'!

new
	^Shift
! !

!SmaCCShiftAction class methodsFor:'class initialization'!

initialize
	Shift := self basicNew
!

releaseObjects
	Shift := nil
! !

!SmaCCShiftAction methodsFor:'accessing'!

id
	^2r01
! !

!SmaCCShiftAction methodsFor:'public'!

isShift
	^true
! !

!SmaCCShiftAction class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCShiftAction.st,v 1.1 2006-02-09 21:16:29 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

SmaCCShiftAction initialize!
