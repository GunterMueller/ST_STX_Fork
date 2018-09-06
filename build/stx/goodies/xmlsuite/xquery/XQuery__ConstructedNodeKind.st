"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

NodeKind subclass:#ConstructedNodeKind
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!ConstructedNodeKind class methodsFor:'accessing'!

documentAdaptor

    ^ ConstructedNodeXDMAdaptor instance.

    "Modified: / 07-10-2009 / 11:14:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 11:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConstructedNodeKind methodsFor:'private'!

hybridKind
    ^ HybridNodeKind instance.

    "Created: / 03-10-2009 / 23:12:05 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:30:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isHybrid: nodeId
    " return true if the nodeId is hybrid "
    ^ self hybridKind isHybrid: nodeId.

    "Created: / 03-10-2009 / 22:58:09 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 11:50:39 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeKind methodsFor:'testing'!

isConstructedNode
   ^true.

    "Created: / 24-04-2012 / 15:24:48 / Adam Senk <senkadam@gmail.com>"
! !

!ConstructedNodeKind methodsFor:'transformations'!

transformNodeIds:nodeIds usingDocumentAdaptor:adaptor
    "Superclass XQuery::SequenceItemKind says that I am responsible to implement this method"

    ^ XQuerySequence withAll: (nodeIds 
        collect:[:nodeId | 
            | kind |
            self assert: (nodeId class = XQueryConstructedItem).

            (self isHybrid: nodeId) ifTrue: [ 
                kind := self hybridKind. 
            ] ifFalse: [
                kind := self.
            ].
            NodeItem new
                nodeId: nodeId;
                documentAdaptor: adaptor;
                itemKind: kind.
        ])

    "Modified: / 05-10-2009 / 16:18:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeKind class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
