"
 COPYRIGHT (c) 1990 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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

EditTextView subclass:#EditField
	instanceVariableNames:'leaveAction enabled clickAction crAction tabAction converter
		leaveKeys immediateAccept acceptOnLeave acceptOnReturn
		lengthLimit entryCompletionBlock entryCompletionCharacter
		passwordCharacter autoScrollHorizontally acceptOnTab
		acceptOnLostFocus acceptOnPointerLeave acceptIfUnchanged leaveKey
		doubleClickAction emptyFieldReplacementText leaveKeyActions'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor
		DefaultSelectionForegroundColor DefaultSelectionBackgroundColor
		DefaultBorderColor DefaultBorderWidth DefaultLevel'
	poolDictionaries:''
	category:'Views-Text'
!

!EditField class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    an editable text-field. Realized by using an EditTextView,
    and forcing its size to 1 line - disabling cursor movement
    in the vertical direction.

    Basically, an editField is an editor for a single line text,
    and provides the usual access protocol as defined in its superClasses
    (especially: #contents / #contents:).

    The above underlying internal mechanism can be used for fields which
    are passive; i.e. into which text can be entered and the value (string)
    is extracted actively by someone else.

    accepting:
      The opposite way to use editFields is to connect them to a model
      and let the field notify changes to it.
      This notification is called ``accepting''.
      Unless accepted, the models value is not updated from the editFields contents
      this default is the normal operation and way things should work, since most
      uses of editFields are not interested in every individual change
      (i.e. getting each keyStroke when a long number is entered).
      The default behavior is to ``accept'' when either return or a cursorUp/Down
      key is pressed in a field.
      However, the field can setup to accept/not accept on leave, on return
      or on each individual key input.
      See the methods #acceptOnLeave: / #acceptOnReturn: / #immediateAccept.

      In addition, the set of keys which are considered ``leaveKeys'' can be
      specified by #leaveKeys: (in case you need keys other than Return, CursorUp/Down).

    models value vs. field contents:
      Although the field internally keeps its contents as some string object,
      the application may prefer to think of numbers, floats, yes/no values etc.
      To support this, a converter may defined, which is responsible for conversion of
      strings to/from the models domain value.
      If present (i.e. nonNil), the converter is asked to convert a string to the models
      domain with #readValueFrom:aString and vice versa, a value to a string by #printStringFor:.
      The PrintConverter class already provides a number of standard conversions, see the examples.
      To access a converted value directly (i.e. not via the model), use #editValue.

    grouping:
      Individual fields do not know about being included in a group. This must be arranged on the
      outside, by placing multiple fields into an EnterFieldGroup.
      This groupObject keeps a reference to one active field, and forwards input from any other
      field to the active one. Also have a look at the examples for this.

    input completion:
      To support input completion (i.e. filename completion, classname completion etc.),
      a completionBlock can be defined which (if non-nil) is evaluated when the completion-key
      is pressed and its value is taken as the new field-contents. 
      The physical completion-key is the Tab key (this one cannot be defined by
      the keyboardTranslation mechanism, since that would disable the Tab-key on regular text views.



    [Instance variables:]

      leaveAction    <Block | nil>              if non-nil, this is evaluated with
                                                the key (#Return, #CursorUp etc.) when
                                                the field is left via keyboard keys.
                                                (fieldGroups use this to decide which
                                                 field has to be enabled next)

      enabled        <Boolean>                  if false, input is ignored.

      clickAction    <Block | nil>              action performed if the field is
                                                clicked upon.
                                                (this is used by the group to
                                                 set the active field to the clicked upon field)

      crAction       <Block | nil>              if non-nil, keyboard input of a cr are not
                                                handled specially, instead this block is evaluated
                                                (however, this block can perform additional checks and send
                                                 a #accept then)

      tabAction      <Block | nil>              if non-nil, keyboard input of a tab character
                                                is not entered into the text, instead this block
                                                is evaluated. Also, no input completion is performed if
                                                tabAction is nonNil.

      converter      <PrintConverter | nil>     if non-nil, this is supposed to convert between
                                                the object and its printed representation and vice versa.
                                                Defaults to nil i.e. assume that strings are edited.

      leaveKeys      <Collection>               keys which are interpreted as 'leaving the field'

      immediateAccept   <Boolean>               if true, every change of the text is immediately
                                                forwarded to the model/acceptBlock. If false,
                                                the changed value is only stored in the model
                                                if the field is left or accepted.
                                                Default is false.

      acceptOnLeave  <Boolean>                  if true, leaving the field (via cursor keys)
                                                automatically accepts the value into the model.
                                                Default is true.

      acceptOnReturn <Boolean>                  if true, leaving the field via return
                                                automatically accepts the value into the model.
                                                Default is true.

      acceptOnTab    <Boolean>                  if true, the Tab key accepts and leaves the field.
                                                If false, Tabs are entered into the contents field like
                                                ordinary non-control keys.
                                                AcceptOnTab is ignored if the entryCompletion block is nonNil.
                                                Default is true.

      lengthLimit    <Number>                   the max. number of allowed characters

      entryCompletionBlock <BlockOrNil>         if non-nil, this is evaluated to complete the entry
                                                when <entryCompletionCharacter> is pressed.
                                                Entry completion is used with Filenamefields or in the
                                                browser for classname/selector completion.
                                                Setting a nonNil entryCompletion disables acceptOnTab.

      entryCompletionCharacter <CharacterOrNil> if non-nil AND entryCompletionBlock is nonNil, that one
                                                is evaluated for completion. Typically used to complete
                                                a fileName (also, classNames in the browser)
                                                Default is #Tab.

      passwordCharacter     <CharacterOrNil>    if non-nil, typed input is replaced by this character
                                                for display. Used for secret-input fields (such as password entry).
                                                Default is nil.


    [author:]
        Claus Gittinger

    [see also:]
        DialogBox
        EnterFieldGroup
        EnterBox EnterBox2
        FilenameEditField EditTextView
"
!

examples 
"
    see more examples in EnterFieldGroup>>examples.


    Step-by-step introduction:


    basic field in some view:
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:0.0@0.0 in:top.
        field width:1.0.                                'let its height as-is'.

        top open
                                                                        [exEnd]


    forward input in topView to the field:
    (currently, the field does not know this - therefore,
     its been told here ... this may change)
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:0.0@0.0 in:top.
        field width:1.0.                                'let its height as-is'.

        top delegate:(KeyboardForwarder toView:field).
        field hasKeyboardFocus:true.
        top open
                                                                        [exEnd]


    to make it look better: set some inset:
                                                                        [exBegin]
        |top field spacing|

        top := StandardSystemView new.
        top extent:200@100.

        spacing := View viewSpacing.
        field := EditField origin:(0.0 @ spacing) in:top.
        field width:1.0.                                        'let its height as-is'.
        field leftInset:spacing; rightInset:spacing.

        top open
                                                                        [exEnd]


    give it an initial contents:
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.       

        field editValue:'hello world'.

        top open
                                                                        [exEnd]


    have it preselected:
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.     
        field editValue:'hello world' selected:true.

        top open
                                                                         [exEnd]


    have part of it preselected:
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.     

        field editValue:'hello world'.
        field selectFromCharacterPosition:1 to:5.

        top open
                                                                        [exEnd]


    set a size limit:
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.     
        field editValue:'hello'.

        field maxChars:8.

        top open
                                                                        [exEnd]


    set a size limit, initial width and stop it from scrolling
    notice: you may prefer a constant-pitch font (such as courier):
                                                                        [exBegin]
        |top field|

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field innerWidth:(field font widthOf:'00000000').     
        field editValue:'12345678'.

        field maxChars:8.
        field autoScroll:false.

        top open
                                                                        [exEnd]


    enable / disable:
                                                                        [exBegin]
        |top panel check field ena|

        top := StandardSystemView new.
        top extent:200@100.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel borderWidth:0.
        panel horizontalLayout:#left.
        panel horizontalInset:View viewSpacing.

        check := CheckBox label:'enable' in:panel.
        check turnOn.
        check action:[:onOff | onOff ifTrue:[field enable] ifFalse:[field disable]].

        panel add:(View new height:30; borderWidth:0).

        field := EditField in:panel.
        field width:1.0.     
        field editValue:'hello'.
        
        top open
                                                                        [exEnd]


    enable / disable using a channel:
                                                                        [exBegin]
        |top panel check field ena|

        top := StandardSystemView new.
        top extent:200@100.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel borderWidth:0.
        panel horizontalLayout:#left.
        panel horizontalInset:View viewSpacing.

        ena := true asValue.

        check := CheckBox label:'enable' in:panel.
        check model:ena.

        panel add:(View new height:30; borderWidth:0).

        field := EditField in:panel.
        field enableChannel:ena.
        field width:1.0.     
        field editValue:'hello'.

        top open
                                                                        [exEnd]


    use a converter:
      - numbers (default to 0):
                                                                        [exBegin]
        |top field spacing|

        top := StandardSystemView new.
        top extent:200@100.

        spacing := View viewSpacing.

        field := EditField origin:0.0 @ spacing in:top.
        field width:1.0.
        field horizontalInset:spacing.

        field converter:(PrintConverter new initForNumber).
        field editValue:1234.
        field acceptAction:[:value | Transcript showCR:value].
        field crAction:[field accept. top destroy].
        top open.
                                                                        [exEnd]

      - dates:
                                                                        [exBegin]
        |top field spacing|

        top := StandardSystemView new.
        top extent:200@100.

        spacing := View viewSpacing.

        field := EditField origin:0.0 @ spacing in:top.
        field width:1.0.
        field horizontalInset:spacing.

        field converter:(PrintConverter new initForDate).
        field editValue:Date today.
        field acceptAction:[:value | Transcript showCR:value class name , ' ' , value printString].
        field crAction:[field accept. top destroy].
        top open.
                                                                        [exEnd]


    setting immediateAccept, makes the field update with every key:

      - immediate accept numbers, defaulting to nil:
                                                                        [exBegin]
        |top field spacing|

        top := StandardSystemView new.
        top extent:200@100.

        spacing := View viewSpacing.

        field := EditField origin:0.0 @ spacing in:top.
        field width:1.0.
        field horizontalInset:spacing.

        field converter:(PrintConverter new initForNumberOrNil).
        field immediateAccept:true.
        field editValue:1234.
        field acceptAction:[:value | Transcript showCR:value].
        field crAction:[field accept. top destroy].
        top open.
                                                                        [exEnd]



    grouping multiple fields, and forward keyPres from the outer view to the active field
    (i.e. actually: to the group):
                                                                        [exBegin]
        |top field1 field2 field3 group|


        top := StandardSystemView new.
        top extent:200@100.

        field1 := EditField origin:(0.0 @ 0.0) in:top.
        field1 width:1.0.

        field2 := EditField origin:(0.0 @ 0.0) in:top.
        field2 width:0.5.
        field2 topInset:(field1 height); bottomInset:(field1 height negated).

        field3 := EditField origin:(0.5 @ 0.0) in:top.
        field3 width:0.5.
        field3 topInset:(field1 height); bottomInset:(field1 height negated).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.

        top delegate:(KeyboardForwarder to:group).

        top open.
                                                                        [exEnd]

        
    in addition: tell the group to close when the last field is left:
                                                                        [exBegin]
        |top field1 field2 field3 group|


        top := StandardSystemView new.
        top extent:200@100.

        field1 := EditField origin:(0.0 @ 0.0) in:top.
        field1 width:1.0.

        field2 := EditField origin:(0.0 @ 0.0) in:top.
        field2 width:0.5.
        field2 topInset:(field1 height); bottomInset:(field1 height negated).

        field3 := EditField origin:(0.5 @ 0.0) in:top.
        field3 width:0.5.
        field3 topInset:(field1 height); bottomInset:(field1 height negated).

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.
        group leaveAction:[top destroy].

        top delegate:(KeyboardForwarder to:group).

        top open.
                                                                        [exEnd]


    use a model:
    (see changing model value in inspector when return is pressed in the field)
                                                                        [exBegin]
        |top field model|

        model := 'hello world' asValue.

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.
        field model:model.
        field acceptOnReturn:true.

        top open.
        model inspect.
                                                                        [exEnd]


    like above, but also accept the value, when the focus is changed
    (i.e. out of the input field):
    (see changing model value in inspector)
                                                                        [exBegin]
        |top field model|

        model := 'hello world' asValue.

        top := StandardSystemView new.
        top extent:200@100.

        field := EditField origin:(0.0 @ 0.0) in:top.
        field width:1.0.
        field model:model.
        field acceptOnLostFocus:true.

        top open.
        InspectorView openOn:model monitor:'value'.
                                                                        [exEnd]


    two views on the same model (each accepts on return):
                                                                        [exBegin]
        |top1 top2 field1 field2 model|

        model := 'hello world' asValue.

        top1 := StandardSystemView new.
        top1 extent:200@100.
        field1 := EditField origin:(0.0 @ 0.0) in:top1.
        field1 width:1.0.
        field1 model:model.
        field1 acceptOnReturn:true.
        top1 open.

        top2 := StandardSystemView new.
        top2 extent:200@100.
        field2 := EditField origin:(0.0 @ 0.0) in:top2.
        field2 width:1.0.
        field2 model:model.
        field2 acceptOnReturn:true.
        top2 open.
                                                                        [exEnd]

    two views on the same model (no accept on return):
                                                                        [exBegin]
        |top1 top2 field1 field2 model|

        model := 'hello world' asValue.

        top1 := StandardSystemView new.
        top1 extent:200@100.
        field1 := EditField origin:(0.0 @ 0.0) in:top1.
        field1 width:1.0.
        field1 model:model; acceptOnReturn:false.
        top1 open.

        top2 := StandardSystemView new.
        top2 extent:200@100.
        field2 := EditField origin:(0.0 @ 0.0) in:top2.
        field2 width:1.0.
        field2 model:model; acceptOnReturn:false.
        top2 open.
                                                                        [exEnd]

    with immediate accept (every key updates the model):
                                                                        [exBegin]
        |top1 top2 field1 field2 model|

        model := 'hello world' asValue.

        top1 := StandardSystemView new.
        top1 extent:200@100.
        field1 := EditField origin:(0.0 @ 0.0) in:top1.
        field1 width:1.0.
        field1 model:model; immediateAccept:true.
        top1 open.

        top2 := StandardSystemView new.
        top2 extent:200@100.
        field2 := EditField origin:(0.0 @ 0.0) in:top2.
        field2 width:1.0.
        field2 model:model; immediateAccept:true.
        top2 open.
                                                                        [exEnd]

    just an example; a checkBox and an editField on the same model:
                                                                        [exBegin]
        |top1 top2 field1 box model|

        model := false asValue.

        top1 := StandardSystemView new.
        top1 extent:200@100.
        field1 := EditField origin:(0.0 @ 0.0) in:top1.
        field1 width:1.0.
        field1 converter:(PrintConverter new initForYesNo).
        field1 model:model.
        top1 open.

        top2 := StandardSystemView new.
        top2 extent:200@100.
        box := CheckBox on:model.
        box label:'on/off'.
        top2 add:box.
        top2 open.

        model inspect.
                                                                        [exEnd]


    multiple editFields on multiple models (value holders):
    (the fields are connected by a group to allow tabbing)
                                                                        [exBegin]
        |top panel group field1 field2 field3 box 
         v1 v2 v3 spacing|

        v1 := true asValue.
        v2 := 'some string' asValue.
        v3 := 1.2 asValue.

        top := StandardSystemView new.
        top extent:200@100.

        panel := VerticalPanelView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.

        spacing := View viewSpacing.

        field1 := EditField new.
        field1 width:1.0.
        field1 horizontalInset:spacing.
        field1 converter:(PrintConverter new initForYesNo).
        field1 model:v1.
        panel add:field1.

        field2 := EditField new.
        field2 width:1.0.
        field2 horizontalInset:spacing.
        field2 model:v2.
        panel add:field2.

        field3 := EditField new.
        field3 width:1.0.
        field3 horizontalInset:spacing.
        field3 converter:(PrintConverter new initForNumber).
        field3 model:v3.
        panel add:field3.

        group := EnterFieldGroup new.
        group add:field1; add:field2; add:field3.

        top openModal.

        Transcript showCR:v1 value.
        Transcript showCR:v2 value.
        Transcript showCR:v3 value.
                                                                        [exEnd]


    connecting fields:
    update field2 wehenever field1 is changed.
    (normally, the processing below (xChanged) is done in your application
     class, or in a complex model. For the demonstration below, we use
     a Plug to simulate the protocol.)
                                                                        [exBegin]
        |application top field1 field2 value1 value2|

        application := Plug new.
        application respondTo:#value1Changed
                         with:[value2 value:(value1 value isNil ifTrue:[nil]
                                                                ifFalse:[value1 value squared])].

        value1 := 1 asValue.
        value2 := 1 asValue.

        top := Dialog new.
        top extent:200@200.

        (top addTextLabel:'some number:') layout:#left.
        top addVerticalSpace.

        (top addInputFieldOn:value1 tabable:false) 
            converter:(PrintConverter new initForNumberOrNil);
            immediateAccept:true.
        top addVerticalSpace.

        (top addTextLabel:'squared:') layout:#left.
        top addVerticalSpace.
        (top addInputFieldOn:value2 tabable:false) 
            converter:(PrintConverter new initForNumberOrNil).

        value1 onChangeSend:#value1Changed to:application.

        top openModeless.
                                                                        [exEnd]


    two-way connect:
    each field updates the other (notice, that we have to turn off
    onChange: notification, to avoid an endless notification cycle)
                                                                        [exBegin]
        |application top field1 field2 value1 value2|

        application := Plug new.
        application respondTo:#value1Changed
                         with:[value2 retractInterestsFor:application.
                               value2 value:(value1 value isNil ifTrue:[nil]
                                                                ifFalse:[value1 value squared]).
                               value2 onChangeSend:#value2Changed to:application.
                              ].
        application respondTo:#value2Changed
                         with:[value1 retractInterestsFor:application.
                               value1 value:(value2 value isNil ifTrue:[nil]
                                                                ifFalse:[value2 value sqrt]).
                               value1 onChangeSend:#value1Changed to:application.
                              ].

        value1 := 1 asValue.
        value2 := 1 asValue.

        top := Dialog new.
        top extent:200@200.

        (top addTextLabel:'some number:') layout:#left.
        top addVerticalSpace.

        (top addInputFieldOn:value1 tabable:false) 
            converter:(PrintConverter new initForNumberOrNil);
            immediateAccept:true.
        top addVerticalSpace.

        (top addTextLabel:'squared:') layout:#left.
        top addVerticalSpace.
        (top addInputFieldOn:value2 tabable:false) 
            converter:(PrintConverter new initForNumberOrNil);
            immediateAccept:true.

        value1 onChangeSend:#value1Changed to:application.
        value2 onChangeSend:#value2Changed to:application.

        top openModeless.
                                                                        [exEnd]
"
! !

!EditField class methodsFor:'defaults'!

defaultBorderColor
    ^ DefaultBorderColor
!

defaultBorderWidth
    ^ DefaultBorderWidth
!

defaultLeaveKeys
    "return the set of keys which are taken as leave-keys.
     If the field is in an enterFieldGroup, all leave keys will be
     forwarded to the group and possible step to the next/previous field.
     Also, if acceptOnLeave is true, leave keys will store the current
     value into their model (if any)"

    ^ #(Return CursorUp CursorDown Next Previous Accept)
!

defaultLevel
    ^ DefaultLevel
!

defaultNumberOfLines
    "the number of lines in the field"

    ^ 1
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'editField.foregroundColor' 
                       #'editField.backgroundColor'
                       #'editField.selectionForegroundColor' 
                       #'editField.selectionBackgroundColor'
                       #'editField.font')>

    DefaultForegroundColor := StyleSheet colorAt:'editField.foregroundColor' default:Color black.
    DefaultBackgroundColor := StyleSheet colorAt:'editField.backgroundColor' default:Color white.
    DefaultSelectionForegroundColor := StyleSheet colorAt:'editField.selectionForegroundColor' default:nil.
    DefaultSelectionForegroundColor isNil ifTrue:[
        DefaultSelectionForegroundColor := StyleSheet colorAt:'selection.hilightForegroundColor' default:DefaultBackgroundColor.
    ].
    DefaultSelectionBackgroundColor := StyleSheet colorAt:'editField.selectionBackgroundColor' default:nil.
    DefaultSelectionBackgroundColor isNil ifTrue:[
        DefaultSelectionBackgroundColor := StyleSheet colorAt:'selection.hilightBackgroundColor' default:DefaultForegroundColor.
    ].
    DefaultFont := StyleSheet fontAt:'editField.font' default:nil.
    DefaultBorderColor := StyleSheet colorAt:'editField.borderColor' default:nil. 
    DefaultBorderWidth := StyleSheet at:'editField.borderWidth' default:nil.  
    DefaultLevel := StyleSheet at:'editField.level' default:nil. 

    "
     self updateStyleCache
    "

    "Modified: / 19-01-2011 / 22:34:35 / cg"
! !

!EditField methodsFor:'accepting'!

accept
    "accept the current contents by executing the accept-action and/or
     changeMessage.
     Do this only if the contents of the EditField differs
     from the printed representation of the model."

    |string|

    acceptEnabled == false ifTrue:[
        self beep.
        ^ self
    ].

    (acceptIfUnchanged not
     and:[model notNil
     and:[(self convertEditValueToString:model value) = self contents]]) ifTrue:[
        ^ self
    ].

    super accept.

    "a typeconverter can convert different strings to the same value 
     ('010' asInteger = '10' asInteger).
     Show the common string representation ('10') of the value"

    converter notNil ifTrue:[
        string := converter printStringFor:self editValue.
        string ~= self contents ifTrue:[
            self contents:string.
            self flash
        ].
    ].

    "Modified: 7.3.1997 / 11:06:00 / cg"
! !

!EditField methodsFor:'accessing-behavior'!

acceptIfUnchanged
    "return the acceptIfUnchanged flag setting.
     if set (the default), an accept notification is sent on accept,
     even if the fields value is the same. If cleared,
     the notification is suppressed, if the fields contents is the same."

    ^ acceptIfUnchanged
!

acceptIfUnchanged:aBoolean
    "if set (the default), an accept notification is sent on accept,
     even if the fields value is the same. If cleared,
     the notification is suppressed, if the fields contents is the same."

    acceptIfUnchanged := aBoolean
!

acceptOnLeave
    "returnr the acceptOnLeave flag. The default is false.
     If true, leaving the box (via return, cursor etc.) accepts my 
     string into the valueHolder (if any).
     (actually, the set of keys can be specified with #leaveKeys:)"

     ^ acceptOnLeave 
!

acceptOnLeave:aBoolean
    "set/clear the acceptOnLeave flag. The default is false.
     If true, leaving the box (via return, cursor etc.) accepts my 
     string into the valueHolder (if any).
     (actually, the set of keys can be specified with #leaveKeys:)"

     acceptOnLeave := aBoolean

    "Modified: 11.12.1996 / 16:47:25 / cg"
!

acceptOnLostFocus
    ^ acceptOnLostFocus
!

acceptOnLostFocus:aBoolean
    "set/clear the acceptOnLostFocus flag. The default is false.
     If true, a lost focus (via mouse-pointer motion etc.) accepts my 
     string into the valueHolder (if any)."

     acceptOnLostFocus := aBoolean

    "Modified: 16.12.1995 / 16:26:45 / cg"
    "Created: 11.12.1996 / 16:48:00 / cg"
!

acceptOnPointerLeave:aBoolean
    "set/clear the acceptOnPointerLeave flag. The default is false.
     If true, a pointer leave (via mouse-pointer motion etc.) accepts my 
     string into the valueHolder (if any)."

     acceptOnPointerLeave := aBoolean

    "Modified: / 16.12.1995 / 16:26:45 / cg"
    "Created: / 28.6.1999 / 18:07:38 / cg"
!

acceptOnReturn:aBoolean
    "set/clear the acceptOnReturn flag. The default is false.
     If true, leaving the box via return accepts my 
     string into the valueHolder (if any)."

     acceptOnReturn := aBoolean

    "Modified: 16.12.1995 / 16:25:34 / cg"
!

acceptOnTab:aBoolean
    "set/clear the acceptOnTab flag. The default is true.
     If true, a pressed Tab key accepts and leaves the box.
     If false, the Tab key is treated like any normal input character
     (i.e. inserted into the contents)."

     acceptOnTab := aBoolean

    "Created: 24.1.1996 / 13:13:37 / cg"
!

autoScroll:aBoolean
    "turn on/off automatic scrolling upon keyboard entry
     to make the cursor visible."

    autoScrollHorizontally := aBoolean
!

clickAction:aBlock
    "define an action to be evaluated when being clicked upon"

    clickAction := aBlock
!

converter
    "return the converter (if any)."

    ^ converter
!

converter:aConverter
    "set the converter. If non-nil,
     the converter is applied to the text to convert from the string
     representation to the actual object value and vice versa.
     The default converter is nil, meaning no-conversion
     (i.e. the edited object is the string itself."

    converter := aConverter
!

crAction:aBlock
    "define an action to be evaluated when the return key is pressed."

    crAction := aBlock
!

doubleClickAction:aBlock
    "define an action to be evaluated when being double clicked upon"

    doubleClickAction := aBlock
!

enabled
    "return true, if the field is enabled (i.e. accepts keyboard input)"

    ^ enabled ? true 

!

enabled:aBoolean
    "enable/disable the field; show/hide the cursor and allow/disallow input"

    enabled ~~ aBoolean ifTrue:[
        enabled := aBoolean.
        self updateBackground.
        super cursorShown:aBoolean
    ]

    "Modified: / 3.8.1998 / 17:52:18 / cg"
    "Created: / 30.3.1999 / 15:19:17 / stefan"
    "Modified: / 30.3.1999 / 16:00:43 / stefan"
!

entryCompletionBlock
    "the action to be evaluated when Tab (EntryCompletionCharacter) is pressed.
     The block gets the current contents and the field itself as optional arguments
     (i.e. it can be a 0, 1 or 2-arg block)."

    "/ read comment in entryCompletionBlockHolder: on why the following kludge is present
    entryCompletionBlock isBlock ifTrue:[
        ^ entryCompletionBlock
    ].
    ^ entryCompletionBlock value
!

entryCompletionBlock:aZeroOneOrTwoArgBlock
    "define an action to be evaluated when Tab (EntryCompletionCharacter) is pressed.
     The block gets the current contents and the field itself as optional arguments
     (i.e. it can be a 0, 1 or 2-arg block)."

    entryCompletionBlock := aZeroOneOrTwoArgBlock
!

entryCompletionBlockHolder:aZeroOneOrTwoArgBlock
    "a holder for an action to be evaluated when Tab (EntryCompletionCharacter) is pressed.
     The block gets the current contents and the field itself as optional arguments
     (i.e. it can be a 0, 1 or 2-arg block)."

    "/ for now (to avoid incompatibilities), misuse the existing
    "/ entryCompletionBlock and check if its a holder.

    entryCompletionBlock := aZeroOneOrTwoArgBlock
!

entryCompletionCharacter
    "return the value of the instance variable 'entryCompletionCharacter' (automatically generated)"

    ^ entryCompletionCharacter
!

immediateAccept:aBoolean
    "set/clear the immediateAccept flag. The default is false.
     If true, every pressed key immediately accepts my 
     string into the valueHolder (if any)."

     immediateAccept := aBoolean

    "Modified: 16.12.1995 / 16:25:57 / cg"
!

isAcceptOnLeave
    "return the acceptOnLeave flag. The default is false.
     If true, leaving the box (via return, cursor etc.) accepts my 
     string into the valueHolder (if any).
     (actually, the set of keys can be specified with #leaveKeys:)"

     ^ acceptOnLeave 

    "Modified: 11.12.1996 / 16:47:25 / cg"
!

isAcceptOnLostFocus
    "return the acceptOnLostFocus flag. The default is false.
     If true, a lost focus (via mouse-pointer motion etc.) accepts my 
     string into the valueHolder (if any)."

     ^ acceptOnLostFocus

    "Modified: 16.12.1995 / 16:26:45 / cg"
    "Created: 11.12.1996 / 16:48:00 / cg"
!

isAcceptOnReturn
    "return the acceptOnReturn flag. The default is false.
     If true, leaving the box via return accepts my 
     string into the valueHolder (if any)."

     ^ acceptOnReturn 

    "Modified: 16.12.1995 / 16:25:34 / cg"
!

isAcceptOnTab
    "return the acceptOnTab flag. The default is true.
     If true, a pressed Tab key accepts and leaves the box.
     If false, the Tab key is treated like any normal input character
     (i.e. inserted into the contents)."

     ^ acceptOnTab
!

isImmediateAccept
    "return the immediateAccept flag. The default is false.
     If true, every pressed key immediately accepts my 
     string into the valueHolder (if any)."

     ^ immediateAccept

    "Modified: 16.12.1995 / 16:25:57 / cg"
!

leaveAction:aBlock
    "define an action to be evaluated when field is left by a leave-key
     (by default: return or cursor keys.
     Actually, the set of keys can be specified with #leaveKeys:
     On leave, the precedence of actions is:
       1) explicit leaveAction per key
       2) this general leaveAction
       3) tab or return action
"

    leaveAction := aBlock

    "Modified: 16.12.1995 / 16:26:36 / cg"
!

leaveKey
    "only valid after the editField has been left via a leaveCharacter.
     Allows for users of the EditField to advance the selection 
     (especially: DataSets to select next/prev if editor is left via CrsrUp/Down)"

    ^ leaveKey
!

leaveKeys
    "return (a copy of) the collection of keys which are interpreted as leaveKeys.
     I.e. those that make the field inactive and pass the focus to the next field
     (and accept, if acceptOnLeave is true)"

    ^ leaveKeys copy
!

leaveKeys:aCollectionOfKeySymbols 
    "define the set of keys which are interpreted as leaveKeys.
     I.e. those that make the field inactive and accept (if acceptOnLeave is true).
     The default is a set of #CursorUp, #CursorDown, #Next, #Prior and #Return."

    leaveKeys := aCollectionOfKeySymbols
!

makeTabable
    "arrange for Tab to accept & leave the field
     If the field is part of a group, the next field gets the
     input focus"

    leaveKeys isNil ifTrue:[
        leaveKeys := self class defaultLeaveKeys
    ].
    leaveKeys := leaveKeys copyWith:#Tab

    "Created: 27.4.1996 / 17:09:48 / cg"
!

onKey:aKey leaveWith:aBlock
    "arrange for aKey to leave the field and evalaute aBlock.
     On leave, the precedence of actions is:
       1) explicit leaveAction per key
       2) general leaveAction
       3) tab or return action
     Can be used to arrange for cursorDown to pass focus to another widget."

    leaveKeys := leaveKeys asOrderedCollection.
    leaveKeys add:aKey.
    leaveKeyActions isNil ifTrue:[
        leaveKeyActions := Dictionary new.
    ].
    leaveKeyActions at:aKey put:aBlock.
!

readOnly:aBoolean
    "make the text readonly or writable"

    super readOnly:aBoolean.
    self updateBackground.

    "Created: / 26.7.1998 / 21:23:17 / cg"
    "Modified: / 3.8.1998 / 17:52:38 / cg"
!

returnKeyIsFocusNext
    "arrange for the return key to act as a focus-next key"

    leaveKeys := leaveKeys copyAsOrderedCollection. 
    leaveKeys remove:#Return ifAbsent:nil
!

tabAction:aBlock
    "define an action to be evaluated when the tabulator key is pressed."

    tabAction := aBlock
!

tabKey:aKeySymbol 
    "arrange for aKeySymbol to accept & leave the field
     If the field is part of a group, the next field gets the
     input focus"

    leaveKeys isNil ifTrue:[
        leaveKeys := self class defaultLeaveKeys
    ].
    leaveKeys := leaveKeys copyWith:#Tab

    "Created: 27.4.1996 / 17:08:54 / cg"
! !

!EditField methodsFor:'accessing-contents'!

contents
    "return contents as a string
     - redefined since EditFields hold only one line of text.
    In your application, please use #editValue; 
    it uses a converter (if any) and is compatible to ST-80."

    (list isEmptyOrNil) ifTrue:[^ ''].
    ^ list at:1
!

contents:someText
    "set the contents from a string
     - redefined to place the cursor to the end.
    In your application, please use #editValue: - 
    it uses a converter (if any) and is compatible to ST-80."

    |newCol txt|

    newCol := cursorCol.

    someText isNil ifTrue:[
        txt := ''.
    ] ifFalse:[
        txt := someText asString.
    ].
    super contents:txt.

    (cursorMovementWhenUpdating == #endOfLine
    or:[cursorMovementWhenUpdating == #endOfText
    or:[cursorMovementWhenUpdating == #end]]) ifTrue:[
         newCol := (txt size + 1).
    ] ifFalse:[
        (cursorMovementWhenUpdating == #beginOfLine
        or:[cursorMovementWhenUpdating == #beginOfText
        or:[cursorMovementWhenUpdating == #begin]]) ifTrue:[
            newCol := 1
        ] ifFalse:[
            "/ default: stay where it was
        ]
    ].

    self cursorCol:newCol.

    "Modified: / 13.11.1999 / 13:50:30 / cg"
!

convertEditValueToString:aStringOrObject
    "convert a aStringOrObject to a printed representation. 
     If there is a converter, use it to convert
     the object into a printed representation.
     Use asString to convert the object,
     and used directly."

    converter notNil ifTrue:[
        ^ converter printStringFor:aStringOrObject
    ].

    aStringOrObject isNil ifTrue:[
        ^ ''.
    ].
    ^ aStringOrObject asString.
!

editValue
    "if the field edits a string, this is a name alias for #contents.
     Otherwise, if there is a converter, return the edited string
     converted to an appropriate object."

    |string|

    string := self contents.
    string isNil ifTrue:[string := ''].
    converter isNil ifTrue:[^ string].
    ^ converter readValueFrom:string 
!

editValue:anObject
    "set the contents. If there is a converter, use it to convert
     the object into a printed representation.
     Otherwise, convert anObject to a string using #asString
     (this is equivalent to sending #contents:)."

    self editValue:anObject selected:false
!

editValue:anObject selected:isSelected
    "set the contents. If there is a converter, use it to convert
     anObject into a printed representation.
     Otherwise, use anObject asString
     (i.e. this is equivalent to sending #initialText:selected:)."

    |string|

    string := self convertEditValueToString:anObject.
    self contents:string.
    isSelected ifTrue:[
        self selectFromLine:1 col:1 toLine:1 col:string size.
    ]
!

initialText:aString
    "set the initialText and select it.
     Better use #editValue: - it uses the type converter."

    self initialText:aString selected:true
!

initialText:aString selected:isSelected
    "set the initialText and select it if isSelected is true
     Better use #editValue:selected: - it uses the type converter."

    |len s|

    viewOrigin := 0 @ viewOrigin y.

    self contents:aString.
    isSelected ifTrue:[
        s := self contents.
        len := s size.
        len ~~ 0 ifTrue:[
            self selectFromLine:1 col:1 toLine:1 col:len
        ]
    ].
!

list:someText
    "low level access to the underlying contents' list.
     Redefined to force text to 1 line, and notify dependents
     of any changed extent-wishes (for automatic box resizing)."

    |l oldWidth|

    l := someText.
    l notEmptyOrNil ifTrue:[
        l := OrderedCollection with:(l at:1)
    ].
    oldWidth := self widthOfContents.
    super list:l.
    self widthOfContents ~~ oldWidth ifTrue:[
        self changedPreferredBounds:nil
    ]

    "Modified: 6.3.1997 / 16:13:36 / cg"
!

stringValue
    "alias for #contents - for compatibility with ST-80's InputField"

    ^ self contents
! !

!EditField methodsFor:'accessing-look'!

bePassword
    "make me a password entry field (i.e. show *'s for typed characters"

    self passwordCharacter:$*
!

emptyFieldReplacementText
    "the string to show in grey if nothing has been entered (and the field is passive)"

    ^ emptyFieldReplacementText
!

emptyFieldReplacementText:something
    "the string to show in grey if nothing has been entered (and the field is passive)"

    emptyFieldReplacementText := something.
!

font:aFont
    super font:aFont.
    realized ifTrue:[ self computeTopMargin ].
!

maxChars
    "return the maximum number of characters that are allowed in
     the field. 
     A limit of nil means: unlimited. This is the default."

    ^ lengthLimit

    "Modified: 6.9.1995 / 13:43:33 / claus"
!

maxChars:aNumberOrNil
    "set the maximum number of characters that are allowed in
     the field. Additional input will be ignored by the field.
     A limit of nil or zero means: unlimited. This is the default.
     If set, a lengthLimit must be defined before any contents is placed
     into the field, because the contents is not cut when the max is
     changed later. I.e. it should be set early after creation of the field.

     This method has been renamed from #lengthLimit: for ST-80
     compatibility."

    aNumberOrNil == 0 ifTrue:[
        lengthLimit := nil
    ] ifFalse:[
        lengthLimit := aNumberOrNil.
    ]
!

passwordCharacter
    "return the passwordCharacter;
     If nonNil, that one is replacing typed input
     (for secret input)"

    ^ passwordCharacter

    "Modified: 6.9.1995 / 12:25:39 / claus"
    "Modified: 16.12.1995 / 16:24:25 / cg"
!

passwordCharacter:aCharacter
    "set the passwordCharacter;
     If nonNil, that one is replacing typed input
     (for secret input)"

    passwordCharacter := aCharacter

    "Modified: 6.9.1995 / 12:25:33 / claus"
    "Modified: 16.12.1995 / 16:24:33 / cg"
! !

!EditField methodsFor:'cursor drawing'!

cursorShown:aBoolean
    "make cursor visible if currently invisible - but only if this
     EditField is enabled. 
     Return the previous cursor-shown-state"

    ^ super cursorShown:(aBoolean and:[enabled and:[self isReadOnly not]])

    "Created: / 30.3.1999 / 16:00:25 / stefan"
    "Modified: / 1.4.1999 / 11:18:38 / cg"
!

drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fg and:bg
    startVisLineNr to:endVisLineNr do:[:visLine |
	self drawVisibleLine:visLine with:fg and:bg
    ]

    "Modified: 6.9.1995 / 12:24:29 / claus"
! !

!EditField methodsFor:'cursor movement'!

cursorDown
    "catch cursor movement"

    (cursorVisibleLine == nLinesShown) ifFalse:[
	super cursorDown
    ]
!

cursorLine:line col:col
    "catch cursor movement"

    super cursorLine:1 col:col
!

cursorLine:line col:col makeVisible:aBoolean
    "catch cursor movement"

    super cursorLine:1 col:col makeVisible:aBoolean
!

validateCursorCol:col inLine:line
    "check of col is a valid cursor position;
     return a fixed value if not."

    |sz|

    sz := self contents size.
    lengthLimit notNil ifTrue:[
        sz := sz min:lengthLimit.
    ].

    col <= sz ifTrue:[
        ^ col
    ].
    ^ sz + 1.  "/ to allow positioning right behind the string

    "Created: 22.5.1996 / 18:17:27 / cg"
    "Modified: 22.5.1996 / 18:19:04 / cg"
! !

!EditField methodsFor:'drag & drop'!

dropFileObject:aDropObject
    "drop objects
     Redefined to always drop the name only"

    self 
        undoablePasteReplacingAll:(aDropObject asFilename pathName) 
        info:'Drop Filename'.

    "Created: / 13-10-2006 / 17:42:22 / cg"
    "Modified: / 28-07-2007 / 13:27:32 / cg"
! !

!EditField methodsFor:'editing'!

paste:someText
    "redefined to force text to 1 line"

    super paste:someText.
    list size > 1 ifTrue:[
	self deleteFromLine:2 toLine:(list size)
    ]
! !

!EditField methodsFor:'event handling'!

buttonPress:button x:x y:y
    "enable myself on mouse click"

    |prevFocus|

    enabled ifTrue:[
        prevFocus := hasKeyboardFocus.
        clickAction notNil ifTrue:[
            clickAction value:self
        ].
        hasKeyboardFocus ~~ prevFocus ifTrue:[
            ^ self
        ].
    ].
    super buttonPress:button x:x y:y

"/    enabled ifFalse:[
"/        enabled := true.
"/        super buttonPress:button x:x y:y.
"/        enableAction notNil ifTrue:[
"/            enableAction value
"/        ]
"/    ] ifTrue:[
"/        super buttonPress:button x:x y:y
"/    ]

    "Modified: 22.5.1996 / 15:02:45 / cg"
!

canHandle:aKey
    "return true, if the receiver would like to handle aKey
     (usually from another view, when the receiver is part of
      a more complex dialog box).
     We do return true here, since the editfield will handle
     all keys.
     OBSOLETE: don't use this anymore - its a leftover for the tableWidget"

    ^ true
!

doubleClickX:x y:y
    doubleClickAction notNil ifTrue: [
        doubleClickAction value.
    ].

    super doubleClickX:x y:y
!

handleCompletionService
    "none here"

    ^ self
!

handleFocusKey:key
    "handle a focus key, to assign the focus to another field in my group"

    <resource: #keyboard (#Tab #Return #CursorDown #CursorUp)>

    windowGroup isNil ifTrue:[^ self ].

    (key == #Tab) ifTrue:[
        (self tabRequiresControl not
        or:[ self sensor ctrlDown ]) ifTrue:[
            self sensor shiftDown ifTrue:[
                windowGroup focusPrevious
            ] ifFalse:[
                windowGroup focusNext
            ].
        ].
        ^ self
    ].

    (key == #Return) ifTrue:[
        windowGroup focusNext.
        ^ self
    ].

    key == #CursorDown ifTrue:[
        windowGroup focusNext.
        ^ self.
    ].
    key == #CursorUp ifTrue:[
        windowGroup focusPrevious.
        ^ self.
    ].

    "Created: / 06-03-2007 / 20:14:04 / cg"
!

keyPress:key x:x y:y
    "if keyHandler is defined, pass input; otherwise check for leave
     keys"

    <resource: #keyboard (#Tab #Return #Find #FindNext #FindPrev
                          #DeleteLine #GotoLine #EndOfLine #EndOfText
                          #CursorDown #CursorUp)>

    |leave oldContents newContents doAccept keyAction numArgs|

    enabled ifFalse:[
        ^ self
    ].

    (key == #DeleteLine) ifTrue:[
        Smalltalk at:#CopyBuffer put:(self contents).
        self contents:''. 
        ^ self
    ].

    (key == entryCompletionCharacter and:[self entryCompletionBlock notNil]) ifTrue:[
        oldContents := self contents.
        oldContents isNil ifTrue:[
            oldContents := ''
        ] ifFalse:[
            oldContents := oldContents asString
        ].

        self entryCompletionBlock valueWithOptionalArgument:oldContents and:self.

        newContents := self contents.
        newContents isNil ifTrue:[
            newContents := ''
        ] ifFalse:[
            newContents := newContents asString
        ].
        newContents ~= oldContents ifTrue:[
            self textChanged
        ].
        ^ self
    ].

    (key == #Tab) ifTrue:[
        doAccept := acceptOnTab.
        keyAction := tabAction.
    ].
    (key == #Return) ifTrue:[
        doAccept := acceptOnReturn.
        keyAction := crAction.
    ].

    leave := leaveKeys includes:key.
    leave ifTrue:[
        leaveKey := key.
        doAccept := doAccept ? acceptOnLeave.

        "/ on leave, the precedence of actions is:
        "/  1) explicit leaveAction per key
        "/  2) general leaveAction
        "/  3) tab or return action
        leaveKeyActions notNil ifTrue:[
            keyAction := leaveKeyActions at:key ifAbsent:[keyAction].
        ].
        keyAction := keyAction ? leaveAction.
    ].

    doAccept == true ifTrue:[
        self accept.
    ].

    keyAction notNil ifTrue:[
        numArgs := keyAction numArgs.

        numArgs == 2 ifTrue:[
            ^ keyAction value:self value:key
        ].
        numArgs == 0 ifTrue:[
            ^ keyAction value
        ].
        ^ keyAction value:key
    ].

    leave ifTrue:[
        (x notNil and:[x >= 0]) ifTrue:[
            "
             we do not handle this key directly.
             let superview know about the key that caused us to leave (maybe RETURN, DOWN, UP etc....
            "
            (superView notNil and:[superView canHandle:key from:self]) ifTrue:[
                superView keyPress:key x:x y:y.
            ].
        ].

        "/ a leave, but no action defined
        "/ forward it as a Focus-step
        key == #CursorDown ifTrue:[
            self handleFocusKey:key.
            ^ self.
        ].
        key == #CursorUp ifTrue:[
            self handleFocusKey:key.
            ^ self.
        ].
        ^ self
    ].

    "
     ignore some keys (if not a leaveKey) ...
    "
    (key == #Find) ifTrue:[^self].
    (key == #FindNext) ifTrue:[^self].
    (key == #FindPrev) ifTrue:[^self].
    (key == #GotoLine) ifTrue:[^self].
    "
     a normal key - let superclass's method insert it
    "
    super keyPress:key x:x y:y.

    "
     for end-of-text, also move to end-of-line
    "
    key == #EndOfText ifTrue:[
        super keyPress:#EndOfLine x:x y:y.
    ].

    self resizeOrScroll.

    "Modified: / 02-05-1996 / 17:24:16 / stefan"
    "Modified: / 17-01-2011 / 11:26:08 / cg"
!

keyboardZoom:larger
    "/ ignored here
!

pointerLeave:state
    (acceptOnPointerLeave and:[enabled and:[self modified]]) ifTrue:[
        self accept
    ].
    super pointerLeave:state

    "Modified: / 28.6.1999 / 18:08:29 / cg"
!

resizeOrScroll
    "helper for keyPress.
     Extracted for easier subclass redefinition."

    |xCol newOffset newWidth|

    newWidth := self widthOfContents.

    "
     should (& can) we resize ?
    "
    xCol := (self xOfCol:cursorCol inVisibleLine:cursorLine) - viewOrigin x.
    (xCol > (width * (5/6))) ifTrue:[
        self changedPreferredBounds:nil
    ] ifFalse:[
        newWidth < (width * (1/6)) ifTrue:[
            self changedPreferredBounds:nil
        ]
    ].

    autoScrollHorizontally ifTrue:[
        "
         did someone react (i.e. has my extent changed) ?
         (if not, we scroll horizontally)
        "
        lengthLimit notNil ifTrue:[
            (self xOfCol:lengthLimit+1 inVisibleLine:cursorLine) <= self innerWidth
            ifTrue:[
                ^ self
            ].
        ].

        xCol := (self xOfCol:cursorCol inVisibleLine:cursorLine) - viewOrigin x.
        (xCol > (width * (5/6))) ifTrue:[
            newOffset := viewOrigin x + (width // 2).
        ] ifFalse:[
            (xCol < (width * (1/6))) ifTrue:[
                newOffset := 0 max: viewOrigin x - (width // 2).
            ] ifFalse:[
                newOffset := viewOrigin x
            ]
        ].
        newOffset ~~ viewOrigin x ifTrue:[
            self scrollHorizontalTo:newOffset.
        ]
    ].

    "Modified: 6.3.1997 / 16:13:59 / cg"
!

sizeChanged:how
    "scroll to origin, if all fits"

    |xCol|

    viewOrigin x ~~ 0 ifTrue:[
        xCol := self xOfCol:cursorCol inVisibleLine:cursorLine.
        (xCol < (width * (5/6))) ifTrue:[
            self scrollHorizontalTo:0
        ].
    ].
    self makeCursorVisible.
    super sizeChanged:how.
    self computeTopMargin.

    "Modified: 10.7.1996 / 10:59:37 / cg"
!

tripleClickX:x y:y
    "triple-click - select all"

    self selectAll

    "Created: / 09-04-2014 / 19:04:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditField methodsFor:'focus handling'!

hasKeyboardFocus:aBoolean
    "the view got/lost the keyboard focus"

    |hadKeyboardFocus|

    hadKeyboardFocus := hasKeyboardFocus.
    super hasKeyboardFocus:aBoolean.

    (acceptOnLostFocus and:[enabled and:[aBoolean not and:[hadKeyboardFocus]]]) ifTrue:[
        model notNil ifTrue:[
            model value = self argForChangeMessage ifTrue:[
                ^ self
            ]
        ].
        self accept.
    ].

    "Created: / 11.12.1996 / 16:57:50 / cg"
    "Modified: / 6.12.1997 / 14:07:12 / cg"
!

showFocus:explicit
    "the view got the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    "/ giving me the focus is like clicking on me
    "/ (tell my enterFieldGroup ...)


    (enabled or:[explicit]) ifTrue:[
        super showFocus:explicit.
        clickAction notNil ifTrue:[clickAction value:self].
        "/ mhmh - should we ALWAYS do this ?
        true "explicit" ifTrue:[ self makeCursorVisible ].
    ]

    "Modified: / 06-03-2007 / 21:11:17 / cg"
!

showNoFocus:explicit
    "the view lost the keyboard focus 
     (either explicit, via tabbing; or implicit, by pointer movement)
      - change any display attributes as req'd."

    self hideCursor.
    super showNoFocus:explicit

    "Modified: / 17.9.1998 / 15:10:04 / cg"
!

wantsFocusWithPointerEnter
    "return true, if I want the focus when
     the mouse pointer enters"

    ^ UserPreferences current focusFollowsMouse ~~ false
         and:[(styleSheet at:#'editField.requestFocusOnPointerEnter' default:true)
         and:[self enabled 
         and:[self isReadOnly not]]]
! !

!EditField methodsFor:'help'!

flyByHelpTextAt:aPoint
    |len|
    
    len := self widthOfContents.
    len > width ifTrue:[
        ^ self contents  
    ].
    ^ nil
! !

!EditField methodsFor:'initialization & release'!

computeTopMargin
    |innerHeight rest font fontHeight fontDescent|

    innerHeight := self innerHeight.
    innerHeight <= 0 ifTrue:[ textStartTop := 0. ^ self ].

    font := gc font.
    fontHeight := font height.
    fontDescent := font descent.
    rest := innerHeight - (fontHeight + (fontDescent // 2)).
    rest > 1 ifTrue:[
        textStartTop := (rest // 2) + margin + topMargin
    ] ifFalse:[
        "/ care if font is too high for my height: 
        "/ shift baseline towards the top, so that the same is cut off at both ends.
        "/ (the heuristic fontDescent//3) gives a few pixels more at the top)
        textStartTop := 1 "(fontDescent//3)" - ((font ascent + fontDescent - innerHeight) // 2).
    ].
!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#'editField.cursorType'
                       #'editField.cursorForegroundColor' 
                       #'editField.cursorBackgroundColor'
                       )>

    super initStyle.

    self computeTopMargin.

    DefaultBackgroundColor notNil ifTrue:[
        bgColor := DefaultBackgroundColor onDevice:device.
"/        bgColor ditherForm notNil ifTrue:[
"/            bgColor := (bgColor copy) exactOrNearestOn:device
"/        ].
        self viewBackground:bgColor.
    ].
    fgColor := DefaultForegroundColor.
    selectionFgColor := DefaultSelectionForegroundColor.
    selectionBgColor := DefaultSelectionBackgroundColor.

    "/ enable this, when the focus detection works correctly (in dialogs)
    cursorTypeNoFocus := #none.

    cursorType := styleSheet at:#'editField.cursorType' default:cursorType.

    cursorFgColor := styleSheet at:#'editField.cursorForegroundColor' default:cursorFgColor.
    cursorBgColor := styleSheet at:#'editField.cursorBackgroundColor' default:cursorBgColor.

    DefaultLevel notNil ifTrue:[
        self level:DefaultLevel.
    ].
    DefaultBorderWidth notNil ifTrue:[
        self borderWidth:DefaultBorderWidth.
        DefaultBorderColor notNil ifTrue:[
            self borderColor:DefaultBorderColor.
        ].
    ].

    "Modified: / 21-05-1998 / 15:38:14 / cg"
    "Modified (comment): / 05-10-2011 / 15:51:15 / az"
!

initialize
    |font|
    
    super initialize.
    font := gc font.
    self initialHeight:(font height + font descent + (topMargin * 2)).

    nFullLinesShown := 1.
    nLinesShown := 1.
    trimBlankLines := immediateAccept := acceptOnLostFocus := false.
    acceptOnPointerLeave := false.
    enabled := fixedSize := autoScrollHorizontally := true.
    acceptOnLeave := acceptOnReturn := acceptOnTab := true.
    cursorShown := true.
    entryCompletionCharacter := #Tab.
    acceptIfUnchanged := false.

    leaveKeys isNil ifTrue:[
        leaveKeys := self class defaultLeaveKeys.
    ].
    cursorMovementWhenUpdating := #endOfLine

    "Modified: / 28.6.1999 / 18:08:17 / cg"
! !

!EditField methodsFor:'menu actions'!

editMenu
    "return a popUpMenu for the receiver"

    <resource: #keyboard ( #Accept #Copy #Cut #Paste ) >
    <resource: #programMenu>

    |items m isReadOnly|

    isReadOnly := (self isReadOnly == true or:[enabled == false]).
    isReadOnly ifTrue:[
        items := #(
                ('Copy'   copySelection  Copy  )
                )
    ] ifFalse:[
        items := #(
                    ('Cut'    cut            Cut   )
                    ('Copy'   copySelection  Copy  )
                    ('Paste'  pasteOrReplace Paste )
                   ).
        (acceptAction notNil 
        or:[model notNil and:[changeMsg notNil]]) ifTrue:[
            immediateAccept ifFalse:[
                items := items , #(
                                        ('-'                     )
                                        ('Accept'  accept  Accept)
                                    ).
            ].
        ].
    ].

    isReadOnly ifFalse:[
        items := items ,
                    #(
                        ('-'                     )
                        ('Insert Unicode...'            insertUnicode )
                    ).
        CharacterSetView notNil ifTrue:[
            items := items ,
                        #(
                            ('Special Characters...'    specialCharacters  OpenSpecialCharacterWindow )
                        ).
        ].
    ].

    m := PopUpMenu itemList:items resources:resources.

    passwordCharacter notNil ifTrue:[
        m disable:#copySelection
    ].

    self hasSelectionForCopy ifFalse:[
        m disable:#copySelection
    ].
    self hasSelection ifFalse:[
        m disable:#cut
    ].
    isReadOnly ifTrue:[
        m disableAll:#(cut pasteOrReplace accept)
    ].

    ^ m

    "Modified: / 17-01-2011 / 11:24:22 / cg"
! !

!EditField methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    ^ #EditField
! !

!EditField methodsFor:'private'!

argForChangeMessage
    "redefined to send use converted value (if I have one)"

    |str|

    str := self editValue.
    (acceptIfUnchanged
    and:[model notNil
    and:[model value == self editValue]]) ifTrue:[
        "/ copy to force valueHolder to trigger
        str := str copy.
    ].
    ^ str
!

getListFromModel
    "redefined to acquire the text via the aspectMsg - not the listMsg,
     and to ignore updates resulting from my own change."

    |val|

    (model notNil and:[aspectMsg notNil]) ifTrue:[
        aspectMsg == #value ifTrue:[
            val := model value
        ] ifFalse:[
            val := model perform:aspectMsg
        ].

        "
         ignore updates from my own change
        "
        lockUpdates ifTrue:[
            lockUpdates := false.
            val = self editValue ifTrue:[
                ^ self
            ]
        ].

        self editValue:val.
    ]

    "Modified: / 23.4.1998 / 10:10:37 / cg"
!

startAutoScrollDown:y
    "no vertical scrolling in editfields"

    ^ false
!

startAutoScrollUp:y
    "no vertical scrolling in editfields"

    ^ false
!

textChanged
    "this is sent by mySelf (somewhere in a superclass) whenever
     my contents has changed. 
     A good place to add immediateAccept functionality and check for the
     lengthLimit."

    |string c|

    super textChanged.
    string := self contents.
    lengthLimit notNil ifTrue:[
	string size > lengthLimit ifTrue:[
	    c := cursorCol.
	    self contents:(string copyTo:lengthLimit).
	    self flash.
	    self cursorCol:c.
	]
    ].
    immediateAccept ifTrue:[
	self accept
    ]
!

textChangedButNoSizeChange
    "this is sent by mySelf (somewhere in a superclass) whenever
     my contents has changed. 
     A good place to add immediateAccept functionality."

    super textChangedButNoSizeChange.
    immediateAccept ifTrue:[
        self accept
    ]
!

updateBackground
    "make my background grey, whenever either readOnly or disable"

    |fg|

    backgroundChannel notNil ifTrue:[^ self].

    (self isReadOnly or:[enabled not]) ifTrue:[
        self backgroundColor:(View defaultViewBackgroundColor).
        enabled ifFalse:[
            fg := StyleSheet colorAt:'editField.disabledForegroundColor' default:nil.
            fg isNil ifTrue:[
                fg := StyleSheet colorAt:'button.disabledForegroundColor' default:Color gray.
            ].
            self foregroundColor:fg.
        ] ifTrue:[
            self foregroundColor:DefaultForegroundColor.
        ].
    ] ifFalse:[
        self backgroundColor:DefaultBackgroundColor.
        self foregroundColor:DefaultForegroundColor.
    ]

    "Modified: / 3.8.1998 / 18:40:11 / cg"
!

visibleAt:visLineNr
    "return the string at lineNr for display.
     If there is a password character, return a string consisting of those only."

    |s emptyText|

    s := super visibleAt:visLineNr.
    passwordCharacter notNil ifTrue:[
        ^ String new:(s size) withAll:passwordCharacter
    ].
    (s isEmptyOrNil  
    and:[ (emptyText := self emptyFieldReplacementText) notNil  
    and:[ self hasFocus not 
    and:[ visLineNr == 1 ]]])
    ifTrue:[
        ^ emptyText allItalic withColor:Color lightGray.
    ].

    ^ s

    "Modified: 6.9.1995 / 12:25:06 / claus"
! !

!EditField methodsFor:'queries'!

hasSelectionForCopy
    "return true, if there is a selection which can be copied."

    ^ passwordCharacter isNil and:[self hasSelection]
!

isInputField
    "return true, if the receiver is some kind of input view,
     i.e. it should (can) be part of an enterGroup.
     Return true here"

    ^ true

    "Created: 4.3.1996 / 11:32:34 / cg"
!

preferredExtent
    "return the preferred extent of this view.
     That is the width of the string plus some extra, 
     but not wider than half of the screen"

    |string w h f|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    string := self contents.
    (string isNil or:[string isBlank]) ifTrue:[
        w := fontWidth * 20.  "space for 20 characters"
    ] ifFalse:[
        "length of current contents +  50% space to type more characters"
        f := gc deviceFont.
        w := ((f widthOf:string) * 1.5) rounded. 
        w := w + margin + margin.
    ].
    w := w min:(device width // 2).

    "/ h := f maxHeight + (f maxDescent * 2) + (margin * 2).
    h := fontHeight + topMargin + (margin * 2).

    ^ w rounded @ h rounded

    "Modified: / 6.9.1995 / 19:24:06 / claus"
    "Modified: / 21.5.1998 / 02:13:35 / cg"
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not EditFieldSpec)"

    self class == EditField ifTrue:[^ InputFieldSpec].
    ^ super specClass

    "Modified: / 5.9.1995 / 17:28:27 / claus"
    "Modified: / 31.10.1997 / 19:48:59 / cg"
!

tabMeansNextField
    "return true, if Tab character should shift focus to the next field"

    "if I have a completionBlock, I want my Tabs ..."

    ^ self entryCompletionBlock isNil or:[entryCompletionCharacter ~~ #Tab]

    "Created: 7.2.1996 / 19:16:38 / cg"
! !

!EditField methodsFor:'realization'!

realize
    "scroll back to beginning when realized"

    viewOrigin := 0 @ viewOrigin y.
    super realize

    "Created: 24.7.1997 / 18:23:15 / cg"
! !

!EditField methodsFor:'scrolling'!

makeColVisible:col inLine:lineNr
    "don't scroll for the cursor, if its beyond the text and a lengthLimit
     is present."

    |wText innerWidth colToMakeVisible|

    innerWidth := self innerWidth.
    colToMakeVisible := col.

    lengthLimit notNil ifTrue:[
        (self xOfCol:col inVisibleLine:1) <= innerWidth
        ifTrue:[
            ^ self
        ].
        (self xOfCol:lengthLimit inVisibleLine:1) <= innerWidth
        ifTrue:[
            ^ self
        ].
        (col == cursorCol and:[col > lengthLimit]) ifTrue:[
            colToMakeVisible := lengthLimit
        ].
    ].

    super makeColVisible:colToMakeVisible inLine:lineNr.

    "/ new:
    "/ care to make the most possible visible
    viewOrigin x > 0 ifTrue:[
        wText := self widthOfLine:lineNr.
        wText <= innerWidth ifTrue:[
            self scrollHorizontalTo:0
        ]
    ]

    "Modified: / 06-09-1995 / 13:57:53 / claus"
    "Modified: / 04-08-2010 / 17:30:17 / cg"
! !

!EditField methodsFor:'selections'!

copySelection
    "refuse to copy a password to the clipboard"

    passwordCharacter notNil ifTrue:[
        self beep.
        ^ self
    ].
    ^ super copySelection
!

selectAll
    "select the whole text.
     redefined to send super selectFrom... since we don't want the
     cursor to be moved in this case."

    |len|

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        len := (self listAt:1) size.
        len ~~ 0 ifTrue:[
            self selectFromLine:1 col:1 toLine:1 col:len.
        ].
        typeOfSelection := nil
    ]

    "Modified: 28.2.1997 / 19:16:21 / cg"
!

selectFrom:firstColToSelect
    "select the right part of the text"

    |len|

    list isNil ifTrue:[
        self unselect
    ] ifFalse:[
        len := (self listAt:1) size.
        firstColToSelect <= len ifTrue:[
            self selectFromLine:1 col:firstColToSelect toLine:1 col:len.
        ].
        typeOfSelection := nil
    ]
!

setClipboardText:aString
    "redefined to refuse to copy the password to the clipboard"

    passwordCharacter notNil ifTrue:[
        self beep.
        ^ self
    ].
    ^ super setClipboardText:aString

    "Modified (format): / 21-11-2016 / 23:37:07 / cg"
!

setLastStringToReplace: sel
    "redefined to refuse to remember the password"

    passwordCharacter notNil ifTrue:[
        ^ self
    ].
    ^ super setLastStringToReplace: sel
!

validateNewSelection
    "make certain that only one line is ever selected"

    selectionEndLine notNil ifTrue:[
        selectionEndLine > 1 ifTrue:[
            selectionEndLine := 2. selectionEndCol := 0
        ]
    ].
! !

!EditField class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

