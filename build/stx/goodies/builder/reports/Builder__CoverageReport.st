"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Report subclass:#CoverageReport
	instanceVariableNames:'instrumentedMethods'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports'
!


!CoverageReport methodsFor:'accessing-defaults'!

defaultFileSuffix

    "Return a default filename suffix. Note that format suffix will be 
     appended too if not file is explicitely specified"

    ^'Coverage'

    "Created: / 25-06-2013 / 01:12:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFormat
    "raise an error: must be redefined in concrete subclass(es)"

    ^ Builder::CoverageReportFormat::Cobertura new

    "Modified: / 25-06-2013 / 01:31:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultName

    packages isNil ifTrue:[
        ^'someClasses'.
    ].

    ^String streamContents:[:s|
        packages do:[:packageOrClass|
            s nextPutAll: packageOrClass printString 
        ] separatedBy:[
            s nextPut:$,;space
        ]
    ]

    "Created: / 25-06-2013 / 01:29:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReport methodsFor:'initialization'!

initialize
    instrumentedMethods := Set new.

    "Created: / 25-06-2013 / 01:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 13:21:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForClasses:classes
    "raise an error: must be redefined in concrete subclass(es)"

    classes do:[:each | self instrumentClass: each].

    "Modified: / 25-06-2013 / 16:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForPackages:pkgs
    "raise an error: must be redefined in concrete subclass(es)"

    pkgs do:[:each | self instrumentPackage: each ].

    "Modified: / 25-06-2013 / 16:22:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReport methodsFor:'instrumentation'!

instrumentClass:class
    class instAndClassMethods do:[:method|
        self instrumentMethod: method 
    ]

    "Created: / 25-06-2013 / 01:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instrumentMethod:method

    | class selector |

    class := method mclass.
    selector := method selector.
    (self excludedFromCoverage: method) ifFalse:[
        method isInstrumented ifFalse:[
            InstrumentingCompiler compileMethod: method.
        ].
        instrumentedMethods add: (class compiledMethodAt: selector)
    ]

    "Created: / 25-06-2013 / 01:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 02:45:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instrumentPackage:pkg
    Smalltalk allMethodsDo:[:method|
        method package asSymbol == pkg asSymbol ifTrue:[
            self instrumentMethod: method.
        ]
    ]

    "Created: / 25-06-2013 / 01:42:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 17:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReport methodsFor:'queries'!

excludedFromCoverage: aMethod
    "Returns true, if given method should be excluded from
     coverage report.

     Here, certain 'metadata' method like documentation, copyright,
     version methods, printOn: and so on are exluded. Also, testcases
     and test resources are ommited"

    | mclass mselector tree pkgdef |

    mclass := aMethod mclass.
    mselector := aMethod selector.

    aMethod hasPrimitiveCode ifTrue:[ ^ true ].
    (mclass inheritsFrom: TestCase) ifTrue:[ ^ true ].
    (mclass inheritsFrom: TestResource) ifTrue:[ ^ true ].
    (mclass inheritsFrom: ProjectDefinition) ifTrue:[ ^ true ].
    mclass isMetaclass ifTrue:[
        (#(
                copyright 
                documentation
        ) includes: mselector) ifTrue:[ ^ true ].
        (AbstractSourceCodeManager isVersionMethodSelector: mselector) ifTrue:[ ^ true ].
    ] ifFalse:[
        (#(
            printString printOn: 
            inspectorExtraAttributes inspectorClass
        ) includes: mselector) ifTrue:[ ^ true ].    
    ].

    tree := (Parser parseMethod: aMethod source in: mclass) tree.
    tree isNil ifTrue:[ ^ true ]. "/ empty method?
    (tree isStatement and:[tree isReturnNode not and:[tree nextStatement isNil]]) ifTrue:[
        tree := tree expression.
    ].

    "/ Exclude all getters/return constants...
    (aMethod numArgs == 0 
        and:[tree isReturnNode 
        and:[tree expression isVariable or:[tree expression isConstant]]]) ifTrue:[ ^ true ].

    "/ Exclude all setters
    (aMethod numArgs == 1 
        and:[tree isAssignment 
        and:[(tree variable isInstanceVariable or:[tree variable isClassVariable])
        and:[tree expression isVariable
        and:[tree expression isMethodArg]]]]) ifTrue:[ ^ true ].

    pkgdef := ProjectDefinition definitionClassForPackage: aMethod package.
    pkgdef notNil ifTrue:[
        ^ pkgdef excludedFromCoverage:aMethod.
    ].
    ^ false

    "Created: / 28-06-2013 / 02:20:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-06-2013 / 11:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReport methodsFor:'running'!

runReport
    "Actually run the report. What to do (what classes/packages to check)
     must be stored instance variables"

    format write: instrumentedMethods.

    "Modified: / 25-06-2013 / 13:13:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

