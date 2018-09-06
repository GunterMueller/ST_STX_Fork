"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Stream subclass:#SelectingReadStream
	instanceVariableNames:'selectBlock hasReadAhead readAhead inStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!SelectingReadStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    A stream which only delivers elements for which a select block returns true
    from an underlying stream. 

    Needs readAhead for proper atEnd handling.

    [Author:]
        Claus Gittinger

    [instance variables:]
        hasReadAhead        - because nil is a valid read-element,
                            this is used to know if readAhead is valid.
"
!

examples
"
    |s|

    s := SelectingReadStream 
            on:#(1 2 3 4 5 6 7 8) readStream
            selecting:[:each | each even].
    s upToEnd  
"
! !

!SelectingReadStream class methodsFor:'instance creation'!

on:aStream selecting:aBlock
    ^ self basicNew on:aStream selecting:aBlock
! !

!SelectingReadStream methodsFor:'instance creation'!

on:aStream selecting:aBlock
    inStream := aStream.
    selectBlock := aBlock.
    hasReadAhead := false.
! !

!SelectingReadStream methodsFor:'queries'!

atEnd
    |el|

    hasReadAhead ifTrue:[^ false].

    [
        inStream atEnd ifTrue:[
            ^ true
        ].
        el := inStream next.
        (selectBlock value:el)
    ] whileFalse.
    readAhead := el.
    hasReadAhead := true.
    ^ false.
!

contentsSpecies
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    ^ inStream contentsSpecies.
! !

!SelectingReadStream methodsFor:'reading'!

next
    |el|
    
    hasReadAhead ifTrue:[
        hasReadAhead := false.
        ^ readAhead
    ].
    [
        inStream atEnd ifTrue:[
            ^ self pastEndRead
        ].
        el := inStream next.
        (selectBlock value:el)
    ] whileFalse.
    ^ el
! !

!SelectingReadStream class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/SelectingReadStream.st,v 1.5 2014-04-30 18:20:55 cg Exp $'
! !

