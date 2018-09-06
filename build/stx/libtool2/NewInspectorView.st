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
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

VariableVerticalPanel subclass:#NewInspectorView
	instanceVariableNames:'inspectorView userSpace workSpace inspectedObject'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-NewInspector'
!

!NewInspectorView class methodsFor:'documentation'!

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


!

documentation
"
    a new (multipane) inspector;
    open with:
	Tools::NewInspectorView inspect:Object

    install as standard inspector:
	Smalltalk at:#Inspector put:(Tools::NewInspectorView)

    [open with:]
	Tools::NewInspectorView
		inspect:(Array with:#hello with:'hello' with:#(1 2 3) asSortedCollection with:Display)

    [author:]
	Claus Atzkern
"
!

examples

"
    open an inspector on an array
									[exBegin]
    |array|

    array := Array new:5.
    array at:1 put:(Array new:400).
    Tools::NewInspectorView inspect:array
									[exEnd]
"
! !

!NewInspectorView class methodsFor:'instance creation'!

inspect:anObject
    "start inspector on an instance
    "
    ^ self openOn:anObject
!

openOn:anObject
    "start an inspector on some object
    "

    |top isp|

    top := StandardSystemView new extent:600@400.
    isp := NewInspectorView origin:0.0@0.0  corner:1.0@1.0 in:top.
    isp inspect:anObject.
    top open.

    ^ isp.
! !

!NewInspectorView methodsFor:'accessing'!

inspect:anInstance

    inspectedObject := anInstance.
    self topView label:(inspectedObject class name asString).
    inspectorView inspect:anInstance.
    self updateWorkSpace.

! !

!NewInspectorView methodsFor:'initialization'!

initialize
    |view wsHeight|

    super initialize.

    view := SimpleView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:self.

    inspectorView := NewInspectorPanelView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:view.
    workSpace     := Workspace          origin:0.0 @ 1.0 corner:1.0 @ 1.0 in:view.
    userSpace     := Workspace          origin:0.0 @ 0.5 corner:1.0 @ 1.0 in:self.

    wsHeight := (workSpace preferredExtentForLines:1 cols:10) y.
    workSpace     topInset:wsHeight negated.
    inspectorView bottomInset:wsHeight.

    userSpace acceptAction:[:theText|inspectorView accept:theText notifying:workSpace].
    workSpace acceptAction:[:theText|inspectorView accept:theText notifying:workSpace].

    userSpace   doItAction:[:theCode|inspectorView doIt:theCode notifying:workSpace].
    workSpace   doItAction:[:theCode|inspectorView doIt:theCode notifying:workSpace].

    inspectorView action:[:el|self updateWorkSpace].

    inspectorView valueChangedAction:[:el||lbl|
	workSpace list:(Array with:(el displayString)).
    ].

    "Modified: 18.3.1997 / 10:57:34 / cg"
! !

!NewInspectorView methodsFor:'update'!

updateWorkSpace
    "update the workSpace
    "
    workSpace list:(Array with:(inspectorView selectedInstanceVar displayString)).
! !

!NewInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
