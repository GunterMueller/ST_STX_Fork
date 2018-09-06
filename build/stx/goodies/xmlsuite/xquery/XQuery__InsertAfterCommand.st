"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

InsertCommand subclass:#InsertAfterCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertAfterCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^20
! !

!InsertAfterCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 

    | foundNonAttribute |
    foundNonAttribute := false.
    anXQuerySequence do:
        [:seqItem|
        self 
            assert: (((seqItem type isSubtypeOf: (TypeFactory getType: 'attribute')) and:[foundNonAttribute])) not
            description:'An attribute found after non-attribute (see section 2.3.1.)'.
        foundNonAttribute := (seqItem type == (TypeFactory getType: 'attribute')) not]

    "Modified: / 05-12-2007 / 21:01:27 / janfrog"
    "Modified: / 09-05-2009 / 12:08:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkTargetSequence: anXQuerySequence 

    self
        assert: (anXQuerySequence containsSingleElement and:[anXQuerySequence first item hasParent ]) 
        description: 'target must be a single element or document node with parent (see section 2.3.1.)'.

    "Modified: / 21-11-2007 / 09:43:55 / janfrog"
! !

!InsertAfterCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self insert: node  after: self targetSequence first]
! !

!InsertAfterCommand methodsFor:'inserting'!

insert:sourceNode after:targetNode 
    "|importedSourceNodeId|"

    "importedSourceNodeId := targetNode documentAdaptor 
                importForeignNode:sourceNode. "

    (sourceNode isElementNode) ifFalse:[
        targetNode documentAdaptor updInsertAttribute:sourceNode
            after:targetNode 
    ] ifTrue:[
        targetNode documentAdaptor updInsert:sourceNode
            after:targetNode 
    ]

    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 09-05-2009 / 12:09:07 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-04-2012 / 23:11:35 / Adam Senk <senkadam@gmail.com>"
! !

!InsertAfterCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
