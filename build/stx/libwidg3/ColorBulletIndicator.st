"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

ImageView subclass:#ColorBulletIndicator
	instanceVariableNames:'images symbolicModel'
	classVariableNames:'RedStateImage YellowStateImage GreenStateImage'
	poolDictionaries:''
	category:'Views-Misc'
!

!ColorBulletIndicator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    Shows a colored bullet (like a led lamp).
    Xlates symbolic image names like #red/#green/#blue into a corresponding
    bullet image.

    [author:]
        Claus Gittinger (ps@joshua)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
                                                                [exBegin]
    |top aV model|

    model := #red asValue.

    top := StandardSystemView new.
    top extent:100@100.
    aV := ColorBulletIndicator origin:0@0 in:top.
    aV model:model.

    top open.
    5 timesRepeat:[
        Delay waitForSeconds:1.
        model value:#yellow.
        Delay waitForSeconds:1.
        model value:#green.
        Delay waitForSeconds:1.
        model value:#red.
    ].    
                                                                [exEnd]
"
! !

!ColorBulletIndicator class methodsFor:'class initialization'!

initializeSharedImages
    RedStateImage := Smalltalk imageFromFileNamed:'gifImages/red-ball.gif' forClass:self.
    YellowStateImage := Smalltalk imageFromFileNamed:'gifImages/yellow-ball.gif' forClass:self.
    GreenStateImage := Smalltalk imageFromFileNamed:'gifImages/green-ball.gif' forClass:self.

    "
     self initializeSharedImages
    "

    "Modified: / 11.2.2000 / 00:31:50 / cg"
! !

!ColorBulletIndicator methodsFor:'accessing'!

imagesAt:aSymbol put:anImage
    "define the image to be shown as per symbol"
    
    images at:aSymbol put:anImage
!

model:aModel
    "set the model, which is supposed to provide the boxes value.
     If a listMessage was defined, it is also responsible for providing
     the list"

    symbolicModel notNil ifTrue:[
        symbolicModel removeDependent:self
    ].
    symbolicModel := aModel.
    symbolicModel notNil ifTrue:[
        symbolicModel addDependent:self
    ].
    self getStateFromModel.
! !

!ColorBulletIndicator methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == symbolicModel ifTrue:[
        self getStateFromModel.
        ^ self. 
    ].
    super update:something with:aParameter from:changedObject
! !

!ColorBulletIndicator methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    images at:#red    put:((images at:#red) onDevice:device).
    images at:#yellow put:((images at:#yellow) onDevice:device).
    images at:#green  put:((images at:#green) onDevice:device).
!

initialize
    super initialize.

    images isNil ifTrue:[
        images := IdentityDictionary new.
    ].

    RedStateImage isNil ifTrue:[
        self class initializeSharedImages
    ].

    self imagesAt:#red    put:RedStateImage.
    self imagesAt:#yellow put:YellowStateImage.
    self imagesAt:#green  put:GreenStateImage.
! !

!ColorBulletIndicator methodsFor:'menu'!

middleButtonMenu
    ^ nil
! !

!ColorBulletIndicator methodsFor:'private'!

getStateFromModel
    |img|

    img := images at:(symbolicModel value) ifAbsent:nil.
    super image:img
! !

!ColorBulletIndicator methodsFor:'queries'!

preferredExtent
    preferredExtent notNil ifTrue:[^ preferredExtent].

    preferredExtent := (images at:#red) extent.
    ^ preferredExtent

! !

!ColorBulletIndicator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ColorBulletIndicator.st,v 1.9 2018-05-01 08:38:20 cg Exp $'
! !

