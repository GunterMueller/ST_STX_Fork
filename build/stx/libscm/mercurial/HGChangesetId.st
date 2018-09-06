"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

ByteArray variableByteSubclass:#HGChangesetId
	instanceVariableNames:'revno'
	classVariableNames:'NullId'
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGChangesetId class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    Represent a changeset id in Mercurial repository.

    !!!!!! WARNING !!!!!!

    Due to a stupid design here, DO NOT USE put it into hashed collections!!
    I have to change it later...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGChangesetId class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray
    anArray size == 2 ifTrue:[
        "/ HGChangesetId 'hash-string'
        ^ self readFrom:(anArray at:2).
    ].

    ^ super decodeFromLiteralArray:anArray

    "
    #(HGChangesetId 'f6f68d32de73') decodeAsLiteralArray literalArrayEncoding
    "

    "Created: / 07-09-2015 / 17:43:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromBytes: aByteArrayOrString

    | sz |

    sz := aByteArrayOrString size.
    (sz ~~ 20 and:[sz ~~ 6]) ifTrue:[
        self error:'Node ID has either 20 or 6 bytes (short form)'.
        ^nil.
    ].
    ^(self new: sz) replaceBytesFrom: 1 to: sz with: aByteArrayOrString startingAt: 1

    "Created: / 25-09-2012 / 21:00:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 16:47:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromString: aString
    ^self readFrom: aString readStream

    "Created: / 10-09-2012 / 10:49:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 16:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^self new: 20

    "Created: / 10-09-2012 / 10:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-10-2012 / 15:51:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    (size ~~ 0 and:[size ~~ 20 and:[size ~~ 6]]) ifTrue:[
        self error: 'Size of HGNodeId must be either 20 bytes or 6 bytes (short form) or 0 (revno only)'.
        ^nil.
    ].
    ^super new: size

    "Created: / 10-09-2012 / 10:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 21:24:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom: aStringOrStream 
    ^self readFrom: aStringOrStream onError:[:msg|self error:msg].

    "Created: / 13-11-2012 / 16:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom: aStringOrStream onError: aBlock
    "Parses node id from stream and returns it. Support both,
     short and full node ids"

    | stream c c1 c2 sign revno hash hashPos charPos short |

    hash := ByteArray new: 20.
    hashPos := 1.
    charPos := 0.
    short := true.
    revno := 0.

    stream := aStringOrStream readStream.
    stream peek == $- ifTrue:[        
        stream next.
        sign := -1.
    ] ifFalse:[
        sign := 1.
    ].

    "/ Read revno...

    [ stream atEnd not and:[(c := stream peek) isDigit] ] whileTrue:[
        "/ Update revno
        revno := (revno * 10) + c digitValue.
        "/ Update hash for case we're reading hash instead..."
        c1 isNil ifTrue:[
            c1 := c.
        ] ifFalse:[
            c2 := c.
            hash at:hashPos put: (c1 digitValue << 4) | c2 digitValue.
            hashPos := hashPos + 1.
            c1 := c2 := nil.
        ].
        stream next.
        charPos := charPos + 1.
    ].
    revno := revno * sign.
    stream atEnd ifTrue:[
        "/ We might have read revno or a short hash that by chance
        "/ consist of only digits and not leading with 0. In this case
        "/ we actually cannot distinguish. 
        "/ In case we have read less than 12 characters (size of a short id), 
        "/ treat it as revno. A conservative guess...
        charPos < 12 ifTrue:[ 
            ^(HGChangesetId new: 0)
                revno: revno;
                yourself
        ]
    ].
    (stream atEnd not and:[stream peek isSeparator]) ifTrue:[
        ^(HGChangesetId new: 0)
            revno: revno;
            yourself
    ].
    stream peek == $: ifTrue:[
        "/OK. we have read revno"
        hashPos := 1.
        c1 := c2 := nil.
        stream next. "/eat :
    ] ifFalse:[
        revno := nil.
    ].
    "/ Read hash
    hashPos <= 6 ifTrue:[
        hashPos to: 6 do:[:i|
            stream atEnd ifTrue:[
                ^ aBlock valueWithOptionalArgument:'Unexpected end of stream, hex digit expected'.
            ].
            c1 isNil ifTrue:[
                c1 := stream peek.
                c1 isHexDigit ifFalse:[
                    ^ aBlock valueWithOptionalArgument:'Hex digit ([0-9a-z]) expected but ', c1 , ' found'.
                ].
                stream next.
            ].
            stream atEnd ifTrue:[
                ^ aBlock valueWithOptionalArgument:'Unexpected end of stream, hex digit expected'.
            ].
            c2 := stream peek.
            c2 isHexDigit ifFalse:[
                ^ aBlock valueWithOptionalArgument:'Hex digit ([0-9a-z]) expected but ', c2 , ' found'.
            ].
            hash at:i put: (c1 digitValue << 4) | c2 digitValue.
            hashPos := i + 1.
            c1 := c2 := nil.
            stream next.
        ].
    ].
    (stream atEnd not and:[stream peek isHexDigit]) ifTrue:[
        "/OK, full 40-char node id
        short := false.
        hashPos to: 20 do:[:i|
            stream atEnd ifTrue:[
                ^ aBlock valueWithOptionalArgument:'Unexpected end of stream, hex digit expected'.
            ].
                        c1 := stream peek.
            c1 isHexDigit ifFalse:[
                ^ aBlock valueWithOptionalArgument:'Hex digit ([0-9a-z]) expected but ', c1 , ' found'.
            ].
            stream next.
            stream atEnd ifTrue:[
                ^ aBlock valueWithOptionalArgument:'Unexpected end of stream, hex digit expected'.
            ].
            c2 := stream peek.
            c2 isHexDigit ifFalse:[
                ^ aBlock valueWithOptionalArgument:'Hex digit ([0-9a-z]) expected but ', c2 , ' found'.
            ].
            hash at:i put: (c1 digitValue << 4) + c2 digitValue.
            stream next.
        ].
    ].
    (revno == -1) ifTrue:[
        (hash = #[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 
            or:[hash = #[0 0 0 0 0 0]]) ifTrue:[
            ^self null
        ].
    ].
    short ifTrue:[
        ^(HGChangesetId new: 6)
            revno: revno;
            replaceBytesFrom: 1 to: 6 with: hash startingAt: 1;
            yourself
    ] ifFalse:[
        ^(HGChangesetId fromBytes: hash) revno: revno.
    ]

    "
    HGChangesetId fromString:'4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7'
    HGChangesetId readFrom: '96DB65258808720D8D5EA6CB7A6A4D4F4E467325''!!' readStream

    Bad ones:

    HGChangesetId fromString:'4:6f88e1f44d9eb86e0b56ca15e30e5d786acd' 
    HGChangesetId fromString:'4:6f88Z1f44d9eb86e0b56ca15e30e5d786acd83c7' 

    "

    "Created: / 13-11-2012 / 16:49:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-08-2018 / 10:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId class methodsFor:'accessing'!

null
    NullId isNil ifTrue:[
        NullId := self new.
        NullId revno: -1
    ].
    ^NullId

    "
        HGChangesetId null
    "

    "Created: / 19-10-2012 / 15:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 30-11-2012 / 22:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId methodsFor:'accessing'!

revno
    ^ revno

    "Created: / 13-11-2012 / 09:52:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 22:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revno:anInteger
    revno := anInteger.
! !

!HGChangesetId methodsFor:'comparing'!

= anotherId

    self class == anotherId class ifFalse:[ ^ false].
    (self size == 0 or:[anotherId size == 0]) ifTrue:[
        ^(self revno == anotherId revno and:[ self revno ~~ -2 ])
    ].
    self size == anotherId size ifTrue:[
        ^super = anotherId
    ].
    "One of them must be short, another long"
    1 to: 6 do:[:i|
        (self at:i) ~~ (anotherId at:i) ifTrue:[ ^ false ].
    ].
    ^true

    "Created: / 13-11-2012 / 17:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2012 / 21:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^self size > 0 
        ifTrue:[self computeXorHashFrom:1 to:6]
        ifFalse:[revno hash].

    "Created: / 16-11-2012 / 21:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId methodsFor:'converting'!

asHGChangesetId
    ^ self

    "Created: / 16-11-2012 / 21:22:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asHGRevset
    ^ self asString asHGRevset

    "Created: / 07-02-2014 / 13:03:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asString
    self hasRevnoOnly ifTrue:[ 
        ^ revno printString
    ] ifFalse:[ 
        ^ self hexPrintString asLowercase
    ].

    "Created: / 17-11-2012 / 01:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-10-2017 / 20:48:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalArrayEncoding
    ^ Array 
        with:(self class name)
        with:(self printStringWithoutNumber).
    "
    #(HGChangesetId 'f6f68d32de73') decodeAsLiteralArray literalArrayEncoding
    "

    "Created: / 07-09-2015 / 17:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId methodsFor:'printing & storing'!

displayOn:aStream

    ^self printOn: aStream

    "Created: / 13-11-2012 / 09:55:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2012 / 22:01:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    | rn |

    rn := self revno.
    rn notNil ifTrue:[
        rn printOn: aStream.
        self isEmpty ifTrue:[ ^ self ].
        aStream nextPut: $:.
    ].

    aStream nextPutAll: (self copyTo: 6) hexPrintString asLowercase

    "Modified: / 01-12-2012 / 00:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printStringWithoutNumber
    ^(self copyTo: 6) hexPrintString asLowercase

    "Created: / 27-03-2013 / 11:52:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId methodsFor:'queries'!

hasHashOnly
    ^revno isNil

    "Created: / 16-11-2012 / 21:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasRevno
    ^revno notNil

    "Created: / 22-01-2013 / 22:30:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasRevnoOnly
    ^self size == 0

    "Created: / 16-11-2012 / 21:54:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNull
    ^(revno isNil or:[revno == -1]) 
        and:[self allSatisfy:[:e|e == 0]]

    "Created: / 01-04-2013 / 13:03:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId methodsFor:'testing'!

isFull
    "Return true, if given changeset id is shortened"

    ^self size = 20

    "Created: / 22-01-2013 / 22:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isShort
    "Return true, if given changeset id is shortened"

    ^self size < 20

    "Created: / 16-12-2012 / 00:54:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetId class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

