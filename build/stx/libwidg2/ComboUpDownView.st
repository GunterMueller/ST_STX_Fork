"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ComboBoxView subclass:#ComboUpDownView
	instanceVariableNames:'minValue maxValue step currentValue values valueIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!ComboUpDownView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    an up/down comboView (also called comboSpin).

    This is a quick&dirty hack, not yet finished and may change.

    [author:]
	Claus Gittinger

    [see also:]
	ComboListView ComboBoxView
	Slider
"
!

examples
"
  non-MVC use;
    set min/max:
								[exBegin]
     |top udBox|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     udBox := ComboUpDownView in:top.
     udBox origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     udBox bottomInset:(udBox preferredExtent y negated).

     udBox minValue:1; maxValue:99; currentValue:10.
     top open.
								[exEnd]
    set step:
								[exBegin]
     |top udBox|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     udBox := ComboUpDownView in:top.
     udBox origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     udBox bottomInset:(udBox preferredExtent y negated).

     udBox minValue:1; maxValue:99; step:10; currentValue:10.
     top open.
								[exEnd]
    define a list of values:
								[exBegin]
     |top udBox|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     udBox := ComboUpDownView in:top.
     udBox origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     udBox bottomInset:(udBox preferredExtent y negated).

     udBox values:#('red' 'green' 'blue' 'black' 'white');
	   valueIndex:1.
     top open.
								[exEnd]
"
! !

!ComboUpDownView methodsFor:'accessing'!

currentValue
    "return the value of the instance variable 'currentValue' (automatically generated)"

    ^ currentValue

    "Created: 29.3.1997 / 11:47:06 / cg"
!

currentValue:something
    "set the value of the instance variable 'currentValue' (automatically generated)"

    currentValue := something.
    values notNil ifTrue:[
	valueIndex := values indexOf:currentValue
    ].
    field contents:currentValue printString.

    "Modified: 29.3.1997 / 11:49:48 / cg"
!

maxValue
    "return the value of the instance variable 'maxValue' (automatically generated)"

    ^ maxValue

    "Created: 29.3.1997 / 11:45:29 / cg"
!

maxValue:something
    "set the value of the instance variable 'maxValue' (automatically generated)"

    maxValue := something.

    "Created: 29.3.1997 / 11:45:29 / cg"
!

minValue
    "return the value of the instance variable 'minValue' (automatically generated)"

    ^ minValue

    "Created: 29.3.1997 / 11:45:27 / cg"
!

minValue:something
    "set the value of the instance variable 'minValue' (automatically generated)"

    minValue := something.

    "Created: 29.3.1997 / 11:45:27 / cg"
!

step
    "return the value of the instance variable 'step' (automatically generated)"

    ^ step

    "Created: 29.3.1997 / 11:45:31 / cg"
!

step:something
    "set the value of the instance variable 'step' (automatically generated)"

    step := something.

    "Created: 29.3.1997 / 11:45:31 / cg"
!

valueIndex
    "return the value of the instance variable 'valueIndex' (automatically generated)"

    ^ valueIndex

    "Created: 29.3.1997 / 11:45:37 / cg"
!

valueIndex:something
    "set the value of the instance variable 'valueIndex' (automatically generated)"

    valueIndex := something.
    values notNil ifTrue:[
	currentValue := values at:valueIndex.
	field contents:currentValue printString.
    ].

    "Created: 29.3.1997 / 11:45:38 / cg"
    "Modified: 29.3.1997 / 11:51:07 / cg"
!

values
    "return the value of the instance variable 'values' (automatically generated)"

    ^ values

    "Created: 29.3.1997 / 11:45:34 / cg"
!

values:something
    "set the value of the instance variable 'values' (automatically generated)"

    values := something.

    "Created: 29.3.1997 / 11:45:34 / cg"
! !

!ComboUpDownView methodsFor:'initialization'!

initializeButton
    |v|

    v := UpDownButton in:self.
    v upAction:[self countUp].
    v downAction:[self countDown].

    pullDownButton := v.

    "Created: 29.3.1997 / 11:35:10 / cg"
    "Modified: 1.4.1997 / 12:00:51 / cg"
! !

!ComboUpDownView methodsFor:'user interaction'!

count:delta
    |newIndex newValue|

    values notNil ifTrue:[
	valueIndex notNil ifTrue:[
	    newIndex := valueIndex + delta.
	    (newIndex between:1 and:values size) ifTrue:[
		valueIndex := newIndex.

		newValue := values at:valueIndex.
	    ].
	].
    ] ifFalse:[
	currentValue notNil ifTrue:[
	    minValue notNil ifTrue:[
		maxValue notNil ifTrue:[
		    step isNil ifTrue:[
			newValue := currentValue + delta
		    ] ifFalse:[
			newValue := currentValue + (delta * step)
		    ].
		    (newValue between:minValue and:maxValue) ifFalse:[
			newValue := nil.
		    ]
		]
	    ]
	].
    ].

    newValue notNil ifTrue:[
	currentValue := newValue.
	field contents:newValue printString.
	field accept.

	action notNil ifTrue:[
	    action value:newValue
	].
    ]

    "Created: 29.3.1997 / 11:44:29 / cg"
    "Modified: 29.3.1997 / 11:46:58 / cg"
!

countDown
    self count:-1

    "Created: 29.3.1997 / 11:39:17 / cg"
!

countUp
    self count:1

    "Created: 29.3.1997 / 11:39:12 / cg"
! !

!ComboUpDownView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/ComboUpDownView.st,v 1.5 2006-11-13 16:11:29 cg Exp $'
! !

