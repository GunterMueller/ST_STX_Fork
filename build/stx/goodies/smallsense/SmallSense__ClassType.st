"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

Type subclass:#ClassType
	instanceVariableNames:'trustfullness klass'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types'
!

!ClassType class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

!ClassType methodsFor:'accessing'!

klass
    ^ klass
!

klass:aClass

    self assert: aClass notNil.
    klass := aClass.
    (klass == True or:[klass == False]) ifTrue: [
        klass := Boolean
    ].
    "Some manual trustfullness tweaks"
    klass == Object ifTrue:[
        self trustfullnessAdd: -10. 
    ]

    "Modified (format): / 05-10-2013 / 00:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness
    ^ trustfullness ? 20

    "Modified: / 17-05-2012 / 19:35:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness:something
    trustfullness := something min: 100.

    "Modified: / 17-05-2012 / 19:46:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType methodsFor:'comparing'!

= another

    ^self class == another class 
        and:[klass == another klass]

    "Modified: / 16-12-2011 / 13:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^ klass hash

    "Modified: / 16-12-2011 / 13:38:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType methodsFor:'enumerating'!

classesDo:aBlock
    "Enumerate all classes that this type represents"

    ^ aBlock value: klass

    "Modified: / 16-12-2011 / 13:33:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType methodsFor:'operations'!

classSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new 
        klass: klass class;
        trustfullness: self trustfullness - 10;
        yourself

    "Modified: / 18-09-2013 / 02:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new 
        klass: klass theNonMetaclass;
        trustfullness: self trustfullness - 10;
        yourself

    "Modified: / 18-09-2013 / 02:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType methodsFor:'printing & storing'!

printWithoutAnglesOn:aStream
    "superclass SmallSenseType says that I am responsible to implement this method"

    klass == UndefinedObject ifTrue:[
         'nil' printOn: aStream 
    ] ifFalse:[
        klass printOn: aStream
    ].

    "Modified: / 24-09-2013 / 13:46:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType methodsFor:'testing'!

isClassType

    ^true

    "Created: / 16-12-2011 / 02:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnknownType

    ^klass == UndefinedObject

    "Created: / 31-01-2014 / 01:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

