"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Report subclass:#LintReport
	instanceVariableNames:'environment rules'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports'
!


!LintReport methodsFor:'accessing - defaults'!

defaultFileSuffix

    ^ 'Lint'

    "Modified: / 08-10-2011 / 10:49:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultFormat
    "raise an error: must be redefined in concrete subclass(es)"

    ^ LintReportFormat::PMD new

    "Modified: / 25-11-2011 / 22:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultName

    environment isNil ifTrue:[^super defaultName].
    ^environment label

    "Modified: / 25-11-2011 / 22:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 13-01-2012 / 12:43:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'command line options'!

cmdlineOptionRuleset

    ^CmdLineOption new
        short: $s;
        long: 'ruleset';
        description: 'defines set of rules to check against.';
        action:[:option |
            self setupRulesFrom: option.
        ];
        yourself

    "Created: / 28-02-2013 / 23:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 16:54:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'generating'!

generateClass:class inPackage:package 
    | sourceInfo |

    sourceInfo := ReportSourceInfo forClass:class inPackage:package.
    format writeFile:(sourceInfo pathNameAbsolute: true)
        with:[
            self generateClass:class source:sourceInfo inPackage: package.
            self generateClass:class class source:sourceInfo inPackage: package.
        ].

    "Created: / 15-12-2014 / 10:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2014 / 10:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateClass: aClass selector: aSelector source: sourceInfo
        | matching |
        matching := rules select: [ :each | 
                (self isSelectorEnvironment: each result)
                        and: [ each result includesSelector: aSelector in: aClass ] ].
        self generateViolations: matching class: aClass selector: aSelector source: sourceInfo

    "Created: / 07-10-2011 / 11:04:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2013 / 18:10:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateClass: aClass selector: aSelector source: sourceInfo inPackage: package
        | matching |
        matching := rules select: [ :each | 
                (self isSelectorEnvironment: each result)
                        and: [ each result includesSelector: aSelector in: aClass ] ].
        self generateViolations: matching class: aClass selector: aSelector source: sourceInfo

    "Created: / 15-12-2014 / 11:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateClass: aClass source: sourceInfo inPackage: package 

    | matching |
    (environment definesClass: aClass) ifTrue: [
        matching := rules select: [ :rule | (self isClassEnvironment: rule result) and: [ rule result includesClass: aClass ] ].
        self generateViolations: matching class: aClass source: sourceInfo
    ].
    (environment selectorsForClass: aClass) asSortedCollection do: [ :selector | 
        self generateClass: aClass selector: selector source: sourceInfo inPackage: package
    ]

    "Created: / 15-12-2014 / 11:05:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateClassesInPackage:package 
    (ProjectDefinition searchForClassesWithProject:package) do:[:cls | 
        self generateClass:cls inPackage:package
    ].

    "Created: / 15-12-2014 / 10:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateExtensionsInPackage:package 
    | sourceInfo |

    sourceInfo := ReportSourceInfo forExtensionsInPackage:package.
    format writeFile:(sourceInfo pathNameAbsolute: true)
        with:[
            (ProjectDefinition searchForExtensionsWithProject:package) do:[:method | 
                self 
                    generateClass:method mclass
                    selector:method selector
                    source:sourceInfo
                    inPackage: package.
            ].
        ].

    "Created: / 15-12-2014 / 10:50:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2014 / 10:38:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generatePackage: package
    self generateClassesInPackage:package.  
    self generateExtensionsInPackage:package.

    "Created: / 15-12-2014 / 10:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateViolations: aCollection class: aClass selector: aSelector source: sourceInfo
    | method offset  |

    (AbstractSourceCodeManager isVersionMethodSelector: aSelector) ifTrue:[ ^ self ].
    (AbstractSourceCodeManager isExtensionsVersionMethodSelector: aSelector) ifTrue:[ ^ self ].


    method := aClass compiledMethodAt: aSelector.
    offset := sourceInfo offsetOfMethod: method.
    aCollection do: [ :rule |
        | tree |

        tree := RBParser parseMethod: method source.
        rule result selectionIntervalsForSource: method source tree: tree in: method mclass do:[:intervalOrNil | 
            | interval start stop |

            interval := interval isNil ifTrue: [ 1 to: method source size ].
            start := sourceInfo lineAndColumnOfOffset: offset + interval first - 1.
            stop  := sourceInfo lineAndColumnOfOffset: offset + interval last - 1.

            format writeViolation: rule
                       class: aClass selector: aSelector
                   startLine: start x column: start y
                    stopLine: stop x  column: stop  y.
        ]
    ]

    "Created: / 01-03-2013 / 18:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 11:32:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateViolations: aCollection class: aClass source: sourceInfo
    | method offset start stop |

    start := sourceInfo lineAndColumnOfOffset: 1.
    stop  := sourceInfo lineAndColumnOfOffset: SmallInteger maxVal.
    aCollection do: [ :rule |
        | interval  |

        format writeViolation: rule
                   class: aClass selector: nil
               startLine: start x column: start y
                stopLine: stop x  column: stop  y.
    ]

    "Created: / 15-12-2014 / 11:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'initialization'!

