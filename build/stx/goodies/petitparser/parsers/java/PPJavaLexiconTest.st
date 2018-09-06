"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPCompositeParserTest subclass:#PPJavaLexiconTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Tests'
!

!PPJavaLexiconTest methodsFor:'accessing'!

parserClass
	^ PPJavaLexicon
! !

!PPJavaLexiconTest methodsFor:'testing'!

testIdentifier6

	self
		fail: 'super'
		rule: #identifier
! !

!PPJavaLexiconTest methodsFor:'testing-comments'!

testComment1

	self 
		parse: '//'
		rule: #comment
!

testComment2

	self 
		parse: '//comment'
		rule: #comment
!

testComment3

	self 
		parse: '// comment'
		rule: #comment
!

testComment4

	self 
		parse: '/* comment */'
		rule: #comment
!

testComment5

	self 
		fail: '/* comment '
		rule: #comment
!

testComment6

	self 
		parse: '/* this comment /* // /** ends here: */'
		rule: #comment
!

testComment7

	self 
		parse: '/**
     * @param args 
     * @return void
     */'
		rule: #comment
!

testComment8cr

        self 
                parse: '/*',(Character codePoint: 13),'*/'
                rule: #comment

    "Created: / 21-04-2015 / 17:07:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment8crlf

        self 
                parse: '/*',(Character codePoint: 13),(Character codePoint: 10),'*/'
                rule: #comment

    "Created: / 21-04-2015 / 17:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testComment8lf

        self 
                parse: '/*',(Character codePoint: 10),'*/'
                rule: #comment

    "Created: / 21-04-2015 / 17:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testTraditionalComment1

	self 
		parse: '/* this comment */'
		rule: #traditionalComment
!

testTraditionalComment2

	self 
		parse: '/* this comment / */'
		rule: #comment
! !

!PPJavaLexiconTest methodsFor:'testing-identifiers'!

testIdentifier1

	self
		parse: 'String'
		rule: #identifier
!

testIdentifier2

	self
		parse: 'i3'
		rule: #identifier
!

testIdentifier3

	self
		parse: 'αρετη'
		rule: #identifier
!

testIdentifier4

	self
		parse: 'MAX_VALUE'
		rule: #identifier
!

testIdentifier5

	self
		parse: 'isLetterOrDigit'
		rule: #identifier
! !

!PPJavaLexiconTest methodsFor:'testing-input'!

testInput1

	self parse: 'package testPackage;
						class Test {
        				public static void main(String[] args) {
                			String hello = "Hello", lo = "lo";
                			System.out.print((hello == "Hello") + " ");
                			System.out.print((Other.hello == hello) + " ");
                			System.out.print((other.Other.hello == hello) + " ");
                			System.out.print((hello == ("Hel"+"lo")) + " ");
                			System.out.print((hello == ("Hel"+lo)) + " ");
                			System.out.println(hello == ("Hel"+lo).intern());
        				}
						}
						class Other { static String hello = "Hello"; }'
	rule: #input
!

testInput2

	self parse: 'package other;
						public class Other { static String hello = "Hello"; }'
	rule: #input
!

testInput3

	self parse: 'class Value { int val; }	
						class Test {
        				public static void main(String[] args) {
              			int i1 = 3;
                		int i2 = i1;
                		i2 = 4;
                		System.out.print("i1==" + i1);
                		System.out.println(" but i2==" + i2);
                		Value v1 = new Value();
                		v1.val = 5;
                		Value v2 = v1;
                		v2.val = 6;
                		System.out.print("v1.val==" + v1.val);
                		System.out.println(" and v2.val==" + v2.val);
        				}
						}'
	rule: #input
! !

!PPJavaLexiconTest methodsFor:'testing-lineTerminators'!

testInputCharacter1

	self
		parse: '\'
		rule: #inputCharacter
!

testInputCharacter2

	self
		fail: (Character cr asString)
		rule: #inputCharacter
!

testInputCharacter3

	self
		fail: (Character lf asString)
		rule: #inputCharacter
!

