"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#KeywordInContextIndexBuilder
	instanceVariableNames:'keywordToLinesMapping excluded separatorAlgorithm
		unquoteAlgorithm exclusionFilter matchSorter'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!KeywordInContextIndexBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    A support class for building KWIC (Keyword in Context) or KWOC (Keyword out of Context) indexes.
    (for example, to build such indexes on html pages or class documentation).
    
    To generate a kwic, add each line together with a reference (or page number, or whatever),
    using addLine:reference:.
    Then, when finished, enumerate the kwic and print as kwic or kwoc.
    
    To ignore fill words (such as 'and', 'the', 'in', etc.), 
    define those with the #excluded: messages.

    The keyword handling is configurable by providing actions/lists for:
        separatorAlgorithm      a block which separates lines into individual words
                                gets a line; delivers a collection of words

        excluded                a collection of words which are to be ignored

        unquoteAlgorithm        a block to remove quotes around words. 
                                gets word as argument, delivers unquoted word

        keywordMappingAlgorithm 
                                maps keywords; for example, can be used to map 'startsWith'
                                to 'start', so they appear in the same section.
                                Gets the word and the set-of-all-words as arguments,
                                delivers the key into which the word's entries should be placed  
                                
        matchSorter             determines the order in which keywords are listed
        
    [author:]
        Claus Gittinger (cg@alan)

    [examples:]
        see examples method

    [see also:]
        https://en.wikipedia.org/wiki/Key_Word_in_Context (english)
        https://de.wikipedia.org/wiki/Permutiertes_Register (german)
        
"
!

examples
"
    building a kwic; print as kwic and kwoc
                                                                [exBegin]
    |kwic|

    kwic := KeywordInContextIndexBuilder new.
    kwic excluded:#('the' 'and' 'a' 'an' 'in').

    kwic addLine:'bla bla bla' reference:1.
    kwic addLine:'foo, bar. baz' reference:2.
    kwic addLine:'one two three' reference:3.
    kwic addLine:'a cat and a dog' reference:4.
    kwic addLine:'the man in the middle' reference:5.
    kwic addLine:'the man with the dog' reference:6.

    Transcript showCR:'Printed as KWIC:'.
    kwic 
        entriesDo:[:word :left :right :ref |
            Transcript 
                show:((left contractTo:20) leftPaddedTo:20);
                space;
                show:((word contractTo:10) leftPaddedTo:10) allBold;
                space;
                show:((right contractTo:20) leftPaddedTo:20);
                space;
                show:'['; show:ref; show:']';
                cr    
        ].

    Transcript cr.
    Transcript showCR:'Printed as KWOC:'.
    kwic 
        entriesDo:[:word :left :right :ref :fullText :context |
            Transcript 
                show:((word contractTo:10) paddedTo:10) allBold;
                space;
                show:((context contractTo:60) paddedTo:60);
                space;
                show:'['; show:ref; show:']';
                cr    
        ].
                                                                [exEnd]


  KWIC index over method selector components; build a little browser window:
                                                                [exBegin]
    |kwic v s c list refs|

    kwic := KeywordInContextIndexBuilder new.
    Smalltalk allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            kwic addLine:sel reference:mthd.
        ]
    ].

    v := StandardSystemView new.
    v addComponent:(s := HVScrollableView for:SelectionInListView).
    s origin:0.0@0.0 corner:1.0@0.5.
    v addComponent:(c := HVScrollableView for:CodeView).
    c origin:0.0@0.5 corner:1.0@1.0.

    refs := OrderedCollection new.
    list := OrderedCollection new.
    kwic 
        entriesDo:[:word :left :right :ref |
            list add:(word,' ',left,' ',word allBold,' ',right,' (',ref mclass name,')').
            refs add:ref].
    s list:list.
    s action:[:lNr | c contents:(refs at:lNr) source].
    v open.
                                                                [exEnd]

  KWIC index over method selector components, with word separation:
                                                                [exBegin]
    |kwic|

    kwic := KeywordInContextIndexBuilder forMethodSelectorIndex.

    Smalltalk allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            kwic addLine:sel reference:mthd.
        ]
    ].
    kwic
                                                                [exEnd]

  KWIC index over method comments:
                                                                [exBegin]
    |kwic v s c refs list|

    kwic := KeywordInContextIndexBuilder forMethodComments.

    Smalltalk allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            |comment|

            (sel == #documentation) ifTrue:[
                comment := mthd comment.
                comment notNil ifTrue:[
                    kwic addLine:comment reference:mthd mclass ignoreCase:true.
                ]
            ] ifFalse:[
                (sel ~~ #examples
                and:[ sel ~~ #copyright
                and:[ sel ~~ #version]]) ifTrue:[
                    comment := mthd comment.
                    comment notNil ifTrue:[
                        kwic addLine:comment reference:mthd ignoreCase:true.
                    ]
                ]
            ]
        ]
    ].
    kwic.
                                                                [exEnd]

  KWIC index over class comments:
                                                                [exBegin]
    |kwic|

    kwic := KeywordInContextIndexBuilder forMethodComments.

    Smalltalk allClassesDo:[:eachClass |
        |mthd comment|

        mthd := eachClass theMetaclass compiledMethodAt:#documentation.
        mthd notNil ifTrue:[
            comment := mthd comment.
            comment notNil ifTrue:[
                kwic addLine:comment reference:eachClass theNonMetaclass ignoreCase:true.
            ]
        ]
    ].
    kwic
                                                                [exEnd]
