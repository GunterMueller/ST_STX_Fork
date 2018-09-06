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

TextDiffTool subclass:#TextDiff3Tool
	instanceVariableNames:'labelMergedHolder textMergedHolder mergeHolder mergeDataHolder
		mergeIntervalHolder mergeView mergeService'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

CodeViewService subclass:#MergeService
	instanceVariableNames:'dataHolder data sectionIntervalHolder ignoreLinesModifiedFromTo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TextDiff3Tool
!

!TextDiff3Tool class methodsFor:'documentation'!

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
!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::TextDiff3Tool open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!TextDiff3Tool class methodsFor:'defaults - colors'!

colorA

    ^(Color red:54.1176470588235 green:75.2941176470588 blue:28.6274509803922) lighter

    "Created: / 19-03-2012 / 13:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorB

    ^(Color red:96.078431372549 green:73.7254901960784 blue:0.0) lighter

    "Created: / 19-03-2012 / 13:11:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorBase

    ^(Color red:5.88235294117647 green:58.8235294117647 blue:80.3921568627451) lighter

    "Created: / 19-03-2012 / 13:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorConflict

    ^Color red

    "Created: / 19-03-2012 / 13:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorMerged

    ^(Color red:83.921568627451 green:17.2549019607843 blue:85.0980392156863) lighter

    "Created: / 19-03-2012 / 13:11:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool class methodsFor:'interface specs'!

diff3Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff3Tool andSelector:#diff3Spec
     Tools::TextDiff3Tool new openInterface:#diff3Spec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: diff3Spec
        window: 
       (WindowSpec
          label: 'Text Diff Tool (for embedding)'
          name: 'Text Diff Tool (for embedding)'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: '3Labels'
              layout: (LayoutFrame 0 0 0 0 -16 1 30 0)
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'VersionC'
                    layout: (LayoutFrame 0 0 0 0 0 0.33333 30 0)
                    minorKey: versionCLabelSpec
                  )
                 (UISubSpecification
                    name: 'VersionA'
                    layout: (LayoutFrame 5 0.3333 0 0 0 0.67 30 0)
                    minorKey: versionALabelSpec
                  )
                 (UISubSpecification
                    name: 'VersionB'
                    layout: (LayoutFrame 5 0.67 0 0 0 1 30 0)
                    minorKey: versionBLabelSpec
                  )
                 )
               
              )
            )
           (ArbitraryComponentSpec
              name: 'Diff3TextView'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              autoHideScrollBars: false
              hasBorder: false
              component: diffView
              postBuildCallback: postBuildDiffView:
            )
           )
         
        )
      )
!

mergeSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff3Tool andSelector:#mergeSpec
     Tools::TextDiff3Tool new openInterface:#mergeSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: mergeSpec
        window: 
       (WindowSpec
          label: 'Merge view'
          name: 'Merge view'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'DiffAndMergePanel'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'Box1'
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: '3Labels'
                          layout: (LayoutFrame 0 0 0 0 -16 1 30 0)
                          component: 
                         (SpecCollection
                            collection: (
                             (UISubSpecification
                                name: 'VersionC'
                                layout: (LayoutFrame 0 0 0 0 0 0.33333 30 0)
                                minorKey: versionCLabelSpec
                              )
                             (UISubSpecification
                                name: 'VersionA'
                                layout: (LayoutFrame 5 0.3333 0 0 0 0.67 30 0)
                                minorKey: versionALabelSpec
                              )
                             (UISubSpecification
                                name: 'VersionB'
                                layout: (LayoutFrame 5 0.67 0 0 0 1 30 0)
                                minorKey: versionBLabelSpec
                              )
                             )
                           
                          )
                        )
                       (ArbitraryComponentSpec
                          name: 'Diff3TextView'
                          layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          autoHideScrollBars: false
                          hasBorder: false
                          component: diffView
                          postBuildCallback: postBuildDiffView:
                        )
                       )
                     
                    )
                  )
                 (TransparentBoxSpec
                    name: 'MergeView'
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'MergeLabel'
                          layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                          minorKey: versionMergedLabelSpec
                        )
                       (TextEditorSpec
                          name: 'MergeCode'
                          layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                          model: textMergedHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          hasKeyboardFocusInitially: false
                          viewClassName: 'Tools::CodeView2'
                          postBuildCallback: postBuildMergeView:
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           (MenuPanelSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              menu: toolbarMenuMerge
              textDefault: true
            )
           )
         
        )
      )

    "Modified: / 17-01-2013 / 20:32:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool class methodsFor:'interface specs - labels'!

versionMergedLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff3Tool andSelector:#versionMergedLabelSpec
     Tools::TextDiff3Tool new openInterface:#versionMergedLabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionMergedLabelSpec
        window: 
       (WindowSpec
          label: 'Merge'
          name: 'Merge'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 774 30)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionMerged24x24'
              name: 'VersionMergedIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Merge'
              name: 'VersionMergeLabel'
              layout: (LayoutFrame 30 0 5 0 157 0 0 1)
              translateLabel: true
              labelChannel: labelMergedHolder
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           )
         
        )
      )
! !

!TextDiff3Tool class methodsFor:'menu specs'!

toolbarMenuMerge
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::TextDiff3Tool andSelector:#toolbarMenuMerge
     (Menu new fromLiteralArrayEncoding:(Tools::TextDiff3Tool toolbarMenuMerge)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canMergeCurrentHolder
            label: 'Use Base for Current Delta'
            itemValue: doMergeCurrentUsingBase
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingBase24x24)
          )
         (MenuItem
            enabled: canMergeCurrentHolder
            label: 'Use A for Current '
            itemValue: doMergeCurrentUsingA
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingA24x24)
          )
         (MenuItem
            enabled: canMergeCurrentHolder
            label: 'Use B for Current '
            itemValue: doMergeCurrentUsingB
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingB24x24)
          )
         (MenuItem
            label: 'Use Base Everywhere'
            itemValue: doMergeAllUsingBase
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingBaseAll24x24)
          )
         (MenuItem
            label: 'Use A Everywhere'
            itemValue: doMergeAllUsingA
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingAAll24x24)
          )
         (MenuItem
            label: 'Use Be Everywhere '
            itemValue: doMergeAllUsingB
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingBAll24x24)
          )
         (MenuItem
            label: 'Auto Merge'
            itemValue: doMergeAllAuto
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeMerge24x24)
          )
         (MenuItem
            label: 'External Merge'
            itemValue: doMergeAllExternal
            isButton: true
            startGroup: right
            labelImage: (ResourceRetriever ToolbarIconLibrary mergeMergeExternal24x24)
          )
         )
        nil
        nil
      )

    "Modified: / 17-01-2013 / 22:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #codeAspectHolder
        #labelAHolder
        #labelBHolde
        #labelCHolder
        #labelHolder
        #languageHolder
        #mergeDataHolder
        #mergeHolder
        #textAHolder
        #textBHolder
        #textCHolder
      ).

! !

!TextDiff3Tool methodsFor:'accessing'!

beDiff3Tool

    self mergeHolder value: false

    "Created: / 17-03-2012 / 12:23:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beMergeTool

    self mergeHolder value: true

    "Created: / 17-03-2012 / 12:23:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeData

    ^self mergeDataHolder value

    "Created: / 20-03-2012 / 14:17:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'aspects'!

