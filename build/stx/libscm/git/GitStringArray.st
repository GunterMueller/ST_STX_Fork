"{ Package: 'stx:libscm/git' }"

GitStructure subclass:#GitStringArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!

!GitStringArray class methodsFor:'documentation'!

documentation
"
    A git_strarray wrapper. GitStringArray is for internal usage only.
    Do not use it your code

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GitStringArray class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^8
! !

!GitStringArray methodsFor:'accessing'!

collect: aBlock    
    | strings newCollection |

    "Reimplemented for speed"

    strings := self strings.
    newCollection := Array new: self count.
    1 to: self count do:[:index|
        | val |

        val := aBlock value: (strings pointerAt: ((index - 1) * ExternalBytes sizeofPointer) + 1) copyCStringFromHeap.
        newCollection at: index put: val.
    ].
    ^newCollection

    "Created: / 30-09-2012 / 20:32:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

do: aBlock    
    | strings |

    "Reimplemented for speed"

    strings := self strings.
    1 to: self count do:[:index|
        aBlock value: (strings pointerAt: ((index - 1) * ExternalBytes sizeofPointer) + 1) copyCStringFromHeap
    ]

    "Created: / 30-09-2012 / 20:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStringArray methodsFor:'accessing-private'!

count
    "Returns a Cface::CLongNode"

    ^self longAt:1 + 4

    "Modified: / 30-09-2012 / 20:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

count: value

    self longLongAt:1 + 4 put:value
!

strings
    "Returns (pointer-to (pointer-to char))"

    ^ExternalBytes 
        address:(self longAt:1 + 0) 
        size:(self count * ExternalBytes sizeofPointer)

    "Modified: / 30-09-2012 / 20:32:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

strings: value

    self pointerAt:1 + 0 put:value
! !

!GitStringArray methodsFor:'adding'!

addAll:aCollection
    self shouldNotImplement. "/ Cannot grow!!

    "Created: / 30-09-2012 / 19:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStringArray methodsFor:'finalization'!

finalize
    GitPrimitives prim_git_strarray_free: self.
    self setAddress:0 size:0

    "Created: / 30-09-2012 / 19:58:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStringArray class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
