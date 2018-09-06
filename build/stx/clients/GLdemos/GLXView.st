"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Smalltalk }"

View subclass:#GLXView
	instanceVariableNames:'type'
	classVariableNames:'IdentityMatrix Black Red Green Yellow Blue Magenta Cyan White
		KnownObjects LastObjectId AllocatedColorSlots'
	poolDictionaries:''
	category:'Views-3D'
!

!GLXView class methodsFor:'documentation'!

documentation
"
    This view (and therefore all subclasses) support GLX type of
    3D rendering. This is a prototype implementation with just a
    few things implemented; to show how things could be and what is
    possible.

    GLXViews on non-SGI workstations will only support a subset
    of the GL functionality (i.e. no lighting, no Z-buffer, no textures
    etc.). The GL simulation used on those machines is based on the
    vogl PD library.

    To understand the individual methods, please refer to the GL programmers
    manual or the OpenGL documentation. Documentation for some functions is
    also found in the vogl documentation.

    Notice, not all possible functions (see GLXWorkstation) have been 
    implemented here - new ones will be added as required.
    (Actually, for every GL-method in GLXWorkstation, a corresponding
     method is required here.)

    written jun 93 by claus;
    many, many additional methods (for almost full set of graphic calls)
    dec 93 by jeff

    [author:]
	Claus Gittinger
	Jeff Mc. Affer

    [see also:]
	( 3D graphics using the GL library :html: programming/GL.html )

"
! !

!GLXView class methodsFor:'initialization'!

initialize
    super initialize.


    IdentityMatrix := FloatArray withAll:#(  1.0 0.0 0.0 0.0
                                             0.0 1.0 0.0 0.0
                                             0.0 0.0 1.0 0.0 
                                             0.0 0.0 0.0 1.0 ).

    self initializeGLResources.


    "want to be informed when returning from snapshot"
    ObjectMemory addDependent:self.

    "
     self initialize
    "

    "Modified: / 5.6.1998 / 13:44:01 / cg"
!

initializeGLResources
    "
     common color indices as class variables
     Notice: these could (in theory) be redefined using mapColor.
     however, it is recommended to leave those 8 colors unchanged.
     start private colors with index above 7
    "
    Black := 0.
    Red := 1.
    Green := 2.
    Yellow := 3.
    Blue := 4.
    Magenta := 5.
    Cyan := 6.
    White := 7.

    AllocatedColorSlots isNil ifTrue:[
        AllocatedColorSlots := ByteArray new:256.
        AllocatedColorSlots at:(Black+1)   put:1.
        AllocatedColorSlots at:(Red+1)     put:1.
        AllocatedColorSlots at:(Green+1)   put:1.
        AllocatedColorSlots at:(Blue+1)    put:1.
        AllocatedColorSlots at:(White+1)   put:1.
        AllocatedColorSlots at:(Yellow+1)  put:1.
        AllocatedColorSlots at:(Magenta+1) put:1.
        AllocatedColorSlots at:(Cyan+1)    put:1.
    ].

    KnownObjects isNil ifTrue:[
        KnownObjects := OrderedCollection new.
        LastObjectId := 0.
    ].
! !

!GLXView class methodsFor:'color management'!

allocateColorSlotFor:aColor
    "needed, since GL uses a single table for all views.
     (should be moved to the GL-device, since its really device
     specific)"

    |slot|

    "/ see, if its a standard color ...
    aColor = Color red ifTrue:[^ Red].
    aColor = Color green ifTrue:[^ Green].
    aColor = Color blue ifTrue:[^ Blue].
    aColor = Color white ifTrue:[^ White].
    aColor = Color black ifTrue:[^ Black].
    aColor = Color cyan ifTrue:[^ Cyan].
    aColor = Color magenta ifTrue:[^ Magenta].
    aColor = Color yellow ifTrue:[^ Yellow].

    "/ need a private slot ...
    slot := self nextFreeColorSlot.
    slot isNil ifTrue:[
        'GLX [info]: running out of colors' infoPrintCR.
        ^ nil
    ].

    self reserveColorSlot:slot.
    ^ slot

    "Created: / 5.6.1998 / 13:49:35 / cg"
!

freeColorSlot:idx
    AllocatedColorSlots at:idx+1 put:1.

    "Created: / 5.6.1998 / 13:45:31 / cg"
!

nextFreeColorSlot
    |idx|

    idx := AllocatedColorSlots indexOf:0.
    idx == 0 ifTrue:[^ nil].
    ^ idx - 1

    "Created: / 5.6.1998 / 13:45:05 / cg"
!

reserveColorSlot:idx
    AllocatedColorSlots at:idx+1 put:1.

    "Created: / 5.6.1998 / 13:45:28 / cg"
! !

!GLXView class methodsFor:'constants'!

identityMatrix
    ^ IdentityMatrix
! !

!GLXView class methodsFor:'constants - colors'!

black
    "return the index of the black color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Black
!

blue
    "return the index of the blue color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Blue
!

cyan 
    "return the index of the cyane color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Cyan
!

green
    "return the index of the green color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Green
!

magenta 
    "return the index of the magenta color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Magenta
!

numberOfStandardColors
    "0 ..7 should not be changed - they are standard"

    ^ 8

    "Created: 23.3.1996 / 19:07:14 / cg"
!

red
    "return the index of the red color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Red
!

white
    "return the index of the white color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ White
!

