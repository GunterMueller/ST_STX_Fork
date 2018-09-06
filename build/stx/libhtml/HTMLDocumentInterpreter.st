"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HTMLDocumentInterpreter
	instanceVariableNames:'document element previousElement'
	classVariableNames:'SelectorTable'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocumentInterpreter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Please read the Caveat & Warning in HTMLDocumentPainter.
    
    An abstract class to walk through a list of HTML elements
    (i.e. the document) and perform an action on each
    (by sending self-messages named after the elements tag).

    Not useful by its own, but provides a framework for
    both HTML displayers and processors 
    (i.e. must be subclassed).
"
! !

!HTMLDocumentInterpreter class methodsFor:'initialization'!

initializeSelectorTable
    SelectorTable isNil ifTrue:[
        SelectorTable := IdentityDictionary new.

        #(
            a
            title head body html plain meta link base bgsound

            h1 h2 h3 h4 h5 h6 h7 h8 h9
            p hr br div tab wbr
            li_ul li_ol

            b u i tt big small sub sup

            address abbrev acronym au blink blockquote
            center cite code span del dfn em font ins
            kbd lang nobr person q s strike samp strong var

            ul menu dir dl ol dd dt li
            pre xmp col caption table td tr th

            form select textarea input option
            area map img app applet jwssuperapplet script 

            frame frameset internalMathFont
        ) do:[:ok | SelectorTable at:ok put:ok].

        SelectorTable at:#'/title' put:#'titleEnd'.
        SelectorTable at:#'/head'  put:#'headEnd'.
        SelectorTable at:#'/body'  put:#'bodyEnd'.
        SelectorTable at:#'/html'  put:#'htmlEnd'.
        SelectorTable at:#'/plain' put:#'plainEnd'.

        SelectorTable at:#'/h1'    put:#'h1End'.
        SelectorTable at:#'/h2'    put:#'h2End'.
        SelectorTable at:#'/h3'    put:#'h3End'.
        SelectorTable at:#'/h4'    put:#'h4End'.
        SelectorTable at:#'/h5'    put:#'h5End'.
        SelectorTable at:#'/h6'    put:#'h6End'.
        SelectorTable at:#'/h7'    put:#'h7End'.
        SelectorTable at:#'/h8'    put:#'h8End'.
        SelectorTable at:#'/h9'    put:#'h9End'.

        SelectorTable at:#'/p'     put:#'pEnd'.
        SelectorTable at:#'/div'   put:#'divEnd'.

        SelectorTable at:#'/b'     put:#'bEnd'.
        SelectorTable at:#'/u'     put:#'uEnd'.
        SelectorTable at:#'/i'     put:#'iEnd'.
        SelectorTable at:#'/tt'    put:#'ttEnd'.
        SelectorTable at:#'/big'   put:#'bigEnd'.
        SelectorTable at:#'/small' put:#'smallEnd'.
        SelectorTable at:#'/sub'   put:#'subEnd'.
        SelectorTable at:#'/sup'   put:#'supEnd'.

        SelectorTable at:#'/address' put:#'addressEnd'.
        SelectorTable at:#'/abbrev'  put:#'abbrevEnd'.
        SelectorTable at:#'/acronym' put:#'acronymEnd'.
        SelectorTable at:#'/au'      put:#'auEnd'.
        SelectorTable at:#'/blockquote'  put:#'blockquoteEnd'.
        SelectorTable at:#'/cite'    put:#'citeEnd'.
        SelectorTable at:#'/code'    put:#'codeEnd'.
        SelectorTable at:#'/span'    put:#'spanEnd'.
        SelectorTable at:#'/del'     put:#'delEnd'.
        SelectorTable at:#'/dfn'     put:#'dfnEnd'.
        SelectorTable at:#'/em'      put:#'emEnd'.
        SelectorTable at:#'/font'    put:#'fontEnd'.
        SelectorTable at:#'/ins'     put:#'insEnd'.
        SelectorTable at:#'/kbd'     put:#'kbdEnd'.
        SelectorTable at:#'/lang'    put:#'langEnd'.
        SelectorTable at:#'/person'  put:#'personEnd'.
        SelectorTable at:#'/q'       put:#'qEnd'.
        SelectorTable at:#'/s'       put:#'sEnd'.
        SelectorTable at:#'/strike'  put:#'strikeEnd'.
        SelectorTable at:#'/samp'    put:#'sampEnd'.
        SelectorTable at:#'/strong'  put:#'strongEnd'.
        SelectorTable at:#'/var'     put:#'varEnd'.
        SelectorTable at:#'/blink'   put:#'blinkEnd'.
        SelectorTable at:#'/center'  put:#'centerEnd'.
        SelectorTable at:#'/nobr'    put:#'nobrEnd'.

        SelectorTable at:#'/a'       put:#'aEnd'.

        SelectorTable at:#'/ul'    put:#'ulEnd'.
        SelectorTable at:#'/menu'  put:#'menuEnd'.
        SelectorTable at:#'/dir'   put:#'dirEnd'.
        SelectorTable at:#'/dl'    put:#'dlEnd'.
        SelectorTable at:#'/ol'    put:#'olEnd'.
        SelectorTable at:#'/dd'    put:#'ddEnd'.
        SelectorTable at:#'/dt'    put:#'dtEnd'.
        SelectorTable at:#'/li'    put:#'liEnd'.

        SelectorTable at:#'/pre'    put:#'preEnd'.
        SelectorTable at:#'/xmp'    put:#'xmpEnd'.

        SelectorTable at:#'/col'       put:#'colEnd'.
        SelectorTable at:#'/caption'   put:#'captionEnd'.
        SelectorTable at:#'/table'     put:#'tableEnd'.
        SelectorTable at:#'/td'        put:#'tdEnd'.
        SelectorTable at:#'/tr'        put:#'trEnd'.
        SelectorTable at:#'/th'        put:#'thEnd'.

        SelectorTable at:#'/form'      put:#'formEnd'.
        SelectorTable at:#'/select'    put:#'selectEnd'.
        SelectorTable at:#'/textarea'  put:#'textareaEnd'.

        SelectorTable at:#'/map'       put:#'mapEnd'.

        SelectorTable at:#'/applet'           put:#'appletEnd'.
        SelectorTable at:#'/jwssuperapplet'   put:#'jwssuperappletEnd'.
        SelectorTable at:#'/script'           put:#'scriptEnd'.

        SelectorTable at:#'/frameset'         put:#'framesetEnd'.
        SelectorTable at:#'/internalMathFont' put:#'internalMathFontEnd'.
    ]

    "
     SelectorTable := nil.
     HTMLDocumentInterpreter initialize
    "

    "Modified: 8.8.1997 / 14:42:08 / cg"
