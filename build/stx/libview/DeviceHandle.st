"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DeviceHandle
	instanceVariableNames:'device drawableId gcId'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!DeviceHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This is an abstract class for device handles which are responsible
    for finalization i.e. to destroy underlying system resources, when the GC
    frees an object which has created some system object.
    Currently, these are forms and views (streams, cursors, colors and
    fonts could also make use of this class - however, for historical reasons,
    they continue to use their own private finalization machanisms. This may
    change in future versions).

    [see also:]
        DeviceDrawable

    [author:]
        Claus Gittinger

"
! !

!DeviceHandle methodsFor:'accessing'!

device
    ^ device
!

id
    "return the id of the dravable"

    ^ drawableId

    "Modified: 20.3.1997 / 16:34:00 / cg"
! !

!DeviceHandle methodsFor:'finalization'!

finalize
    "I am abstract"

    self subclassResponsibility

    "Created: 2.4.1997 / 19:23:14 / cg"
! !

!DeviceHandle methodsFor:'private-accessing'!

setDevice:aDevice id:aDrawableId gcId:aGCId
    "set the handles contents"

    device := aDevice.
    drawableId := aDrawableId.
    gcId := aGCId

    "Modified: 23.4.1996 / 22:10:26 / cg"
! !

!DeviceHandle class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

