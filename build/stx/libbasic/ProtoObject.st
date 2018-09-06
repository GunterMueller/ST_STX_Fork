"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2004 by eXept Software AG
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

nil subclass:#ProtoObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Objects'
!

!ProtoObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    a minimum object without much protocol;
    Provides the minimum required to prevent inspectors from crashing,
    and debuggers from blocking.
    (i.e. instead of inheriting from nil, better inherit from this).

    Named after a similar class found in Dolphin-Smalltalk.

    [author:]
        Claus Gittinger (not much authoring, though)
"
! !

!ProtoObject class methodsFor:'helpers'!

shallowCopyOf:anObject
    "return a copy of anObject with shared subobjects (a shallow copy)
     i.e. the copy shares referenced instvars with its original."

%{  /* NOCONTEXT */
    int ninsts, spc, sz;
    OBJ theCopy;
    OBJ cls = __qClass(anObject);
    int flags = __intVal(__ClassInstPtr(cls)->c_flags);

    /*
     * bail out for special objects ..
     */
    if (((flags & ~ARRAYMASK) == 0)
     && ((flags & ARRAYMASK) != WKPOINTERARRAY)) {
        sz = __qSize(anObject);
        __PROTECT__(anObject);
        __qNew(theCopy, sz);    /* OBJECT ALLOCATION */
        __UNPROTECT__(anObject);
        if (theCopy) {
            cls = __qClass(anObject);
            spc = __qSpace(theCopy);

            theCopy->o_class = cls; __STORE_SPC(theCopy, cls, spc);

            sz = sz - OHDR_SIZE;
            if (sz) {
                char *src, *dst;

                src = (char *)(__InstPtr(anObject)->i_instvars);
                dst = (char *)(__InstPtr(theCopy)->i_instvars);
#ifdef bcopy4
                {
                    /* care for odd-number of longs */
                    int nW = sz >> 2;

                    if (sz & 3) {
                        nW++;
                    }

                    bcopy4(src, dst, nW);
                }
#else
                bcopy(src, dst, sz);
#endif

                flags &= ARRAYMASK;
                if (flags == POINTERARRAY) {
                    ninsts = __BYTES2OBJS__(sz);
                } else {
                    ninsts = __intVal(__ClassInstPtr(cls)->c_ninstvars);
                }
                if (ninsts) {
                    do {
                        OBJ el;

                        el = __InstPtr(theCopy)->i_instvars[ninsts-1];
                        __STORE_SPC(theCopy, el, spc);
                    } while (--ninsts);
                }
            }
            RETURN (theCopy);
        }
    }
%}.
    "/ fallBack for special objects & memoryAllocation failure case

    ^ self error:'ProtoObject>>#shallowCopyOf: failed'
! !

!ProtoObject methodsFor:'error handling'!

doesNotUnderstand:aMessage
    "this message is sent by the runtime system (VM) when
     a message is not understood by some object (i.e. there
     is no method for that selector). The original message has
     been packed into aMessage (i.e. the receiver, selector and
     any arguments) and the original receiver is then sent the
     #doesNotUnderstand: message.
     Here, we raise another signal which usually enters the debugger.
     You can of course redefine #doesNotUnderstand: in your classes
     to implement message delegation, 
     or handle the MessageNotUnderstood exception gracefully."

    <context: #return>

    ^ MessageNotUnderstood raiseRequestWith:aMessage
! !

!ProtoObject methodsFor:'inspecting'!

inspect
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#inspect)
        valueWithReceiver:self
        arguments:nil
        selector:#inspect
!

instVarAt:index
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#instVarAt:)
        valueWithReceiver:self
        arguments:{index}
        selector:#instVarAt:
!

isKindOf:aBehavior
    "this method is required Behavior>>#allSubInstancesDo:"

    aBehavior == Object ifTrue:[^ true].

    ^ (Object compiledMethodAt:#isKindOf:)
        valueWithReceiver:self
        arguments:{aBehavior}
        selector:#isKindOf:
!

perform:aSelector
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:#().
!

perform:aSelector with:arg1 
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1}.
!

perform:aSelector with:arg1 with:arg2
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1. arg2}.
!

perform:aSelector with:arg1 with:arg2 with:arg3
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1. arg2. arg3}.
!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1. arg2. arg3. arg4}.
!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1. arg2. arg3. arg4. arg5}.
!

perform:aSelector with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6
    "this method is required to allow inspection of the object"

    ^ self perform:aSelector withArguments:{arg1. arg2. arg3. arg4. arg5. arg6}.
