"
 COPYRIGHT (c) 2001 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication/tests' }"

"{ NameSpace: SunRPC }"

TestCase subclass:#XDRTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-RPC-Tests'
!

!XDRTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    [author:]
	Claus Gittinger
"
! !

!XDRTest methodsFor:'tests'!

test_xdr1
     |packer bytes u val|

     packer := XDRCoder new.

     packer packBool:true.
     self assert:(packer contents size == 4).
     self assert:((packer contents copyLast:4) = #[0 0 0 1] ).

     packer packBool:false.
     self assert:(packer contents size == 8).
     self assert:((packer contents copyLast:4) = #[0 0 0 0] ).

     packer packInt:0.
     self assert:(packer contents size == 12).
     self assert:((packer contents copyLast:4) = #[0 0 0 0] ).

     packer packInt:-1.
     self assert:(packer contents size == 16).
     self assert:((packer contents copyLast:4) = #[255 255 255 255] ).

     packer packInt:1.
     self assert:(packer contents size == 20).
     self assert:((packer contents copyLast:4) = #[0 0 0 1] ).

     packer packInt:16r7FFFFFFF.
     self assert:(packer contents size == 24).
     self assert:((packer contents copyLast:4) = #[16r7F 16rFF 16rFF 16rFF] ).

     packer packInt:-16r80000000.
     self assert:(packer contents size == 28).
     self assert:((packer contents copyLast:4) = #[16r80 16r00 16r00 16r00] ).

     packer packUnsignedInt:16rFFFFFFFF.
     self assert:(packer contents size == 32).
     self assert:((packer contents copyLast:4) = #[16rFF 16rFF 16rFF 16rFF] ).

     packer packUnsignedInt:16r80000000.
     self assert:(packer contents size == 36).
     self assert:((packer contents copyLast:4) = #[16r80 16r00 16r00 16r00] ).

     packer packHyper:0.
     self assert:(packer contents size == 44).
     self assert:((packer contents copyLast:8) = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00] ).

     packer packHyper:-1.
     self assert:(packer contents size == 52).
     self assert:((packer contents copyLast:8) = #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF] ).

     packer packHyper:1.
     self assert:(packer contents size == 60).
     self assert:((packer contents copyLast:8) = #[16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r01] ).

     packer packHyper:16r7FFFFFFFFFFFFFFF.
     self assert:(packer contents size == 68).
     self assert:((packer contents copyLast:8) = #[16r7F 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF] ).

     packer packHyper:-16r8000000000000000.
     self assert:(packer contents size == 76).
     self assert:((packer contents copyLast:8) = #[16r80 16r00 16r00 16r00 16r00 16r00 16r00 16r00] ).

     packer packHyper:16rFFFFFFFFFFFFFFFF.
     self assert:(packer contents size == 84).
     self assert:((packer contents copyLast:8) = #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF] ).

     packer packHyper:16r8000000000000000.
     self assert:(packer contents size == 92).
     self assert:((packer contents copyLast:8) = #[16r80 16r00 16r00 16r00 16r00 16r00 16r00 16r00] ).

     packer
	    packString:'';
	    packString:'a';
	    packString:'ab';
	    packString:'abc';
	    packString:'abcd';
	    packString:'abcde';
	    packEnum:#CALL;
	    packArray:#() using:#packInt:;
	    packArray:#(1 2 3 4 5 6) using:#packInt:;
	    packList:#() using:#packInt:;
	    packList:#(1 2 3 4 5 6) using:#packInt:;
	    packArray:#('1' '2' '3' '4' '5' '6') using:#packString:;
	    packList:#('1' '2' '3' '4' '5' '6') using:#packString:.
     bytes := packer contents.

     u := XDRCoder from:bytes.

     self assert:( ((val := u unpackBool) == true ) ).
     self assert:( ((val := u unpackBool) == false ) ).
     self assert:( ((val := u unpackInt) == 0 ) ).
     self assert:( ((val := u unpackInt) == -1 ) ).
     self assert:( ((val := u unpackInt) == 1 ) ).
     self assert:( ((val := u unpackInt) = 16r7FFFFFFF ) ).
     self assert:( ((val := u unpackInt) = -16r80000000 ) ).
     self assert:( ((val := u unpackUnsignedInt) = 16rFFFFFFFF ) ).
     self assert:( ((val := u unpackUnsignedInt) = 16r80000000 ) ).
     self assert:( ((val := u unpackHyper) == 0 ) ).
     self assert:( ((val := u unpackHyper) == -1 ) ).
     self assert:( ((val := u unpackHyper) == 1 ) ).
     self assert:( ((val := u unpackHyper) = 16r7FFFFFFFFFFFFFFF ) ).
     self assert:( ((val := u unpackHyper) = -16r8000000000000000 ) ).
     self assert:( ((val := u unpackUnsignedHyper) = 16rFFFFFFFFFFFFFFFF ) ).
     self assert:( ((val := u unpackUnsignedHyper) = 16r8000000000000000 ) ).
     self assert:( ((val := u unpackString) = '' ) ).
     self assert:( ((val := u unpackString) = 'a' ) ).
     self assert:( ((val := u unpackString) = 'ab' ) ).
     self assert:( ((val := u unpackString) = 'abc' ) ).
     self assert:( ((val := u unpackString) = 'abcd' ) ).
     self assert:( ((val := u unpackString) = 'abcde' ) ).
     self assert:( ((val := u unpackUint) = RPCDefinitions CALL ) ).
     self assert:( ((val := (u unpackArrayUsing:#unpackInt)) = #() ) ).
     self assert:( ((val := (u unpackArrayUsing:#unpackInt)) = #(1 2 3 4 5 6) ) ).
     self assert:( ((val := (u unpackListUsing:#unpackInt)) = #() ) ).
     self assert:( ((val := (u unpackListUsing:#unpackInt)) = #(1 2 3 4 5 6) ) ).
     self assert:( ((val := (u unpackArrayUsing:#unpackString)) = #('1' '2' '3' '4' '5' '6') ) ).
     self assert:( ((val := (u unpackListUsing:#unpackString)) = #('1' '2' '3' '4' '5' '6') ) ).

    "
      self basicNew test_xdr1
    "
! !

!XDRTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/SunRPC_XDRTest.st,v 1.2 2016-05-02 15:41:11 cg Exp $'
! !
