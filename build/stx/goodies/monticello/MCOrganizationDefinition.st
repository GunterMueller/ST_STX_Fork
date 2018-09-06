"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCOrganizationDefinition
	instanceVariableNames:'categories'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCOrganizationDefinition class methodsFor:'as yet unclassified'!

categories: anArray
	^ self instanceLike: (self new categories: anArray)
! !

!MCOrganizationDefinition methodsFor:'accessing'!

categories
	^ categories
!

categories: aCollection
        categories := aCollection asArray

    "Modified: / 15-09-2010 / 14:16:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
	^ Array with: #organization with: self commonPrefix
!

source
	^ String streamContents:
		[:s |
		categories do: [:ea | s nextPutAll: ea] separatedBy: [s cr]]
! !

!MCOrganizationDefinition methodsFor:'as yet unclassified'!

commonPrefix
	| stream |
	categories isEmpty ifTrue: [^ ''].
	
	stream := String new writeStream.
	categories first withIndexDo:
		[:c :i|
		categories do:
			[:ea |
			(ea at: i ifAbsent: []) = c ifFalse: [^ stream contents]].
		stream nextPut: c].
	^ stream contents
!

reorderCategories: allCategories original: oldCategories
        | first |
        ^allCategories
        "
        first := allCategories detect: [:ea | categories includes: ea] ifNone: [^ allCategories].
        ^       ((allCategories copyUpTo: first) copyWithoutAll: oldCategories, categories),
                categories,
                ((allCategories copyAfter: first) copyWithoutAll: oldCategories, categories)
        "

    "Modified: / 11-09-2010 / 18:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCOrganizationDefinition methodsFor:'comparing'!

= aDefinition
	^ (super = aDefinition)
		and: [categories = aDefinition categories]
!

sortKey
	^ '<organization>'
! !

!MCOrganizationDefinition methodsFor:'converting'!

asChange

    ^OtherChange new
        mcDefinition: self;
        source: ('" Organization: %1 "' bindWith: categories printString)

    "Created: / 13-10-2010 / 17:20:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-11-2010 / 17:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCOrganizationDefinition methodsFor:'installing'!

postloadOver: oldDefinition
	SystemOrganization categories:
		(self
			reorderCategories: SystemOrganization categories
			original: (oldDefinition ifNil: [#()] ifNotNil: [oldDefinition categories]))
! !

!MCOrganizationDefinition methodsFor:'printing'!

summary
	^ categories asArray printString
! !

!MCOrganizationDefinition methodsFor:'testing'!

isOrganizationDefinition
	^ true
! !

!MCOrganizationDefinition methodsFor:'visiting'!

accept: aVisitor
	^ aVisitor visitOrganizationDefinition: self
! !

!MCOrganizationDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCOrganizationDefinition.st,v 1.5 2013-01-18 13:02:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCOrganizationDefinition.st,v 1.5 2013-01-18 13:02:33 cg Exp $'
!

version_SVN
    ^ '§Id: MCOrganizationDefinition.st 24 2010-11-09 14:00:17Z vranyj1 §'
! !

