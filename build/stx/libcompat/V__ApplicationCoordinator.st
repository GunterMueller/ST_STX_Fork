"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: V }"

ApplicationModel subclass:#ApplicationCoordinator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST/V'
!

!ApplicationCoordinator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    Dummy ST-V compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    No Warranty, no functionality: all this class exists for is to allow subclasses
    to be filed in and find some home to allow porting...

    [author:]
        Claus Gittinger
"
! !

!ApplicationCoordinator class methodsFor:'startup'!

constructViewFor: aCoordinator
    "Create a new view of the application <aCoordinator> and define its structure."

    | view |
    view := self createViewFor: aCoordinator.
    self buildView: view forModel: aCoordinator.
    ^view
!

createViewFor: aCoordinator
    "Create and configure a window for <aCoordinator>."

    | window |
    window := self windowClass new.
    window isDialogTopPane ifFalse: [ window owner: window ].
    "/ window windowPolicy: ( self windowPolicyClass on: window ).
    aCoordinator when: #closeApplication send: #close to: window.
    ^window
!

open
    "Build and open a window for a new instance of the receiver."

    | coordinator |
    coordinator := self new.
    self open: coordinator.
    ^coordinator
!

open: aCoordinator
    "Build and open a window for <aCoordinator>."

    | view |
    view := self constructViewFor: aCoordinator.
    view open
!

windowClass
    "Answer the class of windows for the receiver."

    (Smalltalk isSmalltalkX) ifTrue:[
        ^StandardSystemView
    ] ifFalse:[    
        ( Smalltalk includesKey: #MDISystem ) ifFalse: [ ^TopPane ].
        Smalltalk isRunTime ifFalse: [
            ( Smalltalk at: #MDISystem ) isActive
                ifTrue: [ ^Smalltalk at: #MDIChild ] ].
        ^TopPane
    ].
!

windowPolicyClass
    "Answer the class of window policy for the receiver."

    ^nil "/ StandardWindowPolicy "current"
! !

!ApplicationCoordinator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/V__ApplicationCoordinator.st,v 1.4 2017-01-26 10:25:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/V__ApplicationCoordinator.st,v 1.4 2017-01-26 10:25:14 cg Exp $'
! !

