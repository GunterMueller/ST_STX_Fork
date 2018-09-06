"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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

Object subclass:#Behavior
	instanceVariableNames:'superclass flags methodDictionary
	lookupObject instSize'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!Behavior class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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
    Every class in the system inherits from Behavior (via Class, ClassDescription);
    so here is where most of the class messages end up being implemented.
    (to answer a FAQ: 'Point basicNew' will be done here :-)

    Beginners should keep in mind, that all classes are instances (of subclasses)
    of Behavior, therefore you will find the above mentioned 'basicNew:' method
    under the 'instance'-methods of Behavior - NOT under the class methods
    ('Behavior new' will create and return a new class, while sending 'new' to
    any instance of Behavior (i.e. any class) will return an instance of that class).


    Behavior provides minimum support for all class-like objects, which define behavior
    of other objects. Additional stuff (meta info) is found in ClassDescription and Class.
    Behavior provides all mechanisms needed to create instances (on the class side),
    and send messages to them.
    However, Behavior does not provide the (symbolic) information needed to compile methods
    for a class or to get useful information in inspectors or browsers.

    For experts:

    Since instances of Behavior provide all that is needed to interact with the VM's
    message dispatch mechanism, these can be used as 'light weight' classes.
    I.e. it is possible, to generate completely anonymous classes (and instances thereof)
    on the fly - 'Behavior new new' is such a thingy.

    The selectors and methods are organized in a MethodDictionary (which is not a true
    dictionary, but an Array with alternating selector/method entries).
    This avoids the need for knowledge about Dictionaries in the runtime library (VM)
    (lookup and search in these is seldom anyway, so the added benefit from using a
     hashed dictionary is almost void).

    [Instance variables:]

	superclass        <Class>            the classes superclass

	methodDictionary  <MethodDictionary> inst-selectors and methods

	instSize          <SmallInteger>     the number of instance variables

	flags             <SmallInteger>     special flag bits coded in a number
					     not for application use

    flag bits (see stc.h):

    NOTICE: layout known by compiler and runtime system; be careful when changing

    [author:]
	Claus Gittinger

    [see also:]
	Class ClassDescription Metaclass
	Method MethodDictionary
"
!

virtualMachineRelationship
"
    Expert info follows:
    --------------------
    NOTICE:
	the stuff described below may not be available on other
	Smalltalk implementations; be aware that these error mechanisms
	are ST/X specials and applications using these (tricks) may
	not be portable to other systems.

    WARNING:
	do not try the examples below on (some) other smalltalk systems;
	it has been reported, that some crash badly when doing this .... ;-)

    Instances of Behavior and subclasses (i.e. in sloppy words: classes)
    play a special role w.r.t. the VM. Only objects whose class-slot is marked
    as being behaviorLike (in the flag-instvar) are considered to be classLike
    and a message lookup will be done for it in the well known way.
    Thus, if an object has a class for which its class does NOT have
    this flag bit set, the VM will trigger an error on a message send.


    Why is this so:
    ---------------
    the above lets every object play the role of a class,
    which has been flagged as behaviorLike in its class's flag.
    Thus, you can create arbitrary new classLike objects and have the VM
    play with them.
    This may offer the flexibility to create a totally different object scheme
    on top of ST/X (for example: Self like objects) where any object can play
    a classRole for another object or even for itself.

    [A concrete application of this is found in the Structure class,
     which creates objects which are their own class !!
     This may look to be of theoretical value at first sight,
     however, such a construct saves memory, by not requiring an extra
     class object per Structure object.]

    Be aware, that the VM trusts the isBehaviorLike flag - IF it is set for some
    object, the VM EXPECTS the object selector and methodDictionaries to be found
    at the instance positions as defined here.
    (i.e. instanceVariables with contents and semantic corresponding to
	superclass
	flags
	methodDictionary
     must be present and have the same instVar-index as here).

    The VM (and the system) may crash badly, if this is not the case.

    Since every class in the system derives from Behavior, the flag setting
    (and instance variable layout) is correct for all 'normal' classes.
    If you experiment by creating new behaviorLike objects, please take
    care of this flag. If you want to use the VM's lookup function, the
    instVars  'superclass' and 'methodDictionary' are required
    and have to be at the same instVar index.
    (we suggest, you subclass Behavior, to make certain)


    Vice versa, defining 'dumb classes', which have the behaviorLike bit turned
    off may be useful as well; if a message is sent to an instance of such
    a thingy, the VM performs a recovery sequence, which is much like the
    #doesNotUnderstand: mechanism - however, since the instance is no good
    receiver of such a message, a #cannotSendMessage:to: is now sent to the
    class (which is not a real class), passing the original message (selector
    and arguments) along with the original receiver.
    The default behavior for this message is to raise an internalError signal -
    however, you may redefine this in your 'dum class' for recovery.
    One possible use of this is to provide new message send algorithms - the
    class may lookup a method and invoke it directly, via the #valueWithReceiver:
    interface.

    All of the above is pure expert stuff
    - You do not have to care about the above details if you are a 'normal'
    ST-programmer, though (and even most of those will never use these features).


    Examples (only of theoretical interest):
    ----------------------------------------
	take away the behaviorLike-flag from a class.
	-> The instances will not understand any messages, since the VM will
	   not recognize its class as being a class ...

	|newMeta notRecognizedAsClass someInstance|

	newMeta := Metaclass new.
	newMeta flags:0.

	notRecognizedAsClass := newMeta new.

	someInstance := notRecognizedAsClass new.
	someInstance perform:#isNil


    Of course, this is an exception which can be handled ...:
    Example:

	|newMeta notRecognizedAsClass someInstance|

	newMeta := Metaclass new.
	newMeta flags:0.

	notRecognizedAsClass := newMeta new.

	someInstance := notRecognizedAsClass new.
	Object errorSignal handle:[:ex |
	    ex return
	] do:[
	    someInstance perform:#isNil
	]


    likewise, a doesNotUnderstand-notUnderstood can be handled:
    Example:

	|newMeta funnyClass someInstance|

	newMeta := Metaclass new.

	funnyClass := newMeta new.
	funnyClass setSuperclass:nil.

	someInstance := funnyClass new.
	Object errorSignal handle:[:ex |
	     ex return
	] do:[
	    someInstance perform:#isNil
	]


    more examples, which try to trick the VM ;-):
	badly playing around with a classes internals ...

	|newClass someInstance|

	newClass := Class new.
	newClass setSuperclass:nil.
	someInstance := newClass new.
	someInstance inspect


	|newClass someInstance|

	newClass := Class new.
	newClass setSuperclass:newClass.
	someInstance := newClass new.
	someInstance inspect


	|newClass someInstance|

	newClass := Class new.
	newClass setSuperclass:1.
	someInstance := newClass new.
	someInstance inspect


    Example:
	creating totally anonymous classes:

	|newClass someInstance|

	newClass := Class new.
	someInstance := newClass new.
	someInstance inspect


    Example:
	creating totally anonymous metaclasses:

	|newMeta newClass someInstance|

	newMeta := Metaclass new.
	newClass := newMeta new.
	someInstance := newClass new.
	someInstance inspect


    PS: if you experiment with new behaviorLike objects, you may want
	to turn off the VM's debugPrintouts
	with:
		'Smalltalk debugPrinting:false'
	and:
		'Smalltalk infoPrinting:false'

    Meta-Object-Protocol support:
    -----------------------------
    the above tricks do not affect the inline caches, and are therefore somewhat slow.
    Another hook is the lookupObject which, if non-nil, is consulted to do the lookup
    instead of the hardwired VM lookup algorithm, and provide a method as return value.
    This method (if non-nil) will be put into the inline-and polymorph caches for speedy
    call the next time. If non-nil, the lookup object is sent the:
	    lookupMethodForSelector:aSelector
	    directedTo:searchClass
	    for:aReceiver
	    withArguments:argArrayOrNil
	    from:sendingContext
    message.
    'searchClass' is the object class or any of its superclasses (for directed/super sends).
    You can return any arbitrary method there - for example to implement multiple inheritance,
    selector namespace tricks or multi-dispatch on argument types (double dispatch for a method).
    Be aware, that the returned method is cached, and the lookup is not consulted again for the
    same receiver/callsite combination. So the returned method should check if it's ok to be called
    again (maybe, a synthetic method is generated and returned).
"
! !

!Behavior class methodsFor:'creating new classes'!

new
    "creates and return a new behavior (which is like a class,
     but without the symbolic & name information).
     Not for normal applications.
     Sending the returned behavior the #new message gives you
     an instance if it.

     Notice: the returned class is given a superclass of Object;
     this allows for its new instances to be inspected and the like."

    |newClass|

    newClass := self basicNew.
    newClass
	setSuperclass:Object
	methodDictionary:(MethodDictionary new)
	instSize:0
	flags:(self flagBehavior).
    ^ newClass

    "
     Behavior new               <- a new behavior
     Behavior new new           <- an instance of it
     ClassDescription new       <- a new classDescription
     ClassDescription new new   <- an instance of it
     Class new                  <- a new class
     Class new new              <- an instance of it
     Metaclass new              <- a new metaclass
     Metaclass new new          <- an instance (i.e. a class) of it
     Metaclass new new new      <- an instance of this new class
    "

    "Modified: 7.6.1996 / 15:38:58 / stefan"
! !

!Behavior class methodsFor:'flag bit constants'!

flagAlien
    "Return the flag code for Alien objects for Translucent Object implementation"

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_ALIENPOINTERS );
#else
    RETURN ( __mkSmallInteger(ALIENPOINTERS) );
#endif
%}
!

flagBehavior
    "return the flag code which marks Behavior-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for behaviors."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_BEHAVIOR_INSTS );
#else
    RETURN ( __mkSmallInteger(BEHAVIOR_INSTS) );
#endif
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
     The VM checks for either this bit or the blockLike bit in the flag
     value when checking for blocks to be evaluated from bytecodes.
     However, compiled code only checks for the block bit."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_BLOCK_INSTS );
#else
    RETURN ( __mkSmallInteger(BLOCK_INSTS) );
#endif
%}
!

flagBlockContext
    "return the flag code which marks BlockContext-like instances.
     The VM checks this single bit in the flag value when
     checking for blockContexts."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_BCONTEXT_INSTS );
#else
    RETURN ( __mkSmallInteger(BCONTEXT_INSTS) );
#endif
%}
!

flagBlockLike
    "return the flag code which marks Block-like instances
     with respect to byteCode interpretation.
     The VM checks for either this bit or the block bit in the flag
     value when checking for blocks to be evaluated from bytecodes.
     However, compiled code only checks for the block bit."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_BLOCKLIKE_INSTS );
#else
    RETURN ( __mkSmallInteger(BLOCKLIKE_INSTS) );
#endif
%}
!

flagBytes
    "return the flag code for byte-valued indexed instances.
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for byte valued
     variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_BYTEARRAY );
#else
    RETURN ( __mkSmallInteger(BYTEARRAY) );
#endif
%}
    "
     Behavior flagBytes
    "
!

flagContext
    "return the flag code which marks Context-like instances.
     The VM checks this single bit in the flag value when
     checking for contexts."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_CONTEXT_INSTS );
#else
    RETURN ( __mkSmallInteger(CONTEXT_INSTS) );
#endif
%}
!

flagDoubles
    "return the flag code for double-valued indexed instances (i.e. 8-byte reals).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for double valued
     variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_DOUBLEARRAY );
#else
    RETURN ( __mkSmallInteger(DOUBLEARRAY) );
#endif
%}
    "
     Behavior flagDoubles

     (ByteArray flags bitAnd:(Behavior maskIndexType)) == (Behavior flagDoubles)
     (DoubleArray flags bitAnd:(Behavior maskIndexType)) == (Behavior flagDoubles)
     (Object flags bitAnd:(Behavior maskIndexType)) == (Behavior flagDoubles)
    "
!

flagExternalBytes
    "return the flag code which marks ExternalBytes-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for an externalBytes-like objet."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_EXTERNALBYTES_INSTS );
#else
    RETURN ( __mkSmallInteger(EXTERNALBYTES_INSTS) );
#endif
%}
!

flagFloat
    "return the flag code which marks Float-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for a float."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_FLOAT_INSTS );
#else
    RETURN ( __mkSmallInteger(FLOAT_INSTS) );
#endif
%}
!

flagFloats
    "return the flag code for float-valued indexed instances (i.e. 4-byte reals).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for double valued
     variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_FLOATARRAY );
#else
    RETURN ( __mkSmallInteger(FLOATARRAY) );
#endif
%}
    "
     Behavior flagFloats
    "
!

flagForSymbolic:aSymbol
    "return the flag code for indexed instances with aSymbolic type.
     The argument may be one of
	#float, #double,
	#word, #signedWord,
	#long, #signedLong
	#longLong, #signedLongLong,
	#byte
	#weakObjects
     For VW compatibility, also accept:
	#objects, #bytes, #weak.
    "

%{   /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aSymbol == @symbol(float)) {
	return __c__._RETURN ( STClass.FLAG_FLOATARRAY );
    }
    if (aSymbol == @symbol(double)) {
	return __c__._RETURN ( STClass.FLAG_DOUBLEARRAY );
    }
    if (aSymbol == @symbol(long)) {
	return __c__._RETURN ( STClass.FLAG_LONGARRAY );
    }
    if (aSymbol == @symbol(longLong)) {
	return __c__._RETURN ( STClass.FLAG_LONGLONGARRAY );
    }
    if (aSymbol == @symbol(word)) {
	return __c__._RETURN ( STClass.FLAG_WORDARRAY );
    }
    if (aSymbol == @symbol(signedWord)) {
	return __c__._RETURN ( STClass.FLAG_SWORDARRAY );
    }
    if (aSymbol == @symbol(signedLong)) {
	return __c__._RETURN ( STClass.FLAG_SLONGARRAY );
    }
    if (aSymbol == @symbol(signedLongLong)) {
	return __c__._RETURN ( STClass.FLAG_SLONGLONGARRAY );
    }
    if ((aSymbol == @symbol(byte)) || (aSymbol == @symbol(bytes))) {
	return __c__._RETURN ( STClass.FLAG_BYTEARRAY );
    }
    if (aSymbol == @symbol(objects)) {
	return __c__._RETURN ( STClass.FLAG_POINTERARRAY );
    }
    if ((aSymbol == @symbol(weakObjects)) || (aSymbol == @symbol(weak))) {
	return __c__._RETURN ( STClass.FLAG_WKPOINTERARRAY );
    }
#else
    if (aSymbol == @symbol(float)) {
	RETURN ( __mkSmallInteger(FLOATARRAY) );
    }
    if (aSymbol == @symbol(double)) {
	RETURN ( __mkSmallInteger(DOUBLEARRAY) );
    }
    if (aSymbol == @symbol(long)) {
	RETURN ( __mkSmallInteger(LONGARRAY) );
    }
    if (aSymbol == @symbol(longLong)) {
	RETURN ( __mkSmallInteger(LONGLONGARRAY) );
    }
    if (aSymbol == @symbol(word)) {
	RETURN ( __mkSmallInteger(WORDARRAY) );
    }
    if (aSymbol == @symbol(signedWord)) {
	RETURN ( __mkSmallInteger(SWORDARRAY) );
    }
    if (aSymbol == @symbol(signedLong)) {
	RETURN ( __mkSmallInteger(SLONGARRAY) );
    }
    if (aSymbol == @symbol(signedLongLong)) {
	RETURN ( __mkSmallInteger(SLONGLONGARRAY) );
    }
    if ((aSymbol == @symbol(byte)) || (aSymbol == @symbol(bytes))) {
	RETURN ( __mkSmallInteger(BYTEARRAY) );
    }
    if (aSymbol == @symbol(objects)) {
	RETURN ( __mkSmallInteger(POINTERARRAY) );
    }
    if ((aSymbol == @symbol(weakObjects)) || (aSymbol == @symbol(weak))) {
	RETURN ( __mkSmallInteger(WKPOINTERARRAY) );
    }
#endif
%}.
    ^ 0         "/ not indexed

    "Modified: / 07-06-2007 / 11:57:44 / cg"
!

flagJavaArray
    "return the flag code which marks Java array-like instances.
     The VM checks this single bit in the flag value when
     checking for a java arrays."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_JARRAY_INSTS );
#else
    RETURN ( __mkSmallInteger(JARRAY_INSTS) );
#endif
%}
!

flagJavaClass
    "return the flag code which marks JavaClass-like instances.
     The VM checks this single bit in the flag value when
     checking for a javaClass."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_JCLASS_INSTS );
#else
    RETURN ( __mkSmallInteger(JCLASS_INSTS) );
#endif
%}
!

flagJavaMethod
    "return the flag code which marks JavaMethod-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for a method."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_JMETHOD_INSTS );
#else
    RETURN ( __mkSmallInteger(JMETHOD_INSTS) );
#endif
%}
!

