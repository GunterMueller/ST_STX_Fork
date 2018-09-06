"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

Object subclass:#VMBehavior
	instanceVariableNames:'superclass flags selectorArray methodArray'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!VMBehavior class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This class describes what the VM considers to be a classLike object.
    Every class in the system inherits from VMBehavior (via Behavior, Class, ClassDescription).

    In contrast to Behavior (which describes smalltalk behavior), the things defined
    here are valid for all objects for which the VM can do a method lookup.
    In theory, you can create totally different object systems on top of VMBehavior.
    This class is purely abstract - therefore, no smalltalk behavior is defined here.

    This is certainly not for normal applications.

    Instance variables:

	superclass        <Class>           where lookup continues when a selector is not
					    found in the selector array
					    (i.e. the superclass in Smalltalk terms)

	selectorArray     <Array of Symbol> the selectors for which inst-methods are defined here

	methodArray       <Array of Method> the inst-methods corresponding to the selectors

	flags             <SmallInteger>    special flag bits coded in a number
					    not for application use

    flag bits (see stc.h):

    NOTICE: layout known by compiler and runtime system; be careful when changing
"
! !

!VMBehavior class methodsFor:'initialization'!

initialize
    self == VMBehavior ifTrue:[
        self flags:(self flagBehavior).
    ]

    "
      self initialize
    "
! !

!VMBehavior class methodsFor:'flag bit constants'!

flagBehavior
    "return the flag code which marks Behavior-like instances.
     You have to check this single bit in the flag value when
     checking for behaviors."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(BEHAVIOR_INSTS) );
%}

    "consistency check:
     all class-entries must be behaviors;
     all behaviors must be flagged so (in its class's flags)
     (otherwise, VM will bark)
     all non-behaviors may not be flagged

     |bit|
     bit := Class flagBehavior.

     ObjectMemory allObjectsDo:[:o|
       o isBehavior ifTrue:[
	 (o class flags bitTest:bit) ifFalse:[
	     self halt
	 ].
       ] ifFalse:[
	 (o class flags bitTest:bit) ifTrue:[
	     self halt
	 ].
       ].
       o class isBehavior ifFalse:[
	 self halt
       ] ifTrue:[
	 (o class class flags bitTest:bit) ifFalse:[
	     self halt
	 ]
       ]
     ]
    "
!

flagBlock
    "return the flag code which marks Block-like instances.
     You have to check this single bit in the flag value when
     checking for blocks."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(BLOCK_INSTS) );
%}
!

flagBlockContext
    "return the flag code which marks BlockContext-like instances.
     You have to check this single bit in the flag value when
     checking for blockContexts."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(BCONTEXT_INSTS) );
%}
!

flagBytes
    "return the flag code for byte-valued indexed instances.
     You have to mask the flag value with indexMask when comparing
     it with flagBytes."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(BYTEARRAY) );
%}
    "
     Behavior flagBytes    
    "
!

flagContext
    "return the flag code which marks Context-like instances.
     You have to check this single bit in the flag value when
     checking for contexts."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(CONTEXT_INSTS) );
%}
!

flagDoubles
    "return the flag code for double-valued indexed instances (i.e. 8-byte reals).
     You have to mask the flag value with indexMask when comparing
     it with flagDoubles."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(DOUBLEARRAY) );
%}
    "
     Behavior flagDoubles    
    "
!

flagFloat
    "return the flag code which marks Float-like instances.
     You have to check this single bit in the flag value when
     checking for floats."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(FLOAT_INSTS) );
%}
!

flagFloats
    "return the flag code for float-valued indexed instances (i.e. 4-byte reals).
     You have to mask the flag value with indexMask when comparing
     it with flagFloats."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(FLOATARRAY) );
%}
    "
     Behavior flagFloats    
    "
!

flagLongs
    "return the flag code for long-valued indexed instances (i.e. 4-byte).
     You have to mask the flag value with indexMask when comparing
     it with flagLongs."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(LONGARRAY) );
%}
    "
     Behavior flagLongs    
    "
!

flagMethod
    "return the flag code which marks Method-like instances.
     You have to check this single bit in the flag value when
     checking for methods."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(METHOD_INSTS) );
