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

Workspace subclass:#CodeView
	instanceVariableNames:'explainAction formatAction pointerOverWordAction theme'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!CodeView class methodsFor:'documentation'!

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
    a view for text which is known to be smalltalk code. 
    It adds 'explain' to the menu, and defines another action: 
      explainAction to be performed for explain.

    This action is to be defined by the user of this view 
    (i.e. usually the owning browser)

    In addition, uncomment/comment are added to the controlMenu.
    These are smalltalk specific - if you plan to edit other language code,
    you need a different kind of CodeView for that.

    If used with a model, accept sends the changeMsg to it (as defined in EditTextView).
    (however, it is possible to define both changeMsg and acceptAction)

    See how doIt/printIt/inspectIt are handled in the superclass: Workspace.

    Caveat:
        in this version, CodeView does not yet support MVC setups for doIt
        and explain.
        If required, simulate this by setting the doItAction and
        explainAction, to notify the model manually about whats going on.

    [instance variables:]
        commentStrings          <Array>         an array with 2 entries;
                                                the first defining the EOL-comment string,
                                                the 2nd (another array) defining opening
                                                and closing comment strings.
                                                Default to ST/X comments,
                                                can be changed in an instance for other
                                                programming languages.

    [author:]
        Claus Gittinger

    [see also:]
        Workspace EditTextView TextView
"
! !

!CodeView class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CodeView methodsFor:'accessing'!

explainAction:aBlock
    "set the action to be performed on explain"

    explainAction := aBlock
!

formatAction:aBlock
    "set the action to be performed on format"

    formatAction := aBlock

    "Created: / 17.2.1998 / 17:05:13 / cg"
!

pointerOverWordAction:aBlock
    pointerOverWordAction := aBlock.
    pointerOverWordAction notNil ifTrue:[
        self enableMotionEvents.
    ] ifFalse:[
        self disableMotionEvents
    ]


! !

!CodeView methodsFor:'cursor handling'!

cursorReturn
    self cursorReturn:false
!

cursorReturn:withPossibleAutoindent
    "added an argument to disable autoindent, because this method is called from other
     places as well..."
     
    |wasOn line newCol |

    "/ make Jan's enhancement dependent on
    "/ the autoIndent-flag setting - to avoid confusing
    "/ those who are used to the old behavior.
    "/ for Jan: 
    "/     autoIndent is configured in the settings-Editor dialog (for all new editors)
    "/     or in the per-editor popup menu (misc)
    "/ 
    "/ and saved/restored with the userPreferences.

    (withPossibleAutoindent not
    or:[ autoIndent not
    or:[ cursorLine == 1
    or:[ self sensor shiftDown]]]) ifTrue:[
        super cursorReturn.
        ^ self.
    ].
    "/ autoIndent

    wasOn := self hideCursor.
"/
"/    line := self listAt:cursorLine.
"/    newCol := line size == 0
"/                    ifTrue:[1]
"/                    ifFalse:[line indexOfNonSeparator].
"/    super cursorReturn.
"/    line := self listAt:cursorLine.
"/
"/    newCol := line size == 0
"/                    ifTrue:[newCol]
"/                    ifFalse:[line indexOfNonSeparator].

    super cursorReturn.
    newCol := (self leftIndentForLine:cursorLine)+1.

    self setCursorCol:newCol.
    self makeCursorVisibleAndShowCursor:wasOn

    "Created: / 8.8.2004 / 18:59:55 / janfrog"
    "Modified: / 8.8.2004 / 20:32:48 / janfrog"
! !

!CodeView methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    |col line word|

    pointerOverWordAction notNil ifTrue:[
        buttonState == 0 ifTrue:[
            line := self visibleLineOfY:y.
            col := self colOfX:x inVisibleLine:line.
            line := self visibleLineToAbsoluteLine:line.

            self wordAtLine:line col:col do:[
                :selectLine :beginCol :endLine :endCol :flag |

                word := self listAt:selectLine from:beginCol to:endCol.
                word notNil ifTrue:[
                    pointerOverWordAction value:word value:line value:col
                ]
            ].
            ^ self
        ].
    ].
    super buttonMotion:buttonState x:x y:y
!

