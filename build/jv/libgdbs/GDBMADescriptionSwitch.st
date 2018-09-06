"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

Magritte::MADescription subclass:#GDBMADescriptionSwitch
	instanceVariableNames:'klassMap'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Support'
!

!GDBMADescriptionSwitch class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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

!GDBMADescriptionSwitch class methodsFor:'instance creation'!

forTag: label1 use: classOrDesc1 forTag: label2 use: classOrDesc2
    | desc1 desc2 |

    desc1 := classOrDesc1.
    desc2 := classOrDesc2.
    ^ self new klassMap:
        (Dictionary new
            at: label1 put: desc1;
            at: label2 put: desc2;
            yourself)

    "Created: / 03-07-2018 / 16:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forTag: label1 useClass: class1 forTag: label2 useClass: class2
    ^ self new klassMap:
        (Dictionary new
            at: label1 put: class1;
            at: label2 put: class2;
            yourself)

    "Created: / 03-07-2018 / 16:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMADescriptionSwitch class methodsFor:'testing'!

isAbstract
    ^ false

    "Created: / 03-07-2018 / 16:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMADescriptionSwitch methodsFor:'accessing'!

klassMap
    ^ klassMap
!

klassMap:aDictionary
    klassMap := aDictionary.
! !

!GDBMADescriptionSwitch methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ self shouldNotImplement

    "Created: / 03-07-2018 / 16:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseUsingGDBMIParser: aGDBMIParser taggedAs: aString
    ^ (klassMap at: aString) parseUsingGDBMIParser: aGDBMIParser taggedAs: aString

    "Created: / 03-07-2018 / 16:25:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

