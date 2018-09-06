"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


"{ NameSpace: Tools }"

Object subclass:#NewInspectorList
	instanceVariableNames:'inspectedObject instanceNames instanceTypes selection'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-NewInspector'
!

!NewInspectorList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

! !

!NewInspectorList class methodsFor:'instance creation'!

for:anObject
    "create a new list for an instance
    "
    ^ self new inspect:anObject


!

new
    "create a new instance and set the inspected object to nil
    "
    ^ self basicNew initialize.

! !

!NewInspectorList class methodsFor:'helpers'!

asString:aCollection
    "converts any collection to a string seperated by spaces. If
     the collection is empty or nil, nil is returned otherwise a
     string.
    "
    |string|

    aCollection isCollection ifTrue:[
	aCollection isString ifTrue:[
	    string := aCollection
	] ifFalse:[
	    string := aCollection asStringWith:Character space
					  from:1 to:(aCollection size)
				  compressTabs:true
					 final:nil
	].
	string := string withoutSeparators.

	string notEmpty ifTrue:[
	    ^ string
	]
    ].
    ^ nil


! !

!NewInspectorList class methodsFor:'testing'!

isDirectory:anInstance
    "returns true if the instance is a directory
    "
    |cls|

    anInstance notNil ifTrue:[
	cls := anInstance class.

	cls == Character  ifTrue:[ ^ false ].
	cls == Symbol     ifTrue:[ ^ false ].
	cls == String     ifTrue:[ ^ false ].
	cls == Float      ifTrue:[ ^ false ].
	cls == ShortFloat ifTrue:[ ^ false ].

	cls allInstVarNames notEmpty ifTrue:[
	    ^ true
	].

	anInstance isVariable ifTrue:[
	    ^ true
	].
    ].
    ^ false

    "Modified: / 4.2.1999 / 20:00:11 / cg"
!

isTraceable:anInstance
    "returns true if the instance could be traced or traped
    "
    |cls|

    anInstance notNil ifTrue:[
	cls := anInstance class.

      ^ (     cls ~~ True
	 and:[cls ~~ False
	 and:[cls ~~ SmallInteger]]
	)
    ].
    ^ false.

! !

!NewInspectorList methodsFor:'accessing'!

includesSelf:aBoolean
    "includes 'self' dependant on the boolean
    "
    (self includesSelf) ~~ aBoolean ifTrue:[
	aBoolean ifTrue:[
	    instanceNames addFirst:'self'.
	    instanceTypes addFirst:#self.

	    selection notNil ifTrue:[selection := selection + 1]
			    ifFalse:[selection := 1]

	] ifFalse:[
	    instanceNames removeFirst.
	    instanceTypes removeFirst.

	    selection isNil ifFalse:[
		(selection := selection - 1) == 0 ifTrue:[
		    selection := nil
		]
	    ]
	]
    ]


!

list
    "returns self
    "
    ^ self
!

size
    "returns size of list
    "
    ^ instanceNames size

!

update
    "update list contents
    "
    |start stop size|

    inspectedObject isVariable ifTrue:[
	start := instanceNames findFirst:[:el|(el at:1) isDigit].
	stop  := instanceTypes size.

	start == 0 ifTrue:[
	    size := stop + 10.  "must be > 1: force a resize the first time"
	] ifFalse:[
	    instanceTypes last ~~ #grow ifTrue:[size := stop]
				       ifFalse:[size := stop-1].

	    instanceTypes removeFromIndex:start toIndex:stop.
	    instanceNames removeFromIndex:start toIndex:stop.
	].
	self resizeTo:size.
    ]

    "Modified: / 4.2.1999 / 20:00:38 / cg"
! !

!NewInspectorList methodsFor:'accessing contents'!

inspectedObject
    "returns current inspected object
    "
    ^ inspectedObject


!

instanceNames
    "returns list of instance names
    "
    ^ instanceNames


!

instanceTypeAt:anIndex
    "returns type assigned to the list entry (#directory #normal #self #grow)
     In case of an invalid index nil is returned.
    "
    (anIndex isNil or:[anIndex > instanceTypes size]) ifFalse:[^ instanceTypes at:anIndex]
						       ifTrue:[^ nil].


!

instanceTypes
    "returns list of types (#directory #normal #self #grow)
    "
    ^ instanceTypes


!

instanceVarAt:anIndex
    "returns the instnace variable assigned to the index or
     nil in case of an invalid index.
    "
    |nm|

    (anIndex isNil or:[anIndex > instanceTypes size]) ifFalse:[
	nm := instanceNames at:anIndex.

	(nm at:1) isDigit ifFalse:[
	    self includesSelf ifFalse:[
		^ inspectedObject instVarAt:anIndex
	    ].
	    anIndex == 1 ifFalse:[^ inspectedObject instVarAt:(anIndex-1)]
			  ifTrue:[^ inspectedObject]
	].
      ^ inspectedObject basicAt:(Number readFrom:nm onError:0)
    ].
    ^ nil


! !

!NewInspectorList methodsFor:'initialization'!

initialize
    "initialize instance attributes
    "
    super initialize.

    instanceNames := OrderedCollection new.
    instanceTypes := OrderedCollection new.

! !

!NewInspectorList methodsFor:'private'!

