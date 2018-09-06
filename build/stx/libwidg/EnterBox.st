"
 COPYRIGHT (c) 1990 by Claus Gittinger
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

DialogBox subclass:#EnterBox
	instanceVariableNames:'labelField enterField trimBlanks'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!EnterBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
   Historic note:
        originally, ST/X had separate classes for the various entry methods;
        there were YesNoBox, EnterBox, InfoBox and so on.
        In the meantime, the DialogBox class (and therefore its alias: Dialog)
        is going to duplicate most functionality found in these classes.

        In the future, those existing subclasses' functionality is going to
        be moved fully into Dialog, and the subclasses will be replaced by dummy
        delegators. (They will be kept for backward compatibility, though).


    This class implements a pop-up box to enter some string
    with 2 buttons; a cancel button, and a trigger-action button.
    Normally, the box is created and opened with the single message:
        EnterBox request:'someString'
    which returns nil if aborted and the entered string otherwise.

    However, to control more details of the box, it may also be created first
    (EnterBox new) and then modified as appropriate before it is shown.

    For example, the boxes title can be changed with:

        aBox title:'some string'

    The two button-labels default to 'abort' and 'ok';
    they can be changed using:

        aBox okText:'someString'
        aBox abortText:'someString'

    The initial text in the enterfield can be set using:

        aBox initialText:'someString'

    when the ok-button is pressed, an action is performed, which is
    set using:

        aBox action:[ ... ]

    the abort-action defaults to no-action, but can also be set.

    The box can be opened modal (i.e. the currently active view will
    be suspended) or modeless. The default is modal (i.e. sending #open
    is equivalent to #openModal).

    Most of the above is also available via messages to Dialog for ST-80 compatibility
    (i.e. ""Dialog request:someString"" is the same as ""EnterBox request:'someString'"")

    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterBox2 YesNoBox ListSelectionBox FileSelectionBox FileSaveBox
        EditField EditTextView
        EnterFieldGroup
"
!

examples
"
    examples (for ST-80 compatibility, please use Dialog messages):

    simple (most common):
                                                                        [exBegin]
        |someString|

        someString := EnterBox request:'enter a string'.
        Transcript showCR:someString
                                                                        [exEnd]


    creating first, setting actions and manually opening:
                                                                        [exBegin]
        |box|

        box := EnterBox new.
        box title:'your name please:'.
        box action:[:arg | Transcript showCR:'entered: ''' , arg printString , ''''].
        box open
                                                                        [exEnd]


    turning off trimming of leading/trailing spaces (seldom required):
                                                                        [exBegin]
        |box|

        box := EnterBox new.
        box title:'your name please:'.
        box action:[:arg | Transcript showCR:'entered: ''' , arg printString , ''''].
        box trimBlanks:false.
        box open
                                                                        [exEnd]


    non-modal
    (just for the demo; it does not really make sense,
     since cancel-button has no effect):
                                                                        [exBegin]
        |box|

        box := EnterBox new.
        box title:'your name please:'.
        box action:[:arg | Transcript showCR:'entered: ' , arg printString].
        box openModeless
                                                                        [exEnd]


    for easier instance creation, there are also some combination methods:
                                                                        [exBegin]
        |box|

        box := EnterBox
                 title:'your name please:'
                 action:[:arg | Transcript showCR:'entered: ' , arg printString].
        box open
                                                                        [exEnd]


    If the box is needed to ask for a simple string, you can also use the
    #request method, to bring up a box, let it ask for something and return
    the entered string. This method will return nil, if the box was
    closed with the 'abort' button.
    Example:
                                                                        [exBegin]
        |box string|

        box := EnterBox request:'input some string:'.
        string isNil ifTrue:[
            Transcript showCR:'no input'
        ] ifFalse:[
            Transcript showCR:('the entered string was: ' , string)
        ]
                                                                        [exEnd]


    of course, this can be written shorter as:
                                                                        [exBegin]
        |string|

        string := EnterBox request:'input some string:'.
        string isNil ifTrue:[
            Transcript showCR:'no input'
        ] ifFalse:[
            Transcript showCR:('the entered string was: ' , string)
        ]
                                                                        [exEnd]


    A box for passwords is created with:
                                                                        [exBegin]
        |box|

        box := EnterBox
                 title:'your name please:'
                 action:[:arg | Transcript showCR:'entered: ' , arg printString].
        box enterField passwordCharacter:$*.
        box showAtPointer
                                                                        [exEnd]


    or simply:
                                                                        [exBegin]
        |string|

        string := EnterBox requestPassword:'enter your password:'.
        Transcript showCR:string.
                                                                        [exEnd]

    ATTENTION:
    for ST-80 compatibility, please use protocol from Dialog
    (which is an alias for DialogBox):
                                                                        [exBegin]
        |string|

        string := Dialog request:'input some string:'.
        string isNil ifTrue:[
            Transcript showCR:'no input'
        ] ifFalse:[
            Transcript showCR:('the entered string was: ' , string)
        ]
                                                                        [exEnd]
    and:
                                                                        [exBegin]
        |string|

        string := Dialog requestPassword:'enter your password:'.
        Transcript showCR:string.
                                                                        [exEnd]
"

    "Modified: 16.11.1995 / 21:28:11 / cg"
! !

!EnterBox class methodsFor:'instance creation'!

action:aBlock
    "create and return a new EnterBox
     which will evaluate aBlock when 'ok' is pressed.
     Obsolete (but kept for backward compatibility):
     boxes are never used without a proper label"

    ^ (self new) action:aBlock

    "
     (EnterBox action:[:string | Transcript showCR:string]) showAtPointer
     (EnterBox action:[:string | Transcript showCR:string]) open
     (EnterBox action:[:string | Transcript showCR:string]) open
    "
!

title:titleString
    "create and return a new EnterBox with title aString"

    ^ self new title:titleString
!

title:titleString action:aBlock
    "create and return a new EnterBox with title aString,
     which will evaluate aBlock when 'ok' is pressed"

    ^ (self title:titleString) action:aBlock
!

title:titleString okText:okText abortText:abortText action:aBlock
    "create and return a new EnterBox with title aString, and buttons showing
     okText and abortText; it will evaluate aBlock when 'ok' is pressed"

    ^ (self title:titleString okText:okText action:aBlock) abortText:abortText
!

title:titleString okText:okText action:aBlock
    "create and return a new EnterBox with title aString, and ok button showing
     okText; it will evaluate aBlock when 'ok' is pressed"

    ^ (self title:titleString action:aBlock) okText:okText
! !

!EnterBox class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ (Screen current pixelPerMillimeter * (60 @ 20)) rounded

    "Modified: / 22.1.1998 / 09:57:26 / md"
    "Modified: / 27.7.1998 / 20:15:52 / cg"
!

minExtent
    ^ self defaultExtent
! !

!EnterBox class methodsFor:'easy startup'!

request:aTitle
    "create and show an enterBox asking for aTitle.
     Return the entered string or an empty string (if abort was pressed).
     The string may be empty, in case return was pressed immediately."

    ^ self new request:aTitle

    "
     EnterBox request:'Enter a string:'
    "

    "Modified: 27.1.1996 / 14:34:23 / cg"
!

requestPassword:aTitle
    "create and show an enterBox asking for aTitle.
     The box is setup to NOT display entered characters (as with password entry).
     Return the entered string or nil (if abort was pressed).
     The string may be empty, in case return was pressed immediately."

    ^ self new requestPassword:aTitle

    "
     |s|

     s := EnterBox requestPassword:'Enter a password string:'.
     Transcript showCR:'you entered: ' , s asString
    "

    "Created: 16.11.1995 / 21:25:08 / cg"
! !

!EnterBox methodsFor:'accessing-behavior'!

entryCompletionBlock:aBlock
    "define an entryCompletion block; if nonNil, that one
     is evaluated if TAB is pressed in the field and should
     try to complete the input.
     The block gets the current contents and the field itself as optional arguments
     (i.e. it can be a 0, 1 or 2-arg block).
     Typically used with fileName-boxes."

    enterField entryCompletionBlock:aBlock

    "Modified: 22.5.1996 / 15:19:31 / cg"
!

trimBlanks:aBoolean
    "set/clear blank trimming in the returned string.
     By default, leading and trailing spaces are removed from the input;
     setting trimBlanks to false disables this behavior.
     (not normally useful in most applications)"

    trimBlanks := aBoolean

    "Created: 22.5.1996 / 15:23:45 / cg"
! !

!EnterBox methodsFor:'accessing-components'!

enterField
    "provide access to the entryfield"

    ^ enterField

    "Created: 16.11.1995 / 21:23:48 / cg"
!

labelField
    "provide access to the labelfield"

    ^ labelField

    "Created: 16.11.1995 / 21:23:48 / cg"
! !

!EnterBox methodsFor:'accessing-contents'!

contents
    "return my contents"

    ^ enterField contents
!

contents:aString
    "set my contents"

    enterField contents:aString
!

initialAnswer:aString
    "for protocol compatibility - an alias for initialText:"

    self initialText:aString
!

initialText:aString
    "define the initial text in the enterfield. all will be selected initially"

    self initialText:aString selected:true
!

initialText:aString selectFrom:start to:stop
    "define the initial text in the enterfield, and the part to be selected"

    self initialText:aString.
    self selectFromCharacterPosition:start to:stop
!

initialText:someString selected:selected
    "define the initial text in the enterfield; optionally, all is selected initially"

    enterField initialText:someString selected:selected
!

selectFrom:start to:stop
    "define the initial selection in the enterfield"

    enterField selectFromLine:1 col:start toLine:1 col:stop
!

selectFromCharacterPosition:start to:stop
    "define the initial selection in the enterfield"

    enterField selectFromCharacterPosition:start to:stop
! !

!EnterBox methodsFor:'accessing-look'!

noCancel
    "make the cancel button invisible - i.e. only the ok button is shown.
     Not useful here, but useful with display-only textBoxes."

    abortButton beInvisible.
!

title:aString
    "set the title to be displayed at top of enterBox"

    |oldSize|

    aString ~= labelField label ifTrue:[
        oldSize := labelField extent.
        labelField label:aString.
        labelField forceResize.

        shown ifTrue:[
            labelField extent ~= oldSize ifTrue:[
                self resize
            ]
        ] ifFalse:[
            self sizeChanged:nil.
        ]
    ]
!

title:titleString okText:okString
    "set title and text in okbutton"

    (titleString ~= labelField label or:[okString ~= okButton label]) ifTrue:[
        okButton label:okString.
        okButton resize.
        labelField label:titleString.
        labelField forceResize.
        shown
            ifTrue:[self resize]
            ifFalse:[ self sizeChanged:nil].
    ]
!

title:titleString okText:okString abortText:abortString
    "set title and texts in the buttons"

    (titleString ~= labelField label
     or:[okString ~= okButton label
     or:[abortString ~= abortButton label]]) ifTrue:[
        okButton label:okString.
        okButton resize.
        abortButton label:abortString.
        abortButton resize.
        labelField label:titleString.
        labelField forceResize.
        shown
            ifTrue:[self resize]
            ifFalse:[ self sizeChanged:nil].
    ]
! !

!EnterBox methodsFor:'change & update'!

update:something with:someArgument from:changedObject
    "sent if my enterbox thinks it needs more real-estate ..."

    changedObject == enterField ifTrue:[
	something == #preferredExtent ifTrue:[
	    shown ifTrue:[self resizeUnderPointer].
	    ^ self
	]
    ].
    super update:something with:someArgument from:changedObject
! !

!EnterBox methodsFor:'initialization'!

addEnterField:aWidget
    |space2 innerWidth|

    enterField notNil ifTrue:[
        enterField removeDependent:self.
        enterField destroy.
        enterField := nil.
    ].
    enterField := aWidget.

    space2 := 2 * ViewSpacing.
    innerWidth := width - space2.

    self addComponent:aWidget.
    enterField
        width:1.0;
        origin:[0.0 @ (space2 + labelField preferredHeight "height")];
        leftInset:ViewSpacing-aWidget borderWidth;
        rightInset:1 "ViewSpacing".

    aWidget addDependent:self. "to get preferredExtent-changes"

    self makeTabable:aWidget

    "Modified: / 23-01-2012 / 17:30:17 / cg"
!

createEnterField
    "this has been extracted from the initialize method
     to allow redefinition in subclasses. (FilenameEnterBox for example).
     It shall return a new instance of the desired editField class."

    |widget|

    widget := EditField new.
    widget leaveAction:[:key | self okPressed].
    ^ widget
!

initialize
    |space2 innerWidth|

    super initialize.

    self addAbortAndOkButtons.

    trimBlanks := true.
    label := resources string:'Enter'.  "/ bad name: this is the window label

    space2 := 2 * ViewSpacing.
    innerWidth := width - space2.

    labelField := Label in:self.
    labelField
        label:'';
        borderWidth:0;
        adjust:#left;
        origin:(0.0 @ ViewSpacing) extent:[1.0 @ labelField height];
        leftInset:ViewSpacing;
        rightInset:ViewSpacing.

    self addEnterField:(self createEnterField).
    yPosition := enterField bottom + ViewSpacing.
!

reAdjustGeometry
    "sent late in the setup process - gives me a chance
     to resize for new font dimensions"

    super reAdjustGeometry.
    labelField resize.
    okButton resize.
    abortButton resize.
    self resize
! !

!EnterBox methodsFor:'queries'!

preferredExtent
    "compute the boxes preferredExtent from the components' sizes"

    |wWanted hWanted wPanel vs2 min
     labelPref enterPref panelPref|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    panelPref := buttonPanel preferredExtent.
    labelPref := labelField preferredExtent.
    enterPref := enterField preferredExtent.
    wWanted := (labelPref x max:enterPref x).
    wPanel := panelPref x.
    wPanel > wWanted ifTrue:[
        wWanted := wPanel
    ].
    hWanted := labelPref y + ViewSpacing + enterPref y +
               ViewSpacing + panelPref y + ViewSpacing.
    verticalPanel notNil ifTrue:[
        hWanted := hWanted + ViewSpacing + (verticalPanel preferredHeight).
    ].

    min := self class minExtent.
    wWanted <  min x ifTrue:[
        wWanted :=  min x
    ].
    hWanted <  min y ifTrue:[
        hWanted :=  min y
    ].
    vs2 := ViewSpacing * 2.
    ^ (wWanted + vs2) @ (hWanted + vs2)

    "Modified: / 22.1.1998 / 09:57:55 / md"
    "Modified: / 27.7.1998 / 20:18:41 / cg"
! !

!EnterBox methodsFor:'startup'!

request
    "open the box and return the entered string
     or an empty string, if abort was pressed"

    ^ self requestOnCancel:''

    "Modified: 27.1.1996 / 14:50:01 / cg"
!

request:title
    "set the title, open the box and return the entered string,
     or  the empty string, if abort was pressed."

    ^ self request:title onCancel:''

    "
     EnterBox request:'enter some string:'

     |bx|
     bx := EnterBox new.
     bx label:'foo bar baz'.
     bx request:'enter some string:'
    "

    "Created: 7.12.1995 / 23:12:19 / cg"
    "Modified: 27.1.1996 / 14:49:23 / cg"
!

request:title onCancel:cancelValue
    "set the title, open the box and return the entered string,
     or cancelValue if abort was pressed."

    self title:title.
    ^ self requestOnCancel:cancelValue

    "
     EnterBox request:'enter some string:' onCancel:nil

     |bx|
     bx := EnterBox new.
     bx label:'foo bar baz'.
     bx request:'enter some string:' onCancel:#foo
    "

    "Created: 7.12.1995 / 23:12:19 / cg"
    "Modified: 27.1.1996 / 14:48:39 / cg"
!

requestOnCancel:cancelValue
    "open the box and return the entered string
     or cancelValue, if abort was pressed"

    self action:[:string | ^ string].
    self open.
    ^ cancelValue value

    "Created: 27.1.1996 / 14:47:47 / cg"
!

requestPassword:title
    "set the title, set password mode, open the box and return the entered string
     or nil, if abort was pressed"

    ^ self requestPassword:title onCancel:nil

    "Created: 16.11.1995 / 21:25:33 / cg"
    "Modified: 27.1.1996 / 14:52:36 / cg"
!

requestPassword:title onCancel:cancelValue
    "set the title, set password mode, open the box and return the entered string
     or cancelValue, if abort was pressed"

    enterField bePassword.
    ^ self request:title onCancel:cancelValue

    "Modified: 27.1.1996 / 14:34:07 / cg"
    "Created: 27.1.1996 / 14:52:13 / cg"
! !

!EnterBox methodsFor:'user actions'!

actionArgument
    "fetch the entered string, optionally trim spaces and return it"

    |string|

    string := self contents.
    string isNil ifTrue:[
        string := ''
    ] ifFalse:[
        trimBlanks ifTrue:[
            string := string withoutSeparators
        ]
    ].

    ^ string
! !

!EnterBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

