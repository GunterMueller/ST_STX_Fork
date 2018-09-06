"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

View subclass:#PullDownMenu
	instanceVariableNames:'receiver menus titles selectors activeMenuNumber
		showSeparatingLines topMargin fgColor bgColor activeFgColor
		activeBgColor onLevel offLevel edgeStyle toggleMode toggleKeep
		raiseTopWhenActivated actions'
	classVariableNames:'DefaultViewBackground DefaultForegroundColor
		DefaultBackgroundColor DefaultHilightForegroundColor
		DefaultHilightBackgroundColor DefaultLevel DefaultHilightLevel
		DefaultShadowColor DefaultLightColor DefaultEdgeStyle
		DefaultToggleMode DefaultKeepMenu DefaultToggleKeep
		DefaultSeparatingLines'
	poolDictionaries:''
	category:'Views-Menus'
!

!PullDownMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Notice: this class is obsolete now 
    - please use a MenuPanel in new applications, 
    which provides all of this functionality, plus more and a nicer look.

    PullDown menu provides the top (always visible) part of these menus. 
    It controls display of its menus, which become visible when one of the 
    PullDownMenus entries is pressed.

    A PullDownMenu itself consists of a single row of labels, which activate
    a pulled menu when clicked. Entries may be empty (i.e. have no menu)
    and empty entries may (optionally) also perform some action when clicked.
    An entries selector is used as the key to define and access submenus
    and (for empty entries:) the selector sent to the receiver of the menu.

    [Instance variables:]

      menus                   <Collection>    the sub menus

      titles                  <Collection>    the strings in the menu

      selectors               <Collection>    the selectors to send to the menu-
                                              receiver (for empty pull-menus)
                                              if nil (the default), title entries
                                              do not send anything.

      activeMenuNumber        <Number>        the index of the currently active menu

      showSeparatingLines     <Boolean>       show separating lines between my menu-strings

      topMargin               <Number>        number of pixels at top

      fgColor                 <Color>         fg color to draw passive menu-titles
      bgColor                 <Color>         bg color to draw passive menu-titles

      activeFgColor           <Color>         fg color to draw activated menu-titles
      activeBgColor           <Color>         bg color to draw activated menu-titles

      onLevel                 <Integer>       3D level of entry-buttons when pressed
      offLevel                <Integer>       3D level of entry-buttons when released

      edgeStyle               <Symbol>        how to draw edges

      toggleMode              <Symbol>        if #toggle, press pulls menu,
                                              another press hides it.
                                              if other, its hidden on release.

     except menus, titles and selectors, instvars are usually defined from
     defaults in the styleSheet; you should not care for them.


    [StyleSheet values:]

      pullDownMenuViewBackground              view background Color for the menu bar
                                              default: menuViewBackground

      pullDownMenuForegroundColor             foreground drawing color for the menu bar
                                              default: menuForegroundColor

      pullDownMenuBackgroundColor             background drawing color for the menu bar
                                              default: menuBackgroundColor

      pullDownMenuHilightForegroundColor      active foreground drawing color for the menu bar
                                              default: menuHilightForegroundColor

      pullDownMenuHilightBackgroundColor      active background drawing color for the menu bar
                                              default: menuHilightBackgroundColor

      pullDownMenuHilightLevel                level (3D only) when active
                                              default: menuHilightLevel

      pullDownMenuEdgeStyle                   edge style (nil or #soft)

      pullDownMenuKeepMenu                    if true, pulled menu stays open until button
                                              is pressed again outside of the item-area (motif behavior)
                                              if false, menu closes on release (default)

      pullDownMenuToggleKeep                  if true, pulled menu closes when an entry is pressed
                                              again. Otherwise, only press outside of the items area
                                              hides it. default is false

      pullDownMenuLevel                       level (3D only)

      pullDownMenuFont                        font to use for the menu bar
                                              default: menuFont

      pullDownMenuShowSeparatingLines         if true, lines are drawn between items.
                                              default: false

      pullDownMenuRaiseTop                    if true, topview is raised whenever an entry
                                              is activated.
                                              default: true

    [author:]
        Claus Gittinger
"
!

examples 
"
  with default level (from styleSheets 'pullDownMenuLevel' setting):
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu origin:0.0@0.0 corner:1.0@30 in:top.
	menu labels:#('foo' 'bar').
	menu selectors:#(foo bar).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	menu at:#bar 
	     putLabels:#('bar1' 'bar2' 'bar3')
	     selectors:#(bar1 bar2 bar3)
	     receiver:nil.
	top open
									[exEnd]

  with a defined level:
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu origin:0.0@0.0 corner:1.0@30 in:top.
	menu level:1.
	menu labels:#('foo' 'bar').
	menu selectors:#(foo bar).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	menu at:#bar 
	     putLabels:#('bar1' 'bar2' 'bar3')
	     selectors:#(bar1 bar2 bar3)
	     receiver:nil.
	top open
									[exEnd]


    empty entries are possible as selectable items (with non-nil seletor) ...
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu origin:0.0@0.0 corner:1.0@30 in:top.
	menu labels:#('foo' 'bar' 'baz').
	menu selectors:#(foo bar baz).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	menu at:#baz 
	     putLabels:#('baz1' 'baz2' 'baz3')
	     selectors:#(baz1 baz2 baz3)
	     receiver:nil.
	top open
									[exEnd]


    ... or as separators (with nil selector)
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	top extent:500@200.

	menu := PullDownMenu origin:0.0@0.0 corner:1.0@30 in:top.
	menu labels:#('foo' '    ' 'bar' ' baz' '    ' 'moreFoo' 'moreBar' 'moreBaz').
	menu selectors:#(foo nil bar baz nil moreFoo moreBar moreBaz).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	menu at:#bar 
	     putLabels:#('bar1' 'bar2' 'bar3')
	     selectors:#(bar1 bar2 bar3)
	     receiver:nil.
	menu at:#baz 
	     putLabels:#('baz1' 'baz2' 'baz3')
	     selectors:#(baz1 baz2 baz3)
	     receiver:nil.
	top open
									[exEnd]



    use the menus default height
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu in:top.
	menu origin:0.0@0.0 corner:1.0@(menu height).
	menu labels:#('foo' 'bar').
	menu selectors:#(foo bar).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	top open
									[exEnd]



    although you can change the font, colors etc. (as shown below)
    you should NOT do it - since if you do so, the styleSheet settings
    are ineffective (which users probably won't like)
    BTW: The styleSheet entries for below are pullDownMenuForegroundColor,
	 pullDownMenuBackgroundColor and pullDownMenuFont
									[exBegin]
	|top menu|

	top := StandardSystemView new.
	menu := PullDownMenu in:top.
	menu font:(Font family:'courier' size:20).
	menu foregroundColor:Color red.
	menu backgroundColor:Color yellow.
	menu viewBackground:Color green.
	menu showSeparatingLines:true.

	menu origin:0.0@0.0 corner:1.0@(menu height).
	menu labels:#('foo' 'bar').
	menu selectors:#(foo bar).
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	(menu menuAt:#foo) font:(Font family:'courier' size:36).
	top open
									[exEnd]


    you can use icons, too ...
									[exBegin]
	|labels top menu|

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu in:top.
	menu origin:0.0@0.0 corner:1.0@(menu height).
	labels := Array with:((Image fromFile:'SmalltalkX.xbm') magnifiedTo:16@16)
			with:'foo'
			with:'bar'.
	menu labels:labels.
	menu selectors:#(about foo bar).
	menu at:#about 
	     putLabels:#('about PullDownMenus')
	     selectors:#(aboutMenus)
	     receiver:nil.
	menu at:#foo
	     putLabels:#('foo1' 'foo2' 'foo3')
	     selectors:#(foo1 foo2 foo3)
	     receiver:nil.
	top open
									[exEnd]


    a concrete example (combining things described above)
    (using a Plug, since we have no application class here):
									[exBegin]
	|labels top menu textView appModel|

	appModel := Plug new.
	appModel respondTo:#quit with:[top destroy].
	appModel respondTo:#showAbout with:[self information:'some info here ...'].
	appModel respondTo:#help with:[self information:'some help here ...'].

	top := StandardSystemView new.
	top extent:300@300.

	menu := PullDownMenu in:top.
	menu receiver:appModel.
	menu origin:0.0@0.0 corner:1.0@(menu height).

	textView := ScrollableView forView:(EditTextView new).
	textView origin:0.0@menu height corner:1.0@1.0.
	top addSubView:textView.

	labels := Array with:((Image fromFile:'SmalltalkX.xbm') magnifiedTo:16@16)
			with:'file'
			with:'edit'
			with:'help'.
	menu labels:labels.
	menu selectors:#(about file edit help).
	menu at:#about 
	     putLabels:#('about PullDownMenus')
	     selectors:#(showAbout)
	     receiver:appModel.
	menu at:#file 
	     putLabels:#('quit')
	     selectors:#(quit)
	     receiver:appModel.
	menu at:#edit 
	     putLabels:#('copy' 'cut' 'paste')
	     selectors:#(copySelection cut paste)
	     receiver:textView.
	top open
									[exEnd]
"

! !

!PullDownMenu class methodsFor:'instance creation'!

labels:titleArray
    "create and return a new PullDownMenu"

    ^ self new labels:titleArray
! !

!PullDownMenu class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'pullDownMenu.viewBackground' #'menuView.background'
                       #'pullDownMenu.foregroundColor' #'menu.foregroundColor'
                       #'pullDownMenu.backgroundColor' #'menu.backgroundColor'
                       #'pullDownMenu.hilightForegroundColor' #'menu.hilightForegroundColor'
                       #'pullDownMenu.hilightBackgroundColor' #'menu.hilightBackgroundColor'
                       #'pullDownMenu.hilightLevel' #'menu.hilightLevel'
                       #'pullDownMenu.edgeStyle' 
                       #'pullDownMenu.toggleMode'
                       #'pullDownMenu.level'
                       #'pullDownMenu.font' 
                       #'pullDownMenu.separatingLines')>

    |styleSheet|

    styleSheet := StyleSheet.

    DefaultViewBackground := styleSheet colorAt:#'pullDownMenu.viewBackground'.
    DefaultViewBackground isNil ifTrue:[
        DefaultViewBackground := styleSheet colorAt:#'menuView.background'.
    ].
    DefaultForegroundColor := styleSheet colorAt:#'pullDownMenu.foregroundColor'.
    DefaultForegroundColor isNil ifTrue:[
        DefaultForegroundColor := styleSheet colorAt:#'menu.foregroundColor'.
    ].
    DefaultBackgroundColor := styleSheet colorAt:#'pullDownMenu.backgroundColor'.
    DefaultBackgroundColor isNil ifTrue:[
        DefaultViewBackground notNil ifTrue:[
            DefaultBackgroundColor := DefaultViewBackground
        ] ifFalse:[
            DefaultBackgroundColor := styleSheet colorAt:#'menu.backgroundColor'.
        ]
    ].
    DefaultHilightForegroundColor := styleSheet colorAt:#'pullDownMenu.hilightForegroundColor'.
    DefaultHilightForegroundColor isNil ifTrue:[
        DefaultHilightForegroundColor := styleSheet colorAt:#'menu.hilightForegroundColor'.
    ].
    DefaultHilightBackgroundColor := styleSheet colorAt:#'pullDownMenu.hilightBackgroundColor'.
    DefaultHilightBackgroundColor isNil ifTrue:[
        DefaultHilightBackgroundColor := styleSheet colorAt:#'menu.hilightBackgroundColor'.
    ].
    DefaultHilightLevel := styleSheet at:#'pullDownMenu.hilightLevel'.
    DefaultHilightLevel isNil ifTrue:[
        DefaultHilightLevel := styleSheet at:#'menu.hilightLevel' default:0.
    ].
    DefaultEdgeStyle := styleSheet at:#'pullDownMenu.edgeStyle'.
    DefaultToggleMode := styleSheet at:#'pullDownMenu.toggleMode' default:#toggle.
    DefaultLevel := styleSheet at:#'pullDownMenu.level' default:1.
    DefaultFont := styleSheet fontAt:#'pullDownMenu.font'.
    DefaultFont isNil ifTrue:[
        DefaultFont := MenuView defaultFont
    ].
    DefaultSeparatingLines := styleSheet at:#'pullDownMenu.separatingLines' default:false.

    "
     PullDownMenu updateStyleCache
    "

    "Modified: 20.10.1997 / 14:02:28 / cg"
! !

!PullDownMenu methodsFor:'accessing'!

add:label selector:selector
    "add a new title-item at the end.
     The corresponding label can later be set with #at:putMenu:
     or #at:putLabels:selectors:..."

    self add:label selector:selector after:nil

    "Modified: 5.6.1996 / 16:45:46 / cg"
!

add:label selector:selector after:indexOrString
    "add a new title-item after an existing item, indexOrString,
     or at the end if the after-arg is nil.
     The corresponding label can later be set with #at:putMenu:
     or #at:putLabels:selectors:..."

    |idx|

    indexOrString isNil ifTrue:[
        idx := titles size
    ] ifFalse:[
        idx := self indexOf:indexOrString.
    ].

    titles isNil ifTrue:[
        menus := Array with:nil.
        titles := Array with:label.
        selectors := Array with:selector.
    ] ifFalse:[
        menus := menus copyWith:nil insertedAfterIndex:idx.
        titles := titles copyWith:label insertedAfterIndex:idx.
        selectors := selectors copyWith:selector insertedAfterIndex:idx.
    ].

    shown ifTrue:[
        self redraw
    ]

    "
     |top m|

     top := StandardSystemView new.
     m := PullDownMenu in:top.
     m labels:#('file' 'edit').
     m selectors:#(file #edit).

     m add:'help' selector:#help after:#file.
     m at:#help putMenu:(MenuView labels:#('foo' 'bar')
                               selectors:#(foo bar)
                                receiver:nil).

     top open
    "

    "Modified: 5.7.1996 / 11:40:47 / cg"
!

add:label selector:selector before:indexOrString
    "add a new title-item before an existing item, indexOrString,
     or at the beginning if the before-arg is nil.
     The corresponding label can later be set with #at:putMenu:
     or #at:putLabels:selectors:..."

    |idx|

    indexOrString isNil ifTrue:[
        idx := 1
    ] ifFalse:[
        idx := self indexOf:indexOrString.
    ].

    titles isNil ifTrue:[
        menus := Array with:nil.
        titles := Array with:label.
        selectors := Array with:selector.
    ] ifFalse:[
        menus := menus copyWith:nil insertedAfterIndex:idx-1.
        titles := titles copyWith:label insertedAfterIndex:idx-1.
        selectors := selectors copyWith:selector insertedAfterIndex:idx-1.
    ].

    shown ifTrue:[
        self redraw
    ]

    "
     |top m|

     top := StandardSystemView new.
     m := PullDownMenu in:top.
     m labels:#('file' 'edit').
     m selectors:#(file #edit).

     m add:'help' selector:#help before:#edit.
     m at:#help putMenu:(MenuView labels:#('foo' 'bar')
                               selectors:#(foo bar)
                                receiver:nil).

     m add:'foo' selector:#foo before:nil.
     m at:#foo putMenu:(MenuView labels:#('foo1' 'foo2')
                               selectors:#(foo1 foo2)
                                receiver:nil).

     top open
    "

    "Modified: 5.7.1996 / 11:40:55 / cg"
