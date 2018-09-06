"{ NameSpace: CodingExamples_GUI }"

Model subclass:#LabelAndModelDemo2
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-MVC'
!

!LabelAndModelDemo2 class methodsFor:'documentation'!

documentation
"
    Demonstrates the use of a Label and Buttons
    which have an instance of this class as model.
    The model provides the label.

    [start with:]
        LabelAndModelDemo2 new open    
"

! !

!LabelAndModelDemo2 methodsFor:'accessing '!

squaredValueString
    ^ value squared printString
!

valueString
    ^ value printString
! !

!LabelAndModelDemo2 methodsFor:'button actions'!

button1Pressed
    value := 1.
    self changed:#value
!

button2Pressed
    value := 2.
    self changed:#value
!

button3Pressed
    value := 3.
    self changed:#value
! !

!LabelAndModelDemo2 methodsFor:'initialization'!

open
    |topView p b1 b2 b3 l1 l2|

    value := 0.

    topView := StandardSystemView new extent:300@100.
    p := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:topView.

    b1 := Button label:'one' in:p.
    b2 := Button label:'two' in:p.
    b3 := Button label:'three' in:p.
    l1 := Label in:p.
    Label label:'squared is:' in:p.
    l2 := Label in:p.

    "tell the labels to react to changes of #value,
     and display the value returned by #valueString/#squaredValueString"
    l1 model:self; aspect:#value; labelMessage:#valueString.
    l2 model:self; aspect:#value; labelMessage:#squaredValueString.

    "tell the buttons to tell me when pressed"
    b1 model:self; change:#button1Pressed.
    b2 model:self; change:#button2Pressed.
    b3 model:self; change:#button3Pressed.

    topView open

    "LabelAndModelDemo2 new open"
! !

!LabelAndModelDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/MVC-Button_Label2.st,v 1.7 1997-01-03 19:48:24 cg Exp $'
! !
