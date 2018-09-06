"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBAbstractContainer
	instanceVariableNames:'components labels'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Abstract'
!

!VDBAbstractContainer class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractContainer class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == VDBAbstractContainer.
! !

!VDBAbstractContainer methodsFor:'adding & removing components'!

addApplication: anApplicationModel
    | label |

    label := anApplicationModel perform: #title ifNotUnderstood:[ anApplicationModel class name ].
    ^ self addApplication: anApplicationModel labeled: label

    "Created: / 10-06-2014 / 14:23:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2014 / 16:59:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addApplication: anApplicationModel labeled: aString
    ^ self addApplication: anApplicationModel labeled: aString beforeIndex: components size + 1

    "Created: / 10-06-2014 / 16:59:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addApplication: anApplicationModel labeled: aString beforeIndex: anInteger
    | component |

    component := ApplicationSubView new.
    anApplicationModel createBuilder.
    anApplicationModel window: component.
    component client: anApplicationModel.
    ^ self addComponent: component labeled: aString beforeIndex: anInteger

    "Created: / 10-06-2014 / 16:58:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent: aView labeled: aString 
    self addComponent: aView labeled: aString beforeIndex: labels size + 1.

    "Created: / 10-06-2014 / 16:39:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addComponent: aView labeled: aString beforeIndex: anInteger
    labels add: aString beforeIndex: anInteger.
    components add: aView beforeIndex: anInteger.
    self assert: labels size == components size.

    "Created: / 10-06-2014 / 16:37:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-09-2014 / 22:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractContainer methodsFor:'aspects'!

debuggerHolder:aValueModel
    super debuggerHolder:aValueModel.
    components do:[:each | 
        each isApplicationSubView ifTrue:[ 
            each application debuggerHolder: aValueModel
        ].
    ].

    "Created: / 10-06-2014 / 17:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractContainer methodsFor:'initialization & release'!

initialize
    labels := List new.
    components := List new.
    components addDependent: self.

    "Created: / 10-06-2014 / 14:24:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-09-2014 / 22:21:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractContainer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

