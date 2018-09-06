"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Model subclass:#ApplicationModel
	instanceVariableNames:'builder resources keyboardMap device masterApplication'
	classVariableNames:'DefaultExtents DefaultLabels DefaultVisuals
		RecentlyOpenedApplications'
	poolDictionaries:''
	category:'Interface-Framework'
!

ApplicationModel class instanceVariableNames:'ClassResources defaultKeyboardMap'

"
 No other class instance variables are inherited by this class.
"
!

!ApplicationModel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
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
    Since many ST-80 classes are subclasses of ApplicationModel, this class
    is provided here to allow easier porting of ST-80 code.

    It does not (currently) provide all functionality and is NOT
    compatible to the corresponding ST80 class; therefore, manual
    changes have to be made to get those applications to run under ST/X.
    (but at least, this enables you to fileIn that code and have a superclass
     for them)

    As time goes by, ST/X applications are going to be converted to
    become subclasses of this abstract class - see Launcher for a
    first concrete example.


    ApplicationModel is prepared to build a view from a windowSpec, as
    created by the windowBuilder. If your subclass does not provide such
    a spec, you should at least redefine:

	#openInterface   - to create a topview and open it

    you may want to redefine:

	#closeRequest    - to catch window closing
	#focusSequence   - to define a sequence for focus-stepping


    Once the interfaceBuilder is finished & released, subclasses can
    alternatively provide the spec via a #windowSpec method.

    The classResources have been put into this class to allow ST/X
    applications (which used to be subclasses of StandardSystemView)
    to migrate smoothly into ApplicationModels (which is better design ...).


    [Instance variables:]
	resources    ResourcePack       language string translation

	builder      WindowBuilder      a builder who knows how to create
					a window hierarchy from a specification


    Notice: this class was implemented using protocol information
    from alpha testers and PD code - it may not be complete or compatible to
    the corresponding ST-80 class. If you encounter any incompatibilities,
    please forward a note to the ST/X team.


    [author:]
	Claus Gittinger

    [see also:]
	StandardSystemView
	WindowGroup DeviceWorkstation
"
!

howToDealWithMultipleApplicationInstances
"
    The following relates to StandAlone applications (i.e. compiled exe's) only.
    If the user attempts to open another of the applications documents (after the first instance
    of the application has already been opened), it is sometimes required to notify the first
    application about this and to ask it to open an extra window on the second-clicked document.
    In other words: to get another of the first instances' windows instead of opening a window
    by the second application.

    This is implemented via the following mechanism (see StandaloneStartup):
        the first application instance leaves the information about its existence somewhere
            (under win32: in the registry, the window-ID of its main window is remembered;
             under unix, its stored into a locked file).
        a mutex is created to prevent a race on this informationduring startup
            (under win32: a mutex proper; under unix, the above locked file will do)

    when the app is started the second time, it will not be able to acquire the mutex (and therefore
    knows, that its the second instance). It will then send an event-message (win32: via copyData;
    unix. via sendClientEvent), to the first instance and pass the fileName of the document which
    is to be opened. The first instance receives this event and opens another window for it.
    The second instance simply exits and stops execution.
    This guarantees that only one instance of an application is executing (if desired).

    The implementation is found in:
        StandaloneStartup:
            checkForAndExitIfAnotherApplicationInstanceIsRunning

        here:
            processOpenPathCommand:aFilename

    By default, the event is ignored - subclasses which want to support that behavior MUST
    redefine processOpenPathCommand: in ApplicationModel and also make sure that
    checkForAndExitIfAnotherApplicationInstanceIsRunning is called for in StandaloneStartup.

"
! !

!ApplicationModel class methodsFor:'initialization'!

initialize
    self == ApplicationModel ifTrue:[
	Smalltalk addDependent:self
    ].
    DefaultLabels isNil ifTrue:[
	DefaultLabels := IdentityDictionary new
    ].
    DefaultVisuals isNil ifTrue:[
	DefaultVisuals := IdentityDictionary new
    ].

    "
     ApplicationModel initialize
    "

    "Modified: 28.1.1997 / 12:31:38 / cg"
!

initializeDefaultKeyboardMap
    defaultKeyboardMap := KeyboardMap new.

    "Created: / 04-02-2017 / 22:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApplicationModel class methodsFor:'instance creation'!

new
    "return a new initialized instance"

    ^ self basicNew basicInitialize; initialize; yourself.
!

onDevice:aDevice
    "return a new initialized instance, which shall open its interface on aDevice."

    ^ (super basicNew basicInitialize setDevice:aDevice) initialize
! !

!ApplicationModel class methodsFor:'accessing'!

application
    ^ self

!

applicationName
    "the name as shown in an about box or in the deployed package.
     If there is an application definition in my package, ask that one.
     Otherwise, return my name."

    |prjDef|

    (prjDef := self projectDefinitionClass) notNil ifTrue:[
        prjDef isApplicationDefinition ifTrue:[
            ^ prjDef applicationName
       ]. 
    ].
    ^ self name
!

defaultKeyboardMap
    defaultKeyboardMap isNil ifTrue:[
        self initializeDefaultKeyboardMap.
    ].
    ^ defaultKeyboardMap

    "Created: / 04-02-2017 / 22:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApplicationModel class methodsFor:'active help'!

flyByHelpSpec
    "default is: take the oldStyle help-spec (should be redefined by concrete class)."

    ^ self helpSpec
!

helpSpec
    "default is: no help-spec (should be redefined by concrete class if help is wanted)."

    ^ IdentityDictionary new.
! !

!ApplicationModel class methodsFor:'bindings'!

actionFor:aKey
    "sent by the builder to ask for an actionBlock for
     a Button. The argument, aKey comes from an UI-spec
     for a buttons #action property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     actionBlocks from a Dictionary or whatever.
     Typically, a block is returned there."

    ^ nil


!

actionFor:aKey withValue:aValue
    "sent by the builder to ask for an actionBlock for
     a Button which passes a value to the actionMethod.
     The argument, aKey comes from an UI-spec
     for a buttons #action property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     actionBlocks from a Dictionary or whatever.
     Typically, a block is returned there."

    ^ nil


!

aspectFor:aKey
    "sent by the builder to ask for an aspect (a data model).
     The argument, aKey comes from an UI-spec
     for a components #aspect property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a valueHolder is returned there."

    ^ self perform:aKey

    "/ ^ nil

    "Modified: / 27.10.1997 / 13:43:12 / cg"
!

clientFor:aKey
    "sent by the builder to ask for an application provided
     subcanvas's application.
     The argument, aKey comes from an UI-spec
     for a subcanvas's #client property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     appModels from a Dictionary or whatever.
     Typically, an applicationModel is returned there."

    ^ nil

!

colorFor:aSymbol
    "sent by the builder to ask for an application provided color.
     The argument, aKey comes from an UI-spec
     for a widgets #*Color property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a color is returned there."

    (self respondsTo:aSymbol) ifTrue:[
	^ (self perform:aSymbol) value.
    ].

    "fall back to a possibly well defined color name"
    ^ Color name:aSymbol ifIllegal:nil.
!

componentFor:aKey
    "sent by the builder to ask for an application provided
     component.
     The argument, aKey comes from an UI-spec
     for a viewHolders #view property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a view is returned there."

    (self respondsTo:aKey) ifTrue:[
	^ self perform:aKey
    ].
    ^ nil
!

fontFor:aSymbol
    "sent by the builder to ask for an application provided font.
     The argument, aKey comes from an UI-spec
     for a widgets #*Font property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a font is returned there."

    (self respondsTo:aSymbol) ifTrue:[
	^ self perform:aSymbol.
    ].

"/    "fall back to a well defined font name"
"/    (Font respondsTo:aSymbol) ifTrue:[
"/        ^ Font perform:aSymbol.
"/    ].
    ^ nil
!

labelFor:aKey
    "sent by the builder to ask for an application provided
     label for a component.
     The argument, aKey comes from an UI-spec
     for a components #label property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     labels from a Dictionary or whatever.
     Typically, a string is returned there."

    |app|

    app := self application.
    app isNil ifTrue:[^ nil].
    (app respondsTo:aKey) ifTrue:[
	^ app perform:aKey
    ].
    ^ app labelAt:aKey ifAbsent:nil
!

listFor:aKey
    "sent by the builder to ask for an application provided
     holder for a list.
     The argument, aKey comes from an UI-spec
     for a listWidgets #list property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a list-holding model (SelectionInList) is returned there."

    |app|

    app := self application.
    app notNil ifTrue:[
	(app respondsTo:aKey) ifTrue:[
	    ^ app perform:aKey
	]
    ].
    ^ nil.

    "Modified: 4.3.1997 / 00:53:03 / cg"
!

menuFor:aKey
    "sent by the builder to ask for an application provided
     holder for a menu.
     The argument, aKey comes from an UI-spec
     for a widgets #menu property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a menu or a menu-holding valueHolder is returned there."

    ^ self application perform:aKey

!

specificationFor:aKey
    "sent by the builder to ask for an application provided
     specification for a subcanvas or subspecification.
     The argument, aKey comes from an UI-spec
     for a subcanvases #specification property (minorKey).
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     interfaceSpecifications from a Dictionary or whatever.
     Typically, an interfaceSpecification is returned there."

    ^ self
	specificationFor:aKey
	application:self
	onDevice:nil
!

specificationFor:aKey application:app onDevice:deviceOrNil
    "sent by the builder to ask for an application provided
     specification for a subcanvas or subspecification.
     The argument, aKey comes from an UI-spec
     for a subcanvases #specification property (minorKey).
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     interfaceSpecifications from a Dictionary or whatever.
     Typically, an interfaceSpecification is returned there."

    |displayDevice displayDeviceType modifiedKey appClass|

    "/ this code is so ugly...
    "/ translate the specs name, if the display device type is different
    "/ for example, if the type is pda, the xxxSpec_pda spec will be used.
    displayDevice := deviceOrNil.
    displayDevice isNil ifTrue:[
	displayDevice := Screen current.
	displayDevice isNil ifTrue:[
	    displayDevice := Screen default.
	]
    ].
    displayDevice notNil ifTrue:[
	displayDeviceType := displayDevice deviceType.
	displayDeviceType notNil ifTrue:[
	    modifiedKey := (aKey , '_' , displayDeviceType) asSymbolIfInterned.
	    modifiedKey notNil ifTrue:[
		(app respondsTo:modifiedKey) ifTrue:[
		    ^ app perform:modifiedKey
		].
		app isBehavior ifFalse:[
		    appClass := app application.
		    (appClass respondsTo:modifiedKey) ifTrue:[
			^ appClass perform:modifiedKey
		    ].
		].
	    ]
	]
    ].

    app isBehavior ifFalse:[
	(app respondsTo:aKey) ifTrue:[
	    ^ app perform:aKey
	].
	appClass := app application.
	(appClass respondsTo:aKey) ifTrue:[
	    ^ appClass perform:aKey
	].
	^ app masterApplication specificationFor:aKey
    ].

    ^ app perform:aKey

    "Modified: / 18-07-2011 / 09:28:15 / cg"
!

subApplicationFor:aKey
    "sent by subCanvas to ask for an application inside itself.
     The argument, aKey comes from a TabList-specs majorKey.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     an application from a Dictionary or whatever.
     Typically, an ApplicationModel subinstance is returned there."

    |app|

    app := self application.
    (app respondsTo:aKey) ifTrue:[
	^ app perform:aKey
    ].
    ^ nil
!

visualFor:aKey
    "sent by the builder to ask for an application provided
     image or element for a label.
     The argument, aKey comes from an UI-spec
     for a widgets #label property, if LabelIsImage is turned on.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     images from a Dictionary or whatever.
     Typically, an image is returned there."

    |app|

    app := self application.
    (app respondsTo:aKey) ifTrue:[
	^ app perform:aKey
    ].
    ^ app visualAt:aKey ifAbsent:nil
! !

!ApplicationModel class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "flush resources on language changes"

    something == #Language ifTrue:[
	self flushAllClassResources
    ]

    "Created: 15.6.1996 / 15:13:29 / cg"
! !

!ApplicationModel class methodsFor:'defaults'!

defaultExtentFor:anApplicationClass
    "return a default extent for an app-class or nil.
     If the user has the corresponding userPreference set,
     previous extents are remembered (at close time)
     and used as default for the next opening."
     
    DefaultExtents notNil ifTrue:[
        UserPreferences current shouldRememberLastExtent ifTrue:[
            ^ DefaultExtents at:anApplicationClass name ifAbsent:nil
        ].
        "/ flush remebered values
        DefaultExtents := nil.
    ].
    ^ nil.

    "Modified: / 31-07-2013 / 18:20:28 / cg"
!

defaultHttpServerPort
    "this is only used for web-applications"

    ^ HTTPServer defaultPort
!

defaultIcon
    "default is: no icon (should be redefined by concrete class if an icon is wanted)."

    ^ nil
!

defaultIconForAboutBox
    "the icon to be shown in my about-this-app dialog"

    ^ self defaultIcon
!

defaultServiceLinkName
    "old web server interface - remove me"

    <resource: #obsolete>
    ^ '/portal'
!

labelAt:aKey
    "default is: no label (could be redefined by concrete class )."

    ^ nil
!

labelAt:aKey ifAbsent:aBlock
    "default is: no label (could be redefined by concrete class )."

    ^ aBlock value
!

labelAt:aKey put:aValue
    "/ not yet implemented
!

labels
    "/ not yet implemented
    ^ nil
!

visualAt:aKey
    "default is: no visual (could be redefined by concrete class )."

    ^ nil
!

visualAt:aKey ifAbsent:aBlock
    "default is: no visual (could be redefined by concrete class )."

    ^ aBlock value
!

visualAt:aKey put:aValue
    "/ not yet implemented
!

visuals
    "/ not yet implemented
    ^ nil
! !

!ApplicationModel class methodsFor:'font helpers'!

resolveFont:aSelector
    "resolve the font descriobed by aSelector.
     Delegate to a WindowBuilder, whuch may forward to self fontOn:"

    |builder|

    builder := UIBuilder new isEditing:true; applicationClass:self.
    ^ builder resolveFont:aSelector.
! !

!ApplicationModel class methodsFor:'font specs'!

