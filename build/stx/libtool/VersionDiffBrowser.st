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

ApplicationModel subclass:#VersionDiffBrowser
	instanceVariableNames:'classChangeSet diffTextView boxAVisible boxBVisible boxMVisible
		classIfSingleClassDiff versionAIfSingleClassDiff
		versionBIfSingleClassDiff changedLabelHolder diffTextLabelA
		diffTextLabelB methodText methodsChanged methodsChangedFiltered
		methodsChangedSelection methodsOnlyInA methodsOnlyInAFiltered
		methodsOnlyInASelection methodsOnlyInB methodsOnlyInBFiltered
		methodsOnlyInBSelection onlyInALabelHolder onlyInBLabelHolder
		classHolder versionAHolder versionBHolder infoHolder
		includeExtensionsHolder canIncludeExtensionsHolder
		includeCategoryChangesHolder includeVersionMethodsHolder
		isMultipleVersionBrowser versionInfoList versionList
		selectedVersionHolder symbolicVersionList
		selectedSymbolicVersionHolder symbolicToVersionMapping'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers'
!

HierarchicalItem subclass:#ClassChangeSet
	instanceVariableNames:'class1BeingCompared class2BeingCompared labelA labelB diffSet
		versionA versionB'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VersionDiffBrowser
!

!VersionDiffBrowser class methodsFor:'documentation'!

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
    This is not yet finished (work in progress).

    A quickly hacked up browser to show differences between class versions,
    allowing easy comparison; will also eventually add capabilities
    to checkIn / load classes into / from the repository.

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!VersionDiffBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VersionDiffBrowser andSelector:#windowSpec
     VersionDiffBrowser new openInterface:#windowSpec
     VersionDiffBrowser open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Version DiffBrowser'
	  name: 'Version DiffBrowser'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 865 504)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableVerticalPanelSpec
	      name: 'VariableVerticalPanel1'
	      layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
	      component:
	     (SpecCollection
		collection: (
		 (HorizontalPanelViewSpec
		    name: 'TopHorizontalPanel'
		    horizontalLayout: fit
		    verticalLayout: fit
		    horizontalSpace: 3
		    verticalSpace: 3
		    component:
		   (SpecCollection
		      collection: (
		       (ViewSpec
			  name: 'BoxA'
			  level: 0
			  visibilityChannel: boxAVisible
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Only in A'
				name: 'OnlyInALabel'
				layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
				translateLabel: true
				labelChannel: onlyInALabelHolder
			      )
			     (SequenceViewSpec
				name: 'ListA'
				layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
				model: methodsOnlyInASelection
				menu: menuA
				hasHorizontalScrollBar: true
				hasVerticalScrollBar: true
				miniScrollerHorizontal: true
				doubleClickSelector: methodInADoubleClicked:
				valueChangeSelector: methodsOnlyInASelectionChanged
				useIndex: true
				sequenceList: methodsOnlyInA
			      )
			     )

			  )
			  extent: (Point 286 199)
			)
		       (ViewSpec
			  name: 'BoxM'
			  visibilityChannel: boxMVisible
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Changed'
				name: 'ChangedLabel'
				layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
				translateLabel: true
				labelChannel: changedLabelHolder
			      )
			     (SequenceViewSpec
				name: 'ListM'
				layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
				model: methodsChangedSelection
				menu: menuM
				hasHorizontalScrollBar: true
				hasVerticalScrollBar: true
				miniScrollerHorizontal: true
				doubleClickSelector: methodInChangedDoubleClicked:
				valueChangeSelector: methodsChangedSelectionChanged
				useIndex: true
				sequenceList: methodsChanged
			      )
			     )

			  )
			  extent: (Point 286 199)
			)
		       (ViewSpec
			  name: 'BoxB'
			  visibilityChannel: boxBVisible
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'Only in B'
				name: 'OnlyInBLabel'
				layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
				translateLabel: true
				labelChannel: onlyInBLabelHolder
			      )
			     (SequenceViewSpec
				name: 'ListB'
				layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
				model: methodsOnlyInBSelection
				menu: menuB
				hasHorizontalScrollBar: true
				hasVerticalScrollBar: true
				miniScrollerHorizontal: true
				doubleClickSelector: methodInBDoubleClicked:
				valueChangeSelector: methodsOnlyInBSelectionChanged
				useIndex: true
				sequenceList: methodsOnlyInB
			      )
			     )

			  )
			  extent: (Point 287 199)
			)
		       )

		    )
		  )
		 (ViewSpec
		    name: 'Box4'
		    component:
		   (SpecCollection
		      collection: (
		       (ViewSpec
			  name: 'diffTextViewBox'
			  layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
			  initiallyInvisible: true
			  component:
			 (SpecCollection
			    collection: (
			     (LabelSpec
				label: 'A'
				name: 'DiffTextLabelA'
				layout: (LayoutFrame 0 0 0 0 0 0.5 20 0)
				translateLabel: true
				labelChannel: diffTextLabelA
			      )
			     (LabelSpec
				label: 'B'
				name: 'DiffTextLabelB'
				layout: (LayoutFrame 0 0.5 0 0 0 1 20 0)
				translateLabel: true
				labelChannel: diffTextLabelB
			      )
			     (ArbitraryComponentSpec
				name: 'diffTextView'
				layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 0 1.0)
				hasBorder: false
				component: diffTextView
			      )
			     )

			  )
			)
		       (CodeViewSpec
			  name: 'singleTextView'
			  layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
			  model: methodText
			  hasHorizontalScrollBar: true
			  hasVerticalScrollBar: true
			  miniScrollerHorizontal: true
			  isReadOnly: true
			  hasKeyboardFocusInitially: false
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.42379958246347 1.0)
	    )
	   (LabelSpec
	      name: 'InfoLabel'
	      layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
	      level: -1
	      translateLabel: true
	      labelChannel: infoHolder
	      adjust: left
	    )
	   )

	)
      )
!

windowSpecForMultipleVersions
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VersionDiffBrowser andSelector:#windowSpecForMultipleVersions
     VersionDiffBrowser new openInterface:#windowSpecForMultipleVersions
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecForMultipleVersions
       window: 
      (WindowSpec
         label: 'Version DiffBrowser'
         name: 'Version DiffBrowser'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 865 504)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -25 1.0)
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Box1'
                   component: 
                  (SpecCollection
                     collection: (
                      (SequenceViewSpec
                         name: 'VersionList'
                         layout: (LayoutFrame 0 0 0 0 0 0.5 0 1)
                         model: selectedVersionHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         useIndex: false
                         sequenceList: versionList
                       )
                      (SequenceViewSpec
                         name: 'List1'
                         layout: (LayoutFrame 0 0.5 0 0 0 1 0 1)
                         model: selectedSymbolicVersionHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         useIndex: false
                         sequenceList: symbolicVersionList
                       )
                      )
                    
                   )
                 )
                (HorizontalPanelViewSpec
                   name: 'TopHorizontalPanel'
                   horizontalLayout: fit
                   verticalLayout: fit
                   horizontalSpace: 3
                   verticalSpace: 3
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'BoxA'
                         level: 0
                         visibilityChannel: boxAVisible
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Only in A'
                               name: 'OnlyInALabel'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
                               translateLabel: true
                               labelChannel: onlyInALabelHolder
                             )
                            (SequenceViewSpec
                               name: 'ListA'
                               layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
                               model: methodsOnlyInASelection
                               menu: menuA
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               miniScrollerHorizontal: true
                               doubleClickSelector: methodInADoubleClicked:
                               valueChangeSelector: methodsOnlyInASelectionChanged
                               useIndex: true
                               sequenceList: methodsOnlyInA
                             )
                            )
                          
                         )
                         extent: (Point 286 207)
                       )
                      (ViewSpec
                         name: 'BoxM'
                         visibilityChannel: boxMVisible
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Changed'
                               name: 'ChangedLabel'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
                               translateLabel: true
                               labelChannel: changedLabelHolder
                             )
                            (SequenceViewSpec
                               name: 'ListM'
                               layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
                               model: methodsChangedSelection
                               menu: menuM
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               miniScrollerHorizontal: true
                               doubleClickSelector: methodInChangedDoubleClicked:
                               valueChangeSelector: methodsChangedSelectionChanged
                               useIndex: true
                               sequenceList: methodsChanged
                             )
                            )
                          
                         )
                         extent: (Point 286 207)
                       )
                      (ViewSpec
                         name: 'BoxB'
                         visibilityChannel: boxBVisible
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'Only in B'
                               name: 'OnlyInBLabel'
                               layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 20 0)
                               translateLabel: true
                               labelChannel: onlyInBLabelHolder
                             )
                            (SequenceViewSpec
                               name: 'ListB'
                               layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 -3 1.0)
                               model: methodsOnlyInBSelection
                               menu: menuB
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               miniScrollerHorizontal: true
                               doubleClickSelector: methodInBDoubleClicked:
                               valueChangeSelector: methodsOnlyInBSelectionChanged
                               useIndex: true
                               sequenceList: methodsOnlyInB
                             )
                            )
                          
                         )
                         extent: (Point 287 207)
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'DiffBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'diffTextViewBox'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         initiallyInvisible: true
                         component: 
                        (SpecCollection
                           collection: (
                            (LabelSpec
                               label: 'A'
                               name: 'DiffTextLabelA'
                               layout: (LayoutFrame 0 0 0 0 0 0.5 20 0)
                               translateLabel: true
                               labelChannel: diffTextLabelA
                             )
                            (LabelSpec
                               label: 'B'
                               name: 'DiffTextLabelB'
                               layout: (LayoutFrame 0 0.5 0 0 0 1 20 0)
                               translateLabel: true
                               labelChannel: diffTextLabelB
                             )
                            (ArbitraryComponentSpec
                               name: 'diffTextView'
                               layout: (LayoutFrame 0 0.0 20 0.0 0 1.0 0 1.0)
                               hasBorder: false
                               component: diffTextView
                             )
                            )
                          
                         )
                       )
                      (CodeViewSpec
                         name: 'singleTextView'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         model: methodText
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         isReadOnly: true
                         hasKeyboardFocusInitially: false
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.217118997912317 0.666666666666667 1.0)
           )
          (LabelSpec
             name: 'InfoLabel'
             layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
             level: -1
             translateLabel: true
             labelChannel: infoHolder
             adjust: left
           )
          )
        
       )
     )
