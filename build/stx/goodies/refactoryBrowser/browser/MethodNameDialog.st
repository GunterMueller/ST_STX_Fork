"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserDialog subclass:#MethodNameDialog
	instanceVariableNames:'argumentList selector methodName cancelAllVisible
		renameOnlyVisible renameSelectedMethodsOnlyVisible
		renameOnlyFlagHolder renameSelectedMethodsOnlyFlagHolder
		selectorOk rewriteLocalMethodsOnlyFlagHolder
		shownRewriteLocalMethodsOnlyFlagHolder browseChangedMethodsHolder
		browseButtonsVisibleHolder browseOldSendersHolder
		browseNewSendersHolder
		shownRewritePackageLocalMethodsOnlyFlagHolder
		rewritePackageLocalMethodsOnlyFlagHolder'
	classVariableNames:'LastRenameOnly LastRenameSelectedMethodsOnly LastBrowseChanged
		LastBrowseNew LastBrowseOld'
	poolDictionaries:''
	category:'Refactory-Refactorings UI'
!


!MethodNameDialog class methodsFor:'instance creation'!

for: aMethodName 
	| dialog |
	dialog := self new.
	dialog for: aMethodName.
	^dialog
!

methodNameFor: arguments 
	| dialog |
	dialog := self new.
	dialog arguments: arguments.
	^dialog
!

methodNameFor: arguments initial: aSelector
        | dialog |
        dialog := self new.
        dialog methodName: aSelector.
        dialog arguments: arguments copy. "/copy, otherwise dialog will modify the very same collection!!"
        ^dialog

    "Modified (comment): / 05-08-2013 / 15:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodNameDialog class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#moveArgDown
'Move the select argument down in the order-list'

#moveArgUp
'Move the select argument up in the order-list'

#newSelector
'New Selector'

#pattern
'New message pattern'

#argumentOrder
'Specifies the new argument order.\Rearrange by selecting an argument and pressing one of the up/down buttons'

#browseOldSenders
'Open a browser on the senders of the original message'

#browseNewSenders
'Open a browser on the senders of the new message'

#defaultValueForArgument
'For additional argument(s): the value to be passed from senders'

#doNotRewriteSenders
'Only rename methods - do NOT rewrite senders'

#onlyRewriteLocalSenders
'Only rewrite local senders (from within the class and subclasses)'

#onlyRewritePackageLocalSenders
'Only rewrite senders from within the classes package'

#renameSelectedMethodsOnly
'Only rename the selected methods, NOT all inplementations in the system'

)

    "Modified: / 13-02-2012 / 11:15:17 / cg"
! !

!MethodNameDialog class methodsFor:'interface specs'!

windowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        Smalltalk isSmalltalkX ifTrue:[
            ^ self windowSpecForSTX
        ].
        ^ self windowSpecForVW
!

windowSpecForSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MethodNameDialog andSelector:#windowSpecForSTX
     MethodNameDialog new openInterface:#windowSpecForSTX
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpecForSTX
        window: 
       (WindowSpec
          label: 'Method name'
          name: 'Method name'
          bounds: (Rectangle 0 0 341 532)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'VerticalPanel2'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              horizontalLayout: fitSpace
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'New Selector:'
                    name: 'Label1'
                    translateLabel: true
                    adjust: left
                    extent: (Point 335 18)
                  )
                 (InputFieldSpec
                    name: selector
                    activeHelpKey: newSelector
                    model: selector
                    callbacksSpec: 
                   (UIEventCallbackSubSpec
                      valueChangeSelector: changedSelector
                    )
                    type: symbol
                    immediateAccept: true
                    acceptOnLeave: true
                    acceptOnLostFocus: true
                    acceptOnPointerLeave: true
                    extent: (Point 335 25)
                  )
                 (ViewSpec
                    name: 'ArgOrderBox'
                    visibilityChannel: argOrderBoxVisible
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Argument Order (Select and Move):'
                          name: 'Label2'
                          layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                          translateLabel: true
                          adjust: left
                        )
                       (SequenceViewSpec
                          name: argumentList
                          layout: (LayoutFrame 0 0 30 0 -50 1 0 1)
                          activeHelpKey: argumentOrder
                          model: argumentList
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          useIndex: false
                        )
                       (ActionButtonSpec
                          label: upImage
                          name: up
                          layout: (LayoutFrame -34 1 36 0 -4 1 71 0)
                          isOpaque: true
                          activeHelpKey: moveArgUp
                          hasCharacterOrientedLabel: false
                          model: up
                        )
                       (ActionButtonSpec
                          label: downImage
                          name: down
                          layout: (LayoutFrame -34 1 71 0 -4 1 106 0)
                          isOpaque: true
                          activeHelpKey: moveArgDown
                          hasCharacterOrientedLabel: false
                          model: down
                        )
                       )
                     
                    )
                    extent: (Point 335 113)
                  )
                 (ViewSpec
                    name: 'ArgumentValueBox'
                    visibilityChannel: argValueBoxVisible
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Default Value for Parameter (will be used in sending methods):'
                          name: 'Label4'
                          layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                          translateLabel: true
                          adjust: left
                        )
                       (InputFieldSpec
                          name: 'EntryField1'
                          layout: (LayoutFrame 0 0 30 0 0 1 55 0)
                          activeHelpKey: defaultValueForArgument
                          model: defaultValueHolder
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnPointerLeave: true
                        )
                       )
                     
                    )
                    extent: (Point 335 113)
                  )
                 (LabelSpec
                    label: 'No method name'
                    name: methodPattern
                    activeHelpKey: pattern
                    level: -1
                    extent: (Point 335 25)
                  )
                 (VerticalPanelViewSpec
                    name: 'VerticalPanel1'
                    horizontalLayout: fitSpace
                    verticalLayout: top
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Only Rename Selected Method(s)'
                          name: 'RenameSelectedCheckBox'
                          activeHelpKey: renameSelectedMethodsOnly
                          visibilityChannel: renameSelectedMethodsOnlyVisible
                          model: renameSelectedMethodsOnlyFlagHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Rename Only (Do not Rewrite Senders)'
                          name: 'RenameOnlyCheckBox'
                          activeHelpKey: doNotRewriteSenders
                          visibilityChannel: renameOnlyVisible
                          model: renameOnlyFlagHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Only Rewrite Local Senders'
                          name: 'RewriteLocalCheckBox'
                          activeHelpKey: onlyRewriteLocalSenders
                          enableChannel: notRenameOnlyFlagHolder
                          model: shownRewriteLocalMethodsOnlyFlagHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Only Rewrite Senders in Package'
                          name: 'CheckBox4'
                          activeHelpKey: onlyRewritePackageLocalSenders
                          enableChannel: notRenameOnlyFlagHolder
                          model: shownRewritePackageLocalMethodsOnlyFlagHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Browse Senders of Original Message'
                          name: 'CheckBox1'
                          activeHelpKey: browseSenders
                          visibilityChannel: browseButtonsVisibleHolder
                          model: browseOldSendersHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Browse Senders of New Message'
                          name: 'CheckBox2'
                          activeHelpKey: browseSenders
                          visibilityChannel: browseButtonsVisibleHolder
                          model: browseNewSendersHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       (CheckBoxSpec
                          label: 'Browse Changed Methods after the Rewrite'
                          name: 'CheckBox3'
                          activeHelpKey: browseSenders
                          visibilityChannel: browseButtonsVisibleHolder
                          model: browseChangedMethodsHolder
                          translateLabel: true
                          extent: (Point 329 22)
                        )
                       )
                     
                    )
                    extent: (Point 335 155)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0.0 -30 1.0 0 1.0 0 1.0)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel All'
                    name: 'cancelAll'
                    visibilityChannel: cancelAllVisible
                    translateLabel: true
                    model: doCancelAll
                    extent: (Point 109 27)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: cancel
                    translateLabel: true
                    model: doCancel
                    extent: (Point 110 27)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: ok
                    translateLabel: true
                    model: doAccept
                    isDefault: true
                    defaultable: true
                    extent: (Point 110 27)
                  )
                 )
               
              )
              keepSpaceForOSXResizeHandleH: true
            )
           )
         
        )
      )
!

