"{ Package: 'stx:libscm/git' }"

ByteArray variableByteSubclass:#GitOid
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitOid class methodsFor:'instance creation'!

fromBytes: aByteArrayOrString

    ^self new replaceBytesFrom: 1 to: 20 with: aByteArrayOrString startingAt: 1

    "Created: / 25-09-2012 / 21:00:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromString: aString

"/    | oid |
"/
"/    oid := self new.
"/    GitPrimitives prim_git_oid_fromstr: oid str: aString.
"/    ^oid.


    | sz oid s hi lo |

    sz := aString size.
    sz ~~ 40 ifTrue:[
        self error:'Not a SHA-1 hex string (must have 40 chars)'.
        ^nil
    ].
    oid := self new.
    s := aString readStream.
    1 to: 20 do: [ :idx |
        hi := s next digitValue.
        lo := s next digitValue.
        oid at:idx put: ((hi bitShift:4) bitOr: lo)
    ].
    ^ oid

    "
    GitOid fromString: '7164acf359f5da8a4bc9cd3e03e2e461013c3811'
    "

    "Created: / 10-09-2012 / 10:49:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^self new: self structSize

    "Created: / 10-09-2012 / 10:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    size ~~ "self structSize"20 ifTrue:[
        self error: 'Size GitOid must be exactly 20 bytes, its a SHA-1 hash'.
        ^nil.
    ].
    ^super new: size

    "Created: / 10-09-2012 / 10:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitOid class methodsFor:'accessing'!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libgit2.so'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'git2.dll'].

    self error:'Library name for host OS is not known'
!

structSize
    "Returns size of undelaying structure in bytes"

    ^20
! !

!GitOid methodsFor:'printing & storing'!

displayOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    self hexPrintOn:aStream.

    "Created: / 19-09-2012 / 00:34:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    self hexPrintOn:aStream.

    "Modified: / 19-09-2012 / 00:32:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitOid methodsFor:'testing'!

isGitOid
    ^true

    "Created: / 19-09-2012 / 13:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitOid class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
