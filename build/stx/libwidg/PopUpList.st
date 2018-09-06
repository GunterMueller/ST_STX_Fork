"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Button subclass:#PopUpList
	instanceVariableNames:'menu menuAction values useIndex listMsg defaultLabel listHolder
		showHandle ignoreReselect'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!PopUpList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    a PopUpList is basically a button with a popup menu.
    The PopUpLists label is showing the current selection from the
    list.
    When an entry is selected, an actionBlock (if nonNil) is evaluated
    and (if nonNil), the model is notified via the changeMessage.

    If no model is set, the list is assumed to be a static list, which
    is defined via #list:, and the popUpList evaluates the action block,
    as defined via #action:.

    If a model is provided, it should return the current selected items index via the 
    aspectMessage (default is #selection or: #selectionIndex, depending on the setting 
    of useIndex) and the list via the listMessage (default is #list).
    If the listMessage was set to nil, the list is not acquired from the model
    and can be set explicitely via #list:.

    The defaults are set to allow a PopUpList to be used with a SelectionInList 
    as model without further setup.
    A simple valueHolder may also be used without further setup.
    (if used with some other model, either use an adaptor, or set the
     change/aspect and/or listMessage to something else ..)

    If a listHolder is set, this one is always asked for the list instead of the
    model, via the #value message. 
    This allows the popUpListView to acquire the list and value from different places.


    Notice: PopUpList and ComboListView provide a similar protocol and functionality.


    [Instance variables:]

        menu                            helpers for the popup menu
        menuAction 
        values 

        useIndex             <Boolean>  if true, the index of the selected entry
                                        is passed to the action block and the
                                        model in a change-message.
                                        If false (the default), the value is passed.
                                        Notice that the default changeMessage is
                                        #selection:, which is not ok to be used
                                        with useIndex:true and a selectionInList model.
                                        (set the changeMessage to #selectionIndex: then)

        listMsg              <Symbol>   message to acquire a new list from the
                                        model. Default is #list.


        listHolder           <Object>   if non-nil, this object is assumed to return the
                                        list via the listMsg (instead of the model).
                                        Default is nil.

    [see also:]
        SelectionInList ValueHolder
        SelectionInListView
        ComboListView

    [author:]
        Claus Gittinger
"
!

examples
"
  non-MVC use:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'healthy fruit'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p open
                                                                        [exEnd]


    with an initial selection:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'dummy'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p selection:'apples'.
     p open
                                                                        [exEnd]


    with separating lines:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'fruit'.
     p list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     p selection:'apples'.
     p open
                                                                        [exEnd]


    draw without menu-handle:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'fruit'.
     p list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     p showHandle:false.
     p open
                                                                        [exEnd]


    with an action:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'dummy'.
     p list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     p selection:'apples'.
     p action:[:what | Transcript showCR:'you selected: ' , what].
     p open
                                                                        [exEnd]


    sometimes, you may like the index instead of the value:
    (notice, that the separating line counts, so you have to take care ...)
                                                                        [exBegin]
     |p|
     p := PopUpList label:'dummy'.
     p list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     p selection:'apples'.
     p action:[:what | Transcript show:'you selected: '; showCR:what].
     p useIndex:true.
     p open
                                                                        [exEnd]


    since the list is actually a popupMenu, you can add double-separators:
    also, here values are different from the labels
                                                                        [exBegin]
     |p|
     p := PopUpList label:'dummy'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 
              '=' 
              'margaritas' 'pina colada'
              '=' 
              'smalltalk' 'c++' 'eiffel' 'java').
     p values:#(apples bananas grape lemon 
                nil 
                'mhmh - so good' 'makes headache'
                nil
                'great' 'another headache' 'not bad' 'neat').
     p selection:'apples'.
     p action:[:what | Transcript show:'you selected: '; showCR:what].
     p open
                                                                        [exEnd]


    since the list is actually represented by a menuView,
    which itself is inheriting from listView, which itself can display
    things different from strings, arbitrary lists can be constructed:
    (see ListEntry, LabelAndIcon and Text classes)
                                                                        [exBegin]
     |p l|
     p := PopUpList label:'dummy'.
     l := OrderedCollection new.
     l add:(Text string:'apples' color:Color red).
     l add:(Text string:'bananas' color:Color red).
     l add:(Text string:'grape' color:Color red).
     l add:(Text string:'lemon' color:Color red).
     l add:'='.
     l add:(Text string:'margaritas' color:Color green darkened darkened).
     l add:(Text string:'pina colada' color:Color green darkened darkened).
     l add:'='.
     l add:(Text string:'smalltalk' color:Color blue).
     l add:(Text string:'c++' color:Color blue).
     l add:(Text string:'eiffel' color:Color blue).
     l add:(Text string:'java' color:Color blue).
     p list:l.
     p values:#(apples bananas grape lemon 
                nil 
                'mhmh - so good' 'makes headache'
                nil
                'great' 'another headache' 'not bad' 'neat').
     p selection:'apples'.
     p action:[:what | Transcript show:'you selected: '; showCR:what].
     p open
                                                                        [exEnd]


    with values different from the label strings:
                                                                        [exBegin]
     |p|
     p := PopUpList label:'dummy'.
     p list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     p selection:'apples'.
     p values:#(10 20 30 40 nil 50).
     p action:[:what | Transcript show:'you selected: '; showCR:what].
     p open
                                                                        [exEnd]


    with values different from the label strings:
                                                                        [exBegin]
     |p|

     p := PopUpList label:'language selection'.
     p list:( #(
                'usa'
                'uk'
                'france'
                'germany'       
                'italy'
               ) collect:[:country |
                            LabelAndIcon 
                                icon:(Image fromFile:'bitmaps/xpmBitmaps/countries/' , country , '.xpm')
                                string:country
                         ]
            ).
     p values:#(us england france germany italy).

     p action:[:what | Transcript show:'you selected: '; showCR:what].
     p open
                                                                        [exEnd]


  with a model (see in the inspector, how the index-holders value changes)
  the defaults are setup to allow a SelectionInList directly as model:
                                                                        [exBegin]
     |p model|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').

     p := PopUpList label:'healthy fruit'.
     p model:model.
     p open.
     model inspect
                                                                        [exEnd]


  model provides selection; list is explicit:
  must change the aspect, since the default setup is for a SelectionInList
                                                                [exBegin]
     |model top b|

     model := 'foo' asValue.

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := PopUpList in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b model:model; aspect:#value; change:#value:.

     top openModal.
     Transcript showCR:('comboBox''s value: ' , model value).
                                                                [exEnd]


    a popupList and a SelectionInListView on the same model:
                                                                        [exBegin]
     |p slv model|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     model selection:'apples'.

     p := PopUpList on:model.
     p open.

     slv := SelectionInListView on:model.
     slv open.
                                                                        [exEnd]


    dynamically changing the list (click button(s) to change):
                                                                        [exBegin]
     |p slv model b|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     model selection:'apples'.

     p := PopUpList on:model.
     p open.

     slv := SelectionInListView on:model.
     slv open.

     b := Button label:'long list' action:[model list:#('1' '2' '3' '4' '5' '6')].
     b open.
     b := Button label:'short list' action:[model list:#('1' '2' '3')].
     b open.

                                                                        [exEnd]



    two PopUpLists on the same model, different aspects:
                                                                        [exBegin]
     |top panel p model|

     model := Plug new.
     model respondTo:#eat: with:[:val | Transcript showCR:'eat: ' , val].
     model respondTo:#drink: with:[:val | Transcript showCR:'drink: ' , val].
     model respondTo:#meals with:[#(taco burrito enchilada)].
     model respondTo:#drinks with:[#(margarita water corona)].

     top := StandardSystemView new.
     top extent:(100@100).
     panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
     panel horizontalLayout:#fitSpace.

     p := PopUpList label:'meals'.
     p model:model; listMessage:#meals; aspect:nil; change:#eat:.
     panel add:p.

     p := PopUpList label:'drinks'.
     p model:model; listMessage:#drinks; aspect:nil; change:#drink:.
     panel add:p.

     top open
                                                                        [exEnd]


    with separate list- and indexHolders:
                                                                        [exBegin]
     |p selectionHolder listHolder|

     listHolder := #('apples' 'bananas' 'grape' 'lemon' 'margaritas') asValue.
     selectionHolder := 'apples' asValue.

     p := PopUpList label:'healthy fruit'.
     p listHolder:listHolder.
     p model:selectionHolder; aspect:#value; change:#value:.
     p open.
     selectionHolder inspect
                                                                        [exEnd]

    same, using index:
                                                                        [exBegin]
     |p selectionIndexHolder listHolder|

     listHolder := #('apples' 'bananas' 'grape' 'lemon' 'margaritas') asValue.
     selectionIndexHolder := 3 asValue.

     p := PopUpList new.
     p listHolder:listHolder.
     p model:selectionIndexHolder; aspect:#value; change:#value:.
     p useIndex:true.
     p open.
     selectionIndexHolder inspect
                                                                        [exEnd]

    using different values:
                                                                        [exBegin]
     |p selectionHolder listHolder values|

     listHolder := #('apples' 'bananas' 'grape' 'lemon' 'margaritas') asValue.
     values := #(apples bananas grape lemon alcohol).

     selectionHolder := #alcohol asValue.

     p := PopUpList label:'healthy fruit'.
     p listHolder:listHolder.
     p model:selectionHolder; aspect:#value; change:#value:.
     p values:values.
     p open.
     selectionHolder inspect
                                                                        [exEnd]

    provide your own menu (spec could come from a specMethod):
                                                                        [exBegin]
     |p myMenu selectionHolder|

     selectionHolder := nil asValue.
     myMenu :=
       #(#Menu
           #(
            #(#MenuItem
                #label: 'Oranges'
                #translateLabel: true
                #value: #oranges
            )
            #(#MenuItem
                #label: 'Lemons'
                #translateLabel: true
                #value: #lemons
            )
            #(#MenuItem
                #label: 'grape'
                #translateLabel: true
                #value: #grape
            )
            #(#MenuItem
                #label: '-'
            )
            #(#MenuItem
               #label: 'other'
               #translateLabel: true
               #value: #other
               #submenu: 
                  #(#Menu
                     #(
                      #(#MenuItem
                         #label: 'margarita'
                         #translateLabel: true
                         #value: #margarita
                       )
                      #(#MenuItem
                         #label: 'vine'
                         #translateLabel: true
                         #value: #vine
                       )
                      )
                   )
            )
          )
       ) decodeAsLiteralArray.
     p := PopUpList label:'healthy fruit'.
     p menu:myMenu.
     p model:selectionHolder; aspect:#value; change:#value:.
     selectionHolder inspect.
     p open.
                                                                        [exEnd]

