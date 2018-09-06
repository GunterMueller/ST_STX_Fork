"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

NodeKind subclass:#AccessedNodeKind
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!AccessedNodeKind methodsFor:'testing'!

isAccesedNode
   ^true.

    "Created: / 24-04-2012 / 15:23:52 / Adam Senk <senkadam@gmail.com>"
! !

!AccessedNodeKind methodsFor:'transformations'!

transformNodeIds:nodeIds usingDocumentAdaptor:adaptor
    "Superclass XQuery::SequenceItemKind says that I am responsible to implement this method"
    ^ XQuerySequence withAll: (nodeIds 
        collect:[:nodeId | 
            NodeItem new
                nodeId: nodeId;
                documentAdaptor: adaptor;
                itemKind: self]).

    "Modified: / 05-10-2009 / 16:17:42 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AccessedNodeKind class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
