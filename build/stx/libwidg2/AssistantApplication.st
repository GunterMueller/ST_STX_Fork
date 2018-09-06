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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ToolApplicationModel subclass:#AssistantApplication
	instanceVariableNames:'currentPageSpecHolder backButtonEnabled forwardButtonEnabled
		backButtonVisible forwardButtonVisible finishButtonVisible
		finishButtonEnabled currentPageInfoHTMLHolder
		currentPageIndexHolder backButtonLabelHolder
		nextButtonLabelHolder pageLabelsInList pageInfoHolder infoHolder
		cancelButtonVisible'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!AssistantApplication class methodsFor:'documentation'!

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
    an easy to use framework for assistant-dialog applications.
    These are multipage applications, in which the user is able to navigate
    along achain of pages as specified in the AssistantSpec

    see stx:doc/coding:DemoAssistant for a demo example.
    see ProjectBuilderAssistantApplication for a concrete example.

    caveat: should have called this WizardApplication

    [author:]
        Claus Gittinger
"
! !

!AssistantApplication class methodsFor:'defaults'!

windowLabelTemplate
    ^ 'Assistent: %1'
! !

!AssistantApplication class methodsFor:'help'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#backButton
'Navigate to the previous page %(previousPageInfo)'

#nextButton
'Navigate to the next page %(nextPageInfo)'

)
! !

!AssistantApplication class methodsFor:'image specs'!

bulletIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bulletIcon inspect
     ImageEditor openOnClass:self andSelector:#bulletIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AssistantApplication class bulletIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@% @@BPA @@P@D@@ @@ @D@@D@A@@A@@ @@ @A@@P@@$@X@@@% @@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 84 84 84 170 170 170 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@<@O<@?0G? _>A?8G? O<@?0@<@@@@@@@@@b') ; yourself); yourself]
!

leftArrowIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self leftArrowIcon inspect
     ImageEditor openOnClass:self andSelector:#leftArrowIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AssistantApplication class leftArrowIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@G@@@@G??<@A???@@G@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 84 84 84 170 170 170 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@A@@L@A0@O@A?>O?9??''?>O?8_? <@A0@C@@D@@@@b') ; yourself); yourself]
!

rightArrowIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self rightArrowIcon inspect
     ImageEditor openOnClass:self andSelector:#rightArrowIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AssistantApplication class rightArrowIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@M@@O??4@C??=@@@@M@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 84 84 84 170 170 170 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@ @C@@N@@<G?8_?1??''?>_?1?>@C0@N@@0@B@@@@b') ; yourself); yourself]
! !

!AssistantApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AssistantApplication andSelector:#windowSpec
     AssistantApplication new openInterface:#windowSpec
     AssistantApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Assistant'
         name: 'Assistant'
         bounds: (Rectangle 0 0 806 608)
         menu: mainMenu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
             component: 
            (SpecCollection
               collection: (
                (VariableHorizontalPanelSpec
                   name: 'MainHorizontalPanel'
                   layout: (LayoutFrame 0 0 0 0 0 1 -40 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'Box2'
                         component: 
                        (SpecCollection
                           collection: (
                            (VariableVerticalPanelSpec
                               name: 'VariableVerticalPanel1'
                               layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                               component: 
                              (SpecCollection
                                 collection: (
                                  (SequenceViewSpec
                                     name: 'PagesLabelList'
                                     level: 0
                                     enableChannel: false
                                     hasHorizontalScrollBar: true
                                     hasVerticalScrollBar: true
                                     miniScrollerHorizontal: true
                                     useIndex: true
                                     sequenceList: pageLabelsInList
                                   )
                                  (HTMLViewSpec
                                     name: 'HTMLBrowser1'
                                     level: 0
                                     hasHorizontalScrollBar: true
                                     hasVerticalScrollBar: true
                                     miniScrollerHorizontal: true
                                     miniScrollerVertical: false
                                     htmlText: pageInfoHolder
                                   )
                                  )
                                
                               )
                               handles: (Any 0.5 1.0)
                             )
                            )
                          
                         )
                       )
                      (SubCanvasSpec
                         name: 'SubCanvas1'
                         hasHorizontalScrollBar: false
                         hasVerticalScrollBar: false
                         miniScrollerHorizontal: false
                         miniScrollerVertical: false
                         specHolder: currentPageSpecHolder
                         createNewBuilder: false
                       )
                      )
                    
                   )
                   handles: (Any 0.5 1.0)
                 )
                (HorizontalPanelViewSpec
                   name: 'TwoPanelsPanel'
                   layout: (LayoutFrame 0 0 -40 1 0 1 0 1)
                   horizontalLayout: fit
                   verticalLayout: fit
                   horizontalSpace: 3
                   verticalSpace: 3
                   reverseOrderIfOKAtLeft: true
                   component: 
                  (SpecCollection
                     collection: (
                      (HorizontalPanelViewSpec
                         name: 'ButtonPanel2'
                         horizontalLayout: rightSpaceMax
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         ignoreInvisibleComponents: false
                         reverseOrderIfOKAtLeft: true
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Cancel'
                               name: 'Button8'
                               visibilityChannel: cancelButtonVisible
                               translateLabel: true
                               resizeForLabel: true
                               model: doCancel
                               extent: (Point 80 22)
                             )
                            (ActionButtonSpec
                               label: 'Finish'
                               name: 'Button7'
                               visibilityChannel: finishButtonVisible
                               translateLabel: true
                               resizeForLabel: true
                               model: doFinish
                               enableChannel: finishButtonEnabled
                               extent: (Point 80 22)
                             )
                            )
                          
                         )
                         extent: (Point 401 40)
                       )
                      (HorizontalPanelViewSpec
                         name: 'ButtonPanel1'
                         horizontalLayout: centerMax
                         verticalLayout: center
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (ActionButtonSpec
                               label: 'Back'
                               name: 'Button1'
                               activeHelpKey: backButton
                               visibilityChannel: backButtonVisible
                               translateLabel: true
                               labelChannel: backButtonLabelHolder
                               model: goBackward
                               enableChannel: backButtonEnabled
                               useDefaultExtent: true
                             )
                            (ActionButtonSpec
                               label: 'Next'
                               name: 'Button2'
                               activeHelpKey: nextButton
                               visibilityChannel: forwardButtonVisible
                               translateLabel: true
                               labelChannel: nextButtonLabelHolder
                               model: goForward
                               enableChannel: forwardButtonEnabled
                               useDefaultExtent: true
                             )
                            )
                          
                         )
                         extent: (Point 402 40)
                       )
                      )
                    
                   )
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'Label'
             name: 'Label1'
             layout: (LayoutFrame 1 0 -25 1 -1 1 -1 1)
             level: -1
             translateLabel: true
             labelChannel: infoHolder
             adjust: left
           )
          )
        
       )
     )
! !

