"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

Object subclass:#CustomSourceCodeSelection
	instanceVariableNames:'selectedInterval currentSourceCode selectedMethod selectedClass
		selectedSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomSourceCodeSelection class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
    Container class which holds actual source code from text editor (source code editor) 
    with exact position of selected source code. Also keeps corresponding class, method and selector
    to current source code.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomSourceCodeSelection methodsFor:'accessing'!

currentSourceCode
    "Returns the source code string. This is the code we actually
    working on - for example modified method in code editor.
    If such code is not directly known then is retrieved from selected method
    or from selected class and selector."

    currentSourceCode notNil ifTrue: [ 
        ^ currentSourceCode
    ].

    self selectedMethod notNil ifTrue: [ 
        ^ self selectedMethod source
    ].

    (selectedSelector notNil and: [selectedClass notNil]) ifTrue: [ 
        ^ (selectedClass compiledMethodAt: selectedSelector asSymbol) source
    ].

    ^ nil

    "Modified: / 28-10-2014 / 11:46:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

currentSourceCode: aSourceCode
    "see ... currentSourceCode"

    currentSourceCode := aSourceCode.

    "Modified (comment): / 18-10-2014 / 12:03:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClass
    "Returns the selected class which belongs to the selected source code."

    ^ selectedClass

    "Modified (comment): / 18-10-2014 / 12:27:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClass: aClass
    "see ... selectedClass"

    selectedClass := aClass.

    "Modified (comment): / 18-10-2014 / 12:27:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedInterval
    "Returns numeric interval to tell which fragment of the currentSourceCode is selected.
    For example (2 to: 5) means that second to fifth character is selected."

    ^ selectedInterval

    "Modified (comment): / 18-10-2014 / 12:50:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedInterval: anInterval
    "see ... selectedInterval"

    selectedInterval := anInterval.

    "Modified (comment): / 18-10-2014 / 12:51:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethod
    "Returns the selected method which belongs to the selected source code."

    ^ selectedMethod

    "Modified (comment): / 18-10-2014 / 12:53:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethod: aMethod
    "see ... selectedMethod"

    selectedMethod := aMethod.

    "Modified (comment): / 18-10-2014 / 12:53:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedSelector
    "Returns the selected method selector which belongs to the selected source code.
    If not known then returns selected method selector or source code."

    | selector |

    selectedSelector notNil ifTrue: [ 
        ^ selectedSelector
    ].

    selector := nil.

    self selectedMethod notNil ifTrue: [
        selector := self selectedMethod selector
    ].

    selector isNil ifTrue: [
        | source |

        source := self currentSourceCode.
        source notNil ifTrue: [
            "In some cases the 'who' method from Method >> selector 
            returns nil as selector so parse the selector from source"
            selector := (Parser parseMethodSpecification: source) selector
        ]
    ].

    ^ selector

    "Modified (format): / 28-10-2014 / 12:20:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedSelector: aSelector
    "see ... selectedSelector"

    selectedSelector := aSelector.

    "Modified (comment): / 18-10-2014 / 12:54:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedSourceCode
    "Returns selected source code fragment as string from current source code
    specified by selected interval.
    For example when code is 'some_code' and interval is (2 to: 4) then 'ome' is returned."

    | source interval |

    source := self currentSourceCode.
    source isNil ifTrue: [ ^ nil ].
    source := source asString.

    interval := self selectedInterval.

    interval isNil ifTrue: [
        "Return the whole source when none interval is specified"
        ^ source
    ].

    interval isEmpty ifTrue: [
        "Cannot retrieve any source when interval is empty, so return unknown source"
        ^ nil
    ].

    (interval first between: 1 and: source size) ifFalse: [ 
        self error: 'selectedInterval is not within currentSourceCode range'
    ].

    ^ source copyFrom: interval first to: (interval last min:source size)

    "Created: / 24-08-2014 / 22:18:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 22:49:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeSelection methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:' (selectedInterval: '.

    self selectedInterval printOn:aStream.
    aStream nextPutAll:'; currentSourceCode: '.

    self currentSourceCode printOn:aStream.
    aStream nextPutAll:'; selectedMethod: '.

    self selectedMethod printOn:aStream.
    aStream nextPutAll:'; selectedClass: '.

    self selectedClass printOn:aStream.
    aStream nextPutAll:'; selectedSelector: '.

    self selectedSelector printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 28-10-2014 / 10:25:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeSelection methodsFor:'queries'!

isWholeMethodSelected
    "Returns true if complete method source code is selected
    othervise returns false"

    self selectedMethod isNil ifTrue: [ 
        ^ false
    ].

    ^ (self currentSourceCode) = (self selectedSourceCode)

    "Created: / 07-12-2014 / 18:48:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeSelection class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

