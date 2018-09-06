"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

InsertCommand subclass:#InsertAsFirstIntoCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!InsertAsFirstIntoCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

   ^20
! !

!InsertAsFirstIntoCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 

    | foundNonAttribute |
    foundNonAttribute := false.
    anXQuerySequence do:
        [:seqItem|
        self 
            assert: ((seqItem type == (TypeFactory getType: 'attribute') and:[foundNonAttribute])) not
            description:'An attribute found after non-attribute (see section 2.3.1.)'.
        foundNonAttribute := (seqItem type == (TypeFactory getType: 'attribute')) not]

    "Modified: / 09-05-2009 / 12:09:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

checkTargetSequence: anXQuerySequence 

    self
        assert: anXQuerySequence containsSingleElement
        description: 'target must be a single element or document node (see section 2.3.1.)'.

    "Modified: / 05-12-2007 / 21:56:03 / janfrog"
! !

!InsertAsFirstIntoCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self sourceSequence
        do:[:node|self insert: node  asFirstInto: self targetSequence first]
! !

!InsertAsFirstIntoCommand methodsFor:'inserting'!

insert:sourceNode asFirstInto:targetNode 
    "|importedSourceNodeId typeOfNode|"

    "importedSourceNodeId := targetNode documentAdaptor 
                importForeignNode:sourceNode.
    typeOfNode := sourceNode type."

    (sourceNode isElementNode) ifTrue:[
        targetNode documentAdaptor updInsert:sourceNode
            asFirstInto:targetNode
    ] ifFalse:[
        targetNode documentAdaptor updInsertAttribute:sourceNode 
            into:targetNode
    ]

    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 09-05-2009 / 12:10:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-04-2012 / 20:37:56 / Adam Senk <senkadam@gmail.com>"
! !

!InsertAsFirstIntoCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
