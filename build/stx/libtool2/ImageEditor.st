"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ResourceSpecEditor subclass:#ImageEditor
	instanceVariableNames:'imageEditView colorMapMode editMode mouseKeyColorMode
		selectedColorIndex postOpenAction imageSeqNr drawingColormap
		lastShiftUsedWrap lastGrabbedScreenArea
		allowedToChangeImageDimensionAndDepth'
	classVariableNames:'LastDirectory LastSizeString MaskClipboard LastColormapMode
		DefaultRelativeSizes LastURL'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

!ImageEditor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Image Editor allows you to create, design, modify or just inspect images.

    [start with:]
        ImageEditor open
        ImageEditor openOnClass:Icon andSelector:#startIcon

    [see also:]
        ImageEditView Image

    [author:]
        Thomas Zwick, eXept Software AG
        Claus Gittinger, eXept Software AG
"
! !

!ImageEditor class methodsFor:'instance creation'!

openLoadingImageWith:aBlock modal:modalBoolean
    "opens an Image Editor on anImage"

    |editor|

    editor := self new.
    editor allButOpen.
    aBlock value:editor.
    modalBoolean ifTrue:[
        editor openWindowModal.
    ] ifFalse:[
        editor openWindow.
    ].
    ^ editor
!

openModalOnClass: aClass andSelector: aSelector
    "opens a modal Image Editor on aClass and aSelector.
     Returns the real name of the edited resource method (in case, user changed it)."

    |imageEditor imageEditView className resourceClass resourceSelector| 

    imageEditor := self new.

    aClass isClass  ifTrue: [className := aClass name].
    aClass isString ifTrue: [className := aClass].      
    aClass isNil    ifTrue: [className := ''].      

    imageEditor postOpenAction: [
            imageEditView := imageEditor imageEditView. 
            imageEditor loadFromOrPrepareForClass: aClass andSelector: aSelector
        ].
    imageEditor openModal.

    resourceClass := imageEditView resourceClass.
    resourceSelector := imageEditView resourceSelector.

    (resourceClass isNil or:[resourceSelector isNil]) ifTrue:[^ nil].
    ^ Array with:resourceClass with:resourceSelector

    "
     self openModalOnClass: self andSelector: #leftMouseKeyIcon
    "
!

openModalOnFile:aFileName
    "opens an Image Editor on aFileName"

    self openLoadingImageWith:[:editor | 
        editor loadFromFile:aFileName.
    ] modal:true.

    "
     self openModalOnFile: '../../goodies/bitmaps/gifImages/back.gif'
    "
!

openModalOnImage:anImage
    "opens a modal Image Editor on an image.
     Returns the modified image or nil if unsaved/unchanged"

    |imageEditor imageEditView newImage| 

    imageEditor := self new.
    imageEditor allowedToChangeImageDimensionAndDepth:false.
    imageEditor postOpenAction: [
            imageEditView := imageEditor imageEditView. 
            imageEditor loadFromImage: anImage
        ].
    imageEditor openModal.

    newImage := imageEditor savedImage.
    ^ newImage
!

openOnClass:aClass andSelector:aSelector
    "opens an Image Editor on aClass and aSelector"

    self openLoadingImageWith:[:editor | 
        editor loadFromClass:aClass theNonMetaclass andSelector:aSelector.
    ] modal:false.

    "
     self openOnClass:self andSelector:#leftMouseKeyIcon
     self openOnClass:self andSelector:nil
    "

    "Modified: / 16.3.1999 / 21:33:49 / cg"
!

openOnFile:aFileName
    "opens an Image Editor on aFileName"

    self openLoadingImageWith:[:editor | 
        editor loadFromFile:aFileName.
    ] modal:false.

    "
     self openOnFile: '../../goodies/bitmaps/gifImages/back.gif'
    "

    "Modified: / 16.3.1999 / 21:33:25 / cg"
!

openOnImage:anImage
    "opens an Image Editor on anImage"

    self openLoadingImageWith:[:editor | 
        editor loadFromImage: anImage.
    ] modal:false

    "
     self openOnImage: Icon startIcon
    "

    "Modified: / 11.3.1999 / 16:18:33 / cg"
! !

!ImageEditor class methodsFor:'accessing'!

listOfColorMaps
    "returns the list of default color maps for a new image"

    |colorMap|

    (colorMap := OrderedCollection new)
        add: Color black;
        add: Color white;
        add: Color red;
        add: Color green;
        add: Color blue;
        add: Color cyan;
        add: Color yellow;
        add: Color magenta;
        add: (Color redByte: 127 greenByte:   0 blueByte:   0);
        add: (Color redByte:   0 greenByte: 127 blueByte:   0);
        add: (Color redByte:   0 greenByte:   0 blueByte: 127);
        add: (Color redByte:   0 greenByte: 127 blueByte: 127);
        add: (Color redByte: 127 greenByte: 127 blueByte:   0);
        add: (Color redByte: 127 greenByte:   0 blueByte: 127);
        add: (Color redByte: 127 greenByte: 127 blueByte: 127);
        add: (Color redByte: 170 greenByte: 170 blueByte: 170).

    0 to: 5 do: [:r|                                                    
        0 to: 5 do: [:g|
            0 to: 5 do: [:b|
                colorMap add: (Color redByte: (r*255//5) ceiling greenByte: (g*255//5) ceiling blueByte: (b*255//5) ceiling)
            ]
        ]
    ].

    1 to: 25 do: [:g|                             
        colorMap add: (Color redByte: (g*255//26) ceiling greenByte: (g*255//26) ceiling blueByte: (g*255//26) ceiling)
    ].

    ^ Dictionary new
        at: #depth32 put:(FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF);
        at: #depth24 put:(FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF);
        at: #masked24 put:(FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF);
        at: #depth16 put:(FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F);
        at: #masked16 put:(FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F);
        at: #depth8  put: colorMap;
        at: #masked8 put: colorMap;
        at: #depth4  put: (colorMap copyFrom: 1 to: 16);
        at: #masked4 put: (colorMap copyFrom: 1 to: 16);
        at: #depth2  put: (colorMap copyFrom: 1 to: 4);
        at: #masked2 put: (colorMap copyFrom: 1 to: 4);
        at: #depth1  put: (colorMap copyFrom: 1 to: 2);
        at: #masked1 put: (colorMap copyFrom: 1 to: 2);
        yourself
!

listOfDefaultSizes
    "returns the list of default sizes for a new image"

    ^ #('8x8' '16x16' '22x22' '32x32' '48x48' '64x64')

    "Modified: / 31.7.1998 / 01:57:34 / cg"
!

namesOfColorMaps
    ^ Dictionary new
        at: #depth32 put: '32-plane (rgba)';
        at: #depth24 put: '24-plane';
        at: #masked24 put: '24-plane + mask';
        at: #depth16 put: '16-plane';
        at: #masked16 put: '16-plane + mask';
        at: #depth8  put: ' 8-plane';
        at: #masked8 put: ' 8-plane + mask';
        at: #depth4  put: ' 4-plane';
        at: #masked4 put: ' 4-plane + mask';
        at: #depth2  put: ' 2-plane';
        at: #masked2 put: ' 2-plane + mask';
        at: #depth1  put: ' 1-plane';
        at: #masked1 put: ' 1-plane + mask' ;
        yourself
! !

!ImageEditor class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:(self localHelpTexts)

    "Modified: / 19-01-2012 / 13:29:48 / cg"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ImageEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:(self localHelpTexts)

    "Modified: / 19-01-2012 / 13:29:42 / cg"
!

localHelpTexts
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ImageEditor    
    "

    <resource: #help>

    ^ #(

#xdrawModeBox
'Rectangle'

#xdrawModeCopy
'Copy'

#xdrawModeFill
'Flood-fill'

#xdrawModeFilledBox
'Filled rectangle'

#xdrawModePaste
'Paste'

#xdrawModePasteUnder
'Paste under'

#xdrawModePasteWithMask
'Paste with Mask'

#xdrawModePoint
'Point'

#xfileGrabImage
'Pick from screen'

#xfileLoadFromClass
'Load from method...'

#xfileLoadFromFile
'Load from file...'

#xfileNewImage
'New image'

#filePrint
'Print'

#xfileSaveAs
'Save to file...'

#xfileSaveMaskAs
'Save mask to file...'

#xfileSaveMethod
'Save as method'

#xfileSaveMethodAs
'Save as Method...'

#nextImageInSequence
'Go to the next image in the animated gif image sequence.'

#previousImageInSequence
'Go to the previous image in the animated gif image sequence.'

#colorMap
'ColorMap functions'

#colorMap1
'Convert to depth-1 image'

#colorMap1M
'Convert to depth-1 image plus mask'

#colorMap2
'Convert to depth-2 image'

#colorMap24
'Convert to depth-24 image (rgb)'

#colorMap2M
'Convert to depth-2 image plus mask'

#colorMap32
'Convert to depth-32 image (rgba)'

#colorMap4
'Convert to depth-4 image'

#colorMap4M
'Convert to depth-4 image plus mask'

#colorMap8
'Convert to depth-8 image'

#colorMap8M
'Convert to depth-8 image plus mask'

#colorMapTable
'Shows a list of used colors of the image'

#compressColormap
'Remove unneeded entries from the colorMap'

#cropAll
'Find and remove all borders'

#cropBottom
'Find and remove bottom border'

#cropLeft
'Find and remove left border'

#cropManual
'Specify border(s) to remove.'

#cropRight
'Find and remove right border'

#cropTop
'Find and remove top border'

#drawModeBox
'Rectangle Drawing Mode'

#drawModeCircle
'Circle Drawing Mode'

#drawModeCopy
'Area Copy Mode'

#drawModeFill
'Flood Fill Mode'

#drawModeFilledBox
'Filled Rectangle Drawing Mode'

#drawModePaste
'Paste Mode'

#drawModePasteUnder
'Paste-Under Mode'

#drawModePasteWithMask
'Paste-with-Mask Mode'

#drawModePoint
'Point Drawing Mode'

#drawModeSpecial
'Special operations (select rectangle, then choose operation)'

#drawModeSpray
'Spray Drawing Mode'

#editFlipHorizontal
'Flip the image horizontally'

#editFlipVertical
'Flip the image vertically'

#editMagnifyImage
'Magnify the image'

#editNegate
'Invert the images colors'

#editResize
'Resize the image (preserving the old image)'

#editRotate
'Rotate the image'

#fileGrabImageFromScreen
'Pick an image from the screen (specify area)'

#fileGrabImageFromWindow
'Pick an image from a window on the screen (click on window)'

#fileLoadFromClass
'Select and load an image from a resource method'

#fileLoadFromFile
'Select and load an image from a file'

#fileLoadFromURL
'Load an image from the net, given its URL'

#fileNewImage
'Create a new image'

#fileNewImageFromClipboard
'Create a new image and initialize it from the clipboard'

#fileNewMaskFromClipboard
'Paste the image in the clipboard as a mask. Must be a depth-1 image'

#filePrint
'Print the image on a postscript printer'

#fileSave
'Save the image'

#fileSaveAs
'Save the image to a file'

#fileSaveButtonImageAs
'Save an image of a button with the image to a file (for html use)'

#fileSaveMaskAs
'Save the mask of the image to a file'

#fileSaveMethod
'Save the image as resource method in the current class and selector'

#fileSaveMethodAs
'Save the image as resource method in a class'

#magnificationNumber
'Shows the current magnification'

#magnifyImageDown
'Decrease magnification'

#magnifyImageUp
'Increase magnification'

#mouseKeyColorMode
'Toggle between left and right mouse button color'

#previewView
'Shows a preview of the image'

#settingsGridMagnification
'Change the grid magnification of the edit view'

)

    "Created: / 19-01-2012 / 13:29:31 / cg"
! !

!ImageEditor class methodsFor:'image specs'!

circleIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self circleIcon inspect
     ImageEditor openOnClass:self andSelector:#circleIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class circleIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@A@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@N@CF@PDA@PH@  BB@HDA@PD@1 @8@@@@@a');
                            yourself);
                yourself
        ]
!

copyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self copyIcon inspect
     ImageEditor openOnClass:self andSelector:#copyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class copyIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@** @@J)UUTB*Z*)@*&**PJ)**$B*Z*)@*&**PJ)**$@@Z*)@@F**P@AUUT@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@C? O>@??3??O?<??3??O?<??3??@_<A?0@@@@a');
                            yourself);
                yourself
        ]
!

defaultIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary startImageEditorIcon
!

fillGradientRectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fillGradientRectIcon inspect
     ImageEditor openOnClass:self andSelector:#fillGradientRectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class fillGradientRectIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDQ@@@QDQDQDP@@BH"H"H"@@@"H"H"H @@L3L3L3L@@CL3L3L3@@@QDQDQDP@@DQDQDQD@@@@@@@@@
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 127 0 0 191 0 0 63 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0O?@?<C?0O?@?<C?0O?@?<C?0@@@@@@@a');
                            yourself);
                yourself
        ]
!

fillHorizontalGradientRectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fillHorizontalGradientRectIcon inspect
     ImageEditor openOnClass:self andSelector:#fillHorizontalGradientRectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class fillHorizontalGradientRectIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@DP"L1D@@@ADH#LQ@@@@QBH3DP@@@DP"L1D@@@ADH#LQ@@@@QBH3DP@@@DP"L1D@@@ADH#LQ@@@@QBH3DP@@@DP"L1D@@@@@@@@@
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 127 0 0 191 0 0 63 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0O?@?<C?0O?@?<C?0O?@?<C?0@@@@@@@a');
                            yourself);
                yourself
        ]
!

fillIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fillIcon inspect
     ImageEditor openOnClass:self andSelector:#fillIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class fillIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@ @@@@*H@@D*(@@DUUP@EAUU@AAEU@@@@U@@DDA@@@@@@@@PP@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'C @Q@BN@I<@?8C?0[?!!G<@O P\@@ D@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

fillRectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fillRectIcon inspect
     ImageEditor openOnClass:self andSelector:#fillRectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class fillRectIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@A@@@@@@@@@@@@@@@@@@@@@@@@@@D@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0O?@?<C?0O?@?<C?0O?@?<C?0@@@@@@@a');
                            yourself);
                yourself
        ]
!

fillVerticalGradientRectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fillGradientRectIcon inspect
     ImageEditor openOnClass:self andSelector:#fillGradientRectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class fillGradientRectIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ADQDQDQ@@@QDQDQDP@@BH"H"H"@@@"H"H"H @@L3L3L3L@@CL3L3L3@@@QDQDQDP@@DQDQDQD@@@@@@@@@
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 0 0 127 0 0 191 0 0 63 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0O?@?<C?0O?@?<C?0O?@?<C?0@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 19-01-2012 / 13:44:51 / cg"
!

flipHorizontalIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self flipHorizontalIcon inspect
     ImageEditor openOnClass:self andSelector:#flipHorizontalIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class flipHorizontalIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@A@C?8HP )JC$8_?1??C$8JR !!BC?8@P@@@@@a');
                            yourself);
                yourself
        ]
!

flipVerticalIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self flipVerticalIcon inspect
     ImageEditor openOnClass:self andSelector:#flipVerticalIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class flipVerticalIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@C@C?0I9@/4BLPH1A?>BLPH1@/4B^PO?@C@@@a');
                            yourself);
                yourself
        ]
!

leftMouseKeyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftMouseKeyIcon inspect
     ImageEditor openOnClass:self andSelector:#leftMouseKeyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class leftMouseKeyIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@EJJ@@AR" @@T((@@@@@@@B** @@**(@@J**@@B** @@**(@@J**@@@**@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@?0G? _>A?8G? _>A?8G? _>A?8G? O<@_ @@@b');
                            yourself);
                yourself
        ]
!

pasteIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pasteIcon inspect
     ImageEditor openOnClass:self andSelector:#pasteIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class pasteIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@AU@@@@@CHE@E@2@@@ QDQD@0@@L@@@@@H@@BL#H2L#@@@QDQDQL @@D3L@@@@@@AL3A&Y&X@@SL0Y A&@@D3LF@@A @AL3A&@FX@@QDPY&Y&
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 128 128 0 128 128 128 212 208 200 255 255 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'C0A?8O?0??C?<O?0??C?>O?8??#?>O?8_? G>@@a');
                            yourself);
                yourself
        ]
!

pasteUnderIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pasteUnderIcon inspect
     ImageEditor openOnClass:self andSelector:#pasteUnderIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class pasteUnderIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@AU@@@@@CHE@E@2@@@ QDQD@0@@L@@@@@H@@BL#H2L#@@@QDQDQL @@D3L3LP@@@AL3L3E&X@@SL3L0A&@@D3L3@@A @AL3L3@FX@@QDQDQY&
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 128 128 0 128 128 128 212 208 200 255 255 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'C0A?8O?0??C?<O?0??C?>O?8??#?>O?8_? G>@@a');
                            yourself);
                yourself
        ]
!

pasteWithMaskIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pasteWithMaskIcon inspect
     ImageEditor openOnClass:self andSelector:#pasteWithMaskIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class pasteWithMaskIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@AU@@@@@CHE@E@2@@@ QDQD@0@@L@@@@@H@@BL#H2L#@@@QDQDQL @@D3L@@@@@@AL3@3M&X@@SL0L3A&@@D3LCL0A @AL3@3LFX@@QDPY&Y&
@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 0 0 128 128 128 0 128 128 128 212 208 200 255 255 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'C0A?8O?0??C?<O?0??C?>O?8??#?>O?8_? G>@@a');
                            yourself);
                yourself
        ]
!

pointIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self pointIcon inspect
     ImageEditor openOnClass:self andSelector:#pointIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class pointIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@A@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@0@G@@8@G@@8@G@@8@G@@X@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

rectIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rectIcon inspect
     ImageEditor openOnClass:self andSelector:#rectIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class rectIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@A@@@@@@@@@@@@@@@C@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0HA@ DB@PHA@ DB@PHA@ DC?0@@@@@@@a');
                            yourself);
                yourself
        ]
!

rightMouseKeyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self rightMouseKeyIcon inspect
     ImageEditor openOnClass:self andSelector:#rightMouseKeyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class rightMouseKeyIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@JJE@@B"!!P@@((T@@@@@@@B** @@**(@@J**@@B** @@**(@@J**@@@**@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@?0G? _>A?8G? _>A?8G? _>A?8G? O<@_ @@@b');
                            yourself);
                yourself
        ]
!

smoothIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smoothIcon inspect
     ImageEditor openOnClass:self andSelector:#smoothIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'ImageEditor smoothIcon'
        ifAbsentPut:[(Depth4Image new) width:14; height:14; bits:(ByteArray fromPackedString:'@@@@@@@@@@@RH@@@H!!@@HRD@@RD @BHQ@@DRH@@ADP@ADP@@@@@QD@@@@@@@DQ@@@@@@@ADP@@@@@QD@@QD@@BHQ@@DRH@@!!HP@AHR@@D"@@@BHP@@@@@@@@
@@@@@@@@@@@b') ; colorMapFromArray:#[127 126 127 255 0 0 255 255 255]; mask:((ImageMask new) width:14; height:14; bits:(ByteArray fromPackedString:'_?1<_G1<_G1??D_DQ<QG1G?<_G1<_G1<_?0@@@@a') ; yourself); yourself]
!

specialCircleIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self specialCircleIcon inspect
     ImageEditor openOnClass:self andSelector:#specialCircleIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class specialCircleIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@L@@@!!BDB@ D4@HP@!!@BD@HHA@PHP!!@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@-@D2@''$D^HQ8!!G"DLHH1@PH@-@@0@@@@@a');
                            yourself);
                yourself
        ]
!

specialIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self specialIcon inspect
     ImageEditor openOnClass:self andSelector:#specialIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'ImageEditor class specialIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:14;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@L@@G!!:P@!!@B4@HP@!!@BD@HP@!!@BW!!8@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:14;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@G-8P0!!G"D^HQ8!!G"DLHP0!!@BG-8@0@@@@@a');
                            yourself);
                yourself
        ]
!

sprayIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sprayIcon inspect
     ImageEditor openOnClass:self andSelector:#sprayIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'ImageEditor sprayIcon'
        ifAbsentPut:[(Depth4Image new) width:14; height:14; bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@DA@P@@@@@PDA@@@@@@@PDA@@@@@@@PD@@@@"H@@PD@@@H"@@@@@@@ADP@@@@@@@QD@@@@@@@DQ@@@@@@@ADP@@
@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 0 0 255 255 255]; mask:((ImageMask new) width:14; height:14; bits:(ByteArray fromPackedString:'@@@@@@@HA%PF*@ITA2 O%@>@C8@O @>@C8@O @@a') ; yourself); yourself]
! !

!ImageEditor class methodsFor:'interface specs'!

changeHLSDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#changeHLSDialogSpec
     ImageEditor new openInterface:#changeHLSDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: changeHLSDialogSpec
        window: 
       (WindowSpec
          label: 'HLS Edit Dialog'
          name: 'HLS Edit Dialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 312 258)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Hue-Shift:'
              name: 'HueLabel'
              layout: (LayoutFrame 20 0 21 0 120 0 43 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'HueShiftEntryField'
              layout: (LayoutFrame 123 0 21 0 166 0 43 0)
              tabable: true
              model: hueShiftAmount
              type: numberInRange
              minValue: 0
              maxValue: 360
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ThumbWheelSpec
              name: 'HueWheel'
              layout: (LayoutFrame 180 0 22 0 297 0 42 0)
              model: hueShiftAmount
              orientation: horizontal
              step: 1
              endlessRotation: true
            )
           (LabelSpec
              label: 'Light Factor:'
              name: 'LightLabel'
              layout: (LayoutFrame 18 0 50 0 120 0 72 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'LightEntryField'
              layout: (LayoutFrame 123 0 50 0 166 0 72 0)
              tabable: true
              model: lightAmount
              type: numberInRange
              minValue: 0
              maxValue: 1000
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ThumbWheelSpec
              name: 'LightWheel'
              layout: (LayoutFrame 180 0 51 0 297 0 71 0)
              model: lightAmount
              orientation: horizontal
              stop: 1000
              step: 1
            )
           (LabelSpec
              label: 'Saturation Factor:'
              name: 'SaturationLabel'
              layout: (LayoutFrame 9 0 79 0 120 0 101 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'SaturationEntryField'
              layout: (LayoutFrame 123 0 79 0 166 0 101 0)
              tabable: true
              model: saturationAmount
              type: numberInRange
              minValue: 0
              maxValue: 1000
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ThumbWheelSpec
              name: 'SaturationWheel'
              layout: (LayoutFrame 180 0 80 0 297 0 100 0)
              model: saturationAmount
              orientation: horizontal
              stop: 1000
              step: 1
            )
           (LabelSpec
              label: 'Color Shift'
              name: 'Label2'
              layout: (LayoutFrame 5 0 110 0 -15 0.5 132 0)
              translateLabel: true
            )
           (LabelSpec
              name: 'HueColorLabel'
              layout: (LayoutFrame 18 0.0 133 0 -41 0.5 217 0)
              level: -1
              backgroundChannel: hlsColor
              translateLabel: true
            )
           (LabelSpec
              label: 'Preview'
              name: 'Label3'
              layout: (LayoutFrame 5 0.5 110 0 -5 1 132 0)
              translateLabel: true
            )
           (LabelSpec
              name: 'PreviewLabel'
              layout: (LayoutFrame 36 0.5 133 0 -23 1.0 217 0)
              level: -1
              translateLabel: true
              labelChannel: previewImageHolder
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 151 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    tabable: true
                    model: accept
                    extent: (Point 152 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

cropDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#cropDialogSpec
     ImageEditor new openInterface:#cropDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: cropDialogSpec
        window: 
       (WindowSpec
          label: 'Crop Border(s)'
          name: 'Crop Border(s)'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 259 229)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Left:'
              name: 'GropLeftLabel'
              layout: (LayoutFrame 14 0 21 0 90 0 43 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'GropLeftEntryField'
              layout: (LayoutFrame 95 0 21 0 132 0 43 0)
              tabable: true
              model: left
              type: number
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'Now'
              name: 'GropLeftNowButton'
              layout: (LayoutFrame 148 0 21 0 221 0 43 0)
              translateLabel: true
              tabable: true
              model: gropLeftNow
              autoRepeat: true
            )
           (LabelSpec
              label: 'Right:'
              name: 'GropRightLabel'
              layout: (LayoutFrame 14 0 51 0 90 0 73 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'GropRightEntryField'
              layout: (LayoutFrame 95 0 51 0 132 0 73 0)
              tabable: true
              model: right
              type: number
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'Now'
              name: 'GropRightButton'
              layout: (LayoutFrame 148 0 51 0 221 0 73 0)
              translateLabel: true
              tabable: true
              model: gropRightNow
              autoRepeat: true
            )
           (LabelSpec
              label: 'Top:'
              name: 'GropTopLabel'
              layout: (LayoutFrame 14 0 81 0 90 0 103 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'GropTopEntryField'
              layout: (LayoutFrame 95 0 81 0 132 0 103 0)
              tabable: true
              model: top
              type: number
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'Now'
              name: 'GropTopButton'
              layout: (LayoutFrame 148 0 81 0 221 0 103 0)
              translateLabel: true
              tabable: true
              model: gropTopNow
              autoRepeat: true
            )
           (LabelSpec
              label: 'Bottom:'
              name: 'GropBottomLabel'
              layout: (LayoutFrame 14 0 111 0 90 0 133 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'GropBottomEntryField'
              layout: (LayoutFrame 95 0 111 0 132 0 133 0)
              tabable: true
              model: bottom
              type: number
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (ActionButtonSpec
              label: 'Now'
              name: 'GropBottomButton'
              layout: (LayoutFrame 148 0 111 0 221 0 133 0)
              translateLabel: true
              tabable: true
              model: gropBottomNow
              autoRepeat: true
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 77 22)
                  )
                 (ActionButtonSpec
                    label: 'Apply'
                    name: 'Button3'
                    translateLabel: true
                    tabable: true
                    model: applyAction
                    extent: (Point 78 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    tabable: true
                    model: accept
                    extent: (Point 78 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

dialogSpecForNewImage
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#dialogSpecForNewImage
     ImageEditor new openInterface:#dialogSpecForNewImage
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpecForNewImage
        window: 
       (WindowSpec
          label: 'New Image'
          name: 'New Image'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 301 119)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'View'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -35 1.0)
              level: 1
              component: 
             (SpecCollection
                collection: (
                 (FramedBoxSpec
                    label: 'Size'
                    name: 'framedBox1'
                    layout: (LayoutFrame 1 0.0 7 0.0 0 0.4 76 0)
                    style: (FontDescription helvetica medium roman 12)
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (ComboBoxSpec
                          name: 'defaultSizesComboBox'
                          layout: (LayoutFrame 0 0.0 10 0.0 0 1 35 0.0)
                          model: selectionOfSize
                          type: string
                          acceptOnPointerLeave: false
                          comboList: listOfDefaultSizes
                          isFilenameBox: false
                        )
                       )
                     
                    )
                  )
                 (FramedBoxSpec
                    label: 'Color Map'
                    name: 'framedBox2'
                    layout: (LayoutFrame 0 0.4 7 0.0 -1 1.0 76 0)
                    style: (FontDescription helvetica medium roman 12)
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (ComboListSpec
                          name: 'colorMapComboBox'
                          layout: (LayoutFrame 0 0.0 10 0.0 0 1 35 0.0)
                          model: selectionOfColorMap
                          comboList: listOfColorMaps
                          useIndex: false
                          hidePullDownMenuButton: false
                        )
                       )
                     
                    )
                  )
                 )
               
              )
            )
           (UISubSpecification
              name: 'windowSpecForCommitWithoutChannels'
              layout: (LayoutFrame 2 0.0 -26 1 -2 1.0 -2 1.0)
              minorKey: windowSpecForCommitWithoutChannels
            )
           )
         
        )
      )
!

shiftDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#shiftDialogSpec
     ImageEditor new openInterface:#shiftDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: shiftDialogSpec
        window: 
       (WindowSpec
          label: 'Shift'
          name: 'Shift'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 259 229)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Amount:'
              name: 'AmountLabel'
              layout: (LayoutFrame 14 0 21 0 90 0 43 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'AmountEntryField'
              layout: (LayoutFrame 95 0 21 0 139 0 43 0)
              tabable: true
              model: shiftAmount
              type: number
              acceptChannel: acceptChannel
              acceptOnPointerLeave: false
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    tabable: true
                    model: cancel
                    extent: (Point 118 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    tabable: true
                    model: accept
                    extent: (Point 118 22)
                  )
                 )
               
              )
            )
           (ArrowButtonSpec
              name: 'upArrowButton'
              layout: (LayoutFrame 105 0 63 0 127 0 85 0)
              model: shiftUpNow
              isTriggerOnDown: true
              autoRepeat: true
              actionValue: ''
              direction: up
            )
           (ArrowButtonSpec
              name: 'leftArrowButton'
              layout: (LayoutFrame 84 0 86 0 106 0 108 0)
              model: shiftLeftNow
              isTriggerOnDown: true
              autoRepeat: true
              actionValue: ''
              direction: left
            )
           (ArrowButtonSpec
              name: 'rightArrowButton'
              layout: (LayoutFrame 126 0 86 0 148 0 108 0)
              model: shiftRightNow
              isTriggerOnDown: true
              autoRepeat: true
              actionValue: ''
              direction: right
            )
           (ArrowButtonSpec
              name: 'downArrowButton'
              layout: (LayoutFrame 105 0 107 0 127 0 129 0)
              model: shiftDownNow
              isTriggerOnDown: true
              autoRepeat: true
              actionValue: ''
              direction: down
            )
           (CheckBoxSpec
              label: 'Wrap'
              name: 'CheckBox1'
              layout: (LayoutFrame 153 0 22 0 289 0 44 0)
              model: wrap
              translateLabel: true
            )
           )
         
        )
      )
!

uncropDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#uncropDialogSpec
     ImageEditor new openInterface:#uncropDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: uncropDialogSpec
        window: 
       (WindowSpec
          label: 'Add Border(s)'
          name: 'Add Border(s)'
          min: (Point 10 10)
          max: (Point 800 478)
          bounds: (Rectangle 0 0 261 228)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Left:'
              name: 'Label1'
              layout: (LayoutFrame 14 0 21 0 90 0 43 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 95 0 21 0 132 0 43 0)
              model: left
              type: number
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Right:'
              name: 'Label2'
              layout: (LayoutFrame 14 0 51 0 90 0 73 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField2'
              layout: (LayoutFrame 95 0 51 0 132 0 73 0)
              model: right
              type: number
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Top:'
              name: 'Label3'
              layout: (LayoutFrame 14 0 81 0 90 0 103 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField3'
              layout: (LayoutFrame 95 0 81 0 132 0 103 0)
              model: top
              type: number
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Bottom:'
              name: 'Label4'
              layout: (LayoutFrame 14 0 111 0 90 0 133 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField4'
              layout: (LayoutFrame 95 0 111 0 132 0 133 0)
              model: bottom
              type: number
              acceptOnPointerLeave: false
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    model: cancel
                    extent: (Point 118 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    model: accept
                    extent: (Point 118 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ImageEditor andSelector:#windowSpec
     ImageEditor new openInterface:#windowSpec
     ImageEditor open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Image Editor'
         name: 'Image Editor'
         min: (Point 400 320)
         bounds: (Rectangle 0 0 450 350)
         menu: menu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'menuToolbarView'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
             style: (FontDescription helvetica medium roman 10)
             menu: menuToolbar
             showSeparatingLines: true
           )
          (VariableHorizontalPanelSpec
             name: 'mainPanel'
             layout: (LayoutFrame 0 0.0 34 0.0 0 1.0 -26 1.0)
             snapMode: both
             barLevel: 0
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'leftView'
                   level: 1
                   component: 
                  (SpecCollection
                     collection: (
                      (VariableVerticalPanelSpec
                         name: 'verticalPanel'
                         layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                         level: 0
                         snapMode: both
                         component: 
                        (SpecCollection
                           collection: (
                            (ViewSpec
                               name: 'View1'
                               component: 
                              (SpecCollection
                                 collection: (
                                  (MenuPanelSpec
                                     name: 'MouseButtonColorToolBar'
                                     layout: (LayoutFrame 0 0.0 0 0 0 1.0 24 0)
                                     level: 0
                                     menu: menuMouseButtonColors
                                   )
                                  (DataSetSpec
                                     name: 'colorDataSetView'
                                     layout: (LayoutFrame 0 0.0 26 0.0 0 1.0 0 1.0)
                                     activeHelpKey: colorMapTable
                                     style: (FontDescription helvetica medium roman 10)
                                     model: selectedColors
                                     menu: colorMapMenu
                                     hasHorizontalScrollBar: true
                                     hasVerticalScrollBar: true
                                     miniScrollerHorizontal: true
                                     miniScrollerVertical: true
                                     dataList: listOfColors
                                     has3Dseparators: true
                                     doubleClickSelector: doubleClickOnColor:
                                     columnHolder: colorTableColumns
                                     multipleSelectOk: true
                                     verticalSpacing: 1
                                     columnAdaptor: colorColumnAdaptor
                                   )
                                  )
                                
                               )
                             )
                            (ArbitraryComponentSpec
                               name: 'imagePreView'
                               activeHelpKey: previewView
                               menu: previewMenu
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               miniScrollerHorizontal: false
                               miniScrollerVertical: false
                               hasBorder: false
                               component: ImageView
                             )
                            )
                          
                         )
                         handles: (Any 0.5 1.0)
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'rightView'
                   component: 
                  (SpecCollection
                     collection: (
                      (MenuPanelSpec
                         name: 'ToolBar1'
                         layout: (LayoutFrame 0 0 0 0.0 28 0 0 1.0)
                         level: 1
                         menu: toolsMenuToolbar
                         verticalLayout: true
                         centerItems: true
                         textDefault: true
                       )
                      (ViewSpec
                         name: 'editingView'
                         layout: (LayoutFrame 28 0.0 0 0.0 0 1.0 0 1.0)
                         level: 1
                         component: 
                        (SpecCollection
                           collection: (
                            (ArbitraryComponentSpec
                               name: 'imageEditView'
                               layout: (LayoutFrame 2 0.0 2 0.0 -2 1.0 -24 1.0)
                               hasHorizontalScrollBar: true
                               hasVerticalScrollBar: true
                               hasBorder: false
                               component: ImageEditView
                             )
                            (LabelSpec
                               name: 'coordLabel'
                               layout: (LayoutFrame 2 0.0 -22 1 -83 1.0 0 1.0)
                               level: -1
                               translateLabel: true
                               labelChannel: imageInfoHolder
                               resizeForLabel: false
                               adjust: left
                             )
                            (ArrowButtonSpec
                               name: 'magnifyDownButton'
                               layout: (LayoutFrame -80 1 -22 1 -58 1 0 1)
                               activeHelpKey: magnifyImageDown
                               translateLabel: true
                               model: doMagnifyDown
                               enableChannel: imageIsLoadedHolder
                               isTriggerOnDown: true
                               direction: left
                             )
                            (ArrowButtonSpec
                               name: 'magnifyUpButton'
                               layout: (LayoutFrame -24 1 -22 1 -2 1 0 1)
                               activeHelpKey: magnifyImageUp
                               translateLabel: true
                               model: doMagnifyUp
                               enableChannel: imageIsLoadedHolder
                               isTriggerOnDown: true
                               direction: right
                             )
                            (InputFieldSpec
                               name: 'magnificationInputField'
                               layout: (LayoutFrame -57 1 -22 1 -26 1 0 1)
                               activeHelpKey: magnificationNumber
                               enableChannel: imageIsLoadedHolder
                               model: magnificationHolder
                               type: numberInRange
                               acceptOnReturn: true
                               acceptOnTab: true
                               numChars: 2
                               minValue: 1
                               maxValue: 99
                               acceptOnPointerLeave: true
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.28888900000000006 1.0)
           )
          (UISubSpecification
             name: 'infoBarSubSpec'
             layout: (LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
             majorKey: ToolApplicationModel
             minorKey: windowSpecForInfoBar
           )
          )
        
       )
     )
! !

!ImageEditor class methodsFor:'menu specs'!

colorMapMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#colorMapMenu
     (Menu new fromLiteralArrayEncoding:(ImageEditor colorMapMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasColormapHolder
            label: 'Add Color'
            itemValue: addColorToColormap
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapHolder
            label: 'Pick and Add Color...'
            itemValue: pickAndAddColorToColormap
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasColormapAndSingleColorSelected
            label: 'Cut Color'
            itemValue: cutColorFromColormap
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            enabled: hasSingleColorSelectedHolder
            label: 'Copy Color'
            itemValue: copyColorFromColormap
            translateLabel: true
            shortcutKey: Copy
          )
         (MenuItem
            enabled: hasColormapAndSingleColorSelected
            label: 'Pick and Paste Color...'
            itemValue: pickAndPasteColor
            translateLabel: true
          )
         (MenuItem
            label: 'Paste Color'
            itemValue: pasteColorIntoColormap
            translateLabel: true
            shortcutKey: Paste
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasColormapAndSingleColorSelected
            label: 'Edit Color...'
            itemValue: editSelectedColor
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapAndColorSelected
            label: 'Brighter'
            itemValue: makeSelectedColorBrighter
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapAndColorSelected
            label: 'Darker'
            itemValue: makeSelectedColorDarker
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapAndColorSelected
            label: 'Make Gray'
            itemValue: makeSelectedColorGray
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapAndColorSelected
            label: 'Color Shift'
            itemValue: makeSelectedColorShifted
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSingleColorSelectedHolder
            label: 'Inspect Color'
            itemValue: inspectColor
            translateLabel: true
          )
         (MenuItem
            enabled: hasColormapHolder
            label: 'Inspect Colormap'
            itemValue: inspectColormap
            translateLabel: true
          )
         )
        nil
        nil
      )
!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(ImageEditor menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: '&File'
            translateLabel: true
            submenuChannel: menuFile
            "/ keepLinkedMenu: true
          )
         (MenuItem
            label: 'Edit'
            translateLabel: true
            submenuChannel: menuEdit
            "/ keepLinkedMenu: true
          )
         (MenuItem
            label: 'Mode'
            translateLabel: true
            submenuChannel: modeMenu
          )
         (MenuItem
            label: 'Colors'
            translateLabel: true
            submenuChannel: menuColors
          )
         (MenuItem
            label: 'Settings'
            translateLabel: true
            submenuChannel: menuSettings
          )
         (MenuItem
            label: 'History'
            translateLabel: true
            isVisible: isStandAlone
            submenuChannel: menuHistory
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
            submenuChannel: menuHelp
          )
         )
        nil
        nil
      )
!

menuColors
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuColors
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuColors)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Depth'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: colorMap1
                  label: '1-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth1
                  choice: colorMapMode
                  choiceValue: depth1
                )
               (MenuItem
                  activeHelpKey: colorMap1M
                  label: '1-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked1
                  choice: colorMapMode
                  choiceValue: masked1
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap2
                  label: '2-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth2
                  choice: colorMapMode
                  choiceValue: depth2
                )
               (MenuItem
                  activeHelpKey: colorMap2M
                  label: '2-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked2
                  choice: colorMapMode
                  choiceValue: masked2
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap4
                  label: '4-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth4
                  choice: colorMapMode
                  choiceValue: depth4
                )
               (MenuItem
                  activeHelpKey: colorMap4M
                  label: '4-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked4
                  choice: colorMapMode
                  choiceValue: masked4
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap8
                  label: '8-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth8
                  choice: colorMapMode
                  choiceValue: depth8
                )
               (MenuItem
                  activeHelpKey: colorMap8M
                  label: '8-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked8
                  choice: colorMapMode
                  choiceValue: masked8
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap16
                  label: '16-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth16
                  choice: colorMapMode
                  choiceValue: depth16
                )
               (MenuItem
                  activeHelpKey: colorMap16M
                  label: '16-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked16
                  choice: colorMapMode
                  choiceValue: masked16
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap24
                  label: '24-Plane'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth24
                  choice: colorMapMode
                  choiceValue: depth24
                )
               (MenuItem
                  activeHelpKey: colorMap24M
                  label: '24-Plane + Mask'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: masked24
                  choice: colorMapMode
                  choiceValue: masked24
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: colorMap32
                  label: '32-Plane (rgba)'
                  itemValue: colorMapMode:
                  translateLabel: true
                  argument: depth32
                  choice: colorMapMode
                  choiceValue: depth32
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'ColorMap'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: compressColormap
                  enabled: hasColormapHolder
                  label: 'Compress Colormap'
                  itemValue: #'menu_compressColorMap'
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasColormapHolder
                  label: 'Sort Colormap'
                  itemValue: #'menu_sortColorMap'
                  translateLabel: true
                )
               (MenuItem
                  label: 'Reduce Number of Colors by Rounding...'
                  itemValue: reduceNumberOfColors2
                  translateLabel: true
                )
               (MenuItem
                  label: 'Reduce Number of Colors by Masking Bits...'
                  itemValue: reduceNumberOfColors
                  translateLabel: true
                )
               (MenuItem
                  label: 'Dither to Depth...'
                  itemValue: ditherToDepth
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: imageIsLoadedHolder
                  label: 'Brighten'
                  itemValue: doBrightenImage
                  translateLabel: true
                )
               (MenuItem
                  enabled: imageIsLoadedHolder
                  label: 'Darken'
                  itemValue: doDarkenImage
                  translateLabel: true
                )
               (MenuItem
                  enabled: imageIsLoadedHolder
                  label: 'Invert'
                  itemValue: doNegativeImage
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Process'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Make GrayScale'
                  itemValue: makeGrayScaleImage
                  translateLabel: true
                )
               (MenuItem
                  enabled: allowedToChangeImageDimensionAndDepth
                  label: 'Make dithered 8Bit Palette'
                  itemValue: makeDitheredPaletteImage
                  translateLabel: true
                  isVisible: false
                )
               (MenuItem
                  label: 'Make Inverse'
                  itemValue: makeInverse
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Make Slightly Brighter'
                  itemValue: makeSlightlyBrighter
                  translateLabel: true
                )
               (MenuItem
                  label: 'Make Slightly Darker'
                  itemValue: makeSlightlyDarker
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Make Brighter'
                  itemValue: makeBrighter
                  translateLabel: true
                )
               (MenuItem
                  label: 'Make Darker'
                  itemValue: makeDarker
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Change HLS...'
                  itemValue: changeHLS
                  translateLabel: true
                )
               (MenuItem
                  label: 'Colorize...'
                  itemValue: colorize
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Mask'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: copyMask
                  enabled: hasMask
                  label: 'Copy Mask'
                  itemValue: #'menu_copyMask'
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: pasteMask
                  enabled: hasMask
                  label: 'Paste Mask'
                  itemValue: #'menu_pasteMask'
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMask
                  label: 'Clear Masked Pixels'
                  itemValue: #'menu_clearMaskedPixels'
                  translateLabel: true
                )
               (MenuItem
                  enabled: hasMask
                  label: 'Clear Colormap Entry for Masked Pixels'
                  itemValue: #'menu_clearColormapEntry0AndMaskedPixels'
                  translateLabel: true
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
!

menuEdit
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuEdit
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuEdit)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: editUndo
            enabled: canUndoHolder
            label: 'Undo'
            itemValue: doUndo
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Copy to Clipboard'
            itemValue: doCopyImageToClipboard
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editResize
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Resize...'
            itemValue: doResizeImage
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: editMagnifyImage
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Magnify...'
            itemValue: doMagnifyImage
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: editMagnifyImage
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Magnify By...'
            itemValue: doMagnifyImageBy
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: editRotate
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Rotate...'
            itemValue: doRotateImage
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: edit3DProjection
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: '3D Projection...'
            itemValue: do3DProjection
            translateLabel: true
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Flip'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: editFlipVertical
                  enabled: imageIsLoadedHolder
                  label: 'Flip - Vertical'
                  itemValue: doFlipVertical
                  translateLabel: true
                  labelImage: (ResourceRetriever ImageEditor flipVerticalIcon 'Flip - Vertical')
                )
               (MenuItem
                  activeHelpKey: editFlipHorizontal
                  enabled: imageIsLoadedHolder
                  label: 'Flip - Horizontal'
                  itemValue: doFlipHorizontal
                  translateLabel: true
                  labelImage: (ResourceRetriever ImageEditor flipHorizontalIcon 'Flip - Horizontal')
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Crop'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: cropManual
                  label: 'Manual...'
                  itemValue: doCropManual
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: cropAll
                  label: 'All'
                  itemValue: doCropAll
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: cropLeft
                  label: 'Left'
                  itemValue: doCropLeft
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: cropRight
                  label: 'Right'
                  itemValue: doCropRight
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: cropTop
                  label: 'Top'
                  itemValue: doCropTop
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: cropBottom
                  label: 'Bottom'
                  itemValue: doCropBottom
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            activeHelpKey: uncropManual
            enabled: imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
            label: 'Uncrop (Add Border)...'
            itemValue: doUnCropManual
            translateLabel: true
          )
         (MenuItem
            activeHelpKey: shiftManual
            enabled: imageIsLoadedHolder
            label: 'Shift...'
            itemValue: doShiftManual
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileEditMask
            enabled: imageIsLoadedHolder
            label: 'Edit Mask'
            itemValue: doEditMask
            translateLabel: true
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Text...'
            itemValue: doInsertTextFromUser
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Animation Sequence'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: imageHasNextImageHolder
                  label: 'Next in Sequence'
                  itemValue: nextImageInSequence
                  translateLabel: true
                )
               (MenuItem
                  enabled: imageHasPreviousImageHolder
                  label: 'Previous in Sequence'
                  itemValue: previousImageInSequence
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: imageHasImageSequenceHolder
                  label: 'Edit each from Sequence'
                  itemValue: editEachImageFromSequence
                  translateLabel: true
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
!

menuFile
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuFile
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuFile)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileNewImageEditor
            label: 'New ImageEditor'
            itemValue: doNewImageEditor
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileNewImage
            label: 'New...'
            itemValue: doNewImage
          )
         (MenuItem
            activeHelpKey: fileNewImageFromClipboard
            label: 'New from ClipBoard'
            itemValue: doNewImageFromClipboard
          )
         (MenuItem
            activeHelpKey: fileNewMaskFromClipboard
            label: 'Mask from ClipBoard'
            itemValue: doNewMaskFromClipboard
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileLoadFromClass
            label: 'Load...'
            itemValue: doLoadFromClass
          )
         (MenuItem
            activeHelpKey: fileLoadFromFile
            label: 'Load from File...'
            itemValue: doLoadFromFile
          )
         (MenuItem
            activeHelpKey: fileLoadFromURL
            label: 'Load from URL...'
            itemValue: doLoadFromURL
          )
         (MenuItem
            label: 'Grab'
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: fileGrabImageFromScreen
                  label: 'Grab from Screen Area...'
                  itemValue: grabScreenImage
                )
               (MenuItem
                  activeHelpKey: fileGrabImageFromScreen
                  enabled: hasLastGrabScreenArea
                  label: 'Grab again from same Screen Area'
                  itemValue: grabScreenImageFromLastArea
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileGrabImageFromWindow
                  label: 'Grab from Window...'
                  itemValue: grabWindowImage
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileSaveMethod
            enabled: imageIsLoadedAndClassDefined
            label: 'Save'
            itemValue: doSaveMethod
          )
         (MenuItem
            activeHelpKey: fileSaveMethodAs
            enabled: imageIsLoadedHolder
            label: 'Save As...'
            itemValue: doSaveMethodAs
          )
         (MenuItem
            activeHelpKey: fileSaveAs
            enabled: imageIsLoadedHolder
            label: 'Save to File...'
            itemValue: doSaveImageFileAs
          )
         (MenuItem
            activeHelpKey: fileSaveMaskAs
            enabled: imageIsLoadedHolder
            label: 'Save Mask to File...'
            itemValue: doSaveImageMaskFileAs
          )
         (MenuItem
            activeHelpKey: fileSaveButtonImageAs
            enabled: imageIsLoadedHolder
            label: 'Save as Button to File...'
            itemValue: doSaveButtonImageToFileAs
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: filePrint
            enabled: imageIsLoadedHolder
            label: 'Print'
            itemValue: doPrint
          )
         (MenuItem
            label: '-'
            isVisible: isStandAlone
          )
         (MenuItem
            activeHelpKey: fileBrowseClass
            enabled: hasClassDefinedHolder
            label: 'Browse Class'
            itemValue: doBrowseClass
            isVisible: isStandAlone
          )
         (MenuItem
            enabled: imageIsLoadedHolder
            label: 'Inspect Image'
            itemValue: doInspectImage
            isVisible: isStandAlone
          )
         (MenuItem
            activeHelpKey: fileShowStoreString
            enabled: imageIsLoadedHolder
            label: 'Show storeString'
            itemValue: doShowStoreString
          )
         (MenuItem
            activeHelpKey: fileShowStoreString
            enabled: imageIsLoadedHolder
            label: 'Show Pixel Array Literal String'
            itemValue: doShowPixelArrayLiteralString
          )
         (MenuItem
            label: '-'
            isVisible: isStandAlone
          )
         (MenuItem
            activeHelpKey: fileExit
            label: 'Exit'
            itemValue: closeRequest
            isVisible: isStandAlone
          )
         )
        nil
        nil
      )
!

menuMouseButtonColors
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuMouseButtonColors
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuMouseButtonColors)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Left Mouse Button'
                #nameKey: #leftMouseKeyButton
                #activeHelpKey: #mouseKeyColorMode
                #enabled: #imageIsLoadedHolder
                #labelImage: #(#ResourceRetriever nil #leftMouseKeyIcon)
                #choice: #mouseKeyColorMode
                #choiceValue: 1
            )
             #(#MenuItem
                #label: 'Right Mouse Button'
                #nameKey: #rightMouseKeyButton
                #activeHelpKey: #mouseKeyColorMode
                #enabled: #imageIsLoadedHolder
                #labelImage: #(#ResourceRetriever nil #rightMouseKeyIcon)
                #choice: #mouseKeyColorMode
                #choiceValue: 2
            )
          ) nil
          nil
      )

    "Modified: / 04-07-2010 / 10:17:37 / cg"
