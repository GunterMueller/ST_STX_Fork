"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

InsertCommand subclass:#InsertAsLastIntoCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertAsLastIntoCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^20
! !

!InsertAsLastIntoCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 

    | foundNonAttribute |
    foundNonAttribute := false.
    anXQuerySequence do:
        [:seqItem|
        self 
            assert: ((seqItem type == (TypeFactory getType: 'attribute') and:[foundNonAttribute])) not
            description:'An attribute found after non-attribute (see section 2.3.1.)'.
        foundNonAttribute := (seqItem type == (TypeFactory getType: 'attribute')) not]

    "Modified: / 21-11-2007 / 11:24:56 / janfrog"
    "Modified: / 09-05-2009 / 12:10:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkTargetSequence: anXQuerySequence 

    self
        assert: anXQuerySequence containsSingleElement
        description: 'target must be a single element or document node (see section 2.3.1.)'.

    "Modified: / 05-12-2007 / 21:56:19 / janfrog"
! !

!InsertAsLastIntoCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self insert: node asLastInto: self targetSequence first]

    "Created: / 21-11-2007 / 11:22:31 / janfrog"
! !

!InsertAsLastIntoCommand methodsFor:'inserting'!

insert:sourceNode asLastInto:targetNode 
    "|importedSourceNodeId|

    importedSourceNodeId := targetNode documentAdaptor 
                importForeignNode:sourceNode."
    (sourceNode isElementNode) ifTrue:[
        targetNode documentAdaptor updInsert:sourceNode 
            asLastInto:targetNode
    ] ifFalse:[
        targetNode documentAdaptor updInsertAttribute:sourceNode
            into:targetNode
    ]

    "Created: / 21-11-2007 / 11:28:21 / janfrog"
    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 09-05-2009 / 12:10:34 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-04-2012 / 20:37:38 / Adam Senk <senkadam@gmail.com>"
! !

!InsertAsLastIntoCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
