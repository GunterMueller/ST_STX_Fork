"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#ReplaceCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!ReplaceCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^30
! !

!ReplaceCommand methodsFor:'checks'!

checkSourceSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self 
        assert:
            (arg allSatisfy:[:item| item type = self targetSequence first type])
        description:('replacing different node types').

    "Created: / 14-11-2007 / 10:06:41 / janfrog"
    "Modified: / 14-11-2007 / 15:20:01 / janfrog"
!

checkTargetSequence:anXQuerySequence
    self 
        assert: (anXQuerySequence containsSingleNode)
        description:'Target sequence must contain one node (see section 2.3.3.1)'.
    self
        assert: (anXQuerySequence first item isDocumentNode not)
                 description:'Target sequence node must have a parent (see section 2.3.3.1)'.

    "Modified: / 14-11-2007 / 11:58:32 / janfrog"
! !

!ReplaceCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"


       self replaceNode: self targetSequence first  with: self sourceSequence

    "Created: / 14-11-2007 / 10:06:41 / janfrog"
    "Modified: / 14-11-2007 / 16:09:43 / janfrog"
    "Modified: / 12-03-2012 / 15:07:29 / Adam Senk <senkadam@gmail.com>"
! !

!ReplaceCommand methodsFor:'replacing'!

replaceNode:targetNode with:sourceNodes 
    |importedSourceNodes|

    importedSourceNodes := sourceNodes 
                collect:[:sourceNode | sourceNode itemKind isConstructedNode ifTrue:[
                       targetNode documentAdaptor importForeignNode:sourceNode
                        adaptor:sourceNode documentAdaptor
                     ]
                   ifFalse:[sourceNode.].

                ].
    targetNode documentAdaptor updReplaceNode:targetNode 
        with:importedSourceNodes

    "Created: / 14-11-2007 / 10:24:04 / janfrog"
    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 01-05-2012 / 16:56:25 / Adam Senk <senkadam@gmail.com>"
! !

!ReplaceCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
