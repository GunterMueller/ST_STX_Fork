"
 COPYRIGHT (c) 2014 by Claus Gittinger
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

ApplicationModel subclass:#HTMLDocumentViewerApplication
	instanceVariableNames:'infoLabelHolder htmlTextHolder currentURLHolder
		uriFieldVisibleHolder uriHolder htmlView htmlEditView
		htmlTagsView previousWidth isEditingHolder editTextHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocumentViewerApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
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
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    HTMLDocumentViewerApplication open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!HTMLDocumentViewerApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HTMLDocumentViewerApplication andSelector:#windowSpec
     HTMLDocumentViewerApplication new openInterface:#windowSpec
     HTMLDocumentViewerApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '0ff06762-eeef-11e7-b656-32001872b3c0'
       window: 
      (WindowSpec
         label: 'HTMLDocumentViewerApplication'
         name: 'HTMLDocumentViewerApplication'
         uuid: '0ff082ba-eeef-11e7-b656-32001872b3c0'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 778 856)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 36 0)
             uuid: '0ff08698-eeef-11e7-b656-32001872b3c0'
             menu: toolbarMenu
             textDefault: true
           )
          (InputFieldSpec
             name: 'EntryField1'
             layout: (LayoutFrame -483 1 2 0 -2 1 32 0)
             uuid: '0ff0897c-eeef-11e7-b656-32001872b3c0'
             visibilityChannel: uriFieldVisibleHolder
             model: uriHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnPointerLeave: true
           )
          (VariableHorizontalPanelSpec
             name: 'HtmlPanel'
             layout: (LayoutFrame 1 0 36 0 0 1 -26 1)
             uuid: '0ff08c92-eeef-11e7-b656-32001872b3c0'
             level: 1
             showHandle: true
             snapMode: both
             component: 
            (SpecCollection
               collection: (
                (HTMLViewSpec
                   name: 'HTMLBrowser1'
                   uuid: '0ff08f4e-eeef-11e7-b656-32001872b3c0'
                   model: uriHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   htmlText: htmlTextHolder
                   postBuildCallback: postBuildHTMLView:
                 )
                )
              
             )
             handles: (Any 1.0)
           )
          (ViewSpec
             name: 'Box2'
             layout: (LayoutFrame 0 0 -26 1 0 1 0 1)
             uuid: '0ff091f6-eeef-11e7-b656-32001872b3c0'
             level: 1
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'InfoLabel'
                   name: 'Label2'
                   layout: (LayoutFrame 0 0 -26 1 -1 1 0 1)
                   uuid: '0ff093cc-eeef-11e7-b656-32001872b3c0'
                   level: -1
                   translateLabel: true
                   labelChannel: infoLabelHolder
                   adjust: left
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!HTMLDocumentViewerApplication class methodsFor:'menu specs'!

extraMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#extraMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication extraMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Settings...'
            itemValue: menuOpenSettings
          )
         )
        nil
        nil
      )
!

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#fileMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication fileMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Open...'
            itemValue: menuOpen
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Save'
            itemValue: menuSave
            isVisible: false
          )
         (MenuItem
            label: 'Save As...'
            itemValue: menuSaveAs
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Print'
            itemValue: menuPrint
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Exit'
            itemValue: closeRequest
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenuChannel: fileMenu
          )
         (MenuItem
            label: 'View'
            isVisible: false
            submenuChannel: viewMenu
          )
         (MenuItem
            label: 'Navigation'
            submenuChannel: navigationMenu
          )
         (MenuItem
            label: 'Tools'
            submenuChannel: toolsMenu
          )
         (MenuItem
            label: 'Extra'
            submenuChannel: extraMenu
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
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
!

navigationMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#navigationMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication navigationMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: menuBackEnabledHolder
            label: 'Back'
            itemValue: menuGoBack
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Start Page'
            itemValue: menuGotoStartPage
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: menuBackEnabledHolder
            label: 'Back'
            itemValue: menuGoBack
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
          )
         (MenuItem
            label: 'Reload'
            itemValue: menuReload
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reload24x24Icon)
          )
         )
        nil
        nil
      )
