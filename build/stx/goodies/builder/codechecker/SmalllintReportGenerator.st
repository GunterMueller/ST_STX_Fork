"{ Package: 'stx:goodies/builder/codechecker' }"

Object subclass:#SmalllintReportGenerator
	instanceVariableNames:'rules environment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!SmalllintReportGenerator class methodsFor:'documentation'!

documentation
"
    a standalone smallint runner.
    Generates an xml report compatible to pmd, to be processed by hudson.

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                    [exBegin]
    |checker|

    checker := self new.
    checker addPackage:'exept:workflow'.
    checker performChecks.
    checker generateReportAs:'checkstyle.xml'
                                                                    [exEnd]

                                                                    [exBegin]
    |checker|

    checker := self new.
    checker addClasses:(Workflow::Datatype withAllSubclasses).
    checker performChecks.
    checker generateReportAs:'checkstyle.xml'
                                                                    [exEnd]
"
! !

!SmalllintReportGenerator class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SmalllintReportGenerator methodsFor:'checking'!

performChecks
    rules withIndexDo:[:rule :index|
       Stdout showCR:('Checking: ', rule name).
       (SmalllintChecker runRule: rule onEnvironment: environment)
    ].

    "Created: / 07-08-2011 / 01:10:00 / cg"
! !

!SmalllintReportGenerator methodsFor:'initialization'!

initialize
    self setupRules.
    self setupEnvironment

    "Modified: / 07-08-2011 / 01:14:51 / cg"
! !

!SmalllintReportGenerator methodsFor:'reporting'!

generateReportAs:aFilename
    aFilename asFilename writingFileDo:[:s | self generateReportOn:s].

    "Created: / 07-08-2011 / 01:17:46 / cg"
!

generateReportOn:aStream
    |perClass|

    perClass := IdentityDictionary new.

    rules do:[:eachRule | 
        eachRule problemCount > 0 ifTrue:[
            eachRule failedMethods do:[:method |
                |class perMethodAndClassMethod perMethod|

                class := method mclass.
                perMethodAndClassMethod := perClass at:class theNonMetaclass ifAbsentPut:[{ IdentityDictionary new. IdentityDictionary new }].
                perMethod := perMethodAndClassMethod at:(class isMeta ifTrue:[2] ifFalse:[1]).
                rules := perMethod at:method ifAbsentPut:[IdentitySet new].
                rules add:eachRule.
            ]
        ]
    ].

    aStream nextPutLine: '<?xml version="1.0"?>'.
    aStream nextPutLine: '<pmd>'.

    perClass keysAndValuesDo:[:class :perMethodAndClassMethod |
        |fullSource sourceStream classFileName|

        fullSource := class source.
        sourceStream := class localSourceStreamFor:(class classFilename).
        sourceStream notNil ifTrue:[
            classFileName := sourceStream pathName.
            sourceStream close.
        ] ifFalse:[
            classFileName := class packageDirectory construct:(class classFilename).
        ].

        aStream nextPutLine:('  <file name="%1">' bindWith:classFileName asFilename pathName).

        { (perMethodAndClassMethod at:2).
          (perMethodAndClassMethod at:1) } do:[:perMethod |
            (perMethod keys copyAsOrderedCollection sort:[:a :b | a selector < b selector]) do:[:eachMethod |
                |rulesPerMethod charPosOfMethod lineNumberOfMethod|

                rulesPerMethod := perMethod at:eachMethod.
                
                charPosOfMethod := eachMethod sourcePosition ? 1.
                "/ q&d hack - editor knows how to compute line number - should go
                "/ somewhere else...
                lineNumberOfMethod := (ListView basicNew setList:fullSource) lineOfCharacterPosition:charPosOfMethod.
                rulesPerMethod do:[:eachRule |
                    |ruleName rationale|

                    ruleName := eachRule name.
                    rationale := eachRule rationale.

                    aStream nextPutLine:('    <violation line="%1" rule="%2">' 
                                                        bindWith:lineNumberOfMethod with:ruleName).
                    aStream nextPutLine:('%1' bindWith:rationale).
                    aStream nextPutLine: '    </violation>'.

                ].
            ].
        ].
        aStream nextPutLine: '  </file>'.
    ].
    aStream nextPutLine: '</pmd>'.

    "Created: / 07-08-2011 / 01:17:00 / cg"
! !

!SmalllintReportGenerator methodsFor:'setup'!

addClass:aClass
    environment addClass: aClass.

    "Created: / 07-08-2011 / 01:11:33 / cg"
!

addClasses:aCollectionOfClasses
    aCollectionOfClasses do:[:eachClass | self addClass: eachClass ].

    "Created: / 07-08-2011 / 11:51:52 / cg"
!

addPackage:aPackage
    Smalltalk loadPackage:aPackage.
    Smalltalk allClassesInPackage:aPackage do:[:cls | self addClass:cls]

    "Created: / 07-08-2011 / 01:12:31 / cg"
!

setupEnvironment
    environment := ClassEnvironment new.

    "Created: / 07-08-2011 / 01:10:56 / cg"
!

setupRules
    self setupRules:(RBCompositeLintRule allRules).

    "Created: / 07-08-2011 / 01:08:56 / cg"
!

setupRules:rulesArg
    | checks|

    checks := rulesArg rules detect:[ :each | each name = 'Lint checks' ].
    checks rules: (checks rules reject: [ :each | each name = 'Squeak bugs' ]).

    rules := rulesArg flattened.

    "Created: / 07-08-2011 / 11:48:30 / cg"
! !

!SmalllintReportGenerator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
