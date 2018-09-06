"
 Copyright (C) Original Authors (Kaehler, Scott Wallace and Dan Ingalls)
 Copyright (C) 2001 eXept Software AG

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MethodFinder
	instanceVariableNames:'data answers selector argMap thisData mapStage mapList
		expressions cachedClass cachedArgNum cachedSelectorLists'
	classVariableNames:'AddAndRemove Approved Blocks BlocksOptional Dangerous'
	poolDictionaries:''
	category:'Interface-Tools'
!

!MethodFinder class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original Authors (Kaehler, Scott Wallace and Dan Ingalls)
 Copyright (C) 2001 eXept Software AG

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
  a utility to find implementing methods by example.
  Give it values for a receiver, optional arguments and a desired result,
  and it will find methods which do that for you.
  Please read the online documentation for details,
  or open the MethodFinderView GUI.
  
  [example:]
    which message, answers 7, given to 4 with an argument of 3,
    and also answers 5, if sent with an arg of 5 to 0
    and 10, if send to 5 with an argument of 5:    
    
      MethodFinder methodFor: #(
                                (4 3) 7
                                (0 5) 5
                                (5 5) 10
                              )
    You guessed it; it's the '+' message. 
                              
  [author:]
    original squeak version by Ted Kaehler, Scott Wallace and Dan Ingalls.
    ported from Squeak and GUI enhanced 2001 by James Hayes james@exept.de.
    improved by Claus Gittinger.
"
! !

!MethodFinder class methodsFor:'accessing'!

abortAllSignal
    "return the value of the static variable 'AbortAllSignal' (automatically generated)"

    ^ AbortAllSignal
!

abortAllSignal:something
    "set the value of the static variable 'AbortAllSignal' (automatically generated)"

    AbortAllSignal := something.
!

addAndRemove
    "return the value of the static variable 'AddAndRemove' (automatically generated)"

    ^ AddAndRemove
!

addAndRemove:something
    "set the value of the static variable 'AddAndRemove' (automatically generated)"

    AddAndRemove := something.
!

approved
    "return the value of the static variable 'Approved' (automatically generated)"

    ^ Approved
!

approved:something
    "set the value of the static variable 'Approved' (automatically generated)"

    Approved := something.
!

blocks
    "return the value of the static variable 'Blocks' (automatically generated)"

    ^ Blocks
!

blocks:something
    "set the value of the static variable 'Blocks' (automatically generated)"

    Blocks := something.
!

dangerous
    "return the value of the static variable 'Dangerous' (automatically generated)"

    ^ Dangerous
!

dangerous:something
    "set the value of the static variable 'Dangerous' (automatically generated)"

    Dangerous := something.
! !

!MethodFinder class methodsFor:'utilities'!

methodFor: dataAndAnswers
    "Return a Smalltalk expression that computes these answers."

    | resultOC resultString |
   
    resultOC := (self new) load: dataAndAnswers; findMessage.
    resultString := 
        String streamContents: [:strm |
            resultOC do: [:exp | strm nextPut: $(; nextPutAll: exp; nextPut: $); space]
        ].

    ^ resultString
! !

!MethodFinder methodsFor:'accessing'!

answers

        ^ answers
!

data

        ^ data
!

expressions
        ^ expressions
!

selectors
        "Note the inst var does not have an S on the end"

        ^ selector
! !

!MethodFinder methodsFor:'arg maps'!

argMap
        ^ argMap 
!

makeAllMaps 
        "Make a giant list of all permutations of the args.  To find the function, we will try these permutations of the input data.  receiver, args."

        | ii |
        mapList _ Array new: argMap size factorial.
        ii _ 1.
        argMap permutationsDo: [:perm |
                mapList at: ii put: perm copy.
                ii _ ii + 1].
        mapStage _ 1.   "about to be bumped"
!

mapData 
        "Force the data through the map (permutation) to create the data to test."

        thisData _ data collect: [:realData |
                                        argMap collect: [:ind | realData at: ind]].
                
!

permuteArgs 
        "Run through ALL the permutations.  First one was as presented."

        data first size <= 1 ifTrue: [^ false]. "no other way"
        mapList isNil ifTrue: [self makeAllMaps].
        mapStage _ mapStage + 1.
        mapStage > mapList size ifTrue: [^ false].
        argMap _ mapList at: mapStage.
        self mapData.
        ^ true
!

thisData
        ^ thisData 
! !

!MethodFinder methodsFor:'find a constant'!

allNumbers
        "Return true if all answers and all data are numbers."

        answers do: [:aa | aa isNumber ifFalse: [^ false]].
        thisData do: [:vec |
                        vec do: [:nn | nn isNumber ifFalse: [^ false]]].
        ^ true
!

const
        | const |
        "See if (^ constant) is the answer"

        "quick test"
        ((const _ answers at: 1) closeTo: (answers at: 2)) ifFalse: [^ false].
        3 to: answers size do: [:ii | (const closeTo: (answers at: ii)) ifFalse: [^ false]].
        expressions add: '^ ', const printString.
        selector add: #yourself.
        ^ true
!

constDiv
        "See if (data1 // C) is the answer"
        self breakPoint:#cg.
        ^ false.

"/        const _ ((thisData at: 1) at: 1) // (answers at: 1).  "May not be right!!"
"/        got _ (subTest _ MethodFinder new copy: self addArg: const) 
"/                                searchForOne isEmpty not.
"/        got ifFalse: [^ false]. 
"/
"/        "replace data2 with const in expressions"
"/        subTest expressions do: [:exp |
"/                expressions add: (exp copyReplaceString: "copyReplaceAll:" 'data2' withString: "with:" const printString)].
"/        selector addAll: subTest selectors.
"/        ^ true
!

constLessThan
        | const subTest got minConst maxConst tt |
        "See if (data1 <= C) or (data1 >= C) is the answer"

        "quick test"
        ((answers at: 1) class superclass == Boolean) ifFalse: [^ false].
        2 to: answers size do: [:ii | 
                ((answers at: ii) class superclass == Boolean) ifFalse: [^ false]].

        minConst _ Float infinity.  maxConst _ minConst negated.
        answers withIndexDo: [:aa :ii |
                aa ifTrue: [tt _ (thisData at: ii) at: 1.
                        minConst _ minConst min: tt.
                        maxConst _ maxConst max: tt]].
        const _ (thisData at: 1) at: 1.
        got _ (subTest _ MethodFinder new copy: self addArg: minConst) 
                                searchForOne isEmpty not.
        got ifFalse: ["try other extreme for <= >= "
                got _ (subTest _ MethodFinder new copy: self addArg: maxConst) 
                                searchForOne isEmpty not]. 
        got ifFalse: [^ false]. 

        "replace data2 with const in expressions"
        subTest expressions do: [:exp |
                expressions add: (exp copyReplaceString: "copyReplaceAll:" 'data2' withString: "with:" const printString)].
        selector addAll: subTest selectors.
        ^ true
!

constLinear
        | const subTest got denom num slope offset |
        "See if (data1 * C1) + C2 is the answer.  In the form  #(C2 C1) polynomialEval: data1 "

        denom _ ((thisData at: 2) at: 1) - ((thisData at: 1) at: 1).
        denom = 0 ifTrue: [^ false].   "will divide by it"
        num _ (answers at: 2) - (answers at: 1).

    slope := (num asFloat / denom) reduce.
    offset := ((answers at: 2) - (((thisData at: 2) at: 1) * slope)) reduce.

        const _ Array with: offset with: slope.
        got _ (subTest _ MethodFinder new copy: self addArg: const) 
                                searchForOne isEmpty not.
        got ifFalse: [^ false]. 

        "replace data2 with const in expressions"
        subTest expressions do: [:exp |
                expressions add: (exp copyReplaceString: "copyReplaceAll:" 'data2' withString: "with:" const printString)].
        selector addAll: subTest selectors.
        ^ true
!

constMod
        | subTest low |
        "See if mod, (data1 \\ C) is the answer"

        low _ answers max.
        low+1 to: low+20 do: [:const |
                subTest _ MethodFinder new copy: self addArg: const.
                (subTest testPerfect: #\\) ifTrue: [
                        expressions add: 'data1 \\ ', const printString.
                        selector add: #\\.
                        ^ true]].
        ^ false
!

