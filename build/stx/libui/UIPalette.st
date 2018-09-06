"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


Object subclass:#UIPalette
	instanceVariableNames:''
	classVariableNames:'ActiveSpecList'
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!UIPalette class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    for now, this is a dummy class to allow ST-80 widgets to be
    (at least) loaded without too many errors.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by reading public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"

! !

!UIPalette class methodsFor:'initialization'!

initialize
    ActiveSpecList := IdentitySet new.

    "
     UIPalette initialize
    "

    "Modified: 27.1.1997 / 11:30:33 / cg"
! !

!UIPalette class methodsFor:'accessing'!

activeSpecsList
    ^ ActiveSpecList

    "Created: 25.1.1997 / 19:05:07 / cg"
! !

!UIPalette class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UIPalette.st,v 1.1 1997-01-27 10:41:01 cg Exp $'
! !
UIPalette initialize!
