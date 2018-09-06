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

CustomDialog subclass:#CustomSilentDialog
	instanceVariableNames:'methodAnswers'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI'
!

CustomSilentDialog subclass:#NilComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomSilentDialog
!

!CustomSilentDialog class methodsFor:'documentation'!

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
    CustomDialog implementation based on non human interaction with dialog answers.
    You may set dialog aswers to inject them in code generators.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomSilentDialog class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize

    "Created: / 11-05-2014 / 11:13:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'accessing'!

answer: anAnswer forSelector: aSelector

    methodAnswers 
        at: aSelector 
        put: anAnswer

    "Created: / 11-05-2014 / 00:32:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodAnswer: aSelector   

    ^ methodAnswers at: aSelector

    "Created: / 11-05-2014 / 00:25:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'construction-adding'!

addAbortAndOkButtons
    "/ Nothing to do

    "Created: / 15-09-2014 / 16:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent:aView
    "Add given component. Component is automatically stretched to occupy windows' width"

    ^ CustomSilentDialog::NilComponent new

    "Created: / 15-09-2014 / 18:48:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 11:27:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

addComponent:aView labeled:labelString
    "Add a label and some component side-by-side. Returns the component"

    ^ CustomSilentDialog::NilComponent new

    "Created: / 15-09-2014 / 15:45:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-10-2014 / 11:26:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'dialogs'!

requestClassName:aString initialAnswer:anInitialAswer

    ^ self methodAnswer: #requestClassName:initialAnswer:

    "Created: / 11-05-2014 / 00:16:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'initialization'!

initialize

    methodAnswers := Dictionary new

    "Created: / 11-05-2014 / 00:19:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'opening'!

open
    "/ Ignored

    "Created: / 15-09-2014 / 16:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomSilentDialog methodsFor:'user interaction & notifications'!

information: aString

    ^ self

    "Created: / 13-05-2014 / 22:33:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog::NilComponent class methodsFor:'documentation'!

documentation
"
    Substitute for component in CustomDialog to hide any real UI.
    This class just understand all method calls and returns self.
"
! !

!CustomSilentDialog::NilComponent methodsFor:'queries'!

doesNotUnderstand: aMessage
    "Do nothing when a message arrives."

    ^ self

    "Created: / 14-10-2014 / 11:25:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSilentDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

