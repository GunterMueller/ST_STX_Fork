"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

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

ParseNode subclass:#SelectorNode
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SelectorNode class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

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
    A (helper) node that represents a selector (or its part).
    SelectorNodes are not directly created nor used by the
    parser/compiler itself.

    Some custom subclasses (syntax highlighters for instance)
    makes use of it.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SyntaxHighlighter2

"
! !

!SelectorNode class methodsFor:'instance creation'!

value: selector from: start to: end

    ^self new
        value: selector;
        startPosition:start endPosition: end

    "Created: / 16-02-2012 / 20:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode methodsFor:'accessing'!

value
    ^ value
!

value:aString
    value := aString.
! !

!SelectorNode methodsFor:'navigation-SmallSense'!

navigateToUsing: navigator
    | p |

    p := self parent.
    p notNil ifTrue:[
        p navigateToUsing: navigator
    ] ifFalse:[ 
        self breakPoint: #jv  
    ].

    "Created: / 24-09-2013 / 10:04:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-11-2014 / 15:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode methodsFor:'printing & storing'!

printOn:aStream indent:aSmallInteger
    aStream nextPutAll: value

    "Created: / 13-11-2017 / 22:27:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode methodsFor:'testing'!

isSelector

    ^true

    "Created: / 16-02-2012 / 21:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

