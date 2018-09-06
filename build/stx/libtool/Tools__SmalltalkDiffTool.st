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

ApplicationModel subclass:#SmalltalkDiffTool
	instanceVariableNames:'diffSetHolder changeSetA changeSetB selectionHolder titleHolder
		showMergingChangeSetHolder versionsViewHolder ignoreExtensions'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff & Merge tool'
!

Object subclass:#DiffItem
	instanceVariableNames:'versionA versionB'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkDiffTool
!

!SmalltalkDiffTool class methodsFor:'documentation'!

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
! !

!SmalltalkDiffTool class methodsFor:'interface opening'!

openOnDiffSet:diffSet labelA:labelA labelB: labelB title: title
    ^ self
        openOnDiffSet:diffSet labelA:labelA labelB: labelB title: title 
        ignoreExtensions:false

    "Created: / 19-04-2008 / 12:52:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-09-2011 / 11:52:20 / cg"
!

openOnDiffSet:diffSet labelA:labelA labelB: labelB title: title ignoreExtensions:aBoolean

    ^self new
        ignoreExtensions:aBoolean;
        diffSet: diffSet labelA: labelA labelB: labelB;
        title: title;
        open

    "Created: / 19-04-2008 / 12:52:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 12-09-2011 / 11:51:11 / cg"
! !

!SmalltalkDiffTool class methodsFor:'interface specs'!

conflictsListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::DiffTool andSelector:#conflictsListSpec
     Tools::DiffTool new openInterface:#conflictsListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: conflictsListSpec
        window: 
       (WindowSpec
          label: 'VersionBothListSpec'
          name: 'VersionBothListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Conflicts (present in both A and B)'
              name: 'VersionBothLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: conflictsLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionBothList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: conflictsListHolder
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )

    "Modified: / 21-05-2008 / 14:20:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inAOnlyListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MergeTool andSelector:#inAOnlyListSpec
     MergeTool new openInterface:#inAOnlyListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: inAOnlyListSpec
        window: 
       (WindowSpec
          label: 'VersionAOnlyListSpec'
          name: 'VersionAOnlyListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'In A only'
              name: 'VersionAOnlyLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: inAOnlyLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionAOnlyList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: inAOnlyListHolder
              useIndex: false
              highlightMode: line
              postBuildCallback: postBuildVersionAListWidget:
            )
           )
         
        )
      )

    "Modified: / 11-12-2007 / 16:46:29 / janfrog"
    "Created: / 19-04-2008 / 12:52:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-05-2008 / 14:20:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inBOnlyListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MergeTool andSelector:#inBOnlyListSpec
     MergeTool new openInterface:#inBOnlyListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: inBOnlyListSpec
        window: 
       (WindowSpec
          label: 'VersionBOnlyListSpec'
          name: 'VersionBOnlyListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'In B only'
              name: 'VersionBOnlyLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: inBOnlyLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionBOnlyList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: inBOnlyListHolder
              postBuildCallback: postBuildVersionBListWidget:
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )

    "Modified: / 11-12-2007 / 16:46:33 / janfrog"
    "Created: / 19-04-2008 / 12:52:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-05-2008 / 14:20:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::DiffTool andSelector:#windowSpec
     Tools::DiffTool new openInterface:#windowSpec
     Tools::DiffTool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'MergeTool'
          name: 'MergeTool'
          labelChannel: titleHolder
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 602 508)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'ContentPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (VariableHorizontalPanelSpec
                    name: 'VersionListPanel'
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'VersionAOnlyListSpec'
                          minorKey: inAOnlyListSpec
                        )
                       (UISubSpecification
                          name: 'VersionBothListSpec'
                          minorKey: conflictsListSpec
                        )
                       (UISubSpecification
                          name: 'VersionBOnlyListSpec'
                          minorKey: inBOnlyListSpec
                        )
                       )
                     
                    )
                    handles: (Any 0.33333333333333 0.66666666666667 1.0)
                  )
                 (ArbitraryComponentSpec
                    name: 'ArbitraryComponent1'
                    hasBorder: false
                    viewChannel: versionsViewHolder
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )

    "Modified: / 07-10-2008 / 11:03:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool class methodsFor:'plugIn spec'!

