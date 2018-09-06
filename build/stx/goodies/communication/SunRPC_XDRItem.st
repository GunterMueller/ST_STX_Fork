"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Object subclass:#XDRItem
	instanceVariableNames:'name number'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    helper entity for the XDR-IDL parser

    [author:]
        Claus Gittinger
"
! !

!XDRItem methodsFor:'accessing'!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.
!

number
    "return the value of the instance variable 'number' (automatically generated)"

    ^ number
!

number:something
    "set the value of the instance variable 'number' (automatically generated)"

    number := something.
! !

!XDRItem methodsFor:'printing'!

displayString
    ^ self class name , '(' , (name ? '??' ) , ')'

    "Created: / 30.1.2002 / 14:52:54 / cg"
! !

!XDRItem methodsFor:'queries'!

isProgram
    ^ false
! !

!XDRItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRItem.st,v 1.10 2017-11-18 09:52:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRItem.st,v 1.10 2017-11-18 09:52:00 cg Exp $'
! !

