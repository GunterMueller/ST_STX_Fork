"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#XSDateTime
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSDateTime class methodsFor:'accessing'!

typename

    ^'dateTime'

    "Created: / 13-05-2005 / 13:48:16 / masca"
! !

!XSDateTime methodsFor:'instance creation'!

createObjectFromString: aString

    | ts |
    [
        "ts := Timestamp readIso8601MobileFormatFrom: aString"
        ts := Timestamp readIso8601FormatFrom: aString
    ] on:Error do:[:ex|
        DataConversionError raiseErrorString:ex errorString
    ].
    ^ts

    "Created: / 13-05-2005 / 13:48:16 / masca"
    "Modified: / 13-05-2005 / 16:00:33 / masca"
!

createStringFromObject: aTimestamp

    | s |
    s := (String new:15) writeStream.

    s
        nextPutAll:(aTimestamp year printStringRadix:10 size:4 fill:$0) ;
        nextPut:$-;
        nextPutAll:(aTimestamp month printStringRadix:10 size:2 fill:$0) ;
        nextPut:$-;
        nextPutAll:(aTimestamp day printStringRadix:10 size:2 fill:$0) ;
        nextPut:$T;
        nextPutAll:(aTimestamp hour printStringRadix:10 size:2 fill:$0) ;
        nextPut:$:;
        nextPutAll:(aTimestamp minute printStringRadix:10 size:2 fill:$0) ;
        nextPut:$:;
        nextPutAll:(aTimestamp second printStringRadix:10 size:2 fill:$0).

    ^s contents



    "1995-02-20T13:11:06"

    "Created: / 13-05-2005 / 13:48:16 / masca"
    "Modified: / 13-05-2005 / 16:03:06 / masca"
! !

!XSDateTime class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSDateTime.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
