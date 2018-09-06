"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
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

Object subclass:#ExecutableFunction
	instanceVariableNames:'code*'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!ExecutableFunction class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
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
    This is an abstract class, to merge common attributes of all kinds of
    executable code objects; i.e. non-ST functions, Blocks and Methods
    and whatever there might be in the future.

    Instances of ExecutableCode are not meant to be created by user code -
    the compilers create instances of subclasses, such as Method & Block
    (the VM would not even know what to do with such an instance, and triggered
     and exception, if ever encountered during block/method execution).


    NOTICE: layout known by runtime system and compiler - do not change


    [Instance variables:]
      code        <not_an_object>   the function pointer to the machine code.
                                    Not accessible from smalltalk code.
                                    (notice the '*' in the instVarNames definition)


    [Class variables:]
      ExecutionErrorSignal          parent of all execution errors
                                    (not raised itself)

      InvalidCodeSignal             codeObject is not executable


    [author:]
        Claus Gittinger
"
! !

!ExecutableFunction class methodsFor:'queries'!

isAbstract
    ^ self == ExecutableFunction
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == ExecutableFunction

    "Modified: 23.1.1997 / 13:47:58 / cg"
! !

!ExecutableFunction methodsFor:'accessing'!

code
    "return the code field. This is not an object but the address of the machine instructions. 
     Therefore an externalAddress representing the code-address is returned"

%{  /* NOCONTEXT */
    unsigned INT addr;

    if (__INST(code_) != nil) {
        
#ifdef OLD
        // returned an integer in very old versions.
        addr = (unsigned INT)__INST(code_);
        if (addr <= _MAX_INT) {
            RETURN ( __mkSmallInteger(addr) );
        }
        RETURN ( __MKUINT(addr));
#endif
        RETURN (__MKEXTERNALADDRESS(__INST(code_)));
    }
%}.
    ^ nil
!

instVarAt:index
    "have to catch instVar access to code - since its no object"

    (index == 1) ifTrue:[^ self code].
    ^ super instVarAt:index
!

instVarAt:index put:value
    "have to catch instVar access to code - since its no object"

    (index == 1) ifTrue:[^ self code:value].
    ^ super instVarAt:index put:value
! !


!ExecutableFunction methodsFor:'error handling'!

invalidCode
    "{ Pragma: +optSpace }"

    "this error is triggered by the interpreter when something is wrong
     with the code object (any error not handled by Method-signals).
     In this case, the VM sends this to the bad method/block (the receiver).
     Can only happen when the Compiler/runtime system is broken or
     someone played around."

    ^ InvalidCodeError raise.

    "Modified: 4.11.1996 / 22:47:21 / cg"
! !

!ExecutableFunction methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    |addr|

    addr := self code.
    addr isNil ifTrue:[^ super printOn:aStream].

    aStream nextPutAll:self class name; nextPutAll:'(address: 0x'.
    addr address printOn:aStream base:16.
    aStream nextPut:$)

    "Modified: / 22.4.1996 / 16:36:05 / cg"
    "Modified: / 20.1.1998 / 14:10:46 / stefan"
!

printStringForBrowserWithSelector:selector inClass:aClass
    "return a printString to represent myself to the user in a browser."

    ^ selector

! !

!ExecutableFunction methodsFor:'private-accessing'!

code:anAddress
    "set the code field - DANGER ALERT. 
     This is not an object but the address of the machine instructions.
     Therefore the argument must be an integer representing this address.
     You can crash Smalltalk very badly when playing around here ...
     This method is for compiler support and very special cases (debugging) only
     - do not use"

%{  /* NOCONTEXT */

    if (__isExternalAddress(anAddress)) {
        __INST(code_) = (OBJ)(__externalAddressVal(anAddress));
    } else {
        if (__isSmallInteger(anAddress))
            __INST(code_) = (OBJ)(__intVal(anAddress));
        else {
            if (anAddress == nil) {
                __INST(code_) = nil;
            } else {
                __INST(code_) = (OBJ)(__longIntVal(anAddress));
            }
        }
    }
%}
!

invalidate
    self code:0
! !

!ExecutableFunction methodsFor:'queries'!

category
    "return the category of this codeObject.
     Return nil here, to allow alien codeObjects to be handled by the browsers."

    ^ nil

    "Created: / 16-04-1996 / 16:31:15 / cg"
    "Modified (comment): / 12-11-2016 / 11:46:00 / cg"
!

hasCanvasResource
    "Return true, if this method is an canvas-resource method, false otherwise.
     This is done by looking for a #canvas key in the method's resources."

    ^ self hasResource:#canvas

    "Modified (comment): / 20-03-2014 / 16:58:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasCode
    "return true, if this codeObject has machinecode to execute."

%{  /* NOCONTEXT */
    if (__INST(code_)) {
        RETURN (true);
    }
    RETURN (false);
%}.
    ^ false

    "Created: / 13.11.1998 / 23:13:29 / cg"
!

hasImageResource
    "return true, if this method is an image-resource method.
     This is done by looking for a #image key in the method's resources."

    ^ self hasResource:#image
!

hasMenuResource
    "return true, if this method is a menu-resource method.
     This is done by looking for a #image key in the method's resources."

    ^ self hasResource:#menu
!

hasResource
    "return true, if this codeObject has a resource (false here - only real methods have)."

    ^ false
!

hasResource:aSymbol
    "return true if the method has a <resource> definition for aSymbol."

    ^ self hasResource and:[ (self resources ? #()) includesKey:aSymbol ]

    "
     Method allInstancesDo:[:m |
        (m hasResource:#image) ifTrue:[self halt]
     ].
    "

    "Modified: / 01-12-2010 / 13:59:58 / cg"
!

isBreakpointed
    "return true, if this is a wrapper method for a breakpoint.
     False is returned here - this method is redefined in WrappedMethod"

    ^ false

    "Created: 7.4.1997 / 17:24:40 / cg"
!

isExecutable
    "return true, if this codeObject is executable."

    self isInvalid ifTrue:[^ false].
    ^ self hasCode

    "Created: / 16.4.1996 / 20:13:32 / cg"
    "Modified: / 13.11.1998 / 23:16:32 / cg"
!

isInstrumented
    "return true, if this is an instrumented method.
     False is returned here - this method is redefined in InstrumentedMethod"

    ^ false

    "Created: / 27-04-2010 / 12:26:05 / cg"
!

isInvalid
    "return true, if this codeObject is invalidated.
     Return false here, to allow alien codeObjects to be handled by the browsers."

    ^ false

    "Created: / 16-04-1996 / 16:31:42 / cg"
    "Modified (comment): / 12-11-2016 / 11:46:07 / cg"
!

isJavaMethod
    ^ false

    "Created: / 10.11.1998 / 18:26:44 / cg"
!

isLazyMethod
    "return true, if this is a lazy method.
     False is returned here - this method is redefined in LazyMethod"

    ^ false

    "Created: 16.4.1996 / 16:32:11 / cg"
    "Modified: 16.4.1996 / 16:32:36 / cg"
!

isObsolete
    ^ false
!

isTimed
    "return true, if this is a wrapper method for a time measurement.
     False is returned here - this method is redefined in WrappedMethod"

    ^ false

    "Created: 11.4.1997 / 17:06:32 / cg"
!

isTraced
    "return true, if this is a wrapper method for a trace point.
     False is returned here - this method is redefined in WrappedMethod"

    ^ false

    "Created: 7.4.1997 / 17:24:50 / cg"
!

isUnloaded
    "return true, if the objects machine code has been unloaded
     from the system (i.e. it is not executable)."

    ^ self hasCode not

    "Created: / 16.4.1996 / 20:15:52 / cg"
    "Modified: / 13.11.1998 / 23:19:52 / cg"
!

isWrapped
    "return true, if this is a wrapper method.
     False is returned here - this method is redefined in WrappedMethod"

    ^ false

    "Created: 16.4.1996 / 16:33:24 / cg"
!

messagesSent
    ^ #()       "/ actually: unknown here in this abstract class
!

messagesSentToSelf
    ^ #()       "/ actually: unknown here in this abstract class
!

privacy
    "return a symbol describing the methods access rights (privacy);
     Currently, this is one of #private, #protected, #public or #ignored.

     Here we unconditionally return #public, to allow alien code objects
     to be handled by the browsers."

    ^ #public

    "Created: 16.4.1996 / 16:35:18 / cg"
!

referencesGlobal:aGlobalSymbol
    "return true, if this method references the global
     bound to aGlobalSymbol.
     Return false (we don't know) here, to allow alien code objects to be
     handled by the browsers."

    ^ false

    "Created: 16.4.1996 / 16:37:48 / cg"
!

referencesGlobalMatching:aMatchPattern
    "return true, if this method references a global
     whose name matches aMatchPattern.
     Return false (we don't know) here, to allow alien code objects to be
     handled by the browsers."

    ^ false

    "Created: / 9.11.1999 / 16:58:48 / cg"
!

referencesLiteral:aLiteral
    "return true, if this executable references the literal directly (i.e. a flat search).
     Return false (we don't know) here, to allow alien code objects to be
     handled by the browsers."

    ^ false

    "Modified: / 18.8.2000 / 21:18:43 / cg"
!

refersToLiteral:aLiteral
    "return true, if this executable references the literal directly or indirectly (i.e. a deep search).
     Return false (we don't know) here, to allow alien code objects to be
     handled by the browsers."

    ^ false

    "Modified: / 18.8.2000 / 21:18:03 / cg"
!

refersToLiteralMatching:aMatchPattern
    "return true if the receiver or recursively any array element in the
     receiver is symbolic and matches aMatchPattern (i.e. a deep search).
     Return false (we don't know) here, to allow alien code objects to be
     handled by the browsers."

    ^ false

    "Modified: / 18-08-2000 / 21:18:03 / cg"
    "Created: / 26-07-2012 / 15:38:26 / cg"
!

resources
    ^ nil

    "Created: / 3.11.1997 / 09:09:01 / cg"
!

sends:aSelectorSymbol
    "return true, if this code object contains a message-send with aSelectorSymbol as selector. 
     - due to the simple check in the literal array, also simple uses 
       of aSelectorSymbol as symbol will return true.
       Should ask compiler, if there is really a send."

    ^ self referencesLiteral:aSelectorSymbol

    "Created: 16.4.1996 / 16:35:53 / cg"
!

usedGlobals
    "return a collection with the global names referred to by the receiver.
     Uses Parser to parse methods source and extract them."

    ^ #()
! !

!ExecutableFunction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

