"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Dialog subclass:#BranchAndRevisionSelectionDialog
	instanceVariableNames:'repositoryHolder pathHolder branchHolder revisionHolder
		revisionNumberHolder revisionDateHolder revisionKindHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!BranchAndRevisionSelectionDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
!

example1



    (SVN::BranchAndRevisionSelectionDialog new)
        repository: self svnRepository;
        onCancel:[:dialog| self];
        onAccept:[:dialog|
            Transcript
                showCR:'You have selected:';
                show:  '  Branch: '; show: dialog branch printString; cr;
                show:  '  Rev: '; show: dialog revision printString];
        open
! !

!BranchAndRevisionSelectionDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::BranchAndRevisionSelectionDialog andSelector:#contentSpec
     SVN::BranchAndRevisionSelectionDialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Select branch & revision'
          name: 'Select branch & revision'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 556 300)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'ContentPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topSpaceFit
              horizontalSpace: 3
              verticalSpace: 3
              ignoreInvisibleComponents: false
              component: 
             (SpecCollection
                collection: (
                 (TransparentBoxSpec
                    name: 'BranchBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Branch:'
                          name: 'BranchLabel'
                          layout: (LayoutFrame 0 0 0 0 100 0 25 0)
                          translateLabel: true
                          adjust: left
                        )
                       (ComboListSpec
                          name: 'Branch'
                          layout: (LayoutFrame 100 0 0 0 0 1 25 0)
                          model: branchHolder
                          comboList: branchListHolder
                          useIndex: false
                        )
                       )
                     
                    )
                    extent: (Point 556 25)
                  )
                 (TransparentBoxSpec
                    name: 'RevisionBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Revision:'
                          name: 'RevisionLabel'
                          layout: (LayoutFrame 0 0 0 0 100 0 22 0)
                          translateLabel: true
                          adjust: left
                        )
                       (RadioButtonSpec
                          label: 'HEAD'
                          name: 'RevKindHEAD'
                          layout: (LayoutFrame 100 0.0 0 0 0 1 25 0)
                          translateLabel: true
                          model: revisionKindHolder
                          isTriggerOnDown: true
                          select: head
                        )
                       (RadioButtonSpec
                          label: 'Number'
                          name: 'RevKindNumber'
                          layout: (LayoutFrame 100 0.0 25 0 200 1 50 0)
                          translateLabel: true
                          model: revisionKindHolder
                          isTriggerOnDown: true
                          select: number:
                        )
                       (InputFieldSpec
                          name: 'RevisionNumber'
                          layout: (LayoutFrame 200 0 25 0 0 1 48 0)
                          enableChannel: revisionNumberEnabledHolder
                          model: revisionNumberHolder
                          type: numberInRange
                          immediateAccept: true
                          acceptOnReturn: true
                          acceptOnTab: true
                          minValue: 0
                          acceptOnPointerLeave: true
                          emptyFieldReplacementText: 'Revision number'
                        )
                       (RadioButtonSpec
                          label: 'Date'
                          name: 'RevKindDate'
                          layout: (LayoutFrame 100 0.0 50 0 0 1 75 0)
                          translateLabel: true
                          model: revisionKindHolder
                          isTriggerOnDown: true
                          select: date:
                        )
                       (InputFieldSpec
                          name: 'EntryField1'
                          layout: (LayoutFrame 200 0 50 0 0 1 73 0)
                          enableChannel: revisionDateEnabledHolder
                          model: revisionDateHolder
                          type: dateOrNil
                          immediateAccept: true
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnPointerLeave: true
                          emptyFieldReplacementText: 'Date (DD-MM-YYYY)'
                        )
                       (ToggleSpec
                          label: 'Toggle'
                          name: 'Toggle1'
                          layout: (LayoutFrame 368 0 84 0 504 0 106 0)
                          translateLabel: true
                          isTriggerOnDown: true
                          lampColor: (Color 100.0 100.0 0.0)
                        )
                       )
                     
                    )
                    extent: (Point 556 75)
                  )
                 (SubCanvasSpec
                    name: 'RevisionLogBrowser'
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    autoHideScrollBars: false
                    majorKey: #'SVN::RevisionLogBrowser'
                    subAspectHolders: 
                   (Array
                      
                     (SubChannelInfoSpec
                        subAspect: branchHolder
                        aspect: branchHolder
                      ) 
                     (SubChannelInfoSpec
                        subAspect: pathHolder
                        aspect: pathHolder
                      )
                    )
                    createNewApplication: true
                    createNewBuilder: true
                    extent: (Point 556 188)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!BranchAndRevisionSelectionDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!BranchAndRevisionSelectionDialog class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #modelHolder
        #revisionHolder
      ).

! !

!BranchAndRevisionSelectionDialog methodsFor:'accessing'!

branch

    ^self branchHolder value

    "Created: / 19-04-2008 / 13:20:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-06-2009 / 23:43:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

branch: aSVNBranch

    self branchHolder value: aSVNBranch
!

