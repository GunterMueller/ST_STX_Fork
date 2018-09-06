"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLParser subclass:#XMLParserStX
	instanceVariableNames:''
	classVariableNames:'CachedDTD'
	poolDictionaries:''
	category:'XML-VW-Parsing'
!


!XMLParserStX class methodsFor:'dtd caching'!

cachedDTDAt:anIdentifier ifAbsent:aBlock
    CachedDTD isNil ifTrue:[
	^ aBlock value.
    ].
    ^ CachedDTD at:anIdentifier ifAbsent:aBlock
!

cachedDTDAt:anIdentifier put:something
    CachedDTD isNil ifTrue:[
	CachedDTD := Dictionary new.
    ].
    ^ CachedDTD at:anIdentifier put:something
!

emptyAllCaches
	CachedDTD := nil
! !

!XMLParserStX methodsFor:'accessing'!

normalizeDtd
    ^ normalizeDtd
!

normalizeDtd:something
    normalizeDtd := something.
! !

!XMLParserStX methodsFor:'attribute def processing'!

attType

	| nm all type |
	hereChar == $(
		ifTrue: [^self enumeration]
		ifFalse:
			[nm := self getSimpleName.
			all := #(NOTATION CDATA ID
						IDREF IDREFS
						ENTITY ENTITIES
						NMTOKEN NMTOKENS).
			(all includes: nm)
				ifFalse: [self expected: 'one of ', all storeString].

			type := #(NOTATION_AT CDATA_AT ID_AT
						IDREF_AT IDREFS_AT
						ENTITY_AT ENTITIES_AT
						NMTOKEN_AT NMTOKENS_AT)
					at: (all indexOf: nm).
			nm = #NOTATION
				ifTrue: [^self completeNotationType]
				ifFalse: [^(self class environment at:type) new]].
! !

!XMLParserStX methodsFor:'dtd-processing'!

dtdFile:newURI
    "same as super but looks to see if there is already this dtd cached in a
    class variable"

    |uri str filename filetime cachedDTD|

    self documentNode noteExternalDTD.
    "So we don't lose hereChar."
    currentSource skip:-1.
    uri := self uriResolver resolve:newURI last from:self latestURI.

    "first try if up-to-date external DTD is in our cache"
    uri key = 'file' ifTrue:[
	|nm|

	nm := uri value copy.
	"Do some other massaging?"
	nm replaceAll:$/ with:Filename separator.
	filename := nm asFilename asAbsoluteFilename withEncoding:#'UTF_8'.
	filetime := filename modificationTime.
	cachedDTD := (self class cachedDTDAt:filename ifAbsent:[]).
	(cachedDTD notNil and:[cachedDTD first = filetime]) ifTrue:[
	    dtd := cachedDTD second.
	    currentSource skip:1.
	    ^ self
	].
    ].
    self pushSource:(str := StreamWrapper
			stream:(self uriResolver openStreamOn:uri)
			protocol:uri key
			name:uri value
			entity:nil).
    str usedAsExternal:true.
    str textDeclIn:self.
    self getNextChar.
    [
	self fullSourceStack includes:str
    ] whileTrue:[ self dtdEntry ].
    filetime notNil ifTrue:[
	"put dtd in cache only if there is a real dtd file"
	self class cachedDTDAt:filename put:(Array with:filetime with:dtd).
    ]
! !

!XMLParserStX class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLParserStX.st,v 1.22 2015-02-14 03:23:36 cg Exp $'
! !
