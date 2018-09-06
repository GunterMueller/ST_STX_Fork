"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

PO subclass:#PackagePO
	instanceVariableNames:'package packageDefinition isJava'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!PackagePO class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

!PackagePO methodsFor:'accessing'!

icon
    ^ ToolbarIconLibrary smallYellowPackageIcon

    "Created: / 06-05-2014 / 00:09:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    ^ package

    "Created: / 19-06-2014 / 12:04:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ package 

    "Created: / 06-05-2014 / 00:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    ^ package
!

packageDefinition
    packageDefinition isNil ifTrue:[
        packageDefinition := ProjectDefinition definitionClassForPackage:package.
    ].
    ^ packageDefinition

    "Created: / 06-05-2014 / 00:05:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.
     
     For internal usage only."

    ^ package

    "Created: / 20-06-2014 / 11:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePO methodsFor:'initialization'!

initializeWithPackage: aStringOrSymbol
    package := aStringOrSymbol.
    isJava := false.

    "Created: / 19-06-2014 / 12:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePO methodsFor:'testing'!

isSmallSensePackagePO
    ^ true

    "Created: / 05-05-2014 / 23:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

