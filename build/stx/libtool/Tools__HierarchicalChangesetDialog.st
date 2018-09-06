"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

SimpleDialog subclass:#HierarchicalChangesetDialog
	instanceVariableNames:'changeSetHolder selectedChangeSetHolder codeView diffView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

HierarchicalItem subclass:#Change
	instanceVariableNames:'change label removed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalChangesetDialog
!

!HierarchicalChangesetDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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

!HierarchicalChangesetDialog class methodsFor:'interface specs'!

codeViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalChangesetBrowser andSelector:#codeViewSpec
     Tools::HierarchicalChangesetBrowser new openInterface:#codeViewSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: codeViewSpec
        window: 
       (WindowSpec
          label: 'Code Pane'
          name: 'Code Pane'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'CodeView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: codeView
            )
           (NonScrollableArbitraryComponentSpec
              name: 'DiffView'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
            )
           )
         
        )
      )

    "Modified: / 06-11-2008 / 14:52:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

dialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalChangesetBrowser andSelector:#dialogSpec
     Tools::HierarchicalChangesetBrowser new openInterface:#dialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: dialogSpec
        window: 
       (WindowSpec
          label: 'DialogSpec'
          name: 'DialogSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 502 450)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'WindowSpec'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              minorKey: windowSpec
            )
           (ActionButtonSpec
              label: 'Accept'
              name: 'AcceptButton'
              layout: (LayoutFrame 0 0.5 -30 1 0 1 0 1)
              translateLabel: true
              model: doAccept
            )
           (ActionButtonSpec
              label: 'Cancel'
              name: 'CancelButton'
              layout: (LayoutFrame 0 0 -30 1 0 0.5 0 1)
              translateLabel: true
              model: doCancel
            )
           )
         
        )
      )

    "Modified: / 26-11-2008 / 12:15:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalChangesetBrowser andSelector:#windowSpec
     Tools::HierarchicalChangesetBrowser new openInterface:#windowSpec
     Tools::HierarchicalChangesetBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ChangeSet  Browser'
          name: 'ChangeSet  Browser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 601 423)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'VariableVerticalPanel1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (HierarchicalListViewSpec
                    name: 'ChangeTree'
                    model: selectionHolder
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    listModel: changesHolder
                    multipleSelectOk: true
                    useIndex: false
                    highlightMode: line
                    doubleClickSelector: changeListToggleRemoved
                    useDefaultIcons: false
                  )
                 (UISubSpecification
                    name: 'SubSpecification1'
                    minorKey: codeViewSpec
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )

    "Modified: / 06-11-2008 / 17:51:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #changeSetHolder
        #selectedChangeSetHolder
      ).

    "Created: / 02-04-2009 / 18:04:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-04-2009 / 09:46:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog methodsFor:'accessing'!

changeSet

    ^self changeSetHolder value

    "Created: / 02-04-2009 / 23:14:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSet: aChangeSet

    ^self changeSetHolder value: aChangeSet

    "Created: / 02-04-2009 / 23:14:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

refactoryChange: refactoryChange

    self refactoryChanges: (Array with: refactoryChange)

    "Created: / 26-11-2008 / 12:26:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

refactoryChanges: refactoryChanges


    self changesHolder root 
        children:(refactoryChanges collect:[:each|(Tools::HierarchicalChangesetDialog::Change forRefactoryChange: each) parent:self changesHolder root]);
        expand.

    "Created: / 26-11-2008 / 11:32:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectedChange

    | selection |
    selection := self selection.
    ^selection size = 1
        ifTrue:[selection anyOne]
        ifFalse:[nil]

    "Created: / 02-04-2009 / 17:58:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectedChangeSet

    | changeSet |
    changeSet := ChangeSet new.
    self changesHolder do:
        [:each|(each change notNil and:[each isRemoved not]) 
                    ifTrue:[changeSet add: each change]].
    ^changeSet

    "Created: / 02-04-2009 / 17:58:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selection

    ^self selectionHolder value

    "Created: / 06-11-2008 / 15:02:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog methodsFor:'actions'!

