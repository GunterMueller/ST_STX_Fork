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
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaByteCodeProcessorAdapter subclass:#JavaMethodAnalyzer
	instanceVariableNames:'fieldsAccessed fieldsRead fieldsWritten staticsAccessed
		staticsRead staticsWritten methodsInvoked refdClasses
		constantsAccessed'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Decompiling'
!

!JavaMethodAnalyzer class methodsFor:'documentation'!

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
!

documentation
"
    A helper class to analyze method's bytecode and keep some statistics
    like read/written fields, sent messages, referenced classes...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaMethodAnalyzer class methodsFor:'analyzing'!

analyze: aJavaMethod
    "Analyzes the given method and return the analyzer,
     which can be in turn asked for various informstion"

     ^ self new
        process: aJavaMethod 
        receiver: nil
        arguments: (Array new: aJavaMethod javaNumArgs);
        yourself

    "Created: / 30-08-2013 / 13:33:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'enumerating'!

literalsDo: aBlock
    constantsAccessed do:aBlock.
    refdClasses do:[:ref | 
        | nameSym |

        nameSym := ref name asSymbolIfInterned.
        nameSym notNil ifTrue:[ 
            aBlock value: nameSym.
        ].
    ].
    methodsInvoked do:[:ref | 
        | selectorSym |

        selectorSym := (ref name , ref descriptor) asSymbolIfInterned.
        selectorSym notNil ifTrue:[ 
            aBlock value: selectorSym
        ].
    ]

    "Created: / 29-07-2016 / 09:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'instructions'!

anewarray
    | classRef |

    classRef := constantPool at: self fetchIndex2.
    refdClasses add: classRef.

    "Created: / 09-09-2013 / 12:21:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getfield
    | fieldRef |

    fieldRef := constantPool at: self fetchIndex2.     
    fieldsRead add: fieldRef.
    fieldsAccessed add: fieldRef.

    "Created: / 30-08-2013 / 13:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2013 / 16:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getstatic
    | fieldRef |

    fieldRef := constantPool at: self fetchIndex2.     
    staticsRead add: fieldRef.
    staticsAccessed  add: fieldRef.
    refdClasses add: fieldRef classRef.

    "Created: / 05-09-2013 / 16:19:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2013 / 12:16:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invinterface
    methodsInvoked add: (constantPool at: self fetchBytes2).
    self fetchBytes2  "/ count

    "Created: / 30-08-2013 / 17:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2013 / 20:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invnonvirt
     methodsInvoked add: (constantPool at: self fetchBytes2)

    "Created: / 30-08-2013 / 17:05:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invstatic
    methodsInvoked add: (constantPool at: self fetchBytes2)

    "Created: / 30-08-2013 / 17:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invvirt
    methodsInvoked add: (constantPool at: self fetchBytes2)

    "Created: / 30-08-2013 / 17:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc1
    self ldc: self fetchIndex.
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
    "Modified: / 29-07-2016 / 10:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2
    self ldc: self fetchIndex2

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
    "Modified: / 29-07-2016 / 10:18:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2w
    constantsAccessed add: (constantPool at: self fetchIndex2).     

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

ldc: index
    | constantOrRef |

    constantOrRef := constantPool at: index.
    constantOrRef isJavaRef ifTrue:[ 
        constantOrRef isJavaClassRef ifTrue:[
            refdClasses add: constantOrRef.
        ].
        constantOrRef isJavaStringRef ifTrue:[ 
            (constantOrRef isResolved or:[ JavaVM booted ]) ifTrue:[ 
                constantsAccessed add: constantOrRef resolve.
            ].
        ]
    ] ifFalse:[ 
        constantsAccessed add: constantOrRef    
    ].


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

    "Created: / 29-07-2016 / 10:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

multianewarray
    | classRef |

    classRef := constantPool at: self fetchIndex2.
    self fetchIndex. "/ dimensions
    refdClasses add: classRef.

    "Created: / 09-09-2013 / 12:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    | classRef |

    classRef := constantPool at: self fetchIndex2.
    refdClasses add: classRef.

    "Created: / 09-09-2013 / 12:18:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

