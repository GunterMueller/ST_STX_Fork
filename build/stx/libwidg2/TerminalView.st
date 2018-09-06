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

TextCollector subclass:#TerminalView
	instanceVariableNames:'inStream outStream readerProcess shellPid kbdSequences
		escapeSequenceTree currentSequence keyboardMap escapeLeadingChars
		numberOfColumns numberOfLines shellTerminateAction rangeStartLine
		rangeEndLine state savedCursor shellCommand shellDirectory
		filterStream recorderStream localEcho translateNLToCRNL
		inputTranslateCRToNL inputTranslateCRToCRNL
		inputTranslateBackspaceToDelete autoWrapFlag masterWindow
		alternateKeypadMode noColors sizeOfOutstandingInputToBeProcessed
		lineEditMode lineBuffer lineBufferCursorPosition
		lineBufferHistory lineBufferHistoryPosition
		lineBufferHistoryChanged maxHistorySize doUTF ignoreOutput
		sendControlKeys lastSelectedLineBufferHistoryPosition inputIsUTF8
		outputIsUTF8 signalControlKeys filterOnly'
	classVariableNames:'Debug DebugKeyboard DefaultMaxHistorySize'
	poolDictionaries:''
	category:'Views-TerminalViews'
!

!TerminalView class methodsFor:'documentation'!

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
    I provide terminal functionality, by interpreting data
    arriving from some stream (typically connected to a command interpreter 
    via a pty, or another system via a modem) and sending my keyboard data to it.

    I am abstract providing general functionality -
    concrete terminal characteristics (i.e. escape sequences) are defined 
    by concrete subclasses (see VT52TerminalView, VT100TerminalView).

    Concrete applications are: 
        consoles (VT100TerminalView),
        telnet-views (see TelnetTool)
        editor wrappers (if you like emacs/vi)
        gdb terminal subviews (see GDBApplication)

    Although my class protocol includes common startup protocol
    (to open a terminalView with a shell or on the output of a command),
    I can be used as a widget within an application (modem software).

    Implementation notice: 
        some of my pty functionality and handling is being extracted to
        the separate TerminalSession class (which allows communicating with a
        program without having its output displayed).   
        So currently, some ugly code duplication is present.
        Once stable, code will be refactored.   
        For now, as terminalView is being used in
        some of our critical applications, this refactoring has not yet been done.

    Line Editing mode:
     Cursor keys allow for th user to navigate through previously entered input (as in cmd.exe and bash).

     Special: <SHIFT>-cursor up goes back to the previously selected history line.
     (not to the previous line).
     For example, if the user types:
        a <RETURN>
        b <RETURN>
        c <RETURN>
        <CURSOR-UP> -> shows 'c'
        <CURSOR-UP> -> shows 'b'
        <CURSOR-UP> -> shows 'a'
        123 <RETURN> -> resends 'a123'
        <SHIFT-CURSOR-UP> -> shows 'a' again which is the previously selected history line(not a123)
        <CURSOR-DOWN> -> shows 'b'
        <RETURN> -> sends 'b'
    
    [author:]
        Claus Gittinger

    [instance variables:]
        inStream                stream where keyboard input is
                                sent to (connected to shells or commands input)

        outStream               stream where the output of the
                                shell or command arrives
                                (read here and displayed in the view)

        readerProcess           process which reads commands    
                                output and sends it to the view

        lineEditMode            if on, do readLine-alike input history and editing

        signalControlKeys       if on, CTRL-C sends an interrupt (for Windows)

    [class variables]:
        Debug := true           trace incoming characters
        Debug := false           
        DebugKeyboard := true   trace outgoing characters
        DebugKeyboard := false 


    [start with:]
        VT52TerminalView open
        VT100TerminalView open
        VT52TerminalView openShell
        VT100TerminalView openShell
        VT100TerminalView openOnCommand:'ls -l'
        VT100TerminalView openOnCommand:'dir'

    [see also:]
        TelNetTool
"
!

