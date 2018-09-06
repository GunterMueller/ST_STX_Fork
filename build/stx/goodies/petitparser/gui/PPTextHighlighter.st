"{ Package: 'stx:goodies/petitparser/gui' }"

Object subclass:#PPTextHighlighter
	instanceVariableNames:'parser attributeMapper'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPTextHighlighter methodsFor:'accessing'!

attributeMapper 
	"returns a dictionary with keys corresponding to parser names and 
	values corresponding to a collection of TextAttributes"
	^ attributeMapper
!

attributeMapper: aDictionary 
	attributeMapper := aDictionary
!

parser
	^ parser
!

parser: aParser
	parser := aParser
! !

!PPTextHighlighter methodsFor:'initialization'!

initialize
	parser := #any asParser.
	attributeMapper := Dictionary new
! !

!PPTextHighlighter methodsFor:'public'!

addAttribute: aTextAttribute for: anElementString 
	| attributes |
	attributes := self attributeMapper at: anElementString ifAbsentPut: [OrderedCollection new].
	attributes add: aTextAttribute
!

bold: anElementString
	self addAttribute: TextEmphasis bold for: anElementString
!

color: anElementString with: aColor
	self addAttribute: (TextColor new color: aColor) for: anElementString
!

highlight: aString
	| text highlighter |
	text := aString asText.
	highlighter := parser transform: [ :p |
		attributeMapper at: p name
			ifPresent: [ :attributes | 
				p token ==> [ :token | 
					attributes do: [:each |
						text 
							addAttribute: each 
							from: token start 
							to: token stop ] ] ]
			ifAbsent: [ p ] ].
	highlighter parse: text.
	^ text
! !

!PPTextHighlighter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPTextHighlighter.st,v 1.1 2014-03-04 21:15:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPTextHighlighter.st,v 1.1 2014-03-04 21:15:00 cg Exp $'
! !

