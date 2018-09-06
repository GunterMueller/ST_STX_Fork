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

HTMLMarkup variableSubclass:#HTMLForm
	instanceVariableNames:'widgets values maxHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLForm class methodsFor:'documentation'!

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

    a form element.
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
    |reply page document forms form fieldElements sel|

    reply := HTTPInterface get:'http://reiseauskunft.bahn.de/bin/query.exe/dn'.
    page := reply data asString.
    document := HTMLParser parseText:page.
    forms := document elementsForWhich:[:el | el isFormElement].
    form := forms detect:[:form | form name = 'formular'].
    fieldElements := form fieldElements.
    sel := fieldElements detect:[:el | el name = 'REQ0HafasSearchForw'].

"

    "Created: / 26-01-2007 / 13:32:58 / cg"
! !

!HTMLForm methodsFor:'accessing'!

action
    |value|

    value := self parameterFor:#'ACTION'.
    ^ HTMLUtilities unEscape:value.

    "Modified: / 14-11-2016 / 14:24:26 / cg"
!

addWidget:aWidgetElement
    widgets isNil ifTrue:[
        widgets := OrderedCollection new.
    ].
    widgets add:aWidgetElement

    "Created: 21.5.1996 / 15:34:29 / cg"
!

maxHeight
    "return maxHeight"

    ^ maxHeight

    "Created: 22.5.1996 / 13:42:36 / cg"
!

maxHeight:something
    "set maxHeight"

    maxHeight := something.

    "Created: 22.5.1996 / 13:42:36 / cg"
!

valueAt:name put:aValueHolder
    values isNil ifTrue:[
        values := (Dictionary new).
    ].
    values at:name put:aValueHolder

    "Created: 21.5.1996 / 15:32:36 / cg"
!

values
    values isNil ifTrue:[
        values := Dictionary new.
    ].
    ^ values

    "Created: 21.5.1996 / 15:30:47 / cg"
!

values:aCollection
    values := aCollection

    "Created: 21.5.1996 / 15:30:47 / cg"
!

widgets
    ^ widgets

    "Created: 21.5.1996 / 21:00:49 / cg"
! !

!HTMLForm methodsFor:'queries'!

encTypeString
    ^ self parameterFor:#'ENCTYPE'

    "Modified: 30.6.1996 / 16:01:20 / cg"
!

fieldElementNamed:aString
    ^ self fieldElements detect:[:el | el name = aString ] 
!

fieldElements
    |el fields|

    fields := OrderedCollection new.
    el := next.
    [el notNil and:[el isFormEndElement not]] whileTrue:[
        (el isInputElement or:[el isSelectElement]) ifTrue:[
            fields add:el
        ].
        el := el next.
    ].
    ^ fields.

    "Modified: / 26-01-2007 / 11:45:33 / cg"
!

methodString
    ^ self parameterFor:#'METHOD'

    "Modified: 30.6.1996 / 16:00:47 / cg"
! !

!HTMLForm methodsFor:'testing'!

isFormElement
    ^ true
! !

!HTMLForm class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLForm.st,v 1.13 2016-11-14 13:25:52 cg Exp $'
! !

