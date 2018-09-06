"{ Package: 'stx:libjavascript' }"!

!AbstractTime methodsFor:'JavaScript support'!

getHours
    "return the hours (0..24)"

    ^ self asTime hours

    "
     JavaScriptParser
	evaluate:'Date.now.getHours;'
    "
! !

!AbstractTime methodsFor:'JavaScript support'!

getMinutes
    "return the minutes (0..60)"

    ^ self asTime minutes

    "
     JavaScriptParser
	evaluate:'Date.now.getMinutes;'
    "
! !

!AbstractTime methodsFor:'JavaScript support'!

js_add: aNumberOrString
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aNumberOrString js_addFromTime:self
    "/^ self + aNumberOrString

    "Modified: / 19-05-2010 / 13:47:11 / cg"
! !

!AbstractTime methodsFor:'JavaScript support'!

js_addFromTime: aTime
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aTime + self
! !

!AbstractTime methodsFor:'JavaScript support'!

js_getMilliseconds
    "return the millieconds (0..999)"

    ^ self asTime milliseconds

    "
     JavaScriptParser
	evaluate:'Date.now.js_getMilliseconds;'
    "
! !

!AbstractTime methodsFor:'JavaScript support'!

js_getSeconds
    "return the seconds (0..60)"

    ^ self asTime seconds

    "
     JavaScriptParser
	evaluate:'Date.now.getSeconds;'
    "
! !

!ArithmeticValue methodsFor:'JavaScript support'!

js_add: aNumberOrString
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aNumberOrString js_addFromNumber:self

    "Created: / 08-08-2006 / 11:06:23 / cg"
    "Modified: / 19-05-2010 / 13:46:47 / cg"
! !

!ArithmeticValue methodsFor:'JavaScript support'!

js_addFromNumber:aNumber
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aNumber + self

    "Created: / 19-05-2010 / 13:47:42 / cg"
! !

!ArithmeticValue methodsFor:'JavaScript support'!

js_addFromTime: aTime
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aTime + self

    "Created: / 19-05-2010 / 13:48:44 / cg"
! !

!Behavior methodsFor:'Javascript support'!

js_new
    "redefinable JS-new"

    ^ self new
! !

!Behavior methodsFor:'Javascript support'!

js_new:argument
    "redefinable JS-new:"

    ^ self new:argument
! !

!Block methodsFor:'Javascript support'!

typeof
    "return a string describing what I am"

    ^ 'function'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'(function (a,b) { return a; }).typeof();'
    "
! !

!Boolean methodsFor:'Javascript support'!

js_asBoolean
    ^ self
! !

!Boolean methodsFor:'Javascript support'!

typeof
    "return a string describing what I am"

    ^ 'boolean'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'false.typeof();'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

charAt0:index
    "returns the n'th character, using a 0-based indexing scheme (sigh)"

    ^ ( self at:(index-1) ) asString.

    "
     JavaScriptParser
	evaluate:'''hello''.charAt0(0)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

charAt1:index
    "returns the n'th character, using a 1-based indexing scheme (sigh)"

    ^ ( self at:index ) asString.

    "
     JavaScriptParser
	evaluate:'''hello''.charAt1(1)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

charCodeAt0:index
    "returns the code of the n'th character, using a 0-based indexing scheme (sigh)"

    ^ ( self at:(index-1) ) codePoint.

    "
     JavaScriptParser
	evaluate:'''hello''.charCodeAt0(0)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

charCodeAt1:index
    "returns the code of the n'th character, using a 1-based indexing scheme (sigh)"

    ^ ( self at:index ) codePoint.

    "
     JavaScriptParser
	evaluate:'''hello''.charCodeAt1(1)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

indexOf0:aCharacter
    "returns the index of aCharacter, using a 0-based indexing scheme; -1 if not found (sigh)"

    aCharacter isCharacter ifFalse:[
	self assert:aCharacter size == 1.
	^ self indexOf0:(aCharacter at:1)
    ].
    ^ (self indexOf:aCharacter) - 1

    "
     JavaScriptParser
	evaluate:'''hello''.indexOf0(''l'')'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

indexOf1:aCharacter
    "returns the index of aCharacter, using a 1-based indexing scheme; 0 if not found (sigh)"

    aCharacter isCharacter ifFalse:[
	self assert:aCharacter size == 1.
	^ self indexOf1:(aCharacter at:1)
    ].
    ^ (self indexOf:aCharacter)

    "
     JavaScriptParser
	evaluate:'''hello''.indexOf0(''l'')'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

js_add:something
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ something js_addFromString:self

    "Created: / 19-05-2010 / 13:50:28 / cg"
