"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

AbstractPackageBrowser subclass:#PackageBrowser
	instanceVariableNames:'packageSelectorSelectionHolder packageDetailsApplicationHolder
		packageSelectorApplicationHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Application'
!

!PackageBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
         (james@miraculix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Packages::PackageBrowser open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 19.3.2003 / 11:23:18 / james"
! !

!PackageBrowser class methodsFor:'interface specs'!

XXXwindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Packages::PackageBrowser andSelector:#windowSpec
     Packages::PackageBrowser new openInterface:#windowSpec
     Packages::PackageBrowser open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Packages::PackageBrowser'
          #name: 'Packages::PackageBrowser'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 29 59 777 532)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableHorizontalPanelSpec
              #name: 'VariableHorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #showHandle: true
              #snapMode: #both
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#SubCanvasSpec
                    #name: 'PackageSelector'
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #majorKey: #'Packages::PackageSelector'
                    #subAspectHolders: 
                   #(#Array
                      
                     #(#SubChannelInfoSpec
                        #subAspect: #packagesSelectedHolder
                        #aspect: #packagesSelectedHolder
                      )
                    )
                    #createNewApplication: true
                    #createNewBuilder: true
                    #postBuildCallback: #packageSelectorCreated:
                  )
                 #(#SubCanvasSpec
                    #name: 'PackageDetails'
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #majorKey: #'Packages::PackageDetails'
                    #createNewApplication: true
                    #createNewBuilder: true
                    #postBuildCallback: #packageDetailsCreated:
                  )
                 )
               
              )
              #handles: #(#Any 0.260695 1.0)
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Packages::PackageBrowser andSelector:#windowSpec
     Packages::PackageBrowser new openInterface:#windowSpec
     Packages::PackageBrowser open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Packages::PackageBrowser'
          #name: 'Packages::PackageBrowser'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 29 59 777 532)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'ToolBar1'
              #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
              #menu: #menu
              #textDefault: true
            )
           #(#VariableHorizontalPanelSpec
              #name: 'VariableHorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
              #showHandle: true
              #snapMode: #both
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#SubCanvasSpec
                    #name: 'PackageSelector'
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #majorKey: #'Packages::PackageSelector'
                    #subAspectHolders: 
                   #(#Array
                      
                     #(#SubChannelInfoSpec
                        #subAspect: #packagesSelectedHolder
                        #aspect: #packagesSelectedHolder
                      )
                    )
                    #createNewApplication: true
                    #createNewBuilder: true
                    #postBuildCallback: #packageSelectorCreated:
                  )
                 #(#SubCanvasSpec
                    #name: 'PackageDetails'
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #majorKey: #'Packages::PackageDetails'
                    #createNewApplication: true
                    #createNewBuilder: true
                    #postBuildCallback: #packageDetailsCreated:
                  )
                 )
               
              )
              #handles: #(#Any 0.287433 1.0)
            )
           )
         
        )
      )
! !

!PackageBrowser class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated by the CodeGeneratorTool."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Packages::PackageBrowser andSelector:#mainMenu
    "

    <resource: #menu>

    ^ #(#Menu
           #(
             #(#MenuItem
                #label: 'File'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'New'
                          #translateLabel: true
                          #value: #menuNew
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Open...'
                          #translateLabel: true
                          #value: #menuOpen
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Save'
                          #translateLabel: true
                          #value: #menuSave
                      )
                       #(#MenuItem
                          #label: 'Save As...'
                          #translateLabel: true
                          #value: #menuSaveAs
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'Exit'
                          #translateLabel: true
                          #value: #closeRequest
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: 'Help'
                #translateLabel: true
                #startGroup: #right
                #submenu: 
                 #(#Menu
                     #(
                       #(#MenuItem
                          #label: 'Documentation'
                          #translateLabel: true
                          #value: #openDocumentation
                      )
                       #(#MenuItem
                          #label: '-'
                      )
                       #(#MenuItem
                          #label: 'About this Application'
                          #translateLabel: true
                          #value: #openAboutThisApplication
                      )
                    ) nil
                    nil
                )
            )
          ) nil
          nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Packages::PackageBrowser andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Packages::PackageBrowser menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Reset Smalltalk Manager'
            #itemValue: #resetSmalltalkManager
            #translateLabel: true
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #idea16x16Icon)
          )
         #(#MenuItem
            #label: 'Action'
            #itemValue: #inspectSmalltalkManager
            #translateLabel: true
            #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #inspectLocals20x20Icon)
          )
         )
        nil
        nil
      )