yellow
    "return the index of the yellow color - this has a predefined
     index in the colorMap. Only usefull for colorIndex modes."

    ^ Yellow
! !

!GLXView class methodsFor:'constants - materials'!

defaultMaterial
    ^ FloatArray withAll:#(
			   7.0 "ALPHA"      1.0             "/ 0.0 .. 1.0
			   2.0 "AMBIENT"    0.2  0.2  0.2   "/ 0.0 .. 1.0
			   3.0 "DIFFUSE"    0.8  0.8  0.8   "/ 0.0 .. 1.0
			   1.0 "EMISSION"   0.0  0.0  0.0   "/ 0.0 .. 1.0
			   4.0 "SPECULAR"   0.0  0.0  0.0   "/ 0.0 .. 1.0
			   5.0 "SHININESS"  0.0             "/ 0.0 .. 128.0
			   0.0 "END"
			  )
!

material_BluePlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.12  0.12  0.35
		4.0 "SPECULAR"   0.45  0.55  0.45
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )

!

material_Brass
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.35  0.25   0.1
		3.0 "DIFFUSE"    0.65  0.5    0.35
		4.0 "SPECULAR"   0.0   0.0    0.0
		5.0 "SHININESS"  5.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )


!

material_BrownPolstone
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.1   0.1   0.0
		4.0 "SPECULAR"   0.627 0.627 0.627
		3.0 "DIFFUSE"    0.208 0.04  0.0
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  60.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )

!

material_CyanPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.1   0.06
		3.0 "DIFFUSE"    0.0   0.51  0.51
		4.0 "SPECULAR"   0.5   0.5   0.5
		5.0 "SHININESS"  40.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_Gold
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.4   0.2   0.0
		3.0 "DIFFUSE"    0.9   0.5   0.0
		4.0 "SPECULAR"   0.7   0.7   0.0
		5.0 "SHININESS"  10.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )
!

material_GreenPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.1   0.35  0.1
		4.0 "SPECULAR"   0.45  0.55  0.45
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_GreyPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.15  0.15  0.15
		4.0 "SPECULAR"   0.6   0.6   0.6
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_Lapis
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.9
		4.0 "SPECULAR"   0.56  0.54  0.73
		3.0 "DIFFUSE"    0.01  0.01  0.18
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  44.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )

!

material_Lavpolstone
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.1   0.0   0.12
		4.0 "SPECULAR"   0.97  0.59  0.94
		3.0 "DIFFUSE"    0.33  0.04  0.37
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  54.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )

!

material_Pewter
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.1   0.1   0.1
		3.0 "DIFFUSE"    0.6   0.55  0.65
		4.0 "SPECULAR"   0.9   0.9   0.95
		5.0 "SHININESS"  10.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )




!

material_PinkPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.1   0.0   0.06
		3.0 "DIFFUSE"    0.47  0.0   0.196
		4.0 "SPECULAR"   0.5   0.5   0.5
		5.0 "SHININESS"  40.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_Plaster
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.2   0.2   0.2
		3.0 "DIFFUSE"    0.95  0.95  0.95
		4.0 "SPECULAR"   0.0   0.0   0.0
		5.0 "SHININESS"  1.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )
!

material_RedPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.5   0.0   0.0
		4.0 "SPECULAR"   0.7   0.6   0.6
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_RedRubber
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.05
		4.0 "SPECULAR"   0.5   0.5   0.5
		3.0 "DIFFUSE"    0.7   0.04  0.05
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  10.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )


!

material_ShinyBrass
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.25  0.15  0.0
		3.0 "DIFFUSE"    0.65  0.5   0.35
		4.0 "SPECULAR"   0.9   0.6   0.0
		5.0 "SHININESS"  10.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )


!

material_ShinyBronze
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.1   0.0   0.02
		4.0 "SPECULAR"   1.0   0.545 0.275
		3.0 "DIFFUSE"    0.30  0.12  0.06
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  70.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )


!

material_ShinyGold
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.4   0.2   0.0
		3.0 "DIFFUSE"    0.9   0.5   0.0
		4.0 "SPECULAR"   0.9   0.9   0.0
		5.0 "SHININESS"  20.0
		7.0 "ALPHA"      0.2
		0.0 "END"
      )
!

material_Silver
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.4   0.4   0.4
		3.0 "DIFFUSE"    0.3   0.3   0.3
		4.0 "SPECULAR"   0.9   0.9   0.95
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )
!

material_Wall
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.4   0.4   0.4
		4.0 "SPECULAR"   0.1   0.1   0.1
		3.0 "DIFFUSE"    0.6   0.6   0.6
		1.0 "EMISSION"   0.0   0.0   0.0
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      0.0
		0.0 "END"
      )

!

material_WhitePlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.55  0.55  0.55
		4.0 "SPECULAR"   0.7   0.7   0.7
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )

!

material_YellowPlastic
    ^ FloatArray withAll:#(

		2.0 "AMBIENT"    0.0   0.0   0.0
		3.0 "DIFFUSE"    0.5   0.5   0.0
		4.0 "SPECULAR"   0.6   0.6   0.6
		5.0 "SHININESS"  30.0
		7.0 "ALPHA"      1.0
		0.0 "END"
      )

! !

!GLXView class methodsFor:'start'!

