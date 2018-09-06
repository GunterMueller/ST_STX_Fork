"{ Package: 'stx:goodies/petitparser/islands/tests' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#XmlFeedParserTest
	instanceVariableNames:'debugResult'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitIslands-Examples'
!

!XmlFeedParserTest methodsFor:'as yet unclassified'!

debug: aString rule: aSymbol
	| production |
	production := self parserInstanceFor: aSymbol.
	debugResult := production end debug: aString.
	result := debugResult children first result.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result
!

feed01
^'
<shoplist>
<name>ABC Shop</name>
<address>Here and there 123, 123 45 Somewhere</address>
<item>
  <name>socks</name>
  <price>123</price>
  <availability>1</availability>
</item>
</shoplist>
'
!

feed02
^'
<shoplist>
<name>ABC Shop</name>
<address>Here and there 123, 123 45 Somewhere</address>
<item>
  <name>socks</name>
  <price>123</price>
  <availability>1</availability>
</item>


<item>
  <name> shoes </name>
  <price>2345</price>
  <availability>1</availability>
</item>

</shoplist>
'
!

feed03
^'
<shoplist>
<name>ABC Shop</name>
<address>Here and there 123, 123 45 Somewhere</address>
<item>
  <name>socks</name>
  <price>123</price>
  <availability>1</availability>
</item>


<item>
  <name> shoes </name>
  <price>2345</price>
  <!!-- this one is malformed -->
  <availability>1 </
</item>

<item>
  <name> shoes </name>
  <price>3456</price>
  <availability>0</availability>
</item>


</shoplist>
'
!

parse: aString rule: aSymbol to: anObject
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production end parse: aString.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	self assert: result = anObject.
	
	^ result
!

parserClass
	^ XmlFeedParser
!

testItem
	self testItem01.
	self testItem02.
	self testItem03.
	
!

testItem01
	self debug: '
	<item>
		<name>abc</name>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	
!

testItem02
	self debug: '
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	self assert: (result at: #price) = '123'.
	
!

testItem03
	self debug: '
	<item>
		<price>123</price>
		<name>abc</name>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	self assert: (result at: #price) = '123'.
	
!

testShoplist
	self testShoplist01.
	self testShoplist02.
	self testShoplist03.
!

testShoplist01
	self debug: '
<shoplist>
	<item>
		<name>abc</name>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 1.
	
!

testShoplist02
	self debug: '
<shoplist>
	<name>xyz</name>
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 1.
	
!

testShoplist03
	self debug: '
<shoplist>
	<name>xyz</name>
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
	<item>
		<name>cde</name>
		<price>345</price>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 2.
	
!

testSimpleElement
	self parse: '<a>b</a>' rule: #simpleElement to: #('a' 'b').	
	self parse: '<abc> def </ abc>' rule: #simpleElement to: #('abc' 'def').	
		
	self fail: '<a>b</b>' rule: #simpleElement.
	
!

testStringValue
	self parse: 'abc' rule: #stringValue to: 'abc'.	
	self parse: ' def ' rule: #stringValue to: 'def'.
	
!

testXmlFeed01
	self parse: self feed01.
	
	self assert: result size = 1.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.
	
!

testXmlFeed02
	self parse: self feed02.
	
	self assert: result size = 2.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.

	self assert: (result second at:#name) = 'shoes'.
	self assert: (result second at:#price) = '2345'.
	self assert: (result second at:#availability) = '1'.
	
!

testXmlFeed03
	self parse: self feed03.
	
	self assert: result size = 2.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.

	self assert: (result second at:#name) = 'shoes'.
	self assert: (result second at:#price) = '3456'.
	self assert: (result second at:#availability) = '0'.
	
! !

