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

JavaRefsAndConstantPoolTestCase subclass:#JavaMethodRefTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaMethodRefTests class methodsFor:'documentation'!

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

!JavaMethodRefTests methodsFor:'permission tests'!

testAccessingPPFromOutside
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'packagePrivateMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.

            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 14-04-2011 / 15:10:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:15:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPPFromSubclass
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'packagePrivateMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error
        .

    "Created: / 14-04-2011 / 15:10:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:14:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromOutside
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'privateMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:44:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:16:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromOutsideInNonPublic
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'privateMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:47:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:17:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromSubclass
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'privateMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
                javaMethodRef owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:49:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:13:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromOutside
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'protectedMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:44:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:12:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromOutsideInNonPublic
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'protectedMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.

            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:47:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:12:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromPackage
    | javaMethodRef  initString |

initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.Crate').
            javaMethodRef resolve. ]
        raise: Error.

    "Created: / 14-04-2011 / 15:09:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:11:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromSubclass
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'protectedMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error.

    "Created: / 13-04-2011 / 14:49:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:11:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromOutside
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error.

    "Created: / 13-04-2011 / 14:44:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:10:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromOutsideInNonPublic
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error.

    "Created: / 13-04-2011 / 14:48:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:10:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromSubclass
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self shouldnt: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaMethodRef resolve. ]
        raise: Error.

    "Created: / 13-04-2011 / 14:49:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:10:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicInterfaceFromOutside
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicInterface;'.
    self should: 
            [ javaMethodRef := self 
                        getMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.PublicClass').
            javaMethodRef resolve. ]
        raise: Error suchThat: [:e | e messageText = 'IncompatibleClassChangeError'].

    "Created: / 23-05-2011 / 17:54:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodRefTests methodsFor:'resolving static tests'!

testCorrectStaticResolving
    | initString  javaMethodRef  expectedResult  result |
    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaMethodRef := self 
                getMethodRefNamed: 'publicStaticMethod'
                typed: '()Ljava/lang/String;'
                inClass: initString.
    result := javaMethodRef resolve.
    expectedResult := (Java 
                classForName: 'stx.libjava.tests.mocks.PublicClass') methodDictionary 
                at: #'publicStaticMethod()Ljava/lang/String;'.
    self assertTrue: (result = expectedResult).

    "Created: / 28-04-2011 / 22:46:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-12-2011 / 19:25:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodRefTests methodsFor:'resolving tests'!

testCorrectInstanceCreation
    | initString  javaMethodRef |

    initString := 'Ljava/lang/String;'.
    javaMethodRef := self getMethodRefNamed: '<init>' typed: '()V' inClass: initString.

    self assertTrue: (javaMethodRef isResolved not).
    self assertTrue: (javaMethodRef resolvedValue isNil).
    self assertTrue: (javaMethodRef name = '<init>').
    self assertTrue: (javaMethodRef descriptor = '()V').
    self assertTrue: (javaMethodRef classRef name = 'Ljava/lang/String;').

    "Created: / 08-04-2011 / 14:01:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:03:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCorrectResolving
    | initString  javaMethodRef  expectedResult  result |

    initString := 'Ljava/lang/String;'.
    javaMethodRef :=  self 
                getMethodRefNamed: '<init>'
                typed: '()V'
                inClass: initString.

    result := javaMethodRef resolve.
    expectedResult := (Java classForName: 'java.lang.String') methodDictionary 
                at: #'<init>()V'.
    self assertTrue: (result = expectedResult).

    "Created: / 08-04-2011 / 14:07:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:06:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidation
    | javaMethodRef  initString|

    initString := 'Ljava/lang/String;'.
     javaMethodRef := self 
                getMethodRefNamed: '<init>'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef isResolved).
    self assertTrue: (javaMethodRef classRef isResolved).
    javaMethodRef invalidate.
    self assertTrue: (javaMethodRef isResolved not).
    self assertTrue: (javaMethodRef classRef isResolved not).

    "Created: / 08-04-2011 / 14:09:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:06:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassNegative
    | javaMethodRef  initString|

    initString := 'Ljava/lang/String;'.

    javaMethodRef :=  self 
                getMethodRefNamed: '<init>'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef isResolved).
    javaMethodRef invalidateForClass: 'Ljava/lang/Object;'.
    self assertTrue: (javaMethodRef isResolved).

    "Created: / 08-04-2011 / 16:23:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:07:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassPositive
    | javaMethodRef  initString|

    initString := 'Ljava/lang/String;'.
    javaMethodRef := self 
                getMethodRefNamed: '<init>'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef isResolved).
    javaMethodRef invalidateForClass: 'Ljava/lang/String;'.
    self assertTrue: (javaMethodRef isResolved not).

    "Created: / 08-04-2011 / 16:23:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:07:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testResolving
    | initString javaMethodRef |

    initString := 'Ljava/lang/String;'.
    javaMethodRef := self 
                getMethodRefNamed: '<init>'
                typed: '()V'
                inClass: initString.

    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef classRef isResolved).
    self assertTrue: (javaMethodRef isResolved).

    "Created: / 08-04-2011 / 14:04:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:05:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodRefTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodRefTests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