!

toolsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#toolsMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication toolsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Edit'
            itemValue: doEditHtml:
            hideMenuOnActivated: false
            indication: isEditingHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Page Source'
            itemValue: menuShowPageSource
          )
         (MenuItem
            label: 'File Browser on Page Source'
            itemValue: menuFileBrowserOnPageSource
          )
         )
        nil
        nil
      )
!

viewMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:HTMLDocumentViewerApplication andSelector:#toolsMenu
     (Menu new fromLiteralArrayEncoding:(HTMLDocumentViewerApplication toolsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Page Source'
            itemValue: menuShowPageSource
          )
         )
        nil
        nil
      )
! !

!HTMLDocumentViewerApplication class methodsFor:'startup-basic'!

openFullOnFile:aFilenameOrString anchor:localAnchor text:htmlText top:topDirectory 
    extent:extent title:title buttonSpec:buttonSpec 
    uriDisplay:showUri infoDisplay:showInfo

    |app|

    app := self new.
    app allButOpen.

    app file:aFilenameOrString.
    app text:htmlText.
    app topDirectory:topDirectory.
    app showUriDisplay:showUri.
    app showInfoDisplay:showInfo.
    localAnchor ifNotNil:[app anchor:localAnchor].

    app openWindow.
    ^ app
! !

!HTMLDocumentViewerApplication methodsFor:'accessing'!

anchor:localAnchor
    self positionOnAnchor:localAnchor
!

file:aFilenameOrString
    |filename homeDocument topDirectory|

    aFilenameOrString notNil ifTrue:[
        aFilenameOrString isFilename ifTrue:[
            filename := 'file://' , aFilenameOrString pathName.
            homeDocument := aFilenameOrString baseName.
            topDirectory := aFilenameOrString directoryName.
        ] ifFalse:[
            ((aFilenameOrString startsWith:'http:')
              or:[ (aFilenameOrString startsWith:'https:')
              or:[ (aFilenameOrString startsWith:'ftp:') ]]) ifTrue:[
                filename := URL fromString:aFilenameOrString.
                homeDocument := filename.
                topDirectory := filename path asUnixFilename directory.
            ] ifFalse:[
                filename := 'file://' , aFilenameOrString asFilename pathName.
                homeDocument := aFilenameOrString asFilename baseName.
                topDirectory := aFilenameOrString asFilename directoryName.
            ]
        ]    
    ].

    filename isNil ifTrue:[
        "/ htmlView homeText:htmlText.
        "/ directory := topDirectory.
    ] ifFalse:[        
        self uriHolder value:filename.
        htmlView homeDocument:homeDocument.
        htmlView setTopDirectoryName:topDirectory.
    ].

    "Modified: / 17-02-2017 / 10:32:21 / cg"
!

nameSpaceForExecution:aNameSpace
    htmlView nameSpaceForExecution:aNameSpace.
!

positionOnAnchor:localAnchor
    htmlView notNil ifTrue:[
        htmlView positionOnAnchor:localAnchor
    ]
!

showInfoDisplay:showInfo
    "/ self halt.
!

showUriDisplay:showUri
    self uriFieldVisibleHolder value:showUri
!

text:htmlText
    htmlText notNil ifTrue:[
        htmlView homeText:htmlText.
    ]
!

topDirectory:topDirectory
    topDirectory notNil ifTrue:[
        htmlView setTopDirectoryName:topDirectory
    ].
! !

!HTMLDocumentViewerApplication methodsFor:'aspects'!

editTextHolder
    <resource: #uiAspect>

    editTextHolder isNil ifTrue:[
        editTextHolder := ValueHolder new.
    ].
    ^ editTextHolder.
!

htmlTextHolder
    <resource: #uiAspect>

    htmlTextHolder isNil ifTrue:[
        htmlTextHolder := ValueHolder new.
    ].
    ^ htmlTextHolder.
!

infoLabelHolder
    <resource: #uiAspect>

    infoLabelHolder isNil ifTrue:[
        infoLabelHolder := ValueHolder new.
    ].
    ^ infoLabelHolder.
!

