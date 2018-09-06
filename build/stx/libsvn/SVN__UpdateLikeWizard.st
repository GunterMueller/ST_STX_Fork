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

Wizard subclass:#UpdateLikeWizard
	instanceVariableNames:'branchAspect revisionAspect updatesAspect conflictsAspect
		conflictsAspectValueCache resolutionAspect'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

WizardPane subclass:#ChangeSetPane
	instanceVariableNames:'changeSetHolder finalChangeSetHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UpdateLikeWizard
!

WizardPane subclass:#MergePane
	instanceVariableNames:'diffSetHolder changeSetHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UpdateLikeWizard
!

WizardPane subclass:#RevisionPane
	instanceVariableNames:'logHolder revisionHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UpdateLikeWizard
!

!UpdateLikeWizard class methodsFor:'documentation'!

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
! !

!UpdateLikeWizard methodsFor:'accessing'!

branch

    ^self branchAspect value

    "Created: / 25-11-2009 / 20:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branch: aBranch

    ^self branchAspect value: aBranch

    "Created: / 25-11-2009 / 20:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSubtitle
    "Superclass SVN::Dialog says that I am responsible to implement this method"

    | subtitle |
    subtitle := 'Package' asText allBold, ' ' ,self task package asText allItalic.

    self task isMergeTask
        ifTrue:
            [subtitle := subtitle , ' ',' branch ' asText allBold, ' ' ,self branch path asText allItalic].
    ^subtitle

    "Modified: / 09-04-2009 / 08:41:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 09-12-2009 / 17:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTitle
    "Superclass SVN::Dialog says that I am responsible to implement this method"

    ^self task isUpdateTask
        ifTrue:
            [self revision == SVN::Revision head 
                ifTrue:['Update']
                ifFalse:['Load revision ', self revision printString]]
        ifFalse:
            ['Merge']

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:41:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2009 / 17:12:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

firstPane
    "
     Answers the very first pane to show"

    ^self revision 
        ifNotNil:
            [MergePane new]
        ifNil:
            [RevisionPane new]

    "Modified: / 02-04-2009 / 16:34:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revision

    ^self revisionAspect value

    "Created: / 25-11-2009 / 20:13:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision: aRevision

    ^self revisionAspect value: aRevision

    "Created: / 25-11-2009 / 20:11:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard methodsFor:'actions'!

doAccept
    self showProgressWhile: 
            [self task doApplyUpdates.
            self accept value: true ].

    "Created: / 02-04-2009 / 23:19:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:26:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2009 / 14:05:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard methodsFor:'aspects'!