constMult
        | const subTest got |
        "See if (data1 * C) is the answer"

        ((thisData at: 1) at: 1) = 0 ifTrue: [^ false].
        const _ ((answers at: 1) asFloat / ((thisData at: 1) at: 1)) reduce.
        got _ (subTest _ MethodFinder new copy: self addArg: const) 
                                searchForOne isEmpty not.
        got ifFalse: [^ false]. 

        "replace data2 with const in expressions"
        subTest expressions do: [:exp |
                expressions add: (exp copyReplaceString: "copyReplaceAll:" 'data2' withString: "with:" const printString)].
        selector addAll: subTest selectors.
        ^ true
!

constPlus
        | const subTest got |
        "See if (data1 + C) is the answer"

        const _ (answers at: 1) - ((thisData at: 1) at: 1).
        got _ (subTest _ MethodFinder new copy: self addArg: const) 
                                searchForOne isEmpty not.
        got ifFalse: [^ false]. 

        "replace data2 with const in expressions"
        subTest expressions do: [:exp |
                expressions add: (exp copyReplaceString: "copyReplaceAll:" 'data2' withString: "with:" const printString)].
        selector addAll: subTest selectors.
        ^ true
! !

!MethodFinder methodsFor:'initialization'!

cleanInputs:dataAndAnswerString 
    "Find and remove common mistakes.  Complain when ill formed."
    
    |fixed ddd rs places|

    ddd := dataAndAnswerString.
    
    "/ check if user typed #true / #false instead of true / false
    
    fixed := false.
    rs := ReadStream on:ddd , ' '.
    places := OrderedCollection new.
    [
        rs upToAll_positionBefore:'#true'.
        rs atEnd
    ] whileFalse:[ places addFirst:rs position ].
    places do:[:pos | 
        ddd := ddd 
                copyReplaceFrom:pos
                to:pos
                with:''.
        fixed := true
    ].
    rs := ReadStream on:ddd.
    places := OrderedCollection new.
    [
        rs upToAll_positionBefore:'#false'.
        rs atEnd
    ] whileFalse:[ places addFirst:rs position ].
    places do:[:pos | 
        ddd := ddd 
                copyReplaceFrom:pos
                to:pos
                with:''.
        fixed := true
    ].
    fixed ifTrue:[
        self 
            information:'#(true false) are Symbols, not Booleans.  
Next time use { true. false }.'
    ].
    
    "/ check if user typed #nil instead of nil

    fixed := false.
    rs := ReadStream on:ddd.
    places := OrderedCollection new.
    [
        rs upToAll_positionBefore:'#nil'.
        rs atEnd
    ] whileFalse:[ places addFirst:rs position ].
    places do:[:pos | 
        ddd := ddd 
                copyReplaceFrom:pos
                to:pos
                with:''.
        fixed := true
    ].
    fixed ifTrue:[
        self 
            information:'#nil is a Symbol, not the authentic UndefinedObject.  
Next time use nil instead of #nil'
    ].
    ^ ddd
!

initialize
        "The methods we are allowed to use.  (MethodFinder new initialize) "
        Approved _ Set new.
        AddAndRemove _ Set new.
        Blocks _ Set new.
        BlocksOptional := Set new.
        "These modify an argument: longPrintOn: printOn: storeOn: sentTo: storeOn:base: printOn:base: absPrintExactlyOn:base: absPrintOn:base: absPrintOn:base:digitCount: writeOn: writeScanOn: possibleVariablesFor:continuedFrom:"

"Object"  
        #(
    "in class, instance creation" 
        categoryForUniclasses chooseUniqueClassName initialInstance isSystemDefined newFrom: officialClass readCarefullyFrom:
    "accessing" 
        at: basicAt: basicSize bindWithTemp: in: size yourself 
    "testing" 
        basicType ifNil: #'ifNil:ifNotNil:' ifNotNil: #'ifNotNil:ifNil:' 
        isColor isArray isFloat isFraction isInMemory isInteger isMorph isNil isNumber 
        isPoint isPseudoContext isText isTransparent isWebBrowser isCollection
        knownName notNil pointsTo: wantsSteps 
    "comparing" 
        = == closeTo: hash hashMappedBy: identityHash identityHashMappedBy: identityHashPrintString 
        ~= ~~ 
    "copying" 
        clone copy shallowCopy 
    "dependents access" 
        canDiscardEdits dependents hasUnacceptedEdits 
    "updating" 
        "changed changed: okToChange update: windowIsClosing" - not useful 
    "printing" 
        fullPrintString isLiteral longPrintString printString storeString stringForReadout stringRepresentation 
    "class membership" 
        class isKindOf: #'isKindOf:orOf:' isMemberOf: respondsTo: respondsToArithmetic  
    "error handling" 
    "user interface" 
        defaultBackgroundColor defaultLabelForInspector fullScreenSize initialExtent modelWakeUp mouseUpBalk: 
        "newTileMorphRepresentative" windowActiveOnFirstClick windowReqNewLabel: 
    "system primitives"  
        instVarAt: instVarNamed: 
    "private" 
    "associating" -> 
    "converting" 
        as: asOrderedCollection asString 
    "casing" 
        caseOf: #'caseOf:otherwise:' 
    "binding" 
        bindingOf: 
    "macpal" 
        contentsChanged #'ifKindOf:thenDo:' instanceVariableValues  
    "flagging" 
        flag: 
    "translation support" 
    "objects from disk" 
    "finalization" 
    "ST/X converting"
        literalArrayEncoding
        ) do: [:sel | Approved add: sel].

        #(
        #'at:add:' #'at:modify:' #'at:put:' #'basicAt:put:' "NOT instVar:at:"
    "message handling" 
        perform: 
        #'perform:with:' #'perform:with:with:' #'perform:with:with:with:' #'perform:withArguments:' 
        #'perform:withArguments:inSuperclass:'
        #'perform:orSendTo:' 
        ) do: [:sel | AddAndRemove add: sel].

"Boolean, True, False, UndefinedObject"  
        #(
    "logical operations" 
        & eqv: not xor: |
    "controlling" 
        and: ifFalse: #'ifFalse:ifTrue:' ifTrue: #'ifTrue:ifFalse:' or: ifNil: ifNotNil:
    "copying" 
    "testing" 
        isEmptyOrNil isNilOrEmptyCollection notEmptyOrNil
        ) do: [:sel | Approved add: sel].

"Behavior" 
        #("initialize-release"
    "accessing" 
        compilerClass decompilerClass evaluatorClass format methodDict parserClass sourceCodeTemplate subclassDefinerClass
    "testing" 
        instSize instSpec isBits isBytes isFixed isPointers isVariable isWeak isWords
    "copying"
    "printing" 
        defaultNameStemForInstances printHierarchy
    "creating class hierarchy"
    "creating method dictionary"
    "instance creation" 
        basicNew basicNew: new new:
    "accessing class hierarchy" 
        allSubclasses #'allSubclassesWithLevelDo:startingLevel:' allSuperclasses subclasses superclass withAllSubclasses withAllSuperclasses
    "accessing method dictionary" 
        allSelectors changeRecordsAt: compiledMethodAt: #'compiledMethodAt:ifAbsent:' firstCommentAt: lookupSelector: selectors selectorsDo: selectorsWithArgs: 
        "slow but useful ->" sourceCodeAt: sourceCodeAt:ifAbsent: sourceMethodAt: sourceMethodAt:ifAbsent:
    "accessing instances and variables" 
        allClassVarNames allInstVarNames allSharedPools classVarNames instVarNames instanceCount sharedPools 
        "someInstance" subclassInstVarNames
    "testing class hierarchy" 
        inheritsFrom: kindOfSubclass
    "testing method dictionary" 
        canUnderstand: classThatUnderstands: hasMethods includesSelector: #'scopeHas:ifTrue:' 
        whichClassIncludesSelector: 
        whichSelectorsAccess: whichSelectorsReferTo: #'whichSelectorsReferTo:special:byte:' whichSelectorsStoreInto:
    "enumerating"
    "user interface"
    "private" 
        indexIfCompact
    "ST/X testing method dictionary" 
        implements:  
        ) do: [:sel | Approved add: sel].

"ClassDescription"
        #(
    "initialize-release" 
    "accessing" 
        classVersion isMeta name theNonMetaClass
    "copying" 
    "printing" 
        classVariablesString instanceVariablesString sharedPoolsString
    "instance variables" 
        checkForInstVarsOK: 
    "method dictionary" 
    "organization" 
        category organization whichCategoryIncludesSelector:
    "compiling" 
        acceptsLoggingOfCompilation wantsChangeSetLogging
    "fileIn/Out" 
        definition
    "private" 
    "ST/X queries" 
        theMetaclass theNonMetaclass
        ) do: [:sel | Approved add: sel].

