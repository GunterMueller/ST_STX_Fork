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

DiffViewApp subclass:#MergeViewApp
	instanceVariableNames:'mergeHolder diff'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers-Diff'
!

!MergeViewApp class methodsFor:'documentation'!

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

!MergeViewApp class methodsFor:'interface specs'!

diffSpec_Merge
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeViewApp andSelector:#diffSpec_Merge
     SVN::MergeViewApp new openInterface:#diffSpec_Merge
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'diffSpec_Merge'
        window: 
       (WindowSpec
          label: 'Merge view'
          name: 'Merge view'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 506)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'DiffAndMergePanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'DiffView'
                    minorKey: #'diffSpec_ThreeWay'
                  )
                 (TransparentBoxSpec
                    name: 'MergeView'
                    component: 
                   (SpecCollection
                      collection: (
                       (UISubSpecification
                          name: 'MergeLabel'
                          layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                          minorKey: versionMergedLabelSpec
                        )
                       (TextEditorSpec
                          name: 'MergeCode'
                          layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                          model: mergeHolder
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          acceptCallBack: mergeAccepted
                          hasKeyboardFocusInitially: false
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )
! !

!MergeViewApp class methodsFor:'interface specs - labels'!

versionMergedLabelSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeViewApp andSelector:#versionMergedLabelSpec
     SVN::MergeViewApp new openInterface:#versionMergedLabelSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: versionMergedLabelSpec
        window: 
       (WindowSpec
          label: 'Version Merge'
          name: 'Version Merge'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 592 30)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              name: 'ResolveLabel'
              layout: (LayoutFrame 105 0 5 0 300 0 0 1)
              labelChannel: versionMergedLabelAspect
              adjust: left
            )
           (LabelSpec
              label: 'sphereGray24x24'
              name: 'VersionAIcon'
              layout: (LayoutFrame 0 0 -12 0.5 27 0 12 0.5)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              label: 'Resolution:'
              name: 'ResolutionLabel'
              layout: (LayoutFrame 30 0 5 0 100 0 0 1.0)
              translateLabel: true
              adjust: right
            )
           (ActionButtonSpec
              label: 'Resolve'
              name: 'Resolve'
              layout: (LayoutFrame -200 1 5 0 -5 1 -5 1)
              translateLabel: true
              model: mergeMenuOpen
            )
           )
         
        )
      )
! !

!MergeViewApp class methodsFor:'menu specs'!

mergeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::MergeViewApp andSelector:#mergeMenu
     (Menu new fromLiteralArrayEncoding:(SVN::MergeViewApp mergeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Unresolve'
            itemValue: mergeMenuUseNone
            translateLabel: true
          )
         (MenuItem
            label: 'Resolve using A'
            itemValue: mergeMenuUseB
            nameKey: ResolveUsingA
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionA16x16 'Resolve using A')
          )
         (MenuItem
            label: 'Resolve using B'
            itemValue: mergeMenuUseB
            nameKey: ResolveUsingB
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionB16x16 'Resolve using B')
          )
         (MenuItem
            label: 'Resolve using Base'
            itemValue: mergeMenuUseBase
            nameKey: ResolveUsingBase
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionBase16x16 'Resolve using Base')
          )
         (MenuItem
            label: 'Resolve using external tool'
            itemValue: mergeMenuUseExternalTool
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Inspect'
            itemValue: mergeMenuInspect
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!MergeViewApp class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!MergeViewApp class methodsFor:'plugIn spec'!

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

!MergeViewApp methodsFor:'aspects'!

mergeHolder
    mergeHolder ifNil:
        [mergeHolder := ValueHolder new].
    ^mergeHolder

    "Modified: / 23-11-2009 / 22:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMergedLabelAspect
    <resource: #uiAspect>

    | holder |

    (holder := builder bindingAt:#versionMergedLabelAspect) isNil ifTrue:[
        holder := (AspectAdaptor forAspect: #versionMergedLabel)
                    subjectChannel: self diffHolder.
        builder aspectAt:#versionMergedLabelAspect put:holder.
    ].
    ^ holder.
! !

!MergeViewApp methodsFor:'callbacks'!

mergeAccepted

    self diffHolder value versionMerged source: 
        self mergeHolder value.
    self updateResolution

    "Created: / 24-11-2009 / 12:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeViewApp methodsFor:'change & update'!

diffChanged

    diff ifNotNil:[diff removeDependent: self].
    diff := self diffitem.
    diff ifNotNil:[diff addDependent: self].    

    super diffChanged.
    self  resolutionChanged

    "Created: / 23-11-2009 / 22:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 07:13:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolutionChanged

    | source |
    source := diff 
                ifNil:
                    ['']
                ifNotNil:
                    [diff merged 
                        ifTrue:[diff versionMerged source] 
                        ifFalse:['<Merge Conflict>' asText colorizeAllWith:Color red]].
    self mergeHolder value: source.
    self versionMergedLabelAspect changed: #value

    "Created: / 24-11-2009 / 09:48:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 13:01:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: aspect with: param from: sender

    aspect == #resolution ifTrue:[^self resolutionChanged].
    ^super update: aspect with: param from: sender
! !

!MergeViewApp methodsFor:'menu actions'!

mergeMenuInspect

    diff inspect
!

mergeMenuOpen

    (Menu decodeFromLiteralArray: (self menuFor: #mergeMenu)) 
        receiver: self;
        startUp
!

mergeMenuUseExternalTool
    |externalMerge |


    externalMerge := KDiff3 new.
    externalMerge
        labelA:diff versionBaseLabel;
        textA:diff versionBase source;
        labelB:diff versionBLabel;
        textB:diff versionB source;
        labelC:diff versionALabel;
        textC:diff versionA source.
    externalMerge merge.
    externalMerge textMerged ifNotNil:
        [diff  versionMerged:(diff versionAorB copy source:externalMerge textMerged)]
!

mergeMenuUseNone

    diff versionMerged: nil
!

mergeMenuUseVersionA

    diff versionMerged: diff versionA copy
!

mergeMenuUseVersionB

    diff versionMerged: diff versionB copy
!

mergeMenuUseVersionBase

    diff versionMerged: diff versionBase copy
! !

!MergeViewApp methodsFor:'private'!

resolutionListEntryFor: change label: label

    ^LabelAndIcon  new
        model: change;
        string: label

    "Created: / 24-11-2009 / 07:16:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeViewApp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__MergeViewApp.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
