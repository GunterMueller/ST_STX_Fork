"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

TextDiffTool subclass:#TextDiff2Tool
	instanceVariableNames:'showDiffHolder diffSpecHolder codeView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

!TextDiff2Tool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    a little UI around the DiffTextView,
    to show two texts side by side.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                        [exBegin]
    |text1 text2|

    text1 := 'hello world
here is some difference
more text
this line has been removed
more text
more text
'.

    text2 := 'hello world
where is the difference ?
more text
more text
more text
this line has been added
'.

    TextDiff2Tool openOn:text1 label:'text1'
                     and:text2 label:'text2'
                                                        [exEnd]
"
! !

!TextDiff2Tool class methodsFor:'interface opening'!

openOn:textA label:labelA and: textB label: labelB
    | app |

    app := self new.
    app labelA: labelA; textA: textA.
    app labelB: labelB; textB: textB.
    app open.
    ^ app window

    "Created: / 16-03-2012 / 13:15:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-07-2016 / 10:06:46 / jv"
! !

!TextDiff2Tool class methodsFor:'interface specs'!

diffSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiff2Tool andSelector:#diffSpec
     Tools::TextDiff2Tool new openInterface:#diffSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: diffSpec
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
              component: diffView
              postBuildCallback: postBuildDiffView:
            )
           )
         
        )
      )
!

nothingSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiffTool andSelector:#nothingSpec
     Tools::TextDiffTool new openInterface:#nothingSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: nothingSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Nothing selected...'
              name: 'Label1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              translateLabel: true
            )
           )
         
        )
      )
!

textAViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiffTool andSelector:#textViewSpec
     Tools::TextDiffTool new openInterface:#textViewSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: 'textAViewSpec'
        window: 
       (WindowSpec
          label: 'Text Only'
          name: 'Text Only'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (ArbitraryComponentSpec
              name: 'CodeView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: textAHolder
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              autoHideScrollBars: false
              hasBorder: false
              component: #'Tools::CodeView2'
              postBuildCallback: postBuildCodeView:
            )
           )
         
        )
      )

    "Created: / 18-04-2012 / 18:43:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textBViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiffTool andSelector:#textViewSpec
     Tools::TextDiffTool new openInterface:#textViewSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: 'textAViewSpec'
        window: 
       (WindowSpec
          label: 'Text Only'
          name: 'Text Only'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (ArbitraryComponentSpec
              name: 'CodeView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: textBHolder
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              autoHideScrollBars: false
              hasBorder: false
              component: #'Tools::CodeView2'
              postBuildCallback: postBuildCodeView:
            )
           )
         
        )
      )

    "Created: / 18-04-2012 / 18:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionAOnlySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiffTool andSelector:#versionAOnlySpec
     Tools::TextDiffTool new openInterface:#versionAOnlySpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionAOnlySpec
        window: 
       (WindowSpec
          label: 'Version A Only'
          name: 'Version A Only'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'VersionA'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              minorKey: versionALabelSpec
            )
           (UISubSpecification
              name: 'Text'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              minorKey: textAViewSpec
            )
           )
         
        )
      )

    "Modified: / 18-04-2012 / 18:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBOnlySpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::TextDiffTool andSelector:#versionBOnlySpec
     Tools::TextDiffTool new openInterface:#versionBOnlySpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: 'versionBOnlySpec'
        window: 
       (WindowSpec
          label: 'Version B Only'
          name: 'Version B Only'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'VersionB'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              minorKey: versionBLabelSpec
            )
          (UISubSpecification
              name: 'Text'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              minorKey: textBViewSpec
            )
           )
         
        )
      )

    "Created: / 19-07-2011 / 10:06:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #classHolder
        #codeAspectHolder
        #labelAHolder
        #labelBHolde
        #labelCHolder
        #labelHolder
        #languageHolder
        #showDiffHolder
        #textAHolder
        #textBHolder
        #textCHolder
      ).

! !

!TextDiff2Tool methodsFor:'accessing'!

title: aString

    ^self label: aString

    "Created: / 30-08-2011 / 09:45:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool methodsFor:'aspects'!

showDiffHolder
    "return/create the 'showDiffHolder' value holder (automatically generated)"

    showDiffHolder isNil ifTrue:[
        showDiffHolder := ValueHolder with: true.
        showDiffHolder addDependent:self.
    ].
    ^ showDiffHolder

    "Modified: / 30-06-2011 / 20:59:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDiffHolder:something
    "set the 'showDiffHolder' value holder (automatically generated)"

    |oldValue newValue|

    showDiffHolder notNil ifTrue:[
        oldValue := showDiffHolder value.
        showDiffHolder removeDependent:self.
    ].
    showDiffHolder := something.
    showDiffHolder notNil ifTrue:[
        showDiffHolder addDependent:self.
    ].
    newValue := showDiffHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showDiffHolder.
    ].
