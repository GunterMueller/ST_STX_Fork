"
 Copyright (c) 2007-2010 Jan Vrany
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

ApplicationModel subclass:#ChangeSetDiffTool
	instanceVariableNames:'infoPanel diffInfoHolder listHolder singleSelectionHolder
		diffsetHolder titleHolder firstColSelectionHolder
		navigatorPanelSpecHolder diffMenuHolder diffsetHolderPrivate
		selectionHolder versionATextHolder versionBTextHolder
		versionBaseTextHolder textDiffToolHolder
		textDiffToolWindowSpecHolder mergeHolder mergeData
		mergeDataHolder showVersionMethodDiffsHolder
		showCopyrightMethodDiffsHolder highlightConflictsHolder
		hasDiffsetHolder mergeSavedHolder canSaveHolder
		autoMoveToNextConflictHolder textDiff2App textDiff3App list1App
		list2App alreadyWarnedAboutUnsavedMerge labelSpecHolder
		labelsView navigatorAndDiffPanelView codeAspectHolder'
	classVariableNames:'LastDiffInfo AutoMoveToNextConflict'
	poolDictionaries:''
	category:'Interface-Diff'
!

SimpleDialog subclass:#OpenDialog
	instanceVariableNames:'doAcceptEnabled changesetSpecAHolder changesetSpecBHolder
		changesetSpecBaseHolder changesetSpecBaseEnabledHolder
		changesetSpecMergedHolder changesetSpecMergedEnabledHolder'
	classVariableNames:'LastDirectory'
	poolDictionaries:''
	privateIn:ChangeSetDiffTool
!

!ChangeSetDiffTool class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
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
    Tool for viewing/merging differences between two change sets

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
    Tools::ChangeSetDiffTool open

								[exEnd]

  Show differences between CVS HEAD and SVN jv-branch
  NewSystemBrowser:
								[exBegin]
    | cvsCs svnCs |

    cvsCs := ChangeSet fromFile:'/home/jv/Private/Projects/SmalltalkX/sources/branches/exept@HEAD/stx/libtool/Tools__NewSystemBrowser.st'.
    svnCs := ChangeSet fromFile:'/home/jv/Private/Projects/SmalltalkX/sources/branches/jv2/build/stx/libtool/Tools__NewSystemBrowser.st'.

    Tools::ChangeSetDiffTool new
	open;
	fileMenuOpenOnDiffBetween: cvsCs and: svnCs.

								[exEnd]

  Show differences between CVS HEAD and SVN jv-branch and
  base version of NewSystemBrowser:

								[exBegin]
    | cvsBaseCs cvsCs svnCs |

    cvsBaseCs := ChangeSet fromFile:'/home/jv/Private/Projects/SmalltalkX/sources/branches/exept@2012-01-01/stx/libtool/Tools__NewSystemBrowser.st'.
    cvsCs := ChangeSet fromFile:'/home/jv/Private/Projects/SmalltalkX/sources/branches/exept@HEAD/stx/libtool/Tools__NewSystemBrowser.st'.
    svnCs := ChangeSet fromFile:'/home/jv/Private/Projects/SmalltalkX/sources/branches/jv2/build/stx/libtool/Tools__NewSystemBrowser.st'.

    Tools::ChangeSetDiffTool new
	open;
	fileMenuOpenOnDiffBetween: cvsCs and: svnCs base: cvsBaseCs

								[exEnd]



"
! !

!ChangeSetDiffTool class methodsFor:'accessing'!

autoMoveToNextConflict
    ^AutoMoveToNextConflict == true

    "Created: / 17-01-2013 / 19:49:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

autoMoveToNextConflict: aBoolean
    AutoMoveToNextConflict := aBoolean

    "Created: / 17-01-2013 / 19:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'accessing - defaults'!

versionAColor

    ^Color green lightened lightened

    "Created: / 01-11-2009 / 10:14:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBColor

    ^Color blue lightened lightened

    "Created: / 01-11-2009 / 10:14:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBaseColor

    ^Color yellow lightened lightened

    "Created: / 01-11-2009 / 10:14:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionNotPresentText
    ^ 'Not present' allItalic withColor:Color gray lighter
! !

!ChangeSetDiffTool class methodsFor:'image specs'!

mergeDiff3AToMergedArrow30x30

    ^ToolbarIconLibrary mergeDiff3AToMergedArrow30x30

    "Created: / 17-01-2013 / 23:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDiff3BToMergedArrow30x30

    ^ToolbarIconLibrary mergeDiff3BToMergedArrow30x30

    "Created: / 17-01-2013 / 23:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDiff3BaseToAArrow30x30

    ^ToolbarIconLibrary mergeDiff3BaseToAArrow30x30

    "Created: / 17-01-2013 / 23:52:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDiff3BaseToBArrow30x30

    ^ToolbarIconLibrary mergeDiff3BaseToBArrow30x30

    "Created: / 17-01-2013 / 23:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA24x24

    ^ToolbarIconLibrary versionA24x24

    "Created: / 24-03-2010 / 20:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionB24x24

    ^ToolbarIconLibrary versionB24x24

    "Created: / 24-03-2010 / 20:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBase24x24

    ^ToolbarIconLibrary versionBase24x24

    "Created: / 17-01-2013 / 22:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMerged24x24

    ^ToolbarIconLibrary versionMerged24x24

    "Created: / 17-01-2013 / 22:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'interface opening'!

open
    | tool |

    tool := self new.
    tool open.
    tool window sensor pushUserEvent: #fileMenuOpen for: tool.

    "Created: / 01-08-2012 / 15:13:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'interface specs'!

labelDiff2Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#labelDiff2Spec
     Tools::ChangeSetDiffTool new openInterface:#labelDiff2Spec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: labelDiff2Spec
	window:
       (WindowSpec
	  label: 'Label'
	  name: 'Label'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 600 60)
	)
	component:
       (SpecCollection
	  collection: (
	   (UISubSpecification
	      name: 'LabelA'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 0.5)
	      minorKey: versionALabelSpec
	    )
	   (UISubSpecification
	      name: 'LabelB'
	      layout: (LayoutFrame 0 0 0 0.5 0 1 0 1)
	      minorKey: versionBLabelSpec
	    )
	   )

	)
      )
!

labelDiff3Spec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#labelDiff3Spec
     Tools::ChangeSetDiffTool new openInterface:#labelDiff3Spec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: labelDiff3Spec
	window:
       (WindowSpec
	  label: 'Label'
	  name: 'Label'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 600 90)
	)
	component:
       (SpecCollection
	  collection: (
	   (UISubSpecification
	      name: 'LabelBase'
	      layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	      minorKey: versionBaseLabelSpec
	    )
	   (UISubSpecification
	      name: 'LabelA'
	      layout: (LayoutFrame 0 0 30 0 0 1 60 0)
	      minorKey: versionALabelSpec
	    )
	   (UISubSpecification
	      name: 'LabelB'
	      layout: (LayoutFrame 0 0 60 0 0 1 0 1)
	      minorKey: versionBLabelSpec
	    )
	   )

	)
      )
!

labelMergeSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#labelMergeSpec
     Tools::ChangeSetDiffTool new openInterface:#labelMergeSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: labelMergeSpec
	window:
       (WindowSpec
	  label: 'Label'
	  name: 'Label'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 600 120)
	)
	component:
       (SpecCollection
	  collection: (
	   (UISubSpecification
	      name: 'LabelBase'
	      layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	      minorKey: mergeBaseLabelSpec
	    )
	   (UISubSpecification
	      name: 'LabelA'
	      layout: (LayoutFrame 0 0 30 0 0 1 60 0)
	      minorKey: mergeALabelSpec
	    )
	   (UISubSpecification
	      name: 'LabelB'
	      layout: (LayoutFrame 0 0 60 0 0 1 90 0)
	      minorKey: mergeBLabelSpec
	    )
	   (UISubSpecification
	      name: 'SubSpecification1'
	      layout: (LayoutFrame 0 0 90 0 0 1 0 1)
	      minorKey: mergeMergeLabelSpec
	    )
	   )

	)
      )

    "Modified: / 17-01-2013 / 23:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffBrowser andSelector:#labelSpec
     SVN::DiffBrowser new openInterface:#labelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: labelSpec
        window: 
       (WindowSpec
          label: 'Label'
          name: 'Label'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 600 48)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'LabelA'
              layout: (LayoutFrame 0 0 0 0 0 1 0 0.5)
              minorKey: versionALabelSpec
            )
           (UISubSpecification
              name: 'LabelB'
              layout: (LayoutFrame 0 0 0 0.5 0 1 0 1)
              minorKey: versionBLabelSpec
            )
           )
         
        )
      )
!

oneColumnNavigatorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#oneColumnNavigatorSpec
     Tools::ChangeSetDiffTool new openInterface:#oneColumnNavigatorSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: oneColumnNavigatorSpec
	window:
       (WindowSpec
	  label: 'One Column Navigator'
	  name: 'One Column Navigator'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (SubCanvasSpec
	      name: 'DiffList'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      majorKey: #'Tools::ChangeSetDiffList'
	      subAspectHolders:
	     (Array

	       (SubChannelInfoSpec
		  subAspect: highlightConflictsHolder
		  aspect: highlightConflictsHolder
		)
	       (SubChannelInfoSpec
		  subAspect: inGeneratorHolder
		  aspect: diffsetHolderPrivate
		)

	       (SubChannelInfoSpec
		  subAspect: listEntryLabelGenerator
		  aspect: diffListEntryLabelGeneratorAspect
		)
	       (SubChannelInfoSpec
		  subAspect: menuHolder
		  aspect: listMenuHolder
		)

	       (SubChannelInfoSpec
		  subAspect: outGeneratorHolder
		  aspect: selectionHolder
		)
	       (SubChannelInfoSpec
		  subAspect: showCopyrightMethodDiffsHolder
		  aspect: showCopyrightMethodDiffsHolder
		)

	       (SubChannelInfoSpec
		  subAspect: showVersionMethodDiffsHolder
		  aspect: showVersionMethodDiffsHolder
		)
	      )
	      createNewApplication: true
	      createNewBuilder: false
	      postBuildCallback: list1View:
	    )
	   )

	)
      )
