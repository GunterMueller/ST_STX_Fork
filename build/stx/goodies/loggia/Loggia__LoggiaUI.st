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

AbstractUI subclass:#LoggiaUI
	instanceVariableNames:'facilitiesUI transportsUI'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!LoggiaUI class methodsFor:'documentation'!

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

!LoggiaUI class methodsFor:'class initialization'!

initialize
    "/ self installInLauncher.            - now done in phase 2
    ObjectMemory addDependent:self.
!

installInLauncher
    "add myself to the launcher menu and toolBar"

    |menuItem icon action|

    FileBrowserV2 isNil ifTrue:[^ self].

    action := MessageSend receiver: self selector: #open.

    menuItem := MenuItem new
		    translateLabel: true;
		    value: action;
		    isButton: false;
		    label:'Loggia Settings' icon:icon;
		    nameKey: #loggiaSettings;
		    activeHelpKey: #loggiaSettings.
    NewLauncher
	addMenuItem:menuItem
	from:self
	in:'menu.tools'
	position:nil
	space:true.

    NewLauncher addSettingsApplicationByClass:#'Loggia::LoggiaSettingsApplication'
		withName:'Logging/Loggia'
		icon:nil.

    "
     self installInLauncher
     self removeFromLauncher
    "

    "Modified: / 07-04-2012 / 08:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeFromLauncher
    "/
    "/ remove myself from the launcher menu
    "/

    |currentLauncher|

    NewLauncher isNil ifTrue:[^ self].
    NewLauncher removeUserTool:#fileBrowserV2.
    currentLauncher := NewLauncher current.
    currentLauncher notNil ifTrue:[
	currentLauncher fileBrowserItemVisible value:false
    ].
    NewLauncher removeSettingsApplicationByClass:#'FileBrowserV2SettingsAppl'.

    "
     self removeFromLauncher
    "
!

update:something with:aParameter from:changedObject
    something == #initialized ifTrue:[
	changedObject == ObjectMemory ifTrue:[
	    self installInLauncher.
	    ObjectMemory removeDependent:self.
	]
    ].
! !

!LoggiaUI class methodsFor:'interface specs'!

facilitiesTab
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LoggiaUI andSelector:#facilitiesTab
     LoggiaUI new openInterface:#facilitiesTab
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: facilitiesTab
	window:
       (WindowSpec
	  label: 'FacilitiesTab'
	  name: 'FacilitiesTab'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (SubCanvasSpec
	      name: 'Facilities'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      minorKey: windowSpec
	      clientKey: facilitiesUI
	      createNewApplication: true
	      createNewBuilder: true
	    )
	   )

	)
      )
!

transportsTab
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LoggiaUI andSelector:#transportsTab
     LoggiaUI new openInterface:#transportsTab
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: transportsTab
	window:
       (WindowSpec
	  label: 'TransportsTab'
	  name: 'TransportsTab'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 300 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (SubCanvasSpec
	      name: 'Transports'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      hasHorizontalScrollBar: false
	      hasVerticalScrollBar: false
	      minorKey: windowSpec
	      clientKey: transportsUI
	      createNewApplication: true
	      createNewBuilder: true
	    )
	   )

	)
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:LoggiaUI andSelector:#windowSpec
     LoggiaUI new openInterface:#windowSpec
     LoggiaUI open
    "

    <resource: #canvas>

    ^
     #(FullSpec
	name: windowSpec
	window:
       (WindowSpec
	  label: 'Loggia'
	  name: 'Loggia'
	  min: (Point 10 10)
	  bounds: (Rectangle 0 0 550 300)
	)
	component:
       (SpecCollection
	  collection: (
	   (NoteBookViewSpec
	      name: 'NoteBook'
	      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
	      menu: tabList
	    )
	   )

	)
      )

    "Modified: / 20-05-2005 / 10:32:59 / masca"
! !

!LoggiaUI class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass:LoggiaUI andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
	  label: 'Facilities'
	  minorKey: facilitiesTab
	  createNewBuilder: false
	)
       (TabItem
	  label: 'Transports'
	  minorKey: transportsTab
	  createNewBuilder: false
	)
       )

      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 05-05-2005 / 15:42:44 / masca"
! !

!LoggiaUI class methodsFor:'plugIn spec'!

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

!LoggiaUI methodsFor:'aspects'!

facilitiesUI

    facilitiesUI ifNil:[facilitiesUI := FacilitiesUI new].
    ^facilitiesUI

    "Created: / 19-04-2010 / 10:34:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
	builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list
!

transportsUI
    transportsUI isNil ifTrue:[
        transportsUI := TransportsUI new
    ].
    ^ transportsUI

    "Created: / 19-04-2010 / 10:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 11:20:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LoggiaUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LoggiaUI.st,v 1.4 2014-09-23 10:59:17 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LoggiaUI.st,v 1.4 2014-09-23 10:59:17 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LoggiaUI.st,v 1.4 2014-09-23 10:59:17 vrany Exp $'
! !


LoggiaUI initialize!