keyPress:key x:x y:y
    "catch keyboard shortcuts"

    <resource: #keyboard (#Format #Explain #Help)>

    (key == #Format)  ifTrue:[self format. ^ self].
    (key == #Explain) ifTrue:[self explain. ^ self].
    (key == #Help)    ifTrue:[self explain. ^ self].

    super keyPress:key x:x y:y

    "Modified: / 17.2.1998 / 17:05:23 / cg"
! !

!CodeView methodsFor:'initialization'!

initStyle
    "initialize style specific stuff"

    | theme |

    super initStyle.     

    theme := UserPreferences current codeViewTheme.
    theme notNil ifTrue:[
        fgColor := theme defaultSyntaxColor ? fgColor.
        bgColor := theme defaultSyntaxBackground ? bgColor.

        cursorFgColor := theme cursorColor.
        cursorBgColor := theme cursorBackground.

    ].

    "Created: / 11-12-2017 / 17:30:07 / jv"
! !

!CodeView methodsFor:'menu & menu actions'!

accept
    "redefined accept action;
     save cursor and selection to allow restore in case of an error
     (we are typically compiling here ... and the compiler may show
     errors by highlighting them)"

    acceptEnabled == false ifTrue:[
        self beep.
        ^ self
    ].

    codeStartPosition := 1.
    [
        AbortOperationRequest handle:[:ex |
            self cursor:Cursor normal.
            "redraw selection in normal color"
            self selectFromLine:selectionStartLine col:selectionStartCol 
                         toLine:selectionEndLine col:selectionEndCol.
            self invalidate.
            ex return
        ] do:[
            super accept.
        ]
    ] ensure:[
        self cursor:Cursor normal.
        "/ self unselect.
    ]

    "Modified: / 30-06-2011 / 19:41:39 / cg"
!

editMenu
    "return the popUpMenu;
     to make this independent from what is defined in superclasses,
     get the superclass menu and add my functions."

    <resource: #keyboard ( 
                          #Accept #Explain #Format)>
    <resource: #programMenu>

    |m sub subsub sensor|

    m := super editMenu.
    ((sensor := self sensor) notNil and:[sensor ctrlDown and:[sensor shiftDown not]]) ifTrue:[
        sub := m.
        m := nil.
    ] ifFalse:[
        sub := m subMenuAt:#others.
    ].

    m notNil ifTrue:[
        "
         codeViews do support #accept
         ... add it after #inspectIt
        "
        m 
          addItemList:#(
                ('-')
                ('Accept'       accept          Accept)       
            )
          resources:resources  
          after:#inspectIt.

        (acceptEnabled == false 
        or:[acceptAction isNil]) ifTrue:[
            m disable:#accept
        ].
    ].

    sub notNil ifTrue:[
        "
         and add #explain after $gotoLine in the extra menu
        "
        sub 
          addItemList:#(
                ('-')
                ('Explain'       explain          Explain)       
            )
          resources:resources  
          after:#gotoLine.

        formatAction notNil ifTrue:[
            subsub := sub subMenuAt:#tools.

            subsub notNil ifTrue:[
                subsub
                  addItemList:#(
                        ('Format'       format          Format)       
                    )
                  resources:resources  
                  after:#indent.
            ].
        ].
        (self hasSelection not
        or:[explainAction isNil]) ifTrue:[
            sub disable:#explain 
        ].
    ].
    ^ m ? sub.

    "Modified: / 12.11.2001 / 16:04:46 / cg"
!

explain
    "explain action;
     evaluate the explainBlock passing whole contents and 
     selection as arguments."

    |text|

    explainAction notNil ifTrue:[
	text := self selection.
	text notNil ifTrue:[
	    explainAction value:(self contents) value:(text asString)
	]
    ]
!

format
    "format action;
     evaluate the formatBlock passing whole contents as argument."

    |text|

    formatAction notNil ifTrue:[
        text := self contents.
        text notNil ifTrue:[
            self 
                undoableDo:[ formatAction value:(text asString) ]
                info:'Format'
        ]
    ]

    "Created: / 17.2.1998 / 17:06:18 / cg"
    "Modified: / 17.2.1998 / 18:25:33 / cg"
! !

!CodeView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

