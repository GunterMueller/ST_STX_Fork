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

Info subclass:#MethodInfo
	instanceVariableNames:'classInfo selector returnType'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types-Info'
!

!MethodInfo class methodsFor:'documentation'!

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

!MethodInfo class methodsFor:'instance creation'!

forClassInfo: clsInfo selector: sel

    ^self new
        setClassInfo: clsInfo selector: sel;
        yourself

    "Created: / 27-11-2011 / 16:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodInfo methodsFor:'initialization'!

setManager: mgr classInfo: clsInfo selector: sel

    manager := mgr.
    classInfo := clsInfo.
    selector := sel.

    "Created: / 29-11-2011 / 15:58:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

