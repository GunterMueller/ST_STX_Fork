"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

HierarchicalItem subclass:#MCPackageEntry
	instanceVariableNames:'name repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCPackageEntry class methodsFor:'instance creation'!

name: name repository: repository

    ^self new
        name: name;
        repository: repository

    "Created: / 16-09-2010 / 18:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCPackageEntry methodsFor:'accessing'!

label

    ^name

    "Created: / 16-09-2010 / 18:59:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

name:something
    name := something.
!

repository
    ^ repository
!

repository:something
    repository := something.
!

versions

    | versions |

    versions := repository allFileNames select:[:n|n startsWith: name].
    versions := versions asSortedCollection asOrderedCollection reverse.
    versions := versions collect:[:vername|(MCVersionEntry name: vername repository: repository) package: self name; yourself].
    ^versions

    "Modified: / 09-11-2010 / 13:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCPackageEntry methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    self class name printOn:aStream.
    aStream space.
    aStream nextPutAll:'name: '.
    name printOn:aStream.
    aStream space.
    aStream nextPutAll:'repository: '.
    repository printOn:aStream.

    "Modified: / 16-09-2010 / 18:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCPackageEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

