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

AbstractSearchProcessor subclass:#CompositeProcessor
	instanceVariableNames:'processors'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!CompositeProcessor class methodsFor:'documentation'!

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

!CompositeProcessor class methodsFor:'instance creation'!

with: processor1
    ^ self withAll: (Array with: processor1)

    "Created: / 10-01-2015 / 07:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

with: processor1 with: processor2
    ^ self withAll: (Array with: processor1 with: processor2)

    "Created: / 10-01-2015 / 07:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

with: processor1 with: processor2 with: processor3
    ^ self withAll: (Array with: processor1 with: processor2 with: processor3)

    "Created: / 10-01-2015 / 07:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAll: processors
    ^ self new processors: processors

    "Created: / 10-01-2015 / 07:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeProcessor methodsFor:'accessing'!

canDoNextStepFor: aPO
    "Return true if navigation can take a next step for given PO
     (i.e., if user can 'dive in'), false otherwise.
     To be overriden by subclasses to avoid excessive processor creation."

    ^ aPO context canDoNextStepFor: aPO

    "Created: / 23-01-2015 / 22:26:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processorForNextStepFor: aPO
    "Return a processor for next navigation step for given PO.
     If nil is returned, then there's no next step (i.e.,
     a user connot 'dive in')"

    ^ aPO context processorForNextStepFor: aPO

    "Created: / 23-01-2015 / 22:26:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processors
    ^ processors
!

processors:aCollection
    processors := aCollection asArray

    "Modified: / 10-01-2015 / 06:59:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recentlySearchedObjectPOs
    | pos |

    pos := OrderedCollection new: processors size.
    processors do:[:processor  |
        | bucket |

        bucket := processor recentlySearchedObjectPOs.
        bucket notEmptyOrNil ifTrue:[ 
            | sectionPO bucketPOs|

            sectionPO := PluggablePO new.
            pos add: sectionPO.
            sectionPO label: ((processor label bindWith: processor label with: bucket size) asText colorizeAllWith: Color gray).
            sectionPO subject: self. "/ used as a marker that this is a group PO
            bucketPOs := bucket.
            bucketPOs do:[:e | e context: processor ].
            false ifTrue:[ 
                sectionPO children: bucketPOs.
                sectionPO expand
            ] ifFalse:[ 
                pos addAll: bucketPOs.
            ].



        ].
    ].
    ^ pos

    "Created: / 11-01-2015 / 06:25:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeProcessor methodsFor:'accessing - presentation'!

label
    "Return a label for this processor. This one is used as section label
     in Spotter"

    processors notEmptyOrNil ifTrue:[ 
        processors size == 1 ifTrue:[ ^ processors anElement label ].
        processors size == 2 ifTrue:[ ^ processors first label , ' & ' , processors second label ].
        processors size == 2 ifTrue:[ ^ processors first label , ', ', processors second label, ' & ' , processors third label ].
        ^ processors size , ' search processors'
    ] ifFalse:[ 
        ^ 'Empty'
    ].

    "Created: / 10-01-2015 / 06:44:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeProcessor methodsFor:'remembering'!

rememberSearchObjectPO: po
    po context rememberSearchObjectPO: po

    "Created: / 11-01-2015 / 06:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompositeProcessor methodsFor:'searching'!

matchingObjectPOsFor: objects
    ^ self matchingObjectPOsFor: objects label: '%1 (%2 matches)'

    "Created: / 10-01-2015 / 06:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-01-2015 / 06:24:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectPOsFor: objects label: label

    | pos |

    objects isEmptyOrNil ifTrue:[ ^ #() ].
    pos := OrderedCollection new: processors size.
    processors with: objects do:[:processor :bucket |
        bucket notEmptyOrNil ifTrue:[ 
            | sectionPO bucketPOs|

            sectionPO := PluggablePO new.
            pos add: sectionPO.
            sectionPO label: ((label bindWith: processor label with: bucket size) asText colorizeAllWith: Color gray).
            sectionPO subject: self. "/ used as a marker that this is a group PO
            bucketPOs := processor matchingObjectPOsFor: bucket.
            bucketPOs do:[:e | e context: processor ].
            false ifTrue:[ 
                sectionPO children: bucketPOs.
                sectionPO expand
            ] ifFalse:[ 
                pos addAll: bucketPOs.
            ].



        ].
    ].
    ^ pos

    "Created: / 11-01-2015 / 06:24:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter: filter inEnvironment:environment
    ^ (processors ? #()) collect: [ :processor | processor matchingObjectsForPattern:pattern filter: filter inEnvironment:environment ]

    "Created: / 10-01-2015 / 06:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter:filter inEnvironment:environment relax:level
    "superclass SmallSense::AbstractSearchProcessor says that I am responsible to implement this method"

    ^ self shouldNotImplement

    "Created: / 10-01-2015 / 06:45:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

