"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

SelectionBrowser subclass:#ResourceSelectionBrowser
	instanceVariableNames:'resourceMethod resourceClass resourceSuperclass resourceTypes
		allClasses classSelectionBlock'
	classVariableNames:'ClassPresentation'
	poolDictionaries:''
	category:'Interface-Dialogs'
!

Object subclass:#ResourceMethod
	instanceVariableNames:'method icon resourceType selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ResourceSelectionBrowser
!

!ResourceSelectionBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    The ResourceSelectionBrowser allows you to browse in class hierarchies
    and to select resource methods for loading or to saving resource 
    specifications (#canvas, #menu, etc.).

    [instance variables:]
        resourceMethod          <Symbol>        selector of the resource spec
        resourceClass           <Symbol>        class of the resource spec
        resourceSuperclass      <Symbol>        root class of the tree list
        resourceTypes           <Array>         allowed resource types
        allClasses              <Array>         list of the subclasses of resourceSuperclass
        classSelectionBlock     <Block>         by evaluating this block the class selection is done

    [start with:]
        ResourceSelectionBrowser open

    [author:]
        Thomas Zwick, eXept Software AG
"
! !

!ResourceSelectionBrowser class methodsFor:'instance creation'!

request:aTitle onSuperclass:aSuperclass andClass:aClassOrClassName andSelector:aSelector withResourceTypes:resourceTypes
    "opens a ResourceSelectionBrowser; return a Message-object or nil."

    ^ (self new
        title: aTitle)
            openOnSuperclass:aSuperclass
            andClass:aClassOrClassName
            andSelector:aSelector
            withResourceTypes:resourceTypes

    "
     ResourceSelectionBrowser
        request: 'Select a Resource Selector'
        onSuperclass: #ApplicationModel 
        andClassNamed: #MenuEditor 
        andSelector: #menuItemImage 
        withResourceTypes: #(image) 
    "
! !

!ResourceSelectionBrowser class methodsFor:'callbacks-default'!

treeViewClassHierarchyChildren
    "returns the children for the contents (class) of aTreeItem as a block"

    "/ cg: tz's algorithm was very-very slow, 
    "/ (it enumerated classes hundreds of times,
    "/  leading to a square runtime behavior
    "/  - i.e. very slow scrolling )
    "/ Speed up things by caching facts while enumerating
    "/ classes once only.

    |subclassesAndPrivateClassesPerClass|

    subclassesAndPrivateClassesPerClass := IdentityDictionary new.

    Smalltalk allClassesDo:[:cls |
        |owner superclass info|

"/        (owner := cls owningClass) notNil ifTrue:[
"/            info := subclassesAndPrivateClassesPerClass at:owner ifAbsent:nil.
"/            info isNil ifTrue:[
"/                subclassesAndPrivateClassesPerClass at:owner put:(info := Array with:IdentitySet new 
"/                                                                                with:IdentitySet new).
"/            ].
"/            (info at:2) add:cls
"/        ] ifFalse:[
            superclass := cls superclass.
            superclass notNil ifTrue:[
                info := subclassesAndPrivateClassesPerClass at:superclass ifAbsent:nil.
                info isNil ifTrue:[
                    subclassesAndPrivateClassesPerClass at:superclass put:(info := Array with:IdentitySet new 
                                                                                         with:IdentitySet new).
                ].
                (info at:1) add:cls
            ]
"/        ]
    ].

    ^ [:aTreeItem|
        |classes itemClass info|

        classes := OrderedCollection new. 
        itemClass := aTreeItem contents.
        info := subclassesAndPrivateClassesPerClass at:itemClass ifAbsent:nil.
        info notNil ifTrue:[
            classes addAll:((info at:1) asSortedCollection: [:cls1 :cls2| cls1 name < cls2 name]).
            classes addAll:((info at:2) asSortedCollection: [:cls1 :cls2| cls1 name < cls2 name]).
        ].
        classes
     ]
!

treeViewClassHierarchyContents
    "returns the default contents of the root of the class tree list"

    ^ Object

!

treeViewClassHierarchyIcon
    "returns the icon for aTreeItem as a block"

    ^[:aTreeItem|
        |icon|

        aTreeItem contents isClass ifTrue:[
            icon := self iconClass.
            aTreeItem contents isPrivate ifTrue:[
               icon := self iconPrivateClass
            ].
            icon
        ] ifFalse:[
            self iconCategory
        ]
    ]

!

treeViewClassHierarchyLabel
    "returns the label for aTreeItem as a block"

    ^[:aTreeItem|
        |label superCls itemContents|

        itemContents := aTreeItem contents.
        label := itemContents name.
"/        (itemContents isPrivate 
"/        and:[aTreeItem parent contents ~~ (superCls := itemContents superclass)])
"/            ifTrue: [label := label, ' (', superCls name, ')'].
        label
     ]
! !

!ResourceSelectionBrowser class methodsFor:'image specs'!

iconCategory
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconCategory inspect
     ImageEditor openOnClass:self andSelector:#iconCategory"
    
    ^ Icon constantNamed:#'ResourceSelectionBrowser class iconCategory'
        ifAbsentPut:[
            (Depth4Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'3L0@@@@@@L3L3L@@@@@@@@3L3@@3L3L3L0CL3@LQDQDQD#CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@LRH"H"H3CL3@L#L3L3L3CL3@@3L3L3L0CL3L@@@@@@@@3L3L0@@@@@@L3L');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 127 127 127 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'<@O@8@G@3?3@7?;@7?;@7?;@7?;@7?;@7?;@7?;@7?;@7?;@7?;@3?3@8@G@<@O@');
                            yourself);
                yourself
        ]
