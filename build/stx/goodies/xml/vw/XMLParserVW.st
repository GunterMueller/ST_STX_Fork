"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

XMLParser subclass:#XMLParserVW
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!


!XMLParserVW methodsFor:'attribute def processing'!

attType

	| nm all type |
	^hereChar = $(
		ifTrue: [self enumeration]
		ifFalse:
			[nm := self getSimpleName.
			all := #('NOTATION' 'CDATA' 'ID'
						'IDREF' 'IDREFS'
						'ENTITY' 'ENTITIES'
						'NMTOKEN' 'NMTOKENS').
			(all includes: nm)
				ifFalse: [self expected: 'one of ', all storeString].
			type := #(#{NOTATION_AT} #{CDATA_AT} #{ID_AT}
						#{IDREF_AT} #{IDREFS_AT}
						#{ENTITY_AT} #{ENTITIES_AT}
						#{NMTOKEN_AT} #{NMTOKENS_AT})
					at: (all indexOf: nm).
			nm = 'NOTATION'
				ifTrue: [self completeNotationType]
				ifFalse: [type value new]].

! !

!XMLParserVW class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLParserVW.st,v 1.5 2004-03-19 13:28:17 stefan Exp $'
! !

XMLParserVW initialize!
