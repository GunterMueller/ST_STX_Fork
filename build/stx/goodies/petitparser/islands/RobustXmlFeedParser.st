"{ Package: 'stx:goodies/petitparser/islands' }"

"{ NameSpace: Smalltalk }"

XmlFeedParser subclass:#RobustXmlFeedParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Examples'
!

RobustXmlFeedParser comment:'A RobustXmlFeedParser is XmlFeedParser, that can handle error within an xml Item element'
!


!RobustXmlFeedParser methodsFor:'as yet unclassified'!

itemContent
	^ ((simpleElement island ==> #second) star) ==> self elementsToDictionaryBlock
! !

!RobustXmlFeedParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

