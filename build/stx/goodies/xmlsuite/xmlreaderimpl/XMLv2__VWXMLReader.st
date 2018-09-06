"{ Package: 'stx:goodies/xmlsuite/xmlreaderimpl' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#VWXMLReader
	instanceVariableNames:'parser'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!

XML::StreamWrapper subclass:#StreamWrapper
	instanceVariableNames:'col'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VWXMLReader
!

XML::XMLParserStX subclass:#XMLParser
	instanceVariableNames:'xmlReader'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VWXMLReader
!


!VWXMLReader methodsFor:'SAX2 interface - Locator'!

getColumnNumber
    "Superclass says that I am responsible to implement this method"

    ^parser getColumnNumber

    "Created: / 19-05-2005 / 10:45:03 / masca"
    "Modified: / 11-07-2005 / 12:07:19 / masca"
    "Modified: / 04-08-2005 / 11:21:01 / janfrog"
!

getLineNumber
    "Superclass says that I am responsible to implement this method"

    ^parser  getLineNumber

    "Created: / 19-05-2005 / 10:45:03 / masca"
    "Modified: / 11-07-2005 / 12:07:10 / masca"
    "Modified: / 04-08-2005 / 11:21:15 / janfrog"
! !

!VWXMLReader methodsFor:'SAX2 interface - extensions'!

parseFragmentStream:aStream 
    "Superclass says that I am responsible to implement this method"

    ^self parseStream:aStream

    "Created: / 03-05-2005 / 11:46:46 / janfrog"
!

parseStream:aStream

    | saxBuilder |

    aStream isExternalStream ifTrue:[
        aStream text
    ] ifFalse:[
        aStream isBinary ifTrue:[aStream on:aStream collection asString]
    ].


    saxBuilder := VWSAXBuilder 
                        driver: self getContentHandler 
                        source: aStream.
    parser := XMLv2::VWXMLReader::XMLParser on: aStream.
    parser xmlReader:self.
    parser builder:saxBuilder.
    parser validate:false.
    parser scanDocument.

    "Created: / 03-05-2005 / 11:46:46 / janfrog"
    "Modified: / 18-05-2005 / 11:04:37 / masca"
    "Modified: / 06-06-2006 / 09:23:21 / janfrog"
! !

!VWXMLReader::StreamWrapper class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!VWXMLReader::StreamWrapper methodsFor:'accessing'!

col
    ^ col

    "Created: / 04-08-2005 / 11:19:20 / janfrog"
!

line
    ^ line

    "Created: / 04-08-2005 / 11:19:20 / janfrog"
! !

!VWXMLReader::StreamWrapper methodsFor:'declaration'!

encodingDeclIn: aParser

        | enc |
        ^stream peek = $e
                ifTrue:
                        [| encoding |
                        self mustFind: 'encoding' errorOn: aParser.
                        self skipSpaceIn: aParser.
                        self mustFind: '=' errorOn: aParser.
                        self skipSpaceIn: aParser.
                        encoding := self quotedString.
                        aParser validateEncoding: encoding.
                        ((stream respondsTo: #encoder)
                                        and: [stream encoder nameOfEncoding asLowercase ~= (XMLv2::VWXMLReader::XMLParser mapEncoding: encoding) asLowercase])
                                ifTrue:
                                        [enc := (CharacterEncoder encoderFor:
                                                        (XMLv2::VWXMLReader::XMLParser mapEncoding: encoding) asSymbol).

                                        stream encoder: enc].
                        true]
                ifFalse: [false]

    "Created: / 15-06-2005 / 15:00:01 / janfrog"
    "Modified: / 22-06-2005 / 17:02:27 / masca"
! !

!VWXMLReader::StreamWrapper methodsFor:'initialization'!

stream: str protocol: key name: value entity: ent

    super stream: str protocol: key name: value entity: ent.

    line := 1.
    col := 0.
    stream := EncodedStream 
                stream:stream 
                encoder:(CharacterEncoder encoderForUTF8)

    "Created: / 15-06-2005 / 14:58:51 / janfrog"
    "Modified: / 04-08-2005 / 11:42:05 / janfrog"
! !

!VWXMLReader::StreamWrapper methodsFor:'streaming'!

nextFor:aParser 
    |ch ascii|

    ch := stream next.
    (ch = Character lf) ifTrue:[
        line := line + 1.
        col := 0.
    ] ifFalse:[

        col := col + 1.
    ].
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
            ch == cr ifTrue:[
                stream peekFor:lf.
                ^ aParser eol
            ] ifFalse:[
                ch == lf ifTrue:[
                    ^ aParser eol
                ]
            ]
        ].
    ].
    (aParser isIllegalCharacter:ascii) ifTrue:[
        aParser 
            notPermitted:'a character with Unicode value ' , ascii printString
    ].
    ^ ch

    "Created: / 04-08-2005 / 11:16:48 / janfrog"
