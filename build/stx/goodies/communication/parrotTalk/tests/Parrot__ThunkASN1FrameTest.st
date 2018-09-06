"{ Package: 'stx:goodies/communication/parrotTalk/tests' }"

"{ NameSpace: Parrot }"

TestCase subclass:#ThunkASN1FrameTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-test'
!

ThunkASN1FrameTest comment:''
!


!ThunkASN1FrameTest methodsFor:'as yet unclassified'!

buildSamplePublicKey

	^ RSAPublicKey exponent: 65537 modulo: 14631611540685054051246828779474659279434795828979877100056741326852574061485199294988121017044511058150957383138883396176340034247939747961936993875787199951904902675151337040861984020136174965691597035416377590189950405767507320112179317911200971768673589874672666315699001559759593359858088499188421132948034888617685711165611182732555992037146239346746996434870589494285479881652847671542092722577703150166494760601888755745838507254088117517198055561562279008065104487719450273397328134480627880994280654832384199334978656423699129788360180335222193654848544660576393761816982999928331982769311793235220487698201.
!

printIAmEncodedBytes

	| encodedBytes encodedBytesString |
	encodedBytes := #[0 0 0 73 0 0 1 44 169 130 1 32 12 10 49 50 51 52 53 54 55 56 57 48 12 5 104 101 108 108 111 48 130 1 9 2 130 1 0 115 231 153 187 59 135 204 18 127 9 12 71 230 103 111 173 138 207 196 239 59 28 52 143 84 156 199 153 38 6 5 171 95 32 86 226 220 15 113 75 219 7 231 107 127 151 131 167 61 47 254 81 15 154 249 130 72 109 9 238 96 163 166 246 177 27 120 235 164 185 46 195 118 137 64 96 5 6 114 135 40 130 212 7 122 117 210 245 75 11 96 124 58 251 42 195 125 250 206 101 83 61 31 144 103 79 70 23 254 144 145 119 235 187 244 164 75 53 41 191 97 154 47 86 87 143 193 82 134 68 40 131 148 65 211 9 229 16 199 95 202 97 244 139 199 219 4 86 230 164 243 111 16 251 29 137 99 165 234 109 174 141 111 81 12 112 71 153 220 88 216 180 91 87 57 250 118 102 81 139 159 242 4 84 100 13 226 171 231 153 218 77 157 61 170 119 222 28 84 110 202 214 175 135 243 39 174 31 126 223 39 44 249 194 187 127 53 122 124 55 25 222 42 224 98 135 168 13 109 202 167 18 37 6 204 211 46 102 48 10 3 145 189 10 200 145 85 137 192 109 245 178 155 155 119 25 2 3 1 0 1].
	encodedBytesString := ''.
	encodedBytes
		do: [:e | encodedBytesString := encodedBytesString, e]
		separatedBy: [encodedBytesString := encodedBytesString, ', '].
	Transcript cr; cr; cr; show: encodedBytesString; cr; cr; cr.
!

testGiveInfo

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 81 0 0 1 44 170 130 1 32 12 10 49 50 51 52 53 54 55 56 57 48 12 5 104 101 108 108 111 48 130 1 9 2 130 1 0 115 231 153 187 59 135 204 18 127 9 12 71 230 103 111 173 138 207 196 239 59 28 52 143 84 156 199 153 38 6 5 171 95 32 86 226 220 15 113 75 219 7 231 107 127 151 131 167 61 47 254 81 15 154 249 130 72 109 9 238 96 163 166 246 177 27 120 235 164 185 46 195 118 137 64 96 5 6 114 135 40 130 212 7 122 117 210 245 75 11 96 124 58 251 42 195 125 250 206 101 83 61 31 144 103 79 70 23 254 144 145 119 235 187 244 164 75 53 41 191 97 154 47 86 87 143 193 82 134 68 40 131 148 65 211 9 229 16 199 95 202 97 244 139 199 219 4 86 230 164 243 111 16 251 29 137 99 165 234 109 174 141 111 81 12 112 71 153 220 88 216 180 91 87 57 250 118 102 81 139 159 242 4 84 100 13 226 171 231 153 218 77 157 61 170 119 222 28 84 110 202 214 175 135 243 39 174 31 126 223 39 44 249 194 187 127 53 122 124 55 25 222 42 224 98 135 168 13 109 202 167 18 37 6 204 211 46 102 48 10 3 145 189 10 200 145 85 137 192 109 245 178 155 155 119 25 2 3 1 0 1].
	hdr := GiveInfo new.
	hdr vatId: '1234567890'.
	hdr domain: 'hello'.
	hdr publicKey: self buildSamplePublicKey.
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 10).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 300).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header vatId = newFrame header vatId).
	self assert: (frame header domain = newFrame header domain).
	self assert: (frame header publicKey exponent = newFrame header publicKey exponent).
	self assert: (frame header publicKey modulo = newFrame header publicKey modulo).
