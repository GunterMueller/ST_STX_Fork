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

Wizard subclass:#CommitWizard
	instanceVariableNames:'workingCopyHolder warningHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

WizardPane subclass:#MessagePane
	instanceVariableNames:'messageTextView'
	classVariableNames:'Messages'
	poolDictionaries:''
	privateIn:CommitWizard
!

WizardPane subclass:#WorkingCopyStatusPane
	instanceVariableNames:'initialized'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CommitWizard
!

!CommitWizard class methodsFor:'documentation'!

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

!CommitWizard class methodsFor:'instance creation'!

on: aWorkingCopy

    ^self new 
        workingCopy: aWorkingCopy;
        yourself

    "Created: / 11-04-2008 / 11:47:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard class methodsFor:'interface opening'!

openOn: aWorkingCopy

    ^(self on: aWorkingCopy) open

    "Created: / 11-04-2008 / 11:47:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::CommitWizard andSelector:#contentSpec
     SVN::CommitWizard new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Content'
          name: 'Content'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'WizardPane'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              miniScrollerHorizontal: false
              clientHolder: paneHolder
              createNewBuilder: false
            )
           (LabelSpec
              label: 'Label'
              name: 'WarningHolder'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              translateLabel: true
              labelChannel: warningHolder
              adjust: left
            )
           )
         
        )
      )
! !

!CommitWizard methodsFor:'accessing'!

acceptButtonLabel
    ^ 'Commit'

    "Created: / 13-04-2008 / 11:08:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultTitle
    ^ 'Commit '

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-10-2008 / 09:14:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

firstPane

    ^WorkingCopyStatusPane new

    "Created: / 20-03-2009 / 13:51:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

message

    ^self pane value message

    "Created: / 21-03-2009 / 10:51:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repository
    ^ workingCopyHolder value repository

    "Created: / 31-03-2008 / 15:54:04 / janfrog"
    "Modified: / 31-03-2008 / 18:52:26 / janfrog"
!

workingCopy

    ^self modelHolder value workingCopy

    "Created: / 24-06-2009 / 15:55:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard methodsFor:'actions'!

doAccept
    self 
        showProgressWhile:[
            self acceptEnabled:false.
            MessagePane messages at:self task package put:self message.
            (self task)
                message:self message;
                doCommit.
            MessagePane messages removeKey:self task package ifAbsent:[].
            self accept value:true
        ]

    "Created: / 01-04-2008 / 18:59:12 / janfrog"
    "Modified: / 19-08-2009 / 14:26:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doBrowseWorkingCopy
    self workingCopy browse

    "Modified: / 04-02-2012 / 17:15:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCancel

    MessagePane messages
            at: self task package
            put: self message.
    super doCancel

    "Created: / 27-05-2009 / 13:38:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard methodsFor:'aspects'!

moveToTitleAspect

    ^[ 'Move to package ', self workingCopy package ]

    "Created: / 31-03-2008 / 21:58:14 / janfrog"
!

warningHolder
    "return/create the 'warningHolder' value holder (automatically generated)"

    warningHolder isNil ifTrue:[
        warningHolder := ValueHolder new.
    ].
    ^ warningHolder
! !

!CommitWizard methodsFor:'change & update'!

updateWarning

    | packageClasses packageExtensions noProjectClasses noProjectExtensions warning |
    packageClasses := self workingCopy packageClasses.
    packageExtensions := self workingCopy packageExtensions.
    noProjectClasses := ProjectDefinition searchForClassesWithProject: PackageId noProjectID.
    noProjectExtensions := ProjectDefinition searchForExtensionsWithProject: PackageId noProjectID.

    noProjectExtensions := noProjectExtensions select:
        [:mth|packageClasses includes: mth mclass].

    warning := noProjectExtensions isEmpty
                    ifTrue:
                        [nil]
                    ifFalse:
                        [LabelAndIcon 
                            label:'Some classes/methods in __NoProject__ may belong to ', self workingCopy package
                            icon: ToolbarIconLibrary warn32x32Icon].

    self warningHolder value: warning.

    "Created: / 24-06-2009 / 15:52:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard methodsFor:'hooks'!

commonPostOpen

    self updateWarning

    "Created: / 24-06-2009 / 16:01:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::MessagePane class methodsFor:'accessing'!