aspectSelectors

    ^ #(
        #diffSetHolder
        #inAOnlyLabelHolder
        #inBOnlyLabelHolder
      ).

    "Created: / 02-04-2009 / 16:07:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 09:19:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'accessing'!

changeSetA
    ^ changeSetA

    "Created: / 07-10-2008 / 10:38:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetA:aChangeSet
    changeSetA := aChangeSet.

    "Created: / 07-10-2008 / 10:38:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetB
    ^ changeSetB

    "Created: / 07-10-2008 / 10:38:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetB:aChangeSet
    changeSetB := aChangeSet.
    self changeSetsChanged.

    "Created: / 07-10-2008 / 10:38:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffItemClass
    ^ SmalltalkDiffTool::DiffItem

    "Created: / 21-05-2008 / 14:38:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 14:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSet
    ^ diffSetHolder value

    "Created: / 07-10-2008 / 10:39:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:10:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSet:aDiffSet

    self diffSetHolder value: aDiffSet

    "Modified: / 07-12-2007 / 11:39:15 / janfrog"
    "Created: / 19-04-2008 / 12:58:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-04-2009 / 23:45:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSet:aDiffSet labelA:labelA labelB:labelB 
    self onlyInALabel:labelA.
    self onlyInBLabel:labelB.
    self diffSet:aDiffSet

    "Modified: / 11-12-2007 / 17:10:49 / janfrog"
    "Created: / 19-04-2008 / 12:58:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:24:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

ignoreExtensions:something
    ignoreExtensions := something.
!

onlyInALabel:labelA 
    self inAOnlyLabelHolder value:'Only in ', labelA

    "Created: / 07-10-2008 / 10:24:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

onlyInBLabel:labelB 
    self inBOnlyLabelHolder value:'Only in ', labelB

    "Created: / 07-10-2008 / 10:24:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selection

    ^self selectionHolder value asCollection

    "Created: / 21-10-2008 / 09:32:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionIsNonEmpty

    ^[self selection notEmptyOrNil ]

    "Created: / 19-04-2008 / 12:58:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 13:14:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 21:31:28 / cg"
!

selectionIsNonEmptyAndAllHasVersionA

    ^[self selection notEmptyOrNil 
        and:[self selection allSatisfy:[:mergeItem|mergeItem hasVersionA]]]

    "Created: / 19-04-2008 / 12:58:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 13:14:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 21:31:24 / cg"
!

selectionIsNonEmptyAndAllHasVersionB

    ^[self selection notEmptyOrNil 
        and:[self selection allSatisfy:[:mergeItem|mergeItem hasVersionB]]]

    "Created: / 19-04-2008 / 12:58:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 13:14:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 21:31:19 / cg"
!

title

    self titleHolder value

    "Created: / 19-04-2008 / 12:58:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

title: aString

    self titleHolder value: aString

    "Created: / 19-04-2008 / 12:58:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionAColor

    ^Color green lightened lightened

    "Created: / 19-04-2008 / 12:58:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionBColor

    ^Color red lightened lightened

    "Created: / 19-04-2008 / 12:58:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'aspects'!

