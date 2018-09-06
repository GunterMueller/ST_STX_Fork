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

SmalltalkDiffTool subclass:#SmalltalkMergeTool
	instanceVariableNames:'resolvedHolder changeSetHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff & Merge tool'
!

SmalltalkDiffTool::DiffItem subclass:#DiffItem
	instanceVariableNames:'versionMerged state'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkMergeTool
!

!SmalltalkMergeTool class methodsFor:'documentation'!

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
    MergeTool open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
!

history
    "Created: / 06-12-2007 / 11:00:54 / janfrog"
! !

!SmalltalkMergeTool class methodsFor:'initialization'!

initialize
    "self initialize"

    |menuItem|

    menuItem := (MenuItem label:'Merge tool') 
                    nameKey:'MergeTool';
                    value:[SmalltalkMergeTool open];
                    isButton:false.


    NewLauncher
        addMenuItem:menuItem
        from:self
        in:'menu.tools.programming'
        position:#(before startSmaCCParserGenerator)
        space:false.

    "Created: / 11-12-2007 / 19:12:08 / janfrog"
    "Modified: / 09-08-2009 / 14:15:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 03-07-2011 / 22:30:30 / cg"
! !

!SmalltalkMergeTool class methodsFor:'interface specs'!

conflictsListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MergeTool andSelector:#conflictsListSpec
     MergeTool new openInterface:#conflictsListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: conflictsListSpec
        window: 
       (WindowSpec
          label: 'VersionBothListSpec'
          name: 'VersionBothListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Conflicts (present in both A and B)'
              name: 'VersionBothLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: conflictsLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionBothList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              menu: resolveMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: conflictsListHolder
              multipleSelectOk: true
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )

    "Modified: / 11-12-2007 / 16:46:23 / janfrog"
    "Created: / 19-04-2008 / 12:58:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inAOnlyListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MergeTool andSelector:#inAOnlyListSpec
     MergeTool new openInterface:#inAOnlyListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: inAOnlyListSpec
        window: 
       (WindowSpec
          label: 'VersionAOnlyListSpec'
          name: 'VersionAOnlyListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'In A only'
              name: 'VersionAOnlyLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: inAOnlyLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionAOnlyList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              menu: resolveMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: inAOnlyListHolder
              multipleSelectOk: true
              useIndex: false
              highlightMode: line
              postBuildCallback: postBuildVersionAListWidget:
            )
           )
         
        )
      )

    "Modified: / 11-12-2007 / 16:46:29 / janfrog"
    "Created: / 19-04-2008 / 12:58:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inBOnlyListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MergeTool andSelector:#inBOnlyListSpec
     MergeTool new openInterface:#inBOnlyListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: inBOnlyListSpec
        window: 
       (WindowSpec
          label: 'VersionBOnlyListSpec'
          name: 'VersionBOnlyListSpec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 306 406)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'In B only'
              name: 'VersionBOnlyLabel'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              labelChannel: inBOnlyLabelHolder
            )
           (SelectionInListModelViewSpec
              name: 'VersionBOnlyList'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              model: selectionHolder
              menu: resolveMenu
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: inBOnlyListHolder
              multipleSelectOk: true
              postBuildCallback: postBuildVersionBListWidget:
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )

    "Modified: / 11-12-2007 / 16:46:33 / janfrog"
    "Created: / 19-04-2008 / 12:58:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::MergeTool andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::MergeTool mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Open file'
                  itemValue: fileMenuMergeFileIntoImage
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Apply resolved'
                  itemValue: fileMenuApplyResolved
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Resolve'
            translateLabel: true
            submenuChannel: resolveMenu
          )
         (MenuItem
            label: 'Help'
            translateLabel: true
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'About this Application...'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )

    "Modified: / 08-11-2008 / 11:09:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolveMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::MergeTool andSelector:#resolveMenu
     (Menu new fromLiteralArrayEncoding:(Tools::MergeTool resolveMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: selectionIsNonEmptyAndAllHasVersionA
            label: 'Resolve using version A <-'
            itemValue: resolveMenuResolveUsingA
            translateLabel: true
          )
         (MenuItem
            enabled: selectionIsNonEmptyAndAllHasVersionB
            label: 'Resolve using version B ->'
            itemValue: resolveMenuResolveUsingB
            translateLabel: true
          )
         (MenuItem
            enabled: selectionIsNonEmpty
            label: 'Delete'
            itemValue: resolveMenuDelete
            translateLabel: true
          )
         (MenuItem
            enabled: selectionIsNonEmpty
            label: 'Unresolve'
            itemValue: resolveMenuUnresolve
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: false
            label: 'Show changeset'
            translateLabel: true
            indication: showMergingChangeSetHolder
          )
         )
        nil
        nil
      )

    "Modified: / 08-11-2008 / 11:06:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool class methodsFor:'plugIn spec'!

