"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBMethod
	instanceVariableNames:'class compiledMethod source selector info'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Model'
!

RBMethod comment:'RBMethod represents a method in an RBAbstractClass.

Instance Variables:
	class	<RBAbstractClass>	where the method is defined
	compiledMethod	<CompiledCode | nil>	the CompiledMethod object (if we have been compiled)
	selector	<Symbol>	our name
	source	<String>	our source'
!


!RBMethod class methodsFor:'instance creation'!

for: aRBClass fromMethod: aCompiledMethod andSelector: aSymbol 
	^(self new)
		modelClass: aRBClass;
		method: aCompiledMethod;
		selector: aSymbol;
		yourself
!

for: aRBClass source: aString selector: aSelector 
	^(self new)
		modelClass: aRBClass;
		selector: aSelector;
		source: aString;
		yourself
!

forMethodChange:aChange
    "return an RBMethod instance for a change.
     This may or may not refer to a really existing class"
     
    |cls|
    
    self assert:aChange isMethodCodeChange.
    cls := aChange changeClass notNil
            ifTrue:[aChange changeClass]
            ifFalse:[RBClass named:aChange className].
            
    ^ (self new)
                modelClass: cls;
                selector: aChange changeSelector ;
                source: aChange source;
                yourself

    "Created: / 04-02-2017 / 23:20:38 / cg"
    "Modified: / 05-02-2017 / 03:57:10 / cg"
! !

!RBMethod methodsFor:'accessing'!

allLiterals
    | m |

    m := self method.
    m notNil ifTrue:[
        ^m allLiterals.
    ].
    ^#()

    "Created: / 17-02-2012 / 00:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsAt:aSymbol do:aBlock
    | m |

    m := self method.
    m notNil ifTrue:[
        ^m annotationsAt:aSymbol do:aBlock
    ].

    "Created: / 17-02-2012 / 00:03:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

category
    "Returns in which category/protocol does the method belongs within a class"

    | category |

    category := self objectAttributeAt: #category.  

    category isNil ifTrue: [  
        | compiledMethod |

        compiledMethod := self method.
        compiledMethod notNil ifTrue:[
            ^ compiledMethod category.
        ].

        ^ 'as yet unclassified'
    ].

    ^ category

    "Created: / 17-02-2012 / 00:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 06-10-2014 / 07:55:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

info
    "Returns an 'info object' that can answer various
     questions like 'what selectors method sends',
     names if temporaries etc.

     Actally, 'info object' is a remembered instance of Parser"

    info isNil ifTrue:[
        info := Parser 
            parseMethod: self source
            in:nil
            ignoreErrors:true
            ignoreWarnings:true
    ].
    ^ info

    "Created: / 16-02-2012 / 16:33:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2014 / 10:13:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

literals
    | m |

    m := self method.
    m notNil ifTrue:[
        ^m literals.
    ].
    ^#()

    "Created: / 17-02-2012 / 00:00:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mclass
    "for compatibility with real methods"

    ^ class
!

method
    "Returns Method instance which is present or retrived from real class"

    (compiledMethod isNil and: [ class notNil ]) ifTrue:[
        | realClass selector |

        realClass := class realClass.
        selector := self selector.

        "Do not try to retrieve method when its not possible"
        (realClass notNil and: [ selector notNil ]) ifTrue: [
            compiledMethod := realClass compiledMethodAt: selector.
        ]
    ].
    ^compiledMethod

    "Modified: / 17-02-2012 / 00:07:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2014 / 16:38:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

method: aCompiledMethod 
	compiledMethod := aCompiledMethod
!

modelClass
	^class
!

modelClass: aRBClass
	class := aRBClass
!

package
    "see Method >> package ( same purpose, but for model method )"
    | package |

    package := self objectAttributeAt: #package.

    package isNil ifTrue: [ 
        | method |

        method := self method.

        method isNil ifTrue: [
            package := PackageId noProjectID
        ] ifFalse: [
            package := method package
        ]
    ].

    ^ package

    "Created: / 17-02-2012 / 00:41:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2014 / 16:34:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

