"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBReplaceStringInOriginalSource
	instanceVariableNames:'oldNode newNode'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!

!RBReplaceStringInOriginalSource class methodsFor:'documentation'!

documentation
"
    a concrete replace action, to replace a node by another node in the source
    (i.e. in contrast to the normal rewrites, this preserves all code which is not
     below the two affected nodes).
    Tries, but sometimes fails to preserve the indentation within the node 
    (eg. if it is a message send).
"
! !

!RBReplaceStringInOriginalSource methodsFor:'accessing'!

newNode
    "return the value of the instance variable 'newNode' (automatically generated)"

    ^ newNode
!

newNode:something
    "set the value of the instance variable 'newNode' (automatically generated)"

    newNode := something.
!

oldEndPosition
    ^ oldNode endPosition
!

oldNode
    "return the value of the instance variable 'oldNode' (automatically generated)"

    ^ oldNode
!

oldNode:something
    "set the value of the instance variable 'oldNode' (automatically generated)"

    oldNode := something.
!

oldStartPosition
    ^ oldNode startPosition
!

tokenPosition
    ^ oldNode start
! !

!RBReplaceStringInOriginalSource methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:self class name.
    aStream nextPutAll:'(['.
    oldNode start printOn: aStream.
    aStream nextPutAll:'..'.
    oldNode stop printOn: aStream.
    aStream nextPutAll:'] '.
    oldNode printOn:aStream.
    aStream nextPutAll:' -> '.
    newNode printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 19-02-2015 / 16:22:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBReplaceStringInOriginalSource methodsFor:'replacing'!

addIndividualReplacementsTo:aCollection
    aCollection add:self.
!

executeIn:aSourceString
    | start stop newCode indent lastLineStart sourceStream |

    start := oldNode start.
    stop := oldNode stop.
    newNode isVariable ifTrue:[
        newCode := newNode name
    ] ifFalse:[
        sourceStream := aSourceString readStream.
        [ sourceStream atEnd not and:[(sourceStream position) < start ] ]  whileTrue:[
            lastLineStart := sourceStream position.
            sourceStream nextLine.
        ].
        indent := String new: start - lastLineStart + 1.


        newCode := String streamContents: [:s |
            | lines |

            lines := newNode formattedCode asStringCollection.
            s nextPutAll: lines first.
            lines size > 1 ifTrue:[
                2 to: lines size do:[:lineNr|
                    s cr.
                    s nextPutAll: indent.
                    s nextPutAll: (lines at:lineNr)
                ]
            ]
        ]

    ].

    ^ (aSourceString copyTo:start-1)
          , newCode
          , (aSourceString copyFrom:stop+1)

    "Modified: / 23-07-2011 / 14:29:50 / cg"
    "Modified: / 25-08-2013 / 14:21:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBReplaceStringInOriginalSource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

