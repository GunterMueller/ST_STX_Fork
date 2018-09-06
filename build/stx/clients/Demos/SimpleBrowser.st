"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#SimpleBrowser
	instanceVariableNames:'classListModel methodListModel currentClass currentMethod
		codeView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tutorial'
!

!SimpleBrowser class methodsFor:'documentation'!

documentation
"
    this is a simple browser example

    It can show the list of classes in the system,
    and show a selected classes methods. If a method is
    selected, the code is shown in the lower codeView.
    Changed methods can be accepted and are recompiled.

    The methodList provides a popupMenu for senders and
    implementors.

    [author:]
	Claus Gittinger

    [start with:]
	SimpleBrowser open
"
! !

!SimpleBrowser methodsFor:'change notifications'!

classListChange
    "the class selection has changed"

    |selection|

    selection := classListModel selection.
    selection notNil ifTrue:[
	currentClass := Smalltalk classNamed:selection.
	self updateMethodList
    ]
!

methodListChange
    "the method selection has changed"

    |selection|

    selection := methodListModel selection.
    selection notNil ifTrue:[
	currentMethod := currentClass compiledMethodAt:selection asSymbol.
	self updateCodeView
    ]
! !

!SimpleBrowser methodsFor:'method menu'!

browseImplementors
    "ask for a selector and open a browser on its implementors"

    |selector classes implementors|

    selector := Dialog request:(resources string:'selector:').
    self withCursor:(Cursor wait) do:[
	selector isNil ifTrue:[^ self]. "/ cancel pressed
	selector := selector asSymbol.  "/ got a string - need a symbol

	classes := Smalltalk allClasses
			select:[:aClass | aClass implements:selector].
	implementors := classes 
			collect:[:aClass | aClass compiledMethodAt:selector].

	implementors isEmpty ifTrue:[        
	    self information:(resources string:'no implementors')
	] ifFalse:[
	    SystemBrowser 
		browseMethods:implementors 
		title:((resources string:'implementors of %1' with:selector))
	]
    ]
!

browseSenders
    "ask for a selector and open a browser on its senders"

    |selector senders|

    selector := Dialog request:(resources string:'selector:').
    self withCursor:(Cursor wait) do:[
	selector isNil ifTrue:[^ self]. "/ cancel pressed
	selector := selector asSymbol.  "/ got a string - need a symbol

	senders := OrderedCollection new.
	Smalltalk allClasses do:[:aClass |
	    aClass methodDictionary do:[:aMethod |
		(aMethod sends:selector) ifTrue:[
		    senders add:aMethod
		]
	    ]
	].

	senders isEmpty ifTrue:[        
	    self information:(resources string:'no senders')
	] ifFalse:[
	    SystemBrowser 
		browseMethods:senders 
		title:((resources string:'senders of %1' with:selector))
	]
    ]
!

methodMenu
    "return a menu for the methodListView"

    ^ PopUpMenu
	    labels:(resources array:#('senders' 'implementors'))
	    selectors:#(#browseSenders #browseImplementors)
! !

!SimpleBrowser methodsFor:'setup - models'!

setupModels 
    "create the models"


    "
     create the selectionInList models and stuff them into the listViews
    "
    classListModel := SelectionInList new.
    methodListModel := SelectionInList new.

    "
     let me know if something changes
    "
    classListModel selectionHolder onChangeSend:#classListChange to:self.
    methodListModel selectionHolder onChangeSend:#methodListChange to:self.


    "
     let me know if classes are added or removed
    "
    Smalltalk onChangeSend:#updateClassList to:self.

    "
     update the classList now and here
    "
    self updateClassList.

! !

!SimpleBrowser methodsFor:'setup - subviews'!

setupSubviewsIn:topView 
    "create the panels with the selectionInListViews and the codeView"

    |outerPanel upperPanel 
     classListView methodListView scrollHelper|

    "
     create the panels ...
    "
    outerPanel := VariableVerticalPanel 
			origin:0.0 @ 0.0 corner:1.0 @ 1.0 
			in:topView.

    upperPanel := VariableHorizontalPanel 
			origin:0.0 @ 0.0 corner:1.0 @ 0.3 
			in:outerPanel.

    "
     the classListView is a scrollable SelectionInListView ...
    "
    scrollHelper := HVScrollableView 
			for:SelectionInListView 
			miniScrollerH:true 
			origin:0.0 @0.0 corner:0.5 @ 1.0 
			in:upperPanel.
    classListView := scrollHelper scrolledView.
    classListView model:classListModel.

    "
     the methodListView also ...
    "
    scrollHelper := HVScrollableView 
			for:SelectionInListView 
			miniScrollerH:true 
			origin:0.5 @0.0 corner:1.0 @ 1.0 
			in:upperPanel.
    methodListView := scrollHelper scrolledView.
    methodListView model:methodListModel.

    "
     setup for its menu ...
    "
    methodListView menuHolder:self;
		   menuMessage:#methodMenu;
		   menuPerformer:self.

    "
     the codeView is a scrollable CodeView ...
    "
    scrollHelper := HVScrollableView 
			for:CodeView 
			miniScrollerH:true 
			origin:0.0 @0.3 corner:1.0 @ 1.0 
			in:outerPanel.
    codeView := scrollHelper scrolledView.
! !

!SimpleBrowser methodsFor:'startup'!

openInterface
    "sent by my superclass to open up my interface
     (i.e. SimpleBrowser - openInterface)"

    |topView|

    topView := StandardSystemView new.
    topView label:(resources string:'Simple Browser').
    topView application:self.   

    self setupModels.
    self setupSubviewsIn:topView.

    topView open.

    "
     SimpleBrowser open
    "
! !

!SimpleBrowser methodsFor:'updating'!

updateClassList
    "update the classList"

    classListModel 
	list:(Smalltalk allClasses asOrderedCollection
		collect:[:aClass | aClass name]) sort
!

updateCodeView
    "update the methodList and set the acceptAction"

    codeView contents:(currentMethod source).
    codeView acceptAction:[:theCode |
	codeView topView withCursor:(Cursor wait)
	do:[
	    Compiler
		compile:theCode asString
		forClass:currentClass
		inCategory:'no category' 
		notifying:codeView.
	 ]
    ]
!

updateMethodList
    "update the methodList"

    |dict selectors|

    dict := currentClass methodDictionary.
    selectors := dict keys.
    methodListModel list:(selectors sort)

    "Modified: 8.2.1997 / 17:39:19 / cg"
! !

!SimpleBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/SimpleBrowser.st,v 1.4 1997-02-08 16:41:48 cg Exp $'
! !