! !

!VersionDiffBrowser class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VersionDiffBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(VersionDiffBrowser mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Create PatchFile...'
                  itemValue: createPatchFile
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
          )
         (MenuItem
            label: 'Class'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Remove from Changeset'
                  itemValue: removeClassFromChangeSet
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: canIncludeExtensionsHolder
                  label: 'Include Extensions'
                  itemValue: includeExtensions:
                  indication: includeExtensionsHolder
                )
               (MenuItem
                  enabled: canIncludeExtensionsHolder
                  label: 'Include Version Methods'
                  itemValue: includeVersionMethods:
                  indication: includeVersionMethodsHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Include Category Changes'
                  itemValue: includeCategoryChanges:
                  indication: includeCategoryChangesHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show Log Messages'
                  itemValue: showLogMessages
                )
               )
              nil
              nil
            )
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

menuA
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:VersionDiffBrowser andSelector:#menu1
     (Menu new fromLiteralArrayEncoding:(VersionDiffBrowser menu1)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Apply'
	    #translateLabel: true
	    #value: #applySelectedChangeInA
	    #enabled: #hasChangeSelectedInA
	  )
	 #(#MenuItem
	    #label: 'Browse'
	    #translateLabel: true
	    #value: #browseClassInA
	    #enabled: #hasChangeSelectedInA
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Inspect'
	    #translateLabel: true
	    #value: #inspectSelectedChangeInA
	    #choiceValue: 'nil "UndefinedObject" '
	    #enabled: #hasChangeSelectedInA
	  )
	 )
	nil
	nil
      )
!

menuB
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:VersionDiffBrowser andSelector:#menuB
     (Menu new fromLiteralArrayEncoding:(VersionDiffBrowser menuB)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Apply'
	    #translateLabel: true
	    #value: #applySelectedChangeInB
	    #enabled: #hasChangeSelectedInB
	  )
	 #(#MenuItem
	    #label: 'Browse'
	    #translateLabel: true
	    #value: #browseClassInB
	    #enabled: #hasChangeSelectedInB
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Remove in Image'
	    #translateLabel: true
	    #value: #removeSelectedChangeInBFromImage
	    #enabled: #hasChangeSelectedInB
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Inspect'
	    #translateLabel: true
	    #value: #inspectSelectedChangeInB
	    #choiceValue: 'nil "UndefinedObject" '
	    #enabled: #hasChangeSelectedInB
	  )
	 )
	nil
	nil
      )

    "Modified: / 15-08-2010 / 21:24:49 / cg"
!

menuM
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:VersionDiffBrowser andSelector:#menu1
     (Menu new fromLiteralArrayEncoding:(VersionDiffBrowser menu1)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Browse'
	    #translateLabel: true
	    #value: #browseClassInM
	    #enabled: #hasChangeSelectedInM
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Apply Left Version'
	    #translateLabel: true
	    #value: #acceptInLeftView
	    #enabled: #hasChangeSelectedInM
	  )
	 #(#MenuItem
	    #label: 'Apply Right Version'
	    #translateLabel: true
	    #value: #acceptInRightView
	    #enabled: #hasChangeSelectedInM
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Inspect both'
	    #translateLabel: true
	    #value: #inspectSelectedChangeInM
	    #choiceValue: 'nil "UndefinedObject" '
	    #enabled: #hasChangeSelectedInM
	  )
	 )
	nil
	nil
      )

    "Modified: / 31-08-2007 / 14:16:39 / cg"
! !

!VersionDiffBrowser class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #changedLabelHolder
        #onlyInALabelHolder
        #onlyInBLabelHolder
      ).

! !

!VersionDiffBrowser class methodsFor:'startup'!

openOnAllVersionsOfClass:aClass
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from aClasses current version against
     the selected version in the top selection list"

    |theBrowser|

    theBrowser := self new.
    theBrowser allButOpenInterface:#windowSpecForMultipleVersions.
    theBrowser beMultipleVersionBrowser.
    theBrowser classHolder:(ValueHolder with:aClass).
    theBrowser setupForClass:aClass againstVersion:nil.
    theBrowser openWindow.
    ^ theBrowser.

    "
     self openOnAllVersionsOfClass:Object
    "
!

openOnClass:aClass againstVersion:aVersionA
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from aClasses current against some version
     via the source code manager."

    |theBrowser|

    theBrowser := self new.
    theBrowser allButOpen.
    theBrowser setupForClass:aClass againstVersion:aVersionA.
    theBrowser openWindow.
    ^ theBrowser.

    "
     self openOnClass:Array againstVersion:'1.116'
     self openOnClass:Array againstVersion:nil            - against the version on which Array is based upon
     self openOnClass:Array againstVersion:#newest        - against the newest repository version

     self openOnClass:VersionDiffBrowser againstVersion:nil
     self openOnClass:VersionDiffBrowser againstVersion:#newest

     (self openOnClass:ByteArray againstVersion:'1.116') includeExtensionsHolder value:true
    "
!

openOnClass:classA labelA:aLabelA andClass:classB labelB:aLabelB title:ignoredTitle
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two classes."

    ^ self
	openOnClass:classA labelA:aLabelA
	andClass:classB labelB:aLabelB
	title:ignoredTitle ifSame:nil

    "
     self
	openOnClass:Array labelA:'Array'
	andClass:Collection labelB:'Collection'
	title:'Array vs. Collection'
    "
!

openOnClass:classA labelA:aLabelA andClass:classB labelB:aLabelB title:ignoredTitle ifSame:sameAction
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two classes."

    |classChangeSet|

    classChangeSet := ClassChangeSet newForClass:classA labelA:aLabelA andClass:classB labelB:aLabelB.
    classChangeSet removeAllVersionMethods.
    sameAction notNil ifTrue:[
	"/ check if same ...
	(classChangeSet methodsOnlyInA isEmpty
	and:[classChangeSet methodsOnlyInB isEmpty
	and:[classChangeSet diffSet isEmpty]]) ifTrue:[
	    sameAction value.
	    ^ self "/ do not open
	]
    ].

    ^ self openOnClassChangeSet:classChangeSet title:ignoredTitle
!

openOnClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two source files."

    ^ self
	openOnClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB
	title:nil
!

openOnClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB title:ignoredTitle
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two source files."

    ^ self
	openOnClass:aClass labelA:aLabelA sourceA:aSourceA
	labelB:aLabelB sourceB:aSourceB
	title:ignoredTitle ifSame:nil
!

openOnClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB title:ignoredTitle ifSame:sameAction
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two source files."

    |diffs hasChangedMethods classChangeSet versionMethodChanges|

    classChangeSet := ClassChangeSet newForClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB.
    classChangeSet removeAllVersionMethods.
    sameAction notNil ifTrue:[
	"/ check if same ...
	(classChangeSet methodsOnlyInA isEmpty
	and:[classChangeSet methodsOnlyInB isEmpty]) ifTrue:[
	    diffs := classChangeSet diffSet.

	    hasChangedMethods := diffs changed notEmpty.
	    hasChangedMethods ifTrue:[
		versionMethodChanges := diffs changed select:[:eachDifference |
		    |eachChange|
		    eachChange := eachDifference first.
		    (eachChange isMethodChange
		    and:[ (AbstractSourceCodeManager isVersionMethodSelector:eachChange selector)
		    and:[ eachChange changeClass isMeta ]]).
		].
		diffs changed size == versionMethodChanges size ifTrue: [
		    hasChangedMethods := false.
		].
"/                diffs changed size == 1 ifTrue:[
"/                    theOnlyDifference := diffs changed first.
"/                    theOnlyChange := theOnlyDifference first.
"/                    (theOnlyChange isMethodChange
"/                    and:[ ((theOnlyChange selector == #version) or:[theOnlyChange selector startsWith:'version_'])
"/                    and:[ theOnlyChange changeClass isMeta ]]) ifTrue:[
"/                        hasChangedMethods := false
"/                    ]
"/                ]
	    ].

	    (hasChangedMethods not
	    and:[diffs onlyInArg isEmpty
	    and:[diffs onlyInReceiver isEmpty]]) ifTrue:[
		sameAction value.
		^ self "/ do not open
	    ].
	]
    ].

    ^ self openOnClassChangeSet:classChangeSet title:ignoredTitle

    "Modified: / 13-10-2006 / 01:01:05 / cg"
!

openOnClass:aClass versionA:aVersionA versionB:aVersionB
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two versions of aClass via
     the source code manager."

    |theBrowser|

    theBrowser := self new.
    theBrowser allButOpen.
    theBrowser setupForClass:aClass versionA:aVersionA versionB:aVersionB.
    theBrowser openWindow.
    ^ theBrowser.

    "
     self openOnClass:Array versionA:'1.116' versionB:'1.113'
    "
!

openOnClassChangeSet:classChangeSet title:ignoredTitle
    "create a VersionDiffBrowser instance and set the class change set of the
     browser. The class diff set is generated from two classes."

    |theBrowser|

    theBrowser := self new.
    theBrowser allButOpen.
    theBrowser classChangeSet:classChangeSet.
    theBrowser openWindow.
    ^ theBrowser.
!

openOnDiffSet:diffSet labelA:aLabelA labelB:aLabelB title:ignoredTitle
    ^ self
        openOnDiffSet:diffSet 
        labelA:aLabelA labelB:aLabelB 
        title:ignoredTitle
        ignoreExtensions:false
        ignoreVersionMethods:false

    "Modified: / 12-09-2011 / 11:52:44 / cg"
!

