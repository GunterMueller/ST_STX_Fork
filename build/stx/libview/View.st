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
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#View
	instanceVariableNames:'model aspectMsg changeMsg menuMsg menuHolder menuPerformer
		enableChannel foregroundChannel backgroundChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!View class methodsFor:'documentation'!

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
    this class adds provisions for views which show or work on a model.
    This functionality used to be in View, but has been extracted into SimpleView and
    this new View class, to take some of the stuff out of views which do not need
    this functionality (i.e. all views which do only geometry management).
    Instances of View are seldom used, most views in the system inherit 
    from this class. 

    [Instance variables:]
        model           <nil | any>         the model (if any)

        aspectMsg       <nil | Symbol>      the aspect; typically
                                            dependentViews react on changes
                                            of this aspect and update their contents.

        changeMsg       <nil | Symbol>      the changeMessage; typically
                                            dependentViews send this message to
                                            the model to tell it about changes.

        menuMsg         <nil | Symbol>      the menuMessage; typically
                                            dependentViews send this message to
                                            the model to ask for a popup menu.


        menuHolder      <any>               who has a menu 
                                            (default: nil i.e. model has menu)

        menuPerformer   <any>               who performs menu actions
                                            (default: nil i.e. model has menu)

    [see also:]
        StandardSystemView TopView DialogBox
        WindowGroup
        Model ValueHolder
        ( introduction to view programming :html: programming/viewintro.html )
        

    [author:]
        Claus Gittinger
"
!