flagLongLongs
    "return the flag code for longlong-valued indexed instances (i.e. 8-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     unsigned long valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_LONGLONGARRAY );
#else
    RETURN ( __mkSmallInteger(LONGLONGARRAY) );
#endif
%}
    "
     Behavior flagLongLongs
    "
!

flagLongs
    "return the flag code for long-valued indexed instances (i.e. 4-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     unsigned long valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_LONGARRAY );
#else
    RETURN ( __mkSmallInteger(LONGARRAY) );
#endif
%}
    "
     Behavior flagLongs
    "
!

flagMetaMethod
    "return the flag code which marks MetaMethod-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     about to evaluate a method."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_METAMETHOD_INSTS );
#else
    RETURN ( __mkSmallInteger(METAMETHOD_INSTS) );
#endif
%}
!

flagMethod
    "return the flag code which marks Method-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for a method."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_METHOD_INSTS );
#else
    RETURN ( __mkSmallInteger(METHOD_INSTS) );
#endif
%}
!

flagNonObjectInst
    "return the flag code which marks instances which have a
     non-object instance variable (in slot 1).
     (these are ignored by the garbage collector)"

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_NONOBJECT_INSTS );
#else
    RETURN ( __mkSmallInteger(NONOBJECT_INSTS) );
#endif
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
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     pointer variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_POINTERARRAY );
#else
    RETURN ( __mkSmallInteger(POINTERARRAY) );
#endif
%}
    "
     Behavior flagPointers
    "
!

flagRegular
    "return the flag code which marks regular instances."

    ^ 0

    "Created: 12.5.1996 / 17:53:36 / cg"
!

flagSignedLongLongs
    "return the flag code for signed longlong-valued indexed instances (i.e. 8-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     signed long valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_SLONGLONGARRAY );
#else
    RETURN ( __mkSmallInteger(SLONGLONGARRAY) );
#endif
%}
    "
     Behavior flagSignedLongLongs
    "
!

flagSignedLongs
    "return the flag code for signed long-valued indexed instances (i.e. 4-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     signed long valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_SLONGARRAY );
#else
    RETURN ( __mkSmallInteger(SLONGARRAY) );
#endif
%}
    "
     Behavior flagSignedLongs
    "
!

flagSignedWords
    "return the flag code for signed word-valued indexed instances (i.e. 2-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     signed word valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_SWORDARRAY );
#else
    RETURN ( __mkSmallInteger(SWORDARRAY) );
#endif
%}
    "
     Behavior flagSignedWords
    "
!

flagSymbol
    "return the flag code which marks Symbol-like instances.
     Inline C-code and the VM check this single bit in the flag value when
     checking for symbols."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_SYMBOL_INSTS );
#else
    RETURN ( __mkSmallInteger(SYMBOL_INSTS) );
#endif
%}
!

flagWeak
    "return the flag code for weak-object-pointer indexed instances.
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     weak pointer variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_WKPOINTERARRAY );
#else
    RETURN ( __mkSmallInteger(WKPOINTERARRAY) );
#endif
%}
    "
     Behavior flagWeak
    "

    "Created: / 07-06-2007 / 11:59:12 / cg"
!

flagWeakPointers
    "return the flag code for weak pointer indexed instances (i.e. WeakArray).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for weak pointers."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_WKPOINTERARRAY );
#else
    RETURN ( __mkSmallInteger(WKPOINTERARRAY) );
#endif
%}
!

flagWords
    "return the flag code for word-valued indexed instances (i.e. 2-byte).
     The VM masks the flag value with the indexMask (maskIndexType)
     and compares it to this flag value, when checking for
     unsigned word valued variable instances."

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_WORDARRAY );
#else
    RETURN ( __mkSmallInteger(WORDARRAY) );
#endif
%}
    "
     Behavior flagWords
    "
!

maskIndexType
    "return a mask to extract all index-type bits"

%{  /* NOCONTEXT */
    /* this is defined as a primitive to get defines from stc.h */

#ifdef __SCHTEAM__
    return __c__._RETURN( STClass.FLAG_ARRAYMASK );
#else
    RETURN ( __mkSmallInteger(ARRAYMASK) );
#endif
%}
! !

!Behavior class methodsFor:'helpers'!

classesSortedByLoadOrder2:aCollectionOfClasses
    "return a copy of the given collection of classes, which is sorted
     by inheritance and superclass-of-any-private class.
     This is the optimal order for loading, and the required order for compilation.

     This is an alternate algorithm showing cycles"

    |orderedTuples|

    orderedTuples := OrderedCollection new:aCollectionOfClasses size.
    aCollectionOfClasses do:[:eachClass|
	|sharedPools|
	orderedTuples add:(Array with:eachClass with:eachClass superclass).
	sharedPools := eachClass sharedPools.
	sharedPools notEmptyOrNil ifTrue:[
	    orderedTuples add:((OrderedCollection with:eachClass) addAll:sharedPools).
	].
	eachClass allPrivateClasses do:[:eachPrivateClass| |superClassOwner|
	    superClassOwner := eachPrivateClass superclass.
	    "take care of classes inheriting from nil or ProtoObject"
	    superClassOwner isBehavior ifTrue:[
		superClassOwner := superClassOwner owningClassOrYourself.
	    ].
	    orderedTuples add:(Array with:eachPrivateClass with:superClassOwner).
	    sharedPools := eachPrivateClass sharedPools.
	    sharedPools notEmptyOrNil ifTrue:[
		orderedTuples add:((OrderedCollection with:eachPrivateClass) addAll:sharedPools).
	    ].
	].
    ].

    "I am only interested in my classes"
    ^ orderedTuples topologicalSort intersect:aCollectionOfClasses.

    "
     Class classesSortedByLoadOrder:stx_libbasic compiled_classes_common
     Class classesSortedByLoadOrder2:stx_libbasic compiled_classes_common
     Class classesSortedByLoadOrder:stx_libjava compiled_classes_common
     Class classesSortedByLoadOrder2:stx_libjava compiled_classes_common
    "
!

classesSortedByLoadOrder:someClasses
    "return a copy of the given collection of classes, which is sorted
     by inheritance and superclass-of-any-private class.
     This is the optimal order for loading, and the required order for compilation"

    |remaining classesInLoadOrder|

    "private classes are not loaded directly, so ignore them"
    remaining := someClasses select:[:eachClass| eachClass isPrivate not] as:IdentitySet.
    "JV-2011-05-05: Sort the classes by name to get more stable order.
     This stabilizes order of classes in generated build files and
     makes text-based diffing/merging easier for both human beings
     and version control systems"
    remaining := remaining asOrderedCollection sort:[:a :b|a name < b name].
    classesInLoadOrder := OrderedCollection new:(remaining size).

    [remaining notEmpty] whileTrue:[
	|thoseWithOtherSuperclasses thoseWhichCanBeLoadedNow|

	"find the next class(es) to be loaded.
	 Consider first:
	    all those, which do not have a superclass in the remaining set.
	    and which do not use a shared pool defined in the remaining set"

	thoseWithOtherSuperclasses :=
	    remaining
		reject:[:eachClass |
		    (remaining includes:eachClass superclass)
		    or:[eachClass sharedPoolNames contains:[:eachPoolSymbol|
			    remaining contains:[:eachRemainingClass| eachPoolSymbol = eachRemainingClass name]
			]
		    ].
		].

	"second: the subset with all those having no private classes,
		 or having private classes, whose superclasses are NOT in the remaining set,
		 or having private classes which do not use a shared pool in the remaining set"

	thoseWhichCanBeLoadedNow :=
	    thoseWithOtherSuperclasses
		reject:[:eachClass |
		    eachClass allPrivateClasses contains:[:eachPrivateClass|
			|superClassesOwner sharedPools|
			superClassesOwner := eachPrivateClass superclass.
			"take care of classes inheriting from nil or ProtoObject"
			superClassesOwner isBehavior ifTrue:[
			    superClassesOwner := superClassesOwner owningClassOrYourself.
			].
			sharedPools := eachPrivateClass sharedPools.
			(superClassesOwner ~~ eachClass
			    and:[remaining includes:superClassesOwner])
			or:[remaining includesAny:sharedPools]
		    ].
		].

	thoseWhichCanBeLoadedNow isEmpty ifTrue:[
	    thoseWithOtherSuperclasses isEmpty ifTrue:[
		"this does not normally happen"
		self error:'superclass order is cyclic'.
	    ] ifFalse:[
		"no class found, that may be loaded - maybe there is a cyclic
		 dependency involving private classes.
		 If you proceed here, private class dependencies are ignored
		 for this pass"
		self error:'load order is cyclic (care for private classes)' mayProceed:true.
		thoseWhichCanBeLoadedNow := thoseWithOtherSuperclasses.
	    ].
	].
	remaining removeAllFoundIn:thoseWhichCanBeLoadedNow.
	classesInLoadOrder addAll:(thoseWhichCanBeLoadedNow sort:[:a :b | a name < b name]).
    ].
    ^ classesInLoadOrder

    "
     Class classesSortedByLoadOrder:(Smalltalk allClassesInPackage:'stx:libbasic')
     Class classesSortedByLoadOrder:(Smalltalk allClassesInPackage:'stx:libbasic3')
     Class classesSortedByLoadOrder:(Smalltalk allClassesInPackage:'stx:libwidg')
     Class classesSortedByLoadOrder:(Smalltalk allClassesInPackage:'stx:libjava')
    "

    "Created: / 14-09-2006 / 11:21:25 / cg"
    "Modified: / 18-01-2011 / 17:55:59 / cg"
    "Modified: / 05-05-2011 / 12:43:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commonSuperclassOf:listOfClassesOrClassNames
    "given a list of classes, return the common superclass.
     A helper for the browser, some dialogs and some refactorings"

    |common|

    listOfClassesOrClassNames do:[:classOrClassName |
	|class|

	class := classOrClassName isBehavior
			ifTrue:[classOrClassName]
			ifFalse:[Smalltalk classNamed:classOrClassName].

	common isNil ifTrue:[
	    common := class
	] ifFalse:[
	    (class isSubclassOf:common) ifTrue:[
		"keep common"
	    ] ifFalse:[
		(common isSubclassOf:class) ifTrue:[
		    common := class
		] ifFalse:[
		    common := common commonSuperclass:class.

"/                    "walk up, checking"
"/                    found := false.
"/
"/                    common allSuperclassesDo:[:sup |
"/                        (found not and:[class isSubclassOf:sup]) ifTrue:[
"/                            common := sup.
"/                            found := true.
"/                        ]
"/                    ].
"/                    found ifFalse:[
"/                        class allSuperclassesDo:[:sup |
"/                            (found not and:[common isSubclassOf:sup]) ifTrue:[
"/                                common := sup.
"/                                found := true.
"/                            ]
"/                        ].
"/                    ].
		]
	    ].
	].
	(common isNil or:[common == Object]) ifTrue:[^ common].
    ].
    ^ common

    "
     Class commonSuperclassOf:#(Array OrderedCollection Set)
     Class commonSuperclassOf:#(Character Number Point)
    "

    "Modified: 17.6.1996 / 17:09:21 / stefan"
    "Modified: 5.9.1996 / 19:34:41 / cg"
! !

!Behavior class methodsFor:'misc'!

autoload
    "for compatibility with autoloaded classes - dummy here"

    ^ self

! !

!Behavior class methodsFor:'queries'!

definitionSelectorFirstParts
    "return a collection of partial class-definition selectors"

    ^ #( #'subclass:'
	 #'variableSubclass:'
	 #'variableByteSubclass:'
	 #'variableWordSubclass:'
	 #'variableLongSubclass:'
	 #'variableSignedWordSubclass:'
	 #'variableSignedLongSubclass:'
	 #'variableLongLongSubclass:'
	 #'variableSignedLongLongSubclass:'
	 #'variableFloatSubclass:'
	 #'variableDoubleSubclass:'
      )
!

definitionSelectors
    "return a collection class-definition selectors"

    ^ #(
	 #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableWordSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableSignedWordSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableSignedLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableLongLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableSignedLongLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableFloatSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
	 #'variableDoubleSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'

	"/ ST/X private subclasses

	 #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableWordSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableSignedWordSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableSignedLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableLongLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableSignedLongLongSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableFloatSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'
	 #'variableDoubleSubclass:instanceVariableNames:classVariableNames:poolDictionaries:privateIn:'

	"/ ST/V subclass messages

	 #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:'
	 #'variableByteSubclass:classVariableNames:poolDictionaries:'
	 #'variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:'

	"/ Dolphin
	 #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:'

	"/ VSE
	 #'variableByteSubclass:classVariableNames:poolDictionaries:category:'
      )
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ (self == Behavior class) or:[self == Behavior]

    "Modified: 23.4.1996 / 15:55:52 / cg"
!

supportsMethodCategories
    "return true, if my methods are categorized.
     This is a hook for the browser to allow alien classes
     to be handled (actually, this is not yet used)."

    ^ true

    "Created: / 01-06-2012 / 20:37:46 / cg"
! !


!Behavior methodsFor:'Compatibility-Dolphin'!

allSubinstances
    "Compatibility method - do not use in new code.
     Same as allSubInstances; added for Dolphin compatibility"

    ^ self allSubInstances
!

fromString:aString
    "reconstruct an instance of myself from the ascii-store string.
     These bytes are typically the result from storing into a string/stream.
     Same as readFrom:, for Dolphin compatibility."

    |result|

    result := self readFrom:aString readStream.
"/ should check here for garbage - maybe later
"/    s atEnd ifFalse:[^ ConversionError raiseRequestWith:aString errorString:' - garbage at end of ', self name].
    ^ result
!

guid:aUUID
    "Compatibility method - do not use in new code.
     An ignored dummy; for Dolphin compatibility."

    "/ intentionally left blank - for now
!

lookupMethod:selector
    "Compatibility method - do not use in new code.
     Return the method for given selector aSelector or nil.
     Only methods in the receiver - not in the superclass chain are returned.
     For dolphin compatibility.
     TODO: fixme if I am wrong, and dolphin does a full lookup here. If that is the case,
     change to use lookupMethodFor:aSelector below."

    ^ self compiledMethodAt:selector
! !

!Behavior methodsFor:'Compatibility-Squeak'!

classComment:comment stamp:commentStamp
    self comment:comment
!

classSide
    "alias for theMetaclass - return the metaclass"

    ^ self theMetaclass

    "Created: / 26-08-2009 / 11:44:51 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
    "Modified: / 12-09-2010 / 16:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-08-2011 / 16:33:47 / cg"
!

defaultNameStemForInstances
    "Answer a basis for names of default instances of the receiver"

    ^ self name

!

lookupSelector:aSelector
    "return the method for a selector - Squeak compatibility"

    ^ self lookupMethodFor:aSelector
!

selectorsWithArgs:numberOfArgs
    "Return all selectors defined in this class that take this number of arguments."

    ^ self selectors
        select:[:sel | sel argumentCount == numberOfArgs]

    "
     SmallInteger selectorsWithArgs:0
     SmallInteger selectorsWithArgs:2
     SmallInteger selectorsWithArgs:3
     SmallInteger selectorsWithArgs:4
    "
!

theNonMetaClass
    <resource: #obsolete>
    
    "alias for theNonMetaclass (Squeak) - return the class.
     sigh; in ST/X, it is called theNonMetaclass; please use that."

    ^ self theNonMetaclass

    "Created: / 26-08-2009 / 11:39:08 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
    "Modified (comment): / 20-08-2011 / 16:35:07 / cg"
! !

!Behavior methodsFor:'Compatibility-VW'!

>> aSelector
    "return the method stored under the given selector; nil if there is none"

    ^ self compiledMethodAt:aSelector

    "
     self compiledMethodAt:#compiledMethodAt:
     self >> #compiledMethodAt:
    "
!

findSelector:aSelector
    "return an array filled with class and method, which would be executed if aSelector was sent to
     an instance of the receiver.
     I.e. the selector arrays of the receiver
     and all of its superclasses are searched for aSelector.
     Return nil if instances do not understand aSelector"

    |mthd|

    mthd := self lookupMethodFor:aSelector.
    mthd notNil ifTrue:[
	^ { mthd mclass . mthd }
    ].
    ^ nil

    "
     Array findSelector:#at:
    "
!

fixedFieldsMask
    "Mask on the format word to indicate the number of fixed fields in instances
     of a behavior.  If this is non-zero, the behavior must be pointer-type"

    ^ 255

!

format
    "Answer an Integer that encodes the kinds and numbers of
    variables of instances of the receiver.

    See instSize method for reference to the fixedFieldsMask bit mask of the format.
    See isVariable method for reference to the indexableMask bit mask of the format.
    See isBits method for reference to the pointersMask bit mask of the format.
    All other bits of the format are unused and should be 0."

    "/ simulate a VW5i mask

    ^ (self instSize
      bitOr:( self isPointers ifTrue:[16384] ifFalse:[0]))
      bitOr:( self isVariable ifTrue:[ 4096] ifFalse:[0])

