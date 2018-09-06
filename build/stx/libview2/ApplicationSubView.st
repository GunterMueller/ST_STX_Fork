"
 COPYRIGHT (c) 1999 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

View subclass:#ApplicationSubView
	instanceVariableNames:'application buildMenu'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!ApplicationSubView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 eXept Software AG
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
    needed sometimes, when a full application is embeded into an ExtendedComboBox
    or subcanvas AND you want to avoid, that this application accesses the outer
    applications aspects (by returning a private application instance).

    Notice: you may have to manually set this views application to be the embedded app
           (i.e. via #application:) unless it is set by #client:....

    see self-embedding example in CodingExamples_GUI::GUIDemoExtendedComboBox
"
!

examples
"
    see self-embedding example in CodingExamples_GUI::GUIDemoExtendedComboBox.
                                                                [exBegin]
    |top sub app|

    top := StandardSystemView new.
    sub := ApplicationSubView new.

    app := FileBrowserV2 new.
    app createBuilder.
    app window:sub.
    sub client:app.

    top addSubView:sub.
    sub origin:(0.1@0.1) corner:(0.9@0.9).
    top open.
                                                                [exEnd]
                                                                [exBegin]
    |top sub app|

    top := StandardSystemView new.
    sub := ApplicationSubView new.

    app := Tools::NewSystemBrowser new.
    app createBuilder.
    app window:sub.
    sub client:app.

    top addSubView:sub.
    sub origin:(0.1@0.1) corner:(0.9@0.9).
    top open.
                                                                [exEnd]
"
! !

!ApplicationSubView methodsFor:'accessing'!

application
    "return the value of the instance variable 'application' (automatically generated)"

    ^ application
!

application:something
    "set the value of the instance variable 'application' (automatically generated)"

    application := something.
!

buildMenu:aBoolean
    "if true, the main menu is also built. Default is false"

    buildMenu := aBoolean.
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder
    self 
        client:anApplication 
        spec:aWindowSpecOrSpecSymbol 
        builder:aBuilder 
        withMenu:(buildMenu ? false).
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:withMenu
    self application:anApplication.
    super client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:withMenu.

    "Modified: / 25-07-2011 / 17:51:22 / cg"
! !

!ApplicationSubView methodsFor:'events'!

destroy
    |app|

    (app := self application) notNil ifTrue:[
        app ~~ self topView application ifTrue:[
            app release
        ]
    ].
    super destroy.

!

preRealize
    |app|

    super preRealize.
    (app := self application) notNil ifTrue:[
        app preOpenAsSubcanvasWith:app builder
    ]

    "Created: / 05-03-2014 / 18:46:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

realize
    |app|

    super realize.
    (app := self application) notNil ifTrue:[
        app postOpenAsSubcanvasWith:app builder
    ]
! !

!ApplicationSubView methodsFor:'testing'!

isApplicationSubView
    ^ true
! !

!ApplicationSubView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ApplicationSubView.st,v 1.12 2014-03-05 20:25:41 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/ApplicationSubView.st,v 1.12 2014-03-05 20:25:41 vrany Exp $'
! !

