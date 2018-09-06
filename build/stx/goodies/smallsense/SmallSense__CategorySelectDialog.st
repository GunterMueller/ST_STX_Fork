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

CetegoryOrProtocolSelectDialog subclass:#CategorySelectDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!CategorySelectDialog class methodsFor:'documentation'!

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

!CategorySelectDialog class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!CategorySelectDialog methodsFor:'accessing-defaults'!

defaultTitle
    ^ (resources string: 'Select Protocol...')

    "Modified: / 01-08-2015 / 05:58:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CategorySelectDialog methodsFor:'searching'!

matchingObjectPOsForPattern:pattern relax: level
    | environment categories |

    environment := self environment.
    categories := Set new.

    environment allClassesDo:[ :cls | 
        | category |

        category := cls category.
        (category notNil 
            and: [ (filter isNil or:[filter value: category]) 
            and: [ pattern isNil or:[pattern match: category relax: level] ] ]) ifTrue:[
                categories add: cls category 
            ] 
    ].
    categories := categories asArray.
    categories sort: [ :a :b | a < b ].
    ^ categories collect:[ :e | PluggablePO new label: e; subject: e ].

    "Created: / 13-12-2014 / 08:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2014 / 12:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