!

menuSettings
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuSettings
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuSettings)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: settingsGridMagnification
            label: 'Grid Magnification Limit...'
            itemValue: doChangeGridMagnification
            translateLabel: true
          )
         (MenuItem
            label: 'Pen'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: '1'
                  translateLabel: true
                  choice: penWidthHolder
                  choiceValue: 1
                )
               (MenuItem
                  label: '5'
                  translateLabel: true
                  choice: penWidthHolder
                  choiceValue: 5
                )
               (MenuItem
                  label: '10'
                  translateLabel: true
                  choice: penWidthHolder
                  choiceValue: 10
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Spray'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: '4'
                  translateLabel: true
                  choice: spraySpotHolder
                  choiceValue: 4
                )
               (MenuItem
                  label: '8'
                  translateLabel: true
                  choice: spraySpotHolder
                  choiceValue: 8
                )
               (MenuItem
                  label: '16'
                  translateLabel: true
                  choice: spraySpotHolder
                  choiceValue: 16
                )
               (MenuItem
                  label: '32'
                  translateLabel: true
                  choice: spraySpotHolder
                  choiceValue: 32
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
!

menuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageEditor andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(ImageEditor menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileNewImage
            label: 'newImage'
            itemValue: doNewImage
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary newImageIcon)
          )
         (MenuItem
            activeHelpKey: fileGrabImageFromScreen
            label: 'grabScreenImage'
            itemValue: grabScreenImage
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary snapshot24x24Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileLoadFromClass
            label: 'loadFromClass'
            itemValue: doLoadFromClass
            translateLabel: true
            isButton: true
            isVisible: isStandAlone
            submenuChannel: menuHistory
            labelImage: (ResourceRetriever XPToolbarIconLibrary loadImageFromMethodIcon)
            keepLinkedMenu: true
          )
         (MenuItem
            activeHelpKey: fileSaveMethodAs
            enabled: imageIsLoadedHolder
            label: 'fileSaveMethodAs'
            itemValue: doSaveMethodAs
            translateLabel: true
            isButton: true
            isVisible: isStandAlone
            labelImage: (ResourceRetriever XPToolbarIconLibrary saveImageAsMethodAsIcon)
          )
         (MenuItem
            activeHelpKey: fileSaveMethod
            enabled: imageIsLoadedHolder
            label: 'saveAsMethod'
            itemValue: doSaveMethod
            translateLabel: true
            isButton: true
            isVisible: isNotStandAlone
            labelImage: (ResourceRetriever ToolbarIconLibrary saveImageAsMethodIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: fileLoadFromFile
            label: 'loadFromFile'
            itemValue: doLoadFromFile
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary loadImageFromFileIcon)
          )
         (MenuItem
            activeHelpKey: fileSaveAs
            enabled: imageIsLoadedHolder
            label: 'saveAsFile'
            itemValue: doSaveImageFileAs
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveImageToFileAsIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: editUndo
            enabled: canUndoHolder
            label: 'Undo'
            itemValue: doUndo
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary undoIcon)
          )
         (MenuItem
            label: '-'
            isVisible: imageHasImageSequenceHolder
          )
         (MenuItem
            activeHelpKey: previousImageInSequence
            enabled: imageHasPreviousImageHolder
            label: 'Previous Image'
            itemValue: previousImageInSequence
            translateLabel: true
            isVisible: imageHasImageSequenceHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary leftArrow24x24Icon)
          )
         (MenuItem
            activeHelpKey: nextImageInSequence
            enabled: imageHasNextImageHolder
            label: 'Next Image'
            itemValue: nextImageInSequence
            translateLabel: true
            isVisible: imageHasImageSequenceHolder
            labelImage: (ResourceRetriever ToolbarIconLibrary rightArrow24x24Icon)
          )
         )
        nil
        nil
      )
!

modeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#modeMenu
     (Menu new fromLiteralArrayEncoding:(ImageEditor modeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: drawModePoint
            enabled: imageIsLoadedHolder
            label: 'Point'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor pointIcon 'Point')
            choice: editMode
            choiceValue: point
          )
         (MenuItem
            activeHelpKey: drawModePoint
            enabled: imageIsLoadedHolder
            label: 'Spray'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor sprayIcon 'Spray')
            choice: editMode
            choiceValue: spray
          )
         (MenuItem
            activeHelpKey: drawModeSmooth
            enabled: imageIsLoadedHolder
            label: 'Smooth'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor smoothIcon 'Smooth')
            choice: editMode
            choiceValue: smooth
          )
         (MenuItem
            activeHelpKey: drawModeBox
            enabled: imageIsLoadedHolder
            label: 'Rect'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor rectIcon 'Rect')
            choice: editMode
            choiceValue: box
          )
         (MenuItem
            activeHelpKey: drawModeFilledBox
            enabled: imageIsLoadedHolder
            label: 'Filled Rectangle'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor fillRectIcon 'Filled Rectangle')
            choice: editMode
            choiceValue: filledBox
          )
         (MenuItem
            activeHelpKey: drawModeBox
            enabled: imageIsLoadedHolder
            label: 'Circle'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor circleIcon 'Circle')
            choice: editMode
            choiceValue: circle
          )
         (MenuItem
            activeHelpKey: drawModeFill
            enabled: imageIsLoadedHolder
            label: 'Fill'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor fillIcon 'Fill')
            choice: editMode
            choiceValue: fill
          )
         (MenuItem
            activeHelpKey: drawModeCopy
            enabled: imageIsLoadedHolder
            label: 'Copy'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor copyIcon 'Copy')
            choice: editMode
            choiceValue: copy
          )
         (MenuItem
            activeHelpKey: drawModePaste
            enabled: imageIsLoadedHolder
            label: 'Paste'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor pasteIcon 'Paste')
            choice: editMode
            choiceValue: paste
          )
         (MenuItem
            activeHelpKey: drawModePasteUnder
            enabled: imageIsLoadedHolder
            label: 'Paste Under'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor pasteUnderIcon 'Paste Under')
            choice: editMode
            choiceValue: pasteUnder
          )
         (MenuItem
            activeHelpKey: drawModePasteWithMask
            enabled: imageIsLoadedHolder
            label: 'Paste with Mask'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor pasteWithMaskIcon 'Paste with Mask')
            choice: editMode
            choiceValue: pasteWithMask
          )
         (MenuItem
            activeHelpKey: drawModeSpecial
            enabled: imageIsLoadedHolder
            label: 'Special'
            translateLabel: true
            labelImage: (ResourceRetriever ImageEditor specialIcon 'Special')
            choice: editMode
            choiceValue: specialOperation
          )
         )
        nil
        nil
      )

    "Modified: / 04-07-2010 / 10:18:08 / cg"
!

previewMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ImageEditor andSelector:#previewMenu
     (Menu new fromLiteralArrayEncoding:(ImageEditor previewMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'TileMode'
            translateLabel: true
            indication: tileModeHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Background Color'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Gray'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: nil
                )
               (MenuItem
                  label: 'Black'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: black
                )
               (MenuItem
                  label: 'White'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: white
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Red'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: red
                )
               (MenuItem
                  label: 'Green'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: green
                )
               (MenuItem
                  label: 'Blue'
                  translateLabel: true
                  choice: previewBackgroundColorHolder
                  choiceValue: blue
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

    "Modified: / 04-07-2010 / 10:20:09 / cg"
!

toolsMenuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ImageEditor andSelector:#toolsMenuToolbar
     (Menu new fromLiteralArrayEncoding:(ImageEditor toolsMenuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: drawModePoint
            enabled: imageIsLoadedHolder
            label: 'Point'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor pointIcon)
            choice: editMode
            choiceValue: point
          )
         (MenuItem
            activeHelpKey: drawModeSpray
            enabled: imageIsLoadedHolder
            label: 'Spray'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor sprayIcon)
            choice: editMode
            choiceValue: spray
          )
         (MenuItem
            activeHelpKey: drawModeBox
            enabled: imageIsLoadedHolder
            label: 'Rect'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor rectIcon)
            choice: editMode
            choiceValue: box
          )
         (MenuItem
            activeHelpKey: drawModeFilledBox
            enabled: imageIsLoadedHolder
            label: 'FillRect'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor fillRectIcon)
            choice: editMode
            choiceValue: filledBox
          )
         (MenuItem
            activeHelpKey: drawModeCircle
            enabled: imageIsLoadedHolder
            label: 'Circle'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor circleIcon)
            choice: editMode
            choiceValue: circle
          )
         (MenuItem
            activeHelpKey: drawModeFill
            enabled: imageIsLoadedHolder
            label: 'Fill'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor fillIcon)
            choice: editMode
            choiceValue: fill
          )
         (MenuItem
            activeHelpKey: drawModeCopy
            enabled: imageIsLoadedHolder
            label: 'Copy'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor copyIcon)
            choice: editMode
            choiceValue: copy
          )
         (MenuItem
            activeHelpKey: drawModePasteWithMask
            enabled: imageIsLoadedHolder
            label: 'Paste With Mask'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor pasteWithMaskIcon)
            choice: editMode
            choiceValue: pasteWithMask
          )
         (MenuItem
            activeHelpKey: drawModePaste
            enabled: imageIsLoadedHolder
            label: 'Paste'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor pasteIcon)
            choice: editMode
            choiceValue: paste
          )
         (MenuItem
            activeHelpKey: drawModePasteUnder
            enabled: imageIsLoadedHolder
            label: 'Paste Under'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor pasteUnderIcon)
            choice: editMode
            choiceValue: pasteUnder
          )
         (MenuItem
            activeHelpKey: drawModeSpecial
            enabled: imageIsLoadedHolder
            label: 'Special'
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever ImageEditor specialIcon)
            choice: editMode
            choiceValue: specialOperation
          )
         )
        nil
        nil
      )
! !

!ImageEditor class methodsFor:'tableColumns specs'!

colorTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ImageEditor andSelector:#colorTableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         activeHelpKey: ''
         labelButtonType: Button
         rendererType: rowSelector
         backgroundSelector: theColorItself:
         selectedBackgroundSelector: theColorItself:
         isResizeable: false
       )
      (DataSetColumnSpec
         label: 'R'
         labelAlignment: left
         labelButtonType: Button
         columnAlignment: right
         editorType: InputField
         type: number
         model: redFromColor:
         writeSelector: redAtColor:put:
         selectSelector: canSelectRedInColor:
       )
      (DataSetColumnSpec
         label: 'G'
         labelAlignment: left
         labelButtonType: Button
         columnAlignment: right
         editorType: InputField
         type: number
         model: greenFromColor:
         writeSelector: greenAtColor:put:
         selectSelector: canSelectGreenInColor:
       )
      (DataSetColumnSpec
         label: 'B'
         labelAlignment: left
         labelButtonType: Button
         columnAlignment: right
         editorType: InputField
         type: number
         model: blueFromColor:
         writeSelector: blueAtColor:put:
         selectSelector: canSelectBlueInColor:
       )
      )

    "Modified: / 22-07-2007 / 13:21:57 / cg"
! !

!ImageEditor methodsFor:'accessing'!

image
    "returns the current editing image"

    ^ imageEditView image
!

postOpenAction: anAction
   "sets an action which is evaluated after opening"

    postOpenAction := anAction
!

resourceClass:aClass
    imageEditView resourceClass:aClass
! !

!ImageEditor methodsFor:'accessing-behavior'!

allowedToChangeImageDimensionAndDepth
    "used to edit an existing image's contents only (Expecco)"

    ^ allowedToChangeImageDimensionAndDepth ? true
!

allowedToChangeImageDimensionAndDepth:aBoolean
    "used to edit an existing image's contents only (Expecco)"

    allowedToChangeImageDimensionAndDepth := aBoolean
! !

!ImageEditor methodsFor:'accessing-views'!

