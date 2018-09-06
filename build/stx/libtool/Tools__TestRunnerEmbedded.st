"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

TestRunnerMini subclass:#TestRunnerEmbedded
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-UI'
!

!TestRunnerEmbedded class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!TestRunnerEmbedded class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #methodGeneratorHolder
        #selectedClassesHolder
        #selectedMethodsHolder
        #selectedProtocolsHolder
      ).

! !

!TestRunnerEmbedded methodsFor:'aspects'!

methodGeneratorHolder
    "return/create the 'methodGeneratorHolder' value holder (automatically generated)"

    methodGeneratorHolder isNil ifTrue:[
        methodGeneratorHolder := ValueHolder new.
        methodGeneratorHolder addDependent:self.
    ].
    ^ methodGeneratorHolder
!

methodGeneratorHolder:something
    "set the 'methodGeneratorHolder' value holder (automatically generated)"

    |oldValue newValue|

    methodGeneratorHolder notNil ifTrue:[
        oldValue := methodGeneratorHolder value.
        methodGeneratorHolder removeDependent:self.
    ].
    methodGeneratorHolder := something.
    methodGeneratorHolder notNil ifTrue:[
        methodGeneratorHolder addDependent:self.
    ].
    newValue := methodGeneratorHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:methodGeneratorHolder.
    ].
!

selectedClassesHolder
    "return/create the 'selectedClassesHolder' value holder (automatically generated)"

    selectedClassesHolder isNil ifTrue:[
        selectedClassesHolder := ValueHolder new.
        selectedClassesHolder addDependent:self.
    ].
    ^ selectedClassesHolder
!

selectedClassesHolder:something
    "set the 'selectedClassesHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedClassesHolder notNil ifTrue:[
        oldValue := selectedClassesHolder value.
        selectedClassesHolder removeDependent:self.
    ].
    selectedClassesHolder := something.
    selectedClassesHolder notNil ifTrue:[
        selectedClassesHolder addDependent:self.
    ].
    newValue := selectedClassesHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedClassesHolder.
    ].
!

selectedMethodsHolder
    "return/create the 'selectedMethodsHolder' value holder (automatically generated)"

    selectedMethodsHolder isNil ifTrue:[
        selectedMethodsHolder := ValueHolder new.
        selectedMethodsHolder addDependent:self.
    ].
    ^ selectedMethodsHolder
!

selectedMethodsHolder:something
    "set the 'selectedMethodsHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedMethodsHolder notNil ifTrue:[
        oldValue := selectedMethodsHolder value.
        selectedMethodsHolder removeDependent:self.
    ].
    selectedMethodsHolder := something.
    selectedMethodsHolder notNil ifTrue:[
        selectedMethodsHolder addDependent:self.
    ].
    newValue := selectedMethodsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedMethodsHolder.
    ].
!

selectedProtocolsHolder
    "return/create the 'selectedProtocolsHolder' value holder (automatically generated)"

    selectedProtocolsHolder isNil ifTrue:[
        selectedProtocolsHolder := ValueHolder new.
        selectedProtocolsHolder addDependent:self.
    ].
    ^ selectedProtocolsHolder
!

selectedProtocolsHolder:something
    "set the 'selectedProtocolsHolder' value holder (automatically generated)"

    |oldValue newValue|

    selectedProtocolsHolder notNil ifTrue:[
        oldValue := selectedProtocolsHolder value.
        selectedProtocolsHolder removeDependent:self.
    ].
    selectedProtocolsHolder := something.
    selectedProtocolsHolder notNil ifTrue:[
        selectedProtocolsHolder addDependent:self.
    ].
    newValue := selectedProtocolsHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selectedProtocolsHolder.
    ].
! !

!TestRunnerEmbedded methodsFor:'aspects-visibility'!

pinButtonVisibleHolder
    ^ true

    "Created: / 23-09-2014 / 10:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runAllButtonVisibleHolder
    ^ true

    "Created: / 23-09-2014 / 10:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 11:44:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runFailedButtonVisibleHolder
    ^ false "/true

    "Created: / 23-09-2014 / 10:12:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 11:43:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerEmbedded methodsFor:'change & update'!

invalidateTestCases
    allTestCases := nil.
!

