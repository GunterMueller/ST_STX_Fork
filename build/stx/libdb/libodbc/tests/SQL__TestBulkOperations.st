"{ Package: 'stx:libdb/libodbc/tests' }"

"{ NameSpace: SQL }"

TestCase subclass:#TestBulkOperations
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-ODBC-Tests'
!


!TestBulkOperations methodsFor:'tests'!

test
|storageAndInfo rows storage fieldCTypes fieldSizes fieldOffsets numBytesPerRow|

rows := #(
		    ( 'aaaa' 1000.0 'AAA' )
		    ( 'bbbb' 2000.0 'BBB' )
		    ( 'cccc' 3000.0 'CCC' )
		    ( 'dddd' 4000.0 'DDD' )
		    ( 'eeee' 5000.0 'EEE' )
		).

storageAndInfo :=
     self
	buildStructFor:
		#(
			( SQL_C_CHAR    12 )
			( SQL_C_DOUBLE  )
			( SQL_C_CHAR    5 )
		)
	values:rows.
storage := storageAndInfo at:1.
fieldOffsets := storageAndInfo at:2.
fieldSizes := storageAndInfo at:3.
fieldCTypes := storageAndInfo at:4.
numBytesPerRow := storageAndInfo at:5.
^ self
   testBulkInsert:storage
   numRows:rows size
   rowStorageSize:numBytesPerRow
   types:fieldCTypes asArray
   sizes:fieldSizes asArray
   offsets:fieldOffsets asArray
! !

!TestBulkOperations class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/tests/SQL__TestBulkOperations.st,v 1.1 2009-08-07 13:56:24 cg Exp $'
! !
