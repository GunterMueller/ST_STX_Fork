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

ClassCategoryList subclass:#HierarchicalClassCategoryList
	instanceVariableNames:'hierarchicalCategoryTree hierarchicalCategoryList
		hierarchicalCategorySelection categoryToItemDictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

HierarchicalItemWithLabel subclass:#ClassCategoryItem
	instanceVariableNames:'category'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalClassCategoryList
!

!HierarchicalClassCategoryList class methodsFor:'documentation'!

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
    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!HierarchicalClassCategoryList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HierarchicalClassCategoryList andSelector:#windowSpec
     HierarchicalClassCategoryList new openInterface:#windowSpec
     HierarchicalClassCategoryList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ClassCategoryList'
          #name: 'ClassCategoryList'
          #min: #(#Point 0 0)
          #bounds: #(#Rectangle 16 46 316 346)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'List'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #hierarchicalCategorySelection
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #listModel: #hierarchicalCategoryList
              #multipleSelectOk: true
              #highlightMode: #line
              #doubleClickSelector: #doubleClicked:
              #showLines: false
              #indicatorSelector: #indicatorPressed:
              #useDefaultIcons: false
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
! !

!HierarchicalClassCategoryList class methodsFor:'plugIn spec'!

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
        #nameSpaceFilter
        #organizerMode
        #outGeneratorHolder
        #packageFilter
        #selectedCategories
        #selectionChangeCondition
        #slaveMode
        #updateTrigger
        #showCoverageInformation
      ).

    "Modified: / 20-07-2011 / 14:29:15 / cg"
    "Modified: / 24-02-2014 / 10:38:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalClassCategoryList methodsFor:'aspects'!

addCategory:category
    |item path parentPath parentCategory parentItem|

    item:= categoryToItemDictionary at:category ifAbsent:nil.
    item isNil ifTrue:[
        path := category asCollectionOfSubstringsSeparatedBy:$-.

        item := ClassCategoryItem new.
        item category:category.
        item label:(path last).
        categoryToItemDictionary at:category put:item.

        category size > 0 ifTrue:[
            "/ find the parent ...
            parentPath := path copyButLast.
            parentCategory := parentPath asStringWith:$-.

            parentItem := self addCategory:parentCategory .

            parentItem add:item sortBlock:[:i1 :i2 | i1 category asLowercase < i2 category asLowercase].
        ]
    ].
    ^ item
!

generateHierarchicalCategoryTree
    |anchor|

    self categoryList value isNil ifTrue:[
	self updateList.
	self categoryList value isNil ifTrue:[
	    ^ nil.
	]
    ].

    anchor := ClassCategoryItem new.
    anchor category:nil.
    anchor label:nil.

    categoryToItemDictionary := Dictionary new.
    categoryToItemDictionary at:'' asSymbol put:anchor.

    self categoryList value do:[:eachCategory |
	(categoryToItemDictionary includesKey:eachCategory) ifFalse:[
	    self addCategory:eachCategory 
	].
    ].

    anchor recursiveSortChildren:[:i1 :i2 | i1 category asLowercase < i2 category asLowercase].
    anchor expand.

    ^ anchor
!

hierarchicalCategoryList
    |anchor |

    hierarchicalCategoryList isNil ifTrue:[
        hierarchicalCategoryList := HierarchicalList new.
        hierarchicalCategoryList showRoot:false.

        (self slaveMode value ~~ true) ifTrue:[
            anchor := self generateHierarchicalCategoryTree.
            hierarchicalCategoryList root:anchor.
            self setListValid:true.
        ] ifFalse:[
            self setListValid:false
        ]
    ].
    ^ hierarchicalCategoryList
!

hierarchicalCategorySelection
    hierarchicalCategorySelection isNil ifTrue:[
	hierarchicalCategorySelection := #() asValue.
	hierarchicalCategorySelection addDependent:self.
    ].
    ^ hierarchicalCategorySelection.
! !

