"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/mercurial' }"

View subclass:#HGChangesetLabelsView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGChangesetLabelsView class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
 Notice that everything between [exBegin] and [exEnd] is extracted by the html-doc generator
 to create nicely formatted and clickable executable examples in the generated html-doc.
 (see the browsers class-documentation menu items for more)

 trying the widget as standAlone view:
                                                        [exBegin]
    HGChangesetLabelsView new open
                                                        [exEnd]

 embedded in another view:
                                                        [exBegin]
    |top v|

    top := StandardSystemView new.
    top extent:300@300.
    v := HGChangesetLabelsView new.
    v origin:10@10 corner:150@150.
    top add:v.
    top open
                                                        [exEnd]
"
! !

!HGChangesetLabelsView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == model ifTrue:[
        self invalidate.
        ^ self
    ].
    super update:something with:aParameter from:changedObject
! !

!HGChangesetLabelsView methodsFor:'drawing'!

redrawX:x y:y width:w height:h
    "called to redraw a part of the widgets area. x/y define the origin, w/h the size of
     that area. The clipping region has already been set by the caller, so even if the code
     below draws outside the redraw-area, it will not affect what is on the screen. 
     Therefore, the example below can fill the rectangle in the redraw area, but still draw
     the cross in the outside regions."

    | cs x0 y0 branch |
    self clear.
    cs := self model value.
    cs isNil ifTrue:[ ^ self ].
    branch := cs branches anElement.
    y0 := ((self height - (branch heightOn: gc)) / 2) rounded.
    x0 := 3.
    cs branches size == 1 ifTrue:[ 
"/        changeset branch isDefault ifFalse:[ 
            cs branch displayOn: gc x: x0 y: y0.
            x0 := x0 + (cs branch widthOn: gc) + 3. 
"/        ].
    ] ifFalse:[ 
        cs branches do:[:each |
            each displayOn: gc x: x0 y: y0.
            x0 := x0 + (each widthOn: gc) + 3. 
        ]
    ].
    cs tags do:[:each |
        cs branch displayOn: gc x: x0 y: y0.
        x0 := x0 + (each widthOn: gc) + 3. 
    ].
    cs bookmarks do:[:each |
        each displayOn: gc x: x0 y: y0.
        x0 := x0 + (each widthOn: gc) + 3. 
    ].

    "Modified: / 17-03-2014 / 23:28:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabelsView methodsFor:'event handling'!

sizeChanged:how
    "Invoked whenever the size of the view changes. 
     Here, we force a full redraw, which might not be needed all the time"

    self invalidate.
    super sizeChanged:how.
! !

!HGChangesetLabelsView methodsFor:'initialization & release'!

initialize
    super initialize "/ to initialize inherited state

    "/ add code to initialize private variables,
    "/ and sub-components as required.
! !

