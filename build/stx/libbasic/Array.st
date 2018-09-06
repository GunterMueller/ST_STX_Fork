"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

ArrayedCollection variableSubclass:#Array
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!Array class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    Instances of Array store general objects;
    an array's size is fixed, therefore add:/remove: are not allowed.
    (actually, #add: is implemented for compatibility with smalltalks which
     provide it, but it is very slow and outputs an annoying warning message...)

    Access to the individual elements is via an integer index,
    using the well-known access messages #at: and #at:put:.

    Since Arrays are used very often in the system (either directly or a data-container
    of more complex collection classes), some methods have been tuned by reimplementing
    them as primitives. Also, the compiler inline-codes some operations
    (especially: the above accessing messages).

    Notice that Array is a built-in class
    (i.e. the VM knows about its representation).
    Therefore it is NOT possible to add named instance variables or change Arrays inheritance.
    However, subclassing is allowed of course
    - even with added named instance variables.

    Literal arrays (i.e. array-constants) are entered in source as:

	#( element1 element2 ... element-N)

    where each element must be itself a literal constant.
    Array, symbol and byteArray constants within an array can be written
    without the initial #-character.
    In addition, true, false and nil are also allowed as array-literal.

    Examples:
      #(1 2 3)                -> 3 elements: 1, 2 and 3
      #('foo' 2 (1 2))        -> 3 elements: a String, 2 and anotherArray
      #('foo' #(1 2) #foo)    -> 3 elements: a String, another array and a symbol
      #('foo' (1 2) foo)      -> same as above
      #(nil true #true)       -> 3 elements: nil, true and a symbol (watch out)
      #(two [3 3 3] (4 4 4))  -> 3 elements: a symbol, a byteArray and another array

    Also, a syntactic sugar piece allows for Array instances to be created dynamcially
    at runtime with the brace syntax:

	{ expr1 . expr2 . ... . expr-N }

    where each expr-i evaluates to an element of the new array instance.
    Notice that the expressions are separated by a period.
    Semantically, this is equivalent to ``Array with:expr1 with:expr2 ... with:expr-N''
    Examples:
	{ 1 . 2 . 3 }         -> a new 3 element array; similar to #( 1 2 3 ),
				 but in contrast, a new array instance is created
	{
	    { 'foo' . [ Transcript showCR:'foo' ] } .
	    { 'bar' . [ Transcript showCR:'bar' ] }
	    { 'baz' . [ Transcript showCR:'baz' ] }
	}
			      -> a new 3 element array, consisting of 3 new
				 2-element array instances, consisting of a string
				 and a block each

    [memory requirements:]
	OBJ-HEADER + (size * ptr-size)

    [warning:]
	read the warning about 'growing fixed size collection'
	in ArrayedCollection's documentation

    [author:]
	Claus Gittinger

    [see also:]
	OrderedCollection
	ByteArray FloatArray DoubleArray IntegerArray BitArray
	CharacterArray String
"
! !

!Array class methodsFor:'instance creation'!

basicNew:anInteger
    "return an instance of myself with anInteger indexed variables.
     Since Array-creation is so common (all other collections use them),
     it seems worth to have a specially tuned version here."

%{  /* NOCONTEXT */

    OBJ newobj;
    unsigned INT nInstVars;
    unsigned INT instsize;
    INT nindexedinstvars;
    REGISTER OBJ *op;

    if (__isSmallInteger(anInteger)) {
	nindexedinstvars = __intVal(anInteger);
	if (nindexedinstvars >= 0) {
	    nInstVars = __intVal(__ClassInstPtr(self)->c_ninstvars);

	    nInstVars += nindexedinstvars;
	    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
	    if (__CanDoQuickNew(instsize)) {     /* OBJECT ALLOCATION */
		/*
		 * the most common case
		 */
		__qCheckedNew(newobj, instsize);
	ok: ;
		__InstPtr(newobj)->o_class = self;
		__qSTORE(newobj, self);

#if (POINTER_SIZE == 4) && defined(memset4) && defined(FAST_ARRAY_MEMSET4)
		memset4(__InstPtr(newobj)->i_instvars, nil, nInstVars);
#else
# if !defined(NEGATIVE_ADDRESSES)
		/*
		 * knowing that nil is 0
		 */
#  ifdef __sparc__
#   define FAST_ARRAY_MEMSET_DOUBLES_UNROLLED
#  endif

#  ifdef __VMS__
#   define FAST_ARRAY_MEMSET_LONGLONG_UNROLLED
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
		while (nInstVars) {
		    *op++ = 0;
		    nInstVars--;
		}
#  else
#   if (POINTER_SIZE == 4) && defined(FAST_ARRAY_MEMSET_LONGLONG_UNROLLED)
#    ifdef INT64
#     define LONGLONG INT64
#    else
#     define LONGLONG long long
#    endif

		op = __InstPtr(newobj)->i_instvars;
		if (nInstVars > 8) {
		    *op++ = nil;    /* for alignment */
		    nInstVars--;
		    while (nInstVars >= 8) {
			*(LONGLONG *)op = 0;
			((LONGLONG *)op)[1] = 0;
			((LONGLONG *)op)[2] = 0;
			((LONGLONG *)op)[3] = 0;
			op += 8;
			nInstVars -= 8;
		    }
		}
		while (nInstVars) {
		    *op++ = 0;
		    nInstVars--;
		}
#   else
#    if defined(FAST_ARRAY_MEMSET)
		memset(__InstPtr(newobj)->i_instvars, 0, instsize - OHDR_SIZE);
#    else
		op = __InstPtr(newobj)->i_instvars;
#     if (POINTER_SIZE == 4) && defined(INT64)
		while (nInstVars > 1) {
		    *((INT64 *)op) = 0;
		    nInstVars -= 2;
		    op += 2;
		}
#     endif
		while (nInstVars >= 8) {
		    nInstVars -= 8;
		    op[0] = nil; op[1] = nil;
		    op[2] = nil; op[3] = nil;
		    op[4] = nil; op[5] = nil;
		    op[6] = nil; op[7] = nil;
		    op += 8;
		}
		while (nInstVars--)
		    *op++ = nil;
#    endif
#   endif
#  endif
# else
		op = __InstPtr(newobj)->i_instvars;
		while (nInstVars--)
		    *op++ = nil;
# endif
#endif
		RETURN ( newobj );
	    } else {
		/*
		 * a GC will happen ...
		 * have to protect all context stuff
		 * (especially for self, but also for backtrace in case of
		 *  allocation failure)
		 */
		__PROTECT_CONTEXT__
		newobj = __STX___new((INT)instsize);
		__UNPROTECT_CONTEXT__
		if (newobj != nil) {
		    goto ok;
		}
	    }
	}
    }
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
	self error:'argument to new: must be Integer'.
	^ nil
    ].
    (anInteger < 0) ifTrue:[
	"
	 the argument is negative,
	"
	self error:'bad (negative) argument to new:'.
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

new:anInteger
    "return an instance of myself with anInteger indexed variables.
     Redefined here to save a few cycles when executed.
     (Since this is often called, its worth giving it an extra ilc-slot.
      Future versions of stc will do this automatically.)"

    ^ self basicNew:anInteger

    "Modified: 23.4.1996 / 15:52:15 / cg"
! !

!Array class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Array

    "Modified: 23.4.1996 / 15:55:06 / cg"
! !

!Array methodsFor:'accessing'!

at:index
    "return the indexed instance variable with index, anInteger.
     Reimplemented here to avoid the additional at:->basicAt: send
     (which we can do here, since when arriving here, #at: is obviously not
      redefined in a subclass).
     This method is the same as basicAt:."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	return context._RETURN( self.basicAt(index.intValue() ));
    }
#else
    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER unsigned INT nIndex;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;
	cls = __qClass(slf);
	cls = __qClass(slf);
	nIndex = __BYTES2OBJS__(__qSize(slf) - OHDR_SIZE);
	if (cls == Array) {
	    fetch:
	    if ((unsigned INT)indx < (unsigned INT)nIndex) {
		RETURN ( __InstPtr(slf)->i_instvars[indx] );
	    }
	    goto badIndex;
	}
	if (indx >= 0) {
	    indx += __intVal(__ClassInstPtr(cls)->c_ninstvars);
	    goto fetch;
	}
    }
badIndex: ;
#endif /* not SCHTEAM */
%}.
"/    ^ super at:index
    ^ super basicAt:index   "/ knowing that super-#at: does #basicAt:
!

at:index put:anObject
    "store the 2nd arg, anObject as indexed instvar with index, anInteger.
     Returns anObject (sigh).
     Reimplemented here to avoid the additional at:put:->basicAt:put: send
     (which we can do here, since when arriving here, #atput:: is obviously not
      redefined in a subclass).
     This method is the same as basicAt:put:."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	self.basicAt_put(index.intValue(), anObject);
	return context._RETURN( anObject );
    }
