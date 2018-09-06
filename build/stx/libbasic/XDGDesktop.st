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

UnixDesktop subclass:#XDGDesktop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Desktop'
!

!XDGDesktop class methodsFor:'documentation'!

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

!XDGDesktop class methodsFor:'accessing'!

priority

    ^30

    "Created: / 11-08-2009 / 16:41:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XDGDesktop class methodsFor:'accessing - defaults'!

defaultEditorCommand
    ^ 'xdg-open %F'

    "Created: / 11-08-2009 / 16:54:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XDGDesktop class methodsFor:'testing'!

isAvailable
    ^ super isAvailable 
        and: [ (OperatingSystem pathOfCommand: 
                    (self defaultEditorCommand upTo:
                        Character space)) notNil ]

    "Created: / 11-08-2009 / 16:44:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XDGDesktop class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/XDGDesktop.st,v 1.1 2011-06-28 10:09:48 vrany Exp $'
!

version_SVN
    ^ ' Id: XDGDesktop.st 10517 2010-04-26 18:26:38Z vranyj1  '
! !
