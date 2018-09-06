"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
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

AbstractSettingsApplication subclass:#LintRuleSettingsApplication
	instanceVariableNames:'rulesetList rulesetSelectionHolder hasSelectionHolder
		hasSelectionAndUserDefinedHolder smallSenseEnabledHolder
		smallLintRulesetDefault defaultInBrowserRuleNameHolder'
	classVariableNames:'LastFileName'
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintRuleSettingsApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!LintRuleSettingsApplication class methodsFor:'class initialization'!

initialize

    Smalltalk addStartBlock:[
        NewLauncher
            addSettingsApplicationByClass: self name
            withName: 'Tools/SmallLint'
            icon: nil.
    ]

    "Created: / 04-02-2012 / 21:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2013 / 22:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSettingsApplication class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::LintRuleSettingsApplication    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#add
'Create a new ruleset'

#copy
'Create a copy of the selected ruleset'

#edit
'Edit the selected ruleset'

#export
'Export the selected ruleset as a file'

#import
'Import a ruleset from a file'

#remove
'Remove the selected ruleset'

#resetDefault
'Recreate the default ruleset with all existing RBRules.\(Do this after new rules have been added or rule classes were modified)'

#makeDefaultInBrowser
'Make this the default ruleset to be used in browsers'

#smallSenseEnabled
'Enable SmallSense (incremental lint rule checking in the editor).\If the SmallSense package is not yet loaded, checking this will force it into the image.\\Sorry, but this will only affect new windows,\so you have to reopen the browsers.'

)
! !

!LintRuleSettingsApplication class methodsFor:'interface opening'!

open    

    | settingsApp |

    settingsApp := SettingsDialog new.
    settingsApp addApplClass:self fullName
                withName:'SmallLint Rules'.
    settingsApp showRoot: false.
    settingsApp selectedItem value:
        (settingsApp applicationList root children anyOne).
    settingsApp open.

    "Created: / 26-05-2008 / 12:17:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2013 / 11:25:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::LintRuleSettingsApplication andSelector:#windowSpec
     Tools::LintRuleSettingsApplication new openInterface:#windowSpec
     Tools::LintRuleSettingsApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Lint Settings'
         name: 'Lint Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 587 473)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: topFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Enable Lintrule Checking in Codeview (Load SmallSense Package)'
                   name: 'CheckBox1'
                   activeHelpKey: smallSenseEnabled
                   model: smallSenseEnabledHolder
                   translateLabel: true
                   useDefaultExtent: true
                 )
                (ViewSpec
                   name: 'Box2'
                   component: 
                  (SpecCollection
                     collection: (
                      (LabelSpec
                         label: 'Predefined SmallLint Rule Sets'
                         name: 'Label'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         translateLabel: true
                         adjust: left
                       )
                      (SelectionInListModelViewSpec
                         name: 'ProfileList'
                         layout: (LayoutFrame 0 0 30 0 -128 1 -30 1)
                         enableChannel: svnEnabled
                         model: rulesetSelectionHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         listModel: rulesetList
                         useIndex: false
                         highlightMode: line
                         doubleClickSelector: doEdit
                       )
                      (VerticalPanelViewSpec
                         name: 'Buttons1'
                         layout: (LayoutFrame -128 1 30 0 0 1 -65 0.70000000000000095)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 5
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Edit'
                               name: 'ButtonEdit'
                               activeHelpKey: edit
                               translateLabel: true
                               tabable: true
                               model: doEdit
                               extent: (Point 128 22)
                             )
                            (ActionButtonSpec
                               label: 'Copy'
                               name: 'ButtonCopy'
                               activeHelpKey: copy
                               translateLabel: true
                               tabable: true
                               model: doCopy
                               extent: (Point 128 22)
                             )
                            (ActionButtonSpec
                               label: 'New'
                               name: 'ButtonAdd'
                               activeHelpKey: add
                               translateLabel: true
                               tabable: true
                               model: doAdd
                               extent: (Point 128 22)
                             )
                            (ActionButtonSpec
                               label: 'Remove'
                               name: 'ButtonRemove'
                               activeHelpKey: remove
                               translateLabel: true
                               tabable: true
                               model: doRemove
                               extent: (Point 128 22)
                             )
                            )
                          
                         )
                       )
                      (VerticalPanelViewSpec
                         name: 'Buttons2'
                         layout: (LayoutFrame -128 1 -64 0.70000000000000095 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: bottom
                         horizontalSpace: 5
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Make Default\in Browser'
                               name: 'Button5'
                               activeHelpKey: makeDefaultInBrowser
                               translateLabel: true
                               adjust: centerEach
                               multiLineLabel: true
                               tabable: true
                               model: makeDefaultInBrowser
                               enableChannel: hasSelectionHolder
                               extent: (Point 128 44)
                             )
                            (ViewSpec
                               name: 'Box3'
                               extent: (Point 128 29)
                             )
                            (ActionButtonSpec
                               label: 'Reinitialize'
                               name: 'Button4'
                               activeHelpKey: resetDefault
                               translateLabel: true
                               tabable: true
                               model: doResetDefault
                               extent: (Point 128 22)
                             )
                            (ViewSpec
                               name: 'Box1'
                               extent: (Point 128 30)
                             )
                            (ActionButtonSpec
                               label: 'Export'
                               name: 'Button2'
                               activeHelpKey: export
                               translateLabel: true
                               tabable: true
                               model: doExport
                               extent: (Point 128 22)
                             )
                            (ActionButtonSpec
                               label: 'Import'
                               name: 'Button3'
                               activeHelpKey: import
                               translateLabel: true
                               tabable: true
                               model: doImport
                               extent: (Point 128 22)
                             )
                            )
                          
                         )
                       )
                      (LabelSpec
                         label: 'Default in Browser:'
                         name: 'Label1'
                         layout: (LayoutFrame 0 0 -30 1 170 0 0 1)
                         translateLabel: true
                         adjust: left
                       )
                      (LabelSpec
                         label: 'default ruleset in browser'
                         name: 'Label2'
                         layout: (LayoutFrame 170 0 -30 1 -128 1 0 1)
                         translateLabel: true
                         labelChannel: defaultInBrowserRuleNameHolder
                         adjust: left
                       )
                      )
                    
                   )
                   extent: (Point 587 443)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!LintRuleSettingsApplication methodsFor:'accessing'!

