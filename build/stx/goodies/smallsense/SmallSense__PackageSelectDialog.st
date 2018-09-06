"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

AbstractSelectDialog subclass:#PackageSelectDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!PackageSelectDialog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

!PackageSelectDialog methodsFor:'accessing - private'!

matchingObjectForString: aString
    "Creates a new object from given string. Called only when
     #canCreateMatchingObjectFromString: returns true"

    ^ aString asSymbol

    "Created: / 23-06-2014 / 15:25:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageSelectDialog methodsFor:'accessing-defaults'!

defaultTitle
    ^ (resources string: 'Select Package...')

    "Created: / 13-12-2014 / 12:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageSelectDialog methodsFor:'queries'!

canCreateMatchingObjectFromString:string 
    "Return true, a new object can be created with given string value"
    
    ^ string notNil and:[ string allSatisfy:[:c | c isLetterOrDigit or:[ '_:/' includes:c ] ] ]

    "Created: / 23-06-2014 / 15:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2015 / 07:23:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canSelect:selection
    ^ selection askFor: #isSmallSensePackagePO

    "Created: / 05-05-2014 / 23:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageSelectDialog methodsFor:'searching'!

matchingObjectPOsForPattern:pattern relax: level
    | environment packages |

    environment := self environment.
    packages := Set new.

    environment allClassesDo: [ :cls |
        | pkg |

        pkg := cls package.
        ((pkg notNil and:[ pkg ~~ PackageId noProjectID and:[ (pkg startsWith: '__') not] ])
            and:[(filter isNil or:[ filter value: pkg ])
            and:[pattern isNil or:[pattern match: pkg relax: level]]]) ifTrue:[ packages add: pkg ].
    ].
    environment allMethodsDo:[ :mth |
        | pkg |

        pkg := mth package.
        ((pkg notNil and:[ pkg ~~ PackageId noProjectID and:[ (pkg startsWith: '__') not] ])
            and:[(filter isNil or:[ filter value: pkg ])
            and:[pattern isNil or:[pattern match: pkg relax: level]]]) ifTrue:[ packages add: pkg ].
    ].
    packages := packages asArray.
    packages sort: [ :a :b | a < b ].
    ^ packages collect:[ :e | PO forPackage: e ].

    "Created: / 13-12-2014 / 08:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

