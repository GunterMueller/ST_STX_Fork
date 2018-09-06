"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Dictionary subclass:#CacheDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!CacheDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a CacheDictionary is a Dictionary which will not grow beyond a given max. size
    - i.e. keep only a limited number of elements.
    It can be used as a cache, for keeping recently used objects alive.
    Must be created with an initial (=maximal) size. 
    I.e. (CacheDictionary new:100)

    [see also:]
        Dictionary
        OrderedCollection
        OrderedDictionary
        
    [author:]
        Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    |d|

    d := CacheDictionary new:16.
    1 to:20 do:[:i |
        d at:i printString put:i.
    ].
    21 to:40 do:[:i |
        d at:i printString put:i.
    ].
    d inspect
                                                                        [exEnd]
"
! !

!CacheDictionary methodsFor:'private'!

findKeyOrNil:key  
    "Look for the key in the receiver.  If it is found, return
     the index of the association containing the key, otherwise
     return the index of the first unused slot. If no empty slot
     is available, make one empty (but never grow)."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        key = probe ifTrue:[^ index].
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].

            keyArray basicAt:delIndex put:nil.
            valueArray basicAt:delIndex put:nil.
            ^ delIndex
        ].

        (delIndex == 0 and:[probe == DeletedEntry]) ifTrue:[
            delIndex := index
        ].

        index := index + 1.
        index > length ifTrue:[
            index := 1.
        ].
        index == startIndex ifTrue:[
            "/ mhmh - actually, a kind of round-robin would be better
            delIndex == 0 ifTrue:[
                delIndex := startIndex
            ].

            keyArray basicAt:delIndex put:nil.
            valueArray basicAt:delIndex put:nil.
            tally := tally - 1.
            ^ delIndex
        ].
    ] loop.

    "Modified: / 01-03-1997 / 00:59:55 / cg"
    "Modified (format): / 26-12-2011 / 10:42:08 / cg"
!

findKeyOrNilOrDeletedEntry:key  
    "Look for the key in the receiver.  If it is found, return
     the index of the association containing the key, otherwise
     return the index of the first unused slot. If no empty slot
     is available, make one empty (but never grow)."

    |index  "{ Class:SmallInteger }"
     length "{ Class:SmallInteger }"
     startIndex probe
     delIndex "{ Class:SmallInteger }"|

    delIndex := 0.

    length := keyArray basicSize.
    startIndex := index := self initialIndexForKey:key.

    [
        probe := keyArray basicAt:index.
        key = probe ifTrue:[^ index].
        probe isNil ifTrue:[
            delIndex == 0 ifTrue:[^ index].

            valueArray basicAt:delIndex put:nil.
            ^ delIndex
        ].

        (delIndex == 0 and:[probe == DeletedEntry]) ifTrue:[
            delIndex := index
        ].

        index := index + 1.
        index > length ifTrue:[
            index := 1.
        ].
        index == startIndex ifTrue:[
            "/ mhmh - actually, a kind of round-robin would be better
            delIndex == 0 ifTrue:[
                delIndex := startIndex
            ].

            valueArray basicAt:delIndex put:DeletedEntry.
            valueArray basicAt:delIndex put:nil.
            tally := tally - 1.
            ^ delIndex
        ].
    ] loop.

    "Modified: / 01-03-1997 / 00:59:55 / cg"
    "Modified (format): / 26-12-2011 / 10:42:08 / cg"
!

possiblyGrow
    "redefined - never grow"

    ^ self

    "Modified: 30.1.1997 / 15:17:18 / cg"
!

possiblyShrink
    "redefined - never shrink"

    ^ self

    "Modified: 30.1.1997 / 15:17:12 / cg"
! !

!CacheDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

