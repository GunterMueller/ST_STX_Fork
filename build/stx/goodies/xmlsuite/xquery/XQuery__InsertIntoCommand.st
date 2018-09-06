"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

InsertCommand subclass:#InsertIntoCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertIntoCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

   ^10
! !

!InsertIntoCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 

    | foundNonAttribute |
    foundNonAttribute := false.
    anXQuerySequence do:
        [:seqItem|
        self 
            assert: ((seqItem type == (TypeFactory getType: 'attribute') and:[foundNonAttribute])) not
            description:'An attribute found after non-attribute (see section 2.3.1.)'.
        foundNonAttribute := (seqItem type == (TypeFactory getType: 'attribute')) not]

    "Modified: / 21-11-2007 / 11:25:04 / janfrog"
    "Modified: / 09-05-2009 / 12:11:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkTargetSequence: anXQuerySequence 

    self
        assert: anXQuerySequence containsSingleElement
        description: 'target must be a single element or document node (see section 2.3.1.)'.

    "Modified: / 05-12-2007 / 21:55:39 / janfrog"
! !

!InsertIntoCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self insert: node  into: self targetSequence first]

    "Created: / 21-11-2007 / 11:23:12 / janfrog"
! !

!InsertIntoCommand methodsFor:'inserting'!

insert:sourceNode into:targetNode 
    "importedSourceNodeId := targetNode documentAdaptor 
                importForeignNode:sourceNode."
    (sourceNode isElementNode) ifTrue:[
        targetNode documentAdaptor updInsert:sourceNode 
            into:targetNode 
    ] ifFalse:[
        targetNode documentAdaptor updInsertAttribute:sourceNode 
            into:targetNode
    ]

    "Created: / 21-11-2007 / 11:29:01 / janfrog"
    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 09-05-2009 / 12:11:34 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-04-2012 / 20:38:07 / Adam Senk <senkadam@gmail.com>"
! !

!InsertIntoCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
