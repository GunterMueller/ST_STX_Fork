"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponent subclass:#MAReport
	instanceVariableNames:'rows cache columns properties backtracked'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAReport class methodsFor:'instance creation'!

rows: aCollection
	^ self new
		rows: aCollection;
		yourself
!

rows: aCollection description: aDescription
	| report |
	report := self rows: aCollection.
	aDescription asContainer do: [ :each |
		report addColumnDescription: each ].
	^ report
! !

!MAReport class methodsFor:'accessing-description-batch'!

description4000
	^ MABooleanDescription new
		accessor: #showBatch;
		label: 'Show Batch';
		priority: 4000;
		yourself
!

description4100
	^ MANumberDescription new
		accessor: #batchSize;
		label: 'Size';
		priority: 4100;
		yourself
!

description4200
	^ MABooleanDescription new
		accessor: #showBatchFirstLast;
		label: 'Show First/Last';
		priority: 4200;
		yourself
!

description4300
	^ MABooleanDescription new
		accessor: #showBatchPreviousNext;
		label: 'Show Previous/Next';
		priority: 4300;
		yourself
!

description4400
	^ MABooleanDescription new
		accessor: #showBatchPages;
		label: 'Show Pages';
		priority: 4400;
		yourself
! !

!MAReport class methodsFor:'accessing-description-table'!

description2000
	^ MABooleanDescription new
		accessor: #showHeader;
		label: 'Show Header';
		priority: 2000;
		yourself
!

description2100
	^ MABooleanDescription new
		accessor: #showBody;
		label: 'Show Body';
		priority: 2100;
		yourself
!

description2200
	^ MAStringDescription new
		accessor: #tableEmpty;
		label: 'Empty';
		priority: 2200;
		yourself
!

description2300
	^ MABooleanDescription new
		accessor: #showFooter;
		label: 'Show Footer';
		priority: 2300;
		yourself
!

description2400
	^ MABooleanDescription new
		accessor: #showCaption;
		label: 'Show Caption';
		priority: 2300;
		yourself
!

description2500
	^ MAStringDescription new
		accessor: #tableCaption;
		label: 'Caption';
		priority: 2500;
		yourself
!

description2600
	^ MABooleanDescription new
		accessor: #showSummary;
		label: 'Show Summary';
		priority: 2600;
		yourself
!

description2700
	^ MAStringDescription new
		accessor: #tableSummary;
		label: 'Summary';
		priority: 2700;
		yourself
! !

!MAReport class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAReport methodsFor:'accessing'!

rows
	"Return the rows of the receiver."

	^ rows
!

rows: aCollection
	"Set the rows of the receiver."
	
	rows := aCollection.
	self refresh
! !

!MAReport methodsFor:'accessing-defaults'!

defaultBatchPage
	^ 1
!

defaultBatchSize
	^ 10
!

defaultRowFilter
	^ nil
!

defaultRowPeriod
	^ 1
!

defaultRowStyles
	^ Array with: 'odd' with: 'even'
!

defaultShowBatch
	^ true
!

defaultShowBatchFirstLast
	^ false
!

defaultShowBatchPages
	^ true
!

defaultShowBatchPreviousNext
	^ true
!

defaultShowBody
	^ true
!

defaultShowCaption
	^ false
!

defaultShowFilter
	^ false
!

defaultShowFooter
	^ false
!

defaultShowHeader
	^ true
!

defaultShowSummary
	^ false
!

defaultSortColumn
	^ nil
!

defaultSortEnabled
	^ true
!

defaultSortReversed
	^ false
!

defaultSorterStyles
	^ Array with: 'ascending' with: 'descending'
!

defaultTableCaption
	^ nil
!

defaultTableEmpty
	^ 'The report is empty.'
!

defaultTableSummary
	^ nil
! !

!MAReport methodsFor:'accessing-readonly'!

cache
	"Return the cached rows of the receiver, these rows are filtered and sorted."

	cache isNil ifTrue: [
		self cache: (self
			sortRows: (self
				filterRows: self
					rows asArray)) ].
	^ cache
!

cache: aCollection
	cache := aCollection
!

columns
	^ columns
!

columns: aCollection
	columns := aCollection
!

states
	^ Array with: backtracked
!

visible
	^ self showBatch
		ifFalse: [ self cache ]
		ifTrue: [
			self cache
				copyFrom: self batchStartIndex
				to: self batchEndIndex ]
!

visibleColumns
	^ self columns select: [ :each | each isVisible ]
! !

