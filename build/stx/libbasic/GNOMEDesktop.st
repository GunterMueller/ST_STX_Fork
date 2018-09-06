"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

XDGDesktop subclass:#GNOMEDesktop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Desktop'
!

!GNOMEDesktop class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!GNOMEDesktop class methodsFor:'accessing'!

priority

    ^50

    "Created: / 11-08-2009 / 16:45:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!GNOMEDesktop class methodsFor:'accessing - defaults'!

defaultEditorCommand
    ^ 'gnome-open %F'

    "Created: / 11-08-2009 / 16:54:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!GNOMEDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/GNOMEDesktop.st,v 1.1 2011-06-28 10:09:53 vrany Exp $'
!

version_SVN
    ^ ' Id: GNOMEDesktop.st 10524 2010-05-20 13:35:23Z vranyj1  '
! !
