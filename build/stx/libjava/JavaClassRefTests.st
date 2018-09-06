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

JavaRefsAndConstantPoolTestCase subclass:#JavaClassRefTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaClassRefTests class methodsFor:'documentation'!

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

!JavaClassRefTests methodsFor:'arrays'!

testCorrectArrayCreation
    | classRef  result  expectedResult |
    classRef := self getClassRefNamed: '[Ljava/lang/Object;'.
    result := classRef resolve.
    expectedResult := JavaArray 
            javaArrayClassFor: (Java classForName: 'java.lang.Object').
    self assertTrue: (result = expectedResult).

    "Created: / 23-05-2011 / 21:15:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testCorrectMultiArrayCreation
    | classRef  result  expectedResult |
    classRef := self getClassRefNamed: '[[Ljava/lang/Object;'.
    result := classRef resolve.
    expectedResult := JavaArray javaArrayClassFor: (JavaArray 
                    javaArrayClassFor: (Java classForName: 'java.lang.Object')).
    self assertTrue: (result name = expectedResult name).

    "Created: / 23-05-2011 / 21:15:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRefTests methodsFor:'permission tests'!

testAccessingNonPublicFromInside
    | javaClassRef  initString  throwedException |

    [ initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'stx.libjava.tests.mocks.Crate').
    javaClassRef resolve. ] on: Error
            do: [:e | throwedException := e ].
    self assertTrue: (throwedException isNil).

    "Created: / 13-04-2011 / 13:42:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 08:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAccessingNonPublicFromOutside
    | javaClassRef  initString  throwedException |

    [
        initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
        javaClassRef := self getClassRefNamed:initString.
        javaClassRef owner: self someJavaClass.
        javaClassRef resolve.
    ] on:Error do:[:e | throwedException := e ].
    self assertTrue:(throwedException notNil 
                and:[ throwedException messageText = 'IllegalAccessError' ]).

    "Created: / 13-04-2011 / 13:37:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 08:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAccessingPublic
    | javaClassRef  initString |

    self shouldnt: 
            [ initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
            javaClassRef := self getClassRefNamed: initString.
            javaClassRef owner: self someJavaClass.
            javaClassRef resolve. ]
        raise: Error.

    "Created: / 13-04-2011 / 13:36:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 09:00:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNonPublicClassPresent
    | javaClassRef  initString |

    initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java 
                classForName: 'stx.libjava.tests.mocks.SubclassOfNonPublicClass').
    javaClassRef resolve.
    self assertTrue: (javaClassRef resolvedValue notNil).

    "Created: / 13-04-2011 / 13:38:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 09:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPublicClassPresent
    | javaClassRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: self someJavaClass.
    javaClassRef resolve.
    self assertTrue: (javaClassRef resolvedValue notNil).

    "Created: / 13-04-2011 / 13:39:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 09:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRefTests methodsFor:'primitives'!

testAllPrimitiveArrayClasses
    | classRef  descriptor |

    #( $B $D $F $I $J $S $Z ) do: 
            [:each | 
            descriptor := '[' , each.
            classRef := self getClassRefNamed: descriptor.
            self assertTrue: ((JavaDescriptor readFromString: descriptor) javaClass 
                        = classRef resolve) ].

    "Created: / 23-05-2011 / 20:49:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAllPrimitiveClasses
    | classRef |

    #( $B $C $D $F $I $J $S $Z )
        do: 
            [:each | 

            classRef := self getClassRefNamed: each asString.
            self assertTrue: ((JavaDescriptor baseTypes at: each) = classRef resolve) ].

    "Created: / 23-05-2011 / 20:48:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAllPrimitiveMultiArrayClasses
    | classRef  descriptor |
    #( $B $D $F $I $J $S $Z ) do: [
        :each | 
        descriptor := '[[[[' , each.
        classRef := self getClassRefNamed: descriptor.
        self assertTrue: ((JavaDescriptor readFromString: descriptor) match: classRef resolve). 
    ].

    "Created: / 23-05-2011 / 20:50:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-11-2012 / 21:40:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRefTests methodsFor:'resolving static tests'!

testCorrectStaticResolving
    | javaClassRef  initString  result  expectedResult |
    initString := 'Lstx/libjava/tests/mocks/ClassWithInnerClasses$InnerStatic;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef 
        owner: (Java classForName: 'stx.libjava.tests.mocks.ClassWithInnerClasses').
    expectedResult := Java 
                classForName: 'stx.libjava.tests.mocks.ClassWithInnerClasses$InnerStatic'.
    result := javaClassRef resolve.
    self assertTrue: (result = expectedResult).

    "Created: / 28-04-2011 / 21:51:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-12-2011 / 19:24:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRefTests methodsFor:'resolving tests'!

testCorrectInstanceCreation
    | javaClassRef  initString |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    self assertFalse: (javaClassRef isResolved).
    self assertTrue: (javaClassRef resolvedValue isNil).
    self assertTrue: (javaClassRef name = initString).

    "Created: / 08-04-2011 / 14:01:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:12:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCorrectResolving
    | javaClassRef  initString  result  expectedResult |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'java.lang.Object').
    expectedResult := Java classForName: 'java.lang.String'.
    result := javaClassRef resolve.
    self assertTrue: (result = expectedResult).

    "Created: / 08-04-2011 / 14:07:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidation
    | javaClassRef  initString |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'java.lang.Object').
    self assertTrue: (javaClassRef isResolved not).
    javaClassRef resolve.
    self assertTrue: (javaClassRef isResolved).
    javaClassRef invalidate.
    self assertTrue: (javaClassRef isResolved not).

    "Created: / 08-04-2011 / 14:09:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassNegative
    | javaClassRef  initString |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'java.lang.Object').
    self assertTrue: (javaClassRef isResolved not).
    javaClassRef resolve.
    self assertTrue: (javaClassRef isResolved).
    javaClassRef invalidateForClass: 'Ljava/lang/Object;'.
    self assertTrue: (javaClassRef isResolved).

    "Created: / 08-04-2011 / 16:21:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:58:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassPositive
    | javaClassRef  initString |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'java.lang.Object').
    self assertTrue: (javaClassRef isResolved not).
    javaClassRef resolve.
    self assertTrue: (javaClassRef isResolved).
    javaClassRef invalidateForClass: initString.
    self assertTrue: (javaClassRef isResolved not).

    "Created: / 08-04-2011 / 16:21:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:57:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testResolving
    | javaClassRef  initString |

    initString := 'Ljava/lang/String;'.
    javaClassRef := self getClassRefNamed: initString.
    javaClassRef owner: (Java classForName: 'java.lang.Object').
    self assertTrue: (javaClassRef isResolved not).
    javaClassRef resolve.
    self assertTrue: (javaClassRef isResolved).

    "Created: / 08-04-2011 / 14:04:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:57:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRefTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassRefTests.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