%}
!

flagNotIndexed
    "return the flag code for non-indexed instances.
     You have to mask the flag value with indexMask when comparing
     it with flagNotIndexed."

    ^ 0
!

flagPointers
    "return the flag code for pointer indexed instances (i.e. Array of object).
     You have to mask the flag value with indexMask when comparing
     it with flagPointers."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(POINTERARRAY) );
%}
    "
     Behavior flagPointers    
    "
!

flagSymbol
    "return the flag code which marks Symbol-like instances.
     You have to check this single bit in the flag value when
     checking for symbols."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(SYMBOL_INSTS) );
%}
!

flagWeakPointers
    "return the flag code for weak pointer indexed instances (i.e. WeakArray).
     You have to mask the flag value with indexMask when comparing
     it with flagWeakPointers."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(WKPOINTERARRAY) );
%}
!

flagWords
    "return the flag code for word-valued indexed instances (i.e. 2-byte).
     You have to mask the flag value with indexMask when comparing
     it with flagWords."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(WORDARRAY) );
%}
    "
     Behavior flagWords    
    "
!

maskIndexType
    "return a mask to extract all index-type bits"

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

    RETURN ( _MKSMALLINT(ARRAYMASK) );
%}
! !

!VMBehavior class methodsFor:'private'!

basicNew
    "I dont know how to do this ..."

    ^ self subclassResponsibility
!

basicNew:size
    "I dont know how to do this ..."

    ^ self subclassResponsibility
!

new
    "I dont know how to do this ..."

    ^ self subclassResponsibility
!

new:size
    "I dont know how to do this ..."

    ^ self subclassResponsibility
! !

!VMBehavior class methodsFor:'queries'!

isBuiltInClass
    "this class is known by the run-time-system"

    ^ true
! !

!VMBehavior methodsFor:'accessing'!

flags
    "return the receivers flag bits"

    ^ flags
!

methodArray
    "return the receivers method array.
     Notice: this is not compatible with ST-80."

    ^ methodArray
!

selectorArray 
    "return the receivers selector array.
     Notice: this is not compatible with ST-80."

    ^ selectorArray
!

selectors:newSelectors methods:newMethods
    "set both selector array and method array of the receiver,
     and flush caches"

    ObjectMemory flushCaches.
    selectorArray := newSelectors.
    methodArray := newMethods
!

superclass
    "return the receivers superclass"

    ^ superclass
! !

!VMBehavior methodsFor:'private accessing'!

setFlags:aNumber
    "set the flags.
     Do NOT use it."

    flags := aNumber
!

setMethodArray:anArray
    "set the method array of the receiver.
     this method is for special uses only - there will be no recompilation
     and no change record written here.
     NOT for general use."

    methodArray := anArray
!

setSelectorArray:anArray
    "set the selector array of the receiver.
     this method is for special uses only - there will be no recompilation
     and no change record written here.
     NOT for general use."

    selectorArray := anArray
!

setSelectors:sels methods:m
    "set some inst vars. 
     this method is for special uses only - there will be no recompilation
     and no change record written here; 
     Do NOT use it."

    selectorArray := sels.
    methodArray := m.
!

setSuperclass:aClass
    "set the superclass of the receiver.
     this method is for special uses only - there will be no recompilation
     and no change record written here. Also, if the receiver class has
     already been in use, future operation of the system is not guaranteed to
     be correct, since no caches are flushed.
     Therefore: do NOT use it; use Behavior>>superclass: (or flush the caches, at least)"

    superclass := aClass
! !

!VMBehavior methodsFor:'queries'!

cachedLookupMethodFor:aSelector
    "return the method, which would be executed if aSelector was sent to
     an instance of the receiver. I.e. the selector arrays of the receiver
     and all of its superclasses are searched for aSelector.
     Return the method, or nil if instances do not understand aSelector.
     This interface provides exactly the same information as #lookupMethodFor:,
     but uses the lookup-cache in the VM for faster search. 
     However, keep in mind, that doing a lookup through the cache also adds new
     entries and can thus slow down the system by polluting the cache with 
     irrelevant entries. (do NOT loop over all objects calling this method).
     Does NOT (currently) handle MI"