testLineTerminator1

	self
		parse: (Character lf asString)
		rule: #lineTerminator
!

testLineTerminator2

	self
		parse: (Character cr asString)
		rule: #lineTerminator
!

testLineTerminator3

        self
                parse: (Character codePoint: 13) asString , (Character codePoint: 10) asString
                rule: #lineTerminator

    "Modified: / 21-04-2015 / 15:47:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testLineTerminator4

	self
		fail: (Character space asString)
		rule: #lineTerminator
!

testLineTerminator5

	self
		fail: ('a' asString)
		rule: #lineTerminator
! !

!PPJavaLexiconTest methodsFor:'testing-literal-float'!

testFloatLiteral1
	self 
		parse: '1e1f'
		rule: #floatingPointLiteral
!

testFloatLiteral10
	self 
		parse: '0.0'
		rule: #floatingPointLiteral
!

testFloatLiteral11
	self 
		parse: '3.14'
		rule: #floatingPointLiteral
!

testFloatLiteral12
	self 
		parse: '1e-9d'
		rule: #floatingPointLiteral
!

testFloatLiteral13
	self 
		parse: '1e137'
		rule: #floatingPointLiteral
!

testFloatLiteral2
	self 
		parse: '2.f'
		rule: #floatingPointLiteral
!

testFloatLiteral3
	self 
		parse: '.3f'
		rule: #floatingPointLiteral
!

testFloatLiteral4
	self 
		parse: '0f'
		rule: #floatingPointLiteral
!

testFloatLiteral5
	self 
		parse: '3.14f'
		rule: #floatingPointLiteral
!

testFloatLiteral6
	self 
		parse: '6.022137e+23f'
		rule: #floatingPointLiteral
!

testFloatLiteral7
	self 
		parse: '1e1'
		rule: #floatingPointLiteral
!

testFloatLiteral8
	self 
		parse: '2.'
		rule: #floatingPointLiteral
!

testFloatLiteral9
	self 
		parse: '.3'
		rule: #floatingPointLiteral
! !

!PPJavaLexiconTest methodsFor:'testing-literals'!

testBooleanLiteral1
	self 
		parse: 'true'
		rule: #booleanLiteral
!

testBooleanLiteral2
	self 
		parse: 'false'
		rule: #booleanLiteral
!

testLiteral1

	self 
		parse: 'null'
		rule: #literal
!

testLiteral10

	self 
		fail: '0777 L'
		rule: #literal
!

testLiteral11

	self 
		fail: '0777 0'
		rule: #literal
!

testLiteral12

	self 
		fail: '0 x'
		rule: #literal
!

testLiteral13

	self 
		parse: '"This is a Java string"'
		rule: #literal
!

testLiteral2

	self 
		parse: 'false'
		rule: #literal
!

testLiteral3

	self 
		parse: '6.022137e+23f'
		rule: #literal
!

testLiteral4

	self 
		parse: '1e1'
		rule: #literal
!

testLiteral5

	self 
		parse: '0x100000000L'
		rule: #literal
!

testLiteral6

	self 
		parse: '0372'
		rule: #literal
!

testLiteral7

	self 
		parse: '0xDadaCafe'
		rule: #literal
!

testLiteral8

	self 
		parse: '0x00FF00FF'
		rule: #literal
!

testLiteral9

	self 
		parse: '0777L'
		rule: #literal
!

testNullLiteral1

	self 
		parse: 'null'
		rule: #nullLiteral
!

testStringLiteral1

	self 
		parse: '""'
		rule: #stringLiteral
!

testStringLiteral10

	self 
		fail: '"This is a \\
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral11

	self 
		parse: '"null"'
		rule: #stringLiteral
!

testStringLiteral2

	self 
		parse: '"\""'
		rule: #stringLiteral
!

testStringLiteral3

	self 
		parse: '"This is a Java string"'
		rule: #stringLiteral
!

testStringLiteral4

	self 
		fail: '"This is a 
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral5

	self 
		fail: '"This is a \b
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral6

	self 
		fail: '"This is a \t
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral7

	self 
		fail: '"This is a \n
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral8

	self 
		fail: '"This is a \f
				two lines Java string"'
		rule: #stringLiteral