defaultTitle
    "Superclass SVN::Dialog says that I am responsible to implement this method"
    
    ^ 'Select branch & revision '
    "/ , self model package allItalic

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path: path

    self pathHolder value: path
!

repository: aSVNRepository

    self repositoryHolder value: aSVNRepository
!

revision

    ^self revisionHolder value

    "Created: / 19-04-2008 / 13:20:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-06-2009 / 23:43:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchAndRevisionSelectionDialog methodsFor:'actions'!

fetchRevisionLog
    self revisionLogVisibleHolder value: true

    "Modified: / 10-07-2012 / 16:15:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BranchAndRevisionSelectionDialog methodsFor:'aspects'!

branchHolder
    <resource: #uiAspect>

    branchHolder isNil ifTrue:[
        branchHolder := ValueHolder with:
                            (self repositoryHolder value 
                                ifNotNil:[self repositoryHolder value branch]
                                ifNil:[nil]).
        branchHolder onChangeSend: #branchOrRevisionChanged to: self
    ].
    ^ branchHolder.
!

pathHolder
    "return/create the 'pathHolder' value holder (automatically generated)"

    pathHolder isNil ifTrue:[
        pathHolder := ValueHolder new.
    ].
    ^ pathHolder
!

repositoryHolder
    "return/create the 'repositoryHolder' value holder (automatically generated)"

    repositoryHolder isNil ifTrue:[
        repositoryHolder := ValueHolder new.
        revisionHolder onChangeSend: #repositoryChanged to: self
    ].
    ^ repositoryHolder
!

revisionHolder

    revisionHolder ifNil:[
        revisionHolder := ValueHolder with: SVN::Revision head.
        revisionHolder onChangeSend: #branchOrRevisionChanged to: self
    ].
    ^revisionHolder

    "Created: / 24-03-2009 / 14:51:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchAndRevisionSelectionDialog methodsFor:'aspects - aux'!

branchListHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#branchListHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#branchListHolder put:holder.
    ].
    ^ holder.
!

revisionDateHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#revisionDateHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#revisionDateHolder put:holder.
"/       holder addDependent:self.
       holder onChangeSend:#revisionKindOrNumberOrDateChanged to:self.
    ].
    ^ holder.
!

revisionKindHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#revisionKindHolder) isNil ifTrue:[
        holder := ValueHolder with:#head.
        builder aspectAt:#revisionKindHolder put:holder.
"/       holder addDependent:self.
        holder onChangeSend:#revisionKindOrNumberOrDateChanged to:self.
    ].
    ^ holder.
!

revisionLogInvisibleHolder
    ^BlockValue forLogicalNot: self revisionLogVisibleHolder

    "Created: / 10-07-2012 / 16:16:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionLogVisibleHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#revisionLogVisibleHolder) isNil ifTrue:[
        holder := ValueHolder with: false.
        builder aspectAt:#revisionLogVisibleHolder put:holder.
    ].
    ^ holder.
!

revisionNumberHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#revisionNumberHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#revisionNumberHolder put:holder.
"/       holder addDependent:self.
        holder onChangeSend:#revisionKindOrNumberOrDateChanged to:self.
    ].
    ^ holder.
! !

!BranchAndRevisionSelectionDialog methodsFor:'change & update'!

branchOrRevisionChanged

    self acceptEnabled:
        (self branch notNil and:[self revision notNil])
!

repositoryChanged

    [| repo |
    repo := self repositoryHolder value.
    self branchListHolder value:
        (repo
            ifNil:[#()]
            ifNotNil:[repo branchesAndTags])] fork.
!

revisionKindOrNumberOrDateChanged

    | kind rev |
    kind := self revisionKindHolder value.
    kind = #head ifTrue:
        [rev := SVN::Revision head].
    kind = #number: ifTrue:
        [(self revisionNumberHolder value) ifNotNil:
            [rev := SVN::Revision number: (self revisionNumberHolder value)]].
    kind = #date: ifTrue:
        [self revisionDateHolder value ifNotNil:
            [rev := SVN::Revision date: (self revisionDateHolder value)]].
    self revisionHolder setValue: rev.
    self branchOrRevisionChanged.
! !

!BranchAndRevisionSelectionDialog methodsFor:'hooks'!

commonPostBuild

    self branchOrRevisionChanged.
    self repositoryChanged
! !

!BranchAndRevisionSelectionDialog methodsFor:'queries'!

revisionDateEnabledHolder

    ^(PluggableAdaptor on: self revisionKindHolder)
        getBlock:[:model|model value = #date:]
        putBlock:[:i1 :i2|]
        updateBlock:[:i1 :i2 :i3|true]
!

revisionNumberEnabledHolder

    ^(PluggableAdaptor on: self revisionKindHolder)
        getBlock:[:model|model value = #number:]
        putBlock:[:i1 :i2|]
        updateBlock:[:i1 :i2 :i3|true]
! !

!BranchAndRevisionSelectionDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__BranchAndRevisionSelectionDialog.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
