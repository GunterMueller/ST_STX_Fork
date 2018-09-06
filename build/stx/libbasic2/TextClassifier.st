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

Object subclass:#TextClassifier
	instanceVariableNames:'wordBag sentences docCounts wordCounts wordFrequencyCounts
		categories vocabulary'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

!TextClassifier class methodsFor:'documentation'!

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
    an initial experiment in text classification.
    see BayesClassifierTest
    
    [author:]
        cg
"
! !

!TextClassifier class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!TextClassifier methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    wordBag := Bag new.
    "/ sentences := nil.
    docCounts := Dictionary new.
    wordCounts := Dictionary new.
    wordFrequencyCounts := Dictionary new.
    categories := Set new.
    vocabulary := Set new.

    "/ super initialize.   -- commented since inherited method does nothing
!

initializeCategory:categoryName
    (categories includes:categoryName) ifFalse:[
        docCounts at:categoryName put:0.
        wordCounts at:categoryName put:0.
        wordFrequencyCounts at:categoryName put:(Dictionary new).
        categories add:categoryName
    ].
! !

!TextClassifier methodsFor:'text handling'!

collectWords:lines
    "computes words from lines"

    |words|

    words := lines collectAll:[:l | 
                l asCollectionOfSubCollectionsSeparatedByAnyForWhich:[:ch | ch isLetterOrDigit not]
             ].
    ^ words
!

dehyphenate:linesCollection
    "join hypens"

    |lines partialLine|

    lines := OrderedCollection new.
    linesCollection do:[:eachLine |
        |l isHyphenated|
        
        l := eachLine withoutSeparators.
        l notEmptyOrNil ifTrue:[
            isHyphenated := (l endsWith:'-')
                            and:[ l size > 1 
                            and:[ (l at:(l size-1)) isLetter ]].
            isHyphenated ifFalse:[
                partialLine := (partialLine ? '') , l.
                lines add:partialLine.
                partialLine := nil.
            ] ifTrue:[
                l := l copyButLast.
                partialLine := (partialLine ? '') , l.
            ].    
        ].
    ].
    partialLine notEmptyOrNil ifTrue:[
        lines add:partialLine
    ].
    ^ lines
!

tokenize:string
    |rawLines lines allWords|

    rawLines := string asCollectionOfLines.
    lines := self dehyphenate:rawLines.
    allWords := self collectWords:lines.
    ^ allWords
! !

!TextClassifier class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

