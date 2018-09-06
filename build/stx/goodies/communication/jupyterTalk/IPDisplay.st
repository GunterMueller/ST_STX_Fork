"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

Object subclass:#IPDisplay
	instanceVariableNames:'jupyterData interaction extent'
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Display'
!

IPDisplay class instanceVariableNames:'cachedObjects'

"
 No other class instance variables are inherited by this class.
"
!

IPDisplay comment:''
!


!IPDisplay class methodsFor:'accessing'!

cachedObjects
	^ cachedObjects ifNil:[cachedObjects := Dictionary new]
! !

!IPDisplay class methodsFor:'removing'!

resetCache
	cachedObjects :=nil
! !

!IPDisplay methodsFor:'accessing'!

jupyterData
	"Uses Session jupyterData to write the anwer"
	^ IPSession currentSession jupyterData 
! !

!IPDisplay methodsFor:'as yet unclassified'!

publish: aResultMessage

	(IPharoKernel instance processors at:#iopub) publish:  aResultMessage
! !

!IPDisplay methodsFor:'initialization'!

initialize
	super initialize.
	interaction := false
! !

!IPDisplay methodsFor:'public-api'!

extent
	"default extent"
	^  extent ifNil:[ extent :=  640@256 ].
	
	
!

extent: aPoint
	extent:= aPoint 
	
	
!

maxNumberOfRows
	^ 500

	 
	
														
														
!

openInJupyter: data 
	|aJupyterData  uuid  |
	
	
	aJupyterData := (interaction and:[data respondsTo:#asJupyterInteractiveDataWithExtent:]) 
							ifTrue:[data asJupyterInteractiveDataWithExtent: self extent]
							ifFalse:[data asJupyterDataWithExtent: self extent].	
	self jupyterData data at:aJupyterData key put:aJupyterData value.
	self jupyterData metadata:{
 									aJupyterData key -> {
    															'width' -> self extent x.
    															'height' -> self extent y
 														 	} asSCJsonObject.
														} asSCJsonObject.
	uuid:= UUID new hex asString asUppercase.
	self jupyterData transient: {#display_id -> uuid} asSCJsonObject.
	self class cachedObjects 
						at:uuid put: {    #data-> data.
												#interactive-> interaction.
												#extent->self extent.
												#metadata ->self jupyterData metadata} asDictionary. 
	^ uuid
!

openInJupyter: data extent: aPoint
	
	self extent: aPoint.
	^ self openInJupyter: data
!

refresh: anUUID 
	| cdata udm|

	cdata:= self class cachedObjects at:anUUID ifAbsent:[self error:'Object ', anUUID asString,' not found in jupyter kernel cache'].
	"get the old object and execute display again"
	(cdata at:#interactive) ifTrue:[self interactionOn].
	self openInJupyter: (cdata at:#data) extent: (cdata at:#extent). 
	udm := IPSession currentSession  updateDisplayMessage.
	udm content addAll: self jupyterData .	
	udm transient: {#display_id -> anUUID} asSCJsonObject.
	udm metadata: (cdata at:#metadata).
	udm respondsToWireMessage:(IPharoKernel instance processors at:#shell) wireMessage.
	self publish:udm.
	"we need to reset current output to avoid double response..."
	IPSession currentSession resetJupyterData.
	
! !

!IPDisplay class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPDisplay.st,v 1.2 2018-05-14 00:52:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/IPDisplay.st,v 1.2 2018-05-14 00:52:24 cg Exp $'
! !