! !

!CharacterArray methodsFor:'JavaScript support'!

js_addFromNumber:aNumber
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aNumber printString , self

    "Created: / 19-05-2010 / 13:49:34 / cg"
! !

!CharacterArray methodsFor:'JavaScript support'!

js_addFromString:aString
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aString , self

    "Created: / 19-05-2010 / 13:50:42 / cg"
! !

!CharacterArray methodsFor:'JavaScript support'!

js_addFromTime:aTime
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aTime printString , self

    "Created: / 19-05-2010 / 13:49:46 / cg"
! !

!CharacterArray methodsFor:'JavaScript support'!

js_indexOf:aCharacterOrSubstring
    "JS: collection.indexOf(character)
     JS: collection.indexOf(substring)
     returns the index of anElement/substring, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    aCharacterOrSubstring isCharacter ifTrue:[
        ^ (self indexOf:aCharacterOrSubstring)-1
    ].    
    ^ (self indexOfString:aCharacterOrSubstring)-1

    "
     JavaScriptParser
        evaluate:'''bla fasel quall''.indexOf(''fasel'')'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

js_indexOf:aCharacterOrSubstring _:startIndex
    "JS: collection.indexOf(character, startIndex)
     JS: collection.indexOf(substring, startIndex)
     returns the index of anElement, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    aCharacterOrSubstring isCharacter ifTrue:[
        ^ (self indexOf:aCharacterOrSubstring startingAt:startIndex+1)-1
    ].    
    ^ (self indexOfString:aCharacterOrSubstring startingAt:startIndex+1)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40].indexOf(20, 1)'
     JavaScriptParser evaluate:'''hello hello''.indexOf(''he'', 1)'
     JavaScriptParser evaluate:'''hello hello''.indexOf(''el'', 1)'
     JavaScriptParser evaluate:'''hello hello''.indexOf(''l'', 0)'
     JavaScriptParser evaluate:'''hello''.indexOf(''l'', 3)'
     JavaScriptParser evaluate:'''blaxxbla''.indexOf(''bla'', 2)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

js_lastIndexOf:aCharacterOrSubstring
    "JS: collection.lastIndexOf(character)
     JS: collection.lastIndexOf(substring)
     returns the index of the last occurrence of anElement/substring, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    aCharacterOrSubstring isCharacter ifTrue:[
        ^ (self lastIndexOf:aCharacterOrSubstring)-1
    ].    
    ^ (self lastIndexOfString:aCharacterOrSubstring)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40].lastIndexOf(20)'
     JavaScriptParser evaluate:'[10,20,30,40,10,20].lastIndexOf(10)'

     JavaScriptParser evaluate:'''abcdefabc''.lastIndexOf(''ab'')'
     JavaScriptParser evaluate:'''abcdefabc''.lastIndexOf(''ab'', 5)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

js_lastIndexOf:aCharacterOrSubstring _:startIndex
    "JS: collection.lastIndexOf(character, startIndex)
     JS: collection.lastIndexOf(substring, startIndex)
     returns the index of the last occurrence of anElement/substring, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    aCharacterOrSubstring isCharacter ifTrue:[
        ^ (self lastIndexOf:aCharacterOrSubstring startingAt:startIndex+1)-1
    ].    
    ^ (self lastIndexOfString:aCharacterOrSubstring startingAt:startIndex+1)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40].lastIndexOf(20)'
     JavaScriptParser evaluate:'[10,20,30,40,10,20].lastIndexOf(10, 4)'
     JavaScriptParser evaluate:'''abcdefabc''.lastIndexOf(''ab'')'
     JavaScriptParser evaluate:'''xabcdefabc''.lastIndexOf(''ab'', 5)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

js_split:separator
    "JavaScript: splits the receiver into an array of substrings"

    separator isCharacter ifTrue:[
        ^ self asCollectionOfSubstringsSeparatedBy:separator
    ].
    (separator isString and:[separator size == 1]) ifTrue:[
        ^ self asCollectionOfSubstringsSeparatedBy:(separator first)
    ].
    ^ self asCollectionOfSubstringsSeparatedByAll:separator

    "
     JavaScriptParser
        evaluate:'''bla-fasel-suelz''.split(''-'')'

     JavaScriptParser
        evaluate:'''bla - fasel - suelz''.split('' - '')'

     'bla - fasel - suelz' split:' - fasel - '
     '- fasel - suelz' split:' - fasel - '
     'bla - fasel - ' split:' - fasel - '
    "

    "Created: / 03-07-2018 / 00:31:59 / Claus Gittinger"
    "Modified (comment): / 03-07-2018 / 10:45:09 / Claus Gittinger"
