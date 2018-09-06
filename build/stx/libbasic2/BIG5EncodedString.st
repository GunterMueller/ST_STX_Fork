"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

TwoByteString variableWordSubclass:#BIG5EncodedString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!BIG5EncodedString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    OBSOLETE
        this class will vanish - its functionality has been replaced
        by the UnicodeString classes.

    BIG5EncodedString represents 16bit strings encoded in BIG-5.
    BIG-5 is a popular hanzi code used in Taiwan.

    [author:]
        Claus Gittinger

    [see also:]
        Unicode16String
        GBEncodedString JISEncodedString 
        TwoByteString String CharacterArray
        StringCollection
"
! !

!BIG5EncodedString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords)

    "
     BIG5EncodedString initialize
    "

    "Created: 27.4.1996 / 13:12:30 / cg"
! !

!BIG5EncodedString class methodsFor:'code tables'!

romanTable
    "return a table to decode from roman ascii to 16 bit BIG5.
     This is experimental - possibly unfinished or incorrect"

    ^ #(    "   "   "excla"         " # "   " $ "   " % "   " & "   " ' "
          16ra1bc 16ra149 16ra1b2 16ra1ad 16ra243 16ra248 16ra1ae 16ra1ac 
            " ( "   " ) "   " * "   " + "   " , "   " - "   " . "   " / "
          16ra15d 16ra15e 16ra1ce 16ra1cf 16ra14d 16ra1df 16ra14f 16ra1fe
            " 0 "   " 1 "   " 2 "   " 3 "   " 4 "   " 5 "   " 6 "   " 7 "
          16ra2af 16ra2b0 16ra2b1 16ra2b2 16ra2b3 16ra2b4 16ra2b5 16ra2b6
            " 8 "   " 9 "   " : "   " ; "   " < "   " = "   " > "   " ? "
          16ra2b7 16ra2b8 16ra152 16ra151 16ra1e0 16ra1e2 16ra1e1 16ra148 
            " @ "   " A "   " B "   " C "   " D "   " E "   " F "   " G "
          16ra249 16ra2cf 16ra2d0 16ra2d1 16ra2d2 16ra2d3 16ra2d4 16ra2d5 
            " H "   " I "   " J "   " K "   " L "   " M "   " N "   " O "
          16ra2d6 16ra2d7 16ra2d8 16ra2d9 16ra2da 16ra2db 16ra2dc 16ra2dd 
            " P "   " Q "   " R "   " S "   " T "   " U "   " V "   " W "
          16ra2de 16ra2df 16ra2e0 16ra2e1 16ra2e2 16ra2e3 16ra2e4 16ra2e5 
            " X "   " Y "   " Z "   " [ "   " \ "   " ] "   " ^ "   " _ "
          16ra2e6 16ra2e7 16ra2e8 16ra169 16ra242 16ra16a 16ra173 16ra15a
            " ` "   " a "   " b "   " c "   " d "   " e "   " f "   " g "
          16ra1ab 16ra2e9 16ra2ea 16ra2eb 16ra2ec 16ra2ed 16ra2ee 16ra2ef 
            " h "   " i "   " j "   " k "   " l "   " m "   " n "   " o "
          16ra2f0 16ra2f1 16ra2f2 16ra2f3 16ra2f4 16ra2f5 16ra2f6 16ra2f7 
            " p "   " q "   " r "   " s "   " t "   " u "   " v "   " w "
          16ra2f8 16ra2f9 16ra2fa 16ra2fb 16ra2fc 16ra2fd 16ra2fe 16ra340 
            " x "   " y "   " z "   " { "   " | "   " } "  " ~ "
          16ra341 16ra342 16ra343 16ra161 16ra157 16ra162 16ra1e3 16ra1bd

"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
"/          16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 16ra1bc 
        ).

    "Created: 30.6.1997 / 14:26:26 / cg"
    "Modified: 30.6.1997 / 18:22:30 / cg"
! !

!BIG5EncodedString methodsFor:'queries'!

encoding
    "return the strings encoding as a symbol. 
     Here, the constant symbol #big5 is returned."

    ^ #big5

    "Created: 17.4.1996 / 15:41:15 / cg"
    "Modified: 27.4.1996 / 13:23:01 / cg"
! !

!BIG5EncodedString class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


BIG5EncodedString initialize!
