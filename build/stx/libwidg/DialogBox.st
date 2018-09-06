"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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

ModalBox subclass:#DialogBox
	instanceVariableNames:'buttonPanel okButton okAction abortButton abortAction
		acceptReturnAsOK yPosition leftIndent rightIndent addedComponents
		inputFieldGroup acceptOnLeave acceptValue tabableElements
		hideOnAccept acceptCheck needResize autoAccept focusToOKOnLeave
		bindings namedComponents verticalPanel'
	classVariableNames:'DefaultFocusToOKOnLeave AboutToOpenBoxNotificationSignal'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!DialogBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2018 Jan Vrany
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
    this class implements the common behavior of dialogboxes.

    DialogBox is also a superclass of many other boxes - see InfoBox,
    WarningBox, YesNoBox etc. for concrete examples.
    Most of them simply add buttons or other elements.

    For programmatically created boxes, instances support adding of components
    in a top-to-bottom fashion, and also keep track of added text-fields and,
    since they are most common, automatically create an EnterFieldGroup for
    them.

    Caveat:
        more adding support is required - especially for row-wise construction.
        The programmatic interface is best suited for row-wise
        arranged components; laying out elements in columns is a bit
        complicate - for complicated dialogs, it may be better to not use
        the automatic arrangement, but instead give explicit layouts to
        the components (in a subclass) or better use the UIPainter.

    Compatibility note:
        For ST-80 compatibility, DialogBox is also accessible under
        the global named 'Dialog' (which is the name of an ST-80 class,
        providing a very similar protocol).
        This may lead to confusion, if DialogBox is recompiled - you have
        to manually assign Dialog again to refer to the new DialogBox class.
        In future versions of ST/X, DialogBox may be renamed to Dialog.

    Historic note:
        originally, ST/X had separate classes for the various entry methods;
        there were YesNoBox, EnterBox, InfoBox and so on.
        ST-80 has all this defined in the common Dialog.
        Therefore, for compatibility, many ST/X methods defined here in Dialogs
        class protocol simply dispatch to some other boxes class method.
        In the future, those existing subclasses' functionality is going to
        be moved full into Dialog, and the subclasses will be replaced by dummy
        delegators. (They will be kept for backward compatibility, though).


    [instance variables:]

        buttonPanel      <PanelView>    contains the button(s)

        okButton         <Button>       the ok-Button

        okAction         <Block>        the action to be performed when ok is pressed,
                                        or return is pressed.

        acceptReturnAsOK <Boolean>      if true, pressing the return-key counts
                                        as if ok was pressed. Default is true.

        abortButton      <Button>       the cancel-Button

        abortAction      <Block>        the action to be performed when cancel is
                                        pressed.

        yPosition        <Integer>      current y position when adding components

        leftIndent       <Integer>      left inset to use when adding components

        rightIndent      <Integer>      right inset to use when adding components

        addedComponents  <Collection>   programmatically added components

        inputFieldGroup  <EnterFieldGroup>
                                        for added input fields

        acceptOnLeave    <Boolean>      if true (the default) and there are
                                        tabable inputFields, accept and close when
                                        the last field is left. If false, the ok
                                        button must be pressed to close the box.

        acceptedValue    v(<Boolean>)   valueHolder on a boolean
                                        after close: holds true if box was accepted
                                        (i.e. ok-Button was pressed), false if box was
                                        closed via cancel or window manager.

        autoAccept       Boolean        if true, pressing ok (or return)
                                        sends #accept to all subcomponents.
                                        I.e. all subfields update their models
                                        first. The default is true.

        variablePanel   nil|VPanel      an optional additional panel to be filled dynamically
                                        in an aboutToOpenNotification hook.

    For compatibility with ST-80, this class is also available under
    the global names DialogView and Dialog (see patches file).

    [author:]
        Claus Gittinger

    [see also:]
        Button CheckToggle Toggle
        EditField SelectionInListView FileSelectionList
        FramedBox Separator
        ( introduction to view programming :html: programming/viewintro.html )
"
!

