"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#XMLParser
	instanceVariableNames:'sourceStack hereChar lastSource currentSource documentNode dtd
		unresolvedIDREFs builder validating ignore eol isEncodeChecking
		isTreeBuilding normalizeDtd normalizeAttributes encoding'
	classVariableNames:'PredefinedEntities DefaultNormalizeAttributes'
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

XMLParser comment:'This class represents the main XML processor in the system. This  XMLParser may be used as a validating or non-validating parser to scan and process an XML document and provide access to it''s content and structure to a smalltalk application. This XMLParser tries to follow the guidelines laid out in the W3C XML Version 1.0 Recommendation, plus the XML Namespaces Recommendation.

Instance Variables:
	sourceStack     <XML.StreamWrapper>  stack of input streams that handles inclusion.
	hereChar        <Character>  the current character being parsed
	lastSource      <XML.StreamWrapper>  record of previous source used to check correct nesting
	currentSource   <XML.StreamWrapper>  current input stream (the top of sourceStack)
	documentNode    <XML.Document>  the document created by parsing
	dtd     <XML.DocumentType>  the document type definition for the current document
	unresolvedIDREFs        <Collection>  collection of IDREfs that have yet to be resolved; used for validation
	builder <XML.NodeBuilder>  node builder
	validating      <Boolean>  if true then the parse validates the XML
	ignore  <Boolean>  ?
	eol     <Character>  the end-of-line character in the source stream
'
!

!XMLParser class methodsFor:'documentation'!

examples
"
    XML::XMLParser
	processDocumentStream:'<HalloWelt />' readStream
	beforeScanDo:[:parser |
	    parser
		validate:false
	].

    XML::XMLParser
	processDocumentStream:'<Hallo_Welt />' readStream
	beforeScanDo:[:parser |
	    parser
		validate:false
	].

    Fails (invalid character):

    XML::XMLParser
	processDocumentStream:'<Hallo$Welt />' readStream
	beforeScanDo:[:parser |
	    parser
		validate:false
	].
"
! !

!XMLParser class methodsFor:'instance creation'!

new
    self == XMLParser ifTrue:[
	^ self concreteClass new
    ].
    ^ self basicNew initialize
!

on:aStream
    ^self new on:aStream
!

on:aStream protocol:protocolString name:name
    ^self new
	on:aStream
	protocol:protocolString
	name:name
!

parse:aStringOrStream
    "parse the xml in aStringOrStream;
     return a DOM-tree"

    ^self
        processDocumentStream:aStringOrStream readStream
        beforeScanDo:
            [:p |
            p isEncodeChecking:false.
            p validate:false.]
!

parseDtdAsPatterns:aStringOrStream
    "parse a document type from aStringOrStream.
     Do not normalize the DTD patterns, so they can be used for type construction.
     Answer a XML::DocumentType."

    |p|

    p := self on:aStringOrStream readStream.
    p validate:false; normalizeDtd:false.
    p parseDtd .
    ^ p dtd.
!

parseDtdString:aStringOrStream
    "parse a dtd from a aStringOrStream"

    |p|

    p := self on:aStringOrStream readStream.
    p validate:false.
    p parseDtd.
    ^ p dtd.
!

processDocumentInFilename:aFilename
    ^self processDocumentInFilename:aFilename beforeScanDo:[:parser | ]
!