#else

    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER unsigned INT nIndex;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;
        cls = __qClass(slf);
	cls = __qClass(slf);
	nIndex = __BYTES2OBJS__(__qSize(slf) - OHDR_SIZE);
	if (cls == Array) {
	    store:
	    if ((unsigned INT)indx < (unsigned INT)nIndex) {
		__InstPtr(slf)->i_instvars[indx] = anObject;
		__STORE(slf, anObject);
		RETURN ( anObject );
	    }
	    goto badIndex;
	}
	if (indx >= 0) {
	    indx += __intVal(__ClassInstPtr(cls)->c_ninstvars);
	    goto store;
	}
    }
badIndex: ;
#endif /* not SCHTEAM */
%}.
"/    ^ super at:index put:anObject
    ^ super basicAt:index put:anObject  "/ knowing that super-#at:put: does #basicAt:put:

    "Modified: 19.4.1996 / 11:16:42 / cg"
!

basicAt:index
    "return the indexed instance variable with index, anInteger
     - added here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	return context._RETURN( self.basicAt(index.intValue() ));
    }
#else

    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER unsigned INT nIndex;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;

	nIndex = __BYTES2OBJS__(__qSize(slf) - OHDR_SIZE);
	if ((cls = __qClass(slf)) != Array) {
	    if (indx < 0) goto badIndex;
	    indx += __intVal(__ClassInstPtr(cls)->c_ninstvars);
	}
	if ((unsigned INT)indx < (unsigned INT)nIndex) {
	    RETURN ( __InstPtr(slf)->i_instvars[indx] );
	}
    }
badIndex: ;
#endif /* not SCHTEAM */
%}.
    ^ super basicAt:index
!

basicAt:index put:anObject
    "store the 2nd arg, anObject as indexed instvar with index, anInteger.
     Returns anObject (sigh).
     - added here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	self.basicAt_put(index.intValue(), anObject);
	return context._RETURN( anObject );
    }
#else
    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER unsigned INT nIndex;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;

	nIndex = __BYTES2OBJS__(__qSize(slf) - OHDR_SIZE);
	if ((cls = __qClass(slf)) != Array) {
	    if (indx < 0) goto badIndex;
	    indx += __intVal(__ClassInstPtr(cls)->c_ninstvars);
	}
	if ((unsigned INT)indx < (unsigned INT)nIndex) {
	    __InstPtr(slf)->i_instvars[indx] = anObject;
	    __STORE(slf, anObject);
	    RETURN ( anObject );
	}
    }
badIndex: ;
#endif /* not SCHTEAM */
%}.
    ^ super basicAt:index put:anObject

    "Modified: 19.4.1996 / 11:14:26 / cg"
! !

!Array methodsFor:'converting'!

asArray
    "return the receiver as an array - that's the receiver itself.
     Notice: Use asNewArray, if you intent to modify the returned collection."

    "could be an instance of a subclass..."
    self class == Array ifTrue:[
	^ self
    ].
    ^ super asArray

    "Modified: 22.4.1996 / 12:42:09 / cg"
!

asImmutableArray
    "return a write-protected copy of myself"

    "/ self assert:(ImmutableArray notNil).
    ^ self copy beImmutable

    "Modified: / 07-06-2012 / 11:06:48 / cg"
!

asNewArray
    "return the receiver as an unique new array."

    "could be an instance of a subclass..."
    self class == Array ifTrue:[
	^ self copy
    ].
    ^ super asArray
!

beImmutable
    "make myself write-protected"

    super beImmutable.
    self changeClassTo:ImmutableArray

    "Created: / 07-06-2012 / 11:06:33 / cg"
! !

!Array methodsFor:'copying'!

, aCollection
%{
    if (__isArray(aCollection)) {
	if (__isArray(self)) {
	    OBJ newArray;
	    int mySize = __arraySize(self);
	    int otherSize = __arraySize(aCollection);
	    REGISTER OBJ src;
	    int srcIdx, dstIdx;
	    newArray = __ARRAY_NEW_INT(mySize+otherSize);

	    src = self;
	    for (dstIdx=0; dstIdx<mySize; dstIdx++) {
		OBJ el = __ArrayInstPtr(src)->a_element[dstIdx];

		__ArrayInstPtr(newArray)->a_element[dstIdx] = el;
		__STORE(newArray, el);
	    }

	    src = aCollection;
	    for (srcIdx=0; srcIdx<otherSize; srcIdx++, dstIdx++) {
		OBJ el = __ArrayInstPtr(src)->a_element[srcIdx];

		__ArrayInstPtr(newArray)->a_element[dstIdx] = el;
		__STORE(newArray, el);
	    }
	    RETURN (newArray);
	}
    }
%}.
    ^ super , aCollection
!

copyWith:something
    "return a new collection containing the receiver's elements
     and the single new element, newElement.
     This is different from concatentation, which expects another collection
     as argument, but equivalent to copy-and-addLast.
     Reimplemented for speed if receiver is an Array.
     (since the inherited copyWith uses replaceFromTo:, which is also
      tuned, it is questionable, if we need this)"

%{  /* NOCONTEXT */
    OBJ nObj;
    unsigned INT sz;
    unsigned INT nIndex;
    REGISTER OBJ *srcP, *dstP;
    REGISTER int spc;

    if (__qClass(self) == Array) {
	sz = __qSize(self) + sizeof(OBJ);
	__PROTECT2__(something, self);
	__qNew(nObj, sz);        /* OBJECT ALLOCATION */
	__UNPROTECT2__(self, something);

	if (nObj) {
	    __InstPtr(nObj)->o_class = Array;
	    __qSTORE(nObj, Array);

	    nIndex = __BYTES2OBJS__(sz - OHDR_SIZE - sizeof(OBJ));
	    /*
	     * sorry:
	     *   cannot use bcopy, since we must take care of stores ...
	     *   could check for: notRemembered + inOld + notLifoRem
	     *                  + not incrGCRunning
	     * but: copyWith is not heavily used by real programmers ...
	     */
	    spc = __qSpace(nObj);
	    srcP = __arrayVal(self);
	    dstP = __arrayVal(nObj);

#ifdef __UNROLL_LOOPS__
	    while (nIndex >= 4) {
		OBJ element;

		element = srcP[0];
		dstP[0] = element;
		__STORE_SPC(nObj, element, spc);
		element = srcP[1];
		dstP[1] = element;
		__STORE_SPC(nObj, element, spc);
		element = srcP[2];
		dstP[2] = element;
		__STORE_SPC(nObj, element, spc);
		element = srcP[3];
		dstP[3] = element;
		__STORE_SPC(nObj, element, spc);
		srcP += 4;
		dstP += 4;
		nIndex -= 4;
	    }
#endif
	    while (nIndex--) {
		OBJ element;

		element = *srcP++;
		*dstP++ = element;
		__STORE_SPC(nObj, element, spc);
	    }
	    *dstP = something;
	    __STORE_SPC(nObj, something, spc);
	    RETURN ( nObj );
	}
    }
%}.
    ^ super copyWith:something
! !

!Array methodsFor:'enumerating'!

addAllNonNilElementsTo:aCollection
    "add all nonNil elements of the receiver to aCollection.
     Return aCollection.
     Redefined here for slightly more speed."

    |each stop "{ Class: SmallInteger }"|

    stop := self size.
    1 to:stop do:[:idx |
	each := self at:idx.
	each notNil ifTrue:[
	    aCollection add:each.
	].
    ].
    ^ aCollection

    "
     #(1 2 3 4 5 1 2 3 symbol 'string' nil) addAllNonNilElementsTo:Set new
    "
!

addAllTo:aCollection
    "add all elements of the receiver to aCollection.
     Return aCollection.
     Redefined here for slightly more speed."

    |stop "{ Class: SmallInteger }"|

    stop := self size.
    1 to:stop do:[:idx |
	aCollection add:(self at:idx)
    ].
    ^ aCollection
!

do:aBlock
    "evaluate the argument, aBlock for each element in the collection.
     - reimplemented for speed, since this is used by many higher
       level collections"

    | sz "{ Class: SmallInteger }"|

    sz := self size.