buttonFont
    "that is a symbolic font"
    
    <resource: #fontSpec>

    ^ Button defaultFont  
!

buttonFontBig
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self bigFontFor:(self buttonFont)
!

buttonFontSmall
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self smallFontFor:(self buttonFont)
!

inputFont
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ EditField defaultFont  
!

inputFontSmall
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self smallFontFor:(self inputFont)
!

labelFont
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ Label defaultFont  
!

labelFontBig
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self bigFontFor:(self labelFont)
!

labelFontSmall
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self smallFontFor:(self labelFont)
!

listFont
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ SelectionInListView defaultFont  
!

listFontSmall
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self smallFontFor:(self listFont)
!

menuFont
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ MenuView defaultFont  
!

textFont
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ TextView defaultFont  
!

textFontBig
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self bigFontFor:(self textFont)
!

textFontSmall
    "that is a symbolic font"

    <resource: #fontSpec>

    ^ self smallFontFor:(self textFont)
! !

!ApplicationModel class methodsFor:'help'!

aboutImage
    "bitmap image or nil for an about box for this application."

    ^ self defaultIcon
!

aboutThisApplicationLabel
    "label for an about box for this application."

    ^ 'About This Application'
!

aboutThisApplicationText
    "text for an about box for this application."

    |rev clsRev msg|

    rev := ''.

    (clsRev := self revision) notNil ifTrue: [rev := '  (rev: ', clsRev printString, ')'].
    msg := "'\' withCRs ," self applicationName allBold, rev.
    ^ msg

    "Created: / 13-11-2001 / 12:28:36 / cg"
!

documentationPath
    |packageDir|

    packageDir := Smalltalk getPackageDirectoryForPackage:(self package).
    packageDir isNil ifTrue:[
	packageDir := Filename defaultDirectory
    ].
    #(
	'documentation'
	'doc'
    ) do:[:subDir |
	(packageDir construct:subDir) exists ifTrue:[
	    ^ packageDir construct:subDir
	].
    ].
    ^ packageDir construct:'doc'
! !

!ApplicationModel class methodsFor:'history'!

forgetDefaultExtentFor:anApplicationClass
    "forget the remembered last extent for some application class.
     This is sent by the UIPainter, when a windowspec is saved,
     to bring up the application with its possibly changed default extent"

    DefaultExtents notNil ifTrue:[
        DefaultExtents removeKey:anApplicationClass name ifAbsent:[]
    ]
!

forgetRecentlyOpenedApplications
    RecentlyOpenedApplications := nil
!

recentlyOpenedApplications
    ^ RecentlyOpenedApplications ? #()
!

rememberRecentlyOpenedApplication
    "support for the launcher's ''open recent...'' menu function.
     It is questionable, if dialogs should also be remembered
     (although it might be convenient dor developers)"
    
    |myName|

    myName := self name.
    RecentlyOpenedApplications isNil ifTrue:[
        RecentlyOpenedApplications := OrderedCollection new.
    ].
    RecentlyOpenedApplications removeAndAddFirst:myName.
! !

!ApplicationModel class methodsFor:'private'!

bigFontFor:aFont
    |newSize|
    
    newSize := aFont size * 1.1.
    newSize := newSize ceiling asInteger.
    ^ aFont asSize:newSize.
!

selfResponsibleFor:aKey
    <resource: #obsolete>

    self obsoleteMethodWarning:'obsoleted for de-obfuscation'.
    ^ self respondsTo:aKey
!

smallFontFor:aFont
    |newSize|
    
    newSize := aFont size * 0.9.
    newSize := newSize floor asInteger.
    ^ aFont asSize:newSize.
! !

!ApplicationModel class methodsFor:'queries'!

interfaceSpecFor:aSelector
    "return an interface spec"

    |specOrSpecArray|

    specOrSpecArray := self application specificationFor:aSelector.
    specOrSpecArray isNil ifTrue:[^ nil].

    "/ app could already return a decoded spec
    specOrSpecArray isCollection ifFalse:[^ specOrSpecArray].

    "/ app returns a literal array
    MissingClassInLiteralArrayErrorSignal
        handle:[:ex |
            |clsInMyNamespace className|

            className := ex missingClassName.
            className isSymbol ifTrue:[
                "retry with my nameSpace"
                clsInMyNamespace := self nameSpace at:className.
                clsInMyNamespace notNil ifTrue:[ ex proceedWith:clsInMyNamespace].
            ].
            self warn:ex description.
            ex proceedWith:nil
        ]
        do:[
            ^ UISpecification from:specOrSpecArray
        ]

    "Modified: / 25-07-2010 / 10:36:53 / cg"
!

isAbstract
    ^ self == ApplicationModel

    "
     self isAbstract
    "

    "Created: / 02-03-2012 / 15:56:48 / cg"
!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    self isAbstract ifTrue:[^ false].
    ((self respondsTo:#open) or:[self class includesSelector:#openInterface]) ifFalse:[^ false].
"/    (self respondsTo:#windowSpec) ifFalse:[^ false].
    ^ true

    "Created: / 27-10-1997 / 16:38:02 / cg"
    "Modified: / 02-03-2012 / 15:57:02 / cg"
!

shouldRememberLastExtent
    "to be redefined by concrete applications:
     if true is answered, the application's extent is remembered on close
     and used as a default when opened the next time"

    ^ UserPreferences current shouldRememberLastExtent

    "Modified: / 31-07-2013 / 18:12:07 / cg"
! !

!ApplicationModel class methodsFor:'resources'!

classResources
    "if not already loaded, get the classes resourcePack and return it"

    ClassResources isNil ifTrue:[
	ClassResources := super classResources.
    ].
    ^ ClassResources
!

classResources:aResourcePack
    "allow setting of the classResources"

    ClassResources := aResourcePack
!

flushAllClassResources
    "flush all classes resource translations.
     Needed after a resource file / language setting has changed."

    ResourcePack flushCachedResourcePacks.
    self flushClassResources.
    self allSubclassesDo:[:aClass |
	aClass flushClassResources.
    ].

    WindowGroup scheduledWindowGroups
	do:[:wg |
	    |app|

	    (app := wg application) notNil ifTrue:[
		app initializeResources
	    ]
	]

    "Modified: / 13-09-2006 / 12:41:31 / cg"
!

flushClassResources
    "flush classes resource string translations.
     Needed whenever a resource file / language setting has changed"

    ClassResources := nil.
!

resources
    "return the application's resources -
     that's a ResourcePack containing national language strings"

    ^ self classResources

    "Created: / 19-05-1998 / 20:14:00 / cg"
    "Modified (comment): / 25-11-2016 / 15:26:14 / cg"
!

updateClassResources
    "update my classResources"

    ClassResources := nil.
    self classResources
! !

!ApplicationModel class methodsFor:'startup'!

open
    "create an instance of the application and open its view.
     Sorry, but for visualworks compatibility, the builder is returned,
     not the application instance"
     
    self rememberRecentlyOpenedApplication.
    ^ self new open

    "
     Launcher open
    "

    "Modified: 13.1.1997 / 20:54:50 / cg"
!

openAt:aLocation
    "create an instance of the application and open its view
     at some position."

    self rememberRecentlyOpenedApplication.
    ^ self new openAt:aLocation

    "Modified: 14.2.1997 / 20:28:41 / cg"
!

openDialogInterface:anInterfaceSymbol
    "create an instance of the application and open a view as
     specified by anInterfaceSymbol."

    ^ self openDialogInterface:anInterfaceSymbol withBindings:nil

    "Modified: 5.9.1995 / 17:54:50 / claus"
    "Created: 14.2.1997 / 20:33:10 / cg"
    "Modified: 28.2.1997 / 14:07:36 / cg"
!

openDialogInterface:anInterfaceSymbol withBindings:bindings
    "create an instance of the application and open a view as
     specified by anInterfaceSymbol."

    ^ self new openDialogInterface:anInterfaceSymbol withBindings:bindings

    "Modified: 5.9.1995 / 17:54:50 / claus"
    "Modified: 13.1.1997 / 20:55:02 / cg"
    "Created: 28.2.1997 / 14:07:24 / cg"
!

openDialogInterfaceSpec:anInterfaceSpec
    "create an instance of the application and open a view as
     specified by the given spec."

    ^ self new
	openDialogInterfaceSpec:anInterfaceSpec
	withBindings:nil
!

openDialogInterfaceSpec:anInterfaceSpec withBindings:bindings
    "create an instance of the application and open a view as
     specified by the given spec."

    ^ self new
	openDialogInterfaceSpec:anInterfaceSpec
	withBindings:bindings

    "Modified: 5.9.1995 / 17:54:50 / claus"
    "Modified: 13.1.1997 / 20:55:02 / cg"
    "Created: 28.2.1997 / 14:07:24 / cg"
!

openDialogSpec:aSpec
    "create an instance of the application and open a view as
     specified by aSpec."

    ^ self openDialogSpec:aSpec withBindings:nil

    "Modified: / 5.9.1995 / 17:54:50 / claus"
    "Modified: / 28.2.1997 / 14:07:36 / cg"
    "Created: / 20.5.1998 / 20:27:08 / cg"
!

openDialogSpec:aSpec withBindings:bindings
    "create an instance of the application and open a view as
     specified by the spec."

    ^ self new
	openDialogSpec:aSpec
	withBindings:bindings

    "Modified: / 5.9.1995 / 17:54:50 / claus"
    "Modified: / 13.1.1997 / 20:55:02 / cg"
    "Created: / 20.5.1998 / 20:26:37 / cg"
!

openInterface:anInterfaceSymbol
    "create an instance of the application and open a view as
     specified by anInterfaceSymbol."

    ^ self new openInterface:anInterfaceSymbol

    "Modified: 5.9.1995 / 17:54:50 / claus"
    "Modified: 13.1.1997 / 20:55:02 / cg"
!

openInterface:anInterfaceSymbol at:aPoint
    "create an instance of the application and open a view as
     specified by anInterfaceSymbol."

    ^ self new openInterface:anInterfaceSymbol at:aPoint

    "Modified: 14.2.1997 / 20:28:47 / cg"
!

openLauncherOnInitializedDisplayNamed:displayName
    |display app wsClass|

    wsClass := Smalltalk classNamed:#XWorkstation.
    wsClass isNil ifTrue:[
	self error:'XWorkstation has not been loaded'
    ].

    [
	display := wsClass newDispatchingFor:displayName.
	display deviceIOErrorSignal handlerBlock:[:ex |
	    'DeviceWorkstation [warning]: stop dispatch due to I/O error: ' errorPrint.
	    display errorPrintCR.
	    display brokenConnection.
	].

	Screen currentScreenQuerySignal answer:display do:[
	    Screen default isNil ifTrue:[
		Smalltalk secureFileIn:'keyboard.rc'.
		"/ Smalltalk secureFileIn:'display.rc'.
		display buttonTranslation:#(1 2 2 4 5 6 7).
		Screen default:display.
	    ].

	    app := NewLauncher new openAndWaitUntilVisible.
	    app windowGroup isNil ifTrue:[
		"terminate event processor on error"
		display stopDispatch.
		self error:'Cannot open'.
	    ] ifFalse:[
		app windowGroup process addExitAction:[
		    "reset the default display"
		    Screen default == display ifTrue:[
			Screen default:nil.
		    ].
		].
	    ].
	]
    ] on:Screen deviceOpenErrorSignal do:[:ex|
	self error:('Cannot connect to display: <1s><br><2s>'
			expandMacrosWith:displayName with:ex description).
    ].
    ^ app

    "Created: / 01-06-2010 / 11:23:52 / sr"
!

openModal
    "create an instance of the application and open its view modal"

    ^ self new openModal
!

openOn:anApplicationModel
    "send an open message to the argument, anApplicationModel.
     I don't really understand what this method is useful for ..."

    ^ anApplicationModel open

    "Modified: 13.1.1997 / 20:55:05 / cg"
!

openOnDevice:aDevice
    "create an instance of the application and open its view
     on ANOTHER device.
     For more info, read the document on multiple display
     support and the documentation of the DeviceWorkstation class."

    Screen currentScreenQuerySignal
	answer:aDevice
	do:[
	    ^ (self onDevice:aDevice) open
	]

    "
     Launcher openOnDevice:Display
    "

    "Modified: 13.1.1997 / 20:55:27 / cg"
!

openOnXScreenNamed:aScreenName
    "create an instance of the application and open its view
     on some X display screen. The argument aScreenName must be
     a valid x-display name (i.e. of the form '<host>:<screenNr>' as in 'foo:0').
     For more info, read the document on multiple display
     support and the documentation of the DeviceWorkstation class."

    |newDevice|

    (XWorkstation notNil and:[ XWorkstation isLoaded ]) ifFalse:[
        self warn:(self resources string:'Could not open display: %1 (no XWorkstation class)' with:aScreenName).
        ^ self
    ].    

    [
        newDevice := XWorkstation newDispatchingFor:aScreenName.
    ] on:Screen deviceOpenErrorSignal do:[:ex|
        self warn:(self resources string:'Could not open display: %1' with:aScreenName).
        ^ self
    ].
    ^ self openOnDevice:newDevice.

    "
     Launcher openOnXScreenNamed:'sgi:0'
     Launcher openOnXScreenNamed:'foo:0'
     NewLauncher openOnXScreenNamed:'dawn:0'
     NewLauncher openOnXScreenNamed:'bitsy:0'
     SystemBrowser openOnXScreenNamed:'dawn:0'
     SystemBrowser openOnXScreenNamed:'bitsy:0'
     SystemBrowser openOnXScreenNamed:'localhost:0'
    "

    "Modified: 13.1.1997 / 20:55:27 / cg"
!

openWithSpec:aSpecSymbol
    "ST80 compatibility:
     mhmh - what is the difference to #openInterface ?"

    ^ self openInterface:aSpecSymbol

    "Modified: 29.8.1997 / 01:16:52 / cg"
! !

!ApplicationModel class methodsFor:'startup-web applications'!

addRequiredForeignServicesTo:anHTTPServer
    "a hook to allow web apps to register additional services;
     typically: file services to deliver bitmaps"
     
    "/ intentionally left blank here;
    "/ to be redefined in subclasses
!

initialPageSpec
    "this is only required for web-applications"

    self subclassResponsibility
!

pageSpec
    "this is only used for web-applications"

    ^ self windowSpec
!

pageSpecs
    "this is only required for web-applications"

    self subclassResponsibility
!

startAsWebService
    "this is not yet a public interface. For internal exept use only.
     Start a web service for myself on the default webService linkURL.
     The webService will create new instances of me for incoming sessions.
     Answer the webService."

    ^ self startAsWebService:(self webServiceLinkName)

    "
     self startAsWebService
    "
!

startAsWebService:linkName
    "this is not yet a public interface. For internal exept use only.
     Start a web service for myself on link, an URL.
     The webService will create new instances of me for incoming sessions.
     Answer the webService.
     Start a HTTP server, if not already running"

    ^ HTTPPortalService
	startWithApplication:self
	link:linkName

    "
     self startAsWebService:'hello'
     UBS::UBSUsecase startAsWebService:'uuu'
    "
!

startAsWebService:linkName inServer:httpServer
    "this is not yet a public interface. For internal exept use only.
     Start a web service for myself on the default webService linkURL.
     The webService will create new instances of me for incoming sessions.
     Answer the webService.
     Start a HTTP server, if not already running"

    ^ HTTPPortalService
	startWithApplication:self
	inServer:httpServer
	link:linkName

    "
     self startAsWebService:'hello'
     UBS::UBSUsecase startAsWebService:'uuu'
    "
!

startAsWebService:linkName onPort:httpPort
    "this is not yet a public interface. For internal exept use only.
     Start a web service for myself on the default webService linkURL.
     The webService will create new instances of me for incoming sessions.
     Answer the webService.
     Start a HTTP server, if not already running"

    |service httpServer|
    
    service := HTTPPortalService
            startWithApplication:self
            inServer:(httpServer := HTTPServer serverOnPort:httpPort)
            link:linkName.
    self addRequiredForeignServicesTo:httpServer.
    ^ service.
    
    "
     self startAsWebService:'hello'
     UBS::UBSUsecase startAsWebService:'uuu'
    "
!

startAsWebService_old
    "this is not yet a public interface. For internal exept use only"

    |app|

    app := self basicNew.
    app initializeAsWebServiceOnWebDevice:(WebApplicationDevice new).
    app startAsWebService.
    ^ app

    "
     PortalTests::TestApplication1 startAsWebService
    "
!

startInPortalService:aPortalServiceOrSession
    "this is not yet a public interface. For internal exept use only"

    |app|

    app := self basicNew.
    app setDevice:(WebApplicationDevice new).
    app initialize.
    app initializeResources.
    app startInPortalService:aPortalServiceOrSession.
    ^ app.

    "
     PortalTests::TestApplication1
	startInPortalService:
	    (HTTPPortalService allInstances select:[:s | s httpServer port = 8080]) first
    "
!

webServiceLinkName
    "the link name, under which instances of myself are found in the httpServer"

    "/ typically, redefined as:
    ^ self name asLowercaseFirst
    "/ or
    "/  ^ 'ubs'

"/    ^ self subclassResponsibility
! !

!ApplicationModel methodsFor:'Compatibility-VW'!

mainWindow
    ^ self window topView.
! !

!ApplicationModel methodsFor:'accessing'!

application
    "application knows about interfaceSpecs, menuSpecs etc.
     Usually this is my class.
     This may be redefined in subclasses"

    ^ self class

    "Modified: / 5.2.1998 / 00:45:21 / stefan"
!

builder
    "return the applications builder; this one has more information
     about views, components etc."

    ^ builder
!

builder:aBuilder
    "set the applications builder. Normally, you should not set it
     directly, but depend on the default builder, as created when the application
     was created."

    builder := aBuilder
!

componentAt:name
    "return a component identified by its name"

    ^ self builder componentAt:name
!

device
    device isNil ifTrue:[
	self isWebService ifTrue:[
	    device := WebApplicationDevice new
	]
    ].
    ^ device
!

keyboardMap
    keyboardMap isNil ifTrue:[ 
        self initializeKeyboardMap.
    ].
    ^keyboardMap

    "
    WorkspaceApplication new open; yourself
    "

    "Created: / 02-02-2017 / 00:16:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2017 / 00:25:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

masterApplication
    "return the master application, in which I am embedded, or nil, if I am the topmost application.
     Useful for embedded sub applications to access outer windows and/or bindings from the master"

    ^ masterApplication
!

masterApplication:something
    "set the value of the instance variable 'masterApplication' (automatically generated)"

    something == self ifTrue:[
	self error:'an application cannot be its own masterApplication' mayProceed:true.
	^ self
    ].
    masterApplication := something.

    "/ ensure that the device is compatible.
    masterApplication notNil ifTrue:[
	device := masterApplication device.
    ].
!

resources
    "return the application's resources -
     that's a ResourcePack containing national language strings"

    resources isNil ifTrue:[
        masterApplication notNil ifTrue:[
            ^ masterApplication resources
        ]
    ].
    resources isNil ifTrue:[
        ^ ResourcePack new
    ].
    ^ resources

    "Modified (comment): / 25-11-2016 / 15:25:28 / cg"
!

resources:aResourcePack
    "set the application's resources - usually this is done automatically,
     except for manually built dialogs"

    resources := aResourcePack

    "Modified (comment): / 25-11-2016 / 15:25:36 / cg"
!

topMasterApplication
    "return the topmost master application. Useful when nested subapplications are used"

    masterApplication isNil ifTrue:[^ self].
    ^ masterApplication topMasterApplication
!

topView
    "SimpleView compatibility - answer my topWindow"

    ^ self window
!

window
    "return my topWindow - or nil, if I have no window (yet)"

    |win|

    builder isNil ifTrue:[^ nil].
    (win := builder window) notNil ifTrue:[
	^ win
    ].
    masterApplication notNil ifTrue:[
	masterApplication ~~ self ifTrue:[
	    "/ is that true ?
	    ^ masterApplication window
	]
    ].
    ^ nil.

    "Modified: / 18.9.1998 / 15:18:19 / cg"
!

window:aTopView
    "set my topWindow.
     As a side effect, this creates a dummy builder if non has yet
     been built. This prevents non-GUI-Painter apps from failing later,
     when the builder is accessed."

    builder isNil ifTrue:[
	self createBuilder
    ].
    builder window:aTopView

    "Created: 18.4.1996 / 14:55:26 / cg"
!

windowGroup
    "return the applications windowGroup"

    |w|

    builder notNil ifTrue:[
	(w := builder window) notNil ifTrue:[
	    ^ w windowGroup
	].
    ].
    masterApplication notNil ifTrue:[
	^ masterApplication windowGroup
    ].
    ^ nil

    "Modified: / 7.9.1998 / 23:37:00 / cg"
!

windowTitle:aString
    builder windowTitle:aString
! !

!ApplicationModel methodsFor:'binding access'!

actionFor:aKey
    "sent by the builder to ask for an actionBlock for
     a Button. The argument, aKey comes from an UI-spec
     for a buttons #action property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     actionBlocks from a Dictionary or whatever.
     Typically, a block is returned there."

    aKey isNil ifTrue:[ self error:'nil action key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication actionFor:aKey
	].
    ].

    ^ MessageSend receiver:self selector:aKey
    "/ ^ [self perform:aKey]   "/ could use:  MessageSend receiver:self selector:aKey

    "Modified: / 28-07-2010 / 11:56:49 / cg"
!

actionFor:aKey withValue:aValue
    "sent by the builder to ask for an actionBlock for
     a Button which passes a value.
     The argument, aKey comes from an UI-spec for a buttons #action property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     actionBlocks from a Dictionary or whatever.
     Typically, a block is returned there."

    aKey isNil ifTrue:[ self error:'nil action key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication actionFor:aKey withValue:aValue
	].
    ].

