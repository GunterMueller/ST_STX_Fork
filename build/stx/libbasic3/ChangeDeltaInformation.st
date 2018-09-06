"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ChangeDeltaInformation
	instanceVariableNames:'shortDeltaSymbol'
	classVariableNames:'Unknown Identical Different Added Removed IdenticalButWhiteSpace
		IdenticalButFormat IdenticalSemantically Conflict'
	poolDictionaries:''
	category:'System-Changes'
!

!ChangeDeltaInformation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    delta used to return a symbol (#=, #~, #+ or #-);
    for more detail, use instances of me:
        Unknown                 delta is unknown
        Identical               exactly the same
        IdenticalButWhiteSpace  code is formatted different, but AST is the same
        SemanticallyIdentical   code is different, but semantically the same
                                (for example, ifNil: -> isNil ifTrue:)
        Different               code is different
        Added                   method/class is added by change
        Removed                 method/class is removed by change
"
! !

!ChangeDeltaInformation class methodsFor:'initialization'!

initialize
    Unknown                 := self new shortDeltaSymbol:#'?'.    "/ delta is unknown
    Identical               := self new shortDeltaSymbol:#'='.    "/ exactly the same
    IdenticalButWhiteSpace  := self new shortDeltaSymbol:#'W'.    "/ code is the same except for indentation
    IdenticalButFormat      := self new shortDeltaSymbol:#'F'.    "/ code is formatted different, but AST is the same
    IdenticalSemantically   := self new shortDeltaSymbol:#'%'.    "/ code is different, but semantically the same
                                                                  "/ (for example, ifNil: -> isNil ifTrue:)
    Different               := self new shortDeltaSymbol:#'~'.    "/ code is different
    Added                   := self new shortDeltaSymbol:#'+'.    "/ method/class is added by change
    Removed                 := self new shortDeltaSymbol:#'-'.    "/ method/class is removed by change
    Conflict                := self new shortDeltaSymbol:#'!!'.    "/ package conflict - overwrites existing method

    "Created: / 31-08-2011 / 10:09:24 / cg"
! !

!ChangeDeltaInformation class methodsFor:'accessing'!

added
    "method/class is added by change"

    ^ Added

    "Modified (comment): / 31-08-2011 / 10:20:51 / cg"
!

conflict
    "method overwrites existing method from another package"

    ^ Conflict
!

different
    "code is different"

    ^ Different

    "Modified (comment): / 31-08-2011 / 10:21:07 / cg"
!

identical
    "exactly the same"

    ^ Identical

    "Modified (comment): / 31-08-2011 / 10:21:18 / cg"
!

identicalButFormat
    "code is formatted different, but AST is the same"

    ^ IdenticalButFormat

    "Created: / 31-08-2011 / 10:23:18 / cg"
!

identicalButWhiteSpace
    "code is the same except for indentation"

    ^ IdenticalButWhiteSpace

    "Modified (comment): / 31-08-2011 / 10:23:49 / cg"
!

identicalSemantically
    "code is different, but semantically the same.
     (for example, ifNil: -> isNil ifTrue:)"

    ^ IdenticalSemantically

    "Modified (comment): / 31-08-2011 / 10:24:04 / cg"
!

removed
    "method/class is removed by change"

    ^ Removed

    "Modified (comment): / 31-08-2011 / 10:24:14 / cg"
!

unknown
    "another change / cannot figure out what has changed"

    ^ Unknown

    "Created: / 31-08-2011 / 10:20:13 / cg"
! !

!ChangeDeltaInformation class methodsFor:'utilities'!

changeDeltaFor:changeText changeClass:changeClass selector:methodSelector
    "utility: give a changed method's source, compare against the current version in the system"

    |currentText method t1 t2|

    changeClass isNil ifTrue:[ ^ '+'].

    (methodSelector isNil or:[changeClass theNonMetaclass isLoaded not]) ifTrue:[
        ^ '?'
    ].
    (changeClass includesSelector:methodSelector asSymbol) ifFalse:[
        ^ '+'.
    ].

    method := changeClass compiledMethodAt:methodSelector asSymbol.
    Error handle:[:ex |
        Transcript showCR:'Error while accessing methods current source: ',ex description.
    ] do:[
        currentText := method source.
    ].
    currentText isNil ifTrue:[
        "/ cannot access the source code - assume changed
        ^ '!!'.
    ].

    changeText asString string withoutTrailingSeparators = currentText asString string withoutTrailingSeparators ifTrue:[
        ^ '='
    ].

    t1 := currentText asCollectionOfLines collect:[:s | s withTabsExpanded].
    t2 := changeText asCollectionOfLines collect:[:s | s withTabsExpanded].
    t1 = t2 ifTrue:[
        ^ '='
    ].

    RBParser notNil ifTrue:[
        |tree1 tree2|

        tree1 := RBParser parseMethod:currentText onError:[:aString :pos | ^ '!!'].
        tree2 := RBParser parseMethod:changeText onError:[:aString :pos | ^ '!!'].

        tree1 = tree2 ifTrue:[
            ^ '~'
        ].
    ].

    ^ ' '
! !

!ChangeDeltaInformation methodsFor:'accessing'!

shortDeltaSymbol
    ^ shortDeltaSymbol

    "Created: / 31-08-2011 / 10:39:01 / cg"
!

shortDeltaSymbol:something
    shortDeltaSymbol := something.

    "Created: / 31-08-2011 / 10:39:05 / cg"
! !

!ChangeDeltaInformation methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    shortDeltaSymbol printOn:aStream.
    aStream nextPut:$).

    "Modified: / 23-04-2015 / 08:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeDeltaInformation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ChangeDeltaInformation.st,v 1.4 2014-12-11 20:47:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/ChangeDeltaInformation.st,v 1.4 2014-12-11 20:47:41 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ChangeDeltaInformation initialize!