processDocumentInFilename:aFilename beforeScanDo:aBlock
    |stream rslt|

    stream := (aFilename asFilename withEncoding:#'UTF_8') readStream.
    [
	stream lineEndTransparent.
	rslt := self processDocumentStream:stream beforeScanDo:aBlock.
    ] ensure:[stream close].
    ^ rslt
!

processDocumentStream:aStream
    ^self processDocumentStream:aStream beforeScanDo:[:parser | ]
!

processDocumentStream:aStream beforeScanDo:aBlock
    |p|

    p := self on:aStream.
    aBlock value:p.
    ^ p scanDocument.
!

processDocumentString:aString
    ^self processDocumentString:aString beforeScanDo:[:parser | ]
!

processDocumentString:aString beforeScanDo:aBlock
    ^self processDocumentStream:aString readStream beforeScanDo:aBlock
! !

!XMLParser class methodsFor:'attribute processing'!

isValidName: aTag

        aTag size = 0 ifTrue: [^false].
        (self isValidNameStart: aTag first)
                ifFalse: [^false].
        2 to: aTag size do: [:i |
                (self isValidNameChar: (aTag at: i))
                        ifFalse: [^false]].
        ^true
!

isValidNmToken: aTag

        aTag size = 0 ifTrue: [^false].
        1 to: aTag size do: [:i |
                (self isValidNameChar: (aTag at: i))
                        ifFalse: [^false]].
        ^true
! !

!XMLParser class methodsFor:'class initialization'!

initialize
	"XMLParser initialize"

	PredefinedEntities := Dictionary new
		at: #amp  put: (GeneralEntity new name:#amp;  text:'&#38;');
		at: #lt   put: (GeneralEntity new name:#lt;   text:'&#60;');
		at: #gt   put: (GeneralEntity new name:#gt;   text:'>');
		at: #apos put: (GeneralEntity new name:#apos; text:'''');
		at: #quot put: (GeneralEntity new name:#quot; text:'"');
		yourself
! !

!XMLParser class methodsFor:'defaults'!

defaultNormalizeAttributes:aBoolean
    DefaultNormalizeAttributes := aBoolean
! !

!XMLParser class methodsFor:'dialects'!

concreteClass
    "return the concrete parser class, per smalltalk dialect"

    (Smalltalk isSmalltalkX)
	ifTrue:[^ XMLParserStX ].

    "add more here"

    ^ XMLParserVW
! !

!XMLParser class methodsFor:'private'!

isValidNameChar: c
    "cg: this is not correct:
	^ c isLetterOrDigit or: [c == $- or:[c ==$_]]
     a name may also contain much more..."

    |cp "Class: SmallInteger"|

    c isLetterOrDigit ifTrue:[^ true].
    (c == $-) ifTrue:[^ true].
    (c == $_) ifTrue:[^ true].

    (c == $.) ifTrue:[^ true].
    cp := c codePoint.
    cp == 16rB7 ifTrue:[^ true].
    (cp between:16rC0 and:16r2FF) ifTrue:[
	^ cp ~~ 16rD7 and:[ cp ~~ 16rF7]
    ].
    (cp between:16r300 and:16r1FFF) ifTrue:[
	^ cp ~~ 16r37E
    ].
    (cp between:16r200C and:16r200D) ifTrue:[^ true].
    (cp between:16r203F and:16r2040) ifTrue:[^ true].
    (cp between:16r2070 and:16r218F) ifTrue:[^ true].
    (cp between:16r2C00 and:16r2FEF) ifTrue:[^ true].
    (cp between:16r3001 and:16rD7FF) ifTrue:[^ true].
    (cp between:16rF900 and:16rFDCF) ifTrue:[^ true].
    (cp between:16rFDF0 and:16rFFFD) ifTrue:[^ true].
    (cp between:16r10000 and:16rEFFFF) ifTrue:[^ true].
    ^ false

"/ W3C says:
"/     NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF]
"/                             | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] |
"/                             [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
"/     NameChar      ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
!

isValidNameStart: c
    "cg: this is not correct;
	^ c isLetter or: [c ==$_ ]
     a name may contain much more..."

    |cp "Class: SmallInteger"|

    (c == $_) ifTrue:[^ true].
    c isLetter ifTrue:[^ true].
    cp := c codePoint.
    (cp between:16rC0 and:16r2FF) ifTrue:[
	^ cp ~~ 16rD7 and:[ cp ~~ 16rF7]
    ].
    (cp between:16r370 and:16r1FFF) ifTrue:[
	^ cp ~~ 16r37E
    ].
    (cp between:16r200C and:16r200D) ifTrue:[^ true].
    (cp between:16r2070 and:16r218F) ifTrue:[^ true].
    (cp between:16r2C00 and:16r2FEF) ifTrue:[^ true].
    (cp between:16r3001 and:16rD7FF) ifTrue:[^ true].
    (cp between:16rF900 and:16rFDCF) ifTrue:[^ true].
    (cp between:16rFDF0 and:16rFFFD) ifTrue:[^ true].
    (cp between:16r10000 and:16rEFFFF) ifTrue:[^ true].
    ^ false

"/ W3C says:
"/     NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF]
"/                             | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] |
"/                             [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
"/     NameChar      ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
! !

!XMLParser class methodsFor:'utilities'!

invalid: aString
	^ InvalidSignal raiseRequestErrorString:(' - ', aString)
!

malformed: aString

	MalformedSignal new
		messageText: ' - ', aString;
		raiseSignal
!

mapEncoding: anEncoding
        "visualworks specific: map xml-encoding names to vw encodedStream names"
        
        | enc |
        enc := anEncoding asLowercase.
        enc = 'utf-8' ifTrue: [^'UTF_8'].
        enc = 'utf-16' ifTrue: [^'UTF_16'].
        enc = 'iso-8859-1' ifTrue: [^'ISO8859_1'].
        ^enc

    "Modified (comment): / 09-11-2017 / 07:47:30 / cg"
!

warn: aString
	"Added to unify warnings for SAX. REW"
	WarningSignal isHandled ifTrue:[
	    WarningSignal raiseSignal: aString
	] ifFalse:[
	    Transcript showCR:'XMLParser [warning]: ',aString
	]
! !

!XMLParser methodsFor:'DTD processing'!

conditionalSect

	| nm oldIgnore |
	hereChar == $< ifFalse: [^false].
	self inInternalSubset ifTrue: [^false].
	^(self skipIf: '<!![')
		ifTrue:
			[self skipSpaceInDTD.
			nm := self getSimpleName.
			(#('INCLUDE' 'IGNORE') includes: nm)
				ifFalse: [self expected: 'INCLUDE or IGNORE'].
			oldIgnore := ignore.
			ignore := ignore or: [nm = 'IGNORE'].
			self skipSpaceInDTD.
			self mustFind: '['.
			[self skipIf: ']]>']
				whileFalse: [self dtdEntry].
			ignore := oldIgnore.
			true]
		ifFalse: [false]
!

dtdEntry

	((self PERef: #dtdEntry) or:
			[self markUpDecl or:
			[self conditionalSect or:
			[self skipSpace or:
			[self atEnd]]]])
		ifFalse: [self expected: 'markup declaration or PE reference']
!

dtdFile: newURI

	| uri str |

	self documentNode noteExternalDTD.
	currentSource skip: -1.
		"So we don't lose hereChar."
	uri := self uriResolver resolve: newURI last from: self latestURI.
	self pushSource: (str := StreamWrapper
						stream: (self uriResolver openStreamOn: uri)
						protocol: uri key
						name: uri value
						entity: nil).
	str usedAsExternal: true.
	str textDeclIn: self.
	self getNextChar.
	[self fullSourceStack includes: str]
		whileTrue: [self dtdEntry].
!

dtdStream:aStream rootElement:rootElementNameString
    "set the DTD from the contents of aStream"

    |str|

    self documentNode noteExternalDTD.

    currentSource notNil ifTrue:[
	currentSource skip:-1. "So we don't lose hereChar."
    ].

    self pushSource:(str := StreamWrapper
			stream:aStream
			protocol:'internal'
			name:nil
			entity:nil).

    str usedAsExternal:true.
    str textDeclIn:self.
    self getNextChar.
    [self fullSourceStack includes:str] whileTrue:[ self dtdEntry ].

    currentSource notNil ifTrue:[
	currentSource skip:-1. "So we don't lose hereChar."
    ].

    self isValidating ifTrue:[
	dtd completeValidationAgainst:self
    ].

    rootElementNameString notNil ifTrue:[
	dtd declaredRoot:(NodeTag new qualifier: '' ns: '' type:rootElementNameString).
    ].
!

externalID: usage
	"Usage may be #docType, #entity, or #notation.
	DocType is treated specially, since PE references are not allowed.
	Notation is treated specially since the system identifier of the
		PUBLIC form is optional."

	| lit2 lit1 forceSpace skipSpace |
	forceSpace := [usage == #docType
					ifTrue: [self forceSpace]
					ifFalse: [self forceSpaceInDTD]].
	skipSpace := [usage == #docType
					ifTrue: [self skipSpace]
					ifFalse: [self skipSpaceInDTD]].
	^(self skipIf: 'SYSTEM')
		ifTrue:
			[forceSpace value.
			lit2 := self systemLiteral.
			Array with: lit2]
		ifFalse: [(self skipIf: 'PUBLIC')
			ifTrue:
				[forceSpace value.
				lit1 := self pubIdLiteral.
				usage == #notation
					ifTrue:
						[(skipSpace value and:
								[hereChar == $' or: [hereChar == $"]])
							ifTrue: [lit2 := self systemLiteral]
							ifFalse: [lit2 := nil]]
					ifFalse:
						[forceSpace value.
						lit2 := self systemLiteral].
				Array with: lit1 with: lit2]
			ifFalse:
				[nil]]
!

inInternalSubset

	self fullSourceStack reverseDo:
		[:str |
		str usedAsExternal == nil
			ifFalse: [^str usedAsExternal not]].
	self error: 'Not currently processing the DTD'
!

markUpDecl

	^self elementDecl
		or: [self attListDecl
		or: [self entityDecl
		or: [self notationDecl
		or: [self pi
		or: [self comment]]]]]
!

notationDecl

	| nm id str |
	str := currentSource.
	^(self skipIf: '<!!NOTATION')
		ifTrue:
			[self forceSpaceInDTD.
			nm := self getSimpleName.
			self forceSpaceInDTD.
			id := self externalID: #notation.
			ignore ifFalse: [dtd notationAt: nm put: (builder notation: nm value: id)].
			self skipSpaceInDTD.
			self mustFind: '>'.
			str == lastSource
				ifFalse: [self invalid: 'Improper nesting of declarations within a parameter entity'].
			true]
		ifFalse: [false]
!

pubIdLiteral

	| str |
	str := self quotedString.
	str do: [:ch |
		((' -''()+,./:=?;!!*#@$_%' includes: ch)
				or: [ch asInteger = 10
				or: [ch asInteger = 13
				or: [ch < 127
				and: [ch isLetter or: [ch isDigit]]]]])
			ifFalse: [self expected: 'valid public id character']].
	^str
!

systemLiteral

	^self quotedString
!

uriResolver
	^URIResolver
! !

!XMLParser methodsFor:'IDs'!

checkUnresolvedIDREFs

	(self isValidating and: [unresolvedIDREFs notEmpty])
		ifTrue: [self invalid: ('The IDREFs <1p> have not been resolved to IDs' expandMacrosWith: unresolvedIDREFs asSortedCollection asArray)]
!

rememberIDREF: anID

	self documentNode atID: anID ifAbsent: [unresolvedIDREFs add: anID]
!

resolveIDREF: anID

	unresolvedIDREFs remove: anID ifAbsent: []
! !

!XMLParser methodsFor:'accessing'!

builder
    "return the value of the instance variable 'builder' (automatically generated)"

    ^ builder
!

document
    "cg: added for twoFlower *compatibilitz with newer XMLParser framework"

    ^ builder driver document
!

dtd

	^dtd
!

encoding
    ^ encoding
!

eol

	^eol
!

isEncodeChecking
	isEncodeChecking isNil ifTrue:[isEncodeChecking := true].
	^isEncodeChecking
!

isEncodeChecking: aBoolean
	isEncodeChecking := aBoolean
!

isTreeBuilding
    "answer true, if we build a tree of xml elements.
     This is false for SAX parsing"

    ^ isTreeBuilding
!

isTreeBuilding:something
    isTreeBuilding := something.
!

normalizeAttributes
    ^ normalizeAttributes ? DefaultNormalizeAttributes ? true
!

normalizeAttributes:aBoolean
    "controls if attribute values like ' foo   bar ' are normalized to
     'foo bar' or not. The default is true.
     If you have to parse non-standard XML, you can set this to false
     before parsing"
     
    normalizeAttributes := aBoolean
!

normalizeDtd
    ^ normalizeDtd
!

normalizeDtd:something
    normalizeDtd := something.
!

sourceWrapper

	^sourceStack "last"
!

validate: aBoolean

	validating := aBoolean
! !

!XMLParser methodsFor:'api'!

comment

	| comment str1 |
	str1 := currentSource.
	^(self skipIf: '<!!--')
		ifTrue:
			[comment := self completeComment: str1.
			(ignore or: [comment isDiscarded])
				ifFalse: [self documentNode addNode: comment].
			true]
		ifFalse: [false]
!

docTypeDecl

	| nm id |
	^(self skipIf: '<!!DOCTYPE')
		ifTrue:
			[self forceSpace.
			self documentNode noteDTD.
			nm := self getQualifiedName.
			self dtd declaredRoot: nm.
			nm yourself.
			self skipSpace.
			(id := self externalID: #docType) notNil ifTrue: [self skipSpace].
			self sourceWrapper usedAsExternal: false.
			(self skipIf: '[')
				ifTrue: [[self skipIf: ']']
					whileFalse: [self dtdEntry]].
			self sourceWrapper usedAsExternal: nil.
			id == nil ifFalse: [
			    self isValidating ifTrue:[self dtdFile: id]
			].
			self skipSpace.
			self mustFind: '>'.
			self isValidating ifTrue: [dtd completeValidationAgainst: self].
			true]
		ifFalse: [false]
!

latestURI

	| s nm |
	s := self fullSourceStack reverse detect: [:i | i protocol ~= 'internal'] ifNone: [nil].
	^s == nil
		ifTrue:
			[nm := (Filename defaultDirectory construct: 'xxx') asString.
			nm replaceAll: Filename separator with: $/.
			'file' -> nm]
		ifFalse: [s protocol -> s name]
!

misc
    "comment or PI"

    ^ self atEnd not and: [self skipSpace or: [self comment or: [self pi]]]

    "Modified (comment): / 13-03-2017 / 11:10:38 / stefan"
!

parseDtd
    "parse a plain dtd"

    |source|

    self getNextChar.
    source := currentSource.
    [ self misc ] whileTrue.
    [ self atEnd ] whileFalse:[ self dtdEntry ].
!

pi

	| str1 pi |
	str1 := currentSource.
	^(self skipIf: '<?')
		ifTrue:
			[pi := self completePI: str1.
			ignore ifFalse: [self documentNode addNode: pi].
			true]
		ifFalse: [false]
!

prolog

	self sourceWrapper xmlDeclIn: self.        "This is optional."
	self getNextChar.
	[self misc] whileTrue.
	self docTypeDecl
		ifTrue: [[self misc] whileTrue].
!

pushSource: aStreamWrapper

	aStreamWrapper nextLink: sourceStack.
	currentSource := sourceStack := aStreamWrapper
!

scanDocument
    "/ MessageTally spyOn:[

    ^ [
	self prolog.
	self documentNode addNode:self element.
	[ self misc ] whileTrue.
	self atEnd ifFalse:[
	    self expected:'comment or processing instruction'
	].
	self checkForWrongRootNode.
	self documentNode updateIDs.
	self checkUnresolvedIDREFs.
	self documentNode
    ] ensure:[ self closeAllFiles ]

    "/ ]
! !

!XMLParser methodsFor:'attribute def processing'!

attListDecl

	| nm str1 attr |
	str1 := currentSource.
	^(self skipIf: '<!!ATTLIST')
		ifTrue:
			[self forceSpaceInDTD.
			nm := self getQualifiedName.
			[self skipSpaceInDTD.
			self skipIf: '>']
				whileFalse:
					[self skipSpaceInDTD.
					attr := AttributeDef new name: self getQualifiedName.
					self forceSpaceInDTD.
					attr type: self attType.
					self forceSpaceInDTD.
					attr default: self defaultDecl.
					self isValidating ifTrue: [attr selfValidateFor: self].
					ignore ifFalse: [self dtd attributeFor: nm subKey: attr name put: attr]].
			str1 == lastSource
				ifFalse: [self invalid: 'Improper nesting of declarations within a parameter entity'].
			true]
		ifFalse: [false]
!

completeNotationType

	| nm |
	self forceSpaceInDTD.
	self mustFind: '('.
	self skipSpaceInDTD.
	nm := OrderedCollection with: self getSimpleName.
	self skipSpaceInDTD.
	[self skipIf: '|']
		whileTrue:
			[self skipSpaceInDTD.
			nm add: self getSimpleName.
			self skipSpaceInDTD].
	self mustFind: ')'.
	^NOTATION_AT typeNames: nm
!

defaultDecl

	| fixed default |
"/        ^(self skipIf: '#REQUIRED')
"/                ifTrue: [#required]
"/                ifFalse: [(self skipIf: '#IMPLIED')
"/                        ifTrue: [#implied]
"/                        ifFalse:
"/                                [fixed := self skipIf: '#FIXED'.
"/                                fixed ifTrue:
"/                                        [self forceSpaceInDTD].
"/                                default := self attValue.
"/                                default == nil ifTrue: [self expected: 'quoted value for the attribute''s default'].
"/                                fixed -> default]]
"/ Fixed for stc compilation:

	(self skipIf: '#REQUIRED') ifTrue: [^ #required].
	(self skipIf: '#IMPLIED')  ifTrue: [^ #implied].
	fixed := self skipIf: '#FIXED'.
	fixed ifTrue:[self forceSpaceInDTD].
	default := self attValue.
	default == nil ifTrue:[self expected: 'quoted value for the attribute''s default'].
	^ fixed -> default
!

enumeration

	| nm |
	self mustFind: '('.
	self skipSpaceInDTD.
	nm := OrderedCollection with: self nmToken.
	self skipSpaceInDTD.
	[self skipIf: '|']
		whileTrue:
			[self skipSpaceInDTD.
			nm add: self nmToken.
			self skipSpaceInDTD].
	self mustFind: ')'.
	^Enumeration_AT withAll: nm
! !

!XMLParser methodsFor:'attribute processing'!

attValue

        | data aQuote s str1 attVal in out c needSpace|
        aQuote := hereChar.
        (aQuote == $' or: [aQuote == $"]) ifFalse: [^nil].
        s := currentSource.
        hereChar := self nextChar.

        data := CharacterWriteStream on:(String new: 32).
        [(hereChar = aQuote and: [s == currentSource])]
                whileFalse:
                        [hereChar == $<
                                ifTrue: [self malformed: '< not permitted in attribute values; use &lt;'].
                        hereChar == $&
                                ifTrue:
                                        [str1 := currentSource.
                                        (self skipIf: '&#')
                                                ifTrue: [self charEntity: data startedIn: str1]
                                                ifFalse: [self getNextChar; generalEntityInText: data canBeExternal: false]]
                                ifFalse:
                                        [hereChar asInteger < 16r20
                                                ifTrue: [data space]
                                                ifFalse: [data nextPut: hereChar].
                                        hereChar := self nextChar.
                                        ]].
        hereChar := self nextChar.
        attVal := data contents.
        self normalizeAttributes ifTrue:[
            (attVal includes:Character space) ifTrue:[
                "cg: must eat all other spaces ...
                 do it here, to limit changes to one place.
                 Q: is this true?    
                "
                out := CharacterWriteStream on:(String new:attVal size-1).
                in := attVal readStream.
                in skipSeparators.
                needSpace := false.
                [(c := in next) notNil] whileTrue:[
                    c == Character space ifTrue:[
                        in skipSpaces.
                        needSpace := true.
                    ] ifFalse:[
                        needSpace ifTrue:[
                            out space.
                            needSpace := false.
                        ].
                        out nextPut:c.
                    ]
                ].
                attVal := out contents.
            ].
        ].
        ^ attVal
!

attribute

	| nm value |
	nm := self getQualifiedName.
	self skipSpace.
	self mustFind: '='.
	self skipSpace.
	value := self attValue.
	value == nil ifTrue: [self expected: 'quoted value for the attribute'].
	^builder attribute: nm value: value
!

isValidName:arg
    ^ self class isValidName:arg
!

isValidNmToken:arg
    ^ self class isValidNmToken:arg
!

processAttributes
    |attributes attr keys|

    attributes := nil.
    [
        self skipSpace.
        self class isValidNameStart:hereChar
    ] whileTrue:[
        attributes == nil ifTrue:[
            attributes := OrderedCollection new.
            keys := Set new.
        ].
        attr := self attribute.
        attributes add:attr.
        (keys testAndAdd:attr key) ifTrue:[
            self notPermitted:'two attributes with the same name'
        ].
         "
         (attributes collect: [:i | i key]) asSet size = attributes size
         ifFalse: [self notPermitted: 'two attributes with the same name']

        "
    ].
    ^ attributes
!

quotedString

	| string |

	hereChar == $"
		ifTrue:
			[string := self upTo: $".
			hereChar := self nextChar.
			^string].
	hereChar == $'
		ifTrue:
			[string := self upTo: $'.
			hereChar := self nextChar.
			^string].
	self expected: 'quoted string'
!

validateAttributes: attributes for: tag

	| attr attributeList keys |
	attr := self dtd attributesFor: tag.
	attributeList := attributes == nil ifTrue: [#()] ifFalse: [attributes].
	keys := Set new.
	attributeList do: [:i |
		(keys includes: i key)
			ifTrue: [self malformed: ('the attribute "<1s>" was used twice in this element''s tag "<2s>"'
								expandMacrosWith: i key with:tag)]
			ifFalse: [keys add: i key].
		(attr includesKey: i key asString)
			ifFalse: [self invalid: ('the attribute "<1s>" was not defined in the DTD for tag "<2s>"'
								expandMacrosWith: i key with:tag)]].

	attr do: [:adef | | a |
		a := attributeList detect: [:at | at key isLike: adef name] ifNone: [].
		a == nil
			ifTrue: [adef hasDefault
				ifTrue: [attributeList := attributeList copyWith:
							(builder attribute: adef name value: adef default)]
				ifFalse: [adef isRequired
					ifTrue: [self invalid: ('"<1s>" elements are required to have a "<2s>" attribute'
									expandMacrosWith: tag asString
									with: adef name asString)]]]
			ifFalse: [adef validateValueOf: a for: self]].
	^attributeList size = 0
		ifTrue: [nil]
		ifFalse: [attributeList]
! !

!XMLParser methodsFor:'element def processing'!

completeChildren: str

	| div items node |
	items := OrderedCollection with: self cp.
	self skipSpaceInDTD.
	div := nil.
	[self skipIf: ')']
		whileFalse:
			[div == nil ifTrue:
				[(',|' includes: hereChar) ifFalse: [self expected: ', or |'].
				div := hereChar].
			div = hereChar ifFalse: [self expected: (String with: div)].
			self getNextChar; skipSpaceInDTD.
			items add: self cp.
			self skipSpaceInDTD].
	(self isValidating and: [lastSource ~~ str])
		ifTrue: [self expected: 'proper nesting of parentheses within entities'].
	div == nil ifTrue: [div := $,].
	div == $,
		ifTrue: [node := SequencePattern on: items]
		ifFalse: [node := ChoicePattern on: items].
	('*+?' includes: hereChar)
		ifTrue:
			[node := ModifiedPattern on: node type: hereChar.
			self getNextChar].
	^node
!

completeMixedContent: str

	"we already have the #PCDATA finished."
	| names |
	self skipSpaceInDTD.
	names := OrderedCollection new.
	[hereChar == $)]
		whileFalse:
			[self mustFind: '|'.
			self skipSpaceInDTD.
			names add: (NamePattern named: self getQualifiedName).
			self skipSpaceInDTD].
	(self isValidating and: [currentSource ~~ str])
		ifTrue: [self expected: 'proper nesting of parentheses within entities'].
	names size = 0
		ifTrue: [self mustFind: ')']
		ifFalse: [self mustFind: ')*'].
	^MixedPattern on: names
!

contentsSpec

	| str |
"/        ^(self skipIf: 'ANY')
"/                ifTrue: [AnyPattern new]
"/                ifFalse: [(self skipIf: 'EMPTY')
"/                        ifTrue: [EmptyPattern new]
"/                        ifFalse:
"/                                [str := currentSource.
"/                                self mustFind: '('.
"/                                self skipSpaceInDTD.
"/                                (self skipIf: '#PCDATA')
"/                                        ifTrue: [self completeMixedContent: str]
"/                                        ifFalse: [self completeChildren: str]]]
"/  Fixed for STC compilation:

	(self skipIf: 'ANY')   ifTrue: [^ AnyPattern new].
	(self skipIf: 'EMPTY') ifTrue: [^ EmptyPattern new].
	str := currentSource.
	self mustFind: '('.
	self skipSpaceInDTD.
	(self skipIf: '#PCDATA') ifTrue: [^ self completeMixedContent:str].
	^ self completeChildren: str
!

cp

	| node str |
	str := currentSource.
	^(self skipIf: '(')
		ifTrue: [self skipSpaceInDTD; completeChildren: str]
		ifFalse:
			[node := NamePattern named: self getQualifiedName.
			('*+?' includes: hereChar)
				ifTrue:
					[node := ModifiedPattern on: node type: hereChar.
					self getNextChar].
			node]
!

elementDecl

	| nm cSpec str |
	str := currentSource.
	^(self skipIf: '<!!ELEMENT')
		ifTrue:
			[self forceSpaceInDTD.
			nm := self getQualifiedName.
			self forceSpaceInDTD.
			cSpec := self contentsSpec.
			normalizeDtd ifTrue:[
			    cSpec := cSpec normalize
			].
			ignore ifFalse: [self dtd elementFor: nm put: cSpec].
			self skipSpaceInDTD.
			self mustFind: '>'.
			str == lastSource
				ifFalse: [self invalid: 'Improper nesting of declarations within a parameter entity'].
			true]
		ifFalse: [false]
! !

!XMLParser methodsFor:'element processing'!

charEntity: data startedIn: str1
	"parse a character entity and add it to data.
	 cg: separated into parsinf the entity and adding to the stream"

	|char|

	char := self parseCharEntityStartedIn: str1.
	data nextPut: char.
	^ char
!

closeTag: tag return: elements

	| nm |
	nm := self getQualifiedName.
	nm := builder correctTag: nm.
	self skipSpace.
	self mustFind: '>'.
	nm = tag
		ifFalse: [self expected: 'close tag for ', tag asString].
	^elements
!

completeCDATA: str1
	| str data |
	data := CharacterWriteStream on:(String new: 32).
	[str := self upToAll_positionBefore:']>'.
	str last = $]]
		whileFalse:
			[data nextPutAll: str; nextPutAll: ']>'].
	lastSource = str1
		ifFalse: [self expected: 'proper nesting of CDATA in entities'].
	data nextPutAll: (str copyFrom: 1 to: str size-1).
	^builder makeText: data contents
!

completeComment: str1
        | str data comment commentText|

        data := CharacterWriteStream on:(String new: 32).
        [
            str := self upToAll_positionBefore:'->'.
            str last = $-
        ] whileFalse:[
            data nextPutAll: str; nextPutAll: '->'
        ].
        data nextPutAll: (str copyFrom: 1 to: str size-1).
        comment := builder comment: data contents.

        commentText := comment text.
        commentText size > 0 ifTrue:[
            (commentText findString: '--' startingAt: 1) = 0
                ifFalse: [self notPermitted: 'doubled hyphens in comments'].
            (commentText last = $-)
                ifTrue: [self notPermitted: 'a hyphen as the last character in a comment'].
        ].
        lastSource = str1
                ifFalse: [self expected: 'proper nesting of comments in entities'].
        ^comment
!

completePI: str1
	| nm pi |
	nm := self getSimpleName.
	nm = 'xml' ifTrue: [self notPermitted: '"xml" declaration, except at the beginning of the file'].
	nm asLowercase = 'xml' ifTrue: [self notPermitted: '''xml'' as part of a name'].
	self skipSpace
		ifTrue:
			[pi := self upToAll_positionBefore:'?>']
		ifFalse:
			[pi := ''.
			self mustFind: '?>'].
	lastSource = str1
		ifFalse: [self expected: 'proper nesting of programming instructions in entities'].
	^builder pi: nm text: pi
!

element
    |str1 startPosition|

    currentSource isNil ifTrue:[
	self expected:'element'
    ].
    str1 := currentSource stream.
    startPosition := str1 position.
    str1 isEncodedStream ifTrue:[
	startPosition := startPosition + 1 - (str1 encoder characterSize:hereChar).
    ].
    ^ self elementAtPosition:startPosition
!

elementAtPosition:startPosition
    |attributes nm str1 elements p tag|

    str1 := currentSource.
    self mustFind:'<'.
    nm := self getQualifiedName.
    ^ builder pushTag:nm whileDoing:[
	    attributes := self processAttributes.
	    tag := builder currentTag.
	    self isValidating ifTrue:[
		attributes := self validateAttributes:attributes for:tag
	    ].
	    attributes := builder resolveNamespaces: attributes.
	    tag := builder currentTag.
	    (self skipIf:'/>') ifTrue:[
		str1 = lastSource ifFalse:[
		    self expected:'elements properly nested within entities'
		].
		self isValidating ifTrue:[
		    p := self dtd elementFor:tag.
		    p == nil ifTrue:[
			self notPermitted:('Using a tag (<1s>) without declaring it'
				    expandMacrosWith:tag asString)
		    ] ifFalse:[
			p
			    validateTag:tag
			    content:#( )
			    for:self
		    ]
		].
		builder postProcessElement:(builder
			    tag:tag
			    attributes:attributes
			    elements:nil
			    position:startPosition
			    stream:str1)
	    ] ifFalse:[
		(self skipIf:'>') ifTrue:[
		    str1 = lastSource ifFalse:[
			self expected:'elements properly nested within entities'
		    ].
		    elements := self elementContent:tag openedIn:str1.
		    isTreeBuilding ifFalse:[
			elements := nil.
		    ].
		    builder postProcessElement:(builder
				tag:tag
				attributes:attributes
				elements:elements
				position:startPosition
				stream:str1)
		] ifFalse:[
		    self expected:'end of start tag'
		]
	    ]
	]
!

elementContent: tag openedIn: str
	| data elements str1 result p |

	data := CharacterWriteStream on:(String new: 32).
	elements := OrderedCollection new.
	[hereChar == nil
		ifTrue: [self expected: ('end tag for %<<1s>>' expandMacrosWith: tag asString)].
	hereChar == $<
		ifTrue:
			[data position = 0
				ifFalse:
					[data := data contents.
"                                       (data findString: ']]>' startingAt: 1) = 0
						ifFalse: [self halt: 'including ]]> in element content'].
"                                       self with: elements add: (builder makeText: data).
					data := CharacterWriteStream on:(String new: 32)].
			str1 := currentSource.
			(self skipIf: '</')
				ifTrue:
					[result := self closeTag: tag return: elements asArray.
					str == lastSource
						ifFalse: [self expected: 'elements properly nested within entities'].
					self isValidating
						ifTrue:
							[p := self dtd elementFor: tag.
							p == nil
								ifTrue: [self invalid: ('Using a tag (<1p>) without declaring it is not valid' expandMacrosWith: tag)]
								ifFalse: [p validateTag: tag content: result for: self]].
					^result]
				ifFalse: [(self skipIf: '<?')
					ifTrue: [self with: elements add: (self completePI: str1)]
					ifFalse: [(self skipIf: '<!![CDATA[')
						ifTrue: [self with: elements add: (self completeCDATA: str1)]
						ifFalse: [(self skipIf: '<!!--')
							ifTrue: [self with: elements add: (self completeComment: str1)]
							ifFalse: [self with: elements add: self element]]]]]
		ifFalse: [hereChar == $&
			ifTrue:
				[str1 := currentSource.
				(self skipIf: '&#')
					ifTrue: [self charEntity: data startedIn: str1]
					ifFalse: [self getNextChar; generalEntityInText: data canBeExternal: true]]
			ifFalse:
				[data nextPut: hereChar.
				hereChar := self nextChar]].
    ] loop
!

generalEntityInText: str canBeExternal: external

	| exp nm str1 |

	str1 := lastSource.
	nm := self getSimpleName.
	hereChar == $;
		ifFalse: [self expected: 'semicolon'].
	currentSource = str1
		ifFalse: [self expected: 'proper nesting of entity references within other entity references'].
	exp := self dtd generalEntityAt: nm.
	exp == nil
		ifTrue: [self warn: ('The general entity "<1s>" has not been defined'
							expandMacrosWith: nm)].
	exp == nil
		ifTrue:
			[self shouldTestWFCEntityDeclared
				ifTrue: [self malformed: 'General entity used but not defined'].
			str nextPut: $&; nextPutAll: nm; nextPut: $;.
			self getNextChar]
		ifFalse:
			[(external or: [exp isExternal not])
				ifFalse: [self notPermitted: 'external entities in attribute values'].
			exp isParsed
				ifFalse: [self malformed: 'References to unparsed entities other than in an attribute of type ENTITY are not permitted'].
			exp streamFor: self].
!

isValidTag: aTag

	^true
!

parseCharEntityStartedIn: str1
	"parse a character entity.
	 cg: separated into parsing and separate adding to the stream"

	|base digit n d char|

	hereChar == $x
		ifTrue:
			[base := 16.
			digit := 'hex digit'.
			hereChar := self nextChar]
		ifFalse:
			[base := 10.
			digit := 'digit'].
	n := 0.
	[hereChar == $;]
		whileFalse:
			[d := hereChar digitValue.
			(d >= 0 and: [d < base]) ifFalse: [self expected: digit].
			n := n * base + d.
			hereChar := self nextChar].
	str1 = currentSource
		ifFalse: [self expected: 'proper nesting of character entities inside other entities'].
"/        (self isIllegalCharacter: n)
"/                ifTrue: [self notPermitted: 'a character with Unicode value ', n printString].
	char := Character value: n.
	hereChar := self nextChar.
	^ char
! !

!XMLParser methodsFor:'entity processing'!

PERef: refType

	| nm exp |
	(hereChar == $%)
		ifTrue:
			[self getNextChar.
			(self inInternalSubset and: [refType ~= #dtdEntry])
				ifTrue: [self notPermitted: 'Parameter entity reference in the internal DTD, inside a declaration'].
			nm := self getSimpleName.
			hereChar == $; ifFalse: [self expected: 'semicolon'].
			exp := self dtd parameterEntityAt: nm.
			exp == nil
				ifTrue: [self warn: ('The parameter entity "<1s>" has not been defined'
							expandMacrosWith: nm)].
			exp == nil
				ifTrue: [self isValidating
					ifTrue:
						["if we are in IGNORE conditional, this is not an error. gj"
						ignore ifFalse:[self invalid: 'Parameter entity used but not defined'.].
						self getNextChar]
					ifFalse:
						[self pushSource: (StreamWrapper
								emptyWithExtraSpace: refType ~= #data).
						self getNextChar]]
				ifFalse:
					[exp streamFor: self addSpaces: refType ~= #data].
			(refType ~= #data and: [self sourceWrapper protocol ~= 'internal'])
				ifTrue: [self sourceWrapper usedAsExternal: true].
			^true]
		ifFalse: [^false]
!

entityDecl

	| nm def str |
	str := currentSource.
	^(self skipIf: '<!!ENTITY')
		ifTrue:
			[self forceSpace.
			hereChar == $%
				ifTrue:
					[self getNextChar; forceSpaceInDTD.
					nm := self getSimpleName.
					self forceSpaceInDTD.
					def := self peDef: nm.          "peDef modified for SAX. REW"
					ignore ifFalse: [self dtd parameterEntityAt: nm put: def]]
				ifFalse:
					[self skipSpaceInDTD.
					nm := self getSimpleName.
					self forceSpaceInDTD.
					def := self entityDef: nm.      "entityDef modified for SAX. REW"
					ignore ifFalse: [self dtd generalEntityAt: nm put: def]].
			self skipSpaceInDTD.
			self mustFind: '>'.
			str == lastSource
				ifFalse: [self invalid: 'Improper nesting of declarations within a parameter entity'].
			true]
		ifFalse: [false]
!

entityDef: entityName
	"Parameter entityName added for SAX. REW"
	| val ndata |
	(val := self entityValue) == nil
		ifTrue:
			[(val := self externalID: #entity) == nil
				ifTrue: [^ self expected: 'entity value or external id']
				ifFalse:
					[ndata := self nDataDecl.
					^ builder
						externalGeneralEntity: entityName
						id: val
						ndata: ndata
						uri: self latestURI]]
		ifFalse: [^ builder internalGeneralEntity: entityName value: val]
!

entityValue

	| data aQuote s str1 |
	aQuote := hereChar.
	(aQuote == $' or: [aQuote == $"]) ifFalse: [^nil].
	s := currentSource.
	self getNextChar.
	data := CharacterWriteStream on:(String new: 32).
	OrderedCollection new.
	[hereChar == nil
		ifTrue: [self expected: (String with: aQuote)].
	(hereChar = aQuote and: [s = currentSource])]
		whileFalse:
			[hereChar == $&
				ifTrue:
					[str1 := currentSource.
					(self skipIf: '&#')
						ifTrue: [self charEntity: data startedIn: str1]
						ifFalse: [self getNextChar; generalEntity: data]]
				ifFalse: [(self PERef: #data)
					ifFalse:
						[data nextPut: hereChar.
						self getNextChar]]].
	self getNextChar.
	^data contents
!

generalEntity: str

	| nm |
	nm := self getSimpleName.
	hereChar == $;
		ifFalse: [self expected: 'semicolon'].
	str nextPut: $&; nextPutAll: nm; nextPut: $;.
	self getNextChar
!

nDataDecl

"/        ^self skipSpaceInDTD
"/                ifTrue: [(self skipIf: 'NDATA')
"/                        ifTrue:
"/                                [self forceSpaceInDTD.
"/                                self getSimpleName]
"/                        ifFalse: [nil]]
"/                ifFalse: [nil]
"/ Fixed for STC compilation:

	self skipSpaceInDTD ifFalse:[^ nil].
	(self skipIf: 'NDATA') ifFalse:[^ nil].
	self forceSpaceInDTD.
	^ self getSimpleName
!

peDef: entityName
	"Parameter entityName added for SAX. REW"
	| val |
	^(val := self entityValue) == nil
		ifTrue: [(val := self externalID: #entity) == nil
			ifTrue: [self expected: 'entity value or external id']
			ifFalse:
				[builder
					externalParameterEntity: entityName
					id: val]]
		ifFalse:
			[builder
				internalParameterEntity: entityName
				value: val]
! !

!XMLParser methodsFor:'initialization'!

builder: anXMLNodeBuilder

	builder := anXMLNodeBuilder.
	isTreeBuilding := builder isTreeBuilding.
!

lineEndLF

	eol := Character lf
!

on: inputStream

    ^ self on:inputStream protocol:nil name:nil
!

on:inputStream protocol:protocolString name:name

	[inputStream lineEndTransparent] on: Error do: [:ex | ].
	validating == nil ifTrue: [validating := true].
	sourceStack := self wrapStream:inputStream protocol:protocolString name:name.
	builder == nil
		ifTrue: [self builder:NodeBuilder new].
	documentNode := Document new.
	dtd := DocumentType new.
	documentNode dtd: dtd.
	unresolvedIDREFs := Set new.
	ignore := false.
	eol := Character cr.

	normalizeDtd := true.
!

wrapStream:aStream protocol:protocolString name:name

    |protocol|

    protocolString notNil ifTrue:[
	protocol := protocolString.
    ] ifFalse:[
	protocol := aStream isExternalStream ifTrue:['file'] ifFalse:['internal']
    ].

    ^StreamWrapper
	    stream: aStream
	    protocol: protocol
	    name: name
	    entity: nil
! !

!XMLParser methodsFor:'private'!

checkForWrongRootNode
    | expectedRootNode |
    expectedRootNode := self dtd declaredRoot.
    (self documentHasDTD
	and:[
	    (expectedRootNode isLikeForValidation:self documentNode root tag) not
	])  ifTrue:[
		self malformed:'root node should have been ' , expectedRootNode asString.
    ]
!

closeAllFiles

	self fullSourceStack do: [:str | str close]
!

documentNode

	^documentNode
!

error: aStringOrMessage

	^XMLSignal raiseErrorString: aStringOrMessage asString
!

expected: string

	self malformed: string, ' expected, but not found'
!

fullSourceStack

	| out s |
	out := OrderedCollection new.
	s := sourceStack.
	[s == nil]
		whileFalse:
			[out addFirst: s.
			s := s nextLink].
	^out
!

getDottedName
    |nm|

    nm := self getSimpleName.
    hereChar == $. ifTrue:[
	[hereChar == $.] whileTrue:[
	    nm := nm copyWith:hereChar.
	    hereChar := self nextChar.
	    nm := nm , self getSimpleName.
	].
    ].
    ^ nm
!

getElement
    "cg: added for twoFlower *compatibility with newer XMLParser framework"

    | str1 startPosition |
    str1 := currentSource.
    startPosition := str1 stream position - (hereChar isNil ifTrue:0 ifFalse:1) "hereCharNumBytes".
    ^self elementAtPosition: startPosition
!

getQualifiedName

	| nm |

	"/ original:
	"/ nm := self getSimpleName.
	nm := self getDottedName.
	hereChar == $:
		ifTrue:
			[hereChar := self nextChar.
			^NodeTag new
			    qualifier: nm
			    ns: ''
			    "/ original:
			    "/ type: self getSimpleName
			    type: self getDottedName
		]
		ifFalse:
			[^NodeTag new qualifier: '' ns: '' type: nm]
!

getSimpleName
    |s|

    (self class isValidNameStart:hereChar) ifFalse:[
        ^ self malformed: ('name expected, but not found (got "%1")' bindWith:hereChar)
        "/ ^ self expected:'name'
    ].
    s := CharacterWriteStream on:(String new:16).
    [
        s nextPut:hereChar.
        hereChar := self nextChar.
        self class isValidNameChar:hereChar
    ] whileTrue.
    ^ s contents
!

invalid: aString

	self class invalid: aString
!

malformed: aString
    |msg lno|

    msg := aString.

    lno := currentSource perform:#line ifNotUnderstood:nil.
    lno notNil ifTrue:[
	msg := msg , (' [at or near line %1]' bindWith:lno)
    ].
    self class malformed: msg
!

nmToken

        | s |
        (self class isValidNameChar: hereChar) ifFalse: [^self expected: 'NmToken'].
        s := CharacterWriteStream on:(String new: 16).
        s nextPut: hereChar.
        [hereChar := self nextChar.
        self class isValidNameChar: hereChar] whileTrue: [s nextPut: hereChar].
        ^s contents
!

notPermitted: string

	self malformed: string, ' is not permitted'
!

validateEncoding:encName
    "validate the encoding string in encName.
     Set the encoding instVar as a side effect."

    |c|

    self isEncodeChecking ifTrue:[
        encName isEmptyOrNil ifTrue:[
            self expected:'non-empty encoding name'
        ].
        c := encName first.
        c isLetter ifFalse:[
            self malformed:('The first letter of the encoding ("<1s>") must be an ASCII alphabetic letter' 
                            expandMacrosWith:encName)
        ].
        2 to:encName size do:[:i | 
            c := encName at:i.
            (c isLetterOrDigit or:[ '._-' includes:c]) ifFalse:[
                self malformed:('The first name of the encoding ("<1s>") must be ''.'', ''_'', ''-'', or an ASCII letter or digit' 
                                 expandMacrosWith:encName)
            ]
        ].
    ].
    encoding := encName.

    "Modified (comment): / 13-03-2017 / 11:28:42 / stefan"
!

validateText: data from: start to: stop testBlanks: testBlanks
    "cg: added for twoFlower *compatibilitz with newer XMLParser framework"

    | elm textType types |
    textType := #characters.
    stop < start ifTrue: [^textType].
    self isValidating
	ifTrue:
	    [elm := builder currentElement "elementStack last".
	    types := elm
		validateText: data
		from: start
		to: stop
		testBlanks: testBlanks.
	    types == nil
		ifTrue: [self invalid: #textNotPermittedHere << #xml >> 'The DTD does not permit text here']
		ifFalse:
		    [(types contains: [:n | n couldBeText]) ifFalse: [textType := #whitespace].
		    elm types: types]].
    ^textType
!

warn: aString
	"Modfied to unify warn system for SAX, REW"
	"gj: dont warn in conditional ignores"
	ignore ifFalse:[self class warn:aString]
!

with:list add:node

    (isTreeBuilding and:[node isDiscarded not]) ifTrue:[
	list add:node
    ]
! !

!XMLParser methodsFor:'streaming'!

atEnd
    sourceStack isNil ifTrue:[
	^ true
    ].
    [ sourceStack atEnd ] whileTrue:[
	sourceStack close.
	sourceStack := sourceStack nextLink.
	sourceStack isNil ifTrue:[^ true].
    ].
    ^ false
!

forceSpace

	self skipSpace ifFalse: [self expected: 'white space'].
!

forceSpaceInDTD

	self skipSpaceInDTD ifFalse: [self expected: 'white space'].
!

getNextChar

	^hereChar := self nextChar
!

mustFind: str

	(self skipIf: str)
		ifFalse: [self expected: '"', str, '"']
!

nextChar

    " avoid #atEnd if possible (let #next return nil) "

    [
	| ch |

	currentSource notNil ifTrue:[
	    ch := currentSource nextFor:self.
	    ch notNil ifTrue:[
		lastSource := currentSource.
		^ ch
	    ].
	].

	self atEnd.
	sourceStack isNil ifTrue: [^ nil].
	lastSource := currentSource.
	currentSource := sourceStack.
    ] loop.

    "not reached"
    ^ nil
!

skipIf: str
    | strSize p oc next|

    hereChar = (str at:1) ifFalse: [^false].
    strSize := str size.

    strSize == 1 ifTrue:[
	hereChar := currentSource nextFor:self.
	hereChar == nil ifTrue:[
	    hereChar := self nextChar.
	].
	^ true
    ].

    next := self sourceWrapper stream peekOrNil.
    next = (str at:2) ifFalse: [^false].
    strSize == 2 ifTrue:[
	hereChar := currentSource nextFor:self.
	hereChar == nil ifTrue:[
	    hereChar := self nextChar.
	].
	hereChar := currentSource nextFor:self.
	hereChar == nil ifTrue:[
	    hereChar := self nextChar.
	].
	^ true
    ].

    p := self sourceWrapper stream position.
    oc := hereChar.
    1 to: strSize do: [:i |
	    hereChar = (str at: i)
		    ifFalse:
			    [self sourceWrapper stream position: p.


			    hereChar := oc.
			    ^false].
	    lastSource := currentSource.
	    currentSource := self sourceWrapper.
	    hereChar := self sourceWrapper nextFor: self].
    hereChar == nil
	    ifTrue: [hereChar := self nextChar].
    ^true
!

skipSpace
    "answer true, if whitespace was skipped"

    |ascii|

    hereChar isNil ifTrue:[
	^ false
    ].
    ascii := hereChar codePoint.
    (ascii == 32 or:[ ascii == 10 or:[ ascii == 13 or:[ ascii == 9 ] ] ]) ifFalse:[
	^ false
    ].

    [
	hereChar := self nextChar.
	hereChar isNil ifTrue:[
	    ^ true
	].
	ascii := hereChar codePoint.
	(ascii == 32 or:[ ascii == 10 or:[ ascii == 13 or:[ ascii == 9 ] ] ]) ifFalse:[
	    ^ true
	].
    ] loop.
    " not reached "
    ^ true.

    "
	| n |

	n := 0.
	[hereChar ~~ nil and: [#(9 10 13 32) includes: hereChar asInteger]]
	whileTrue:[n := n+1.
		   self getNextChar].
	^ n > 0
    "
!

skipSpaceInDTD

	| space |
	space := self skipSpace.
	[self PERef: #dtd]
		whileTrue: [space := self skipSpace | space].
	^space
!

upTo: aCharacter
	"Answer a subcollection from position to the occurrence (if any, exclusive) of anObject.
	 The stream is left positioned after anObject.
	If anObject is not found answer everything."

	| newStream element |
	newStream := CharacterWriteStream on:(String new: 64).
"/        [self atEnd]
"/                whileFalse:
"/                        [element := self nextChar.
"/                        element = aCharacter
"/                                ifTrue: [^newStream contents].
"/                        newStream nextPut: element.].
	[(element := self nextChar) notNil] whileTrue:[
	    element = aCharacter
		    ifTrue: [^newStream contents].
	    newStream nextPut: element.
	].
	self expected: (String with: aCharacter).
	^newStream contents
!

upToAll_positionBefore:target
    "Answer a subcollection from the current position
     up to the occurrence (if any, not inclusive) of target,
     and leave the stream positioned before the occurrence.
     If no occurrence is found, answer the entire remaining
     stream contents, and leave the stream positioned at the end.
     We are going to cheat here, and assume that the first
     character in the target only occurs once in the target, so
     that we don't have to backtrack."

    |str i|

    (target occurrencesOf:target first) = 1 ifFalse:[
	self error:'The target collection is ambiguous.'
    ].
    self sourceWrapper skip:-1.
    str := CharacterWriteStream on:(String new:32).
    [
	str nextPutAll:(self upTo:target first).
	i := 2.
	[
	    i <= target size and:[ self nextChar = (target at:i) ]
	] whileTrue:[ i := i + 1 ].
	i <= target size
    ] whileTrue:[
	str nextPutAll:(target copyFrom:1 to:i - 1).
	self sourceWrapper skip:-1
    ].
    hereChar := self nextChar.
    ^ str contents
! !

!XMLParser methodsFor:'testing'!

documentHasDTD
	^self dtd declaredRoot notNil
!

hasExpanded: anEntity

	| s |
	s := sourceStack.
	[s == nil] whileFalse:
		[s entity == anEntity
			ifTrue: [self malformed: ('The <1s> entity "<2s>" invokes itself recursively'
						expandMacrosWith: anEntity entityType
						with: anEntity name)].
		s := s nextLink].
	^false
!

isIllegalCharacter:anInteger
    "answer true, if anInteger is an illegal unicode code point in an xml file"

    (16r20 <= anInteger) ifTrue:[
        "Range 16rD800 - 16rDFFF is reserved for the
         lower and upper substitution page for UCS-16"
        (16rD800 <= anInteger) ifTrue:[
            (16rDFFF >= anInteger) ifTrue:[
                ^ true.
            ].
            (anInteger == 16rFFFE) ifTrue:[
                ^ true.
            ].
            (anInteger == 16rFFFF) ifTrue:[
                ^ true.
            ].
        ].
        ^ false
    ].

    anInteger == 10 ifTrue:[^ false].
    anInteger == 9  ifTrue:[^ false].
    anInteger == 13 ifTrue:[^ false].
    anInteger == 12 ifTrue:[^ false].

    ^ true
!

isValidating
    ^validating
!

shouldTestWFCEntityDeclared

	^self documentNode hasDTD not
		or: [(self documentNode hasExternalDTD not
			and: [self documentNode usesParameterEntities not])
		or: [self documentNode isDeclaredStandalone]]
! !

!XMLParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLParser.st,v 1.71 2017-11-09 08:55:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLParser.st,v 1.71 2017-11-09 08:55:38 cg Exp $'
! !


XMLParser initialize!
