"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Metaclass subclass:#AutoloadMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!AutoloadMetaclass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    AutoloadMetaclass catches unhandled class methods, files in 
    the corresponding code when first used and resends the catched
    message to the now existing class.

    Autoload installs AutoloadMetaclass as its metaclass in #initialize. 

    See details of the why and how of autoloading in the Autoload class.

    [author:]
        Stefan Vogel

    [see also:]
        Autoload
"
! !

!AutoloadMetaclass methodsFor:'message catching'!

doesNotUnderstand:aMessage
    "caught a message; load the class and retry the message"

    |newClass|

    (myClass isNil or:[myClass == Autoload]) ifTrue:[
        "take care: subclassing Autoload must still be possible"
        ^ self perform:aMessage selector inClass:Metaclass withArguments:aMessage arguments.
    ].
    newClass := myClass autoload.
    (newClass notNil and:[newClass isLoaded]) ifTrue:[
        ^ aMessage sendTo:newClass class
    ].

    Transcript showCR:'Autoload [warning]: failed to autoload ',self name.
    ^ super doesNotUnderstand:aMessage

    "
     Wrapper unload.
     Wrapper class xxx

     Wrapper unload.
     Wrapper
        subclass:#TTTT 
        instanceVariableNames:'' 
        classVariableNames:''
        poolDictionaries:'' 
        category:'AAAA-Test'
    "

    "Modified: / 3.8.1999 / 13:57:05 / stefan"
!

new
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#new)
!

newClassBuilder
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#newClassBuilder)
! !

!AutoloadMetaclass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/AutoloadMetaclass.st,v 1.9 2014-11-26 09:10:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/AutoloadMetaclass.st,v 1.9 2014-11-26 09:10:20 cg Exp $'
! !

