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

WriteStream subclass:#HTMLFilterStream
	instanceVariableNames:'runs outStream loHeaders'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!HTMLFilterStream class methodsFor:'documentation'!

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
    A stream, which can generate HTML markup.
    It may be useful, when generating HTML documents.

    ATTENTION: obsoleted by the HTMLTree builder, which provides a similar functionality
    but is more complete and maintained. Please migrate, if you still use this.

    [caveat:]
        should be merged with HTMLWriteStream into one.

    [authors:]
        Claus Gittinger
        Claus Atzkern

    [See also:]
        ReadStream WriteStream
        HTMLWriteStream HTMLDocumentView
        ( HTML-3 reference :html: english/html/html-3_spec/CoverPage.html )
        ( HTML Einf&uuml;hrung (german) :html: german/html/html_einfuehrung.html )

"
!

examples
"
  generate a small document and display it:
                                                [exBegin]
    |collector html|

    collector := WriteStream on:''.
    html := HTMLFilterStream writingTo:collector.

    html html.
      html head.
        html title:'TestDocument'.
      html headEnd.

      html body.
        html h:1.
        html nextPutAll:'Chapter1'.
        html hEnd.

        html p.
        html nextPutLine:'some text'.
        html nextPutLine:'more text'.
        html br.
        html nextPutLine:'and even more text'.
      html bodyEnd.
    html htmlEnd.

    HTMLDocumentView openOnText:collector contents.
                                                [exBegin]
"
! !

!HTMLFilterStream class methodsFor:'instance creation'!

on:something
    "return a new HTMLFilterStream, which sends its output to
     something (which must be a Stream or convertable to a writeStream)"

    |s|

    something isStream ifFalse:[
        s := something writeStream
    ] ifTrue:[
        s := something
    ].
    ^ self writingTo:s

    "Modified: 23.1.1997 / 14:24:02 / cg"
!

writingTo:aStream
    "return a new HTMLFilterStream, which sends its output to
     another stream"

    |newStream|

    newStream := super on:nil.
    newStream outStream:aStream.
    ^ newStream

    "Created: 11.1.1997 / 16:40:29 / cg"
! !

!HTMLFilterStream methodsFor:'accessing'!

outStream
    "returns output stream
    "
    ^ outStream
! !

!HTMLFilterStream methodsFor:'elements - document'!

body
    outStream nextPutAll:'<BODY>'; cr.

!

bodyEnd
    outStream nextPutAll:'</BODY>'; cr.

!

head
    outStream nextPutAll:'<HEAD>'; cr.

!

headEnd
    outStream nextPutAll:'</HEAD>'; cr.

!

html
    outStream nextPutAll:'<HTML>'; cr.

!

htmlEnd
    outStream nextPutAll:'</HTML>'; cr.

!

title:aTitle
    outStream nextPutAll:'<TITLE>', aTitle asString, '</TITLE>'; cr.
! !

!HTMLFilterStream methodsFor:'elements - lists'!

dd
    outStream nextPutAll:'<DD>'

!

dl
    outStream nextPutAll:'<DL>'; cr.

!

dlEnd
    outStream nextPutAll:'</DL>'; cr.

!

dt
    outStream nextPutAll:'<DT>'

!

li
    outStream nextPutAll:'<LI>'.

!

ul
    outStream nextPutAll:'<UL>'; cr.

!

ulEnd
    outStream nextPutAll:'</UL>'; cr.

! !

!HTMLFilterStream methodsFor:'elements - special'!

img:aFile hspace:hspace

    outStream nextPutAll:'<IMG src="'
                        , aFile asString
                        , '" hspace='
                        , hspace printString
                        , '>'; cr


! !

!HTMLFilterStream methodsFor:'elements - structure'!

br
    outStream nextPutAll:'<BR>'; cr.


!

h:number
    "begin header with number
    "
    outStream nextPutAll:'<H', number printString, '>'.
    loHeaders add:number.