setupForClasses: classes

    environment := BrowserEnvironment new forClasses: classes.
    environment label: name

    "Created: / 04-08-2011 / 14:40:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupForPackages: pkgs
    pkgs isEmpty ifTrue:[^self].
    environment := PackageEnvironment 
                    onEnvironment: BrowserEnvironment new
                    packageNames: pkgs.
    name isNil ifTrue:[
        pkgs size > 1 ifTrue:[
            name :=  pkgs size printString , ' packages'.
        ] ifFalse:[
            name :=  pkgs anElement
        ]
    ].

    environment label: name.

    "
        LintReport runPackage:'stx:goodies/monticello'.
        LintReport runPackage:'stx:libjava'
    "

    "Created: / 04-08-2011 / 14:40:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 10:52:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'private'!

lineAndColumn: aString at: anInteger
	| line last stream |
	line := 1.
	last := 0.
	stream := aString readStream.
	[ (stream nextLine isNil or: [ anInteger <= stream position ])
		ifTrue: [ ^ line @ (anInteger - last) ].
	last := stream position.
	line := line + 1 ]
		repeat
!

sourceFilenameForClass:class package: package 
    | fn  cls |

    cls := class theNonMetaclass.
    fn := package copy
            replaceAll:$: with:$_;
            replaceAll:$/ with:$_;
            yourself.
    fn := fn , '_' , (cls asString copyReplaceAll:$: with:$_) , '.' 
            , cls programmingLanguage sourceFileSuffix.
    ^ self encodeFilename:fn.

    "
        Builder::LintReportFormat::CheckStyle basicNew
            sourceFilenameFor: Class

        Builder::LintReportFormat::CheckStyle basicNew
            sourceFilenameFor: Builder::LintReportFormat"

    "Created: / 15-12-2014 / 10:46:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFilenameForExtensionsInPackage: package 
    | fn |

    fn := package copy
            replaceAll:$: with:$_;
            replaceAll:$/ with:$_;
            yourself.
    fn := fn , '_' , 'extensions.st'.
    ^ self encodeFilename:fn.

    "
        Builder::LintReportFormat::CheckStyle basicNew
            sourceFilenameFor: Class

        Builder::LintReportFormat::CheckStyle basicNew
            sourceFilenameFor: Builder::LintReportFormat"

    "Created: / 15-12-2014 / 10:50:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'running'!

runReport
    | wasTryLocalSources |

    [
        wasTryLocalSources := Class tryLocalSourceFirst.
        Class tryLocalSourceFirst: true.
        SmalllintChecker 
            runRule: (RBCompositeLintRule rules: rules)
            onEnvironment: environment.
        environment packageNames do:[:packageName | 
            self generatePackage: packageName  
        ].
    ] ensure:[
        Class tryLocalSourceFirst: wasTryLocalSources 
    ]

    "Modified: / 15-12-2014 / 11:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setUp

    super setUp.
    rules isNil ifTrue:[
        rules := RBBuiltinRuleSet rulesetBuiltinDefault flatten   
    ].

    "Created: / 04-08-2011 / 14:35:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 11:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupRulesFrom: filename
    | file |    
    file := filename asFilename.
    file readingFileDo:[:s|
        | spec |
        spec := Parser parseLiteralArray: s.
        rules := spec decodeAsLiteralArray rules.
    ]

    "Created: / 28-02-2013 / 23:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReport methodsFor:'testing'!

isClassEnvironment: anEnvironment
	^ #(CategoryEnvironment ClassEnvironment VariableEnvironment) includes: anEnvironment class name
!

isSelectorEnvironment: anEnvironment
	^ #(SelectorEnvironment ParseTreeEnvironment VariableEnvironment) includes: anEnvironment class name
! !

!LintReport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