!

perform:aSelector withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver.

     1-to-1 Copy from the same method in Object!!"

    |numberOfArgs a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15|

%{
#ifdef __SCHTEAM__
    return context.PERFORM_WITH_ARGUMENTS(self, aSelector, argArray);
#else
    REGISTER OBJ *argP;
    int nargs;
    OBJ l;

    if (__isArrayLike(argArray)) {
        nargs = __arraySize(argArray);
        argP = __arrayVal(argArray);
    } else {
        if (__isNonNilObject(argArray)) {
            static struct inlineCache ilcSize = __ILC0(@line);
            int i;

            numberOfArgs = (*ilcSize.ilc_func)(argArray, @symbol(size), nil, &ilcSize);
            if (!__isSmallInteger(numberOfArgs))
                goto bad;
            nargs = __intVal(numberOfArgs);
            argP = (OBJ *)(&a1);
            for (i=1; i <= nargs; i++) {
                *argP++ = __AT_(argArray, __mkSmallInteger(i));
            }
            argP = (OBJ *)(&a1);
        } else {
            nargs = 0;
        }
    }
    switch (nargs) {
        case 0:
            if (InterruptPending == nil) {
                static OBJ last0_0 = nil; static struct inlineCache ilc0_0 = __ILCPERF0(@line);
                static OBJ last0_1 = nil; static struct inlineCache ilc0_1 = __ILCPERF0(@line);
                static OBJ last0_2 = nil; static struct inlineCache ilc0_2 = __ILCPERF0(@line);
                static OBJ last0_3 = nil; static struct inlineCache ilc0_3 = __ILCPERF0(@line);
                static int flip0 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last0_0) {
                    pIlc = &ilc0_0;
                } else if (aSelector == last0_1) {
                    pIlc = &ilc0_1;
                } else if (aSelector == last0_2) {
                    pIlc = &ilc0_2;
                } else if (aSelector == last0_3) {
                    pIlc = &ilc0_3;
                } else {
                    if (flip0 == 0) {
                        pIlc = &ilc0_0;
                        flip0 = 1;
                        last0_0 = aSelector;
                    } else if (flip0 == 1) {
                        pIlc = &ilc0_1;
                        flip0 = 2;
                        last0_1 = aSelector;
                    } else if (flip0 == 2) {
                        pIlc = &ilc0_2;
                        flip0 = 3;
                        last0_2 = aSelector;
                    } else {
                        pIlc = &ilc0_3;
                        flip0 = 0;
                        last0_3 = aSelector;
                    }

                    pIlc->ilc_func = __SEND0ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc));
            } else {
                static struct inlineCache ilc0 = __DUMMYILCSELF0(@line+1);
                RETURN (_SEND0(self, aSelector, nil, &ilc0));
            }

        case 1:
            if (InterruptPending == nil) {
                static OBJ last1_0 = nil; static struct inlineCache ilc1_0 = __ILCPERF1(@line);
                static OBJ last1_1 = nil; static struct inlineCache ilc1_1 = __ILCPERF1(@line);
                static OBJ last1_2 = nil; static struct inlineCache ilc1_2 = __ILCPERF1(@line);
                static OBJ last1_3 = nil; static struct inlineCache ilc1_3 = __ILCPERF1(@line);
                static int flip1 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last1_0) {
                    pIlc = &ilc1_0;
                } else if (aSelector == last1_1) {
                    pIlc = &ilc1_1;
                } else if (aSelector == last1_2) {
                    pIlc = &ilc1_2;
                } else if (aSelector == last1_3) {
                    pIlc = &ilc1_3;
                } else {
                    if (flip1 == 0) {
                        pIlc = &ilc1_0;
                        flip1 = 1;
                        last1_0 = aSelector;
                    } else if (flip1 == 1) {
                        pIlc = &ilc1_1;
                        flip1 = 2;
                        last1_1 = aSelector;
                    } else if (flip1 == 2) {
                        pIlc = &ilc1_2;
                        flip1 = 3;
                        last1_2 = aSelector;
                    } else {
                        pIlc = &ilc1_3;
                        flip1 = 0;
                        last1_3 = aSelector;
                    }

                    pIlc->ilc_func = __SEND1ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0]));
            } else {
                static struct inlineCache ilc1 = __DUMMYILCSELF1(@line+1);
                RETURN (_SEND1(self, aSelector, nil, &ilc1, argP[0]));
            }

        case 2:
            if (InterruptPending == nil) {
                static OBJ last2_0 = nil; static struct inlineCache ilc2_0 = __ILCPERF2(@line);
                static OBJ last2_1 = nil; static struct inlineCache ilc2_1 = __ILCPERF2(@line);
                static int flip2 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last2_0) {
                    pIlc = &ilc2_0;
                } else if (aSelector == last2_1) {
                    pIlc = &ilc2_1;
                } else {
                    if (flip2 == 0) {
                        pIlc = &ilc2_0;
                        flip2 = 1;
                        last2_0 = aSelector;
                    } else {
                        pIlc = &ilc2_1;
                        flip2 = 0;
                        last2_1 = aSelector;
                    }

                    pIlc->ilc_func = __SEND2ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0], argP[1]));
            } else {
                static struct inlineCache ilc2 = __DUMMYILCSELF2(@line+1);
                RETURN (_SEND2(self, aSelector, nil, &ilc2, argP[0], argP[1]));
            }

        case 3:
            if (InterruptPending == nil) {
                static OBJ last3_0 = nil; static struct inlineCache ilc3_0 = __ILCPERF3(@line);
                static OBJ last3_1 = nil; static struct inlineCache ilc3_1 = __ILCPERF3(@line);
                static int flip3 = 0;
                struct inlineCache *pIlc;

                if (aSelector == last3_0) {
                    pIlc = &ilc3_0;
                } else if (aSelector == last3_1) {
                    pIlc = &ilc3_1;
                } else {
                    if (flip3 == 0) {
                        pIlc = &ilc3_0;
                        flip3 = 1;
                        last3_0 = aSelector;
                    } else {
                        pIlc = &ilc3_1;
                        flip3 = 0;
                        last3_1 = aSelector;
                    }

                    pIlc->ilc_func = __SEND3ADDR__;
                    if (pIlc->ilc_poly) {
                        __flushPolyCache(pIlc->ilc_poly);
                        pIlc->ilc_poly = 0;
                    }
                }
                RETURN ((*pIlc->ilc_func)(self, aSelector, nil, pIlc, argP[0], argP[1], argP[2]));
            } else {
                static struct inlineCache ilc3 = __DUMMYILCSELF3(@line+1);
                RETURN (_SEND3(self, aSelector, nil, &ilc3, argP[0], argP[1], argP[2]));
            }

        case 4:
            {
                static OBJ last4 = nil; static struct inlineCache ilc4 = __ILCPERF4(@line);

                if ((InterruptPending != nil) || (aSelector != last4)) {
                    ilc4.ilc_func = __SEND4ADDR__;
                    if (ilc4.ilc_poly) {
                        __flushPolyCache(ilc4.ilc_poly);
                        ilc4.ilc_poly = 0;
                    }
                    last4 = aSelector;
                }
                RETURN ( (*ilc4.ilc_func)(self, aSelector, nil, &ilc4,
                                                argP[0], argP[1], argP[2], argP[3]));
            }

        case 5:
            {
                static OBJ last5 = nil; static struct inlineCache ilc5 = __ILCPERF5(@line);

                if ((InterruptPending != nil) || (aSelector != last5)) {
                    ilc5.ilc_func = __SEND5ADDR__;
                    if (ilc5.ilc_poly) {
                        __flushPolyCache(ilc5.ilc_poly);
                        ilc5.ilc_poly = 0;
                    }
                    last5 = aSelector;
                }
                RETURN ( (*ilc5.ilc_func)(self, aSelector, nil, &ilc5,
                                                argP[0], argP[1], argP[2], argP[3], argP[4]));
            }

        case 6:
            {
                static OBJ last6 = nil; static struct inlineCache ilc6 = __ILCPERF6(@line);

                if ((InterruptPending != nil) || (aSelector != last6)) {
                    ilc6.ilc_func = __SEND6ADDR__;
                    if (ilc6.ilc_poly) {
                        __flushPolyCache(ilc6.ilc_poly);
                        ilc6.ilc_poly = 0;
                    }
                    last6 = aSelector;
                }
                RETURN ( (*ilc6.ilc_func)(self, aSelector, nil, &ilc6,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5]));
            }

        case 7:
            {
                static OBJ last7 = nil; static struct inlineCache ilc7 = __ILCPERF7(@line);

                if ((InterruptPending != nil) || (aSelector != last7)) {
                    ilc7.ilc_func = __SEND7ADDR__;
                    if (ilc7.ilc_poly) {
                        __flushPolyCache(ilc7.ilc_poly);
                        ilc7.ilc_poly = 0;
                    }
                    last7 = aSelector;
                }
                RETURN ( (*ilc7.ilc_func)(self, aSelector, nil, &ilc7,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6]));
            }

        case 8:
            {
                static OBJ last8 = nil; static struct inlineCache ilc8 = __ILCPERF8(@line);

                if ((InterruptPending != nil) || (aSelector != last8)) {
                    ilc8.ilc_func = __SEND8ADDR__;
                    if (ilc8.ilc_poly) {
                        __flushPolyCache(ilc8.ilc_poly);
                        ilc8.ilc_poly = 0;
                    }
                    last8 = aSelector;
                }
                RETURN ( (*ilc8.ilc_func)(self, aSelector, nil, &ilc8,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7]));
            }

        case 9:
            {
                static OBJ last9 = nil; static struct inlineCache ilc9 = __ILCPERF9(@line);

                if ((InterruptPending != nil) || (aSelector != last9)) {
                    ilc9.ilc_func = __SEND9ADDR__;
                    if (ilc9.ilc_poly) {
                        __flushPolyCache(ilc9.ilc_poly);
                        ilc9.ilc_poly = 0;
                    }
                    last9 = aSelector;
                }
                RETURN ( (*ilc9.ilc_func)(self, aSelector, nil, &ilc9,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8]));
            }

        case 10:
            {
                static OBJ last10 = nil; static struct inlineCache ilc10 = __ILCPERF10(@line);

                if ((InterruptPending != nil) || (aSelector != last10)) {
                    ilc10.ilc_func = __SEND10ADDR__;
                    if (ilc10.ilc_poly) {
                        __flushPolyCache(ilc10.ilc_poly);
                        ilc10.ilc_poly = 0;
                    }
                    last10 = aSelector;
                }
                RETURN ( (*ilc10.ilc_func)(self, aSelector, nil, &ilc10,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9]));
            }

        case 11:
            {
                static OBJ last11 = nil; static struct inlineCache ilc11 = __ILCPERF11(@line);

                if ((InterruptPending != nil) || (aSelector != last11)) {
                    ilc11.ilc_func = __SEND11ADDR__;
                    if (ilc11.ilc_poly) {
                        __flushPolyCache(ilc11.ilc_poly);
                        ilc11.ilc_poly = 0;
                    }
                    last11 = aSelector;
                }
                RETURN ( (*ilc11.ilc_func)(self, aSelector, nil, &ilc11,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10]));
            }

        case 12:
            {
                static OBJ last12 = nil; static struct inlineCache ilc12 = __ILCPERF12(@line);

                if ((InterruptPending != nil) || (aSelector != last12)) {
                    ilc12.ilc_func = __SEND12ADDR__;
                    if (ilc12.ilc_poly) {
                        __flushPolyCache(ilc12.ilc_poly);
                        ilc12.ilc_poly = 0;
                    }
                    last12 = aSelector;
                }
                RETURN ( (*ilc12.ilc_func)(self, aSelector, nil, &ilc12,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11]));
            }

        case 13:
            {
                static OBJ last13 = nil; static struct inlineCache ilc13 = __ILCPERF13(@line);

                if ((InterruptPending != nil) || (aSelector != last13)) {
                    ilc13.ilc_func = __SEND13ADDR__;
                    if (ilc13.ilc_poly) {
                        __flushPolyCache(ilc13.ilc_poly);
                        ilc13.ilc_poly = 0;
                    }
                    last13 = aSelector;
                }
                RETURN ( (*ilc13.ilc_func)(self, aSelector, nil, &ilc13,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12]));
            }

        case 14:
            {
                static OBJ last14 = nil; static struct inlineCache ilc14 = __ILCPERF14(@line);

                if ((InterruptPending != nil) || (aSelector != last14)) {
                    ilc14.ilc_func = __SEND14ADDR__;
                    if (ilc14.ilc_poly) {
                        __flushPolyCache(ilc14.ilc_poly);
                        ilc14.ilc_poly = 0;
                    }
                    last14 = aSelector;
                }
                RETURN ( (*ilc14.ilc_func)(self, aSelector, nil, &ilc14,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12], argP[13]));
            }

        case 15:
            {
                static OBJ last15 = nil; static struct inlineCache ilc15 = __ILCPERF15(@line);

                if ((InterruptPending != nil) || (aSelector != last15)) {
                    ilc15.ilc_func = __SEND15ADDR__;
                    if (ilc15.ilc_poly) {
                        __flushPolyCache(ilc15.ilc_poly);
                        ilc15.ilc_poly = 0;
                    }
                    last15 = aSelector;
                }
                RETURN ( (*ilc15.ilc_func)(self, aSelector, nil, &ilc15,
                                                argP[0], argP[1], argP[2], argP[3], argP[4],
                                                argP[5], argP[6], argP[7], argP[8], argP[9],
                                                argP[10], argP[11], argP[12], argP[13],
                                                argP[14]));
            }
    }
