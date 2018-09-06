"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MAColorComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MAColorComponent comment:'Seaside component of MAColorDescription. I display a little box with the current selected color. If you click on the box, a beautiful palette will be displayed thanks to MAColorChooser.'
!


!MAColorComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAColorComponent methodsFor:'accessing'!

form
	| form |
	form := Form extent: self width @ self height depth: 32.
	form getCanvas
		drawPolygon: (Array with: 0 @ self height with: 0 @ 0 with: self width @ 0)
			color: Color white borderWidth: 0 borderColor: Color white;
		drawPolygon: (Array with: 0 @ self height with: self width @ self height with: self width @ 0)
			color: Color black borderWidth: 0 borderColor: Color white;
		fillRectangle: (0 @ 0 extent: self width @ self height)
			color: self value.
	^ form
!

height
	^ 15
!

value
	^ super value ifNil: [ self description kind transparent ]
!

width
	^ 30
! !

!MAColorComponent methodsFor:'actions'!

choose
	self chooser: (MAColorChooser color: self value)
! !

!MAColorComponent methodsFor:'rendering'!

renderEditorOn: html
	html imageButton
		id: self labelId;
		callback: [ self choose ];
		attributeAt: 'width' put: self width;
		attributeAt: 'height' put: self height;
		attributeAt: 'src' put: (html context urlForDocument: self form)
!

renderViewerOn: html
	html image
		id: self labelId;
		form: self form
! !

!MAColorComponent methodsFor:'testing'!

hasLabelId
	^ true
! !

!MAColorComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAColorComponent.st,v 1.2 2009-08-14 20:27:01 cg Exp $'
! !
