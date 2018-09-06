"
 COPYRIGHT (c) 2016 by Claus Gittinger
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

Object subclass:#VoidObject
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyVoid'
	poolDictionaries:''
	category:'Kernel-Objects'
!

!VoidObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by Claus Gittinger
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
    there is only one instance of this class: Void,
    representing a void value.

    This is mainly present for Scheme-like read-eval-print loops,
    in which methods may return void to prevent it from being printed.
    
    It may also be useful to represent void values as returned from calls
    to external functions (C-void functions) or from remote procedure calls.

    Smalltalk code does not normally use it.

    [author:]
        Claus Gittinger
"
! !

!VoidObject class methodsFor:'instance creation'!

basicNew
    TheOneAndOnlyVoid isNil ifTrue:[
        TheOneAndOnlyVoid := super basicNew.
    ].
    ^ TheOneAndOnlyVoid

    "
     VoidObject basicNew
     VoidObject new
    "
! !

!VoidObject class methodsFor:'class initialization'!

initialize
    Smalltalk at:#Void put:(self basicNew).
    Smalltalk at:#void put:(self basicNew). "/ for JavaScript code
! !

!VoidObject methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'Void'.
! !

!VoidObject methodsFor:'queries'!

isVoid
    ^ true

    "
     Void isVoid
    "
! !

!VoidObject class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


VoidObject initialize!