!

selectorTable
    SelectorTable isNil ifTrue:[
        self initializeSelectorTable
    ].
    ^ SelectorTable
!

xx_initialize
    "/ SelectorTable isNil ifTrue:[
    "/     self initializeSeletorTable.    -- now done lazily
    "/ ].

    "
     SelectorTable := nil.
     HTMLDocumentInterpreter initialize
    "

    "Modified: 8.8.1997 / 14:42:08 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-document'!

base
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 22:17:53 / cg"
!

body
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:04 / cg"
!

bodyEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:06 / cg"
!

frame
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 5.9.1996 / 13:47:47 / cg"
!

frameEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 5.9.1996 / 13:47:47 / cg"
!

frameset
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 5.9.1996 / 13:47:29 / cg"
!

framesetEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 5.9.1996 / 13:47:30 / cg"
!

head
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:50:47 / cg"
!

headEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:55:36 / cg"
!

html
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:49:02 / cg"
!

htmlEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:55:32 / cg"
!

link
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 17:46:21 / cg"
!

meta
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 30.6.1997 / 13:49:35 / cg"
!

style
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 24.2.1997 / 11:31:09 / cg"
!

styleEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 24.2.1997 / 11:31:10 / cg"
!

title
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:50:57 / cg"
!

titleEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 14:55:28 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-forms'!

form
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:17:24 / cg"
!

formEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:20:22 / cg"
!