"
! !

!KeywordInContextIndexBuilder class methodsFor:'instance creation'!

forMethodComments
    "return an indexer for method comments"

    |sepChars sep kwic|

    sepChars := '.,;:_ !![]()''"#?<>|' , Character return, Character lf, Character tab.

    sep := [:lines | lines asString asCollectionOfSubstringsSeparatedByAny:sepChars].

    kwic := self new.
    kwic separatorAlgorithm:sep.
    kwic excluded:#('the' 'and' 'a' 'an' 'for' 'with' 'no').
    ^ kwic
!

forMethodSelectorIndex
    "return an indexer for method selector components, with word separation at case boundaries"

    |sep kwic sepUCWords|

    sepUCWords := [:word :keyWords| 
                    |s w c lastC last2C frag|

                    word asLowercase = word ifTrue:[
                        keyWords add:word.
                    ] ifFalse:[
                        s := word readStream.
                        w := '' writeStream.
                        [s atEnd] whileFalse:[
                            c := s next.
                            (c isUppercase) ifTrue:[
                                (lastC notNil and:[lastC isUppercase not]) ifTrue:[
                                    keyWords add:w contents.
                                    w := '' writeStream.
                                ].
                            ] ifFalse:[
                                (last2C notNil and:[last2C isUppercase and:[lastC isUppercase]]) ifTrue:[
                                    c isLetter ifTrue:[
                                        frag := w contents.
                                        w := '' writeStream.
                                        w nextPut:(frag last).
                                        keyWords add:(frag allButLast).
                                    ] ifFalse:[
                                       "/ frag := w contents.
                                       "/ w := '' writeStream.
                                       "/ keyWords add:frag.
                                    ].
                                ].
                            ].
                            w nextPut:c.
                            last2C := lastC.
                            lastC := c.
                        ].
                    ].
                  ].

    sep := [:line | 
                |words keyWords|

                words := line asCollectionOfSubstringsSeparatedByAny:'.,;:_ '.
                keyWords := OrderedCollection new.
                words do:[:eachWord | sepUCWords value:eachWord value:keyWords].
                keyWords
            ].

    kwic := self new.
    kwic separatorAlgorithm:sep.
    ^ kwic
!

new
    ^ self basicNew initialize
! !

!KeywordInContextIndexBuilder methodsFor:'accessing'!

excluded:aListOfExcludedWords
    "define words which are to be ignored.
     Typically, this is a list of fillwords, such as 'and', 'the', 'in', etc."
     
    excluded := aListOfExcludedWords asSet.
!

exclusionFilter:aBlock
    "define an additional filter to exclude more complicated patterns.
     This is invoked after filtering by the exclusion list.
     If defined, this should return true,if the word is to be excluded."
     
    exclusionFilter := aBlock.
!

matchSorter:aSortBlock
    "if set, matches will be enumerated in that sort order."
    
    matchSorter := aSortBlock.
!

