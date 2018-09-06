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

MethodPO subclass:#JavaConstructorPO
	instanceVariableNames:'showPrefix'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java-Interface-PO'
!

!JavaConstructorPO class methodsFor:'documentation'!

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

!JavaConstructorPO methodsFor:'accessing'!

hint
    ^ (classes collect:[:each | each javaPackage ]) asArray asStringWith:' , '.

    "Created: / 24-06-2014 / 11:04:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    label isNil ifTrue:[
	label := (classes anElement compiledMethodAt: selector) printStringForBrowserWithSelector: selector.
	showPrefix ifTrue:[
	    label := classes anElement javaPackage , '.' , label
	].
    ].
    ^ label

    "Created: / 15-05-2014 / 12:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showPrefix: aBoolean
    showPrefix := aBoolean

    "Created: / 15-05-2014 / 12:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringAlreadyWritten
    "Answers a string already written in the textview"

    ^ showPrefix ifTrue:[
	context wordBeforeCursorConsisitingOfCharactersMatching:[:c | c isAlphaNumeric or:['$_.' includes: c] ]
    ] ifFalse:[
	super stringAlreadyWritten
    ].

    "Created: / 15-05-2014 / 12:06:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage: aProgrammingLanguage
    "Answers a string to complete"

    | string |

    string := super stringToCompleteForLanguage: aProgrammingLanguage.
    showPrefix ifTrue:[
	string := classes anElement javaPackage , '.' , string
    ].
    ^ string

    "Created: / 15-05-2014 / 12:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstructorPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