!

getMethodDictionary
    "ST 80 compatibility: return the receiver's method dictionary."

    ^ self methodDictionary

    "Modified: / 6.3.1998 / 15:45:50 / stefan"
!

instanceBehavior
    "Answer the instance behavior of the receiver.
     This is the receiver for non metaclasses.
     Metaclass overrides this to answer a Metaclass's sole instance.
     Same as #theNonMetaclass - for VW compatibility
    "

    ^ self theNonMetaclass

!

shortName
    ^ self nameWithoutPrefix
! !


!Behavior methodsFor:'RefactoringBrowser'!

realClass
    "for compatibility with RBAbstractClass"

    ^ self
! !

!Behavior methodsFor:'accessing'!

addSelector:newSelector withMethod:newMethod
    "add the method given by 2nd argument under the selector given by
     1st argument to the methodDictionary. Flushes all caches."

    |oldMethod ns nsName selector newLookupObject|

    (newSelector isMemberOf:Symbol) ifFalse:[
	self error:'invalid selector'.
    ].

    ns := newMethod nameSpace.
    (ns notNil and:[(nsName := ns name) ~= self programmingLanguage defaultSelectorNameSpacePrefix]) ifTrue:[
	selector := (':' , nsName , '::' , newSelector) asSymbol.
	newLookupObject := Smalltalk at: #NamespaceAwareLookup. "/ so it can be nilled to disable that feature
    ] ifFalse:[
	selector := newSelector
    ].

    "/ Q (cg): isn't that something that the caller should decide?
    oldMethod := self compiledMethodAt:selector.
    oldMethod notNil ifTrue:[
	newMethod restricted:(oldMethod isRestricted).
	newMethod setPrivacy:(oldMethod privacy) flushCaches:false.
    ].

    (self primAddSelector:selector withMethod:newMethod) ifFalse:[^ false].

    newLookupObject notNil ifTrue:[
	lookupObject ~= newLookupObject ifTrue:[
	    self lookupObject: newLookupObject
	]
    ].

    "
     if I have no subclasses, all we have to flush is cached
     data for myself ... (actually, in any case all that needs
     to be flushed is info for myself and all of my subclasses)
    "
