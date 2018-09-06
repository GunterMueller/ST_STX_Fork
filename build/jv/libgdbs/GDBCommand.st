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

Object subclass:#GDBCommand
	instanceVariableNames:'token'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands'
!

!GDBCommand class methodsFor:'documentation'!

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

!GDBCommand class methodsFor:'utilities'!

parse: aStringOrStream
    "Return an sub-instance of GDBCommand from textual representation"

    ^ (GDBMIParser on: aStringOrStream readStream) parseCommand.

    "
    GDBCommand parse: 'b new.c : 123'
    "

    "Created: / 08-01-2018 / 19:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommand methodsFor:'accessing'!

token
    ^ token
!

token:anInteger
    token := anInteger.
! !

!GDBCommand methodsFor:'accessing-descriptors'!

resultDescription
    ^ GDBMAContainer new

    "Created: / 19-06-2014 / 21:39:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:37:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommand methodsFor:'converting'!

asString
    ^ String streamContents: [ :s | (GDBMIPrinter on: s) printCommand: self ]

    "Created: / 09-06-2014 / 18:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 23:14:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommand methodsFor:'printing & storing'!

printOn: aStream
    super printOn: aStream.
    aStream nextPut: $(; nextPutAll: self asString; nextPut:$)

    "Created: / 11-07-2017 / 23:23:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBCommand methodsFor:'testing'!

isCLICommand
    ^ false
!

isMICommand
    ^ false
! !

!GDBCommand class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

