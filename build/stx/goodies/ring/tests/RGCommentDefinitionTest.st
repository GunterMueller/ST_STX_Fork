"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGCommentDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGCommentDefinitionTest comment:'SUnit tests for comment definitions'
!

!RGCommentDefinitionTest methodsFor:'testing'!

testActiveComment

    | rgComment |
    rgComment := RGCommentDefinition realClass: RGClassDefinition.
    self assert: rgComment isActive.
    self assert: rgComment sourcePointer isNil.
    self assert: rgComment content notNil.
    self assert: rgComment stamp notNil.
    rgComment content: ''.
    "it always reads from the organization and the previous changes was not commited"
    self assert: rgComment content ~= ''.
    
    rgComment fromActiveToPassive.
    self assert: rgComment isPassive.
    self assert: rgComment sourcePointer isNil.
    self assert: rgComment content notNil.
    self assert: rgComment stamp notNil.
    rgComment content: ''.
    self assert: rgComment content = ''.
    
    rgComment := RGCommentDefinition realClass: RGClassDefinition.
    rgComment fromActiveToHistorical.
    self assert: rgComment isHistorical.
    self assert: rgComment sourcePointer notNil.
    self assert: rgComment content notNil.
    self assert: rgComment stamp notNil.
    rgComment content: ''.
    "it always reads from the source file and the previous changes was not commited"
    self assert: rgComment content ~= ''
!

testCommentFromSourceFile
    | rgComment |
    
    rgComment := (RGCommentDefinition realClass: RGClassDefinition) asHistorical.
    self assert: rgComment isHistorical.
    self assert: rgComment sourcePointer notNil.
    self assert: rgComment content notNil.
    self assert: rgComment stamp notNil
!

testCommentWithoutAuthor
    | newComment |
    
    newComment:= RGCommentDefinition new
                        content: 'This is a comment for test';
                        stamp: '3/22/2011 14:51';
                        yourself.
    
    self assert: (newComment hasAuthor not).
!

testNewComment
    | newComment |
    
    newComment:= RGCommentDefinition new
                        content: 'This is a comment for test';
                        stamp: 'VeronicaUquillas 3/22/2011 14:51';
                        yourself.
    
    self assert: newComment isComment.
    self assert: newComment isPassive.
    self assert: newComment name = #Comment.
    self assert: newComment hasStamp.
    self assert: newComment hasAuthor.
    self assert: newComment timeStamp notNil.
    
    self assert: (newComment author = 'VeronicaUquillas').
    self assert: (newComment timeStamp = '3/22/2011 14:51' asDateAndTime).
    self assert: (newComment parent = nil).
    self assert: (newComment environment = Smalltalk globals).
!

testSorting

    | rgComm1 rgComm2 |
    rgComm1 := RGCommentDefinition realClass: RGClassDefinition.
    rgComm2 := RGCommentDefinition realClass: RGElementDefinition.
    self assert: rgComm1 <= rgComm2
!

testingConversion
    
    | rgComm |
    rgComm := RGCommentDefinition realClass: RGClassDefinition.
    self assert: rgComm asString equals: 'RGClassDefinition Comment'.
    
    rgComm := RGCommentDefinition class: (RGClassDefinition named: #Foo).
    self assert: rgComm asString equals: 'Foo Comment'
! !