changeListToggleRemoved
    self selection do:[:each | 
        each removed:each isRemoved not
    ].
    self updateSelectedChangeSet

    "Created: / 06-11-2008 / 17:44:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-04-2009 / 09:47:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

updateSelectedChangeSet
    selectedChangeSetHolder 
        ifNotNil:[ selectedChangeSetHolder value:self selectedChangeSet ]
! !

!HierarchicalChangesetDialog methodsFor:'aspects'!

changeSetHolder

    changeSetHolder isNil ifTrue:[
        self changeSetHolder: ChangeSet new asValue.
    ].
    ^ changeSetHolder

    "Modified: / 02-04-2009 / 18:01:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changeSetHolder:aValueHolder

    changeSetHolder := aValueHolder.
    changeSetHolder onChangeSend: #updateChangeSet to: self.
    self updateChangeSet

    "Modified: / 02-04-2009 / 23:14:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changesHolder

    |list|

    self createBuilder.
    (list := builder bindingAt:#changesHolder) isNil ifTrue:[
        list := HierarchicalList new
                    application: self;
                    root: (HierarchicalChangesetDialog::Change new label:'Whole changeset');
                    showRoot: false.
        list root expand.
        builder aspectAt:#changesHolder put:list.
    ].
    ^ list.

    "Created: / 05-11-2008 / 08:43:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 12:12:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

codeView

    codeView isNil ifTrue:[
        codeView := HVScrollableView for: CodeView
    ].
    ^codeView

    "Created: / 06-11-2008 / 14:52:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:32 / cg"
!

diffView

    diffView isNil ifTrue:[
        diffView := HVScrollableView for: DiffTextView
    ].
    ^diffView

    "Created: / 06-11-2008 / 15:01:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:41 / cg"
!

selectedChangeSetHolder
    "return/create the 'selectedChangeSetHolder' value holder (automatically generated)"

    ^ selectedChangeSetHolder

    "Modified: / 03-04-2009 / 09:47:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectedChangeSetHolder:aValueHolder
    "set the 'selectedChangeSetHolder' value holder (automatically generated)"

    selectedChangeSetHolder := aValueHolder.
    self updateSelectedChangeSet

    "Modified: / 06-04-2009 / 17:43:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionHolder

    |holder|

    (holder := builder bindingAt:#selectionHolder) isNil ifTrue:[
        holder := #() asValue.
        holder onChangeSend: #updateCode to: self.
        builder aspectAt:#selectionHolder put:holder.
    ].
    ^ holder.

    "Created: / 05-11-2008 / 08:40:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 15:04:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog methodsFor:'change & update'!

updateChangeSet

    | condensedChangeset classNames classChanges otherChanges |
    condensedChangeset := self changeSet" copy condenseChanges".
    classNames := (condensedChangeset 
                    select:[:each|each isClassChange]
                    thenCollect:[:each|each nonMetaClassName]) asSet asSortedCollection.
    classChanges := classNames collect:
        [:className|
        | classChange |
        classChange := Change new label: className asText allBold.
        classChange children:
            (condensedChangeset 
                select:[:each|each isClassChange and:[each nonMetaClassName = className]]
                thenCollect:[:each|Change forChange: each]).
        classChange expand].
    otherChanges := condensedChangeset
                    select:[:each|each isClassChange not]
                    thenCollect:[:each|Change forChange: each].
    self changesHolder root 
        children:(classChanges asOrderedCollection) , (otherChanges asOrderedCollection);
        expand.
    self updateSelectedChangeSet

    "Created: / 02-04-2009 / 17:56:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 17:43:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

updateCode
    | change scrolledCodeView |

    change := self selectedChange.
    change isNil ifTrue:[^self].
    (scrolledCodeView := self codeView scrolledView) isNil ifTrue:[^self].
    scrolledCodeView
        contents: change source;
        raise.

    "Created: / 06-11-2008 / 15:01:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 17:59:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:59:31 / cg"
! !

!HierarchicalChangesetDialog methodsFor:'hooks'!

