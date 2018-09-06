"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

DialogBox subclass:#MessageBox
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!

!MessageBox class methodsFor:'documentation'!

examples
"
        MessageBox new
                        abortRetryIgnore;
                        defaultButton: 3;
                        warning: 'hello world'
"
! !

!MessageBox methodsFor:'accessing-behavior'!

defaultButton:defaultIndex
    buttonPanel subViews 
        keysAndValuesDo:[:buttonIdx :button | 
            button isReturnButton:(defaultIndex == buttonIdx)]                    
! !

!MessageBox methodsFor:'construction-buttons'!

abortRetryIgnore
    "create abort-, retry- and Ignore Buttons"

    self addAbortButton; addRetryButton; addIgnoreButton
!

addIgnoreButton
    "create a ignoreButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

    |b|

    b := self addAbortButtonLabelled:'Ignore'.
    b change:#ignorePressed.
    ^ b
!

addRetryButton
    "create a retryButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

    |b|

    b := self addAbortButtonLabelled:'Retry'.
    b change:#retryPressed.
    ^ b
! !

!MessageBox methodsFor:'startup'!

warning:aString
    |y l1 l2 icon|

    y := self yPosition.
    l1 := self addTextLabel:(icon := WarningBox warnIconBitmap).
    l1 width:(icon width).
    self yPosition:y.

    self leftIndent:(icon width * 1.5) rounded.
    l2 := self addTextLabel:aString.
    self leftIndent:0.

    self label:'Warning'.
    "/ self icon:icon.
    self open.

    ^ acceptValue value.
! !

!MessageBox methodsFor:'user actions'!

ignorePressed
    acceptValue value:#ignore.
    self hide.
!

retryPressed
    acceptValue value:#retry.
    self hide.
! !

!MessageBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__MessageBox.st,v 1.3 2017-11-28 18:03:31 cg Exp $'
!

version_SVN
    ^ '$Id: Dolphin__MessageBox.st,v 1.3 2017-11-28 18:03:31 cg Exp $'
! !