%{
    REGISTER OBJFUNC codeVal;
    REGISTER INT index;
    unsigned INT nIndex;
    static struct inlineCache val = _ILC1;
    REGISTER OBJ rHome;
    INT actualSize;

    {
	OBJ mySelf = self;

	index = __intVal(__ClassInstPtr(__qClass(mySelf))->c_ninstvars);
	actualSize = __BYTES2OBJS__(__qSize(mySelf) - OHDR_SIZE);
    }

    nIndex = index + __intVal(sz);
    if (nIndex <= actualSize) {

	if (__isBlockLike(aBlock)
	 && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
	    {
		/*
		 * the most common case: a static compiled block, with home on the stack ...
		 */
		REGISTER OBJFUNC codeVal;

		if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
#ifdef PARANOIA
		 && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
#endif
		) {

#                   define BLOCK_ARG        aBlock
		    {

			    /*
			     * boy; what an ugly looking piece of code ...
			     * however, this software pipelined thing has no taken conditional
			     * branches in the normal case and is almost twice as fast to even
			     * what an unrolling optimizing compiler produces from the loop below ...
			     * notice, that those gotos expand to forward branches (which are predicted
			     * as NOT taken by most machines ... which is exactly what we want)
			     */
			    REGISTER OBJ el;
#ifdef __UNROLL_LOOPS__

			    {
				int i8;

				while ((i8 = index+8) < nIndex) {
				    el = __InstPtr(self)->i_instvars[index];
				    if (InterruptPending != nil) goto interrupt0;
		continue0:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+1];
				    if (InterruptPending != nil) goto interrupt1;
		continue1:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+2];
				    if (InterruptPending != nil) goto interrupt2;
		continue2:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+3];
				    if (InterruptPending != nil) goto interrupt3;
		continue3:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+4];
				    if (InterruptPending != nil) goto interrupt4;
		continue4:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+5];
				    if (InterruptPending != nil) goto interrupt5;
		continue5:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+6];
				    if (InterruptPending != nil) goto interrupt6;
		continue6:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+7];
				    if (InterruptPending != nil) goto interrupt7;
		continue7:
				    (*codeVal)(BLOCK_ARG, el);
				    index = i8;
				}
			    }
#endif /* __UNROLL_LOOPS__ */

			    for (; index < nIndex; index++) {
				el = __InstPtr(self)->i_instvars[index];
				if (InterruptPending != nil) goto interruptX;
		continueX:
				(*codeVal)(BLOCK_ARG, el);
			    }
			    RETURN (self);

#ifdef __UNROLL_LOOPS__
		interrupt0:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index];
			    goto continue0;
		interrupt1:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+1];
			    goto continue1;
		interrupt2:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+2];
			    goto continue2;
		interrupt3:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+3];
			    goto continue3;
		interrupt4:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+4];
			    goto continue4;
		interrupt5:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+5];
			    goto continue5;
		interrupt6:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+6];
			    goto continue6;
		interrupt7:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index+7];
			    goto continue7;
#endif /* __UNROLL_LOOPS__ */
		interruptX:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index];
			    goto continueX;
		    }
		}
	    }

	    /*
	     * sorry, must check code-pointer in the loop
	     * it could be recompiled or flushed
	     */
#           undef BLOCK_ARG
#           define BLOCK_ARG        aBlock
#           define IBLOCK_ARG       nil
	    for (; index < nIndex; index++) {
		REGISTER OBJFUNC codeVal;

		if (InterruptPending != nil) __interruptL(@line);

		if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
		    (*codeVal)(BLOCK_ARG, __InstPtr(self)->i_instvars[index]);
		} else {
		    if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
			/*
			 * arg is a compiled block with bytecode -
			 * directly call interpreter without going through Block>>value
			 */
#ifdef PASS_ARG_POINTER
			__interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &(__InstPtr(self)->i_instvars[index]));
#else
			__interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __InstPtr(self)->i_instvars[index]);
#endif
		    } else {
			(*val.ilc_func)(aBlock,
					    @symbol(value:),
					    nil, &val,
					    __InstPtr(self)->i_instvars[index]);
		    }
		}
	    }

#           undef BLOCK_ARG
#           undef IBLOCK_ARG

	    RETURN (self );
	}

	/*
	 * not a block - send it #value:
	 */
	for (; index < nIndex; index++) {
	    if (InterruptPending != nil) __interruptL(@line);
	    // console_printf("el%d -> %"_lx_"\n", index, (long)(__InstPtr(self)->i_instvars[index]));
	    (*val.ilc_func)(aBlock,
				@symbol(value:),
				nil, &val,
				__InstPtr(self)->i_instvars[index]);
	}
	RETURN ( self );
    }
    /*
     * I am something, not handled here
     */
%}.
    ^ super do:aBlock
!

from:start to:stop do:aBlock
    "evaluate the argument, aBlock for the elements starting at index start
     up to (and including) stop in the collection.
     - reimplemented for speed, since this is used by many higher
       level collections"

%{
    REGISTER OBJFUNC codeVal;
    REGISTER INT index;
    REGISTER OBJ rHome;
    OBJ slf;
    INT nIndex, nInsts;
    static struct inlineCache val = _ILC1;
    INT indexHigh;
    OBJ myClass;

    slf = self;
    myClass = __qClass(slf);

    if ( __bothSmallInteger(start, stop)
     && ((index = __intVal(start)) > 0) ) {
	indexHigh = __intVal(stop);
	nIndex = __BYTES2OBJS__(__qSize(slf) - OHDR_SIZE);
	if (myClass != @global(Array)) {
	    nInsts = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
	    index += nInsts;
	    indexHigh += nInsts;
	}
	if (indexHigh <= nIndex) {
	    OBJ __aBlock = aBlock;
	    INT n;

	    index--;                            /* 0-based */
	    n = indexHigh - index;

	    if (__isBlockLike(__aBlock)
	     && (__BlockInstPtr(__aBlock)->b_nargs == __mkSmallInteger(1))) {
		{
		    /*
		     * the most common case: a static compiled block, with home on the stack ...
		     */
		    REGISTER OBJFUNC codeVal;

		    if (((codeVal = __BlockInstPtr(__aBlock)->b_code) != (OBJFUNC)nil)
#ifdef PARANOIA
		     && (! ((INT)(__BlockInstPtr(__aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
#endif
		    ) {
#                       define BLOCK_ARG        aBlock
			{
			    REGISTER OBJ el;

#ifdef __UNROLL_LOOPS__
			    /*
			     * boy; what an ugly looking piece of code ...
			     * however, this software pipelined thing has no taken conditional
			     * branches in the normal case and is almost twice as fast to even
			     * what an unrolling optimizing compiler produces from the loop below ...
			     * notice, that those gotos expand to forward branches (which are predicted
			     * as NOT taken by most machines ... which is exactly what we want)
			     */
			    {
				while ( n >= 8) {
				    el = __InstPtr(self)->i_instvars[index];
				    if (InterruptPending != nil) goto interrupt0;
		continue0:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+1];
				    if (InterruptPending != nil) goto interrupt1;
		continue1:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+2];
				    if (InterruptPending != nil) goto interrupt2;
		continue2:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+3];
				    if (InterruptPending != nil) goto interrupt3;
		continue3:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+4];
				    if (InterruptPending != nil) goto interrupt4;
		continue4:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+5];
				    if (InterruptPending != nil) goto interrupt5;
		continue5:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+6];
				    if (InterruptPending != nil) goto interrupt6;
		continue6:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+7];
				    if (InterruptPending != nil) goto interrupt7;
		continue7:
				    (*codeVal)(BLOCK_ARG, el);
				    n -= 8;
				    index += 8;
				}
# ifdef __UNROLL_LOOPS2__ /* this makes small loops slower */
				if (n >= 4) {
				    el = __InstPtr(self)->i_instvars[index];
				    if (InterruptPending != nil) goto interrupt0b;
		continue0b:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+1];
				    if (InterruptPending != nil) goto interrupt1b;
		continue1b:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+2];
				    if (InterruptPending != nil) goto interrupt2b;
		continue2b:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+3];
				    if (InterruptPending != nil) goto interrupt3b;
		continue3b:
				    (*codeVal)(BLOCK_ARG, el);
				    n -= 4;
				    index += 4;
				}
				if (n >= 2) {
				    el = __InstPtr(self)->i_instvars[index];
				    if (InterruptPending != nil) goto interrupt0c;
		continue0c:
				    (*codeVal)(BLOCK_ARG, el);
				    el = __InstPtr(self)->i_instvars[index+1];
				    if (InterruptPending != nil) goto interrupt1c;
		continue1c:
				    (*codeVal)(BLOCK_ARG, el);
				    n -= 2;
				    index += 2;
				}
# endif /* __UNROLL_LOOPS2__ */
			    }
#endif /* __UNROLL_LOOPS__ */
			    while (n > 0) {
				el = __InstPtr(self)->i_instvars[index];
				if (InterruptPending != nil) goto interruptX;
		continueX:
				(*codeVal)(BLOCK_ARG, el);
				n--;
				index++;
			    }
			    RETURN (self);

#ifdef __UNROLL_LOOPS__
		interrupt0:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index];
			    goto continue0;
		interrupt1:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+1];
			    goto continue1;
		interrupt2:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+2];
			    goto continue2;
		interrupt3:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+3];
			    goto continue3;
		interrupt4:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+4];
			    goto continue4;
		interrupt5:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+5];
			    goto continue5;
		interrupt6:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+6];
			    goto continue6;
		interrupt7:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+7];
			    goto continue7;

# ifdef __UNROLL_LOOPS2__
		interrupt0b:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index];
			    goto continue0b;
		interrupt1b:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+1];
			    goto continue1b;
		interrupt2b:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+2];
			    goto continue2b;
		interrupt3b:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+3];
			    goto continue3b;

		interrupt0c:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index];
			    goto continue0c;
		interrupt1c:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index+1];
			    goto continue1c;