!MAReport methodsFor:'accessing-settings'!

batchPage
	^ backtracked at: #batchPage ifAbsentPut: [ self defaultBatchPage ]
!

batchPage: anInteger
	backtracked at: #batchPage put: anInteger
!

batchSize
	^ properties at: #batchSize ifAbsent: [ self defaultBatchSize ]
!

batchSize: anInteger
	properties at: #batchSize put: anInteger
!

rowFilter
	^ backtracked at: #rowFilter ifAbsent: [ self defaultRowFilter ]
!

rowFilter: aBlock
	backtracked at: #rowFilter put: aBlock.
	self refresh
!

rowPeriod
	^ properties at: #rowPeriod ifAbsent: [ self defaultRowPeriod ]
!

rowPeriod: aNumber
	properties at: #rowPeriod put: aNumber
!

rowStyles
	^ properties at: #rowStyles ifAbsent: [ self defaultRowStyles ]
!

rowStyles: aCollection
	properties at: #rowStyles put: aCollection
!

showBatch
	^ properties at: #showBatch ifAbsent: [ self defaultShowBatch ]
!

showBatch: aBoolean
	properties at: #showBatch put: aBoolean
!

showBatchFirstLast
	^ properties at: #showBatchFirstLast ifAbsent: [ self defaultShowBatchFirstLast ]
!

showBatchFirstLast: aBoolean
	properties at: #showBatchFirstLast put: aBoolean
!

showBatchPages
	^ properties at: #showBatchPages ifAbsent: [ self defaultShowBatchPages ]
!

showBatchPages: aBoolean
	properties at: #showBatchPages put: aBoolean
!

showBatchPreviousNext
	^ properties at: #showBatchPreviousNext ifAbsent: [ self defaultShowBatchPreviousNext ]
!

showBatchPreviousNext: aBoolean
	properties at: #showBatchPreviousNext put: aBoolean
!

showBody
	^ properties at: #showBody ifAbsent: [ self defaultShowBody ]
!

showBody: aBoolean
	properties at: #showBody put: aBoolean
!

showCaption
	^ properties at: #showCaption ifAbsent: [ self defaultShowCaption ]
!

showCaption: aBoolean
	properties at: #showCaption put: aBoolean
!

showFilter
	^ properties at: #showFilter ifAbsent: [ self defaultShowFilter ]
!

showFilter: aBoolean
	properties at: #showFilter put: aBoolean
!

showFooter
	^ properties at: #showFooter ifAbsent: [ self defaultShowFooter ]
!

showFooter: aBoolean
	properties at: #showFooter put: aBoolean
!

showHeader
	^ properties at: #showHeader ifAbsent: [ self defaultShowHeader ]
!

showHeader: aBoolean
	properties at: #showHeader put: aBoolean
!

showSummary
	^ properties at: #showSummary ifAbsent: [ self defaultShowSummary ]
!

showSummary: aBoolean
	properties at: #showSummary put: aBoolean
!

sortColumn
	^ backtracked at: #sortColumn ifAbsent: [ self defaultSortColumn ]
!

sortColumn: aColumn
	backtracked at: #sortColumn put: aColumn
!

sortEnabled
	^ properties at: #sortEnabled ifAbsent: [ self defaultSortEnabled ]
!

sortEnabled: aBoolean
	properties at: #sortEnabled put: aBoolean
!

sortReversed
	^ backtracked at: #sortReversed ifAbsent: [ self defaultSortReversed ]
!

sortReversed: aBoolean
	backtracked at: #sortReversed put: aBoolean
!

sorterStyles
	^ properties at: #sorterStyles ifAbsent: [ self defaultSorterStyles ]
!

sorterStyles: aCollection
	properties at: #sorterStyles put: aCollection
!

tableCaption
	^ properties at: #tableCaption ifAbsent: [ self defaultTableCaption ]
!

tableCaption: aString
	properties at: #tableCaption put: aString
!

tableEmpty
	^ properties at: #tableEmpty ifAbsent: [ self defaultTableEmpty ]
!

tableEmpty: aString
	properties at: #tableEmpty put: aString
!

tableSummary
	^ properties at: #tableSummary ifAbsent: [ self defaultTableSummary ]
!

tableSummary: aString
	properties at: #tableSummary put: aString
! !

!MAReport methodsFor:'actions'!

nextPage
	self isOnLastPage
		ifFalse: [ self batchPage: self batchPage + 1 ]
!

previousPage
	self isOnFirstPage
		ifFalse: [ self batchPage: self batchPage - 1 ]
