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

JavaByteCodeProcessorTests subclass:#JavaByteCodeInterpreterTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaByteCodeInterpreterTests class methodsFor:'documentation'!

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

!JavaByteCodeInterpreterTests class methodsFor:'resources'!

resources

    ^ Array with: JavaInitializedResource with: JavaTestsResource.

    "Created: / 15-03-2011 / 17:29:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 14:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeInterpreterTests methodsFor:'private'!

invoke: methodName class: aClass receiver: receiver args: args 
    | method  result |
    
    method := aClass lookupMethodFor: methodName.    
    result := JavaByteCodeInterpreter new 
                interpret: method
                receiver: receiver
                arguments: args.
    ^ result.

    "Created: / 10-03-2011 / 23:30:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:32:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeInterpreterTests methodsFor:'tests'!

testAnd
    | result  expResult |

    expResult := 2r10010101.
    result := self 
                invoke: #'and(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 255 149 ).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    iload_1
     2    iand
     3    ireturn"

    "Created: / 14-03-2011 / 17:02:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:49:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testBitShiftLeft
    | result  expResult |

    expResult := 2r101010000.
    result := self 
                invoke: #'bitShiftLeft(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 21 4 ).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    iload_1
     2    ishl
     3    ireturn"

    "Created: / 14-03-2011 / 16:56:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:49:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testBitShiftRight
    | result  expResult |

    expResult := 2r11011.
    result := self 
                invoke: #'bitShiftRight(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 439 4 ).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    iload_1
     2    ishr
     3    ireturn"

    "Created: / 14-03-2011 / 16:57:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:49:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDec2
    | result  expResult |

    expResult := 1.
    result := self 
                invoke: #'dec2(I)I'
                class: self loadSimpleMathJavaClass
                args: #( 3 ).
    self assertTrue: expResult = result.

    "static method

     0    iinc 0 -1
     3    iinc 0 -1
     6    iload_0
     7    ireturn"

    "Created: / 14-03-2011 / 16:58:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:49:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDiv
    | result  expResult |

    expResult := 1.
    result := self 
                invoke: #'div(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 101 10 ).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    iload_1
     2    irem
     3    ireturn"

    "Created: / 14-03-2011 / 16:54:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:49:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testDivision
    | result  expResult |

    expResult := 10.
    result := self 
                invoke: #'division(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 101 10 ).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    iload_1
     2    idiv
     3    ireturn"

    "Created: / 14-03-2011 / 16:57:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:48:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testGetBoolean
    | result  expResult  inst |
    inst := self loadSimpleClassWithManyReferences new.
    expResult := 1.
    result := self 
            invoke: #'getBoolean()Z'
            class: inst class
            receiver: inst
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

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
    "Modified: / 21-03-2011 / 17:45:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:21 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetByte
    | result  expResult |
    expResult := 11.
    result := self 
            invoke: #'getByte()B'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 7
     6    aaload
     7    checkcast 17 [java.lang.Byte]
     10   invokevirtual 31 [JavaMethodRef (java.lang.Byte 'byteValue'()B)]
     13   ireturn"

    "Created: / 14-03-2011 / 21:34:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 22:04:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:27 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetChar
    | result  expResult |
    expResult := 97.
    result := self 
            invoke: #'getChar()C'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_3
     5    aaload
     6    checkcast 25 [java.lang.Character]
     9    invokevirtual 26 [JavaMethodRef (java.lang.Character 'charValue'()C)]
     12   ireturn"

    "Created: / 14-03-2011 / 21:31:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 17:45:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:31 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetDateArray
    | result |
    "again  - you're comparing java array with st array - watch out"
    "/  expResult := #( nil nil nil ).
    result := self 
            invoke: #'getDateArray()[Ljava/util/Date;'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).

    "/    self assertTrue: (result = expResult).
    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 8
     6    aaload
     7    checkcast 32 [UnresolvedClass([Ljava.util.Date;)]
     10   checkcast 32 [UnresolvedClass([Ljava.util.Date;)]
     13   areturn"

    "Created: / 14-03-2011 / 21:35:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 17:59:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:37 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetDouble
    | result |
    result := self 
            invoke: #'getDouble()Ljava/lang/Double;'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_2
     5    aaload
     6    checkcast 24 [java.lang.Double]
     9    areturn"

    "Created: / 14-03-2011 / 21:30:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 17:10:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:42 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetInt
    | result  expResult |
    expResult := 1.
    result := self 
            invoke: #'getInt()I'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_1
     5    aaload
     6    checkcast 13 [java.lang.Integer]
     9    invokevirtual 23 [JavaMethodRef (java.lang.Integer 'intValue'()I)]
     12   ireturn"

    "Created: / 14-03-2011 / 21:30:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 22:05:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:48 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetLong
    | result  expResult |
    expResult := 10.
    result := self 
            invoke: #'getLong()J'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_4
     5    aaload
     6    checkcast 27 [java.lang.Long]
     9    invokevirtual 28 [JavaMethodRef (java.lang.Long 'longValue'()J)]
         12   lreturn"

    "Created: / 14-03-2011 / 21:32:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 22:05:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:56 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetShort
    | result  expResult |
    expResult := 1.
    result := self 
            invoke: #'getShort()S'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    bipush 6
     6    aaload
     7    checkcast 14 [java.lang.Short]
     10   invokevirtual 30 [JavaMethodRef (java.lang.Short 'shortValue'()S)]
     13   ireturn"

    "Created: / 14-03-2011 / 21:33:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 22:06:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:06:01 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testGetString
    | result |
    result := self 
            invoke: #'getString()Ljava/lang/String;'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).

    "Modified: / 28-03-2011 / 22:40:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:06:05 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInc2
    | result  expResult |

    expResult := 5.
    result := self 
                invoke: #'inc2(I)I'
                class: self loadSimpleMathJavaClass
                args: #( 3 ).
    self assertTrue: expResult = result.

    "static method

     0    iinc 0 1
     3    iinc 0 1
     6    iload_0
     7    ireturn"

    "Created: / 14-03-2011 / 16:58:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:48:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInheritedMethodCall
    | result |

    self shouldnt: 
            [ result := self 
                        invoke: #'foo()Ljava/lang/String;'
                        class: self loadSimpleInheritingJavaClass
                        args: nil. ]
        raise: Error.
    self assertFalse: (result isNil).
"0    ldc1 2 ['foo'] 
2    areturn "

    "Created: / 14-03-2011 / 16:21:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:47:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testJustLoadConstants
    "/self shouldnt: 
    
    
    [ self 
        invoke: #'justUseConstants()V'
        class: self loadSimpleMathJavaClass
        args: #(). ] value.

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
    "Modified: / 16-03-2011 / 21:48:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testLookupSwitch
    | result  expResult |

    expResult := -1.
    result := self 
                invoke: #'switchInt(I)I'
                class: self loadSwitchExamplesClass
                receiver: self loadSwitchExamplesClass new
                args: #(-1000).
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "Created: / 21-03-2011 / 13:51:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testMultipy
    | result  expResult |

    expResult := 200.
    result := self 
                invoke: #'multiply(II)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 20 with: 10).
    self assertTrue: expResult = result.
"static method

0    iload_0 
1    iload_1 
2    imul 
3    ireturn "

    "Created: / 06-03-2011 / 14:17:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:50:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testNegateInt
    | result  expResult |

    expResult := -56.
    result := self 
                invoke: #'negateInt(I)I'
                class: self loadSimpleMathJavaClass
                args: #( 55 ).
    self assertTrue: expResult = result.
"0    iload_0 
1    iconst_m1 
2    ixor 
3    ireturn "

    "Created: / 14-03-2011 / 16:55:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:50:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testOr
    | result  expResult |

    expResult := 119.
    result := self 
                invoke: #'or(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 55 66 ).
    self assertTrue: expResult = result.
"0    iload_0 
1    iload_1 
2    ior 
3    ireturn "

    "Created: / 14-03-2011 / 17:02:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:50:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testOverridenMethodCall
    | result |

    self shouldnt: 
            [ result := self 
                        invoke: #'bar()Ljava/lang/String;'
                        class: self loadSimpleInheritingJavaClass
                        args: nil. ]
        raise: Error.
    self assertFalse: (result isNil).
"0    ldc1 2 ['bar'] 
2    areturn "

    "Modified: / 16-03-2011 / 21:51:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testPower
    | result  expResult |

    expResult := 1024.
    result := self 
                invoke: #'power(II)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 2 with: 10).
    self assertTrue: expResult = result.
"0    iload_0 
1    iload_1 
2    iconst_1 
3    invokestatic 2 [JavaMethod(stx.libjava.tests.mocks.SimpleMath::int powerAcc (int int int))] 
6    ireturn "

    "Created: / 06-03-2011 / 14:18:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:51:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testReturnArrayOfLongs
    | result |

    self shouldnt: 
            [ result := self 
                        invoke: #'giveMeArrayOfLongs()[J'
                        class: self loadSimpleMathJavaClass
                        args: #(). ]
        raise: Error.
"0    bipush 100
2    newarray 11 [T_LONG]
4    areturn "

    "Created: / 14-03-2011 / 17:08:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:52:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSetBoolean
    | inst |
    inst := self loadSimpleClassWithManyReferences new.
    self 
        invoke: #'setBoolean(I)V'
        class: inst class
        receiver: inst
        args: #( 5 ).
    self 
        invoke: #'setBoolean(I)V'
        class: inst class
        receiver: inst
        args: #( 4 ).

    "
     1:      ILOAD_1     (27)  ARGS: []                  STACK: [.. -> FIELD 1: 'Arg 1']
     2:      ICONST_2    (5)   ARGS: []                  STACK: [.. -> 2]
     3:      IREM        (112) ARGS: []                  STACK: [value, value -> result]
     4:      IFNE        (154) ARGS: [JMP to: 20]        STACK: [value -> ..]
     7:      ALOAD_0     (42)  ARGS: []                  STACK: [.. -> FIELD 0: stx.libjava.tests.mocks.SimpleClassWithManyReferences]
     8:      GETFIELD    (180) ARGS: [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)] STACK: [objectRef -> objectRef]
     11:     BIPUSH      (16)  ARGS: [9]                 STACK: [.. -> value]
     13:     GETSTATIC   (178) ARGS: [JavaFieldRef (java.lang.Boolean 'TRUE'Ljava/lang/Boolean; offs=29)] STACK: [.. -> objectRef]
     16:     AASTORE     (83)  ARGS: []                  STACK: [arrayRef, index, value -> ..]
     17:     GOTO        (167) ARGS: [JMP to: 31]        STACK: [.. -> ..]
     20:     ALOAD_0     (42)  ARGS: []                  STACK: [.. -> FIELD 0: stx.libjava.tests.mocks.SimpleClassWithManyReferences]
     21:     GETFIELD    (180) ARGS: [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)] STACK: [objectRef -> objectRef]
     24:     BIPUSH      (16)  ARGS: [9]                 STACK: [.. -> value]
     26:     ICONST_0    (3)   ARGS: []                  STACK: [.. -> 0]
     27:     INVSTATIC   (184) ARGS: [JavaMethodRef (java.lang.Boolean 'valueOf'(Z)Ljava/lang/Boolean;)] STACK: [[arg1, arg2, ...]  -> ..]
     30:     AASTORE     (83)  ARGS: []                  STACK: [arrayRef, index, value -> ..]
     31:     RETURN      (177) ARGS: []                  STACK: [.. -> EMPTY]"

    "Created: / 21-03-2011 / 18:53:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 12:18:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:06:14 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDouble
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 1234.45.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: 1234.45).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 13-03-2011 / 17:43:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:54:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:08:10 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDoubleMaxValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 1.79769313486232E+308.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: 1.79769313486232E+308).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 14-03-2011 / 14:06:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:53:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:08:06 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDoubleMinValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 4.94065645841247E-324.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: 4.94065645841247E-324).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 14-03-2011 / 14:06:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:54:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:08:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDoubleNan
    | result  crate |
    crate := self loadCrateJavaClass new.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: Float nan).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (result isNaN).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 14-03-2011 / 14:07:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:54:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:08:00 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDoubleWithInfinityArg
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := Float infinity.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: Float infinity).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 14-03-2011 / 13:52:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:54:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:57 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersDoubleWithNegativeInfinityArg
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := Float negativeInfinity.
    self 
        invoke: #'setDoubleVar(D)V'
        class: crate class
        receiver: crate
        args: (Array with: Float negativeInfinity).
    result := self 
            invoke: #'getDoubleVar()D'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setDoubleVar:
     0    aload_0
     1    dload_1
     2    putfield 3
     5    return

     getDoubleVar:
     0    aload_0
     1    getfield 3
     4    dreturn"

    "Created: / 14-03-2011 / 13:53:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:54:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:54 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersInt
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 1234.
    self 
        invoke: #'setIntVar(I)V'
        class: crate class
        receiver: crate
        args: (Array with: 1234).
    result := self 
            invoke: #'getIntVar()I'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setIntVar:
     0    aload_0
     1    iload_1
     2    putfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     5    return

     getIntVar:
     0    aload_0
     1    getfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     4    ireturn"

    "Created: / 13-03-2011 / 17:42:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:55:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:50 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersIntMaxValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 2147483647.
    self 
        invoke: #'setIntVar(I)V'
        class: crate class
        receiver: crate
        args: (Array with: 2147483647).
    result := self 
            invoke: #'getIntVar()I'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setIntVar:
     0    aload_0
     1    iload_1
     2    putfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     5    return

     getIntVar:
     0    aload_0
     1    getfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     4    ireturn"

    "Created: / 14-03-2011 / 14:02:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:55:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:43 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersIntMinValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := -2147483648.
    self 
        invoke: #'setIntVar(I)V'
        class: crate class
        receiver: crate
        args: (Array with: -2147483648).
    result := self 
            invoke: #'getIntVar()I'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setIntVar:
     0    aload_0
     1    iload_1
     2    putfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     5    return

     getIntVar:
     0    aload_0
     1    getfield 2 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'intVar'I offs=1)]
     4    ireturn"

    "Created: / 14-03-2011 / 14:01:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:55:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:40 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersLong
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890.
    self 
        invoke: #'setLongVar(J)V'
        class: crate class
        receiver: crate
        args: (Array 
                with: 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890).
    result := self 
            invoke: #'getLongVar()J'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setLongVar:
     0    aload_0
     1    lload_1
     2    putfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     5    return

     getLongVar:
     0    aload_0
     1    getfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     4    lreturn"

    "Created: / 14-03-2011 / 13:36:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:56:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:36 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersLongMaxValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 9223372036854775807.
    self 
        invoke: #'setLongVar(J)V'
        class: crate class
        receiver: crate
        args: (Array with: 9223372036854775807).
    result := self 
            invoke: #'getLongVar()J'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setLongVar:
     0    aload_0
     1    lload_1
     2    putfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     5    return

     getLongVar:
     0    aload_0
     1    getfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     4    lreturn"

    "Created: / 14-03-2011 / 14:04:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:56:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:33 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersLongMinValue
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := -9223372036854775808.
    self 
        invoke: #'setLongVar(J)V'
        class: crate class
        receiver: crate
        args: (Array with: -9223372036854775808).
    result := self 
            invoke: #'getLongVar()J'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setLongVar:
     0    aload_0
     1    lload_1
     2    putfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     5    return

     getLongVar:
     0    aload_0
     1    getfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     4    lreturn"

    "Created: / 14-03-2011 / 14:04:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:56:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:29 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:47:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersLongWithIntArg
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 12.
    self 
        invoke: #'setLongVar(J)V'
        class: crate class
        receiver: crate
        args: (Array with: 12).
    result := self 
            invoke: #'getLongVar()J'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setLongVar:
     0    aload_0
     1    lload_1
     2    putfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     5    return

     getLongVar:
     0    aload_0
     1    getfield 4 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'longVar'J offs=3)]
     4    lreturn"

    "Created: / 14-03-2011 / 13:49:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:56:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:24 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSetterAndGettersString
    | result  expResult  crate |
    crate := self loadCrateJavaClass new.
    expResult := 'hello world'.
    self 
        invoke: #'setStringVar(Ljava/lang/String;)V'
        class: crate class
        receiver: crate
        args: (Array with: 'hello world').
    result := self 
            invoke: #'getStringVar()Ljava/lang/String;'
            class: crate class
            receiver: crate
            args: nil.
    self assert: (expResult = result).

    "setString:
     0    aload_0
     1    aload_1
     2    putfield 5 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'stringVar'Ljava/lang/String; offs=4)]
     5    return

     getString:
     0    aload_0
     1    getfield 5 [JavaFieldRef (stx.libjava.tests.mocks.Crate 'stringVar'Ljava/lang/String; offs=4)]
     4    areturn"

    "Created: / 14-03-2011 / 13:45:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:57:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:07:19 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 02-03-2016 / 07:48:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSimpleAdd
    | result  expResult |

    expResult := 2002.
    result := self 
                invoke: #'add2To2000Expect2002()I'
                class: self loadSimpleMathJavaClass
                args: nil.
    self assertTrue: expResult = result.

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
    "Modified: / 16-03-2011 / 21:57:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSimpleAdd2
    | result  expResult |

    expResult := 5.
    result := self 
                invoke: #'addMinus5ToArg(I)I'
                class: self loadSimpleMathJavaClass
                args: (Array with: 10).
    self assertTrue: expResult = result.

    "static method

     0    iload_0
     1    bipush -5
     3    iadd
     4    ireturn"

    "Created: / 06-03-2011 / 14:18:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:59:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testStackCreation
    | result  expResult |

    expResult := 7.
    result := self 
                invoke: #'isYourStackCreatedCorrectly()I'
                class: self loadSimpleMathJavaClass
                args: #().
    self assertTrue: expResult = result.

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
    "Modified: / 16-03-2011 / 21:59:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSumArray
    | result  expResult |

    expResult := 15.
    result := self 
                invoke: #'sumArray([I)I'
                class: self loadSimpleMathJavaClass
                args: #( #(1 2 3 4 5) ).
    self assertTrue: expResult = result.

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
    "Modified: / 16-03-2011 / 21:58:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testSumArrayOfDoubles
    | result  expResult |

    expResult := 16.5.
    result := self 
                invoke: #'sumArrayOfDoubles([D)D'
                class: self loadSimpleMathJavaClass
                args: #( #(1.1 2.2 3.3 4.4 5.5) ).
    self assertTrue: expResult = result.
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
23   dreturn "

    "Created: / 14-03-2011 / 17:07:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:59:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testTableSwitch
    | result  expResult |

    expResult := 1.
    result := self 
                invoke: #'switchChar(C)I'
                class: self loadSwitchExamplesClass
                receiver: self loadSwitchExamplesClass new
                args: #($b).
    self assertFalse: (result isNil).
    self assertTrue: (result = expResult).

    "Created: / 21-03-2011 / 13:51:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testUnsignedBitShiftLeft
    | result  expResult |

    expResult := 1234 bitShift: 5.
    result := self 
                invoke: #'unsignedBitShiftRight(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 1234 5 ).
    self assertTrue: expResult = result.