!

iconClass
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self iconClass inspect
     ImageEditor openOnClass:self andSelector:#iconClass"
    
    ^ Icon constantNamed:#'ResourceSelectionBrowser class iconClass'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@*****ABUUUUT@IUUUUP@%UUUU@BUUUUT@IUUUUP@%UUUU@BUUUUT@IUUUUP@%UUUU@BUUUUT@IUUUUP@%UUUU@A@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
!

iconPrivateClass
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#iconPrivateClass"
    
    ^ Icon constantNamed:#'ResourceSelectionBrowser class iconPrivateClass'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU A****(@F*??* @Z+??*@A*/*>(OF*>+: @Z+??*@A*/?:(DF*>** @Z+:**@A*/**(@F*>** @Z****C2@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 0 0 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!ResourceSelectionBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ResourceSelectionBrowser andSelector:#windowSpec
     ResourceSelectionBrowser new openInterface:#windowSpec
     ResourceSelectionBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Resource Selection Browser'
          name: 'Resource Selection Browser'
          min: (Point 400 300)
          bounds: (Rectangle 12 22 612 372)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'VariableHorizontalPanel'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -36 1.0)
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'Box1'
                    component: 
                   (SpecCollection
                      collection: (
                       (HorizontalPanelViewSpec
                          name: 'HorizontalPanel2'
                          layout: (LayoutFrame 0 0 2 0 297 0 23 0)
                          horizontalLayout: leftSpace
                          verticalLayout: fit
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (RadioButtonSpec
                                label: 'Categories'
                                name: 'ClassCategoriesRadioButton'
                                translateLabel: true
                                model: selectionOfClassPresentation
                                isTriggerOnDown: true
                                lampColor: (Color 0.0 0.0 0.0)
                                select: #'Class Categories'
                                extent: (Point 124 21)
                              )
                             (RadioButtonSpec
                                label: 'Hierarchy'
                                name: 'ClassHierarchyRadioButton'
                                translateLabel: true
                                model: selectionOfClassPresentation
                                isTriggerOnDown: true
                                lampColor: (Color 0.0 0.0 0.0)
                                select: #'Class Hierarchy'
                                extent: (Point 145 21)
                              )
                             )
                           
                          )
                        )
                       (SelectionInTreeViewSpec
                          name: 'listOfClassHierarchyView'
                          layout: (LayoutFrame 0 0.0 23 0.0 0 1.0 -24 1.0)
                          tabable: true
                          model: selectionOfClassHierarchy
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          showDirectoryIndicatorForRoot: false
                          showDirectoryIndicator: true
                          valueChangeSelector: classSelected
                          hierarchicalList: rootOfClassHierarchy
                          validateDoubleClickSelector: validateDoubleClick:
                          contentsSelector: treeViewClassHierarchyContents
                          labelSelector: treeViewClassHierarchyLabel
                          childrenSelector: treeViewClassHierarchyChildren
                          iconSelector: treeViewClassHierarchyIcon
                          highlightMode: line
                        )
                       (SelectionInTreeViewSpec
                          name: 'listOfClassCategoriesView'
                          layout: (LayoutFrame 0 0.0 23 0.0 0 1.0 -24 1.0)
                          tabable: true
                          model: selectionOfClassCategories
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          showRoot: false
                          showDirectoryIndicator: true
                          valueChangeSelector: classSelected
                          hierarchicalList: rootOfClassCategories
                          validateDoubleClickSelector: validateDoubleClick:
                          childrenSelector: treeViewClassCategoryChildren
                          iconSelector: treeViewClassCategoryIcon
                          highlightMode: line
                        )
                       (InputFieldSpec
                          name: 'classNameInputField'
                          layout: (LayoutFrame 2 0.0 -22 1 -1 1.0 0 1)
                          tabable: true
                          model: classNameHolder
                          acceptOnLeave: true
                          acceptOnLostFocus: true
                          acceptOnPointerLeave: true
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'Box2'
                    component: 
                   (SpecCollection
                      collection: (
                       (DataSetSpec
                          name: 'resourcesDataSetView'
                          layout: (LayoutFrame 2 0.0 2 0.0 -2 1.0 -24 1.0)
                          model: selectionOfResourceMethod
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          rowClassName: 'ResourceSelectionBrowser::Row'
                          dataList: listOfResourceMethods
                          useIndex: false
                          has3Dsepartors: true
                          has3Dseparators: true
                          doubleClickSelector: resourceDoubleClicked
                          columnHolder: resourceMethodColumns
                          valueChangeSelector: resourceSelected
                          verticalSpacing: 1
                        )
                       (InputFieldSpec
                          name: 'selectorInputField'
                          layout: (LayoutFrame 2 0.0 -22 1 -2 1.0 0 1)
                          tabable: true
                          model: resourceSelectorHolder
                          acceptOnLeave: true
                          acceptOnLostFocus: true
                          acceptOnPointerLeave: true
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
              layout: (LayoutFrame 2 0.0 -30 1 -2 1.0 -4 1.0)
              horizontalLayout: fit
              verticalLayout: fit
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Help'
                    name: 'HelpButton'
                    activeHelpKey: dss
                    model: openHTMLDocument:
                    initiallyDisabled: true
                    enableChannel: helpEnabled
                    actionValue: 'tools/uipainter/ResourceSelectionBrowser.html'
                    extent: (Point 196 26)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    activeHelpKey: commitCancel
                    tabable: true
                    model: cancel
                    extent: (Point 197 26)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    activeHelpKey: commitOK
                    tabable: true
                    model: accept
                    isDefault: true
                    extent: (Point 197 26)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!ResourceSelectionBrowser class methodsFor:'list specs'!

tableColumnsForResourceMethodAttributes
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ResourceSelectionBrowser andSelector:#tableColumnsForResourceMethodAttributes
    "

    <resource: #tableColumns>


    ^ #(
        #(#DataSetColumnSpec
           #width: 20
           #height: 20
           #printSelector: #iconOn:
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: ' Selector'
           #labelAlignment: #left
           #model: #selector
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: ' Resource Type'
           #labelAlignment: #left
           #model: #resourceType
           #canSelect: false
       )
     )
! !

!ResourceSelectionBrowser methodsFor:'aspects'!

classNameHolder
    "returns the value holder for the name of the class"

    |holder|

    (holder := builder bindingAt:#valueOfClassName) isNil ifTrue:[
        builder aspectAt:#valueOfClassName put:(holder :=  '' asValue).
        holder onChangeEvaluate:[self classSelectionUpdate:holder value].
    ].
    ^ holder
!

helpEnabled
    "returns whether there is a documentation file"

    ^true
!

listOfResourceMethods
    "returns the value holder for the list of the resource methods"

    ^ builder listAspectFor:#listOfResourceMethods
!

resourceMethodColumns
    "returns the columns for the table of the resource methods as value holder"

    |holder|
    (holder := builder bindingAt:#resourceMethodColumns) isNil ifTrue:[
        builder aspectAt:#resourceMethodColumns put:(holder := List new).
        holder addAll: (self class tableColumnsForResourceMethodAttributes collect: [:i| i decodeAsLiteralArray]).
    ].
    ^ holder
!

resourceSelectorHolder
    "returns the value holder for the name of the selector"

    |holder|
    (holder := builder bindingAt:#valueOfResourceSelector) isNil ifTrue:[
        builder aspectAt:#valueOfResourceSelector put:(holder :=  '' asValue).
    ].
    ^ holder
!

rootOfClassCategories
    "returns the value holder for the root of the class tree list"

    |holder|                                

    (holder := builder bindingAt:#rootOfClassCategories) isNil ifTrue:[
        ClassPresentation = #'Class Categories' ifTrue: [
        builder aspectAt:#rootOfClassCategories put: (holder := TreeItem name: 'Categories')].
    ].
    ^ holder


!

rootOfClassHierarchy
    "returns the value holder for the root of the class tree list"

    |holder|


    (holder := builder bindingAt:#rootOfClassHierarchy) isNil ifTrue:[
        ClassPresentation = #'Class Hierarchy' ifTrue: [
        builder aspectAt:#rootOfClassHierarchy put: (holder := TreeItem new)]
    ].
    ^ holder


!

selectionOfClassCategories
    "returns the value holder for the selected class of the class tree list"

    |holder|           
    (holder := builder bindingAt:#selectionOfClassCategories) isNil ifTrue:[
        builder aspectAt:#selectionOfClassCategories put:(holder :=  ValueHolder new). 
    ].
    ^ holder
!

selectionOfClassHierarchy
    "returns the value holder for the selected class of the class tree list"

    |holder|           
    (holder := builder bindingAt:#selectionOfClassHierarchy) isNil ifTrue:[
        builder aspectAt:#selectionOfClassHierarchy put:(holder :=  ValueHolder new). 
    ].
    ^ holder
!

selectionOfClassPresentation
    "returns the value holder for the selected class presentation"

    |holder|

    (holder := builder bindingAt:#selectionOfClassPresentation) isNil ifTrue:[
        builder aspectAt:#selectionOfClassPresentation put:(holder :=  RadioButtonGroup with: (ClassPresentation := ClassPresentation ? #'Class Categories')).
        holder onChangeEvaluate: 
            [
                 |hv comp newRoot|

                 hv := holder value.
                 ClassPresentation := hv.
                 hv = #'Class Hierarchy' ifTrue:[
                      comp := builder componentAt: #listOfClassHierarchyView.
                      newRoot := self rootOfClassHierarchy.  
                 ] ifFalse: [
                      comp := builder componentAt: #listOfClassCategoriesView.
                      newRoot := self rootOfClassCategories. 
                 ].
                 comp root:newRoot.
                 comp raise. 
                 classSelectionBlock value: self classNameHolder value
            ]
    ].
    ^ holder
!

selectionOfResourceMethod
    "returns the value holder for the selected resource method of the resource method list"

    |holder|
    (holder := builder bindingAt:#selectionOfResourceMethod) isNil ifTrue:[
	builder aspectAt:#selectionOfResourceMethod put:(holder :=  '' asValue).
    ].
    ^ holder
!

valueOfClassName
    <resource: #obsolete>
    "returns the value holder for the name of the class"

    self obsoleteMethodWarning:'stupid name - use #classNameHolder'.
    ^ self classNameHolder
!

valueOfResourceSelector
    <resource: #obsolete>
    "returns the value holder for the name of the selector"

    self obsoleteMethodWarning:'stupid name - use #resourceSelectorHolder'.
    ^ self resourceSelectorHolder
! !

!ResourceSelectionBrowser methodsFor:'callbacks-class list'!

treeViewClassCategoryChildren
    "returns the children for the contents (class) of aTreeItem as a block"

    "/ cg: tz's algorithm was very-very slow, 
    "/ (it enumerated classes hundreds of times,
    "/  leading to a square runtime behavior
    "/  - i.e. very slow scrolling )
    "/ Speed up things by caching facts while enumerating
    "/ classes once only.

    |topClass childrenPerCategory privateClasses|

    topClass := self treeViewClassHierarchyContents.
    privateClasses := IdentitySet new.

    childrenPerCategory := Dictionary new.

    topClass withAllSubclassesDo:[:cls |
        |cat set|

        cls isPrivate ifFalse:[
            cat := cls category.
            cat notNil ifTrue:[
                set := childrenPerCategory at:cat ifAbsent:nil.
                set isNil ifTrue:[
                    childrenPerCategory at:cat put:(set := IdentitySet new).
                ].
                set add:cls
            ].
        ] ifTrue:[
            privateClasses add:cls
        ]
    ].

    ^ [:aTreeItem|
        |cont children initialContents setOfCategories itemCategory setOfClasses|

        (cont := aTreeItem contents) isBehavior ifTrue:[
           children := privateClasses select:[:cls | cls owningClass == aTreeItem contents].
           children := children asSortedCollection: [:c1 :c2| c1 name <= c2 name].
           "/ children := children collect: [:child| TreeItem name: child name , ' (', child superclass name, ')' contents: child]
           children := children collect: [:child| TreeItem name:(child name) contents: child]
        ] ifFalse:[
            cont size == 0 ifTrue:[
                setOfCategories := childrenPerCategory keys.
                children := setOfCategories asSortedCollection.
                children := children collect: [:nm | TreeItem name:nm contents:#Category]
            ] ifFalse:[
                cont == #Category ifTrue:[
                    itemCategory := aTreeItem name.
                    setOfClasses := childrenPerCategory at:itemCategory ifAbsent:[Set new].
                    children := setOfClasses asOrderedCollection sort:[:c1 :c2 | c1 name <= c2 name].
                    children := children collect:[:child | TreeItem name:child name contents:child].
                ] ifFalse:[
                    "/ huh ?
                    children := OrderedCollection new.
                ]
            ].
        ].
        children
    ]

    "Modified: / 22-08-2012 / 19:44:59 / cg"
!

treeViewClassCategoryIcon
    "returns the icon for aTreeItem as a block"

    ^self class treeViewClassHierarchyIcon


!

treeViewClassHierarchyContents
    "returns the contents of the root of the class tree list"

    |cls|

    resourceSuperclass notNil ifTrue:[
        cls := Smalltalk classNamed: resourceSuperclass.
    ].
    cls notNil ifTrue:[^ cls].
    ^ self class treeViewClassHierarchyContents
!

validateDoubleClick: aTreeItem
    "returns whether a class may be selected"

    |cont|

    ^ (cont := aTreeItem contents) ~= '' 
      and: [cont ~~ self treeViewClassHierarchyContents]       



! !

!ResourceSelectionBrowser methodsFor:'callbacks-user'!

classSelected
    "after a class selection, read the allowed resource methods of the selected class"

    |sel|

    ClassPresentation = #'Class Hierarchy'
"/        ifTrue:  [sel := self selectionOfClassHierarchy value]
        ifFalse: [sel := self selectionOfClassCategories value].

    sel notNil ifTrue:[
        resourceClass := sel.
    ].
    self updateResourceMethodList.
!

classSelectionUpdate:clsPattern
    |foundClass classes|  

    clsPattern notNil ifTrue:[
        foundClass := Smalltalk at:(clsPattern printString asSymbol).
    ].
    (foundClass isClass not or:[foundClass name ~= clsPattern])
    ifTrue: [
        classes := allClasses select: [:cls| cls name size >= clsPattern size].
        1 to: clsPattern size do: [:i|    
             classes := classes select: [:cls| (cls name at: i) == (clsPattern at: i)].
        ].    
        foundClass := classes at: 1 ifAbsent:[]. 
    ].          

    foundClass notNil ifTrue: [           
        foundClass := foundClass autoload.
        resourceClass := foundClass.

        ClassPresentation = #'Class Hierarchy' ifTrue: [
            |searchArgs nonSuperclasses hierItem|

            false "foundClass isPrivate"
                ifFalse: [searchArgs := foundClass withAllSuperclasses reversed]
                ifTrue:  [searchArgs := foundClass owningClass withAllSuperclasses reversed. 
                          searchArgs add: foundClass].                                  
            (nonSuperclasses := self treeViewClassHierarchyContents allSuperclasses) notNil 
                ifTrue: [searchArgs := searchArgs reject: [:cls| nonSuperclasses includes: cls]].

            hierItem := self rootOfClassHierarchy detectChild:[:child :arg| child contents == arg] arguments:searchArgs.
            hierItem notNil ifTrue:[
                self selectionOfClassHierarchy value:hierItem.
            ].
        ] ifFalse: [
            |searchArgs hierItem|

            false "foundClass isPrivate"
                ifTrue:  [searchArgs := Array with: 'Categories' with: foundClass category with: foundClass owningClass name with: foundClass name]
                ifFalse: [searchArgs := Array with: 'Categories' with: foundClass category with: foundClass name].

            hierItem := self rootOfClassCategories detectChild:[:child :arg| (child name upTo: $ ) = arg] arguments:searchArgs.
            hierItem notNil ifTrue:[
                self selectionOfClassCategories value: hierItem.
            ].
        ].
    ].
    self classNameHolder value: clsPattern.
    self updateResourceMethodList.
