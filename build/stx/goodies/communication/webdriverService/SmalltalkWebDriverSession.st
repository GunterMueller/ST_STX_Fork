"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/webdriverService' }"

"{ NameSpace: Smalltalk }"

HTTPSimpleJSONRestService subclass:#SmalltalkWebDriverSession
	instanceVariableNames:'interface sessionID application currentApplication
		didStartApplication windowHandles elementHandles nextHandleID'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Service'
!

!SmalltalkWebDriverSession class methodsFor:'documentation'!

documentation
"
    I represent a single session inside a webDriver.

    [author:]
        Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkWebDriverSession class methodsFor:'private'!

runningApplications
    |listOfApps|
    
    listOfApps :=
        WindowGroup scheduledWindowGroups
            select:[:each | each application notNil]
            thenCollect:[:each | each application].
    listOfApps := listOfApps asOrderedCollection.
    listOfApps sort:[:a :b |
                    (a class name < b class name)
                    or:[ a class name = b class name
                         and:[ a window label < b window label]]
               ].
    ^ listOfApps

    "Created: / 18-07-2018 / 11:46:06 / Claus Gittinger"
! !

!SmalltalkWebDriverSession methodsFor:'accessing'!

application
    ^ application
!

application:something
    application := something.
!

interface
    ^ interface
!

interface:something
    interface := something.
!

sessionID
    ^ sessionID
!

sessionID:something
    sessionID := something.
! !

!SmalltalkWebDriverSession methodsFor:'initialization & release'!

connectToApplicationByName:applicationName
    |app|

    didStartApplication := false.
    (app := self findApplicationByName:applicationName) notNil ifTrue:[
        application := app.
    ].
    ^ app

    "Created: / 21-07-2018 / 14:06:16 / Claus Gittinger"
!

findApplicationByName:applicationName
    |allApplications|

    allApplications := SmalltalkWebDriverSession runningApplications.
    allApplications do:[:eachApp |
        eachApp className = applicationName ifTrue:[^ eachApp].
    ].
    allApplications do:[:eachApp |
        eachApp class nameWithoutPrefix = applicationName ifTrue:[^ eachApp].
    ].
    allApplications do:[:eachApp |
        |window|
        (window := eachApp window) notNil ifTrue:[
            window label = applicationName ifTrue:[^ eachApp].
        ].
    ].
    ^ nil

    "
     self new findApplicationByName:'NewLauncher'
     self new findApplicationByName:'SmalltalkWebDriverInterface findApplicationByName: [modified]'
     self new findApplicationByName:'SmalltalkWebDriverInterface findApplicationByName:'
    "

    "Created: / 21-07-2018 / 14:05:22 / Claus Gittinger"
!

release
    didStartApplication == true ifTrue:[
        application closeRequest.
        application := nil.
        didStartApplication := false.
    ].

    "Created: / 21-07-2018 / 14:10:14 / Claus Gittinger"
!

startApplicationByName:applicationNameToStart
    |name class|

    (name := applicationNameToStart asSymbolIfInterned) isNil ifTrue:[^ nil].
    (class := Smalltalk at:name) isNil ifTrue:[^ nil].
    application := class new.
    application open.
    didStartApplication := true.
    ^ application

    "Created: / 21-07-2018 / 14:01:59 / Claus Gittinger"
! !

!SmalltalkWebDriverSession methodsFor:'private'!

addCommonAttributesOfView:aView to:attrs 
    |id|

    attrs add:(XML::Attribute name:'name' value:aView name asString).

    attrs add:(XML::Attribute name:'class' value:aView class name asString).
    attrs add:(XML::Attribute name:'enabled' value:aView enabled asString).
    attrs add:(XML::Attribute name:'visible' value:aView shown asString).
    attrs add:(XML::Attribute name:'x' value:aView origin x asString).
    attrs add:(XML::Attribute name:'y' value:aView origin y asString).
    attrs add:(XML::Attribute name:'width' value:aView width asString).
    attrs add:(XML::Attribute name:'height' value:aView height asString).

    id := aView automationUUID.
    id notNil ifTrue:[
        attrs add:(XML::Attribute name:'automationID' value:id asString).
    ].    
    id := aView instanceUUID.
    attrs add:(XML::Attribute name:'id' value:id asString).

    "Created: / 21-07-2018 / 18:28:30 / Claus Gittinger"
!