!

twoColumnNavigatorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#twoColumnNavigatorSpec
     Tools::ChangeSetDiffTool new openInterface:#twoColumnNavigatorSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: twoColumnNavigatorSpec
	window:
       (WindowSpec
	  label: 'Two Column Navigator'
	  name: 'Two Column Navigator'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableHorizontalPanelSpec
	      name: 'Columns'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      component:
	     (SpecCollection
		collection: (
		 (SubCanvasSpec
		    name: 'LeftList'
		    hasHorizontalScrollBar: false
		    hasVerticalScrollBar: false
		    majorKey: #'Tools::ChangeSetDiffList'
		    subAspectHolders:
		   (Array

		     (SubChannelInfoSpec
			subAspect: highlightConflictsHolder
			aspect: highlightConflictsHolder
		      )
		     (SubChannelInfoSpec
			subAspect: inGeneratorHolder
			aspect: diffsetHolderPrivate
		      )

		     (SubChannelInfoSpec
			subAspect: listEntryLabelGenerator
			aspect: diffListEntryLabelGeneratorAspect
		      )
		     (SubChannelInfoSpec
			subAspect: menuHolder
			aspect: listMenuHolder
		      )

		     (SubChannelInfoSpec
			subAspect: outGeneratorHolder
			aspect: firstColSelectionHolder
		      )
		     (SubChannelInfoSpec
			subAspect: showCopyrightMethodDiffsHolder
			aspect: showCopyrightMethodDiffsHolder
		      )

		     (SubChannelInfoSpec
			subAspect: showVersionMethodDiffsHolder
			aspect: showVersionMethodDiffsHolder
		      )
		    )
		    createNewApplication: true
		    createNewBuilder: true
		    postBuildCallback: list1View:
		  )
		 (SubCanvasSpec
		    name: 'RightList'
		    hasHorizontalScrollBar: false
		    hasVerticalScrollBar: false
		    majorKey: #'Tools::ChangeSetDiffList'
		    subAspectHolders:
		   (Array

		     (SubChannelInfoSpec
			subAspect: highlightConflictsHolder
			aspect: highlightConflictsHolder
		      )
		     (SubChannelInfoSpec
			subAspect: inGeneratorHolder
			aspect: firstColSelectionHolder
		      )

		     (SubChannelInfoSpec
			subAspect: listEntryLabelGenerator
			aspect: diffListEntryLabelGeneratorAspect
		      )
		     (SubChannelInfoSpec
			subAspect: menuHolder
			aspect: listMenuHolder
		      )

		     (SubChannelInfoSpec
			subAspect: outGeneratorHolder
			aspect: selectionHolder
		      )
		     (SubChannelInfoSpec
			subAspect: showCopyrightMethodDiffsHolder
			aspect: showCopyrightMethodDiffsHolder
		      )

		     (SubChannelInfoSpec
			subAspect: showVersionMethodDiffsHolder
			aspect: showVersionMethodDiffsHolder
		      )
		    )
		    createNewApplication: true
		    createNewBuilder: true
		    postBuildCallback: list2View:
		  )
		 )

	      )
	      handles: (Any 0.5 1.0)
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
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#windowSpec
     Tools::ChangeSetDiffTool new openInterface:#windowSpec
     Tools::ChangeSetDiffTool open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Diff Browser'
	  name: 'Diff Browser'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 1024 768)
	  menu: mainMenu
	)
	component:
       (SpecCollection
	  collection: (
	   (MenuPanelSpec
	      name: 'ToolBar'
	      layout: (LayoutFrame 0 0 0 0 0 1 30 0)
	      menu: toolbarMenu
	      textDefault: true
	    )
	   (SubCanvasSpec
	      name: 'InfoPanel'
	      layout: (LayoutFrame 0 0 30 0 0 1 70 0)
	      level: 0
	      initiallyInvisible: true
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      clientKey: infoPanel
	      createNewBuilder: false
	    )
	   (ViewSpec
	      name: 'Content'
	      layout: (LayoutFrame 0 0 30 0 0 1 0 1)
	      component:
	     (SpecCollection
		collection: (
		 (SubCanvasSpec
		    name: 'Labels'
		    layout: (LayoutFrame 0 0 0 0 0 1 60 0)
		    hasHorizontalScrollBar: false
		    hasVerticalScrollBar: false
		    specHolder: labelSpecHolder
		    createNewBuilder: false
		    postBuildCallback: labelsView:
		  )
		 (VariableVerticalPanelSpec
		    name: 'NavigatorAndDiffPanel'
		    layout: (LayoutFrame 0 0 60 0 0 1 0 1)
		    initiallyInvisible: true
		    visibilityChannel: hasDiffsetHolder
		    showHandle: true
		    component:
		   (SpecCollection
		      collection: (
		       (SubCanvasSpec
			  name: 'NavigatorPanel'
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  specHolder: navigatorPanelSpecHolder
			  createNewBuilder: false
			)
		       (SubCanvasSpec
			  name: 'SubCanvas1'
			  specHolder: textDiffToolWindowSpecHolder
			  clientHolder: textDiffToolHolder
			  createNewBuilder: false
			)
		       )

		    )
		    handles: (Any 0.3 1.0)
		    postBuildCallback: navigatorAndDiffPanelView:
		  )
		 )

	      )
	    )
	   )

	)
      )

    "Modified: / 18-01-2013 / 00:07:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'interface specs - labels'!

mergeALabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#mergeALabelSpec
     Tools::ChangeSetDiffTool new openInterface:#mergeALabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: mergeALabelSpec
	window:
       (WindowSpec
	  label: 'Version A'
	  name: 'Version A'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 79.6078431372549 90.5882352941177 69.4117647058823)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'mergeDiff3BaseToAArrow30x30'
	      name: 'Label1'
	      layout: (LayoutFrame 0 0 0 0 30 0 0 1)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'versionA24x24'
	      name: 'VersionAIcon'
	      layout: (LayoutFrame 30 0 -12 0.5 57 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'mergeDiff3AToMergedArrow30x30'
	      name: 'Label2'
	      layout: (LayoutFrame 60 0 0 0 90 0 0 1)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version A'
	      name: 'VersionALabel'
	      layout: (LayoutFrame 90 0 0 0 0 1 0 1)
	      translateLabel: true
	      labelChannel: versionALabelHolder
	      resizeForLabel: true
	      adjust: left
	    )
	   (LabelSpec
	      label: '(A)'
	      name: 'ALabel'
	      layout: (LayoutFrame -30 1 0 0 0 1 0 1)
	      translateLabel: true
	    )
	   )

	)
      )
!

mergeBLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionBLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionBLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBLabelSpec
	window:
       (WindowSpec
	  label: 'Version B'
	  name: 'Version B'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 100.0 90.5882352941177 60.0)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	    (LabelSpec
	      label: 'mergeDiff3BaseToBArrow30x30'
	      name: 'Label1'
	      layout: (LayoutFrame 0 0 0 0 30 0 0 1)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'versionB24x24'
	      name: 'VersionBIcon'
	      layout: (LayoutFrame 30 0 -12 0.5 57 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	    (LabelSpec
	      label: 'mergeDiff3BToMergedArrow30x30'
	      name: 'Label2'
	      layout: (LayoutFrame 60 0 0 0 90 0 0 1)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version B'
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 90 0 0 0 167 0 0 1)
	      translateLabel: true
	      labelChannel: versionBLabelHolder
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	     (LabelSpec
	     label: '(B)'
	     name: 'BLabel'
	     layout: (LayoutFrame -30 1 0 0 0 1 0 1)
	     translateLabel: true
	    )
	   )

	)
      )

    "Created: / 17-01-2013 / 23:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeBaseLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionBaseLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionBaseLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBaseLabelSpec
	window:
       (WindowSpec
	  label: 'Version Base'
	  name: 'Version Base'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 67.843137254902 87.843137254902 96.4705882352941)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionBase24x24'
	      name: 'VersionBIcon'
	      layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version B'
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 90 0 0 0 190 0 0 1)
	      translateLabel: true
	      labelChannel: versionBaseLabelHolder
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (LabelSpec
	      label: '(Base)'
	      name: 'BaseLabel'
	      layout: (LayoutFrame -50 1 0 0 0 1 0 1)
	      translateLabel: true
	    )
	   )

	)
      )

    "Created: / 17-01-2013 / 23:44:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeMergeLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#mergeMergeLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#mergeMergeLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: mergeMergeLabelSpec
	window:
       (WindowSpec
	  label: 'Version Merged'
	  name: 'Version Merged'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 96.2554360265507 72.7275501640345 95.8999008163577)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionMerged24x24'
	      name: 'VersionMergedIcon'
	      layout: (LayoutFrame 60 0 -12 0.5 87 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version B'
	      name: 'VersionMergedLabel'
	      layout: (LayoutFrame 90 0 0 0 267 0 0 1)
	      translateLabel: true
	      labelChannel: versionMergedLabelHolder
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (LabelSpec
	      label: '(Merge)'
	      name: 'MergedLabel'
	      layout: (LayoutFrame -70 1 0 0 0 1 0 1)
	      translateLabel: true
	    )
	   )

	)
      )
