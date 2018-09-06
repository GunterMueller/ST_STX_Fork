"{ Package: 'stx:goodies/refactoryBrowser/lint' }"!

!Annotation class methodsFor:'instance creation'!

ignore: rule rationale: rationale

    ^self ignore: rule rationale: rationale author: nil

    "Created: / 24-08-2010 / 20:41:22 / Jan Vrany <enter your email here>"
! !

!Annotation class methodsFor:'instance creation'!

ignore: rule rationale: rationale author: author
    ^LintRuleIgnoreAnnotation new
	rule: rule;
	rationale: rationale;
	author: author;
	yourself

    "Created: / 24-08-2010 / 20:40:56 / Jan Vrany <enter your email here>"
! !

!Annotation class methodsFor:'instance creation'!

ignoreLintRule: rule rationale: rationale author: author

    "Squeak compatibility"

    ^self ignore: rule rationale: rationale author: author

    "Created: / 24-08-2010 / 20:42:16 / Jan Vrany <enter your email here>"
! !

!Annotation class methodsFor:'instance creation'!

lint: rule rationale: rationale author: author

    "Squeak compatibility"

    ^self ignore: rule rationale: rationale author: author

    "Created: / 24-08-2010 / 20:41:59 / Jan Vrany <enter your email here>"
! !

!BrowserEnvironment methodsFor:'testing'!

includesMethod: aMethod

    ^self includesSelector: aMethod selector in: aMethod mclass
! !

!BrowserEnvironment methodsFor:'accessing'!

methodsInto:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!RestrictedEnvironment methodsFor:'accessing'!

classesInto:aCollection
    classDict keysDo:[:class | aCollection add:class ]

    "Created: / 13-01-2009 / 01:10:26 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 11:31:48 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RestrictedEnvironment methodsFor:'accessing'!

methodsInto:aCollection
    classDict
	keysAndValuesDo:[:class :selectorSet |
	    selectorSet do:[:selector |
		aCollection add:(class compiledMethodAt:selector)
	    ]
	]

    "Created: / 12-01-2009 / 23:25:54 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 01:45:07 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorEnvironment methodsFor:'accessing'!

classesInto:aCollection
    classSelectors
	keysDo:[:className | aCollection add:(Smalltalk at:className) ].
    metaClassSelectors
	keysDo:[:className | aCollection add:(Smalltalk at:className) ]

    "Created: / 10-01-2009 / 15:15:00 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 15:28:53 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 02-02-2010 / 20:57:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorEnvironment methodsFor:'accessing'!