!

skip: n

    | str idx lfs |
    n < 0 ifTrue:[^stream skip:n].
    str := stream next:n.
    lfs := str occurrencesOf:Character lf.
    lfs isZero 
        ifTrue:[
            col := col + str size
        ] ifFalse:[
            idx := str lastIndexOf:Character lf.
            line := line + lfs . 
            col := col + (str size - idx).
    ].

    "Created: / 04-08-2005 / 11:18:37 / janfrog"
    "Modified: / 04-08-2005 / 14:54:25 / janfrog"
! !

!VWXMLReader::XMLParser class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!VWXMLReader::XMLParser class methodsFor:'utilities'!

mapEncoding: anEncoding

        | enc |
        enc := anEncoding asLowercase.
        "enc = 'utf-8' ifTrue: [^'UTF_8'].
        enc = 'utf-16' ifTrue: [^'UTF_16'].
        enc = 'iso-8859-1' ifTrue: [^'ISO8859_1']."
        ^enc

    "Created: / 22-06-2005 / 17:11:03 / masca"
!

readFileContents: fn

        | s p |
        s := VWXMLReader::StreamWrapper
                        stream: (fn withEncoding: #UTF_8) readStream
                        protocol: 'file'
                        name: nil       
                        entity: nil.
        p := self new.
        p lineEndLF.
        ^[s checkEncoding.
          s contentsFor: p]
                ensure: [s close]

    "Created: / 15-06-2005 / 15:04:40 / janfrog"
! !

!VWXMLReader::XMLParser methodsFor:'SAX2 interface - Locator'!

getColumnNumber
    "Superclass says that I am responsible to implement this method"

    ^currentSource col

    "Modified: / 11-07-2005 / 12:07:19 / masca"
    "Created: / 04-08-2005 / 11:20:26 / janfrog"
!

getLineNumber
    "Superclass says that I am responsible to implement this method"

    ^currentSource line

    "Modified: / 11-07-2005 / 12:07:10 / masca"
    "Created: / 04-08-2005 / 11:20:26 / janfrog"
! !

!VWXMLReader::XMLParser methodsFor:'accessing'!

dtdFile:aString

    "Created: / 18-05-2005 / 11:04:10 / masca"
!

xmlReader
    ^ xmlReader

    "Created: / 25-10-2005 / 13:09:54 / janfrog"
!

xmlReader:something
    xmlReader := something.

    "Created: / 25-10-2005 / 13:09:54 / janfrog"
! !

!VWXMLReader::XMLParser methodsFor:'attribute processing'!

processAttributes
    |attributes attr keys|

    attributes := nil.
    [
        self skipSpace.
        self isValidNameStart:hereChar
    ] whileTrue:[
        attributes == nil ifTrue:[
            attributes := OrderedCollection new.
            keys := Set new.
        ].
        attr := self attribute.
        attributes add:attr.
        "(keys testAndAdd:attr key) ifTrue:[
            self notPermitted:'two attributes with the same name'
        ]."
         "
         (attributes collect: [:i | i key]) asSet size = attributes size
         ifFalse: [self notPermitted: 'two attributes with the same name']

        "
    ].
    ^ attributes

    "Created: / 02-06-2008 / 19:28:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!VWXMLReader::XMLParser methodsFor:'element processing'!

