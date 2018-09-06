"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#RenameCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!RenameCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    ^10
! !

!RenameCommand methodsFor:'checks'!

checkSourceSequence: anXQuerySequence

    self 
        assert: anXQuerySequence containsSingleString
        description:'Sequence must contain excatly one item with type QNAME (see section 2.3.4)'
!

checkTargetSequence: anXQuerySequence 

    self 
        assert: (anXQuerySequence containsSingleElement or:[anXQuerySequence containsSingleAttribute])
        description:'Only elements or attributes can be renamed (see section 2.3.4)'.
! !

!RenameCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self renameNode: self targetSequence first  to: self sourceSequence first

    "Modified: / 18-04-2010 / 22:18:00 / Martin Hevera <>"
! !

!RenameCommand methodsFor:'renaming'!

renameNode: node to: name

    node documentAdaptor
       updRename: node nodeId to: name nodeId

    "Modified: / 05-02-2012 / 18:47:27 / Adam Senk <senkadam@gmail.com>"
! !

!RenameCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
