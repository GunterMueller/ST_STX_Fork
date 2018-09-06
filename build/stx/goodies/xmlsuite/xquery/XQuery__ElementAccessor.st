"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAccessors subclass:#ElementAccessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!ElementAccessor methodsFor:'private'!

descendants: xdm
    | children descendants |
    descendants := OrderedCollection new.

    children := self dmChildrenFor: xdm.

    descendants addAll: children.
    children do: [ :child |
        descendants addAll: (self descendants: child).
    ].

    ^ descendants.

    "Created: / 03-10-2009 / 14:46:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ElementAccessor methodsFor:'xdm accessors - private'!

primDmAttributesFor: xdm
    xdm attributes ifNil:
    [
        ^ XQuerySequence new.
    ]
    ifNotNil:
    [
        ^ xdm attributes.
    ].

    "Created: / 03-10-2009 / 14:16:59 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 13:07:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmChildrenFor: xdm
    xdm children ifNil:
    [
        ^ OrderedCollection new.
    ]
    ifNotNil:
    [
        ^ xdm children.
    ].

    "Created: / 03-10-2009 / 14:13:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmDocumentUriFor: xdm
    ^ XQuerySequence new.

    "Created: / 03-10-2009 / 14:13:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmStringValueFor: xdm
    "The string-value property of an Element Node must be the concatenation of the 
        string-values of all its Text Node descendants in document order or, if the 
        element has no such descendants, the zero-length string."

    | stringValue descendants |
    stringValue := ''.
    descendants := self descendants: xdm.

    descendants do: [ :descendant |
        descendant nodeKind = 'text' ifTrue:
        [
            stringValue := stringValue, (self dmStringValueFor: descendant).
        ]
    ].

    ^ stringValue.

    "Created: / 03-10-2009 / 14:38:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 16:47:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmTypedValueFor: xdm
    ^ AtomicItem withValue: (self dmStringValueFor: xdm).

    "Created: / 06-10-2009 / 15:43:44 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ElementAccessor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