input
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:20:19 / cg"
!

option
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:47:58 / cg"
!

select
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:20:26 / cg"
!

selectEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:20:27 / cg"
!

textarea
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:47:48 / cg"
!

textareaEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:47:51 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-lists'!

dd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:16 / cg"
!

ddEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:18 / cg"
!

dir
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:10:11 / cg"
!

dirEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:10:12 / cg"
!

dl
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:13 / cg"
!

dlEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:15 / cg"
!

dt
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:20 / cg"
!

dtEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:22 / cg"
!

li
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:08:30 / cg"
!

liEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 26.7.1996 / 18:14:23 / cg"
!

menu
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:02:09 / cg"
!

menuEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:02:14 / cg"
!

ol
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:11 / cg"
!

olEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:09 / cg"
!

ul
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:06 / cg"
!

ulEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:04:07 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-pseudo tags'!

internalMathFont
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 16.10.1996 / 15:44:58 / cg"
!

internalMathFontEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 16.10.1996 / 15:45:12 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-special'!

a
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:03:19 / cg"
!

aEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:03:20 / cg"
!

app
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 22:30:53 / cg"
!

appEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 22:30:55 / cg"
!

applet
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 26.6.1996 / 09:14:10 / cg"
!

appletEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 26.6.1996 / 09:14:08 / cg"
!

area
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:52:30 / cg"
!

bgsound
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 5.9.1996 / 12:49:20 / cg"
!

img
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:08:55 / cg"
!

jwssuperapplet
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 26.6.1996 / 09:14:16 / cg"
!

jwssuperappletEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 26.6.1996 / 09:14:18 / cg"
!

map
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:52:26 / cg"
!

mapEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 18:52:28 / cg"
!

param
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 8.10.1996 / 16:36:09 / cg"
!

paramEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 8.10.1996 / 16:38:12 / cg"
!

script
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 30.6.1996 / 15:49:33 / cg"
!

scriptEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 30.6.1996 / 15:49:34 / cg"
!

specialMarkup

    "Created: 17.5.1996 / 15:03:05 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-structure'!

br
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:22:06 / cg"
!

div
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: / 17.11.1998 / 18:33:00 / cg"
!

divEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: / 17.11.1998 / 18:33:00 / cg"
!

h1
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:15 / cg"
!

h1End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:16 / cg"
!

h2
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:18 / cg"
    "Modified: 19.6.1997 / 10:21:45 / cg"
!

h2End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:19 / cg"
!

h3
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:21 / cg"
!

h3End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:23 / cg"
!

h4
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:25 / cg"
!

h4End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:27 / cg"
!

h5
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:29 / cg"
!

h5End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:30 / cg"
!

h6
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:32 / cg"
!

h6End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:34 / cg"
!

h7
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:32 / cg"
!

h7End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:34 / cg"
!

h8
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:32 / cg"
!

h8End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:34 / cg"
!

h9
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:32 / cg"
!

h9End
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:00:34 / cg"
!

hr
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:08:45 / cg"
!

nobr
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.7.1996 / 11:05:02 / cg"
!

nobrEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.7.1996 / 11:05:05 / cg"
!

p
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:01:42 / cg"
!

pEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:01:43 / cg"
!

plain
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:40:11 / cg"
!

plainEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 20.5.1996 / 19:40:13 / cg"
!

pre
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:21:18 / cg"
!

preEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:21:19 / cg"
!

tab
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 21:25:42 / cg"
!

wbr
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 21:23:31 / cg"
!

xmp
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:21:18 / cg"
!

xmpEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:21:19 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-style'!

abbrev
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:12 / cg"
!

abbrevEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:14 / cg"
!

acronym
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:17 / cg"
!

acronymEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:19 / cg"
!

address
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:06 / cg"
!

addressEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:07 / cg"
!

au
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:22 / cg"
!

auEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:23 / cg"
!

blink
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:49 / cg"
!

blinkEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:50 / cg"
!

blockquote
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:27 / cg"
!

blockquoteEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:29 / cg"
!

center
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:54 / cg"
!

centerEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:55 / cg"
!

