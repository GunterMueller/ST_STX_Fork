"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

Object subclass:#ParrotPercentEncoder
	instanceVariableNames:'safeSet'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ParrotPercentEncoder comment:'I am ZnPercentEncoder.I implement RFC 3986 percent encoding and decoding.All characters that are not part of a safe set are encoded using a percent (%) followed by a two digit hexadecimal number of a byte value. Non-ASCII characters are first encoded, normally using UTF-8.My #encode: and #decode: messages work from String to String.My decoder additionally will accept + as an encoding for a space.See also http://en.wikipedia.org/wiki/Percent-encodingPart of Zinc HTTP Components'
!


!ParrotPercentEncoder class methodsFor:'as yet unclassified'!

decode: string

	^ self new decode: string
!

encode: string

	^ self new encode: string
! !

!ParrotPercentEncoder methodsFor:'accessing'!

safeSet
	"Return the safe set of characters that I will not encode, as a byte array.
	If not set, I will default to the most commonly used safe set"
	
	^ safeSet ifNil: [ safeSet := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~' asByteArray ]
! !

!ParrotPercentEncoder methodsFor:'converting'!

decode: string
	"Decode a percent encoded string and return the resulting byte array.
	After percent decoding I will use my character encoder to convert byte values to characters."

	| bytes stringStream |
	stringStream := string readStream.
	bytes := ByteArray streamContents: [ :byteStream | self decode: stringStream to: byteStream ].
	^ ASN1UTF8StringType new decodeValueWithDERStream: bytes readStream length: bytes size.
!

decode: stringStream to: byteStream
	| char |
	[ stringStream atEnd ]
		whileFalse: [ 
			(char := stringStream next) == $+
				ifTrue: [ byteStream nextPut: 32 ]
				ifFalse: [ 
					char == $%
						ifTrue: [ byteStream nextPut: (self readHexFrom: stringStream) ]
						ifFalse: [ 
							char charCode < 128
								ifTrue: [ byteStream nextPut: char charCode ]
								ifFalse: [ Error signal: 'ASCII character expected' ] ] ] ]
!

encode: string
	"Encode string using percent encoding and return the resulting string.
	I will use my character encoder to convert string to bytes and then
	percent encode all byte values that are not in my safe set."

	^ String streamContents: [ :stream | self encode: string readStream to: stream ]
!

encode: readStream to: writeStream
	| bytes buffer byte |
	buffer := (bytes := ByteArray new: 4) writeStream.
	self safeSet.
	[ readStream atEnd ]
		whileFalse: [
			buffer reset.
			ASN1UTF8StringType new encodeValue: readStream next asString withDERStream: buffer.
			1 to: buffer position do: [ :index | 
				(safeSet includes: (byte := bytes at: index))
					ifTrue: [ writeStream nextPut: byte asCharacter ]
					ifFalse: [ 
						writeStream nextPut: $%.
						byte printOn: writeStream base: 16 length: 2 padded: true ] ] ]
! !

!ParrotPercentEncoder methodsFor:'private'!

readHexFrom: stream
	| first second |
	(stream atEnd not and: [(first := stream next digitValue) between: 0 and: 15])
		ifFalse: [ Error signal: 'hex digit expected' ].
	(stream atEnd not and: [ (second := stream next digitValue) between: 0 and: 15 ])
		ifFalse: [ Error signal: 'hex digit expected' ].
	^ (first << 4) + second
! !

!ParrotPercentEncoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ParrotPercentEncoder.st,v 1.1 2018-05-14 00:17:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ParrotPercentEncoder.st,v 1.1 2018-05-14 00:17:58 cg Exp $'
! !