checkForGLDrawing
    "check if device supports GL drawing;
     if not, open a warnBox and return false.
     Otherwise, return true."

    |msg screen|

    (screen := Screen current) supportsGLDrawing ifFalse:[
        (screen isKindOf:GLXWorkstation) ifFalse:[
            msg := 'sorry, but this view requires a display capable of GL drawing'.
        ] ifTrue:[
            msg := 'sorry, but GL drawing is not possible (on remote display)'.
        ].
        self warn:msg.
        ^ false.
    ].
    ^ true
!

defaultIcon
    ^ Image fromFile:'GLX.xbm'
!

defaultIconLabel
    ^ self defaultLabel

    "Created: 19.7.1996 / 22:22:45 / cg"
!

defaultLabel
    ^ 'a GLXView'
!

defaultMaxExtent
    ^ self defaultExtent
!

defaultMinExtent
    ^ self defaultExtent
!

isVisualStartable
    ^ self ~~ GLXView


!

open
    "default open for GLX views: create a standardSystemView around,
     and open that one"

    |top v|

    (self checkForGLDrawing) ifFalse:[
        ^ nil.
    ].

    top := StandardSystemView new.
    top extent:(self defaultExtent).
    top minExtent:(self defaultMinExtent).
    top maxExtent:(self defaultMaxExtent).
    top label:(self defaultLabel).
    top icon:(self defaultIcon).
    top iconLabel:(self defaultIconLabel).
    v := self in:top.
    v origin:0@0 extent:1.0@1.0.
    top open.
    ^ v

    "Modified: 19.7.1996 / 22:22:36 / cg"
! !

!GLXView class methodsFor:'system restart'!

update:something with:parameter from:changedObject
    (something == #returnFromSnapshot) ifTrue:[
       "/ flush my view of allocated objects.
        self initializeGLResources
    ]
! !

!GLXView methodsFor:'events '!

configureX:x y:y width:w height:h
    "view was resized - have to tell GL about it"

    super configureX:x y:y width:w height:h.
    device glxReshapeViewPortIn:drawableId.
!

