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

ApplicationModel subclass:#ClassRevisionTree
	instanceVariableNames:'selectionHolder dataHolder menuBlock selectionBlock listView
		hierarchicalList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ClassRevisionTree class methodsFor:'documentation'!

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

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"

! !

!ClassRevisionTree class methodsFor:'interface spec'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassRevisionTree andSelector:#windowSpec
     ClassRevisionTree new openInterface:#windowSpec
     ClassRevisionTree open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ClassVersionTree'
          #name: 'ClassVersionTree'
          #min: #(#Point 10 10)
          #max: #(#Point 9999 9999)
          #bounds: #(#Rectangle 16 46 881 575)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalItemListView'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #menu: #selectItemMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #listModel: #listModel
              #multipleSelectOk: true
              #useIndex: false
              #highlightMode: #label
              #doubleClickSelector: #doubleClick:
              #selectConditionSelector: #isItemSelectable:
              #indicatorSelector: #doubleClick:
              #retrieveIconsSelector: #icons
            )
           )
         
        )
      )
! !

!ClassRevisionTree class methodsFor:'protocol'!

classItemRootClass

    ^ClassItemRoot
! !

!ClassRevisionTree class methodsFor:'startup'!

openOnClassHolder:aClassHolder

    |theTree|

    theTree := self new.
    theTree allButOpen.
    theTree classItemRootClass:ClassItemRoot.
    theTree classHolder:aClassHolder.
    theTree openWindow.
     ^theTree

"
|theSelectionHolder theClassHolder theTree|

theSelectionHolder := ValueHolder new.
theClassHolder := ValueHolder new.
theSelectionHolder compute:[:coll |
                coll do:[:each | Transcript showCR: each]].
theClassHolder value:(Smalltalk allClasses asOrderedCollection sort:[:x : y|x name < y name]).
theTree := ClassRevisionTree openOnClassHolder:theClassHolder.
theSelectionHolder value:(Array with:(theTree itemList children last)).
theTree selectionHolder:theSelectionHolder.
Delay waitForMilliseconds:1500.
theClassHolder value:(Project current changedClasses asOrderedCollection).
Delay waitForMilliseconds:1500.
theTree classHolder:nil.
Delay waitForMilliseconds:1500.
theTree classHolder:theClassHolder.
Delay waitForMilliseconds:1500.
theClassHolder value:(Smalltalk allClasses asOrderedCollection sort:[:x : y|x name < y name]).
"



!

openOnClassRevisionInfoColl:aClassRevisionInfoColl

    |theTree|

    theTree := self new.
    theTree allButOpen.
    theTree classItemRootClass:ClassItemRootForRevision.
    theTree dataHolder value:aClassRevisionInfoColl.
    theTree openWindow.
     ^theTree
"
|theTree infoLog|

infoLog := OrderedCollection new.
CVSSourceCodeManager reportHistoryLogSince:'yesterday'
        filterSTSources:true 
        filterUser:nil 
        filterRepository:nil 
        inTo:[:info| infoLog add:info].

theTree := self new.
theTree open.
theTree classItemRootClass:ClassItemRootForRevision.
theTree setupOnClasses:infoLog
"

"
|infoLog|

infoLog := OrderedCollection new.
CVSSourceCodeManager reportHistoryLogSince:'yesterday'
        filterSTSources:true 
        filterUser:nil 
        filterRepository:nil 
        inTo:[:info| infoLog add:info].
self openOnClassRevisionInfoColl:infoLog.
"
!

openOnClasses:aClassColl

    |theTree|

    theTree := self new.
    theTree classItemRootClass:ClassItemRoot.
    theTree allButOpen.
    theTree setupOnClasses:aClassColl.
    theTree openWindow.
    ^theTree
"
self openOnClasses:(Smalltalk allClasses asOrderedCollection sort:[:x : y|x name < y name]).
"

"
|theSelectionHolder theTree|

theSelectionHolder := ValueHolder new.
theSelectionHolder compute:[:coll |
                coll do:[:each | Transcript showCR: each]].
theTree := ClassRevisionTree openOnClasses:(Smalltalk allClasses asOrderedCollection sort:[:x : y|x name < y name]).
theSelectionHolder value:(Array with:(theTree itemList children last)).
theTree selectionHolder:theSelectionHolder.
"
! !

!ClassRevisionTree methodsFor:'accessing'!

dataHolder
    "return the value of the instance variable 'classHolder' (automatically generated)"

    ^dataHolder ifNil:[
        dataHolder := ValueHolder new.
        dataHolder addDependent:self
    ]
!

dataHolder:aValueHolder
    "set the value of the instance variable 'classHolder' (automatically generated)"

    (dataHolder ~~ aValueHolder) ifTrue:[
        dataHolder removeDependent:self.
        dataHolder := aValueHolder.
        dataHolder notNil ifTrue:[
            dataHolder addDependent:self.
        ].
        self setUpList
    ].
!

