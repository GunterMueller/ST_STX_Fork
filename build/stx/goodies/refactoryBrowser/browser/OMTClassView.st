"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CompositeView subclass:#OMTClassView
	instanceVariableNames:'extent'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-OMT-Diagram'
!

OMTClassView comment:'OMTClassView is the view that displays a class in the OMT diagram.

Instance Variables:
	extent  <Point> our extent - based on the class name length'
!


!OMTClassView class methodsFor:'instance creation'!

viewFor: aClass in: aBrowser
        | model view instVarView methodView label offsetBlock textHeightBlock |
        model := OMTClassModel new on: aClass in: aBrowser.
        view := self model: model.
        (view controller) menuHolder: model classMenuHolder; performer: model.
        RBParser isSmalltalkX ifTrue:[
            label := Label label:model name asText allBold.
        ] ifFalse:[
            label := model name asText allBold asComposedText.
        ].
        offsetBlock := [model name asText allBold asComposedText width // 2].
        textHeightBlock := [model name asText allBold asComposedText height].
        view add: label in: ((LayoutFrame new) leftFraction: 0.5 offset: [offsetBlock value negated]; topOffset: 0; rightFraction: 0.5 offset: offsetBlock; bottomOffset: textHeightBlock; yourself).
        instVarView := SequenceView new.
        instVarView optimizeForText.
        RBParser isSmalltalkX ifTrue:[
            instVarView model: model instVarListHolder.
        ] ifFalse:[
            instVarView model: model instVarListHolder listHolder.
            instVarView selectionChannel: model instVarListHolder selectionIndexHolder.
        ].
        instVarView controller menuHolder: model instVarMenuHolder.
        instVarView controller performer: model.
        view add: (LookPreferences edgeDecorator on: instVarView)
                in: ((LayoutFrame new) leftOffset: 2; topOffset: [textHeightBlock value]; rightFraction: 1 offset: -2; bottomFraction: 0.5 offset: [textHeightBlock value // 2]; yourself).
        methodView := SequenceView new.
        methodView optimizeForText.
        RBParser isSmalltalkX ifTrue:[
            methodView model: model methodListHolder.
        ] ifFalse:[
            methodView model: model methodListHolder listHolder.
            methodView selectionChannel: model methodListHolder selectionIndexHolder.
        ].
        methodView controller menuHolder: model methodMenuHolder.
        methodView controller performer: model.
        view add: (LookPreferences edgeDecorator on: methodView)
                in: ((LayoutFrame new) leftOffset: 2; topFraction: 0.5 offset: [textHeightBlock value // 2 + 2]; rightFraction: 1 offset: -2; bottomFraction: 1 offset: -2; yourself).
        view extent: (aClass name asText allBold asComposedText width + 4 max: self minWidth)
                        @ self height.
        ^view

    "Modified: / 3.2.2000 / 22:48:15 / cg"
! !

!OMTClassView class methodsFor:'defaults'!

height
	^140
!

minWidth
	^100
! !

!OMTClassView methodsFor:'bounds accessing'!

preferredBounds
	^0 @ 0 corner: extent
! !

!OMTClassView methodsFor:'control defaults'!

subViewWantingControl
	"Answer the subcomponent of the receiver that wants control."

	^self componentWantingControl
! !

!OMTClassView methodsFor:'controller accessing'!

defaultControllerClass
	^OMTClassController
! !

!OMTClassView methodsFor:'private'!

extent: aPoint
	extent := aPoint
! !

!OMTClassView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OMTClassView.st,v 1.10 2003-09-23 10:46:08 cg Exp $'
! !
