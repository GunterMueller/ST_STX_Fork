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

BrowserList subclass:#BrowserListWithFilter
	instanceVariableNames:'listView filterView filterPatternHolder showFilterHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!BrowserListWithFilter class methodsFor:'documentation'!

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
    Abstract superclass for a browser list with user filter.
    Currently used only ChangeList and ChangeSetDiffList, but
    user filter may be usefull for class/category lists as well.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BrowserListWithFilter class methodsFor:'plugIn spec'!

aspectSelectors

    ^#(
        environmentHolder
        showFilterHolder
    )

    "Created: / 11-02-2012 / 22:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 10:37:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserListWithFilter class methodsFor:'queries'!

isAbstract
    ^ self == Tools::BrowserListWithFilter
! !

!BrowserListWithFilter methodsFor:'accessing'!

filterPattern

    | p |
    p := filterPatternHolder value.
    ^p isEmptyOrNil ifTrue:[
        nil
    ] ifFalse:[
        StringPattern fromString: p
    ]

    "Created: / 29-11-2011 / 15:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showFilter

    ^self showFilterHolder value

    "Created: / 29-11-2011 / 15:27:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserListWithFilter methodsFor:'aspects'!

filterPatternHolder
    "return/create the 'filterPatternHolder' value holder (automatically generated)"

    filterPatternHolder isNil ifTrue:[
        filterPatternHolder := ValueHolder new.
        filterPatternHolder addDependent:self.
    ].
    ^ filterPatternHolder
!

menuHolderWithShowFilter

    ^[
        | menu |
        menu := self menuHolder value copy.
        menu isArray ifTrue:[menu := Menu decodeFromLiteralArray: menu].
        menu addSeparator.
        menu addItem:
            ((MenuItem label:(self resources at: 'Show filter'))
                indication: self showFilterHolder;
                yourself).
        menu
    ]

    "Created: / 29-11-2011 / 15:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showFilterHolder
    "return/create the 'showFilterHolder' value holder (automatically generated)"

    showFilterHolder isNil ifTrue:[
        showFilterHolder := ValueHolder with: false.
        showFilterHolder addDependent:self.
    ].
    ^ showFilterHolder

    "Modified: / 29-11-2011 / 15:43:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showFilterHolder:something
    "set the 'showFilterHolder' value holder (automatically generated)"

    |oldValue newValue|

    showFilterHolder notNil ifTrue:[
        oldValue := showFilterHolder value.
        showFilterHolder removeDependent:self.
    ].
    showFilterHolder := something.
    showFilterHolder notNil ifTrue:[
        showFilterHolder addDependent:self.
    ].
    newValue := showFilterHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showFilterHolder.
    ].
! !

!BrowserListWithFilter methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == showFilterHolder ifTrue:[
        self showFilter: showFilterHolder value.
        ^self.
    ].
    changedObject == filterPatternHolder ifTrue:[
        self enqueueDelayedUpdateList.
        ^self
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 29-11-2011 / 15:51:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-06-2012 / 00:01:37 / cg"
! !

!BrowserListWithFilter methodsFor:'event handling-delegation'!

handlesKeyPress:key inView:aView
    ^ aView == filterView and:[key == #CursorDown]

    "Created: / 06-02-2012 / 23:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view:aView

    (aView == filterView and:[key == #CursorDown]) ifTrue:[
        listView scrolledView notNil ifTrue:[
            listView scrolledView 
                takeFocus;
                keyPress: key x:x y:y.
        ].
    ].

    "Created: / 06-02-2012 / 23:06:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 21:28:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserListWithFilter methodsFor:'hooks'!

commonPostBuild
    super commonPostBuild.
    listView isNil ifTrue:[listView := builder componentAt:#List].
    listView isNil ifTrue:[self breakPoint: #jv].
    filterView isNil ifTrue:[self breakPoint: #jv].

    filterView delegate: self.
    self showFilter: showFilterHolder value.

    "Created: / 29-11-2011 / 14:47:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildFilterView: aView

    filterView := aView

    "Created: / 29-11-2011 / 14:47:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildListView: aView

    listView := aView

    "Created: / 29-11-2011 / 14:47:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserListWithFilter methodsFor:'private'!

filterList: list
    | pattern filteredList |

    self showFilter ifFalse:[ ^ list ].

    pattern := self filterPattern.
    pattern isNil ifTrue:[ ^ list ].    
    filteredList := list value select:[:each|pattern matchObject: each relax: 1].
    filteredList isEmpty ifTrue:[
        filteredList := list value select:[:each|pattern matchObject: each relax: 2].
        filteredList isEmpty ifTrue:[
            filteredList := list value select:[:each|pattern matchObject: each relax: 3].
        ]
    ].
    ^filteredList

    "Created: / 29-11-2011 / 15:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showFilter: aBoolean
    | offset |

    listView isNil ifTrue:[ ^ self ].

    aBoolean ifTrue:[
        offset := filterView height.
    ] ifFalse:[
        offset := 0
    ].
    listView layout: (listView layout copy topOffset: offset) .
    filterView isVisible: aBoolean

    "Created: / 29-11-2011 / 14:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserListWithFilter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__BrowserListWithFilter.st,v 1.9 2015-02-01 14:13:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__BrowserListWithFilter.st,v 1.9 2015-02-01 14:13:31 cg Exp $'
! !

