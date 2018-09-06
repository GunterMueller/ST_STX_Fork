"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaScriptEnvironment
	instanceVariableNames:'_theReceiver _functions _variables _outerEnvironment
		_isHTMLEnvironment _fallBackReceiver _outStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

Object subclass:#AppletObject
	instanceVariableNames:'window element view'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#AppletsObject
	instanceVariableNames:'window'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Smalltalk::Array variableSubclass:#Array
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Timestamp subclass:#Date
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#Document
	instanceVariableNames:'forms link anchor applets'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#DocumentObject
	instanceVariableNames:'images applets forms links anchors'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#FormFieldObject
	instanceVariableNames:'window element widget'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#FormObject
	instanceVariableNames:'window element'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#FormsObject
	instanceVariableNames:'window'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#HistoryObject
	instanceVariableNames:'historyItems window'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#Math
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Smalltalk::String variableByteSubclass:#String
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

Object subclass:#WindowObject
	instanceVariableNames:'view history location document frames'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaScriptEnvironment
!

!JavaScriptEnvironment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptEnvironment class methodsFor:'queries'!

scriptingNamespace
    "return a namespace, in which the scripts global variables
     are searched. Returning myself here, will make Math and Date
     visible (maybe more in the future)"

    ^ self

    "Created: / 17.5.1998 / 20:52:17 / cg"
! !

!JavaScriptEnvironment methodsFor:'accessing'!

__theReceiver
    "keep this for backward compatibility"

    ^ _theReceiver
!

_argVariables
    ^ nil
!

_beHTMLEnvironment
    _isHTMLEnvironment := true
!

_defineFunction:aFunction as:selector
    self _defineVariable:selector value:aFunction.
"/    _functions isNil ifTrue:[
"/        _functions := IdentityDictionary new
"/    ].
"/    _functions at:selector put:aFunction

    "Created: / 17.5.1998 / 00:34:41 / cg"
    "Modified: / 17.5.1998 / 21:28:13 / cg"
!

_defineVariable:name value:initialValue
    _variables isNil ifTrue:[
	_variables := IdentityDictionary new.
    ].
    _variables at:name asSymbol put:initialValue.
!

_functions
    <resource: #obsolete>
    self obsoleteMethodWarning:'obsolete - now _localVariables contains both functions and vars'.
    ^ _functions

    "Created: / 17.5.1998 / 00:02:36 / cg"
    "Modified: / 17.5.1998 / 21:28:17 / cg"
!

_functions:aDictionary
    <resource: #obsolete>
    self obsoleteMethodWarning:'obsolete - now _localVariables contains both functions and vars'.
    _functions := aDictionary

    "Created: / 17.5.1998 / 00:02:43 / cg"
    "Modified: / 17.5.1998 / 21:28:20 / cg"
!

_isHTMLEnvironment
    ^ _isHTMLEnvironment ? false
!

_localVariables
    ^ _variables
!

_localVariables:aDictionary
    _variables := aDictionary

    "Created: / 17.5.1998 / 00:04:16 / cg"
    "Modified: / 17.5.1998 / 21:28:33 / cg"
!

_outStream
    ^ _outStream
!

_outStream:aStream
    _outStream := aStream
!

_outerEnvironment
    ^ _outerEnvironment

    "Created: / 17.5.1998 / 00:02:49 / cg"
    "Modified: / 17.5.1998 / 21:28:23 / cg"
!

_outerEnvironment:anEnvironment
    _outerEnvironment := anEnvironment

    "Created: / 17.5.1998 / 00:02:52 / cg"
    "Modified: / 17.5.1998 / 21:28:27 / cg"
!

_theReceiver
    "keep this for backward compatibility"
    ^ _theReceiver
!

_theReceiver:anObject
    _theReceiver := anObject
!

_topEnvironment
    ^ _outerEnvironment isNil ifTrue:self ifFalse:[_outerEnvironment _topEnvironment]
