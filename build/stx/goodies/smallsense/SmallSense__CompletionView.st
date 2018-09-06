"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2015 Claus Gittinger
Copyright (C) 2017-2018 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

TopView subclass:#CompletionView
	instanceVariableNames:'completionController completionContext list listHolder listView
		selectionHolder helpHolder helpView'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface'
!

!CompletionView class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2015 Claus Gittinger
Copyright (C) 2017-2018 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!CompletionView methodsFor:'accessing'!

completionContext
    ^ completionContext
!

completionContext:aCompletionContext
    | node |

    completionContext := aCompletionContext.
    node := completionContext node.
    (node notNil and:[node askFor:#isMessage]) ifTrue:[ 
        helpHolder value: 'Receiver type: ', node receiver inferedType displayString
    ] ifFalse:[ 
        helpHolder value: 'Up/Down to select, Enter to paste' asText.
    ].

    "Modified: / 12-08-2014 / 10:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionController
    ^ completionController
!

completionController:aCompletionController
    completionController := aCompletionController.

    "Modified: / 04-04-2014 / 14:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

font: aFont
    super font: aFont.
    listView font: aFont.

    "Created: / 27-09-2013 / 14:03:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

list
    ^ list
!

list: aCollection
    list :=  aCollection.
    listHolder value: aCollection.
    self completionContext: (aCollection notEmptyOrNil ifTrue:[aCollection anElement context] ifFalse:[ nil ]).

    "Created: / 27-09-2013 / 14:02:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-04-2014 / 14:56:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection
    ^ (listView value at: selectionHolder value).

    "Created: / 27-09-2013 / 15:41:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selection: po
    selectionHolder value: (listHolder value identityIndexOf: po)

    "Created: / 27-09-2013 / 16:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView methodsFor:'actions'!

complete: index
    self assert: selectionHolder value == index.
    completionController complete.

    "Created: / 27-02-2014 / 10:09:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView methodsFor:'event handling'!

keyPress:key x:x y:y
    key == #Escape ifTrue:[ 
        completionController closeCompletionView.
        ^ self
    ].  
    (key == #CursorDown
        or:[ key == #CursorUp
        or:[ ((key == #Return) and:[ self hasSelection ])]]) ifTrue:[ 
            listView keyPress:key x:x y:y.
            ^ self
        ].

    ^ completionController editView keyPress:key x:x y:y

    "Created: / 27-09-2013 / 14:05:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-01-2018 / 23:10:58 / jv"
    "Modified (comment): / 17-04-2018 / 15:14:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view: view
    view == listView ifTrue:[ 
        (key == #CursorDown
        or:[ key == #CursorUp
        or:[ key == #Return]]) ifTrue:[ 
            ^ false
        ] ifFalse:[ 
            completionController editView keyPress:key x:x y:y.
            ^ true
        ].
    ].
    ^ false

    "Created: / 17-04-2018 / 09:54:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 17-04-2018 / 15:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView methodsFor:'initialization & release'!

initialize
    | listViewScroller listViewScrollerLayout helpViewLayout |

    super initialize.
    listHolder := ValueHolder new.
    selectionHolder := ValueHolder new.
    helpHolder := ValueHolder new.

    listViewScrollerLayout := LayoutFrame origin: 0.0 @ 0.0  corner: 1.0 @ 1.0.
    listViewScrollerLayout bottomOffset: -20.
    listViewScroller := ScrollableView for: SelectionInListModelView.
    listViewScroller layout: listViewScrollerLayout.
    self addSubView: listViewScroller.

    listView := listViewScroller scrolledView.
    listView listHolder: listHolder.
    listView model: selectionHolder.
    listView delegate: self.
    listView highlightMode: #line.
    listView doubleClickAction:[:index | self complete: index ].

    helpViewLayout := LayoutFrame origin: 0.0 @ 1.0  corner: 1.0 @ 1.0.
    helpViewLayout topOffset: -20.
    helpView := Label new.
    helpView adjust: #left.
    helpView labelChannel: helpHolder.  
    helpView layout: helpViewLayout.
    self addSubView: helpView.  

    self extent: 400 @ 250

    "Created: / 27-09-2013 / 13:56:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-04-2018 / 09:53:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView methodsFor:'queries'!

handlesKeyPress: key inView: view
    ^ view == listView and:[ key isCharacter ]

    "Created: / 17-04-2018 / 09:55:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelection
    ^listView hasSelection

    "Created: / 27-09-2013 / 14:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPopUpView
    ^ true

    "Created: / 27-09-2013 / 13:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView methodsFor:'redrawing'!

flash
    "delegate"

    listView flash.

    "Created: / 31-03-2014 / 22:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flash:message withColor:flashColor
    "delegate"

    listView flash:message withColor:flashColor.

    "Created: / 31-03-2014 / 22:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Path: stx/goodies/smallsense/SmallSense__CompletionView.st, Version: 1.0, User: cg, Time: 2015-09-01T18:58:15.172+02$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

