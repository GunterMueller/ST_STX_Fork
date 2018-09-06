"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

StringCollection subclass:#FileText
	instanceVariableNames:'myStream lastLineKnown lastLineOfFile cachedLines cacheLineNr'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!FileText class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    FileText represents the contents of a text-file and allows
    transparent access, via #at:, as if the lineStrings were in
    memory - although, only a small portion of the file is actually
    present in a cache.

    Only the offsets of the text-lines are stored in an internal array
    to save memory space. The #at: method fetches the line from the file.
    Individual textlines may be replaced by strings (via #at:put:).
    The underlying file is NOT updated in this case.

    Care should be taken, if the underlying file is rewritten -
    you have to manually update/flush the pointers.
    Never rewrite the file using the data from a FileText.
    If you keep a file's contents in a FileText object and want to
    rewrite that file, you MUST write to a temporary file first.
    Otherwise, you will clobber the contents.

    This is an EXPERIMENTAL class, use at your own risk.
    (If at all, use fileText for huge readonly texts only.)

    [author:]
        Claus Gittinger
"
! !

!FileText class methodsFor:'instance creation'!

of:aStream
    "return a new FileText object for the stream aStream"

    ^ (self new:1) of:aStream
!

ofFile:aFileName
    "return a new FileText object for the named file"

    |aStream|

    aStream := FileStream readonlyFileNamed:aFileName.
    aStream isNil ifTrue:[^ nil].
    ^ (self new:1) of:aStream
! !

!FileText methodsFor:'accessing'!

at:index
    "return the files line at index, as a string"

    |entry oldPosition|

    (index > lastLineKnown) ifTrue:[
        self scanUpToLine:index.
        (lastLineOfFile notNil) ifTrue:[
            (index > lastLineOfFile) ifTrue:[
                ^ self subscriptBoundsError
            ]
        ]
    ].

    entry := super at:index.
    entry isSingleByteString ifTrue:[^ entry].

    cachedLines isNil ifTrue:[
        cachedLines := Array new:50.
        cacheLineNr := -9999
    ].
    ((index < cacheLineNr)
     or:[index >= (cacheLineNr + cachedLines size)]) ifTrue:[
        oldPosition := myStream position.
        myStream position:entry.
        1 to:(cachedLines size) do:[:cacheIndex|
            cachedLines at:cacheIndex put:(myStream nextLine)
        ].
        myStream position:oldPosition.
        cacheLineNr := index
    ].

    ^ cachedLines at:(index - cacheLineNr + 1)

    "Modified: 27.4.1996 / 13:32:29 / cg"
!

of:aStream
    "setup the receiver for lines from aStream"

    myStream := aStream.
    lastLineOfFile := nil.
    lastLineKnown := 0.
    cachedLines := nil

    "Modified: 27.4.1996 / 13:33:26 / cg"
!

size
    "return the number of text-lines - have to scan file the first time"

    (lastLineOfFile isNil) ifTrue:[
	self scanUpToEnd
    ].
    ^ lastLineOfFile
! !

!FileText methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for all lines"

    self from:1 to:(self size) do:aBlock

    "Modified: 27.4.1996 / 13:33:51 / cg"
!

from:index1 to:index2 do:aBlock
    "evaluate aBlock for all lines from index1 to index2.
     Must be redefined back since elements are indices into file, 
     not the elements themselfes"

    |index "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }" |

    index := index1.
    stop := index2.
    [index <= stop] whileTrue:[
        aBlock value:(self at:index).
        index := index + 1
    ]

    "Modified: 27.4.1996 / 13:34:16 / cg"
! !

!FileText methodsFor:'private'!

scanUpToEnd
    "scan myStream up to the end of file"

    (lastLineOfFile notNil) ifTrue:[^ self].
    [true] whileTrue:[
	lastLineKnown := lastLineKnown + 1.
	(super size < lastLineKnown) ifTrue:[
	    super grow:(super size * 2 + 1)
	].
	super at:lastLineKnown put:(myStream position).
	myStream skipLine isNil ifTrue:[
	    lastLineOfFile := lastLineKnown.
	    ^ self
	]
    ]
!

scanUpToLine:index
    "scan myStream up to line index and save line-start-positions"

    (lastLineOfFile notNil) ifTrue:[
	(index > lastLineOfFile) ifTrue:[^ self]
    ].
    [lastLineKnown <= index] whileTrue:[
	lastLineKnown := lastLineKnown + 1.
	(super size < lastLineKnown) ifTrue:[
	    super grow:(super size * 2 + 1)
	].
	super at:lastLineKnown put:(myStream position).
	myStream skipLine isNil ifTrue:[
	    lastLineOfFile := lastLineKnown.
	    ^ self
	]
    ]
! !

!FileText class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

