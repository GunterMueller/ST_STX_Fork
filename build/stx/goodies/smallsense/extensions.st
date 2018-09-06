"{ Package: 'stx:goodies/smallsense' }"!

!AssignmentNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock

    aBlock value: #variable   value: variable.
    aBlock value: #expression value: expression.

    "Modified: / 26-11-2011 / 10:39:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AssignmentNode methodsFor:'accessing-SmallSense'!

inferedType
    expression isNil ifTrue:[ 
        ^ SmallSense::Type unknown
    ].
    ^ expression inferedType

    "Created: / 26-11-2011 / 12:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2015 / 17:16:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AssignmentNode methodsFor:'accessing-SmallSense'!

inferedType: aSmallSenseType

    ^ self shouldNotImplement

    "Created: / 26-11-2011 / 12:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BlockNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    "Enumerates all direct children and evaluates a block
     with its name (usually instVar name) and the node itself"

    aBlock value:'statements' value: statements

    "Created: / 20-09-2013 / 01:03:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasSmallSenseEnabled

    ^UserPreferences current smallSenseEnabled


    "
     ConfigurableFeatures hasSmallSenseEnabled
     ConfigurableFeatures includesFeature:'SmallSenseEnabled'
    "

    "Created: / 27-11-2011 / 17:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebugView methodsFor:'event handling'!

processShortcut:aKeyPressEvent
    "a shortcut key event as forwarded from the keyboardProcessor - if there is the
     shortcut key defined, process the shortcut and return true - otherwise false."

    UserPreferences current smallSenseEnabled ifTrue:[   
        (aKeyPressEvent key == #OpenNavigator or:[aKeyPressEvent rawKey == #CtrlT and:[(aKeyPressEvent targetView keyboardMap hasMappingFor:#OpenNavigator) not]]) ifTrue:[ 
            SmallSense::Navigator open.                                                                      
            ^ true
        ].    
    ].
    ^ super processShortcut:aKeyPressEvent

    "Created: / 25-01-2015 / 12:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 21:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DialogBox class methodsFor:'smalltalk dialogs-SmallSense'!