examples
"
    historically, DialogBox was used as an abstract class as a base for InfoBox, 
    YesNoBox etc. 
    However, the programmatic construction protocol (#addComponent:)
    now allows those classes to be easily replaced and future versions of
    ST/X may do this and make those subclasses obsolete.
    However, dummy stubs will remain to exist for backward compatibility
    (i.e. do not fear using YesNoBox, EnterBox etc.)

    For most simple standard dialogs, there are ready to use
    methods in the class protocol.

    For example:

      info & warnings:
                                                                        [exBegin]
        Dialog information:'hi there'
                                                                        [exEnd]
                                                                        [exBegin]
        Dialog warn:'oops'
                                                                        [exEnd]


      yes/no questions:
                                                                        [exBegin]
        (Dialog confirm:'is this simple ?')
        ifTrue:[
            Transcript showCR:'thats what I expected'
        ] ifFalse:[
            Transcript showCR:'read more examples and documentation'
        ]
                                                                        [exEnd]


      yes/no question with cancel option:
                                                                        [exBegin]
        |answer|

        answer := Dialog confirmWithCancel:'is this simple ?'.
        answer isNil ifTrue:[
            Transcript showCR:'no easy decision'
        ] ifFalse:[
            answer ifTrue:[
                Transcript showCR:'thats what I expected'
            ] ifFalse:[
                Transcript showCR:'read more examples and documentation'
            ]
        ]
                                                                        [exEnd]


      asking for a string:
                                                                        [exBegin]
        |s|

        s := Dialog request:'enter your name, please:'.
        s notEmpty ifTrue:[
            Transcript showCR:'you entered: ' , s.
        ]
                                                                        [exEnd]


      asking for a string with given default:
                                                                        [exBegin]
        |s|

        s := Dialog 
                request:'enter your name, please:'
                initialAnswer:(OperatingSystem getLoginName).
        s notEmpty ifTrue:[
            Transcript showCR:'you entered: ' , s.
        ]
                                                                        [exEnd]


      asking for a filename:
                                                                        [exBegin]
        |s|

        s := Dialog 
                requestFileName:'select a file, please:'
                default:''.
        Transcript show:'you entered: '; showCR:s.
                                                                        [exEnd]


      with a namefiler pattern:
                                                                        [exBegin]
        |s|

        s := Dialog 
                requestFileName:'select a file, please:'
                default:''
                pattern:'*.rc'.
        Transcript show:'you entered: '; showCR:s.
                                                                        [exEnd]


      another namefiler pattern:
                                                                        [exBegin]
        |s|

        s := Dialog 
                requestFileName:'select a file, please:'
                default:''
                pattern:'*.rc;*.st;*.h'.
        Transcript show:'you entered: '; showCR:s.
                                                                        [exEnd]


      with changed button label and pattern:
                                                                        [exBegin]
        |s|

        s := Dialog 
                requestFileName:'select a file, please:'
                default:''
                ok:'show'
                abort:'cancel'
                pattern:'*.rc'.
        Transcript show:'you entered: '; showCR:s.
                                                                        [exEnd]


      asking for a password:
                                                                        [exBegin]
        |s|

        s := Dialog 
                requestPassword:'enter your secret, please:'.
        Transcript show:'you entered: '; showCR:s.
                                                                        [exEnd]

      multiple choice dialogs:
                                                                        [exBegin]
        Dialog 
           choose:'choose any' 
           fromList:nil
           values:nil
           buttons:#('one' 'two' 'three' 'four') 
           values:#(1 2 3 4) 
           lines:nil
           cancel:nil
                                                                        [exEnd]

      multiple choice dialog, with list & buttons:
                                                                        [exBegin]
         Transcript showCR:(
             Dialog 
                choose:'choose example' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:4
                cancel:[Transcript flash. #aborted]
         )
                                                                        [exEnd]

    You can (and often have to) construct custom dialogs programmatically, 
    from individual components. As shown in the following examples:

    basic (unusable) example:
                                                                        [exBegin]
        DialogBox new open
                                                                        [exEnd]

    still unusable - only an ok-button:
                                                                        [exBegin]
        DialogBox new addOkButton; open
                                                                        [exEnd]

    both ok- and abortButtons:
                                                                        [exBegin]
        DialogBox new addAbortButton; addOkButton; open
                                                                        [exEnd]

    with different ok-label:
                                                                        [exBegin]
        DialogBox new addAbortButton; addOkButtonLabelled:'yeah'; open
                                                                        [exEnd]

    adding a (centered by default) textlabel gives an infoBox:
                                                                        [exBegin]
        DialogBox new
            addTextLabel:'hello';
            addOkButton; 
            open
                                                                        [exEnd]

    a textlabel with abort- and okButton gives a yesNoBox:
                                                                        [exBegin]
        DialogBox new
            addTextLabel:'hello';
            addAbortButton; 
            addOkButton; 
            open
                                                                        [exEnd]

    the same, adjusting the labels contents to the left:
                                                                        [exBegin]
        |box|

        box := DialogBox new.
        (box addTextLabel:'hello') adjust:#left.
        box addAbortButton; 
            addOkButton; 
            open
                                                                        [exEnd]

    with modified buttons:
                                                                        [exBegin]
        |box|

        box := DialogBox new.
        (box addTextLabel:'are you certain ?') adjust:#left.
        box addAbortButtonLabelled:'not really'. 
        (box addOkButtonLabelled:'yes, absolutely') 
                activeBackgroundColor:Color red. 
        box open
                                                                        [exEnd]


    mswindows style (different up/down bitmaps in buttons):
    ((try tabbing ...)
                                                                        [exBegin]
        |b box|

        box := DialogBox new.
        (box addTextLabel:'are you certain ?') adjust:#left.
        b := Button new.
        b activeLogo:(Image fromFile:'cancel_down.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b passiveLogo:(Image fromFile:'cancel_up.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b focusLogo:(Image fromFile:'cancel_focus.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b beImageButton.
        box addAbortButton:b.

        b := Button new.
        b activeLogo:(Image fromFile:'ok_down.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b passiveLogo:(Image fromFile:'ok_up.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b focusLogo:(Image fromFile:'ok_focus.bmp' inPackage:'stx:goodies/bitmaps/winImages').
        b beImageButton.
        box addOkButton:b.
        box open
                                                                        [exEnd]


    two textlabels:
                                                                        [exBegin]
        DialogBox new
            addTextLabel:'hello';
            addTextLabel:'world';
            addAbortButton; 
            addOkButton; 
            open
                                                                        [exEnd]

    fixing the dialogs size (suppres it calculating its size from the
    preferredExtents of its components):
                                                                        [exBegin]
        DialogBox new
            label:'a simple dialog';
            addTextLabel:'hello';
            addAbortButton; 
            addOkButton; 
            extent:200@200;
            sizeFixed:true;
            open
                                                                        [exEnd]

    asking the box if it was closed via ok:
                                                                        [exBegin]
        (DialogBox new
            label:'a simple dialog';
            addTextLabel:'hello';
            addAbortButton; 
            addOkButton; 
            extent:200@200;
            sizeFixed:true;
            open
        ) accepted ifTrue:[
            Transcript showCR:'yes'
        ] ifFalse:[
            Transcript showCR:'no'
        ]
                                                                        [exEnd]

    textLabels are not limited to strings (although, the name which is
    used for ST-80 compatibility, suggests it):
                                                                        [exBegin]
        DialogBox new
            addTextLabel:(Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages');
            addOkButton; 
            open
                                                                        [exEnd]

                                                                        [exBegin]
        DialogBox new
            addTextLabel:'hello';
            addTextLabel:((Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages')
                                magnifiedTo:200@150);
            addTextLabel:'world';
            addAbortButton; 
            addOkButton; 
            open
                                                                        [exEnd]

    adding an input field (on a string model):
                                                                        [exBegin]
        |stringModel|

        stringModel := '' asValue.
        (DialogBox new
            addTextLabel:'Please enter a string:';
            addInputFieldOn:stringModel; 
            addAbortButton; 
            addOkButton; 
            open
        ) accepted ifTrue:[
            Transcript showCR:'entered: ', stringModel value
        ]
                                                                        [exEnd]


    multiple input fields (notice, that the dialog connects the fields
    in a group, so stepping is allowed via Cursor and Return keys):
                                                                        [exBegin]
        |firstName lastName|

        firstName := '' asValue.
        lastName := '' asValue.
        (DialogBox new
            addTextLabel:'Please enter your name:';
            addInputFieldOn:firstName; 
            addVerticalSpace;
            addInputFieldOn:lastName; 
            addAbortButton; 
            addOkButton; 
            open
        ) accepted ifTrue:[
            Transcript showCR:'entered: ', firstName value , ' ' , lastName value
        ]
                                                                        [exEnd]


    of course, the model may contain a value initially:
                                                                        [exBegin]
        |firstName lastName p line i name|

        firstName := '' asValue.
        lastName := '' asValue.
        p := PipeStream readingFrom:'finger ' , OperatingSystem getLoginName.
        p notNil ifTrue:[
            line := p nextLine.
            (i := line findString:'Name:') ~~ 0 ifTrue:[
                name := line copyFrom:(i + 'Name:' size).
            ] ifFalse:[
                (i := line findString:'real life:') == 0 ifTrue:[
                    line := p nextLine.
                ].
                (i := line findString:'real life:') ~~ 0 ifTrue:[
                    name := line copyFrom:(i + 'real life:' size).
                ]
            ].
            name notNil ifTrue:[
                firstName value: name asCollectionOfWords first.
                lastName  value: name asCollectionOfWords last.
                Transcript showCR:'initially ' , firstName value , ' ' , lastName value.
            ].
            p close.
        ].

        (DialogBox new
            addTextLabel:'Please enter your name:';
            addInputFieldOn:firstName; 
            addVerticalSpace;
            addInputFieldOn:lastName; 
            addAbortButton; 
            addOkButton;
            open
        ) accepted ifTrue:[
            Transcript showCR:'entered: ', firstName value , ' ' , lastName value
        ]
                                                                        [exEnd]


    validated password entry:
                                                                        [exBegin]
        |box firstEntry secondEntry|

        firstEntry := '' asValue.
        secondEntry := '' asValue.

        box := DialogBox new.
        (box addTextLabel:'Please enter your secret:') adjust:#left.
        (box addInputFieldOn:firstEntry) passwordCharacter:$*. 
        box addVerticalSpace.
        (box addInputFieldOn:secondEntry) passwordCharacter:$*. 
        box addAbortButton. 
        box addOkButton. 
        box open.
        box accepted ifTrue:[
            firstEntry value ~= secondEntry value ifTrue:[
                Transcript showCR:'wrong input - try again'
            ] ifFalse:[
                Transcript showCR:'entered: ', firstEntry value
            ]
        ]
                                                                        [exEnd]

     input fields with a label:
                                                                        [exBegin]
        |box firstNameHolder middleNameHolder lastNameHolder|

        firstNameHolder := 'John' asValue.
        middleNameHolder := 'F' asValue.
        lastNameHolder := 'Peters' asValue.

        box := DialogBox new.
        box 
            addLabelledInputField:'first name:'
            adjust:#right
            on:firstNameHolder
            tabable:true
            separateAtX:0.4.

        box 
            addLabelledInputField:'middle initial:'
            adjust:#right
            on:middleNameHolder
            tabable:true
            separateAtX:0.4.

        box 
            addLabelledInputField:'last name:'
            adjust:#right
            on:lastNameHolder
            tabable:true
            separateAtX:0.4.

        box addOkButton.
        box open.
                                                                        [exEnd]


     constructing a dialog from other elements:
     adding a fileSelectionList:
     (since the dialog adds the component with its preferred extent,
      ignoring the 300-height, this looks ugly ... 
      ... especially when resized vertically)
                                                                        [exBegin]
        |top l scr fileName|

        fileName := '' asValue.

        top := DialogBox new.

        l := FileSelectionList new.
        l useIndex:false.
        l doubleClickAction:[:name | top okPressed].
        l action:[:name | fileName value:name].
        scr := ScrollableView forView:l.
        scr extent:(1.0 @ 300).

        top addComponent:scr.
        top addAbortButton; addOkButton.
        top openModal.

        top accepted ifTrue:[
            Transcript show:'fileName: '; showCR:fileName value storeString.
        ]
                                                                        [exEnd]

    same, looks better, since the height is made larger (not using 
    fileLists preferredExtent):
                                                                        [exBegin]
        |top l scr fileName|

        fileName := '' asValue.

        top := DialogBox new.

        l := FileSelectionList new.
        l useIndex:false.
        l doubleClickAction:[:name | top okPressed].
        l action:[:name | fileName value:name].
        scr := ScrollableView forView:l.

        top addComponent:scr withExtent:300@300.
        top addAbortButton; addOkButton.
        top openModal.

        top accepted ifTrue:[
            Transcript show:'fileName: '; showCR:fileName value storeString.
        ]
                                                                        [exEnd]


    again, setting the boxes initial size and fixing it
    (let it ignore the components' preferredExtent):
                                                                        [exBegin]
        |top fixFrame l scr fileName|

        fileName := '' asValue.

        top := DialogBox new.
        top extent:300@300.

        fixFrame := View new.
        fixFrame extent:(1.0 @ 300).

        l := FileSelectionList new.
        l useIndex:false.
        l doubleClickAction:[:name | top okPressed].
        l action:[:name | fileName value:name].
        scr := ScrollableView forView:l.
        scr origin:0.0@0.0 corner:1.0@1.0.
        fixFrame add:scr.

        top addComponent:fixFrame.
        top addAbortButton; addOkButton.
        top openModal.

        top accepted ifTrue:[
            Transcript show:'fileName: '; showCR:fileName value storeString.
        ]
                                                                        [exEnd]


   adding a panel with checkBoxes:
                                                                        [exBegin]
        |top panel b value1 value2 value3 value4|

        value1 := true asValue.
        value2 := false asValue.
        value3 := false asValue.
        value4 := true asValue.

        top := DialogBox new.
        top extent:200@300.

        panel := VerticalPanelView new.

        b := CheckBox on:value1. b label:'check1'.
        panel addSubView:b.

        b := CheckBox on:value2. b label:'check2'.
        panel addSubView:b.

        b := CheckBox on:value3. b label:'check3'.
        panel addSubView:b.

        b := CheckBox on:value4. b label:'check4'.
        panel addSubView:b.

        top addComponent:panel.
        top addAbortButton; addOkButton.
        top open.

        top accepted ifTrue:[
            Transcript show:'value1: '; showCR:value1 value.
            Transcript show:'value2: '; showCR:value2 value.
            Transcript show:'value3: '; showCR:value3 value.
            Transcript show:'value4: '; showCR:value4 value.
        ]
                                                                        [exEnd]

   same, using a more convenient interface:
                                                                        [exBegin]
        |box value1 value2 value3 value4|

        value1 := true asValue.
        value2 := false asValue.
        value3 := false asValue.
        value4 := true asValue.

        box := DialogBox new.
        box extent:200@300.

        box addCheckBox:'check1' on:value1.
        box addVerticalSpace.
        box addCheckBox:'check2' on:value2.
        box addVerticalSpace.
        box addCheckBox:'check3' on:value3.
        box addVerticalSpace.
        box addCheckBox:'check4' on:value4.

        box addAbortButton; addOkButton.
        box open.

        box accepted ifTrue:[
            Transcript show:'value1: '; showCR:value1 value.
            Transcript show:'value2: '; showCR:value2 value.
            Transcript show:'value3: '; showCR:value3 value.
            Transcript show:'value4: '; showCR:value4 value.
        ]
                                                                        [exEnd]


    same, using an even better interface:
                                                                        [exBegin]
        |box values labels|

        values := #(true false false true) collect:[:val | val asValue].
        labels := #('check1' 'check2' 'check3' 'check4').

        box := Dialog new.

        box
           addColumn:(1 to:labels size)
           fromX:0.0
           toX:1.0 
           collect:[:index | CheckBox label:(labels at:index) model:(values at:index)]
           tabable:true.
        
        box addAbortButton; addOkButton.
        box open.

        box accepted ifTrue:[
           values with:labels do:[:val :lbl |
              Transcript show:(lbl , ': '); showCR:val value.
           ]
        ]
                                                                        [exEnd]


    adding two panels in a frame:
                                                                        [exBegin]
        |box frame vPanel1 vPanel2 m1 m2 m3 m4 chk ef|

        box := Dialog new.
        box label:'example'.

        frame := FramedBox label:'frame'.

        vPanel1 := VerticalPanelView origin:0.0@0.0 corner:0.5@1.0 in:frame.
        vPanel1 horizontalLayout:#leftSpace.
        vPanel1 verticalLayout:#spreadSpace.

        vPanel2 := VerticalPanelView origin:0.5@0.0 corner:1.0@1.0 in:frame.
        vPanel2 horizontalLayout:#leftSpace.
        vPanel2 verticalLayout:#spreadSpace.

        m1 := true asValue.
        m2 := true asValue.
        m3 := true asValue.
        m4 := 'hello' asValue.

        vPanel1 add:(Label label:'check1').
        vPanel1 add:(Label label:'m2').
        vPanel1 add:(Label label:'m3').
        vPanel1 add:(Label label:'enter').
        vPanel1 add:(Label label:'lbl1').
        vPanel1 add:(Label label:'lbl2').

        vPanel2 add:(chk := CheckToggle on:m1). 
        box makeTabable:chk.

        vPanel2 add:(chk := CheckToggle on:m2). 
        box makeTabable:chk.

        vPanel2 add:(chk := CheckToggle on:m3). 
        box makeTabable:chk.

        vPanel2 add:(chk := CheckToggle on:m3). 
        box makeTabable:chk.

        vPanel2 add:(chk := CheckToggle on:m3). 
        box makeTabable:chk.

        vPanel2 add:(ef := EditField on:m4). 
        ef immediateAccept:true.
        box makeTabable:ef.

        box addComponent:frame.

        box addAbortButton; addOkButton.
        box openModal.
        box accepted ifTrue:[
            Transcript showCR:'accepted with:'.
            Transcript showCR:'   m1: ' , m1 value printString.
            Transcript showCR:'   m2: ' , m2 value printString.
            Transcript showCR:'   m3: ' , m3 value printString.
            Transcript showCR:'   m4: ' , m4 value printString.
        ]
                                                                        [exEnd]



    a full example (combined settings dialog - as in launcher):
                                                                        [exBegin]
        |box warnSTX allowUnderscore immutableArrays logDoits
         listOfLanguages listOfStyles styleNames 
         frame panel c resourceDir dir |

        warnSTX := Compiler warnSTXSpecials asValue.
        allowUnderscore := Compiler allowUnderscoreInIdentifier asValue.
        immutableArrays := Compiler arraysAreImmutable asValue.

        logDoits := Smalltalk logDoits asValue.

        listOfLanguages := SelectionInList with:#('english'
                                                  'french'
                                                  'german'
                                                  'italian'
                                                  'spanish'
                                                 ).
        listOfLanguages selection:(Language asString).


        resourceDir := Smalltalk getSystemFileName:'resources'.
        dir := FileDirectory directoryNamed:resourceDir.

        styleNames := dir select:[:aFileName | aFileName endsWith:'.style'].
        styleNames := styleNames collect:[:aFileName | aFileName copyWithoutLast:6].
        listOfStyles := SelectionInList with:styleNames sort.
        listOfStyles selection:(View defaultStyle asString).

        box := Dialog new.
        box label:'Settings'.

        frame := FramedBox label:'Compiler'.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame.
        panel horizontalLayout:#leftSpace.

        panel add:((CheckBox on:warnSTX) label:'warn about ST/X language extensions'; resize).
        panel add:((CheckBox on:allowUnderscore) label:'allow underscore in identifiers'; resize).
        panel add:((CheckBox on:immutableArrays) label:'literal arrays are immutable'; resize).
        box addComponent:frame.

        frame := FramedBox label:'Misc'.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame.
        panel horizontalLayout:#leftSpace.

        panel add:((CheckBox on:logDoits) label:'log doIts in changes file'; resize).
        box addComponent:frame.

        frame := FramedBox label:'Language'.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame.
        panel horizontalLayout:#leftSpace.

        panel add:((PopUpList on:listOfLanguages) width:0.5).
        box addComponent:frame.

        frame := FramedBox label:'Style'.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame.
        panel horizontalLayout:#leftSpace.

        panel add:((PopUpList on:listOfStyles) width:0.5).
        box addComponent:frame.

        box addAbortButton; addOkButton.
        box showAtPointer.

        box accepted ifTrue:[
            Transcript topView withCursor:Cursor wait do:[
                Compiler warnSTXSpecials:warnSTX value.
                Compiler allowUnderscoreInIdentifier:allowUnderscore value.
                Compiler arraysAreImmutable:immutableArrays value.

                Smalltalk logDoits:logDoits value.

                Transcript showCR:'change language to ' , listOfLanguages selection , ' ...'.
                Smalltalk at:#Language put:listOfLanguages selection asSymbol.
                Smalltalk changed:#Language.
                ResourcePack flushCachedResourcePacks.

                Transcript showCR:'change style to ' , listOfStyles selection , ' ...'.
                View defaultStyle:listOfStyles selection asSymbol.
            ]
        ]
                                                                        [exEnd]
      an example from Hopkins/Horan:  
                                                                        [exBegin]
        |aText index|

        aText := 'Smalltalk/X: An Introduction to Application Development' asText.
        index := aText findString:'Smalltalk/X' startingAt:1.
        aText emphasizeFrom:index 
                         to:'Smalltalk/X' size + index - 1
                       with:#bold.
        index := aText findString:'Introduction' startingAt:index.
        aText emphasizeFrom:index 
                         to:'Introduction' size + index - 1
                       with:#italic.
        Dialog warn:aText        
        
                                                                        [exEnd]
      the same, with colors:  
                                                                        [exBegin]
        |aText index|

        aText := 'Smalltalk/X: An Introduction to Application Development' asText.
        index := aText findString:'Smalltalk/X' startingAt:1.
        aText emphasizeFrom:index 
                         to:'Smalltalk/X' size + index - 1
                       with:(Array with:#bold with:#underline with:(#color->Color red)).
        index := aText findString:'Introduction' startingAt:index.
        aText emphasizeFrom:index 
                         to:'Introduction' size + index - 1
                       with:#italic.
        Dialog warn:aText        
                                                                        [exEnd]
"
!

inputFocus
"
    a DialogBox with multiple input fields can be configured on how it
    shall behave if the RETURN key is pressed. 

    The default is to shift the focus to the ok-button - thus, another return
    has to be entered (as confirmation) to close & accept the box.

    This can be changed to force an automatic OK with:
	aBox focusToOKOnLeave:false

    Then, leaving the last field with return, automatically accepts the box,
    as if ok was pressed. (useful for simple - single entry dialogs).
    All simple dialogs (like 'enter a searchString') behave this way.


    With: 
	aBox acceptReturnAsOK:false

    any focusShift or automatic OK is turned off, and the input group 
    switches its focus back to the topMost field. 
    The default for this is true.
    (useful, if you want an explicit ok from the user, or need all fields
     to be handled somehow).


    Simply leaving the group with a cursor movement may also be either
    interpreted as a return (the default), or again wrap back to the top
    of the group.

    With:
	aBox acceptOnLeave:false
    this is turned off, so that with cursor-down, the focus is moved back 
    to the first entry field. The default is true.
"
! !

!DialogBox class methodsFor:'Compatibility-VW'!

choose:aString fromList:list values:listValues lines:maxLines cancel:cancelBlock for:aView
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel.
     This is a new VW2.5 interface - passing an addtional argument.
     In ST/X, this is not needed and ignored"

    ^ self
	choose:aString 
	fromList:list 
	values:listValues
	lines:maxLines
	cancel:cancelBlock

    "
     Transcript showCR:(
	 Dialog 
	    choose:'choose any' 
	    fromList:#('one' 'two' 'three' 'four') 
	    values:#(1 2 3 4) 
	    lines:4
	    cancel:nil
     )

     Transcript showCR:(
	 Dialog 
	    choose:'choose example' 
	    fromList:#('one' 'two' 'three' 'four') 
	    values:#(1 2 3 4) 
	    lines:4
	    cancel:[Transcript flash. #aborted]
     )
    "

    "Created: / 1.11.1997 / 13:21:32 / cg"
    "Modified: / 1.11.1997 / 13:21:54 / cg"
!

confirm:aMessageString for:ignoredView
    "VW compatibility - confirm using the same viewStyle as in the view
     argument; not supported in ST/X (who mixes styles ?)"

    ^ self 
        confirm:aMessageString 
        title:nil 
        yesLabel:nil noLabel:nil 
        initialAnswer:true.

    "Created: / 06-03-1997 / 15:45:54 / cg"
    "Modified: / 02-03-2007 / 15:25:15 / cg"
!

request:aString for:aView
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or the empty string (if cancel was pressed),
     This is a new VW2.5 interface - passing an addtional argument.
     In ST/X, this is not needed and ignored"

    ^ self 
	request:aString

    "Created: / 31.10.1997 / 03:26:32 / cg"
    "Modified: / 31.10.1997 / 11:53:50 / cg"
!

request:aString initialAnswer:initial for:aView
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     This is a new VW2.5 interface - passing an addtional argument.
     In ST/X, this is not needed and ignored"

    ^ self 
	request:aString 
	initialAnswer:initial

    "Modified: / 29.5.1996 / 14:30:05 / cg"
    "Created: / 1.11.1997 / 13:18:29 / cg"
!

requestFileName:title default:default version:versionSym ifFail:failBlock for:aViewOrNil
    "new VW2.5 interface - passing an addtional argument.
     In ST/X, this is not needed and ignored"

    ^ self
	requestFileName:title default:default version:versionSym ifFail:failBlock

    "Created: / 31.10.1997 / 02:00:42 / cg"
    "Modified: / 31.10.1997 / 11:52:53 / cg"
!

warn:aMessageString for:ignoredView
    "VW compatibility - warn using the same viewStyle as in the view
     argument; not supported in ST/X (who mixes styles ?)"

    ^ self warn:aMessageString

    "Created: / 6.3.1997 / 15:46:02 / cg"
    "Modified: / 31.10.1997 / 11:54:35 / cg"
! !

!DialogBox class methodsFor:'class initialization'!

initialize
    self == DialogBox ifTrue:[
        "/ do this for ST-80 compatibility 
        "/ (and in the meantime also for my own compatibility..)
        Dialog := self
    ].

    DefaultFocusToOKOnLeave := false.

    "/ for backward whitebox compatibility (customer subclasses which access the classVar directly)
    AboutToOpenBoxNotificationSignal := SimpleView aboutToOpenBoxNotificationSignal
! !

!DialogBox class methodsFor:'common dialogs'!

about:text label:label icon:image
    "opens an standard about box for an application."

    |box|

    AboutBox isNil ifTrue:[
        "/ this handles bad installations of ST/X,
        "/ where the AboutBox is missing.
        "/ (May vanish in the future)
        ^ self information:text
    ].

    box := AboutBox title:text.

    box image:image.
    box label:label.
    box autoHideAfter:10 with:[].
    self showAndThenDestroyBox:box.
    "/ box open.

    "Created: / 17.11.2001 / 23:04:53 / cg"
    "Modified: / 17.11.2001 / 23:06:06 / cg"
!

aboutClass:aClass
    "opens a standard (simple) aboutBox for aClass."

    |rev clsRev msg resources|

    rev := ''.

    (clsRev := aClass revision) notNil ifTrue: [rev := '  (rev: ', clsRev printString, ')'].
    resources := aClass classResources.

    msg := '\' withCRs , aClass name allBold, rev.

    self
        about:(resources string:msg)
        label:(resources string:'About ' , aClass nameWithoutPrefix)
        icon:aClass defaultIconForAboutBox
!

ask:setupBlock ifNotNilOrEmptyDo:actionBlock
    "utility: open a requestor with setupBlock;
     if it answers ok, invoke actionBlock with the entered input.
     Otherwise do nothing"
     
    |answer|

    answer := setupBlock value.
    answer notEmptyOrNil ifTrue:[
        actionBlock value:answer
    ].

    "
     Dialog 
        ask:[ Dialog request:'Some Answer:' ] 
        ifNotNilOrEmptyDo:[:what | Transcript showCR:what ]
    "
    "
     Dialog 
        ask:[ Dialog requestFileName:'Some File:' ] 
        ifNotNilOrEmptyDo:[:what | Transcript showCR:what ]
    "
!

askYesNo:setupBlock ifYesDo:actionBlock
    "utility: open a confirmer with setupBlock;
     if it answers true, invoke actionBlock.
     Otherwise do nothing"
     
    |answer|

    answer := setupBlock value.
    answer == true ifTrue:[
        actionBlock value
    ].

    "
     Dialog 
        askYesNo:[ Dialog confirm:'Yes or No?' ] 
        ifYesDo:[ Transcript showCR:'yes' ]
    "
!

informUser:aString during:aBlock
    "show a message-box while executing aBlock"

    |box|

    [
        box := InfoBox title:aString.
        box hideButtons.
        self showBox:box. "/ box showAtPointer.
    ] forkAt:(Processor activePriority + 1).
    aBlock ensure:[box destroy]

    "
     Dialog informUser:'wait a second...' during:[Delay waitForSeconds:1]
     Dialog informUser:'wait a few seconds...' during:[10000 factorial]
    "
!

informUser:aString during:aBlock cancel:canCancel
    "show a message-box while executing aBlock"

    |box subProcess|

    box := InfoBox title:aString.
    canCancel ifTrue:[
        box okText:(self classResources string:'Abort').
    ] ifFalse:[
        box hideButtons.
    ].

    subProcess := [
        aBlock ensure:[box destroy]
    ] forkAt:(Processor activePriority - 1).

    self showBox:box.
    subProcess terminate.
    

    "
     Dialog informUser:'don''t wait ...' during:[true] cancel:true
     Dialog informUser:'please wait a second...' during:[Delay waitForSeconds:1] cancel:true
     Dialog informUser:'please wait, while I compute 30000 factorial...' during:[30000 factorial] cancel:true
    "
!

information:aString
    "launch a Dialog to tell user something"

    self information:aString title:(aString upTo:Character cr)

    "
     Dialog information:'help'
    "

    "Modified: 29.5.1996 / 15:23:03 / cg"
!

information:aString title:windowTitle
    "launch a Dialog to tell user something"

    |currentScreen|

    ((currentScreen := Screen current) notNil and:[currentScreen nativeDialogs]) ifTrue:[
        ^ currentScreen 
            nativeInformationOK:aString
            title:windowTitle
    ].
    self showAndThenDestroyBox:(InfoBox title:aString label:windowTitle)

    "
     Dialog information:'help' title:'Attention'
    "

    "Created: / 22-12-2010 / 19:33:23 / cg"
!

informationText:aString title:windowTitle
    "launch a Dialog to tell user something.
     The argument aString is shown as multiline, scrollable text"

    |dialog textHolder|

    textHolder := ValueHolder new.
    dialog := Dialog 
                forRequestText:'' editViewClass:TextView
                lines:15 columns:60 
                initialAnswer:aString initialSelection:nil 
                model:textHolder.
    dialog window label:windowTitle.
    dialog open.

    "
     Dialog 
        informationText:(DialogBox class compiledMethodAt:#information:title:) source
        title:'Hello'
    "
!

informationText:aString title:title windowTitle:windowTitle
    "launch a Dialog to tell user something.
     The argument aString is shown as multiline, scrollable text"

    |dialog textHolder|

    textHolder := ValueHolder new.
    dialog := Dialog 
                forRequestText:title editViewClass:TextView
                lines:15 columns:60 
                initialAnswer:aString initialSelection:nil 
                model:textHolder.
    dialog removeAbortButton.
    dialog okButton beReturnButton.
    dialog window label:windowTitle.
    dialog open.

    "
     Dialog 
        informationText:(DialogBox class compiledMethodAt:#information:title:) source
        title:'Hello - the text is:'
        windowTitle:'Hello'
    "
!

warn:aString
    "launch a Dialog to warn user"

    |currentScreen|

    ((currentScreen := Screen current) notNil and:[currentScreen nativeDialogs]) ifTrue:[
        ^ currentScreen 
            nativeWarnOK:aString
            title:aString
    ].
    self showAndThenDestroyBox:(WarningBox title:aString)

    "
     Dialog warn:'some warning message'

     Dialog warn:('some text with italic emphasis' asText 
                        emphasizeFrom:16 to:22 with:#italic)

     Dialog warn:('some warning message' asText 
                        emphasizeAllWith:(#color->Color red))

     Dialog warn:('some text with color emphasis' asText 
                        emphasizeFrom:6 to:10 with:(#color->Color blue);
                        emphasizeFrom:16 to:20 with:(#color->Color red))
    "

    "Modified: 29.5.1996 / 15:23:14 / cg"
!

warn:aString title:windowTitle
    "launch a Dialog to warn user"

    |currentScreen|

    ((currentScreen := Screen current) notNil and:[currentScreen nativeDialogs]) ifTrue:[
        ^ currentScreen 
            nativeWarnOK:aString
            title:windowTitle
    ].
    self showAndThenDestroyBox:(WarningBox title:aString label:windowTitle)

    "
     Dialog warn:'some warning message'

     Dialog warn:('some text with italic emphasis' asText 
                        emphasizeFrom:16 to:22 with:#italic)

     Dialog warn:('some warning message' asText 
                        emphasizeAllWith:(#color->Color red))

     Dialog warn:('some text with color emphasis' asText 
                        emphasizeFrom:6 to:10 with:(#color->Color blue);
                        emphasizeFrom:16 to:20 with:(#color->Color red))
    "

    "Modified: / 29-05-1996 / 15:23:14 / cg"
    "Created: / 20-01-2012 / 15:54:26 / cg"
! !

!DialogBox class methodsFor:'confirmation dialogs'!

confirm:aString
    "open a modal yes-no dialog.
     Return true for yes, false for no"                                   

    ^ self 
        confirm:aString 
        title:nil 
        yesLabel:nil noLabel:nil 
        initialAnswer:true.

    " 
     Dialog confirm:'really ?' 

     Transcript showCR:(
        Dialog confirm:'are you certain ?'
     )
    "

    "Modified: / 02-03-2007 / 15:25:34 / cg"
!

confirm:aString default:what
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     InitialAnswer must be true or false and defines which button is to be
     the default (i.e. return-) button"

    ^ self 
        confirm:aString 
        title:nil 
        yesLabel:nil noLabel:nil 
        initialAnswer:what.

    "
     Dialog confirm:'Are you happy' default:true 

     Dialog confirm:'Are you happy' default:false 
    "

    "Modified: / 02-03-2007 / 15:25:23 / cg"
!

confirm:aString initialAnswer:what
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     InitialAnswer must be true or false and defines which button is to be
     the default (i.e. return-) button"

    ^ self 
        confirm:aString 
        title:nil 
        yesLabel:nil noLabel:nil 
        initialAnswer:what.

    " 
     Dialog confirm:'really ?' initialAnswer:false

     Transcript showCR:(
        Dialog confirm:'are you certain ?' initialAnswer:false
     )

     Transcript showCR:(
        Dialog confirm:'are you certain ?' initialAnswer:true 
     )
    "

    "Modified: / 02-03-2007 / 15:24:52 / cg"
!

confirm:aString initialAnswer:what noLabel:noText
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     InitialAnswer must be true or false and defines which button is to be
     the default (i.e. return-) button"

    ^ self 
        confirm:aString 
        title:nil 
        yesLabel:nil noLabel:noText 
        initialAnswer:what.

    "Modified: / 02-03-2007 / 15:24:49 / cg"
!

confirm:aString noLabel:noText
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     The no-button is labeled noText (for example, if you need a 'cancel' there)"

    ^ self 
        confirm:aString
        title:nil
        yesLabel:nil noLabel:noText
        initialAnswer:true

    " 
     Dialog confirm:'really ?' 

     Dialog confirm:'really ?' noLabel:'Cancel' 
    "

    "Modified: / 02-03-2007 / 15:24:43 / cg"
!

confirm:aString title:title
    "open a modal yes-no dialog.
     Return true for yes, false for no"                                   

    ^ self 
        confirm:aString
        title:title
        yesLabel:nil noLabel:nil
        initialAnswer:true

    " 
     Dialog confirm:'really ?' 

     Transcript showCR:(
        Dialog confirm:'are you certain ?'
     )
    "

    "Created: / 02-03-2007 / 15:21:25 / cg"
!

confirm:aString title:title noLabel:noText
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     The no buttons label is defined by noText (for example, to make it 'cancel')."

    ^ self
        confirm:aString 
        title:title 
        yesLabel:nil noLabel:noText
        initialAnswer:true

    " 
     Dialog 
        confirm:'really ?' 
        title:'fooBar'
        noLabel:'Nope'      
    "

    " 
     Dialog 
        confirm:'really ?' 
        title:nil
        noLabel:'Cancel'   
    "

    "Modified: / 02-03-2007 / 15:23:55 / cg"
!

confirm:aString title:title yesLabel:yesText noLabel:noText
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     The yes/no buttons labels are defined by yesText/noText."

    ^ self 
        confirm:aString 
        title:title 
        yesLabel:yesText noLabel:noText 
        initialAnswer:true

    " 
     Dialog 
        confirm:'really ?' 
        title:'fooBar'
        yesLabel:'Oh well' 
        noLabel:'Nope'
    "

    " 
     Dialog 
        confirm:'really ?' 
        title:nil
        yesLabel:'Oh well' 
        noLabel:'Nope'
    "

    " 
     Dialog 
        confirm:'really ?' 
        title:''
        yesLabel:'Oh well' 
        noLabel:'Nope'
    "

    "Created: / 21.2.1996 / 01:10:14 / cg"
    "Modified: / 18.4.1998 / 19:25:21 / cg"
!

confirm:aString title:title yesLabel:yesText noLabel:noText initialAnswer:what
    "launch a Dialog, which allows user to enter yes or no.
     return true for yes, false for no.
     The yes/no buttons labels are defined by yesText/noText."

    |box answer t currentScreen|

    t := title.
    t isNil ifTrue:[ t := self classResources string:'Confirm' ].

    ((currentScreen := Screen current) notNil and:[currentScreen nativeDialogs]) ifTrue:[
        "/ experimental
        ^ currentScreen 
            nativeConfirmYesNo:aString
            title:t
            initialAnswer:what
    ].

    box := YesNoBox title:aString.
    yesText notNil ifTrue:[
        box yesLabel:yesText.
    ].
    noText notNil ifTrue:[
        box noLabel:noText.
    ].
    answer := false.
    box yesAction:[answer := true].

    box label:t.
    what == false ifTrue:[
        box okButton isReturnButton:false.
        box acceptReturnAsOK:false.
        box cancelButton beReturnButton.
    ].

    self showAndThenDestroyBox:box.
    box yesAction:nil noAction:nil.
    ^ answer

    " 
     Dialog 
        confirm:'really ?' 
        title:'fooBar'
        yesLabel:'Oh well' 
        noLabel:'Nope'
        initialAnswer:true
    "
    " 
     Dialog 
        confirm:'really ?' 
        title:'fooBar'
        yesLabel:'Oh well' 
        noLabel:'Nope'
        initialAnswer:false
    "

    "Created: / 21-02-1996 / 01:10:14 / cg"
    "Modified: / 02-03-2007 / 15:23:31 / cg"
!

confirm:msg withCancel:aBoolean
    "launch a Dialog, which allows user to enter yes, no and optionally: cancel.
     Return true for 'yes', false for 'no', nil for 'cancel'"

    aBoolean ifTrue:[
        ^ Dialog confirmWithCancel:msg.
    ] ifFalse:[
        ^ Dialog confirm:msg.
    ].

    "
     Dialog confirm:'really ?' withCancel:false 
     Dialog confirm:'really ?' withCancel:true 
    "
!

confirm:msg withCancel:aBoolean default:default
    "launch a Dialog, which allows user to enter yes, no and optionally: cancel.
     Return true for 'yes', false for 'no', nil for 'cancel'"

    aBoolean ifTrue:[
        ^ Dialog confirmWithCancel:msg default:default.
    ] ifFalse:[
        ^ Dialog confirm:msg default:default.
    ].

    "
     Dialog confirm:'really ?' withCancel:false 
     Dialog confirm:'really ?' withCancel:true 
    "
!

confirm:aString yesLabel:yesText
    "launch a Dialog, which allows user to enter yes or no.
     Return true for yes, false for no.
     The yes button's label is defined by yesText."

    ^ self confirm:aString title:nil yesLabel:yesText noLabel:nil

    " 
     Dialog 
        confirm:'really ?' 
        yesLabel:'Oh well' 
    "

    "Created: / 04-09-2006 / 11:18:50 / cg"
!

confirm:aString yesLabel:yesText initialAnswer:what
    "launch a Dialog, which allows user to enter yes or no.
     Return true for yes, false for no.
     The yes button's label is defined by yesText."

    ^ self confirm:aString title:nil yesLabel:yesText noLabel:nil initialAnswer:what

    " 
     Dialog 
        confirm:'really ?' 
        yesLabel:'Oh well' 
        initialAnswer:false
    "

    "Created: 21.2.1996 / 01:10:14 / cg"
    "Modified: 8.3.1996 / 21:15:06 / cg"
!

confirm:aString yesLabel:yesText noLabel:noText
    "launch a Dialog, which allows user to enter yes or no.
     Return true for yes, false for no.
     The yes/no buttons' labels are defined by yesText/noText."

    ^ self confirm:aString title:nil yesLabel:yesText noLabel:noText

    " 
     Dialog 
        confirm:'really ?' 
        yesLabel:'Oh well' 
        noLabel:'Nope'
    "

    "Created: / 21-02-1996 / 01:10:14 / cg"
    "Modified: / 04-09-2006 / 11:19:00 / cg"
!

confirm:aString yesLabel:yesText noLabel:noText initialAnswer:what
    "launch a Dialog, which allows user to enter yes or no.
     Return true for yes, false for no.
     The yes/no buttons labels are defined by yesText/noText."

    ^ self confirm:aString title:nil yesLabel:yesText noLabel:noText initialAnswer:what

    " 
     Dialog 
        confirm:'really ?' 
        yesLabel:'Oh well' 
        noLabel:'Nope'
        initialAnswer:false
    "

    "Created: 21.2.1996 / 01:10:14 / cg"
    "Modified: 8.3.1996 / 21:15:06 / cg"
!

confirmOKCancel:aString
    "launch a Dialog, which allows user to enter OK or Cancel.
     return true for OK, false for Cancel."

    |resources|

    resources := self classResources.
    ^ self 
        confirm:aString 
        yesLabel:(resources string:'OK') 
        noLabel:(resources string:'Cancel')

    " 
     Dialog confirmOKCancel:'really ?' 
    "
!

confirmWithCancel:aString
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', nil for 'cancel'"

    ^ self  
        confirmWithCancel:aString 
        default:true 
        title:nil

    "
     Dialog confirmWithCancel:'really ?' 
    "

    "
     Transcript showCR:(
        Dialog confirmWithCancel:'really ?'
     )
    "

    "Modified: / 02-03-2007 / 15:26:05 / cg"
!

confirmWithCancel:aString default:default
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', nil for 'cancel'.
     The default argument marks the return-button; it may be one of nil, false or true"

    ^ self 
        confirmWithCancel:aString 
        default:default 
        title:nil

    "
     Dialog confirmWithCancel:'really ?' default:false
     Dialog confirmWithCancel:'really ?' default:true
    "

    "Modified: / 02-03-2007 / 15:26:13 / cg"
!

confirmWithCancel:aString default:defaultValue onCancel:cancelValue
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', cancelValues value for 'cancel'"

    |answer|

    answer := self confirmWithCancel:aString default:defaultValue.
    answer isNil ifTrue:[
        ^ cancelValue value
    ].
    ^ answer

    "
     Dialog confirmWithCancel:'really ?' onCancel:[AbortSignal raise]
    "
!

confirmWithCancel:aString default:default title:titleString
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', nil for 'cancel'.
     The default argument marks the return-button; it may be one of nil, false or true"

    ^ self
        confirmWithCancel:aString 
        labels:(self classResources array:#('Cancel' 'No' 'Yes') )
        values:#(nil false true)
        default:(#(nil false true) indexOf:default ifAbsent:nil)
        title:titleString

    "
     Dialog confirmWithCancel:'really ?' default:false
     Dialog confirmWithCancel:'really ?' default:true
    "

    "Created: / 02-03-2007 / 15:09:56 / cg"
!

confirmWithCancel:aString labels:labelArray
    "launch a Dialog, which allows user to enter cancel, no or yes.
     Return true for 'yes', false for 'no', nil for 'cancel'.
     The default is yes.
     The buttons labels are given in labelArray, cancel being first, yes being last
     (notice that the order may get reversed in some styles)"

    ^ self
        confirmWithCancel:aString 
        labels:(self classResources array:labelArray)
        default:3
    "
     Dialog confirmWithCancel:'really ?' labels:#( 'Oops' 'Nope' 'Yea')
     Dialog confirmWithCancel:'really ?'
    "

    "Modified: / 02-03-2007 / 15:10:34 / cg"
!

confirmWithCancel:aString labels:buttonLabels default:default
    "launch a Dialog, which allows user to enter yes, no and cancel.
     Return true for 'yes', false for 'no', nil for 'cancel'.
     The strings for cancel, no and yes are to be passed in
     buttonLabels, with cancel/abort being the first. 
     The default argument (if non-nil) defines the index of the 
     return button (1 to 3)"

    ^ self
        confirmWithCancel:aString 
        labels:buttonLabels 
        values:#(nil false true)
        default:default

    "
     Transcript showCR:(
         Dialog 
            confirmWithCancel:'really ?'
                       labels:#('mhmh' 'Maybe' 'Definitely')
                      default:3
     )
    "

    "Created: / 18.10.1996 / 14:50:51 / cg"
    "Modified: / 21.10.1998 / 15:49:16 / cg"
!

confirmWithCancel:aString labels:buttonLabels values:buttonValues default:default
    "launch a Dialog, which allows user to click on any button.
     Return the corresponding value from the values array.
     The labels for the buttons are to be passed in
     buttonLabels, with cancel/abort being the first. 
     The default argument (if non-nil) defines the index of the 
     return button (1 to n)"

    ^ self
        confirmWithCancel:aString 
        labels:buttonLabels 
        values:buttonValues 
        default:default
        title:nil

    "
     Transcript showCR:(
         Dialog 
            confirmWithCancel:'really ?'
                       labels:#('mhmh' 'maybe' 'definitely')
                       values:#(1 2 3)
                      default:3
     )
    "

    "Created: / 18-10-1996 / 14:50:51 / cg"
    "Modified: / 02-03-2007 / 15:09:24 / cg"
!

confirmWithCancel:aString labels:buttonLabels values:buttonValues default:default boxLabel:boxLabelOrNil
    <resource: #obsolete>

    "obsolete - for backward compatibility"

    ^ self
        confirmWithCancel:aString 
        labels:buttonLabels 
        values:buttonValues 
        default:default 
        title:boxLabelOrNil

    "Modified: / 02-03-2007 / 15:09:11 / cg"
!

confirmWithCancel:aString labels:buttonLabels values:buttonValues default:default check:checkLabelOrNil on:checkHolderOrNil title:boxLabelOrNil
    "launch a Dialog, which allows user to click on any button.
     Return the corresponding value from the values array.
     The labels for the buttons are to be passed in
     buttonLabels, with cancel/abort being the first.
     The default argument (if non-nil) defines the index of the return button (1 to n).
     If checkLabel/checkHolder are not nil, and additional labelled checkBox is added to operate on
     checkHolder. This can be used for 'do not show this box again' checkItems."

    |box buttons answer i|

    box := OptionBox title:aString numberOfOptions:buttonLabels size.
    box buttonTitles:buttonLabels
             actions:(buttonValues collect:[:v | [answer := v]]).
    box image:(YesNoBox iconBitmap).
    default notNil ifTrue:[
        box defaultButtonIndex:(default isInteger
                                    ifTrue:[default]
                                    ifFalse:[ buttonValues indexOf:default])
    ].
    box label:(boxLabelOrNil ? (self classResources string:'Confirm')).
    buttons := box buttons.
    (i := buttonValues indexOf:true) ~~ 0 ifTrue:[
        i <= buttons size ifTrue:[
            (buttons at:i) cursor:(Cursor thumbsUp).
        ]
    ].
    (i := buttonValues indexOf:false) ~~ 0 ifTrue:[
        i <= buttons size ifTrue:[
            (buttons at:i) cursor:(Cursor thumbsDown).
        ]
    ].
    (i := buttonValues indexOf:nil) ~~ 0 ifTrue:[
        i <= buttons size ifTrue:[
            (buttons at:i) cursor:(Cursor thumbsDown).
        ]
    ].
    checkLabelOrNil notNil ifTrue:[
        box addCheckBoxAtBottom:checkLabelOrNil on:checkHolderOrNil.
    ].

    self showAndThenDestroyBox:box.
    box actions:nil.
    ^ answer

    "
     Transcript showCR:(
         Dialog
            confirmWithCancel:'really ?'
            labels:#('mhmh' 'maybe' 'definitely')
            values:#(1 2 3)
            default:3
            check:'Again' on:(true asValue)
            title:'hello there'
     )

     Transcript showCR:(
         Dialog
            confirmWithCancel:'really ?'
            labels:#('mhmh' 'maybe' 'definitely')
            values:#(1 2 3)
            default:3
            check:nil on:nil
            title:'hello there'
     )
    "

    "Created: / 02-03-2007 / 15:08:49 / cg"
!

confirmWithCancel:aString labels:buttonLabels values:buttonValues default:default title:boxLabelOrNil
    "launch a Dialog, which allows user to click on any button.
     Return the corresponding value from the values array.
     The labels for the buttons are to be passed in
     buttonLabels, with cancel/abort being the first.
     The default argument (if non-nil) defines the index of the
     return button (1 to n)"

    ^ self
        confirmWithCancel:aString
        labels:buttonLabels
        values:buttonValues
        default:default
        check:nil on:nil
        title:boxLabelOrNil

    "
     Transcript showCR:(
         Dialog
            confirmWithCancel:'really ?'
            labels:#('mhmh' 'maybe' 'definitely')
            values:#(1 2 3)
            default:3
            title:'hello there'
     )
    "

    "Created: / 02-03-2007 / 15:08:49 / cg"
!

confirmWithCancel:aString onCancel:cancelValue
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', cancelValues value for 'cancel'"

    |answer|

    answer := self confirmWithCancel:aString.
    answer isNil ifTrue:[
        ^ cancelValue value
    ].
    ^ answer

    "
     Dialog confirmWithCancel:'really ?' onCancel:[AbortSignal raise]
    "
!

confirmWithCancel:aString title:titleString
    "launch a Dialog, which allows user to enter yes, no and cancel.
     return true for 'yes', false for 'no', nil for 'cancel'"

    ^ self 
        confirmWithCancel:aString 
        default:nil 
        title:titleString

    "
     Dialog confirmWithCancel:'really ?' 
    "

    "
     Transcript showCR:(
        Dialog confirmWithCancel:'really ?'
     )
    "

    "Created: / 02-03-2007 / 15:11:14 / cg"
! !

!DialogBox class methodsFor:'defaults'!

defaultLabel
    "return the boxes default window title."

    ^ 'Dialog'

    "Created: 23.4.1996 / 17:13:10 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'dialogBox.returnShiftsFocusToOK')>

    DefaultFocusToOKOnLeave := StyleSheet at:'dialogBox.returnShiftsFocusToOK' default:false.

! !

!DialogBox class methodsFor:'file name dialogs'!

requestDirectoryName
    "same as requestFileName, but only show directories."

    ^ self
        requestDirectoryName:'Select Directory' 
        default:nil
        ok:nil abort:nil 
        ifFail:''

    "
     Dialog requestDirectoryName
    "

    "Created: 19.4.1996 / 14:29:48 / cg"
    "Modified: 19.4.1996 / 14:32:42 / cg"
!

requestDirectoryName:title
    "same as requestFileName, but only show directories."

    ^ self
        requestDirectoryName:title 
        default:nil
        ok:nil abort:nil 
        ifFail:''

    "
     Dialog
        requestDirectoryName:'which directory ?' 
    "

    "Created: 19.4.1996 / 14:29:48 / cg"
    "Modified: 19.4.1996 / 14:32:02 / cg"
!

requestDirectoryName:title default:aFileName
    "same as requestFileName, but only show directories"

    ^ self
        requestDirectoryName:title 
        default:aFileName
        ok:nil abort:nil 
        ifFail:''

    "
     Dialog
        requestDirectoryName:'which directory ?' 
        default:'/etc'
    "

    "Created: 19.4.1996 / 14:29:10 / cg"
    "Modified: 19.4.1996 / 14:31:52 / cg"
!

requestDirectoryName:title default:aFileName acceptReturnAsOK:aBoolean
    "same as requestFileName, but only show directories"

    ^ self
        requestDirectoryName:title 
        default:aFileName
        ok:nil abort:nil 
        ifFail:''
        acceptReturnAsOK:aBoolean

    "
     Dialog
        requestDirectoryName:'which directory ?' 
        default:'/etc'
    "

    "Created: 19.4.1996 / 14:29:10 / cg"
    "Modified: 19.4.1996 / 14:31:52 / cg"
!

requestDirectoryName:title default:aFileName ifFail:failBlock
    "same as requestFileName, but only show directories"

    ^ self 
        requestDirectoryName:title 
        default:aFileName 
        ok:nil abort:nil 
        ifFail:failBlock

    "
     Dialog
        requestDirectoryName:'which directory ?' 
        default:'/etc'
        ifFail:'none'    'none'
    "

    "Created: 19.4.1996 / 14:31:04 / cg"
    "Modified: 23.10.1997 / 19:24:41 / cg"
!

requestDirectoryName:title default:aFileName ok:okText abort:abortText
    "same as requestFileName, but only show directories"

    ^ self 
        requestDirectoryName:title 
        default:aFileName 
        ok:okText abort:abortText 
        ifFail:''

    "
     Dialog
        requestDirectoryName:'which directory ?' 
        default:'/etc'
        ok:'Yes' abort:'No'    
    "

    "Created: 19.4.1996 / 14:31:04 / cg"
    "Modified: 23.10.1997 / 19:24:41 / cg"
!

requestDirectoryName:title default:aFileName ok:okText abort:abortText ifFail:failBlock 
    "Same as requestFileName, but only show directories."
    
    ^ self 
        requestDirectoryName:title
        default:aFileName
        ok:okText
        abort:abortText
        ifFail:failBlock
        acceptReturnAsOK:false

    "Modified (format): / 23-01-2012 / 11:46:08 / cg"
!

requestDirectoryName:title default:aFileName ok:okText abort:abortText ifFail:failBlock acceptReturnAsOK:aBoolean
    "Same as requestFileName, but only show directories.
     Extended to accept return as ok if wanted."

    |t dir dirF fN fileBox enteredName resources|

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[
            ^ "FileDialogV2" FileDialog requestDirectoryName:title default:aFileName ok:okText abort:abortText ifFail:failBlock acceptReturnAsOK:aBoolean
        ]
    ].

    resources := self classResources.
    fileBox := FileSelectionBox
                    title:title
                    action:[:fileName | enteredName := fileName].

    fileBox acceptReturnAsOK:aBoolean.

    okText notNil 
        ifTrue:[ t := okText ]
        ifFalse:[ t := resources string:'OK' ].
    fileBox okText:t.

    abortText notNil 
        ifTrue:[ t := abortText ]
        ifFalse:[ t := resources string:'Cancel' ].
    fileBox abortText:t.

    fN := aFileName.
    dirF := (aFileName ? '.') asFilename.
    dirF name = dirF baseName ifFalse:[
        dir := dirF directoryName.
        fN := dirF baseName.
    ] ifTrue:[
        dir := FileSelectionBox lastFileSelectionDirectory.
    ].
    dir notNil ifTrue:[
        fileBox directory:dir.
    ].

    fileBox initialText:fN.
    fileBox selectingDirectory:true.

    self showAndThenDestroyBox:fileBox.

    (enteredName isEmptyOrNil) ifTrue:[
        ^ failBlock value
    ].

    FileSelectionBox lastFileSelectionDirectory:(enteredName asFilename directoryName).

    ^ enteredName

    "
     Dialog
        requestDirectoryName:'which directory ?' 
        default:'/etc'
        ifFail:'none'
    "

    "Created: / 19-04-1996 / 14:31:04 / cg"
    "Modified: / 23-01-2012 / 11:43:07 / cg"
!

requestDirectoryName:titleString default:aFileName ok:okText abort:abortText version:versionSymbol pattern:pattern fromDirectory:aDirectoryPath ifFail:failBlock whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:aBoolean
    "same as requestFileName, but only show directories"

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[
            ^ FileDialog
                requestDirectoryName:titleString 
                default:aFileName 
                ok:okText 
                abort:abortText 
                version:versionSymbol 
                pattern:pattern 
                fromDirectory:aDirectoryPath 
                ifFail:failBlock 
                whenBoxCreatedEvaluate:boxCreatedCallback 
                asLoadDialog:aBoolean.
        ].
    ].
    ^ self
        requestDirectoryName:titleString 
        default:aFileName 
        ok:okText abort:abortText 
        ifFail:failBlock 
        acceptReturnAsOK:true

    "Modified: / 23-01-2012 / 17:23:27 / cg"
!

requestFileName
    "launch a Dialog, which allows the user to enter a filename.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
	requestFileName:'filename:' 

    "
     Dialog requestFileName
    "

    "Created: 27.1.1996 / 13:24:35 / cg"
    "Modified: 19.4.1996 / 13:49:28 / cg"
!

requestFileName:titleString
    "launch a Dialog, which allows user to enter a filename.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
	requestFileName:titleString 
	default:'file.ext' 

    "
     Dialog requestFileName:'enter a fileName:' 
     Dialog requestFileName:'enter a fileName:' 
    "

    "Created: 27.1.1996 / 13:24:35 / cg"
    "Modified: 19.4.1996 / 13:53:17 / cg"
!

requestFileName:titleString default:defaultName
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        version:nil 
        ifFail:''

    "
     Dialog requestFileName:'Enter a fileName:' default:''  
     Dialog requestFileName:'Enter a fileName:' default:'Makefile.bak'  
    "

    "Modified: / 19-04-1996 / 13:47:44 / cg"
    "Modified (comment): / 23-01-2012 / 18:02:51 / cg"
!

requestFileName:titleString default:defaultName fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        version:nil 
        ifFail:''
        pattern:nil 
        fromDirectory:aDirectoryPath
        forSave:false
        whenBoxCreatedEvaluate:nil

    "
     Dialog 
        requestFileName:'enter a fileName:' 
        default:'Makefile.bak'
        fromDirectory:'..'      
    "

    "Modified: / 27-10-2010 / 10:40:42 / cg"
!

requestFileName:titleString default:defaultName ifFail:cancelBlockOrValue
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        version:nil 
        ifFail:cancelBlockOrValue

    "
     Dialog requestFileName:'enter a fileName:' default:''  
     Dialog requestFileName:'enter a fileName:' default:'Makefile.bak'  
    "

    "Modified: 19.4.1996 / 13:47:44 / cg"
!

requestFileName:titleString default:defaultName ifFail:failReturn pattern:pattern fromDirectory:dir
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from dir.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or failReturn if cancel was pressed."

    ^ self 
        requestFileName:titleString 
        default:defaultName
        version:nil
        ifFail:failReturn
        pattern:pattern
        fromDirectory:dir

!

requestFileName:titleString default:defaultName ok:okText abort:abortText
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        ok:okText abort:abortText 
        pattern:'*'

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:'yeah' 
        abort:'oh, no' 
    "
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    ^ self 
	requestFileName:titleString 
	default:defaultName
	ok:okText 
	abort:abortText 
	pattern:pattern
	fromDirectory:nil

    "
     Dialog 
	requestFileName:'enter a fileName:'
	default:''
	ok:'yeah' 
	abort:'oh, no' 
	pattern:'*.st'   
    "

    "Modified: 20.2.1997 / 18:13:13 / cg"
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        whenBoxCreatedEvaluate:nil
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil forSave:forSave
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil
        forSave:forSave
        whenBoxCreatedEvaluate:nil

    "Created: / 27-10-2010 / 11:22:58 / cg"
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil forSave:forSave whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText abort:abortText 
        pattern:pattern 
        orFilters:nil 
            "argument #filtersOrNil is window specific,
             it is an array of arrays with filter (*.zip) and its description (ZIP compressed archive file)
             to support a call with just #filtersOrNil and no #patternOrNil the pattern will be extracted from the #filtersOrNil for linux"

        fromDirectory:aDirectoryPathOrNil 
        forSave:forSave 
        whenBoxCreatedEvaluate:boxCreatedCallback
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        forSave:false 
        whenBoxCreatedEvaluate:boxCreatedCallback

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:'yeah' 
        abort:'oh, no' 
        pattern:'rc*'
        fromDirectory:'/etc'  
    "

    "Modified: / 24-08-2010 / 17:28:57 / sr"
    "Modified: / 27-10-2010 / 11:21:44 / cg"
!

requestFileName:titleString default:defaultName ok:okText abort:abortText pattern:patternOrNil orFilters:filtersOrNil fromDirectory:aDirectoryPathOrNil forSave:forSave whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    "argument #filtersOrNil is window specific,
     it is an array of arrays with filter (*.zip) and its description (ZIP compressed archive file)
     to support a call with just #filtersOrNil and no #patternOrNil the pattern will be extracted from the #filtersOrNil for linux"

    |box defaultDir defaultNm dir enteredName
     pattern|

    Screen current nativeFileDialogs ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            Win32FileDialog notNil ifTrue:[
                ^ Win32FileDialog    
                    fileDialogFor:nil 
                    save:forSave 
                    title:titleString 
                    inDirectory:aDirectoryPathOrNil
                    initialAnswer:defaultName
                    pattern:patternOrNil
                    orFilters:filtersOrNil
                    extension:nil
            ].
        ].
    ].

    patternOrNil isNil ifTrue:[
        "extract the pattern from #filtersOrNil"
        pattern := self patternForFilters:filtersOrNil.
    ] ifFalse:[
        pattern := patternOrNil.
    ].

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[
            ^ FileDialog 
                requestFileName:titleString 
                default:defaultName 
                ok:okText abort:abortText 
                pattern:pattern 
                fromDirectory:aDirectoryPathOrNil 
                whenBoxCreatedEvaluate:boxCreatedCallback
        ]
    ].

    defaultNm := defaultName.
    defaultDir := aDirectoryPathOrNil.
    defaultDir isNil ifTrue:[
        defaultNm notNil ifTrue:[
            defaultDir := defaultName asFilename directoryName.
            defaultNm := defaultNm asFilename baseName.
            defaultDir = Filename currentDirectory name ifTrue:[
                defaultName asFilename isExplicitRelative ifFalse:[
                    defaultDir := nil
                ]
            ]
        ].
    ].

    box := FileSelectionBox 
               title:titleString
               okText:okText 
               abortText:abortText
               action:[:fileName | enteredName := fileName].

    defaultDir notNil ifTrue:[
        box directory:defaultDir
    ] ifFalse:[
        dir := FileSelectionBox lastFileSelectionDirectory.
        dir notNil ifTrue:[
            box directory:dir.
        ].
    ].
    box pattern:pattern.
    box initialText:defaultNm.
    boxCreatedCallback notNil ifTrue:[boxCreatedCallback value:box].

    self showAndThenDestroyBox:box.
    box action:nil.

    (enteredName notEmptyOrNil) ifTrue:[
        FileSelectionBox lastFileSelectionDirectory:(enteredName asFilename directoryName).
    ].

    ^ enteredName

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:'yeah' 
        abort:'oh, no' 
        pattern:'rc*'
        fromDirectory:'/etc'  
    "

    "Modified: / 24-08-2010 / 17:28:57 / sr"
    "Created: / 27-10-2010 / 11:21:05 / cg"
!

requestFileName:titleString default:defaultName ok:okText abort:abortText version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:aBoolean
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[
            ^ FileDialog
                requestFileName:titleString 
                default:defaultName 
                ok:okText 
                abort:abortText 
                version:versionSymbol 
                ifFail:failBlock 
                pattern:pattern 
                fromDirectory:aDirectoryPath 
                whenBoxCreatedEvaluate:boxCreatedCallback 
                asLoadDialog:aBoolean.
        ].
    ].
    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText abort:abortText 
        pattern:pattern fromDirectory:aDirectoryPath forSave:aBoolean not
        whenBoxCreatedEvaluate:boxCreatedCallback

    "Modified: / 23-01-2012 / 17:22:57 / cg"
!

requestFileName:titleString default:defaultName pattern:pattern
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    |resources|

    resources := self classResources.
    ^ self 
        requestFileName:titleString 
        default:defaultName
        ok:(resources string:'OK') 
        abort:(resources string:'Cancel') 
        pattern:pattern
        fromDirectory:nil

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        pattern:'*.st'   
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        pattern:'*.st;*.h'   
    "

    "Created: 21.2.1997 / 11:16:52 / cg"
    "Modified: 21.2.1997 / 11:18:40 / cg"
!

requestFileName:titleString default:defaultName pattern:pattern fromDirectory:aDirectory
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    |resources|

    resources := self classResources.
    ^ self 
        requestFileName:titleString 
        default:defaultName
        ok:(resources string:'OK') 
        abort:(resources string:'Cancel') 
        pattern:pattern
        fromDirectory:aDirectory

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        pattern:'*.st'   
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        pattern:'*.st;*.h'   
    "

    "Created: 21.2.1997 / 11:16:52 / cg"
    "Modified: 21.2.1997 / 11:18:40 / cg"
!

requestFileName:titleString default:defaultName version:versionSymbol
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string or the empty string if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
	#mustBeNew      - fail (return empty string) if the file exists
	#new            - confirm if the file exists
	#mustBeOld      - fail if the file does not exist
	#old            - confirm if the file does not exist
	#any (other)    - no validation
    "

    ^ self 
	requestFileName:titleString 
	default:defaultName 
	version:versionSymbol 
	ifFail:''

    "
     Dialog requestFileName:'enter a fileName:'
			default:''
			version:nil   

     Dialog requestFileName:'enter a fileName:'
			default:''
			version:#mustBeNew 

     Dialog requestFileName:'enter a fileName:'
			default:''
			version:#new   
    "

    "Modified: 19.4.1996 / 13:53:58 / cg"
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
	#mustBeNew      - fail (return empty string) if the file exists
	#new            - confirm if the file exists
	#mustBeOld      - fail if the file does not exist
	#old            - confirm if the file does not exist
	#any (other)    - no validation
    "

    ^ self
	requestFileName:titleString 
	default:defaultName 
	version:versionSymbol 
	ifFail:failBlock
	fromDirectory:nil

    "
     Dialog 
	requestFileName:'enter a fileName:'
	default:''
	version:nil
	ifFail:['none']   
    "
    "
     Dialog 
	requestFileName:'enter a fileName:'
	default:''
	version:#old 
	ifFail:['none']   
    "

    "Modified: 19.4.1996 / 14:26:36 / cg"
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:nil 
        fromDirectory:aDirectoryPath
        
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#mustBeNew 
        ifFail:['none']   
        fromDirectory:'/etc'
    "

    "Modified: 20.2.1997 / 18:12:28 / cg"
    "Modified: 21.2.1997 / 14:27:27 / stefan"
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self
        requestFileName:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        whenBoxCreatedEvaluate:nil
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath forSave:forSave whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    |box defaultDir defaultNm|

    Screen current nativeFileDialogs ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            Win32FileDialog notNil ifTrue:[
                ^ Win32FileDialog    
                    fileDialogFor:nil 
                    save:forSave 
                    title:titleString 
                    inDirectory:aDirectoryPath
                    initialAnswer:defaultName
                    pattern:pattern
                    extension:nil
            ]
        ].
    ].

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[ 
            ^ FileDialog    
                requestFileName:titleString 
                default:defaultName 
                version:versionSymbol 
                ifFail:failBlock 
                pattern:pattern 
                fromDirectory:aDirectoryPath 
                whenBoxCreatedEvaluate:boxCreatedCallback.
        ].
    ].

    defaultName notNil ifTrue:[defaultNm := defaultName asFilename name].
    defaultDir := aDirectoryPath.
    defaultDir isNil ifTrue:[
        defaultNm notNil ifTrue:[
            defaultName asFilename withoutSuffix baseName = '*' ifTrue:[
                defaultDir := FileSelectionBox lastFileSelectionDirectory.
                defaultNm := ''.
            ] ifFalse:[
                defaultDir := defaultName asFilename directoryName.
                defaultNm := defaultNm asFilename baseName.
            ]
        ].
    ].

    box := FileSelectionBox title:titleString.
    defaultDir notNil ifTrue:[box directory:defaultDir].
    pattern notNil ifTrue:[box pattern:pattern].
    box initialText:defaultNm.
    box action:[:name | 
        versionSymbol == #mustBeNew ifTrue:[
            "/ file may not exist
            name asFilename exists ifTrue:[^ ''].
        ].
        versionSymbol == #new ifTrue:[
            "/ file may not exist
            name asFilename exists ifTrue:[
                (self confirm:(self classResources string:'''%1'' exists.\\Continue anyway ?' with:box fileName) withCRs)
                ifFalse:[^ ''].
            ].
        ].
        versionSymbol == #mustBeOld ifTrue:[
            name asFilename exists ifFalse:[^ ''].
        ].
        versionSymbol == #old ifTrue:[
            "/ file may not exist
            name asFilename exists ifFalse:[
                (self confirm:(self classResources string:'''%1'' does not exist yet.\\Continue anyway ?' with:box fileName) withCRs)
                ifFalse:[^ ''].
            ].
        ].
        FileSelectionBox lastFileSelectionDirectory:box directory.
        box destroy. 
        ^ name
    ].
    boxCreatedCallback notNil ifTrue:[boxCreatedCallback value:box].
    self showAndThenDestroyBox:box.
    box action:nil.
    ^ failBlock value

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'Enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'Enter a fileName:'
        default:''
        version:#mustBeNew 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:'/etc'
    "

    "Modified: / 24-08-2010 / 17:29:04 / sr"
    "Created: / 27-10-2010 / 10:38:10 / cg"
!

requestFileName:titleString default:defaultName version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self
        requestFileName:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath 
        forSave:false
        whenBoxCreatedEvaluate:boxCreatedCallback

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        pattern:'*.conf'
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#mustBeNew 
        ifFail:['none']   
        pattern:'*.conf'
        fromDirectory:'/etc'
    "

    "Created: / 21-02-1997 / 14:23:44 / stefan"
    "Modified: / 24-08-2010 / 17:29:04 / sr"
    "Modified: / 27-10-2010 / 10:38:53 / cg"
!

requestFileName:titleString fromDirectory:aDirectory
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     Return the string or nil if cancel was pressed."

    ^ self 
        requestFileName:titleString 
        default:nil
        pattern:'*'
        fromDirectory:aDirectory

    "
     Dialog 
        requestFileName:'enter a fileName:'
        fromDirectory:'../../libbasic'
    "
!

requestFileName:titleString ifFail:cancelBlockOrValue
    "launch a Dialog, which allows user to enter a filename.
     Return the pathname string consisting of the full pathname of the filename,
     or the value from evaluating cancelBlock (if cancel was pressed)."

    ^ self 
        requestFileName:titleString 
        default:'file.ext'
        version:nil
        ifFail:cancelBlockOrValue

    "
     Dialog requestFileName:'enter a fileName:' ifFail:['foo']
     Dialog requestFileName:'enter a fileName:' ifFail:[nil] 
    "

    "Modified: 19.4.1996 / 13:53:17 / cg"
    "Created: 19.4.1996 / 13:56:28 / cg"
!

requestFileName:titleString pattern:pattern
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    ^ self 
        requestFileName:titleString 
        default:nil
        pattern:pattern

    "
     Dialog 
        requestFileName:'enter a fileName:'
        pattern:'*.st'   
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        pattern:'*.st;*.h'   
    "
!

requestFileName:titleString pattern:pattern fromDirectory:aDirectory
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show ok/cancel in its buttons.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    ^ self 
        requestFileName:titleString 
        default:nil
        pattern:pattern
        fromDirectory:aDirectory
    "
     Dialog 
        requestFileName:'enter a fileName:'
        pattern:'*.st'   
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        pattern:'*.st;*.h'   
    "
!

requestFileNameForImageSave:title image:anImage default:defaultName pattern:patternOrNil 
    "launch a Dialog, which allows user to enter a filename for a bitmap image save operation.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    |resources|

    resources := self classResources.

    ^ self
        requestFileName:title
        default:defaultName
        ok:(resources string:'Save')
        abort:(resources string:'Cancel')
        pattern:'*.png;*.tiff;*.bmp'
        fromDirectory:nil
        forSave:true
        whenBoxCreatedEvaluate:[:box |
            |editButton paintButton copyButton|
            "/ UserPreferences current useNewFileDialog ifFalse:[
                
                "/ ImageEditor is in stx:libtool2, use it only if available
                "/ to avoid dependency on stx:libtool2
                (Smalltalk hasClassNamed: #ImageEditor) ifTrue:[
                    editButton := Button label:(resources string:'Edit').
                    editButton
                        action:[
                            box hide; destroy.
                            "/ Use Smalltalk at: to avoid dependency on
                            "/ ImageEditor package.
                            (Smalltalk at:#ImageEditor) openOnImage:anImage.
                        ].
                    box addButton:editButton.
                ].

                paintButton := Button label:(resources string:'OS Editor').
                paintButton
                    action:[
                        |tempStream|

                        tempStream := FileStream newTemporaryWithSuffix:'png'.
                        box hide; destroy.
                        PNGReader save:anImage onStream:tempStream.
                        tempStream close.
                        OperatingSystem
                            openApplicationForDocument:tempStream fileName operation:#edit mimeType:'image/png'.
                    ].
                box addButton:paintButton.

                copyButton := Button label:(resources string:'Copy to Clipboard').
                copyButton
                    action:[
                        Screen current rootView setClipboardObject:anImage.
                        box hide; destroy.
                    ].
                box addButton:copyButton.
            "/ ]
       ].

    "
     self 
        requestFileNameForImageSave:'save' 
        image:(Image fromScreen:(0@0 corner:100@100)) 
        default:'screen.png' 
        pattern:'*.png' 
    "

    "Modified: / 26-06-2018 / 09:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requestFileNameForSave:titleString
    "launch a Dialog, which allows user to enter a filename.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileNameForSave:titleString 
        default:'file.ext' 

    "
     Dialog requestFileName:'enter a fileName:' 
     Dialog requestFileName:'enter a fileName:' 
    "

    "Created: / 27-10-2010 / 11:31:52 / cg"
!

requestFileNameForSave:titleString default:defaultName
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileNameForSave:titleString 
        default:defaultName 
        version:nil 
        ifFail:''

    "
     Dialog requestFileName:'enter a fileName:' default:''  
     Dialog requestFileNameForSave:'enter a fileName:' default:''  
    "

    "Created: / 27-10-2010 / 11:32:06 / cg"
!

requestFileNameForSave:titleString default:defaultName fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self 
        requestFileName:titleString 
        default:defaultName 
        version:nil 
        ifFail:''
        pattern:nil 
        fromDirectory:aDirectoryPath
        forSave:true
        whenBoxCreatedEvaluate:nil

    "
     Dialog 
        requestFileName:'enter a fileName:' 
        default:'Makefile.bak'
        fromDirectory:'..'      
    "

    "Created: / 27-10-2010 / 10:41:04 / cg"
!

requestFileNameForSave:titleString default:defaultName ok:okText abort:abortText pattern:pattern
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those from the current directory.
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string or nil if cancel was pressed."

    ^ self 
        requestFileNameForSave:titleString 
        default:defaultName
        ok:okText 
        abort:abortText 
        pattern:pattern
        fromDirectory:nil

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:'yeah' 
        abort:'oh, no' 
        pattern:'*.st'   
    "

    "Created: / 27-10-2010 / 11:29:20 / cg"
!

requestFileNameForSave:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil
        forSave:true
        whenBoxCreatedEvaluate:nil

    "Created: / 27-10-2010 / 11:24:37 / cg"
!

requestFileNameForSave:titleString default:defaultName ok:okText abort:abortText pattern:pattern fromDirectory:aDirectoryPathOrNil whenBoxCreatedEvaluate:boxCreatedCallback
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return the string, or nil if cancel was pressed."

    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText 
        abort:abortText 
        pattern:pattern 
        fromDirectory:aDirectoryPathOrNil 
        forSave:true 
        whenBoxCreatedEvaluate:boxCreatedCallback

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        ok:'yeah' 
        abort:'oh, no' 
        pattern:'rc*'
        fromDirectory:'/etc'  
    "

    "Modified: / 24-08-2010 / 17:28:57 / sr"
    "Created: / 27-10-2010 / 11:23:40 / cg"
!

requestFileNameForSave:titleString default:defaultName version:versionSymbol ifFail:failBlock
    "launch a Dialog, which allows user to enter a filename.
     The box will not allow pressing 'ok' without an entered string.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self
        requestFileNameForSave:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock
        fromDirectory:nil

    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']   
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
    "

    "Created: / 27-10-2010 / 11:32:03 / cg"
!

requestFileNameForSave:titleString default:defaultName version:versionSymbol ifFail:failBlock fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self 
        requestFileNameForSave:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:nil 
        fromDirectory:aDirectoryPath
        
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:nil
        ifFail:['none']
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#old 
        ifFail:['none']   
        fromDirectory:'/etc'
    "
    "
     Dialog 
        requestFileName:'enter a fileName:'
        default:''
        version:#mustBeNew 
        ifFail:['none']   
        fromDirectory:'/etc'
    "

    "Modified: / 21-02-1997 / 14:27:27 / stefan"
    "Created: / 27-10-2010 / 11:32:22 / cg"
!

requestFileNameForSave:titleString default:defaultName version:versionSymbol ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath
    "launch a Dialog, which allows user to enter a filename.
     Return the string or the value of failBlock if cancel was pressed.
     The version argument allows validation of the files existance;
     it may be any of:
        #mustBeNew      - fail (return empty string) if the file exists
        #new            - confirm if the file exists
        #mustBeOld      - fail if the file does not exist
        #old            - confirm if the file does not exist
        #any (other)    - no validation
    "

    ^ self
        requestFileName:titleString 
        default:defaultName 
        version:versionSymbol 
        ifFail:failBlock 
        pattern:pattern 
        fromDirectory:aDirectoryPath
        forSave:true
        whenBoxCreatedEvaluate:nil

    "Created: / 27-10-2010 / 11:32:55 / cg"
!

requestFileNames:titleString default:defaultName ok:okText abort:abortText ifFail:failBlock pattern:pattern fromDirectory:aDirectoryPath whenBoxCreatedEvaluate:boxCreatedCallback asLoadDialog:asLoadDialog
    "launch a Dialog, which allows user to enter a filename.
     The files presented initially are those in aDirectoryPathOrNil, or the
     last fileBox directory (default: current directory) (if a nil path is given).
     The box will show okText in its okButton, abortText in the abortButton.
     The matchPattern is set to pattern initially.
     Return all selected Filenames as filenames in a collection, or nil if cancel was pressed
    "

    UserPreferences current useNewFileDialog ifTrue:[
        FileDialog notNil ifTrue:[
            ^ FileDialog
                requestFileNames:titleString 
                default:defaultName 
                ok:okText 
                abort:abortText 
                ifFail:failBlock 
                pattern:pattern 
                fromDirectory:aDirectoryPath 
                whenBoxCreatedEvaluate:boxCreatedCallback 
                asLoadDialog:asLoadDialog.
        ].
    ].
    ^ self
        requestFileName:titleString 
        default:defaultName 
        ok:okText abort:abortText 
        pattern:pattern fromDirectory:aDirectoryPath forSave:asLoadDialog not
        whenBoxCreatedEvaluate:boxCreatedCallback

    "Modified: / 23-01-2012 / 17:24:06 / cg"
!

requestNewFileName:titleString default:defaultName
    "launch a Dialog, which allows user to enter a filename.
     We expect a new files (i.e. nonexisting) name to be entered,
     and confirm if it already exists.
     The box will not allow pressing 'ok' without an entered string.
     Return the pathname string consisting of the full pathname of the filename,
     or an empty string (if cancel was pressed)."

    ^ self
        requestFileName:titleString
        default:defaultName
        version:#new
        ifFail:''

    "
     Dialog requestNewFileName:'enter a fileName:' default:''
    "

    "Modified: 27.1.1996 / 13:44:13 / cg"
!

requestSaveFileName:title default:defaultOrNil fromDirectory:directoryOrNil action:action appendAction:appendActionOrNil
    "save contents into a file - ask user for filename using a fileSelectionBox.
     Append is NOT offered, if appendActionOrNil is nil."

    |doAppend fileBox fileName dialog default resources|

    default := defaultOrNil.
    default notNil ifTrue:[ default := default asString].

    resources := self classResources.

    Screen current nativeFileDialogs ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            appendActionOrNil isNil ifTrue:[
                Win32FileDialog notNil ifTrue:[
                    ^ Win32FileDialog    
                        fileDialogFor:nil 
                        save:true 
                        title:title 
                        inDirectory:directoryOrNil
                        initialAnswer:default
                        pattern:nil
                        extension:nil
                ]
            ].
        ].
    ].

    (UserPreferences current useNewFileDialog and:[FileDialog notNil]) ifTrue:[
        fileName := FileDialog 
                    requestFileName:title 
                    default:default
                    ok:(resources string:'Save') 
                    abort:nil 
                    version:nil 
                    ifFail:nil 
                    pattern:nil 
                    fromDirectory:directoryOrNil 
                    whenBoxCreatedEvaluate:[:box | 
                        (dialog := box) appendButtonVisibleHolder value:appendActionOrNil notNil
                    ].

        doAppend := dialog appendWasPressed 
    ] ifFalse:[
        fileBox := FileSaveBox
                        title:title
                        okText:(resources string:'Save')
                        abortText:(resources string:'Cancel')
                        action:[:fn | doAppend := false. fileName := fn].
        fileBox appendAction:[:fn | doAppend := true. fileName := fn].
        directoryOrNil notNil ifTrue:[ fileBox directory:directoryOrNil].
        default notNil ifTrue:[fileBox initialText:default].
        fileBox showAtPointer.
        fileBox destroy.
    ].

    fileName size > 0 ifTrue:[
        (doAppend ifTrue:[appendActionOrNil] ifFalse:[action])
            value:fileName
    ].
    ^ fileName.

    "
     Dialog
        requestSaveFileName:'Save dialog example with append' 
        default:'xxx.txt' 
        fromDirectory:(Filename homeDirectory) 
        action:[:fn | Transcript showCR:'save ',fn] 
        appendAction:[:fn | Transcript showCR:'append ',fn]

     Dialog
        requestSaveFileName:'Save dialog example' 
        default:'xxx.txt' 
        fromDirectory:(Filename homeDirectory) 
        action:[:fn | Transcript showCR:'save ',fn] 
        appendAction:nil
    "

    "Modified: / 24-08-2010 / 17:29:12 / sr"
    "Modified: / 23-01-2012 / 11:53:07 / cg"
! !

!DialogBox class methodsFor:'fill in the blank dialogs'!

forRequestText:title editViewClass:editViewClass lines:numLines columns:numCols initialAnswer:initialText initialSelection:anIntervalOrNil model:textModel
    "return a dialog asking for multiline text.
     The box is not shown yet, for further customization"

    ^ self
        forRequestText:title 
        editViewClass:editViewClass
        lines:numLines columns:numCols 
        initialAnswer:initialText 
        setupWith:
            [:textView :dialog|
                initialText notEmptyOrNil ifTrue:[
                    textModel value:initialText
                ].
                textView scrolledView model:textModel.
                textView scrolledView 
                    perform:#acceptChannel: 
                    with:(dialog acceptChannel)
                    ifNotUnderstood:[].

                anIntervalOrNil notNil ifTrue:[
                    textView scrolledView selectFromCharacterPosition:anIntervalOrNil start to:anIntervalOrNil stop.
                ].
            ]

    "Modified: / 12-10-2006 / 13:59:21 / cg"
!

forRequestText:title editViewClass:editViewClass lines:numLines columns:numCols initialAnswer:initialText model:textModel
    "return a dialog asking for multiline text.
     The box is not shown yet, for further customization"

    ^ self
        forRequestText:title 
        editViewClass:editViewClass 
        lines:numLines columns:numCols 
        initialAnswer:initialText initialSelection:nil      
        model:textModel
!

forRequestText:title editViewClass:editViewClass lines:numLines columns:numCols initialAnswer:initialText setupWith:aSetupBlockOrNil
    "return a dialog asking for multiline text.
     The box is not shown yet, for further customization"

    |dialog textView|

    dialog := self new.
    (dialog addTextLabel:(self classResources string:title)) adjust:#left.
    textView := dialog addTextBoxOn:nil 
                        class:editViewClass
                        withNumberOfLines:numLines 
                        hScrollable:true 
                        vScrollable:true.
    initialText notEmptyOrNil ifTrue:[
        textView contents:initialText
    ].
    dialog width:(textView preferredExtentForLines:numLines cols:numCols) x.
    dialog addAbortAndOkButtons.
    dialog okButton isReturnButton:false.
    dialog makeTabable:textView.
    dialog stickAtBottomWithVariableHeight:textView.

    aSetupBlockOrNil notNil ifTrue:[
        aSetupBlockOrNil valueWithOptionalArgument:textView and:dialog
    ].

    ^ dialog

    "
     |dialog textHolder|

     textHolder := ValueHolder new.
     dialog := Dialog 
                forRequestText:'foo' 
                editViewClass:EditTextView
                lines:10 columns:40 
                initialAnswer:'hello' model:textHolder.
     dialog open.
     dialog accepted ifTrue:[
        ^ textHolder value
     ].
     ^ nil           
    "

    "
     |dialog textHolder|

     textHolder := ValueHolder new.
     dialog := Dialog 
                forRequestText:'foo' 
                editViewClass:CodeView
                lines:10 columns:40 
                initialAnswer:'hello' model:textHolder.
     dialog open.
     dialog accepted ifTrue:[
        ^ textHolder value
     ].
     ^ nil           
    "

    "Created: / 12-10-2006 / 13:59:27 / cg"
!

forRequestText:title lines:numLines columns:numCols initialAnswer:initialText initialSelection:anIntervalOrNil model:textModel
    "return a dialog asking for multiline text.
     The box is not shown yet, for further customization"

    ^ self
        forRequestText:title 
        editViewClass:EditTextView
        lines:numLines columns:numCols 
        initialAnswer:initialText initialSelection:anIntervalOrNil
        model:textModel

    "
     |dialog textHolder|

     textHolder := ValueHolder new.
     dialog := Dialog forRequestText:'foo' lines:10 columns:40 initialAnswer:'hello' model:textHolder.
     dialog open.
     dialog accepted ifTrue:[
        ^ textHolder value
     ].
     ^ nil           
    "

    "Modified: / 12-10-2006 / 12:45:47 / cg"
!

forRequestText:title lines:numLines columns:numCols initialAnswer:initialText model:textModel
    "return a dialog asking for multiline text.
     The box is not shown yet, for further customization"

    ^ self
        forRequestText:title 
        editViewClass:EditTextView
        lines:numLines columns:numCols 
        initialAnswer:initialText initialSelection:nil
        model:textModel

    "
     |dialog textHolder|

     textHolder := ValueHolder new.
     dialog := Dialog forRequestText:'foo' lines:10 columns:40 initialAnswer:'hello' model:textHolder.
     dialog open.
     dialog accepted ifTrue:[
        ^ textHolder value
     ].
     ^ nil           
    "

    "Modified: / 12-10-2006 / 12:45:47 / cg"
!

request:aString 
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or the empty string (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:''
        onCancel:''

    "
     Dialog request:'enter a string:' 
    "

    "Modified: 29.5.1996 / 14:26:25 / cg"
!

request:aString displayAt:aPoint centered:centered action:resultAction initialAnswer:initial
    "launch a Dialog, which allows user to enter a string.
     If aPoint is nonNil, the box is shown there, optionally centered around
     that point.
     If it is nil, it is shown at the current pointer position or at the 
     screen center.
     Return the string or an empty string (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     centered around 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'


     origin at 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'

     under mouse pointer:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'

     centered on the screen:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
    "

    "Created: 7.12.1995 / 23:14:10 / cg"
    "Modified: 29.5.1996 / 14:19:36 / cg"
!

request:aString displayAt:aPoint centered:centered action:resultAction initialAnswer:initial okLabel:okLabel cancelLabel:cancelLabel onCancel:cancelValue
    "launch a Dialog, which allows user to enter a string.
     If aPoint is nonNil, the box is shown there, optionally centered around it.
     If it is nil, it is shown at the current pointer position or at the 
     screen center (if centered is true).
     The ok-button is labelled okLabel (or the default, ifNil),
     the cancel-button is labelled cancelLabel (or the default, ifNil).
     Return the string or the value of cancelValue (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial 
        okLabel:okLabel 
        cancelLabel:cancelLabel 
        title:nil 
        onCancel:cancelValue
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     at topLeft (centering is suppressed, to make the box fully visible)    
         Dialog 
            request:'Enter a string:'
            displayAt:0@0
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            onCancel:#foo

     centered around 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            onCancel:#foo

     topLeft of box at 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            onCancel:#foo
    "

    "Created: 7.12.1995 / 23:14:10 / cg"
    "Modified: 29.5.1996 / 14:35:45 / cg"
!

request:aString displayAt:aPoint centered:centered action:resultAction initialAnswer:initial okLabel:okLabel cancelLabel:cancelLabel title:titleString onCancel:cancelValue
    "launch a Dialog, which allows user to enter a string.
     The dialogs window is titled titleString, or the default (if nil).
     If aPoint is nonNil, the box is shown there, optionally centered around it.
     If it is nil, it is shown at the current pointer position or at the 
     screen center (if centered is true).
     The ok-button is labelled okLabel (or the default, ifNil),
     the cancel-button is labelled cancelLabel (or the default, ifNil).
     Return the string or the value of cancelValue (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial 
        okLabel:okLabel 
        cancelLabel:cancelLabel 
        title:titleString 
        onCancel:cancelValue 
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil
!

request:aString displayAt:aPoint centered:centered action:resultAction 
initialAnswer:initial okLabel:okLabel cancelLabel:cancelLabel title:titleString 
onCancel:cancelValue list:listToSelectFrom
    "launch a Dialog, which allows user to enter a string.
     The dialogs window is titled titleString, or the default (if nil).
     If aPoint is nonNil, the box is shown there, optionally centered around it.
     If it is nil, it is shown at the current pointer position or at the 
     screen center (if centered is true).
     The ok-button is labelled okLabel (or the default, ifNil),
     the cancel-button is labelled cancelLabel (or the default, ifNil).
     Return the string or the value of cancelValue (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial 
        okLabel:okLabel 
        cancelLabel:cancelLabel 
        title:titleString 
        onCancel:cancelValue 
        list:listToSelectFrom 
        initialSelection:nil
        entryCompletionBlock:nil

    "
     centered around 200@200:

         Dialog 
            request:'enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     with a list:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo
            list:#(foo bar baz)
    "

    "Created: / 29.5.1996 / 14:35:04 / cg"
    "Modified: / 5.5.1999 / 10:50:22 / cg"
!

request:aString displayAt:aPoint centered:centered action:resultAction 
initialAnswer:initial okLabel:okLabel cancelLabel:cancelLabel title:titleString 
onCancel:cancelValue list:listToSelectFrom initialSelection:anIntervalOrNil
    "launch a Dialog, which allows user to enter a string.
     The dialogs window is titled titleString, or the default (if nil).
     If aPoint is nonNil, the box is shown there, optionally centered around it.
     If it is nil, it is shown at the current pointer position or at the 
     screen center (if centered is true).
     The ok-button is labelled okLabel (or the default, ifNil),
     the cancel-button is labelled cancelLabel (or the default, ifNil).
     Return the string or the value of cancelValue (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial   
        okLabel:okLabel 
        cancelLabel:cancelLabel 
        title:titleString 
        onCancel:cancelValue 
        list:listToSelectFrom 
        initialSelection:anIntervalOrNil
        entryCompletionBlock:nil

    "
     centered around 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            title:'foo'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            title:'foo'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            title:'foo'
            onCancel:#foo

     with a list:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'Yes'
            cancelLabel:'No'
            title:'foo'
            onCancel:#foo
            list:#(foo bar baz)
    "

    "Created: / 29.5.1996 / 14:35:04 / cg"
    "Modified: / 5.5.1999 / 10:50:22 / cg"
!

request:aString displayAt:aPoint centered:centeredOrNil action:resultAction 
initialAnswer:initial okLabel:okLabel cancelLabel:cancelLabel title:titleString 
onCancel:cancelValue list:listToSelectFrom initialSelection:anIntervalOrNil
entryCompletionBlock:entryCompletionBlock
    "launch a Dialog, which allows user to enter a string.
     The dialogs window is titled titleString, or the default (if nil).
     If aPoint is nonNil, the box is shown there, optionally centered around it.
     If it is nil, it is shown at the current pointer position or at the 
     screen center (if centered is true).
     The ok-button is labelled okLabel (or the default, ifNil),
     the cancel-button is labelled cancelLabel (or the default, ifNil).
     Return the string or the value of cancelValue (if cancel was pressed)"

    |box centered|

    listToSelectFrom isNil ifTrue:[
        box := EnterBox title:aString.
    ] ifFalse:[
        box := EnterBoxWithList title:aString.
        box list:listToSelectFrom.
    ].
    initial notNil ifTrue:[ box initialText:initial printString ].
    anIntervalOrNil notNil ifTrue:[
        box selectFromCharacterPosition:anIntervalOrNil start to:anIntervalOrNil stop.
    ].
    box abortAction:[:val | box destroy. ^ cancelValue value].
    okLabel notNil ifTrue:[
        box okText:okLabel.
    ].
    cancelLabel notNil ifTrue:[
        box abortText:cancelLabel 
    ].
    resultAction isNil ifTrue:[
        box action:[:val | box destroy. ^ val]
    ] ifFalse:[
        box action:[:val | box destroy. ^ resultAction value:val]
    ].
    titleString notNil ifTrue:[
        box label:titleString
    ].
    entryCompletionBlock notNil ifTrue:[
"/        box entryCompletionBlock:[:text | box 
"/                                            initialText:(entryCompletionBlock value:text) 
"/                                            selected:false].
        box entryCompletionBlock:entryCompletionBlock.
    ].

    centered := centeredOrNil ? (ForceModalBoxesToOpenAtCenter ? false).

    aPoint notNil ifTrue:[
        box showAt:aPoint center:centered
    ] ifFalse:[
        centered ifTrue:[
            box showAtCenter
        ] ifFalse:[
            box showAtPointer
        ]
    ].
    box destroy. 
    ^ cancelValue value.

    "
     centered around 200@200:

         Dialog 
            request:'Enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'Enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo

     with a list:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            okLabel:'yes'
            cancelLabel:'no'
            title:'foo'
            onCancel:#foo
            list:#(foo bar baz)
    "

    "Created: / 29.5.1996 / 14:35:04 / cg"
    "Modified: / 5.5.1999 / 10:50:22 / cg"
!

request:aString displayAt:aPoint centered:centered action:resultAction initialAnswer:initial onCancel:cancelValue
    "launch a Dialog, which allows user to enter a string.
     If aPoint is nonNil, the box is shown there, optionally centered.
     If it is nil, it is shown at the current pointer position or at the screen center.
     Return the string or the value of cancelValue (if cancel was pressed)"

    ^ self
        request:aString 
        displayAt:aPoint 
        centered:centered 
        action:resultAction 
        initialAnswer:initial 
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:cancelValue
        list:nil
        initialSelection:nil

    "
     at topLeft (centering is suppressed, to make the box fully visible)    
         Dialog 
            request:'enter a string:'
            displayAt:0@0
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     centered around 200@200:

         Dialog 
            request:'enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     topLeft of box at 200@200:

         Dialog 
            request:'enter a string:'
            displayAt:200@200
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo
    "

    "Created: 7.12.1995 / 23:14:10 / cg"
    "Modified: 29.5.1996 / 14:24:39 / cg"
!

request:aString displayAt:aPoint initialAnswer:initial
    "launch a Dialog, which allows user to enter something.
     The boxes topLeft is placed at aPoint, or under the mouse pointer (if aPoint is nil).
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:aPoint 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        onCancel:nil

    "
     Dialog 
         request:'enter a string:' 
         displayAt:(250 @ 250) 
         initialAnswer:'the default' 
    "

    "Modified: 29.5.1996 / 14:29:51 / cg"
!

request:aString initialAnswer:initial
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial 
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'enter a string:' 
         initialAnswer:'the default'  
    "

    "Modified: 29.5.1996 / 14:30:05 / cg"
!

request:aString initialAnswer:initial entryCompletionBlock:entryCompletionBlock
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial 
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:entryCompletionBlock

    "
     Dialog 
         request:'enter a selector:' 
         initialAnswer:'at:p'
         entryCompletionBlock:[:s | |completion|

                                completion := Smalltalk selectorCompletion:s.
                                completion second size > 1 ifTrue:[ Screen current beep].
                                completion first
                              ].  
    "

    "Modified: 29.5.1996 / 14:30:05 / cg"
!

request:aString initialAnswer:initial initialSelection:anIntervalOrNil
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial 
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil 
        list:nil 
        initialSelection:anIntervalOrNil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'enter a string:' 
         initialAnswer:'the default'
         initialSelection:(1 to:3)
    "

    "Modified: 29.5.1996 / 14:30:05 / cg"
!

request:aString initialAnswer:initial list:aList
    "launch a Dialog, which allows user to enter something,
     or select from a list of values.
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:aList
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a string:' 
         initialAnswer:'the default'  
         list:#('foo' 'bar' 'baz')  
    "
    "
     Dialog 
         request:'enter a string:' 
         initialAnswer:'the default'  
         list:((1 to:30) collect:[:i | i printString])  
    "

    "Modified: / 5.5.1999 / 10:53:45 / cg"
!

request:aString initialAnswer:initial okLabel:okLabel title:titleString 
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a string:' 
         initialAnswer:'the default'  
         okLabel:'Yes'      
         title:'Only a Test'      
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
    "Created: 29.5.1996 / 14:59:57 / cg"
!

request:aString initialAnswer:initial okLabel:okLabel title:titleString list:list
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:nil
        list:list
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter or select a string:' 
         initialAnswer:'the default'  
         okLabel:'Yes'      
         title:'Only a Test'      
         list:#('a' 'b' 'c')      
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
    "Created: 29.5.1996 / 14:59:57 / cg"
!

request:aString initialAnswer:initial okLabel:okLabel title:titleString onCancel:cancelAction
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:cancelAction
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a string:' 
         initialAnswer:'the default'  
         onCancel:['foooo']      
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
    "Created: 29.5.1996 / 14:59:57 / cg"
!

request:aString initialAnswer:initial okLabel:okLabel title:titleString onCancel:cancelAction list:listOfChoices
    "launch a Dialog, which allows user to enter something
     (with a list of choices for fast input).
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:cancelAction
        list:listOfChoices
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a String:' 
         initialAnswer:'the default'
         okLabel:'OK'
         title:'demo'
         onCancel:nil
         list:#('foo' 'bar' 'baz')
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
    "Created: 29.5.1996 / 14:59:57 / cg"
!

request:aString initialAnswer:initial okLabel:okLabel title:titleString onCancel:cancelAction list:listOfChoices entryCompletionBlock:entryCompletionBlock
    "launch a Dialog, which allows user to enter something
     (with a list of choices for fast input).
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:cancelAction
        list:listOfChoices
        initialSelection:nil
        entryCompletionBlock:entryCompletionBlock

    "
     Dialog 
         request:'Enter a String:' 
         initialAnswer:'the default'
         okLabel:'OK'
         title:'demo'
         onCancel:nil
         list:#('foo' 'bar' 'baz')
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
    "Created: 29.5.1996 / 14:59:57 / cg"
!

request:aString initialAnswer:initial onCancel:cancelAction
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial
        okLabel:nil
        cancelLabel:nil
        title:nil
        onCancel:cancelAction
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'enter a string:' 
         initialAnswer:'the default'  
         onCancel:['foooo']      
    "

    "Modified: 29.5.1996 / 14:28:24 / cg"
!

request:aString list:listOfChoices
    "launch a Dialog, which allows user to enter something,
     but adds a list of choices for fast input.
     Return the entered string (may be empty string) 
     or the empty string (if cancel was pressed)"

    ^ self request:aString list:listOfChoices initialAnswer:''

    "
     Dialog 
         request:'Enter a string:'
         list:#('foo' 'bar' 'baz')
    "

    "Modified: / 18-08-2011 / 19:29:28 / cg"
!

request:aString list:listOfChoices initialAnswer:initialAnswer
    "launch a Dialog, which allows user to enter something,
     but adds a list of choices for fast input.
     Return the entered string (may be empty string) 
     or the empty string (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initialAnswer 
        okLabel:nil 
        cancelLabel:nil 
        title:nil 
        onCancel:nil 
        list:listOfChoices
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a string:'
         list:#('foo' 'bar' 'baz')
         initialAnswer:'foe'   
    "

    "Modified: / 29-05-1996 / 14:26:25 / cg"
    "Created: / 18-08-2011 / 19:28:13 / cg"
!

request:aString okLabel:okLabel
    "launch a Dialog, which allows user to enter something.
     The okButton is labelled as okLabel.
     Return the entered string (may be empty string) 
     or the empty string (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:''
        okLabel:okLabel
        cancelLabel:nil
        title:nil 
        onCancel:nil 
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
        request:'Enter a string:'
        okLabel:'Yes'
    "

    "Modified: 29.5.1996 / 14:26:25 / cg"
    "Created: 29.5.1996 / 14:31:10 / cg"
!

request:aString okLabel:okLabel onCancel:cancelValue
    "launch a Dialog, which allows user to enter something.
     The okButton is labelled as okLabel.
     Return the entered string (may be empty string) 
     or the value from evaluating cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:''
        okLabel:okLabel
        cancelLabel:nil
        title:nil 
        onCancel:cancelValue
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
        request:'Enter a string:'
        okLabel:'Yes'
        onCancel:nil    
    "

    "Modified: 29.5.1996 / 14:32:00 / cg"
!

request:aString okLabel:okLabel title:titleString onCancel:cancelValue
    "launch a Dialog, which allows user to enter something.
     The okButton is labelled as okLabel.
     Return the entered string (may be empty string) 
     or the value from evaluating cancelValue (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:''
        okLabel:okLabel
        cancelLabel:nil
        title:titleString
        onCancel:cancelValue
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
        request:'Enter a String:'
        okLabel:'Yes'
        title:'foo'
        onCancel:nil    
    "

    "Modified: 29.5.1996 / 14:32:00 / cg"
    "Created: 29.5.1996 / 14:57:02 / cg"
!

request:aString onCancel:cancelActionOrValue
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) 
     or the value of cancelAction (if cancel was pressed)."

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:''
        okLabel:nil
        cancelLabel:nil
        title:nil
        onCancel:cancelActionOrValue
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'Enter a String:'
         onCancel:nil       
    "

    "Created: 27.1.1996 / 14:31:45 / cg"
    "Modified: 29.5.1996 / 14:28:59 / cg"
!

request:aString title:windowTitle
    "launch a Dialog, which allows user to enter a string."

    ^ self
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:nil 
        okLabel:nil 
        cancelLabel:nil 
        title:windowTitle 
        onCancel:''
        list:nil
        initialSelection:nil

    "
     at topLeft (centering is suppressed, to make the box fully visible)    
         Dialog 
            request:'enter a string:'
            displayAt:0@0
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     centered around 200@200:

         Dialog 
            request:'enter a string:'
            displayAt:200@200
            centered:true
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     topLeft of box at 200@200:

         Dialog 
            request:'enter a string:'
            displayAt:200@200
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     under mouse pointer:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:false 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo

     centered on the screen:

         Dialog 
            request:'enter a string:'
            displayAt:nil
            centered:true 
            action:[:result | result printNewline]
            initialAnswer:'the default'
            onCancel:#foo
    "

    "Created: 7.12.1995 / 23:14:10 / cg"
    "Modified: 29.5.1996 / 14:24:39 / cg"
!

request:aString title:titleString initialAnswer:initial
    "launch a Dialog, which allows user to enter something.
     Return the entered string (may be empty string) or nil (if cancel was pressed)"

    ^ self 
        request:aString 
        displayAt:nil 
        centered:(ForceModalBoxesToOpenAtCenter ? false) 
        action:nil 
        initialAnswer:initial 
        okLabel:nil 
        cancelLabel:nil 
        title:titleString 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:nil

    "
     Dialog 
         request:'enter a string:' 
         initialAnswer:'the default'  
    "

    "Modified: 29.5.1996 / 14:30:05 / cg"
!

requestNumber:aString 
    "launch a Dialog, which allows user to enter a number.
     Return the numeric value or nil 
     (for an invalid number or if cancel was pressed)"

    |string|

    string := self request:aString.
    ^ Number readFrom:string onError:nil.

    "
     Dialog requestNumber:'Enter your Age:'      
    "

    "Created: 17.11.1995 / 09:45:21 / cg"
!

requestNumber:aString initialAnswer: aNumber
    "launch a Dialog, which allows user to enter a number.
     Return the numeric value or nil 
     (for an invalid number or if cancel was pressed)"

    |string|

    string := self request:aString initialAnswer: aNumber.
    ^ Number readFrom:string onError:nil.

    "
     Dialog requestNumber:'Enter your Age:' initialAnswer: 25     
    "

    "Created: / 26-07-2006 / 12:22:23 / fm"
    "Modified: / 07-08-2006 / 15:31:30 / fm"
!

requestPassword:aString 
    "launch a Dialog, which allows user to enter something invisibly.
     Return the entered string (may be empty string) 
     or nil (if cancel was pressed)"

    ^ EnterBox requestPassword:aString 

    "
     Dialog 
         requestPassword:'Enter Secret:'
    "

    "Created: 17.11.1995 / 09:45:21 / cg"
!

requestPassword:aString initialAnswer:defaultAnswer
    "launch a Dialog, which allows user to enter something invisibly.
     Return the entered string (may be empty string) 
     or nil (if cancel was pressed)"

    ^ EnterBox new initialText:defaultAnswer; requestPassword:aString 

    "
     Dialog 
         requestPassword:'Enter Secret:'
         initialText:'blabla'
    "
!

requestText:title
    "open a dialog asking for multiline text.
     Return a stringCollection or nil if cancelled."

    ^ self 
        requestText:title initialAnswer:'' initialSelection:nil

    "
     Dialog requestText:'Bla'
    "
!

requestText:title initialAnswer:initialAnswer 
    "open a dialog asking for multiline text.
     Return a stringCollection or nil if cancelled."

    ^ self 
        requestText:title initialAnswer:initialAnswer initialSelection:nil

    "
     Dialog requestText:'Bla' initialAnswer:'Hello world'
    "
!

requestText:title initialAnswer:initialAnswer initialSelection:anIntervalOrNil
    "open a dialog asking for multiline text.
     Return a stringCollection or nil if cancelled."

    ^ self 
        requestText:title lines:10 columns:60 initialAnswer:initialAnswer initialSelection:anIntervalOrNil

    "
     Dialog requestText:'Bla' initialAnswer:'Hello world' initialSelection:(1 to:5)
    "
!

requestText:title lines:numLines columns:numCols initialAnswer:initialText
    "open a dialog asking for multiline text.
     Return a stringCollection or nil if cancelled."

    ^ self
        requestText:title lines:numLines columns:numCols 
        initialAnswer:initialText initialSelection:nil

    "
     Dialog requestText:'Bla' lines:8 columns:40 initialAnswer:'hello world'
    "

   "Modified: / 18.8.2000 / 21:45:41 / cg"
!

requestText:title lines:numLines columns:numCols initialAnswer:initialText initialSelection:anIntervalOrNil
    "open a dialog asking for multiline text.
     Return a stringCollection or nil if cancelled."

    |dialog textHolder|

    textHolder := ValueHolder new.
    dialog := Dialog 
                forRequestText:title editViewClass:EditTextView
                lines:numLines columns:numCols 
                initialAnswer:initialText initialSelection:anIntervalOrNil 
                model:textHolder.
    dialog open.
    dialog accepted ifTrue:[
        ^ textHolder value
    ].
    ^ nil

    "
     Dialog 
        requestText:'Bla' lines:8 columns:40 initialAnswer:'hello world'

     Dialog 
        requestText:'Bla2' lines:8 columns:40 initialAnswer:'hello world' initialSelection:(1 to:5)
   "

   "Modified: / 18.8.2000 / 21:45:41 / cg"
! !

!DialogBox class methodsFor:'multiple choice dialogs'!

choose:aString fromList:list lines:maxLines 
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the value
     from list is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:(list collect:[:each| each printString]) values:list
        initialSelection:nil
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:nil
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
     )
    "

    "Modified: / 02-03-2007 / 12:08:31 / cg"
!

choose:aString fromList:list lines:maxLines initialSelection:initialSelection
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the value
     from list is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:list initialSelection:initialSelection
        buttons:nil values:nil 
        lines:maxLines 
        cancel:nil     
        multiple:false 
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            initialSelection:4
     )
    "

    "Modified: 27.1.1996 / 14:17:07 / cg"
!

choose:aString fromList:list lines:maxLines initialSelection:initialSelection title:windowTitle
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the value
     from list is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:(list collect:[:each| each printString]) values:list
        initialSelection:initialSelection
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:windowTitle
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            title:'Choose'    
     )
    "

    "Created: / 02-03-2007 / 12:06:39 / cg"
!

choose:aString fromList:list lines:maxLines title:windowTitle
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the value
     from list is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:(list collect:[:each| each printString]) values:list
        initialSelection:nil
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:windowTitle
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            title:'Choose'    
     )
    "

    "Modified: / 02-03-2007 / 12:08:20 / cg"
!

choose:aString fromList:list values:listValues buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        buttons:buttonLabels values:buttonValues 
        lines:maxLines 
        cancel:cancelBlock 
        multiple:false

    "
     full example:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:10 
                cancel:nil
         )


     no buttons:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:4
                cancel:nil
         )


     no list (lines argument is ignored):

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:nil
                values:nil
                buttons:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                lines:nil
                cancel:nil
         )


      full including cancel value:

         Transcript showCR:(
             Dialog 
                choose:'choose example' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:4
                cancel:[Transcript flash. #aborted]
         )


     degenerated:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:nil
                values:nil
                buttons:nil
                values:nil
                lines:nil 
                cancel:nil
         )


    "

    "Modified: / 02-03-2007 / 12:08:12 / cg"
!

choose:aString fromList:list values:listValues buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock multiple:multiple
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        buttons:buttonLabels values:buttonValues 
        lines:maxLines 
        cancel:cancelBlock 
        multiple:multiple
        postBuildBlock:nil

    "Modified: / 02-03-2007 / 12:08:06 / cg"
!

choose:aString fromList:list values:listValues buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock multiple:multiple postBuildBlock:aBlockOrNil
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        initialSelection:nil
        buttons:buttonLabels values:buttonValues 
        default:nil
        lines:maxLines 
        cancel:cancelBlock     
        multiple:multiple 
        title:nil
        postBuildBlock:aBlockOrNil

    "
     full example:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:10 
                cancel:nil
                multiple:true
         )


     no buttons:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:4
                cancel:nil
                multiple:true
         )
    "

    "Modified: / 02-03-2007 / 12:08:02 / cg"
!

choose:aString fromList:list values:listValues buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock postBuildBlock:postBuildBlock
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        buttons:buttonLabels values:buttonValues 
        lines:maxLines 
        cancel:cancelBlock 
        multiple:false
        postBuildBlock:postBuildBlock.


    "
     full example:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:10 
                cancel:nil
         )


     no buttons:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:4
                cancel:nil
         )


     no list (lines argument is ignored):

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:nil
                values:nil
                buttons:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                lines:nil
                cancel:nil
         )


      full including cancel value:

         Transcript showCR:(
             Dialog 
                choose:'choose example' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#('five' 'six' 'seven')
                values:#(5 6 7)
                lines:4
                cancel:[Transcript flash. #aborted]
         )


     degenerated:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:nil
                values:nil
                buttons:nil
                values:nil
                lines:nil 
                cancel:nil
         )


    "

    "Modified: / 02-03-2007 / 12:08:12 / cg"
!

choose:aString fromList:list values:listValues initialSelection:initialListSelectionOrNil buttons:buttonLabels values:buttonValues default:defaultValue lines:maxLines cancel:cancelBlock multiple:multiple postBuildBlock:aBlockOrNil
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        initialSelection:initialListSelectionOrNil 
        buttons:buttonLabels values:buttonValues 
        default:defaultValue 
        lines:maxLines 
        cancel:cancelBlock 
        multiple:multiple 
        title:nil
        postBuildBlock:aBlockOrNil

    "Modified: / 02-03-2007 / 12:07:57 / cg"
!

choose:aString fromList:list values:listValues initialSelection:initialListSelectionOrNil buttons:buttonLabels values:buttonValues default:defaultValue lines:maxLines cancel:cancelBlock multiple:multiple title:windowTitle postBuildBlock:aBlockOrNil
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        initialSelection:initialListSelectionOrNil 
        buttons:buttonLabels values:buttonValues 
        default:defaultValue 
        lines:maxLines width:nil
        cancel:cancelBlock 
        multiple:multiple 
        title:windowTitle 
        postBuildBlock:aBlockOrNil

    "
     full example:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') values:#(1 2 3 4) 
                initialSelection: nil
                buttons:#('five' 'six' 'seven') values:#(5 6 7)
                default:6
                lines:10 
                cancel:nil
                multiple:true
                postBuildBlock:nil
         )


     no buttons:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:4
                cancel:nil
                multiple:true
         )
    "

    "Created: / 22-08-2006 / 16:10:19 / cg"
!

choose:aString fromList:list values:listValues initialSelection:initialListSelectionOrNil buttons:buttonLabels values:buttonValues default:defaultValue lines:maxLines width:boxWidthOrNil cancel:cancelBlock multiple:multiple title:windowTitle postBuildBlock:aBlockOrNil
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     The buttonValue may be a block of up to 3 arguments; it gets the selection, the box and selIndices as args.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    |box listView panel sel haveDefault|

    haveDefault := false.

    box := Dialog new.
    (box addTextLabel:aString) adjust:#left.

    list notNil ifTrue:[
        listView := HVScrollableView for:SelectionInListView.
        listView autoHideScrollBars:true.
"/        maxLines <= list size ifTrue:[
"/            listView := HVScrollableView for:SelectionInListView.
"/        ] ifFalse:[
"/            listView := SelectionInListView new.
"/            listView level:-1.
"/        ].
        listView list:list.
        listView doubleClickAction:[:selectionIndex | 
            |val okButton|

            multiple ifTrue:[
                val := selectionIndex collect:[:idx | listValues at:idx].
            ] ifFalse:[
                val := listValues at:selectionIndex.
            ].
            (box okButton notNil and:[box okButton isReturnButton]) ifTrue:[
                box destroy. 
            ] ifFalse:[
                okButton := box allSubViewsDetect:[:v | v isDefault] ifNone:nil.
                okButton notNil ifTrue:[
                    okButton controller performAction
                ]
            ].
            ^ val
        ].
        listView multipleSelectOk:multiple.

        initialListSelectionOrNil notNil ifTrue:[
            multiple ifTrue:[
                listView selection:(initialListSelectionOrNil collect:[:each| listValues indexOf:each])
            ] ifFalse:[
                listView selection:(listValues indexOf:initialListSelectionOrNil)
            ]
        ].
        box addComponent:listView indent:(ViewSpacing // 2) withHeight:(listView heightForLines:maxLines).
        box makeTabable:listView.
        box name:listView as:#ListView.
    ].

    buttonLabels size > 0 ifTrue:[
        panel := HorizontalPanelView new.
        panel horizontalLayout:#fitSpace.
        buttonLabels keysAndValuesDo:[:index :label |
            |b|

            b := Button label:label.
            b action:[
                |val selectionValues listSelection|

                listSelection := listView selection.
                listSelection notNil ifTrue:[
                    listSelection isCollection ifFalse:[ listSelection := Array with:listSelection ].
                    selectionValues := listValues isNil 
                                        ifTrue:[ listSelection ]
                                        ifFalse:[ listSelection collect:[:idx | listValues at:idx]].
                ].
                val := buttonValues at:index.
                val isBlock ifTrue:[ 
                    val := val valueWithOptionalArgument:selectionValues and:box and:listView selection
                ] ifFalse:[
                    multiple ifTrue:[
                        val := Array with:val
                    ].
                ].
                box destroy. 
                ^ val
            ].
            haveDefault ifFalse:[
                defaultValue notNil ifTrue:[
                    (buttonValues at:index) = defaultValue ifTrue:[
                        b isReturnButton:true.
                        haveDefault := true.
                    ].
                ].
            ].
            panel add:b.
            box makeTabable:b.
        ].
        box addComponent:panel indent:0.  "/ panel has its own idea of indenting
        box name:panel as:#ButtonPanel2.
    ].
    box addAbortButton.
    list notNil ifTrue:[
        haveDefault ifTrue:[
            (box addOkButton) isReturnButton:false.
        ] ifFalse:[
            box addOkButton.
        ].
    ].

    listView notNil ifTrue:[box stickAtBottomWithVariableHeight:listView].
    panel notNil ifTrue:[box stickAtBottomWithFixHeight:panel].

    aBlockOrNil notNil ifTrue:[
        aBlockOrNil value:box
    ].
    windowTitle notNil ifTrue:[
        box label:windowTitle.
    ].
    boxWidthOrNil notNil ifTrue:[
        box width:(boxWidthOrNil max:250).
    ] ifFalse:[
        box width < 250 ifTrue:[
            box width:250.
        ]
    ].

    self showBox:box.

    "/ notice: if one of the extra buttons is pressed, we do not arrive here, and the returned value
    "/ is the value returned by the button-value (which might be a block)

    box accepted ifTrue:[
        (sel := listView selection) notNil ifTrue:[
            box destroy. 
            sel isInteger ifTrue:[
                ^ listValues at:sel
            ].
            ^ sel collect:[:idx | listValues at:idx]
        ].
        box destroy. 
        ^ multiple ifTrue:[ #() ] ifFalse:[ nil ]
    ].
    box destroy. 
    ^ cancelBlock value

    "
     full example:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') values:#(1 2 3 4) 
                initialSelection: nil
                buttons:#('five' 'six' 'seven') values:#(5 6 7)
                default:6
                lines:10 
                cancel:nil
                multiple:true
                postBuildBlock:nil
         )


     no buttons:

         Transcript showCR:(
             Dialog 
                choose:'choose any' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:4
                cancel:nil
                multiple:true
         )
    "

    "Created: / 08-11-2011 / 12:15:20 / cg"
!

choose:aString fromList:list values:listValues initialSelection:initialListSelectionOrNil buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock multiple:multiple postBuildBlock:aBlockOrNil
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     If a list is present, multiple controls if multiple selections are allowed.
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns nil or an empty collection (if multiple is true)."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        initialSelection:initialListSelectionOrNil 
        buttons:buttonLabels values:buttonValues 
        default:nil
        lines:maxLines 
        cancel:cancelBlock 
        multiple:multiple 
        title:nil
        postBuildBlock:aBlockOrNil

    "Modified: / 02-03-2007 / 12:07:47 / cg"
!

choose:aString fromList:list values:listValues lines:maxLines 
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:(list collect:[:each| each printString]) values:listValues
        initialSelection:nil
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:nil
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#('one' 'two' 'three') 
            values:#(1 2 3) 
            lines:4
     )
    "

    "Modified: / 02-03-2007 / 12:08:31 / cg"
!

choose:aString fromList:list values:listValues lines:maxLines cancel:cancelBlock
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:listValues
        buttons:nil values:nil
        lines:maxLines
        cancel:cancelBlock
        multiple:false
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#('one' 'two' 'three' 'four') 
            values:#(1 2 3 4) 
            lines:4
            cancel:nil
     )

     Transcript showCR:(
         Dialog 
            choose:'choose example' 
            fromList:#('one' 'two' 'three' 'four') 
            values:#(1 2 3 4) 
            lines:4
            cancel:[Transcript flash. #aborted]
     )
    "

    "Modified: / 02-03-2007 / 12:07:42 / cg"
!

choose:aString fromList:list values:values lines:maxLines cancel:cancelBlock title:windowTitle
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:values
        initialSelection:nil
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:cancelBlock
        multiple:false
        title:windowTitle
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            title:'Choose'    
     )
    "

    "Created: / 02-03-2007 / 12:07:32 / cg"
!

choose:aString fromList:list values:values lines:maxLines initialSelection:initialSelection title:windowTitle
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:values
        initialSelection:initialSelection
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:windowTitle
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            title:'Choose'    
     )
    "

    "Created: / 02-03-2007 / 12:07:32 / cg"
!

choose:aString fromList:list values:values lines:maxLines title:windowTitle
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection is treated like cancel."

    ^ self
        choose:aString 
        fromList:list values:values
        initialSelection:nil
        buttons:nil values:nil
        default:nil
        lines:maxLines
        cancel:nil
        multiple:false
        title:windowTitle
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            choose:'choose any' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
            title:'Choose'    
     )
    "

    "Created: / 02-03-2007 / 12:07:32 / cg"
!

choose:aString label:windowLabel image:imageOrNil labels:buttonLabels values:values default:default onCancel:cancelValue
    "launch a Dialog, which allows user to enter any of buttonLabels.
     Returning a corresponding value from the values-array.
     The default entries button is marked as a return button and entering
     return will choose that value; hitting escape returns cancelValue.
     For a good userInterface style, we recommend this being the last
     entry (to make the right-most button the default button)."

    |box answer idx|

    box := OptionBox title:aString numberOfOptions:buttonLabels size. 
    windowLabel notNil ifTrue:[
        box label:windowLabel
    ].
    imageOrNil notNil ifTrue:[
        box image:imageOrNil
    ].

    box buttonTitles:(self classResources array:buttonLabels)
             actions:(values collect:[:val | [answer := val]]).
    answer := cancelValue.
    box buttons last isReturnButton:false.
    idx := values indexOf:default.
    idx ~~ 0 ifTrue:[box defaultButtonIndex:idx].

    self showAndThenDestroyBox:box.
    box actions:nil.
    ^ answer

    "no good style (default button is not the rightmost one)

     Dialog 
        choose:'choose any' 
        label:'Foo Bar Baz'
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:2     
        onCancel:1      

     Dialog 
        choose:'choose any' 
        labels:#('cancel' 'foo' 'bar' 'baz') 
        values:#(nil foo bar baz) 
        default:#baz     

      Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:nil 
    "

    "Modified: / 16.11.2001 / 14:55:33 / cg"
    "Created: / 16.11.2001 / 15:04:16 / cg"
!

choose:aString label:windowLabel labels:buttonLabels values:values default:default
    "launch a Dialog, which allows user to enter any of buttonLabels.
     Returning a corresponding value from the values-array.
     The default entries button is marked as a return button and entering
     return will choose that value; hitting escape returns nil.
     For a good userInterface style, we recommend this being the last
     entry (to make the right-most button the default button)."

    ^ self
        choose:aString 
        label:windowLabel image:nil
        labels:buttonLabels values:values 
        default:default
        onCancel:nil

    "no good style (default button is not the rightmost one)

     Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:2     

     Dialog 
        choose:'choose any' 
        labels:#('cancel' 'foo' 'bar' 'baz') 
        values:#(nil foo bar baz) 
        default:#baz     

      Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:nil 
    "

    "Created: / 22-07-1996 / 11:44:27 / cg"
    "Modified: / 02-03-2007 / 12:09:01 / cg"
!

choose:aString label:windowLabel labels:buttonLabels values:values default:default onCancel:cancelValue
    "launch a Dialog, which allows user to enter any of buttonLabels.
     Returning a corresponding value from the values-array.
     The default entries button is marked as a return button and entering
     return will choose that value; hitting escape returns cancelValue.
     For a good userInterface style, we recommend this being the last
     entry (to make the right-most button the default button)."

    ^ self
        choose:aString 
        label:windowLabel image:nil
        labels:buttonLabels values:values 
        default:default onCancel:cancelValue

    "no good style (default button is not the rightmost one)

     Dialog 
        choose:'choose any' 
        label:'Foo Bar Baz'
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:2     
        onCancel:1      

     Dialog 
        choose:'choose any' 
        labels:#('cancel' 'foo' 'bar' 'baz') 
        values:#(nil foo bar baz) 
        default:#baz     

      Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:nil 
    "

    "Created: / 16-11-2001 / 14:53:55 / cg"
    "Modified: / 02-03-2007 / 12:08:44 / cg"
!

choose:aString labels:buttonLabels values:values default:default
    "launch a Dialog, which allows user to enter any of buttonLabels.
     Returning a corresponding value from the values-array.
     The default entries button is marked as a return button and entering
     return will choose that value.
     For a good userInterface style, we recommend this being the last
     entry (to make the right-most button the default button)."

    ^ self
        choose:aString 
        label:nil image:nil
        labels:buttonLabels values:values 
        default:default
        onCancel:nil


    "no good style (default button is not the rightmost one)

     Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:2 

     Dialog 
        choose:'choose any' 
        labels:#('cancel' 'foo' 'bar' 'baz') 
        values:#(nil foo bar baz) 
        default:#baz     

      Dialog 
        choose:'choose any' 
        labels:#('one' 'two' 'three' 'four') 
        values:#(1 2 3 4) 
        default:nil 
    "

    "Modified: / 02-03-2007 / 12:08:55 / cg"
!

chooseMultiple:aString fromList:list lines:maxLines 
    "launch a Dialog showing the message and list.
     The user can select any combination of items and click ok; 
     in this case, the values from list is returned (doubleclick works as well).
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns an empty collection."

    ^ self
        choose:aString 
        fromList:(list collect:[:each| each printString]) values:list
        initialSelection:nil
        buttons:nil values:nil
        default:#()
        lines:maxLines
        cancel:nil
        multiple:true
        title:nil
        postBuildBlock:nil

    "
     Transcript showCR:(
         Dialog 
            chooseMultiple:'choose any combination' 
            fromList:#(1 2 3 4 5 6 7) 
            lines:4
     )
    "

    "Modified: / 02-03-2007 / 12:08:31 / cg"
!

chooseMultiple:aString fromList:list values:listValues buttons:buttonLabels values:buttonValues lines:maxLines cancel:cancelBlock
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns an empty collection."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        buttons:buttonLabels values:buttonValues 
        lines:maxLines 
        cancel:cancelBlock 
        multiple:true

    "
     full example:

         Transcript showCR:(
             Dialog 
                chooseMultiple:'choose selected' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:nil
                values:nil
                lines:10 
                cancel:nil
         )

         Transcript showCR:(
             Dialog 
                chooseMultiple:'choose selected' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                buttons:#()
                values:#()
                lines:10 
                cancel:nil
         )
    "

    "Modified: / 02-03-2007 / 12:09:10 / cg"
!

chooseMultiple:aString fromList:list values:listValues initialSelection:initialListSelectionOrNil lines:maxLines
    "launch a Dialog showing the message and list.
     The user can select an item and click ok; in this case, the corresponding value
     from listValues is returned (doubleclick works as well). 
     The list may be suppressed (if the list arg is nil).
     Below the list, an optional row of buttons is shown, which can also be
     clicked upon, and a corresponding value from buttonValues is returned.
     If cancel is pressed, the value of cancelBlock is returned.
     Pressing ok without a selection returns an empty collection."

    ^ self
        choose:aString 
        fromList:list values:listValues 
        initialSelection:initialListSelectionOrNil
        buttons:nil values:nil 
        lines:maxLines 
        cancel:nil 
        multiple:true
        postBuildBlock:nil

    "
     full example:

         Transcript showCR:(
             Dialog 
                chooseMultiple:'choose selected' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#(1 2 3 4) 
                initialSelection:#(2 4)
                lines:10 
         )

         Transcript showCR:(
             Dialog 
                chooseMultiple:'choose selected' 
                fromList:#('one' 'two' 'three' 'four') 
                values:#('one' 'two' 'three' 'four') 
                initialSelection:#( 'two' 'three')
                lines:10 
         )
    "

    "Created: / 18-08-2000 / 22:38:13 / cg"
    "Modified: / 02-03-2007 / 12:09:15 / cg"
! !

!DialogBox class methodsFor:'on the fly modifications'!

modifyingBoxWith:modifyBlock do:openingBlock
    "perform openingBlock (which usually creates a standard dialog box),
     but call modifyBlock right before the dialog is actually opened.
     This allows modifyBlock to add additional controls to the dialog.
     ModifyBlock is called with the box as argument."

    Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
        |box|

        box := ex box.
        modifyBlock value:box.
        ex proceed.
    ] do:openingBlock.

    "
     Dialog 
        modifyingBoxWith:[:box |
            box allViewBackground:Color red.
        ] do:[
            Dialog information:'hello'
        ].
    "
!

withOptoutOption:optOutAction1 labelled:labelString1 
    andOptoutOption:optOutAction2 labelled:labelString2
    do:boxOpeningBlock

    "launch a Dialog to warn user. 
     Add two 'do not show this dialog again'-like checkboxes,
     and call optOutActionX after the dialog, if the checkbox was indeed checked."

    |optOutHolder1 optOutHolder2|

    optOutHolder1 := false asValue.
    optOutHolder2 := false asValue.
    [
        self 
            modifyingBoxWith:[:box |
                box verticalPanel 
                    add:((CheckBox label:labelString1) model:optOutHolder1);
                    add:((CheckBox label:labelString2) model:optOutHolder2).
            ] 
            do:boxOpeningBlock
    ] ensure:[
        optOutHolder1 value ifTrue:[ optOutAction1 value ].
        optOutHolder2 value ifTrue:[ optOutAction2 value ].
    ].

    "
     Dialog 
        withOptoutOption:[Transcript flash] labelled:'opt out1' 
        andOptoutOption:[Transcript show:'wow'] labelled:'opt out2' 
        do:[ Dialog confirm:'some question' ].
    "

    "Created: / 18-11-2016 / 11:26:06 / cg"
    "Modified: / 22-11-2016 / 04:21:10 / cg"
!

withOptoutOption:optOutAction labelled:labelString do:boxOpeningBlock
    "launch a Dialog to warn user. 
     Add a 'do not show this dialog again'-like checkbox,
     and call optOutAction after the dialog, if the checkbox was indeed checked."

    |holder|

    holder := false asValue.
    [
        self 
            modifyingBoxWith:[:box |
                box verticalPanel add:((CheckBox label:labelString) model:holder).
            ] 
            do:boxOpeningBlock.
    ] ensure:[
        holder value ifTrue:[optOutAction value]
    ]

    "
     Dialog 
        withOptoutOption:[Transcript flash] 
        labelled:'opt out' 
        do:[ Dialog confirm:'some question' ].
    "

    "Modified: / 22-11-2016 / 04:20:38 / cg"
!

withOptoutOption:optOutAction labelled:labelString warn:warnString
    "launch a Dialog to warn user. 
     Add a 'do not show this dialog again'-like checkbox,
     and call optOutAction after the warning, if the checkbox was indeed checked."

    self
        withOptoutOption:optOutAction 
        labelled:labelString 
        do:[self warn:warnString]

    "
     Dialog 
        withOptoutOption:[Transcript flash] 
        labelled:'opt out' 
        warn:'some warning'.
    "
! !

!DialogBox class methodsFor:'private'!

showAndThenDestroyBox:aBox
    [
        self showBox:aBox.
    ] ensure:[
        aBox destroy
    ]
!

showBox:aBox
    |wg v|

    ForceModalBoxesToOpenAtCenter == true ifTrue:[
        aBox showAtCenter.
        ^ self.
    ].
    ForceModalBoxesToOpenAtPointer == true ifTrue:[
        aBox showAtPointer.
        ^ self.
    ].

    wg := WindowGroup activeGroup.
    wg isNil ifTrue:[
        aBox showAtCenter.
        ^ self.
    ].
    wg isDebugged ifTrue:[
        aBox showAtPointer.
        ^ self.
    ].

    wg isModal ifTrue:[
        v := wg mainView.
        v notNil ifTrue:[
            aBox showCenteredIn:v.
            ^ self.
        ].
    ].

    v := wg mainGroup mainView.
    v isNil ifTrue:[
        aBox showAtCenter.
        ^ self.
    ].

    aBox showCenteredIn:v.

    "Modified: / 29-08-2013 / 16:39:29 / cg"
! !

!DialogBox class methodsFor:'queries'!

defaultOKButtonAtLeft
    "somewhat of a kludge:
     some viewStyles have ok at left (motif), others at right..."

    ^ (StyleSheet at:'dialogBox.okAtLeft' default:false)

    "
     DialogBox defaultOKButtonAtLeft
    "
!

defaultParentWindow
    "return a default parent (top-) window for the dialog.
     Here, the currently active view is returned, if there
     is one; otherwise, the first encountered topView is
     returned."

    |activeGroup|

    activeGroup := WindowGroup activeGroup.
    activeGroup isNil ifTrue:[
        "/ mhmh - looks like I am a background process ...
        activeGroup := Transcript windowGroup.
        activeGroup isNil ifTrue:[^ nil].
    ].
    ^ activeGroup topViews first.

    "
     self defaultParentWindow
    "

    "Modified: / 16.6.1998 / 12:36:15 / cg"
!

patternForFilters:filtersOrNil
    "argument #filtersOrNil is window specific,
     it is an array of arrays with filter (*.zip) and its description (ZIP compressed archive file)
     to support a call with just #filtersOrNil and no #patternOrNil the pattern will be extracted from the #filtersOrNil for linux

     which is done here"

    filtersOrNil isEmptyOrNil ifTrue:[
        ^ nil
    ].

    ^ (filtersOrNil 
        collect:[:each | each last])
            asStringWith:'; '      
! !

!DialogBox class methodsFor:'smalltalk dialogs'!

imageSaveDialog:title image:image default:defaultFileName pattern:pattern
    "a complete bitmap image save dialog.
     Offers edit and save as button options.
     Returns the fileName if saved, nil if not"
    
    |fileName|

    fileName := self
                    requestFileNameForImageSave:title 
                    image:image 
                    default:defaultFileName 
                    pattern:pattern. 

    fileName isEmptyOrNil ifTrue:[^ nil].
    
    image saveOn:fileName.
    ImageEditView notNil ifTrue:[
        ImageEditView lastSaveDirectory:(fileName asFilename directory pathName).
    ].
    ^ fileName

    "
     Dialog
        imageSaveDialog:'save screen image' 
        image:(Image fromScreen:(0@0 corner:100@100)) 
        default:'screen.png' 
        pattern:'*.png;*.gif;*.bmp'
    "
!

requestClass:aString
    "launch a Dialog, which allows user to enter an existing classes name.
     Return the entered class or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self requestClass:aString okLabel:'OK' initialAnswer:nil.

    "
     Dialog 
         requestClass:'Enter a class:'
    "
!

requestClass:aString initialAnswer:initialAnswer
    "launch a Dialog, which allows user to enter an existing classes name.
     Return the entered class or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self requestClass:aString okLabel:'OK' initialAnswer:initialAnswer.

    "
     Dialog 
         requestClass:'Enter a class:'
         initialAnswer:'Array'
    "
!

requestClass:aString list:list okLabel:okLabel initialAnswer:initial
    "launch a Dialog, which allows user to enter an existing classes name.
     Return the entered class or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     |className|

     className := self requestClassName:aString list:list okLabel:okLabel initialAnswer:initial.
     className isEmptyOrNil ifTrue:[^ nil].
     ^ Smalltalk classNamed:className

    "
     Dialog 
         requestClass:'Enter a class:'
         list:(View withAllSubclasses copy sortBySelector:#name)
         okLabel:'OK'
         initialAnswer:'Arr'        
    "

    "Created: / 12-01-2008 / 23:02:28 / cg"
!

requestClass:aString okLabel:okLabel initialAnswer:initial
    "launch a Dialog, which allows user to enter an existing class's name.
     Return the entered class or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self requestClass:aString list:nil okLabel:okLabel initialAnswer:initial

    "
     Dialog 
         requestClass:'Enter a class:'
         okLabel:'OK'
         initialAnswer:'Arr'        
    "

    "Modified: / 12-01-2008 / 23:02:42 / cg"
!

requestClassName:aString initialAnswer:initial
    "launch a Dialog, which allows user to enter a class name.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self requestClassName:aString list:nil okLabel:'OK' initialAnswer:initial

    "
     Dialog 
         requestClassName:'enter a class:'
         initialAnswer:'Arr'        
    "

    "Modified: / 12-01-2008 / 22:58:13 / cg"
!

requestClassName:aString list:list okLabel:okLabel initialAnswer:initial
    "launch a Dialog, which allows user to enter a class name.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self
        request:aString 
        displayAt:nil 
        centered:nil 
        action:nil 
        initialAnswer:initial 
        okLabel:okLabel 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:list
        initialSelection:nil
        entryCompletionBlock:DoWhatIMeanSupport classNameEntryCompletionBlock

    "
     Dialog 
         requestClassName:'Enter a class:'
         list:(Array with:Array with:String with:Point)
         okLabel:'OK'
         initialAnswer:'Arr'        
    "

    "Created: / 12-01-2008 / 22:58:01 / cg"
!

requestClassName:aString okLabel:okLabel initialAnswer:initial
    "launch a Dialog, which allows user to enter a class name.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     The entryField does classNameCompletion on TAB."

     ^ self requestClassName:aString list:nil okLabel:okLabel initialAnswer:initial

    "
     Dialog 
         requestClassName:'enter a class:'
         okLabel:'OK'
         initialAnswer:'Arr'        
    "

    "Modified: / 12-01-2008 / 22:58:13 / cg"
!

requestName:title fromList:nameList title:boxTitle initialAnswer:initialTextOrNil
    "Ask for a name from a list (used for namespaces and sharedPools)"

    |newName box|

    box := ListSelectionBox new.
    box title:title.
    box list:nameList.
    box okAction:[:sel | newName := sel].
    box initialText:initialTextOrNil.
    boxTitle notNil ifTrue:[ box label:boxTitle ].
    box showAtPointer.

    newName notNil ifTrue:[
        newName := newName withoutSeparators.
    ].
    ^ newName

    "
     Dialog 
        requestName:'Select a Name' 
        fromList:#('foo' 'bar' 'baz') 
        title:'blabla'
        initialAnswer:nil
    "
!

requestNameSpace:title initialAnswer:initialTextOrNil
    "Ask for a namespaces name"

    ^ self
        requestNameSpace:title 
        title:title 
        initialAnswer:initialTextOrNil

    "
     Dialog 
        requestNameSpace:'Select a NameSpace' 
        initialAnswer:nil
    "
!

requestNameSpace:title title:boxTitle initialAnswer:initialTextOrNil
    "Ask for a namespaces name"

    |allNameSpaces|

    allNameSpaces := NameSpace allNameSpaces collect:[:each | each name].
    allNameSpaces := allNameSpaces asOrderedCollection sort.

    ^ self
        requestName:title 
        fromList:allNameSpaces 
        title:boxTitle 
        initialAnswer:initialTextOrNil

    "
     Dialog 
        requestNameSpace:'Select a NameSpace' 
        initialAnswer:nil
    "
!

requestProject:title from:listOfProjectsIn initialAnswer:initialTextOrNil suggestions:suggestionsOrNil
    "Ask for a project (package-id)"

    |suggestions listOfProjects newProject box more|

    suggestions := suggestionsOrNil ? #().
    
    listOfProjects := listOfProjectsIn.
    
    more := suggestions reject:[:each | (listOfProjects includes:each)].
    more notEmpty ifTrue:[
        listOfProjects := (listOfProjects , more) sort
    ].
    
    box := ListSelectionBox new.
    box useComboBoxWithList:suggestions.
    box title:title.
    box list:listOfProjects.
    box okAction:[:sel | newProject := sel].
    box initialText:initialTextOrNil.
    box entryCompletionBlock:(DoWhatIMeanSupport packageNameEntryCompletionBlock).
    box label:'Enter Project/PackageID'.
    box showAtPointer.

    newProject notNil ifTrue:[
        newProject := newProject withoutSeparators asSymbol.
    ].
    ^ newProject

    "
     Dialog 
        requestProject:'enter a project'
        initialAnswer:'stx:libbasic' 
        suggestions:#('foo' 'bar' 'baz')
    "

    "Created: / 07-09-2006 / 11:40:17 / cg"
!

requestProject:title initialAnswer:initialTextOrNil suggestions:suggestions
    "Ask for a project (package-id)"

    |allProjects|

    allProjects := Smalltalk allPackageIDs.
    ^ self
        requestProject:title 
        from:allProjects
        initialAnswer:initialTextOrNil 
        suggestions:suggestions
!

requestSelector:aString initialAnswer:initial
    "launch a Dialog, which allows user to enter a method selector.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     The entryField does selectorCompletion on TAB."

     ^ self requestSelector:aString okLabel:nil initialAnswer:initial

    "
     Dialog 
         requestSelector:'enter a selector:' 
         initialAnswer:'at:p'        
    "
!

requestSelector:aString okLabel:okLabel initialAnswer:initial
    "launch a Dialog, which allows user to enter a method selector.
     Return the entered string (may be empty string) or nil (if cancel was pressed).
     The entryField does selectorCompletion on TAB."

     ^ self
        request:aString 
        displayAt:nil 
        centered:nil 
        action:nil 
        initialAnswer:initial 
        okLabel:okLabel 
        cancelLabel:nil 
        title:nil 
        onCancel:nil
        list:nil
        initialSelection:nil
        entryCompletionBlock:
            [:s :field| 
                |completion|

                completion := Smalltalk selectorCompletion:s.
                completion second size > 1 ifTrue:[ 
                    UserPreferences current beepInEditor ifTrue:[                
                        Screen current beep
                    ].
                ].
                field contents:(completion first)
            ]

    "
     Dialog 
         requestSelector:'enter a selector:' 
         initialAnswer:'at:p'        
    "
!

requestSharedPool:title title:boxTitle initialAnswer:initialTextOrNil
    "Ask for a sharedPools name"

    |allPools|

    allPools := SharedPool allSubclasses collect:[:each | each name].
    allPools := allPools asOrderedCollection sort.

    ^ self
        requestName:title 
        fromList:allPools 
        title:boxTitle 
        initialAnswer:initialTextOrNil

    "
     Dialog 
        requestSharedPool:'Select a SharedPool' 
        title:nil
        initialAnswer:nil
    "
! !


!DialogBox methodsFor:'accessing-behavior'!

abortAction:aBlock
    "define the action to be performed when abort is pressed"

    abortAction := aBlock
!

acceptCheck:aBlock
    "if nonNil, the acceptCheck-block is evaluated when the dialog is
     accepted (ok-button or Return-key). If it returns true, the box is closed,
     otherwise not. Of course, you may also use a valueHolder instead of a block
     to provide the check value."

    acceptCheck := aBlock

    "Modified: / 25.1.2000 / 20:56:04 / cg"
!

acceptOnLeave:aBoolean
    "define the behavior when the last input field is left via cursor keys.
     The default is to accept & close the dialog (i.e. true)."

    acceptOnLeave := aBoolean.

    "Modified: 19.4.1996 / 17:05:12 / cg"
!

acceptReturnAsOK:aBoolean
    "turn on/off interpretation of return-key as ok.
     Default is on"

    acceptReturnAsOK := aBoolean.
    okButton notNil ifTrue:[
	okButton isReturnButton:aBoolean.
    ]
!

action:aBlock
    "set the action to be performed when user presses ok-button;
     aBlock must be nil or a block. This method simply
     reuses okAction: and has been added for a consistent action-setting
     protocol."

    self okAction:aBlock
!

focusOnField:anInputField
    "arrange for the argument to get the focus (initially)"

    inputFieldGroup makeActive:anInputField

    "Modified: / 13.8.1998 / 21:23:17 / cg"
!

focusToOKOnLeave:aBoolean
    "define the behavior when the last input field is left via a return
     or cursor key.
     The default is to shift the focus to the OK button (i.e. true).
     If turned off, the OK is immediately performed, i.e.
     the dialog is accepted & closed."

    focusToOKOnLeave := aBoolean.

    "Modified: 19.4.1996 / 17:05:12 / cg"
    "Created: 19.4.1996 / 17:13:36 / cg"
!

hideOnAccept:aBoolean
    "control if the dialog should close when accepted.
     The default is true"

    hideOnAccept := aBoolean
!

makeTabable:aComponentOrSubcomponent
    "add a component (usually a subcomponent, of which the dialog
     does not know) to the list of tabable ones (i.e. those, that can be
     stepped through via FocusNext/FocusPrevious).
     Toplevel tabable components are usually added with #addComponent:tabable:"

    aComponentOrSubcomponent canTab:true.

"/    tabableElements isNil ifTrue:[
"/        tabableElements := OrderedCollection new
"/    ].
"/    (tabableElements includesIdentical:aComponentOrSubcomponent) ifFalse:[
"/        tabableElements add:aComponentOrSubcomponent.
"/    ].

    (aComponentOrSubcomponent isInputField) ifTrue:[
        self addToInputFieldGroup:aComponentOrSubcomponent
    ].

    "Modified: 31.5.1996 / 21:22:13 / cg"
!

makeTabable:aComponentOrSubcomponent after:anotherComponent
    "add a component (usually a subcomponent, of which the dialog
     does not know) to the list of tabable ones (i.e. those, that can be
     stepped through via FocusNext/FocusPrevious).
     Toplevel tabable components are usually added with #addComponent:tabable:"

    <resource: #obsolete>
    self obsoleteMethodWarning. "/ focusSequence has been eliminated

    aComponentOrSubcomponent canTab:true.

"/    tabableElements isNil ifTrue:[
"/        tabableElements := OrderedCollection new
"/    ].
"/    tabableElements removeIdentical:aComponentOrSubcomponent ifAbsent:nil.
"/
"/    anotherComponent isNil ifTrue:[
"/        tabableElements addLast:aComponentOrSubcomponent
"/    ] ifFalse:[
"/        tabableElements add:aComponentOrSubcomponent after:anotherComponent.
"/    ].
"/
    (aComponentOrSubcomponent isInputField) ifTrue:[
        self addToInputFieldGroup:aComponentOrSubcomponent after:anotherComponent
    ].

    "Modified: 18.10.1997 / 03:08:20 / cg"
!

makeUntabable:aComponentOrSubcomponent
    aComponentOrSubcomponent canTab:false.

"/    (tabableElements includesIdentical:aComponentOrSubcomponent) ifFalse:[
"/        tabableElements removeIdentical:aComponentOrSubcomponent.
"/    ].

    (aComponentOrSubcomponent isInputField) ifTrue:[
        self removeFromInputFieldGroup:aComponentOrSubcomponent
    ].

    "Modified: 18.10.1997 / 02:50:05 / cg"
!

noAction:aBlock
    "define the action to be performed when 'no' is pressed"

    abortAction := aBlock

    "Modified: 16.1.1997 / 11:29:18 / cg"
!

okAction:aBlock
    "define the action to be performed when ok is pressed"

    okAction := aBlock
!

title:aString yesAction:yesBlock noAction:noBlock
    "define title and actions"

    self title:aString.
    okAction := yesBlock.
    abortAction := noBlock
!

yesAction:aBlock 
    "define the action to be performed when 'yes' is pressed"

    okAction := aBlock

    "Modified: 16.1.1997 / 11:31:21 / cg"
!

yesAction:yesBlock noAction:noBlock
    "define both actions"

    okAction := yesBlock.
    abortAction := noBlock
! !

!DialogBox methodsFor:'accessing-components'!

abortButton
    "return the abortButton - this access is provided to allow
     setting the buttons look (for example: colors or font)"

    ^ abortButton
!

buttonPanel
    "return the buttonPanel - this access is provided to allow
     setting the buttons look (for example: colors or font)"

    ^ buttonPanel
!

cancelButton
    "same as #abortButton;
     return the abortButton - this access is provided to allow
     setting the buttons look (for example: colors or font)"

    ^ self abortButton
!

noButton
    "return the no-button"

    ^ abortButton
!

okButton
    "return the okButton - this access is provided to allow
     setting the buttons look (for example: colors or font)"

    ^ okButton
!

verticalPanel
    "if there is none yet, create and add a vertical panel.
     This can be used to add additional components in an aboutToOpen hook callback."

    |savedY|

    verticalPanel isNil ifTrue:[
        savedY := yPosition.
        self addComponent:(verticalPanel := VerticalPanelView new).
        verticalPanel horizontalLayout:#fit.
        verticalPanel verticalLayout:#top.
        "/ verticalPanel height:25.
        yPosition := savedY.
    ].
    ^ verticalPanel

    "Modified (comment): / 28-02-2012 / 15:46:23 / cg"
!

yesButton
    "return the 'yes'-button"

    ^ okButton

    "Modified: 16.1.1997 / 11:31:27 / cg"
! !

!DialogBox methodsFor:'accessing-elements'!

componentAt:name
    "retrieve a component by name - to access it, it must have been
     named previously with #name:as:"

    namedComponents isNil ifTrue:[^ nil].
    ^ namedComponents at:name ifAbsent:nil

    "Modified: 16.1.1997 / 11:40:50 / cg"
!

name:element as:name
    "assign a name to a component. This can be done during construction,
     to allow later access to the components (i.e. without a need to
     remember them in some instVars)"

    namedComponents isNil ifTrue:[
	namedComponents := Dictionary new.
    ].
    namedComponents at:name put:element

    "Modified: 16.1.1997 / 11:41:03 / cg"
! !

!DialogBox methodsFor:'accessing-look'!

abortText:aString
    "define the label in the abort-button"

    |oldSize|

    aString ~= abortButton label ifTrue:[
	oldSize := abortButton extent.
	abortButton label:aString.
	abortButton resize.
	abortButton extent ~= oldSize ifTrue:[
	    shown ifTrue:[self resize]
	]
    ]
!

hideButtons
    "hides the buttonPanel (i.e. the ok and cancel buttons if any)"

    buttonPanel notNil ifTrue:[buttonPanel beInvisible]
!

noLabel:aString
    "define the label of the 'no'-button.
     And alias for #noText: - for backward compatibility"

    self noText:aString.

    "Created: 13.12.1995 / 16:21:57 / cg"
    "Modified: 16.1.1997 / 11:30:25 / cg"
!

noText:aString
    "define the label of the no-button.
     If not set, it defaults to the resource-string for 'no'."

    aString ~= abortButton label ifTrue:[
        abortButton label:aString.
        abortButton resize.
        shown ifTrue:[self resize]
    ]
!

okText:aString
    "define the text in the ok-button"

    |oldSize|

    aString ~= okButton label ifTrue:[
	oldSize := okButton extent.
	okButton label:aString.
	okButton resize.
	okButton extent ~= oldSize ifTrue:[
	    shown ifTrue:[self resize]
	]
    ]
!

okText:okString abortText:abortString
    "set both texts displayed in the buttons"

    (abortString ~= abortButton label 
    or:[okString ~= okButton label]) ifTrue:[
	okButton label:okString.
	abortButton label:abortString.
	okButton resize.
	abortButton resize.
	shown ifTrue:[self resize]
    ]
!

okText:yesString noText:noString
    "define the labels of both buttons.
     Alias for yesText:noText: for backward compatibility."

    ^ self yesText:yesString noText:noString

    "Modified: 16.1.1997 / 11:30:58 / cg"
!

title:aString
    "define title"

    self label:aString.

    "
     DialogBox new open
     (DialogBox new title:'Foo') open
    "
!

title:aString yesText:yesString noText:noString
    "define title and button labels"

    self title:aString.
    self yesText:yesString noText:noString
!

yesLabel:aString
    "define the label of the 'yes'-button.
     An alias for #yesText: for backward compatibility."

    self yesText:aString.

    "Created: 13.12.1995 / 16:22:05 / cg"
    "Modified: 16.1.1997 / 11:31:58 / cg"
!

yesText:aString
    "define the label of the 'yes'-button"

    self okText:aString

    "Modified: 16.1.1997 / 11:31:39 / cg"
!

yesText:yesString noText:noString
    "define the labels of both buttons"

    ((yesString ~= okButton label) or:[noString ~= abortButton label]) ifTrue:[
        okButton label:yesString. 
        abortButton label:noString.
        okButton resize.
        abortButton resize.
        shown ifTrue:[self resize]
    ]

    "Modified: 21.2.1996 / 00:58:38 / cg"
! !

!DialogBox methodsFor:'accessing-models'!

accept
    "return the valueHolder holding true when the box
     is accepted, false if closed via the windowManager or
     the cancel button.
     This is confusing: this method was originally called #acceptValue,
     but renamed for compatibility with ST-80.
     This looks like a bad name to me, since in most other situations, #accept
     is used to force an accept, not to return some valueHolder ...)."

    ^ acceptValue
!

acceptChannel
    "same as #accept: return the valueHolder which is set to true when the box
     is accepted"

    ^ acceptValue

    "Created: / 18.8.2000 / 21:44:24 / cg"
!

acceptChannel:aValueHolder
    "set the valueHolder which is set to true when the box
     is accepted"

    acceptValue := aValueHolder
!

aspectAt:anAspectSymbol put:aDataModel
    "return the dataModel for some aspect, nil if no such dataModel was defined;
     requires that a corresponding dataModel has been set (usually during
     initialization) via the #aspectAt:put: message.
     Allows users of boxes to access individual values - especially useful,
     in multi-field dialogs."

    bindings isNil ifTrue:[bindings := IdentityDictionary new].
    bindings at:anAspectSymbol put:aDataModel

    "Created: 16.1.1997 / 11:38:46 / cg"
    "Modified: 16.1.1997 / 11:41:28 / cg"
!

aspectFor:anAspectSymbol
    "return the dataModel for some aspect, nil if no such dataModel was defined;
     requires that a corresponding dataModel has been set (usually during
     initialization) via the #aspectAt:put: message.
     Allows users of boxes to access individual values - especially useful,
     in multi-field dialogs."

    "/ subclasses may redefine some aspects...
    (self respondsTo:anAspectSymbol) ifTrue:[
        ^ self perform:anAspectSymbol
    ].

    bindings isNil ifTrue:[^ nil].
    ^ bindings at:anAspectSymbol ifAbsent:nil

    "Modified: / 11-10-2006 / 21:48:14 / cg"
!

cancel
    ^ BlockValue forLogicalNot:(acceptValue)
! !

!DialogBox methodsFor:'construction-adding'!

addComponent:aComponent
    "add any component with its preferred height and full width.
     Returns the component."

    ^ self addComponent:aComponent indent:nil tabable:false

    "Modified: 9.2.1996 / 22:22:41 / cg"
!

addComponent:aComponent indent:indent
    "add any component with its preferred height and full width.
     The indent is temporarily changed to indent.
     Returns the component."

    ^ self addComponent:aComponent indent:indent tabable:false

    "Modified: 9.2.1996 / 22:22:44 / cg"
!

addComponent:aComponent indent:indent tabable:tabable
    "add any component with its preferred height and full width.
     The indent is temporarily changed to indent.
     Returns the component."

    |oldLeft oldRight result|

    oldLeft := leftIndent.
    oldRight := rightIndent.
    indent notNil ifTrue:[
	leftIndent := rightIndent := indent.
    ].
    result := self addComponent:aComponent tabable:tabable tabbedComponent:aComponent.
    leftIndent := oldLeft.
    rightIndent := oldRight.
    ^ result

    "Modified: 9.2.1996 / 22:22:50 / cg"
!

addComponent:aComponent indent:indent withExtent:ext 
    "add any component with some given extent.
     Returns the component."

    |fullSize lI rI|

    indent isNil ifTrue:[
        lI := leftIndent.
        rI := rightIndent.
    ] ifFalse:[
        lI := rI := indent
    ].

    self basicAddComponent:aComponent.
    (ext x isInteger) ifTrue:[ 
        fullSize := ext + (lI + rI @ 0).
        width := fullSize x max:width.
    ] ifFalse:[
        fullSize := ext.
    ].
    aComponent extent:fullSize.
    aComponent origin:(0.0 @ yPosition); 
               leftInset:lI; 
               rightInset:rI.

    yPosition := aComponent corner y + ViewSpacing.
    "/ yPosition := yPosition + aComponent height + ViewSpacing.
    needResize := true.
    ^ aComponent

    "Modified: / 29-07-2011 / 12:28:47 / cg"
!

addComponent:aComponent indent:indent withHeight:height 
    "add any component with some given height and full width.
     Returns the component."

    |lI rI|

    indent isNil ifTrue:[
        lI := leftIndent.
        rI := rightIndent.
    ] ifFalse:[
        lI := rI := indent
    ].
    self basicAddComponent:aComponent.
    aComponent 
        height:height;
        origin:0.0@yPosition; 
        width:1.0; 
        leftInset:lI;
        rightInset:rI.
    yPosition := yPosition + height + ViewSpacing.
    ^ aComponent

    "Modified: 9.2.1996 / 22:22:58 / cg"
!

addComponent:aComponent tabable:tabable
    "add any component with its preferred height and full width.
     Returns the component."

    ^ self addComponent:aComponent tabable:tabable tabbedComponent:aComponent

    "Modified: 9.2.1996 / 22:23:04 / cg"
!

addComponent:aComponent tabable:tabable tabbedComponent:subComponent
    "add any component with its preferred height and full width.
     Returns the component."

    tabable ifTrue:[
        aComponent canTab:true.

"/        tabableElements isNil ifTrue:[
"/            tabableElements := OrderedCollection new
"/        ].
"/        tabableElements add:subComponent
    ].
    ^ self addComponent:aComponent withHeight:(aComponent preferredHeight).

    "Modified: 9.2.1996 / 22:23:07 / cg"
!

addComponent:aComponent withExtent:ext 
    "add any component with some given extent.
     Returns the component."

    ^ self addComponent:aComponent indent:nil withExtent:ext

    "Modified: 9.2.1996 / 22:23:11 / cg"
!

addComponent:aComponent withHeight:height 
    "add any component with some given height and full width.
     Returns the component."

    ^ self addComponent:aComponent indent:nil withHeight:height

    "Modified: 9.2.1996 / 22:23:15 / cg"
!

addLabelledField:aView label:labelString adjust:labelAdjust tabable:tabable from:leftX to:rightX separateAtX:relativeX
    "add a label and some view side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."

    ^ self
        addLabelledField:aView 
        label:labelString 
        adjust:labelAdjust 
        tabable:tabable 
        from:leftX to:rightX separateAtX:relativeX 
        nameAs:nil

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(EditField on:model) label:'input here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := SelectionInList new.
     model list:#('foo' 'bar' 'baz').
     model selectionIndex:2.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(PopUpList on:model) label:'select here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Created: 3.6.1996 / 11:03:24 / cg"
    "Modified: 17.7.1996 / 15:04:07 / cg"
!

addLabelledField:aView label:labelString adjust:labelAdjust 
    tabable:tabable from:leftX to:rightX separateAtX:relativeX nameAs:aName

    "add a label and some view side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."

    ^ self
        addLabelledField:aView 
        label:labelString 
        adjust:labelAdjust 
        tabable:tabable 
        from:leftX to:rightX 
        separateAtX:relativeX 
        nameAs:aName
        foregroundColor:nil

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(EditField on:model) 
                label:'input here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:((ComboListView on:model) list:#('foo' 'bar' 'baz'))
                label:'select foo:'
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := SelectionInList new.
     model list:#('foo' 'bar' 'baz').
     model selectionIndex:2.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(PopUpList on:model) 
                label:'select here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Created: 17.7.1996 / 15:03:32 / cg"
    "Modified: 26.7.1996 / 18:11:12 / cg"
!

addLabelledField:aView label:labelString adjust:labelAdjust 
    tabable:tabable from:leftX to:rightX separateAtX:relativeX nameAs:aName
    foregroundColor:fgColor

    "add a label and some view side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."

    |y lbl max relW wLabel|

    y := self yPosition.
    lbl := Label label:labelString.

    max := lbl preferredHeight max:(aView preferredHeight max:aView height).

    relW := rightX - leftX.

    self addComponent:lbl indent:leftIndent withHeight:max.
    lbl rightInset:0.
    relativeX isInteger ifTrue:[
        wLabel := relativeX.
    ] ifFalse:[
        wLabel := relW*relativeX.
    ].

    lbl 
        width:wLabel; 
        left:leftX; 
        adjust:labelAdjust; 
        borderWidth:0.

    relativeX isInteger ifTrue:[
        lbl preferredExtent:(wLabel @ lbl preferredExtent y).
        lbl extent:(wLabel @ lbl preferredExtent y).
        lbl sizeFixed:true.
    ].

    fgColor notNil ifTrue:[
        lbl foregroundColor:fgColor
    ].

    self yPosition:y.

    "/ aView preferredExtent:(aView preferredExtent x @ max).
    "/ aView height:max.

    self addComponent:aView tabable:tabable.

    relativeX isInteger ifTrue:[
        aView 
            leftInset:(ViewSpacing + relativeX); 
            left:0.0;
            rightInset:ViewSpacing; 
            right:1.0.
    ] ifFalse:[
        aView 
            leftInset:ViewSpacing; 
            rightInset:ViewSpacing;
            width:relW*(1.0 - relativeX); 
            left:leftX+(relW*relativeX).
    ].

    "/ self todo. "/ someone changes this later, back to a too small height !!!!!!
    aView setHeight:max.

    aView isInputField ifTrue:[
        self addToInputFieldGroup:aView
    ].

    aName notNil ifTrue:[
        self name:lbl as:(aName , '.label').
        self name:aView as:aName
    ].

    ^ aView                         

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(EditField on:model) 
                label:'input here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:((ComboListView on:model) list:#('foo' 'bar' 'baz'))
                label:'select foo:'
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := SelectionInList new.
     model list:#('foo' 'bar' 'baz').
     model selectionIndex:2.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(PopUpList on:model) 
                label:'select here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Created: / 17-07-1996 / 15:03:32 / cg"
    "Modified: / 02-02-2011 / 12:17:55 / cg"
!

addLabelledField:aView label:labelString adjust:labelAdjust tabable:tabable separateAtX:relativeX
    "add a label and some view side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."

    ^ self
        addLabelledField:aView 
        label:labelString 
        adjust:labelAdjust 
        tabable:tabable 
        from:0.0 to:1.0 
        separateAtX:relativeX

"/    |y lbl max|
"/
"/    y := self yPosition.
"/    lbl := Label label:labelString.
"/    max := lbl preferredExtent y max:(aView preferredExtent y).
"/
"/    self addComponent:lbl indent:leftIndent withHeight:max.
"/    lbl rightInset:0.
"/    lbl width:relativeX; adjust:labelAdjust; borderWidth:0.
"/
"/    self yPosition:y.
"/    self addComponent:aView tabable:tabable.
"/    aView leftInset:ViewSpacing; rightInset:ViewSpacing.
"/    aView width:(1.0 - relativeX); left:relativeX.
"/
"/    aView isInputField ifTrue:[
"/        self addToInputFieldGroup:aView
"/    ].
"/
"/    ^ aView

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(EditField on:model) label:'input here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model field|

     model := SelectionInList new.
     model list:#('foo' 'bar' 'baz').
     model selectionIndex:2.

     dialog := DialogBox new.

     field := dialog 
                addLabelledField:(PopUpList on:model) label:'select here:' 
                adjust:#left 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Created: 13.4.1996 / 13:41:31 / cg"
    "Modified: 3.6.1996 / 18:48:49 / cg"
!

addMessage:labelString centered:centered
    |l|

    l := self addTextLabel:labelString.
    l adjust:(centered ifTrue:[#center] ifFalse:[#left]).
    ^ l

    "Created: / 4.2.2000 / 00:03:24 / cg"
!

addMessage:labelString textLine:valueHolder boundary:fraction
    ^ self
        addMessage:labelString 
        textLine:valueHolder 
        type:nil 
        boundary:fraction
!

addMessage:labelString textLine:valueHolder type:typeSymbolOrNil boundary:fraction
    |pos lbl field|

    pos := self yPosition.
    lbl := self addTextLabel:labelString.
    lbl width:fraction.
    self yPosition:pos.
    field := self addInputFieldOn:valueHolder tabable:true.
    field left:fraction; width:(1.0-fraction).
    typeSymbolOrNil == #password ifTrue:[
        field bePassword
    ].
    ^ field
!

addTextLabel:aString
    "create a text label - the name has been choosen for ST-80 compatibility;
     however, ST/X labels allow image labels too.
     Returns the label."

    |l|

    l := Label new label:aString.
    l borderWidth:0.
    self addComponent:l.
    ^ l

    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello'.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b leftIndent:100.
     b addTextLabel:'hello'.
     b leftIndent:0.
     b addTextLabel:'world'.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello'.
     b addTextLabel:'world'.
     b addOkButton.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello'.
     (b addTextLabel:'world') foregroundColor:Color red.
     b addOkButton.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello world\\How about this ?' withCRs.
     b addOkButton.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello world\\How about this ?' withCRs.
     b addTextLabel:'not bad'.
     b addAbortButton.
     b addOkButton.
     b showAtPointer
    "
!

addTextLabel:aString adjust:how
    "create a text label - the name has been choosen for ST-80 compatibility;
     however, ST/X labels allow image labels too.
     Returns the label. 
     The adjust argument must be one of #left, #right or #center (see Label for details)"

    |l|

    l := self addTextLabel:aString.
    l adjust:how.
    ^ l

    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello' adjust:#left.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b addTextLabel:'hello' adjust:#right.
     b showAtPointer
    "
!

addTextLabelOn:aValueHolder
    "create a text label showing the contents of a valueHolder.
     Returns the label."

    |l|

    l := Label new labelChannel:aValueHolder.
    l borderWidth:0.
    self addComponent:l.
    ^ l

    "
     |holder b|

     holder := ValueHolder with:'hello'.

     b := DialogBox new.
     b addTextLabelOn:holder asValue.
     [ Delay waitForSeconds:2. holder value:'world' ] fork.
     b showAtPointer
    "
    "
     |b|

     b := DialogBox new.
     b leftIndent:100.
     b addTextLabelOn:'hello' asValue.
     b leftIndent:0.
     b addTextLabelOn:'world' asValue.
     b showAtPointer
    "
!

addTextLabelOn:aStringHolder adjust:how
    "create a text label - the name has been choosen for ST-80 compatibility;
     however, ST/X labels allow image labels too.
     Returns the label. 
     The adjust argument must be one of #left, #right or #center (see Label for details)"

    |l|

    l := self addTextLabelOn:aStringHolder.
    l adjust:how.
    ^ l

    "
     |holder b|

     holder := ValueHolder with:'hello'.

     b := DialogBox new.
     b addTextLabelOn:holder asValue adjust:#left.
     [ Delay waitForSeconds:2. holder value:'world' ] fork.
     b showAtPointer
    "
!

addToInputFieldGroup:aComponentOrSubcomponent
    "add a component to the input group.
     The argument, aComponentOrSubcomponent may even be a nested subcomponent of
     a topLevel component."

    self
	addToInputFieldGroup:aComponentOrSubcomponent before:nil

    "Modified: 18.10.1997 / 03:09:17 / cg"
!

addToInputFieldGroup:aComponentOrSubcomponent before:anotherComponent
    "add a component to the input group.
     The argument, aComponentOrSubcomponent may even be a nested subcomponent of
     a topLevel component."

    inputFieldGroup isNil ifTrue:[
        inputFieldGroup := EnterFieldGroup new.
        inputFieldGroup leaveAction:[self lastFieldLeft].
        "/
        "/ the first inputField gets the focus initially
        "/
        aComponentOrSubcomponent hasKeyboardFocus:true.
    ].
    inputFieldGroup add:aComponentOrSubcomponent before:anotherComponent.
    self delegate:(KeyboardForwarder to:inputFieldGroup condition:#noFocus).

"/    inputFields isNil ifTrue:[
"/        inputFields := OrderedCollection new.
"/
"/        "/ the very first field gets the focus initially
"/
"/        aComponentOrSubcomponent showCursor.
"/        aComponentOrSubcomponent hasKeyboardFocus:true.
"/    ] ifFalse:[
"/        aComponentOrSubcomponent hideCursor.
"/        aComponentOrSubcomponent hasKeyboardFocus:false.
"/    ].
"/    inputFields add:aComponentOrSubcomponent

    "Modified: 18.10.1997 / 02:47:20 / cg"
    "Created: 18.10.1997 / 03:08:51 / cg"
!

removeFromInputFieldGroup:aComponentOrSubcomponent
    "remove a component from the input group.
     The argument, aComponentOrSubcomponent may even be a nested subcomponent of
     a topLevel component."

    inputFieldGroup isNil ifTrue:[^ self].
    inputFieldGroup remove:aComponentOrSubcomponent.

    "Created: 18.10.1997 / 02:51:30 / cg"
! !

!DialogBox methodsFor:'construction-buttons'!

addAbortAndOkButtons
    "create both abort- and Ok Buttons"

    self 
        addAbortButtonLabelled:nil; 
        addOkButtonLabelled:nil
!

addAbortButton
    "create an abortButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

    ^ self addAbortButtonLabelled:nil
!

addAbortButton:aButton 
    "add an already created abortButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

    abortButton := aButton.
    aButton model:self; change:#abortPressed.

    "/ changed:
    "/ now exclusively done by the buttonPanel itself

"/    (Dialog defaultOKButtonAtLeft) ifTrue:[
"/        self addButton:aButton after:nil.
"/    ] ifFalse:[
"/        self addButton:aButton before:nil.
"/    ].

    self addButton:aButton before:nil.
    ^ aButton.

    "Created: 17.9.1995 / 20:17:26 / claus"
!

addAbortButtonLabelled:buttonLabel
    "create an abortButton with a label - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     A nil argument creates one with the default label.
     Returns the button."

    |aButton|

    aButton := Button abortButton.
    buttonLabel notNil ifTrue:[aButton label:buttonLabel].
    ^ self addAbortButton:aButton

    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButtonLabelled:'get out of here'.
     dialog addOkButtonLabelled:'yes thats ok'.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 22:09:40 / cg"
!

addButton:aButton
    "add a button into the buttonPanel.
     Returns the button."

    "/ ^ self addButton:aButton after:nil
    (self class defaultOKButtonAtLeft) ifFalse:[
        ^ self addButton:aButton before:nil
    ] ifTrue:[
        ^ self addButton:aButton after:nil
    ].

    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addButton:(Button label:'foo' action:[Transcript showCR:'foo']).
     dialog addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addButton:(Button label:'foo' action:[dialog hide. Transcript showCR:'foo']).
     dialog addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "
     |dialog|

     dialog := DialogBox new.
     dialog addButton:(Button label:'foo' action:[dialog hide. Transcript showCR:'foo']).
     dialog addAbortButton.
     dialog addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 22:14:17 / cg"
!

addButton:aButton after:someOtherButtonOrNil
    "add a button into the buttonPanel.
     If the argument someOtherButtonOrNil is nil, the button is
     added at the end."

    |h|

    buttonPanel addSubView:aButton after:someOtherButtonOrNil.
    buttonPanel subViews size > 1 ifTrue:[
        buttonPanel horizontalLayout:#fitSpace.
    ].
    (h := (aButton heightIncludingBorder + (ViewSpacing * 2))) > buttonPanel topInset ifTrue:[
         buttonPanel topInset:h negated
    ].
    preferredExtent := nil.
    needResize := true.
    ^ aButton

    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addOkButton.
     dialog addButton:(Button 
                        label:'foo' 
                        action:[dialog hide. Transcript showCR:'foo'])
                after:(dialog okButton).
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "
    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addOkButton.
     dialog addButton:(Button 
                        label:'foo' 
                        action:[dialog hide. Transcript showCR:'foo'])
                after:(dialog abortButton).
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "
    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addOkButton.
     dialog addButton:(Button 
                        label:'foo' 
                        action:[dialog hide. Transcript showCR:'foo'])
                after:nil.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 22:13:51 / cg"
!

addButton:aButton before:someOtherButtonOrNil
    "add a button into the buttonPanel.
     If the argument someOtherButtonOrNil is nil, the button is
     added upFront."

    |h|

    buttonPanel addSubView:aButton before:someOtherButtonOrNil.
    buttonPanel subViews size > 1 ifTrue:[
        buttonPanel horizontalLayout:#fitSpace.
    ].
    (h := (aButton heightIncludingBorder + (ViewSpacing * 2))) > buttonPanel topInset ifTrue:[
         buttonPanel topInset:h negated
    ].
    preferredExtent := nil.
    needResize := true.
    shown ifTrue:[ aButton realize ].
    ^ aButton

    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addOkButton.
     dialog addButton:(Button 
                        label:'foo' 
                        action:[dialog hide. Transcript showCR:'foo'])
                before:(dialog okButton).
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "
    "
     |dialog|

     dialog := DialogBox new.
     dialog addAbortButton.
     dialog addOkButton.
     dialog addButton:(Button 
                        label:'foo' 
                        action:[dialog hide. Transcript showCR:'foo'])
                before:nil.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 22:13:51 / cg"
    "Created: 10.2.1996 / 16:04:35 / cg"
!

addHelpButtonFor:pathToHelpText 
    "add a help button to the buttonPanel.
     The argument, pathToHelpText should specify the path to the help
     text under either the doc/online/<language> or the help/<language>
     directory."

    ^ self addHelpButtonWithAction:[HTMLDocumentView openFullOnHelpFile:pathToHelpText].

    "
     |box|

     box := DialogBox new.
     box 
        addHelpButtonFor:'Launcher/compilerSettings.html';
        addAbortButton; 
        addOkButton.

     box open
    "

    "Modified: / 09-09-1996 / 22:40:21 / stefan"
    "Modified: / 26-01-2011 / 18:04:53 / cg"
!

addHelpButtonWithAction:helpAction
    "add a help button to the buttonPanel.
     The argument, helpAction is avaluated when clicked"

    |helpButton|

    helpButton := Button label:(resources string:'Help').
    helpButton action:[
        self withWaitCursorDo:helpAction
    ].

    "/ changed:
    "/ now exclusively done by the buttonPanel itself

"/    (Dialog defaultOKButtonAtLeft) ifTrue:[
"/        self addButton:helpButton after:nil.
"/    ] ifFalse:[
"/        self addButton:helpButton before:nil.
"/    ].

    self addButton:helpButton before:nil.
    ^ helpButton

    "
     |box|

     box := DialogBox new.
     box 
        addHelpButtonWithAction:[ Transcript flash ];
        addAbortButton; 
        addOkButton.

     box open
    "

    "Modified: / 09-09-1996 / 22:40:21 / stefan"
    "Created: / 26-01-2011 / 18:04:16 / cg"
!

addOK:checkBlock
    |butt|

    butt := self addOkButton.
    "/ what is checkBlock ?
    ^ butt

    "Modified: / 4.2.2000 / 00:09:15 / cg"
!

addOkButton
    "create an okButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

    ^ self addOkButtonLabelled:nil

    "
     |dialog|

     dialog := DialogBox new.
     dialog addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 21:37:02 / cg"
!

addOkButton:aButton 
    "add an already created okButton - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     Returns the button."

"/    okButton isNil ifTrue:[
        okButton := aButton.
"/    ].
    aButton model:self; change:#okPressed.

    "/ changed:
    "/ now exclusively done by the buttonPanel itself

"/    (Dialog defaultOKButtonAtLeft) ifTrue:[
"/        self addButton:aButton before:nil.
"/    ] ifFalse:[
"/        self addButton:aButton after:nil.
"/    ].

    self addButton:aButton after:nil.

    ^ aButton.

    "
     |dialog b|

     b := Button label:((Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages') magnifiedBy:0.5).

     dialog := DialogBox new.
     dialog addOkButton:b.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 17.9.1995 / 20:20:41 / claus"
    "Modified: 9.2.1996 / 21:38:48 / cg"
!

addOkButtonLabelled:buttonLabel 
    "create an okButton with a label - to be sent from redefined initialize
     methods in subclasses or when creating a box programmatically.
     A nil argument creates one with the default text.
     Returns the button."

    |aButton|

    aButton := Button okButton.
    buttonLabel notNil ifTrue:[aButton label:buttonLabel].
    aButton isReturnButton:acceptReturnAsOK.
    ^ self addOkButton:aButton.

    "
     |dialog|

     dialog := DialogBox new.
     dialog addOkButtonLabelled:'get out of here'.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:'yes'].
    "

    "Modified: 9.2.1996 / 21:39:34 / cg"
!

removeAbortButton 
    "remove an already added okButton - only useful to change some already created
     dialog afterwards"

    abortButton destroy
!

removeOkButton 
    "remove an already added okButton - only useful to change some already created
     dialog afterwards"

    okButton destroy
! !

!DialogBox methodsFor:'construction-check & comboboxes'!

addCheckBox:label on:aModel
    "create a checkBox with label on aModel and add it.
     Returns the box."

    ^ self addCheckBox:label on:aModel tabable:true

    "
     |dialog check|

     check := true asValue.

     dialog := DialogBox new.
     dialog addCheckBox:'on or off' on:check.
     dialog addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:check value].
    "

    "Modified: 9.2.1996 / 22:15:38 / cg"
!

addCheckBox:label on:aModel tabable:tabable
    "create a checkBox with label on aModel and add it.
     Returns the box."

    |b|

    b := CheckBox on:aModel.
    b label:label.
    self addComponent:b tabable:tabable.
    ^ b

    "
     |dialog check1 check2 check3|

     check1 := true asValue.
     check2 := false asValue.
     check3 := true asValue.

     dialog := DialogBox new.
     dialog addCheckBox:'on or off' on:check1 tabable:false.
     dialog addHorizontalLine.

     dialog addCheckBox:'on or off' on:check2 tabable:true.
     dialog addCheckBox:'on or off' on:check3 tabable:true.
     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 22:16:49 / cg"
!

addCheckBoxAtBottom:checkLabel on:aValueHolder
    "add a checkbox and make it stick at the bottom"

    |box|

    box := here addCheckBox:checkLabel on:aValueHolder.

    box layout:((0.0 @ 1.0 corner:1.0 @ 1.0) asLayout 
                topOffset:(buttonPanel preferredHeight 
                          + box preferredHeight
                          + ViewSpacing ) negated;
                bottomOffset:(buttonPanel preferredHeight 
                          + ViewSpacing ) negated).
    ^ box.

    "Created: / 28-02-2012 / 09:03:22 / cg"
!

addComboBoxOn:aModel
    "create a comboBoxView on aModel and add it.
     Returns the comboBoxView."

    ^ self addComboBoxOn:aModel tabable:true

    "
     without a list, the comboBox is disabled:

     |box val|

     val := 'some input' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val).
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "with a list, it can be pulled:

     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val) list:#('one' 'two' 'three' 'four').
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "Modified: 28.2.1996 / 15:17:39 / cg"
    "Created: 4.3.1996 / 17:21:45 / cg"
!

addComboBoxOn:aModel list:list tabable:tabable
    "create a comboBoxView on aModel and add it.
     Returns the comboBoxView."

    ^ (self addComboBoxOn:aModel tabable:tabable) list:list

    "
     without a list, the comboBox is disabled:

     |box val|

     val := 'some input' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val tabable:true).
     box addOkButton.
     box open.
     box accepted ifTrue:[
        Transcript showCR:val value
     ].
    "

    "with a list, it can be pulled:

     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val tabable:true) list:#('one' 'two' 'three' 'four').
     box addOkButton.
     box open.
     box accepted ifTrue:[
        Transcript showCR:val value
     ].
    "

    "Modified: 4.3.1996 / 17:21:57 / cg"
!

addComboBoxOn:aModel tabable:tabable
    "create a comboBoxView on aModel and add it.
     Returns the comboBoxView."

    |f|

    f := ComboBoxView new.
    f model:aModel.
    self addComponent:f tabable:tabable.
    tabable ifTrue:[
	self addToInputFieldGroup:f editor.
    ].
    ^ f

    "
     without a list, the comboBox is disabled:

     |box val|

     val := 'some input' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val tabable:true).
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "with a list, it can be pulled:

     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboBoxOn:val tabable:true) list:#('one' 'two' 'three' 'four').
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "Modified: 4.3.1996 / 17:21:57 / cg"
!