# endif /* __UNROLL_LOOPS2__ */
#endif /* __UNROLL_LOOPS__ */
		interruptX:
			    __interruptL(@line); el = __InstPtr(self)->i_instvars[index];
			    goto continueX;
			}
		    }
		}

		/*
		 * sorry, must check code-pointer in the loop
		 * it could be recompiled or flushed
		 */
#               undef BLOCK_ARG
#               define BLOCK_ARG        aBlock
#               define IBLOCK_ARG       nil
		while (n > 0) {
		    REGISTER OBJFUNC codeVal;
		    OBJ el;

		    el = __InstPtr(self)->i_instvars[index];
		    if (InterruptPending != nil) {
			__interruptL(@line);
			el = __InstPtr(self)->i_instvars[index];
		    }

		    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
			(*codeVal)(BLOCK_ARG, el);
		    } else {
			if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
			    /*
			     * arg is a compiled block with bytecode -
			     * directly call interpreter without going through Block>>value
			     */
#ifdef PASS_ARG_POINTER
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &el);
#else
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, el);
#endif
			} else {
			    (*val.ilc_func)(aBlock,
					    @symbol(value:),
					    nil, &val,
					    el);
			}
		    }
		    n--;
		    index++;
		}

#               undef BLOCK_ARG
#               undef IBLOCK_ARG

		RETURN (self );
	    }

	    /*
	     * not a block - send it #value:
	     */
	    while (n > 0) {
		if (InterruptPending != nil) __interruptL(@line);

		(*val.ilc_func)(aBlock,
				@symbol(value:),
				nil, &val,
				__InstPtr(self)->i_instvars[index]);
		n--;
		index++;
	    }
	    RETURN ( self );
	}
    }
%}.
    ^ super from:start to:stop do:aBlock

!

from:start to:stop reverseDo:aBlock
    "evaluate the argument, aBlock for the elements starting at index start
     up to (and including) stop in the collection. Step in reverse order.
     - reimplemented for speed"

%{
    REGISTER OBJFUNC codeVal;
    REGISTER INT index;
    REGISTER OBJ rHome;
    INT nIndex;
    static struct inlineCache val = _ILC1;
    INT indexLow, indexHigh;

    if (__bothSmallInteger(start, stop)
     && (__qClass(self) == @global(Array))
     && ((indexLow = __intVal(start)) > 0)) {
	indexHigh = __intVal(stop);
	nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	if (indexHigh <= nIndex) {
	    indexLow--;
	    indexHigh--;

	    if (__isBlockLike(aBlock)
	     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
#               undef BLOCK_ARG
#               define BLOCK_ARG        aBlock
#               define IBLOCK_ARG       nil

		for (index=indexHigh; index >= indexLow; index--) {
		    REGISTER OBJFUNC codeVal;

		    if (InterruptPending != nil) __interruptL(@line);

		    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
			(*codeVal)(BLOCK_ARG, __InstPtr(self)->i_instvars[index]);
		    } else {
			if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
			    /*
			     * arg is a compiled block with bytecode -
			     * directly call interpreter without going through Block>>value
			     */
#ifdef PASS_ARG_POINTER
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &(__InstPtr(self)->i_instvars[index]));
#else
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __InstPtr(self)->i_instvars[index]);
#endif
			} else {
			    (*val.ilc_func)(aBlock,
					    @symbol(value:),
					    nil, &val,
					    __InstPtr(self)->i_instvars[index]);
			}
		    }
		}

#               undef BLOCK_ARG
#               undef IBLOCK_ARG

		RETURN (self );
	    }

	    /*
	     * not a block - send it #value:
	     */
	    for (index=indexHigh; index >= indexLow; index--) {
		if (InterruptPending != nil) __interruptL(@line);

		(*val.ilc_func)(aBlock,
				@symbol(value:),
				nil, &val,
				__InstPtr(self)->i_instvars[index]);
	    }
	    RETURN ( self );
	}
    }
%}.
    ^ super from:start to:stop reverseDo:aBlock
!

keysAndValuesDo:aBlock
    "evaluate the argument, aBlock for each element in the collection.
     Pass both index and element to the block.
     - reimplemented for speed"

%{
    REGISTER OBJFUNC codeVal;
    REGISTER INT index;
    static struct inlineCache val2 = _ILC2;
    REGISTER OBJ rHome;
    INT actualSize;
    OBJ myClass;

    myClass = __qClass(self);
    if ((__ClassInstPtr(myClass)->c_ninstvars) == __mkSmallInteger(0)) {

	actualSize = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	index = 0;

	if (index < actualSize) {
	    if (__isBlockLike(aBlock)
	     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(2))) {
		{
		    /*
		     * the most common case: a static compiled block, with home on the stack ...
		     */
		    REGISTER OBJFUNC codeVal;

		    if (((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil)
#ifdef PARANOIA
		     && (! ((INT)(__BlockInstPtr(aBlock)->b_flags) & __MASKSMALLINT(F_DYNAMIC)))
#endif
		    ) {

#                       define BLOCK_ARG        aBlock
			{
			    OBJ el;

			    while (index < actualSize) {

				el = __InstPtr(self)->i_instvars[index];
				if (InterruptPending != nil) goto interruptX;
		continueX:
				index++;
				(*codeVal)(BLOCK_ARG, __mkSmallInteger(index), el);
			    }
			    RETURN (self);

		interruptX:
			    __interruptL(@line);
			    el = __InstPtr(self)->i_instvars[index];
			    goto continueX;
			}
		    }
		}

		/*
		 * sorry, must check code-pointer in the loop
		 * it could be recompiled or flushed
		 */
#               undef BLOCK_ARG
#               define BLOCK_ARG        aBlock
#               define IBLOCK_ARG       nil
		while (index < actualSize) {
		    REGISTER OBJFUNC codeVal;
		    OBJ el;

		    if (InterruptPending != nil) __interruptL(@line);

		    el = __InstPtr(self)->i_instvars[index];
		    index++;
		    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
			(*codeVal)(BLOCK_ARG, __mkSmallInteger(index), el);
		    } else {
			if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
			    /*
			     * arg is a compiled block with bytecode -
			     * directly call interpreter without going through Block>>value
			     */
#ifdef PASS_ARG_POINTER
			    {
				OBJ t[2];

				t[0] = __mkSmallInteger(index);
				t[1] = el;

				__interpret(aBlock, 2, nil, IBLOCK_ARG, nil, nil, t);
			    }
#else
			    __interpret(aBlock, 2, nil, IBLOCK_ARG, nil, nil, __mkSmallInteger(index), el);
#endif
			} else {
			    (*val2.ilc_func)(aBlock,
						@symbol(value:value:),
						nil, &val2,
						__mkSmallInteger(index),
						el);
			}
		    }
		}

#               undef BLOCK_ARG
#               undef IBLOCK_ARG

		RETURN (self );
	    }

	    /*
	     * not a block - send it #value:
	     */
	    while (index < actualSize) {
		OBJ el;

		if (InterruptPending != nil) __interruptL(@line);

		el = __InstPtr(self)->i_instvars[index];
		index++;
		(*val2.ilc_func)(aBlock,
				    @symbol(value:value:),
				    nil, &val2,
				    __mkSmallInteger(index),
				    el);
	    }
	    RETURN ( self );
	}
    }
%}.
    ^ super keysAndValuesDo:aBlock
!

modifyingTraverse:aBlock
    "Evaluate aBlock for every element that is not an Array,
     and recursively traverse Arrays.

     aBlock may return the original element or a new element.
     If a new element is returned, the element is changed to the new element."

    self
	keysAndValuesDo:[:eachIndex :eachElement |
	    eachElement isArray ifTrue:[
		eachElement modifyingTraverse:aBlock
	    ] ifFalse:[
		|newElement|

		newElement := aBlock value:eachElement.
		newElement ~~ eachElement ifTrue:[
		    self at:eachIndex put:newElement.
		].
	    ]
	].

    "
     example: replace all elements which are 10 with: 'changed'

     #(1 2 (3 (4 5 (6 7) 8) 9 10) 11 (12 (13)) 14) copy
	 modifyingTraverse:[:el |
	    el = 10 ifTrue:['changed'] ifFalse:[el]
	 ];
	 inspect
    "
!

reverseDo:aBlock
    "evaluate the argument, aBlock for each element in the collection in reverse order.
     - reimplemented for speed"

    |home sz "{ Class: SmallInteger }" |

    sz := self size.