!

at:aString putLabels:labels selector:selector args:args receiver:anObject
    "create and set the menu under the title, aString
     OBSOLETE protocol: labels:selectors:args:receiver: knows how to handle a
     single symbol-arg for selectors ..."

    ^ self at:aString putLabels:labels selectors:selector args:args receiver:anObject

    "Modified: 5.6.1996 / 16:47:32 / cg"
!

at:aString putLabels:labels selectors:selectors
    "create and set the menu under the title, aString"

    ^ self at:aString putLabels:labels selectors:selectors receiver:nil

    "Created: 24.3.1996 / 17:06:45 / cg"
!

at:aString putLabels:labels selectors:selectors accelerators:shorties args:args receiver:anObject
    "create and set the menu under the title, aString"

    |menuView|

    menuView := MenuView labels:labels
                      selectors:selectors
                   accelerators:shorties
                           args:args
                       receiver:anObject
                            for:self.
    self at:aString putMenu:menuView.
    ^ menuView

    "Created: 5.6.1996 / 16:51:48 / cg"
!

at:aString putLabels:labels selectors:selectors accelerators:shorties receiver:anObject
    "create and set the menu under the title, aString"

    ^ self at:aString putLabels:labels selectors:selectors accelerators:shorties args:nil receiver:anObject

    "Modified: 5.6.1996 / 16:48:26 / cg"
    "Created: 5.6.1996 / 16:53:39 / cg"
