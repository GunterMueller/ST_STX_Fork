"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDSerializer subclass:#SDSmartRefStreamSerializer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Store'
!


!SDSmartRefStreamSerializer methodsFor:'actions'!

materializeFromFile: aFile
	^ SmartRefStream readOnlyFileNamed: aFile do: [ :file | file sandstoneNextAndClose ]
!

serialize: anObject toFile: aFile
	SmartRefStream
		newFileNamed: aFile
		do: [ :file | 
			file
				sandstoneNextPutObjOnly: anObject;
				flush ]
! !

!SDSmartRefStreamSerializer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDSmartRefStreamSerializer.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDSmartRefStreamSerializer.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