!

refresh
	self cache: nil; batchPage: self defaultBatchPage.
	self columns do: [ :each | each refresh ]
!

sort: aColumn
	aColumn = self sortColumn
		ifTrue: [
			self sortReversed
				ifFalse: [ self sortReversed: true ]
				ifTrue: [ self sortColumn: nil; sortReversed: false ] ]
		ifFalse: [ self sortColumn: aColumn; sortReversed: false ].
	self refresh
! !

!MAReport methodsFor:'columns'!

addColumn: aColumn
	columns := columns copyWith: aColumn.
	^ aColumn setReport: self; yourself
!

addColumnCascade: anArray
	^ (self addColumn: MAColumn new)
		cascade: anArray;
		yourself
!

addColumnDescription: aDescription
	^ self addColumn: (aDescription reportColumnClass new
		description: aDescription;
		yourself)
!

addColumnSelector: aSelector
	^ (self addColumn: MAColumn new)
		selector: aSelector;
		yourself
!

moveDown: aColumn
	| index |
	index := self columns indexOf: aColumn ifAbsent: [ ^ self ].
	self columns swap: index with: (index = self size
		ifFalse:[ index + 1 ]
		ifTrue: [ 1 ])
!

moveUp: aColumn
	| index |
	index := self columns indexOf: aColumn ifAbsent: [ ^ self ].
	self columns swap: index with: (index = 1
		ifFalse:[ index - 1 ]
		ifTrue: [ self size ])
!

remove: aColumn
	columns := columns copyWithout: aColumn
! !

!MAReport methodsFor:'exporting'!

export
	^ String streamContents: [ :stream |
		self exportOn: stream ]
!

exportBodyOn: aStream
	self cache keysAndValuesDo: [ :index :row |
		self visibleColumns
			do: [ :column |
				column
					exportContent: (column valueFor: row)
					index: index on: aStream ]
			separatedBy: [ aStream tab ].
		aStream nextPut: Character cr ]
!

exportHeaderOn: aStream
	self visibleColumns
		do: [ :each | each exportHeadOn: aStream ]
		separatedBy: [ aStream tab ].
	aStream nextPut: Character cr
!

exportOn: aStream
	self showHeader
		ifTrue: [ self exportHeaderOn: aStream ].
	self showBody
		ifTrue: [ self exportBodyOn: aStream ]
! !

!MAReport methodsFor:'initialization'!

initialize
	super initialize.
	rows := columns := Array new.
	properties := Dictionary new.
	backtracked := Dictionary new
! !

!MAReport methodsFor:'private'!

filterRows: aCollection
	| filters filter |
	filters := OrderedCollection new.
	self hasRowFilter
		ifTrue: [ filters add: self rowFilter ].
	self columns do: [ :each |
		each isFiltered ifTrue: [
			filter := each filterBlock.
			filter isNil
				ifFalse: [ filters add: filter ] ] ].
	^ filters isEmpty
		ifTrue: [ aCollection ]
		ifFalse: [ aCollection select: [ :row | filters allSatisfy: [ :block | block value: row ] ] ]
!