addComboListOn:aModel
    "create a comboListView on aModel and add it.
     Returns the comboListView."

    ^ self addComboListOn:aModel tabable:true 

    "without a list, the comboList is disabled:

     |box val|

     val := 'some input' asValue.

     box := Dialog new.

     (box addTextLabel:'combo list example') adjust:#left.
     box addVerticalSpace.
     (box addComboListOn:val).
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "with a list, it can be pulled:

     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboListOn:val) list:#('one' 'two' 'three' 'four').
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "Created: 28.2.1996 / 15:16:34 / cg"
    "Modified: 4.3.1996 / 17:22:59 / cg"
!

addComboListOn:aModel list:list tabable:tabable
    "create a comboListView on aModel and add it.
     Returns the comboListView."

    ^ (self addComboListOn:aModel tabable:tabable) list:list

    "
     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboListOn:val list:#('one' 'two' 'three' 'four') tabable:true).
     box addOkButton.
     box open.
     box accepted ifTrue:[
        Transcript showCR:val value
     ].
    "
!

addComboListOn:aModel tabable:tabable
    "create a comboListView on aModel and add it.
     Returns the comboListView."

    |f|

    f := ComboListView new.
    f model:aModel.
    self addComponent:f tabable:tabable.
    ^ f

    "without a list, the comboList is disabled:

     |box val|

     val := 'some input' asValue.

     box := Dialog new.

     (box addTextLabel:'combo list example') adjust:#left.
     box addVerticalSpace.
     (box addComboListOn:val tabable:true).
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "with a list, it can be pulled:

     |box val|

     val := '' asValue.

     box := Dialog new.

     (box addTextLabel:'combo box example') adjust:#left.
     box addVerticalSpace.
     (box addComboListOn:val tabable:true) list:#('one' 'two' 'three' 'four').
     box addOkButton.
     box open.
     box accepted ifTrue:[
	Transcript showCR:val value
     ].
    "

    "Created: 28.2.1996 / 15:16:34 / cg"
    "Modified: 4.3.1996 / 17:23:38 / cg"
