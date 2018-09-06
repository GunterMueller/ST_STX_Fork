"{ Encoding: utf8 }"

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

AbstractTestCase subclass:#CompletionEngineTests
	instanceVariableNames:'engine context result codeView'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!CompletionEngineTests class methodsFor:'documentation'!

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

!CompletionEngineTests class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::CompletionEngineTests.
! !

!CompletionEngineTests methodsFor:'accessing'!

environment
   ^ Smalltalk

    "Created: / 22-05-2014 / 16:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngineTests methodsFor:'accessing-classes'!

completionEngineClass
    ^ self subclassResponsibility

    "Created: / 22-05-2014 / 16:38:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionLanguage
    ^ self subclassResponsibility

    "Created: / 07-03-2015 / 10:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngineTests methodsFor:'running'!

setUp
    | service support  |

    engine := self completionEngineClass new.
    codeView := Tools::CodeView2 new.
    codeView languageHolder value: self completionLanguage.
    service := EditService new.
    service registerIn: codeView.  
    support := GenericEditSupport new.
    service updateSupport: support.  
    context := CompletionContext new.
    context support: support.
    context environment: self environment.

    "Created: / 22-05-2014 / 16:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2015 / 10:36:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    engine := context := nil

    "Created: / 22-05-2014 / 16:51:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngineTests methodsFor:'utilities'!

complete: aString
     | list textView |

    list := aString asStringCollection.
    textView := codeView textView.
    textView list: list.
    1 to: list size do:[:i |  
        | line cursorCol |

        line := list at: i.
        cursorCol := line indexOf: '┃' first.
        cursorCol ~~ 0 ifTrue:[ 
            line := (line copyTo: cursorCol - 1) , (line copyFrom: cursorCol + 1).
            list at: i put: line.
            textView setCursorLine: i; setCursorCol: cursorCol.
        ].
    ].
    ^ result := engine complete: context

    "Created: / 22-05-2014 / 16:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:10:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngineTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