"
! !

!PopUpList class methodsFor:'defaults'!

defaultAspectMessage
    ^ #selection
!

defaultChangeMessage
    ^ #selection:
!

defaultListMessage
    ^ #list 
! !

!PopUpList methodsFor:'accessing'!

contents
    "return the current contents"

    ^ self label
!

contents:con
    "change the contents"

    ^ self selection:con

    "Modified: 25.5.1996 / 14:20:57 / cg"
!

defaultLabel:aString
    "set the defaultLabel, to be shown if nothing is selected"

    defaultLabel := aString.
    shown ifFalse:[
        super label:defaultLabel
    ].

    "Modified: / 29.10.1997 / 15:50:10 / cg"
!

label:aString
    self defaultLabel:aString.
    model isNil ifTrue:[
        super label:aString suppressResize:(self shown)
    ].

    "Created: / 1.3.1997 / 02:09:02 / cg"
    "Modified: / 29.10.1997 / 15:49:50 / cg"
!

list
    "return the list - i.e. the values shown in the pop-up list"

    ^ menu labels
!

list:aList
    "set the list - i.e. the values shown in the pop-up list"

    self createMenuFor:aList.
    realized ifTrue:[
	self computeLabelSize
    ]

    "
     |p|
     p := PopUpList label:'fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p action:[:val | Transcript showCR:'selected: ' , val printString].   
     p open
    "
