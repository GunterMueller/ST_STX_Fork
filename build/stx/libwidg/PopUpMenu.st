"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

PopUpView subclass:#PopUpMenu
	instanceVariableNames:'menuView lastSelection memorize hideOnLeave actionLabels
		actionLines actionValues hideOnRelease defaultHideOnRelease
		hideOnAnyKey hideOnKeyFilter'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Menus'
!

!PopUpMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Warning: this is a very old class which was written well before many improved
    successors and tools were added. A lot of stuff you find here is kept for backward
    compatibility.

    This class provides PopUpMenu functionality;
    -> Actually, this class only provides the popup and shadow functionality 
       and wraps ANOTHER view, which shows the actual menu-list 
       (usually an instance of MenuView, but in theory, other views could be wrapped as popup).

    PopUpMenus are usually created with a list of labels, selectors and a
    receiver. 
    Once activated, the specified receiver will be sent a 'selector'-message.

    PopupMenus may be either assigned statically to a view (via the #middleButtonMenu:
    message) or created dynamically as required.
    Static definition makes sense, if the menu stays constant and you want to
    assign it once for the lifetime of the view.

    Dynamic menus are easier to use, if the number of or look of the entries has to
    change according the internal state of some model. Also, this is the ST-80 way
    of using popupMenus. For dynamic popups, the view's model is asked for a menu
    via the #menuSelector each time a button press occurs.

    See examples section for more.

    [author:]
        Claus Gittinger

    [see also:]
        PullDownMenu MenuView
"
!

