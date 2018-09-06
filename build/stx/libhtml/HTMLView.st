"
 COPYRIGHT (c) 1997 by eXept Software AG
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

ScrollableView subclass:#HTMLView
	instanceVariableNames:'documentHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Attention: Please read the warning in HTMLElement.

    The functionality is basically the same as provided by the HTMLDocumentView.
    Additional there is a value holder which holds the 'home' document to be shown
    and configurable scrollbars (horizontal and vertical).

    [author:]
        Claus Atzkern

    [see also:]
        HTMLDocumentView
        HTMLViewSpec
"
!

examples
"
                                                                [exBegin]
    |top doc holder|

    top := StandardSystemView extent:500@500.
    doc := self origin:0.0@ 0.0 corner:1.0@1.0 in:top.
    top openAndWait.

    holder := ValueHolder new.
    holder inspect.
    doc documentHolder:holder.
    holder value:'/home2/stx/lib/doc/online/english/TOP.html'.
                                                                [exEnd]

                                                                [exBegin]
    |top doc holder|

    top := StandardSystemView extent:500@500.
    doc := self origin:0.0@ 0.0 corner:1.0@1.0 in:top.
    top openAndWait.

    holder := ValueHolder new.
    doc documentHolder:holder.
    doc homeText:
        '
        <html>
        <body>
        <h1>chapter 1</h1>
        <h2>sub chapter 1.1</h2>
        <h1>chapter 2</h1>
        <h2>sub chapter 2.1</h2>
        <h2>sub chapter 2.2</h2>
        <h2>sub chapter 2.3</h2>
        </body>
        </html>
        '
                                                                [exEnd]
"
! !

!HTMLView methodsFor:'accessing'!

contents:aString
    "for compatibility with TextViews"

    self homeText:aString.
    scrolledView sizeChanged:nil.   "/ to force painter-action
!

extentOfContents
    ^ scrolledView extentOfContents
!

homeDocument:aFilename
    "set home document"

    scrolledView notNil ifTrue:[
        scrolledView homeDocument:aFilename
    ]

    "Modified: / 14-07-2007 / 21:19:12 / cg"
!

homeText:aString
    "set some html text"

    self scrolledView homeText:aString
!

positionOnAnchor:localAnchor
    self scrolledView positionOnAnchor:localAnchor
!

positionTo:aPoint
    self scrolledView positionTo:aPoint
! !

!HTMLView methodsFor:'accessing-channels'!

canGoBackHolder
    ^ scrolledView canGoBackHolder.
!

documentHolder
    "get the document holder (holds the uri)
    "
    ^ documentHolder

!

documentHolder:aValueHolder
    "set the text holder (holds the html-text)
    "
    scrolledView notNil ifTrue:[ scrolledView uriInputHolder:aValueHolder ].
    documentHolder := aValueHolder.
    self homeDocument:(documentHolder value)

"/    documentHolder notNil ifTrue:[
"/        documentHolder removeDependent:self. 
"/    ].
"/    (documentHolder := aValueHolder) notNil ifTrue:[
"/        documentHolder addDependent:self.
"/        self homeDocument:(documentHolder value)
"/    ].

    "Modified: / 14-07-2007 / 21:18:40 / cg"
!

htmlTextHolder
    "get the text holder (holds the html-text)
    "
    scrolledView model.

!

htmlTextHolder:aValueHolder
    "set the text holder (holds the html-text)
    "
    scrolledView model:aValueHolder.
    self homeDocument:nil



! !

!HTMLView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "one of my models changed its value"

    changedObject == documentHolder ifTrue:[
        ^ self homeDocument:documentHolder value
    ].
    super update:something with:aParameter from:changedObject
! !

!HTMLView methodsFor:'initialization & release'!

destroy
    "remove dependencies
    "
    self documentHolder:nil.
    super destroy.
!

initStyle
    super initStyle.
    "/ hideScrollbarIfPointerOutside := false.
!

initialize
    "setup scrollable view a HTMLDocumentView instance
    "
    super initialize.

    self verticalScrollable:true;     verticalMini:false.
    self horizontalScrollable:true; horizontalMini:false.
    "/ hideScrollbarIfPointerOutside := false.
    self scrolledView:HTMLDocumentView new.
! !

!HTMLView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLView.st,v 1.17 2016-04-28 20:45:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLView.st,v 1.17 2016-04-28 20:45:48 cg Exp $'
! !