!

selection:indexOrString
    "set (force) a selection - usually done to set
     an initial selection without updating others"

    |index menuLabels newLabel|

    menu isNil ifTrue:[
        self getListFromModel.
    ].
    menu isNil ifTrue:[^ self].
    menuLabels := menu labels.

    (useIndex not and:[values notNil]) ifTrue:[
        values notNil ifTrue:[
            index := values indexOf:indexOrString
        ]
    ] ifFalse:[
        indexOrString isNumber ifTrue:[
            index := indexOrString
        ] ifFalse:[
            menuLabels notNil ifTrue:[
                index := menuLabels indexOf:indexOrString.
            ]
        ].
        "/ fails if list consists of symbols ...
        "/ index := menu indexOf:indexOrString.
    ].
    (index isNil or:[index > menuLabels size]) ifTrue:[
        index := 0
    ].

    index == 0 ifTrue:[
        newLabel := defaultLabel
    ] ifFalse:[
        newLabel := (menuLabels at:index) 
    ].

    "kludge: don't want label to resize ..."

    self label:newLabel suppressResize:true.

    "
     |p|
     p := PopUpList label:'what fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p selection:'grape'.
     p open 

     |p|
     p := PopUpList label:'what fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p selection:'blabla'.
     p open

     |p|
     p := PopUpList label:'what fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p defaultLabel:'nothing selected'.
     p selection:'blabla'.
     p open
    "

    "Modified: / 29-10-1997 / 15:50:12 / cg"
    "Modified: / 26-01-2018 / 10:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

