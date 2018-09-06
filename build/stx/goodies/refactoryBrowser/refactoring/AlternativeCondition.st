"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

RBAbstractCondition subclass:#RBAlternativeCondition
	instanceVariableNames:'left right ok'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Conditions'
!


!RBAlternativeCondition methodsFor:'checking'!

check
        left check ifTrue:[ok := #leftOK. ^ true].
        right check ifTrue:[ok := #rightOK. ^ true]. 
        ^false
!

check:errAction
        (left check:[:badCond | ])  ifTrue:[ok := #leftOK. ^ true].
        (right check:[:badCond | ]) ifTrue:[ok := #rightOK. ^ true]. 
        errAction value:self.
        ^false
!

left: aCondition right: aCondition2 
    left := aCondition.
    right := aCondition2.
    ok := nil
! !

!RBAlternativeCondition methodsFor:'printing'!

bothFailed
        ^ (left errorStringFor:false) , ' AND ' , (right errorStringFor: false)
!

errorStringFor:aBoolean 
    aBoolean 
            ifTrue:[ ^ self perform:ok ]
            ifFalse: [ ^ self bothFailed]
!

leftOK
        ^ (left errorStringFor: true)
!

printOn: aStream 
        aStream print: left;
                nextPutAll: ' | ';
                print: right
!

rightOK
        ^ (right errorStringFor: true)
! !

!RBAlternativeCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/AlternativeCondition.st,v 1.2 2011-06-11 15:28:33 vrany Exp $'
! !
