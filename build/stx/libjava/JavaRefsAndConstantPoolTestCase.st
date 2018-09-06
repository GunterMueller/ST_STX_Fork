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

TestCase subclass:#JavaRefsAndConstantPoolTestCase
	instanceVariableNames:'exceptionThrowerBackup'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

Object subclass:#JavaExceptionThrowerMock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRefsAndConstantPoolTestCase
!

!JavaRefsAndConstantPoolTestCase class methodsFor:'documentation'!

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

!JavaRefsAndConstantPoolTestCase class methodsFor:'resources'!

resources
    ^ Array with: JavaInitializedResource with: JavaTestsResource.

    "Created: / 26-04-2011 / 13:03:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase class methodsFor:'testing'!

isAbstract
    ^self == JavaRefsAndConstantPoolTestCase

    "Created: / 06-07-2012 / 21:53:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase methodsFor:'cp creation helpers'!

getClassRefNamed: name 
    "creates classRef with correctly prepared constant pool"
    
    | cp |

    cp := JavaConstantPool new:2.
    cp at: 1 put: (self getClassRefIn: cp withNameAt: 2).
    cp at: 2 put: name.
    cp do:[:ref|ref isJavaRef ifTrue:[ref preResolve]].

    ^ cp at: 1.

    "Created: / 23-05-2011 / 16:17:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getFieldRefNamed: name typed: type inClass: classString
    "creates fieldRef with correctly prepared constant pool"
    | cp |

    cp := JavaConstantPool new: 6.
    cp at: 1 put: (self getClassRefIn: cp withNameAt: 2).
    cp at: 2 put: classString.
    cp at: 3 put: name.
    cp at: 4 put: type.
    cp at: 5
        put: (self 
                getFieldRefIn: cp
                withNameAndTypeAt: 6 andClassAt: 1).
    cp at: 6 put: (self getNameAndTypeIn: cp withNameAt: 3 andTypeAt: 4).
    cp do:[:ref|ref isJavaRef ifTrue:[ref preResolve]].

    ^ cp at: 5.

    "Created: / 23-05-2011 / 15:56:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:11:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getInterfaceMethodRefNamed: name typed: type inClass: classString 
   "creates interfaceMethodRef with correctly prepared constant pool"
    | cp |

    cp := JavaConstantPool new: 6.
    cp at: 1 put: (self getClassRefIn: cp withNameAt: 2).
    cp at: 2 put: classString.
    cp at: 3 put: name.
    cp at: 4 put: type.
    cp at: 5
        put: (self 
                getInterfaceMethodRefIn: cp
                withNameAndTypeAt: 6
                andClassAt: 1).
    cp at: 6
        put: (self 
                getNameAndTypeIn: cp
                withNameAt: 3
                andTypeAt: 4).
    cp do:[:ref|ref isJavaRef ifTrue:[ref preResolve]].
    ^ cp at: 5.

    "Created: / 23-05-2011 / 16:15:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getMethodRefNamed: name typed: type inClass: classString 
   "creates methodRef with correctly prepared constant pool"
    | cp |

    cp := JavaConstantPool new: 6.
    cp at: 1 put: (self getClassRefIn: cp withNameAt: 2).
    cp at: 2 put: classString.
    cp at: 3 put: name.
    cp at: 4 put: type.
    cp at: 5
        put: (self 
                getMethodRefIn: cp
                withNameAndTypeAt: 6
                andClassAt: 1).
    cp at: 6
        put: (self 
                getNameAndTypeIn: cp
                withNameAt: 3
                andTypeAt: 4).
    cp do:[:ref|ref isJavaRef ifTrue:[ref preResolve]].
    ^ cp at: 5.

    "Created: / 23-05-2011 / 16:00:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 09:12:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase methodsFor:'helpers'!