mapped 
    super mapped.

    device supportsGLDrawing ifFalse:[^ self].

    self redraw.
    (type == #colorIndexDoubleBuffer 
    or:[type == #rgbDoubleBuffer]) ifTrue:[
	self redraw
    ]

    "Modified: / 27.7.1998 / 20:14:25 / cg"
!

sizeChanged:how
    "view was resized - have to tell GL about it"

    super sizeChanged:how.
    device glxResizedView:drawableId width:width height:height.
    device glxReshapeViewPortIn:drawableId.

    "Created: / 5.2.1998 / 13:52:37 / cg"
    "Modified: / 5.2.1998 / 16:49:06 / cg"
!

unmapped 
    super unmapped.

    device supportsGLDrawing ifTrue:[
        device isTrueGL ifTrue:[
            "/ since we never get any mapped event,
            "/ (due to a bug in GL/VGL), keep shown as true
            shown := true
        ]
    ]

    "Modified: / 27.7.1998 / 20:13:56 / cg"
! !

!GLXView methodsFor:'initialization'!

initialize
    super initialize.
    type := #colorIndexSingleBuffer
!

setType:aTypeSymbol 
    "set the views type; the argument, aTypeSymbol may be any of:
	 #colorIndexSingleBuffer   
	 #colorIndexDoubleBuffer
	 #rgbSingleBuffer
	 #rgbDoubleBuffer

     VOGL only supports the colorIndex types.
    "

    type := aTypeSymbol
! !

!GLXView methodsFor:'low level colors'!

color:index
    "set color, for non gouraud shading, we dont care if the
     argument is integer or float; otherwise, better results are
     expected with float values."

    ^ device glxColor:index in:drawableId
!

colorRed:r green:g blue:b
    "set color, args must be integers in 0..255"

    ^ device glxColorRed:r green:g blue:b in:drawableId
!

colorRed:r green:g blue:b alpha:a
    "set color, args must be integers in 0..255"

    ^ device glxColorRed:r green:g blue:b alpha:a in:drawableId
!

mapColor:index red:red green:green blue:blue
    "assign a color to a color index"

    ^ device glxMapcolorI:index red:red green:green blue:blue in:drawableId
! !

!GLXView methodsFor:'low level data transfer'!

c3f:arrayOf3FloatsWithColor
    "load color (r, g, b) vector"

    ^ device glxC3f:arrayOf3FloatsWithColor in:drawableId
!

n3f:arrayOf3FloatsWithNormal
    "load vertex normal"

    ^ device glxN3f:arrayOf3FloatsWithNormal in:drawableId
!

t2f:arrayOf2Floats
    "load texture coordinate from an array"

    ^ device glxT2f:arrayOf2Floats in:drawableId
!

v2f:arrayOf2Floats
    "load vertex from an array; z is taken as 0.0"

    ^ device glxV2f:arrayOf2Floats in:drawableId
!

v2fX:x y:y 
    "load vertex from individual x, y coordinates; z is taken as 0.0.
     If the x/y values are computed, this avoids the creation
     of a temporary array."

    ^ device glxV2fX:x y:y in:drawableId
!

v3f:arrayOf3Floats
    "load vertex from an array"

    ^ device glxV3f:arrayOf3Floats in:drawableId
!

v3fX:x y:y z:z
    "load vertex from individual x, y and z coordinates.
     If the x/y/z values are computed, this avoids the creation
     of a temporary array."

    ^ device glxV3fX:x y:y z:z in:drawableId
!

vOrigin
    "load 0/0/0 vertex.
     This is the same as v3f:#(0 0 0), but sligtly faster.
     Provided since its a very common vertex."

    ^ device glxVOriginIn:drawableId
!

vUnitX
    "load 1/0/0 vertex.
     This is the same as v3f:#(1 0 0), but sligtly faster.
     Provided since its a very common vertex."

    ^ device glxVUnitXIn:drawableId
!

vUnitY
    "load 0/1/0 vertex.
     This is the same as v3f:#(0 1 0), but sligtly faster.
     Provided since its a very common vertex."

    ^ device glxVUnitYIn:drawableId
!

vUnitZ
    "load 0/0/1 vertex.
     This is the same as v3f:#(0 0 1), but sligtly faster.
     Provided since its a very common vertex."

    ^ device glxVUnitZIn:drawableId
! !

!GLXView methodsFor:'low level lights'!

lmbind:target index:index
    "select a material, light or lighting model"

    ^ device glxLmbind:target index:index in:drawableId
!

lmdef:what index:index np:np props:props
    "define a material, light source or lighting model;
     props must be a FloatArray"

    ^ device glxLmdef:what index:index np:np props:props in:drawableId
! !

!GLXView methodsFor:'low level matrix operations'!

getMatrix:arrayOf16Floats
    "get matrix from top of matrix stack"

    ^ device glxGetMatrix:arrayOf16Floats in:drawableId
!

loadIdentityMatrix
    "load identity matrix into top of matrix stack"

    ^ device glxLoadMatrix:IdentityMatrix in:drawableId
!

loadMatrix:arrayOf16Floats
    "load a transformation matrix into top of matrix stack"

    ^ device glxLoadMatrix:arrayOf16Floats in:drawableId
!

multMatrix:arrayOf16Floats
    "multiplication matrix"

    ^ device glxMultMatrix:arrayOf16Floats in:drawableId
!

popMatrix
    "pop transformation matrix stack"

    ^ device glxPopmatrixIn:drawableId
!

pushMatrix
    "push down transformation matrix stack"

    ^ device glxPushmatrixIn:drawableId
! !

!GLXView methodsFor:'low level misc'!

backBuffer
    "switch to backbuffer"

    ^ device glxBackBufferIn:drawableId
!

backFace:aBoolean
    "enable/disable backface culling"

    ^ device glxBackface:aBoolean in:drawableId
!

clear
    "clear to current color"

    ^ device glxClearIn:drawableId
!

czClearColor:colorValue z:zValue
    "clear the z buffer"

    ^ device glxCzclearCval:colorValue zval:zValue in:drawableId
!

doubleBuffer
    "set double buffer mode"

    ^ device glxDoubleBufferIn:drawableId
!

frontBuffer
    "switch to frontbuffer"

    ^ device glxFrontBufferIn:drawableId
!

mMode:aSymbol 
    "set the matrix mode. The argument must be one of
     #single, #viewing, #projection or #texture."

    ^ device glxMmode:aSymbol in:drawableId 
!

nMode:aSymbol 
    "set normal mode. The argument must be one of #auto or #normalize."

    ^ device glxNmode:aSymbol in:drawableId 
!

polyFill:aBoolean
    "enable/disable polygon filling"

    ^ device glxPolyFill:aBoolean in:drawableId
!

rgbMode
    "set true color mode (no colormap)"

    ^ device glxRGBmodeIn:drawableId
!

setConfig
    "must be sent after RGBmode, doubleBuffer etc. to have these
     changes really take effect. See GLX manual"

    ^ device glxGconfigIn:drawableId
!

singleBuffer
    "set single buffer mode"

    ^ device glxSingleBufferIn:drawableId
!

swapBuffers
    "swap double buffers"

    ^ device glxSwapBuffersIn:drawableId
!

zBuffer:aBoolean
    "enable/disable z buffer mode"

    ^ device glxZbuffer:aBoolean in:drawableId
!

zClear
    "clear the z buffer"

    ^ device glxZClearIn:drawableId
! !

!GLXView methodsFor:'low level objects'!

callObject:id
    "perform commands from an object"

    ^ device glxCallObject:id in:drawableId
!

closeObject
    "end an object definition"

    ^ device glxCloseObjectIn:drawableId
!

deleteObject:id
    "delete an object definition"

    KnownObjects remove:id ifAbsent:[].
    ^ device glxDeleteObject:id in:drawableId
!

makeObject:id
    "start an object definition"

    KnownObjects add:id.
    ^ device glxMakeObject:id in:drawableId
!

newObjectId
    "return a new unique object id for
     makeObject"

    |id|

    id := LastObjectId + 1.
    LastObjectId := id.
    ^ id
! !

!GLXView methodsFor:'low level patches'!

defBasis:id mat:matrix
    ^ device glxDefBasis:id mat:matrix in:drawableId
!

patchBasisU:u v:v
    ^ device glxPatchBasisU:u v:v in:drawableId
!

patchCurvesU:u v:v
    ^ device glxPatchCurvesU:u v:v in:drawableId
!

patchPrecisionU:u v:v
    ^ device glxPatchPrecisionU:u v:v in:drawableId
!

patchX:arrayOf16XFloats y:arrayOf16YFloats z:arrayOf16ZFloats
    "draw a patch"

    ^ device glxPatchX:arrayOf16XFloats 
		     y:arrayOf16YFloats 
		     z:arrayOf16ZFloats in:drawableId
! !

!GLXView methodsFor:'low level polygons'!

arcX:x y:y radius:r startAngle:startang endAngle:endang
    "draw an arc"

    ^ device glxArcX:x y:y radius:r startang:startang endang:endang in:drawableId
!

arcfX:x y:y radius:r startAngle:startang endAngle:endang
    "draw a filled arc"

    ^ device glxArcX:x y:y radius:r startang:startang endang:endang in:drawableId
!

beginClosedLine 
    "start a closed line"

    ^ device glxBeginClosedLineIn:drawableId
!

beginCurve 
    "start a NURBS curve def"

    ^ device glxBeginCurveIn:drawableId
!

beginLine 
    "start a line group"

    ^ device glxBeginLineIn:drawableId
!

beginPoint 
    "start a point"

    ^ device glxBeginPointIn:drawableId
!

beginPolygon 
    "start a polygon"

    ^ device glxBeginPolygonIn:drawableId
!

beginQuadrilateralStrip 
    "start a quadrilateral strip"

    ^ device glxBeginQuadrilateralStripIn:drawableId
!

beginSurface 
    "start a NURBS surface def"

    ^ device glxBeginSurfaceIn:drawableId
!

beginTriangleMesh 
    "start a triangle mesh"

    ^ device glxBeginTriangleMeshIn:drawableId
!

circleX:x y:y radius:r
    "draw a circle"

    ^ device glxCircX:x y:y radius:r in:drawableId
!

circlefX:x y:y radius:r
    "draw a filled circle"

    ^ device glxCircfX:x y:y radius:r in:drawableId
!

draw:a3DPoint
    "draw to a position"

    ^ device glxDraw:a3DPoint in:drawableId
!

drawX:x y:y z:z
    "draw to a position"

    ^ device glxDrawX:x y:y z:z in:drawableId
!

endClosedLine 
    "end a closed line"

    ^ device glxEndClosedLineIn:drawableId
!

endCurve
    "end a NURBS curve def"

    ^ device glxEndCurveIn:drawableId
!

endLine 
    "end a line group"

    ^ device glxEndLineIn:drawableId
!

endPoint 
    "end a point"

    ^ device glxEndPointIn:drawableId
!

endPolygon 
    "end a polygon"

    ^ device glxEndPolygonIn:drawableId
!

endQuadrilateralStrip
    "end a quadrilateral strip"

    ^ device glxEndQuadrilateralStripIn:drawableId
!

endSurface
    "end a NURBS surface def"

    ^ device glxEndSurfaceIn:drawableId
!

endTriangleMesh 
    "end a triangle mesh"

    ^ device glxEndTriangleMeshIn:drawableId
!

move:a3DPoint
    "move to a position"

    ^ device glxMove:a3DPoint in:drawableId
!

moveX:x y:y z:z
    "move to a position"

    ^ device glxMoveX:x y:y z:z in:drawableId
!

rdr:a3DPoint
    "draw to a position"

    ^ device glxRdr:a3DPoint in:drawableId
!

rdrX:x y:y z:z
    "draw to a position"

    ^ device glxRdrX:x y:y z:z in:drawableId
!

rectangleOrigin:p1 corner:p2
    "draw a rectangle"

    ^ device glxRectX1:(p1 x) y1:(p1 y) x2:(p2 x) y2:(p2 y) in:drawableId
!

rectangleX1:x1 y1:y1 x2:x2 y2:y2
    "draw a rectangle"

    ^ device glxRectX1:x1 y1:y1 x2:x2 y2:y2 in:drawableId
!

rmv:a3DPoint
    "relative move to a position"

    ^ device glxRmv:a3DPoint in:drawableId
!

rmvX:x y:y z:z
    "move to a position"

    ^ device glxRmvX:x y:y z:z in:drawableId
!

swapTriangleMesh 
    "swap triangle mesh pointers"

    ^ device glxSwaptmeshIn:drawableId
! !

!GLXView methodsFor:'low level spheres'!

sphDraw:arrayOf4Floats
    "draw a solid sphere (only on a real GL).
     The argument vector contains x,y,z and radius."

    ^ device glxSphDraw:arrayOf4Floats in:drawableId
!

sphDrawX:x y:y z:z radius:r
    "draw a solid sphere (only on a real GL)."

    ^ device glxSphDrawX:x y:y z:z radius:r in:drawableId
!

sphWireDraw:arrayOf4Floats    
    "draw a wireframe sphere.
     The argument vector contains x,y,z and radius."

    |radius r a z step|

    device glxPushmatrixIn:drawableId.
    self translate:arrayOf4Floats.  "/ only the first 3 elements are used
    radius := arrayOf4Floats at:4.

    "
     create the latitudinal rings
    "
    0 to:180 by:20 do:[:i |
	device glxPushmatrixIn:drawableId.
	device glxRotateY:i in:drawableId.
	self arcX:0.0 y:0.0 radius:radius startAngle:0 endAngle:3599.
	device glxPopmatrixIn:drawableId.
    ].

    "
     create the longitudinal rings
    "
    device glxRotateX:90 in:drawableId. 
    -900 to:899 by:200 do:[:i |
	|t|

	t := (i * 3.14159 / 180.0).
	r := radius * t cos.
	z := radius * t sin.
	device glxPushmatrixIn:drawableId.
	device glxTranslateZ:z negated in:drawableId.
	self arcX:0.0 y:0.0 radius:r startAngle:0 endAngle:3599.
	device glxPopmatrixIn:drawableId.    
    ].                    
    device glxPopmatrixIn:drawableId.
! !

!GLXView methodsFor:'low level textures'!

tevbind:target index:index
    ^ device glxTevbind:target index:index in:drawableId
!

tevdef:index np:np props:props
    ^ device glxTevdef:index np:np props:props in:drawableId
!

texbind:target index:index
    ^ device glxTexbind:target index:index in:drawableId
!

texdef2d:index nc:nc width:w height:h bits:image np:np props:props 
    ^ device glxTexDef2d:index 
		      nc:nc 
		   width:w height:h bits:image 
		      np:np props:props in:drawableId
! !

!GLXView methodsFor:'low level transformations'!

rotate:a3ElementVector
    "rotate current matrix, given a float-vector."

    ^ device glxTranslate:a3ElementVector in:drawableId
!

rotate:angle axis:axis
    "rotate the current matrix around an axis.
     The angle is in degrees.
     The axis argument must be one of the symbols #x, #y or #z"

    ^ device glxRotate:angle axis:axis in:drawableId
!

rotateIX:angle
    "rotate the current matrix around x axis.
     The angle must be integer (in tenth of degrees)."

    ^ device glxRotateIX:angle in:drawableId
!

rotateIX:xAngle y:yAngle z:zAngle
    "rotate the current matrix, given individual x, y and z values.
     The angles must be integers, specifying tenths of degrees."

    ^ device glxRotateIX:xAngle y:yAngle z:zAngle in:drawableId
!

rotateIY:angle
    "rotate the current matrix around y axis.
     The angle must be integer (in tenth of degrees)."

    ^ device glxRotateIY:angle in:drawableId
!

rotateIZ:angle
    "rotate the current matrix around z axis.
     The angle must be integer (in tenth of degrees)."

    ^ device glxRotateIZ:angle in:drawableId
!

rotateX:angle
    "rotate the current matrix around x axis.
     The angle is in degrees."

    ^ device glxRotateX:angle in:drawableId
!

rotateX:xAngle y:yAngle z:zAngle
    "rotate the current matrix, given individual x, y and z values.
     The angles are in degrees."

    ^ device glxRotateX:xAngle y:yAngle z:zAngle in:drawableId
!

rotateY:angle
    "rotate the current matrix around y axis.
     The angle is in degrees."

    ^ device glxRotateY:angle in:drawableId
!

rotateZ:angle
    "rotate the current matrix around z axis.
     The angle is in degrees."

    ^ device glxRotateZ:angle in:drawableId
!

scale:a3ElementVector
    "scale current matrix, given a float-vector."

    ^ device glxScale:a3ElementVector in:drawableId
!

scaleX:x y:y z:z
    "scale & mirror current matrix, given individual x, y and z values."

    ^ device glxScaleX:x y:y z:z in:drawableId
!

translate:a3ElementVector
    "translate current matrix, given a float-vector."

    ^ device glxTranslate:a3ElementVector in:drawableId
!

translateX:x 
    "translate current matrix, given an x value. Y and z are taken as 0"

    ^ device glxTranslateX:x in:drawableId
!

translateX:x y:y z:z
    "translate current matrix, given individual x, y and z values."

    ^ device glxTranslateX:x y:y z:z in:drawableId
!

translateY:y 
    "translate current matrix, given a y value. X and z are taken as 0"

    ^ device glxTranslateY:y in:drawableId
!

translateZ:z
    "translate current matrix, given a z value. X and y are taken as 0"

    ^ device glxTranslateZ:z in:drawableId
! !

!GLXView methodsFor:'low level viewing setup'!

lookatVx:vx vy:vy vz:vz px:px py:py pz:pz twist:twist
    "define viewing transformation.
     Setup is for eye position at vx/vy/vz, looking at px/py/pz;
     with a twist"

    ^ device glxLookatVx:vx vy:vy vz:vz 
		      px:px py:py pz:pz 
		   twist:twist
		      in:drawableId
!

perspectiveFovy:fovy aspect:aspect near:near far:far
    "define perspective projection.
     fovy is the field of view in y, given in 10th of degrees;
     aspect is the x/y aspect ratio;
     near and far define the z clipping bounds."

    ^ device glxPerspectiveFovy:fovy aspect:aspect near:near far:far in:drawableId
!

windowLeft:left right:right top:top bottom:bottom near:near far:far 
    "define viewing transformation"

    ^ device glxWindowLeft:left right:right 
		       top:top bottom:bottom 
		      near:near far:far 
			in:drawableId
! !

!GLXView methodsFor:'medium level shapes'!

drawBoxX0:ix0 y0:iy0 z0:iz0 x1:ix1 y1:iy1 z1:iz1 type:type
    "draw an axis aligned rectangluare box with given x,y and z ranges."

    |normals faces v x0 y0 x1 y1 z0 z1 bgn end|

    type == #quads ifTrue:[
	bgn := #beginQuadrilateralStrip.
	end := #endQuadrilateralStrip.
    ] ifFalse:[
	type == #flat ifTrue:[
	    bgn := #beginPolygon.
	    end := #endPolygon.
	] ifFalse:[
	    bgn := #beginClosedLine.
	    end := #endClosedLine.
	]
    ].

    normals := #(                  "/ normals
		 (-1.0  0.0  0.0)
		 ( 0.0  1.0  0.0)
		 ( 1.0  0.0  0.0)
		 ( 0.0 -1.0  0.0)
		 ( 0.0  0.0  1.0)
		 ( 0.0  0.0 -1.0) 
	       ).

    faces := #(                    "/ the faces defined by 
		 (1 2 3 4)         "/ the corner point indices
		 (4 3 7 8)
		 (8 7 6 5)
		 (5 6 2 1)
		 (6 7 3 2)
		 (8 5 1 4)
	      ).

    "/ make certain, that [xyz]0 is smaller than correspondung [xyz]1

    (ix0 > ix1) ifTrue:[
	x0 := ix1. x1 := ix0
    ] ifFalse:[
	x0 := ix0. x1 := ix1
    ].
    (iy0 > iy1) ifTrue:[
	y0 := iy1. y1 := iy0
    ] ifFalse:[
	y0 := iy0. y1 := iy1
    ].
    (iz0 > iz1) ifTrue:[
	z0 := iz1. z1 := iz0
    ] ifFalse:[
	z0 := iz0. z1 := iz1
    ].

    v := Array new:8.
    1 to:8 do:[:i | v at:i put:(Array new:3)].

    (v at:1) at:1 put: x0.
    (v at:2) at:1 put: x0.
    (v at:3) at:1 put: x0.
    (v at:4) at:1 put: x0.

    (v at:5) at:1 put: x1.
    (v at:6) at:1 put: x1.
    (v at:7) at:1 put: x1.
    (v at:8) at:1 put: x1.

    (v at:1) at:2 put: y0.
    (v at:2) at:2 put: y0.
    (v at:5) at:2 put: y0.
    (v at:6) at:2 put: y0.

    (v at:3) at:2 put: y1.
    (v at:4) at:2 put: y1.
    (v at:7) at:2 put: y1.
    (v at:8) at:2 put: y1.

    (v at:1) at:3 put: z0.
    (v at:4) at:3 put: z0.
    (v at:5) at:3 put: z0.
    (v at:8) at:3 put: z0.

    (v at:2) at:3 put: z1.
    (v at:3) at:3 put: z1.
    (v at:6) at:3 put: z1.
    (v at:7) at:3 put: z1.

    1 to:6 do:[:i |
	self perform:bgn.
	self n3f:(normals at:i).
	self v3f:(v at:((faces at:i) at:1)).

	self n3f:(normals at:i).
	self v3f:(v at:((faces at:i) at:2)).

	self n3f:(normals at:i).
	self v3f:(v at:((faces at:i) at:3)).

	self n3f:(normals at:i).
	self v3f:(v at:((faces at:i) at:4)).

	self perform:end
    ]

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:60.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     'v drawBoxX0:-1 y0:-1 z0:-1 x1:1 y1:1 z1:1 type:#lines'. 
     'v drawBoxX0:-1 y0:-1 z0:-1 x1:1 y1:1 z1:1 type:#flat   '.
     v drawBoxX0:-1 y0:-1 z0:-1 x1:1 y1:1 z1:1 type:#quads.
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:33:10 / claus"
!

