"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDSerializer subclass:#SDBOSSSerializer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Store'
!


!SDBOSSSerializer methodsFor:'actions'!

materializeFromFile: aFile
    ^  (BinaryObjectStorage new onOld:aFile) next.
!

serialize: anObject toFile: aFile
        aFile asFilename writingFileDo:[:s |
            s binary.
            BinaryOutputManager store:anObject on:s.
            s close
        ]
! !

!SDBOSSSerializer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDBOSSSerializer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDBOSSSerializer.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !

