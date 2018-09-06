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

ApplicationModel subclass:#DiffViewApp
	instanceVariableNames:'diffView diffHolder versionALabelHolder versionBLabelHolder
		versionATextHolder versionBTextHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers-Diff'
!

Tools::DiffCodeView2 subclass:#Diff2TextView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DiffViewApp
!

DiffTextView subclass:#Diff3TextView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DiffViewApp
!

!DiffViewApp class methodsFor:'documentation'!

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

!DiffViewApp class methodsFor:'image specs'!

versionA24x24

    ^IconLibrary versionA24x24

    "Created: / 24-03-2010 / 20:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionB24x24

    ^IconLibrary versionB24x24

    "Created: / 24-03-2010 / 20:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBase24x24

    ^IconLibrary versionBase24x24

    "Created: / 24-03-2010 / 20:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp class methodsFor:'interface specs'!

diffSpec_ThreeWay
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffBrowser andSelector:#diffSpec_ThreeWay
     SVN::DiffBrowser new openInterface:#diffSpec_ThreeWay
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'diffSpec_ThreeWay'
        window: 
       (WindowSpec
          label: 'Three-way diff view'
          name: 'Three-way diff view'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (TransparentBoxSpec
              name: '3Labels'
              layout: (LayoutFrame 0 0 0 0 -16 1 30 0)
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'VersionA'
                    layout: (LayoutFrame 0 0 0 0 0 0.33 30 0)
                    minorKey: versionALabelSpec
                  )
                 (UISubSpecification
                    name: 'VersionB'
                    layout: (LayoutFrame 2 0.33 0 0 0 0.66 30 0)
                    minorKey: versionBLabelSpec
                  )
                 (UISubSpecification
                    name: 'VersionBase'
                    layout: (LayoutFrame 3 0.66 0 0 0 1 30 0)
                    minorKey: versionBaseLabelSpec
                  )
                 )
               
              )
            )
           (ArbitraryComponentSpec
              name: 'Diff3TextView'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              autoHideScrollBars: false
              hasBorder: false
              component: #'SVN::DiffViewApp::Diff3TextView'
              postBuildCallback: postBuildDiffView:
            )
           )
         
        )
      )

    "Modified: / 23-11-2009 / 18:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffSpec_TwoWay
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffViewApp andSelector:#diffSpec_TwoWay
     SVN::DiffViewApp new openInterface:#diffSpec_TwoWay
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'diffSpec_TwoWay'
        window: 
       (WindowSpec
          label: 'Three-way diff view'
          name: 'Three-way diff view'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: '2Labels'
              layout: (LayoutFrame 0 0 0 0 -16 1 30 0)
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'VersionA'
                    layout: (LayoutFrame 0 0 0 0 0 0.5 30 0)
                    minorKey: versionALabelSpec
                  )
                 (UISubSpecification
                    name: 'VersionB'
                    layout: (LayoutFrame 5 0.5 0 0 0 1 30 0)
                    minorKey: versionBLabelSpec
                  )
                 )
               
              )
            )
           (ArbitraryComponentSpec
              name: 'Diff2TextView'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              autoHideScrollBars: false
              hasBorder: false
              component: #'SVN::DiffViewApp::Diff2TextView'
              postBuildCallback: postBuildDiffView:
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
     UIPainter new openOnClass:SVN::DiffViewApp andSelector:#windowSpec
     SVN::DiffViewApp new openInterface:#windowSpec
     SVN::DiffViewApp open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Diff View'
          name: 'Diff View'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 818 594)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'DiffView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              minorKey: #'diffSpec_TwoWay'
            )
           )
         
        )
      )
! !

!DiffViewApp class methodsFor:'interface specs - labels'!

versionALabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffViewApp andSelector:#versionALabelSpec
     SVN::DiffViewApp new openInterface:#versionALabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionALabelSpec
        window: 
       (WindowSpec
          label: 'Version A'
          name: 'Version A'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionA24x24'
              name: 'VersionAIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Version A'
              name: 'VersionALabel'
              layout: (LayoutFrame 30 0 0 0 0 1 0 1)
              translateLabel: true
              labelChannel: versionALabelHolder
              resizeForLabel: true
              adjust: left
            )
           )
         
        )
      )
