"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCStXSnapshotTransformation subclass:#MCStXSnapshotPostReadTransformation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X Storing'
!

!MCStXSnapshotPostReadTransformation class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!MCStXSnapshotPostReadTransformation methodsFor:'visiting'!

visitMethodDefinition: definition
    | source |

    source := definition source asStringWithNativeLineEndings.  "/ Make sure source has native line endings
    source := self class reindentUsingTabsAndSpaces: source.    "/ Make sure there are tabs and spaces used for indentation
                                                                "/ (as it is norm on Smalltalk/X)
    source := source asSingleByteStringIfPossible.              "/ Convert to single byte string

    definition source: source.

    "Created: / 24-04-2015 / 16:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotPostReadTransformation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXSnapshotPostReadTransformation.st,v 1.1 2013-05-29 11:47:15 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXSnapshotPostReadTransformation.st,v 1.1 2013-05-29 11:47:15 vrany Exp $'
! !

