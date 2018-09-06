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

Dialog subclass:#BranchSelectionDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!BranchSelectionDialog class methodsFor:'documentation'!

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

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany (janfrog@bruxa)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    SVN::BranchSelectionDialog open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 11-04-2008 / 13:46:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchSelectionDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::BranchSelectionDialog andSelector:#dialogSpec
     SVN::BranchSelectionDialog new openInterface:#dialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SelectionInListModelViewSpec
              name: 'BranchList'
              layout: (LayoutFrame 0 0 0 0 0 1 -25 1)
              model: branchAspect
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: branchesAspect
              useIndex: false
              highlightMode: line
            )
           (CheckBoxSpec
              label: 'Show tags'
              name: 'ShowTags'
              layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
              initiallyDisabled: true
              model: showTagsAspect
              translateLabel: true
            )
           )
         
        )
      )

    "Created: / 21-10-2008 / 12:37:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchSelectionDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!BranchSelectionDialog methodsFor:'accessing'!

branch

    ^self branchAspect value

    "Created: / 02-11-2009 / 16:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTitle
    "Superclass SVN::Dialog says that I am responsible to implement this method"
    
    ^ 'Select branch for ' , self model package asText allItalic

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchSelectionDialog methodsFor:'aspects'!

acceptEnabledHolder
    |holder|

    (holder := builder bindingAt:#acceptEnabledHolder) isNil ifTrue:[
        holder := (AspectAdaptor forAspect:#notNil) 
                    subjectChannel:self branchAspect.
        builder aspectAt:#acceptEnabledHolder put:holder
    ].
    ^ holder.

    "Created: / 14-04-2008 / 11:19:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

branchAspect
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    |holder|

    (holder := builder bindingAt:#branchAspect) isNil ifTrue:[
        holder := nil asValue.
        builder aspectAt:#branchAspect put:holder.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/        holder addDependent:self.
"/        holder onChangeSend:#branchAspectChanged to:self.
    ].
    ^ holder.

    "Created: / 14-04-2008 / 10:55:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

branchesAspect
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    |holder|

    (holder := builder bindingAt:#branchesAspect) isNil ifTrue:[
        holder := (PluggableAdaptor on: self model)
                    getBlock:[:model|
                        self showTagsAspect value
                            ifTrue:[model value branchesAndTags]
                            ifFalse:[model value branches]]
                    putBlock:[:model :value|]
                    updateBlock:[:model :aspect :value|true]
    ].

    ^ holder.

    "Created: / 14-04-2008 / 10:55:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showTagsAspect
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    |holder|

    (holder := builder bindingAt:#showTagsAspect) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#showTagsAspect put:holder.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/        holder addDependent:self.
          holder onChangeEvaluate:[self branchesAspect changed].
    ].
    ^ holder.

    "Created: / 14-04-2008 / 10:55:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchSelectionDialog methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects in:aComponent
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefine in order for drop to work."

    self shouldImplement

    "Created: / 19-04-2008 / 13:15:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchSelectionDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__BranchSelectionDialog.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
