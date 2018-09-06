"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libview2' }"

IdentityDictionary subclass:#PropertyListDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!PropertyListDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    Instances are used temporarily by the UISpecification to keep dynamic
    properties for a view.
    For example, all the callbacks used by the drag & drop operation are
    stored.

    [author:]
        Claus Atzkern

    [see also:]
        UISpecification
"
! !

!PropertyListDictionary methodsFor:'accessing'!

at:aKey
    "returns the value stored under the key or nil"

    ^ self at:aKey ifAbsent:nil
!

dropSourceFor:aReceiver
    "returns the DropSource for a receiver or nil"

    |source|

    self canDrag ifTrue:[
        source := DropSource 
                    receiver:aReceiver
                    argument:(self at:#dragArgument:)
                    dropObjectSelector:(self at:#dropObjectSelector:)
                    displayObjectSelector:(self at:#displayObjectSelector:)
                    dropFeedBackSelector:(self at:#feedBackSelector:).

        source startDragSelector:(self at:#startDragSelector:).
        ^ source
    ].
    ^ nil
!

dropTargetFor:aReceiver
    "returns the DropTarget for a receiver or nil"

    |target|

    self canDrop ifTrue:[
        target := DropTarget 
                    receiver:aReceiver
                    argument:(self at:#dropArgument:)
                    dropSelector:(self at:#dropSelector:) 
                    canDropSelector:(self at:#canDropSelector:).

        target enterSelector:(self at:#enterSelector:).
        target  overSelector:(self at:#overSelector:).
        target leaveSelector:(self at:#leaveSelector:).
        ^ target
    ].
    ^ nil
! !

!PropertyListDictionary methodsFor:'building'!

actionSelectors
    "returns the list of action selectors" 

    |list|

    list := OrderedCollection new.

    self keysAndValuesDo:[:aKey :aVal|
        (aVal isSymbol and:[self isActionSelector:aKey]) ifTrue:[
            list add:aVal
        ]
    ].
    ^ list        
!

aspectSelectors
    "returns the list of aspect selectors or nil" 

    ^ nil        
! !

!PropertyListDictionary methodsFor:'converting'!

fromLiteralArrayEncoding:aLiteralEncodedArray
    "read my values from an encoding"

    |key val|

    2 to:aLiteralEncodedArray size-1 by:2 do:[:i |
        key := aLiteralEncodedArray at:i.
        val := (aLiteralEncodedArray at:i+1) decodeAsLiteralArray.

        self at:key put:val
    ]
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    |coll|

    coll := OrderedCollection new.
    coll add:self class name.

    self keysAndValuesDo:[:aKey :aVal|
        coll add:aKey; add:(aVal literalArrayEncoding)
    ].
    ^ coll asArray
! !

!PropertyListDictionary methodsFor:'queries'!

canDrag
    "returns true if the receiver of the property list is draggable"

    ^ self includesKey:#dropObjectSelector:
!

canDrop
    "returns true if the receiver of the property list is droppable"

    ^ self includesKey:#dropSelector:
!

isActionSelector:aKey
    "returns true if the key is an action selector"

    ^ (     aKey ~~ #dragArgument:
       and:[aKey ~~ #dropArgument:]
      )
! !

!PropertyListDictionary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PropertyListDictionary.st,v 1.7 2006-07-03 16:10:27 stefan Exp $'
! !