hierarchicalList
"
returns a hierarchical list which is the model for tree. All necassary things like icons,
root and subnodes must be hold by this list. Therefore the list must have a special protocoll.
See examples.

<return: HierarchicalList>
"

    hierarchicalList isNil
        ifTrue:[self error: 'no necessary list is set'. "hierarchicalList := HierarchicalList new"].
    ^ hierarchicalList
!

hierarchicalList:aHierarchicalList
"
sets the hierarchical list which is the model for tree. All necassary things like icons
root and subnodes must be hold by this list. Therefore the list must have a special protocoll.
See examples.

<return: self>
"

    hierarchicalList := aHierarchicalList.
!

itemForSelectionIndex:anIndex
"

<return: HierarchicalItem | nil >
"
    ^self listModel at:anIndex ifAbsent:nil
!

itemList
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    ^ self listModel root





!

listView
    "return the value of the instance variable 'listView' (automatically generated)"

    ^ listView
!

listView:something
    "set the value of the instance variable 'listView' (automatically generated)"

    listView := something.
! !

!ClassRevisionTree methodsFor:'actions'!

doubleClick:anIndex

    |theItem|

    theItem := self itemForSelectionIndex:anIndex. self halt.
    self listModel root doubleClickOn:theItem.

!

isItemSelectable:anIndex
"
checks if an item at anIndex can be selected. If an selection block
is set, evaluate it with the selected item.
(Callback from the tree).

<return: Boolean>
"
   selectionBlock ifNil:[^true].
   ^selectionBlock value:(self itemForSelectionIndex:anIndex)

! !

!ClassRevisionTree methodsFor:'aspects'!

icons
"
gets the icons from hierarchical list which should be registered on the view. 

<return: Dictionary of: Symbol->Image | nil>
"
    ^self hierarchicalList icons
!

listModel
"

<return: HierarchicalList>
"
    |holder|

    (holder := builder bindingAt:#listModel) isNil ifTrue:[
        holder := self hierarchicalList.
        builder aspectAt:#listModel put:holder.
        holder application:self.
    ].
    ^ holder.
! !

!ClassRevisionTree methodsFor:'change & update'!

update:something with:aParameter from:changedObject

     changedObject == self dataHolder
        ifTrue:[self setUpList].


! !

!ClassRevisionTree methodsFor:'interface opening'!

postBuildWith: aBuilder

    super postBuildWith: aBuilder.
    self listView:(self builder componentAt:#HierarchicalItemListView).
    selectionHolder notNil
        ifTrue:[listView model:selectionHolder].
    self listView useDefaultIcons:false.
!

release

"/    self stopItemTask.    
    ^super release


! !

!ClassRevisionTree methodsFor:'menu actions'!

selectItemMenu
"
get the menu for the selected items.If a menuBlock is set then evalute this block
with the current selection.

<return: Menu|nil>
"
    ^ [ menuBlock value ]
! !

!ClassRevisionTree methodsFor:'private'!

setUpList

    ^self hierarchicalList newData: self dataHolder value

    "Modified: / 18.2.2000 / 15:05:35 / cg"
! !

!ClassRevisionTree methodsFor:'protocol accessing'!

menuBlock
    "return the value of the instance variable 'menuBlock' (automatically generated)"

    ^ menuBlock
!

menuBlock:something
    "set the value of the instance variable 'menuBlock' (automatically generated)"

    menuBlock := something.
!

selectionBlock
    "return the value of the instance variable 'selectionBlock' (automatically generated)"

    ^ selectionBlock
!

selectionBlock:something
    "set the value of the instance variable 'selectionBlock' (automatically generated)"

    selectionBlock := something.
!

selectionHolder

    ^selectionHolder
!

selectionHolder:aValueHolder
    "set the value of the instance variable 'revisionItemSelection' (automatically generated)"

    selectionHolder := aValueHolder.
    self listView ifNil:[^self].
    self listView model:selectionHolder
! !

!ClassRevisionTree methodsFor:'protocol setup'!

setupOnData:aDataObject

    self dataHolder value:aDataObject.
"
|theTree infoLog theHierarchicalList|

theTree := ClassRevisionTree new.
theHierarchicalList := HierarchicalClassRevisionList new.
theTree hierarchicalList:theHierarchicalList.
theTree open.
infoLog := OrderedCollection new.
theTree setupOnData:infoLog.
"
"
|theTree infoLog theHierarchicalList|

theTree := ClassRevisionTree new.
theHierarchicalList := HierarchicalClassRevisionList new.
theTree hierarchicalList:theHierarchicalList.
infoLog := OrderedCollection new.
CVSSourceCodeManager reportHistoryLogSince:'yesterday'
        filterSTSources:true 
        filterUser:nil 
        filterRepository:nil 
        inTo:[:info| infoLog add:info].
theTree open.
theTree setupOnData:infoLog.
"
! !

!ClassRevisionTree class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ClassRevisionTree.st,v 1.9 2000/02/18 14:08:48 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

