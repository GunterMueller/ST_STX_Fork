"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAObject subclass:#MAColumn
	instanceVariableNames:'report accessor'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAColumn class methodsFor:'instance creation'!

new
	^ self basicNew initialize
! !

!MAColumn class methodsFor:'accessing-description'!

descriptionComment
	^ MAStringDescription new
		accessor: #comment;
		label: 'Comment';
		priority: 200;
		yourself
!

descriptionTitle
	^ MAStringDescription new
		accessor: #title;
		label: 'Title';
		priority: 100;
		yourself
! !

!MAColumn class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAColumn methodsFor:'accessing'!

column
	^ self report cache collect: [ :each | self valueFor: each ]
!

index
	^ self report columns indexOf: self
!

report
	^ report
!

sorterStyle
	^ self isSorted
		ifTrue: [
			self isReversed
				ifTrue: [ self report sorterStyles first ]
				ifFalse: [ self report sorterStyles second ] ]
		ifFalse: [ String new ]
! !

!MAColumn methodsFor:'accessing-defaults'!

defaultCascade
	^ #( yourself )
!

defaultComment
	^ nil
!

defaultFilter
	^ false
!

defaultFooter
	^ nil
!

defaultFormat
	^ MessageSend receiver: self selector: #renderCellContent:on:
!

defaultFormatter
	^ MessageSend receiver: self selector: #stringFor:
!

defaultLabel
	^ self accessor selector asCapitalizedPhrase
!

defaultRenderer
	^ MessageSend receiver: self selector: #renderCellContent:on:
!

defaultSorter
	^ [ :a :b | self sort: a and: b ]
!

defaultTitle
	^ self cascade first asCapitalizedPhrase
!

defaultVisible
	^ true
! !

!MAColumn methodsFor:'accessing-properties'!

properties
	^ properties
!

propertyAt: aSymbol
	^ self properties at: aSymbol
!

propertyAt: aSymbol ifAbsent: aBlock
	^ self properties at: aSymbol ifAbsent: aBlock
!

propertyAt: aSymbol ifAbsentPut: aBlock
	^ self properties at: aSymbol ifAbsentPut: aBlock
!

propertyAt: aSymbol put: anObject
	^ self properties at: aSymbol put: anObject
! !

!MAColumn methodsFor:'accessing-settings'!

accessor
	^ accessor
!

accessor: anAccessor
	"Set the accessor used to get the column value for a given row object."

	accessor := anAccessor asAccessor
!

cascade
	^ self propertyAt: #cascade ifAbsent: [ self defaultCascade ]
!

comment
	^ self propertyAt: #comment ifAbsent: [ self defaultComment ]
!

comment: aString
	"A descriptive comment of this column."

	self propertyAt: #comment put: aString
!

filter
	^ self propertyAt: #filter ifAbsent: [ self defaultFilter ]
!

filter: aBoolean
	"Enable or disable filtering of this column."

	self propertyAt: #filter put: aBoolean
!

footer
	^ self propertyAt: #footer ifAbsent: [ self defaultFooter ]
!

footer: aBlock
	"A block that renders the footer of this column."
	
	self propertyAt: #footer put: aBlock
!

formatter
	^ self propertyAt: #formatter ifAbsent: [ self defaultFormatter ]
!

formatter: aBlock
	"A block that converts the row value to a string."
	
	self propertyAt: #formatter put: aBlock
!

label
	^ self propertyAt: #label ifAbsent: [ self defaultLabel ]
!

label: aString
	"The label of this column, also used to toggle the sort order of this column."
	
	self propertyAt: #label put: aString
!

renderer
	^ self propertyAt: #renderer ifAbsent: [ self defaultRenderer ]
!

renderer: aBlock
	"A block that renders the row value to HTML."

	self propertyAt: #renderer put: aBlock
!

sorter
	^ self propertyAt: #sorter ifAbsent: [ self defaultSorter ]
!

sorter: aBlock
	"A sort block for this column."

	self propertyAt: #sorter put: aBlock
!

visible
	^ self propertyAt: #visible ifAbsent: [ self defaultVisible ]
!

visible: aBoolean
	"Make this column visible or invisible."
	
	self propertyAt: #visible put: aBoolean
! !

!MAColumn methodsFor:'actions'!

refresh
	self properties removeKey: #uniqueValues ifAbsent: [ ]
!

valueFor: aRow
	"Answer the column value for aRow."

	^ accessor read: aRow
! !

!MAColumn methodsFor:'deprecated'!

