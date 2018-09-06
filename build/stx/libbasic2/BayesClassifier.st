"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

TextClassifier subclass:#BayesClassifier
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

!BayesClassifier class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    an initial experiment in bayes text classification.
    see BayesClassifierTest
    This is possibly unfinished and may need more work.

    [author:]
        cg
"
!

examples
"
    |b|

    b := BayesClassifier new.
    'teach it positive phrases'.
    b classify:'amazing, awesome movie!!!! Yeah!!!!' asCategory: 'positive'.
    b classify:'Sweet, this is incredibly, amazing, perfect, great!!!!' asCategory: 'positive'.

    'teach it a negative phrase'.
    b classify:'terrible, shitty thing. Damn. Sucks!!!!' asCategory: 'negative'.

    'teach it a neutral phrase'.
    b classify:'I dont really know what to make of this.' asCategory: 'neutral'.

    'now test it to see that it correctly categorizes a new document'.
    self assert:(b classify:'awesome, cool, amazing!!!! Yay.')= 'positive'.
"
! !

!BayesClassifier methodsFor:'text handling'!

classify:string
    "assume that it is a regular text.
     split first into lines..."

    |tokens frequencyTable maxProbability chosenCategory|

    maxProbability := Infinity negative.

    tokens := self tokenize:string.
    frequencyTable := tokens asBag.

    categories do:[:categoryName |
        |categoryProbability logProbability|

        categoryProbability := (docCounts at:categoryName) / docCounts size.
        logProbability := categoryProbability log.
        frequencyTable valuesAndCountsDo:[:token :frequencyInText |
            | tokenProbability|
            
            tokenProbability := self tokenProbabilityOf:token inCategory:categoryName.
            logProbability := logProbability + (frequencyInText * tokenProbability log).
        ].
        Transcript show:'P(',categoryName,') = '; showCR:logProbability.
        
        logProbability > maxProbability ifTrue:[
            maxProbability := logProbability.
            chosenCategory := categoryName.
        ].
    ].
    ^ chosenCategory
!

classify:string asCategory:categoryName
    |tokens frequencyTable sumWordCount|
    
    self initializeCategory:categoryName.
    docCounts incrementAt:categoryName.
    tokens := self tokenize:string.
    frequencyTable := tokens asBag.
    sumWordCount := 0.
    frequencyTable valuesAndCountsDo:[:token :count |
        vocabulary add:token.
        (wordFrequencyCounts at:categoryName) incrementAt:token by:count.
        sumWordCount := sumWordCount + count.
    ].
    wordCounts incrementAt:categoryName by:sumWordCount
!

tokenProbabilityOf:token inCategory:category
    "Calculate probability that a `token` belongs to a `category`"

    |wordFrequencyCount wordCount prob|

    wordFrequencyCount := (wordFrequencyCounts at:category) at:token ifAbsent:0.
    wordCount := wordCounts at:category.

    "/use laplace Add-1 Smoothing equation
    prob :=( wordFrequencyCount + 1 ) / ( wordCount + vocabulary size ).
    prob := prob asFloat.
    Transcript showCR:('  P(%1, %2) = %3' bindWith:token with:category with:prob).
    ^ prob
! !

!BayesClassifier class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