! !

!PackageBrowser class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #packageDetailsApplicationHolder
        #packageSelectorApplicationHolder
        #packageSelectorSelectionHolder
      ).

! !

!PackageBrowser methodsFor:'accessing'!

packageDetailsApplication
    ^ packageDetailsApplicationHolder value
! !

!PackageBrowser methodsFor:'actions'!

inspectSmalltalkManager
    "This is temporary for when the manager goes a bit bonkers!!"
    self packageManager inspect
!

resetSmalltalkManager
    "This is temporary for when the manager goes a bit bonkers!!"
    | aPackageManager |
    self withWaitCursorDo:[
        Packages::PackageManager smalltalkPackageManager becomeNil.
        aPackageManager := Packages::PackageManager smalltalkPackageManager.
        self packageManager:aPackageManager
    ].
! !

!PackageBrowser methodsFor:'aspects'!

packageDetailsApplicationHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    packageDetailsApplicationHolder isNil ifTrue:[
        packageDetailsApplicationHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       packageDetailsApplicationHolder addDependent:self.
"/       packageDetailsApplicationHolder onChangeSend:#packageDetailsApplicationHolderChanged to:self.
    ].
    ^ packageDetailsApplicationHolder.
!

packageSelectorApplicationHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    packageSelectorApplicationHolder isNil ifTrue:[
        packageSelectorApplicationHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       packageSelectorApplicationHolder addDependent:self.
"/       packageSelectorApplicationHolder onChangeSend:#packageSelectorApplicationHolderChanged to:self.
    ].
    ^ packageSelectorApplicationHolder.
!

packagesSelectedHolder
    packageSelectorSelectionHolder isNil ifTrue:[
        self applicationAspectsAt:#packagesSelectedHolder put:ValueHolder new.
    ].
    ^ packageSelectorSelectionHolder.
! !

!PackageBrowser methodsFor:'callbacks'!

packageDetailsCreated:aSubCanvas
    "do nothing...for now"

    self packageDetailsApplicationHolder value:aSubCanvas client.
!

packageSelectorCreated:aSubCanvas
    "do nothing...for now"
    self packageSelectorApplicationHolder value:aSubCanvas client.
! !

!PackageBrowser methodsFor:'constants'!

smalltalkPackageManager
    ^ PackageManager smalltalkPackageManager
! !

!PackageBrowser methodsFor:'initialization & release'!

closeDownViews
    "This is a hook method generated by the Browser.
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
    "This is a hook method generated by the Browser.
     It will be invoked when your app/dialog-window is about to be
     closed (this method has a chance to suppress the close).
     See also #closeDownViews, which is invoked when the close is really done."

    "/ change the code below as required ...
    "/ Closing can be suppressed, by simply returning.
    "/ The 'super closeRequest' at the end will initiate the real closeDown

    ("self hasUnsavedChanges" true) ifTrue:[
        (self confirm:(resources string:'Close without saving ?')) ifFalse:[
            ^ self
        ]
    ].

    ^ super closeRequest
!

initialize
    self packageManager:self smalltalkPackageManager.
!

postBuildWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built, 
     but BEFORE the top window is made visible.
     Add any app-specific actions here (reading files, setting up values etc.)
     See also #postOpenWith:, which is invoked after opening."

    "/ add any code here ...

    ^ super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...
    ^ super postOpenWith:aBuilder
! !

!PackageBrowser methodsFor:'menu actions'!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuOpen
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'open' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''open'' available.'.
!

menuSave
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''save'' available.'.
!

menuSaveAs
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'saveAs' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''saveAs'' available.'.
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
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
! !

!PackageBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackageBrowser.st,v 1.4 2006/01/10 09:25:17 cg Exp $'
! !