"/ sigh - too many senders of #isBlock around...
"/    ^ MessageSend receiver:self selector:aKey argument:aValue
     ^ [self perform:aKey with:aValue]

    "Modified: / 28-07-2010 / 11:56:42 / cg"
    "Modified: / 30-07-2010 / 10:40:35 / sr"
!

actionFor:aKey withValue:value1 withValue:value2
    "sent by the builder to ask for an actionBlock for a Button which passes two values.
     The argument, aKey comes from an UI-spec for a buttons #action property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     actionBlocks from a Dictionary or whatever.
     Typically, a block is returned there."

    aKey isNil ifTrue:[ self error:'nil action key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication actionFor:aKey withValue:value1 withValue:value2
	].
    ].
    ^ [self perform:aKey with:value1 with:value2]
!

aspectFor:aKey
    "sent by the builder to ask for an aspect (a data model).
     The argument, aKey comes from an UI-spec
     for a components #aspect property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a valueHolder is returned there."

    aKey isNil ifTrue:[ self error:'nil aspect key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication aspectFor:aKey
	].
    ].
    ^ self perform:aKey

    "Modified: / 18.6.1998 / 20:33:23 / cg"
!

aspectOrNil:aKey forSubApplication:aSubApp
    ^ nil
!

aspectValueFor:aspectKeySymbol
    "fetch an aspect's value
     same as (self aspectFor:aKey) value"

    ^ (self aspectFor:aspectKeySymbol) value
!

aspectValueOr:default for:aspectKeySymbol
    "common helper - fetches the aspect value; 
     if it is nil, return a default."

    ^ (self aspectValueFor:aspectKeySymbol) ? default
!

clientFor:aKey
    "sent by the builder to ask for an application provided
     subcanvas's application.
     The argument, aKey comes from an UI-spec
     for a subcanvas's #client property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     appModels from a Dictionary or whatever.
     Typically, an applicationModel is returned there."

    aKey isNil ifTrue:[ self error:'nil client key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication clientFor:aKey
	].
    ].
    ^ self perform:aKey

    "Modified: / 18.6.1998 / 20:33:30 / cg"
!

colorFor:aKey
    "sent by the builder to ask for an application provided color.
     The argument, aKey comes from an UI-spec
     for a widgets #*Color property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a color is returned there."

    (self respondsTo:aKey) ifTrue:[
	^ (self perform:aKey) value
    ].
    (self class respondsTo:aKey) ifTrue:[
	^ (self class perform:aKey) value
    ].
    masterApplication notNil ifTrue:[
	^ masterApplication colorFor:aKey
    ].
    ^ self class colorFor:aKey.
!

componentFor:aKey
    "sent by the builder to ask for an application provided
     component.
     The argument, aKey comes from an UI-spec
     for a viewHolders #view property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a view is returned there."

    aKey isNil ifTrue:[ self error:'nil component key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication componentFor:aKey
	].
    ].
    ^ self perform:aKey

    "Modified: / 18.6.1998 / 20:33:36 / cg"
!

fontFor:aKey
    "sent by the builder to ask for an application provided font.
     The argument, aKey comes from an UI-spec
     for a widgets #*Font property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a font is returned there.

     Use #resolveFont:, if you are not a builder!!"

    (self respondsTo:aKey) ifTrue:[
        ^ self perform:aKey
    ].
    (self class respondsTo:aKey) ifTrue:[
        ^ self class perform:aKey
    ].
    masterApplication notNil ifTrue:[
        ^ masterApplication fontFor:aKey
    ].
    ^ self class fontFor:aKey.
!

labelFor:aKey
    "sent by the builder to ask for an application provided
     label for a component.
     The argument, aKey comes from an UI-spec
     for a components #label property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     labels from a Dictionary or whatever.
     Typically, a string is returned there."

    aKey isNil ifTrue:[ self error:'nil label key' ].

    masterApplication notNil ifTrue:[
	(self respondsTo:aKey) ifFalse:[
	    ^ masterApplication labelFor:aKey
	].
    ].

    (self respondsTo:aKey) ifFalse:[
	(self class respondsTo:aKey) ifTrue:[
	    ^ self class perform:aKey
	].
    ].
    ^ self perform:aKey
!

listFor:aKey
    "sent by the builder to ask for an application provided
     holder for a list (for example, a popUpLists list).
     The argument, aKey comes from an UI-spec
     for a listWidgets #list property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a list-holding model (SelectionInList) is returned there.
     If the instance does not provide a value, a corresponding aspect
     is asked for. If that fails as well, the app class is asked as a last
     chance."

    |a|

    aKey isNil ifTrue:[ self error:'nil list key' ].

    a := self aspectFor:aKey.
    a notNil ifTrue:[
	^ a
    ].
    ^ self application listFor:aKey

    "Modified: / 18.6.1998 / 20:33:50 / cg"
!

menuFor:key
    "Sent by the builder to ask for an application provided
     holder for a menu. The argument, `key`, comes from an UI-spec
     for a widgets #menu property.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     holders from a Dictionary or whatever.
     Typically, a menu or a menu-holding valueHolder is returned there."

    | menu |

    key isNil ifTrue:[ self error:'nil menu key' ].

    "/ Ask myself first...
    (thisContext isRecursive not and:[ self respondsTo: key ]) ifTrue:[
	menu := self perform: key
    ] ifFalse:[
	"/ Ask my class...
	(self class respondsTo: key) ifTrue:[
	    menu := self class perform: key
	] ifFalse:[
	    "/ Ask masterApplication if any...
	    masterApplication notNil ifTrue:[
		menu := masterApplication menuFor: key
	    ].
	].
    ].

    "/ If the provided menu is a menu spec, create Menu from it...
    menu isArray ifTrue:[
	menu :=  Menu decodeFromLiteralArray: menu.
    ].
    ^ menu.

    "Modified: / 18-06-1998 / 20:33:56 / cg"
    "Modified: / 24-01-2014 / 09:46:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specificationFor:aKey
    "sent by the builder to ask for an application provided
     specification for a subcanvas or subspecification.
     The argument, aKey comes from an UI-spec
     for a subcanvases #specification property (minorKey).
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     interfaceSpecifications from a Dictionary or whatever.
     Typically, an interfaceSpecification is returned there."

    ^ self class
        specificationFor:aKey
        application:self
	onDevice:(device)
!

subApplicationFor:aKey
    "sent by subCanvas to ask for an application inside itself.
     The argument, aKey comes from a TabList-specs majorKey.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     an application from a Dictionary or whatever.
     Typically, an ApplicationModel subinstance is returned there."

     (self respondsTo:aKey) ifTrue:[
	 ^ self perform:aKey
     ].
     masterApplication notNil ifTrue:[
	 ^ masterApplication subApplicationFor:aKey
     ].
     ^ nil.
