"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

SmaCCRegularExpressionNode subclass:#SmaCCCharacterRENode
	instanceVariableNames:'characters'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Scanner Generator'
!

SmaCCCharacterRENode comment:'SmaCCCharacterRENode represents a regular expression that matches one of a set of characters.

Instance Variables:
	characters	<SortedCollection of: Character>	The characters that this node can accept. Note that there are no duplicates and all characters are sorted.

'
!


!SmaCCCharacterRENode class methodsFor:'instance creation'!

characters: aString 
	^(self new)
		characters: (self sortedCharactersFor: aString);
		yourself
! !

!SmaCCCharacterRENode class methodsFor:'private'!

sortedCharactersFor: aString 
        | characters stream |
        SmaCCGrammar ignoreCase 
                ifTrue: 
                        [stream := WriteStream on: UnicodeString new.
                        aString do: 
                                        [:each | 
                                        stream
                                                nextPut: each asUppercase;
                                                nextPut: each asLowercase]]
                ifFalse: 
                        [stream := WriteStream on: (UnicodeString new: aString size).
                        stream nextPutAll: aString].
        characters := stream contents 
                                asSortedCollection: [:a :b | a asInteger < b asInteger].
        stream := WriteStream on: UnicodeString new.
        characters inject: nil
                into: 
                        [:sum :each | 
                        sum = each ifFalse: [stream nextPut: each].
                        each].
        ^stream contents

    "Modified: / 26-05-2006 / 22:17:33 / janfrog"
! !

!SmaCCCharacterRENode methodsFor:'accessing'!

possibleMatchesSize
	^self matchingCharacters size
!

| aScannerNode 
	(self canMergeWith: aScannerNode) ifFalse: [^super | aScannerNode].
	characters := String 
				withAll: ((characters , aScannerNode characters) asSet 
						asSortedCollection: [:a :b | a asInteger < b asInteger]).
	^self
! !

!SmaCCCharacterRENode methodsFor:'initialize-release'!

characters: aString 
	characters := aString
! !

!SmaCCCharacterRENode methodsFor:'printing'!

printCharacter: aCharacter on: aStream
	(aCharacter asInteger between: 32 and: 126) ifTrue: [^aStream nextPut: aCharacter].
	aStream nextPutAll: '\x'.
	aCharacter asInteger 
		printOn: aStream
		base: 16
		showRadix: false
!

printOn: aStream 
	| allCharacters |
	characters size = 1 
		ifTrue: [^self printCharacter: characters first on: aStream].
	aStream nextPut: $[.
	allCharacters := characters.
	characters size > 128 
		ifTrue: 
			[aStream nextPut: $^.
			allCharacters := ((0 to: SmaCCGrammar maximumCharacterValue) 
						collect: [:each | Character value: each]) 
							reject: [:each | characters includes: each]].
	allCharacters do: [:each | self printCharacter: each on: aStream].
	aStream nextPut: $]
! !

!SmaCCCharacterRENode methodsFor:'private'!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	startNode addEdgeTo: endNode on: characters.
	^endNode
!

characters
	^characters
!

matchingCharacters
	^SmaCCGrammar ignoreCase 
		ifTrue: [characters reject: [:each | each isLowercase]]
		ifFalse: [characters]
!

possibleMatchesDo: aBlock on: aStream 
	self matchingCharacters do: 
			[:each | 
			aStream nextPut: each.
			aBlock value.
			aStream skip: -1]
! !

!SmaCCCharacterRENode methodsFor:'public'!

canMergeWith: aScannerNode 
	^self class = aScannerNode class and: 
			[characters notNil 
				and: [aScannerNode characters notNil and: [self action = aScannerNode action]]]
! !

!SmaCCCharacterRENode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCCharacterRENode.st,v 1.2 2006-05-28 20:10:18 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