examples
"
  start a shell in the current directory:
                                                                [exBegin]
    TerminalView openShell
                                                                [exEnd]

  start a shell in a given directory:
                                                                [exBegin]
    TerminalView openShellIn:(OperatingSystem getHomeDirectory)
                                                                [exEnd]

  start another program current directory:
                                                                [exBegin]
    TerminalView openOnCommand:'ls -l'
                                                                [exEnd]

  start another program in some given directory:
                                                                [exBegin]
    TerminalView openOnCommand:'ls' in:'/etc'
                                                                [exEnd]

  specify how to react when the shell terminates:
                                                                [exBegin]
    TerminalView openOnCommand:'ls' in:'/etc' onExit:[:vt | vt topView destroy]
    TerminalView openOnCommand:'ls' in:'/etc' onExit:[:vt | Dialog information:'finished'. vt topView destroy]
                                                                [exEnd]

  special low level usage: no shell command, interact with the user myself
  (i.e. read the user's input, and intepret it myself):
                                                                [exBegin]
    |terminal in out inputLine|

    in := InternalPipeStream new.
    out := InternalPipeStream new.

    terminal := TerminalView openOnInput:in output:out.
    terminal localEcho:true.
    terminal inputTranslateCRToNL:true.
    terminal translateNLToCRNL:true.

    out nextPutLine:'Hello world - please type at me:'.

    [
        inputLine := in nextLine asString.
        inputLine ~= '#exit' ifTrue:[
            out nextPutLine:(Compiler evaluate:inputLine) printString.
        ].
        (inputLine = '#exit') or:[ terminal isOpen not ]
    ] whileFalse.

    terminal topView destroy.
                                                                [exEnd]
"
! !

!TerminalView class methodsFor:'initialization'!

initialize

    Debug := DebugKeyboard := false.
    DefaultMaxHistorySize := 1000.

    "
     self initialize
    "
! !

!TerminalView class methodsFor:'defaults'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'TerminalView defaultIcon'
        ifAbsentPut:[(Depth4Image new) width:48; height:36; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CL3L3L3L3L3L3L3L3L0@@@@@@@@@@@@@5UUUUUUUUUUUUUUUUUS@@@@@@@@@@@@MUUUUUUUUUUUUUUUUUUU
DP@@@@@@@@@@MUQDQDQDQDQDQDQDQEUUDP@@@@@@@@@@MUQDQDQDQDQDQDQDQDUUDQ@@@@@@@@@@MUQBIBQBP"H$P$QDQDUUDQ@@@@@@@@@@MUQDQDQDQDQD
QDQDQDUUDQD@@@@@@@@@MUQBH"P"P"IDQDQDQDUUDQD@@@@@@@@@MUQDQDQDQDQDQDQDQDUUDQDP@@@@@@@@MUQBH"H"H"P"H"QDQDUUDQDP@@@@@@@@MUQD
QDQDQDQDQDQDQDUUDQDP@@@@@@@@MUQBH$H"IBIDH"QDQDUUDQDP@@@@@@@@MUQDQDQDQDQDQDQDQDUUDQDP@@@@@@@@MUQBQDQDQDQDQDQDQDUUDQDP@@@@
@@@@MUQDQDQDQDQDQDQDQDUUDQDP@@@@@@@@MUQBH"P$H"P$QDQDQDUUDQDP@@@@@@@@MUQDQDQDQDQDQDQDQDUUDQDP@@@@@@@@MUQBP"H$QDQDQDQDQDUU
DQDP@@@@@@@@MUUDQDQDQDQDQDQDQEUUDQD@@@@@@@@@MUUUUUUUUUUUUUUUUUUUDQ@@@@@@@@@@@5UUUUUUUUUUUUUUUUUQDP@@@@@@@@@@@@@QDQDQDQDQ
DQDQDQDSL1D@@@@@@@@@@@@CL3L3L3L3L3L3L3L3LQD@@@@@@@@@@@@QDQDQDQDQDQDQDQDQDQD@@@@@@@@@@AUUUUUUUUUUUUUUUUUUDQD3@3@@@@@@@AUU
UUUUUUUUUU@@@@AUDQD@L@L@@@@@DQDQDQDQDQDQDQDQDQUUDQ@@@C@@@@@AUUUUUUUUUUUUUUUUUQDQD@@@@0@@@@@UUUUUUUUUUUUUUUUUTQ@@@@DQDQ@@
@@@UT"H"H"H"H"H"H%UUTQ@@DQDSL1@@@@EUUUUUUUUUUUUUUUUUDP@AEUTQL1@@@AURH"H"H"H"H"H"IUUQD@@AUUUSLP@@@UUUUUUUUUUUUUUUUUTQ@@@A
L3L1D@@@@QDQDQDQDQDQDQDQDQDP@@@ADQDQ@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 80 78 80 255 255 255 140 140 140 40 58 10 196 194 190]; mask:((ImageMask new) width:48; height:36; bits:(ByteArray fromPackedString:'
@@@@@@@@@O???>@@@_????@@@?????0@@?????0@@?????8@@?????8@@?????<@@?????<@@?????>@@?????>@@?????>@@?????>@@?????>@@?????>@
@?????>@@?????>@@?????>@@?????>@@?????<@@?????8@@_????0@@C????<@@A????<@@C????<@@O?????X@O????<$@?????8HA????? PC????8G8
C????8?8G????1?8O????!!?0_????A? _???>A?@@@@@@@@@') ; yourself); yourself]
!

defaultNumberOfColumns
    ^ 80

    "Created: / 4.8.1998 / 17:48:18 / cg"
    "Modified: / 4.8.1998 / 17:48:31 / cg"
!

defaultNumberOfLines
    ^ 25

    "Created: / 4.8.1998 / 17:48:18 / cg"
    "Modified: / 4.8.1998 / 17:48:31 / cg"
! !

!TerminalView class methodsFor:'opening'!

open
    ^ self openShell

    "
     VT100TerminalView open
     VT52TerminalView open
     TerminalView open
    "

    "Created: / 10.6.1998 / 15:47:25 / cg"
    "Modified: / 9.7.1998 / 17:55:37 / cg"
!

openDummy
    "for testing purposes only - opens a dummy tty-view, which simply
     echoes whatever is typed in"

    |in vt52|

    ForwardingStream isNil ifTrue:[ Smalltalk loadPackage:'stx:goodies' ].
    
    vt52 := self new.
    in := ForwardingStream on:''.

    in fwdStream:vt52.
    vt52 inStream:in.
    vt52 outStream:in.
    vt52 open

    "
     self openDummy
    "
!

openOnCommand:aCommandString
    "start a command on a pseudo-TTY, open a terminalView on it
     (i.e. this is kind of an xterm)"

    ^ self openOnCommand:aCommandString onExit:[]

    "
     VT100TerminalView openOnCommand:'ls -l'
    "

    "Created: / 9.7.1998 / 17:50:53 / cg"
    "Modified: / 9.7.1998 / 17:57:41 / cg"
!

openOnCommand:aCommand in:aDirectory
    "start a shell on a pseudo-TTY, open a terminalView on it
     (i.e. this is kind of an xterm)"

    ^ self openOnCommand:aCommand in:aDirectory onExit:[]
        
    "
     TerminalView openOnCommand:'ls'
     TerminalView openOnCommand:'ls' in:'/etc'
    "
!

openOnCommand:aCommandString in:aDirectory onExit:exitBlockOrNil
    "start a command on a pseudo-TTY, open a terminalView on its output
     (i.e. this is kind of an xterm).
     When the command finishes, evaluate aBlock."

    ^ self 
        openWithAction: [:vt | vt startCommand:aCommandString in:aDirectory ]
        onExit: exitBlockOrNil.

    "
     VT100TerminalView openOnCommand:'ls -l' in:'/etc' onExit:[]
     VT100TerminalView openOnCommand:'ls -l' in:'/etc' onExit:[:vt | vt topView destroy]
     VT100TerminalView openOnCommand:'ls -l' in:'/etc' onExit:[:vt | Dialog information:'Shell terminated'. vt topView destroy ]
    "

    "Created: / 9.7.1998 / 17:54:34 / cg"
    "Modified: / 4.8.1998 / 17:49:02 / cg"
!

openOnCommand:aCommandString onExit:aBlock
    "start a command on a pseudo-TTY, open a terminalView on its output
     (i.e. this is kind of an xterm).
     When the command finishes, evaluate aBlock."

    ^ self openOnCommand:aCommandString in:nil onExit:aBlock

    "
     VT100TerminalView 
        openOnCommand:'ls -lR' 
        onExit:[:vt | 
            Dialog information:'Press OK to close'.
            vt topView close.
        ].
    "
!

openOnInput:inStream output:outStream
    "open a terminalView on the given streams (which are typically some
     kind of socket or pty). 
     Keys pressed are sent to inStream, text appearing
     from outStream is displayed in the terminal view.
     This can be used to implement things like rlogin
     or telnet views (if connected to a modem, a com-program can also be
     implemented this way)."

    |top vt|

    top := StandardSystemView new.
    vt := self openOnInput:inStream output:outStream in:top.
    vt masterWindow:top.

    top extent:(vt preferredExtent).
    top label:'shell'.
    top iconLabel:'shell'.
    top icon:(self defaultIcon).
    top open.
    ^ vt

    "Modified: / 5.5.1999 / 17:25:59 / cg"
!

openOnInput:inStream output:outStream in:aView
    "open a terminalView on the given streams 
     (which are typically some kind of socket or pty). 
     Keys pressed are sent to inStream, text appearing
     from outStream is displayed in the terminal view.
     This can be used to implement things like rlogin
     or telnet views (if connected to a modem, a com-program can also be
     implemented this way)."

    |scr vt|

    scr := ScrollableView for:self in:aView.
    scr origin:0.0@0.0 corner:1.0@1.0.
    vt := scr scrolledView.

    vt inStream:inStream.
    vt outStream:outStream.
    vt startReaderProcessWhenVisible.

    ^ scr

    "Modified: / 5.5.1999 / 17:25:59 / cg"
!

openShell
    "start a shell on a pseudo-TTY, open a terminalView on it
     (i.e. this is kind of an xterm)"

    ^ self openShellIn:nil

    "
     VT100TerminalView openShell
    "

    "Modified: / 21.7.1998 / 18:24:55 / cg"
!

openShellIn:aDirectory
    "start a shell on a pseudo-TTY, open a terminalView on it
     (i.e. this is kind of an xterm)"

    ^ self openWithAction:[:vt | vt startShellIn:aDirectory]

    "
     TerminalView openShellIn:'/etc'
     VT52TerminalView openShellIn:'/etc'
     VT100TerminalView openShellIn:'/etc'
    "

    "Created: / 20.7.1998 / 18:28:15 / cg"
    "Modified: / 5.5.1999 / 17:27:10 / cg"
!

openShellIn:aDirectory onExit:exitAction
    "start a shell on a pseudo-TTY, open a terminalView on it
     (i.e. this is kind of an xterm)"

    ^ self openWithAction:[:vt | vt startShellIn:aDirectory] onExit:exitAction

    "
     TerminalView openShellIn:'/etc' onExit:[ Dialog information:'Shell terminated' ]
    "
!

openWithAction:setupAction
    "open a terminalView, let it start its command via setupAction, 
     which gets the instantiated terminalView as argument."

    ^ self openWithAction:setupAction onExit:[:vt | vt topView destroy]

    "
     TerminalView openWithAction:[:vt | vt startShellIn:'/etc']
     TerminalView openWithAction:[:vt | vt startCommand:'ls -l' in:'/etc'.  vt shellTerminateAction:[].]
    "
!

openWithAction:setupAction onExit:exitBlockOrNil
    "open a terminalView, let it start its command via setupAction, 
     which gets the instantiated terminalView as argument.
     The default exitAction is to destroy the topView."

    | top scr vt lbl|

    lbl := OperatingSystem isUNIXlike ifTrue:['shell'] ifFalse:['dos'].

    top := StandardSystemView new.
    scr := HVScrollableView for:self in:top.
    scr origin:0.0@0.0 corner:1.0@1.0.
    vt := scr scrolledView.
    exitBlockOrNil isNil ifTrue:[
        vt shellTerminateAction:[ top destroy ]
    ] ifFalse:[        
        vt shellTerminateAction:[
            top label:(lbl,' - terminated').
            exitBlockOrNil valueWithOptionalArgument:vt.
        ].
    ].
    vt masterWindow: top.

    top extent:(scr preferredExtent).
    top label:lbl.
    top iconLabel:lbl.
    top icon:(self defaultIcon).
    top open.

    setupAction value:vt.

    ^ vt

    "
     TerminalView openWithAction:[:vt | vt startShellIn:'/etc']
     TerminalView openWithAction:[:vt | vt startCommand:'ls -l' in:'/etc'.  vt shellTerminateAction:[].]
    "
! !

!TerminalView class methodsFor:'queries'!

isVisualStartable
    "returns whether this application class can be started via #open"

    self == TerminalView ifTrue:[^ false].
    ^ true

    "Created: / 10.6.1998 / 15:48:43 / cg"
! !

!TerminalView methodsFor:'accessing'!

filterStream
    "get a filter stream if any; if not nil, it gets all incoming data via nextPutAll:.
     Added to allow saving incoming data to a file, but can also be used to catch/filter/lookAt
     incoming data by some other program"

    ^ filterStream
!

filterStream:aStream
    "set a filter stream; if not nil, it gets all incoming data via nextPutAll:.
     Added to allow saving incoming data to a file, but can also be used to catch/filter/lookAt
     incoming data by some other program"

    filterStream := aStream.

    "Created: / 28.1.2002 / 20:56:04 / micha"
    "Modified: / 28.1.2002 / 20:56:11 / micha"
!

inStream
    "return the stream, which gets all input data (i.e. keyboard input)"

    ^ inStream
!

inStream:something
    "set the stream, which gets all input data (i.e. keyboard input)"

    inStream := something.
!

innerHeight
    | innerHeight |

    "/ Redefined to take into account the height of
    "/ horizontal scroller at the bottom. This is to make
    "/ sure that last line is always fully visible, otherwise
    "/ user may not actually see what is she typing.
    innerHeight := super innerHeight.
    (superView notNil and:[superView isScrollWrapper ]) ifTrue:[ 
        innerHeight := innerHeight - superView horizontalScrollBar height.
    ].
    ^ innerHeight

    "Created: / 29-07-2018 / 21:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineBufferHistory
    ^ lineBufferHistory
!

lineBufferHistory:aCollection
    aCollection isNil ifTrue:[
        lineBufferHistory := OrderedCollection new.
    ] ifFalse:[
        lineBufferHistory := OrderedCollection withAll:aCollection.
    ].
    lineBufferHistoryPosition := lineBufferHistory size + 1.
    lineBufferHistoryChanged := false.
!

lineBufferHistoryChanged
    "true if it changed since either set explicitly or since the terminal was opened"
    
    ^ lineBufferHistoryChanged ? false
!

masterWindow:aTopView
    "if set, and a corresponding osCommand escape sequence is received,
     that topView's title, icon or other attribute is changed.
     Needed to support xterm's 'set window title' escape sequence"
     
    masterWindow := aTopView.
!

outStream
    "return the stream, which is used to present data in the view (i.e. shell output)"

    ^ outStream
!

outStream:something
    "set the stream, which is used to present data in the view (i.e. shell output)"

    outStream := something.
!

readerProcess
    ^ readerProcess
!

recorderStream:aWriteStream
    "set a recorder stream; if not nil, it gets all user input (keyboard) data via nextPut:.
     Allows saving of user input to a file, for later replay of a session"

    recorderStream := aWriteStream.
!

shellDirectory:aPathname
    "the directory, in which the shell/command should be executed.
     By default, the 'current' directory is used"
     
    shellDirectory := aPathname.
!

shellTerminateAction:aBlock
    "set the block which is evaluated when the shell terminates.
     Can be used to close down the application or perform any other cleanup action.
     The default shows a dialog, that the shell/command has terminated"

    shellTerminateAction := aBlock.

    "Created: / 12.6.1998 / 17:02:58 / cg"
! !

!TerminalView methodsFor:'accessing - behavior'!

filterOnly:aBoolean
    "if true, any output from the program is ONLY
     sent to the filterStream (if any), not to the window.
     Can be used to divert output to a file, without showing
     it (eg. for mass-data recording)"

    filterOnly := aBoolean
!

ignoreOutput:aBoolean
    "if true, any output from the program is ignored
     (not processed at all).
     Can be used to temporarily disable processing
     (for example via a button) when huge mass-output is 
     coming which we want to ignore."
    
    ignoreOutput := aBoolean
!

inputTranslateBackspaceToDelete
   "translating backspace to delete on user input"
   
    ^ inputTranslateBackspaceToDelete
!

inputTranslateBackspaceToDelete:aBoolean
    inputTranslateBackspaceToDelete := aBoolean.
!

inputTranslateCRToNL
    "translating <RETURN> to <NL> on user input"

    ^ inputTranslateCRToNL
!

inputTranslateCRToNL:aBoolean
    "translate <RETURN> to <NL> on user input"

    inputTranslateCRToNL := aBoolean.
!

lineEditMode:aBoolean
    "if true, I do some limited line editing for the user's input;
     the user can use cursor keys to navigate in the input history and
     reissue a previously entered input line.
     Special: <SHIFT>-cursor up goes back to the previously selected history line.
     (not to the previous line).
     For example, if the user types:
        a <RETURN>
        b <RETURN>
        c <RETURN>
        <CURSOR-UP> -> shows 'c'
        <CURSOR-UP> -> shows 'b'
        <CURSOR-UP> -> shows 'a'
        123 <RETURN> -> resends 'a123'
        <SHIFT-CURSOR-UP> -> shows 'a' again which is the previously selected history line(not a123)
        <CURSOR-DOWN> -> shows 'b'
        <RETURN> -> sends 'b'
    "

    lineEditMode := aBoolean.
!

localEcho:aBoolean
    "enable/disable local echo"

    localEcho := aBoolean

    "Created: / 5.5.1999 / 17:53:16 / cg"
!

noColors
    "the noColors boolean disables color changes (from color rendition escape sequences)"
    
    ^ noColors
!

noColors:aBoolean
    "the noColors boolean disables color changes (from color rendition escape sequences)"

    noColors := aBoolean.
!

sendControlKeys
    "there is some conflict with control key handling, for keys such as CTRL-c:
     it is both a shortcut (eg. Copy) and sometimes required in the terminal (interrupt key).
     For this, we look if there is a current selection, and if so, always treat it as a 
     shortcut (and NOT sending it to the terminal's program).
     Otherwise, if there is no selection, look at the 'sendControlKeys' boolean.
     If it is set (which is the default), then send it to the terminal, otherwise perform the editor op.
     Thus, an application containing me can offer a menu function (or toggle), 
     to control this behavior on the UI level."

    ^ sendControlKeys
!

sendControlKeys:aBoolean
    "there is some conflict with control key handling, for keys such as CTRL-c:
     it is both a shortcut (eg. Copy) and sometimes required in the terminal (interrupt key).
     For this, we look if there is a current selection, and if so, always treat it as a 
     shortcut (and NOT sending it to the terminal's program).
     Otherwise, if there is no selection, look at the 'sendControlKeys' boolean.
     If it is set (which is the default), then send it to the terminal, otherwise perform the editor op.
     Thus, an application containing me can offer a menu function (or toggle), 
     to control this behavior on the UI level."

    sendControlKeys := aBoolean
!

signalControlKeys
    "if true (default on Windows), CTRL-C sends an interrupt to 
     the program. Otherwise, it is sent as a character (0x03)"

    ^ signalControlKeys
!

signalControlKeys:aBoolean
    "if true (default on Windows), CTRL-C sends an interrupt to 
     the program. Otherwise, it is sent as a character (0x03)"

    signalControlKeys := aBoolean
!

translateNLToCRNL
    "translate NL to CRNL on output"
    
    ^ translateNLToCRNL

    "Created: / 28.1.2002 / 20:32:10 / micha"
!

translateNLToCRNL:aBoolean
    "translate NL to CRNL on output"

    translateNLToCRNL := aBoolean.

    "Created: / 28.1.2002 / 20:32:10 / micha"
! !

!TerminalView methodsFor:'cursor handling'!

cursorDown:n
    cursorLine + n > list size ifTrue:[
        list := list , (Array new:n).
        self textChanged.
    ].
    super cursorDown:n

    "Modified: / 10.6.1998 / 17:18:41 / cg"
    "Created: / 10.6.1998 / 17:18:50 / cg"
!

cursorMovementAllowed
    "return true, if the user may move the cursor around
     (via button-click, or cursor-key with selection).
     Here false is returned - the cursor is only moved by
     cursor positioning escape sequences arriving from the
     stream."

    ^ false

    "Created: / 18.6.1998 / 14:12:02 / cg"
!

numberOfTerminalCols
    ^ numberOfColumns
!

numberOfTerminalColumns
    ^ numberOfColumns

    "Created: / 5.5.1999 / 11:46:25 / cg"
!

numberOfTerminalLines
    "/ be careful - this is NOT called numberOfLines,
    "/ since that would interfere with numberOfLines as defined
    "/ in ListView ...
    "/ ... one of the bad sides of subclassing

    ^ numberOfLines

    "Created: / 5.5.1999 / 11:46:18 / cg"
    "Modified: / 5.5.1999 / 11:47:24 / cg"
!

restoreCursor
    |l c|

    savedCursor isNil ifTrue:[
        l := c := 1.
    ] ifFalse:[
        l := savedCursor y.
        c := savedCursor x.
    ].
    self cursorLine:l col:c.

    "Created: / 14.8.1998 / 13:49:24 / cg"
!

saveCursor
    savedCursor := cursorCol @ cursorLine

    "Created: / 14.8.1998 / 13:48:45 / cg"
    "Modified: / 14.8.1998 / 13:49:32 / cg"
!

validateCursorCol:col inLine:line
    "check of col is a valid cursor position; return a new col-nr if not.
     Here, the linelength is enforced"

    col > numberOfColumns ifTrue:[
        autoWrapFlag ifTrue:[
            self endEntry.
            self cursorLine:(self cursorLine + 1) col:1 " (col-numberOfColumns) ".
            ^ 1.
        ].
    ].
    ^ col min:numberOfColumns

    "Modified: / 10.6.1998 / 15:09:41 / cg"
! !

!TerminalView methodsFor:'defaults'!

anyKeyCodes
    ^ IdentityDictionary withKeysAndValues:
        #(
             #Escape      '\e'
             #BackSpace   '\b'
             #Return      '\r'
             #Delete      '\0177'
             #Tab         '\t'
         )

    "Created: / 5.5.1999 / 15:00:37 / cg"
! !

!TerminalView methodsFor:'event handling'!

computeNumberOfLinesShown
    |prevNLines prevNCols|

    prevNCols := (innerWidth // gc font width).
    prevNLines := nFullLinesShown.

    super computeNumberOfLinesShown.

    ((innerWidth // gc font width) ~~ prevNCols
    or:[prevNLines ~~ nFullLinesShown]) ifTrue:[
        self defineWindowSize.
    ]

    "Created: / 12.6.1998 / 22:34:39 / cg"
    "Modified: / 20.6.1998 / 19:45:28 / cg"
!

contentsChanged
    "this one is sent, whenever contents changes its size"

    super contentsChanged.
    "/ self defineWindowSize.

    "Modified: / 11.6.1998 / 22:51:48 / cg"
    "Created: / 5.5.1999 / 16:30:15 / cg"
!

defineWindowSize
    | delta prevNumCols prevNumLines|

"/self halt.
"/self realized ifFalse:[
"/    "/ iconfified
"/    ^ self
"/].
    numberOfColumns := (innerWidth // gc font width).
    delta := numberOfLines - rangeEndLine.
    numberOfLines := nFullLinesShown.
    ((prevNumCols == numberOfColumns)
    and:[prevNumLines == numberOfLines]) ifTrue:[
        ^ self
    ].

    rangeEndLine notNil ifTrue:[
        rangeEndLine := numberOfLines - delta.
    ].

    "/ any idea, how to do this under windows ?

    OperatingSystem isUNIXlike ifTrue:[
        "/
        "/ tell the pty;
        "/ tell the shell;
        "/
        (inStream notNil 
        and:[inStream isExternalStream
        and:[inStream isOpen]]) ifTrue:[
            Debug ifTrue:[
                Transcript showCR:'VT100: windowSize changed nLines to ', numberOfLines printString.
            ].
            (OperatingSystem 
                setWindowSizeOnFileDescriptor:inStream fileDescriptor
                width:numberOfColumns
                height:numberOfLines
            ) ifFalse:[
                Debug ifTrue:[
                    Transcript showCR:'VT100: cannot change windowSize'.
                ].
            ].
        ].
        shellPid notNil ifTrue:[
            OperatingSystem sendSignal:OperatingSystem sigWINCH to:shellPid
        ]
    ].

    prevNumCols := numberOfColumns.
    prevNumLines := numberOfLines.

    "Created: / 11-06-1998 / 22:51:39 / cg"
    "Modified: / 17-07-2014 / 19:40:45 / cg"
!

extendSelectionToX:x y:y setPrimarySelection:aBoolean
    | savedCursorLine savedCursorCol |

    "/ We must preserve the cursor position here. Cursor position
    "/ is controlled by the client after we send it a control 
    "/ sequence!!
    savedCursorLine := cursorLine.
    savedCursorCol  := cursorCol.
    super extendSelectionToX:x y:y setPrimarySelection:aBoolean.
    self setCursorLine: savedCursorLine col: savedCursorCol

    "Created: / 13-06-2017 / 14:35:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:logicalKey x:x y:y
    <resource: #keyboard (#Control #Control_L #Control_R
                          #Shift #Shift_L #Shift_R
                          #Alt #Alt_L #Alt_R
                          #Cmd #Cmd_L #Cmd_R
                          #Meta #Meta_L #Meta_R
                          #Return)>

    |rest event rawKey seq shortCut|

    ( #(ZoomIn ZoomOut ZoomInAll ZoomOutAll) includes:logicalKey) ifTrue:[
        super keyPress:logicalKey x:x y:y.
    ].
    
    "/ somewhat complicated, since some characters
    "/ should go untranslated (CTRL-key),
    "/ even if defined as function keys.

    inStream isNil ifTrue:[^ self].

    DebugKeyboard ifTrue:[
        Transcript showCR:'----'; show:'keyPress:' ; showCR:logicalKey printString.
    ].
    self shouldProcessInputInLineEditMode ifTrue:[
        (self keyPressInLineEditMode:logicalKey) ifTrue:[^ self].
    ].

    logicalKey isCharacter ifTrue:[
        self deselect.

        localEcho ifTrue:[
            self nextPut:logicalKey.
            self flush.
        ].
        "/ send it down to inStream ...
        self sendCharacter:logicalKey.
        ^ self
    ].

    (#(Control Control_L Control_R
      Shift Shift_L Shift_R
      Alt Alt_L Alt_R
      Cmd Cmd_L Cmd_R
      Meta Meta_L Meta_R) includes:logicalKey) ifTrue:[
        ^ self
    ].

    "/
    "/ common translations (Tab, Backspace, F-keys etc.)
    "/
    (logicalKey == #Return
    and:[inputTranslateCRToNL]) ifTrue:[
        seq := '\n'.
    ] ifFalse:[
        (logicalKey == #BackSpace
        and:[inputTranslateBackspaceToDelete]) ifTrue:[
            seq := kbdSequences at:#Delete ifAbsent:[ kbdSequences at:logicalKey ifAbsent:nil ].
        ] ifFalse:[
            seq := kbdSequences at:logicalKey ifAbsent:nil.
        ].
    ].

    seq notNil ifTrue:[
        DebugKeyboard ifTrue:[
            Transcript show:'->' ; showCR:seq storeString.
        ].
        seq := seq withoutCEscapes.

        localEcho ifTrue:[
            seq do:[:k | self nextPut:k].
            self flush.
        ].
        self send:seq.
        ^ self
    ].

    self sensor ctrlDown ifTrue:[
        (logicalKey startsWith:'Ctrl') ifTrue:[
            rawKey := logicalKey
        ] ifFalse:[
            "/ already translated - undo it.
        
            event := WindowGroup lastEventQuerySignal query.
            rawKey := event rawKey.
            rawKey isCharacter ifTrue:[
                rawKey := 'Ctrl' , rawKey.
            ]
        ]
    ] ifFalse:[
        rawKey := self keyboardMap bindingForLogical:logicalKey.
        rawKey isNil ifTrue:[
            "/ Try aliases...
            | rawKeys |

            rawKeys := self keyboardMap aliasesForLogical: logicalKey.
            rawKeys notEmpty ifTrue:[ 
                rawKey := rawKeys anyOne.
            ].
        ].
        rawKey isNil ifTrue:[ 
            rawKey := logicalKey
        ].
    ].

    "/
    "/ care for function-keys, which are mapped to Ctrl-x;
    "/
    DebugKeyboard ifTrue:[
        Transcript show:'raw ->' ; showCR:rawKey storeString.
    ].
    
    "/ there is some conflict here, for keys such as CTRL-c:
    "/ it is both a shortcut (eg. Copy) and sometimes required in the terminal (interrupt key).
    "/ For this, we look if there is a current selection, and if so, always treat it as a 
    "/ shortcut (and NOT sending it to the terminal's program).
    "/ Otherwise, if there is no selection, look at the "sendControlKeys" boolean.
    "/ If it is set (which is the default), then send it to the terminal, otherwise perform the editor op.
    "/ Thus, an application containing me can offer a menu function (or toggle), to control this behavior
    "/ on the UI level.
    
    shortCut := device keyboardMap mappingFor:logicalKey.
    (shortCut notNil and:[shortCut isSymbol]) ifTrue:[
        (sendControlKeys not or:[ self hasSelection or:[ shortCut == #Paste] ]) ifTrue:[
            DebugKeyboard ifTrue:[
                Transcript showCR:'internal handling'.
            ].
            ^ super keyPress:shortCut x:x y:y
        ].
    ].    

    seq := kbdSequences at:rawKey ifAbsent:nil.
    seq notNil ifTrue:[
        DebugKeyboard ifTrue:[
            Transcript show:'seq ->' ; showCR:seq storeString.
        ].
        self send:(seq withoutCEscapes).
        ^ self
    ].

    (rawKey startsWith:'Ctrl') ifTrue:[
        rest := rawKey copyFrom:5.
        rest size == 1 ifTrue:[
            rest := rest at:1.
            (rest asLowercase between:$a and:$z) ifTrue:[
                DebugKeyboard ifTrue:[
                    Transcript show:'ctrl ->' ; showCR:(Character controlCharacter:rest) storeString.
                ].
                (signalControlKeys and:[rawKey == #Ctrlc]) ifTrue:[
                    self doSendInterrupt.
                    ^ self.
                ].
                self sendCharacter:(Character controlCharacter:rest).
                ^ self
            ].
        ]
    ].

    ((rawKey startsWith:'Control')
        or:[ (rawKey startsWith:'Shift')
        or:[ (rawKey startsWith:'Alt')
        or:[ (rawKey = 'Ctrl')
    ]]]) ifTrue:[
        DebugKeyboard ifTrue:[
            Transcript showCR:'modifier ignored'.
        ].
        ^ self
    ].
    (rawKey startsWith:'Cmd') ifTrue:[
        DebugKeyboard ifTrue:[
            Transcript showCR:'CMD handled internal'.
        ].
        ^ super keyPress:logicalKey x:x y:y
    ].

    DebugKeyboard ifTrue:[
        Transcript show:'unhandled: '; showCR:rawKey.
    ].

    "
     DebugKeyboard := true
    "

    "Modified: / 25-01-2012 / 10:43:06 / cg"
    "Modified: / 12-07-2017 / 09:39:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressInLineEditMode:aKey
    "readline alike line editing.
     cursorUp/down select a previous line from the history (unix shell bahevior).
     shift cursorUp selects a previous selected history line from the history (windows shell bahevior).
     cursor left/right/^A/^E/backspace position/edit inside that line.
     Return true, if the character was processed,
     false if not. Then, the caller should proceed as usual."

    |clearLine|

    clearLine :=
        [
            lineBufferCursorPosition-1 timesRepeat:[ self deleteCharBeforeCursor ].
            (lineBuffer size-(lineBufferCursorPosition-1)) timesRepeat:[ self deleteCharAtCursor].
        ].

    "/ in lineEditMode, defer sending to the pty, until a newline is entered
    lineBuffer isNil ifTrue:[
        lineBuffer := String new.
        lineBufferCursorPosition := 1.
    ].

    aKey isCharacter ifTrue:[
        lineBuffer := (lineBuffer copyTo:lineBufferCursorPosition-1)
                      , aKey
                      , (lineBuffer copyFrom:lineBufferCursorPosition).
        self insertCharAtCursor:aKey.
        lineBufferCursorPosition := lineBufferCursorPosition + 1.
        ^ true.
    ].

    aKey == #Return ifTrue:[
        "/ as the pty is in echo mode,
        "/ we should either disable echo for the following,
        "/ or remove from the textview and let the program redraw them.
        "/ the second alternative looks easier for now...
        clearLine value.
        self sendCR:lineBuffer.

        lastSelectedLineBufferHistoryPosition := lineBufferHistoryPosition.

        lineBufferHistory isNil ifTrue:[
            lineBufferHistory := OrderedCollection new.
        ].
        (lineBufferHistory size > 0 and:[lineBufferHistory last isEmpty]) ifTrue:[
            lineBufferHistory removeLast.
            lineBufferHistoryChanged := true.
        ].
        "/ do not remember blank lines
        (lineBuffer notEmptyOrNil and:[lineBuffer isBlank not]) ifTrue:[
            "/ do not remember repetitions
            (lineBufferHistory size > 0 and:[lineBufferHistory last = lineBuffer]) ifFalse:[
                lineBufferHistory addLast:lineBuffer.
                lineBufferHistoryChanged := true.
            ].
            lineBufferHistoryPosition := lineBufferHistory size + 1.
            lineBuffer := nil.

            maxHistorySize notNil ifTrue:[
                [ lineBufferHistory size > maxHistorySize] whileTrue:[
                    lineBufferHistory removeFirst.
                    lineBufferHistoryChanged := true.
                ].
            ].
        ].
        ^ true.
    ].

    aKey == #BackSpace ifTrue:[
        lineBufferCursorPosition > 1 ifFalse:[
            self beep.  
            ^ true
        ].
        lineBuffer := (lineBuffer copyTo:lineBufferCursorPosition-2)
                      , (lineBuffer copyFrom:lineBufferCursorPosition).
        self deleteCharBeforeCursor.
        lineBufferCursorPosition := lineBufferCursorPosition - 1.
        ^ true.
    ].

    ((aKey == #BeginOfText) or:[aKey == #Ctrla]) ifTrue:[
        lineBufferCursorPosition > 1 ifFalse:[
            self beep.  
            ^ true
        ].
        lineBufferCursorPosition := 1.
        self cursorToBeginOfLine.
        ^ true.
    ].
    ((aKey == #EndOfText) or:[aKey == #Ctrle]) ifTrue:[
        lineBufferCursorPosition := lineBuffer size.
        self cursorToEndOfLine.
        ^ true.
    ].
    aKey == #CursorLeft ifTrue:[
        lineBufferCursorPosition > 1 ifFalse:[
            self beep.  
            ^ true
        ].
        lineBufferCursorPosition := lineBufferCursorPosition - 1.
        self cursorLeft.
        ^ true.
    ].
    aKey == #CursorRight ifTrue:[
        lineBufferCursorPosition <= lineBuffer size ifFalse:[
            self beep.  
            ^ true
        ].
        lineBufferCursorPosition := lineBufferCursorPosition + 1.
        self cursorRight.
        ^ true.
    ].
    aKey == #CursorUp ifTrue:[
        (lineBufferHistoryPosition notNil and:[lineBufferHistoryPosition > 1]) ifFalse:[
            self beep.
            ^ true
        ].
    
        "/ remember the current lineBuffer (but only if it is the last)
        lineBufferHistoryPosition > lineBufferHistory size ifTrue:[
            (lineBuffer notEmptyOrNil and:[lineBuffer isBlank not]) ifTrue:[  
                "/ do not remember repetitions
                (lineBufferHistory size > 0 and:[lineBufferHistory last = lineBuffer]) ifFalse:[
                    lineBufferHistory add:lineBuffer.
                    lineBufferHistoryChanged := true.
                ].
            ].
        ].
        clearLine value.

        (self sensor shiftDown and:[lastSelectedLineBufferHistoryPosition notNil]) ifTrue:[
            lineBufferHistoryPosition := lastSelectedLineBufferHistoryPosition.
        ] ifFalse:[
            lineBufferHistoryPosition := lineBufferHistoryPosition - 1.
        ].
        "/ lastSelectedLineBufferHistoryPosition := lineBufferHistoryPosition.
        lineBuffer := lineBufferHistory at:lineBufferHistoryPosition ifAbsent:[lineBufferHistory last].
        self insertStringAtCursor:lineBuffer.
        lineBufferCursorPosition := lineBuffer size + 1.
        self makeCursorVisible.
        ^ true.    
    ].
    aKey == #CursorDown ifTrue:[
        (lineBufferHistoryPosition notNil and:[lineBufferHistoryPosition < lineBufferHistory size]) ifFalse:[
            self beep.
            ^ true
        ].

        clearLine value.

        lineBufferHistoryPosition := lineBufferHistoryPosition + 1.
        "/ lastSelectedLineBufferHistoryPosition := lineBufferHistoryPosition.
        lineBuffer := lineBufferHistory at:lineBufferHistoryPosition.
        lineBufferHistoryPosition >= lineBufferHistory size ifTrue:[
            lineBufferHistory removeLast.
            lineBufferHistoryChanged := true.
        ].
        self insertStringAtCursor:lineBuffer.
        lineBufferCursorPosition := lineBuffer size + 1.
        self makeCursorVisible.
        ^ true.    
    ].
    ^ false.
!

shellTerminated
    "shell has terminated"

"/Delay waitForSeconds:10.
    [self readAnyAvailableData > 0] whileTrue:[Delay waitForSeconds:0.1].
"/
    self closeDownShellAndStopReaderProcess.

    shellTerminateAction notNil ifTrue:[
        shellTerminateAction value
    ]

    "Modified: / 5.5.1999 / 18:43:22 / cg"
!

shouldProcessInputInLineEditMode
    "should input be processed in the readline edit mode?"

    |termiosInfo|

    lineEditMode == true ifFalse:[^ false].

    "/ check if tty is in raw mode - then don't do lineEditMode
    (OperatingSystem isUNIXlike
    and:[ inStream isExternalStream ]) ifTrue:[
        termiosInfo := inStream tcgetattr.
        ((termiosInfo at:#lflags) at:#icanon) ifFalse:[^ false].
    ].

    "/ don't know how to do that on non-unix systems
    ^ true
!

sizeChanged:how
    super sizeChanged:how.
    self defineWindowSize.

    "Modified: / 11.6.1998 / 22:51:48 / cg"
! !

!TerminalView methodsFor:'functions'!

autoMargin:aBoolean
    "set/clear autowrap at end of line (not yet fully implemented).
     This may come from a CSI sequence, or set programmatically."

    autoWrapFlag := aBoolean
!

doBackspace
    self cursorLeft.
    self replaceCharAtCursor:(Character space).
    self cursorLeft.

    "Modified: / 10.6.1998 / 17:09:12 / cg"
!

doClearDisplay
    "clear everything"

    self doClearEntireScreen.

    "Modified: / 21.7.1998 / 20:05:35 / cg"
!

doClearEntireLine
    "clear the cursor line. cursor position remains unchanged"

    self at:cursorLine put:''
!

doClearEntireScreen
    "clear everything"

    firstLineShown to:(list size) do:[:lNr |
        self at:lNr put:''
    ].

    "Modified: / 21.7.1998 / 20:00:19 / cg"
    "Created: / 21.7.1998 / 20:05:24 / cg"
!

doClearFromBeginningOfLine
    "clear from beginning of line to the cursorPosition"

    |l|

    l := self listAt:cursorLine.
    l notNil ifTrue:[
        (l size >= (cursorCol-1)) ifTrue:[
            l := l copy from:1 to:cursorCol-1 put:(Character space).
        ] ifFalse:[
            l := nil.
        ].
        self withoutRedrawAt:cursorLine put:l.
        self invalidateLine:cursorLine
        "/ self at:cursorLine put:l.
    ]

    "Modified: / 20.6.1998 / 19:10:21 / cg"
    "Created: / 21.7.1998 / 20:10:58 / cg"
!

doClearFromBeginningOfScreen
    "clear from beginning of the screen to the cursorPosition"

    self doClearFromBeginningOfLine.
    cursorLine-1 to:firstLineShown do:[:lNr |
        self at:lNr put:''
    ].

    "Modified: / 10.6.1998 / 14:45:43 / cg"
    "Created: / 21.7.1998 / 20:08:29 / cg"
!

doClearToEndOfLine
    "clear from the cursorPosition to the end of the line"

    |l|

    l := self listAt:cursorLine.
    (l size >= (cursorCol-1)) ifTrue:[
        l notNil ifTrue:[
            l := l copyTo:cursorCol-1.
            self withoutRedrawAt:cursorLine put:l.
            self invalidateLine:cursorLine
            "/ self at:cursorLine put:l.
        ]
    ]

    "Created: / 10.6.1998 / 14:45:01 / cg"
    "Modified: / 20.6.1998 / 19:10:21 / cg"
!

doClearToEndOfScreen
    "clear from the cursorPosition to the end of the screen"

    self doClearToEndOfLine.
    cursorLine+1 to:(list size) do:[:lNr |
        self at:lNr put:''
    ].

    "Modified: / 10.6.1998 / 14:45:43 / cg"
    "Created: / 21.7.1998 / 20:06:14 / cg"
!

doCursorDown:n
    "move the cursor down by n lines"

    |wasOn rEnd|

"/    rangeEndLine == numberOfLines ifTrue:[
"/        ^ super cursorDown:n
"/    ].
    cursorLine + 1 - firstLineShown + n <= rangeEndLine ifTrue:[
        "/ no special action req'd
        ^ super cursorDown:n
    ].

    n timesRepeat:[
        wasOn := self hideCursor.
        rEnd := rangeEndLine+firstLineShown-1.
        cursorLine ==  rEnd ifTrue:[
            self deleteLine:(rangeStartLine+firstLineShown-1).
            self insertLine:'' before:rEnd.
        ] ifFalse:[
            super cursorDown
        ].
        wasOn ifTrue:[self showCursor]. "/ self makeCursorVisibleAndShowCursor:wasOn.
    ]

    "Modified: / 20.6.1998 / 20:29:39 / cg"
!

doCursorHome
    "move the cursor to the home position"

    self cursorVisibleLine:1 col:1
    "/ super cursorHome

    "Modified: / 10.6.1998 / 20:47:31 / cg"
!

doCursorLeft:n
    "move the cursor to the left by n columns"

    n timesRepeat:[
        super cursorLeft
    ]

    "Created: / 11.6.1998 / 22:30:00 / cg"
!

doCursorNewLine
    "move the cursor down to the next line (col remains unchanged)"

    super cursorDown:1

    "Modified: / 10.6.1998 / 16:55:57 / cg"
!

doCursorReturn
    "move the cursor down and left to the beginning to the next line"

    super cursorToBeginOfLine
!

doCursorRight:n
    "move the cursor to the right by n columns"

    self cursorCol:(cursorCol + n)

    "Created: / 10.6.1998 / 15:10:08 / cg"
!

doCursorUp:n
    "move the cursor up by n lines"

    |wasOn rStart|

"/    rangeStartLine == 1 ifTrue:[
"/        ^ super cursorUp:n
"/    ].
    cursorLine + 1 - firstLineShown - n >= rangeStartLine ifTrue:[
        "/ no special action req'd
        ^ super cursorUp:n
    ].
    n timesRepeat:[
        wasOn := self hideCursor.
        rStart := rangeStartLine+firstLineShown-1.
        cursorLine == rStart ifTrue:[
            (rangeEndLine+firstLineShown-1) <= list size ifTrue:[
                self deleteLine:(rangeEndLine+firstLineShown-1).
                self insertLine:'' before:rStart.
            ].
        ] ifFalse:[
            super cursorUp
        ].
        self makeCursorVisibleAndShowCursor:wasOn.
    ]

    "Created: / 11.6.1998 / 22:29:46 / cg"
    "Modified: / 20.6.1998 / 20:30:34 / cg"
! !

!TerminalView methodsFor:'initialization & release'!

closeDownShell
    "shut down my shell process."

    |pid|

    (pid := shellPid) notNil ifTrue:[
        Debug ifTrue:[
            Transcript show:'killing shell pid='; showCR:pid.
        ].
        OperatingSystem isMSWINDOWSlike ifFalse:[
            OperatingSystem terminateProcessGroup:pid.
        ].
        OperatingSystem terminateProcess:pid.
        Delay waitForSeconds:0.2.
        shellPid notNil ifTrue:[
            "/ Delay waitForSeconds:1.
            shellPid notNil ifTrue:[
                OperatingSystem isMSWINDOWSlike ifFalse:[
                    OperatingSystem killProcessGroup:pid.
                ].
                OperatingSystem killProcess:pid.
                shellPid := nil.
            ].
        ].
        OperatingSystem closePid:pid.
    ].
!

closeDownShellAndStopReaderProcess
    "shut down my shell process and stop the background reader thread."

    self closeDownShell.
    self stopReaderProcess.
    self closeStreams

    "Modified: / 5.5.1999 / 18:43:02 / cg"
!

closeStreams
    |s|

    (s := inStream) notNil ifTrue:[
        inStream := nil.
        (s isStream and:[s isOpen]) ifTrue:[
            s close
        ].
    ].
    (s := outStream) notNil ifTrue:[
        outStream := nil.
        (s isStream and:[s isOpen]) ifTrue:[
            s close.
        ].
    ].

    "Modified: / 5.5.1999 / 18:43:02 / cg"
!

escapeSequences:codes
    "setup my escape sequences"

    |tree|

    tree isNil ifTrue:[tree := escapeSequenceTree := IdentityDictionary new].

    codes do:[:specEntry |
        |sequence function|

        sequence := (specEntry at:1) withoutCEscapes.
        function := specEntry at:2.

        tree := escapeSequenceTree.

        sequence keysAndValuesDo:[:idx :char |
            |followup|

            idx == sequence size ifTrue:[
                tree at:char put:function
            ] ifFalse:[
                followup := tree at:char ifAbsent:nil.
                followup isNil ifTrue:[
                    tree at:char put:(followup := IdentityDictionary new).
                ].
                tree := followup
            ]
        ]
    ].
    escapeLeadingChars := escapeSequenceTree keys asSet.
    escapeLeadingChars add:(Character cr).
    escapeLeadingChars add:(Character return).
    escapeLeadingChars add:(Character backspace).

    escapeLeadingChars := escapeLeadingChars asArray

    "Modified: / 25-01-2012 / 10:42:46 / cg"
!

flushInput
    |sensor|

    "/ flush any leftover input-processing events
    (sensor := self sensor) notNil ifTrue:[
        sensor flushEventsFor:self withType:#processInput:n:.
    ]

    "Modified: / 21.7.1998 / 19:00:13 / cg"
    "Created: / 5.5.1999 / 18:41:42 / cg"
!

initStyle
    super initStyle.
"/    self foregroundColor:Color green.
"/    self backgroundColor:Color black.
!

initialize

    super initialize.

    sendControlKeys := true.
    signalControlKeys := OperatingSystem isMSWINDOWSlike.
    showMatchingParenthesis := false.
    self insertMode: false.
    alwaysAppendAtEnd := false.
    collectSize := 4096.
    sizeOfOutstandingInputToBeProcessed := 0.
    st80Mode := false.
    trimBlankLines := true.
    localEcho := false.
    inputTranslateCRToNL := false.
    inputTranslateCRToCRNL := OperatingSystem isMSWINDOWSlike.
    inputTranslateBackspaceToDelete := false.
    inputIsUTF8 := UserPreferences current terminalInputIsUTF8.
    outputIsUTF8 := false. "/ currently unused.
    autoWrapFlag := true.
    noColors := false.
    doUTF := UserPreferences current terminalOutputIsUTF8.
    lineEditMode := OperatingSystem isMSWINDOWSlike.
    maxHistorySize := maxHistorySize ? DefaultMaxHistorySize.
    ignoreOutput := false.
    filterOnly := false.

    "/ cursorType := #block.
    "/ cursorTypeNoFocus := #frame.

    state := 0.

    numberOfColumns := 80.
    numberOfLines := 24.
    rangeStartLine := 1.
    rangeEndLine := numberOfLines.

    self setTab8.

    self initializeKeyboardSequences.
    list := OrderedCollection new:24 withAll:''.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        kbdSequences at:#Return put:'\r\n'.
    ].
    self initializeKeyboardMap.
    self initializeShellTerminateAction.
    
    "
     VT52TerminalView openShell
     VT100TerminalView openShell
    "

    "Modified: / 30-07-2013 / 10:43:07 / cg"
!

initializeKeyboardMap
    "setup my own keyboardMap, where control-keys 
     (and some Cmd-keys) are not translated."

    |mappedKeys ctrlKeys cmdKeys|

    keyboardMap := device keyboardMap copy.
    keyboardMap parent: nil.
    mappedKeys := keyboardMap mappedKeys.

    ctrlKeys := mappedKeys select:[:key | key startsWith:'Ctrl'].
    ctrlKeys do:[:key |
        |val|
        
        val := keyboardMap mappingFor: key.
        (#(ZoomIn ZoomOut) includesIdentical:val) ifFalse:[
            keyboardMap 
                unbindValue: key;
                unbindAlias: key.
        ]
    ].

    cmdKeys := mappedKeys select:[:key | key startsWith:'Cmd'].
    cmdKeys do:[:key | 
        |val|
        
        val := keyboardMap mappingFor:key.
        (
            #(Copy Paste SaveAs Print Find FindNext FindPrev GotoLine
        ) includesIdentical:val) ifFalse:[
            keyboardMap 
                unbindValue: key;
                unbindAlias: key. 
        ]
    ].

    keyboardMap 
           unbindValue: #Delete;    unbindAlias: #Delete;
           unbindValue: #BackSpace; unbindAlias: #BackSpace.



    "
     VT52TerminalView openShell
    "

    "Modified: / 29-04-1999 / 14:25:24 / cg"
    "Modified: / 17-05-2017 / 15:53:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeKeyboardSequences
    kbdSequences := (self anyKeyCodes)

    "Modified: / 5.5.1999 / 15:01:09 / cg"
!

initializeShellTerminateAction
    shellTerminateAction := 
        [
            "/ may be removed with shellTerminateAction:...
            self warn:(resources string:'shell terminated').
        ]
!

keyboardMap
    "return my own, private keyboard map. 
     This has control keys removed and
     those will be passed unchanged to the shell"

    ^ keyboardMap

    "Modified: / 10.6.1998 / 17:46:59 / cg"
!

reinitialize
    "reinit after a snapIn.
     this is invoked (by the system thread) after a snapShot image restart"

    super reinitialize.

    shellPid := nil.

    self stopReaderProcess.
    self flushInput.

    readerProcess := nil.
    inStream := outStream := nil.

    "/ must fork at low-prio (to avoid running reader at prio31)
    [
       "/ Delay waitForSeconds:0.5.
        self doClearEntireScreen.
        self cursorLine:1 col:1.
        self contents:nil.
        self flash.

        "/
        "/ all I can do is to restart the original command
        "/
        self startCommand:shellCommand in:shellDirectory.
    ] forkAt:8

    "Modified: / 5.5.1999 / 18:41:55 / cg"
!

release
    "release myself - shut down the shell, stop the reader thread."

    [
        self closeDownShellAndStopReaderProcess.
        self flushInput.
    ] forkAt:(Processor systemBackgroundPriority).
    super release.

    "Modified: / 17-07-2014 / 19:29:55 / cg"
! !

!TerminalView methodsFor:'initialization-shell'!

basicStartCommand:aCommand in:aDirectory
    "start a command on a pseudo terminal. If the command arg is nil,
     a shell is started. If aDirectory is not nil, the command is
     executed in that directory.
     Also fork a reader process, to read the shells output and
     tell me, whenever something arrives"

    |pty slaveFD execFdArray blocked exitStatus 
     stxToCommandPipe commandToStxPipe cmd shell args env shellAndArgs|

    shellCommand := aCommand.
    shellDirectory := aDirectory.

    self create.  "/ need my windowID (to pass down in environment)

    OperatingSystem isMSWINDOWSlike ifTrue:[
        "use two pipes to COMMAND.COM"
        stxToCommandPipe := NonPositionableExternalStream makePipe.
        stxToCommandPipe isNil ifTrue:[
            self warn:(resources string:'Could not create pipe to COMMAND.COM.'). 
            ^ self.
        ].

        commandToStxPipe := NonPositionableExternalStream makePipe.
        commandToStxPipe isNil ifTrue:[
            self warn:(resources string:'Could not create pipe from COMMAND.COM.'). 
            ^ self.
        ].

        "/ pipe readSide is p at:1;
        "/      writeSide is p at:2

        slaveFD := (commandToStxPipe at:2) fileDescriptor.
        execFdArray := Array 
                         with:(stxToCommandPipe at:1) fileDescriptor        "stdin"
                         with:slaveFD                                       "stdout"
                         with:slaveFD.                                      "stderr"

        outStream := commandToStxPipe at:1.
        inStream  := stxToCommandPipe at:2.

        self defineWindowSize.  "/ does not really work on windows (need help)

        shellAndArgs := OperatingSystem commandAndArgsForOSCommand:aCommand.
        shell := shellAndArgs at:1.
        args  := (shellAndArgs at:2) ? ''.
    ] ifFalse:[
        "Use a pseudo-tty"
        pty := NonPositionableExternalStream makePTYPair.
        pty isNil ifTrue:[
            self warn:(resources string:'Cannot open pty.').
            ^ self.
        ].

        "/ pty at:1 is the master;
        "/ pty at:2 is the slave
        inStream := outStream := (pty at:1).

        self defineWindowSize.

        "/ fork a shell process on the slave-side
        slaveFD := (pty at:2) fileDescriptor.
        execFdArray := Array with:slaveFD with:slaveFD with:slaveFD.

        aCommand isNil ifTrue:[
            shell := OperatingSystem getEnvironment:'SHELL'.
            shell size == 0 ifTrue:[
                shell := '/bin/sh'.
            ].
            cmd := shell asFilename baseName.
            args := (Array with:cmd).
        ] ifFalse:[
            shell := '/bin/sh'.
            args := (Array with:'sh' with:'-c' with:aCommand).
        ].
        env := Dictionary new.
        env at:'SHELL'    put:shell.
        env at:'TERM'     put:(self terminalType).
        env at:'HOME'     put:(OperatingSystem getEnvironment:'HOME').
        env at:'USER'     put:(OperatingSystem getEnvironment:'USER').
        env at:'LINES'    put:(numberOfLines printString).
        env at:'COLUMNS'  put:(numberOfColumns printString).
        (device platformName == #X11 and:[self drawableId notNil]) ifTrue:[
            env at:'WINDOWID' put:(self drawableId address printString).
        ].
    ].

    blocked := OperatingSystem blockInterrupts.

    shellPid := Processor
               monitor:[
                  OperatingSystem
                      exec:shell
                      withArguments:args
                      environment:env
                      fileDescriptors:execFdArray
                      fork:true
                      newPgrp:true
                      inDirectory:aDirectory
                      showWindow:false.
               ]
               action:[:status |
                    Debug ifTrue:[
                        Transcript showCR:'shell status change'.
                        Transcript show:'  pid:'; showCR:status pid.
                        Transcript show:'  status:'; showCR:status status.
                        Transcript show:'  code:'; showCR:status code.
                        Transcript show:'  core:'; showCR:status core.
                    ].
                    status stillAlive ifFalse:[
                        exitStatus := status.
                        OperatingSystem closePid:shellPid.
                        shellPid := nil.
                        self pushEvent:#shellTerminated
                    ].
               ].

    blocked ifFalse:[
        OperatingSystem unblockInterrupts
    ].

    "close the slave side of the pty/pipes (only used by the child)"
    pty notNil ifTrue:[
        (pty at:2) close.
    ].

    commandToStxPipe notNil ifTrue:[
        (commandToStxPipe at:2) close.
        (stxToCommandPipe at:1) close.
    ].

    shellPid isNil ifTrue:[
        self warn:(resources string:'Cannot start shell').
        self closeStreams.
        ^ self.
    ].

    "Created: / 20-07-1998 / 18:19:32 / cg"
    "Modified: / 17-07-2014 / 19:43:00 / cg"
!

startCommand:aCommand
    "start a command on a pseudo terminal. If the command arg is nil,
     a shell is started. The command is started in the current directory.
     Also fork a reader process, to read the shells output and
     tell me, whenever something arrives"

    self startCommand:aCommand in:nil

    "Modified: / 20.7.1998 / 18:30:24 / cg"
!

startCommand:aCommand in:aDirectory
    "start a command on a pseudo terminal. If the command arg is nil,
     a shell is started. If aDirectory is not nil, the command is
     executed in that directory.
     Also fork a reader process, to read the shells output and
     tell me, whenever something arrives"

    self basicStartCommand:aCommand in:aDirectory.
    self startReaderProcessWhenVisible.

    "Created: / 20.7.1998 / 18:19:32 / cg"
    "Modified: / 5.5.1999 / 17:28:37 / cg"
!

startShell
    "start a shell on a pseudo terminal in the current directory.
     Also fork a reader process, to read the shells output and
     tell me, whenever something arrives"

    ^ self startCommand:nil

    "
     VT100TerminalView openShell
    "

    "Modified: / 20.7.1998 / 18:29:54 / cg"
!

startShellIn:aDirectory
    "start a shell on a pseudo terminal in some directory.
     Also fork a reader process, to read the shells output and
     tell me, whenever something arrives"

    self startCommand:nil in:aDirectory

    "
     VT100TerminalView openShellIn:'/etc'
    "

    "Modified: / 20.7.1998 / 18:29:46 / cg"
! !

!TerminalView methodsFor:'menu'!

doClear
    "reset the scroll-range etc, clear the text buffer"

    rangeStartLine := 1.
    rangeEndLine := numberOfLines.

    self normal.
    self clear.

    "Created: / 03-04-2007 / 08:58:59 / cg"
!

doReset
    "reset the scroll-range; 
     may have to reset more in the future (current font-set; color; etc)"

    rangeStartLine := 1.
    rangeEndLine := numberOfLines.

    self normal.

!

doSendInterrupt
    "send an INT-signal to the shell (UNIX only)"

    DebugKeyboard ifTrue:[
        Transcript showCR:'interrupt!!'.
    ].
    self sendInterruptSignal
!

doSendKillSignal
    "send a KILL-signal to the shell (UNIX only)"

    DebugKeyboard ifTrue:[
        Transcript showCR:'kill!!'.
    ].
    self sendKillSignal
!

doSendTerminateSignal
    "send a TERM-signal to the shell (UNIX only)"

    DebugKeyboard ifTrue:[
        Transcript showCR:'terminate!!'.
    ].
    self sendTerminateSignal
!

editMenu
    "return the view's middleButtonMenu"

    <resource: #keyboard (#Copy #Paste #Print #SaveAs #Print)>
    <resource: #programMenu>

    |items subMenu moreMenu m sensor|

    items := #(
                    ('Interrupt'      doSendInterrupt )  
                    ('Terminate'      doSendTerminateSignal )  
                    ('Kill'           doSendKillSignal)  
                    ('-'                              )
                    ('Clear'          doClear         )  
                    ('Reset'          doReset         )  
              ).
    subMenu := PopUpMenu itemList:items resources:resources.

    items := #(
                    ('Open FileBrowser on It'      openFileBrowserOnIt )  
              ).
    moreMenu := PopUpMenu itemList:items resources:resources.

    ((sensor := self sensor) notNil and:[sensor ctrlDown]) ifTrue:[
        m := subMenu.
    ] ifFalse:[
        items := #(
                        ('Copy'         copySelection    Copy   )
                        ('Paste'        pasteOrReplace   Paste  )
                        ('-'                                    )
                        ('Search...'    search           Find)
                        ('-'                                    )
                        ('Font...'      changeFont              )
                        ('-'                                    )
                        ('Save As...'   save             SaveAs )
                        ('Print'        doPrint          Print  )
                        ('='                               )
                        ('More'         more                )
                        ('Shell'        others           Ctrl   )
                  ).
        m := PopUpMenu itemList:items resources:resources.
        m subMenuAt:#more put:moreMenu.
        m subMenuAt:#others put:subMenu.

"/ disabled - for now;
"/ need a more intelligent filtering of control characters.
"/
"/        filterStream isNil ifTrue:[
"/           items := items , #(
"/                        ('-'                                    )
"/                        ('Start Save as ...'  startSaveAs       )
"/                        ('Start Print'        startPrint        )
"/                             )
"/        ] ifFalse:[
"/           items := items , #(
"/                        ('-'                                    )
"/                        ('Stop filter'  stopFilter              )
"/                             )
"/        ].
    ].

    self hasSelection ifFalse:[
        m disable:#copySelection.
    ].
    ^ m.

    "Modified: / 03-04-2007 / 08:58:26 / cg"
!

openFileBrowserOnIt
    "open a fileBrowser on the selected fileName"

    |selection fileName|

    shellDirectory notNil ifTrue:[
        selection := self selectionAsString.
        fileName := selection asFilename.
        fileName isAbsolute ifFalse:[
            fileName := shellDirectory construct:selection.
        ].
        self openFileBrowserOnFileNamed:fileName pathName
    ].
!

sendInterruptSignal
    "send an INT-signal to the shell (UNIX only)"

    shellPid notNil ifTrue:[
        OperatingSystem isUNIXlike ifTrue:[
            OperatingSystem interruptProcessGroup:shellPid.
            OperatingSystem interruptProcess:shellPid.
            "/ status := OperatingSystem childProcessWait:false pid:shellPid.
        ] ifFalse:[
            self warn:(resources string:'unimplemented for DOS')
        ]
    ] ifFalse:[
        'VT100: no shell' infoPrintCR.
    ].

    "Modified: / 10.6.1998 / 17:49:49 / cg"
!

sendKillSignal
    "send a KILL-signal to the shell (UNIX only)"

    |status|

    shellPid notNil ifTrue:[
        OperatingSystem isUNIXlike ifTrue:[
            OperatingSystem killProcessGroup:shellPid.
            OperatingSystem killProcess:shellPid.
            status := OperatingSystem childProcessWait:false pid:shellPid.
        ] ifFalse:[
            self warn:(resources string:'unimplemented for DOS')
        ]
    ] ifFalse:[
        'VT100: no shell' infoPrintCR.
    ]
!

sendTerminateSignal
    "send a TERM-signal to the shell (UNIX only)"

    shellPid notNil ifTrue:[
        OperatingSystem terminateProcessGroup:shellPid.
        OperatingSystem terminateProcess:shellPid.
        "/ status := OperatingSystem childProcessWait:false pid:shellPid.
    ] ifFalse:[
        'VT100: no shell' infoPrintCR.
    ].
!

setGreenDisplayMode
    self foregroundColor:Color green backgroundColor:self blackColor.
    self cursorForegroundColor:self blackColor backgroundColor:Color green.
!

setNormalDisplayMode
    self foregroundColor:self blackColor backgroundColor:self whiteColor.
    self cursorForegroundColor:self whiteColor backgroundColor:self blackColor.
!

setRedDisplayMode
    self foregroundColor:(self whiteColor) backgroundColor:(Color red:80).
    self cursorForegroundColor:(Color red:80) backgroundColor:(self whiteColor).
!

setReverseDisplayMode
    |fg bg|

    fg := self foregroundColor.
    bg := self backgroundColor.
    self foregroundColor:bg backgroundColor:fg.
    self cursorForegroundColor:fg backgroundColor:bg.
!

startSaveAs
    "start saving all received data to some file"

    |fn|

    fn := Dialog requestFileName:'Save received data in file:'.
    fn size > 0 ifTrue:[
        filterStream := fn asFilename writeStream
    ].

    "Created: / 29.4.1999 / 11:06:29 / cg"
!

stopFilter
    "stop saving/printing of received data"

    filterStream close.
    filterStream := nil.

    "Created: / 29.4.1999 / 11:07:49 / cg"
    "Modified: / 29.4.1999 / 11:09:52 / cg"
! !

!TerminalView methodsFor:'misc'!

debugPrintCharacter:aCharacter as:what
    Transcript show:what; show:' <'.
    aCharacter codePoint < 32 ifTrue:[
        Transcript show:'\x'; show:(aCharacter codePoint hexPrintString:2)
    ] ifFalse:[
        Transcript show:aCharacter
    ].
    Transcript showCR:'>'
!

removeTrailingBlankLines
    ^ self
! !

!TerminalView methodsFor:'processing-input'!

doNothing
    "private - end of an ignored escape-sequence"

    self endOfSequence

    "Created: / 12.6.1998 / 20:40:43 / cg"
!

endOfSequence
    "private - reset state-machine at end of escape-sequence"

    state := 0.

    "Created: / 12.6.1998 / 20:39:52 / cg"
!

nextPut:char
    "process a character (i.e. the shell's output)"

    "/ Debug := true
    "/ Debug := false
    Debug ifTrue:[
        Transcript show:state; show:' <'; show:(char codePoint hexPrintString:2); showCR:'>'.
    ].

    (char == Character nl) ifTrue:[ 
        self endEntry.
        self doCursorDown:1.
        ^ self endEntry.
    ].
    (char == Character return) ifTrue:[ 
        self endEntry.
        self cursorToBeginOfLine.
        ^ self.
    ].
    (char == Character backspace) ifTrue:[ 
        self endEntry.
        self doCursorLeft:1. "/ doBackspace
        ^ self endEntry.
    ].
    (char == Character bell) ifTrue:[
        self beep.
        ^ self 
    ].
    char codePoint < 32 ifTrue:[
        char ~~ Character tab ifTrue:[
            char codePoint ~~ 0 ifTrue:[
                Debug ifTrue:[
                    Transcript show:'unhandled control key: '; showCR:char storeString.
                ].
            ].
            ^ self.
        ]
    ].
    self show:char; endEntry.

    "Modified: / 21.7.1998 / 20:06:04 / cg"
!

nextPutAll:aString
    "/ self processInput:aString n:aString size

    Debug ifTrue:[
        Transcript                                                       
            show:(self class name); show:': nextPutAll - state: '; show:state;
            show:' got: <'.
        aString do:[:ch |
            Transcript show:'<'; show:(ch codePoint hexPrintString:2); show:'>'
        ].
        Transcript cr; endEntry.
    ].
    self pushEvent:#processInput:n: with:aString with:aString size.

    "Created: / 27.7.1998 / 15:10:59 / cg"
    "Modified: / 27.7.1998 / 23:16:19 / cg"
!

processInput:buffer n:count
    "actually: output coming from the connected application (aka input to me);
     the stuff coming from the application is a mix of plain text and CSI escape sequences.
     If we process each character individually, things are trivial, but slow.
     Therefore, we collect big chunks of non-escaped text and buffer them to make
     use of the inherited buffered output optimizations (see TextCollector).
     Thus, we collect until an escape sequence is encountered, and flush the buffered stuff then,
     proceed in single-character mode (processState0:) until the sequence is finished, and continue
     collecting.
     This makes this terminalView's speed usable and actually competitive with some existing
     console applications. 
     BTW: It is *much* faster than the MSWindows command.com window,
     - so much for the 'slow' Smalltalk ;-)"

    |sensor|

    "/ remember how much is in the queue...
    [
        sizeOfOutstandingInputToBeProcessed := sizeOfOutstandingInputToBeProcessed - count.
    ] valueUninterruptably.
    "/ Debug := true
    "/ Debug := false
    Debug ifTrue:[
        Transcript show:self class name; show:': processInput - state: '; show: state;
                   show:' got: '; showCR: count.
    ].

    filterStream notNil ifTrue:[
        filterStream nextPutAll:(buffer copyTo:count).
        filterOnly ifTrue:[^ self].
    ].
    "/ '*' print. (buffer copyTo:count) asByteArray hexPrintString printCR.

