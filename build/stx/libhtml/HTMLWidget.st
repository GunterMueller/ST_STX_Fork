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

HTMLMarkup variableSubclass:#HTMLWidget
	instanceVariableNames:'view maxHeightInRow yTopInRow'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLWidget class methodsFor:'documentation'!

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
    Attention: Please read the warning in HTMLElement.

    a widget within a form.
    No new features added; however, provides convenient access for
    some heavily used values (attributes).

    [author:]
        Claus Gittinger

    [see also:]
        HTMLParser
        HTMLDocumentPainter
"
!

examples
"
    |reply page document forms|

    reply := HTTPInterface get:'http://reiseauskunft.bahn.de/bin/query.exe/dn'.
    page := reply data asString.
    document := HTMLParser parseText:page.
    forms := document elementsForWhich:[:el | el isFormElement].
    forms.
"

"
    |reply page document forms|

    reply := HTTPInterface get:'http://www.der.de/portal/der/app/content;jsessionid=043BCD5971826837665644647C2627BA'.
    page := reply data asString.
    document := HTMLParser parseText:page.
    forms := document elementsForWhich:[:el | el isFormElement].
    forms.
"
! !

!HTMLWidget methodsFor:'accessing'!

maxHeightInRow
    "return maxHeightInRow"

    ^ maxHeightInRow

    "Created: 16.9.1996 / 16:15:32 / cg"
!

maxHeightInRow:something
    "set maxHeightInRow"

    maxHeightInRow := something.

    "Created: 16.9.1996 / 16:15:32 / cg"
!

view
    "return view"

    ^ view

    "Created: 21.5.1996 / 15:40:48 / cg"
!

view:something
    "set view"

    view := something.

    "Created: 21.5.1996 / 15:40:48 / cg"
!

yTopInRow
    "return yTopInRow"

    ^ yTopInRow

    "Created: 16.9.1996 / 16:15:34 / cg"
!

yTopInRow:something
    "set yTopInRow"

    yTopInRow := something.

    "Created: 16.9.1996 / 16:15:34 / cg"
! !

!HTMLWidget methodsFor:'queries'!

optionElements
    |el options|

    self isSelectElement ifFalse:[ self error ].

    options := OrderedCollection new.
    el := next.
    [el notNil and:[el isSelectEndElement not]] whileTrue:[
        (el isOptionElement) ifTrue:[
            options add:el
        ].
        el := el next.
    ].
    ^ options.

    "Created: / 26-01-2007 / 14:25:34 / cg"
! !

!HTMLWidget methodsFor:'testing'!

isInputElement
    ^ type = 'input'
!

isSelectElement
    ^ type = 'select'

    "Created: / 26-01-2007 / 11:44:17 / cg"
! !

!HTMLWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLWidget.st,v 1.13 2016-04-28 20:45:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLWidget.st,v 1.13 2016-04-28 20:45:47 cg Exp $'
! !

