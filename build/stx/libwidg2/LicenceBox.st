"
 COPYRIGHT (c) 1996 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

DialogBox subclass:#LicenceBox
	instanceVariableNames:'accepted destroySemaphore fileName textView'
	classVariableNames:'LicenceRejectSignal'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!LicenceBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    LicenceBox shows a licence text when opened, an returns true,
    if the licence has been accepted, false otherwise.

    [author:]
	Stefan Vogel

    [start with:]
	LicenceBox open

    [see also:]
	AboutBox
"
!

examples
"
						[exBegin]
    LicenceRejectSignal handle:[:ex|
	Transcript showCR:'Licence rejected'.
    ] do:[
	LicenceBox open.
	Transcript showCR:'Licence accepted'.
    ]
						[exEnd]
"
! !

!LicenceBox class methodsFor:'initialization'!

initialize
    LicenceRejectSignal isNil ifTrue:[
	LicenceRejectSignal := ErrorSignal newSignalMayProceed:true.
	LicenceRejectSignal nameClass:self message:#licenceRejectSignal.
	LicenceRejectSignal notifierString:'licence rejected by user'.
    ].

    "
     self initialize
    "
! !

!LicenceBox class methodsFor:'instance creation'!

open
    "open myself modal and return true if accepted, false otherwise"

    ^ super open accepted.

    "
     LicenceBox open
    "

    "Modified: 9.9.1996 / 17:52:48 / stefan"
!

openOnFile:aFileName
    "like open, but show the HTML-text found in aFileName.
     Can be used for end-user applications which want to display
     there own licence text."

    |box f fn text dir|

    box := self new.

    (f := aFileName asFilename) exists ifTrue:[
	text := f contents.
	dir := f directoryName.
    ] ifFalse:[
	fn := Smalltalk getSystemFileName:aFileName.
	fn notNil ifTrue:[
	    f := fn asFilename.
	    text := f contents.
	    dir := f directoryName.
	]
    ].
    text notNil ifTrue:[
	box licenceText:text.
	box topDirectory:dir.
    ].
    box open

    "
     LicenceBox openOnFile:'doc/online/english/TOP.html'

     (LicenceBox licenceRejectSignal catch:[
	LicenceBox openOnFile:'doc/online/english/TOP.html'
     ]) ifTrue:[
	self information:'rejected'
      ]
    "
! !

!LicenceBox class methodsFor:'Signal constants'!

licenceRejectSignal
    "licence has been rejected by user"

    ^ LicenceRejectSignal

! !

!LicenceBox methodsFor:'accessing'!

accepted
    "return accepted"

    ^ accepted

    "Created: 6.9.1996 / 13:24:44 / stefan"
!

accepted:something
    "set accepted"

    accepted := something.

    "Created: 6.9.1996 / 13:24:44 / stefan"
!

licenceText:someHTMLText
    "set the text which is shown in the box"

    textView setText:someHTMLText.
!

topDirectory:aDirectoryName
    "set the topDirectory, which is required for hyperlinks
     to work (in the html text)"

    textView setTopDirectoryName:aDirectoryName.
! !

!LicenceBox methodsFor:'destroying'!

terminate
    "this is the close from a windowmanager
     (only if UseTransientViews == true).
     Redefined, since ModalBox keeps the View alive (only hidden)"

    self destroy.

    "Created: 9.9.1996 / 15:15:31 / stefan"
! !

!LicenceBox methodsFor:'initialization'!

initialize
    |nLines displayHeight|

    super initialize.

    displayHeight := self graphicsDevice usableHeight.
    nLines := displayHeight // 25.

"/    (displayHeight < 800) ifTrue:[
"/        (displayHeight < 500) ifTrue:[
"/            nLines := 20
"/        ] ifFalse:[
"/            nLines := 30
"/        ]
"/    ] ifFalse:[
"/        nLines := 40
"/    ].

    accepted := false.

    (self addTextLabel:(resources string:'Please read the licence terms:')) adjust:#left.
    textView := self addTextBoxOn:nil
                        class:HTMLDocumentView
                        withNumberOfLines:nLines
                        hScrollable:true
                        vScrollable:true.

    self width:(textView preferredExtentForLines:nLines cols:70) x.
    textView setText:(self licenceText).
    textView setTopDirectoryName:(self topDirectory).
    self addAbortButtonLabelled:(resources string:'Reject licence terms').
    self addOkButtonLabelled:(resources string:'Accept licence terms').
    self abortAction:[self destroy. accepted := false. LicenceRejectSignal raise].
    self okAction:[self destroy. accepted := true].
    self stickAtBottomWithVariableHeight:textView.
    self label:'ST/X Licence Dialog'.

    "Modified: 9.9.1996 / 17:52:13 / stefan"
!

mapped
    super mapped.

    self graphicsDevice isWindowsPlatform ifTrue:[
        "/ kludge
        [
            Delay waitForSeconds:0.5.
            self raise.
            self activate.
            self setForegroundWindow.
            self activate.
        ] fork.
    ].

    "
     self open
    "
! !

!LicenceBox methodsFor:'private'!

licenceFile
    "get filename of licence file"

    |relName|

    fileName isNil ifTrue:[
        fileName := relName := resources at:'LICENCEFILE' default:nil.
        fileName isNil ifTrue:[
            Smalltalk releaseIdentification = 'ST/X_free_demo_vsn' ifTrue:[
                relName := 'doc/online/english/LICENCE_DEMO_STX.html'.
            ] ifFalse:[
                relName := 'doc/online/english/LICENCE_STX.html'.
            ].
            fileName := relName.
        ].

        fileName asFilename exists ifFalse:[
            fileName := Smalltalk getSystemFileName:relName.
            fileName isNil ifTrue:[
                fileName := Smalltalk getSystemFileName:'doc/online/' , relName.
                fileName isNil ifTrue:[
                    fileName := Smalltalk getSystemFileName:('../' , relName).
                    fileName isNil ifTrue:[
                        fileName := Smalltalk getSystemFileName:('../../' , relName).
                        fileName isNil ifTrue:[
                            fileName := Smalltalk getSystemFileName:'doc/online/german/LICENCE_STX.html'.
                            fileName isNil ifTrue:[
                                fileName := '../../doc/online/german/LICENCE_STX.html'.
                            ]
                        ]
                    ].
                ].
            ]
        ].
        fileName asFilename exists ifFalse:[
            fileName := nil
        ].
    ].
    ^ fileName

    "
     LicenceBox new licenceFile
    "

    "Modified: / 23-04-1998 / 11:40:25 / cg"
    "Modified: / 30-12-2016 / 23:04:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

licenceText
    "get licence text"

    |file|

    file := self licenceFile.
    file isNil ifTrue:[
	^ 'oops - you are not supposed to remove the LICENSE file !!

- or the documentation files have not been installed correctly;
- or your systemPath settings are not correct.'
    ].
    ^ file asFilename contents.

    "
     LicenceBox new licenceText
    "

!

topDirectory
    "get name of top directory"

    |file|

    file := self licenceFile.
    file isNil ifTrue:[
	^ ''
    ].
    ^ file asFilename directoryName.

    "
     LicenceBox new topDirectory
    "

! !

!LicenceBox methodsFor:'queries'!

windowStyle
    ^ #normal.
    ^ #dialog.
    ^ super windowStyle.

    "
     self new windowStyle
    "
! !

!LicenceBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/LicenceBox.st,v 1.30 2014-09-25 19:43:38 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/LicenceBox.st,v 1.30 2014-09-25 19:43:38 stefan Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


LicenceBox initialize!