selection

    ^self rulesetSelectionHolder value

    "Created: / 25-08-2010 / 14:10:03 / Jan Vrany <enter your email here>"
    "Modified: / 11-11-2014 / 15:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection: anObject

    self rulesetSelectionHolder value: anObject

    "Created: / 25-08-2010 / 14:09:40 / Jan Vrany <enter your email here>"
    "Modified: / 11-11-2014 / 15:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSettingsApplication methodsFor:'actions'!

doAdd
    <resource: #uiCallback>

    | ruleset |

    ruleset := RBCompositeLintRule new.
    ruleset name: 'New Rule Set ' , (self rulesetList size + 1) printString.
    self doAdd: ruleset

    "Modified: / 14-10-2014 / 16:30:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAdd: anRBCompositeLintRule
    | dialog |

    dialog := LintRuleEditDialog new.
    dialog rule: anRBCompositeLintRule.
    dialog open.
    dialog accepted ifTrue:[ 
        self rulesetList add: anRBCompositeLintRule.
        self rulesetSelectionHolder value: anRBCompositeLintRule.
        self updateModifiedChannel.
    ].

    "Created: / 27-02-2013 / 11:25:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 16:29:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCopy
    <resource: #uiCallback>

    | ruleset |

    ruleset := self rulesetSelectionHolder value deepCopy.
    ruleset name: ('Copy of ' , ruleset name).
    self doAdd:  ruleset

    "Modified: / 27-02-2013 / 11:30:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEdit
    <resource: #uiCallback>

    self doEdit: self rulesetSelectionHolder value.

    "Modified: / 14-10-2014 / 16:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEdit: rule
    | edited dialog |    

    rule isBuiltin ifTrue:[ 
        Dialog warn: (resources string: 'Cannot edit built-in rule sets').
        ^ self
    ].

    dialog := LintRuleEditDialog new.
    dialog nameEditableHolder value: false.
    edited := rule deepCopy.
    dialog rule: edited.
    dialog open.
    dialog accepted ifTrue:[ 
        rule name: edited name.
        rule rules: edited rules.
        self updateModifiedChannel.
    ].

    "Created: / 14-10-2014 / 16:47:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2014 / 01:59:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExport
    <resource: #uiCallback>

    | file |

    Dialog warn: 'Not yet implemented'.
    ^ self.

