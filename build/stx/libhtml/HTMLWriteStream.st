"
 COPYRIGHT (c) 1996 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

WriteStream subclass:#HTMLWriteStream
	instanceVariableNames:'currentEmphasis'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!HTMLWriteStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    a simple stream, which behaves somewhat printer-like,
    in supporting emphasis's of #bold, #italic, #strikeout and #underline.
    These are translated to corresponding HTML commands.
    This Stream does not support HTML markup.

    ATTENTION: obsolete - use the HTMLTreeBuilder, if you have to generate HTML.

    [caveat:]
        should be merged with HTMLFilterStream into one.

    [author:]
        Claus Gittinger

    [see also:]
        PrinterStream
        Text
        HTMLFilterStream
"
!

examples
"
  convert smalltalk-style emphasis changes to HTML commands:
                                                        [exBegin]
    |s|

    s := HTMLWriteStream on:''.
    s 
        nextPutAll:'hello ';
        bold;
        nextPutAll:'world';
        normal;
        cr;
        nextPutAll:'this is ';
        italic;
        nextPutAll:'emphasized';
        normal;
        nextPutAll:' text.';
        cr.
    Transcript showCR:(s contents)
                                                        [exEnd]
"
! !

!HTMLWriteStream methodsFor:'emphasis'!

bold
    "change to bold"

    (Text emphasis:currentEmphasis includes:#bold) ifTrue:[^ self].
    self normal.
    super nextPutAll:'<b>'.
    currentEmphasis := #bold.

    "Created: 14.5.1996 / 17:46:16 / cg"
    "Modified: 14.5.1996 / 17:48:21 / cg"
!

boldItalic
    "change to bold"

    (Text emphasis:currentEmphasis includes:#bold) ifTrue:[
        (Text emphasis:currentEmphasis includes:#italic) ifTrue:[
            ^ self
        ].
    ].
    self normal.
    super nextPutAll:'<b><i>'.
    currentEmphasis := #(bold italic).

    "Modified: 14.5.1996 / 17:48:21 / cg"
    "Created: 14.5.1996 / 17:49:23 / cg"
!

emphasis:anEmphasis
    "change the emphasis"

    anEmphasis isNil ifTrue:[
        ^ self normal
    ].
    anEmphasis == #bold ifTrue:[
        ^ self bold
    ].
    anEmphasis == #italic ifTrue:[
        ^ self italic
    ].
    anEmphasis == #underline ifTrue:[
        ^ self underline
    ].
    anEmphasis == #strikeout ifTrue:[
        ^ self strikeout
    ].
!

italic
    "change to italic"

    (Text emphasis:currentEmphasis includes:#italic) ifTrue:[^ self].
    self normal.

    super nextPutAll:'<i>'.
    currentEmphasis := #italic.

    "Modified: 14.5.1996 / 17:48:09 / cg"
!

normal
    "change to normal"

    (Text emphasis:currentEmphasis includes:#italic) ifTrue:[
        super nextPutAll:'</i>'.
    ].
    (Text emphasis:currentEmphasis includes:#bold) ifTrue:[
        super nextPutAll:'</b>'.
    ].
    (Text emphasis:currentEmphasis includes:#underline) ifTrue:[
        super nextPutAll:'</u>'.
    ].
    (Text emphasis:currentEmphasis includes:#strikeout) ifTrue:[
        super nextPutAll:'</s>'.
    ].

    currentEmphasis := nil.

    "Created: 14.5.1996 / 17:47:57 / cg"
    "Modified: 14.5.1996 / 17:49:36 / cg"
! !

!HTMLWriteStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLWriteStream.st,v 1.3 2009-05-13 09:05:58 cg Exp $'
! !