conflictsLabelHolder

    |holder|

    (holder := builder bindingAt:#conflictsLabelHolder) isNil ifTrue:[
        holder := 'Conflicts' asValue.
        builder aspectAt:#conflictsLabelHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:36:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

conflictsListHolder

    |holder|

    (holder := builder bindingAt:#conflictsListHolder) isNil ifTrue:[
        holder := #() asValue.
        builder aspectAt:#conflictsListHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:36:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSetHolder

    diffSetHolder ifNil:
        [self diffSetHolder: ChangeSet::DiffSet new asValue].
    ^diffSetHolder

    "Created: / 02-04-2009 / 16:09:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 18:01:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSetHolder:aValueHolder
    diffSetHolder := aValueHolder.
    diffSetHolder onChangeSend: #diffSetChanged to: self

    "Modified: / 02-04-2009 / 18:01:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inAOnlyLabelHolder

    |holder|

    (holder := builder bindingAt:#inAOnlyLabelHolder) isNil ifTrue:[
        holder := 'Only in A' asValue.
        builder aspectAt:#inAOnlyLabelHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:48:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inAOnlyLabelHolder: anValueHolder

    builder aspectAt:#inAOnlyLabelHolder put:anValueHolder.

    "Created: / 09-04-2009 / 09:19:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inAOnlyListHolder

    |holder|

    (holder := builder bindingAt:#inAOnlyListHolder) isNil ifTrue:[
        holder :=#() asValue.
        builder aspectAt:#inAOnlyListHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:48:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inBOnlyLabelHolder

    |holder|

    (holder := builder bindingAt:#inBOnlyLabelHolder) isNil ifTrue:[
        holder := 'Only in B' asValue.
        builder aspectAt:#inBOnlyLabelHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:48:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inBOnlyLabelHolder: anValueHolder

    builder aspectAt:#inBOnlyLabelHolder put:anValueHolder.

    "Created: / 09-04-2009 / 09:19:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inBOnlyListHolder

    |holder|

    (holder := builder bindingAt:#inBOnlyListHolder) isNil ifTrue:[
        holder :=#() asValue.
        builder aspectAt:#inBOnlyListHolder put:holder.
    ].
    ^ holder.

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:48:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionHolder

    selectionHolder ifNil:
        [selectionHolder := nil asValue.
        selectionHolder 
            onChangeSend:#selectionChanged to: self].
    ^selectionHolder

    "Created: / 19-04-2008 / 12:57:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-05-2008 / 19:30:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showMergingChangeSetHolder
    "return/create the 'showMergingChangeSetHolder' value holder (automatically generated)"

    showMergingChangeSetHolder isNil ifTrue:[
        showMergingChangeSetHolder := false asValue
    ].
    ^ showMergingChangeSetHolder

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil ifTrue:[
        titleHolder := 'Merge tool' asValue
    ].
    ^ titleHolder

    "Created: / 19-04-2008 / 12:57:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionsViewHolder
    "return/create the 'versionsViewHolder' value holder (automatically generated)"

    versionsViewHolder isNil ifTrue:[
        versionsViewHolder := HVScrollableView new.
    ].
    ^ versionsViewHolder

    "Created: / 07-10-2008 / 08:58:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 14:49:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'change & update'!

changeSetsChanged

    self diffSet:
        ((changeSetA notNil and:[changeSetB notNil]) 
            ifTrue:[changeSetA diffSetsAgainst: changeSetB]
            ifFalse:[ChangeSet::DiffSet new])

    "Created: / 07-10-2008 / 10:42:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

diffSetChanged

    |onlyInA changed onlyInB|

    self builder ifNil:[^self].
    self diffSet ifNil:[^self].
    onlyInA := self diffSet onlyInReceiver ? #()
                collect:[:change | self diffItemClass versionA:change ].
    changed := self diffSet changed ? #()
                collect:[:changes | self diffItemClass versionA:changes first versionB:changes second ].
    onlyInB := self diffSet onlyInArg ? #()
                collect:[:change | self diffItemClass versionB:change ].
    self inAOnlyListHolder value:onlyInA.
    self conflictsListHolder value:changed.
    self inBOnlyListHolder value:onlyInB.
    self resolutionChanged

    "Created: / 07-10-2008 / 10:42:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:43:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolutionChanged

    self inAOnlyListHolder changed.
    self conflictsListHolder changed.
    self inBOnlyListHolder changed.

    "Created: / 19-04-2008 / 12:57:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionChanged

    self showVersionsFor: 
        (self selection size = 1 ifTrue:[self selection anyOne] ifFalse:[nil])

    "Created: / 19-04-2008 / 12:57:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-10-2008 / 09:31:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'hooks'!

commonPostBuild

    self diffSetChanged

    "Created: / 07-10-2008 / 10:47:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

postBuildVersionAListWidget: widget

    widget scrolledView backgroundColor: self versionAColor

    "Created: / 19-04-2008 / 12:57:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

postBuildVersionBListWidget: widget

    widget scrolledView backgroundColor: self versionBColor

    "Created: / 19-04-2008 / 12:57:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder.

    "Created: / 07-10-2008 / 10:57:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:10:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool methodsFor:'private'!

showVersionAAndBAndMergedFor: mergeItem

    ^self showVersionAAndBFor: mergeItem

    "Created: / 19-04-2008 / 12:56:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionAAndBFor: mergeItem

    | diffView |

    diffView := (self versionsView isKindOf:DiffTextView) 
                    ifFalse:[DiffTextView new]
                    ifTrue:[self versionsView].

    "/self diff2TextView initialize.
    diffView
        text1: mergeItem versionASource
        text2: mergeItem versionBSource.
    diffView leftTextView backgroundColor: self versionAColor.
    diffView rightTextView backgroundColor: self versionBColor.
    self versionsView: diffView

    "Modified: / 07-12-2007 / 21:31:12 / janfrog"
    "Created: / 19-04-2008 / 12:56:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:28:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionAAndMergedFor: mergeItem

    ^self showVersionAFor: mergeItem

    "Created: / 19-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionAFor: aMergeItem

    | textView |

    textView := (self versionsView isKindOf:TextView) 
                    ifFalse:[TextView new]
                    ifTrue:[self versionsView].

    textView contents: aMergeItem versionASource.
    textView backgroundColor: self versionAColor.
    self versionsView: textView.

    "Created: / 19-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:29:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionBAndMergedFor: mergeItem

    ^self showVersionBFor: mergeItem

    "Created: / 19-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionBFor: aMergeItem

    | textView |

    textView := (self versionsView isKindOf:TextView) 
                    ifFalse:[TextView new]
                    ifTrue:[self versionsView].

    textView contents: aMergeItem versionBSource.
    textView backgroundColor: self versionBColor.
    self versionsView: textView.

    "Created: / 19-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 10:29:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showVersionsFor: mergeItem

    mergeItem ifNil:[^self versionsView: nil].
    mergeItem showVersionsIn: self.

    "Created: / 19-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 09:03:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionsView

    ^self versionsViewHolder value scrolledView

    "Created: / 07-10-2008 / 09:59:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 11:05:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionsView: aView

    self versionsViewHolder value scrolledView:aView

    "Created: / 07-10-2008 / 08:58:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-10-2008 / 11:05:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool::DiffItem class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libtool/Tools__SmalltalkDiffTool.st,v 1.9 2013-08-19 16:01:16 stefan Exp $'
! !

!SmalltalkDiffTool::DiffItem class methodsFor:'instance creation'!

versionA: changeA

    ^self new 
        versionA: changeA

    "Created: / 06-12-2007 / 17:51:17 / janfrog"
    "Modified: / 06-12-2007 / 21:26:59 / janfrog"
    "Modified: / 21-05-2008 / 14:15:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionA: changeA versionB: changeB

    ^self new 
        versionA: changeA;
        versionB: changeB

    "Created: / 06-12-2007 / 17:51:31 / janfrog"
!

versionB: changeB

    ^self new 
        versionB: changeB

    "Created: / 06-12-2007 / 17:51:37 / janfrog"
    "Modified: / 06-12-2007 / 21:27:14 / janfrog"
    "Modified: / 21-05-2008 / 14:15:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkDiffTool::DiffItem methodsFor:'accessing'!

version
    ^ versionA ? versionB

    "Created: / 21-05-2008 / 11:54:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionA
    ^ versionA

    "Created: / 06-12-2007 / 17:36:51 / janfrog"
!

versionA:something
    versionA := something.

    "Created: / 06-12-2007 / 17:36:51 / janfrog"
!

versionASource
    ^ versionA 
        ifNil:[nil]
        ifNotNil:[versionA source]

    "Created: / 07-12-2007 / 12:16:49 / janfrog"
!

versionB
    ^ versionB

    "Created: / 06-12-2007 / 17:36:51 / janfrog"
!

versionB:something
    versionB := something.

    "Created: / 06-12-2007 / 17:36:51 / janfrog"
!

versionBSource
    ^ versionB 
        ifNil:[nil]
        ifNotNil:[versionB source]

    "Created: / 07-12-2007 / 12:17:01 / janfrog"
! !

!SmalltalkDiffTool::DiffItem methodsFor:'displaying'!

displayChangeOn: aGC x:x y:y

    self displayString displayOn: aGC x:x y:y

    "Created: / 06-12-2007 / 21:06:18 / janfrog"
!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    ^ self version printOn:aGCOrStream

    "Created: / 06-12-2007 / 21:10:22 / janfrog"
    "Modified: / 12-12-2007 / 15:14:31 / janfrog"
    "Modified: / 08-11-2008 / 09:28:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

displayOn: aGC x:x y:y

    self displayChangeOn: aGC x:x y:y.

    "Created: / 21-05-2008 / 11:55:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

 !

!SmalltalkDiffTool::DiffItem methodsFor:'queries'!

hasVersionA

    ^versionA notNil

    "Created: / 11-12-2007 / 16:42:22 / janfrog"
!

hasVersionB

    ^versionB notNil

    "Created: / 11-12-2007 / 16:42:26 / janfrog"
! !

!SmalltalkDiffTool::DiffItem methodsFor:'testing'!

isMergedVersionDifferent

    ^false

    "Created: / 21-05-2008 / 14:17:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isMethodChange

    "Created: / 11-12-2007 / 18:39:35 / janfrog"
! !

!SmalltalkDiffTool::DiffItem methodsFor:'ui support'!

showVersionAAndBAndMergedIn: aMergeTool

    self isMergedVersionDifferent
        ifTrue:[aMergeTool showVersionAAndBAndMergedFor: self]
        ifFalse:[aMergeTool showVersionAAndBFor: self]

    "Created: / 07-12-2007 / 13:05:45 / janfrog"
!

showVersionAAndMergedIn: aMergeTool

    self isMergedVersionDifferent
        ifTrue:[aMergeTool showVersionAAndMergedFor: self]
        ifFalse:[aMergeTool showVersionAFor: self]

    "Created: / 07-12-2007 / 13:03:05 / janfrog"
!

showVersionBAndMergedIn: aMergeTool

    self isMergedVersionDifferent
        ifTrue:[aMergeTool showVersionBAndMergedFor: self]
        ifFalse:[aMergeTool showVersionBFor: self]

    "Created: / 07-12-2007 / 13:03:05 / janfrog"
!

showVersionsIn: aMergeTool

    (versionA notNil and:[versionB isNil])
        ifTrue:[^self showVersionAAndMergedIn: aMergeTool].
    (versionA notNil and:[versionB notNil])
        ifTrue:[^self showVersionAAndBAndMergedIn: aMergeTool].
    (versionA isNil and:[versionB notNil])
        ifTrue:[^self showVersionBAndMergedIn: aMergeTool].

    "Created: / 07-12-2007 / 12:57:39 / janfrog"
! !

!SmalltalkDiffTool class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__SmalltalkDiffTool.st,v 1.9 2013-08-19 16:01:16 stefan Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__SmalltalkDiffTool.st,v 1.9 2013-08-19 16:01:16 stefan Exp $'
! !

