"{ Encoding: utf8 }"

"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#JavaCodeBundleEditor
	instanceVariableNames:'bundleHolder readonlyHolder bundleTree bundleTreeSelectionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools'
!

HierarchicalItem subclass:#BundleItem
	instanceVariableNames:'bundle'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeBundleEditor
!

HierarchicalItem subclass:#LibraryItem
	instanceVariableNames:'library warnings label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeBundleEditor
!


!JavaCodeBundleEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:JavaCodeBundleEditor andSelector:#windowSpec
     JavaCodeBundleEditor new openInterface:#windowSpec
     JavaCodeBundleEditor open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Java Code Bundle Editor'
          name: 'Java Code Bundle Editor'
          bounds: (Rectangle 0 0 580 420)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'HierarchicalListView1'
              layout: (LayoutFrame 0 0 0 0 -100 1 -30 1)
              model: bundleTreeSelectionHolder
              menu: listMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: bundleTree
              useIndex: false
              highlightMode: line
              useDefaultIcons: false
            )
           (VerticalPanelViewSpec
              name: 'Buttons1'
              layout: (LayoutFrame -100 1 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 5
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Add Library...'
                    name: 'ButtonAddLibrary'
                    activeHelpKey: addPerPackageManager
                    translateLabel: true
                    model: doAddLibrary
                    enableChannel: canAddHolder
                    extent: (Point 100 22)
                  )
                 (ActionButtonSpec
                    label: 'Add Bundle...'
                    name: 'ButtonAddBundle'
                    activeHelpKey: moveManagerDown
                    translateLabel: true
                    model: doAddBundle
                    enableChannel: canAddHolder
                    extent: (Point 100 22)
                  )
                 (ActionButtonSpec
                    label: 'Edit...'
                    name: 'ButtonEdit'
                    activeHelpKey: editPerPackageManager
                    translateLabel: true
                    model: doEdit
                    enableChannel: canEditHolder
                    extent: (Point 100 22)
                  )
                 (ActionButtonSpec
                    label: 'Remove'
                    name: 'ButtonRemove'
                    activeHelpKey: removePerPackageManager
                    translateLabel: true
                    model: doRemove
                    enableChannel: canRemoveHolder
                    extent: (Point 100 22)
                  )
                 )
               
              )
            )
           (LabelSpec
              label: 'Drag and drop .jar files above'
              name: 'Hint'
              layout: (LayoutFrame 3 0 -30 1 -100 1 0 1)
              visibilityChannel: readwriteHolder
              translateLabel: true
              adjust: left
            )
           (LinkButtonSpec
              label: 'LinkButton'
              name: 'Button1'
              layout: (LayoutFrame -100 1 -30 1 0 1 0 1)
              visibilityChannel: readwriteHolder
              translateLabel: true
              labelChannel: browseFilesLabel
            )
           )
         
        )
      )
! !

!JavaCodeBundleEditor class methodsFor:'menu specs'!

listMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:JavaCodeBundleEditor andSelector:#listMenu
     (Menu new fromLiteralArrayEncoding:(JavaCodeBundleEditor listMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canAddHolder
            label: 'Add Library...'
            itemValue: doAddLibrary
          )
         (MenuItem
            enabled: canAddHolder
            label: 'Add Bundle...'
            itemValue: doAddBundle
          )
         (MenuItem
            enabled: canEditHolder
            label: 'Edit..'
            itemValue: doEdit
          )
         (MenuItem
            enabled: canRemoveHolder
            label: 'Remove'
            itemValue: doRemove
          )
         )
        nil
        nil
      )
! !

!JavaCodeBundleEditor class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #bundleHolder
        #readonlyHolder
      ).

! !

!JavaCodeBundleEditor methodsFor:'accessing'!

bundle: aJavaCodeBundle
    self bundleHolder value: aJavaCodeBundle

    "Created: / 25-01-2013 / 21:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readonly
    ^ self readonlyHolder value

    "Created: / 15-04-2014 / 18:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readonly: aBoolean
    self readonlyHolder value: aBoolean

    "Created: / 15-04-2014 / 18:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor methodsFor:'aspects'!

browseFilesLabel

    ^'Browse...' asText
        colorizeAllWith: Color blue;
        actionForAll:[ self doBrowseFiles ];
        yourself

    "Created: / 22-02-2013 / 00:22:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bundleHolder
    "return/create the 'bundleHolder' value holder (automatically generated)"

    bundleHolder isNil ifTrue:[
        bundleHolder := JavaCodeBundle new asValue.
        bundleHolder addDependent:self.
    ].
    ^ bundleHolder

    "Modified: / 21-02-2013 / 23:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bundleHolder:something
    "set the 'bundleHolder' value holder (automatically generated)"

    |oldValue newValue|

    bundleHolder notNil ifTrue:[
        oldValue := bundleHolder value.
        bundleHolder removeDependent:self.
    ].
    bundleHolder := something.
    bundleHolder notNil ifTrue:[
        bundleHolder addDependent:self.
    ].
    newValue := bundleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:bundleHolder.
    ].
