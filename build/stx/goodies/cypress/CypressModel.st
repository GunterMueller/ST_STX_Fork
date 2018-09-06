"{ Package: 'stx:goodies/cypress' }"

"{ NameSpace: Smalltalk }"

Object subclass:#CypressModel
	instanceVariableNames:'name properties'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Model'
!

!CypressModel class methodsFor:'documentation'!

documentation
"
    An abstract class to model packages, classes and methods.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CypressModel methodsFor:'accessing'!

name
    ^ name
!

name:nm
    name := nm asString.

    "Modified: / 13-09-2012 / 15:17:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

properties
    properties isNil ifTrue:[
        properties := Dictionary new
    ].
    ^properties

    "Modified: / 17-09-2012 / 22:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

properties: aDictionary
    properties := aDictionary

    "Created: / 18-09-2012 / 10:14:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressModel methodsFor:'converting'!

asChange
    ^self subclassResponsibility

    "Created: / 18-09-2012 / 10:17:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asChangeSet
    | cs |

    cs := ChangeSet new.
    self changesInto: cs.
    ^cs.

    "Created: / 18-09-2012 / 10:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressModel methodsFor:'private'!

changesInto: aChangeSet
    self subclassResponsibility

    "Created: / 18-09-2012 / 10:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressModel class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !

