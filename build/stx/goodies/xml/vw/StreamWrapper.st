"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Link subclass:#StreamWrapper
	instanceVariableNames:'stream isInternal protocol name usedAsExternal entity cr lf line
		column'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

StreamWrapper comment:'This class is used by the XMLParser to wrap both internal and external streams with proper encoding before handing them to the parser for processing

Instance Variables:
	stream                  <EncodedStream>  stream being wrapped
	isInternal              <Boolean>  true if the stream is internal and hencer doesn''t need careful line-end treatment
	protocol                        <String>  name of stream type, ''internal'' or ''file''
	name                    <String | nil>  the name of the stream, if it is named
	usedAsExternal  <Boolean>  flag used to override protocol and say how stream is being used?
	entity                  <Entity | nil>  if wrapping on behalf of an Entity this is it?
	cr                              <Character>  cache of Character cr
	lf                              <Character>  cache of Character lf
'
!


!StreamWrapper class methodsFor:'instance creation'!

emptyWithExtraSpace: space

	^self stream: (space ifTrue: ['  '] ifFalse: ['']) readStream
		protocol: 'internal'
		name: nil
		entity: nil
!

stream: str protocol: key name: value entity: entity

	^self new stream: str protocol: key name: value entity: entity
! !

!StreamWrapper methodsFor:'accessing'!

characterSize:aCharacter 
    "return the number of bytes required to encode aCharacter"

    |s|

    s := self stream.
    ^ s isEncodedStream 
        ifTrue:[ s encoder characterSize:aCharacter ]
        ifFalse:[ 1 ]
!

