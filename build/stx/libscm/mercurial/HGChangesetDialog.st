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

SimpleDialog subclass:#HGChangesetDialog
	instanceVariableNames:'repositoryHolder revsetHolder changesetHolder showDetailsHolder
		acceptEnabledHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGChangesetDialog class methodsFor:'documentation'!

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
!

documentation
"
    Dialog to ask user for a mercurial revision.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
    Asking for a changeset
                                                                [exBegin]
    | repo revset dialog changeset |
    repo :=  (HGRepository on: stx_libscm_mercurial packageDirectory / '..' ).
    revset := 'branch(''default'') and merge()' asHGRevset.
    dialog := HGChangesetDialog new.
    dialog repository: repo.
    dialog revset: revset.
    changeset := dialog open

                                                                [exEnd]

                                                                [exEnd]
"
! !

!HGChangesetDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGChangesetDialog andSelector:#windowSpec
     HGChangesetDialog new openInterface:#windowSpec
     HGChangesetDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Select revision...'
         name: 'Select revision...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 541 487)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'Contents'
             layout: (LayoutFrame 0 0 0 0 0 1 -45 1)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'SubCanvas1'
                   layout: (LayoutFrame 0 0 0 0 0 1 -20 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: HGChangesetBrowser
                   minorKey: listAndDetailsSpec
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: changesetHolder
                       aspect: changesetHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: repositoryHolder
                       aspect: repositoryHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: revsetHolder
                       aspect: revsetHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: showDetailsHolder
                       aspect: showDetailsHolder
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                (CheckBoxSpec
                   label: 'Show details'
                   name: 'CheckBox1'
                   layout: (LayoutFrame 0 0 -20 1 0 1 0 1)
                   model: showDetailsHolder
                   translateLabel: true
                 )
                )
              
             )
           )
          (DividerSpec
             name: 'Separator'
             layout: (LayoutFrame 0 0 -45 1 0 1 -40 1)
           )
          (HorizontalPanelViewSpec
             name: 'BittonPanel'
             layout: (LayoutFrame 9 0 -40 1 -9 1 0 1)
             horizontalLayout: okCancelBox
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 257 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'OKButton'
                   translateLabel: true
                   model: doAccept
                   enableChannel: acceptEnabledHolder
                   extent: (Point 257 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!HGChangesetDialog methodsFor:'accessing'!

changeset
    ^ self changesetHolder value

    "Created: / 24-03-2014 / 11:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    ^ self repositoryHolder value

    "Created: / 11-03-2014 / 20:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository: anHGRepository
    self repositoryHolder value: anHGRepository

    "Created: / 11-03-2014 / 20:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revset
    ^ self revsetHolder value

    "Created: / 11-03-2014 / 20:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revset: anHGRevset
    ^ self revsetHolder value: anHGRevset

    "Created: / 11-03-2014 / 20:55:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetDialog methodsFor:'aspects'!

acceptEnabledHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    acceptEnabledHolder isNil ifTrue:[
        acceptEnabledHolder := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       acceptEnabledHolder addDependent:self.
"/       acceptEnabledHolder onChangeSend:#acceptEnabledHolderChanged to:self.
    ].
    ^ acceptEnabledHolder.

    "Modified: / 24-03-2014 / 11:12:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetHolder
    "return/create the 'changesetHolder' value holder (automatically generated)"

    changesetHolder isNil ifTrue:[
        changesetHolder := ValueHolder new.
        changesetHolder addDependent:self.
    ].
    ^ changesetHolder
!

repositoryHolder
    "return/create the 'repositoryHolder' value holder (automatically generated)"

    repositoryHolder isNil ifTrue:[
        repositoryHolder := ValueHolder new.
    ].
    ^ repositoryHolder

    "Modified: / 24-03-2014 / 11:03:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revsetHolder
    "return/create the 'revsetHolder' value holder (automatically generated)"

    revsetHolder isNil ifTrue:[
        revsetHolder := ValueHolder new.
    ].
    ^ revsetHolder

    "Modified: / 24-03-2014 / 11:03:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDetailsHolder
    "return/create the 'showDetailsHolder' value holder (automatically generated)"

    showDetailsHolder isNil ifTrue:[
        showDetailsHolder := ValueHolder with: false.
        showDetailsHolder addDependent:self.
    ].
    ^ showDetailsHolder

    "Modified: / 24-03-2014 / 11:03:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetDialog methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == changesetHolder ifTrue:[
         self updateAcceptEnabledHolder.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 24-03-2014 / 11:10:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAcceptEnabledHolder

    self acceptEnabledHolder value: self changeset notNil

    "Created: / 24-03-2014 / 11:12:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetDialog methodsFor:'forced actions'!

doAcceptByReturnKey
    "Do not accept when Return is pressed in revset editor"

    (self windowGroup focusView application isKindOf: HGRevsetEditor) ifTrue:[ ^ self ].
    self acceptEnabledHolder value ifFalse:[ ^ self ].
    super doAcceptByReturnKey

    "Created: / 24-03-2014 / 21:35:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