!

testGo

	| hdr frame bytes newFrame encodedBytes dhParm |
	encodedBytes := #[0 0 0 97 0 0 2 17 172 130 2 5 12 5 104 101 108 108 111 12 5 119 111 114 108 100 4 129 240 90 86 168 229 173 75 79 80 74 246 246 97 100 221 231 135 39 213 12 29 163 29 20 233 45 51 184 124 113 106 249 85 153 177 90 16 245 252 39 61 46 172 115 1 46 155 68 17 5 169 219 135 183 16 13 95 209 227 76 205 192 180 194 153 135 27 77 171 91 243 110 168 216 16 42 203 140 242 197 31 167 146 175 73 165 153 89 68 47 108 99 29 34 48 77 189 9 68 254 43 56 67 232 93 122 186 185 56 140 77 223 198 159 5 119 192 106 6 100 69 234 37 92 123 195 113 136 69 19 26 246 236 35 110 21 204 206 76 88 172 211 186 68 180 171 229 5 142 245 74 78 217 210 164 255 63 15 5 246 157 63 38 69 241 201 56 44 146 139 42 10 66 128 90 0 71 23 151 28 53 113 89 129 39 193 131 180 33 31 14 187 160 43 114 236 66 220 200 154 189 79 201 64 106 16 76 249 80 69 128 3 181 198 117 212 109 162 44 132 42 125 239 102 210 169 189 186 83 184 45 230 91 166 49 230 10 128 65 113 232 4 130 1 0 76 209 101 125 140 49 25 147 148 94 117 219 200 210 180 196 123 80 204 245 169 240 247 156 22 145 152 110 1 157 63 145 230 33 167 104 59 17 138 185 62 111 194 252 215 245 24 59 146 210 19 129 173 88 95 205 214 212 82 101 123 119 233 45 190 99 43 93 79 242 23 100 79 5 223 146 61 98 61 114 227 26 2 221 234 202 18 78 41 102 93 63 139 178 221 102 77 53 25 94 9 130 253 11 141 209 59 184 187 150 0 186 227 102 89 9 143 15 22 2 231 85 66 57 249 221 113 160 73 84 152 93 100 46 120 176 157 34 208 100 96 194 14 90 104 228 172 220 9 19 159 194 152 170 240 68 125 233 17 113 36 5 216 35 91 53 35 145 218 171 112 251 27 22 121 207 31 82 23 97 176 217 132 37 119 124 1 19 60 2 123 212 71 64 41 144 66 138 112 13 173 12 251 28 57 208 100 214 223 248 228 116 241 121 164 35 30 101 179 159 88 155 86 112 219 68 213 116 170 126 225 91 100 200 223 28 160 4 88 58 165 16 129 252 216 229 150 74 34 169 162 86 172 70 63 185].
	dhParm := #[90 86 168 229 173 75 79 80 74 246 246 97 100 221 231 135 39 213 12 29 163 29 20 233 45 51 184 124 113 106 249 85 153 177 90 16 245 252 39 61 46 172 115 1 46 155 68 17 5 169 219 135 183 16 13 95 209 227 76 205 192 180 194 153 135 27 77 171 91 243 110 168 216 16 42 203 140 242 197 31 167 146 175 73 165 153 89 68 47 108 99 29 34 48 77 189 9 68 254 43 56 67 232 93 122 186 185 56 140 77 223 198 159 5 119 192 106 6 100 69 234 37 92 123 195 113 136 69 19 26 246 236 35 110 21 204 206 76 88 172 211 186 68 180 171 229 5 142 245 74 78 217 210 164 255 63 15 5 246 157 63 38 69 241 201 56 44 146 139 42 10 66 128 90 0 71 23 151 28 53 113 89 129 39 193 131 180 33 31 14 187 160 43 114 236 66 220 200 154 189 79 201 64 106 16 76 249 80 69 128 3 181 198 117 212 109 162 44 132 42 125 239 102 210 169 189 186 83 184 45 230 91 166 49 230 10 128 65 113 232].
	hdr := Go new.
	hdr cryptoProtocol: 'hello'.
	hdr dataEncoder: 'world'.
	hdr diffieHellmanParameter: dhParm.
	hdr signature: (SessionIdentity sampleVatId1 signMessage: dhParm).
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 12).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 529).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: encodedBytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header cryptoProtocol = newFrame header cryptoProtocol).
	self assert: (frame header dataEncoder = newFrame header dataEncoder).
	self assert: (frame header diffieHellmanParameter = newFrame header diffieHellmanParameter).
	self assert: (frame header signature = newFrame header signature).