!

versionBLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffViewApp andSelector:#versionBLabelSpec
     SVN::DiffViewApp new openInterface:#versionBLabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionBLabelSpec
        window: 
       (WindowSpec
          label: 'Version B'
          name: 'Version B'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionB24x24'
              name: 'VersionBIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Version B'
              name: 'VersionBLabel'
              layout: (LayoutFrame 30 0 0 0 0 1 0 1)
              translateLabel: true
              labelChannel: versionBLabelHolder
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           )
         
        )
      )
!

versionBaseLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::DiffViewApp andSelector:#versionBaseLabelSpec
     SVN::DiffViewApp new openInterface:#versionBaseLabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionBaseLabelSpec
        window: 
       (WindowSpec
          label: 'Version Base'
          name: 'Version Base'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'versionBase24x24'
              name: 'VersionBaseIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Version Base'
              name: 'VersionBaseLabel'
              layout: (LayoutFrame 30 0 5 0 191 0 0 1)
              translateLabel: true
              labelChannel: versionBaseLabelAspect
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           )
         
        )
      )

    "Modified: / 24-03-2010 / 20:51:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!DiffViewApp class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #diffHolder
      ).

! !

!DiffViewApp methodsFor:'accessing'!

diffitem


    ^self diffHolder value.

    "Created: / 09-11-2009 / 12:22:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-11-2009 / 11:01:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString

    "Created: / 25-06-2010 / 11:37:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA: textA versionB: textB

    self versionATextHolder setValue: textA.
    self versionBTextHolder setValue: textB.
    self updateTexts

    "Created: / 25-06-2010 / 11:34:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionALabel: aString

    ^self versionALabelHolder value: aString.

    "Created: / 25-06-2010 / 11:34:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBLabel: aString

    ^self versionBLabelHolder value: aString.

    "Created: / 25-06-2010 / 11:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp methodsFor:'aspects'!

diffHolder
    "return/create the 'diffitemHolder' value holder (automatically generated)"

    diffHolder isNil ifTrue:[
        diffHolder := ValueHolder new.
        diffHolder addDependent:self.
    ].
    ^ diffHolder

    "Created: / 09-11-2009 / 12:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffHolder:aValueModel
    "set the 'diffitemHolder' value holder (automatically generated)"

    |oldValue newValue|

    diffHolder notNil ifTrue:[
        oldValue := diffHolder value.
        diffHolder removeDependent:self.
    ].
    diffHolder := aValueModel.
    diffHolder notNil ifTrue:[
        diffHolder addDependent:self.
    ].
    newValue := diffHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:diffHolder.
    ].

    "Created: / 09-11-2009 / 12:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionALabelHolder
    "return/create the 'versionALabelHolder' value holder (automatically generated)"

    versionALabelHolder isNil ifTrue:[
        versionALabelHolder := ValueHolder with: 'Version A'.
    ].
    ^ versionALabelHolder

    "Modified: / 24-06-2010 / 18:54:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionALabelHolder:something
    "set the 'versionALabelHolder' value holder (automatically generated)"

    versionALabelHolder := something.
!

versionATextHolder
    "return/create the 'versionATextHolder' value holder (automatically generated)"

    versionATextHolder isNil ifTrue:[
        versionATextHolder := ValueHolder new.
        versionATextHolder addDependent:self.
    ].
    ^ versionATextHolder
!

versionATextHolder:something
    "set the 'versionATextHolder' value holder (automatically generated)"

    |oldValue newValue|

    versionATextHolder notNil ifTrue:[
        oldValue := versionATextHolder value.
        versionATextHolder removeDependent:self.
    ].
    versionATextHolder := something.
    versionATextHolder notNil ifTrue:[
        versionATextHolder addDependent:self.
    ].
    newValue := versionATextHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:versionATextHolder.
    ].
!

