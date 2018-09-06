"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

PO subclass:#VariablePO
	instanceVariableNames:'class type name'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!VariablePO class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!VariablePO class methodsFor:'instance creation'!

argument: name

    ^self new name: name; type: #MethodArg

    "Created: / 26-11-2011 / 18:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classVariable: name in: class

    ^self new name: name; type: #ClassVar; class: class

    "Created: / 26-11-2011 / 18:46:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

globalVariable: name

    ^self new name: name; type: #Global

    "Created: / 26-11-2011 / 18:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceVariable: name in: class

    ^self new name: name; type: #InstanceVar; class: class

    "Created: / 26-11-2011 / 18:45:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variable: name

    ^self new name: name; type: #MethodVar

    "Created: / 26-11-2011 / 18:45:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariablePO methodsFor:'accessing'!

class:something
    class := something.

    "Created: / 06-04-2011 / 16:51:42 / Jakub <zelenja7@fel.cvut.cz>"
!

label
    ^ name

    "Created: / 20-05-2014 / 11:30:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name

    "Created: / 20-05-2014 / 11:38:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name: aString
    name := aString

    "Created: / 20-05-2014 / 11:37:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage:aProgrammingLanguage
    "Answers a string to complete"

    ^ name

    "Created: / 20-05-2014 / 11:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type:something
    type := something.
! !

!VariablePO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.
     
     For internal usage only."

    ^ name

    "Created: / 20-06-2014 / 11:11:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariablePO methodsFor:'displaying'!

displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected: highlighted
    | lw cn cnw fg y0 |

    super displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected: highlighted.

    class isNil ifTrue:[ ^ self ]. "/ Could be pseudo-variable

    lw :=  x + (parent isNil ifTrue:[IconWidth] ifFalse:[0]) + (self label widthOn: aGC).
    cn := class nameWithoutPrefix.
    cnw := aGC widthOfString: cn.
    y0 := y - (lH + 1 - h // 2).
    y0 := y0 + (cn ascentOn:aGC).  

    (aGC width > (lw + cnw + 5)) ifTrue:
        [fg := aGC paint.
        aGC paint: Color gray .
        aGC displayString: cn x: aGC width - cnw - 5 y: y0.
        aGC paint: fg.
    ]

    "Created: / 03-02-2015 / 05:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-04-2014 / 00:24:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayOn:aGC x:x y:y opaque:opaque

    | lw cn cnw fg |

    super displayOn:aGC x:x y:y opaque:opaque.

    class isNil ifTrue:[^self].

    lw :=  x + 16 + (self label widthOn: aGC).
    cn := class nameWithoutPrefix.
    cnw := aGC widthOfString: cn.

    (aGC width > (lw + cnw + 5)) ifTrue:
        [fg := aGC paint.
        aGC paint: Color gray .
        aGC displayString: cn x: aGC width - cnw - 5 y: y.
        aGC paint: fg.
    ]

    "Created: / 21-05-2011 / 11:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-09-2013 / 23:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariablePO methodsFor:'testing'!

isSmallSenseVariablePO
    ^ true
! !

!VariablePO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

