"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#ClassSorter
	instanceVariableNames:'indents order'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ClassSorter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ClassSorter class methodsFor:'sorting'!

sort: classes

    ^self new sort: classes

    "Created: / 21-01-2008 / 19:40:19 / janfrog"
! !

!ClassSorter methodsFor:'filtering'!

sort: classes
        "Sort nodes according to their position in the class hierarchy"

        | supersChain |
        self initializeResults.
        classes do: 
                [:class | 
                supersChain := class  withAllSuperclasses reversed.
                supersChain removeAllSuchThat: [:cl | (classes includes: cl) not].
                order add: supersChain "contents" -> class].
        self buildIndentIndex.
        ^self collectSortedClasses

    "Modified: / 21-01-2008 / 19:43:24 / janfrog"
! !

!ClassSorter methodsFor:'private'!

buildIndentIndex
	indents := IdentityDictionary new.
	order do: [:assoc | indents at: assoc value put: assoc key size - 1].
!

collectSortedClasses
        ^order asArray collect: [:assoc | assoc value]

    "Created: / 21-01-2008 / 19:41:54 / janfrog"
!

initializeResults
	| i chain2 chain1 result max |
	order := SortedCollection sortBlock: 
					[:assoc1 :assoc2 | 
					result := nil.
					chain1 := assoc1 key.
					chain2 := assoc2 key.
					max := chain1 size min: chain2 size.
					i := 1.
					[result isNil and: [i <= max]] whileTrue: 
							[(chain1 at: i) = (chain2 at: i) 
								ifTrue: [i := i + 1]
								ifFalse: [result := (chain1 at: i) name < (chain2 at: i) name]].
					result isNil ifTrue: [chain1 size < chain2 size] ifFalse: [result]]
! !

!ClassSorter class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__ClassSorter.st,v 1.1 2011/07/01 13:28:45 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ClassSorter.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

