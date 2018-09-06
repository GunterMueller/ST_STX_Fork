"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/experiments' }"

"{ NameSpace: Smalltalk }"

JavaByteCodeProcessor subclass:#JavaByteCodeInterpreter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodeInterpreter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaByteCodeInterpreter class methodsFor:'interpretation'!

interpret:aMethod receiver:aReceiver arguments:argArray
    ^ self new interpret:aMethod receiver:aReceiver arguments:argArray
! !

!JavaByteCodeInterpreter methodsFor:'instructions'!

aaload
    "loads onto the stack a reference from an array
     stack: arrayref, index -> value
     args: nothing"
    
    | arrayref  index |

    index := self pop.
    arrayref := self pop.
    arrayref isNil ifTrue:[
        ^ JavaVM throwNullPointerException
    ].
    ^ self pushRef:(arrayref at:index + 1).

    "
     The arrayref must be of type reference and must refer to an array whose
     components are of type reference. The index must be of type int. Both arrayref
     and index are popped from the operand stack. The reference value in the component
     of the array at index is retrieved and pushed onto the operand stack.

     If arrayref is null, aaload throws a NullPointerException.
     Otherwise, if index is not within the bounds of the array referenced by arrayref,
     the aaload instruction throws an ArrayIndexOutOfBoundsException."

    "Modified: / 21-03-2011 / 17:20:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

aastore
    "stores into a reference in an array
     stack: arrayref, index, value -> nothing
     args: nothing"
    
    | arrayref  index  value |

    value := self pop.
    index := self pop.
    arrayref := self pop.
    arrayref isNil ifTrue:[
        ^ JavaVM throwNullPointerException
    ].
    arrayref at:index + 1 put:value.

    "
     The arrayref must be of type reference and must refer to an array whose components are of
     type reference. The index must be of type int and value must be of type reference. The arrayref,
     index, and value are popped from the operand stack. The reference value is stored as the
     component of the array at index.

     The type of value must be assignment compatible (Â§2.6.7) with the type of the components
     of the array referenced by arrayref. Assignment of a value of reference type S (source)
     to a variable of reference type T (target) is allowed only when the type S supports all
     the operations defined on type T. The detailed rules follow:

     If S is a class type, then:
     If T is a class type, then S must be the same class (Â§2.8.1) as T, or S must be a subclass of T;
     If T is an interface type, S must implement (Â§2.13) interface T.
     If S is an interface type, then:
     If T is a class type, then T must be Object (Â§2.4.7).
     If T is an interface type, then T must be the same interface as S or a superinterface of S (Â§2.13.2).

     If S is an array type, namely, the type SC[], that is, an array of components of type SC, then:
     If T is a class type, then T must be Object (Â§2.4.7).
     If T is an array type TC[], that is, an array of components of type TC, then one of the following must be true:
     TC and SC are the same primitive type (Â§2.4.1).
     TC and SC are reference types (Â§2.4.6), and type SC is assignable to TC by these runtime rules.
     If T is an interface type, T must be one of the interfaces implemented by arrays (Â§2.15).


     If arrayref is null, aastore throws a NullPointerException.
     Otherwise, if index is not within the bounds of the array referenced by arrayref,
     the aastore instruction throws an ArrayIndexOutOfBoundsException.
     Otherwise, if arrayref is not null and the actual type of value is not assignment
     compatible (Â§2.6.7) with the actual type of the components of the array, aastore
     throws an ArrayStoreException."

    "Modified: / 22-03-2011 / 12:27:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

aconst_null
    "
     Push null
     stack: nothing -> null
     args: nothing"
    
    self pushConstant: nil.

"
Description
Push the null object reference onto the operand stack.

Notes
The Java virtual machine does not mandate a concrete
value for null."

    "Created: / 24-02-2011 / 22:40:50 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 22:07:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2011 / 20:55:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

aload: idx 
    "Load reference from local variable
     nothing -> objectRef
     args: index"
    
    self pushRef: (context at: idx + 1).

    "Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (Â§3.6). The local variable at
     index must contain a reference. The objectref in the local variable
     at index is pushed onto the operand stack.

     Notes
     The aload instruction cannot be used to load a value of type returnAddress
     from a local variable onto the operand stack. This asymmetry with the
     astore instruction is intentional.
     The aload opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Modified: / 13-03-2011 / 20:59:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