windowSpecForVW
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Method name' 
                        #bounds: #(#Rectangle 554 318 842 534 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 5 0 5 0 -5 1 30 0 ) 
                                        #name: #selector 
                                        #model: #selector 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedSelector ) 
                                        #type: #string ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#LayoutFrame 5 0 35 0 -55 1 145 0 ) 
                                        #name: #argumentList 
                                        #model: #argumentList ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -50 1 35 0 -5 1 75 0 ) 
                                        #name: #up 
                                        #isOpaque: true 
                                        #model: #up 
                                        #label: #upImage 
                                        #hasCharacterOrientedLabel: false ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -50 1 105 0 -5 1 145 0 ) 
                                        #name: #down 
                                        #isOpaque: true 
                                        #model: #down 
                                        #label: #downImage 
                                        #hasCharacterOrientedLabel: false ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#AlignmentOrigin 0 0.333333 180 0 0.5 0 ) 
                                        #name: #ok 
                                        #model: #accept 
                                        #label: 'OK' 
                                        #isDefault: true 
                                        #defaultable: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#AlignmentOrigin 0 0.666666 180 0 0.5 0 ) 
                                        #name: #cancel 
                                        #model: #cancel 
                                        #label: 'Cancel' 
                                        #defaultable: true ) 
                                #(#LabelSpec 
                                        #layout: #(#LayoutFrame 5 0 150 0 -5 1 175 0 ) 
                                        #name: #methodPattern 
                                        #label: 'No method name' ) ) ) )
! !

!MethodNameDialog methodsFor:'accessing'!

arguments
	^argumentList list
!

isRenameOnly
    ^ renameOnlyFlagHolder value ? true

    "Modified: / 13-02-2012 / 11:06:10 / cg"
!

isRenameSelectedMethodsOnly
    ^ renameSelectedMethodsOnlyFlagHolder value ? true

    "Modified: / 13-02-2012 / 11:06:01 / cg"
!

isRewritingLocalSendersOnly
    ^ rewriteLocalMethodsOnlyFlagHolder value ? false

    "Created: / 28-02-2007 / 21:16:43 / cg"
!

isRewritingPackageLocalSendersOnly
    ^ rewritePackageLocalMethodsOnlyFlagHolder value ? false

    "Created: / 28-02-2007 / 21:16:43 / cg"
!

methodName
	^self selector value asSymbol
!

methodPattern
        | stream methodName |

        methodName := self methodName.
        methodName numArgs > 0 ifFalse: [^ methodName allBold].

        stream := '' asText writeStream.
        methodName keywords 
            with: (self argumentList list)
            do: [:keyword :arg | 
                stream
                        bold;
                        nextPutAll: keyword;
                        normal;
                        "/ nextPut: $ ;
                        nextPutAll: arg;
                        nextPut: $ 
            ].
        ^ stream contents
! !

!MethodNameDialog methodsFor:'actions'!

doAccept
    LastRenameOnly := renameOnlyFlagHolder value.
    LastRenameSelectedMethodsOnly := renameSelectedMethodsOnlyFlagHolder value.
    LastBrowseOld := browseOldSendersHolder value.
    LastBrowseNew := browseNewSendersHolder value.
    LastBrowseChanged := browseChangedMethodsHolder value.

    ^ super doAccept

    "Modified: / 13-02-2012 / 14:13:17 / cg"
!

doAcceptByReturnKey
    selectorOk == true ifFalse:[self window beep. ^ self].
    ^ super doAcceptByReturnKey
!

doCancelAll
    AbortAllSignal raise
!

down
	| index |
	index := self argumentList selectionIndex.
	methodName moveArgument: (self argumentList list at: index + 1)
		before: self argumentList selection.
	self argumentList list swap: index with: index + 1.
	self argumentList selectionIndex: index + 1
!

up
	| index |
	index := self argumentList selectionIndex.
	methodName moveArgument: self argumentList selection
		before: (self argumentList list at: index - 1).
	self argumentList list swap: index with: index - 1.
	self argumentList selectionIndex: index - 1
! !

!MethodNameDialog methodsFor:'aspects'!

argOrderBoxVisible
    ^ true
!

argValueBoxVisible
    ^ false
!

argumentList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^argumentList isNil
		ifTrue:
			[argumentList := SelectionInList new]
		ifFalse:
			[argumentList]
!

browseButtonsVisibleHolder
    <resource: #uiAspect>

    browseButtonsVisibleHolder isNil ifTrue:[
        browseButtonsVisibleHolder := true asValue
    ].
    ^ browseButtonsVisibleHolder

    "Modified: / 13-02-2012 / 11:18:21 / cg"
    "Created: / 13-02-2012 / 13:01:18 / cg"
