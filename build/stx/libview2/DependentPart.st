"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

VisualPart subclass:#DependentPart
	instanceVariableNames:'model'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

!DependentPart class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    a dummy class - only existing to provide a compatible home
    for fileIn of ST-80 classes.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, from reading PD programs and 
        from the Hopkins/Horan book.
        - it may not be complete or compatible to the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"



! !

!DependentPart class methodsFor:'instance creation'!

model:aModel
    "return a new instance and initialize its model"

    ^ self new model:aModel

    "Created: 24.5.1996 / 19:17:37 / cg"
! !

!DependentPart methodsFor:'accessing'!

model
    "return model"

    ^ model

    "Created: 24.5.1996 / 19:16:51 / cg"
!

model:something
    "set model"

    model := something.

    "Created: 24.5.1996 / 19:16:51 / cg"
! !

!DependentPart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DependentPart.st,v 1.3 2003-08-18 12:13:35 cg Exp $'
! !

