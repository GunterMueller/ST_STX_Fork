"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TestSuite
	instanceVariableNames:'tests resources name'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

TestSuite comment:''
!


!TestSuite class methodsFor:'instance creation'!

named: aString

	^self new
		name: aString;
		yourself
! !

!TestSuite methodsFor:'accessing'!

addTest: aTest
    self tests add: aTest

    "Modified: / 16-01-2012 / 14:07:03 / cg"
    "Modified: / 02-08-2012 / 11:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addTests: aCollection
	aCollection do: [:eachTest | self addTest: eachTest]
!

defaultResources
	^self tests
		inject: OrderedCollection new
		into:
			[:coll :testCase |
			testCase resources do:
				[:each |
				(coll includes: each) ifFalse: [coll add: each]].
			coll]
!

getTestName
    ^self name

    "Created: / 12-09-2006 / 11:38:09 / cg"
!

name

	^name
!

name: aString

	name := aString
!

nameOfTest
    ^ self name
!

resources
	resources isNil ifTrue: [resources := self defaultResources].
	^resources
!

resources: someOrderedTestResourceClasses
	"The parameter should understand reverseDo: and should not contain duplicates."

	resources := someOrderedTestResourceClasses
!

testCount

    ^tests notNil ifTrue:[
        tests inject:0 into:[:count :test|count + test testCount]
    ] ifFalse:[
        0
    ]

    "Created: / 04-08-2011 / 13:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tests
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests
! !

!TestSuite methodsFor:'dependencies'!

addDependentToHierachy: anObject
	self sunitAddDependent: anObject.
	self tests do: [ :each | each addDependentToHierachy: anObject]
!

removeDependentFromHierachy: anObject
	self sunitRemoveDependent: anObject.
	self tests do: [ :each | each removeDependentFromHierachy: anObject]
! !

!TestSuite methodsFor:'queries'!

isTestCase
    ^ false
!

isTestSuite
    ^ true
! !

!TestSuite methodsFor:'running'!

debug

    ^self run: TestResult defaultResultClass new debug:true.
!

run

    ^self run: TestResult defaultResultClass new.

    "Modified: / 29-07-2011 / 09:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run:aTestResult

    ^self run: aTestResult 
        beforeEachDo: [:test :result|] 
        afterEachDo: [:test :result|]

    "Modified: / 29-07-2011 / 09:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run:result beforeEachDo: before afterEachDo: after
    ^ self
        run:result 
        beforeEachDo:before afterEachDo:after 
        resetResources:true

    "Modified: / 29-07-2011 / 12:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2011 / 13:58:08 / cg"
!

run:result beforeEachDo: before afterEachDo: after debug:doDebug
    ^ self
        run:result 
        beforeEachDo:before afterEachDo:after 
        resetResources:true
        debug:doDebug

    "Modified: / 29-07-2011 / 12:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2011 / 13:58:08 / cg"
    "Created: / 21-08-2011 / 17:56:57 / cg"
!

run:result beforeEachDo:before afterEachDo:after resetResources:resetResources
    ^ self
        run:result  
        beforeEachDo:before 
        afterEachDo:after 
        resetResources:resetResources 
        debug:false

    "Created: / 31-07-2011 / 13:57:25 / cg"
    "Modified: / 03-08-2011 / 14:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 17:56:16 / cg"
!

run:result beforeEachDo:before afterEachDo:after resetResources:resetResources debug:doDebug
    result timestamp:(Timestamp now).
    result name isNil ifTrue:[ result name:name ].  "will only change once"
    [
        self tests do:[:each |
            self sunitChanged:each.
            each run:result 
                beforeEachDo: before 
                afterEachDo: after 
                resetResources: false "I'll reset it, see the ensure below"
                debug:doDebug
        ]
    ] sunitEnsure:[
        resetResources ifTrue:[
            TestResource resetResources: self resources
        ].
    ].
    result endTime:(Timestamp now).

    ^result

    "Modified: / 03-08-2011 / 14:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-08-2011 / 17:56:00 / cg"
!

run:aResult beforeEachTestCaseDo:block1 afterEachTestCaseDo:block2

    <resource: #obsolete>

    ^self run: aResult beforeEachDo: block1 afterEachDo: block2

    "Modified: / 29-07-2011 / 09:49:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

run:aTestResult debug:debug

    ^self run: aTestResult 
        beforeEachDo: [:test :result|] 
        afterEachDo: [:test :result|]
        debug:debug
!

runBeforeEachDo:block1 

    ^self runBeforeEachDo:block1 afterEachDo:[]

    "Modified: / 29-07-2011 / 09:51:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 01-08-2011 / 09:42:29 / cg"
!

runBeforeEachDo:block1 afterEachDo: block2

    ^self run: TestResult defaultResultClass new beforeEachDo: block1 afterEachDo: block2

    "Created: / 05-07-2011 / 16:51:25 / cg"
    "Modified: / 29-07-2011 / 09:51:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestSuite methodsFor:'testing'!

areAllResourcesAvailable
	^self resources
		inject: true
		into: [:total :each | each isAvailable & total]
!

signalUnavailableResources

    self resources do:[:res |
	res isAvailable ifFalse:[
	    ^ res signalInitializationError
	]
    ].
! !

!TestSuite class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestSuite.st,v 1.35 2015-02-05 16:19:45 cg Exp $'
!

version_SVN
    ^ '$Id: TestSuite.st,v 1.35 2015-02-05 16:19:45 cg Exp $'
! !

