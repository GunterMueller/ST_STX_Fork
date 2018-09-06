"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#AbstractChart
	instanceVariableNames:'model aod aoHilf anzahl'
	classVariableNames:''
	poolDictionaries:''
	category:'Statistic-Charts'
!

!AbstractChart class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!AbstractChart class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/AbstractChart.st,v 1.3 2017-01-23 22:30:09 cg Exp $'
! !

!AbstractChart methodsFor:'accessing'!

model:newModel
    model := newModel.
    aod := newModel value
! !

!AbstractChart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/AbstractChart.st,v 1.3 2017-01-23 22:30:09 cg Exp $'
! !

