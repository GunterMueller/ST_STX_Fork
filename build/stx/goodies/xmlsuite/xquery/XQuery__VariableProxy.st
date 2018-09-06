"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::VariableProxy subclass:#VariableProxy
	instanceVariableNames:'nativeContext'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Debugging-Model'
!


!VariableProxy methodsFor:'accessing'!

name
    ^ name

    "Created: / 18-09-2008 / 18:13:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

name:something
    name := something.

    "Created: / 18-09-2008 / 18:13:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nativeContext
    ^ nativeContext

    "Created: / 18-09-2008 / 18:13:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nativeContext:something
    nativeContext := something.

    "Created: / 18-09-2008 / 18:13:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

typeName
    "Superclass Perseus::VariableProxy says that I am responsible to implement this method"

    ^self value typeName

    "Created: / 18-09-2008 / 18:14:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 20:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value
    "Superclass Perseus::VariableProxy says that I am responsible to implement this method"

    ^nativeContext variableAt: name

    "Created: / 18-09-2008 / 18:14:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

value: anObject
    "Superclass Perseus::VariableProxy says that I am responsible to implement this method"

    ^nativeContext variableAt: name put: anObject

    "Created: / 18-09-2008 / 18:14:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

valueString

    | value |
    value := self value.
    ^value isAtomicValue 
        ifTrue:[value value printString]
        ifFalse:[value dmStringValue]

    "Created: / 20-04-2010 / 20:58:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableProxy methodsFor:'converting'!

asDocumentFragment

    ^self value asDocumentFragment

    "Created: / 23-04-2010 / 11:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableProxy class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
