"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#TextDiffTool
	instanceVariableNames:'labelHolder labelAHolder textAHolder labelBHolder textBHolder
		labelCHolder textCHolder languageHolder codeAspectHolder
		textAChanged textBChanged textCChanged contentSpecHolder diffView
		classHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

!TextDiffTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
    See
        - TextDiff2Tool examples
        - TextDiff3Tool examples
"
! !

!TextDiffTool class methodsFor:'image specs'!

versionA24x24

    ^ToolbarIconLibrary versionA24x24

    "Created: / 24-03-2010 / 20:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionB24x24

    ^ToolbarIconLibrary versionB24x24

    "Created: / 24-03-2010 / 20:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBase24x24

    ^ToolbarIconLibrary versionBase24x24

    "Created: / 24-03-2010 / 20:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMerged24x24

    ^ToolbarIconLibrary versionMerged24x24

    "Created: / 17-03-2012 / 12:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff2Tool andSelector:#windowSpec
     Tools::TextDiff2Tool new openInterface:#windowSpec
     Tools::TextDiff2Tool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Text Diff Tool'
          name: 'Text Diff Tool'
          labelChannel: titleHolder
          min: (Point 10 10)
          bounds: (Rectangle 0 0 640 480)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Label'
              name: 'Label1'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: labelHolder
            )
           (UISubSpecification
              name: 'Contents'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              minorKey: windowSpecForEmbedding
            )
           )
         
        )
      )
!

windowSpecForEmbedding
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff2Tool andSelector:#windowSpecForEmbedding
     Tools::TextDiff2Tool new openInterface:#windowSpecForEmbedding
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpecForEmbedding
        window: 
       (WindowSpec
          label: 'Text Diff Tool (for embedding)'
          name: 'Text Diff Tool (for embedding)'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'Contents'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              specHolder: contentSpecHolder
              createNewBuilder: false
            )
           )
         
        )
      )
! !

!TextDiffTool class methodsFor:'interface specs - labels'!

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
              labelChannel: labelAHolder
              resizeForLabel: true
              adjust: left
            )
           )
         
        )
      )

    "Modified: / 30-06-2011 / 20:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
              labelChannel: labelBHolder
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           )
         
        )
      )

    "Modified: / 30-06-2011 / 20:53:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionCLabelSpec
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
        name: versionCLabelSpec
        window: 
       (WindowSpec
          label: 'Version C'
          name: 'Version C'
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
              label: 'Version C'
              name: 'VersionCLabel'
              layout: (LayoutFrame 30 0 5 0 191 0 0 1)
              translateLabel: true
              labelChannel: labelCHolder
              resizeForLabel: true
              adjust: left
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           )
         
        )
      )

    "Created: / 16-03-2012 / 12:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool class methodsFor:'plugIn spec'!

aspectSelectors

    ^#( 
        #labelHolder

        #labelAHolder
        #labelBHolder
        #labelCHolder

        #textAHolder
        #textBHolder
        #textCHolder

        #languageHolder
        #codeAspectHolder
    )

    "Created: / 16-03-2012 / 12:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'accessing'!

label: aString

    ^self labelHolder value: aString

    "Created: / 16-03-2012 / 13:07:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelA: aString

    ^self labelAHolder value: aString

    "Created: / 16-03-2012 / 13:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelB: aString
    ^self labelBHolder value: aString

    "Modified: / 19-07-2011 / 11:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-08-2011 / 09:42:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:57:15 / cg"
!

labelC: aString

    ^self labelCHolder value: aString

    "Modified: / 19-07-2011 / 11:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 16-03-2012 / 13:05:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textA

    ^self textAHolder value

    "Created: / 19-03-2012 / 12:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textA: aString
    ^self textAHolder value: aString

    "Created: / 30-08-2011 / 09:43:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:57:37 / cg"
!

textB

    ^self textBHolder value

    "Created: / 19-03-2012 / 12:24:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textB: aString
    ^self textBHolder value: aString

    "Created: / 30-08-2011 / 09:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:57:41 / cg"
!

textC

    ^self textCHolder value

    "Created: / 19-03-2012 / 12:24:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textC: aString

    ^self textCHolder value: aString

    "Created: / 16-03-2012 / 13:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString
    <resource: #obsolete>

    ^self label: aString

    "Created: / 30-08-2011 / 09:45:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'aspects'!

classHolder
    "return/create the 'classHolder' value holder (automatically generated)"

    classHolder isNil ifTrue:[
        classHolder := ValueHolder new.
    ].
    ^ classHolder
!