!

resourceDoubleClicked
    "after a double click on resource method, accept it and close"

    accept value: true.
    self closeRequest
!

resourceSelected
    "after a click on a resource method, set its selector into the field"

    self selectionOfResourceMethod value notNil
        ifTrue: [self resourceSelectorHolder value: self selectionOfResourceMethod value selector]
!

updateResourceMethodList
    "read the allowed resource methods of the selected class"

    |class className item|

    (class := resourceClass) isNil ifTrue:[
        ClassPresentation = #'Class Hierarchy'
            ifTrue:  [item := self selectionOfClassHierarchy value ]
            ifFalse: [item := self selectionOfClassCategories value ].

        item notNil ifTrue:[
            className := item name.
            class := Smalltalk at:className asSymbol
        ].
    ].

    class isNil ifTrue: [^self].

    className := class name."/class theNonMetaclass name

    self withWaitCursorDo:[
        |newContents|           

        resourceTypes isNil ifTrue: [resourceTypes := Method resourceTypes].

        self classNameHolder value: className.
        self class lastSelection: className.

        newContents := class class methodDictionary asOrderedCollection 
                       select: [:m | m resources notNil 
                                     and: [resourceTypes includes: m resourceType]
                               ].
        newContents := newContents sort:[:m1 :m2 | m1 selector < m2 selector].
        newContents := newContents collect:[:m| (ResourceMethod new method:m)].

        self listOfResourceMethods contents:newContents
                .
    ]