cite
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:01:51 / cg"
!

citeEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:01:52 / cg"
!

code
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:34 / cg"
!

codeEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:35 / cg"
!

del
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:43 / cg"
!

delEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:44 / cg"
!

dfn
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:46 / cg"
!

dfnEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:48 / cg"
!

em
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:52 / cg"
!

emEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:53 / cg"
!

font
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:12:18 / cg"
!

fontEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:12:19 / cg"
!

ins
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:58 / cg"
!

insEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:09:59 / cg"
!

kbd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:03 / cg"
!

kbdEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:04 / cg"
!

lang
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:07 / cg"
!

langEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:08 / cg"
!

person
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:14 / cg"
!

personEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:15 / cg"
!

q
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:26 / cg"
!

qEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:28 / cg"
!

s
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:30 / cg"
!

sEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:32 / cg"
!

samp
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:36 / cg"
!

sampEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:37 / cg"
!

site
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: / 15-03-2016 / 22:22:20 / cg"
!

siteEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: / 15-03-2016 / 22:22:30 / cg"
!

span
    "intentionally left blank - to be redefined by concrete class (if required)"
!

spanEnd
    "intentionally left blank - to be redefined by concrete class (if required)"
!

strike
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 8.8.1997 / 14:39:33 / cg"
!

strikeEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 8.8.1997 / 14:39:38 / cg"
!

strong
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:40 / cg"
!

strongEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:41 / cg"
!

var
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:45 / cg"
!

varEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:10:46 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-style physical'!

b
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:11 / cg"
!

bEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:12 / cg"
!

big
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:30 / cg"
!

bigEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:31 / cg"
!

i
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:15 / cg"
!

iEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:17 / cg"
!

small
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:33 / cg"
!

smallEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:35 / cg"
!

sub
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:38 / cg"
!

subEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:39 / cg"
!

sup
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:41 / cg"
!

supEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:43 / cg"
!

tt
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:26 / cg"
!

ttEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:28 / cg"
!

u
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:22 / cg"
!

uEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 17.5.1996 / 15:11:24 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'elements-tables'!

caption
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 21:14:10 / cg"
!

captionEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 21:14:11 / cg"
!

col
    "intentionally left blank - to be redefined by concrete class (if required)"
!

colEnd
    "intentionally left blank - to be redefined by concrete class (if required)"
!

table
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:33:41 / cg"
!

tableEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:33:43 / cg"
!

td
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:34:20 / cg"
!

tdEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 23:47:01 / cg"
!

th
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 18:09:06 / cg"
!

thEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 18:09:11 / cg"
!

tr
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 12.6.1996 / 17:34:19 / cg"
!

trEnd
    "intentionally left blank - to be redefined by concrete class (if required)"

    "Created: 18.6.1996 / 18:09:03 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'error handling'!

doesNotUnderstand:aMessage
    (element notNil and:[element type == aMessage selector]) ifTrue:[
        ('HTML: unknown markup: ' , aMessage selector) infoPrintCR.
    ] ifFalse:[
        super doesNotUnderstand:aMessage
    ].

    "Created: 17.9.1996 / 21:30:51 / cg"
    "Modified: 11.4.1997 / 12:34:33 / cg"
! !

!HTMLDocumentInterpreter methodsFor:'processing'!

process:aDocument
    |e selectorTable|

    element := e := document := aDocument.
    selectorTable := self class selectorTable.

    [e notNil] whileTrue:[
        |type|

        type := e type.
        type isNil ifTrue:[
            self specialMarkup
        ] ifFalse:[
            type := selectorTable at:type ifAbsent:type.
            (type endsWith:$/) ifFalse:[
                self perform:type
            ]
        ].
        element := e := e next.
    ]

    "Created: 17.5.1996 / 14:56:23 / cg"
    "Modified: 9.10.1996 / 18:36:02 / cg"
! !

!HTMLDocumentInterpreter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentInterpreter.st,v 1.29 2016-07-28 14:54:08 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentInterpreter.st,v 1.29 2016-07-28 14:54:08 mawalch Exp $'
! !