!

addTriggerBox:label action:aBlock
    "create a triggerBox with label and action and add it.
     Returns the box."

    |b|

    b := TriggerBox new action:aBlock.
    b label:label.
    self addComponent:b tabable:false.
    ^ b

    "
     |dialog trigger1 trigger2 trigger3|

     trigger1 := true asValue.
     trigger2 := false asValue.
     trigger3 := true asValue.

     dialog := DialogBox new.
     dialog addTriggerBox:'go' action:[Transcript showCR:'1'].
     dialog addHorizontalLine.

     dialog addTriggerBox:'go go' action:[Transcript showCR:'2'].
     dialog addTriggerBox:'trigger' action:[Transcript showCR:'3'].
     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 22:16:49 / cg"
! !

!DialogBox methodsFor:'construction-inputfields'!

addFilenameInputFieldOn:aModel in:aDirectory tabable:tabable
    "create a fileName input field on aModel and add it.
     Returns the field. This is much like a normal input field,
     but supports filename completion."

    |f|

    f := FilenameEditField new.
    aDirectory notNil ifTrue:[f directory:aDirectory].
    f model:aModel.
    self addInputField:f tabable:tabable.
    ^ f
!

addInputField:aField
    "add an already created input field.
     Returns the field."

    ^ self addInputField:aField tabable:true

    "Modified: 9.2.1996 / 20:46:16 / cg"
