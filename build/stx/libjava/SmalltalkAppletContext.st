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

Object subclass:#SmalltalkAppletContext
	instanceVariableNames:'statusHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Views-Support'
!

!SmalltalkAppletContext class methodsFor:'documentation'!

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

!SmalltalkAppletContext methodsFor:'accessing'!

getImage: url 
    | imgSource  toolKit |

    "return 
        Toolkit.getDefaultToolkit().createImage(new sun.awt.image.URLImageSource(arg1)))"
    imgSource := (JavaVM classForName: 'sun.awt.image.URLImageSource') 
                newCleared.
    imgSource perform: #'<init>(Ljava/net/URL;)V' with: url.
    toolKit := (Java classForName: 'java.awt.Toolkit') 
                perform: #getDefaultToolkit.
    ^ toolKit perform: #createImage with: imgSource.

    "Modified: / 4.11.1998 / 21:07:48 / cg"
!

showStatus: arg 
    | msg |

    arg isJavaObject ifTrue: [
        (arg isMemberOf: (JavaVM classForName: 'java.lang.String')) ifTrue: [
            msg := Java as_ST_String: arg
        ] ifFalse: [ msg := arg printString ]
    ] ifFalse: [ msg := arg ].
    statusHolder notNil ifTrue: [ statusHolder value: msg ] ifFalse: [
        Transcript showCR: msg
    ].
    ^ nil

    "Created: 1.8.1997 / 15:48:53 / cg"
    "Modified: 8.8.1997 / 12:07:43 / cg"
! !

!SmalltalkAppletContext methodsFor:'java accessing'!

doesNotUnderstand:aMessage
    |selector img|

    (selector := aMessage selector) == #'showStatus(Ljava/lang/String;)V' ifTrue:[
        self showStatus:(Java as_ST_String:(aMessage arguments at:1)).
        ^ self
    ].
    selector == #'getImage(Ljava/net/URL;)Ljava/awt/Image;' ifTrue:[
        ^ self getImage:(aMessage arguments at:1).
    ].
    ^ super doesNotUnderstand:aMessage

    "Created: / 12.1.1998 / 23:48:10 / cg"
    "Modified: / 12.1.1998 / 23:53:31 / cg"
! !

!SmalltalkAppletContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/SmalltalkAppletContext.st,v 1.16 2015-03-20 12:08:01 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/SmalltalkAppletContext.st,v 1.16 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