stx_goodies_smallsense_requestProject:title from:listOfProjects initialAnswer:initialTextOrNil suggestions:suggestions
    "Ask for a project (package-id)"

    <swizzle: #requestProject:from:initialAnswer:suggestions:>
    "
    stx_goodies_smallsense swizzle: (DialogBox class >> #stx_goodies_smallsense_requestProject:from:initialAnswer:suggestions:)
    "

    | dialog |

    UserPreferences current smallSenseNewDialogsEnabled ifFalse:[ 
        ^ self stx_libwidg_requestProject:title from:listOfProjects initialAnswer:initialTextOrNil suggestions:suggestions
    ].
    dialog := SmallSense::PackageSelectDialog new.
    dialog title: title.
    dialog filter: [ :pkg | listOfProjects includes: pkg ].
    (initialTextOrNil notNil and:[initialTextOrNil ~~ PackageId noProjectID]) ifTrue:[
        initialTextOrNil isEmpty ifTrue:[
            suggestions size == 1 ifTrue:[
                dialog pattern:   suggestions anElement. 
                dialog selection: suggestions anElement. 
            ].
        ] ifFalse:[ 
            dialog pattern: initialTextOrNil.
            dialog selection: initialTextOrNil.
        ]
    ].
    ^ dialog open.

    "Created: / 25-11-2014 / 13:20:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-02-2015 / 17:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextView methodsFor:'accessing-behavior'!

autoIndent
    ^ autoIndent
! !

!EditTextViewCompletionSupport methodsFor:'queries'!

isCompletionViewShown
    ^ completionView notNil and:[ completionView isVisible ]

    "Created: / 13-08-2014 / 16:00:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HTMLDocumentView methodsFor:'actions'!

doQuickFix: quickFixNo
    | app |

    app := self application.
    app notNil ifTrue:[
	app doQuickFix: quickFixNo
    ].

    "Created: / 16-02-2012 / 14:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InspectorView methodsFor:'initialization & release'!

preRealize
    "/ This method is an ugly hack to hook-in a a SmallSense completer.
    "/ Things fall apart if somebody later defined preRealize on
    "/ InspectorView...
    UserPreferences current smallSenseCompletionEnabled ifTrue:[ 
        | completion support |

        support := SmallSense::EditSupport forLanguage: object class programmingLanguage.
        support initializeForTextView: workspace.  
        completion := SmallSense::CompletionController for: workspace. 
        completion support: support.
        workspace completionSupport: completion.  
    ].
    super preRealize

    "Modified: / 12-02-2015 / 00:20:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock

    aBlock value: #receiver value: receiver.
    argArray notNil ifTrue:[
	argArray withIndexDo:[:node :idx|
	    aBlock value: 'arg[' , idx printString , ']' value: node
	]
    ]

    "Modified: / 26-11-2011 / 12:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MessageNode methodsFor:'navigation-SmallSense'!

navigateToUsing: navigator
    navigator navigateToMessageNode: self.

    "Created: / 24-09-2013 / 10:04:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'inspecting'!

inspector2TabRBParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (RB)';
        priority:35;
        application:
                [
                    | src node |

                    src := self source.
                    node := RBParser parseMethod: src.
                    SmallSense::ParseTreeInspector new node:node source:src.
                ];
        yourself

    "Created: / 15-10-2014 / 02:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'inspecting'!

inspector2TabSTXParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (ST/X)';
        priority:36;
        application:
                [
                    | src parser |

                    src := self source.
                    parser := self parserClass parseMethod: src.
                    SmallSense::ParseTreeInspector new node:parser tree source:src.
                ];
        yourself

    "Created: / 15-10-2014 / 11:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseErrorNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    "superclass ParseNode says that I am responsible to implement this method"

    ^ children withIndexDo:[:child :index |
        aBlock value:'child[' , index printString , ']' value: child
    ]

    "Modified: / 20-09-2013 / 01:00:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    "Enumerates all direct children and evaluates a block
     with its name (usually instVar name) and the node itself"

    self class allInstVarNames withIndexDo:[:n :i|
        | v |

        v := self instVarAt: i.
        (v isKindOf: ParseNode) ifTrue:[
            aBlock value: n value: v
        ] ifFalse:[
            (v isSequenceable) ifTrue:[
                v withIndexDo:[ :v2 :i2|
                    (v2 isKindOf: ParseNode) ifTrue:[
                        aBlock value: (n, '[' , i2 printString , ']') value: v2.
                    ]
                ]
            ]
        ]
    ]

    "Created: / 26-11-2011 / 10:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2013 / 18:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'accessing-SmallSense'!

inferedType

    | t |
    t := self objectAttributeAt:#inferedType.
    t isNil ifTrue:[t := SmallSense::Type unknown].
    ^t

    "Created: / 26-11-2011 / 12:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2013 / 20:46:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'accessing-SmallSense'!

inferedType: aSmallSenseType

    ^ self objectAttributeAt:#inferedType put: aSmallSenseType

    "Created: / 26-11-2011 / 12:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'inspecting'!

inspector2TabSTXParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (ST/X)';
        priority:36;
        application:
                [
                    SmallSense::ParseTreeInspector new node:self source:nil.
                ];
        yourself

    "Created: / 15-10-2014 / 11:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseNode methodsFor:'testing'!

isSelector
    "return true, if this is a node for an selctors"

    ^ false

    "Created: / 22-02-2011 / 21:44:45 / Jakub <zelenja7@fel.cvut.cz>"
! !

!ParseNode methodsFor:'navigation-SmallSense'!

navigateToUsing:navigator
    "Nothing by default, to overwritten by subclasses"

    "Modified: / 24-09-2013 / 10:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Parser methodsFor:'inspecting'!

inspector2TabSTXParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (ST/X)';
        priority:36;
        application:
                [
                    | src parser |

                    source isExternalStream ifFalse:[ 
                        src := source collection 
                    ].
                    SmallSense::ParseTreeInspector new node:tree source:src.
                ];
        yourself

    "Created: / 15-10-2014 / 11:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PrimaryNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock

    "Initionally left blank, primary nodes have no children"

    "Modified: / 26-11-2011 / 11:49:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PrimitiveNode methodsFor:'accessing-SmallSense'!

inferedType

    ^ SmallSense::Type withClass: UndefinedObject "/ Not really true, should be 'void'

    "Created: / 08-12-2013 / 22:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBlockNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    arguments withIndexDo:[:statement :index |
        aBlock value: 'argument[', index printString ,']' value: statement
    ].
    body statements withIndexDo:[:statement :index |
        aBlock value: 'statement[', index printString ,']' value: statement
    ]

    "Created: / 15-10-2014 / 10:42:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsSmalltalkXEOLCommentRule methodsFor:'accessing'!

fixes: fixer
    | changes |

    changes := self changes.
    changes notEmptyOrNil ifTrue:[
        fixer fix
            rule: self;
            label:'Change EOL comments to standard Smalltalk comments';
            action: [ fixer apply:
                ((ChangeSet withAll:changes) name: self name)
            ].
    ]

    "Created: / 01-02-2012 / 12:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 16:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRule methodsFor:'accessing'!