anewarray
    "
       Create new array of reference
       stack: count -> arrayRef
       args: arrayType"
    
    | type  size |

    type := constantPool at: self fetchIndex2.
    size := self pop.

    self pushNewArrayOf: type sized: size.

    "
     Description
     The count must be of type int. It is popped off the operand stack. The count
     represents the number of components of the array to be created. The unsigned
     indexbyte1 and indexbyte2 are used to construct an index into the runtime
     constant pool of the current class (3.6), where the value of the index is
     (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at that index
     must be a symbolic reference to a class, array, or interface type. The named
     class, array, or interface type is resolved (5.4.3.1). A new array with components
     of that type, of length count, is allocated from the garbage-collected heap,
     and a reference arrayref to this new array object is pushed onto the operand
     stack. All components of the new array are initialized to null, the default
     value for reference types (2.5.1).

     Linking Exceptions
     During resolution of the symbolic reference to the class, array, or interface
     type, any of the exceptions documented in 5.4.3.1 can be thrown.

     Runtime Exception
     Otherwise, if count is less than zero, the anewarray instruction throws a
     NegativeArraySizeException.

     Notes
     The anewarray instruction is used to create a single dimension of an array of
     object references or part of a multidimensional array."

    "Created: / 14-03-2011 / 18:24:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2011 / 21:12:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

areturn
    "
     Return reference from method
     stack: objectRef -> empty
     args: nothing"
    
    self leaveProcessorWith: (self pop).

    "
     Description
     The objectref must be of type reference and must refer to an object of a type
     that is assignment compatible (Â§2.6.7) with the type represented by the return
     descriptor (Â§4.3.3) of the current method. If the current method is a synchronized
     method, the monitor acquired or reentered on invocation of the method is released
     or exited (respectively) as if by execution of a monitorexit instruction. If no
     exception is thrown, objectref is popped from the operand stack of the current
     frame (Â§3.6) and pushed onto the operand stack of the frame of the invoker. Any
     other values on the operand stack of the current method are discarded.
     The interpreter then reinstates the frame of the invoker and returns control to
     the invoker.

     Runtime Exceptions
     If the current method is a synchronized method and the current thread is not the
     owner of the monitor acquired or reentered on invocation of the method, areturn
     throws an IllegalMonitorStateException. This can happen, for example, if a synchronized
     method contains a monitorexit instruction, but no monitorenter instruction, on the object
     on which the method is synchronized.
     Otherwise, if the virtual machine implementation enforces the rules on structured use
     of locks described in Â§8.13 and if the first of those rules is violated during invocation
     of the current method, then areturn throws an IllegalMonitorStateException."
    "Created: / 14-03-2011 / 13:45:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

arraylength
    "
     Get length of array
     stack: arrayRef -> length
     args: nothing"
    self pushInt: self pop size.

    "
     Description
     The arrayref must be of type reference and must refer to an array. It is
     popped from the operand stack. The length of the array it references is
     determined. That length is pushed onto the operand stack as an int.

     Runtime Exception
     If the arrayref is null, the arraylength instruction throws a NullPointerException."

    "Created: / 14-03-2011 / 18:41:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

astore: idx 
    "
     stores a reference into a local variable #index
     stack: objectref -> nothing
     args: index"
    
    context at: idx + 1 put: (self pop).

    "Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The objectref on the
     top of the operand stack must be of type returnAddress or of type
     reference. It is popped from the operand stack, and the value of
     the local variable at index is set to objectref.

     Notes
     The astore instruction is used with an objectref of type returnAddress
     when implementing the finally clauses of the Java programming language
     (see Section 7.13, Compiling finally). The aload instruction cannot be
     used to load a value of type returnAddress from a local variable onto
     he operand stack. This asymmetry with the astore instruction is intentional.
     The astore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Modified: / 13-03-2011 / 16:57:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

athrow
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

baload
    self halt
!

bastore
    self halt
!

bipush
    "
     pushes a byte onto the stack as an integer value
     stack: nothing -> value
     args: byte"
    
    self pushInt: (self fetchByte).

    "
     The immediate byte is sign-extended to an int value. That value is pushed onto the operand stack.
"

    "Modified: / 13-03-2011 / 16:58:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

breakpoint
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

caload
    self halt
!

castore
    self halt
!

checkcast
    "
     Check whether object is of given type
     stack: objref -> objRef
     args: indexByte1 indexByte2"
    
    | classRef  obj |
    classRef := constantPool at: self fetchIndex2.
    obj := self pop.
    self pushRef: (JavaVM _CHECKCAST_R: obj _: classRef).

    "
     Description
     The objectref must be of type reference. The unsigned indexbyte1 and indexbyte2 are used to
     construct an index into the runtime constant pool of the current class (Â§3.6), where the value
     of the index is (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at the index
     must be a symbolic reference to a class, array, or interface type. The named class, array,
     or interface type is resolved (Â§5.4.3.1).
     If objectref is null or can be cast to the resolved class, array, or interface type, the
     operand stack is unchanged; otherwise, the checkcast instruction throws a ClassCastException.
     The following rules are used to determine whether an objectref that is not null can be cast
     to the resolved type: if S is the class of the object referred to by objectref and T is the
     resolved class, array, or interface type, checkcast determines whether objectref can be cast
     to type T as follows:
     If S is an ordinary (nonarray) class, then:
     If T is a class type, then S must be the same class (Â§2.8.1) as T, or a subclass of T.
     If T is an interface type, then S must implement (Â§2.13) interface T.
     If S is an interface type, then:
     If T is a class type, then T must be Object (Â§2.4.7).
     If T is an interface type, then T must be the same interface as S or a superinterface
     of S (Â§2.13.2).
     If S is a class representing the array type SC[], that is, an array of components of
     type SC, then:
     If T is a class type, then T must be Object (Â§2.4.7).
     If T is an array type TC[], that is, an array of components of type TC, then one of the
     following must be true:
     TC and SC are the same primitive type (Â§2.4.1).
     TC and SC are reference types (Â§2.4.6), and type SC can be cast to TC by recursive
     application of these rules.
     If T is an interface type, T must be one of the interfaces implemented by arrays (Â§2.15).
     Linking Exceptions
     During resolution of the symbolic reference to the class, array, or interface type, any of the
     exceptions documented in Section 5.4.3.1 can be thrown.

     Runtime Exception
     Otherwise, if objectref cannot be cast to the resolved class, array, or interface type,
     the checkcast instruction throws a ClassCastException.

     Notes
     The checkcast instruction is very similar to the instanceof instruction. It differs in
     its treatment of null, its behavior when its test fails (checkcast throws an exception,
     instanceof pushes a result code), and its effect on the operand stack."

    "Modified: / 21-03-2011 / 18:15:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2016 / 00:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

d2f
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

d2i
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

d2l
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dadd
    "
     adds two doubles together
     stack: value1, value2 -> result
     args: nothing"
    
    self pushDouble: (self pop + self pop).

"
Description
Both value1 and value2 must be of type double. The values are popped from the operand 
stack and undergo value set conversion (3.8.3), resulting in value1' and value2'. 
The double result is value1' + value2'. The result is pushed onto the operand stack.
The result of a dadd instruction is governed by the rules of IEEE arithmetic:
If either value1' or value2' is NaN, the result is NaN.
The sum of two infinities of opposite sign is NaN.
The sum of two infinities of the same sign is the infinity of that sign.
The sum of an infinity and any finite value is equal to the infinity.
The sum of two zeroes of opposite sign is positive zero.
The sum of two zeroes of the same sign is the zero of that sign.
The sum of a zero and a nonzero finite value is equal to the nonzero value.
The sum of two nonzero finite values of the same magnitude and opposite sign is 
positive zero.
In the remaining cases, where neither operand is an infinity, a zero, or NaN and 
the values have the same sign or have different magnitudes, the sum is computed 
and rounded to the nearest representable value using IEEE 754 round to nearest mode. 
If the magnitude is too large to represent as a double, we say the operation overflows; 
the result is then an infinity of appropriate sign. If the magnitude is too small to 
represent as a double, we say the operation underflows; the result is then a zero of 
appropriate sign.
The Java virtual machine requires support of gradual underflow as defined by IEEE 754. 
Despite the fact that overflow, underflow, or loss of precision may occur, execution 
of a dadd instruction never throws a runtime exception.
"

    "Created: / 14-03-2011 / 20:53:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

daload
    "
     Load double from array
     stack: arrayRef index -> value
     args: nothing"
    
    self swap.
    self pushDouble: (self pop at: (self pop + 1)).

"
Description
The arrayref must be of type reference and must refer to an array whose components are of 
type double. The index must be of type int. Both arrayref and index are popped from the 
operand stack. The double value in the component of the array at index is retrieved and 
pushed onto the operand stack.

Runtime Exceptions
If arrayref is null, daload throws a NullPointerException.
Otherwise, if index is not within the bounds of the array referenced by arrayref, the 
daload instruction throws an ArrayIndexOutOfBoundsException.
"

    "Modified: / 14-03-2011 / 20:52:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dastore
    self halt
!

dcmpg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dcmpl
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dconst: arg 
    self pushDouble: arg.

    "Created: / 14-03-2011 / 18:01:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ddiv
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dload: idx 
"
Load double from local variable
stack: nothing -> value
args: index
"
    self pushDouble: (context at: idx + 1).

"
Description
The index is an unsigned byte. Both index and index + 1 must be indices into the local 
variable array of the current frame (3.6). The local variable at index must contain a 
double. The value of the local variable at index is pushed onto the operand stack.

Notes
The dload opcode can be used in conjunction with the wide instruction to access a local 
variable using a two-byte unsigned index.
"

    "Modified: / 13-03-2011 / 16:59:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dmul
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dneg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

drem
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dreturn
    "
     Return double from method
     stack: value -> empty
     args: nothing"
    
    self leaveProcessorWith: (self popDouble).

    "
     Description
     The current method must have return type double. The value must be of
     type double. If the current method is a synchronized method, the monitor
     acquired or reentered on invocation of the method is released or exited
     (respectively) as if by execution of a monitorexit instruction. If no
     exception is thrown, value is popped from the operand stack of the current
     frame (Â§3.6) and undergoes value set conversion (Â§3.8.3), resulting in
     value'. The value' is pushed onto the operand stack of the frame of the
     invoker. Any other values on the operand stack of the current method are
     discarded.
     The interpreter then returns control to the invoker of the method,
     reinstating the frame of the invoker.

     Runtime Exceptions
     If the current method is a synchronized method and the current thread
     is not the owner of the monitor acquired or reentered on invocation of
     the method, dreturn throws an IllegalMonitorStateException. This can
     happen, for example, if a synchronized method contains a monitorexit
     instruction, but no monitorenter instruction, on the object on which
     the method is synchronized.
     Otherwise, if the virtual machine implementation enforces the rules
     on structured use of locks described in Â§8.13 and if the first of
     those rules is violated during invocation of the current method,
     then dreturn throws an IllegalMonitorStateException."
    "Created: / 14-03-2011 / 13:33:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 18:04:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore
    "
     Store double into local variable
     stack: value -> nothing
     args: index"
    
    context at: self fetchIndex put: (self popDouble).

    "
     Description
     The index is an unsigned byte. Both index and index + 1 must be indices
     into the local variable array of the current frame (3.6). The value on
     the top of the operand stack must be of type double. It is popped from
     the operand stack and undergoes value set conversion (3.8.3), resulting
     in value'. The local variables at index and index + 1 are set to value'.

     Notes
     The dstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 18:04:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore: idx 
    "
     Store double into local variable
     stack: value -> nothing
     args: index"
    
    context at: idx + 1 put: (self popDouble).

    "
     Description
     The index is an unsigned byte. Both index and index + 1 must be indices
     into the local variable array of the current frame (3.6). The value on
     the top of the operand stack must be of type double. It is popped from
     the operand stack and undergoes value set conversion (3.8.3), resulting
     in value'. The local variables at index and index + 1 are set to value'.

     Notes
     The dstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Modified: / 14-03-2011 / 18:04:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dsub
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

dup
"
Duplicate the top operand stack value
stack: value -> value value
args: nothing
"
self pushRef: self tos.

"
Description
Duplicate the top value on the operand stack and push the duplicated value onto the operand stack.
The dup instruction must not be used unless value is a value of a category 1 computational type (3.11.1).
"

    "Modified: / 27-03-2011 / 21:19:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2
"
Duplicate the top one or two operand stack values
stack v 1: value2 value1 -> value2 value 1 value2 value1            where both value1 and value2 are values of a category 1 computational type (3.11.1).
stack v 2: value1 -> value1 value1                                  where value is a value of a category 2 computational type (3.11.1).
args: nothing
"
    | tos |

    tos := self popLong.
    self pushLong: tos.
    self pushLong: tos.
    self breakPoint:#mh_instructions.
"
Description
Duplicate the top one or two values on the operand stack and 
push the duplicated value or values back onto the operand 
stack in the original order.
"

    "Modified: / 13-03-2011 / 17:03:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2_x1
    self halt
!

dup2_x2
    self halt
!

dup_x1
    self halt
!

dup_x2
    self halt
!

f2d
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

f2i
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

f2l
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fadd
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

faload
    self halt
!

fastore
    self halt
!

fcmpg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fcmpl
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fconst: arg 
    self pushFloat: arg.

    "Created: / 14-03-2011 / 17:57:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fdiv
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fload: idx 
"
Load float from local variable
stack: nothing -> value
args: index
"
    self pushFloat: (context at: idx + 1).

"
Description
The index is an unsigned byte that must be an index into the local 
variable array of the current frame (3.6). The local variable at 
index must contain a float. The value of the local variable at index 
is pushed onto the operand stack.

Notes
The fload opcode can be used in conjunction with the wide instruction 
to access a local variable using a two-byte unsigned index.
"

    "Modified: / 13-03-2011 / 17:05:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fmul
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fneg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

frem
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

freturn
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fstore
    "
     Store float into local variable
     stack: value -> nothing
     args: index"
    
    self fstore: self fetchIndex.

    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 18:01:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore: idx 
"
Store float into local variable
stack: value -> nothing
args: index
"
    context at: idx + 1 put: (self pop).

"
Description
The index is an unsigned byte that must be an index into the local 
variable array of the current frame (3.6). The value on the top of 
the operand stack must be of type float. It is popped from the operand 
stack and undergoes value set conversion (3.8.3), resulting in value'. 
The value of the local variable at index is set to value'.

Notes
The fstore opcode can be used in conjunction with the wide instruction 
to access a local variable using a two-byte unsigned index.
"

    "Modified: / 13-03-2011 / 17:06:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fsub
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

getfield
    "gets a field value of an object objectref, where the field is 
     identified by field reference in the constant pool index (index1 << 8 + index2)
     stack: objectRef -> value
     args: indexByte1 indexByte2"
    
    | fieldref  object |

    object := self pop.
    fieldref := constantPool at: self fetchIndex2.
    fieldref resolve.
    self pushRef: (object instVarAt: fieldref resolvedOffset)

    "
     Description
     The objectref, which must be of type reference, is popped from the operand stack.
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into the
     runtime constant pool of the current class (Â§3.6), where the value of the index
     is (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at that index
     must be a symbolic reference to a field (Â§5.1), which gives the name and
     descriptor of the field as well as a symbolic reference to the class in which
     the field is to be found. The referenced field is resolved (Â§5.4.3.2). The value
     of the referenced field in objectref is fetched and pushed onto the operand stack.
     The class of objectref must not be an array. If the field is protected (Â§4.6),
     and it is either a member of the current class or a member of a superclass of
     the current class, then the class of objectref must be either the current class
     or a subclass of the current class.

     Linking Exceptions
     During resolution of the symbolic reference to the field, any of the errors
     pertaining to field resolution documented in Section 5.4.3.2 can be thrown.
     Otherwise, if the resolved field is a static field, getfield throws an
     IncompatibleClassChangeError.

     Runtime Exception
     Otherwise, if objectref is null, the getfield instruction throws a NullPointerException.

     Notes
     The getfield instruction cannot be used to access the length field of an array.
     The arraylength instruction is used instead."

    "Created: / 10-03-2011 / 23:34:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-06-2011 / 18:12:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2016 / 07:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getstatic
    "
     Get static field from class
     stack: .. -> value
     args: indexByte1 indexByte2"
    
    | fieldRef |
    fieldRef := constantPool at: self fetchIndex2.
    fieldRef resolve.
    self pushRef: (fieldRef javaClass instVarAt: fieldRef resolvedOffset).

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into the
     runtime constant pool of the current class (3.6), where the value of the index
     is (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at that index
     must be a symbolic reference to a field (5.1), which gives the name and descriptor
     of the field as well as a symbolic reference to the class or interface in which the
     field is to be found. The referenced field is resolved (5.4.3.2).
     On successful resolution of the field, the class or interface that declared the
     resolved field is initialized (5.5) if that class or interface has not already
     been initialized.
     The value of the class or interface field is fetched and pushed onto the operand stack.

     Linking Exceptions
     During resolution of the symbolic reference to the class or interface field,
     any of the exceptions pertaining to field resolution documented in Section 5.4.3.2
     can be thrown.
     Otherwise, if the resolved field is not a static (class) field or an interface field,
     getstatic throws an IncompatibleClassChangeError.

     Runtime Exception
     Otherwise, if execution of this getstatic instruction causes initialization of the
     referenced class or interface, getstatic may throw an Error as detailed in Section 2.17.5."

    "Modified: / 08-12-2011 / 19:24:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2016 / 07:41:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

goto
    "
     Branch always
     stack: nothing -> nothing
     args: branchByte1 branchByte2"
    
    self relativeJump: self fetchBytes2.

    "
     Description
     The unsigned bytes branchbyte1 and branchbyte2 are used to construct a signed 16-bit
     branchoffset, where branchoffset is (branchbyte1 << 8) | branchbyte2. Execution proceeds
     at that offset from the address of the opcode of this goto instruction. The target
     address must be that of an opcode of an instruction within the method that contains
     this goto instruction."

    "Created: / 14-03-2011 / 20:21:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

goto_w
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

i2d
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

i2f
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

i2l
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

i_dup
    self pushInt: (self tos).

    "Modified: / 13-03-2011 / 16:40:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iadd
    "
     adds two ints together
     stack: value1, value2 -> result
     args: nothing"
    self pushInt: (self pop + self pop).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped
     from the operand stack. The int result is value1 + value2. The result
     is pushed onto the operand stack.
     The result is the 32 low-order bits of the true mathematical result
     in a sufficiently wide two's-complement format, represented as a value
     of type int. If overflow occurs, then the sign of the result may not be
     the same as the sign of the mathematical sum of the two values.
     Despite the fact that overflow may occur, execution of an iadd instruction
     never throws a runtime exception."

    "Created: / 06-03-2011 / 21:23:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 21:51:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iaload
    "
     Load int from array
     stack: arrayRef index -> value
     args: nothing"
    
    self swap.
    self pushInt: (self pop at: (self pop + 1)).

    "
     Description
     The arrayref must be of type reference and must refer to an array whose
     components are of type int. The index must be of type int. Both arrayref
     and index are popped from the operand stack. The int value in the
     component of the array at index is retrieved and pushed onto the operand
     stack.

     Runtime Exceptions
     If arrayref is null, iaload throws a NullPointerException.
     Otherwise, if index is not within the bounds of the array referenced by
     arrayref, the iaload instruction throws an ArrayIndexOutOfBoundsException."

    "Modified: / 14-03-2011 / 20:20:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iand
"
Boolean AND int
stack: val1 val2 -> result
args: nothing
"
self pushInt:(self pop bitAnd: self pop).
"
Both value1 and value2 must be of type int. They are popped from the 
operand stack. An int result is calculated by taking the bitwise AND 
(conjunction) of value1 and value2. The result is pushed onto the 
operand stack.
"

    "Created: / 14-03-2011 / 17:10:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iastore
    self halt
!

iconst: arg
    self pushInt: arg.

    "Created: / 20-03-2011 / 23:35:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

idiv
    "
     Divide int
     stack: value1 value2 -> result
     args: nothing"
    self swap.
    self pushInt: (self pop // self pop).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped from the operand stack.
     The int result is the value of the Java programming language expression value1 / value2.
     The result is pushed onto the operand stack.
     An int division rounds towards 0; that is, the quotient produced for int values in n/d is
     an int value q whose magnitude is as large as possible while satisfying . Moreover, q is
     positive when  and n and d have the same sign, but q is negative when  and n and d have
     opposite signs.
     There is one special case that does not satisfy this rule: if the dividend is the negative
     integer of largest possible magnitude for the int type, and the divisor is -1, then overflow
     occurs, and the result is equal to the dividend. Despite the overflow, no exception is thrown
     in this case.

     Runtime Exception
     If the value of the divisor in an int division is 0, idiv throws an ArithmeticException."

    "Created: / 14-03-2011 / 17:50:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifacmpeq
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

ifacmpne
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

ifeq
    "
     if true, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self pop = 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value  0
     lt succeeds if and only if value < 0
     le succeeds if and only if value  0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value  0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 14-03-2011 / 18:47:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifge
    "
     if true, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self pop >= 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value  0
     lt succeeds if and only if value < 0
     le succeeds if and only if value  0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value  0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 14-03-2011 / 18:48:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifgt
    "
     if true, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self pop > 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value  0
     lt succeeds if and only if value < 0
     le succeeds if and only if value  0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value  0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 14-03-2011 / 18:48:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpeq
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    (self pop = self pop) ifTrue: [ self relativeJump: dest ].

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1  value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1  value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 18:49:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpge
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self swap.
    (self pop >= self pop) ifTrue: [ self relativeJump: dest ]

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1 <= value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1 >= value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 18:52:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpgt
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self swap.
    (self pop > self pop) ifTrue: [ self relativeJump: dest ]

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1 <= value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1 >= value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 21:00:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmple
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self swap.
    (self pop <= self pop) ifTrue: [ self relativeJump: dest ]

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1 <= value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1 >= value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 21:00:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmplt
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self swap.
    (self pop < self pop) ifTrue: [ self relativeJump: dest ]

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1 <= value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1 >= value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 21:00:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ificmpne
    "
     Branch if int comparison succeeds
     stack: value1 value2 -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    (self pop ~= self pop) ifTrue: [ self relativeJump: dest ].

    "
     Description
     Both value1 and value2 must be of type int. They are both popped from
     the operand stack and compared. All comparisons are signed. The results
     of the comparison are as follows:
     eq succeeds if and only if value1 = value2
     ne succeeds if and only if value1 ~= value2
     lt succeeds if and only if value1 < value2
     le succeeds if and only if value1  value2
     gt succeeds if and only if value1 > value2
     ge succeeds if and only if value1  value2
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2 are
     used to construct a signed 16-bit offset, where the offset is calculated
     to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds at that
     offset from the address of the opcode of this if_icmp<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if_icmp<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if_icmp<cond> instruction."

    "Created: / 14-03-2011 / 20:59:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifle
    "
     if true, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self pop <= 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value  0
     lt succeeds if and only if value < 0
     le succeeds if and only if value  0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value  0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 14-03-2011 / 18:48:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iflt
    "
     if true, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    
    | dest |

    dest := self fetchBytes2.
    self pop < 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value  0
     lt succeeds if and only if value < 0
     le succeeds if and only if value  0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value  0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 14-03-2011 / 18:47:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifne
    "
     if value is not 0, branch to instruction at branchoffset (signed short constructed from unsigned bytes branchbyte1 << 8 + branchbyte2)
     stack: value -> nothing
     args: branchByte1 branchByte2"
    "/ -1 in block - because we already increased pc to point to the next instruction
    
    | dest |

    dest := self fetchBytes2.
    self pop ~= 0 ifTrue: [ self relativeJump: dest ].

    "
     The value must be of type int. It is popped from the operand stack and
     compared against zero. All comparisons are signed. The results of the
     comparisons are as follows:
     eq succeeds if and only if value = 0
     ne succeeds if and only if value ~= 0
     lt succeeds if and only if value < 0
     le succeeds if and only if value <= 0
     gt succeeds if and only if value > 0
     ge succeeds if and only if value >= 0
     If the comparison succeeds, the unsigned branchbyte1 and branchbyte2
     are used to construct a signed 16-bit offset, where the offset is
     calculated to be (branchbyte1 << 8) | branchbyte2. Execution then proceeds
     at that offset from the address of the opcode of this if<cond> instruction.
     The target address must be that of an opcode of an instruction within the
     method that contains this if<cond> instruction.
     Otherwise, execution proceeds at the address of the instruction following
     this if<cond> instruction."

    "Created: / 06-03-2011 / 22:57:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:20:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifnonnull
    | value target |

    value := self pop.
    target := self fetchIndex2.
    value notNil ifTrue:[
        self relativeJump: target.
    ]

    "Modified: / 16-03-2016 / 00:18:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ifnull
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

iinc
"
Increment local variable by constant
stack: nothing -> nothing
args: index const
"
| index  const |

    index := self fetchIndex.
    const := self fetchByte.
    context at: index + 1 put: ((context at: index + 1) + const).    
"
Description
The index is an unsigned byte that must be an index into the local variable 
array of the current frame (3.6). The const is an immediate signed byte. 
The local variable at index must contain an int. The value const is first 
sign-extended to an int, and then the local variable at index is incremented 
by that amount.

Notes
The iinc opcode can be used in conjunction with the wide instruction to access 
a local variable using a two-byte unsigned index and to increment it by a two-byte 
immediate value.
"

    "Created: / 14-03-2011 / 17:22:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload: idx 
    "
     loads an int value from a local variable #index
     stack: nothing -> value
     args: index"
    
    self pushInt: (context at: idx + 1).

    "
     The index is an unsigned byte that must be an index into the local variable array
     of the current frame (Â§3.6). The local variable at index must contain an int.
     The value of the local variable at index is pushed onto the operand stack.

     Notes
     The iload opcode can be used in conjunction with the wide instruction to
     access a local variable using a two-byte unsigned index."

    "Modified: / 17-03-2011 / 17:33:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

imul
    "multiply two integers
     stack: value1, value2 -> result
     args: nothing"
    
    self pushInt: (self pop * self pop).

"
Both value1 and value2 must be of type int. The values are popped
from the operand stack. The int result is value1 * value2. The result
is pushed onto the operand stack.
The result is the 32 low-order bits of the true mathematical result
in a sufficiently wide two's-complement format, represented as a value
of type int. If overflow occurs, then the sign of the result may not
be the same as the sign of the mathematical sum of the two values.
Despite the fact that overflow may occur, execution of an imul
instruction never throws a runtime exception."

    "Created: / 06-03-2011 / 22:42:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:24:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ineg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

instanceof
    "Determine if object is of given type
     Operand ..., objectref
     Stack ..., "

    | classRef  obj |
    classRef := constantPool at: self fetchIndex2.
    obj := self pop.
    JavaVM _INSTANCEOF_R: obj _: classRef

    "Modified: / 02-03-2016 / 07:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

int2byte
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

int2char
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

int2short
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

invinterface
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

invnonvirt
    "
     Invoke instance method; special handling for superclass, private, and instance initialization method invocations
     stack: objRef [args] -> ..
     args: indexByte1 indexByte2"
    
    | methodRef methodToBeInvoked  methodReceiver  methodNumArgs  methodArgs  result |

    methodRef := constantPool at: self fetchIndex2.
    methodToBeInvoked := methodRef resolve.
    methodNumArgs := methodToBeInvoked javaNumArgs.
    methodArgs := Array new: methodNumArgs.
    methodNumArgs to: 1
        by: -1
        do: [:index | methodArgs at: index put: self pop ].
    methodReceiver := self pop.
    result := self 
                interpretInner: methodToBeInvoked
                receiver: methodReceiver
                arguments: methodArgs.
    methodToBeInvoked returnsDouble ifTrue:[
        self pushDouble: result
    ] ifFalse:[ 
        methodToBeInvoked returnsLong ifTrue:[ 
            self pushLong: result  
        ] ifFalse:[ 
            methodToBeInvoked returnsVoid ifFalse: [
                self pushRef: result
            ]
        ]
    ].   

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into the runtime constant pool
     of the current class (Â§3.6), where the value of the index is (indexbyte1 << 8) | indexbyte2. The
     runtime constant pool item at that index must be a symbolic reference to a method (Â§5.1), which gives
     the name and descriptor (Â§4.3.3) of the method as well as a symbolic reference to the class in which
     the method is to be found. The named method is resolved (Â§5.4.3.3). Finally, if the resolved method
     is protected (Â§4.6), and it is either a member of the current class or a member of a superclass of
     the current class, then the class of objectref must be either the current class or a subclass of the
     current class.
     Next, the resolved method is selected for invocation unless all of the following conditions are true:
     The ACC_SUPER flag (see Table 4.1, Class access and property modifiers) is set for the current class.
     The class of the resolved method is a superclass of the current class.
     The resolved method is not an instance initialization method (Â§3.9).
     If the above conditions are true, the actual method to be invoked is selected by the following lookup
     procedure. Let C be the direct superclass of the current class:
     If C contains a declaration for an instance method with the same name and descriptor as the resolved
     method, then this method will be invoked. The lookup procedure terminates.
     Otherwise, if C has a superclass, this same lookup procedure is performed recursively using the direct
     superclass of C. The method to be invoked is the result of the recursive invocation of this lookup
     procedure.
     Otherwise, an AbstractMethodError is raised.
     The objectref must be of type reference and must be followed on the operand stack by nargs argument
     values, where the number, type, and order of the values must be consistent with the descriptor of the
     selected instance method.
     If the method is synchronized, the monitor associated with objectref is acquired or reentered.
     If the method is not native, the nargs argument values and objectref are popped from the operand stack.
     A new frame is created on the Java virtual machine stack for the method being invoked. The objectref
     and the argument values are consecutively made the values of local variables of the new frame, with
     objectref in local variable 0, arg1 in local variable 1 (or, if arg1 is of type long or double, in
     local variables 1 and 2), and so on. Any argument value that is of a floating-point type undergoes
     value set conversion (Â§3.8.3) prior to being stored in a local variable. The new frame is then made
     current, and the Java virtual machine pc is set to the opcode of the first instruction of the method
     to be invoked. Execution continues with the first instruction of the method.
     If the method is native and the platform-dependent code that implements it has not yet been bound (Â§5.6)
     into the Java virtual machine, that is done. The nargs argument values and objectref are popped from
     the operand stack and are passed as parameters to the code that implements the method. Any argument
     value that is of a floating-point type undergoes value set conversion (Â§3.8.3) prior to being passed
     as a parameter. The parameters are passed and the code is invoked in an implementation-dependent
     manner. When the platform-dependent code returns, the following take place:
     If the native method is synchronized, the monitor associated with objectref is released or exited as
     if by execution of a monitorexit instruction.
     If the native method returns a value, the return value of the platform-dependent code is converted in
     an implementation-dependent way to the return type of the native method and pushed onto the operand stack.
     Linking Exceptions
     During resolution of the symbolic reference to the method, any of the exceptions pertaining to method
     resolution documented in Section 5.4.3.3 can be thrown.
     Otherwise, if the resolved method is an instance initialization method, and the class in which it is
     declared is not the class symbolically referenced by the instruction, a NoSuchMethodError is thrown.
     Otherwise, if the resolved method is a class (static) method, the invokespecial instruction throws an
     IncompatibleClassChangeError.
     Otherwise, if no method matching the resolved name and descriptor is selected, invokespecial throws
     an AbstractMethodError.
     Otherwise, if the selected method is abstract, invokespecial throws an AbstractMethodError.

     Runtime Exceptions
     Otherwise, if objectref is null, the invokespecial instruction throws a NullPointerException.
     Otherwise, if the selected method is native and the code that implements the method cannot be bound,
     invokespecial throws an UnsatisfiedLinkError.

     Notes
     The difference between the invokespecial and the invokevirtual instructions is that invokevirtual
     invokes a method based on the class of the object. The invokespecial instruction is used to invoke
     instance initialization methods (Â§3.9) as well as private methods and methods of a superclass of
     the current class.
     The invokespecial instruction was named invokenonvirtual prior to Sun's JDK release 1.0.2.
     The nargs argument values and objectref are not one-to-one with the first nargs + 1 local variables.
     Argument values of types long and double must be stored in two consecutive local variables, thus more
     than nargs local variables may be required to pass nargs argument values to the invoked method."

    "Modified: / 31-03-2011 / 16:34:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2016 / 00:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invstatic
    "
     Invoke a class (static) method
     stack: [arg1 [args2 ...]] -> nothing
     args: indexByte1 indexByte2"
    
    | methodToBeInvoked  methodNumArgs  args  argSignatures  result |

    methodToBeInvoked := (constantPool at:self fetchIndex2) resolve.
    methodToBeInvoked isNil ifTrue:[
        self halt
    ].
    methodNumArgs := methodToBeInvoked javaNumArgs.
    argSignatures := methodToBeInvoked argSignature.
    args := Array new:methodNumArgs.
    methodNumArgs to:1 by:-1 do:[:index | 
        args at:index put:self pop
    ].
    result := self 
            interpretInner:methodToBeInvoked
            receiver:methodToBeInvoked javaClass
            arguments:args.
    methodToBeInvoked returnsDouble ifTrue:[
        self pushDouble: result
    ] ifFalse:[ 
        methodToBeInvoked returnsLong ifTrue:[ 
            self pushLong: result  
        ] ifFalse:[ 
            methodToBeInvoked returnsVoid ifFalse: [
                self pushRef: result
            ]
        ]
    ]. 

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into the
     runtime constant pool of the current class (Â§3.6), where the value of the index is
     (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at that index must
     be a symbolic reference to a method (Â§5.1), which gives the name and descriptor (Â§4.3.3)
     of the method as well as a symbolic reference to the class in which the method is to
     be found. The named method is resolved (Â§5.4.3.3). The method must not be the class
     or interface initialization method (Â§3.9). It must be static, and therefore cannot be
     abstract.
     On successful resolution of the method, the class that declared the resolved field is
     initialized (Â§5.5) if that class has not already been initialized.
     The operand stack must contain nargs argument values, where the number, type, and order
     of the values must be consistent with the descriptor of the resolved method.
     If the method is synchronized, the monitor associated with the resolved class is acquired
     or reentered.
     If the method is not native, the nargs argument values are popped from the operand stack.
     A new frame is created on the Java virtual machine stack for the method being invoked.
     The nargs argument values are consecutively made the values of local variables of the
     new frame, with arg1 in local variable 0 (or, if arg1 is of type long or double, in local
     variables 0 and 1) and so on. Any argument value that is of a floating-point type undergoes
     value set conversion (Â§3.8.3) prior to being stored in a local variable. The new frame is
     then made current, and the Java virtual machine pc is set to the opcode of the first
     nstruction of the method to be invoked. Execution continues with the first instruction
     of the method.
     If the method is native and the platform-dependent code that implements it has not yet
     been bound (Â§5.6) into the Java virtual machine, that is done. The nargs argument values
     are popped from the operand stack and are passed as parameters to the code that
     implements the method. Any argument value that is of a floating-point type undergoes
     value set conversion (Â§3.8.3) prior to being passed as a parameter. The parameters are
     passed and the code is invoked in an implementation-dependent manner. When the
     platform-dependent code returns, the following take place:
     If the native method is synchronized, the monitor associated with the resolved class
     is released or exited as if by execution of a monitorexit instruction.
     If the native method returns a value, the return value of the platform-dependent code
     is converted in an implementation-dependent way to the return type of the native
     method and pushed onto the operand stack.
     Linking Exceptions
     During resolution of the symbolic reference to the method, any of the exceptions
     pertaining to method resolution documented in Section 5.4.3.3 can be thrown.
     Otherwise, if the resolved method is an instance method, the invokestatic instruction
     throws an IncompatibleClassChangeError.

     Runtime Exceptions
     Otherwise, if execution of this invokestatic instruction causes initialization of the
     referenced class, invokestatic may throw an Error as detailed in Section 2.17.5.
     Otherwise, if the resolved method is native and the code that implements the method
     cannot be bound, invokestatic throws an UnsatisfiedLinkError.

     Notes
     The nargs argument values are not one-to-one with the first nargs local variables.
     Argument values of types long and double must be stored in two consecutive local variables,
     thus more than nargs local variables may be required to pass nargs argument values to
     the invoked method."

    "Created: / 24-02-2011 / 10:37:05 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 25-02-2011 / 00:18:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-06-2011 / 18:13:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2016 / 00:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invvirt
    "
     Invoke instance method; dispatch based on class
     stack: objRef args -> ..
     args: indexByte1 indexByte2"
    
    | methodOwner  methodRef  resolvedMethod  methodNumArgs  args  result |

    methodRef := constantPool at: self fetchIndex2.
    resolvedMethod := methodRef resolve.
    methodNumArgs := resolvedMethod javaNumArgs.
    args := Array new: methodNumArgs.
    methodNumArgs to: 1 by: -1 do: [
        :index | 
        args at: index put: self pop
    ].
    methodOwner := self pop.      
    result := self 
                interpretInner: (methodOwner class lookupMethodFor: resolvedMethod selector)
                receiver: methodOwner
                arguments: args.
    resolvedMethod returnsDouble ifTrue:[
        self pushDouble: result
    ] ifFalse:[ 
        resolvedMethod returnsLong ifTrue:[ 
            self pushLong: result  
        ] ifFalse:[ 
            resolvedMethod returnsVoid ifFalse: [
                self pushRef: result
            ]
        ]
    ].

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into the
     runtime constant pool of the current class (Â§3.6), where the value of the index
     is (indexbyte1 << 8) | indexbyte2. The runtime constant pool item at that index
     must be a symbolic reference to a method (Â§5.1), which gives the name and descriptor
     (Â§4.3.3) of the method as well as a symbolic reference to the class in which the
     method is to be found. The named method is resolved (Â§5.4.3.3). The method must
     not be an instance initialization method (Â§3.9) or the class or interface
     initialization method (Â§3.9). Finally, if the resolved method is protected (Â§4.6),
     and it is either a member of the current class or a member of a superclass of the
     current class, then the class of objectref must be either the current class or a
     subclass of the current class.
     Let C be the class of objectref. The actual method to be invoked is selected by
     the following lookup procedure:
     If C contains a declaration for an instance method with the same name and descriptor
     as the resolved method, and the resolved method is accessible from C, then this is
     the method to be invoked, and the lookup procedure terminates.
     Otherwise, if C has a superclass, this same lookup procedure is performed recursively
     using the direct superclass of C ; the method to be invoked is the result of the
     recursive invocation of this lookup procedure.
     Otherwise, an AbstractMethodError is raised.
     The objectref must be followed on the operand stack by nargs argument values,
     where the number, type, and order of the values must be consistent with the descriptor
     of the selected instance method.
     If the method is synchronized, the monitor associated with objectref is acquired or
     reentered.
     If the method is not native, the nargs argument values and objectref are popped from
     the operand stack. A new frame is created on the Java virtual machine stack for the
     method being invoked. The objectref and the argument values are consecutively made
     the values of local variables of the new frame, with objectref in local variable 0,
     arg1 in local variable 1 (or, if arg1 is of type long or double, in local variables 1
     and 2), and so on. Any argument value that is of a floating-point type undergoes
     value set conversion (Â§3.8.3) prior to being stored in a local variable. The new
     frame is then made current, and the Java virtual machine pc is set to the opcode
     of the first instruction of the method to be invoked. Execution continues with the
     first instruction of the method.
     If the method is native and the platform-dependent code that implements it has not
     yet been bound (Â§5.6) into the Java virtual machine, that is done. The nargs argument
     values and objectref are popped from the operand stack and are passed as parameters
     to the code that implements the method. Any argument value that is of a floating-point
     type undergoes value set conversion (Â§3.8.3) prior to being passed as a parameter. The
     parameters are passed and the code is invoked in an implementation-dependent manner.
     When the platform-dependent code returns, the following take place:
     If the native method is synchronized, the monitor associated with objectref is released
     or exited as if by execution of a monitorexit instruction.
     If the native method returns a value, the return value of the platform-dependent code
     is converted in an implementation-dependent way to the return type of the native method
     and pushed onto the operand stack.
     Linking Exceptions
     During resolution of the symbolic reference to the method, any of the exceptions
     pertaining to method resolution documented in Section 5.4.3.3 can be thrown.
     Otherwise, if the resolved method is a class (static) method, the invokevirtual instruction
     throws an IncompatibleClassChangeError.

     Runtime Exceptions
     Otherwise, if objectref is null, the invokevirtual instruction throws a NullPointerException.
     Otherwise, if no method matching the resolved name and descriptor is selected, invokevirtual
     throws an AbstractMethodError.
     Otherwise, if the selected method is abstract, invokevirtual throws an AbstractMethodError.
     Otherwise, if the selected method is native and the code that implements the method cannot
     be bound, invokevirtual throws an UnsatisfiedLinkError.

     Notes
     The nargs argument values and objectref are not one-to-one with the first nargs + 1 local
     variables. Argument values of types long and double must be stored in two consecutive local
     variables, thus more than nargs local variables may be required to pass nargs argument
     values to the invoked method."

    "Modified: / 04-06-2011 / 18:13:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2016 / 00:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ior
    "
     Boolean OR int
     stack: val1 val2 -> result
     args: nothing"
    
    self pushInt: (self pop bitOr: self pop).

"
Description
Both value1 and value2 must be of type int. They are popped from the operand stack. 
An int result is calculated by taking the bitwise inclusive OR of value1 and value2. 
The result is pushed onto the operand stack.
"

    "Created: / 14-03-2011 / 18:20:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

irem
    "
     Remainder int
     stack: value1 value2 -> result
     args: nothing"
    
    | value1  value2 |

    value2 := self pop.
    value1 := self pop.
    self pushInt: (value1 - ((value1 // value2) * value2)).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped from the operand stack.
     The int result is value1 - (value1 / value2) * value2. The result is pushed onto the
     operand stack.
     The result of the irem instruction is such that (a/b)*b + (a%b) is equal to a. This identity
     holds even in the special case in which the dividend is the negative int of largest possible
     magnitude for its type and the divisor is -1 (the remainder is 0). It follows from this rule
     that the result of the remainder operation can be negative only if the dividend is negative
     and can be positive only if the dividend is positive. Moreover, the magnitude of the result
     is always less than the magnitude of the divisor.

     Runtime Exception
     If the value of the divisor for an int remainder operator is 0, irem throws an ArithmeticException."

    "Modified: / 14-03-2011 / 17:32:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ireturn
    "
     Return int from method
     stack: value -> nothing
     args: nothing"
    
    self leaveProcessorWith: (self pop).

    "
     Description
     The current method must have return type boolean, byte, short,
     char, or int. The value must be of type int. If the current method
     is a synchronized method, the monitor acquired or reentered on
     invocation of the method is released or exited (respectively) as
     if by execution of a monitorexit instruction. If no exception is
     thrown, value is popped from the operand stack of the current frame
     (Â§3.6) and pushed onto the operand stack of the frame of the invoker.
     Any other values on the operand stack of the current method are discarded.
     The interpreter then returns control to the invoker of the method,
     reinstating the frame of the invoker.

     Runtime Exceptions
     If the current method is a synchronized method and the current thread
     is not the owner of the monitor acquired or reentered on invocation of
     the method, ireturn throws an IllegalMonitorStateException. This can
     happen, for example, if a synchronized method contains a monitorexit
     instruction, but no monitorenter instruction, on the object on which
     the method is synchronized.
     Otherwise, if the virtual machine implementation enforces the rules
     on structured use of locks described in Section 8.13 and if the first
     of those rules is violated during invocation of the current method,
     then ireturn throws an IllegalMonitorStateException."
    "Created: / 06-03-2011 / 21:24:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:42:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ishl
    "
     Shift left int
     stack: val1 val2 -> result
     args: nothing"
    
    self swap.
    self pushInt: (self pop bitShift32: self pop).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped from the operand
     stack. An int result is calculated by shifting value1 left by s bit positions, where
     s is the value of the low 5 bits of value2. The result is pushed onto the operand stack.

     Notes
     This is equivalent (even if overflow occurs) to multiplication by 2 to the power s.
     The shift distance actually used is always in the range 0 to 31, inclusive, as if
     value2 were subjected to a bitwise logical AND with the mask value 0x1f."

    "Created: / 14-03-2011 / 17:12:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 19:01:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ishr
    "
     Shift right int
     stack: val1 val2 -> result
     args: nothing"
    
    self swap.
    self pushInt: (self pop rightShift: (self pop bitAnd: 2r11111)).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped from the operand
     stack. An int result is calculated by shifting value1 right by s bit positions,
     with sign extension, where s is the value of the low 5 bits of value2. The result
     is pushed onto the operand stack.

     Notes
     The resulting value is , where s is value2 & 0x1f. For nonnegative value1, this
     is equivalent to truncating int division by 2 to the power s. The shift distance
     actually used is always in the range 0 to 31, inclusive, as if value2 were
     subjected to a bitwise logical AND with the mask value 0x1f."

    "Created: / 14-03-2011 / 17:19:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore: idx 
    "store int value into variable #index
     stack: value -> nothing
     args: index"
    
    context at: (idx + 1) put: (self pop).

    "
     Description
     The index is an unsigned byte that must be an index into the local variable
     array of the current frame (Â§3.6). The value on the top of the operand stack
     must be of type int. It is popped from the operand stack, and the value of
     the local variable at index is set to value.

     Notes
     The istore opcode can be used in conjunction with the wide instruction to
     access a local variable using a two-byte unsigned index."

    "Modified: / 14-03-2011 / 20:03:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isub
    "
     int substract
     stack: value1, value2 -> result
     args: nothing"
    
    self pushInt: (0 - self pop + self pop).

    "
     Both value1 and value2 must be of type int. The values are
     popped from the operand stack. The int result is value1 - value2.
     The result is pushed onto the operand stack.
     For int subtraction, a - b produces the same result as a + (-b).
     For int values, subtraction from zero is the same as negation.
     The result is the 32 low-order bits of the true mathematical result
     in a sufficiently wide two's-complement format, represented
     as a value of type int. If overflow occurs, then the sign of
     the result may not be the same as the sign of the mathematical
     sum of the two values.
     Despite the fact that overflow may occur, execution of an isub
     instruction never throws a runtime exception."

    "Created: / 06-03-2011 / 23:14:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 17:13:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iushr
    "
     Logical shift right int
     stack: value1 value2 -> result
     args: nothing"
    
    self swap.
    self pushInt: (self pop unsignedBitShift32: self pop).

    "
     Description
     Both value1 and value2 must be of type int. The values are popped from the
     operand stack. An int result is calculated by shifting value1 right by s
     bit positions, with zero extension, where s is the value of the low 5 bits
     of value2. The result is pushed onto the operand stack.

     Notes
     If value1 is positive and s is value2 & 0x1f, the result is the same as
     that of value1 >> s; if value1 is negative, the result is equal to the
     value of the expression (value1 >> s) + (2 << ~s). The addition of the
     (2 << ~s) term cancels out the propagated sign bit. The shift distance
     actually used is always in the range 0 to 31, inclusive."

    "Created: / 14-03-2011 / 18:58:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ixor
    "
     Boolean XOR int
     stack: value1 value -> result
     args: nothing"
                        
    self pushInt: (self pop bitXor: self pop).

    "
     Description
     Both value1 and value2 must be of type int. They are popped from the operand
     stack. An int result is calculated by taking the bitwise exclusive OR of
     value1 and value2. The result is pushed onto the operand stack."

    "Created: / 14-03-2011 / 18:07:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:35:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

jsr
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

jsr_w
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

l2d
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

l2f
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

l2i
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

ladd
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

laload
    self halt
!

land
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lastore
    self halt
!

lcmp
    | l1 l2 |

    l1 := self popLong.
    l2 := self popLong.
    l1 = l2 ifTrue:[ 
        self pushInt: 0
    ] ifFalse:[ 
        l1 > l2 ifTrue:[ 
            self pushInt: 1
        ] ifFalse:[ 
            self pushInt:-1
        ].
    ].

    "Modified: / 15-03-2016 / 23:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lconst: arg 
    "
     Push long constant
     stack: nothing -> const
     arg: nothing"
    
    self pushLong: arg.

    "
     Push the long constant <l> (0 or 1) onto the operand stack."

    "Created: / 17-03-2011 / 15:31:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:03:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldc1
    | constantOrRef |

    constantOrRef := constantPool at: self fetchIndex.
    (constantOrRef isNumber or:[ constantOrRef isJavaObject"java.lang.String"]) ifFalse:[ 
        constantOrRef := constantOrRef resolve.
    ].
    self pushRef: constantOrRef.       

    "
    Operation

       Push item from run-time constant pool

    Format

       ldc
       index

    Forms

       ldc = 18 (0x12)

    Operand Stack

       ... →

       ..., value

    Description

       The index is an unsigned byte that must be a valid index into
       the run-time constant pool of the current class ([384]§2.6).
       The run-time constant pool entry at index either must be a
       run-time constant of type int or float, or a reference to a
       string literal, or a symbolic reference to a class, method
       type, or method handle ([385]§5.1).

       If the run-time constant pool entry is a run-time constant of
       type int or float, the numeric value of that run-time constant
       is pushed onto the operand stack as an int or float,
       respectively.

       Otherwise, if the run-time constant pool entry is a reference
       to an instance of class String representing a string literal
       ([386]§5.1), then a reference to that instance, value, is
       pushed onto the operand stack.

       Otherwise, if the run-time constant pool entry is a symbolic
       reference to a class ([387]§5.1), then the named class is
       resolved ([388]§5.4.3.1) and a reference to the Class object
       representing that class, value, is pushed onto the operand
       stack.

       Otherwise, the run-time constant pool entry must be a symbolic
       reference to a method type or a method handle ([389]§5.1). The
       method type or method handle is resolved ([390]§5.4.3.5) and a
       reference to the resulting instance of
       java.lang.invoke.MethodType or java.lang.invoke.MethodHandle,
       value, is pushed onto the operand stack.

    Linking Exceptions

       During resolution of a symbolic reference to a class, any of
       the exceptions pertaining to class resolution ([391]§5.4.3.1)
       can be thrown.

       During resolution of a symbolic reference to a method type or
       method handle, any of the exception pertaining to method type
       or method handle resolution ([392]§5.4.3.5) can be thrown.

    Notes

       The ldc instruction can only be used to push a value of type
       float taken from the float value set ([393]§2.3.2) because a
       constant of type float in the constant pool ([394]§4.4.4) must
       be taken from the float value set.
    "

    "Created: / 29-07-2016 / 09:14:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2
    self pushRef: (constantPool at: self fetchIndex2).  

    "
    ldc_w

    Operation

       Push item from run-time constant pool (wide index)

    Format

       ldc_w
       indexbyte1
       indexbyte2

    Forms

       ldc_w = 19 (0x13)

    Operand Stack

       ... →

       ..., value

    Description

       The unsigned indexbyte1 and indexbyte2 are assembled into an
       unsigned 16-bit index into the run-time constant pool of the
       current class ([395]§2.6), where the value of the index is
       calculated as (indexbyte1 << 8) | indexbyte2. The index must be
       a valid index into the run-time constant pool of the current
       class. The run-time constant pool entry at the index either
       must be a run-time constant of type int or float, or a
       reference to a string literal, or a symbolic reference to a
       class, method type, or method handle ([396]§5.1).

       If the run-time constant pool entry is a run-time constant of
       type int or float, the numeric value of that run-time constant
       is pushed onto the operand stack as an int or float,
       respectively.

       Otherwise, if the run-time constant pool entry is a reference
       to an instance of class String representing a string literal
       ([397]§5.1), then a reference to that instance, value, is
       pushed onto the operand stack.

       Otherwise, if the run-time constant pool entry is a symbolic
       reference to a class ([398]§4.4.1). The named class is resolved
       ([399]§5.4.3.1) and a reference to the Class object
       representing that class, value, is pushed onto the operand
       stack.

       Otherwise, the run-time constant pool entry must be a symbolic
       reference to a method type or a method handle ([400]§5.1). The
       method type or method handle is resolved ([401]§5.4.3.5) and a
       reference to the resulting instance of
       java.lang.invoke.MethodType or java.lang.invoke.MethodHandle,
       value, is pushed onto the operand stack.

    Linking Exceptions

       During resolution of the symbolic reference to a class, any of
       the exceptions pertaining to class resolution ([402]§5.4.3.1)
       can be thrown.

       During resolution of a symbolic reference to a method type or
       method handle, any of the exception pertaining to method type
       or method handle resolution ([403]§5.4.3.5) can be thrown.

    Notes

       The ldc_w instruction is identical to the ldc instruction
       ([404]§ldc) except for its wider run-time constant pool index.

       The ldc_w instruction can only be used to push a value of type
       float taken from the float value set ([405]§2.3.2) because a
       constant of type float in the constant pool ([406]§4.4.4) must
       be taken from the float value set.
    "

    "Created: / 29-07-2016 / 09:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2w
    self pushDouble: (constantPool at: self fetchIndex2).     

    "
    ldc2_w

    Operation

       Push long or double from run-time constant pool (wide index)

    Format

       ldc2_w
       indexbyte1
       indexbyte2

    Forms

       ldc2_w = 20 (0x14)

    Operand Stack

       ... →

       ..., value

    Description

       The unsigned indexbyte1 and indexbyte2 are assembled into an
       unsigned 16-bit index into the run-time constant pool of the
       current class ([407]§2.6), where the value of the index is
       calculated as (indexbyte1 << 8) | indexbyte2. The index must be
       a valid index into the run-time constant pool of the current
       class. The run-time constant pool entry at the index must be a
       run-time constant of type long or double ([408]§5.1). The
       numeric value of that run-time constant is pushed onto the
       operand stack as a long or double, respectively.

    Notes

       Only a wide-index version of the ldc2_w instruction exists;
       there is no ldc2 instruction that pushes a long or double with
       a single-byte index.

       The ldc2_w instruction can only be used to push a value of type
       double taken from the double value set ([409]§2.3.2) because a
       constant of type double in the constant pool ([410]§4.4.5) must
       be taken from the double value set.
    "

    "Created: / 29-07-2016 / 09:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldiv
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lload: idx 
"
Load long from local variable
stack: nothing -> value
args: index"
    
    self pushLong: (context at: idx + 1).

    "
     Description
     The index is an unsigned byte. Both index and index + 1 must be indices
     into the local variable array of the current frame (3.6). The local variable
     at index must contain a long. The value of the local variable at index is
     pushed onto the operand stack.

     Notes
     The lload opcode can be used in conjunction with the wide instruction to
     access a local variable using a two-byte unsigned index."

    "Modified: / 13-03-2011 / 17:24:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lmul
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lneg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lookupswtch
    "
     Access jump table by key match and jump
     stack: key -> ..
     args: insane"
    
    | key  jmpDest  default  npairs |

    key := self pop asInteger.
    self skipPadding.
    default := self fetchBytes4.
    npairs := self fetchBytes4.
    npairs timesRepeat:[
        key = self fetchBytes4 ifTrue:[
            jmpDest := self fetchBytes4
        ] ifFalse:[
            self fetchBytes4
        ]
    ].
    jmpDest isNil ifTrue:[
        jmpDest := default.
    ].
    self relativeJump:jmpDest.

    "
     Description
     A lookupswitch is a variable-length instruction. Immediately after the lookupswitch
     opcode, between zero and three null bytes (zeroed bytes, not the null object) are
     inserted as padding. The number of null bytes is chosen so that the defaultbyte1 begins
     at an address that is a multiple of four bytes from the start of the current method
     (the opcode of its first instruction). Immediately after the padding follow a series
     of signed 32-bit values: default, npairs, and then npairs pairs of signed 32-bit values.
     The npairs must be greater than or equal to 0. Each of the npairs pairs consists of an
     int match and a signed 32-bit offset. Each of these signed 32-bit values is constructed
     from four unsigned bytes as (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4.
     The table match-offset pairs of the lookupswitch instruction must be sorted in increasing
     numerical order by match.
     The key must be of type int and is popped from the operand stack. The key is compared
     against the match values. If it is equal to one of them, then a target address is
     calculated by adding the corresponding offset to the address of the opcode of this
     lookupswitch instruction. If the key does not match any of the match values, the target
     address is calculated by adding default to the address of the opcode of this lookupswitch
     instruction. Execution then continues at the target address.
     The target address that can be calculated from the offset of each match-offset pair, as
     well as the one calculated from default, must be the address of an opcode of an instruction
     within the method that contains this lookupswitch instruction.

     Notes
     The alignment required of the 4-byte operands of the lookupswitch instruction guarantees
     4-byte alignment of those operands if and only if the method that contains the lookupswitch
     is positioned on a 4-byte boundary.
     The match-offset pairs are sorted to support lookup routines that are quicker than linear
     search."

    "Modified: / 21-03-2011 / 18:38:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lor
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lrem
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lreturn
    "
     Return long from method
     stack: value -> empty
     args: nothing"
    
    self leaveProcessorWith: (self pop).

    "
     Description
     The current method must have return type long. The value must be of type
     long. If the current method is a synchronized method, the monitor acquired
     or reentered on invocation of the method is released or exited (respectively)
     as if by execution of a monitorexit instruction. If no exception is thrown,
     value is popped from the operand stack of the current frame (Â§3.6) and pushed
     onto the operand stack of the frame of the invoker. Any other values on the
     operand stack of the current method are discarded.
     The interpreter then returns control to the invoker of the method, reinstating
     the frame of the invoker.

     Runtime Exceptions
     If the current method is a synchronized method and the current thread is not
     the owner of the monitor acquired or reentered on invocation of the method,
     lreturn throws an IllegalMonitorStateException. This can happen, for example,
     if a synchronized method contains a monitorexit instruction, but no monitorenter
     instruction, on the object on which the method is synchronized.
     Otherwise, if the virtual machine implementation enforces the rules on structured
     use of locks described in Section 8.13 and if the first of those rules is
     violated during invocation of the current method, then lreturn throws an
     IllegalMonitorStateException."
    "Created: / 14-03-2011 / 13:40:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lshl
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lshr
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lstore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lstore: idx 
    "
     Store long into local variable
     stack: value -> nothing
     args: index"
    
    self istore: idx.

    "
     Description
     The index is an unsigned byte. Both index and index + 1 must be indices
     into the local variable array of the current frame (3.6). The value on
     the top of the operand stack must be of type long. It is popped from the
     operand stack, and the local variables at index and index + 1 are set to
     value.

     Notes
     The lstore opcode can be used in conjunction with the wide instruction to
     access a local variable using a two-byte unsigned index."

    "Modified: / 14-03-2011 / 17:55:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lsub
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lushr
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

lxor
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

monenter
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

monexit
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

multianewarray
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

new
    "
     Create new object
     stack: nothing -> objectRef
     args: indexByte1 indexByte2"
    
    | classRef  objectRef |

    classRef := constantPool at: self fetchIndex2.
    self breakPoint:#mh_instructions.
    objectRef := (JavaVM classForName: classRef name) basicNew.
    self pushRef: objectRef  

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into
     the runtime constant pool of the current class (3.6), where the value of
     the index is (indexbyte1 << 8) | indexbyte2. The runtime constant pool item
     at the index must be a symbolic reference to a class, array, or interface
     type. The named class, array, or interface type is resolved (5.4.3.1) and
     should result in a class type (it should not result in an array or interface
     type). Memory for a new instance of that class is allocated from the
     garbage-collected heap, and the instance variables of the new object are
     initialized to their default initial values (2.5.1). The objectref, a reference
     to the instance, is pushed onto the operand stack.
     On successful resolution of the class, it is initialized (5.5) if it has not
     already been initialized.

     Linking Exceptions
     During resolution of the symbolic reference to the class, array, or interface
     type, any of the exceptions documented in Section 5.4.3.1 can be thrown.
     Otherwise, if the symbolic reference to the class, array, or interface type
     resolves to an interface or is an abstract class, new throws an InstantiationError.

     Runtime Exception
     Otherwise, if execution of this new instruction causes initialization of the
     referenced class, new may throw an Error as detailed in Section 2.17.5.

     Note
     The new instruction does not completely create a new instance; instance creation
     is not completed until an instance initialization method has been invoked on
     the uninitialized instance."

    "Created: / 25-02-2011 / 00:17:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 13-03-2011 / 17:18:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-03-2016 / 23:26:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newarray
    "
     Create new array
     stack: count -> arrayRef
     args: arrayType"
    
    | type  size |

    type := self fetchByte.
    size := self pop.
    type = 4 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'boolean' sized: size ].
    type = 5 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'char' sized: size ].
    type = 6 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'float' sized: size ].
    type = 7 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'double' sized: size ].
    type = 8 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'byte' sized: size ].
    type = 9 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'short' sized: size ].
    type = 10 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'int' sized: size ].
    type = 11 ifTrue: [ ^ self pushNewPrimitiveArrayOf: 'long' sized: size ].
    self halt: 'Type not recognized - tell mh'.

"
Description
The count must be of type int. It is popped off the operand stack. The count represents 
the number of elements in the array to be created.
The atype is a code that indicates the type of array to create. It must take one of the 
following values:
Array Type   atype
T_BOOLEAN    4
T_CHAR   5
T_FLOAT  6
T_DOUBLE     7
T_BYTE   8
T_SHORT  9
T_INT    10
T_LONG   11


A new array whose components are of type atype and of length count is allocated 
from the garbage-collected heap. A reference arrayref to this new array object is pushed 
into the operand stack. Each of the elements of the new array is initialized to the 
default initial value for the type of the array (2.5.1).

Runtime Exception
If count is less than zero, newarray throws a NegativeArraySizeException.

Notes
In Sun's implementation of the Java virtual machine, arrays of type boolean (atype 
is T_BOOLEAN) are stored as arrays of 8-bit values and are manipulated using the baload 
and bastore instructions, instructions that also access arrays of type byte. Other 
implementations may implement packed boolean arrays; the baload and bastore instructions 
must still be used to access those arrays.
"

    "Created: / 14-03-2011 / 18:24:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2011 / 21:07:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

nop
"Do nothing"

    "Created: / 14-03-2011 / 18:52:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop1
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

pop2
    "
     Pop the top one or two operand stack values
    stack v1: value2 value1 -> nothing                      where each of value1 and value2 is a value of a category 1 computational type (3.11.1).
    stack v2: value -> nothing                              where value is a value of a category 2 computational type (3.11.1).
    args: nothing
"
    
    sp := sp - 2.
"
Description
Pop the top one or two values from the operand stack.
"

    "Modified: / 13-03-2011 / 17:20:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

putfield
    "Set field in object
     stack: objectRef value -> nothing
     args: indexbyte1 indexbyte2"
    
    | newValue  object  fieldRef |

    newValue := self pop.  
    object := self pop.    
    fieldRef := constantPool at: self fetchIndex2.
    fieldRef resolve.
    object instVarAt: fieldRef resolvedOffset put: newValue.

    "Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index
     into the runtime constant pool of the current class (Â§3.6), where the value
     of the index is (indexbyte1 << 8) | indexbyte2. The runtime constant pool
     item at that index must be a symbolic reference to a field (Â§5.1), which
     gives the name and descriptor of the field as well as a symbolic reference
     to the class in which the field is to be found. The class of objectref must
     not be an array. If the field is protected (Â§4.6), and it is either a member
     of the current class or a member of a superclass of the current class, then
     the class of objectref must be either the current class or a subclass of
     the current class.
         The referenced field is resolved (Â§5.4.3.2). The type of a value stored
     by a putfield instruction must be compatible with the descriptor of the
     referenced field (Â§4.3.2). If the field descriptor type is boolean, byte,
     char, short, or int, then the value must be an int. If the field descriptor
     type is float, long, or double, then the value must be a float, long, or
     double, respectively. If the field descriptor type is a reference type, then
     the value must be of a type that is assignment compatible (Â§2.6.7) with the
     field descriptor type. If the field is final, it should be declared in the
     current class. Otherwise, an IllegalAccessError is thrown.
         The value and objectref are popped from the operand stack. The objectref
     must be of type reference. The value undergoes value set conversion (Â§3.8.3),
     resulting in value', and the referenced field in objectref is set to value'.

         Linking Exceptions
         During resolution of the symbolic reference to the field, any of the
     exceptions pertaining to field resolution documented in Section 5.4.3.2 can be thrown.


         Otherwise, if the resolved field is a static field, putfield throws
     an IncompatibleClassChangeError.
         Otherwise, if the field is final, it must be declared in the current
     class. Otherwise, an IllegalAccessError is thrown.

         Runtime Exception
         Otherwise, if objectref is null, the putfield instruction throws a NullPointerException."

    "Modified: / 04-06-2011 / 18:14:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2016 / 00:28:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

putstatic
    "
     Set static field in class
     stack: value -> nothing
     args: indexByte1 indexByte2"
    
    | newValue  fieldref |
    newValue := self pop.
    fieldref := constantPool at: self fetchIndex2.
    fieldref resolve.
    fieldref javaClass instVarAt: fieldref resolvedOffset put: newValue.

    "
     Description
     The unsigned indexbyte1 and indexbyte2 are used to construct an index into
     the runtime constant pool of the current class (Â§3.6), where the value of
     the index is (indexbyte1 << 8) | indexbyte2. The runtime constant pool
     item at that index must be a symbolic reference to a field (Â§5.1), which
     gives the name and descriptor of the field as well as a symbolic reference
     to the class or interface in which the field is to be found. The referenced
     field is resolved (Â§5.4.3.2).
     On successful resolution of the field the class or interface that declared
     the resolved field is initialized (Â§5.5) if that class or interface has not
     already been initialized.
     The type of a value stored by a putstatic instruction must be compatible with
     the descriptor of the referenced field (Â§4.3.2). If the field descriptor type
     is boolean, byte, char, short, or int, then the value must be an int. If the
     field descriptor type is float, long, or double, then the value must be a float,
     long, or double, respectively. If the field descriptor type is a reference type,
     then the value must be of a type that is assignment compatible (Â§2.6.7) with
     the field descriptor type. If the field is final, it should be declared in
     the current class. Otherwise, an IllegalAccessError is thrown.
     The value is popped from the operand stack and undergoes value set conversion
     (Â§3.8.3), resulting in value'. The class field is set to value'.

     Linking Exceptions
     During resolution of the symbolic reference to the class or interface field,
     any of the exceptions pertaining to field resolution documented in Section
     5.4.3.2 can be thrown.
     Otherwise, if the resolved field is not a static (class) field or an interface
     field, putstatic throws an IncompatibleClassChangeError.
     Otherwise, if the field is final, it must be declared in the current class.
     Otherwise, an IllegalAccessError is thrown.

     Runtime Exception
     Otherwise, if execution of this putstatic instruction causes initialization
     of the referenced class or interface, putstatic may throw an Error as detailed
     in Section 2.17.5.

     Notes
     A putstatic instruction may be used only to set the value of an interface field
     on the initialization of that field. Interface fields may be assigned to only
     once, on execution of an interface variable initialization expression when the
     interface is initialized (Â§2.17.4)."

    "Created: / 24-02-2011 / 23:21:16 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-12-2011 / 19:24:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2016 / 00:26:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ret
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

ret_w
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

return
    "Return void from method
     stack: nothing -> nothing
     args: nothing"
    
    self leaveProcessorWith: nil.

    "
     Description
     The current method must have return type void. If the current method is a synchronized
     method, the monitor acquired or reentered on invocation of the method is released or
     exited (respectively) as if by execution of a monitorexit instruction. If no exception
     is thrown, any values on the operand stack of the current frame (Â§3.6) are discarded.
     The interpreter then returns control to the invoker of the method, reinstating the
     frame of the invoker.

     Runtime Exceptions
     If the current method is a synchronized method and the current thread is not the owner
     of the monitor acquired or reentered on invocation of the method, return throws an
     IllegalMonitorStateException. This can happen, for example, if a synchronized method

     contains a monitorexit instruction, but no monitorenter instruction, on the object on
     which the method is synchronized.
     Otherwise, if the virtual machine implementation enforces the rules on structured use
     of locks described in Section 8.13 and if the first of those rules is violated during
     invocation of the current method, then return throws an IllegalMonitorStateException."
    "Created: / 24-02-2011 / 11:38:13 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2011 / 23:10:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 13-03-2011 / 17:22:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

saload
    self halt
!

sastore
    self halt
!

sipush
    "pushes a short onto the stack
     stack: nothing -> value
     args: byte1 byte2"
    
    self pushInt: (self fetchBytes2).

    "
     Description
     The immediate unsigned byte1 and byte2 values are assembled
     into an intermediate short where the value of the short is (byte1 << 8) | byte2.
     The intermediate value is then sign-extended to an int value. That value is
     pushed onto the operand stack."

    "Modified: / 17-03-2011 / 17:03:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

swap
"
Swap the top two operand stack values
stack: value2 value1 -> value1 value2
args: nothing
"
    | v1  v2 |

    v1 := self pop.
    v2 := self pop.
    self pushInt: v1.
    self pushInt: v2.

"
Description
Swap the top two values on the operand stack.
The swap instruction must not be used unless value1 and value2 are both 
values of a category 1 computational type (3.11.1).

Notes
The Java virtual machine does not provide an instruction implementing a 
swap on operands of category 2 computational types.
"

    "Modified: / 13-03-2011 / 17:24:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

tableswtch
    "
     Access jump table by index and jump
     stack: index -> ..
     args: insane :)"
    
    | index  jmpDest  default  low  high |

    index := self pop asInteger.
    self skipPadding.
    default := self fetchBytes4.
    low := self fetchBytes4.
    high := self fetchBytes4.
    low to:high do:[:idx | 
        idx = index ifTrue:[
            jmpDest := self fetchBytes4
        ] ifFalse:[
            self fetchBytes4
        ]
    ].
    jmpDest isNil ifTrue:[
        jmpDest := default.
    ].
    self relativeJump:jmpDest.

    "
     Description
     A tableswitch is a variable-length instruction. Immediately after the tableswitch opcode,
     between 0 and 3 null bytes (zeroed bytes, not the null object) are inserted as padding.
     The number of null bytes is chosen so that the following byte begins at an address that
     is a multiple of 4 bytes from the start of the current method (the opcode of its first
     instruction). Immediately after the padding follow bytes constituting three signed 32-bit
     values: default, low, and high. Immediately following those bytes are bytes constituting a
     series of high - low + 1 signed 32-bit offsets. The value low must be less than or equal
     to high. The high - low + 1 signed 32-bit offsets are treated as a 0-based jump table.
     Each of these signed 32-bit values is constructed as (byte1 << 24) | (byte2 << 16) |
     (byte3 << 8) | byte4.
     The index must be of type int and is popped from the operand stack. If index is less than
     low or index is greater than high, then a target address is calculated by adding default
     to the address of the opcode of this tableswitch instruction. Otherwise, the offset at
     position index - low of the jump table is extracted. The target address is calculated by
     adding that offset to the address of the opcode of this tableswitch instruction. Execution
     then continues at the target address.
     The target address that can be calculated from each jump table offset, as well as the ones
     that can be calculated from default, must be the address of an opcode of an instruction
     within the method that contains this tableswitch instruction.

     Notes
     The alignment required of the 4-byte operands of the tableswitch instruction guarantees 4-byte
     alignment of those operands if and only if the method that contains the tableswitch starts
     on a 4-byte boundary."

    "Modified: / 21-03-2011 / 18:35:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wide
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
! !

!JavaByteCodeInterpreter methodsFor:'interpretation'!

handleAbstractMethod
self halt: 'Is it allowed to interpret abstract method? I dont think so :)'.

    "Created: / 22-03-2011 / 14:50:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

interpret: aMethod receiver: aReceiver arguments: args 
    self 
        log: ('Invoking method ' , aMethod name , ' on ' , aReceiver printString
                , ' with ' , args printString).

    ^ self 
        process: aMethod
        receiver: aReceiver
        arguments: args.

    "Created: / 17-03-2011 / 17:25:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 28-03-2011 / 18:03:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

interpretInner: aJavaMethod receiver: aReceiver arguments: anArgs 
    ^ aJavaMethod interpretWithReceiver: aReceiver arguments: anArgs.

    "Created: / 31-03-2011 / 16:29:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeInterpreter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/JavaByteCodeInterpreter.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