!

isReturnedFrom:something
    "/ isReturnedFrom := something.
!

receiver
    ^ _theReceiver ? self
! !

!JavaScriptEnvironment methodsFor:'builtin functions'!

alert:msg
    self warn:('JavaScript alert:\\' withCRs , msg)

    "Created: / 16-05-1998 / 23:47:12 / cg"
    "Modified: / 19-05-2010 / 13:59:00 / cg"
!

confirm:msg
    ^ Dialog confirm:('JavaScript confirmation:\\' , msg) withCRs

    "Created: / 17.5.1998 / 23:39:59 / cg"
!

js_alert:msg
    Dialog warn:('JavaScript alert:\\' , msg) withCRs

    "Created: / 16.5.1998 / 23:47:12 / cg"
    "Modified: / 17.5.1998 / 23:40:10 / cg"
!

js_confirm:msg
    ^ Dialog confirm:('JavaScript confirmation:\\' , msg) withCRs

    "Created: / 17.5.1998 / 23:39:59 / cg"
!

print:msg
    (_outStream ? Transcript) show:msg
!

println
    (_outStream ? Transcript) cr
!

println:msg
    (_outStream ? Transcript) showCR:msg
! !

!JavaScriptEnvironment methodsFor:'error handling'!

doesNotUnderstand:aMessage
    |f|

    _functions notNil ifTrue:[
        f := _functions at:aMessage selector ifAbsent:nil.
        f notNil ifTrue:[
            ^ f valueWithReceiver:self arguments:(aMessage arguments)
        ]
    ].
    _fallBackReceiver notNil ifTrue:[
        ^ aMessage sendTo:_fallBackReceiver
    ].
    _outerEnvironment notNil ifTrue:[
        ^ aMessage sendTo:_outerEnvironment 
    ].
    Workspace notNil ifTrue:[
        f := Workspace workspaceVariableAt:(aMessage selector upTo:$:).
        f notNil ifTrue:[
            ^ f valueWithReceiver:self arguments:(aMessage arguments)
        ]
    ].
    
    ^ super doesNotUnderstand:aMessage

    "Created: / 17-05-1998 / 00:48:43 / cg"
    "Modified: / 22-10-2017 / 10:17:02 / cg"
! !

!JavaScriptEnvironment methodsFor:'expression evaluation'!

_evaluateAction:aString with:aComponentName
    "invoked when some HTML-element (such as a button) with an ONCLICK
     action is pressed. This is supposed to parse the passed string as
     an expression in my language (i.e. javaScript) and invoke that
     function."

    ErrorSignal handle:[:ex |
	Transcript showCR:('error in script: ' , ex description).
"/        self warn:'error in script: ' , ex description
	ex reject.
    ] do:[
	"/
	"/ here, we parse the string and evaluate it as an expression.
	"/

	JavaScriptParser evaluate:aString receiver:self in:self.
    ].

    "Modified: / 17.5.1998 / 21:24:35 / cg"
!

_readEvalFrom:inputStream to:outputStream errorTo:errorStream
    self _readEvalFrom:inputStream to:outputStream errorTo:errorStream print:false.

    "Created: / 13-07-2006 / 12:25:29 / cg"
!

_readEvalFrom:inputStream to:outputStream errorTo:errorStream print:doPrint
    [true] whileTrue:[
	ErrorSignal handle:[:ex |
	    errorStream showCR:('error in script: ' , ex description).
    "/        self warn:'error in script: ' , ex description
	    ex reject.
	] do:[
	    |line result|

	    "/
	    "/ here, we parse the string and evaluate it as an expression.
	    "/
	    outputStream nextPutAll:'js>'.
	    inputStream atEnd ifTrue:[^ self].

	    result := JavaScriptParser evaluate:inputStream receiver:self in:self.
"/            line := inputStream nextLine.
"/            result := JavaScriptParser evaluate:line receiver:self in:self.
	    doPrint ifTrue:[
		outputStream nextPutAll:result printString; cr.
	    ]
	].
    ]

    "Created: / 13-07-2006 / 12:22:47 / cg"