!

at:aString putLabels:labels selectors:selectors args:args receiver:anObject
    "create and set the menu under the title, aString"

    |menuView|

    menuView := MenuView labels:labels
                      selectors:selectors
                           args:args
                       receiver:anObject
                            for:self.
    self at:aString putMenu:menuView.
    ^ menuView
!

at:aString putLabels:labels selectors:selectors receiver:anObject
    "create and set the menu under the title, aString"

    ^ self at:aString putLabels:labels selectors:selectors args:nil receiver:anObject

    "Modified: 5.6.1996 / 16:48:26 / cg"
!

at:aString putMenu:aMenu
    "set the menu under the title, aString"

    |index|

    index := self indexOf:aString.
    (index == 0) ifTrue:[
        self error:'no such menu entry' mayProceed:true.
        ^ nil
    ].

    aMenu container:(self superView).
    aMenu beInvisible.
    menus at:index put:aMenu.
    aMenu masterView:self.

    ^ aMenu

    "Modified: 5.6.1996 / 16:48:50 / cg"
!

labels
    "return the menu-titles (group-headers)"

    ^ titles
!

labels:titleArray
    "define the menu-titles (group-headers)"

    |numberOfLabels|

    numberOfLabels := titleArray size.
    menus := Array new:numberOfLabels.
    titles := Array new:numberOfLabels.

    titleArray keysAndValuesDo:[:index :entry |
        |e|

        entry isImage ifTrue:[
            e := entry onDevice:device
        ] ifFalse:[
            e := entry printString
        ].
        titles at:index put:e
    ].
    self invalidate "/ clear; redraw

    "Modified: 29.5.1996 / 16:21:00 / cg"