!

visualFor:aKey
    "sent by the builder to ask for an application provided
     image or element for a label.
     The argument, aKey comes from an UI-spec
     for a widgets #label property, if LabelIsImage is turned on.
     Here, a corresponding message is sent to myself,
     which ought to be defined in the application subclass.
     Alternatively, a subclass may redefine this method, to provide
     images from a Dictionary or whatever.
     Typically, an image is returned there."

    ^ self application visualFor:aKey
! !

!ApplicationModel methodsFor:'building'!

allButOpen
    "create my views from the windowSpec, but do not open the main window."

    ^ self allButOpenInterface:(self defaultWindowSpecName).

    "Modified: / 19.6.1998 / 01:48:26 / cg"
!

allButOpenFrom:aSpec
    "create my views but do not open the main window.
     The argument is a spec which defines the interface."

    |window|

    window notNil ifTrue:[
	self error:'building twice (window is already built) ?' mayProceed:true.
    ].

"/ DISABLED; see comment in basicInitialize
"/
"/    "
"/     here, we kludge a bit: up to now, the builder was an
"/     instance of the no-op WindowBuilder. Now, it becomes
"/     a UIBuilder ....
"/     This allows for ApplicationModels without a UIBuilder
"/     if not needed.
"/    "
"/    realBuilder := UIBuilder new.
"/    builder := realBuilder.
"/    builder application:self.
"/    builder bindings:builder bindings.

    builder isNil ifTrue:[
	self createBuilder.
    ].

    self preBuildWith:builder.
    builder buildWindowFromSpec:aSpec.
    window := builder window.

    window model:self.
    (window respondsTo:#application:) ifTrue:[
	window application:self.
    ].

    self showingHelp ifTrue: [ActiveHelp startFor: self].
    self postBuildWith:builder.

    "Modified: / 19.6.1998 / 03:35:31 / cg"
!

allButOpenInterface:aSymbol
    "create my views but do not open the main window.
     The argument specifies a selector of a method,
     which when sent to myself should return a spec.
     Notice, this returns the windowBuilder."

    self allButOpenFrom:(self interfaceSpecFor:aSymbol).
    ^ builder

    "Modified: / 19.6.1998 / 01:48:26 / cg"
!

buildSpec:specToBuild asSubCanvasWithBuilder:aBuilder
    "build a subcanvases spec into aSubcanvas"

    |sameApp prevSpec prevSource|

    aBuilder notNil ifTrue:[
	prevSpec := aBuilder spec.
	prevSource := aBuilder source.
    ].

    builder isNil ifTrue:[
	builder := aBuilder.
	aBuilder isNil ifTrue:[
	    self createBuilder
	]
    ].

    aBuilder source:self.

    "/ if the subcanvases appModel is NOT the same as
    "/ the topApp, it must be pre/post-built.
    "/ Otherwise, we invoke pre/post-builtAsSubcanvas.
    "/ which provides a hook for redefinition in concrete appModels.
    "/ This avoids invoking pre/postBuild twice for subCanvases which
    "/ have the topApp as appModel.

    sameApp := aBuilder application == aBuilder window topView application.
    sameApp ifTrue:[
	self preBuildAsSubcanvasWith:aBuilder.
    ] ifFalse:[
	self preBuildWith:aBuilder.
    ].

    aBuilder buildFromSpec:specToBuild.

    sameApp ifTrue:[
	self postBuildAsSubcanvasWith:aBuilder.
    ] ifFalse:[
	self postBuildWith:aBuilder.
    ].

    prevSpec notNil ifTrue:[
	"/ restore state in builder if original builder was used
	aBuilder spec:prevSpec.
    ].
    prevSource notNil ifTrue:[
	"/ restore state in builder if original builder was used
	aBuilder source:prevSource.
    ].

    ^ aBuilder

    "Created: / 18-06-1998 / 20:08:45 / cg"
    "Modified: / 27-10-2006 / 11:45:25 / cg"
!

buildSubCanvas:spec withBuilder:aBuilder
    "build a subcanvases' spec into aSubcanvas"

    self buildSubCanvas:spec withMenu:false withBuilder:aBuilder
!

buildSubCanvas:spec withMenu:withMenuBoolean withBuilder:aBuilder
    "build a subcanvases' spec into aSubcanvas"

    |specToBuild|

    specToBuild := spec.
    withMenuBoolean ifFalse:[
	"/ subapps should not build the menu and other fullSpec stuff.
	spec class == FullSpec ifTrue:[
	    specToBuild := spec component.
	]
    ].
    self buildSpec:specToBuild asSubCanvasWithBuilder:aBuilder
! !

!ApplicationModel methodsFor:'component manipulations'!

components:aSymbolOrArray do:aBlock
    "evaluate aBlock for all components listed aSymbolOrArray."

    |coll|

    aSymbolOrArray isSymbol ifTrue:[
	"/ a single components name
	coll := Array with:aSymbolOrArray
    ] ifFalse:[
	coll := aSymbolOrArray
    ].
    coll do:[:aSymbol |
	|component|

	(component := self componentFor:aSymbol) isNil ifFalse:[
	    aBlock value:component
	]
    ]

    "Modified: 26.3.1997 / 16:23:14 / cg"
!

disable:aSymbolOrArray
    "disable the components whose id's are aSymbolOrArray."

    self components:aSymbolOrArray do:[:comp | comp disable]

    "Modified: 14.2.1997 / 17:32:09 / cg"
!

enable:aSymbolOrArray
    "enables the component(s) identified by aSymbolOrArray."

    self components:aSymbolOrArray do:[:comp | comp enable]

    "Modified: 14.2.1997 / 17:32:19 / cg"
!

invalidate:aSymbolOrArray
    "invalidates the component(s) identified by aSymbolOrArray."

    self components:aSymbolOrArray do:[:comp | comp invalidate]

    "Modified: 14.2.1997 / 17:32:28 / cg"
!

makeInvisible:aSymbolOrArray
    "makes the components whose id's are aSymbolOrArray invisible"

    self components:aSymbolOrArray do:[:comp | comp beInvisible]

    "Modified: 14.2.1997 / 17:32:42 / cg"
!

makeReadOnly:aSymbolOrArray
    "make all components identified by aSymbolOrArray read only
     (for editText components)."

    self components:aSymbolOrArray do:[:comp | comp readOnly:true]

    "Modified: 14.2.1997 / 17:36:22 / cg"
!

makeVisible:aSymbolOrArray
    "makes the components whose id's are aSymbolOrArray visible"

    self components:aSymbolOrArray do:[:comp | comp beVisible]

    "Modified: 14.2.1997 / 17:32:52 / cg"
!

makeWritable:aSymbolOrArray
    "make all components identified by aSymbolOrArray writable
     (for editText components)."

    self components:aSymbolOrArray do:[:comp | comp readOnly:false]

    "Created: 14.2.1997 / 17:36:17 / cg"
! !

!ApplicationModel methodsFor:'copying'!

postCopy
    builder := device := nil.

    "Created: / 19.4.1998 / 11:44:44 / cg"
!

postDeepCopy
    builder := device := nil.

    "Created: / 19.4.1998 / 11:44:44 / cg"
! !


!ApplicationModel methodsFor:'delayed actions (enqueue)'!

delayedUpdate:something with:aParameter from:changedObject
    "support for delayed updates -
     subclasses which invoke #enqueueDelayedUpdate:with:from: (from #update:with:from:)
     must also redefine this method, and perform the actual update there."

    ^ self
!

enqueueDelayedAction:aBlock
    "This will enqueue a delayed action - the application-process will
     eventually execute aBlock.
     Useful for synchronization"

    ^ self
	enqueueMessage:#value
	for:aBlock
	arguments:#().

    "Modified: / 26.2.2000 / 18:01:44 / cg"
!

enqueueDelayedUpdate:something with:aParameter from:changedObject
    "support for delayed updates - to be invoked from a concrete classes
     #update:with:from: method.
     This will enqueue a delayed update, and resend #delayedUpdate:with:from:
     whenever the receiver is handling events.
     Especially useful, if many updates arrive at high frequency, to avoid
     multiple redraws."

    ^ self
        enqueueMessage:#delayedUpdate:with:from:
        for:self
        arguments:{ something . aParameter . changedObject }.

    "Modified: / 26.2.2000 / 18:01:44 / cg"
!

enqueueMessage:selector 
    "enqueue a message without arguments to be sent to myself later, 
     when my process is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    self enqueueMessage:selector for:self arguments:#()
!

enqueueMessage:selector arguments:argumentArray 
    "enqueue a message to be sent to myself later, 
     when my process is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    self enqueueMessage:selector for:self arguments:argumentArray
!

enqueueMessage:selector for:someone 
    "enqueue a message without arguments to be sent to someone later, 
     when my process is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    self enqueueMessage:selector for:someone arguments:#()
!

enqueueMessage:selector for:someone arguments:argList
    "enqueue a message to be sent to someone later, when my process
     is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    |window sensor|


    self isWebService ifTrue:[
        self breakPoint:#sr.
        ^ self
    ].

    ((window := self window) notNil and:[window isOpen]) ifTrue:[
        sensor := window sensor.
    ].

    sensor isNil ifTrue:[
        "no window (yet or any longer)"
        someone perform:selector withArguments:argList.
        ^ self.
    ].

    "/
    "/ if such a message is already in the queue, ignore it.
    "/ Otherwise push it as an event, to be handled when my thread is
    "/ back in the event loop.
    "/
    sensor enqueueMessage:selector for:someone arguments:argList

    "Created: / 26-02-2000 / 18:01:31 / cg"
    "Modified: / 23-03-2011 / 19:46:41 / cg"
!

enqueueMessage:selector with:argument 
    "enqueue a message with one argument to be sent to myself later, 
     when my process is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    self enqueueMessage:selector for:self arguments:{ argument }
!

enqueueMessage:selector with:argument1 with:argument2
    "enqueue a message with one argument to be sent to myself later, 
     when my process is back in its eventLoop. Also, filter duplicates.
     This is useful, to buffer redraws and avoid flicker due to multiple
     redraws (especially in browsers, when reacting on changeMessages resulting
     from changes made in other browsers)"

    self enqueueMessage:selector for:self arguments:{ argument1. argument2 }
! !

!ApplicationModel methodsFor:'drag & drop'!

canDropObjects:aCollectionOfDropObjects
    "drop manager asked if a drop is possible
     - should be redefined by apps which can do it, to return true"

    ^ false
!

canDropObjects:aCollectionOfDropObjects in:aComponent
    "drop manager asked if a drop is possible
     - should be redefined by apps which can do it, to return true"

    ^ self canDropObjects:aCollectionOfDropObjects
!

canDropObjects:aCollectionOfDropObjects in:aComponent at:position
    "drop manager asked if a drop is possible.
     Should be redefined by apps which can do it, to return true"

    ^ self canDropObjects:aCollectionOfDropObjects in:aComponent

    "Created: / 13-10-2006 / 15:52:20 / cg"
!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self subclassResponsibility

    "Created: / 13-10-2006 / 18:25:06 / cg"
!

dropObjects:aCollectionOfDropObjects in:aComponent
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefine in order for drop to work."

    ^ self dropObjects:aCollectionOfDropObjects

!

dropObjects:aCollectionOfDropObjects in:aComponent at:aPoint
    "drop manager wants to drop.
     This is ony sent, if #canDrop:in: returned true.
     Can be redefined in apps which return true to #canDrop."

    ^ self dropObjects:aCollectionOfDropObjects in:aComponent

    "Created: / 13-10-2006 / 18:25:13 / cg"
!

droppedFile:aFilename in:aComponent
    "ignored here - only sent by textView components, sometimes"
! !

!ApplicationModel methodsFor:'easy bindings'!

registerInterestIn:aValueModel using:aSelectorOrArray
    "Register interest in a change in aValueModel using information in aSelectorOrArray.
     aSelectorOrArray can be one of three things:

	    1) nil                  in which case no interest is registered
	    2) a selector           in which case the receiver is understood to be self
	    3) an Array             in which case the size is two where the first element is the
				    message to be sent and the second element is the receiver."

    aSelectorOrArray isNil ifTrue:[^ aValueModel].

    (aSelectorOrArray isArray) ifTrue:[
	aValueModel onChangeSend:(aSelectorOrArray at:1) to:(aSelectorOrArray at:2)
    ] ifFalse: [
	aValueModel onChangeSend:aSelectorOrArray to:self
    ].
    ^aValueModel

    "Modified: / 31.10.1997 / 18:19:44 / cg"
!

valueHolderFor:aSelector initialValue:anObject
    "Return a ValueHolder on anObject."

    ^ self valueHolderFor:aSelector initialValue:anObject changeMessage:nil


!

valueHolderFor:aSelector initialValue:anObject changeMessage:aSelectorOrArrayOrNil
    "Return a ValueHolder on anObject.  aSelectorOrArrayOrNil is the change information
     for the ValueHolder.  This argument is either a Symbol or an Array of two elements.
     If it is a Symbol, then it is the change message and the interested object is understood
     to be the receiver.  If it is an Array, then the first element is the change message and
     the second element is the interested object. "

    |holder|

    (builder bindings includesKey:aSelector) ifFalse:[
        holder := ValueHolder with:anObject.
        builder aspectAt:aSelector put:holder.
        aSelectorOrArrayOrNil notNil ifTrue:[
            ^ self registerInterestIn:holder using:aSelectorOrArrayOrNil
        ].
        ^ holder
    ].
    ^ builder aspectAt:aSelector

    "Modified: / 21.5.1998 / 03:31:28 / cg"
! !

!ApplicationModel methodsFor:'forced actions'!

doAcceptByReturnKey
    |acceptAction|

    builder notNil ifTrue:[
	acceptAction := builder bindingAt:#doAccept.
    ].
    acceptAction notNil ifTrue:[
	acceptAction value
    ] ifFalse:[
	self doAccept
    ]
!

doCancelByEscapeKey
    |cancelAction|

    builder notNil ifTrue:[
	cancelAction := builder bindingAt:#doCancel.
    ].
    cancelAction notNil ifTrue:[
	cancelAction value
    ] ifFalse:[
	self doCancel
    ]
