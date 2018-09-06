"{ Package: 'stx:libbasic' }"

WriteStream subclass:#TextCollectorStream
	instanceVariableNames:'access lineLimit partialLastLine'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!TextCollectorStream class methodsFor:'documentation'!

documentation
"
    a textCollectorStream is much like a regular writeStream.
    In addition to collecting characters, it does a delayed update
    of its collection, and may be used as a model for a TextView to
    work like a TextCollector.

    Currently ListViews are optimezed for StringCollections as model.
    So stream on a StringCollection for best performance.

    [author:]
        Stefan Vogel

    [see also:]
        WriteStream
        TextCollector StringCollection

"
!

examples
"
                                        [exBegin]
    |s|
    s := TextCollectorStream on:StringCollection new.
    s show:'Hello '.
    s showCR:'World'.
    s contents inspect
                                        [exEnd]
"
!

history
    "Created: 18.2.1997 / 13:18:17 / stefan"
! !

!TextCollectorStream class methodsFor:'defaults'!

defaultLineLimit
    "the number of lines remembered by default"

    ^ 600

    "Created: 18.2.1997 / 14:41:38 / stefan"
! !

!TextCollectorStream methodsFor:'accessing'!

access
    "return the value of the instance variable 'access' (automatically generated)"

    ^ access

    "Created: 19.2.1997 / 09:01:21 / stefan"
!

access:something
    "set the value of the instance variable 'access' (automatically generated)"

    access := something.

    "Created: 19.2.1997 / 09:01:21 / stefan"
!

lineLimit
    "return the value of the instance variable 'lineLimit' (automatically generated)"

    ^ lineLimit

    "Created: 19.2.1997 / 09:01:21 / stefan"
!

lineLimit:something
    "set the value of the instance variable 'lineLimit' (automatically generated)"

    lineLimit := something.

    "Created: 19.2.1997 / 09:01:21 / stefan"
! !

!TextCollectorStream methodsFor:'initialization'!

initialize
    super initialize.

"/    access := RecursionLock new.
    lineLimit := self class defaultLineLimit.

    "first line is empty"    
    partialLastLine := false.

    "Created: 18.2.1997 / 14:39:50 / stefan"
    "Modified: 19.2.1997 / 11:59:01 / stefan"
!

on:aCollection
    self initialize.
    ^ super on:aCollection.

    "Created: 19.2.1997 / 08:59:45 / stefan"
!

on:aCollection from:start to:end
    self initialize.
    ^ super on:aCollection from:start to:end.

    "Created: 19.2.1997 / 09:00:07 / stefan"
!

with:aCollection
    self initialize.
    ^ super with:aCollection.

    "Created: 19.2.1997 / 09:00:24 / stefan"
! !

!TextCollectorStream methodsFor:'writing'!

nextPut:anObject
    "an Object may be a Character (cr or nl), or anything 
     responding to #printString."

    |string newPartialLastLine size|

    (writeLimit notNil
     and:[position >= writeLimit]) ifTrue:[
        WriteError raiseErrorString:'write beyond writeLimit'
    ].

    anObject isCharacter ifTrue:[       
        ((anObject == Character cr) or:[anObject == Character nl]) ifTrue:[
            partialLastLine ifFalse:[
                collection add:''.      "add empty line"
                position := position + 1.
            ].
            partialLastLine := false.
            ^ anObject.
        ].
    ].
        
    string := anObject printString.
    (string includes:Character cr) ifTrue:[
        newPartialLastLine := (string last ~= Character cr).
        string := string asStringCollection.
        partialLastLine ifTrue:[
            string at:1 put:((collection removeLast ? ''), (string at:1)).
        ].
        size := collection size + string size.
        size > lineLimit ifTrue:[
            collection removeFirst:(size - lineLimit min:(collection size)).
            position := lineLimit.
        ].
        collection addAll:string.
        position := position + string size.
        partialLastLine := newPartialLastLine.
    ] ifFalse:[
        partialLastLine ifTrue:[
            collection add:((collection removeLast ? ''), string).
        ] ifFalse:[
            collection add:string.
            position := position + 1.
        ].
        partialLastLine := true.
    ].

    ^ anObject

    "Created: 18.2.1997 / 14:29:51 / stefan"
    "Modified: 19.2.1997 / 11:47:37 / stefan"
!

show:anObject
    self nextPut:anObject

    "Created: 18.2.1997 / 17:20:53 / stefan"
!

showCR:anObject
    self nextPut:anObject; nextPut:Character cr

    "Created: 18.2.1997 / 17:21:12 / stefan"
! !

!TextCollectorStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/TextCollectorStream.st,v 1.2 2006/04/06 10:54:06 stefan Exp $'
! !



