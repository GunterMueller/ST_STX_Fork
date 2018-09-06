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

Object subclass:#Info
	instanceVariableNames:'manager errorneous'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types-Info'
!

!Info class methodsFor:'documentation'!

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

!Info methodsFor:'accessing'!

errorneous:aBoolean
    aBoolean ifTrue:[  
        self breakPoint: #jv.  
    ].
    errorneous := aBoolean.

    "Modified: / 21-08-2015 / 17:01:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Info methodsFor:'testing'!

isErrorneous
    ^ errorneous == true

    "Created: / 21-11-2014 / 16:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 17:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Info class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