!

versionALabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionALabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionALabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionALabelSpec
        window: 
       (WindowSpec
          label: 'Version A'
          name: 'Version A'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
          backgroundColor: (Color 79.6078431372549 90.5882352941177 69.4117647058823)
          forceRecursiveBackground: true
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionA24x24'
              name: 'VersionAIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Version A'
              name: 'VersionALabel'
              layout: (LayoutFrame 30 0 0 0 0 1 0 1)
              translateLabel: true
              labelChannel: versionALabelHolder
              resizeForLabel: true
              adjust: left
            )
           (LabelSpec
              label: '(A)'
              name: 'ALabel'
              layout: (LayoutFrame -30 1 0 0 0 1 0 1)
              translateLabel: true
            )
           )
         
        )
      )
!

versionBLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionBLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionBLabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionBLabelSpec
        window: 
       (WindowSpec
          label: 'Version B'
          name: 'Version B'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
          backgroundColor: (Color 100.0 90.5882352941177 60.0)
          forceRecursiveBackground: true
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionB24x24'
              name: 'VersionBIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Version B'
              name: 'VersionBLabel'
              layout: (LayoutFrame 30 0 0 0 167 0 0 1)
              translateLabel: true
              labelChannel: versionBLabelHolder
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
             (LabelSpec
             label: '(B)'
             name: 'BLabel'
             layout: (LayoutFrame -30 1 0 0 0 1 0 1)
             translateLabel: true
            )
           )
         
        )
      )

    "Modified: / 16-12-2011 / 14:17:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBaseLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionBaseLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionBaseLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBaseLabelSpec
	window:
       (WindowSpec
	  label: 'Version Base'
	  name: 'Version Base'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 67.843137254902 87.843137254902 96.4705882352941)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionBase24x24'
	      name: 'VersionBIcon'
	      layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version B'
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 30 0 0 0 190 0 0 1)
	      translateLabel: true
	      labelChannel: versionBaseLabelHolder
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (LabelSpec
	      label: '(Base)'
	      name: 'BaseLabel'
	      layout: (LayoutFrame -50 1 0 0 0 1 0 1)
	      translateLabel: true
	    )
	   )

	)
      )
!

versionMergeLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool andSelector:#versionBaseLabelSpec
     Tools::ChangeSetDiffTool new openInterface:#versionBaseLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBaseLabelSpec
	window:
       (WindowSpec
	  label: 'Version Merged'
	  name: 'Version Merged'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 96.2554360265507 72.7275501640345 95.8999008163577)
	  forceRecursiveBackground: true
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
	      label: 'Version B'
	      name: 'VersionMergedLabel'
	      layout: (LayoutFrame 30 0 0 0 190 0 0 1)
	      translateLabel: true
	      labelChannel: versionMergedLabelHolder
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (LabelSpec
	      label: '(Merge)'
	      name: 'MergedLabel'
	      layout: (LayoutFrame -70 1 0 0 0 1 0 1)
	      translateLabel: true
	    )
	   )

	)
      )

    "Created: / 17-01-2013 / 22:53:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'menu specs'!

listMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::DiffBrowser andSelector:#listMenu
     (Menu new fromLiteralArrayEncoding:(SVN::DiffBrowser listMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse'
            itemValue: listMenuBrowse
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Load version A'
            itemValue: listMenuLoadVersionA
            nameKey: LoadVersionA
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionA16x16 'Load version A')
          )
         (MenuItem
            label: 'Load version B'
            itemValue: listMenuLoadVersionB
            nameKey: LoadVersionB
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionB16x16 'Load version B')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Inspect'
            itemValue: listMenuInspect
            translateLabel: true
          )
         )
        nil
        nil
      )
!

listMenuDiff
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetDiffTool andSelector:#listMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetDiffTool listMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasSelection
	    label: 'Browse'
	    itemValue: listMenuBrowse
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasSelection
	    label: 'Load version A'
	    itemValue: listMenuLoadVersionA
	    nameKey: LoadVersionA
	    translateLabel: true
	    labelImage: (ResourceRetriever #'SVN::IconLibrary' versionA16x16 'Load version A')
	  )
	 (MenuItem
	    enabled: hasSelection
	    label: 'Load version B'
	    itemValue: listMenuLoadVersionB
	    nameKey: LoadVersionB
	    translateLabel: true
	    labelImage: (ResourceRetriever #'SVN::IconLibrary' versionB16x16 'Load version B')
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Open in...'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  enabled: hasSelection
		  label: 'Inspector'
		  itemValue: listMenuInspect
		  translateLabel: true
		)
	       (MenuItem
		  enabled: hasSelection
		  label: 'kdiff3'
		  itemValue: listMenuOpenInExternal:
		  translateLabel: true
		  argument: 'kdiff3'
		)
	       (MenuItem
		  enabled: hasSelection
		  label: 'meld'
		  itemValue: listMenuOpenInExternal:
		  translateLabel: true
		  argument: 'meld'
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

    "Created: / 16-01-2013 / 15:47:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuMerge
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetDiffTool andSelector:#listMenuMerge
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetDiffTool listMenuMerge)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasSelection
	    label: 'Browse'
	    itemValue: listMenuBrowse
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasSelection
	    label: 'Merge using A'
	    itemValue: listMenuMergeUsingA
	    shortcutKey: Cmd2
	  )
	 (MenuItem
	    enabled: hasSelection
	    label: 'Merge using B'
	    itemValue: listMenuMergeUsingB
	    shortcutKey: Cmd3
	  )
	 (MenuItem
	    enabled: hasSelection
	    label: 'Merge using Base'
	    itemValue: listMenuMergeUsingBase
	    shortcutKey: Cmd1
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Open in...'
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  enabled: hasSelection
		  label: 'Inspector'
		  itemValue: listMenuInspect
		)
	       (MenuItem
		  enabled: hasSelection
		  label: 'kdiff3'
		  itemValue: listMenuOpenInExternal:
		  argument: 'kdiff3'
		)
	       (MenuItem
		  enabled: hasSelection
		  label: 'meld'
		  itemValue: listMenuOpenInExternal:
		  argument: 'meld'
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

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetDiffTool andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetDiffTool mainMenu)) startUp
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
		  label: 'Open...'
		  itemValue: fileMenuOpen
		  shortcutKey: Ctrlo
		)
	       (MenuItem
		  enabled: canSave
		  label: 'Save'
		  itemValue: fileMenuSave
		  shortcutKey: Ctrls
		)
	       (MenuItem
		  enabled: canSaveAs
		  label: 'Save As...'
		  itemValue: fileMenuSaveAs
		)
	       (MenuItem
		  enabled: canSaveAsPatch
		  label: 'Save As Patch '
		  itemValue: fileMenuSaveAsPatch
		  isVisible: false
		)
	       (MenuItem
		  enabled: canSaveMergedAs
		  label: 'Save Merged as... '
		  itemValue: fileMenuSaveMergedAs
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Exit'
		  itemValue: closeRequest
		  shortcutKey: Ctrlq
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Changeset'
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  enabled: isDiff2Or3
		  label: 'Browse changes (A)'
		  itemValue: changesetMenuBrowseA
		)
	       (MenuItem
		  enabled: isDiff2Or3
		  label: 'Browse changes (B)'
		  itemValue: changesetMenuBrowseB
		)
	       (MenuItem
		  enabled: isDiff3
		  label: 'Browse changes (Base)'
		  itemValue: changesetMenuBrowseBase
		)
	       (MenuItem
		  enabled: isMerge
		  label: 'Browse changes (Merge)'
		  itemValue: changesetMenuBrowseMerge
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Movement'
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Go to Previous Delta'
		  itemValue: menuMoveUp
		)
	       (MenuItem
		  label: 'Go To Next Delta'
		  itemValue: menuMoveDown
		)
	       (MenuItem
		  label: 'Go to Previous Conflict'
		  itemValue: menuMoveUpConflict
		  shortcutKey: CmdCursorUp
		)
	       (MenuItem
		  label: 'Go to Next Conflict'
		  itemValue: menuMoveDownConflict
		  shortcutKey: CmdCursorDown
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Automatically Go to Next Conflict'
		  indication: autoMoveToNextConflictHolder
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Change'
	    submenuChannel: listMenu
	  )
	 (MenuItem
	    label: 'View'
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Show Diffs in Version Methods'
		  indication: showVersionMethodDiffsHolder
		)
	       (MenuItem
		  label: 'Show Diff in #copyright Methods'
		  indication: showCopyrightMethodDiffsHolder
		)
	       (MenuItem
		  label: 'Highlight Conflicts'
		  indication: highlightConflictsHolder
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

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetDiffTool andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetDiffTool toolbarMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Open'
	    itemValue: fileMenuOpen
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary loadFromFile22x22Icon)
	  )
	 (MenuItem
	    enabled: canSaveHolder
	    label: 'Save'
	    itemValue: fileMenuSave
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary saveImageIcon)
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    label: 'Go to Previous Delta'
	    itemValue: menuMoveUp
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergePrev24x24)
	  )
	 (MenuItem
	    label: 'Go to Next Delta'
	    itemValue: menuMoveDown
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergeNext24x24)
	  )
	 (MenuItem
	    label: 'Go to Previous Conflict'
	    itemValue: menuMoveUpConflict
	    isButton: true
	    isVisible: mergeHolder
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergePrevConflict24x24)
	  )
	 (MenuItem
	    label: 'Go to Next Conflict'
	    itemValue: menuMoveDownConflict
	    isButton: true
	    isVisible: mergeHolder
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergeNextConflict24x24)
	  )
	 (MenuItem
	    label: '-'
	    isVisible: mergeHolder
	  )
	 (MenuItem
	    label: 'Merge using Base'
	    itemValue: listMenuMergeUsingBase
	    isButton: true
	    isVisible: mergeHolder
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingBaseAll24x24)
	  )
	 (MenuItem
	    label: 'Merge using A'
	    itemValue: listMenuMergeUsingA
	    isButton: true
	    isVisible: mergeHolder
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingAAll24x24)
	  )
	 (MenuItem
	    label: 'Merge using B'
	    itemValue: listMenuMergeUsingB
	    isButton: true
	    isVisible: mergeHolder
	    labelImage: (ResourceRetriever ToolbarIconLibrary mergeUsingBAll24x24)
	  )
	 )
	nil
	nil
      )
