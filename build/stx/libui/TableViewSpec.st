"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libui' }"

MenuComponentSpec subclass:#TableViewSpec
	instanceVariableNames:'selectionStyle'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!TableViewSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!TableViewSpec methodsFor:'accessing'!

selectionStyle
    "return the value of the instance variable 'selectionStyle' (automatically generated)"

    ^ selectionStyle

    "Created: 10.4.1997 / 11:15:29 / cg"
!

selectionStyle:something
    "set the value of the instance variable 'selectionStyle' (automatically generated)"

    selectionStyle := something.

    "Created: 10.4.1997 / 11:15:30 / cg"
! !

!TableViewSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/TableViewSpec.st,v 1.9 2002-07-11 10:47:07 cg Exp $'
! !
