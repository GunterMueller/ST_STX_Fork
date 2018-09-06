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

"{ Package: 'stx:libwidg2' }"

ListEntry subclass:#ModelListEntry
	instanceVariableNames:'string model'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!ModelListEntry class methodsFor:'documentation'!

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
    Use this class, if you provide some SelectionInListView, ComboBox, etc. with
    both a display string, and you want to store some model specific information, too.

    You can store a class, a selector to perform, a factory object or anything else
    in model.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        string          String          string to display
        model           Object          anything you want to store

    [class variables:]

    [see also:]

"
! !

!ModelListEntry class methodsFor:'instance creation'!

string:stringArg model:modelArg

    ^ self new string:stringArg model:modelArg
! !

!ModelListEntry methodsFor:'accessing'!

model
    ^ model
!

model:something
    model := something.
!

string
    ^ string
!

string:something
    string := something.
!

string:stringArg model:modelArg 
    string := stringArg.
    model := modelArg.
! !

!ModelListEntry methodsFor:'required protocol'!

asString

    ^ string
!

displayOn:arg1 x:arg2 y:arg3 opaque:arg4

    ^ string displayOn:arg1 x:arg2 y:arg3 opaque:arg4
!

sameStringAndEmphasisAs:aStringOrText

    aStringOrText class == self class ifTrue:[
        ^ string sameStringAndEmphasisAs:aStringOrText string
    ].
    ^ string sameStringAndEmphasisAs:aStringOrText
!

widthOn:arg

    ^ string widthOn:arg
! !

!ModelListEntry methodsFor:'string protocol'!

expandPlaceholdersWith:argArrayOrDictionary
    ^ self copy string:(string expandPlaceholdersWith:argArrayOrDictionary)
! !

!ModelListEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ModelListEntry.st,v 1.4 2004-02-25 16:09:56 cg Exp $'
! !
