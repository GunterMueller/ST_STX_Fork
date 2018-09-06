"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#InlineMessageDialog
	instanceVariableNames:'messageHolder progressHolder backgroundColorHolder
		backgroundColorOrDefaultHolder progressView panelView
		panelViewComponents specHolder panelShownHolder panelHiddenHolder
		worker layout changeLayoutUponShowHide
		progressIndicatorForegroundHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!InlineMessageDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    A simple info/warning dialog to embed into application window -
    much like information panel in Firefox or other applications.
    Use it when a modal dialog might be too disturbing.


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
    Tools::InlineMessageDialog new
        open;
        message: 'Hello World';
        show: #messageInfoSpec.


                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!InlineMessageDialog class methodsFor:'accessing-colors'!

defaultInformationBackground
    ^ (Color red:100.0 green:78 blue:23)

    "Created: / 10-04-2012 / 19:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultWarningBackground

    ^(Color red:76 green:43 blue:43)

    "Created: / 10-04-2012 / 19:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog class methodsFor:'interface specs'!

messageInfoSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::InlineMessageDialog andSelector:#messageInfoSpec
     Tools::InlineMessageDialog new openInterface:#messageInfoSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: messageInfoSpec
        window: 
       (WindowSpec
          label: 'MessageInfo'
          name: 'MessageInfo'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 40)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Label'
              name: 'Message'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              backgroundChannel: backgroundColorOrDefaultHolder
              translateLabel: true
              labelChannel: messageHolder
              adjust: left
            )
           )
         
        )
      )
!

progressInfoSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::InlineMessageDialog andSelector:#progressInfoSpec
     Tools::InlineMessageDialog new openInterface:#progressInfoSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: progressInfoSpec
       window: 
      (WindowSpec
         label: 'ProgressInfo'
         name: 'ProgressInfo'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 800 40)
         forceRecursiveBackgroundOfDefaultBackground: true
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             level: 0
             backgroundChannel: backgroundColorOrDefaultHolder
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Label'
                   name: 'Message'
                   layout: (LayoutFrame 0 0 0 0 -20 1 20 0)
                   backgroundChannel: backgroundColorOrDefaultHolder
                   translateLabel: true
                   labelChannel: messageHolder
                   adjust: left
                 )
                (ProgressIndicatorSpec
                   name: 'ProgressIndicator'
                   layout: (LayoutFrame 0 0 -20 1 -20 1 -3 1)
                   level: 0
                   backgroundChannel: backgroundColorOrDefaultHolder
                   foregroundChannel: progressIndicatorForegroundHolder
                   model: progressHolder
                   postBuildCallback: postBuildProgressView:
                 )
                )
              
             )
           )
          )
        
       )
     )
!

warningInfoSpec

     <resource: #canvas>

    ^self messageInfoSpec

    "Modified: / 10-04-2012 / 19:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::InlineMessageDialog andSelector:#windowSpec
     Tools::InlineMessageDialog new openInterface:#windowSpec
     Tools::InlineMessageDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Tools::InlineMessageDialog'
          name: 'Tools::InlineMessageDialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 40)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'Layout'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              backgroundChannel: backgroundColorOrDefaultHolder
              component: 
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'ComponentPanel'
                    layout: (LayoutFrame 12 0 0 0 -10 1 0 1)
                    backgroundChannel: backgroundColorOrDefaultHolder
                    horizontalLayout: rightSpaceFit
                    verticalLayout: fit
                    horizontalSpace: 0
                    verticalSpace: 3
                    elementsChangeSize: true
                    component: 
                   (SpecCollection
                      collection: (
                       (SubCanvasSpec
                          name: 'InfoSpec'
                          level: 0
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          miniScrollerHorizontal: false
                          specHolder: specHolder
                          createNewBuilder: false
                          usePreferredHeight: true
                          useDynamicPreferredWidth: true
                          useDynamicPreferredHeight: true
                          useDefaultExtent: true
                          usePreferredWidth: true
                        )
                       )
                     
                    )
                    postBuildCallback: postBuildPanelView:
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!InlineMessageDialog methodsFor:'accessing'!