!

labels:titleArray selectors:selectorArray
    "define the menu-titles (group-headers) and selectors.
     Selectors are mostly used as access keys to get to submenus later."

    self labels:titleArray.
    self selectors:selectorArray

    "Created: 20.10.1995 / 20:15:54 / cg"
!

menuAt:stringOrNumber
    "return the menu with the title; nil if not found"

    ^ self subMenuAt:stringOrNumber

    "Modified: 24.3.1996 / 17:10:11 / cg"
!

numberOfTitles:n
    "setup blank title-space to be filled in later"

    menus := Array new:n.
    titles := Array new:n
!

receiver:anObject 
    "set the menu-receiver. 
     That's the one who gets the messages (both from myself and from my submenus).
     This only sets the receiver for menus which are already
     created - menus added later should get their receiver in
     the creation send."

    receiver := anObject.
    menus notNil ifTrue:[
        menus do:[:aMenu |
            aMenu notNil ifTrue:[
                aMenu receiver:anObject
            ]
        ]
    ]
!

remove:indexOrString
    "remove the menu, indexOrString."

    |idx|

    idx := self indexOf:indexOrString.
    idx == 0 ifTrue:[^ self].

    menus removeIndex:idx.
    titles removeIndex:idx.
    selectors removeIndex:idx.

    shown ifTrue:[
        self clearView.
        self redraw
    ]

    "
     |top m|

     top := StandardSystemView new extent:300@200.
     m := PullDownMenu in:top.
     m labels:#('file' 'edit').
     m selectors:#(file #edit).
     top open.

     Delay waitForSeconds:3.
     m add:'help' selector:#help after:#file.
     m at:#help putMenu:(MenuView labels:#('foo' 'bar')
                               selectors:#(foo bar)
                                receiver:nil).

     Delay waitForSeconds:3.
     m remove:'help'
    "

    "Modified: 5.7.1996 / 11:43:08 / cg"
!

selectors
    "return the menu-selectors"

    ^ selectors
!

selectors:selectorArray
    "define the menu-selectors. These are used as accesskey only
     in menuAt: accesses. This makes PullDownMenu accesss
     somewhat more compatible to PopUpMenus."

    selectors := selectorArray copy.

    "Modified: 30.4.1996 / 15:57:04 / cg"
!

subMenuAt:stringOrNumber
    "return the menu with the title; nil if not found."

    |index|

    index := self indexOf:stringOrNumber.
    (index == 0) ifTrue:[^ nil].
    ^ menus at:index

    "Modified: 24.3.1996 / 17:09:56 / cg"
! !

!PullDownMenu methodsFor:'accessing-behavior'!

actionAt:stringOrNumber
    "return the actionBlock associated with stringOrNumber; 
     nil if there is none (but there may be still a selector there)."

    |index|

    actions isNil ifTrue:[^ nil].
    index := self indexOf:stringOrNumber.
    (index == 0) ifTrue:[^ nil].
    ^ actions at:index ifAbsent:nil

    "Modified: 24.3.1996 / 17:09:56 / cg"
    "Created: 17.4.1996 / 20:50:45 / cg"
!

actionAt:stringOrNumber put:aBlock
    "return the actionBlock associated with stringOrNumber; 
     nil if there is none (but there may be still a selector there)."

    |index newActions|

    index := self indexOf:stringOrNumber.
    (index == 0) ifTrue:[^ nil].
    actions size < index ifTrue:[
	newActions := Array new:index.
	newActions replaceFrom:1 to:actions size with:actions.
	actions := newActions
    ].
    actions at:index put:aBlock

    "Modified: 24.3.1996 / 17:09:56 / cg"
    "Created: 17.4.1996 / 20:52:13 / cg"
!

disable:anItem
    menus do:[:aMenu |
        aMenu notNil ifTrue:[aMenu disable:anItem]
    ]
!

enable:anItem
    menus do:[:aMenu |
        aMenu notNil ifTrue:[aMenu enable:anItem]
    ]
! !

!PullDownMenu methodsFor:'accessing-look'!

backgroundColor:aColor
    "set the background drawing color.
     You should not use this method; instead leave the value as
     defined in the styleSheet."

    bgColor := aColor onDevice:device
!

font:aFont
    "set the menus font.
     adjusts menu-origins when font changes.
     You should not use this method; instead leave the value as
     defined in the styleSheet.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    |font|

    font := self font.
    aFont ~~ font ifTrue:[
        super font:aFont.
        font := self font.
        self height:(font height + (font descent * 2)).
        shown ifTrue:[
            self setMenuOrigins
        ]
    ]

    "Modified: 22.5.1996 / 12:37:04 / cg"
!

foregroundColor:aColor
    "set the foreground drawing color.
     You should not use this method; instead leave the value as
     defined in the styleSheet."

    fgColor := aColor onDevice:device
!

showSeparatingLines:aBoolean
    "turn on/off drawing of separating lines.
     You should not use this method; instead leave the value as
     defined in the styleSheet."

    showSeparatingLines := aBoolean.
    shown ifTrue:[
	self setMenuOrigins.
	self invalidate
    ]

    "Modified: 29.5.1996 / 16:21:06 / cg"
! !

!PullDownMenu methodsFor:'converting'!

asMenu
    ^ self asMenu:self

!

asMenu:aView
    |menu values item subM rcv|

    menu   := Menu new.
    values := aView selectors.

    aView labels keysAndValuesDo:[:anIndex :aLabel|
        item := MenuItem label:(aLabel printString).
        aLabel isImage ifTrue:[
            rcv := ResourceRetriever new.
            rcv className:#MenuEditor.
            rcv selector:#iconUnknown.
            item resourceRetriever:rcv.
        ] ifFalse:[
            aView ~~ self ifTrue:[
                rcv := aView checkToggleAt:anIndex.
                rcv notNil ifTrue:[
                    item indication:rcv
                ]
            ]
        ].

        subM := aView subMenuAt:anIndex.

        subM notNil ifTrue:[
            item submenu:(self asMenu:subM)
        ].
        menu addItem:item value:(values at:anIndex).
    ].
  ^ menu