!

_readEvalPrintFrom:inputStream to:outputStream errorTo:errorStream
    self _readEvalFrom:inputStream to:outputStream errorTo:errorStream print:true.

    "Modified: / 13-07-2006 / 12:23:09 / cg"
!

exitWith:val
    ^ val
! !

!JavaScriptEnvironment methodsFor:'html-browser interaction'!

_start
    |f|

    "/ cannot do:
    "/      self perform:#js_start ifNotUnderstood:[].
    "/ because the ifNotUnderstood-part does not handle delegated notUnderstood

    _functions notNil ifTrue:[
	f := _functions at:#js_start ifAbsent:nil.
	f notNil ifTrue:[
	    f valueWithReceiver:self arguments:#()
	]
    ].
!

_stop
    |f|

    "/ cannot do:
    "/      self perform:#js_stop ifNotUnderstood:[].
    "/ because the ifNotUnderstood-part does not handle delegated notUnderstood

    _functions notNil ifTrue:[
	f := _functions at:#js_stop ifAbsent:nil.
	f notNil ifTrue:[
	    f valueWithReceiver:self arguments:#()
	]
    ].
! !

!JavaScriptEnvironment methodsFor:'queries'!

_isFunctionEnvironment
    ^ false
!

isInnerFunction
    ^ true
!

isInnerJavaScriptBlock
    ^ false
!

isJavaScriptClassNode
    ^ false
! !

!JavaScriptEnvironment methodsFor:'setup'!

_setupForWindow:aWindow
    |painter window history
     document formElements realForms formNames appletElements appletViews appletNames index|

    painter := aWindow painter.
"/    painter notNil ifTrue:[
"/        formElements := painter forms.
"/        index := 1.
"/        formNames :=
"/            formElements
"/                collect:[:aFormElement |
"/                            |nm|
"/
"/                            nm := aFormElement nameString.
"/                            nm isNil ifTrue:[
"/                                nm := 'form' , index printString
"/                            ].
"/                            index := index + 1.
"/                            nm
"/                        ].
"/        realForms :=
"/            formElements
"/                collect:[:aFormElement |
"/                            |widgets widgetNames widgetViews|
"/
"/                            widgets := aFormElement widgets select:[:wE | wE nameString notNil].
"/                            widgetNames := widgets collect:[:aWidgetElement | |nm|
"/                                                nm := aWidgetElement nameString.
"/                                                nm
"/                                           ].
"/                            widgetViews := widgets collect:[:aWidgetElement | aWidgetElement view].
"/                            Structure newWith:widgetNames values:widgetViews.
"/                        ].

"/        appletElements := aWindow painter applets.
"/        index := 1.
"/        appletNames :=
"/            appletElements
"/                collect:[:anAppletElement | |nm|
"/
"/                            nm := anAppletElement nameString.
"/                            nm isNil ifTrue:[
"/                                nm := 'form' , index printString
"/                            ].
"/                            index := index + 1.
"/                            nm
"/                        ].
"/        appletViews := appletElements collect:[:anAppletElement | anAppletElement view].
"/    ].

    document := DocumentObject new.
    document forms:(FormsObject new window:aWindow).
    document applets:(AppletsObject new window:aWindow).