fixes: aSmallSenseQuickFixer
    "Adds all possible code fixes to given quick fixer.
     Default is to do nothing, meaning that there are
     no quickfixes available"

    "Created: / 01-02-2012 / 12:09:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethod methodsFor:'inspecting'!

inspector2TabRBParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (RB)';
        priority:35;
        application:
                [
                    SmallSense::ParseTreeInspector new node:self source: self source.
                ];
        yourself

    "Created: / 26-10-2015 / 11:25:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    arguments withIndexDo:[:statement :index |
        aBlock value: 'argument[', index printString ,']' value: statement
    ].
    body statements withIndexDo:[:statement :index |
        aBlock value: 'statement[', index printString ,']' value: statement
    ]

    "Created: / 15-10-2014 / 09:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-10-2014 / 10:41:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMethodNode methodsFor:'inspecting'!

inspector2TabRBParseTreeInspector
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Parse Tree (RB)';
        priority:35;
        application:
                [
                    SmallSense::ParseTreeInspector new node:self source:self source.
                ];
        yourself

    "Created: / 26-10-2015 / 11:26:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock

    "Enumerates all direct children and evaluates a block
     with its name (usually instVar name) and the node itself"

    self class allInstVarNames withIndexDo:[:n :i|
        | v |

        n ~~ #parent ifTrue:[
            v := self instVarAt: i.
            (v isKindOf: RBProgramNode) ifTrue:[
                aBlock value: n value: v
            ] ifFalse:[
                (v isSequenceable) ifTrue:[
                    v withIndexDo:[ :v2 :i2|
                        (v2 isKindOf: RBProgramNode) ifTrue:[
                            aBlock value: (n, '[' , i2 printString , ']') value: v2.
                        ]
                    ]
                ]
            ]
        ]
    ]

    "Created: / 15-10-2014 / 10:39:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'accessing'!

endPosition
    ^ self stop

    "Created: / 15-10-2014 / 09:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBProgramNode methodsFor:'accessing'!

startPosition
    ^ self start

    "Created: / 15-10-2014 / 09:34:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBTransformationRule methodsFor:'accessing'!

fixes: fixer
    | changes |

    changes := self changes.
    changes notEmptyOrNil ifTrue:[
        fixer fix
            rule: self;    
            label:'Rewrite the code';
            action: [ 
                fixer apply: ((ChangeSet withAll:self changes) name: self name)
            ].
    ]

    "Created: / 01-02-2012 / 12:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 16:46:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReturnNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    aBlock value: 'expression' value: expression.

    "Created: / 10-04-2014 / 08:15:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatementNode methodsFor:'enumeration'!

childNamesAndValuesDo:aBlock
    | stmt index |
    stmt := self.
    index := 1.
    [ stmt notNil ] whileTrue:[
        | expr |

        stmt isReturnNode ifTrue:[
            expr := stmt.
        ] ifFalse:[
            expr := stmt expression.
        ].
        aBlock value: ('statement[%1]' bindWith: index) value: expr.
        stmt := stmt nextStatement.
        index := index + 1.
    ]

    "Modified: / 10-04-2014 / 08:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatementNode methodsFor:'accessing-SmallSense'!

inferedType

    ^ expression inferedType

    "Created: / 26-11-2011 / 12:38:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatementNode methodsFor:'accessing-SmallSense'!

inferedType: aSmallSenseType

    ^ self shouldNotImplement

    "Created: / 26-11-2011 / 12:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::CodeCompletionService class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ (SmallSense::EditService ? self) basicNew initialize.

    "Created: / 27-07-2013 / 22:47:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-11-2014 / 15:40:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::CodeHighlightingService class methodsFor:'instance creation'!

new
    "return an initialized instance"

    |serviceUsed|
    
    "/ cg: what an ugly hack; @Jan, why this
    "/ ^ (SmallSense::CodeHighlightingService ? self) basicNew initialize.

    "/ cg: at least allow subclassing
    serviceUsed := self.
    self == Tools::CodeHighlightingService ifTrue:[
        serviceUsed := (SmallSense::CodeHighlightingService ? self).
    ].
    ^ serviceUsed basicNew initialize
    
    "Created: / 27-07-2013 / 22:47:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2013 / 14:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::CodeNavigationService class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ (SmallSense::CodeNavigationService ? self) basicNew initialize.

    "Created: / 27-07-2013 / 22:47:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2013 / 14:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::Inspector2 methodsFor:'event handling'!