examples
"
  The ST-80 way of opening menus is to startUp a menu,
  and use the returned value:
                                                                        [exBegin]
    |p|

    p := PopUpMenu
            labels:#('foo' 'bar' 'baz').
    Transcript showCR:p startUp
                                                                        [exEnd]
  It returns the index of the selected item or 0 if nothing was selected.
  This opening is done by either the controller or the view (if it has
  a middleButtonMenu and/or a menuHolder).

  If the numeric index is inconvenient, alternative values may be specified
  as in (here, nil is returned if nothing was selected):
                                                                        [exBegin]
    |p|

    p := PopUpMenu
            labels:#('foo' 'bar' 'baz')
            values:#('hello foo' 'hello bar' 'hello baz').
    Transcript showCR:p startUp
                                                                        [exEnd]
  In ST/X, the above is actually done by a mimicri method (#startUp)
  and menus are typically created in one of the following ways:

  -> With a single actionBlock.
     This is convenient, if all actions shall perform a similar task, 
     but require different arguments.

  this is evaluated, passing the selections index or value as argument.
  The action block is NOT evaluated, if nothing was selected.
    With index:
                                                                        [exBegin]
    |p|

    p := PopUpMenu
            labels:#('foo' 'bar' 'baz').
    p action:[:item | Transcript showCR:item].
    p showAtPointer
                                                                        [exEnd]
    With individual arguments:
                                                                        [exBegin]
    |p|

    p := PopUpMenu
            labels:#('foo' 'bar' 'baz')
            args:#('hello foo' 'hello bar' 'hello baz').
    p action:[:item | Transcript showCR:item].
    p showAtPointer
                                                                        [exEnd]

  -> With an explicit receiver and different selectors.
     This is convenient, if you have to send per-item messages
     to some object (typically, the receiver is the view or a model)
                                                                        [exBegin]
    |p m|

    m := Plug new.
    m respondTo:#foo with:[Transcript showCR:'foo received'].
    m respondTo:#bar with:[Transcript showCR:'bar received'].
    m respondTo:#maz with:[Transcript showCR:'maz received'].

    p := PopUpMenu
            labels:#('foo' 'bar' 'baz')
            selectors:#(#foo #bar #baz)
            receiver:m.
    p showAtPointer
                                                                        [exEnd]


  More examples:
    dynamic with action instead of selector being sent:
                                                                        [exBegin]
        |p|

        p := PopUpMenu
                labels:(($a to: $d) collect:[:char | char asString])
                selectors:nil
                receiver:nil.
        p action:[:idx | Transcript showCR:'selected index is '; showCR:idx].
        p showAtPointer
                                                                        [exEnd]


    individual actions:
                                                                        [exBegin]
        |p|
        p := PopUpMenu
                labels:#('foo'
                         'bar'
                         'baz')
                selectors:#(
                            #foo
                            #bar
                            #baz).
        p actionAt:#foo put:[Transcript showCR:'foo'].
        p actionAt:#bar put:[Transcript showCR:'bar'].
        p actionAt:#baz put:[Transcript showCR:'baz'].
        p showAtPointer
                                                                        [exEnd]

    sometimes, you want to specify both selectors and some arguments
    to be sent; this is done by:
                                                                        [exBegin]
        |p|
        p := PopUpMenu
                labels:#('foo' 'bar' 'baz')
                selectors:#(#foo: #bar: #foo:)
                args:#(1 2 3)
                receiver:nil.
        p showAtPointer
                                                                        [exEnd]

    or, the same selector but different arguments:
                                                                        [exBegin]
        |p|
        p := PopUpMenu
                labels:#('foo' 'bar' 'baz')
                selectors:#foo:
                args:#(1 2 3)
                receiver:nil.
        p showAtPointer
                                                                        [exEnd]

    Normally, you do not show the menu explicitely, but install
    it as a either as middleButtonMenu of some view or return it from
    a model. 
    (Views/Controllers button-event handler will show it when the middle
    button is pressed ...)
    Static menu:
                                                                        [exBegin]
        |v m|

        v := View new.
        m := PopUpMenu
                labels:#('lower'
                         'raise'
                         '-'
                         'destroy')
                selectors:#(#lower #raise nil #destroy)
                receiver:v.
        v middleButtonMenu:m.
        v open
                                                                        [exEnd]

    Dynamic menu:
    (since we need some model which responds to a menu-message,
     we use a plug in the example below; normally, this would be your model)
                                                                        [exBegin]
        |v model|

        model := Plug new.
        model respondTo:#getMenu with:[PopUpMenu labels:#('foo' 'bar')
                                                 selectors:#(foo bar)].
        model respondTo:#foo with:[Transcript showCR:'models foo called'].
        model respondTo:#bar with:[Transcript showCR:'models bar called'].

        v := View new.
        v model:model; menu:#getMenu.
        v open
                                                                        [exEnd]

    Dynamic menus are the MVC-way (i.e. ST-80) way of doing things.
    They are usually easier to use, if the menu changes depending on the models
    state. (for example, see the systemBrowsers menus being different when
    things are selected ...)

    It is also possible, to add check-mark entries, with an entry string
    starting with the special sequence '\c' (for check-mark). The value
    passed will be the truth-state of the check-mark.
                                                                        [exBegin]
        |m v|

        v := View new.
        m := PopUpMenu
                labels:#('\c foo'
                         '\c bar')
                selectors:#(#value: #value:)
                receiver:[:v | Transcript show:'arg: '; showCR:v].
        v middleButtonMenu:m.
        v open
                                                                        [exEnd]

    The style of the checkmark can be: check (\c), box (\b) or thumbs (\t):
                                                                        [exBegin]
        |m v|

        v := View new.
        m := PopUpMenu
                labels:#('\c foo'
                         '\b bar'
                         '\t baz')
                selectors:#(#value: #value: #value:)
                receiver:[:v | Transcript show:'arg: '; showCR:v].
        v middleButtonMenu:m.
        v open
                                                                        [exEnd]

    or at the end (looks better with variable fonts):
                                                                        [exBegin]
        |m v|

        v := View new.
        m := PopUpMenu
                labels:#('foo \c'
                         'bar \b'
                         'baz \t')
                selectors:#(#value: #value: #value:)
                receiver:[:v | Transcript show:'arg: '; showCR:v].
        v middleButtonMenu:m.
        v open
                                                                        [exEnd]

    Finally, you can wrap other views into a popup menu (for example,
    to implement menus with icons or other components).
    The view should respond to some messages sent from here (for
    example: #hideSubmenus, #deselectWithoutRedraw and others).
    Currently there is only one class in the system, which can be used
    this way (PatternMenu in the DrawTool demo):
                                                                        [exBegin]
        |v p|

        v := View new.
        p := PatternMenu new.
        p patterns:(Array with:Color red
                          with:Color green
                          with:Color blue).
        v middleButtonMenu:(PopUpMenu forMenu:p).
        v open
                                                                        [exEnd]

    or try:
                                                                        [exBegin]
        |v p|

        v := View new.
        p := PatternMenu new.
        p patterns:(Array with:Color red
                          with:Color green
                          with:Color blue).
        p selectors:#value:.
        p receiver:[:val | v viewBackground:val. v clear].
        p args:(Array with:Color red
                      with:Color green
                      with:Color blue).
        v middleButtonMenu:(PopUpMenu forMenu:p).
        v open
                                                                        [exEnd]

        
    ST-80 style:

    The above menus all did some message send on selection; it is
    also possible, to use Smalltalk-80 style menus (which return some value
    from their startup method):
                                                                        [exBegin]
        |m selection|

        m := PopUpMenu
                labels:#('one' 'two' 'three').
        selection := m startUp.
        Transcript show:'the selection was: '; showCR:selection
                                                                        [exEnd]

    startUp will return the entries index, or 0 if there was no selection.
    You can also specify an array of values to be returned instead of the
    index:
                                                                        [exBegin]
        |m selection|

        m := PopUpMenu
                labels:#('one' 'two' 'three')
                values:#(10 20 30).
        selection := m startUp.
        Transcript show:'the value was: '; showCR:selection
                                                                        [exEnd]

    In ST/X style menus, separating lines between entries are created
    by a '-'-string as its label text (and corresponding nil-entries in the
    selectors- and args-arrays).
    In ST-80, you have to pass the indices of the lines in an extra array:
                                                                        [exBegin]
        |m selection|

        m := PopUpMenu
                labels:#('one' 'two' 'three' 'four' 'five')
                lines:#(2 4).
        selection := m startUp.
        Transcript show:'the value was: '; showCR:selection
                                                                        [exEnd]

    or:
                                                                        [exBegin]
        |m selection|

        m := PopUpMenu
                labels:#('one' 'two' 'three')
                lines:#(2)
                values:#(10 20 30).
        selection := m startUp.
        Transcript show:'the value was: '; showCR:selection
                                                                        [exEnd]

    Use whichever interface you prefer.
"
! !

!PopUpMenu class methodsFor:'instance creation'!

forMenu:aMenuView
    "this wraps an already existing menu - allowing to put any
     view (not just MenuViews) into popups (for example, menus
     with icons, or other components).
     Currently, there is only one example of different menus in
     the system (PatternMenu in the DrawTool) which could be used
     this way.
     The view should respond to some of the menuView messages
     (such as hideSubmenu, deselectWithoutRedraw etc.)"

    |newMenu|

    aMenuView isView ifFalse:[
        self error:'bad argument'
    ].
    newMenu := self onSameDeviceAs:aMenuView. 
    newMenu addSubView:aMenuView.
    newMenu menuView:aMenuView.
    ^ newMenu
!

itemList:itemList resources:resources
    "like labels:selectors:... messages, but expects a single collection,
     containing items row-wise (i.e. elements are themself arrays, consisting of
        label [selector [accelerator [arg]]]
     if resources are non-nil, labels are translated using the translations found there.
    "

    ^ self
        itemList:itemList resources:resources receiver:nil for:nil

    "the sometimes more convenient:
        |p|

        p := PopUpMenu
                itemList:#(('foo' doFoo CtrlF)
                           ('-')
                           ('bar' doBar CtrlB)
                           ('baz' doBaz CtrlZ))
                resources:nil.
        p showAtPointer

     does the same as:
        |p|

        p := PopUpMenu
                labels:#('foo' '-' 'bar' 'baz')
                selectors:#(doFoo nil doBar doBaz)
                accelerators:#(CtrlF nil CtrlB CtrlZ).
        p showAtPointer
    "

!

itemList:itemList resources:resources performer:menuPerformer
    "like labels:selectors:... messages, but expects a single collection,
     containing items row-wise (i.e. elements are themself arrays, consisting of
        label [selector [accelerator [arg]]]
     if resources are non-nil, labels are translated using the translations found there.
    "

    ^ self
        itemList:itemList resources:resources receiver:menuPerformer for:nil

    "Created: / 21.5.1998 / 15:31:42 / cg"
!

itemList:itemList resources:resources performer:menuPerformer for:aView
    "like labels:selectors:... messages, but expects a single collection,
     containing items row-wise (i.e. elements are themself arrays, consisting of
        label [selector [accelerator [arg]]]
     if resources are non-nil, labels are translated using the translations found there.
    "

    |n labels selectors accelerators args anyArg|

    n := itemList size.
    labels := Array new:n.
    selectors := Array new:n.
    accelerators := Array new:n.
    anyArg := false.

    itemList keysAndValuesDo:[:idx :item |
        |label selector accelerator arg|

        label := item at:1.
        labels at:idx put:label.
        item size > 1 ifTrue:[
            selector := item at:2.
            selectors at:idx put:selector.
            item size > 2 ifTrue:[
                accelerator := item at:3.
                accelerators at:idx put:accelerator.
                item size > 3 ifTrue:[
                    arg := item at:4.
                    anyArg ifFalse:[
                        anyArg := true.
                        args := Array new:n.
                    ].
                    args at:idx put:arg.    
                ]
            ]
        ].
    ].

    resources notNil ifTrue:[
        labels := resources array:labels
    ].

    ^ self
        labels:labels
        selectors:selectors
        accelerators:accelerators
        args:args 
        receiver:menuPerformer 
        for:aView

    "this is sometimes more convenient:
        |p|

        p := PopUpMenu
                itemList:#(('foo' doFoo CtrlF)
                           ('-')
                           ('bar' doBar CtrlB)
                           ('baz' doBaz CtrlZ))
                resources:nil.
        p showAtPointer

     and does the same as:
        |p|

        p := PopUpMenu
                labels:#('foo' '-' 'bar' 'baz')
                selectors:#(doFoo nil doBar doBaz)
                accelerators:#(CtrlF nil CtrlB CtrlZ).
        p showAtPointer
    "

    "Created: / 21.5.1998 / 15:32:39 / cg"
!

itemList:itemList resources:resources receiver:menuPerformer for:aView
    "like labels:selectors:... messages, but expects a single collection,
     containing items row-wise (i.e. elements are themself arrays, consisting of
        label [selector [accelerator [arg]]]
     if resources are non-nil, labels are translated using the translations found there.
    "

    ^ self
        itemList:itemList resources:resources performer:menuPerformer for:aView

    "Modified: / 21.5.1998 / 15:33:04 / cg"
!

labels:labels args:args 
    "create and return a menu with label-items and args. 
     The actionBlock has to be defined later"

    ^ self labels:labels selectors:nil accelerators:nil args:args receiver:nil for:nil

    "
     |m|

     m := PopUpMenu labels:#('foo' 'bar')
                      args:#('hello world' 'how about this').
     m action:[:arg |
        Transcript showCR:arg
     ].

     m showAtPointer
    "

    "Modified: 25.5.1996 / 17:01:43 / cg"
!

labels:labels selector:aSelector args:args receiver:anObject
    "create and return a popup menu with labels as entries.
     Each item will send aSelector with a corresponding argument from the
     args array to anObject. The menu is created on the default DIsplay"

    "
     OBSOLETE protocol: #labels:selectors:... knows how to handle single-symbol selectors-arg
    "
    ^ self labels:labels selectors:aSelector accelerators:nil args:args receiver:anObject

    "Modified: 28.2.1996 / 19:01:12 / cg"
!

labels:labels selector:aSelector args:args receiver:anObject for:aView
    "create and return a popup menu with labels as entries.
     Each item will send aSelector with a corresponding argument from the
     args array to anObject. The menu is created on the same physical device
     as aView (which is only of interest in multi-Display applications; 
     typical applications can use the sibbling message without the for: argument)."

    "
     OBSOLETE protocol: #labels:selectors:... knows how to handle single-symbol selectors-arg
    "
    ^ self labels:labels selectors:aSelector accelerators:nil args:args receiver:anObject for:aView

    "Modified: 28.2.1996 / 19:01:29 / cg"
!

labels:labels selectors:selectors 
    "create and return a menu with label-items and selectors. The receiver
     will either be defined later, or not used at all (if opened via startUp)"

    ^ self labels:labels selectors:selectors accelerators:nil args:nil receiver:nil for:nil

    "Modified: 28.2.1996 / 19:01:35 / cg"
!

labels:labels selectors:selectors accelerators:shorties 
    "create and return a menu with label-items and selectors. The receiver
     will either be defined later, or not used at all (if opened via startUp)"

    ^ self labels:labels selectors:selectors accelerators:shorties args:nil receiver:nil for:nil

    "Created: 28.2.1996 / 18:58:52 / cg"
!

labels:labels selectors:selectors accelerators:shorties args:args receiver:anObject
    "create and return a popup menu with labels as entries.
     Each item will send a corresponding selector:argument from the selectors-
     and args array to anObject. The menu is created on the default Display"

    ^ self labels:labels selectors:selectors accelerators:shorties args:args receiver:anObject for:nil

    "Created: 28.2.1996 / 18:59:03 / cg"
!

labels:labels selectors:selectors accelerators:shorties args:args receiver:anObject for:aView
    "create and return a popup menu with labels as entries.
     Each item will send a corresponding selector:argument from the selectors-
     and args array to anObject. The menu is created on the same physical device
     as aView (which is only of interest in multi-Display applications; 
     typical applications can use the sibbling message without the for: argument)."

    |newMenu m|

    newMenu := self onSameDeviceAs:aView. 
    m := (MenuView
            labels:labels
            selectors:selectors
            accelerators:shorties 
            args:args
            receiver:anObject
            in:newMenu).

    m level:0; borderWidth:0.
    newMenu menuView:m.
    ^ newMenu

    "Created: 28.2.1996 / 18:59:25 / cg"
    "Modified: 25.2.1997 / 20:52:47 / cg"
!

labels:labels selectors:selectors accelerators:shorties receiver:anObject
    "create and return a popup menu with labels as entries.
     Each item will send a message with a selector from the corresponding 
     selectors-array.
     The menu is created on the default Display."

    ^ self labels:labels selectors:selectors accelerators:shorties args:nil receiver:anObject for:nil

    "Created: 28.2.1996 / 19:00:49 / cg"
!

labels:labels selectors:selectors args:argArray 
    "create and return a menu with label-items and selectors. The receiver
     will either be defined later, or not used at all (if opened via startUp)"

    ^ self labels:labels selectors:selectors accelerators:nil args:argArray receiver:nil for:nil

    "Modified: 28.2.1996 / 19:01:45 / cg"
!

labels:labels selectors:selectors args:args receiver:anObject
    "create and return a popup menu with labels as entries.
     Each item will send a corresponding selector:argument from the selectors-
     and args array to anObject. The menu is created on the default Display"

    ^ self labels:labels selectors:selectors accelerators:nil args:args receiver:anObject for:nil

    "Modified: 28.2.1996 / 19:01:49 / cg"
!

labels:labels selectors:selectors args:args receiver:anObject for:aView
    "create and return a popup menu with labels as entries.
     Each item will send a corresponding selector:argument from the selectors-
     and args array to anObject. The menu is created on the same physical device
     as aView (which is only of interest in multi-Display applications; 
     typical applications can use the sibbling message without the for: argument)."

    ^ self labels:labels selectors:selectors accelerators:nil args:args receiver:anObject for:aView

    "Modified: 28.2.1996 / 19:03:58 / cg"
!

labels:labels selectors:selectors receiver:anObject
    "create and return a popup menu with labels as entries.
     Each item will send a message with a selector from the corresponding 
     selectors-array.
     The menu is created on the default Display."

    ^ self labels:labels selectors:selectors accelerators:nil args:nil receiver:anObject for:nil

    "Modified: 28.2.1996 / 19:02:07 / cg"
!

labels:labels selectors:selectors receiver:anObject for:aView
    "create and return a popup menu with labels as entries.
     Each item will send a corresponding selector from the selectors-array
     to anObject. The menu is created on the same physical device
     as aView (which is only of interest in multi-Display applications; 
     typical applications can use the sibbling message without the for: argument)."

    ^ self labels:labels selectors:selectors accelerators:nil args:nil receiver:anObject for:aView

    "Modified: 28.2.1996 / 19:02:10 / cg"
! !

!PopUpMenu class methodsFor:'ST-80 instance creation'!

labelArray:labels
    "ST80R4 compatibility"

    ^ self labels:labels lines:nil values:nil

    "
     (PopUpMenu labelArray:#('one' 'two' 'three')) startUp 
    "
!

labelArray:labels lines:lines values:values 
    "ST80R4 compatibility"

    ^ self labels:labels lines:lines values:values 
!

labelArray:labels values:values 
    "ST80R4 compatibility"

    ^ self labels:labels lines:nil values:values 
!

labelList:labels 
    "ST80R4 compatibility:
	given a list consisting of group label entries (to be separated by
	lines), convert into standard form (using '-' for lines.
    "

    ^ self labelList:labels values:nil

    "
     (PopUpMenu labels:#('1' '2' '3')) showAtPointer
     (PopUpMenu labelList:#(('1') ('2' '3'))) showAtPointer    
     (PopUpMenu labelList:#(('1') ('2') ('3'))) showAtPointer    
    "
!

labelList:labels lines:lines values:values 
    "mhmh what is that ?"

    ^ (self new) labels:labels lines:lines values:values 
!

labelList:labels values:values 
    "ST80R4 compatibility:
	given a list consisting of group label entries (to be separated by
	lines), convert into standard form (using '-' for lines.
    "

    |newLabels newValues lS vS first|

    newLabels := OrderedCollection new.
    newValues := OrderedCollection new.
    lS := ReadStream on:labels.
    values notNil ifTrue:[vS := ReadStream on:values].
    first := true.
    [lS atEnd] whileFalse:[
	|entry|

	entry := lS next.
	entry isCollection ifTrue:[
	    first ifFalse:[
		newLabels add:'-'.
		values notNil ifTrue:[newValues add:nil]
	    ].
	    newLabels addAll:entry.
	    values notNil ifTrue:[newValues addAll:(vS next:entry size)]
	] ifFalse:[
	    newLabels add:entry.
	    values notNil ifTrue:[newValues add:(vS next)]
	].
	first := false.
    ].
    values isNil ifTrue:[
	^ self labels:newLabels
    ].
    ^ self labels:newLabels values:newValues

    "
     (PopUpMenu labels:#('1' '2' '3') values:#(1 2 3)) showAtPointer
     (PopUpMenu labelList:#(('1') ('2' '3')) values:#(1 2 3)) showAtPointer    
     (PopUpMenu labelList:#(('1') ('2') ('3')) values:#(1 2 3)) showAtPointer    
    "
!

labels:labels 
    "ST80R2 compatibility"

    ^ self labels:labels lines:nil values:nil 
!

labels:labels lines:lines 
    "ST80R2 compatibility"

    ^ self labels:labels lines:lines values:nil
!

labels:labels lines:lines values:values 
    "ST80R2 compatibility"

    ^ (self new) labels:labels lines:lines values:values 
!

labels:labels values:values 
    "ST80R2 compatibility"

    ^ self labels:labels lines:nil values:values 
! !

!PopUpMenu class methodsFor:'defaults'!

maxClickTimeToStayOpen
    ^ 200  "/ if button is pressed shorter, its a click and the menu stays open.
           "/ otherwise, its a press and the menu hides itself with the release
! !

!PopUpMenu methodsFor:'ST-80 activation'!

startUp
    "start the menu modal - return the selected value,
     or - if no values where specified - return the index.
     If nothing was selected, return 0.
     Modal - i.e. stay in the menu until finished.
     This is the ST-80 way of launching a menu."

    ^ self startUpAt:nil

    "
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')) startUp 
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')
                                  values:#(foo bar baz)) startUp
    "

    "Modified: 10.1.1996 / 20:16:40 / cg"
!

startUpAt:aPoint
    "start the menu modal - return the selected value,
     or - if no values where specified - return the index.
     If nothing was selected, return 0.
     Modal - i.e. stay in the menu until finished.
     This is the ST-80 way of launching a menu."

    ^ self startUpAt:aPoint ifNoneSelected:0

    "
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')) startUp 
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')
                                  values:#(foo bar baz)) startUp
    "

!

startUpAt:aPoint ifNoneSelected:defaultReturnValue
    "start the menu modal - return the selected value,
     or - if no values where specified - return the index.
     If nothing was selected, return defaultReturnValue.
     Modal - i.e. stay in the menu until finished.
     This is the ST-80 way of launching a menu."

    |return rec sel0 sel1 arg myAction|

    return := defaultReturnValue.
    actionValues notNil ifTrue:[
        return := nil
    ].
"/    menuView args notNil ifTrue:[
"/        return := nil
"/    ].

    "/
    "/ arrange for the menu to evaluate this action,
    "/ instead of directly sending any messages to the menuReceiver.
    "/ (which used to be the ST/X way, menus worked).
    "/ This works better with menuPerformers - which were not
    "/ supported when ST/X menus were originally written.
    "/ The old ST/X mechanism may vanish.
    "/

    menuView action isNil ifTrue:[
        myAction := true.
        menuView action:[:menuView :selected |
            |actionIndex value sel retVal selIdx
             args selectors checkFlags check|

            menuView action:nil.  "/ must clear it ...  
            retVal := 0.
            actionValues notNil ifTrue:[
                retVal := nil
            ].

            selected isNil ifTrue:[
                "/ the menu has already sent a message or performed an item-action; do nothing here
                retVal
            ] ifFalse:[
                selIdx := menuView selection.

                args := menuView args.
                selectors := menuView selectors.
                checkFlags := menuView checkFlags.

                args isNil ifTrue:[
                    selectors notNil ifTrue:[
                        sel0 := selectors at:selIdx.
                    ].
                ] ifFalse:[
                    actionIndex := selected.
                    actionIndex notNil ifTrue:[
                        actionValues isNil ifTrue:[
                            selectors notNil ifTrue:[
                                "/ mhmh an ST/X menu started the ST-80 way

                                sel1 := selectors at:selIdx.
                                arg := actionIndex.
                            ] ifFalse:[
                                retVal := actionIndex
                            ]
                        ] ifFalse:[
                            retVal := actionValues at:actionIndex.
                            (retVal isKindOf:PopUpMenu) ifTrue:[
                                retVal := retVal startUp
                            ]
                        ]
                    ] ifFalse:[
                        "/ mhmh an ST/X menu started the ST-80 way

                        selectors notNil ifTrue:[
                            sel0 := selectors at:selIdx.
                        ].
                    ]
                ].

                checkFlags notNil ifTrue:[
                    check := checkFlags at:selIdx.
                    check notNil ifTrue:[
                        arg := check.
                        sel1 := sel0.
                        sel0 := nil.
                    ]
                ].
                return := retVal.

                menuView action:nil
            ]
        ]
    ].

    aPoint isNil ifTrue:[
        self showAt:(device pointerPosition) resizing:true
    ] ifFalse:[
        self showAt:aPoint.
    ].
    myAction == true ifTrue:[menuView action:nil].

    "/ 
    "/ mhmh an ST/X menu started the ST-80 way
    "/
    (sel0 notNil or:[sel1 notNil]) ifTrue:[
        rec := menuView receiver.
        sel0 notNil ifTrue:[
            ^ sel0
        ].
        ^ Array with:sel1 with:arg.
    ].
    ^ return

    "
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')) startUp 
     Transcript showCR:(PopUpMenu labels:#('foo' 'bar' 'baz')
                                  values:#(foo bar baz)) startUp
    "

    "Created: / 10.1.1996 / 20:11:42 / cg"
    "Modified: / 20.5.1998 / 22:39:03 / cg"
!

startUpFor:originatingWidget
    ^ self startUp
!

startUpOrNil
    "start the menu modal - return the selected value,
     or - if no values where specified - return the index.
     If nothing was selected, return nil.
     Modal - i.e. stay in the menu until finished.
     This is the ST-80 way of launching a menu."

    ^ self startUpAt:nil ifNoneSelected:nil

!

startUpWithHeading:aString
    "start the menu modal - return the selected value,
     or - if no values where specified - return the index.
     If nothing was selected, return 0.
     Modal - i.e. stay in the menu until finished.
     This is the ST-80 way of launching a menu."

    |vector|

    defaultHideOnRelease := false.
    (vector := menuView labels) notNil ifTrue:[
        menuView labels:(Array with:aString with:'=') , vector.
    ].
    (vector := menuView selectors) notNil ifTrue:[
        menuView selectors:#(nil nil) , vector.
    ].
    (vector := menuView args) notNil ifTrue:[
        menuView args:#(nil nil) , vector.
    ].
    (vector := menuView checkFlags) notNil ifTrue:[
        menuView checkFlags:#(nil nil) , vector.
    ].
    (vector := menuView actions) notNil ifTrue:[
        menuView actions:#(nil nil) , vector.
    ].
    menuView disable:1; disable:2.

    ^ self startUp.

    "
     (PopUpMenu
        labels:#('foo' 'bar'))
        startUp
    "
    "
     (PopUpMenu
        labels:#('foo' 'bar'))
        startUpWithHeading:'hello'
    "
! !

!PopUpMenu methodsFor:'accessing-behavior'!

hideOnKeyFilter:aBlock
    "set a filter, which determines if a key should lead to closing the menu."

    hideOnKeyFilter := aBlock
!

hideOnLeave:aBoolean
    "set/clear the hideOnLeave attribute, which controls
     if the menu should be hidden when the pointer leaves
     the view (used with multiple-menus)"

    hideOnLeave := aBoolean
!

hideOnRelease:aBoolean
    "set/clear the hideOnRelease attribute, which controls
     if the menu should be hidden when the button is released"

    defaultHideOnRelease := aBoolean.
    menuView hideOnRelease:aBoolean

    "Modified: 9.2.1996 / 02:06:15 / cg"
!

isEnabled:indexOrName
    "return true, if the item at anIndexOrName is enabled"

    ^ menuView isEnabled:indexOrName
!

memorizeLastSelection:index
    "normally, a popup menu comes up unselected, even if reused.
     This can be used to arrange for an initial selection to be shown"

    lastSelection := index.
    memorize := true.
! !

!PopUpMenu methodsFor:'accessing-items'!

addItem:anItem
    menuView addItem:anItem
!

atMenuItemLabeled:aString putSubmenu:aMenu visible:visible
    |idx|

    idx := self indexOf:aString.
    idx notNil ifTrue:[
        visible ifTrue:[
            self subMenuAt:aString put:(aMenu asOldStylePopUpMenuFor:self application).
        ].
    ].

    "Created: / 30-06-2011 / 10:28:57 / cg"
!

hasItems
    "return true, if I have items"

    ^ menuView notNil and:[ menuView hasItems ]
!

indexOf:indexOrName
    "return the index of a submenu - or 0 if there is none"

    ^ menuView indexOf:indexOrName
!

labels
    "return the list of labels"

    actionLabels notNil ifTrue:[
	^ actionLabels asStringCollection
    ].
    ^ menuView list
!

labels:labelString lines:lineArrayArg values:valueArray
    "define the menu the ST-80 way (with labels and lines defined separately)"

    |lineArray labelArray argArray convertedLabels 
     offs dstOffs linePos m|

    lineArray := lineArrayArg.
    (lineArray notNil and:[lineArray first]) == 0 ifTrue:[
        lineArray := lineArray copyFrom:2.
    ].

    actionLabels := labelString.
    actionLines := lineArray.
    actionValues := valueArray.

    labelArray := labelString asStringCollection.

    convertedLabels := Array new:(labelArray size + lineArray size).
    argArray := Array new:(labelArray size + lineArray size).

    offs := 1.
    dstOffs := 1.
    1 to:lineArray size do:[:lineIndex |
        linePos := lineArray at:lineIndex.
        [offs <= linePos] whileTrue:[
            convertedLabels at:dstOffs put:(labelArray at:offs).
            argArray at:dstOffs put:offs.
            offs := offs + 1.
            dstOffs := dstOffs + 1
        ].
        convertedLabels at:dstOffs put:'-'.
        argArray at:dstOffs put:nil.
        dstOffs := dstOffs + 1
    ].
    [offs <= labelArray size] whileTrue:[
        convertedLabels at:dstOffs put:(labelArray at:offs).
        argArray at:dstOffs put:offs.
        offs := offs + 1.
        dstOffs := dstOffs + 1
    ].

    m := MenuView
            labels:convertedLabels
            selectors:nil
            args:argArray
            receiver:nil 
            in:self.
    m level:0; borderWidth:0.
    self menuView:m

    "Modified: 2.4.1997 / 15:57:52 / cg"
!

lines
    "st-80 compatibility"

    ^ actionLines
!

menuAt:indexOrName
    "return the submenu for entry indexOrName."

    ^ self subMenuAt:indexOrName

    "Created: 24.3.1996 / 17:11:05 / cg"
!

numberOfItems
    "return the number of items in the menu"

    actionLabels notNil ifTrue:[
	^ actionLabels asStringCollection size
    ].
    ^ menuView list size
!

remove:indexOrName
    "remove a menu entry"

    menuView remove:indexOrName
!

subMenuAt:indexOrName
    "return the submenu for entry indexOrName"

    ^ menuView subMenuAt:indexOrName

    "Created: 24.3.1996 / 17:09:15 / cg"
!

subMenuAt:indexOrName put:aMenu
    "define a submenu to be shown for entry indexOrName"

"
    aMenu hideOnLeave:true.
"
    menuView subMenuAt:indexOrName put:aMenu.
    (aMenu notNil and:[aMenu isBlock not]
    ) ifTrue:[
        "tell the submenu to notify me when action is performed"
        aMenu superMenu:self.
    ].

    "
     |v m someObject|

     v := View new.
     m := PopUpMenu labels:#('1' '2' '3')
                 selectors:#(one two nil)
                  receiver:someObject 
                       for:nil.
     m subMenuAt:3 put:(PopUpMenu
                             labels:#('a' 'b' 'c')
                          selectors:#(a b c)
                           receiver:someObject 
                                for:nil).
     v middleButtonMenu:m.
     v realize
    "
!

values
    "st-80 compatibility"

    ^ actionValues
!

values:aValueArray
    "st-80 compatibility"

    actionValues := aValueArray
! !

!PopUpMenu methodsFor:'accessing-look'!

font:aFont
    "set the menus font.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    preferredExtent := nil.
    menuView font:aFont

    "Modified: 22.5.1996 / 12:36:53 / cg"
!

viewBackground:aColor
    "this is a kludge and will vanish ..."

    super viewBackground:aColor.
    menuView viewBackground:aColor
! !

!PopUpMenu methodsFor:'accessing-mvc'!

changeMessage
    "set the changeMessage from my menu"

    ^ menuView changeMessage

    "Modified: 5.6.1996 / 17:08:52 / cg"
!

changeMessage:aSymbol
    "set the changeMessage - forward to my menu"

    menuView changeMessage:aSymbol

    "Modified: 5.6.1996 / 17:08:41 / cg"
!

menuPerformer
    "get the menuPerformer - forwarded to my menuViews"

    ^ menuView menuPerformer

    "Modified: 5.6.1996 / 17:08:30 / cg"
    "Created: 21.1.1997 / 15:40:22 / cg"
!

menuPerformer:someone
    "set the menuPerformer - forwarded to my menuViews"

    menuView menuPerformer:someone

    "Modified: 5.6.1996 / 17:08:30 / cg"
    "Created: 21.1.1997 / 15:40:14 / cg"
!

model 
    "return my menuViews model"

    ^ menuView model

    "Modified: 5.6.1996 / 14:16:53 / cg"
!

model:aModel
    "set the model - forwarded to my menuViews"

    menuView model:aModel

    "Modified: 5.6.1996 / 17:08:30 / cg"
! !


!PopUpMenu methodsFor:'deactivation'!

hide
    "hide the menu - if there are any pop-up-submenus, hide them also"

    menuView hideSubmenu.
    super hide.
    (self isOpenedAsSubmenu) ifTrue:[
        menuView superMenu regainControl
    ].

    "Modified: 25.2.1997 / 22:11:53 / cg"
!

hideForAction
    "hide the menu - if there are any pop-up-submenus, hide them also.
     Any superMenu is not asked to regain control, since we are going to
     hide them also."

    menuView hideSubmenu.
    super hide.
! !

!PopUpMenu methodsFor:'dummy'!

findGuiResourcesIn:aResourceContainerOrApplication
    "dummy - for compatibility with MenuPanel (in case an old-style
     PopUpMenu us returned from a menu message)
    "


! !

!PopUpMenu methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |p sensor|

    "/ state == 0 ifTrue:[^ self].

    (sensor := self sensor) isNil ifTrue:[^ self].
    (sensor hasButtonMotionEventFor:self) ifTrue:[^ self].

    "any-button ?"
    "/ sensor anyButtonPressed ifFalse:[^ self].

    ((x >= 0) 
    and:[x < width
    and:[y >= 0
    and:[y < height]]]) ifTrue:[
        "/ inside me

        (x >= margin 
        and:[x < (width-margin)
        and:[y >= margin
        and:[y < (height-margin)]]]) ifTrue:[
            "/ inside my menuView
            hideOnRelease := true.
            p := device 
                    translatePoint:(x @ y)
                    fromView:self
                    toView:menuView.
        
            menuView buttonMotion:state x:p x y:p y.
        ].
        ^ self
    ].

    "outside of myself"
    (self isOpenedAsSubmenu) ifTrue:[
        p := device 
                translatePoint:(x @ y)
                fromView:self
                toView:(menuView superMenu).
        p notNil ifTrue:[
            menuView superMenu buttonMotion:state x:p x y:p y
        ]
    ].

    menuView subMenuShown isNil ifTrue:[
        menuView pointerLeave:state.
    ].

    hideOnLeave ifTrue:[
        self hide
    ].

    "Modified: / 28-07-2007 / 13:14:12 / cg"
!

buttonPress:button x:x y:y
    hideOnRelease := true.

    ((x >= 0) and:[x < width]) ifTrue:[
        ((y >= 0) and:[y < height]) ifTrue:[
            menuView buttonPress:button x:x y:y.
            ^ self
        ]
    ].

    "Modified: 22.1.1997 / 17:38:14 / cg"
!

buttonRelease:button x:x y:y
    |h|

    realized ifFalse:[^ self].

    "/
    "/ detect short click - stay open if this is one
    "/
    h := hideOnRelease.
    (OperatingSystem 
        millisecondTimeDeltaBetween:(Time millisecondClockValue)
                                and:mapTime) > (self class maxClickTimeToStayOpen) ifFalse:[
        hideOnRelease := false.
    ].

    hideOnRelease ifFalse:[
        ^ self
    ].

    (x < 0 
    or:[x >= width
    or:[y < 0
    or:[y >= height]]]) ifTrue:[
         "/   
         "/ released outside of mySelf
         "/
        (self isOpenedAsSubmenu) ifTrue:[
            menuView superMenu hideSubmenu
        ] ifFalse:[
            self hide
        ].
        ^ self
    ].


"/    menuView superMenu notNil ifTrue:[
"/        menuView superMenu submenuTriggered 
"/    ].

    menuView buttonRelease:button x:x y:y.

    "Modified: 8.3.1996 / 14:17:18 / cg"
!

keyPress:key x:x y:y
    <resource: #keyboard (#Tab)>

    hideOnKeyFilter notNil ifTrue:[
        (hideOnKeyFilter value:key) ifTrue:[
            self hide.
            ^ self.
        ].
    ].

    key == #Tab ifTrue:[
        self hide.
        super keyPress:key x:x y:y.
        ^ self.
    ].

    x == 0 ifTrue:[
        menuView keyPress:key x:nil y:nil.
    ] ifFalse:[
        x notNil ifTrue:[
            "/ already redelegated
            menuView keyPress:key x:x y:y.
        ].
    ].

    "Modified: / 6.12.1997 / 01:53:08 / cg"
!

mapped
    super mapped.

    "/
    "/ check if a button is pressed when mapped;
    "/ if not, change my hide-strategy
    "/

"/    device buttonStates == 0 ifTrue:[
"/        hideOnRelease := false
"/    ].

    "Created: 9.2.1996 / 19:56:20 / cg"
    "Modified: 8.3.1996 / 13:42:15 / cg"
!

pointerEnter:state x:x y:y
    "catch quick release of button"

    hideOnLeave ifTrue:[
        state == 0 ifTrue:[
            self hide
        ].
    ]
!

pointerLeave:state
"/    menuView pointerLeave:state.
"/    hideOnLeave ifTrue:[
"/        self hide
"/    ].
"/    menuView superMenu notNil ifTrue:[
"/        menuView superMenu regainControl
"/    ]
! !

!PopUpMenu methodsFor:'initialization'!

initEvents
    super initEvents.
    self enableEnterLeaveEvents.
    self enableMotionEvents.

    "Modified: 7.3.1996 / 14:17:42 / cg"
!

initStyle
    <resource: #style (#'popup.hideOnRelease'
                       #'popup.level'
"/                       #'popup.borderWidth'
"/                       #'popup.borderColor'
                       )>

    |lvl bw bc|

    super initStyle.

    (lvl := styleSheet at:#'popup.level') notNil ifTrue:[
        self level:lvl.
    ].
"/    (bw := styleSheet at:#'popup.borderWidth') notNil ifTrue:[
"/        self borderWidth:bw
"/    ].
"/    (bc := styleSheet at:#'popup.borderColor') notNil ifTrue:[
"/        self borderColor:bc
"/    ].
    defaultHideOnRelease := styleSheet at:#'popup.hideOnRelease' default:true.
!

initialize
    super initialize.

    memorize := true.
    hideOnLeave := false.
! !

!PopUpMenu methodsFor:'menuview messages'!

doesNotUnderstand:aMessage
    "forward all menu-view messages"

    (menuView respondsTo:(aMessage selector)) ifTrue:[
	^ aMessage sendTo:menuView
    ].
    ^ super doesNotUnderstand:aMessage
!

regainControl
|g|
    ((g := device activePointerGrab) ~~ self) ifTrue:[
        self forceUngrabPointer.
        self forceUngrabKeyboard.
        shown ifTrue:[
            self grabPointer.
            self grabKeyboard.
        ]
    ].

    "Modified: / 20.11.1997 / 00:32:32 / cg"
    "Modified: / 2.2.1998 / 23:52:28 / stefan"
! !

!PopUpMenu methodsFor:'private-accessing'!

isOpenedAsSubmenu
    "return true, if I have been opened as a submenu of some other
     menu."

    |superMenu|

    superMenu := menuView superMenu.
    "/ check for realized, because the CTRL/SHIFT menus of a textView
    "/ are opened as top-menu AND have a non-nil supermenu.
    "/ thus asking for supermenu being nonNil is NOT a sufficient indicator for
    "/ being an open submenu !!
    ^ superMenu notNil and:[superMenu realized]
!

menu:aMenuView
    "set the actual menu"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #menuView:'.
    self menuView:aMenuView

    "Modified: 25.2.1997 / 20:52:08 / cg"
!

menuView
    "return the actual menu"

    ^ menuView
!

menuView:aMenu
    "set the actual menu"

    menuView := aMenu.
    menuView origin:(margin @ margin).
    menuView borderWidth:0.
    menuView masterView:self

    "Created: 25.2.1997 / 20:51:42 / cg"
!

superMenu:aMenu
    "set the superMenu"

    menuView superMenu:aMenu

    "Modified: 25.2.1997 / 20:52:20 / cg"
! !

!PopUpMenu methodsFor:'realization'!

fixSize
    "called right before the view is made visible.
     adjust my size to the size of the actual menu"

    |extra newWidth newHeight|

    extra := margin * 2.
    menuView resizeIfChanged.
    newWidth := menuView width + extra.
    newHeight := menuView height + extra.
    ((newWidth ~~ width) or:[newHeight ~~ height]) ifTrue:[
        self extent:(newWidth @ newHeight)
    ].
    super fixSize
!

realize
    (memorize == true and:[lastSelection notNil]) ifTrue:[
        menuView setSelection:lastSelection.
    ] ifFalse:[
        menuView deselectWithoutRedraw.
    ].
    super realize.
    hideOnRelease := defaultHideOnRelease.
! !

!PopUpMenu class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

