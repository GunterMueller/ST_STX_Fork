"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAccessors subclass:#TextAccessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!TextAccessor methodsFor:'xdm accessors - private'!

primDmAttributesFor: xdm
    ^ OrderedCollection new.

    "Created: / 06-10-2009 / 16:51:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmChildrenFor: xdm
    ^ OrderedCollection new.

    "Created: / 03-10-2009 / 18:22:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmStringValueFor: xdm
    xdm stringValue ifNil: [
        self dmStringValue: '' for: xdm.
    ].

    ^ xdm stringValue

    "Created: / 29-09-2009 / 12:10:37 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 16:48:06 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TextAccessor methodsFor:'xdm setters - private'!

primDmNodeName: nodeName for: xdm
    " there is no such property"
    ^ self

    "Created: / 03-10-2009 / 13:32:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 16:50:03 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TextAccessor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