parseTree
    ^RBParser 
        parseMethod: self source 
        onError: [:str :pos | 
            "/Transcript showCR:str. Transcript showCR:pos.
            ^ nil
        ]

    "Modified: / 17-02-2012 / 11:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    (selector isNil and: [ source notEmptyOrNil ]) ifTrue:[
        selector := (Parser parseMethodSpecification: source) selector.
    ].
    ^selector

    "Modified: / 16-02-2012 / 16:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-12-2014 / 13:24:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selector: aSymbol 
	selector := aSymbol
!

source
        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            ^source isNil 
                    ifTrue: [source := compiledMethod source]
                    ifFalse: [source]
        ].

        ^source isNil 
                ifTrue: [source := compiledMethod getSource]
                ifFalse: [source]

    "Modified: / 22-11-2012 / 00:55:40 / cg"
!

source: aString 
	source := aString
! !



!RBMethod methodsFor:'printing'!

printOn: aStream 
	class printOn: aStream.
	aStream
		nextPutAll: '>>';
		nextPutAll: self selector
! !

!RBMethod methodsFor:'private'!

literal: anObject containsReferenceTo: aSymbol 
	anObject = aSymbol ifTrue: [^true].
	anObject class = Array ifFalse: [^false].
	anObject 
		do: [:each | (self literal: each containsReferenceTo: aSymbol) ifTrue: [^true]].
	^false
! !

!RBMethod methodsFor:'queries'!

refersToLiteral:anAssociation
    | m |

    m := self method.
    m notNil ifTrue:[
        ^ m refersToLiteral:anAssociation
    ].
    ^ false "Actually - don't know"

    "Created: / 16-02-2012 / 23:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

refersToLiteralMatching:aMatchPattern
    "return true if the receiver or recursively any array element in the
     receiver is symbolic and matches aMatchPattern (i.e. a deep search)"

    | m |

    m := self method.
    m notNil ifTrue:[
        ^ m refersToLiteralMatching:aMatchPattern
    ].
    ^ false "Actually - don't know"

    "Created: / 16-02-2012 / 23:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2012 / 15:38:46 / cg"
!

sendsAnySelector:aCollectionOfSymbols
    ^self info messagesSent includesAny: aCollectionOfSymbols
!

sendsSelector:aSymbol
    ^self info messagesSent includes: aSymbol

    "Created: / 16-02-2012 / 16:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedGlobals
    | m |

    m := self method.
    m notNil ifTrue:[
        ^ m usedGlobals

    ].
    ^ #() "Actually - don't know"
! !

!RBMethod methodsFor:'testing'!

refersToClassNamed: aSymbol 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: aSymbol asString do: [:node :answer | true].
	^(searcher executeTree: self parseTree initialAnswer: false) 
		or: [self refersToSymbol: aSymbol]
!

refersToSymbol: aSymbol 
        | searcher p|
        searcher := ParseTreeSearcher new.
        p := (RBParser isSmalltalkX ifTrue:[aSymbol storeString] ifFalse:[aSymbol printString]).

        searcher
                matches: p do: [:node :answer | true];
                matches: '`#literal'
                        do: [:node :answer | answer or: [self literal: node value containsReferenceTo: aSymbol]].
        (RBScanner isSelector: aSymbol) 
                ifTrue: 
                        [searcher 
                                matches: '`@object ' , (ParseTreeSearcher buildSelectorString: aSymbol)
                                do: [:node :answer | true]].
        ^searcher executeTree: self parseTree initialAnswer: false
!

refersToVariable: aString 
	| searcher tree |
	tree := self parseTree.
	((tree defines: aString) or: [tree body defines: aString]) 
		ifTrue: [^false].
	searcher := ParseTreeSearcher new.
	searcher
		matches: aString do: [:node :answer | true];
		matches: '[:`@vars | | `@temps | `@.Stmts]'
			do: 
				[:node :answer | 
				answer or: 
						[((node defines: aString) or: [node body defines: aString]) not 
							and: [searcher executeTree: node body initialAnswer: false]]].
	^searcher executeTree: self parseTree initialAnswer: false
! !

!RBMethod class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