getCrateClassReadStream
    ^ ((stx_libjava packageDirectory / 'tests' ) 
        / 'java' / 'bin' 
        / 'stx' / 'libjava' 
        / 'tests' / 'mocks' 
        / 'Crate.class') readStream.

    "Created: / 10-05-2011 / 12:13:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 16:26:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 24-01-2013 / 23:23:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getPrettyBigConstantPool
    | cp |

    cp := JavaConstantPool new: 20.
    cp at: 1 put: 6.
    cp at: 2 put: 'Ljava/lang/Object;'.
    cp at: 3 putClassRefWithNameAt: 2.
    cp 
        at: 4
        putMethodRefWithClassAt: 3
        andNameAndTypeAt: 5.
    cp 
        at: 5
        putNameAndTypeWithNameAt: 6
        andDescriptorAt: 7.
    cp at: 6 put: '<init>'.
    cp at: 7 put: '()V'.
    cp at: 8 put: 'Ljava/lang/String;'.
    cp at: 9 putClassRefWithNameAt: 8.
    cp 
        at: 10
        putMethodRefWithClassAt: 9
        andNameAndTypeAt: 13.
    cp at: 11 put: 'length'.
    cp at: 12 put: '()I'.
    cp 
        at: 13
        putNameAndTypeWithNameAt: 11
        andDescriptorAt: 12.
    cp at: 14 putClassRefWithNameAt: 15.
    cp at: 15 put: 'Ljava/lang/Runnable;'.
    cp at: 16 put: 'run'.
    cp at: 17 put: '()V'.
    cp 
        at: 18
        putNameAndTypeWithNameAt: 16
        andDescriptorAt: 17.
    cp at: 19 putClassRefWithNameAt: 15.
    cp 
        at: 20
        putInterfaceMethodRefWithClassAt: 19
        andNameAndTypeAt: 18.
    ^ cp

    "Modified: / 23-05-2011 / 15:16:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

someJavaClass
    ^ Java classForName: 'org.junit.runners.JUnit4'.

    "Created: / 12-05-2011 / 19:09:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 26-01-2014 / 17:08:01 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase methodsFor:'refs creation'!

getClassRefIn: aJavaConstantPool withNameAt: nameCPIndex 
    | result |

    result := JavaClassRef2 in: aJavaConstantPool withNameAt: nameCPIndex.
    result owner: self someJavaClass.
    ^ result.

    "Created: / 12-05-2011 / 19:14:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 16:24:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getFieldRefIn: cp withNameAndTypeAt: nmIndex andClassAt: classIndex 
    |result|

    result := JavaFieldRef2 
        in: cp
        withNameAndTypeAt: nmIndex
        andClassAt: classIndex.
result owner: self someJavaClass.
    ^ result.

    "Created: / 23-05-2011 / 16:01:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getInterfaceMethodRefIn: cp withNameAndTypeAt: nmIndex andClassAt: classIndex 
    |result|

    result:= JavaInterfaceMethodRef2 
        in: cp
        withNameAndTypeAt: nmIndex
        andClassAt: classIndex.
 result owner: self someJavaClass.
    ^ result.

    "Created: / 23-05-2011 / 15:58:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getMethodRefIn: cp withNameAndTypeAt: nmIndex andClassAt: classIndex 
    |result|

    result := JavaMethodRef2 
        in: cp
        withNameAndTypeAt: nmIndex
        andClassAt: classIndex.
 result owner: self someJavaClass.
    ^ result.

    "Created: / 23-05-2011 / 15:58:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getNameAndTypeIn: cp withNameAt: nameIndex andTypeAt: typeIndex 
    |result|

    result := JavaNameAndType2 
        in: cp
        withNameAt: nameIndex
        andDescriptorAt: typeIndex.
 result owner: self someJavaClass.
    ^ result.

    "Created: / 23-05-2011 / 16:00:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase methodsFor:'running'!

setUp
    super setUp.
    exceptionThrowerBackup := JavaResolver uniqueInstance exceptionThrower.
    JavaResolver uniqueInstance exceptionThrower: JavaExceptionThrowerMock new.

    "Created: / 12-05-2011 / 17:30:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 18:02:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 08:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    JavaResolver uniqueInstance exceptionThrower: exceptionThrowerBackup.
    super tearDown.

    "Created: / 12-05-2011 / 17:30:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2016 / 08:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase::JavaExceptionThrowerMock class methodsFor:'documentation'!

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

version_SVN
    ^ 'Id'
! !

!JavaRefsAndConstantPoolTestCase::JavaExceptionThrowerMock methodsFor:'exceptions'!

throwAbstractMethodError
    self error: 'AbstractMethodError'.

    "Created: / 11-04-2011 / 20:19:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:09:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIllegalAccessError
    self error: 'IllegalAccessError'.

    "Created: / 11-04-2011 / 19:39:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:09:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIllegalAccessException
    self error: 'IllegalAccessException'.

    "Created: / 13-04-2011 / 23:02:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIncompatibleClassChangeError
    self error: 'IncompatibleClassChangeError'.

    "Created: / 11-04-2011 / 20:02:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:09:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNoSuchFieldException
    self error: 'NoSuchFieldException'.

    "Created: / 11-04-2011 / 21:35:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:10:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNoSuchMethodError
    self error: 'NoSuchMethodError'.

    "Created: / 11-04-2011 / 20:19:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2011 / 14:10:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRefsAndConstantPoolTestCase class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaRefsAndConstantPoolTestCase.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