!

bundleTree
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    bundleTree isNil ifTrue:[
        bundleTree := HierarchicalList new.
        bundleTree showRoot: false.
    ].
    ^ bundleTree.

    "Modified: / 28-01-2013 / 20:35:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bundleTreeSelectionHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    bundleTreeSelectionHolder isNil ifTrue:[
        bundleTreeSelectionHolder := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       bundleTreeSelectionHolder addDependent:self.
"/       bundleTreeSelectionHolder onChangeSend:#bundleTreeSelectionHolderChanged to:self.
    ].
    ^ bundleTreeSelectionHolder.
!

readonlyHolder
    "return/create the 'readonlyHolder' value holder (automatically generated)"

    readonlyHolder isNil ifTrue:[
        readonlyHolder := ValueHolder with: false.
    ].
    ^ readonlyHolder

    "Modified: / 28-01-2013 / 19:27:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readonlyHolder:something
    "set the 'readonlyHolder' value holder (automatically generated)"

    readonlyHolder := something.
!

readwriteHolder
    ^BlockValue forLogicalNot: self readonlyHolder

    "Created: / 22-02-2013 / 00:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor methodsFor:'aspects-queries'!

canAddHolder
    ^BlockValue 
        with:[:ro :sel| ro value not" and:[sel value isNil or:[sel value libraryOrBundle isBundle]]"]
        argument: self readonlyHolder
        argument: self bundleTreeSelectionHolder

    "Created: / 30-01-2013 / 16:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2013 / 23:42:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canEditHolder
    ^BlockValue 
        with:[:ro :sel|ro value not and:[sel value notNil]]
        argument: self readonlyHolder
        argument: self bundleTreeSelectionHolder

    "Modified: / 30-01-2013 / 16:33:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canRemoveHolder
    ^BlockValue 
        with:[:ro :sel|ro value not and:[sel value notNil]]
        argument: self readonlyHolder
        argument: self bundleTreeSelectionHolder

    "Modified: / 30-01-2013 / 16:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor methodsFor:'change & update'!

update:aspect with: parameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == bundleHolder ifTrue:[
        self updateTree.
        ^ self.
    ].
    super update:aspect with:parameter from:changedObject

    "Modified: / 25-01-2013 / 21:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateModifiedChannel
    (masterApplication respondsTo: #updateModifiedChannel) ifTrue:[
        masterApplication updateModifiedChannel
    ].

    "Created: / 30-01-2013 / 17:22:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTree
    self bundleTree root notNil ifTrue:[
        (self bundleTree)
            removeAll;
            root:nil.
    ].
    self bundleTree root:(BundleItem bundle:self bundleHolder value parent:nil).
    self bundleTree root expand.

    "Created: / 25-01-2013 / 21:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-03-2015 / 13:14:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor methodsFor:'hooks'!

commonPostOpen
    self updateTree

    "Created: / 21-02-2013 / 23:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor methodsFor:'menu actions'!

doAdd: libraryOrBundle
    | parent parentItem |

    parentItem := self bundleTreeSelectionHolder value.
    parentItem isNil ifTrue:[
        parentItem := bundleTree root
    ].

    parentItem libraryOrBundle isLibrary ifTrue:[
        parentItem := parentItem parent.
    ].
    parent := parentItem libraryOrBundle.

    parent add: libraryOrBundle.

    parentItem expand.

    self doSelect: libraryOrBundle.
    self updateModifiedChannel

    "Created: / 30-01-2013 / 17:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2013 / 15:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAddBundle
    | name bundle |

    name := Dialog request: (resources string: 'Enter name of new bundle').
    name isEmptyOrNil ifTrue:[^self].
    bundle := JavaCodeBundle new.
    bundle name: name.

    self doAdd: bundle

    "Modified: / 22-02-2013 / 13:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doAddLibrary
    | dialog |

    dialog := JavaCodeLibraryEditor new.
    dialog open.
    dialog accepted ifTrue:[
        self doAdd: dialog acceptedValue.
    ]

    "Modified: / 22-02-2013 / 13:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doBrowseFiles
    UserPreferences fileBrowserClass openOnDirectory:  (Array with: ((JavaCodeLibraryEditor lastDirectory)  ? (Filename currentDirectory pathName)) asFilename)

    "Modified: / 08-12-2014 / 00:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEdit
    | bundleOrLibraryItem bundleOrLibrary dialog name |

    bundleOrLibraryItem := self bundleTreeSelectionHolder value.
    bundleOrLibraryItem isNil ifTrue:[ ^ self ].
    bundleOrLibrary := bundleOrLibraryItem libraryOrBundle.
    bundleOrLibrary isLibrary ifTrue:[
        dialog := JavaCodeLibraryEditor new.
        dialog library: bundleOrLibrary.
        dialog open.
        bundleOrLibrary isLibrary ifTrue:[ 
            "/ To get rid ow warnings if fixed or revalidate
            bundleOrLibraryItem updateWarnings.
        ].   
    ] ifFalse:[
        name := Dialog request: (resources string: 'Enter new name') initialAnswer:bundleOrLibrary name.
        name isNil ifTrue:[^self].
        bundleOrLibrary name: name.

    ]

    "Modified: / 19-03-2015 / 16:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemove
    | selItem sel parentItem parent |

    selItem := self bundleTreeSelectionHolder value.
    selItem isNil ifTrue:[ ^ self ].

    sel := selItem libraryOrBundle.
    parentItem := selItem parent.
    parent := parentItem libraryOrBundle.

    parent remove: sel.
    parent libraries size > 0 ifTrue:[
        parentItem expand.
    ].

    self doSelect: parent.
    self updateModifiedChannel

    "Modified: / 22-02-2013 / 15:53:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelect: libraryOrBundle
    self bundleTree root recursiveDo:[:e|
        e libraryOrBundle == libraryOrBundle ifTrue:[
            self bundleTreeSelectionHolder value: e.
            ^self
        ]
    ]

    "Created: / 22-02-2013 / 15:36:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::BundleItem class methodsFor:'instance creation'!