messages

    Messages ifNil:[Messages := Dictionary new].
    ^Messages

    "Created: / 27-05-2009 / 13:33:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::MessagePane class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SVN__CommitWizard.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !

!CommitWizard::MessagePane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::CommitWizard::MessagePane andSelector:#windowSpec
     SVN::CommitWizard::MessagePane new openInterface:#windowSpec
     SVN::CommitWizard::MessagePane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Commit Message'
          name: 'Commit Message'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Commit message:'
              name: 'MessageLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              adjust: left
            )
           (TextEditorSpec
              name: 'MessageText'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              modifiedChannel: modifiedChannel
              hasKeyboardFocusInitially: false
              viewClassName: ''
              postBuildCallback: postBuildMessageTextView:
            )
           )
         
        )
      )

    "Modified: / 24-03-2009 / 20:29:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::MessagePane methodsFor:'accessing'!

message

    ^messageTextView 
        ifNotNil:[messageTextView contents]
        ifNil:[nil]

    "Created: / 31-03-2008 / 21:06:28 / janfrog"
    "Modified: / 09-04-2009 / 08:50:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

message: aString

    ^messageTextView contents: aString

    "Created: / 08-04-2009 / 23:27:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::MessagePane methodsFor:'aspect'!

messageModifiedChannel

    ^[:modified|self updateDoAcceptButton]

    "Created: / 24-03-2009 / 20:08:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

modifiedChannel

    ^nil asValue
        onChangeSend: #updateButtons to: self;
        yourself

    "Created: / 24-03-2009 / 20:29:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::MessagePane methodsFor:'hooks'!

postBuildMessageTextView: aView

    messageTextView := aView scrolledView.
    messageTextView model:
        (self class messages
            at: self task package
            ifAbsent:[self task message])

    "Created: / 31-03-2008 / 21:05:03 / janfrog"
    "Modified: / 27-05-2009 / 13:35:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-08-2010 / 12:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitWizard::MessagePane methodsFor:'private'!

createNext
    "Superclass SVN::Wizard::Pane says that I am responsible to implement this method"
    
    self shouldImplement
! !

!CommitWizard::MessagePane methodsFor:'queries'!

acceptEnabled
    ^ self message isNilOrEmptyCollection not

    "Modified: / 02-04-2009 / 16:28:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

canGoNext
    "Superclass SVN::Wizard::Pane says that I am responsible to implement this method"

    ^false

    "Modified: / 02-04-2009 / 16:29:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::WorkingCopyStatusPane class methodsFor:'documentation'!

version_SVN
    ^ '§Id: SVN__CommitWizard.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !

!CommitWizard::WorkingCopyStatusPane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::CommitWizard::WorkingCopyStatusPane andSelector:#windowSpec
     SVN::CommitWizard::WorkingCopyStatusPane new openInterface:#windowSpec
     SVN::CommitWizard::WorkingCopyStatusPane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Working copy status'
          name: 'Working copy status'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 564 366)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: ' Working copy status'
              name: 'PaneLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              adjust: left
            )
           (SubCanvasSpec
              name: 'WorkingCopyStatus'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'SVN::WorkingCopyBrowser'
              minorKey: windowSpec
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: model
                  aspect: workingCopyAspect
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )
         
        )
      )
! !

!CommitWizard::WorkingCopyStatusPane methodsFor:'accessing'!

message

    ^''

    "Created: / 02-06-2009 / 13:36:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::WorkingCopyStatusPane methodsFor:'actions'!

enter
    initialized == true ifFalse:[
        self showProgressWhile:[ self task doPrepareWorkingCopy ].
        initialized := true
    ].

    "Created: / 02-04-2009 / 17:10:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 09:06:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::WorkingCopyStatusPane methodsFor:'aspects'!

workingCopyAspect

    ^(AspectAdaptor forAspect: #workingCopy)
        subjectChannel: self masterApplication modelHolder

    "Created: / 23-03-2009 / 11:53:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::WorkingCopyStatusPane methodsFor:'private'!

createNext
    ^ SVN::CommitWizard::MessagePane new

    "Created: / 21-03-2009 / 12:24:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard::WorkingCopyStatusPane methodsFor:'queries'!

acceptEnabled
    ^ false

    "Modified: / 02-04-2009 / 16:28:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

canGoNext

    ^true

    "Modified: / 20-03-2009 / 13:53:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitWizard class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CommitWizard.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