! !

!ChangeSetDiffTool class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #diffsetHolder
      ).

! !

!ChangeSetDiffTool methodsFor:'accessing'!

beSingleColumn

    self navigatorPanelSpecHolder value: #oneColumnNavigatorSpec

    "Created: / 20-11-2009 / 20:41:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beTwoColumn

    self navigatorPanelSpecHolder value: #twoColumnNavigatorSpec

    "Created: / 20-11-2009 / 20:42:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beTwoColumn: aBoolean

    aBoolean
        ifTrue:[self beTwoColumn]
        ifFalse:[self beSingleColumn]

    "Created: / 20-11-2009 / 20:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspect
    ^self codeAspectHolder value

    "Created: / 04-04-2013 / 18:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffInfo

    ^self diffInfoHolder value

    "Created: / 20-03-2012 / 11:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffset
    
    ^self diffsetHolder value

    "Created: / 05-12-2009 / 11:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffset: aDiff3Set

    self diffsetHolder value: aDiff3Set

    "Created: / 01-11-2009 / 09:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patchset

    | patchset |
    patchset := ChangeSet new.
    self diffset do:
        [:diff|patchset add:diff versionA].
    ^patchset

    "Created: / 05-12-2009 / 11:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection

    ^self selectionHolder value

    "Created: / 22-10-2008 / 11:30:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showCopyrightMethodDiffs
    ^self showCopyrightMethodDiffsHolder value

    "Created: / 10-08-2012 / 16:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCopyrightMethodDiffs: aBoolean
    self showCopyrightMethodDiffsHolder value: aBoolean

    "Created: / 10-08-2012 / 16:07:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVersionMethodDiffs
    ^ self showVersionMethodDiffsHolder value

    "Created: / 10-08-2012 / 16:07:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVersionMethodDiffs: aBoolean
    self showVersionMethodDiffsHolder value: aBoolean

    "Created: / 10-08-2012 / 16:08:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString

    self titleHolder value: aString

    "Created: / 19-11-2009 / 15:44:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'accessing-menus'!

listMenu
    | spec |

    spec := self isMerge ifTrue:[self class listMenuMerge] ifFalse:[self class listMenuDiff].
    ^Menu decodeFromLiteralArray: spec.

    "Created: / 16-01-2013 / 15:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'accessing-selection'!

selection: entry


    self isOneColumnBrowser ifTrue:[
	list1App selection: entry
    ] ifFalse:[
	| parent |

	parent := self diffsetHolderPrivate value diffs
		    detect:[:each|each diffs includes: entry] ifNone:[nil].
	parent notNil ifTrue:[
	    list1App selection: parent.
	    list1App updateOutputGenerator.
	    list2App updateList.
	    list2App selection: entry.

	]
    ]

    "Created: / 22-10-2008 / 11:30:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-01-2013 / 16:28:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theFirstSelectedEntry
    | selection |

    selection := self selectionHolder value.
    selection isNil ifTrue:[ ^ nil ].
    selection := selection collect:[:e|e]. "/selection might be an Iterator
    selection  isEmpty ifTrue:[ ^nil ].
    ^selection first

    "Created: / 17-01-2013 / 16:58:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theLastSelectedEntry
    | selection |

    selection := self selectionHolder value.
    selection isNil ifTrue:[ ^ nil ].
    selection := selection collect:[:e|e]. "/selection might be an Iterator
    selection  isEmpty ifTrue:[ ^nil ].
    ^selection last

    "Created: / 17-01-2013 / 13:22:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theSingleSelectedObject

    | sel selSize obj |
    sel := self selection.

    (sel isCollection and:[self isString not])
        ifFalse:[^sel].

    selSize := 0.
    obj := nil.        
    sel do:
        [:each|
        selSize := selSize + 1.
        selSize > 1 ifTrue:[^nil].
        obj := each].
    ^obj

    "Created: / 10-11-2009 / 11:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2009 / 19:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'accessing-subApps'!

textDiff2Tool
    textDiff2App isNil ifTrue:[
	textDiff2App := TextDiff2Tool new
	    labelAHolder: self versionALabelHolder;
	     textAHolder: self versionATextHolder;

	    labelBHolder: self versionBLabelHolder;
	     textBHolder: self versionBTextHolder;

	    codeAspectHolder: self codeAspectHolder;

	    yourself
    ].
    ^textDiff2App

    "Created: / 16-03-2012 / 13:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2013 / 18:17:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textDiff3Tool
    textDiff3App isNil ifTrue:[
	textDiff3App := TextDiff3Tool new
	    mergeHolder: self mergeHolder;
	    mergeDataHolder: self mergeDataHolder;

	    labelCHolder: self versionBaseLabelHolder;
	     textCHolder: self versionBaseTextHolder;

	    labelBHolder: self versionBLabelHolder;
	     textBHolder: self versionBTextHolder;

	    labelAHolder: self versionALabelHolder;
	     textAHolder: self versionATextHolder;

	    codeAspectHolder: self codeAspectHolder;


	    yourself
    ].
    ^textDiff3App

    "Created: / 16-03-2012 / 15:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2013 / 18:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'accessing-subviews'!

labelsView:something
    labelsView := something.
!

list1View: aView
    list1App := aView application.

    "Created: / 17-01-2013 / 13:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

list2View: aView
    list2App := aView application.

    "Created: / 17-01-2013 / 13:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

navigatorAndDiffPanelView:something
    navigatorAndDiffPanelView := something.
! !

!ChangeSetDiffTool methodsFor:'aspects'!

autoMoveToNextConflictHolder

    autoMoveToNextConflictHolder isNil ifTrue:[
	autoMoveToNextConflictHolder := AspectAdaptor forAspect: #autoMoveToNextConflict.
	autoMoveToNextConflictHolder subject: self class.
    ].
    ^autoMoveToNextConflictHolder

    "Created: / 17-01-2013 / 19:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSaveHolder
    "return/create the 'canSaveHolder' value holder (automatically generated)"

    canSaveHolder isNil ifTrue:[
	canSaveHolder := false asValue
    ].
    ^ canSaveHolder

    "Modified: / 17-01-2013 / 21:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspectHolder
    "return/create the valueHolder 'codeAspectHolder'"

    codeAspectHolder isNil ifTrue:[
	codeAspectHolder := ValueHolder with:nil "defaultValue here".
    ].
    ^ codeAspectHolder
!

diffInfoHolder
    "return/create the 'diffInfoHolder' value holder (automatically generated)"

    diffInfoHolder isNil ifTrue:[
	diffInfoHolder := ValueHolder new.
	diffInfoHolder addDependent:self.
    ].
    ^ diffInfoHolder
!

diffInfoHolder:something
    "set the 'diffInfoHolder' value holder (automatically generated)"

    |oldValue newValue|

    diffInfoHolder notNil ifTrue:[
	oldValue := diffInfoHolder value.
	diffInfoHolder removeDependent:self.
    ].
    diffInfoHolder := something.
    diffInfoHolder notNil ifTrue:[
	diffInfoHolder addDependent:self.
    ].
    newValue := diffInfoHolder value.
    oldValue ~~ newValue ifTrue:[
	self update:#value with:newValue from:diffInfoHolder.
    ].
!

diffListEntryLabelGeneratorAspect

    ^nil

    "Created: / 24-11-2009 / 10:01:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffsetHolder
    "return/create the 'diffsetHolder' value holder (automatically generated)"

    diffsetHolder isNil ifTrue:[
        diffsetHolder := ValueHolder new.
        diffsetHolder addDependent:self.
    ].
    ^ diffsetHolder
!

diffsetHolder:aValueHolder
    "set the 'diffsetHolder' value holder (automatically generated)"

    |oldValue newValue|

    diffsetHolder notNil ifTrue:[
        oldValue := diffsetHolder value.
        diffsetHolder removeDependent:self.
    ].
    diffsetHolder := aValueHolder.
    diffsetHolder notNil ifTrue:[
        diffsetHolder addDependent:self.
    ].
    newValue := diffsetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:diffsetHolder.
    ].
!