"/    file := Dialog requestFileName: (resources string: 'Select file') default: (LastFileName ? Filename currentDirectory / 'exported-ruleset.st').
"/    file isEmptyOrNil ifTrue:[ ^ self ].
"/
"/    self shouldImplement

    "Modified: / 14-10-2014 / 16:33:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doImport
    <resource: #uiCallback>

    Dialog warn: 'Not yet implemented'

    "Modified: / 14-10-2014 / 16:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemove
    <resource: #uiCallback>

    | rule idx rulesetList |

    rule := self rulesetSelectionHolder value.
    rulesetList := self rulesetList.
    idx := rulesetList indexOf: rule.
    idx ~~ 0 ifTrue:[
        rulesetList remove: rule.
        rulesetList size > 0 ifTrue:[
            self rulesetSelectionHolder value: (rulesetList at: ((idx -1 ) max: 1))
        ]
    ].
    self updateModifiedChannel

    "Modified: / 27-02-2013 / 11:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doResetDefault
    <resource: #uiCallback>

    RBBuiltinRuleSet flushBuiltinDefault.
!

makeDefaultInBrowser
    <resource: #uiCallback>

    self smallLintRulesetDefault value:(self rulesetSelectionHolder value).
! !

!LintRuleSettingsApplication methodsFor:'aspects'!

canCopyHolder
    ^self hasSelectionHolder

    "Created: / 27-02-2013 / 11:24:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canEditHolder
    ^self hasSelectionAndUserDefinedHolder

    "Created: / 27-02-2013 / 11:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2014 / 15:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canExportHolder
    ^self hasSelectionHolder

    "Created: / 27-02-2013 / 11:24:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canRemoveHolder
    ^self hasSelectionAndUserDefinedHolder

    "Created: / 27-02-2013 / 11:24:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2014 / 15:12:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultInBrowserRuleNameHolder
    defaultInBrowserRuleNameHolder isNil ifTrue:[
        defaultInBrowserRuleNameHolder := '' asValue
    ].
    ^ defaultInBrowserRuleNameHolder
!

