"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

Object subclass:#NavigationHistory
	instanceVariableNames:'items position isGlobalHistory maxNumberOfItems'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-History'
!

!NavigationHistory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    two variants:
        a forward-backward history, as in a browser:
            navigating backward moves a pointer in a list
        a global history
            navigating moves the navigated item to the front position

    hack: configurable to behave either as a global history
          or as a local-tab navigation history.
    Also implement backward compatible list-style access interface,
    to support old browsers (I guess, this is temporary and the other 
    users of the global history (debugger, old systembrowser etc. should
    be changed)
"
! !

!NavigationHistory class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 21-02-2008 / 15:26:05 / janfrog"
! !

!NavigationHistory methodsFor:'accessing'!

addFirst:anEntry
    "list protocol"

    maxNumberOfItems == 0 ifTrue:[^ self].

    items addFirst:anEntry.
    items size > maxNumberOfItems ifTrue:[
        items removeLast
    ].
    self changed: #value with: anEntry.

    "Created: / 03-07-2011 / 13:26:48 / cg"
!

addLast:anEntry
    "list protocol"

    maxNumberOfItems == 0 ifTrue:[^ self].

    items addLast:anEntry.
    items size > maxNumberOfItems ifTrue:[
        items removeFirst
    ].
    self changed: #value with: anEntry.

    "Created: / 03-07-2011 / 13:26:48 / cg"
!

currentItem

    ^(position between:1 and: items size) 
        ifTrue:[items at: position]
        ifFalse:[nil]

    "Created: / 27-02-2008 / 08:46:37 / janfrog"
!

currentItem: anObject

    self goTo: anObject

    "Created: / 27-02-2008 / 08:47:04 / janfrog"
!

goBackItems
    isGlobalHistory ifTrue:[^ items "isEmpty ifTrue:[items] ifFalse:[items copyFrom:2]"].

    ^ (items copyTo:position - 1) reverse

    "Created: / 27-02-2008 / 11:52:12 / janfrog"
    "Modified: / 05-07-2011 / 16:53:18 / cg"
!

goForwardItems
    isGlobalHistory ifTrue:[^ #()].

    ^ items copyFrom:position + 1

    "Created: / 27-02-2008 / 11:52:26 / janfrog"
    "Modified: / 03-07-2011 / 16:00:45 / cg"
!

maxItemsInHistory:aNumber
    maxNumberOfItems := aNumber max:1.
    maxNumberOfItems > items size ifTrue:[
        items removeFromIndex:maxNumberOfItems+1 toIndex:items size.
        position := maxNumberOfItems.
        self changed.
    ].
! !

!NavigationHistory methodsFor:'backward list compatibility'!

collect:aBlock 
    "backward compatible list protocol"

    ^ items collect:aBlock

    "Created: / 04-07-2011 / 22:45:21 / cg"
!

collect:aBlock thenSelect:filter
    "backward compatible list protocol"

    ^ items collect:aBlock thenSelect:filter

    "Created: / 03-07-2011 / 13:34:14 / cg"
!

detect:aBlock ifNone:exceptionalValue
    "backward compatible list protocol"

    ^ items detect:aBlock ifNone:exceptionalValue

    "Created: / 03-07-2011 / 13:25:37 / cg"
!

do:aBlock
    "backward compatible list protocol"

    ^ items do:aBlock 
!

first
    "backward compatible list protocol"

    ^ items first

    "Created: / 04-07-2011 / 22:45:21 / cg"
!

isEmpty
    "backward compatible list protocol"

    ^ items isEmpty

    "Created: / 04-07-2011 / 22:44:54 / cg"
!

isEmptyOrNil
    "backward compatible list protocol"

    ^ items isEmptyOrNil

    "Created: / 04-07-2011 / 22:44:54 / cg"
!

notEmpty
    "backward compatible list protocol"

    ^ items notEmpty

    "Created: / 04-07-2011 / 22:45:45 / cg"
!

notEmptyOrNil
    "backward compatible list protocol"

    ^ items notEmptyOrNil

    "Created: / 04-07-2011 / 22:45:45 / cg"
!

removeAll
    "backward compatible list protocol"

    items removeAll.

    "Created: / 21-09-2011 / 16:27:38 / cg"
!

removeIdentical:anEntry
    "backward compatible list protocol"

    items removeIdentical:anEntry.
    self changed: #value with:nil.

    "Created: / 03-07-2011 / 13:27:34 / cg"
!

reverseDo:aBlock
    "backward compatible list protocol"

    items reverseDo:aBlock

    "Created: / 04-07-2011 / 22:44:28 / cg"
! !

!NavigationHistory methodsFor:'initialization'!

beGlobalHistory
    isGlobalHistory := true

    "Created: / 03-07-2011 / 14:42:57 / cg"
!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ items := nil.
    "/ position := nil.

    "/ super initialize.   -- commented since inherited method does nothing
    items := OrderedCollection new.
    position := 0.
    isGlobalHistory := false.
    maxNumberOfItems := maxNumberOfItems ? 30.

    "Created: / 21-02-2008 / 15:26:05 / janfrog"
    "Modified: / 03-07-2011 / 14:43:08 / cg"
! !

!NavigationHistory methodsFor:'menu & menu actions'!

clearHistory
    self removeAll.
    position := 0.
    self changed.
!

goBackMenu
    |menu any|

    any := false.
    menu := Menu new.
    self goBackItems do:[:item | 
        menu addItem:(MenuItem label:item displayString itemValue:[ self goTo:item ]).
        any := true.
    ].
    menu addSeparator.
    menu addItem:((MenuItem label:'Clear History' value:[ self clearHistory]) enabled:any).    
    ^ menu

    "Created: / 22-02-2008 / 16:57:46 / janfrog"
    "Modified: / 27-02-2008 / 11:52:12 / janfrog"
!

goForwardMenu
    |menu|

    menu := Menu new.
    self goForwardItems do:[:item | 
        menu addItem:(MenuItem label:item displayString itemValue:[ self goTo:item ])
    ].
    ^ menu

    "Created: / 22-02-2008 / 16:58:11 / janfrog"
    "Modified: / 27-02-2008 / 11:52:26 / janfrog"
! !

!NavigationHistory methodsFor:'navigation'!

goBack
    | value |

    isGlobalHistory ifTrue:[
        items size <= 1 ifTrue:[^ nil].
        ^ self goTo:(items second).
    ].

    position := (position - 1) max: 1.
    self changed: #currentItem with: (value := self currentItem).
    ^value

    "Created: / 21-02-2008 / 16:37:37 / janfrog"
    "Modified: / 27-02-2008 / 08:48:14 / janfrog"
    "Modified: / 03-07-2011 / 16:19:27 / cg"
!

goForward
    | value |

    position := (position + 1) min: items size.
    self changed: #currentItem with: (value := self currentItem).
    ^value

    "Created: / 21-02-2008 / 16:37:37 / janfrog"
    "Modified: / 27-02-2008 / 08:48:24 / janfrog"
!

goTo: navigationHistoryItem
    | idx |

    idx := items lastIndexOf:navigationHistoryItem.
    "/ do not uodate history if we go twice in a row into a same item...
    (idx ~~ 0 and:[ idx == position ]) ifTrue:[ ^ self ].

    isGlobalHistory ifTrue:[
        idx ~~ 0 ifTrue:[
            items removeIndex:idx.
        ].
        self addFirst:navigationHistoryItem.
    ] ifFalse:[
        position < items size ifTrue:[
            items removeFromIndex: position + 1 toIndex: items size
        ].
        items addLast: navigationHistoryItem.
        items size > maxNumberOfItems ifTrue:[
            items removeFirst
        ] ifFalse:[
            position := position + 1
        ].
    ].

    "/ for the canGoXXX apect.
    self changed: #value with: navigationHistoryItem.
    ^ navigationHistoryItem

    "Created: / 21-02-2008 / 16:40:39 / janfrog"
    "Modified: / 21-02-2008 / 19:12:35 / janfrog"
    "Modified: / 03-07-2011 / 16:03:11 / cg"
    "Modified (comment): / 04-09-2015 / 07:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigationHistory methodsFor:'queries'!

canGoBack
    isGlobalHistory ifTrue:[
        ^ items size > 2
    ].

    ^ position > 1

    "Created: / 21-02-2008 / 16:40:48 / janfrog"
!

canGoForward

    ^position < items size

    "Created: / 21-02-2008 / 16:40:48 / janfrog"
! !

!NavigationHistory class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_CVS_jvrany
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

