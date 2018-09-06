"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SubChannelInfoSpec
	instanceVariableNames:'subAspect aspect type callBack description'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SubChannelInfoSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



! !

!SubChannelInfoSpec methodsFor:'accessing'!

aspect
    "return the value of the instance variable 'aspect' (automatically generated)"

    ^ aspect
!

aspect:something
    "set the value of the instance variable 'aspect' (automatically generated)"

    aspect := something.
!

aspectCanBeEdited
"/   type == #action ifTrue:[^ false].
   ^ true

!

aspectString
"/    type == #action ifTrue:[^ '** action only **'].
    ^ aspect

!

callBack
    "return the value of the instance variable 'callBack' (automatically generated)"

    ^ callBack
!

callBack:something
    "set the value of the instance variable 'callBack' (automatically generated)"

    callBack := something.
!

description
    "return the value of the instance variable 'description' (automatically generated)"

    ^ description
!

description:something
    "set the value of the instance variable 'description' (automatically generated)"

    description := something.
!

subAspect
    "return the value of the instance variable 'subAspect' (automatically generated)"

    ^ subAspect
!

subAspect:something
    "set the value of the instance variable 'subAspect' (automatically generated)"

    subAspect := something.
!

type
    "return the value of the instance variable 'type' (automatically generated)"

    ^ type
!

type:something
    "set the value of the instance variable 'type' (automatically generated)"

    type := something.
!

typeString
    type isNil ifTrue:[ ^ 'V' ].        "/ valueHolder-like
    ^ type first asUppercase asString.  "/ #action etc.

! !

!SubChannelInfoSpec methodsFor:'converting'!

literalArrayEncoding
    "redefined to skip the type"

    |savedType encoding|

    savedType := type.
    encoding := super literalArrayEncoding.
    type := savedType.
    ^ encoding
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"
    "redefined to skip the type"

    ^ #( #type )

    "Modified (comment): / 09-08-2018 / 17:17:08 / Claus Gittinger"
! !

!SubChannelInfoSpec methodsFor:'misc'!

normalize
    "clear empty selector strings to nil"

    aspect := self normalizedSelector:aspect.
    subAspect := self normalizedSelector:subAspect.
    callBack := self normalizedSelector:callBack.
!

normalizedSelector:sel
    sel size == 0 ifTrue:[
        ^ nil
    ].
    ^ sel string asSymbol
! !

!SubChannelInfoSpec methodsFor:'printing'!

printOn:aStream
    aStream 
        nextPutAll:subAspect;
        nextPutAll:'->';
        nextPutAll:(aspect ? callBack)

    "Created: / 20-07-2011 / 14:33:24 / cg"
! !

!SubChannelInfoSpec methodsFor:'queries'!

hasNonNilAspectOrCallBack
    ^ aspect notNil or:[callBack notNil]
! !

!SubChannelInfoSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SubChannelInfoSpec.st,v 1.8 2018-08-09 15:18:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/SubChannelInfoSpec.st,v 1.8 2018-08-09 15:18:59 cg Exp $'
! !