! !

!CharacterArray methodsFor:'JavaScript support'!

lastIndexOf0:aCharacter
    "returns the last index of aCharacter, using a 0-based indexing scheme; -1 if not found (sigh)"

    aCharacter isCharacter ifFalse:[
	self assert:aCharacter size == 1.
	^ self lastIndexOf0:(aCharacter at:1)
    ].
    ^ (self lastIndexOf:aCharacter) - 1

    "
     JavaScriptParser
	evaluate:'''hello''.lastIndexOf0(''l'')'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

lastIndexOf1:aCharacter
    "returns the last index of aCharacter, using a 1-based indexing scheme; 0 if not found (sigh)"

    aCharacter isCharacter ifFalse:[
	self assert:aCharacter size == 1.
	^ self lastIndexOf1:(aCharacter at:1)
    ].
    ^ (self lastIndexOf:aCharacter)

    "
     JavaScriptParser
	evaluate:'''hello''.lastIndexOf1(''l'')'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

quote
    "wraps the receiver into quotes.
     This is the JavaScript standard quote function."

    ^ '"',self,'"'

    "
     JavaScriptParser evaluate:'''hello''.quote'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substr0:index
    "extracts a rest-substring, using a 0-based indexing scheme (sigh)"

    ^ self copyFrom:(index+1)

    "
     JavaScriptParser
        evaluate:'''helloWorld''.substr0(3)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substr0:index _:count
    "extracts a substring, using a 0-based indexing scheme (sigh)"

    ^ self copyFrom:(index+1) to:(index+count)

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substr0(3,4)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substr1:index
    "extracts a rest-substring, using a 1-based indexing scheme (sigh)"

    ^ self copyFrom:index

    "
     JavaScriptParser
        evaluate:'''helloWorld''.substr1(3)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substr1:index _:count
    "extracts a substring, using a 1-based indexing scheme (sigh)"

    ^ self copyFrom:index to:(index-1+count)

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substr1(3,4)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substring0:index1
    "extracts a substring, using a 0-based indexing scheme (sigh)"

    ^ self copyFrom:(index1+1)

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substring0(3)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substring0:index1 _:index2
    "extracts a substring, using a 0-based indexing scheme (sigh)"

    ^ self copyFrom:(index1+1) to:(index2+1)

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substring0(3,6)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substring1:index1
    "extracts a substring, using a 1-based indexing scheme (sigh)"

    ^ self copyFrom:index1

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substring1(3)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

substring1:index1 _:index2
    "extracts a substring, using a 1-based indexing scheme (sigh)"

    ^ self copyFrom:index1 to:index2

    "
     JavaScriptParser
	evaluate:'''helloWorld''.substring1(3,6)'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

toLowerCase
    "returns a copy of the receiver with all chars in lower case"

    ^ self asLowercase

    "
     JavaScriptParser
	evaluate:'''HeLLo''.toLowerCase'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

toUpperCase
    "returns a copy of the receiver with all chars in upper case"

    ^ self asUppercase

    "
     JavaScriptParser
	evaluate:'''HeLLo''.toUpperCase'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

trim
    "returns a copy of the receiver with all leading and trailing whiteSpace removed"

    ^ self withoutSeparators

    "
     JavaScriptParser
	evaluate:'''    He LLo   ''.trim'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

trimLeft
    "returns a copy of the receiver with all leading whiteSpace removed"

    ^ self withoutLeadingSeparators

    "
     JavaScriptParser
	evaluate:'''    HeLLo   ''.trimLeft'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

trimRight
    "returns a copy of the receiver with all trailing whiteSpace removed"

    ^ self withoutTrailingSeparators

    "
     JavaScriptParser
	evaluate:'''    HeLLo   ''.trimRight'
    "
! !

!CharacterArray methodsFor:'JavaScript support'!

typeof
    "return a string describing what I am"

    ^ 'string'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'1234.typeof()'
    "
! !

!Collection methodsFor:'JavaScript support'!

forEach:aBlock
    "same as do: for javaScript"

    ^ self do:aBlock
    
    "
     JavaScriptParser
        evaluate:'[10,20,30,40].forEach(function(el){Transcript.showCR(el);});'
    "
    "
     JavaScriptParser
        evaluate:'[10,20,30,40].map(function(el){ return el*el; });'
    "
! !

!Collection methodsFor:'JavaScript support'!

length
    "returns the length of the string"

    ^ self size

    "
     JavaScriptParser
	evaluate:'''hello''.length'
    "
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3 _:el4
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3 with:el4
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3 _:el4 _:el5
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3 with:el4 with:el5
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3 _:el4 _:el5 _:el6
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3 with:el4 with:el5 with:el6
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3 _:el4 _:el5 _:el6 _:el7
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3 with:el4 with:el5 with:el6 with:el7
! !