colorDataSetView
    "returns the view of the colormap"

    ^(self componentAt: #colorDataSetView)

    "Created: / 26.7.1998 / 12:02:14 / cg"
!

coordLabel
    "returns the view the coord label"

    ^self componentAt: #coordLabel
!

imageEditView
    "returns the view of the image"

    imageEditView isNil ifTrue:[
        imageEditView := (self componentAt: #imageEditView) scrolledView.
        imageEditView addDependent:self.
    ].
    ^ imageEditView

    "Modified: / 10.2.2000 / 23:19:20 / cg"
!

imagePreView
    "returns the preview of the image"

    |imagePreViewSubViews|

    imagePreViewSubViews := (self componentAt: #imagePreView) subViews.

    "subViews is an empty array at closing image Editor"
    imagePreViewSubViews isEmptyOrNil ifTrue:[
        ^ nil
    ].

    ^ imagePreViewSubViews first 
! !

!ImageEditor methodsFor:'aspects'!

activityInfoHolder
    ^ self infoLabelHolder

    "Modified: / 29.7.1998 / 18:49:03 / cg"
!

colorColumnAdaptor
    ^ self

    "Created: / 26.7.1998 / 12:17:03 / cg"
!

hasClassAndSelectorDefinedHolder
    ^ [
        |cls|

        (cls := imageEditView resourceClass) notNil
        and:[imageEditView resourceSelector notNil]
      ]

    "Created: / 04-07-2010 / 10:11:10 / cg"
!

hasClassDefinedHolder
    ^ [
        imageEditView resourceClass notNil
      ]

    "Created: / 04-07-2010 / 10:11:47 / cg"
!

hasColorSelectedHolder
    ^ [ self selectedColors value notEmptyOrNil "self selectedColorIndexOrNil notNil" ]

    "Created: / 04-07-2010 / 10:12:22 / cg"
!

hasColormap
    ^ self image notNil and:[self image colorMap notNil]

    "Created: / 30-09-1998 / 23:53:55 / cg"
    "Modified: / 04-07-2010 / 10:13:26 / cg"
!

hasColormapAndColorSelected
    ^ [ self hasColormapHolder value and:[self hasColorSelectedHolder value]]

    "Modified: / 04-07-2010 / 10:13:13 / cg"
!

hasColormapAndSingleColorSelected
    ^ [ self hasColormapHolder value and:[self hasSingleColorSelectedHolder value]]

    "Modified: / 04-07-2010 / 10:13:13 / cg"
!

hasColormapHolder
    ^ [self hasColormap]

    "Created: / 04-07-2010 / 10:13:05 / cg"
!

hasSingleColorSelectedHolder
    ^ [ self selectedColors value size == 1 "self selectedColorIndexOrNil notNil" ]

    "Created: / 04-07-2010 / 10:12:22 / cg"
!

imageHasImageSequence
    |img|

    ^ (img := self image) notNil and:[img imageSequence notNil]

    "Created: / 21-10-2010 / 14:35:45 / cg"
!

imageHasImageSequenceHolder
    |holder|

    (holder := builder bindingAt:#imageHasImageSequenceHolder) isNil ifTrue:[
        builder aspectAt:#imageHasImageSequenceHolder put:(holder := false asValue).
        holder value:(self imageHasImageSequence).    
    ].
    ^ holder

    "Modified: / 21-10-2010 / 14:36:57 / cg"
!

imageHasNextImage
    ^ self imageHasImageSequence and:[ (imageSeqNr ? 1) < self image imageSequence size ]

    "Created: / 21-10-2010 / 14:37:10 / cg"
!

imageHasNextImageHolder
    |holder|

    (holder := builder bindingAt:#imageHasNextImageHolder) isNil ifTrue:[
        builder aspectAt:#imageHasNextImageHolder put:(holder := false asValue).
        holder value:(self imageHasNextImage).    
    ].
    ^ holder

    "Modified: / 21-10-2010 / 14:37:40 / cg"
!

imageHasPreviousImage
    ^ self imageHasImageSequence and:[ (imageSeqNr ? 1) > 1 ]

    "Created: / 21-10-2010 / 14:37:21 / cg"
!

imageHasPreviousImageHolder
    |holder|

    (holder := builder bindingAt:#imageHasPreviousImageHolder) isNil ifTrue:[
        builder aspectAt:#imageHasPreviousImageHolder put:(holder := false asValue).
        holder value:(self imageHasPreviousImage).    
    ].
    ^ holder

    "Modified: / 21-10-2010 / 14:37:48 / cg"
!

imageInfoHolder
    |holder|

    (holder := builder bindingAt:#imageInfoHolder) isNil ifTrue:[
        builder aspectAt:#imageInfoHolder put:(holder :=  '' asValue).
    ].
    ^ holder

    "Modified: / 04-07-2010 / 10:15:14 / cg"
!

imageIsLoadedAndAllowedToChangeImageDimensionAndDepth
    "returns whether an image is loaded as value holder"

    ^ [ 
        self imageIsLoadedHolder value
        and:[ self allowedToChangeImageDimensionAndDepth ] 
      ]

    "Modified: / 04-07-2010 / 10:15:43 / cg"
!

imageIsLoadedAndClassDefined
    "returns whether an image is loaded as value holder"

    ^ [self hasClassAndSelectorDefinedHolder value
       and:[self imageIsLoadedHolder value]]

    "Created: / 31-07-1998 / 02:04:18 / cg"
    "Modified: / 04-07-2010 / 10:15:48 / cg"
!

imageIsLoadedHolder
    "returns whether an image is loaded as value holder"

    |holder|

    (holder := builder bindingAt:#imageIsLoaded) isNil ifTrue:[
        builder aspectAt:#imageIsLoaded put:(holder :=  false asValue).
    ].
    ^ holder

    "Created: / 04-07-2010 / 10:15:38 / cg"
!

listOfColors
    "returns the list of colors"

    |list|

    (list := builder bindingAt:#listOfColors) isNil ifTrue:[
        builder aspectAt:#listOfColors put:(list :=  List new).
        list addDependent:self.
    ].
    ^ list
!

magnificationHolder
    "returns current magnification of the image as an AspectAdaptor"

    |holder|
    (holder := builder bindingAt:#valueOfMagnification) isNil ifTrue:[
        builder aspectAt:#valueOfMagnification put:(
        holder := AspectAdaptor new subject:self; forAspect:#magnification)
    ].
    ^ holder
!

penWidthHolder
    |holder|

    (holder := builder bindingAt:#penWidthHolder) isNil ifTrue:[
        builder aspectAt:#penWidthHolder put:(holder := imageEditView penWidth asValue).
        holder onChangeSend:#penWidthHolderChanged to:self.
    ].
    ^ holder

    "Created: / 15-02-2012 / 22:30:58 / cg"
!

previewBackgroundColorHolder
    |holder|

    (holder := builder bindingAt:#previewBackgroundColor) isNil ifTrue:[
        builder aspectAt:#previewBackgroundColor put:(holder := nil asValue).
        holder addDependent:self.
    ].
    ^ holder

    "Created: / 04-07-2010 / 10:19:34 / cg"
!

selectedColors
    "returns a valueHolder for the current set of selected colors."

    |holder|

    (holder := builder bindingAt:#selectedColors) isNil ifTrue:[
        builder aspectAt:#selectedColors put:(holder := nil asValue).
        holder onChangeSend:#selectedColorsChanged to:self.
    ].
    ^ holder
!

selectionOfColor
    "returns a valueHolder for the current selection of the edit color.
     Here, an AspectAdaptor which accesses selectedColorIndex is returned."

    |holder|

    (holder := builder bindingAt:#selectionOfColor) isNil ifTrue:[
        builder aspectAt:#selectionOfColor put:(
        holder := AspectAdaptor new subject:self; forAspect:#selectedColorIndex ).
    ].
    ^ holder
!

spraySpotHolder
    |holder|

    (holder := builder bindingAt:#spraySpotHolder) isNil ifTrue:[
        builder aspectAt:#spraySpotHolder put:(holder := imageEditView spraySpot asValue).
        holder onChangeSend:#spraySpotHolderChanged to:self.
    ].
    ^ holder

    "Created: / 15-02-2012 / 22:36:38 / cg"
!

tileModeHolder
    |holder|

    (holder := builder bindingAt:#tileModeHolder) isNil ifTrue:[
        builder aspectAt:#tileModeHolder put:(holder := false asValue).
        holder addDependent:self.
    ].
    ^ holder

    "Modified: / 21-10-2010 / 14:35:24 / cg"
!

valueOfMagnification
    <resource: #obsolete>
    "returns current magnification of the image as an AspectAdaptor"

    self obsoleteMethodWarning:'stupid method name - use #magnificationHolder'.
    ^ self magnificationHolder
! !

!ImageEditor methodsFor:'change & update'!

findColorMapMode
    "finds the colorMapMode for a new image"

    |image newListOfColors colorMapModeKey drawColor1 drawColor2 someOrAllUsedColors|

    image := self image.
    image isNil ifTrue:[^ self ].

    image mask notNil ifTrue: [             
        colorMapModeKey := 'masked'.
    ] ifFalse:[
        colorMapModeKey := 'depth'.
    ].
    colorMapModeKey := colorMapModeKey , image depth printString.
    self colorMapMode setValue:colorMapModeKey.

    image photometric == #palette ifTrue:[
        image colorMap isNil ifTrue:[
            image depth > 16 ifTrue:[
                image photometric:#rgb
            ].
        ].
    ].

    image depth > 12 ifTrue:[
        newListOfColors := OrderedCollection new.
        (image depth > 16 or:[image colorMap isEmptyOrNil]) ifTrue:[
            someOrAllUsedColors := image usedColorsMax:10000.
            someOrAllUsedColors notNil ifTrue:[
                someOrAllUsedColors := someOrAllUsedColors asArray.
                someOrAllUsedColors sort:self sortBlockForColors.
                newListOfColors addAll:someOrAllUsedColors.
                "/ listOfColors add:Color black; add:Color white.
            ].
            image mask notNil ifTrue:[
                newListOfColors := (Array with:(Color noColor)),newListOfColors.
            ].
        ] ifFalse:[
            newListOfColors addAll:(image colorMap).
        ].
    ] ifFalse:[
        newListOfColors := OrderedCollection withAll:(self listOfColors).
        newListOfColors isEmpty ifTrue:[   
            self colorMapMode: colorMapMode value.
            image := self image.
        ].                               
        "/ image mask notNil ifTrue:[
        "/     newListOfColors := (Array with:(Color noColor)),newListOfColors.
        "/ ].
    ].  
    newListOfColors notEmptyOrNil ifTrue:[
        drawColor1 := newListOfColors at:1.
        drawColor2 := newListOfColors at:2 ifAbsent:drawColor1.

        self hasMask ifTrue: [             
            (newListOfColors includes:(Color colorId:0)) ifFalse:[
                newListOfColors addFirst:(Color colorId:0).
                drawColor1 := newListOfColors at:2. 
                drawColor2 := newListOfColors at:3 ifAbsent:drawColor1.
            ]
        ].
"/        imageEditView drawingColors:(Array with: drawColor1 with: drawColor2).
"/        self selectionOfColor 
"/            setValue: 0;
"/            value: (listOfColors indexOf: imageEditView selectedColor).
    ].
    self listOfColors asOrderedCollection ~= newListOfColors ifTrue:[
        self listOfColors contents:newListOfColors.
    ].

    "Modified: / 06-12-2016 / 12:51:36 / cg"
!

selectedColorsChanged
    |colorIndices|

    (colorIndices := self selectedColors value) isEmptyOrNil ifTrue:[
        self selectionOfColor value:nil
    ] ifFalse:[
        colorIndices size == 1 ifTrue:[
            "/ as single color selected
            self selectionOfColor value:colorIndices first
        ] ifFalse:[
            "/ multipl selected
            self selectionOfColor value:nil
        ].
    ].
!

update:something with:aParameter from:changedObject
    |clrIndex img imagePreView clr changedColor|

    img := self image.
    imagePreView := self imagePreView.

    changedObject == self tileModeHolder ifTrue:[
        imagePreView 
            tileMode:(changedObject value) tileOffset:(img extent);
            clear; 
            invalidate.
        ^ self
    ].
    changedObject == self previewBackgroundColorHolder ifTrue:[
        clr := changedObject value isNil 
                    ifTrue:[imageEditView viewBackground]
                    ifFalse:[Color perform:changedObject value].
        imagePreView 
            viewBackground:clr;
            clear; 
            invalidate.
        ^ self
    ].

    changedObject == self listOfColors ifTrue:[
        something == #at: ifTrue:[
            "/ colormap entry changed at aParameter

            clrIndex := aParameter.
            (self hasMask) ifTrue:[
                clrIndex := clrIndex - 1.
            ].
            changedColor := changedObject at:aParameter.
            img colorMap notNil ifTrue:[
                img colorMap at:clrIndex put:changedColor.
                self colorMapChanged.
            ] ifFalse:[
                drawingColormap notNil ifTrue:[
                    drawingColormap at:clrIndex put:changedColor.
                ].
            ].
            ^ self
        ].
        ^ self
    ].

    changedObject == imageEditView undoImages ifTrue:[
        self canUndoHolder value:(changedObject notEmpty).
        ^ self.
    ].

    changedObject == imageEditView ifTrue:[
        something == #imageColors ifTrue:[
            self updateListOfColorsAndColormapMode.
            ^ self.
        ].
        something == #image ifTrue:[
            self updateAfterImageChange.
            imagePreView image:img scroll:false.
            self updateListOfColorsAndColormapMode.
            self tileModeHolder value ifTrue:[
                imagePreView tileMode:true tileOffset:(img extent).
            ].
            ^ self.
        ].
        something == #subImageIn ifTrue:[
            imagePreView image ~~ img ifTrue:[
                self error:'internal error' mayProceed:true.
            ].
            self tileModeHolder value ifTrue:[
                imagePreView invalidate.
            ] ifFalse:[
                imagePreView invalidate:aParameter.
            ].
            ^ self.
        ].
        something == #selectedColor ifTrue:[
            (aParameter isNil or:[aParameter = (Color colorId:0)]) ifTrue:[
                "/ no color/mask */
                "/ self halt.
                clrIndex := self hasMask ifTrue:[1] ifFalse:[0].
            ] ifFalse:[
                clrIndex := self listOfColors indexOf:aParameter.
            ].
            self selectedColors value:{clrIndex}. "/ selectionOfColor value:clrIndex.
            ^ self.
        ].
        ^ self.
    ].

    changedObject == imageEditView modifiedHolder ifTrue:[
        "/ self halt:'to be implemented'.
        ^ self
    ].

    changedObject == imageEditView image ifTrue:[
        "/ self halt:'to be implemented'.
        self updateAfterImageChange.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 21-10-2010 / 14:34:31 / cg"
!

updateAfterImageChange
    |img|

    (img := self image) notNil ifTrue:[
        img := img onDevice:device.
        self updateColorsFromImage:img.
        self findColorMapMode.
        self updateLabelsAndHistory.

        imageSeqNr isNil ifTrue:[
            imageSeqNr := 1
        ].
        self imageHasImageSequenceHolder value:(self imageHasImageSequence).
        self imageHasNextImageHolder value:(self imageHasNextImage).
        self imageHasPreviousImageHolder value:(self imageHasPreviousImage).
    ] ifFalse:[
        self updateForNoImage
    ]

    "Modified: / 21-10-2010 / 14:40:45 / cg"
!

updateColorsFromImage:image
    |colors|

    image depth > 16 ifTrue:[
        self listOfColors contents:#().
        ^ self.
    ].

    colors := image colorMap.
    colors isNil ifTrue:[
        Error handle:[:ex |
            colors := OrderedCollection new.
        ] do:[
            colors := image usedColors asSet.
        ].
    ].
    self listOfColors contents:(colors asOrderedCollection).

    "Modified: / 18-01-2012 / 13:57:43 / cg"
!

updateForNoImage
    "updates channels and view, if image is loaded"

    self imageIsLoadedHolder value: false.
    self listOfColors removeAll.
    self imagePreView image: nil.
    self imageHasImageSequenceHolder value:false.

    "Modified: / 21-10-2010 / 14:39:13 / cg"
!

updateLabelsAndHistory
    "updates labels and history, if something has changed"

    |image|

    image := self image.

    self imageIsLoadedHolder value: image notNil.
    image isNil ifTrue: [^nil].

    self updateInfoLabel.

    imageEditView resourceClass notNil ifTrue:[
        imageEditView resourceSelector notNil ifTrue:[
            self addHistoryEntryForClass:imageEditView resourceClass selector:imageEditView resourceSelector.
        ]
    ].

    image fileName notNil ifTrue: [
        self addHistoryEntryForFile:image fileName.
    ].

    "Modified: / 04-07-2010 / 10:16:02 / cg"
!

updateListOfColorsAndColormapMode
    |selectedColor colorMap image|

    selectedColor := self selectedColorOrNil.

    image := self image.
    image isNil ifTrue:[
        self listOfColors removeAll.
    ] ifFalse:[
        colorMap := image colorMap.
        colorMap notNil ifTrue:[
            (colorMap size <= 4096) ifTrue:[
                image mask notNil ifTrue:[
                    colorMap := (Array with:(Color noColor)),colorMap.
                ].
                self listOfColors contents:colorMap.
            ] ifFalse:[
                self listOfColors removeAll.
                colorMap isFixedPalette ifTrue:[
                    image colorMap:nil.
                    image photometric:#rgb.
                    image samplesPerPixel:3.
                    
                    image bitsPerSample:(Array 
                                            with:(colorMap bitsRed)
                                            with:(colorMap bitsGreen)
                                            with:(colorMap bitsBlue)).
                ].
            ]
        ].
    ].
    self findColorMapMode.
    selectedColor notNil ifTrue:[
        self selectColor:selectedColor.
    ].
! !

!ImageEditor methodsFor:'data access'!

atColor:anOldColor put:newColor
    "a color changed to a new color"

    |index list oldColor image newImage oldSel|

    list  := self listOfColors.
    index := list identityIndexOf:anOldColor.

    oldSel := self selectionOfColor value.
    index ~~ 0 ifTrue:[
        oldColor := list at:index.
        list at:index put:newColor
    ] ifFalse:[
        self error:'internal error' mayProceed:true.
        list add:newColor
    ].

    image := self image.
    (image colorMap isNil 
    and:[drawingColormap isNil]) ifTrue:[
        oldColor notNil ifTrue:[
            imageEditView makeUndo.
            newImage := image copy.
            newImage
                colorsFromX:0 y:0 toX:(image width-1) y:(image height-1) 
                do:[:x :y :clr |
                    |newClr|

                    newClr := (clr = oldColor) ifTrue:[newColor] ifFalse:[clr].
                    newImage colorAtX:x y:y put:newClr
                ].
            imageEditView image:newImage.
            imageEditView setModified.
            self updateImage.
            self updateImagePreView.

            self selectedColors value:{oldSel}.
            imageEditView selectedColorIndex:oldSel.
            imageEditView selectedColor:(self listOfColors at:oldSel).
        ]
    ].
!

blueAtColor:aColor put:newBlue
    "helper used to return a new row element, when blue is changed"

    |byte|

    aColor isNil ifTrue:[^ self].       "/ mask cannot be changed
    byte := newBlue clampBetween:0 and:255.
    byte = aColor blueByte ifTrue:[^ self ].

    self atColor:aColor
             put:(Color redByte:(aColor redByte) greenByte:(aColor greenByte) blueByte:byte).
!

blueFromColor:aColor
    "helper used to access a color as a row in the dataSet view"

    aColor isNil ifTrue:[^ 'none'].
    ^ aColor blueByte ? 'mask'

    "Created: / 26.7.1998 / 12:30:35 / cg"
    "Modified: / 31.7.1998 / 01:11:18 / cg"
!

canSelectBlueInColor:aColor
    ^ aColor blueByte notNil

    "Created: / 7.8.1998 / 22:50:34 / cg"
    "Modified: / 7.8.1998 / 22:52:57 / cg"
!

canSelectGreenInColor:aColor
    ^ aColor greenByte notNil

    "Created: / 7.8.1998 / 22:50:22 / cg"
    "Modified: / 7.8.1998 / 22:52:46 / cg"
!

canSelectRedInColor:aColor
    ^ aColor redByte notNil

    "Created: / 7.8.1998 / 22:50:00 / cg"
    "Modified: / 7.8.1998 / 22:51:03 / cg"
!

greenAtColor:aColor put:newGreen
    "helper used to return a new row element, when green is changed"

    |byte|

    aColor isNil ifTrue:[^ self].       "/ mask cannot be changed
    byte := newGreen clampBetween:0 and:255.
    byte = aColor greenByte ifTrue:[^ self].

    self atColor:aColor
             put:(Color redByte:(aColor redByte) greenByte:byte blueByte:(aColor blueByte)).
!

greenFromColor:aColor
    "helper used to access a color as a row in the dataSet view"

    aColor isNil ifTrue:[^ 'none'].
    ^ aColor greenByte ? 'mask'

    "Created: / 26.7.1998 / 12:30:29 / cg"
    "Modified: / 31.7.1998 / 01:11:31 / cg"
!

redAtColor:aColor put:newRed
    "helper used to return a new row element, when red is changed"

    |byte|

    aColor isNil ifTrue:[^ self].       "/ mask cannot be changed
    byte := newRed clampBetween:0 and:255.
    byte = aColor redByte ifTrue:[^ self].

    self atColor:aColor
             put:(Color redByte:byte greenByte:(aColor greenByte) blueByte:(aColor blueByte)).
!

redFromColor:aColor
    "helper used to access a color as a row in the dataSet view"

    aColor isNil ifTrue:[^ 'none'].
    ^ aColor redByte ? 'mask'

    "Modified: / 31.7.1998 / 01:11:35 / cg"
!

theColorItself:aColor
    "an accessor for the table-column"

    ^ aColor
! !

!ImageEditor methodsFor:'defaults'!

aboutIcon
    ^ self class defaultIcon
! !

!ImageEditor methodsFor:'drag & drop'!

canDropObjects:aCollectionOfDropObjects in:aWidget
    ^ (aCollectionOfDropObjects size == 1) 
      and:[ aCollectionOfDropObjects 
                contains:[:dropObject | dropObject isFileObject]]
!

dropObjects:aCollectionOfDropObjects in:aWidget at:position
    |dropObject|

    dropObject := aCollectionOfDropObjects first.
    dropObject isFileObject ifTrue:[
        self loadFromFile:dropObject asFilename.
    ]
! !

!ImageEditor methodsFor:'event handling'!

processEvent:anEvent
    "Return true, if I have eaten the event"

    <resource: #keyboard (#Paste #Copy )>

    |view focusView p transformation|

    view := anEvent view.
    view notNil ifTrue:[
        view == self imagePreView ifTrue:[
            ((anEvent isButtonPressEvent and:[ anEvent button == 1 ])
            or:[ anEvent isButtonMotionEvent and:[ anEvent hasButton1 ]])  ifTrue:[
                p := anEvent x @ anEvent y.
                (transformation := view transformation) notNil ifTrue:[
                    p := transformation applyInverseTo:p.
                ].
                self imageEditView scrollToMakeVisible:p.    
                ^ true.
            ].
        ].

        anEvent isKeyPressEvent ifTrue:[
            focusView := view windowGroup focusView ? view.
            (focusView isComponentOf:(builder componentAt:#colorDataSetView)) ifTrue:[
                anEvent key == #Paste ifTrue:[
                    self pasteColorIntoColormap.
                    ^ true.
                ].
                anEvent key == #Copy ifTrue:[
                    self copyColorFromColormap.
                    ^ true.
                ].
            ].
        ].
    ].
    ^ false.

    "Modified: / 04-04-2011 / 13:50:09 / cg"
