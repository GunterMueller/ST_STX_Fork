"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ExternalAddress subclass:#CObject
	instanceVariableNames:''
	classVariableNames:'Lobby'
	poolDictionaries:'Cairo::Status'
	category:'Cairo-Objects'
!


!CObject class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Lobby := Registry new

    "Modified: / 09-01-2015 / 11:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject class methodsFor:'instance creation'!

fromExternalAddress: anExternalAddress
    ^ self new fromExternalAddress: anExternalAddress

    "Created: / 24-12-2014 / 22:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-12-2014 / 10:33:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject methodsFor:'accessing'!

referenceCount
    "Return value or reference counter"

    ^ self subclassResponsibility

    "Created: / 09-09-2008 / 20:33:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:09:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."    

    ^ self subclassResponsibility

    "Created: / 23-02-2016 / 10:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject methodsFor:'finalization'!

executor

    ^self class basicNew
        setAddress: self address;
        yourself

    "Created: / 10-09-2008 / 18:57:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-12-2014 / 10:36:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalize
    Logger debug: '%1@%2 instance finalized' with: self address with: self referenceCount.
    self destroy

    "Created: / 09-09-2008 / 20:30:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-09-2008 / 18:45:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 21:39:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject methodsFor:'initialization & release'!

initialize
    | status |
    
    Logger debug: '%1@%2 instance created' with: self with: self referenceCount.
    self registerForFinalization.
    status := self status.
    status ~~ CAIRO_STATUS_SUCCESS ifTrue:[ 
        CError raiseWith: status errorString: 'Failed to create ', self class name
    ].

    "Created: / 23-02-2016 / 10:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:09:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    Logger debug: '%1@%2 instance released explicitly' with: self with: self referenceCount.
    self unregisterForFinalization.
    ^self destroy

    "Created: / 25-12-2014 / 10:34:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:09:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy, 
     this instance should be treated as invalid."

    ^ self subclassResponsibility

    "Created: / 28-12-2014 / 21:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.

     This method must be called whenever Cairo documentation says so, 
     check comment on return value for methods returning a Cairo object"

    ^ self subclassResponsibility

    "Created: / 05-03-2016 / 10:31:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

statusCheck
    <resource: #skipInDebuggersWalkBack>        

    | status |

    status := self status.
    status ~~ CAIRO_STATUS_SUCCESS ifTrue:[ 
        CError raiseWith: status errorString: 'Operation failed'.  
    ].

    "Created: / 21-02-2016 / 15:11:55 / jv"
    "Modified: / 23-02-2016 / 16:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CObject class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !


CObject initialize!