! !

!PullDownMenu methodsFor:'drawing'!

drawActiveTitleSelected:selected
    |x|
    activeMenuNumber notNil ifTrue:[
	x := self titleLenUpTo:activeMenuNumber.
	self drawTitle:(titles at:activeMenuNumber) x:x selected:selected 
    ]
!

drawTitle:stringOrImage x:x0 selected:selected
    |y w x wSpace fg bg map font|

    selected ifTrue:[
        fg := activeFgColor.
        bg := activeBgColor
    ] ifFalse:[
        fg := fgColor.
        bg := bgColor
    ].

    font := gc font.
    wSpace := font widthOf:' '.
    x := x0.
    stringOrImage isString ifTrue:[
        y := ((height - (font height)) // 2) + (font ascent) "+ topMargin".
        w := font widthOf:stringOrImage.
    ] ifFalse:[
        y := ((height - stringOrImage height) // 2) max:0.
        w := stringOrImage width
    ].
    w := w + (wSpace * 2).

    gc paint:bg.
    gc fillRectangleX:x y:0 width:w height:height.

    self is3D ifTrue:[
        self drawEdgesForX:x y:0
                     width:w
                    height:height
                     level:(selected ifTrue:[onLevel] ifFalse:[offLevel])
    ].
    gc paint:fg on:bg.
    x := x + wSpace.
    stringOrImage isString ifTrue:[
        gc displayOpaqueString:stringOrImage x:x y:y
    ] ifFalse:[
        stringOrImage isImageOrForm ifTrue:[
            stringOrImage depth == 1 ifTrue:[
                (map := stringOrImage colorMap) notNil ifTrue:[
                    map at:1 put:((map at:1) onDevice:device).
                    map at:2 put:((map at:2) onDevice:device).

                    gc paint:(map at:2) on:(map at:1).
                    gc displayOpaqueForm:stringOrImage x:x y:y.
                    ^ self
                ]
            ].
            gc displayForm:stringOrImage x:x y:y
        ] ifFalse:[
            stringOrImage displayOn:self x:x y:y
        ]
    ]

    "Modified: 14.1.1997 / 00:06:07 / cg"
!

highlightActiveTitle
    self drawActiveTitleSelected:true 
!

redraw
    |x     "{ Class: SmallInteger }"
     y     "{ Class: SmallInteger }"
     index "{ Class: SmallInteger }" 
     wSpace clr font|

    shown ifFalse: [ ^ self ].
    titles isNil ifTrue:[^ self].

    font := gc font.
    wSpace := (font widthOf:' ').
    x := 0.
    y := height "- 1".
    index := 1.
    titles do:[:title |
        self drawTitle:title x:x selected:(index == activeMenuNumber).

        title isString ifTrue:[
            x := x + (font widthOf:title).
        ] ifFalse:[
            x := x + title width
        ].
        x := x + wSpace + wSpace.
        showSeparatingLines ifTrue:[
            self is3D ifTrue:[
                gc paint:shadowColor.
                gc displayLineFromX:x y:0 toX:x y:y.
                x := x + 1.
                clr := lightColor.
            ] ifFalse:[
                clr := fgColor.
            ].
            gc paint:clr.
            gc displayLineFromX:x y:0 toX:x y:y.
            x := x + 1
        ].
        index := index + 1
    ]

    "Modified: 14.1.1997 / 00:06:22 / cg"
!

unHighlightActiveTitle
    self drawActiveTitleSelected:false 
! !

!PullDownMenu methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |titleIndex activeMenu activeLeft activeTop|

    state == 0 ifTrue:[
        "/ self hideActiveMenu.
        ^ self
    ].
    "is it the select or 1-button ?"
    self sensor anyButtonPressed ifFalse:[^ self].

    activeMenuNumber isNil ifTrue:[^ self].

    activeMenuNumber notNil ifTrue:[
        activeMenu := menus at:activeMenuNumber.
    ].

    (y < height) ifTrue:[
        "moving around in title line"
        activeMenu notNil ifTrue:[
            activeMenu setSelection:nil
        ].
        titleIndex := self titleIndexForX:x.
        titleIndex notNil ifTrue:[
            (titleIndex ~~ activeMenuNumber) ifTrue:[
                self pullMenu:titleIndex
            ]
        ] ifFalse:[
            self hideActiveMenu
        ]
    ] ifFalse:[
        "moving around below"
        activeMenu isNil ifTrue:[^self].
        activeLeft := activeMenu left.
        (x between:activeLeft and:(activeMenu right)) ifTrue:[
            activeTop := activeMenu top.
            (y between:activeTop and:(activeMenu bottom)) ifTrue:[
                "moving around in menu"
                activeMenu buttonMotion:state
                                      x:(x - activeLeft)
                                      y:(y - activeTop).
                ^ self
            ]
        ].
        "moved outside menu"
        activeMenu setSelection:nil
    ]

    "Modified: / 28.7.1998 / 16:01:50 / cg"
!

buttonPress:button x:x y:y
    |titleIndex activeMenu activeLeft activeTop m|

    self forceUngrabPointer.
    self forceUngrabKeyboard.

    (y between:0 and:height) ifTrue:[
        titleIndex := self titleIndexForX:x.
    ].

    "
     now, titleIndex is non-nil if pressed within myself
    "
    (titleIndex notNil and:[titleIndex ~~ activeMenuNumber]) ifTrue:[
        "/ pressed on another item
        m := self pullMenu:titleIndex.
        (toggleMode == #toggle) ifTrue:[
            self grabPointer.
            self grabKeyboard.
"/            self cursor:Cursor upRightArrow
        ]
    ] ifFalse:[
        titleIndex == activeMenuNumber ifTrue:[
            "/ pressed on same item
            (toggleMode ~~ #toggle) ifTrue:[
                "same pressed again ... stay"
                titleIndex notNil ifTrue:[
                    self grabPointer.
                    self grabKeyboard.
                ].
            ] ifFalse:[
                self hideActiveMenu.
            ].
            ^ self
        ].

        "/ pressed outside

        activeMenuNumber isNil ifTrue:[^self].

        activeMenu := menus at:activeMenuNumber.
        activeLeft := activeMenu left.
        (x between:activeLeft and:(activeMenu right)) ifTrue:[
            activeTop := activeMenu top.
            (y between:activeTop and:(activeMenu bottom)) ifTrue:[

                "/ pressed inside currently pulled menu
                activeMenu buttonPress:button x:(x - activeLeft) y:(y - activeTop).
                ^ self
            ].
        ].

        "/ somewhere else
        self hideActiveMenu.
    ]

    "Modified: 6.3.1996 / 17:14:16 / cg"
!

buttonRelease:button x:x y:y
    |activeMenu activeLeft activeTop hideMenu|

    activeMenuNumber isNil ifTrue:[^self].
    activeMenu := menus at:activeMenuNumber.

    hideMenu := false.
    (y >= height) ifTrue:[
	"release below title-line"
	activeLeft := activeMenu left.
	"
	 released in a submenu ?
	"
	(x between:activeLeft and:(activeMenu right)) ifTrue:[
	    activeTop := activeMenu top.
	    (y between:activeTop and:(activeMenu bottom)) ifTrue:[
		"release in menu"
		self hideActiveMenu.   
		activeMenu buttonRelease:button
				       x:(x - activeLeft)
				       y:(y - activeTop).
		^ self
	    ]
	].
	hideMenu := true.
    ] ifFalse:[
	y < 0 ifTrue:[
	    hideMenu := true
	] ifFalse:[
	    activeMenu isNil ifTrue:[
		self performSelectedAction.
		hideMenu := true.
	    ] ifFalse:[
		(toggleMode == #toggle) ifFalse:[   
		    hideMenu := true
		]
	    ]
	]
    ].                  
    hideMenu ifTrue:[
       self hideActiveMenu.
    ]

    "Modified: 17.4.1996 / 20:56:08 / cg"
!

keyPress:key x:x y:y

    <resource: #keyboard (#CursorLeft #CursorRight #MenuSelect #Return)>

    |index startIndex m|

    "
     handle CursorLeft/Right for non-mouse operation
     (for example, if it has the explicit focus)
     These will pull the previous/next menu
    "
    ((key == #CursorRight) or:[key == #CursorLeft]) ifTrue:[
	activeMenuNumber isNil ifTrue:[
	    index := (key == #CursorRight) ifTrue:[1] ifFalse:[menus size].
	] ifFalse:[
	    (key == #CursorRight) ifTrue:[
		"/ if its a cursor-right, and the current item
		"/ has a submenu, then pop up the submenu
		m := menus at:activeMenuNumber.
		m notNil ifTrue:[
		    m selectedItemHasSubmenu ifTrue:[
			m showSubmenu:(m selection).
			^ self.
		    ].
		].
	    ].

	    (key == #CursorRight) ifTrue:[
		index := activeMenuNumber+1
	    ] ifFalse:[
		index := activeMenuNumber-1
	    ].
	    index == 0 ifTrue:[index := menus size]
	    ifFalse:[
		index > menus size ifTrue:[index := 1]
	    ]
	].
	self pullMenu:index.
	^ self
    ].

"/    activeMenuNumber isNil ifTrue:[
	"/
	"/ find an item starting with that alpha-key
	"/
	key isCharacter ifTrue:[
	    (key isLetter) ifTrue:[
		activeMenuNumber isNil ifTrue:[
		    startIndex := 1.
		] ifFalse:[
		    startIndex := activeMenuNumber + 1
		].
		index := titles 
			    findFirst:[:item | 
					    item isString
					    and:[(item startsWith:key asUppercase)
						 or:[item startsWith:key asLowercase]]]
			    startingAt:startIndex.

		(index == 0 and:[startIndex ~~ 1]) ifTrue:[
		    index := titles 
				findFirst:[:item | 
						item isString
						and:[(item startsWith:key asUppercase)
						     or:[item startsWith:key asLowercase]]]
				startingAt:1.
		].

		index ~~ 0 ifTrue:[
		    self pullMenu:index.
		].
		^ self
	    ]
	].
"/    ].

    activeMenuNumber isNil ifTrue:[
	^ super keyPress:key x:x y:y
    ].

    "
     Return, space or the (virtual) MenuSelect key trigger
     a menu entry (for non-submenu entries).
     Otherwise, if we have a submenu open,
     pass the key on to it ...
    "
    m := menus at:activeMenuNumber.
    m isNil ifTrue:[
	(key == #Return 
	or:[key == #MenuSelect
	or:[key == Character space]]) ifTrue:[
	    self performSelectedAction.
	].
    ] ifFalse:[
	m keyPress:key x:0 y:0.
    ].

    "Modified: 25.2.1997 / 23:38:15 / cg"
!

showNoFocus:explicit
    "when stepping focus, hide any active menu"

    explicit ifTrue:[
	self hideActiveMenu.
	super showNoFocus:explicit
    ]

    "Modified: 25.2.1997 / 23:31:38 / cg"
! !

!PullDownMenu methodsFor:'hiding/showing menus'!

cancelDelayedSubmenuHideOrShowAction

    "Created: / 30-09-2011 / 18:55:43 / cg"
!

hide 
    "sent by an aborted menu"

    self hideActiveMenu.
!

hideActiveMenu
    "hide currently active menu - release grab if there is any grab"

    ^ self hideActiveMenuRelease:true
!

hideActiveMenuRelease:aBoolean
    "hide currently active menu - release grab if aBoolean is true
     and a grab was set"

    |m|

    activeMenuNumber notNil ifTrue:[
        (m := menus at:activeMenuNumber) notNil ifTrue:[
            m beInvisible.
        ].
        self unHighlightActiveTitle.
        activeMenuNumber := nil
    ].
    aBoolean ifTrue:[
        self forceUngrabKeyboard.
        self forceUngrabPointer. 
"/        self cursor:Cursor normal
    ].

    "Modified: 6.3.1996 / 17:14:21 / cg"
!

pullMenu:aNumber
    "activate a menu, return it or nil"

    <resource: #style (#'pullDownMenu.autoselectFirst')>

    |subMenu r posY|

    activeMenuNumber notNil ifTrue:[self hideActiveMenuRelease:false].
    activeMenuNumber := aNumber.
    subMenu := menus at:aNumber.

    raiseTopWhenActivated ifTrue:[
        self topView raise.
    ].

    (activeMenuNumber notNil 
    and:[
         subMenu notNil
         or:[selectors notNil and:[(selectors at:activeMenuNumber) notNil]]]) ifTrue:[
            self highlightActiveTitle.
         ].

    subMenu notNil ifTrue:[
        subMenu origin:((left + (self titleLenUpTo:aNumber)) 
                       @
                       (posY := height + subMenu borderWidth)).
        subMenu hiddenOnRealize:false.
        subMenu setSelection:nil.
        subMenu create.
        subMenu saveUnder:true.
        subMenu superMenu:self.

        subMenu right > (r := self right) ifTrue:[
            subMenu origin:((r - subMenu width) @ posY).
        ].
        subMenu raise show.

        (styleSheet at:#'pullDownMenu.autoselectFirst') == true ifTrue:[
            subMenu setSelection:1
        ]
    ].
    ^ subMenu

    "Modified: / 26.10.1997 / 17:04:00 / cg"
!

regainControl
    true ifTrue:[
        self grabPointer.
        self grabKeyboard.
"/        self cursor:Cursor upRightArrow
        self sensor flushMotionEventsFor:nil
    ]

    "Modified: 6.3.1996 / 17:14:27 / cg"
! !

!PullDownMenu methodsFor:'initialization & release'!

container:aView
    "when my container changes, all of my menus must change as well"

    super container:aView.

    menus notNil ifTrue:[
	menus do:[:aMenu |
	    aMenu notNil ifTrue:[
		aMenu container:aView
	    ]
	]
    ]

    "Modified: 9.5.1996 / 00:43:13 / cg"
    "Created: 9.5.1996 / 00:43:38 / cg"
!

create
    super create.
    self setMenuOrigins
!

destroy
    "have to destroy the menus manually here,
     since they are no real subviews of myself"

    menus notNil ifTrue:[
        menus do:[:m |
            m notNil ifTrue:[m destroy]
        ].
        "/ cg: no need to remove the submenus (they are already destroyed).
        "/ leaving the menus allows for reopening the receiver
        "/ menus := nil
    ].
    activeMenuNumber := nil.
    super destroy.
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    bgColor notNil ifTrue:[bgColor := bgColor onDevice:device].
    fgColor notNil ifTrue:[fgColor := fgColor onDevice:device].

    activeBgColor notNil ifTrue:[activeBgColor := activeBgColor onDevice:device].
    activeFgColor notNil ifTrue:[activeFgColor := activeFgColor onDevice:device].

    "Created: 13.1.1997 / 23:25:14 / cg"
!

initCursor
    "set up a hand cursor"

    cursor := Cursor hand
!

initStyle
    "initialize style specifics"

    <resource: #style (#name 
                       #'pullDownMenu.raiseTop' 
                       #'pullDownMenu.menuLevel')>

    |style l|

    super initStyle.

    showSeparatingLines := DefaultSeparatingLines. "/ false.
    DefaultViewBackground notNil ifTrue:[
        viewBackground := DefaultViewBackground onDevice:device
    ].

    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor
    ] ifFalse:[
        fgColor := Black.
    ].
    DefaultBackgroundColor notNil ifTrue:[
        bgColor := DefaultBackgroundColor
    ] ifFalse:[
        bgColor := viewBackground.
    ].
    onLevel := DefaultHilightLevel.
    offLevel := DefaultLevel.

    self is3D ifTrue:[
        device hasColors ifTrue:[
            activeFgColor := Color name:'yellow'
        ] ifFalse:[
            activeFgColor := White
        ].
        device hasGrayscales ifTrue:[
            activeBgColor := bgColor.
        ] ifFalse:[
            activeBgColor := fgColor.
        ].
        topMargin := 2.

        (l := styleSheet at:#'pullDownMenu.menuLevel') notNil ifTrue:[
            self level:l
        ].

        style := styleSheet name.
        ((style == #iris) or:[style == #motif]) ifTrue:[
            onLevel := 2.
            offLevel := 0.
            activeFgColor := fgColor
        ]
    ] ifFalse:[
        activeFgColor := bgColor.
        activeBgColor := fgColor.
        topMargin := 0
    ].

    edgeStyle := DefaultEdgeStyle.
    toggleMode := DefaultToggleMode.

    DefaultHilightForegroundColor notNil ifTrue:[
        activeFgColor := DefaultHilightForegroundColor
    ].
    DefaultHilightBackgroundColor notNil ifTrue:[
        activeBgColor := DefaultHilightBackgroundColor
    ].
    DefaultShadowColor notNil ifTrue:[
        shadowColor := DefaultShadowColor
    ].
    DefaultLightColor notNil ifTrue:[
        lightColor := DefaultLightColor
    ].

    raiseTopWhenActivated := styleSheet at:#'pullDownMenu.raiseTop' default:true.

    "Modified: / 15-09-1998 / 22:58:42 / cg"
    "Modified (comment): / 05-10-2011 / 15:50:54 / az"
!

initialize
    super initialize.

    self origin:(0.0 @ 0.0)
         extent:(1.0 @ self preferredHeight)
!

recreate
    "sent after a snapin or a migration;
     if the image was saved with an active menu, hide it"

    |m|

    activeMenuNumber notNil ifTrue:[
        (m := menus at:activeMenuNumber) notNil ifTrue:[
            m unmap.
        ].
        activeMenuNumber := nil.
    ].
    super recreate.
    self setMenuOrigins

    "Modified: 3.5.1996 / 23:48:55 / stefan"
! !

!PullDownMenu methodsFor:'private'!

indexOf:stringOrNumber
    "return the index of the menu with title; return 0 if not found.
     stringOrNumber may be a number, a selector from the selectorArray
     or a string from the title array.
     If stringOrNumber is not a valid item, return 0."

    |idx|

    stringOrNumber isNumber ifTrue:[
	^ stringOrNumber
    ].
    selectors notNil ifTrue:[
	idx := selectors indexOf:stringOrNumber.
	idx ~~ 0 ifTrue:[^ idx].
    ].
    stringOrNumber isString ifTrue:[
	^ titles indexOf:stringOrNumber
    ].
    (stringOrNumber respondsTo:#string) ifTrue:[
	^ titles indexOf:stringOrNumber asString
    ].
    ^ 0

    "Modified: 27.4.1996 / 15:25:28 / cg"
!

performEntry:itemIndex
    |block sel|

    actions notNil ifTrue:[
	block := actions at:itemIndex.
	block notNil ifTrue:[
	    block value.
	    ^ self
	].
    ].
    selectors notNil ifTrue:[
	sel := selectors at:itemIndex.
	sel notNil ifTrue:[
	    model notNil ifTrue:[
		model perform:sel
	    ] ifFalse:[
		receiver perform:sel
	    ]    
	].
    ].

    "Modified: 17.4.1996 / 20:55:11 / cg"
!

performSelectedAction
    |block sel|

    actions notNil ifTrue:[
	block := actions at:activeMenuNumber.
	block notNil ifTrue:[
	    block value.
	    ^ self
	].
    ].
    selectors notNil ifTrue:[
	sel := selectors at:activeMenuNumber.
	sel notNil ifTrue:[
	    model notNil ifTrue:[
		model perform:sel
	    ] ifFalse:[
		receiver perform:sel
	    ]    
	].
    ].

    "Modified: 17.4.1996 / 20:55:11 / cg"
    "Created: 17.4.1996 / 20:55:53 / cg"
!

setMenuOrigins
    "adjust origins of menus when font changes"

    (gc font graphicsDevice == device) ifTrue:[
        menus notNil ifTrue:[
            menus keysAndValuesDo:[:index :aMenu |
                aMenu notNil ifTrue:[
                    aMenu origin:((left + (self titleLenUpTo:index)) 
                                  @
                                  (height + aMenu borderWidth))
                ].
            ]
        ]
    ]

    "Modified: 5.7.1996 / 17:55:08 / cg"
!

someMenuItemLabeled:aLabel
    "find a menu item.
     Currently, in ST/X, instances of MenuItem are only created as dummy"

    |idx|

    idx := self indexOf:aLabel.
    idx ~~ 0 ifTrue:[
	^ MenuItem new menu:self index:idx
    ].
    menus notNil ifTrue:[
	menus do:[:aMenu |
	    |item|

	    aMenu notNil ifTrue:[
		(item := aMenu someMenuItemLabeled:aLabel) notNil ifTrue:[
		    ^ item
		]
	    ]
	]
    ].
    ^ nil
!

titleIndexForX:x
    "given a click x-position, return index in title or nil"

    |xstart "{ Class: SmallInteger }"
     xend   "{ Class: SmallInteger }" 
     wSpace wSep font|

    font := gc font.
    wSpace := (font widthOf:' ') * 2. 
    showSeparatingLines ifTrue:[
        self is3D ifTrue:[
            wSep := 2
        ] ifFalse:[
            wSep := 1
        ]
    ] ifFalse:[
        wSep := 0
    ].
    xstart := 0.
    1 to:(titles size) do:[:index |
        |entry thisLength|

        entry := titles at:index.
        entry isString ifTrue:[
            thisLength := font widthOf:entry.
        ] ifFalse:[
            thisLength := entry width
        ].
        xend := xstart + thisLength + wSpace + wSep.
        (x between:xstart and:xend) ifTrue:[^ index].
        xstart := xend
    ].
    ^ nil
!

titleLenUpTo:index
    "answer len (in pixels) of all title-strings up-to 
     (but excluding) title-index. Used to compute x-position when drawing
     individual entries."

    |len "{ Class: SmallInteger }" 
     wSpace wSep font|

    (index <= 1) ifTrue:[^ 0].
    font := gc font.
    wSpace := (font widthOf:' ').
    showSeparatingLines ifTrue:[
        self is3D ifTrue:[
            wSep := 2
        ] ifFalse:[
            wSep := 1
        ]
    ] ifFalse:[
        wSep := 0
    ].

    len := 0.
    titles from:1 to:(index - 1) do:[:entry |
        |thisLength|

        entry isString ifTrue:[
            thisLength := (font widthOf:entry).
        ] ifFalse:[
            thisLength := entry width
        ].
        len := len + thisLength + wSpace + wSep + wSpace.
    ].
    ^ len
! !

!PullDownMenu methodsFor:'queries'!

preferredExtent
    "return my preferredExtent from the title-item widths & font height"

    |w hMax font|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    font := gc font.

    w := self titleLenUpTo:(titles size + 1).
    hMax := font height + (font descent * 2).
    titles notNil ifTrue:[
        titles do:[:aStringOrImage |
            aStringOrImage isString ifFalse:[
                hMax := hMax max:(aStringOrImage heightOn:self)
            ]
        ]
    ].
        
    ^ w @ (hMax + (margin*2) + ((onLevel abs max:offLevel abs)*2) "+ topMargin").

    "Modified: / 31.10.1997 / 20:49:23 / cg"
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not PullDownMenuSpec)"

    ^ MenuPanelSpec

    "Modified: / 31.10.1997 / 19:48:23 / cg"
! !

!PullDownMenu methodsFor:'submenu notifications'!

hideSubmenu
    "sent by an escaped menu - ignored here"

    ^ self

    "Modified: / 29-11-2010 / 19:51:17 / cg"
!

showActive
    "sent by a menu to tell me that it starts to perform
     its menu action."

    windowGroup notNil ifTrue:[windowGroup showCursor:Cursor wait]
!

showPassive
    "sent by a menu to tell me that it finished its menu-action.
     Here, we hide the currently active menu."

    self hideActiveMenu.
    windowGroup notNil ifTrue:[windowGroup restoreCursors]
!

submenuTriggered 
    "sent by a sub-submenu to tell me that it finished its menu-action."

    self showPassive
! !

!PullDownMenu class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

