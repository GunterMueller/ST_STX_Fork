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

AbstractSearchProcessor subclass:#PluggableSearchProcessor
	instanceVariableNames:'label search presentation'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!PluggableSearchProcessor class methodsFor:'documentation'!

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

!PluggableSearchProcessor class methodsFor:'instance creation'!

search: searchBlock presentation: presentBlock
    ^ self new initializeWithSearch: searchBlock presentation: presentBlock

    "Created: / 24-01-2015 / 00:14:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggableSearchProcessor methodsFor:'accessing'!

label:something
    label := something.
! !

!PluggableSearchProcessor methodsFor:'accessing - presentation'!

label
    "Return a label for this processor. This one is used as section label
     in Spotter"

    ^ label

    "Created: / 24-01-2015 / 00:09:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggableSearchProcessor methodsFor:'initialization'!

initializeWithSearch: searchBlock presentation: presentBlock
    search := searchBlock.
    presentation := presentBlock

    "Created: / 24-01-2015 / 00:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggableSearchProcessor methodsFor:'searching'!

matchingObjectPOsFor:objects
    "superclass SmallSense::AbstractSearchProcessor says that I am responsible to implement this method"

    | pos |

    pos := objects collect: presentation.
    pos isSequenceable ifFalse:[ 
        pos := pos asArray.
    ].
    ^ pos sort:[ :a :b | a label == b label ]

    "Created: / 24-01-2015 / 00:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter:filter inEnvironment:environment relax:level
    "superclass SmallSense::AbstractSearchProcessor says that I am responsible to implement this method"

    ^ search value: pattern value: filter value: environment value: level

    "Created: / 24-01-2015 / 00:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

