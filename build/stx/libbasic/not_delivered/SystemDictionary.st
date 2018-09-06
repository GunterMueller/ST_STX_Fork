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

Collection subclass:#SystemDictionary
       instanceVariableNames:'sysId'
       classVariableNames:''
       poolDictionaries:''
       category:'System-Support'
!

!SystemDictionary class methodsFor:'documentation'!

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

version
    ^ '$Header: /cvs/stx/stx/libbasic/not_delivered/SysDict.st,v 1.1 1996/09/12 01:05:30 cg Exp $'
!

documentation
"
    SystemDictionaries are nameSpaces, which are also known in the c-world
    somehow (i.e. names found in SystemDictionaries may also be known as
    a c-global).

    As you will notice, this is NOT a Dictionary
     - my implementation of globals is totally different
       (due to the need to be able to access globals from c-code as well).
    However, it provides the known enumeration protocol.

    Instance variables:
	sysId           <SmallInteger>  the dictionaries id
"
! !

!SystemDictionary methodsFor:'accessing'!

at:aKey
    "retrieve the value stored under aKey, which must be some kind of symbol.
     Return nil if not present."

%{  /* NOCONTEXT */
    extern OBJ _SYSDICT_GET();

    if (__isSmallInteger(__INST(sysId))) {
	RETURN ( _SYSDICT_GET(__intVal(__INST(sysId)), aKey) );
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed
!

at:aKey ifAbsent:aBlock
    "retrieve the value stored under aKey.
     If there is none stored this key, return the value of
     the evaluation of aBlock"

    (self includesKey:aKey) ifTrue:[
	^ self at:aKey
    ].
    ^ aBlock value
!

at:aKey put:aValue
    "store the argument aValue under aKey, which must be some kind of symbol."

%{  /* NOCONTEXT */
    if (__isSmallInteger(__INST(sysId))) {
	_SYSDICT_SET(__intVal(__INST(sysId)), aKey, aValue, (OBJ *)0);
	RETURN (aValue);
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed
!

removeKey:aKey
    "remove the argument from the globals dictionary"

%{  /* NOCONTEXT */
    extern OBJ _SYSDICT_REMOVE();

    if (__isSmallInteger(__INST(sysId))) {
	RETURN ( _SYSDICT_REMOVE(__intVal(__INST(sysId)), aKey) );
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed
!

includesKey:aKey
    "return true, if the key is known"

%{  /* NOCONTEXT */
    extern OBJ _SYSDICT_KEYKNOWN();

    if (__isSmallInteger(__INST(sysId))) {
	RETURN ( _SYSDICT_KEYKNOWN(__intVal(__INST(sysId)), aKey) );
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed
!

keyAtValue:anObject
    "return the symbol under which anObject is stored - or nil"

    self allKeysDo:[:aKey |
	(self at:aKey) == anObject ifTrue:[^ aKey]
    ]

    "Smalltalk keyAtValue:Object"
!

keys
    "return a collection with all keys in the Smalltalk dictionary"

    |keys|

    keys := IdentitySet new.
    self allKeysDo:[:k | keys add:k].
    ^ keys
! !

!SystemDictionary class methodsFor:'copying'!

shallowCopy
    "redefine copy - there is only one instance of each dictionary"

    ^ self
!

simpleDeepCopy
    "redefine copy - there is only one instance of each dictionary"

    ^ self
!

deepCopyUsing:aDictionary
    "redefine copy - there is only one instance of each dictionary"

    ^ self
!

deepCopy
    "redefine copy - there is only one instance of each dictionary"

    ^ self
! !

!SystemDictionary methodsFor:'inspecting'!

inspect
    "redefined to launch a DictionaryInspector on the receiver
     (instead of the default InspectorView)."

    DictionaryInspectorView isNil ifTrue:[
	super inspect
    ] ifFalse:[
	DictionaryInspectorView openOn:self
    ]
! !

!SystemDictionary methodsFor:'enumeration'!

do:aBlock
    "evaluate the argument, aBlock for all values in the dictionary"
%{
    if (__isSmallInteger(__INST(sysId))) {
	_SYSDICT_DO(__intVal(__INST(sysId)), &aBlock COMMA_CON);
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed

    "
     Smalltalk do:[:value | value class name printNL]
    "
!

allKeysDo:aBlock
    "evaluate the argument, aBlock for all keys in the dictionary"
%{
    if (__isSmallInteger(__INST(sysId))) {
	_SYSDICT_KEYSDO(__intVal(__INST(sysId)), &aBlock COMMA_CON);
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed

    "
     Smalltalk allKeysDo:[:key | key printNL]
    "
!

associationsDo:aBlock
    "evaluate the argument, aBlock for all key/value pairs 
     in the dictionary"

    self allKeysDo:[:aKey |
	aBlock value:(aKey -> (self at:aKey))
    ]

    "
     Smalltalk associationsDo:[:assoc | assoc printNL]
    "
!

keysAndValuesDo:aBlock
    "evaluate the two-arg block, aBlock for all keys and values"

    self allKeysDo:[:aKey |
	aBlock value:aKey value:(self at:aKey)
    ]
! !

!SystemDictionary methodsFor:'queries'!

cellAt:aKey
    "return the address of a global cell
     - used internally for compiler only"

%{  /* NOCONTEXT */
    extern OBJ _SYSDICT_GETCELL();

    if (__isSmallInteger(__INST(sysId))) {
	RETURN ( _SYSDICT_GETCELL(__intVal(__INST(sysId)), aKey) );
    }
%}.
    "
     the receiver is not a valid systemDictionary
    "
    self pimitiveFailed
!

references:anObject
    "return true, if I refer to the argument, anObject
     must be reimplemented since systemDictionaries are no real collections."

    self do:[:o |
	(o == anObject) ifTrue:[^ true]
    ].
    ^ false
! !

!SystemDictionary class methodsFor: 'binary storage'!

addGlobalsTo:globalDictionary manager: manager
    |pools|

    pools := Set new.
    self associationsDo:[:assoc |
	|value|

	value := assoc value.
	value == self ifFalse:[
	    value isClass ifTrue:[
		value addGlobalsTo:globalDictionary manager:manager.
		pools addAll:value sharedPools
	    ] ifFalse:[
		globalDictionary at:assoc put:self
	    ].
	    value isNil ifFalse:[
		globalDictionary at:value put:self
	    ]
	]
    ].

    pools do:[:poolDictionary|
	poolDictionary addGlobalsTo:globalDictionary manager:manager
    ]
!

storeBinaryDefinitionOf:anObject on:stream manager:manager
    |string|

    anObject class == Association ifTrue:[
	string := 'Smalltalk associationAt:', anObject key storeString
    ] ifFalse: [
	string := 'Smalltalk at:', (self keyAtValue: anObject) storeString
    ].
    stream nextNumber:2 put:string size.
    string do:[:char | stream nextPut:char asciiValue]
! !





