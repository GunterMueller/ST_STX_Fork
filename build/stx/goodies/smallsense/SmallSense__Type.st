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

Object subclass:#Type
	instanceVariableNames:''
	classVariableNames:'ObjectType'
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types'
!

!Type class methodsFor:'documentation'!

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
!

documentation
"
    An object representing an inferred type.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Type class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    ObjectType := ClassType new klass: Object

    "Modified: / 16-12-2011 / 02:23:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type class methodsFor:'instance creation'!

default

    <resource: #obsolete>

    ^self unknown

    "Created: / 26-11-2011 / 16:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unknown

    ^TypeHolder with: UnknownType new

    "Created: / 16-12-2011 / 09:42:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withClass: aClass
    self assert: aClass notNil.

    ^TypeHolder with: (ClassType new klass: aClass)

    "Created: / 26-11-2011 / 14:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 14:11:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'accessing'!

trustfullness
    "Return an integer value in <1..100>, higher value
     means the object is more likely of that type."

    ^self subclassResponsibility

    "Created: / 17-05-2012 / 19:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness: anInteger
    "Set the trustfullness"

    ^self subclassResponsibility

    "Created: / 17-05-2012 / 19:43:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullnessAdd: anInteger 
    "Advance mu trustfullness by an Integer"

    self trustfullness: self trustfullness + anInteger

    "Created: / 17-05-2012 / 19:46:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'comparing'!

= another

    ^self subclassResponsibility

    "Created: / 16-12-2011 / 13:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^self subclassResponsibility

    "Created: / 16-12-2011 / 13:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'enumerating'!

classes
    "Return set of all classes that this type represents"

    ^ OrderedCollection streamContents:[:s| self classesDo:[:cls|s nextPut: cls] ].

    "Created: / 04-10-2013 / 13:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesDo: aBlock
    "Enumerate all classes that this type represents"

    self subclassResponsibility

    "Created: / 16-12-2011 / 13:33:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typesDo: aBlock

    aBlock value: self

    "Created: / 16-12-2011 / 02:16:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'operations'!

classSide

    ^self subclassResponsibility

    "Created: / 16-12-2011 / 13:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceSide

    ^self subclassResponsibility

    "Created: / 16-12-2011 / 13:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

union: anotherType

    ^UnionType new
        addType: self;
        addType: anotherType;
        yourself

    "Created: / 16-12-2011 / 02:00:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'printing & storing'!

printOn:aStream

    aStream nextPut:$<; space.
    self printWithoutAnglesOn: aStream.
    aStream space; nextPut:$>.

    "Modified: / 24-09-2013 / 13:47:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printWithoutAnglesOn: aStream

    self subclassResponsibility

    "Created: / 16-12-2011 / 01:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type methodsFor:'testing'!

isClassType

    ^false

    "Created: / 16-12-2011 / 02:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTypeHolder

    ^false

    "Created: / 16-12-2011 / 02:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnionType

    ^false

    "Created: / 16-12-2011 / 02:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnknownType

    ^false

    "Created: / 16-12-2011 / 13:29:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Type class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


Type initialize!