"Class"
        #(
    "initialize-release" 
    "accessing" 
        classPool
    "testing"
    "copying" 
    "class name" 
    "instance variables" 
    "class variables" 
        classVarAt: classVariableAssociationAt:
    "pool variables" 
    "compiling" 
    "subclass creation" 
    "fileIn/Out" 
    "ST/X queries" 
        nameSpace nameWithoutPrefix nameWithoutNameSpacePrefix
        ) do: [:sel | Approved add: sel]. 

"Metaclass"
        #("initialize-release" 
    "accessing" 
        isSystemDefined soleInstance
    "copying" "instance creation" "instance variables"  
    "pool variables" "class hierarchy"  "compiling"
    "fileIn/Out"  
        nonTrivial 
        ) do: [:sel | Approved add: sel].

"Context, BlockContext"
        #(
        receiver client method receiver tempAt: 
    "debugger access" 
        mclass pc selector sender shortStack sourceCode tempNames tempsAndValues
    "controlling"  "printing" "system simulation" 
    "initialize-release" 
    "accessing" 
        hasMethodReturn home numArgs
    "evaluating" 
        value #'value:ifError:' #'value:value:' #'value:value:value:' #'value:value:value:value:' #'valueWithArguments:'
    "controlling"  "scheduling"  "instruction decoding"  "printing" "private"  "system simulation" ) do: [:sel | Approved add: sel].
        #(value: "<- Association has it as a store" 
        ) do: [:sel | AddAndRemove add: sel].

"Message"
        #(
    "inclass, instance creation" 
        selector: #'selector:argument:' #'selector:arguments:'
    "accessing" 
        argument argument: arguments sends:
    "printing" "sending" 
        ) do: [:sel | Approved add: sel].
        #(
    "private" 
        #'setSelector:arguments:'
        ) do: [:sel | AddAndRemove add: sel].

"Magnitude"
        #(
    "comparing" 
        < <= > >= #'between:and:'
    "testing" 
        max: min: min:max: 
        ) do: [:sel | Approved add: sel].

"Date, Time"
        #(
    "in class, instance creation" 
        fromDays: fromSeconds: fromString: #'newDay:month:year:' #'newDay:year:' today
    "in class, general inquiries" 
        dateAndTimeNow dayOfWeek: #'daysInMonth:forYear:' daysInYear: #'firstWeekdayOfMonth:year:' indexOfMonth: leapYear: nameOfDay: nameOfMonth:
    "accessing" 
        day isLeapYear "leap" monthIndex monthName weekday year
    "arithmetic" 
        addDays: subtractDate: subtractDays:
    "comparing"
    "inquiries" 
        dayOfMonth daysInMonth daysInYear daysLeftInMonth daysLeftInYear firstDayOfMonth previous:
    "converting" 
        asSeconds asDays
    "printing" 
        mmddyy mmddyyyy printFormat: printOn:format:
    "private" 
        firstDayOfMonthIndex: weekdayIndex 

    "in class, instance creation" 
        fromSeconds: now 
    "in class, general inquiries" 
        dateAndTimeFromSeconds: dateAndTimeNow millisecondClockValue millisecondsToRun: totalSeconds
    "accessing" 
        hours minutes seconds
    "arithmetic" 
        addTime: subtractTime:
    "comparing"
    "printing" 
        intervalString print24 
    "converting"
    "st/x" 
        dayOfWeek abbreviatedDayName abbreviatedMonthName 
        abbreviatedMonthNameForLanguage: dayCount dayInWeek dayInYear
        monthNameForLanguage: weekInYear daysSince: daysUntil: 
        asTimestamp asDate
        timeZoneDeltaInMinutes asTime asTimeDuration asMilliseconds
        asUtcTimestamp utcSecondsSince1901 printStringIso8601Format
        printString12HourFormat printString24HourFormat
        days utcOffset millisecondDeltaFrom: secondDeltaFrom:
        ) do: [:sel | Approved add: sel].
        #(
    "private" 
        hours: #'hours:minutes:seconds:' #'day:year:' 
        ) do: [:sel | AddAndRemove add: sel].

"Number"
        #(
    "in class" 
        #'readFrom:base:' 
    "arithmetic" 
        * + - / // \\ abs negated quo: reciprocal rem: 
    "mathematical functions" 
        arcCos arcSin arcTan arcTan: cos exp floorLog: ln log log: raisedTo: raisedToInteger: sin sqrt squared tan
    "truncation and round off" 
        ceiling #'detentBy:atMultiplesOf:snap:' floor roundTo: roundUpTo: rounded truncateTo: truncated
    "comparing"
    "testing" 
        even isDivisibleBy: isInf isInfinite isNaN isZero negative odd positive sign strictlyPositive
    "converting" 
        @ asInteger asNumber asPoint asSmallAngleDegrees degreesToRadians radiansToDegrees 
        asFixedPoint asFixedPoint: asFixedPointRoundedToScale asFixedPointRoundedToScale:
        asFloat asFraction
    "intervals" 
        to: #'to:by:' 
    "printing" 
        printStringBase: storeStringBase: 

    "ST/X in class"         
        #'readFrom:base:' 
    "ST/X intervals"        
        downTo: #'downTo:by:'
    "ST/X printing"         
        radixPrintStringRadix: printStringRadix: storeStringRadix: romanPrintString
        ) do: [:sel | Approved add: sel].

"Integer"
        #(
    "in class" 
        primesUpTo:
    "testing" 
        isPowerOfTwo isPowerOf: digitBytes isPrime nextPrime
    "arithmetic" 
        alignedTo:
    "comparing"
    "truncation and round off" 
        atRandom normalize
    "enumerating" 
        timesRepeat:
    "mathematical functions" 
        degreeCos degreeSin factorial gcd: lcm: binco: take: primeFactors
    "bit manipulation" 
        << >> allMask: anyMask: bitAnd: bitClear: bitInvert bitInvert32 bitOr: bitShift: bitXor: 
              highBit lowBit bitCount noMask:
    "converting" 
        asCharacter asColorOfDepth: asFloat asFraction asHexDigit
    "printing" 
        asStringWithCommas hex hex8 radix:
    "system primitives" 
        lastDigit #'replaceFrom:to:with:startingAt:'
    "private" "benchmarks" 

    "ST/X printing"       
        hexPrintString 

        ) do: [:sel | Approved add: sel].

"SmallInteger, LargeNegativeInteger, LargePositiveInteger"
        #(
    "arithmetic" 
    "bit manipulation" 
    "testing" "comparing" "copying" "converting" "printing" 
    "system primitives" 
        digitAt: digitLength 
    "private" 
        #'fromString:radix:' 
        ) do: [:sel | Approved add: sel].

        #((#'digitAt:put:') ) do: [:sel | AddAndRemove add: sel].

"Float"
        #(
    "arithmetic"
    "mathematical functions" 
        reciprocalFloorLog: reciprocalLogBase2 timesTwoPower:
    "comparing" "testing"
    "truncation and round off" 
        exponent fractionPart integerPart significand significandAsInteger
    "converting" 
        asApproximateFraction asIEEE32BitWord asTrueFraction
    "copying"
        ) do: [:sel | Approved add: sel].

"Fraction, Random"
        #(
        denominator numerator reduced next nextValue
        ) do: [:sel | Approved add: sel].
        #(
        #'setNumerator:denominator:'
        ) do: [:sel | AddAndRemove add: sel].

"Collection"
        #(
    "accessing" 
        anyOne
    "testing" 
        includes: includesAllOf: includesAnyOf: includesSubstringAnywhere: 
        isEmpty notEmpty isSequenceable occurrencesOf:
    "enumerating" 
        collect: #'collect:thenSelect:' count: contains:
        detect: #'detect:ifNone:' detectMax: detectMin: detectSum: 
        #'inject:into:' reject: select: #'select:thenCollect:'  map:
    "converting" 
        asArray asBag asCharacterSet asSet asSortedArray asSortedCollection asSortedCollection:
        asStringWith: asNilIfEmpty asOrderedCollection
    "printing"
    "private" 
        maxSize largest: smallest: 
    "arithmetic"
    "math functions" 
        average max median min range sum product abs minMax
        ) do: [:sel | Approved add: sel].

        #(
    "adding" 
        add: addAll: addIfNotPresent:
    "removing" 
        remove: #'remove:ifAbsent:' removeAll: removeAllFoundIn: removeAllSuchThat: #'remove:ifAbsent:'
        ) do: [:sel | AddAndRemove add: sel].

