"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

SAXDriver subclass:#SAXWriter
	instanceVariableNames:'output textMap attrMap hasOpenTag normalizeText notations
		newNamespaces'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

SAXWriter comment:'SAXWriter is a kind of SAXDriver that converts SAX events back into textutal XML documents.

Instance Variables:
	attrMap	<Dictionary>	Lists the characters that are not allowed to appear literally in attributes, and maps them to their quoted form.
	hasOpenTag	<Boolean>	True if we are inside an element that has no content as yet. This allows us to know when we reach the end tag whether we can write the element as <x/> rather than <x></x>.
	newNamespaces	<nil | Dictionary>	Maps namespace qualifiers to URIs, for namespaces which the current element defines differently than its parent.
	normalizeText	<Boolean>	Should be true in almost all cases--can be false only if the "XML" document being parsed is actually not XML, in which case it may be legal to not quote characters such as $<.
	notations	<Collection>	List of notations defined in the document being parsed.
	output	<Stream>	Stream on which the XML is rendered as text.
	textMap	<Dictionary>	Lists the characters that are not allowed to appear literally in text, and maps them to their quoted form.

'
!


!SAXWriter methodsFor:'DTD handler'!

notationDecl: nameString publicID: publicIDString systemID: systemIDString 

	notations == nil ifTrue: [notations := OrderedCollection new].
	notations add: (Array with: nameString with: publicIDString with: systemIDString)
! !

!SAXWriter methodsFor:'content handler'!

characters: aString from: start to: stop

	| ch mapped |
	self closeOpenTag.
	normalizeText
		ifTrue: [start to: stop do: [:i |
				ch := aString at: i.
				mapped := textMap at: ch ifAbsent: [nil].
				mapped == nil
					ifTrue: [output nextPut: ch]
					ifFalse: [output nextPutAll: mapped]]]
		ifFalse: [output next: stop+1-start putAll: aString startingAt: start]
!

comment: data from: start to: stop

	output nextPutAll: '<!!--';
		next: stop+1-start putAll: data startingAt: start;
		nextPutAll: '-->'
!

endElement: namespaceURI localName: localName qName: name

	hasOpenTag == true
		ifTrue: [output nextPutAll: '/>']
		ifFalse: [output nextPutAll: '</', name, '>'].
	hasOpenTag := false.
!

processingInstruction: targetString data: dataString

	output nextPutAll: '<?';
		nextPutAll: targetString;
		space;
		nextPutAll: dataString;
		nextPutAll: '?>'
!

startDocument

	hasOpenTag := false
!

startDocumentFragment
	"Nonstandard extension to SAX"

	hasOpenTag := false
!

startElement: namespaceURI localName: localName qName: name attributes: attributes

        | val |
        notations == nil ifFalse: [self emitDTD: name].
        self closeOpenTag.
        output nextPut:$<.
        output nextPutAll: name.
        (self sort: attributes) do: [:att |
                output space.
                output nextPutAll: att tag asString.
                output nextPutAll:'="'.
                1 to: att value size do: [:i |
                        | ch mapped |

                        ch := att value at: i.
                        mapped := attrMap at: ch ifAbsent: [nil].
                        mapped == nil
                                ifTrue: [output nextPut:ch]
                                ifFalse: [output nextPutAll: mapped]].
                output nextPut:$"
            ].

        newNamespaces notNil ifTrue: [
            newNamespaces keys asSortedCollection do: [:key |
                output space.
                output nextPutAll: (key isEmpty ifTrue: ['xmlns'] ifFalse: ['xmlns:', key]).
                output nextPutAll: '="'.
                val := newNamespaces at: key.
                1 to: val size do: [:i |
                    | ch mapped |

                    ch := val at: i.
                    mapped := attrMap at: ch ifAbsent: [nil].
                    mapped == nil
                            ifTrue: [output nextPut: ch]
                            ifFalse: [output nextPutAll: mapped]
                ].
                output nextPut:$"
            ]
        ].
        newNamespaces := nil.
        hasOpenTag := true

    "Modified: / 17-02-2017 / 10:20:32 / stefan"
!

startPrefixMapping: prefix uri: uri 

	newNamespaces == nil
		ifTrue: [newNamespaces := Dictionary new].
	newNamespaces at: prefix put: uri.
! !

!SAXWriter methodsFor:'initialize'!

minimalCharacterMapping

	textMap := Dictionary new
		at: $< put: '&lt;';
		at: $& put: '&amp;';
		yourself.
	attrMap := Dictionary new
		at: $< put: '&lt;';
		at: $& put: '&amp;';
		at: $" put: '&quot;';
		yourself.
!

normalizeText: aBoolean

	normalizeText := aBoolean
!

output: aStream

	output := aStream.
	normalizeText := true.
	notations := nil.
	textMap == nil ifTrue: [self minimalCharacterMapping].
! !

!SAXWriter methodsFor:'private'!

closeOpenTag

        hasOpenTag == true
                ifTrue:
                        [output nextPut: $>.
                        hasOpenTag := false].

    "Modified: / 17-02-2017 / 10:15:37 / stefan"
!

emitDTD: name

	| list |
	output nextPutAll: '<!!DOCTYPE ';
		nextPutAll: name;
		nextPutAll: ' [';
		cr.
	list := notations asSortedCollection: [:a1 :a2 | a1 first < a2 first].
	list do: [:notation |
		self emitNotation: notation.
		output cr].
	output nextPutAll: ']>'; cr.
	notations := nil.
!

emitNotation: array
        output nextPutAll: '<!!NOTATION ';
                nextPutAll: (array at: 1);
                space;
                nextPutAll: ((array at: 2) == nil ifTrue: ['SYSTEM'] ifFalse: ['PUBLIC']).
        (array at: 2) == nil
                ifFalse: [output nextPutAll: ' ''';
                                nextPutAll: (array at: 2);
                                nextPut:$'].
        (array at: 3) == nil
                ifFalse: [output nextPutAll: ' ''';
                                nextPutAll: (array at: 3);
                                nextPut:$'].
        output nextPut: $>.

    "Modified: / 17-02-2017 / 10:44:07 / stefan"
!

sort: attributes

	^attributes asSortedCollection: [:a1 :a2 | a1 tag asString < a2 tag asString]
! !

!SAXWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXWriter.st,v 1.2 2017-02-17 10:13:41 stefan Exp $'
! !

