"{ Package: 'stx:goodies/monticello' }"

HierarchicalItem subclass:#MCRepositoryEntry
	instanceVariableNames:'repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCRepositoryEntry class methodsFor:'instance creation'!

repository:arg
    "Create & return a new instance for arg."

    ^ self new repository:arg

    "Modified: / 16-09-2010 / 18:40:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryEntry methodsFor:'accessing'!

label

    ^self repository displayString

    "Created: / 16-09-2010 / 18:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packages

    "Returns a collection of package entries (MCPackageEntry)"

    ^repository allPackageNames collect:
        [:name|MCPackageEntry name: name repository: repository]

    "Created: / 16-09-2010 / 18:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    ^ repository
!

repository:something
    repository := something.
! !

!MCRepositoryEntry methodsFor:'displaying'!

displayString

    ^repository displayString

    "Created: / 16-09-2010 / 18:41:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryEntry.st,v 1.3 2012-09-11 21:28:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryEntry.st,v 1.3 2012-09-11 21:28:22 cg Exp $'
!

version_SVN
    ^ '§Id: MCRepositoryEntry.st 14 2010-09-17 14:16:41Z vranyj1 §'
! !
