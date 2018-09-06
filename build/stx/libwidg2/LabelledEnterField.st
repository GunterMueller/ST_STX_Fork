"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

View subclass:#LabelledEnterField
	instanceVariableNames:'labelField textField'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!LabelledEnterField class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    An EnterField with a name. Its protocol mimics that of an
    inputfield for the most common cases. However, for access to
    some specific things, you have to get the components 
    (labelField and inputField)
    and send those message directly.

    [author:]
        Claus Gittinger
"
!

examples 
"
                                                                        [exBegin]
    |top panel f1 f2 f3 f4 model data|

    data := #('John' 'F' 'Smith' '1234567').
    model := Plug new.
    model respondTo:#firstName with:[data at:1].
    model respondTo:#firstName: with:[:arg | data at:1 put:arg].
    model respondTo:#middleInitial with:[data at:2].
    model respondTo:#middleInitial: with:[:arg | data at:2 put:arg].
    model respondTo:#lastName with:[data at:3].
    model respondTo:#lastName: with:[:arg | data at:3 put:arg].
    model respondTo:#telNo with:[data at:4].
    model respondTo:#telNo: with:[:arg | data at:4 put:arg].

    top := StandardSystemView new.
    top extent:300@300.

    panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
    panel verticalLayout:#topSpace.

    f1 := LabelledEnterField new.
    f1 label:'Firstname:'.
    f1 aspect:#firstName; change:#firstName:; model:model.
    panel add:f1.

    f2 := LabelledEnterField new.
    f2 label:'Middle Initial:'.
    f2 aspect:#middleInitial; change:#middleInitial:; model:model.
    panel add:f2.

    f3 := LabelledEnterField new.
    f3 label:'Lastname:'.
    f3 aspect:#lastName; change:#lastName:; model:model.
    panel add:f3.

    f4 := LabelledEnterField new.
    f4 label:'Telephone:'.
    f4 aspect:#telNo; change:#telNo:; model:model.
    panel add:f4.

    top open
                                                                        [exEnd]
"
! !

!LabelledEnterField methodsFor:'accessing'!

inputField
    "return the input field component"

    ^ textField
!

labelView
    "return the label component"

    ^ labelField
! !

!LabelledEnterField methodsFor:'accessing-behavior'!

acceptOnLeave:aBoolean
    "set/clear the acceptOnLeave flag in my inputField. The default is false."

     textField acceptOnLeave: aBoolean.
!

enabled
    "return true if enabled - forwarded to the inputField"

    ^ textField enabled
!

enabled:aBoolean
    "enable/disable - forwarded to the inputField"

    textField enabled:aBoolean

    "Created: / 30.3.1999 / 15:20:44 / stefan"
! !

!LabelledEnterField methodsFor:'accessing-look'!

contents
    ^ textField contents
!

contents:aString
    textField contents:aString
!

editValue 
    ^ textField editValue 
!

editValue:something 
    textField editValue:something 
!

label:aString
    labelField label:aString
! !

!LabelledEnterField methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    labelField addModelInterfaceTo:aDictionary.
    textField addModelInterfaceTo:aDictionary
!

aspectMessage:aspectSymbol 
    textField aspectMessage:aspectSymbol.
    labelField aspectMessage:aspectSymbol
!

changeMessage:aSymbol
    textField changeMessage:aSymbol
!

labelMessage:aSymbol 
    labelField labelMessage:aSymbol
!

model:aModel
    textField model:aModel.
    labelField model:aModel
! !

!LabelledEnterField methodsFor:'initialization'!

initialize
    "setup; create the label and an enterfield"

    super initialize.

    labelField := Label label:'l' in:self.
    textField := EditField in:self.

    labelField resize.
    labelField level:0.
    labelField origin:(margin @ (margin + textField margin)).

    textField origin:[(labelField origin x + labelField width) @ level]
	      extent:[(self width 
		      - margin - margin
		      - labelField width) @ (textField heightIncludingBorder)].

    "
     forward keyboard input to the enterField
    "
    self delegate:(KeyboardForwarder from:self toView:textField)

    "
     LabelledEnterField new realize
    "
! !

!LabelledEnterField methodsFor:'queries'!

preferredExtent
    "return the preferredExtent from the components sizes."

    |p lx ly ix iy|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    p := labelField preferredExtent.
    lx := p x. ly := p y.
    p := textField preferredExtent.
    ix := p x. iy := p y.
    ^ (lx + ix) @ (ly max:iy)

    "Modified: 19.7.1996 / 20:44:46 / cg"
! !

!LabelledEnterField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/LabelledEnterField.st,v 1.23 2008-10-26 20:13:28 stefan Exp $'
! !
