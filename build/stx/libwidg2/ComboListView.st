"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ComboView subclass:#ComboListView
	instanceVariableNames:'useIndex values selectCondition'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboListView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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
    A ComboListView combines a label with a drop down list of default inputs;
    choosing any from the pulled list sets the string in the label.

    This is the same as a PopUpList or SelectionInListView, bit looks different.

    The preferred model is a SelectionInList, but a simple valueHolder
    may also be used.
    If some other model is to be used, the changeMessage and aspectMessage
    should be defined as appropriate (or an aspectAdaptor should be used).
    If a listHolder is set, that one is assumed to provide the list of
    items in the popped menu;
    otherwise, if listMessage is nonNil, the model is assumed to also provide the
    list as displayed in the popped menu.

    [author:]
        Claus Gittinger

    [see also:]
        ComboView
        PopUpList SelectionInListView
        ComboBoxView ExtendedComboBox
        PullDownMenu Label EntryField
"
!

examples
"
  non-MVC use; 
    set the list explicitely:
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList list:#('hello' 'world' 'this' 'is' 'st/x').
     top open.
                                                                [exEnd]

  a really, really long list (notice scrollup/down buttons at the top/bottom); 
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList list:((1 to:100) collect:[:n | n printString]).
     top open.
                                                                [exEnd]


    with callBack:
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList list:#('hello' 'world' 'this' 'is' 'st/x').
     comboList action:[:selected | Transcript showCR:selected].
     top open.
                                                                [exEnd]



    with separating lines:
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView label:'fruit chooser'.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList label:'fruit'.
     comboList list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     comboList action:[:selected | Transcript showCR:selected].
     top open
                                                                [exEnd]




    with values different from the label strings:
                                                                        [exBegin]
     |top comboList|

     top := StandardSystemView label:'fruit chooser'.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList label:'dummy'.
     comboList list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     comboList selection:'apples'.
     comboList values:#(10 20 30 40 nil 50).
     comboList action:[:what | Transcript show:'you selected: '; showCR:what].
     top open
                                                                        [exEnd]


    sometimes, you may like the index instead of the value:
    (notice, that the separating line counts, so you have to take care ...)
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView label:'fruit chooser'.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList label:'dummy'.
     comboList list:#('apples' 'bananas' 'grape' 'lemon' '-' 'margaritas').
     comboList selection:'apples'.
     comboList action:[:what | Transcript show:'you selected: '; showCR:what].
     comboList useIndex:true.
     top open
                                                                [exEnd]

    since the list is actually represented by a menuView,
    which itself is inheriting from listView, which itself can display
    things different from strings, arbitrary lists can be constructed:
    (see ListEntry, LabelAndIcon and Text classes)
                                                                        [exBegin]
     |top comboList l|

     top := StandardSystemView label:'fruit chooser'.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

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
     comboList list:l.
     comboList values:#(apples bananas grape lemon 
                nil 
                'mhmh - so good' 'makes headache'
                nil
                'great' 'another headache' 'not bad' 'neat').
     comboList selection:'apples'.
     comboList action:[:what | Transcript show:'you selected: '; showCR:what].
     top open
                                                                        [exEnd]

    with values different from the label strings:
                                                                        [exBegin]
     |top comboList|

     top := StandardSystemView label:'language chooser'.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).

     comboList list:( #(
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
     comboList values:#(us england france germany italy).

     comboList action:[:what | Transcript show:'you selected: '; showCR:what].
     comboList bottomInset:(comboList preferredExtent y negated).
     top open
                                                                        [exEnd]


  with a model (see in the inspector, how the index-holders value changes)
  the defaults are setup to allow a SelectionInList directly as model:
                                                                        [exBegin]
     |p model|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').

     p := ComboListView label:'healthy fruit'.
     p model:model.
     p openAt:(Screen current center).
     model inspect
                                                                        [exEnd]

  model provides selection; list is explicit:
                                                                [exBegin]
     |model top b|

     model := 'foo' asValue.

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := ComboListView in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b model:model.

     top openModal.
     Transcript showCR:('comboBox''s value: ' , model value).
                                                                [exEnd]


    a comboListView and a SelectionInListView on the same model:
                                                                        [exBegin]
     |p slv model|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     model selection:'apples'.

     p := ComboListView on:model.
     p openAt:(Screen current center).

     slv := SelectionInListView on:model.
     slv openAt:(Screen current center + (100@100)).
                                                                        [exEnd]


    like above, using index:
                                                                        [exBegin]
     |p slv model|

     model := SelectionInList with:#('apples' 'bananas' 'grape' 'lemon' 'margaritas').
     model selection:'apples'.

     p := ComboListView on:model.
     p openAt:(Screen current center).

     slv := SelectionInListView on:model.
     slv openAt:(Screen current center + (100@100)).
                                                                        [exEnd]


    two comboListViews on the same model, different aspects:
                                                                        [exBegin]
     |top panel p model|

     model := Plug new.
     model respondTo:#eat: with:[:val | Transcript showCR:'eat: ' , val].
     model respondTo:#drink: with:[:val | Transcript showCR:'drink: ' , val].
     model respondTo:#meals with:[#(taco burrito enchilada)].
     model respondTo:#drinks with:[#(margarita water corona)].

     top := StandardSystemView label:'meal chooser'.
     top extent:(150@150).
     panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
     panel horizontalLayout:#fitSpace.

     p := ComboListView label:'meals'.
     p aspect:nil; model:model; listMessage:#meals; change:#eat:.
     panel add:p.

     p := ComboListView label:'drinks'.
     p aspect:nil; model:model; listMessage:#drinks; change:#drink:.
     panel add:p.

     top open
                                                                        [exEnd]




    with separate list- and indexHolders:
                                                                        [exBegin]
     |p selectionHolder listHolder|

     listHolder := #('apples' 'bananas' 'grape' 'lemon' 'margaritas') asValue.
     selectionHolder := 'apples' asValue.

     p := ComboListView label:'healthy fruit'.
     p listHolder:listHolder.
     p model:selectionHolder.
     p openAt:(Screen current center).
     selectionHolder inspect
                                                                        [exEnd]

    using different values:
                                                                        [exBegin]
     |p priceHolder listHolder prices priceField|

     listHolder := #('apples' 'bananas' 'grape' 'lemon' 'margaritas') asValue.
     prices := #(10 10 5 15 50).

     priceHolder := nil asValue.

     p := ComboListView new.
     p listHolder:listHolder.
     p model:priceHolder.
     p values:prices.
     p openAt:(Screen current center).

     priceField := EditField new.
     priceField readOnly:true.
     priceField model:(TypeConverter onNumberValue:priceHolder).
     priceField openAt:(Screen current center + (10@10)).
                                                                        [exEnd]


  in a dialog:
                                                                [exBegin]
     |model1 model2 dialog b|

     model1 := 'foo' asValue.
     model2 := 'bar' asValue.

     dialog := Dialog new.
     (dialog addTextLabel:'ComboList example:') adjust:#left.
     dialog addVerticalSpace.

     (b := dialog addComboListOn:model1 tabable:true).
     b list:#('fee' 'foe' 'foo').
     dialog addVerticalSpace.

     (b := dialog addComboListOn:model2 tabable:true).
     b list:#('bar' 'baz' 'baloo').
     dialog addVerticalSpace.

     dialog addOkButton.

     dialog open.

     Transcript showCR:('1st comboBox''s value: ' , model1 value).
     Transcript showCR:('2nd comboBox''s value: ' , model2 value).
                                                                [exEnd]

  Select condition
                                                                [exBegin]
     |top comboList|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     comboList := ComboListView in:top.
     comboList origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     comboList bottomInset:(comboList preferredExtent y negated).

     comboList list:((1 to:100) collect:[:n | n printString]).
     comboList selectCondition:[:newValue | (Number readFrom:newValue) even].
     top open.
                                                                [exEnd]



"
! !

!ComboListView class methodsFor:'defaults'!

defaultAspectMessage
    ^ #selection

    "Created: 27.2.1997 / 15:23:13 / cg"
!

defaultChangeMessage
    ^ #selection:

    "Created: 27.2.1997 / 15:23:18 / cg"
!

defaultFont
    ^ SelectionInListView defaultFont.
! !

!ComboListView methodsFor:'accessing'!

selectCondition:something
    selectCondition := something.
! !

!ComboListView methodsFor:'accessing-behavior'!

useIndex
    "specify, if the selected components value or its index in the
     list should be sent to the model. The default is its value."

    ^ useIndex
!

useIndex:aBoolean
    "specify, if the selected components value or its index in the
     list should be sent to the model. The default is its value."

    useIndex := aBoolean.

"/    "/ change the aspectMessage - but only if it has not yet been
"/    "/ changed explicitly
"/    useIndex ifTrue:[
"/        changeMsg == #selection: ifTrue:[
"/            changeMsg := #selectionIndex:.
"/            aspectMsg := #selectionIndex.
"/        ]
"/    ] ifFalse:[
"/        changeMsg == #selectionIndex: ifTrue:[
"/            changeMsg := #selection:.
"/            aspectMsg := #selection.
"/        ]
"/    ].

    "Created: 26.7.1996 / 17:44:18 / cg"
    "Modified: / 24.1.1998 / 19:06:41 / cg"
!

values:aCollection
    "specify, which values are to be stuffed into the model or
     passed via the actionBlock."

    values := aCollection.

    "Created: 27.2.1997 / 15:10:12 / cg"
! !

!ComboListView methodsFor:'accessing-components'!

label 
    "return the label component"

    ^ field

    "Modified: 28.2.1996 / 15:10:50 / cg"
    "Created: 28.2.1996 / 15:13:51 / cg"
! !

!ComboListView methodsFor:'accessing-contents'!

contents
    "get the current value - either in the fields model
     or directly"

    |m|

    (m := field model) notNil ifTrue:[
        ^ m value
    ] ifFalse:[
        ^ field label
    ]
!

contents:something
    "set the current value - either in the fields model or directly"

    |m|

    (m := field model) notNil ifTrue:[
        m value:something
    ] ifFalse:[
        field label:something
    ]

    "Created: 15.7.1996 / 13:16:49 / cg"
    "Modified: 5.1.1997 / 00:05:04 / cg"
!

selection:something
    "set the contents of my field; questionable"

    self contents:something

    "Created: 27.2.1997 / 15:07:37 / cg"
! !

!ComboListView methodsFor:'event handling'!

buttonPress:button x:x y:y view:aView
    aView == field ifTrue:[
        self pullMenu.
    ].
!

enableStateChanged
    |fieldBG fieldFG|

    super enableStateChanged.
    self enabled ifTrue:[
        fieldBG := (styleSheet colorAt:#'comboList.backgroundColor' default:self whiteColor).
        fieldFG := Button defaultForegroundColor
    ] ifFalse:[
        fieldBG := View defaultViewBackgroundColor.
        fieldFG := Button defaultDisabledForegroundColor.
    ].
    field backgroundColor:fieldBG.
    field foregroundColor:fieldFG.
!

handlesButtonPress:button inView:aView
    ^ aView == field
!

keyPress:key x:x y:y
    "select by first letter"

    <resource: #keyboard (#CursorDown #CursorUp)>

    |idx searchKey startIndex|

    list notEmptyOrNil ifTrue:[
        key == #CursorDown ifTrue:[
            self deltaSelect:1.
            ^ self.
        ].
        key == #CursorUp ifTrue:[
            self deltaSelect:-1.
            ^ self.
        ].

        currentIndex isNil ifTrue:[
            currentIndex := 1.
        ].
        searchKey := key asLowercase.
        startIndex := currentIndex + 1.
        [
            idx := list findFirst:[:eachEntry| (eachEntry printString at:1 ifAbsent:Character cr) asLowercase = searchKey]
                        startingAt:startIndex.
        ] doWhile:[ idx = 0 and:[startIndex ~= 1 and:[startIndex := 1. true]] ].

        idx = 0 ifFalse:[
            self select:idx.
            ^ self.
        ].
    ].

    ^ super keyPress:key x:x y:y
