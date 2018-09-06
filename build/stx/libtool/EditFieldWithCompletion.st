"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

EditField subclass:#EditFieldWithCompletion
	instanceVariableNames:'showOptions optionsHolder optionsView optionsWindow completionJob
		tabCompletionJob'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!EditFieldWithCompletion class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    an editfield, which does some completion on the Tab key.

    [author:]
        Jan Vrany (janfrog@bruxa)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

example_1
    |top field label value|

    top := StandardSystemView new.
    top
        extent:300 @ 300;
        label:'Live class completion field'.
    value := '' asValue.
    field := self new
                origin:10 @ 135 corner:280 @ 165;
                entryCompletionBlock:[:content | Smalltalk classnameCompletion:content ];
                model:value.
    label := Label new
                origin:10 @ 95 corner:280 @ 115;
                labelChannel:value.
    top
        add:field;
        add:label;
        open
!

examples
"
    Opens a LiveCompletionEditField on a class name
                                                        [exBegin]
    LiveCompletionEditField example_1
                                                        [exEnd]
"
! !

!EditFieldWithCompletion methodsFor:'accepting'!

accept

    self unselect.
    super accept.

    "Created: / 27-07-2009 / 09:38:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-02-2010 / 11:56:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditFieldWithCompletion methodsFor:'accessing-behavior'!

showOptions
    ^ showOptions
!

showOptions:aBoolean
    showOptions := aBoolean.
! !

!EditFieldWithCompletion methodsFor:'accessing-dimensions'!

absoluteLeft

    | absoluteLeft view |
    absoluteLeft := 1.
    view := self.
    [ view notNil ] whileTrue:
        [absoluteLeft := absoluteLeft + view left - 1.
        view := view superView].
    ^absoluteLeft

    "Created: / 08-08-2009 / 22:30:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

absoluteTop

    | absoluteTop view |
    absoluteTop := 1.
    view := self.
    [ view notNil ] whileTrue:
        [absoluteTop := absoluteTop + view top - 1.
        view := view superView].
    ^absoluteTop

    "Created: / 08-08-2009 / 22:30:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!EditFieldWithCompletion methodsFor:'accessing-mvc'!

optionsHolder

    ^ optionsHolder

    "Created: / 09-08-2009 / 08:14:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

optionsHolder:aValueHolder
    "set the 'options' value holder (automatically generated)"

    optionsHolder := aValueHolder.

    "Created: / 09-08-2009 / 08:14:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!EditFieldWithCompletion methodsFor:'event handling'!

completion:best options:options 
    |newContent oldContent|
    "
    oldContent := ((self contents ? '') asString).
    newContent := ((best isNil or:[ best = oldContent ]) 
                and:[ options isNilOrEmptyCollection not ]) 
                    ifTrue:[
                        options first
                        ""options inject:options anyOne
                            into:[:shortest :each | 
                                shortest asString size > each asString size ifTrue:[
                                    each
                                ] ifFalse:[ shortest ]
                            ]""
                    ]
                    ifFalse:[ best ].
    self contents:newContent asString.
    self cursorCol:oldContent size + 1.
    oldContent size < newContent size ifTrue:[
        self 
            selectFromLine:1
            col:oldContent size + 1
            toLine:1
            col:newContent size
    ].
    "
    true "options size > 1" ifTrue:[
        optionsHolder value:options.
        self showOptionsWindow
    ]

    "Created: / 08-08-2009 / 22:02:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 08:16:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-02-2010 / 09:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleNonCommandKey: char
    super handleNonCommandKey: char.
    self startCompletion

    "Modified: / 26-07-2009 / 17:41:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