backgroundColor: aColor
    "Sets the background color, but only iff backgroundColorHolder is
     not set"

    backgroundColorHolder isNil ifTrue:[
        self backgroundColorOrDefaultHolder value: aColor.
        self progressIndicatorForegroundHolder value:(aColor darkened).
    ]

    "Created: / 10-04-2012 / 19:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttons
    panelView isNil ifTrue:[ ^ #() ].
    ^ OrderedCollection streamContents:[ :s |
        panelView allSubViewsDo:[:v |
            (v class == Button or:[ v class == LinkButton ]) ifTrue:[ 
                s nextPut: v
            ].
        ]
    ]

    "Created: / 03-03-2015 / 10:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message
    ^ self messageHolder value

    "Created: / 03-03-2015 / 10:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message: aString

    self messageHolder value: aString

    "Created: / 28-10-2010 / 18:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

progress: aNumberOrNil

    aNumberOrNil isNumber ifTrue:[
        progressView notNil ifTrue:[
            progressView showBusyIndication: false.
        ].
        self progressHolder value: aNumberOrNil
    ] ifFalse:[
        progressView notNil ifTrue:[
            progressView showBusyIndication: true.
        ]

    ]

    "Created: / 28-10-2010 / 18:24:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'accessing-presentation'!

changeLayoutUponShowHide: aBoolean
    "If set to false, no changes to compokent layout is done
     when panel is shown/hidden. This effectively means, that
     that panel is shown over the normal content. 

     Default value is true (i.e., relayout components)"

     changeLayoutUponShowHide := aBoolean

    "Modified (comment): / 17-05-2012 / 13:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'actions'!

doAbort

    worker isNil ifTrue:[ self hide. ^ self ].
    worker interruptWith:[
        NoHandlerError handle:[:ex |
            ex exception creator == AbortOperationRequest ifTrue:[
                ex return.
            ].
            ex reject.
        ] do:[
            AbortOperationRequest raise.
        ].
    ].
    (worker notNil and:[worker isDead not]) ifTrue:[
        worker terminate.
        "/ raise its prio to make it terminate quickly
        worker priority:(Processor userSchedulingPriority + 1).
        worker := nil.
    ].

    "Modified: / 11-04-2012 / 16:24:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAbortIfWorking
    worker notNil ifTrue:[ self doAbort ].

    "Created: / 04-10-2012 / 19:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOK
    <resource: #uiCallback>

    (worker notNil and:[worker isDead not]) ifTrue:[
        worker terminate.
        "/ raise its prio to make it terminate quickly
        worker priority:(Processor userSchedulingPriority + 1).
        worker := nil.
    ].
    self hide.

    "Modified: / 31-03-2013 / 18:02:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'adding & removing components'!

addButton: aButton
    | layoutView |

    aButton preferredExtent: ((aButton width + 20) max: 70"px") @ 24.
    layoutView := View new.
    layoutView backgroundChannel: self backgroundColorOrDefaultHolder.
    layoutView addComponent: aButton.
    aButton layout:
        ( LayoutFrame fractions:(0 @ 0.5 corner:1.0 @ 0.5) offsets:(3 @ -12 corner:-3 @ 12) ).
    layoutView preferredExtent: (aButton preferredExtent x + 12) @ 24.

    ^self addComponent: layoutView

    "Created: / 10-04-2012 / 20:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonAbort

    ^self addButtonWithLabel: (self resources string:'Abort') action: [ self doAbort ]

    "Created: / 10-04-2012 / 21:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonOK

    ^self addButtonWithLabel: (self resources string:'OK') action: [ self doOK ]

    "Created: / 10-04-2012 / 21:44:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtonWithLabel: label action: action
    ^self addButton: (Button label: label action: action)

    "Created: / 10-04-2012 / 20:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent: aView
    panelView isNil ifTrue:[
        panelViewComponents isNil ifTrue:[
            panelViewComponents := OrderedCollection new
        ].
        panelViewComponents add: aView
    ] ifFalse:[
        panelView addSubView: aView.
        aView isVisible: true.
    ].
    ^aView.

    "Created: / 10-04-2012 / 20:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beInformation

    self backgroundColor: self class defaultInformationBackground.
    self specHolder value: #messageInfoSpec

    "Created: / 11-04-2012 / 11:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beProgress
    |colorOrNil|

    "/ never, ever use explicit colors. 
    "/ If at all, ask the stylesheet and add it to your personal one.
    "/ (Don't expect otherss to also like your color preferences)
"/    colorOrNil := self class defaultInformationBackground.

     colorOrNil := View styleSheet colorAt:'inlineMessageDialog.information.backgroundColor' default:View defaultBackgroundColor.
    self backgroundColor: colorOrNil.
    self specHolder value: #progressInfoSpec

    "Created: / 11-04-2012 / 11:41:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beWarning
    |colorOrNil|

    "/ never, ever use explicit colors. 
    "/ If at all, ask the stylesheet and add it to your personal one.
    "/ (Don't expect others to also like your color preferences)

    "/ colorOrNil := self class defaultWarningBackground.
    colorOrNil := View styleSheet colorAt:'inlineMessageDialog.warning.backgroundColor' default:(self class defaultWarningBackground).
    self backgroundColor: colorOrNil.
    self specHolder value: #messageInfoSpec

    "Created: / 11-04-2012 / 11:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeComponent: aView
    panelView notNil ifTrue:[
        panelView removeComponent: aView.
    ].
    panelViewComponents notNil ifTrue:[
        panelViewComponents remove: aView ifAbsent:[].
    ]

    "Created: / 11-04-2012 / 00:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeComponents
    "Removes all components except subcanvas"
    panelViewComponents := nil.
    panelView notNil ifTrue:[
        panelView subViews allButFirst do:[:component|
             component destroy
        ]

    ].

    "Created: / 11-04-2012 / 00:51:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'aspects'!

backgroundColorHolder
    "return/create the 'backgroundColorHolder' value holder (automatically generated)"

    backgroundColorHolder isNil ifTrue:[
        backgroundColorHolder := ValueHolder new.
    ].
    ^ backgroundColorHolder
!

backgroundColorHolder:something
    "set the 'backgroundColorHolder' value holder (automatically generated)"

    |oldValue newValue|

    backgroundColorHolder notNil ifTrue:[
        oldValue := backgroundColorHolder value.
        backgroundColorHolder removeDependent:self.
    ].
    backgroundColorHolder := something.
    backgroundColorHolder notNil ifTrue:[
        backgroundColorHolder addDependent:self.
    ].
    newValue := backgroundColorHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:backgroundColorHolder.
    ].
