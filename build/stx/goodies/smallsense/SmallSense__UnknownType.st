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

Type subclass:#UnknownType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types'
!

UnknownType class instanceVariableNames:'theOneAndOnlyInstance'

"
 No other class instance variables are inherited by this class.
"
!

!UnknownType class methodsFor:'documentation'!

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

!UnknownType class methodsFor:'instance creation'!

flushSingleton
    "flushes the cached singleton"

    theOneAndOnlyInstance := nil

    "
     self flushSingleton
    "
!

new
    "returns a singleton"

    ^ self theOneAndOnlyInstance.
!

theOneAndOnlyInstance
    "returns a singleton"

    theOneAndOnlyInstance isNil ifTrue:[
        theOneAndOnlyInstance := self basicNew initialize.
    ].
    ^ theOneAndOnlyInstance.
! !

!UnknownType methodsFor:'accessing'!

trustfullness
    "Return an integer value in <1..100>, higher value
     means the object is more likely of that type."

    ^ 1

    "Modified: / 17-05-2012 / 19:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trustfullness: anInteger
    "Nothing to do here"

    "Created: / 17-05-2012 / 19:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType methodsFor:'comparing'!

= another
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^self == another

    "Modified: / 16-12-2011 / 13:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self identityHash

    "Modified: / 16-12-2011 / 13:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType methodsFor:'enumerating'!

classesDo:aBlock
    "Enumerate all classes that this type represents"

    ^ aBlock value: Object

    "Modified: / 16-12-2011 / 13:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType methodsFor:'operations'!

classSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new

    "Modified: / 16-12-2011 / 13:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instanceSide
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ self class new

    "Modified: / 16-12-2011 / 13:21:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

union: anotherType

    ^anotherType

    "Created: / 16-12-2011 / 02:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType methodsFor:'printing & storing'!

printWithoutAnglesOn:aStream
    "superclass SmallSenseType says that I am responsible to implement this method"

    ^ aStream nextPut:$?

    "Modified: / 16-12-2011 / 02:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType methodsFor:'testing'!

isUnknownType

    ^true

    "Created: / 16-12-2011 / 13:29:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UnknownType class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

