"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Smalltalk }"

DeviceHandle subclass:#CairoGraphicsContextHandle
	instanceVariableNames:'deviceHandle cr'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Compatibility'
!

!CairoGraphicsContextHandle class methodsFor:'documentation'!

documentation
"
    Strictly internal!! Instances of CairoGraphicsContextHandle are used as
    executors for CairoGraphicsContext - do not use!!

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CairoGraphicsContextHandle methodsFor:'accessing'!

parentId
    ^ deviceHandle parentId

    "Modified: / 17-07-2018 / 19:45:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextHandle methodsFor:'finalization'!

finalize
    "Called the view or pixmap for which I am a handle was collected - release system resources"

    Logger debug: 'Finalizing drawable %1#%2' with: deviceHandle id address with: deviceHandle id identityHash.
    cr notNil ifTrue:[
        | surfaceToDestroy crToDestroy |

        crToDestroy := cr.
        surfaceToDestroy := cr surface.
        cr := nil.
        crToDestroy release.
        surfaceToDestroy release.    
    ].
    deviceHandle notNil ifTrue:[ 
        | deviceHandleToDestpry |

        deviceHandleToDestpry := deviceHandle.
        deviceHandle := nil.
        deviceHandleToDestpry finalize.
    ].

    "Created: / 03-03-2016 / 23:21:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:58:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextHandle methodsFor:'private-accessing'!

setDevice:aDevice id:aDrawableId gcId:aGCId
    self shouldNeverBeSent

    "Created: / 03-03-2016 / 23:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDeviceHandle:deviceHandleArg cairo: crArg
    deviceHandle := deviceHandleArg.
    cr := crArg

    "Created: / 17-07-2018 / 19:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextHandle class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