diffsetHolderPrivate
    "return/create the 'diffSetHolderPrivate' value holder (automatically generated)"

    diffsetHolderPrivate isNil ifTrue:[
        diffsetHolderPrivate := ValueHolder with: (self diffsetHolder value).
    ].
    ^ diffsetHolderPrivate

    "Created: / 05-12-2009 / 11:03:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

firstColSelectionHolder
    "return/create the valueHolder 'firstColSelectionHolder'"

    firstColSelectionHolder isNil ifTrue:[
        firstColSelectionHolder := ValueHolder with:nil "defaultValue here".
    ].
    ^ firstColSelectionHolder
!

hasDiffsetHolder
    "return/create the 'hasDiffsetHolder' value holder (automatically generated)"

    hasDiffsetHolder isNil ifTrue:[
	hasDiffsetHolder := false asValue
    ].
    ^ hasDiffsetHolder

    "Modified: / 01-08-2012 / 17:16:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasDiffsetHolder:something
    "set the 'hasDiffsetHolder' value holder (automatically generated)"

    hasDiffsetHolder := something.
!

hasSelectionHolder

    |holder|

    (holder := builder bindingAt:#hasSelectionHolder) isNil ifTrue:[
        holder := (AspectAdaptor forAspect: #notEmptyOrNil)
            subjectChannel: self selectionHolder.
        builder aspectAt:#hasSelectionHolder put: holder
    ].
    ^ holder.

    "Created: / 22-10-2008 / 11:34:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 12:38:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

highlightConflictsHolder
    "return/create the 'highlightConflictsHolder' value holder (automatically generated)"

    highlightConflictsHolder isNil ifTrue:[
	highlightConflictsHolder := true asValue
    ].
    ^ highlightConflictsHolder

    "Modified: / 01-08-2012 / 17:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightConflictsHolder:something
    "set the 'highlightConflictsHolder' value holder (automatically generated)"

    highlightConflictsHolder := something.
!

infoPanel
    infoPanel isNil ifTrue:[
	infoPanel := InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelSpecHolder
    "return/create the 'labelSpecHolder' value holder (automatically generated)"

    labelSpecHolder isNil ifTrue:[
	labelSpecHolder := nil asValue

    ].
    ^ labelSpecHolder

    "Modified: / 17-01-2013 / 23:32:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder

    "Modified: / 01-11-2009 / 16:57:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuHolder
    diffMenuHolder isNil ifTrue:[
"/        diffMenuHolder := ValueHolder with:self listMenu
      diffMenuHolder := BlockValue with:[:v|self listMenu] argument: self mergeHolder
    ].
    ^ diffMenuHolder

    "Created: / 21-11-2009 / 18:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:57:47 / cg"
    "Modified: / 16-01-2013 / 15:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
    ].
    ^ mergeHolder

    "Modified: / 19-03-2012 / 14:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeHolder:something
    "set the 'mergeHolder' value holder (automatically generated)"

    mergeHolder := something.
!

mergeSavedHolder
    "return/create the 'mergeSavedHolder' value holder (automatically generated)"

    mergeSavedHolder isNil ifTrue:[
	mergeSavedHolder := false asValue
    ].
    ^ mergeSavedHolder

    "Modified: / 15-01-2013 / 11:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameAspect

    ^(AspectAdaptor forAspect: #name)
        subjectChannel: self diffsetHolder

    "Created: / 01-11-2009 / 11:14:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

navigatorPanelSpecHolder
    <resource: #uiAspect>

    navigatorPanelSpecHolder isNil ifTrue:[
        navigatorPanelSpecHolder := ValueHolder with: #twoColumnNavigatorSpec.
    ].
    ^ navigatorPanelSpecHolder.

    "Modified: / 20-11-2009 / 20:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

secondColSelectionHolder
    "return/create the valueHolder 'firstColSelectionHolder'"

    ^self selectionHolder

    "Created: / 17-01-2013 / 12:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectionHolder isNil ifTrue:[

        selectionHolder := ValueHolder new.
        selectionHolder addDependent:self.
    ].
    ^ selectionHolder

    "Modified (format): / 06-07-2011 / 12:25:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCopyrightMethodDiffsHolder
    "return/create the 'showCopyrightMethodDiffsHolder' value holder (automatically generated)"

    showCopyrightMethodDiffsHolder isNil ifTrue:[
	showCopyrightMethodDiffsHolder := true asValue
    ].
    ^ showCopyrightMethodDiffsHolder

    "Modified: / 01-08-2012 / 17:06:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showCopyrightMethodDiffsHolder:something
    "set the 'showCopyrightMethodDiffsHolder' value holder (automatically generated)"

    showCopyrightMethodDiffsHolder := something.
!

showVersionMethodDiffsHolder
    "return/create the 'showVersionMethodDiffsHolder' value holder (automatically generated)"

    showVersionMethodDiffsHolder isNil ifTrue:[
	showVersionMethodDiffsHolder := true asValue.
    ].
    ^ showVersionMethodDiffsHolder

    "Modified: / 18-04-2012 / 19:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVersionMethodDiffsHolder:something
    "set the 'showVersionMethodDiffsHolder' value holder (automatically generated)"

    showVersionMethodDiffsHolder := something.
!

singleSelectionHolder
    "return/create the 'singleSelectionHolder' value holder (automatically generated)"

    singleSelectionHolder isNil ifTrue:[
        singleSelectionHolder := ValueHolder new.
    ].
    ^ singleSelectionHolder

    "Modified: / 10-11-2009 / 11:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textDiffToolHolder
    "return/create the 'textDiffToolHolder' value holder (automatically generated)"

    textDiffToolHolder isNil ifTrue:[
	textDiffToolHolder := ValueHolder with: self textDiff2Tool.
    ].
    ^ textDiffToolHolder

    "Modified: / 16-03-2012 / 13:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textDiffToolHolder:something
    "set the 'textDiffToolHolder' value holder (automatically generated)"

    textDiffToolHolder := something.
!

textDiffToolWindowSpecHolder
    "return/create the 'textDiffToolWindowSpecHolder' value holder (automatically generated)"

    textDiffToolWindowSpecHolder isNil ifTrue:[
	textDiffToolWindowSpecHolder := #windowSpecForEmbedding asValue.
    ].
    ^ textDiffToolWindowSpecHolder

    "Modified: / 16-03-2012 / 13:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textDiffToolWindowSpecHolder:something
    "set the 'textDiffToolWindowSpecHolder' value holder (automatically generated)"

    textDiffToolWindowSpecHolder := something.
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil ifTrue:[
        titleHolder := ValueHolder with: 'Diff Browser'.
    ].
    ^ titleHolder

    "Modified: / 01-11-2009 / 14:04:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionALabelHolder

    ^(AspectAdaptor forAspect: #versionALabel)
        subjectChannel: self diffsetHolder

    "Created: / 09-04-2011 / 23:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionATextHolder

    versionATextHolder isNil ifTrue:[
        versionATextHolder := ValueHolder new
    ].
    ^versionATextHolder

    "Created: / 06-07-2011 / 12:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:57:56 / cg"
!

versionBLabelHolder

    ^(AspectAdaptor forAspect: #versionBLabel)
        subjectChannel: self diffsetHolder

    "Created: / 09-04-2011 / 23:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBTextHolder

    versionBTextHolder isNil ifTrue:[
        versionBTextHolder := ValueHolder new
    ].
    ^versionBTextHolder

    "Created: / 06-07-2011 / 12:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:57:59 / cg"
!

versionBaseLabelHolder

    ^(AspectAdaptor forAspect: #versionBaseLabel)
	subjectChannel: self diffsetHolder

    "Created: / 16-03-2012 / 15:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBaseTextHolder

    versionBaseTextHolder isNil ifTrue:[
	versionBaseTextHolder := ValueHolder new
    ].
    ^versionBaseTextHolder

    "Modified: / 18-11-2011 / 14:57:59 / cg"
    "Created: / 16-03-2012 / 15:19:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'change & update'!

diffInfoChanged

    | info |
    info := self diffInfoHolder value.
    self hasDiffsetHolder value: false.
    self mergeSavedHolder value: false.
    self canSaveHolder value: false.
    info notNil ifTrue:[
	self infoPanel showProgressLabeled: (resources string:'Reading changesets') while: [
	    info read.
	    self diffset: info diffset.
	].
    ].

    "Created: / 19-03-2012 / 23:40:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 21:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffsetChanged

    | ds |

    ds := self diffsetHolder value.
    ds depth = 2 ifTrue:[
	self beTwoColumn.
    ] ifFalse:[
	self beSingleColumn.
    ].
    self hasDiffsetHolder value: ds notNil.
    self canSaveHolder value: self canSave.
    alreadyWarnedAboutUnsavedMerge := false.


    self diffsetHolderPrivate value:
	(self isOneColumnBrowser
	    ifTrue:[ds flattened sort]
	    ifFalse:[ds value sort]).
    self autoMoveToNextConflictHolder value ifTrue:[
	self menuMoveDownConflict.
    ].
    self versionALabelHolder value: ds versionALabel.
    self versionBLabelHolder value: ds versionBLabel.
    self versionBaseLabelHolder value: ds versionBaseLabel.
    self updateViews.

    "Created: / 05-12-2009 / 11:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2011 / 08:24:18 / Jan Vrany <enter your email here>"
    "Modified: / 21-01-2013 / 21:13:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDataChanged
    "Resolution has been changed..."

    self canSaveHolder value: self canSave.
    alreadyWarnedAboutUnsavedMerge := false.
    (self autoMoveToNextConflictHolder value and:[mergeData isMerged]) ifTrue:[
	self menuMoveDownConflict
    ]

    "Created: / 17-01-2013 / 20:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 21:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeDataHolderChanged
    mergeData notNil ifTrue:[mergeData removeDependent: self].
    mergeData := self mergeDataHolder value.
    mergeData notNil ifTrue:[mergeData addDependent: self].

    "Created: / 16-01-2013 / 09:24:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 20:06:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionChanged

    | diffItem mergeData |

    diffItem := self theSingleSelectedObject.
    self singleSelectionHolder value: diffItem.
    diffItem isNil ifTrue:[^self].

    self isMerge ifTrue:[
	self mergeDataHolder setValue: (mergeData := diffItem mergeInfo).
    ].
    self versionATextHolder setValue: diffItem versionAText.
    self versionBTextHolder setValue: diffItem versionBText.
    self versionBaseTextHolder setValue: diffItem versionBaseText.


    self versionATextHolder changed: #value.
    self versionBTextHolder changed: #value.
    self versionBaseTextHolder changed: #value.
    self isMerge ifTrue:[
	self mergeDataHolder changed: #value.
	"Maybe, there was no merge data beforehand. In that case,
	 update"
	mergeData isNil ifTrue:[
	    diffItem mergeInfo: (self mergeDataHolder value).
	]
    ]

    "Created: / 22-10-2008 / 11:29:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-03-2012 / 14:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: aspect with: param from: sender

    sender == selectionHolder ifTrue:[
	self selectionChanged.
	^self.
    ].

    sender == diffsetHolder ifTrue:[
	self diffsetChanged.
	^self.
    ].

    sender == diffInfoHolder ifTrue:[
	self diffInfoChanged.
	^self.
    ].

    sender == mergeDataHolder ifTrue:[
	self mergeDataHolderChanged.
	^self.
    ].

    sender == mergeData ifTrue:[
	"Resolution has been changed..."
	self mergeDataChanged.
	^self.
    ].

    ^super update: aspect with: param from: sender

    "Created: / 05-12-2009 / 11:02:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-01-2013 / 20:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListMenu
    |menu diffs loadA loadB|

    menu := self listMenuHolder value.
    diffs := self selection ? #().
    loadA := menu atNameKey:#LoadVersionA.
    loadA disable.
    loadB := menu atNameKey:#LoadVersionB.
    loadB disable.

    diffs do:[:diff | 
        diff versionA 
            ifNotNil:[
                loadA 
                    label:('Load version ' , diff versionALabel);
                    enable.
            ].
        diff versionB 
            ifNotNil:[
                loadB
                    label:('Load version ' , diff versionBLabel);
                    enable
            ].
    ].
!

updateViews

    (self diffInfo notNil and:[self diffInfo isDiff3]) ifTrue:[
	self diffInfo isMerge ifTrue:[
	    self mergeHolder value: true.
	    self labelSpecHolder value: #labelMergeSpec.
	    self labelHeight: 120.
	] ifFalse:[
	    self mergeHolder value: false.
	    self labelSpecHolder value: #labelDiff3Spec.
	    self labelHeight: 90.
	].
	self textDiffToolHolder value isDiff3 ifFalse:[
	    textDiffToolHolder value: self textDiff3Tool.
	].


    ] ifFalse:[
	self mergeHolder value: false.
	self labelSpecHolder value: #labelDiff2Spec.
	self labelHeight: 60.

	self textDiffToolHolder value isDiff2 ifFalse:[
	    textDiffToolHolder value: self textDiff2Tool.
	].
    ].

    "Created: / 20-03-2012 / 10:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 21:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'hooks'!

commonPostOpen
    self updateViews

    "Created: / 21-01-2013 / 21:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder

    "Created: / 22-10-2008 / 12:37:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'menu actions'!

changesetMenuBrowse: changeset

    (Tools::ChangeSetBrowser2 on: (changeset , self diffInfo same))
        allowRemove: true;
        open

    "Created: / 16-12-2011 / 14:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2013 / 17:19:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMenuBrowseA

    self changesetMenuBrowse: self diffInfo diffset changesetA

    "Created: / 16-12-2011 / 14:23:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMenuBrowseB

    self changesetMenuBrowse: self diffInfo diffset changesetB

    "Created: / 16-12-2011 / 14:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMenuBrowseBase

    self changesetMenuBrowse: self diffInfo diffset changesetBase

    "Created: / 20-03-2012 / 13:34:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMenuBrowseMerge

    self changesetMenuBrowse: self diffInfo diffset changesetMerged

    "Created: / 20-03-2012 / 14:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuOpen

    | dlg info |
    dlg := OpenDialog new.
    info := LastDiffInfo.
    info isNil ifTrue:[
        info := ChangeSetDiffInfo new.
        info specMerge: ChangeSetSpec changeSet
    ] ifFalse:[
        info := info deepCopy.
    ].
    dlg diffInfo: info.
    dlg open ifFalse:[^self].
    info := dlg diffInfo.

    ^self fileMenuOpenOnDiffInfo: info

    "Modified: / 13-11-2013 / 11:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuOpenOnDiffBetween: a and: b

    self diffset: (ChangeSetDiff versionA: a versionB: b).

    "Created: / 21-03-2011 / 23:23:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2011 / 08:10:17 / Jan Vrany <enter your email here>"
    "Modified: / 06-07-2011 / 12:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuOpenOnDiffInfo: info

    LastDiffInfo := info.
    self diffInfoHolder value: info

    "Created: / 20-03-2012 / 00:04:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSave
    self fileMenuSaveAs: self diffInfo specMergeFile.

    "Modified: / 20-03-2012 / 15:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSaveAs
    | info file suggestion |

    info := self diffInfo.
    suggestion := (info specMerge isFile ifTrue:['merged.chg'] ifFalse:[info specMergeFile]).
    file := Dialog requestFileName:'Select File for Save' default: (suggestion) pattern:('*.chg;*.st').
    file isNil ifTrue:[^self].
    self fileMenuSaveAs: file.

    "Modified: / 20-03-2012 / 15:07:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSaveAs: aFilename

    self fileMenuSaveAs: aFilename format: #classSource

    "Created: / 20-03-2012 / 15:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSaveAs: aFilename format: format

    | changesToSave |

    changesToSave := (self diffInfo diffset changesetMerged) , (self diffInfo same).
    changesToSave := changesToSave reject:[:chg|chg isDoIt].
    changesToSave saveToFile: aFilename format: format.
    self mergeSavedHolder value: true

    "Created: / 20-03-2012 / 15:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 11:40:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSaveAsPatch
    | filename |
    
    filename := Dialog requestFileName: 'Enter filename' default:'patch.chg' ifFail:[^self].
    self patchset fileOutAs: filename.

    "Modified: / 05-12-2009 / 12:37:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMenuSaveMergedAs

    self halt.

    "Modified: / 03-08-2012 / 15:39:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuBrowse

    | items |
    items := self selection collect:[:e|e]. "/must do collect as selection is an iterator..."
    items size == 1 ifTrue:[
        | item cls sel |
        item:= items anElement.
        cls := item changeClass.
        sel := item changeSelector.
        cls notNil ifTrue:[
            sel notNil ifTrue:[
                UserPreferences systemBrowserClass
                    openInClass:cls selector:sel

            ] ifFalse:[
                UserPreferences systemBrowserClass
                    browseClass: cls
            ]
        ] ifFalse:[
            Dialog warn: (self class resources at: 'Oops, class is gone')
        ]
    ] ifFalse:[
        Dialog error: 'Not yet implemented (Tools::ChangeSetDiffTool » listMenuBrowse)'.                        
    ]

    "Created: / 30-11-2011 / 11:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuInspect

    (self selection collect:[:e|e]) inspect

    "Modified: / 24-11-2009 / 12:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuLoadVersionA

    self selection do:
        [:diff|diff versionA apply]

    "Modified: / 09-12-2009 / 23:09:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuLoadVersionB

    self selection do:
        [:diff|diff versionB apply]

    "Modified: / 09-12-2009 / 23:10:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuMergeUsingA
    self textDiffToolHolder value doMergeAllUsingA

    "Modified: / 16-01-2013 / 15:57:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuMergeUsingB
    self textDiffToolHolder value doMergeAllUsingB

    "Created: / 16-01-2013 / 15:57:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuMergeUsingBase
    self textDiffToolHolder value doMergeAllUsingBase

    "Created: / 16-01-2013 / 15:57:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listMenuOpenInExternal: command

    (OperatingSystem canExecuteCommand: command) ifFalse:[
	Dialog warn: 'Sorry. ', command , ' is not installed or not in PATH'
    ].

    self selection do:[:item|
	| base a b cmd |
	item versionBase notNil ifTrue:[
	    base := Filename newTemporary.
	    base writingFileDo:[:s|s nextPutAll: item versionBase source].
	].
	a := Filename newTemporary.
	a writingFileDo:[:s|s nextPutAll: item versionA source].
	b := Filename newTemporary.
	b writingFileDo:[:s|s nextPutAll: item versionB source].

	base isNil ifTrue:[
	    cmd := '%1 %2 %3' bindWith: command with: a pathName with: b pathName
	] ifFalse:[
	    cmd := '%1 %4 %2 %3 ' bindWith: command with: a pathName with: b pathName with: base pathName.
	].
	[ OperatingSystem executeCommand: cmd.
	a remove.
	b remove.
	base notNil ifTrue:[base remove]. ] fork
    ]

    "Modified: / 17-03-2012 / 08:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveDown
    self menuMoveDownToSuchThat: [:entry|true]

    "Modified: / 17-01-2013 / 16:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveDownConflict
    self menuMoveDownToSuchThat: [:entry|entry isMerged not]

    "Modified: / 17-01-2013 / 16:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveDownToSuchThat: aBlock
    | oldSel newSel |
    oldSel := self theLastSelectedEntry.
    newSel := self diffsetHolderPrivate value nextEntryAfter: oldSel suchThat: aBlock.
    self menuMoveTo: newSel.

    "Created: / 17-01-2013 / 16:52:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveTo: entry

"/    self window sensor pushUserEvent:#selection: for: self withArgument: entry
    self selection: entry.

    "Created: / 17-01-2013 / 13:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 16:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveUp
    self menuMoveUpToSuchThat: [:entry|true]

    "Created: / 17-01-2013 / 16:58:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveUpConflict
    self menuMoveUpToSuchThat: [:entry|entry isMerged not]

    "Created: / 17-01-2013 / 17:00:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuMoveUpToSuchThat: aBlock
    | oldSel newSel |
    oldSel := self theFirstSelectedEntry.
    newSel := self diffsetHolderPrivate value nextEntryBefore: oldSel suchThat: aBlock.
    self menuMoveTo: newSel.

    "Created: / 17-01-2013 / 16:58:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'private'!

labelHeight: height
    (labelsView notNil and:[navigatorAndDiffPanelView notNil]) ifTrue:[
	labelsView layout: (labelsView layout copy bottomOffset: height).
	navigatorAndDiffPanelView layout: (navigatorAndDiffPanelView layout copy topOffset: height).
    ].

    "Created: / 17-01-2013 / 23:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 21:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'queries'!

canBrowse

    ^true

    "^[self selection notNil 
        and:[self selection versionA notNil]]"

    "Created: / 02-11-2009 / 18:32:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2009 / 18:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSave
    "Returns true, if a merged file can be saved"

    ^self canSaveAs and:[self diffInfo specMerge isFile]

    "Created: / 20-03-2012 / 15:00:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 21:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSaveAs
    "Returns true, if a merged file can be saved"

    | info |
    info := self diffInfo.
    info isNil ifTrue:[^false].
    ^info isMerge and:[info diffset notNil and:[info diffset isMerged]]

    "Created: / 20-03-2012 / 15:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 20:57:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSaveAsPatch

    ^false

    "Created: / 20-03-2012 / 14:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSaveMergedAs
    "Returns true, if a merged file can be saved"

    | info |
    info := self diffInfo.
    info isNil ifTrue:[^false].
    ^info isMerge

    "Created: / 03-08-2012 / 15:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelection

    ^[self selection notNil]

    "Created: / 03-11-2009 / 10:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isOneColumnBrowser

    ^self navigatorPanelSpecHolder value = #oneColumnNavigatorSpec

    "Created: / 05-12-2009 / 11:04:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'startup & release'!

closeRequest

    "/Warn about unsaved merge..."
    (alreadyWarnedAboutUnsavedMerge not and:[self canSave and:[mergeSavedHolder value not]]) ifTrue:[
	alreadyWarnedAboutUnsavedMerge := true.
	self infoPanel
	    reset;
	    beInformation;
	    message: (self resources string:'Output file (merge) has not been saved. Save?');
	    addButtonWithLabel: (self resources string:'Save') action: [
		self fileMenuSave.
		self closeDownViews.
	    ];
	    addButtonWithLabel: (self resources string:'Cancel') action:[self infoPanel hide];
	    show.
	^self.
    ].
    self closeDownViews.

    "Created: / 17-01-2013 / 21:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool methodsFor:'testing'!

isDiff2
    ^self diffInfo notNil and:[self diffInfo isDiff2]

    "Created: / 20-03-2012 / 13:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiff2Or3
    ^self diffInfo notNil and:[self diffInfo isDiff2 or:[self diffInfo isDiff3]]

    "Created: / 20-03-2012 / 13:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiff3
    ^self diffInfo notNil and:[self diffInfo isDiff3]

    "Created: / 20-03-2012 / 13:27:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerge
    ^self diffInfo notNil and:[self diffInfo isMerge]

    "Created: / 19-03-2012 / 11:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog class methodsFor:'image specs'!

versionA24x24

    ^ToolbarIconLibrary versionA24x24

    "Created: / 24-03-2010 / 20:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionB24x24

    ^ToolbarIconLibrary versionB24x24

    "Created: / 24-03-2010 / 20:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBase24x24

    ^ToolbarIconLibrary versionBase24x24

    "Created: / 19-03-2012 / 23:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMerged24x24

    ^ToolbarIconLibrary versionMerged24x24

    "Created: / 19-03-2012 / 23:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool::OpenDialog andSelector:#windowSpec
     Tools::ChangeSetDiffTool::OpenDialog new openInterface:#windowSpec
     Tools::ChangeSetDiffTool::OpenDialog open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Open...'
	  name: 'Open...'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 640 457)
	)
	component:
       (SpecCollection
	  collection: (
	   (VerticalPanelViewSpec
	      name: 'VerticalPanel1'
	      layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
	      horizontalLayout: fit
	      verticalLayout: top
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (ViewSpec
		    name: 'B'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification2'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionBLabelSpec
			)
		       (SubCanvasSpec
			  name: 'SubCanvas1'
			  layout: (LayoutFrame 30 0 30 0 0 1 0 1)
			  level: 0
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecBHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		    extent: (Point 640 99)
		  )
		 (ViewSpec
		    name: 'A'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification1'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionALabelSpec
			)
		       (SubCanvasSpec
			  name: 'ChangesetASpec'
			  layout: (LayoutFrame 30 0 30 0 0 1 0 1)
			  level: 0
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecAHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		    extent: (Point 640 99)
		  )
		 (ViewSpec
		    name: 'Base'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification3'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionBaseLabelSpec
			)
		       (SubCanvasSpec
			  name: 'SubCanvas2'
			  layout: (LayoutFrame 30 0 30 0 0 1 0 1)
			  level: 0
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: enabledHolder
			      aspect: changesetSpecBaseEnabledHolder
			    )
			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecBaseHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		    extent: (Point 640 98)
		  )
		 (ViewSpec
		    name: 'Merge'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification4'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionMergedLabelSpec
			)
		       (SubCanvasSpec
			  name: 'SubCanvas3'
			  layout: (LayoutFrame 30 0 30 0 0 1 -25 1)
			  level: 0
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: enabledHolder
			      aspect: changesetSpecMergedEnabledHolder
			    )
			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecMergedHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		    extent: (Point 640 123)
		  )
		 )

	      )
	    )
	   (HorizontalPanelViewSpec
	      name: 'ButtonPanel'
	      layout: (LayoutFrame 3 0 -30 1 -3 1 0 1)
	      horizontalLayout: right
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      reverseOrderIfOKAtLeft: true
	      component:
	     (SpecCollection
		collection: (
		 (ActionButtonSpec
		    label: 'OK'
		    name: 'Button1'
		    translateLabel: true
		    model: doAccept
		    enableChannel: doAcceptEnabled
		    extent: (Point 125 22)
		  )
		 (ActionButtonSpec
		    label: 'Cancel'
		    name: 'Button2'
		    translateLabel: true
		    model: doCancel
		    extent: (Point 125 22)
		  )
		 )

	      )
	    )
	   )

	)
      )