addXmlDomForChildrenOfView:aView to:viewNode 
    "/ subviews
    aView subViews asArray do:[:eachSubView |
        |subViewNode|

        subViewNode := self elementForView:eachSubView.
        viewNode addNode:subViewNode.
        self addXmlDomForChildrenOfView:eachSubView to:subViewNode
    ].

    "Created: / 18-07-2018 / 12:33:21 / Claus Gittinger"
    "Modified: / 21-07-2018 / 18:24:56 / Claus Gittinger"
!

addXmlDomForViewsOf:anApplication to:appNode 
    |wg w topViews|

    (wg := anApplication windowGroup) isNil ifTrue:[
        "/ already closed?
        (w := application window) isNil ifTrue:[
            topViews := #().
        ] ifFalse:[
            topViews := Array with:w.
        ].
    ] ifFalse:[
        topViews := wg topViews ? #().
    ].
    topViews do:[:eachTopView | 
        |viewNode id attrs|

        attrs := OrderedCollection new.
        self addCommonAttributesOfView:eachTopView to:attrs. 
        "/ add the topView's id
        
        viewNode := XML::Element tag:'Window' attributes:attrs.
        appNode addNode:viewNode.
        self addXmlDomForChildrenOfView:eachTopView to:viewNode
    ].

    "Created: / 18-07-2018 / 12:24:01 / Claus Gittinger"
    "Modified: / 21-07-2018 / 18:29:21 / Claus Gittinger"
!

elementForView:aView 
    |attrs label creator|

    attrs := OrderedCollection new. 
    self addCommonAttributesOfView:aView to:attrs.

    (aView isKindOf:Label) ifTrue:[
        label := aView label.
        label isString ifTrue:[
            attrs add:(XML::Attribute name:'label' value:label asString string).
        ] ifFalse:[
            label isNil ifTrue:[
                attrs add:(XML::Attribute name:'label' value:'').
            ] ifFalse:[
                label isImage ifTrue:[
                    (creator := Icon nameIfKnownIcon:label) notNil ifTrue:[
                        attrs add:(XML::Attribute name:'imageCreator' value:creator).
                    ].    
                ].    
            ].    
        ].    
    ].
    
    aView class == HorizontalPanelView ifTrue:[
        attrs add:(XML::Attribute name:'orientation' value:'horizontal').
        attrs add:(XML::Attribute name:'variable' value:'false').
        ^ XML::Element tag:'Panel' attributes:attrs.
    ]. 
    
    aView class == VerticalPanelView ifTrue:[
        attrs add:(XML::Attribute name:'orientation' value:'vertical').
        attrs add:(XML::Attribute name:'variable' value:'false').
        ^ XML::Element tag:'Panel' attributes:attrs.
    ].    

    aView class == VariableHorizontalPanel ifTrue:[
        attrs add:(XML::Attribute name:'orientation' value:'horizontal').
        attrs add:(XML::Attribute name:'variable' value:'true').
        ^ XML::Element tag:'Panel' attributes:attrs.
    ].    
    aView class == VariableVerticalPanel ifTrue:[
        attrs add:(XML::Attribute name:'orientation' value:'vertical').
        attrs add:(XML::Attribute name:'variable' value:'true').
        ^ XML::Element tag:'Panel' attributes:attrs.
    ].    
    ^ XML::Element tag:aView class nameWithoutPrefix attributes:attrs.

    "Created: / 21-07-2018 / 18:24:44 / Claus Gittinger"
!

elementWithID:id inApplication:anApplication
    anApplication allViewsDo:[:eachView |
        self halt.
    ].

    "Created: / 21-07-2018 / 19:13:07 / Claus Gittinger"
!