"SequenceableCollection"
        #(
    "comparing" 
        hasEqualElements:
    "accessing" allButFirst allButLast at:ifAbsent: atAll: atPin: atRandom: atWrap: 
        fifth first fourth last second sixth third  nth:
        identityIndexOf: #'identityIndexOf:startingAt:' #'identityIndexOf:ifAbsent:' #'identityIndexOf:startingAt:ifAbsent:'
        indexOf:         #'indexOf:startingAt:'         #'indexOf:ifAbsent:'     #'indexOf:startingAt:ifAbsent:' 
        lastIndexOf:     #'lastIndexOf:startingAt:'     #'lastIndexOf:ifAbsent:' #'lastIndexOf:startingAt:ifAbsent:' 
        #'indexOfSubCollection:' 
        #'indexOfSubCollection:ifAbsent:' 
        #'indexOfSubCollection:startingAt:' 
        #'indexOfSubCollection:startingAt:ifAbsent:' 
        #'lastIndexOfSubCollection:' 
        #'lastIndexOfSubCollection:ifAbsent:' 
        #'lastIndexOfSubCollection:startingAt:' 
        #'lastIndexOfSubCollection:startingAt:ifAbsent:' 

    "removing"
    "copying" 
        , copyAfterLast: #'copyAt:put:' #'copyFrom:to:' #'copyReplaceAll:with:' #'copyReplaceFrom:to:with:' copyUpTo: copyUpToLast: copyWith: copyWithout: copyWithoutAll: #'forceTo:paddingWith:' shuffled sortBy:
    "enumerating" 
        collectWithIndex: findFirst: findLast: pairsCollect: #'with:collect:' withIndexCollect: polynomialEval:
    "converting" 
        asArray asDictionary asFloatArray asIntegerArray asStringWithCr asWordArray reversed
    "private" 
        #'copyReplaceAll:with:asTokens:' 

    "ST/X copying"        
        copyButLast: copyLast:  copyFrom: copyTo:  last: first:
    "ST/X testing"        
        longestCommonPrefix
        ) do: [:sel | Approved add: sel].

        #( swap:with:
        ) do: [:sel | AddAndRemove add: sel].

"ArrayedCollection, Bag"
        #(
    "private" 
        defaultElement 
    "sorting" 
        isSorted
    "accessing" 
        cumulativeCounts sortedCounts sortedElements 
    "testing" "adding" 
        #'add:withOccurrences:' 
    "removing" "enumerating" 
        ) do: [:sel | Approved add: sel].

        #( 
        #'mergeSortFrom:to:by:' sort sort: add: #'add:withOccurrences:'
    "private" 
        setDictionary 
        ) do: [:sel | AddAndRemove add: sel].

"Other messages that modify the receiver"
        #(
        #'atAll:put:' #'atAll:putAll:' atAllPut: #'atWrap:put:' 
        #'replaceAll:with:' #'replaceFrom:to:with:'  removeFirst removeLast
    "ST/X filling & replacing" 
        reverse
        ) do: [:sel | AddAndRemove add: sel].

        self initialize2.

"
MethodFinder new initialize.
MethodFinder new organizationFiltered: Set
"

    "Modified: / 02-08-2010 / 13:33:57 / cg"
!

initialize2
        "The methods we are allowed to use.  (MethodFinder new initialize) "

"Set"
        #(
    "in class" 
        sizeFor:
    "testing" "adding" "removing" "enumerating"
    "private" 
        array findElementOrNil: 
    "accessing" 
        "/ someElement anElement anyOne
        anElement anyOne
        ) do: [:sel | Approved add: sel].

"Dictionary, IdentityDictionary, IdentitySet"
        #(
    "accessing" 
        associationAt: #'associationAt:ifAbsent:' #'at:ifPresent:' keyAtIdentityValue: #'keyAtIdentityValue:ifAbsent:' keyAtValue: #'keyAtValue:ifAbsent:' keys
    "testing" 
        includesKey: 
        ) do: [:sel | Approved add: sel].
        #(
        removeKey: #'removeKey:ifAbsent:'
        ) do: [:sel | AddAndRemove add: sel].

"LinkedList, Interval, MappedCollection"
        #(
    "in class"  
        #'from:to:' #'from:to:by:'
    "accessing" 
        contents) do: [:sel | Approved add: sel].
        #(
    "adding" 
        addFirst: addLast:) do: [:sel | AddAndRemove add: sel].

"OrderedCollection, SortedCollection"
        #(
    "accessing" 
        after: before:
    "copying" 
        copyEmpty
    "adding"  
        growSize
    "removing" "enumerating" "private" 
    "accessing" 
        sortBlock) do: [:sel | Approved add: sel].
        #(
    "adding" 
        #'add:after:' #'add:afterIndex:' #'add:before:' addAllFirst: addAllLast: addFirst: addLast:
    "removing" 
        removeAt: removeFirst removeLast
    "accessing" 
        sortBlock:) do: [:sel | AddAndRemove add: sel].

"Character"
        #(
    "in class, instance creation" 
        allCharacters digitValue: new separators
    "accessing untypeable characters" 
        backspace cr enter lf linefeed nbsp newPage space tab
    "constants" 
        alphabet characterTable
    "accessing" 
        asciiValue digitValue
    "comparing"
    "queries"
        bitsPerCharacter
    "testing" 
        isAlphaNumeric isDigit isLetter isLetterOrUnderline isLowercase isSafeForHTTP isSeparator isSpecial 
        isUppercase isVowel tokenish isNationalAlphaNumeric isNationalDigit isNationalLetter
    "copying"
    "converting" 
        asIRCLowercase asLowercase asUppercase rot13 rot:
        ) do: [:sel | Approved add: sel].

"String"
        #(
    "in class, instance creation" 
        crlf fromPacked:
    "primitives" 
        #'findFirstInString:inSet:startingAt:' #'indexOfAscii:inString:startingAt:'      "internet" valueOfHtmlEntity:
    "accessing" 
        byteAt: endsWithDigit #'findAnySubStr:startingAt:' findBetweenSubStrs: 
        #'findDelimiters:startingAt:' 
        #'findString:startingAt:' #'findString:startingAt:caseSensitive:' 
        findTokens: #'findTokens:includes:' #'findTokens:keep:' 
        includesSubString: #'includesSubstring:caseSensitive:' 
        #'indexOf:startingAt:' 
        indexOfAnyOf: #'indexOfAnyOf:ifAbsent:' #'indexOfAnyOf:startingAt:' #'indexOfAnyOf:startingAt:ifAbsent:' 
        lineCorrespondingToIndex: lineCount lineNumber: 
        #'skipAnySubStr:startingAt:' #'skipDelimiters:startingAt:' startsWithDigit
    "comparing" 
        alike: beginsWith: caseSensitiveLessOrEqual: charactersExactlyMatching: compare: crc16 
        endsWith: endsWithAnyOf: sameAs: 
        #'startingAt:match:startingAt:'
    "copying" 
        #'copyReplaceTokens:with:' #'padded:to:with:'
    "converting" 
        asByteArray asDate asDisplayText asFilename asHtml asLegalSelector asPacked asParagraph asText asTime asUnHtml asUrl asUrlRelativeTo: 
        #capitalized compressWithTable: contractTo: correctAgainst: 
        encodeForHTTP initialIntegerOrNil keywords quoted sansPeriodSuffix 
        splitInteger stemAndNumericSuffix substrings surroundedBySingleQuotes 
        truncateWithElipsisTo: withBlanksTrimmed withFirstCharacterDownshifted 
        withNoLineLongerThan: withSeparatorsCompacted withoutLeadingDigits 
        withoutTrailingBlanks
    "displaying" "printing"
    "system primitives" 
        #'compare:with:collated:' 
    "Celeste" 
        withCRs
    "internet" 
        decodeMimeHeader decodeQuotedPrintable replaceHtmlCharRefs unescapePercents withInternetLineEndings withSqueakLineEndings withoutQuoting
    "testing" 
        isAllSeparators lastSpacePosition isBlank isEmpty
    "paragraph support" 
        indentationIfBlank:
    "arithmetic" 
    "queries"
        bitsPerCharacter contains8BitCharacters knownAsSymbol
    "ST/X copying"
        paddedTo: paddedTo:with: centerPaddedTo: centerPaddedTo:with:
        decimalPaddedTo:and:at:
        leftPaddedTo: leftPaddedTo:with:
        chopTo: contractAtBeginningTo: contractAtEndTo: contractTo:
    "ST/X comparing"
        compareWith: sameCharacters: sameEmphasisAs: sameStringAndEmphasisAs:
    "ST/X searching"
        indexOfSeparator indexOfSeparatorStartingAt:
        lastIndexOfSeparator lastIndexOfSeparatorStartingAt:
        indexOfNonSeparatorStartingAt:
    "ST/X printing" 
        sscanf:
        printf:
    "ST/X converting" 
        asUppercaseFirst 
        asCollectionOfWords asCollectionOfLines 
        asCollectionOfSubstringsSeparatedBy: asCollectionOfSubstringsSeparatedByAny:
    "Ansi"
        addLineDelimiters
    ) do: [:sel | Approved add: sel].
        #(#'byteAt:put:' translateToLowercase match:) do: [:sel | AddAndRemove add: sel].

