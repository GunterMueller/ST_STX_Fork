"{ Package: 'stx:goodies/magritte/tests' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MAExtensionsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Utility'
!


!MAExtensionsTest methodsFor:'testing-collection'!

testCopyWithAll
	| col res |
	col := #( a b ).
	res := col copyWithAll: #( c d ).
	self assert: res = #( a b c d ).
	self deny: col == res.

	col := Set with: #a with: #b.
	res := col copyWithAll: #( c d ).
	self assert: (res size = 4).
	self assert: (res includes: #a).
	self assert: (res includes: #b).
	self assert: (res includes: #c).
	self assert: (res includes: #d).
	self deny: col == res.

	col := OrderedCollection with: #a with: #b.
	res := col copyWithAll: #( c d ).
	self assert: res = (OrderedCollection with: #a with: #b with: #c with: #d).
	self deny: col == res
!

testCopyWithoutFirst
	| col res |
	col := #( a b a c ).
	res := col copyWithoutFirst: #a.
	self assert: res = #( b a c ).
	self deny: col == res.

	col := Set with: #a with: #b with: #c.
	res := col copyWithoutFirst: #a.
	self assert: res size = 2.
	self assert: (res includes: #b).
	self assert: (res includes: #c).
	self deny: col == res
!

testHasEqualElements
	| one two |
	one := #( 1 2 3 ).

	two := #( 1 2 3 ) asOrderedCollection.
	self assert: (one hasEqualElements: two).
	self assert: (two hasEqualElements: one).
	
	two := #( 1 2 4 ).
	self deny: (one hasEqualElements: two).
	self deny: (two hasEqualElements: one).
	
	two := #( 1 2 3 4 ).
	self deny: (one hasEqualElements: two).
	self deny: (two hasEqualElements: one).
	
!

testIntersection
	| group |
	group := #( 1 2 3 ).
	
	self assert: ((group intersection: group) hasEqualElements: group).
	self assert: ((group intersection: #( )) hasEqualElements: #( )).
	self assert: ((group intersection: #( 4 5 )) hasEqualElements: #( )).
	self assert: ((group intersection: #( 1 3 4 5 )) hasEqualElements: #( 1 3 )).
	self assert: ((group intersection: #( 2 )) hasEqualElements: #( 2 ))
!

testIsCollection
	self deny: Object new isCollection.
	self deny: nil isCollection.
	self deny: 123 isCollection.
	self assert: 'abc' isCollection.
	self assert: #(a b c) isCollection
!

testMoveDown
	| col |
	col := Array with: 1 with: 2 with: 3.

	self assert: (col moveDown: 1) = 2.
	self assert: col = #( 2 1 3 ).

	self assert: (col moveDown: 1) = 3.
	self assert: col = #( 2 3 1 ).

	self assert: (col moveDown: 1) = 3.
	self assert: col = #( 2 3 1 ).

	self assert: (col moveDown: 0) = 0.
	self assert: col = #( 2 3 1 )
!

testMoveUp
	| col |
	col := Array with: 1 with: 2 with: 3.

	self assert: (col moveUp: 3) = 2.
	self assert: col = #( 1 3 2 ).

	self assert: (col moveUp: 3) = 1.
	self assert: col = #( 3 1 2 ).

	self assert: (col moveUp: 3) = 1.
	self assert: col = #( 3 1 2 ).

	self assert: (col moveUp: 0) = 0.
	self assert: col = #( 3 1 2 )
!

testReduce
	self assert: (#() reduce: [ :a :b | a ]) isNil.
	self assert: ((1 to: 9) reduce: [ :a :b | a ]) = 1.
	self assert: ((1 to: 9) reduce: [ :a :b | b ]) = 9.
	self assert: ((1 to: 9) reduce: [ :a :b | a + b ]) = 45.
	self assert: ((1 to: 9) reduce: [ :a :b | a * b ]) = 362880.
	self assert: (#('a' 'b' 'c') reduce: [ :a :b | a , ' ' , b ]) = 'a b c'.
	self assert: (#('a' 'b' 'c') reduce: [ :a :b | b , ' ' , a ]) = 'c b a'
!

testSort
	| array |
	array := Array with: 2 with: 3 with: 1.

	array sort: [ :a :b | a < b ].
	self assert: (array hasEqualElements: #( 1 2 3 )).

	array sort: [ :a :b | a > b ].
	self assert: (array hasEqualElements: #( 3 2 1 ))
! !

!MAExtensionsTest methodsFor:'testing-errors'!

testValidationError
        | result |
        result := [ MARequiredError signal: 'some message' ]
                on: MARequiredError
                do: [ :err | err displayString ].
        self assert: result = 'some message'.
        result := [
                MARequiredError 
                        description: (MAStringDescription new 
                                label: 'label';
                                yourself) 
                        signal: 'some message' ] 
                on: MARequiredError
                do: [ :err | err displayString ].
        self assert: result = 'label: some message'
! !

!MAExtensionsTest methodsFor:'testing-integer'!

testFileSize
	self assert: (1000) asFileSize = '1000 B'.
	self assert: (1024) asFileSize = '1 KB'.

	self assert: (1000 * 1000) asFileSize = '976 KB'.
	self assert: (1024 * 1024) asFileSize = '1 MB'.

	self assert: (1000 * 1000 * 1000) asFileSize = '953 MB'.
	self assert: (1024 * 1024 * 1024) asFileSize = '1 GB'.

	self assert: (1000 * 1000 * 1000 * 1000) asFileSize = '931 GB'.
	self assert: (1024 * 1024 * 1024 * 1024) asFileSize = '1 TB'.

	" etc "
! !

!MAExtensionsTest methodsFor:'testing-string'!

testAsString
	self assert: Object new asString = Object new printString.
	self assert: 'Hello World' asString = 'Hello World'.
	self assert: 123 asString = '123'
	
!

testIsUnary
	self assert: #testIsUnary isUnary.
	self deny: #+ isUnary.
	self deny: #with:with: isUnary.	
!

testLines
	self assert: ('') lines = #().
	self assert: ('foo') lines = #('foo').
	self assert: ('foo' , (String with: Character cr) , 'bar') lines = #('foo' 'bar').
	self assert: ('foo' , (String with: Character cr with: Character lf) , 'bar') lines = #('foo' 'bar')
!

testMatches
	self assert: ('' matches: '').
	self assert: ('zort' matches: '').
	self assert: ('zort' matches: 'o').
	self assert: ('zort' matches: 'O').
	self assert: ('zort' matches: '*').
	self assert: ('mobaz' matches: '*baz').
	self deny: ('mobazo' matches: '*baz').
	self assert: ('mobazo' matches: '*baz*').
	self deny: ('mozo' matches: '*baz*').
	self assert: ('foozo' matches: 'foo*').
	self deny: ('bozo' matches: 'foo*').
	self assert: ('foo23baz' matches: 'foo*baz').
	self assert: ('foobaz' matches: 'foo*baz').
	self deny: ('foo23bazo' matches: 'foo*baz').
	self assert: ('Foo' matches: 'foo').
	self deny: ('foobazort' matches: 'foo*baz*zort').
	self assert: ('foobazzort' matches: 'foo*baz*zort').
	self assert: ('afoo3zortthenfoo3zort' matches: '*foo#zort').
	self assert: ('afoodezortorfoo3zort' matches: '*foo*zort')
!

testSubstringCaseSensitive
	self deny: ('' includesSubstring: '' caseSensitive: true).
	self deny: ('' includesSubstring: '' caseSensitive: false).

	self deny: ('abc' includesSubstring: '' caseSensitive: true).
	self deny: ('abc' includesSubstring: '' caseSensitive: false).

	self deny: ('' includesSubstring: 'abc' caseSensitive: true).
	self deny: ('' includesSubstring: 'abc' caseSensitive: false).

	self deny: ('abc' includesSubstring: 'aa' caseSensitive: true).
	self deny: ('abc' includesSubstring: 'cc' caseSensitive: false).
	self deny: ('abc' includesSubstring: 'aB' caseSensitive: true).

	self assert: ('abc' includesSubstring: 'a' caseSensitive: true).
	self assert: ('abc' includesSubstring: 'c' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'aB' caseSensitive: false).

	self assert: ('abc' includesSubstring: 'AbC' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'ABC' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'aBc' caseSensitive: false)
! !

!MAExtensionsTest methodsFor:'testing-time'!

testTimePrintOn
	| stream |
	stream := String new writeStream.
	Time now print24: true showSeconds: true on: stream.
	
	self assert: (stream contents size) = 8.
	self assert: (stream contents at: 3) = $:.
	self assert: (stream contents at: 6) = $:
! !

!MAExtensionsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAExtensionsTest.st,v 1.2 2009-07-30 08:01:12 cg Exp $'
! !
