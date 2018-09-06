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
"{ Package: 'stx:libui' }"

NoteBookSpec subclass:#TabControlSpec
	instanceVariableNames:'labels'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!TabControlSpec class methodsFor:'documentation'!

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

!TabControlSpec methodsFor:'accessing'!

labels
    "return the value of the instance variable 'labels' (automatically generated)"

    ^ labels
!

labels:something
    "set the value of the instance variable 'labels' (automatically generated)"

    labels := something.
! !

!TabControlSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    aView canvas:(SubCanvas new).

    super setAttributesIn:aView with:aBuilder.

    self setModelAttributeIn:aView with:aBuilder.

    labels size > 0 ifTrue:[
        "/ aView list:labels 
        aView listHolder isList ifTrue:[
            aView listHolder contents:labels
        ] ifFalse:[
            aView listHolder value:labels
        ]
    ].
!

setModelAttributeIn:aView with:aBuilder
    |m|

    aBuilder isEditing ifFalse:[
        m := self modelInBuilder:aBuilder.
        (m isKindOf:SelectionInList) ifTrue:[
            aView listHolder:(m listHolder).
            aView model:(m selectionIndexHolder).
        ] ifFalse:[
            aView model:m
        ].
        "/ m onChangeEvaluate:[self halt].
    ]
! !

!TabControlSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    super fromLiteralArrayEncoding:aSpecArray.

    labels notNil ifTrue:[
        labels := labels decodeAsLiteralArray.
    ].
! !

!TabControlSpec methodsFor:'queries'!

viewClass
    "return the corresponding view class of the spec"

    ^ TabControl
! !

!TabControlSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/TabControlSpec.st,v 1.5 2012-08-23 13:09:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/TabControlSpec.st,v 1.5 2012-08-23 13:09:57 cg Exp $'
! !