contentSpecHolder
    "return/create the 'contentSpecHolder' value holder (automatically generated)"

    contentSpecHolder isNil ifTrue:[
        contentSpecHolder := ValueHolder new.
        self mergeHolder value 
            ifTrue:[contentSpecHolder setValue: #mergeSpec]
            ifFalse:[contentSpecHolder setValue: #diff3Spec].
        contentSpecHolder addDependent:self.
    ].
    ^ contentSpecHolder

    "Created: / 17-01-2013 / 20:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffView
    diffView notNil  ifTrue:[
        self breakPoint: #jv.
    ].
    diffView := self initializeDiffView.
    ^diffView

    "Created: / 17-01-2013 / 20:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDataHolder
    "return/create the 'mergeDataHolder' value holder (automatically generated)"

    mergeDataHolder isNil ifTrue:[
        mergeDataHolder := ValueHolder new.
        mergeDataHolder addDependent:self.
    ].
    ^ mergeDataHolder
!

mergeDataHolder:something
    "set the 'mergeDataHolder' value holder (automatically generated)"

    |oldValue newValue|

    mergeDataHolder notNil ifTrue:[
        oldValue := mergeDataHolder value.
        mergeDataHolder removeDependent:self.
    ].
    mergeDataHolder := something.
    mergeDataHolder notNil ifTrue:[
        mergeDataHolder addDependent:self.
    ].
    newValue := mergeDataHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:mergeDataHolder.
    ].
!

mergeHolder
    "return/create the 'mergeHolder' value holder (automatically generated)"

    mergeHolder isNil ifTrue:[
        mergeHolder := ValueHolder with: false.
        mergeHolder addDependent:self.
    ].
    ^ mergeHolder

    "Modified: / 16-03-2012 / 13:24:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeHolder:something
    "set the 'mergeHolder' value holder (automatically generated)"

    |oldValue newValue|

    mergeHolder notNil ifTrue:[
        oldValue := mergeHolder value.
        mergeHolder removeDependent:self.
    ].
    mergeHolder := something.
    mergeHolder notNil ifTrue:[
        mergeHolder addDependent:self.
    ].
    newValue := mergeHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:mergeHolder.
    ].
!

mergeIntervalHolder
    "return/create the 'mergeIntervalHolder' value holder (automatically generated)"

    mergeIntervalHolder isNil ifTrue:[
        mergeIntervalHolder := ValueHolder new.
        mergeIntervalHolder addDependent:self.
    ].
    ^ mergeIntervalHolder
!

mergeIntervalHolder:something
    "set the 'mergeIntervalHolder' value holder (automatically generated)"

    |oldValue newValue|

    mergeIntervalHolder notNil ifTrue:[
        oldValue := mergeIntervalHolder value.
        mergeIntervalHolder removeDependent:self.
    ].
    mergeIntervalHolder := something.
    mergeIntervalHolder notNil ifTrue:[
        mergeIntervalHolder addDependent:self.
    ].
    newValue := mergeIntervalHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:mergeIntervalHolder.
    ].
! !

!TextDiff3Tool methodsFor:'aspects - queries'!

canMergeCurrentHolder
    ^self builder bindings at:#canMergeCurrentHolder ifAbsentPut:[
        BlockValue
            with:[:model|model value notNil]
            argument: self mergeIntervalHolder
    ]

    "Created: / 30-11-2012 / 13:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'aspects-versions'!

labelMergedHolder
    "return/create the 'labelMergedHolder' value holder (automatically generated)"

    labelMergedHolder isNil ifTrue:[
        labelMergedHolder := ValueHolder with:'Merge'.
    ].
    ^ labelMergedHolder

    "Modified: / 17-03-2012 / 12:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelMergedHolder:something
    "set the 'labelMergedHolder' value holder (automatically generated)"

    labelMergedHolder := something.
!

textMergedHolder
    "return/create the 'textMergedHolder' value holder (automatically generated)"

    textMergedHolder isNil ifTrue:[
        textMergedHolder := ValueHolder new.
    ].
    ^ textMergedHolder
!

textMergedHolder:something
    "set the 'textMergedHolder' value holder (automatically generated)"

    textMergedHolder := something.
! !

