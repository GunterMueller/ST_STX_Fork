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

Dialog subclass:#Wizard
	instanceVariableNames:'paneHolder goNextEnabledHolder goPrevEnabledHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!Wizard class methodsFor:'documentation'!

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

!Wizard class methodsFor:'interface specs'!

buttonsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Wizard andSelector:#buttonsSpec
     SVN::Wizard new openInterface:#buttonsSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: buttonsSpec
        window: 
       (WindowSpec
          label: 'Buttons'
          name: 'Buttons'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 400 30)
        )
        component: 
       (SpecCollection
          collection: (
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: rightSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Prev'
                    name: 'PrevButton'
                    translateLabel: true
                    model: goPrev
                    enableChannel: goPrevEnabledHolder
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'Next'
                    name: 'NextButton'
                    translateLabel: true
                    model: goNext
                    enableChannel: goNextEnabledHolder
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'AcceptButton'
                    translateLabel: true
                    labelChannel: acceptButtonTitleAspect
                    model: doAccept
                    enableChannel: acceptEnabledHolder
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'CancelButton'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 24-03-2009 / 19:52:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Wizard andSelector:#contentSpec
     SVN::Wizard new openInterface:#contentSpec
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
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              miniScrollerHorizontal: false
              clientHolder: paneHolder
              createNewBuilder: false
            )
           )
         
        )
      )
! !

!Wizard class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Wizard methodsFor:'accessing'!

defaultSubtitle
    ^ 'Package: ' , self model package asText allItalic

    "Created: / 28-10-2008 / 09:14:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

firstPane
    "
        Answers the very first pane to show
    "

    ^self subclassResponsibility

    "Created: / 20-03-2009 / 13:46:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

pane

    ^self paneHolder value

    "Created: / 08-04-2009 / 20:17:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

pane:aWizardPane 
    self pane leave.
    self paneHolder subjectChannel:aWizardPane.
    self paneHolder changed.
    aWizardPane masterApplication: self.
    self updateButtons.
    self pane enter.

    "Created: / 21-03-2009 / 10:55:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:53:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

task

    ^self model

    "Created: / 23-03-2009 / 11:49:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

task: aTask

    ^self model: aTask

    "Created: / 23-03-2009 / 11:49:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'accessing - buttons'!

goNextEnabled: aBoolean

    self goNextEnabledHolder value: aBoolean

    "Created: / 24-03-2009 / 19:56:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goPrevEnabled: aBoolean

    self goPrevEnabledHolder value: aBoolean

    "Created: / 24-03-2009 / 19:56:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'actions'!

goNext

    self showContent.
    ^self pane value goNext

    "Created: / 24-03-2009 / 14:38:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:30:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goPrev

    self showContent.
    ^self pane value goPrev

    "Created: / 24-03-2009 / 14:38:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:31:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'aspects'!

goNextEnabledHolder

    goNextEnabledHolder ifNil:
        [goNextEnabledHolder := false asValue].
    ^goNextEnabledHolder

    "Created: / 24-03-2009 / 19:51:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goPrevEnabledHolder

    goPrevEnabledHolder ifNil:
        [goPrevEnabledHolder := false asValue].
    ^goPrevEnabledHolder

    "Created: / 24-03-2009 / 19:51:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

paneHolder
    paneHolder 
        ifNil:[
            paneHolder := (AspectAdaptor subjectChannel:self firstPane
                        sendsUpdates:true) forAspect:#value.
        ].
    ^ paneHolder

    "Created: / 20-03-2009 / 13:45:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-03-2009 / 20:09:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'change & update'!

contentSpecChanged: specSymbol

    self updateButtons

    "Created: / 24-03-2009 / 20:15:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

updateButtons

    self pane value updateButtons

    "Created: / 24-03-2009 / 19:54:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'hooks'!

postOpenWith: anUIBuilder

    ^self pane value enter

    "Created: / 02-04-2009 / 17:10:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Wizard methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ pane := nil.

    super initialize.
! !

!Wizard class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Wizard.st 372 2011-09-29 10:47:58Z vranyj1 §'
! !