"Symbol"
        #(
    "in class, private" 
        hasInterned:ifTrue:
    "access" 
        morePossibleSelectorsFor: possibleSelectorsFor: selectorsContaining: #'thatStarts:skipping:'
    "accessing" "comparing" "copying" "converting" "printing" 
    "testing" 
        isInfix isKeyword isPvtSelector isUnary) do: [:sel | Approved add: sel].

"Array"
        #(
    "comparing" 
    "converting" 
        evalStrings 
    "printing" "private" 
        hasLiteralSuchThat:) do: [:sel | Approved add: sel].

"Array2D"
        #(
    "access" 
        #'at:at:' atCol: #'atCol:put:' atRow: extent #'extent:fromArray:' height width #'width:height:type:'
        ) do: [:sel | Approved add: sel].
        #(#'at:at:add:' #'at:at:put:' #'atRow:put:' ) do: [:sel | AddAndRemove add: sel].

"ByteArray"
        #(
    "accessing" 
        doubleWordAt: wordAt: 
    "platform independent access" 
        #'longAt:bigEndian:' #'shortAt:bigEndian:' #'unsignedLongAt:bigEndian:' #'unsignedShortAt:bigEndian:' 
    "converting") do: [:sel | Approved add: sel].
        #(#'doubleWordAt:put:' #'wordAt:put:' #'longAt:put:bigEndian:' #'shortAt:put:bigEndian:' #'unsignedLongAt:put:bigEndian:' #'unsignedShortAt:put:bigEndian:'
        ) do: [:sel | AddAndRemove add: sel].

"FloatArray"            "Don't know what happens when prims not here"
        false ifTrue: [#(
    "accessing" 
    "arithmetic" 
        *= += -= /=
    "comparing"
    "primitives-plugin" 
        primAddArray: primAddScalar: primDivArray: primDivScalar: primMulArray: primMulScalar: primSubArray: primSubScalar:
    "primitives-translated" 
        #'primAddArray:withArray:from:to:' #'primMulArray:withArray:from:to:' #'primSubArray:withArray:from:to:'
    "converting" "private" "user interface"
        ) do: [:sel | Approved add: sel].
        ].

"IntegerArray, WordArray"
"RunArray"
        #(
    "in class, instance creation" 
        #'runs:values:' scanFrom:
    "accessing" 
        runLengthAt: 
    "adding" "copying"
    "private" 
        runs values
        ) do: [:sel | Approved add: sel].
        #(coalesce #'addLast:times:' #'repeatLast:ifEmpty:' repeatLastIfEmpty:
                ) do: [:sel | AddAndRemove add: sel].

"Stream  -- many operations change its state"
        #(
    "testing" 
        atEnd) do: [:sel | Approved add: sel].
        #(
    "accessing" 
        next: nextMatchAll: nextMatchFor: upToEnd
        #'next:put:' nextPut: nextPutAll: 
    "printing" print: printHtml:
        ) do: [:sel | AddAndRemove add: sel].

"PositionableStream"
        #(
    "accessing" 
        contentsOfEntireFile originalContents peek peekFor: "testing"
    "positioning" 
        position 
    ) do: [:sel | Approved add: sel].
        #(nextDelimited: nextLine upTo: position: reset resetContents setToEnd skip: skipTo: upToAll: ) do: [:sel | AddAndRemove add: sel].
        "Because it is so difficult to test the result of an operation on a Stream 
         (you have to supply another Stream in the same state), 
         we don't support Streams beyond the basics.  
         We want to find the messages that convert Streams to other things."

"ReadWriteStream"
        #(
    "file status" 
        closed) do: [:sel | Approved add: sel].
        #(
    "accessing" 
        next: on: ) do: [:sel | AddAndRemove add: sel].

"WriteStream"
        #(
    "in class, instance creation" 
        on:from:to: with: with:from:to:
                ) do: [:sel | Approved add: sel].
        #(
    "positioning" 
        resetToStart
    "character writing" 
        crtab crtab:) do: [:sel | AddAndRemove add: sel].

"LookupKey, Association, Link"
        #(
    "accessing" 
        key nextLink) do: [:sel | Approved add: sel].
        #(key: #'key:value:' nextLink:) do: [:sel | AddAndRemove add: sel].

"Point"
        #(
    "in class, instance creation" 
        #'r:degrees:' #'x:y:'
    "accessing" 
        x y 
    "comparing" "arithmetic" "truncation and round off"
    "polar coordinates" 
        degrees r theta
    "point functions" 
        bearingToPoint: crossProduct: dist: dotProduct: eightNeighbors #'flipBy:centerAt:' fourNeighbors grid: 
        #'nearestPointAlongLineFrom:to:' #'nearestPointOnLineFrom:to:' 
        normal normalized octantOf: 
        #'onLineFrom:to:' #'onLineFrom:to:within:' 
        quadrantOf: #'rotateBy:centerAt:' transposed unitVector
    "converting" 
        asFloatPoint asIntegerPoint corner: extent: rect:
    "transforming" 
        adhereTo: #'rotateBy:about:' scaleBy: #'scaleFrom:to:' translateBy: "copying"
    "interpolating" 
        #'interpolateTo:at:'
        ) do: [:sel | Approved add: sel].

"Rectangle"
        #("in class, instance creation" #'center:extent:' encompassing: #'left:right:top:bottom:' 
        merging: #'origin:corner:' #'origin:extent:' 
    "accessing" 
        area bottom bottomCenter bottomLeft bottomRight boundingBox center corner corners innerCorners 
        left leftCenter origin right rightCenter top topCenter topLeft topRight
    "comparing"
    "rectangle functions" 
        #'adjustTo:along:' amountToTranslateWithin: areasOutside: #'bordersOn:along:' encompass: 
        expandBy: extendBy: #'forPoint:closestSideDistLen:' 
        insetBy: #'insetOriginBy:cornerBy:' intersect: 
        merge: pointNearestTo: quickMerge: #'rectanglesAt:height:' 
        sideNearestTo: translatedToBeWithin: 
        withBottom: withHeight: withLeft: withRight: #'withSide:setTo:' withTop: withWidth:
    "testing" 
        containsPoint: containsRect: hasPositiveExtent intersects: isTall isWide
    "truncation and round off"
    "transforming" 
        #'align:with:' centeredBeneath: newRectFrom: squishedWithin: "copying"
        ) do: [:sel | Approved add: sel].

"Color"
        #(
    "in class, instance creation" 
        colorFrom: #'colorFromPixelValue:depth:' fromRgbTriplet: gray: #'h:s:v:' #'r:g:b:' #'r:g:b:alpha:' #'r:g:b:range:'
    "ST/X in class, instance creation" 
        colorNamed:
    "named colors" 
        black blue brown cyan darkGray gray green lightBlue lightBrown lightCyan lightGray lightGreen lightMagenta lightOrange lightRed lightYellow 
        magenta orange red transparent veryDarkGray veryLightGray veryVeryDarkGray veryVeryLightGray white yellow
    "other" 
        colorNames indexedColors pixelScreenForDepth: quickHighLight:
    "access" 
        alpha blue brightness green hue luminance red saturation
    "equality"
    "queries" 
        isBitmapFill isBlack isGray isSolidFill isTranslucent isTranslucentColor
    "transformations" 
        alpha: dansDarker darker lighter #'mixed:with:' muchLighter slightlyDarker slightlyLighter veryMuchLighter #'alphaMixed:with:'
    "groups of shades" 
        darkShades: lightShades: #'mix:shades:' wheel:
    "printing" 
        shortPrintString
    "other" 
        colorForInsets rgbTriplet
    "conversions" 
        asB3DColor asColor balancedPatternForDepth: bitPatternForDepth: closestPixelValue1 closestPixelValue2 closestPixelValue4 closestPixelValue8 dominantColor 
        halfTonePattern1 halfTonePattern2 indexInMap: pixelValueForDepth: #'pixelWordFor:filledWith:' pixelWordForDepth: scaledPixelValue32
    "private" 
        privateAlpha privateBlue privateGreen privateRGB privateRed 
    "copying"
    "ST/X access" 
        redByte greenByte blueByte alphaByte rgbValue almostSameAs:
        ) do: [:sel | Approved add: sel].

