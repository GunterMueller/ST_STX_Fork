"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CryptTests
	instanceVariableNames:''
	classVariableNames:'LibCryptLoaded'
	poolDictionaries:''
	category:'tests-Regression'
!

!CryptTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	exept

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CryptTests class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    LibCryptLoaded := false.

    "Modified: / 03-03-2014 / 12:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CryptTests class methodsFor:'utilities'!

loadLibcryptIfAvailable
    "raise an error: this method should be implemented (TODO)"

    LibCryptLoaded ifFalse:[
	(Smalltalk at: #SHA384Stream) isNil ifTrue:[
	    [
		Smalltalk loadPackage: #'exept:libcrypt'
	    ] on: PackageLoadError do:[:ex |
		"/Libcrypt not not available.
	    ].
	].
	LibCryptLoaded := true.
    ].

    "Created: / 03-03-2014 / 12:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CryptTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    self class loadLibcryptIfAvailable.

    "Modified: / 03-03-2014 / 12:03:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!CryptTests methodsFor:'tests'!

test01_crc32
    |h|

    h := CRC32Stream hashValueOf:''.
    self assert:(h = 0).

    h := CRC32Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = 16r414fa339).

    h := CRC32Stream hashValueOf:'resume'.
    self assert:(h = 16r60C1D0A0).

    h := (CRC32Stream new
		    nextPut:$r;
		    nextPut:$e;
		    nextPut:$s;
		    nextPut:$u;
		    nextPut:$m;
		    nextPut:$e;
		    hashValue).
    self assert:(h = 16r60C1D0A0).

    h := (CRC32Stream hashValueOf:#[1 2 3 4 5 6 7]).
    self assert:(h = 16r70E46888).

    h := (CRC32Stream hashValueOf:#[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
	     16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
	     16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
	     16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF]).
    self assert:(h = 16r8CD04C73).

    h := (CRC32Stream new
		    next:100000 putAll:'12345678901234567890123456789012345678901234567890';
		    hashValue).
    self assert:(h = 16r86D7D79A).

    "
     self run:#test01_crc32
     self new test01_crc32
    "
!

test02_md5
    |h|

    h := MD5Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'d41d8cd98f00b204e9800998ecf8427e')).

    h := MD5Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'9e107d9d372bb6826bd81d3542a419d6')).

    h := MD5Stream hashValueOf:'abc'.
    self assert:(h = #[16r90 16r01 16r50 16r98 16r3C 16rD2 16r4F 16rB0
		       16rD6 16r96 16r3F 16r7D 16r28 16rE1 16r7F 16r72]).

    h := MD5Stream hashValueOf:'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'.
    self assert:(h = #[16r82 16r15 16rEF 16r07 16r96 16rA2 16r0B 16rCA
		       16rAA 16rE1 16r16 16rD3 16r87 16r6C 16r66 16r4A]).

    h := (MD5Stream new
		next:1000000 put:$a;
		hashValue).
    self assert:(h = #[16r77 16r07 16rD6 16rAE 16r4E 16r02 16r7C 16r70
		       16rEE 16rA2 16rA9 16r35 16rC2 16r29 16r6F 16r21]).

    "
     self run:#test02_md5
     self new test02_md5
    "
!

