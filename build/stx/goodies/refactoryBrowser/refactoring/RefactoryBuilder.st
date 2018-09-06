"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Object subclass:#RefactoryBuilder
	instanceVariableNames:'changes'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!

RefactoryBuilder comment:'RefactoryBuilder represents a series of changes (RefactoryChange) that need to be performed. It provides transaction-like behavior by defering all changes until it is told to commit them (#doIt).

Instance Variables:
	changes <SequenceableCollection of: RefactoryChange>    the changes that need to be performed'
!


!RefactoryBuilder class methodsFor:'instance creation'!

new
        ^self basicNew initialize
! !

!RefactoryBuilder methodsFor:'accessing'!

problemCount
	^changes size
! !

!RefactoryBuilder methodsFor:'initialize-release'!

initialize
	changes := OrderedCollection new
! !

!RefactoryBuilder methodsFor:'performing-changes'!

doIt
	changes do: [:each | each doIt]
!

doIt:aString
        | tally controller model |

        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            changes do:[:change | change doIt.]
        ] ifFalse:[
            model := 0 asValue.
            tally := changes size.
            controller := ProgressWidgetView progressOpenOn: model label: aString.

            [model value: 0.
            1 to: changes size
                    do:
                            [:i |
                            (changes at: i) doIt.
                            model value: i asFloat / tally]]
                    ensure: [controller closeAndUnschedule]
        ].

    "Modified: / 4.2.2000 / 01:28:32 / cg"
! !

!RefactoryBuilder methodsFor:'printing'!

printOn: aStream
	changes printOn: aStream
! !

!RefactoryBuilder methodsFor:'private-inspector accessing'!

changes
	^changes
!

removeChange: aChange 
	changes remove: aChange ifAbsent: []
! !

!RefactoryBuilder methodsFor:'refactory-changes'!

addClassVariable: variableName to: aClass
	changes add: (ClassRefactoryChange new addClassVariable: variableName to: aClass)
!

addInstanceVariable: variableName to: aClass
	changes add: (ClassRefactoryChange new addVariable: variableName to: aClass)
!

compile: source in: class 
	changes add: (MethodRefactoryChange new class: class source: source)
!

compile: source in: class classified: aProtocol 
	changes add: (MethodRefactoryChange new class: class
				protocol: aProtocol
				source: source)
!

removeClassVariable: variableName from: aClass
	changes add: (ClassRefactoryChange new removeClassVariable: variableName from: aClass)
!

removeInstanceVariable: variableName from: aClass
	changes add: (ClassRefactoryChange new removeVariable: variableName from: aClass)
!

renameClass: class to: newName
	changes add: (ClassRefactoryChange new rename: class to: newName)
! !

!RefactoryBuilder methodsFor:'user interface'!

inspect
	RefactoryBuilderInspector openOn: self
! !

!RefactoryBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RefactoryBuilder.st,v 1.11 2005-08-02 13:15:10 cg Exp $'
! !
