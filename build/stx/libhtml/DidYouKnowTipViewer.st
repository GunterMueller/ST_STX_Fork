"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#DidYouKnowTipViewer
	instanceVariableNames:'currentTipFile currentTipTextHolder tipHistory allTipsShownHolder
		showTipOfTheDayAtStartupHolder tipTitleHolder htmlTextForNewTip
		publishTipToExeptHolder textAcceptChannel infoHolder
		currentTipURLHolder iconHolder showEnglishTips'
	classVariableNames:'LastPublishTipToExept'
	poolDictionaries:''
	category:'System-Documentation'
!

!DidYouKnowTipViewer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    shows 'did you know' tips.
    The tips are found in a folder as individual html documents,
    which are chosen randomly.

    [author:]
        cg (cg@AQUA-DUO)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    DidYouKnowTipViewer open

                                                                [exEnd]
"
! !

!DidYouKnowTipViewer class methodsFor:'image specs'!

stxIcon
    <resource: #programImage>

    ^ Icon stxIconTransparent "/ stxIcon

    "Modified: / 28-07-2018 / 09:59:03 / Claus Gittinger"
! !

!DidYouKnowTipViewer class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DidYouKnowTipViewer andSelector:#windowSpec
     DidYouKnowTipViewer new openInterface:#windowSpec
     DidYouKnowTipViewer open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: 'a8c7bbfa-d1e1-11e7-ae98-c42c033b4871'
       window: 
      (WindowSpec
         label: 'Did You Know...'
         name: 'Did You Know...'
         uuid: 'f9d3199c-d1df-11e7-ae98-c42c033b4871'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 555 336)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             name: 'Label2'
             layout: (LayoutFrame 2 0 2 0 60 0 58 0)
             uuid: 'f9d354de-d1df-11e7-ae98-c42c033b4871'
             hasCharacterOrientedLabel: false
             translateLabel: true
             labelChannel: iconHolder
           )
          (LabelSpec
             label: 'Did You Know...'
             name: 'Label1'
             layout: (LayoutFrame 85 0 2 0 -2 1 58 0)
             style: (FontDescription helvetica medium roman 18 #'ms-ansi' nil nil)
             uuid: 'f9d357b8-d1df-11e7-ae98-c42c033b4871'
             translateLabel: true
             adjust: right
           )
          (HTMLViewSpec
             name: 'HTMLBrowser1'
             layout: (LayoutFrame 0 0 60 0 0 1 -30 1)
             uuid: 'f9d35948-d1df-11e7-ae98-c42c033b4871'
             model: currentTipURLHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
           )
          (CheckBoxSpec
             label: 'Show Tip at Startup'
             name: 'CheckBox1'
             layout: (LayoutFrame 3 0 -30 1 355 0 -4 1)
             uuid: 'f9d35b8c-d1df-11e7-ae98-c42c033b4871'
             model: showTipOfTheDayAtStartupHolder
             translateLabel: true
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 340 0 -30 1 -16 1 0 1)
             uuid: 'f9d35d6c-d1df-11e7-ae98-c42c033b4871'
             horizontalLayout: rightSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Next Tip'
                   name: 'Button1'
                   uuid: 'f9d35fa6-d1df-11e7-ae98-c42c033b4871'
                   translateLabel: true
                   model: showNextTip
                   enableChannel: nextTipEnabledHolder
                   extent: (Point 120 28)
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

windowSpecToAddTip
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:DidYouKnowTipViewer andSelector:#windowSpecToAddTip
     DidYouKnowTipViewer new openInterface:#windowSpecToAddTip
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecToAddTip
       uuid: 'f99a4a5a-d1e3-11e7-ae98-c42c033b4871'
       window: 
      (WindowSpec
         label: 'Adding Tip'
         name: 'Adding Tip'
         uuid: 'f265b950-d1e2-11e7-ae98-c42c033b4871'
         min: (Point 10 10)
         max: (Point 1024 768)
         bounds: (Rectangle 0 0 522 485)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'stxIcon'
             name: 'Label2'
             layout: (LayoutFrame 2 0 2 0 60 0 58 0)
             uuid: 'f265bbb2-d1e2-11e7-ae98-c42c033b4871'
             hasCharacterOrientedLabel: false
             translateLabel: true
           )
          (LabelSpec
             label: 'Adding New Tip'
             name: 'Label1'
             layout: (LayoutFrame 85 0 2 0 -2 1 58 0)
             style: (FontDescription helvetica medium roman 18 #'ms-ansi' nil nil)
             uuid: 'f265bda6-d1e2-11e7-ae98-c42c033b4871'
             translateLabel: true
             adjust: right
           )
          (LabelSpec
             label: 'Title:'
             name: 'Label3'
             layout: (LayoutFrame 5 0 62 0 100 0 84 0)
             uuid: 'f265bef0-d1e2-11e7-ae98-c42c033b4871'
             translateLabel: true
             adjust: right
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame 101 0 61 0 -2 1 85 0)
             uuid: 'f265c012-d1e2-11e7-ae98-c42c033b4871'
             model: tipTitleHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: true
           )
          (LabelSpec
             label: 'Tip Text (Body only):'
             name: 'Label4'
             layout: (LayoutFrame 5 0 92 0 317 0 114 0)
             uuid: 'f265c3f0-d1e2-11e7-ae98-c42c033b4871'
             translateLabel: true
             adjust: left
           )
          (TextEditorSpec
             name: 'HTMLText'
             layout: (LayoutFrame 0 0 120 0 0 1 -60 1)
             uuid: 'f265c526-d1e2-11e7-ae98-c42c033b4871'
             model: htmlTextForNewTip
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             acceptChannel: textAcceptChannel
             hasKeyboardFocusInitially: false
             viewClassName: ''
           )
          (CheckBoxSpec
             label: 'Publish Global (Send to eXept)'
             name: 'CheckBox1'
             layout: (LayoutFrame 3 0 -55 1 346 0 -34 1)
             uuid: 'f265c77e-d1e2-11e7-ae98-c42c033b4871'
             model: publishTipToExeptHolder
             translateLabel: true
           )
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel1'
             layout: (LayoutFrame 349 0 -59 1 0 1 -29 1)
             uuid: 'f265c904-d1e2-11e7-ae98-c42c033b4871'
             horizontalLayout: rightSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Add Tip'
                   name: 'Button1'
                   uuid: 'f265cac6-d1e2-11e7-ae98-c42c033b4871'
                   translateLabel: true
                   model: doAddTip
                   enableChannel: nextTipEnabledHolder
                   extent: (Point 150 28)
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'Label'
             name: 'Label5'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             uuid: 'f265ccce-d1e2-11e7-ae98-c42c033b4871'
             level: -1
             translateLabel: true
             labelChannel: infoHolder
             adjust: left
           )
          )
        
       )
     )
