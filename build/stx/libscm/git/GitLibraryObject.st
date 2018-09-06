"{ Package: 'stx:libscm/git' }"

Object subclass:#GitLibraryObject
	instanceVariableNames:'handle'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core'
!

!GitLibraryObject class methodsFor:'documentation'!

documentation
"
    An abstract superclass for all libgit2 objects.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        handle          <GitHandle>     a pointer to underlayng
                                        C object (structure)

    [class variables:]

    [see also:]

"
! !

!GitLibraryObject methodsFor:'finalization'!

executor
    ^self class basicNew setHandleFromOriginal: self

    "Created: / 08-09-2012 / 00:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalize
    self free

    "Created: / 07-09-2012 / 23:08:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitLibraryObject methodsFor:'initialization & release'!

free
    handle notNil ifTrue:[
        self subclassResponsibility.
        handle := nil.
    ].

    "Created: / 08-09-2012 / 00:01:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitLibraryObject methodsFor:'private-accessing'!

getHandle
    ^handle

    "Created: / 19-09-2012 / 00:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getHandleClass
    "Returns a class of my handle."

    ^self subclassResponsibility

    "Created: / 17-09-2012 / 21:19:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHandle: hndl
    self assert: (hndl isNil or:[hndl class == self getHandleClass]).
    handle := hndl.
    handle notNil ifTrue:[
        self registerForFinalization.
    ].

    "Created: / 17-09-2012 / 21:13:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHandleFromExternalAddress: anExternalAddress
    | cls |

    cls := self getHandleClass.
    self setHandle: (self getHandleClass new setAddress: anExternalAddress address size: cls structSize)

    "Created: / 19-09-2012 / 01:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHandleFromOriginal: original
    "To be called only from #executor"
    handle := original getHandle

    "Created: / 19-09-2012 / 01:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHandleFromRef: aByteArray
    "Initalized a handle from a reference. The passed bytearray
     is supposed to contain a C pointer data to the underlaing
     C object"

    self assert: aByteArray isByteArray.
    self assert: aByteArray size == ExternalAddress pointerSize.
    self setHandle: (self getHandleClass newAddress: (aByteArray longAt: 1))

    "Created: / 17-09-2012 / 21:22:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitLibraryObject class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