!

windowSpec_old
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffBrowser::OpenDialog andSelector:#windowSpec
     Tools::ChangeSetDiffBrowser::OpenDialog new openInterface:#windowSpec
     Tools::ChangeSetDiffBrowser::OpenDialog open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Open...'
	  name: 'Open...'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 640 130)
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableHorizontalPanelSpec
	      name: 'ChangeSetsSpecPanel'
	      layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
	      barWidth: 3
	      showHandle: true
	      component:
	     (SpecCollection
		collection: (
		 (ViewSpec
		    name: 'A'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification1'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionALabelSpec
			)
		       (SubCanvasSpec
			  name: 'ChangesetASpec'
			  layout: (LayoutFrame 0 0 30 0 0 1 0 1)
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecAHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		  )
		 (ViewSpec
		    name: 'B'
		    component:
		   (SpecCollection
		      collection: (
		       (UISubSpecification
			  name: 'SubSpecification2'
			  layout: (LayoutFrame 0 0 0 0 0 1 30 0)
			  minorKey: versionBLabelSpec
			)
		       (SubCanvasSpec
			  name: 'SubCanvas1'
			  layout: (LayoutFrame 0 0 30 0 0 1 0 1)
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: false
			  majorKey: #'Tools::ChangeSetSelectionDialog'
			  minorKey: windowSpecForEmbedding
			  subAspectHolders:
			 (Array

			   (SubChannelInfoSpec
			      subAspect: specHolder
			      aspect: changesetSpecBHolder
			    )
			  )
			  createNewApplication: true
			  createNewBuilder: true
			)
		       )

		    )
		  )
		 )

	      )
	      handles: (Any 0.5 1.0)
	    )
	   (HorizontalPanelViewSpec
	      name: 'ButtonPanel'
	      layout: (LayoutFrame 3 0 -30 1 -3 1 0 1)
	      horizontalLayout: right
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      reverseOrderIfOKAtLeft: true
	      component:
	     (SpecCollection
		collection: (
		 (ActionButtonSpec
		    label: 'OK'
		    name: 'Button1'
		    translateLabel: true
		    model: doAccept
		    enableChannel: doAcceptEnabled
		    extent: (Point 125 22)
		  )
		 (ActionButtonSpec
		    label: 'Cancel'
		    name: 'Button2'
		    translateLabel: true
		    model: doCancel
		    extent: (Point 125 22)
		  )
		 )

	      )
	    )
	   )

	)
      )

    "Modified: / 06-07-2011 / 11:32:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 22:21:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog class methodsFor:'interface specs - labels'!

versionALabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffBrowser::OpenDialog andSelector:#versionALabelSpec
     Tools::ChangeSetDiffBrowser::OpenDialog new openInterface:#versionALabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionALabelSpec
	window:
       (WindowSpec
	  label: 'Version A'
	  name: 'Changeset A'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 79.6078431372549 90.5882352941177 69.4117647058823)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionA24x24'
	      name: 'VersionAIcon'
	      layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version A (working copy)'
	      name: 'VersionALabel'
	      layout: (LayoutFrame 30 0 5 0 0 1 0 1)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: left
	    )
	   )

	)
      )

    "Modified: / 19-03-2012 / 22:15:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffBrowser::OpenDialog andSelector:#versionBLabelSpec
     Tools::ChangeSetDiffBrowser::OpenDialog new openInterface:#versionBLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBLabelSpec
	window:
       (WindowSpec
	  label: 'Version B'
	  name: 'Changeset B'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 100.0 90.5882352941177 60.0)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionB24x24'
	      name: 'VersionBIcon'
	      layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Version B (to be merged)'
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 30 0 5 0 97 0 0 1)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   )

	)
      )

    "Modified: / 19-03-2012 / 22:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBaseLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool::OpenDialog andSelector:#versionBaseLabelSpec
     Tools::ChangeSetDiffTool::OpenDialog new openInterface:#versionBaseLabelSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: versionBaseLabelSpec
	window:
       (WindowSpec
	  label: 'Version B'
	  name: 'Version B'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 57.2182803082322 81.2832837415122 91.0872053101396)
	  forceRecursiveBackground: true
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'versionBase24x24'
	      name: 'VersionBaseIcon'
	      layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
	      hasCharacterOrientedLabel: false
	      translateLabel: true
	    )
	   (LabelSpec
	      label: 'Base'
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 30 0 5 0 68 0 0 1)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (CheckBoxSpec
	      label: ''
	      name: 'CheckBox1'
	      layout: (LayoutFrame -30 1 0 0 0 1 0 1)
	      model: changesetSpecBaseEnabledHolder
	      translateLabel: true
	    )
	   )

	)
      )
