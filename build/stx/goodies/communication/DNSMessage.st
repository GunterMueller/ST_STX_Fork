"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DNSMessage
	instanceVariableNames:'id flags questions answers authority additional'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!DNSMessage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    no warranty; provided AS-IS
    code ported from squeak
"

    "Created: / 22-11-2006 / 12:48:56 / cg"
! !

!DNSMessage class methodsFor:'instance creation'!

addressByName:hostName 
    ^ self new
        recursionDesired:true;
        addQuestion:(DNSQuery 
                        name:hostName
                        type:ARecord type
                        class:1);
"/        addQuestion:(DNSQuery 
"/                        name:hostName
"/                        type:AAAARecord type
"/                        class:1);
        yourself
!

axfr: domain
	^ self new addQuestion: (DNSQuery name: domain type: 252 class: 1); yourself
!

mailExchangerFor: hostName
    ^ self new recursionDesired: true; addQuestion: (DNSQuery name: hostName type: MXRecord type class: 1); yourself
!

nameServersFor: domain
    ^ self new addQuestion: (DNSQuery name: domain type: NSRecord type class: 1); yourself
!

new
        ^ self basicNew initialize
!

readFrom: aStream
	^ self basicNew readFrom: aStream
!

reverseLookup: address
	^ self new recursionDesired: true; addAnswer: (ARecord new address: address); yourself
! !

!DNSMessage methodsFor:'accessing'!

addAnswer: aDNSRecord
        answers := answers copyWith: aDNSRecord.
        ^ aDNSRecord
!

addQuestion: aDNSQuery
        questions := questions copyWith: aDNSQuery.
        ^ aDNSQuery
!

additional
    ^ additional
!

answers
	^ answers
!

authoritativeAnswer
	^ (flags bitAnd: 2r10000000000) ~= 0
!

authoritativeAnswer: aBoolean
        flags := aBoolean ifTrue: [flags bitOr: 2r10000000000] ifFalse: [flags bitClear: 2r10000000000]
!

authority
    ^ authority
!

beInverseQuery
	self opcode: 1
!

checkResponseCode
        |error|

        self responseCode ~= 0 ifTrue: [
            error := #('Format error' 'Server failure' 'Non existent domain' 'Not implemented' 'Query refused' 'Name exists' 'RRset exists' 'RRset does not exist' 'Not authoritative for zone' 'Zone of record different from zone section') 
                     at: self responseCode ifAbsent:['Undefined response code: ', self responseCode printString].

            NameLookupError raiseRequestErrorString:' - ', error
        ].
!

isInverseQuery
	^ self opcode = 1
!

isQuery
	^ self isResponse not
!

isResponse
	^ (flags bitAnd: 16r8000) ~= 0
!

isStandardQuery
	^ self opcode = 0
!

opcode
	^ (flags bitShift: -11) bitAnd: 2r01111
!

opcode: anInteger
        ^ flags := (flags bitClear: 2r01111) + anInteger
!

questions
	^ questions
!

recursionAvailable: aBoolean
    flags := aBoolean ifTrue: [flags bitOr: 2r10000000] ifFalse: [flags bitClear: 2r10000000]

    "Created: / 17-05-2017 / 17:02:44 / mawalch"
!

recursionAvaliable:aBoolean
    <resource: #obsolete>
    self obsoleteMethodWarning:'Spelling mistake. Use #recursionAvailable.'.
    ^ self recursionAvailable:aBoolean

    "Modified: / 17-05-2017 / 17:06:27 / mawalch"
!

recursionDesired: aBoolean
        flags := aBoolean ifTrue: [flags bitOr: 2r100000000] ifFalse: [flags bitClear: 2r100000000]
!

response: aBoolean
        flags := aBoolean ifTrue: [flags bitOr: 2r1000000000000000] ifFalse: [flags bitClear: 2r1000000000000000]
!

responseCode
	^ flags bitAnd: 2r1111
!

timedOut
        |ans|

        ans := self answers.
        ^ ans isEmpty or:[ans contains: [:any | any timedOut]].
!

truncated: aBoolean
        flags := aBoolean ifTrue: [flags bitOr: 2r1000000000] ifFalse: [flags bitClear: 2r1000000000]
! !

!DNSMessage methodsFor:'initialization'!

initialize
        id := (0 to: 16rFFFF) atRandom.
        flags := 0.
        questions := answers := authority := additional := #()
! !

!DNSMessage methodsFor:'reading/wrinting'!

asByteArray
        | stream |
        stream := #[] writeStream.
        self writeOn: stream.
        ^ stream contents
!

readFrom: aStream
        | questionsCount answersCount authorityCount additionalCount |
        aStream position = 0 ifFalse: [self error: 'the stream should be at position 0 in order to correctly unpack domain names'].
        id := aStream nextNumber: 2.
        flags := aStream nextNumber: 2.
        questionsCount := aStream nextNumber: 2.
        answersCount := aStream nextNumber: 2.
        authorityCount := aStream nextNumber: 2.
        additionalCount := aStream nextNumber: 2.
        questions := (1 to: questionsCount) collect: [:each | DNSQuery readFrom: aStream].
        answers := (1 to: answersCount) collect: [:each | DNSRecord readFrom: aStream].
        authority := (1 to: authorityCount) collect: [:each | DNSRecord readFrom: aStream].
        additional := (1 to: additionalCount) collect: [:each | DNSRecord readFrom: aStream]
!

writeHeaderOn: aStream
	aStream
		nextNumber: 2 put: id;
		nextNumber: 2 put: flags;
		nextNumber: 2 put: questions size;
		nextNumber: 2 put: answers size;
		nextNumber: 2 put: authority size;
		nextNumber: 2 put: additional size
!

writeOn: aStream
	self writeHeaderOn: aStream.
	questions do: [:each | each writeOn: aStream].
	answers do: [:each | each writeOn: aStream].
	authority do: [:each | each writeOn: aStream].
	additional do: [:each | each writeOn: aStream]
! !

!DNSMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSMessage.st,v 1.11 2017-05-17 15:26:56 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/DNSMessage.st,v 1.11 2017-05-17 15:26:56 mawalch Exp $'
! !