!Collection class methodsFor:'JS syntactic sugar'!

with:el1 _:el2 _:el3 _:el4 _:el5 _:el6 _:el7 _:el8
    "for JS easy syntax - allows: Array.with(el1, el2,...)"

    ^ self with:el1 with:el2 with:el3 with:el4 with:el5 with:el6 with:el7 with:el8
! !

!Date class methodsFor:'Javascript support'!

js_new:aString
    "return a parsed dateobejct"

    Timestamp readFrom:aString

    "
     JavaScriptParser
	evaluate:'(new Date(''July 21, 1983 01:15:00''));'
    "
! !

!Date class methodsFor:'Javascript support'!

now
    "return the current date"

    ^ Timestamp now

    "
     JavaScriptParser
	evaluate:'Date.now.getDate;'
    "
! !

!False methodsFor:'Javascript support'!

js_not
    ^ true
! !

!GenericException class methodsFor:'JavaScript support'!

js_add:anExceptionHandler
    "For JavaScript only:
     Alternative error concatenation.
     Generated for +-operator in javascript."

    ^ self , anExceptionHandler

    "Created: / 31-08-2018 / 11:36:53 / Claus Gittinger"
! !

!GenericException class methodsFor:'instance creation'!

js_new:errorString
    "sent from js in:
        throw new Error(msg)
    "

    ^ self new errorString:errorString

    "
     (Error js_new:'hello') raise
    "

    "Modified: / 28-06-2010 / 17:49:24 / cg"
! !

!Integer methodsFor:'Javascript support'!

js_asBoolean
    ^ self ~~ 0
! !

!Integer methodsFor:'Javascript support'!

js_not
    ^ self == 0
! !

!Number methodsFor:'Javascript support'!

toExponential:nDigits
    "return a string representing the number in exponential notation"

    self assert:(nDigits isInteger).
    self assert:(nDigits between:0 and:50).

    ^ self asFloat printfPrintString:('%.',nDigits printString,'f')

    "
     JavaScriptParser
	evaluate:'new Number(10000);'
    "
    "
     JavaScriptParser
	evaluate:'(new Number(10000)).toExponential(1)'
    "
! !

!Number methodsFor:'Javascript support'!

toExponential:nDigits _:nDigitsAfter
    "return a string representing the number in exponential notation"

    self assert:(nDigits isInteger).
    self assert:(nDigits between:0 and:50).
    self assert:(nDigitsAfter isInteger).
    self assert:(nDigitsAfter between:0 and:50).

    ^ self asFloat printfPrintString:('%',nDigits printString,'.',nDigitsAfter printString,'f')

    "
     JavaScriptParser
	evaluate:'(new Number(10000)).toExponential(4,2)'
    "
! !

!Number methodsFor:'Javascript support'!

toFixed:nDigits
    "return a string representing the number in fixed notation"

    self assert:(nDigits isInteger).
    self assert:(nDigits between:0 and:50).

    ^ (self asFixedPoint:nDigits) printString

    "
     JavaScriptParser
	evaluate:'(new Number(10000)).toFixed(10)'
    "
! !

!Number methodsFor:'Javascript support'!

typeof
    "return a string describing what I am"

    ^ 'number'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'1234.typeof();'

     JavaScriptParser
	evaluate:'typeof (1234)'

     JavaScriptParser
	evaluate:'typeof 1234'
    "
! !

!Number class methodsFor:'Javascript support'!

MAX_VALUE
    "in expecco/stx-JS, there is no MAX_VALUE;
     return something useful (simulate 64bits)"

    ^ 16r7FFFFFFFFFFFFFFF

    "
     JavaScriptParser
	evaluate:'Number.MAX_VALUE;'
    "
! !

!Number class methodsFor:'Javascript support'!

MIN_VALUE
    "in expecco/stx-JS, there is no MIN_VALUE;
     return something useful (simulate 64bits)"

    ^ 16r-8000000000000000

    "
     JavaScriptParser
        evaluate:'Number.MIN_VALUE;'
    "

    "Modified (comment): / 19-09-2017 / 16:31:19 / stefan"
! !

!Number class methodsFor:'Javascript support'!

NEGATIVE_INFINITY
    "return the special 'negative infinity' value"

    ^ Float negativeInfinity

    "
     JavaScriptParser
	evaluate:'Number.NEGATIVE_INFINITY;'
    "