bundle: bundle parent: parent
    ^self new setBundle: bundle parent: parent

    "Created: / 19-03-2015 / 13:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::BundleItem methodsFor:'accessing'!

icon
    ^nil

    "Created: / 25-01-2013 / 21:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^bundle displayString

    "Created: / 25-01-2013 / 21:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2014 / 18:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraryOrBundle
    ^ bundle

    "Created: / 19-03-2015 / 13:15:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::BundleItem methodsFor:'change & update'!

update:aspect with: parameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == bundle ifTrue:[
        self updateChildren.
        ^ self.
    ].
    super update:aspect with:parameter from:changedObject

    "Modified: / 22-02-2013 / 15:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateChildren
    | oldChildren newChildren |

    children isNil ifTrue:[
        self children: self fetchChildren.
        ^self.
    ].
    bundle isLibrary ifTrue:[ ^ self ].


    oldChildren := children copy.
    newChildren := OrderedCollection new.
    bundle libraries do:[:each|
        | item |

        item := oldChildren 
                detect:[:item|item libraryOrBundle == each] 
                ifNone:[each isLibrary 
                            ifTrue:[ JavaCodeBundleEditor::LibraryItem library:each parent: self] 
                            ifFalse: [ JavaCodeBundleEditor::BundleItem bundle:each parent: self] ].
        newChildren add: item.
    ].
    self children: newChildren

    "Created: / 22-02-2013 / 15:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 16:26:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::BundleItem methodsFor:'initialization'!

setBundle: aJavaCodeBundle parent: aBundleItem
    bundle := aJavaCodeBundle.
    bundle addDependent: self.
    parent := aBundleItem.

    "Created: / 19-03-2015 / 13:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::BundleItem methodsFor:'protocol-accessing'!

fetchChildren
    ^ bundle libraries collect:[:each| 
        each isLibrary 
            ifTrue:[ JavaCodeBundleEditor::LibraryItem library:each parent: self] 
            ifFalse: [ JavaCodeBundleEditor::BundleItem bundle:each parent: self] 
    ]

    "Created: / 25-01-2013 / 21:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 16:26:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::LibraryItem class methodsFor:'instance creation'!

library: model parent: parent
    ^self new setLibrary: model parent: parent

    "Created: / 19-03-2015 / 13:06:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::LibraryItem methodsFor:'accessing'!

icon
    ^nil

    "Created: / 25-01-2013 / 21:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    | resources |

    label isNil ifTrue:[
        resources := self class classResources.
        warnings isNil ifTrue:[ self updateWarnings ].

        label := library name.          
        warnings isEmpty ifTrue:[ 
            library sources isNil ifTrue:[ 
                label := label , ((' (', (resources string: 'no sources') , ')') asText colorizeAllWith: Color gray)
            ].
        ] ifFalse:[ 
            label := label , (' (', (warnings size == 1 ifTrue:[resources string: '1 warning'] ifFalse:[resources string: '%1 warnings' with: warnings size]) , ')').
            label := label colorizeAllWith: Color red.
        ].
    ].
    ^ label

    "Created: / 25-01-2013 / 21:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 16:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraryOrBundle
    ^ library

    "Created: / 19-03-2015 / 13:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::LibraryItem methodsFor:'initialization'!

setLibrary: aJavaCodeLibrary parent: aBundleItem
    library := aJavaCodeLibrary.
    parent := aBundleItem.

    "Created: / 19-03-2015 / 13:06:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 16:20:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::LibraryItem methodsFor:'private'!

updateWarnings

    warnings := OrderedCollection new.
    [ 
        library validate
    ] on: JavaCodeLibraryValidationWarning do:[:warning | 
        warnings add: warning.
        warning proceed.
    ].
    label := nil.

    "Created: / 19-03-2015 / 16:20:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor::LibraryItem methodsFor:'protocol-accessing'!

fetchChildren
    ^ #()

    "Created: / 25-01-2013 / 21:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 13:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundleEditor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaCodeBundleEditor.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

