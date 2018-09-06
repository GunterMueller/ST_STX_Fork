"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: VAST }"

Object subclass:#System
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualAge'
!

!System class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    this class is provided to allow for an initial fileIn of V'Age classes.
    Classes should then be moved to their desired position in the ST/X class hierarchy.

    Except for the required protocol mimicri,
    it does not (yet) provide any functionality.
"
! !

!System class methodsFor:'queries'!

bigEndian
    ^ UninterpretedBytes isBigEndian

    "Created: / 06-03-2012 / 17:11:07 / cg"
!

subsystemType:key
    key = 'OS' ifTrue:[
        OperatingSystem isUNIXlike ifTrue:[^ 'UNIX'].
        OperatingSystem isMSWINDOWSlike ifTrue:[^ 'WIN32s'].
    ].
    key = 'CG' ifTrue:[
        Screen current isWindowsPlatform ifTrue:[^ 'WIN32'].
        Screen current isX11Platform ifTrue:[^ 'X'].
    ].

    self shouldImplement.

    "Created: / 18-10-2011 / 20:41:57 / cg"
! !

!System class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/VAST__System.st,v 1.8 2017-11-09 09:03:58 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/VAST__System.st,v 1.8 2017-11-09 09:03:58 mawalch Exp $'
! !

