"{ Package: 'stx:libscm/git' }"

GitStructure variableByteSubclass:#GitCheckoutOptions
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'GitCheckoutStrategy'
	category:'SCM-Git-Core'
!


!GitCheckoutOptions class methodsFor:'instance creation'!

new
    ^self new: self structSize

    "Created: / 19-09-2012 / 18:12:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    size == self structSize ifFalse:[
        self error:'Invalid size for git_checkout_opts'.
        ^nil.
    ].
    ^super new: size

    "Created: / 19-09-2012 / 18:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCheckoutOptions class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^28
! !

!GitCheckoutOptions methodsFor:'accessing'!

strategy
    "Returns unsigned 
  int32"
    
    ^ self longAt:1 + 0
!

strategy:value 
    self longAt:1 + 0 put:value
!

strategyCreateMissing
    self strategy: GIT_CHECKOUT_CREATE_MISSING

    "Created: / 19-09-2012 / 18:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

strategyDefault
    self strategy: GIT_CHECKOUT_DEFAULT

    "Created: / 19-09-2012 / 18:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCheckoutOptions methodsFor:'accessing-private'!

dirMode
    "Returns int32"

    ^self longAt:1 + 8
!

dirMode: value

    self longAt:1 + 8 put:value
!

disableFilters
    "Returns int32"

    ^self longAt:1 + 4
!

disableFilters: value

    self longAt:1 + 4 put:value
!

fileMode
    "Returns int32"

    ^self longAt:1 + 12
!

fileMode: value

    self longAt:1 + 12 put:value
!

fileOpenFlags
    "Returns int32"

    ^self longAt:1 + 16
!

fileOpenFlags: value

    self longAt:1 + 16 put:value
!

paths
    "Returns ;; Line: 437
;; Class: GitStrarrayStructure
"

    ^self at:1 + 20
!

paths: value

    self at:1 + 20 put:value
! !

!GitCheckoutOptions class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
