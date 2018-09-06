"{ Encoding: utf8 }"

"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

ClassAndMethodCompilingTestCase subclass:#ChangeSetTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'
!

Object subclass:#ExistingPrivateClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetTests
!

ReadWriteStream subclass:#NonPositionableReadWriteStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetTests
!

!ChangeSetTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ChangeSetTests methodsFor:'private'!

performTest
    ^Class withoutUpdatingChangesDo:[
	super performTest
    ]

    "Created: / 20-11-2012 / 15:08:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - ChangeSet'!

test_saveToStream_format_nil_01
    | cs output chunks |

    cs := ChangeSet forExistingClass: self class.
    cs := cs select:[:each | each isMethodChange and:[ each selector = testSelector ]].
    output := (String streamContents:[ :s | cs saveToStream: s  format: nil ]) readStream.
    chunks := OrderedCollection streamContents:[ :s |
	[ output atEnd ] whileFalse:[
	    s nextPut: output nextChunk.
	].
    ].

    self assert: chunks size == 6.

    self assert: (chunks at: 1) = ('"{ NameSpace: RegressionTests }"', Character cr, Character cr).
    self assert: (chunks at: 2) = ''.
    self assert: (chunks at: 3) = ('ChangeSetTests methodsFor: ''%1''' bindWith: (self class compiledMethodAt: testSelector) category).
    self assert: (chunks at: 4) = (self class compiledMethodAt: testSelector) source.
    self assert: (chunks at: 5) = ''.
    self assert: (chunks at: 6) = ''.

    "Created: / 04-02-2014 / 11:51:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 16:42:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_saveToStream_format_nil_02
    | cs output chunks |

    cs := ChangeSet forExistingClass: ChangeSetTests::ExistingPrivateClass.
    cs := cs select:[:each | each isMethodChange and:[ each selector = #foo ]].
    output := (String streamContents:[ :s | cs saveToStream: s  format: nil ]) readStream.
    chunks := OrderedCollection streamContents:[ :s |
	[ output atEnd ] whileFalse:[
	    s nextPut: output nextChunk.
	].
    ].

    self assert: chunks size == 6.

    self assert: (chunks at: 1) = ('"{ NameSpace: RegressionTests }"', Character cr, Character cr).
    self assert: (chunks at: 2) = ''.
    self assert: (chunks at: 3) = 'ChangeSetTests::ExistingPrivateClass methodsFor: ''methods'''.
    self assert: (chunks at: 4) = (ChangeSetTests::ExistingPrivateClass compiledMethodAt: #foo) source.
    self assert: (chunks at: 5) = ''.
    self assert: (chunks at: 6) = ''.

    "Created: / 04-02-2014 / 12:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 12:45:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - ChangeSet::ClassSourceWriter'!

test_ClassSourceWriter_01
    | sourceFileout cs sourceChangeset|

    sourceFileout := String streamContents:[:s|
	AbstractSourceCodeManager fileOutSourceCodeOf:ChangeSet on:s
    ].

    cs := ChangeSet fromStream: sourceFileout readStream.

    sourceChangeset := String streamContents:[:s|
	cs saveToStream:s format:#classSource
    ].
    self assert: sourceFileout asByteArray = sourceChangeset asByteArray.
    "
    Tools::TextDiff2Tool openOn: sourceFileout label: 'sourceFileout' and: sourceChangeset label: 'sourceChangeset'
    '/tmp/sourceFileout.st' asFilename writingFileDo:[:s|s binary; nextPutAll:  sourceFileout asByteArray].
    '/tmp/sourceChangeset.st' asFilename writingFileDo:[:s|s binary; nextPutAll:  sourceChangeset asByteArray].
    "

    "Created: / 30-04-2013 / 11:28:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-05-2013 / 08:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassSourceWriter_02
    | sourceFileout cs sourceChangeset|

    sourceFileout := String streamContents:[:s|
	AbstractSourceCodeManager fileOutSourceCodeOf:Tools::HierarchicalPackageFilterList on:s
    ].

    cs := ChangeSet fromStream: sourceFileout readStream.

    sourceChangeset := String streamContents:[:s|
	cs saveToStream:s format:#classSource
    ].
    self assert: sourceFileout asByteArray = sourceChangeset asByteArray.
    "
    Tools::TextDiff2Tool openOn: sourceFileout label: 'sourceFileout' and: sourceChangeset label: 'sourceChangeset'
    "

    "Created: / 30-04-2013 / 11:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - ClassDefinitionChange'!

test_ClassDefinitionChange_01

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    self assert: cs size == 1.
    self assert: cs first className = 'MockClass'.
    self assert: (Smalltalk at: #MockClass) isNil.
    cs apply.
    self assert: (Smalltalk at: #MockClass) notNil.

    "Created: / 20-11-2012 / 14:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_01_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.



    self assert: (Smalltalk at: #MockClass) isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #MockClass) notNil.

    "Created: / 20-11-2012 / 14:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_02

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    self assert: cs size == 1.
    self assert: cs first className = 'MockClass'.
    self assert: cs first fullClassName = 'Mocks::MockClass'.
    self assert: cs first nameSpaceName = 'Mocks'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.

    "Created: / 20-11-2012 / 14:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_02_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.





    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.

    "Created: / 20-11-2012 / 14:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_03a

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''

!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass

' readStream.

    self assert: cs size == 2.
    self assert: cs first  className = 'MockClass'.
    self assert: cs first fullClassName = 'MockClass'.
    self assert: cs second className = 'MockClass::PrivateClass'.
    self assert: cs second fullClassName = 'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'MockClass') isNil.
    cs apply.
    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') name == #'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') isPrivate

    "Created: / 20-11-2012 / 14:54:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2013 / 14:41:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_03a_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''

!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass

' readStream.






    self assert: (Smalltalk at: #'MockClass') isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') name == #'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') isPrivate

    "Created: / 20-11-2012 / 14:54:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2013 / 14:41:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_03b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''

!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass

' readStream.

    self assert: cs size == 2.
    self assert: cs first  className = 'MockClass'.
    self assert: cs first  fullClassName = 'Mocks::MockClass'.
    self assert: cs second className = 'MockClass::PrivateClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass::PrivateClass'.
    self assert: cs second nameSpaceName = 'Mocks'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') isPrivate not.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name == #'Mocks::MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isPrivate

    "Created: / 20-11-2012 / 15:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_03b_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''

!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass

' readStream.







    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') isPrivate not.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name == #'Mocks::MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isPrivate

    "Created: / 20-11-2012 / 15:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04a

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass') name ==  #'MockClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil

    "Created: / 20-11-2012 / 15:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04a_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass') name ==  #'MockClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil

    "Created: / 20-11-2012 / 15:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'Mocks2::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass') name ==  #'Mocks2::MockClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.

    "Created: / 20-11-2012 / 15:14:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:09:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04b_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'Mocks2::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass') name ==  #'Mocks2::MockClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.

    "Created: / 20-11-2012 / 15:14:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:09:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04c

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') name ==  #'Mocks::MockClass'.

    "Created: / 20-11-2012 / 15:16:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04c_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') name ==  #'Mocks::MockClass'.

    "Created: / 20-11-2012 / 15:16:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04d

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    cs first nameSpaceOverride: (NameSpace name: #Mocks).
    cs apply.

    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') name ==  #'Mocks::MockClass'.

    "Created: / 20-11-2012 / 15:21:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_04e

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    cs first nameSpaceOverride: (NameSpace name: #Mocks).
    cs apply.

    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass') name ==  #'Mocks::MockClass'.

    "Created: / 20-11-2012 / 15:22:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05a

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') name ==  #'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isNil.

    "Created: / 20-11-2012 / 15:25:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05a_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') name ==  #'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isNil.

    "Created: / 20-11-2012 / 15:25:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') name ==  #'Mocks2::MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isNil.

    "Created: / 20-11-2012 / 15:26:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:11:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05b_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    "Responding to a nameSpaceQuerySignal should no longer affect change's namespace.
     Use #nameSpaceOverride: or #applyWithNameSpaceOverride: to apply a change in given
     namespace "

    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') name ==  #'Mocks2::MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isNil.

    "Created: / 20-11-2012 / 15:26:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:11:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05c

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	cs apply.
    ].
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name ==  #'Mocks::MockClass::PrivateClass'.

    "Created: / 20-11-2012 / 15:33:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05c_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	changefile readStream fileIn.
    ].
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name ==  #'Mocks::MockClass::PrivateClass'.

    "Created: / 20-11-2012 / 15:33:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05d

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    cs first nameSpaceOverride: (NameSpace name: #Mocks).
    cs second nameSpaceOverride: (NameSpace name: #Mocks).
    cs apply.

    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name ==  #'Mocks::MockClass::PrivateClass'.

    "Created: / 20-11-2012 / 15:26:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_05e

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass


' readStream.

    cs first  nameSpaceOverride: (NameSpace name: #Mocks).
    cs second nameSpaceOverride: (NameSpace name: #Mocks).
    cs apply.

    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') name ==  #'Mocks::MockClass::PrivateClass'.

    "Created: / 20-11-2012 / 15:26:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_06a
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
nil subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    cs apply.

    self assert: (Smalltalk at: #MockClass) superclass isNil

    "Created: / 10-06-2013 / 16:48:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_06a_fileIn
    | changefile |

    "Test nil superclass"

    changefile :='
nil subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
' readStream.

    changefile readStream fileIn.

    self assert: (Smalltalk at: #MockClass) superclass isNil

    "Created: / 10-06-2013 / 16:48:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_07a
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
Object subclass:#ExistingPrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:RegressionTests::ChangeSetTests
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement changeClass == ExistingPrivateClass.

    "Created: / 12-11-2013 / 17:53:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_07b
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

Object subclass:#ExistingPrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:ChangeSetTests
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement changeClass == ExistingPrivateClass.

    "Created: / 12-11-2013 / 17:54:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08a
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

ClassAndMethodCompilingTestCase subclass:#ChangeSetTests
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-System-Changes''
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement changeClass == ChangeSetTests.
    self assert: cs anElement delta == #'='

    "Created: / 13-11-2013 / 17:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 16:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08b
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

TestCase subclass:#ChangeSetTests
	instanceVariableNames:''classes someMoreData''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-System-Changes''
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement delta == #'~'

    "Created: / 13-11-2013 / 17:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08c
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

Object subclass:#ExistingPrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:ChangeSetTests
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement delta == #'='

    "Created: / 13-11-2013 / 17:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08d
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

Object subclass:#ExistingPrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''somePool''
	privateIn:ChangeSetTests
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement delta == #'~'

    "Created: / 13-11-2013 / 17:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08e
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

TestCase subclass:#ChangeSetTests2
	instanceVariableNames:''classes someMoreData''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-System-Changes''
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement delta == #'+'

    "Created: / 13-11-2013 / 17:44:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassDefinitionChange_08f
    | cs |

    "Test nil superclass"

    cs := ChangeSet fromStream:'
"{ NameSpace: RegressionTests }"

Object subclass:#ExistingPrivateClass2
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:ChangeSetTests
' readStream.


    self assert: cs size == 1.
    self assert: cs anElement isClassDefinitionChange.
    self assert: cs anElement delta == #'+'

    "Created: / 13-11-2013 / 17:44:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - ClassInitializeChange'!

test_ClassInitializeChange_01

    | cs |

    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:'MockVar'
	poolDictionaries:''
	category:'tests-Regression-Mocks'.
    (Smalltalk at: #MockClass) class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.

    cs := ChangeSet fromStream:'
MockClass initialize!!

' readStream.

    self assert: cs size == 1.
    self assert: cs first class == ClassInitializeChange.
    self assert: cs first className = 'MockClass'.

    self assert: (Smalltalk at: #MockClass) mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #MockClass) mockVar == 1234.

    "Created: / 21-03-2014 / 17:48:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_02

    | cs |

    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:'MockVar'
	poolDictionaries:''
	category:'tests-Regression-Mocks'.

    Object subclass:#PrivateClass
	instanceVariableNames:''
	classVariableNames:'MockVar'
	poolDictionaries:''
	privateIn:(Smalltalk at: #'MockClass').

    (Smalltalk at: #'MockClass::PrivateClass') class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.

    cs := ChangeSet fromStream:'
MockClass::PrivateClass initialize!!

' readStream.

    self assert: cs size == 1.
    self assert: cs first class == ClassInitializeChange.
    self assert: cs first className = 'MockClass::PrivateClass'.

    self assert: (Smalltalk at: #'MockClass::PrivateClass') mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') mockVar == 1234.

    "Created: / 21-03-2014 / 18:04:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_03a

    | cs |

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	Object subclass:#MockClass
	    instanceVariableNames:''
	    classVariableNames:'MockVar'
	    poolDictionaries:''
	    category:'tests-Regression-Mocks'.
    ].
    (Smalltalk at: #'Mocks::MockClass') class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.


    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

MockClass initialize!!

' readStream.

    self assert: cs size == 1.
    self assert: cs first class == ClassInitializeChange.
    self assert: cs first className = 'MockClass'.
    self assert: cs first fullClassName = 'Mocks::MockClass'.

    self assert: (Smalltalk at: #'Mocks::MockClass') mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass') mockVar == 1234.

    "Created: / 21-03-2014 / 18:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_03b

    | cs|

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	Object subclass:#MockClass
	    instanceVariableNames:''
	    classVariableNames:'MockVar'
	    poolDictionaries:''
	    category:'tests-Regression-Mocks'.
    ].
    (Smalltalk at: #'Mocks::MockClass') class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.


    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

!!
!!MockClass methodsFor:''methods''!!

foo

!! !!

MockClass initialize!!

' readStream.

    self assert: cs size == 2.
    self assert: cs second class == ClassInitializeChange.
    self assert: cs second className = 'MockClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass'.

    self assert: (Smalltalk at: #'Mocks::MockClass') mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass') mockVar == 1234.

    "Created: / 21-03-2014 / 18:04:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_04a

    | cs |

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:'MockVar'
	poolDictionaries:''
	category:'tests-Regression-Mocks'.

    Object subclass:#PrivateClass
	instanceVariableNames:''
	classVariableNames:'MockVar'
	poolDictionaries:''
	privateIn:(Smalltalk at: #'Mocks::MockClass').

    ].
    (Smalltalk at: #'Mocks::MockClass::PrivateClass') class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.


    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

MockClass::PrivateClass initialize!!

' readStream.

    self assert: cs size == 1.
    self assert: cs first class == ClassInitializeChange.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'Mocks::MockClass::PrivateClass'.

    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') mockVar == 1234.

    "Created: / 21-03-2014 / 18:09:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_04b

    | cs |

    Class nameSpaceQuerySignal answer: (NameSpace name: #Mocks) do:[
	Object subclass:#MockClass
	    instanceVariableNames:''
	    classVariableNames:'MockVar'
	    poolDictionaries:''
	    category:'tests-Regression-Mocks'.

	Object subclass:#PrivateClass
	    instanceVariableNames:''
	    classVariableNames:'MockVar'
	    poolDictionaries:''
	    privateIn:(Smalltalk at: #'Mocks::MockClass').
    ].
    (Smalltalk at: #'Mocks::MockClass::PrivateClass') class
	compile: 'initialize MockVar := 1234';
	compile: 'mockVar ^MockVar'.


    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

!!
!!MockClass methodsFor:''methods''!!

foo

!! !!

MockClass::PrivateClass initialize!!

' readStream.

    self assert: cs size == 2.
    self assert: cs second class == ClassInitializeChange.
    self assert: cs second className = 'MockClass::PrivateClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass::PrivateClass'.

    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') mockVar isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') mockVar == 1234.

    "Created: / 21-03-2014 / 18:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_ClassInitializeChange_05
    | cs1 cs2 diff |

    cs1 := ChangeSet fromStream:'
MockClass initialize!!

' readStream.

    cs2 := ChangeSet fromStream:'
MockClass initialize!!

' readStream.

    diff := cs1 diffSetsAgainst:cs2.

    self assert: diff changed isEmpty.
    self assert: diff onlyInReceiver isEmpty.
    self assert: diff onlyInArg isEmpty.

    "Created: / 26-03-2014 / 17:37:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - MethodDefinitionChange'!

test_MethodDefinitionChange_01

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs second className = 'MockClass'.
    self assert: cs second fullClassName = 'MockClass'.
    self assert: (Smalltalk at: #MockClass) isNil.
    cs apply.
    self assert: (Smalltalk at: #MockClass) notNil.
    self assert:((Smalltalk at: #MockClass) methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:40:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_01_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: (Smalltalk at: #MockClass) isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #MockClass) notNil.
    self assert:((Smalltalk at: #MockClass) methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:40:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-03-2014 / 17:04:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_02

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs second className = 'MockClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    cs apply.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert:((Smalltalk at: #'Mocks::MockClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:42:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_02_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert:((Smalltalk at: #'Mocks::MockClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:42:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-03-2014 / 17:04:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_02a
    "Tests whether all method changes have package properly set when reading
     extension container"

    | cs |

    cs := ChangeSet fromStream:'"{ Package: ''stx:libtool'' }"!!

!!AbstractSyntaxHighlighter class methodsFor:''api highlighting''!!

formatExpression:aString in:aClass elementsInto:elementsCollection

    ^self formatExpression:aString in:aClass

!! !!

!!AbstractSyntax class methodsFor:''xxx highlighting''!!

xxx:aString in:aClass elementsInto:elementsCollection

    ^self formatExpression:aString in:aClass

!! !!

' readStream.

    self assert: cs size = 2.
    self assert: cs first package = 'stx:libtool'.
    self assert: cs second package = 'stx:libtool'.

    "Created: / 29-01-2013 / 19:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 10:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_03a

    | cs |

    cs := ChangeSet fromStream:'
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass
!!

!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.

    self assert: cs size == 3.
    self assert: cs third className = 'MockClass::PrivateClass'.
    self assert: cs third fullClassName = 'MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'MockClass') isNil.
    cs apply.
    self assert:((Smalltalk at: #'MockClass::PrivateClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2013 / 15:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_03a_fileIn

    | changefile |

    changefile :='
Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass
!!

!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.




    self assert: (Smalltalk at: #'MockClass') isNil.
    changefile readStream fileIn.
    self assert:((Smalltalk at: #'MockClass::PrivateClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2013 / 15:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_03b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass
!!

!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.

    self assert: cs size == 3.
    self assert: cs third className = 'MockClass::PrivateClass'.
    self assert: cs third fullClassName = 'Mocks::MockClass::PrivateClass'.
    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    cs apply.
    self assert:((Smalltalk at: #'Mocks::MockClass::PrivateClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

test_MethodDefinitionChange_03b_fileIn

    | changefile |

    changefile :='
"{ NameSpace: Mocks }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

Object subclass:#PrivateClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	privateIn:MockClass
!!

!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.




    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    changefile readStream fileIn.
    self assert:((Smalltalk at: #'Mocks::MockClass::PrivateClass') methodDictionary includesKey: #foo)

    "Created: / 01-05-2013 / 09:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

test_MethodDefinitionChange_04a

    | cs |

    cs := ChangeSet fromStream:'
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.

    self assert: cs size == 1.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'MockClass::PrivateClass'.

    "Created: / 06-03-2014 / 10:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_04a_fileIn

    | changefile |

    self assert: (Smalltalk at: #'MockClass') isNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') isNil.


    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'MockClass').


    changefile :='
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.
    changefile readStream fileIn.

    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'MockClass::PrivateClass') methodDictionary includesKey:#foo)

    "Created: / 06-03-2014 / 10:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 17:11:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_04b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.

    self assert: cs size == 1.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'Mocks::MockClass::PrivateClass'.

    "Created: / 06-03-2014 / 10:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_04b_fileIn

    | changefile |

    self assert: (Smalltalk at: #'Mocks::MockClass') isNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') isNil.

    Class nameSpaceQuerySignal answer: (NameSpace name: #'Mocks') do:[

    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'Mocks::MockClass').
    ].


    changefile :='
"{ NameSpace: Mocks }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.
    changefile readStream fileIn.

    self assert: (Smalltalk at: #'Mocks::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'Mocks::MockClass::PrivateClass') methodDictionary includesKey:#foo)

    "Created: / 06-03-2014 / 10:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 17:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05a

    | cs |

    cs := ChangeSet fromStream:'
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Mocks }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'MockClass::PrivateClass'.
    self assert: cs second className = 'MockClass2::PrivateClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass2::PrivateClass'.

    "Created: / 06-03-2014 / 10:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05a_fileIn

    | changefile |

    self assert: (Smalltalk at: #'MockClass') isNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') isNil.


    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'MockClass').

    Class nameSpaceQuerySignal answer: (NameSpace name: #'Mocks') do:[

    Object subclass:#MockClass2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'Mocks::MockClass2').
    ].

    changefile :='
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Mocks }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    changefile readStream fileIn.
     self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'MockClass::PrivateClass') methodDictionary includesKey:#foo).
    self assert: (Smalltalk at: #'Mocks::MockClass2') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass2::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'Mocks::MockClass2::PrivateClass') methodDictionary includesKey:#bar)

    "Created: / 06-03-2014 / 10:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 17:16:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05b

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Mocks }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'Mocks2::MockClass::PrivateClass'.
    self assert: cs second className = 'MockClass2::PrivateClass'.
    self assert: cs second fullClassName = 'Mocks::MockClass2::PrivateClass'.

    "Created: / 06-03-2014 / 10:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05b_fileIn

    | changefile |

    Class nameSpaceQuerySignal answer: (NameSpace name: #'Mocks2') do:[

    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'Mocks2::MockClass').

    ].

    Class nameSpaceQuerySignal answer: (NameSpace name: #'Mocks') do:[

    Object subclass:#MockClass2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'Mocks::MockClass2').
    ].


    changefile :='
"{ NameSpace: Mocks2 }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Mocks }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    changefile readStream fileIn.

    self assert: (Smalltalk at: #'Mocks2::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'Mocks2::MockClass::PrivateClass') methodDictionary includesKey:#foo).
    self assert: (Smalltalk at: #'Mocks::MockClass2') notNil.
    self assert: (Smalltalk at: #'Mocks::MockClass2::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'Mocks::MockClass2::PrivateClass') methodDictionary includesKey:#bar)

    "Created: / 06-03-2014 / 10:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 17:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05c

    | cs |

    cs := ChangeSet fromStream:'
"{ NameSpace: Mocks2 }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Smalltalk }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'Mocks2::MockClass::PrivateClass'.
    self assert: cs second className = 'MockClass2::PrivateClass'.
    self assert: cs second fullClassName = 'MockClass2::PrivateClass'.

    "Created: / 06-03-2014 / 10:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_05c_fileIn

    | changefile |

    Class nameSpaceQuerySignal answer: (NameSpace name: #'Mocks2') do:[

    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'Mocks2::MockClass').
    ].

    Object subclass:#MockClass2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'MockClass2').



    changefile :='
"{ NameSpace: Mocks2 }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
"{ NameSpace: Smalltalk }"

!!
!!MockClass2::PrivateClass methodsFor:''methods''!!

bar

!! !!

' readStream.

    changefile readStream fileIn.
    self assert: (Smalltalk at: #'Mocks2::MockClass') notNil.
    self assert: (Smalltalk at: #'Mocks2::MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'Mocks2::MockClass::PrivateClass') methodDictionary includesKey:#foo).
    self assert: (Smalltalk at: #'MockClass2') notNil.
    self assert: (Smalltalk at: #'MockClass2::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'MockClass2::PrivateClass') methodDictionary includesKey:#bar)

    "Created: / 06-03-2014 / 10:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 17:25:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_06

    | cs |

    cs := ChangeSet fromStream:'
"{ Package: ''mocks:ChangeSetTests'' }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: cs size == 2.
    self assert: cs second className = 'MockClass'.
    self assert: cs second fullClassName = 'MockClass'.
    self assert: cs second package = 'mocks:ChangeSetTests'.
    self assert: (Smalltalk at: #MockClass) isNil.
    cs apply.
    self assert: (Smalltalk at: #MockClass) notNil.
    self assert: (Smalltalk at: #MockClass) package = 'mocks:ChangeSetTests'.
    self assert:((Smalltalk at: #MockClass) methodDictionary includesKey: #foo).
    self assert:((Smalltalk at: #MockClass) methodDictionary at: #foo) package = 'mocks:ChangeSetTests'.

    "Created: / 29-03-2014 / 23:23:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_06_fileIn

    | changefile |

    changefile :='
"{ Package: ''mocks:ChangeSetTests'' }"

Object subclass:#MockClass
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-Mocks''
!!

!!MockClass methodsFor:''methods''!!

foo

!! !!

' readStream.

    self assert: (Smalltalk at: #MockClass) isNil.
    changefile readStream fileIn.
    self assert: (Smalltalk at: #MockClass) notNil.
    self assert: (Smalltalk at: #MockClass) package = 'mocks:ChangeSetTests'.
    self assert:((Smalltalk at: #MockClass) methodDictionary includesKey: #foo).
    self assert:((Smalltalk at: #MockClass) methodDictionary at: #foo) package = 'mocks:ChangeSetTests'.

    "Created: / 29-03-2014 / 23:30:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_07

    | cs |

    cs := ChangeSet fromStream:'
"{ Package: ''mocks:ChangeSetTests'' }"

!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.

    self assert: cs size == 1.
    self assert: cs first className = 'MockClass::PrivateClass'.
    self assert: cs first fullClassName = 'MockClass::PrivateClass'.
    self assert: cs first package = 'mocks:ChangeSetTests'.

    "Created: / 29-03-2014 / 23:31:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_07_fileIn

    | changefile |

    self assert: (Smalltalk at: #'MockClass') isNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') isNil.


    Object subclass:#MockClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-System-Changes'.

    Object subclass: #PrivateClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	privateIn: (Smalltalk at: #'MockClass').


    changefile :='
"{ Package: ''mocks:ChangeSetTests'' }"

!!
!!MockClass::PrivateClass methodsFor:''methods''!!

foo

!! !!
' readStream.
    changefile readStream fileIn.

    self assert: (Smalltalk at: #'MockClass') notNil.
    self assert: (Smalltalk at: #'MockClass::PrivateClass') notNil.
    self assert: ((Smalltalk at: #'MockClass::PrivateClass') methodDictionary includesKey:#foo).
    self assert: ((Smalltalk at: #'MockClass::PrivateClass') methodDictionary at: #foo) package = 'mocks:ChangeSetTests'.

    "Created: / 29-03-2014 / 23:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_jextension_01a
    "Tests Java extensios - used by stx:libjava (see stx/libjava/java/extensions/**/*.st"

    | cs |

    cs := ChangeSet fromStream:'
!!(Java classForName:''java.lang.Long'') class methodsFor:''queries''!!

javaWrap: object
	|inst|
    inst := self basicNew.
    inst perform: #''<init>(J)V'' with: object with: nil.
	^ inst.
!! !!
' readStream.

    self assert: cs size == 1.

    "Created: / 01-05-2013 / 17:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_MethodDefinitionChange_jextension_01b
    "Tests Java extensios - used by stx:libjava (see stx/libjava/java/extensions/**/*.st"

    | cs |

    cs := ChangeSet fromStream:'
!!(Java classForName:''java.lang.Long'') methodsFor:''queries''!!

javaWrap: object
	|inst|
    inst := self basicNew.
    inst perform: #''<init>(J)V'' with: object with: nil.
	^ inst.
!! !!
' readStream.

    self assert: cs size == 1.

    "Created: / 01-05-2013 / 17:38:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - misc'!

test_misc_package_01a
    "When reading session changefile, make sure that change's package is
     not the one of by-chance-last package pragma in the stream.

     SV: it is not exactly clear, whether this is a bug or a feature.
     There may be changefiles, that have the package or namespace definition in a
     separate chunk - see ChangeSet>>#changesFromStream:for:reader:do - line 70"

    | cs |

    cs := ChangeSet fromStream:'"{ Encoding: utf8 }" !!
''---- timestamp jv@sao 05-10-2013 01:57:54 ----''!!
"{ Package: ''some:funny/package'' }"

Object subclass:#Mock1
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''* Mocks *''
!!
''---- timestamp jv@sao 05-10-2013 01:00:00 ----''!!
!!Object methodsFor:''* mocks * ''!!

someMethod
    ^ 1

!! !!

' readStream.

    self assert: cs size == 3.
    self assert: cs second package = 'some:funny/package'.
    self assert: cs third package = PackageId noProjectID.

    "Created: / 05-08-2014 / 10:49:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-04-2016 / 22:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_package_01b
    "When reading session changefile, make sure that change's package is
     honored when present in a own chunk.

     SV: this contradicts with #test_misc_package_01a - see ChangeSet>>#changesFromStream:for:reader:do - line 70"

    | cs |

    cs := ChangeSet fromStream:'"{ Encoding: utf8 }" !!
''---- timestamp jv@sao 05-10-2013 01:57:54 ----''!!
"{ Package: ''some:funny/package'' }"
!!
Object subclass:#Mock1
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''* Mocks *''
!!
!!Object methodsFor:''* mocks * ''!!

someMethod
    ^ 1

!! !!

' readStream.

    self assert: cs size == 3.
    self assert: cs second package = 'some:funny/package'.
    self assert: cs third package = 'some:funny/package'.

    "Created: / 05-08-2014 / 10:49:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_package_01c
    "When reading session changefile, make sure that change's package is
     not the one of by-chance-last package pragma in the stream.

     SV: it is not exactly clear, whether this is a bug or a feature.
     There may be changefiles, that have the package or namespace definition in a
     seaprate chunk - see ChangeSet>>#changesFromStream:for:reader:do - line 70"

    | cs |

    cs := ChangeSet fromStream:'"{ Encoding: utf8 }" !!
''---- timestamp jv@sao 05-10-2013 01:57:54 ----''!!
"{ Package: ''some:funny/package'' }"

Object subclass:#Mock1
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:''* Mocks *''
!!
''---- timestamp jv@sao 05-10-2013 01:00:00 ----''!!
"{ Package: ''some:funny/package'' }" !!

!!Object methodsFor:''* mocks * ''!!

someMethod  
    ^ 1

!! !!

' readStream.    

    self assert: cs size == 3.
    self assert: cs second package = 'some:funny/package'.
    self assert: cs third package = 'some:funny/package'.

    "Created: / 26-04-2016 / 22:57:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_package_02a
    "
    When reading class fileout, all methods should have package set, however...
    "
    | cs |
    cs := ChangeSet fromStream:'""{ Encoding: utf8 }"

''From Smalltalk/X, Version:6.2.4.0 on 05-08-2014 at 10:57:51''                   !!

"{ Package: ''stx:goodies/regression'' }"

"{ NameSpace: RegressionTests }"

ClassAndMethodCompilingTestCase subclass:#ChangeSetTests
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''tests-Regression-System-Changes''
!!

!!ChangeSetTests methodsFor:''private''!!

performTest
    ^Class withoutUpdatingChangesDo:[
	super performTest
    ]

!! !!' readStream.

    self assert: cs size == 2.
    self assert: cs first  package = 'stx:goodies/regression'.
    self assert: cs second package = 'stx:goodies/regression'.

    "Created: / 05-08-2014 / 10:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_misc_package_03a
    "
    When reading extensions file out, all methods should have
    package correctly set.
    "
    | cs |
    cs := ChangeSet fromStream:'"{ Package: ''stx:libjava'' }"!!

!!Behavior methodsFor:''queries''!!

isInterface
    "return true, if the receiver is a Java interface"

    ^ false

    "
     True isInterface
    "

!! !!

!!Behavior methodsFor:''queries''!!

isJavaPrimitiveType

    ^false


!! !!
' readStream.

    self assert: cs size == 2.
    self assert: cs first  package = 'stx:libjava'.
    self assert: cs second package = 'stx:libjava'.

    "Created: / 05-08-2014 / 11:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests methodsFor:'tests - utf8'!

test_reading_utf8_01
    "
    Test reading of changeset with non-ASCII/non-ISO8859-1 chars
    "
    | file cs |

    file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'testData' / 'packages' / 'p1utf8' / 'ProjectDefinitionTestsP1UTF8Bar.st'.
    self assert: file exists.
    "
    file contents asString
    "
    cs := ChangeSet fromFile: file.
    self assert: cs size == 4.
    self assert: (cs second source size = 127).
    self assert: (cs second source includesString: 'Příliš žluťoučký kůň úpěl ďábelské ódy').

    "Created: / 26-03-2013 / 09:54:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-02-2014 / 20:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_reading_utf8_02
    "
    Test reading of changeset with non-ASCII/non-ISO8859-1 chars from non-positionable stream
    "
    | file stream cs |

    file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'testData' / 'packages' / 'p1utf8' / 'ProjectDefinitionTestsP1UTF8Bar.st'.
    self assert: file exists.
    "
    file contents asString
    "
    stream := NonPositionableReadWriteStream with: file contents asString.
    cs := ChangeSet fromStream: stream.
    self assert: cs size == 4.
    self assert: (cs second source size = 127).
    self assert: (cs second source includesString: 'Příliš žluťoučký kůň úpěl ďábelské ódy').

    "Created: / 14-03-2014 / 15:42:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_write_utf8_01
    | cs output expected got |

    cs := ChangeSet forExistingClass: ChangeSetTests::ExistingPrivateClass.
    output := String streamContents:[ :s | cs saveToStream: s  format: nil ].
    got := output asStringCollection first.

    expected := '"{ Encoding: utf8 }"'.

    self assert: expected = got.

    "Created: / 04-02-2014 / 12:10:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2014 / 20:13:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests::ExistingPrivateClass methodsFor:'methods'!

bar
    ^ 'Příliš žluťoučký kůň úpěl ďábelské ódy'

    "Created: / 04-02-2014 / 11:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foo
    ^ self bar

    "Created: / 04-02-2014 / 11:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests::NonPositionableReadWriteStream methodsFor:'positioning'!

position
    "{ Pragma: +optSpace }"

    "catch position - there is none here"

    ^ self positionError
!

position:aPosition
    "{ Pragma: +optSpace }"

    "catch position - there is none here"

    ^ self positionError
!

skip:numberToSkip
    "skip count bytes/characters, return the receiver.
     Re-redefined since PositionableStream redefined it."

    "don't know how to unread ..."
    numberToSkip < 0 ifTrue:[
	PositionError raiseRequest.
	^ self
    ].
    numberToSkip timesRepeat:[self next].

    "Modified: / 30.7.1999 / 12:42:12 / cg"
! !

!ChangeSetTests::NonPositionableReadWriteStream methodsFor:'testing'!

isPositionable
    ^ false

    "Created: / 14-03-2014 / 16:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