!

testGoToo

	| hdr frame bytes newFrame encodedBytes dhParm |
	encodedBytes := #[0 0 0 105 0 0 2 17 173 130 2 5 12 5 104 101 108 108 111 12 5 119 111 114 108 100 4 129 240 90 86 168 229 173 75 79 80 74 246 246 97 100 221 231 135 39 213 12 29 163 29 20 233 45 51 184 124 113 106 249 85 153 177 90 16 245 252 39 61 46 172 115 1 46 155 68 17 5 169 219 135 183 16 13 95 209 227 76 205 192 180 194 153 135 27 77 171 91 243 110 168 216 16 42 203 140 242 197 31 167 146 175 73 165 153 89 68 47 108 99 29 34 48 77 189 9 68 254 43 56 67 232 93 122 186 185 56 140 77 223 198 159 5 119 192 106 6 100 69 234 37 92 123 195 113 136 69 19 26 246 236 35 110 21 204 206 76 88 172 211 186 68 180 171 229 5 142 245 74 78 217 210 164 255 63 15 5 246 157 63 38 69 241 201 56 44 146 139 42 10 66 128 90 0 71 23 151 28 53 113 89 129 39 193 131 180 33 31 14 187 160 43 114 236 66 220 200 154 189 79 201 64 106 16 76 249 80 69 128 3 181 198 117 212 109 162 44 132 42 125 239 102 210 169 189 186 83 184 45 230 91 166 49 230 10 128 65 113 232 4 130 1 0 76 209 101 125 140 49 25 147 148 94 117 219 200 210 180 196 123 80 204 245 169 240 247 156 22 145 152 110 1 157 63 145 230 33 167 104 59 17 138 185 62 111 194 252 215 245 24 59 146 210 19 129 173 88 95 205 214 212 82 101 123 119 233 45 190 99 43 93 79 242 23 100 79 5 223 146 61 98 61 114 227 26 2 221 234 202 18 78 41 102 93 63 139 178 221 102 77 53 25 94 9 130 253 11 141 209 59 184 187 150 0 186 227 102 89 9 143 15 22 2 231 85 66 57 249 221 113 160 73 84 152 93 100 46 120 176 157 34 208 100 96 194 14 90 104 228 172 220 9 19 159 194 152 170 240 68 125 233 17 113 36 5 216 35 91 53 35 145 218 171 112 251 27 22 121 207 31 82 23 97 176 217 132 37 119 124 1 19 60 2 123 212 71 64 41 144 66 138 112 13 173 12 251 28 57 208 100 214 223 248 228 116 241 121 164 35 30 101 179 159 88 155 86 112 219 68 213 116 170 126 225 91 100 200 223 28 160 4 88 58 165 16 129 252 216 229 150 74 34 169 162 86 172 70 63 185].
	dhParm := #[90 86 168 229 173 75 79 80 74 246 246 97 100 221 231 135 39 213 12 29 163 29 20 233 45 51 184 124 113 106 249 85 153 177 90 16 245 252 39 61 46 172 115 1 46 155 68 17 5 169 219 135 183 16 13 95 209 227 76 205 192 180 194 153 135 27 77 171 91 243 110 168 216 16 42 203 140 242 197 31 167 146 175 73 165 153 89 68 47 108 99 29 34 48 77 189 9 68 254 43 56 67 232 93 122 186 185 56 140 77 223 198 159 5 119 192 106 6 100 69 234 37 92 123 195 113 136 69 19 26 246 236 35 110 21 204 206 76 88 172 211 186 68 180 171 229 5 142 245 74 78 217 210 164 255 63 15 5 246 157 63 38 69 241 201 56 44 146 139 42 10 66 128 90 0 71 23 151 28 53 113 89 129 39 193 131 180 33 31 14 187 160 43 114 236 66 220 200 154 189 79 201 64 106 16 76 249 80 69 128 3 181 198 117 212 109 162 44 132 42 125 239 102 210 169 189 186 83 184 45 230 91 166 49 230 10 128 65 113 232].
	hdr := GoToo new.
	hdr cryptoProtocol: 'hello'.
	hdr dataEncoder: 'world'.
	hdr diffieHellmanParameter: dhParm.
	hdr signature: (SessionIdentity sampleVatId1 signMessage: dhParm).
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 13).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 529).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: encodedBytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header cryptoProtocol = newFrame header cryptoProtocol).
	self assert: (frame header dataEncoder = newFrame header dataEncoder).
	self assert: (frame header diffieHellmanParameter = newFrame header diffieHellmanParameter).
	self assert: (frame header signature = newFrame header signature).