!

browseChangedMethodsHolder
    <resource: #uiAspect>

    browseChangedMethodsHolder isNil ifTrue:[
        browseChangedMethodsHolder := (LastBrowseChanged ? false) asValue
    ].
    ^ browseChangedMethodsHolder

    "Modified: / 13-02-2012 / 14:12:14 / cg"
!

browseNewSendersHolder
    <resource: #uiAspect>

    browseNewSendersHolder isNil ifTrue:[
        browseNewSendersHolder := (LastBrowseNew ? false) asValue
    ].
    ^ browseNewSendersHolder

    "Created: / 13-02-2012 / 13:12:31 / cg"
!

browseOldSendersHolder
    <resource: #uiAspect>

    browseOldSendersHolder isNil ifTrue:[
        browseOldSendersHolder := (LastBrowseOld ? false) asValue
    ].
    ^ browseOldSendersHolder

    "Created: / 13-02-2012 / 13:12:22 / cg"
!

cancelAllVisible
    <resource: #uiAspect>

    cancelAllVisible isNil ifTrue:[
        cancelAllVisible := false asValue
    ].
    ^ cancelAllVisible

    "Modified: / 13-02-2012 / 11:19:29 / cg"
!

notRenameOnlyFlagHolder
    <resource: #uiAspect>

    ^ BlockValue forLogicalNot:(self renameOnlyFlagHolder)

    "Created: / 25-02-2007 / 12:25:04 / cg"
!

renameOnlyFlagHolder
    <resource: #uiAspect>

    renameOnlyFlagHolder isNil ifTrue:[
        renameOnlyFlagHolder := (LastRenameOnly ? false) asValue
    ].
    ^ renameOnlyFlagHolder

    "Modified: / 13-02-2012 / 11:18:50 / cg"
!

renameOnlyVisible
    <resource: #uiAspect>

    renameOnlyVisible isNil ifTrue:[
        renameOnlyVisible := true "false" asValue
    ].
    ^ renameOnlyVisible

    "Modified: / 13-02-2012 / 11:18:47 / cg"
!

renameSelectedMethodsOnlyFlagHolder
    <resource: #uiAspect>

    renameSelectedMethodsOnlyFlagHolder isNil ifTrue:[
        renameSelectedMethodsOnlyFlagHolder := (LastRenameSelectedMethodsOnly ? false) asValue
    ].
    ^ renameSelectedMethodsOnlyFlagHolder

    "Modified: / 13-02-2012 / 11:18:44 / cg"
!

renameSelectedMethodsOnlyVisible
    <resource: #uiAspect>

    renameSelectedMethodsOnlyVisible isNil ifTrue:[
        renameSelectedMethodsOnlyVisible := true "false" asValue
    ].
    ^ renameSelectedMethodsOnlyVisible

    "Modified: / 13-02-2012 / 11:18:35 / cg"
!

rewriteLocalMethodsOnlyFlagHolder
    <resource: #uiAspect>

    rewriteLocalMethodsOnlyFlagHolder isNil ifTrue:[
        rewriteLocalMethodsOnlyFlagHolder := true asValue
    ].
    ^ rewriteLocalMethodsOnlyFlagHolder

    "Created: / 25-02-2007 / 12:21:59 / cg"
!

rewritePackageLocalMethodsOnlyFlagHolder
    <resource: #uiAspect>

    rewritePackageLocalMethodsOnlyFlagHolder isNil ifTrue:[
        rewritePackageLocalMethodsOnlyFlagHolder := false asValue
    ].
    ^ rewritePackageLocalMethodsOnlyFlagHolder

    "Created: / 25-02-2007 / 12:21:59 / cg"
!

selector
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^selector isNil
		ifTrue:
			[selector := '' asValue]
		ifFalse:
			[selector]
!