"/    self hideCursor.

    "/ the following may not be too clean, but adds a lot of speed.
    "/ instead of passing every individual character through the
    "/ escape-state machine, collect chunks of non-control text
    "/ when in state 0, and add them immediately to the pendingLines
    "/ collection of the textCollectors asynchronous update mechanism.
    "/ This helps a lot if you do something like "ls -lR /" ...
    "/ For debugging the state machine, reenable the commented lines
    "/ below.

"/1 to:count do:[:i|
"/    self nextPut:(buffer at:i).
"/].
"/self showCursor.
"/^ self.

    access critical:[
        |index controlCharIndex stringWithOutControl crnlFollows 
         nFit nCharsInLine charIdx oldCollectSize|

        index := 1.
        [index <= count] whileTrue:[
            stringWithOutControl := nil.

            (state == 0) ifTrue:[
                "/ in initial state:
                "/ quick scan forward for next control character ...
                controlCharIndex := buffer indexOfControlCharacterStartingAt:index.
                controlCharIndex > count ifTrue:[controlCharIndex := 0].

                controlCharIndex == 0 ifTrue:[
                    "/ no control characters - simply append all
                    "/ to the outstanding lines...
                    stringWithOutControl := buffer copyFrom:index to:count.
                    crnlFollows := false.
                    index := count + 1. "/ leave loop.
                ] ifFalse:[
                    controlCharIndex > index ifTrue:[
                        "/ some more regular character(s) before control character
                        stringWithOutControl := buffer copyFrom:index to:controlCharIndex-1.
                        index := controlCharIndex. "/ proceed withcontrol character
                        crnlFollows := false.
                        index < (count - 1) ifTrue:[
                            (buffer at:index) == Character return ifTrue:[
                                (buffer at:index+1) == Character nl ifTrue:[
                                    crnlFollows := true.
                                    index := index + 2.
                                ]
                            ]
                        ].
                    ] ifFalse:[
                        "/ controlchr immediately follows
                    ]
                ].
            ].

            stringWithOutControl notNil ifTrue:[
                doUTF ifTrue:[
                    Error handle:[:ex |
                    ] do:[
                        stringWithOutControl := stringWithOutControl utf8Decoded
                    ].
                ].
                nCharsInLine := stringWithOutControl size.
                (autoWrapFlag 
                    and:[ (cursorCol + outstandingLine size + nCharsInLine) >= numberOfColumns ]
                ) ifTrue:[
                    charIdx := 1.
                    nFit := numberOfColumns - outstandingLine size - cursorCol - 1.
                    nFit > 0 ifTrue:[
                        access critical:[
                            outstandingLine size > 0 ifTrue:[
                                outstandingLine := outstandingLine , (stringWithOutControl copyTo:nFit).
                            ] ifFalse:[
                                outstandingLine := (stringWithOutControl copyTo:nFit).
                            ].
                        ].
                        charIdx := nFit + 1.
                    ].
                    "/ Transcript show:'idx: '; show:charIdx; show:' n:'; showCR:nCharsInLine.
                    oldCollectSize := collectSize.
                    collectSize := 32*1024.
                    "/ characterwise, for correct wrap handling at line end
                    [charIdx <= nCharsInLine] whileTrue:[
                        |eachCharacter|
                        
                        eachCharacter := stringWithOutControl at:charIdx.
                        self nextPut:eachCharacter.
"/                        self endEntry.
                        cursorCol >= numberOfColumns ifTrue:[ 
                            "/ self endEntry.
                            self validateCursorCol:cursorCol inLine:cursorLine.
                            "/ Transcript show:'col now: '; showCR:cursorCol.
                            nFit := numberOfColumns - cursorCol - charIdx.
                            "/ Transcript show:'nFit now: '; showCR:nFit.
                        ].
                        charIdx := charIdx + 1.
                    ].
                    crnlFollows ifTrue:[
                        self nextPut:Character return.
                        self nextPut:Character nl.
                    ].
                    self endEntry.
                    collectSize := oldCollectSize.
                ] ifFalse:[

                    Debug ifTrue:[
                        Transcript showCR:'String:<', stringWithOutControl, '>'.
                        stringWithOutControl do:[:ch |
"/ ch codePoint > 255 ifTrue:[self halt].
                            Transcript show:'<'; show:(ch codePoint hexPrintString:2); show:'>'
                        ].
                        Transcript cr.
                    ].
                    currentEmphasis notNil ifTrue:[
                        stringWithOutControl := stringWithOutControl emphasizeAllWith:currentEmphasis
                    ].

                    access critical:[
                        outstandingLine size > 0 ifTrue:[
                            outstandingLine := outstandingLine , stringWithOutControl.
                        ] ifFalse:[
                            outstandingLine := stringWithOutControl.
                        ].
                        crnlFollows ifTrue:[
                            "/ 'xp' printCR.
                            outstandingLines isNil ifTrue:[
                                outstandingLines := OrderedCollection with:outstandingLine
                            ] ifFalse:[
                                outstandingLines add:outstandingLine.
                            ].
                            outstandingLine := ''.
                        ].
                    ].
"/                    collecting ifTrue:[
"/                        flushPending ifFalse:[
"/                            self installDelayedUpdate
"/                        ] ifTrue:[
"/        "/                    outstandingLines size > collectSize ifTrue:[
"/        "/                        self endEntry
"/        "/                    ]
"/                        ]
"/                    ] ifFalse:[
"/                        self endEntry
"/                    ].
                ].
            ] ifFalse:[
                "/ no chunk to append (in an escape sequence)
                "/ must handle individual characters
                "/ to update the state machine.

                "/ self endEntry.
                self nextPut:(buffer at:index).
                index := index + 1.
                [state ~~ 0 and:[index <= count]] whileTrue:[
                    self nextPut:(buffer at:index).
                    index := index + 1.
                ]
            ]
        ].
"/        inFlush := false.    
    ].

    (state == 0 and:[self shown]) ifTrue:[
        (sensor := self sensor) notNil ifTrue:[
            "/ if there is no more output pending from the shell,
            "/ enforce update of the view (asynchronous)

            (sensor hasEvent:#processInput:n: for:self) ifFalse:[
                self endEntry.
                self showCursor.
                "/ self makeCursorVisible.
            ] ifTrue:[
                "/ if there is more output pending from the shell,
                "/ and many lines have already been collected,
                "/ also enforce update of the view (asynchronous)
                "/ Thus, it will update at least once for every
                "/ collectSize lines.

                outstandingLines size > collectSize ifTrue:[ 
                    self endEntry.
                    self showCursor.

                    "/ make certain that things are really displayed ...
                    windowGroup notNil ifTrue:[
                        windowGroup processRealExposeEventsFor:self.
                    ]
                ].
            ]
        ].
    ].

    "Created: / 10-06-1998 / 17:26:09 / cg"
    "Modified: / 28-01-2002 / 20:41:36 / micha"
    "Modified: / 30-07-2013 / 10:47:19 / cg"