!

addInputField:aField tabable:tabable
    "add an already created input field.
     If tabable is true, the field is put into a group, to allow
     stepping through the fields with #Cursor/#Return keys.
     Returns the field."

    self addComponent:aField tabable:tabable.
    tabable ifTrue:[
	self addToInputFieldGroup:aField.
    ].
    ^ aField

    "Modified: 31.5.1996 / 21:22:29 / cg"
!

addInputFieldOn:aModel
    "create an input field on aModel and add it.
     Returns the field."

    ^ self addInputFieldOn:aModel tabable:true

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.
     (dialog addTextLabel:'enter a string') adjust:#left.

     field := dialog addInputFieldOn:model.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Modified: 9.2.1996 / 21:34:14 / cg"
!

addInputFieldOn:aModel tabable:tabable
    "create an input field on aModel and add it.
     If tabable is false, the field cannot be tabbed into
     and return does not close the box.
     (pointer must be moved into it).
     Returns the field."

    |f|

    f := EditField model:aModel.
    self addInputField:f tabable:tabable.
    ^ f

    " a non-tabable field:

     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.
     (dialog addTextLabel:'enter a string') adjust:#left.

     field := dialog addInputFieldOn:model tabable:false.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "Modified: 9.2.1996 / 21:36:16 / cg"
    "Modified: 3.1.1997 / 10:24:04 / stefan"