"/    formNames notNil ifTrue:[
"/        formNames := formNames , (formNames collect:[:nm | 'js_' , nm]).
"/        realForms := realForms , realForms.
"/        document forms:(Structure newWith:formNames values:realForms).
"/    ].
"/    appletNames notNil ifTrue:[
"/        appletNames := appletNames , (appletNames collect:[:nm | 'js_' , nm]).
"/        appletViews := appletViews , appletViews.
"/        document applets:(Structure newWith:appletNames values:appletViews).
"/    ].

    window := WindowObject new.
    window location:(aWindow currentURL).
    window document:document.
    window view:aWindow.

    history := HistoryObject new.
    history window:window.
    history historyItems:(aWindow history).
    "/ window history:(aWindow history).
    window history:history.

    self _defineVariable:#window value:((JavaScriptVariable name:#window) value:window).

    _fallBackReceiver := window.

    "Created: / 21.9.1996 / 12:44:55 / cg"
    "Modified: / 17.5.1998 / 21:35:19 / cg"
! !

!JavaScriptEnvironment::AppletObject methodsFor:'accessing'!

window:windowArg element:elementArg view:viewArg
    "set instance variables (automatically generated)"

    window := windowArg.
    element := elementArg.
    view := viewArg.
! !

!JavaScriptEnvironment::AppletsObject methodsFor:'accessing'!

js_at:idx
    ^ self appletNamed:(idx + 1)
!

window:something
    window := something.
! !

!JavaScriptEnvironment::AppletsObject methodsFor:'caught accessors'!

appletNamed:anAppletNameOrIndex
    |appletElements index el|

    appletElements := window applets.

    anAppletNameOrIndex isNumber ifTrue:[
	index := anAppletNameOrIndex.
    ] ifFalse:[
	index := appletElements findFirst:[:el | el nameString = anAppletNameOrIndex].
	index == 0 ifTrue:[
	    Transcript show:'no applet named: '; showCR:anAppletNameOrIndex.
	    self halt.
	    ^ nil
	].
    ].
    el := appletElements at:index ifAbsent:nil.
    el isNil ifTrue:[
	Transcript showCR:'bad applet index'.
	self halt.
	^ nil
    ].

    ^ JavaScriptEnvironment::AppletObject new
	window:window
	element:el
	widget:(el view)
!

doesNotUnderstand:aMessage
    |sel nm applet|

    sel := aMessage selector.
    (sel startsWith:'js_') ifTrue:[
	"/ JS-access
	nm := sel copyFrom:4.
    ] ifFalse:[
	"/ ST-access
	nm := sel
    ].
    (applet := self appletNamed:nm) notNil ifTrue:[
	^ applet
    ].
    ^ super doesNotUnderstand:aMessage
! !

!JavaScriptEnvironment::Array methodsFor:'accessing'!

js_at:index
    "JS uses 0-based indexing"

    ^ super at:index+1

    "Created: / 7.11.1998 / 12:17:34 / cg"
!

js_at:index put:something
    "JS uses 0-based indexing"

    ^ super at:index+1 put:something

    "Created: / 7.11.1998 / 12:17:47 / cg"
! !

!JavaScriptEnvironment::Date methodsFor:'accessing'!

js_getDate
    "get the day of month"

    ^ self day

    "Modified: / 16.5.1998 / 20:32:25 / cg"
    "Created: / 16.5.1998 / 20:39:47 / cg"
!

js_getDay
    "get the day of week"

    ^ self dayInWeek

    "Modified: / 16.5.1998 / 20:32:25 / cg"
!

js_getHours
    ^ self hours

    "Created: / 16.5.1998 / 20:32:40 / cg"
!

js_getMinutes
    ^ self minutes

    "Created: / 16.5.1998 / 20:32:57 / cg"
!

js_getMonth
    ^ self month

    "Created: / 16.5.1998 / 20:31:57 / cg"
!

js_getSeconds
    ^ self seconds

    "Created: / 16.5.1998 / 20:33:08 / cg"
!

js_getTime
    ^ (Timestamp day:1 month:1 year:1970 hour:0 minutes:0 seconds:0) millisecondDeltaFrom:self

    "Created: / 16.5.1998 / 20:32:57 / cg"
    "Modified: / 16.5.1998 / 20:35:36 / cg"
!

