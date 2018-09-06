"
 COPYRIGHT (c) 1998 by eXept Software AG
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

EditTextView subclass:#RCSConflictEditTextView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!RCSConflictEditTextView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    like an editTextView, but adds two buttons to search forward/backward
    for next change.
"
! !

!RCSConflictEditTextView methodsFor:'actions'!

moveToNextChanged
    "somewhat of a kludge - simply search for the next text-item"

    |start end lnNr max list|

    start := self lastLineShown + 1.

    list := self list.
    max  := list size.
    lnNr := start.

    [(lnNr > max or:[(list at:lnNr) isText])
    ] whileFalse:[
        lnNr := lnNr + 1
    ].

    (lnNr <= max) ifTrue:[
        (end isNil or:[lnNr < end]) ifTrue:[
            end := lnNr.
        ]
    ].

    end notNil ifTrue:[
        self scrollToLine:end
    ] ifFalse:[
        self beep
    ].

    "Modified: / 27.7.1998 / 12:29:24 / cg"
!

moveToPreviousChanged
    "somewhat of a kludge - simply search for the previous text-item"

    |start end found lnNr list|

    start := firstLineShown - 1.
    end   := 1.
    found := false.

    start > 1 ifTrue:[
        list := self list.
        lnNr := list size.

        lnNr >= start ifTrue:[
            lnNr := start
        ].

        [(lnNr == end or:[(list at:lnNr) isText])
        ] whileFalse:[
            lnNr := lnNr - 1
        ].
        (list at:lnNr) isText ifTrue:[
            end   := lnNr.
            found := true.
            "/ skip multiple text-lines
            [end > 1 and:[(list at:(end-1)) isText]] whileTrue:[
                end := end - 1
            ].
        ]
    ].
    found ifTrue:[
        self scrollToLine:end
    ] ifFalse:[
        self beep
    ]

    "Created: / 27.7.1998 / 12:25:34 / cg"
    "Modified: / 27.7.1998 / 12:31:26 / cg"
! !

!RCSConflictEditTextView methodsFor:'initialization'!

initialize
    |panel buttonPrev buttonNext|

    super initialize.

"set up-down buttons"

    panel := VerticalPanelView in:self.

    buttonPrev := Button label:'-' in:panel.
    buttonNext := Button label:'+' in:panel.
    buttonPrev extent:15@22.
    buttonNext extent:15@22.
    panel origin:0.0 @ 1.0 corner:(15 + SimpleView viewSpacing) @ 1.0.
    panel topInset:(2 * (buttonPrev preferredExtent y)) negated.

"set actions"

    buttonPrev pressAction:[
        buttonPrev turnOff.
        self moveToPreviousChanged
    ].

    buttonNext pressAction:[
        buttonNext turnOff.
        self moveToNextChanged
    ].
    self moveToNextChanged.

    "Modified: / 27.7.1998 / 12:22:31 / cg"
! !

!RCSConflictEditTextView class methodsFor:'documentation'!

version
    ^ '$Id: RCSConflictEditTextView.st 8016 2012-07-18 09:57:46Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id:: RCSConflictEditTextView.st 8016 2012-07-18 09:57:46Z vranyj1                                                           $'
! !

