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

View subclass:#Label
	instanceVariableNames:'logo labelWidth labelHeight labelOriginX labelOriginY adjust
		hSpace vSpace bgColor fgColor etchedFgColor fixSize labelMsg
		converter labelChannel'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor'
	poolDictionaries:''
	category:'Views-Layout'
!

Object subclass:#AnimatorState
	instanceVariableNames:'timedBlock nextOffset logoShown moveDirection pointerEntered'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Label
!

!Label class methodsFor:'documentation'!

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
    This class implements labels, which are views to display a string or image.
    The Label will try to do its best to make its contents fit into the
    view. The contents can be a String, a collection of Strings (i.e.
    a StringCollection) or a Form/Image. 

    The contents is drawn in fgColor/bgColor, which can be changed using:

        aLabel foregroundColor:aColor
        aLabel backgroundColor:aColor

    When a label is assigned a contents, it will resize itself to fit
    the required size. This resizing can be suppressed by setting the
    fixsize attribute to true using:

        aLabel sizeFixed:true

    This can be used, if resizing of the label is not wanted.
    However, in this case you have to make certain that the size is big enough
    to hold any changed logos later. (usually, you create the label first with
    the longest string first to have it compute its size, then set the fixSize 
    attribute to avoid resizing later).
    Be careful when placing self-resizing labels into panels - by default,
    panels do not react on the size change - leading to ugly looking geometry.
    (but you can tell the panel to watch for changes with #elementsCHangeSize:)

    The placement of the contents within the label is controlled by
    the adjust attribute, it can be set with:

        aLabel adjust:how

    where how is one of the symbols left, #right, #center, #centerEach,
    #centerLeft, #centerRight, #leftRight or #rightLeft 
    (see the comment in Label>>adjust:). The default is #center.

    model-less operation (ok for static labels):
      if no model is set, the labels contents is set with:

        aLabel label:aStringOrImage

      and stays constant unless changed by new calls to #label:.


    model operation (ST-80 style):
      labels with a model, aspectMsg and labelMsg react to 
      changes of the aspect, and send a labelMsg-message 
      to the model in order to acquire a new labelString or image.
      The model should send 'self changed:aspectMsg' if it thinks the label 
      should change and return a string or image from the labelMsg-message.

        label model:aModel.
        label aspect:aspectSymbol.
        label labelMessage:labelSymbol.

        model sends #changed:aspectSymbol
        ---> label will redraw its label from value of model perform:labelSymbol

      Having a labelSymbol different from the aspectSymbol allows for two labels
      to react on the same aspect-change, but use different messages when asking
      the model for a new label contents. By default, the labelMsg is nil,
      so the label does NOT update its shown contents.
      The aspectMsg defaults to #value.



    channel operation (new ST/X style):

      the label will react on changes of the token found in the
      channels: foregroundChannel, backgroundChannel and labelChannel.
      These are valueHolders and can be shared between labels.


        
    [Instance variables:]

        logo                <Object>        the logo, can be a Form, String or Text
        labelWidth          <Integer>       the width of the logo in device units
        labelHeight         <Integer>       the height of the logo in device units
        labelOriginX        <Integer>       the x-position of the logo withing the Label
        labelOriginY        <Integer>       the y-position of the logo withing the Label
        adjust              <Symbol>        controls how the logo is positioned within the
                                            label. Can be one of:#left,#right,#center,
                                            #centerLeft or #centerRight (see comment in adjust:)
        hSpace              <Integer>       number of horizontal pixels around logo
        vSpace              <Integer>       number of vertical pixels around logo

        bgColor             <Color>         background color
        fgColor             <Color>         foreground color

        fixSize             <Boolean>       if true, a change of the logo change will not
                                            resize the label; otherwise, its size is adjusted.
                                            default:false.

        labelMsg            <Symbol>        if non-nil, this is sent to the model to
                                            acquire the labelString or labelImage.
                                            If nil, the label stays as is

    [styleSheet parameters:]

      labelForegroundColor    <Color>         color to draw foreground pixels (i.e. the string)
      labelBackgroundColor    <Color>         color to draw background pixels
      labelFont               <Font>          font to use for textual labels

    [author:]
        Claus Gittinger

    [see also:]
        Panel HorizontalPanel VerticalPanel
        TextView EditTextView
        Button
        InfoBox WarningBox
"
!

examples
"
    Notice, that Buttons and others inherit from Label; 
    therefore, the following geometry examples apply to all subclasses too.


    simple (default position is 0@0):
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l label:'hello world'.

        top open
                                                                        [exEnd]


    simple with emphasis:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(300 @ 100).

        l := Label in:top.
        l level:-1.
        l label:('hello world - this is text in a label ' asText 
                        emphasizeFrom:7 to:11 with:#italic;
                        emphasizeFrom:23 to:26 with:#bold).
        top open
                                                                        [exEnd]


    there is also a creation message which sets the label:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label label:'hello world' in:top.

        top open
                                                                        [exEnd]


    placement:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l label:'hello world'.
        l origin:50@100.

        top open
                                                                        [exEnd]


    level:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:5.
        l label:'hello world'.
        l origin:50@100.

        top open
                                                                        [exEnd]


    another level:    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:-1.
        l label:'hello world'.
        l origin:50@100.

        top open
                                                                        [exEnd]


    colors & font:    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:-1.
        l font:(Font family:'Times' size:18).
        l foregroundColor:Color yellow.
        l backgroundColor:Color red.
        l label:'hello world'.
        l origin:50@100.

        top open
                                                                        [exEnd]


    border & colors:    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:0.
        l borderWidth:1.
        l borderColor:Color red.
        l foregroundColor:Color green darkened.
        l backgroundColor:Color green lightened.
        l label:'hello world'.
        l origin:50@100.

        top open
                                                                        [exEnd]


    different adjusts (resize to see):    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(300 @ 250).
        top label:'make me smaller'.

        l := Label in:top.
        l borderWidth:1.
        l label:'default - #centered'.
        l origin:0.1@40.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#left.
        l label:'#left adjust'.
        l origin:0.1@70.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#right.
        l label:'#right adjust'.
        l origin:0.1@100.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#centerLeft.
        l label:'#centerLeft adjust with a long text'.
        l origin:0.1@130.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#centerRight.
        l label:'#centerRight adjust with a long text'.
        l origin:0.1@160.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#leftRight.
        l label:'#leftRight adjust with a long text'.
        l origin:0.1@190.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#rightLeft.
        l label:'#rightLeft adjust with a long text'.
        l origin:0.1@220.
        l width:0.8.

        top open
                                                                        [exEnd]


    center vs. centerEach adjust (only with multiline labels):    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(300 @ 250).
        top label:'resize me'.

        l := Label in:top.
        l borderWidth:1.
        l label:'this labels logo
consists of multiple lines 
with #center adjust'.
        l origin:0.1@0.1.
        l corner:0.9@0.9.
        l adjust:#center.

        top open.

        top := StandardSystemView new.
        top extent:(300 @ 250).
        top label:'resize me'.

        l := Label in:top.
        l borderWidth:1.
        l label:'this labels logo
consists of multiple lines 
with #centerEach adjust'.
        l origin:0.1@0.1.
        l corner:0.9@0.9.
        l adjust:#centerEach.

        top open

                                                                        [exEnd]

    fitting-adjust (resize to see):
    Warning: #fit is experimental and should not be used.
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label origin:0.25 @ 0.25 corner:0.75@0.75 in:top.
        l label:'stretch'.
        l level:-1.
        l adjust:#fit.

        top open
                                                                        [exEnd]

    or:
    Warning: #fit is experimental and should not be used.
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label origin:0.25 @ 0.25 corner:0.75@0.75 in:top.
        l label:(Image fromFile:'bitmaps/SBrowser.xbm').
        l level:-1.
        l adjust:#fit.

        top open
                                                                        [exEnd]


    just a reminder, that instead of doing placement manually
    as in ...:    
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l borderWidth:1.
        l label:'default - centered'.
        l origin:0.1@70.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#left.
        l label:'left adjust'.
        l origin:0.1@100.
        l width:0.8.

        l := Label in:top.
        l borderWidth:1.
        l adjust:#right.
        l label:'right adjust'.
        l origin:0.1@130.
        l width:0.8.

        top open
                                                                        [exEnd]


    ... it is much easier, to use a geometry handler, such as
    a VerticalPanel. Try:
                                                                        [exBegin]
        |top panel l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        panel := VerticalPanelView 
                        origin:0.1 @ 0.0 
                        corner:0.9 @ 1.0 
                            in:top.

        panel horizontalLayout:#fit.
        panel verticalLayout:#center.

        l := Label in:panel.
        l borderWidth:1.
        l label:'default - centered'.

        l := Label in:panel.
        l borderWidth:1.
        l adjust:#left.
        l label:'left adjust'.

        l := Label in:panel.
        l borderWidth:1.
        l adjust:#right.
        l label:'right adjust'.

        top open
                                                                        [exEnd]


    labels with bitmaps or images:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:-1.
        l label:((Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') magnifiedBy:0.2 @ 0.2).
        l origin:50@100.

        top open
                                                                        [exEnd]


     that even works with #fit:
                                                                        [exBegin]
        |top l|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l adjust:#fit.
        l level:-1.
        l label:(Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif').
        l origin:0.2@0.2 corner:0.8@0.8.

        top open
                                                                        [exEnd]


     notice, that Buttons inherit from Label; thus:
                                                                        [exBegin]
        |top b|

        top := StandardSystemView new.
        top extent:(200 @ 200).

        b := Button in:top.
        b adjust:#fit.
        b label:(Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif').
        b origin:0.2@0.2 corner:0.8@0.8.
        b action:[Transcript showCR:'wow'].

        top open
                                                                        [exEnd]


     Channel operation (controlling fg, bg and labelText via ValueHolders)
     -----------------
                                                                        [exBegin]
        |top panel logoChannel fgChannel bgChannel l b|

        top := StandardSystemView new.
        top extent:(450 @ 200).

        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        l := Label in:panel.
        l level:-1.
        l label:'change my colors'.
        l origin:50@100.
        l sizeFixed:true.

        fgChannel := Color blue asValue.
        bgChannel := Color grey asValue.
        logoChannel := 'change me' asValue.

        b := Toggle label:'change fg' in:panel. b showLamp:false; onLevel:-2.
        b pressAction:[fgChannel value:Color red].
        b releaseAction:[fgChannel value:Color blue].

        b := Toggle label:'change bg' in:panel.
        b pressAction:[bgChannel value:Color yellow].
        b releaseAction:[bgChannel value:Color grey].

        b := Toggle label:'change text' in:panel.
        b pressAction:[logoChannel value:'wow'].
        b releaseAction:[logoChannel value:'not bad' ].

        l labelChannel:logoChannel.
        l foregroundChannel:fgChannel.
        l backgroundChannel:bgChannel.

        top open
                                                                        [exEnd]


       multiple labels on one channel:
                                                                        [exBegin]
        |l1 l2 b conv|

        l1 := Label label:'label1'.

        l2 := Label label:'label2'.

        b := Button label:'change'.
        conv := (ConvertedValue new
                            conversion:[:input | 
                                        input ifTrue:[
                                            Color red
                                        ] ifFalse:[
                                            Color blue
                                        ]]).
        conv value:false.

        b controller pressChannel:conv.
        l1 foregroundChannel:conv.
        l2 foregroundColor:Color white; backgroundChannel:conv.

        b open.
        l1 open.
        l2 open.
                                                                        [exEnd]
        

     MVC operation 
     -------------

       model provides the label):
       (have to use a plug to simulate a model which responds to
        the #someAspect message):
        |top l model|

        model := Plug new.
        model respondTo:#someAspect with:['models labelString'].

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l model:model; labelMessage:#someAspect.

        top open
        ...

        model changed:#someAspect
        ...


    concrete example (track a counters value):
      (here, the default aspect #value is used both to notify the label about
       changes and to acquire a new value from the model).
                                                                        [exBegin]
        |top l model|

        model := ValueHolder new.
        model value:'0'.
        [
            1 to:20 do:[:i |
                (Delay forSeconds:1) wait.
                model value:i printString
            ].
            top destroy
        ] fork.

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:-1.
        l model:model; labelMessage:#value.

        top open
                                                                        [exEnd]


      with a printConverter:
                                                                        [exBegin]
        |top l model|

        model := Date today asValue.
        [
            1 to:50 do:[:i |
                (Delay forSeconds:1) wait.
                model value:(model value addDays:1) 
            ].
            top destroy
        ] fork.

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label in:top.
        l level:-1.
        l converter:(PrintConverter new initForDate).
        l model:model; labelMessage:#value.

        top open
                                                                        [exEnd]


       model changes aspect after a while; two labels on the same model:
                                                                        [exBegin]
        |top l model|

        model := Plug new.
        model respondTo:#labelValue1 with:['models labelString1'].
        model respondTo:#labelValue2 with:['models labelString2'].

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label origin:0.0@0.0 corner:1.0@0.5 in:top.
        l model:model; aspect:#someAspect; labelMessage:#labelValue1.
        l := Label origin:0.0@0.5 corner:1.0@1.0 in:top.
        l model:model; aspect:#someAspect; labelMessage:#labelValue2.

        top open.

        (Delay forSeconds:5) wait.
        model respondTo:#labelValue1 with:['new string1'].
        model respondTo:#labelValue2 with:['new string2'].

        model changed:#someAspect 
                                                                        [exEnd]


      plugged MVC operation (getBlock returns the label): 
                                                                        [exBegin]
        |top l model|

        model := PluggableAdaptor new
                        getBlock:[:m | 'hello']
                        putBlock:nil
                        updateBlock:nil.

        top := StandardSystemView new.
        top extent:(200 @ 200).

        l := Label origin:0.0@0.0 corner:1.0@0.5 in:top.
        l model:model; labelMessage:#value.

        top open.
                                                                        [exEnd]


      use different label-selectors to access fields of a complex model:
                                                                        [exBegin]
        |top panel model|

        model := Plug new.
        model respondTo:#field1 with:['value1'].
        model respondTo:#field2 with:['value2'].
        model respondTo:#field3 with:['value3'].
        model respondTo:#field4 with:['value4'].

        top := StandardSystemView new.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel elementsChangeSize:true.

        panel addSubView:((Label on:model) labelMessage:#field1).
        panel addSubView:((Label on:model) labelMessage:#field2).
        panel addSubView:((Label on:model) labelMessage:#field3).
        panel addSubView:((Label on:model) labelMessage:#field4).

        top extent:(200 @ 200).
        top open.

        (Delay forSeconds:5) wait.

        model respondTo:#field2 with:['new value2'].
        model changed:#value  
                                                                        [exEnd]


      same as above, using default aspects in the label, and an adaptor
      to translate aspects:
                                                                        [exBegin]
        |top panel model v1|

        model := Plug new.
        model respondTo:#field1 with:[v1].
        model respondTo:#field1: with:[:arg | v1 := arg. model changed:#field1].
        model respondTo:#field2 with:['value2'].
        model respondTo:#field2: with:[:arg |].
        model respondTo:#field3 with:['value3'].
        model respondTo:#field3: with:[:arg |].
        model respondTo:#field4 with:['value4'].
        model respondTo:#field4: with:[:arg |].

        top := StandardSystemView new.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel elementsChangeSize:true.

        panel addSubView:((Label on:((AspectAdaptor subject:model) forAspect:#field1)) labelMessage:#value).
        panel addSubView:((Label on:((AspectAdaptor subject:model) forAspect:#field2)) labelMessage:#value).
        panel addSubView:((Label on:((AspectAdaptor subject:model) forAspect:#field3)) labelMessage:#value).
        panel addSubView:((Label on:((AspectAdaptor subject:model) forAspect:#field4)) labelMessage:#value).

        top extent:(200 @ 200).
        top open.

        (Delay forSeconds:5) wait.

        model field1:'new value1'.
                                                                        [exEnd]


      use an adapter to access fields of a complex model:
                                                                        [exBegin]
        |top l panel model|

        model := #('one' 'two' 'three') asValue.

        top := StandardSystemView new.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel elementsChangeSize:true.

        panel addSubView:((Label on:(ProtocolAdaptor
                                        subjectChannel:model
                                        accessPath:#(1))) labelMessage:#value).
        panel addSubView:((Label on:(ProtocolAdaptor
                                        subjectChannel:model
                                        accessPath:#(2))) labelMessage:#value).
        panel addSubView:((Label on:(ProtocolAdaptor
                                        subjectChannel:model
                                        accessPath:#(3))) labelMessage:#value).

        top extent:(200 @ 200).
        top open.

        (Delay forSeconds:5) wait.

        model value:#('oneone' 'twotwo' 'threethree').
                                                                        [exEnd]
"
! !

!Label class methodsFor:'instance creation'!

form:aForm
    "return a new Label showing a form.
     OBSOLETE: you should now use #label: for both text and bitmap labels."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #label:'.
    ^ (self onDevice:Screen current) label:aForm

    "Modified: 16.6.1997 / 11:47:38 / cg"
!

form:aForm in:aView
    "return a new Label showing a form.
     OBSOLETE: you should now use #label:in: for both text and bitmap labels."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #label:in:'.
    ^ (self in:aView) label:aForm

    "Modified: 16.6.1997 / 11:47:57 / cg"
! !

!Label class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ 16 @ 16

    "Modified: 22.4.1996 / 23:36:11 / cg"
!

defaultForegroundColor
    "return the default foregroundColor of my instances."

    ^ DefaultForegroundColor

!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'label.foregroundColor' #'label.backgroundColor'
                       #foregroundColor #backgroundColor
                       #'label.font')>

    DefaultForegroundColor := StyleSheet colorAt:#'label.foregroundColor'.
    DefaultForegroundColor isNil ifTrue:[
        "/ fallBack: comon value
        DefaultForegroundColor := StyleSheet colorAt:#'foregroundColor' default:Color black.
    ].
    DefaultBackgroundColor := StyleSheet colorAt:#'label.backgroundColor'.
    DefaultBackgroundColor isNil ifTrue:[
        "/ fallBack: comon value
        DefaultBackgroundColor := StyleSheet colorAt:#'backgroundColor'.
    ].
    DefaultFont := StyleSheet fontAt:#'label.font'.

    "
     self updateStyleCache
    "

    "Modified: / 31.10.1997 / 14:53:48 / cg"
! !

!Label class methodsFor:'menu specs'!

middleButtonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Label andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(Label middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Copy Label Text'
            itemValue: copyLabelText
            enabled: isTextLabel
          )
         )
        nil
        nil
      )
! !

!Label methodsFor:'accessing-channels'!

labelChannel
    "return the labelChannel - or nil"

    ^ labelChannel.

    "Created: / 16.12.1995 / 15:50:18 / cg"
    "Modified: / 31.10.1997 / 14:43:14 / cg"
!

labelChannel:aValueHolder
    "set the labelChannel - a valueHolder holding a string or image
     which is shown as my logo"

    |prev|

    prev := labelChannel.
    labelChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev.
    self getLabelFromLabelChannel.

    "Modified: / 31.10.1997 / 14:37:02 / cg"
! !

!Label methodsFor:'accessing-colors'!

backgroundColor
    "return the background color"

    ^ bgColor 
!

backgroundColor:aColor
    "set the background color"

    aColor ~~ bgColor ifTrue:[
        bgColor := aColor.
        bgColor notNil ifTrue:[
            bgColor := bgColor onDevice:device.
            self class == Label ifTrue:[
                super viewBackground:bgColor
            ].
        ].
        self invalidateRepairNow:true
    ]

    "Modified: / 15.1.1998 / 00:14:10 / stefan"
    "Modified: / 6.6.1998 / 20:01:56 / cg"
!

etchedForegroundColor
    "return the etched foreground color (or nil)"

    ^ etchedFgColor
!

etchedForegroundColor:aColor
    "set the etched foreground color"

    aColor ~~ etchedFgColor ifTrue:[
        etchedFgColor := aColor.
        etchedFgColor notNil ifTrue:[
            etchedFgColor := etchedFgColor onDevice:device.
        ].
        self invalidateRepairNow:true
    ].
!

foregroundColor
    "return the foreground color"

    ^ fgColor
!

foregroundColor:aColor
    "set the foreground color"

    aColor ~~ fgColor ifTrue:[
        fgColor := aColor onDevice:device.
        self invalidateRepairNow:true
    ].

    "Modified: / 15.1.1998 / 00:14:22 / stefan"
    "Modified: / 6.6.1998 / 20:02:02 / cg"
!

foregroundColor:fg backgroundColor:bg
    "set the colors to be used for drawing"

    (fgColor ~~ fg or:[bgColor ~~ bg]) ifTrue:[
        fgColor := fg onDevice:device.
        bgColor := bg onDevice:device.
        self class == Label ifTrue:[
            super viewBackground:bgColor
        ].
        self invalidateRepairNow:true
    ].

    "Modified: / 15.1.1998 / 00:14:36 / stefan"
    "Modified: / 6.6.1998 / 20:02:07 / cg"
!

viewBackground:aColor
    "for labels, the viewBackground is forced to be the same as
     the backgroundColor"

    super viewBackground:aColor.
    self class == Label ifTrue:[
        self backgroundColor:aColor
    ].

    "Modified: / 6.6.1998 / 20:02:22 / cg"
! !

!Label methodsFor:'accessing-contents'!

form:aForm
    "set the labels form; adjust extent if not already realized.
     OBSOLETE: you should now use #label: for both strings and images"

    <resource:#obsolete>

    self label:aForm
!

label
    "return the labels string or image"

    ^ logo
!

label:aStringOrFormOrImage
    "set the labelString or image; 
     adjust extent if not already realized and not fixedSize;
     also redraw"

    self label:aStringOrFormOrImage redraw:true

    "Modified: / 13-10-2010 / 12:17:36 / cg"
!

label:aStringOrFormOrImage redraw:doRedraw
    "set the labelString or image; adjust extent if not already realized and
     not fixedSize"

    |newLogo numberOfLines|

    newLogo := aStringOrFormOrImage.
    newLogo isString ifTrue:[
        numberOfLines := 1 + (newLogo occurrencesOf:(Character cr)).
        (numberOfLines ~~ 1) ifTrue:[
            newLogo := newLogo asStringCollection
        ]
    ] ifFalse:[
        newLogo isStringCollection ifTrue:[
            numberOfLines := newLogo size.
            (numberOfLines <= 1) ifTrue:[
                newLogo := newLogo asString
            ]
        ]
    ].

    (aStringOrFormOrImage ~~ logo) ifTrue:[
        "/
        "/ avoid recompute of size, if its an image with
        "/ the same size
        "/
        aStringOrFormOrImage isImageOrForm ifTrue:[
            logo notNil ifTrue:[
                logo isImageOrForm ifTrue:[
                    logo extent = aStringOrFormOrImage extent ifTrue:[
                        logo := aStringOrFormOrImage.
                        doRedraw ifTrue:[ self invalidateRepairNow:true ].
                        ^ self
                    ]
                ]
            ]
        ] ifFalse:[
            "/ any change ?
            (logo isString  
             and:[ newLogo isString
             and:[ newLogo = logo
             and:[ logo emphasis = newLogo emphasis]]]) ifTrue:[
                ^ self
            ]
        ].
        "/ do not check using #isString here;
        "/ we allow for non-strings to be used as logo as well (it must understand displayOn:).
        newLogo isNumber ifTrue:[
            logo := newLogo asString
        ] ifFalse:[
            logo := newLogo.
        ].
        doRedraw ifTrue:[ 
            self newLayout.
            self repairDamage 
        ].
    ]

    "Created: / 13-10-2010 / 12:16:34 / cg"
!

label:newLabel suppressResize:suppress
    "change the label and optionally suppress a resize operation"

    |wasFix|

    wasFix := fixSize. 
    suppress ifTrue:[
        fixSize := true.
    ].
    here label:newLabel.
    fixSize := wasFix

    "Modified: / 29.10.1997 / 15:50:01 / cg"
!

labelString:aString
    "for ST-80 compatibility: same as #label:
     set the label-string; adjust extent if not already realized and not fixedSize"

    self label:aString
!

labelWidth
    "return the logos width in pixels"

    ^ labelWidth
!

logo:something
    "set the labels form or string.
     OBSOLETE: the old version used #form: for images and #label: for strings.
               you should now use #label: for any."

    <resource:#obsolete>

    self label:something
! !

!Label methodsFor:'accessing-layout'!

adjust
    "return the adjust symbol. See #adjust: for an explanation."

    ^ adjust
!

adjust:how
    "set the adjust, how which must be one of

     #left        -> left adjust logo
     #right       -> right adjust logo
     #center      -> center logo
     #centerEach  -> like #center, but if its a multiline logo,
                     center each line individually.

     #centerRight -> center logo if it fits; 
                     BUT, if it does not fit, right adjust the logo
                     (use with filenames, where the interesting part is
                      at the right if the label is too small)

     #centerLeft  -> center logo if it fits; 
                     BUT, if it does not fit, left adjust the logo
                     (use with strings where the interesting part is at the
                      left if the label is too small)

     #leftRight   -> left adjust logo if it fits
                     BUT, if it does not fit, right adjust the logo
                     (use with filenames, where the interesting part is
                      at the right if the label is too small)

     #rightLeft   -> right adjust logo if it fits
                     BUT, if it does not fit, left adjust the logo
                     (use with strings where the interesting part is at the
                      left if the label is too small)

     See examples in the documentation category.
    "

    (adjust ~~ how) ifTrue:[
        adjust := how.
        self newLayout
    ]

    "Modified: 13.4.1996 / 11:17:58 / cg"
!

extraMarginForBorder
    "some (round) borders may need more space"
    
    ^ 0
!

font:aFont
    "set the font - if I'm not realized and not fixedSize, adjust my size.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    (aFont notNil and:[aFont ~~ gc font]) ifTrue:[
        super font:aFont.
        self newLayout
    ]

    "Modified: 22.5.1996 / 12:36:29 / cg"
!

horizontalSpace:aNumber
    "set the number of pixels by which the logo
     is horizontally inset from the border"

    hSpace := aNumber.
    self newLayout
!

layout:something
    "OBSOLETE compatibility interface. Will vanish.
     for protocol compatibility: alias for #adjust:.
     Please use #adjust:, since #layout: conflicts with a method
     in VW (which has a completely different meaning).
     In future versions of ST/X, #layout: will behave the VW way.
     In the meantime, try to figure out what is meant ... a kludge"

    <resource:#obsolete>

    something isSymbol ifFalse:[^ super layout:something].

    self obsoleteMethodWarning:'use #adjust:'.
    self adjust:something

    "Modified: 31.8.1995 / 23:08:13 / claus"
!

sizeFixed
    "return the fix-size attribute"

    ^ fixSize
!

sizeFixed:aBoolean
    "set/clear the fix-size attribute. 
     If true, the label will not change its size when the labelString/logo
     changes. 
     If false (the default), it will resize itself to make the logo fit."

    fixSize := aBoolean
!

verticalSpace:aNumber
    "set the number of pixels by which the logo
     is vertically inset from the border"

    vSpace := aNumber.
    self newLayout
! !

!Label methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    "see comment in View>>modelInterface"

    super addModelInterfaceTo:aDictionary.
    aDictionary at:#labelMessage put:labelMsg
!

converter:aConverter
    "set the printConverter;
     that one is asked to convert the models value to a printed
     representation (if non-nil). If nil, the model is supposed to
     return a string or bitmap image."

    converter := aConverter
!

labelMessage 
    "return the symbol used to acquire the labelString/image from the model
     when the aspect changes.
     The default is nil, which means: leave the label unchanged."

    ^ labelMsg
!

labelMessage:aSymbol 
    "set the symbol used to acquire the labelString/image from the model.
     The default is nil, which means: leave the label unchanged."

    labelMsg ~~ aSymbol ifTrue:[
        labelMsg := aSymbol.
        self getLabelFromModel
    ]
!

model:aModel
    super model:aModel.
    labelMsg notNil ifTrue:[
        self getLabelFromModel.
    ]
! !

!Label methodsFor:'change & update'!

getLabelFromLabelChannel
    self label:(labelChannel value).
!

update:something with:aParameter from:changedObject
    "the MVC way of changing the label ..."

    changedObject notNil ifTrue:[
        changedObject == labelChannel ifTrue:[
            self getLabelFromLabelChannel.
            ^ self
        ].

        changedObject == model ifTrue:[
            something == aspectMsg ifTrue:[
                self getLabelFromModel.
                ^ self.
            ]
        ].
    ].
    ^ super update:something with:aParameter from:changedObject

    "Modified: / 31.10.1997 / 14:32:02 / cg"
    "Modified: / 30.3.1999 / 13:57:26 / stefan"
! !

!Label methodsFor:'event handling'!

sizeChanged:how
    "sent whenever size is changed by someone else - recompute the
     logos position within the View."

    |prevX prevY|

    super sizeChanged:how.

    prevX := labelOriginX.
    prevY := labelOriginY.
    self computeLabelOrigin.
    shown ifTrue:[
        (adjust == #fit
        or:[labelOriginX ~~ prevX 
        or:[labelOriginY ~~ prevY 
        or:[how ~~ #smaller]]]) ifTrue:[
            "/ self clear.
            self invalidate.
            "/ self redrawEdges
        ]
    ]

    "Modified: / 28.4.1998 / 17:07:57 / cg"
! !

!Label methodsFor:'focus handling'!

wantsFocusWithButtonPress
    self class == Label ifTrue:[^ false].
    ^ super wantsFocusWithButtonPress


! !

!Label methodsFor:'initialization & release'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    fgColor := fgColor onDevice:device.
    bgColor := bgColor onDevice:device.

    "Created: / 13.1.1997 / 23:34:30 / cg"
    "Modified: / 15.1.1998 / 00:13:46 / stefan"
!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    DefaultBackgroundColor notNil ifTrue:[
        bgColor := DefaultBackgroundColor
    ] ifFalse:[
        bgColor := viewBackground.
    ].
    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor
    ] ifFalse:[
        fgColor := self blackColor.
    ].
    self class == Label ifTrue:[
        self borderWidth:0.
    ]

    "Modified: / 31-10-1997 / 14:57:23 / cg"
    "Modified (comment): / 05-10-2011 / 15:51:09 / az"
!

initialize
    |currentFont|

    super initialize.

    currentFont := gc font.
    self initialHeight:(currentFont height + currentFont descent).
    adjust := #center.
    labelOriginX := labelOriginY := 0.
    labelWidth := labelHeight := 0.
    logo := nil.
    fixSize := false.
    hSpace := ((self horizontalPixelPerMillimeter:0.5) max:2) rounded.
    vSpace := ((self verticalPixelPerMillimeter:0.5) max:2) rounded
!

recreate
    "after snapin or a migration, labels dimensions may have changed due to
     different font parameters"

    super recreate.
    self computeLabelSize.
    self computeLabelOrigin
!

release
    labelChannel notNil ifTrue:[
        labelChannel removeDependent:self.
        labelChannel := nil.
    ].
    self stopAnimation.
    super release
! !

!Label methodsFor:'label animation'!

animationDelay
    ^ 100 milliseconds
!

animationDelayTopOrBottom
    ^ 3 seconds
!

doAnimate
    "by slow scrolling the label, ensure that the label's text is readable.
     (stops when the cursor enters)"
    
    |animatorState offset atTop atBottom nextOffset nextMoveDirection nextAnimationDelay focusView|
    
    animatorState := self objectAttributeAt:#animator.
    animatorState isNil ifTrue:[^ self "I have been stopped in the meanwhile"].
    
    (gc drawableId isNil) ifTrue:[
        "/ view has been closed.
        self stopAnimation.
        ^ self
    ].
    logo == (animatorState logoShown) ifFalse:[
        "/ logo changed - stop it
        self stopAnimation.
        ^ self
    ].
    shown ifFalse:[
        "/ currently invisible (iconified/hidden)
        Processor addTimedBlock:(animatorState timedBlock) after:self animationDelayTopOrBottom.
        self computeLabelOrigin.
        ^ self.
    ].
    (controller notNil and:[controller entered]) ifTrue:[
        "/ pause animation
        Processor addTimedBlock:(animatorState timedBlock) after:0.5 seconds.
        ^ self.
    ].
    
    offset := animatorState nextOffset max:0.

    atTop := (offset <= 0).
    "/ Transcript printf:'labelHeight: %d offset: %d fA: %d fH: %d height: %d\n'
    "/              withAll:{ labelHeight . offset . self font ascent . self font height . height }.
    "/ (labelHeight - offset) is restHeight
    atBottom := (labelHeight - offset) < height.
    
    nextAnimationDelay := (atTop | atBottom)
                                ifTrue:[ self animationDelayTopOrBottom ]
                                ifFalse:[ self animationDelay ]. 

    nextMoveDirection := animatorState moveDirection.
    atTop ifTrue:[
        nextMoveDirection := #down
    ].
    
    atBottom ifTrue:[
        "/ after a longer delay, start again from top
        "/ nextOffset := 0.
        "/ nextMoveDirection := #down.
        "/ after a longer delay, start moving up again (fast)
        nextOffset := offset - 1.
        nextMoveDirection := #up.
    ] ifFalse:[
        nextMoveDirection == #down ifTrue:[
            nextOffset := offset + 1.
        ] ifFalse:[
            nextOffset := offset - 2.
            nextAnimationDelay := nextAnimationDelay / 4. "/ fast
        ].    
    ].

    "/ If I am not part of the active window, scroll back to top and wait longer...
    ((focusView := Display focusView) notNil
    and:[ focusView windowGroup == self windowGroup ]) ifFalse:[
        nextOffset := offset := 0.
        nextAnimationDelay := self animationDelayTopOrBottom.
        nextMoveDirection := #down.
    ].

    labelOriginY := offset negated.
    animatorState nextOffset:nextOffset.
    animatorState moveDirection:nextMoveDirection.

    self invalidate.
    Processor addTimedBlock:(animatorState timedBlock) after:nextAnimationDelay.
!

startAnimation
    "start an animator, which scrolls the label's text.
     (slow scroll which stops when the cursor enters)"
    
    |timedBlock|
    
    self enableEnterLeaveEvents.

    self stopAnimation.

    timedBlock := [ self doAnimate ].
    self 
        objectAttributeAt:#animator 
        put:(AnimatorState new 
                timedBlock:timedBlock 
                nextOffset:0 
                moveDirection:#down 
                logoShown:logo).
    Processor addTimedBlock:timedBlock after:(self animationDelay)

    "
     |l|
     l := Label new.
     l height:30.
     l sizeFixed:true.
     l label:'Line1
Line2
Line3
Line4'.
     l openAndWait.
     l startAnimation.
     Delay waitForSeconds:10.
     l stopAnimation.
    "
!

stopAnimation
    |animatorState timedBlock|
    
    animatorState := self removeObjectAttribute:#animator.
    animatorState notNil ifTrue:[
        timedBlock := animatorState timedBlock.
        Processor removeTimedBlock:timedBlock.

        "/ ensure that things are in their normal state again
        self computeLabelOrigin.
        shown ifTrue:[
            self invalidate.
        ].
    ].
! !

!Label methodsFor:'menu'!

copyLabelText
    |text|

    text := logo asString.
    self setClipboardText:text.
!

middleButtonMenu
    |m|

    m := super middleButtonMenu.
    m isNil ifTrue:[
        m := self yellowButtonMenu.
        m isNil ifTrue:[
            "/ not a customized menu
            self class == Label ifTrue:[
                m := self class middleButtonMenu
            ]
        ].
    ].
    ^ m
! !

!Label methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    self class == Label ifTrue:[
        ^ #Label
    ].
    ^ nil
! !

!Label methodsFor:'private'!

computeLabelOrigin
    "(re)compute the origin of the label whenever label, font or view-size changes"

    |x y a|

    labelHeight isNil ifTrue:[^ self].

    adjust == #fit ifTrue:[
        labelOriginX := labelOriginY := margin.
        ^ self
    ].

    "if it does not fit, should we make the origin visible,
     or the center ?
     (for text, the center seems better. 
      For images, I don't really know ...)
     The commented code below makes the origin visible
   "
"/    (labelHeight < height) ifTrue:[
"/        y := (height - labelHeight) // 2
"/    ] ifFalse:[
"/        y := 0
"/    ].

    "always center vertically"
    y := (height - labelHeight) // 2.

    labelOriginY := y.

    a := adjust.
    a == #centerEach ifTrue:[a := #center].

    (width < labelWidth) ifTrue:[
        ((a == #centerRight) or:[a == #leftRight]) ifTrue:[
            a := #right
        ] ifFalse:[
            ((a == #centerLeft) or:[a == #rightLeft]) ifTrue:[
                a := #left
            ].
        ]
    ] ifFalse:[
        ((a == #centerRight) or:[a == #centerLeft]) ifTrue:[
            a := #center
        ] ifFalse:[
            a == #leftRight ifTrue:[
                a := #left
            ] ifFalse:[
                a == #rightLeft ifTrue:[
                    a := #right
                ]
            ]
        ]
    ].

    (a == #center) ifTrue:[
        " center text/form in button "
        x := (width - labelWidth) // 2.
    ] ifFalse:[
        (a == #left) ifTrue:[
            x := margin
        ] ifFalse:[
            "/ #right
            x := width - labelWidth - margin - self extraMarginForBorder
        ]
    ].
    labelOriginX := x

    "Modified: 13.5.1996 / 10:55:17 / cg"
!

computeLabelSize
    "compute the extent needed to hold the logo"

    |ext|

    logo isNil ifTrue:[^ self].

    ext := self rawLabelSizeOf:logo.
    labelWidth := ext x.
    labelHeight := ext y.
!

getLabelFromModel
    "ask my model for the label to show.
     Here, we use labelMsg (instead of aspectMsg). 
     This allows multiple labels to react on the same aspect, 
     but show different labels when changed 
     (also, since labelMsg defaults to nil, constant labels
      which have a nil labelMsg will not try to acquire a labelString)."

    |val|

    (model notNil 
    and:[labelMsg notNil]) ifTrue:[
        val := model perform:labelMsg.
        converter notNil ifTrue:[
            val := converter printStringFor:val
        ].
        self label:val.
    ].
!

newLayout
    "recompute position/size after a change
     - helper for form:/font: etc."

    self computeLabelSize.

    fixSize ifFalse:[
        self resize.
    ] ifTrue:[
        self computeLabelOrigin.
    ].
    self invalidate

    "Modified: / 6.6.1998 / 19:23:45 / cg"
!

rawLabelSizeOf:aLogo
    "compute the extent needed to hold aLogo; aForm or aString"

    |logoUsed numberOfLines w h textHeight textWidth bounds|

    logoUsed := aLogo.
    aLogo isString ifTrue:[
        numberOfLines := 1 + (aLogo occurrencesOf:(Character cr)).
        (numberOfLines ~~ 1) ifTrue:[
            logoUsed := aLogo asStringCollection
        ]
    ] ifFalse:[
        (aLogo isStringCollection) ifTrue:[
            numberOfLines := aLogo size.
            (numberOfLines <= 1) ifTrue:[
                logoUsed := aLogo asString
            ]
        ]
    ].

    numberOfLines isNil ifTrue:[
        "logoUsed is neither a String nor a StringCollection"
        (logoUsed respondsTo:#preferredBounds) ifTrue:[
            bounds := logoUsed preferredBounds.
            w := bounds width.
            h := bounds height.
        ] ifFalse:[
            w := logoUsed widthOn:self.
            h := logoUsed heightOn:self.
        ].

"/        b := logoUsed bounds.
"/        labelWidth := b right.
"/        labelHeight := b bottom.
        logoUsed isImageOrForm ifFalse:[
            w := w + (hSpace * 2).
            h := h + (vSpace * 2).
        ].
        ^ w@h
    ].

    logoUsed isString ifTrue:[
        "/ a string or Text
        textHeight := logoUsed heightOn:self.
        textWidth := logoUsed widthOn:self.
    ] ifFalse:[
        "/ a StringCollection
        textHeight := (gc font height) * numberOfLines.

        textWidth := 0.
        logoUsed do:[:line |
            |thisWidth|

            line notNil ifTrue:[
                thisWidth := line asString widthOn:self.
                textWidth := textWidth max:thisWidth
            ]
        ].
    ].

    w := textWidth + (hSpace * 2).
    h := textHeight + (vSpace * 2).
    ^ w@h

    "Modified: / 05-12-2011 / 22:35:44 / cg"
! !

!Label methodsFor:'queries'!

isTextLabel
    ^ logo isString
!

preferredExtent
    "return my preferred extent - this is the minimum size I would like to have"

    |ext m2|

    "/ If I have an explicit preferredExtent...
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value...
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    "/ If I have a frozen extent value...
    fixSize ifTrue:[
        ^ self extent
    ].

    logo isNil ifTrue:[
        self label:''
    ].
    ext := self rawLabelSizeOf:logo.
    m2 := (margin + self extraMarginForBorder) * 2.
    ^ (m2 + ext x + hSpace) @ (m2 + vSpace + ext y)

    "Modified: 19.7.1996 / 20:44:41 / cg"
!

redrawsFull
    ^ true

    "Created: 7.2.1997 / 16:41:41 / cg"
! !

!Label methodsFor:'redrawing'!

clearInsideWith:bg
    |cutOff mustClear|

    cutOff := margin * 2.

    mustClear := true.

    (logo notNil and:[logo isImageOrForm]) ifTrue:[
        (labelOriginX == 0 and:[labelOriginY == 0]) ifTrue:[
            logo width >= (width - cutOff) ifTrue:[
                logo height >= (height - cutOff) ifTrue:[
                    "no need to clear before - avoid flicker"
                    mustClear := false
                ]
            ]
        ].
    ].

    mustClear ifTrue:[
        gc paint:bg.
        gc fillRectangleX:margin y:margin width:(width - cutOff) height:(height - cutOff).
    ].
!

drawImageLogo:imageOrForm x:x y:y opaque:opaque
    (opaque not or:[imageOrForm mask notNil]) ifTrue:[
        gc displayForm:imageOrForm x:x y:y 
    ] ifFalse:[
        gc displayOpaqueForm:imageOrForm x:x y:y 
    ]
!

drawOtherLogo:something x:x y:y opaque:opaque
    something displayOn:self x:x y:y opaque:opaque
!

drawStringLogo:aString x:x y:y
    gc displayString:aString x:x y:y
!

drawWin95FocusFrame
    |m1 m2|

    m1 := margin + 1.
    m2 := margin + margin + 2.
    self
        displayDottedRectangleX:m1
        y:m1
        width:(width - m2)
        height:(height - m2).

    "Created: / 17.9.1998 / 14:16:46 / cg"
    "Modified: / 29.4.1999 / 21:49:22 / cg"
!

drawWith:fg and:bg
    "redraw my label with fg/bg - this generic method is also used by subclasses
     (especially Button) to redraw the logo in different colors."

    self drawWith:fg and:bg clearInside:true etchedFg:etchedFgColor.
!

drawWith:fg and:bg clearInside:doClear etchedFg:etchedFg
    "redraw my label with fg/bg - this generic method is also used by subclasses
     (especially Button) to redraw the logo in different colors."

    |x y scaleH scaleV nW nH hSep vSep m2 ascent currentTransformation
     logoWidth logoHeight|

    doClear ifTrue:[self clearInsideWith:bg].

    gc paint:fg on:bg.
    logo notNil ifTrue:[
        m2 := margin * 2.
        hSep := hSpace*2.
        vSep := vSpace*2.

        x := labelOriginX.
        y := labelOriginY.

        logo isImageOrForm ifTrue:[
            logoWidth := logo width.
            logoHeight := logo height.
            ((logoWidth == 0) or:[logoHeight == 0]) ifTrue:[
                "/ do nothing; also avoids followup errors in the image creation and division by zero...
                ^ self.
            ].    
            adjust == #fit ifTrue:[
                "/
                "/ change scale to make the logo fit exactly
                "/
                scaleH := ((width - hSep) / logoWidth) asFloat.
                scaleV := ((height - vSep) / logoHeight) asFloat.
                scaleH <= 0 ifTrue:[scaleH := Float epsilon].
                scaleV <= 0 ifTrue:[scaleV := Float epsilon].
                self scale:(scaleH @ scaleV).
                x := currentTransformation applyInverseScaleX:x.
                y := currentTransformation applyInverseScaleY:y.
            ].

            logo := logo onDevice:device.
"/            self background:bg.
            self drawImageLogo:logo x:x y:y opaque:doClear.
        ] ifFalse:[
            x := x + hSpace.
            y := y + vSpace.

            level < 0 ifTrue:[
                x := x + 1.
                y := y + 1
            ].

            ascent := logo ascentOn:self.
            y := y + ascent.

            adjust == #fit ifTrue:[
                "/
                "/ change scale to make the logo fit exactly
                "/
                scaleH := ((width - m2 - hSep) / (labelWidth - hSpace)) asFloat.
                scaleV := ((height - m2 - vSep) / (labelHeight - vSpace)) asFloat.
                scaleH <= 0 ifTrue:[scaleH := Float epsilon].
                scaleV <= 0 ifTrue:[scaleV := Float epsilon].

                self scale:(scaleH min:scaleV).
                currentTransformation := gc transformation.
                x := currentTransformation applyInverseScaleX:x.
                ascent ~~ 0 ifTrue:[
                    y := y - ascent + (currentTransformation applyScaleY:ascent).
                ].
                y := currentTransformation applyInverseScaleY:y.
                scaleH < scaleV ifTrue:[
                    nH := labelHeight * scaleH.
                    "/ now, center vertically
                    y := y + ((height - nH - m2 - vSep) / scaleH / 2).
                ].
                scaleV < scaleH ifTrue:[
                    "/ now, center horizontally
                    nW := labelWidth * scaleV.
                    x := x + ((width - nW - m2 - hSep) / scaleV / 2) 
                ].
            ].

            logo isString ifTrue:[
"/                doClear ifTrue:[
"/                    self displayOpaqueString:logo x:x y:y
"/                ] ifFalse:[
"/                    self displayString:logo x:x y:y
"/                ]
                etchedFg notNil ifTrue:[
                    gc paint:etchedFg.
                    self drawStringLogo:logo x:x+1 y:y+1.
                    gc paint:fg.
                ].
                self drawStringLogo:logo x:x y:y
            ] ifFalse:[
                (logo isStringCollection) ifTrue:[
                    logo do:[ :line | 
                        |wThis str|

                        adjust == #centerEach ifTrue:[
                            wThis := line asString widthOn:self.
                            x := (width - wThis) // 2.
                        ].
                        str := line printString.
"/                        doClear ifTrue:[
"/                            self displayOpaqueString:str x:x y:y.
"/                        ] ifFalse:[
"/                            self displayString:str x:x y:y.
"/                        ].
                        etchedFg notNil ifTrue:[
                            gc paint:etchedFg.
                            self drawStringLogo:str x:x+1 y:y+1.
                            gc paint:fg.
                        ].
                        self drawStringLogo:str x:x y:y.
                        y := y + (gc font height)
                    ]
                ] ifFalse:[
                    "/ anything
                    self drawOtherLogo:logo x:x y:y opaque:doClear
                ]
            ].
        ].

        adjust == #fit ifTrue:[
            self scale:1
        ].
    ]

    "Modified: / 6.9.1998 / 22:35:53 / cg"
!

redraw
    "redraw my label"

    shown ifTrue:[
        self clear.
        self drawWith:fgColor and:bgColor
    ]
! !

!Label methodsFor:'resizing'!

forceResize
    "resize myself to make text fit into myself. Here, this is done even if
     fixSize is set."

    |prevFixSize|

    logo notNil ifTrue:[
        prevFixSize := fixSize.
        fixSize := false.
        self extent:self preferredExtent.
        self computeLabelOrigin.
        "/ this seems the only one which might depend on my contents.
        layout isLayout ifTrue:[
            layout isAlignmentOrigin ifTrue:[
                self containerChangedSize.
            ]
        ].
        fixSize := prevFixSize.
    ]
!

forceResizeHorizontally
    "resize myself horizontally to make text fit into myself. 
     Here, this is done even if fixSize is set."

    |prevFixSize|

    logo notNil ifTrue:[
        prevFixSize := fixSize.
        fixSize := false.
        self width:self preferredWidth.
        self computeLabelOrigin.
        fixSize := prevFixSize.
    ]
!

resize
    "resize myself to make text fit into myself.
     but only do so, if I am not fixedSize and I have NOT been 
     given a relative extent or an extend computation block."

    (logo notNil 
    and:[fixSize not
    and:[relativeExtent isNil
    and:[extentRule isNil
    and:[relativeCorner isNil 
    and:[cornerRule isNil]]]]]) ifTrue:[
	self forceResize
    ] ifFalse:[
	self computeLabelOrigin
    ]
! !

!Label::AnimatorState methodsFor:'accessing'!

logoShown
    ^ logoShown
!

moveDirection
    ^ moveDirection
!

moveDirection:something
    moveDirection := something.
!

nextOffset
    ^ nextOffset
!

nextOffset:something
    nextOffset := something.
!

pointerEntered
    ^ pointerEntered
!

pointerEntered:something
    pointerEntered := something.
!

timedBlock
    ^ timedBlock
!

timedBlock:timedBlockArg nextOffset:nextOffsetArg moveDirection:moveDirectionArg logoShown:logoShownArg
    timedBlock := timedBlockArg.
    nextOffset := nextOffsetArg.
    moveDirection := moveDirectionArg.
    logoShown := logoShownArg.
! !

!Label class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