%{  /* NOCONTEXT */
    RETURN ( __lookup(self, aSelector, SENDER) );
%}

    "
     String cachedLookupMethodFor:#=
     String cachedLookupMethodFor:#asOrderedCollection
    "
!

isBits
    "return true, if instances have indexed byte or short instance variables.
     Ignore long, float and double arrays, since ST-80 code using isBits are probably
     not prepared to handle them correctly."

%{  /* NOCONTEXT */

    REGISTER int flags;

    RETURN ( (((flags = (_intVal(_INST(flags)) & ARRAYMASK)) == BYTEARRAY)
	     || (flags == WORDARRAY)) ? true : false ); 
%}
!

isBytes
    "return true, if instances have indexed byte instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) == VMBehavior flagBytes
    "
%{  /* NOCONTEXT */

    RETURN ( ((_intVal(_INST(flags)) & ARRAYMASK) == BYTEARRAY) ? true : false ); 
%}
!

isDoubles
    "return true, if instances have indexed double instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) == VMBehavior flagDoubles
    "
%{  /* NOCONTEXT */

    RETURN ( ((_intVal(_INST(flags)) & ARRAYMASK) == DOUBLEARRAY) ? true : false ); 
%}
!

isFixed
    "return true, if instances do not have indexed instance variables"

    "this could be defined as:
	^ self isVariable not
    "

%{  /* NOCONTEXT */

    RETURN ( (_intVal(_INST(flags)) & ARRAYMASK) ? false : true ); 
%}
!

isFloats
    "return true, if instances have indexed float instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) == VMBehavior flagFloats
    "
%{  /* NOCONTEXT */

    RETURN ( ((_intVal(_INST(flags)) & ARRAYMASK) == FLOATARRAY) ? true : false ); 
%}
!

isLongs
    "return true, if instances have indexed long instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) == VMBehavior flagLongs
    "
%{  /* NOCONTEXT */

    RETURN ( ((_intVal(_INST(flags)) & ARRAYMASK) == LONGARRAY) ? true : false ); 
%}
!

isPointers
    "return true, if instances have pointer instance variables 
     i.e. are either non-indexed or have indexed pointer variables"

    "QUESTION: should we ignore WeakPointers ?"

%{  /* NOCONTEXT */

    REGISTER int flags;

    flags = _intVal(_INST(flags)) & ARRAYMASK;
    switch (flags) {
	default:
	    /* normal objects */
	    RETURN ( true );

	case BYTEARRAY:
	case WORDARRAY:
	case LONGARRAY:
	case FLOATARRAY:
	case DOUBLEARRAY:
	    RETURN (false );

	case WKPOINTERARRAY:
	    /* what about those ? */
	    RETURN (true );
    }
%}
!

isVariable
    "return true, if instances have indexed instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) ~~ 0
     "

%{  /* NOCONTEXT */

    RETURN ( (_intVal(_INST(flags)) & ARRAYMASK) ? true : false ); 
%}
!

isWords
    "return true, if instances have indexed short instance variables"

    "this could be defined as:
	^ (flags bitAnd:(VMBehavior maskIndexType)) == VMBehavior flagWords
    "
%{  /* NOCONTEXT */

    RETURN ( ((_intVal(_INST(flags)) & ARRAYMASK) == WORDARRAY) ? true : false ); 
%}
!

lookupMethodFor:aSelector
    "return the method, which would be executed if aSelector was sent to
     an instance of the receiver. I.e. the selector arrays of the receiver
     and all of its superclasses are searched for aSelector.
     Return the method, or nil if instances do not understand aSelector.
     EXPERIMENTAL: take care of multiple superclasses."

    |m cls|

    cls := self.
    [cls notNil] whileTrue:[
	m := cls compiledMethodAt:aSelector.
	m notNil ifTrue:[^ m].
	cls := cls superclass
    ].
    ^ nil
! !

!VMBehavior class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/not_delivered/VMBehavior.st,v 1.1 1996/09/12 01:03:24 cg Exp $'
! !
VMBehavior initialize!





