"{ Package: 'stx:goodies/cypress' }"

CypressModel subclass:#CypressMethod
	instanceVariableNames:'klass meta category source'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Model'
!


!CypressMethod class methodsFor:'instance creation'!

fromFile: aStringOrFilename
    "Reads a CypressMethod from given file"
    ^self new initializeFromFile: aStringOrFilename

    "Created: / 13-09-2012 / 15:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromMethod: aMethod
    "Returns a Cypress method for given (real) method"
    ^self new initializeFromMethod: aMethod

    "Created: / 11-09-2012 / 00:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressMethod methodsFor:'accessing'!

category
    ^ category ? '* as yet unclassified *'

    "Modified: / 18-09-2012 / 10:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

category:something
    category := something.
!

fullClassName
    ^meta == true 
        ifTrue:[klass , ' class']
        ifFalse:[klass]

    "Created: / 18-09-2012 / 10:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

klass
    ^ klass
!

klass:something
    klass := something.
!

meta
    ^ meta
!

meta:something
    meta := something.
!

selector
    ^self name

    "Created: / 11-09-2012 / 11:18:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    ^ source
!

source:aString
    source := aString.
    name := (Parser parseMethodSpecification: source) selector

    "Modified: / 18-09-2012 / 11:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressMethod methodsFor:'converting'!

asChange
    "superclass CypressModel says that I am responsible to implement this method"

    ^ MethodDefinitionChange new
        className: self fullClassName;
        category: self category;
        source: self source;
        selector: self name.

    "Modified: / 18-09-2012 / 11:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressMethod methodsFor:'initialization'!

initializeFromFile: aStringOrFilename
    self readFrom: aStringOrFilename

    "Created: / 13-09-2012 / 15:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFromMethod: aMethod
    name := aMethod selector.
    klass := aMethod mclass theNonMetaclass name.
    meta := aMethod mclass isMetaclass.
    category := aMethod category.
    source := aMethod source.

    "Created: / 11-09-2012 / 00:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressMethod methodsFor:'private'!

changesInto:aChangeSet
    "superclass CypressModel says that I am responsible to implement this method"

    ^ aChangeSet add: self asChange

    "Modified: / 18-09-2012 / 10:57:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressMethod class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