! !

!ApplicationModel methodsFor:'help'!

aboutImage
    "bitmap image or nil for an about box for this application."

    ^ self class aboutImage

    "Modified: / 13.11.2001 / 12:32:44 / cg"
!

aboutThisApplicationLabel
    "label for an about box for this application."

    ^ self class aboutThisApplicationLabel
!

aboutThisApplicationText
    "text for an about box for this application."

    ^ self class aboutThisApplicationText
!

activeHelpViewFor:text onDevice:aDevice
    "redefinable to allow for applications to provide their own active help
     (aka tooltip) bubble window"

    ^ ActiveHelpView for:text onDevice:aDevice
!

flyByHelpDependsOnPositionIn:aView
    "subclasses where the help-text depends upon the pointer position might
     want to redefine this"

    ^ false
!

openAboutThisApplication
    "opens an about box for this application.
     Can be specialized by redefining #aboutThisApplicationText
     and #aboutThisApplicationLabel"

    Dialog
	about:(self translateString:self aboutThisApplicationText)
	label:(self translateString:self aboutThisApplicationLabel)
	icon:self aboutImage

    "Modified: / 17.11.2001 / 23:05:52 / cg"
!

openHelpViewOnFile:pathToHelpText
    "open a help viewer (as opened by the help buttons).
     The argument is a relative path within the help directory
     (but a file under the current directory is tried first)"

    self withWaitCursorDo:[
	HTMLDocumentView openFullOnHelpFile:pathToHelpText
    ]

!

showActiveHelp:aHelpText for:view
    "This is invoked from the activeHelp event listener, to display some popup-help
     for a component. If false is returned, the help manager will pop up
     some active help bubble; if true is returned, it will assume that the
     help text has been already displayed and will not do any further actions.
     Here, we accept the help text, and push an event into out own input
     queue, so that the help text will be displayed asynchronously by myself,
     vis the #showHelp:for: method.
     This can be redefined in concrete classes to handle active help differently."

    |wg mySensor|

    self showingHelp ifFalse: [
        ^ true
    ].

"/    masterApplication notNil ifTrue:[
"/        (masterApplication showActiveHelp:aHelpText for:view) ifTrue:[
"/            ^ true
"/        ]
"/    ].

    "/ NEW: push it into the event queue, to have it displayed
    "/ syncronously with other events.
    "/ (also any errors are reported as occurring in my context;
    "/  instead of occurring in the activeHelp context).

    (wg := self windowGroup) notNil ifTrue:[
        mySensor := wg sensor.
        mySensor notNil ifTrue:[
            mySensor flushEventsFor:self withType:#showHelp:for:.
            mySensor
                pushUserEvent:#showHelp:for: for:self
                withArguments:(Array with:aHelpText with:view).
            ^ true
        ]
    ].

    "/ mhmh - can this happen ?

    ^ true

    "Modified: / 21.8.1998 / 16:00:37 / cg"
!

showHelp:aHelpText for:view
    "actual method which is supposed to display the help text.
     Should be redefined in concrete classes, to put the help text
     into some info label, or the windows title bar.
     Here, the help text is ignored."

    masterApplication notNil ifTrue:[
	masterApplication showHelp:aHelpText for:view
    ].

    "Modified: / 31.7.1998 / 19:13:59 / cg"
!

showingHelp
    "return true, if the activeHelp manager should invoke my #showHelp:for:
     method, when the mouse pointer is moved over my widgets.
     The default here is true, however, the #showHelp:for: methods are empty.
     These should be redefined to put the help text into some info label,
     or into the view's title bar.
     You may also redefine the showingHelp/showingHelp: methods, to
     remember the flag setting."

    ^ true

    "Modified: / 31.7.1998 / 17:55:31 / cg"
! !

!ApplicationModel methodsFor:'help texts'!

basicFlyByHelpTextForKey:aKey
    "flyByHelp interface: return some short help text for a key.
     key is the symbol associated with some widget or menu item.
     Return the original (english) text as written in the helpSpec; 
     needs to be translated as per language"

    |helpSpecFromBindings helpText helpSpec "resourceArgs"|

    helpSpecFromBindings := self aspectFor:#flyByHelpSpec.
    helpSpecFromBindings notNil ifTrue:[
        helpText := helpSpecFromBindings at:aKey ifAbsent:nil.
    ] ifFalse:[
        helpSpecFromBindings := self aspectFor:#helpSpec.
        helpSpecFromBindings notNil ifTrue:[
            helpText := helpSpecFromBindings at:aKey ifAbsent:nil.
        ].
    ].
    helpText isNil ifTrue:[
        helpSpec := self flyByHelpSpec.
        helpSpec notNil ifTrue:[
            helpText := helpSpec at:aKey ifAbsent:nil.
        ].
    ].

    "/ new: allow for a collection (resource-key arg1 arg2...)
    helpText isNonByteCollection ifTrue:[
        helpText := helpText first.
"/        resourceArgs := helpText copyFrom:2.
    ].
    ^ helpText

    "Modified: / 27-01-2012 / 14:30:20 / cg"
    "Modified (comment): / 17-11-2016 / 22:37:05 / cg"
!

basicHelpTextForKey:aKey
    "activeHelp interface: return some help text for a key
     key is the symbol associated with some widget or menu item.
     Return the original (english) text; needs to be translated as per language"

    |helpText helpSpec "resourceArgs"|

    helpSpec := self helpSpec.
    helpSpec notNil ifTrue:[
	helpText := helpSpec at:aKey ifAbsent:nil.
    ].

    "/ new: allow for a collection (resource-key arg1 arg2...)
    helpText isNonByteCollection ifTrue:[
	helpText := helpText first.
"/        resourceArgs := helpText copyFrom:2.
    ].
    ^ helpText
!

flyByHelpSpec
    "activeHelp interface: return some short help text for a widget component"

    |specFromBuilder|

    builder notNil ifTrue:[
	(specFromBuilder := builder bindingAt:#flyByHelpSpec) notNil ifTrue:[
	    ^ specFromBuilder
	].

    ].
    ^ self class flyByHelpSpec
!

flyByHelpTextFor:aComponent
    "activeHelp interface: return some short help text for a widget component"

    |key|

    builder notNil ifTrue:[
	(key := builder helpKeyFor:aComponent) notNil ifTrue:[
	    ^ self flyByHelpTextForKey:key
	]
    ].
    masterApplication notNil ifTrue:[
	^ masterApplication flyByHelpTextFor:aComponent
    ].
    ^ nil

    "Modified: / 31.7.1998 / 23:03:10 / cg"
!

flyByHelpTextForKey:aKey
    "flyByHelp interface: return some short help text for a key
     key is the symbol associated with some widget or menu item.
     (from my flyByHelpSpec); return a language variant (if available)"

    |helpText translatedHelpText translatedKey|

    ActiveHelp debugging ifTrue:[ Transcript showCR:'help key: ', aKey].

    helpText := self basicFlyByHelpTextForKey:aKey.
    helpText isNil ifTrue:[
	masterApplication notNil ifTrue:[
	    "here we get an already translated helpText"
	    helpText := masterApplication flyByHelpTextForKey:aKey.
	].
	helpText isNil ifTrue:[
	    "there is no help text - resolve key from resources"
	    helpText := (self translateString:aKey) withCRs.
	].
	^ helpText.
    ].
    "/ kludge to allow for dynamic translation by the application itself, avoiding the key translation below.
    helpText isBlock ifTrue:[
	^ helpText value.
    ].

    "get the translation"
    translatedHelpText := self translateString:helpText.
    (helpText = aKey and:[ translatedHelpText = helpText ]) ifTrue:[
	"there is no translation in the resources - maybe there is one for the key?"
	translatedKey := self translateString:aKey.
	translatedKey ~~ aKey ifTrue:[
	     translatedHelpText := translatedKey.
	].
    ].
    ^ translatedHelpText withCRs.

    "Modified: / 27-01-2012 / 14:33:54 / cg"
!

flyByHelpTextForKey:aKey row:aRowNr
    "Special interface for DataSet - get the active help text for a specific row"

    "Default: no row specific help"

    ^ self flyByHelpTextForKey:aKey.
!

helpSpec
    "activeHelp interface: return some short help text for a widget component"

    ^ self class helpSpec
!

helpTextFor:aComponent
    "activeHelp interface: return some help text for a widget component"

    |key|

    builder notNil ifTrue:[
	(key := builder helpKeyFor:aComponent) notNil ifTrue:[
	    ^ self helpTextForKey:key
	]
    ].
    masterApplication notNil ifTrue:[
	^ masterApplication helpTextFor:aComponent
    ].
    ^ nil

    "Modified: / 31.7.1998 / 23:03:10 / cg"
!

helpTextForKey:aKey
    "activeHelp interface: return some help text for a key
     key is the symbol associated with some widget or menu item.
     (from my helpSpec); return a language variant (if available)"

    |helpText translatedHelpText translatedKey|

    helpText := self basicHelpTextForKey:aKey.
    helpText isNil ifTrue:[
        masterApplication notNil ifTrue:[
            "here we get an already translated helpText"
            helpText := masterApplication helpTextForKey:aKey.
        ].
        helpText isNil ifTrue:[
            "there is no help text - resolve key from resources"
            helpText := (self translateString:aKey) withCRs.
        ].
        ^ helpText.
    ].

    "/ kludge to allow for dynamic translation by the application itself.
    helpText isBlock ifTrue:[
        ^ helpText value.
    ].

    "get the translation"
    translatedHelpText := self translateString:helpText.
    translatedHelpText == helpText ifTrue:[
        "there is no translation in the resources - maybe there is one for the key?"
        translatedKey := self translateString:aKey.
        translatedKey ~~ aKey ifTrue:[
             translatedHelpText := translatedKey.
        ].
    ].
    ^ translatedHelpText withCRs.

    "Modified: / 22-12-2011 / 11:07:03 / cg"
! !

!ApplicationModel methodsFor:'hooks'!

aboutToOpen:whichTopView
    "the topView is about to be opened.
     This is sent by whichTopView, right before its really open
     (i.e. finally visible)"

    self preOpenWith:builder
!

commonPostBuild
    "a common hook for postBuildWith: and postBuildAsSubcanvasWith:."
!

commonPostOpen
    "a common hook for postOpenWith:, postOpenAsSubcanvasWith: and postOpenAsDialogWith:."

    "Modified (comment): / 07-07-2011 / 17:13:39 / cg"
!

commonPreBuild
    "a common hook for preBuildWith:, preBuildAsSubcanvasWith: and preBuildAsDialogWith:."

    "Modified (comment): / 07-07-2011 / 17:13:51 / cg"
!

commonPreOpen
    "A common hook for preOpenWith:, preOpenAsSubcanvasWith: and preOpenAsDialogWith:."

    "Created: / 05-03-2014 / 18:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postApplicationProcessCreate:newProcess windowGroup:newGroup
    "this is sent whenever a new application is launched from this app,
     which forks its own windowGroup process. Allows for process group management,
     or process-global exception handlers to be installed.
     Nothing done here - to be redefined in concrete applications"

!

postBuildAsSubcanvasWith:aBuilder
    "this is sent after an interface is built from a spec as subcanvas.
     Can be redefined in subclasses for additional setup after
     the subcanvas' view has been built, but not yet opened."

    |sameApp|

    sameApp := aBuilder application == aBuilder window topView application.

    "/ If I am opened as subcanvas in another application
    "/ then treat this like a regular open.
    "/ otherwise ignore it.
    sameApp ifFalse:[
	self postBuildWith:aBuilder.
    ] ifTrue:[
	"/ I no not think, that this is a good default
	"/ self commonPostBuild.
    ].

    "Modified (comment): / 07-07-2011 / 17:16:30 / cg"
!

postBuildDialogWith:aBuilder
    "this is sent after an interface is built from a spec as dialog with me
     as a source (for aspects) i.e. via openDialogInterface:.
     Can be redefined in subclasses for additional setup after
     the dialog's view has been built, but not yet opened."

    |sameApp|

    sameApp := (aBuilder application == aBuilder window topView application).

    "/ If I am opened as subcanvas in another application
    "/ then treat this like a regular open.
    "/ otherwise ignore it.
    sameApp ifFalse:[
	self postBuildWith:aBuilder.
    ] ifTrue:[
	self commonPostBuild.
    ].

    "Modified: / 08-07-1998 / 18:28:55 / cg"
    "Created: / 07-07-2011 / 17:20:29 / cg"
!

postBuildWith:aBuilder
    "this is sent after an interface is built from a spec.
     Can be redefined in subclasses for additional setup after
     the view has been built, but not yet opened."

    self commonPostBuild
!

postOpenAsSubcanvasWith:aBuilder
    "this is sent after the applications window is opened inside another application.
     Can be redefined in subclasses for actions after showing the canvas view."

    self commonPostOpen

    "Modified (comment): / 07-07-2011 / 17:16:46 / cg"
!

postOpenDialogWith:aBuilder
    "this is sent after the applications window is opened as a dialog with me
     as a source (for aspects) i.e. via openDialogInterface:.
     Can be redefined in subclasses for actions after opening a dialog view."

    self commonPostOpen

    "Created: / 07-07-2011 / 17:20:37 / cg"
    "Modified: / 05-03-2014 / 18:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith:aBuilder
    "this is sent after the applications main window is opened.
     Can be redefined in subclasses for actions after opening the view."

    self commonPostOpen
!

preBuildAsSubcanvasWith:aBuilder
    "this is sent before an interface is built from a spec as a subcanvas.
     Can be redefined for apps which need to be informed about that."

    self commonPreBuild
!

preBuildDialogWith:aBuilder
    "this is sent before an interface is built from a spec as a dialog with me
     as a source (for aspects) i.e. via openDialogInterface:.
     Can be redefined for apps which need to be informed about that."

    "Created: / 07-07-2011 / 17:20:48 / cg"
!

preBuildWith:aBuilder
    "this is sent before an interface is built from a spec.
     Can be redefined in subclasses.
     mhmh - what should this do here ?"

    self commonPreBuild
!

