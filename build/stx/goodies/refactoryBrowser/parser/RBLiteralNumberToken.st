"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBLiteralToken subclass:#RBLiteralNumberToken
	instanceVariableNames:'radix'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBLiteralNumberToken class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ Install an alias - Squeak/Pharo has RBNumberLiteralToken
    Smalltalk at: #RBNumberLiteralToken put: self.

    "Modified (comment): / 07-10-2014 / 22:53:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLiteralNumberToken class methodsFor:'instance creation'!

value: aNumber start: anInteger stop: stopInteger lineNumber:lineNumber radix:radixArg
        ^ self new
                value: aNumber
                start: anInteger
                stop: stopInteger
                lineNumber:lineNumber
                radix:radixArg

    "Modified: / 17-08-2015 / 23:25:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value: aString start: anInteger stop: stopInteger source: source
    | radix |

    radix := nil.
    (source includes: $r) ifTrue:[ 
        radix := Integer readFrom: source readStream.
    ].
    ^ self new
            value: aString
            start: anInteger
            stop: stopInteger
            lineNumber:nil
            radix:radix

    "Created: / 07-10-2014 / 22:57:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2015 / 23:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLiteralNumberToken methodsFor:'accessing'!

radix
    ^ radix
!

radix:something
    radix := something.
! !

!RBLiteralNumberToken methodsFor:'initialization & release'!

value: aString start: startInteger stop: stopInteger lineNumber:lineNumberInteger radix:radixArg
        self assert:startInteger notNil.
        self assert:stopInteger notNil.

        value := aString.
        sourcePointer := startInteger.
        stopPosition := stopInteger.
        lineNumber := lineNumberInteger.
        radix := radixArg.
        "/ self assert:(lineNumber notNil).
! !

!RBLiteralNumberToken methodsFor:'testing'!

isLiteralNumber 
    ^ true
! !

!RBLiteralNumberToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBLiteralNumberToken.st,v 1.6 2015-02-19 15:46:39 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


RBLiteralNumberToken initialize!