checkEncoding

        | encoding |
        Smalltalk isSmalltalkX ifTrue:[^ #null].

        encoding := [stream encoding] on: Error do: [:ex | ex returnWith: #null].
        encoding = #UTF_8
                ifTrue:
                        [| c1 c2 pos |
                        pos := stream position.
                        stream setBinary: true.
                        c1 := stream next.
                        c2 := stream next.
                        stream setBinary: false.
                        (c2 notNil and: [c1 * c2 = 16rFD02])
                                ifTrue: [stream encoder: (UTF16StreamEncoder new
                                                                        forByte1: c1 byte2: c2)]
                                ifFalse: [stream position: pos]]

    "Modified: / 27-08-2007 / 15:44:48 / cg"
!

close

	stream close
!

column
    ^ column
!

column:something
    column := something.
!

entity

	^entity
!

line
    ^ line
!

line:something
    line := something.
!

name
        | streamName |

        name ~~ nil ifTrue: [^name].
        stream isExternalStream ifFalse: [^nil].
        (Smalltalk isSmalltalkX) ifTrue:[
            streamName := stream pathName.
        ] ifFalse:[
            streamName := [stream name] on: Error do: [:ex| ex returnWith: nil].
        ].
        streamName ~~ nil ifTrue: [streamName replaceAll: Filename separator with: $/].
        ^streamName
!

protocol

	^protocol
!

stream

	^stream
! !

!StreamWrapper methodsFor:'declaration'!

encodingDeclIn: aParser

        | enc |
        ^stream peek = $e
                ifTrue:
                    [
                        | encoding |

                        self mustFind: 'encoding' errorOn: aParser.
                        self skipSpaceIn: aParser.
                        self mustFind: '=' errorOn: aParser.
                        self skipSpaceIn: aParser.
                        encoding := self quotedString.
                        aParser validateEncoding: encoding.
                        
                        Smalltalk isSmalltalkX ifTrue:[
                            "/ seemed to be work until now (done elsewhere?)
                            "/ if needed, try:
false ifTrue:[
                            stream := EncodedStream 
                                        stream:stream 
                                        encoder:(CharacterEncoder 
                                                    encoderFor:encoding asSymbol 
                                                    ifAbsent:[
                                                        Logger warning:('XML::StreamWrapper: no decoder for ' , encoding).
                                                        "proceed using inStream without decoder"
                                        ]).
].
                        ] ifFalse:[
                            "/ this is visualworks code...
                            ((stream respondsTo: #encoding)
                            and: [stream encoding asLowercase ~= (XMLParser mapEncoding: encoding) asLowercase])
                            ifTrue:[
                                enc := (StreamEncoder new:(XMLParser mapEncoding: encoding) asSymbol)
                                        initializeForFiles.
                                stream encoder: enc
                            ].
                        ].                
                        true
                    ]
                ifFalse: [false]

    "Modified: / 09-11-2017 / 07:50:03 / cg"
!

expected: string

	XMLParser malformed: string, ' expected, but not found'
!

mustFind: str errorOn: aParser

	(self skipIf: str)
		ifFalse: [aParser expected: str].
!

quotedString

	(stream peekFor: $")
		ifTrue: [^(stream upTo: $") asString].
	(stream peekFor: $')
		ifTrue: [^(stream upTo: $') asString].
	self expected: 'quoted string'
!

sdDeclIn: aParser

	^stream peek = $s
		ifTrue:
			[| word |
			self mustFind: 'standalone' errorOn: aParser.
			self skipSpaceIn: aParser.
			self mustFind: '=' errorOn: aParser.
			self skipSpaceIn: aParser.
			word := self quotedString.
			(#('yes' 'no') includes: word)
				ifFalse: [aParser expected: 'yes or no'].
			true]
		ifFalse: [false]
!

skipIf: str

	| p |
	p := stream position.
	1 to: str size do: [:i |
		(stream peekFor: (str at: i))
			ifFalse:
				[stream position: p.
				^false]].
	^true
!

skipSpaceIn: aParser
    | p gotSpace |

    gotSpace := false.
    [
        |nextChar|

        p := stream position.
        nextChar := self nextFor:aParser.
        nextChar notNil
        and:[ #(9 10 13 32) includes: nextChar codePoint ]
    ] whileTrue:[gotSpace := true].
    stream position: p.
    ^ gotSpace
!

textDeclIn: aParser

	self checkEncoding.
	^(self skipIf: '<?xml')
		ifTrue:
			[| hasSpace |
			hasSpace := self skipSpaceIn: aParser.
			hasSpace
				ifTrue: [(self versionInfoIn: aParser) == nil
					ifFalse: [hasSpace := self skipSpaceIn: aParser]].
			hasSpace
				ifTrue: [(self encodingDeclIn: aParser)
					ifFalse: [self expected: 'encoding']]
				ifFalse: [(self encodingDeclIn: aParser)
					ifTrue: [self expected: 'white space']].
			self skipSpaceIn: aParser.
			self mustFind: '?>' errorOn: aParser.
			true]
		ifFalse: [false]
!

versionInfoIn: aParser

	| version |
	^stream peek = $v
		ifTrue:
			[self mustFind: 'version' errorOn: aParser.
			self skipSpaceIn: aParser.
			self mustFind: '=' errorOn: aParser.
			self skipSpaceIn: aParser.
			version := self quotedString.
			version = '1.0' ifFalse: [self expected: 'version 1.0'].
			version]
		ifFalse: [nil]
!

xmlDeclIn: aParser

        self checkEncoding.
        ^(self skipIf: '<?xml')
                ifTrue:
                        [| hasSpace version |
                        (self skipSpaceIn: aParser)
                                ifTrue: [version := self versionInfoIn: aParser]
                                ifFalse: [version := nil].
                        version = nil ifTrue: [self expected: 'xml version'].
                        aParser documentNode xmlVersion: version.
                        hasSpace := self skipSpaceIn: aParser.
                        hasSpace
                                ifTrue: [(self encodingDeclIn: aParser)
                                        ifTrue: [hasSpace := self skipSpaceIn: aParser]]
                                ifFalse: [(self encodingDeclIn: aParser)
                                        ifTrue: [self expected: 'white space']].
                        hasSpace
                                ifTrue: [(self sdDeclIn: aParser)
                                        ifTrue: [hasSpace := self skipSpaceIn: aParser]]
                                ifFalse: [(self sdDeclIn: aParser)
                                        ifTrue: [self expected: 'white space']].
                        self mustFind: '?>' errorOn: aParser.
                        true]
                ifFalse: [false]
! !

!StreamWrapper methodsFor:'initialization'!

stream: str protocol: key name: value entity: ent

        stream := str.
        isInternal := key = 'internal'.
        protocol := key.
        name := value.
        entity := ent.
        (Smalltalk isSmalltalkX) ifTrue:[
            cr := Character return
        ] ifFalse:[
            cr := Character cr.
        ].
        lf := Character lf.
        line := 1.
        column := 0.
!

usedAsExternal

	^usedAsExternal
!

usedAsExternal: aBoolean

	usedAsExternal := aBoolean
! !

!StreamWrapper methodsFor:'private'!

error: aStringOrMessage

	^XMLSignal raiseErrorString: aStringOrMessage asString
! !

!StreamWrapper methodsFor:'streaming'!

nextFor:aParser 
    |ch ascii position|

    ch := stream nextOrNil.
    ch isNil ifTrue:[
        ^ nil
    ].
    ascii := ch codePoint.

    "to speed up things, do a quick check for
     common characters"

    ascii >= 16r20 ifTrue:[
        ascii <= 16rFF ifTrue:[
            ^ ch
        ].
    ] ifFalse:[
        isInternal ifFalse:[
            column := column+1.
            ch == cr ifTrue:[
                column := 0.
                line := line+1.
                stream peekFor:lf.          "Windows/MAC: line end is CR LF"
                ^ aParser eol
            ] ifFalse:[
                ch == lf ifTrue:[
                    column := 0.
                    line := line+1.
                    ^ aParser eol
                ]
            ]
        ].
    ].
    (aParser isIllegalCharacter:ascii) ifTrue:[
        isInternal ifTrue:[
            position := 'char position %1' bindWith:stream position.
        ] ifFalse:[
            position := 'line %1 col %2' bindWith:line with:column.
        ].
        aParser 
            notPermitted:'a character with Unicode value: ' , ascii printString, ' at: ', position
    ].
    ^ ch
!

skip: n

	stream skip: n
! !

!StreamWrapper methodsFor:'testing'!

atEnd

	^stream atEnd
! !

!StreamWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/StreamWrapper.st,v 1.29 2017-11-09 08:56:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/StreamWrapper.st,v 1.29 2017-11-09 08:56:19 cg Exp $'
! !

