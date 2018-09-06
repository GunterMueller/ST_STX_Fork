"{ Package: 'stx:goodies/petitparser/gui' }"

GLMCompositePresentation subclass:#PPParserInspector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPParserInspector class methodsFor:'as yet unclassified'!

openOn: aParserInstance
	^ self new openOn: aParserInstance
! !

!PPParserInspector methodsFor:'building'!

compose
	"self new openOn: PPArithmeticParser new"

	self title: [:each | 'Parser Inspector on ', (each name ifNil: [each class name])].

	self tabulator with: [ :browser | 
		browser
			column: #sample;
			column: #inspectors.
		(browser transmit)
			fromOutsidePort: #entity;
			fromOutsidePort: #sampleText;
			to: #sample;
			andShowIfNone: [ :a | self sampleIn: a ].
		(browser transmit) 
			from: #sample port: #text;
			toOutsidePort: #sampleText.
		(browser transmit)
			from: #sample; "result"
			passivelyFrom: #sample port: #text; "sample text"
			from: #sample port: #stream; "parser stream"
			fromOutsidePort: #entity; "parser"  
			to: #inspectors;
			andShow: [ :a | self inspectorsIn: a ].
		browser transmit 
			from: #inspectors; 
			to: #sample port: #selectionInterval; 
			transformed: [:debugResult | debugResult ifNotNil: [debugResult start to: debugResult end] ] ]
! !

!PPParserInspector methodsFor:'private building'!

debuggerIn: composite
	composite tree
		title: 'Debugger';
		format: [:resultNode | resultNode formattedText ];
		display: [ :result :sample :stream :parser | {PPParserDebuggerResult parse: sample with: parser } ];
		children: [:resultNode | resultNode children ].
!

inspectorsIn: composite
	self resultIn: composite.
	self debuggerIn: composite.
	self tallyIn: composite.
	self profileIn: composite.
	self progressIn: composite
!

profileIn: composite
	composite table 
		title: 'Profile';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Time (ms)' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [ :result :sample :stream :parser  | stream asFrequencyTable ];
		noSelection;
		showOnly: 50
!

progressChartIn: composite
	composite morph 
		title: 'Progress';
		display: [ :stream |
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: stream asPositionMorph.
			morph ]
!

progressIn: composite
	composite morph 
		title: 'Progress';
		display: [:result :sample :stream :parser  | 
			| morph |
			morph := ScrollPane new.
			morph color: Color white.
			morph scroller addMorph: stream asPositionMorph.
			morph ]
!

resultIn: composite
	(composite text)
		title: 'Result';
		display: [ :result :sample :stream :parser | result ];
		act: [ :text :result :sample :stream :parser | result inspect ] icon: GLMUIThemeExtraIcons glamorousInspect entitled: 'Inspect';
		act: [ :text :result :sample :stream :parser | result explore ] icon: GLMUIThemeExtraIcons glamorousSearch entitled: 'Explore'.
!

sampleIn: composite
	(composite text)
		title: 'Sample';
		display: [:parser :sample | sample ifNil: [''] ];
		allowNil;
		populate: #selection
			icon: GLMUIThemeExtraIcons glamorousPlay
			on: $s
			entitled: 'Parse (s)'
			with: [ :presentation :parser | 
				| stream output |
				stream := PPBrowserStream on: presentation text asString.
				output := parser parse: stream.
				output isPetitFailure
					ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
				(presentation pane port: #stream) value: stream.
				output ]
!

tallyIn: composite
	composite table 
		title: 'Tally';
		column: 'Parser' evaluated: [ :each | each first displayName ];
		column: 'Count' evaluated: [ :each | each second printString ];
		column: 'Percentage (%)' evaluated: [ :each | each third printString ];
		display: [:result :sample :stream :parser | stream asFrequencyTable ];
		noSelection;
		showOnly: 50
! !

!PPParserInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPParserInspector.st,v 1.1 2014-03-04 21:14:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPParserInspector.st,v 1.1 2014-03-04 21:14:44 cg Exp $'
! !

