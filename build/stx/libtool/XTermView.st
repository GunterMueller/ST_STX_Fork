"
 COPYRIGHT (c) 2006 by eXept Software AG
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

XEmbedContainerView subclass:#XTermView
	instanceVariableNames:'pid wid wd'
	classVariableNames:'XTermType XTermExecutable'
	poolDictionaries:''
	category:'Interface-Tools-Terminal'
!

!XTermView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
    self new open
"
! !

!XTermView class methodsFor:'class initialization'!

initialize

    XTermType := #unavailable.
    #(urxvt rxvt xterm uxterm) do:[:eachXtermCommandSymbol|    
        (XTermExecutable := OperatingSystem pathOfCommand:eachXtermCommandSymbol) notNil ifTrue:[
            XTermType := eachXtermCommandSymbol.
            ^ self
        ].
    ].

    "
        XTermView initialize 
    "

    "Created: / 09-12-2010 / 23:15:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView class methodsFor:'defaults'!

defaultFont

    DefaultFont ifNotNil:[^CodeView defaultFont].
    ^super defaultFont.

    "Created: / 25-11-2010 / 12:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateStyleCache

    super updateStyleCache.
    "/DefaultViewBackgroundColor := Color black.

    "Created: / 25-11-2010 / 12:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView class methodsFor:'queries'!

isAvailable

    ^XTermType ~= #unavailable

    "Created: / 09-12-2010 / 23:21:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'accessing'!

workingDirectory: aStringOrFilename

    aStringOrFilename ifNotNil:
        [wd := aStringOrFilename asString].

    "Created: / 25-11-2010 / 12:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'event handling'!

clientUnplugged: clientInitiated

    | app |

    super clientUnplugged: clientInitiated.

    clientInitiated ifFalse:[^self].
    
    "But hackish..."
    app := self application.
    app ifNil:[^self].
    (app class == FileApplicationNoteBook::Terminal) ifTrue:[
        app doClose.
        ^self.
    ].
    #(removeWorkspace "WorkspaceApplication"
      bufferMenuRemoveCurrentBuffer "NewSystemBrowser"
    ) do:[:closeSelector|
        (app topApplication respondsTo: closeSelector) ifTrue: [
            app topApplication perform: closeSelector.
            ^self
        ]
    ].

    "Created: / 06-06-2011 / 10:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'initialization & release'!

closeDownShell
    "shut down my shell process."

    |p|

    (p := pid) notNil ifTrue:[
        pid := nil.
        OperatingSystem terminateProcess: p
    ].
!

destroy
    self closeDownShell.
    super destroy.

    "Created: / 25-11-2010 / 10:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2011 / 13:13:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize

    super initialize.
    wd := Filename defaultDirectory asString

    "Created: / 25-11-2010 / 12:34:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'menu'!

doClear
    "reset the scroll-range etc, clear the text buffer"

"/    rangeStartLine := 1.
"/    rangeEndLine := numberOfLines.
"/
"/    self normal.
"/    self clear.

    "Created: / 03-04-2007 / 08:58:59 / cg"
    "Modified: / 03-04-2012 / 10:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doReset
    "reset the scroll-range; 
     may have to reset more in the future (current font-set; color; etc)"

"/    rangeStartLine := 1.
"/    rangeEndLine := numberOfLines.
"/
"/    self normal.

    "Modified: / 03-04-2012 / 10:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSendInterrupt
    "send an INT-signal to the shell (UNIX only)"
    pid notNil ifTrue:[
        OperatingSystem sendSignal:(OperatingSystem sigINT) to:pid negated.
    ].

    "Modified: / 10-06-1998 / 17:49:49 / cg"
    "Modified: / 03-04-2012 / 10:34:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSendKillSignal
    "send a KILL-signal to the shell (UNIX only)"

    pid notNil ifTrue:[
        OperatingSystem sendSignal:(OperatingSystem sigKILL) to:pid negated.
    ]

    "Modified: / 03-04-2012 / 10:34:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'mimicry'!

defaultFileNameForFileDialog

    ^nil

    "Created: / 03-05-2012 / 12:29:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineLimit:aSmallInteger

    "Nothing"

    "Created: / 03-04-2012 / 10:42:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

list
    ^nil

    "Created: / 17-07-2012 / 21:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modified

    ^false

    "Created: / 03-05-2012 / 11:42:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

save

    Dialog warn: 'Not yet implemented for XTermView'

    "Created: / 03-04-2012 / 10:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionAsString
    ^ (self graphicsDevice getSelectionOwnerOf: #PRIMARY) = self drawableId ifTrue:[
        self graphicsDevice getClipboardText:#selection for:self drawableId
    ] ifFalse:[
        nil
    ]

    "Created: / 03-04-2012 / 10:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendLine:aString
    self halt:'please define sendLine: here'.

    "Created: / 03-04-2012 / 10:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shellTerminateAction: aBlock

    "Nothing to do"

    "Created: / 25-11-2010 / 12:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startShellIn:aUnixFilename

    "Nothing to do. just to be compatible with TerminalView"

    "Created: / 25-11-2010 / 12:38:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'private'!

xcolorNameFor: aColor

    ^'rgb:%1/%2/%3' 
            bindWith: (aColor redByte   printStringRadix: 16)
                with: (aColor greenByte printStringRadix: 16)
                with: (aColor blueByte  printStringRadix: 16)

    "Created: / 25-11-2010 / 12:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xtermArgs
    | args |

    args := OrderedCollection new.
    args
        add: self xtermExecutable;
        add: (XTermType == #xterm ifTrue:['-into'] ifFalse:['-embed']); add:self embeddingWindowId printString;        
        add: '-j';
"/        add: '-font'; add: (device fullFontNameOf: (font fontId));
        add: '-fg'; add: 'white'"(self xcolorNameFor: foreground)";
        add: '-bg'; add: 'black'"(self xcolorNameFor: viewBackground)".

    XTermType == #rxvt ifTrue:[
    args
        add: '-tn'; add: 'xterm'
    ].

    ^args asArray

    "Modified: / 06-02-2014 / 20:03:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xtermExecutable

    ^ XTermExecutable

    "Modified: / 09-12-2010 / 23:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'queries'!

preferredExtent
    "return my preferred extent - this is the minimum size I would like to have.
     If the preferredExtent has been set, that one is returned.
     Otherwise, if there are any components, a rectangle enclosing them
     is returned. Otherwise, the actual extent is returned."

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    ^(gc font width * 80) @ (gc font height * 25)

    "Modified: / 19-07-1996 / 20:43:32 / cg"
    "Created: / 25-11-2010 / 12:51:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'realization'!

postRealize

    super postRealize.
    XTermType ~= #rxvt ifTrue:[self sizeChanged: nil]

    "Created: / 25-11-2010 / 11:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2010 / 22:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preRealize
    super preRealize.
    self startXTerm

    "Created: / 25-11-2010 / 10:51:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 23:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startXTerm
    clientViewId isNil ifTrue:[
        pid := OperatingSystem 
                exec:self xtermExecutable
                withArguments:self xtermArgs
                fork:true
                inDirectory: wd.
    ]

    "Created: / 25-11-2010 / 10:51:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 23:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView methodsFor:'testing'!

isTextView

    ^true

    "Created: / 13-09-2011 / 11:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XTermView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/XTermView.st,v 1.10 2014-06-05 18:25:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/XTermView.st,v 1.10 2014-06-05 18:25:15 cg Exp $'
!

version_SVN
    ^ '$Id: XTermView.st,v 1.10 2014-06-05 18:25:15 cg Exp $'
! !


XTermView initialize!
