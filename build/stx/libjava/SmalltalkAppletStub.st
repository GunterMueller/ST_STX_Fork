"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

Object subclass:#SmalltalkAppletStub
	instanceVariableNames:'parameter documentBase codeBase appletContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Views-Support'
!

!SmalltalkAppletStub class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!SmalltalkAppletStub methodsFor:'accessing'!

appletContext
    "return the value of the instance variable 'appletContext' (automatically generated)"

    ^ appletContext

    "Created: 1.8.1997 / 15:56:20 / cg"
!

appletContext:something
    "set the value of the instance variable 'appletContext' (automatically generated)"

    appletContext := something.

    "Created: 1.8.1997 / 15:56:20 / cg"
!

codeBase
    "return the value of the instance variable 'codeBase' (automatically generated)"

    ^ codeBase

    "Created: 1.8.1997 / 15:56:20 / cg"
!

codeBase:something
    "set the value of the instance variable 'codeBase' (automatically generated)"

    codeBase := something.

    "Created: 1.8.1997 / 15:56:20 / cg"
!

documentBase
    "return the value of the instance variable 'documentBase' (automatically generated)"

    ^ documentBase

    "Created: 1.8.1997 / 15:56:20 / cg"
!

documentBase:something
    "set the value of the instance variable 'documentBase' (automatically generated)"

    documentBase := something.

    "Created: 1.8.1997 / 15:56:20 / cg"
!

parameter
    "return the value of the instance variable 'parameter' (automatically generated)"

    ^ parameter

    "Created: 1.8.1997 / 15:56:19 / cg"
!

parameter:something
    "set the value of the instance variable 'parameter' (automatically generated)"

    parameter := something.

    "Created: 1.8.1997 / 15:56:20 / cg"
! !

!SmalltalkAppletStub methodsFor:'applet actions'!

appletResize:newWidth _:newHeight
    self halt.

    "Created: 13.8.1997 / 00:18:41 / cg"
! !

!SmalltalkAppletStub methodsFor:'java accessing'!

doesNotUnderstand:aMessage
    |selector base|

    selector := aMessage selector.
    selector == #'getParameter(Ljava/lang/String;)Ljava/lang/String;' ifTrue:[
        ^ self getParameter:(aMessage arguments at:1)
    ].
    selector == #'getAppletContext()Ljava/applet/AppletContext;' ifTrue:[
        ^ self getAppletContext
    ].
    selector == #'getCodeBase()Ljava/net/URL;' ifTrue:[
        ^ self getCodeBase.
    ].
    selector == #'appletResize(II)V' ifTrue:[
        self appletResize:(aMessage arguments at:1) _:(aMessage arguments at:2).
        ^ nil   "/ void
    ].
    ^ super doesNotUnderstand:aMessage

    "Created: / 7.1.1998 / 17:13:11 / cg"
    "Modified: / 12.1.1998 / 23:50:40 / cg"
!

getAppletContext
    ^ appletContext

    "Created: 1.8.1997 / 15:57:20 / cg"
!

getCodeBase
    ^ codeBase

    "Created: 1.8.1997 / 15:57:11 / cg"
!

getDocumentBase
    ^ documentBase

    "Created: 1.8.1997 / 15:57:05 / cg"
!

getParameter:arg
    |s|

    (parameter includesKey:arg) ifFalse:[
"/        self halt:'no parameter for: ' , arg displayString.
        ^ nil.

        s := Dialog request:('applet wants parameter for ' , (Java as_ST_String:arg)).
        ^ Java as_String:s.
    ].
    ^ parameter at:arg ifAbsent:nil

    "Created: 1.8.1997 / 15:56:51 / cg"
    "Modified: 14.8.1997 / 01:28:56 / cg"
! !

!SmalltalkAppletStub class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/SmalltalkAppletStub.st,v 1.16 2015-03-20 12:08:01 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/SmalltalkAppletStub.st,v 1.16 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

