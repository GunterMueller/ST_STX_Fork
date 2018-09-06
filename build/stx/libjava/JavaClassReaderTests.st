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

JavaRefsAndConstantPoolTestCase subclass:#JavaClassReaderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaClassReaderTests class methodsFor:'documentation'!

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

!JavaClassReaderTests methodsFor:'tests'!

testReadingClass
    | reader  constantPool  result |

    reader := JavaClassReader new.
    constantPool := JavaConstantPool new: 1.
    constantPool at: 1 put: 'Ljava/lang/Object;'.
    reader constants: constantPool.
    reader stream: (ReadStream on: #( 1 0 )).
    result := reader readConstant_Class.
    self assertTrue: (result notNil).
    self assertTrue: (result isJavaRef).
    self assertTrue: (result isNewJavaRef).
    self assertTrue: (result name = 'Ljava/lang/Object;').

    "Created: / 10-05-2011 / 13:52:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReadingField
    | reader  constantPool  result |

    reader := JavaClassReader new.
    constantPool := JavaConstantPool new: 5.
    constantPool at: 1 put: 'class'.
    constantPool at: 2 put: (self getClassRefIn: constantPool withNameAt: 1).
    constantPool at: 3
        put: (self 
                getNameAndTypeIn: constantPool
                withNameAt: 4
                andTypeAt: 5).
    constantPool at: 4 put: 'name'.
    constantPool at: 5 put: 'type'.
    constantPool owner: self someJavaClass.
    reader constants: constantPool.
    reader stream: (ReadStream on: #( 2 0 3 0 )).
    result := reader readConstant_Fieldref.
    self assertTrue: (result notNil).
    self assertTrue: (result isJavaRef).
    self assertTrue: (result isNewJavaRef).
    self assertTrue: (result classRef isJavaRef).
    self assertTrue: (result nameAndType isNewJavaNameAndType).
    self assertTrue: (result nameAndType name = 'name').
    self assertTrue: (result nameAndType descriptor = 'type').
    self assertTrue: (result owner = self someJavaClass).

    "Created: / 10-05-2011 / 14:12:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 18:00:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReadingInterfaceMethod
    | reader  constantPool  result |

    reader := JavaClassReader new.
    constantPool := JavaConstantPool new: 5.
    constantPool at: 1 put: 'class'.
    constantPool at: 2 put: (self getClassRefIn: constantPool withNameAt: 1).
    constantPool at: 3
        put: (self 
                getNameAndTypeIn: constantPool
                withNameAt: 4
                andTypeAt: 5).
    constantPool at: 4 put: 'name'.
    constantPool at: 5 put: 'type'.
    constantPool owner: self someJavaClass.
    reader constants: constantPool.
    reader stream: (ReadStream on: #( 2 0 3 0 )).
    result := reader readConstant_InterfaceMethodref.
    self assertTrue: (result notNil).
    self assertTrue: (result isJavaRef).
    self assertTrue: (result isNewJavaRef).
    self assertTrue: (result classRef isNewJavaRef).
    self assertTrue: (result classRef isNewJavaRef).
    self assertTrue: (result nameAndType isNewJavaNameAndType).
    self assertTrue: (result nameAndType name = 'name').
    self assertTrue: (result nameAndType descriptor = 'type').
    self assertTrue: (result owner = self someJavaClass).
    self assertTrue: (result owner = self someJavaClass).

    "Created: / 10-05-2011 / 14:12:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 18:00:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReadingMethod
    | reader  constantPool  result |

    reader := JavaClassReader new.
    constantPool := JavaConstantPool new: 5.
    constantPool at: 1 put: 'class'.
    constantPool at: 2 put: (self getClassRefIn: constantPool withNameAt: 1).
    constantPool at: 3
        put: (self 
                getNameAndTypeIn: constantPool
                withNameAt: 4
                andTypeAt: 5).
    constantPool at: 4 put: 'name'.
    constantPool at: 5 put: 'type'.
    constantPool owner: self someJavaClass.
    reader constants: constantPool.
    reader stream: (ReadStream on: #( 2 0 3 0 )).
    result := reader readConstant_Methodref.
    self assertTrue: (result notNil).
    self assertTrue: (result isJavaRef).
    self assertTrue: (result isNewJavaRef).
    self assertTrue: (result classRef isNewJavaRef).
    self assertTrue: (result classRef isNewJavaRef).
    self assertTrue: (result nameAndType isNewJavaNameAndType).
    self assertTrue: (result nameAndType name = 'name').
    self assertTrue: (result nameAndType descriptor = 'type').
    self assertTrue: (result owner = self someJavaClass).

    "Created: / 10-05-2011 / 14:10:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 18:00:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReadingNameAndType
    | reader  constantPool  result |

    reader := JavaClassReader new.
    constantPool := JavaConstantPool new: 2.
    constantPool at: 1 put: 'foo'.
    constantPool at: 2 put: 'bar'.
    reader constants: constantPool.
    reader stream: (ReadStream on: #( 1 0 2 0 )).
    result := reader readConstant_NameAndType.
    self assertTrue: (result notNil).
    self assertTrue: (result isJavaNameAndType).
    self assertTrue: (result isNewJavaNameAndType).
    self assertTrue: (result name = 'foo').
    self assertTrue: (result descriptor = 'bar').

    "Created: / 10-05-2011 / 13:56:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReadingStream

    |result|    
    result := JavaClassReader readStream: self getCrateClassReadStream.
    self assertTrue: (result notNil).

    "Created: / 10-05-2011 / 12:16:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-08-2011 / 17:25:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWholeConstantPoolContainsFullyInitializedItems
    | result |

    result := JavaClassReader readStream: self getCrateClassReadStream.
    result constantPool do: 
            [:each | 
            each isJavaRef 
                ifTrue: [ self assertTrue: each isNewJavaRef. self assertTrue: each owner notNil. self assertTrue: each constantPool notNil.]
                ifFalse: 
                    [ each isJavaNameAndType 
                        ifTrue: [ self assertTrue: each isNewJavaNameAndType. self assertTrue: each owner notNil. self assertTrue: each constantPool notNil.] ] ].

    "Created: / 10-05-2011 / 17:01:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

testWholeConstantPoolContainsOnlyNewRefs
    | result |

    result := JavaClassReader readStream: self getCrateClassReadStream.
    result constantPool do: 
            [:each | 
            each isJavaRef 
                ifTrue: [ self assertTrue: each isNewJavaRef ]
                ifFalse: 
                    [ each isJavaNameAndType 
                        ifTrue: [ self assertTrue: each isNewJavaNameAndType ] ] ].

    "Created: / 10-05-2011 / 12:18:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 10-05-2011 / 16:59:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

test_exceptions
    | crate m |

    crate := JavaClassReader readStream: self getCrateClassReadStream.
    m := crate methodDictionary at: #'throwSomeException(I)V'.
    self assert: m class == JavaMethodWithException.
    self assert: m exceptionTable size == 2.
    self assert: (m exceptionTable contains:[:e | e name = 'java/lang/InterruptedException' ]).
    self assert: (m exceptionTable contains:[:e | e name = 'java/lang/IllegalArgumentException' ]).

    "Created: / 14-08-2014 / 12:32:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReaderTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassReaderTests.st,v 1.6 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

