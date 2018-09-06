"{ NameSpace: TDV }"

TDVObject subclass:#Data
	instanceVariableNames:'aspects functionYblock pickFunctionBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Data'
!


!Data methodsFor:'accessing Y function'!

functionYblock
"get the two arguments block which is used to access Y values from
start into an array. The block should return the collection of y
values; see method: #from:into:
"
    ^functionYblock

    "Created: / 5.11.1998 / 12:27:27 / ps"
!

functionYblock:something
"set the two arguments block which is used to access Y values from
start into an array. The block should return the collection of y
values; see method: #from:into:
"
    functionYblock := something.
    self changed.

    "Created: / 5.11.1998 / 12:27:33 / ps"
!

pickFunctionBlock
"get the two arguments block which is used to access Y values from
start into an array. The block should return the collection of y
values; see method: #from:into:
"
    ^pickFunctionBlock

    "Created: / 5.11.1998 / 12:27:27 / ps"
!

pickFunctionBlock:something
"set the two arguments block which is used to access Y values from
start into an array. The block should return the collection of y
values; see method: #from:into:
"
    pickFunctionBlock := something.
    self changed.

    "Created: / 5.11.1998 / 12:27:33 / ps"
! !

!Data methodsFor:'accessing aspects'!

hide
"returns true if the data object is hide otherwise false

<return: Boolean>
"
    ^aspects at:#hide ifAbsent:true

    "Created: / 5.11.1998 / 12:38:56 / ps"
!

hide:aBoolean
"set the visibility state of the data object

<return: self>
"
    self aspectAt:#hide put:aBoolean

    "Modified: / 29.9.1998 / 18:21:01 / ps"
    "Created: / 5.11.1998 / 12:39:00 / ps"
!

name
"get the name of the data object

<return: String | Symbol>
"
    ^aspects at:#name ifAbsent:#noName

    "Modified: / 29.9.1998 / 18:20:43 / ps"
    "Created: / 5.11.1998 / 12:38:04 / ps"
!

name:aName
"set the name of the data object

<return: self>
"
    self aspectAt:#name put:aName

    "Created: / 5.11.1998 / 12:38:09 / ps"
!

pickName
"get the pick name of the data object

<return: Number>
"
    ^aspects at:#pickName ifAbsent:1

    "Modified: / 29.9.1998 / 18:20:43 / ps"
    "Created: / 5.11.1998 / 12:38:04 / ps"
!

pickName:aValue
"set the pick name of the data object

<return: self>
"
    self aspectAt:#pickName put:aValue

    "Created: / 5.11.1998 / 12:38:09 / ps"
!

showName
"return a boolean which determins if the name of the data object is drawn

<return: Boolean>
"
    ^aspects at:#showName ifAbsent:true

    "Modified: / 30.9.1998 / 14:39:13 / ps"
    "Created: / 5.11.1998 / 12:38:46 / ps"
!

showName:aBoolean
"set a boolean which determins if the name of the data object should be drawn

<return: self>
"
    self aspectAt:#showName put:aBoolean

    "Modified: / 30.9.1998 / 14:39:06 / ps"
    "Created: / 5.11.1998 / 12:38:50 / ps"
!

shown
"returns true if the data object is shown otherwise false

<return: Boolean>
"
    ^aspects at:#shown ifAbsent:true

    "Created: / 5.11.1998 / 12:38:56 / ps"
!

shown:aBoolean
"set the visibility state of the data object

<return: self>
"
    self aspectAt:#shown put:aBoolean

    "Modified: / 29.9.1998 / 18:21:01 / ps"
    "Created: / 5.11.1998 / 12:39:00 / ps"
! !

!Data methodsFor:'aspects'!

aspect
"returns current aspects for the column
"
    ^aspects

    "Created: / 5.11.1998 / 12:28:24 / ps"
!

aspectAt:aKey 
"retrun an aspect at an key
"
    |oldValue|

    ^aspects at:aKey ifAbsent:nil.

    "Modified: / 25.9.1998 / 13:43:30 / ps"
    "Created: / 5.11.1998 / 12:28:29 / ps"
!

aspectAt:aKey put:aValue
"set an aspect; if the aspect changed its value, a notification will
be raised. The arguments to the change notifications is the key of
the aspect (selector) and the old value of the aspect.
"
    |oldValue|

    oldValue := aspects at:aKey ifAbsent:nil.

    oldValue ~= aValue ifTrue:[
	aValue isNil ifTrue:[aspects removeKey:aKey]
		    ifFalse:[aspects at:aKey put:aValue].

	self changed:aKey with:oldValue
    ]

    "Created: / 5.11.1998 / 12:28:34 / ps"
!

aspects:aDictionaryOrNil
"change aspects; raise a change notification when changed. If the argument is
nil, the default aspects are set
"
    |oldAspects|

    aDictionaryOrNil == aspects ifFalse:[
	oldAspects := aspects.
	self setAspects:aDictionaryOrNil.
	self changed:#aspects with:oldAspects.
    ]

    "Created: / 5.11.1998 / 12:28:39 / ps"
!

setAspects:aDictionaryOrNil
"change aspects; raise no notification. If the argument is
nil, the default aspects are set
"
    aDictionaryOrNil isNil ifTrue:[
	aspects := IdentityDictionary new.
	aspects at:#minY          put:0.0.
	aspects at:#maxY          put:1.0.
    ]ifFalse:[
	aspects := aDictionaryOrNil
    ]

    "Created: / 5.11.1998 / 12:28:44 / ps"
!

withoutNotificationAspectAt:aKey put:aValue
"set an aspect without a change notification
"
    aValue notNil ifTrue:[ aspects at:aKey put:aValue ]
		 ifFalse:[ aspects removeKey:aKey ifAbsent:nil ]

    "Created: / 5.11.1998 / 12:28:49 / ps"
! !

!Data methodsFor:'initialization'!

initialize
"setup default values"

    super initialize.
    self setAspects:nil.

    "Created: / 5.11.1998 / 12:29:54 / ps"
! !

!Data methodsFor:'queries'!

maxY
"return aspect at #maxY: maximum y value for the column
"   
    ^aspects at:#maxY ifAbsent:nil

    "Modified: / 5.11.1998 / 12:31:00 / ps"
    "Created: / 5.11.1998 / 12:32:12 / ps"
!

maxY:aValue
"set aspect at #maxY to a value: maximum y value for the column
"    
    self aspectAt:#maxY put:aValue

    "Modified: / 5.11.1998 / 12:31:05 / ps"
    "Created: / 5.11.1998 / 12:32:20 / ps"
!

minY
"return aspect at #minY: minimum y value for the column
"
    ^ aspects at:#minY ifAbsent:nil

    "Created: / 5.11.1998 / 12:32:24 / ps"
!

minY:aValue
"set aspect at #minY to a value: minimum y value for the column
"
    self aspectAt:#minY put:aValue

    "Created: / 5.11.1998 / 12:32:29 / ps"
! !

!Data class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/Data.st,v 1.5 1999-04-23 15:22:42 cg Exp $'
! !
