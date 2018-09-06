"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#KeyboardMap
	instanceVariableNames:'parent current bindings aliases'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!KeyboardMap class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    Instances of KeyboardMap are used for mapping keystrokes AND sequences
    of keystrokes to a logical function which is used by UI code. For
    example, it maps #Ctrls to #Accept logical function which is then
    used menu items and so on.

    This allows for changing a shortcut without changing the code.

    Keyboard maps may chained together, if a mapping is not found in
    a particular key map, lookup continues in its parent map (if any).
    Usually the grand-parent is device's standard map, see
    DeviceWorkstation >> keyboardMap (but not necessarily!!)

    The setup of device's map is done in the 'smalltalk.rc' or one of the
    'keyboard.rc' files during startup.

    To add a mapping (for example, to attach the logical function 'DoIt' to
    the key-combination Cmd-'d'):

        |m|

        m := Display keyboardMap.
        m bindValue:#DoIt to:#Cmdd.

    Key sequences can also be defined (hey emacs fans ;-) as in:

        |m|

        m := Display keyboardMap.
        m bindValue:#DoIt to:#Ctrlx followedBy:#Ctrld

    Key prefixes are defined in the DeviceWorkstation>>translateKey: method.
    Typical prefixes are Cmd (for Alt or Meta), Ctrl etc.
    Some keyboards offer both Alt and Meta keys - on those, the first has a
    prefix of Alt, the second has Cmd as prefix. Keyboards with only an Alt
    key will will create prefix codes of Cmd for that.

    A convenient way to create initialize a keyboard map is to use
    #loadKeyboadMapDefinition: as in:

        |m|

        m := Display keyboardMap.
        m loadKeyboadMapDefinition: #(
            (Cut    Ctrlx   Cmdx)
            (Copy   Ctrlc   Cmdc)
            (Paste  Ctrlv   (Cmdv ShiftInsert)
        )

    For details about the format of definition array see commebt in
    KeyboardMap >> #loadKeyboardMapDefinition: .

    To remove a mapping, use the same value for both logical and physical key,
    as in:

        |m|

        m := Display keyboardMap.
        m bindValue:#Cmdd to:#Cmdd.

    [see also:]
        WindowEvent WindowSensor WindowGroup
        View DeviceWorkstation
        KeyboardMap >> #loadKeyboardMapDefinition:

    [author:]
        Claus Gittinger
        Jan Vrany
"
! !

!KeyboardMap class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!KeyboardMap methodsFor:'accessing'!