!

sync
    self waitForOutputToDrain

    "Created: / 27.7.1998 / 23:49:44 / cg"
!

waitForOutputToDrain
    |sensor|

    sensor := self sensor.
    (sensor notNil and:[sensor userEventCount > 30]) ifTrue:[
        [sensor userEventCount > 5] whileTrue:[
            "/ give terminalView a chance to
            "/ catch up.
            Delay waitForSeconds:0.1.
        ]
    ].

    "Created: / 27.7.1998 / 23:47:22 / cg"
    "Modified: / 5.5.1999 / 18:51:00 / cg"
! !

!TerminalView methodsFor:'queries'!

isKeyboardConsumer
    "return true, if the receiver is a keyboard consumer;
     Always return true here"

    ^ true
!

preferredExtent
    "return my preferred extent - this is computed from my numberOfLines,
     numberOfCols and font size"

    ^ (fontWidth * self class defaultNumberOfColumns + ((leftMargin + margin) * 2))
      @ 
      ((self heightForLines:self class defaultNumberOfLines) + 8)

    "Modified: / 20-06-1998 / 20:06:57 / cg"
    "Modified (format): / 16-11-2016 / 23:14:18 / cg"
!

terminalType
    "returns a string describing this terminal (usually, this is
     passed down to the shell as TERM environment variable).
     Here, 'dump' is returned."

    ^ 'dump'

    "Created: / 10.6.1998 / 16:22:30 / cg"
    "Modified: / 5.5.1999 / 11:22:32 / cg"
