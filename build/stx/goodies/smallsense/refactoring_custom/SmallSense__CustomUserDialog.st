"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

CustomDialog subclass:#CustomUserDialog
	instanceVariableNames:'dialog'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI'
!

!CustomUserDialog class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
    CustomDialog implementation with real dialogs to provide human interaction.
    Currently it is a simple wrapper around DialogBox. 

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomUserDialog class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CustomUserDialog methodsFor:'accessing'!

dialog
    ^ dialog
!

dialog:something
    dialog := something.
! !

!CustomUserDialog methodsFor:'construction-adding'!

addAbortAndOkButtons
    "Adds buttons Ok and Cancel"

    dialog addAbortAndOkButtons

    "Created: / 15-09-2014 / 16:21:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-11-2014 / 22:52:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

addComponent:aView
    "Add given component. Component is automatically stretched to occupy windows' width"

    ^ dialog addComponent: aView

    "Created: / 15-09-2014 / 18:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent:aView labeled:aString
    "Add a label and some component side-by-side. Returns the component"

"/    aString notEmptyOrNil ifTrue:[
        ^ dialog
            addLabelledField:aView 
            label:aString ? ''
            adjust:#left 
            tabable:true 
            separateAtX:0.3
"/    ] ifFalse:[ 
"/        ^ dialog
"/            addComponent:aView indent: 0.3
"/    ].

    "Created: / 15-09-2014 / 15:45:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2014 / 19:44:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomUserDialog methodsFor:'initialization'!

initialize

    dialog := DialogBox new

    "Modified: / 15-09-2014 / 16:23:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 21:09:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomUserDialog methodsFor:'opening'!

open
    "Actually opens the dialog. Return true, if dialog has been accepted
     of raises abort request if it has been cancelled."

    dialog open.
    dialog accepted ifFalse: [
        AbortOperationRequest raiseRequest
    ].

    ^ dialog accepted

    "Created: / 15-09-2014 / 16:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2014 / 17:52:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 21:08:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomUserDialog methodsFor:'user interaction & notifications'!

information: aString

    ^ Dialog information: aString

    "Created: / 02-06-2014 / 22:36:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 22-07-2014 / 21:25:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomUserDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