openOnDiffSet:diffSet labelA:aLabelA labelB:aLabelB title:ignoredTitle ignoreExtensions:ignoreExtensionsBoolean
    ^ self
        openOnDiffSet:diffSet 
        labelA:aLabelA labelB:aLabelB 
        title:ignoredTitle 
        ignoreExtensions:ignoreExtensionsBoolean 
        ignoreVersionMethods:false
!

openOnDiffSet:diffSet labelA:aLabelA labelB:aLabelB title:ignoredTitle ignoreExtensions:ignoreExtensionsBoolean ignoreVersionMethods:ignoreVersionMethodsBoolean
    |theBrowser|

    theBrowser := self new.
    theBrowser ignoreExtensions:ignoreExtensionsBoolean.
    theBrowser ignoreVersionMethods:ignoreVersionMethodsBoolean.
    theBrowser allButOpen.
    theBrowser setupForDiffSet:diffSet labelA:aLabelA labelB:aLabelB.
    theBrowser window label:ignoredTitle.
    theBrowser openWindow.
    ^ theBrowser.

    "Created: / 12-09-2011 / 11:50:18 / cg"
!

openOnDiffsBetweenFile:file1 and:file2
    |set1 set2 diffset theBrowser|

    set1 := ChangeSet fromFile:file1.
    set2 := ChangeSet fromFile:file2.
    diffset := set1 diffSetsAgainst:set2.

    theBrowser := self new.
    theBrowser allButOpen.
    theBrowser setupForDiffSet:diffset labelA:file1 asFilename baseName labelB:file2 asFilename baseName.
    theBrowser window label:('%1 vs. %2' bindWith:file1 asFilename baseName with:file2 asFilename baseName).
    theBrowser openWindow.
    ^ theBrowser.

    "
     VersionDiffBrowser
	openOnDiffsBetweenFile:'/phys/exept/tmp/ws/Workflow::BlockDescription.st'
	and:'/phys/exept/tmp/workflowClasses/Workflow::BlockDescription.st'
    "
! !

!VersionDiffBrowser methodsFor:'accessing'!

beMultipleVersionBrowser
    isMultipleVersionBrowser := true
!

canIncludeExtensions:something
    self canIncludeExtensionsHolder value:something.
!

changeSetA
    "
    gets the change set which contains only the new methods
    in versionA of the class

    <return: ChangeSet>
    "

    ^ self classChangeSet methodsOnlyInA
!

changeSetB
    "
    gets the change set which contains only the new methods
    in versionB of the class

    <return: ChangeSet>
    "

    ^ self classChangeSet methodsOnlyInB
!

class:aClass versionA:revA versionB:revB
    classIfSingleClassDiff := aClass.
    versionAIfSingleClassDiff := revA.
    versionBIfSingleClassDiff := revB.
!

classBeingCompared
    "returns the class from the change set which is compared.

    <return: Class>
    "
    ^ self classChangeSet classBeingCompared
!

classChangeSet
    "returns the class change set which is the model of the version diff browser."

    ^ classChangeSet
!

classChangeSet:aClassChangeSet
    "sets the class change set which is the model of the version diff browser.
     The labels, the lists, the visibility and the selection of the lists must be reseted
     when a new change set is given."

    classChangeSet := aClassChangeSet.
    self updateLabels.
    self updateLists.
    self resetSelectionHolders.
!

ignoreExtensions
    "if true, extension methods are suppressed.
     Ignoring is useful when comparing for baseClass checkin,
     as opposed to extension-checking, where extensions should not be ignored.
     the default is false"

    ^ self includeExtensions not

    "Created: / 12-09-2011 / 11:54:11 / cg"
!

ignoreExtensions:aBoolean
    "if true, extension methods are suppressed.
     Ignoring is useful when comparing for baseClass checkin,
     as opposed to extension-checking, where extensions should not be ignored.
     the default is false"

    self includeExtensions:aBoolean not

    "Modified: / 06-03-2012 / 15:37:32 / cg"
!

ignoreVersionMethods:aBoolean
    "if true, version methods (version and version_XXX) are suppressed.
     Ignoring is useful when comparing for real code changes.
     the default is false"

    self includeVersionMethods:aBoolean not

    "Modified: / 06-03-2012 / 15:37:32 / cg"
!

isMultipleVersionBrowser
    ^ isMultipleVersionBrowser ? false
!

selectedChangeInA
    "
    gets the selected method change for the 'method only in version A'.

    <return: MethodChange | nil>
    "
    |selIndex change|

    selIndex := self methodsOnlyInASelection value.
    selIndex notNil ifTrue:[
        change := methodsOnlyInAFiltered "self changeSetA" at:selIndex.
    ].
    ^ change
!

selectedChangeInB
    "
    gets the selected method change for the 'method only in version B'.

    <return: MethodChange | nil>
    "
    |selIndex change|

    selIndex := self methodsOnlyInBSelection value.
    selIndex notNil ifTrue:[
        change := methodsOnlyInBFiltered "self changeSetB" at:selIndex.
    ].
    ^ change
!

selectedChangesInM
    "
    get the two method changes for the selected 'changed method'.

    <return: <Array with:MethodChange with:MethodChange | nil>>
    "
    |selIndex theTwoChanges|

    selIndex := self methodsChangedSelection value.
    selIndex notNil ifTrue:[
        theTwoChanges := methodsChangedFiltered "self classChangeSet methodsChanged" at:selIndex.
        ^ theTwoChanges.
    ].
    ^ #(nil nil)
!

versionA
    "
    gets the first class version to be compared

    <return: String>
    "
    classChangeSet isNil ifTrue:[^ 'A'].
    ^ classChangeSet labelA
!

versionB
    "
    gets the second class version to be compared

    <return: String>
    "
    classChangeSet isNil ifTrue:[^ 'B'].
    ^ classChangeSet labelB
! !

!VersionDiffBrowser methodsFor:'actions'!

acceptInLeftView
    |change|

    change := self selectedChangesInM first.
    self applyChange:change
!

acceptInRightView
    |change|

    change := self selectedChangesInM second.
    self applyChange:change
!

acceptInSingleView
    |change|

    change := self selectedChangeInA.
    change isNil ifTrue:[
	change := self selectedChangeInB
    ].
    self applyChange:change
!

applySelectedChangeInA
    self applyChange:(self selectedChangeInA)
!

applySelectedChangeInB
    self applyChange:(self selectedChangeInB)
!

methodInADoubleClicked:index
"/    |change|
"/
"/    change := self changeSetA at:index.
"/    self browseChange:change
    self browseClassInA
!

methodInBDoubleClicked:index
"/    |change|
"/
"/    change := self changeSetB at:index.
"/    self browseChange:change
    self browseClassInB
!

methodInChangedDoubleClicked:index
    self browseClassInM.
!

removeSelectedChangeInBFromImage
    |change cls sel op|

    change := self selectedChangeInB.
    change isMethodChange ifTrue:[
	(cls := change changeClass) notNil ifTrue:[
	    (sel := change selector) notNil ifTrue:[
		RefactoryChangeManager notNil ifTrue:[
		    op := RemoveMethodChange remove:sel from:cls.
		    RefactoryChangeManager performChange: op.
		] ifFalse:[
		    cls removeSelector:sel
		]
	    ]
	]
    ]

    "Modified: / 15-08-2010 / 21:35:00 / cg"
!

showLogMessages
    "the UI shows code-diffs if any change is selected, and version log entries otherwise.
     But there is no way to deselect any of the method-change-lists, to go back to log-messages,
     once a method has been looked at.
     This view-menu entry helps."

    methodsOnlyInASelection value:nil.
    methodsOnlyInBSelection value:nil.
    methodsChangedSelection value:nil.
! !

!VersionDiffBrowser methodsFor:'aspects'!

boxAVisible
    boxAVisible isNil ifTrue:[
	boxAVisible := true asValue.
    ].
    ^ boxAVisible.
!

boxBVisible
    boxBVisible isNil ifTrue:[
	boxBVisible := true asValue.
    ].
    ^ boxBVisible.
!

boxMVisible
    boxMVisible isNil ifTrue:[
	boxMVisible := true asValue.
    ].
    ^ boxMVisible.
!

canIncludeExtensionsHolder
    "can include extensions ? (menu item enabler)"

    canIncludeExtensionsHolder isNil ifTrue:[
	canIncludeExtensionsHolder := true asValue.
    ].
    ^ canIncludeExtensionsHolder.
!

changedLabelHolder
    "
    aspect for the label of the changed method box.

    <return: ValueHolder on: nil>
    "

    changedLabelHolder isNil ifTrue:[
	changedLabelHolder := ValueHolder new.
    ].
    ^ changedLabelHolder.
!

diffTextLabelA
    "
    aspect for the label for version A.

    <return: ValueHolder on: nil>
    "

    diffTextLabelA isNil ifTrue:[
	diffTextLabelA := ValueHolder new.
    ].
    ^ diffTextLabelA.
!

diffTextLabelB
    "
    aspect for the label for version B.

    <return: ValueHolder on: nil>
    "

    diffTextLabelB isNil ifTrue:[
	diffTextLabelB := ValueHolder new.
    ].
    ^ diffTextLabelB.
!

diffTextView
    "
    return the component for the diff text view.

    <return: HVScrollableView>
    "
    |v|

    diffTextView isNil ifTrue:[
        v := DiffCodeView new.
        v textViewClass:CodeView.
        v initialize.
        diffTextView := HVScrollableView
                           forView:v
                           miniScrollerH:true miniScrollerV:false.
        diffTextView addNextPreviousButtons.
    ].
    ^ diffTextView

    "Modified: / 06-10-2006 / 14:30:42 / cg"
!

includeCategoryChanges
    ^ self includeCategoryChangesHolder value

    "Created: / 17-07-2012 / 18:22:34 / cg"
!

includeCategoryChanges:aBoolean
    self includeCategoryChangesHolder value:aBoolean

    "Created: / 17-07-2012 / 17:50:41 / cg"
!

