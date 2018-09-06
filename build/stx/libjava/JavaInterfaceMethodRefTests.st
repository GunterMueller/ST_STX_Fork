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

JavaRefsAndConstantPoolTestCase subclass:#JavaInterfaceMethodRefTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaInterfaceMethodRefTests class methodsFor:'documentation'!

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

!JavaInterfaceMethodRefTests methodsFor:'javaInterfaceMethodRef tests'!

testCorrectInstanceCreation
    | initString  javaMethodRef |

    initString := 'Ljava/lang/Runnable;'.
    javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    self assertTrue: (javaMethodRef resolvedValue isNil).
    self assertTrue: (javaMethodRef name = 'run').
    self assertTrue: (javaMethodRef descriptor = '()V').
    self assertTrue: (javaMethodRef classRef name = 'Ljava/lang/Runnable;').

    "Created: / 08-04-2011 / 14:01:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:19:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:13:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCorrectResolving
    | initString  javaMethodRef  expectedResult  result |

    initString := 'Ljava/lang/Runnable;'.
    javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
                typed: '()V'
                inClass: initString.
    result := javaMethodRef resolve.
    expectedResult := (Java classForName: 'java.lang.Runnable') 
                methodDictionary at: #'run()V'.
    self assertTrue: (result = expectedResult).

    "Created: / 08-04-2011 / 14:07:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:18:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidation
    | javaMethodRef  initString|

   initString :='Ljava/lang/Runnable;'.

    javaMethodRef := javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
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
    "Modified: / 23-05-2011 / 17:19:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassNegative
    | javaMethodRef  initString|

    initString :='Ljava/lang/Runnable;'.

    javaMethodRef := javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef isResolved).
    self assertTrue: (javaMethodRef classRef isResolved).
    javaMethodRef invalidateForClass: 'Ljava/lang/Object;'.
    self assertTrue: (javaMethodRef isResolved).
    self assertTrue: (javaMethodRef classRef isResolved).

    "Created: / 08-04-2011 / 16:23:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:20:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testInvalidationForClassPositive
    | javaMethodRef  initString|

    initString :='Ljava/lang/Runnable;'.

    javaMethodRef := javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef isResolved).
    self assertTrue: (javaMethodRef classRef isResolved).
    javaMethodRef invalidateForClass: 'Ljava/lang/Runnable;'.
    self assertTrue: (javaMethodRef isResolved not).
    self assertTrue: (javaMethodRef classRef isResolved not).

    "Created: / 08-04-2011 / 16:23:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:20:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testResolving
    | javaMethodRef  initString|

     initString :='Ljava/lang/Runnable;'.

    javaMethodRef := javaMethodRef := self 
                getInterfaceMethodRefNamed: 'run'
                typed: '()V'
                inClass: initString.
    self assertTrue: (javaMethodRef isResolved not).
    javaMethodRef resolve.
    self assertTrue: (javaMethodRef classRef isResolved).
    self assertTrue: (javaMethodRef isResolved).

    "Created: / 08-04-2011 / 14:04:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:21:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaInterfaceMethodRefTests methodsFor:'permission tests'!

testAccessingPublicFromSubclass
    | javaMethodRef  initString |

    initString := 'Lstx/libjava/tests/mocks/PublicClass;'.
    self 
        should: 
            [ javaMethodRef := self 
                        getInterfaceMethodRefNamed: 'publicMethod'
                        typed: '()Ljava/lang/String;'
                        inClass: initString.
            javaMethodRef resolve. ]
        raise: Error
        suchThat: [:e | e messageText = 'IncompatibleClassChangeError' ].

    "Created: / 13-04-2011 / 14:49:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 17:54:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaInterfaceMethodRefTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaInterfaceMethodRefTests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