shownRewriteLocalMethodsOnlyFlagHolder
    |p|

    shownRewriteLocalMethodsOnlyFlagHolder isNil ifTrue:[
        p := PluggableAdaptor on:self rewriteLocalMethodsOnlyFlagHolder.
        p 
            getBlock:[:m | self renameOnlyFlagHolder value not and:[m value]] 
            putBlock:[:m :val | 
                                self renameOnlyFlagHolder value ifFalse:[
                                    self rewriteLocalMethodsOnlyFlagHolder value:val.    
                                    val ifTrue:[
                                        self shownRewritePackageLocalMethodsOnlyFlagHolder value:false
                                    ]
                                ].
                     ].
        self renameOnlyFlagHolder onChangeEvaluate:[p changed:#value].
        shownRewriteLocalMethodsOnlyFlagHolder := p.
    ].
    ^ shownRewriteLocalMethodsOnlyFlagHolder

    "Created: / 27-02-2007 / 11:16:01 / cg"
    "Modified: / 28-02-2007 / 21:15:18 / cg"
!

shownRewritePackageLocalMethodsOnlyFlagHolder
    |p|

    shownRewritePackageLocalMethodsOnlyFlagHolder isNil ifTrue:[
        p := PluggableAdaptor on:self rewritePackageLocalMethodsOnlyFlagHolder.
        p 
            getBlock:[:m | self renameOnlyFlagHolder value not and:[m value]] 
            putBlock:[:m :val | 
                                self renameOnlyFlagHolder value ifFalse:[
                                    self rewritePackageLocalMethodsOnlyFlagHolder value:val.
                                    val ifTrue:[
                                        self shownRewriteLocalMethodsOnlyFlagHolder value:false
                                    ]
                                ].
                     ].
        self renameOnlyFlagHolder onChangeEvaluate:[p changed:#value].
        shownRewritePackageLocalMethodsOnlyFlagHolder := p.
    ].
    ^ shownRewritePackageLocalMethodsOnlyFlagHolder
! !

!MethodNameDialog methodsFor:'changing'!

changedSelection
        | index |

        index := self argumentList selectionIndex.
        index > 1 ifTrue: [self enable: #up] ifFalse: [self disable: #up].
        index < self argumentList list size & (index > 0)
                ifTrue: [self enable: #down]
                ifFalse: [self disable: #down].
        self changedSelector
!

changedSelector
        self selector value size == 0 ifTrue:[
            self disableOk. self disable: #renameOnly. self printNoSelector
        ] ifFalse:[
            methodName selector: self methodName.
            methodName isValid 
                    ifTrue: 
                            [self enableOk. self enable: #renameOnly.
                            self printSelector]
                    ifFalse: 
                            [self disableOk.
                            self printNoSelector]
        ]
!

disableOk
    selectorOk := false.
    self disable: #ok.
!

enableOk
    selectorOk := true.
    self enable: #ok.
! !

!MethodNameDialog methodsFor:'initialize-release'!

arguments: aCollection
	self argumentList list: aCollection asList.
	methodName arguments: aCollection asOrderedCollection
!

for: aMethodName 
	self arguments: aMethodName arguments.
	aMethodName selector notNil 
		ifTrue: [self methodName: aMethodName selector].
	methodName := aMethodName
!

initialize
        super initialize.

        methodName := RBMethodName selector: #'' arguments: OrderedCollection new.
        self argumentList selectionIndexHolder 
            onChangeSend: #changedSelection to: self
!

methodName: aSelector
        self selector value: aSelector asSymbol.
        methodName notNil ifTrue:[
            methodName selector:aSelector
        ].
!

release
	super release.
	self argumentList selectionIndexHolder retractInterestsFor: self
! !

!MethodNameDialog methodsFor:'interface opening'!

postBuildWith: aBuilder 
        super postBuildWith: aBuilder.
        self changedSelection.
        (self componentAt: #selector) widget controller 
                continuousAccept: true
! !

!MethodNameDialog methodsFor:'private'!

methodLabel: aString
	| component |
	component := builder componentAt: #methodPattern.
	component notNil ifTrue: [component labelString: aString]
!

printNoSelector
	self methodLabel: ''
!

printSelector
        self methodLabel: self methodPattern
! !

!MethodNameDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/MethodNameDialog.st,v 1.31 2013-08-05 14:49:49 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/MethodNameDialog.st,v 1.31 2013-08-05 14:49:49 vrany Exp $'
!

version_SVN
    ^ '$Id: MethodNameDialog.st,v 1.31 2013-08-05 14:49:49 vrany Exp $'
! !

