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
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaByteCodeProcessorTests subclass:#JavaByteCodeDisassemblerTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaByteCodeDisassemblerTests class methodsFor:'documentation'!

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

!JavaByteCodeDisassemblerTests class methodsFor:'resources'!

resources

    ^ Array with: JavaInitializedResource with: JavaTestsResource.

    "Created: / 15-03-2011 / 17:29:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 14:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassemblerTests methodsFor:'tests'!

testAnd
    | result |
    self shouldnt: 
            [ result := self 
                invoke: #'and(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 255 149 )
            ] raise: Error. 

    "static method

     0    iload_0
     1    iload_1
     2    iand
     3    ireturn"

    "Created: / 14-03-2011 / 17:02:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:49:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 21-12-2012 / 18:43:34 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testBitShiftLeft
    |  |

     self shouldnt: 
            [ self 
                invoke: #'bitShiftLeft(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 21 4 )]
                        raise: Error.
    "static method

     0    iload_0
     1    iload_1
     2    ishl
     3    ireturn"

    "Created: / 14-03-2011 / 16:56:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:50:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testBitShiftRight
    |  |

     self shouldnt: 
             [ self 
                invoke: #'bitShiftRight(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 439 4 )]
                        raise: Error.

    "static method

     0    iload_0
     1    iload_1
     2    ishr
     3    ireturn"

    "Created: / 14-03-2011 / 16:57:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:50:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDec2
    self shouldnt: 
    
    
    [ self 
        invoke: #'dec2(I)I'
        class: self loadSimpleMathJavaClass
        args: #( 3 ). ] raise: Error.
    

    "static method

     0    iinc 0 -1
     3    iinc 0 -1
     6    iload_0
     7    ireturn"

    "Created: / 14-03-2011 / 16:58:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 22:59:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDiv
    |  |

    self shouldnt: 
            [ self 
                invoke: #'div(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 101 10 ) ]
                        raise: Error.

    "static method

     0    iload_0
     1    iload_1
     2    irem
     3    ireturn"

    "Created: / 14-03-2011 / 16:54:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:51:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDivision
    |  |

   self shouldnt: 
            [ self 
                invoke: #'division(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 101 10 ) ]
                        raise: Error.
    "static method

     0    iload_0
     1    iload_1
     2    idiv
     3    ireturn"

    "Created: / 14-03-2011 / 16:57:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:51:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInc2
    |  |

    self shouldnt: 
            [ self 
                invoke: #'inc2(I)I'
                class: self loadSimpleMathJavaClass
                args: #( 3 ) ]
                        raise: Error.
    "static method

     0    iinc 0 1
     3    iinc 0 1
     6    iload_0
     7    ireturn"

    "Created: / 14-03-2011 / 16:58:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:51:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInheritedMethodCall
    self shouldnt:  [ 
    
    self 
        invoke: #'foo()Ljava/lang/String;'
        class: self loadSimpleInheritingJavaClass
        args: nil.

    ]       raise: Error.
    "0    ldc1 2 ['foo'] 
     2    areturn"

    "Created: / 14-03-2011 / 16:21:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 23:01:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testJustLoadConstants
    self shouldnt:  [ 
    
    self 
        invoke: #'justUseConstants()V'
        class: self loadSimpleMathJavaClass
        args: #().

    ]        raise: Error.
    "static method

     0    lconst_0
     1    lstore_0
     2    lconst_1
     3    lstore_2
     4    fconst_0
     5    fstore 4
     7    fconst_1
     8    fstore 5
     10   fconst_2
     11   fstore 6
     13   dconst_0
     14   dstore 7
     16   dconst_1
     17   dstore 9
     19   return"

    "Created: / 14-03-2011 / 17:05:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 23:02:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testLookupSwitch
        self shouldnt:            [ 
    
    self 
        invoke: #'switchInt(I)I'
        class: self loadSwitchExamplesClass
        receiver: self loadSwitchExamplesClass new
        args: #( -1000 )

     ]        raise: Error.

    "Created: / 21-03-2011 / 13:51:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:12:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testMultipy
   self shouldnt: 
             [ self 
                invoke: #'multiply(II)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 20 with: 10)]
                        raise: Error.

    "static method

     0    iload_0
     1    iload_1
     2    imul
     3    ireturn"

    "Created: / 06-03-2011 / 14:17:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:53:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testNegateInt
    self shouldnt: 
             [ self 
                invoke: #'negateInt(I)I'
                class: self loadSimpleMathJavaClass
                args: #( 55 )]
                        raise: Error.

    "0    iload_0 
     1    iconst_m1
     2    ixor
     3    ireturn"

    "Created: / 14-03-2011 / 16:55:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:53:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testOr
    |  |

    self shouldnt: 
            [ self 
                invoke: #'or(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 55 66 )]
                        raise: Error.

    "0    iload_0 
     1    iload_1
     2    ior
     3    ireturn"

    "Created: / 14-03-2011 / 17:02:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:53:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testOverridenMethodCall
    self shouldnt: 
             [ self 
                        invoke: #'bar()Ljava/lang/String;'
                        class: self loadSimpleInheritingJavaClass
                        args: nil.]
                                raise: Error.

    "0    ldc1 2 ['bar'] 
     2    areturn"

    "Modified: / 20-03-2011 / 21:53:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testPower
     self shouldnt: 
             [ self 
                invoke: #'power(II)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 2 with: 10)]
                        raise: Error.

    "0    iload_0 
     1    iload_1
     2    iconst_1
     3    invokestatic 2 [JavaMethod(stx.libjava.tests.mocks.SimpleMath::int powerAcc (int int int))]
     6    ireturn"

    "Created: / 06-03-2011 / 14:18:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:54:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testReturnArrayOfLongs


    self shouldnt: 
            [ self 
                        invoke: #'giveMeArrayOfLongs()[J'
                        class: self loadSimpleMathJavaClass
                        args: #(). ]
        raise: Error.

    "0    bipush 100
     2    newarray 11 [T_LONG]
     4    areturn"

    "Created: / 14-03-2011 / 17:08:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:54:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSimpleAdd
    self shouldnt: 
             [ self 
                invoke: #'add2To2000Expect2002()I'
                class: self loadSimpleMathJavaClass
                args: nil ]
                        raise: Error.

    "static method

     0    iconst_2
     1    istore_0
     2    sipush 2000
     5    istore_1
     6    iload_0
     7    iload_1
     8    iadd
     9    istore_2
     10   iload_2
     11   ireturn"

    "Created: / 06-03-2011 / 14:18:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:55:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSimpleAdd2
    self shouldnt: 
             [ self 
                invoke: #'addMinus5ToArg(I)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 10) ]
                        raise: Error.

    "static method

     0    iload_0
     1    bipush -5
     3    iadd
     4    ireturn"

    "Created: / 06-03-2011 / 14:18:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:55:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testStackCreation
    self shouldnt: 
             [ self 
                invoke: #'isYourStackCreatedCorrectly()I'
                class: self loadSimpleMathJavaClass
                args: #()]
                        raise: Error.

    "0    iconst_0 
     1    istore_0
     2    iconst_1
     3    istore_1
     4    iconst_2
     5    istore_0
     6    iconst_3
     7    istore_1
     8    iconst_4
     9    istore_0
     10   iconst_5
     11   istore_0
     12   bipush 6
     14   istore_1
     15   bipush 7
     17   istore_0
     18   bipush 8
     20   istore_1
     21   bipush 9
     23   istore_1
     24   iload_0
     25   ireturn"

    "Created: / 14-03-2011 / 17:03:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:55:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSumArray
    self shouldnt:   [
    
    self 
        invoke: #'sumArray([I)I'
        class: self loadSimpleMathJavaClass
        args: #( #(1 2 3 4 5) )

    ]        raise: Error.
    "
     Decompiled source:
     Static method
     0    iconst_0
     1    istore_1
     2    iconst_0
     3    istore_2
     4    iload_2
     5    aload_0
     6    arraylength
     7    if_icmpge 15 [22]
     10   iload_1
     11   aload_0
     12   iload_2
     13   iaload
     14   iadd
     15   istore_1
     16   iinc 2 1
     19   goto -15 [4]
     22   iload_1
     23   ireturn"

    "Created: / 14-03-2011 / 17:06:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 23:05:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSumArrayOfDoubles
    self shouldnt: 
             [self 
                invoke: #'sumArrayOfDoubles([D)D'
                class: self loadSimpleMathJavaClass
                args: #( #(1.1 2.2 3.3 4.4 5.5) ) ]
                        raise: Error.
    "0    dconst_0 
     1    dstore_1
     2    iconst_0
     3    istore_3
     4    iload_3
     5    aload_0
     6    arraylength
     7    if_icmpge 15 [22]
     10   dload_1
     11   aload_0
     12   iload_3
     13   daload
     14   dadd
     15   dstore_1
     16   iinc 3 1
     19   goto -15 [4]
     22   dload_1
     23   dreturn"

    "Created: / 14-03-2011 / 17:07:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:55:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testTableSwitch
         self shouldnt:             [ 
    
    self 
        invoke: #'switchChar(C)I'
        class: self loadSwitchExamplesClass
        receiver: self loadSwitchExamplesClass new
        args: #( $b ).

    ]        raise: Error.

    "Created: / 21-03-2011 / 13:51:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:02:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testUnsignedBitShiftLeft
   self shouldnt: 
             [ self 
                invoke: #'unsignedBitShiftRight(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 1234 5 ) ]
                        raise: Error.

    "0    iload_0 
     1    iload_1
     2    iushr
     3    ireturn"

    "Created: / 14-03-2011 / 17:01:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:56:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testXor
    self shouldnt: 
             [ self 
                invoke: #'xor(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 1234 5 )]
                        raise: Error.

    "0    iload_0 
     1    iload_1
     2    ixor
     3    ireturn"

    "Modified: / 06-03-2011 / 15:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 14-03-2011 / 17:02:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 21:56:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassemblerTests methodsFor:'tests - manual'!

diassembleAll
    | fails |

    fails := OrderedCollection new.
    JavaMethod allSubInstances do: 
            [:method | 
            method isNative 
                ifFalse: 
                    [ [ JavaByteCodeDisassembler new diassemble: method to: String new writeStream ] 
                        on: Error
                        do: [ fails add: method ] ] ].
    fails size ~~ 0 
        ifTrue: [ self error: 'Some java methods failed to disassemble' ].

    "
        JavaByteCodeDisassemblerTests new diassembleAll"

    "Created: / 21-03-2011 / 21:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2011 / 21:05:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-03-2011 / 16:54:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassemblerTests methodsFor:'tests-helpers'!

invoke:methodName class:aClass receiver:receiver args:args 
    |method result|

    method := aClass lookupMethodFor:methodName.
    result := JavaByteCodeDisassembler diassemble:method.

    "Created: / 10-03-2011 / 23:30:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 17:42:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 21:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeDisassemblerTests methodsFor:'tests2'!

testGetBoolean
    self 
        invoke: #'getBoolean()Z'
        class: self loadSimpleClassWithManyReferences
        receiver: self loadSimpleClassWithManyReferences new
        args: nil.

    "
     Deassembling getBoolean
     1:      ALOAD_0     (42)  ARGS: []                  STACK: [.. -> FIELD 0: stx.libjava.tests.mocks.SimpleClassWithManyReferences]
     2:      GETFIELD    (180) ARGS: [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)] STACK: [objectRef -> objectRef]
     5:      BIPUSH      (16)  ARGS: [9]                 STACK: [.. -> value]
     7:      AALOAD      (50)  ARGS: []                  STACK: [arrayRef, index -> value]
     8:      CHECKCAST   (192) ARGS: [java.lang.Boolean] STACK: [objectRef -> objectRef]
     11:     INVVIRT     (182) ARGS: [JavaMethodRef (java.lang.Boolean 'booleanValue'()Z)] STACK: [objectRef, [arg1, arg2, ...]  -> ..]
     14:     IRETURN     (172) ARGS: []                  STACK: [value -> EMPTY]"
    "Created: / 14-03-2011 / 21:36:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 16:06:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetByte
    self 
        shouldnt: [
            self 
                invoke: #'getByte()B'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 7
     6    aaload
     7    checkcast 17 [java.lang.Byte]
     10   invokevirtual 31 [JavaMethodRef (java.lang.Byte 'byteValue'()B)]
     13   ireturn"
    "Created: / 14-03-2011 / 21:34:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:38:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetChar
    self 
        shouldnt: [
            self 
                invoke: #'getChar()C'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_3
     5    aaload
     6    checkcast 25 [java.lang.Character]
     9    invokevirtual 26 [JavaMethodRef (java.lang.Character 'charValue'()C)]
     12   ireturn"
    "Created: / 14-03-2011 / 21:31:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:39:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetDateArray
    self 
        shouldnt: [
            self 
                invoke: #'getDateArray()[Ljava/util/Date;'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 8
     6    aaload
     7    checkcast 32 [UnresolvedClass([Ljava.util.Date;)]
     10   checkcast 32 [UnresolvedClass([Ljava.util.Date;)]
     13   areturn"
    "Created: / 14-03-2011 / 21:35:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:39:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetDouble
    self 
        shouldnt: [
            self 
                invoke: #'getDouble()Ljava/lang/Double;'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_2
     5    aaload
     6    checkcast 24 [java.lang.Double]
     9    areturn"
    "Created: / 14-03-2011 / 21:30:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:39:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetInt
    self 
        shouldnt: [
            self 
                invoke: #'getInt()I'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_1
     5    aaload
     6    checkcast 13 [java.lang.Integer]
     9    invokevirtual 23 [JavaMethodRef (java.lang.Integer 'intValue'()I)]
     12   ireturn"
    "Created: / 14-03-2011 / 21:30:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:39:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetIntArray
    self 
        shouldnt: [
            self 
                invoke: #'getIntArray()[I'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil.
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_5
     5    aaload
     6    checkcast 29 [JavaBuiltInClassPointerRef(class:IntegerArray ; name&type: '[I')]
     9    checkcast 29 [JavaBuiltInClassPointerRef(class:IntegerArray ; name&type: '[I')]
     12   areturn"
    "Created: / 14-03-2011 / 21:33:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:40:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetLong
    self 
        shouldnt: [
            self 
                invoke: #'getLong()J'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_4
     5    aaload
     6    checkcast 27 [java.lang.Long]
     9    invokevirtual 28 [JavaMethodRef (java.lang.Long 'longValue'()J)]
         12   lreturn"
    "Created: / 14-03-2011 / 21:32:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:40:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetShort
    self 
        shouldnt: [
            self 
                invoke: #'getShort()S'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 6
     6    aaload
     7    checkcast 14 [java.lang.Short]
     10   invokevirtual 30 [JavaMethodRef (java.lang.Short 'shortValue'()S)]
     13   ireturn"
    "Created: / 14-03-2011 / 21:33:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:40:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetString
    self 
        shouldnt: [
            self 
                invoke: #'getString()Ljava/lang/String;'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil
        ]
        raise: Error.

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_0
     5    aaload
     6    checkcast 22 [java.lang.String]
     9    areturn"
    "Created: / 14-03-2011 / 21:27:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:40:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testMultiBytePrintString
<skip>
    | badClass |
    badClass := Java classForName: 'java.nio.charset.CharsetDecoder'.
    self 
        invoke: #'<init>(Ljava/nio/charset/Charset;FF)V'
        class: badClass
        args: #( 21 4 ).

    "Created: / 23-03-2011 / 16:58:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 06-07-2012 / 21:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 14:04:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSetBoolean
    self 
        shouldnt: [
            self 
                invoke: #'setBoolean(I)V'
                class: self loadSimpleClassWithManyReferences
                receiver: self loadSimpleClassWithManyReferences new
                args: nil.
        ]
        raise: Error.

    "Created: / 22-03-2011 / 12:17:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeDisassemblerTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeDisassemblerTests.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