resizeTo:aNumber
    "resize list to minimum aNumber
    "
    |lstVarId basicSize newLastId obj instSize|

    (inspectedObject isVariable and:[self class isDirectory:inspectedObject]) ifFalse:[
	^ self
    ].

    instanceTypes size == 0 ifTrue:[
	lstVarId := 0
    ] ifFalse:[
	instSize := inspectedObject class instSize.

	instanceTypes first == #self ifTrue:[
	    instSize := instSize + 1
	].
	instanceTypes last == #grow ifTrue:[
	    instanceNames removeLast.       " ..    "
	    instanceTypes removeLast.       " #grow "
	].
	lstVarId := instanceTypes size - instSize.
    ].

    (basicSize := inspectedObject basicSize) == lstVarId ifTrue:[
	^ self
    ].
    newLastId := (1 bitShift:((aNumber-1) highBit)) max:128.

    (newLastId + 64) > basicSize ifTrue:[
	newLastId := basicSize
    ].

    [lstVarId ~~ newLastId] whileTrue:[
	lstVarId := lstVarId + 1.
	obj := inspectedObject basicAt:lstVarId.

	(self class isDirectory:obj) ifTrue:[instanceTypes add:#directory]
				    ifFalse:[instanceTypes add:#normal].

	instanceNames add:(lstVarId printString, '   ', obj class name printString).
    ].

    lstVarId ~~ basicSize ifTrue:[
	instanceNames add:'..'.
	instanceTypes add:#grow
    ].
! !

!NewInspectorList methodsFor:'selections'!

selectedInstanceType
    "returns type assigned to the selected list entry (#directory #normal #self #grow).
     In case of no selection nil is returned.
    "
    ^ self instanceTypeAt:selection


!

selectedInstanceVar
    "returns current inspected instance variable or nil
    "
    ^ self instanceVarAt:selection


!

selection
    "returns current selection number or nil
    "
    ^ selection


!

setSelection:aNrOrNil
    "change current selection to a number or nil; may resize the lists
    "
    selection := aNrOrNil.

    (selection isNil or:[instanceTypes size > selection]) ifFalse:[
	self resizeTo:selection.

	selection > instanceTypes size ifTrue:[
	    selection := nil
	]
    ]
! !

!NewInspectorList methodsFor:'testing'!

includesSelf
    "returns true if 'self' is included in the list
    "
    ^ (instanceTypes notEmpty and:[instanceTypes first == #self])


!

isEmpty
    "returns true if the list is empty
    "
    ^ instanceNames isEmpty

!

notEmpty
    "returns true if the list is not empty
    "
    ^ instanceNames notEmpty

! !

!NewInspectorList methodsFor:'user interaction'!

accept:aText notifying:aView
    "evaluating aText on the selected instance var; if an error occurs #Error
     is returned otherwise the inspected object instance. On success the list
     will be updated.
    "
    |text slNr value|

    selection notNil ifTrue:[
	text := self class asString:aText.

	text notNil ifTrue:[
	    self includesSelf ifFalse:[slNr := selection]
			       ifTrue:[slNr := selection-1].

	    value := inspectedObject class evaluatorClass
		       evaluate:text
		       receiver:inspectedObject
		      notifying:aView.

	    slNr ~~ 0 ifTrue:[
		(inspectedObject class isVariable) ifFalse:[
		    inspectedObject instVarAt:slNr put:value
		] ifTrue:[
		    slNr <= (inspectedObject class instSize) ifTrue:[
			inspectedObject instVarAt:slNr put:value
		    ] ifFalse:[
			slNr := slNr - inspectedObject class instSize.
			inspectedObject basicAt:slNr put:value
		    ]
		]
	    ].
	    inspectedObject changed.
	    self update.
	  ^ inspectedObject
	]
    ].
    ^ #Error
!

doIt:aCode notifying:aView
    "evaluating aCode on the selected instance var; if an error occurs #Error
     is returned otherwise the result returned from the evaluator. On success
     the list will be updated.
    "
    |successFg result evaluator selInstVar code|

    selInstVar := self selectedInstanceVar.

    selInstVar notNil ifTrue:[
	code := self class asString:aCode.

	code notNil ifTrue:[
	    evaluator := selInstVar class evaluatorClass.
	    successFg := true.

	    evaluator notNil ifTrue:[
		result := evaluator evaluate:code
					  in:nil
				    receiver:selInstVar
				   notifying:aView
				      logged:true
				      ifFail:[successFg := false].

		successFg ifTrue:[
		    self update.
		  ^ result
		]
	    ]
	]
    ].
    ^ #Error.


!

inspect:anObject
    "inspect a new instance; update contents
    "
    |varNamesSize|

    selection := nil.

    anObject == inspectedObject ifFalse:[
	inspectedObject := anObject.

	(self class isDirectory:inspectedObject) ifFalse:[
	    instanceNames := OrderedCollection new.
	    instanceTypes := OrderedCollection new.
	] ifTrue:[
	    instanceNames := inspectedObject class allInstVarNames.
	    varNamesSize  := instanceNames size.
	    instanceTypes := OrderedCollection new:varNamesSize.

	    1 to:varNamesSize do:[:i|
		(self class isDirectory:(inspectedObject instVarAt:i)) ifTrue:[
		    instanceTypes add:#directory
		] ifFalse:[
		    instanceTypes add:#normal
		]
	    ].
	]
    ].
    self update
! !

!NewInspectorList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