isEditingHolder
    <resource: #uiAspect>

    isEditingHolder isNil ifTrue:[
        isEditingHolder := false asValue.
    ].
    ^ isEditingHolder.
!

menuBackEnabledHolder
    ^ htmlView canGoBackHolder
!

uriFieldVisibleHolder
    <resource: #uiAspect>

    uriFieldVisibleHolder isNil ifTrue:[
        uriFieldVisibleHolder := true asValue.
    ].
    ^ uriFieldVisibleHolder.
!

uriHolder
    <resource: #uiAspect>

    uriHolder isNil ifTrue:[
        uriHolder := ValueHolder new.
    ].
    ^ uriHolder.
! !

!HTMLDocumentViewerApplication methodsFor:'change & update'!

scrollHtmlViewFromEditTextView
    |characterPosition prev prevElWithBounds|
    
    characterPosition := htmlEditView characterPositionOfCursor.

    "/ find the last element before that sourceposition
    htmlView scrolledView painter elementsDo:[:el |
        (el sourcePosition ? 0) >= characterPosition ifTrue:[
            prevElWithBounds notNil ifTrue:[
                htmlView positionTo:(0 @ (prevElWithBounds boundsTop-(htmlView height//2))).
            ].
            ^ self
        ].    
        prev := el.
        el bounds notNil ifTrue:[
            prevElWithBounds := el
        ].    
    ].
!

update:something with:aParameter from:changedObject
    (changedObject == htmlEditView) ifTrue:[
        something == #textChanged ifTrue:[
            self enqueueMessage:#updateHtmlTextFromEditor for:self arguments:#().
            ^ self
        ].
        something == #sizeOfContents ifTrue:[
            self enqueueMessage:#updateHtmlTextFromEditor for:self arguments:#().
            ^ self
        ].
    ].
    (htmlEditView notNil 
    and:[htmlEditView scrolledView notNil]) ifTrue:[
        (changedObject == htmlEditView cursorLineHolder
        or:[ changedObject == htmlEditView cursorColHolder ]) ifTrue:[
            self enqueueMessage:#scrollHtmlViewFromEditTextView for:self arguments:#().
            ^ self
        ].
    ].
    
    super update:something with:aParameter from:changedObject.
!

updateHtmlTextFromEditor
    htmlTextHolder value:(htmlEditView contents).
! !

!HTMLDocumentViewerApplication methodsFor:'initialization & release'!

closeDownViews
    "This is a hook method generated by the Browser/CodeGeneratorTool.
     It will be invoked when your app/dialog-window is really closed.
     See also #closeDownViews, which is invoked before and may suppress the close
     or ask the user for confirmation."

    "/ change the code below as required ...
    "/ This should cleanup any leftover resources
    "/ (for example, temporary files)
    "/ super closeRequest will initiate the closeDown

    "/ add your code here

    "/ do not remove the one below ...
    ^ super closeDownViews
!

closeRequest
    "This is a hook method generated by the Browser/CodeGeneratorTool.
     It will be invoked when your app/dialog-window is about to be
     closed (this method has a chance to suppress the close).
     See also #closeDownViews, which is invoked when the close is really done."

    "/ change the code below as required ...
    "/ Closing can be suppressed, by simply returning.
    "/ The 'super closeRequest' at the end will initiate the real closeDown

    self hasUnsavedChanges ifTrue:[
        (self confirm:(resources string:'Close without saving ?')) ifFalse:[
            ^ self
        ]
    ].
    self doEditHtml:false.
    
    ^ super closeRequest
!

postBuildHTMLView:aView
    htmlView := aView.
    htmlView infoHolder:self infoLabelHolder.
! !

!HTMLDocumentViewerApplication methodsFor:'menu actions'!

doEditHtml:aBoolean
    "add an editor pane, to allow immediate editing"
    
    |panel fn tagsBrowser relWidth htmlInnerEditView|
    
    aBoolean ifTrue:[
        htmlEditView isNil ifTrue:[
            fn := htmlView fileNameOfPageSource.
            fn isNil ifTrue:[
                Dialog warn:'Shown HTML is not coming from a file'.
            ] ifFalse:[
                htmlEditView := ScrollableView for:EditTextView.
                htmlInnerEditView := htmlEditView scrolledView.
                
                htmlTagsView := ApplicationSubView new.
                tagsBrowser := Tools::TagsBrowser new.
                tagsBrowser window:htmlTagsView.
                tagsBrowser allButOpen.
                tagsBrowser editedFile:fn.
                tagsBrowser 
                    action:[:tag |
                        tag notNil ifTrue:[
                            htmlInnerEditView cursorLine:tag lineNumber col:1    
                        ].    
                    ].
                    
                htmlView 
                    masterClickActionPerformer:[:clickPos :clickElement |
                        |el|
                        el := clickElement.
                        [el notNil and:[el sourcePosition isNil]] whileTrue:[
                            el := el next.
                        ]. 
                        el notNil ifTrue:[
                            htmlInnerEditView cursorToCharacterPosition:el sourcePosition.
                            htmlInnerEditView selectLine:(htmlInnerEditView cursorLine).
                        ].
                        true
                    ].
                    
                "/ self postBuildTagsBrowser:tagsBrowserCanvas.
                panel := builder componentAt:#HtmlPanel.
                relWidth := (((100.0 / panel width) truncateTo:0.01) min: 1.0) max:0.
               
                previousWidth isNil ifTrue:[
                    previousWidth := self window width
                ].    
                self window width:( ((previousWidth * 2)+(panel barHeight*2)) min:(device width-10)).
                panel 
                    addComponent:htmlEditView;
                    addComponent:htmlTagsView;
                    relativeCorners:{ 0.5 . (1.0 - relWidth) . 1.0 }.
                    
                previousWidth := nil.        
                previousWidth := self window width.        
                "/ self window width:( ((previousWidth * 2)+(panel barHeight*2)) min:(self graphicsDevice width-10)).
                htmlInnerEditView model:self editTextHolder.
                "/ htmlView htmlTextHolder homeText
                self editTextHolder value:(fn contentsAsString).
                htmlInnerEditView defaultFileNameForFileDialog:fn.
                htmlInnerEditView addDependent:self.
                htmlInnerEditView cursorLineHolder addDependent:self.
                htmlInnerEditView cursorColHolder addDependent:self.
            ].
        ].
    ] ifFalse:[
        htmlEditView notNil ifTrue:[
            htmlEditView cursorLineHolder removeDependent:self.
            htmlEditView cursorColHolder removeDependent:self.
            htmlEditView removeDependent:self.

            htmlTagsView destroy.
            htmlEditView destroy.
            previousWidth notNil ifTrue:[
                self window width:previousWidth.
            ].
            htmlEditView := htmlTagsView := nil.
            htmlView masterClickActionPerformer:nil
        ]                            
    ].
!

doSaveAs
    "This method was generated by the Browser/CodeGeneratorTool.
     It will be invoked when the menu-item 'save/saveAs' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''save/saveAs'' defined.'.
!

menuFileBrowserOnPageSource
    htmlView fileBrowserOnPageSource
!

menuGoBack
    htmlView menu_back
!

menuGotoStartPage
    htmlView menu_home
!

menuOpenSettings
    htmlView menu_settings
!

menuPrint
    htmlView menu_print
!

menuReload
    htmlView menu_reload
!

menuShowPageSource
    htmlView showPageSource
!

openAboutThisApplication
    "This method was generated by the Browser/CodeGeneratorTool.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser/CodeGeneratorTool.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    self openDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ self openDocumentationFile:'help/<MyApplication>/TOP.html'.
! !

!HTMLDocumentViewerApplication methodsFor:'private queries'!

hasUnsavedChanges
    "Return true, if any unsaved changes are present 
     (i.e. the contents needs to be saved or else will be lost)"

    "/ add real code as required (or remove the halt and always return false)...
    "/ self halt:'check this code'.
    ^ false.
! !

!HTMLDocumentViewerApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentViewerApplication.st,v 1.25 2018-01-01 12:27:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentViewerApplication.st,v 1.25 2018-01-01 12:27:27 cg Exp $'
! !