aspectSelectors

    ^super aspectSelectors,
    #(

        #resolvedHolder
        #changeSetHolder
      ).

    "Created: / 02-04-2009 / 22:04:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 09:21:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool methodsFor:'accessing'!

diffItemClass

    ^SmalltalkMergeTool::DiffItem

    "Created: / 21-05-2008 / 14:39:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-08-2009 / 14:57:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool methodsFor:'aspects'!

changeSetHolder
    "return/create the 'changeSetHolder' value holder (automatically generated)"

    changeSetHolder isNil ifTrue:[
        changeSetHolder := ValueHolder new.
    ].
    ^ changeSetHolder
!

changeSetHolder:aValueHolder
    "set the 'changeSetHolder' value holder (automatically generated)"

    changeSetHolder := aValueHolder.
!

resolvedHolder

    resolvedHolder ifNil:
        [resolvedHolder := false asValue].
    ^resolvedHolder

    "Created: / 02-04-2009 / 21:53:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionHolder

    selectionHolder ifNil:
        [selectionHolder := List new asValue.
        selectionHolder 
            onChangeSend:#selectionChanged to: self].
    ^selectionHolder

    "Created: / 21-05-2008 / 19:30:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool methodsFor:'change & update'!

resolutionChanged

    super resolutionChanged.
    self resolvedHolder value: self resolved.
    self changeSetHolder value: self changeSet.

    "Created: / 22-10-2008 / 10:50:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 22:04:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool methodsFor:'menu actions'!

fileMenuApplyResolved
    (Dialog confirm:'Really apply resolved?') ifFalse:[
        ^ self
    ].
    self inAOnlyListHolder 
        value:(self inAOnlyListHolder value reject:[:e | e isResolved ]).
    self conflictsListHolder 
        value:(self conflictsListHolder value reject:[:e | e isResolved ]).
    self inBOnlyListHolder 
        value:(self inBOnlyListHolder value reject:[:e | e isResolved ]).
    self fileMenuApplyResolved:self changeSetToApply

    "Modified: / 12-12-2007 / 08:37:21 / janfrog"
    "Created: / 08-11-2008 / 11:08:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileMenuApplyResolved:aChangeSet 
    (Class updateChangeFileQuerySignal , Class updateChangeListQuerySignal) 
        answer:false
        do:[ aChangeSet apply ]

    "Modified: / 12-12-2007 / 08:36:04 / janfrog"
    "Created: / 08-11-2008 / 11:08:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileMenuMergeFileIntoImage

    |filename|

    filename := Dialog requestFileName:'Enter fileout or change file' pattern:'*.st;*.cha'.
    filename isNilOrEmptyCollection ifTrue:[^self].
    filename := filename asFilename.
    filename isRegularFile ifFalse:[^Dialog warn:'Selected file is not a regular file'].
    filename isReadable ifFalse:[^Dialog warn:'Selected file is not readable'].

    [
        self 
            diffSet: (ChangeSet fromFile: filename) diffSetsAgainstImage            labelA: filename components last
            labelB: 'image'
    ] on: Error do:[:ex|
        Dialog warn: 'Error when reading changeset: ', ex description.
        ex pass
    ]

    "Created: / 11-12-2007 / 16:59:04 / janfrog"
    "Modified: / 12-12-2007 / 15:12:01 / janfrog"
!

resolveMenuDelete

    self selection do:
        [:mergeItem|mergeItem delete].
    self resolutionChanged

    "Modified: / 11-12-2007 / 16:54:51 / janfrog"
!

resolveMenuResolveUsingA

    self selection do:
        [:mergeItem|mergeItem resolveUsingA].
    self resolutionChanged

    "Modified: / 11-12-2007 / 16:54:56 / janfrog"
!

resolveMenuResolveUsingB

    self selection do:
        [:mergeItem|mergeItem resolveUsingB].
    self resolutionChanged

    "Modified: / 11-12-2007 / 16:55:01 / janfrog"
!

resolveMenuUnresolve

    self selection do:
        [:mergeItem|mergeItem unresolve].
    self resolutionChanged

    "Modified: / 11-12-2007 / 16:55:05 / janfrog"
! !

!SmalltalkMergeTool methodsFor:'private'!

changeSet

    ^ChangeSet withAll:
        ((self inAOnlyListHolder value , self conflictsListHolder value, self inBOnlyListHolder value)
            select:[:e|e isResolved] thenCollect:[:e|e versionMerged])

    "Created: / 02-04-2009 / 22:03:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolved
    ^ (self inAOnlyListHolder value allSatisfy:[:e | e isResolved ]) 
        and:[
            (self conflictsListHolder value allSatisfy:[:e | e isResolved ]) 
                and:[ (self inBOnlyListHolder value allSatisfy:[:e | e isResolved ]) ]
        ]

    "Created: / 21-10-2008 / 09:51:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libtool/Tools__SmalltalkMergeTool.st,v 1.3 2014-02-05 18:58:07 cg Exp $'
! !

!SmalltalkMergeTool::DiffItem class methodsFor:'image specs'!

resolvedAsRemoveIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self resolvedAsRemoveIcon inspect
     ImageEditor openOnClass:self andSelector:#resolvedAsRemoveIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::MergeTool::DiffItem class resolvedAsRemoveIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@T@AP@EPAT@@UAT@@AUT@@@ET@@@AU@@@AUT@@ATEP@AT@U@@T@AP@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 0 0 170 170 170 255 255 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
?????<@C6A/\N<931>OC0<OC1>ON\=0;6A/@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]

    "Created: / 08-11-2008 / 10:58:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolvedAsVersionAIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self resolvedUsingVersionAIcon inspect
     ImageEditor openOnClass:self andSelector:#resolvedUsingVersionAIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'Tools::MergeTool::DiffItem class resolvedUsingVersionAIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:((1));
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@EUUUPAUPUT@UTEU@ET@UPAU@ET@UAPU@EPTEPAPUPT@T@@E@D@@@PAAUTD@UUUU@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 191 255 191 30 255 30 255 255 255 ];
                mask:((Depth1Image new)
                            width:16;
                            height:16;
                            photometric:(#blackIs0);
                            bitsPerSample:(#[ 1 ]);
                            samplesPerPixel:((1));
                            bits:(ByteArray 
                                        fromPackedString:'
??????????????????????????????????????????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 08-11-2008 / 10:59:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolvedAsVersionBIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self resolvedUsingVersionBIcon inspect
     ImageEditor openOnClass:self andSelector:#resolvedUsingVersionBIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'Tools::MergeTool::DiffItem class resolvedUsingVersionBIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:((1));
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@EUUUPAT@ET@UAPU@EPTEPATEAT@U@AU@EP@UPATEAT@UAPU@EPTEPAT@ET@UUUU@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 191 191 30 255 30 255 255 255 ];
                mask:((Depth1Image new)
                            width:16;
                            height:16;
                            photometric:(#blackIs0);
                            bitsPerSample:(#[ 1 ]);
                            samplesPerPixel:((1));
                            bits:(ByteArray 
                                        fromPackedString:'
??????????????????????????????????????????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 08-11-2008 / 10:59:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

unresolvedIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self unresolvedIcon inspect
     ImageEditor openOnClass:self andSelector:#unresolvedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::MergeTool::DiffItem class unresolvedIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[2]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 84 84 84 170 170 170 255 255 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
?????<@C0@O@@<@C0@O@@<@C0@O@@<@C0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]

    "Created: / 08-11-2008 / 10:41:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem class methodsFor:'instance creation'!

versionA: changeA

    ^self new 
        versionA: changeA;
        versionMerged: changeA;
        state: #merged

    "Created: / 21-05-2008 / 14:14:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionB: changeB

    ^self new 
        versionB: changeB;
        versionMerged: changeB;
        state: #merged

    "Created: / 21-05-2008 / 14:14:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem methodsFor:'accessing'!

icon

    state = #unresolved ifTrue:[^self class unresolvedIcon].
    state = #deleted ifTrue:[^self class resolvedAsRemoveIcon].

    versionMerged = versionA ifTrue:[^self class resolvedAsVersionAIcon].
    versionMerged = versionB ifTrue:[^self class resolvedAsVersionBIcon].

    ^self class unresolvedIcon

    "Created: / 08-11-2008 / 10:59:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

state
    ^ state ? #unresolved

    "Modified: / 06-12-2007 / 20:55:20 / janfrog"
    "Created: / 21-05-2008 / 11:52:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

state:aSymbol

    self 
        assert:(#(unresolved deleted merged) includes: aSymbol).        
    state := aSymbol.

    "Created: / 21-05-2008 / 11:52:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

version
    ^ versionMerged ? versionA ? versionB

    "Created: / 21-05-2008 / 11:52:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionMerged
    ^ versionMerged

    "Created: / 21-05-2008 / 11:52:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionMerged:aChange
    versionMerged := aChange.

    "Created: / 21-05-2008 / 11:52:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-05-2008 / 13:42:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

versionMergedSource
    ^ versionMerged
        ifNil:[nil]
        ifNotNil:[versionMerged source]

    "Created: / 21-05-2008 / 11:52:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem methodsFor:'displaying'!

displayIconOn:aGC x:x y:y 

    self icon
            displayOn:aGC
            x:x
            y:y - 14

    "Created: / 21-05-2008 / 11:54:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-11-2008 / 11:03:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

displayOn: aGC x:x y:y

    self displayIconOn: aGC x:x y:y.
    self displayChangeOn: aGC x:x + 18 y:y.

    "Created: / 21-05-2008 / 11:55:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem methodsFor:'resolution'!

apply

    ^self versionMerged apply

    "Modified: / 11-12-2007 / 18:58:37 / janfrog"
    "Created: / 21-05-2008 / 11:53:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

delete

    self state: #deleted.
    self isMethodChange ifTrue:
        [versionMerged := MethodRemoveChange 
                            class: self version changeClass
                            selector: self version changeSelector]

    "Modified: / 11-12-2007 / 18:41:49 / janfrog"
    "Created: / 21-05-2008 / 11:53:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolveUsingA

    self state: #merged.
    versionMerged := versionA

    "Created: / 21-05-2008 / 11:53:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resolveUsingB

    self state: #merged.
    versionMerged := versionB

    "Created: / 21-05-2008 / 11:53:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

unresolve

    self state: #unresolved

    "Created: / 21-05-2008 / 11:53:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool::DiffItem methodsFor:'testing'!

isMergedVersionDifferent

    ^versionMerged notNil 
        and:[versionMerged ~= versionA
            and:[versionMerged ~= versionB]]

    "Created: / 21-05-2008 / 11:53:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isResolved

    ^self state ~= #unresolved

    "Created: / 21-05-2008 / 11:53:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SmalltalkMergeTool class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__SmalltalkMergeTool.st,v 1.3 2014-02-05 18:58:07 cg Exp $'
!

version_SVN
    ^ '$Id: Tools__SmalltalkMergeTool.st,v 1.3 2014-02-05 18:58:07 cg Exp $'
! !


SmalltalkMergeTool initialize!
