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

TestCase subclass:#JavaByteCodeProcessorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaByteCodeProcessorTests class methodsFor:'documentation'!

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

!JavaByteCodeProcessorTests class methodsFor:'testing'!

isAbstract

    ^self == JavaByteCodeProcessorTests

    "Created: / 08-08-2011 / 17:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessorTests methodsFor:'tests-helpers'!

invoke: methodName class: aClass args: args 
   ^ self invoke:methodName class: aClass receiver:aClass args: args

    "Created: / 10-03-2011 / 23:32:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invoke:arg1 class:arg2 receiver:arg3 args:arg4
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

loadCrateJavaClass
    ^ Java classForName: 'stx.libjava.tests.mocks.Crate'.

    "Created: / 10-03-2011 / 21:34:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

loadSimpleClassWithManyReferences
    ^ Java 
        classForName: 'stx.libjava.tests.mocks.SimpleClassWithManyReferences'.

    "Created: / 14-03-2011 / 21:26:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-04-2011 / 23:15:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadSimpleInheritingJavaClass
    ^ Java classForName: 'stx.libjava.tests.mocks.SimpleInheritingClass'.

    "Created: / 10-03-2011 / 21:34:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-04-2011 / 23:15:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadSimpleMathJavaClass
    ^ Java classForName: 'stx.libjava.tests.mocks.SimpleMath'.

    "Created: / 10-03-2011 / 21:28:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-04-2011 / 23:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadSwitchExamplesClass
    ^ Java classForName: 'stx.libjava.tests.mocks.SwitchExamples'.

    "Created: / 21-03-2011 / 13:51:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-04-2011 / 23:15:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessorTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeProcessorTests.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

