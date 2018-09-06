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

AbstractUI subclass:#SyslogTransportUI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!SyslogTransportUI class methodsFor:'documentation'!

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

!SyslogTransportUI class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SyslogTransportUI andSelector:#windowSpec
     SyslogTransportUI new openInterface:#windowSpec
     SyslogTransportUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: SyslogTransportUI
	  name: SyslogTransportUI
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (LabelSpec
	      label: 'Host'
	      name: 'HostLabel'
	      layout: (LayoutFrame 0 0 0 0 50 0 30 0)
	      translateLabel: true
	    )
	   (HorizontalPanelViewSpec
	      name: 'HostPanel'
	      layout: (LayoutFrame 50 0 0 0 0 1 30 0)
	      horizontalLayout: fitSpace
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (InputFieldSpec
		    name: 'IP1'
		    model: address1Aspect
		    type: numberInRange
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    minValue: 0
		    maxValue: 255
		    acceptOnPointerLeave: false
		    extent: (Point 58 22)
		  )
		 (InputFieldSpec
		    name: 'IP2'
		    model: address2Aspect
		    type: numberInRange
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    minValue: 0
		    maxValue: 255
		    acceptOnPointerLeave: false
		    extent: (Point 59 22)
		  )
		 (InputFieldSpec
		    name: 'IP3'
		    model: address3Aspect
		    type: numberInRange
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    minValue: 0
		    maxValue: 255
		    acceptOnPointerLeave: false
		    extent: (Point 59 22)
		  )
		 (InputFieldSpec
		    name: 'IP4'
		    model: address4Aspect
		    type: numberInRange
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    minValue: 0
		    maxValue: 255
		    acceptOnPointerLeave: false
		    extent: (Point 59 22)
		  )
		 )

	      )
	    )
	   (LabelSpec
	      label: 'Port'
	      name: 'PortLabel'
	      layout: (LayoutFrame 0 0 30 0 50 0 60 0)
	      translateLabel: true
	    )
	   (HorizontalPanelViewSpec
	      name: 'PortPanel'
	      layout: (LayoutFrame 50 0 30 0 0 1 60 0)
	      horizontalLayout: fitSpace
	      verticalLayout: center
	      horizontalSpace: 3
	      verticalSpace: 3
	      component:
	     (SpecCollection
		collection: (
		 (InputFieldSpec
		    name: 'Port'
		    model: portAspect
		    type: numberInRange
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    minValue: 1
		    maxValue: 65535
		    acceptOnPointerLeave: false
		    extent: (Point 244 22)
		  )
		 )

	      )
	    )
	   (FramedBoxSpec
	      label: 'Syslog properties'
	      name: 'SyslogBox'
	      layout: (LayoutFrame 0 0 60 0 0 1 0 1)
	      labelPosition: topLeft
	      translateLabel: true
	      component:
	     (SpecCollection
		collection: (
		 (LabelSpec
		    label: 'Hostname'
		    name: 'HostnameLabel'
		    layout: (LayoutFrame 0 0 0 0 70 0 30 0)
		    translateLabel: true
		  )
		 (InputFieldSpec
		    name: 'HostnameField'
		    layout: (LayoutFrame 70 0 0 0 0 1 26 0)
		    model: hostnameAspect
		    formatString: ''
		    acceptOnReturn: true
		    acceptOnTab: true
		    acceptOnLostFocus: true
		    acceptOnPointerLeave: false
		  )
		 (LabelSpec
		    label: 'Facility'
		    name: 'FacilityLabel'
		    layout: (LayoutFrame 0 0 30 0 70 0 60 0)
		    translateLabel: true
		  )
		 (PopUpListSpec
		    label: 'Facility...'
		    name: 'FacilityPopUpList'
		    layout: (LayoutFrame 70 0 34 0 0 1 56 0)
		    tabable: true
		    model: selectedFacilityAspect
		    menu: facilitiesList
		    useIndex: true
		  )
		 (LabelSpec
		    label: 'Severity'
		    name: 'SeverityLabel'
		    layout: (LayoutFrame 0 0 60 0 70 0 90 0)
		    translateLabel: true
		  )
		 (PopUpListSpec
		    label: 'Severity...'
		    name: 'SeverityPopUpList'
		    layout: (LayoutFrame 70 0 64 0 0 1 86 0)
		    tabable: true
		    model: selectedSeverityAspect
		    menu: severitiesList
		    useIndex: true
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!SyslogTransportUI class methodsFor:'plugIn spec'!

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

!SyslogTransportUI methodsFor:'aspects'!

address1Aspect

    ^self
	aspectAt: #address1Aspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #addressBytes) subjectChannel: modelHolder))
	    getBlock: [:model | model value at: 1]
	    putBlock: [:model :number | model value: (model value at: 1 put: number; yourself)]
	    updateBlock: [:model :aspect :value | true]]
!

address2Aspect

    ^self
	aspectAt: #address2Aspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #addressBytes) subjectChannel: modelHolder))
	    getBlock: [:model | model value at: 2]
	    putBlock: [:model :number | model value: (model value at: 2 put: number; yourself)]
	    updateBlock: [:model :aspect :value | true]]
!

address3Aspect

    ^self
	aspectAt: #address3Aspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #addressBytes) subjectChannel: modelHolder))
	    getBlock: [:model | model value at: 3]
	    putBlock: [:model :number | model value: (model value at: 3 put: number; yourself)]
	    updateBlock: [:model :aspect :value | true]]
!

address4Aspect

    ^self
	aspectAt: #address4Aspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #addressBytes) subjectChannel: modelHolder))
	    getBlock: [:model | model value at: 4]
	    putBlock: [:model :number | model value: (model value at: 4 put: number; yourself)]
	    updateBlock: [:model :aspect :value | true]]