handlesKeyPress:key inView:aView
    <resource: #keyboard (#CursorDown #CursorUp)>

    ^ aView == optionsView and:[(#(CursorDown CursorUp) includes:key) not].

    "Created: / 09-12-2010 / 21:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasKeyboardFocus:gotFocusBoolean
    hasKeyboardFocus == gotFocusBoolean ifTrue:[
        "no change"
        ^ self
    ].

    gotFocusBoolean ifTrue:[
        "position cursor behind of already typed chars"
        self selectAll.
    ] ifFalse:[
        (self hasFocus not and:[optionsWindow notNil and:[optionsWindow hasFocus not]]) ifTrue:[
            self unselect.
            self hideOptionsWindow.
        ].
    ].
    ^ super hasKeyboardFocus:gotFocusBoolean

    "Created: / 08-08-2009 / 23:28:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 10:14:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2010 / 22:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y 
    "Forward certain events to optionsView if any"

    <resource: #keyboard (#CursorDown #CursorUp #Accept #Return #Escape #BackSpace #Delete)>

    (key isCharacter or:[#(Paste Copy Cut) includesIdentical:key]) ifTrue:[
        super keyPress:key x:x y:y.
        ^ self.
    ].

    (optionsView notNil 
     and:[#(CursorDown CursorUp) includesIdentical:key]) ifTrue:[
        optionsView keyPress:key x:x y:y.
        ^ self.
    ].

    key == #Accept ifTrue:[self hideOptionsWindow; accept].
    key == #Return ifTrue:[self hideOptionsWindow; accept].
    key == #Escape ifTrue:[self hideOptionsWindow].
    (key == #BackSpace or:[key == #Delete or:[key == #Tab]]) ifTrue:[
        super keyPress:key x:x y:y.
        key == #Tab ifTrue:[
            self startTabCompletion
        ] ifFalse:[    
            self startCompletion.
        ].
        ^ self.
    ].


    "Created: / 08-08-2009 / 22:02:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 14:06:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-02-2010 / 20:47:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view:aView
    self keyPress: key x:x y:y

    "Created: / 09-12-2010 / 21:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabCompletion:best options:options 
    self updateContentsForLongest:best options:options.
    
    true "options size > 1" ifTrue:[
        optionsHolder value:options.
        self showOptionsWindow
    ].
    "/ start another job, to update the list
    self doCompletion.
!

updateContentsForLongest:best options:options 
    |newContent oldContent|
    
    oldContent := ((self contents ? '') asString).
    newContent := best ? oldContent.
    newContent ~= oldContent ifTrue:[
        self contents:newContent asString.
        self cursorCol:oldContent size + 1.
        oldContent size < newContent size ifTrue:[
            self 
                selectFromLine:1 col:oldContent size + 1
                toLine:1 col:newContent size.
            typeOfSelection := #paste
        ].
    ].
! !

!EditFieldWithCompletion methodsFor:'initialization & release'!

destroy
    self hideOptionsWindow.
    super destroy.

    "Created: / 08-08-2009 / 22:16:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 08:50:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

initialize
    super initialize.
    showOptions := true.
    optionsHolder := ValueHolder new.
    
    completionJob := BackgroundJob 
                        named: 'Edit Field Completion Job'
                        on:[self doCompletion].
    tabCompletionJob := BackgroundJob 
                        named: 'Edit Field Tab Completion Job'
                        on:[self doTabCompletion].

    "Created: / 08-08-2009 / 20:24:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 08:17:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-08-2011 / 17:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditFieldWithCompletion methodsFor:'private'!

doCompletion
    self doCompletionThenSend:#completion:options:
!

doCompletionThenSend:selector
    |oldContents completionInfo options best|

    oldContents := (self contents ? '') asString.
    completionInfo := self entryCompletionBlock 
                    valueWithOptionalArgument:oldContents
                    and:self.
    completionInfo isNil ifTrue:[
        ^ self
    ].
    
    best := completionInfo first.
    options := completionInfo second.
"/    best isNil ifTrue:[self halt ].
    (options includes:best) ifFalse:[
        best := options 
                    detect:[:e | e asString startsWith:best asString ]
                    ifNone:[ best ]
    ].
    options isSortedCollection ifFalse:[
        options := options asSortedCollection:[:a :b | a displayString < b displayString ]
    ].
    self sensor 
        pushUserEvent:selector
        for:self
        withArguments:(Array with:best with:options).

    "Created: / 26-07-2009 / 17:45:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 02:51:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:33:56 / cg"
    "Modified (format): / 20-11-2011 / 09:42:25 / cg"
    "Modified: / 25-07-2016 / 07:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doTabCompletion
    self doCompletionThenSend:#tabCompletion:options:
!

hideOptionsWindow
    optionsWindow notNil ifTrue:[
        optionsWindow destroy.
        optionsView := optionsWindow := nil.
    ]

    "Created: / 08-08-2009 / 23:23:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 09:00:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-11-2011 / 11:27:03 / cg"
!

showOptionsWindow
    | x y w |

    showOptions ifFalse:[^ self].
    optionsWindow notNil ifTrue:[ 
        optionsWindow raise.
        ^ self 
    ].

    optionsView := SelectionInListModelView new
                    textStartLeft: textStartLeft - 2;
                    listHolder: optionsHolder;
                    action:[:value | value notNil ifTrue:[self contents:value asString]];
                    doubleClickAction:[:index | 
                            self contents:(optionsView at:index) asString.
                            self hideOptionsWindow.
                            self accept
                        ];
                    useIndex: false;
                    " JV: Looks good to me "
                    highlightMode: #line;
                    font:self font;
                    backgroundColor:self backgroundColor;
                    delegate: self;
                    yourself.

    x := self absoluteLeft + 5" - optionsView textStartLeft".
    y := self absoluteTop + self height + 1 + 5.
    w := (width * 2) + 0"((optionsView textStartLeft) * 2)".

    optionsWindow := StandardSystemView new
        bePopUpView;
        beSlave;        
        origin:x @ y
        extent:(w min: ((Screen current monitorBoundsAt:(x@y)) corner x - x)) @ (fontHeight * 10);
        yourself.

    ScrollableView   
        forView:optionsView 
        hasHorizontalScrollBar:false 
        hasVerticalScrollBar:true 
        miniScrollerH:true 
        miniScrollerV:false 
        origin:0.0@0.0 
        corner:1.0@1.0 
        in:optionsWindow.

    optionsWindow open.

    "Created: / 09-08-2009 / 08:12:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 09:28:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-11-2011 / 11:27:13 / cg"
    "Modified: / 04-04-2012 / 13:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startCompletion

    completionJob restart.

    "Created: / 26-07-2009 / 17:41:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 03-08-2011 / 17:50:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startTabCompletion

    tabCompletionJob restart.
! !

!EditFieldWithCompletion class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

