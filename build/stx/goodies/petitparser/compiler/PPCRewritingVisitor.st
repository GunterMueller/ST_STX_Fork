"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PPCRewritingVisitor
	instanceVariableNames:'change'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCRewritingVisitor methodsFor:'as yet unclassified'!

change
    self flag: 'JK: Do we need this?'.
    change := true.
!

visitChild: child of: node
    | newChild |

    (self isOpen: child) ifTrue: [ 
        "already processing..."
        ^ nil
    ].

    (self isCached: child) ifTrue: [ 
        "Use Cached Value"
        node replace: child with: (self cachedValue: child).
        ^ nil
    ]. 


    change := false.
    newChild := self visit: child.
    change ifTrue: [ 
        node replace: child with: newChild.
    ].
!

visitChildren: node
    node children do: [ :child | 
        self visitChild: child of: node
    ]
! !

