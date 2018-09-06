"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#PPCSetUpBeforeTearDownAfterResource
	instanceVariableNames:''
	classVariableNames:'CachedResources'
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Support'
!

PPCSetUpBeforeTearDownAfterResource class instanceVariableNames:'testCaseClass'

"
 The following class instance variables are inherited by this class:

	TestResource - current
	TestAsserter - 
	Object - 
"
!

!PPCSetUpBeforeTearDownAfterResource class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    CachedResources := Dictionary new

    "Modified: / 30-07-2015 / 07:47:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSetUpBeforeTearDownAfterResource class methodsFor:'accessing'!

testCaseClass
    ^ testCaseClass

    "Created: / 29-07-2015 / 16:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCaseClass: aClass
    testCaseClass := aClass

    "Created: / 29-07-2015 / 16:19:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSetUpBeforeTearDownAfterResource class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."
    
    ^ self == PPCSetUpBeforeTearDownAfterResource.
! !

!PPCSetUpBeforeTearDownAfterResource class methodsFor:'running'!

availableFor: aTestAsserter
        aTestAsserter
                assert: self isAvailable
                description: 'Unavailable resource ', PPCSetUpBeforeTearDownAfterResource name ,' for: ', testCaseClass name , ' requested by ', aTestAsserter printString.

    "Created: / 29-07-2015 / 16:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSetUpBeforeTearDownAfterResource class methodsFor:'subclass creation'!

for: aClass
    ^ CachedResources at: aClass ifAbsentPut:[
        | resourceMeta resourceClass |

        ((Smalltalk respondsTo: #isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            resourceMeta := Metaclass new.
            resourceMeta setSuperclass: self class.
            resourceMeta instSize: self class instSize.  
            resourceClass := resourceMeta new.
            resourceClass setSuperclass: self.
            resourceClass instSize: self instSize.  
        ] ifFalse:[
            " Assumes Pharo 5.0"
            resourceMeta := Metaclass new.
            resourceMeta
                superclass: self class
                withLayoutType: FixedLayout
                slots: #().
            resourceClass := resourceMeta new.
            resourceClass superclass: self 
                withLayoutType: FixedLayout
                slots: #().			
        ].
        resourceClass testCaseClass: aClass.
        resourceClass
    ]

    "Created: / 29-07-2015 / 16:17:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 30-07-2015 / 07:48:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCSetUpBeforeTearDownAfterResource methodsFor:'setup & teardown'!

setUp
    | testCaseClass |

    testCaseClass := self class testCaseClass.
    (testCaseClass lookupSelector: #setUpBefore) notNil ifTrue:[ 
        testCaseClass new setUpBefore.
    ].

    "Created: / 29-07-2015 / 16:33:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | testCaseClass |

    testCaseClass := self class testCaseClass.
    (testCaseClass lookupSelector: #tearDownAfter) notNil ifTrue:[ 
        testCaseClass new tearDownAfter
    ].

    "Created: / 29-07-2015 / 16:33:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


PPCSetUpBeforeTearDownAfterResource initialize!