rowStyleForNumber: aNumber
	^ self rowStyles
		at: ((aNumber - 1 // self rowPeriod) \\ self rowStyles size) + 1
		ifAbsent: [ String new ]
!

sortRows: aCollection
	^ self isSorted
		ifFalse: [ aCollection ]
		ifTrue: [ self sortColumn sortRows: aCollection ]
! !

!MAReport methodsFor:'private-batch'!

batchEndIndex
	^ self batchPage * self batchSize min: self cache size
!

batchMaxPages
	^ (self cache size / self batchSize)
		ceiling
!

batchPageRange
	^ self batchPageRangeStart to: self batchPageRangeEnd
!

batchPageRangeEnd
	^ self batchMaxPages min: self batchPage + 9
!

batchPageRangeStart
	^ self defaultBatchPage max: self batchPage - 9
!

batchStartIndex
	^ (self batchPage - 1) * self batchSize + 1
!

isOnFirstPage
	^ self batchPage = 1
!

isOnLastPage
	^ self batchPage = self batchMaxPages
! !

!MAReport methodsFor:'rendering'!

renderContentOn: html
	html table
		id: self ajaxId; class: 'report';
		with: [ self renderTableOn: html ]
!

renderTableOn: html
	self showCaption
		ifTrue: [ self renderTableCaptionOn: html ].
	self showSummary
		ifTrue: [ self renderTableSummaryOn: html ].
	html tableHead: [
		self showHeader
			ifTrue: [ self renderTableHeadOn: html ].
		self showFilter
			ifTrue: [ self renderTableFilterOn: html ] ].

	((self showBatch
		and: [ self hasMoreThanOnePage ])
		or: [ self showFooter ]) ifTrue: [
			"we must not produce an empty tfoot element, this is not valid xhtml"
			html tableFoot: [
				self showFooter
					ifTrue: [ self renderTableFootOn: html ].
				self showBatch
					ifTrue: [ self renderTableBatchOn: html ] ] ].

	html tableBody: [
		self showBody
			ifTrue: [ self renderTableBodyOn: html ] ]
! !

!MAReport methodsFor:'rendering-batch'!

renderBatchFirstOn: html
	self isOnFirstPage
		ifFalse: [ html anchor callback: [ self batchPage: self defaultBatchPage ]; with: '|<' ]
		ifTrue: [ html text: '|<' ].
	html space
!

renderBatchItemsOn: html
	self batchPageRangeStart > self defaultBatchPage
		ifTrue: [ html text: '...'; space ].
	self batchPageRange do: [ :index |
		self batchPage = index
			ifFalse: [ html anchor callback: [ self batchPage: index ]; with: index ]
			ifTrue: [ html span class: 'current'; with: index ].
		html space ].
	self batchPageRangeEnd < (self batchMaxPages - 1)
		ifTrue: [ html text: '...'; space ].
	self batchPageRangeEnd = self batchMaxPages
		ifFalse: [
			html anchor
				callback: [ self batchPage: self batchMaxPages ];
				with: self batchMaxPages ]
!

renderBatchLastOn: html
	self isOnLastPage
		ifFalse: [ html anchor callback: [ self batchPage: self batchMaxPages ]; with: '>|' ]
		ifTrue: [ html text: '>|' ]
!

renderBatchNextOn: html
	self isOnLastPage
		ifFalse: [ html anchor callback: [ self nextPage ]; with: '>>' ]
		ifTrue: [ html text: '>>' ].
	html space
!

renderBatchPreviousOn: html
	self isOnFirstPage
		ifFalse: [ html anchor callback: [ self previousPage ]; with: '<<' ]
		ifTrue: [ html text: '<<' ].
	html space
! !

!MAReport methodsFor:'rendering-table'!

renderTableBatchOn: html
	self hasMoreThanOnePage ifTrue: [
		html tableRow: [
			html tableData
				class: 'batch';
				colSpan: self visibleColumns size;
				with: [
					self showBatchFirstLast
						ifTrue: [ self renderBatchFirstOn: html ].
					self showBatchPreviousNext
						ifTrue: [ self renderBatchPreviousOn: html ].
					self showBatchPages
						ifTrue: [ self renderBatchItemsOn: html ].
					self showBatchPreviousNext
						ifTrue: [ self renderBatchNextOn: html ].
					self showBatchFirstLast
						ifTrue: [ self renderBatchLastOn: html ] ] ] ]
!

renderTableBodyOn: html 
	self visible isEmpty 
		ifTrue: [ 
			html tableRow
				class: 'empty';
				with: [ 
					html tableData
						colSpan: self visibleColumns size;
						with: self tableEmpty ] ]
		ifFalse: [
			self visible keysAndValuesDo: [ :index :row | 
				html tableRow
					class: (self rowStyleForNumber: index);
					with: [ 
						self visibleColumns do: [ :col | 
							col 
								renderCell: row
								index: index
								on: html ] ] ] ]
!

renderTableCaptionOn: html
	(html tag: 'caption') with: self tableCaption
!

renderTableFilterOn: html
	html tableRow: [
		self visibleColumns do: [ :each |
			each renderFilterCellOn: html ] ]
!

renderTableFootOn: html
	html tableRow: [
		self visibleColumns do: [ :each |
			each renderFootCellOn: html ] ]
!

renderTableHeadOn: html
	html tableRow: [
		self visibleColumns do: [ :each |
			each renderHeadCellOn: html ] ]
!

renderTableSummaryOn: html
	(html tag: 'summary') with: self tableSummary
! !

!MAReport methodsFor:'testing'!

hasMoreThanOnePage
	^self batchSize < self cache size
!

hasRowFilter
	^ self rowFilter notNil
!

isSorted
	^ self sortColumn notNil
! !

!MAReport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAReport.st,v 1.2 2009-08-14 20:29:43 cg Exp $'
! !