! !

!ImageEditor methodsFor:'help'!

defaultInfoLabel
    "returns the text shown in the info label, when the mouse is NOT over
     some widget with a help text."

    |resourceClass resourceSelector|

    resourceClass := imageEditView resourceClass.
    resourceClass notNil ifTrue:[
        resourceSelector := imageEditView resourceSelector.
        resourceSelector notNil ifTrue:[
            ^ resourceClass name, ' >> ', resourceSelector
        ].
    ].
    ^ 'No class and selector defined.'
!

openDocumentation
    "opens the documentation file of the Image Editor"

    self openHTMLDocument: 'tools/uipainter/ImageEditor.html'

! !

!ImageEditor methodsFor:'loading'!

loadFromClass:aClass andSelector:aSelector
    "loads an image from the method specified by class and selector"

    self assert:(aClass isNil or:[aClass isClass]).

    (aClass isNil or:[aSelector isNil]) ifTrue:[
        imageEditView resourceClass:aClass.
        imageEditView resourceSelector:aSelector.
        imageEditView image:nil.
        self clearModified.
        ^ self.
    ].

"/    (imageEditView resourceClass == aClass
"/    and:[ imageEditView resourceSelector == aSelector ]) ifTrue:[
"/        imageEditView modified ifFalse:[
"/            ^ self.
"/        ].
"/    ].

    (imageEditView loadFromClass:aClass andSelector:aSelector) notNil ifTrue:[
        self updateAfterImageChange.
        self clearModified.
    ]

    "Modified: / 16.3.1999 / 21:44:41 / cg"
!

loadFromFile:aFileName
    "loads an image from aFileName and sets up color map list and other info labels"

    self withCursor:Cursor wait do:[
        (imageEditView loadFromFile: aFileName) notNil ifTrue:[
            self updateAfterImageChange
        ]
    ]

    "Modified: / 16.3.1999 / 21:44:26 / cg"
!

loadFromImage:anImage
    "loads an image from anImage and sets up color map list and other info labels"

    |img|

    anImage notNil ifTrue:[    
        img := anImage onDevice:device.
    ].

    imageEditView image:img.
    imageEditView clearModified.

    self updateAfterImageChange.
"/    img notNil ifTrue:[    
"/        self updateColorsFromImage:img.
"/        self findColorMapMode.
"/        self updateLabelsAndHistory.
"/    ] ifFalse:[
"/        self updateForNoImage
"/    ]

    "Modified: / 16.3.1999 / 21:43:56 / cg"
!

loadFromOrPrepareForClass: aClass andSelector: aSelector
    "loads an image by evaluating aMessage;
     if no image could extract from aMessage; do set the class and the selector from 
     the aMessage for a saving at the end of editing"

    (imageEditView loadFromClass:aClass andSelector:aSelector) notNil ifTrue: [
        self updateColorsFromImage:self image.
        self findColorMapMode.
    ] ifFalse: [
        imageEditView resourceClass: aClass.
        imageEditView resourceSelector:aSelector.
    ].
    self updateLabelsAndHistory.

    "Modified: / 16.3.1999 / 21:45:07 / cg"
! !

!ImageEditor methodsFor:'menu modes'!

colorMapMode
    "returns the colorMapMode"

    colorMapMode isNil ifTrue: [colorMapMode := '' asValue].

    ^colorMapMode
!

editMode
    "returns editMode"

    editMode isNil ifTrue: [
        editMode := #point asValue.
        editMode onChangeEvaluate:[imageEditView editMode:(editMode value)]
    ].

    ^editMode
!

mouseKeyColorMode
    "returns mouseKeyColorMode"

    mouseKeyColorMode isNil ifTrue:[
        mouseKeyColorMode := 1 asValue.
        mouseKeyColorMode onChangeEvaluate: [
            imageEditView mouseKeyColorMode:mouseKeyColorMode value. 
            self selectedColors value:{ self listOfColors indexOf:imageEditView selectedColor }.
        ]
    ].

    ^mouseKeyColorMode

    "Modified: / 10.2.2000 / 23:16:42 / cg"
! !

!ImageEditor methodsFor:'private'!

checkModified
    imageEditView modified value ifTrue:[
        (Dialog
            confirm:(resources string:'Image was not saved. Proceed anyway ?')
            yesLabel:(resources string:'Proceed')
            noLabel:(resources string:'Cancel')
            initialAnswer:false
        ) ifFalse: [^false].

        imageEditView clearModified.
    ].
    ^ true

    "Modified: / 29.7.1998 / 18:55:24 / cg"
!

pointFromString:aString
    |p s x y|

    p := Object readFromString:aString onError:nil.
    p isPoint ifTrue:[^ p].

    s := aString readStream.
    x := Number readFrom:s onError:nil.
    x notNil ifTrue:[
        s skipSeparators.
        [s atEnd not and:[s peek isDigit not]] whileTrue:[s next].
        y := Number readFrom:s onError:nil.
        ^ x @ (y ? x)
    ].
    ^ nil
!

sortBlockForColors
    ^ self sortBlockForColorsByHLS.
"/    ^ self sortBlockForColorsByRGB
!

sortBlockForColorsByHLS
    ^ [:a :b |
        |h1 h2 s1 s2 l1 l2|

        h1 := a hue ? 0.
        h2 := b hue ? 0.
        (h1 between: h2-30 and:h2+30) ifTrue:[
            l1 := a light.
            l2 := b light.
            l1 = l2 ifTrue:[
                a saturation < b saturation
            ] ifFalse:[
                l1 < l2
            ].
"/            s1 := a saturation.
"/            s2 := b saturation.
"/            s1 = s2 ifTrue:[
"/                a light < b light
"/            ] ifFalse:[
"/                s1 < s2 
"/            ]
        ] ifFalse:[
            h1 < h2 
        ]
      ]
!

sortBlockForColorsByRGB
    ^ [:a :b |
            a redByte == b redByte ifTrue:[
                a greenByte == b greenByte ifTrue:[
                    a blueByte < b blueByte
                ] ifFalse:[
                    a greenByte < b greenByte 
                ]
            ] ifFalse:[
                a redByte < b redByte 
            ]
      ]
!

updateImage
    |img|

    img := imageEditView image.
    imageEditView image:img.
    self fetchImageData.
!

updateImagePreView
    self tileModeHolder value ifTrue:[
        self imagePreView tileMode:true tileOffset:(self image extent).
    ].
    self imagePreView 
        setImage:(self image) scroll:false invalidate:false; "/ true.
        invalidate.
! !

!ImageEditor methodsFor:'queries'!

hasLastGrabScreenArea
    ^ [ lastGrabbedScreenArea notNil ]
!

hasMask
    ^ colorMapMode value notNil and:[colorMapMode value startsWith:'mask']

    "Created: / 18.8.1998 / 17:17:38 / cg"
!

modified
    ^ imageEditView modified
!

modified:aBoolean
    super modified:aBoolean.
    imageEditView modified:aBoolean
!

