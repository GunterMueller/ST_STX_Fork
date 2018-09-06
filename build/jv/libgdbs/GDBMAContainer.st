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

Magritte::MAContainer subclass:#GDBMAContainer
	instanceVariableNames:'klass'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Support'
!

!GDBMAContainer class methodsFor:'documentation'!

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

!GDBMAContainer class methodsFor:'instance creation'!

forClass: aClass
    ^ self new  
        klass:aClass;
        yourself

    "Created: / 23-09-2014 / 22:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAContainer class methodsFor:'testing'!

isAbstract
    ^ false

    "Created: / 23-09-2014 / 22:38:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAContainer methodsFor:'accessing'!

klass
    ^ klass
!

klass:something
    klass := something.
!

propertyDescriptorAt: name
    ^ children detect:[:each | (each accessor isKindOf: GDBMAPropertyAccessor) and:[ each accessor name = name ] ] ifNone:nil

    "Created: / 23-09-2014 / 22:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAContainer methodsFor:'adding-easy shortcuts'!

define: property as: class
    "/ Handle primitive types furst...

    | description |

    class == Boolean ifTrue:[ 
        description := Magritte::MABooleanDescription new.
    ] ifFalse:[
    class == Integer ifTrue:[ 
        description := Magritte::MANumberDescription new
    ] ifFalse:[
    class == String ifTrue:[ 
        description := Magritte::MAStringDescription new
    ] ifFalse:[
    class == ByteArray ifTrue:[ 
        description :=GDBMAByteArrayDescription new        
    ] ifFalse:[
        description := class description. 
    ]]]].
    description accessor: (GDBMAPropertyAccessor forPropertyNamed: property).

    self add: description.
    ^ description

    "Created: / 23-09-2014 / 22:20:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2018 / 11:20:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

define: property as: collectionClass of: elementClass
    "/ Handle primitive types first...

    | description |

    elementClass == Boolean ifTrue:[ 
        description := Magritte::MAToManyScalarRelationDescription new.
        description reference: Magritte::MABooleanDescription new.      
    ] ifFalse:[
    elementClass == Integer ifTrue:[ 
        description := Magritte::MAToManyScalarRelationDescription new.
        description reference: Magritte::MANumberDescription new.
    ] ifFalse:[
    elementClass == String ifTrue:[
        description := Magritte::MAToManyScalarRelationDescription new.
        description reference: Magritte::MAStringDescription new.
    ] ifFalse:[
    elementClass == ByteArray ifTrue:[
        description := Magritte::MAToManyScalarRelationDescription new.
        description reference: GDBMAByteArrayDescription new.     
    ] ifFalse:[
        description := Magritte::MAToManyRelationDescription new.
        description reference: elementClass description.
    ]]]].
    description accessor: (GDBMAPropertyAccessor forPropertyNamed: property).       
    description classes: (Array with: elementClass).
    description ordered: (collectionClass inheritsFrom: SequenceableCollection).

    self add: description.
    ^ description.

    "Created: / 23-09-2014 / 22:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2018 / 11:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-07-2018 / 16:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

define: property as: collectionClass of: elementClass1 whenTaggedBy: tag1 or: elementClass2 whenTaggedBy: tag2 
    "/ Handle primitive types first...

    | description |

    description := Magritte::MAToManyRelationDescription new.
    description reference: (
        GDBMADescriptionSwitch 
            forTag: tag1 use: elementClass1 description 
            forTag: tag2 use: elementClass2 description 
    ).
    description classes: (Array with: elementClass1 with: elementClass2).
    description accessor: (GDBMAPropertyAccessor forPropertyNamed: property).       
    description ordered: (collectionClass inheritsFrom: SequenceableCollection).

    self add: description.
    ^ description.

    "Created: / 03-07-2018 / 17:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMAContainer methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser:aGDBMIParser
    ^ aGDBMIParser parseValueAsInstanceOf: klass describedBy: self.

    "Created: / 23-09-2014 / 22:32:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

