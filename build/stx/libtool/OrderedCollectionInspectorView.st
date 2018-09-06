"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

InspectorView subclass:#OrderedCollectionInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!OrderedCollectionInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a modified Inspector for orderedCollections

    [author:]
        Claus Gittinger
"

! !

!OrderedCollectionInspectorView methodsFor:'menu'!

fieldMenu
    "return the menu for the field-list"

    <resource: #programMenu>

    |items m sel|

    items := #(
                  ('Inspect'                     doInspect              )
                  ('BasicInspect'                doBasicInspect         )
             ).
    NewInspector::NewInspectorView notNil ifTrue:[
        items := items , #(
                  ('Inspect Hierarchical'         #doNewInspect           )
             ).
    ].
    items := items , #(
                  ('-')
                  ('Owners'                      showOwners             )
                  ('Ref Chains'                  showReferences         )
                  ('-')
                  ('Browse'                      browse                 )
"/                      ('Browse class hierarchy'      browseClassHierarchy   )
"/                      ('Browse full class protocol'  browseFullClassProtocol)
               ).

    sel := self selection.
    (sel isBlock or:[sel isContext]) ifTrue:[
        items := items , #(
                       ('Browse Blocks Home'           #browseHome)
              ).
    ].

    items := items , #(
                  ('-')
                  ('Remove'                      removeIndex            )
               ).

    (hasMore) ifTrue:[
        items := items , #(                                  
                      ('-')
                      ('Show More'                   showMore               )
                   ).
        (self numIndexedFields > (nShown * 2)) ifTrue:[
            items := items , #(
                        ('Show All'                     #showAll                )
                          )
        ].
    ].

    monitorProcess isNil ifTrue:[
        items := items , #( ('-') ('Start Monitor' doStartMonitor)).
    ] ifFalse:[
        items := items , #( ('-') ('Stop Monitor' doStopMonitor)).
    ].
    items := items , (self numberBaseItems).

    m := PopUpMenu
          itemList:items
          resources:resources.

    selectionIndex isNil ifTrue:[
        m disableAll:#(doInspect doBasicInspect 
                       browse browseClassHierarchy browseFullClassProtocol
                       doStartMonitor removeIndex)
    ] ifFalse:[
        (self keyIndexForLine:selectionIndex) isNil ifTrue:[
            m disable:#removeIndex
        ].
    ].

    ^ m

    "Modified: / 06-08-2012 / 09:01:56 / cg"
! !

!OrderedCollectionInspectorView methodsFor:'private'!

baseInspectedObjectClass
    ^ OrderedCollection
!

defaultLabel
    ^ 'Contents'

    "
     (OrderedCollection with:1 with:2 with:3) inspect
    "

    "Modified: 28.6.1996 / 16:06:24 / cg"
!

indexList 
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    |n|

    n := self numIndexedFields.
    (n > nShown) ifTrue:[
        n := nShown.
        hasMore := true.
    ].

    ^ (1 to:n)

    "Modified: / 13-06-2012 / 10:14:06 / cg"
!

numIndexedFields
    ^ inspectedObject size

    "Created: / 13-06-2012 / 10:13:16 / cg"
! !

!OrderedCollectionInspectorView methodsFor:'user interaction'!

indexedValueAtIndex:idx
    ^ inspectedObject at:idx ifAbsent:nil.

!

indexedValueAtIndex:idx put:newValue
    inspectedObject at:idx put:newValue.
!

removeIndex
    "remove selected item from the collection"

    |idx|

    idx := self keyIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        inspectedObject removeIndex:idx.
        selectionIndex := selectedLine := nil.
        inspectedObject changed.
        self reinspect.
    ]
! !

!OrderedCollectionInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: OrderedCollectionInspectorView.st 8048 2012-09-07 17:28:09Z vranyj1 $'
! !

