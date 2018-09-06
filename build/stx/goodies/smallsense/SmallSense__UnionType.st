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

Type subclass:#UnionType
	instanceVariableNames:'types trustfullness trustfullnessBonus'
	classVariableNames:''
	poolDictionaries:'SmallSense::SmalltalkInferencerParameters'
	category:'SmallSense-Smalltalk-Types'
!

!UnionType class methodsFor:'documentation'!

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

!UnionType methodsFor:'accessing'!

trustfullness
    "Return an integer value in <1..100>, higher value
     means the object is more likely of that type."

    trustfullness isNil ifTrue:[
        self updateTrustfullness
    ].
    ^ trustfullness

    "Modified: / 18-09-2013 / 01:16:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness: anInteger
    "Remember the bonus/malus given by an inferences"

    trustfullnessBonus := anInteger - trustfullness.
    trustfullness := anInteger min: 100.

    "Created: / 17-05-2012 / 19:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullnessAdd: anInteger

    trustfullnessBonus := (trustfullnessBonus ? 0) + anInteger.
    trustfullness := trustfullness + anInteger.

    "Created: / 17-05-2012 / 19:47:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

types
    ^ types ? #()

    "Modified: / 16-12-2011 / 02:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

types:something
    types := something.
    self updateTrustfullness

    "Modified: / 17-05-2012 / 19:23:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'adding & removing'!

addType: typeOrHolder

   self basicAddType: typeOrHolder.
   self prune

    "Created: / 16-12-2011 / 01:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addTypes: typeOrHolder

   self basicAddTypes: typeOrHolder.
   self prune

    "Created: / 16-12-2011 / 01:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'adding & removing-private'!

basicAddType: typeOrHolder

    | type |
    typeOrHolder isTypeHolder ifTrue:[
        type := typeOrHolder type
    ] ifFalse:[
        type := typeOrHolder
    ].

    types isNil ifTrue:[types := OrderedCollection new].
    type isUnionType ifTrue:[
        self basicAddTypes: type types.
    ] ifFalse:[
        type isUnknownType ifFalse:[
            | existing |

            existing := types detect:[:each | each = type ] ifNone:[nil].
            existing isNil ifTrue:[
                types add: type.
            ] ifFalse:[
                existing trustfullness: (existing trustfullness max: type trustfullness)
            ]
        ]
    ].

    "Created: / 17-05-2012 / 19:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2013 / 01:14:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicAddTypes: someTypes

    someTypes do:[:each|self basicAddType: each ].

    "Created: / 17-05-2012 / 19:28:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'comparing'!

= another
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^self class == another class 
        and:[types size == another types size 
            and:[types = another types]]

    "Modified: / 16-12-2011 / 13:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^types hash

    "Modified: / 16-12-2011 / 13:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'enumerating'!

classesDo:aBlock
    "Enumerate all classes that this type represents"

    types notNil ifTrue:[
        ^types do:[:t|t classesDo: aBlock]    
    ].

    "Modified: / 16-12-2011 / 13:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typesDo: aBlock

    (types ? #()) do:[:each|
        each typesDo: aBlock
    ].

    "Created: / 16-12-2011 / 02:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'operations'!

classSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new 
        types: (types ? #() collect:[:t|t classSide])

    "Modified: / 16-12-2011 / 13:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new 
        types: (types ? #() collect:[:t|t instanceSide])

    "Modified: / 16-12-2011 / 13:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'printing & storing'!

printWithoutAnglesOn:aStream
    "superclass SmallSenseType says that I am responsible to implement this method"

    types isNil ifTrue:[ 
        aStream nextPut: $?
    ] ifFalse:[
        types 
            do:[:each|each printWithoutAnglesOn:aStream]
            separatedBy:[aStream space; nextPut:$|; space.]
    ]

    "Modified: / 24-09-2013 / 13:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'private'!

prune
    "Prune the types - remove less likely types."

    self updateTrustfullness.   
    types size < 1 ifTrue:[ ^ self ].

    "Experimental - remove those with trustfullness less than mine"    
    types := types reject:[:type|type trustfullness < trustfullness ].      


    (UnionTypeReduceThreshold notNil or:[types size > UnionTypeMaxSize]) ifTrue:[
        "/ Try to find common superclass...
        types size > (UnionTypeReduceThreshold ? 5) ifTrue:[
            | reduced |    
            reduced := types reduce:[ :a :b | ClassType new klass: (a klass commonSuperclass: b klass)].
            ((reduced klass ~~ Object) and:[reduced klass ~~ Object class]) ifTrue:[ 
                types  := OrderedCollection with: reduced. 
            ] ifFalse:[ 
                "/ If the size of types exeeds limit, make it Object anyway.
                types size > UnionTypeMaxSize ifTrue:[ 
                    types  := OrderedCollection with: reduced. 
                ].
            ].
        ].     
    ].

    "Created: / 17-05-2012 / 19:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2014 / 23:28:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTrustfullness
    "Recompute the trustfullness, This is subject to tuning"
    "Average if individual types"
    
    types isEmpty ifTrue: [
        trustfullness := 1
    ] ifFalse: [
        trustfullness := (types inject: 0
                into: [:a :type | a + type trustfullness ]) / types size.
        trustfullness := trustfullness + (trustfullnessBonus ? 0).
    ].

    "Created: / 17-05-2012 / 19:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2013 / 01:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType methodsFor:'testing'!

isUnionType

    ^true

    "Created: / 16-12-2011 / 02:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnknownType
    "Union type is consireded unknown iff types are empty or all
     unknown"

    ^types isEmptyOrNil or:[types allSatisfy:[:t|t isUnknownType]]

    "Created: / 24-07-2013 / 13:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnionType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