preferredExtent
    "returns the preferred extent"

    ^ super preferredExtent max: (Screen current width//3)@(Screen current height//3.5)
! !

!ImageEditor methodsFor:'selection'!

magnification
    "returns the magnification of the image"

    self imageEditView isNil ifTrue: [^1].
    ^imageEditView magnification x
!

magnification: aValue
    "sets the magnification of the image"

    |magnification|        
    magnification := (aValue ? 1) asPoint.
    (magnification = imageEditView magnification or: [magnification = (0@0)]) ifTrue: [^nil].
    imageEditView magnification: magnification
!

selectedColorIndex
    "returns the index of the selected color"

    ^selectedColorIndex
!

selectedColorIndex: anIndex
    "sets the index of the selected color"

    |clr pixel|

    selectedColorIndex := anIndex.
    anIndex isNil ifTrue:[^ self].
    clr := self listOfColors at:anIndex ifAbsent:nil.
    clr isNil ifTrue:[^ self].

    pixel := anIndex - 1.
    (self listOfColors at:1) = Color noColor ifTrue:[
        anIndex == 1 ifTrue:[
            pixel := nil.       "/ mask
        ] ifFalse:[
            pixel := pixel - 1
        ]
    ].
    imageEditView selectedColorIndex:pixel.
    imageEditView selectedColor:clr.
! !

!ImageEditor methodsFor:'startup & release'!

closeDownViews
    builder notNil ifTrue:[
        DefaultRelativeSizes :=
            Array 
                with:(builder componentAt:#mainPanel) relativeCorners    
                with:(builder componentAt:#verticalPanel) relativeCorners.
    ].
    super closeDownViews
!

closeRequest
    "asks for permission before closing"

    imageEditView checkModified ifTrue:[
        super closeRequest
    ]
!

commonPostBuild
    imageEditView undoImages addDependent:self.
    imageEditView imageInfoHolder:(self imageInfoHolder).
    imageEditView activityInfoHolder:(self activityInfoHolder).

    imageEditView clickInfoCallBack:[:button :point | 
                        |mouseButtonColorToolBar|
                        button <= 2 ifTrue:[
                            mouseButtonColorToolBar := self componentAt:#MouseButtonColorToolBar.
                            (mouseButtonColorToolBar itemAt:button) toggleIndication.
                            mouseButtonColorToolBar do: [:i| i updateIndicators].
                        ].
                  ].

    imageEditView addDependent:self.
    imageEditView modifiedHolder addDependent:self.

    DefaultRelativeSizes notNil ifTrue:[
        (builder componentAt:#mainPanel) relativeCorners:DefaultRelativeSizes first.
        (builder componentAt:#verticalPanel) relativeCorners:DefaultRelativeSizes second.
    ].

    "/ using masters infoHolder ?
    (builder aspectAt:#useAlienInfoLabelHolder) == true ifTrue:[
        (builder componentAt:#mainPanel) layout bottomOffset:0.
        (builder componentAt:#infoBarSubSpec) beInvisible
    ]
!

open
    "after opening, sets the masterApplication of the imageEditView to self"

    super open.

    imageEditView := (self componentAt: #imageEditView) subViews first.
!

postOpenWith:aBuilder
    "after opening, sets the masterApplication of the imageEditView to self;
     evaluate the postOpenAction"

    postOpenAction value.

    super postOpenWith:aBuilder.

    aBuilder keyboardProcessor menuBar:nil.
    self windowGroup addPreEventHook:self.
! !

!ImageEditor methodsFor:'user actions-colormap'!

addColorToColormap
    self addColorToColormap:(Color black)
!

addColorToColormap:newColor
    |depth img cMap newColorMap newImage oldCListSize newMode listOfColors|

    img := self image.
    img isNil ifTrue:[
        self warn:'No Image.'.
        ^ self
    ].

    depth := img depth.
    cMap := img colorMap.
    cMap isNil ifTrue:[
        drawingColormap isNil ifTrue:[
            self information:(resources stringWithCRs:'Image has no colormap.\The shown colorMap is for drawing only.').
            drawingColormap := OrderedCollection new.
        ].
        drawingColormap add:newColor.
        self listOfColors contents:drawingColormap.
        self selectedColors value:{drawingColormap size}.
        "/ self warn:'Image has no colormap.\Change colorMap mode first.' withCRs.
        ^ self
    ].

    ("(depth == 1)" false
    or:[cMap size == (1 bitShift:depth)]) ifTrue:[
        depth >= 8 ifTrue:[
            self warn:'No space for more colors in colormap.'.
            ^ self
        ].
        (self confirm:(resources stringWithCRs:'No space for more colors in colormap.\Change depth ?'))
        ifFalse:[
            ^ self
        ].

        imageEditView makeUndo.
        img mask notNil ifTrue:[
            newMode := 'masked' , (depth*2) printString.
        ] ifFalse:[
            newMode := 'depth' , (depth*2) printString.
        ].
        self colorMapMode:newMode.
    ] ifFalse:[
        imageEditView makeUndo.
    ].

    cMap := cMap asArray.
    listOfColors := self listOfColors.
    oldCListSize := listOfColors size.

    newColorMap := cMap copyWith:newColor.

    newImage := img species new
                    width:img width
                    height:img height
                    depth:depth
                    fromArray:img bits.

    newImage colorMap:newColorMap.  
    newImage fileName:img fileName.
    newImage mask:(img mask copy).

    (imageEditView image:newImage) notNil ifTrue:[
        listOfColors contents: newImage colorMap.
        self findColorMapMode.
        "/ mhmh - somehow, we get two colors added ... (sigh findColorMapMode adds another one ...)
        listOfColors size > (oldCListSize + 1) ifTrue:[
            listOfColors removeLast
        ].
        self selectedColors value:{listOfColors size}.
        self updateLabelsAndHistory.
    ]

    "Created: / 12.3.1999 / 00:20:28 / cg"
    "Modified: / 16.3.1999 / 21:57:26 / cg"
!

changeHLS
    "interactive Hue/Light/Saturation editing"

    |bindings hueShift lightValue saturationValue originalColormap firstChange acceptChannel 
     shiftAction avgColorHolder avgColor shiftedColor shiftProcess readySema
     originalPixels p previewImage previewImageHolder originalPreviewColormap originalPreviewPixels
     anyChange |

    "/ compute the averageColor in the background (while asking user)
    avgColorHolder := nil asValue.
    previewImageHolder := nil asValue.

    readySema := Semaphore new.
    [
        |image|

        image := imageEditView image.
        originalColormap := image colorMap copy.
        originalPixels := image bits.
        avgColor := image averageColor.
        avgColorHolder value:avgColor.

        previewImage := self image magnifiedPreservingRatioTo:100@100.
        previewImageHolder value: previewImage.
        originalPreviewColormap := previewImage colorMap copy.
        originalPreviewPixels := previewImage bits.

        readySema signal.
    ] forkAt:7.

    acceptChannel := TriggerValue new.

    firstChange := true.
    anyChange := false.

    shiftedColor := [:clr :hShift :lFactor :sFactor |
                        Color 
                                hue:((clr hue) ? 0 + hShift) 
                                light:((clr light * lFactor / 100) min:100)
                                saturation:((clr saturation * sFactor / 100) min:100)].

    shiftAction := 
        [
            |hShift lFactor sFactor|

            acceptChannel value:true.

            firstChange ifTrue:[
                imageEditView makeUndo.
                firstChange := false.
                anyChange := true.
            ].
            readySema notNil ifTrue:[readySema wait. readySema := nil].

            hShift := hueShift value.
            lFactor := lightValue value.
            sFactor := saturationValue value.

            avgColorHolder value:(shiftedColor value:avgColor value:hShift value:lFactor value:sFactor).

            previewImage
                colorMap:originalPreviewColormap copy;
                bits:originalPreviewPixels copy;
                release;
                colorMapProcessing:[:clr | shiftedColor value:clr value:hShift value:lFactor value:sFactor].
            previewImageHolder value:nil; value:previewImage.

            shiftProcess notNil ifTrue:[
                shiftProcess terminate.
                shiftProcess waitUntilTerminated.
                shiftProcess := nil.
            ].
            shiftProcess := 
                [
                    [
                        imageEditView image 
                            colorMap:originalColormap copy;
                            bits:originalPixels copy;
                            release;
                            colorMapProcessing:[:clr | shiftedColor value:clr value:hShift value:lFactor value:sFactor].
                        self updateImage.
                        self updateInfoLabel.
                        self updateImagePreView.
                    ] ensure:[ shiftProcess := nil ].    
                ] forkAt:7.
        ].

    bindings := IdentityDictionary new.
    bindings at:#hueShiftAmount put:(hueShift := 0 asValue).
    hueShift onChangeEvaluate:shiftAction.

    bindings at:#lightAmount put:(lightValue := 100 asValue).
    lightValue onChangeEvaluate:shiftAction.

    bindings at:#saturationAmount put:(saturationValue := 100 asValue).
    saturationValue onChangeEvaluate:shiftAction.

    bindings at:#acceptChannel put:acceptChannel.
    bindings at:#hlsColor put:avgColorHolder.
    bindings at:#previewImageHolder put:previewImageHolder.

    (self openDialogInterface:#changeHLSDialogSpec withBindings:bindings) 
    ifFalse:[ 
        anyChange ifTrue:[
            imageEditView undo
        ]
    ].

    (p := shiftProcess) notNil ifTrue:[
        p waitUntilTerminated.
    ].

    anyChange ifTrue:[
        self updateImage.
        self updateImagePreView.
    ].
!

changeHLSOfColors:colorsToShift
    "interactive Hue/Light/Saturation editing"

    |bindings hueShift lightValue saturationValue originalColormap firstChange acceptChannel 
     shiftAction avgColorHolder avgColor shiftedColor shiftProcess readySema
     originalPixels p previewImage previewImageHolder originalPreviewColormap originalPreviewPixels
     anyChange |

    "/ compute the averageColor in the background (while asking user)
    avgColorHolder := nil asValue.
    previewImageHolder := nil asValue.

    readySema := Semaphore new.
    [
        |image red green blue|

        image := imageEditView image.
        originalColormap := image colorMap copy.
        originalPixels := image bits.
        red := (colorsToShift collect:[:clr | clr red]) average.
        green := (colorsToShift collect:[:clr | clr green]) average.
        blue := (colorsToShift collect:[:clr | clr blue]) average.
        avgColor := Color red:red green:green blue:blue.
        avgColorHolder value:avgColor.

        previewImage := self image magnifiedPreservingRatioTo:100@100.
        previewImageHolder value: previewImage.
        originalPreviewColormap := previewImage colorMap copy.
        originalPreviewPixels := previewImage bits.

        readySema signal.
    ] forkAt:7.

    acceptChannel := TriggerValue new.

    firstChange := true.
    anyChange := false.

    shiftedColor := [:clr :hShift :lFactor :sFactor |
                        Color 
                                hue:((clr hue) ? 0 + hShift) 
                                light:((clr light * lFactor / 100) min:100)
                                saturation:((clr saturation * sFactor / 100) min:100)].

    shiftAction := 
        [
            |hShift lFactor sFactor|

            acceptChannel value:true.

            firstChange ifTrue:[
                imageEditView makeUndo.
                firstChange := false.
                anyChange := true.
            ].
            readySema notNil ifTrue:[readySema wait. readySema := nil].

            hShift := hueShift value.
            lFactor := lightValue value.
            sFactor := saturationValue value.

            avgColorHolder value:(shiftedColor value:avgColor value:hShift value:lFactor value:sFactor).

            previewImage
                colorMap:originalPreviewColormap copy;
                bits:originalPreviewPixels copy;
                release;
                colorMapProcessing:[:clr | 
                    (colorsToShift includes:clr) ifTrue:[
                        shiftedColor value:clr value:hShift value:lFactor value:sFactor.
                    ] ifFalse:[
                        clr
                    ]
                ].
            previewImageHolder value:nil; value:previewImage.

            shiftProcess notNil ifTrue:[
                shiftProcess terminate.
                shiftProcess waitUntilTerminated.
                shiftProcess := nil.
            ].

            shiftProcess := 
                [
                    [
                        imageEditView image 
                            colorMap:originalColormap copy;
                            bits:originalPixels copy;
                            release;
                            colorMapProcessing:[:clr | 
                                (colorsToShift includes:clr) ifTrue:[
                                    shiftedColor value:clr value:hShift value:lFactor value:sFactor.
                                ] ifFalse:[
                                    clr
                                ]
                            ].
                        self updateImage.
                        self updateInfoLabel.
                        self updateImagePreView.
                    ] ensure:[ shiftProcess := nil ].    
                ] forkAt:7.
        ].

    bindings := IdentityDictionary new.
    bindings at:#hueShiftAmount put:(hueShift := 0 asValue).
    hueShift onChangeEvaluate:shiftAction.

    bindings at:#lightAmount put:(lightValue := 100 asValue).
    lightValue onChangeEvaluate:shiftAction.

    bindings at:#saturationAmount put:(saturationValue := 100 asValue).
    saturationValue onChangeEvaluate:shiftAction.

    bindings at:#acceptChannel put:acceptChannel.
    bindings at:#hlsColor put:avgColorHolder.
    bindings at:#previewImageHolder put:previewImageHolder.

    (self openDialogInterface:#changeHLSDialogSpec withBindings:bindings) 
    ifFalse:[ 
        anyChange ifTrue:[
            imageEditView undo
        ]
    ].

    (p := shiftProcess) notNil ifTrue:[
        p waitUntilTerminated.
    ].

    anyChange ifTrue:[
        self updateImage.
        self updateImagePreView.
    ].
!

clearColormapEntry0AndMaskedPixels
    "ensure that there is a colorMap entry with 0/0/0 at position
     0 and then clear all masked pixels (to pixelValue 0).
     This is required for windows icons to be really transparent"

    |index colorMap| 

    self compressColorMap.
    colorMap := self image colorMap.
    (colorMap includes:(Color black)) ifFalse:[
        self addColorToColormap:(Color black).
        colorMap := self image colorMap.
    ].
    index := colorMap indexOf:(Color black).
    index == 1 ifFalse:[
        self sortColorMap.
        colorMap := self image colorMap.
    ].
    self clearMaskedPixels
!

clearMaskedPixels
    "clear all masked pixels (to pixelValue 0)"

    |newImage| 

    newImage := self image clearMaskedPixels.
    0 to:newImage height - 1 do:[:y |
        0 to:newImage width - 1 do:[:x |
            (newImage maskAtX:x y:y) == 0 ifTrue:[
                newImage pixelAtX:x y:y put:0
            ]
        ]
    ].

    (imageEditView image:newImage) notNil ifTrue:[
        self fetchImageData.
    ]
!

colorMapChanged
    |img|

    img := self image.
    img release.

    self imageEditView invalidate.
    self imagePreView invalidate.

"/    (imageEditView image:img) notNil ifTrue:[
"/        self updateLabelsAndHistory.
"/        self imagePreView image:img
"/    ]

    "Created: / 7.8.1998 / 22:26:10 / cg"
    "Modified: / 18.8.1998 / 17:08:55 / cg"
!

colorMapMode:aMode
    "calculates a new color map for the image from aMode"

    |depth numColors newColorMap newImage 
     oldImage image newColors realColorMap oldFileName
     usedColors useNearest usageCounts tmpBits tmpMap quest
     prevMode maskThreshold maskImage| 

    self withExecuteCursorDo:[
        oldImage := self image.

        prevMode := colorMapMode value.

        newColorMap := self class listOfColorMaps at:aMode.
        (aMode == #depth32 or:[aMode == #masked32]) ifTrue:[
            depth := 32. 
        ] ifFalse:[
            (aMode == #depth24 or:[aMode == #masked24]) ifTrue:[
                depth := 24. 
            ] ifFalse:[
                (aMode == #depth16 or:[aMode == #masked16]) ifTrue:[
                    depth := 16. 
                ] ifFalse:[
                    depth := (newColorMap size log:2) asInteger. 
                ].
            ].
        ].

        useNearest := false.
        depth == 1 ifTrue:[
            quest := 'Keep colormap (or use standard B&W)'
        ] ifFalse:[
            prevMode isNil ifTrue:[
                quest := 'Compute colormap (or use standard)'
            ] ifFalse:[
                quest := 'Keep colormap (or use standard)'
            ]
        ].
        ((prevMode = aMode)
        or:[depth > oldImage depth
        or:[self confirm:(resources string:quest)]]) ifTrue:[
            (newColorMap isOrderedCollection or:[newColorMap isFixedPalette not]) ifTrue:[

                "/ keep the colormap
                "/ newColorMap atAllPut:Color black.
                depth > oldImage depth ifTrue:[
                    "/ easy - simply copy the part
                    numColors := 1 bitShift:oldImage depth.
                    0 to:numColors-1 do:[:pixel |
                        newColorMap at:(pixel+1) put:(oldImage colorFromValue:pixel)
                    ].
                ] ifFalse:[
                    "/ see if all used color fit the new colormap
                    usedColors := oldImage usedColorsMax:(1 bitShift:depth).
                    (usedColors notNil and:[usedColors size > (1 bitShift:depth)]) ifTrue:[
                        usedColors := oldImage realUsedColors
                    ].
                    (usedColors notNil and:[usedColors size <= (1 bitShift:depth)]) ifTrue:[
                        "/ yea - just install them
                        usedColors asArray keysAndValuesDo:[:idx :clr |
                            newColorMap at:idx put:clr
                        ].
                    ] ifFalse:[
                        "/ copy over those that are most often used.
                        oldImage depth < 8 ifTrue:[
                            tmpBits := ByteArray uninitializedNew:(oldImage width*oldImage height).
                            oldImage bits
                                expandPixels:(oldImage depth)
                                width:oldImage width
                                height:oldImage height 
                                into:tmpBits
                                mapping:nil.
                        ] ifFalse:[
                            oldImage depth == 8 ifTrue:[
                                tmpBits := oldImage bits
                            ] ifFalse:[
                                colorMapMode value:prevMode.
                                self findColorMapMode.    
                                self warn:('Too many used colors in image (', oldImage usedColors size printString , ').').
                                ^ self
    "/                            (self confirm:('Too many used colors in image (', oldImage usedColors size printString , ').\\Dither ?' withCRs))
    "/                            ifFalse:[.
    "/                                ^ self
    "/                            ].
    "/                            self image: (Image newForDepth:depth) fromImage:oldImage.
    "/                            ^ self.
                            ]
                        ].
                        usageCounts := tmpBits usageCounts.
                        tmpMap := Array new:usageCounts size.
                        oldImage colorMap asArray keysAndValuesDo:[:i :clr |
                            tmpMap at:i put:clr
                        ].
                        usageCounts sort:[:a :b | a > b] with:tmpMap.

                        1 to:(1 bitShift:depth) do:[:idx |
                            newColorMap at:idx put:(tmpMap at:idx)
                        ].

                        useNearest := Dialog 
                                            confirmWithCancel:(resources 
                                                                  stringWithCRs:'Image requires %1 colors.\ColorMap has only space for %2\\Use nearest (or map to first color) ?'
                                                                  with:usedColors size
                                                                  with:(1 bitShift:depth))
                                            labels:(resources array:#('Cancel' 'First' 'Nearest')).
                        useNearest isNil ifTrue:[
                            colorMapMode value:prevMode.
                            ^ self   "/ cancel
                        ].
                    ]
                ]
            ]
        ] ifFalse:[
            "/ standard colormap
            usedColors := oldImage usedColors.
            (usedColors conform:[:clr | newColorMap includes:clr]) ifFalse:[
                useNearest := Dialog 
                                    confirmWithCancel:(resources 
                                                           stringWithCRs:'Not all colors are present in the new colormap.\\Map missing ones to nearest (or map to first color) ?'
                                                       ) 
                                    labels:(resources string:#('Cancel' 'First' 'Nearest')).
                useNearest isNil ifTrue:[
                    colorMapMode value:prevMode.
                    ^ self   "/ cancel
                ].
            ].
            newColorMap := oldImage colorMap.
        ].

        imageEditView makeUndo.

        newImage := Image newForDepth:depth.
        newImage depth:depth.
        depth >= 16 ifTrue:[
            depth == 32 ifTrue:[
                newImage colorMap:nil.
                newImage samplesPerPixel:4.
                newImage photometric:#rgba.
            ] ifFalse:[    
                newImage colorMap:nil.
                newImage samplesPerPixel:3.
                newImage photometric:#rgb.
            ].    
        ].    
"/        newImage photometric:oldImage photometric.

        oldFileName := oldImage fileName.

        Image imageErrorSignal handle:[:ex|
            "/ arrive here only if not all colors can be represented;
            "/ then do a more expensive nearest color search
            Color colorErrorSignal handle:[:ex|
                colorMapMode value:prevMode.
                imageEditView undo.
                ^ self warn:(resources string:'Conversion failed !!')
            ] do:[
                newImage := Image newForDepth:depth.
                newImage 
                    width:oldImage width height:oldImage height depth:depth;
                    colorMap:newColorMap;
                    photometric:#palette;
                    bits:(ByteArray new:(newImage bytesPerRow * newImage height));
                    mask:oldImage mask.

                oldImage 
                    colorsFromX:0 y:0 
                    toX:(oldImage width-1) y:(oldImage height-1) 
                    do:[:x :y :clr |
                        |newColor|

                        (newColorMap includes:clr)
                            ifTrue: [newColor := clr]
                            ifFalse: [
                                newColor := clr nearestIn:newColorMap.
                                useNearest ifFalse:[
                                    (newColor deltaFrom:clr) > 0.5 ifTrue:[
                                        newColor := oldImage colorFromValue:0
                                    ]
                                ]
                            ].
                        newImage colorAtX:x y:y put:newColor.
                    ].
                
                image := newImage
            ].
        ] do:[ 
            image := newImage 
                        fromImage:oldImage 
                        photometric:((newColorMap notNil and:[newColorMap isOrderedCollection or:[newColorMap isFixedPalette not]])
                                        ifTrue:[#palette]
                                        ifFalse:[nil]).
                         "/ -- nope; keep the newly determined photometric. photometric:oldImage photometric.
        ].

        (aMode asString startsWith:'mask') ifTrue:[
            image mask isNil ifTrue:[
                false "(Dialog confirm:'Generate mask from black ?' default:false)" ifTrue:[
                    maskThreshold := 0.1.
                    maskImage := Depth1Image fromImage:(image asThresholdMonochromeImage:maskThreshold). 
                ] ifFalse:[
                    maskImage := ImageMask extent:image extent.
                    maskImage bits:(ByteArray 
                                        new:(maskImage bytesPerRow * maskImage height)
                                        withAll:16rFF).

"/                    maskImage fillRectangle:(image bounds) withColor:(Color colorId:1).
                ].
                image mask:maskImage.
            ].
        ] ifFalse:[ 
            image mask: nil.
            oldImage mask notNil ifTrue:[
                newImage depth == 32 ifTrue:[
                    newImage computeAlphaValuesFromMask:oldImage mask
                ].
            ].
        ]. 

        (newColorMap isOrderedCollection or:[newColorMap isFixedPalette not]) ifTrue:[
            realColorMap := OrderedCollection new.
            image realColorMap do:[:clr|
                (realColorMap includes: clr) ifFalse: [realColorMap add: clr]
            ].
            newColors := realColorMap copyFrom: 1 to: (newColorMap size min: realColorMap size).
            newColorMap do:[:clr|
                ((newColors size < newColorMap size) and: [(newColors includes: clr) not]) 
                ifTrue:[      
                    newColors add: clr
                ]
            ].                  
            image colorMap: newColors.   
        ].
        image fileName: oldFileName.

        (imageEditView image: image) notNil ifTrue:[
            self fetchImageData.
        ]
    ]

    "Modified: / 22-11-2016 / 03:44:00 / cg"
!

colorize
    "interactive Hue editing"

    |bindings hueShift lightValue saturationValue originalColormap firstChange acceptChannel 
     shiftAction avgColorHolder avgColor shiftedColor shiftProcess readySema
     originalPixels p|

    "/ compute the averageColor in the background (while asking user)
    readySema := Semaphore new.
    [
        |image|

        image := imageEditView image.
        originalColormap := image colorMap copy.
        avgColor := image averageColor.
        originalPixels := image bits.
        readySema signal.
    ] forkAt:7.

    acceptChannel := TriggerValue new.
    avgColorHolder := avgColor asValue.

    firstChange := true.

    shiftedColor := [:clr :hShift :lFactor :sFactor |
                        Color 
                                hue:((clr hue) ? 0 + hShift) 
                                light:((clr light * lFactor / 100) min:100)
                                saturation:(((clr saturation max:20) * sFactor / 100) min:100)].


    shiftAction := 
        [
            |hShift lFactor sFactor|

            acceptChannel value:true.

            firstChange ifTrue:[
                imageEditView makeUndo.
                firstChange := false.
            ].
            readySema notNil ifTrue:[readySema wait. readySema := nil].

            hShift := hueShift value.
            lFactor := lightValue value.
            sFactor := saturationValue value.

            avgColorHolder value:(shiftedColor value:avgColor value:hShift value:lFactor value:sFactor).

            shiftProcess notNil ifTrue:[
                shiftProcess terminate.
                shiftProcess waitUntilTerminated.
                shiftProcess := nil.
            ].
            shiftProcess := 
                [
                    [
                        imageEditView image 
                            colorMap:originalColormap copy;
                            bits:originalPixels copy;
                            release;
                            colorMapProcessing:[:clr | shiftedColor value:clr value:hShift value:lFactor value:sFactor].
                        self updateImage.
                        self updateInfoLabel.
                        self updateImagePreView.
                    ] ensure:[ shiftProcess := nil ].    
                ] forkAt:7.
        ].

    bindings := IdentityDictionary new.
    bindings at:#hueShiftAmount put:(hueShift := 0 asValue).
    hueShift onChangeEvaluate:shiftAction.

    bindings at:#lightAmount put:(lightValue := 100 asValue).
    lightValue onChangeEvaluate:shiftAction.

    bindings at:#saturationAmount put:(saturationValue := 100 asValue).
    saturationValue onChangeEvaluate:shiftAction.

    bindings at:#acceptChannel put:acceptChannel.
    bindings at:#hlsColor put:avgColorHolder.

    (self openDialogInterface:#changeHLSDialogSpec withBindings:bindings) 
    ifFalse:[ 
        firstChange ~~ true ifTrue:[
            imageEditView undo
        ]
    ].

    (p := shiftProcess) notNil ifTrue:[
        p waitUntilTerminated.
    ].
    self updateImage.
    self updateImagePreView.

    "Created: / 01-11-2007 / 23:27:37 / cg"
!

compressColorMap
    "calculates a new color map for the image, using only used colors"

    |newImage| 

    newImage := self image.
    newImage compressColorMap.

    (imageEditView image:newImage) notNil ifTrue:[
        self fetchImageData.
    ]
!

copyColorFromColormap
    imageEditView setClipboardObject:(self selectedColorOrNil)
!

ditherToDepth
    |depth|

    depth := Dialog request:'New depth ?'.
    depth isEmptyOrNil ifTrue:[^ self].
    depth := Number readFrom:depth onError:nil.
    depth isNil ifTrue:[^ self].

    self ditherToDepth:depth

    "Created: / 07-07-2006 / 13:22:10 / cg"
!

ditherToDepth:depth
    |ditherColors newImage useStandardColors nGrey greyColorsAlready moreColors d|

    useStandardColors := true.
"/    useStandardColors := Dialog confirmWithCancel:'Dither in standard colors or use a new (optimized) colormap ?'.
"/    useStandardColors isNil ifTrue:[^ self].

    useStandardColors ifTrue:[
        depth = 1 ifTrue:[
            ditherColors := Array with:(Color black) with:(Color white).
        ] ifFalse:[ depth = 2 ifTrue:[
            ditherColors := Array 
                                with:(Color black) 
                                with:(Color darkGray)
                                with:(Color lightGray)
                                with:(Color white).
        ] ifFalse:[ depth = 3 ifTrue:[
            ditherColors := Color colorCubeWithRed:2 green:2 blue:2. 
        ] ifFalse:[ depth = 4 ifTrue:[
            ditherColors := Color vgaColors. 
        ] ifFalse:[ depth = 5 ifTrue:[
            ditherColors := Color colorCubeWithRed:4 green:4 blue:2. 
        ] ifFalse:[ depth = 6 ifTrue:[
            ditherColors := Color colorCubeWithRed:4 green:4 blue:3.
        ] ifFalse:[ depth <= 8 ifTrue:[
            ditherColors := Color colorCubeWithRed:6 green:6 blue:5. 
        ] ifFalse:[ 
            self error:'unsupported depth'.
        ]]]]]]].

        nGrey := (2 raisedTo:depth) - ditherColors size.  
        nGrey > 0 ifTrue:[
            nGrey := nGrey min:128.
            greyColorsAlready := ditherColors select:[:clr | clr isGreyColor].
            d := 1 / nGrey.
            moreColors := (1 to:nGrey-1) 
                            collect:[:i | Color brightness:(d * i)] 
                            thenReject:[:clr | greyColorsAlready includes:clr ].

            ditherColors := ditherColors , moreColors.
        ].
    ] ifFalse:[
        self halt:'unhandled dither color setup'.
    ].

    self withExecuteCursorDo:[
        "/ newImage := self image asDitheredImageUsing:ditherColors depth:depth.
        newImage := self image asDitheredImageUsing:ditherColors depth:8.

        imageEditView makeUndo.
        imageEditView image:newImage.
        imageEditView setModified.
        self updateImage.
        self updateImagePreView.

        self fetchImageData.
    ].

    "Created: / 07-07-2006 / 13:20:56 / cg"
    "Modified: / 05-09-2006 / 16:13:25 / cg"
!

doubleClickOnColor:aColorIndex
    self editSelectedColor.

    "Created: / 22-07-2007 / 13:14:37 / cg"
!

editSelectedColor
    self processSelectedColorWith:[:clr | 
        |editor|

        editor := ColorEditDialog new.
        editor color:clr.
        editor open.
        editor accepted ifFalse:[
            AbortOperationRequest raise.
        ].
        editor color
    ]
!

fetchImageData
    |image|

    (image := imageEditView image) notNil ifTrue:[
        self findColorMapMode.
        self updateLabelsAndHistory.
    ]
!

inspectColor
    |clrIndex clr|

    self hasColormap ifFalse:[
        clr := self selectedColorOrNil
    ] ifTrue:[
        clrIndex := self selectedColorIndexOrNil.
        clrIndex isNil ifTrue:[
            ^ self
        ].
        clr := self image colorFromValue:clrIndex-1
    ].
    clr inspect
!

inspectColormap
    self hasColormap ifTrue:[
        self image colorMap inspect
    ].
!

makeBrighter
    | anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeBrighter.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].
!

makeDarker
    | anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeDarker.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].
!

makeGrayScaleImage
    |anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeGrayScaleImage.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].
!

makeInverse
    | anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeInverse.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].
!

makeSelectedColorBrighter
    self processSelectedColorsWith:[:clr | clr lightened]
!

makeSelectedColorDarker
    self processSelectedColorsWith:[:clr | clr darkened]
!

makeSelectedColorGray
    self processSelectedColorsWith:[:clr | Color brightness:(clr brightness)]
!

makeSelectedColorShifted
    |cMap colors|

    cMap := self image colorMap.
    self hasMask ifTrue:[
        colors := self selectedColors value collect:[:idx | cMap at:idx-1].
    ] ifFalse:[
        colors := self selectedColors value collect:[:idx | cMap at:idx].
    ].
    self changeHLSOfColors:colors.
!

makeSlightlyBrighter
    | anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeSlightlyBrighter.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].

    "Created: / 24-11-2010 / 11:06:11 / cg"
!

makeSlightlyDarker
    | anyChange|

    self withExecuteCursorDo:[
        anyChange := imageEditView makeSlightlyDarker.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            self updateImage.
        ]
    ].

    "Created: / 24-11-2010 / 11:06:23 / cg"
!

menu_clearColormapEntry0AndMaskedPixels
    "ensure that there is a colorMap entry with 0/0/0 at position
     0 and then clear all masked pixels (to pixelValue 0)"

    imageEditView makeUndo.
    self withExecuteCursorDo:[
        self clearColormapEntry0AndMaskedPixels
    ]
!

menu_clearMaskedPixels
    "clear all masked pixels (to pixelValue 0)"

    imageEditView makeUndo.

    self withExecuteCursorDo:[
        self clearMaskedPixels
    ]
!

menu_compressColorMap
    "calculates a new color map for the image, using only used colors"

    |depth oldImage usedColors colorMap| 

    oldImage := self image.

    oldImage photometric ~~ #palette ifTrue:[
        self information:'Compress colorMap: Only palette images have colormaps.'.
        ^ self
    ].
    depth := oldImage depth.
    colorMap := oldImage colorMap asArray.
    usedColors := oldImage realUsedColors.
    usedColors size == colorMap size ifTrue:[
        self information:'Compress colorMap: Colormap already compressed - no compression.'.
        ^ self
    ].

    imageEditView makeUndo.

    self withExecuteCursorDo:[
        self compressColorMap
    ]
!

menu_copyMask
    |mask|

    mask := self image mask.
    MaskClipboard := mask subImageIn: (0@0 extent:mask extent).
!

menu_pasteMask
    |img mask|

    imageEditView makeUndo.

    img := self image.
    mask := img mask.

    mask 
         copyFrom:MaskClipboard
         x:0 y:0
         toX:0 y:0 
         width:(mask width min:MaskClipboard width)
         height:(mask height min:MaskClipboard height).
    img mask:mask.
    (imageEditView image:img copy) notNil ifTrue:[
        self fetchImageData.
    ]
!

menu_sortColorMap
    "calculates a new color map for the image, sorting colors"

    self menu_sortColorMapWith:self sortBlockForColors
!

menu_sortColorMapWith:sortBlock
    "calculates a new color map for the image, sorting colors"

    self image photometric ~~ #palette ifTrue:[
        self information:'Compress colorMap: Only palette images have colormaps.'.
        ^ self
    ].

    imageEditView makeUndo.

    self withExecuteCursorDo:[
        self sortColorMapWith:sortBlock
    ]

    "Modified: / 15.9.1998 / 17:53:32 / cg"
    "Created: / 30.9.1998 / 23:51:23 / cg"
!

pasteColorIntoColormap
    |copyBufferColor|

    copyBufferColor := imageEditView getClipboardObject.
    copyBufferColor isColor ifFalse:[
        UserPreferences current beepInEditor ifTrue:[                
            self window beep.
        ].
        ^ self
    ].

    self processSelectedColorWith:[:clr |
        copyBufferColor
    ]
!

pickAndAddColorToColormap
    self addColorToColormap:(Color fromUser)
!

pickAndPasteColor
    self pickColor.
    self pasteColorIntoColormap.
!

pickColor
    imageEditView setClipboardObject:(Color fromUser)
!

processSelectedColorWith:aBlock
    "undoable color processing: 
     the selected color will be replaced by the value of aBlock"

    self processSelectedColorsWith:aBlock.
!

processSelectedColorsWith:aBlock
    "undoable color processing: 
     the selected colors will be replaced by the value of aBlock 
     (which gets a color vector and must return a color vector)"

    |img cMap modifiedColormap oldColors newImage selectedColorIndices newColors maskOffset|

    selectedColorIndices := self selectedColors value.
    selectedColorIndices isEmptyOrNil ifTrue:[^ self].

    img := self image.
    cMap := img colorMap.
    cMap isNil ifTrue:[
        self warn:(resources stringWithCRs:'Image has no colormap.\Please change the colorMap mode first.').
        ^ self
    ].
    self hasMask ifTrue:[
        maskOffset := 1.
    ] ifFalse:[
        maskOffset := 0.
    ].
    oldColors := selectedColorIndices collect:[:idx | cMap at:idx-maskOffset].
    imageEditView makeUndo.

    modifiedColormap := cMap asNewArray.

    newColors := oldColors collect:aBlock.
    selectedColorIndices with:newColors do:[:idx :newColor | 
        modifiedColormap at:idx-maskOffset put:newColor
    ].

    newImage := img species new
                    width:img width
                    height:img height
                    depth:img depth
                    fromArray:img bits.

    newImage colorMap:modifiedColormap.  
    newImage fileName:img fileName.
    newImage mask:(img mask copy).

    (imageEditView image:newImage) notNil ifTrue:[
        self fetchImageData.
    ].
    self selectedColors value:selectedColorIndices.
!

reduceNumberOfColors
    |s n anyChange img usedColors|

    s := Dialog request:'Number of color bits to strip (1-7) ?' initialAnswer:3.
    s size == 0 ifTrue:[^ self].

    n := Integer readFrom:s onError:0.
    (n between:1 and:7) ifFalse:[
        Dialog warn:'Image unchanged'.
        ^ self
    ].

    self withExecuteCursorDo:[
        anyChange := imageEditView reduceColorResolutionBy:n.
        anyChange ifFalse:[
            Dialog warn:'Image unchanged'.
        ] ifTrue:[
            img := imageEditView image.
            imageEditView image:img.

            self fetchImageData.
            usedColors := img usedColorsMax:10000.
            usedColors size == 10000 ifTrue:[
                Dialog information:('>= ' , usedColors size printString , ' colors used.')
            ] ifFalse:[
                Dialog information:(usedColors size printString , ' colors used.')
            ]
        ]
    ].

    "Modified: / 29-10-2010 / 18:08:01 / cg"
!

reduceNumberOfColors2
    |s rndR rndG rndB usedColors image newImage|

    s := Dialog request:'Rounding Interval red (2..) ?' initialAnswer:4.
    s size == 0 ifTrue:[^ self].
    rndR := Integer readFrom:s onError:0.

    s := Dialog request:'Rounding Interval green (2..) ?' initialAnswer:2.
    s size == 0 ifTrue:[^ self].
    rndG := Integer readFrom:s onError:0.

    s := Dialog request:'Rounding Interval blue (2..) ?' initialAnswer:10.
    s size == 0 ifTrue:[^ self].
    rndB := Integer readFrom:s onError:0.

    ((rndR > 1) or:[(rndG > 1) or:[(rndB > 1)]]) ifFalse:[
        Dialog warn:'Image unchanged'.
        ^ self
    ].

    self withExecuteCursorDo:[
        |reduceColor|

        reduceColor :=
            [:clr |
                |r g b nr ng nb|

                r := clr redByte.
                g := clr greenByte.
                b := clr blueByte. 
                nr := (r roundTo:rndR) min:255.
                ng := (g roundTo:rndG) min:255.
                nb := (b roundTo:rndB) min:255. 

                Color redByte:nr greenByte:ng blueByte:nb.
            ].

        image := self image.
        "/ usedColors := image usedColorsMax:4096.
        imageEditView makeUndo.

        newImage := image copy.
        newImage photometric == #palette ifTrue:[
            newImage colorMap:(image colorMap collect:reduceColor).
        ] ifFalse:[
            image
                colorsFromX:0 y:0 toX:(image width-1) y:(image height-1) 
                do:[:x :y :clr |
                    newImage colorAtX:x y:y put:(reduceColor value:clr)
                ].
        ].
        imageEditView image:newImage.
        imageEditView setModified.
        self updateImage.
        self updateImagePreView.

        self fetchImageData.
        usedColors := newImage usedColorsMax:10000.
        usedColors size == 10000 ifTrue:[
            Dialog information:('>= ' , usedColors size printString , ' colors used.')
        ] ifFalse:[
            Dialog information:(usedColors size printString , ' colors used.')
        ]
    ].

    "Modified: / 07-07-2006 / 13:10:42 / cg"
!

selectColor:aColor
    |idx img cMap|

    aColor isNil ifTrue:[
        idx := nil.
    ] ifFalse:[
        img := self image.
        img notNil ifTrue: [
            aColor == Color noColor ifTrue:[
                (img mask notNil) ifTrue:[
                    idx := 1.
                ]
            ] ifFalse:[
                (cMap := self listOfColors) notNil ifTrue:[
                    idx := cMap indexOf:aColor ifAbsent:nil.
                ].
                idx isNil ifTrue:[
                    "/ should not happen...
                    (cMap := img colorMap) notNil ifTrue:[
                        idx := cMap indexOf:aColor ifAbsent:nil.
                        idx notNil ifTrue:[
                            img mask notNil ifTrue:[
                                idx := idx + 1.
                            ].
                        ]
                    ].
                ].
            ].
        ].
    ].
    self selectedColors value:{idx}.

    "Modified: / 02-07-2010 / 12:06:07 / cg"
!

selectedColorIndexOrNil
    |img clrIndex|

    img := self image.
    img isNil ifTrue:[
        "/ self warn:'No Image.'.
        ^ nil
    ].
    clrIndex := self selectionOfColor value.
    self hasMask "img mask notNil" ifTrue: [ 
        (clrIndex isInteger and:[clrIndex > 1]) ifTrue:[
            ^ clrIndex - 1 
        ].
        ^ nil
    ].
    ^ clrIndex
!

selectedColorOrNil
    |cmapIndex img cMap colorList|

    cmapIndex := self selectedColorIndexOrNil.
    cmapIndex isNil ifTrue:[^ nil].
    cmapIndex == 0 ifTrue:[^ nil].

    img := self image.
    cMap := img colorMap.
    cMap isNil ifTrue:[
        "/ self warn:(resources stringWithCRs:'Image has no colormap.\Please change the colorMap mode first.').
        colorList := self listOfColors.
        colorList notNil ifTrue:[
            ^ colorList at:cmapIndex ifAbsent:nil
        ].
        ^ nil
    ].
    ^ cMap at:cmapIndex.
!

sortColorMap
    "calculates a new color map for the image, sorting colors"

    self sortColorMapWith:self sortBlockForColorsByRGB
!

sortColorMapWith:sortBlock
    "calculates a new color map for the image, sorting colors"

    |depth newColorMap newImage oldImage usedColors oldToNew oldBits newBits tmpBits
     expectedSize w h| 

    oldImage := self image.
    depth := oldImage depth.
    w := oldImage width.
    h := oldImage height.

    usedColors := oldImage realColorMap.

    "/ translation table
    oldToNew := ByteArray new:(1 bitShift:depth).
    newColorMap := usedColors asArray.
    newColorMap sort:sortBlock.

    oldImage colorMap asArray keysAndValuesDo:[:oldIdx :clr |
        |newPixel|

        (usedColors includes:clr) ifTrue:[
            newPixel := newColorMap indexOf:clr.
            oldToNew at:oldIdx put:newPixel-1.
        ]
    ].

    oldBits := oldImage bits.
    "/ sanity check...
    expectedSize := ((w * h * depth + 7) // 8).
    (oldBits size < expectedSize) ifTrue:[
        self halt:'incorrect pixeldata size'.
        oldBits := (ByteArray new:expectedSize) replaceFrom:1 with:oldBits; yourself.
    ].
    newBits := ByteArray new:(oldBits size).
    depth ~~ 8 ifTrue:[

        "/ expand/compress can only handle 8bits
        tmpBits := ByteArray uninitializedNew:(w*h).
        oldBits
            expandPixels:depth
            width:w height:h 
            into:tmpBits
            mapping:oldToNew.
        tmpBits
            compressPixels:depth 
            width:w height:h 
            into:newBits 
            mapping:nil
    ] ifFalse:[
        oldBits
            expandPixels:depth
            width:w height:h 
            into:newBits
            mapping:oldToNew.
    ].

    newImage := oldImage species new
                    width:w height:h depth:depth
                    fromArray:newBits.

    newImage colorMap:newColorMap.  
    newImage fileName:oldImage fileName.
    newImage mask:(oldImage mask copy).

    (imageEditView image:newImage) notNil ifTrue:[
        self fetchImageData.
    ]

    "Modified: / 15.9.1998 / 17:53:32 / cg"
    "Created: / 30.9.1998 / 23:51:23 / cg"
! !

!ImageEditor methodsFor:'user actions-editing'!

do3DProjection
    |box dx1 dx2 image|

    image := imageEditView image.

    box := EnterBox new.
    box title:(resources string:'dX1 (0 < dx < 0.5):').
    box okText:(resources string:'OK').
    box abortText:(resources string:'Cancel').
    box initialText:'0.1'.
    box showAtPointer.

    (box accepted 
    and: [(dx1 := Number readFrom:(box contents) onError:nil) notNil])
    ifTrue:[
        box title:(resources string:'dX2 (0 < dx < 0.5):').
        box initialText:(dx1 printString).
        box showAtPointer.
        (box accepted 
        and: [(dx2 := Number readFrom:(box contents) onError:nil) notNil])
        ifTrue:[
            imageEditView threeDProjection:dx1 and:dx2.
        ]
    ].

    self updateInfoLabel
!

doBrightenImage
    imageEditView brightenImage.
    self listOfColors removeAll.
    self findColorMapMode.     
    "/ imageEditView removelastUndo
!

doBrowseClass
    "opens a System Browser on the resourceClass and the resourceSelector"

    |cls|

    cls := imageEditView resourceClass.
    cls isNil ifTrue:[^ self warn:'No Class specified'].

    cls browserClass
        openInClass:cls class 
        selector:(imageEditView resourceSelector)

    "Modified: / 31.7.1998 / 02:01:15 / cg"
!

doCopyImageToClipboard
    imageEditView copyImageToClipboard.
!

doCropAll
    "find all borders and cut them off"

    imageEditView cropLeft:true right:true top:true bottom:true.   
    self updateInfoLabel

    "Modified: / 7.9.1998 / 14:26:23 / cg"
    "Created: / 7.9.1998 / 16:33:43 / cg"
!

doCropBottom
    "find a bottom border and cut it off"

    imageEditView cropLeft:false right:false top:false bottom:true.   
    self updateInfoLabel

    "Created: / 7.9.1998 / 13:00:20 / cg"
    "Modified: / 7.9.1998 / 14:26:23 / cg"
!

doCropLeft
    "find a left border and cut it off"

    imageEditView cropLeft:true right:false top:false bottom:false.   
    self updateInfoLabel

    "Created: / 7.9.1998 / 13:00:14 / cg"
    "Modified: / 7.9.1998 / 14:26:34 / cg"
!

doCropManual
    "let user specify borders and cut them off"

    |bindings left top right bottom img firstChange gropAction acceptChannel|

    acceptChannel := TriggerValue new.

    firstChange := true.

    gropAction := 
        [:lV :rV :tV :bV | |l r t b|
            acceptChannel value:true.

            l := lV value.
            r := rV value.
            t := tV value.
            b := bV value.
            (l + r + t + b) == 0 ifTrue:[
                UserPreferences current beepInEditor ifTrue:[                
                    self window beep
                ]
            ] ifFalse:[
                img := imageEditView image.
                firstChange ifTrue:[
                    imageEditView makeUndo.
                    firstChange := false.
                ].
                imageEditView
                    makeSubImageX:l y:t 
                    width:(img width - l - r)
                    height:(img height - t - b).

                self updateImagePreView.
                self updateInfoLabel
            ].
        ].

    bindings := IdentityDictionary new.
    bindings at:#left put:(left := 1 asValue).
    bindings at:#right put:(right := 1 asValue).
    bindings at:#top put:(top := 1 asValue).
    bindings at:#bottom put:(bottom := 1 asValue).
    bindings at:#acceptChannel put:acceptChannel.

    bindings at:#gropLeftNow   put:[ gropAction value:left value:0 value:0 value:0 ].
    bindings at:#gropRightNow  put:[ gropAction value:0 value:right value:0 value:0 ].
    bindings at:#gropTopNow    put:[ gropAction value:0 value:0 value:top value:0 ].
    bindings at:#gropBottomNow put:[ gropAction value:0 value:0 value:0 value:bottom ].

    bindings at:#applyAction   put:[ gropAction value:left value:right value:top value:bottom ].

    (self openDialogInterface:#cropDialogSpec withBindings:bindings) 
    ifFalse:[ 
        firstChange ~~ true ifTrue:[
            imageEditView undo.
            self updateImagePreView.
        ]
    ].

    "Created: / 7.9.1998 / 18:16:07 / cg"
    "Modified: / 7.9.1998 / 18:20:42 / cg"
!

doCropRight
    "find a right border and cut it off"

    imageEditView cropLeft:false right:true top:false bottom:false.   
    self updateInfoLabel

    "Created: / 7.9.1998 / 13:00:14 / cg"
    "Modified: / 7.9.1998 / 14:26:44 / cg"
!

doCropTop
    "find a top border and cut it off"

    imageEditView cropLeft:false right:false top:true bottom:false.   
    self updateInfoLabel

    "Created: / 7.9.1998 / 13:00:19 / cg"
    "Modified: / 7.9.1998 / 14:26:52 / cg"
!

doDarkenImage
    imageEditView darkenImage.
    self listOfColors removeAll.
    self findColorMapMode.     
    "/ imageEditView removelastUndo
!

doEditMask
    self image mask edit
!

doFlipHorizontal
    "flips horizontally current image"

    imageEditView flipHorizontal
!

doFlipVertical
    "flips vertically current image"

    imageEditView flipVertical
!

doInsertTextFromUser
    |text tempForm tempImage maskImage font w h paintColor|

    text := Dialog request:'Text to be inserted (placed as bitmap into clipboard for paste):'.
    text isEmptyOrNil ifTrue:[^ self ].

    font := Font family:'arial' size:20.
    font := font onDevice:Screen current.
    w := font widthOf:text.
    h := font heightOf:text.

    tempForm := Form extent:(w@h) depth:1 onDevice:(Screen current).
    tempForm clear.
    tempForm font:font.
    tempForm paint:(Color colorId:1).
    tempForm displayString:text at:(0@font ascent).

    tempImage := tempForm asImage.
    maskImage := tempForm asImage.

    paintColor := imageEditView selectedColor.
    paintColor  colorId == 0 ifTrue:[
        paintColor := Color black
    ].
    tempImage   
        photometric:#palette;
        colorMap:(Array 
                    with:Color white 
                    with:paintColor);
        mask:maskImage.

    ImageEditView copyImageToClipboard:tempImage.
    self editMode value:#paste.

    "Modified: / 11-11-2007 / 12:32:55 / cg"
!

doInspectImage
    "opens a System Browser on the resourceClass and the resourceSelector"

    self image inspect
!

doMagnifyDown
    "magnifies the current image one step down"

    |magHolder mag|

    magHolder := self magnificationHolder.
    (mag := magHolder value) > 1 ifTrue: [
        magHolder value: mag - 1
    ]

    "Modified: / 26.7.1998 / 20:24:08 / cg"
!

doMagnifyImage
    "magnifies the current image to a new size"

    |box newSize image antiAliased|

    antiAliased := false asValue.
    image := imageEditView image.

    box := EnterBox new.
    box title:(resources string:'Images new size:').
    box okText:(resources string:'OK').
    box abortText:(resources string:'Cancel').
    box initialText:image extent printString.
    box addCheckBox:(resources string:'Antialiased') on:antiAliased.
    box showAtPointer.

    (box accepted 
    and: [(newSize := self pointFromString:(box contents)) notNil])
    ifTrue:[
        newSize isPoint ifFalse:[
            self warn:'Please enter the new size as ''x @ y''.'.
            ^ self.    
        ].
        antiAliased value ifTrue:[
            imageEditView magnifyAntiAliasedImageTo:newSize.
        ] ifFalse:[
            imageEditView magnifyImageTo:newSize.
        ].
    ].

    self updateInfoLabel
!

doMagnifyImageBy
    "magnifies the current image (by a scale)"

    |oldSize newSize scaleString scale image antiAliased|

    image := imageEditView image.
    oldSize := image extent.

    antiAliased := false asValue.

    Dialog modifyingBoxWith:[:box |
        box addCheckBox:(resources string:'Antialiased') on:antiAliased.
    ] do:[
        scaleString := Dialog 
                   request:(resources string:'Scale factor (<1 to shrink; >1 to magnify):') 
                   initialAnswer:'1'
                   list:#('0.25' '0.5' '2' '4').     
    ].
    scaleString isNil ifTrue:[^ self].

"/    box := EnterBox new.
"/    box title:(resources string:'Scale factor (<1 to shrink; >1 to magnify):').
"/    box okText:(resources string:'OK').
"/    box abortText:(resources string:'Cancel').
"/    box initialText:1 printString.
"/    box showAtPointer.
"/    box accepted ifTrue:[
"/        scaleString := box contents.
"/    ].

    scale := Object readFromString:scaleString onError:nil.

    scale notNil ifTrue:[
        scale isNumber ifFalse:[
            self warn:'please enter a scale factor (<1 to shrink; >1 to magnify).'.
            ^ self.    
        ].
        newSize := oldSize * scale.
        antiAliased value ifTrue:[
            imageEditView magnifyAntiAliasedImageTo:newSize.
        ] ifFalse:[
            imageEditView magnifyImageTo:newSize.
        ].
    ].

    self updateInfoLabel
!

doMagnifyUp
    "magnifies the current image one step up"

    |magHolder mag|

    magHolder := self magnificationHolder.
    (mag := magHolder value) < 63 ifTrue: [
        magHolder value: mag + 1
    ]

    "Modified: / 26.7.1998 / 20:23:52 / cg"
!

doNegativeImage
    "negates current image by negating the color map"

    self image depth ~~ 1 ifTrue:[
        Dialog warn:'Only useful for depth 1 images'.
        ^ self
    ].
    imageEditView negativeImage.
    self listOfColors removeAll.
    self findColorMapMode.     
    "/ imageEditView removelastUndo
!

doResizeImage
    "resizes the current image"

    |box newSize image|

    image := imageEditView image.

    box := EnterBox new.
    box title:(resources string:'Images new size:').
    box okText:(resources string:'OK').
    box abortText:(resources string:'Cancel').
    box initialText:image extent printString.
    box showAtPointer.
    (box accepted 
    and: [(newSize := self pointFromString:(box contents)) notNil])
    ifTrue:[
        imageEditView resizeImageTo:newSize.
    ].
!

doRotateImage
    "rotates current image"

    |rotationString box rotation|

    rotationString := Dialog 
                        request:(resources string:'Rotate by (degrees, clockwise):')
                        list:#( '-90' '90' '180' '45' '-45'  '135' '-135' ) 
                        initialAnswer:90.
    rotationString isEmptyOrNil ifTrue:[^ self].    "/ cancelled
    rotation := Number readFrom:rotationString onError:[nil].
    rotation isNil ifTrue:[^ self].   

"/    box := EnterBox new.
"/    box title:(resources string:'Rotate by (degrees, clockwise):').
"/    box okText:(resources string:'OK').
"/    box abortText:(resources string:'Cancel').
"/    box initialText: '0'.
"/    box showAtPointer.
"/    (box accepted and: [(rotation := Number readFromString: box contents onError:nil) notNil])
"/    ifFalse:[ ^ self ].

    imageEditView rotateImageBy:rotation.
    self updateInfoLabel.

    "Modified: / 18-03-2012 / 14:41:14 / cg"
!

doShiftManual
    "let user specify amount and shift"

    |bindings amount img firstChange shiftAction acceptChannel wrapHolder|

    acceptChannel := TriggerValue new.
    wrapHolder := (lastShiftUsedWrap ? true) asValue.

    firstChange := true.

    shiftAction := 
        [:shiftH :shiftV | 
            acceptChannel value:true.

            img := imageEditView image.
            firstChange ifTrue:[
                imageEditView makeUndo.
                firstChange := false.
            ].
            imageEditView shiftImageHorizontal:(shiftH value) vertical:(shiftV value) wrap:(wrapHolder value).
            self updateInfoLabel
        ].

    bindings := IdentityDictionary new.
    bindings at:#shiftAmount put:(amount := 1 asValue).
    bindings at:#wrap put:wrapHolder.
    bindings at:#acceptChannel put:acceptChannel.

    bindings at:#shiftLeftNow   put:[ shiftAction value:(-1*amount value) value:0 ].
    bindings at:#shiftRightNow  put:[ shiftAction value:amount value value:0 ].
    bindings at:#shiftUpNow     put:[ shiftAction value:0 value:(-1*amount value) ].
    bindings at:#shiftDownNow   put:[ shiftAction value:0 value:amount value ].

    (self openDialogInterface:#shiftDialogSpec withBindings:bindings) 
    ifFalse:[ 
        firstChange ~~ true ifTrue:[
          imageEditView undo
        ]
    ].
    lastShiftUsedWrap := wrapHolder value.

    "Created: / 7.9.1998 / 18:16:07 / cg"
    "Modified: / 7.9.1998 / 18:20:42 / cg"
!

doUnCropManual
    "let user specify borders and add them"

    |bindings left top right bottom img|

    bindings := IdentityDictionary new.
    bindings at:#left put:(left := 1 asValue).
    bindings at:#right put:(right := 1 asValue).
    bindings at:#top put:(top := 1 asValue).
    bindings at:#bottom put:(bottom := 1 asValue).
    (self openDialogInterface:#uncropDialogSpec withBindings:bindings)
    ifTrue:[
        left := left value.
        right := right value.
        top := top value.
        bottom := bottom value.
        img := imageEditView image.

        imageEditView
            makeBorderedImageX:left y:top 
            width:(img width + left + right)
            height:(img height + top + bottom).
        self updateInfoLabel
    ].

    "Created: / 7.9.1998 / 18:16:07 / cg"
    "Modified: / 7.9.1998 / 18:20:42 / cg"
!

doUndo
    "reverses last edit action"

    imageEditView undo.
    self updateImagePreView
! !

!ImageEditor methodsFor:'user actions-image sequences'!

editEachImageFromSequence
    |seq|

    self checkModified ifFalse:[ ^ self ].

    imageEditView releaseUndos.

    seq := self image imageSequence.
    seq size > 10 ifTrue:[
        (Dialog confirm:(resources string:'Ok to open %1 image editor windows?' with:seq size)) 
            ifFalse:[^ self].
    ].

    seq do:[:eachFrame |
        ImageEditor openOnImage:eachFrame image
    ].

    "Modified: / 21-10-2010 / 15:01:25 / cg"
!

gotoImageInSequence:index
    "display the next image in the image sequence"

    |img seq frame listOfColors|

    imageEditView releaseUndos.

    seq := self image imageSequence.

    imageSeqNr := index.
    frame := seq at:imageSeqNr.
    imageEditView image:(frame image).

    (img := self image) notNil ifTrue:[          
        listOfColors := self listOfColors.
        img colorMap notNil ifTrue:[
            listOfColors contents:(img usedColors asSet asOrderedCollection).
        ] ifFalse:[
            listOfColors removeAll.
        ].
        self findColorMapMode.     
        self updateLabelsAndHistory.
        img := img onDevice:device.
        imageEditView image:img.
    ] ifFalse:[
        self updateForNoImage
    ].

    "Created: / 21-10-2010 / 14:22:11 / cg"
!

nextImageInSequence
    "display the next image in the image sequence"

    |seq index|

    seq := self image imageSequence.
    (index := imageSeqNr) isNil ifTrue:[
        index := 1.
    ].
    index := index + 1.
    index > seq size ifTrue:[
        self information:'Back to first image in sequence'.
        index := 1.
    ].
    self gotoImageInSequence:index.

    "Modified: / 21-10-2010 / 14:24:11 / cg"
!

previousImageInSequence
    "display the previous image in the image sequence"

    |seq index|

    seq := self image imageSequence.
    (index := imageSeqNr) isNil ifTrue:[
        index := 1.
    ].
    index := index - 1.
    index < 1 ifTrue:[
        self information:'Wrap to last image in sequence'.
        index := seq size.
    ].
    self gotoImageInSequence:index.

    "Created: / 21-10-2010 / 14:25:03 / cg"
! !

!ImageEditor methodsFor:'user actions-loading'!

doLoadFromClass
    "opens a dialog for loading an image from class and a (resource-) selector"

    |img|

    self checkModified ifFalse:[ ^ self ].

    (imageEditView loadFromClass) notNil ifTrue:[
        imageSeqNr := nil.
        (img := self image) notNil ifTrue: [
            self updateColorsFromImage:img.
            self findColorMapMode.
            self updateLabelsAndHistory.
        ] ifFalse: [
            self updateForNoImage
        ].
    ]
!

doLoadFromFile
    "opens a dialog for loading an image from a file"

    |img file filters title|

    self checkModified ifFalse:[ ^ self ].

    imageSeqNr := nil.
    img := self image.
    img notNil ifTrue: [
        file := img fileName
    ].

    title := (resources string:'Load Image From').

    (UserPreferences current useNativeFileDialog
     and:[Screen current isWindowsPlatform]) ifTrue:[
        self withWaitCursorDo:[
            file := Screen current
                nativeFileDialogFor:(self window topView id)
                save:false
                title:title
                inDirectory:(file notNil ifTrue:[file asFilename directory pathName] ifFalse:[LastDirectory])
                initialAnswer:(file notNil ifTrue:[file asFilename baseName] ifFalse:['image.png'])
                "/ flags:#( ENABLESIZING "HIDEREADONLY" EXPLORER NOCHANGEDIR)
                filter:
                  {
                          { (resources string:'Image Files') . '*.tif;*.png;*.gif;*.bmp;*.jpg'  } .
                          { (resources string:'All Files') . '*.*'  } 
                  }
                extension:nil
                "blocking:false".
        ].
    ] ifFalse:[    
        filters := FileSelectionBrowser loadImageFileNameFilters.
        file notNil ifTrue:[
            file := FileSelectionBrowser
                        request:title
                        fileName:file
                        withFileFilters:filters.
        ] ifFalse:[
            file := FileSelectionBrowser
                        request:title
                        inDirectory:LastDirectory
                        withFileFilters:filters.
        ].
    ].

    file notNil ifTrue:[
        LastDirectory := file asFilename directoryName.
        self loadFromFile:file
    ]

    "Modified: / 14-12-2010 / 13:52:11 / cg"
!

doLoadFromURL
    "opens a dialog for loading an image from a URL"

    |tempFile url response|

    self checkModified ifFalse:[ ^ self ].

    url := Dialog 
                request:(resources string:'Load Image from URL')
                initialAnswer:LastURL.

    url notEmptyOrNil ifTrue:[
        HTTPInterface isNil ifTrue:[ Smalltalk loadPackage:'stx:goodies/communication'].

        LastURL := url.
        tempFile := FileStream newTemporary close fileName.
        self withWaitCursorDo:[
            response := HTTPInterface get:url destinationFile:tempFile.
        ].
        response isErrorResponse ifTrue:[
            Dialog warn:(resources string:'Could not load image ("%1")' with:response responseText).
        ] ifFalse:[
            self loadFromFile:tempFile.
        ].
        tempFile delete
    ]

    "Created: / 20-09-2010 / 11:30:59 / cg"
!

doNewImage
    "opens a dialog with choices of size and color map for creating a new image"

    |dialogAspects width height cMapString cMapMode cMap imageClass image szString defaultSize ext|

    self checkModified ifFalse:[ ^ self ].

    defaultSize := (self class listOfDefaultSizes includes:'32x32') 
                        ifTrue:['32x32'] 
                        ifFalse:[self class listOfDefaultSizes first].

    dialogAspects  := IdentityDictionary new
        at:#listOfSizes         put: self class listOfDefaultSizes asValue;
        at:#listOfColorMaps     put: self class namesOfColorMaps values asSortedCollection asValue;
        at:#selectionOfSize     put: (LastSizeString ? defaultSize) asValue;
        at:#selectionOfColorMap put: (LastColormapMode ? self class namesOfColorMaps values asSortedCollection first) asValue;
        yourself.

    (self openDialogInterface:#dialogSpecForNewImage withBindings:dialogAspects)
    ifTrue:[
        szString := (dialogAspects at:#selectionOfSize) value.
        ext := self pointFromString:szString.
        ext isNil ifTrue:[
            width := height := 32
        ] ifFalse:[
            width := ext x.
            height := ext y.
        ].
"/        width  := "128 min: "(Integer readFromString: (szString upTo: $x) onError:[32]).
"/        height := "128 min: " (Integer readFromString: (szString copy reverse upTo: $x) reverse onError:[32]).

        cMapString := (dialogAspects at:#selectionOfColorMap) value.
        cMapMode   := self class namesOfColorMaps keyAtEqualValue:cMapString.
        cMap       := self class listOfColorMaps at:cMapMode.
        imageClass := Image implementorForDepth:(cMap size highBit-1).
        image      := imageClass width: width height: height.
        image bits:(ByteArray new:(image bytesPerRow*height)).

        LastSizeString := szString.
        LastColormapMode := cMapString.

        (cMapMode startsWith: 'mask') ifTrue:[
            image mask: (ImageMask width: width height: height depth: 1 fromArray: (ByteArray new: width*height)).
        ].
        image colorMap: cMap.
        (imageEditView image: image) notNil ifTrue:[
            self updateListOfColorsAndColormapMode.
            self updateLabelsAndHistory.
        ].
        image fillRectangleX:0 y:0 width:width height:height with:Color white.
    ]
!

doNewImageEditor
    "opens a new image editor"

    ImageEditor open

    "Created: / 17-08-2006 / 09:03:14 / cg"
!

doNewImageFromClipboard
    |image|

    self checkModified ifFalse:[ ^ self ].

    image := imageEditView clipBoard.
    image isImageOrForm ifFalse:[
        image := Image readFrom:(image asString) onError:nil.
        image isNil ifTrue:[
            Dialog warn:'Clipboard does not contain an image I can use/understand'.
            ^ self.
        ].
    ].
    imageEditView image:image.

    image notNil ifTrue:[
        self updateColorsFromImage:image.
        self findColorMapMode.
        self updateLabelsAndHistory.
    ]
!

doNewMaskFromClipboard
    |mask image newImage|

    self checkModified ifFalse:[ ^ self ].

    mask := imageEditView clipBoard.
    mask isImageOrForm ifFalse:[
        mask := Image readFrom:(mask asString) onError:nil.
        mask isNil ifTrue:[
            Dialog warn:'Clipboard does not contain an image I can use/understand'.
            ^ self.
        ].
    ].
    (image:= imageEditView image) isNil ifTrue:[
        image := mask.
    ].
    mask extent ~= image extent ifTrue:[
        mask := imageEditView resizedImage:mask to:image extent.
    ].
    newImage := image copy.
    newImage mask:mask.
    imageEditView newImageWithUndo:newImage.
    self updateAfterImageChange.
"/    self updateColorsFromImage:image.
"/    self findColorMapMode.
"/    self updateLabelsAndHistory.
!

grabScreenImage
    "let user choose an area and grab that are for editing"

    self grabScreenImageUsing:[ 
        |r|

        [Screen current leftButtonPressed] whileTrue:[Delay waitForSeconds:0.05].
        r := Rectangle fromUser.
        (r width == 0 or:[r height == 0]) ifTrue:[
            nil
        ] ifFalse:[
            lastGrabbedScreenArea := r.
            Image fromScreen:r
        ]
    ].
!

grabScreenImageFromLastArea
    "grab again from the previous area for editing"

    self grabScreenImageUsing:[ 
        Image fromScreen:lastGrabbedScreenArea
    ].
!

grabScreenImageUsing:aBlock
    "let user choose an area and grab that are for editing"

    self checkModified ifFalse:[ ^ self ].

    Processor 
        addTimedBlock:[
            |image d8image img|

            imageSeqNr := nil.
            image := aBlock value.
            image notNil ifTrue:[
                image depth > 8 ifTrue:[
false ifTrue:[
                    Error handle:[:ex | |sig|
                        (sig := ex creator) == HaltInterrupt ifTrue:[ex reject].
                        sig == Signal noHandlerSignal ifTrue:[ex reject].

                        self warn:'Could not convert to depth8 image (too many colors)'.
                        d8image := nil.
                    ] do:[
                        d8image := Depth8Image fromImage:image photometric:#palette.
                    ].
                    d8image notNil ifTrue:[
                        image := d8image
                    ]
].
                ].
                (imageEditView image:image) notNil ifTrue:[
                    self listOfColors contents:(image colorMap).
                    self findColorMapMode.
                    self updateLabelsAndHistory.
                ]
             ] 
        ] 
        afterSeconds:1

    "Created: / 29.7.1998 / 21:24:42 / cg"
    "Modified: / 16.11.2001 / 16:21:19 / cg"
!

grabWindowImage
    "let user choose an area and grab that are for editing"

    self grabScreenImageUsing:[
        |v topView|

        (v := Screen current viewFromUser) notNil ifTrue:[
            topView := v topView.
            topView raise; makeFullyVisible.
            Delay waitForSeconds:0.5.   "/ give view a chance to redraw itself.
            Image fromView:topView
        ].
    ].
! !

!ImageEditor methodsFor:'user actions-saving'!

doPrint
    "prints current image on the current printer"

    self withWaitCursorDo:[
        imageEditView print
    ]
!

doSaveButtonImageToFileAs
    "opens a dialog for saving current image to a file"

    imageEditView saveButtonImageToFileAs.
    self updateLabelsAndHistory.
!

doSaveImageFile
    "saves current image to current file"

    imageEditView save.
    self clearModified.
!

doSaveImageFileAs
    "opens a dialog for saving an image to a file"

    |img file filters|

    img := self image.
    img notNil ifTrue: [
        file := img fileName
    ].

    filters := FileSelectionBrowser saveImageFileNameFilters.

    (UserPreferences current useNativeFileDialog
     and:[Screen current isWindowsPlatform]) ifTrue:[
        self withWaitCursorDo:[
            file := Screen current
                nativeFileDialogFor:(self window topView id)
                save:true
                title:(resources string:'Save Image To')
                inDirectory:(file notNil ifTrue:[file asFilename directory pathName] ifFalse:[LastDirectory])
                initialAnswer:(file notNil ifTrue:[file asFilename baseName] ifFalse:['image.png'])
                "/ flags:#( ENABLESIZING "HIDEREADONLY" EXPLORER NOCHANGEDIR)
                filter:
                  {
                          { (resources string:'Image Files') . '*.tif;*.png;*.gif;*.bmp'  } .
                          { (resources string:'All Files') . '*.*'  } 
                  }
                extension:nil
                "blocking:false".
        ].
    ] ifFalse:[    
        (FileSelectionBrowser isNil or:[DirectoryView isNil]) ifTrue:[
            file notNil ifTrue:[
                file := Dialog requestFileName:'Save Image To'
                            default:file
                            pattern:(filters first).
            ] ifFalse:[
                file := Dialog
                            requestFileName:'Save Image To'
                            default:'image.png'
                            pattern:(filters first)
                            fromDirectory:LastDirectory.
            ].
        ] ifFalse:[
            file notNil ifTrue:[
                file := FileSelectionBrowser
                            request:'Save Image To'
                            fileName:file
                            withFileFilters:filters.
            ] ifFalse:[
                file := FileSelectionBrowser
                            request:'Save Image To'
                            inDirectory:LastDirectory
                            withFileFilters:filters.
            ].
        ].
    ].
    file notNil ifTrue:[
        imageEditView saveImageFileAs:file.
        LastDirectory := file asFilename directoryName.
        self updateLabelsAndHistory.
        self clearModified.
    ]

    "Modified: / 14-12-2010 / 13:51:47 / cg"
!

doSaveImageMaskFileAs
    "opens a dialog for saving mask of current image to a file"

    imageEditView saveImageMaskFileAs.
!

doSaveMethod
    "saves the image in current class and selector"

    imageEditView saveMethod ifTrue:[
        self updateLabelsAndHistory.
        self clearModified.
    ]
!

doSaveMethodAs
    "opens a dialog for saving current image on a class and a selector"

    imageEditView saveMethodAs ifTrue:[
        self updateLabelsAndHistory.
        self clearModified.
    ]
!

doShowPixelArrayLiteralString
    "opens a dialog showing a literal array-like storeString
     (sometimes useful to embed an image into source code)"

    |img|

    img := imageEditView image.
    TextBox openOn:img bits storeString
!

doShowStoreString
    "opens a dialog showing the storeString
     (sometimes useful to embed an image into source code)"

    |img|

    img := imageEditView image.
    TextBox openOn:img storeString
!

save
    "saves current image on current class and selector"

    self doSaveMethod
! !

!ImageEditor methodsFor:'user actions-settings'!

doChangeGridMagnification
    "change grid magnification"

    |box oldGridLimit newGridLimit|

    oldGridLimit := imageEditView class gridMagnificationLimit asPoint.

    box := EnterBox new.
    box title:(resources string:'Grid Magnification Limit:').
    box okText:(resources string:'OK').
    box abortText:(resources string:'Cancel').
    box initialText:(oldGridLimit x printString).
    box showAtPointer.

    (box accepted 
    and: [(newGridLimit := Number readFromString:(box contents) onError:[2]) notNil]
    ) ifTrue:[
        newGridLimit := (99 min: (2 max:newGridLimit)) asPoint.
        imageEditView class gridMagnificationLimit:newGridLimit.
        imageEditView invalidate
    ]

!

penWidth:n
    imageEditView penWidth:n

    "Created: / 01-11-2007 / 23:47:48 / cg"
!

penWidthHolderChanged
    imageEditView penWidth:(self penWidthHolder value)

    "Created: / 15-02-2012 / 22:32:00 / cg"
!

spraySpot:n
    imageEditView spraySpot:n

    "Created: / 01-11-2007 / 23:47:48 / cg"
!

spraySpotHolderChanged
    imageEditView spraySpot:(self spraySpotHolder value)

    "Created: / 15-02-2012 / 22:37:08 / cg"
! !

!ImageEditor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