preOpenAsSubcanvasWith:aBuilder
    "this is sent before the applications window is opened inside another application.
     Can be redefined in subclasses for actions after showing the canvas view."

    self commonPreOpen

    "Created: / 05-03-2014 / 18:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preOpenDialogWith:aBuilder
    "this is sent after the applications window is opened as a dialog with me
     as a source (for aspects) i.e. via openDialogInterface:.
     Can be redefined in subclasses for actions after opening a dialog view."

    self commonPreOpen

    "Created: / 05-03-2014 / 18:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preOpenWith:aBuilder
    "this is sent before the applications main window is opened.
     Can be redefined in subclasses for actions right before opening the view."
! !

!ApplicationModel methodsFor:'initialization'!

addTopViewsToCurrentProject
    "add all of my topViews to the current projects list of views.
     This allows hiding views on a per-project basis.
     Applications which do not want to be switched with projects
     (such as the Launcher), may redefine this to a noop."

    |wg|

    (wg := self windowGroup) notNil ifTrue:[
	(wg topViews ? #()) do:[:aView |
	    aView addToCurrentProject
	]
    ]

    "Modified: 17.1.1997 / 19:43:39 / cg"
!

basicInitialize
    "initialize the application.
     Since ST-80 applications seem commonly to redefine #initialize
     without doing a super initialize, the real initialization is
     done here ..."

    self initializeDevice.

    "claus: I wanted to delay the creation & assignment of the
     builder till later, to allow setting to another builder.
     however, some (old) ST-80 code seems to access the builder right after instance
     creation, which might lead to trouble.
     On the other hand, some (newer) apps (RefactoringBrowser) depend on this being set
     late.
     So, we leave it undefined here. Do not uncomment the following lines.
    "

"/    builder := self builderClass new.
"/    builder notNil ifTrue:[builder application:self].

    self initializeResources.

    "Modified: / 13-09-2006 / 12:39:30 / cg"
!

initialize
    "nothing done here;
     but can be redefined in concrete applications"

    "Modified: / 02-02-2017 / 23:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeDevice
    self isWebService ifTrue:[
	self initializeWebServiceDevice
    ] ifFalse:[
	self initializeScreenDevice
    ].
!

initializeKeyboardMap
    keyboardMap := self class defaultKeyboardMap copy.
    device notNil ifTrue:[
        keyboardMap parent: device keyboardMap.
    ].

    "Created: / 02-02-2017 / 23:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2017 / 22:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeResources
    "initialize the applications resources (NLS support)."

    resources := self class classResources.

    "Created: / 13-09-2006 / 12:39:22 / cg"
!

initializeScreenDevice
    Screen notNil ifTrue:[
        device := Screen current.
        (device notNil and:[device isOpen not]) ifTrue:[
            (self class name,' [warning]: screen device is not open') errorPrintCR
        ].    
    ]
!

setDevice:aDevice
    "set the device (i.e. some Screen), where the application shall open its view(s).
     The default device (if not set here) will be the current screen."

    device := aDevice

    "Created: 5.7.1996 / 12:01:40 / cg"
    "Modified: 17.1.1997 / 19:44:09 / cg"
! !

!ApplicationModel methodsFor:'opening'!

hideWindows
    self windowGroup hideTopViews
!

open
    "open a standard interface.
     Sorry, but for visualworks compatibility, the builder is returned,
     not the receiver."

    ^ self openInterface

    "Modified: / 03-05-1996 / 13:39:15 / cg"
    "Modified (comment): / 27-12-2011 / 10:42:15 / cg"
!

openAndWaitUntilVisible
    "open a standard interface, and wait until my window is visible"

    self open.
    self window waitUntilVisible.
!

openAs:windowType
    "open a standard interface as slave, partner, dialog, popUp, undecorated etc.
     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterfaceAs:windowType

    "Modified: / 04-03-2011 / 15:03:19 / cg"
    "Modified (comment): / 27-12-2011 / 10:42:28 / cg"
!

openAsSlave
    "open a standard interface as slave.
     Notice: there is still a need to make the current window a master
	(see code and comments in WindowBuilder >> openAt:withExtent:andType:)"

    ^ self openAs:#slave

    "
     WorkspaceApplication new openAsSlave.
    "
!

openAt:aPoint
    "open a standard interface at some point"

    ^ self openInterfaceAt:aPoint

    "Modified: 3.5.1996 / 13:39:15 / cg"
    "Created: 14.2.1997 / 20:17:41 / cg"
!

openAtPointer
    "open a standard interface at the current pointer position.
     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterfaceAt:(device pointerPosition)
!

openInterface
    "open a standard interface.

     Subclasses which do not have an interfaceSpec
     should redefine this method and create & open their view(s) there.
     (see Launcher as an example).

     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterface:(self defaultWindowSpecName)

    "Modified: / 09-09-1996 / 22:39:23 / stefan"
    "Modified: / 23-01-1998 / 18:16:50 / cg"
    "Modified (comment): / 27-12-2011 / 10:42:04 / cg"
!

openInterface:aSymbol
    "open a specific interface.

     The argument, aSymbol specifies which interface. The concrete
     application subclass must provide a method with that name,
     which must return an interfaceSpec.
     This is forwarded to the builder to create the views.
     Typically, applications only use one interface, returned by the #windowSpec method.

     Sorry, but for visualworks compatibility, the builder is returned"

    self allButOpenInterface:aSymbol.
    self openWindow.
    ^ builder

    "Modified: / 03-03-2011 / 18:57:04 / cg"
    "Modified (comment): / 27-12-2011 / 10:41:54 / cg"
!

openInterface:aSymbol as:windowType
    "open a specific interface in a special mode.

     The argument, aSymbol specifies which interface.
     The concrete application subclass must provide a method with that name,
     which must return an interfaceSpec. This is forwarded to the builder to create the views.
     Typically, applications only use one interface, returned by the #windowSpec method.
     The windowType can be any of #slave, #partner, #dialog, #popUp etc.

     Sorry, but for visualworks compatibility, the builder is returned"

    self allButOpenInterface:aSymbol.
    self openWindowAs:windowType.
    ^ builder

    "Modified: / 03-03-2011 / 18:56:23 / cg"
    "Modified (comment): / 27-12-2011 / 10:42:37 / cg"
!

openInterface:aSymbol at:aLocation
    "open a specific interface at a location in default mode.

     The argument, aSymbol specifies which interface. The concrete
     application subclass must provide a method with that name,
     which must return an interfaceSpec. This is forwarded to
     the builder to create the views.
     Typically, applications only use one interface,
     returned by the #windowSpec method."

    self allButOpenInterface:aSymbol.
    self openWindowAt:aLocation.
    ^ builder

    "Created: / 14-02-1997 / 20:19:44 / cg"
    "Modified: / 03-03-2011 / 18:55:26 / cg"
!

openInterfaceAs:windowType
    "open a standard interface in a special mode.

     The windowType can be any of #slave, #partner, #dialog, #popUp, #undecorated etc."

    ^ self openInterface:(self defaultWindowSpecName) as:windowType

    "Modified: / 09-09-1996 / 22:39:23 / stefan"
    "Modified: / 04-03-2011 / 15:03:28 / cg"
!

openInterfaceAt:aLocation
    "open a standard interface."

    ^ self openInterface:(self defaultWindowSpecName) at:aLocation

    "Created: / 14.2.1997 / 20:18:20 / cg"
    "Modified: / 23.1.1998 / 18:17:13 / cg"
!

openInterfaceModal
    "open a standard interface as a modal dialog.
     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterfaceModal:(self defaultWindowSpecName)

    "Modified: / 09-09-1996 / 22:39:23 / stefan"
    "Modified: / 03-03-2011 / 18:54:48 / cg"
    "Modified (comment): / 27-12-2011 / 10:42:53 / cg"
!

openInterfaceModal:aSymbol
    "open a specific interface as a modal dialog.
     The argument, aSymbol specifies which interface. The concrete
     application subclass must provide a method with that name,
     which must return an interfaceSpec. This is forwarded to
     the builder to create the views.
     Typically, applications only use one interface,
     returned by the #windowSpec method."

    self allButOpenInterface:aSymbol.
    self openWindowModal.
    ^ builder

    "Modified: 14.2.1997 / 20:25:33 / cg"
!

openInterfaceModal:aSymbol at:location
    "open a specific interface modal at some screen location.
     The argument, aSymbol specifies which interface. The concrete
     application subclass must provide a method with that name,
     which must return an interfaceSpec. This is forwarded to
     the builder to create the views.
     Typically, applications only use one interface,
     returned by the #windowSpec method."

    self allButOpenInterface:aSymbol.
    self openWindowModalAt:location.
    ^ builder

    "Modified: 14.2.1997 / 20:25:33 / cg"
!

openModal
    "open a standard interface as a modal dialog"

    ^ self openInterfaceModal

    "Modified: 3.5.1996 / 13:39:15 / cg"
!

openModalAtPointer
    "open a standard interface modal at the current pointer position.
     Sorry, but for visualworks compatibility, the builder is returned"

    ^ self openInterfaceModal:(self defaultWindowSpecName) at:(device pointerPosition)
!

openOnDevice:aDevice
    "open a standard interface on some other device"

    self setDevice:aDevice.
    Screen currentScreenQuerySignal 
        answer:aDevice
        do:[
            ^ self open
        ]

    "Created: 13.1.1997 / 21:24:11 / cg"
    "Modified: 13.1.1997 / 21:24:30 / cg"
!

openSpec:anInterfaceSpec
    "open a view as specified in anInterfaceSpec."

    self allButOpenFrom:anInterfaceSpec.
    self openWindow.
    ^ builder

    "Modified: / 14.2.1997 / 20:25:33 / cg"
    "Created: / 20.5.1998 / 20:08:51 / cg"
!

openSpec:anInterfaceSpec withBindings:bindings
    "open a view as specified in anInterfaceSpec."

    self openSpec:anInterfaceSpec withBindings:bindings modal:false
!

openSpec:anInterfaceSpec withBindings:bindings modal:modal
    "open a view as specified in anInterfaceSpec."

    self createBuilder.
    builder bindings:bindings.
    self allButOpenFrom:anInterfaceSpec.
    modal ifTrue:[
	self openWindowModal.
    ] ifFalse:[
	self openWindow.
    ]
!

openSpecModal:anInterfaceSpec
    "open an interface spec modal"

    self allButOpenFrom:anInterfaceSpec.
    self openWindowModal.
    ^ builder

    "Modified: / 14.2.1997 / 20:25:33 / cg"
    "Created: / 20.5.1998 / 20:20:21 / cg"
!

openWindow
    "open the window
     - assumes that the builder has already setup the interface."

    builder "openWindow."
	openAt:nil
	withExtent:(self defaultWindowExtent)
	andType:(self defaultWindowType)

    "Created: / 14-02-1997 / 20:20:39 / cg"
    "Modified: / 11-07-2011 / 22:30:27 / cg"
!

openWindowAs:windowType
    "open the window - assumes that the builder has already setup the interface.
     The windowType can be any of #slave, #partner, #dialog, #popUp etc."

    builder
	openAt:nil
	withExtent:(self defaultWindowExtent)
	andType:windowType

    "Modified: / 11-07-2011 / 22:30:35 / cg"
!

openWindowAs:windowType at:originOrNil
    "open the window - assumes that the builder has already setup the interface.
     The windowType can be any of #slave, #partner, #dialog, #popUp etc."

    builder
	openAt:originOrNil
	withExtent:(self defaultWindowExtent)
	andType:windowType

    "Modified: / 11-07-2011 / 22:30:35 / cg"
    "Created: / 25-07-2011 / 16:00:24 / cg"
!

openWindowAt:aPoint
    "open the window
     - assumes that the builder has already setup the interface."

    builder "openWindowAt:aLocation."
	openAt:aPoint
	withExtent:(self defaultWindowExtent)
	andType:(self defaultWindowType)

    "Created: / 14-02-1997 / 20:20:55 / cg"
!

openWindowAtCenter
    "open the window centered on the screen
     - assumes that the builder has already setup the interface."

    builder openWindowAt:#center

    "Created: 14.2.1997 / 20:20:55 / cg"
!

openWindowModal
    "open the window as a modal dialog
     - assumes that the builder has already setup the interface."

"/    builder openDialog.
    builder
	openAt:nil
	withExtent:(self defaultWindowExtent)
	andType:#dialog

    "Created: / 14-02-1997 / 20:20:39 / cg"
!

openWindowModalAt:aLocation
    "open the window as a modal dialog
     - assumes that the builder has already setup the interface."

    builder openDialogAt:aLocation.

    "Created: / 14-02-1997 / 20:20:55 / cg"
!

openWithExtent:extPoint
    "open a standard interface with given extent"

    |bldr|

    bldr := self allButOpen.
    bldr openWithExtent:extPoint.
    ^ bldr

    "Modified: 3.5.1996 / 13:39:15 / cg"
!

opened:whichTopView
    "the topView has been opened.
     This is sent by whichTopView, when its really open
     (i.e. finally visible)"

    self addTopViewsToCurrentProject.
    self postOpenWith:builder
!

showWindows
    self window map;activate.
!

unhideWindows
    self windowGroup unhideTopViews
! !

!ApplicationModel methodsFor:'opening-dialogs'!

openDialog
    "open my window as a modal dialog
     - assumes that the builder has already setup the interface."

    self window beToolDialog.
    ^ builder openDialog.

    "Modified: / 14-02-1997 / 20:32:52 / cg"
    "Modified (comment): / 07-07-2011 / 17:25:45 / cg"
!

openDialogAt:aPoint
    "open my window as a modal dialog
     - assumes that the builder has already setup the interface."

    self window beToolDialog.
    ^ builder openDialogAt:aPoint.
!

openDialogAtPointer
    "open my window as a modal dialog
     - assumes that the builder has already setup the interface."

    ^ self openDialogAt:(device pointerPosition).
!

openDialogInterface:aSelector
    "open a dialog"

    "/ Notice: the opened dialog will be technically another instance
    "/ (of SimpleDialog) but use me as aspect provider.
    "/ It will call postOpenDialog: and postBuildDialog: as callbacks.

    ^ self openDialogInterface:aSelector withBindings:nil

    "Modified: / 28-02-1997 / 14:08:01 / cg"
    "Modified (comment): / 07-07-2011 / 17:25:26 / cg"
!

