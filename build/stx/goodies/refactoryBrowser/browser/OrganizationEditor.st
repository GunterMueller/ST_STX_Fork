"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserTextTool subclass:#OrganizationEditor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

OrganizationEditor comment:'OrganizationEditor is used to edit the class categories or the protocols of classes. It is similar to the "edit all" feature of the standard browser.'
!


!OrganizationEditor methodsFor:'accepting'!

accept: aText from: aController 
	| organization class |
	organization := self organization.
	organization notNil ifTrue: 
			[organization changeFromString: self textController text.
			class := self selectedClass.
			class notNil ifTrue: 
					[class reorganize.
					class logOrganizationChange]].
	codeModel navigate.
	self updateContents
! !

!OrganizationEditor methodsFor:'accessing'!

organization
        | class |
        class := self selectedClass.
        (class isNil and: [self category isNil])
                ifTrue: [^RefactoryBrowserPlatformSupport systemOrganization].
        class notNil ifTrue: [^class organization].
        ^nil

    "Modified: / 3.2.2000 / 23:24:41 / cg"
! !

!OrganizationEditor methodsFor:'testing'!

isEnabled
	^self category isNil or: [self nonMetaClass notNil]
! !

!OrganizationEditor methodsFor:'updating'!

updateContents
	| organization |
	organization := self organization.
	organization notNil
		ifTrue: [self text: organization printString]
		ifFalse: [self text: '']
! !

!OrganizationEditor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OrganizationEditor.st,v 1.6 2003-09-23 10:48:05 cg Exp $'
! !
