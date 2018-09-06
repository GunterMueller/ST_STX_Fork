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

Object subclass:#CustomDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI'
!

!CustomDialog class methodsFor:'documentation'!

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
    A simple factory for user dialogs.

    Note: in future, API of this class will be merged into DialogBox and
    CustomDialog and subclasses will vanish.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>
        Jakub Nesveda <nesvejak@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CustomDialog class methodsFor:'testing'!

isAbstract
    ^ self == CustomDialog
! !

!CustomDialog methodsFor:'common dialogs'!

requestClassName: label initialAnswer:initial

    | holder |

    holder := ValueHolder with: initial.
    self addClassNameEntryOn: holder labeled: 'Class' validateBy: nil.
    self addAbortAndOkButtons.
    self open ifTrue:[ 
        ^ holder value
    ]

    "
    CustomUserDialog new requestClassName: 'Select class' initialAnswer: 'Array'.
    "

    "Created: / 10-05-2014 / 15:33:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 15-09-2014 / 16:26:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 21:10:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomDialog methodsFor:'construction-adding'!

addAbortAndOkButtons
    ^ self subclassResponsibility

    "Created: / 15-09-2014 / 16:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addButtons
    self addAbortAndOkButtons

    "Created: / 15-09-2014 / 18:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addCheckBoxOn: aValueModel labeled: aString
    | checkbox |

    checkbox := CheckBox new.
    checkbox model: aValueModel.
    checkbox label: aString.

    ^ self addComponent: checkbox labeled: nil.

    "Created: / 15-09-2014 / 18:11:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent:aView
    "Add given component. Component is automatically stretched to occupy windows' width"

    self subclassResponsibility.

    "Created: / 15-09-2014 / 18:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent:aView labeled:labelString
    "Add a label and some component side-by-side. Returns the component"

    self subclassResponsibility

    "Created: / 15-09-2014 / 15:43:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addInputFieldOn: aValueModel labeled: aString validatedBy: aBlock
    | field |

    field := EditField new.
    field immediateAccept: true.
    field model: aValueModel.

    ^ self addComponent: field labeled: aString

    "Created: / 15-09-2014 / 15:52:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSeparator
    "Add horizontal separator (line)"
    ^ self addComponent: Separator new

    "Created: / 15-09-2014 / 18:52:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomDialog methodsFor:'construction-utilities'!

addClassCategoryEntryOn: aValueModel labeled: aString validateBy: aBlock

    ^ (self addInputFieldOn: aValueModel labeled: aString validatedBy: aBlock)
        entryCompletionBlock: [:text | DoWhatIMeanSupport classCategoryCompletion: text inEnvironment: Smalltalk ];
        yourself

    "Created: / 16-09-2014 / 10:13:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClassNameEntryOn: aValueModel labeled: aString validateBy: aBlock

    ^ (self addInputFieldOn: aValueModel labeled: aString validatedBy: aBlock)
        entryCompletionBlock: (DoWhatIMeanSupport classNameEntryCompletionBlock);
        yourself

    "Created: / 15-09-2014 / 15:43:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSelectorNameEntryOn: aValueModel labeled: aString validateBy: aBlock

    ^ (self addInputFieldOn: aValueModel labeled: aString validatedBy: aBlock)
        entryCompletionBlock: [:text | DoWhatIMeanSupport selectorCompletion:text inEnvironment:Smalltalk];
        yourself

    "Created: / 15-10-2014 / 08:44:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomDialog methodsFor:'opening'!

open
    self subclassResponsibility

    "Created: / 15-09-2014 / 16:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomDialog methodsFor:'user interaction & notifications'!

information: aString

    self subclassResponsibility

    "Created: / 02-06-2014 / 22:01:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

