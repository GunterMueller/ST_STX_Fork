"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

DeviceGraphicsContext subclass:#XGraphicsContext
	instanceVariableNames:'depth xftDrawId cairoSurfaceId'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Graphics'
!


!XGraphicsContext methodsFor:'accessing'!

depth
    ^ depth
!

xftDrawId
    ^ xftDrawId
!

xftDrawId:anXftDrawHandle
    xftDrawId := anXftDrawHandle.

    "Modified (format): / 23-06-2014 / 21:28:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XGraphicsContext methodsFor:'initialization & release'!

destroy
    xftDrawId notNil ifTrue:[ 
        | id |

	id := xftDrawId.
        xftDrawId := nil.
        XftFontDescription xftDrawDestroy: id.  
    ].
    super destroy.

    "Created: / 25-11-2016 / 00:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepareForReinit
    "kludge - clear drawableId and gcId
     needed after snapin"

    super prepareForReinit.
    xftDrawId := nil.
    cairoSurfaceId := nil.

    "Created: / 09-10-2014 / 00:02:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-12-2014 / 22:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XGraphicsContext methodsFor:'view creation'!

createBitmapFromArray:data width:width height:height
    depth := 1.
    super createBitmapFromArray:data width:width height:height
!

createPixmapWidth:w height:h depth:d
    depth := d.
    super createPixmapWidth:w height:h depth:d
! !

!XGraphicsContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