%{
    REGISTER OBJFUNC codeVal;
    REGISTER INT index;
    unsigned INT nIndex;
    INT endIndex;
    static struct inlineCache val = _ILC1;
    INT actualSize;
    OBJ myClass;

    myClass = __qClass(self);
    {
	endIndex = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
	actualSize = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	nIndex = endIndex + __intVal(sz);

	if (nIndex <= actualSize) {
	    if (__isBlockLike(aBlock)
	     && (__BlockInstPtr(aBlock)->b_nargs == __mkSmallInteger(1))) {
#               undef BLOCK_ARG
#               define BLOCK_ARG        aBlock
#               define IBLOCK_ARG       nil
		for (index=nIndex-1; index >= endIndex; index--) {
		    REGISTER OBJFUNC codeVal;

		    if (InterruptPending != nil) __interruptL(@line);

		    if ((codeVal = __BlockInstPtr(aBlock)->b_code) != (OBJFUNC)nil) {
			(*codeVal)(BLOCK_ARG, __InstPtr(self)->i_instvars[index]);
		    } else {
			if (__BlockInstPtr(aBlock)->b_bytecodes != nil) {
			    /*
			     * arg is a compiled block with bytecode -
			     * directly call interpreter without going through Block>>value
			     */
#ifdef PASS_ARG_POINTER
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, &(__InstPtr(self)->i_instvars[index]));
#else
			    __interpret(aBlock, 1, nil, IBLOCK_ARG, nil, nil, __InstPtr(self)->i_instvars[index]);
#endif
			} else {
			    (*val.ilc_func)(aBlock,
					    @symbol(value:),
					    nil, &val,
					    __InstPtr(self)->i_instvars[index]);
			}
		    }
		}

#               undef BLOCK_ARG
#               undef IBLOCK_ARG

		RETURN (self );
	    }

	    /*
	     * not a block - send it #value:
	     */
	    for (index=nIndex-1; index >= endIndex; index--) {
		if (InterruptPending != nil) __interruptL(@line);

		(*val.ilc_func)(aBlock,
				@symbol(value:),
				nil, &val,
				__InstPtr(self)->i_instvars[index]);
	    }
	    RETURN ( self );
	}
    }
%}.
    ^ super reverseDo:aBlock
!

traverse:aBlock
    "Evaluate aBlock for every element that is not an Array,
     and recursively traverse Arrays.
     Implemented here to support better search for selectors in
     literal arrays - might be a good idea to move it up in the collection
     hierarchy, since this may be a useful method for other collections
     as well."

    self do: [:el |
	el isArray
	    ifTrue: [el traverse: aBlock]
	    ifFalse: [aBlock value: el]]

    "
     example: flattening an Array:

     |s|

     s := WriteStream on:Array new.
     #(1 2 (3 (4 5 (6 7) 8) 9 10) 11 (12 (13)) 14) traverse:[:el | s nextPut:el].
     s contents
    "
    "
     example: deep search

     #(1 2 (3 (4 5 (6 7) 8) 9 10) 11 (12 (13)) 14) traverse:[:el |
	el == 10 ifTrue:[Transcript showCR:'found']
     ]
    "

    "Modified: 26.3.1996 / 17:08:10 / cg"
! !

!Array methodsFor:'filling & replacing'!

from:index1 to:index2 put:anObject
    "reimplemented for speed if receiver is an Array"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (bothSmallInteger(index1, index2)) {
	int _start = index1.intValue();
	int _stop = index2.intValue();
	self.from_to_put(_start, _stop, anObject);
	return context._RETURN(self);
    }
#else
    REGISTER INT index;
    unsigned INT nIndex;
    unsigned INT endIndex;
    REGISTER OBJ *dst;

    if ((__qClass(self) == Array)
     && __bothSmallInteger(index1, index2)) {
	index = __intVal(index1) - 1;
	if (index >= 0) {
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    endIndex = __intVal(index2) - 1;

	    if ((endIndex >= index) && (endIndex < nIndex)) {
		dst = &(__InstPtr(self)->i_instvars[index]);
# ifdef memset4
		{
		    int n4 = endIndex-index+1;

		    memset4(dst, anObject, n4);
		}
# else
#  ifdef FAST_MEMSET
		if ((INT)anObject == 0) {
		    memset(dst, 0, __OBJS2BYTES__(endIndex-index+1));
		} else
#  endif
		{
#  ifdef __UNROLL_LOOPS__
		    {
			INT i8;

			while ((i8 = index + 8) <= endIndex) {
			    dst[3] = dst[2] = dst[1] = dst[0] = anObject;
			    dst[7] = dst[6] = dst[5] = dst[4] = anObject;
			    dst += 8;
			    index = i8;
			}
		    }
#  endif
		    for (; index <= endIndex; index++) {
			*dst++ = anObject;
		    }
		}
# endif
		__STORE(self, anObject);
		RETURN ( self );
	    }
	}
    }
#endif
%}.
    ^ super from:index1 to:index2 put:anObject
!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "replace elements in the receiver between index start and stop,
     with elements taken from replacementCollection starting at repStart.
     Return the receiver.
     Reimplemented for speed if both receiver and aCollection are Arrays"

%{  /* NOCONTEXT */

    unsigned INT nIndex;
    unsigned INT repNIndex;
    INT startIndex, stopIndex;
    REGISTER OBJ *src;
    REGISTER OBJ *dst;
    INT repStopIndex;
    REGISTER INT repStartIndex;
    REGISTER OBJ t;
    REGISTER INT count;
    OBJ myClass;

    if (
	(__ClassInstPtr((myClass = __qClass(self)))->c_ninstvars == __mkSmallInteger(0))
     && __isNonNilObject(aCollection)
     && (((t = __qClass(aCollection)) == Array) || t == ImmutableArray || (t == myClass))
     && __bothSmallInteger(start, stop)
     && __isSmallInteger(repStart)
    ) {
	startIndex = __intVal(start) - 1;
	if (startIndex >= 0) {
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    stopIndex = __intVal(stop) - 1;
	    count = stopIndex - startIndex + 1;

	    if ((count > 0) && (stopIndex < nIndex)) {
		repStartIndex = __intVal(repStart) - 1;
		if (repStartIndex >= 0) {
		    repNIndex = __BYTES2OBJS__(__qSize(aCollection)-OHDR_SIZE);
		    repStopIndex = repStartIndex + (stopIndex - startIndex);
		    if (repStopIndex < repNIndex) {
			src = &(__InstPtr(aCollection)->i_instvars[repStartIndex]);
			dst = &(__InstPtr(self)->i_instvars[startIndex]);
			if (aCollection == self) {
			    /*
			     * no need to check stores if copying
			     * from myself
			     */

			    if (src < dst) {
				/*
				 * take care of overlapping copy
				 * memcpy() is not smart enough by definition for overlkapping copies
				 * memmove() is!
				 */
#if defined(FAST_MEMCPY)
				memmove(dst, src, __OBJS2BYTES__(count));
#else
				/* must do a reverse copy */
				src += count;
				dst += count;
# ifdef __UNROLL_LOOPS__
				while (count > 8) {
				    dst[-1] = src[-1];
				    dst[-2] = src[-2];
				    dst[-3] = src[-3];
				    dst[-4] = src[-4];
				    dst[-5] = src[-5];
				    dst[-6] = src[-6];
				    dst[-7] = src[-7];
				    dst[-8] = src[-8];
				    dst -= 8; src -= 8;
				    count -= 8;
				}
# endif // __UNROLL_LOOPS__
				while (count-- > 0) {
				    *--dst = *--src;
				}
#endif // ! FAST_MEMCPY
				RETURN ( self );
			    }
#ifdef SOFTWARE_PIPELINE
			    {
				/*
				 * the loop below fetches one longWord behind
				 * this should not be a problem
				 */
				OBJ t1 = src[0];
				count--;
				if (count) {
				    dst++; src++;
				    do {
					dst[-1] = t1;
					t1 = src[0];
					src++;
					dst++;
				    } while (count--);
				} else {
				    dst[0] = t1;
				}
			    }
#elif defined(bcopy4)
			    count = __OBJS2BYTES__(count) / 4;
			    bcopy4(src, dst, count);
#elif defined(FAST_MEMCPY)
			    memmove(dst, src, __OBJS2BYTES__(count));
#else
# if defined(__UNROLL_LOOPS__)
			    while (count >= 8) {
				dst[0] = src[0];
				dst[1] = src[1];
				dst[2] = src[2];
				dst[3] = src[3];
				dst[4] = src[4];
				dst[5] = src[5];
				dst[6] = src[6];
				dst[7] = src[7];
				dst += 8; src += 8;
				count -= 8;
			    }
# endif // __UNROLL_LOOPS__
			    while (count--) {
				*dst++ = *src++;
			    }
#endif
			} else {
			    // not copying into the same object
			    REGISTER int spc = __qSpace(self);
#ifdef __UNROLL_LOOPS__
			    while (count >= 8) {
				t = src[0]; dst[0] = t; __STORE_SPC(self, t, spc);
				t = src[1]; dst[1] = t; __STORE_SPC(self, t, spc);
				t = src[2]; dst[2] = t; __STORE_SPC(self, t, spc);
				t = src[3]; dst[3] = t; __STORE_SPC(self, t, spc);
				t = src[4]; dst[4] = t; __STORE_SPC(self, t, spc);
				t = src[5]; dst[5] = t; __STORE_SPC(self, t, spc);
				t = src[6]; dst[6] = t; __STORE_SPC(self, t, spc);
				t = src[7]; dst[7] = t; __STORE_SPC(self, t, spc);
				count -= 8; src += 8; dst += 8;
			    }
#endif
			    while (count-- > 0) {
				*dst++ = t = *src++;
				__STORE_SPC(self, t, spc);
			    }
			}
			RETURN ( self );
		    }
		}
	    }

	    if (count == 0) {
		RETURN ( self );
	    }
	}
    }
%}.
    ^ super replaceFrom:start to:stop with:aCollection startingAt:repStart

    "Modified: 13.4.1996 / 12:17:13 / cg"