drawDoughnutMajorRadius:R minorRadius:r sides:nsides rings:nrings type:type
    "draw a doughnut at 0/0/0."

    |rCosPhi rRCosPhi cosPhi cosPhi1 
     cosTheta cosTheta1 sinTheta sinTheta1 sinPhi sinPhi1
     theta phi theta1 phi1
     p0 p1 p2 p3 n0 n1 n2 n3 bgn end|

    type == #quads ifTrue:[
	bgn := #beginQuadrilateralStrip.
	end := #endQuadrilateralStrip.
    ] ifFalse:[
	type == #flat ifTrue:[
	    bgn := #beginPolygon.
	    end := #endPolygon.
	] ifFalse:[
	    bgn := #beginClosedLine.
	    end := #endClosedLine.
	]
    ].

    p0 := Array new:3.
    p1 := Array new:3.
    p2 := Array new:3.
    p3 := Array new:3.
    n0 := Array new:3.
    n1 := Array new:3.
    n2 := Array new:3.
    n3 := Array new:3.

    0 to:nrings-1 do:[:i |
	theta := (i*2.0*(Float pi))/nrings.
	theta1 := ((i+1)*2.0*(Float pi))/nrings.
	0 to:nsides-1 do:[:j |
	    phi := (j*2.0*(Float pi))/nsides.
	    phi1 := ((j+1)*2.0*(Float pi))/nsides.

	    cosPhi := phi cos.
	    cosPhi1 := phi1 cos.
	    sinPhi := phi sin.
	    sinPhi1 := phi1 sin.
	    rCosPhi := r * cosPhi.
	    rRCosPhi := R + rCosPhi.
	    cosTheta := theta cos.
	    cosTheta1 := theta1 cos.
	    sinTheta := theta sin.
	    sinTheta1 := theta1 sin.

	    p0 at:1 put:(cosTheta * rRCosPhi).
	    p0 at:2 put:(sinTheta negated * rRCosPhi).
	    p0 at:3 put:(sinPhi * r).

	    p1 at:1 put:(cosTheta1 * rRCosPhi).
	    p1 at:2 put:(sinTheta1 negated * rRCosPhi).
	    p1 at:3 put:(sinPhi * r).

	    rCosPhi := r * cosPhi1.
	    rRCosPhi := R + rCosPhi.

	    p2 at:1 put:(cosTheta1 * rRCosPhi).
	    p2 at:2 put:(sinTheta1 negated * rRCosPhi).
	    p2 at:3 put:(sinPhi1 * r).

	    p3 at:1 put:(cosTheta * rRCosPhi).
	    p3 at:2 put:(sinTheta negated * rRCosPhi).
	    p3 at:3 put:(sinPhi1 * r).

	    n0 at:1 put:(cosTheta * cosPhi).
	    n0 at:2 put:(sinTheta negated * cosPhi).
	    n0 at:3 put:sinPhi.

	    n1 at:1 put:(cosTheta1 * cosPhi).
	    n1 at:2 put:(sinTheta1 negated * cosPhi).
	    n1 at:3 put:sinPhi.

	    n2 at:1 put:(cosTheta1 * cosPhi1).
	    n2 at:2 put:(sinTheta1 negated * cosPhi1).
	    n2 at:3 put:sinPhi1.

	    n3 at:1 put:(cosTheta * cosPhi1).
	    n3 at:2 put:(sinTheta negated * cosPhi1).
	    n3 at:3 put:sinPhi1.

	    self perform:bgn.

	    self n3f:n3.
	    self v3f:p3.

	    self n3f:n2.
	    self v3f:p2.

	    self n3f:n1.
	    self v3f:p1.

	    self n3f:n0.
	    self v3f:p0.

	    self perform:end
	]
    ]

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:30.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     v drawDoughnutMajorRadius:1 minorRadius:0.5 sides:10 rings:10 type:#lines 
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:52:52 / claus"
!