"0    iload_0 
1    iload_1 
2    iushr 
3    ireturn"

    "Created: / 14-03-2011 / 17:01:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:59:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testXor
    | result  expResult |

    expResult := 1234 bitXor: 5.
    result := self 
                invoke: #'xor(II)I'
                class: self loadSimpleMathJavaClass
                args: #( 1234 5 ).
    self assertTrue: expResult = result.
"0    iload_0 
1    iload_1 
2    ixor 
3    ireturn "

    "Modified: / 06-03-2011 / 15:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 14-03-2011 / 17:02:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 21:59:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeInterpreterTests methodsFor:'tests2'!

testGetIntArray
    <skip>
    | result  expResult |
    "again  - you're comparing java array with st array - watch out"
    expResult := #( nil nil nil nil nil ).
    result := self 
            invoke: #'getIntArray()[I'
            class: self loadSimpleClassWithManyReferences
            receiver: self loadSimpleClassWithManyReferences new
            args: nil.
    self assertFalse: (result isNil).
    self 
        invoke: #'setIntArray([I)V'
        class: self loadSimpleClassWithManyReferences
        receiver: self loadSimpleClassWithManyReferences new
        args: (Array with: result).

    "/self assertTrue: (result = expResult).
    "0    aload_0 
     1    getfield 3 [JavaFieldRef (stx.libjava.tests.mocks.SimpleClassWithManyReferences 'values'[Ljava/lang/Object; offs=1)]
     4    iconst_5
     5    aaload
     6    checkcast 29 [JavaBuiltInClassPointerRef(class:IntegerArray ; name&type: '[I')]
     9    checkcast 29 [JavaBuiltInClassPointerRef(class:IntegerArray ; name&type: '[I')]
     12   areturn"

    "Created: / 14-03-2011 / 21:33:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 18:53:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2012 / 19:05:52 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 22:45:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInitSimpleClassWithManyReferences
    <skip>
    | c |
    self 
        invoke: #'<init>()V'
        class: (c := self loadSimpleClassWithManyReferences)
        receiver: c new
        args: nil.

    "Created: / 21-12-2012 / 19:05:02 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

testInitimpleClassWithManyReferences
    <skip>
    | c |
    self 
        invoke: #'<init>()V'
        class: (c := self loadSimpleClassWithManyReferences)
        receiver: c new
        args: nil.

    "Created: / 21-12-2012 / 19:05:09 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaByteCodeInterpreterTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/JavaByteCodeInterpreterTests.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