! !

!ResourceSelectionBrowser methodsFor:'instance creation'!

openOnSuperclass: aSuperclassOrSymbol andClass:aClassOrClassName andSelector: aSelector withResourceTypes: aResourceTypes
    "opens a ResourceSelectionBrowser; return a Message-object or nil"

    |selectedClass enteredClassName className cls|

    resourceMethod := aSelector.
    resourceTypes := aResourceTypes.
    resourceSuperclass := aSuperclassOrSymbol isClass ifTrue: [aSuperclassOrSymbol name] ifFalse: [aSuperclassOrSymbol].
    resourceClass := nil.

    aClassOrClassName notNil ifTrue:[
        aClassOrClassName isClass ifTrue: [
            cls := aClassOrClassName. 
            resourceClass := aClassOrClassName
        ] ifFalse: [
            cls := Smalltalk classNamed: aClassOrClassName.
            cls notNil ifTrue:[
                resourceClass := cls
            ]
        ]
    ].            
    self resourceSelectorHolder value:(aSelector ? '').
    self open.

    (selectedClass := self selectionOfClassHierarchy value) isNil ifTrue:[
        (selectedClass := self selectionOfClassCategories value) isNil ifTrue:[
            (enteredClassName := self classNameHolder value) isNil ifTrue:[
                accept value ifTrue:[
                    self warn:'No valid class selected/entered'.
                ].
                ^ nil
            ]
        ]
    ].

    className := enteredClassName.    
    className isNil ifTrue:[
        className := selectedClass name
    ].
    cls := Smalltalk classNamed:className.
    (cls isClass and:[accept value]) ifTrue:[            
        ^ Method::MethodWhoInfo class:cls selector:(self resourceSelectorHolder value)
    ].

    accept value ifTrue:[
        self warn:'No valid class selected/entered'.
    ].
    ^ nil

    "Modified: / 22.4.1998 / 14:51:03 / cg"
