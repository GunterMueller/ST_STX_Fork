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

AbstractPackageBrowser subclass:#AbstractPackageNotebookApplication
	instanceVariableNames:'selectedTabHolder canvasHolder tabListHolder tabApplications'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Application'
!

!AbstractPackageNotebookApplication class methodsFor:'documentation'!

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
! !

!AbstractPackageNotebookApplication class methodsFor:'constant values'!

applicationName
    ^ 'No name' asSymbol
! !

!AbstractPackageNotebookApplication class methodsFor:'defaults'!

tabsNames
    ^ self tabsNamesAndClasses keys asOrderedCollection sort:[:x :y |
            x < y
      ]

"/    ^ #( 
"/            #(#'Classes'         #Classes)
"/            #(#'Loose Methods'   #LooseMethod)
"/            #(#'Scripts'         #Scripts)
"/            #(#'Prerequisites'   #Prerequisites)
"/            #(#'Comment'         #Comment)
"/       ).
!

tabsNamesAndClasses
    | dic |
    dic := Dictionary new.

    self privateClasses do:[:aPrivateClass |  
            dic at:aPrivateClass applicationName  put:aPrivateClass name
    ].                                       
    ^ dic

"/    ^ #( 
"/            #(#'Classes'         #Classes)
"/            #(#'Loose Methods'   #LooseMethod)
"/            #(#'Scripts'         #Scripts)
"/            #(#'Prerequisites'   #Prerequisites)
"/            #(#'Comment'         #Comment)
"/       ).
! !

!AbstractPackageNotebookApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Packages::AbstractPackageNotebookApplication andSelector:#windowSpec
     Packages::AbstractPackageNotebookApplication new openInterface:#windowSpec
     Packages::AbstractPackageNotebookApplication open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Packages::PackageDetails'
          #name: 'Packages::PackageDetails'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 29 59 329 359)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#NoteBookViewSpec
              #name: 'PackageDetailsNotebook'
              #layout: #(#LayoutFrame 0 0 0 0 0 1 0 1)
              #model: #selectedTabHolder
              #menu: #tabListHolder
              #selectConditionBlock: #packageDetailsChangeToTabNumber:
              #canvas: #canvasHolder
              #postBuildCallback: #selectInitialTab
            )
           )
         
        )
      )
! !

!AbstractPackageNotebookApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #list
        #selectionHolder
      ).

! !

!AbstractPackageNotebookApplication methodsFor:'accessing'!

selectedTab:aSymbol 
    ^ self selectedTabHolder value:aSymbol
!

tabApplications
    "return the value of the instance variable 'tabApplications' (automatically generated)"
    tabApplications ifNil:[
        tabApplications := Dictionary new
    ].
    ^ tabApplications
!

tabApplications:something
    "set the value of the instance variable 'tabApplications' (automatically generated)"

    tabApplications := something.
! !

!AbstractPackageNotebookApplication methodsFor:'actions'!

packageDetailsChangeToTabNamed:aSymbol
    "return a boolean validating if you can change the current selected
     tab to the tab represented by aSymbol"
    aSymbol == self selectedTab ifTrue:[
        ^ self. "do nothing... dont think this can happen 
                but it means that the #validateChangeTo: methods do not need this check!!"
    ].
    ^ (self instanceAtTab:self selectedTab) validateCanChange:(self instanceAtTab:aSymbol)
!

packageDetailsChangeToTabNumber:anInteger
    "return a boolean validating if you can change the current selected
     tab to the tab represented by anInteger"
    ^ self packageDetailsChangeToTabNamed:(self tabListHolder value at:anInteger)
!

selectInitialTab
    self selectedTab:self tabListHolder value first.
! !

!AbstractPackageNotebookApplication methodsFor:'aspects'!

canvasHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    canvasHolder isNil ifTrue:[
        canvasHolder := ValueHolder with:(SubCanvas new) .
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       canvasHolder addDependent:self.
"/       canvasHolder onChangeSend:#canvasHolderChanged to:self.
    ].
    ^ canvasHolder.
!

selectedTab
    ^ selectedTabHolder value
!

selectedTabHolder

    selectedTabHolder isNil ifTrue:[
        selectedTabHolder := ValueHolder new.
       selectedTabHolder addDependent:self.
       selectedTabHolder onChangeSend:#selectedTabHolderChanged to:self.
    ].
    ^ selectedTabHolder.
!

tabListHolder
    "holds the names of the tab in a tabList"
    tabListHolder isNil ifTrue:[
        tabListHolder := ValueHolder with:(self class tabsNames).
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       tabList addDependent:self.
"/       tabList onChangeSend:#tabListChanged to:self.
    ].
    ^ tabListHolder.
! !

!AbstractPackageNotebookApplication methodsFor:'changes'!

selectedTabHolderChanged
    | instance |
    instance := self instanceAtTab:self selectedTab.

    instance ifNil:[
        ^ self
    ].
    self canvasHolder value client:(instance).
!

updateWithPackages:packages
! !

!AbstractPackageNotebookApplication methodsFor:'factory'!

applicationClassAt:aSymbol 
    ^ Smalltalk classNamed:(self class tabsNamesAndClasses at:aSymbol).







!

instanceAtTab:aSymbol 
    | anInstance |
    ^ self tabApplications at:aSymbol ifAbsentPut:[
        anInstance := (self applicationClassAt:aSymbol) new.
        anInstance masterApplication:self.
        anInstance
    ].
! !

!AbstractPackageNotebookApplication methodsFor:'initialization & release'!

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
    ^ super closeRequest
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

!AbstractPackageNotebookApplication class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/AbstractPackageNotebookApplication.st,v 1.3 2006-01-10 09:25:10 cg Exp $'
! !