! !

!ComboListView methodsFor:'focus handling'!

showFocus:explicit
    "the button got the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    (styleSheet at:#'focusHighlightStyle') == #win95 ifTrue:[
        field hasFocus:true.
        field invalidate.
    ] ifFalse:[
        super showFocus:explicit
    ]
!

showNoFocus:explicit
    "the button lost the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    (styleSheet at:#'focusHighlightStyle') == #win95 ifTrue:[
        field hasFocus:false.
        field invalidate.
    ] ifFalse:[
        ^ super showNoFocus:explicit
    ]
!

subviewsInFocusOrder
    "none of my subviews should get he focus"

    ^ #()
!

wantsFocusWithButtonPress
    "we want the focus, in order to do selection via mouse wheel"

    ^ true
! !

!ComboListView methodsFor:'initialization'!

initialize
    useIndex isNil ifTrue:[useIndex := false].

    super initialize.

    "Created: 26.7.1996 / 17:44:57 / cg"
    "Modified: 27.2.1997 / 15:23:24 / cg"
!

initializeField
    field := CheckLabel in:self.
    field level:((styleSheet at:#'comboList.level') ? -1).
    field borderWidth:0.
    field adjust:#left.
    field delegate:self.    "delegate mouseWheel events to myself"
    field backgroundColor:(styleSheet colorAt:#'comboList.backgroundColor' default:self whiteColor).
    field font:self font.

    "
     |b|

     b := ComboListView new.
     b list:#('hello' 'world' 'this' 'is' 'st/x').
     b open
    "

    "Created: 28.2.1996 / 15:13:46 / cg"
    "Modified: 28.2.1996 / 15:18:40 / cg"
! !

!ComboListView methodsFor:'menu interaction'!

select:anIndex
    "sent from the popped menu, when an item was selected"

    |label value chg|

    values isNil ifTrue:[
        value := anIndex.
        useIndex ifFalse:[
            value := list at:anIndex.
        ]
    ] ifFalse:[
        value := values at:anIndex
    ].

    selectCondition notNil ifTrue:[
        (selectCondition value:value) ifFalse:[
            ^ self.
        ]
    ].

    label := list at:anIndex.
    currentIndex := anIndex.

    field label:label.

    "
     ST-80 style model notification ...
     this updates the model (typically, a ValueHolder)
    "
    (model notNil and:[changeMsg notNil]) ifTrue:[
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

        self sendChangeMessage:chg with:value
    ].
    pullDownButton turnOff.

    "
     ST/X style actionBlock evaluation ...
    "
    action notNil ifTrue:[
        action value:value
    ].

    "Created: / 27-02-1997 / 15:18:44 / cg"
    "Modified: / 28-02-1997 / 13:50:17 / cg"
    "Modified: / 15-09-2006 / 11:40:00 / User"
! !

!ComboListView methodsFor:'private'!

getValueFromModel
    |selection idx aspect newContents|

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

        aspect == #value ifTrue:[
            selection := model value
        ] ifFalse:[
            selection := model perform:aspect.
        ].

        selection notNil ifTrue:[
            values notNil ifTrue:[
                list notNil ifTrue:[
                    idx := values indexOf:selection.
                ].    
                newContents := selection.
            ] ifFalse:[
                useIndex ifTrue:[
                    idx := selection
                ] ifFalse:[
                    self contents:selection.
                    ^ self.
                ]
            ].
            list notNil ifTrue:[
                newContents := list at:idx ifAbsent:nil.
            ]
        ].
        self contents:newContents
    ].

    "Created: / 15.7.1996 / 12:28:53 / cg"
    "Modified: / 1.3.2000 / 15:20:24 / cg"
! !

!ComboListView methodsFor:'queries'!

specClass
    "XXX no longer needed (inherited default works here)"

    self class == ComboListView ifTrue:[
        ^ ComboListSpec
    ].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:49:34 / cg"
! !

!ComboListView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