bad:;
#endif
%}.

    "/ arrive here, if bad number of arguments (too many)
    "/ ST/X (currently) only allows up to 15 method arguments

    ^ self primitiveFailed
!

referencesAny:anObject
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#referencesAny:)
        valueWithReceiver:self
        arguments:{anObject}
        selector:#referencesAny
!

referencesObject:anObject
    "this method is required to allow inspection of the object"

    ^ (Object compiledMethodAt:#referencesObject:)
        valueWithReceiver:self
        arguments:{anObject}
        selector:#referencesObject
! !

!ProtoObject methodsFor:'queries'!

class
    "return the receiver's class"

%{  /* NOCONTEXT */

    RETURN ( __Class(self) );
%}

"
*** WARNING
***
*** this method has been automatically created,
*** since all nil-subclasses should respond to some minimum required
*** protocol.
***
*** Inspection and/or debugging of instances may not be possible,
*** if you remove/change this method. 
"

    "Modified (comment): / 30-04-2016 / 15:51:12 / cg"
!

identityHash
    "return an Integer useful as a hash key for the receiver.
     This hash should return same values for the same object (i.e. use
     this to hash on identity of objects).

     We cannot use the Objects address (as other smalltalks do) since
     no object-table exists and the hashval must not change when objects
     are moved by the collector. Therefore we assign each object a unique
     Id in the object header itself as its hashed upon.
     (luckily we have 11 bits spare to do this - unluckily its only 11 bits).
     Time will show, if 11 bits are enough; if not, another entry in the
     object header will be needed, adding 4 bytes to every object. Alternatively,
     hashed-upon objects could add an instvar containing the hash value."

%{  /* NOCONTEXT */

    REGISTER unsigned INT hash;
    static unsigned nextHash = 0;

    if (__isNonNilObject(self)) {
        hash = __GET_HASH(self);
        if (hash == 0) {
            /* has no hash yet */

            if (++nextHash > __MAX_HASH__) {
                nextHash = 1;
            }
            hash = nextHash;
            __SET_HASH(self, hash);
        }

        /*
         * now, we got 11 bits for hashing;
         * make it as large as possible; since most hashers use the returned
         * key and take it modulo some prime number, this will allow for
         * better distribution (i.e. bigger empty spaces) in hashed collection.
         */
        hash = __MAKE_HASH__(hash);
        RETURN ( __mkSmallInteger(hash) );
    }
%}.
    ^ 0 "never reached, since redefined in UndefinedObject and SmallInteger"

    "Created: / 31-05-2007 / 23:18:40 / cg"
! !

!ProtoObject methodsFor:'testing'!

ifNil:aBlock
    ^ self
!

ifNotNil:aBlockOrValue
    (aBlockOrValue isBlock and:[aBlockOrValue argumentCount == 1]) ifTrue:[
        ^ aBlockOrValue value:self.
    ].
    ^ aBlockOrValue value
!

isBehavior
    "return true, if the receiver is describing another object's behavior.
     False is returned here - the method is only redefined in Behavior."

    ^ false
!

isBlock
    ^ false
!

isBridgeProxy
    "answer true, if I am a proxy object for a bridged remote object"

    "do not move this into the bridge-package;
     it is called by some others, to prevent remote messages from implements/respondsTo, etc.
     which are called from inspectors and debuggers"
     
    ^ false

    "Modified (comment): / 25-05-2018 / 12:45:50 / Claus Gittinger"
!

isException
    ^ false
!

isExceptionHandler
    ^ false
!

isJavaObject
    ^ false
!

isLazyValue
    ^ false

    "Created: / 03-06-2007 / 14:02:12 / cg"
!

isLiteral
    ^ false

    "Created: / 04-06-2007 / 17:19:10 / cg"
!

isNil
    ^ false.
!

isProtoObject
    ^ true
! !

!ProtoObject class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