!

addLabelledInputField:labelString adjust:labelAdjust on:model tabable:tabable from:leftX to:rightX separateAtX:relativeX
    "add a label and an inputField side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."


    ^ self 
        addLabelledField:(EditField on:model) label:labelString 
        adjust:labelAdjust
        tabable:tabable 
        from:leftX to:rightX
        separateAtX:relativeX.

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledInputField:'enter a string' 
                adjust:#left 
                on:model 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model1 model2 field|

     model1 := '' asValue.
     model2 := '' asValue.

     dialog := DialogBox new.

     dialog addTextLabel:'a two-input box'.
     dialog addHorizontalLine.

     field := dialog 
                addLabelledInputField:'string1:' 
                adjust:#right 
                on:model1 
                tabable:true 
                separateAtX:0.4.

     field := dialog 
                addLabelledInputField:'string2:' 
                adjust:#right 
                on:model2 
                tabable:true 
                separateAtX:0.4.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[
        Transcript showCR:model1 value.
        Transcript showCR:model2 value.
     ].
    "

    "Modified: 19.4.1996 / 17:39:46 / cg"
    "Created: 3.6.1996 / 11:04:23 / cg"
!

addLabelledInputField:labelString adjust:labelAdjust on:model tabable:tabable separateAtX:relativeX
    "add a label and an inputField side-by-side.
     The label goes from 0.0 to relativeX; the inputField from relativeX to 1.0.
     The label's string is defined by labelString and adjusted according to labelAdjust.
     The inputField gets model as its model.
     Return the inputField."


    ^ self 
        addLabelledField:(EditField on:model) label:labelString 
        adjust:labelAdjust
        tabable:tabable 
        separateAtX:relativeX.

    "
     |dialog model field|

     model := '' asValue.

     dialog := DialogBox new.

     field := dialog 
                addLabelledInputField:'enter a string' 
                adjust:#left 
                on:model 
                tabable:true 
                separateAtX:0.3.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[Transcript showCR:model value].
    "

    "
     |dialog model1 model2 field|

     model1 := '' asValue.
     model2 := '' asValue.

     dialog := DialogBox new.

     dialog addTextLabel:'a two-input box'.
     dialog addHorizontalLine.

     field := dialog 
                addLabelledInputField:'string1:' 
                adjust:#right 
                on:model1 
                tabable:true 
                separateAtX:0.4.

     field := dialog 
                addLabelledInputField:'string2:' 
                adjust:#right 
                on:model2 
                tabable:true 
                separateAtX:0.4.

     dialog addAbortButton; addOkButton.
     dialog open.
     dialog accepted ifTrue:[
        Transcript showCR:model1 value.
        Transcript showCR:model2 value.
     ].
    "

    "Created: 13.4.1996 / 13:41:31 / cg"
    "Modified: 19.4.1996 / 17:39:46 / cg"