"
    problem: this is slower; since looking for all subclasses is (currently)
	     a bit slow :-(
	     We need the hasSubclasses-info bit in Behavior; now

    self withAllSubclassesDo:[:aClass |
	ObjectMemory flushInlineCachesFor:aClass withArgs:nargs.
	ObjectMemory flushMethodCacheFor:aClass
    ].
"

    "/
    "/ pass the selector AND the old method as changeArg
    "/ - this allows for watchers to find out if its a new method or a method-change
    "/
    self changed:#methodDictionary with:(Array with:selector with:oldMethod).

    "/
    "/ pass the class AND selector AND the old method as changeArg
    "/ - this allows for watchers to depend on a non-metaclass only, watching both sides.
    "/
    self theNonMetaclass changed:#classesMethodDictionary with:(Array with:self with:selector with:oldMethod).

    "/
    "/ also notify a change of Smalltalk;
    "/ this allows a dependent of Smalltalk to watch all class
    "/ changes (no need for observing all classes)
    "/ - this allows for watchers to find out if its a new method or a method-change
    "/
    Smalltalk changed:#methodInClass with:(Array with:self with:selector with:oldMethod).
    ^ true.

    "Created: / 11-12-1995 / 13:59:37 / cg"
    "Modified: / 04-08-2006 / 11:39:28 / cg"
    "Modified: / 20-07-2010 / 11:29:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicAddSelector:newSelector withMethod:newMethod
    "add the method given by 2nd argument under the selector given by
     1st argument to the methodDictionary. Flushes all caches."

    |nargs |

    self primAddSelector:newSelector withMethod:newMethod.

    nargs := newMethod argumentCount.

    ObjectMemory flushMethodCacheForSelector:newSelector.
"/    ObjectMemory flushMethodCache.
    ObjectMemory flushInlineCachesWithArgs:nargs.
    ObjectMemory flushCachesForSelector:newSelector numArgs:nargs

    "Created: / 15-07-2006 / 16:56:43 / cg"
!

basicRemoveSelector:aSelector
    "remove the selector, aSelector and its associated method
     from the methodDictionary"

    |dict newDict|

    (Smalltalk
	changeRequest:#methodInClassRemoved
	with:(Array with:self with:aSelector)
    ) ifFalse:[
	^ false
    ].

    dict := self methodDictionary.
    newDict := dict removeKeyAndCompress:aSelector.
    newDict isNil ifTrue:[
    ^ false.
    ].
    self setMethodDictionary:newDict.

    "
     actually, we would do better with less flushing ...
    "
    "/ObjectMemory flushCaches.

    "yes, we can:"
    ObjectMemory flushCachesForSelector:aSelector.
    ^ true

    "Modified: / 12-06-1996 / 11:54:29 / stefan"
    "Modified: / 19-07-2010 / 11:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containingNameSpace
    "return the namespace which contains me.
     Defined here as a dummy; actually only real classes should ever be put into a namespace."

    ^ nil
!

flags
    "return the receiver's flag bits.
     see flagXXX methods on my class side for details"

    ^ flags
!

instSize
    "return the number of instance variables of the receiver.
     This includes all superclass instance variables."

    ^ instSize
!

lookupObject
    "return the lookupObject (Jan's MetaObjectProtocol support) or nil.
     If non-nil, no lookup is performed by the VM, instead the VM asks the lookupObject
     to provide a method for message sends."

    ^ lookupObject

    "/ CG: why this?
    "/ the VM ONLY looks at the lookupObject slot and does not walk the hierarchy;
    "/ (which it should never !!!!!!)
    "/ It is the responsibility of the IDE (or whoever uses lookupObjects),
    "/ to make sure that subclasses get a lookupObject, if they need it.
    "/ Also: it does not really make sense to redefine the behavior here
    "/ (for inheritance of lookup),
    "/ differently to what the VM does;
    "/ remember: this is also called for canUnderstand, respondsTo etc.
    "/ and no one expects these to return different results than what the VM does.

    "/    | behavior lookupInherited |
    "/
    "/    lookupObject notNil ifTrue:[^ lookupObject].
    "/    Lookup isNil ifTrue:[^ nil].

    "/    behavior := self.
    "/    [ behavior notNil ] whileTrue:[
    "/        lookupInherited := behavior getLookupObject.
    "/        lookupInherited notNil ifTrue: [^ lookupInherited].
    "/        behavior := behavior superclass
    "/    ].
    "/    ^ BuiltinLookup instance "Lookup builtin"

    "Modified: / 26-04-2010 / 21:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupObject: anObject
    lookupObject == anObject ifTrue:[^ self ].

    anObject notNil ifTrue:[
	"/ check if it is valid; the reason is that the VM gets into bad trouble,
	"/ if some invalid thingy is set as lookup object
	(anObject respondsTo: #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:)
	ifFalse:[
	    self error:'Lookup object does not respond to #lookupMethodForSelector:directedTo:for:withArguments:from:ilc:'
	].

	"/ CG: huh - what is this - it is nowhere implemented.
	(anObject respondsTo:#superLookupObject:)
	ifTrue:[
	    anObject superLookupObject: self lookupObject
	].
    ].
    "/ the builtin has the same behavior as the VM's default;
    "/ so let it do it - it's faster
    anObject == BuiltinLookup instance ifTrue:[
	self setLookupObject: nil.
    ] ifFalse:[
	self setLookupObject: anObject.
    ].

    "Created: / 26-04-2010 / 13:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2011 / 13:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodDictionary
    "return the receiver's method dictionary."

    ^ methodDictionary

    "Modified: 12.6.1996 / 13:47:08 / stefan"
    "Modified: 16.8.1996 / 14:55:21 / cg"
!

methodDictionary:dict
    "set the receiver's method dictionary and flush inline caches."

    dict isNil ifTrue:[
        self error:'attempt to set methodDictionary to nil.' mayProceed:true.
        ^ self
    ].
    self setMethodDictionary:dict.
    ObjectMemory flushCaches.

    "Created: 5.6.1996 / 11:29:36 / stefan"
    "Modified: 7.6.1996 / 08:39:51 / stefan"
!

package
    "for protocol compatibility with class"

    ^ ''
!

removeSelector:aSelector
    "remove the selector, aSelector and its associated method
     from the methodDictionary"

    ^ self basicRemoveSelector:aSelector
!

selectors
    "return the receiver's selector array as an OrderedCollection.
     Notice: this may not be compatible with ST-80.
     (should we return a Set ?)"

    |md|

    (md := self methodDictionary) isNil ifTrue:[
        'oops - nil methodDictionary' errorPrintCR.
        ^ #()
    ].
    ^ md keys

    "Modified: 7.6.1996 / 15:33:18 / stefan"
    "Modified: 12.11.1996 / 11:31:51 / cg"
!

superclass
    "return the receiver's superclass"

    ^ superclass
! !

!Behavior methodsFor:'autoload check'!

autoload
    "force autoloading - do nothing here;
     redefined in Autoload; see comment there"

    ^ self
!

isLoaded
    "return true, if the class has been loaded;
     redefined in Autoload; see comment there"

    ^ true
!

wasAutoloaded
    "return true, if this class came into the system via an
     autoload; false otherwise.
     Returning false here. This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well."

    ^ false

    "Created: 16.4.1996 / 16:27:16 / cg"
! !


!Behavior methodsFor:'cleanup'!

flushSubclasses
    "I don't keep my subclasses - but if anyone inherits from me,
     it better knows how to ignore this"
!

lowSpaceCleanup
    "ignored here - redefined in some classes to
     cleanup in low-memory situations"

    ^ self
! !

!Behavior methodsFor:'compiler interface'!

browserClass
    "return the browser to use for this class -
     this can be redefined in special classes, to get different browsers"

    ^ self class browserClass.
!

compiler
    "return the compiler to use for this class.
     OBSOLETE: This is the old ST/X interface, kept for migration.
	       Don't use it - it will vanish."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #compilerClass'.
    ^ self compilerClass

    "Modified: 31.7.1997 / 23:04:33 / cg"
!

compilerClass
    "return the compiler to use for this class -
     this can be redefined in special classes, to compile classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class compilerClass.
!

dllPath
    "if a class contains ExternalFunctions,
     return a collection of pathNames where to find the DLLs
     containing the external functions.

     Do not code absolute path names here - keep them in the system settings.
     Use this if the DLL location is kept in some registry entry."

    ^ #()
!

evaluatorClass
    "return the compiler to use for expression evaluation for this class -
     this can be redefined in special classes, to evaluate expressions with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class evaluatorClass.
!

formatterClass
    "return the parser to use for formatting (prettyPrinting) this class -
     this can be redefined in special classes, to format classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class formatterClass.
!

language
    "return the programming language to use for this class.
     OBSOLETE: This is an old interface which will vanish (easily confused with UI-national language)."

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #programmingLanguage or Smalltalk language'.
    ^ self class programmingLanguage

    "Created: / 15-08-2009 / 09:06:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parserClass
    "return the parser to use for parsing this class -
     this can be redefined in special classes, to parse classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class parserClass.
!

programmingLanguage

    ^self class programmingLanguage

    "Created: / 15-08-2009 / 09:06:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

subclassDefinerClass
    "Answer an evaluator class appropriate for evaluating definitions of new
     subclasses of this class."

    ^ self class subclassDefinerClass.
!

syntaxHighlighterClass
    "return the class to use for syntaxHighlighting (prettyPrinting) this class -
     this can be redefined in special classes, to highlight classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class syntaxHighlighterClass.
! !

!Behavior methodsFor:'compiling'!

compile:code
    "compile code, aString for this class;
     if successful update the method dictionary.
     Returns the new method or nil (on failure)."

    ^ self compilerClass
	compile:code
	forClass:self

    "Modified: 13.12.1995 / 10:56:00 / cg"
    "Created: 1.4.1997 / 23:43:51 / stefan"
!

compile:code categorized:methodCategory
    "compile code, aString for this class;
     if successful update the method dictionary.
     Returns the new method or nil (on failure)."

    ^ self compilerClass
	compile:code
	forClass:self
	inCategory:methodCategory
	notifying:nil
!

compile:code categorized:methodCategory notifying:requestor
    "compile code, aString for this class;
     if successful update the method dictionary.
     Returns the new method or nil (on failure)."

    ^ self compilerClass
	compile:code
	forClass:self
	inCategory:methodCategory
	notifying:requestor
!

compile:code notifying:requestor
    "compile code, aString for this class; on any error, notify
     requestor, anObject with the error reason.
     Returns the new method or nil (on failure)."

    ^ self compilerClass
	compile:code
	forClass:self
	notifying:requestor

    "Modified: 13.12.1995 / 11:02:40 / cg"
    "Created: 1.4.1997 / 23:43:43 / stefan"
! !

!Behavior methodsFor:'copying'!

canCloneFrom:anObject
    "return true, if this class can clone an obsolete object as retrieved
     by a binary load. Subclasses which do not want to have obsolete objects
     be converted, should redefine this method to return false.
     (However, conversion is never done silently in a binary load; you
      have to have a handler for the binaryload errors and for the conversion
      request signal.)"

    ^ true
!

cloneFrom:aPrototype
    "return an instance of myself with variables initialized from
     a prototype. This is used when instances of obsolete classes are
     binary loaded and a conversion is done on the obsolete object.
     UserClasses may redefine this for better conversions."

    |newInst indexed|

    indexed := false.
    aPrototype class isVariable ifTrue:[
	self isVariable ifTrue:[
	    indexed := true.
	].
	"otherwise, these are lost ..."
    ].
    indexed ifTrue:[
	newInst := self basicNew:aPrototype basicSize
    ] ifFalse:[
	newInst := self basicNew
    ].

    newInst cloneInstanceVariablesFrom:aPrototype.

    ^ newInst

    "
     Class withoutUpdatingChangesDo:[
	 Point subclass:#Point3D
	   instanceVariableNames:'z'
	   classVariableNames:''
	   poolDictionaries:''
	   category:'testing'.
	 (Point3D cloneFrom:1@2) inspect.
     ]
    "

    "
     Class withoutUpdatingChangesDo:[
	 Point variableSubclass:#Point3D
	   instanceVariableNames:'z'
	   classVariableNames:''
	   poolDictionaries:''
	   category:'testing'.
	 (Point3D cloneFrom:#(1 2 3)) inspect.
     ]
    "

    "
     |someObject|

     Class withoutUpdatingChangesDo:[
	 Object subclass:#TestClass1
	   instanceVariableNames:'foo bar'
	   classVariableNames:''
	   poolDictionaries:''
	   category:'testing'.
	 someObject := TestClass1 new.
	 someObject instVarAt:1 put:'foo'; instVarAt:2 put:'bar'.
	 Object subclass:#TestClass2
	   instanceVariableNames:'bar foo'
	   classVariableNames:''
	   poolDictionaries:''
	   category:'testing'.
	 (TestClass2 cloneFrom:someObject) inspect.
     ]
    "
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of the receiver
     - return the receiver here - time will show if this is ok"

    ^ self
!

simpleDeepCopy
    "return a deep copy of the receiver
     - return the receiver here - time will show if this is ok"

    ^ self
! !

!Behavior methodsFor:'dummy changes management'!

addChangeRecordForClassRemove:aClassName
     "add a change record that some class has been removed.
      Defined as dummy here, since Behavior does not know about change management.
      (only Classes do). This allows different Behavior-like  objects
      (alien classes) to be handled by the browser as well."

    "Created: 16.4.1996 / 16:30:09 / cg"
    "Modified: 16.4.1996 / 18:10:35 / cg"
! !

!Behavior methodsFor:'dummy fileOut'!

fileOutDefinitionOn:aStream
    "dummy fileOut defined here.
     This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well."

    ^ self

    "Created: 16.4.1996 / 16:28:01 / cg"
! !

!Behavior methodsFor:'enumerating'!

allDerivedInstancesDo:aBlock
    "evaluate aBlock for all of my instances and all instances of subclasses.
     This method is going to be removed for protocol compatibility with
     other STs; use allSubInstancesDo:"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #allSubInstancesDo:'.
    self allSubInstancesDo:aBlock

    "
     StandardSystemView allDerivedInstancesDo:[:v | Transcript showCR:(v name)]
    "

    "Modified: 31.7.1997 / 23:05:04 / cg"
!

allInstancesDo:aBlock
    "evaluate aBlock for all of my instances"

    ObjectMemory allInstancesOf:self do:aBlock.

    "
     StandardSystemView allInstancesDo:[:v | Transcript showCR:(v name)]
    "
!

allOwningclassesDo:aBlock
    "evaluate aBlock for all of my owners (i.e. owner, owner-of-owner etc)."

    |owner|

    owner := self owningClass.
    [owner notNil] whileTrue:[
	aBlock value:owner.
	owner := owner owningClass.
    ].

    "
     Method::MethodWhoInfo allOwningclassesDo:[:c | Transcript showCR:(c name)]
    "
!

allSelectorsAndMethodsDo:aTwoArgBlock
    "evaluate the argument, aBlock for all selectors of mySelf and my metaclass,
     passing the corresponding method as second argument"

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #instAndClassSelectorsAndMethodsDo:'.

    self selectorsAndMethodsDo:aTwoArgBlock.
    self class selectorsAndMethodsDo:aTwoArgBlock.
!

allSubInstancesDo:aBlock
    "evaluate aBlock for all of my instances and all instances of subclasses"

    ObjectMemory allObjectsDo:[:anObject |
	(anObject isKindOf:self) ifTrue:[
	    aBlock value:anObject
	]
    ]

    "
     StandardSystemView allSubInstancesDo:[:v | Transcript showCR:(v name)]
    "
!

allSubclassesDo:aBlock
    "evaluate aBlock for all of my subclasses.
     There is no specific order, in which the entries are enumerated.
     Warning:
	This will only enumerate globally known classes - for anonymous
	behaviors, you have to walk over all instances of Behavior."

    self allSubclassesInOrderDo:aBlock

"/    self isMeta ifTrue:[
"/        "/ metaclasses are not found via Smalltalk allClassesDo:
"/        "/ here, walk over classes and enumerate corresponding metas.
"/        self soleInstance allSubclassesDo:[:aSubClass |
"/            aBlock value:(aSubClass class)
"/        ].
"/    ] ifFalse:[
"/        Smalltalk allClassesDo:[:aClass |
"/            (aClass isSubclassOf:self) ifTrue:[
"/                aBlock value:aClass
"/            ]
"/        ]
"/    ]

    "
     Collection allSubclassesDo:[:c | Transcript showCR:(c name)]
     Collection class allSubclassesDo:[:c | Transcript showCR:(c name)]
    "

    "Modified: / 25.10.1997 / 21:17:13 / cg"
!

allSubclassesInOrderDo:aBlock
    "evaluate aBlock for all of my subclasses.
     The subclasses are enumerated breath first (i.e. all of a classes superclasses
     come before a class, which comes before any of its subclasses).
     However, within one inheritance level, there is no specific order,
     in which the entries are enumerated.
     Warning:
	This will only enumerate globally known classes - for anonymous
	behaviors, you have to walk over all instances of Behavior."

    |meta toDo cls|

    meta := self isMeta.

    toDo := self theNonMetaclass subclasses asNewOrderedCollection.
    [toDo notEmpty] whileTrue:[
	cls := toDo removeFirst.
	toDo addAll:cls subclasses.
	meta ifTrue:[
	    aBlock value:cls class.
	] ifFalse:[
	    aBlock value:cls.
	]
    ].

"/    self isMeta ifTrue:[
"/        "/ metaclasses are not found via Smalltalk allClassesDo:
"/        "/ here, walk over classes and enumerate corresponding metas.
"/        self soleInstance allSubclassesDo:[:aSubClass |
"/            aBlock value:(aSubClass class)
"/        ].
"/    ] ifFalse:[
"/        Smalltalk allClassesDo:[:aClass |
"/            (aClass isSubclassOf:self) ifTrue:[
"/                aBlock value:aClass
"/            ]
"/        ]
"/    ]

    "
     Collection allSubclassesInOrderDo:[:c | Transcript showCR:(c name)]
     Collection class allSubclassesInOrderDo:[:c | Transcript showCR:(c name)]
    "

    "Modified: / 25-10-1997 / 21:17:13 / cg"
    "Modified (comment): / 27-07-2013 / 08:13:04 / cg"
!

allSuperclassesDo:aBlock
    "evaluate aBlock for all of my superclasses"

    |theClass
     n "{ Class: SmallInteger }"|

    n := 1.
    theClass := self superclass.
    [theClass notNil] whileTrue:[
	aBlock value:theClass.
	theClass := theClass superclass.
	n := n + 1.
	n > 100000 ifTrue:[ VMInternalError raiseErrorString:'deep inheritance' ].
    ]

    "
     String allSuperclassesDo:[:c | Transcript showCR:(c name)]
    "
!

instAndClassMethodsDo:aOneArgBlock
    "evaluate the argument, aBlock for all methods of mySelf and my metaclass
     (i.e. for both instance- and class methods)"

    self theNonMetaclass methodsDo:aOneArgBlock.
    self theMetaclass    methodsDo:aOneArgBlock.
!

instAndClassSelectorsAndMethodsDo:aTwoArgBlock
    "evaluate the argument, aBlock for all selectors of mySelf and my metaclass,
     passing the corresponding method as second argument"

    self selectorsAndMethodsDo:aTwoArgBlock.
    self class selectorsAndMethodsDo:aTwoArgBlock.
!

methodsDo:aOneArgBlock
    "evaluate the argument, aBlock for all my methods"

    self methodDictionary do:aOneArgBlock

    "
     UndefinedObject methodsDo:[:m | Transcript showCR:m whoString]
     UndefinedObject selectorsDo:[:sym | Transcript showCR:sym]
     UndefinedObject methodDictionary
    "

    "Modified (comment): / 25-11-2016 / 15:42:43 / cg"
!

selectorsAndMethodsDo:aTwoArgBlock
    "evaluate the argument, aBlock for all my selectors,
     passing the corresponding method as second argument"

    self methodDictionary keysAndValuesDo:aTwoArgBlock

    "Created: / 27.10.1997 / 14:09:27 / cg"
!

selectorsDo:aOneArgBlock
    "evaluate the argument, aBlock for all my selectors"

    self methodDictionary keysDo:aOneArgBlock
!

subclassesDo:aBlock
    "evaluate the argument, aBlock for all immediate subclasses.
     This will only enumerate globally known classes - for anonymous
     behaviors, you have to walk over all instances of Behavior."

    "Do it the hard way. Subclasses redefine this"
    Smalltalk allClassesDo:[:aClass |
	(aClass superclass == self) ifTrue:[
	    aBlock value:aClass
	]
    ]
!

whichClassSatisfies: aBlock
    "return the first class along the superclass-chain, which satisfies aBlock.
     Return nil, if there is none."

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
	(aBlock value: cls) ifTrue: [^ cls].
	cls := cls superclass.
    ].
    ^ nil

    "
     SimpleView whichClassSatisfies:[:cls | cls instanceVariableNames includes:'gc']
    "
!

withAllSubclassesDo:aBlock
    "evaluate aBlock for mySelf and all of my subclasses.
     There is no specific order, in which the entries are enumerated.
     Warning:
	This will only enumerate globally known classes - for anonymous
	behaviors, you have to walk over all instances of Behavior."

    aBlock value:self.
    self allSubclassesDo:aBlock

    "
     Collection withAllSubclassesDo:[:c | Transcript showCR:(c name)]
     Collection class withAllSubclassesDo:[:c | Transcript showCR:(c name)]
    "
!

withAllSuperclassesDo:aBlock
    "evaluate aBlock for the class and all of its superclasses"

    aBlock value:self.
    self allSuperclassesDo:aBlock

    "
     String withAllSuperclassesDo:[:each| Transcript showCR:each]
    "
! !

!Behavior methodsFor:'error handling'!

abstractClassInstantiationError
    "sent by an abstract classes redefined new method"

    ^ AbstractClassInstantiationError raiseRequest

    "Created: / 02-11-2012 / 10:07:01 / cg"
! !

!Behavior methodsFor:'initialization'!

deinitialize
    "deinitialize is sent to a class before it is physically unloaded.
     This is only done with classes which have been loaded in from a binary
     file. Classes may release any primitive memory or other stuff which is
     not visible to smalltalk (for example, release internal memory).
     The default action here is to do nothing."

    ^ self
!

initialize
    "initialize is sent to a class either during startup,
     (for all statically compiled-in classes) or after a class
     has been loaded into the system (either bytecodes or machinecode).
     The default action here is to do nothing."

    ^ self
!

initializeWithAllPrivateClasses
    "if implemented, send #initialize to myself and any private
     class which does so.
     This is sent to a class after it
     has been loaded into the system.
     Statically compiled classes are initialized by the VM"

    (self class includesSelector:#initialize) ifTrue:[
	self initialize.
    ].
    self privateClassesSorted do:[:aPrivateClass |
	aPrivateClass initializeWithAllPrivateClasses.
    ].

    "Created: / 13.5.1998 / 23:33:16 / cg"
    "Modified: / 13.5.1998 / 23:34:06 / cg"
!

postAutoload
    "postAutoload is sent to a class after it has been autoloaded.
     This gives it a chance to arrange for automatic unloading to be done
     after a while ...
     This is NOT sent to statically compiled in or explicitely filedIn
     classes.
     The default action here is to do nothing."

    ^ self
!

reinitialize
    "reinitialize is sent to a class when an image has been restarted.
     I.e. when the system is restarted.
     This gives classes a chance to flush any device dependent or otherwise
     obsolete data which may be a leftover from the previous live.
     The default action here is to do nothing."

    ^ self
! !


!Behavior methodsFor:'instance creation'!

basicNew
    "return an instance of myself without indexed variables.
     If the receiver-class has indexed instvars, the new object will have
     a basicSize of zero -
     i.e. 'aClass basicNew' is equivalent to 'aClass basicNew:0'.

     ** Do not redefine this method in any class **"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( self.basicNew() );
#else
    REGISTER OBJ newobj;
    REGISTER char *nextPtr;
    unsigned INT instsize;
    REGISTER unsigned INT nInstVars;

    /*
     * the following ugly code is nothing more than a __new() followed
     * by a nilling of the new instance.
     * Unrolled for a bit more speed since this is one of the central object
     * allocation methods in the system
     */
    nInstVars = __intVal(__INST(instSize));
    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);

    newobj = (OBJ) __newNextPtr;
    nextPtr = ((char *)newobj) + instsize;
    // 26-AUG-2016
    nextPtr = (char *)(__ALIGNED__(nextPtr));

    /*
     * don't argue about the goto and the arrangement below - it saves
     * an extra nil-compare and branch in the common case ...
     * (i.e. if no GC is needed, we fall through without a branch)
     */
    if (nextPtr < (char *)__newEndPtr) {
	__objPtr(newobj)->o_size = instsize;
	/* o_allFlags(newobj) = 0;              */
	/* __objPtr(newobj)->o_space = __newSpace; */
	o_setAllFlags(newobj, __newSpace);
	// 26-AUG-2016
	__newNextPtr = nextPtr;
//# ifdef __HAS_ALIGN4__
//        /*
//         * if the alignment is 4, we are already sat,
//         * since a non-indexed object always has a word-aligned size.
//         */
//        __newNextPtr = nextPtr;
//# else
//        if (instsize & (__ALIGN__-1)) {
//            __newNextPtr = (char *)newobj + (instsize & ~(__ALIGN__-1)) + __ALIGN__;
//        } else {
//            __newNextPtr = nextPtr;
//        }
//# endif

ok:
	__InstPtr(newobj)->o_class = self;
	__qSTORE(newobj, self);

	if (nInstVars) {
# if defined(memset4) && defined(FAST_OBJECT_MEMSET4) || defined(FAST_MEMSET4)
	    memset4(__InstPtr(newobj)->i_instvars, nil, nInstVars);
# else
	    REGISTER OBJ *op = __InstPtr(newobj)->i_instvars;

	    /*
	     * knowing that nil is 0
	     */
#  if defined(FAST_OBJECT_MEMSET_DOUBLES_UNROLLED)
	    if (nInstVars > 8) {
		*op++ = nil;    /* for alignment */
		nInstVars--;
		while (nInstVars >= 8) {
		    *(double *)op = 0.0;
		    ((double *)op)[1] = 0.0;
		    ((double *)op)[2] = 0.0;
		    ((double *)op)[3] = 0.0;
		    op += 8;
		    nInstVars -= 8;
		}
	    }
	    while (nInstVars != 0) {
		*op++ = 0;
		nInstVars--;
	    }
#  else
#   if defined(FAST_OBJECT_MEMSET_LONGLONG_UNROLLED)
	    if (nInstVars > 8) {
		*op++ = nil;    /* for alignment */
		nInstVars--;
		while (nInstVars >= 8) {
		    *(long long *)op = 0;
		    ((long long *)op)[1] = 0;
		    ((long long *)op)[2] = 0;
		    ((long long *)op)[3] = 0;
		    op += 8;
		    nInstVars -= 8;
		}
	    }
	    while (nInstVars != 0) {
		*op++ = 0;
		nInstVars--;
	    }

#   else
#    if defined(FAST_OBJECT_MEMSET_WORDS_UNROLLED)
	    while (nInstVars >= 8) {
		*op = nil;
		*(op+1) = nil;
		*(op+2) = nil;
		*(op+3) = nil;
		*(op+4) = nil;
		*(op+5) = nil;
		*(op+6) = nil;
		*(op+7) = nil;
		op += 8;
		nInstVars -= 8;
	    }
	    while (nInstVars != 0) {
		*op++ = nil;
		nInstVars--;
	    }
#    else
#     if defined(FAST_MEMSET)
	    memset(__InstPtr(newobj)->i_instvars, 0, instsize-OHDR_SIZE);
#     else
	    while (nInstVars >= 8) {
		nInstVars -= 8;
		op[0] = nil; op[1] = nil;
		op[2] = nil; op[3] = nil;
		op[4] = nil; op[5] = nil;
		op[6] = nil; op[7] = nil;
		op += 8;
	    }
	    while (nInstVars != 0) {
		*op++ = nil;
		nInstVars--;
	    }
#     endif
#    endif
#   endif
#  endif
# endif
	}
	RETURN ( newobj );
    }

    /*
     * the slow case - a GC will occur
     */
    __PROTECT_CONTEXT__
    newobj = __STX___new((INT)instsize);
    __UNPROTECT_CONTEXT__
    if (newobj != nil) goto ok;
#endif /* NOT REACHED */
%}
.
    "
     memory allocation failed.
     When we arrive here, there was no memory, even after
     a garbage collect.
     This means, that the VM wanted to get some more memory from the
     Operatingsystem, which was not kind enough to give it.
     Bad luck - you should increase the swap space on your machine.
    "
    ^ AllocationFailure raise.
!

basicNew:anInteger
    "return an instance of myself with anInteger indexed variables.
     If the receiver-class has no indexed instvars, this is only allowed
     if the argument, anInteger is zero.
     ** Do not redefine this method in any class **"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (anInteger.isSmallInteger()) {
	return __c__._RETURN( self.basicNew( anInteger.intValue()) );
    }
#else
    OBJ newobj;
    unsigned INT nInstVars;
    unsigned INT instsize;
    INT nindexedinstvars;
    unsigned INT nBytes;
    unsigned INT flags;
# if ! defined(FAST_ARRAY_MEMSET)
    REGISTER char *cp;
    short *sp;
#  if defined(__i386__) || defined(__x86__) || defined(__x86_64__) || defined(__sparc__)
    int *lp;
#  else
#   error "please (conditionally) declare lp as pointer to 4byte integer type"
#  endif
# endif
    REGISTER OBJ *op;
    float *fp;
    double *dp;

    if (__isSmallInteger(anInteger)) {
	nindexedinstvars = __intVal(anInteger);
	if (nindexedinstvars >= 0) {
	    nInstVars = __intVal(__INST(instSize));
	    flags = __intVal(__INST(flags)) & ARRAYMASK;
	    switch (flags) {
		case BYTEARRAY:
		    nBytes = nindexedinstvars + __OBJS2BYTES__(nInstVars);
		    instsize = OHDR_SIZE + nBytes;
			if (__CanDoQuickNew(instsize)) {        /* OBJECT ALLOCATION */
			    /*
			     * the most common case
			     */
			    __qCheckedNew(newobj, instsize);
			    __InstPtr(newobj)->o_class = self;
			    __qSTORE(newobj, self);
		nilIt:
			cp = (char *)__InstPtr(newobj)->i_instvars;
# if defined(memset4) && defined(FAST_ARRAY_MEMSET4) || defined(FAST_MEMSET4)
			memset4(cp, 0, (nBytes+3) >> 2);
# elif defined(FAST_ARRAY_MEMSET)
			memset(cp, 0, nBytes);
# else
			while (nBytes >= (sizeof(INT) * 8L)) {
			    ((INT *)cp)[0] = (INT)0;
			    ((INT *)cp)[1] = (INT)0;
			    ((INT *)cp)[2] = (INT)0;
			    ((INT *)cp)[3] = (INT)0;
			    ((INT *)cp)[4] = (INT)0;
			    ((INT *)cp)[5] = (INT)0;
			    ((INT *)cp)[6] = (INT)0;
			    ((INT *)cp)[7] = (INT)0;
			    cp += (sizeof(INT) * 8L);
			    nBytes -= (sizeof(INT) * 8L);
			}
			while (nBytes >= sizeof(INT)) {
				*(INT *)cp = (INT)0;
				cp += sizeof(INT);
			    nBytes -= sizeof(INT);
			    }
			while (nBytes--)
			    *cp++ = 0;
# endif
			    RETURN ( newobj );
		    }
		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);   /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);
		    goto nilIt;
		    break;

		case WORDARRAY:
		case SWORDARRAY:
		    nBytes = __OBJS2BYTES__(nInstVars) + nindexedinstvars * 2;
		    instsize = OHDR_SIZE + nBytes;
		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);   /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);
		    goto nilIt;

	       case LONGARRAY:
	       case SLONGARRAY:
		    nBytes = __OBJS2BYTES__(nInstVars) + nindexedinstvars * 4;
		    instsize = OHDR_SIZE + nBytes;
		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);    /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);
		    goto nilIt;

	       case LONGLONGARRAY:
	       case SLONGLONGARRAY:
		    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
