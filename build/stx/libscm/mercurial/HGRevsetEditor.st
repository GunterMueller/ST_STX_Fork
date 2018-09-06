"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#HGRevsetEditor
	instanceVariableNames:'revsetHolder revsetList revsetField revsetFieldBackground
		errorHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGRevsetEditor class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGRevsetEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGRevsetEditor andSelector:#windowSpec
     HGRevsetEditor new openInterface:#windowSpec
     HGRevsetEditor open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Revset Editor'
         name: 'Revset Editor'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 25)
       )
       component: 
      (SpecCollection
         collection: (
          (ComboBoxSpec
             name: 'RevsetField'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             tabable: false
             model: revsetHolder
             converter: revsetToStringConverter
             acceptOnPointerLeave: false
             hasKeyboardFocusInitially: true
             comboList: revsetList
             postBuildCallback: postBuildRevsetField:
           )
          )
        
       )
     )
! !

!HGRevsetEditor class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #revsetHolder
        #revsetList
        #errorHolder
      ).

    "Modified: / 25-03-2014 / 02:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevsetEditor methodsFor:'aspects'!

errorHolder
    "return/create the 'errorHolder' value holder (automatically generated)"

    errorHolder isNil ifTrue:[
        errorHolder := ValueHolder new.
        errorHolder addDependent:self.
    ].
    ^ errorHolder
!

errorHolder:valueModel
    "set the 'errorHolder' value holder (automatically generated)"

    |oldValue newValue|

    errorHolder notNil ifTrue:[
        oldValue := errorHolder value.
        errorHolder removeDependent:self.
    ].
    errorHolder := valueModel.
    errorHolder notNil ifTrue:[
        errorHolder addDependent:self.
    ].
    newValue := errorHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:errorHolder.
    ].
!

revsetHolder
    "return/create the 'revsetHolder' value holder (automatically generated)"

    revsetHolder isNil ifTrue:[
        revsetHolder := ValueHolder new.
        revsetHolder addDependent:self.
    ].
    ^ revsetHolder
!

revsetHolder:aValueModel
    "set the 'revsetHolder' value holder (automatically generated)"

    |oldValue newValue|

    revsetHolder notNil ifTrue:[
        oldValue := revsetHolder value.
        revsetHolder removeDependent:self.
    ].
    revsetHolder := aValueModel.
    revsetHolder notNil ifTrue:[
        revsetHolder addDependent:self.
    ].
    newValue := revsetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:revsetHolder.
    ].
!

revsetList
    "return/create the 'revsetList' value holder (automatically generated)"

    revsetList isNil ifTrue:[
        revsetList := List new.
    ].
    ^ revsetList

    "Modified: / 24-03-2014 / 21:45:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revsetList:something
    "set the 'revsetList' value holder (automatically generated)"

    revsetList := something.
!

revsetToStringConverter
    ^ (PluggableAdaptor on: self revsetHolder)
        getBlock:   [ :model | model value isNil ifTrue:[''] ifFalse:[model value asString] ]
        putBlock:   [ :model :string | model value: string asHGRevset ]
        updateBlock:[ :model :aspect :value|true]

    "Created: / 14-03-2014 / 23:17:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevsetEditor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == errorHolder ifTrue:[
         self updateAfterErrorHolderChanged.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 25-03-2014 / 02:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterErrorHolderChanged
    | error |

    error := self errorHolder value.
    error isNil ifTrue:[ 
        revsetField field backgroundColor: revsetFieldBackground  
    ] ifFalse:[ 
        revsetField field backgroundColor: Color red lighter  
    ].

    "Created: / 25-03-2014 / 02:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevsetEditor methodsFor:'hooks'!

postBuildRevsetField: aView
    revsetField := aView.
    revsetFieldBackground := revsetField field background.

    "Created: / 25-03-2014 / 02:03:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevsetEditor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

