"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIBuffer subclass:#OCIRawBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCIRawBuffer class methodsFor:'queries'!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_BIN' 
! !

!OCIRawBuffer methodsFor:'decoding'!

at:index
    "decode the contents of the buffer"

    |len startIndex|

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    len := self alenAt:index.
    (nElements == 1 and:[buffer isByteArray]) ifTrue:[ |sz buf|
	sz := buffer size.
	sz == len ifTrue:[
	    buf := buffer.
	    buffer := buffer copyEmpty:sz.
	    ^ buf.
	].
    ].
    startIndex := ((index-1)*maxElementLen)+1.
    ^ (ByteArray new:len) replaceFrom:1 to:len with:buffer startingAt:startIndex.

    "
      |buf|

      buf := self new.
      buf at:1 put:#[1 2 3 4 5 6 7].
      buf at:1
    "
! !

!OCIRawBuffer methodsFor:'encoding'!

visitByteArray:bytes with:index

    |len startIndex|

    len := bytes size.
    self alenAt:index put:len.
    startIndex := maxElementLen*(index-1)+1.
    buffer replaceBytesFrom:startIndex to:startIndex+len-1 with:bytes startingAt:1.

    "
      |buf|

      buf := self new.
      buf at:1 put:#[1 2 3 4 5 6 7]
    "
! !

!OCIRawBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIRawBuffer.st,v 1.5 2004-06-11 21:56:26 stefan Exp $'
! !