findElementById:locatorIdString
    |id uuid|

    id := (locatorIdString withoutPrefix:'"') withoutSuffix:'"'.
    id := (id withoutPrefix:'''') withoutSuffix:''''.
    uuid := UUID readFrom:id.

    (application ? currentApplication) windowGroup topViews do:[:eachWindow |
        eachWindow allSubViewsDo:[:eachView |
            eachView instanceUUID = uuid ifTrue:[
                ^ eachView.
            ]
        ]
    ].
    ^ nil

    "Created: / 22-07-2018 / 07:46:44 / Claus Gittinger"
!

findElementByLocationStrategy:locationStrategy value:locatorValue
    locationStrategy = 'id' ifTrue:[
        ^ self findElementById:locatorValue
    ].    
    locationStrategy = 'css selector' ifTrue:[
        ^ self findElementByCSSSelector:locatorValue
    ].    
    locationStrategy = 'link text' ifTrue:[
        ^ self findElementByLinkText:locatorValue
    ].    
    locationStrategy = 'partial link text' ifTrue:[
        ^ self findElementByPartialLinkText:locatorValue
    ].    
    locationStrategy = 'tag name' ifTrue:[
        ^ self findElementByTagName:locatorValue
    ].    
    locationStrategy = 'xpath' ifTrue:[
        ^ self findElementByXPath:locatorValue
    ].    
    
    self error:'unsupported location strategy'

    "Created: / 22-07-2018 / 08:27:04 / Claus Gittinger"
!

forwardToElement:aRequest path:path argument:arg 
    |element id|

    Transcript showCR:'per ELEMENT request'.

    id := path first asInteger.
    element := elementHandles at:id ifAbsent:[nil].
    element isNil ifTrue:[
        "/ search it...
        element := self elementWithID:id inApplication:application ? currentApplication.
        element isNil ifTrue:[
            aRequest reportNotFound:'no such element' moreInfo:nil.
            ^ nil.
        ].
        elementHandles at:id put:element
    ].

    ^ element 
        process:aRequest 
        method:aRequest method 
        relativePath:((path copyFrom:2) asStringWith:'/')
        argument:arg .

    "Created: / 22-07-2018 / 09:29:43 / Claus Gittinger"
!

xmlDom
    "get the dom for either all, or a single application"

    |node|
    
    application isNil ifTrue:[
        "/ return dom for ALL applications
        node := XML::Element tag:'STX'.
        self class runningApplications do:[:eachApp |
            node addNode:(self xmlDomForApplication:eachApp).
        ].
    ] ifFalse:[
        "/ return dom for single applications
        node := self xmlDomForApplication:application
    ].    
    ^ node

    "Created: / 18-07-2018 / 11:55:46 / Claus Gittinger"
    "Modified: / 21-07-2018 / 11:40:59 / Claus Gittinger"
!

xmlDomForApplication:anApplication
    "get the dom node for a single application"

    |node attrs|
     
    attrs := OrderedCollection new.
    attrs add:(XML::Attribute 
                name:'class' 
                value:anApplication class name). 
    node := XML::Element tag:'Application' attributes:attrs.
    self addXmlDomForViewsOf:anApplication to:node.
    ^ node

    "Created: / 18-07-2018 / 11:54:51 / Claus Gittinger"
! !

!SmalltalkWebDriverSession methodsFor:'service entries'!

back:aRequest 
    "ignored"

    <Rest: (POST 
                name: 'back' 
                return: 'Dictionary' 
                comment: 'ignored') >

    Logger info:'POST session/back'.
    Logger info:'<- nil'.
    ^ { 'value' -> nil }

    "Created: / 21-07-2018 / 12:50:07 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:01:29 / Claus Gittinger"
!

element:aRequest argument:arg path:path    
    <Rest: (* name: 'element' 
                 argument: 'Dictionary' 
                 return: 'Dictionary') >

    |locationStrategy locatorValue element|
    
    path notEmptyOrNil ifTrue:[
        ^ self forwardToElement:aRequest path:path argument:arg .
    ].

    (aRequest isPOST or:[aRequest isPUT]) ifFalse:[
        self error:'invalid request'
    ].
    
    Logger info:'POST session/id/element'.

    locationStrategy := arg at:'using'.
    locatorValue := arg at:'value'.
    element := self findElementByLocationStrategy:locationStrategy value:locatorValue.
self halt.    
    self error:'invalid request'

    "Created: / 22-07-2018 / 08:05:53 / Claus Gittinger"
    "Modified: / 22-07-2018 / 09:29:59 / Claus Gittinger"
!

elements:aRequest argument:arg path:path    
    <Rest: (* name: 'elements' 
                 argument: 'Dictionary' 
                 return: 'Dictionary') >

    |locationStrategy locatorValue elements|
    
    path notEmptyOrNil ifTrue:[
        self error:'invalid request'
    ].
    (aRequest isPOST or:[aRequest isPUT]) ifFalse:[
        self error:'invalid request'
    ].
    
    Logger info:'POST session/id/elements'.

    locationStrategy := arg at:'using'.
    locatorValue := arg at:'value'.
    elements := self findElementsByLocationStrategy:locationStrategy value:locatorValue.
self halt.    
    self error:'invalid request'

    "Created: / 22-07-2018 / 08:28:37 / Claus Gittinger"
!

forward:aRequest 
    "ignored"

    <Rest: (POST 
                name: 'forward' 
                return: 'Dictionary' 
                comment: 'ignored') >

    Logger info:'POST session/forward'.
    Logger info:'<- nil'.
    ^ { 'value' -> nil }

    "Created: / 21-07-2018 / 12:50:16 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:01:20 / Claus Gittinger"
!

refresh:aRequest 
    "ignored"

    <Rest: (POST 
                name: 'refresh' 
                return: 'Dictionary' 
                comment: 'ignored') >

    Logger info:'POST session/refresh'.
    Logger info:'<- nil'.
    ^ { 'value' -> nil }

    "Created: / 21-07-2018 / 12:50:53 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:01:10 / Claus Gittinger"
!

screenshot:aRequest argument:arg     
    "get a screenshot information
     see https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#screenshot"

    <Rest: (GET name: 'screenshot' 
                 argument: 'Dictionary' 
                 return: 'Dictionary' 
                 comment: 'return a screenshot.') >

    |img pngBytes|
    
    Logger info:'GET session/screenshot'.
    img := Image fromScreen.
    pngBytes := ByteArray streamContents:[:byteStream |
        PNGReader save:img onStream:byteStream
    ].
    ^ { 'value' -> (Base64Coder encode:pngBytes) }

    "Created: / 17-07-2018 / 00:58:58 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:12:07 / Claus Gittinger"
!

source:aRequest argument:arg     
    "get the pagesource
     see https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#source"

    <Rest: (GET name: 'source' 
                 argument: 'Dictionary' 
                 return: 'Dictionary' 
                 comment: 'return the pagesource as XML.') >

    |node|
    
    Logger info:'GET session/source'.
    node := self xmlDom.
    Logger info:'<- ',node printString.

    ^ Dictionary new
        at:'value' put:node printString;
        yourself.

    "Created: / 17-07-2018 / 00:59:46 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:00:55 / Claus Gittinger"
!

title:aRequest 
    "the title of the application's window;
     or a dummy title"

    <Rest: (GET 
                name: 'title' 
                return: 'Dictionary' 
                comment: 'title of application window') >

    |title app|
    
    Logger info:'GET session/title'.
    (app := application ? currentApplication) isNil ifTrue:[
        title := 'Smalltalk/X'.
    ] ifFalse:[
        title := app window label.
    ].    
    Logger info:'<- ',title.
    ^ { 'value' -> title }

    "Created: / 21-07-2018 / 12:51:46 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:00:47 / Claus Gittinger"
!

url:aRequest argument:arg 
    "the id of the current window"

    <Rest: (POST 
                name: 'url' 
                return: 'Dictionary' 
                comment: 'open a new url') >

    |appName|
    
    Logger info:'POST session/url'.
    didStartApplication ifTrue:[
        "/ close the previous app
        application closeRequest.
        application := nil.
        didStartApplication := false.
    ].    
    appName := arg at:'url' ifAbsent:nil.
    appName isNil ifTrue:[
        self error:'missing application name in url arg'
    ].
    (application := self startApplicationByName:appName) isNil ifTrue:[
        self error:'could not start application'
    ].        
    didStartApplication := true.
    ^ { 'value' -> true }

    "Created: / 21-07-2018 / 16:51:00 / Claus Gittinger"
!

window:aRequest 
    "the id of the current window"

    <Rest: (GET 
                name: 'window' 
                return: 'Dictionary' 
                comment: 'the id of the current window') >

    |id app|
    
    Logger info:'GET session/window'.
    (app := application ? currentApplication) isNil ifTrue:[
        id := '0'.
    ] ifFalse:[
        id := app window uuid printString.
    ].    
    Logger info:'<- ',id.
    ^ { 'value' -> id }

    "Created: / 21-07-2018 / 12:57:00 / Claus Gittinger"
    "Modified: / 21-07-2018 / 16:00:40 / Claus Gittinger"
! !

!SmalltalkWebDriverSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverSession.st,v 1.12 2018-07-22 09:54:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverSession.st,v 1.12 2018-07-22 09:54:36 cg Exp $'
! !