methodsInto:aCollection
    |addMethods|
    
    addMethods := 
        [:class :selectorSet |
            selectorSet do:[:selector |
                |method|
                method := class compiledMethodAt:selector.
                method notNil ifTrue:[
                    aCollection add:method.
                ].
            ]
        ].
        
    classSelectors
        keysAndValuesDo:[:className :selectorSet |
            addMethods value:(Smalltalk at:className) value:selectorSet
        ].
        
    metaClassSelectors
        keysAndValuesDo:[:className :selectorSet |
            addMethods value:(Smalltalk at:className) theMetaclass value:selectorSet
        ].

    "Created: / 12-01-2009 / 23:20:43 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 15:29:43 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 02-02-2010 / 21:16:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesetDefault
    "Return the 'default' ruleset, i.e., ruleset which is run when
     SmallLint checks are run (unless a ruleset is explicitly selected). 

     Return nil if no ruleset is configured or ruleset is not found"

    | name |

    name := self at: #'smallLintRulesetDefault.name' ifAbsent:[ ^ nil ].
    ^ RBCompositeLintRule rulesets detect:[:ruleset | ruleset name = name ] ifNone:[ nil ]


    "
    UserPreferences current smallLintRulesetDefault
    UserPreferences current removeKey:#'smallLintRulesetDefault.name'
    "

    "Created: / 14-10-2014 / 08:16:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-10-2014 / 22:15:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesetDefault: anRBCompositeLintRule
    "Sets the 'default' ruleset, i.e., ruleset which is run when
     SmallLint checks are run (unless a ruleset is explicitly selected). "


    anRBCompositeLintRule notNil ifTrue:[ 
        self at: #'smallLintRulesetDefault.name' put: anRBCompositeLintRule name .
    ] ifFalse:[ 
        self at: #'smallLintRulesetDefault.name' put: nil.
    ].

    "
    UserPreferences current smallLintRulesetDefault
    UserPreferences current smallLintRulesetDefault: nil.
    "

    "Created: / 14-10-2014 / 08:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesets
    "Return list of user-defined rulesets as collection of RBCompositeLintRule"

    | specs rulesets |    

    specs := UserPreferences current at: #smalllintRulesets ifAbsent:[#()].
    rulesets := specs asOrderedCollection 
                    collect:[:spec|
                        [
                              RBCompositeLintRule decodeFromLiteralArray:spec
                        ] on:MissingClassInLiteralArrayErrorSignal do:[:ex | 
                            Logger warning:'Missing lint rule class: ' with:ex missingClassName.
                            ex return:nil
                        ]
                    ]
                    thenSelect:[:specOrNil | specOrNil notNil].
    ^ rulesets

    "
    UserPreferences current smallLintRulesets
    "

    "Created: / 14-10-2014 / 08:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesets: aCollection
    "Return list of user-defined rulesets as collection of RBCompositeLintRule"

    self
        at: #smalllintRulesets 
        put: (aCollection collect:[:ruleset|ruleset literalArrayEncoding] as: Array).
    "Hack, because preference system is stupid..."
    (Smalltalk includesKey: #'RBCompositeLintRule:RuleSets') ifTrue:[
        Smalltalk at: #'RBCompositeLintRule:RuleSets' put: aCollection  
    ].


    "
    UserPreferences current smallLintRulesets
    "

    "Created: / 14-10-2014 / 08:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesetsUserDefined
    "Return list of user-defined rulesets as collection of RBCompositeLintRule"
    
    |specs  rulesets |

    specs := UserPreferences current at:#smalllintRulesets ifAbsent:[ #() ].
    rulesets := specs asOrderedCollection 
            collect:[:spec | 
                [
                      "/ Kludge for loading old specs that used
                      "/ RBCompositeLintRule insted of RBUserDefinedRuleSet
                      spec first == RBCompositeLintRule name ifTrue:[
                          spec at:1 put:RBUserDefinedRuleSet name
                      ].
                      RBCompositeLintRule decodeFromLiteralArray:spec
                ] on:MissingClassInLiteralArrayErrorSignal do:[:ex | 
                    Logger warning:'Missing lint rule class: ' with:ex missingClassName.
                    ex return:nil
                ]
            ]
            thenSelect:[:specOrNil | specOrNil notNil ].
    ^ rulesets

    "
     UserPreferences current smallLintRulesets"
    "Created: / 14-10-2014 / 08:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 10:35:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-SmallLint'!

smallLintRulesetsUserDefined:aCollection 
    "Return list of user-defined rulesets as collection of RBCompositeLintRule"
    
    self at:#smalllintRulesets
        put:(aCollection 
                collect:[:ruleset | ruleset literalArrayEncoding ]
                as:Array).
     "Hack, because preference system is stupid..."
    (Smalltalk includesKey:#'RBCompositeLintRule:RuleSets') ifTrue:[
        Smalltalk at:#'RBCompositeLintRule:RuleSets' put:aCollection
    ].

    "
     UserPreferences current smallLintRulesets"
    "Created: / 14-10-2014 / 08:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableEnvironment methodsFor:'accessing'!

classesInto:aCollection
    classVariables
        keysDo:[:className | aCollection add:(Smalltalk classNamed:className) ].
    instanceVariables
        keysDo:[:className | aCollection add:(Smalltalk classNamed:className) ].

    "Created: / 14-01-2009 / 00:01:54 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:35:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableEnvironment methodsFor:'accessing'!

methodsInto:aCollection

    "Created: / 13-01-2009 / 09:49:04 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 16:43:58 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:34:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_refactoryBrowser_lint class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header$'
! !