js_getTimezoneOffset
    ^ self utcOffset

    "Modified: / 16.5.1998 / 20:42:05 / cg"
!

js_getYear
    ^ self year

    "Created: / 16.5.1998 / 20:31:32 / cg"
!

js_setDay:newDay
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:timeInfo year month:timeInfo month day:newDay
	hour:timeInfo hours minute:timeInfo minutes second:timeInfo seconds
	millisecond:timeInfo milliseconds

    "
	self now js_setDay:1
    "

    "Modified: / 16.5.1998 / 20:39:24 / cg"
!

js_setHour:newHour
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:timeInfo year month:timeInfo month day:timeInfo day
	hour:newHour minute:timeInfo minutes second:timeInfo seconds
	millisecond:timeInfo milliseconds

    "
	self now js_setHour:0
    "

    "Modified: / 16.5.1998 / 20:39:24 / cg"
    "Created: / 16.5.1998 / 20:40:11 / cg"
!

js_setMinutes:newMin
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:timeInfo year month:timeInfo month day:timeInfo day
	hour:timeInfo hours minute:newMin second:timeInfo seconds
	millisecond:timeInfo milliseconds

    "
	self now js_setMinutes:0
    "

    "Modified: / 16.5.1998 / 20:39:24 / cg"
    "Created: / 16.5.1998 / 20:40:33 / cg"
!

js_setMonth:newMonth
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:timeInfo year month:newMonth day:timeInfo day
	hour:timeInfo hours minute:timeInfo minutes second:timeInfo seconds
	millisecond:timeInfo milliseconds

    "
	self now js_setMonth:7
    "

    "Modified: / 16.5.1998 / 20:32:25 / cg"
    "Created: / 16.5.1998 / 20:39:04 / cg"
!

js_setSeconds:newSecs
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:timeInfo year month:timeInfo month day:timeInfo day
	hour:timeInfo hours minute:timeInfo minutes second:newSecs
	millisecond:timeInfo milliseconds

    "
	self now js_setSeconds:0
    "

    "Modified: / 16.5.1998 / 20:39:24 / cg"
    "Created: / 16.5.1998 / 20:40:55 / cg"
!

js_setYear:newYear
    |timeInfo|

    timeInfo := self timeInfo.
    self
	year:newYear month:timeInfo month day:timeInfo day
	hour:timeInfo hours minute:timeInfo minutes second:timeInfo seconds
	millisecond:timeInfo milliseconds

    "
	self now js_setYear:2000
    "

    "Modified: / 16.5.1998 / 20:38:39 / cg"
! !

!JavaScriptEnvironment::DocumentObject methodsFor:'accessing'!

anchors
    ^ anchors
!

anchors:something
    anchors := something.
!

applets
    ^ applets
!

applets:something
    applets := something.
!

forms
    ^ forms
!

forms:something
    forms := something.
!

images
    ^ images
!

images:something
    images := something.
!

js_anchors
    ^ anchors
!

js_applets
    ^ applets
!

js_forms
    ^ forms
!

js_images
    ^ images
!

js_links
    ^ links
!

links
    ^ links
!

links:something
    links := something.
! !

!JavaScriptEnvironment::FormFieldObject methodsFor:'accessing'!

js_value
    "my fields value"

    ^ widget model value
!

js_value:newValue
    "change my fields value"

    ^ widget model value:newValue
!

value
    self halt.
!

value:newValue
    self halt.
!

window:windowArg element:elementArg widget:widgetArg
    "set instance variables (automatically generated)"

    window := windowArg.
    element := elementArg.
    widget := widgetArg.
! !

!JavaScriptEnvironment::FormObject methodsFor:'accessing'!

window:windowArg element:elementArg
    "set instance variables (automatically generated)"

    window := windowArg.
    element := elementArg.
! !

!JavaScriptEnvironment::FormObject methodsFor:'caught accessors'!