classHolder: aValueHolder
    classHolder := aValueHolder.
    "codeView notNil ifTrue:[codeView classHolder: aValueHolder]."
    diffView notNil ifTrue:[diffView classHolder: aValueHolder].

    "Modified: / 19-07-2011 / 12:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:57:00 / cg"
!

codeAspectHolder
    "return/create the 'codeAspectHolder' value holder (automatically generated)"

    codeAspectHolder isNil ifTrue:[
        codeAspectHolder := ValueHolder with: (SyntaxHighlighter codeAspectExpression).
        codeAspectHolder addDependent:self
    ].
    ^ codeAspectHolder

    "Modified: / 19-07-2011 / 19:07:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 23:46:11 / cg"
!

codeAspectHolder:something
    "set the 'codeAspectHolder' value holder (automatically generated)"

    codeAspectHolder notNil ifTrue:[
        codeAspectHolder removeDependent:self
    ].
    codeAspectHolder := something.
    codeAspectHolder notNil ifTrue:[
        codeAspectHolder addDependent:self
    ].

    "Modified: / 27-07-2012 / 22:55:42 / cg"
!

contentSpecHolder
    "return/create the 'contentSpecHolder' value holder (automatically generated)"

    contentSpecHolder isNil ifTrue:[
        contentSpecHolder := ValueHolder new.
        contentSpecHolder addDependent:self.
    ].
    ^ contentSpecHolder
!

contentSpecHolder:something
    "set the 'contentSpecHolder' value holder (automatically generated)"

    |oldValue newValue|

    contentSpecHolder notNil ifTrue:[
        oldValue := contentSpecHolder value.
        contentSpecHolder removeDependent:self.
    ].
    contentSpecHolder := something.
    contentSpecHolder notNil ifTrue:[
        contentSpecHolder addDependent:self.
    ].
    newValue := contentSpecHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:contentSpecHolder.
    ].
!

diffView
"/    diffView isNil ifTrue:[
        diffView := self initializeDiffView.
"/    ].
   ^diffView

    "Created: / 16-01-2013 / 09:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2014 / 00:16:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelHolder
    "return/create the 'labelAHolder' value holder (automatically generated)"

    labelHolder isNil ifTrue:[
        labelHolder := ValueHolder with:'Text diff'.
        "/titleHolder addDependent:self.
    ].
    ^ labelHolder

    "Created: / 16-03-2012 / 13:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageHolder
    "return/create the 'languageHolder' value holder (automatically generated)"

    languageHolder isNil ifTrue:[
        languageHolder := ValueHolder new.
    ].
    ^ languageHolder
!

languageHolder:aValueHolder

    languageHolder := aValueHolder.
    "codeView notNil ifTrue:[codeView languageHolder: aValueHolder]."
    diffView notNil ifTrue:[diffView languageHolder: aValueHolder].

    "Modified: / 19-07-2011 / 12:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'aspects-versions'!

labelAHolder
    "return/create the 'labelAHolder' value holder (automatically generated)"

    labelAHolder isNil ifTrue:[
        labelAHolder := ValueHolder with:'Version A'.
        labelAHolder addDependent:self.
    ].
    ^ labelAHolder

    "Modified: / 19-07-2011 / 11:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelAHolder:something
    "set the 'labelAHolder' value holder (automatically generated)"

    |oldValue newValue|

    labelAHolder notNil ifTrue:[
        oldValue := labelAHolder value.
        labelAHolder removeDependent:self.
    ].
    labelAHolder := something.
    labelAHolder notNil ifTrue:[
        labelAHolder addDependent:self.
    ].
    newValue := labelAHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:labelAHolder.
    ].
!

labelBHolder
    "return/create the 'labelBHolder' value holder (automatically generated)"

    labelBHolder isNil ifTrue:[
        labelBHolder := ValueHolder with:'Version B'.
        labelBHolder addDependent:self.
    ].
    ^ labelBHolder

    "Modified: / 19-07-2011 / 11:42:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelBHolder:something
    "set the 'labelBHolder' value holder (automatically generated)"

    |oldValue newValue|

    labelBHolder notNil ifTrue:[
        oldValue := labelBHolder value.
        labelBHolder removeDependent:self.
    ].
    labelBHolder := something.
    labelBHolder notNil ifTrue:[
        labelBHolder addDependent:self.
    ].
    newValue := labelBHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:labelBHolder.
    ].
!