# ifdef __NEED_LONGLONG_ALIGN
		    instsize = ((instsize-1) + __LONGLONG_ALIGN) & ~(__LONGLONG_ALIGN-1);
# endif
		    instsize += nindexedinstvars * 8;
		    nBytes = instsize - OHDR_SIZE;

		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);    /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);
		    goto nilIt;
		    break;

	       case FLOATARRAY:
		    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
# ifdef __NEED_FLOATARRAY_ALIGN
		    instsize = ((instsize-1) + __FLOATARRAY_ALIGN) & ~(__FLOATARRAY_ALIGN-1);
# endif
		    instsize += nindexedinstvars * sizeof(float);
		    nBytes = instsize - OHDR_SIZE;

		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);   /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);

# if defined(__FLOAT0_IS_INT0) /* knowin that float 0.0 is all-zeros */
		    goto nilIt;
#  else
		    op = __InstPtr(newobj)->i_instvars;
		    while (nInstVars-- != 0)
			*op++ = nil;
		    fp = (float *)op;
		    while (nindexedinstvars-- != 0)
			*fp++ = 0.0;
# endif
		    RETURN ( newobj );
		    break;

	       case DOUBLEARRAY:
		    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
# ifdef __NEED_DOUBLE_ALIGN
		    instsize = ((instsize-1) + __DOUBLE_ALIGN) & ~(__DOUBLE_ALIGN-1);
# endif
		    instsize += nindexedinstvars * sizeof(double);
		    nBytes = instsize - OHDR_SIZE;

		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);    /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);

# if defined(__DOUBLE0_IS_INT0) /* knowin that double 0.0 is all-zeros */
		    goto nilIt;
# else
		    op = __InstPtr(newobj)->i_instvars;
		    while (nInstVars-- != 0)
			*op++ = nil;

#  ifdef __NEED_DOUBLE_ALIGN
		    /*
		     * care for double alignment
		     * add filler.
		     */
		    if ((INT)op & (__DOUBLE_ALIGN-1)) {
			*op++ = nil;
		    }
#  endif
		    dp = (double *)op;
		    while (nindexedinstvars-- != 0)
			*dp++ = 0.0;
# endif
		    RETURN ( newobj );
		    break;

		case WKPOINTERARRAY:
		case POINTERARRAY:
		    nInstVars += nindexedinstvars;
		    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
		    __PROTECT_CONTEXT__
		    __qNew(newobj, instsize);    /* OBJECT ALLOCATION */
		    __UNPROTECT_CONTEXT__
		    if (newobj == nil) {
			break;
		    }
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);

# if defined(memset4) && defined(FAST_ARRAY_MEMSET4) || defined(FAST_MEMSET4)
		    memset4(__InstPtr(newobj)->i_instvars, nil, nInstVars);
# else
		    /*
		     * knowing that nil is 0
		     */
#  ifdef sparc
#   define FAST_ARRAY_MEMSET_DOUBLES_UNROLLED
#  endif

#  if defined(FAST_ARRAY_MEMSET_DOUBLES_UNROLLED)
		    op = __InstPtr(newobj)->i_instvars;
		    if (nInstVars > 8) {
			*op++ = nil;    /* for alignment */
			nInstVars--;
			while (nInstVars >= 8) {
			    *(double *)op = 0.0;
			    ((double *)op)[1] = 0.0;
			    ((double *)op)[2] = 0.0;
			    ((double *)op)[3] = 0.0;
			    op += 8;
			    nInstVars -= 8;
			}
		    }
		    while (nInstVars != 0) {
			*op++ = 0;
			nInstVars--;
		    }
#  else
#   if defined(FAST_ARRAY_MEMSET_LONGLONG_UNROLLED)
		    op = __InstPtr(newobj)->i_instvars;
		    if (nInstVars > 8) {
			*op++ = nil;    /* for alignment */
			nInstVars--;
			while (nInstVars >= 8) {
			    *(long long *)op = 0;
			    ((long long *)op)[1] = 0;
			    ((long long *)op)[2] = 0;
			    ((long long *)op)[3] = 0;
			    op += 8;
			    nInstVars -= 8;
			}
		    }
		    while (nInstVars != 0) {
			*op++ = 0;
			nInstVars--;
		    }
#   else
#    if defined(FAST_ARRAY_MEMSET)
		    memset(__InstPtr(newobj)->i_instvars, 0, instsize - OHDR_SIZE);
#    else
		    op = __InstPtr(newobj)->i_instvars;
		    while (nInstVars >= 8) {
			nInstVars -= 8;
			op[0] = nil; op[1] = nil;
			op[2] = nil; op[3] = nil;
			op[4] = nil; op[5] = nil;
			op[6] = nil; op[7] = nil;
			op += 8;
		    }
		    while (nInstVars-- != 0)
			*op++ = nil;
#    endif
#   endif
#  endif
# endif
		    RETURN ( newobj );
		    break;

		default:
		    /*
		     * new:n for non-variable classes only allowed if
		     * n == 0
		     */
		    if (nindexedinstvars == 0) {
			instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
			__PROTECT_CONTEXT__
			__qNew(newobj, instsize);        /* OBJECT ALLOCATION */
			__UNPROTECT_CONTEXT__
			if (newobj == nil) {
			    break;
			}
			__InstPtr(newobj)->o_class = self;
			__qSTORE(newobj, self);

			if (nInstVars) {
# if defined(memset4) && defined(FAST_OBJECT_MEMSET4) || defined(FAST_MEMSET4)
			    memset4(__InstPtr(newobj)->i_instvars, nil, nInstVars);
# else
#  if defined(FAST_MEMSET)
			    /*
			     * knowing that nil is 0
			     */
			    memset(__InstPtr(newobj)->i_instvars, 0, instsize - OHDR_SIZE);
#  else
			    op = __InstPtr(newobj)->i_instvars;
			    do {
				*op++ = nil;
			    } while (--nInstVars != 0);
#  endif
# endif
			}
			RETURN ( newobj );
		    }
		    break;
	    }
	}
    }
#endif /* not SCHTEAM */
%}.
    "
     arrive here if something went wrong ...
     figure out what it was
    "

    (anInteger isMemberOf:SmallInteger) ifFalse:[
	"
	 the argument is either not an integer,
	 or a LargeInteger (which means that its definitely too big)
	"
	self error:'argument to new: must be Integer' mayProceed:true.
	^ nil
    ].
    (anInteger < 0) ifTrue:[
	"
	 the argument is negative,
	"
	self error:'bad (negative) argument to new:'.
	^ nil
    ].
    self isVariable ifFalse:[
	"
	 this class does not have any indexed instance variables
	"
	self error:'class has no indexed instvars - cannot create with new:'.
	^ nil
    ].
    "
     memory allocation failed.
     When we arrive here, there was no memory, even after
     a garbage collect.
     This means, that the VM wanted to get some more memory from the
     Operatingsystem, which was not kind enough to give it.
     Bad luck - you should increase the swap space on your machine.
    "
    ^ AllocationFailure raise.
!

decodeFromLiteralArray:anArray
    "create & return a new instance from information encoded in anArray."

    ^ self new fromLiteralArrayEncoding:anArray.

    "
     Rectangle
	decodeFromLiteralArray:#(Rectangle 10 10 100 100)
    "

    "Modified: / 28.1.1998 / 17:40:30 / cg"
!

new
    "return an instance of myself without indexed variables"

    ^ self basicNew
!

new:anInteger
    "return an instance of myself with anInteger indexed variables"

    ^ self basicNew:anInteger
!

niceBasicNew:anInteger
    "same as basicNew:anInteger, but tries to avoid long pauses
     due to garbage collection. This method checks to see if
     allocation is possible without a pause, and does a background
     incremental garbage collect first if there is not enough memory
     available at the moment for fast allocation.
     This is useful in low-priority background processes which like to
     avoid disturbing any higher priority foreground process while allocating
     big amounts of memory. Of course, using this method only makes
     sense for big or huge objects (say > 200k).

     EXPERIMENTAL: this is a non-standard interface and should only
     be used for special applications. There is no guarantee, that this
     method will be available in future ST/X releases."

    |size|

    size := self sizeOfInst:anInteger.
    (ObjectMemory checkForFastNew:size) ifFalse:[
	"
	 incrementally collect garbage
	"
	ObjectMemory incrementalGC.
    ].
    ^ self basicNew:anInteger
!

readFrom:aStream
    "read an objects printed representation from the argument, aStream
     and return it.
     The read object must be a kind of myself if its not, an error is raised.
     This is the reverse operation to 'storeOn:'.

     WARNING: storeOn: does not handle circular references and multiple
	      references to the same object.
	      Use #storeBinary:/readBinaryFrom: for this."

    ^ self
	readFrom:aStream
	onError:[ self conversionErrorSignal
		    raiseWith:aStream errorString:' for: ' , self name ]

    "
     |s|
     s := WriteStream on:String new.
     #(1 2 3 4) storeOn:s.
     Object readFrom:(ReadStream on:s contents)
    "
!