drawSolidBoxX0:ix0 y0:iy0 z0:iz0 x1:ix1 y1:iy1 z1:iz1
    "draw an axis aligned rectangluare box with given x,y and z ranges."

    self drawBoxX0:ix0 y0:iy0 z0:iz0 x1:ix1 y1:iy1 z1:iz1 type:#flat 

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:60.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     v drawSolidBoxX0:-1 y0:-1 z0:-1 x1:1 y1:1 z1:1
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:34:50 / claus"
!

drawSolidDoughnutMajorRadius:R minorRadius:r sides:nsides rings:nrings
    "draw a doughnut at 0/0/0."

    self drawDoughnutMajorRadius:R minorRadius:r sides:nsides rings:nrings type:#flat 

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:30.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     v drawSolidDoughnutMajorRadius:1 minorRadius:0.5 sides:20 rings:20  
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:54:42 / claus"
!

drawWireframeBoxX0:ix0 y0:iy0 z0:iz0 x1:ix1 y1:iy1 z1:iz1
    "draw an axis aligned rectangluare box with given x,y and z ranges."

    self drawBoxX0:ix0 y0:iy0 z0:iz0 x1:ix1 y1:iy1 z1:iz1 type:#lines 

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:60.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     v drawWireframeBoxX0:-1 y0:-1 z0:-1 x1:1 y1:1 z1:1
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:34:02 / claus"
!

