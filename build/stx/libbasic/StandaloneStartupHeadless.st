"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

StandaloneStartup subclass:#StandaloneStartupHeadless
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!StandaloneStartupHeadless class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    When smalltalk is started as IDE (stx), the show starts in Smalltalk>>start.
    In contrast, when a standAlone app is linked, 
    the show starts in the startup class's start method.

    This class is an abstract, subclassable template for a standalone headless-application's startup.
    For your own stand alone programs, define a subclass of this, 
    and redefine the #main: method there.
    (of course, the other methods can also be redefined.)

    [author:]
        Claus Gittinger

    [start with:]
        <yourNamehere>Startup start

    [see also:]
        Smalltalk
        GetOpt
        ReadEvalPrintLoop
        StandaloneStartup
"
! !

!StandaloneStartupHeadless class methodsFor:'queries'!

isAbstract
    ^ self == StandaloneStartupHeadless
!

isHeadless
    "this is invoked early by Smalltalk>>mainStartup, to ask if I like to
     have a Display or if I am a non-GUI headless application"

    ^ true
! !

!StandaloneStartupHeadless class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

