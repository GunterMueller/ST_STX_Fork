"
 COPYRIGHT (c) 2004 by eXept Software AG
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

ProjectList subclass:#HierarchicalProjectList
	instanceVariableNames:'hierarchicalProjectTree selectedProjectItems packageIcon
		hierarchicalProjectList hierarchicalProjectSelection
		packageToItemDictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

HierarchicalItemWithLabel subclass:#ProjectItem
	instanceVariableNames:'packageID'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalProjectList
!

!HierarchicalProjectList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Like a ClassList, but shows classes hierarchical.

    If topClassHolders value is non-nil, only that classes hierarchy
    is shown.

    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!HierarchicalProjectList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HierarchicalProjectList andSelector:#windowSpec
     HierarchicalProjectList new openInterface:#windowSpec
     HierarchicalProjectList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ProjectList'
          #name: 'ProjectList'
          #min: #(#Point 0 0)
          #bounds: #(#Rectangle 16 46 316 346)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalListView1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #hierarchicalProjectSelection
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #listModel: #hierarchicalProjectList
              #multipleSelectOk: true
              #highlightMode: #line
              #doubleClickSelector: #doubleClicked:
              #indicatorSelector: #indicatorPressed:
              #properties: 
             #(#PropertyListDictionary
                #dragArgument: nil
                #dropArgument: nil
                #canDropSelector: #canDrop:
                #dropSelector: #doDrop:
              )
            )
           )
         
        )
      )
!

xxwindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HierarchicalProjectList andSelector:#windowSpec
     HierarchicalProjectList new openInterface:#windowSpec
     HierarchicalProjectList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #windowSpec
	#window: 
       #(#WindowSpec
	  #label: 'ProjectList'
	  #name: 'ProjectList'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 721)
	  #bounds: #(#Rectangle 12 22 312 322)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#SelectionInTreeViewSpec
	      #name: 'List'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #model: #selectedProjectItems
	      #menu: #menuHolder
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #showRoot: false
	      #showDirectoryIndicator: true
	      #isMultiSelect: true
	      #valueChangeSelector: #selectionChangedByClick
	      #hierarchicalList: #hierarchicalProjectTree
	      #childrenSelector: #actionToRetrieveChildren
	      #highlightMode: #line
	      #doubleClickChannel: #doubleClickChannel
	    )
	   #(#HierarchicalListViewSpec
	      #name: 'HierarchicalListView1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #tabable: true
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #listModel: #hierarchicalProjectList
	      #multipleSelectOk: true
	      #highlightMode: #line
	      #doubleClickSelector: #doubleClicked:
	      #indicatorSelector: #indicatorPressed:
	      "/ #showLeftIndicators: false
	    )
	   )
         
	)
      )
! !

!HierarchicalProjectList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        environmentHolder
        #(#doubleClickChannel #action )
        #forceGeneratorTrigger
        #hideUnloadedClasses
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #organizerMode
        #outGeneratorHolder
        #selectedProjects
        #selectionChangeCondition
        #slaveMode
        #updateTrigger
        #showCoverageInformation
      ).

    "Modified: / 20-07-2011 / 14:29:26 / cg"
    "Modified: / 24-02-2014 / 10:37:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalProjectList methodsFor:'aspects'!

generateHierarchicalProjectTree
    |anchor|

    self projectList value isNil ifTrue:[
	self updateList.
	self projectList value isNil ifTrue:[
	    ^ nil.
	]
    ].

    anchor := ProjectItem new.
    anchor package:''.
    anchor label:nil.

    packageToItemDictionary := IdentityDictionary new.
    packageToItemDictionary at:'' asSymbol put:anchor.

    self projectList value do:[:eachPackageString |
	|package|

	package := eachPackageString asSymbol.
	(packageToItemDictionary includesKey:package) ifFalse:[
	    self addPackage:package 
	].
    ].

"/    environment allClassesDo:[:eachClass |
"/        |package|
"/
"/        package := eachClass package asSymbol.
"/        (packageToItemDictionary includesKey:package) ifFalse:[
"/            self addPackage:package 
"/        ].
"/    ].
    anchor recursiveSortChildren:[:i1 :i2 | i1 label asLowercase < i2 label asLowercase].
    anchor expand.

    ^ anchor
!

hierarchicalProjectList
    |anchor |

    hierarchicalProjectList isNil ifTrue:[
        hierarchicalProjectList := HierarchicalList new.
        hierarchicalProjectList showRoot:false.

        (self slaveMode value ~~ true) ifTrue:[
            anchor := self generateHierarchicalProjectTree.
            hierarchicalProjectList root:anchor.
            self setListValid:true.
        ] ifFalse:[
            self setListValid:false
        ]
    ].
    ^ hierarchicalProjectList
!

hierarchicalProjectSelection
    hierarchicalProjectSelection isNil ifTrue:[
	hierarchicalProjectSelection := #() asValue.
	hierarchicalProjectSelection addDependent:self.
    ].
    ^ hierarchicalProjectSelection.
!