!TextDiff3Tool methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == mergeHolder ifTrue:[
        self updateViews.
        self updateMergeData.
        self updateCodeViewSynchronization.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 19-03-2012 / 14:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterAorBorCChanged

    (textAChanged & textBChanged & textCChanged) ifTrue:[
        textAChanged := textBChanged := textCChanged := false.
        self updateViews.
        self isMerge ifTrue:[
            self updateMergeData.
        ].
    ].

    "Created: / 16-03-2012 / 15:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCodeViewSynchronization

    diffView isNil ifTrue:[ ^ self ].
    mergeView isNil ifTrue:[ ^ self ].
    self isMerge ifTrue:[
"/        diffView synchronizeWith: mergeView. 
        diffView textViews do:[:e|
            mergeView synchronizeWith: e.
        ]
    ] ifFalse:[
"/        diffView unsynchronizeWith: mergeView.
        diffView textViews do:[:e|
            mergeView unsynchronizeWith: e.
        ]

    ]

    "Created: / 19-03-2012 / 14:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMergeData
    | data |

    (data := self mergeDataHolder value) isNil ifTrue:[
        data := TextMergeInfo new.
        data text1: self textC text2: self textA text3: self textB.
        self mergeDataHolder value: data.
    ].

    "Created: / 19-03-2012 / 11:52:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateViews

    self mergeHolder value ifTrue:[
        self contentSpecHolder value: #mergeSpec
    ] ifFalse:[
        self contentSpecHolder value: #diff3Spec
    ].

    diffView notNil ifTrue:[
        diffView
            text1: self textC
            text2: self textA
            text3: self textB.
    ]

    "Created: / 16-03-2012 / 13:24:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'hooks'!

commonPostBuild
    self updateViews

    "Created: / 16-03-2012 / 13:25:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildDiffView:aScrollableView
    |textA textB textC|

    super postBuildDiffView:aScrollableView.

    diffView := aScrollableView scrolledView.
    diffView notNil ifTrue:[
        textA := self textA.
        textB := self textB.
        textC := self textC.
        (textA notNil and:[textB notNil and:[textC notNil]]) ifTrue:[
            diffView scrolledView
                text1: textC
                text2: textA
                text3: textB

        ].
        self updateCodeViewSynchronization.
    ].

    "Created: / 16-03-2012 / 13:31:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 20:31:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildMergeView:aCodeView2

    mergeView := aCodeView2.
    self setupCodeView: aCodeView2.
    mergeView registerService: 
                ((mergeService := MergeService new)
                    dataHolder: self mergeDataHolder;
                    sectionIntervalHolder: self mergeIntervalHolder;
                    yourself).
    self updateCodeViewSynchronization.

    "Created: / 19-03-2012 / 11:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 13:47:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'initialization'!

initializeDiffView
    "superclass Tools::TextDiffTool says that I am responsible to implement this method"

    ^ Tools::Diff3CodeView2 new

    "Modified: / 16-01-2013 / 09:52:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'menu actions'!

doMergeAllAuto
    self mergeDataHolder value 
        text1:self textC
        text2:self textA
        text3:self textB.

    "Created: / 17-03-2012 / 12:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeAllExternal
    | left wc right merge |

    left := Filename newTemporary.
    left writingFileDo:[:s|s nextPutAll: self textC ? ''].

    wc := Filename newTemporary.
    wc writingFileDo:[:s|s nextPutAll: self textA ? ''].

    right := Filename newTemporary.
    right writingFileDo:[:s|s nextPutAll: self textB ? ''].

    merge := Filename newTemporary.

    [
        (OperatingSystem executeCommand:
                ('%1 %2 %3 %4 -o %5'
                    bindWith: 'kdiff3'
                        with: left pathName
                        with: wc pathName
                        with: right pathName
                        with: merge pathName)) ifTrue:[
            merge exists ifTrue:[
                self mergeData mergeUsing: merge contents asString
            ].
        ]
    ] ensure:[
        left remove.
        wc remove.
        right remove.
        merge exists ifTrue:[merge remove].
    ]

    "Modified: / 16-01-2013 / 10:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeAllUsingA
    self mergeData mergeUsingA: self textA

    "Created: / 30-11-2012 / 13:33:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeAllUsingB

    self mergeData mergeUsingB: self textB

    "Created: / 30-11-2012 / 13:33:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeAllUsingBase
    self mergeData mergeUsingBase: self textC

    "Created: / 30-11-2012 / 13:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeCurrentUsingA

    | interval |
    interval := mergeService sectionInterval.
    interval notNil ifTrue:[
        self mergeData mergeUsingA: self textA interval: interval
    ]

    "Created: / 30-11-2012 / 13:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeCurrentUsingB

    | interval |
    interval := mergeService sectionInterval.
    interval notNil ifTrue:[
        self mergeData mergeUsingB: self textB interval: interval
    ]

    "Created: / 30-11-2012 / 13:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMergeCurrentUsingBase

    | interval |
    interval := mergeService sectionInterval.
    interval notNil ifTrue:[
        self mergeData mergeUsingBase: self textC interval: interval
    ]

    "Created: / 30-11-2012 / 13:34:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool methodsFor:'testing'!

isDiff3
    ^true

    "Created: / 16-03-2012 / 15:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerge

    ^self mergeHolder value

    "Created: / 19-03-2012 / 11:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService class methodsFor:'accessing'!

label
    "Answers short label - for UI"

    ^'Merge Support Service'

    "Created: / 19-03-2012 / 11:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService class methodsFor:'queries'!

isUsefulFor:aCodeView
    "this filters useful services.
     must be redefined to return true in subclasses (but each class must do it only
     for itself - not for subclasses"

    ^ self == Tools::TextDiff3Tool::MergeService

    "Created: / 23-08-2013 / 10:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService class methodsFor:'testing'!

isAvailable

    ^false "/Should be installed explicitly"

    "Created: / 19-03-2012 / 11:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'accessing'!

infoAtLine: lineNr

    data isNil ifTrue:[ ^ nil ].
    ^(lineNr between: 1 and: data listInfos size) ifTrue:[
        data listInfos at: lineNr
    ] ifFalse:[
        nil
    ]

    "Created: / 19-03-2012 / 13:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-08-2013 / 11:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sectionInterval
    ^ sectionIntervalHolder value

    "Modified: / 30-11-2012 / 13:45:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sectionInterval: anObject
    ^ self sectionIntervalHolder value: anObject

    "Created: / 30-11-2012 / 13:45:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 11:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'aspects'!

dataHolder
    "return/create the 'dataHolder' value holder (automatically generated)"

    dataHolder isNil ifTrue:[
        dataHolder := ValueHolder new.
        dataHolder addDependent:self.
    ].
    ^ dataHolder
!

dataHolder:something
    "set the 'dataHolder' value holder (automatically generated)"

    |oldValue newValue|

    dataHolder notNil ifTrue:[
        oldValue := dataHolder value.
        dataHolder removeDependent:self.
    ].
    dataHolder := something.
    dataHolder notNil ifTrue:[
        dataHolder addDependent:self.
    ].
    newValue := dataHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:dataHolder.
    ].
!

sectionIntervalHolder
    "return/create the 'sectionIntervalHolder' value holder (automatically generated)"

    sectionIntervalHolder isNil ifTrue:[
        sectionIntervalHolder := ValueHolder new.
        sectionIntervalHolder addDependent:self.
    ].
    ^ sectionIntervalHolder
!

sectionIntervalHolder:something
    "set the 'sectionIntervalHolder' value holder (automatically generated)"

    |oldValue newValue|

    sectionIntervalHolder notNil ifTrue:[
        oldValue := sectionIntervalHolder value.
        sectionIntervalHolder removeDependent:self.
    ].
    sectionIntervalHolder := something.
    sectionIntervalHolder notNil ifTrue:[
        sectionIntervalHolder addDependent:self.
    ].
    newValue := sectionIntervalHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:sectionIntervalHolder.
    ].
