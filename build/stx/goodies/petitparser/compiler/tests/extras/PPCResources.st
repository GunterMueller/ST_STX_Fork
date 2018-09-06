"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#PPCResources
	instanceVariableNames:'cache'
	classVariableNames:'javaCache'
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-Support'
!


!PPCResources methodsFor:'expressions'!

expressionOfSize: size
    | stream |
    stream := WriteStream on: (String new: size * 5).
    self expressionOfSize: size stream: stream.
    ^ stream contents
!

expressionOfSize: size stream: stream
    | index rand |
    index := 0.
    rand := Random new.
    
    [index < size] whileTrue: [ 
 		(rand next < 0.1) ifTrue: [  
            | subSize |
            subSize := rand nextInt: (size - index - 1) + 1.
            stream nextPutAll: ' ('.
            self expressionOfSize: subSize stream: stream.
            stream nextPutAll: ') '.
            index := index + subSize.
        ] ifFalse: [ 
            stream nextPutAll: (rand nextInt: 10) asString.
            index := index + 1.
        ].
    
        (index < size) ifTrue: [ 
 			(rand next < 0.5) 
                ifTrue: [  stream nextPutAll: ' + ' ] 
                ifFalse: [ stream nextPutAll: ' * ' ]
        ]
    ]
!

expressionSourcesBig
    | sources |
    
    cache at: #expressionSourcesBig ifAbsentPut: [ 
        sources := OrderedCollection new.
        
        2000 timesRepeat: [ 
            sources add: (self expressionOfSize: 200).
        ].
        sources	
    ].

    ^ cache at: #expressionSourcesBig
    
!

expressionSourcesMedium
    | sources |

    cache at: #expressionSourcesMedium ifAbsentPut: [ 
        sources := OrderedCollection new.
        
        1000 timesRepeat: [ 
            sources add: (self expressionOfSize: 100).
        ].
        sources	
    ].

    ^ cache at: #expressionSourcesMedium
    
! !

!PPCResources methodsFor:'initialization'!

initialize
    super initialize.
    cache := IdentityDictionary new
! !

!PPCResources methodsFor:'java'!

javaInDirectory: directory
    | files |
    files := self readDirectory: directory.
    files := self files: files withExtension: 'java'.
    
    ^ files collect: [ :f | (FileStream fileNamed: f) contents ]
!

javaLangMath
    ^ (FileStream fileNamed: '../java-src/java/lang/Math.java') contents asString

    "Modified: / 10-05-2015 / 14:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaSourcesBig
    ^ self javaInDirectory: '../java-src/java/util'.
    "^ self workingJavaInDirectory: '../java-src/java/util'"
!

javaUtilTimer
    ^ (FileStream fileNamed: '../java-src/java/util/Timer.java') contents asString

    "Modified: / 10-05-2015 / 14:11:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingJavaInDirectory: directory
    | sources parser |
    "return only such a files, that can be parsed by PPJavaSyntax"

    javaCache ifNil: [ javaCache := Dictionary new ].
    
    ^ javaCache at: directory ifAbsentPut: [ 
        sources := self javaInDirectory: directory.
        parser := PPJavaSyntax new.
    
        sources select: [ :source | ([parser parse: source ] on: Error do: [ PPFailure new ]) isPetitFailure not ]	
    ]
! !

!PPCResources methodsFor:'others'!

idsOfSize: size
    | stream |
    stream := WriteStream on: (String new: size).

    [stream size < size] whileTrue: [ 
        stream nextPutAll: 'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco'.
    ].
    ^ stream contents
! !

!PPCResources methodsFor:'private utilities'!

files: files withExtension: extension
    ^ files select: [ :f | f extension = extension ] 
!

readDirectory: directory
    | file |

    ( (Smalltalk respondsTo: #isSmalltalkX) and:[ Smalltalk isSmalltalkX ] ) ifTrue:[ 
        file := directory asFilename.
        file exists ifFalse:[  
            self error: 'Directory does not exist'.
        ].
        ^ file recursiveDirectoryContentsAsFilenames select:[:each | each isRegularFile ]
    ] ifFalse:[ 
        "Assuming Pharo..."

        file := directory asFileReference.
        file exists ifFalse: [ 
            self error: 'Directory does not exist'.
        ].
        ^ file allFiles
    ]

    "Modified: / 10-05-2015 / 07:54:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCResources methodsFor:'smalltalk'!

smalltalkClassMethods
    ^ self smalltalkInDirectory: '../smalltalk-src/Class/'
    
!

smalltalkInDirectory: directory
    | files |
    files := self readDirectory: directory.
    files := self files: files withExtension: 'st'.
    
    ^ files collect: [ :f | (FileStream fileNamed: f) contents ]
!

smalltalkObjectMethods
    ^ self smalltalkInDirectory: '../smalltalk-src/Object/'
    
!

smalltalkSourcesBig
    ^ self smalltalkInDirectory: '../smalltalk-src/'
!

smalltalkSourcesMedium
    ^ (self smalltalkInDirectory: '../smalltalk-src/') copyFrom: 1 to: 10*1000.
!

smalltalkSourcesSmall
    ^ (self smalltalkInDirectory: '../smalltalk-src/') copyFrom: 1 to: 1000.
! !

!PPCResources class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