! !

!ResourceSelectionBrowser methodsFor:'startup & release'!

postBuildWith:aBuilder
    "after building and before opening,  
     create a class selection block, an entry completion block for the class name field"

    |classSelection classNameInputField|
     
    allClasses := self treeViewClassHierarchyContents withAllSubclasses reject: [:cls| cls isPrivate].
    classSelection := resourceClass isNil ifTrue:[nil] ifFalse:[resourceClass name]. 

    (classSelection isNil or:[ (Smalltalk classNamed: classSelection) isNil]) 
        ifTrue: [classSelection :=  self class lastSelection].
"/    (classSelection isNil or:[Smalltalk at: classSelection]) isNil 
"/        ifTrue: [classSelection :=  self treeViewContents].

    classSelectionBlock := [:clsPattern | self classSelectionUpdate:clsPattern].
    self classNameHolder value:classSelection.  

    (classNameInputField := builder componentAt: #classNameInputField) 
        entryCompletionBlock:
            [:value|
                |s what m|

                s := classNameInputField contents withoutSpaces.
                what := Smalltalk classnameCompletion:s inEnvironment:Smalltalk.
                classNameInputField contents:what first.
                (what at:2) size ~~ 1 ifTrue:[
                    classNameInputField device beep
                ]
"/                |what oldClassName|
"/                oldClassName := classNameInputField contents.
"/                what := Smalltalk classnameCompletion: value withoutSpaces.
"/                classNameInputField contents:what first.
"/                oldClassName = classNameInputField contents ifTrue:[classNameInputField flash].
"/                classSelectionBlock value: classNameInputField contents
            ].

    classSelectionBlock value: self classNameHolder value.
    self updateResourceMethodList.
    self selectionOfResourceMethod value: (self listOfResourceMethods detect: [:m| m selector == resourceMethod] ifNone: nil).

    ^super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    "after opening and if turned on make hierarchy view visible"

    ClassPresentation = #'Class Hierarchy'
        ifTrue: [(builder componentAt: #listOfClassHierarchyView) raise].

    super postOpenWith:aBuilder
! !

!ResourceSelectionBrowser::ResourceMethod methodsFor:'accessing'!

iconOn:aGC
    "registers and returns an icon indicating the resource type"

    |cls sel image imageKey|

    self resourceType isNil ifTrue: [^nil].

    icon isNil ifTrue:[
        ((self resourceType = #image) or: [resourceType = #fileImage])
        ifTrue:[  
            cls := method mclass theNonMetaclass.
            sel := method selector.
        ] ifFalse: [
            cls := SystemBrowser.
            sel := (resourceType, 'Icon') asSymbol.
        ].
        imageKey := (cls name, sel) asSymbol.
        (icon := aGC registeredImageAt: imageKey) isNil
        ifTrue: [       
            image := cls perform: sel.
            (image extent y > 18) ifTrue: [         
                image := image magnifiedBy: 18/image extent y
            ].
            aGC registerImage: image key: imageKey.
            icon := aGC registeredImageAt: imageKey.
        ].
    ].
    ^icon

    "Modified: / 5.11.2001 / 16:48:35 / cg"
!

method: aMethod
    "sets aMethod"

    method := aMethod
!

resourceType
    "returns resourceType"

    resourceType isNil ifTrue: [resourceType := method resourceType].
    ^resourceType
!

selector
    "returns selector"

    selector isNil ifTrue: [selector := method who methodSelector].
    ^selector
! !

!ResourceSelectionBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

