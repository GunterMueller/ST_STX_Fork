"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

HierarchicalItem subclass:#MCVersionEntry
	instanceVariableNames:'name package repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCVersionEntry class methodsFor:'instance creation'!

name: name repository: repository

    ^self new
        name: name;
        repository: repository

    "Created: / 16-09-2010 / 18:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionEntry methodsFor:'accessing'!

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

package
    ^ package
!

package:something
    package := something.
!

repository
    ^ repository
!

repository:something
    repository := something.
!

versionNumber

    | versionNumberString |
    versionNumberString := self name select:[:e|e isDigit].
    ^versionNumberString isNilOrEmptyCollection
        ifTrue:[nil]
        ifFalse:[versionNumberString asNumber]

    "Created: / 13-10-2010 / 15:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versions

    ^#()

    "Created: / 16-09-2010 / 18:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionEntry methodsFor:'converting'!

asMCVersion

    ^repository loadVersionFromFileNamed: name

    "Created: / 17-09-2010 / 15:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionEntry methodsFor:'printing & storing'!

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

!MCVersionEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

