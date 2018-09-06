"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#ReplaceValueOfCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!ReplaceValueOfCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^10
! !

!ReplaceValueOfCommand methodsFor:'checks'!

checkSourceSequence:anXQuerySequence 


    self
        assert: anXQuerySequence containsSingleTextOrAtomicValue
        description: 'target must be a single text node (see section 2.3.3.2.)'.

    "Modified: / 21-11-2007 / 12:23:15 / janfrog"
!

checkTargetSequence:anXQuerySequence
    self 
        assert: (anXQuerySequence containsSingleNode)
        description:'Target sequence must contain one node (see section 2.3.3.2)'.

    "Modified: / 14-11-2007 / 11:31:24 / janfrog"
! !

!ReplaceValueOfCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self replaceValueOf: self targetSequence first  with: self sourceSequence first.

    "Created: / 14-11-2007 / 10:55:16 / janfrog"
    "Modified: / 14-11-2007 / 14:00:40 / janfrog"
! !

!ReplaceValueOfCommand methodsFor:'replacing'!

replaceValueOf:referenceNode with:newValueNode 
    |importedNewValueNodeId|

    importedNewValueNodeId := referenceNode documentAdaptor 
                importForeignNode:newValueNode "nodeId"
                "adaptor:newValueNode documentAdaptor".
    referenceNode documentAdaptor updReplaceValueOf:referenceNode 
        with:importedNewValueNodeId

    "Modified: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 07-02-2012 / 18:53:26 / Adam Senk <senkadam@gmail.com>"
! !

!ReplaceValueOfCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