update:aspect with:param from: sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == selectedMethodsHolder ifTrue:[
        self enqueueMessage:#updateTestCases for:self arguments:#().
        self enqueueMessage:#updateSuiteAndResult for:self arguments:#().
    ].

    sender == selectedClassesHolder ifTrue:[
        self 
            invalidateTestCases;      "/ updateTestSuite;
            invalidateSuiteAndResult; "/ updateTestSuiteAndResult;
            updateVisibility.

        self hasTestCaseSelected ifTrue:[
            self enqueueMessage:#updateTestCases for:self arguments:#().
            self enqueueMessage:#updateSuiteAndResult for:self arguments:#().
            "/ self enqueueDelayedAction:[ self updateTestCases; updateSuiteAndResult ].
        ].
         ^ self.
    ].
    self hasTestCaseSelected ifTrue:[
        (sender == selectedProtocolsHolder 
        or:[ sender == selectedMethodsHolder 
        or:[ sender == methodGeneratorHolder ]]) ifTrue:[
            self invalidateSuiteAndResult. 
            self enqueueMessage:#updateSuiteAndResult for:self arguments:#().
            ^self
        ].

        sender == Smalltalk ifTrue:[
            aspect == #lastTestRunResult ifTrue:[
                allTestCases notNil ifTrue:[
                    (allTestCases includesIdentical: param first) ifTrue:[
                        self invalidateSuiteAndResult. "/ updateTestSuiteAndResult.
                        self enqueueMessage:#updateSuiteAndResult for:self arguments:#().
                        ^self        
                    ]
                ].
            ]        
        ].
    ].

    super update:aspect with:param from: sender

    "Modified: / 20-11-2011 / 12:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:03:34 / cg"
!

updateTestCases
    |classes|

    classes := (self selectedClassesHolder value ? #()) 
                    select:[:cls | self isTestCaseLike:cls ] as:Set.
    classes addAll:((self selectedMethodsHolder value ? #()) 
                    collect:[:mthd | mthd mclass ]
                    thenSelect:[:cls | self isTestCaseLike:cls ]).
    allTestCases := classes asArray.
    allTestCases sortBySelector:#name.

    "Created: / 11-03-2010 / 10:31:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2012 / 22:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:02:52 / cg"
! !

!TestRunnerEmbedded methodsFor:'private'!

hide

    self visibility: false height: 0

    "Created: / 11-03-2010 / 09:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

show

    self visibility: true height: 50

    "Created: / 11-03-2010 / 09:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visibility:visibility height:height 
    | window container list h|

    window := self window.
    window isNil ifTrue:[ ^ self ].
    container := self window container.
    container isNil ifTrue:[ ^ self ].

    h := visibility ifFalse:[0] ifTrue:[ height ].
    container isVisible == visibility ifFalse:[
        container isVisible:visibility
    ].
    "/ this is the kind of dangerous access which breaks, whenever some wrapping setup
    "/ changes. Never do this!!!!!!!!
    "/ I'd rather see code which refers to the widget by name,
    "/ or if there is an explicit setter for the container, from which to steal the space.
    list := container container subViews first.
    (list layout bottomOffset ~= height negated) ifTrue:[
        list layout:((list layout)
                    bottomOffset:height negated;
                    yourself)
    ].

    "Created: / 11-03-2010 / 09:51:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 13:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestRunnerEmbedded methodsFor:'utilities'!

suiteForRun
    "if methods are selected, a suite for those methods is built and returned.
     If protocols are selected, a suite for all methods in those protocols
     is built and returned.
     Otherwise, a suite for all methods in the class is built and returned"
    
    | testMethods protocols suite selectedClass |

    selectedClass := self theSingleTestCase.
    selectedMethodsHolder value notEmptyOrNil ifTrue:[
        testMethods := self selectedTestMethods.
        suite := TestSuite named:(self suiteNameFromMethods:testMethods).
        testMethods do:[:mthd | 
            | class  selector |

            class := selectedClass isNil ifTrue:[mthd mclass] ifFalse:[ selectedClass ].
            suite addTest:(class asTestCase selector:mthd selector)
        ].
        ^ suite
    ].
    (protocols := selectedProtocolsHolder value) notEmptyOrNil ifTrue:[
        suite := TestSuite named:(self suiteNameFromProtocols:protocols).
        (self selectedTestMethodsFromProtocols:protocols inClass:selectedClass) do:[:mthd | 
            | class  selector |

            class := selectedClass isNil ifTrue:[mthd mclass] ifFalse:[ selectedClass ].
            suite addTest:(class asTestCase selector:mthd selector)
        ].
        ^ suite
    ].
    ^ self suiteForRunAll

    "Created: / 15-03-2010 / 13:13:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:06:42 / cg"
    "Modified (format): / 23-09-2014 / 10:19:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suiteForRunAll
    |suite|

    allTestCases isNil ifTrue:[
        self updateTestCases.
    ].
    suite := TestSuite named:(self suiteNameFromClasses: self allTestCases).

    allTestCases do:[:testCase | 
        suite addTests:(self buildSuiteFromClass:testCase) tests
    ].
    ^suite

    "Modified: / 04-03-2011 / 06:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2012 / 19:01:48 / cg"
! !

!TestRunnerEmbedded class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

