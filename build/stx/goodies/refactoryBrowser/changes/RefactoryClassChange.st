"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

RefactoryChange subclass:#RefactoryClassChange
	instanceVariableNames:'className isMeta'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RefactoryClassChange methodsFor:'accessing'!

changeClass
        | theClass |

        "/ cg: handle anonymous classes
        theClass := Smalltalk at: self changeClassName ifAbsent: [nil].
        theClass isNil ifTrue:[
            theClass := class.
            theClass isNil ifTrue:[ 
                self model notNil ifTrue: [ 
                    ^ isMeta ifTrue: [
                        self model metaclassNamed: self changeClassName  
                    ] ifFalse: [
                        self model classNamed: self changeClassName  
                    ]
                ].
                ^ nil 
            ].
        ].
        ^isMeta ifTrue: [theClass class] ifFalse: [theClass]

    "Modified: / 08-11-2014 / 14:05:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

changeClass: aBehavior 
        isMeta := aBehavior isMeta.
        className := isMeta 
                        ifTrue: [aBehavior soleInstance name]
                        ifFalse: [aBehavior name].

        aBehavior isBehavior "i.e. not a refactory-class-stub" ifTrue:[
            "/ added by cg:
            (class := (Smalltalk at: className asSymbol ifAbsent: [nil])) isNil ifTrue:[
                "/ a change for an anonymous class...
                class := aBehavior theNonMetaclass
            ].
        ].
!

changeClassName
	^className
!

changeClassName: aSymbol 
	className := aSymbol.
	isMeta isNil ifTrue: [isMeta := false]
!

methodSourceFor: aSymbol 
	(self changeClass includesSelector: aSymbol) ifFalse: [^nil].
	^self changeClass sourceCodeAt: aSymbol
!

renameChangesForClass: aClassName to: newClassName 
	self changeClassName == aClassName 
		ifTrue: 
			[^(self copy)
				changeClassName: newClassName;
				yourself].
	^self
! !

!RefactoryClassChange methodsFor:'comparing'!

= aRefactoryClassChange 
	self class = aRefactoryClassChange class ifFalse: [^false].
	^className = aRefactoryClassChange changeClassName 
		and: [isMeta = aRefactoryClassChange isMeta]
!

hash
	^self changeClassName hash
! !

!RefactoryClassChange methodsFor:'converting'!

asUndoOperation
	^self subclassResponsibility
! !

!RefactoryClassChange methodsFor:'printing'!

changeString
	^self displayClassName
!

displayClassName
	^isMeta 
		ifTrue: [self changeClassName , ' class']
		ifFalse: [self changeClassName asString]
!

printOn: aStream
	aStream nextPutAll: self displayString
! !

!RefactoryClassChange methodsFor:'private'!

executeNotifying: aBlock 
        | undo |
        undo := self asUndoOperation.
        undo name: self name.
        self primitiveExecute.
        aBlock value.
        ^ undo
!

isMeta
	^isMeta
!

primitiveExecute
	^self subclassResponsibility
! !

!RefactoryClassChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RefactoryClassChange.st,v 1.7 2012-08-23 12:34:07 cg Exp $'
! !