! !

!TextDiff2Tool methodsFor:'change & update'!

codeAspect

    ^self codeAspectHolder value

    "Created: / 19-07-2011 / 19:07:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    |realDiffView|

    (changedObject == showDiffHolder) ifTrue:[
        self updateViews.            
        ^ self.
    ].
    diffView notNil ifTrue:[
        "/ otherwise, respondsTo does not work.
        realDiffView := diffView scrolledView.
        (realDiffView respondsTo:#leftTextView) ifTrue:[
            ((changedObject == diffView leftTextView modifiedChannel) 
            or:[changedObject == diffView rightTextView modifiedChannel]) ifTrue:[
                self enqueueMessage:#updateDiffFromChangedText for:self arguments:#().
                ^ self.    
            ]
        ].
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 16-03-2012 / 12:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterAorBorCChanged

    (textAChanged & textBChanged) ifTrue:[
        textAChanged := textBChanged := false.
        self updateViews
    ].

    "Created: / 16-03-2012 / 12:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateDiffFromChangedText
    |leftView rightView prevCursorLine1 prevCursorCol1 prevCursorLine2 prevCursorCol2|

    leftView := diffView leftTextView.
    rightView := diffView rightTextView.

    prevCursorLine1 := leftView cursorLine.
    prevCursorCol1 := leftView cursorCol.
    prevCursorLine2 := rightView cursorLine.
    prevCursorCol2 := rightView cursorCol.

        
    self textA:(leftView contents).
    self textB:(rightView contents).
    leftView modifiedChannel setValue:false.
    rightView modifiedChannel setValue:false.

    self updateViews.    
    leftView cursorLine:prevCursorLine1 col:prevCursorCol1.
    rightView cursorLine:prevCursorLine2 col:prevCursorCol2.
!

updateViews
    | a b |

    a := self textA.
    b := self textB.

    self showDiffHolder value ifFalse:[
        self showTextOnly.
        ^ self
    ].

    (a notNil and:[b notNil]) ifTrue:[
        self showDiff.
        ^self
    ].
    a notNil ifTrue:[
        self showVersionA.
        ^self
    ].
    b notNil ifTrue:[
        self showVersionB.
        ^self
    ].

   self showNothing.

    "Created: / 19-07-2011 / 11:29:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool methodsFor:'hooks'!

postBuildCodeView:aScrollableView

    codeView := aScrollableView.
    codeView notNil ifTrue:[codeView languageHolder: self languageHolder].
    codeView notNil ifTrue:[codeView classHolder: self classHolder].

    "Created: / 19-07-2011 / 10:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildDiffView:aScrollableView
    |textA textB|

    super postBuildDiffView:aScrollableView.

    diffView notNil ifTrue:[
        textA := self textA.
        textB := self textB.
       (textA notNil and:[textB notNil]) ifTrue:[
            diffView scrolledView
                text1: textA
                text2: textB
        ].
        diffView textViews do:[:each | each modifiedChannel addDependent:self].    
    ].

    "Created: / 16-03-2012 / 13:30:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool methodsFor:'initialization'!

initializeDiffView
    "superclass Tools::TextDiffTool says that I am responsible to implement this method"

    ^ Tools::DiffCodeView2 new

    "Modified: / 16-01-2013 / 11:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool methodsFor:'private'!

showDiff
    |scrolledView|

    self contentSpecHolder value: #diffSpec.
    
    diffView isNil ifTrue:[^self].
    (scrolledView := diffView scrolledView) isNil ifTrue:[^self].
    scrolledView
        text1: self textA
        text2: self textB

    "Created: / 19-07-2011 / 10:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 15:01:12 / cg"
    "Modified: / 16-03-2012 / 13:21:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showNothing

    self contentSpecHolder value: #nothingSpec

    "Created: / 19-07-2011 / 19:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showTextOnly

    self contentSpecHolder value: #textViewSpec

    "Created: / 19-07-2011 / 11:39:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVersionA

    self contentSpecHolder value: #versionAOnlySpec

    "Created: / 19-07-2011 / 10:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVersionB

    self contentSpecHolder value: #versionBOnlySpec

    "Created: / 19-07-2011 / 10:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool methodsFor:'testing'!

isDiff2
    ^true

    "Created: / 16-03-2012 / 15:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextDiff2Tool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