!

backgroundColorOrDefaultHolder
    "return/create the 'backgroundColorOrDefaultHolder' value holder (automatically generated)"

    backgroundColorOrDefaultHolder isNil ifTrue:[
        backgroundColorOrDefaultHolder := ValueHolder new.
        backgroundColorOrDefaultHolder addDependent:self.
    ].
    ^ backgroundColorOrDefaultHolder
!

messageHolder
    <resource: #uiAspect>

    messageHolder isNil ifTrue:[
        messageHolder := ValueHolder new.
    ].
    ^ messageHolder.

    "Modified (comment): / 15-05-2012 / 11:08:35 / cg"
!

panelHiddenHolder
    "return/create the 'panelHiddenHolder' value holder (automatically generated)"

    panelHiddenHolder isNil ifTrue:[
        panelHiddenHolder := ValueHolder new.
    ].
    ^ panelHiddenHolder
!

panelHiddenHolder:aValueModel
    "set the 'panelHiddenHolder' value holder (automatically generated)"

    panelHiddenHolder := aValueModel.
!

panelShownHolder
    "return/create the 'panelShownHolder' value holder (automatically generated)"

    panelShownHolder isNil ifTrue:[
        panelShownHolder := ValueHolder new.
    ].
    ^ panelShownHolder
!

panelShownHolder:aValueModel
    "set the 'panelShownHolder' value holder (automatically generated)"

    panelShownHolder := aValueModel.
!

progressHolder
    "automatically generated by UIPainter ..."

    <resource: #uiAspect>

    progressHolder isNil ifTrue:[
        progressHolder := ValueHolder new.
    ].
    ^ progressHolder.
!

progressIndicatorForegroundHolder
    progressIndicatorForegroundHolder isNil ifTrue:[
        progressIndicatorForegroundHolder := ValueHolder new.
    ].
    ^ progressIndicatorForegroundHolder
!

specHolder
    "return/create the 'specHolder' value holder (automatically generated)"

    specHolder isNil ifTrue:[
        specHolder := ValueHolder with: #messageInfoSpec.
    ].
    ^ specHolder

    "Modified: / 28-10-2010 / 18:29:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'change & update'!

update:aspect with:parameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == backgroundColorHolder ifTrue:[
         self backgroundColorOrDefaultHolder value: backgroundColorHolder value.
         ^ self.
    ].
    super update:aspect with:parameter from:changedObject

    "Modified: / 10-04-2012 / 19:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'hooks'!

commonPostBuild
    panelViewComponents notEmptyOrNil ifTrue:[
        panelViewComponents do:[:each| panelView addSubView: each].
        panelViewComponents := nil.
"/        "/Correction view, dunno why the layout is bad without it...
"/        correctionView :=  View new.
"/        correctionView extent: (panelView subViews size * 3)@24.
"/        correctionView backgroundChannel: self backgroundColorOrDefaultHolder.
"/        panelView addComponent:  correctionView
    ]

    "Created: / 10-04-2012 / 21:02:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildPanelView: aPanelView
    panelView := aPanelView.

    "Created: / 10-04-2012 / 20:47:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildProgressView: aProgressIndicator
    progressView := aProgressIndicator

    "Created: / 10-02-2012 / 10:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'private'!

getMyView

    | v |

    builder isNil ifTrue:[ ^ nil ].
    v := builder window.
    ^(v superView isKindOf: SubCanvas)
        ifTrue:[v superView]
        ifFalse:[v]

    "Created: / 29-10-2010 / 11:49:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getOtherView

    | myView |

    myView := self getMyView.
    ^ (myView isNil or:[myView superView isNil]) ifTrue:[
        nil.    
    ] ifFalse: [
        myView superView subViews after: myView
    ].

    "Created: / 29-10-2010 / 11:49:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hide

    | myView otherView |
    builder isNil ifTrue:[ ^ self ].
    myView := self  getMyView.
    otherView := self getOtherView.

    myView isVisible ifFalse:[ "/already hidden"
        self reset.
        ^self 
    ].
    myView isVisible: false.
    panelShownHolder notNil ifTrue:[
        panelShownHolder value: false
    ].
    panelHiddenHolder notNil ifTrue:[
        panelHiddenHolder value: true
    ].
    changeLayoutUponShowHide ~~ false ifTrue:[
        otherView layout: layout.
    ].

    self reset.

    "Created: / 29-10-2010 / 11:55:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-01-2013 / 23:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

show

    | myView otherView |
    myView := self getMyView.
    otherView := self getOtherView.
    (myView isNil or:[myView isVisible]) ifTrue:[
        ^self.
    ].
    myView isVisible: true.
    panelShownHolder notNil ifTrue:[
        panelShownHolder value: true
    ].
    panelHiddenHolder notNil ifTrue:[
        panelHiddenHolder value: false
    ].

    changeLayoutUponShowHide ~~ false ifTrue:[
        otherView notNil ifTrue:[
            layout := otherView layout copy.
            otherView  layout: 
                (layout copy topOffset: layout topOffset + 40; yourself).
        ].
    ].

    "Created: / 11-04-2012 / 11:43:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

show: spec
    <resource: #obsolete>

    self obsoleteMethodWarning.
    self breakPoint: #jv.

    spec == #warningInfoSpec ifTrue:[ self beWarning ].
    spec == #messageInfoSpec ifTrue:[ self beInformation ].
    spec == #progressInfoSpec ifTrue:[ self beProgress ].
    self show.

    "Created: / 29-10-2010 / 11:48:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'testing'!

isMessageOrWarning
    ^ self specHolder value == #messageInfoSpec.

    "Created: / 20-06-2014 / 11:25:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isProgress
    ^ self specHolder value == #progressInfoSpec.

    "Created: / 20-06-2014 / 11:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVisible
    | myView |

    myView := self getMyView.
    ^ myView notNil and:[ myView isVisible ]

    "Created: / 20-06-2014 / 11:26:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2014 / 11:13:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'utilities'!