"       For each selector that requires a block argument, add (selector argNum) 
                to the set Blocks."
"ourClasses _ #(Object Boolean True False UndefinedObject Behavior ClassDescription Class Metaclass MethodContext BlockContext Message Magnitude Date Time Number Integer 
                SmallInteger LargeNegativeInteger LargePositiveInteger Float Fraction Random Collection SequenceableCollection ArrayedCollection Bag Set 
                Dictionary IdentityDictionary IdentitySet LinkedList Interval MappedCollection OrderedCollection SortedCollection Character String Symbol Array 
                Array2D ByteArray FloatArray IntegerArray WordArray RunArray Stream PositionableStream ReadWriteStream WriteStream LookupKey Association Link Point Rectangle Color).
ourClasses do: [:clsName | cls _ Smalltalk at: clsName.
        (cls selectors) do: [:aSel |
                ((Approved includes: aSel) or: [AddAndRemove includes: aSel]) ifTrue: [
                        (cls formalParametersAt: aSel) withIndexDo: [:tName :ind |
                                (tName endsWith: 'Block') ifTrue: [
                                        Blocks add: (Array with: aSel with: ind)]]]]].
"
        #(
            (timesRepeat: 1 ) (indexOf:ifAbsent: 2 ) (pairsCollect: 1 ) (#'mergeSortFrom:to:by:' 3 ) 
            (#'ifNotNil:ifNil:' 1 ) (#'ifNotNil:ifNil:' 2 ) (ifNil: 1 ) (#'at:ifAbsent:' 2 ) 
            (#'ifNil:ifNotNil:' 1 ) (#'ifNil:ifNotNil:' 2 ) (ifNotNil: 1 ) (#'at:modify:' 2 ) 
            (#'identityIndexOf:ifAbsent:' 2 ) (sort: 1 ) (sortBlock: 1 ) 
            (detectMax: 1 ) (repeatLastIfEmpty: 1 ) (#'allSubclassesWithLevelDo:startingLevel:' 1 ) 
            (#'keyAtValue:ifAbsent:' 2 ) (in: 1 ) 
            (ifTrue: 1 ) (or: 1 ) (select: 1 ) (inject:into: 2 ) (#'ifKindOf:thenDo:' 2 ) 
            (#'forPoint:closestSideDistLen:' 2 ) (#'value:ifError:' 2 ) (selectorsDo: 1 ) 
            (removeAllSuchThat: 1 ) (#'keyAtIdentityValue:ifAbsent:' 2 ) (detectMin: 1 ) 
            (#'detect:ifNone:' 1 ) (#'ifTrue:ifFalse:' 1 ) (#'ifTrue:ifFalse:' 2 ) 
            (#'detect:ifNone:' 2 ) (hasLiteralSuchThat: 1 ) (#'indexOfAnyOf:ifAbsent:' 2 ) 
            (reject: 1 ) (newRectFrom: 1 ) (#'removeKey:ifAbsent:' 2 ) (#'at:ifPresent:' 2 ) 
            (#'associationAt:ifAbsent:' 2 ) (withIndexCollect: 1 ) (#'repeatLast:ifEmpty:' 2 ) 
            (findLast: 1 ) (#'indexOf:startingAt:ifAbsent:' 3 ) (#'remove:ifAbsent:' 2 ) 
            (#'ifFalse:ifTrue:' 1 ) (#'ifFalse:ifTrue:' 2 ) (#'caseOf:otherwise:' 2 ) (count: 1 ) (collect: 1 ) (sortBy: 1 ) (and: 1 ) (asSortedCollection: 1 ) 
            (#'with:collect:' 2 ) (#'sourceCodeAt:ifAbsent:' 2 ) (detect: 1 ) (#'scopeHas:ifTrue:' 2 ) (collectWithIndex: 1 ) (#'compiledMethodAt:ifAbsent:' 2 ) 
            (bindWithTemp: 1 ) (detectSum: 1 ) (#'indexOfSubCollection:startingAt:ifAbsent:' 3 ) (findFirst: 1 ) (#'sourceMethodAt:ifAbsent:' 2 ) (#'collect:thenSelect:' 1 ) 
            (#'collect:thenSelect:' 2 ) (#'select:thenCollect:' 1 ) (#'select:thenCollect:' 2 ) (ifFalse: 1 ) (#'indexOfAnyOf:startingAt:ifAbsent:' 3 ) (#'indentationIfBlank:' 1 ) 
        ) do: [:anArray |
            Blocks add: anArray].

        #(
            (ifFalse: 1 )
            (ifTrue: 1 )
            (#'ifFalse:ifTrue:' 1 ) (#'ifFalse:ifTrue:' 2 )
            (#'ifTrue:ifFalse:' 1 ) (#'ifTrue:ifFalse:' 2 )
        ) do: [:anArray |
            BlocksOptional add: anArray].

"
MethodFinder new initialize.
MethodFinder new organizationFiltered: TranslucentColor class 
"
"Do not forget class messages for each of these classes"

    "Modified: / 13.11.2001 / 19:28:41 / cg"
!

load:dataWithAnswers 
    "Find a function that takes the data and gives the answers.  Odd list entries are data for it, even ones are the answers.  nil input means data and answers were supplied already."
    "  (MethodFinder new) load: #( (4 3) 7  (-10 5) -5  (-3 11) 8);
                    findMessage"
    
    dataWithAnswers 
        ifNotNil:[
            data := Array new:dataWithAnswers size // 2.
            1 to:data size do:[:ii | 
                data at:ii put:(dataWithAnswers at:ii * 2 - 1)
            ].
            answers := Array new:data size.
            1 to:answers size do:[:ii | 
                answers at:ii put:(dataWithAnswers at:ii * 2)
            ]
        ].
    data do:[:list | 
        (list isSequenceable) ifFalse:[
            ^ self warn:'first and third items are not Arrays'
        ].
    ].
    argMap := (1 to:data first size) asArray.
    data do:[:list | 
        list size = argMap size ifFalse:[
            self warn:'data arrays must all be the same size'
        ]
    ].
    argMap size > 4 ifTrue:[
        self warn:'No more than a receiver and 
three arguments allowed'
    ].
     "Really only test receiver and three args."
    thisData := data copy.
    mapStage := mapList := nil.
!

noteDangerous
        "Remember the methods with really bad side effects."

        Dangerous _ Set new.
"Object accessing, testing, copying, dependent access, macpal, flagging"
        #(addInstanceVarNamed:withValue: haltIfNil copyAddedStateFrom: veryDeepCopy veryDeepCopyWith: veryDeepFixupWith: veryDeepInner: addDependent: evaluate:wheneverChangeIn: codeStrippedOut: playSoundNamed: isThisEverCalled isThisEverCalled: logEntry logExecution logExit)
                do: [:sel | Dangerous add: sel].

"Object error handling"
        #(cannotInterpret: caseError confirm: confirm:orCancel: doesNotUnderstand: error: halt halt: notify: notify:at: primitiveFailed shouldNotImplement subclassResponsibility tryToDefineVariableAccess:)
                do: [:sel | Dangerous add: sel].

"Object user interface"
        #(basicInspect beep inform: inspect inspectWithLabel: notYetImplemented inspectElement )
                do: [:sel | Dangerous add: sel].

"Object system primitives"
        #(become: becomeForward: becomeSameAs: changeClassTo: instVarAt:put: instVarNamed:put: nextInstance nextObject rootStubInImageSegment: someObject tryPrimitive:withArgs:)
                do: [:sel | Dangerous add: sel].

"Object private"
        #(errorImproperStore errorNonIntegerIndex errorNotIndexable errorSubscriptBounds: mustBeBoolean primitiveError: species storeAt:inTempFrame:)
                do: [:sel | Dangerous add: sel].

"Object, translation support"
        #(cCode: cCode:inSmalltalk: cCoerce:to: export: inline: returnTypeC: sharedCodeNamed:inCase: var:declareC:)
                do: [:sel | Dangerous add: sel].

"Object, objects from disk, finalization.  And UndefinedObject"
        #(comeFullyUpOnReload: objectForDataStream: readDataFrom:size: rehash saveOnFile storeDataOn: actAsExecutor executor finalize retryWithGC:until:   suspend)
                do: [:sel | Dangerous add: sel].

"No Restrictions:   Boolean, False, True, "

"Morph"
        #(fullCopy copyRecordingIn:)
                do: [:sel | Dangerous add: sel].

"Behavior"
        #(obsolete confirmRemovalOf: copyOfMethodDictionary literalScannedAs:notifying: storeLiteral:on: addSubclass: removeSubclass: superclass: 
"creating method dictionary" addSelector:withMethod: compile: compile:notifying: compileAll compileAllFrom: compress decompile: defaultSelectorForMethod: methodDictionary: recompile:from: recompileChanges removeSelector: compressedSourceCodeAt: selectorAtMethod:setClass: allInstances allSubInstances inspectAllInstances inspectSubInstances thoroughWhichSelectorsReferTo:special:byte: "enumerating" allInstancesDo: allSubInstancesDo: allSubclassesDo: allSuperclassesDo: selectSubclasses: selectSuperclasses: subclassesDo: withAllSubclassesDo:
"user interface" allCallsOn: browse browseAllAccessesTo: browseAllCallsOn: browseAllStoresInto: "too slow->" crossReference removeUninstantiatedSubclassesSilently "too slow->" unreferencedInstanceVariables
"private" becomeCompact becomeUncompact flushCache format:variable:words:pointers: format:variable:words:pointers:weak: printSubclassesOn:level: removeSelectorSimply:)
                do: [:sel | Dangerous add: sel].

"Others "
        #("no tangible result" do: associationsDo:  
"private" adaptToCollection:andSend: adaptToNumber:andSend: adaptToPoint:andSend: adaptToString:andSend: instVarAt:put: asDigitsToPower:do: combinations:atATimeDo: doWithIndex: pairsDo: permutationsDo: reverseDo: reverseWith:do: with:do: withIndexDo: asDigitsAt:in:do: combinationsAt:in:after:do: errorOutOfBounds permutationsStartingAt:do: fromUser)
                do: [:sel | Dangerous add: sel].


        #(    fileOutPrototype addSpareFields makeFileOutFile )
                do: [:sel | Dangerous add: sel].
        #(recompile:from: recompileAllFrom: recompileChanges asPrototypeWithFields: asPrototype addInstanceVarNamed:withValue: addInstanceVariable addClassVarName: removeClassVarName: findOrAddClassVarName: tryToDefineVariableAccess: instanceVariableNames: )
                do: [:sel | Dangerous add: sel].
!

organizationFiltered: aClass
        "Return the organization of the class with all selectors defined in superclasses removed.  (except those in Object)"

        | org str |
        org _ aClass organization deepCopy.
        Dangerous do: [:sel |
                        org removeElement: sel].
        Approved do: [:sel |
                        org removeElement: sel].
        AddAndRemove do: [:sel |
                        org removeElement: sel].
        str _ org printString copyWithout: $(.
        str _ '(', (str copyWithout: $) ).
        str _ str replaceAll: $' with: $".
        ^ str
!

test2: anArray
        "look for bad association"

        anArray do: [:sub |
                sub class == Association ifTrue: [
                        (#('true' '$a' '2' 'false') includes: sub value printString) ifFalse: [
                                self error: 'bad assn'].
                        (#('3' '5.6' 'x' '''abcd''') includes: sub key printString) ifFalse: [
                                self error: 'bad assn'].

        "                       sub value class == Association ifTrue: [
                                        self error: 'bad assn'].
                                (sub value isKindOf: Class) ifTrue: [
                                        self error: 'class in assn'].
                                sub value class == Symbol ifTrue: [sub value codePoint = 204 '$' ifTrue: [
                                        self error: 'Write into char']].
                                sub value == $ ifTrue: [
                                        self error: 'Write into char']
        "].
                sub class == Array ifTrue: [
                        sub do: [:element | 
                                element isString ifTrue: [element first codePoint < 32 ifTrue: [
                                                self error: 'store into string in data']].
                                element class == Association ifTrue: [
                                        element value class == Association ifTrue: [
                                                self error: 'bad assn']]]].
                sub class == Date ifTrue: [sub year isInteger ifFalse: [
                                self error: 'stored into input date!!!!']].
                sub class == Dictionary ifTrue: [
                                sub size > 0 ifTrue: [
                                        self error: 'store into dictionary']].
                sub class == OrderedCollection ifTrue: [
                                sub size > 4 ifTrue: [
                                        self error: 'store into OC']].
                ].
!

test3
        "find the modification of the caracter table"

        (#x at: 1) codePoint = 120 ifFalse: [self error: 'Character table mod'].
! !

!MethodFinder methodsFor:'search'!

exceptions
        "Handle some very slippery selectors.
        asSymbol -- want to be able to produce it, but do not want to make every string submitted into a Symbol!!" 

        | aSel |
        answers first isSymbol ifFalse: [^ self].
        thisData first first isString ifFalse: [^ self].
        aSel := #asSymbol.   
        (self testPerfect: aSel) ifTrue: [
                selector add: aSel.
                expressions add: (String streamContents: [:strm | 
                        strm nextPutAll: 'data', argMap first printString.
                        aSel keywords doWithIndex: [:key :ind |
                                strm nextPutAll: ' ',key.
                                ((key last == $:) or:[ key first isLetter not ])
                                        ifTrue: [strm nextPutAll: ' data', 
                                                (argMap at: ind+1) printString]]])].
!

findMessage
        "Control the search."

        data do: [:alist |
                (alist isSequenceable) ifFalse: [
                        ^ OrderedCollection with: 'first and third items are not Arrays']].

        true "Approved isNil" ifTrue: [self initialize].      "Sets of allowed selectors"
        expressions := OrderedCollection new.
        self search: true.      "multi"
        expressions isEmpty ifTrue: [^ OrderedCollection with: 'no single method does that function'].
        expressions isString ifTrue: [^ OrderedCollection with: expressions].
        ^ expressions
!

insertConstants
        "see if one of several known expressions will do it. C is the constant we discover here."
        "C  data1+C  data1*C  data1//C  (data1*C1 + C2) (data1 = C) (data1 ~= C) (data1 <= C) (data1 >= C) 
 (data1 mod C)"

        thisData size >= 2 ifFalse: [^ self].   "need 2 examples"
        (thisData at: 1) size = 1 ifFalse: [^ self].    "only one arg, data1"

        self const ifTrue: [^ self].
"/        self constEquiv ifTrue: [^ self].       " ==  ~= "
        self constLessThan ifTrue: [^ self].    " <=  and  >= "

        self allNumbers ifFalse: [^ self].
        self constMod ifTrue: [^ self].
        self constPlus ifTrue: [^ self].
        self constMult ifTrue: [^ self].
        self constDiv ifTrue: [^ self].
        self constLinear ifTrue: [^ self].
!

search: multi
        "if Multi is true, collect all selectors that work."
        | old |
        selector:=OrderedCollection new.       "list of them"

      "  old _ Preferences autoAccessors.
        Preferences disableGently: #autoAccessors. "
        Smalltalk isSmalltalkX ifTrue:[old:=false].

        self simpleSearch.
        multi not & (selector isEmpty not) ifTrue:
                ["old ifTrue: [Preferences enableGently: #autoAccessors]."
                ^ selector]. 

        [self permuteArgs] whileTrue:
                [self simpleSearch.
               multi not & (selector isEmpty not) ifTrue:
                        ["old ifTrue: [Preferences enableGently: #autoAccessors]."
                        ^ selector]].

        self insertConstants.
      "  old ifTrue: [Preferences enableGently: #autoAccessors]. "

"/ (selector isEmpty not) ifTrue: [^ selector]].   " expression is the answer, not a selector"
        ^ #()
!

searchForOne
        "Look for and return just one answer"

        expressions _ OrderedCollection new.
        self search: false.     "non-multi"
        ^ expressions
                        
!

simpleSearch
        "Run through first arg's class' selectors, looking for one that works."

| class supers listOfLists |
self exceptions.
class:=thisData first first class.
"Cache the selectors for the receiver class"
(class == cachedClass and: [cachedArgNum = ((argMap size) - 1)]) 
        ifTrue: [listOfLists:=cachedSelectorLists]
        ifFalse: [supers:=class withAllSuperclasses.
                listOfLists:=OrderedCollection new.
                supers do: [:cls |    
                        listOfLists add: (cls selectorsWithArgs: (argMap size) - 1)].
                cachedClass:=class.
                cachedArgNum:=(argMap size) - 1.
                cachedSelectorLists:=listOfLists].
"/ self halt.
listOfLists do: [:selectorList |
        selectorList do: [:aSel |
                (selector includes: aSel) ifFalse: [
                        ((Approved includes: aSel) or: [AddAndRemove includes: aSel]) ifTrue: [
                                (self testPerfect: aSel) ifTrue: [
                                        selector add: aSel.
                                        expressions add: (String streamContents: [:strm | 
                                                strm nextPutAll: 'data', argMap first printString.
                                                aSel keywords doWithIndex: [:key :ind |
                                                        strm nextPutAll: ' ',key.
                                                        ((key last == $:) or:[ key first isLetter not])
                                                                ifTrue: [strm nextPutAll: ' data', 
                                                                        (argMap at: ind+1) printString]]])
                                        ]]]]].
!

testPerfect:aSelector 
    "Try this selector!! Return true if it answers every example perfectly.  
     Take the args in the order they are.  Do not permute them.
     Survive errors.  later cache arg lists."
    
    |sz argList val rec activeSel perform argIsBlock expectedAnswer|

    "Transcript cr; show: aSelector.                debug"
    perform := aSelector beginsWith:'perform:'.
    sz := argMap size.
    1 to:thisData size do:[:ii | 
        "each example set of args"
        argList := (thisData at:ii) copyFrom:2 to:sz.
        perform ifFalse:[
            activeSel := aSelector
        ] ifTrue:[
            activeSel := argList first.
            ((Approved includes:activeSel) or:[ AddAndRemove includes:activeSel ]) ifFalse:[
                ^ false
            ].
            aSelector == #perform:withArguments: ifTrue:[
                activeSel numArgs = (argList at:2) basicSize "avoid error" ifFalse:[
                    ^ false
                ]
            ] ifFalse:[
                activeSel numArgs = (aSelector numArgs - 1) ifFalse:[
                    ^ false
                ]
            ]
        ].
        1 to:sz do:[:num | 
            (Blocks includes:(Array with:activeSel with:num)) ifTrue:[
                Smalltalk isSmalltalkX ifTrue:[
                    argIsBlock := (argList at:num) isBlock
                ] ifFalse:[
                    argIsBlock := (argList at:num) class == BlockContext
                ].
                argIsBlock ifFalse:[
                    (BlocksOptional includes:(Array with:activeSel with:num)) ifFalse:[
                        ^ false
                    ]
                ]
            ]
        ].
         "   (activeSel = #capitalized) ifTrue:[self halt.].  " "  used to test  "
        rec := (AddAndRemove includes:activeSel) ifTrue:[
                (thisData at:ii) first class == Symbol ifTrue:[
                    ^ false
                ].
                 "vulnerable to modification"
                (thisData at:ii) first copyTwoLevel "protect from damage"
            ] ifFalse:[
                [
                    (thisData at:ii) first
                ] ifError:[ self halt. ]
            ].
        expectedAnswer := (answers at:ii).
        val := 
            [
                [
                    rec copy perform:aSelector withArguments:argList
                ] on:ObsoleteMethodCallWarning do:[^ false].    
            ] ifError:[:aSignal | 
                "/ Transcript showCR:aSignal description.
                "self test3."
                "self test2: (thisData at: ii)."
                ^ false
            ].
         "self test3." "self test2: (thisData at: ii)."
        (expectedAnswer isNumber) ifFalse:[
            expectedAnswer isArray ifTrue:[
                (val isCollection and:[ val isString not ]) ifTrue:[
                    ([
                        val asArray = expectedAnswer
                    ] ifError:[ false ]) ifTrue:[
                        ^ true
                    ].
                ].
            ].
            
            "/ would like to remember 'almost' same, and present in separate list.
"/            expectedAnswer isString ifTrue:[
"/                (val isString) ifTrue:[
"/                    ([val sameAs: expectedAnswer] ifError:[false]) ifTrue:[self halt. ^ true].
"/                ].
"/            ].
            
            ([
                (expectedAnswer = val)
            ] ifError:[ false ]) ifFalse:[
                ^ false
            ]
        ] ifTrue:[
            (expectedAnswer closeTo:val) ifFalse:[
                ^ false
            ]
        ].
    ].
    ^ true

    "Modified: / 13.11.2001 / 19:08:39 / cg"
! !

!MethodFinder methodsFor:'tests'!

verify
        "Test a bunch of examples"
        "       MethodFinder new verify    "
Approved isNil ifTrue: [self initialize].      "Sets of allowed selectors"
"/(MethodFinder new load: #( (0) 0  (30) 0.5  (45) 0.707106  (90) 1)
"/        ) searchForOne asArray = #('data1 degreeSin') ifFalse: [self error: 'should have found it'].  "Squeak test"
(MethodFinder new load:   (Array with:(Array with:true with:[3] with:[4]) with:3 with:(Array with:false with:[0] with:[6]) with:6)
        ) searchForOne asArray = #('data1 ifTrue: data2 ifFalse: data3') ifFalse: [
                self error: 'should have found it'].
(MethodFinder new load: #(#(1) true #(2) false #(5) true #(10) false)
        ) searchForOne asArray = #('data1 odd' 'data1 isPrime') ifFalse: [self error: 'should have found it'].
                "will correct the date type of #true, and complain"
Smalltalk isSmalltalkX ifTrue:[        
(MethodFinder new load: #((4 2) '2r100'   (255 16) '16rFF'    (14 8) '8r16')
        ) searchForOne asArray = 
                #('data1 radixPrintStringRadix: data2' )
                          ifFalse: [self error: 'should have found it'].        
] ifFalse:[
(MethodFinder new load: #((4 2) '2r100'   (255 16) '16rFF'    (14 8) '8r16')
        ) searchForOne asArray = 
                #('data1 radix: data2' 'data1 printStringBase: data2' 'data1 storeStringBase: data2')                             
                          ifFalse: [self error: 'should have found it'].        
].
"/(MethodFinder2 new load: #(#(3@4) 4 #(1@5) 5)
"/        ) searchForOne asArray = #('data1 y') ifFalse: [self error: 'should have found it'].    
Smalltalk isSmalltalkX ifTrue:[
(MethodFinder new load: #(('abcd') $a  ('TedK') $T)
        ) searchForOne asArray = #('data1 first' 'data1 removeFirst'  'data1 anyOne')   
                 ifFalse: [self error: 'should have found it']. 
] ifFalse:[
(MethodFinder new load: #(('abcd') $a  ('TedK') $T)
        ) searchForOne asArray = #('data1 asCharacter' 'data1 first' 'data1 anyOne')
                 ifFalse: [self error: 'should have found it']. 
].
(((MethodFinder new load: #(('abcd' 1) $a  ('Ted ' 3) $d )
        ) searchForOne asArray) includesAll: #('data1 at: data2' 'data1 atPin: data2' 'data1 atWrap: data2'))
                ifFalse: [self error: 'should have found it'].  
(MethodFinder new load: #(((12 4 8)) 24  ((1 3 6)) 10 )
        ) searchForOne asArray=  #('data1 sum') ifFalse: [self error: 'should have found it'].  
                "note extra () needed for an Array object as an argument"

(MethodFinder new load: #((14 3) 11  (-10 5) -15  (4 -3) 7)
        ) searchForOne asArray = #('data1 - data2') ifFalse: [self error: 'should have found it'].
((MethodFinder new load: #((4) 4  (-10) 10 (-3) 3 (2) 2 (-6) 6 (612) 612)
        ) searchForOne asArray includesAll: #('data1 abs')) ifFalse: [self error: 'should have found it'].
(MethodFinder new load: #(#(4 3) true #(-7 3) false #(5 1) true #(5 5) false)
        ) searchForOne asArray = #('data1 > data2') ifFalse: [self error: 'should have found it'].      
(MethodFinder new load: #((5) 0.2   (2) 0.5)
        ) searchForOne asArray = #('data1 reciprocal') ifFalse: [self error: 'should have found it'].   
(MethodFinder new load: #((12 4 8) 2  (1 3 6) 2  (5 2 16) 8)
        ) searchForOne asArray = #()     " '(data3 / data2) ' want to be able to leave out args"  
                ifFalse: [self error: 'should have found it'].  
(MethodFinder new load: #((0.0) 0.0  (1.5) 0.997495  (0.75) 0.681639)
        ) searchForOne asArray = #('data1 sin') ifFalse: [self error: 'should have found it'].  
(MethodFinder new load: #((7 5) 2   (4 5) 4   (-9 4) 3)
        ) searchForOne asArray = #('data1 \\ data2') ifFalse: [self error: 'should have found it'].     
! !

!MethodFinder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