test03_sha1
    |h|

    h := SHA1Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'da39a3ee5e6b4b0d3255bfef95601890afd80709')).

    h := SHA1Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'2fd4e1c67a2d28fced849ee1bb76e7391b93eb12')).

    h := SHA1Stream hashValueOf:#[16r00 16r01 16r02 16r40 16r08 16r10 16r20 16r40 16r80
				  16rFF 16rFE 16rFC 16rF8 16rF0 16rE0 16rC0 16r80].
    self assert:(h = #[146 31 26 53 78 167 121 73 144 117 145 88 50 42 25 52 53 37 177 73]).

    "
     self run:#test03_sha1
     self new test03_sha1
    "

    "Modified: / 25-11-2013 / 11:42:46 / cg"
!

test03b_sha1
    |h|

    h := SHA1Stream hashValueOf:#[48 130 2 149 160 3 2 1 2 2 1 6 48 13 6 9 42 134 72 134 247 13 1 1 5 5 0 48 111 49 25 48 23 6 3 85 4 3 19 16 69 120 101 112 116 32 76 101 118 101 108 32 50 32 67 65 49 11 48 9 6 3 85 4 6 19 2 68 69 49 26 48 24 6 3 85 4 10 19 17 69 120 101 112 116 32 83 111 102 116 119 97 114 101 32 65 71 49 11 48 9 6 3 85 4 11 19 2 67 65 49 28 48 26 6 9 42 134 72 134 247 13 1 9 1 22 13 99 101 114 116 64 101 120 101 112 116 46 100 101 48 30 23 13 48 56 48 52 50 50 50 48 48 48 48 48 90 23 13 49 54 48 54 48 49 49 57 53 57 53 57 90 48 72 49 11 48 9 6 3 85 4 6 19 2 68 69 49 26 48 24 6 3 85 4 10 19 17 69 120 101 112 116 32 83 111 102 116 119 97 114 101 32 65 71 49 29 48 27 6 3 85 4 3 19 20 101 120 112 101 99 99 111 32 99 111 100 101 32 115 105 103 110 105 110 103 48 129 159 48 13 6 9 42 134 72 134 247 13 1 1 1 5 0 3 129 141 0 48 129 137 2 129 129 0 199 150 115 153 147 36 175 136 129 9 92 77 196 254 201 72 55 141 131 27 57 64 226 5 191 35 239 72 236 142 151 98 19 209 37 164 153 24 185 170 82 62 223 250 229 224 59 238 40 73 29 84 83 109 2 188 117 254 37 86 32 136 145 32 255 118 90 26 62 76 137 45 196 88 220 234 231 81 63 165 29 158 212 132 117 227 250 68 249 54 42 54 69 145 185 217 234 66 192 205 240 247 173 215 243 64 30 52 116 19 113 47 189 90 216 64 241 30 193 187 185 219 5 35 231 222 30 183 2 3 1 0 1 163 129 254 48 129 251 48 9 6 3 85 29 19 4 2 48 0 48 29 6 3 85 29 14 4 22 4 20 142 53 132 147 2 27 121 108 9 10 151 194 20 232 134 227 84 160 251 55 48 129 153 6 3 85 29 35 4 129 145 48 129 142 128 20 36 157 29 207 97 136 114 233 22 165 218 37 28 117 161 157 224 230 74 178 161 115 164 113 48 111 49 25 48 23 6 3 85 4 3 19 16 69 120 101 112 116 32 76 101 118 101 108 32 49 32 67 65 49 11 48 9 6 3 85 4 6 19 2 68 69 49 26 48 24 6 3 85 4 10 19 17 69 120 101 112 116 32 83 111 102 116 119 97 114 101 32 65 71 49 11 48 9 6 3 85 4 11 19 2 67 65 49 28 48 26 6 9 42 134 72 134 247 13 1 9 1 22 13 99 101 114 116 64 101 120 101 112 116 46 100 101 130 1 2 48 11 6 3 85 29 15 4 4 3 2 7 128 48 19 6 3 85 29 37 4 12 48 10 6 8 43 6 1 5 5 7 3 3 48 17 6 9 96 134 72 1 134 248 66 1 1 4 4 3 2 4 16].
    self assert:(h = #[152 185 22 239 129 56 192 23 215 67 254 147 139 91 251 28 96 142 185 186]).

    "
     self run:#test03b_sha1
     self new test03b_sha1
    "

    "Created: / 24-01-2014 / 17:47:22 / cg"
!

test04_md2
    |h|

    self
	skipIf:(MD2Stream isBehavior not or:[MD2Stream isLoaded not])
	description:'MD2Stream/libcrypt is not loaded'.

    h := MD2Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'8350e5a3e24c153df2275c9f80692773')).

    h := MD2Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'03d85a0d629d2c442e987525319fc471')).

    "
     self run:#test04_md2
     self new test04_md2
    "
!

test05_md4
    |h|

    self
	skipIf:(MD4Stream isBehavior not or:[MD4Stream isLoaded not])
	description:'MD4Stream/libcrypt is not loaded'.

    h := MD4Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'31d6cfe0d16ae931b73c59d7e0c089c0')).

    h := MD4Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'1bee69a46ba811185c194762abaeae90')).

    "
     self run:#test05_md4
     self new test05_md4
    "
!

test06_sha256
    |h|

    self
	skipIf:(SHA256Stream isBehavior not or:[SHA256Stream isLoaded not])
	description:'SHA256Stream/libcrypt is not loaded'.

    h := SHA256Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855')).

    h := SHA256Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592')).

    "
     self run:#test06_sha256
     self new test06_sha256
    "
!

test07_sha224
    |h|

    self
	skipIf:(SHA224Stream isBehavior not or:[SHA224Stream isLoaded not])
	description:'SHA224Stream/libcrypt is not loaded'.

    h := SHA224Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f')).

    h := SHA224Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525')).

    "
     self run:#test07_sha224
     self new test07_sha224
    "
!