updateTreeSelection
    "/ must expand items as required
    |itemsToSelect oldSelection newSelection|

    itemsToSelect := OrderedCollection new.

    (self selectedProjects value ? #()) do:[:eachSelectedProject |
        |item child|

        item := hierarchicalProjectList root.
        item notNil ifTrue:[
            (eachSelectedProject asCollectionOfSubstringsSeparatedByAny:':/') do:[:part |
                item expand.
                child := item detect:[:child | child label = part] ifNone:nil.
                child notNil ifTrue:[
                    item := child.
                ].
            ].
            itemsToSelect add:child.
        ].
    ].
    oldSelection := hierarchicalProjectSelection value.
    newSelection := itemsToSelect collect:[:eachItem | hierarchicalProjectList identityIndexOf:eachItem].
    oldSelection ~= newSelection ifTrue:[
        hierarchicalProjectSelection value:newSelection.
    ].

    "Modified: / 17-08-2006 / 09:56:32 / cg"
! !

!HierarchicalProjectList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |cls sel oldMethod newMethod newPackage|

    self inSlaveModeOrInvisible ifTrue:[
	super delayedUpdate:something with:aParameter from:changedObject.
	^ self.
    ].

"/    (self slaveMode value == true) ifTrue:[
"/        super delayedUpdate:something with:aParameter from:changedObject.
"/        ^ self
"/    ].

    changedObject == updateTrigger ifTrue:[
	hierarchicalProjectList := nil.
	self hierarchicalProjectList.
	self updateTreeSelection.
	^ self        
    ].

    changedObject == slaveMode ifTrue:[
	listValid ~~ true ifTrue:[
	    self enqueueDelayedUpdateList
	].
	"/ self invalidateList.
	self updateTreeSelection.
	^  self
    ].

    changedObject == hierarchicalProjectSelection ifTrue:[
	self updateSelectionFromTree.
	^ self        
    ].
"/    changedObject == self selectedProjects ifTrue:[
"/        "/ update the trees selection as appropriate
"/        self updateTreeSelection.
"/    ].
    changedObject == projectList ifTrue:[
	"/ update the tree
	self hierarchicalProjectList root:(self generateHierarchicalProjectTree).
	^ self.
    ].
        
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 17.2.2000 / 23:41:02 / cg"
    "Modified: / 26.2.2000 / 01:21:49 / cg"
!

enqueueDelayedAddPackage:package
    (NewSystemBrowser synchronousUpdate == true
    or:[ immediateUpdate value == true ])
    ifTrue:[
        self addPackage:package.
        ^ self
    ].
    ^ self
        enqueueMessage:#addPackage:
        for:self
        arguments:(Array with:package)
!

update:something with:aParameter from:changedObject
    something == #methodTrap ifTrue:[
        "/ don't care for that.
        ^ self.
    ].
    changedObject == organizerMode ifTrue:[
        "/ don't care for that.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject
!

updateSelectionFromTree
    |treeSelection|

    treeSelection := hierarchicalProjectSelection value 
		    collect:[:eachIndex |  |item|
				    item := hierarchicalProjectList at:eachIndex ifAbsent:nil.
				    item package
			    ].

    treeSelection asSet ~= (self selectedProjects value ? #()) asSet ifTrue:[
	self selectedProjects value:treeSelection.
    ]
! !

!HierarchicalProjectList methodsFor:'private'!

addPackage:package
    |i p pp l parentPackage parentItem idx|

    i:= packageToItemDictionary at:package asSymbol ifAbsent:nil.
    i isNil ifTrue:[
        i := ProjectItem new.
        i package:package.
        packageToItemDictionary at:package asSymbol put:i.

        package size > 0 ifTrue:[
            "/ find the parent ...
            p := package asCollectionOfSubstringsSeparatedByAny:':/.'.
            pp := p copyButLast.
            l := (pp asStringWith:$/) size.
            parentPackage := package copyTo:l.

            parentItem := self addPackage:parentPackage asSymbol .

            parentPackage size == 0 ifTrue:[
                idx := 1.
            ] ifFalse:[
                idx := parentPackage size + 2
            ].
            i label:(package copyFrom:idx).

            parentItem add:i sortBlock:[:i1 :i2 | i1 label asLowercase < i2 label asLowercase].

            "/ TODO: special items for classes, resources etc.
        
        ]
    ].
    ^ i
!

release
    super release.

    hierarchicalProjectSelection removeDependent:self.
! !

!HierarchicalProjectList methodsFor:'user actions'!

doubleClicked:anIndex
    |item|

    item := hierarchicalProjectList at:anIndex ifAbsent:nil.
    item isNil ifTrue:[
	^ self
    ].        

    (item canExpand not or:[item isExpanded]) ifTrue:[
	doubleClickChannel notNil ifTrue:[
	    doubleClickChannel value:anIndex.
	].
	^ self
    ].

    item expand.
!

indicatorPressed:anIndex
    |item sensor|

    item := hierarchicalProjectList at:anIndex ifAbsent:nil.

    item isNil ifTrue:[
	^ self
    ].

    sensor := self window sensor.
    (sensor ctrlDown or:[sensor shiftDown]) ifTrue:[
	item recursiveToggleExpand
    ] ifFalse:[
	item toggleExpand
    ].
! !

!HierarchicalProjectList::ProjectItem methodsFor:'accessing'!

children
    children isNil ifTrue:[
        children := #()
    ].
    ^ children
!

icon
    ^ SystemBrowser packageIcon
!

label:aString
    label ~= aString ifTrue:[
        label := aString.
        self changed:#label
    ].
!

package
    ^ packageID
!

package:prefixOrPackageID
    packageID := prefixOrPackageID
! !

!HierarchicalProjectList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalProjectList.st,v 1.16 2014-11-19 21:41:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalProjectList.st,v 1.16 2014-11-19 21:41:12 cg Exp $'
! !

