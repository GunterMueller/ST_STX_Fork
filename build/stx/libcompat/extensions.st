"{ Encoding: utf8 }"

"{ Package: 'stx:libcompat' }"!

!Behavior methodsFor:'Compatibility-Squeak'!

allSelectorsInProtocol:aProtocol
    "Return all selectors defined in this class that take this number of arguments."

    ^ self selectors
        select:[:sel | (self compiledMethodAt:sel) category = aProtocol]

    "
     SmallInteger allSelectorsInProtocol:#testing
     Behavior allSelectorsInProtocol:'Compatibility-Squeak'
    "

    "Created: / 01-07-2018 / 11:08:31 / Claus Gittinger"
! !

!Behavior methodsFor:'Compatibility-Squeak'!

defaultNameStemForInstances
    "Answer a basis for names of default instances of the receiver"

    ^ self name

! !

!Behavior methodsFor:'Compatibility-Squeak'!

kindOfSubclass
    "Answer a String that is the keyword that describes the receiver's kind
    of subclass, either a regular subclass, a variableSubclass, a
    variableByteSubclass, a variableWordSubclass, or a weakSubclass."

    self isWeakPointers ifTrue:[
	^ ' weakSubclass:'
    ].
    ^ ' ',self firstDefinitionSelectorPart

    "
     Array kindOfSubclass
     WeakArray kindOfSubclass
    "

    "Modified: / 12-09-2010 / 09:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Behavior methodsFor:'Compatibility-Squeak'!

setTraitComposition: aTraitComposition
    "
    | oldComposition |
    (self hasTraitComposition not and: [aTraitComposition isEmpty]) ifTrue: [^self].
    aTraitComposition assertValidUser: self.

    oldComposition := self traitComposition.
    self traitComposition: aTraitComposition.
    self applyChangesOfNewTraitCompositionReplacing: oldComposition.

    oldComposition traits do: [:each | each removeUser: self].
    aTraitComposition traits do: [:each | each addUser: self]
    "

    "Now, Smalltalk/X doesnt support traits"
    aTraitComposition notNil ifTrue:[
        self error:'Smalltalk/X doesn''t support traits!!'
    ].

    "Created: / 29-08-2010 / 08:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:20:36 / cg"
! !

!ByteArray methodsFor:'Compatibility-VW'!

asByteString
    "same as asString, for visualworks compatibility"
    
    ^ self asString
! !

!ChangeSet class methodsFor:'Compatibility-Squeak'!

uniqueNameLike: baseName

    ^self new name: baseName

    "Created: / 12-09-2010 / 09:29:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character methodsFor:'Compatibility-Squeak'!

asUnicode
    "the same as #codePoint"

    ^ asciivalue
! !

!Character methodsFor:'Compatibility-Squeak'!

charCode
    ^ asciivalue. "/ (self asInteger bitAnd: 16r3FFFFF).

    "Created: / 01-07-2018 / 00:54:08 / Claus Gittinger"
! !

!Character methodsFor:'Compatibility-Squeak'!

isSafeForHTTP
    "whether a character is 'safe', or needs to be escaped when used, eg, in a URL"
    "[GG]  See http://www.faqs.org/rfcs/rfc1738.html. ~ is unsafe and has been removed"
    ^ self charCode < 128
        and: [self isAlphaNumeric
              or: ['.-_' includes: (Character value: self charCode)]]

    "Created: / 01-07-2018 / 00:53:05 / Claus Gittinger"
! !

!CharacterArray methodsFor:'Compatibility-VW'!

asComposedText
    "ST-80 compatibility
     - ST/X does not (as today) support composedTexts."

    ^ ComposedText fromString:self string

    "Modified: 27.4.1996 / 13:30:30 / cg"
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

asOneByteString
    "return the receiver converted to a 'normal' string.
     Same as asSingleByteString - for Squeak/Pharo compatibility."

    ^ self asSingleByteString
! !

!CharacterArray methodsFor:'Compatibility-VW'!

asQualifiedReference
    ^ BindingReference pathString:(self string)

! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

asUrl
    "Same as asURL - for Squeak/Pharo compatibility."

    ^ self asURL
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

asWideString
    "return a two-byte string containing the same characters as the receiver.
     Same as asTwoByteString - for Squeak/Pharo compatibility."

    ^ self asTwoByteString

    "
     'abc' asWideString
    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

capitalized
    "same as asUppercaseFirst for Squeak/Pharo compatibility"

    ^ self asUppercaseFirst

    "
     'hello' capitalized
    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

caseInsensitiveLessOrEqual:aString
    "compare the receiver against the argument ignoring case differences
     For Squeak/Pharo compatibility"

    ^ (self compareCaselessWith:aString) <= 0
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

caseSensitiveLessOrEqual:aString
    "compare the receiver against the argument caring for case differences
     For Squeak/Pharo compatibility"

    ^ self <= aString
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

charactersExactlyMatching:aString
    "return the number of characters I share as a prefix with the argument, aString"

    |idx nMax|

    nMax :=(self size) min:(aString size).
    idx := 1.
    [idx <= nMax] whileTrue:[
        (self at:idx) = (aString at:idx) ifFalse:[
            ^ idx - 1
        ].
        idx := idx + 1.
    ].
    ^ nMax

    "
     'abc' charactersExactlyMatching:'abc'
     'abc' charactersExactlyMatching:'abcd'
     'abcd' charactersExactlyMatching:'abc'
     'abc' charactersExactlyMatching:'abd'
     'abc' charactersExactlyMatching:'xxx'
    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

convertToEncoding:nameOfEncoding
    "/ special case, because it is so common:
    nameOfEncoding = 'utf8' ifTrue:[^ self utf8Encoded].
    ^ (CharacterEncoder encoderFor:nameOfEncoding) encodeString:self.

    "
     'hellöäü' convertToEncoding:'utf8'
     'hello' convertToEncoding:'cp1252'
    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

intervalFromStartLine: aStartLine startColumn: aStartColumn toEndLine: anEndLine endColumn: anEndColumn
    " Returns an interval spanning between startLine @ startColumn to endLine @ endColumn"
        
    | lineIndex intervalStart intervalEnd |

    lineIndex := 0.
    intervalStart := 1.
    intervalEnd := 0.
    self lineIndicesDo: [ :start :endWithoutDelimiters :end |
        lineIndex := lineIndex + 1.
        lineIndex = aStartLine ifTrue: [ intervalStart := start + aStartColumn - 1 ].
        lineIndex = anEndLine ifTrue: [ intervalEnd := start + anEndColumn - 1] 
    ].
    ^ intervalStart to: intervalEnd
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

intervalOfLine: aLineNumber
    "Answer an interval spanning between the first and the last character of the line from aLineNumber.
     Use this to convert lineNr into a character range."
    
    | lineIndex |

    lineIndex := 0.
    self lineIndicesDo: [ :start :endWithoutDelimiters :end |
        lineIndex := lineIndex + 1.
        lineIndex = aLineNumber ifTrue: [ ^ start to: end ] 
    ].
    ^ 0 to: 0
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

intervalOfLineCorrespondingToIndex: anIndex
    "Answer an interval spanning between the first and the last character of the line containing the given character index"
            
    self lineIndicesDo: [:start :endWithoutDelimiters :end |
        anIndex <= end ifTrue: [^ start to: end]
    ].
    ^ 0 to: 0
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

lineIndicesDo: aBlock
    "execute aBlock with 3 arguments for each line:
    - start index of line
    - end index of line without line delimiter
    - end index of line including line delimiter(s) CR, LF or CRLF"
    
    | cr lf start sz nextLF nextCR |

    start := 1.
    sz := self size.
    Smalltalk isSmalltalkX ifTrue:[
        cr := Character return
    ] ifFalse:[
        cr := Character cr.
    ].
    nextCR := self indexOf: cr startingAt: 1.
    lf := Character lf.
    nextLF := self indexOf: lf startingAt: 1.
    [ start <= sz ] whileTrue: [
            (nextLF = 0 and: [ nextCR = 0 ])
                    ifTrue: [ "No more CR, nor LF, the string is over"
                                    aBlock value: start value: sz value: sz.
                                    ^self ].
            (nextCR = 0 or: [ 0 < nextLF and: [ nextLF < nextCR ] ])
                    ifTrue: [ "Found a LF"
                                    aBlock value: start value: nextLF - 1 value: nextLF.
                                    start := 1 + nextLF.
                                    nextLF := self indexOf: lf startingAt: start ]
                    ifFalse: [ 1 + nextCR = nextLF
                            ifTrue: [ "Found a CR-LF pair"
                                    aBlock value: start value: nextCR - 1 value: nextLF.
                                    start := 1 + nextLF.
                                    nextCR := self indexOf: cr startingAt: start.
                                    nextLF := self indexOf: lf startingAt: start ]
                            ifFalse: [ "Found a CR"
                                    aBlock value: start value: nextCR - 1 value: nextCR.
                                    start := 1 + nextCR.
                                    nextCR := self indexOf: cr startingAt: start ]]]
