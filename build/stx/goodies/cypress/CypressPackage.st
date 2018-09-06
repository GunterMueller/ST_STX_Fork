"{ Package: 'stx:goodies/cypress' }"

CypressModel subclass:#CypressPackage
	instanceVariableNames:'definition comment classes extensions'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Model'
!


!CypressPackage class methodsFor:'instance creation'!

fromDirectory: directory
    "Reads a CypressPackage from given directory"

    ^self new initializeFromDirectory: directory

    "Created: / 13-09-2012 / 15:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromPackage: packageId
    "Creates new CypressPackage for given package id"

    ^self fromPackageDefinition: (ProjectDefinition definitionClassForPackage: packageId createIfAbsent: true).

    "Created: / 10-09-2012 / 23:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromPackageDefinition: projectDefinition

    ^self new initializeFromPackageDefinition: projectDefinition

    "Created: / 10-09-2012 / 23:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressPackage methodsFor:'accessing'!

classes

    classes isNil ifTrue:[
        classes := OrderedCollection new.
    ].
    ^classes

    "Created: / 10-09-2012 / 23:45:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comment
    ^ comment
!

comment:something
    comment := something.
!

definition
    ^ definition
!

extensions

    extensions isNil ifTrue:[
        extensions := OrderedCollection new.   
    ].
    ^extensions

    "Created: / 11-09-2012 / 11:03:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressPackage methodsFor:'converting'!

asChange
    "superclass CypressModel says that I am responsible to implement this method"

    ^ self shouldNotImplement

    "Modified: / 18-09-2012 / 10:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressPackage methodsFor:'initialization'!

initializeFromPackageDefinition: projectDefinition
    definition := projectDefinition.
    name := projectDefinition package asString.
    properties := Dictionary new.

    properties 
        at: '_cypress_copyright' put: (definition legalCopyright);
        at: '_stx_name' put: name.

    classes := definition classes collect:[:cls|CypressClass fromClass: cls].
    extensions := definition extensionMethods collect:[:mthd|CypressMethod fromMethod: mthd].

    "Created: / 10-09-2012 / 23:35:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressPackage methodsFor:'private'!

changesInto:aChangeSet
    "superclass CypressModel says that I am responsible to implement this method"

    self classes do:[:each|each changesInto: aChangeSet].
    self extensions do:[:each|each changesInto: aChangeSet].

    "Modified: / 18-09-2012 / 10:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressPackage class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !
