"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Ruler subclass:#VerticalRuler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!VerticalRuler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    like a Ruler, but vertical.
    see documentation in Ruler
"
! !

!VerticalRuler methodsFor:'initialization'!

initialize
    orientation := #vertical.

    super initialize.
    self width:(font widthOf:'inch').

    "
     VerticalRuler new open
    "
! !

!VerticalRuler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/VerticalRuler.st,v 1.11 2006-11-13 16:11:31 cg Exp $'
! !

