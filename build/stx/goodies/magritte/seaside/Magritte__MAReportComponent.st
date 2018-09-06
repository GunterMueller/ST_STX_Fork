"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescriptionComponent subclass:#MAReportComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAReportComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAReportComponent methodsFor:'rendering'!

renderContentOn: html
	html table id: self labelId; with: [
		self renderTableCaptionOn: html.
		self renderTableSummaryOn: html.
		self renderTableHeadOn: html.
		self renderTableFootOn: html.
		self renderTableBodyOn: html ]
! !

!MAReportComponent methodsFor:'rendering-content'!

renderTableContentOn: html
!

renderTableEmptyOn: html
!

renderTableFooterOn: html
!

renderTableHeaderOn: html
	html tableRow: [
		self description do: [ :each |
			each isVisible ifTrue: [
				html tableData: each label ] ] ]
! !

!MAReportComponent methodsFor:'rendering-parts'!

renderTableBodyOn: html
	(html tag: 'tbody') with: [
		self description showBody ifTrue: [
			(self value isNil or: [ self value isEmpty ])
				ifTrue: [ self renderTableEmptyOn: html ]
				ifFalse: [ self renderTableContentOn: html ] ] ]
!

renderTableCaptionOn: html
	self description caption isNil ifFalse: [
		(html tag: 'caption')
			with: self description caption ]
!

renderTableFootOn: html
	(html tag: 'tfoot') with: [
		self description showFooter
			ifTrue: [ self renderTableFooterOn: html ] ]
!

renderTableHeadOn: html
	(html tag: 'thead') with: [
		self description showHeader
			ifTrue: [ self renderTableHeaderOn: html ] ]
!

renderTableSummaryOn: html
	self description summary isNil ifFalse: [
		(html tag: 'summary')
			with: self description summary ]
! !

!MAReportComponent methodsFor:'testing'!

hasLabelId
	^ true
! !

!MAReportComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAReportComponent.st,v 1.2 2009-08-14 20:26:45 cg Exp $'
! !