includeCategoryChangesHolder
    includeCategoryChangesHolder isNil ifTrue:[
        includeCategoryChangesHolder := true asValue.
        includeCategoryChangesHolder addDependent:self.
    ].
    ^ includeCategoryChangesHolder.

    "Modified: / 06-03-2012 / 15:36:52 / cg"
    "Created: / 17-07-2012 / 16:47:58 / cg"
!

includeExtensions
    ^ self includeExtensionsHolder value

    "Created: / 13-09-2011 / 11:48:51 / cg"
!

includeExtensions:aBoolean
    self includeExtensionsHolder value:aBoolean

    "Created: / 13-09-2011 / 11:48:41 / cg"
!

includeExtensionsHolder
    "only compare base-methods or include extensions ?"

    includeExtensionsHolder isNil ifTrue:[
	includeExtensionsHolder := false asValue.
	includeExtensionsHolder addDependent:self.
    ].
    ^ includeExtensionsHolder.

    "Modified: / 06-03-2012 / 15:36:52 / cg"
!

includeVersionMethods
    ^ self includeVersionMethodsHolder value

    "Created: / 13-09-2011 / 11:48:51 / cg"
!

includeVersionMethods:aBoolean
    self includeVersionMethodsHolder value:aBoolean

    "Created: / 13-09-2011 / 11:48:41 / cg"
!

includeVersionMethodsHolder
    includeVersionMethodsHolder isNil ifTrue:[
        includeVersionMethodsHolder := true asValue.
        includeVersionMethodsHolder addDependent:self.
    ].
    ^ includeVersionMethodsHolder.

    "Modified: / 06-03-2012 / 15:36:52 / cg"
    "Created: / 17-07-2012 / 16:47:58 / cg"
!

infoHolder
    infoHolder isNil ifTrue:[
	infoHolder := ValueHolder new.
    ].
    ^ infoHolder.
!

methodText
    "
    aspect for the text in the method text view.

    <return: ValueHolder on: nil>
    "

    methodText isNil ifTrue:[
	methodText := ValueHolder new.
    ].
    ^ methodText.
!

methodsChanged
    "
    aspect for the 'changed method' list.

    <return: List>
    "

    methodsChanged isNil ifTrue:[
	methodsChanged := List new.
    ].
    ^ methodsChanged.
!

methodsChangedSelection
    "
    aspect for the selection holder of 'changed method'-list.

    <return: ValueHolder on: nil>
    "

    methodsChangedSelection isNil ifTrue:[
	methodsChangedSelection := ValueHolder new.
    ].
    ^ methodsChangedSelection.
!

methodsOnlyInA
    "aspect for the 'method only in version A' list."

    methodsOnlyInA isNil ifTrue:[
	methodsOnlyInA := List new.
    ].
    ^ methodsOnlyInA.

    "Modified: / 25-07-2006 / 11:14:43 / cg"
!

methodsOnlyInASelection
    "aspect for the selection holder of 'method only in version A'-list."

    methodsOnlyInASelection isNil ifTrue:[
	methodsOnlyInASelection := ValueHolder new.
    ].
    ^ methodsOnlyInASelection.

    "Modified: / 25-07-2006 / 11:14:53 / cg"
!

methodsOnlyInB
    "aspect for the 'method only in version B' list"

    methodsOnlyInB isNil ifTrue:[
	methodsOnlyInB := List new.
    ].
    ^ methodsOnlyInB.

    "Modified: / 25-07-2006 / 11:14:48 / cg"
!

methodsOnlyInBSelection
    "aspect for the selection holder of 'method only in version B'-list."

    methodsOnlyInBSelection isNil ifTrue:[
	methodsOnlyInBSelection := ValueHolder new.
    ].
    ^ methodsOnlyInBSelection.

    "Modified: / 25-07-2006 / 11:15:00 / cg"
!

onlyInALabelHolder
    "aspect for the label for 'method only in version A'."

    onlyInALabelHolder isNil ifTrue:[
	onlyInALabelHolder := ValueHolder new.
    ].
    ^ onlyInALabelHolder.

    "Modified: / 25-07-2006 / 11:15:12 / cg"
!

onlyInBLabelHolder
    "aspect for the label for 'method only in version B'."

    onlyInBLabelHolder isNil ifTrue:[
	onlyInBLabelHolder := ValueHolder new.
    ].
    ^ onlyInBLabelHolder.

    "Modified: / 25-07-2006 / 11:15:07 / cg"
!

selectedSymbolicVersionHolder
    selectedSymbolicVersionHolder isNil ifTrue:[
        selectedSymbolicVersionHolder := nil asValue.
        selectedSymbolicVersionHolder onChangeSend:#selectedSymbolicVersionHolderChanged to:self.
    ].
    ^ selectedSymbolicVersionHolder
!

selectedVersionHolder
    selectedVersionHolder isNil ifTrue:[
        selectedVersionHolder := nil asValue.
        selectedVersionHolder onChangeSend:#selectedVersionHolderChanged to:self.
    ].
    ^ selectedVersionHolder
!

symbolicVersionList
    symbolicVersionList isNil ifTrue:[
         symbolicVersionList := List new.
    ].
    ^ symbolicVersionList
!

versionList
    versionList isNil ifTrue:[
         versionList := List new.
    ].
    ^ versionList
! !

!VersionDiffBrowser methodsFor:'aspects-exported'!

changedLabelHolder:aValueHolder
    builder aspectAt:#changedLabelHolder put:aValueHolder.

!

classHolder:aValueHolder
    classHolder notNil ifTrue:[
	classHolder removeDependent:self
    ].
    classHolder := aValueHolder.
    classHolder notNil ifTrue:[
	classHolder addDependent:self
    ]
!

onlyInALabelHolder:aValueHolder
    builder aspectAt:#onlyInALabelHolder put:aValueHolder.
!

onlyInBLabelHolder:aValueHolder
    builder aspectAt:#onlyInBLabelHolder put:aValueHolder.
!

versionAHolder:aValueHolder
    versionAHolder notNil ifTrue:[
	versionAHolder removeDependent:self
    ].
    versionAHolder := aValueHolder.
    versionAHolder notNil ifTrue:[
	versionAHolder addDependent:self
    ]
!

versionBHolder:aValueHolder
    versionBHolder notNil ifTrue:[
	versionBHolder removeDependent:self
    ].
    versionBHolder := aValueHolder.
    versionBHolder notNil ifTrue:[
	versionBHolder addDependent:self
    ]
! !

!VersionDiffBrowser methodsFor:'aspects-menu'!

canAcceptInCodeView
    ^ self hasChangeSelectedInA
      or:[self hasChangeSelectedInB
      or:[self hasChangeSelectedInM]]
!

hasChangeSelectedInA
    ^ self selectedChangeInA notNil
!

hasChangeSelectedInB
    ^ self selectedChangeInB notNil
!

hasChangeSelectedInM
    ^ self methodsChangedSelection value notNil
! !

!VersionDiffBrowser methodsFor:'change & update'!

methodsChangedSelectionChanged
    "
    the selection in the list of the 'changed methods' changed.
    Reset the selection of the two other lists and calc the method change.

    <return: self>
    "
    |sel changeA changeB methodsChanged parseError treeA treeB|

    self infoHolder value:''.

    sel := self methodsChangedSelection value.
    sel notNil ifTrue:[
        self methodsOnlyInASelection value:nil.
        self methodsOnlyInBSelection value:nil.
        methodsChanged := self classChangeSet methodsChanged.
        changeA := (methodsChangedFiltered at:sel) first.
        changeB := (methodsChangedFiltered at:sel) second.
        self withReadCursorDo:[
            "/ see if the semantics have changed (or only prettyPrinted)
            RBParser notNil ifTrue:[
                (classChangeSet notNil
                and:[ classChangeSet classBeingCompared notNil ]) ifTrue:[
                    parseError := false.
                    treeA := RBParser parseMethod:changeA source onError: [:str :pos | parseError := true].
                    treeB := RBParser parseMethod:changeB source onError: [:str :pos | parseError := true].
                    parseError ifFalse:[
                        (treeA "semanticallyEqualTo:" equalTo:treeB withMapping:(Dictionary  new)) ifTrue:[
                            self infoHolder value:'Methods only differ in formatting / comments.'.
                        ]
                    ]
                ].
            ].
            self diffTextView
                text1:(changeA prettyPrintedSource) 
                text2:(changeB prettyPrintedSource)        
        ].
        self showDiffTextView.
        self diffTextView moveToNextChanged
    ] ifFalse:[
        self showVersionInfoIfNothingSelected
    ]

    "Modified: / 03-09-1999 / 15:01:30 / ps"
    "Modified: / 17-07-2012 / 18:27:06 / cg"
!

methodsOnlyInASelectionChanged
    "
    the selection in the list of the 'method only in version A' changed.
    Reset the selection of the two other lists and show the method in
    the text view.

    <return: self>
    "
    |change sel|

    self infoHolder value:''.

    sel := self methodsOnlyInASelection value.
    sel notNil ifTrue:[
        self methodsOnlyInBSelection value:nil.
        self methodsChangedSelection value:nil.
        change := methodsOnlyInAFiltered "self changeSetA" at:sel.
        self methodText value:(change prettyPrintedSource).
        self showSingleTextView.
    ] ifFalse:[
        self showVersionInfoIfNothingSelected
    ].

    "Modified: / 17-07-2012 / 18:31:22 / cg"
!

methodsOnlyInBSelectionChanged
    "
    the selection in the list of the 'method only in version B' changed.
    Reset the selection of the two other lists and show the method in
    the text view.

    <return: self>
    "
    |change sel|

    self infoHolder value:''.

    sel := self methodsOnlyInBSelection value.
    sel notNil ifTrue:[
        self methodsOnlyInASelection value:nil.
        self methodsChangedSelection value:nil.
        change := methodsOnlyInBFiltered "self changeSetB" at:sel.
        self methodText value:(change prettyPrintedSource).
        self showSingleTextView.
    ] ifFalse:[
        self showVersionInfoIfNothingSelected
    ].

    "Modified: / 17-07-2012 / 18:31:32 / cg"
!

