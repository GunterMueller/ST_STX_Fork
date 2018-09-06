"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libboss' }"

"{ NameSpace: Smalltalk }"

nil subclass:#ObsoleteObject
	instanceVariableNames:''
	classVariableNames:'ObsoleteObjectSignal'
	poolDictionaries:''
	category:'System-BinaryStorage'
!

!ObsoleteObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    This class is used for error handling during binary object restoration.
    Whenever an object whose class has changed (i.e. it was stored with a
    different layout/size) is about to be restored, it cannot be made an
    instance of the now existing class.
    In this case, the BinaryInputManager will create a dummy class for the
    old (obsolete) object and make the restored object an instance of it.
    This dummy class will be a subclass of ObsoleteObject.
    Thus, the restored obsolete object will (at least) provide the data
    (i.e. the contents) of the original object - although it will obviously
    not be able to implement the original protocol.

    After the creation of the obsolete object, a signal will be raised (in
    BinaryInputManager), which can be caught by the application to provide
    a replacement class and/or to try some automatic or semi-automatic object
    conversion.
    The signal gets the obsolete object and the new class as parameters, so
    a handler can extract instance values from the obsolete object and construct a
    replacement object from those.

    ObsoleteObject itself catches all messages, to avoid any use of the restored
    object (in case conversion failed or the signal was ignored).

    Read the documentation on binary object storage for examples & code fragments,
    on obsolete object handling and object migration.

    [author:]
        Claus Gittinger

    [see also:]
        BinaryObjectStorage
        BinaryIOManager
        PersistencyManager
        (binary object storage : programming/binaryStore.html )
"
! !

!ObsoleteObject class methodsFor:'initialization'!

initialize

    ObsoleteObjectSignal isNil ifTrue:[
        ObsoleteObjectSignal := (Signal new) mayProceed:false.
        ObsoleteObjectSignal nameClass:self message:#obsoleteObjectSignal.
        ObsoleteObjectSignal notifierString:'use of obsolete object'.

        self setSuperclass:nil
    ]

    "Modified: 30.4.1996 / 14:46:13 / cg"
! !

!ObsoleteObject class methodsFor:'Signal constants'!

obsoleteObjectSignal
    "return the signal raised when a message is sent to an Obsolete
     signal."

    ^ ObsoleteObjectSignal

    "Modified: 30.4.1996 / 14:46:27 / cg"
! !

!ObsoleteObject methodsFor:'message catching'!

doesNotUnderstand: aMessage
    "the only thing obsolete objects understand is that they don't understand
     anything."

    ^ ObsoleteObjectSignal 
             raiseRequestWith:aMessage

    "Modified: 23.9.1996 / 15:17:37 / cg"
! !

!ObsoleteObject methodsFor:'required protocol'!

basicAt:index
    "this method is required to allow cloning of the object"

    ^ (Object compiledMethodAt:#basicAt:)
	valueWithReceiver:self
	arguments:(Array with:index)
	selector:#basicAt:
!

basicAt:index put:something
    "this method is required to allow restore of the object"

    ^ (Object compiledMethodAt:#basicAt:put:)
	valueWithReceiver:self
	arguments:(Array with:index with:something)
	selector:#basicAt:put:
!

basicInspect
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#basicInspect)
        valueWithReceiver:self
        arguments:nil
        selector:#basicInspect

    "Modified: / 30.10.1997 / 14:16:45 / cg"
!

basicSize
    "this method is required to allow restore of the object"

    ^ (Object compiledMethodAt:#basicSize)
	valueWithReceiver:self
	arguments:nil
	selector:#basicSize
!

become:index
    "this method is required to allow cloning of the object"

    ^ (Object compiledMethodAt:#become:)
        valueWithReceiver:self
        arguments:(Array with:index)
        selector:#become:

    "Created: 23.9.1996 / 15:16:37 / cg"
!

becomeNil
    "this method is required to allow restore of the object"

    ^ (Object compiledMethodAt:#becomeNil)
        valueWithReceiver:self
        arguments:nil
        selector:#becomeNil

    "Created: 23.9.1996 / 15:17:14 / cg"
!

becomeSameAs:anObject
    "this method is required to allow cloning of the object"

    ^ (Object compiledMethodAt:#becomeSameAs:)
        valueWithReceiver:self
        arguments:(Array with:anObject)
        selector:#becomeSameAs:

    "Created: 23.9.1996 / 15:16:50 / cg"
!

displayOn:aGcOrStream 
    "return a printed representation of the receiver for displaying.
     This method is required to allow inspection of the object."

    ^ (Object compiledMethodAt:#displayOn: )
        valueWithReceiver:self
        arguments:(Array with:aGcOrStream)
        selector:#displayOn:
!

displayString 
    "return a printed representation of the receiver for displaying.
     This method is required to allow inspection of the object."

    ^ (Object compiledMethodAt:#displayString )
        valueWithReceiver:self
        arguments:nil
        selector:#displayString

    "Modified: 20.9.1997 / 11:40:53 / cg"
!

inspect
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#inspect)
        valueWithReceiver:self
        arguments:nil
        selector:#inspect

    "Modified: / 30.10.1997 / 14:16:33 / cg"
!

instVarAt:index
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#instVarAt:)
	valueWithReceiver:self
	arguments:(Array with:index)
	selector:#instVarAt:
!

instVarAt:index put:something
    "this method is required to allow restore of the object"

    ^ (Object compiledMethodAt:#instVarAt:put:)
	valueWithReceiver:self
	arguments:(Array with:index with:something)
	selector:#instVarAt:put:
!

isKindOf:aClass
    "this method is required to allow restore of the object"

    aClass == Object ifTrue:[^ true].
    ^ (Object compiledMethodAt:#isKindOf:)
	valueWithReceiver:self
	arguments:(Array with:aClass)
	selector:#isKindOf:
!

readBinaryContentsFrom:stream manager:manager
    "this method is required to allow restore of the object"

    ^ (Object compiledMethodAt:#readBinaryContentsFrom:manager:)
	valueWithReceiver:self
	arguments:(Array with:stream with:manager)
	selector:#readBinaryContentsFrom:manager:
!

readBinaryContentsFromData:instvarArray manager:manager
    "this method is required to allow restore of the object"

    | originalClass newObject |

    originalClass := Smalltalk at:(self class name) asSymbol ifAbsent:nil.
    originalClass notNil ifTrue:[
        newObject := originalClass cloneFrom:self.
        self becomeSameAs:newObject.
        newObject readBinaryContentsFromData:instvarArray manager:manager.
        ^ newObject.
    ].
! !

!ObsoleteObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/ObsoleteObject.st,v 1.23 2017-11-28 14:15:27 mawalch Exp $'
! !


ObsoleteObject initialize!
