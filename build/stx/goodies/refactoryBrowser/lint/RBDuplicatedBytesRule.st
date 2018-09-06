"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBDuplicatedCodeRule subclass:#RBDuplicatedBytesRule
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Experimental Rules'
!


!RBDuplicatedBytesRule methodsFor:'accessing'!

name
	^ super name , ' (bytecode)'
! !

!RBDuplicatedBytesRule methodsFor:'initialization'!

initialize
	super initialize.
	index := OrderedCollection new
! !

!RBDuplicatedBytesRule methodsFor:'private'!

minimalSize
	^ 8
! !

!RBDuplicatedBytesRule methodsFor:'running'!

checkMethod: aContext
        | method bytes substring nBytes|

        method := aContext compiledMethod.
        Smalltalk isSmalltalkX ifTrue:[
            bytes := method byteCode.
        ] ifFalse:[
            bytes := method.
        ].
        nBytes := bytes size.

        method initialPC to: nBytes - self minimalSize do: [ :i |
                i + self minimalSize to: nBytes do: [ :j |
                        substring := ByteArray new: j - i + 1.
                        substring replaceFrom: 1 to: substring size with: bytes startingAt: i.
                        index do: [ :otherMethod |
                                ((otherMethod byteCode ? #[]) indexOfSubCollection: substring startingAt: 1) = 0 
                                        ifFalse: [ self addDuplication: method with: otherMethod in: result ] ] ] ].
        index addLast: aContext compiledMethod
! !

!RBDuplicatedBytesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