! !

!Number class methodsFor:'Javascript support'!

NaN
    "return the special 'not a number' value"

    ^ Float NaN

    "
     JavaScriptParser
	evaluate:'Number.NaN;'
    "
! !

!Number class methodsFor:'Javascript support'!

POSITIVE_INFINITY
    "return the special 'positive infinity' value"

    ^ Float infinity

    "
     JavaScriptParser
	evaluate:'Number.POSITIVE_INFINITY;'
    "
! !

!Number class methodsFor:'Javascript support'!

js_new:argument
    ^ argument

    "
     JavaScriptParser
        evaluate:'new Number(100)'

     JavaScriptParser
        evaluate:'new Error(''hello'')'
    "

    "Modified: / 28-06-2010 / 17:27:52 / cg"
! !

!Object methodsFor:'Javascript support'!

js_addFromString:aString
    "For JavaScript only:
     Generated for +-operator in javascript."

    ^ aString , self printString

    "Created: / 19-05-2010 / 13:51:24 / cg"
! !

!Object methodsFor:'Javascript support'!

js_asBoolean
    ^ self mustBeBoolean
! !

!Object methodsFor:'Javascript support'!

js_at:index 
    "JS uses 0-based indexing"

    index isInteger ifTrue:[
        ^ self at:index+1 
    ].
    ^ self at:index 
! !

!Object methodsFor:'Javascript support'!

js_at:index put:something
    "JS uses 0-based indexing"

    index isInteger ifTrue:[
        ^ self at:index+1 put:something
    ].
    ^ self at:index put:something
! !

!Object methodsFor:'Javascript support'!

js_length
    ^ self size
! !

!Object methodsFor:'Javascript support'!

js_new
    "redefinable JS-new (for datatypes and ctypes, this is required in the inst side"

    ^ self new
! !

!Object methodsFor:'Javascript support'!

js_new:size
    "redefinable JS-new (for datatypes and ctypes, this is required in the inst side"

    ^ self new:size
! !

!Object methodsFor:'Javascript support'!

typeof
    "return a string describing what I am"

    ^ 'object'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'1234.typeof()'
    "
! !

!ParseNode methodsFor:'testing'!

isBreakStatement
    ^ false
! !

!SequenceableCollection methodsFor:'JavaScript support'!