examples
"
    a subView in a topView:
                                                                        [exBegin]
        |top v|

        top := StandardSystemView new.
        v := View new.
        v origin:0.25 @ 0.25 corner:0.75 @ 0.75.
        top addSubView:v.
        top open
                                                                        [exEnd]


    the same, a bit more compact:
                                                                        [exBegin]
        |top v|

        top := StandardSystemView new.
        v := View origin:0.25 @ 0.25 corner:0.75 @ 0.75 in:top.
        top open
                                                                        [exEnd]

    menuHolder
                                                                        [exBegin]
        |top mh|

        mh := (PopUpMenu itemList:#( ('foo' foo) (#'bar' bar)) resources:nil) asValue.

        top := StandardSystemView extent:200@200.
        top menuHolder:mh.
        top open
                                                                        [exEnd]


    menuHolder
                                                                        [exBegin]
        |top mh|

        mh := (PopUpMenu itemList:#( ('foo' foo) (#'bar' bar)) resources:nil) asValue.
        [
            Delay waitForSeconds:5.
            mh value: (PopUpMenu itemList:#( ('waboo' foo) (#'baz' bar)) resources:nil)
        ] fork.

        top := StandardSystemView extent:200@200.
        top menuHolder:mh.
        top open
                                                                        [exEnd]

"
! !

!View class methodsFor:'instance creation'!

on:aModel aspect:aspectMsg
    "st-80 style view creation: create a new view, set its model
     and selectors for aspect"

    ^ self new 
	on:aModel
	aspect:aspectMsg
!

on:aModel aspect:aspectMsg change:changeMsg
    "st-80 style view creation: create a new view, set its model
     and selectors for aspect and change"

    ^ self new 
	on:aModel
	aspect:aspectMsg
	change:changeMsg
!

on:aModel aspect:aspectMsg change:changeMsg menu:menuMsg
    "st-80 style view creation: create a new view, set its model
     and selectors for aspect, change and menu"

    ^ self new 
	on:aModel
	aspect:aspectMsg
	change:changeMsg
	menu:menuMsg
!

on:aModel aspect:aspectMsg menu:menuMsg
    "st-80 style view creation: create a new view, set its model
     and selectors for aspect and menu"

    ^ self new 
	on:aModel
	aspect:aspectMsg
	menu:menuMsg
! !

!View class methodsFor:'defaults'!

defaultAspectMessage   
    "subclasses which by default do NOT want to be informed about changed
     models should redefine this to return nil"

    ^ #value
!

defaultChangeMessage   
    "subclasses which by default do NOT want to inform the model
     should redefine this to return nil"

    ^ #value:
!

defaultMenuMessage   
    "subclasses which by default do NOT want to send menu messages
     should return nil"

    ^ nil

    "Created: 3.1.1997 / 01:50:36 / stefan"
! !

!View methodsFor:'accessing-bg & border'!

allViewBackground:something if:condition
    "set the viewBackground to something, a color, image or form,
     in myself and recursively in all of my subviews.
     However, if I have a backgroundChannel, don't change my own bg."

    backgroundChannel isNil ifTrue:[
        ^ super allViewBackground:something if:condition
    ].

    self allSubViewsBackground:something if:condition
! !

!View methodsFor:'accessing-channels'!

backgroundChannel 
    "return a valueHolder for background color"

    ^ backgroundChannel

    "Modified: / 30.3.1999 / 13:49:28 / stefan"
    "Created: / 30.3.1999 / 13:50:55 / stefan"
!

backgroundChannel:aValueHolder
    "set the backgroundChannel - a valueHolder holding a color"

    |prev|

    prev := backgroundChannel.
    backgroundChannel := aValueHolder.
    self setupChannel:aValueHolder for:#backgroundColorChanged withOld:prev

    "Modified: / 31.10.1997 / 14:38:38 / cg"
    "Created: / 30.3.1999 / 13:48:42 / stefan"
!

enableChannel 
    "return a valueHolder for enable/disable"

    ^ enableChannel

    "Created: / 30.3.1999 / 13:46:43 / stefan"
!

enableChannel:aValueHolder 
    "set the valueHolder, which holds the enable boolean value"

    |prev|

    prev := enableChannel.
    enableChannel := aValueHolder.
    self setupChannel:aValueHolder for:#enableStateChanged withOld:prev

    "Modified: / 14.11.1997 / 13:52:44 / cg"
    "Modified: / 30.3.1999 / 13:50:15 / stefan"
!

foregroundChannel 
    "return a valueHolder for foreground color"

    ^ foregroundChannel

    "Modified: / 30.3.1999 / 13:49:28 / stefan"
!

foregroundChannel:aValueHolder
    "set the foregroundChannel - a valueHolder holding a color"

    |prev|

    prev := foregroundChannel.
    foregroundChannel := aValueHolder.
    self setupChannel:aValueHolder for:#foregroundColorChanged withOld:prev

    "Modified: / 31.10.1997 / 14:38:38 / cg"
    "Modified: / 30.3.1999 / 13:50:08 / stefan"
! !

!View methodsFor:'accessing-menus'!

menuHolder
    "who has the menu ? 
     If no explicit menuHolder was defined, its the model if I have one.
     Otherwise, its the menuHolder (if nonNil) or mySelf.
     The menuHolder is supposed to return a popUpMenu when asked via the
     menuMessage."

    menuHolder notNil ifTrue:[^ menuHolder].
    model notNil ifTrue:[^ model].
    ^ self

    "Modified: 23.12.1996 / 13:56:55 / cg"
!

menuHolder:anObject
    "change the one that provides the menu (via menuMsg)."

    menuHolder := anObject.
    menuMsg isNil ifTrue:[menuMsg := #value].

    "Created: 23.12.1996 / 13:54:33 / cg"
!

menuMessage
    "Return the symbol sent to the model to acquire the menu"

    ^ menuMsg
!

menuMessage:aSymbol
    "ST-80 style menus: If a views menuSymbol is nonNil, it
     will send it to its model when the middleButton is pressed.
     That method should return nil or the menu to be shown.
     This is useful for very dynamic menus, where it does not
     make sense to define an initial menu.
     This is the same as #menu: which was added for ST-80 compatibility."

    menuMsg := aSymbol
!

menuPerformer
    "who should perform the menu actions ? 
     If no menuPerformer was defined, its the model if I have one.
     Otherwise its the menuPerformer (if nonNil), or myself.
     The menuPerformer get messages from the menu"

    menuPerformer notNil ifTrue:[^ menuPerformer].

    "/ the stuff below tries to make for a reasonable
    "/ default, in case the menuPerformer was NOT set explicitely
    "/ (you should not depend on this in your application)
    (model isNil 
    or:[model isValueModel
    or:[model isBlock]]) ifTrue:[
        "/ a simple holder-model. don't send menuMessages to it
        ^ self application ? self
    ].
    ^ model
!

menuPerformer:anObject
    "change the one that does the menu actions.
     See the comment in SimpleView>>activateMenu on who gets the menus
     message."

    menuPerformer := anObject

    "
     |top textV plug|

     plug := Plug new.
     plug respondTo:#textMenu
               with:[ |m|
                        m := PopUpMenu
                                  labels:#('copy' 'foo' '-' 'others')
                                  selectors:#(copySelection foo nil others).
                        m subMenuAt:#others
                                put:(PopUpMenu 
                                        labels:#('bar' 'goto')
                                        selectors:#(bar gotoLine))        
                    ].

     top := StandardSystemView new.
     top extent:300@300.

     textV := TextView origin:0.0@0.0 corner:1.0@1.0 in:top.
     textV menuHolder:plug; menuMessage:#textMenu; menuPerformer:plug.
     textV contents:'hello world'.
     top open.
    "

    "Created: 23.12.1996 / 13:57:28 / cg"
!

performer:anObject
    "same as #menuPerformer - ST80 compatibility"

    self menuPerformer:anObject

    "Created: / 6.7.1998 / 13:38:32 / cg"
! !

!View methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    "this adds entries for all messages sent to my model
     to aDictionary"

    aDictionary at:#aspectMessage put:aspectMsg.
    aDictionary at:#changeMessage put:changeMsg.
    aDictionary at:#menuMessage put:menuMsg.

    "
     Button new modelInterface 
    "
!

aspect
    "Return the aspect used with changes from/to the model"

    ^ aspectMsg
!

aspectMessage
    "Return the aspect used with changes from/to the model"

    ^ aspectMsg
!

aspectMessage:aspectSymbol
    "ST-80 style updating: If a views aspectSymbol is nonNil, 
     it will respond to changes of this aspect from the model."

    aspectMsg := aspectSymbol
!

change:changeSymbol
    "ST-80 style change notification: If a views changeSymbol is nonNil, 
     it will send it to its model when something changes.
     Alias for changeMessage: for ST-80 compatibility."

    self changeMessage:changeSymbol
!

changeMessage
    "Return the symbol sent to the model if nonNil when something changes."

    ^ changeMsg
!

changeMessage:aSymbol
    "ST-80 style change notification: If a views changeSymbol is nonNil, 
     it will send it to its model when something changes.
     This is the same as change: which was added for ST-80 compatibility."

    changeMsg := aSymbol
!

controller:aController
    "set the controller"

    super controller:aController.
    controller notNil ifTrue:[
	controller model:model
    ]
!

menu:menuSymbol
    "ST-80 style menus: If a views menuSymbol is nonNil, it
     will send it to its model when the middleButton is pressed.
     That method should return nil or the menu to be shown.
     This is useful for very dynamic menus, where it does not
     make sense to define an initial menu.
     Alias for #menuMessage:, for ST-80 compatibility."

    menuMsg := menuSymbol
!

model
    "return the model, for non-MVC views,
     this is nil or the receiver"

    ^ model
!

model:aModel
    "Set the model.
     Here, if I am my own menuPerformer/menuHolder,
     set the menuHolder and menuPerformer to the model. 
     This is a compatibility kludge,
     since typically, ST-80 code expects the model to provide a menu
     and perform it. If the model does not support a menu message,
     it will be forwarded to the view.
     Those apps which want the view to provide the (default) menu have to reset
     this by sending #menuHolder: message (again)"

    model notNil ifTrue:[
        model removeDependent:self
    ].
    model := aModel.

    "/ ST80 kludge start
    (menuPerformer == self 
    and:[menuHolder == self
    and:[model isValueModel not]]) ifTrue:[
        menuPerformer := menuHolder := model
    ].
    "/ ST80 kludge end.

    model notNil ifTrue:[
        aModel addDependent:self
    ].
    controller notNil ifTrue:[
        controller model:aModel
    ].

    "Modified: 28.2.1997 / 19:23:06 / cg"
!

modelInterface
    "this returns a dictionary of messages sent to my model.
     It can be used for builders and wrappers to get information
     about the messages sent to my model.
     The returned dictionary contains one entry for each get-Msg,
     and the receiver will implement corresponding messages (with a colon)
     to set the message symbol."

    |d|

    d := IdentityDictionary new.
    self addModelInterfaceTo:d.
    ^ d

    "
     Button new modelInterface
     Label new modelInterface 
    "

    "
     does the view support setting the menuMessage ?

     SelectionInListView new modelInterface includesKey:#menuMessage 
    "

    "
     turn off all interaction to the model:

     |m v if|

     m := SelectionInList new.
     m list:#('one' 'two' 'tree' 'four') asValue.
     m selection:1 asValue.
     v := SelectionInListView on:m.
     v open.
     v inspect.

     if := v modelInterface.
     if inspect.

     if keysAndValuesDo:[:what :msg |
         v perform:(what , ':') asSymbol with:nil.
     ].
    "
!

on:aModel aspect:aspectSymbol
    "ST-80 compatibility: set model and aspect
     messages - needs a view which uses these"

    aspectMsg := aspectSymbol.
    self model:aModel.
!

on:aModel aspect:aspectSymbol change:changeSymbol
    "ST-80 compatibility: set model, aspect and change
     messages - needs a view which uses these"

    aspectMsg := aspectSymbol.
    changeMsg := changeSymbol.
    self model:aModel.
!

on:aModel aspect:aspectSymbol change:changeSymbol menu:menuSymbol
    "ST-80 compatibility: set model, aspect, change and menu
     messages - needs a view which uses these"

    aspectMsg := aspectSymbol.
    changeMsg := changeSymbol.
    menuMsg := menuSymbol.
    self model:aModel.
!

on:aModel aspect:aspectSymbol menu:menuSymbol
    "ST-80 compatibility: set model, aspect and menu
     messages - needs a view which uses these"

    aspectMsg := aspectSymbol.
    menuMsg := menuSymbol.
    self model:aModel.
!

sendChangeMessage:aSelector with:arg
    "tell the model about a change"

    "/
    "/ MVC way of doing it:
    "/ if the model is a block, evaluate it, optionally
    "/ passing the arg and the receiver as arguments.
    "/
    "/ otherwise (the common case) send it a changeMsg message
    "/ also with arg and the receiver (depending on the number of arguments
    "/ as defined by the selector).
    "/
    (model notNil and:[aSelector notNil]) ifTrue:[
        model isBlock ifTrue:[
            model valueWithOptionalArgument:aSelector and:arg and:self.
        ] ifFalse:[
            model perform:aSelector withOptionalArgument:arg and:self.
        ]
    ]
!

sendChangeMessageWith:arg
    "tell the model about a change"

    self sendChangeMessage:changeMsg with:arg
! !

!View methodsFor:'change & update'!

update:something with:aParameter from:changedObject

    changedObject == backgroundChannel ifTrue:[
        self backgroundColor:(backgroundChannel value).
        ^ self
    ].
    changedObject == foregroundChannel ifTrue:[
        self foregroundColor:(foregroundChannel value).
        ^ self
    ].
    changedObject == model ifTrue:[
        self updateFromModel.
        ^ self
    ].
    super update:something with:aParameter from:changedObject

    "Created: / 14.1.1998 / 17:10:11 / stefan"
    "Modified: / 30.3.1999 / 13:52:31 / stefan"
!

updateFromModel
    "to be redefined in subclasses"
! !

!View methodsFor:'drawing'!

redraw
    "redraw myself
     if there is a model, this one shall redraw itself,
     otherwise we cannot do much here - has to be redefined in subclasses"

    model notNil ifTrue:[
	model update:self
    ]
! !

!View methodsFor:'event handling'!

backgroundColorChanged
    "called to update the background color"

    |color|

    color := backgroundChannel value.
    self backgroundColor:color.
!

enableStateChanged
    "called to update enable/disable state"

    self enabled:(enableChannel value)

    "Modified: / 30.3.1999 / 16:07:08 / stefan"
!

foregroundColorChanged
    "called to update the foreground color"

    self foregroundColor:(foregroundChannel value)
! !

!View methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "views which do not like to take the keyboard focus
     with buttonPress can do so by redefining this
     to return false"

    (self class == View) ifTrue:[
        "/ a pure filler/geometric layout view
        ^ false
    ].
    ^ super wantsFocusWithButtonPress


! !

!View methodsFor:'initialization & release'!

initialize
    super initialize.

    aspectMsg := self class defaultAspectMessage.
    changeMsg := self class defaultChangeMessage.
    menuMsg := self class defaultMenuMessage.

    model notNil ifTrue:[
        controller notNil ifTrue:[
            controller model:model
        ]
    ].

    "Modified: 3.1.1997 / 02:11:15 / stefan"
!

release
    model notNil ifTrue:[
        model removeDependent:self.
        model := nil.
    ].
    visibilityChannel notNil ifTrue:[
        visibilityChannel retractInterestsFor:self.
        visibilityChannel removeDependent:self. visibilityChannel := nil
    ].
    enableChannel notNil ifTrue:[
        enableChannel retractInterestsFor:self.
        enableChannel removeDependent:self. enableChannel := nil
    ].
    foregroundChannel notNil ifTrue:[
        foregroundChannel retractInterestsFor:self.
        foregroundChannel removeDependent:self. foregroundChannel := nil
    ].
    backgroundChannel notNil ifTrue:[
        backgroundChannel retractInterestsFor:self.
        backgroundChannel removeDependent:self. backgroundChannel := nil
    ].
    super release.
! !

!View class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