! !

!Array methodsFor:'printing & storing'!

displayStringName
    "redefinable helper for displayString"

    |cls|

    ((cls := self class) == Array or:[cls == ImmutableArray]) ifTrue:[
	^ '#'
    ].
    ^ super displayStringName.
!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    self isLiteral ifTrue:[
	|limit firstOne s|

	thisContext isRecursive ifTrue:[
	    'Array [error]: printOn: of self referencing collection.' errorPrintCR.
	    aStream nextPutAll:'#("recursive")'.
	    ^ self
	].

	aStream nextPutAll:'#('.
	firstOne := true.

	"
	 if aStream is not positionable, create an temporary positionable stream
	 (needed for limit calculation)
	"
	aStream isPositionable ifTrue:[
	    s := aStream.
	] ifFalse:[
	    s := CharacterWriteStream new:50.
	].
	limit := s position + self maxPrint.

	self printElementsDo:[:element |
	    firstOne ifFalse:[
		s space
	    ] ifTrue:[
		firstOne := false
	    ].
	    (s position >= limit) ifTrue:[
		s ~~ aStream ifTrue:[
		    aStream nextPutAll:(s contents).
		].
		aStream nextPutAll:'...etc...)'.
		^ self
	    ] ifFalse:[
		element printOn:s.
	    ].
	].
	s ~~ aStream ifTrue:[
	    aStream nextPutAll:(s contents).
	].
	aStream nextPut:$)
    ] ifFalse:[
	super printOn:aStream
    ]

    "
     #(1 2 $a $Š 'hello' sym kewordSymbol:with: #'funny symbol') printString
     #(1 2 $a [1 2 3] true false nil #true #false #nil) printString
    "

    "Created: 20.11.1995 / 11:16:58 / cg"
!

storeArrayElementOn:aStream
    "Store as element of an array. Omit the leading '#'"

    self isLiteral ifTrue:[
	aStream nextPut:$(.
	self
	    do:[:element | element storeArrayElementOn:aStream]
	    separatedBy:[aStream space].
	aStream nextPut:$).
	^ self.
    ].
    super storeArrayElementOn:aStream

    "
     #(1 2 3 4 5) storeOn:Transcript
     #(1 2 3 4 5) storeArrayElementOn:Transcript
    "
!

storeOn:aStream
    "append a printed representation of the receiver to aStream,
     which allows reconstructing it via readFrom:.
     Redefined to output a somewhat more user friendly string."

    self isLiteral ifTrue:[
	aStream nextPutAll:'#('.
	self do:[:element | element storeArrayElementOn:aStream]
	     separatedBy:[aStream space].
	aStream nextPut:$)
    ] ifFalse:[
	super storeOn:aStream
    ]

    "
     #(1 2 $a 'hello' sym kewordSymbol:with: #'funny symbol') storeString
     #(1 2 $a [1 2 3] true false nil #true #false #nil) storeString
    "

    "Created: 20.11.1995 / 11:16:58 / cg"
! !

!Array methodsFor:'queries'!

basicSize
    "return the number of indexed elements in the receiver"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN (STInteger._new(self.basicSize()));
#else
    REGISTER OBJ slf = self;

    RETURN ( __mkSmallInteger(__arraySize(slf) - __intVal(__ClassInstPtr(__qClass(slf))->c_ninstvars) ));
#endif
%}
!

refersToLiteral:aLiteral
    "return true if the receiver or recursively any array element in the
     receiver refers to aLiteral (i.e. a deep search)"

    self do:[:el |
	el == aLiteral ifTrue:[^true].
	el isArray ifTrue:[
	    (el refersToLiteral: aLiteral) ifTrue: [^true]
	]
    ].
    ^ false

    "
     #(1 2 3) refersToLiteral:#foo
     #(1 2 3 foo bar baz) refersToLiteral:#foo
     #(1 2 3 (((bar foo))) bar baz) refersToLiteral:#foo
    "

    "Modified: / 18.8.2000 / 21:18:14 / cg"
!

refersToLiteralMatching:aMatchPattern
    "return true if the receiver or recursively any array element in the
     receiver is symbolic and matches aMatchPattern (i.e. a deep search)"

    self do:[ :el |
	(el isSymbol and:[ aMatchPattern match: el]) ifTrue:[^true].
	el isArray ifTrue:[
	    (el refersToLiteralMatching: aMatchPattern) ifTrue: [^true]
	]
    ].
    ^ false

    "
     #(1 2 3) refersToLiteralMatching:#foo
     #(1 2 3 foo bar baz) refersToLiteralMatching:#foo
     #(1 2 3 (((bar foo))) bar baz) refersToLiteralMatching:#foo
    "

    "Modified: / 18-08-2000 / 21:18:14 / cg"
    "Created: / 26-07-2012 / 15:38:01 / cg"
!

size
    "return the number of indexed elements in the receiver.
     Reimplemented here to avoid the additional size->basicSize send
     (which we can do here, since when arriving here, #size is obviously not
      redefined in a subclass).
     This method is the same as basicSize."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN (STInteger._new(self.basicSize()));
#else
    REGISTER OBJ slf = self;

    RETURN ( __mkSmallInteger(__arraySize(slf) - __intVal(__ClassInstPtr(__qClass(slf))->c_ninstvars) ));
#endif
%}
! !

!Array methodsFor:'searching'!

identityIndexOf:anElement or:alternative
    "search the array for anElement or alternative;
     return the index of anElement if found, or the index of anAlternative,
     if not found. If anAlternative is also not found, return 0.
     This is a special interface for high-speed searching in an array
     and at the same time searching for an empty slot.
     Do not use this method for your application classes, since it is
     not portable (i.e. other smalltalks do not offer this)"

%{  /* NOCONTEXT */
    REGISTER INT index;
    REGISTER OBJ o, el1, el2;
    REGISTER OBJ *op;
    REGISTER unsigned INT nIndex;
    INT altIndex = 0;
    INT nInsts;

    index = 0;
    nInsts = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
    index += nInsts;
    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    el1 = anElement; el2 = alternative;
    op = & (__InstPtr(self)->i_instvars[index]);
    while (index++ < nIndex) {
	if ((o = *op++) == el1) {
	    RETURN ( __mkSmallInteger(index - nInsts) );
	}
	if (o == el2) {
	    if (altIndex == 0) {
		altIndex = index;
	    }
	}
    }
    RETURN ( __mkSmallInteger(altIndex) );
%}.
    ^ super identityIndexOf:anElement or:alternative

    "
     #(1 2 3 4 5 6 7 8 9) identityIndexOf:3 or:5
     #(1 2 0 4 5 6 7 8 9) identityIndexOf:3 or:5
     #(1 2 0 4 5 6 7 3 9) identityIndexOf:3 or:5
     #(1 2 3 4 5 nil 7 3 9) identityIndexOf:3 or:nil
     #(1 2 nil 4 5 6 7 3 9) identityIndexOf:3 or:nil
     #(1 2 nil 4 5 6 7 8 9) identityIndexOf:3 or:nil
     #() identityIndexOf:3 or:nil
     #(1 2) identityIndexOf:3 or:nil
    "
!

identityIndexOf:anElement startingAt:start
    "search the array for anElement; return index if found, 0 otherwise
     - reimplemented for speed"