!

versionMergedLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetDiffTool::OpenDialog andSelector:#versionMergedLabelSpec
     Tools::ChangeSetDiffTool::OpenDialog new openInterface:#versionMergedLabelSpec
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
	  bounds: (Rectangle 0 0 300 30)
	  backgroundColor: (Color 92.6909285114824 62.388036926833 93.2265201800565)
	  forceRecursiveBackground: true
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
	      name: 'VersionBLabel'
	      layout: (LayoutFrame 30 0 5 0 68 0 0 1)
	      translateLabel: true
	      resizeForLabel: true
	      adjust: left
	      useDynamicPreferredWidth: true
	      usePreferredWidth: true
	    )
	   (CheckBoxSpec
	      label: ''
	      name: 'CheckBox1'
	      layout: (LayoutFrame -30 1 0 0 0 1 0 1)
	      model: changesetSpecMergedEnabledHolder
	      translateLabel: true
	    )
	   )

	)
      )

    "Modified: / 19-03-2012 / 23:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog methodsFor:'accessing'!

changeSetA

    | specA |

    specA := self changesetSpecAHolder value.
    ^specA ifNil:[nil] ifNotNil:[specA changeSet]

    "Created: / 06-07-2011 / 11:36:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetASpec
    ^self changesetSpecAHolder value.

    "Created: / 20-03-2012 / 00:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetASpec: spec
    ^self changesetSpecAHolder value: spec

    "Created: / 01-08-2012 / 15:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetB

    | specB |

    specB := self changesetSpecBHolder value.
    ^specB ifNil:[nil] ifNotNil:[specB changeSet]

    "Created: / 06-07-2011 / 11:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBSpec
    ^self changesetSpecBHolder value.

    "Created: / 20-03-2012 / 00:01:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBSpec: spec
    ^self changesetSpecBHolder value: spec

    "Created: / 01-08-2012 / 15:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBase

    | specBase |

    specBase := self changesetSpecBaseHolder value.
    ^specBase ifNil:[nil] ifNotNil:[specBase changeSet]

    "Created: / 16-03-2012 / 13:48:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBaseSpec
    ^self changesetSpecBaseHolder value.

    "Created: / 20-03-2012 / 00:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBaseSpec: spec
    ^self changesetSpecBaseHolder value: spec

    "Created: / 01-08-2012 / 15:38:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetMerged

    | specMerged |

    specMerged := self changesetSpecMergedHolder value.
    ^specMerged ifNil:[nil] ifNotNil:[specMerged changeSet]

    "Created: / 20-03-2012 / 00:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetMergedSpec
    ^self changesetSpecMergedHolder value.

    "Created: / 20-03-2012 / 00:01:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetMergedSpec: spec
    ^self changesetSpecMergedHolder value: spec

    "Created: / 01-08-2012 / 15:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffInfo
    "Returns a ChangeSetDiffInfo based on current data"

    | info |
    info := ChangeSetDiffInfo new.
    info specA: self changeSetASpec.
    info specB: self changeSetBSpec.
    self changesetSpecBaseEnabledHolder value ifTrue:[
	info specBase: self changeSetBaseSpec.
    ].
    changesetSpecMergedEnabledHolder value ifTrue:[
	info specMerge: self changeSetMergedSpec.
    ].
    ^info

    "Created: / 01-08-2012 / 15:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffInfo: info
    "Sets up dialog for given diff info"

    info isNil ifTrue:[ ^ self ].

    self changeSetASpec: info specA.
    self changeSetBSpec: info specB.
    self changeSetBaseSpec: info specBase.
    self changeSetMergedSpec: info specMerge.

    "Created: / 01-08-2012 / 15:37:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog methodsFor:'aspects'!

changesetSpecAHolder
    "return/create the 'changesetSpecAHolder' value holder (automatically generated)"

    changesetSpecAHolder isNil ifTrue:[
        changesetSpecAHolder := ValueHolder new.
    ].
    ^ changesetSpecAHolder
!

changesetSpecAHolder:something
    "set the 'changesetSpecAHolder' value holder (automatically generated)"

    changesetSpecAHolder := something.
!

changesetSpecBHolder
    "return/create the 'changesetSpecBHolder' value holder (automatically generated)"

    changesetSpecBHolder isNil ifTrue:[
        changesetSpecBHolder := ValueHolder new.
    ].
    ^ changesetSpecBHolder
!

changesetSpecBHolder:something
    "set the 'changesetSpecBHolder' value holder (automatically generated)"

    changesetSpecBHolder := something.
!

changesetSpecBaseEnabledHolder
    "return/create the 'changesetSpecBaseEnabledHolder' value holder (automatically generated)"

    changesetSpecBaseEnabledHolder isNil ifTrue:[
	changesetSpecBaseEnabledHolder := false asValue
    ].
    ^ changesetSpecBaseEnabledHolder

    "Modified: / 19-03-2012 / 23:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetSpecBaseEnabledHolder:something
    "set the 'changesetSpecBaseEnabledHolder' value holder (automatically generated)"

    changesetSpecBaseEnabledHolder := something.
!

changesetSpecBaseHolder
    "return/create the 'changesetSpecBHolder' value holder (automatically generated)"

    changesetSpecBaseHolder isNil ifTrue:[
	changesetSpecBaseHolder := ValueHolder new.
    ].
    ^ changesetSpecBaseHolder

    "Created: / 16-03-2012 / 13:48:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetSpecBaseHolder:something
    "set the 'changesetSpecBHolder' value holder (automatically generated)"

    changesetSpecBaseHolder := something.

    "Created: / 16-03-2012 / 13:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetSpecMergedEnabledHolder
    "return/create the 'changesetSpecMergedEnabledHolder' value holder (automatically generated)"

    changesetSpecMergedEnabledHolder isNil ifTrue:[
	changesetSpecMergedEnabledHolder := false asValue
    ].
    ^ changesetSpecMergedEnabledHolder

    "Modified: / 19-03-2012 / 23:20:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetSpecMergedEnabledHolder:something
    "set the 'changesetSpecMergedEnabledHolder' value holder (automatically generated)"

    changesetSpecMergedEnabledHolder := something.
!

changesetSpecMergedHolder
    "return/create the 'changesetSpecMergedHolder' value holder (automatically generated)"

    changesetSpecMergedHolder isNil ifTrue:[
	changesetSpecMergedHolder := ValueHolder new.
    ].
    ^ changesetSpecMergedHolder
!

changesetSpecMergedHolder:something
    "set the 'changesetSpecMergedHolder' value holder (automatically generated)"

    changesetSpecMergedHolder := something.
!

doAcceptEnabled
    <resource: #uiAspect>

    ^BlockValue 
        with:[:a :b|a value notNil and:[b value notNil]]
        argument:self changesetSpecAHolder
        argument:self changesetSpecAHolder.

    "Modified: / 06-07-2011 / 11:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool::OpenDialog methodsFor:'events'!

closeAccept

    ^super closeAccept

    "Created: / 06-07-2011 / 12:09:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