elementContent: tag openedIn: str

        | data elements str1 result p |
        data := (UnicodeString new: 32) writeStream.
        elements := OrderedCollection new.
        [hereChar == nil
                ifTrue: [self expected: ('end tag for %<<1s>>' expandMacrosWith: tag)].
        hereChar = $<
                ifTrue:
                        [data position0Based = 0
                                ifFalse:
                                        [data := data contents.
"                                       (data findString: ']]>' startingAt: 1) = 0
                                                ifFalse: [self halt: 'including ]]> in element content'].
"                                       self with: elements add: (builder makeText: data).
                                        data := (UnicodeString new: 32) writeStream].
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
                                                                ifTrue: [self invalid: ('Using a tag (<1s>) without declaring it is not valid' expandMacrosWith: tag)]
                                                                ifFalse: [p validateTag: tag content: result for: self]].
                                        ^result]
                                ifFalse: [(self skipIf: '<?')
                                        ifTrue: [self with: elements add: (self completePI: str1)]
                                        ifFalse: [(self skipIf: '<!![CDATA[')
                                                ifTrue: [self with: elements add: (self completeCDATA: str1)]
                                                ifFalse: [(self skipIf: '<!!--')
                                                        ifTrue: [self with: elements add: (self completeComment: str1)]
                                                        ifFalse: [self with: elements add: self element]]]]]
                ifFalse: [hereChar = $&
                        ifTrue:
                                [str1 := currentSource.
                                (self skipIf: '&#')
                                        ifTrue: [self charEntity: data startedIn: str1]
                                        ifFalse: [self getNextChar; generalEntityInText: data canBeExternal: true]]
                        ifFalse:
                                [data nextPut: hereChar.
                                self getNextChar]]. true] whileTrue "repeat"

    "Created: / 22-06-2005 / 09:23:51 / masca"
    "Modified: / 15-05-2006 / 14:50:28 / janfrog"
!

generalEntityInText: str canBeExternal: external

        | exp nm str1 |
        str1 := lastSource.
        nm := self getSimpleName.
        hereChar = $;
                ifFalse: [self expected: 'semicolon'].
        currentSource = str1
                ifFalse: [self expected: 'proper nesting of entity references within other entity references'].

        ^self.

        exp := self dtd generalEntityAt: nm.
        exp == nil
                ifTrue: [
                         "/self warn: ('The general entity "<1s>" has not been defined'
                         "/                               expandMacrosWith: nm)
                        ].
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
                        "exp streamFor: self"].

    "Created: / 07-11-2006 / 21:09:05 / janfrog"
! !

!VWXMLReader::XMLParser methodsFor:'initialization'!

wrapStream:aStream protocol:protocolString name:name

    |protocol|

    protocolString notNil ifTrue:[
        protocol := protocolString.
    ] ifFalse:[
        protocol := aStream isExternalStream ifTrue:['file'] ifFalse:['internal']
    ].

    ^VWXMLReader::StreamWrapper
            stream: aStream
            protocol: protocol
            name: name
            entity: nil

    "Created: / 15-06-2005 / 15:05:38 / janfrog"
! !

!VWXMLReader::XMLParser methodsFor:'private'!

malformed: aString

    self xmlReader getErrorHandler fatalError: aString

    "Created: / 25-10-2005 / 13:09:07 / janfrog"
!

warn: aString

    self malformed: 'XML parser warning: ' , aString

    "Created: / 22-06-2005 / 10:12:49 / masca"
! !

!VWXMLReader class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xmlreaderimpl/XMLv2__VWXMLReader.st,v 1.4 2006-11-08 09:29:50 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

