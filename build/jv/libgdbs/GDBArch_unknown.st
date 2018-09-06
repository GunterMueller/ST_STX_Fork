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

GDBArchitecture subclass:#GDBArch_unknown
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBArch_unknown class methodsFor:'documentation'!

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

!GDBArch_unknown methodsFor:'accessing'!

name
    ^ name

    "Created: / 16-08-2018 / 09:00:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_unknown methodsFor:'initialization'!

setName: aString
    name := aString

    "Created: / 16-08-2018 / 09:00:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBArch_unknown methodsFor:'queries'!

sizeofPointer
    ^ 8 "/ conservative value

    "Created: / 16-08-2018 / 09:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