! !

!DialogBox methodsFor:'construction-layout'!

addGap
    "VW compatibility"

    self addGap:4
!

addGap:pixels
    "VW compatibility"

    self addVerticalSpace:pixels

    "Created: / 4.2.2000 / 00:03:58 / cg"
    "Modified: / 5.2.2000 / 15:30:26 / cg"
!

addHorizontalLine
    "add a horizontal line as separator"

    ^ self addComponent:(Separator new extent:1.0 @ 5).

    "
     |dialog|

     dialog := DialogBox new.
     dialog 
	addTextLabel:'some title string';
	addHorizontalLine;
	addTextLabel:'more text';
	addOkButton;
	open.
    "

    "
     |dialog|

     dialog := DialogBox new.
     dialog 
	addTextLabel:'some title string';
	addHorizontalLine;
	addTextLabel:'more text'.
     (dialog addHorizontalLine) width:20.
     dialog addTextLabel:'more text'.
     (dialog addHorizontalLine) width:20.
     dialog 
	addTextLabel:'more text';
	addHorizontalLine;
	addOkButton;
	open.
    "

    "Modified: 19.4.1996 / 15:11:30 / cg"
!

addVerticalSpace
    "add a default vertical space (1 mm)"

    self addVerticalSpace:(ViewSpacing).

    "
     |dialog|

     dialog := DialogBox new.
     dialog addTextLabel:'some title string'.
     dialog addVerticalSpace.
     dialog addTextLabel:'more text'.

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 21:41:10 / cg"
!

addVerticalSpace:nPixel
    "add some pixels of space to the next component"

    yPosition := yPosition + nPixel.
    needResize := true.

    "
     |dialog|

     dialog := DialogBox new.
     dialog addTextLabel:'some title string'.
     dialog addVerticalSpace:50.
     dialog addTextLabel:'more text'.

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 21:41:23 / cg"
! !

!DialogBox methodsFor:'construction-lists'!

addList:listHolder lines:nLines validation:validateionBlock
    ^ self 
        addListBoxOn:listHolder
        withNumberOfLines:nLines 
        hScrollable:true
        vScrollable:true

    "Created: / 4.2.2000 / 00:04:49 / cg"
    "Modified: / 4.2.2000 / 00:06:06 / cg"
!

addListBoxOn:aModel
    "add a selectionInListView to the box.
     The listViews ScrollWrapper is returned"

    ^ self 
	addListBoxOn:aModel 
	withNumberOfLines:nil 
	hScrollable:false 
	vScrollable:true. 

    "
     |dialog model listView|

     model := SelectionInList new.
     model list:#('one' 'two' 'three' 'four').
     model selectionIndex:2.

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog addListBoxOn:model.

     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:model selection].
    "

    "Modified: 27.4.1996 / 18:27:58 / cg"
!

addListBoxOn:aModel class:aListViewClass
    "create & add an instance of aListViewClass to the box.
     The listViews ScrollWrapper is returned"

    ^ self 
	addListBoxOn:aModel
	class:aListViewClass
	withNumberOfLines:nil 
	hScrollable:false 
	vScrollable:true.

    "Created: 19.4.1996 / 13:06:14 / cg"
    "Modified: 27.4.1996 / 18:27:53 / cg"
!

addListBoxOn:aModel class:aListViewClass withNumberOfLines:numLines
    "create and add an instance of aListViewClass to the box.
     The list has numLines (if nonNil) number of lines shown.
     The listViews ScrollWrapper is returned"

    ^ self 
	addListBoxOn:aModel
	class:aListViewClass
	withNumberOfLines:numLines 
	hScrollable:false 
	vScrollable:true.

    "Created: 19.4.1996 / 13:05:05 / cg"
    "Modified: 27.4.1996 / 18:27:48 / cg"
!

addListBoxOn:aModel class:aListViewClass withNumberOfLines:numLines hScrollable:hs vScrollable:vs
    "add an instance of aListViewClass (selectionInListView) to the box.
     The list has numLines (if nonNil) number of lines shown.
     If scrolled, the ScrollWrapper is returned - otherwise the listView."

    |l|

    l := self addTextBoxOn:aModel class:aListViewClass withNumberOfLines:numLines hScrollable:hs vScrollable:vs.
    (aListViewClass canUnderstand:#doubleClickAction:) ifTrue:[
        l doubleClickAction:[:name | self okPressed].
    ].
    ^ l

    "
     |dialog listView|

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog 
                        addListBoxOn:nil 
                        class:FileSelectionList
                        withNumberOfLines:10 
                        hScrollable:false 
                        vScrollable:false.

     listView directory:'/etc'.

     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:listView selectionValue].
    "

    "Created: 22.2.1996 / 15:40:07 / cg"
    "Modified: 27.4.1996 / 18:26:15 / cg"
    "Modified: 15.6.1996 / 00:31:20 / stefan"
!

addListBoxOn:aModel withNumberOfLines:numLines
    "add a selectionInListView to the box.
     The list has numLines (if nonNil) number of lines shown.
     The listViews ScrollWrapper is returned"

    ^ self 
	addListBoxOn:aModel 
	withNumberOfLines:numLines 
	hScrollable:false 
	vScrollable:true. 

    "
     |dialog model listView|

     model := SelectionInList new.
     model list:#('one' 'two' 'three' 'four').
     model selectionIndex:2.

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog addListBoxOn:model withNumberOfLines:3.

     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:model selection].
    "

    "Created: 22.2.1996 / 15:40:07 / cg"
    "Modified: 27.4.1996 / 18:27:42 / cg"
!

addListBoxOn:aModel withNumberOfLines:numLines hScrollable:hs vScrollable:vs
    "add a selectionInListView to the box.
     The list has numLines (if nonNil) number of lines shown.
     If scrolled, the ScrollWrapper is returned - otherwise the listView."

    ^ self 
	addListBoxOn:aModel 
	class:SelectionInListView
	withNumberOfLines:numLines 
	hScrollable:hs 
	vScrollable:vs

    "
     |dialog model listView|

     model := SelectionInList new.
     model list:#('one' 'two' 'three' 'four').
     model selectionIndex:2.

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog addListBoxOn:model withNumberOfLines:3 hScrollable:true vScrollable:true.

     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:model selection].
    "

    "
     |dialog model listView|

     model := SelectionInList new.
     model list:#('one' 'two' 'three' 'four').
     model selectionIndex:2.

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog addListBoxOn:model withNumberOfLines:3 hScrollable:false vScrollable:false.

     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:model selection].
    "

    "Created: 22.2.1996 / 15:40:07 / cg"
    "Modified: 27.4.1996 / 18:26:36 / cg"
!

addPopUpList:labelString on:aModel
    "create a popUpList with a label on aModel and add it.
     Returns the box."

    ^ self addPopUpList:labelString on:aModel tabable:true
!

addPopUpList:labelString on:aModel tabable:tabable
    "create a popUpList on aModel and add it.
     Returns the popUpList."

    |p box l|

    p := PopUpList on:aModel.
    p resize; sizeFixed:true.
    labelString notNil ifTrue:[
	box := HorizontalPanelView new.
	box borderWidth:0; horizontalLayout:#rightSpace.
	box add:(l := Label label:labelString).
	l borderWidth:0.
	box add:p.
    ] ifFalse:[
	box := p.
    ].        
    self addComponent:box tabable:tabable tabbedComponent:p.
    ^ p

    "Modified: 31.5.1996 / 21:25:17 / cg"
!

addPopUpListOn:aModel
    "create a popUpList on aModel and add it.
     Returns the box."

    ^ self addPopUpList:nil on:aModel tabable:true
!

addPopUpListOn:aModel tabable:tabable
    "create a popUpList on aModel and add it.
     Returns the popUpList."

    ^ self addPopUpList:nil on:aModel tabable:tabable
!

addRadioButton:labelString on:aRadioButtonGroupModel value:radioValue tabable:tabable
    "create a radio button on aModel and add it.
     Returns the radio button."

    |r|

    r := RadioButton label:labelString.
    aRadioButtonGroupModel add:r value:radioValue.

    self addComponent:r tabable:tabable.
    ^ r

    "Created: / 23-07-2011 / 17:28:08 / cg"
!

addTextBoxOn:aModel class:aListViewClass withNumberOfLines:numLines hScrollable:hs vScrollable:vs
    "add an instance of aListViewClass to the box.
     The list has numLines (if nonNil) number of lines shown.
     If scrolled, the ScrollWrapper is returned - otherwise the listView."

    |l scr h dH|

    l := aListViewClass new.
    l model:aModel.

    (vs or:[hs]) ifTrue:[
        hs ifTrue:[
            scr := HVScrollableView forView:l miniScrollerH:true .
        ] ifFalse:[
            scr := ScrollableView forView:l
        ].
        scr resize.
        "/ Transcript show:scr height; show:' '; showCR:l height.
        dH := scr height - l height.
    ] ifFalse:[
        l level:-1.
        scr := l.
        dH := 0.
    ].

    numLines notNil ifTrue:[
        h := l heightForLines:numLines.
    ] ifFalse:[
        h := l preferredHeight
    ].
    self addComponent:scr withHeight:(h + dH).
    ^ scr

    "
     |dialog listView|

     dialog := DialogBox new.
     (dialog addTextLabel:'select any') adjust:#left.

     listView := dialog 
                        addTextBoxOn:nil 
                        class:EditTextView
                        withNumberOfLines:10 
                        hScrollable:true 
                        vScrollable:true.


     dialog addAbortButton; addOkButton.
     dialog open.

     dialog accepted ifTrue:[Transcript show:'selection is:'; showCR:listView contents].
    "

    "Created: 14.6.1996 / 23:33:47 / stefan"
    "Modified: 8.11.1996 / 15:31:15 / cg"
