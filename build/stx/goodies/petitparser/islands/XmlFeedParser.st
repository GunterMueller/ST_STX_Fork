"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

PPCompositeParser subclass:#XmlFeedParser
	instanceVariableNames:'item openItem itemContent closeItem openShoplist shoplistContent
		closeShoplist shoplist simpleElement stringValue'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Examples'
!

XmlFeedParser comment:'A XmlFeedParser is Parser of a fake shop feed. Shop feed is a XML file with information about shop products. Shop feed can be malformed (for any reason) the parser will recover from malformed item and will continue on the next valid item.
!

!XmlFeedParser methodsFor:'grammar'!

item
	^ (openItem, itemContent trim, closeItem) trim ==> #second
!

itemContent
	^ (simpleElement trim star) ==> self elementsToDictionaryBlock
!

shoplist
	^ (openShoplist, shoplistContent, closeShoplist) trim ==> #second
!

shoplistContent
	^ (item island ==> #second) star
!

start
	^ shoplist
!

stringValue
	^ (#letter asParser / #digit asParser) star flatten trim
! !

!XmlFeedParser methodsFor:'tags'!

closeItem
	^ '</' asParser, 'item' asParser trim, '>' asParser
!

closeShoplist
	^ '</' asParser, 'shoplist' asParser trim, '>' asParser
!

openItem
	^ '<' asParser, 'item' asParser trim, '>' asParser
!

openShoplist
	^ '<' asParser, 'shoplist' asParser trim, '>' asParser
! !

!XmlFeedParser methodsFor:'xmlSupport'!

elementsToDictionaryBlock
 	^ [ :elements | | d | 
		d := Dictionary new.
		elements do: [ :e | d at: e first asSymbol put: e second ].
		d
	]
!

simpleElement
	^ (
		(('<' asParser, stringValue trim, '>' asParser) ==> #second),
		stringValue,
		(('</' asParser, stringValue trim, '>' asParser) ==> #second)
	) ==> [ :elements |
		(elements first = elements third) 
		ifTrue: [ Array with: elements first with: elements second ]
		ifFalse: [ PPFailure message: 'malformed element' ]
 	]
! !
