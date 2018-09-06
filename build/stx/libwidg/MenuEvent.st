"{ Package: 'stx:libwidg' }"

WidgetEvent subclass:#MenuEvent
	instanceVariableNames:'menu itemIndex item itemLabel itemValue menuReceiver'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Menus'
!

MenuEvent subclass:#MenuEnterItemEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEvent
!

MenuEvent subclass:#MenuHideEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEvent
!

MenuEvent subclass:#MenuLeaveItemEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEvent
!

MenuEvent subclass:#MenuSelectItemEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEvent
!

MenuEvent subclass:#MenuShowEvent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:MenuEvent
!

!MenuEvent class methodsFor:'documentation'!

documentation
"
    Internal menu events.
    These have been added very lately to support capture & replay inside st/x applications.
    They are used internally within a menu-widget instead of direct message sends, thus
    allowing interception and synthetization.

    Due to some historic leftover, there are two mechanisms for menus:
        1) the (very) old MenuView (which inherits from SelectionInListView)
        2) the new MenuPanel.

    The menuView uses simple text and values and it is basically index-based.
    The menuPanel uses instances of MenuItem which contain the action information.

    The menuView should go away, as soon as someone finds time to convert all leftover uses
    of it in the system (mostly popupMenus in text views).
"
! !

!MenuEvent class methodsFor:'instance creation'!

enterMenuItem:itemOrNil index:index text:textOrNil value:valueOrNil inMenu:aMenu menuReceiver:menuReceiver
    |ev|

    ev := (MenuEnterItemEvent basicNew).
    ev item:itemOrNil index:index text:textOrNil value:valueOrNil menu:aMenu menuReceiver:menuReceiver.

    ev selector:#processMenuEnterItemEvent:.
    ev arguments:(Array with:ev).
    ^ ev

    "Created: / 29-06-2011 / 16:19:14 / cg"
!

hideMenu:aMenu
    |ev|

    ev := (MenuHideEvent basicNew).
    ev menu:aMenu.

    ev selector:#processHideMenuEvent:.
    ev arguments:(Array with:ev).
    ^ ev

    "Created: / 29-06-2011 / 12:30:16 / cg"
!

leaveMenuItem:itemOrNil index:index text:textOrNil value:valueOrNil inMenu:aMenu menuReceiver:menuReceiver
    |ev|

    ev := (MenuLeaveItemEvent basicNew).
    ev menu:aMenu.
    ev item:itemOrNil index:index text:textOrNil value:valueOrNil menu:aMenu menuReceiver:menuReceiver.

    ev selector:#processMenuLeaveItemEvent:.
    ev arguments:(Array with:ev).
    ^ ev

    "Created: / 29-06-2011 / 16:19:01 / cg"
!

selectMenuItem:itemOrNil index:indexOrNil text:textOrNil value:valueOrNil inMenu:aMenu menuReceiver:menuReceiver
    |ev|

    ev := (MenuSelectItemEvent basicNew).
    ev item:itemOrNil index:indexOrNil text:textOrNil value:valueOrNil menu:aMenu menuReceiver:menuReceiver.

    ev selector:#processMenuSelectItemEvent:.
    ev arguments:(Array with:ev).
    ^ ev

    "Created: / 29-06-2011 / 16:18:34 / cg"
!

showMenu:aMenu
    |ev|

    ev := (MenuShowEvent basicNew).
    ev menu:aMenu.

    ev selector:#processShowMenuEvent:.
    ev arguments:(Array with:ev).
    ^ ev

    "Created: / 29-06-2011 / 12:30:05 / cg"
! !

!MenuEvent methodsFor:'accessing'!

item
    "attention: only menuPanels return something useful here;
     menuview will return nil"

    ^ item

    "Modified: / 29-06-2011 / 12:41:28 / cg"
!

itemIndex
    "the index (1..) of the menu item"

    ^ itemIndex

    "Modified: / 29-06-2011 / 12:41:47 / cg"
!

itemLabel
    "the item's label text. Might be nil or non-string (image or labelAndIcon)"

    ^ itemLabel

    "Modified: / 29-06-2011 / 12:42:18 / cg"
!

itemValue
    "the item's value. That is completely up to the menu-widget's user."

    ^ itemValue

    "Modified: / 29-06-2011 / 12:42:46 / cg"
!

menu
    "the item's menu; either a menuPanel or a menuView"

    ^ menu

    "Modified: / 29-06-2011 / 12:43:00 / cg"
!

menuReceiver
    ^ menuReceiver
! !

!MenuEvent methodsFor:'instance creation'!

item:itemArgOrNil index:indexArgOrNil text:textArgOrNil value:valueArgOrNil menu:aMenu menuReceiver:menuReceiverArg
    item := itemArgOrNil.
    itemIndex := indexArgOrNil.
    itemLabel := textArgOrNil.
    itemValue := valueArgOrNil.
    menu := receiver := aMenu.
    menuReceiver := menuReceiverArg.

    "Created: / 29-06-2011 / 16:18:08 / cg"
! !

!MenuEvent class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg/MenuEvent.st,v 1.3 2013-06-21 13:40:23 cg Exp $'
! !