versionBLabelHolder
    "return/create the 'versionBLabelHolder' value holder (automatically generated)"

    versionBLabelHolder isNil ifTrue:[
        versionBLabelHolder := ValueHolder with: 'Version B'.
    ].
    ^ versionBLabelHolder

    "Modified: / 24-06-2010 / 18:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBLabelHolder:something
    "set the 'versionBLabelHolder' value holder (automatically generated)"

    versionBLabelHolder := something.
!

versionBTextHolder
    "return/create the 'versionBTextHolder' value holder (automatically generated)"

    versionBTextHolder isNil ifTrue:[
        versionBTextHolder := ValueHolder new.
        versionBTextHolder addDependent:self.
    ].
    ^ versionBTextHolder
!

versionBTextHolder:something
    "set the 'versionBTextHolder' value holder (automatically generated)"

    |oldValue newValue|

    versionBTextHolder notNil ifTrue:[
        oldValue := versionBTextHolder value.
        versionBTextHolder removeDependent:self.
    ].
    versionBTextHolder := something.
    versionBTextHolder notNil ifTrue:[
        versionBTextHolder addDependent:self.
    ].
    newValue := versionBTextHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:versionBTextHolder.
    ].
!

versionBaseLabelAspect

    <resource: #uiAspect>

    ^(AspectAdaptor forAspect: #versionBaseLabel)
        subjectChannel: self diffHolder

    "Created: / 24-11-2009 / 09:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp methodsFor:'callbacks'!

commonPostOpen

    ^self updateTexts

    "Created: / 25-06-2010 / 11:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildDiffView: aView

    diffView := aView.

    "Created: / 09-11-2009 / 12:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp methodsFor:'change & update'!

update:aspect with:param from:sender

    (sender == versionATextHolder or:[sender == versionBTextHolder])
        ifTrue:[^self updateTexts].

    sender == diffHolder 
        ifTrue:[ ^ self updateDiff ].

    ^ super 
        update:aspect
        with:param
        from:sender

    "Created: / 09-11-2009 / 12:20:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2010 / 19:08:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateDiff

    diffView ifNil:[ ^ self ].
    self diffitem ifNil: [ ^ self ].

    self versionALabelHolder value: self diffitem versionALabel.
    self versionBLabelHolder value: self diffitem versionBLabel.

    
    self versionATextHolder setValue: (self sourceOf: self diffitem versionA).
    self versionBTextHolder setValue: (self sourceOf: self diffitem versionB).

    self updateTexts

    "Created: / 24-06-2010 / 19:01:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTexts

    diffView ifNil:[^self].
    diffView 
        text1: versionATextHolder value
        text2: versionBTextHolder value

    "Created: / 24-06-2010 / 18:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2010 / 11:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp methodsFor:'private'!

sourceOf: aChange

    ^(aChange isNil or:[aChange isClassRemoveChange or: [aChange isMethodRemoveChange]])
        ifTrue:[SVN::DiffBrowser versionNotPresentText]
        ifFalse:[aChange source]

    "Created: / 03-11-2009 / 13:21:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 12:34:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp::Diff3TextView class methodsFor:'defaults'!

numberOfViews
    "return the number of the synced subViews.
     Usually redefined in subclasses"

    ^ 3

    "Created: / 03-11-2009 / 13:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp::Diff3TextView methodsFor:'accessing'!

change1: c1 change2: c2 change3: c3

    "Sorry. no three-way diff here. I'm too lazy :-)
     Waiting for pure smalltalk diff implementation...
    "
    c1 isNil | c2 isNil 
        ifTrue:
            [textViews first contents: (self sourceOf: c1).
            textViews second contents: (self sourceOf: c2)]
        ifFalse:
            [self 
                text1: (self sourceOf: c1) 
                text2: (self sourceOf: c2) ].
    textViews third contents: (self sourceOf: c3)

    "Created: / 04-11-2009 / 09:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp::Diff3TextView methodsFor:'private'!

sourceOf: aChange

    ^(aChange isNil or:[aChange isClassRemoveChange or: [aChange isMethodRemoveChange]])
        ifTrue:[SVN::DiffBrowser versionNotPresentText]
        ifFalse:[aChange source]

    "Created: / 03-11-2009 / 13:21:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 12:34:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffViewApp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__DiffViewApp.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