! !

!TerminalView methodsFor:'reader process'!

readAnyAvailableData
    "read data from the stream,
     and sends me #processInput:n: events if something arrived.
     Returns the amount of data read."

    |buffer n bufferSize|

    outStream isNil ifTrue:[^ 0].

    "/ avoid too many processInput messages to be in the buffer,
    "/ otherwise, the reaction on ctrl-s/ctrl-c is too slow, as
    "/ many processInput messages are in the sensor's queue before the keypress
    "/ event. We need another queue, actually so the sensor's keypress events
    "/ are not blocked while reading a lot of input.
    [sizeOfOutstandingInputToBeProcessed > 4096] whileTrue:[
        Delay waitForSeconds:0.1
    ].

    bufferSize := 1024*2.

    buffer := String new:bufferSize.
    (StreamNotOpenError,ReadError) handle:[:ex |
        n := 0
    ] do:[
        n := outStream nextAvailableBytes:bufferSize into:buffer startingAt:1.
    ].
    n > 0 ifTrue:[
        ignoreOutput ifFalse:[
            "/ Transcript showCR:n.
            self pushEvent:#processInput:n: with:buffer with:n.
            "/ remember how much is in the queue...
            [
                sizeOfOutstandingInputToBeProcessed := sizeOfOutstandingInputToBeProcessed + n.
            ] valueUninterruptably
        ].
    ].

    ^ n

    "Created: / 05-05-1999 / 17:57:39 / cg"
    "Modified: / 28-01-2002 / 21:10:25 / micha"
    "Modified (comment): / 30-07-2013 / 10:50:03 / cg"