readFrom:aStream onError:exceptionBlock
    "read an object's printed representation from the argument, aStream
     and return it (i.e. the stream should contain some representation of
     the object which was created using #storeOn:).
     The read object must be a kind of myself.
     If it's not, the value of exceptionBlock is returned.
     To get any object, use 'Object readFrom:...',
     To get any number, use 'Number readFrom:...' and so on.
     This is the reverse operation to 'storeOn:'.

     WARNING: storeOn: does not handle circular references and multiple
              references to the same object.
              Use #storeBinary:/readBinaryFrom: for this."

    ^ [
        |newObject|

        newObject := self evaluatorClass evaluateFrom:aStream ifFail:exceptionBlock.
        ((newObject class == self) or:[newObject isKindOf:self])
            ifTrue:[newObject]
            ifFalse:[^ exceptionBlock value].
    ] on:Error do:exceptionBlock.

    "
     |s|
     s := WriteStream on:String new.
     #(1 2 3 4) storeOn:s.
     Transcript showCR:(
        Array readFrom:(ReadStream on:s contents) onError:'not an Array'
     )
    "
    "
     |s|
     s := WriteStream on:String new.
     #[1 2 3 4] storeOn:s.
     Transcript showCR:(
         Array readFrom:(ReadStream on:s contents) onError:'not an Array'
     )
    "
    "
     Object readFrom:'illegal' onError:['bla']
     String readFrom:'illegal' onError:'bla'
    "
!

readFromString:aString
    "create an object from its printed representation.
     For most classes, the string is expected to be in a format created by
     storeOn: or storeString; however, some (Time, Date) expect a user
     readable string here.
     See comments in Behavior>>readFromString:onError:,
     Behavior>>readFrom: and Behavior>>readFrom:onError:"

    ^ self
	readFromString:aString
        onError:[ 
	    self conversionErrorSignal raiseWith:aString errorString:' - expected: ' , self name
	]

    "
     Integer readFromString:'12345678901234567890'
     Point readFromString:'1@2'
     Point readFromString:'1'
    "
!

readFromString:aString onError:exceptionBlock
    "create an object from its printed representation.
     Here, the string is expected to be in a format created by
     storeOn: or storeString;
     However, some classes (Time, Date) may redefine it to expect a user readable string here.
     See comments in Behavior>>readFrom: and Behavior>>readFrom:onError:"

    |str val|

    str := ReadStream on:aString.
    val := self readFrom:str onError:[^ exceptionBlock value].
    str atEnd ifFalse:[
	str skipSeparators.
	str atEnd ifFalse:[
	    ^ exceptionBlock value
	]
    ].
    ^ val

    "
     Integer readFromString:'12345678901234567890'
     Integer readFromString:'abc'
     Integer readFromString:'abc' onError:0
     Point readFromString:'1@2'
     Point readFromString:'0'
     Point readFromString:'0' onError:[0@0]
    "
!

uninitializedNew
    "create an instance of myself with uninitialized contents.
     For all classes except ByteArray, this is the same as #basicNew."

    ^ self basicNew
!

uninitializedNew:anInteger
    "create an instance of myself with uninitialized contents.
     For all classes except ByteArray, this is the same as #basicNew:."

    ^ self basicNew:anInteger
! !

!Behavior methodsFor:'misc ui support'!

browse
    "open a browser showing the receiver. Returns the browser"

    ^ self browserClass openInClass:self

    "
     Array browserClass
     Array browse
    "
!

browse:selector
    "open a browser showing the receiver.
     Returns the browser"

    ^ self browserClass openInClass:self selector:selector

    "
     Array browse:#at:put:
    "
!

classOperationsMenu
    "a chance to return additional menu items for the browser's class-menu"

    ^ nil

    "Modified: / 31-01-2011 / 11:05:49 / cg"
!

sourceCodeTemplate
    ^ 'messageSelector and arguments
    "method comment - purpose of message"

    |temporaries|

    statements

    "
     example uses
    "
'

    "Created: / 19.6.1998 / 02:14:02 / cg"
!

toolListIcon
    "VisualWorks icon retrieval for the browser list.
     Only redefined in VW classes.
     Notice, that ST/X uses a better scheme, where the class only
     returns a symbol, which is used to map into the icon library.
     Thus allowing different icons as per view style"

    ^ nil
! !

!Behavior methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a string to display the receiver - include the
     count for your convenience.

     although behaviors have no name, we return something
     useful here - there are many places (inspectors) where
     a classes name is asked for.
     Implementing this message here allows instances of anonymous classes
     to show a reasonable name."

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:self name
!

printOn:aStream
    aStream nextPutAll:(self name).
! !

!Behavior methodsFor:'private-accessing'!

flags:aNumber
    "set the flags.
     see flagXXX methods on my class side for details.
     This method is for special uses only - there will be no recompilation
     and no change record written here;
     Warning:
	the flags slot specifies the layout and behavior of my instances slots
	and affects both the VM's and the class library's behavior.
	It is required to be consistent and correct.
	Setting it to a wrong value may severely affect the system's operation,
	and even crash the system (in the garbage collector).
	Do NOT use it, unless you really know what you are doing."

    flags := aNumber
!

instSize:aNumber
    "set the instance size.
     This method is for special uses only - there will be no recompilation
     and no change record written here;
     Warning:
	the instSize slot specifies the size of my instances and affects
	both the VM's and the class library's behavior.
	It is required to be consistent and correct.
	Setting it to a wrong value may severely affect the system's operation,
	and even crash the system (in the garbage collector).
	Do NOT use it, unless you really know what you are doing."

    instSize := aNumber
!

primAddSelector:aSelector withMethod:newMethod
    "add the method given by 2nd argument under the selector given by
     the 1st argument to the methodDictionary.
     Does NOT flush any caches, does NOT write a change record.

     Do not use this in normal situations, strange behavior will be
     the consequence.
     I.e. executing obsolete methods, since the old method will still
     be executed out of the caches."

    |dict oldMethod|

    newMethod isNil ifTrue:[
        self error:'invalid method'.
    ].

    dict := self methodDictionary.
    oldMethod := dict at:aSelector ifAbsent:nil.

    (Smalltalk
            changeRequest:#methodInClass
            with:(Array with:self with:aSelector with:oldMethod)) ifFalse:[
        ^ false
    ].

    self setMethodDictionary:(dict at:aSelector putOrAppend:newMethod).
    newMethod mclass:self.

    ObjectMemory flushCachesForSelector:aSelector numArgs:newMethod argumentCount.
    ^ true

    "Modified: / 07-06-1996 / 14:48:45 / stefan"
    "Modified: / 31-08-2007 / 16:53:20 / cg"
!

setMethodDictionary:dict
    "set the receiver's method dictionary.
     Convert dict to a MethodDictionary if necessary.
     Do not flush inline caches, therefore old cached methods may be executed
     after this call"

%{
#ifdef __SCHTEAM__
    self.instVarAt_put(I_methodDictionary, dict);
    return __c__._RETURN(self);
#endif
%}.
    "/ since the only thing the VM is prepared to deal with are
    "/ proper methodDictionaries (it cannot do another message send, to
    "/ find any methods ...), we convert it here if required.
    "/ No other classes instances are allowed.

    dict class ~~ MethodDictionary ifTrue:[
        methodDictionary := MethodDictionary withAll:dict.
        methodDictionary isNil ifTrue:[

            "/ refuse to do this
            "/ (can only happen in case of memory allocation trouble,
            "/  where the allocation failed and some exception handler returned
            "/  nil ...)

            self error:'cannot set methodDictionary to nil' mayProceed:true.
            ^ self.
        ]
    ] ifFalse:[
        methodDictionary := dict.
    ].
    ^ self.

    "Created: 5.6.1996 / 11:29:36 / stefan"
    "Modified: 12.6.1996 / 13:58:55 / stefan"
    "Modified: 22.1.1997 / 21:10:48 / cg"
!

setSuperclass:aClass
    "set the superclass of the receiver.
     this method is for special uses only - there will be no recompilation
     and no change record written here. Also, if the receiver class has
     already been in use, future operation of the system is not guaranteed to
     be correct, since no caches are flushed.
     Therefore: do NOT use it; use Behavior>>superclass: (or flush the caches, at least)"

    superclass := aClass

    "Modified: 3.3.1997 / 13:27:00 / cg"
!

setSuperclass:aClass instSize:i
    "set some inst vars.
     this method is for special uses only - there will be no recompilation
     and no change record is written here. Also, if the receiver class has
     already been in use, future operation of the system is not guaranteed to
     be correct, since no caches are flushed.
     Therefore: do NOT use it; use Behavior>>superclass: (or flush the caches, at least)"

    superclass := aClass.
    instSize := i.
!

setSuperclass:aClass methodDictionary:d instSize:i flags:f
    "set some inst vars.
     this method is for special uses only - there will be no recompilation
     and no change record is written here. Also, if the receiver class has
     already been in use, future operation of the system is not guaranteed to
     be correct, since no caches are flushed.
     Therefore: do NOT use it; use Behavior>>superclass: (or flush the caches, at least)"

    self setMethodDictionary:d.
    superclass := aClass.
    instSize := i.
    flags := f

    "Created: 7.6.1996 / 08:41:20 / stefan"
    "Modified: 22.1.1997 / 18:42:12 / cg"
! !

!Behavior methodsFor:'private-helpers'!

addAllClassVarNamesTo:aCollection
    "helper - add the name-strings of the class variables and of the class-vars
     of all superclasses to the argument, aCollection. Return aCollection"

    |classvars superclass|

    superclass := self superclass.
    (superclass notNil) ifTrue:[
	superclass addAllClassVarNamesTo:aCollection
    ].
    (classvars := self classVariableString) notNil ifTrue:[
	aCollection addAll:(classvars asCollectionOfWords).
    ].
    ^ aCollection

    "Created: 16.4.1996 / 18:00:38 / cg"
!

addAllInstVarNamesTo:aCollection
    "helper for allInstVarNames - add the name-strings of the instance variables
     and of the inst-vars of all superclasses to the argument, aCollection.
     Return aCollection."

    |superclass|

    superclass := self superclass.
    (superclass notNil) ifTrue:[
	superclass addAllInstVarNamesTo:aCollection
    ].
    aCollection addAll:self instVarNames.
    ^ aCollection

    "
     SortedCollection allInstVarNames
     SortedCollection instVarNames
    "
!

addAllPrivateClassesTo:aCollection
    "add all of my private classes to aCollection"

    self privateClassesDo:[:aPrivateClass |
	aCollection add:aPrivateClass.
	aPrivateClass addAllPrivateClassesTo:aCollection
    ].
!

getLookupObject
    "return the lookupObject (Jan's MetaObjectProtocol support) or nil.
     If non-nil, no lookup is performed by the VM, instead the lookupObject
     has to provide a method object for message sends."

    ^ lookupObject

    "Created: / 26-04-2010 / 13:36:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLookupObject:aLookupObjectOrNil
    "set the lookupObject (Jan's MetaObjectProtocol support) or nil.
     If non-nil, no lookup is performed by the VM, instead the lookupObject
     has to provide a method object for message sends."

    lookupObject ~~ aLookupObjectOrNil ifTrue:[
	lookupObject := aLookupObjectOrNil.
	self withAllSubclassesDo:[:cls | ObjectMemory flushCachesFor: cls]
    ]

    "Modified: / 22-07-2010 / 18:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Behavior methodsFor:'queries'!

category
    "return the category of the class.
     Returning nil here, since Behavior does not define a category
     (only ClassDescriptions do)."

    ^ nil

    "
     Point category
     Behavior new category
    "
!

comment
    "return the comment of the class.
     Returning nil here, since Behavior does not define a category
     (only Classes do). This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well."

    ^ nil

    "Modified: 16.4.1996 / 16:25:23 / cg"
!

definitionSelector
    "return the selector with which I was (can be) defined in my superclass"

    ^ (self firstDefinitionSelectorPart
      ,
      'instanceVariableNames:classVariableNames:poolDictionaries:category:') asSymbol

    "
     Object definitionSelector
     Array definitionSelector
     ByteArray definitionSelector
     FloatArray definitionSelector
    "

    "Modified: 3.3.1997 / 11:50:37 / cg"
!

definitionSelectorPrivate
    "return the selector with which I was (can be) defined in my superclass
     as a private class"

    ^ (self firstDefinitionSelectorPart
      ,
      'instanceVariableNames:classVariableNames:poolDictionaries:privateIn:') asSymbol

    "
     Array definitionSelector
     Array definitionSelectorPrivate
    "

    "Modified: 23.6.1997 / 10:45:57 / cg"
!

environment
    "return the namespace I am contained in; ST-80 compatible name.
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ nil
!

firstDefinitionSelectorPart
    "return the first part of the selector with which I was (can be) defined in my superclass"

    self isVariable ifFalse:[
	^ #'subclass:'
    ].
    self isBytes ifTrue:[
	^ #'variableByteSubclass:'
    ].
    self isLongs ifTrue:[
	^ #'variableLongSubclass:'
    ].
    self isFloats ifTrue:[
	^ #'variableFloatSubclass:'
    ].
    self isDoubles ifTrue:[
	^ #'variableDoubleSubclass:'
    ].
    self isWords ifTrue:[
	^ #'variableWordSubclass:'
    ].
    self isSignedWords ifTrue:[
	^ #'variableSignedWordSubclass:'
    ].
    self isSignedLongs ifTrue:[
	^ #'variableSignedLongSubclass:'
    ].
    self isSignedLongLongs ifTrue:[
	^ #'variableSignedLongLongSubclass:'
    ].
    self isLongLongs ifTrue:[
	^ #'variableLongLongSubclass:'
    ].
    ^ #'variableSubclass:'
!

fullName
    "Answer the name of the receiver, fully qualified."

    ^ self name asString

!

hasExtensions
    ^ false

    "Created: / 06-08-2006 / 15:23:32 / cg"
!

isAbstract
    "true if this is an abstract class 
     (has no direct instances, should not be instantiated).
     Usually, this means that it only provides shared protocol for its
     subclasses, which should be used.
     Notice: this does not have any semantic effect;
     it is purely for the browser (shows an 'A'-Indicator)
     and for documentation.
     To enforce abstractness, a subclass should redefine new, to raise an exception.
     (which some do, but many are too lazy to do)"
    
    ^ false
!

isBehavior
    "return true, if the receiver is describing another object's behavior.
     Defined to avoid the need to use isKindOf:"

    ^ true

    "
     True isBehavior
     true isBehavior
    "
!

isBrowserStartable
    ^ false

    "Created: / 06-10-2006 / 11:33:42 / cg"
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, false is returned as default.
     Notice, this is instance protocol, which means that any class
     other than those special ones) are non-builtIn by default."

    ^ false

    "Modified: 23.4.1996 / 15:55:52 / cg"
    "Created: 28.10.1996 / 15:10:02 / cg"
!

isObsolete
    "return true, if the receiver is obsolete
     (i.e. has been replaced by a different class or was removed,
      but is still referenced by instanced).
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ false
!

isPrivate
    "return true, if the receiver is some private class"

    ^ self owningClass notNil

    "Modified: 12.10.1996 / 20:11:05 / cg"
!

isStartableWithMain
    "return true, if this is an application class,
     which can be started via #main / #main:"

    ^ false

    "Created: / 06-08-2006 / 15:23:50 / cg"
!

isStartableWithStart
    "return true, if this is an application class,
     which can be started via #start"

    ^ false

    "Created: / 06-08-2006 / 15:23:57 / cg"
!

isUtilityClass
    "a utility class is one which is not to be instantiated,
     but only provides a number of utility functions on the class side.
     It is usually also abstract"
     
    ^ false
!

isVisualStartable
    ^ false

    "Created: / 06-08-2006 / 15:23:38 / cg"
!

name
    "although behaviors have no name, we return something
     useful here - there are many places (inspectors) where
     a classes name is asked for.
     Implementing this message here allows anonymous classes
     and instances of them to be inspected."

    ^ #'anonymous Behavior'
!

nameInBrowser
    "return a nameString as shown in browsers"

    ^ self name ? '?'
!

nameSpace
    "return the namespace I am contained in.
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ nil
!

