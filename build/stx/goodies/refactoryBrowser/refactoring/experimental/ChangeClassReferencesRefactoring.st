"{ Package: 'stx:goodies/refactoryBrowser/refactoring/experimental' }"

"{ NameSpace: Smalltalk }"

ClassRefactoring subclass:#ChangeClassReferencesRefactoring
	instanceVariableNames:'newName class'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Refactorings'
!

!ChangeClassReferencesRefactoring class methodsFor:'documentation'!

documentation
"
    untested.

    not really a semantics-preserving refactoring.
    This rewrites the code to change all references to a global by another global,
    and is (currently) only used to generate source code for export to systems which do
    not support namespaces (namely to generate code for VSE systems).
    For this, a class named Foo::Bar (i.e. class name is Bar in namespace Foo) is saved as
    a class named Foo_Bar, and all references to Foo::Bar are to be replaced by Foo_Bar,
    and all references to Bar from inside the namespace also.
"
! !

!ChangeClassReferencesRefactoring class methodsFor:'instance creation'!

changeReferencesFrom: oldClassName to: aNewName
        ^self new className: oldClassName newName: aNewName
! !

!ChangeClassReferencesRefactoring methodsFor:'initialize-release'!

className: aName newName: aNewName 
	className := aName asSymbol.
	class := self model classNamed: className.
	newName := aNewName asSymbol
! !

!ChangeClassReferencesRefactoring methodsFor:'preconditions'!

preconditions
        ^(RBCondition withBlock: [class notNil and: [class isMeta not]]
                errorString: className , ' is not a valid class name') 
                        "& (RBCondition isValidClassName: newName)            "
                        "& (RBCondition isGlobal: newName in: self model) not "
! !

!ChangeClassReferencesRefactoring methodsFor:'printing'!

storeOn: aStream 
        aStream nextPut: $(.
        self class storeOn: aStream.
        aStream nextPutAll: ' changeReferencesFrom: '.
        class storeOn: aStream.
        aStream
                nextPutAll: ' to: #';
                nextPutAll: newName;
                nextPut: $)
! !

!ChangeClassReferencesRefactoring methodsFor:'transforming'!

renameReferences
        | replacer className2 newName2|

        replacer := (ParseTreeRewriter 
                            replaceLiteral: className with: newName)
                            replaceVariable: className with: newName.

        (className includes:$:) ifTrue:[
            "/ a private or namespace class
            className2 := className copyFrom:(className lastIndexOf:$:)+1.
            newName2 := newName.
            (newName includes:$:) ifTrue:[
                (className copyTo:(className lastIndexOf:$:)) = (newName copyTo:(newName lastIndexOf:$:)) ifTrue:[
                    newName2 := newName copyFrom:(newName lastIndexOf:$:)+1.
                ]
            ].
            replacer 
                replaceLiteral: className2 with: newName2;
                replaceVariable: className2 with: newName2.
        ].

        self model allReferencesToClass: class
                do:[:method | 
                    self 
                            convertMethod: method selector
                            for: method modelClass
                            using: replacer]
!

transform
        self renameReferences
! !

!ChangeClassReferencesRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/experimental/ChangeClassReferencesRefactoring.st,v 1.1 2015-01-28 12:57:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/experimental/ChangeClassReferencesRefactoring.st,v 1.1 2015-01-28 12:57:59 cg Exp $'
! !

