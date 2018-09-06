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

JavaRefsAndConstantPoolTestCase subclass:#JavaFieldRefTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaConstants'
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaFieldRefTests class methodsFor:'documentation'!

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

!JavaFieldRefTests methodsFor:'permission tests'!

testAccessingPPFromOutside
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ 
            javaFieldRef := self 
                        getFieldRefNamed: 'packagePrivateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 14-04-2011 / 15:05:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:40:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 05-07-2012 / 17:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAccessingPPFromPackage
    | javaFieldRef  initString |
                       initString := 'Lstx/libjava/tests/mocks/PublicClass;'.


self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'packagePrivateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
                javaFieldRef owner: (Java classForName: 'stx.libjava.tests.mocks.Crate').
            javaFieldRef resolve. ]
        raise: Error
        .

    "Created: / 14-04-2011 / 15:08:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:41:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPPFromSubclass
    | javaFieldRef  initString |




initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'packagePrivateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef owner: (Java classForName:  'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error.

    "Created: / 14-04-2011 / 15:08:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:42:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromOutside
    | javaFieldRef  initString |




initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'privateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:44:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:42:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromOutsideInNonPublic
    | javaFieldRef  initString |




initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self 
        should: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'privateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:47:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:43:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPrivateFromSubclass
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'privateField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:49:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:45:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromOutside
    | javaFieldRef  initString |


initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'protectedField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.

            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:44:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:46:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromOutsideInNonPublic
    | javaFieldRef  initString |



initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self 
        should: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'protectedField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.

            javaFieldRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IllegalAccessError' ].

    "Created: / 13-04-2011 / 14:47:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:46:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromPackage
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'protectedField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef owner: (Java classForName: 'stx.libjava.tests.mocks.Crate').
            javaFieldRef resolve. ]
        raise: Error
       .

    "Created: / 14-04-2011 / 15:09:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:48:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingProtectedFromSubclass
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'protectedField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error
        .

    "Created: / 13-04-2011 / 14:49:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:49:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromOutside
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'publicField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error
        .

    "Created: / 13-04-2011 / 14:44:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:51:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromOutsideInNonPublic
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/NonPublicClass;'.
    self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'publicField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error
        .

    "Created: / 13-04-2011 / 14:48:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:52:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testAccessingPublicFromSubclass
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        shouldnt: 
            [ javaFieldRef := self 
                        getFieldRefNamed: 'publicField'
                        typed: 'Ljava/lang/String;'
                        inClass: initString.
            javaFieldRef 
                owner: (Java classForName: 'stx.libjava.tests.mocks.SubclassOfPublicClass').
            javaFieldRef resolve. ]
        raise: Error
       .

    "Created: / 13-04-2011 / 14:49:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:52:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaFieldRefTests methodsFor:'resolving static tests'!

testResolvingStatic
    | javaFieldRef  initString  result  expectedResult |
    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self 
                getFieldRefNamed: 'publicStaticField'
                typed: 'Ljava/lang/String;'
                inClass: initString.
    result := javaFieldRef resolve.
    expectedResult := (Java 
                classForName: 'stx.libjava.tests.mocks.PublicClass') staticFields 
                at: 3.
    self assertTrue: (result = expectedResult).

    "Created: / 28-04-2011 / 22:00:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-12-2011 / 19:24:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaFieldRefTests methodsFor:'resolving tests'!

testCorrectInstanceCreation
    | initString  javaFieldRef |

    initString := 'Ljava/lang/String;'.
    javaFieldRef := self 
                getFieldRefNamed: 'value'
                typed: '[C'
                inClass: initString.
    self assertTrue: (javaFieldRef isResolved not).
    self assertTrue: (javaFieldRef resolvedValue isNil).
    self assertTrue: (javaFieldRef name = 'value').
    self assertTrue: (javaFieldRef descriptor = '[C').
    self assertTrue: (javaFieldRef classRef name = initString).

    "Created: / 08-04-2011 / 14:01:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:28:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCorrectResolving
    | initString  javaFieldRef  expectedResult  result |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self 
                getFieldRefNamed: 'publicField'
                typed: 'Ljava/lang/String;'
                inClass: initString.
    self assertTrue: (javaFieldRef isResolved not).
    javaFieldRef resolve.
    self assertTrue: (javaFieldRef isResolved).
    result := javaFieldRef resolve.
    expectedResult := (Java 
                classForName: 'stx.libjava.tests.mocks.PublicClass') fields 
                at: 3.
    self assertTrue: (result = expectedResult).
    self assertTrue: (javaFieldRef resolvedOffset = 4).
    self assertTrue: (javaFieldRef type = 0).

    "Created: / 08-04-2011 / 14:07:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-11-2012 / 21:44:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInvalidation
    | javaFieldRef  initString |

 initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self 
                getFieldRefNamed: 'publicField'
                typed: 'Ljava/lang/String;'
                inClass: initString.
    self assertTrue: (javaFieldRef isResolved not).
    javaFieldRef resolve.
    self assertTrue: (javaFieldRef isResolved).
    self assertTrue: (javaFieldRef classRef isResolved).
    javaFieldRef invalidate.
    self assertTrue: (javaFieldRef isResolved not).
    self assertTrue: (javaFieldRef classRef isResolved not).

    "Created: / 08-04-2011 / 14:09:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:30:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassNegative
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self 
                getFieldRefNamed: 'publicField'
                typed: 'Ljava/lang/String;'
                inClass: initString.
    self assertTrue: (javaFieldRef isResolved not).
    javaFieldRef resolve.
    self assertTrue: (javaFieldRef isResolved).
    javaFieldRef invalidateForClass: 'Ljava/lang/Object;'.
    self assertTrue: (javaFieldRef isResolved).

    "Created: / 08-04-2011 / 16:23:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:31:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassPositive
    | javaFieldRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self 
                getFieldRefNamed: 'publicField'
                typed: 'Ljava/lang/String;'
                inClass: initString.
    self assertTrue: (javaFieldRef isResolved not).
    javaFieldRef resolve.
    self assertTrue: (javaFieldRef isResolved).
    javaFieldRef invalidateForClass: 'Lstx/libjava/tests/mocks/PublicClass;'.
    self assertTrue: (javaFieldRef isResolved not).

    "Created: / 08-04-2011 / 16:23:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:31:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testResolving
    | javaFieldRef  initString |
     initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    javaFieldRef := self getFieldRefNamed: 'publicField' typed:'Ljava/lang/String;' inClass:initString.

    self assertTrue: (javaFieldRef isResolved not).
    javaFieldRef resolve.
    self assertTrue: (javaFieldRef isResolved).

    "Created: / 08-04-2011 / 14:04:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 15:53:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaFieldRefTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaFieldRefTests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

