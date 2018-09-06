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

AbstractSearchProcessor subclass:#ClassSearchProcessor
	instanceVariableNames:'matchFullyQualifiedClassName'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!ClassSearchProcessor class methodsFor:'documentation'!

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

!ClassSearchProcessor methodsFor:'accessing'!

matchFullyQualifiedClassName
    ^ matchFullyQualifiedClassName
!

matchFullyQualifiedClassName:something
    matchFullyQualifiedClassName := something.
! !

!ClassSearchProcessor methodsFor:'accessing - presentation'!

label
    "Return a label for this processor. This one is used as section label
     in Spotter"

    ^ 'Classes'

    "Created: / 10-01-2015 / 06:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassSearchProcessor methodsFor:'searching'!

matchingObjectPOsFor: objects
    | matchQualified |

    matchQualified := matchFullyQualifiedClassName == true.
    matchQualified ifTrue:[
        objects sort:[:a :b | a displayString < b displayString ].
    ] ifFalse:[
        objects sort:[:a :b | a nameWithoutPrefix < b nameWithoutPrefix ].
    ].

    ^ objects collect:[:each | 
        (ClassPO new)
            klass:each;
            showPrefix:matchQualified
    ].

    "Created: / 30-04-2014 / 09:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2014 / 23:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: level 
    | matching matchQualified |

    matching := OrderedCollection new.
    matchFullyQualifiedClassName := (matchFullyQualifiedClassName == true) or:[ pattern asString includesString:'::' ].
    matchQualified := matchFullyQualifiedClassName. 
    pattern notNil ifTrue:[
        matchQualified ifFalse:[
            environment 
                allClassesDo:[:cls | 
                    ((filter isNil or:[filter value: cls]) and:[(pattern match:cls nameWithoutPrefix relax: level)]) ifTrue:[
                        matching add:cls.
                    ].
                ].
        ] ifTrue:[
            environment 
                allClassesDo:[:cls | 
                    ((filter isNil or:[filter value: cls]) and:[(pattern match:cls displayString relax: level)]) ifTrue:[
                        matching add:cls
                    ]
                ].
        ]
    ].

    ^ matching

    "Created: / 12-12-2014 / 21:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2015 / 17:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassSearchProcessor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

