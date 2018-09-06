"{ Package: 'stx:libscm/git' }"

GitLibraryObject subclass:#GitSignature
	instanceVariableNames:'name namePtr email emailPtr timestamp'
	classVariableNames:'Default'
	poolDictionaries:''
	category:'SCM-Git-Core'
!


!GitSignature class methodsFor:'instance creation'!

name: name email: email
    | ref |

    ref := ByteArray new: ExternalBytes sizeofPointer.
    GitError raiseIfError: (GitPrimitives prim_git_signature_new: ref name: name email: email time: 0 offset: 0 ).
    ^self basicNew 
        setHandleFromRef:ref;
        yourself

    "
        self new
    "

    "Created: / 30-09-2012 / 10:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    <todo: 'Replace with values from git config'>
    ^self name: '**unitialized**' email: '**unitialized**'

    "Created: / 25-09-2012 / 12:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature class methodsFor:'accessing-default'!

default
    Default isNil ifTrue:[ 
        Default := self new.
        Default name: OperatingSystem getFullUserName.
        Default email: (Dialog request:'Git - Enter your email')
    ].
    ^ Default.

    "
        GitSignature default
    "

    "Created: / 25-09-2012 / 11:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature methodsFor:'accessing'!

email

    (email isNil and:[handle notNil]) ifTrue:[
        email := (emailPtr := handle email) copyCStringFromHeap utf8Decoded
    ].
    ^email

    "Modified: / 25-09-2012 / 11:28:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

email:aString

    email := aString.
    emailPtr := ExternalBytes newNullTerminatedFromString:aString.
    handle email: emailPtr address

    "Modified: / 25-09-2012 / 14:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    (name isNil and:[handle notNil]) ifTrue:[
        name := (namePtr := handle name) copyCStringFromHeap utf8Decoded
    ].
    ^name

    "Modified: / 25-09-2012 / 11:28:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString

    name := aString.
    namePtr := ExternalBytes newNullTerminatedFromString:aString.
    handle name: namePtr address

    "Modified: / 25-09-2012 / 14:26:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timestamp

    (timestamp isNil and:[handle notNil]) ifTrue:[
        timestamp := Timestamp utcSecondsSince1970: handle time + handle offset
    ].
    ^timestamp

    "Modified: / 29-09-2012 / 23:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timestamp: aTimestamp

    timestamp := aTimestamp. 
    handle notNil ifTrue:[
        handle time: timestamp utcSecondsSince1970.
        handle offset: 0
    ].
    ^timestamp

    "Created: / 25-09-2012 / 14:36:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature methodsFor:'copying'!

copyNow
    ^self copy timestamp: Timestamp now; yourself

    "Created: / 25-09-2012 / 14:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shallowCopy
    ^self class basicNew 
        setHandle:(GitPrimitives prim_git_signature_dup: handle);
        yourself

    "Created: / 25-09-2012 / 14:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream 
        nextPutAll: self name;
        space;
        nextPut:$<;
        nextPutAll: self email;
        nextPut:$>;
        space.
    self timestamp printOn: aStream

    "Modified: / 25-09-2012 / 14:40:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature methodsFor:'private-accessing'!

getHandleClass
    ^GitSignatureStructure

    "Created: / 19-09-2012 / 01:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHandle: hndl
    self assert: (hndl isNil or:[hndl class == self getHandleClass]).
    handle := hndl.

    "Created: / 19-09-2012 / 01:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSignature class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