! !

!CharacterArray methodsFor:'Compatibility-Dolphin'!

lines
    "return the receiver as a collection of lines.
     Added for Dolphin compatibility"

    ^ self asCollectionOfLines

    "
     'hello world' lines  

     'foo
bar
baz' lines

    "
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

openInWorkspaceWithTitle:aTitleString
    "Added for Squeak/Pharo compatibility"

    WorkspaceApplication openWith:self selected:false title:aTitleString.
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

translated
    "Dummy - Added for Squeak/Pharo compatibility"

    ^self

    "Created: / 26-11-2010 / 12:24:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

unescapePercents
    "decode %xx form.  This is the opposite of #encodeForHTTP"

    "/ obsoleted by urlDecoded
    ^ self unescapePercentsWithTextEncoding: 'utf-8'.

    "Created: / 14-09-2010 / 19:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-08-2018 / 13:04:09 / Claus Gittinger"
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

unescapePercentsWithTextEncoding: encodingName
    "decode string including %XX form"

    "/ if encodingName is utf-8, this is the same as urlDecoded
    "/ thus partially obsolete

    | unescaped char asciiVal specialChars oldPos pos converter |

    unescaped := ReadWriteStream on:''.
    specialChars := '+%' asSet.
    oldPos := 1.
    [pos := self indexOfAnyOf: specialChars startingAt: oldPos.
    pos > 0]
        whileTrue: [unescaped
                nextPutAll: (self copyFrom: oldPos to: pos - 1).
            char := self at: pos.
            (char == $%
                    and: [pos + 2 <= self size])
                ifTrue: [asciiVal := (self at: pos + 1) asUppercase digitValue * 16 + (self at: pos + 2) asUppercase digitValue.
                    asciiVal > 255
                        ifTrue: [^ self].
                    unescaped
                        nextPut: (Character value: asciiVal).
                    pos := pos + 3.
                    pos <= self size
                        ifFalse: [char := nil].
                    oldPos := pos]
                ifFalse: [char == $+
                        ifTrue: [unescaped nextPut: Character space]
                        ifFalse: [unescaped nextPut: char].
                    oldPos := pos + 1]].
    oldPos <= self size
        ifTrue: [unescaped
                nextPutAll: (self copyFrom: oldPos to: self size)].
    converter := (CharacterEncoder encoderFor: encodingName)
                ifNil: [CharacterEncoder encoderForUTF8].
    ^ [converter decode: unescaped contents]
        on: Error
        do: ["the contents may be squeak-encoded"
            unescaped contents]

    "Created: / 14-09-2010 / 19:23:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-08-2018 / 13:04:51 / Claus Gittinger"
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

withNoLineLongerThan: aNumber
    "Answer a string with the same content as receiver, but rewrapped so that no line has more characters than the given number"

    | listOfLines currentLast currentStart resultString putativeLast putativeLine crPosition |

    (aNumber isNumber not or:[ aNumber < 1] ) ifTrue: [self error: 'too narrow'].
    listOfLines := OrderedCollection new.
    currentLast := 0.
    [currentLast < self size] whileTrue:
            [currentStart := currentLast + 1.
            putativeLast := (currentStart + aNumber - 1) min: self size.
            putativeLine := self copyFrom: currentStart to: putativeLast.
            (crPosition := putativeLine indexOf: Character cr) > 0 ifTrue:
                    [putativeLast := currentStart + crPosition - 1.
                    putativeLine := self copyFrom: currentStart to: putativeLast].
            currentLast := putativeLast == self size
                    ifTrue:
                            [putativeLast]
                    ifFalse:
                            [currentStart + putativeLine lastSpacePosition - 1].
            currentLast <= currentStart ifTrue:
                    ["line has NO spaces; baleout!!"
                    currentLast := putativeLast].
            listOfLines add: (self copyFrom: currentStart to: currentLast) withoutSeparators].

    listOfLines size > 0 ifFalse: [^ ''].
    resultString := listOfLines first.
    2 to: listOfLines size do:
            [:i | resultString := resultString, Character cr asString, (listOfLines at: i)].
    ^ resultString

    "
     #(5 7 20) collect:
        [:i | 'Fred the bear went down to the brook to read his book in silence' withNoLineLongerThan: i]
    "

    "Modified (format): / 26-08-2018 / 13:14:30 / Claus Gittinger"
! !

!CharacterArray methodsFor:'Compatibility-Squeak'!

withSqueakLineEndings
    "assume the string is textual, and that CR, LF, and CRLF are all
     valid line endings.  
     Replace each occurrence with a single line end character.
     Notice; that ST/X uses LF as line end internally"

    ^ self asStringCollection asStringWith:Character cr.

    "Modified (comment): / 26-08-2018 / 13:34:50 / Claus Gittinger"
! !

!Class methodsFor:'Compatibility-Squeak'!

bindingOf:aName
    "return the binding of a name - either a class var, a private class, or a pool value"

    (self classVarNames includes:aName) ifTrue:[
        ^ self classVarAt:aName
    ].

    self sharedPoolNames do:[:eachPoolName |
        |pool|

        pool := Smalltalk at:eachPoolName.
        (pool classVarNames includes:aName) ifTrue:[
            ^ pool classVarAt:aName
        ].
    ].

    "JV@2011-10-23: In Squeak/Pharo, bindingOf: returns
     nil if no binding is found. Some code depends on this
     behavior"
    self breakPoint:#cg. "/self error:'No such binding'.
    ^nil

    "Created: / 12-09-2011 / 10:09:58 / cg"
    "Modified (format): / 23-10-2011 / 17:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'Compatibility-Squeak'!

objectForDataStream: stream

    self breakPoint: #jv.

    ^super objectForDataStream: stream

    "Created: / 11-09-2010 / 19:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'Compatibility-Squeak'!

storeDataOn: stream

    self error: 'Should never happen'

    "Created: / 11-09-2010 / 19:28:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'Compatibility-Squeak'!

ultimateSourceCodeAt:aSelector ifAbsent:exceptionalValue
    "Return the source code at selector, deferring to superclass if necessary"

    |m|

    m := self lookupMethodFor:aSelector.
    m isNil ifTrue:[ ^ exceptionalValue value ].
    ^ m source

    "
     Array ultimateSourceCodeAt:#class ifAbsent:[nil]
     Array ultimateSourceCodeAt:#foo ifAbsent:[nil]
    "
! !

!ClassDescription methodsFor:'Compatibility-Dolphin'!

categoriesFor:aMethodSelector
    "this method allows fileIn of Dolphin methods -
     return a MethodCategoriesReader to read in a methods categories for me.
     Since Dolphin uses a different way to assign method categories,
     loaded methods are temporarily categorized as 'Dolphin methods'
     and later reassigned, when a categoriesFor: message arrives."

    ^ Dolphin::MethodCategoriesReader class:self selector:aMethodSelector
! !

!ClassDescription methodsFor:'Compatibility-Dolphin'!

categoriesForClass
    "this method allows fileIn of Dolphin classes -
     return a ClassCategoriesReader to read in a classes categories for me.
     Since Dolphin uses a different way to assign class categories,
     the loaded classes are temporarily categorized as 'ST/V classes'
     and later reassigned, when a categoriesForClass message arrives."

    ^ Dolphin::ClassCategoriesReader class:self
! !

!ClassDescription methodsFor:'fileIn interface'!

commentStamp:aStamp prior:whatever
    "return a ClassCategoryReader to read in and compile methods for me.
     This was added to allow squeak code to be filedIn."

    ^ Squeak::ClassCommentReader new
        class:self
        category:#Comment
        changeStamp:aStamp

    "Modified: / 6.6.1998 / 01:47:06 / cg"
! !

!ClassDescription methodsFor:'Compatibility-Squeak'!

compile:code classified:cat withStamp:stamp
    ^ self compile:code classified:cat withStamp:stamp notifying:nil logSource:true
! !

!ClassDescription methodsFor:'Compatibility-Squeak'!