! !

!TextDiff3Tool::MergeService methodsFor:'change & update'!

dataChanged
    "Merge data has changes, update text view"
    | changed |

    textView isNil ifTrue:[ 
        ^ self  "/not yet registered
    ]. 
    data isNil ifTrue:[
        textView list: StringCollection new.
        ^self.
    ].

    "/Collect conflicted lines"
    changed := data listInfos 
                select:[:info|info isConflict]
                thenCollect:[:info|info line].
    [ 
        ignoreLinesModifiedFromTo := true.    
        textView changedLines: changed.
        textView diffMode: true.
        textView list: data list.
    ] ensure:[ 
        ignoreLinesModifiedFromTo := false.
    ].
    textView invalidate.
    gutterView invalidate.

    "Created: / 19-03-2012 / 12:41:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2015 / 13:16:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dataHolderChanged

    data notNil ifTrue:[
        data removeDependent: self.
    ].
    data := dataHolder value.
    data notNil ifTrue:[
        data addDependent: self.
    ].
    self sectionInterval: nil.
    self dataChanged

    "Created: / 19-03-2012 / 11:56:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 13:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == dataHolder ifTrue:[
         self dataHolderChanged.
         ^ self.
    ].
    changedObject == data ifTrue:[
         self dataChanged.
         ^ self.
    ].

    changedObject == sectionIntervalHolder ifTrue:[
        gutterView invalidate.
        ^self
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 30-11-2012 / 13:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelection: lineNr
    "For given number, update sectionInterval"

    | conflict |
    lineNr notNil ifTrue:[
        conflict := (self infoAtLine: lineNr) conflict.
    ].
    lineNr isNil"conflict isNil" ifTrue:[
        self sectionInterval: nil
    ] ifFalse:[
        | start stop i |
        i := lineNr - 1.
        [ i > 0 and:[ (self infoAtLine: i) conflict == conflict ]] 
            whileTrue:[ i := i - 1 ].
        start := i + 1.
        i := lineNr + 1.
        [ i < (data listInfos size)  and:[ (self infoAtLine: i) conflict == conflict ]] 
            whileTrue:[ i := i + 1 ].
        stop := i - 1.
        self sectionInterval: (start to: stop).
    ].
    gutterView invalidate.

    "Created: / 03-04-2012 / 19:29:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 13:45:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'drawing'!

drawLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:aFont
    from:startCol to:endColOrNil with:fg and:bg 
    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    | info color sectionInterval |

    sectionInterval := self sectionInterval.
    view == gutterView ifFalse:[ ^ self ].
    
    info := self infoAtLine: lineNo.
    info notNil ifTrue:[ 
        color := info color.
        color notNil ifTrue:[
            view fillRectangleX:x y:yBaseline - hFont 
                 width:8 
                 height:hFont + textView lineSpacing + 5"Magic constant to make it look nicer"
                 color:color.
        ].
    ].

    (sectionInterval notNil and:[sectionInterval includes: lineNo]) ifTrue:[
        "Drawing outside annotation area is not nice, but..."
        view fillRectangleX:view width - 7 y:yBaseline - hFont 
             width:4 
             height:hFont + textView lineSpacing + 5"Magic constant to make it look nicer"
             color:(Color gray).
    ]

    "Created: / 19-03-2012 / 13:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 13:46:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'event handling'!

buttonPress: button x:x y:y in: view

    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    |lineNr|

    view == gutterView ifFalse:[ ^ false ].
    button == 1 ifFalse:[ ^ false ].

    self updateSelection: (textView yVisibleToLineNr:y).


    ^false

    "Created: / 03-04-2012 / 19:23:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesModifiedFrom: start to: end

    ignoreLinesModifiedFromTo ifTrue:[ ^ self ].
    start to: end do:[:i|
        (data listInfos at:i) resolution: #Merged.
    ].
    gutterView invalidate.

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 20-03-2012 / 22:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2015 / 12:36:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."
    super initialize.
    ignoreLinesModifiedFromTo := false.

    "Created: / 16-11-2015 / 12:36:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool::MergeService methodsFor:'registering'!

registerIn: aCodeView

    "Installs myself in aCodeView"

    super registerIn: aCodeView.
    self dataChanged.

    "Modified: / 17-06-2011 / 13:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 12:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff3Tool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