!

facilitiesList

    ^#(
	'Kernel messages'
	'User level messages'
	'Mail system'
	'System daemons'
	'Security/authorization messages'
	'Internal syslogd messages'
	'Line printer subsystem'
	'Network news subsystem'
	'UUCP subsystem'
	'Clock daemon'
	'Security/authorization messages'
	'FTP daemon'
	'NTP subsystem'
	'Log audit'
	'Log alert'
	'Clock daemon'
	'Local use 0'
	'Local use 1'
	'Local use 2'
	'Local use 3'
	'Local use 4'
	'Local use 5'
	'Local use 6'
	'Local use 7'
    )
!

hostnameAspect

    ^self
	aspectAt: #hostnameAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #hostname) subjectChannel: modelHolder]
!

portAspect

    ^self
	aspectAt: #portAspect
	ifAbsentPut: [(AspectAdaptor forAspect: #port) subjectChannel: modelHolder]
!

selectedFacilityAspect

    ^self
	aspectAt: #selectedFacilityAspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #facility) subjectChannel: modelHolder))
	    getBlock: [:model | model value + 1]
	    putBlock: [:model :index | model value: index - 1]
	    updateBlock: [:model :aspect :value | true]]
!

selectedSeverityAspect

    ^self
	aspectAt: #selectedSeverityAspect
	ifAbsentPut: [(PluggableAdaptor
	    on: ((AspectAdaptor forAspect: #severity) subjectChannel: modelHolder))
	    getBlock: [:model | model value + 1]
	    putBlock: [:model :index | model value: index - 1]
	    updateBlock: [:model :aspect :value | true]]
!

severitiesList

    ^#(
       'Emergency: system unusable'
       'Alert: action must be taken immediately'
       'Critical: critical conditions'
       'Error: error conditions'
       'Warning: warning conditions'
       'Notice: normal but signifiant condition'
       'Informational: information messages'
       'Debug: debug-level messages'
    )
! !

!SyslogTransportUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SyslogTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__SyslogTransportUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__SyslogTransportUI.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