test08_sha384
    |h|

    self
	skipIf:(SHA384Stream isBehavior not or:[SHA384Stream isLoaded not])
	description:'SHA384Stream/libcrypt is not loaded'.

    h := SHA384Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b')).

    h := SHA384Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1')).

    "
     self run:#test08_sha384
     self new test08_sha384
    "
!

test09_sha512
    |h|

    self
	skipIf:(SHA512Stream isBehavior not or:[SHA512Stream isLoaded not])
	description:'SHA512Stream/libcrypt is not loaded'.

    h := SHA512Stream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e')).

    h := SHA512Stream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6')).

    "
     self run:#test09_sha512
     self new test09_sha512
    "
!

test10_des
    |des crypt s s2|

    des := DesCipher new key:#[12 34 56 78 90 12 34 56].
    crypt := des encrypt:'12345678'.
    self assert:(crypt = #[85 205 168 117 136 155 222 239]).

    "/ ------------------------------------------------

    des := DesCipher new key:#[12 34 56 78 90 12 34 56].
    s := '12345678'.
    10 timesRepeat:[
	s2 := ByteArray new:s size.
	des cryptBlock:s from:1 "to:nil" into:s2 startingAt:1 encrypt:true.
	s := s2.
    ].
    self assert:(s = #[212 114 83 160 109 1 37 83]).

    "/ ------------------------------------------------

    des := DesCipher new key:#[16rFF 16r80 56 78 90 12 34 56].
    crypt := des encrypt:'12345678'.
    self assert:(crypt = #[54 60 159 218 32 8 70 60]).


    "
     self run:#test10_des
     self new test10_des
    "

    "Modified: / 25-11-2013 / 11:45:34 / cg"
!

test11_rsaKey
    |dir fn key ks plain cipher|

    dir := Smalltalk packageDirectoryForPackageId:'exept:expecco'.
    self skipIf:dir isNil description:'directory with test key is not present'.
    fn := dir asFilename construct:'license/expeccoKey.pem'.
    self skipIf:fn exists not description:'test key is not present'.

    key := RSASecretCryptKey fromPemStream:fn readStream.

    ks := RSACryptStream new.
    ks encryptWithSecretKey:true.
    ks key:key.
    ks stream:#[] writeStream.

    plain := '12345678901234567890'.
    ks encrypt:plain.
    cipher := ks stream contents.

    ks := RSACryptStream new.
    ks encryptWithSecretKey:true.
    ks key:key.
    ks stream:#[] writeStream.

    ks decrypt:cipher.

    self assert:(ks stream contents asString = plain).

    "/ -------------------------------------------

    ks := RSACryptStream new.
    ks encryptWithSecretKey:true.
    ks key:key.
    ks stream:#[] writeStream.

    plain := #[16rFF 16r80 16r00].
    ks encrypt:plain.
    cipher := ks stream contents.

    ks := RSACryptStream new.
    ks encryptWithSecretKey:true.
    ks key:key.
    ks stream:#[] writeStream.

    ks decrypt:cipher.

    self assert:(ks stream contents = plain).

    "
     self run:#test11_rsaKey
     self new test11_rsaKey
    "

    "Created: / 02-12-2013 / 12:58:19 / cg"
!

test12_whirlpool
    |h|

    self
        skipIf:(WhirlpoolStream isBehavior not or:[WhirlpoolStream isLoaded not])
        description:'WhirlpoolStream/libcrypt is not loaded'.

    "/ hashes taken from wikipedia-page on whirlpool
    
    h := WhirlpoolStream hashValueOf:''.
    self assert:(h = (ByteArray fromHexString:'19FA61D75522A4669B44E39C1D2E1726C530232130D407F89AFEE0964997F7A73E83BE698B288FEBCF88E3E03C4F0757EA8964E59B63D93708B138CC42A66EB3')).

    h := WhirlpoolStream hashValueOf:'The quick brown fox jumps over the lazy dog'.
    self assert:(h = (ByteArray fromHexString:'B97DE512E91E3828B40D2B0FDCE9CEB3C4A71F9BEA8D88E75C4FA854DF36725FD2B52EB6544EDCACD6F8BEDDFEA403CB55AE31F03AD62A5EF54E42EE82C3FB35')).

    h := WhirlpoolStream hashValueOf:'The quick brown fox jumps over the lazy eog'.
    self assert:(h = (ByteArray fromHexString:'C27BA124205F72E6847F3E19834F925CC666D0974167AF915BB462420ED40CC50900D85A1F923219D832357750492D5C143011A76988344C2635E69D06F2D38C')).

    "
     self run:#test12_whirlpool
     self new test12_whirlpool
    "
! !

!CryptTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


CryptTests initialize!