labelCHolder
    "return/create the 'labelBHolder' value holder (automatically generated)"

    labelCHolder isNil ifTrue:[
        labelCHolder := ValueHolder with:'Version Base'.
        labelCHolder addDependent:self.
    ].
    ^ labelCHolder

    "Created: / 16-03-2012 / 12:14:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelCHolder:something
    "set the 'labelBHolder' value holder (automatically generated)"

    |oldValue newValue|

    labelCHolder notNil ifTrue:[
        oldValue := labelCHolder value.
        labelCHolder removeDependent:self.
    ].
    labelCHolder := something.
    labelCHolder notNil ifTrue:[
        labelCHolder addDependent:self.
    ].
    newValue := labelCHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:labelCHolder.
    ].

    "Created: / 16-03-2012 / 12:15:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textAHolder
    "return/create the 'textAHolder' value holder (automatically generated)"

    textAHolder isNil ifTrue:[
        textAHolder := ValueHolder new.
        textAHolder addDependent:self.
    ].
    ^ textAHolder
!

textAHolder:something
    "set the 'textAHolder' value holder (automatically generated)"

    |oldValue newValue|

    textAHolder notNil ifTrue:[
        oldValue := textAHolder value.
        textAHolder removeDependent:self.
    ].
    textAHolder := something.
    textAHolder notNil ifTrue:[
        textAHolder addDependent:self.
    ].
    newValue := textAHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:textAHolder.
    ].
!

textBHolder
    "return/create the 'textBHolder' value holder (automatically generated)"

    textBHolder isNil ifTrue:[
        textBHolder := ValueHolder new.
        textBHolder addDependent:self.
    ].
    ^ textBHolder
!

textBHolder:something
    "set the 'textBHolder' value holder (automatically generated)"

    |oldValue newValue|

    textBHolder notNil ifTrue:[
        oldValue := textBHolder value.
        textBHolder removeDependent:self.
    ].
    textBHolder := something.
    textBHolder notNil ifTrue:[
        textBHolder addDependent:self.
    ].
    newValue := textBHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:textBHolder.
    ].
!

textCHolder
    "return/create the 'textBHolder' value holder (automatically generated)"

    textCHolder isNil ifTrue:[
        textCHolder := ValueHolder new.
        textCHolder addDependent:self.
    ].
    ^ textCHolder

    "Created: / 16-03-2012 / 12:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textCHolder:something
    "set the 'textBHolder' value holder (automatically generated)"

    |oldValue newValue|

    textCHolder notNil ifTrue:[
        oldValue := textCHolder value.
        textCHolder removeDependent:self.
    ].
    textCHolder := something.
    textCHolder notNil ifTrue:[
        textCHolder addDependent:self.
    ].
    newValue := textCHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:textCHolder.
    ].

    "Created: / 16-03-2012 / 12:14:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'change & update'!

codeAspect:aSymbol
    self codeAspectHolder value:aSymbol

    "Created: / 19-07-2011 / 19:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-07-2012 / 21:56:48 / cg"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."


    changedObject == textAHolder ifTrue:[
        textAChanged := true.
        self updateAfterAorBorCChanged.
        ^ self.
    ].
    changedObject == textBHolder ifTrue:[
        textBChanged := true.
        self updateAfterAorBorCChanged.
        ^ self.
    ].
    changedObject == textCHolder ifTrue:[
        textCChanged := true.
        self updateAfterAorBorCChanged.
        ^ self.
    ].

    ^super update:something with:aParameter from:changedObject

    "Created: / 16-03-2012 / 12:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterAorBorCChanged
    "Called whenever one of the texts changes"

    ^ self subclassResponsibility

    "Modified (comment): / 16-03-2012 / 12:39:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'hooks'!

postBuildDiffView:aScrollableView

    diffView := aScrollableView.
    self setupCodeView: aScrollableView.

    "Created: / 30-06-2011 / 20:55:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupCodeView: codeView2
    codeView2 notNil ifTrue:[
        codeView2
            languageHolder: self languageHolder;
            classHolder: self classHolder;
            modeHolder: self codeAspectHolder
    ].

    "Created: / 26-07-2012 / 19:13:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'initialization'!

initialize

    super initialize.
    textAChanged := textBChanged := textBChanged := false.

    "Modified: / 16-03-2012 / 12:40:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeDiffView

    self subclassResponsibility

    "Created: / 16-01-2013 / 09:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool methodsFor:'testing'!

isDiff2
    ^false

    "Created: / 16-03-2012 / 15:21:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiff3
    ^false

    "Created: / 16-03-2012 / 15:21:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerge
    ^false

    "Created: / 19-03-2012 / 11:53:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiffTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__TextDiffTool.st,v 1.12 2014-03-02 00:17:39 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__TextDiffTool.st,v 1.12 2014-03-02 00:17:39 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__TextDiffTool.st,v 1.12 2014-03-02 00:17:39 vrany Exp $'
! !

