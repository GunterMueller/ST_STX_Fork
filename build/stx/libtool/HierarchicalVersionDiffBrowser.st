"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#HierarchicalVersionDiffBrowser
	instanceVariableNames:'versionDiffBrowser classTree treeSelectionHolder classHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers'
!

!HierarchicalVersionDiffBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    This is not yet finished (work in progress) - do not use.

    A hierarchical version diff browser, allowing easy comparison
    between a classes versions; will also eventually add capabilities
    to checkIn / load classes into / from the repository.

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"

!

examples
"
                                                                        [exBegin]
    HierarchicalVersionDiffBrowser openOnClasses:(Array with:Smalltalk)
                                                                        [exEnd]

                                                                        [exBegin]
    HierarchicalVersionDiffBrowser openOnClasses:(Project current changedClasses)
                                                                        [exEnd]
"

! !

!HierarchicalVersionDiffBrowser class methodsFor:'interface specs'!

contentsSpecVersionDiffBrowser
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassRevisionTree andSelector:#contentsSpecVersionDiffBrowser
     ClassRevisionTree new openInterface:#contentsSpecVersionDiffBrowser
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #contentsSpecVersionDiffBrowser
	#window: 
       #(#WindowSpec
	  #label: 'Hierarchical Version DiffBrowser'
	  #name: 'Hierarchical Version DiffBrowser'
	  #min: #(#Point 10 10)
	  #max: #(#Point 9999 9999)
	  #bounds: #(#Rectangle 12 22 877 551)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#SubCanvasSpec
	      #name: 'VersionDiffBrowser'
	      #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
	      #hasHorizontalScrollBar: false
	      #hasVerticalScrollBar: false
	      #majorKey: #VersionDiffBrowser
	      #minorKey: #windowSpec
	      #clientKey: #versionDiffBrowser
	    )
	   #(#LabelSpec
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 20 0)
	      #visibilityChannel: #''
	      #translateLabel: true
	      #labelChannel: #versionDiffModel
	      #resizeForLabel: false
	      #adjust: #left
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
     UIPainter new openOnClass:HierarchicalVersionDiffBrowser andSelector:#windowSpec
     HierarchicalVersionDiffBrowser new openInterface:#windowSpec
     HierarchicalVersionDiffBrowser open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Hierarchical Version DiffBrowser'
          #name: 'Hierarchical Version DiffBrowser'
          #min: #(#Point 10 10)
          #max: #(#Point 9999 9999)
          #bounds: #(#Rectangle 16 46 881 575)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'menuPanel'
              #layout: #(#LayoutFrame 0 0 0 0 0 1.0 24 0)
              #level: 1
              #tabable: true
              #style: 
             #(#Font
                'helvetica' 'bold'
                'oblique' 10
              )
            )
           #(#VariableHorizontalPanelSpec
              #name: 'VariableHorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 25 0.0 0 1.0 0 1.0)
              #level: 2
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#SubCanvasSpec
                    #name: 'ClassTree'
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: false
                    #majorKey: #ClassRevisonTree
                    #minorKey: #windowSpec
                    #clientKey: #classTree
                  )
                 #(#UISubSpecification
                    #name: 'SubSpecification1'
                    #majorKey: #HierarchicalVersionDiffBrowser
                    #minorKey: #contentsSpecVersionDiffBrowser
                  )
                 )
               
              )
              #handles: #(#Any 0.310983 1.0)
            )
           )
         
        )
      )
! !

!HierarchicalVersionDiffBrowser class methodsFor:'menu specs'!

resourceClassItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ClassRevisionTree andSelector:#resourceRevisonItemMenu
     (Menu new fromLiteralArrayEncoding:(ClassRevisionTree resourceRevisonItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Browse Class'
            #translateLabel: true
            #value: #menuActionBrowseClass
          )
         #(#MenuItem
            #label: 'Checkin...'
            #translateLabel: true
            #value: #menuActionCheckInClass
            #enabled: #canCheckInClass
          )
         )
        nil
        nil
      )

!

resourceCompareChangesMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ClassRevisionTree andSelector:#resourceCompareChangesMenu
     (Menu new fromLiteralArrayEncoding:(ClassRevisionTree resourceCompareChangesMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Compare Changes'
            #translateLabel: true
            #value: #menuActionCompareChanges
          )
         )
        nil
        nil
      )

!

resourceRevisonItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ClassRevisionTree andSelector:#resourceRevisonItemMenu
     (Menu new fromLiteralArrayEncoding:(ClassRevisionTree resourceRevisonItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Load Revision'
            #translateLabel: true
            #nameKey: #menuActionLoadRevision
            #value: #menuActionLoadRevision
          )
         )
        nil
        nil
      )

! !

!HierarchicalVersionDiffBrowser class methodsFor:'protocol'!

browserClass

    ^SystemBrowser
!

tree

    ^ClassRevisionTree
! !

!HierarchicalVersionDiffBrowser class methodsFor:'startup'!