! !

!DialogBox methodsFor:'construction-rows & columns'!

addColumn:aRow fromX:leftX toX:rightX collect:aBlock
    "add some elements in a vertical column.
     Equally space elements as returned from aBlock."

    self 
	addColumn:aRow 
	fromX:leftX toX:rightX 
	collect:aBlock 
	tabable:false

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addColumn:#('label1' 'label2' 'lbl3' 'l4' 'label5')
	fromX:0.0
	toX:1.0
	collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addColumn:#('label1' 'label2' 'label3' 'label4' 'label5')
	fromX:0.25 
	toX:0.75
	collect:[:label | (Label label:label) adjust:#left].

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog y|

     dialog := Dialog new.
     y := dialog yPosition.
     dialog 
	addColumn:#('a1' 'b1' 'c1' 'd1')
	fromX:0
	toX:(1/3) 
	collect:[:label | Label label:label].

     dialog yPosition:y.
     dialog 
	addColumn:#('a2' 'b2' 'c2' 'd2')
	fromX:(1/3)
	toX:(2/3) 
	collect:[:label | Label label:label].

     dialog yPosition:y.
     dialog 
	addColumn:#('a3' 'b3' 'c3' 'd3')
	fromX:(2/3)
	toX:1 
	collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 22:22:12 / cg"
!

addColumn:aRow fromX:leftX toX:rightX collect:aBlock tabable:tabable
    "add some elements in a vertical column.
     Equally space elements as returned from aBlock."

    self 
	addColumn:aRow 
	fromX:leftX toX:rightX 
	collect:aBlock 
	tabable:tabable 
	horizontalLayout:#fitSpace 

    "
     |dialog y values|

     values := (1 to:4) collect:[:dummy | '' asValue].

     dialog := Dialog new.
     y := dialog yPosition.
     dialog 
	addColumn:#('one' 'two' 'three' 'four')
	fromX:0
	toX:0.3 
	collect:[:label | Label label:label].

     dialog yPosition:y.
     dialog 
	addColumn:values
	fromX:0.3
	toX:1.0 
	collect:[:value | EditField on:value]
	tabable:true.

     dialog addOkButton.
     dialog open.

     dialog accepted ifTrue:[
	Transcript showCR:(values collect:[:holder | holder value])
     ]
    "

    "
     |dialog y values|

     values := #(true true false false false true false true) collect:[:val | val asValue].

     dialog := Dialog new.
     y := dialog yPosition.
     dialog 
	addColumn:(1 to:4)
	fromX:0
	toX:0.5 
	collect:[:idx | CheckToggle on:(values at:idx)]
	tabable:true
	horizontalLayout:#center.

     dialog yPosition:y.
     dialog 
	addColumn:(5 to:8) 
	fromX:0.5 
	toX:1.0 
	collect:[:idx | CheckToggle on:(values at:idx)]
	tabable:true
	horizontalLayout:#center.

     dialog addOkButton.
     dialog open.

     dialog accepted ifTrue:[
	Transcript showCR:(values collect:[:holder | holder value])
     ]
    "

    "Created: 9.2.1996 / 21:51:47 / cg"
    "Modified: 9.2.1996 / 22:22:02 / cg"
!

addColumn:aRow fromX:leftX toX:rightX collect:aBlock tabable:tabable horizontalLayout:hLayout
    "add some elements in a vertical column.
     Equally space elements as returned from aBlock."

    |helper component|

    helper := VerticalPanelView new.

    aRow do:[:el |
        component := aBlock value:el.
        helper add:component.
        component resize.
        tabable ifTrue:[self makeTabable:component].
    ].    

    helper resize.
    self addComponent:helper.
    width < helper preferredWidth ifTrue:[
        self width:helper preferredWidth.
        "/ Transcript show:'w now: '; showCR:helper preferredExtent x
    ].
    helper horizontalLayout:hLayout.
    helper left:leftX asFloat;
           right:rightX asFloat;
           leftInset:leftIndent;
           rightInset:rightIndent.

    "
     |dialog y values|

     values := (1 to:4) collect:[:dummy | '' asValue].

     dialog := Dialog new.
     y := dialog yPosition.
     dialog 
        addColumn:#('one' 'two' 'three' 'four')
        fromX:0
        toX:0.3 
        collect:[:label | Label label:label].

     dialog yPosition:y.
     dialog 
        addColumn:values
        fromX:0.3
        toX:1.0 
        collect:[:value | EditField on:value]
        tabable:true.

     dialog addOkButton.
     dialog open.

     dialog accepted ifTrue:[
        Transcript showCR:(values collect:[:holder | holder value])
     ]
    "

    "
     |dialog y values|

     values := #(true true false false false true false true) collect:[:val | val asValue].

     dialog := Dialog new.
     y := dialog yPosition.
     dialog 
        addColumn:(1 to:4)
        fromX:0
        toX:0.5 
        collect:[:idx | CheckToggle on:(values at:idx)].

     dialog yPosition:y.
     dialog 
        addColumn:(5 to:8) 
        fromX:0.5 
        toX:1.0 
        collect:[:idx | CheckToggle on:(values at:idx)]
        tabable:true.

     dialog addOkButton.
     dialog open.

     dialog accepted ifTrue:[
        Transcript showCR:(values collect:[:holder | holder value])
     ]
    "

    "Modified: 9.2.1996 / 22:02:22 / cg"
    "Created: 9.2.1996 / 22:20:31 / cg"
!

addRow:aCol fromX:leftX toX:rightX collect:aBlock
    "add some elements in a horizontal row.
     Equally space elements as returned from aBlock.
     Advance y."

    self 
	addRow:aCol 
	fromX:leftX toX:rightX 
	collect:aBlock 
	tabable:true 
	horizontalLayout:#spread 

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addRow:#('a' 'b' 'c' 'd')
	fromX:0
	toX:1
	collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addRow:#('a1' 'b1' 'c1' 'd1')
	fromX:0
	toX:1 
	collect:[:label | Label label:label].

     dialog 
	addRow:#('a2' 'b2' 'c2' 'd2')
	fromX:0
	toX:0.5 
	collect:[:label | Label label:label].

     dialog 
	addRow:#('a3' 'b3' 'c3' 'd3')
	fromX:0.5
	toX:1 
	collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 22:25:16 / cg"
!

addRow:aCol fromX:leftX toX:rightX collect:aBlock tabable:tabable
    "add some elements in a horizontal row.
     Equally space elements as returned from aBlock.
     Advance y."

    self 
	addRow:aCol 
	fromX:leftX toX:rightX 
	collect:aBlock 
	tabable:tabable 
	horizontalLayout:#spread

    "Created: 9.2.1996 / 22:25:35 / cg"
!

addRow:aCol fromX:leftX toX:rightX collect:aBlock tabable:tabable horizontalLayout:hLayout
    "add some elements in a horizontal row.
     Equally space elements as returned from aBlock.
     Advance y."

    ^ self
	addRow:aCol 
	fromX:leftX toX:rightX 
	collect:aBlock 
	tabable:tabable 
	horizontalLayout:hLayout
	verticalLayout:#fit

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addRow:#('a' 'b' 'c' 'd')
	fromX:0
	toX:1
	collect:[:label | Label label:label]
	tabable:false
	horizontalLayout:#fit.

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addRow:#('one' 'two' 'three' 'four')
	fromX:0
	toX:1
	collect:[:label | Button label:label]
	tabable:false
	horizontalLayout:#fit.

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
	addRow:#('a1' 'b1' 'c1' 'd1')
	fromX:0
	toX:1 
	collect:[:label | Label label:label].

     dialog 
	addRow:#('a2' 'b2' 'c2' 'd2')
	fromX:0
	toX:0.5 
	collect:[:label | Label label:label].

     dialog 
	addRow:#('a3' 'b3' 'c3' 'd3')
	fromX:0.5
	toX:1 
	collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "Created: 9.2.1996 / 22:24:31 / cg"
    "Modified: 31.5.1996 / 20:46:00 / cg"
!

addRow:aCol fromX:leftX toX:rightX collect:aBlock tabable:tabable horizontalLayout:hLayout verticalLayout:vLayout
    "add some elements in a horizontal row.
     Equally space elements as returned from aBlock.
     Advance y."

    |helper component|

    helper := HorizontalPanelView new.
    helper borderWidth:0.

    aCol do:[:el |
        component := aBlock value:el.
        component resize.
        helper add:component.
        tabable ifTrue:[self makeTabable:component]
    ].    

    helper resize.
    self addComponent:helper.

    width < helper preferredWidth ifTrue:[
        self width:helper preferredWidth.
        "/ Transcript show:'w now: '; showCR:helper preferredWidth
    ].
    hLayout notNil ifTrue:[
        helper horizontalLayout:hLayout.
    ].
    vLayout notNil ifTrue:[
        helper verticalLayout:vLayout.
    ].
    helper left:leftX asFloat;
           right:rightX asFloat.

    "
     |dialog|

     dialog := Dialog new.
     dialog 
        addRow:#('a' 'b' 'c' 'd')
        fromX:0
        toX:1
        collect:[:label | Label label:label]
        tabable:false
        horizontalLayout:#fit.

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
        addRow:#('one' 'two' 'three' 'four')
        fromX:0
        toX:1
        collect:[:label | Button label:label]
        tabable:false
        horizontalLayout:#fit.

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog|

     dialog := Dialog new.
     dialog 
        addRow:#('a1' 'b1' 'c1' 'd1')
        fromX:0
        toX:1 
        collect:[:label | Label label:label].

     dialog 
        addRow:#('a2' 'b2' 'c2' 'd2')
        fromX:0
        toX:0.5 
        collect:[:label | Label label:label].

     dialog 
        addRow:#('a3' 'b3' 'c3' 'd3')
        fromX:0.5
        toX:1 
        collect:[:label | Label label:label].

     dialog addOkButton.
     dialog open.
    "

    "Created: 31.5.1996 / 20:45:31 / cg"
    "Modified: 17.7.1996 / 12:06:08 / cg"
! !

!DialogBox methodsFor:'explicit focus control'!

focusOnOk
    windowGroup focusView:okButton

    "Modified: 19.4.1996 / 16:57:58 / cg"
! !

!DialogBox methodsFor:'initialization & release'!

initialize
    super initialize.

"/    label := 'Dialog'.
    acceptValue := ValueHolder newBoolean.

    acceptReturnAsOK := true.
    acceptOnLeave := true.
    focusToOKOnLeave := DefaultFocusToOKOnLeave.
    hideOnAccept := true.
    autoAccept := true.

    buttonPanel := HorizontalPanelView in:self.
    buttonPanel
        origin:(0.0 @ 1.0) corner:(1.0 @ 1.0);
        bottomInset:ViewSpacing; 
        topInset:((gc font height + (ViewSpacing*2)) + ViewSpacing) negated;
        borderWidth:0;
        horizontalLayout:#spread.

    buttonPanel rightInset:(device extentOfResizeHandle x).
    "/ some viewStyles want ok to be the leftMost button.
    buttonPanel reverseOrderIfOKAtLeft:true.

    yPosition := ViewSpacing.
    leftIndent := rightIndent := (ViewSpacing // 2).
    needResize := true.

    "
     |b|
     b := DialogBox new.
     b addAbortButton; 
       addOkButton; 
       showAtPointer
    "
    "
     |b|
     b := DialogBox new.
     b addOkButton; 
       showAtPointer
    "
    "
     |b|
     b := DialogBox new.
     b addTextLabel:'hello world';
       addOkButton; 
       showAtPointer
    "
    "
     |b|
     b := DialogBox new.
     b addTextLabel:'hello world';
       addVerticalSpace:50; 
       addOkButton; 
       showAtPointer
    "

    "Modified: / 23.12.1997 / 10:05:24 / md"
    "Modified: / 27.7.1998 / 20:16:37 / cg"
!

reAdjustGeometry
    "sent late in snapin processing - gives me a chance
     to resize for changed font dimensions."

    super reAdjustGeometry.
    okButton notNil ifTrue:[okButton resize].
    abortButton notNil ifTrue:[abortButton resize].
    self resize
! !

!DialogBox methodsFor:'layout control'!

bottomAlign:widgets
    "mhmh - seems similar to our stickAtBottom functionality - to be checked"

    'DialogBox [warning]: unimplemented VW feature: #bottomAlign' infoPrintCR.
"/    self halt:'unimplemented VW functionality'.

    "Created: / 4.2.2000 / 00:10:21 / cg"
    "Modified: / 5.2.2000 / 15:31:23 / cg"
!

bottomAlignLowerEdge:widget
    "mhmh - seems similar to our stickAtBottom functionality - to be checked"

    "/ self halt:'unimplemented VW functionality'.
    self stickAtBottomWithVariableHeight:widget

    "Modified: / 5.2.2000 / 15:31:15 / cg"
!

leftIndent
    "return the current indent 
     (current x position - that's where the next component will be positioned)."

    ^ leftIndent

    "Modified: 27.1.1996 / 18:21:31 / cg"
!

leftIndent:aNumber 
    "set the left indent 
     (current x position - that's where the next component(s) will be located).
     Setting this before adding a component will place it indented"

    leftIndent := aNumber.
    needResize := true.

    "
     |dialog|

     dialog := DialogBox new.
     (dialog addTextLabel:'label1') adjust:#left.
     dialog leftIndent:20.
     (dialog addTextLabel:'label2') adjust:#left.
     dialog leftIndent:40.
     (dialog addTextLabel:'label3') adjust:#left.
     dialog leftIndent:60.
     (dialog addTextLabel:'label4') adjust:#left.

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 21:42:20 / cg"
!

rightIndent
    "return the current right indent."

    ^ rightIndent

    "Modified: 27.1.1996 / 18:21:31 / cg"
!

rightIndent:aNumber 
    "set the right indent"

    rightIndent := aNumber.
    needResize := true.

    "
     |dialog|

     dialog := DialogBox new.
     (dialog addTextLabel:'label1') adjust:#right.
     dialog rightIndent:20.
     (dialog addTextLabel:'label2') adjust:#right.
     dialog rightIndent:40.
     (dialog addTextLabel:'label3') adjust:#right.
     dialog rightIndent:60.
     (dialog addTextLabel:'label4') adjust:#right.

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 21:42:46 / cg"
!

setInitialGap

    "Created: / 4.2.2000 / 00:01:44 / cg"
!

stickAtBottomWithFixHeight:aComponent
    "arrange for a component to be positioned at a constant offset
     from the bottom of the box and its height to remain the same.
     This will keep the component at a constant distance from the bottom
     (without this setup, it would stay at a constant offset from the top).
     ATTENTION: use this as a last step, after all components have been added."

    self stickAtBottomWithFixHeight:aComponent left:0.0 right:1.0

    "
     compare the resizing behavior of:

        |box|

        box := Dialog new.
        box addTextLabel:'hello'.
        box addTextLabel:'hello2'.
        box addOkButton.
        box show

     with:

        |box l2|

        box := Dialog new.
        box addTextLabel:'hello'.
        l2 := box addTextLabel:'hello2'.
        box addOkButton.
        box stickAtBottomWithFixHeight:l2.
        box show
   "

    "Created: / 27.1.1996 / 17:17:41 / cg"
    "Modified: / 18.8.2000 / 21:38:21 / cg"
!

stickAtBottomWithFixHeight:aComponent left:left right:right
    "arrange for a component to be positioned at a constant offset
     from the bottom of the box and its height to remain the same.
     This will keep the component at a constant distance from the bottom
     (without this setup, it would stay at a constant offset from the top).
     ATTENTION: use this as a last step, after all components have been added."

    self resize.

    aComponent
        topInset:(self height - aComponent top) negated;
        bottomInset:(self height - aComponent bottom); 
        origin:left @ 1.0; corner:right @ 1.0.

    "
     compare the resizing behavior of:

        |box|

        box := Dialog new.
        box addTextLabel:'hello'.
        box addTextLabel:'hello2'.
        box addOkButton.
        box show

     with:

        |box l2|

        box := Dialog new.
        box addTextLabel:'hello'.
        l2 := box addTextLabel:'hello2'.
        box addOkButton.
        box stickAtBottomWithFixHeight:l2.
        box show
   "

    "Created: / 27.1.1996 / 17:17:41 / cg"
    "Modified: / 18.8.2000 / 21:38:26 / cg"
!

stickAtBottomWithVariableHeight:aComponent
    "arrange for a component to be positioned at a constant offset
     from the bottom of the box and its height to be adjusted.
     This will resize the component for a constant distance from the top,
     and the bottom.
     (without this setup, its height would remain constant).
     ATTENTION: use this as a last step, after all components have been added."

    self resize.

    aComponent
        bottomInset:(self height - aComponent bottom); 
        corner:1.0@1.0.

    "
     compare the resizing behavior of:

        |box|

        box := Dialog new.
        box addTextLabel:'hello'.
        (box addComponent:(SelectionInListView new)) level:-1.
        box addOkButton.
        box show

     with:

        |box list|

        box := Dialog new.
        box addTextLabel:'hello'.
        list := (box addComponent:(SelectionInListView new)) level:-1.
        box addOkButton.
        box stickAtBottomWithVariableHeight:list.
        box show
   "

    "Modified: / 18.8.2000 / 21:38:35 / cg"
!

yPosition 
    "return the current y position 
     (that's where the next component will be positioned)."

    ^ yPosition 
!

yPosition:aNumber 
    "set the current y position 
     (that's where the next component will be positioned)."

    yPosition := aNumber.
    needResize := true.

    "
     |dialog pos|

     dialog := DialogBox new.
     pos := dialog yPosition.
     (dialog addTextLabel:'label1') width:0.5.
     dialog yPosition:pos.
     (dialog addTextLabel:'label2') width:0.5; left:0.5.

     dialog addOkButton.
     dialog open.
    "

    "
     |dialog pos|

     dialog := DialogBox new.
     pos := dialog yPosition.
     #('one' 'two' 'three' 'four') 
     with:#(0.0 0.25 0.5 0.75) do:[:lbl :x |
         dialog yPosition:pos.
        (dialog addComponent:(Button label:lbl) tabable:true)
                width:0.25; left:x.
     ].

     dialog addOkButton.
     dialog open.
    "

    "Modified: 9.2.1996 / 21:46:40 / cg"
! !

!DialogBox methodsFor:'private'!

assignKeyboardFocusToFirstKeyboardConsumer
    |field|

    (inputFieldGroup notNil 
      and:[(field := inputFieldGroup currentField) notNil
      and:[field shown]]) ifTrue:[
        self assignKeyboardFocusTo:field.
        ^ self  "/ disabled - the focus might have already been changed
                "/ explicitly to another field
    ].
    ^ super assignKeyboardFocusToFirstKeyboardConsumer
!

basicAddComponent:aComponent 
    "add a component, don't change its size"

    addedComponents isNil ifTrue:[
        addedComponents := OrderedCollection new.
    ].
    addedComponents add:aComponent.
    self addSubView:aComponent.

    needResize := true.
    "/ must flush any cached preferredExtent, when a component is added (for example, in an aboutToOpen callBack)
    preferredExtent := nil.
!

forceResize
    "force a recomputation of my size.
     Cann this, when elements where added to a subcomponent, 
     of which I cannot know. 
     Eg. when someone gets the buttonPanel and adds an element to it"
     
    needResize := true.
    self resize
!

hideAndEvaluate:aBlock
    "if I am modal, make myself invisible and evaluate aBlock.
     If nonModal, stay up, but also evaluate the block."

    (windowGroup notNil and:[windowGroup isModal]) ifTrue:[
        self hide.
    ].
    aBlock notNil ifTrue:[
        aBlock numArgs == 0 ifTrue:[
            aBlock value
        ] ifFalse:[
            aBlock value:(self actionArgument)
        ]
    ].

    (windowGroup isNil or:[windowGroup isModal not]) ifTrue:[
        self destroy.
    ].

    "Modified: 5.9.1995 / 19:06:33 / claus"
!

preOpen

    "Created: / 4.2.2000 / 00:10:48 / cg"
!

realize
    "if any inputFields where added, activate the first one"

    verticalPanel notNil ifTrue:[
        verticalPanel extent:verticalPanel preferredExtent.
        preferredExtent := nil.
        self extent:(self preferredExtent).
    ].

    super realize.

    buttonPanel notNil ifTrue:[
        buttonPanel raise.
        buttonPanel subViews do:[:eachButton |
            eachButton canTab:true.
        ]
    ].    

    inputFieldGroup notNil ifTrue:[
        inputFieldGroup activateFirstIfNoCurrent
    ].

    "Modified: / 28-02-2012 / 15:54:10 / cg"
!

resize
    needResize ifTrue:[
"/        verticalPanel notNil ifTrue:[
"/            verticalPanel extent:verticalPanel preferredExtent.
"/            preferredExtent := nil.
"/            self extent:(self preferredExtent).
"/        ].
        needResize := false.
        super resize
    ]

    "Created: 27.1.1996 / 17:22:33 / cg"
    "Modified: 27.1.1996 / 18:25:40 / cg"
! !

!DialogBox methodsFor:'queries'!

accepted
    "after the box has closed:
	 return true if accepted, false if canceled"

    ^ acceptValue value
!

interfaceSpecFor:aSelector
    "return an interface spec.
     Notice - Dialog should be moved under AppModel so this becomes obsolete."

    ^ UISpecification from:(self specificationFor:aSelector)
!

maxPreferredWidthOfAddedComponents
    "helper for computing my preferred extent.
     That is the max component width"

    ^ (addedComponents ? #())
        inject:0 
        into:[:max :element |
                |eExt prefWidth scale rel relX|

                prefWidth := element preferredWidth.

                "/ special (for your convenience)
                "/ if the element has been added with a relative width,
                "/ scale it to get at least its preferred width

                (rel := element relativeExtent) notNil ifTrue:[
                    relX := rel x.
                    (relX isNil or:[relX isInteger]) ifFalse:[
                        prefWidth := (prefWidth * (1 / relX)) rounded
                    ].
                ].
                eExt := prefWidth + (element borderWidth * 2). "/ max:element extent x.
                max max:(eExt + element leftInset + element rightInset)].
!

positionOffset
    "return the delta, by which the box should be displayed
     from the mouse pointer. Here, an offset is returned, which
     makes the center of the first return-Button in the panel
     appear under the cursor. If there is no such button,
     use my superclasses offset."

    |idx butt buttons|

    buttonPanel notNil ifTrue:[
        buttons := buttonPanel subViews.
        buttons size > 0 ifTrue:[
            idx := buttons findFirst:[:b | b isDefault].
            idx ~~ 0 ifTrue:[
                butt := buttons at:idx.

                "get our size (preferredExtent) and compute
                 origin and extent of buttonPanel and okButton.
                 This is normally done on view realization."

                needResize ifTrue:[ self resize ].
                buttonPanel 
                    pixelOrigin:buttonPanel computeOrigin
                    extent:buttonPanel computeExtent.
                buttonPanel setChildPositionsIfChanged.
                ^ (butt originRelativeTo:self) + (butt extent // 2).
            ]
        ]
    ].

    ^ super positionOffset

    "Modified: 3.1.1997 / 10:41:58 / stefan"
    "Modified: 16.1.1997 / 22:00:23 / cg"
!

preferredExtent 
    "return my preferred extent.
     That is the max component width, or my current width (default);
     whichever is larger, by the sum of the component's heights."

    |w h p|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    h := yPosition + ViewSpacing.
    verticalPanel notNil ifTrue:[
        "/ because the vertical panels size was not known until now,
        "/ it was not counted in the y-position yet.
        "/ do this now.
        verticalPanel extent:(verticalPanel computePreferredExtent).
        h := h + verticalPanel height.
    ].

    addedComponents notNil ifTrue:[
        w := self maxPreferredWidthOfAddedComponents.
    ] ifFalse:[
        w := super preferredExtent x.
    ].
    w := w max:width.

    subViews size ~~ 0 ifTrue:[
        p := buttonPanel preferredExtent.
        w := w max:p x.
        h := h
             + p y
             + ViewSpacing.
    ].

"/    okButton isNil ifTrue:[
"/        ^ super preferredExtent
"/    ].
"/    p := buttonPanel preferredExtent.
"/    w := p x.
"/    h := ViewSpacing
"/         + p y
"/         + ViewSpacing.
"/
    ^ w @ h

    "Modified: 19.7.1996 / 20:43:52 / cg"
!

specificationFor:aKey
    "return an interface specs literal encoding.
     Notice - Dialog should be moved under AppModel so this becomes obsolete."

    ^ ApplicationModel
        specificationFor:aKey 
        application:self
        onDevice:(device)
! !

!DialogBox methodsFor:'user actions'!

abortPressed
    "sent by the cancel button; user pressed abort button
     - hide myself and evaluate okAction"

    abortButton turnOffWithoutRedraw.
    acceptValue value:false.

    "/ actually, only hides if I have been opened modal
    self hideAndEvaluate:abortAction
!

actionArgument
    ^ nil
!

closeCancel
    "closed via escape"

    acceptValue value:false.

    "/ actually, only hides if I have been opened modal
    self hideAndEvaluate:abortAction
!

doAccept
    "let all components accept (i.e. update their model from the values),
     then set my accept value to true.
     This is confusing: this method was originally called #accept,
     but renamed for compatibility with ST-80, where #accept returns the
     accept-valueHolder (which looks like a bad name to me ...)."

    autoAccept ifTrue:[    
	addedComponents notNil ifTrue:[
	    addedComponents do:[:aComponent |
		(aComponent respondsTo:#accept) ifTrue:[
		    aComponent accept
		]
	    ]
	].
    ].
    acceptValue value:true.

    "Modified: 4.3.1996 / 12:14:56 / cg"
!

keyPress:aKey x:x y:y
    "return-key duplicates ok-function if acceptReturnAsOK is true"

    <resource: #keyboard (#Return #Escape)>

    |b focusView|

    "/ notice: the modern way to handle this is via the keyboard processor;
    "/ however, for old-style DialogBoxes (i.e. without AppModel), 
    "/ the keyboardProcessor has no one to inform about RETURN/ESCAPE. 
    "/ So the procesing here is still needed.

    (aKey == #Return) ifTrue:[
        focusView := self windowGroup explicitFocusView.
        "/ in case user tabbed onto one of the buttons, that is the one to trigger
        focusView notNil ifTrue:[
            focusView == okButton ifTrue:[
                ^ self okPressed
            ].
            focusView == abortButton ifTrue:[
                ^ self abortPressed
            ].
            (buttonPanel notNil and:[ buttonPanel subViews includesIdentical:focusView ]) ifTrue:[
                focusView turnOnWithAction.focusView turnOffWithAction.
                ^ self.
            ].
        ].

        "/ the focus is on anything else.
        (okButton notNil and:[okButton isReturnButton]) ifTrue:[
            ^ self okPressed
        ].
        (abortButton notNil and:[abortButton isReturnButton]) ifTrue:[
            ^ self abortPressed
        ].
        (buttonPanel notNil and:[(b := buttonPanel subViews detect:[:b | b isReturnButton] ifNone:nil) notNil]) ifTrue:[
            b turnOnWithAction. b turnOffWithAction.
            ^ self.
        ]
    ].

    (aKey == #Escape) ifTrue:[
        (abortButton notNil) ifTrue:[
            ^ self abortPressed
        ].
    ].

    super keyPress:aKey x:x y:y

    "Modified: 7.3.1996 / 13:15:09 / cg"
!

lastFieldLeft
    "if the dialog involves input fields, this is called
     when the last field is left by Return-key or NextField-key"

    acceptOnLeave ifTrue:[
	acceptReturnAsOK ifTrue:[
	    focusToOKOnLeave ifTrue:[
		self focusOnOk.
		^ self.
	    ].
	    self okPressed
	]
    ].
    inputFieldGroup activateFirst

    "Modified: 19.4.1996 / 17:09:02 / cg"
!

okPressed
    "sent by the okButton; user pressed ok-button
     - make myself invisible and if an action was specified do it"

    okButton notNil ifTrue:[okButton turnOffWithoutRedraw].

    self doAccept.

    acceptCheck notNil ifTrue:[
	acceptCheck value ifFalse:[^ self]
    ].

    hideOnAccept ifTrue:[
	"/ actually, only hides if I have been opened modal
	self hideAndEvaluate:okAction.
    ] ifFalse:[
	okAction value
    ]
!

openDialog
    self showAtPointer.
    ^ self accepted
! !

!DialogBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


DialogBox initialize!