commonPostOpen

    self codeView raise

    "Created: / 06-11-2008 / 08:23:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 17:11:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libtool/Tools__HierarchicalChangesetDialog.st,v 1.5 2014-05-23 08:30:33 stefan Exp $'
! !

!HierarchicalChangesetDialog::Change class methodsFor:'image specs'!

checkedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self checkedIcon inspect
     ImageEditor openOnClass:self andSelector:#checkedIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkedIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?07?C?<O?0??@@@@@@b');
                colorMapFromArray:#[ 0 0 0 33 161 33 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
?????<@C0@O@D<@30GOH8<7C38OG@<HC0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 06-11-2008 / 16:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

uncheckedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self checkFrameForm inspect
     ImageEditor openOnClass:self andSelector:#checkFrameForm
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkFrameForm'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
?????<@C0@O@@<@C0@O@@<@C0@O@@<@C0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 06-11-2008 / 16:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change class methodsFor:'instance creation'!

forChange: aChange

    ^self new change: aChange

    "Created: / 26-11-2008 / 11:31:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

forRefactoryChange: aChange

    ^self new refactoryChange: aChange

    "Created: / 26-11-2008 / 11:33:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change methodsFor:'accessing'!

change
    ^ change

    "Created: / 05-11-2008 / 22:57:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

change:something
    change := something.

    "Created: / 05-11-2008 / 22:57:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

children: aCollection

    aCollection do:[:each|each parent: self].
    super children: aCollection

    "Created: / 06-11-2008 / 16:57:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

icon

    ^self isRemoved
       ifTrue:[self class uncheckedIcon]
       ifFalse:[self class checkedIcon]

    "Created: / 06-11-2008 / 16:30:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

label

    label isNil ifTrue:[
        label := change
                    ifNil:['Composite change']
                    ifNotNil:[change printString"displayStringForBrowser: self application"]
    ].
    ^label

    "Created: / 05-11-2008 / 08:20:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-11-2008 / 08:25:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:59:53 / cg"
!

label:something
    label := something.

    "Created: / 06-11-2008 / 17:11:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

refactoryChange:refactoryChange

    refactoryChange isCompositeRefactoryChange
        ifTrue:
            [label := refactoryChange name.
            self children: (refactoryChange changes 
                                collect:[:each|(Tools::HierarchicalChangesetDialog::Change forRefactoryChange: each)
                                                    parent: self]).
            self expand]
        ifFalse:
            [change := refactoryChange]

    "Created: / 26-11-2008 / 11:32:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

removed:aBoolean
    self setRemoved: aBoolean.
    self children do:[:each|each removed: aBoolean].
    self parent ifNotNil:
        [self parent updateRemoved].

    "Created: / 05-11-2008 / 08:21:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 17:50:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

source

    ^change         
        ifNotNil:[change source]
        ifNil:['']

    "Created: / 06-11-2008 / 15:03:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 16:31:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change methodsFor:'change & update'!

updateRemoved

    change ifNotNil:[^self].
    self setRemoved: (children conform:[:each| each isRemoved])

    "Created: / 06-11-2008 / 17:36:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change methodsFor:'private'!

setRemoved: aBoolean

    removed ~~ aBoolean ifTrue:
        [removed := aBoolean.
        self changed: #removed]

    "Created: / 06-11-2008 / 17:49:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangesetDialog::Change methodsFor:'testing'!

isCompositeChange

    ^self isLeafChange not

    "Created: / 06-11-2008 / 17:31:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isLeafChange

    ^change notNil

    "Created: / 06-11-2008 / 17:31:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isRemoved

    removed isNil ifTrue:[removed := false].
    ^removed

    "Created: / 05-11-2008 / 08:21:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:59:39 / cg"
! !

!HierarchicalChangesetDialog class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalChangesetDialog.st,v 1.5 2014-05-23 08:30:33 stefan Exp $'
!

version_SVN
    ^ '$Id: Tools__HierarchicalChangesetDialog.st,v 1.5 2014-05-23 08:30:33 stefan Exp $'
! !