!

readerProcessLoop
    "look for the command's output,
     and send me #processInput:n: events whenever something arrives."

    StreamError handle:[:ex |
        Transcript show:'Terminal(PTY-reader) [error]: '; showCR:ex description.
    ] do:[
        [true] whileTrue:[
            AbortOperationRequest handle:[:ex |
                self showCursor.
                (outStream isNil or:[outStream atEnd]) ifTrue:[ ex reject ].
            ] do:[
                |n sensor|

                "/ Delay waitForSeconds:0.01.
                outStream readWait.
                sensor := self sensor.
                (sensor notNil and:[sensor hasKeyPressEventFor:self]) ifTrue:[
                    true "(sensor userEventCount > 10)" ifTrue:[
                        "/ give terminalView a chance to
                        "/ send out the character.
                        "/ Transcript showCR:'d'.
                        Delay waitForSeconds:0.01.
                    ]
                ] ifFalse:[
                    n := self readAnyAvailableData.
                    n > 0 ifTrue:[
                        shellPid notNil ifTrue:[
                            self waitForOutputToDrain.
                        ]
                    ] ifFalse:[
                        n == 0 ifTrue:[
                            "/ Windows IPC has a bug - it always
                            "/ returns 0 (when the command is idle)
                            "/ and says it's at the end (sigh)

                            OperatingSystem isMSWINDOWSlike ifTrue:[
                                Delay waitForSeconds:0.01
                            ] ifFalse:[
                                outStream atEnd ifTrue:[
                                    self closeStreams.
                                    Processor activeProcess terminate.
                                ] ifFalse:[
                                    "/ this should not happen.
                                    Delay waitForSeconds:0.05
                                ]
                            ].
                        ]
                    ]
                ]
            ]
        ]
    ]

    "Modified: / 30-07-2013 / 10:30:38 / cg"
