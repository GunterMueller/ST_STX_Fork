"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/mercurial' }"

HGRepositoryObject subclass:#HGRemote
	instanceVariableNames:'name url'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGRemote class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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

!HGRemote class methodsFor:'instance creation'!

name: name url: url
    ^ self new setName: name url: url

    "Created: / 18-03-2014 / 12:08:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

url: url
    ^ self name: url asString url: url

    "Created: / 18-03-2014 / 12:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote methodsFor:'accessing'!

name
    ^ name
!

url
    ^ url
! !

!HGRemote methodsFor:'converting'!

asString
    ^name notNil 
        ifTrue:[name] 
        ifFalse:[url asString].

    "Created: / 29-01-2013 / 15:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote methodsFor:'displaying'!

displayString
    ^self isDefault ifTrue:[
        name asText allBold , ' - ', url asString
    ] ifFalse:[
        name , ' - ', url asString
    ]

    "Created: / 10-12-2012 / 01:33:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote methodsFor:'initialization'!

setName: aString
    name := aString.
!

setName: aString url: aStringOrUrl
    name := aString.
    url := aStringOrUrl asURL

    "Created: / 09-12-2012 / 22:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    name printOn:aStream.
    aStream nextPutAll:' - '.
    url printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 10-12-2012 / 01:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote methodsFor:'testing'!

isDefault
    "Return true, if receiver is default remote repository,
     i.e., if default push should go there"

    ^ name = 'default'

    "Created: / 09-12-2012 / 23:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRemote class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

