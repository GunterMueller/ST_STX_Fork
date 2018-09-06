"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

InspectorView subclass:#ImageInspectorView
	instanceVariableNames:'imageView'
	classVariableNames:'LastRatio LastExtent'
	poolDictionaries:''
	category:'Interface-Inspector'
!

!ImageInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    this class allows better inspection of images,
    by adding another subView, which displays the image.
"
! !

!ImageInspectorView class methodsFor:'defaults'!

defaultTopViewExtent
    |def|

    def := LastExtent ? self defaultExtent.
    ^ def min:(Screen current usableExtent)

    "Created: / 23-10-2007 / 18:58:18 / cg"
!

rememberLastExtent:anExtent
    LastExtent := anExtent

    "Created: / 23-10-2007 / 19:09:34 / cg"
! !

!ImageInspectorView class methodsFor:'menu specs'!

imageMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageInspectorView andSelector:#imageMenu
     (Menu new fromLiteralArrayEncoding:(ImageInspectorView imageMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasImage
            label: 'Edit'
            itemValue: menuEdit
          )
         (MenuItem
            enabled: filenameOfImageKnown
            label: 'File Browser'
            itemValue: menuFileBrowser
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Magnification...'
            itemValue: menuMagnification
          )
         (MenuItem
            label: 'Background'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'White'
                  itemValue: menuSetBackgroundColor:
                  argument: white
                )
               (MenuItem
                  label: 'Grey'
                  itemValue: menuSetBackgroundColor:
                  argument: grey
                )
               (MenuItem
                  label: 'Black'
                  itemValue: menuSetBackgroundColor:
                  argument: black
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Red'
                  itemValue: menuSetBackgroundColor:
                  argument: red
                )
               (MenuItem
                  label: 'Green'
                  itemValue: menuSetBackgroundColor:
                  argument: green
                )
               (MenuItem
                  label: 'Blue'
                  itemValue: menuSetBackgroundColor:
                  argument: blue
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
! !

!ImageInspectorView methodsFor:'accessing'!

inspect:anObject
    "set the object to be inspected"

    |scrollToBottom prevViewOrigin prevImageSize|

    prevViewOrigin := imageView viewOrigin.
    imageView image notNil ifTrue:[
        prevImageSize := imageView image extent.
    ].
    super inspect:anObject.
"/    imageView image:anObject.

    scrollToBottom := false.

"/    scrollToBottom :=
"/        anObject notNil
"/        and:[imageView image notNil 
"/        and:[ imageView viewOrigin y + imageView image height >= imageView height ]].

    imageView image:anObject scroll:scrollToBottom not invalidate:false.
    scrollToBottom ifTrue:[
        imageView 
            scrollTo:(0 @ ((anObject height - imageView height) max:0))
            redraw:false.
    ].
    imageView invalidate.

    "
     ImageInspectorView inspect:(Image fromScreen:(0@0 corner:800@800))
    "
! !

!ImageInspectorView methodsFor:'initialization'!

destroy
    |imageViewsSuperView|

    imageViewsSuperView := imageView superView.
    imageViewsSuperView notNil ifTrue:[
        LastRatio := 1.0 - 
                     (imageViewsSuperView relativeCorner y - imageViewsSuperView relativeOrigin y).
    ].
    super destroy

    "Created: / 07-09-1998 / 13:13:43 / cg"
    "Modified: / 23-10-2007 / 19:10:48 / cg"
!

initialize
    |v newPanel sub|

    super initialize.

    LastRatio isNil ifTrue:[
        LastRatio := 0.3
    ].

    newPanel := VariableVerticalPanel in:self.
    newPanel origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    newPanel snapMode:#both.

    "
     wrap my existing subview into the new
     variable panel
    "
    sub := self subViews first.
    self removeSubView:sub.
    sub origin:0.0@0.0 corner:1.0@LastRatio.
    newPanel addSubView:sub.

    v := HVScrollableView for:ImageView in:newPanel.
    v origin:(0.0 @ LastRatio) corner:(1.0 @ 1.0).
    imageView := v scrolledView.
    imageView menuHolder:self; menuMessage:#imageMenu; menuPerformer:self.

    LastExtent notNil ifTrue:[
        self extent:LastExtent
    ].

    "
     ImageInspectorView new realize
     ImageInspectorView inspect:(Image fromFile:'bitmaps/claus.gif')
    "

    "Modified: / 28-05-2007 / 15:15:32 / cg"
! !

!ImageInspectorView methodsFor:'menu'!

imageMenu
    ^ self class imageMenu

    "Created: / 28-05-2007 / 15:12:56 / cg"
!

menuEdit
    inspectedObject edit
!

menuFileBrowser
    UserPreferences fileBrowserClass
        openOn:inspectedObject fileName
!

menuMagnification
    |mag|

    mag := Dialog 
            request:'Magnify by:' 
            initialAnswer:1 
            list:#('0.5' '1' '2' '4' '8').
    mag := Number readFrom:mag onError:[nil].
    mag notNil ifTrue:[
        imageView image:(inspectedObject magnifiedBy:mag).
    ]

    "Created: / 28-05-2007 / 15:14:35 / cg"
    "Modified: / 30-10-2007 / 16:49:16 / cg"
!

menuSetBackgroundColor:colorNameSymbol
    imageView backgroundColor:(Color name:colorNameSymbol)
! !

!ImageInspectorView methodsFor:'queries'!

filenameOfImageKnown
    ^ [ inspectedObject isImage and:[inspectedObject fileName notNil] ]
!

hasImage
    "do we inspect an image and not a Form?"

    ^ inspectedObject isImage
!

labelFor:anObject
    |l fn|

    l := super labelFor:anObject.
    (anObject isImage and:[(fn := anObject fileName) notNil]) ifTrue:[
        l := l , ' (''' , fn asFilename baseName, ''')'
    ].
    ^ l

    "Modified: / 25-07-2012 / 12:53:13 / cg"
! !

!ImageInspectorView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ImageInspectorView.st,v 1.36 2014-10-23 11:15:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/ImageInspectorView.st,v 1.36 2014-10-23 11:15:46 cg Exp $'
! !

