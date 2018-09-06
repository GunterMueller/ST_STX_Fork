"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#Inspector2Tab
	instanceVariableNames:'inspector label view application priority'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector2'
!

!Inspector2Tab class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!Inspector2Tab class methodsFor:'special instance creation'!

toBrowseClass:aClass selector:initialSelectorOrNil label:label
    "create and return an inspector tab containing
     a browser on aClass (and optional initialSelector).
     This is a utility to be used by inspector2TabXXX methods, which want to embed a clas browser."
     
    |makeView view|

    makeView := 
        [
            |spec browser navigationState canvas|


            (view isNil ifTrue:[
                "/ spec := #singleClassBrowserSpec.
                spec := #multipleClassBrowserSpec.

                browser := Tools::NewSystemBrowser new.
                browser isEmbeddedBrowser:true.
                browser createBuilder.

                navigationState := browser navigationState.
                navigationState canvasType:spec.
                browser browserCanvasType:spec.

                canvas := browser browserCanvas value.
                canvas builder:(browser builder).
                navigationState canvas:canvas.
                "/ browser switchToClassHierarchyView.
                "/ browser showInheritedMethods.

                navigationState classList value:(aClass theNonMetaclass withAllSuperclasses).
                navigationState meta value:(aClass isMetaclass).
                browser classListGenerator value:(aClass theNonMetaclass withAllSuperclasses).
                browser sortByNameAndInheritance value:true.
                browser
                    selectClass:aClass;
                    selectProtocol: (Tools::BrowserList nameListEntryForALL). 
                browser switchToClass:aClass selector:initialSelectorOrNil updateHistory: false.
                view := ApplicationSubView new client: browser spec: spec.
                "/ sigh must be done after postbuild
                navigationState classListApplication addOwnerClasses value:false.
            ]).
            view
        ].

    ^ self new
            priority: 0;
            label:label;
            view: makeView;
            yourself

    "
     GenericToolbarIconLibrary systemBrowserIcon inspect
    "

    "Modified: / 09-02-2017 / 00:33:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2Tab methodsFor:'accessing'!

application:anApplicationModelOrBlockOrValueModel
    view := [ 
        ApplicationSubView new
            client: anApplicationModelOrBlockOrValueModel value;
            yourself
    ].

    "Created: / 16-01-2008 / 16:51:05 / janfrog"
    "Modified: / 17-02-2008 / 08:58:34 / janfrog"
    "Modified: / 09-02-2017 / 09:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationHolder:aValueModelOrBlock
    <resource: #obsolete> "/ use #application:
    self application: aValueModelOrBlock

    "Modified: / 09-02-2017 / 09:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector: anInspector2
    inspector := anInspector2

    "Created: / 09-02-2017 / 00:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ label

    "Created: / 16-01-2008 / 16:51:05 / janfrog"
!

label:aString
    label := aString.

    "Created: / 16-01-2008 / 16:51:05 / janfrog"
    "Modified: / 17-02-2008 / 08:58:41 / janfrog"
!

priority
    ^ priority ? 25

    "Created: / 17-02-2008 / 10:05:51 / janfrog"
!

priority:something
    priority := something.

    "Created: / 17-02-2008 / 10:05:51 / janfrog"
!

text:aStringOrValueModel

    self view:((HVScrollableView for:TextView) model: aStringOrValueModel; yourself)

    "Modified: / 17-02-2008 / 08:58:41 / janfrog"
    "Created: / 07-11-2008 / 08:40:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

view
    view isNil ifTrue:[
        application notNil ifTrue:[
            view := ApplicationSubView new.
            view client: application value.
        ]
    ] ifFalse:[
        view isBlock ifTrue:[ 
            view := view value.
        ].
    ].
    self setupView.
    ^ view

    "Created: / 16-01-2008 / 16:51:05 / janfrog"
    "Modified: / 17-02-2008 / 10:38:59 / janfrog"
    "Modified: / 13-06-2012 / 14:57:25 / cg"
    "Modified: / 09-02-2017 / 09:24:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

view:aViewOrBlockOrValueModel
    view := aViewOrBlockOrValueModel.


    "Created: / 16-01-2008 / 16:51:05 / janfrog"
    "Modified: / 17-02-2008 / 08:58:46 / janfrog"
    "Modified: / 21-05-2015 / 21:31:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

viewHolder:aValueModelOrBlock
    <resource: #obsolete> "/ use #view:
    self view: aValueModelOrBlock

    "Modified: / 09-02-2017 / 09:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

viewOrNil
    ^ view

    "Created: / 24-03-2014 / 18:23:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2Tab methodsFor:'setup'!

setupView

    (view respondsTo:#setMasterInspectorApplication:) ifTrue:[ 
        "this is for BridgeOjectInspectorView"
        view setMasterInspectorApplication:inspector.
    ].
    (view respondsTo:#sortOrderHolder:) ifTrue:[ 
        view sortOrderHolder:(inspector sortOrderHolder)
    ].

    "Modified: / 09-02-2017 / 09:24:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Inspector2Tab class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_CVS_jvrany
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

