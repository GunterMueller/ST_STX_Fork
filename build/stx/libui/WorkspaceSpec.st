"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"





"{ Package: 'stx:libui' }"

TextEditorSpec subclass:#WorkspaceSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!WorkspaceSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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

    [author:]
        Claus Gittinger
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!WorkspaceSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ Workspace


! !

!WorkspaceSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/WorkspaceSpec.st,v 1.5 2003-10-09 15:16:20 cg Exp $'
! !