hasSelectionAndUserDefinedHolder


    hasSelectionAndUserDefinedHolder isNil ifTrue:[
        hasSelectionAndUserDefinedHolder := PluggableAdaptor on: self rulesetSelectionHolder
            getter:[ :model | model value notNil and:[model value isBuiltin not ] ]

    ].
    ^ hasSelectionAndUserDefinedHolder

    "Created: / 11-11-2014 / 15:11:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelectionHolder
    "return/create the 'hasSelectionHolder' value holder (automatically generated)"

    hasSelectionHolder isNil ifTrue:[
        hasSelectionHolder := (AspectAdaptor forAspect: #notNil) subjectChannel: self rulesetSelectionHolder
    ].
    ^ hasSelectionHolder

    "Modified: / 27-02-2013 / 11:24:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSmallSenseLoaded
   ^ (Smalltalk at:#'SmallSense::SmalltalkChecker') notNil
!

hasSmallSenseNotLoaded
   ^ self hasSmallSenseLoaded not
!

rulesetList
    "return/create the 'rulesetList' value holder (automatically generated)"

    rulesetList isNil ifTrue:[
        rulesetList := List new.
    ].
    ^ rulesetList

    "Modified: / 27-02-2013 / 11:14:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesetSelectionHolder
    "return/create the 'rulesetSelectionHolder' value holder (automatically generated)"

    rulesetSelectionHolder isNil ifTrue:[
        rulesetSelectionHolder := ValueHolder new.
    ].
    ^ rulesetSelectionHolder
!

smallLintRulesetDefault
    smallLintRulesetDefault isNil ifTrue:[
        smallLintRulesetDefault := ValueHolder with:false.
        smallLintRulesetDefault 
            onChangeEvaluate:[
                self updateModifiedChannel.
                self defaultInBrowserRuleNameHolder 
                    value:(smallLintRulesetDefault value isNil
                            ifTrue:[ RBBuiltinRuleSet notNil 
                                        ifTrue:[RBBuiltinRuleSet rulesetBuiltinDefault]
                                        ifFalse:[nil]]    
                            ifFalse:[ smallLintRulesetDefault value name ])
            ].
    ].
    ^ smallLintRulesetDefault
!

smallSenseEnabledHolder
    smallSenseEnabledHolder isNil ifTrue:[
        smallSenseEnabledHolder := ValueHolder with:false.
        smallSenseEnabledHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ smallSenseEnabledHolder
! !

!LintRuleSettingsApplication methodsFor:'protocol'!

basicReadSettings
    "superclass AbstractSettingsApplication says that I am responsible to implement this method"

    |rbCompositeLintRuleClass|

    self smallSenseEnabledHolder 
        value:(self hasSmallSenseLoaded
               and:[ currentUserPrefs perform:#smallSenseEnabled ifNotUnderstood:false]).

    self smallLintRulesetDefault value:(currentUserPrefs smallLintRulesetDefault).

    rbCompositeLintRuleClass := Smalltalk at:#'RBCompositeLintRule'.

    rbCompositeLintRuleClass isNil ifTrue:[ 
        "/ Not loaded?
        [
            Smalltalk loadPackage: #'stx:goodies/refactoryBrowser/lint'.
        ] on: PackageLoadError do:[:ex | 
            Dialog warn: (resources string: 'SmallLint package could not be loaded!!').
            ^ self.
        ].
        rbCompositeLintRuleClass := Smalltalk at:#'RBCompositeLintRule'.
    ].

    rbCompositeLintRuleClass notNil ifTrue:[
        self rulesetList 
            removeAll; 
            addAll: rbCompositeLintRuleClass rulesetsBuiltin;            
            addAll: rbCompositeLintRuleClass rulesetsUserDefined deepCopy
    ].

    "Modified: / 11-11-2014 / 15:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    | oldRulesets newRulesets toRemove toAdd rbCompositeLintRuleClass|

    self smallSenseEnabledHolder value ifTrue:[
        currentUserPrefs addPreloadedPackage:'stx:goodies/smallsense'
    ] ifFalse:[
        currentUserPrefs removePreloadedPackage:'stx:goodies/smallsense'
    ].
    currentUserPrefs smallLintRulesetDefault:(smallLintRulesetDefault value).

    (Smalltalk at:#'SmallSense::SmalltalkChecker') notNil ifTrue:[
        UserPreferences current 
            perform:#smallSenseEnabled: with:(self smallSenseEnabledHolder value) ifNotUnderstood:[]
    ].

    rbCompositeLintRuleClass := Smalltalk at:#'RBCompositeLintRule'.

    oldRulesets := rbCompositeLintRuleClass rulesetsUserDefined.
    newRulesets := self rulesetList reject:[:e|e isBuiltin].

    toAdd := OrderedCollection withAll: newRulesets.
    toRemove := Set new.
    rbCompositeLintRuleClass rulesetsUserDefined do:[:oldRuleset | 
        | newRuleset |

        newRuleset := newRulesets detect:[:each | each name = oldRuleset name ] ifNone: nil.
        newRuleset isNil ifTrue:[ 
            toRemove add: oldRuleset.
        ] ifFalse:[ 
            toAdd remove: newRuleset.
            oldRuleset rules: newRuleset rules.
        ].
    ].
    oldRulesets removeAll:toRemove.
    oldRulesets addAll:toAdd.
    rbCompositeLintRuleClass rulesetsUserDefined: oldRulesets.

    "Modified: / 24-11-2014 / 11:21:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "subclasses must return either the relative name of a helpFile
     in the doc/online/<language>/help directory,
     or an absolute pathname (typically in their packageDirectory).
     Or nil, if no help is available."

    ^ 'Launcher/lintRuleSettings.html'
! !

!LintRuleSettingsApplication methodsFor:'queries'!

hasUnsavedChanges
    "superclass AbstractSettingsApplication says that I am responsible to implement this method"

    |defaultRules currentRules firstTry rbCompositeLintRuleClass|

    self smallSenseEnabledHolder value ifTrue:[
        currentUserPrefs addPreloadedPackage:'stx:goodies/smallsense'
    ].
    (currentUserPrefs perform:#smallSenseEnabled ifNotUnderstood:false)
            ~= (self smallSenseEnabledHolder value) 
    ifTrue:[
        ^ true
    ].
    currentUserPrefs smallLintRulesetDefault ~= (smallLintRulesetDefault value) ifTrue:[^ true].

    rbCompositeLintRuleClass := Smalltalk at:#'RBCompositeLintRule'.
    rbCompositeLintRuleClass isNil ifTrue:[^ false].

    firstTry := true.
    MissingClassInLiteralArrayErrorSignal handle:[:ex |
        "/ maybe we have to load additional packages...
        firstTry ifTrue:[
            (Smalltalk isPackageLoaded:'stx:goodies/refactoryBrowser/lint/spelling') ifFalse:[
                firstTry := false.
                Smalltalk loadPackage:'stx:goodies/refactoryBrowser/lint/spelling'.
                ex restart.
            ].
        ].
        ex reject.
    ] do:[
        defaultRules := rbCompositeLintRuleClass rulesetsUserDefined copyAsOrderedCollection.
        currentRules := self rulesetList copyAsOrderedCollection.
        "/ I will always add the defaultRule
        defaultRules removeAllFoundIn:rbCompositeLintRuleClass rulesetsBuiltin.
        currentRules removeAllFoundIn:rbCompositeLintRuleClass rulesetsBuiltin.
        ^ defaultRules ~= currentRules
    ].
    ^ false.

    "Modified: / 28-02-2013 / 10:03:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintRuleSettingsApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


LintRuleSettingsApplication initialize!