mappedKeys
    "Return a set of all raw keys which are mapped to a logical key.
     This method consult both - (primary) bindings and (secondary) aliases."

    ^ bindings keys , aliases keys , (parent isNil ifTrue:[ #() ] ifFalse:[ parent mappedKeys ])

    "
    Screen current keyboardMap mappedKeys

    KeyboardMap new
        parent: Screen current keyboardMap mappedKeys;
        mappedKeys    
        
    "

    "Created: / 17-05-2017 / 15:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mappingFor:rawKey 
    "Given a `rawKey` return coresponding logical key. This method
     consults both - (primary) bindings and (secondary) aliaes.
     Example:
        #Ctrlx -> #Cut
        #F13 -> F13 (no mapping)"
    
    | value |

    current notNil ifTrue:[
        value := current mappingFor: rawKey.
        value isKeyboardMap ifTrue:[ 
            current := value.
            ^ nil.
        ].
    ].        

    value := bindings at:rawKey ifAbsent:[ nil ].
    value isKeyboardMap ifTrue:[
        current := value.
        ^ nil.
    ].
    (value isNil) ifTrue:[
        value := aliases at:rawKey ifAbsent:[ nil ].
        value isKeyboardMap ifTrue:[
            current := value.
            ^ nil.
        ].
    ].
    current := nil.
    value isNil ifTrue:[
        parent notNil ifTrue:[
            value := parent mappingFor:rawKey.
            (value notNil and:[ value ~= rawKey ]) ifTrue:[
                "/ Parent defines mapping for given rawKey.
                "/ We need to check whether the action is not
                "/ redefined here under different binding / alias,
                "/ if so, don't use parent's mapping!!
                ((bindings includes:value) or:[ aliases includes:value ]) ifTrue:[
                    "/ Treat this as mo mapping for given key, return it unmapped
                    ^ rawKey
                ].
            ].
            ^ value
        ].
         
        "/ No mapping for given key, return it unmapped
        
        ^ rawKey
    ].
    ^ value

    "
     KeyboardMap new
        bindValue: #Rename to: #F2;
        valueFor: #F10

     KeyboardMap new
        parent: (KeyboardMap new bindValue: #Rename to: #F2; yourself);
        valueFor: #F2"

    "Created: / 15-05-2017 / 21:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-05-2017 / 16:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent
    ^ parent
!

parent:aKeyboardMap
    parent := aKeyboardMap.
!

valueFor:rawKey
    <resource: #obsolete>
    "Given a `rawKey` return coresponding logical key. This method
     consults both - (primary) binding and aliaes.
     Example:
        #Ctrlx -> #Cut
        #F13 -> F13 (no mapping)
    "  
    self obsoleteMethodWarning: 'Use #mappingFor: instead'.  
    ^ self mappingFor:rawKey.  

    "
    KeyboardMap new 
        bindValue: #Rename to: #F2; 
        valueFor: #F2

    KeyboardMap new 
        parent: (KeyboardMap new bindValue: #Rename to: #F2; yourself);
        valueFor: #F2
    "

    "Modified: / 23-04-1996 / 21:55:22 / cg"
    "Modified: / 17-05-2017 / 16:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap methodsFor:'copying'!

postCopy
    current := nil.
    bindings := bindings copy.
    aliases := aliases copy.

    "Created: / 12-05-2017 / 22:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    bindings := IdentityDictionary new.
    aliases := IdentityDictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 11-05-2017 / 21:44:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap methodsFor:'mapping'!

bindAlias:logicalKey to:rawKey
    "Bind shortcut alias to logical action. For example, to bind
     copy action to Alt-C, do

     keyboardMap bindAlias: #Copy to: #Altc

     Use this one only if you're sure you want to bind an alternative
     shortcut (alias). For primary shortcuts, please use
     #bindValue:to:
    "
    (aliases includesKey: rawKey) ifTrue:[ 
         Logger warning:'Trying to bind alias (%1) to a logical action (%2) which is already bound (to %3). Removing old alias.' with: rawKey with: logicalKey with: (aliases at: rawKey).
    ]. 

    rawKey == logicalKey ifTrue:[
        aliases removeKey:rawKey ifAbsent:nil.
    ] ifFalse:[
        aliases at:rawKey put:logicalKey
    ]

    "Modified: / 12-05-2017 / 23:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bindValue:logicalKey to:rawKey
    "Bind shortcut alias to logical action. For example, to bind
     copy action to Alt-C, do

     The event mechanism uses this to pass logical keyboard events
     to the application (such as #Copy, #Cut etc.) 
     instead of physical ones (such as #AltC, #AltX)"

    "/ Issue a warning if logical key is already bound to a shortcut
    "/ to track possibly unwanted aliases. If you really want to
    "/ bind an alias, use #bindAlias:to:

    | binding |

    binding := bindings keyAtValue: logicalKey.
    binding notNil ifTrue:[ 
        Logger warning:'Trying to bind shortcut (%1) to a logical action (%2) which is already bound (to %3). Removing old shortcut,' with: rawKey with: logicalKey with: binding.
    ]. 
    bindings removeKey: binding ifAbsent: nil.

    rawKey == logicalKey ifTrue:[
        bindings removeKey:rawKey ifAbsent:nil
    ] ifFalse:[
        bindings at:rawKey put:logicalKey
    ]

    "Modified: / 12-11-1996 / 10:30:56 / cg"
    "Modified: / 12-05-2017 / 23:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bindValue:logicalKey to:key1 followedBy:key2
    "bind aLogicalKey to a sequence of two rawKeys.
     The event mechanism uses this to pass logical keyboard events
     to the application (such as #Copy, #Cut etc.) 
     instead of physical ones (such as #AltC, #AltX)"

    |submap|

    submap := bindings at:key1 ifAbsent:[].
    submap isNil ifTrue:[
        submap := KeyboardMap new.
        bindings at:key1 put:submap.
    ].
    submap bindValue:logicalKey to: key2

    "Modified: / 23-04-1996 / 21:55:04 / cg"
    "Modified: / 11-05-2017 / 21:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unbindAlias: rawKey
    "Remove (secondary) alias for given `rawKey`. If `rawKey` is not bound
     calling #unbindAlias: is noop."

    bindings removeKey: rawKey ifAbsent: nil.

    "Created: / 17-05-2017 / 15:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unbindValue: rawKey
    "Remove (primary) binding for given `rawKey`. If `rawKey` is not bound
     calling #unbindValue: is noop."

    bindings removeKey: rawKey ifAbsent: nil.

    "Created: / 17-05-2017 / 15:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap methodsFor:'queries'!

aliasesForLogical: logicalKey
    "Return all aliases for given (possibly) logical key.
     Example:
       #Copy -> #(Altc CtrlInsert) - depending on mappings
    "
    | rawKeys |
    rawKeys := #().
    aliases keysAndValuesDo:[:raw :logical |
        (logicalKey == logical) ifTrue:[ 
            rawKeys := rawKeys copyWith: raw.
        ].
    ].
    parent notNil ifTrue:[ 
        rawKeys := rawKeys , (parent aliasesForLogical: logicalKey)
    ].
    ^ rawKeys


    "/ First, search for primary bindings...


    "
    Screen current keyboardMap rawKeysForLogical: #Copy
    "

    "Created: / 15-05-2017 / 21:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bindingForLogical: logicalKey
    "Return binding for given (possibly) logical key.
     If no binding is defined, returns nil.
     Example:
       #Copy -> #Ctrlc - depending on mappings
    "
    | rawKey |
    rawKey := bindings keyAtValue: logicalKey.
    rawKey notNil ifTrue:[ ^ rawKey ].
    parent notNil ifTrue:[ ^ parent bindingForLogical: logicalKey ].
    ^ nil

    "
    Screen current keyboardMap bindingForLogical: #Copy
    Screen current keyboardMap bindingForLogical: #Bogus
    "

    "Created: / 15-05-2017 / 21:14:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 17-05-2017 / 16:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasBindingFor:rawKey
    <resource: #obsolete>
    self obsoleteMethodWarning:'Use #hasMappingFor: instead'.
    ^ self hasMappingFor: rawKey

    "Created: / 17-05-2017 / 15:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasMappingFor:rawKey
    "Return true if receiver maps given rawKey into a logical key,
     false otheriwse. Thic method consults both - (primary) bindings
     and (secondary) aliases."

    | logicalKey |

    logicalKey := self mappingFor:rawKey.
    ^ logicalKey notNil and:[ logicalKey ~= rawKey ]

    "
     KeyboardMap new
        bindValue: #Rename to: #F2;
        hasMappingFor: #F2

     KeyboardMap new
        bindValue: #Rename to: #F2;
        hasMappingFor: #F10

     KeyboardMap new
        parent: (KeyboardMap new bindValue: #Rename to: #F2; yourself);
        hasMappingFor: #F2

     KeyboardMap new
        parent: (KeyboardMap new bindValue: #Rename to: #F2; yourself);
        hasMappingFor: #F10
"

    "Modified: / 15-05-2017 / 21:35:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 17-05-2017 / 15:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rawKeysForLogical: logicalKey
    <resource: #obsolete>
    "Return all raw keys for given (possibly) logical key.
     Example:
       #Copy -> #(Ctrlc CtrlInsert) - depending on mappings
    "
    | rawKey rawKeys |

    self obsoleteMethodWarning:'Use #bindingForLogical: and/or #aliasesForLogical:'.  

    rawKey := self bindingForLogical: logicalKey.
    rawKeys := rawKey notNil ifTrue:[ Array with: rawKey ] ifFalse:[ #() ].
    ^ rawKeys , (self aliasesForLogical: logicalKey)


    "
    Screen current keyboardMap rawKeysForLogical: #Copy
    "

    "Created: / 08-02-2017 / 23:43:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2017 / 21:29:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"

    Screen current keyboardMap valueFor: #Alti
    "Modified (comment): / 14-05-2017 / 10:44:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap methodsFor:'testing'!

isKeyboardMap
    ^ true
! !

!KeyboardMap methodsFor:'utilities'!

loadKeyboardMapDefinition: definitions
    "Load keyboard mapping from given `definition`. The `definition` is a collection
     mapping definitions. Each mapping definition is an array consisting of:

        #( <logical key>     <primary shortcut>  <aliases>?  <description>? )

    where:
        <logical key>   the symbolic name of the action as used in menu specs
                        #keyPress:x:y: methods and so on.
                        Examples: #Copy, #Find, #Undo

        <primary shortcut> the actual shortcut in Smalltalk/X key event notation.
                        This is the shortcut that will be shown in menus and/or
                        tooltips and so.
                        Examples: #Ctrlv (means Ctrl + V), CmdF (means Alt + Shift + F), F10

        <aliases>       an alternative shortcut or array of those. Aliases won't be shown in
                        menu items but one may define some for user's convenience (for exampple,
                        define aliases used in other environments so users using both can just
                        keep using them. Optional.
                        Examples: #Ctrlv, #(#Cmdv #ShiftInsert)

        <description>   A textual description of the action. This may be used to generate some
                        form of documentation. Optional.
                        Examples: 'DoIt - evaluate expression', 'Replace selection with today''s date'

    "
    definitions do:[:definition | 
        | logical shortcut aliases|

        logical := definition first.
        shortcut := definition second.
        "/ aliases are optional as well as description, so it may happen that third
        "/ element is description rather than alias. Hence the check.
        aliases := (definition size > 2) ifTrue:[ definition third ] ifFalse:[ #() ].
        aliases isSymbol ifTrue:[ aliases := Array with: aliases ].
        aliases isArray ifFalse:[ aliases := #() ].

        self bindValue: logical to: shortcut.
        aliases do:[:alias | self bindAlias: logical to: alias ]
    ].

    "
    KeyboardMap new loadKeyboardMapDefinition: #( (Paste Ctrlv (Cmdv CtrlInsert)) )
    KeyboardMap new loadKeyboardMapDefinition: #( (Paste Ctrlv Cmdv) )
    KeyboardMap new loadKeyboardMapDefinition: #( (Paste Ctrlv 'Paste') )   
    "

    "Created: / 12-05-2017 / 22:12:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-05-2017 / 10:24:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!KeyboardMap class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/KeyboardMap.st,v 1.15 2014-12-18 16:13:06 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

