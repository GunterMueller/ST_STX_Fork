"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

EnterBox subclass:#TextBox
	instanceVariableNames:'textViewClass textView'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!TextBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this class implements a pop-up box to enter some text with 2 buttons,
    one to cancel, another to start some action.
    It is basically an enterBox, but allows entering of more than one line
    of text.
"
!

examples
"
  Example (using ok-action callBack):
                                                                        [exBegin]
    |textBox|

    textBox := TextBox new.
    textBox title:'enter some text'.
    textBox action:[:text | Transcript showCR:('the entered text was:\' , text) withCRs].
    textBox showAtPointer.
                                                                        [exEnd]


  Example (asking afterwards):
                                                                        [exBegin]
    |textBox|

    textBox := TextBox new.
    textBox title:'enter some text'.
    textBox showAtPointer.
    textBox accepted ifTrue:[
        Transcript showCR:'accepted text is:'.
        Transcript showCR:textBox contents
    ].
                                                                        [exEnd]

  Example - readonly text (useful for status display):
                                                                        [exBegin]
    |textBox|

    textBox := TextBox new.
    textBox initialText:('Makefile' asFilename contents).
    textBox title:'Makefile:'.
    textBox readOnly:true.
    textBox noCancel.
    textBox label:'Makefile'.
    textBox extent:(600@250); sizeFixed:true.
    textBox showAtPointer.
                                                                        [exEnd]
"
! !

!TextBox class methodsFor:'common dialogs'!

openOn:someText
    "open a textBox on some text, 
     return (the possibly modified) text if accepted; nil otherwise."

    ^ self openOn:someText title:'Enter Text:'

    "
     TextBox openOn:'hello'
    "
!

openOn:someText title:titleString
    "open a textBox on some text, the titleString is shown above the text area as information 
     return (the possibly modified) text if accepted; nil otherwise."

    ^ self openOn:someText title:titleString readOnly:false

"/    |box returnValue|
"/
"/    box := self new.
"/    box title:titleString.
"/    box initialText:someText.
"/    box action:[:text | returnValue := text].
"/    box showAtPointer.
"/    ^ returnValue.

    "
     TextBox openOn:'hello' title:'hi there'
     TextBox openOn:'hello' title:'hi there
this is a very long title
but only the first line is shown in the
caption.
'
    "
!

openOn:someText title:titleString readOnly:readOnly
    "open a textBox on some text, 
     return (the possibly modified) text if accepted; nil otherwise."

    ^ self 
        openOn:someText 
        title:titleString 
        windowTitle:nil 
        readOnly:readOnly

    "
     TextBox openOn:'hello' title:'hi there' readOnly:true
     TextBox openOn:'hello' title:'hi there' readOnly:false
    "

    "Created: / 29-10-2010 / 17:10:04 / cg"
!

openOn:someText title:titleString windowTitle:windowTitle readOnly:readOnly
    "open a textBox on some text, the optional titleString is shown as label
     above the text areay. The optional windowTitle is used as title in the caption.        
     return (the possibly modified) text if accepted; nil otherwise."

    |box returnValue usedWindowTitle|

    box := self new.
    readOnly ifTrue:[ box textViewClass:TextView ].
    box initialize.
    titleString notNil ifTrue:[ box title:titleString ].
    box initialText:someText.
    box action:[:text | returnValue := text].
    box readOnly:readOnly.
    readOnly ifTrue:[ box abortButton destroy ].

    usedWindowTitle := windowTitle.
    usedWindowTitle isNil ifTrue:[
        titleString notNil ifTrue:[
            usedWindowTitle := titleString asString asStringCollection first
        ] ifFalse:[
            usedWindowTitle := readOnly ifTrue:'Value' ifFalse:'Input'
        ].
    ].
    box window label:usedWindowTitle.
    box showAtPointer.
    ^ returnValue.

    "
     TextBox openOn:'hello' title:'hi there' windowTitle:'some Box' readOnly:true
     TextBox openOn:'hello' title:'hi there' windowTitle:'some Box' readOnly:false
     TextBox openOn:'hello' title:'hi there' windowTitle:nil readOnly:false
     TextBox openOn:'hello' title:nil windowTitle:'some Box' readOnly:false
     TextBox openOn:'hello' title:nil windowTitle:nil readOnly:false
     TextBox openOn:'hello' title:nil windowTitle:'foo' readOnly:false
    "

    "Created: / 29-10-2010 / 17:10:04 / cg"
! !

!TextBox class methodsFor:'defaults'!

defaultExtent
    ^ (Screen current pixelPerMillimeter * (120 @ 90)) rounded
! !

!TextBox methodsFor:'accessing'!

contents
    "return my contents"

    ^ textView contents
!

initialText:aString
    "define the initial text in the enterfield"

    textView contents:aString
!

readOnly:aBoolean
    "make my text readOnly or readWrite"

    textView readOnly:aBoolean
!

textView
    ^ textView
!

textViewClass:something
    textViewClass := something.
! !

!TextBox methodsFor:'initialization'!

initialize
    |space2 space3 innerWidth|

    super initialize.

    enterField destroy.

    space2 := 2 * ViewSpacing.
    space3 := 3 * ViewSpacing.

    "kludge: preset extent to something useful since other subviews
     depend on it (extent blocks are not evaluated until view is realized)
     - avoid visible resizing when realized the first time"

    innerWidth := width - space2.

    textView := HVScrollableView for:(textViewClass ? EditTextView) miniScrollerH:true in:self.
    textView origin:(ViewSpacing @ (space2 + labelField height))
             extent:(innerWidth @ (height - ViewSpacing -
                                   labelField height - ViewSpacing -
                                   buttonPanel height - space3) ).
    textView origin:[ViewSpacing @ (space2 + labelField height)]
             extent:[(width - space2) @ (height - ViewSpacing -
                                   labelField height - ViewSpacing -
                                   buttonPanel height - space3) ].

    self delegate:(KeyboardForwarder toView:textView scrolledView)

    "TextBox new showAtPointer"

    "Modified: / 29-10-2010 / 17:14:49 / cg"
! !

!TextBox methodsFor:'queries'!

preferredExtent
    "return the extent needed to make everything visible"

    |wWanted hWanted wPanel|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    wWanted := labelField width + ViewSpacing + ViewSpacing.
    (wWanted > width) ifFalse:[
        wWanted := width
    ].
    wPanel := ViewSpacing * 3.
    buttonPanel subViews do:[:aView |
        wPanel := wPanel + aView width + ViewSpacing
    ].
    wPanel > wWanted ifTrue:[
        wWanted := wPanel
    ].
    hWanted := ViewSpacing + labelField height +
               ViewSpacing + textView height +
               (ViewSpacing * 6) + buttonPanel preferredHeight +
               ViewSpacing.
    ^ (wWanted @ hWanted)
! !

!TextBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TextBox.st,v 1.25 2015-05-04 13:47:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/TextBox.st,v 1.25 2015-05-04 13:47:26 cg Exp $'
! !