putfield
    | fieldRef |

    fieldRef := constantPool at: self fetchIndex2.     
    fieldsAccessed add: fieldRef.
    fieldsWritten add: fieldRef.

    "Created: / 30-08-2013 / 13:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2013 / 17:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

putstatic
    | fieldRef |

    fieldRef := constantPool at: self fetchIndex2.     
    staticsWritten add: fieldRef.
    staticsAccessed  add: fieldRef.
    refdClasses add: fieldRef classRef.

    "Created: / 09-09-2013 / 12:16:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'processing loop'!

process: aMethod receiver: aReceiver arguments: args 
    fieldsAccessed := Set new.
    fieldsRead := Set new.
    fieldsWritten := Set new.

    staticsAccessed := Set new.
    staticsRead  := Set new.
    staticsWritten  := Set new.

    methodsInvoked := Set new.
    refdClasses := Set new.

    constantsAccessed := Set new.

    "/ Abstract, native or other funny method
    aMethod byteCode isNil ifTrue:[ ^ self ].

    ^ super process: aMethod receiver: aReceiver arguments: args.

    "Created: / 30-08-2013 / 13:23:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2016 / 09:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'queries'!

sends: selector
    ^ self sendsAny: (Array with: selector)

    "Created: / 31-08-2013 / 11:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sends:selector1 or:selector2
    ^ self sendsAny: (Array with: selector1 with: selector2)

    "Modified: / 31-08-2013 / 11:39:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendsAny: selectors
    selectors do:[:pair|
        methodsInvoked do:[:methodRef |
            methodRef selector = pair first ifTrue:[
                ^ true
            ]
        ]
    ].
    ^ false

    "Created: / 02-12-2011 / 23:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2013 / 21:33:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'queries-statistic'!

messagesPossiblySent
    ^ #()

    "Created: / 30-08-2013 / 14:05:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2013 / 10:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSent
    ^ methodsInvoked collect:[:methodRef |methodRef selector ]

    "Created: / 31-08-2013 / 10:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2013 / 21:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSentToSelf
    ^#()

    "Created: / 31-08-2013 / 09:31:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSentToSuper
    ^#()

    "Created: / 30-03-2013 / 09:59:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedClassVars
    ^#() "/ No class vars in Java

    "Created: / 30-08-2013 / 13:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedInstVars
    ^ method isStatic ifTrue:[
        staticsWritten collect:[:ref | ref name ]
    ] ifFalse:[
        fieldsWritten collect:[:ref | ref name ]
    ]

    "Created: / 30-08-2013 / 13:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2013 / 16:23:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readGlobals
    | names |

    names := refdClasses collect:[:ref | ref name ].
"/    (names includes: 'sun/misc/Unsafe') ifTrue:[
"/        self halt.
"/    ].
    ^ names

    "Created: / 05-09-2013 / 15:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2013 / 12:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readInstVars
    ^ method isStatic ifTrue:[
        staticsRead collect:[:ref | ref name ]
    ] ifFalse:[
        fieldsRead collect:[:ref | ref name ]
    ]

    "Created: / 05-09-2013 / 15:27:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedClassVars
    ^ #() "/ No class vars in Java

    "Created: / 30-08-2013 / 13:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedGlobals
    ^ self readGlobals

    "Created: / 05-09-2013 / 15:27:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedInstVars
    ^ method isStatic ifTrue:[
        staticsAccessed  collect:[:ref | ref name ]
    ] ifFalse:[
        fieldsAccessed  collect:[:ref | ref name ]
    ]

    "Created: / 30-08-2013 / 13:18:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2013 / 16:22:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer methodsFor:'queries-statistic-Java'!

methodsInvoked
    "Return a set of method invoked by the analyzed
     method. 

     Unlike #messagesSent, which return only
     selectors, this method returns a list of method refs,
     so the receivers' declared class is also accessible
     (through ref classRef)"

    ^ methodsInvoked

    "Created: / 31-08-2013 / 23:22:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodAnalyzer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