%{  /* NOCONTEXT */

    REGISTER INT index;
    REGISTER OBJ el;
    REGISTER OBJ *op;
    REGISTER unsigned INT nIndex;
    INT nInsts;

    if (__isSmallInteger(start)) {
        index = __intVal(start) - 1;
        if (index >= 0) {
            nInsts = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
            index += nInsts;
            nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
            el = anElement;
            op = & (__InstPtr(self)->i_instvars[index]);

#if defined(memsrch4)
            if (index < nIndex) {
                OBJ *p;

                p = memsrch4(op, (INT)el, (nIndex - index));
                if (p) {
                    index += (p - op + 1);
                    RETURN ( __mkSmallInteger(index) );
                }
            }
#else

# ifdef __UNROLL_LOOPS__
            {
                /*
                 * don't argue about those gotos below - they speed up that thing by 30%;
                 * its better to exit the loops below with a goto,
                 * since the generated code will then be:
                 *   compare
                 *   branch-on-equal found
                 *
                 * otherwise (with ret as if-statement), we get:
                 *   compare
                 *   branch-on-not-equal skipLabel
                 *   move-to-ret-register true
                 *   goto ret-label
                 * skipLabel
                 *
                 * therefore, WITH the so-much-blamed goto, we only branch
                 * when found; without the goto, we branch always.
                 * Pipelined CPUs do usually not like taken branches.
                 */

                unsigned INT i8;

                while ((i8 = index + 8) < nIndex) {
                    if (op[0] == el) goto found1;
                    if (op[1] == el) goto found2;
                    if (op[2] == el) goto found3;
                    if (op[3] == el) goto found4;
                    if (op[4] == el) goto found5;
                    if (op[5] == el) goto found6;
                    if (op[6] == el) goto found7;
                    if (op[7] == el) goto found8;
                    index = i8;
                    op += 8;
                }
                if (0) {
                    found1:
                        RETURN ( __mkSmallInteger(index + 1 - nInsts) );
                    found2:
                        RETURN ( __mkSmallInteger(index + 2 - nInsts) );
                    found3:
                        RETURN ( __mkSmallInteger(index + 3 - nInsts) );
                    found4:
                        RETURN ( __mkSmallInteger(index + 4 - nInsts) );
                    found5:
                        RETURN ( __mkSmallInteger(index + 5 - nInsts) );
                    found6:
                        RETURN ( __mkSmallInteger(index + 6 - nInsts) );
                    found7:
                        RETURN ( __mkSmallInteger(index + 7 - nInsts) );
                    found8:
                        RETURN ( __mkSmallInteger(index + 8 - nInsts) );
                }
            }
# endif /* __UNROLLED_LOOPS__ */

            while (index++ < nIndex) {
                if (*op++ == el) goto found0;
            }

            if (0) {
                found0:
                    RETURN ( __mkSmallInteger(index - nInsts) );
            }
#endif /* no memsrch */
        }
        RETURN ( __mkSmallInteger(0) );
    }
%}.
    ^ super identityIndexOf:anElement startingAt:start
!

identityIndexOf:anElement startingAt:start endingAt:stop
    "search the array for anElement in the range start..stop;
     return the index if found, 0 otherwise.
     - reimplemented for speed when searching in OrderedCollections"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (start.isSmallInteger()
     && stop.isSmallInteger()) {
	if (self.isVector()) {
	    int _start = start.intValue() - 1;
	    int _stop = stop.intValue() - 1;
	    for (int i=_start; i<=_stop; i++) {
		if (self.vectorRef(i) == anElement) {
		    return context._RETURN(i+1);
		}
	    }
	    return context._RETURN(STInteger._0);
	}
    }
#else

    REGISTER INT index;
    REGISTER OBJ el;
    REGISTER OBJ *op;
    REGISTER unsigned INT lastIndex;
    unsigned INT nIndex;
    INT nInsts;

    if (__bothSmallInteger(start, stop)) {
	index = __intVal(start) - 1;
	if (index >= 0) {
	    nInsts = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);
	    index += nInsts;
	    lastIndex = nInsts + __intVal(stop);
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    if (nIndex < lastIndex) {
		lastIndex = nIndex;
	    }
	    el = anElement;
	    op = & (__InstPtr(self)->i_instvars[index]);

#if defined(memsrch4)
	    if (index < lastIndex) {
		OBJ *p;

		p = memsrch4(op, (INT)el, (lastIndex - index));
		if (p) {
		    index += (p - op + 1);
		    RETURN ( __mkSmallInteger(index) );
		}
	    }
#else

# ifdef __UNROLL_LOOPS__
	    {
		unsigned INT i8;

		while ((i8 = index + 8) < lastIndex) {
		    if (op[0] == el) goto found1;
		    if (op[1] == el) goto found2;
		    if (op[2] == el) goto found3;
		    if (op[3] == el) goto found4;
		    if (op[4] == el) goto found5;
		    if (op[5] == el) goto found6;
		    if (op[6] == el) goto found7;
		    if (op[7] == el) goto found8;
		    index = i8;
		    op += 8;
		}

		if (0) {
	    found1:
		    RETURN ( __mkSmallInteger(index + 1 - nInsts) );
	    found2:
		    RETURN ( __mkSmallInteger(index + 2 - nInsts) );
	    found3:
		    RETURN ( __mkSmallInteger(index + 3 - nInsts) );
	    found4:
		    RETURN ( __mkSmallInteger(index + 4 - nInsts) );
	    found5:
		    RETURN ( __mkSmallInteger(index + 5 - nInsts) );
	    found6:
		    RETURN ( __mkSmallInteger(index + 6 - nInsts) );
	    found7:
		    RETURN ( __mkSmallInteger(index + 7 - nInsts) );
	    found8:
		    RETURN ( __mkSmallInteger(index + 8 - nInsts) );
		}
	    }
# endif /* __UNROLL_LOOPS__ */

	    while (index++ < lastIndex) {
		if (*op++ == el) goto found0;
	    }

	    if (0) {
		found0:
		    RETURN ( __mkSmallInteger(index - nInsts) );
	    }
#endif
	}
	RETURN ( __mkSmallInteger(0) );
    }
#endif /*not SCHTEAM */
%}.
    ^ super identityIndexOf:anElement startingAt:start endingAt:stop

!

indexOf:anElement startingAt:start
    "search the array for anElement; return index if found, 0 otherwise
     - reimplemented for speed"

    |element|
%{
    REGISTER INT index;
    unsigned INT nIndex;
    unsigned INT nInsts;
    static struct inlineCache eq = _ILC1;
    OBJ myClass, e;

    myClass = __qClass(self);
    if ( __isSmallInteger(start) ) {
	index = __intVal(start) - 1;
	if (index >= 0) {
	    nInsts = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
	    index += nInsts;
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);

	    e = anElement;
	    if (e != nil) {
		/*
		 * special kludge to search for a string;
		 * this is so common, that its worth a special case
		 */
#define SPECIAL_STRING_OPT
#ifdef SPECIAL_STRING_OPT
		if (__isStringLike(e)) {
		    while (index < nIndex) {
			element = __InstPtr(self)->i_instvars[index++];
			if (__isNonNilObject(element)) {
			    if (element == e) {
				RETURN ( __mkSmallInteger(index - nInsts) );
			    }
			    if (__qClass(element) == @global(String)) {
				if (strcmp(__stringVal(e), __stringVal(element)) == 0) {
				    RETURN ( __mkSmallInteger(index - nInsts) );
				}
			    } else {
				if ((*eq.ilc_func)(e, @symbol(=), nil,&eq, element) == true) {
				    RETURN ( __mkSmallInteger(index - nInsts) );
				}
				/*
				 * send of #= could have lead to a GC - refetch e
				 */
				e = anElement;
			    }
			}
		    }
		    RETURN (__mkSmallInteger(0));
		}
#endif
#ifdef MAKES_IT_SLOWER_BUT_WHY
		if (__isSmallInteger(e)) {
		    /* search for a small number */
		    while (index < nIndex) {
			element = __InstPtr(self)->i_instvars[index++];
			if (element == e) {
			    RETURN ( __mkSmallInteger(index - nInsts) );
			}
			if (!__isSmallInteger(element)) {
			    if (element != nil) {
				if ((*eq.ilc_func)(e,
						   @symbol(=),
						   nil,&eq,
						   element) == true) {
				    RETURN ( __mkSmallInteger(index - nInsts) );
				}
				/*
				 * send of #= could have lead to a GC - refetch e
				 */
				e = anElement;
			    }
			}
		    }
		    RETURN (__mkSmallInteger(0));
		}
#endif /* MAKES_IT_SLOWER_BUT_WHY */

		while (index < nIndex) {
		    element = __InstPtr(self)->i_instvars[index++];
		    if (element != nil) {
			if ((element == e)
			 || ((*eq.ilc_func)(e,
					    @symbol(=),
					    nil,&eq,
					    element) == true)) {
			    RETURN ( __mkSmallInteger(index - nInsts) );
			}
			/*
			 * send of #= could have lead to a GC - refetch e
			 */
			e = anElement;
		    }
		}
	    } else {
		OBJ slf = self;

		/*
		 * search for nil - do an identity-search
		 */
#ifdef __UNROLL_LOOPS__
		{
		    unsigned INT i8;

		    while ((i8 = index + 8) < nIndex) {
			if (__InstPtr(slf)->i_instvars[index] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 1) ); }
			if (__InstPtr(slf)->i_instvars[index+1] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 2) ); }
			if (__InstPtr(slf)->i_instvars[index+2] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 3) ); }
			if (__InstPtr(slf)->i_instvars[index+3] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 4) ); }
			if (__InstPtr(slf)->i_instvars[index+4] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 5) ); }
			if (__InstPtr(slf)->i_instvars[index+5] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 6) ); }
			if (__InstPtr(slf)->i_instvars[index+6] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 7) ); }
			if (__InstPtr(slf)->i_instvars[index+7] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 8) ); }
			index = i8;
		    }
		}
#endif

		while (index < nIndex) {
		    if (__InstPtr(slf)->i_instvars[index++] == nil) {
			RETURN ( __mkSmallInteger(index - nInsts) );
		    }
		}
	    }
	}
	RETURN (__mkSmallInteger(0));
    }
%}.
    ^ super indexOf:anElement startingAt:start
