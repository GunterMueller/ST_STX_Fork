"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

TestCase subclass:#OXSAXTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Testing'
!


!OXSAXTests methodsFor:'basic sax tests'!

sampleNameSpaceDocument
	^'<?xml version="1.0" encoding="us-ascii"?>
<doc xmlns="http://www.doc.org/" xmlns:other="http://www.other.com/">
	<a>A text</a>
	<a1></a1>
	<b>
		<other:ba>BA text</other:ba>
	</b>
	<c other:cat="meow">C text</c>
	<d xmlns="http:/nested/">
		<e>E text</e>
	</d>
</doc>'
!

sampleSAXDocument
	^'<!!DOCTYPE doc [
<!!ELEMENT doc (foo*)>
<!!ELEMENT foo (#PCDATA)>
<!!ATTLIST doc a1 CDATA #IMPLIED a2 CDATA #IMPLIED>
]>
<?pi?>
<doc a1 = "v1"   a2 = "v2"  >
	<!!-- a comment --><foo>this   is
a test</foo>
	<foo></foo>
	<foo>
second

</foo>
<foo/>
</doc>'
!

testExternalEntity
	| result client answer inputFile |
	#() do: 
			[:fileIndex | 
			inputFile := self validXMLFile: fileIndex type: 'ext-sa'.
			self halt.
			client := OXSAXTestDriver processDocumentInFilename: inputFile
						beforeScanDo: [:parser | parser validate: false].
			result := client document contents.
			answer := self validAnswer: fileIndex type: 'ext-sa'.
			self assert: result = answer]
!

testLocator
	| text stream locator |
	text := '
123
456

7
'.
	stream := ReadStream on: text.
	locator := SAXLocator on: stream.
	self assert: locator lineNumber = 1.
	self assert: locator columnNumber = 0.
	stream next.
	self assert: locator lineNumber = 1.
	self assert: locator columnNumber = 1.
	stream skipThrough: $3.
	self assert: locator lineNumber = 2.
	self assert: locator columnNumber = 3.
	stream next.
	self assert: locator lineNumber = 2.
	self assert: locator columnNumber = 4.
	stream next.
	self assert: locator lineNumber = 3.
	self assert: locator columnNumber = 1
!

testNameSpace
	| result client answer |
	client := OXSAXTestDriver 
				processDocumentString: self sampleNameSpaceDocument
				beforeScanDo: [:parser | parser validate: false].
	result := client document contents.
	answer := 'Start document
<http://www.doc.org/:doc :xmlns=http://www.doc.org/ <!!-- xml namespace -->:other=http://www.other.com/>
<http://www.doc.org/:a >
A text</a>
<http://www.doc.org/:a1 >
</a1>
<http://www.doc.org/:b >
<http://www.other.com/:ba >
BA text</ba>
</b>
<http://www.doc.org/:c http://www.other.com/:cat=meow>
C text</c>
<http:/nested/:d :xmlns=http:/nested/>
<http:/nested/:e >
E text</e>
</d>
</doc>
End document
'.
	self assert: result = answer
!

testSAXBuilder
	| result client answer |
	client := OXSAXTestDriver processDocumentString: self sampleSAXDocument
				beforeScanDo: [:parser | parser validate: false].
	result := client document contents.
	answer := 'Start document
<? pi ?>
<:doc :a1=v1 :a2=v2>
<:foo >
thisisa test</foo>
<:foo >
</foo>
<:foo >
second</foo>
<:foo >
</foo>
</doc>
End document
'.
	self assert: result = answer
! !

!OXSAXTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/OXSAXTests.st,v 1.3 2003-04-23 08:44:17 cg Exp $'
! !
