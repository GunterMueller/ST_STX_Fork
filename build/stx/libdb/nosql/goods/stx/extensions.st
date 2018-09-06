"{ Package: 'stx:libdb/nosql/goods/stx' }"!

!Stream methodsFor:'*GOODSPlatformStx'!

uint16
    ^ self nextUnsignedShortMSB:true
! !

!Stream methodsFor:'*GOODSPlatformStx'!

uint16:intVal
    self nextPutShort:intVal MSB:true.
! !

!Stream methodsFor:'*GOODSPlatformStx'!

uint32
    ^ self nextUnsignedLongMSB:true
! !

!Stream methodsFor:'*GOODSPlatformStx'!

uint32:intVal
    self nextPutLong:intVal MSB:true.
! !

!stx_libdb_nosql_goods_stx class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx/extensions.st,v 1.4 2013-03-28 11:32:05 cg Exp $'
! !
