"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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

TerminalView subclass:#VT100TerminalView
	instanceVariableNames:'currentParam parameters lastCursorLine'
	classVariableNames:'TraceCSI'
	poolDictionaries:''
	category:'Views-TerminalViews'
!

!VT100TerminalView class methodsFor:'documentation'!

ansiEscapes
"
   see also: http://www.vt100.net/docs/vt100-ug/chapter3.html

                              ANSI ESCAPE SEQUENCES
===============================================================================
Wherever you see '#', that should be replaced by the appropriate number.

        ESC code sequence                       Function
       -------------------              ---------------------------
Cursor Controls:
         ESC[#;#H or ESC[#;#f           Moves cusor to line #, column #
         ESC[#A                         Moves cursor up # lines
         ESC[#B                         Moves cursor down # lines
         ESC[#C                         Moves cursor forward # spaces
         ESC[#D                         Moves cursor back # spaces
         ESC[#;#R                       Reports current cursor line & column
         ESC[s                          Saves cursor position for recall later
         ESC[u                          Return to saved cursor position

Erase Functions:
         ESC[2J                         Clear screen and home cursor
         ESC[K                          Clear to end of line

Set Graphics Rendition:
         ESC[#;#;....;#m                Set display attributes where # is
                                            0 for normal display
                                            1 for bold on
                                            4 underline (mono only)
                                            5 blink on
                                            7 reverse video on
                                            8 nondisplayed (invisible)

                                            30 black foreground 
                                            31 faint red foreground 
                                            32 faint green foreground 
                                            33 faint yellow foreground 
                                            34 faint blue foreground 
                                            35 faint magenta foreground 
                                            36 faint cyan foreground 
                                            37 faint white (grey) foreground
                                            39 reset to default foreground

                                            40 black background
                                            41 red background
                                            42 green background
                                            43 yellow background
                                            44 blue background
                                            45 magenta background
                                            46 cyan background
                                            47 white background
                                            49 reset to default background

                                            90 grey foreground 
                                            91 bright red foreground 
                                            92 bright green foreground 
                                            99 bright yellow foreground 
                                            94 bright blue foreground 
                                            95 bright magenta foreground 
                                            96 bright cyan foreground 
                                            97 bright white foreground

                                           100 grey background 
                                           101 bright red background 
                                           102 bright green background 
                                           109 bright yellow background 
                                           104 bright blue background 
                                           105 bright magenta background 
                                           106 bright cyan background 
                                           107 bright white background

         ESC[=#;7h or                   Put screen in indicated mode where # is
         ESC[=h or                          0 for 40 x 25 black & white
         ESC[=0h or                         1 for 40 x 25 color
         ESC[?7h                            2 for 80 x 25 b&w
                                            3 for 80 x 25 color
                                            4 for 320 x 200 color graphics
                                            5 for 320 x 200 b & w graphics
                                            6 for 640 x 200 b & w graphics
                                            7 to wrap at end of line 

         ESC[=#;7l or ESC[=l or         Resets mode # set with above command
         ESC[=0l or ESC[?7l

Keyboard Reassignments:
         ESC[#;#;...p                   Keyboard reassignment. The first ASCII
         or ESC[""string""p               code defines which code is to be 
         or ESC[#;""string"";#;           changed. The remaining codes define
            #;""string"";#p               what it is to be changed to.

         E.g. Reassign the Q and q keys to the A and a keys (and vice versa).
         ESC [65;81p                    A becomes Q
         ESC [97;113p                   a becomes q
         ESC [81;65p                    Q becomes A
         ESC [113;97p                   q becomes a

         E.g. Reassign the F10 key to a DIR command.
         ESC [0;68;""dir"";13p            The 0;68 is the extended ASCII code 
                                        for the F10 key and 13 is the ASCII
                                        code for a carriage return.

         Other function key codes       F1=59,F2=60,F3=61,F4=62,F5=63
                                        F6=64,F7=65,F8=66,F9=67,F10=68
"
!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
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
    A VT100 / XTerm terminal emulator.
    Most of the functionality is inherited from my superclass,
    I redefine/specialize certain methods for VT100 / XTerm escape sequences
    and VT100 / XTerm keyboard codes

    == Keyboard Debugging ==

    In case some keys does not work as expected, do the folowing:

        1. Turn on keyboard debugging by evaluating:

              DebugKeyboard := false

        2. Check what it actually sends to the program.

        3. Open proper XTerm and run:

              export TERM=xterm
              tput smkx; cat

           Then press desired key and see what is its keycode. 

        4. Update #vt100KeyCodes / #xtermKeyCodes accordingly


    BUGS:
        VT100 wrapMode (at right margin) is not supported
        this may lead to wrong display when a vi is started in a small window.

    [start with:]
        VT100TerminalView openShell

    [see also:]
        VT52TerminalView
        TelnetTool
        http://vt100.net/docs/vt220-rm/chapter4.html
"
! !

!VT100TerminalView methodsFor:'defaults'!

colorAtIndex:idx bright:bright
    |rgb|

    rgb := #(
                #( 0 0 0 )      "/ black                        fg: ESC[30m / bg: ESC[40m
                #(170 0 0)      "/ dark red
                #(0 170 0)      "/ dark green
                #(170 85 0)     "/ dark yellow
                #(0 0 170)      "/ dark blue
                #(170 0 170)    "/ dark magenta
                #(0 170 170 )   "/ dark cyan
                #(170 170 170)  "/ dark white eg. light grey).

                #( 85 85 85 )   "/ bright black eg. darkGray    fg: ESC[90m / bg: ESC[100m  
                #(255 85 85)    "/ bright red
                #(85 255 85)    "/ bright green
                #(255 255 85)   "/ bright yellow
                #(85 85 255)    "/ bright blue
                #(255 85 255)   "/ bright magenta
                #(85 255 255 )  "/ bright cyan
                #(255 255 255)  "/ white 
    ).

    ^ Color 
        perform: #'redByte:greenByte:blueByte:' 
        withArguments:(rgb at:(idx + (bright ifTrue:[8] ifFalse:[0]))).
!

vt100AlternativeKeyCodes
    "return the alternative vt100 keyCode table"

    ^ IdentityDictionary withKeysAndValues:
        #(
             #CursorUp    '\eOA'
             #CursorDown  '\eOB'
             #CursorRight '\eOC'
             #CursorLeft  '\eOD'
             #Home        '\eOH'
             #Escape      '\e'
             #BackSpace   '\b'
             #Return      '\r'
             #Delete      '\0177'
             #Tab         '\t'

             #F1          '\eOP'
             #F2          '\eOQ'
             #F3          '\eOR'
             #F4          '\eOS'
             #F5          '\eOt'
             #F6          '\eOu'
             #F7          '\eOv'
             #F8          '\eOl'
             #F9          '\eOw'
         )
!

vt100KeyCodes
    "return a vt100 keyCode table"

    ^ IdentityDictionary withKeysAndValues:
        #(
             #CursorUp    '\e[A'
             #CursorDown  '\e[B'
             #CursorRight '\e[C'
             #CursorLeft  '\e[D'

             #Home        '\e[H'
             #End         '\e[F'
             #Escape      '\e'
             #BackSpace   '\b'
             #Return      '\r'
             #Delete      '\e[3~'
             #Tab         '\t'

             #F1          '\eOP'
             #F2          '\eOQ'
             #F3          '\eOR'
             #F4          '\eOS'
             #F5          '\eOt'
             #F6          '\eOu'
             #F7          '\eOv'
             #F8          '\eOl'
             #F9          '\eOw'
         )

    "Created: / 10-06-1998 / 15:13:01 / cg"
    "Modified: / 05-05-1999 / 15:01:32 / cg"
    "Modified (comment): / 20-06-2017 / 21:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VT100TerminalView methodsFor:'functions'!

addLines
    "Add the appropriate number of blank lines (param 1) 
     at the cursor position."

    self addLines:((parameters at:1) max:1).
    self endOfSequence

    "Created: / 10.6.1998 / 14:48:03 / cg"
!

addLines:aNumber
    "Add aNumber blank lines at the position indicated by the cursor."

    aNumber timesRepeat:[
        self insertLine:'' before:cursorLine
    ]

    "Created: / 10.6.1998 / 14:49:30 / cg"
!

clearLines:arg
    "Clear some part of the current line, as indicated by the first parameter:
     0 - clear to EOL
     1 - clear from beginning to cursorCol
     2 - clear entire line
    "

    arg = 0 ifTrue: [^self doClearToEndOfLine].
    arg = 1 ifTrue: [^self doClearFromBeginningOfLine].
    arg = 2 ifTrue: [^self doClearEntireLine]

    "Created: / 10.6.1998 / 14:44:22 / cg"
    "Modified: / 21.7.1998 / 20:07:42 / cg"
!

deleteCharacters
    "Delete the appropriate number of characters (param 1)
     at the cursor position."

    |n|

    n := parameters at: 1.
    n isNil ifTrue:[^ self].
    n := n max: 1.
    self deleteFromLine:cursorLine col:cursorCol toLine:cursorLine col:cursorCol+n-1.

    "Created: / 12.6.1998 / 21:19:02 / cg"
    "Modified: / 12.6.1998 / 21:19:15 / cg"
!

deleteLines
    "Delete the appropriate number of lines (param 1)
     at the cursor position."

    |n|

    n := ((parameters at: 1) max: 1).
self halt:'untested code'.
    self deleteFromLine:cursorLine toLine:cursorLine+n-1.
!

displayMode:p1
    "Set the current display mode (emphasis) as specified by param 1."

"/    self endEntry.    -- not needed (does not affect characters on screen or buffered or cursor position
    p1 == 0 ifTrue:[
        self normal.
        ^ self.
    ].

    p1 == 1 ifTrue:[
        "/ ESC-[-1-m  -> bold

        "/ workaround: windows bold fonts are
        "/ wider, leading to ugly looking output
        "/ Therefore, use red color instead of bold
        device isWindowsPlatform ifTrue:[
            self color:(Color red:80).
        ] ifFalse:[
            self bold.
        ].
        ^ self.
    ].
    p1 == 2 ifTrue:[
        "/ faint - unsupported
        ^ self.
    ].
    p1 == 3 ifTrue:[
        "/ ESC-[-3-m  -> italic

        self italic.
        ^ self.
    ].
    p1 == 4 ifTrue:[
        "/ ESC-[-4-m  -> underline

        self underline.
        ^ self.
    ].
    p1 == 5 ifTrue:[
        "/ ESC-[-5-m  -> blink

        self color:Color blue.
        ^ self.
    ].
    p1 == 6 ifTrue:[
        "/ ESC-[-5-m  -> blink rapid - unsupported
        ^ self.
    ].
    p1 == 7 ifTrue:[
        "/ ESC-[-7-m  -> reverse

        self reverse.
        ^ self.
    ].
    p1 == 8 ifTrue:[
        "/ ESC-[-8-m  -> invisible
        ^ self.
    ].
    p1 == 9 ifTrue:[
        "/ ESC-[-9-m  -> crossed out - unsupported
        ^ self.
    ].
    p1 == 10 ifTrue:[
        "/ ESC-[-10-m  -> primary font - unsupported
        ^ self.
    ].
    (p1 between:11 and:19) ifTrue:[
        "/ alternate fonts - unsupported
        ^ self.
    ].
    p1 == 20 ifTrue:[
        "/ fraktur - unsupported
        ^ self.
    ].
    p1 == 21 ifTrue:[
        "/ ESC-[-21-m  -> not bold
        self notBold.
        ^ self.
    ].
    p1 == 23 ifTrue:[
        "/ ESC-[-23-m  -> not italic
        self notItalic.
        ^ self.
    ].
    p1 == 24 ifTrue:[
        "/ ESC-[-24-m  -> not underline
        self notUnderline.
        ^ self.
    ].
    p1 == 25 ifTrue:[
        "/ ESC-[-25-m  -> not blinking - unsupported
        ^ self.
    ].
    p1 == 28 ifTrue:[
        "/ ESC-[-28-m  -> not invisible/reveal - unsupported
        ^ self.
    ].
    p1 == 29 ifTrue:[
        "/ ESC-[-29-m  -> not crossed out - unsupported
        ^ self.
    ].
    (p1 between:30 and:37) ifTrue:[
        "/ ESC-[-30-m  -> black fg color
        "/ ESC-[-31-m  -> red   fg color
        "/ ...
        "/ ESC-[-37-m  -> white fg color
        noColors ifFalse:[
            self color:(self colorAtIndex:(p1-30+1) bright:false).
        ].
        ^ self.
    ].
    p1 == 38 ifTrue:[
        "/ xterm 256 color - unsupported
        ^ self
    ].
    p1 == 39 ifTrue:[
        "/ normal fg color
        self color:nil.
        ^ self
    ].
    (p1 between:40 and:47) ifTrue:[
        "/ ESC-[-40-m  -> black bg color
        "/ ...
        "/ ESC-[-47-m  -> white bg color
        noColors ifFalse:[
            self bgColor:(self colorAtIndex:(p1-40+1) bright:false).
        ].
        ^ self.
    ].
    p1 == 48 ifTrue:[
        "/ xterm 256 bg color - unsupported
        ^ self
    ].
    p1 == 49 ifTrue:[
        "/ normal bg color
        self bgColor:nil.
        ^ self
    ].

    (p1 between:90 and:97) ifTrue:[
        "/ fg color high intensity
        noColors ifFalse:[
            self color:(self colorAtIndex:(p1-90+1) bright:true).
        ].
        ^ self.
    ].
    (p1 between:100 and:107) ifTrue:[
        "/ bg color high intensity
        noColors ifFalse:[
            self bgColor:(self colorAtIndex:(p1-100+1) bright:true).
        ].
        ^ self.
    ].

    "/ ESC-[-any-m  -> normal
    self normal.

    "Created: / 10.6.1998 / 15:01:16 / cg"
    "Modified: / 5.5.1999 / 00:53:15 / cg"
!

doClearDisplay:arg
    "Clear some part of the current screen, as indicated by the first parameter.
     0 - clear to endOfScreen
     1 - clear from beginning of screen to cursorCol
     2 - clear entire screen
    "

    arg = 0 ifTrue: [^self doClearToEndOfScreen].
    arg = 1 ifTrue: [^self doClearFromBeginningOfScreen].
    arg = 2 ifTrue: [^self doClearEntireScreen]

    "Created: / 21.7.1998 / 20:05:07 / cg"
    "Modified: / 21.7.1998 / 20:07:36 / cg"
!

doCursorNextLine:n
    self halt:'unimplemented function'.
!

doCursorPreviousLine:n
    self halt:'unimplemented function'.
!

insertCharacters
    "Insert the appropriate number of spaces (param 1) at the cursor position."

    |s|

    s := String new:((parameters at: 1) max: 1).
    self insertStringWithoutCRs:s atLine:cursorLine col:cursorCol.

    "Modified: / 12.6.1998 / 21:14:25 / cg"
    "Created: / 28.7.1998 / 00:53:51 / cg"
!

insertLines
    "Insert the appropriate number of lines (param 1) at the cursor position."

    |n|

    n := (parameters at: 1) max: 1.
    self halt:'untested code'.
    self insertLines:(Array new:n) before:cursorLine
!

move
    "Move to the locations indicated by the first and second parameters."

    | row column |

    row := (self getParameter:1 withDefault:1).
    column := (self getParameter:2 withDefault:1).
    Debug ifTrue:[
        Transcript show:'move to column/row:'; show:column; show:'/'; showCR:row.
    ].    
    self moveToX:column y:row.

    "Created: / 10.6.1998 / 14:40:01 / cg"
    "Modified: / 20.6.1998 / 18:49:12 / cg"
!

moveToColumn
    "Move to the column indicated by the first."

    | column |

    column := (self getParameter:1 withDefault:1).
    Debug ifTrue:[
        Transcript show:'move to column:'; showCR:column.
    ].    
    self cursorVisibleLine:cursorLine col:column.
!

moveToLine
    "Move to the line indicated by the first param."

    | row |

    row := (self getParameter:1 withDefault:1).
    Debug ifTrue:[
        Transcript show:'move to row:'; showCR:row.
    ].    
    self cursorVisibleLine:row col:cursorCol.
!

moveToX: xLocation y: yLocation
    "Position the cursor at the location given by xLocation and yLocation.
     Ignore the command if the parameters are outside the allowable range."

    Debug ifTrue:[
        Transcript show:'numberOfColumns '; showCR:numberOfColumns.
        Transcript show:'numberOfLines '; showCR:numberOfLines.
    ].
"/    (xLocation < 1 or: [xLocation > numberOfColumns]) ifTrue: [^self].
"/    (yLocation < 1 or: [yLocation > numberOfLines]) ifTrue: [^self].

    self cursorVisibleLine:yLocation col:xLocation.

    "Created: / 10.6.1998 / 14:40:49 / cg"
    "Modified: / 20.6.1998 / 20:27:11 / cg"
!

report
    self halt:'unimplemented function'
!

reportTerminalType
    "currently, only cursor position is supported (param 6)"

    (parameters at: 1) == 6 ifTrue:[
        "/ report position
        self endEntry.
        Debug ifTrue:[
            Transcript showCR:'report terminal type'
        ].
        inStream nextPut:(Character esc).
        inStream nextPutAll:'[' 
                            , cursorLine printString 
                            , ';' 
                            , cursorCol printString
                            , 'R'.
        ^ self
    ].
    (parameters at: 1) == 7 ifTrue:[
        "/ display name 
    ].

    "Created: / 11.6.1998 / 23:05:50 / cg"
    "Modified: / 28.7.1998 / 00:54:30 / cg"
!

resetDefaults
    "Reset the default parameters"

    |l1 l2|


    l1 := (parameters at: 1).
    l2 := (parameters at: 2).
    Debug ifTrue:[
        Transcript show:'resetDefaults:'; show:l1;show:' ';showCR:l2.
    ].
    (l1 ~~ 0 and:[l2 ~~ 0]) ifTrue:[
        rangeStartLine := l1.
        rangeEndLine := l2.
    ] ifFalse:[
"/        self halt.
    ].

"/    (rangeStartLine == 1 and:[rangeEndLine == numberOfLines]) ifTrue:[
"/        rangeEndLine := rangeStartLine := nil.
"/    ].

    alternateKeypadMode := false.
"/    autoLineFeed := false.
"/    autoMargin := true.
"/    displayMode := 0.                "Normal display"!! !!

    "Created: / 10.6.1998 / 14:50:53 / cg"
    "Modified: / 20.6.1998 / 20:28:26 / cg"
! !

!VT100TerminalView methodsFor:'initialization'!

initialize
    super initialize.

    autoWrapFlag := true.
    alternateKeypadMode := false.
    parameters := Array new:8.
    self endOfSequence

    "Created: / 10.6.1998 / 14:46:07 / cg"
    "Modified: / 13.6.1998 / 13:58:01 / cg"
!

initializeKeyboardSequences
    "setup my keyboard sequences for a vt100"

    kbdSequences := (self vt100KeyCodes)

    "Modified: / 9.6.1998 / 20:49:21 / cg"
    "Created: / 10.6.1998 / 15:12:32 / cg"
! !

!VT100TerminalView methodsFor:'misc'!

traceCSI:char
    state infoPrint. '-' infoPrint. 
    char codePoint > 32 ifTrue:[
        char infoPrint. 
    ] ifFalse:[
        '0x' infoPrint. char codePoint hexPrintString infoPrint. 
    ].
    currentParam > 1 ifTrue:[
        ' ' infoPrint. 
        (parameters at:1) infoPrintCR.

        currentParam > 2 ifTrue:[
            ' ' infoPrint. 
            (parameters at:2) infoPrintCR.

            currentParam > 3 ifTrue:[
                ' ' infoPrint. 
                (parameters at:3) infoPrintCR.
            ].
        ].
    ].
! !

!VT100TerminalView methodsFor:'os functions (xterm)'!

osCommand
    "this is an xterm escape sequence, which controls
     the window's title, icon, or other property"
     
    |cmdKey cmdValue|

    cmdKey := parameters at:1.
    cmdValue := parameters at:2.

    cmdKey == 0 ifTrue:[
        "/ change icon name and window title
        masterWindow notNil ifTrue:[
            masterWindow label:cmdValue.
            masterWindow iconLabel:cmdValue.
        ].
        self endOfSequence.
        ^ self.
    ].
    cmdKey == 1 ifTrue:[
        "/ change icon name
        masterWindow notNil ifTrue:[
            masterWindow iconLabel:cmdValue.
        ].
        self endOfSequence.
        ^ self.
    ].
    cmdKey == 2 ifTrue:[
        "/ change window title
        masterWindow notNil ifTrue:[
            masterWindow label:cmdValue.
        ].
        self endOfSequence.
        ^ self.
    ].
    cmdKey == 3 ifTrue:[
        "/ set x property
        self endOfSequence.
        ^ self.
    ].
    cmdKey == 4 ifTrue:[
        "/ change color
        self endOfSequence.
        ^ self.
    ].
    self breakPoint:#cg.
    self endOfSequence
! !

!VT100TerminalView methodsFor:'processing-input'!

addToParameter:char
    "The parameter char is a digit. Add it to the current parameter."

    | param |

    param := (parameters at:currentParam) ? 0.
    parameters at:currentParam put:(param * 10 + char digitValue)

    "Created: / 10.6.1998 / 14:39:00 / cg"
!

endOfSequence
    "private - reset state-machine at end of escape-sequence"

    state := 0. 
    currentParam := 1. 
    "/ parameters := Array new:8 withAll:0.
    parameters atAllPut:nil.

    "Created: / 10.6.1998 / 14:30:40 / cg"
    "Modified: / 10.6.1998 / 14:30:57 / cg"
!

evaluateProcessCharacter:char return:aSymbol
    " evaluate the return value of the process state method except for state 0
    "

    aSymbol isNil ifTrue:[
        ^ self.
    ].
    aSymbol == #waitForNextChar ifTrue:[
        ^ self.
    ].
    aSymbol == #unknown ifTrue:[
        ('VT100TerminalView [info]: unknown character %1 in state %2'
            bindWith:(char codePoint hexPrintString)
            with:state) infoPrintCR.
        self doNothing.
        ^ self
    ].
    aSymbol == #sequenceComplete ifTrue:[
        self endOfSequence.
        ^ self.
    ].
    self halt:'unexpected return value from state processing'
!

nextPut:char 
    " process a character (i.e. from the shell's output)"

    |processCharacterReturn|

    Debug ifTrue:[
        Transcript                                                       
            show:'VT100: nextPut - state: '; show:state;
            show:' got: ';
            showCR:char storeString
    ].
"/ char == Character return ifTrue:[self halt].
    state == 0 ifTrue:[
        processCharacterReturn := self processState0:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self
    ].
    state == #gotReturn ifTrue:[
        processCharacterReturn := self processStateGotReturn:char.
        processCharacterReturn == #sequenceComplete ifTrue:[
            self endOfSequence.
            ^ self.
        ].
        ^ self
    ].
    state == #gotESC ifTrue:[
        processCharacterReturn := self processStateGotESC:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    state == #gotCSI ifTrue:[
        processCharacterReturn := self processStateGotCSI:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    state == #gotCSI2 ifTrue:[
        processCharacterReturn := self processStateGotCSI2:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    state == #gotCSI3 ifTrue:[
        processCharacterReturn := self processStateGotCSI3:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    state == #gotXTERMCSI ifTrue:[
        processCharacterReturn := self processStateGotXTERMCSI:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    state == #gotXTERMCSI2 ifTrue:[
        processCharacterReturn := self processStateGotXTERMCSI2:char.
        self evaluateProcessCharacter:char return:processCharacterReturn.
        ^ self.
    ].
    self halt:'unknown state'.
    self doNothing.
    ^ self
!

processState0:char 
    "next char in initial state
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char codePoint < 32 ifTrue:[
        (char == Character esc) ifTrue:[
            state := #gotESC.
            ^ #waitForNextChar
        ].

        (    char == Character nl   "nl or '\n'"
        or:[(char == (Character value:16r0b))]) ifTrue:[
            translateNLToCRNL == true ifTrue:[
                self endEntry.
                self cursorToBeginOfLine.
            ].
            self endEntry.
            self doCursorDown:1.
            ^ #waitForNextChar.
        ].

        (char == Character return) ifTrue:[
            (rangeEndLine notNil and:[rangeEndLine ~~ numberOfLines]) ifTrue:[
                self endEntry.
                self cursorToBeginOfLine.
            ] ifFalse:[
                state := #gotReturn.
            ].
            ^ #waitForNextChar.
        ].

        (char == Character backspace) ifTrue:[
            self endEntry.
            self cursorLeft.
            ^ #waitForNextChar    "/ doBackspace
        ].

        (char == Character bell) ifTrue:[
            self shown ifTrue:[
                self beep.
            ].
            ^ #waitForNextChar
        ].

        (char == (Character value:5)) ifTrue:[
            "/ Transmission answerback message
            self reportTerminalType.
            ^ #waitForNextChar                         
        ].

        (    char == (Character value:16r18) "/Cancel
        or:[ char == (Character value:16r1A) "/Substitute
        ]) ifTrue:[
            self nextPut:(Character value:16r2).
            ^ #waitForNextChar                         
        ]

        "
        all unsupported control characters (also vt102):
        Character value:16r3    ->End of text
        Character value:16r4    ->End of transmission
        Character tab           ->Horizontal tab
        Character value:16rc    ->Form feed
        Character value:16re    ->SO shift out
        Character value:16rf    ->SI shift in
        Character value:16r11   ->Device control 1
        Character value:16r13   ->Device control 3
        ".
        char ~~ Character tab ifTrue:[
            char codePoint ~~ 0 ifTrue:[
                ('VT100 [info]: unhandled control key: ' , char storeString) infoPrintCR.
            ].
            ^ #waitForNextChar.
        ]
    ].
    self show:char.
    ^ nil
!

processStateGotCSI2:char
    "next char after 'ESC [ ?' (CSI ?)
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char == $; ifTrue: [
        currentParam := (currentParam + 1) min: 8.
        ^ #waitForNextChar
    ].
    char isDigit ifTrue: [
        self addToParameter:char.
        ^ #waitForNextChar
    ].

    TraceCSI == true ifTrue:[ self traceCSI:char ].
    (char == $l or:[char == $h]) ifTrue: [
        "/ (parameters at: 1) = 1 ifTrue: [app_cur_keys:(char == $h) "DECCKM"].
        "/ (parameters at: 1) = 2 ifTrue: [vt52mode:(char == $l) "DECANM"].
        "/ (parameters at: 1) = 3 ifTrue: [mode132:(char == $h) "DECCOLM"].
        "/ (parameters at: 1) = 4 ifTrue: [smoothScroll:(char == $h) "DECSCLM"].
        "/ (parameters at: 1) = 5 ifTrue: [reverseVideo:(char == $h) "DECSCNM"].
        "/ (parameters at: 1) = 6 ifTrue: [originMode:(char == $h) "DECOM"].
        "/ (parameters at: 1) = 8 ifTrue: [autoKbdRepeat:(char == $h) "DECARM"].
        "/ (parameters at: 1) = 25 ifTrue: [cursorVisible:(char == $h) "DECTCEM"].
        self endEntry.
        (parameters at: 1) = 7 ifTrue: [self autoMargin:(char == $h) "DECAWM"].
        ^ #sequenceComplete
    ].
    (char == $n) ifTrue: [
        "/ (parameters at: 1) = 15 ifTrue: [ ... ]. -- What is the printer status?
        "/ (parameters at: 1) = 25 ifTrue: [ ... ]. -- Are user-defined keys locked or unlocked?
        "/ (parameters at: 1) = 26 ifTrue: [ ... ]. -- What is the keyboard language?
    ].    
    ^ #unknown
!

processStateGotCSI3:char
    "next char after 'ESC ('
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    TraceCSI == true ifTrue:[ self traceCSI:char ].
    ^ #unknown
!

processStateGotCSI:char
    "next char after 'ESC> [' (CSI)
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char == $? ifTrue: [
        state := #gotCSI2.
        ^ #waitForNextChar
    ].
    char == $; ifTrue:[
        currentParam := (currentParam + 1) min: 8.
        ^ #waitForNextChar
    ].
    char isDigit ifTrue: [
        self addToParameter:char.
        ^ #waitForNextChar
    ].

    TraceCSI == true ifTrue:[ self traceCSI:char ].
    char == $@ ifTrue: [
        self endEntry.
        self insertCharacters.
        ^ #sequenceComplete
    ].
    char == $A ifTrue: [
        "/ ESC[#A                         - Moves cursor up # lines
        self endEntry.
        self doCursorUp:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    char == $B ifTrue: [
        "/ ESC[#B                         - Moves cursor down # lines
        self endEntry.
        self doCursorDown:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    char == $C ifTrue: [
        "/ ESC[#C                         - Moves cursor forward # spaces
        self endEntry.
        self doCursorRight:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    char == $D ifTrue: [
        "/ ESC[#D                         - Moves cursor back # spaces
        self endEntry.
        self doCursorLeft:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    char == $E ifTrue: [
        "/ ESC[#E                         
        self endEntry.
        self doCursorNextLine:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    char == $F ifTrue: [
        "/ ESC[#F                         
        self endEntry.
        self doCursorPreviousLine:(self getParameter:1 withDefault:1).
        ^ #sequenceComplete
    ].
    (char == $G) ifTrue: [
        "/ ESC[#;#G                       - Moves cusor to column # in current line
        self endEntry.
        self moveToColumn.
        ^ #sequenceComplete
    ].
    (char == $H or:[char == $f]) ifTrue: [
        "/ ESC[#;#H or ESC[#;#f           - Moves cusor to line #, column #
        self endEntry.
        self move.
        ^ #sequenceComplete
    ].
    char == $J ifTrue: [
        "/ ESC[0J                         - Clear screen to end 
        "/ ESC[1J                         - Clear screen from beginning 
        "/ ESC[2J                         - Clear entire screen and home cursor
        self endEntry.
        self doClearDisplay:(self getParameter:1 withDefault:0).
        ^ #sequenceComplete
    ].
    char == $K ifTrue: [
        "/ ESC[K                          - Clear to end of line
        self endEntry.
        self clearLines:(self getParameter:1 withDefault:0).
        Debug ifTrue:[
            Transcript showCR:'clear to EOL'.
        ].
        ^ #sequenceComplete
    ].
    char == $L ifTrue: [
        self endEntry.
        self insertLines.
        ^ #sequenceComplete
    ].
    char == $M ifTrue: [
        self endEntry.
        self deleteLines.
        ^ #sequenceComplete
    ].
    char == $P ifTrue: [
        self endEntry.
        self deleteCharacters.
        ^ #sequenceComplete
    ].
    char == $R ifTrue: [
        "/ ESC[#;#R                       - Reports current cursor line & column
        ^ #unknown
    ].

    char == $c ifTrue:[
        "/ terminal-type query 3
        self reportTerminalType.
        ^ #sequenceComplete
    ].
    char == $d ifTrue:[
        self endEntry.
        self moveToLine.
        ^ #sequenceComplete
    ].
    char == $n ifTrue: [
        self report.
        ^ #sequenceComplete
    ].
    char == $m ifTrue: [
        "/ character attributes (SGR)
        1 to:currentParam do:[:pI |
            self displayMode:(self getParameter:pI withDefault:0).
        ].
        ^ #sequenceComplete
    ].
    char == $r ifTrue: [
        self endEntry.
        self resetDefaults.
        ^ #sequenceComplete
    ].
    char == $s ifTrue: [
        "/ ESC[s                          - Saves cursor position for recall later
        self endEntry.
        ^ #sequenceComplete
    ].
    char == $u ifTrue: [
        "/ ESC[u                          - Return to saved cursor position
        self endEntry.
        ^ #sequenceComplete
    ].
    ^ #unknown
!

processStateGotESC:char
    "next char after ESC
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char == $[ ifTrue: [ 
        "/ ESC-[
        state := #gotCSI. 
        ^ #waitForNextChar
    ].
    char == $] ifTrue: [ 
        "/ ESC-]
        "/xterm sequence
        state := #gotXTERMCSI. 
        ^ #waitForNextChar
    ].
    char == $( ifTrue: [ 
        "/ ESC-(
        "/ todo: set-charset 0 ...
        state := #gotCSI3.
        ^ #waitForNextChar
    ].

    TraceCSI == true ifTrue:[ self traceCSI:char ].
    char == $) ifTrue: [ 
        "/ ESC-(
        "/ todo: set-charset 1 ...
        ^ #unknown
    ].
    char == $7 ifTrue:[
        "/ ESC-7
        self endEntry.
        self saveCursor.
        ^ #sequenceComplete
    ].
    char == $8 ifTrue:[
        "/ ESC-7
        self endEntry.
        self restoreCursor.
        ^ #sequenceComplete
    ].
    char == $M ifTrue:[
        "/ ESC-M cursor up
        self endEntry.
        self doCursorUp:1.
        ^ #sequenceComplete
    ].
    char == $D ifTrue:[
        "/ ESC-D Index cursor down one line in same column
        self endEntry.
        self doCursorDown:1.
        ^ #sequenceComplete
    ].
    char == $E ifTrue:[
        "/ ESC-E
        "/ TODO add_lines
        self endEntry.
        self cursorReturn.
        ^ #sequenceComplete
    ].
    (char == $Z) ifTrue:[
        "/ terminal-type query 2
        self reportTerminalType.
        ^ #sequenceComplete
    ].
    char == $= ifTrue: [
        "/ enter application keypad mode
        "/ ESC-=
        alternateKeypadMode := true.
        kbdSequences := (self vt100AlternativeKeyCodes).
        ^ #sequenceComplete
    ].
    char == $> ifTrue: [
        "/ exit application keypad mode
        "/ ESC-<
        alternateKeypadMode := false.
        kbdSequences := (self vt100KeyCodes).
        ^ #sequenceComplete
    ].
    ^ #unknown
!

processStateGotReturn:char
    "next char after CR
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    state := 0.
    char == Character nl ifTrue:[
        "/ cr-nl
        "/ stay in buffering mode.
        self cr.
        ^ #sequenceComplete.
    ].

    self endEntry.
    self cursorToBeginOfLine.

    (char == Character esc) ifTrue:[
        state := #gotESC.
    ].
    "/ continue in initial state
    ^ #waitForNextChar
!

processStateGotXTERMCSI2:char
    "next char after 'ESC ] ;'
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char == (Character value:7) ifTrue: [
        TraceCSI == true ifTrue:[ self traceCSI:char ].
        parameters at:currentParam put:(parameters at:currentParam) contents.
        self osCommand.
        ^ #sequenceComplete
    ].
    "/ add to parameter
    (parameters at:currentParam) nextPut:char.
    ^ #waitForNextChar
!

processStateGotXTERMCSI:char
    "next char after 'ESC ]'
     change state or processing character; 
     return 
        #waitForNextChar - state was changed and wait for next characters
        #sequenceComplete - command processed
        #unknown - unknown character for this state
    "

    char == $; ifTrue:[
        currentParam := (currentParam + 1) min: 8.
        parameters at:currentParam put:(WriteStream on:'').
        state := #gotXTERMCSI2. 
        ^ #waitForNextChar
    ].

    char isDigit ifTrue: [
        self addToParameter:char.
        ^ #waitForNextChar
    ].
    ^ #unknown
! !

!VT100TerminalView methodsFor:'queries'!

getParameter:para withDefault:default

    |parameter|

    parameter := (parameters at:para).
    ^ ((parameter isNil or:[parameter = 0]) ifTrue:[default] ifFalse:[parameter]).
!

terminalType
    "returns a string describing this terminal (usually, this is
     passed down to the shell as TERM environment variable).
     Here, 'vt100' is returned."

    "/ ^ 'xterm'.
    ^ 'vt100'

    "Created: / 10.6.1998 / 16:22:39 / cg"
    "Modified: / 5.5.1999 / 11:22:40 / cg"
! !

!VT100TerminalView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