!

indexOf:anElement startingAt:start endingAt:stop
    "search the array for anElement in the range start..stop;
     Return the index if found, 0 otherwise.
     - reimplemented for speed when searching in OrderedCollections"

    |element|
%{
    REGISTER INT index;
    unsigned INT lastIndex, nIndex;
    unsigned INT nInsts;
    static struct inlineCache eq = _ILC1;
    OBJ myClass, e;

    myClass = __qClass(self);
    if ( __bothSmallInteger(start, stop) ) {
	index = __intVal(start) - 1;
	if (index >= 0) {
	    nInsts = __intVal(__ClassInstPtr(myClass)->c_ninstvars);
	    index += nInsts;
	    lastIndex = nInsts + __intVal(stop);
	    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
	    if (nIndex < lastIndex) {
		lastIndex = nIndex;
	    }

	    e = anElement;

	    if (e != nil) {
		/*
		 * special kludge to search for a string;
		 * this is so common, that its worth a special case
		 */
#define SPECIAL_STRING_OPT
#ifdef SPECIAL_STRING_OPT
		if (__isStringLike(e)) {
		    while (index < lastIndex) {
			element = __InstPtr(self)->i_instvars[index++];
			if (__isNonNilObject(element)) {
			    if (element == e) {
				RETURN ( __mkSmallInteger(index - nInsts) );
			    }
			    if (__qClass(element) == @global(String)) {
				if (strcmp(__stringVal(e), __stringVal(element)) == 0) {
				    RETURN ( __mkSmallInteger(index - nInsts) );
				}
			    } else {
				if ((*eq.ilc_func)(e, @symbol(=), nil,&eq, element) == true) {
				    RETURN ( __mkSmallInteger(index - nInsts) );
				}
				/*
				 * send of #= could have lead to a GC - refetch e
				 */
				e = anElement;
			    }
			}
		    }
		    RETURN (__mkSmallInteger(0));
		}
#endif
		if (__isSmallInteger(e)) {
		    /* search for a small number */
		    while (index < lastIndex) {
			element = __InstPtr(self)->i_instvars[index++];
			if (element == e) {
			    RETURN ( __mkSmallInteger(index - nInsts) );
			}
			if (!__isSmallInteger(element)) {
			    if ((*eq.ilc_func)(e,
						@symbol(=),
						nil,&eq,
						element) == true) {
				RETURN ( __mkSmallInteger(index - nInsts) );
			    }
			    /*
			     * send of #= could have lead to a GC - refetch e
			     */
			    e = anElement;
			}
		    }
		    RETURN (__mkSmallInteger(0));
		}

		while (index < lastIndex) {
		    element = __InstPtr(self)->i_instvars[index++];
		    if (element != nil) {
			e = anElement;
			if ((element == e)
			 || ((*eq.ilc_func)(e,
					    @symbol(=),
					    nil,&eq,
					    element) == true)) {
			    RETURN ( __mkSmallInteger(index - nInsts) );
			}
		    }
		}
	    } else {
		OBJ slf = self;

		/*
		 * search for nil - do an identity-search
		 */
#ifdef __UNROLL_LOOPS__
		{
		    unsigned INT i8;

		    while ((i8 = index + 8) < lastIndex) {
			if (__InstPtr(slf)->i_instvars[index] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 1) ); }
			if (__InstPtr(slf)->i_instvars[index+1] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 2) ); }
			if (__InstPtr(slf)->i_instvars[index+2] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 3) ); }
			if (__InstPtr(slf)->i_instvars[index+3] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 4) ); }
			if (__InstPtr(slf)->i_instvars[index+4] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 5) ); }
			if (__InstPtr(slf)->i_instvars[index+5] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 6) ); }
			if (__InstPtr(slf)->i_instvars[index+6] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 7) ); }
			if (__InstPtr(slf)->i_instvars[index+7] == nil) { RETURN ( __mkSmallInteger(index - nInsts + 8) ); }
			index = i8;
		    }
		}
#endif
		while (index < lastIndex) {
		    if (__InstPtr(slf)->i_instvars[index++] == nil) {
			RETURN ( __mkSmallInteger(index - nInsts) );
		    }
		}
	    }
	}
	RETURN (__mkSmallInteger(0));
    }
%}.
    ^ super indexOf:anElement startingAt:start endingAt:stop
! !

!Array methodsFor:'testing'!

includes:anObject
    "return true, if the argument, anObject is contained in the array
     - reimplemented for speed"

    |element|

%{  /* NOCONTEXT */
    /*
     * first, do a quick check using ==
     * this does not need a context or message send.
     * In many cases this will already find a match.
     */
    REGISTER INT index;
    REGISTER OBJ o;
    unsigned INT nIndex;

    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    index = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);

    o = anObject;

    /*
     * however, the search is limited to the first 500
     * elements, since otherwise, we may spend too much time
     * searching for identity if an equal value is found early
     * (except if searching for nil - there is no need for equal compare ...)
     */
    if (nIndex > 500) {
        if (o != nil)
            nIndex = 500;
    }

# ifdef memsrch4
    if (index < nIndex) {
        OBJ *p;

        p = memsrch4(&(__InstPtr(self)->i_instvars[index]), (INT)o, (nIndex - index));
        if (p) {
            RETURN ( true );
        }
    }

# else
    /*
     * don't argue those gotos below - they speed up that thing by 30%
     * its better to exit the loops below with a goto,
     * since the generated code will then be:
     *   compare
     *   branch-on-equal found
     *
     * otherwise, we get:
     *   compare
     *   branch-on-not-equal skipLabel
     *   move-to-return-register true
     *   goto return-label
     * skipLabel
     *
     * therefore, WITH the so-much-blamed goto, we only branch
     * when found; without the goto, we branch always.
     * Pipelined CPUs do usually not like taken branches.
     * also, all branches are forward, which are usually predicted
     * as not taken.
     */
#  ifdef __UNROLL_LOOPS__
    {
        unsigned INT i8;
        REGISTER OBJ slf = self;

        while ((i8 = index + 8) < nIndex) {
            if (__InstPtr(slf)->i_instvars[index] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+1] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+2] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+3] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+4] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+5] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+6] == o) goto found;
            if (__InstPtr(slf)->i_instvars[index+7] == o) goto found;
            index = i8;
        }
    }
#  endif /* __UNROLL_LOOPS__ */

    while (index < nIndex) {
        if (__InstPtr(self)->i_instvars[index++] == o) goto found;
    }
    if (0) {
        found:
            RETURN (true);
    }

# endif /* no memsrch */

    if (o == nil) {
        RETURN ( false );
    }
%}.

%{
    REGISTER INT index;
    REGISTER OBJ o;
    unsigned INT nIndex;
    static struct inlineCache eq = _ILC1;

    /*
     * then do a slow(er) check using =
     */

    /*
     * sorry: cannot access the stuff from above ...
     */
    nIndex = __BYTES2OBJS__(__qSize(self) - OHDR_SIZE);
    index = __intVal(__ClassInstPtr(__qClass(self))->c_ninstvars);

    while (index < nIndex) {
        element = __InstPtr(self)->i_instvars[index++];
        if (element != nil) {
            if ((*eq.ilc_func)(anObject,
                               @symbol(=),
                               nil,&eq,
                               element)==true) {
                RETURN ( true );
            }
        }
    }
    RETURN (false);
%}.
    ^ super includes:anObject
!

includesIdentical:anObject
    "return true, if the argument, anObject is contained in the array
     uses #== (instead of #=) when comparing; i.e. the search is for
     the object, not some object being equal."

    ^ (self identityIndexOf:anObject) ~~ 0

    "
     #(1 2 3 4 5) includes:3.0

     #(1 2 3 4 5) includesIdentical:3.0
    "
!

isArray
    "return true, if the receiver is some kind of array (or weakArray etc).
     true is returned here."

    ^ true
!

isEmpty
    "return true if the receiver contains no elements.
     Reimplemented here for performance."

%{  /* NOCONTEXT */
    REGISTER OBJ slf = self;

    if (__qClass(slf) == Array) {
	RETURN ( (__arraySize(slf) == 0) ? true : false);
    }
%}.
    ^ self size == 0
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    "/ no, simply returning true here is a mistake:
    "/ it could be a subclass of Array
    "/ (of which the compiler does not know at all ...)
    self class == Array ifFalse:[^ false].

    "/
    "/ care for recursive arrays ...
    "/
    thisContext isRecursive ifTrue:[^ false].
    ^ self conform:[:element | element isLiteral].

    "Modified: / 13-10-2006 / 13:00:45 / cg"
!

notEmpty
    "return true if the receiver contains elements.
     Reimplemented here for performance."

%{  /* NOCONTEXT */
    REGISTER OBJ slf = self;

    if (__qClass(slf) == Array) {
	RETURN ( (__arraySize(slf) != 0) ? true : false);
    }
%}.
    ^ self size ~~ 0
! !

!Array methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceArray:self level:level from:referrer


! !

!Array class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