processShortcut:aKeyPressEvent
    "a shortcut key event as forwarded from the keyboardProcessor - if there is the
     shortcut key defined, process the shortcut and return true - otherwise false."

    UserPreferences current smallSenseEnabled ifTrue:[   
        (aKeyPressEvent key == #OpenNavigator or:[aKeyPressEvent rawKey == #CtrlT and:[(aKeyPressEvent targetView keyboardMap hasMappingFor:#OpenNavigator) not]]) ifTrue:[ 
            SmallSense::Navigator open.
            ^ true
        ].    
    ].
    ^ super processShortcut:aKeyPressEvent

    "Created: / 25-01-2015 / 12:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 21:34:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::LintService methodsFor:'event handling'!

buttonPress:button x:x y:y in:view 
    |lineNr|

    view == gutterView ifTrue:[
        button == 1 ifTrue:[
            lineNr := textView yVisibleToLineNr:y.
            lineNr notNil ifTrue:[ 
                ^ self showInfoWindowForLine: lineNr 
            ].
            ^ false.
        ].
    ].
    ^ false

    "Created: / 30-01-2012 / 21:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2014 / 10:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::LintService methodsFor:'private'!

showInfoWindowForLine: lineNo
    | ann |

    ann := self annotationAtLine: lineNo.
    ann isNil ifTrue:[ ^ false ].

    SmallSense::CriticsWindow new
        rule: ann rule;
        codeView: codeView;
        allButOpen;
        openWindowAt: (Screen current pointerPosition - (20@20)).

    ^true

    "Created: / 30-01-2012 / 21:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2014 / 10:00:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NavigationState methodsFor:'aspects - SmallSense'!

stx_goodies_smallsense_selectedClasses
    <swizzle: #selectedClasses>
    selectedClasses isNil ifTrue:[
        selectedClasses := nil asValue.
        (ConfigurableFeatures includesFeature:'SmallSenseEnabled') ifTrue:[
            selectedClasses
                onChangeEvaluate:[
                    selectedClasses value ? #() do:[:cls |
                        (Smalltalk at:#'SmallSense::Manager') instance updateInfoForClass:cls.
                    ].
                ]
        ]
    ].
    ^ selectedClasses

    "Created: / 24-08-2013 / 21:53:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'user actions-events'!

processShortcut: aKeyPressEvent
    UserPreferences current smallSenseEnabled ifTrue:[
        aKeyPressEvent isKeyPressEvent ifTrue:[
            (aKeyPressEvent key == #OpenNavigator or:[aKeyPressEvent rawKey == #CtrlT and:[(aKeyPressEvent targetView keyboardMap hasMappingFor:#OpenNavigator) not]]) ifTrue:[ 
                self searchMenuOpenNavigatorOnDeclarations.
                ^ true
            ].
        ].
    ].
    ^ super processShortcut: aKeyPressEvent

    "Created: / 01-02-2015 / 07:22:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 21:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-searching-smallsense'!

searchCompletionBlock_SmallSense
    "This returns a class/selector name completion block that uses
     standard DoWhatIMeanSupport"

    ^ [:patternString | self smallSenseSearchCompletion:patternString ]

    "Created: / 25-11-2013 / 12:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-searching-SmallSense'!

searchMenuOpenNavigatorOnDeclarations
    "Open a SmallSense navigator on definitions (i.e.,
     navugating to a class or or method implementor)"

    | result |    

    result := SmallSense::Navigator new open.
    result isBehavior ifTrue:[
        self createBuffer.
        self switchToClass: result.
        ^ self
    ].
    result isMethod ifTrue:[ 
        self createBuffer.
        self switchToClass: result mclass selector: result selector.
        ^ self
    ].
    result isCollection ifTrue:[ 
        (result allSatisfy:[:e|e isMethod]) ifTrue:[ 
            self  spawnMethodBrowserForSearch:[ result ] 
                  sortBy:#class 
                  in:#newBuffer 
                  label:(resources string: 'Implementors of %1' with: result anElement selector storeString)
        ].
        ^ self
    ].
    ^ self

    "Created: / 23-01-2015 / 20:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2015 / 08:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-searching-smallsense'!

smallSenseSearchCompletion:patternString
    "/sorry, no method search yet"

    ^ self smallSenseSearchCompletionNewForClass:patternString

    "Modified: / 04-08-2011 / 19:05:28 / cg"
    "Created: / 04-12-2011 / 22:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-searching-smallsense'!

smallSenseSearchCompletionBlock
    "This returns a class/selector name completion block that uses
     standard DoWhatIMeanSupport"

    ^ [:patternString | self smallSenseSearchCompletion:patternString ]

    "Modified: / 04-08-2011 / 19:05:28 / cg"
    "Created: / 04-12-2011 / 22:13:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-searching-smallsense'!

