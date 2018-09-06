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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

TerminalView subclass:#VT52TerminalView
	instanceVariableNames:'param1 param2'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-TerminalViews'
!

!VT52TerminalView class methodsFor:'documentation'!

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
    A VT52 terminal emulator.
    Most of the functionality is inherited from my superclass,
    I redefine/specialize certain methods for VT52 escape sequences
    and vt52 keyboard codes

    [start with:]
        VT52TerminalView openShell

    [see also:]
        VT100TerminalView
        TelnetTool

    [start with:]
        VT52TerminalView openShell
"

! !

!VT52TerminalView methodsFor:'defaults'!

vt52KeyCodes
    "return a vt52 keyCode table"

    ^ IdentityDictionary withKeysAndValues:
        #(
             #CursorUp    '\eA'
             #CursorDown  '\eB'
             #CursorRight '\eC'
             #CursorLeft  '\eD'
             #Home        '\eH'
             #Escape      '\e'
             #BackSpace   '\b'
             #Return      '\r'
             #Delete      '\0177'
             #Tab         '\t'
         )

    "Modified: / 5.5.1999 / 15:01:37 / cg"
! !

!VT52TerminalView methodsFor:'events'!

defineWindowSize
    super defineWindowSize.
    rangeEndLine := numberOfLines

    "Created: / 13.6.1998 / 18:15:43 / cg"
    "Modified: / 20.6.1998 / 20:33:29 / cg"
! !

!VT52TerminalView methodsFor:'initialization'!

initialize
    super initialize.
    self endOfSequence.

    "Modified: / 20.6.1998 / 20:34:18 / cg"
!

initializeKeyboardSequences
    "setup my keyboard sequences for a vt52"

    kbdSequences := (self vt52KeyCodes)


! !

!VT52TerminalView methodsFor:'processing - input'!

nextPut:char
    "process a character (i.e. the shells output)"

    Debug ifTrue:[
        Transcript show:state; show:' '; showCR:char storeString.
    ].

    state == #gotReturn ifTrue:[
        state := 0.
        char == Character nl ifTrue:[
            "/ cr-nl
            "/ stay in buffering mode.
            super cr.
            ^ self.
        ].
        self endEntry.
        self cursorToBeginOfLine.
        "/ continue in initial state
    ].

    state == 0 ifTrue:[
        "/ Currently, we are in initial state.  
        "/ Decide what to do on the basis of the parameter char.

        (char == Character esc) ifTrue:[ 
            self endEntry.
            state := #gotESC. 
            ^ self 
        ].
        (char == Character nl) ifTrue:[ 
            self doCursorDown:1.
            ^ self endEntry.
        ].
        (char == Character return) ifTrue:[ 
            (rangeEndLine notNil and:[rangeEndLine ~~ numberOfLines]) ifTrue:[
                self endEntry.
                self cursorToBeginOfLine.
            ] ifFalse:[
                state := #gotReturn.
            ].
            ^ self.
        ].
        (char == Character backspace) ifTrue:[ 
            self doCursorLeft:1. "/ doBackspace
            ^ self endEntry.
        ].
        (char == Character bell) ifTrue:[
            self beep.
            ^ self 
        ].
        char asciiValue < 32 ifTrue:[
            char ~~ Character tab ifTrue:[
                char asciiValue ~~ 0 ifTrue:[
                    Debug ifTrue:[
                        Transcript show:'unhandled control key: '; showCR:char storeString.
                    ].
                ].
                ^ self.
            ]
        ].
        ^ self show:char
    ].

    state == #gotESC ifTrue:[
        "/ Currently, we are in ESC state.  
        "/ Decide what to do on the basis of the parameter char.

        char == $A ifTrue:[
            "/ ESC-A
            self doCursorUp:1.
            ^ self endOfSequence
        ].
        char == $B ifTrue:[
            "/ ESC-B
            self doCursorDown:1.
            ^ self endOfSequence
        ].
        char == $C ifTrue:[
            "/ ESC-C
            self doCursorRight:1.
            ^ self endOfSequence
        ].
        char == $D ifTrue:[
            "/ ESC-D
            self doCursorLeft:1.
            ^ self endOfSequence
        ].
        char == $H ifTrue: [
            "/ ESC-H
            self doCursorHome.
            ^ self endOfSequence
        ].
        char == $J ifTrue: [
            "/ ESC-J
            self doClearToEndOfScreen.
            ^ self endOfSequence
        ].
        char == $K ifTrue: [
            "/ ESC-J
            self doClearToEndOfLine.
            ^ self endOfSequence
        ].
        char == $Y ifTrue: [
            "/ ESC-Y - cursor positioning
            state := #motion1.
            ^ self 
        ].
        char == $= ifTrue: [
            "/ enter application keypad mode
            "/ ESC-=
            alternateKeypadMode := true.
            ^ self 
        ].
        char == $> ifTrue: [
            "/ exit application keypad mode
            "/ ESC-<
            alternateKeypadMode := false.
            ^ self 
        ].
        Debug ifTrue:[
            Transcript show:'unhandled esc-key: '; showCR:char storeString.
        ].
    ].

    state == #motion1 ifTrue:[
        "/ char-value - 32 is line
        param1 := (char asciiValue - 32).
        state := #motion2.
        ^ self.
    ].
    state == #motion2 ifTrue:[
        "/ char-value - 32 is col
        param2 := (char asciiValue - 32).
        Debug ifTrue:[
            Transcript show:'motion '; show:param1+1; show:' '; showCR:param2+1.
        ].
        self cursorVisibleLine:param1+1 col:param2+1.
        ^ self endOfSequence
    ].

    self doNothing

    "Modified: / 21.7.1998 / 20:06:04 / cg"
! !

!VT52TerminalView methodsFor:'queries'!

terminalType
    "returns a string describing this terminal (usually, this is
     passed down to the shell as TERM environment variable).
     Here, 'vt52' is returned."

    ^ 'vt52'

    "Created: / 10.6.1998 / 16:22:46 / cg"
    "Modified: / 5.5.1999 / 11:22:50 / cg"
! !

!VT52TerminalView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/VT52TerminalView.st,v 1.20 2013-11-24 23:13:04 cg Exp $'
! !