doesNotUnderstand:aMessage
    |sel nm form|

    sel := aMessage selector.
    (sel startsWith:'js_') ifTrue:[
	"/ JS-access
	nm := sel copyFrom:4.
    ] ifFalse:[
	"/ ST-access
	nm := sel
    ].
    (form := self fieldNamed:nm) notNil ifTrue:[
	^ form
    ].

    ^ super doesNotUnderstand:aMessage
!

fieldNamed:aFieldNameOrIndex
    |fieldElements index el|

    fieldElements := element widgets.
    fieldElements isNil ifTrue:[^ nil].

    aFieldNameOrIndex isNumber ifTrue:[
	index := aFieldNameOrIndex.
    ] ifFalse:[
	index := fieldElements findFirst:[:el | el nameString = aFieldNameOrIndex].
	index == 0 ifTrue:[
	    Transcript show:'no field named: '; showCR:aFieldNameOrIndex.
	    self halt.
	    ^ nil
	].
    ].

    el := fieldElements at:index ifAbsent:nil.
    el isNil ifTrue:[
	Transcript showCR:'bad field index'.
	self halt.
	^ nil
    ].

    ^ JavaScriptEnvironment::FormFieldObject new
	window:window
	element:el
	widget:(el view)
! !

!JavaScriptEnvironment::FormsObject methodsFor:'accessing'!

js_at:idx
    ^ self formNamed:(idx + 1)
!

window:something
    window := something.
! !

!JavaScriptEnvironment::FormsObject methodsFor:'caught accessors'!

doesNotUnderstand:aMessage
    |sel nm form|

    sel := aMessage selector.
    (sel startsWith:'js_') ifTrue:[
	"/ JS-access
	nm := sel copyFrom:4.
    ] ifFalse:[
	"/ ST-access
	nm := sel
    ].
    (form := self formNamed:nm) notNil ifTrue:[
	^ form
    ].

    ^ super doesNotUnderstand:aMessage
!

formNamed:aFormNameOrIndex
    |formElements index el|

    formElements := window forms.
    formElements isNil ifTrue:[^ nil].

    aFormNameOrIndex isNumber ifTrue:[
	index := aFormNameOrIndex.
    ] ifFalse:[
	index := formElements findFirst:[:el | el nameString = aFormNameOrIndex].
	index == 0 ifTrue:[
	    Transcript show:'no form named: '; showCR:aFormNameOrIndex.
	    self halt.
	    ^ nil
	].
    ].
    el := formElements at:index ifAbsent:nil.
    el isNil ifTrue:[
	Transcript showCR:'bad form index'.
	self halt.
	^ nil
    ].

    ^ JavaScriptEnvironment::FormObject new
	window:window
	element:el
! !

!JavaScriptEnvironment::HistoryObject methodsFor:'accessing'!

historyItems
    "return the value of the instance variable 'historyItems' (automatically generated)"

    ^ historyItems
!

historyItems:something
    "set the value of the instance variable 'historyItems' (automatically generated)"

    historyItems := something.
!

window
    "return the value of the instance variable 'window' (automatically generated)"

    ^ window
!

window:something
    "set the value of the instance variable 'window' (automatically generated)"

    window := something.
! !

!JavaScriptEnvironment::HistoryObject methodsFor:'actions'!

back
    window view menu_back
!

js_back
    window view menu_back
! !

!JavaScriptEnvironment::Math class methodsFor:'constants'!

js_E
    ^ 2.7182818284590452354

    "Modified: / 16.5.1998 / 17:05:49 / cg"
!

js_LN10
    "lng e10"

    ^ 2.30258509299404568402

    "Created: / 16.5.1998 / 17:06:21 / cg"
    "Modified: / 16.5.1998 / 17:08:43 / cg"
!

js_LN2
    "lng e2"

    ^ 0.69314718055994530942

    "Created: / 16.5.1998 / 17:06:02 / cg"
    "Modified: / 16.5.1998 / 17:08:46 / cg"
