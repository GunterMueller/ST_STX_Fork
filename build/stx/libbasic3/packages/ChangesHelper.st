"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Object subclass:#ChangesHelper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

!ChangesHelper class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ChangesHelper class methodsFor:'accessing'!

getCurrentMethodFromMethodChange:aChange
    | classOrNil |
    classOrNil := Smalltalk classNamed:(aChange className).
    classOrNil ifNil:[
        ^ nil
    ].

    ^ classOrNil compiledMethodAt:aChange selector
! !

!ChangesHelper class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/ChangesHelper.st,v 1.2 2006-01-10 09:29:34 cg Exp $'
! !
