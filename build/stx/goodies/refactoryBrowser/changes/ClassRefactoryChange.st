"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RefactoryChange subclass:#ClassRefactoryChange
	instanceVariableNames:'variable isAddition isClassVar rename'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!

ClassRefactoryChange comment:'ClassRefactoryChange is a RefactoryChange that represents a change to a class (insert/delete inst var, etc.). We should probably separate the different types of changes into different classes, but this hasn''t been done yet...

Instance Variables:
	isAddition	<Boolean>	is the variable change an addition or removal
	isClassVar	<Boolean>	is the variable a class variable or instance variable
	rename	<Boolean>	are we renaming the class
	variable	<Object>	the variable name or new class name if we are renaming the class'
!


!ClassRefactoryChange methodsFor:'accessing'!

doIt
        | selector class|

        class := self theClass.
        rename 
                ifTrue: 
                        [class rename: variable.
                        ^self].
        selector := isClassVar 
                                ifTrue: 
                                        [isAddition ifTrue: [#addClassVarName:] ifFalse: [#removeClassVarName:]]
                                ifFalse: 
                                        [isAddition ifTrue: [#addInstVarName:] ifFalse: [#removeInstVarName:]].
        class perform: selector with: variable.
        RBParser isSmalltalkX ifTrue:[
            self theClass.
        ] ifFalse:[
            "Add the class variable changes to the current ChangeSet since the class doesn't add them."
            ChangeSet current changeClass: class.

            "Add the variable change to the .cha file, since it isn't recorded either"
            SourceFileManager default logChange: ('<1p> <2s> <3p>' expandMacrosWith: class with: selector with: variable)
        ].

    "Modified: / 4.2.2000 / 00:45:26 / cg"
! !

!ClassRefactoryChange methodsFor:'initialize-release'!

addClassVariable: aVar to: aClass
	class := aClass.
	variable := aVar.
	isAddition := true.
	isClassVar := true.
	rename := false
!

addVariable: aVar to: aClass
	class := aClass.
	variable := aVar.
	isAddition := true.
	isClassVar := false.
	rename := false
!

removeClassVariable: aVar from: aClass
	class := aClass.
	variable := aVar.
	isAddition := false.
	isClassVar := true.
	rename := false
!

removeVariable: aVar from: aClass
	class := aClass.
	variable := aVar.
	isAddition := false.
	isClassVar := false.
	rename := false
!

rename: aClass to: newName 
	class := aClass.
	variable := newName.
	rename := true.
	isClassVar := false
! !

!ClassRefactoryChange methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    super displayOn:aGCOrStream.
    rename ifTrue:[
        aGCOrStream nextPutAll:' ->'.
    ] ifFalse:[
        aGCOrStream nextPutAll:(isAddition ifTrue: [' adds'] ifFalse: [' removes']).
        aGCOrStream nextPutAll:(isClassVar ifTrue: [' class variable '] ifFalse: [' instance variable ']).
    ].
    variable printOn:aGCOrStream.
!

printOn: aStream
	aStream nextPutAll: 'Class change'
! !

!ClassRefactoryChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/ClassRefactoryChange.st,v 1.10 2013-08-19 16:01:18 stefan Exp $'
! !