!

hEnd
    "end header definition
    "
    |number|

    loHeaders notEmpty ifTrue:[
        number := loHeaders removeLast.
        outStream nextPutAll:'</H', number printString, '>'; cr
    ].


!

hr
    outStream nextPutAll:'<HR>'; cr.

!

p
    outStream nextPutAll:'<P>'; cr.

!

pEnd
    outStream nextPutAll:'</P>'; cr.

!

pre
    outStream nextPutAll:'<PRE>'.

!

preEnd
    outStream nextPutAll:'</PRE>'; cr.

! !

!HTMLFilterStream methodsFor:'elements - style'!

blockquote
    outStream nextPutAll:'<BLOCKQUOTE>'; cr.
!

blockquoteEnd
    outStream nextPutAll:'</BLOCKQUOTE>'; cr.

! !

!HTMLFilterStream methodsFor:'initialization'!

outStream:aStream
    outStream := aStream.
    loHeaders := OrderedCollection new.
    collection := nil.
! !

!HTMLFilterStream methodsFor:'private accessing'!

emphasis:attr on:on
    "turn on/off some emphasis"

    |id|

                attr == #bold      ifTrue:[ id := $B
    ] ifFalse:[ attr == #italic    ifTrue:[ id := $I
    ] ifFalse:[ attr == #underline ifTrue:[ id := $U
    ] ifFalse:[ attr == #strikeout ifTrue:[ id := $S
    ] ifFalse:[ ^ self
    ]]]].

                 outStream nextPut:$<.
    on ifFalse:[ outStream nextPut:$/ ].
                 outStream nextPut:id.
                 outStream nextPut:$>.

    "Modified: 11.1.1997 / 16:54:13 / cg"
!

removeAllEmphasis

    runs notNil ifTrue:[
        runs do:[:attr| self emphasis:attr on:false ].
        runs := nil
    ].





! !

!HTMLFilterStream methodsFor:'writing'!

emphasis:emphasis

    |newRun|

    emphasis isNil ifTrue:[
        ^ self removeAllEmphasis
    ].

    runs isNil ifTrue:[
        runs := IdentitySet new.

        emphasis isSymbol ifTrue:[
            runs add:emphasis.
            self emphasis:emphasis on:true.
        ] ifFalse:[
            emphasis do:[:el|
                runs add:el.
                self emphasis:el on:true.
            ]
        ]
    ] ifFalse:[
        emphasis isSymbol ifTrue:[
            runs do:[:el|
                el == emphasis ifFalse:[
                    runs saveRemove:el.
                    self emphasis:el on:false
                ]
            ].
            runs rehash.

            (runs includes:emphasis) ifFalse:[
                runs add:emphasis.
                self emphasis:emphasis on:true.
            ]
        ] ifFalse:[

            newRun := IdentitySet new.

            runs do:[:el|
                (emphasis includes:el) ifFalse:[
                    self emphasis:el on:false
                ]
            ].

            emphasis do:[:el|
                (runs includes:el) ifFalse:[
                    self emphasis:el on:true
                ].
                newRun add:el.
            ].
            runs := newRun
        ]
    ]
!

nextPut:aCharacter
    "append the argument, anCharacter to the stream;
     handle escapes here."

    aCharacter == $< ifTrue:[
        outStream nextPutAll:'&lt;'.
        ^ self
    ].
    aCharacter == $> ifTrue:[
        outStream nextPutAll:'&gt;'.
        ^ self
    ].
    aCharacter == $& ifTrue:[
        outStream nextPutAll:'&amp;'.
        ^ self
    ].

    "/ more needed ...

    outStream nextPut:aCharacter

    "Modified: 11.1.1997 / 16:42:58 / cg"
! !

!HTMLFilterStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLFilterStream.st,v 1.7 2009-05-13 09:06:03 cg Exp $'
! !