!

js_LOG10E
    "log e10"

    ^ 0.43429448190325182765

    "Created: / 16.5.1998 / 17:06:40 / cg"
    "Modified: / 16.5.1998 / 17:08:26 / cg"
!

js_LOG2E
    "log e2"

    ^ 1.4426950408889634074

    "Created: / 16.5.1998 / 17:06:33 / cg"
    "Modified: / 16.5.1998 / 17:08:36 / cg"
!

js_PI
    "pi"

    ^ 3.14159265358979323846

    "Created: / 16.5.1998 / 17:06:49 / cg"
    "Modified: / 16.5.1998 / 17:08:55 / cg"
!

js_SQRT1_2
    "1/sqrt(2)"

    ^ 0.70710678118654752440

    "Modified: / 16.5.1998 / 17:07:55 / cg"
!

js_SQRT2
    "sqrt(2)"

    ^ 1.41421356237309504880

    "Created: / 16.5.1998 / 17:07:00 / cg"
    "Modified: / 16.5.1998 / 17:09:07 / cg"
! !

!JavaScriptEnvironment::Math class methodsFor:'misc functions'!

js_abs:aFloat
    ^ aFloat abs

    "Created: / 16.5.1998 / 17:09:28 / cg"
!

js_exp:aFloat
    ^ aFloat exp

    "Created: / 16.5.1998 / 17:09:54 / cg"
!

js_round:aFloat
    ^ aFloat rounded

    "Created: / 16.5.1998 / 20:29:51 / cg"
!

js_sqrt:aFloat
    ^ aFloat sqrt

    "Created: / 16.5.1998 / 17:10:03 / cg"
! !

!JavaScriptEnvironment::Math class methodsFor:'trigonometric functions'!

js_acos:aFloat
    ^ aFloat arcCos

    "Created: / 16.5.1998 / 17:09:37 / cg"
!

js_asin:aFloat
    ^ aFloat arcSin

    "Created: / 16.5.1998 / 17:09:43 / cg"
!

js_atan:aFloat
    ^ aFloat arcTan

    "Created: / 16.5.1998 / 17:04:13 / cg"
!

js_cos:aFloat
    ^ aFloat cos

    "Created: / 16.5.1998 / 17:04:01 / cg"
!

js_sin:aFloat
    ^ aFloat sin

    "Created: / 16.5.1998 / 17:03:58 / cg"
!

js_tan:aFloat
    ^ aFloat tan

    "Created: / 16.5.1998 / 17:04:03 / cg"
! !

!JavaScriptEnvironment::String methodsFor:'accessing'!

js_at:index
    "JS returns chars as strings and uses 0-based indexing"

    |newJS|

    newJS := self class basicNew:1.
    newJS at:1 put:(self at:index+1).
    ^ newJS

    "Created: / 16.5.1998 / 20:04:36 / cg"
    "Modified: / 16.5.1998 / 20:26:45 / cg"
!

js_at:index put:aCharacterOrString
    "JS returns chars as strings and uses 0-based indexing"

    aCharacterOrString isString ifTrue:[
	aCharacterOrString size == 1 ifTrue:[
	    self at:index+1 put:(aCharacterOrString at:1).
	    ^ aCharacterOrString
	]
    ].
    ^ self at:index+1 put:aCharacterOrString

    "Created: / 16.5.1998 / 20:04:41 / cg"
    "Modified: / 16.5.1998 / 20:26:56 / cg"
!

js_charAt:index
    " JS returns chars as strings and uses 0-based indexing"

    |newJS|

    newJS := self class basicNew:1.
    newJS at:1 put:(self at:index+1).
    ^ newJS
!

js_substring:idx1 _:idx2
    ^ self copyFrom:idx1+1 to:idx2+1

    "Created: / 16.5.1998 / 20:27:59 / cg"