drawWireframeDoughnutMajorRadius:R minorRadius:r sides:nsides rings:nrings
    "draw a doughnut at 0/0/0."

    self drawDoughnutMajorRadius:R minorRadius:r sides:nsides rings:nrings type:#lines 

    "
     |top v points|

     top := StandardSystemView new.
     top extent:300@300.

     v := GLXView origin:0.0@0.0 corner:1.0@1.0 in:top.
     v setType:#colorIndexSingleBuffer.

     top openAndWait.

     v perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
     v translateZ:-5.0.
     v rotateX:0.0 y:30.0 z:30.0.

     v color:(GLXView black).
     v clear.
     v color:(GLXView red).

     v drawWireframeDoughnutMajorRadius:1 minorRadius:0.5 sides:10 rings:10  
    "

    "Created: 14.9.1995 / 11:08:13 / claus"
    "Modified: 14.9.1995 / 11:53:22 / claus"
! !

!GLXView methodsFor:'realization'!

destroy
    "view is about to be destroyed - unlink from GLX first"

    device supportsGLDrawing ifTrue:[
        drawableId notNil ifTrue:[
            device unlinkGLXView:drawableId.
        ].
    ].
    super destroy

    "Modified: / 27.7.1998 / 20:14:11 / cg"
!

physicalCreate
    "redefined create, to make a GLX window instead of a normal
     one (should extract the createWindow from View and just
     redefine that on to get rid of all the other stuff here)"

    device supportsGLDrawing ifFalse:[
        super physicalCreate.
        ^ self
    ].
    drawableId := device createGLXWindowFor:self 
                                       left:left top:top 
                                      width:width height:height
                                       type:type.

    drawableId isNil ifTrue:[
        self error:'GL window creation failed'.
        ^ nil
    ].

    self extentChangedFlag:false.
    self originChangedFlag:false.

    viewShape notNil ifTrue:[
        self setViewShape
    ].
    backed notNil ifTrue:[
        device setBackingStore:backed in:drawableId
    ].
    self saveUnder ifTrue:[
        device setSaveUnder:true in:drawableId
    ].

    "Modified: / 27.7.1998 / 20:14:34 / cg"
!

realize
    superView isNil ifTrue:[
	"
	 we have to trap this situation, since GL will
	 close down the X-connection if a GL-topview
	 is closed (i.e. GLXView new open).
	"
	self error:'GLXViews need a superview'.
	^ self
    ].
    super realize.
    self enableEvent:#expose.
    "
     SGI-GL does not generate mapped/unmapped etc. events.
     (which is bad)
    "
    shown := true
! !

!GLXView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLXView.st,v 1.29 2016-01-21 18:06:09 cg Exp $'
! !


GLXView initialize!