cascade: anArray
	self deprecatedApi: 'Use MAColumn>>#accessor: instead.'.
	self accessor: anArray
!

format
	self deprecatedApi: 'Use MAColumn>>#renderer instead.'.
	^ self renderer
!

format: aBlock
	self deprecatedApi: 'Use MAColumn>>#renderer: instead.'.
	self renderer: aBlock
!

selector: aSymbol
	self deprecatedApi: 'Use MAColumn>>#accessor: instead.'.
	self accessor: aSymbol
!

title
	self deprecatedApi: 'Use MAColumn>>#label instead.'.
	^ self label
!

title: aString
	self deprecatedApi: 'Use MAColumn>>#label: instead.'.
	self label: aString
! !

!MAColumn methodsFor:'exporting'!

exportContent: anObject index: aNumber on: aStream
	| string |
	string := (self formatter value: anObject) collect: [ :char | 
		char isSeparator
			ifTrue: [ Character space ]
			ifFalse: [ char ] ].
	aStream nextPutAll: string
!

exportHeadOn: aStream
	self label isNil
		ifFalse: [ aStream nextPutAll: self label ]
! !

!MAColumn methodsFor:'initialization'!

initialize
	super initialize.
	self accessor: #yourself
!

setReport: aReport
	report := aReport
! !

!MAColumn methodsFor:'private'!

filterBlock
	^ self 
		propertyAt: #filterValue
		ifPresent: [ :value | [ :row | (self valueFor: row) = value ] ]
!

sort: aFirstObject and: aSecondObject
	| one two |
	one := self valueFor: aFirstObject.
	two := self valueFor: aSecondObject.
	(one respondsTo: #<=) ifFalse: [
		one := self formatter value: one.
		two := self formatter value: two ].
	^ one <= two
!

sortRows: aCollection
	| result |
	result := SortedCollection new: aCollection size.
	result
		sortBlock: self sorter;
		addAll: aCollection.
	^ self isReversed
		ifFalse: [ result ]
		ifTrue: [ result reversed ]
!

stringFor: anObject
	"Answer a string representation of the row value."
	
	^ anObject displayString
!

uniqueValues
	"Answer the unique rows with the unique values, used for filtering."

	^ self propertyAt: #uniqueValues ifAbsentPut: [
		| uniqueValues |
		uniqueValues := Dictionary new.
		self report rows
			do: [ :row | uniqueValues at: (self valueFor: row) put: row ].
		uniqueValues := uniqueValues values asArray.
		self sorter isNil
			ifFalse: [ uniqueValues sort: self sorter ].
		uniqueValues
			collect: [ :row | self valueFor: row ] ]
! !

!MAColumn methodsFor:'rendering'!

renderCell: anObject index: anInteger on: html
	html tableData: [ self renderer valueWithEnoughArguments: (Array with: anObject with: html with: anInteger) ]
!

renderCellContent: anObject on: html
	html render: (self formatter value: (self valueFor: anObject))
!

renderFilterCellOn: html
	html tableHeading: [ self renderFilterContentOn: html ]
!

renderFilterContentOn: html
	self isFiltered 
		ifFalse: [ ^ self ].
	html form style: 'margin: 0; border: 0; padding: 0;'; with: [
		html select
			beOptional;
			beSubmitOnChange;
			optionalLabel: '(all)';
			labels: self formatter;
			list: self uniqueValues;
			selected: (self propertyAt: #filterValue ifAbsent: [ nil ]);
			callback: [ :value |
				value isNil
					ifTrue: [ self properties removeKey: #filterValue ifAbsent: [ ] ]
					ifFalse: [ self propertyAt: #filterValue put: value ].
				self report refresh ] ]
!

renderFootCellOn: html
	html tableData: [ self renderFootContentOn: html ]
!

renderFootContentOn: html
	html render: self footer
!

renderHeadCellOn: html
	html tableHeading
		title: self comment;
		class: self sorterStyle;
		with: [
			self isSortable
				ifFalse: [ self renderHeadContentOn: html ]
				ifTrue: [
					html anchor
						callback: [ self report sort: self ];
						with: [ self renderHeadContentOn: html ] ] ]
!

renderHeadContentOn: html
	html render: self label
! !

!MAColumn methodsFor:'testing'!

isFiltered
	^ self filter
!

isReversed
	^ self report sortReversed
!

isSortable
	^ self report sortEnabled and: [ self sorter notNil ]
!

isSorted
	^ self report sortColumn = self
!

isVisible
	^ self visible
! !

!MAColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAColumn.st,v 1.2 2009-08-14 20:29:38 cg Exp $'
! !