openDialogInterface:aSelector withBindings:bindings
    "open a dialog, given a spec-selector"

    "/ Notice: the opened dialog will be technically another instance
    "/ (of SimpleDialog) but use me as aspect provider.
    "/ It will call postOpenDialog: and postBuildDialog: as callbacks.

    ^ SimpleDialog new
	openFor:self
	interface:aSelector
	withBindings:bindings

    "Created: / 28-02-1997 / 14:07:45 / cg"
    "Modified: / 23-01-1998 / 18:18:14 / cg"
    "Modified (comment): / 07-07-2011 / 17:25:23 / cg"
!

openDialogInterfaceSpec:aSpec withBindings:bindings
    "open a dialog, given a spec"

    "/ Notice: the opened dialog will be technically another instance
    "/ (of SimpleDialog) but use me as aspect provider.
    "/ It will call postOpenDialog: and postBuildDialog: as callbacks.

    ^ SimpleDialog new
	openFor:self
	interfaceSpec:aSpec
	withBindings:bindings

    "Created: / 28-02-1997 / 14:07:45 / cg"
    "Modified: / 23-01-1998 / 18:18:14 / cg"
    "Modified (comment): / 07-07-2011 / 17:25:20 / cg"
!

openDialogModeless
    "open my window as a modal dialog
     - assumes that the builder has already setup the interface."

    self window beToolDialog.
    ^ builder open.

    "Modified: / 14-02-1997 / 20:32:52 / cg"
    "Modified (comment): / 07-07-2011 / 17:25:45 / cg"
!

openDialogSpec:aSpec withBindings:bindings
    "open a dialog"

    "/ Notice: the opened dialog will be technically another instance
    "/ (of SimpleDialog) but use me as aspect provider.
    "/ It will call postOpenDialog: and postBuildDialog: as callbacks.

    ^ SimpleDialog new
	openFor:self
	spec:aSpec
	withBindings:bindings

    "Modified: / 23-01-1998 / 18:18:14 / cg"
    "Created: / 20-05-1998 / 20:27:56 / cg"
!

openDialogSpecModeless:aSpec withBindings:bindings
    "open a dialog, but without blocking the caller"

    "/ Notice: the opened dialog will be technically another instance
    "/ (of SimpleDialog) but use me as aspect provider.
    "/ It will call postOpenDialog: and postBuildDialog: as callbacks.

    ^ SimpleDialog new
        openModelessFor:self
        spec:aSpec
        withBindings:bindings

    "Modified: / 23-01-1998 / 18:18:14 / cg"
    "Created: / 20-05-1998 / 20:27:56 / cg"
! !

!ApplicationModel methodsFor:'opening-webInterface'!

addToService
    self service
	addPage:(builder page)
	link:(self webLink)
!

createWebBuilder
    "create a Web-UIBuilder if not already present"

    builder isNil ifTrue:[
	builder := self webBuilderClass new.
	builder application:self.
    ]

    "Created: / 19.6.1998 / 03:32:37 / cg"
!

defaultPageSpecName
    ^ #pageSpec
!

defineInterface
    "define a standard interface.

     Subclasses which do not have an interfaceSpec
     should redefine this method and create their page there."

    ^ self defineInterface:(self defaultPageSpecName)
!

defineInterface:aSpecSymbol
    "define an interface."

    ^ self defineInterfaceFrom:(self interfaceSpecFor:aSpecSymbol)
!

defineInterfaceFrom:aSpec
    "define an interface (setup a page), given a spec."

    |page|

    builder isNil ifTrue:[
	self createWebBuilder.
    ].

    self preBuildWith:builder.
    builder buildPageFromSpec:aSpec.
    page := builder page.
    page application:self.

    self postBuildWith:builder.

    "Modified: / 19.6.1998 / 03:35:31 / cg"
!

httpServerPort
    "on which port will a HTTP server be started"

    ^ self class defaultHttpServerPort
!

initializeAsWebServiceOnWebDevice:webDevice
    self setDevice:(WebApplicationDevice new).
    self initialize.
    self initializeWebServiceDevice.
    self initializeResources.
!

initializeWebServiceDevice
    "no real device here; instead, we need a web service in which I register.
     The device is a dummy one, to make the protocol transparent & compatible"

    |server|

    self service isNil ifTrue:[
	server := HTTPServer serverOnPort:(self httpServerPort).

	self service:(server
		    serviceForLink:(self serviceLinkName)
		    ifAbsent:[
			|service|

			service := HTTPPortalService new.
			service linkName:(self serviceLinkName).
			service class unRegisterServiceOn:server.
			service registerServiceOn:server.
			service
		    ]).
    ].
!

pageSpecs
    ^ self class pageSpecs
!

service
    device isNil ifTrue:[^ nil].
    self assert:(device isWebServiceDevice).
    ^ device service
!

service:something
    self device service:something.
!

serviceLinkName
    ^ self class defaultServiceLinkName
!

startAsWebService
    device isNil ifTrue:[
	self initializeDevice.
    ].
    self startInPortalService:self service

    "
     self new startInWebService
    "
!

startInPortalService:aPortalServiceOrSession
    aPortalServiceOrSession application:self.
    self service:aPortalServiceOrSession.
    self defineInterface.
    self addToService.
!

webBuilderClass
    "return the UIBuilder class for me.
     This method can be redefined if (eventually) there are
     spec readers for other UI languages (motif UIL ?)"

    ^ WebPageBuilder

    "Created: / 19.6.1998 / 01:39:26 / cg"
    "Modified: / 19.6.1998 / 01:45:24 / cg"
!

webLink
    "if nil is returned, I will install my page(s) right under the serviceLink (i.e. /portal/nn).
     Otherwise, they will be under (i.e. /portal/link/nn)"

    ^ self device webLink
!

webLink:something
    self device webLink:something
! !

!ApplicationModel methodsFor:'private'!

builderClass
    "return the UIBuilder class for me.
     This method can be redefined if (eventually) there are
     spec readers for other UI languages (motif UIL ?)"

    self isWebService ifTrue:[
	^ self webBuilderClass
    ].
    ^ UIBuilder

    "Created: / 19.6.1998 / 01:39:26 / cg"
    "Modified: / 19.6.1998 / 01:45:24 / cg"
!

createBuilder
    "create a WindowBuilder if not already present"

    builder isNil ifTrue:[
	builder := self builderClass new.
	builder application:self.
    ]

    "Created: / 19.6.1998 / 03:32:37 / cg"
! !

!ApplicationModel methodsFor:'queries'!

defaultWindowExtent
    ^ self class defaultExtentFor:self class

    "Created: / 11-07-2011 / 22:30:12 / cg"
!

defaultWindowSpecName
    ^ #windowSpec
!

defaultWindowType
    "Applications come up non-modal, by default"

    ^ #normal

    "Created: 17.1.1997 / 19:57:34 / cg"
!