!HierarchicalClassCategoryList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |cls sel oldMethod newMethod newPackage|

    self inSlaveModeOrInvisible ifTrue:[
	super delayedUpdate:something with:aParameter from:changedObject.
	^ self.
    ].

    changedObject == updateTrigger ifTrue:[
	hierarchicalCategoryTree := nil.
	self hierarchicalCategoryList.
	self updateTreeSelectionFromList.
	^ self        
    ].

    changedObject == slaveMode ifTrue:[
	listValid ~~ true ifTrue:[
	    self enqueueDelayedUpdateList
	].
	"/ self invalidateList.
	^  self
    ].

    changedObject == hierarchicalCategorySelection ifTrue:[
	self updateSelectionFromTree.
	^ self        
    ].
    changedObject == self selectedCategories ifTrue:[
	"/ update the trees selection as appropriate
"/        self updateTreeSelection.
	self updateTreeSelectionFromList.
    ].
    changedObject == categoryList ifTrue:[
	"/ update the tree
	self hierarchicalCategoryList root:(self generateHierarchicalCategoryTree).
	^ self.
    ].

    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 17.2.2000 / 23:41:02 / cg"
    "Modified: / 26.2.2000 / 01:21:49 / cg"
!

updateSelectionFromTree
    |treeSelection|

    treeSelection := hierarchicalCategorySelection value 
		    collect:[:eachIndex |  |item|
				    item := hierarchicalCategoryList at:eachIndex ifAbsent:nil.
				    item category
			    ].

    treeSelection asSet ~= (self selectedCategories value ? #()) asSet ifTrue:[
	self selectedCategories value:treeSelection.
    ]
!

updateTreeSelectionFromList
    |listSelection selectedTreeItems treeSelection|

    listSelection := self selectedCategories value.
    selectedTreeItems := listSelection collect:[:itemString | self treeItemForString:itemString string].
    treeSelection := selectedTreeItems collect:[:eachItem | hierarchicalCategoryList identityIndexOf:eachItem].
    treeSelection := treeSelection asOrderedCollection.
"/hierarchicalCategorySelection value 
"/                    collect:[:eachIndex |  |item|
"/                                    item := hierarchicalCategoryList at:eachIndex ifAbsent:nil.
"/                                    item category
"/                            ].
"/
"/    treeSelection asSet ~= (self selectedCategories value ? #()) asSet ifTrue:[
"/        self selectedCategories value:treeSelection.
"/    ]
    self hierarchicalCategorySelection value:treeSelection
! !

!HierarchicalClassCategoryList methodsFor:'private'!

makeItemVisible:itemString
    |treeItem idx listView|

    treeItem := self treeItemForString:itemString.
    idx := hierarchicalCategoryList identityIndexOf:treeItem.
    idx ~~ 0 ifTrue:[
	(listView := self listView) notNil ifTrue:[
	    listView makeLineVisible:idx.
	]
    ]
!

release
    super release.

    hierarchicalCategorySelection removeDependent:self.
!

treeItemForString:itemString
    |itemPath treeItem|

    itemPath := itemString string asCollectionOfSubstringsSeparatedBy:$-.
    treeItem := hierarchicalCategoryList root.
    [itemPath notEmpty] whileTrue:[
	treeItem expand.
	treeItem := treeItem detect:[:childItem | childItem label string = itemPath first] ifNone:nil.
	itemPath := itemPath copyFrom:2.
    ].
    ^ treeItem
! !

!HierarchicalClassCategoryList methodsFor:'user actions'!

doubleClicked:anIndex
    |item|

    item := hierarchicalCategoryList at:anIndex ifAbsent:nil.
    item isNil ifTrue:[
	^ self
    ].        

    (item canExpand not or:[item isExpanded]) ifTrue:[
	doubleClickChannel notNil ifTrue:[
	    doubleClickChannel value:anIndex.
	] ifFalse:[
	    item collapse.
	].
	^ self
    ].

    item expand.
!

indicatorPressed:anIndex
    |item sensor|

    item := hierarchicalCategoryList at:anIndex ifAbsent:nil.

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

!HierarchicalClassCategoryList::ClassCategoryItem methodsFor:'accessing'!

category
    ^ category
!

category:something
    category := something.
!

icon
    ^ nil "/ SystemBrowser packageIcon
! !

!HierarchicalClassCategoryList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalClassCategoryList.st,v 1.13 2014-11-19 21:41:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalClassCategoryList.st,v 1.13 2014-11-19 21:41:19 cg Exp $'
! !