openOnClassRevisionInfo:aClassRevisionInfoColl
    |theBrowser theTree|

    SourceCodeManager isNil ifTrue:[
        self warn:'SourceCodeManagement is disabled.\\I will not be able to show old versions.' withCRs.
    ].
    theBrowser := self new.
    theTree := self tree new.
    theTree classItemClass: ClassNameItem.
    theTree setUpClassItemBlock:[
        |theClassRevisionInfoColl root theClassItemColl |
        self halt.
        root := ClassItemRoot new.
        (theClassRevisionInfoColl := self classHolder value) notNil ifTrue:[
            theClassItemColl := theClassRevisionInfoColl collect:[:eachClass |
                |theClassItem theClass|
                theClassItem := ClassNameItem new.
               theClassItem myClass:(eachClass at:1).
                theClassItem].
           root addAll: theClassItemColl.
        ].  
        self listModel root:root.
    ].
    theBrowser classTree:theTree.
    theBrowser allButOpen.
    theTree classHolder:(theBrowser classHolder value:aClassRevisionInfoColl).
    "theTree selectionHolder:theBrowser treeSelectionHolder."
    "theTree menuBlock:theBrowser menuBlock."
    theBrowser openWindow.
    ^theBrowser
"
self openOnClassRevisionInfo:#(#(VersionDiffBrowser 1.1 1.2) #(FileBrowser 1.1 1.2) #(Array 1.1 1.2)).
"
!

openOnClasses:aClassColl
    |theBrowser theTree|

    SourceCodeManager isNil ifTrue:[
        self warn:'SourceCodeManagement is disabled.\\I will not be able to show old versions.' withCRs.
    ].
    theBrowser := self new.
    theTree := self tree new.
    theBrowser classTree:theTree.
    theBrowser allButOpen.
    theTree classHolder:(theBrowser classHolder value:aClassColl).
    theTree selectionHolder:theBrowser treeSelectionHolder.
    theTree menuBlock:theBrowser menuBlock.
    theBrowser openWindow.
    ^theBrowser
"
|theBrowser|
theBrowser := self openOnClasses:#(VersionDiffBrowser FileBrowser Array).
Delay waitForMilliseconds:1500.
theBrowser classHolder value:(Smalltalk allClasses asOrderedCollection sort:[:x : y|x name < y name])
"
! !

!HierarchicalVersionDiffBrowser methodsFor:'accessing'!

classHolder
    "return the value of the instance variable 'classHolder' (automatically generated)"

    ^ classHolder ifNil:[classHolder := ValueHolder new]
!

classHolder:something
    "set the value of the instance variable 'classHolder' (automatically generated)"

    classHolder := something.
!

classTree

    ^ classTree 
!

classTree:something
    "set the value of the instance variable 'classTree' (automatically generated)"

    classTree := something.
!

treeSelectionHolder

    ^treeSelectionHolder ifNil:[treeSelectionHolder := ValueHolder new]
!

versionDiffBrowser

    versionDiffBrowser isNil ifTrue:[
        versionDiffBrowser := VersionDiffBrowser new.
        versionDiffBrowser masterApplication:self.
    ].
    ^ versionDiffBrowser
! !

!HierarchicalVersionDiffBrowser methodsFor:'aspects'!

canCheckInClass
    SourceCodeManager isNil ifTrue:[^ false].
    ^ true
!

versionDiffModel
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#versionDiffModel) isNil ifTrue:[
        holder := String new asValue.
        builder aspectAt:#versionDiffModel put:holder.
    ].
    ^ holder.
! !

!HierarchicalVersionDiffBrowser methodsFor:'change & update'!

delayedUpdate

    self halt.

!

