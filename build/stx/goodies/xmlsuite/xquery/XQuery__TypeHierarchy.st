"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#TypeHierarchy
	instanceVariableNames:'root types'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeHierarchy methodsFor:'accessing'!

getType: type
    self assert: (type isXMLType).

    ^ self getTypeByName: type typeName.

    "Created: / 05-11-2009 / 21:30:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

getTypeByName: typeName
    ^ self types at: typeName ifAbsent: [ self raiseError ].

    "Created: / 05-11-2009 / 21:53:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

root
    ^ root

    "Created: / 05-11-2009 / 21:27:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

root: aRoot
    root := TypeHierarchyNode new 
                value: aRoot.
    self types at: aRoot typeName put: root.

    "Created: / 05-11-2009 / 21:23:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

types
    types ifNil:
    [
        types := Dictionary new.
    ].

    ^ types.

    "Created: / 05-11-2009 / 21:32:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeHierarchy methodsFor:'adding & removing'!

addSubtype: subtype toType: type
    " add subtype as children of the type "
    | typeNode subtypeNode |

    self assert: subtype isXMLType.
    self assert: type isXMLType.

    typeNode := self getType: type.
    subtypeNode := (TypeHierarchyNode new)
        value: subtype;
        parent: typeNode.
    typeNode children add: subtypeNode.
    self types at: subtype typeName put: subtypeNode.

    "Created: / 05-11-2009 / 21:29:53 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 20:56:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

addType: type
    " add type without any parent "
    | typeNode |

    self assert: type isXMLType.

    typeNode := (TypeHierarchyNode new)
        value: type.
    self types at: type typeName put: typeNode.

    "Created: / 06-11-2009 / 20:56:29 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeHierarchy methodsFor:'error reporting'!

raiseError
    TypeError raise.

    "Created: / 01-11-2009 / 18:29:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

raiseErrorWithMessage: message
    TypeError raiseErrorString: message.

    "Created: / 01-11-2009 / 18:28:10 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!TypeHierarchy class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
