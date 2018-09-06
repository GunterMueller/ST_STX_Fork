"{ Package: 'stx:libui' }"

Object subclass:#AssistantPageSpec
	instanceVariableNames:'id pageTitle windowSpecSelector enterCallbackSelector
		leaveCallbackSelector canEnterQuerySelector canLeaveQuerySelector
		isEnabledQuerySelector infoText'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!AssistantPageSpec class methodsFor:'documentation'!

documentation
"
    describes a single page inside an AssistantApplication;

    [author:]
        cg (cg@CG-PC)

    [instance variables:]

    [class variables:]

    [see also:]
        look at Tools::ProjectBuilderAssistantApplication and there, especially at #assistantSpec
        for a concrete example
"
! !

!AssistantPageSpec methodsFor:'accessing'!

canEnterQuerySelector
    ^ canEnterQuerySelector
!

canEnterQuerySelector:something
    canEnterQuerySelector := something.
!

canLeaveQuerySelector
    ^ canLeaveQuerySelector
!

canLeaveQuerySelector:something
    canLeaveQuerySelector := something.
!

enterCallbackSelector
    ^ enterCallbackSelector
!

enterCallbackSelector:something
    enterCallbackSelector := something.
!

id
    ^ id
!

id:something
    id := something.
!

infoText
    ^ infoText
!

infoText:something
    infoText := something.
!

isEnabledQuerySelector
    ^ isEnabledQuerySelector
!

isEnabledQuerySelector:aBoolean
    isEnabledQuerySelector := aBoolean.
!

leaveCallbackSelector
    ^ leaveCallbackSelector
!

leaveCallbackSelector:something
    leaveCallbackSelector := something.
!

pageTitle
    ^ pageTitle
!

pageTitle:something
    pageTitle := something.
!

windowSpecSelector
    ^ windowSpecSelector
!

windowSpecSelector:something
    windowSpecSelector := something.
! !

!AssistantPageSpec class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/AssistantPageSpec.st,v 1.4 2010-11-12 11:08:28 cg Exp $'
! !
