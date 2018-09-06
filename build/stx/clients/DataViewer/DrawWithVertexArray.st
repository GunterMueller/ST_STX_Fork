"{ NameSpace: TDV }"

DrawableComponent subclass:#DrawWithVertexArray
	instanceVariableNames:'xdiff zdiff z dimensionX dimensionZ data toDrawValues vertexArray
		normalArray colorArray indexForTriangles indexForQuads
		numOfTriangles numOfQuads normalQuadArray drawGrid drawData
		valueHolderForSelection pickNodesToDraw'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!DrawWithVertexArray methodsFor:'accessing'!

getIndexForPickNodes
"
<return: Array with: (Array)>
"
    ^pickNodesToDraw
! !

!DrawWithVertexArray methodsFor:'accessing aspects'!

aspectAt:aKey put:aValue


    super aspectAt:aKey put:aValue.
    (aKey == #dimensionZ or:[aKey == dimensionX])
	ifTrue:[initialized := false].




! !

!DrawWithVertexArray methodsFor:'accessing matrix-data'!

checkIndexForQuadArray:anIndex

    |x z|
    x := anIndex x.
    z := anIndex y.
    "the quad array matrix size is 1 to dimensionX and 1 to dimensionZ"
    ^(x>0 and:[x<dimensionX and:[z>0 and:[z<dimensionZ]]])


!

getValueFromMatrixForIndex: anIndex
"
<return: Array with:Floats>
"
    |xIndex zIndex indexInMatrixArray|

    xIndex := anIndex at:1 ifAbsent:1.
    zIndex := anIndex at:2 ifAbsent:1.

    "offest in array = row offset  + column offset"
    indexInMatrixArray := 1+(12*(xIndex-1))+(dimensionX*12*(zIndex-1)).
    ^Array with:(vertexArray floatAt:indexInMatrixArray)
	   with:(vertexArray floatAt:indexInMatrixArray+4)
	   with:(vertexArray floatAt:indexInMatrixArray+8)     


!

getValues
"get new y values (if available) from the data manager and 
insert them in the matrix array

return: <Array | nil>
"
    data isNil
	ifFalse:[^data yValuesInto:(Array new)]
	ifTrue: [^nil].

    "Modified: / 29.12.1998 / 15:04:42 / ps"



!

getYValueForIndex: anIndex

    |xIndex zIndex vector indexForVector|

    xIndex := anIndex x.
    zIndex := anIndex y.

    vector := Array new:3.
    indexForVector := 1+(12*(xIndex-1))+(dimensionX*12*(zIndex-1)).
    vector at:1 put:(vertexArray floatAt:indexForVector).
    vector at:2 put:(vertexArray floatAt:indexForVector+4).
    vector at:3 put:(vertexArray floatAt:indexForVector+8).
    ^ vector
!

makeFunction
"copy the new y values from toDrawValues to the matrix array

<return: self>
"
    (toDrawValues := self getValues)
	isNil ifFalse:[
	    "move vertex coordinats from toDrawValues array to the matrix array"
	   self setValues.
	   self calculateNormals]

    "Modified: / 11.3.1999 / 19:38:33 / ps"
!

setValueToMatrix:aVector
"set a the y value at the index of the vector and calculate the appropriate color.
The vectors format looks like:<xIndex, yValue, zIndex> where xIndex and zIndex are integers.

<return: self>
"
    |xIndex zIndex yValue indexForYValueOfVector indexForColorVector color|

    "set every index in peak array to yValue or nil"
"/    yValue >= minPeekValue ifTrue:[
"/        peekArray at:anIndex put:yValue.
"/    ]ifFalse:[
"/        peekArray at:anIndex put:nil.
"/    ].

    xIndex := aVector at:1 ifAbsent:1.
    yValue := aVector at:2 ifAbsent:0.0.
    zIndex := aVector at:3 ifAbsent:1.
    color  := aVector at:4 ifAbsent:#(1.0 1.0 1.0).

    "offest in array = row offset  + column offset"
    indexForYValueOfVector := 5+(12*(xIndex-1))+(dimensionX*12*(zIndex-1)).
    vertexArray floatAt:indexForYValueOfVector put:yValue.

    "set color of the point at index"
    indexForColorVector := 1+(12*(xIndex-1))+(dimensionX*12*(zIndex-1)).

    colorArray floatAt:indexForColorVector   put:(color at:1).
    colorArray floatAt:indexForColorVector+4 put:(color at:2).
    colorArray floatAt:indexForColorVector+8 put:(color at:3).

    "Modified: / 9.3.1999 / 21:33:15 / ps"


!

setValues
"move vertex coordinats from toDrawValues array to the matrix vertex array

<return: self>
"
    1 to: toDrawValues size do:[:i|
	self setValueToMatrix:(toDrawValues at:i) 
    ].

    "Created: / 9.3.1999 / 21:52:39 / ps"
! !

!DrawWithVertexArray methodsFor:'initialization'!

initialize
"setup default values
"
    super initialize.
    dimensionX := 1.
    dimensionZ := 1.
    xdiff := 0.0.
    zdiff := 0.0.
    z := 0.0.
    data := nil.
    drawGrid := false.
    drawData := false.
    valueHolderForSelection := nil.
    pickNodesToDraw := OrderedCollection new.


    "Modified: / 9.3.1999 / 21:32:56 / ps"
!

initializeNormalQuadArray

    normalQuadArray do:[:each |
	1 to: each size do:[:i| |dic| 
				dic := IdentityDictionary new.
				dic at:#recalNormal put:#true.
				dic at:#normalVector put:#(1.0 0.0 0.0).
				each at:i put:dic]]
!

initializeVertexArray
"vertexArray is initialized with xDiff ,yMin and zDiff values

<return: self>
"
    |m|

    m := 1.
    1 to: dimensionZ do:[:dz|
	1 to: dimensionX do:[:dx|
	    vertexArray floatAt:m   put:xdiff*(dx-1).
	    vertexArray floatAt:m+4 put:0.0.
	    vertexArray floatAt:m+8 put:z-(zdiff*(dz-1)).
	    m := m + 12.
	].
    ].

    "Modified: / 9.3.1999 / 21:14:24 / ps"
!

makeIndexForQuads
"generate the quads indices for drawing with the vertex array;
the indices are stored in indexForQuads

<retrun: self>
"
    |offset|
"/    "1"dx+offset.
"/    "2"dx+offset+dimensionX.
"/    "3"dx+1+offset.
"/    "4"dx+1+offset+dimensionX.    

    0 to: (dimensionZ-1) do:[:dz|
	offset := dimensionX*dz.
	0 to: (dimensionX-2) do:[:dx|
	    |index1|
	    index1 := WordArray new:4.
	    index1 at:1 put:"1"dx+offset.
	    index1 at:2 put:"3"dx+1+offset.
	    index1 at:3 put:"2"dx+offset+dimensionX.
	    index1 at:4 put:"4"dx+1+offset+dimensionX.

	    indexForQuads add: index1.
	]
    ].

    "Created: / 9.3.1999 / 21:13:16 / ps"
    "Modified: / 9.3.1999 / 21:15:38 / ps"
!

makeIndexForTriangles
"generate the triangles indices for drawing with the vertex array;
the indices are stored in indexForTriangles

<retrun: self>
"
    |offset|
"/    "1"dx+offset.
"/    "2"dx+offset+dimensionX.
"/    "3"dx+1+offset.
"/    "4"dx+1+offset+dimensionX.    

    0 to: (dimensionZ-1) do:[:dz|
	offset := dimensionX*dz.
	0 to: (dimensionX-2) do:[:dx|
	    |index1 index2|
	    index1 := WordArray new:3.
	    index2 := WordArray new:3.
	    index1 at:1 put:"1"dx+offset.
	    index1 at:2 put:"4"dx+1+offset+dimensionX.
	    index1 at:3 put:"2"dx+offset+dimensionX.
	    indexForTriangles add: index1.
	    index2 at:1 put:"1"dx+offset.
	    index2 at:2 put:"3"dx+1+offset.
	    index2 at:3 put:"4"dx+1+offset+dimensionX.
	    indexForTriangles add: index2.
	]
    ].

    "Created: / 9.3.1999 / 21:09:15 / ps"
    "Modified: / 9.3.1999 / 21:13:25 / ps"
! !

!DrawWithVertexArray methodsFor:'normal vectors'!

calcNormalForQuadForX:x y:y

    |indexUpperLeft indexUpperRight indexLowerLeft indexLowerRight 
     vectorUpperRight vectorUpperLeft vectorLowerLeft vectorLowerRight
     vector1 vector2 normalVector|

    indexUpperLeft  := Point new.
    indexUpperRight := Point new.
    indexLowerLeft  := Point new.
    indexLowerRight := Point new.

    indexUpperRight x:x+1 y:y+1.
    indexUpperLeft  x:x   y:y+1.
    indexLowerLeft  x:x   y:y.
    indexLowerRight x:x+1 y:y.

    vectorUpperRight := self getYValueForIndex:indexUpperRight.
    vectorUpperLeft  := self getYValueForIndex:indexUpperLeft.
    vectorLowerLeft  := self getYValueForIndex:indexLowerLeft.
    vectorLowerRight := self getYValueForIndex:indexLowerRight.

    vector1 := NormalVectorUtilities normale:vectorLowerLeft arg2:vectorUpperLeft arg3:vectorUpperRight.
    vector2 := NormalVectorUtilities normale:vectorUpperRight arg2:vectorLowerRight arg3:vectorLowerLeft.
    ^NormalVectorUtilities addAndNormalize:vector1 arg2:vector2






!

calcNormalVectorForElement:aVector
"invalidate the surrounding normal vectors for all new indicies in toDrawValues

<return: self>
"
    |indexUpperLeft indexUpperRight indexLowerLeft indexLowerRight
     xIndex zIndex normalElements normalVector index|

    normalElements := OrderedCollection new:4.
    indexUpperLeft  := Point new.
    indexUpperRight := Point new.
    indexLowerLeft  := Point new.
    indexLowerRight := Point new.

    xIndex := aVector at:1.
    zIndex := aVector at:3.
    index := Point new x:xIndex y:zIndex.

    indexUpperRight x:xIndex   y:zIndex.
    indexUpperLeft  x:xIndex-1 y:zIndex.
    indexLowerLeft  x:xIndex-1 y:zIndex-1.
    indexLowerRight x:xIndex   y:zIndex-1.

    (self checkIndexForQuadArray:indexUpperRight) 
	ifTrue:[normalElements add:(self getNormalVectorForQuadArrayIndex:indexUpperRight)].
    (self checkIndexForQuadArray:indexUpperLeft) 
	ifTrue:[normalElements add:(self getNormalVectorForQuadArrayIndex:indexUpperLeft)].
    (self checkIndexForQuadArray:indexLowerLeft) 
	ifTrue:[normalElements add:(self getNormalVectorForQuadArrayIndex:indexLowerLeft)].
    (self checkIndexForQuadArray:indexLowerRight) 
	ifTrue:[normalElements add:(self getNormalVectorForQuadArrayIndex:indexLowerRight)].

    normalVector := NormalVectorUtilities addAndNormalize:normalElements.
    self setNormalToMatrixForIndex:index normal:normalVector



    "Created: / 9.3.1999 / 22:14:27 / ps"
!

calculateNormals
"calculate normal vectors and update the normalArray

<return: self>
"
    "invalidate the surrounding normal vector of an index"
    self invalidateNormalsForQuadsArray.
    self calculateNormalsForQuadsArray.
    self calculateNormalsForMatrixElements.

    "Modified: / 9.3.1999 / 21:56:36 / ps"
!

calculateNormalsForMatrixElements
"calculate normal vector for each element in the toDrawValues 

<return: self>
"
    1 to: toDrawValues size do:[:i|
	self calcNormalVectorForElement:(toDrawValues at:i) 
    ]

    "Created: / 9.3.1999 / 21:52:39 / ps"
!

calculateNormalsForQuadsArray



    |x|
    x := 1.
    normalQuadArray do:[:each |
	1 to: each size do:[:i |
		   ((each at:i) at:#recalNormal)
		       ifTrue:[(each at:i) at:#normalVector put:(self calcNormalForQuadForX:x y:i)]].
	x := x +1].
!

getNormalVectorForQuadArrayIndex:anIndex

    ^((normalQuadArray at:(anIndex x)) at:(anIndex y)) at:#normalVector
!

invalidateNormalsForQuadsArray
"invalidate the surrounding normal vectors for all new indicies in toDrawValues

<return: self>
"
    |indexUpperLeft indexUpperRight indexLowerLeft indexLowerRight
     xIndex zIndex|
    indexUpperLeft  := Point new.
    indexUpperRight := Point new.
    indexLowerLeft  := Point new.
    indexLowerRight := Point new.

    "initializeQuadArray"
    normalQuadArray do:[:each|
	1 to: each size do:[:i| (each at:i) at:#recalNormal put:false]].

"/    self halt.

    toDrawValues do:[:vector|
	xIndex := vector at:1.
	zIndex := vector at:3.

	indexUpperRight x:xIndex   y:zIndex.
	indexUpperLeft  x:xIndex-1 y:zIndex.
	indexLowerLeft  x:xIndex-1 y:zIndex-1.
	indexLowerRight x:xIndex   y:zIndex-1.

	(self checkIndexForQuadArray:indexUpperRight)
	    ifTrue:[self setRecalFlagOfQuadArray:indexUpperRight value:true].
	(self checkIndexForQuadArray:indexUpperLeft)
	    ifTrue:[self setRecalFlagOfQuadArray:indexUpperLeft value:true].
	(self checkIndexForQuadArray:indexLowerLeft)
	    ifTrue:[self setRecalFlagOfQuadArray:indexLowerLeft value:true].
	(self checkIndexForQuadArray:indexLowerRight)
	    ifTrue:[self setRecalFlagOfQuadArray:indexLowerRight value:true].
    ].
"/    self halt.
    "Created: / 9.3.1999 / 22:14:27 / ps"
!

setNormalToMatrixForIndex:anIndex normal:aNormalVector
"set a the y value at the index of the vector and calculate the appropriate color.
The vectors format looks like:<xIndex, yValue, zIndex> where xIndex and zIndex are integers.

<return: self>
"
    |xIndex zIndex indexForNormalVector|

    xIndex := anIndex x.
    zIndex := anIndex y.

    "offest in array = row offset  + column offset"
    indexForNormalVector := 1+(12*(xIndex-1))+(dimensionX*12*(zIndex-1)).
    normalArray floatAt:indexForNormalVector   put:(aNormalVector at:1).
    normalArray floatAt:indexForNormalVector+4 put:(aNormalVector at:2).
    normalArray floatAt:indexForNormalVector+8 put:(aNormalVector at:3).


    "Modified: / 9.3.1999 / 21:33:15 / ps"


!

setRecalFlagOfQuadArray:anIndex value:aValue

    ((normalQuadArray at:(anIndex x))at:(anIndex y)) at:#recalNormal put:aValue

! !

!DrawWithVertexArray methodsFor:'protocol'!

copyAspects
"set local variables out of the aspects

<return: self>
"
    |aspect newPickNodesColl|
    (aspect := globalAspectsIdentDic at:#dimensionX ifAbsent:[nil]) notNil
	ifTrue:[dimensionX := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#dimensionZ ifAbsent:[nil]) notNil
	ifTrue:[dimensionZ := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#xdiff ifAbsent:[nil]) notNil
	ifTrue:[xdiff := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#zdiff ifAbsent:[nil]) notNil
	ifTrue:[zdiff := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#z ifAbsent:[nil]) notNil
	ifTrue:[z := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#data ifAbsent:[nil]) notNil
	ifTrue:[data := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawGrid ifAbsent:[nil]) notNil
	ifTrue:[drawGrid := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#drawData ifAbsent:[nil]) notNil
	ifTrue:[drawData := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#valueHolderForSelection ifAbsent:[nil]) notNil
	ifTrue:[valueHolderForSelection := aspect.initialized := false].
    (newPickNodesColl := globalAspectsIdentDic at:#addPickNodes ifAbsent:[nil]) notNil
	ifTrue:[pickNodesToDraw removeAll.
		pickNodesToDraw add:newPickNodesColl].
    (newPickNodesColl := globalAspectsIdentDic at:#removePickNodes ifAbsent:[nil]) notNil
	ifTrue:[pickNodesToDraw remove:newPickNodesColl ifAbsent:[nil]].
    globalAspectsIdentDic removeAll








!

draw
"draw graph and/or peak text
"
    |t stopApplication vector|
"/    t:= Time "millisecondsToRun:[
	self makeFunction.

	vector := FloatArray new:4.
	vector at:1 put:0.0.
	vector at:2 put:0.0.
	vector at:3 put:0.0.
	vector at:4 put:1.0.
	gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
		 valuesFV: vector.

	gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
			     modeIS: gl GL_AMBIENT_AND_DIFFUSE.
	drawData ifTrue:[self drawTriangles].
	drawGrid ifTrue:[self drawGrid].
	self drawPickNodes.
"/    ].
"/    Transcript show:'draw all in millisec: ';showCR:t.

    "Modified: / 22.10.1998 / 16:51:13 / cg"
    "Created: / 9.3.1999 / 19:28:18 / ps"
    "Modified: / 9.3.1999 / 21:48:43 / ps"
!

initBeforeDrawing
"store an aspect identified by its symbol and its value;
reimplementet to initialize local varibales, should be called
when an importent aspect changed.

<return: Boolean>
"
    | numOfCoordinates identDic | 
    numOfCoordinates := dimensionZ * dimensionX.
    "generate at least an array with one element; for safety"
    numOfCoordinates < 1 ifTrue:[numOfCoordinates := 1].
"/    numOfTriangles := numOfSlices * 2.
"/    peekArray := Array new:numOfCoordinates.
    "a coordinate consits of x,y and z vaule => multiply by 3"
    vertexArray := Array new:numOfCoordinates*3.
    normalArray := Array new:numOfCoordinates*3.
    colorArray  := Array new:numOfCoordinates*3.
    normalQuadArray := (Array new:(dimensionX-1)) atAllPut:(Array new:(dimensionZ-1)).
    self initializeNormalQuadArray.
    "initialize arrays"
    vertexArray atAllPut:0.0.
    normalArray atAllPut:0.0.
    colorArray  atAllPut:0.0.
    vertexArray := gl getExternalBytesWithShortFloatsFrom:vertexArray.
    normalArray := gl getExternalBytesWithShortFloatsFrom:normalArray.
    colorArray  := gl getExternalBytesWithShortFloatsFrom:colorArray.
    "arrays which hold the triangles, quads indicies in the vertex array"
    (numOfTriangles := (dimensionX-1)*(dimensionZ-1)*2) > 1 
	ifFalse:[numOfTriangles := 0].
    (numOfQuads := (dimensionX-1)*(dimensionZ-1)) > 1 
	ifFalse:[numOfQuads := 0].
    indexForTriangles := OrderedCollection new:numOfTriangles.
    indexForQuads     := OrderedCollection new:numOfQuads.

    self initializeVertexArray.
    self makeIndexForTriangles.
    self makeIndexForQuads.
    ^ true
!

pick
"draw graph for picking
"
    self drawNodes
    "Modified: / 22.10.1998 / 16:51:13 / cg"
    "Modified: / 29.12.1998 / 15:04:15 / ps"
    "Created: / 9.3.1999 / 19:26:07 / ps"
!

pickWith: anSelectionColl
"notification that a selection on the component occured;
set a new value to the valueHolder at the aspect #valueHolderForSelection.

<return: self>
"
    valueHolderForSelection notNil
	ifTrue:[|aValueCollXYZ|
		aValueCollXYZ := self getValueFromMatrixForIndex: anSelectionColl.
		valueHolderForSelection value:
			(anSelectionColl add:(aValueCollXYZ at:2) afterIndex:1)].
    "Modified: / 22.10.1998 / 16:51:13 / cg"
    "Modified: / 29.12.1998 / 15:04:15 / ps"
    "Created: / 9.3.1999 / 19:26:07 / ps"
! !

!DrawWithVertexArray methodsFor:'rendering'!

drawGrid
"draw grid

<retrun: self>
"
    |z t zdiffNegated|


    gl glEnableIS: gl GL_POLYGON_OFFSET_LINE.
    gl glPolygonOffsetForFactorFS:1.0
			  unitsFS:0.0.

    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK
		       modeIS: gl GL_LINE.
    gl glColor3FV: #(0.0 0.0 0.0) asFloatArray.
    gl glEnableClientStateForArrayIS: gl GL_VERTEX_ARRAY.
"/    gl glEnableClientStateForArrayIS: gl GL_NORMAL_ARRAY.
"/    gl glEnableClientStateForArrayIS: gl GL_COLOR_ARRAY.

"/    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
"/                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.

    gl glVertexPointerForSizeIS: 3 
			 typeIS: gl GL_FLOAT 
		       strideIS: 0 
		  verticesVVExt: vertexArray.

"/    gl glNormalPointerForTypeIS: gl GL_FLOAT 
"/                       strideIS: 0 
"/                   normalsVVExt: normalArray.

"/    gl glColorPointerForSizeIS: 3 
"/                        typeIS: gl GL_FLOAT 
"/                      strideIS: 0 
"/                   colorsVVExt: colorArray.

    1 to: numOfQuads do:[:index|
	gl glDrawWiredQuadFaceElementsForIndices4SV: (indexForQuads at:index)
    ].

    gl glDisableClientStateForArrayIS: gl GL_VERTEX_ARRAY.
"/    gl glDisableClientStateForArrayIS: gl GL_NORMAL_ARRAY.
"/    gl glDisableClientStateForArrayIS: gl GL_COLOR_ARRAY.

    gl glDisableIS: gl GL_POLYGON_OFFSET_LINE.

    "Modified: / 30.10.1998 / 18:54:13 / cg"
    "Created: / 9.3.1999 / 21:20:53 / ps"
    "Modified: / 9.3.1999 / 21:26:07 / ps"
!

drawNodes
"draw a quad around every point in the matrix. This is only used
to identify a pick for a matirx point.

<return: self>
"
    |index point|
    index := Array new:2.
    1 to: dimensionX do:[:x|
	index at:1 put:x.
	gl glPushNameIS:x.
	1 to: dimensionZ do:[:z|
	    index at:2 put:z.
	    gl glPushNameIS: z.
	    self drawQuadForPoint: (self getValueFromMatrixForIndex: index).
	    gl glPopName].
	gl glPopName]


    "Modified: / 30.10.1998 / 18:54:13 / cg"
    "Modified: / 9.3.1999 / 21:34:07 / ps"
!

drawPickNodes
"draw nodes

<return: self>
"
    |index point vector|

        vector := FloatArray new:4.
        vector at:1 put:1.0.
        vector at:2 put:1.0.
        vector at:3 put:0.0.
        vector at:4 put:1.0.
        gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
                 valuesFV: vector.


    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK
                       modeIS: gl GL_FILL.
    (self getIndexForPickNodes)
        do:[:eachPickNode |
            |color|
            color := eachPickNode at:3 ifAbsent:[FloatArray with:1.0 with:0.2 with:0.2].
            gl glColor3FV: color.
            ((eachPickNode at:1) <= dimensionX and:[(eachPickNode at:2) <= dimensionZ])
                ifTrue:[self drawQuadForPoint: (self getValueFromMatrixForIndex: eachPickNode)]].

    "Modified: / 30.10.1998 / 18:54:13 / cg"
    "Modified: / 7.6.1999 / 17:06:03 / ps"
!

drawQuadForPoint: aPointVector

    |vector1 vector2 vector3 vector4 vector5 vector6 vector7 vector8
     pointX pointY pointZ lenght width height|

    vector1 := FloatArray new:3.
    vector2 := FloatArray new:3.
    vector3 := FloatArray new:3.
    vector4 := FloatArray new:3.
    vector5 := FloatArray new:3.
    vector6 := FloatArray new:3.
    vector7 := FloatArray new:3.
    vector8 := FloatArray new:3.
    pointX := aPointVector at:1.
    pointY := aPointVector at:2.
    pointZ := aPointVector at:3.

    lenght := (xdiff/4).
    width := (zdiff/4).
    height := (xdiff/4).

    gl glBeginIS: gl GL_QUADS.
	vector1 at:1 put:pointX-lenght.
	vector1 at:2 put:pointY-height.
	vector1 at:3 put:pointZ+width.
	gl glVertex3FV:vector1.

	vector2 at:1 put:pointX+lenght.
	vector2 at:2 put:pointY-height.
	vector2 at:3 put:pointZ+width.
	gl glVertex3FV:vector2.

	vector3 at:1 put:pointX+lenght.
	vector3 at:2 put:pointY-height.
	vector3 at:3 put:pointZ-width.
	gl glVertex3FV:vector3.

	vector4 at:1 put:pointX-lenght.
	vector4 at:2 put:pointY-height.
	vector4 at:3 put:pointZ-width.
	gl glVertex3FV:vector4.

	vector5 at:1 put:pointX-lenght.
	vector5 at:2 put:pointY+height.
	vector5 at:3 put:pointZ+width.
	gl glVertex3FV:vector5.

	vector6 at:1 put:pointX+lenght.
	vector6 at:2 put:pointY+height.
	vector6 at:3 put:pointZ+width.
	gl glVertex3FV:vector6.

	vector7 at:1 put:pointX+lenght.
	vector7 at:2 put:pointY+height.
	vector7 at:3 put:pointZ-width.
	gl glVertex3FV:vector7.

	vector8 at:1 put:pointX-lenght.
	vector8 at:2 put:pointY+height.
	vector8 at:3 put:pointZ-width.
	gl glVertex3FV:vector8.

	gl glVertex3FV:vector1.
	gl glVertex3FV:vector2.
	gl glVertex3FV:vector6.
	gl glVertex3FV:vector5.

	gl glVertex3FV:vector4.
	gl glVertex3FV:vector3.
	gl glVertex3FV:vector7.
	gl glVertex3FV:vector8.

	gl glVertex3FV:vector1.
	gl glVertex3FV:vector5.
	gl glVertex3FV:vector8.
	gl glVertex3FV:vector4.

	gl glVertex3FV:vector2.
	gl glVertex3FV:vector6.
	gl glVertex3FV:vector7.
	gl glVertex3FV:vector3.
    gl glEnd.

    "Modified: / 30.10.1998 / 18:54:13 / cg"
    "Modified: / 9.3.1999 / 21:34:07 / ps"
!

drawTriangles
"draw triangles

<return: self>
"
    |z t zdiffNegated|

    gl glEnableIS: gl GL_POLYGON_OFFSET_FILL.
    gl glPolygonOffsetForFactorFS:1.0
			  unitsFS:2.0.

    gl glDisableIS: gl GL_CULL_FACE.
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
			 modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK
		       modeIS: gl GL_FILL.

    gl glEnableClientStateForArrayIS: gl GL_VERTEX_ARRAY.
    gl glEnableClientStateForArrayIS: gl GL_NORMAL_ARRAY.
    gl glEnableClientStateForArrayIS: gl GL_COLOR_ARRAY.

    gl glVertexPointerForSizeIS: 3 
			 typeIS: gl GL_FLOAT 
		       strideIS: 0 
		  verticesVVExt: vertexArray.

    gl glNormalPointerForTypeIS: gl GL_FLOAT 
		       strideIS: 0 
		   normalsVVExt: normalArray.

    gl glColorPointerForSizeIS: 3 
			typeIS: gl GL_FLOAT 
		      strideIS: 0 
		   colorsVVExt: colorArray.

    1 to: numOfTriangles do:[:index|
	gl glDrawTriangleFaceElementsForIndices4SV:(indexForTriangles at:index).
    ].

    gl glDisableClientStateForArrayIS: gl GL_VERTEX_ARRAY.
    gl glDisableClientStateForArrayIS: gl GL_NORMAL_ARRAY.
    gl glDisableClientStateForArrayIS: gl GL_COLOR_ARRAY.

    gl glDisableIS: gl GL_POLYGON_OFFSET_FILL.

    "Modified: / 30.10.1998 / 18:54:13 / cg"
    "Modified: / 9.3.1999 / 21:34:07 / ps"
! !

!DrawWithVertexArray class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DrawWithVertexArray.st,v 1.18 1999-06-07 15:13:55 ps Exp $'
! !