branchAspect

    branchAspect ifNil:
        [branchAspect := (AspectAdaptor forAspect: #branch)
                                subjectChannel: self task].
    ^branchAspect

    "Created: / 25-11-2009 / 17:59:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 12:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

conflictsAspect

    conflictsAspect ifNil:
        [conflictsAspect := (AspectAdaptor forAspect: #conflicts)
                                subjectChannel: self task;
                                addDependent: self.
        self conflictsChanged.
        self resolutionChanged].
    ^conflictsAspect

    "Created: / 25-11-2009 / 20:41:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 14:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolutionAspect

    resolutionAspect ifNil:
        [resolutionAspect := (AspectAdaptor forAspect: #resolution)
                                subjectChannel: self task].
    ^resolutionAspect

    "Created: / 26-11-2009 / 08:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 12:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revisionAspect

    revisionAspect ifNil:
        [revisionAspect := (AspectAdaptor forAspect: #revision)
                                subject: self task].
    ^revisionAspect

    "Created: / 25-11-2009 / 17:58:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updatesAspect

    updatesAspect ifNil:
        [updatesAspect := (AspectAdaptor forAspect: #updates)
                                subjectChannel: self task].
    ^updatesAspect

    "Created: / 25-11-2009 / 20:41:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 12:49:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard methodsFor:'change & update'!

conflictsChanged

    conflictsAspectValueCache 
        ifNotNil:[conflictsAspectValueCache removeDependent: self].
    conflictsAspectValueCache := self conflictsAspect value.
    conflictsAspectValueCache 
        ifNotNil:[conflictsAspectValueCache addDependent: self].

    "Created: / 26-11-2009 / 14:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merged
    ^ (conflictsAspectValueCache 
        ifNil:[ false ]
        ifNotNil:[ conflictsAspectValueCache merged ])
!

resolutionChanged
    self acceptEnabled:self merged
!

update: aspect with: param from: sender

    sender == conflictsAspect ifTrue:
        [^self conflictsChanged].
    sender == conflictsAspectValueCache ifTrue:
        [^self resolutionChanged].


    ^super update: aspect with: param from: self

    "Created: / 26-11-2009 / 12:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 14:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard::ChangeSetPane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeWizard::ChangeSetPane andSelector:#windowSpec
     SVN::MergeWizard::ChangeSetPane new openInterface:#windowSpec
     SVN::MergeWizard::ChangeSetPane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'UpdateChangeSet'
          name: 'UpdateChangeSet'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ChangeSetBrowser'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::ChangeSetBrowser'
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: changesetHolder
                  aspect: resolutionAspect
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
! !

!UpdateLikeWizard::ChangeSetPane methodsFor:'queries'!

acceptEnabled

    ^self wizard merged
!

canGoNext

    ^false

    "Created: / 02-04-2009 / 17:21:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UpdateLikeWizard::MergePane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeWizard::MergePane andSelector:#windowSpec
     SVN::MergeWizard::MergePane new openInterface:#windowSpec
     SVN::MergeWizard::MergePane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Merge Pane'
          name: 'Merge Pane'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'Merge'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'SVN::MergeBrowser'
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: diffsetHolder
                  aspect: conflictsAspect
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
! !

!UpdateLikeWizard::MergePane methodsFor:'actions'!

enter

    self task notifications ifNil:
        [self showProgressWhile:
            [self task doComputeUpdates.
            self task hasChanges 
                ifTrue:
                    [self task conflicts isEmpty
                        ifTrue:
                            [self canGoNext 
                                ifTrue:[self goNext]
                                ifFalse:[self wizard doAccept]]]
                ifFalse:
                    [self wizard doAccept]]]

    "Created: / 02-04-2009 / 17:14:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-04-2009 / 20:14:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2009 / 17:44:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard::MergePane methodsFor:'private'!

createNext
    "Superclass SVN::Wizard::Pane says that I am responsible to implement this method"

    ^UpdateLikeWizard::ChangeSetPane new

    "Modified: / 02-04-2009 / 22:32:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2009 / 17:29:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard::MergePane methodsFor:'queries'!

canGoNext

    ^(Smalltalk at: #'Tools::ChangeSetBrowser') notNil

    "Created: / 09-12-2009 / 16:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard::RevisionPane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeWizard::RevisionPane andSelector:#windowSpec
     SVN::MergeWizard::RevisionPane new openInterface:#windowSpec
     SVN::MergeWizard::RevisionPane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'RevisionPane'
          name: 'RevisionPane'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'RevisionSelectionBrowser'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'SVN::BranchAndRevisionSelectionDialog'
              minorKey: contentSpec
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: model
                  aspect: logHolder
                ) 
               (SubChannelInfoSpec
                  subAspect: selectionHolder
                  aspect: revisionHolder
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
! !

!UpdateLikeWizard::RevisionPane methodsFor:'private'!

createNext
    "Superclass SVN::Wizard::Pane says that I am responsible to implement this method"
    
    ^UpdateLikeWizard::MergePane new

    "Modified: / 02-04-2009 / 17:05:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2009 / 17:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UpdateLikeWizard::RevisionPane methodsFor:'queries'!

canGoNext
    "Superclass SVN::Wizard::Pane says that I am responsible to implement this method"
    ^self revisionHolder value notNil

    "Modified: / 24-03-2009 / 19:27:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UpdateLikeWizard class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__UpdateLikeWizard.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !

