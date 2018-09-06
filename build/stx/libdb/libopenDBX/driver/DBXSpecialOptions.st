"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXSpecialOptions
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-API'
!


!DBXSpecialOptions class methodsFor:'options'!

compression
	"0x0022 in hexadecimal in openDBX. But we need it as decimal"
	^16r0022
!

encryption
	 "0x0010 in hexadecimal in openDBX. But we need it as decimal"
	^16r0010
!

multipleStatements
	 "0x0020 in hexadecimal in openDBX. But we need it as decimal"
	^16r0020
!

pagedResults
 	"0x0021 in hexadecimal in openDBX. But we need it as decimal"
	^16r0021
!

specialModes
	"0x0023 in hexadecimal in openDBX. But we need it as decimal"
	^16r0023
! !

!DBXSpecialOptions class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXSpecialOptions.st,v 1.2 2013-04-15 13:10:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXSpecialOptions.st,v 1.2 2013-04-15 13:10:57 cg Exp $'
! !