reset
    "Resets the dialog to initial state, removes all
     user supplied components."

    self removeComponents.

    "Created: / 11-04-2012 / 00:51:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMessage: aString
    "Shows given message and OK button (which closes the dialog
     when clicked"

    self showMessage: aString closeAfter: nil

    "Created: / 11-04-2012 / 13:11:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMessage: aString closeAfter: aTimeDurationOrIntegerOrNil
    "Shows given message and OK button (which closes the dialog
     when clicked). The dialog closes automaticaly after 
     aTimeDurationOrIntegerOrNil (integer value means secons, nil
     means do not close automatically)"


    self reset.
    self beInformation.
    self message: aString.
    self addButtonOK.
    self show.
    aTimeDurationOrIntegerOrNil notNil ifTrue:[
        worker := 
            [                                      
                aTimeDurationOrIntegerOrNil isInteger ifTrue:[
                    Delay waitForSeconds: aTimeDurationOrIntegerOrNil.
                ] ifFalse:[
                    Delay waitForMilliseconds: aTimeDurationOrIntegerOrNil milliseconds
                ].
                self hide.
            ] newProcess.
        worker addExitAction:[ worker := nil ].
        worker resume.
    ].

    "Created: / 11-04-2012 / 13:13:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showProgressLabeled: aString while: aBlock
    "During an execution of aBlock, show a label with given
     string, a progressbar showing the progress and an 'Abort' button.

     If the block raises a ProgressNotification, then the percentage
     progress is updated accordingly. If it raises an ActivityNotification,
     then the label is updated and progress bar is changed to be an
     activity notificator.

     When an 'Abort' button is pressed, the block is interrupted by AbortOperationRequest.

     When aBlock terminates (either normally or abruptly, the inline-dialog is closed).
    "

    worker := [
        self reset.
        self beProgress.
        self message: aString.
        self addButtonAbort.
        self progress: nil.
        self show.
        [
            aBlock value.    
        ] on: ProgressNotification , ActivityNotification do:[:ex|
            |status color|
            
            ex creator == ProgressNotification ifTrue:[
                status := ex statusInfo.
                status notNil ifTrue:[
                    status == #error ifTrue:[
                        color := Color red.
                    ] ifFalse:[
                        status == #warning ifTrue:[
                            color := Color orange.
                        ] ifFalse:[
                            color := Color yellow.
                        ].    
                    ].    
                    self progressIndicatorForegroundHolder value:color.
                ].    
            ].    
            self progress: ex parameter.
            ex messageText notNil ifTrue:[
                self message: ex messageText.    
            ].
            ex proceed.
        ].
    ] newProcess.
    worker addExitAction:[
        "This check is required, since somebody may want to show
         info/warning from within the action block"
        self specHolder value == #progressInfoSpec ifTrue:[
            self hide.
        ].
        worker := nil.
    ].
    worker resume.

    "Created: / 11-04-2012 / 13:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog methodsFor:'utilities-obsolete'!

information: message 

    self information: message timeout: nil

    "Created: / 11-02-2012 / 23:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

information: message timeout: timeoutOrNil

    self reset.
    self beInformation.
    self message: message.
    self addButtonOK.
    self show.
    timeoutOrNil isInteger ifTrue:[
        [
            Delay waitForSeconds: timeoutOrNil.
            self hide.
        ] fork.
    ]

    "Created: / 11-02-2012 / 23:14:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

progress: label while: block

    worker := [
        self reset.
        self beProgress.
        self message: label.
        self addButtonAbort.
        self progress: nil.
        self show.
        [
            block value.    
        ] on: ProgressNotification , ActivityNotification do:[:ex|
            self progress: ex parameter.
            ex messageText notNil ifTrue:[
                self message: ex messageText.    
            ].
            ex proceed.
        ].
    ] newProcess.
    worker addExitAction:[
        self specHolder value == #progressInfoSpec ifTrue:[
            self hide.
        ].
        worker := nil.
    ].
    worker resume.

    "Created: / 10-02-2012 / 10:34:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: message action: block labeled: label

    self reset.
    self beWarning.
    self message: message.
    self addButtonWithLabel: label action: block.
    self addButtonOK.
    self show

    "Created: / 13-02-2012 / 16:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InlineMessageDialog class methodsFor:'documentation'!

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