!

startReaderProcess
    "Start a reader process, which looks for the commands output,
     and sends me #processInput:n: events whenever something arrives."

    self obsoleteMethodWarning.    
    self startReaderProcessWhenVisible.

    "
     VT100TerminalView openShell
    "

    "Modified: / 5.5.1999 / 17:58:02 / cg"
    "Modified: / 28.1.2002 / 21:10:13 / micha"
!

startReaderProcessNow
    "Start a reader process, which looks for the commands output,
     and sends me #processInput:n: events whenever something arrives."

    self startReaderProcessWhenVisible:false

    "
     VT100TerminalView openShell
    "

    "Modified: / 5.5.1999 / 17:58:02 / cg"
    "Modified: / 28.1.2002 / 21:10:13 / micha"
!

startReaderProcessWhenVisible
    "Start a reader process, which looks for the commands output,
     and sends me #processInput:n: events whenever something arrives."

    self startReaderProcessWhenVisible:true

    "
     VT100TerminalView openShell
    "

    "Modified: / 5.5.1999 / 17:58:02 / cg"
    "Modified: / 28.1.2002 / 21:10:13 / micha"
!

startReaderProcessWhenVisible:whenVisible
    "Start a reader process, which looks for the commands output,
     and sends me #processInput:n: events whenever something arrives."

    readerProcess isNil ifTrue:[
        readerProcess := [
            [
                whenVisible ifTrue:[self waitUntilVisible].
                self readerProcessLoop.
            ] ifCurtailed:[
                readerProcess := nil    
            ]
        ] fork. "/ forkAt:9.
        readerProcess name:'pty reader'.
    ]

    "
     VT100TerminalView openShell
    "

    "Modified: / 5.5.1999 / 17:58:02 / cg"
    "Modified: / 28.1.2002 / 21:10:13 / micha"
