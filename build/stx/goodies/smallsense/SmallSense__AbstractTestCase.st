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

Smalltalk::TestCase subclass:#AbstractTestCase
	instanceVariableNames:'preferences'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!AbstractTestCase class methodsFor:'documentation'!

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

!AbstractTestCase class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractTestCase.
! !

!AbstractTestCase methodsFor:'running'!

setUp
    | keysToRemove |
    preferences := Dictionary new.
    keysToRemove := Set new.
    UserPreferences current keysAndValuesDo:[ :key :value |
        (key startsWith: 'smallSense') ifTrue:[ 
            preferences at: key put: value.
            keysToRemove add: key.
        ].
    ].
    keysToRemove do:[:key | 
        UserPreferences current removeKey: key.
    ].
    UserPreferences current smallSenseEnabled: true.

    "Modified: / 11-08-2014 / 14:25:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    | keysToRemove |

    keysToRemove := Set new.
    UserPreferences current keysAndValuesDo:[ :key :value |
        (key startsWith: 'smallSense') ifTrue:[ 
            keysToRemove add: key.
        ].
    ].
    keysToRemove do:[:key | 
        UserPreferences current removeKey: key.
    ].
    preferences keysAndValuesDo:[ :key :value |
        UserPreferences current at: key put: value.
    ].

    "Created: / 11-08-2014 / 14:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