nameWithArticle
    "return a string consisting of classname preceeded by an article.
     (don't expect me to write national variants for this ... :-)
     If you have special preferences, redefine it..."

    |classname|

    classname := self name.
    classname isEmptyOrNil ifTrue:[ ^ 'an anonymous' ].
    ^ classname article , ' ' , classname

    "
     SmallInteger nameWithArticle
    "

    "Modified: / 13-06-2012 / 14:50:03 / cg"
!

owningClass
    "return my owning class - nil if I am a public class"

    "/ this information is in the metaclass ...

    ^ self class owningClass

    "Created: 15.10.1996 / 21:19:32 / cg"
    "Modified: 7.11.1996 / 13:49:28 / cg"
!

owningClassOrYourself
    "return my owning class if I am private, myself otherwise"

    self owningClass notNil ifTrue:[^ self topOwningClass].
    ^ self
!

privateClassesAt:aClassNameStringOrSymbol
    "return a private class if present; nil otherwise.
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ nil
!

realSharedPoolNames
    "this returns the namespace aware pool names.
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ #()
!

revision
    ^ nil

    "Created: / 03-08-2006 / 01:53:44 / cg"
!

sourceCodeAt:aSelector
    "return the methods source for given selector aSelector or nil.
     Only methods in the receiver - not in the superclass chain are tested."

    ^ self sourceCodeAt:aSelector ifAbsent:nil

    "
     True sourceCodeAt:#ifTrue:
     Object sourceCodeAt:#==
     Behavior sourceCodeAt:#sourceCodeAt:
    "
!

sourceCodeAt:aSelector ifAbsent:exceptionalValue
    "return the methods source for given selector aSelector or exceptionalValue.
     Only methods in the receiver - not in the superclass chain are tested."

    |method|

    method := self compiledMethodAt:aSelector.
    method isNil ifTrue:[^ exceptionalValue value].
    ^ method source
!

sourceCodeManager
    "return the sourceCodeManager of the class.
     Returning nil here, since Behavior does not define any sourceCode management.
     (only Classes do). This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well."

    ^ nil

    "Created: 16.4.1996 / 16:26:03 / cg"
!

supportsMethodCategories
    "return true, if my methods are categorized.
     This is a hook for the browser to allow alien classes
     to be handled (actually, this is not yet used)."

    ^ self class supportsMethodCategories

    "Created: / 30-07-1997 / 14:59:08 / cg"
    "Modified: / 01-06-2012 / 20:38:03 / cg"
!

theMetaclass
    "return the metaClass of the class-meta pair.
     Here, return my metaclass object, because I am the class.
     Also implemented in my metaclass, which returns itself."

    ^ self class

    "Created: / 30.1.2000 / 23:08:30 / cg"
    "Modified: / 31.1.2000 / 16:16:52 / cg"
!

theNonMetaclass
    "return the nonMetaClass of the class-meta pair.
     Here, return myself, because I am the nonMetaclass.
     Also implemented in my metaclass, which also returns me.
     Sigh: ST/X naming; Squeak calls this theNonMetaClass"

    ^ self

    "Created: / 30.1.2000 / 23:07:59 / cg"
    "Modified: / 31.1.2000 / 16:17:46 / cg"
!

topNameSpace
    "return the nameSpace of my topOwningClass (if private) or my own nameSpace.
     Not normally needed here, but added to allow for instances of anonymous behaviours
     to be inspected or browsed."

    ^ nil
!

topOwningClass
    "return my outermost owning class - nil if I am a public class"

    "/ this information is in the metaclass ...

    ^ self class topOwningClass

    "Created: 15.10.1996 / 21:19:32 / cg"
    "Modified: 3.1.1997 / 19:18:49 / cg"
! !

!Behavior methodsFor:'queries-inheritance'!

allSubclasses
    "return a collection of all subclasses (direct AND indirect) of
     the receiver. There will be no specific order, in which entries
     are returned. NameSpaces are excluded from the list."

    |newColl|

    newColl := OrderedCollection new.
    self allSubclassesDo:[:aClass |
	(aClass isRealNameSpace) ifFalse:[
	    newColl add:aClass
	]
    ].
    ^ newColl

    "
     Collection allSubclasses
    "

    "Modified: / 10-11-2006 / 17:22:58 / cg"
!

allSubclassesInOrder
    "return a collection of all subclasses (direct AND indirect) of
     the receiver. Higher level subclasses will come before lower ones.
     NameSpaces are excluded from the list."

    |newColl|

    newColl := OrderedCollection new.
    self allSubclassesInOrderDo:[:aClass |
	(aClass isRealNameSpace) ifFalse:[
	    newColl add:aClass
	]
    ].
    ^ newColl

    "
     Collection allSubclassesInOrder
    "

    "Modified: / 10-11-2006 / 17:23:06 / cg"
!

allSuperclasses
    "return a collection of the receiver's accumulated superclasses"

    |aCollection theSuperClass|

    theSuperClass := self superclass.
    theSuperClass isNil ifTrue:[
        ^ #()
    ].
    aCollection := OrderedCollection new.
    [theSuperClass notNil] whileTrue:[
        aCollection add:theSuperClass.
        theSuperClass := theSuperClass superclass
    ].
    ^ aCollection

    "
     String allSuperclasses
    "
!

canBeSubclassed
    "return true, if its allowed to create subclasses of the receiver.
     This method is redefined in SmallInteger and UndefinedObject, since
     instances are detected by their pointer-fields, i.e. they do not have
     a class entry (you don't have to understand this :-)"

    ^ true
!

commonSuperclass:aClass
    "Return the common superclass of the receiver and aClass.
     Assumes that there is a common superclass of any two classes.
     (might return nil, if either the receiver or the argument inherits from nil)"

    (aClass == self) ifTrue:[^ self].
    (aClass isSubclassOf:self) ifTrue:[^ self].
    (self isSubclassOf:aClass) ifTrue:[^ aClass].
    superclass isNil ifTrue:[^ nil].
    ^ superclass commonSuperclass:aClass

    "
     Integer commonSuperclass:Fraction
     SmallInteger commonSuperclass:Fraction
     View commonSuperclass:Form
     View commonSuperclass:Image
     View commonSuperclass:View
     Integer commonSuperclass:Autoload
     Integer commonSuperclass:Object
    "

    "Modified (comment): / 17-03-2012 / 19:56:28 / cg"
!

hasMultipleSuperclasses
    "Return true, if this class inherits from other classes
     (beside its primary superclass).
     This method is a preparation for a future multiple inheritance extension
     - currently it is not supported by the VM"

    ^ false
!

includesBehavior:aClass
    "return true, if the receiver includes the behavior of aClass;
     i.e. if is either identical to a class or inherits from it."

    ^ (self == aClass) or:[self isSubclassOf:aClass]

    "
     True includesBehavior:Object
     True includesBehavior:Boolean
     True includesBehavior:True
     True includesBehavior:False
    "

    "Modified: 19.6.1997 / 18:14:35 / cg"
!

inheritsFrom:aClass
    "return true, if the receiver inherits methods from aClass;
     i.e. if aClass is on the receiver's superclass chain."

    ^ self isSubclassOf:aClass

    "
     True inheritsFrom:Object
     LinkedList inheritsFrom:Array
    "

    "Modified: 19.6.1997 / 18:13:21 / cg"
!

isSubclassOf:aClass
    "return true, if I am a subclass of the argument, aClass"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STClass theClass = self.superClazz();

    while (theClass != null) {
	if (theClass == aClass) {
	    return __c__._RETURN_true();
	}
	theClass = theClass.superClazz();
    }
    return __c__._RETURN_false();
    /* NOTREACHED */
#else
    OBJ __theClass = __INST(superclass);
    int n = 0;

    while (__theClass != nil) {
	if (__theClass == aClass) {
	    RETURN(true);
	}
	if (__isBehaviorLike(__theClass)) {
	    __theClass = __ClassInstPtr(__theClass)->c_superclass;
	} else {
	    __theClass = nil;
	}
	if (++n > 100000) goto vmError;
    }
    RETURN (false);
vmError: ;
#endif /* not SCHTEAM */
%}.
    VMInternalError raiseErrorString:'deep inheritance'.

"/    |theClass|
"/
"/    theClass := superclass.
"/    [theClass notNil] whileTrue:[
"/        (theClass == aClass) ifTrue:[^ true].
"/%{
"/        if (__isBehaviorLike(theClass)) {
"/            theClass = __ClassInstPtr(theClass)->c_superclass;
"/        } else {
"/            theClass = nil;
"/        }
"/%}.
"/"/        theClass := theClass superclass.
"/    ].
"/    ^ false

    "
     String isSubclassOf:Collection
     LinkedList isSubclassOf:Array
     1 isSubclassOf:Number              <- will fail since 1 is no class
     Number isSubclassOf:1
    "
!

subclasses
    "return a collection of the direct subclasses of the receiver"

    |newColl|

    newColl := OrderedCollection new.
    self subclassesDo:[:aClass |
	newColl add:aClass
    ].
    ^ newColl.
!

superclasses
    "return a collection of the receiver's immediate superclasses.
     This method is a preparation for a future multiple inheritance extension
     - currently it is not supported by the VM"

    ^ Array with:self superclass.

    "
     String superclasses
    "
!

withAllSubclasses
    "return a collection containing the receiver and
     all subclasses (direct AND indirect) of the receiver"

    |coll|

    coll := OrderedCollection new.
    self withAllSubclassesDo:[:eachClass | coll add:eachClass].
    ^ coll

"/ the following original code is slighly less efficient (makes big collections)
"/    coll := self allSubclasses asOrderedCollection.
"/    coll addFirst:self.
"/    ^ coll

    "
     Collection withAllSubclasses
    "
!

withAllSuperclasses
    "return a collection containing the receiver and all
     of the receiver's accumulated superclasses"

    |coll|

    coll := OrderedCollection new.
    self withAllSuperclassesDo:[:cls |
        coll add:cls
    ].
    ^ coll

    "
     String withAllSuperclasses
    "
! !

!Behavior methodsFor:'queries-instances'!

allDerivedInstances
    "return a collection of all instances of myself and
     instances of all subclasses of myself.
     This method is going to be removed for protocol compatibility with
     other STs; use allSubInstances"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #allSubInstances'.
    ^ self allSubInstances

    "Modified: 31.7.1997 / 23:04:59 / cg"
!

allInstances
    "return a collection of all my instances"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    |coll|

    coll := OrderedCollection new:100.
    self allInstancesDo:[:anObject |
	coll add:anObject
    ].
    ^ coll

    "
     ScrollBar allInstances
    "
!

allInstancesForWhich:predicate do:action
    "perform action on all instances for which predicate returns true"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    self allInstancesDo:[:anObject |
	(predicate value:anObject) ifTrue:[
	    action value:anObject
	].
    ].

    "
     ScrollBar allInstancesForWhich:[:s | s shown] do:[:s | Transcript showCR:s topView label]
    "
!

allInstancesWeakly:doWeakly
    "return a collection of all my instances.
     If weakly is true, a weak collection is returned."

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    |coll|

    coll := self allInstances.
    doWeakly ifTrue:[
	coll := WeakArray withAll:coll
    ].
    ^ coll

    "Created: / 19.6.1998 / 02:17:20 / cg"
!

allSubInstances
    "return a collection of all instances of myself and
     instances of all subclasses of myself."

    |coll|

    coll := OrderedCollection new:100.
    self allSubInstancesDo:[:anObject |
	coll add:anObject
    ].
    ^ coll

    "
     View allSubInstances
    "
!

anyInstance
    "return any of my instances; raise an error, if there is none"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    self allInstancesDo:[:anObject | ^ anObject].
    self errorNotFound

    "
     ScrollBar anyInstance
     SmallInteger anyInstance
    "

    "Created: / 24-07-2007 / 06:12:27 / cg"
!

anySubInstance
    "return any of my or derived instances; raise an error, if there is none"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    self allSubInstancesDo:[:anObject | ^ anObject].
    self errorNotFound

    "
     View anySubInstance
    "
!

derivedInstanceCount
    "return the number of instances of myself and of subclasses"

    |count|

    count := 0.
    ObjectMemory allObjectsDo:[:anObject |
	(anObject isKindOf:self) ifTrue:[
	    count := count + 1
	]
    ].
    ^ count

    "
     View derivedInstanceCount
     SequenceableCollection derivedInstanceCount
     Object derivedInstanceCount
    "
!

hasDerivedInstances
    "return true, if there are any instances of myself or of any subclass"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    ObjectMemory allObjectsDo:[:anObject |
	(anObject isKindOf:self) ifTrue:[
	    ^ true
	]
    ].
    ^ false

    "
     Object hasDerivedInstances         - certainly true
     SharedQueue hasDerivedInstances
    "
!

hasImmediateInstances
    "return true if this class has immediate instances
     i.e. if the instances are represented in the pointer itself and
     no real object header/storage is used for the object.
     Redefined in classes which have so (only SmallInteger and UndefinedObject)"

    ^ false

    "Created: 3.6.1997 / 12:01:05 / cg"
!

hasImmutableInstances
    "are this classes instances immutable?"

    ^ false
!

hasInstances
    "return true, if there are any instances of myself"

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

"/    ObjectMemory allObjectsDo:[:anObject |
"/        (anObject class == self) ifTrue:[
"/            ^ true
"/        ]
"/    ].

    ObjectMemory allInstancesOf:self do:[:anObject |
	^ true
    ].
    ^ false

    "
     Object hasInstances
     SequenceableCollection hasInstances
     Float hasInstances
     SmallInteger hasInstances
    "
!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     False is returned here, only redefined in classes which have unified
     instances (or should be treated so)."

    ^ false
!

instanceCount
    "return the number of instances of myself."

    "Read the documentation on why there seem to be no
     instances of SmallInteger and UndefinedObject"

    |count|

    count := 0.
"/    ObjectMemory allObjectsDo:[:anObject |
"/        (anObject class == self) ifTrue:[
"/            count := count + 1
"/        ]
"/    ].

    ObjectMemory allInstancesOf:self do:[:anObject |
	count := count + 1
    ].
    ^ count

    "
     View instanceCount
     Object instanceCount
     Float instanceCount
     SequenceableCollection instanceCount
     SmallInteger instanceCount   .... mhmh - hear, hear
    "
! !

!Behavior methodsFor:'queries-instlayout'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     For pointer indexed classes, 0 is returned"

    self isBitsExtended ifTrue:[
	self isBytes ifTrue:[^ 1].
	self isWords ifTrue:[^ 2].
	self isSignedWords ifTrue:[^ 2].
	self isLongs ifTrue:[^ 4].
	self isSignedLongs ifTrue:[^ 4].
	self isLongLongs ifTrue:[^ 8].
	self isSignedLongLongs ifTrue:[^ 8].
    ].
    self isFloats ifTrue:[^ 4].
    self isDoubles ifTrue:[^ 8].

    ^ 0
!

isAlienBehavior
    "Returns true iff I'm an alien behavior."
%{
    RETURN( ( (INT)(__INST(flags)) & __MASKSMALLINT(ALIENPOINTERS)) ? true : false )
%}.

!

isBits
    "return true, if instances have indexed byte or short instance variables.
     Ignore long, float and double arrays, since ST-80 code using isBits are probably
     not prepared to handle them correctly."

%{  /* NOCONTEXT */

    REGISTER int what;

    what = (INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK);
    RETURN (( (what == __MASKSMALLINT(BYTEARRAY))
	     || (what == __MASKSMALLINT(WORDARRAY))) ? true : false );
%}.
    ^ self isBytes or:[self isWords]
!

isBitsExtended
    "return true, if instances have indexed byte, short, long or longlong instance variables.
     Ignore float and double arrays.
     This is really the thing we expect #isBits to return, however, #isBits
     is defined to only return true for byte- and wordIndexed instances.
     This avoids confusion of ST80 code, which is not prepared for long or longLong
     instVars."

%{  /* NOCONTEXT */

    REGISTER int what;

    what = (INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK);
    RETURN (( (what == __MASKSMALLINT(BYTEARRAY))
	     || (what == __MASKSMALLINT(WORDARRAY))
	     || (what == __MASKSMALLINT(SWORDARRAY))
	     || (what == __MASKSMALLINT(LONGARRAY))
	     || (what == __MASKSMALLINT(SLONGARRAY))
	     || (what == __MASKSMALLINT(LONGLONGARRAY))
	     || (what == __MASKSMALLINT(SLONGLONGARRAY))) ? true : false );
%}
!

isBytes
    "return true, if instances have indexed byte instance variables"

    "this could also be defined as:
	^ (flags bitAnd:(Behavior maskIndexType)) == Behavior flagBytes
    "
%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(BYTEARRAY)) ? true : false );
%}
!

isDoubles
    "return true, if instances have indexed double instance variables"

    "this could also be defined as:
	^ (flags bitAnd:(Behavior maskIndexType)) == Behavior flagDoubles
    "
%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(DOUBLEARRAY)) ? true : false );
%}
!

isFixed
    "return true, if instances do not have indexed instance variables"

    "this could also be defined as:
	^ self isVariable not
    "

%{  /* NOCONTEXT */

    RETURN ( ((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) ? false : true );
%}.
    ^ self isVariable not
!

isFloats
    "return true, if instances have indexed float instance variables"

    "this could also be defined as:
	^ (flags bitAnd:(Behavior maskIndexType)) == Behavior flagFloats
    "
%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(FLOATARRAY)) ? true : false );
%}
!

isFloatsOrDoubles
    "return true, if instances have indexed float or double instance variables"

%{  /* NOCONTEXT */

    int what;

    what = (INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK);
    RETURN (( (what == __MASKSMALLINT(FLOATARRAY))
	     || (what == __MASKSMALLINT(DOUBLEARRAY))) ? true : false );
%}.
    ^ self isFloats or:[self isDoubles]

    "
     (Object new) class isFloatsOrDoubles
     (Point new) class isFloatsOrDoubles
     (Array new) class isFloatsOrDoubles
     (ByteArray new) class isFloatsOrDoubles
     (FloatArray new) class isFloatsOrDoubles
     (DoubleArray new) class isFloatsOrDoubles
    "
!

isLongLongs
    "return true, if instances have indexed long-long instance variables (8 byte uints)"

%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(LONGLONGARRAY)) ? true : false );
%}
!

isLongs
    "return true, if instances have indexed long instance variables (4 byte uints)"

%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(LONGARRAY)) ? true : false );
%}
!

isPointers
    "return true, if instances have pointer instance variables
     i.e. are either non-indexed or have indexed pointer variables"

    "QUESTION: should we ignore WeakPointers ?"

%{  /* NOCONTEXT */

    REGISTER int flags;

    flags = __intVal(__INST(flags)) & ARRAYMASK;
    switch (flags) {
	default:
	    /* normal objects */
	    RETURN ( true );

	case BYTEARRAY:
	case WORDARRAY:
	case LONGARRAY:
	case SWORDARRAY:
	case SLONGARRAY:
	case SLONGLONGARRAY:
	case LONGLONGARRAY:
	case FLOATARRAY:
	case DOUBLEARRAY:
	    RETURN (false );

	case WKPOINTERARRAY:
	    /* what about those ? */
	    RETURN (true );
    }
%}
!

isSignedLongLongs
    "return true, if instances have indexed signed long-long instance variables (8 byte ints)"

%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(SLONGLONGARRAY)) ? true : false );
%}
!

isSignedLongs
    "return true, if instances have indexed signed long instance variables (4 byte ints)"

%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(SLONGARRAY)) ? true : false );
%}
!

isSignedWords
    "return true, if instances have indexed signed short instance variables"

%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(SWORDARRAY)) ? true : false );
%}
!

isVariable
    "return true, if instances have indexed instance variables"

    "this could also be defined as:
	^ (flags bitAnd:(Behavior maskIndexType)) ~~ 0
     "