concat:aCollection
    "obsolete: now xlated to js_concat:.
     returns a new collection consisting of the concatenation of the receiver and the argument"

    ^ self , aCollection

    "
     JavaScriptParser
        evaluate:'''hello''.concat(''world'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

doesNotUnderstand:aMessage
    |sel|
    
    "/ consider this a hack: JavaScript concat(...) is a varArg method;
    "/ here, catch js_concat with any number of args and generate the concatenation here.
    
    ((sel := aMessage selector) startsWith:'js_') ifTrue:[
        (sel startsWith:'js_concat:') ifTrue:[
            ^ self class streamContents:[:s | s nextPutAll:self. aMessage arguments do:[:each | s nextPutAll:each]].
        ].    
        "/ TODO: emulate more vararg functions
    ].    
    ^ super doesNotUnderstand:aMessage

    "
     'hello' foo.
     'hello' js_concat:'a' _:'b' _:'c' _:'d' _:'e' _:'f' _:'g' _:'h' _:'i'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

every:filterFunction
    "return true, if filterFunction returns true for all elements"

    ^ self conform:filterFunction
! !

!SequenceableCollection methodsFor:'JavaScript support'!

filter:filterFunction
    "select elements for which filterFunction returns true"

    ^ self select:filterFunction
! !

!SequenceableCollection methodsFor:'JavaScript support'!

indexOf0:anElement
    "returns the index of anElement, using a 0-based indexing scheme; -1 if not found (sigh)"

    ^ (self indexOf:anElement)-1

    "
     JavaScriptParser
        evaluate:'[10,20,30,40].indexOf0(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

indexOf1:anElement
    "returns the index of anElement, using a 1-based indexing scheme; 0 if not found (sigh)"

    ^ (self indexOf:anElement)

    "
     JavaScriptParser
	evaluate:'[10,20,30,40].indexOf1(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

join:separator
    "joins the strings of the receiver into a single string"

    ^ (self collect:#asString) asStringWith:separator

    "
     #(1 2 3 4 5 6) join:' '
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_add: aCollection
    "For JavaScript only:
     Alternative collection-concatenation.
     Generated for +-operator in javascript."

    ^ self , aCollection

    "
     'hello' + $1   - fails in ST
     'hello' + '1'  - fails in ST

     'hello' js_add: $1   - ok in JS
     'hello' js_add: '1'  - ok in JS
    "

    "Created: / 08-08-2006 / 11:05:45 / cg"
    "Modified (comment): / 31-08-2018 / 11:57:47 / Claus Gittinger"
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat
    "JS: coll.concat() 
     returns a copy of the receiver"

    ^ self copy

    "
     JavaScriptParser
        evaluate:'''hello''.concat()'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1
    "JS: collection.concat(arg1)
     returns a new collection consisting of the concatenation of the receiver and the argument"

    ^ self , arg1

    "
     JavaScriptParser
        evaluate:'''hello''.concat(''world'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1 _:arg2
    "JS: collection.concat(arg1, arg2)
     returns a new collection consisting of the concatenation of the receiver and the arguments"

    ^ self concatenate:arg1 and:arg2

    "
     JavaScriptParser
        evaluate:'''hello''.concat('' '' , ''world'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1 _:arg2 _:arg3
    "JS: collection.concat(arg1, arg2, arg3)
     returns a new collection consisting of the concatenation of the receiver and the arguments"

    ^ self concatenate:arg1 and:arg2 and:arg3

    "
     JavaScriptParser
        evaluate:'''hello''.concat('' '' , ''world'', ''2'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1 _:arg2 _:arg3 _:arg4
    "JS: collection.concat(arg1, arg2, arg3, arg4)
     returns a new collection consisting of the concatenation of the receiver and the arguments"

    ^ self concatenate:arg1 and:arg2 and:(arg3 , arg4)

    "
     JavaScriptParser
        evaluate:'''hello''.concat('' '' , ''world'', ''2'' , ''3'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1 _:arg2 _:arg3 _:arg4 _:arg5
    "JS: collection.concat(arg1, arg2, arg3, arg4, arg5)
     returns a new collection consisting of the concatenation of the receiver and the arguments"

    ^ self concatenate:arg1 and:arg2 and:(arg3 concatenate: arg4 and:arg5)

    "
     JavaScriptParser
        evaluate:'''hello''.concat('' '' , ''world'', ''2'' , ''3'' , ''4'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_concat:arg1 _:arg2 _:arg3 _:arg4 _:arg5 _:arg6
    "JS: collection.concat(arg1, arg2, arg3, arg4, arg5, arg6)
     returns a new collection consisting of the concatenation of the receiver and the arguments"

    ^ self concatenate:arg1 and:arg2 and:(arg3 concatenate: arg4 and:arg5 and:arg6)

    "
     JavaScriptParser
        evaluate:'''hello''.concat('' '' , ''world'', ''2'' , ''3'' , ''4'', ''5'')'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_indexOf:anElement
    "JS: collection.indexOf(element)
     returns the index of anElement, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    ^ (self indexOf:anElement)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40].indexOf0(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_indexOf:anElement _:startIndex
    "JS: collection.indexOf(element, startIndex)
     returns the index of anElement, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    ^ (self indexOf:anElement startingAt:startIndex+1)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40,20,10].indexOf(20,2)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_lastIndexOf:anElement
    "JS: collection.lastIndexOf(element)
     returns the index of the last occurrence of anElement, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    ^ (self lastIndexOf:anElement)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40,20,10].lastIndexOf0(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_lastIndexOf:anElement _:startIndex
    "JS: collection.lastIndexOf(element)
     returns the index of the last occurrence of anElement, using a 0-based indexing scheme; -1 if not found (sigh).
     Selector-xlation to allow redefinition in CharacterArray, which supports substring searching."

    ^ (self lastIndexOf:anElement startingAt:startIndex+1)-1

    "
     JavaScriptParser evaluate:'[10,20,30,40,20,10].lastIndexOf(20)'
     JavaScriptParser evaluate:'[10,20,30,40,20,10].lastIndexOf(20, 3)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

js_map:function
    "JS: collection.map(func)
     return a new collection collecting the results of applying function to each element in sequence"

    ^ self collect:function

    "
     JavaScriptParser
        evaluate:'''hello''.map(function(ch){ Transcript.showCR(cg); })'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

lastIndexOf0:anElement
    "returns the last index of anElement, using a 0-based indexing scheme; -1 if not found (sigh)"

    ^ (self lastIndexOf:anElement)-1

    "
     JavaScriptParser evaluate:'[10,20,30,20,40].lastIndexOf0(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

lastIndexOf1:anElement
    "returns the last index of anElement, using a 1-based indexing scheme; 0 if not found (sigh)"

    ^ (self lastIndexOf:anElement)

    "
     JavaScriptParser evaluate:'[10,20,30,20,40].lastIndexOf1(20)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

pop
    "removes and returns the last element of the collection"

    ^ self removeLast
! !

!SequenceableCollection methodsFor:'JavaScript support'!

push:value
    "adds value at the end of the collection; returns the new size"

    self addLast:value.
    ^ self size.
! !

!SequenceableCollection methodsFor:'JavaScript support'!

reduce0:filterFunction
    "apply function against two values, reducing from left to right.
     Function must be declared as: f(previousValue, currentValue, index, arr).
     Pass 0-based indices to the filter."

    |accum|

    accum := self first.
    2 to:self size do:[:idx |
	|current|

	current := self at:idx.
	accum := filterFunction value:accum value:current value:(idx-1) value:self.
    ].
    ^ accum.

    "
     #(1 2 3 4 5 6 7 8 9 10) reduce0:[:prev :this :idx :arr | prev + this]

     JavaScriptParser
	evaluate:'
[0,1,2,3,4].reduce(function(previousValue, currentValue, index, array){
  return previousValue + currentValue;
});
'

     JavaScriptParser
	evaluate:'[0,1,2,3,4].length;'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

reduce0:filterFunction _:initialValue
    "apply function against two values, reducing from left to right.
     Function must be declared as: f(previousValue, currentValue, index, arr).
     Pass 0-based indices to the filter."

    |accum|

    accum := initialValue.
    1 to:self size do:[:idx |
	|current|

	current := self at:idx.
	accum := filterFunction value:accum value:current value:(idx-1) value:self.
    ].
    ^ accum.
! !

!SequenceableCollection methodsFor:'JavaScript support'!

reduce1:filterFunction
    "apply function against two values, reducing from left to right.
     Function must be declared as: f(previousValue, currentValue, index, arr).
     Pass 1-based indices to the filter."

    |accum|

    accum := self first.
    2 to:self size do:[:idx |
	|current|

	current := self at:idx.
	accum := filterFunction value:accum value:current value:idx value:self.
    ].
    ^ accum.

    "
     #(1 2 3 4 5 6 7 8 9 10) reduce1:[:prev :this :idx :arr | prev + this]
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

reduce1:filterFunction _:initialValue
    "apply function against two values, reducing from left to right.
     Function must be declared as: f(previousValue, currentValue, index, arr).
     Pass 1-based indices to the filter."

    |accum|

    accum := initialValue.
    1 to:self size do:[:idx |
	|current|

	current := self at:idx.
	accum := filterFunction value:accum value:current value:idx value:self.
    ].
    ^ accum.

    "

    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

shift
    "removes and returns the first element of the collection"

    ^ self removeFirst
! !

!SequenceableCollection methodsFor:'JavaScript support'!

slice0:index1 _:index2
    "extracts a subcollection, using a 0-based indexing scheme"

    ^ self copyFrom:(index1+1) to:(index2+1)

    "
     JavaScriptParser
	evaluate:'''hello''.slice0(1,3)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

slice1:index1 _:index2
    "extracts a subcollection, using a 1-based indexing scheme"

    ^ self copyFrom:index1 to:index2

    "
     JavaScriptParser
	evaluate:'''hello''.slice0(1,3)'
    "
! !

!SequenceableCollection methodsFor:'JavaScript support'!

some:filterFunction
    "return true, if filterfunction returns true for any element"

    ^ self contains:filterFunction
! !

!SequenceableCollection methodsFor:'JavaScript support'!

unshift:arg
    "adds an element to the beginning of the collection"

    self addFirst:arg.
    ^ self size
! !

!Signal methodsFor:'JavaScript support'!

js_add:anExceptionHandler
    "For JavaScript only:
     Alternative error concatenation.
     Generated for +-operator in javascript."

    ^ self , anExceptionHandler

    "Created: / 31-08-2018 / 11:58:31 / Claus Gittinger"
! !

!SignalSet methodsFor:'JavaScript support'!

js_add:anExceptionHandler
    "For JavaScript only:
     Alternative error concatenation.
     Generated for +-operator in javascript."

    ^ self , anExceptionHandler

    "Created: / 31-08-2018 / 11:58:40 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

log:something
    "same as showCR:.
     Added to allow for Transcript.log(...) to be used in a similar way as
     console.log(...).
     Not for non-JavaScript usage"

    self showCR:something.

    "Created: / 30-08-2018 / 13:29:50 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1
    "for JS easy syntax - allows: Transcript.show('format %1', arg1)"

    self show:(aString bindWith:arg1).
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1 _:arg2
    "for JS easy syntax - allows: Transcript.show('format %1 %2', arg1, arg2)"

    self show:(aString bindWith:arg1 with:arg2).
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1 _:arg2 _:arg3
    "for JS easy syntax - allows: Transcript.show('format %1 %2', arg1,...)"

    self show:(aString bindWith:arg1 with:arg2 with:arg3).
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1 _:arg2 _:arg3 _:arg4
    "for JS easy syntax - allows: Transcript.show('format %1 %2', arg1,...)"

    self show:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4).
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1 _:arg2 _:arg3 _:arg4 _:arg5
    "for JS easy syntax - allows: Transcript.show('format %1 %2', arg1,...)"

    self show:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5).
! !

!Stream methodsFor:'JS syntactic sugar'!

show:aString _:arg1 _:arg2 _:arg3 _:arg4 _:arg5 _:arg6
    "for JS easy syntax - allows: Transcript.show('format %1 %2', arg1,...)"

    self show:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6).

    "Created: / 19-08-2010 / 15:39:12 / cg"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1
    <javascript: 'log/2'>
    
    "for JS easy syntax - allows: Transcript.showCR('format %1', arg1)"

    self showCR:(aString bindWith:arg1).

    "Modified: / 30-08-2018 / 13:30:39 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1 _:arg2
    <javascript: 'log/3'>

    "for JS easy syntax - allows: Transcript.showCR('format %1 %2', arg1, arg2)"

    self showCR:(aString bindWith:arg1 with:arg2).

    "Modified: / 30-08-2018 / 13:30:46 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1 _:arg2 _:arg3
    <javascript: 'log/4'>

    "for JS easy syntax - allows: Transcript.showCR('format %1 %2', arg1,...)"

    self showCR:(aString bindWith:arg1 with:arg2 with:arg3).

    "Modified: / 30-08-2018 / 13:30:53 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1 _:arg2 _:arg3 _:arg4
    <javascript: 'log/5'>

    "for JS easy syntax - allows: Transcript.showCR('format %1 %2', arg1,...)"

    self showCR:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4).

    "Modified: / 30-08-2018 / 13:30:59 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1 _:arg2 _:arg3 _:arg4 _:arg5
    <javascript: 'log/6'>

    "for JS easy syntax - allows: Transcript.showCR('format %1 %2', arg1,...)"

    self showCR:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5).

    "Modified: / 30-08-2018 / 13:31:08 / Claus Gittinger"
! !

!Stream methodsFor:'JS syntactic sugar'!

showCR:aString _:arg1 _:arg2 _:arg3 _:arg4 _:arg5 _:arg6
    <javascript: 'log/7'>

    "for JS easy syntax - allows: Transcript.showCR('format %1 %2', arg1,...)"

    self showCR:(aString bindWith:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6).

    "Created: / 19-08-2010 / 15:38:59 / cg"
    "Modified: / 30-08-2018 / 13:31:14 / Claus Gittinger"
! !

!String class methodsFor:'Javascript support'!

fromCharCode:code
    "return a string consisitng of a single character, given its code"

    |char|

    char := Character value:code.
    ^ char stringSpecies with:char

    "
     JavaScriptParser
	evaluate:'String.fromCharCode(97)'
    "
! !

!Timestamp methodsFor:'Javascript support'!

getDate
    "return the day of the month (1..31)"

    ^ self asDate day

    "
     JavaScriptParser
	evaluate:'Date.now.getDate;'
    "
! !

!Timestamp methodsFor:'Javascript support'!

getDay
    "return the day of the week (0..6); Sunday is 0"

    ^ self asDate dayOfWeek - 1

    "
     JavaScriptParser
	evaluate:'Date.now.getDay;'
    "
! !

!Timestamp methodsFor:'Javascript support'!

getFullYear
    "return the year"

    ^ self asDate year

    "
     JavaScriptParser
	evaluate:'Date.now.getFullYear;'
    "
! !

!Timestamp methodsFor:'Javascript support'!

getMonth
    "return the day of the month (1..12)"

    ^ self asDate month

    "
     JavaScriptParser
	evaluate:'Date.now.getMonth;'
    "
! !

!True methodsFor:'Javascript support'!

js_not
    ^ false
! !

!UndefinedObject methodsFor:'Javascript support'!

typeof
    "return a string describing what I am"

    ^ 'undefined'

    "
     JavaScriptParser
	evaluate:'''hello''.typeof()'

     JavaScriptParser
	evaluate:'null.typeof();'
    "
! !

!stx_libjavascript class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/extensions.st,v 1.48 2018-08-31 10:00:42 cg Exp $'
! !