values:aList
    "set a value list - these are reported via the action or changeSymbol instead of
     the label strings."

    values := aList.

    "
     |p|
     p := PopUpList label:'fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p values:#(1 2 3 4 'mhmh - good').
     p action:[:val | Transcript showCR:'selected: ' , val printString].   
     p open.
    "

    "Modified: 27.2.1997 / 10:24:12 / cg"
! !

!PopUpList methodsFor:'accessing-behavior'!

action:aOneArgBlock
    "set the action to be performed on selection changes;
     the argument, aOneArgBlock will be evaluated with the
     selection-value as argument"

    menuAction := aOneArgBlock
!

ignoreReselect:aBoolean 
    ignoreReselect := aBoolean
!

menu:aMenu
    "explicit change of the menu; 
     allows for non-list-based, or MenuBuilder-constructed menus to be used.
     Attention: this bypasses the list/listHolder"

    menu := aMenu.
!

menu:aMenu default:label
    "explicit change of the menu and default value; 
     allows for non-list-based, or MenuBuilder-constructed menus to be used.
     Attention: this bypasses the list/listHolder"

    menu := aMenu.
    defaultLabel := label
!

useIndex
    "tell the popuplist to pass the index (instead of the value)
     to both the actionBlock and model. Notice, that if you use a model,
     the default changeSelector is not ok for using index and a SelectionInList"

    ^ useIndex
!

useIndex:aBoolean 
    "tell the popuplist to pass the index (instead of the value)
     to both the actionBlock and model. Notice, that if you use a model,
     the default changeSelector is not ok for using index and a SelectionInList"

    useIndex := aBoolean

    "
     |p|
     p := PopUpList label:'fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p action:[:val | Transcript showCR:'selected: ' , val printString].   
     p open.
    "
    "
     |p|
     p := PopUpList label:'fruit ?'.
     p list:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     p action:[:val | Transcript showCR:'selected: ' , val printString].   
     p useIndex:true.
     p open.
    "
