"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#SAXLocator
	instanceVariableNames:'lineNumbers sourceStream'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-SAX'
!

SAXLocator comment:'Author: Roger Whitney whitney@cs.sdsu.edu
Version: 1.0  
Date: 4/2/2000
License: Camp Smalltalk 

OXSAXLocator is used in VWXMLSAXDriver and its subclasses to determine the parser''s position in an XML doucument.

Instance Variables:
	lineNumbers     <SequenceableCollection>        Index of the start of a new line in an Smalltalk string.
	sourceStream    <EndodedStream>  Stream on the input source

'
!


!SAXLocator class methodsFor:'instance creation'!

on: aStream
	^super new initializeOnStream: aStream
! !

!SAXLocator methodsFor:'accessing'!

columnNumber
        "Return the column number of current position of the inputStream.
        This should be the column number of the where the current document event ends"

        | rawLocation |
        lineNumbers isNil ifTrue:[self computeLineNumbers].
        rawLocation := sourceStream position.

        rawLocation <= lineNumbers first ifTrue:[^rawLocation].

        lineNumbers keysAndValuesDo:
                [:key :value | rawLocation <= value ifTrue:
                        [^rawLocation  - (lineNumbers at: key - 1)]].
        ^rawLocation - lineNumbers last
!

lineNumber
        "Return the row number of current position of the inputStream.
        This should be the row number of the where the current document event ends"

        | rawLocation |
        lineNumbers isNil ifTrue: [self computeLineNumbers].
        rawLocation := sourceStream position.

        lineNumbers 
                keysAndValuesDo: [:key :value | rawLocation <= value ifTrue: [^key ]].
        ^lineNumbers size
! !

!SAXLocator methodsFor:'initialization'!

computeLineNumbers
        | source cr |
        lineNumbers := OrderedCollection new.
        cr := Character cr.
        source := ReadStream on: sourceStream contents.
        [source atEnd] whileFalse: 
                        [(source skipThrough: cr) notNil ifTrue: [lineNumbers add: source position]]
!

initializeOnStream: aStream
	sourceStream := aStream.
! !

!SAXLocator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SAXLocator.st,v 1.6 2013-08-10 11:09:31 stefan Exp $'
! !