compile:code classified:cat withStamp:stamp notifying:requestor logSource:doLog
    | action |

    action :=
        [
            |method|
            
            method := self compilerClass
                            compile:code forClass:self inCategory:cat.

            "Make it working even if Monticello is not loaded"
            (Annotation respondsTo:#mctimestamp:) ifTrue:[
                method annotateWith: (Annotation mctimestamp: stamp)
            ].
            ^ method
        ].

    doLog ifTrue:[
        action value.
    ] ifFalse:[
        self withoutUpdatingChangesDo:action
    ].
! !

!ClassDescription methodsFor:'Compatibility-Squeak'!

compileSilently:source classified:category
    Class withoutUpdatingChangesDo:[
        self compile: source classified: category
    ]

    "Created: / 11-09-2010 / 19:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassDescription methodsFor:'Compatibility-ST/V'!

variableByteSubclass:nameSymbol classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable byte-sized nonpointer variables (but no instance variables)"

    ^ self variableByteSubclass:nameSymbol instanceVariableNames:'' classVariableNames:classVarString poolDictionaries:pool category:cat
! !

!ClassOrganizer methodsFor:'Compatibility-Squeak'!

commentStamp

    ^(class respondsTo: #version_MC)
        ifTrue: [class version_MC]
        ifFalse:[Author changeStamp]

    "Created: / 26-08-2010 / 18:36:27 / Jan Vrany"
    "Modified: / 14-09-2010 / 15:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Collection methodsFor:'Compatibility-Squeak'!

collectAsSet: aBlock
        "Evaluates aBlock for each element of the receiver and collects
        the resulting values into a Set."

        "This is an efficient shorthand for [ (self collect: aBlock) asSet ]."
        "originally developed by a. kuhn and released under MIT."
        
        ^self collect:aBlock as:Set
! !

!Collection methodsFor:'Compatibility-Squeak'!

deepFlatten

	^ Array streamContents: [ :stream |
			self do: [ :each | each deepFlattenInto: stream ]]
! !

!Collection methodsFor:'Compatibility-Squeak'!

deepFlattenInto: stream

	self do: [ :each | each deepFlattenInto: stream ]
! !

!Collection methodsFor:'Compatibility-Squeak'!

detect: aBlock ifOne: presentBlock
	^ self detect: aBlock ifOne: presentBlock ifNone: [nil] 
! !

!Collection methodsFor:'Compatibility-Squeak'!

detect: aBlock ifOne: presentBlock ifNone: noneBlock
	| result |
	result := self detect: aBlock ifNone: [nil].
	^ result isNil 
		ifTrue: [ noneBlock value ]
		ifFalse: [ presentBlock value: result ]
! !

!Collection methodsFor:'Compatibility-Squeak'!

do:block displayingProgress:progressMessage
    |numElements counter|

    (numElements := self size) == 0 ifTrue:[^self].

    self isSequenceable ifFalse:[
        counter := 1.
        self do:[:each|
            block value:each.
            ProgressNotification notify:progressMessage progress:(counter / numElements)*100.
            counter := counter + 1.
        ]
    ] ifTrue:[
        self withIndexDo:[:each :index|
            block value: each.
            ProgressNotification notify:progressMessage progress:(index / numElements)*100.
        ]
    ].

    "
     ProgressNotification handle:[:ex |
        Transcript showCR:ex progressValue rounded.
        ex proceed.
     ] do:[
         #(0 1 2 3 4 5 6 6 7 8 9)
             do:[:i| Delay waitForMilliseconds: 50]
             displayingProgress: 'Progress'
     ].
    "

    "Created: / 12-09-2010 / 09:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2011 / 15:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Collection methodsFor:'Compatibility-Squeak'!

equalsTo: aCollection 
	"Answer true if the reciever contains the same elements as aCollection, and vice versa."

	^(aCollection isCollection) 
		and: [ aCollection size = self size 
			and: [ aCollection allSatisfy: [ :each | 
				(aCollection occurrencesOf: each) = (self occurrencesOf: each) ]]]
! !

!Collection methodsFor:'Compatibility-Squeak'!

flatCollect: aBlock 
    "Evaluate aBlock for each of the receiver's elements and answer the
    list of all resulting values flatten one level. Assumes that aBlock returns some kind
    of collection for each element. Equivalent to the lisp's mapcan"
    "original written by a. Kuhn and released under MIT"
    
    | stream |

    self isEmpty ifTrue: [ ^ self copy ].
    stream := (self species new: 0) writeStream.
    self do: [ :each | stream nextPutAll: (aBlock value: each) ].
    ^ stream contents
! !

!Collection methodsFor:'Compatibility-Squeak'!

flatCollect: aBlock as: aCollectionClass
	"Evaluate aBlock for each of the receiver's elements and answer the
	list of all resulting values flatten one level. Assumes that aBlock returns some kind
	of collection for each element. Equivalent to the lisp's mapcan"
	
	| col |
	self isEmpty ifTrue: [^self copy ].
	col := aCollectionClass new: self size. 	
	self do: [ :each |
		col addAll: (aBlock value: each) ].
	^col
! !

!Collection methodsFor:'Compatibility-Squeak'!

flatCollectAsSet: aBlock
    "Evaluate aBlock for each of the receiver's elements and answer the
    list of all resulting values flatten one level. Assumes that aBlock returns some kind
    of collection for each element. Equivalent to the lisp's mapcan"
    
    "original written by a. Kuhn and released under MIT"
    
    ^ self flatCollect:aBlock as:Set

    "
     #((1) (2) (3 -4) (5 (-6 7) 8) (9 10)) flatCollect:[:i | i abs] as:Set
     #((1) (2) (3 -4) (5 (-6 7) 8) (9 10)) flatCollectAsSet:[:i | i abs]
    "
! !

!Collection methodsFor:'Compatibility-Squeak'!

flatten
    "Recursively collect each non-collection element of the receiver and its descendant
    collections.  Please note, this implementation assumes that strings are to be treated
    as objects rather than as collection."

    ^self gather: [ :each | each ]
! !

!Collection methodsFor:'Compatibility-Squeak'!

groupedBy: aBlock
	"Return a dictionary whose keys are the result of evaluating aBlock for all elements in
	 the collection, and the value for each key is the collection of elements that evaluated
	 to that key. e.g.
	     #(1 2 3 4 5) groupedBy: [:each | each odd]
	   a Dictionary  
	     true ---> #( 1 3 5)
	     false --> #(2 4)
	originally developed by a. kuhn and released under MIT."

	| result |
	result := Dictionary new.
	self do:
		[:each | | key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [OrderedCollection new].
		collection add: each].
	self species ~~ OrderedCollection ifTrue:
		["Convert the result collections to be the right type.
		  Note that it should be safe to modify the dictionary
		  while iterating because we only replace values for existing keys"
		result keysAndValuesDo:
			[:key :value | result at: key put: (self species withAll: value)]].

	^result
! !

!Collection methodsFor:'Compatibility-Squeak'!

groupedBy: aBlock affect: anotherBlock
	"First, evaluate aBlock for each of the receiver's elements and group the
	elements by the resulting values, and second, evaluate anotherBlock for
	each of the resulting groups and return a dictionary with the first pass'
	results as keys and the second pass' results as values."

	"This is a shorthand for [ (self groupedBy: aBlock) collect: anotherBlock ]."

	^(self groupedBy: aBlock) associationsDo: [ :each | each value: (anotherBlock value: each value) ]
! !

!Collection methodsFor:'Compatibility-Dolphin'!

includesAllOf:aCollection
    "same as #includesAll for Squeak/Dolphin compatibility."

    ^ self includesAll:aCollection

    "
     #(1 2 3 4 5 6 7) includesAllOf:#(1 2 3)
     #('hello' 'there' 'world') includesAllOf:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAllOf:#(7 8 9)
     #(1 2 3 4 5 6 7) includesAllOf:#(8 9 10)
    "

    "Created: / 01-07-2018 / 10:31:57 / Claus Gittinger"
! !

!Collection methodsFor:'Compatibility-Dolphin'!

includesAnyOf:aCollection
    "same as #includesAny for Squeak/Dolphin compatibility."

    ^ self includesAny:aCollection

    "
     #(1 2 3 4 5 6 7) includesAny:#(1 2 3)
     #('hello' 'there' 'world') includesAny:#('hello' 'world')
     #(1 2 3 4 5 6 7) includesAny:#(7 8 9)
     #(1 2 3 4 5 6 7) includesAny:#(8 9 10)
    "

    "Modified (comment): / 01-07-2018 / 10:32:27 / Claus Gittinger"
! !

!Collection methodsFor:'Compatibility-Squeak'!

intersection:aCollection
    "same as intersect: for Squeak compatibility"
    
    ^ self intersect:aCollection

    "Created: / 22-10-2008 / 21:29:27 / cg"
! !

!Collection methodsFor:'Compatibility-Squeak'!

nilSafeGroupedBy: aBlock
	^ self groupedBy: [ :each |
		| value |
		value := aBlock value: each.
		value ifNil: [ UndefinedObject ].
	]	
! !

!Collection methodsFor:'Compatibility-Squeak'!

selectAsSet: aBlock 
        "Evaluate aBlock with each of the receiver's elements as the argument. 
        Collect into a new set, only those elements for which
        aBlock evaluates to true.  Answer the new collection."

        ^ self select:aBlock as:Set
! !

!Collection methodsFor:'Compatibility-Squeak'!

sorted:aBlock
    "Create a copy that is sorted.  Sort criteria is the block that accepts two arguments.
     When the block is true, the first arg goes first ([:a :b | a > b] sorts in descending order)."

    ^ self sortedBy: aBlock
! !

!Collection methodsFor:'Compatibility-Dolphin'!

symmetricDifference:aCollection
    "return a new set containing all elements, 
     which are contained in either the receiver or aCollection, but not in both.
     Same as xor: - for compatibility"

    ^ self xor:aCollection

    "
     |c1 c2|

     c1 := #( foo bar baz baloo ).
     c2 := #( foe bar banana baloo ).
     c1 symmetricDifference:c2.         
     self assert:(c1 symmetricDifference:c2) asSet = (c2 symmetricDifference:c1) asSet
    "
! !

!Collection class methodsFor:'Compatibility-Squeak'!

ofSize:n
    "return a new collection which really provides space for n elements.
     Kludges around the stupid definition of OrderedCollection>>new:"

    ^ self newWithSize:n
! !

!Color methodsFor:'Compatibility-Squeak'!

newTileMorphRepresentative
    "Squeak compatibility - dummy"

    ^ ColorTileMorph new colorSwatchColor: self

    "Modified (comment): / 03-02-2017 / 11:39:27 / cg"
! !

!FileStream class methodsFor:'Compatibility-Squeak'!

readonlyFileNamed:filename do:aBlock
    "open a readonly stream on filename and evaluate aBlock with it.
     Ensures that the stream is closed afterwards"

    ^ filename asFilename readingFileDo:aBlock

    "Created: / 01-07-2018 / 11:00:45 / Claus Gittinger"
! !

!GenericException methodsFor:'Compatibility-Squeak'!

signal: aString

    ^self signalWith: aString

    "Created: / 13-09-2010 / 12:03:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GenericException class methodsFor:'Compatibility-Dolphin'!

signal:messageText
    "raise a signal proceedable or nonproceedable (whichever is right).
     The argument is used as messageText."

    <context: #return>

    ^ (self newException
                suspendedContext:thisContext sender
                errorString:messageText)
        raiseSignal.

    "Modified: / 10-08-2010 / 09:41:56 / cg"
! !

!Integer methodsFor:'Compatibility-Dolphin'!

& aNumber
    "return the bitwise-and of the receiver and the argument, anInteger.
     Same as bitAnd: - added for compatibility with Dolphin Smalltalk.
     Notice:
        PLEASE DO NOT USE & for integers in new code; it makes the code harder
        to understand, as it may be not obvious, whether a boolean-and a bitWise-and is intended.
        For integers, use bitAnd: to make the intention explicit.
        Also, consider using and: for booleans, which is does not evaluate the right part if the left is false."

    ^ self bitAnd:aNumber

    "
     14 | 1
     9 & 8
    "
! !

!Metaclass methodsFor:'Compatibility-Squeak'!

isTrait

    ^false

    "Created: / 12-09-2010 / 16:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'Compatibility-Squeak'!

numTemps

    ^self numVars

    "Created: / 14-10-2010 / 16:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'Compatibility-Squeak'!

timeStamp

    ^(self hasAnnotation: #mctimestamp:)
	ifTrue:[(self annotationAt: #mctimestamp:) timestamp]
	ifFalse:[Author changeStamp].

    "Created: / 28-08-2010 / 22:43:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-09-2010 / 16:13:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Number methodsFor:'Compatibility-Squeak'!

asDuration
    "return an TimeDuration object from the receiver, taking the receiver
     as number of seconds"

    ^ self asTimeDuration 
! !

!Number methodsFor:'Compatibility-Squeak'!

newTileMorphRepresentative
        ^ TileMorph new addArrows; setLiteral: self; addSuffixIfCan
! !

!Number methodsFor:'Compatibility-Squeak'!

stringForReadout
    ^ self rounded printString
! !

!Object methodsFor:'Compatibility-Squeak'!

becomeForward:anotherObject
    "same as becomeSameAs:, but Squeak naming"
    
    self becomeSameAs:anotherObject
! !

!Object methodsFor:'Compatibility-Squeak'!

becomeForward:anotherObject copyHash:copyHash
    copyHash ifTrue:[ self error:'unsupported operation' ].
    self becomeSameAs:anotherObject
! !

!Object methodsFor:'Compatibility-Squeak'!

caseError
    "Report an error from an in-line or explicit case statement."

    "/ proceedable, so a handler can provide a default value
    ^ self proceedableError: 'Case not found, and no otherwise clause'

    "Modified (format): / 24-05-2018 / 21:10:36 / Claus Gittinger"
! !

!Object methodsFor:'Compatibility-Squeak'!

caseOf: cases
    "The elements of cases are associations between blocks.
     Answer the evaluated value of the first association in cases
     whose evaluated key equals the receiver.  
     If no match is found, report an error."

    ^ self
        caseOf: cases
        otherwise: [self caseError]

    "possible, but not inline compiled (i.e. slow)
        | z | 
        z := {
                [#a]->[1+1]. 
                ['b' asSymbol]->[2+2]. 
                [#c]->[3+3]
             }. 
        #b caseOf: z.

        z := {
                [#a]->[1+1]. 
                ['d' asSymbol]->[2+2]. 
                [#c]->[3+3]
             }. 
        #b caseOf: z
    "
    "The following are compiled in-line (in the BytecodeCompiler:
        #b caseOf: {
            [#a]->[1+1]. 
            ['b' asSymbol]->[2+2]. 
            [#c]->[3+3]
        }.
        #b caseOf: {
            [#a]->2. 
            ['d' asSymbol]->3. 
            [#c]->4
        }.
    "

    "
     |x|
     x := 1.
     x caseOf: {
        [1]->['one'].
        [2]->['two'].
        [3]->['three']
     }.

     |x|
     x := 17.
     x caseOf: {
        [1]->['one'].
        [2]->['two'].
        [3]->['three']
     }.

     |x|
     x := 2.
     x caseOf: {
        1->'one'.
        2->'two'.
        3->'three'
     } otherwise:99.

     |x|
     x := 17.
     x caseOf: {
        1->'one'.
        2->'two'.
        3->'three'
     } otherwise:99.
   "

    "Created: / 12-09-2011 / 09:17:59 / cg"
    "Modified (comment): / 02-08-2017 / 08:49:56 / cg"
! !

!Object methodsFor:'Compatibility-Squeak'!

caseOf:cases otherwise:otherwise 
    "The elements of cases are associations between blocks.
     Answer the evaluated value of the first association in cases
     whose evaluated key equals the receiver.  
     If no match is found, answer the result
     of evaluating the otherwise block."
    
    cases associationsDo:[:eachCase | 
        eachCase key value = self ifTrue:[
            ^ eachCase value value
        ].
    ].
    ^ otherwise value

    "
        | z | 
        z := {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}. 
        #b caseOf: z otherwise: [0].

        z := {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}. 
        #b caseOf: z otherwise: [0]
    "
    "The following are compiled in-line (in the BytecodeCompiler:
        #b caseOf: {
            [#a]->[1+1]. 
            ['b' asSymbol]->[2+2]. 
            [#c]->[3+3]
        } otherwise: [0].

        #b caseOf: {
            [#a]->2. 
            ['d' asSymbol]->4. 
            [#c]->9
        } otherwise: [999]
    "

    "
     |x|
     x := 1.
     x caseOf: {
        [1]->['one'].
        [2]->['two'].
        [3]->['three']
     }
     otherise:[nil].

     x := 2.
     x caseOf: {
        1->'one'.
        2->'two'.
        3->'three'
     }
     otherwise:nil.
   "

    "Created: / 12-09-2011 / 09:18:52 / cg"
! !

!Object methodsFor:'Compatibility-Squeak'!

comeFullyUpOnReload: smartRefStream
    "Normally this read-in object is exactly what we want to store. 7/26/96 tk"

    ^ self

    "Created: / 12-09-2010 / 13:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'Compatibility-Squeak'!

deepFlattenInto: stream

	stream nextPut: self
! !

!Object methodsFor:'Compatibility-Squeak'!

deprecated:aMessage
    "somehow, the Squeak guys came to the same conclusion, that obsolete stuff needs to be marked as such.
     However (as usual), they invent their own naming, not looking what others have already invented (sigh).
     For Squeak code, this forwards the notification to our ST/X mechanism"
     
    self obsoleteMethodWarning:aMessage
! !

!Object methodsFor:'Compatibility-Squeak'!

explore
    (self confirm:'The Squeak explorer has not yet been ported to ST/X\\Inspect instead ?' withCRs)
    ifTrue:[
        self inspect
    ]
! !

!Object methodsFor:'Compatibility-ST/V'!

implementedBySubclass
    "{ Pragma: +optSpace }"

    "this is sent by ST/V code - it's the same as #subclassResponsibility"

    <resource: #skipInDebuggersWalkBack>

    ^ SubclassResponsibilityError raiseRequestErrorString:'method must be reimplemented in ST/V subclass'

    "Modified (comment): / 16-07-2017 / 11:33:50 / cg"
! !

!Object methodsFor:'Compatibility-Squeak'!

inform: aString
    "Display a message for the user to read and then dismiss."

    self information:aString
! !

!Object methodsFor:'Compatibility-ST/V'!

invalidMessage
    "{ Pragma: +optSpace }"

    "this is sent by ST/V code - it is the same as #shouldNotImplement"

    <resource: #skipInDebuggersWalkBack>

    ^ self shouldNotImplement

    "Modified (comment): / 02-11-2012 / 10:11:18 / cg"
! !

!Object methodsFor:'Compatibility-Squeak'!

isInMemory
    "All normal objects are."

    ^ true
! !

!Object methodsFor:'Compatibility-Squeak'!

objectForDataStream: stream

    ^self

    "Created: / 11-09-2010 / 19:21:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'Compatibility-VW'!

oneWayBecome:anotherObject
    ^ self becomeSameAs:anotherObject

    "
     |arr o1 o2|

     arr := Array new:2.
     arr at:1 put:(o1 := Object new).
     arr at:2 put:(o2 := Point new).
     o1 oneWayBecome:o2.
     (arr at:1) ~~ o2 ifTrue:[self halt].
    "
    "
     |arr o1 o2|

     arr := Array new:2.
     arr at:1 put:(o1 := Object new).
     arr at:2 put:(o2 := Point new).
     o1 becomeSameAs:o2.
     (arr at:1) ~~ o2 ifTrue:[self halt].
    "
! !

!Object methodsFor:'Compatibility-Squeak'!

perform: selector withEnoughArguments: anArray
    "Send the selector, aSymbol, to the receiver with arguments in argArray.
    Only use enough arguments for the arity of the selector; supply nils for missing ones.

    Note: This method is from Pharo 1.4 - do not use in Smalltalk/X code"
    | numArgs args |
    numArgs := selector argumentCount.
    anArray size == numArgs
        ifTrue: [ ^self perform: selector withArguments: anArray asArray ].

    args := Array new: numArgs.
    args replaceFrom: 1
        to: (anArray size min: args size)
        with: anArray
        startingAt: 1.

    ^ self perform: selector withArguments: args

    "Created: / 23-10-2011 / 17:17:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'Compatibility-Squeak'!

readDataFrom: aDataStream size: varsOnDisk
    "Fill in the fields of self based on the contents of aDataStream.  Return self.
     Read in the instance-variables written by Object>>storeDataOn:.
     NOTE: This method must send beginReference: before reading any objects from aDataStream that might reference it.
     Allow aDataStream to have fewer inst vars.  See SmartRefStream."

    | cntInstVars cntIndexedVars nSkip|

    cntInstVars := self class instSize.
    nSkip := 0.
    self class isVariable
        ifTrue: [cntIndexedVars := varsOnDisk - cntInstVars.
                cntIndexedVars < 0 ifTrue: [
                    self error: self class name,'-Class has changed too much.  Define a convertxxx method']]
        ifFalse: [cntIndexedVars := 0.
                varsOnDisk > cntInstVars ifTrue:[
                    self error: self class name,' loaded has more instance variables than Class.\Consider defining a convertxxx method. Proceed to skip those slots.' withCRs
                         mayProceed:true.
                    "/ if proceeded, skip additional slots
                    nSkip := varsOnDisk - cntInstVars.
                ] ifFalse:[
                    cntInstVars := varsOnDisk]].     "OK if fewer than now"

    aDataStream beginReference: self.
    1 to: cntInstVars do:
        [:i | self instVarAt: i put: aDataStream next].
    1 to: cntIndexedVars do:
        [:i | self basicAt: i put: aDataStream next].
    nSkip > 0 ifTrue:[  
        nSkip timesRepeat:[ 
            Transcript showCR:self class name,' skipping: ',aDataStream next printString
        ].
    ].

    "Total number read MUST be equal to varsOnDisk!!"
    ^ self  "If we ever return something other than self, fix calls
            on (super readDataFrom: aDataStream size: anInteger)"

    "Created: / 12-09-2010 / 13:10:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-11-2011 / 14:08:52 / cg"
! !

!Object methodsFor:'Compatibility-Dolphin'!

stbFixup: anSTBInFiler at: newObjectIndex
    "Answer the true object that must be used to represent the receiver when read from anSTBInFiler.
     Typically this is overridden by subclasses of STBProxy to answer the proxied object. Other classes
     may also override this method to effectively 'one way become' the receiver to some other object"

    ^ self
! !

!Object methodsFor:'Compatibility-Squeak'!

storeDataOn: aDataStream
    "Store myself on a DataStream.  
     Answer self.  
     This is a low-level DataStream/ReferenceStream method. 
     See also objectToStoreOnDataStream.  
     NOTE: This method must send 'aDataStream beginInstance:size:' and then (nextPut:/nextPutWeak:) its subobjects.  
     readDataFrom:size: reads back what we write here."

    | cntInstVars cntIndexedVars |

    cntInstVars := self class instSize.
    cntIndexedVars := self basicSize.
    aDataStream
        beginInstance: self class
        size: cntInstVars + cntIndexedVars.
    1 to: cntInstVars do:
        [:i | aDataStream nextPut: (self instVarAt: i)].

    "Write fields of a variable length object.  When writing to a dummy
        stream, don't bother to write the bytes"
    "1 to: cntInstVars do:
        [:i | aDataStream nextPut: (self instVarAt: i)]."

    "Created: / 11-09-2010 / 19:27:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-09-2010 / 13:14:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-11-2011 / 14:08:44 / cg"
! !

!Object methodsFor:'Compatibility-Squeak'!

stringForReadout
        ^ self stringRepresentation
! !

!Object methodsFor:'Compatibility-Squeak'!

stringRepresentation
        "Answer a string that represents the receiver.  For most objects this is simply its printString, but for strings themselves, it's themselves.  6/12/96 sw"

        ^ self printString
! !

!OrderedCollection methodsFor:'Compatibility-Squeak'!

overlappingPairsCollect: aBlock 
        "Answer the result of evaluating aBlock with all of the overlapping pairs of my elements. Override superclass in order to use addLast:, not at:put:."
        | retval |
        retval := self species new: self size - 1.
        firstIndex to: lastIndex - 1 do:
                [:index |
                retval addLast: (aBlock value: (contentsArray at: index) value: (contentsArray at: index + 1))].
        ^retval
! !

!Process methodsFor:'Compatibility-Squeak'!

isTerminated
    "return true, if the receiver is a dead process"

    ^ self isDead
! !

!Process methodsFor:'Compatibility-V''Age'!

queueInterrupt:aBlock
    "VisualAge compatibility: alias for #interruptWith:
     arrange for the receiver process to be interrupted and
     evaluate aBlock in its interrupt handler."

    ^ self interruptWith:aBlock

    "Created: 15.11.1996 / 11:41:06 / cg"
! !

!ProjectDefinition class methodsFor:'instance creation'!

definitionClassForMonticelloPackage:aMonicelloPackagename
    ^ self definitionClassForMonticelloPackage:aMonicelloPackagename createIfAbsent:false

    "
     self definitionClassForMonticelloPackage:'foobar'
    "
! !

!ProjectDefinition class methodsFor:'instance creation'!

definitionClassForMonticelloPackage:aMonicelloPackagename createIfAbsent:createIfAbsent
    ^ self allSubclasses
        detect:[:eachProjectDefinition |
            eachProjectDefinition monticelloPackageName = aMonicelloPackagename ]
        ifNone:[
            |dfn squeakPackageInfo|

            createIfAbsent ifTrue:[
                dfn := ApplicationDefinition
                    definitionClassForPackage:'mc:',aMonicelloPackagename createIfAbsent:true projectType:GUIApplicationType.

                "/ if the squeak-stuff is loaded, use it.
                PackageInfo notNil ifTrue:[
                    squeakPackageInfo := PackageInfo allSubclasses
                                            detect:[:pi | pi new packageName = aMonicelloPackagename] ifNone:nil.
                ].

                squeakPackageInfo notNil ifTrue:[
                    dfn classNames:(squeakPackageInfo new classes collect:[:each | each name]).
                ].
            ] ifFalse:[
                nil
            ]
        ]

    "
     self definitionClassForMonticelloPackage:'foobar'
     self definitionClassForMonticelloPackage:'foobar' createIfAbsent:true
    "

    "Modified: / 30-10-2010 / 00:26:07 / cg"
! !

!ReadStream methodsFor:'Compatibility-Squeak'!

nextInto:aCollection
    "Read the next elements of the receiver into aCollection.
    Return aCollection or a partial copy if less than aCollection
    size elements have been read."

    ^self next: aCollection size into: aCollection startingAt: 1.

    "Created: / 12-09-2010 / 13:05:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

asTraitComposition
    "For convenience the composition {T1. T2 ...} is the same as T1 + T2 + ..."
    "
    ^self isEmpty
	ifFalse: [
	    self size = 1
		ifTrue: [self first asTraitComposition]
		ifFalse: [
		    self copyWithoutFirst
			inject: self first
			into: [:left :right | left + right]]]
	ifTrue: [
	    TraitComposition new]
    "

    "Now, Smalltalk/X doesn't support traits"
    ^nil

    "Created: / 29-08-2010 / 08:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

pairsDistanceFrom: aSequenceableCollection
	
	self deprecated: 'Please use pairsSimilarityWith:'.
	^ self pairsSimilarityWith: aSequenceableCollection
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

pairsSimilarityWith: aSequenceableCollection
        
        "
                Examples:
                '1234' pairsSimilarityWith: '2234' ==> (2/3)
                '1234' pairsSimilarityWith: '123' ==>  (4/5)
                '1234' pairsSimilarityWith: '5678' ==> 0
        "
        | set1 set2 |
        set1 := Set new.
        set2 := Set new.
        self overlappingPairsDo: [:a :b | 
                set1 add: a -> b].
        aSequenceableCollection overlappingPairsDo: [:a :b | 
                set2 add: a -> b].
        ^ 2 * (set1 intersect: set2) size / (set1 size + set2 size)

    "Modified: / 09-10-2017 / 17:12:59 / stefan"
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

piecesCutWhere: testBlock do: enumerationBlock 
	"Evaluate testBlock for successive pairs of the receiver elements,
	breaking the receiver into pieces between elements where
	the block evaluated to true, and evaluate enumerationBlock
	with each of those pieces."
	"'A sentence. Another sentence... Yet another sentence.'
		piecesCutWhere: [:each :next | each = $. and: [next = Character space]] 
		do: [:each | Transcript show: each printString; cr]"

	| start prevElem nextElem size |
	self isEmpty ifTrue: [^self].
	prevElem := self at: (start := 1).
	2 to: (size := self size) do:
		[:index|
		 nextElem := self at: index.
		(testBlock value: prevElem value: nextElem) ifTrue: 
			[enumerationBlock value: (self copyFrom: start to: index - 1).
			 start := index].
		prevElem := nextElem].
	enumerationBlock value: (self copyFrom: start to: size)
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

runsFailing: aBlock
	"Evaluate testBlock with the receiver elements, selecting from the
	receiver runs, that is sequences of adjacent elements, for which
	the block returned false. Return an OrderedCollection of those runs."
	"'Hello to\all of the world,\isn''t Smalltalk cool?' 
		runsFailing: [:each | each = $\] "

	^self runsSatisfying: [:each | (aBlock value: each) not]
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

runsSatisfying: testBlock
	"Evaluate testBlock with the receiver elements, selecting from the
	receiver runs, that is sequences of adjacent elements, for which the block 
	returned true. Return an OrderedCollection of those subsequences."
	"'Hello to\all of the world,\isn''t Smalltalk cool?' 
		runsSatisfying: [:each | each ~= $\] "

	| runs |
	runs := OrderedCollection new.
	self runsSatisfying: testBlock do: [:each | runs add: each].
	^runs
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

runsSatisfying: testBlock do: enumerationBlock 
	"Evaluate testBlock with the receiver elements, selecting from the
	receiver runs, that is sequences of adjacent elements, for which the block 
	returned true, and evaluate enumerationBlock with each of those 
	subsequences."
	"'Hello to\all of the world,\isn''t Smalltalk cool?' 
		runsSatisfying: [:each | each ~= $\] 
		do: [:each | Transcript show: each; cr]"

	| size start wasInside nowInside |
	start := 1.
	wasInside := false.
	1 to: (size := self size) do:
		[:index|
		 nowInside := testBlock value: (self at: index).
		 nowInside ~~ wasInside ifTrue:
			[wasInside := nowInside.
			 nowInside
				ifTrue: [start := index]
				ifFalse: [enumerationBlock value: (self copyFrom: start to: index - 1)]]].
	wasInside ifTrue: [enumerationBlock value: (self copyFrom: start to: size)]
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

shuffle
    "Swaps the receiver's elements at random. Inplace, destructive"

    self shuffle: (self size * self size log) asInteger
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

shuffle: times
    "Swaps random elements of the receiver. Inplace, destructive"

    | size random |

    size := self size.
    random := Random new.
    times timesRepeat: [ 
        self swap: (random next * size) floor + 1 with: (random next * size) floor + 1 
    ].
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

sliceFrom: startIndex

	"Answers a copy of a subset of the receiver, starting from element at start index 
	up to the end of the collection.

	Comfortable alternative to stupid copyFrom:to: method.
	See also comment on sliceFrom:to:"

	^self sliceFrom: startIndex to: self size
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

sliceFrom: startIndex to: endIndex

	"Answers a copy of a subset of the receiver, starting from element at start index
	until element at end index.

	Comfortable alternative to stupid copyFrom:to: method.
	If the start or end index is negative, the index will be counted from the end of the collection.

	Note: this method does NEVER throw a SubscriptOutOfBoundsError. If the indexes are
	too large or start is greater than end, then an empty collection will be returned."

	| start end |

	start := 1 max:
		(startIndex positive ifTrue: [startIndex] ifFalse: [self size + startIndex +1]).

	end := self size min: 
		(endIndex positive ifTrue: [endIndex] ifFalse: [self size + endIndex]).

	((start > end) or: [end <= 0]) ifTrue: [^self copyEmpty: 0].
	^self copyFrom: start to: end
! !

!SequenceableCollection methodsFor:'Compatibility-Squeak'!

sliceTo: endIndex
	"Answer a copy of a subset of the receiver, starting from first element 
	up to element at endIndex."

	^self sliceFrom: 1 to: endIndex
! !

!Set methodsFor:'Compatibility-Squeak'!

flatCollect: aBlock 
	
	
	^self flatCollectAsSet: aBlock
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

allClassesAndTraitsDo:aBlock
    "for squeak compatibility - currently, there are no traits"
    
    ^ self allClassesDo:aBlock

    "Created: / 13-07-2017 / 16:30:59 / cg"
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

allTraits

    ^#()

    "Created: / 14-09-2010 / 09:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

globals

    ^self

    "Created: / 12-09-2010 / 13:09:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

logChange:aString

    "Nothing to do"

    "Created: / 14-09-2010 / 09:45:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

os
    "return the operating system"

    ^ OperatingSystem

    "
     Smalltalk os -> Win32OperatingSystem
    "
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

renameClassNamed:oldName as:newName
    self renameClass:(self at:oldName) to:newName
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

unregisterExternalObject: anObject
    "Unregister the given object in the external objects array.
     Do nothing if it isn't registered."

    |objects|

    anObject isNil ifTrue:[^ self].
    objects := SpecialObjectArray.
    1 to: objects size do: [:i |
	(objects at: i) == anObject ifTrue: [
	    objects at: i put: nil
	]
    ].
! !

!Smalltalk class methodsFor:'Compatibility-Squeak'!

windowSystemName
    "not yet fully implemented (I have to figure out, what squeak returns in each case...)"

    |platformName|

    platformName := Screen current platformName.
    platformName = #WIN32 ifTrue:[
	^ #Win32.
    ].
    ^ platformName.

    "
     Smalltalk windowSystemName
				-> 'Win32'
    "
! !

!Socket methodsFor:'Compatibility-Squeak'!

bindTo:interfaceAddr port:portNr
    interfaceAddr isByteArray ifTrue:[
        interfaceAddr size == 4 ifTrue:[
            ^ self bindTo:(IPSocketAddress hostAddress:interfaceAddr port:portNr).
        ].
    ].
    self error:'check Squeak compatibility here'.
! !

!Socket methodsFor:'Compatibility-Squeak'!

localAddress
    ^ self getFullSocketAddress printString
    "/ ^ self address
! !

!Socket methodsFor:'Compatibility-Squeak'!

primSocketLocalPort:aSocket
    ^ self port
! !

!Socket methodsFor:'Compatibility-Squeak'!

receiveUDPDataInto:aDataBuffer
    |addr count status|

    addr := IPSocketAddress new.
    count := self receiveFrom:addr buffer:aDataBuffer.
    "/ squeak returns the result in a vector
    status := Array
                with:count
                with:addr hostAddress
                with:addr port
                with:true.
    ^ status.
! !

!Socket methodsFor:'Compatibility-Squeak'!

sendUDPData:bytes toHost:aHostAddr port:portNr
    |addr bytesXMitted|

    addr := IPSocketAddress hostAddress:aHostAddr port:portNr.
    bytesXMitted := self sendTo:addr buffer:bytes.
    bytesXMitted = bytes size ifFalse:[
        self primitiveFailed
    ].
! !

!Socket methodsFor:'Compatibility-Squeak'!

setOption: optionName value: optionValue
    |option arg1 arg2|

    option := optionName asSymbol.
    arg1 := optionValue.
    arg2 := nil.
    "/ squeak uses different argument passing for some options
    ((option == #IP_ADD_MEMBERSHIP) or:[option == #IP_DROP_MEMBERSHIP]) ifTrue:[
        arg1 := optionValue copyFrom:1 to:4.
        arg2 := optionValue copyFrom:5 to:8.
    ].
    ^ self setSocketOption:option argument:arg1 argument:arg2

    "Modified: / 04-06-2007 / 21:23:19 / cg"
! !

!Socket methodsFor:'Compatibility-Squeak'!

socketHandle
    ^ self
! !

!Socket methodsFor:'Compatibility-Squeak'!

waitForData
    self readWait

    "Created: / 04-06-2007 / 21:28:40 / cg"
! !

!Socket methodsFor:'Compatibility-Squeak'!

waitForDataForMsecs: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock
        "Seconds resolution is way too much for for instance, UDP sockets running on local network, use this when timeouts > 1 sec is desirable"
        "Wait for the given amount of milliseconds for data to arrive."

        (self readWaitWithTimeoutMs:timeout) ifTrue:[
            "/ timeout occurred
            ^ timedOutBlock value.
        ].
        self isOpen ifFalse:[
            ^ closedBlock value.
        ].
"/        startTime := Time millisecondClockValue.
"/        msecsDelta := timeout truncated.
"/        [(Time millisecondsSince: startTime) < msecsDelta] whileTrue: [
"/                (self primSocketReceiveDataAvailable: socketHandle)
"/                        ifTrue: [^self].
"/                self isConnected
"/                        ifFalse: [^closedBlock value].
"/                self readSemaphore waitTimeoutMSecs: 
"/                        (msecsDelta - (Time millisecondsSince: startTime) max: 0).
"/        ].
"/
"/        (self primSocketReceiveDataAvailable: socketHandle)
"/                ifFalse: [
"/                        self isConnected
"/                                ifTrue: [^timedOutBlock value]
"/                                ifFalse: [^closedBlock value]].
! !

!Socket methodsFor:'Compatibility-Squeak'!

waitForDataIfClosed:aBlock
    self readWait.
    self isOpen ifFalse:[
        aBlock value
    ].
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextInt32
    <resource: #obsolete>
    "Read a 32-bit signed integer from the next 4 bytes, most significant byte first"

    "/ CG: PLEASE do not use this in new code;
    "/ we want the byte order to be explicit, and seen at the call site,
    "/ as in the past, there was often confusion about it 
    "/ (people reading binary files, which worked on MSB architectures, but failed on others)
    "/ 
    self obsoleteMethodWarning:'use nextInt32MSB:'.

    ^ self nextInt32MSB: true

    "Original Squeak impl"
    "| s |
    s := 0.
    1 to: 4 do: [:i | s := (s bitShift: 8) + self next].
    (s bitAnd: 16r80000000) = 0
        ifTrue: [^ s]
        ifFalse: [^ -1 - s bitInvert32]
    "

    "Modified: / 14-09-2010 / 13:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2011 / 15:22:10 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextInt32Put: i32
    <resource: #obsolete>
    "Write a signed integer to the next 4 bytes, most significant byte first"

    "/ CG: PLEASE do not use this in new code;
    "/ we want the byte order to be explicit, and seen at the call site,
    "/ as in the past, there was often confusion about it 
    "/ (people reading binary files, which worked on MSB architectures, but failed on others)
    "/ 
    self obsoleteMethodWarning:'use nextPutInt32:MSB:'.

    self nextPutInt32:i32 MSB:true.
"/    | pos |
"/
"/    pos := i32 < 0
"/            ifTrue: [(0-i32) bitInvert32 + 1]
"/            ifFalse: [i32].
"/    1 to: 4 do: [:i | self nextPut: (pos digitAt: 5-i)].
"/    ^ i32

    "Modified: / 16-09-2011 / 15:23:08 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextLittleEndianNumber: n
    "Answer the next n bytes as a positive Integer or LargePositiveInteger, 
     where the bytes are ordered from least significant to most significant."

    ^ self nextUnsigned:n MSB:false.

"/ Original Squeak code:
"/    | bytes s |
"/
"/    bytes := self next: n.
"/    s := 0.
"/    n to: 1 by: -1 do: [:i | |b t| 
"/                              t := (s bitShift: 8).
"/                              b := bytes at: i.
"/                              s := t bitOr: b
"/                       ].
"/    ^ s

    "
     self assert:( [|s| s := #[1 2 3 4] readStream nextLittleEndianNumber:4] value = 16r04030201)
     self assert:( [|s| s := #[1 2 3 4 5 6 7 8] readStream nextLittleEndianNumber:8] value = 16r0807060504030201) 
    "

    "Modified: / 17-09-2011 / 09:07:03 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextLittleEndianNumber: n put: value
    "write a positive Integer or LargePositiveInteger as the next n bytes ordered from least significant to most significant."

    | bytes |

    bytes := ByteArray new: n.
    1 to: n do: [:i | bytes at: i put: (value digitAt: i)].
    self nextPutAll: bytes

    "Modified (format): / 16-09-2011 / 12:09:33 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextPutSqueakString: s
    "Append the string, s, to the receiver.  
     Only used by DataStream.  
     Max size of 64*256*256*256."

    | length |

    (length := s size) < 192
            ifTrue: [self nextPut: length]
            ifFalse:
                    [self nextPut: (length digitAt: 4)+192.
                    self nextPut: (length digitAt: 3).
                    self nextPut: (length digitAt: 2).
                    self nextPut: (length digitAt: 1)].
    self nextPutAll: s asByteArray.
    ^s

    "Modified: / 16-09-2011 / 15:20:30 / cg"
    "Created: / 08-02-2012 / 14:25:48 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextSqueakString
    "Read a string from the receiver. 
     The first byte is the length of the string, unless it is greater than 192, 
     in which case the first four bytes encode the length.  
     I expect to be in ascii mode when called (caller puts back to binary).
     Max size 1G."

    | length aByteArray |

    "read the length in binary mode"
    self binary.
    length := self next.            "first byte."
    length >= 192 ifTrue: [
        length := length - 192.
        1 to: 3 do: [:ii | length := length * 256 + self next]
    ].
    aByteArray := ByteArray new: length.

    self nextInto: aByteArray.
    ^aByteArray asString.

    "Created: / 26-01-2012 / 17:38:02 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextSqueakStringOld
    "Read a string from the receiver. The first byte is the length of the
     string, unless it is greater than 192, in which case the first *two* bytes
     encode the length.  
     Max size 16K. "

    | aString length |

    length := self next.            "first byte."
    length >= 192 ifTrue: [length := (length - 192) * 256 + self next].
    aString := String new: length.
    1 to: length do: [:ii | aString at: ii put: self next asCharacter].
    ^aString

    "Modified: / 16-09-2011 / 15:20:07 / cg"
    "Created: / 08-02-2012 / 14:27:45 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextString
    <resource: #obsolete>

    "/ CG: PLEASE do not use this in new code;
    "/ it is highly specific to a particular encoding style used by a particular Squeak 
    "/ application. It is not general enough to justify polluting the Stream selector namespace
    "/ with a generic name like nextString - after all, I would expect a 0-terminated string reader under that name
    "/ so please move that algorithm as utility to whoever calls this, and be prepared for this method to vanish
    self obsoleteMethodWarning:'use nextSqueakString'.
    
    "Read a string from the receiver. 
     The first byte is the length of the string, unless it is greater than 192, 
     in which case the first four bytes encode the length.  
     I expect to be in ascii mode when called (caller puts back to binary)."
    ^ self nextSqueakString

    "Modified (comment): / 26-01-2012 / 17:38:47 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextStringOld
    <resource: #obsolete>
    "/ CG: PLEASE do not use this in new code;
    "/ it is highly specific to a particular encoding style used by a particular Squeak 
    "/ application. It is not general enough to justify polluting the Stream selector namespace
    "/ with a generic name like nextString - after all, I would expect a 0-terminated string reader under that name
    "/ so please move that algorithm as utility to whoever calls this, and be prepared for this method to vanish
    self obsoleteMethodWarning:'use nextSqueakStringOld'.
    ^ self nextSqueakStringOld

    "Modified: / 08-02-2012 / 14:28:00 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextStringPut: s
    "/ CG: PLEASE do not use this in new code;
    "/ it is highly specific to a particular encoding style used by a particular Squeak 
    "/ application. It is not general enough to justify polluting the Stream selector namespace
    "/ with a generic name like nextStringPut: - after all, I would expect a 0-terminated string reader under that name
    "/ so please move that algorithm as utility to whoever calls this, and be prepared for this method to vanish

    <resource: #obsolete>

    self obsoleteMethodWarning:'use nextPutSqueakString:'.
    ^ self nextPutSqueakString: s

    "Modified: / 08-02-2012 / 14:26:25 / cg"
! !

!Stream methodsFor:'Compatibility-Squeak'!

nextWord
    <resource: #obsolete>
    "Answer the next two bytes from the receiver as an Integer, most significant byte first."

    | high low |

    self obsoleteMethodWarning:'please use nextInt16MSB:true'.

    "/ cg: what an ugly rubbish interface: returning false here instead of nil !!!!!!

    (high := self next) isNil ifTrue: [^false].
    (low := self next) isNil ifTrue: [^false].
    ^(high asInteger bitShift: 8) + low asInteger

    "Modified: / 16-09-2011 / 12:12:27 / cg"
    "Modified (format): / 16-09-2011 / 15:21:10 / cg"
! !

!String methodsFor:'Compatibility-VW5.4'!

asByteString
    ^ self asSingleByteString
! !

!String methodsFor:'Compatibility-Squeak'!

asEnglishPlural
	"Answer the plural of the receiver.  Assumes the receiver is an English noun.
	For a more comprehensive algorithm please refer to ''An Algorithmic Approach
	to English Pluralization'' by Damian Conway."

	self size < 2 ifTrue: [ ^self ].
	self asString = 'child' ifTrue: [ ^'children' ].

	((self last == $y) and: [ (self at: self size - 1) isVowel not ]) 
		ifTrue: [ ^self replaceSuffix: 'y' with: 'ies' ].
	(self endsWith: 's') ifTrue: [ ^self replaceSuffix: 's' with: 'ses' ].

	^self copyWith: $s.
! !

!String methodsFor:'Compatibility-VW5.4'!

asGUID
    "return self as a GUID (or UUID if not present)"

    GUID notNil ifTrue:[ ^ GUID fromString:self ].
    ^ self asUUID

    "
     '{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}' asGUID
    "

    "Modified: / 12-01-2011 / 12:33:58 / cg"
! !

!String methodsFor:'Compatibility-Squeak'!

deepFlattenInto: stream

	stream nextPut: self
! !

!String methodsFor:'Compatibility-Squeak'!

piecesCutWhere: aBlock 
	"Evaluate testBlock for successive pairs of the receiver elements,
	breaking the receiver into pieces between elements where
	the block evaluated to true, and return an OrderedCollection of
	those pieces."
	"'A sentence. Another sentence... Yet another sentence.'
		piecesCutWhere: [:each :next | each = $. and: [next = Character space]]"

	| pieces |
	pieces := OrderedCollection new.
	self piecesCutWhere: aBlock do: [:each | pieces add: each].
	^pieces
! !

!String methodsFor:'Compatibility-Squeak'!

piecesCutWhereCamelCase
	"Breaks apart words written in camel case.
	
	It's not simply using piecesCutWhere: because we want
	to also deal with abbreviations and thus we need to 
	decide based on three characters, not just on two:
	 ('FOOBar') piecesCutWhereCamelCase asArray = #('FOO' 'Bar').
	('FOOBar12AndSomething') piecesCutWhereCamelCase asArray = #('FOO' 'Bar' '12' 'And' 'Something')	
	"
	
	| start previous current next pieces |
	self isEmpty ifTrue: [^self].
	start := 1.
	pieces := OrderedCollection new.
	3 to: self size do: [ :index |
		previous := self at: index - 2.
		current := self at: index - 1.
		next := self at: index.
		((previous isLowercase and: [current isUppercase]) or: [
			(previous isUppercase and: [current isUppercase and: [next isLowercase ]]) or: [
				(previous isDigit not and: [current isDigit]) or: [
					previous isDigit and: [current isDigit not] 
		]]]) ifTrue: [
			pieces add: (self copyFrom: start to: index - 2).
			start := index - 1].
	].
	pieces addAll: ((self copyFrom: start to: self size) piecesCutWhere: [:a :b | 
		(a isDigit and: [b isDigit not]) or: [a isDigit not and: [b isDigit ]]]).
	^pieces
! !

!String methodsFor:'Compatibility-Squeak'!

removePrefix: prefix
	"Remove the given prefix, if present."

	^(self beginsWith: prefix) ifTrue: [ self copyFrom: 1 + prefix size to: self size ] ifFalse: [ self ]
! !

!String methodsFor:'Compatibility-Squeak'!

removeSuffix: suffix
	"Remove the given suffix, if present."

	^(self endsWith: suffix) ifTrue: [ self copyFrom: 1 to: self size - suffix size ] ifFalse: [ self ]
! !

!String methodsFor:'Compatibility-Squeak'!

replaceSuffix: suffix with: replacement
	^ (self removeSuffix: suffix), replacement
! !

!String methodsFor:'Compatibility-Squeak'!

withInternetLineEndings
    "generate a copy with all cr's replaced by crnl"

    ^ self copyReplaceAll:Character cr withAll:String crlf.
! !

!Symbol class methodsFor:'Compatibility-Squeak'!

allSymbols
    ^ self allInstances asArray

    "
     self allSymbols
    "
! !

!Symbol class methodsFor:'Compatibility-ST80'!

tableSize
    "return the size of the system's symbol table"

    "/ claus: I don't know, if the returned value should be exact.
    "/ the number below is just arbitrary ...

    ^ 10000

    "Created: 18.4.1997 / 20:52:20 / cg"
! !

!Time methodsFor:'Compatibility-Squeak'!

hour
    ^ self hours
! !

!Time methodsFor:'Compatibility-Squeak'!

minute
    ^ self minutes
! !

!Time methodsFor:'Compatibility-Squeak'!

second
    ^ self seconds
! !

!ZipArchive methodsFor:'Compatibility-Squeak'!

contentsOf: fileName
    ^ self extract: fileName asString:true

    "Created: / 11-09-2010 / 19:38:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ZipArchive methodsFor:'Compatibility-Squeak'!

testUTF8
    ^ 'äöüĴĵŅņ' 
! !

!stx_libcompat class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/extensions.st,v 1.95 2018-08-26 19:43:51 cg Exp $'
! !