separatorAlgorithm:aBlock
    "define the algorithm to split a given string into words.
     The default is to split at punctuation and whitespace
     (see #initialize)"
     
    separatorAlgorithm := aBlock.
!

unquoteAlgorithm:aBlock
    "define the algorithm to unquote words.
     The default is to unquote single and double quotes
     (see #initialize)"
     
    unquoteAlgorithm := aBlock.
! !

!KeywordInContextIndexBuilder methodsFor:'building'!

addLine:aLine reference:opaqueReference
    "add a text line; the line is split at words and entered into the kwic.
     The reference argument is stored as 'value' of the generated entries.
     It can be anything"

    self addLine:aLine reference:opaqueReference ignoreCase:true
!

addLine:aLine reference:opaqueReference ignoreCase:ignoreCase
    "add a line to the kwic.
     The line is split up into words, and a reference to opaqueReference
     is added for each word.
     The reference argument is stored as 'value' of the generated entries;
     it can be anything"
     
    (separatorAlgorithm value:aLine optionalArgument:keywordToLinesMapping) do:[:eachWord |
        |set word|

        (excluded includes:eachWord) ifFalse:[
            word := unquoteAlgorithm value:eachWord.
            ignoreCase ifTrue:[
                word := word asLowercase.
            ].
            (excluded includes:word) ifFalse:[
                (exclusionFilter isNil or:[ (exclusionFilter value:word) not]) ifTrue:[
                    set := keywordToLinesMapping at:word ifAbsentPut:[Set new].
                    set add:(aLine -> opaqueReference).
                ]
            ]
        ]
    ].
!

remapKeywordsWith:keywordMappingAlgorithm 
    "allows for an additional mapper to be applied (after the kwic has been constructed).
     This can map multiple different words to the same keword.
     It is given the word and the set of already known words as argument.
     It may, for example figure out that a word with a long prefix is already in the
     list and decide, that a new word should be brought into the same bucket.
     For example, if 'starts' is already in the list, and 'startWith' is encountered."

    |knownKeys|
    
    knownKeys := keywordToLinesMapping keys copy.
    knownKeys do:[:kw |
        |mappedWord oldSet newSet|

        mappedWord := keywordMappingAlgorithm value:kw optionalArgument:knownKeys.
        mappedWord ~= kw ifTrue:[
            oldSet := keywordToLinesMapping at:kw ifAbsent:[nil].
            oldSet notNil ifTrue:[
                newSet := keywordToLinesMapping at:mappedWord ifAbsentPut:[Set new].
                oldSet do:[:eachEntry |
                    newSet add:eachEntry.
                ].
                keywordToLinesMapping removeKey:kw.
            ]    
        ]    
    ].
! !

!KeywordInContextIndexBuilder methodsFor:'enumerating'!

entriesDo:aFourToSixArgBlock
    "evaluate the argument, for each entry.
     If it is a 4-arg block, it is called with:
        kwic-word, 
        left-text, 
        right text 
        and reference
     If it is a 5-arg block, the original text is passed as additional argument.
     If it is a 6-arg block, the original text and the context are passed as additional argument.
     (stupid, but done for backward compatibility)"

    |fourArgBlock|

    aFourToSixArgBlock numArgs == 4 ifTrue:[
        fourArgBlock := aFourToSixArgBlock 
    ].    
    keywordToLinesMapping keys asSortedCollection do:[:eachKey |
        |setOfMatches lcKey|

        setOfMatches := keywordToLinesMapping at:eachKey.
        matchSorter notNil ifTrue:[
            setOfMatches := setOfMatches asSortedCollection:matchSorter
        ].    
        lcKey := eachKey asLowercase.
        setOfMatches do:[:eachAssoc |
            |text ref lines idx lIdx context left right word prevLine nextLine|

            text := eachAssoc key.
            ref := eachAssoc value.

            lines := text asCollectionOfLines.
            idx := lines findFirst:[:line | line asLowercase includesString:lcKey].
            idx ~~ 0 ifTrue:[
                context := lines at:idx.
                idx > 1 ifTrue:[
                    prevLine := (lines at:idx-1).
                    context := prevLine , ' ' , context.
                ].
                idx < lines size ifTrue:[
                    nextLine := (lines at:idx+1).
                    context :=  context , ' ' , nextLine.
                ].
                lIdx := context asLowercase findString:lcKey.
                left := (context copyTo:lIdx - 1) withoutSeparators.
                right := (context copyFrom:lIdx + lcKey size) withoutSeparators.
                word := (context copyFrom:lIdx to:lIdx + lcKey size - 1) withoutSeparators.
                fourArgBlock notNil ifTrue:[
                    fourArgBlock value:word value:left value:right value:ref.
                ] ifFalse:[
                    aFourToSixArgBlock value:word optionalArgument:left and:right and:ref and:text and:context
                ].    
            ].
        ]
    ]
! !

!KeywordInContextIndexBuilder methodsFor:'initialization'!

initialize
    keywordToLinesMapping := Dictionary new.
    self excluded:(Set new).
    self exclusionFilter:nil.
    self separatorAlgorithm:[:line | line asCollectionOfSubstringsSeparatedByAny:' .:,;-'].
    self unquoteAlgorithm:[:word | (word unquote:$") unquote:$' ].
! !

!KeywordInContextIndexBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