!

stopReaderProcess
    "stop the background reader thread"

    |sensor|

    readerProcess notNil ifTrue:[
        readerProcess terminate.
        "/ give it a chance to really terminate
        Processor yield.
        readerProcess := nil
    ].

    "/ flush any leftover input-processing events
    (sensor := self sensor) notNil ifTrue:[
        sensor flushEventsFor:self withType:#processInput:n:.
    ]
    "Modified: / 21.7.1998 / 19:00:13 / cg"
! !

!TerminalView methodsFor:'searching'!

startPositionForSearchBackward
    ^ self startPositionForSearchBackwardBasedOnSelection
!

startPositionForSearchForward
    ^ self startPositionForSearchForwardBasedOnSelection
! !

!TerminalView methodsFor:'selection handling'!

autoMoveCursorToEndOfSelection
    "Redefined to return false since the cursor should
     not be affected by selecting"

    ^ false

!

copySelection
    super copySelection.
    self cursorToEndOfText
!

paste:someText
    "paste - redefined to send the chars to the shell instead
     of pasting into the view"

    |s nLines doLineEditMode|

    inStream isNil ifTrue:[
        self flash.
        ^ self           "/ already closed
    ]. 

    s := someText.
    s isString ifTrue:[
        s := s asStringCollection
    ] ifFalse:[
        (s isKindOf:StringCollection) ifFalse:[
            self warn:'selection (' , s class name , ') is not convertable to Text'.
            ^ self
        ]
    ].
    (nLines := s size) == 0 ifTrue:[^ self].
    (nLines == 1 and:[(s at:1) isEmptyOrNil]) ifTrue:[^ self].

    doLineEditMode := ((nLines == 1) and:[self shouldProcessInputInLineEditMode]).
    
    s keysAndValuesDo:[:idx :line |
        line notNil ifTrue:[
            (Debug or:[DebugKeyboard]) ifTrue:[
                Transcript showCR:'send paste line: ',line asByteArray hexPrintString
            ].
        ].
        doLineEditMode ifTrue:[
            line do:[:ch | self keyPressInLineEditMode:ch ].
            idx ~~ nLines ifTrue:[
                self keyPressInLineEditMode:#Return
            ]
        ] ifFalse:[
            self send:(line ? '').
            idx ~~ nLines ifTrue:[
                self sendLineEnd
            ]
        ]
    ].

    "Modified: / 12.6.1998 / 22:12:47 / cg"
!

selection
    |sel|

    sel := super selection.
    sel isNil ifTrue:[^ sel].

    "/ if it is a line-wise collection, return multiple lines;
    "/ otherwise, concatenate to make it one long string.
    "/ this allows for multi-line commands (many args) to be copy-pasted easily
    selectionStartCol == 1 ifTrue:[
        selectionEndCol == 0 ifTrue:[
            ^ sel "/ a full-line (3xclick selection)
        ].
    ].
    ^ StringCollection with:(sel asStringWith:'').
! !

!TerminalView methodsFor:'sending'!

send:aString
    "send aString to the underlying program's stdinput"

    aString notEmptyOrNil ifTrue:[
        aString containsNon7BitAscii ifTrue:[
            aString do:[:each |
                self sendCharacter:each
            ].
        ] ifFalse:[
            recorderStream notNil ifTrue:[
                recorderStream nextPutAll:aString
            ].
            (Debug or:[DebugKeyboard]) ifTrue:[
                Transcript showCR:'send <',aString,'>'
            ].
            inStream nextPutAll:aString
        ].
    ].

    "Created: / 29-07-2013 / 18:18:24 / cg"
!

sendCR:aString
    "send aString followed by a return to the underlying program's stdinput"

    self send:aString.
    self sendLineEnd.
!

sendCharacter:aCharacter
    "send a single character to the underlying program's stdin"

    aCharacter codePoint > 16r7F ifTrue:[
        inputIsUTF8 ifTrue:[
            aCharacter utf8Encoded do:[:eachUTFChar|
                (Debug or:[DebugKeyboard]) ifTrue:[
                    self debugPrintCharacter:eachUTFChar as:'send utf'.
                ].
                recorderStream notNil ifTrue:[
                    recorderStream nextPut:eachUTFChar
                ].
                inStream nextPut:eachUTFChar.
            ].
            ^ self
        ].
        aCharacter bitsPerCharacter > 8 ifTrue:[
            "/ ignore
            Transcript showCR:(self class name,': invalid (non-8bit) character ignored').
            ^ self
        ].
        "/ send normal
    ].

    recorderStream notNil ifTrue:[
        recorderStream nextPut:aCharacter
    ].
    (Debug or:[DebugKeyboard]) ifTrue:[
        self debugPrintCharacter:aCharacter as:'send'.
    ].

    inStream nextPut:aCharacter.

    "Created: / 29-07-2013 / 18:18:24 / cg"
!

sendLine:aString
    (Debug or:[DebugKeyboard]) ifTrue:[
        'VT100: sendline: ' print. aString asByteArray hexPrintString printCR
    ].

    self send:aString.
    self sendLineEnd
!

sendLineEnd
    inputTranslateCRToNL ifTrue:[
        self sendCharacter:(Character nl).
    ] ifFalse:[
        inputTranslateCRToCRNL ifTrue:[
            self send:(String crlf).
        ] ifFalse:[
            self sendCharacter:(Character return).
        ]
    ]
"/    OperatingSystem isMSDOSlike ifTrue:[
"/        self send:String crlf.
"/    ] ifFalse:[
"/        self send:String return.
"/    ].
! !

!TerminalView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


TerminalView initialize!