selectedSymbolicVersionHolderChanged
    self selectedVersionHolder 
        value:(symbolicToVersionMapping at:( self selectedSymbolicVersionHolder value ))
!

selectedVersionHolderChanged

    self withWaitCursorDo:[
        |idx prevSelectionIndexA prevSelectionIndexB prevSelectionIndexDifferent
         previousChange previousClass previousSelector|

        "/ remember the previous selected method
        (prevSelectionIndexA := methodsOnlyInASelection value) notNil ifTrue:[
            previousChange := methodsOnlyInAFiltered at:prevSelectionIndexA.
        ].
        (prevSelectionIndexB := methodsOnlyInBSelection value) notNil ifTrue:[  
            previousChange := methodsOnlyInBFiltered at:prevSelectionIndexB.
        ].
        (prevSelectionIndexDifferent := methodsChangedSelection value) notNil ifTrue:[  
            previousChange := (methodsChangedFiltered at:prevSelectionIndexDifferent) first.
        ].
        previousChange notNil ifTrue:[
            previousClass := previousChange className.
            previousSelector := previousChange selector.
        ].

        "/ possibly expand a contracted list
        selectedVersionHolder value = '...' ifTrue:[
            idx := self versionList size.
            self updateVersionList.
            selectedVersionHolder setValue:(self versionList at:idx).
        ].

        "/ update the view
        self 
            setupForClass:classHolder value 
            againstVersion:(selectedVersionHolder value).

        "/ try to reselect the same method again.
        previousChange notNil ifTrue:[
            "/ search a change for that in the three lists

            (idx := methodsChangedFiltered findFirst:[:entry | entry first className = previousClass
                                                       and:[ entry first selector = previousSelector]]) ~= 0
            ifTrue:[
                methodsChangedSelection value:idx. self methodsChangedSelectionChanged.
            ] ifFalse:[
                (idx := methodsOnlyInAFiltered findFirst:[:chg | chg className = previousClass
                                                       and:[ chg selector = previousSelector]]) ~= 0
                ifTrue:[
                    methodsOnlyInASelection value:idx. self methodsOnlyInASelectionChanged
                ] ifFalse:[
                    (idx := methodsOnlyInBFiltered findFirst:[:chg | chg className = previousClass
                                                          and:[ chg selector = previousSelector]]) ~= 0
                    ifTrue:[
                        methodsOnlyInBSelection value:idx. self methodsOnlyInBSelectionChanged.
                    ]
                ]
            ].
        ].
        self showVersionInfoIfNothingSelected
    ]
!

update:something with:parameter from:changedObject
    ((changedObject == includeExtensionsHolder)
    or:[ changedObject == includeCategoryChangesHolder
    or:[ changedObject == includeVersionMethodsHolder ]]) ifTrue:[
        self updateLists.
         ^ self
    ].

    (changedObject == classHolder
    or:[changedObject == versionAHolder
    or:[changedObject == versionBHolder]]) ifTrue:[
        self setupForClass:(classHolder value) versionA:(versionAHolder value) versionB:(versionBHolder value).
        ^ self
    ].
    super update:something with:parameter from:changedObject

    "Modified: / 17-07-2012 / 17:48:58 / cg"
! !

!VersionDiffBrowser methodsFor:'initialization & release'!

postBuildWith:aBuilder
    "
    components which are invisible should be ignored by the panel.
    Cannot be set via the interface builder.

    <return: self>
    "

    (self componentAt:#TopHorizontalPanel) ignoreInvisibleComponents:true.
    super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.

    self isMultipleVersionBrowser ifTrue:[
        self withWaitCursorDo:[
            self updateVersionList.
        ]
    ]
! !

!VersionDiffBrowser methodsFor:'menu action'!

browseChange:aChange
    "browse the change in aChange"

    |cls sel m browserClass|

    aChange isNil ifTrue:[^ self].
    browserClass := UserPreferences systemBrowserClass.

    cls := aChange changeClass.
    cls isNil ifTrue:[
        Dialog information:'The class is not present in the image'.
        ^ self
    ].
    aChange isMethodChange ifTrue:[
        sel := aChange changeSelector.
"/        (cls compiledMethodAt:sel) isNil ifTrue:[
"/            (self confirm:'Method does not exist.\\Browse Class ?' withCRs) ifTrue:[
"/                browserClass openInClass:cls
"/            ].
"/            sel := nil.
"/        ]
    ].
    self withWaitCursorDo:[
        browserClass openInClass:cls selector:sel.
    ]

    "Modified: / 12-10-2006 / 23:58:40 / cg"
!

browseClassInA
    "browse the selected method."
    self browseChange:(self selectedChangeInA).

    "Modified: / 25-07-2006 / 11:14:02 / cg"
!

browseClassInB
    "browse the selected method."
    self browseChange:(self selectedChangeInB).

    "Modified: / 25-07-2006 / 11:13:58 / cg"
!

browseClassInM
    "browse the selected method."

    self browseChange:(self selectedChangesInM first).

    "Modified: / 25-07-2006 / 11:13:54 / cg"
!

createPatchFile
    "create a patchFile, to patch the old version (versionA) into the new version (versionB).
     I.e. a little changeFile to transport those changes."

    |defaultName diffSet f oldVersion newVersion vsnMthdA vsnMthdB vsnA vsnB info classBeingCompared|

self warn:'Sorry: This function is not yet implemented'.
    defaultName := 'patchFile.chg'.

    classBeingCompared := classChangeSet classBeingCompared.
    defaultName := '%1-%2-to-%3.chg'
                        bindWith:(classBeingCompared isNil ifTrue:['unknown'] ifFalse:[classBeingCompared nameWithoutPrefix])
                        with:(classChangeSet versionA ? 'old')
                        with:(classChangeSet versionB ? 'new').
    f := Dialog
            requestFileNameForSave:'Name of patchFile:'
            default:defaultName.
self halt.
    diffSet := classChangeSet diffSet.
^ self.

"/    vsnMthdA := self changeSetA
"/                detect:[:ch | ch isMethodChange
"/                              and:[ch changeClass isMeta
"/                              and:[ch changeSelector = #version]]]
"/                ifNone:nil.
"/    vsnMthdB := self changeSetA
"/                detect:[:ch | ch isMethodChange
"/                              and:[ch changeClass isMeta
"/                              and:[ch changeSelector = #version]]]
"/                ifNone:nil.
"/
"/    vsnMthdA notNil ifTrue:[
"/        "/ extract the version
"/        vsnA := Class revisionStringFromSource:vsnMthdA source.
"/        vsnA notNil ifTrue:[
"/            info := Class revisionInfoFromString:vsnA.
"/            info notNil ifTrue:[
"/                vsnA := info at:#revision ifAbsent:nil.
"/            ] ifFalse:[
"/                vsnA := nil.
"/            ].
"/        ].
"/    ].
"/    vsnMthdB notNil ifTrue:[
"/        "/ extract the version
"/        vsnB := Class revisionStringFromSource:vsnMthdB source.
"/        vsnB notNil ifTrue:[
"/            info := Class revisionInfoFromString:vsnB.
"/            info notNil ifTrue:[
"/                vsnB := info at:#revision ifAbsent:nil.
"/            ] ifFalse:[
"/                vsnB := nil.
"/            ].
"/        ].
"/    ].
"/
"/    (vsnA isNil or:[vsnB isNil or:[vsnA = vsnB]]) ifTrue:[
"/        self warn:'The generated patch file will not be able to validate/update the class version'.
"/    ].
"/
"/self halt:'not yet finished'.

    "Modified: / 27-10-2010 / 11:34:58 / cg"
!

inspectSelectedChangeInA
    "inspect the selected method change for the 'method only in version A'."

    self selectedChangeInA inspect.

    "Modified: / 25-07-2006 / 11:13:30 / cg"
!

inspectSelectedChangeInB
    "inspect the selected method change for the 'method only in version B'."

    self selectedChangeInB inspect.

    "Modified: / 25-07-2006 / 11:13:22 / cg"
!

inspectSelectedChangeInM
    "inspect the two method changes for the selected 'changed method'."

    |changes|

    changes := self selectedChangesInM.
    changes do:[:change |
	change inspect
    ].

    "Modified: / 25-07-2006 / 11:13:13 / cg"
!

mainMenu
    "if this application runs as an subapplication,
     the menu bar should not be used."

    self masterApplication isNil ifTrue:[
	^ self class mainMenu
    ].
    ^ nil

    "Modified: / 25-07-2006 / 11:13:44 / cg"
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#VERSIONDIFF'
!

removeClassFromChangeSet
    |cls ok changedClasses|

    classChangeSet notNil ifTrue:[
        "/ only do if we compare a single class
        (cls := classChangeSet classBeingCompared) notNil ifTrue:[
            ok := classChangeSet diffSet isEmptyOrNil.
            ok ifFalse:[
                changedClasses := classChangeSet diffSet changedClasses.
                (changedClasses size == 1
                and:[ changedClasses anElement theNonMetaclass == cls theNonMetaclass]) ifTrue:[
                    (methodsChangedFiltered isEmptyOrNil
                    and:[ methodsOnlyInAFiltered isEmptyOrNil
                    and:[ methodsOnlyInBFiltered isEmptyOrNil ]]) ifTrue:[
                        ok := true.
                    ]
                ]
            ].
            ok ifTrue:[
                ChangeSet current condenseChangesForClass:cls
            ].
        ].
    ].
! !

!VersionDiffBrowser methodsFor:'private'!

addAcceptToTextViewMenus
    "add to the standard diff text view or single text views menu an accept entry.
     The acceptAction will fetch the corresponding change and apply it
     (not the shown text)

     <return: self>
    "

    |diffTextView leftView rightView singleView|

    diffTextView := self diffTextView.
    leftView := diffTextView leftTextView.
    rightView := diffTextView rightTextView.
    singleView := self componentAt:#singleTextView.

    (Array
        with:leftView
        with:rightView
        with:singleView)
    do:[:v |
        |mGen|

        mGen := [
            |m|

            m := v editMenu.

            (m selectorAt:#accept) isNil ifTrue:[
                m addLabels:(resources array:#('-' 'Accept'))
                  selectors:#(nil #accept)
                  after:#copySelection.
            ].
            m
                actionAt:#accept
                put:[
                    v == singleView ifTrue:[
                        self acceptInSingleView
                    ] ifFalse:[
                        v == leftView ifTrue:[
                           self acceptInLeftView
                        ] ifFalse:[
                           self acceptInRightView
                        ].
                    ].
                ].
            m selectorAt:#accept put:nil.
            m enable:#copySelection.
            m setEnable:#accept to:[self canAcceptInCodeView].
            m
        ].
        v menuHolder:mGen.
        v menuMessage:#value.
    ]
!

applyChange:change
    change notNil ifTrue:[
	change apply
    ]
!

printStringForChange:aChange
    "generate a print string for a change."

    |m changeClassName classOrMetaString useChangesString selectorString
     singleComparedClass singleComparedClassesName singleComparedMetaclassesName
     printString class1 class2|

    class1 := self classChangeSet class1BeingCompared.
    class2 := self classChangeSet class2BeingCompared.

    (singleComparedClass := self classBeingCompared) notNil ifTrue:[
        singleComparedClassesName := singleComparedClass name.
        singleComparedMetaclassesName := singleComparedClass theMetaclass name.
    ].

    aChange isClassDefinitionChange ifTrue:[
        ^ aChange printStringWithoutClassName
    ].
    aChange isDoIt ifTrue:[
        ^ aChange source , ' (doIt)'
    ].
    aChange isNameSpaceCreationChange ifTrue:[
        ^ aChange source
    ].

    changeClassName := aChange className.
    changeClassName isNil ifTrue:[
        ^ aChange source
    ].

    useChangesString := false.
    classOrMetaString := ''.

    (class1 notNil 
    and:[ class2 notNil
    and:[ class1 ~= class2 ]]) ifTrue:[
        changeClassName := ''.
    ] ifFalse:[
        (changeClassName = singleComparedClassesName) ifTrue:[
            "/ changeClassName := ''.
            useChangesString := true.
        ] ifFalse:[
            (changeClassName = singleComparedMetaclassesName) ifTrue:[
                "/ classOrMetaString := ' class'.
                useChangesString := true.
            ] ifFalse:[
                ((changeClassName includes:$:) and:[ changeClassName startsWith:((singleComparedClassesName ? ''),'::') ]) ifTrue:[
                    changeClassName := changeClassName copyFrom:(singleComparedClassesName,'::') size+1.
                ].
            ].
        ].
    ].

    selectorString := ''.
    (aChange isMethodChange) ifTrue:[
        selectorString := aChange selector.

        aChange changeClass notNil ifTrue:[
            m := aChange changeMethod.
            m notNil ifTrue:[
                m := m originalMethodIfWrapped.
                selectorString := m printStringForBrowserWithSelector:aChange selector inClass:aChange changeClass.
            ].
        ].
        changeClassName notEmptyOrNil ifTrue:[
            selectorString := ' » ',selectorString
        ]
    ].

    printString := changeClassName,classOrMetaString,selectorString.
    aChange isMethodCategoryChange ifTrue:[
        ^ printString, ' (category)'
    ].
    ^ printString

    "Modified: / 17-07-2012 / 18:43:27 / cg"
!

resetSelectionHolders
    "
    reset all selection holders when a new change set is given.
    First set the selection to nil.

    <return: self>
    "

    self methodsChangedSelection value:nil.
    self methodsOnlyInASelection value:nil.
    self methodsOnlyInBSelection value:nil.
    self diffTextView text1:'' text2:''.
    self methodText value:''.

"/    self methodsChangedSelectionChanged.
"/    self methodsOnlyInASelectionChanged.
"/    self methodsOnlyInBSelectionChanged.
!

showDiffTextView
    "
    if a method change is selected, then show the diff text view.
    Add an accept entry to the popup menu.

    <return: self>
    "

    (self componentAt:#diffTextViewBox) raise; beVisible.
    (self componentAt:#singleTextView) beInvisible.
    (self componentAt:#diffTextView) realizeAllSubViews.

    self addAcceptToTextViewMenus.
!

showSingleTextView
    "
    if a method  is selected which is only in version A or B of the class,
    then show the text view.
    Add an accept entry to the popup menu.

    <return: self>
    "

    (self componentAt:#singleTextView) raise; beVisible.
    (self componentAt:#diffTextViewBox) beInvisible.
    self addAcceptToTextViewMenus.
!

showVersionInfoIfNothingSelected
    "show the revision info (author, date, time and logMessage), if no method is selected"

    |revInfo infoText|

    self infoHolder value:''.

    (methodsOnlyInASelection value isNil
    and:[ methodsOnlyInBSelection value isNil
    and:[ methodsChangedSelection value isNil ]]) ifTrue:[
        revInfo := versionInfoList detect:[:info | (info at:#revision) = selectedVersionHolder value] ifNone:nil.
        revInfo notNil ifTrue:[
            infoText := 'Revision: %1\Author:   %2\Date:     %3\Log:\\%4' withCRs
                            bindWith:(revInfo at:#revision) 
                            with:(revInfo at:#author) 
                            with:(revInfo at:#date)
                            with:(revInfo at:#logMessage).
        ].
        self methodText value:infoText.
        self showSingleTextView.
    ].
!

updateLabels
    "update the labels of the diff text view. Show the version numbers
     of the class."

    |theVersionA theVersionB builder makeLabel|

    makeLabel :=
        [:theVersion |
            |label date author revInfo|
            
            label := theVersion.
            versionInfoList notNil ifTrue:[
                revInfo := versionInfoList detect:[:info | (info at:#revision) = theVersion] ifNone:nil.
                revInfo notNil ifTrue:[
                    date := (Timestamp readGeneralizedFrom:(revInfo at:#date)) asDate.
                    author := (revInfo at:#author) ? '?'.
                    label := theVersion , ' [',date printString,' by ',author,']'.
                ].
            ].
            label
        ].
        
    builder := self builder.
    (theVersionA := self versionA) notNil ifTrue:[
        self diffTextLabelA value:(makeLabel value:theVersionA).
        self onlyInALabelHolder value:('Only in ' , theVersionA).
        (self componentAt:#OnlyInALabel)
            foregroundColor:Color white;
            backgroundColor:Color green darkened.
    ].
    (theVersionB :=self versionB) notNil ifTrue:[
        self diffTextLabelB value:(makeLabel value:theVersionB).
        self onlyInBLabelHolder value:('Only in ' , theVersionB).
        (self componentAt:#OnlyInBLabel)
            foregroundColor:Color white;
            backgroundColor:Color red darkened.
    ].

    self changedLabelHolder value:('Different').

    "Modified: / 13-10-2006 / 01:07:08 / cg"
!

updateLists
    "walk over the changeSet and setup the 3 lists:
     onlyInA, changed, onlyInB,
     Optionally filter extensions, categoryChanges and versionMethods"

    |classChangeSet listOnlyInA listOnlyInB listChanged
     printStringGenerator sortBlockForChangeLists filteredList
     isIgnoredChange numIgnoredExtensions numIgnoredVersionMethods 
     info needFilter|

    classChangeSet := self classChangeSet.

    printStringGenerator := [:aChange | self printStringForChange:aChange].
    sortBlockForChangeLists := [:a :b | (printStringGenerator value:a) < (printStringGenerator value:b)].

    numIgnoredExtensions := numIgnoredVersionMethods := 0.
    needFilter := self includeExtensions not 
                  or:[self includeCategoryChanges not
                  or:[self includeVersionMethods not]].

    needFilter ifTrue:[
        isIgnoredChange :=
            [:change |
                |packageOfMethodInChange packageOfMethodInImage changeMethod ignored|

                ignored := false.
                change isMethodCodeChange ifTrue:[
                    self includeExtensions ifFalse:[
                        packageOfMethodInChange := change package.
                        (packageOfMethodInChange notNil
                          and:[ packageOfMethodInChange ~= PackageId noProjectID
                          and:[ change changeClass notNil 
                                and:[ packageOfMethodInChange ~= change changeClass package ]]]) ifTrue:[
                            ignored := true
                        ].

                        changeMethod := change changeMethod.
                        changeMethod notNil ifTrue:[
                            packageOfMethodInImage := changeMethod package.
                            (true "packageOfMethodInImage notNil"
                              and:[ packageOfMethodInImage ~= PackageId noProjectID
                              and:[ packageOfMethodInImage ~= changeMethod mclass package ]]) ifTrue:[
                                ignored := true
                            ].
                        ].
                        numIgnoredExtensions := numIgnoredExtensions + (ignored ifTrue:[1] ifFalse:[0]).
                    ].
                    self includeVersionMethods ifFalse:[
                        (change isMethodChangeForVersionMethod
                        or:[ change isMethodChangeForExtensionsVersionMethod ]) ifTrue:[
                            ignored := true.
                            numIgnoredVersionMethods := numIgnoredVersionMethods + 1
                        ].
                    ].
                ] ifFalse:[
                    change isMethodCategoryChange ifTrue:[
                        self includeCategoryChanges ifFalse:[
                            ignored := true
                        ]
                    ].
                ].
                ignored.
            ].
    ] ifFalse:[
        isIgnoredChange := [:change | false].
    ].

    listOnlyInA := filteredList := self methodsOnlyInA.
    listOnlyInA removeAll.
    classChangeSet notNil ifTrue:[
        "/ classChangeSet methodsOnlyInA sort:sortBlockForChangeLists.
        filteredList := classChangeSet methodsOnlyInA reject:isIgnoredChange.
        listOnlyInA addAll: (filteredList collect:printStringGenerator).
    ].
    methodsOnlyInAFiltered := filteredList.

    listOnlyInB := filteredList := self methodsOnlyInB.
    listOnlyInB removeAll.
    classChangeSet notNil ifTrue:[
        "/ classChangeSet methodsOnlyInB sort:sortBlockForChangeLists.
        filteredList := classChangeSet methodsOnlyInB reject:isIgnoredChange.
        listOnlyInB addAll: (filteredList collect:printStringGenerator).
    ].
    methodsOnlyInBFiltered := filteredList.

    listChanged := filteredList := self methodsChanged.
    listChanged removeAll.
    classChangeSet notNil ifTrue:[
        "/ classChangeSet methodsChanged sort:[:a :b | sortBlockForChangeLists value:a first value:b first].
        filteredList := classChangeSet methodsChanged reject:[:entry | isIgnoredChange value:entry first].
        listChanged addAll: (filteredList collect:[:entry| printStringGenerator value:(entry first)]).
    ].
    methodsChangedFiltered := filteredList.

    self boxAVisible value:(listOnlyInA notEmpty).
    self boxBVisible value:(listOnlyInB notEmpty).

    self boxMVisible value:(listChanged isEmpty
                            and: [(listOnlyInA notEmpty
                                  or:[listOnlyInB notEmpty])]) not.

    info := ''.
    numIgnoredExtensions ~~ 0 ifTrue:[
        info := info , ('%1 extension methods ignored. ' bindWith:numIgnoredExtensions).
    ].
    numIgnoredVersionMethods ~~ 0 ifTrue:[
        info := info , ('%1 version methods ignored.' bindWith:numIgnoredVersionMethods).
    ].
    self infoHolder value:info

    "Modified: / 17-07-2012 / 18:34:36 / cg"
!

updateVersionList
    "asks the classes source code manager for a list of revisions;
     construct versionInfoList (containing the full info), versionList (containing version numbers only)
     and tagList (containing symbolic names only)"

    |cls sourceCodeManager numShown newNumShown numOverallRevisions
     partialLog newestRev revisions symbolicNames
     stableRevision releasedRevision tagList logMessages items|

    cls := classHolder value.
    sourceCodeManager := cls sourceCodeManager.

    numShown := versionList size - 1.
    newNumShown := (numShown + 50) max:30.
    partialLog := sourceCodeManager revisionLogOf:cls numberOfRevisions:newNumShown.

    partialLog isNil ifTrue:[
        self warn:'Could not find/access the container for class ',cls name,' in the repository.
This could be due to:
    - invalid/wrong CVS-Root setting
    - missing CVS access rights
        (no access / not logged in)
    - changed CVSRoot after compilation
        (i.e. wrong CVS-path in classes version method)
'.
        ^ nil
    ].

    numOverallRevisions := partialLog at:#numberOfRevisions.
    newestRev := partialLog at:#newestRevision.
    revisions := partialLog at:#revisions.
    
    "/ fetch the symbolic (tag) version list
    symbolicNames := partialLog at:#symbolicNames ifAbsent:[].
    symbolicNames notNil ifTrue:[
        stableRevision := symbolicNames at:'stable' ifAbsent:[].
        releasedRevision := symbolicNames at:'released' ifAbsent:[].
        tagList := ((symbolicNames associations sort:[:a :b | a key < b key "self versionString:(a value) isLessThan:(b value)"])
                     collect:[:assoc | assoc key]) reverse.
        tagList remove:'stable' ifAbsent:[].
        tagList notEmpty ifTrue:[tagList addFirst:'-'].
        tagList addFirst:'stable'.
    ].
    logMessages := Dictionary new.

    versionInfoList := revisions.

"/    items := versionInfoList collect:[:each | |rev date who flag|
"/                                    rev := each at:#revision.
"/                                    logMessages at:rev put:(each at:#logMessage).
"/                                    date := (each at:#date ifAbsent:nil) ? '?'.
"/                                    who := (each at:#author ifAbsent:nil) ? '?'.
"/                                    rev = stableRevision ifTrue:[
"/                                        flag := ' Stable' allBold.
"/                                    ] ifFalse:[rev = releasedRevision ifTrue:[
"/                                        flag := ' Released' allBold.
"/                                    ] ifFalse:[
"/                                        flag := ' '
"/                                    ]].
"/                                    rev allBold , flag, ' [' , date , ' by ' , who , ']'
"/                               ].
"/
"/    revisions := revisions collect:[:eachItem | eachItem at:#revision].
    revisions := versionInfoList collect:[:each | each at:#revision].

    revisions size < numOverallRevisions ifTrue:[
        revisions add:'...'
    ].          
    symbolicToVersionMapping := symbolicNames.
    self symbolicVersionList contents:tagList.
    self versionList contents:revisions.
! !

!VersionDiffBrowser methodsFor:'setup'!

setupForClass:aClass againstVersion:aVersionA
    "compute the class change set for the class aClass of its current version against the repository version A.
     When setting the class change set, the labels, list etc. of the receiver
     are updated."

    |changeSet|

    aClass isNil ifTrue:[
        changeSet := nil
    ] ifFalse:[
        (aClass isRealNameSpace) ifFalse:[
            aClass isLoaded ifTrue:[
                changeSet := (ClassChangeSet newForClass:aClass againstVersion:aVersionA).
            ]
        ].
    ].
    self classChangeSet:changeSet.
    aVersionA isNil ifTrue:[
        self class:aClass versionA:'Repository' versionB:'Current'.
    ] ifFalse:[
        self class:aClass versionA:aVersionA versionB:(aVersionA , 'm').
    ]
!

setupForClass:classA labelA:aLabelA andClass:classB labelB:aLabelB
    "generate the class change set from the two classes A and B.
     When setting the class change set, the labels, list etc. of the receiver
     are updated."

    |changeSet|

    changeSet := (ClassChangeSet newForClass:classA labelA:aLabelA andClass:classB labelB:aLabelB).
    self classChangeSet:changeSet
!

setupForClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB
    "generate the class change set from the two source files A and B.
     When setting the class change set, the labels, list etc. of the receiver
     are updated."

    |changeSet|

    aClass isRealNameSpace ifFalse:[
	aClass isLoaded ifTrue:[
	    changeSet := (ClassChangeSet newForClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB).
	]
    ].
    self classChangeSet:changeSet

    "Modified: / 10-11-2006 / 17:15:26 / cg"
!

setupForClass:aClass versionA:aVersionA versionB:aVersionB
    "compute the class change set for the class aClass and the versions A and B.
     When setting the class change set, the labels, list etc. of the receiver
     are updated."

    |changeSet|

    aClass isNameSpace ifFalse:[
	aClass isLoaded ifTrue:[
	    changeSet := (ClassChangeSet newForClass:aClass versionA:aVersionA versionB:aVersionB).
	]
    ].
    self classChangeSet:changeSet.
    self class:aClass versionA:aVersionA versionB:aVersionB.
!

setupForDiffSet:diffSet labelA:aLabelA labelB:aLabelB
    |changeSet|

    changeSet := (ClassChangeSet new diffSet:diffSet; labelA:aLabelA; labelB:aLabelB).
    self classChangeSet:changeSet
! !

!VersionDiffBrowser::ClassChangeSet class methodsFor:'instance creation'!

changeSetForClass:aClass
    "return a ChangeSet for the class aClass and its current source.
     The source is generated into a stream and then the change set is generated
     from the source stream."

    ^ ChangeSet forExistingClass:aClass.
!

changeSetForClass:aClass andRevision:aVersion
    "return a ChangeSet for the class aClass and version aVersion.
     The version from the class source stream is checked out from the repositiory
     into a source stream. Then the change set is generated from the source stream."

    |theSourceCodeManager theSourceStream theChangeSet|

    theSourceCodeManager := SourceCodeManagerUtilities sourceCodeManagerFor:aClass.
    [
        theSourceStream := theSourceCodeManager getSourceStreamFor:aClass revision:aVersion.
        theSourceStream notNil ifTrue:[
            theChangeSet := ChangeSet fromStream:theSourceStream
        ]
    ] ensure:[
        theSourceStream notNil ifTrue:[theSourceStream close]
    ].
    theChangeSet isNil ifTrue:[
        self error:'Could not read source of class ',aClass name mayProceed:true.
        ^ nil
    ].
    self sortChangeSet:theChangeSet.
    ^ theChangeSet

    "Modified: / 12-09-2006 / 14:24:51 / cg"
!

changeSetForClass:aClass andSource:aSource
    "return a ChangeSet for the class aClass and source aSource.
     The source is converted to a stream and then the change set is generated
     from the source stream.
     Raise an error if the source stream cannot be opened."

    |theChangeSet theSourceStream|

    [
        theSourceStream := aSource readStream.
        theChangeSet := ChangeSet fromStream:(theSourceStream := aSource readStream)
    ] ensure:[
        theSourceStream notNil ifTrue:[
            theSourceStream close
        ]
    ].
    theChangeSet isNil ifTrue:[
        self error:'Could not read source of class ',aClass name mayProceed:true.
        ^ nil
    ].
    self sortChangeSet:theChangeSet.
    ^ theChangeSet
!

newForClass:aClass againstVersion:aVersionA
    "return a ClassChangeSet for the class aClass against some verson in the repository.
     A new instance of ClassChangeSet is generated containing
     the correspondenting changes."

    |theClassChangeSet|

    theClassChangeSet := self new.
    theClassChangeSet setupForClass:aClass againstVersion:aVersionA.
    ^ theClassChangeSet
!

newForClass:classA labelA:aLabelA andClass:classB labelB:aLabelB
    "return a ClassChangeSet for two classes.
     A new instance of ClassChangeSet is generated containing the correspondenting changes."

    |aStream sourceA sourceB theChangeSetA theChangeSetB theClassChangeSet|

    theClassChangeSet := self new.
    theClassChangeSet class1BeingCompared:classA class2BeingCompared:classB.
    theClassChangeSet labelA:aLabelA.
    theClassChangeSet labelB:aLabelB.

    theChangeSetA := ChangeSet forExistingClass:classA withExtensions:true withLooseMethods:true.
    theChangeSetB := ChangeSet forExistingClass:classB withExtensions:true withLooseMethods:true.
    
"/    aStream := '' writeStream.
"/    Method flushSourceStreamCache.
"/    classA fileOutOn:aStream withTimeStamp:false.
"/    sourceA := aStream contents asString.

"/    aStream := '' writeStream.
"/    Method flushSourceStreamCache.
"/    classB fileOutOn:aStream withTimeStamp:false.
"/    sourceB := aStream contents asString.

"/    theChangeSetA:=self changeSetForClass:classA andSource:sourceA.
"/    theChangeSetB:=self changeSetForClass:classB andSource:sourceB.
"/    theChangeSetA isNil ifTrue: [theChangeSetA := ChangeSet new].
"/    theChangeSetB isNil ifTrue: [theChangeSetB := ChangeSet new].

    "/ just in case (if comparing a class against another),
    "/ unify the classes of the changes (to avoid that all changes are detected as different)

"/    theChangeSetB do:[:eachChange |
"/        eachChange isMethodChange ifTrue:[
"/            eachChange changeClass isMeta ifTrue:[
"/                eachChange changeClass ~~ classA theMetaclass ifTrue:[
"/                    eachChange changeClass:classA theMetaclass.
"/                ]
"/            ] ifFalse:[
"/                eachChange changeClass ~~ classA theNonMetaclass ifTrue:[
"/                    eachChange changeClass:classA theNonMetaclass.
"/                ]
"/            ].
"/        ].
"/    ].
    "/ remove all #initialize doIts
    theChangeSetA := theChangeSetA reject:[:eachChange | eachChange isDoIt and:[eachChange isInitialize]].
    theChangeSetB := theChangeSetB reject:[:eachChange | eachChange isDoIt and:[eachChange isInitialize]].

    theClassChangeSet diffSet:(theChangeSetA diffSetsAgainst:theChangeSetB comparingDifferentClasses:true).
    ^ theClassChangeSet
!

newForClass:aClass labelA:aLabelA sourceA:aSourceA labelB:aLabelB sourceB:aSourceB
    "return a ClassChangeSet for the class aClass and the two sources.
     The two classes are compared via the source files. A new instance of
     ClassChangeSet is generated containing the correspondenting changes."

    |theChangeSetA theChangeSetB theClassChangeSet className metaClassName|

    theClassChangeSet := self new.
    theClassChangeSet classBeingCompared:aClass.
    theClassChangeSet labelA:aLabelA.
    theClassChangeSet labelB:aLabelB.
    theChangeSetA:=self changeSetForClass:aClass andSource:aSourceA.
    theChangeSetB:=self changeSetForClass:aClass andSource:aSourceB.

    className := aClass name.
    metaClassName := aClass class name.

    aClass isPrivate ifTrue:[
	theChangeSetA := theChangeSetA select:[:change | change isMethodChange not
							 or:[change className = className or:[change className = metaClassName]]].
	theChangeSetA := theChangeSetA select:[:change | change isClassDefinitionChange not
							 or:[change className = className or:[change className = metaClassName]]].
	theChangeSetA := theChangeSetA select:[:change | change isDoIt not
							 or:[change receiverClassName = className or:[change receiverClassName = metaClassName]]].
	theChangeSetB := theChangeSetB select:[:change | change isMethodChange not
							 or:[change className = className or:[change className = metaClassName]]].
	theChangeSetB := theChangeSetB select:[:change | change isClassDefinitionChange not
							 or:[change className = className or:[change className = metaClassName]]].
	theChangeSetB := theChangeSetB select:[:change | change isDoIt not
							 or:[change receiverClassName = className or:[change receiverClassName = metaClassName]]].
	"/ there might be more needed...
    ].

    theChangeSetA isNil
	ifTrue: [theChangeSetA := ChangeSet new].
    theChangeSetB isNil
	ifTrue: [theChangeSetB := ChangeSet new].

    theClassChangeSet diffSet:(theChangeSetA diffSetsAgainst:theChangeSetB).
    ^ theClassChangeSet
!

newForClass:aClass versionA:aVersionA versionB:aVersionB
    "return a ClassChangeSet for the class aClass and the two versions.
     The two class version are checked out from the repository and then being
     compared. A new instance of ClassChangeSet is generated containing
     the correspondenting changes."

    |theChangeSetA theChangeSetB theClassChangeSet|

    theClassChangeSet := self new.
    theClassChangeSet classBeingCompared:aClass.
    theClassChangeSet versionA:aVersionA.
    theClassChangeSet versionB:aVersionB.
    theClassChangeSet labelA:aVersionA.
    theClassChangeSet labelB:aVersionB.
    theChangeSetA := self changeSetForClass: aClass andRevision: aVersionA.
    theChangeSetB := self changeSetForClass: aClass andRevision: aVersionB.
    theChangeSetA isNil ifTrue: [theChangeSetA := ChangeSet new].
    theChangeSetB isNil ifTrue: [theChangeSetB := ChangeSet new].
    theClassChangeSet diffSet:(theChangeSetA diffSetsAgainst:theChangeSetB).
    ^ theClassChangeSet
!

sortChangeSet:aChangeSet
    "/ sort by meta and selector

    aChangeSet
        sort:[:a :b |
            a == b ifTrue:[
                false
            ] ifFalse:[
                a isClassDefinitionChange == b isClassDefinitionChange ifTrue:[
                    a isClassChange == b isClassChange ifTrue:[
                        a isClassChange ifTrue:[
                            a isForMeta == b isForMeta ifTrue:[
                                (a isMethodChange and:[b isMethodChange]) ifTrue:[
                                    a className < b className
                                    or:[ a className = b className
                                         and:[ a isPrimitiveChange not
                                         and:[ b isPrimitiveChange not
                                         and:[ a selector < b selector ]]]]
                                ] ifFalse:[
                                    a isMethodChange not
                                ].
                            ] ifFalse:[
                                a isForMeta
                            ].
                        ] ifFalse:[
                            a printString < b printString
                        ].
                    ] ifFalse:[
                        a isClassChange
                    ].
                ] ifFalse:[
                    a isClassDefinitionChange
                ].
            ]
        ].
! !

!VersionDiffBrowser::ClassChangeSet methodsFor:'accessing'!

class1BeingCompared
    "returns the class which is compared"

    ^ class1BeingCompared
!

class1BeingCompared:class1 class2BeingCompared:class2
    "returns the class which is compared"

    class1BeingCompared := class1.
    class2BeingCompared := class2
!

class2BeingCompared
    "returns the class which is compared"

    ^ class2BeingCompared
!

classBeingCompared
    "returns the class which is compared"

    ^ class1BeingCompared
!

classBeingCompared:something
    "set the value of the class which is compared"

    class1BeingCompared := class2BeingCompared := something.
!

diffSet
    "returns a diffSet containing the different changes.
     it responds to:

     changed         OrderedCollection of arrays containing ChangeSets for methods
		     which are changed and exists in the class versionA and versionB
     onlyInArg       ChangeSet for the methods which exists only in the class versionB
     onlyInReceiver  ChangeSet for the methods which exists only in the class versionA
    "

    ^ diffSet
!

diffSet:something
    "sets the diffSet containing the different changes.
     it responds to:

     changed         OrderedCollection of arrays containing ChangeSets for methods
		     which are changed and exists in the class versionA and versionB
     onlyInArg       ChangeSet for the methods which exists only in the class versionB
     onlyInReceiver  ChangeSet for the methods which exists only in the class versionA
    "

    diffSet := something.
!

labelA
    "returns the label for the class versionA"

    ^ labelA
!

labelA:something
   "sets the label for the class versionA"

    labelA := something.
!

labelB
    "returns the label for the class versionB"

    ^ labelB
!

labelB:something
    "sets the label for the class versionB"

    labelB := something.
!

methodsChanged
    "returns an OrderedCollection of arrays containing ChangeSets for methods
     which are changed and exists in the class versionA and versionB

     <return: OrderedCollection of Array(2)>
    "

    ^ self diffSet changed
!

methodsOnlyInA
    "returns a ChangeSet for the methods which exists only in the class versionA"

    ^ self diffSet onlyInReceiver
!

methodsOnlyInB
    "returns a ChangeSet for the methods which exists only in the class versionB"

    ^ self diffSet onlyInArg
!

versionA
    ^ versionA
!

versionA:something
    versionA := something.
!

versionB
    ^ versionB
!

versionB:something
    versionB := something.
! !

!VersionDiffBrowser::ClassChangeSet methodsFor:'misc'!

removeAllVersionMethods
    diffSet removeAllVersionMethods.
! !

!VersionDiffBrowser::ClassChangeSet methodsFor:'setup'!

setupForClass:aClass againstVersion:aVersionA
    "return a ClassChangeSet for the class aClass against some verison in the repository.
     A new instance of ClassChangeSet is generated containing
     the correspondenting changes."

    |theChangeSetA theChangeSetB versionCompared|

    self classBeingCompared:aClass.
    versionCompared := aVersionA.
    aVersionA isNil ifTrue:[
	self labelA:(versionCompared := aClass revision).
	self versionA:versionCompared.
    ] ifFalse:[
	aVersionA == #newest ifTrue:[
	    self labelA:(VersionDiffBrowser resources string:'Newest').
	] ifFalse:[
	    self labelA:versionCompared.
	    self versionA:versionCompared.
	]
    ].
    self labelB:(VersionDiffBrowser resources string:'Current').
    theChangeSetA := self class changeSetForClass: aClass andRevision: versionCompared.
    theChangeSetB := self class changeSetForClass: aClass.
    theChangeSetA isNil ifTrue: [theChangeSetA := ChangeSet new].
    theChangeSetB isNil ifTrue: [theChangeSetB := ChangeSet new].

    "/ if we are comparing a private class, prune out other changes
    aClass isPrivate ifTrue:[
	theChangeSetA removeAllSuchThat:[:aChange | aChange className ~= aClass name ].
	theChangeSetB removeAllSuchThat:[:aChange | aChange className ~= aClass name ].
    ].
    self activityNotification:'Generating diff-set...'.
    self diffSet:(theChangeSetA diffSetsAgainst:theChangeSetB).
    self activityNotification:nil.
    ^ diffSet
! !

!VersionDiffBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

