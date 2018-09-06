"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
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

AbstractTestCase subclass:#EditSupportTests
	instanceVariableNames:'codeView codeViewInteractor editService editSupport'
	classVariableNames:'TriedOpenDisplay'
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!EditSupportTests class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
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
! !

!EditSupportTests class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    TriedOpenDisplay := false.

    "Modified: / 17-10-2017 / 23:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupportTests class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == SmallSense::EditSupportTests.
! !

!EditSupportTests methodsFor:'accessing-classes'!

editSupportClass
    self subclassResponsibility

    "Created: / 23-07-2014 / 07:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupportTests methodsFor:'running'!

setUp
    | topView |

    super setUp.

    TriedOpenDisplay ifFalse:[
        TriedOpenDisplay := true.
        Screen current isNil ifTrue:[
            Smalltalk openDisplay
        ].
    ].
    self skipIf: Screen current isNil description:'No display connection'.

    Smalltalk loadPackage: 'stx:goodies/sunit/ext/ui'.

    topView := StandardSystemView new.
    topView extent: 320 @ 200.
    topView label: self printString.
    codeView := Tools::CodeView2 origin: 0.0@0.0 extent: 1.0@1.0 in: topView.
    codeViewInteractor := codeView interactor.

    editService := EditService new.
    editSupport := self editSupportClass new.
    codeView services: (Array with: editService).
    codeView language: editSupport language.
    editService updateSupport: editSupport.

    topView open.
    topView waitUntilVisible.

    "Created: / 23-07-2014 / 07:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2017 / 23:25:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    editService := nil.
    editSupport := nil.
    codeView topView destroy.

    super tearDown

    "Created: / 23-07-2014 / 07:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-03-2015 / 09:43:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditSupportTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


EditSupportTests initialize!