!

testIAm

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 73 0 0 1 44 169 130 1 32 12 10 49 50 51 52 53 54 55 56 57 48 12 5 104 101 108 108 111 48 130 1 9 2 130 1 0 115 231 153 187 59 135 204 18 127 9 12 71 230 103 111 173 138 207 196 239 59 28 52 143 84 156 199 153 38 6 5 171 95 32 86 226 220 15 113 75 219 7 231 107 127 151 131 167 61 47 254 81 15 154 249 130 72 109 9 238 96 163 166 246 177 27 120 235 164 185 46 195 118 137 64 96 5 6 114 135 40 130 212 7 122 117 210 245 75 11 96 124 58 251 42 195 125 250 206 101 83 61 31 144 103 79 70 23 254 144 145 119 235 187 244 164 75 53 41 191 97 154 47 86 87 143 193 82 134 68 40 131 148 65 211 9 229 16 199 95 202 97 244 139 199 219 4 86 230 164 243 111 16 251 29 137 99 165 234 109 174 141 111 81 12 112 71 153 220 88 216 180 91 87 57 250 118 102 81 139 159 242 4 84 100 13 226 171 231 153 218 77 157 61 170 119 222 28 84 110 202 214 175 135 243 39 174 31 126 223 39 44 249 194 187 127 53 122 124 55 25 222 42 224 98 135 168 13 109 202 167 18 37 6 204 211 46 102 48 10 3 145 189 10 200 145 85 137 192 109 245 178 155 155 119 25 2 3 1 0 1].
	hdr := IAm new.
	hdr vatId: '1234567890'.
	hdr domain: 'hello'.
	hdr publicKey: self buildSamplePublicKey.
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 9).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 300).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header vatId = newFrame header vatId).
	self assert: (frame header domain = newFrame header domain).
	self assert: (frame header publicKey exponent = newFrame header publicKey exponent).
	self assert: (frame header publicKey modulo = newFrame header publicKey modulo).
!

testIWant

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 65 0 0 0 29 168 19 12 10 49 50 51 52 53 54 55 56 57 48 12 5 104 101 108 108 111].
	hdr := IWant new.
	hdr vatId: '1234567890'.
	hdr domain: 'hello'.
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 8).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 29).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header vatId = newFrame header vatId).
	self assert: (frame header domain = newFrame header domain).
!

testProtocolAccepted

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 25 0 0 0 21 163 11 12 9 87 104 105 115 112 101 114 45 49].
	hdr := ProtocolAccepted new.
	hdr accepted: 'Whisper-1'.
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 3).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 21).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header accepted = newFrame header accepted).
!

testProtocolOffered

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 9 0 0 0 32 161 22 12 9 87 104 105 115 112 101 114 45 49 12 9 87 104 105 115 112 101 114 45 49].
	hdr := ProtocolOffered new.
	hdr offered: 'Whisper-1'.
	hdr preferred: 'Whisper-1'.
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 1).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 32).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header offered = newFrame header offered).
	self assert: (frame header preferred = newFrame header preferred).
!

testReplyInfo

	| hdr frame bytes newFrame encodedBytes |
	encodedBytes := #[0 0 0 89 0 0 0 31 171 21 48 8 12 6 65 69 83 101 100 101 48 9 12 7 97 115 110 49 100 101 114].
	hdr := ReplyInfo new.
	hdr cryptoProtocols: (OrderedCollection with: 'AESede').
	hdr dataEncoders: (OrderedCollection with: 'asn1der').
	frame := hdr asFrame.
	bytes := frame asByteArray.
"	Transcript cr; cr; show: bytes printString."
	self assert: (frame tags == 0).
	self assert: (frame multicast == 0).
	self assert: (frame frameVersion == 1).
	self assert: (frame priority == 0).
	self assert: (frame headerType == 11).
	self assert: (frame hash == 0).
	self assert: (frame messageSize == 31).

	self assert: (bytes = encodedBytes).

	newFrame := Frame readFrom: bytes readStream.
	self assert: (frame header class = newFrame header class).
	self assert: (frame header cryptoProtocols = newFrame header cryptoProtocols).
	self assert: (frame header dataEncoders = newFrame header dataEncoders).
! !

!ThunkASN1FrameTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkASN1FrameTest.st,v 1.1 2018-05-14 00:20:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__ThunkASN1FrameTest.st,v 1.1 2018-05-14 00:20:20 cg Exp $'
! !