!AssistantApplication class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AssistantApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(AssistantApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!AssistantApplication class methodsFor:'queries'!

isAbstract
    ^ self == AssistantApplication
! !

!AssistantApplication class methodsFor:'required protocol'!

assistantSpec
    "must return a sequenceable collection of assistantPageSpecs - one for each page"

    self subclassResponsibility
! !

!AssistantApplication methodsFor:'actions'!

canGoBackward
    |currentPageSpec previousPageSpec|

    "/ see if we are allowed to leave...
    currentPageSpec := self currentPageSpec.
    currentPageSpec canLeaveQuerySelector notNil ifTrue:[
        (self perform:currentPageSpec canLeaveQuerySelector) ifFalse:[^ false].
    ].

    "/ see if we are allowed to enter the next...
    previousPageSpec := self previousEnabledPageSpec.
    previousPageSpec isNil ifTrue:[^ false].

    previousPageSpec canEnterQuerySelector notNil ifTrue:[
        (self perform:previousPageSpec canEnterQuerySelector) ifFalse:[^ false].
    ].
    ^ true
!

canGoForward
    |currentPageSpec nextPageSpec|

    self currentPageIndex == self numberOfPages ifTrue:[^ false].

    "/ see if we are allowed to leave...
    currentPageSpec := self currentPageSpec.
    currentPageSpec canLeaveQuerySelector notNil ifTrue:[
        (self perform:currentPageSpec canLeaveQuerySelector) ifFalse:[^ false].
    ].

    "/ see if we are allowed to enter the next...
    nextPageSpec := self nextEnabledPageSpec.
    nextPageSpec isNil ifTrue:[^ false].

    nextPageSpec canEnterQuerySelector notNil ifTrue:[
        (self perform:nextPageSpec canEnterQuerySelector) ifFalse:[^ false].
    ].
    ^ true
!

doCancel
    self closeRequest
!

doFinish
    self closeRequest
!

goBackward
    (self canGoBackward) ifFalse:[^ self].
    self gotoPage:((self indexOfPreviousEnabledPageSpec) max:1)

    "Modified: / 20-07-2012 / 12:37:40 / cg"
!

goForward
    (self canGoForward) ifFalse:[^ self].
    self gotoPage:(self indexOfNextEnabledPageSpec)

    "Modified: / 20-07-2012 / 12:37:54 / cg"
!

gotoPage: pageIndex
    |currentPageSpec|

    currentPageSpec := self currentPageSpec.
    currentPageSpec leaveCallbackSelector notNil ifTrue:[
        self perform:currentPageSpec leaveCallbackSelector
    ].

    self currentPageIndexHolder value: pageIndex.

    currentPageSpec := self currentPageSpec.
    currentPageSpec enterCallbackSelector notNil ifTrue:[
        self perform:currentPageSpec enterCallbackSelector
    ].

    self updateButtonEnableState.

    "Created: / 20-07-2012 / 12:37:12 / cg"
! !

!AssistantApplication methodsFor:'aspects'!

assistantSpec
    ^ self class assistantSpec
!

backButtonEnabled
    <resource: #uiAspect>

    backButtonEnabled isNil ifTrue:[
        backButtonEnabled := false asValue.
    ].
    ^ backButtonEnabled.
!

backButtonLabelHolder
    <resource: #uiAspect>

    backButtonLabelHolder isNil ifTrue:[
        backButtonLabelHolder := self backButtonLabel asValue.
    ].
    ^ backButtonLabelHolder.
!

backButtonVisible
    <resource: #uiAspect>

    backButtonVisible isNil ifTrue:[
        backButtonVisible := true asValue.
    ].
    ^ backButtonVisible.
!

cancelButtonVisible
    <resource: #uiAspect>

    cancelButtonVisible isNil ifTrue:[
        cancelButtonVisible := true asValue.
    ].
    ^ cancelButtonVisible.

    "Created: / 06-09-2012 / 16:41:11 / cg"
!

currentPageIndexHolder
    <resource: #uiAspect>

    currentPageIndexHolder isNil ifTrue:[
        currentPageIndexHolder := 1 asValue.
        currentPageIndexHolder onChangeSend:#updateCanvas to:self
    ].
    ^ currentPageIndexHolder.
!

currentPageInfoHTMLHolder
    <resource: #uiAspect>

    currentPageInfoHTMLHolder isNil ifTrue:[
        currentPageInfoHTMLHolder := ValueHolder new.
    ].
    ^ currentPageInfoHTMLHolder.
!

currentPageSpecHolder
    <resource: #uiAspect>

    currentPageSpecHolder isNil ifTrue:[
        currentPageSpecHolder := nil asValue.
    ].
    ^ currentPageSpecHolder.
!

finishButtonEnabled
    <resource: #uiAspect>

    finishButtonEnabled isNil ifTrue:[
        finishButtonEnabled := false asValue.
    ].
    ^ finishButtonEnabled.
!

finishButtonVisible
    <resource: #uiAspect>

    finishButtonVisible isNil ifTrue:[
        finishButtonVisible := false asValue.
    ].
    ^ finishButtonVisible.
!

forwardButtonEnabled
    <resource: #uiAspect>

    forwardButtonEnabled isNil ifTrue:[
        forwardButtonEnabled := false asValue.
    ].
    ^ forwardButtonEnabled.
!

forwardButtonVisible
    <resource: #uiAspect>

    forwardButtonVisible isNil ifTrue:[
        forwardButtonVisible := true asValue.
    ].
    ^ forwardButtonVisible.
!

infoHolder
    "info message at the bottom"

    <resource: #uiAspect>

    infoHolder isNil ifTrue:[
        infoHolder := nil asValue.
    ].
    ^ infoHolder.

    "Modified: / 12-11-2010 / 12:33:01 / cg"
!

nextButtonLabelHolder
    <resource: #uiAspect>

    nextButtonLabelHolder isNil ifTrue:[
        nextButtonLabelHolder := self nextButtonLabel asValue.
    ].
    ^ nextButtonLabelHolder.
!

pageInfoHolder
    <resource: #uiAspect>

    pageInfoHolder isNil ifTrue:[
        pageInfoHolder := nil asValue.
    ].
    ^ pageInfoHolder.
!

pageLabelsInList
    pageLabelsInList isNil ifTrue:[
        pageLabelsInList := List new.
        pageLabelsInList contents:(self pageLabelsInListWithBullet).
    ].
    ^ pageLabelsInList
!

pageLabelsInListWithBullet
    |newList|

    newList := self pageLabels.
    newList := newList 
                with:(1 to:newList size) 
                collect:[:entry :index |
                    index == self currentPageIndex ifTrue:[
                        LabelAndTwoIcons new 
                            string:(entry allBold 
                                        colorizeAllWith:(TextView defaultSelectionForegroundColor) 
                                        on:(TextView defaultSelectionBackgroundColor) );
                            icon:(self class rightArrowIcon);
                            image2:(self class leftArrowIcon)
                    ] ifFalse:[
                        (self isPageEnabledAtIndex:index) ifFalse:[
                            entry withColor:(Button defaultDisabledForegroundColor) "Color grey".
                        ] ifTrue:[
                            entry
                        ].
                    ].
                ].
    ^ newList
! !

!AssistantApplication methodsFor:'help'!

flyByHelpTextForKey:aKey
    <resource: #help>

    |text bindings nextSpec prevSpec|

    text := super flyByHelpTextForKey:aKey.

    nextSpec := self nextEnabledPageSpec.
    prevSpec := self previousEnabledPageSpec.

    bindings := Dictionary new.
    bindings 
        at:#'previousPageInfo' 
        put:(prevSpec notNil ifTrue:[ '"',prevSpec pageTitle,'"' ] ifFalse:['']).
    bindings 
        at:#'nextPageInfo'
        put:(nextSpec notNil ifTrue:[ '"',nextSpec pageTitle,'"' ] ifFalse:['']).

    ^ self resources string:text withArgs:bindings.    
! !

!AssistantApplication methodsFor:'initialization & release'!

postBuildWith:aBuilder
    |maxCanvasExtent|

    super postBuildWith:aBuilder.
    self updateCanvas.

    maxCanvasExtent := (self assistantSpec 
                            collect:[:eachPageSpec | 
                                |windowSpecSelector specArray windowSpec|

                                windowSpecSelector := eachPageSpec windowSpecSelector.
                                specArray := self perform:windowSpecSelector ifNotUnderstood:[self class perform:windowSpecSelector].
                                windowSpec := specArray decodeAsLiteralArray.
                                windowSpec window bounds extent.
                            ]
                       ) max.

    self window extent:(maxCanvasExtent + (200 @ 40)).
    self builder window isModal ifFalse:[
        self cancelButtonVisible value:false
    ].

    "Modified: / 06-09-2012 / 16:42:42 / cg"
! !

!AssistantApplication methodsFor:'look'!

backButtonLabel
    ^ LabelAndIcon 
        label:(resources string:'Back')
        icon:(self backButtonEnabled value
                ifTrue:[ToolbarIconLibrary leftArrow24x24Icon]
                ifFalse:[ToolbarIconLibrary leftArrow24x24disabledIcon])
!

nextButtonLabel
    ^ LabelAndTwoIcons new 
        string:(resources string:'Next');
        image2:(self forwardButtonEnabled value
                ifTrue:[ToolbarIconLibrary rightArrow24x24Icon]
                ifFalse:[ToolbarIconLibrary rightArrow24x24disabledIcon]);
        yourself
!

pageLabels
    ^ self assistantSpec 
        collect:[:specEntry | resources string:specEntry pageTitle].
! !

!AssistantApplication methodsFor:'private'!

canFinish
    |pageIndex pageSpec|

    pageIndex := self currentPageIndexHolder value.
    pageSpec := self assistantSpec at:pageIndex.
    ^ pageSpec canLeaveQuerySelector isNil
    or:[ self perform:pageSpec canLeaveQuerySelector ]
!

currentPageIndex
    ^ self currentPageIndexHolder value
!

currentPageSpec
    ^ self assistantSpec at:(self currentPageIndex).
!

indexOfNextEnabledPageSpec
    |delta currentPageIndex|

    currentPageIndex := self currentPageIndex.
    delta := 1.
    [ 
        (currentPageIndex + delta) <= (self numberOfPages)
        and:[ (self isPageEnabledAtIndex:(currentPageIndex + delta)) not ]
    ] whileTrue:[
        delta := delta + 1.
    ].
    (currentPageIndex + delta) <= (self numberOfPages) ifTrue:[
        ^ (currentPageIndex + delta).
    ].
    ^ nil
!

indexOfPreviousEnabledPageSpec
    |delta currentPageIndex|

    currentPageIndex := self currentPageIndex.
    delta := 1.
    [ 
        (currentPageIndex - delta) > 0
        and:[ (self isPageEnabledAtIndex:(currentPageIndex - delta)) not ]
    ] whileTrue:[
        delta := delta + 1.
    ].
    (currentPageIndex - delta) > 0 ifTrue:[
        ^ (currentPageIndex - delta).
    ].
    ^ nil
!

isPageEnabledAtIndex:index
    |isEnabledSelector|

    isEnabledSelector := (self assistantSpec at:index) isEnabledQuerySelector.
    ^ isEnabledSelector isNil or:[ (self perform:isEnabledSelector) ]
!

nextEnabledPageSpec
    |index|

    index := self indexOfNextEnabledPageSpec.
    index isNil ifTrue:[^ nil].
    ^ self assistantSpec at:index.
!

nextPageSpec
    ^ self assistantSpec at:(self currentPageIndex + 1).
!

numberOfPages
    ^ self assistantSpec size
!

previousEnabledPageSpec
    |index|

    index := self indexOfPreviousEnabledPageSpec.
    index isNil ifTrue:[^ nil].
    ^ self assistantSpec at:index.
!

previousPageSpec
    ^ self assistantSpec at:(self currentPageIndex - 1).
! !

!AssistantApplication methodsFor:'update'!

updateButtonEnableState
    self backButtonEnabled value:(self canGoBackward).
    self forwardButtonEnabled value:(self canGoForward).
    self backButtonLabelHolder value:(self backButtonLabel).
    self nextButtonLabelHolder value:(self nextButtonLabel).
!

updateCanvas
    "update some valueHolders and especially the current canvas,
     after a step in either direction"

    |pageIndex pageSpec sel uiSpec|

    pageIndex := self currentPageIndex.
    pageSpec := self currentPageSpec.
    sel := pageSpec windowSpecSelector.
    uiSpec := self perform:sel ifNotUnderstood:[ self class perform:sel ].

    self pageLabelsInList contents:(self pageLabelsInListWithBullet).
    self currentPageSpecHolder value:uiSpec.

    self updateWindowLabelFor:pageSpec.

    self finishButtonVisible value:(pageIndex == self numberOfPages).
    self backButtonEnabled value:(pageIndex > 1).
    self forwardButtonEnabled value:(pageIndex < self numberOfPages).
    self finishButtonEnabled value:(pageIndex == self numberOfPages and:[ self canFinish ]).

    self backButtonLabelHolder value:(self backButtonLabel).
    self nextButtonLabelHolder value:(self nextButtonLabel).

    self pageInfoHolder value:(resources string:pageSpec infoText).

    "Modified: / 12-11-2010 / 12:32:09 / cg"
!

updateWindowLabelFor:aPageSpec
    self window label:(self class windowLabelTemplate bindWith:aPageSpec pageTitle).
! !

!AssistantApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