graphicsDevice
    "return the device I want to open my views on.
     The default (if not created with #onDevice:) is the currently
     active screen."

    ^ device

    "Created: 5.7.1996 / 17:51:31 / cg"
!

interfaceSpecFor:aSelectorOrSpec
    "return an interface spec.
     Here, the query is forwarded to my class.
     Can be refefined in subclasses which want to provide per-instance specs."

    aSelectorOrSpec isSymbol ifFalse:[
        (aSelectorOrSpec isKindOf:UISpecification) ifTrue:[^ aSelectorOrSpec].
    ].
    UnhandledAttributeInLiteralArrayErrorSignal handle:[:ex |
        "/ that is to support debugging - to easily find the bad spec
        Transcript showCR:'%1 [warning]: Error in spec (%2):' withCRs 
                                with:self class name 
                                with:aSelectorOrSpec.
        Transcript showCR:ex description. 
        ex proceed.
    ] do:[    
        ^ self class interfaceSpecFor:aSelectorOrSpec
    ].
    
    "Created: / 25-01-1998 / 19:45:12 / cg"
    "Modified: / 14-01-2008 / 17:54:29 / cg"
!

isOpen
   "answer true if the application's window is open"

   |win|

   ^ (win := self window) notNil and:[win isOpen]
!

isShown
   "answer true if the application's window is shown"

   |win|

   ^ (win := self window) notNil and:[win shown]
!

isWebService
    ^ device notNil and:[ device askFor:#isWebServiceDevice ]
!

processName
    "return a name to be shown for me in the process monitor"

    self class == ApplicationModel ifTrue:[
	^ 'Application'
    ].
    ^ self class nameWithoutPrefix

    "Modified: / 4.12.1997 / 12:39:14 / cg"
!

resolveClassNamed:something inClass:aClass
    "return the class from something, a class, symbol, string or nil.
     first we are looking in the namespace of the application, then in the
     current namespace and finally in Smalltalk
    "

    ^ Smalltalk resolveName:something inClass:aClass.
!

resolveFont:something
    "resolve the font. Delegate to windowBuilder"

    ^ builder resolveFont:something
!

resolveName:something
    "return the class from something, a class, symbol, string or nil.
     first we are looking in the namespace of the application, then in the
     current namespace and finally in Smalltalk"

    ^ self resolveName:something inClass:self class
!

resolveName:something inClass:aClass
    "return the class from something, a class, symbol, string or nil.
     first we are looking in the namespace of the application,
     then in the current namespace and finally in Smalltalk"

    |cls|

    aClass notNil ifTrue:[
	(cls := Smalltalk resolveName:something inClass:aClass) notNil ifTrue:[
	    ^ cls
	].

	masterApplication notNil ifTrue:[
	    ^ masterApplication resolveName:something
	]
    ].
    ^ nil
!

selfResponsibleFor:aKey
    "internal: return true, if I am to provide a value for some aspect."

    <resource: #obsolete>

    self obsoleteMethodWarning:'obsoleted for de-obfuscation'.
    ^ (aKey isNil or:[masterApplication isNil or:[self respondsTo:aKey]])
!

shouldRememberLastExtent
    "to be redefined by concrete applications:
     if true is answered, the application's extent is remembered on close
     and used as a default when opened the next time"

    ^ self class shouldRememberLastExtent
!

topApplication
    "return the top-master application"

    masterApplication isNil ifTrue:[
	^ self
    ].
    ^ masterApplication topApplication

    "Created: / 6.6.1998 / 19:40:42 / cg"
! !

!ApplicationModel methodsFor:'startup & release'!

applicationWindowClass
    "return the class used for my (top-) windows"

    ^ ApplicationWindow
!

close
    "this is sent by my topView when about to be closed
     by the program (not by the windowManager).
     Notice, that we get a closeRequest message if closed by the windowManager,
     which can be rejected by the app (or confirmed via a dialog)
     Could be redefined in subclasses."

    self closeDownViews
!

closeDownViews
    "close down the application's view(s)"

    |wg wgProcess window|

    self release.
    ActiveHelp stopFor:self.

    window := self window.

    self shouldRememberLastExtent ifTrue:[
	self rememberLastExtent.
    ].
    ((wg := self windowGroup) notNil
    and:[ wg isModal not ]) ifTrue:[
	wgProcess := wg process.
	(Processor activeProcess ~~ wgProcess
	and:[wgProcess notNil]) ifTrue:[
	    wgProcess terminate
	] ifFalse:[
	    wg closeDownViews.
	]
    ] ifFalse:[
	window notNil ifTrue:[
	    window destroy.
	]
    ].

    "Modified: / 31-07-2013 / 17:41:08 / cg"
!

closeRequest
    "this is sent by my topView when about to be closed by the windowManager.
     Could be redefined in subclasses to suppress close or confirm."

    |sav window|

    window := self window.
    window isNil ifTrue:[
	'ApplicationModel [warning]: oops - closeRequest for non-view application arrived' infoPrintCR.
	^ self
    ].

    window isTopView ifFalse:[
	window topView isModal ifTrue:[
	    WindowGroup leaveSignal raise.
	].

	'ApplicationModel [warning]: oops - closeRequest for non-TopView arrived' infoPrintCR.
	^ self
    ].

    "/ In multiView apps, tell my master.
    "/ (but not if I am a modal reincarnation)
    (masterApplication notNil
    and:[window isModal not]) ifTrue:[

	"/ temporary clear my masterApplication to prevent
	"/ endless recursion, in case the master sends me
	"/ a closeRequest (although, it is supposed to
	"/ send me a closeDownViews ...)

	sav := masterApplication.
	masterApplication := nil.
	sav closeRequestFor:window.

	"/ restore - in case master did not want me to close ...
	masterApplication := sav.
    ] ifFalse:[
	"/ ST/X does close-check by redefining this message without
	"/ a supersend;
	"/ VW does it by returning false from requestForWindowClose
	"/ sigh.

	self requestForWindowClose ifTrue:[
	    window isSlave ifTrue:[
		window destroy
	    ] ifFalse:[
		self closeDownViews
	    ]
	]
    ].

    "Modified: / 19.6.1998 / 01:37:17 / cg"
!

closeRequestFor:aTopView
    "this is sent by any of my topViews when about to be closed by the
     windowmanager. For backward compatibility with single-view applications,
     this is forwarded here to a simple (non topView-specific) closeRequest,
     effectively closing all of my views.
     MultiView applications should redefine this method if closing of individual
     views closing is to be caught and/or should not close all of them."

    |savedMaster myWindow|

    myWindow := self window.

    "/ In multiView apps, tell my master.
    "/ (but not if I am a modal reincarnation)
    (masterApplication notNil
    and:[myWindow topView isModal not]) ifTrue:[

	"/ temporary clear my masterApplication to prevent
	"/ endless recursion, in case the master sends me
	"/ a closeRequest (although, it is supposed to
	"/ send me a closeDownViews ...)

	savedMaster := masterApplication.
	masterApplication := nil.
	aTopView isSlave ifTrue:[
	    savedMaster closeRequestFor:aTopView.
	] ifFalse:[
	    savedMaster closeRequestFor:myWindow.
	].

	"/ restore - in case master did not want me to close ...
	masterApplication := savedMaster.
	^ self
    ].

    (aTopView == myWindow) ifTrue:[
	self closeRequest.
	^ self
    ].

    (aTopView isPartner or:[aTopView isMaster]) ifTrue:[
	aTopView application closeRequest.
	self closeRequest.
	^ self.
    ].
    aTopView isSlave ifTrue:[
	aTopView closeRequest
    ] ifFalse:[
	aTopView application closeRequest.
    ]
!

doAccept
    "this is invoked by the Return-Key (if returnIsOK) or
     the ok-button (if any), IFF the application has been
     opened modal (i.e. as a dialog)."

    "/ the following is a bad kludge -
    "/ actually, modal apps should inherit from SimpleDialog
    "/ (then, things would be clean)
    "/ However, it may be useful, to open some app (which is normally
    "/ modeless) as a modal one as well.
    "/ In that, case, we have no acceptHolder (see SimpleDialog),
    "/ to remember the accept vs. cancel case.
    "/
    self window isModal ifTrue:[
	masterApplication notNil ifTrue:[
	    masterApplication window topView == self window topView ifTrue:[
		masterApplication window isModal ifTrue:[
		    masterApplication doAccept.
		    ^ self.
		].
	    ].
	].

	"/ mhmh - is this a good idea ?
	self perform:#accept ifNotUnderstood:[self closeRequest].
	^ self
    ].

    ^ self      "/ nothing done here ...
!

doCancel
    "this is invoked by the Escape-Key (if escapeIsCancel) or
     the cancel-button (if any), IFF the application has been
     opened modal (i.e. as a dialog)."

    "/ the following is a bad kludge -
    "/ actually, modal apps should inherit from SimpleDialog
    "/ (then, things would be clean)
    "/ However, it may be useful, to open some app (which is normally
    "/ modeless) as a modal one as well.
    "/ In that, case, we have no acceptHolder (see SimpleDialog),
    "/ to remember the accept vs. cancel case.
    "/
    self window isModal ifTrue:[
	"/ mhmh - is this a good idea ?
	self perform:#cancel ifNotUnderstood:[self closeRequest].
	^ self
    ].
    ^ self      "/ nothing done here ...
!

releaseAsSubCanvas
    "a subcanvas is closed or switching to a new application.
     Can be redefined to perform a self release in this case."

    "/ used to self release here,
    "/ but that is incompatible to VW (RefactoryBrowser).
    "/ Therefore, if you need it, you MUST now redefine
    "/ this method.
!

rememberLastExtent
    "remember my current extent for the next open"

    |window|

    window := self window.
    (window notNil and:[window isTopView]) ifTrue:[
	DefaultExtents isNil ifTrue:[
	    DefaultExtents := Dictionary new.
	].
	DefaultExtents at:self class name put:(window extent).
    ].

    "Created: / 31-07-2013 / 14:41:33 / cg"
!

restarted
    "sent by my topWindow, when restarted from an image.
     Nothing done here, but can be redefined to perform any actions
     required to reset the application after an image-restart.
     (for example: check if application files are still around, restart
      subprocesses etc.)."

    "Modified: 1.6.1996 / 16:55:50 / cg"
!

saveAndTerminateRequest
    "some windowManagers send this to shut down an application
     and have it save its state for restart.
     Can be redefined in subclasses"

    self closeRequest
!

saveAndTerminateRequestFor:aTopView
    "some windowManagers send this to shut down an application
     and have it save its state for restart.
     Can be redefined in subclasses"

    self saveAndTerminateRequest
! !

!ApplicationModel methodsFor:'translating'!

translateString:aString
    "translate aString to the current language.
     We use the resources as default.
     Subclasses may redefine this to use another mechanism"

    ^ self resources stringWithCRs:aString

    "Modified: / 25-11-2016 / 09:56:11 / cg"
!

translateString:aString with:anArgument
    "translate aString to the current language.
     We use the resources as default.
     Subclasses may redefine this to use another mechanism"

    ^ self resources stringWithCRs:aString with:anArgument

    "Created: / 25-11-2016 / 09:54:32 / cg"
! !

!ApplicationModel methodsFor:'user interaction & notifications'!

beep
    "output an audible beep or bell on my screen device"

    device notNil ifTrue:[
        device beep.
    ].
!

information:aString
    "like Object's information, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super information:(self translateString:aString)

    "Created: / 20-05-1998 / 03:48:43 / cg"
    "Modified: / 25-11-2016 / 09:55:53 / cg"
!

informationTranslated:aString
    "like Object's information, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self information:(self translateString:aString)

    "Created: / 25-11-2016 / 09:59:47 / cg"
!

informationTranslated:aString with:anArgument
    "like Object's information, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self information:(self translateString:aString with:anArgument)

    "Created: / 25-11-2016 / 10:01:32 / cg"
!

notify:aString
    "like Objects notify, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    super notify:(self translateString:aString) withCRs

    "Created: / 20.5.1998 / 01:14:52 / cg"
    "Modified: / 13.11.2001 / 20:10:12 / cg"
!

openDocumentationFile:aFilename
    HTMLDocumentView notNil ifTrue:[
	HTMLDocumentView openFullOnDocumentationFile:aFilename.
    ].
!

restoreCursors
    "restore the original cursors in all of my views"

    ^ self window windowGroup restoreCursors

    "Created: 1.6.1996 / 17:01:24 / cg"
!

showCursor:aCursor
    "set all of my views cursor to aCursor.
     It can be restored with #restoreCursor."

    ^ self window windowGroup showCursor:aCursor

    "Created: 1.6.1996 / 17:01:09 / cg"
!

warn:aString
    "like Object's warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self warn:aString translate:true

    "Created: / 20.5.1998 / 01:14:52 / cg"
    "Modified: / 13.11.2001 / 20:10:12 / cg"
!

warn:aString translate:aBoolean
    "like Objects warn, but optionally translates the string via the
     resourcePack, thus giving a translated string automatically"

    super warn:(aBoolean
		    ifTrue:[ (self translateString:aString) withCRs ]
		    ifFalse:[ aString ]).
!

warn:aString with:arg
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self warn:aString withArguments:(Array with:arg)
!

warn:aString with:arg1 with:arg2
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self warn:aString withArguments:(Array with:arg1 with:arg2)
!

warn:aString with:arg1 with:arg2 with:arg3
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self warn:aString withArguments:(Array with:arg1 with:arg2 with:arg3)
!

warn:aString with:arg1 with:arg2 with:arg3 with:arg4
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically"

    self warn:aString withArguments:(Array with:arg1 with:arg2 with:arg3 with:arg4)

    "Created: / 23.2.2000 / 09:43:04 / cg"
!

warn:aString withArguments:argArray
    "like Objects warn, but translates the string via the
     resourcePack, thus giving a translated string automatically.
     Also translates \'s to newLine."

    |translatedString stream|

    translatedString := self translateString:aString.
    stream := TextStream on:(translatedString species new:translatedString size + (argArray size * 10)).
    translatedString withCRs expandPlaceholdersWith:argArray on:stream.

    self warn:(stream contents) translate:false.
!

withCursor:aCursor do:aBlock
    "evaluate aBlock, showing aCursor in my topView and all of its subviews.
     Return the value of aBlock."

    |w|

    w := self window.
    w notNil ifTrue:[
        ^ w topView withCursor:aCursor do:aBlock
    ].
    ^ aCursor showWhile:aBlock.

    "Modified: / 23.9.1998 / 17:00:25 / cg"
!

withExecuteCursorDo:aBlock
    "evaluate aBlock, showing an executeCursor in my topView and all of its subviews.
     Return the value of aBlock."

    ^ self withCursor:(Cursor execute) do:aBlock

    "Created: 14.12.1995 / 20:57:03 / cg"
!

withReadCursorDo:aBlock
    "evaluate aBlock, showing a readCursor in my topView and all of its subviews.
     Return the value of aBlock."

    ^ self withCursor:(Cursor read) do:aBlock

    "Created: 14.12.1995 / 20:56:47 / cg"
    "Modified: 14.12.1995 / 20:57:36 / cg"
!

withVisibleCursor:aCursor do:aBlock
    "evaluate aBlock, showing a waitCursor in my topView and all of its subviews.
     Return the value of aBlock.
     Ensure, that the cursor is visible by the user for a minimal amount of time."

    |ret|

    self
	withCursor:aCursor do:[
	    |time|

	    time := Time millisecondsToRun:[ ret := aBlock value].
	    time := UserPreferences current waitCursorVisibleTime - time.
	    time > 0 ifTrue:[
		Delay waitForMilliseconds:time.
	    ].
	].
    ^ ret.

    "Modified (comment): / 12-09-2011 / 12:14:31 / cg"
!

withWaitCursorDo:aBlock
    "evaluate aBlock, showing a waitCursor in my topView and all of its subviews.
     Return the value of aBlock."

    ^ self withCursor:(Cursor wait) do:aBlock
!

withWaitCursorVisibleDo:aBlock
    "evaluate aBlock, showing a waitCursor in my topView and all of its subviews.
     Return the value of aBlock.
     Guarantee, that the cursor is visible by the user for a minimal amount of time."

    ^ self withVisibleCursor:(Cursor wait) do:aBlock
!

withWriteCursorDo:aBlock
    "evaluate aBlock, showing a writeCursor in my topView and all of its subviews.
     Return the value of aBlock."

    ^ self withCursor:(Cursor write) do:aBlock

    "Created: / 27-07-2012 / 09:42:53 / cg"
! !

!ApplicationModel methodsFor:'window events'!

clientMessage:msgType format:msgFormat eventData:msgData
    "a client message - very X-Window specific and only useful for special applications.
     Subclasses prepared to receive them should redefine this method"
!

copyDataEvent:parameter eventData:msgData
    "a client message - very Win32 specific and only useful for special applications.
     Subclasses prepared to receive them should redefine this method"

    |messageStream command argument|

    messageStream := msgData asString readStream.
    command := messageStream upTo: $:.
    argument := messageStream upTo: Character null.
    self processApplicationCommand:command with:argument
!

delayedAutoRaiseEventFor:oneOfMyViews
    "called with a delay by the focusIn code, iff the userPref setting is active.
     Some (a small number only) may want to prevent autoraise in certain situations
     - for example, if one view is controlling another. 
     These get a chance to redefine this method"

    oneOfMyViews raise.
!

dispatchEvent:event
    "dispatch a user-pushed event.
     This allows for events for an appModel to be pushed into the event queue
     the same way as events for a view are pushable."

    ^ self
	dispatchEvent:event
	withFocusOn:nil
	delegate:true

!

dispatchEvent:evType arguments:evArgs withFocusOn:focusView delegate:doDelegate
    "dispatch a user-pushed event.
     This allows for events for an appModel to be pushed into the event queue
     the same way as events for a view are pushable."

    self perform:evType withArguments:evArgs

    "Created: / 20.6.1998 / 16:36:54 / cg"
    "Modified: / 20.6.1998 / 16:44:05 / cg"
!

dispatchEvent:ev type:evType arguments:evArgs withFocusOn:focusView delegate:doDelegate
    "dispatch a user-pushed event.
     This allows for events for an appModel to be pushed into the event queue
     the same way as events for a view are pushable."

    self perform:evType withArguments:evArgs

    "Created: / 20.6.1998 / 16:36:54 / cg"
    "Modified: / 20.6.1998 / 16:44:05 / cg"
!

dispatchEvent:event withFocusOn:focusViewOrNil
    "dispatch a user-pushed event.
     This allows for events for an appModel to be pushed into the event queue
     the same way as events for a view are pushable."

    ^ self
	dispatchEvent:event
	withFocusOn:focusViewOrNil
	delegate:true


!

dispatchEvent:event withFocusOn:focusViewOrNil delegate:doDelegate
    "dispatch a user-pushed event.
     This allows for events for an appModel to be pushed into the event queue
     the same way as events for a view are pushable."

    ^ self
	dispatchEvent:event
	type:event type
	arguments:(event arguments)
	withFocusOn:focusViewOrNil
	delegate:doDelegate


!

noticeOfWindowClose:aWindow
    "sent when a topView or applicationSubView has been closed.
     Can be redefined in subclasses for cleanup."

    "/ ST-80 compatibility
    self windowEvent:(#close -> aWindow) from:aWindow.
    ^ self

    "Created: / 18.6.1998 / 18:56:31 / cg"
    "Modified: / 18.6.1998 / 19:14:16 / cg"
!

noticeOfWindowOpen:aWindow
    "sent when a topView or applicationSubView has been opened.
     Can be redefined in subclasses."

    "/ ST-80 compatibility
    self windowEvent:(#open -> aWindow) from:aWindow.
    ^ self

    "Created: / 18.6.1998 / 18:56:31 / cg"
    "Modified: / 18.6.1998 / 19:14:16 / cg"
!

processApplicationCommand:command with:argument
    "a message from a secondary application instance (the exe has been started again).
     Typically, the command is one like 'openPath:', as generated in StandaloneStartup."

    command = 'openPath' ifTrue:[
	self processOpenPathCommand:argument.
	^ self.
    ].

    Transcript showCR: 'Invalid command received: ', command.
!

processOpenPathCommand:argument
    "a message from a secondary application instance (the exe has been started again)
     to open another window on document as found in the pathName argument.
     Left blank (i.e. ignored) here, but can be redefined to open up another application
     editor window if supported."
!

processShortcut:aKeyEvent
     "a shortcut key event as forwarded from the keyboardProcessor - if there is the
      shortcut key defined, process the shortcut and return true - otherwise false."

    ^false

    "Created: / 23-07-2013 / 18:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requestForWindowClose
    "the applicationWindow wants to know, if a close
     is ok. Return false if not."

    |w k|

    builder notNil ifTrue:[
	(w := builder window) notNil ifTrue:[
	    (k := w keyboardProcessor) notNil ifTrue:[
		^ k requestForWindowClose
	    ]
	]
    ].
    ^ true

    "Modified: / 18.6.1998 / 19:14:16 / cg"
    "Created: / 19.6.1998 / 01:34:58 / cg"
!

showActivity:someMessage
    "some activityNotification shalt be communicated to
     the user. Forwarded from the topView and ignored here.
     Can be redefined in concrete applications to show the
     message either in some infoView (infoLabel as in Windows)
     or in the title area (as done in the browsers)"

    ^ self

    "Created: 16.12.1995 / 18:41:04 / cg"
    "Modified: 24.4.1996 / 09:34:22 / cg"
!

windowEvent:anEvent from:anApplicationWindow
    "dummy: windowEvent forwarding is not yet implemented"

    ^ self

    "Modified: 24.4.1996 / 09:32:50 / cg"
! !

!ApplicationModel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ApplicationModel initialize!
