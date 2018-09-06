"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

InsertCommand subclass:#InsertBeforeCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertBeforeCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^20
! !

!InsertBeforeCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 

    | foundNonAttribute |
    foundNonAttribute := false.
    anXQuerySequence do:
        [:seqItem|
        self 
            assert: ((seqItem type == (TypeFactory getType: 'attribute') and:[foundNonAttribute])) not
            description:'An attribute found after non-attribute (see section 2.3.1.)'.
        foundNonAttribute := (seqItem type == (TypeFactory getType: 'attribute')) not]

    "Modified: / 21-11-2007 / 11:23:52 / janfrog"
    "Modified: / 09-05-2009 / 12:10:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkTargetSequence: anXQuerySequence 

    self
        assert: (anXQuerySequence containsSingleElement and:[anXQuerySequence first item hasParent ]) 
        description: 'target must be a single element or document node with parent (see section 2.3.1.)'.

    "Modified: / 21-11-2007 / 11:24:16 / janfrog"
! !

!InsertBeforeCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self insert: node  before: self targetSequence first]

    "Created: / 21-11-2007 / 11:22:58 / janfrog"
! !

!InsertBeforeCommand methodsFor:'inserting'!

insert:sourceNode before:targetNode 
    "|importedSourceNodeId|

    importedSourceNodeId := targetNode documentAdaptor 
                importForeignNode:sourceNode."
    (sourceNode isElementNode) ifFalse:[
        targetNode documentAdaptor updInsertAttribute:sourceNode 
            into:targetNode 
    ] ifTrue:[
        targetNode documentAdaptor updInsert:sourceNode
            before:targetNode 
    ]

    "Created: / 21-11-2007 / 11:27:30 / janfrog"
    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 09-05-2009 / 12:11:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-04-2012 / 20:37:46 / Adam Senk <senkadam@gmail.com>"
! !

!InsertBeforeCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