smallSenseSearchCompletionEntryForClass:aClass showPrefix:showPrefix
    ^ (SmallSense::ClassPO new)
        klass:aClass;
        showPrefix:showPrefix.

    "Created: / 06-04-2012 / 12:55:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2013 / 12:16:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-searching-smallsense'!

smallSenseSearchCompletionNewForClass:patternString
    | env  pattern  matcher  matches  relax  withPrefix |

    patternString isEmptyOrNil ifTrue:[
        ^ #( '' #() )
    ].
    env := self theSingleSelectedNamespace ? #Smalltalk.
    env = NavigatorModel nameListEntryForALL ifTrue:[
        env := #Smalltalk
    ].
    env := Smalltalk at:env.
    withPrefix := patternString includes:$:.
    pattern := StringPattern readFrom:patternString onError:[ ^ #( '' #() ) ].
    withPrefix ifTrue:[
        matcher := [:cls | pattern match:cls name ]
    ] ifFalse:[
        matcher := [:cls | pattern match:cls nameWithoutPrefix ]
    ].
    relax := 1.
    [
        matches isEmptyOrNil and:[ relax <= 3 ]
    ] whileTrue:[
        matches := OrderedCollection new.
        env
            keysDo:[:nm |
                | cls |

                cls := env at:nm.
                (cls notNil and:[ cls isBehavior and:[ (matches includesIdentical:cls) not ] ])
                        ifTrue:[
                            "cls isJavaClass"false ifTrue:[
                                cls isAnonymous ifFalse:[
                                    (matcher value:cls) ifTrue:[
                                        matches add:cls
                                    ].
                                ].
                            ] ifFalse:[
                                (matcher value:cls) ifTrue:[
                                    matches add:cls
                                ].
                            ]
                        ].
            ].
        relax := relax + 1.
    ].
    matches isEmpty ifTrue:[
        ^ #( nil #() )
    ] ifFalse:[
        matches := matches
                collect:[:cls |
                    self smallSenseSearchCompletionEntryForClass:cls showPrefix:withPrefix
                ].
        ^ {
            matches first.
            matches
        }
    ]

    "Created: / 06-04-2012 / 12:56:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 13:10:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'private-dialogs-SmallSense'!

stx_goodies_smallsense_askForMethodCategory:question title:boxTitle okLabel:okLabel list:someCategories recentList:recentListOrNil initialAnswer:initialText
    "convenient helper method: setup a box asking for a method category"

    <swizzle: #askForMethodCategory:title:okLabel:list:recentList:initialAnswer:>

    | dialog |

    UserPreferences current smallSenseNewDialogsEnabled ifFalse:[ 
        ^ self stx_libtool_askForMethodCategory:question title:boxTitle okLabel:okLabel list:someCategories recentList:recentListOrNil initialAnswer:initialText     
    ].
    dialog := SmallSense::ProtocolSelectDialog new.   
    dialog title: (resources string: question).
    dialog addButtonCancel.   
    dialog addButtonAcceptWithLabel: (resources string: okLabel).  
    dialog protocolsToHighlight: (Iterator on:[ :whatToDo |
        self selectedClasses value do:[:each | 
            each withAllSuperclassesDo:[ :cls |
                cls methodDictionary do:[:method | 
                    whatToDo value: method category.
                ]
            ].
        ].
    ]).
    initialText notNil ifTrue:[ 
        dialog pattern: initialText.
        dialog selection: initialText. 
    ].
    ^ dialog open
    "
    stx_goodies_smallsense swizzle: (Tools::NewSystemBrowser >> #stx_goodies_smallsense_askForMethodCategory:title:okLabel:list:recentList:initialAnswer:)
    "

    "Created: / 09-01-2015 / 10:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2016 / 16:01:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-category-SmallSense'!

stx_goodies_smallsense_categoryMenuRename
    |categoriesToRename allCategories newCategory box
     cancelAll guess combosList change numClasses|

    <swizzle: #categoryMenuRename>


    UserPreferences current smallSenseNewDialogsEnabled ifFalse:[ 
        ^ self stx_libtool_categoryMenuRename
    ]. 

    self canUseRefactoringSupport ifTrue:[
        change := CompositeRefactoryChange named:'Rename categories'.
    ].

    numClasses := 0.

    self withWaitCursorDo:[
        categoriesToRename := self selectedCategoriesValue copy.
        categoriesToRename do:[:eachCategory |
            guess := DoWhatIMeanSupport
                        goodRenameDefaultFor:eachCategory
                        lastOld:LastCategoryRenameOld
                        lastNew:LastCategoryRenameNew.

            guess isNil ifTrue:[
                guess := eachCategory string.
            ].



            allCategories := environment allClassCategories asArray sort.
            combosList := LastCategoryRenames.
            (combosList size > 0 and:[combosList includes:eachCategory]) ifFalse:[
                combosList size == 0 ifTrue:[
                    combosList := List with:eachCategory
                ] ifFalse:[
                    combosList := (List with:eachCategory with:'-') , combosList
                ]
            ].
            cancelAll := false.

            box :=  SmallSense::CategorySelectDialog new.   
            box title: (resources string:'Rename class category...').
            categoriesToRename size > 1 ifTrue:[
                box addButtonWithLabel: (resources string:'Cancel All') action:[  cancelAll := true. box doCancel ].
            ].               
            box addButtonCancel.   
            box addButtonAccept.
            guess notNil ifTrue:[ 
                box pattern: guess.
                box selection: guess. 
            ]. 
            newCategory := box open.
            cancelAll ifTrue:[^ self].

            newCategory notNil ifTrue:[
                newCategory := newCategory withoutSeparators asSymbol.
                LastCategoryRenames isNil ifTrue:[
                    LastCategoryRenames := OrderedCollection new
                ].
                LastCategoryRenames addFirst:newCategory.
                LastCategoryRenames size > 20 ifTrue:[
                    LastCategoryRenames removeLast
                ].

                LastCategoryRenameOld := eachCategory.
                LastCategoryRenameNew := newCategory.

                (self selectedClassesInCategories:(Array with:eachCategory)) do:[:aClass |
                    "/ must be loaded ...
                    aClass autoload
                ].
                (self selectedClassesInCategories:(Array with:eachCategory)) do:[:aClass |
                    aClass category ~= newCategory ifTrue:[
                        numClasses := numClasses + 1.
                        change notNil ifTrue:[
                            change changeClassCategoryOf:aClass to:newCategory
                        ] ifFalse:[
                            aClass category:newCategory.
                        ].
                    ]
                ].
                numClasses == 0 ifTrue:[
                    self categoryListApp addAdditionalCategory:newCategory.
                ].
                self selectedCategories value:(Array with:newCategory).
            ].
        ].
    ].

    change notNil ifTrue:[
        numClasses > 0 ifTrue:[
            change name:('Rename category of %1 classes' bindWith:numClasses).
            RefactoryChangeManager performChange:change
        ]
    ].

    "
    stx_goodies_smallsense swizzle: (Tools::NewSystemBrowser >> #stx_goodies_smallsense_categoryMenuRename)
    "

    "Created: / 01-08-2015 / 06:06:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser class methodsFor:'utilities'!

stx_goodies_smallsense_askForClassToSearch:doWhatByDefault single:singleClass msgTail:msgTail resources:resourcesOrNil filter:filterOrNil forBrowser:aBrowserOrNil thenDo:aBlock
    "utility common code for both opening a new browser on a class and
     to search for a class in an existing browser.
     If singleClass is true, a single class will be asked for and browsed,
     otherwise, a match pattern is allowed and a multi-class browser is opened.
     Moved from instance protocol for better reusability."

    <swizzle: #askForClassToSearch:single:msgTail:resources:filter:forBrowser:thenDo:>

    |classes box boxLabel title okText okText2 okText3 className canFind doWhat doWhat2 doWhat3 resources showFullNameHolder onlyShowJavaClassesHolder|

    UserPreferences current smallSenseNewDialogsEnabled ifFalse:[ 
        ^ self stx_libtool_askForClassToSearch:doWhatByDefault single:singleClass msgTail:msgTail resources:resourcesOrNil filter:filterOrNil forBrowser:aBrowserOrNil thenDo:aBlock
    ].

    resources := resourcesOrNil ? self classResources.
    showFullNameHolder := (LastClassSearchBoxShowedFullName ? false) asValue.
    onlyShowJavaClassesHolder := (LastClassSearchBoxShowedJavaOnly ? false) asValue.

    doWhat := doWhatByDefault.
    canFind := aBrowserOrNil notNil
               and:[aBrowserOrNil navigationState notNil and:[ aBrowserOrNil navigationState isFullBrowser ]].

    (doWhat isNil or:[aBrowserOrNil isNil]) ifTrue:[
        title := 'Select a class'.
        boxLabel := (resources string:'Select a class').
        okText := 'OK'.
        okText2 := nil. doWhat2 := nil.
        okText3 := nil. doWhat3 := nil.
    ] ifFalse:[
        title := (singleClass ifTrue:[ 'Class to browse' ] ifFalse:[ 'Class(es) to browse' ]).
        boxLabel := (resources string:'Browse or Search').

        (doWhat isNil and:[canFind not]) ifTrue:[
            doWhat := #newBuffer.
        ].

        doWhat == #newBrowser ifTrue:[
            okText := 'Open New Window'.
            okText2 := 'Open New Buffer'. doWhat2 := #newBuffer.
            okText3 := 'Open'.       doWhat3 := nil.
        ] ifFalse:[ doWhat == #newBuffer ifTrue:[
            okText := 'Open New Buffer'.
            okText2 := 'Open New Window'.   doWhat2 := #newBrowser.
            okText3 := 'Open'.       doWhat3 := nil.
        ] ifFalse:[
            title := (singleClass ifTrue:[ 'Class to find' ] ifFalse:[ 'Class(es) to find' ]).
            okText := 'Open'.
            okText2 := 'Open New Window'.   doWhat2 := #newBrowser.
            okText3 := 'Open New Buffer'. doWhat3 := #newBuffer.
        ]].
    ].

    box := SmallSense::ClassSearchDialog new.
    box multiselect: true.

    "button3" "okButton" "button2" "cancel"

    box addButtonCancel.
    doWhat notNil ifTrue:[
        box addButtonWithLabel: (resources string:okText) action: [ box doAccept ] enablement: box acceptEnabledHolder.
        (aBrowserOrNil notNil and:[aBrowserOrNil navigationState isFullBrowser]) "singleClass" ifTrue:[
            box addButtonWithLabel: (resources string:okText3) action: [ doWhat := doWhat3. box doAccept ] enablement: box acceptEnabledHolder.
        ].
        box addButtonWithLabel: (resources string:okText2) action: [ doWhat := doWhat2. box doAccept ] enablement: box acceptEnabledHolder.
    ] ifFalse:[
        box addButtonAccept.
    ].



    classes := box open.
    classes size == 0 ifTrue:[ ^ nil ].
    self assert: classes size == 1.
    className := classes anElement name.


    LastClassSearchBoxShowedFullName := showFullNameHolder value.
    LastClassSearchBoxShowedJavaOnly := onlyShowJavaClassesHolder value.

    (doWhat isNil or:[aBrowserOrNil isNil]) ifTrue:[
        aBlock notNil ifTrue:[aBlock value:className optionalArgument:singleClass and:doWhat].
        ^ className
    ].

    aBrowserOrNil withSearchCursorDo:[
        aBlock value:className value:singleClass value:doWhat.
    ].
    ^ className

    "Created: / 28-04-2014 / 23:41:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-05-2016 / 16:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseBackgroundLintEnabled
    "Return true if SmallSense background source checking is enabled"

    ^self at:#smallSenseBackgroundLintEnabled ifAbsent:[false]

    "Created: / 30-01-2012 / 19:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseBackgroundLintEnabled: aBoolean
    "Return true if SmallSense background source checking is enabled"

    ^self at:#smallSenseBackgroundLintEnabled put: aBoolean

    "
	UserPreferences current smallSenseBackgroundLintEnabled
	UserPreferences current smallSenseBackgroundLintEnabled: true
	UserPreferences current smallSenseBackgroundLintEnabled: false
    "

    "Created: / 30-01-2012 / 20:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseBackgroundTypingEnabled
    "Return true if SmallSense background source checking is enabled"

    ^self at:#smallSenseBackgroundTypingEnabled ifAbsent:[false]

    "Created: / 04-02-2012 / 21:41:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseBackgroundTypingEnabled: aBoolean
    "Return true if SmallSense background source checking is enabled"

    ^self at:#smallSenseBackgroundTypingEnabled put: aBoolean

    "
	UserPreferences current smallSenseBackgroundTypingEnabled
	UserPreferences current smallSenseBackgroundTypingEnabled: true
	UserPreferences current smallSenseBackgroundTypingEnabled: false
    "

    "Created: / 04-02-2012 / 21:41:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseCompleteIfUnambiguous

    ^self at:#smallSenseCompleteIfUnambiguous ifAbsent:[false]

    "Created: / 18-01-2014 / 23:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseCompleteIfUnambiguous: aBoolean

    ^self at:#smallSenseCompleteIfUnambiguous put: aBoolean.

    "
    UserPreferences current smallSenseCompleteIfUnambiguous
    UserPreferences current smallSenseCompleteIfUnambiguous: true.
    UserPreferences current smallSenseCompleteIfUnambiguous: false.
    "

    "Created: / 18-01-2014 / 23:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseCompletionEnabled

    ^self at:#smallSenseCompletionEnabled ifAbsent:[self smallSenseEnabled]

    "Created: / 27-02-2014 / 09:29:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseCompletionEnabled: aBoolean

    ^self at:#smallSenseCompletionEnabled put: aBoolean

    "Created: / 27-02-2014 / 09:29:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseElectricEditSupportEnabled
    ^ self at:#smallSenseElectricEditSupportEnabled ifAbsent:[ false ].

    "Created: / 02-05-2015 / 21:57:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseElectricEditSupportEnabled: aBoolean

    ^self at:#smallSenseElectricEditSupportEnabled put: aBoolean

    "Created: / 02-05-2015 / 21:57:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseEnabled
    "Return true if SmallSense is enabled"

    ^self at:#smallSenseEnabled ifAbsent:[false]

    "Created: / 27-11-2011 / 17:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseEnabled: aBoolean
    "enable/disable SmallSense"

    ^self at:#smallSenseEnabled put: aBoolean.

    "
    UserPreferences current smallSenseEnabled.
    UserPreferences current smallSenseEnabled: true.
    UserPreferences current smallSenseEnabled: false.
    "

    "Created: / 02-04-2012 / 11:37:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseNewDialogsEnabled
    ^ self smallSenseEnabled
        and:[self at:#smallSenseNewDialogsEnabled ifAbsent:[false]]

    "
    UserPreferences current smallSenseNewDialogsEnabled.
    UserPreferences current smallSenseNewDialogsEnabled: true.
    UserPreferences current smallSenseNewDialogsEnabled: false.   
    "

    "Created: / 10-05-2014 / 00:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-11-2014 / 13:06:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense'!

smallSenseNewDialogsEnabled: aBoolean

    ^self at:#smallSenseNewDialogsEnabled put: aBoolean

    "Created: / 10-05-2014 / 00:04:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIndentOnPasteEnabled
    "Return true if SmallSense indent-on-paste is enabled for Smalltalk language"

    ^self at:#smallSenseSmalltalkIndentOnPasteEnabled ifAbsent:[false]

    "Created: / 19-07-2014 / 00:11:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIndentOnPasteEnabled: aBoolean
    "Set SmallSense indent-on-paste feature for Smalltalk"

    ^ self at:#smallSenseSmalltalkIndentOnPasteEnabled put: aBoolean

    "
    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled
    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: true.
    UserPreferences current smallSenseSmalltalkIndentOnPasteEnabled: false.
    "

    "Created: / 19-07-2014 / 00:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIterationVariableNameMaxLength
    "Maximum length for iteration variable name. If variable name computed from
     collection name exeeds the max length, 'each' is used instead."

    ^self at:#smallSenseSmalltalkIterationVariableNameMaxLength ifAbsent:[15"Magic number"]

    "Created: / 04-03-2015 / 08:01:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2015 / 09:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIterationVariableNameMaxLength: anInteger
    "Sets the maximum length for iteration variable name. If variable name computed from
     collection name exeeds the max length, 'each' is used instead."

    ^self at:#smallSenseSmalltalkIterationVariableNameMaxLength put: anInteger

    "Created: / 04-03-2015 / 08:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIterationVariableNamePrefixWithEach
    "If true, then iteration variable names are prefixed with 'each', i.e.,
     persons -> eachPerson."

    ^self at:#smallSenseSmalltalkIterationVariableNamePrefixWithEach ifAbsent:[false]

    "Created: / 04-03-2015 / 07:57:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-SmallSense-Smalltalk'!

smallSenseSmalltalkIterationVariableNamePrefixWithEach: aBoolean
    "If true, then iteration variable names are prefixed with 'each', i.e.,
     persons -> eachPerson."

    ^self at:#smallSenseSmalltalkIterationVariableNamePrefixWithEach put: aBoolean.

    "Created: / 04-03-2015 / 07:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableNode methodsFor:'queries'!

isGlobalOrPrivateClass

    ^ type == #GlobalVariable or:[type == #PrivateClass]

    "Created: / 27-11-2011 / 16:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableNode methodsFor:'navigation-SmallSense'!

navigateToUsing: navigator
    navigator navigateToVariableNode: self.

    "Created: / 24-09-2013 / 10:04:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WorkspaceApplication methodsFor:'event handling'!

processShortcut:aKeyPressEvent
    "a shortcut key event as forwarded from the keyboardProcessor - if there is the
     shortcut key defined, process the shortcut and return true - otherwise false."

    UserPreferences current smallSenseNewDialogsEnabled ifTrue:[   
       (aKeyPressEvent key == #OpenNavigator or:[aKeyPressEvent rawKey == #CtrlT and:[(aKeyPressEvent targetView keyboardMap hasMappingFor:#OpenNavigator) not]]) ifTrue:[ 
            SmallSense::Navigator open.
            ^ true
        ].    
    ].
    ^ super processShortcut:aKeyPressEvent

    "Created: / 25-01-2015 / 12:18:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 21:33:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
