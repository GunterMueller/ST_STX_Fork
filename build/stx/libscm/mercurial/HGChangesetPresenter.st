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

"{ NameSpace: Smalltalk }"

Object subclass:#HGChangesetPresenter
	instanceVariableNames:'changeset labels'
	classVariableNames:'PaddingLeft PaddingRight PaddingTop PaddingBottom'
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGChangesetPresenter class methodsFor:'documentation'!

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
! !

!HGChangesetPresenter class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    PaddingLeft := 3.
    PaddingRight := 3.
    PaddingTop := 3.
    PaddingBottom := 3.

    "Modified: / 11-03-2014 / 21:27:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'accessing'!

changeset
    ^ changeset
!

changeset:anHGChangeset
    changeset := anHGChangeset.
!

labels
    "/ Cache labels for speed...
    labels isNil ifTrue:[ 
        labels := changeset labels.
    ].
    ^ labels

    "Created: / 25-03-2014 / 01:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'accessing - presentation'!

authorString
    ^ changeset author

    "Created: / 11-03-2014 / 21:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetString
    ^ changeset id asString
!

dateString
    ^ changeset timestamp printString

    "Created: / 11-03-2014 / 21:48:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentsString
    "raise an error: this method should be implemented (TODO)"

    | p1 p2 |

    p1 := changeset parent1.
    p1 isNil ifTrue:[ 
        ^ HGChangesetId null printString.
    ].

    p2 := changeset parent2.
    ^ p2 isNil ifTrue:[ 
        p1 id asString.
    ] ifFalse:[ 
        p1 id asString , ', ' , p2 id asString.
    ].

    "Created: / 11-03-2014 / 21:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

summaryString
    ^ changeset summary

    "Created: / 11-03-2014 / 21:49:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'comparing'!

= another
    ^ self class = another class and:[changeset = another changeset]

    "Created: / 11-03-2014 / 21:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2014 / 00:03:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ changeset hash

    "Created: / 11-03-2014 / 21:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'displaying'!

displayOn:aGC x:x0 y:y0"baseline of the text!!!!!!"
    | x y yTextOffset xSummary fontH fontA lineH labelH idW resources |

    resources := HGChangesetList resources.
    fontH := (aGC font onDevice:aGC device) height.
    fontA := (aGC font onDevice:aGC device) ascent.
    lineH := (fontH * 1.2) rounded.
    labelH := changeset branches anElement heightOn: aGC.  
    idW := aGC widthOfString:'XXXXXXXXXXXX'.
    yTextOffset := 0."/((labelH - fontH) / 2) rounded.
    x := x0 + PaddingLeft.
    y := y0 + PaddingTop.
    aGC displayString: changeset id printStringWithoutNumber x: x y: y + yTextOffset.
    xSummary := x + idW + 5.
    self labels do:[:label |
"/        (label isBranch and:[ label isDefault ]) ifFalse:[
            label displayOn: aGC x: xSummary y: y - fontA.
            xSummary := xSummary + (label widthOn: aGC) + 3. 
"/        ].
    ].
    aGC displayString: changeset summary x: xSummary + 3 y: y + 2.

    y := y + lineH + 4.
    aGC displayString: changeset user , ', ', changeset timestamp printString x: x + idW + 5 y: y

    "Created: / 11-03-2014 / 21:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2014 / 00:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heightOn:aGC
    | fontH lineSpacing |

    fontH := (aGC font onDevice:aGC device) height.
    lineSpacing := (fontH * 0.2) rounded.
     ^ (fontH * 2) + lineSpacing + 6 +  PaddingTop + PaddingRight.

    "Created: / 11-03-2014 / 21:29:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-03-2014 / 00:22:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthOn:aGC 
    | w idW |

    idW := aGC widthOfString:'XXXXXXXXXXXX'.
    w := PaddingLeft.
    w := w + idW + 5.
    self labels do:[:label |
"/        (label isBranch and:[ label isDefault ]) ifFalse:[
            w := w + (label widthOn: aGC) + 3. 
"/        ].
    ].
    w := w + (aGC widthOfString: changeset summary) + 3.
    ^ w.

    "Created: / 28-03-2014 / 00:26:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'help'!

helpText
    ^ changeset helpText

    "Created: / 10-09-2015 / 09:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetPresenter methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    changeset printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 27-03-2014 / 23:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


HGChangesetPresenter initialize!
