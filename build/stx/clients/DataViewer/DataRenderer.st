"{ NameSpace: TDV }"

TDVObject subclass:#DataRenderer
	instanceVariableNames:'gl glGraph glView lockCriticalResource redrawTrigger redrawTask
		lockRendering aspectsForRendering components renderingAllowed'
	classVariableNames:'NextSequentialComponentID'
	poolDictionaries:''
	category:'TDV-Renderer'
!


!DataRenderer methodsFor:'accessing'!

glContextClass
"return the openGL context for a ColumnDataViewer3D

<return: OpenGLDevice Class>
"
    ^gl

    "Created: / 13.10.1998 / 17:32:09 / ps"
!

glContextInstance
"return the object representing the graph which is shown by a DataViewer3D

<return: OpenGLDevice>
"
    ^ glGraph

    "Created: / 13.10.1998 / 17:32:45 / ps"
!

lockCriticalResource
"return the value of the instance variable 'lockCriticalResource'

<return: Semaphore>
"
    ^lockCriticalResource

! !

!DataRenderer methodsFor:'accessing-attributes'!

aspectAt:aKey
"store an aspect identified by its symbol and its value

<return: Object|nil>
"  

    ^ aspectsForRendering at: aKey ifAbsent:nil

!

aspectAt:aKey put:aValue
"store an aspect identified by its symbol and its value

<return: self>
"  

    aspectsForRendering at: aKey put: aValue

!

setAspectsForComponents: aBlock

    lockCriticalResource critical:
	[aBlock value]
! !

!DataRenderer methodsFor:'accessing-components'!

addComponent:aComponent
"

<return: self>
" 
    components at:aComponent put:(self nextComponentID).
    aComponent renderingContext:(self glContextClass).
    aComponent renderer:self.







!

addComponents:aComponentCollection
"

<return: self>
"
    aComponentCollection do:[:eachComponent | self addComponent: eachComponent]






! !

!DataRenderer methodsFor:'accessing-sequential-id'!

nextComponentID
"

<retrun: SmallInteger>
"
    [
	NextSequentialComponentID isNil
	    ifTrue:[NextSequentialComponentID := 0].
	^ NextSequentialComponentID := NextSequentialComponentID + 1
    ] valueUninterruptably


! !

!DataRenderer methodsFor:'initialization'!

newOn:aDataViewer3D

    OpenGLDevice isLoaded ifFalse:[
        Smalltalk fileInClassLibrary:'libopengl'.
        OpenGLDevice isLoaded ifFalse:[
            self warn:'class OpenGLDevice is not loaded.\\(And classLibrary ''libopengl'' could not be loaded)' withCRs.
            Object abortSignal raise.
        ].
    ].

    glView := aDataViewer3D.
    glGraph := OpenGLDevice new.
    gl      := glGraph class.
    glGraph world:self.
    glView addSubView: glGraph.
    glGraph origin:0.0@0.0 corner:1.0@1.0.

    redrawTrigger := Semaphore new.
    renderingAllowed := false.
    redrawTrigger name:'redraw trigger'.
    lockRendering := Semaphore forMutualExclusion.
    lockRendering name:'GL rendering lock'.
    lockCriticalResource := Semaphore forMutualExclusion.
    lockCriticalResource name:'critical resource lock'.
    aspectsForRendering := IdentityDictionary new.
    components := OrderedDictionary new.
    self createRedrawProcess.
    self initialize

    "Created: / 13.10.1998 / 17:41:20 / ps"
    "Modified: / 26.10.1998 / 19:06:26 / cg"
    "Modified: / 25.6.1999 / 14:27:26 / ps"
! !

!DataRenderer methodsFor:'process'!

createRedrawProcess
"start redraw process if it isn't still running
"
    redrawTask isNil ifTrue:[
	"start process"
	redrawTask := Process for:[
		[true] whileTrue:[
		    redrawTrigger wait.
			self myRedrawRoutine 
		].
	] priority:( Processor activePriority - 1 ).
	redrawTask name:'TDV redrawer'.
	redrawTask resume.
    ]

    "Modified: / 13.10.1998 / 17:27:17 / ps"
!

stopRedrawProcess
"stop redraw process when actual image is rendered; this avoids unfinished images when
changeing drawing function
"
"/    redrawTask isNil ifFalse:[ lockCriticalTask critical:[redrawTask terminate.redrawTask := nil]].
"/    redrawTask isNil ifFalse:[redrawTask terminate.redrawTask := nil].
    redrawTask isNil ifFalse:[lockRendering critical:[redrawTask suspend]].

    "Modified: / 13.10.1998 / 17:28:13 / ps"
!

terminateRedrawProcess
"stop redraw process when actual image is rendered; this avoids unfinished images when
changeing drawing function
"
"/    redrawTask isNil ifFalse:[ lockCriticalTask critical:[redrawTask terminate.redrawTask := nil]].
"/    redrawTask isNil ifFalse:[redrawTask terminate.redrawTask := nil].
    redrawTask isNil ifFalse:[lockRendering critical:[redrawTask terminate]].

    "Modified: / 13.10.1998 / 17:28:13 / ps"
! !

!DataRenderer methodsFor:'queries'!

glExtensions
"return opengl's extensions
"
    ^gl extensions

    "Created: / 13.10.1998 / 17:04:13 / ps"
!

glRenderer
"return opengl's renderer
"
    ^gl renderer

    "Created: / 13.10.1998 / 17:05:07 / ps"
!

glVendor
"return opengl's vendor
"
    ^gl vendor

    "Created: / 13.10.1998 / 17:05:15 / ps"
!

glVersion
"return opengl's versionGL
"
    ^gl versionGL

    "Created: / 13.10.1998 / 17:05:25 / ps"
!

gluVersion
"return opengl's versionGLU
"
    ^gl versionGLU

    "Created: / 13.10.1998 / 17:05:33 / ps"
! !

!DataRenderer methodsFor:'rendering'!

clearView

    gl glClearIS:(gl GL_COLOR_BUFFER_BIT   bitOr: gl GL_DEPTH_BUFFER_BIT).
    gl glFlush.

    "Modified: / 13.10.1998 / 17:50:36 / ps"
!

criticalRender: aBlock

    lockRendering
	critical:[aBlock value]

! !

!DataRenderer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DataRenderer.st,v 1.16 1999-06-25 12:35:26 ps Exp $'
! !