! !

!DidYouKnowTipViewer class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DidYouKnowTipViewer andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(DidYouKnowTipViewer mainMenu)) startUp
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
            label: 'Tip'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Force English Tips'
                  translateLabel: true
                  indication: showEnglishTips
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Next Tip'
                  itemValue: showNextTip
                  translateLabel: true
                )
               (MenuItem
                  label: 'Goto Tip...'
                  itemValue: chooseTip
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Add Tip'
                  itemValue: openAddTipWindow
                  translateLabel: true
                )
               (MenuItem
                  label: 'Edit this Tip'
                  itemValue: openEditorOnCurrentTip
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'History'
            translateLabel: true
            submenuChannel: historyMenu
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
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

!DidYouKnowTipViewer methodsFor:'aspects'!

allTipsShownHolder
    allTipsShownHolder isNil ifTrue:[
        allTipsShownHolder := false asValue.
    ].
    ^ allTipsShownHolder
!

currentTipTextHolder
    currentTipTextHolder isNil ifTrue:[
        currentTipTextHolder := ValueHolder new.
    ].
    ^ currentTipTextHolder
!

currentTipURLHolder
    currentTipURLHolder isNil ifTrue:[
        currentTipURLHolder := ValueHolder new.
    ].
    ^ currentTipURLHolder
!

htmlTextForNewTip
    htmlTextForNewTip isNil ifTrue:[
        htmlTextForNewTip := (resources stringWithCRs:'Plain text of the new tip.\(Header and BODY tags will be added automatically)') asValue.
    ].
    ^ htmlTextForNewTip

    "Modified: / 25-11-2017 / 14:21:57 / cg"
!

iconHolder
    iconHolder isNil ifTrue:[
        iconHolder := nil asValue.
    ].
    ^ iconHolder
!

infoHolder
    infoHolder isNil ifTrue:[
        infoHolder := '' asValue.
    ].
    ^ infoHolder
!

nextTipEnabledHolder
    ^ BlockValue forLogicalNot:self allTipsShownHolder
!

publishTipToExeptHolder
    publishTipToExeptHolder isNil ifTrue:[
        publishTipToExeptHolder := (LastPublishTipToExept ? false) asValue
    ].
    ^ publishTipToExeptHolder
!

showEnglishTips
    showEnglishTips isNil ifTrue:[
        showEnglishTips := false asValue.
        showEnglishTips 
            onChangeEvaluate:[
                self clearHistory.
                self showNextTip.
            ].
    ].
    ^ showEnglishTips
!

showTipOfTheDayAtStartupHolder
    showTipOfTheDayAtStartupHolder isNil ifTrue:[
        showTipOfTheDayAtStartupHolder := UserPreferences current showTipOfTheDayAtStartup asValue.
        showTipOfTheDayAtStartupHolder onChangeEvaluate:[
            UserPreferences current 
                showTipOfTheDayAtStartup:(showTipOfTheDayAtStartupHolder value).
            SettingsDialog saveSettingsAsDefaultSettings.    
        ]
    ].
    ^ showTipOfTheDayAtStartupHolder
!

textAcceptChannel
    textAcceptChannel isNil ifTrue:[
        textAcceptChannel := TriggerValue new.
    ].
    ^ textAcceptChannel
!

tipTitleHolder
    tipTitleHolder isNil ifTrue:[
        tipTitleHolder := 'area_another Tip' asValue.
    ].
    ^ tipTitleHolder
! !

!DidYouKnowTipViewer methodsFor:'initialization'!

defaultIcon
    <resource: #programImage>

    ^ self class stxIcon 
!

initialize
    super initialize.
    tipHistory := OrderedSet new.

    self iconHolder value:self defaultIcon.
!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.

    self showNextTip
! !

!DidYouKnowTipViewer methodsFor:'menu actions'!

checkTipsDirectory
    |dir|

    (dir := self tipsDirectory) isNil ifTrue:[
        Dialog warn:(resources string:'No Tip Directory.').
    ].
    ^ dir
!

chooseTip
    |fn dir|

    (dir := self checkTipsDirectory) isNil ifTrue:[
        ^ self
    ].

    fn := Dialog 
            requestFileName:(resources string:'Show tip')
            pattern:'*.html'
            fromDirectory:dir.

    fn isEmptyOrNil ifTrue:[^ self].
    self showTipFile:fn asFilename.
!

clearHistory
    tipHistory := OrderedSet new.
    allTipsShownHolder value:false.
!

doAddTip
    |html lastIndex prefix baseName fn|

    textAcceptChannel value:true.

    self tipTitleHolder value = 'area_another Tip' ifTrue:[
        Dialog warn:(resources stringWithCRs:'You must give the tip a proper title\consisting of the area (such as workspace, browser, etc.)\and a tip-title.').
        ^ self.
    ].

    html :=
'<HTML>
  <HEAD>
    <meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso8859-1">
    <TITLE>',(self tipTitleHolder value),'</Title>
  </HEAD>
  <BODY>
',(self htmlTextForNewTip value),'
  </BODY>
</HTML>'.

    lastIndex := self tipsDirectory directoryContents 
                        inject:0
                        into:[:maxSoFar :fn |
                            fn first isDigit ifTrue:[
                                maxSoFar max:(Integer readFrom:fn readStream)
                            ] ifFalse:[
                                maxSoFar
                            ].
                        ].
    prefix := (lastIndex+1) printString.
    prefix size == 1 ifTrue:[
        prefix := '0',prefix
    ].
    baseName := prefix,'_',(self tipTitleHolder value asLowercase copyReplaceAll:Character space with:$_).
    fn := (self tipsDirectory / baseName) withSuffix:'html'.
    fn contents:html.

    infoHolder value:'New Tip-File added: ',fn baseName.

    "/ send an email to stx-support@exept.de
    publishTipToExeptHolder value ifTrue:[
        SendMailTool 
            openForMessage:html 
            withSubject:('STX Tip:[', self tipTitleHolder value, ']') 
            preOpenBlock:[:inst|
                inst recipientEntryField value:'stx-tips@exept.de'
            ].
        infoHolder value:'Posted to eXept and Tip-File added: ',fn baseName.
    ].
!

openAddTipWindow
    (self checkTipsDirectory) isNil ifTrue:[
        ^ self
    ].
    self class openInterface:#windowSpecToAddTip
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

openEditorOnCurrentTip
    |dir|

    (dir := self checkTipsDirectory) isNil ifTrue:[
        ^ self
    ].
    currentTipFile isNil ifTrue:[
        Dialog warn:'No Current Tip.'.
        ^ self
    ].

    FileBrowser default openOnFileNamed:(dir construct:currentTipFile)

    "Modified: / 01-09-2017 / 14:03:46 / cg"
! !

!DidYouKnowTipViewer methodsFor:'menu-dynamic'!

historyMenu
    <resource: #programMenu >

    ^ [
        |m item nMax n|

        tipHistory size > 0 ifTrue:[
            m := Menu new.
            nMax := 15.
            n := 0.
            tipHistory do:[:tipName |
                |item index name sel|

                n < nMax ifTrue:[
                    name := tipName asFilename withoutSuffix baseName.
                    index := Integer readFrom:(name copyTo:(name indexOf:$_)-1) onError:''.
                    name := (name copyFrom:(name indexOf:$_)+1).
                    name := name copyReplaceAll:$_ with:Character space.

                    item := MenuItem label:(name, ' ', ('(#',index asString,')') withColor:Color grey).
                    item itemValue:#'showTipFromHistory:' argument:tipName.
                    m addItem:item.
                    n := n + 1.
                ].
            ].

            m addSeparator.

            item := MenuItem label:(resources string:'Clear History').
            item itemValue:#'clearHistory'.
            m addItem:item.

            m findGuiResourcesIn:self.
        ].
        m
    ].

    "Modified: / 25-11-2017 / 14:33:48 / cg"
! !

!DidYouKnowTipViewer methodsFor:'private'!

addToTipHistory:aTipName
    tipHistory addFirst:aTipName.
!

chooseRandomTip
    |allTips remainingTips tipsDirectory|

    tipsDirectory := self tipsDirectory.
    tipsDirectory isNil ifTrue:[
        ^ nil
    ].

    allTips := tipsDirectory directoryContents.
    allTips := allTips select:[:fn | fn first isDigit].
    remainingTips := allTips reject:[:fn | self isInTipHistory:fn].
    remainingTips := remainingTips reject:[:fn | fn asFilename hasSuffix:'bak'].
    remainingTips := remainingTips reject:[:fn | fn asFilename hasSuffix:'sav'].
    remainingTips isEmpty ifTrue:[
        allTipsShownHolder value:true.
        ^ nil
    ].
    ^ tipsDirectory / (remainingTips atRandom).

    "
     self new chooseRandomTip
    "

    "Modified: / 25-11-2017 / 14:29:31 / cg"
!

isInTipHistory:aTip
    ^ (currentTipFile = aTip) or:[ tipHistory includes:aTip ]
!

noMoreTipsInfoText
    ^ 'Sorry - Now all Tips have been shown.'
!

noTipsInfoText
    ^ 'Sorry - No Tips are available (missing tip-files ?).'
!

showNextTip
    |tip|

    tip := self chooseRandomTip.
    tip isNil ifTrue:[
        self tipsDirectory isNil ifTrue:[
            self showNoTipsInfo.
        ] ifFalse:[
            self showNoMoreTipsInfo.
        ].
        ^ self
    ].
    self showTipFile:tip.

    "
     self new showNextTip
    "
!

showNoMoreTipsInfo
    self showText:self noMoreTipsInfoText.
!

showNoTipsInfo
    self showText:self noTipsInfoText.
!

showText:tipText
    self currentTipTextHolder value:tipText.
!

showTipFile:tipFilename
    |tipText|

    currentTipFile notNil ifTrue:[
        self addToTipHistory:currentTipFile.
    ].
    currentTipFile := tipFilename baseName.

    self currentTipURLHolder value:(URL method:'file' path:tipFilename pathName).
    "/ tipText := tipFilename contentsOfEntireFile.
    "/ self showText:tipText.

    "
     self new showNextTip
    "
!

showTipFromHistory:tipName
    self showTipFile:(self tipsDirectory / tipName).
!

tipsDirectory
    |lang docDirectory tipsDirectory|

    docDirectory := HTMLDocGenerator findPathToTopOfDocumentation.
    docDirectory isNil ifTrue:[
        Transcript showCR:'No doc directory found'.
        ^ nil
    ].
    docDirectory := docDirectory asFilename.
    docDirectory exists ifFalse:[
        Transcript showCR:'No doc directory found'.
        ^ nil
    ].

    lang := (showEnglishTips value == true) 
                ifTrue:['english'] 
                ifFalse:[HTMLDocGenerator languageSpecificDocDirectory].

    tipsDirectory := docDirectory / lang / 'didYouKnowTips'.
    tipsDirectory exists ifFalse:[
        tipsDirectory := docDirectory / 'english' / 'didYouKnowTips'.
        tipsDirectory exists ifFalse:[
            Transcript showCR:'No tips-directory: %1' with:tipsDirectory.
            ^ nil
        ].
    ].
    ^ tipsDirectory

    "Modified: / 25-11-2017 / 14:10:46 / cg"
! !

!DidYouKnowTipViewer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/DidYouKnowTipViewer.st,v 1.33 2018-07-28 08:07:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/DidYouKnowTipViewer.st,v 1.33 2018-07-28 08:07:17 cg Exp $'
! !

