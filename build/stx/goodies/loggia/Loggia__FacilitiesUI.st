"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

AbstractUI subclass:#FacilitiesUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

Object subclass:#SeverityRow
	instanceVariableNames:'facility severity'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FacilitiesUI
!

!FacilitiesUI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!FacilitiesUI class methodsFor:'accessing'!

defaultDomainModel

    ^Logger default
!

severityColors

    | colors |
    colors := OrderedCollection new.
    colors add: 'Transparent' asText.

    Color constantNames do: [:e |
	colors add: (' ' asText backgroundColorizeAllWith: (Color perform: e))
    ].

    ^colors

    "Created: / 20-05-2005 / 10:06:46 / masca"
! !

!FacilitiesUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Loggia::FacilitiesUI andSelector:#windowSpec
     Loggia::FacilitiesUI new openInterface:#windowSpec
     Loggia::FacilitiesUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Loggia Facilities'
	  name: 'Loggia Facilities'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 671 459)
	)
	component:
       (SpecCollection
	  collection: (
	   (VariableHorizontalPanelSpec
	      name: 'HorizontalPanel'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      showHandle: true
	      snapMode: both
	      component:
	     (SpecCollection
		collection: (
		 (ViewSpec
		    name: 'Box1'
		    component:
		   (SpecCollection
		      collection: (
		       (SequenceViewSpec
			  name: 'FacilitiesList'
			  layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
			  model: selectedFacilityAspect
			  menu: facilitiesMenu
			  hasHorizontalScrollBar: false
			  hasVerticalScrollBar: true
			  useIndex: false
			  sequenceList: facilitiesList
			)
		       (ActionButtonSpec
			  label: 'Add'
			  name: 'AddFacilityButton'
			  layout: (LayoutFrame 0 0 -25 1 0 0.5 0 1)
			  translateLabel: true
			  model: addFacility
			)
		       (ActionButtonSpec
			  label: 'Remove'
			  name: 'RemoveFacilityButton'
			  layout: (LayoutFrame 0 0.5 -25 1 0 1 0 1)
			  translateLabel: true
			  model: removeFacility
			  enableChannel: canRemoveFacilityHolder
			)
		       )

		    )
		  )
		 (DataSetSpec
		    name: 'SeveritiesTable'
		    model: selectedSeverityAspect
		    menu: severitiesMenu
		    hasHorizontalScrollBar: true
		    hasVerticalScrollBar: true
		    miniScrollerHorizontal: true
		    dataList: severitiesList
		    useIndex: false
		    columnHolder: tableColumns
		  )
		 )

	      )
	      handles: (Any 0.5 1.0)
	    )
	   )

	)
      )
! !

!FacilitiesUI class methodsFor:'menu specs'!

facilitiesMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FacilitiesUI andSelector:#facilitiesMenu
     (Menu new fromLiteralArrayEncoding:(FacilitiesUI facilitiesMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'Add facility'
	    itemValue: addFacility
	    translateLabel: true
	  )
	 (MenuItem
	    label: 'Facility for namespace'
	    itemValue: addFacilityNamespace
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: canRemoveFacility
	    label: 'Remove...'
	    itemValue: removeFacility
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

severitiesMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FacilitiesUI andSelector:#severitiesMenu
     (Menu new fromLiteralArrayEncoding:(FacilitiesUI severitiesMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: facilitySelected
	    label: 'Add severity'
	    itemValue: addSeverity
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: canRemoveSeverity
	    label: 'Remove...'
	    itemValue: removeSeverity
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
! !

!FacilitiesUI class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	#model
      ).

! !

!FacilitiesUI class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:FacilitiesUI andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
	 label: 'Severity'
	 id: 'SeverityColumn'
	 labelButtonType: Button
	 model: severityName
	 canSelect: false
       )
      (DataSetColumnSpec
	 label: 'Transport'
	 id: 'TransportColumn'
	 labelButtonType: Button
	 editorType: ComboList
	 rendererType: ComboList
	 choices: availableTransports
	 model: transportName
	 writeSelector: changeTransportTo:
       )
      (DataSetColumnSpec
	 label: 'Color'
	 labelButtonType: Button
	 width: 70
	 minWidth: 70
	 editorType: ComboList
	 rendererType: ComboList
	 choices: availableColors
	 model: severityColorText
	 writeSelector: changeColorTo:
	 isResizeable: false
       )
      )

    "Modified: / 20-05-2005 / 10:33:32 / masca"
! !

!FacilitiesUI methodsFor:'actions'!

addFacility

    | facility |
    facility := Dialog request: 'New facility name'.
    facility isEmptyOrNil ifTrue: [^self].
    facility := facility asSymbol.

    (self subject facilities includesKey: facility)
	ifTrue: [^Dialog warn: 'Already have facility ' , facility asString].

    self subject addFacility: LogFacility new as: facility.
    self update
!

addFacilityNamespace

    | facility namespaces |
    namespaces := NameSpace allNameSpaces asOrderedCollection.
    facility := Dialog
	choose: 'Namespace for new facility'
	fromList: namespaces
	values: namespaces
	lines: 20
	cancel: [nil].
    facility ifNil: [^self].

    (self subject facilities includesKey: facility)
	ifTrue: [^Dialog warn: 'Already have facility for namespace ' , facility asString].

    self subject addFacility: LogFacility new as: facility name.
    self update

    "Modified: / 20-07-2012 / 13:22:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSeverity

    | severity facility |
    severity := Dialog request: 'New severity name'.
    severity isEmptyOrNil ifTrue: [^self].

    severity := severity asSymbol.
    facility := self selectedFacilityAspect value.
    (facility registeredLevels includesKey: severity)
	ifTrue: [^Dialog warn: 'Already have handler for severity ' , severity asString].

    facility for: severity use: TranscriptTransport default.
    self updateSeverities
!

removeFacility

    | facility |
    facility := self selectedFacilityAspect value.
    facility ifNil: [^self].

    self subject removeFacilityAt:
	(self subject facilities keyAtIdentityValue: facility ifAbsent: [^self]).

    self update
!

removeSeverity

    | row |
    row := self selectedSeverityAspect value.
    row ifNil: [^self].

    self selectedFacilityAspect value removeLevel: row severity.
    self updateSeverities
! !

!FacilitiesUI methodsFor:'aspects'!

facilitiesList

    ^self
	aspectAt: #facilitiesList
	ifAbsentPut: [PluggableAdaptor
	    on: self modelHolder
	    getter: [:logger | logger value facilities asOrderedCollection]]

    "Modified: / 29-05-2014 / 10:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedFacilityAspect
    <resource: #uiAspect>

    |holder system|

    (holder := builder bindingAt:#selectedFacilityAspect) isNil ifTrue:[
	system := Loggia::Logger default facilities at: #system.
	holder := ValueHolder with: system.
	builder aspectAt:#selectedFacilityAspect put:holder.
    ].
    ^ holder.

    "Modified: / 12-04-2012 / 19:20:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedSeverityAspect

    ^builder nilValueAspectFor: #severity
!

severitiesList

    ^self
        aspectAt: #severitiesList
        ifAbsentPut: [PluggableAdaptor
            on: self selectedFacilityAspect
            getter: [:facility |
                facility isNil
                    ifTrue: [#()]
                    ifFalse: [(facility value levels keys asSortedCollection:[ :a :b | a value > b value ])
                        collect: [:e | SeverityRow facility: facility value severity: e]]]]

    "Modified: / 22-09-2014 / 15:28:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FacilitiesUI methodsFor:'columns'!

availableTransports: aSymbol

    ^Logger transports
!

changeTransportOf: aSymbol to: aTransport

    self selectedFacilityAspect value for: aSymbol use: aTransport
!

columnAdaptor

    ^self
!

severityName: aSymbol

    ^aSymbol asString
!

transportName: aSymbol

    ^self selectedFacilityAspect value transportForSeverity: aSymbol
! !

!FacilitiesUI methodsFor:'initialization'!

initialize

    super initialize

    "Created: / 18-04-2010 / 22:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FacilitiesUI methodsFor:'testing'!

canRemoveFacility

    | facility |
    facility := self selectedFacilityAspect value.
    ^facility notNil and: [((self subject facilityNameFor: facility) = self subject systemFacilityName) not]
!

canRemoveFacilityHolder

    ^BlockValue
	with: [:ignored|self canRemoveFacility]
	argument: self selectedFacilityAspect

    "Created: / 02-11-2011 / 12:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canRemoveSeverity

    | row |
    row := self selectedSeverityAspect value.
    ^row notNil and: [(self selectedFacilityAspect value systemLevels includes: row severity) not]
!

facilitySelected

    ^self selectedFacilityAspect value notNil
!

severitySelected

    ^self selectedSeverityAspect value notNil
! !

!FacilitiesUI methodsFor:'updating'!

update

    self facilitiesList changed.
    self selectedFacilityAspect changed
!

updateSeverities

    self severitiesList changed.
    self selectedSeverityAspect changed
! !

!FacilitiesUI::SeverityRow class methodsFor:'instance creation'!

facility: aLogFacility severity: aSymbol

    ^self new
	facility: aLogFacility severity: aSymbol;
	yourself
! !

!FacilitiesUI::SeverityRow methodsFor:'accessing'!

availableColors

    ^FacilitiesUI severityColors

    "Created: / 20-05-2005 / 09:36:29 / masca"
!

availableTransports

    ^Logger transports asList

    "Modified: / 20-05-2005 / 10:17:08 / masca"
!

changeColorTo: aText

    | bg |

    bg := ((aText emphasisAt:1) notNil and:[(aText emphasisAt:1) key = #backgroundColor])
	    ifTrue:[(aText emphasisAt:1) value]
	    ifFalse:[nil].

    facility for: severity useColor: bg

    "Created: / 20-05-2005 / 09:35:26 / masca"
!

changeTransportTo: aLogTransport

    facility for: severity use: aLogTransport
!

facility
    ^ facility
!

severity
    ^ severity
!

severityColor

    ^facility colorFor: severity

    "Created: / 20-05-2005 / 10:07:47 / masca"
!

severityColorText

    ^'         ' asText backgroundColorizeAllWith:(self severityColor)

    "Created: / 20-05-2005 / 10:22:18 / masca"
!

severityName

    ^severity asString
!

transportName

    ^(facility transportForSeverity: severity)
! !

!FacilitiesUI::SeverityRow methodsFor:'initialization'!

facility: aLogFacility severity: aSymbol

    facility := aLogFacility.
    severity := aSymbol
! !

!FacilitiesUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__FacilitiesUI.st,v 1.8 2014-09-23 10:59:12 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__FacilitiesUI.st,v 1.8 2014-09-23 10:59:12 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__FacilitiesUI.st,v 1.8 2014-09-23 10:59:12 vrany Exp $'
! !

