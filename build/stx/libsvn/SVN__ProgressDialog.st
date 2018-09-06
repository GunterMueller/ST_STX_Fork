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

Dialog subclass:#ProgressDialog
	instanceVariableNames:''
	classVariableNames:'CurrentQuerySignal'
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!ProgressDialog class methodsFor:'documentation'!

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

    SVN::ProgressDialog
! !

!ProgressDialog class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    CurrentQuerySignal := QuerySignal new

    "Modified: / 10-03-2010 / 18:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgressDialog class methodsFor:'accessing'!

current

    | current |
    current := CurrentQuerySignal query.
    current ifNil:[current := self new].
    ^current

    "Created: / 10-03-2010 / 18:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgressDialog class methodsFor:'interface opening'!

openOn: aBlock 

    ^self openOn: aBlock title: 'Working...'

    "Created: / 28-10-2008 / 14:50:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

openOn: aBlock title: title

    ^self openOn: aBlock title: title subtitle: ''

    "Created: / 28-10-2008 / 14:50:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

openOn: block title: title subtitle: subtitle

    ^self new
        model: block;
        title: title;
        subtitle: subtitle;
        open

    "Created: / 28-10-2008 / 14:50:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 14:11:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog class methodsFor:'interface specs'!

buttonsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Dialog andSelector:#buttonsSpec
     SVN::Dialog new openInterface:#buttonsSpec
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

    "Created: / 28-10-2008 / 14:53:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ProgressDialog methodsFor:'accessing - defaults'!

defaultContentSpec


    ^#progressSpec

    "Created: / 28-10-2008 / 14:51:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultTitle
    ^'Working...'

    "Created: / 28-10-2008 / 14:55:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog methodsFor:'actions'!

doAccept

    self accept value: true

    "Created: / 19-08-2009 / 14:25:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects in:aComponent
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefine in order for drop to work."

    self shouldImplement

    "Created: / 28-10-2008 / 14:59:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog methodsFor:'hooks'!

postOpenWith: aUIBuilder

    self showProgressWhile:
        [self model value.
        self doAccept]

    "Created: / 28-10-2008 / 14:51:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:36:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgressDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ProgressDialog.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !

ProgressDialog initialize!