update:something with:someArgument from:changedObject
    |sensor|

    "/ delayed update
    "/ if such an update is already in the queue, ignore it.
    "/ Otherwise push it as an event, to be handled when I am back

    (sensor := self window sensor) isNil 
        ifTrue:[^ self delayedUpdate].

    (sensor hasEvent:#delayedUpdate for:self ) 
        ifTrue:[^ self].

    sensor pushUserEvent:#delayedUpdate for:self



! !

!HierarchicalVersionDiffBrowser methodsFor:'menu'!

menuForClassItemSelected
"
<return: Menu>
"
    |menu|

    menu := Menu new fromLiteralArrayEncoding:(self class resourceClassItemMenu).
    menu receiver:self.
    ^menu

!

menuForOneRevisionItemSelected
"
<return: Menu>
"
    |menu theItemColl|

    menu := Menu new fromLiteralArrayEncoding:(self class resourceRevisonItemMenu).
    "disable load button, if version already loaded"
    theItemColl := self treeSelectionHolder value.
    theItemColl first isLoadedRevision
        ifTrue:[menu allItemsDo:[:eachItem | eachItem nameKey == #menuActionLoadRevision
                                                  ifTrue:[eachItem isEnabled:false]].
               ].
    menu receiver:self.
    ^menu
!

menuForTwoRevisionItemsSelected
"
<return: Menu>
"
    |menu|

    menu := Menu new fromLiteralArrayEncoding:(self class resourceCompareChangesMenu).
    menu receiver:self.
    ^menu

! !

!HierarchicalVersionDiffBrowser methodsFor:'menu actions'!

menuActionBrowseClass
    |cls|

    cls := self treeSelectionHolder value first myClass.
    cls browserClass openInClass:cls

!

menuActionCheckInClass
    |cls|

    cls := self treeSelectionHolder value first myClass.
    SourceCodeManagerUtilities checkinClass:cls 

!

menuActionCompareChanges

    self updateVersionDiffBrowser


!

menuActionLoadRevision

    |theSelectedItem theLoadedItem theChangeSetA theChangeSetB theChangeDic|

    theSelectedItem := self treeSelectionHolder value first.
    theLoadedItem := theSelectedItem parent loadedRevisionItem.
    theChangeSetA := ChangeSet fromStream:(theSelectedItem sourceStream).
    theChangeSetB := ChangeSet fromStream:(theLoadedItem sourceStream).
    (theChangeSetA isNil or:[theChangeSetB isNil]) ifTrue:[^self].
    theChangeDic := (theChangeSetA diffSetsAgainst:theChangeSetB).
    self applyChangesIn:theChangeDic.
!

menuBlock

    ^[ 
        |menu|  
        self checkIfTwoRevisionItemsSelected
            ifTrue: [menu := self menuForTwoRevisionItemsSelected].
        self checkIfOneRevisionItemSelected
            ifTrue: [menu := self menuForOneRevisionItemSelected].
        self checkIfClassItemSelected
            ifTrue: [menu := self menuForClassItemSelected].
        menu
    ]

! !

!HierarchicalVersionDiffBrowser methodsFor:'menu testing'!

checkIfClassItemSelected

    |theItemColl|

    theItemColl := self treeSelectionHolder value.
    ^(theItemColl size == 1) and:[theItemColl first isClassItem]
!

checkIfOneRevisionItemSelected

    |theItemColl theItem|

    theItemColl := self treeSelectionHolder value.
    ^(theItemColl size == 1) and:
        [(theItem := theItemColl first) isRevisionItem and:
        [theItem isSourceRevisionItem not and:
        [theItem hasSourceStream]]]
!

checkIfTwoRevisionItemsSelected

    |theFirstItem theSecondItem theItemColl|

    theItemColl := self treeSelectionHolder value.
    theItemColl size ~~ 2
            ifTrue:[^false].
    theFirstItem := theItemColl first.
    theSecondItem := theItemColl last.

    ^theFirstItem isRevisionItem and:[theSecondItem isRevisionItem and:
        [theFirstItem hasSourceStream and:[theSecondItem hasSourceStream and:
        [theFirstItem myClass == theSecondItem myClass]]]]
! !

!HierarchicalVersionDiffBrowser methodsFor:'private'!

applyChangesIn:aChangeDic

    self halt.
    (aChangeDic at:#onlyInReceiver) apply.
    ((aChangeDic at:#changed) collect:[:each | each first]) do:[:eachMethodChange | eachMethodChange apply].
    (aChangeDic at:#onlyInArg) do:
        [:eachChange | eachChange isMethodChange 
                            ifTrue:[|theClass|
                                   (theClass := eachChange changeClass) notNil 
                                        ifTrue:[theClass removeSelector:eachChange selector]]].


! !

!HierarchicalVersionDiffBrowser methodsFor:'update'!

updateVersionDiffBrowser
"

<return: self>
"
    |theFirstTreeItem theSecondTreeItem theClass theFirstRevisionString theSecondRevisionString|

    theFirstTreeItem := self treeSelectionHolder value first.
    theSecondTreeItem := self treeSelectionHolder value last.
    theClass := theFirstTreeItem myClass.
    theFirstRevisionString := theFirstTreeItem revisionString.
    theSecondRevisionString := theSecondTreeItem revisionString.
    self updateVersionDiffLabelForClass:theClass andVersionA:theFirstRevisionString andVersionB:theSecondRevisionString.    
    self versionDiffBrowser setupForClass:theClass 
                            labelA:theFirstRevisionString
                            sourceA:theFirstTreeItem sourceStream
                            labelB:theSecondRevisionString 
                            sourceB:theSecondTreeItem sourceStream
!

updateVersionDiffLabelForClass:aClass andVersionA:aVersionA andVersionB:aVersionB    
"

<return: self>
"
    |theStream|

    theStream := WriteStream on:#String.
    theStream nextPutAll:'Compare '.
    theStream nextPutAll: aClass name.
    theStream nextPutAll:' revision '''.
    theStream nextPutAll: aVersionA.
    theStream nextPutAll: ''' with revision '''.
    theStream nextPutAll: aVersionB.
    theStream nextPutAll: '''.'.
    self versionDiffModel value:theStream contents
! !

!HierarchicalVersionDiffBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/HierarchicalVersionDiffBrowser.st,v 1.9 2000/02/18 14:06:52 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

