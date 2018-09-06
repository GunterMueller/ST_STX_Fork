"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MATextAreaComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MATextAreaComponent comment:'I display an html text area for the magritte MAMemoDescription.'
!


!MATextAreaComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATextAreaComponent methodsFor:'rendering'!

renderEditorOn: html
	html textArea
		id: self labelId;
		rows: self description lineCount;
		on: #string of: self
!

renderViewerOn: html
	(self string findTokens: Character cr)
		do: [ :each | html render: each ]
		separatedBy: [ html break ]
! !

!MATextAreaComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MATextAreaComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATextAreaComponent.st,v 1.2 2009-08-14 20:26:41 cg Exp $'
! !