!

testStringLiteral9

	self 
		fail: '"This is a \r
				two lines Java string"'
		rule: #stringLiteral
! !

!PPJavaLexiconTest methodsFor:'testing-literals-characters'!

testCharacterLiteral1
	self 
		parse: '''a'''
		rule: #characterLiteral
!

testCharacterLiteral2
	self 
		parse: '''%'''
		rule: #characterLiteral
!

testCharacterLiteral3
	self 
		parse: '''\t'''
		rule: #characterLiteral
!

testCharacterLiteral4
	self 
		parse: '''\\'''
		rule: #characterLiteral
!

testCharacterLiteral5
	self 
		parse: '''\'''''
		rule: #characterLiteral
!

testCharacterLiteral6
	"not clear how this must be supported
	(see http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.10.6)"
	
	"self 
		parse: '''\u03a9'''
		rule: #characterLiteral"
!

testCharacterLiteral7
	"not clear how this must be supported
	(see http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#3.10.6)"
	"
	self 
		parse: '''\uFFFF'''
		rule: #characterLiteral"
!

testCharacterLiteral8
	self 
		parse: '''\177'''
		rule: #characterLiteral
!

testSeparator1
	self 
		parse: '{'
		rule: #separator
! !

!PPJavaLexiconTest methodsFor:'testing-literals-integer'!

testHexIntegerLiteral1
	self 
		parse: '0xC0B0L'
		rule: #hexIntegerLiteral
!

testIntegerLiteral1
	self 
		parse: '0'
		rule: #integerLiteral
!

testIntegerLiteral10
	self 
		parse: '1996'
		rule: #integerLiteral
!

testIntegerLiteral11
	self 
		parse: '0x00FF00FF'
		rule: #integerLiteral
!

testIntegerLiteral2
	self 
		parse: '0l'
		rule: #integerLiteral
!

testIntegerLiteral3
	self 
		parse: '0777L'
		rule: #integerLiteral
!

testIntegerLiteral4
	self 
		parse: '0x100000000L'
		rule: #integerLiteral
!

testIntegerLiteral5
	self 
		parse: '2147483648L'
		rule: #integerLiteral
!

testIntegerLiteral6
	self 
		parse: '0xC0B0L'
		rule: #integerLiteral
!

testIntegerLiteral7
	self 
		parse: '2'
		rule: #integerLiteral
!

testIntegerLiteral8
	self 
		parse: '0372'
		rule: #integerLiteral
!

testIntegerLiteral9
	self 
		parse: '0xDadaCafe'
		rule: #integerLiteral
!

testOctalIntegerLiteral1
	self 
		parse: '0777L'
		rule: #octalIntegerLiteral
!

testOperator
	self 
		parse: '>'
		rule: #operator
! !

!PPJavaLexiconTest methodsFor:'testing-unicode'!

testUnicodeEscape1

	self
		parse: '\u0000'
		rule: #unicodeEscape
!

testUnicodeEscape2

	self
		fail: '\u000'
		rule: #unicodeEscape
!

testUnicodeEscape3

	self
		fail: '\u00000'
		rule: #unicodeEscape
!

testUnicodeInputCharacter1

	self
		parse: '\u0000'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter2

	self
		parse: '\'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter3

	self
		parse: 'µ'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter4

	self
		fail: '\\'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter5
	self
		parse: '\u2297'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter6
	self
		fail: '\u2H97'
		rule: #unicodeInputCharacter
!

testUnicodeInputCharacter7
"unicode value for \"
	self
		parse: '\u005a'
		rule: #unicodeInputCharacter
!

testWhiteSpace1
"Testing whiteSpace parser"
	self
		parse: (Character value: 12) asString
		rule: #whiteSpace
!

testWhiteSpace2
"Testing whiteSpace parser"
	self
		fail: 'WhiteSpace testing'
		rule: #whiteSpace
! !