! !

!PopUpList methodsFor:'accessing-look'!

showHandle
    "return true if the pull-handle is to be drawn; default is true"

    ^ showHandle

    "Created: / 6.3.1999 / 21:26:40 / cg"
!

showHandle:aBoolean
    "controls if the pull-handle is to be drawn; default is true"

    showHandle ~~ aBoolean ifTrue:[
        showHandle := aBoolean.
        self computeLabelSize
    ].

    "Modified: / 6.3.1999 / 21:58:21 / cg"
! !

!PopUpList methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    "see comment in View>>modelInterface"

    super addModelInterfaceTo:aDictionary.
    aDictionary at:#listMessage put:listMsg

    "Modified: 26.2.1997 / 19:08:04 / cg"
!

listHolder
    "return the listHolder if any"

    ^ listHolder
!

listHolder:aValueHolder
    "set the listHolder - if non nil, that one is assumed to provide the
     list via #value.
     If a listHolder was defined, the model is never asked for the list."

    listHolder notNil ifTrue:[
        listHolder removeDependent:self.
    ].
    listHolder := aValueHolder.
    listHolder notNil ifTrue:[
        listHolder addDependent:self.
    ].
    shown ifTrue:[
        self getListFromModel
    ]

    "Modified: 26.2.1997 / 19:06:01 / cg"
!

listMessage
    "return the selector by which we ask the model or listHolder for the list.
     The default is #list. 
     If a listHolder was defined, the model is never asked for the list."

    ^ listMsg

    "Modified: 26.2.1997 / 19:05:27 / cg"
!

listMessage:aSelector
    "set the selector by which we ask the model for the list.
     The default is #list. 
     If a listHolder was defined, the model is never asked for the list."

    listMsg := aSelector

    "Modified: 26.2.1997 / 19:05:18 / cg"
!

model:aModel
    "set the model which provides the selection and/or the list"

    super model:aModel.
    self getListFromModel.
    self getSelectionFromModel.

    "Created: 28.2.1997 / 19:12:08 / cg"
! !