%{  /* NOCONTEXT */

    RETURN ( ((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) ? true : false );
%}
!

isWeakPointers
    "return true, if instances have weak pointer instance variables"

%{  /* NOCONTEXT */

    REGISTER int flags;

    flags = __intVal(__INST(flags)) & ARRAYMASK;
    if (flags == WKPOINTERARRAY) {
	RETURN ( true );
    }
%}.
    ^ false
!

isWords
    "return true, if instances have indexed short instance variables"

    "this could also be defined as:
	^ (flags bitAnd:(Behavior maskIndexType)) == Behavior flagWords
    "
%{  /* NOCONTEXT */

    RETURN ( (((INT)(__INST(flags)) & __MASKSMALLINT(ARRAYMASK)) == __MASKSMALLINT(WORDARRAY)) ? true : false );
%}
!

sizeOfInst:n
    "return the number of bytes required for an instance of
     myself with n indexed instance variables.
     The argument n should be zero for classes without indexed instance variables.
     See Behavior>>niceNew: for an application of this."

    |nInstvars|

    nInstvars := self instSize.
%{
    INT nBytes = __intVal(nInstvars) * sizeof(OBJ) + OHDR_SIZE;
    if (__isSmallInteger(n)) {
	unsigned INT nIndex;

	nIndex = __intVal(n);
	switch (__intVal(__INST(flags)) & ARRAYMASK) {
	    case BYTEARRAY:
		nBytes += nIndex;
		if (nBytes & (__ALIGN__ - 1)) {
		    nBytes = (nBytes & ~(__ALIGN__ - 1)) + __ALIGN__;
		}
		break;

	    case WORDARRAY:
	    case SWORDARRAY:
		nBytes += nIndex * 2;
		if (nBytes & (__ALIGN__ - 1)) {
		    nBytes = (nBytes & ~(__ALIGN__ - 1)) + __ALIGN__;
		}
		break;

	    case LONGARRAY:
	    case SLONGARRAY:
		nBytes += nIndex * 4;
		break;

	    case LONGLONGARRAY:
	    case SLONGLONGARRAY:
		nBytes += nIndex * 8;
#ifdef __NEED_LONGLONG_ALIGN
		nBytes = (nBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
		break;

	    case FLOATARRAY:
		nBytes += nIndex * sizeof(float);
#ifdef __NEED_FLOATARRAY_ALIGN
		nBytes = (nBytes-1+__FLOATARRAY_ALIGN) &~ (__FLOATARRAY_ALIGN-1);
#endif
		break;

	    case DOUBLEARRAY:
		nBytes += nIndex * sizeof(double);
#ifdef __NEED_DOUBLE_ALIGN
		nBytes = (nBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
		break;

	    default:
		nBytes += nIndex * sizeof(OBJ);
		break;
	}
    }
    RETURN (__mkSmallInteger(nBytes));
%}

    "
	DoubleArray sizeOfInst:8
	IntegerArray sizeOfInst:8
    "
! !

!Behavior methodsFor:'queries-protocol'!

allSelectors
    "return a collection of all selectors understood by the receiver;
     this includes my selectors and all superclass selectors
     (i.e. the receiver's full protocol)"

    |superclass|

    superclass := self superclass.
    superclass notNil ifTrue:[
        ^ superclass allSelectors addAll:(self selectors); yourself.
    ].
    ^ self selectors asNewIdentitySet

    "
     Point allSelectors
     View allSelectors
     Array allSelectors
    "
!

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
    RETURN ( __lookup(self, aSelector) );
%}

    "
     String cachedLookupMethodFor:#=
     String cachedLookupMethodFor:#asOrderedCollection
    "
!

canUnderstand:aSelector
    "return true, if the receiver or one of its superclasses implements aSelector.
     (i.e. true if my instances understand aSelector).
     I think this is a bad name (it sounds more like instance protocol,
     and something like #instancesRespondTo: would have been better),
     but well, we are compatible (sigh)."

    ^ (self lookupMethodFor:aSelector) notNil

    "
     True canUnderstand:#ifTrue:
     True canUnderstand:#==
     True canUnderstand:#do:
    "
!

compiledMethodAt:aSelector
    "return the method for given selector aSelector or nil.
     Only methods in the receiver - not in the superclass chain are tested."

    ^ self compiledMethodAt:aSelector ifAbsent:nil

    "
     Object compiledMethodAt:#==
     (Object compiledMethodAt:#==) category
    "

    "Modified: / 7.6.1996 / 14:43:32 / stefan"
    "Modified: / 27.10.1997 / 20:18:55 / cg"
!

compiledMethodAt:aSelector ifAbsent:exceptionValue
    "return the method for given selector aSelector or the value
     of exceptionValue if not present.
     Only methods in the receiver - not in the superclass chain are tested."

    |dict|

    dict := self methodDictionary.
    dict isNil ifTrue:[
	('Behavior [warning]: nil methodDictionary in ' , self name printString) errorPrintCR.
	^ exceptionValue value
    ].

    ^ dict at:aSelector ifAbsent:exceptionValue

    "
     Object compiledMethodAt:#==
     (Object compiledMethodAt:#==) category
    "

    "Modified: / 7.6.1996 / 14:43:32 / stefan"
    "Modified: / 10.1.1997 / 17:27:21 / cg"
    "Created: / 27.10.1997 / 20:18:28 / cg"
!

compiledMethodNamed: methodName
    "Warning: this method is here to support multiple languages.
     Do not use in code that works just with the smalltalk code.
     Use compiledMethodAt: selector instead"

    "Returns a method with given name. This differs from
    #compiledMethodAt:, since class may contain more methods
    with same names and different selectors.

     Only methods in the receiver - not in the superclass chain are tested."

    ^ self compiledMethodNamed:methodName  ifAbsent:nil

    "
     Object compiledMethodNamed:#==
     (Object compiledMethodNamed:#==) category
    "

    "Created: / 24-08-2009 / 10:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2011 / 14:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiledMethodNamed: name ifAbsent:exceptionValue
   "Warning: this method is here to support multiple languages.
     Do not use in code that works just with the smalltalk code.
     Use compiledMethodAt: selector instead"

    "Returns a method with given name of value of exceptionValue
    if not present. This differs from #compiledMethodAt:, since class
    may contain more methods with same name and different selectors.

    Only methods in the receiver - not in the superclass chain are tested."

    |dict mth|

    dict := self methodDictionary.
    dict isNil ifTrue:[
	('Behavior [warning]: nil methodDictionary in ' , self name printString) errorPrintCR.
	^ exceptionValue value
    ].
    "Quick check: look into method dictionary"
    mth := dict at: name asSymbol ifAbsent:nil.
    mth notNil ifTrue:[^mth].

    "Slow search..."
    dict do: [:each|
	(each isSynthetic not and:[each name = name])
	    ifTrue:[^each]
    ].
    ^exceptionValue value


    "
     Object compiledMethodNamed:#==
     (Object compiledMethodNamed:#==) category
    "

    "Created: / 24-08-2009 / 10:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2011 / 14:16:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-11-2011 / 11:20:08 / cg"
!

containsMethod:aMethod
    "Return true, if the argument, aMethod is a method of myself"

    |dict|

    dict := methodDictionary.
    dict isNil ifTrue:[^ false].  "degenerated class"
    ^ (dict keyAtValue:aMethod ifAbsent:[0]) ~~ 0

    "Modified: 12.6.1996 / 13:33:53 / stefan"
!

hasMethods
    "return true, if there are any (local) methods in this class"

    ^ ("self " methodDictionary size ~~ 0)

    "
     True hasMethods
     True class hasMethods
    "

    "Modified: 7.6.1996 / 15:43:09 / stefan"
!

implements:aSelector
    "return true, if the receiver implements aSelector.
     (i.e. implemented in THIS class - NOT in a superclass).
     This is semantically equivalent to includesSelector: (which is ST/80/Squeak compatibility).

     Caveat:
        This simply checks for the selector being present in the classes
        selector table - therefore, it does not care for ignoredMethods.
        (but: you should not use this method for protocol-testing, anyway).

     Hint:
        Don't use this method to check if someone responds to a message -
        use #canUnderstand: on the class or #respondsTo: on the instance
        to do this."

    ^ self includesSelector:aSelector

    "
     notice: this is class protocol

       True includesSelector:#ifTrue:
       True includesSelector:#==

       True implements:#ifTrue:
       True implements:#==

     notice: this is instance protocol

       true respondsTo:#ifTrue:
       true respondsTo:#==

     notice: this is class protocol

       True canUnderstand:#ifTrue:
       True canUnderstand:#==
    "

    "Modified: 10.2.1996 / 13:15:56 / cg"
!

includesSelector:aSelector
    "return true, if the methodDictionary of THIS class includes a method for aSelector.
     (i.e. if aSelector is implemented in THIS class - NOT in a superclass).
     This is semantically equivalent to implements: (ST/80/Squeak compatibility).

     Hint:
	Don't use this method to check if someone responds to a message -
	use #canUnderstand: on the class or #respondsTo: on the instance
	to do this.

     Caveat:
	This simply checks for the selector being present in the classes
	selector table - therefore, it does not care for ignoredMethods.
	(but: you should not use this method for protocol-testing, anyway)."

    ^ methodDictionary includesIdenticalKey:aSelector

    "
     Object includesSelector:#==
     Object includesSelector:#murks
     Object includesSelector:nil
    "

    "Modified: / 7.6.1996 / 14:27:24 / stefan"
    "Modified: / 16.10.1998 / 13:00:15 / cg"
!

instAndClassMethods
    ^ (self theMetaclass methodDictionary values) , (self theNonMetaclass methodDictionary values)

    "Created: / 12-10-2006 / 18:36:57 / cg"
    "Modified: / 12-10-2006 / 20:36:34 / cg"
!

lookupMethodFor:aSelector
    "return the method, which would be executed if aSelector was sent to
     an instance of the receiver. I.e. the selector arrays of the receiver
     and all of its superclasses are searched for aSelector.
     Return the method, or nil if instances do not understand aSelector.
     EXPERIMENTAL: take care of multiple superclasses."

    |l m cls|

    "JV @ 2010-08-22: Rewritten to respect lookup object."
    (l := self lookupObject) notNil ifTrue:[
	^ (l
	    lookupMethodForSelector:aSelector
	    directedTo:self
	    for: nil "Fake receiver"
	    withArguments: nil "Fake arguments"
	    from: thisContext methodHome sender
	    ilc: nil "fake ilc")
    ].

    cls := self.
    [
	m := cls compiledMethodAt:aSelector.
	m notNil ifTrue:[^ m].
	cls hasMultipleSuperclasses ifTrue:[
	    cls superclasses do:[:aSuperClass |
		m := aSuperClass lookupMethodFor:aSelector.
		m notNil ifTrue:[^ m].
	    ].
	    ^ nil
	] ifFalse:[
	    cls := cls superclass
	]
    ] doWhile:[cls notNil].
    ^ nil
!

responseTo:aSelector
    "return the method (from here or the inheritance chain),
     which implements aSelector; return nil if none."

    |cls|

    cls := self whichClassIncludesSelector:aSelector.
    cls notNil ifTrue:[
	^ cls compiledMethodAt:aSelector
    ].
    ^ nil

    "
     String responseTo:#==
     String responseTo:#collect:
     String responseTo:#,
    "
!

selectorAtMethod:aMethod
    "Return the selector for given method aMethod."

    ^ self selectorAtMethod:aMethod ifAbsent:[nil]

    "
     |m|

     m := Object compiledMethodAt:#copy.
     Fraction selectorAtMethod:m.
    "
    "
     |m|

     m := Object compiledMethodAt:#copy.
     Object selectorAtMethod:m.
    "
!

selectorAtMethod:aMethod ifAbsent:failBlock
    "return the selector for given method aMethod
     or the value of failBlock, if not found."

    |md|

    md := self methodDictionary.
    md isNil ifTrue:[
	'OOPS - nil methodDictionary' errorPrintCR.
	^ failBlock value.
    ].
    ^ md keyAtValue:aMethod ifAbsent:failBlock.

    "
     |m|

     m := Object compiledMethodAt:#copy.
     Object selectorAtMethod:m ifAbsent:['oops'].
    "
    "
     |m|

     m := Object compiledMethodAt:#copy.
     Fraction selectorAtMethod:m ifAbsent:['oops'].
    "

    "Modified: 7.6.1996 / 15:15:45 / stefan"
!

whichClassImplements:aSelector
    "obsolete interface;
     use whichClassIncludesSelector: for ST-80 compatibility."

    <resource:#obsolete>

    ^ self whichClassIncludesSelector:aSelector
!

whichClassIncludesSelector:aSelector
    "return the class in the inheritance chain, which implements the method
     for aSelector; return nil if none.
     EXPERIMENTAL: handle multiple superclasses"

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
	(cls includesSelector:aSelector) ifTrue:[^ cls].
	cls hasMultipleSuperclasses ifTrue:[
	    cls superclasses do:[:aSuperClass |
		|implementingClass|

		implementingClass := aSuperClass whichClassIncludesSelector:aSelector.
		implementingClass notNil ifTrue:[^ implementingClass].
	    ].
	    ^ nil
	] ifFalse:[
	    cls := cls superclass
	]
    ].
    ^ nil

    "
     String whichClassIncludesSelector:#==
     String whichClassIncludesSelector:#collect:
    "
! !

!Behavior methodsFor:'queries-variables'!

allClassVarNames
    "return a collection of all the class variable name-strings
     this includes all superclass-class variables"

    ^ self addAllClassVarNamesTo:(OrderedCollection new)

    "
     Float allClassVarNames
    "

    "Modified: 16.4.1996 / 18:01:00 / cg"
!

allInstVarNames
    "return a collection of all the instance variable name-strings
     this includes all superclass-instance variables.
     Instvars of superclasses come first (i.e. the position matches
     the instVarAt:-index)."

    self superclass isNil ifTrue:[^ self instVarNames].
    ^ self addAllInstVarNamesTo:(OrderedCollection new)

    "
     Dictionary instVarNames
     Dictionary allInstVarNames
    "

    "Modified: 16.4.1996 / 18:03:55 / cg"
!

allInstanceVariableNames
    "alias for allInstVarNames"

    ^ self allInstVarNames
!

classVarNames
    "return a collection of the class variable name-strings.
     Returning empty here, since Behavior does not define any classVariables.
     (only Classes do). This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well.
     Traditionally, this was called classVarNames, but newer versions of squeak
     seem to have changed to use classVariableNames.
     So you probably should use the alias"

    ^ #()

    "Created: 16.4.1996 / 17:57:31 / cg"
!

classVariableNames
    "alias for classVarNames.
     Traditionally, this was called classVarNames, but newer versions of squeak
     seem to have changed to use classVariableNames.
     So you probably should use this alias"

    ^ self classVarNames

    "
     Infinity classVariableNames
    "
!

classVariableString
    "return a string of the class variables names.
     Returning empty here, since Behavior does not define any classVariables.
     (only Classes do). This allows different Behavior-like objects
     (alien classes) to be handled by the browser as well."

    ^ ''

    "Created: 16.4.1996 / 16:28:56 / cg"
!

instVarNameForIndex:index
    "Behavior does not provide this info - generate synthetic names."

    ^ '* instVar' , index printString , ' *'

    "Created: / 17-07-2006 / 00:28:24 / cg"
!

instVarNames
    "return a collection of the instance variable name-strings.
     Behavior does not provide this info - generate synthetic names.
     Traditionally, this was called instVarNames, but newer versions of squeak
     seem to have changed to use instanceVariableNames.
     So you probably should use the alias"

    |superclass superInsts|

    superclass := self superclass.
    superclass isNil ifTrue:[
	superInsts := 0
    ] ifFalse:[
	superInsts := superclass instSize
    ].
    ^ (superInsts+1 to:self instSize)
	collect:[:index | self instVarNameForIndex:index]

    "Modified: / 17-07-2006 / 00:28:40 / cg"
!

instanceVariableNames
    "alias for instVarNames.
     Traditionally, this was called instVarNames, but newer versions of squeak
     seem to have changed to use instanceVariableNames.
     So you probably should use this alias"

    ^ self instVarNames

    "
     Point instanceVariableNames
    "
!

instanceVariableString
    "return a string with dummy names here - typically, your
     objects are instances of Class, not Behavior,
     so this is only invoked for very artificial behaviors."

    |superclass s superInsts first n "{Class: SmallInteger }"|

    superclass := self superclass.
    s := ''.
    superclass isNil ifTrue:[
	superInsts := 0
    ] ifFalse:[
	superInsts := superclass instSize
    ].
    n := self instSize.
    first := true.
    superInsts+1 to:n do:[:i |
	first ifFalse:[s := s , ' '] ifTrue:[first := false].

	s := s , 'instvar' , i printString
    ].
    ^ s

    "
     Behavior new instanceVariableString
     (Behavior new instSize:2) instanceVariableString
    "

    "Modified: 7.5.1996 / 12:50:25 / cg"
    "Modified: 3.6.1996 / 16:03:33 / stefan"
!

whichClassDefinesClassVar:aStringOrText
    "Behavior does not support classVariables"

    ^ nil

    "
     TextView whichClassDefinesClassVar:'CachedScales'
     TextView whichClassDefinesClassVar:'xxx'
    "
!

whichClassDefinesInstVar: aString
    ^ self whichClassSatisfies: [:aClass | aClass instVarNames includes: aString]
!

whichSelectorsAssign: instVarName
    "Answer a set of selectors whose methods write the argument, instVarName,
    as a named instance variable."

    ^ self whichSelectorsWrite: instVarName

    "Modified (comment): / 16-11-2016 / 20:16:53 / cg"
!

whichSelectorsRead: instVarName
    "Answer a set of selectors whose methods read the argument, instVarName,
    as a named instance variable."

"/        | instVarIndex methodDict|
"/        instVarIndex := self allInstVarNames indexOf: instVarName ifAbsent: [^Set new].
"/        methodDict := self methodDictionary.
"/        ^methodDict keys select: [:sel | (methodDict at: sel)
"/                        readsField: instVarIndex]

    | methodDict |

    methodDict := self methodDictionary.
    ^ methodDict keys select: [:sel | (methodDict at: sel) readsInstVar: instVarName]

    "Modified: / 23-07-2012 / 11:22:04 / cg"
    "Modified (comment): / 16-11-2016 / 20:16:45 / cg"
!

whichSelectorsReferTo:someLiteralConstant
    "return a collection of selectors of methods which refer to the argument.
     Search the literal arrays of my methods to do this."

    |setOfSelectors|

    self methodDictionary keysAndValuesDo:[:sel :mthd |
	(mthd referencesLiteral:someLiteralConstant) ifTrue:[
	    setOfSelectors isNil ifTrue:[
		setOfSelectors := IdentitySet new.
	    ].
	    setOfSelectors add:sel
	].
    ].
    ^ setOfSelectors ? #()

    "
     String whichSelectorsReferTo:#at:
     String whichSelectorsReferTo:CharacterArray
    "

    "Modified: / 28.10.1997 / 13:13:18 / cg"
!

whichSelectorsReferToClassVariable:nameOfClassVariable
    "return a collection of selectors of methods which refer to the argument.
     Search the literal arrays of my methods to do this."

    ^ self whichSelectorsReferToGlobal:(self theNonMetaclass globalKeyForClassVar:nameOfClassVariable)

    "
     Object whichSelectorsReferToClassVariable:#Dependencies
    "

    "Modified: / 18-11-2006 / 17:14:08 / cg"
!

whichSelectorsReferToGlobal:nameOfGlobal
    "return a collection of selectors of methods which refer to the argument.
     Search the literal arrays of my methods to do this."

    |internalNameOfVar|

    internalNameOfVar := nameOfGlobal asSymbol.
    ^ self whichSelectorsReferTo:internalNameOfVar

    "
     Object whichSelectorsReferToGlobal:#Debugger
    "

    "Modified: / 4.2.2000 / 00:41:10 / cg"
!

whichSelectorsWrite: instVarName
    "Answer a set of selectors whose methods write the argument, instVarName,
    as a named instance variable."

"/        | instVarIndex methodDict |
"/        instVarIndex := self allInstVarNames indexOf: instVarName ifAbsent: [^Set new].
"/        methodDict := self methodDictionary.
"/        ^methodDict keys select: [:sel | (methodDict at: sel)
"/                        writesField: instVarIndex]
    | methodDict |

    methodDict := self methodDictionary.
    ^ methodDict keys select: [:sel | (methodDict at: sel) writesInstVar: instVarName]

    "Modified: / 23-07-2012 / 11:21:17 / cg"
    "Modified (format): / 16-11-2016 / 20:17:17 / cg"
! !

!Behavior methodsFor:'snapshots'!

postSnapshot
    "sent by ObjectMemory to all classes, after a snapshot has been written.
     Nothing done here. This can be redefined in classes which like to know
     about snapshooting."

    "Modified: 16.4.1996 / 18:12:08 / cg"
!

preSnapshot
    "sent by ObjectMemory to all classes, before a snapshot is written.
     Nothing done here. This can be redefined in classes which like to know
     about snapshooting."

    "Modified: 16.4.1996 / 18:12:14 / cg"
! !

!Behavior methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceBehavior:self level:level from:referrer


! !

!Behavior methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitBehavior:with: to aVisitor"

    ^ aVisitor visitBehavior:self with:aParameter
! !

!Behavior class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