! !

!JavaScriptEnvironment::String methodsFor:'concatenation'!

js_plus: aString         "/ that's #+
    ^ self , aString printString

    "Created: / 16-05-1998 / 18:47:08 / cg"
    "Modified (comment): / 12-06-2017 / 20:59:23 / cg"
! !

!JavaScriptEnvironment::String methodsFor:'conversion'!

js_toLowerCase
    ^ self asLowercase

    "Created: / 16.5.1998 / 19:03:43 / cg"
!

js_toUpperCase
    ^ self asUppercase

    "Created: / 16.5.1998 / 19:03:20 / cg"
! !

!JavaScriptEnvironment::String methodsFor:'queries'!

js_length
    ^ self size

    "Created: / 16.5.1998 / 19:06:17 / cg"
! !

!JavaScriptEnvironment::String methodsFor:'searching'!

js_indexOf:searchString
    ^ (self indexOfSubCollection:searchString) - 1 "/ JS indexing is 0-based

    "Created: / 16.5.1998 / 19:04:13 / cg"
    "Modified: / 16.5.1998 / 20:24:08 / cg"
!

js_indexOf:searchString _:startIndex
    ^ (self indexOfSubCollection:searchString startingAt:startIndex+1) - 1 "/ JS indexing is 0-based

    "Created: / 16.5.1998 / 19:04:22 / cg"
    "Modified: / 16.5.1998 / 20:25:10 / cg"
!

js_lastIndexOf:searchString
    ^ (self lastIndexOfSubCollection:searchString) - 1 "/ JS indexing is 0-based

    "Modified: / 16.5.1998 / 19:20:19 / cg"
    "Created: / 16.5.1998 / 20:23:38 / cg"
!

js_lastIndexOf:searchString _:startIndex
    ^ (self lastIndexOfSubCollection:searchString startingAt:startIndex+1) - 1 "/ JS indexing is 0-based

    "Created: / 16.5.1998 / 20:23:52 / cg"
    "Modified: / 16.5.1998 / 20:25:16 / cg"
! !

!JavaScriptEnvironment::WindowObject methodsFor:'accessing'!

document
    "return the value of the instance variable 'document' (automatically generated)"

    ^ document
!

document:something
    "set the value of the instance variable 'document' (automatically generated)"

    document := something.
!

frames
    "return the value of the instance variable 'frames' (automatically generated)"

    ^ frames
!

frames:something
    "set the value of the instance variable 'frames' (automatically generated)"

    frames := something.
!

history
    "return the value of the instance variable 'history' (automatically generated)"

    ^ history
!

history:something
    "set the value of the instance variable 'history' (automatically generated)"

    history := something.
!

js_document
    "return the value of the instance variable 'document' (automatically generated)"

    ^ document
!

js_frames
    "return the value of the instance variable 'frames' (automatically generated)"

    ^ frames
!

js_history
    "return the value of the instance variable 'history' (automatically generated)"

    ^ history
!

js_location
    "return the value of the instance variable 'location' (automatically generated)"

    ^ location
!

js_view
    "return the value of the instance variable 'view' (automatically generated)"

    ^ view
!

location
    "return the value of the instance variable 'location' (automatically generated)"

    ^ location
!

location:something
    "set the value of the instance variable 'location' (automatically generated)"

    location := something.
!

view
    "return the value of the instance variable 'view' (automatically generated)"

    ^ view
!

view:something
    "set the value of the instance variable 'view' (automatically generated)"

    view := something.
! !

!JavaScriptEnvironment::WindowObject methodsFor:'information'!

info:aMessage
    view showInfo:aMessage
!

js_info:aMessage
    view showInfo:aMessage
! !

!JavaScriptEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptEnvironment.st,v 1.48 2017-10-22 18:44:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptEnvironment.st,v 1.48 2017-10-22 18:44:31 cg Exp $'
! !