!PopUpList methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == listHolder ifTrue:[
        self getListFromModel.
        ^ self
    ].
    changedObject == model ifTrue:[
        aspectMsg notNil ifTrue:[

            self getSelectionFromModel.
        ].
        listHolder notNil ifTrue:[
            "/ that one holds the list;
            "/ model holds the value
            self getSelectionFromModel
        ] ifFalse:[
            listMsg notNil ifTrue:[
                self getListFromModel.
            ]
        ].
        ^ self
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 18.6.1998 / 23:48:47 / cg"
! !

!PopUpList methodsFor:'drawing'!

drawWith:fgColor and:bgColor
    |mmH mmV mW mH|

    controller pressed ifTrue:[
        super drawWith:enteredFgColor and:enteredBgColor
    ] ifFalse:[
        super drawWith:fgColor and:bgColor.
    ].

    showHandle ifTrue:[
        mmH := device horizontalPixelPerMillimeter.
        mmV := device verticalPixelPerMillimeter.
        mW := (mmH * 2.5) rounded.
        mH := (mmV * 1.5) rounded.

        self 
            drawEdgesForX:(width - mW - (hSpace*2)) y:((height - mmV rounded) // 2)
                     width:mW height:mH 
                     level:2
    ].

    "Modified: / 6.3.1999 / 21:56:13 / cg"
!

showActive
    "no need to redraw - will pop menu on top of me anyway ..."

    ^ self
!

showPassive
    "no need to redraw - will redraw from unpopped menu anyway ..."

    ^ self
! !

!PopUpList methodsFor:'event handling'!

keyPress:key x:x y:y
    "pull menu on Return and space"

    <resource: #keyboard (#Return)>

    (key == Character space or:[key == #Return])ifTrue:[
        self popMenu.
        ^ self
    ].
    super keyPress:key x:x y:y

    "Created: / 21.4.1998 / 20:05:19 / cg"
!

popMenu
    |org theMenu val|

    menu notNil ifTrue:[
        theMenu := menu value
    ].

    theMenu notNil ifTrue:[
        self turnOffWithoutRedraw. 

        theMenu value labels size == 0 ifTrue:[
            ^ self
        ].

        theMenu isView ifTrue:[
            "/ oldStyle - theMenu is a PopUpMenu / MenuPanel
            theMenu font:gc font.

            "
             adjust the menus width to my current width
            "
            menu preferredWidth:(self width).

            "
             the popupMenu wants Display coordinates in its showAt: method
            "
            org := device translatePoint:0@0 fromView:self toView:nil.

            theMenu showAt:org "resizing:false"
        ] ifFalse:[
            "/ newStyle - theMenu is a Menu
            val := theMenu startUpOrNil.
            (theMenu isKindOf:PopUpMenu) ifFalse:[
                "/ sigh - brand new ...
                val notNil ifTrue:[
                    self sendChangeMessage:changeMsg with:val.
                    menuAction notNil ifTrue:[
                        menuAction value:val
                    ]
                ].
            ].
        ]
    ].

    "Modified: / 15.11.2001 / 16:53:53 / cg"
! !

!PopUpList methodsFor:'initialization'!

defaultControllerClass
    ^ PopUpListController
!

initialize
    super initialize.

    controller beTriggerOnDown.
    controller action:[self popMenu].
    ignoreReselect := true.
    useIndex := false.
    defaultLabel := 'popup'.
    showHandle := true.
    self adjust:#left.

    super label:defaultLabel.

    listMsg := self class defaultListMessage.

    onLevel := offLevel.

    "Modified: 1.3.1997 / 02:12:55 / cg"
! !

!PopUpList methodsFor:'private'!

createMenuFor:aList
    |index|

    (aList isKindOf:Menu) ifTrue:[
        menu := aList.
        ^ self.
    ].

"/ old code (uses old PopUpMenu)
"/    menu := PopUpMenu
"/                  labels:aList
"/               selectors:#select:
"/                    args:(1 to:aList size) 
"/                receiver:self
"/                     for:self.

"/ new code - uses (scrollable) MenuPanel
    menu := MenuPanel labels:aList.

    index := 1.
    menu do:[:el | el value:#select:. el argument:index. index := index + 1. ].
    menu receiver:self.
    menu font:gc font.
    menu preferredWidth:self width.

"/ end of change

    "Modified: / 15.11.2001 / 16:51:34 / cg"
!

getListFromModel
    "if I have a listHolder, ask it for the list;
     otherwise, if I have a model and a listMsg, get my list from there"

    listHolder notNil ifTrue:[
        self list:listHolder value.
"/        model notNil ifTrue:[
"/            self halt.
"/        ]
    ] ifFalse:[
        (listMsg notNil and:[model notNil]) ifTrue:[
            (model respondsTo:listMsg) ifTrue:[
                self list:(model perform:listMsg).
            ]
        ].
    ]

    "Modified: / 19.6.1998 / 01:54:17 / cg"
!

getSelectionFromModel
    "if I have a model and an aspectMsg, get my current value from it"

    |aspect val newLabel|

    (model notNil and:[aspectMsg notNil]) ifTrue:[
        "/ kludge - try #value if aspect is the default and
        "/ not understood by the model
        "/ this allows a valueHolder to be used, even
        "/ if the aspectMessage was not setup correctly.

        aspect := aspectMsg.
        aspect == self class defaultAspectMessage ifTrue:[
            (model respondsTo:aspect) ifFalse:[
                aspect := #value
            ]
        ].
        val := (model perform:aspect).

        useIndex ifFalse:[
            val isNil ifTrue:[
                newLabel := defaultLabel 
            ] ifFalse:[
                newLabel := val printString.
            ].
            ^ self label:newLabel suppressResize:true.
        ].
        self selection:val
    ].

    "Modified: / 18.6.1998 / 23:54:34 / cg"
!

rawLabelSizeOf:aLogo
    "compute the extent needed to hold the label plus the mark"

    |ext mmH mmV longest longestWidth labels|

    ext := super rawLabelSizeOf:aLogo.

    (menu notNil 
    and:[adjust ~~ #right
    and:[adjust ~~ #center]]) ifTrue:[
        "compute length of longest menu entry"

        longest := logo.
        logo isNil ifTrue:[
            longestWidth := 0
        ] ifFalse:[
            longestWidth := super rawLabelSizeOf: logo.
        ].
        labels := menu value labels.
        labels notNil ifTrue:[
            labels do:[:entry |
                |this|

                this := super rawLabelSizeOf: entry.
                this > longestWidth ifTrue:[
                    longest := entry.
                    longestWidth := this
                ].
            ].
        ].
        ext := ext max:(super rawLabelSizeOf:(longest displayString))
    ].

    showHandle ifTrue:[
        mmH := device horizontalPixelPerMillimeter.
        mmV := device verticalPixelPerMillimeter.
        ^ (ext x + hSpace + (mmH * 2.5) rounded + hSpace)
          @
          (ext y max: (mmV * 2) rounded)
    ].
    ^ ext

    "Modified: / 06-03-1999 / 21:51:14 / cg"
    "Modified: / 26-01-2018 / 10:11:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PopUpList methodsFor:'private-controller access'!

menu
    "return the menu component"

    ^ menu
! !

!PopUpList methodsFor:'queries'!

preferredExtent
    "redefined to make certain that the menu is fully defined"

    menu isNil ifTrue:[
        self getListFromModel
    ].
    ^ super preferredExtent.

    "Modified: 19.7.1996 / 20:45:16 / cg"
!

specClass
    "XXX no longer needed (inherited default works here)"

    self class == PopUpList ifTrue:[^ PopUpListSpec].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:48:02 / cg"
! !

!PopUpList methodsFor:'testing'!

isPopUpList
    ^ true
! !

!PopUpList methodsFor:'user actions'!

select:anIndex
    "this is sent from the popupmenu when an entry was selected"

    |value menuLabels label chg|

    menuLabels := menu labels.
    values isNil ifTrue:[
        value := anIndex.
        useIndex ifFalse:[
            value := menuLabels at:anIndex.
        ]
    ] ifFalse:[
        value := values at:anIndex
    ].

"/    model isNil ifTrue:[
        "/ if there is a model,
        "/ the update will change my logo ...

        "/ self sizeFixed:true.
        label := menuLabels at:anIndex.
        super label:label suppressResize:true.
"/    ].

    (model notNil and:[changeMsg notNil]) ifTrue:[
        "/
        "/ ST-80 way of doing it
        "/ tell my model - if any
        "/

        "/ kludge - try #value: if changeMsg is the default and
        "/ not understood by the model
        "/ this allows a valueHolder to be used, even
        "/ if the aspectMessage was not setup correctly.

        chg := changeMsg.
        chg == self class defaultChangeMessage ifTrue:[
            (model respondsTo:chg) ifFalse:[
                chg := #value:
            ]
        ].
        ignoreReselect ifFalse:[
            (value == model value) ifTrue:[
                model setValue:nil.
            ].
        ].
        self sendChangeMessage:chg with:value.
    ].

    "/
    "/ ST/X action blocks
    "/
    menuAction notNil ifTrue:[
        menuAction value:value.
    ].

    "Modified: / 29-10-1997 / 21:08:50 / cg"
    "Modified: / 26-01-2018 / 10:10:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PopUpList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

