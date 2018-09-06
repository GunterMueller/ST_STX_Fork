"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Behavior subclass:#ClassDescription
	instanceVariableNames:'instvars'
	classVariableNames:'UpdatingChanges LockChangesFile FileOutErrorSignal
		CatchMethodRedefinitions CatchClassRedefinitions
		UpdateChangeFileQuerySignal UpdateChangeListQuerySignal
		UpdateHistoryLineQuerySignal TryLocalSourceFirst
		ChangeFileAccessLock NameSpaceQuerySignal PackageQuerySignal
		ClassCategoryQuerySignal UsedNameSpaceQuerySignal
		CreateNameSpaceQuerySignal FileOutNameSpaceQuerySignal
		ForceNoNameSpaceQuerySignal
		ChangeDefaultApplicationNotificationSignal
		DefaultApplicationQuerySignal
		ClassConventionViolationConfirmationQuerySignal MethodHistory
		MethodHistorySize'
	poolDictionaries:''
	category:'Kernel-Classes'
!

Notification subclass:#PackageRedefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ClassDescription
!

ClassDescription::PackageRedefinition subclass:#MethodRedefinitionNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ClassDescription
!

ClassDescription::PackageRedefinition subclass:#ClassRedefinitionNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ClassDescription
!

!ClassDescription class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
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
    ClassDescription conceptually adds some descriptive information to the basic
    Behavior class. It is an abstract class used as a common superclass
    for Metaclass and Class.
    Subclasses must define the #name, #category and #comment methods.

    [Instance variables:]

	instvars        <String>        the names of the instance variables
			| <Collection of words>


    [Class variables:]

	UpdatingChanges <Boolean>       true if the changes-file shall be updated
					(except during startup and when filing in, this flag
					 is usually true)
					Please do no longer use this - see the two queries
					below.

	UpdateChangeFileQuerySignal     used as an upQuery from the change management.
					Whenever a changeRecord is to be written,
					this signal is raised and a handler (if present)
					is supposed to return true or false.
					If unhandled, the value of the global
					UpdatingChanges is returned for backward
					compatibility (which means that the old
					mechanism is used if no query-handler
					is present).

	UpdateChangeListQuerySignal     used as an upQuery from the change management.
					Whenever a change is to be added to the changeSet,
					this signal is raised and a handler (if present)
					is supposed to return true or false.
					If unhandled, the value of the global
					UpdatingChanges is returned for backward
					compatibility (which means that the old
					mechanism is used if no query-handler
					is present).

	LockChangesFile <Boolean>       if true, the change file is locked for updates.
					Required when multiple users operate on a common
					change file.
					This is an experimental new feature, being evaluated.

	FileOutErrorSignal              raised when an error occurs during fileOut

	CatchMethodRedefinitions        if true, classes protect themself
	MethodRedefinitionSignal        (by raising MethodRedefinitionSignal)
					from redefining any existing methods,
					which are defined in another package.
					(i.e. a signal will be raised, if you
					 fileIn something which redefines an
					 existing method and the packages do not
					 match).
					The default is (currently) true.

	TryLocalSourceFirst             If true, local source files are tried
					first BEFORE the sourceCodeManager is
					consulted. If false, the sourceCodeManager
					is asked first.
					Should be turned on, if you run an image from
					local sources which have not yet been checked in.

	NameSpaceQuerySignal            used as an upQuery to ask for a namespace into
					which new classes are to be installed.

	PackageQuerySignal              used as an upQuery to ask for a packageSymbol with
					which new classes/methods are to be marked.

	CreateNameSpaceQuerySignal      used as an upQuery to ask if unknown namespaces
					should be silently created (without asking the user)

	MethodHistory                   if nonNil, this must be an OrderedCollection,
					which is filled with method->previousversionMethod
					associations. Can be used for undo-last-method-change
					The number of remembered methods is controlled via the
					UserPreferences.
					Notice: this may fillup your memory over time,
					the preferences are set too high.

	MethodHistorySize               the size of the methodHistory
					(nil: unlimited)

    [author:]
	Claus Gittinger

    [see also:]
	Behavior Class Metaclass
"
! !

!ClassDescription class methodsFor:'initialization'!

initialize
    "the classvariable 'UpdatingChanges' controls if changes are put
     into the changes-file; normally this variable is set to true, but
     (for example) during fileIn or when changes are applied, it is set to false
     to avoid putting too much junk into the changes-file."

    UpdatingChanges := true.
    LockChangesFile := false.
    CatchMethodRedefinitions := CatchClassRedefinitions := true.
    TryLocalSourceFirst := false.

    FileOutErrorSignal isNil ifTrue:[
        FileOutErrorSignal := Error newSignalMayProceed:true.
        FileOutErrorSignal nameClass:self message:#fileOutErrorSignal.
        FileOutErrorSignal notifierString:'error during fileOut'.

"/        MethodRedefinitionSignal := QuerySignal new.
"/        MethodRedefinitionSignal nameClass:self message:#methodRedefinitionSignal.
"/        MethodRedefinitionSignal notifierString:'attempt to redefine method from different package'.
"/        MethodRedefinitionSignal defaultAnswer:#keep.

"/        ClassRedefinitionSignal := QuerySignal new.
"/        ClassRedefinitionSignal nameClass:self message:#classRedefinitionSignal.
"/        ClassRedefinitionSignal notifierString:'attempt to redefine class from different package'.
"/        ClassRedefinitionSignal defaultAnswer:#keep.

        UpdateHistoryLineQuerySignal := QuerySignal new.
        UpdateHistoryLineQuerySignal nameClass:self message:#updateHistoryLineQuerySignal.
        UpdateHistoryLineQuerySignal notifierString:'asking if history line update in method is wanted'.
        UpdateHistoryLineQuerySignal handlerBlock:[:ex | ex proceedWith:false].

        UpdateChangeFileQuerySignal := QuerySignal new.
        UpdateChangeFileQuerySignal nameClass:self message:#updateChangeFileQuerySignal.
        UpdateChangeFileQuerySignal notifierString:'asking if changeFile update is wanted'.
        UpdateChangeFileQuerySignal handlerBlock:[:ex | ex proceedWith:UpdatingChanges].

        UpdateChangeListQuerySignal := QuerySignal new.
        UpdateChangeListQuerySignal nameClass:self message:#updateChangeListQuerySignal.
        UpdateChangeListQuerySignal notifierString:'asking if changeList update is wanted'.
        UpdateChangeListQuerySignal handlerBlock:[:ex | ex proceedWith:UpdatingChanges].

        NameSpaceQuerySignal isNil ifTrue:[
            "This could be used BEFORE initialize has been invoked - that's why we initialize
             the class var there."
            NameSpaceQuerySignal := self nameSpaceQuerySignal
        ].
        UsedNameSpaceQuerySignal isNil ifTrue:[
            "This could be used BEFORE initialize has been invoked - thats why we initialize
             the class var there."
            UsedNameSpaceQuerySignal := self usedNameSpaceQuerySignal.
        ].

        CreateNameSpaceQuerySignal := QuerySignal new.
        CreateNameSpaceQuerySignal nameClass:self message:#createNameSpaceQuerySignal.
        CreateNameSpaceQuerySignal notifierString:'asking for nameSpace creation'.
        CreateNameSpaceQuerySignal defaultAnswer:false.

        ClassConventionViolationConfirmationQuerySignal := QuerySignal new.
        ClassConventionViolationConfirmationQuerySignal nameClass:self message:#classConventionViolationConfirmationQuerySignal.
        ClassConventionViolationConfirmationQuerySignal notifierString:'asking for class convention'.

        PackageQuerySignal := QuerySignal new.
        PackageQuerySignal nameClass:self message:#packageQuerySignal.
        PackageQuerySignal notifierString:'asking for package'.
        PackageQuerySignal handlerBlock:[:ex | ex proceedWith:(Project isNil
                                                                    ifTrue:[
                                                                        nil
                                                                    ] ifFalse:[
                                                                        Project currentPackageName
                                                                    ])].

        ClassCategoryQuerySignal := QuerySignal new.
        ClassCategoryQuerySignal nameClass:self message:#classCategoryQuerySignal.
        ClassCategoryQuerySignal notifierString:'asking for category'.
        ClassCategoryQuerySignal handlerBlock:[:ex | ex proceedWith:'* as yet unspecified *'].

        FileOutNameSpaceQuerySignal := QuerySignal new.
        FileOutNameSpaceQuerySignal defaultAnswer:false.

        ForceNoNameSpaceQuerySignal := QuerySignal new.
        ForceNoNameSpaceQuerySignal defaultAnswer:false.

        ChangeFileAccessLock := RecursionLock new.
        ChangeFileAccessLock name:'ChangeFileAccessLock'.
    ].

    DefaultApplicationQuerySignal isNil ifTrue:[
        DefaultApplicationQuerySignal := QuerySignal new defaultAnswer:nil.
        DefaultApplicationQuerySignal nameClass:self message:#defaultApplicationQuerySignal.
        DefaultApplicationQuerySignal notifierString:'query for default application'.

        ChangeDefaultApplicationNotificationSignal := QuerySignal new defaultAnswer:nil.
        ChangeDefaultApplicationNotificationSignal nameClass:self message:#changeDefaultApplicationNotificationSignal.
        ChangeDefaultApplicationNotificationSignal notifierString:'change default application'.
    ].

    "
     ClassDescription initialize
    "

    "Created: / 02-04-1997 / 17:27:40 / stefan"
    "Modified: / 17-03-1999 / 16:52:41 / stefan"
    "Modified: / 17-08-2006 / 14:04:17 / cg"
! !

!ClassDescription class methodsFor:'Signal constants'!

changeDefaultApplicationNotificationSignal
    "return the signal used as an up-Info to change the current application to which
     new classes/methods will be added.
     Will is only used when filing in V'Age code"

    ^ ChangeDefaultApplicationNotificationSignal

    "
     Transcript showCR:Class changeDefaultApplicationNotificationSignal raise
    "

    "Modified: / 5.11.1996 / 20:08:38 / cg"
    "Created: / 15.6.1998 / 18:29:57 / cg"
!

classCategoryQuerySignal
    "return the signal used as an upQuery for the current class category name.
     Will be used when defining a class without a proper classCategory information
     (JS or Ruby classes). The browser will answer with the currently selected category then."

    ^ ClassCategoryQuerySignal

    "
     Transcript showCR:Class classCategoryQuerySignal raise
    "
!

classConventionViolationConfirmationQuerySignal
    "return the query signal raised when a class is about to be installed
     (or changed) which violates conventions (such as upper case instVars).
     This is raised in subclass creation and can be handled to suppress
     dialog boxes popping up during fileIn"

    ^ ClassConventionViolationConfirmationQuerySignal

    "Created: / 3.2.1999 / 11:22:07 / cg"
!

classRedefinitionNotification
    "return the signal raised when a class is about to be redefined
     differently from an existing class and the packages are not
     equal. This helps when filing in alien code, to prevent existing
     classes from being redefined by incompatible classes
     (classVars, classInstVars or inheritance)."

    ^ ClassDescription::ClassRedefinitionNotification

    "Created: / 17.6.1998 / 10:13:44 / cg"
!

classRedefinitionSignal
    "use #classRedefinitionNotification"
    <resource: #obsolete>

    ^ ClassDescription::ClassRedefinitionNotification

    "Created: / 17.6.1998 / 10:13:44 / cg"
!

createNameSpaceQuerySignal
    "return the signal used as an upQuery if a new nameSpace should be
     silently created without user confirmation.
     Only used when installing autoloaded classes"

    ^ CreateNameSpaceQuerySignal

    "Created: 2.4.1997 / 17:27:54 / stefan"
!

defaultApplicationQuerySignal
    "return the signal used as an upQuery for the current application to which
     new classes/methods are to be added.
     Will is only used when filing in V'Age code"

    ^ DefaultApplicationQuerySignal

    "
     Transcript showCR:Class defaultApplicationQuerySignal raise
    "

    "Modified: / 5.11.1996 / 20:08:38 / cg"
    "Created: / 15.6.1998 / 18:28:54 / cg"
!

fileOutErrorSignal
    "return the signal raised when an error occurs while fileing out.
     This is signalled to allow browsers some user feed back in case
     a fileout fails (for example due to disk-full errors)"

    ^ FileOutErrorSignal

    "Created: 2.4.1997 / 17:28:03 / stefan"
!

fileOutNameSpaceQuerySignal
    "return the signal used as an upQuery whether the current
     namespace should be prepended on fileOut."

    ^ FileOutNameSpaceQuerySignal

    "
     Transcript showCR:Class fileOutNameSpaceQuerySignal raise
    "

    "Modified: / 05-11-1996 / 20:08:38 / cg"
    "Created: / 02-04-1997 / 17:28:41 / stefan"
    "Modified (comment): / 27-07-2013 / 15:35:32 / cg"
!

forceNoNameSpaceQuerySignal
    ^ ForceNoNameSpaceQuerySignal
!

methodRedefinitionNotification
    "return the signal raised when a method is about to be installed
     which redefines an existing method and the methods packages are not
     equal. This helps when filing in alien code, to prevent existing
     methods to be overwritten or redefined by incompatible methods"

    ^ ClassDescription::MethodRedefinitionNotification
!

methodRedefinitionSignal
    "use #methodRedefinitionNotification"
    <resource: #obsolete>

    ^ ClassDescription::MethodRedefinitionNotification
!

nameSpaceQuerySignal
    "return the signal used as an upQuery for the current nameSpace.
     Will be used when filing in code.
     This could be used BEFORE initialize has been invoked - that's why we do not
     simply return the class var here."

    NameSpaceQuerySignal isNil ifTrue:[
        NameSpaceQuerySignal := QuerySignal new.
        NameSpaceQuerySignal nameClass:self message:#nameSpaceQuerySignal.
        NameSpaceQuerySignal notifierString:'asking for nameSpace'.
        NameSpaceQuerySignal handlerBlock:[:ex | ex proceedWith:Project defaultNameSpace].
    ].
    ^ NameSpaceQuerySignal

    "
     Transcript showCR:Class nameSpaceQuerySignal raise
    "

    "Modified: / 17-08-2006 / 14:03:39 / cg"
!

packageQuerySignal
    "return the signal used as an upQuery for the current packages name.
     Will be used when filing in code"

    PackageQuerySignal isNil ifTrue:[ ClassDescription initialize ].
    ^ PackageQuerySignal

    "
     Transcript showCR:Class packageQuerySignal raise
    "

    "Created: 5.11.1996 / 20:07:22 / cg"
    "Modified: 5.11.1996 / 20:08:35 / cg"
!

packageRedefinitionNotification
    "return the signal raised when a class or method is about to be installed
     which redefines an existing method and the methods packages are not
     equal. This helps when filing in alien code, to prevent existing
     methods to be overwritten or redefined by incompatible methods"

    ^ ClassDescription::PackageRedefinition
!

updateChangeFileQuerySignal
    "return the signal used as an upQuery if the changeFile should be updated.
     If unhandled, the value of UpdatingChanges is returned by the signals
     static handler."

    ^ UpdateChangeFileQuerySignal

    "
     Transcript showCR:Class updateChangeFileQuerySignal raise
    "

    "Modified: 5.11.1996 / 20:08:44 / cg"
!

updateChangeListQuerySignal
    "return the signal used as an upQuery if the changeList should be updated.
     If unhandled, the value of UpdatingChanges is returned by the signals
     static handler."

    ^ UpdateChangeListQuerySignal

    "
     Transcript showCR:Class updateChangeListQuerySignal raise
    "
!

updateHistoryLineQuerySignal
    "return the signal used as an upQuery if the historyline of a method should be updated.
     If unhandled, the history managers setting is returned by the signals
     static handler."

    ^ UpdateHistoryLineQuerySignal

    "
     Class updateHistoryLineQuerySignal raise
    "

    "Created: / 05-07-2006 / 17:30:52 / cg"
!

usedNameSpaceQuerySignal
    "return the signal used as an upQuery for the used nameSpace.
     Will be used when filing in code.
     This could be used BEFORE initialize has been invoked - that's why we do not
     simply return the class var here."

    UsedNameSpaceQuerySignal isNil ifTrue:[
        UsedNameSpaceQuerySignal := QuerySignal new.
        UsedNameSpaceQuerySignal nameClass:self message:#usedNameSpaceQuerySignal.
        UsedNameSpaceQuerySignal notifierString:'asking for used nameSpaced'.
    ].
    ^ UsedNameSpaceQuerySignal

    "Created: / 19-12-1996 / 23:57:27 / cg"
    "Modified: / 17-08-2006 / 14:03:33 / cg"
! !

!ClassDescription class methodsFor:'accessing-flags'!

catchClassRedefinitions
    "return the class-redefinition catching flag."

    ^ CatchClassRedefinitions

    "Created: / 17.6.1998 / 10:30:01 / cg"
!

catchClassRedefinitions:aBoolean
    "turn on/off class redefinition catching.
     If on, redefining classes from another package will show a
     warning dialog. Useful, when filing in alien code to avoid defefinition
     of system methods.
     Return the prior value of the flag."

    |prev|

    prev := CatchClassRedefinitions.
    CatchClassRedefinitions := aBoolean.
    ^ prev

    "Created: / 17.6.1998 / 10:31:19 / cg"
!

catchMethodRedefinitions
    "return the method-redefinition catching flag."

    ^ CatchMethodRedefinitions

    "Modified: / 17.6.1998 / 10:30:10 / cg"
!

catchMethodRedefinitions:aBoolean
    "turn on/off method redefinition catching.
     If on, redefining methods from another package will show a
     warning dialog. Useful, when filing in alien code to avoid defefinition
     of system methods.
     Return the prior value of the flag."

    |prev|

    prev := CatchMethodRedefinitions.
    CatchMethodRedefinitions := aBoolean.
    ^ prev

    "Modified: / 17.6.1998 / 10:31:02 / cg"
!

keepMethodHistory:aBoolean
    "turn on/off oldMethod remembering. If on, a methods previous version
     is kept locally, for later undo (or compare)."

    aBoolean ifTrue:[
	MethodHistory isNil ifTrue:[
	    MethodHistory := OrderedCollection new.
	]
    ] ifFalse:[
	MethodHistory := nil
    ].

    "
     Class keepMethodHistory:true
     Class keepMethodHistory:false
    "

    "Modified: 7.11.1996 / 18:36:00 / cg"
    "Created: 7.11.1996 / 19:05:57 / cg"
!

lockChangesFile
    "return true, if the change file is locked during update"

    ^ LockChangesFile
!

lockChangesFile:aBoolean
    "turn on/off change-file-locking. Return the previous value of the flag."

    |prev|

    prev := LockChangesFile.
    LockChangesFile := aBoolean.
    ^ prev
! !

!ClassDescription class methodsFor:'accessing-history'!

flushMethodHistory
    "flush any method->previousVersion associations,
     all method history is lost."

    MethodHistory notNil ifTrue:[
	MethodHistory := OrderedCollection new
    ].

    "Created: 7.11.1996 / 19:07:25 / cg"
!

methodHistory
    "return a dictionary containing method->previousVersion associations,
     nil if method remembering has been turned off"

    ^ MethodHistory

    "
     Class methodHistory
    "

    "Modified: 7.11.1996 / 18:36:00 / cg"
    "Created: 7.11.1996 / 19:06:28 / cg"
! !

!ClassDescription class methodsFor:'enumeration'!

allClassesInCategory:aCategory do:aBlock
    "evaluate aBlock for all classes in aCategory;
     no specific order is defined."

    <resource: #obsolete>
    self obsoleteMethodWarning:'moved to Smalltalk'.
    Smalltalk allClassesInCategory:aCategory do:aBlock

    "
     Class allClassesInCategory:'Kernel-Classes'
			     do:[:class |Transcript showCR:class name]
    "

    "Created: / 1.4.1997 / 23:45:09 / stefan"
    "Modified: / 17.11.2001 / 12:28:50 / cg"
!

allClassesInCategory:aCategory inOrderDo:aBlock
    "evaluate aBlock for all classes in aCategory;
     superclasses come first - then subclasses."

    <resource: #obsolete>
    self obsoleteMethodWarning:'moved to Smalltalk'.
    Smalltalk allClassesInCategory:aCategory inOrderDo:aBlock

    "Created: / 1.4.1997 / 23:45:15 / stefan"
    "Modified: / 17.11.2001 / 12:28:40 / cg"
! !

!ClassDescription class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == ClassDescription class or:[self == ClassDescription]

    "Created: 15.4.1996 / 17:16:59 / cg"
    "Modified: 23.4.1996 / 15:56:54 / cg"
! !


!ClassDescription methodsFor:'Compatibility-Dolphin'!

methodsFor
    "this method allows fileIn of Dolphin methods -
     return a ClassCategoryReader to read in and compile methods for me.
     Since Dolphin uses a different way to assign method categories,
     the loaded methods are temporarily categorized as 'Dolphin methods'
     and later reassigned, when a categoriesFor: message arrives."

    ^ ClassCategoryReader class:self category:'Dolphin methods'

!

sourceManager
    "Answer the receiver's source manager."

    ^ Dolphin::SourceManager default
! !

!ClassDescription methodsFor:'Compatibility-ST80'!

addInstVarName:anotherInstVar
    ^ self addInstVarName:anotherInstVar afterIndex: nil

    "Modified: / 25-02-2009 / 14:51:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-01-2011 / 17:57:23 / cg"
    "Modified: / 31-01-2014 / 02:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addInstVarName:anotherInstVar afterIndex: indexOrNil
    |newClass newNames|

    indexOrNil notNil ifTrue:[ 
        | oldNames |

        oldNames := self instVarNames asOrderedCollection.
        oldNames := oldNames add: anotherInstVar afterIndex: (indexOrNil min: oldNames size).
        newNames := oldNames asStringWith:' '.  
    ] ifFalse:[ 
        newNames := self instanceVariableString , ' ' , anotherInstVar.
    ].

    self isMeta ifTrue:[
        ^ self instanceVariableNames:newNames.
    ].
    "Jan Vrany: I replaced original Claus code.
     See comment at the end of this method"
    newClass := self theMetaclass
                    name:self nameWithoutPrefix 
                    inEnvironment:self nameSpace
                    subclassOf:self superclass
                    instanceVariableNames: newNames
                    variable:self isVariable
                    words:self isWords
                    pointers:self isPointers
                    classVariableNames:self classVariableString
                    poolDictionaries: (self poolDictionaries)
                    category:self category
                    comment:self comment
                    changed:true.
    newClass isNil 
        ifTrue:[self error:'oops - cannot compile newClass'] 
        ifFalse:[newClass recompile].

    ^newClass



    "
    Wrong implementation - does not respect
    my metaclass, my superclasses's metaclass is
    used. So, adding instvar to javascript/ruby
    class makes it a normal smalltalk class. 
    "
    "sel := self definitionSelector.
    Class nameSpaceQuerySignal answer:(self nameSpace)
    do:[
        args := Array
                    with:(self nameWithoutPrefix asSymbol)
                    with:newNames
                    with:(self classVariableString)
                    with:''
                    with:(self category).

        sel numArgs == 6 ifTrue:[
            args := args copyWith:(self owningClass).
        ].

        newClass := self superclass
            perform:sel withArguments:args.
        newClass isNil ifTrue:[
            self error:'oops - cannot compile newClass'.
        ] ifFalse:[
            newClass recompile.
        ]
    ].

    ^ newClass
    "

    "Created: / 31-01-2014 / 01:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-02-2014 / 18:12:25 / cg"
!

organization
    "for ST80 compatibility;
     read the documentation in ClassOrganizer for more info."

    ^ ClassOrganizer for:self
!

preSave: aParcel
	"Allow additional process of a Parcel before writing. This method works
	with the matching method postLoad:, to handle additional processing
	after loading a Parcel. The typical operation to do here is to save
	named objects to aParcel (and retrieve them in postLoad:)."
!

removeInstVarName:anInstVar
    |newClass newNames|

    newNames := self instVarNames asOrderedCollection.
    newNames remove:anInstVar ifAbsent:[^ self].
    newNames := newNames asStringWith:Character space.

    self isMeta ifTrue:[
        ^ self instanceVariableNames:newNames.
    ].

    Class nameSpaceQuerySignal answer:(self nameSpace)
    do:[
        |args sel|

        args := Array
                    with:(self nameWithoutPrefix asSymbol)
                    with:newNames
                    with:(self classVariableString)
                    with:(self isClass ifTrue:[self poolDictionaries] ifFalse:[''])
                    with:(self category).

        sel := self definitionSelector.
        sel numArgs == 6 ifTrue:[
            args := args copyWith:(self owningClass).
        ].

        newClass := self superclass perform:sel withArguments:args.
        newClass recompile.
    ].

    ^ newClass
!

reorganize
    "for ST80 compatibility;
     nothing done here."
!

reorganizeFromString:orgString
    "for ST80 compatibility but without functionality"

    "Created: / 28.3.1998 / 21:21:52 / cg"
! !

!ClassDescription methodsFor:'Compatibility-Squeak'!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString category:cat
    ^ self subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries: '' category:cat

    "Created: / 24-07-2015 / 19:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !
!ClassDescription methodsFor:'Compatibility-V''Age'!

categoriesFor:aSelector are:listOfCategories
    "to allow fileIn of V'Age code.
     Set the category of the method which is installed under aSelector.
     Since ST/X only supports a single category, take the first one
     found in the listOfCategories."

    |mthd|

    (mthd := self compiledMethodAt:aSelector) notNil ifTrue:[
	mthd category:listOfCategories first.
    ].

    "Created: / 15.6.1998 / 17:11:02 / cg"
    "Modified: / 15.6.1998 / 20:32:28 / cg"
!

commentFor:aSelector is:aString
    "to allow fileIn of V'Age code.
     Set the comment of the method which is installed under aSelector.
     For now, this is ignored"

    |mthd|

    (mthd := self compiledMethodAt:aSelector) notNil ifTrue:[
	"/ mthd comment:aString
    ].

    "Created: / 15.6.1998 / 17:11:02 / cg"
    "Modified: / 15.6.1998 / 20:34:39 / cg"
!

description:aString in:anApplication
    "to allow fileIn of V'Age code.
     Set the description of the class."

    "/ since ST/X has no description, we could add it as a class-documentation
    "/ method under the selector #description.
    "/ for now, this is ignored.

    ^ self.

    "Modified: / 15.6.1998 / 17:14:53 / cg"
    "Created: / 15.6.1998 / 20:34:02 / cg"
!

descriptionFor:aSelector is:aString
    "to allow fileIn of V'Age code.
     Set the description of the method which is installed under aSelector."

    "/ since ST/X has no description, we could add it as a class-documentation
    "/ method under the selector #description.
    "/ for now, this is ignored.

"/    |newString code|
"/
"/
"/    newString := aString copy replaceAll:$" with:$'.
"/    code := 'description
"/"
"/ ' , aString , '
"/"'.
"/    self compile:code forClass:self class inCategory:#documentation

    ^ self.

    "Modified: / 15.6.1998 / 17:14:53 / cg"
!

initializeAfterLoad
    "this message is sent after fileIn of a V'Age class"

    self initialize

    "Modified: / 15.6.1998 / 20:35:58 / cg"
    "Created: / 15.6.1998 / 20:36:49 / cg"
! !

!ClassDescription methodsFor:'Compatibility-VW'!

compile: aString classified: protocol attributes: attributes
    "compile some method-code"

    |mthd|

    mthd := self compile: aString classified: protocol.
    attributes notEmpty ifTrue:[
	attributes keysAndValuesDo:[:aK :aV |
	    aK = 'package' ifTrue:[
		"/ mthd package:aV
	    ] ifFalse:[
		self error:(aK , '-attribute not yet supported') mayProceed:true.
	    ].
	].
    ].

    ^ mthd.
!

defineSharedVariable:name private:private constant:constant category:category initializer:initializer 
    self addClassVarName:name.
    initializer notNil ifTrue:[
        self shouldImplement
    ].
!

defineStatic:name private:private constant:constant category:category initializer:initializer attributes:annotations
    self addClassVarName:name.
    initializer notNil ifTrue:[
	self shouldImplement
    ].
!

instVarIndexFor:aVariableName ifAbsent:exceptionValue
    "alias for #instVarOffsetOf: for VW compatibility."

    |idx|

    idx := self instVarIndexFor:aVariableName.
    idx isNil ifTrue:[ ^ exceptionValue value ].
    ^ idx

    "
     Point instVarIndexFor:#x
     Point instVarIndexFor:#x ifAbsent:[123] 1
     Point instVarIndexFor:#z ifAbsent:[123]
    "

    "Created: / 12-09-2011 / 08:44:19 / cg"
! !

!ClassDescription methodsFor:'accessing'!

definition
    "return an expression-string to define myself"

    |s|

    s := WriteStream on:''.
    self fileOutDefinitionOn:s.
    ^ s contents

    "
     Object definition
     Point definition
     Array definition
     ByteArray definition
     FloatArray definition
     OpenGLConstantImporter definition
    "

    "Created: / 19.6.1998 / 02:25:49 / cg"
    "Modified: / 29.7.1998 / 12:13:44 / cg"
!

definitionWithoutPackage
    "return an expression-string to define myself (but not the package)"

    ^ String streamContents:[:s |
        self theNonMetaclass
            basicFileOutDefinitionOn:s
            withNameSpace:false
            withPackage:false
    ]

    "
     Object definition
     Point definition
     Array definition
     ByteArray definition
     FloatArray definition
     OpenGLConstantImporter definition
    "

    "Created: / 31-08-2011 / 09:26:09 / cg"
!

instVarAtOffset:index
    "return the name of the instance variable at index"

    ^ self allInstanceVariableNames at:index
!

instVarIndexFor:aVariableName
    "return the index (as used in instVarAt:/instVarAt:put:) of a named instance
     variable (1..instSize) for valid variable names, nil for illegal names."

    |i cls vars|

    cls := self.
    [cls notNil] whileTrue:[
        vars := cls instVarNames.
        i := vars indexOf:aVariableName.
        i ~~ 0 ifTrue:[
            ^ (cls superclass instSize) + i
        ].
        cls := cls superclass
    ].
    ^ nil

    "
     Point instVarIndexFor:'x'
     View instVarIndexFor:'paint'
     Button instVarIndexFor:'logo'
    "

    "Modified: 23.8.1997 / 16:59:15 / cg"
!

instVarNames
    "return a collection of the instance variable name-strings.
     Traditionally, this was called instVarNames, but newer versions of squeak
     seem to have changed to use instanceVariableNames. 
     So you probably should use the alias"

    instvars isNil ifTrue:[
        ^ #()
    ].
    instvars isString ifTrue:[
        instvars isEmpty ifTrue:[
            instvars := #().
        ] ifFalse:[
            instvars := instvars asCollectionOfWords collect:[:varName| varName asSymbol] as:Array.
        ].
    ].

    ^ instvars

    "
     Point instVarNames
     SortedCollection instVarNames
     SortedCollection allInstVarNames
    "

    "Modified: 22.8.1997 / 17:43:05 / cg"
!

instVarOffsetOf:aVariableName
    <resource: #obsolete>
    "return the index (as used in instVarAt:/instVarAt:put:) of a named instance
     variable (1..instSize) for valid variable names, nil for illegal names.
     This was the original ST/X's method for this functionality; senders have been changed to use instVarIndexFor:.
     Kept for backward compatibility; please use instVarIndexFor: for VW and Squeak compatibility"

    self obsoleteMethodWarning.

    ^ self instVarIndexFor:aVariableName

    "Modified: 23.8.1997 / 16:59:15 / cg"
!

instanceVariableOffsets
    "returns a dictionary containing the instance variable index
     for each instVar name"

    |dict index|

    index := 0. dict := Dictionary new.
    self allInstVarNames do:[:nm | index := index + 1. dict at:nm put:index].
    ^ dict

    "
     Point instanceVariableOffsets
     GraphicsContext instanceVariableOffsets
    "
!

instanceVariableString
    "return a string of the instance variable names"

    instvars isNil ifTrue:[^ ''].
    instvars isString ifTrue:[
	^ instvars
    ].

    ^ instvars asStringWith:(Character space)

    "
     Point instanceVariableString
    "

    "Modified: 22.8.1997 / 14:59:14 / cg"
!

nameSpace
    "should be redefined in concrete subclass(es)"

    ^ nil
!

projectDefinitionClass
    "return the project definition of the classes' package.
     Here, nil is returned. Only full classes have one."

    ^ nil
!

renameCategory:oldCategory to:newCategory
    "{ Pragma: +optSpace }"

    "rename a category (changes category of those methods).
     Appends a change record and notifies dependents."

    |any|

    any := false.
    self methodDictionary do:[:aMethod |
	aMethod category = oldCategory ifTrue:[
	    aMethod category:newCategory.
	    any := true.
	]
    ].
    any ifTrue:[
	self addChangeRecordForRenameCategory:oldCategory to:newCategory.
    ]

    "Modified: 12.6.1996 / 11:49:08 / stefan"
    "Created: 3.6.1997 / 11:55:05 / cg"
!

sharedPoolNames
    ^ #()
!

typeOfClassVarNamed:classVarName
    "option to return a collection of types which are considered
     legal for classVarName.
     This is pure documentation, and has (currently) no semantic implications.
     If present, it is used by the code completer's type inferer, 
     to make better guesses.
     Subclasses may redefine it to return a class, interface or a set of classes."

    ^ nil
!

typeOfInstVarNamed:instVarName
    "option to return a collection of types which are considered
     legal for instVarName.
     This is pure documentation, and has (currently) no semantic implications.
     If present, it is used by the code completer's type inferer, 
     to make better guesses.
     Subclasses may redefine it to return a class, interface or a set of classes."

    ^ nil

    "
     Class typeOfInstVarNamed:'instSize' -> SmallInteger
    "
! !

!ClassDescription methodsFor:'adding & removing'!

addSelector:newSelector withMethod:newMethod
    "add the method given by 2nd argument under the selector given by
     1st argument to the methodDictionary.
     Append a change record to the changes file and tell dependents."

    |oldMethod oldPackage newPackage|

    oldMethod := self compiledMethodAt:newSelector.

    CatchMethodRedefinitions ifTrue:[
        "check for attempts to redefine a method
         in a different package. Signal a resumable error if so.
         This allows tracing redefinitions of existing system methods
         when filing in alien code ....
         (which we may want to forbid sometimes)
        "
        oldMethod notNil ifTrue:[
            oldPackage := oldMethod package.
            newPackage := newMethod package.
            (oldPackage ~= newPackage and:[oldPackage ~= PackageId noProjectID])  ifTrue:[
                |answer|
                "
                 attempt to redefine an existing method, which was
                 defined in another package (see oldPackage vs. newPackage).
                 If you continue in the debugger, the new method gets installed.
                 Otherwise, the existing (old) method remains valid.

                 This check was added to help prevent accidental modifications
                 of system code - especially, when alien code is filedIn.
                 After you became familiar with the system, may want to disable this
                 check if it becomes too annoying (and only turn it on
                 temporarily, when filing in unknown code-files).

                 You can turn off the catching of redefinitions by setting
                 my classVariable
                          CatchMethodRedefinitions
                 to false.
                 (also found in the Launchers 'settings-compilation' menu)
                "
                answer := Class methodRedefinitionNotification
                                    raiseRequestWith:(oldMethod -> newMethod)
                                    errorString:('redefinition of method: ' , self name , '>>' , newSelector).

                answer == #keep ifTrue:[
                    "accept new method definition but keep old package"
                    newMethod setPackage:oldMethod package
                ] ifFalse:[answer ~~ #continue ifTrue:[
                    "skip this method"
                    ^ nil 
                ]].
                "if continued, install as usual - and use new package"
            ]
        ]
    ].

    (super addSelector:newSelector withMethod:newMethod) ifTrue:[
        "/ only write change records for changes to non-anonymous classes
        self theNonMetaclass containingNameSpace notNil ifTrue:[
            "/ just in case addSelector:withMethod: was redefined to ignore this
            newMethod selector == newSelector ifTrue:[
                self addChangeRecordForMethod:newMethod fromOld:oldMethod.
            ]
        ]
    ].

    "Modified: / 09-09-1996 / 22:39:32 / stefan"
    "Created: / 04-06-1997 / 14:47:10 / cg"
    "Modified: / 17-08-2006 / 13:54:00 / cg"
!

basicAddSelector:newSelector withMethod:newMethod
    "add the method given by 2nd argument under the selector given by
     1st argument to the methodDictionary.
     This does NOT append a change record to the changes file and tell
     dependents. Also, no methodHistory is kept or redefinition is checked."

    super addSelector:newSelector withMethod:newMethod

    "Created: 2.4.1997 / 01:01:08 / stefan"
!

removeSelector:aSelector
    "remove the selector, aSelector and its associated method
     from the methodDictionary.
     Append a change record to the changes file and tell dependents."

    |oldMethod|

    oldMethod := self compiledMethodAt:aSelector.

    MethodHistory notNil ifTrue:[
        oldMethod notNil ifTrue:[
            MethodHistory add:(Array with:#methodRemove with:oldMethod).
            (MethodHistorySize notNil and:[MethodHistory size > MethodHistorySize]) ifTrue:[
                MethodHistory removeFirst.
            ]
        ]
    ].

    (super removeSelector:aSelector) ifTrue:[
        "/ only write change records for changes to non-anonymous classes
        self theNonMetaclass containingNameSpace notNil ifTrue:[
            self addChangeRecordForRemoveSelector:aSelector fromOld:oldMethod.
            "/
            "/ also notify a change of mySelf;
            "/
            self changed:#methodDictionary with:aSelector.

            "/
            "/ also notify a change of Smalltalk;
            "/ this allows a dependent of Smalltalk to watch all class
            "/ changes (no need for observing all classes)
            "/ - this allows for watchers to find out if its a new method or a method-change
            "/
            MethodRemoveChangeNotificationParameter notNil ifTrue:[
                Smalltalk changed:#methodInClassRemoved with:(MethodRemoveChangeNotificationParameter changeClass:self changeSelector:aSelector).
            ]
        ]
    ]

    "Modified: 8.1.1997 / 23:03:49 / cg"
    "Created: 2.4.1997 / 00:59:29 / stefan"
! !

!ClassDescription methodsFor:'c function interfacing'!

cInterfaceFunction:selector calling:cFunctionNameString args:argTypeArray returning:returnType
    "{ Pragma: +optSpace }"

    "create an interface to an existing (i.e. already linked in) c function.
     The function can be called by sending selector to the receiver class.
     The c-function has the name cFunctionNameString, and expects parameters as specified in
     argTypeArray. The functions return value has a type as specified by returnType.
     WARNING:
	this interface is EXPERIMENTAL - it may change or even be removed."

    StubGenerator isNil ifTrue:[
	^ self error:'this system does not support dynamic C Interface functions'.
    ].

    StubGenerator
	createStubFor:selector
	calling:cFunctionNameString
	args:argTypeArray
	returning:returnType
	in:self

    "
     Object subclass:#CInterface
	    instanceVariableNames:''
	    classVariableNames:''
	    poolDictionaries:''
	    category:'Examples'.

     CInterface cInterfaceFunction:#printfOn:format:withFloat:
			   calling:'fprintf'
			      args:#(ExternalStream String Float)
			 returning:#SmallInteger.

     CInterface printfOn:Stdout format:'this is a float: %g' withFloat:(Float pi). Stdout cr
    "

    "Modified: 5.1.1997 / 19:58:22 / cg"
    "Created: 2.4.1997 / 00:57:40 / stefan"
! !

!ClassDescription methodsFor:'changes management'!

addChangeRecordForMethod:aMethod
    "{ Pragma: +optSpace }"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use addChangeRecordForMethod:fromOld:'.

    "add a method-change-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
        self writingChangePerform:#addChangeRecordForMethod:to: with:aMethod.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
        UpdateChangeListQuerySignal query ifTrue:[
            Project addMethodChange:aMethod in:self
        ]
    ]

    "Modified: / 20.1.1997 / 12:36:02 / cg"
    "Created: / 2.4.1997 / 01:02:16 / stefan"
    "Modified: / 18.3.1999 / 18:16:41 / stefan"
!

addChangeRecordForMethod:aMethod fromOld:oldMethod
    "{ Pragma: +optSpace }"

    "add a method-change-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForMethod:to: with:aMethod.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addMethodChange:aMethod fromOld:oldMethod in:self
	]
    ]

    "Modified: / 20.1.1997 / 12:36:02 / cg"
    "Created: / 2.4.1997 / 01:02:16 / stefan"
    "Modified: / 18.3.1999 / 18:16:41 / stefan"
!

addChangeRecordForMethodCategory:aMethodOrSelector category:aString
    "{ Pragma: +optSpace }"

    |mthd|

    "add a methodCategory-change-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
	(mthd := aMethodOrSelector) isSymbol ifTrue:[
	    mthd := self compiledMethodAt:aMethodOrSelector
	].
	self writingChangeDo:[:aStream |
	    self addChangeRecordForMethodCategory:mthd category:aString to:aStream.
	].
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addMethodCategoryChange:mthd category:aString in:self
	]
    ].

    "Modified: / 18.3.1999 / 18:16:50 / stefan"
    "Modified: / 6.2.2000 / 17:35:01 / cg"
!

addChangeRecordForMethodPackage:aMethodOrSelector package:aPackageSymbol
    "{ Pragma: +optSpace }"

    |mthd|

    "add a methodPackage-change-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
        (mthd := aMethodOrSelector) isSymbol ifTrue:[
            mthd := self compiledMethodAt:aMethodOrSelector
        ].
        self writingChangeDo:[:aStream |
            self addChangeRecordForMethodPackage:mthd package:aPackageSymbol to:aStream.
        ].
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
        UpdateChangeListQuerySignal query ifTrue:[
            Project addMethodPackageChange:mthd package:aPackageSymbol in:self
        ]
    ].

    "Created: / 09-10-2006 / 13:52:06 / cg"
!

addChangeRecordForMethodPrivacy:aMethod
    "{ Pragma: +optSpace }"

    "add a method-privacy-change-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForMethodPrivacy:to: with:aMethod.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addMethodPrivacyChange:aMethod in:self
	]
    ]

    "Modified: / 27.8.1995 / 22:47:32 / claus"
    "Modified: / 20.1.1997 / 12:36:08 / cg"
    "Created: / 2.4.1997 / 17:30:33 / stefan"
    "Modified: / 18.3.1999 / 18:16:58 / stefan"
!

addChangeRecordForRemoveSelector:aSelector fromOld:oldMethod
    "{ Pragma: +optSpace }"

    "add a method-remove-record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForRemoveSelector:to: with:aSelector.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addRemoveSelectorChange:aSelector fromOld:oldMethod in:self
	]
    ].

    "Created: / 2.4.1997 / 17:30:47 / stefan"
    "Modified: / 16.2.1998 / 12:45:45 / cg"
    "Modified: / 18.3.1999 / 18:17:02 / stefan"
!

addChangeRecordForRenameCategory:oldCategory to:newCategory
    "{ Pragma: +optSpace }"

    "add a category-rename record to the changes file and to the current changeSet"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangeDo:[:aStream |
	    self addChangeRecordForRenameCategory:oldCategory to:newCategory to:aStream.
	].
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addRenameCategoryChangeIn:self from:oldCategory to:newCategory
	]
    ]

    "Created: / 2.4.1997 / 17:31:03 / stefan"
    "Modified: / 18.3.1999 / 18:17:08 / stefan"
    "Modified: / 6.2.2000 / 02:26:58 / cg"
!

addChangeTimeStampTo:aStream
    "{ Pragma: +optSpace }"

    "a timestamp - prepended to any change, except infoRecords"

    |info|

    info := 'timestamp ' , OperatingSystem getLoginName , '@' , OperatingSystem getHostName.
    self addInfoRecord:info to:aStream. aStream cr.

    "Modified: 22.3.1997 / 17:14:10 / cg"
    "Created: 3.4.1997 / 19:18:27 / stefan"
!

addInfoRecord:aMessage
    "{ Pragma: +optSpace }"

    "add an info-record (snapshot, class fileOut etc.) to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangeWithTimeStamp:false
	     perform:#addInfoRecord:to:
	     with:aMessage.
    ]

    "Modified: / 24.1.1997 / 19:13:14 / cg"
    "Created: / 2.4.1997 / 17:34:18 / stefan"
    "Modified: / 18.3.1999 / 18:17:13 / stefan"
!

changesStream
    "return a Stream for the writing changes file.
     This returns a regular stream or a locked stream - according to
     the LockChangesFile settings
     (recommended if multiple images operate on a common changes file)"

    |streamType changesStream fileName
     encoding changeFileIsNew|

    fileName := ObjectMemory nameForChanges.

    LockChangesFile ifTrue:[
        streamType := LockedFileStream.
    ] ifFalse:[
        streamType := FileStream.
    ].

    [
        changesStream := streamType fileNamed:fileName.
    ] on:FileStream openErrorSignal do:[:ex|
        self warn:('%2\\Cannot create/update the changes file "%1"\please check the path and/or permissions' withCRs
                   bindWith:fileName with:ex description).
        ^ nil
    ].

    changeFileIsNew := changesStream fileSize = 0.
    changeFileIsNew ifTrue:[
        encoding := #utf8.
    ] ifFalse:[
        encoding := CharacterEncoder guessEncodingOfStream:changesStream.
        encoding isNil ifTrue:[
            encoding := #'iso8859-1'.
        ].
    ].
    changesStream setToEnd.

    changesStream := EncodedStream stream:changesStream encoding:encoding.
    changeFileIsNew ifTrue:[
        changesStream nextPutLine:'"{ Encoding: ' , encoding , ' }" !!'.
    ].

    ^ changesStream

    "Modified: 24.1.1997 / 19:14:27 / cg"
    "Created: 2.4.1997 / 17:34:13 / stefan"
!

withoutUpdatingChangeSetDo:aBlock
    "turn off changeSet update while evaluating aBlock.
     Returns the block's evaluated value."

    |retVal|

    (UpdateChangeListQuerySignal) answer:false
    do:[
        retVal := aBlock value
    ].
    ^ retVal

    "Created: / 10-08-2006 / 19:15:45 / cg"
!

withoutUpdatingChangesDo:aBlock
    "turn off change file update while evaluating aBlock.
     Returns the block's evaluated value."

    |retVal|

    (UpdateChangeFileQuerySignal, UpdateChangeListQuerySignal) answer:false
    do:[
        retVal := aBlock value
    ].
    ^ retVal

    "Modified: 17.1.1997 / 20:48:05 / cg"
    "Created: 2.4.1997 / 17:34:35 / stefan"
! !

!ClassDescription methodsFor:'compiling'!

compile:code classified:category
    "compile code, aString for this class;
     if successful update the method dictionary.
     The method is classified under category.
     Returns the new method or nil (on failure)."

    ^ self compile:code classified:category logged:true

    "Modified: 20.4.1996 / 12:30:51 / cg"
    "Created: 1.4.1997 / 23:43:57 / stefan"
!

compile:code classified:category logged:logged
    "compile code, aString for this class;
     if successful update the method dictionary.
     The method is classified under category.
     If logged is true, a changeRecord is written.
     Returns the new method or nil (on failure)."

    |compiler|

    compiler := self compilerClass.

    logged ifFalse:[
	self withoutUpdatingChangesDo:[
	    ^ compiler
		compile:code
		forClass:self
		inCategory:category
	]
    ] ifTrue:[
	^ compiler
	    compile:code
	    forClass:self
	    inCategory:category
    ].

    "Modified: 13.12.1995 / 11:02:34 / cg"
    "Created: 1.4.1997 / 23:44:02 / stefan"
!

compile:code classified:cat notifying:requestor
    "compile code, aString for this class; on any error, notify
     requestor, anObject with the error reason.
     Install the method under the category, cat.
     Returns the new method or nil (on failure)."

    ^ self compilerClass
	compile:code
	forClass:self
	inCategory:cat
	notifying:requestor

    "Modified: / 13.12.1995 / 11:02:40 / cg"
    "Created: / 18.6.1998 / 15:52:15 / cg"
!

compile:code notifying:requestor ifFail:failBlock
    "compile code, aString for this class; on any error, notify
     requestor, anObject with the error reason.
     Returns the new method or nil (on failure)."

    |rslt|

    rslt := self compilerClass
	compile:code
	forClass:self
	notifying:requestor.

    (rslt isNil or:[rslt == #Error]) ifTrue:[
	^ failBlock value
    ].
    ^ rslt

    "Modified: / 13.12.1995 / 11:02:40 / cg"
    "Created: / 8.11.1997 / 13:42:02 / cg"
!

recompile
    "{ Pragma: +optSpace }"

    "recompile all methods
     used when a class changes instances and therefore all methods
     have to be recompiled"

    self recompileUsingCompilerClass:(self compilerClass)
!

recompile:aSelector
    "{ Pragma: +optSpace }"

    "recompile the method associated with the argument, aSelector;
     used when a superclass changes instances and we have to recompile
     subclasses"

    ^ self recompile:aSelector usingCompilerClass:(self compilerClass)

    "Modified (format): / 30-09-2011 / 12:50:13 / cg"
!

recompile:aSelector usingCompiler:aCompiler
    "{ Pragma: +optSpace }"

    "recompile the method associated with the argument, aSelector;
     used when a superclass changes instances and we have to recompile
     subclasses"

    |cat code oldMethod oldPackage newMethod|

    oldMethod := self compiledMethodAt:aSelector.
    oldMethod isNil ifTrue:[
        self error:'no such method'
    ].

    oldPackage := oldMethod getPackage.
    cat := oldMethod category.
    code := self sourceCodeAt:aSelector.

    Class withoutUpdatingChangesDo:[

        Error handle:[:ex |
            "/ don't want to loose code !!
            Transcript showCR:ex description.
            newMethod := oldMethod class trapMethodForNumArgs:(oldMethod numArgs).
            newMethod source:code.
        ] do:[
            Class methodRedefinitionNotification answer:#keep do:[
                "/ hack - compilers have  different protocols... (needs fix)
                (aCompiler respondsTo:#compile:forClass:inCategory:)
                ifTrue:[
                    "/ ST/X's compiler
                    aCompiler compile:code forClass:self inCategory:cat
                ] ifFalse:[
                    "/ some other (TGEN) compiler
                    aCompiler
                            compile:code
                            in:self
                            notifying:nil
                            ifFail:[].
                ].
            ].
        ].
        newMethod := self compiledMethodAt:aSelector.
        newMethod setPackage:oldPackage.
    ]

    "Created: / 01-04-1997 / 23:43:34 / stefan"
    "Modified: / 04-03-1998 / 13:01:55 / stefan"
    "Modified: / 08-09-2011 / 05:37:12 / cg"
    "Created: / 30-09-2011 / 12:45:58 / cg"
!

recompile:aSelector usingCompilerClass:aCompilerClass
    "{ Pragma: +optSpace }"

    "recompile the method associated with the argument, aSelector;
     used when a superclass changes instances and we have to recompile
     subclasses"

    ^ self recompile:aSelector usingCompiler:aCompilerClass new

    "Created: / 01-04-1997 / 23:43:34 / stefan"
    "Modified: / 04-03-1998 / 13:01:55 / stefan"
    "Modified: / 30-09-2011 / 12:46:19 / cg"
!

recompileAll
    "{ Pragma: +optSpace }"

    "recompile this class and all subclasses"

    |classes|

    classes := self subclasses.
    self recompile.
    classes do:[:aClass |
	aClass recompileAll
    ]

    "Modified: 5.1.1997 / 19:56:29 / cg"
    "Created: 1.4.1997 / 23:44:15 / stefan"
!

recompileForSpeed:aSelector
    "{ Pragma: +optSpace }"

    "recompile the method associated with the argument, aSelector;
     for highest speed (i.e. using the stc compiler, if supported by the architecture)."

    |cat code oldMethod oldPackage newMethod|

    Class withoutUpdatingChangesDo:[
        oldMethod := self compiledMethodAt:aSelector.
        oldPackage := oldMethod getPackage.
        cat := oldMethod category.
        code := self sourceCodeAt:aSelector.

        Class methodRedefinitionNotification answer:#keep do:[
            [
                ParserFlags 
                    withSTCCompilation:#always 
                    do:[
                        self compilerClass compile:code forClass:self inCategory:cat
                    ].
            ] ensure:[
                (self compiledMethodAt:aSelector) isNil ifTrue:[
                    self primAddSelector:aSelector withMethod:oldMethod
                ]
            ]
        ].
        newMethod := self compiledMethodAt:aSelector.
        newMethod setPackage:oldPackage.
    ]

    "Modified: 5.1.1997 / 19:55:33 / cg"
    "Created: 1.4.1997 / 23:44:32 / stefan"
!

recompileInvalidatedMethods
    "{ Pragma: +optSpace }"

    "recompile all invalidated methods"

    self selectorsAndMethodsDo:[:aSelector :aMethod |
	|trap trapCode trapByteCode|

	trap := aMethod trapMethodForNumArgs:aMethod numArgs.
	trapCode := trap code.
	trapByteCode := trap byteCode.

	(aMethod code = trapCode
	or:[aMethod byteCode == trapByteCode]) ifTrue:[
	    self recompile:aSelector
	]
    ]

    "Modified: 12.6.1996 / 11:52:09 / stefan"
    "Modified: 5.1.1997 / 19:56:59 / cg"
    "Created: 1.4.1997 / 23:44:37 / stefan"
!

recompileMethodsAccessingAny:setOfNames
    "{ Pragma: +optSpace }"

    "recompile all methods accessing a variable from setOfNames"

    self recompileMethodsAccessingAny:setOfNames orSuper:false

    "Modified: 5.1.1997 / 19:57:05 / cg"
    "Created: 1.4.1997 / 23:44:41 / stefan"
!

recompileMethodsAccessingAny:setOfNames orSuper:superBoolean
    "{ Pragma: +optSpace }"

    "recompile all methods accessing a variable from setOfNames,
     or super (if superBoolean is true).
     Also recompiles methods with possibly inlined instVarIndexFor:"

    |p|

    self selectorsAndMethodsDo:[:aSelector :aMethod |
        |mustCompile lits source|

        mustCompile := nil.

        source := aMethod source.
        source isNil ifTrue:[
            self error:('Cannot recompile, source is missing for ', aMethod displayString).    
        ].

        "/ avoid parsing, if possible
        superBoolean ifFalse:[
            setOfNames size == 1 ifTrue:[
                (source findString:(setOfNames first)) == 0 ifTrue:[
                    mustCompile := false.
                ]
            ]
        ].

        mustCompile isNil ifTrue:[
            p := self parserClass parseMethod:source in:self.
            (p isNil
             or:[(aMethod sendsAny:#( instVarIndexFor: instVarOffsetOf: ))
             or:[(p usedVars includesAny:setOfNames)
             or:[superBoolean and:[p usesSuper]]]]) ifTrue:[
                mustCompile := true
            ]
        ].

        mustCompile == true ifTrue:[
            self recompile:aSelector
        ]
    ]

    "Created: / 01-04-1997 / 23:44:46 / stefan"
    "Modified: / 29-08-1997 / 07:58:32 / cg"
    "Modified: / 21-08-2009 / 12:19:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

recompileMethodsAccessingAnyClassvarOrGlobal:aCollection
    "{ Pragma: +optSpace }"

    "recompile all methods accessing a global or classvar in aCollection"

"/  Transcript showCR:self name , ' recompiling accesses to ' , aCollection printString.

    self selectorsAndMethodsDo:[:aSelector :aMethod |
	(aMethod literalsDetect:[ :lit | |i l|
	    "classVars are named 'className:varName' in
	     the literal array"

	    lit isSymbol and:[
		i := lit lastIndexOf:$:.
		i == 0 ifTrue:[
		    l := lit.
		] ifFalse:[
		    l := lit copyFrom:(i + 1).
		].
		aCollection includes:l
	    ].
	] ifNone:[]) notNil ifTrue:[
"/          Transcript showCR:self name , ' recompiling ' , aSelector.
	    self recompile:aSelector
	]
    ]

    "Modified: / 29.8.1997 / 07:59:24 / cg"
    "Created: / 23.1.1998 / 12:13:32 / stefan"
    "Modified: / 23.1.1998 / 16:13:45 / stefan"
!

recompileMethodsAccessingGlobal:aGlobalKey
    "{ Pragma: +optSpace }"

    "recompile all methods accessing the global variable aGlobalKey"

"/    Transcript 
"/            show:self name;
"/            show:'recompiling for: ';
"/            show:aGlobalKey;
"/            showCR:'...'.

    self selectorsAndMethodsDo:[:aSelector :aMethod |
        (aMethod literalsDetect:[:lit| lit = aGlobalKey] ifNone:[]) notNil ifTrue:[
"/            Transcript 
"/                    show:'  ->';
"/                    showCR:aSelector.

            self recompile:aSelector.
        ].
    ].

    "Created: / 1.4.1997 / 23:44:53 / stefan"
    "Modified: / 29.8.1997 / 07:59:24 / cg"
    "Modified: / 23.1.1998 / 15:47:55 / stefan"
!

recompileMethodsWithMachineCode
    "{ Pragma: +optSpace }"

    "recompile all methods which have non-dynamic machineCode
     (i.e. those, which were loaded from a compiled classLibrary)"

    self selectorsAndMethodsDo:[:aSelector :oldMethod |
        |newMethod|

        oldMethod isLazyMethod ifFalse:[
            oldMethod byteCode isNil ifTrue:[
                self recompile:aSelector.
                newMethod := self compiledMethodAt:aSelector.
                oldMethod ~~ newMethod ifTrue:[
                    newMethod sourceFilename:(oldMethod getSource) position:(oldMethod getSourcePosition)
                ]
            ].
        ].
    ].
!

recompileUsingCompilerClass:aCompilerClass
    "{ Pragma: +optSpace }"

    "recompile all methods
     used when a class changes instances and therefore all methods
     have to be recompiled"

    self selectorsAndMethodsDo:[:aSelector :aMethod |
        self recompile:aSelector usingCompilerClass:aCompilerClass
    ]

    "Modified: 12.6.1996 / 11:51:15 / stefan"
    "Created: 1.4.1997 / 23:43:38 / stefan"
    "Modified: 29.8.1997 / 07:56:49 / cg"
! !

!ClassDescription methodsFor:'fileIn interface'!

ignoredMethodsFor:aCategory
    "this is a speciality of ST/X - it allows quick commenting of methods
     from a source-file by replacing the 'methodsFor:' by 'ignoredMethodsFor:'.
     Returns a ClassCategoryReader to read in and skip methods."

    ^ (self methodsFor:aCategory) ignoredProtocol

    "Modified: 10.2.1996 / 12:53:25 / cg"
    "Created: 1.4.1997 / 13:58:46 / stefan"
!

methods
    "this method allows fileIn of ST/V methods -
     return a ClassCategoryReader to read in and compile methods for me.
     Since ST/V does not support method categories, the loaded methods are
     categorized as 'ST/V methods'."

    ^ ClassCategoryReader class:self category:'ST/V methods'

    "Modified: 10.2.1996 / 12:44:21 / cg"
    "Created: 1.4.1997 / 13:58:52 / stefan"
!

methodsFor:aCategory
    "return a ClassCategoryReader to read in and compile methods for me."

    ^ ClassCategoryReader class:self category:aCategory

    "Modified: 10.2.1996 / 12:44:43 / cg"
    "Created: 1.4.1997 / 13:57:37 / stefan"
!

methodsFor:aCategory stamp:time
    "return a ClassCategoryReader to read in and compile methods for me.
     This was added to allow squeak code to be filedIn."

    ^ self methodsFor:aCategory

    "Modified: 15.10.1997 / 18:51:53 / cg"
!

methodsForUndefined:categoryString
    "ST-80 compatibility.
     I don't yet know what this does - it was encountered by some tester.
     For now, simply forward it."

    ^ self methodsFor:categoryString

    "Created: 1.4.1997 / 13:59:14 / stefan"
!

privateMethods
    "this method allows fileIn of V'Age methods
     The privateMethods keyword is for documentation only;
     by default, methods are public (for backward compatibility)
     (although, they could be made private here)."

    "/ uncomment to install as real private methods ...
    "/ ^ (self methodsFor:'private') privateProtocol

    ^ self methodsFor:'private'

    "Created: / 15.6.1998 / 20:29:29 / cg"
    "Modified: / 15.6.1998 / 20:30:38 / cg"
!

privateMethodsFor:aCategory
    "this method allows fileIn of ENVY and ST/X private methods.

     The following methods are only allowed to be executed if sent from a method
     within the current class. Subclass sends or out-of-class sends will raise
     a privatMethodError exception."

    ^ (self methodsFor:aCategory) privateProtocol

    "Modified: 10.2.1996 / 12:48:44 / cg"
    "Created: 1.4.1997 / 14:01:07 / stefan"
!

protectedMethodsFor:aCategory
    "this method allows fileIn of ENVY and ST/X protected methods.

     The following methods are only allowed to be executed if sent from a method
     within the current class or a subclass. Out-of-class sends will raise
     a privatMethodError exception."

    ^ (self methodsFor:aCategory) protectedProtocol

    "Modified: 10.2.1996 / 12:49:18 / cg"
    "Created: 1.4.1997 / 13:59:32 / stefan"
!

publicMethods
    "this method allows fileIn of V'Age methods
     The publicMethods keyword is for documentation only;
     by default, methods are public anyway (for backward compatibility)."

    ^ self methodsFor:'public'

    "Created: / 1.4.1997 / 13:59:39 / stefan"
    "Modified: / 15.6.1998 / 20:29:02 / cg"
!

publicMethodsFor:aCategory
    "this method allows fileIn of ENVY methods
     The publicMethods keyword is for documentation only; my default, methods
     are public anyway (for backward compatibility)."

    ^ self methodsFor:aCategory

    "Modified: 10.2.1996 / 12:50:11 / cg"
    "Created: 1.4.1997 / 13:59:39 / stefan"
! !

!ClassDescription methodsFor:'fileOut'!

fileOutCategory:aCategory
    "create a file 'class-category.st' consisting of all methods in aCategory.
     If the current project is not nil, create the file in the projects
     directory."

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    |aStream fileName|

    fileName := (self name , '-' , aCategory , '.st') asFilename.
    fileName makeLegalFilename.

    "/
    "/ this test allows a smalltalk to be built without Projects/ChangeSets
    "/
    Project notNil ifTrue:[
        fileName := Project currentProjectDirectory asFilename construct:(fileName name).
    ].

    "/
    "/ if the file exists, save original in a .sav file
    "/
    fileName exists ifTrue:[
        fileName copyTo:(fileName withSuffix:'sav')
    ].

    [
        aStream := fileName newReadWriteStream.
    ] on:FileStream openErrorSignal do:[:ex|
        ^ FileOutErrorSignal
                raiseRequestWith:fileName name
                errorString:(' - cannot create file:', fileName name)
    ].

    self fileOutCategory:aCategory on:aStream.
    aStream close

    "Modified: / 1.4.1997 / 16:00:24 / stefan"
    "Created: / 1.4.1997 / 16:04:18 / stefan"
    "Modified: / 28.10.1997 / 14:40:28 / cg"
!

fileOutCategory:aCategory except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    |source sortedSelectors first privacy interestingMethods cat|

    interestingMethods := self methodsInCategory:aCategory forWhich:methodFilter.
    interestingMethods := interestingMethods 
            select:[:method |
                |wanted|

                skippedMethods notNil ifTrue:[
                    wanted := (skippedMethods includesIdentical:method) not
                ] ifFalse:[
                    savedMethods notNil ifTrue:[
                        wanted := (savedMethods includesIdentical:method).
                    ] ifFalse:[
                        wanted := true
                    ]
                ].
                wanted 
            ] as:OrderedCollection.

    interestingMethods notEmpty ifTrue:[
        first := true.
        privacy := nil.

        "/
        "/ sort by selector
        "/
        sortedSelectors := interestingMethods collect:[:m | self selectorAtMethod:m].
        sortedSelectors sortWith:interestingMethods.

        interestingMethods do:[:aMethod |
            first ifFalse:[
                privacy ~~ aMethod privacy ifTrue:[
                    first := true.
                    aStream space.
                    aStream nextPutChunkSeparator.
                ].
                aStream cr; cr
            ].

            privacy := aMethod privacy.

            first ifTrue:[
                aStream nextPutChunkSeparator.
                self printClassNameOn:aStream.
                privacy ~~ #public ifTrue:[
                    aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
                ] ifFalse:[
                    aStream nextPutAll:' methodsFor:'.
                ].
                cat := aCategory.
                cat isNil ifTrue:[ cat := '' ].
                aStream nextPutAll:aCategory asString storeString.
                aStream nextPutChunkSeparator; cr; cr.
                first := false.
            ].
            source := aMethod source.
            source isNil ifTrue:[
                FileOutErrorSignal
                    raiseRequestWith:self
                    errorString:' - no source for method: ', (aMethod displayString)
            ] ifFalse:[
                aStream nextChunkPut:source.
            ].
        ].
        aStream space.
        aStream nextPutChunkSeparator.
        aStream cr
    ]

    "Modified: 28.8.1995 / 14:30:41 / claus"
    "Modified: 12.6.1996 / 11:37:33 / stefan"
    "Modified: 15.11.1996 / 11:32:21 / cg"
    "Created: 1.4.1997 / 16:04:33 / stefan"
!

fileOutCategory:aCategory except:skippedMethods only:savedMethods on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    self
        fileOutCategory:aCategory
        except:skippedMethods
        only:savedMethods
        methodFilter:nil
        on:aStream

    "Modified: 28.8.1995 / 14:30:41 / claus"
    "Modified: 12.6.1996 / 11:37:33 / stefan"
    "Modified: 15.11.1996 / 11:32:21 / cg"
    "Created: 1.4.1997 / 16:04:33 / stefan"
!

fileOutCategory:aCategory methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream"

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    self fileOutCategory:aCategory except:nil only:nil methodFilter:methodFilter on:aStream

    "Created: 1.4.1997 / 16:04:44 / stefan"
!

fileOutCategory:aCategory on:aStream
    "file out all methods belonging to aCategory, aString onto aStream"

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    "/
    "/ must use the classes full name
    "/
    Class fileOutNameSpaceQuerySignal answer:true do:[
        self fileOutCategory:aCategory except:nil only:nil methodFilter:nil on:aStream
    ]

    "Created: 1.4.1997 / 16:04:44 / stefan"
!

fileOutMethod:aMethod
    "create a file 'class-method.st' consisting of the method, aMethod.
     If the current project is not nil, create the file in the projects
     directory."

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    |aStream fileName selector|

    selector := self selectorAtMethod:aMethod.
    selector notNil ifTrue:[
        fileName := (self name , '-' , selector, '.st') asFilename.
        fileName makeLegalFilename.

        "
         this test allows a smalltalk to be built without Projects/ChangeSets
        "
        Project notNil ifTrue:[
            fileName := Project currentProjectDirectory asFilename construct:fileName name.
        ].

        "
         if file exists, save original in a .sav file
        "
        fileName exists ifTrue:[
            fileName copyTo:(fileName withSuffix: 'sav')
        ].

        [
            aStream := fileName newReadWriteStream.
        ] on:FileStream openErrorSignal do:[:ex|
            ^ FileOutErrorSignal
                    raiseRequestWith:fileName name
                    errorString:(' - cannot create file:', fileName name)
        ].
        self fileOutMethod:aMethod on:aStream.
        aStream close
    ]

    "Modified: / 1.4.1997 / 16:00:57 / stefan"
    "Created: / 2.4.1997 / 00:24:28 / stefan"
    "Modified: / 28.10.1997 / 14:40:34 / cg"
!

fileOutMethod:aMethod on:aStream
    "file out aMethod onto aStream. Used for example to write individual changeChunks"

    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    |cat source privacy|

    aStream nextPutChunkSeparator.
    self name printOn:aStream.
"/        self printClassNameOn:aStream.

    (privacy := aMethod privacy) ~~ #public ifTrue:[
        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
    ] ifFalse:[
        aStream nextPutAll:' methodsFor:'.
    ].

    cat := aMethod category ? ''.
    aStream nextPutAll:cat asString storeString.
    aStream nextPutChunkSeparator; cr; cr.

    source := aMethod source.
    source isNil ifTrue:[
        FileOutErrorSignal
            raiseRequestWith:self
            errorString:(' - no source for method: ' ,
                         self name , '>>' ,
                         (self selectorAtMethod:aMethod))
    ] ifFalse:[
        aStream nextChunkPut:source.
    ].
    aStream space.
    aStream nextPutChunkSeparator.
    aStream cr

    "Modified: 27.8.1995 / 01:23:19 / claus"
    "Modified: 12.6.1996 / 11:44:41 / stefan"
    "Modified: 15.11.1996 / 11:32:43 / cg"
    "Created: 2.4.1997 / 00:24:33 / stefan"
!

fileOutMethods:methods on:aStream
    "/ WARNING: will be obsoleted by SmalltalkChunkFileSourceWriter

    methods do:[:aMethod |
        self fileOutMethod:aMethod on:aStream
    ].

    "Created: / 29.1.2000 / 16:39:53 / cg"
    "Modified: / 29.1.2000 / 16:40:59 / cg"
! !

!ClassDescription methodsFor:'fileOut-xml'!

fileOutXMLCategory:aCategory methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString in xml format onto aStream."

    "/ WARNING: will be obsoleted by XMLChunkFileWriter (or similar)

    |source sortedSelectors first privacy interestingMethods cat|

    interestingMethods := (self methodsInCategory:aCategory forWhich:methodFilter) asOrderedCollection.
    interestingMethods notEmpty ifTrue:[
        first := true.
        privacy := nil.

        "/
        "/ sort by selector
        "/
        sortedSelectors := interestingMethods collect:[:m | self selectorAtMethod:m].
        sortedSelectors sortWith:interestingMethods.

        interestingMethods do:[:aMethod |
            first ifFalse:[
                privacy ~~ aMethod privacy ifTrue:[
                    first := true.
                    aStream nextPutLine:'</methods>'.
                ].
            ].

            privacy := aMethod privacy.

            first ifTrue:[
                cat := aCategory.
                cat isNil ifTrue:[ cat := '' ].

                aStream nextPutLine:'<methods>'.
                aStream nextPutAll:'  <class-id>'.
                aStream nextPutAll:self name.
                aStream nextPutLine:'</class-id>'.
                aStream nextPutAll:'  <category>'.
                aStream nextPutAll:cat.
                aStream nextPutLine:'</category>'.

                privacy ~~ #public ifTrue:[
                    aStream nextPutAll:'  <privacy>'.
                    aStream nextPutAll:privacy.
                    aStream nextPutLine:'</privacy>'.
                ].
                first := false.
            ].
            source := aMethod source.
            source isNil ifTrue:[
                FileOutErrorSignal
                    raiseRequestWith:self
                    errorString:' - no source for method: ', (aMethod displayString)
            ] ifFalse:[
                aStream nextPutAll:'  <body>'.
                source printXmlTextQuotedOn:aStream.
                aStream nextPutLine:'</body>'.
            ].
        ].
        aStream nextPutLine:'</methods>'.
    ]
!

fileOutXMLMethod:aMethod on:aStream
    "file out a method in xml format onto aStream."

    "/ WARNING: will be obsoleted by XMLChunkFileWriter (or similar)

    |source privacy|

    privacy := aMethod privacy.

    aStream nextPutLine:'<methods>'.
    aStream nextPutAll:'  <class-id>'.
    aStream nextPutAll:self name.
    aStream nextPutLine:'</class-id>'.
    aStream nextPutAll:'  <category>'.
    aStream nextPutAll:(aMethod category ?'').
    aStream nextPutLine:'</category>'.

    privacy ~~ #public ifTrue:[
        aStream nextPutAll:'  <privacy>'.
        aStream nextPutAll:privacy.
        aStream nextPutLine:'</privacy>'.
    ].

    source := aMethod source.
    source isNil ifTrue:[
        FileOutErrorSignal
            raiseRequestWith:self
            errorString:' - no source for method: ', (aMethod displayString)
    ] ifFalse:[
        aStream nextPutAll:'  <body>'.
        source printXmlTextQuotedOn:aStream.
        aStream nextPutLine:'  </body>'.
    ].
    aStream nextPutLine:'</methods>'.
! !


!ClassDescription methodsFor:'printOut'!

nameWithNameSpacePrefix
    "return my name's printString,
     with nameSpace prefix (even if its the Smalltalk namespace)"

    |nm owner|

    (owner := self owningClass) notNil ifTrue:[
        ^ (owner nameWithNameSpacePrefix , '::' , self nameWithoutPrefix)
    ].

    nm := self name.
    self nameSpace == Smalltalk ifTrue:[
        nm := 'Smalltalk::' , nm
    ].
    ^ nm

    "a public class:
     Array name
     Array nameWithoutPrefix
     Array nameWithoutNameSpacePrefix
     Array nameWithNameSpacePrefix
    "

    "a private class:
     Method::MethodWhoInfo name
     Method::MethodWhoInfo nameWithoutPrefix
     Method::MethodWhoInfo nameWithoutNameSpacePrefix
     Method::MethodWhoInfo nameWithNameSpacePrefix
    "

    "a namespace class:
     CodingExamples::TopClass name
     CodingExamples::TopClass nameWithoutPrefix
     CodingExamples::TopClass nameWithoutNameSpacePrefix
     CodingExamples::TopClass nameWithNameSpacePrefix
    "

    "a private class in a namespace class:
     CodingExamples::TopClass::SubClass name
     CodingExamples::TopClass::SubClass nameWithoutPrefix
     CodingExamples::TopClass::SubClass nameWithoutNameSpacePrefix
     CodingExamples::TopClass::SubClass nameWithNameSpacePrefix
    "

    "Modified: 5.1.1997 / 18:22:57 / cg"
    "Created: 1.4.1997 / 16:20:13 / stefan"
!

nameWithoutNameSpacePrefix
    "helper for fileOut and others - return my names printString,
     without any nameSpace prefix (but with owningClasses prefix)"

    |nm owner|

    nm := self nameWithoutPrefix.
    (owner := self owningClass) isNil ifTrue:[
	^ nm
    ].

    ^ (owner nameWithoutNameSpacePrefix , '::' , nm)

    "a public class:
     Array name
     Array nameWithoutPrefix
     Array nameWithoutNameSpacePrefix
    "

    "a private class:
     Method::MethodWhoInfo name
     Method::MethodWhoInfo nameWithoutPrefix
     Method::MethodWhoInfo nameWithoutNameSpacePrefix
    "

    "a namespace class:
     CodingExamples::TopClass name
     CodingExamples::TopClass nameWithoutPrefix
     CodingExamples::TopClass nameWithoutNameSpacePrefix
    "

    "a private class in a namespace class:
     CodingExamples::TopClass::SubClass name
     CodingExamples::TopClass::SubClass nameWithoutPrefix
     CodingExamples::TopClass::SubClass nameWithoutNameSpacePrefix
    "

    "Modified: 5.1.1997 / 18:22:57 / cg"
    "Created: 1.4.1997 / 16:20:13 / stefan"
!

nameWithoutPrefix
    "helper for fileOut and others - return my names printString,
     without any owningClass or nameSpace prefix"

    ^ Class nameWithoutPrefix:self name

    "a public class:
     Array name
     Array nameWithoutPrefix
     Array nameWithoutNameSpacePrefix
    "

    "a private class:
     Method::MethodWhoInfo name
     Method::MethodWhoInfo nameWithoutPrefix
     Method::MethodWhoInfo nameWithoutNameSpacePrefix
    "

    "a namespace class:
     Demos::WalkingGirl name
     Demos::WalkingGirl nameWithoutPrefix
     Demos::WalkingGirl nameWithoutNameSpacePrefix
    "

    "a private class in a namespace class:
     Demos::WalkingGirl::AnimationView name
     Demos::WalkingGirl::AnimationView nameWithoutPrefix
     Demos::WalkingGirl::AnimationView nameWithoutNameSpacePrefix
    "

    "Created: / 01-04-1997 / 16:20:34 / stefan"
    "Modified: / 11-08-2006 / 12:58:02 / cg"
!

printClassNameOn:aStream
    "helper for fileOut - print my name.
     Private classes always print their owning-class as nameSpace
     prefix; non-private ones print without, except if the
     FileOutNameSpaceQuery returns true. The last feature is used
     with changefile updates - here, the full name is wanted."

    |nm|

    Class fileOutNameSpaceQuerySignal query == false ifTrue:[
	nm := self nameWithoutNameSpacePrefix
    ] ifFalse:[
	nm := self name.
    ].

    aStream nextPutAll:nm.

    "Modified: / 3.1.1997 / 20:41:26 / cg"
    "Created: / 1.4.1997 / 16:06:57 / stefan"
    "Modified: / 18.3.1999 / 18:17:21 / stefan"
!

printHierarchyAnswerIndentOn:aStream
    "print my class hierarchy on aStream - return indent
     recursively calls itself to print superclass and use returned indent
     for my description - used in the browser"

    |indent nm superclass|

    indent := 0.
    superclass := self superclass.
    (superclass notNil) ifTrue:[
	indent := (superclass printHierarchyAnswerIndentOn:aStream) + 2
    ].
    aStream spaces:indent.
    nm := self printNameInHierarchy.
    aStream nextPutAll:nm; nextPutAll:' ('.
    self printInstVarNamesOn:aStream indent:(indent + nm size + 2).
    aStream nextPutLine:')'.
    ^ indent

    "Created: 22.3.1997 / 14:11:29 / cg"
    "Modified: 22.3.1997 / 14:15:42 / cg"
!

printHierarchyOn:aStream
    "print my class hierarchy on aStream"

    self printHierarchyAnswerIndentOn:aStream

    "Created: 22.3.1997 / 14:11:13 / cg"
!

printInstVarNamesOn:aStream indent:indent
    "print the instance variable names indented and breaking at line end"

    self printNameArray:(self instVarNames) on:aStream indent:indent

    "Created: 22.3.1997 / 14:12:00 / cg"
!

printNameArray:anArray on:aStream indent:indent
    "print an array of strings separated by spaces; when the stream
     defines a lineLength, break when this limit is reached; indent
     every line; used to printOut instance variable names"

    |thisName nextName arraySize lenMax pos mustBreak line spaces|

    arraySize := anArray size.
    arraySize ~~ 0 ifTrue:[
	pos := indent.
	lenMax := aStream lineLength.
	thisName := anArray at:1.
	line := ''.
	1 to:arraySize do:[:index |
	    line := line , thisName.
	    pos := pos + thisName size.
	    (index == arraySize) ifFalse:[
		nextName := anArray at:(index + 1).
		mustBreak := false.
		(lenMax > 0) ifTrue:[
		    ((pos + nextName size) > lenMax) ifTrue:[
			mustBreak := true
		    ]
		].
		mustBreak ifTrue:[
		    aStream nextPutLine:line withTabs.
		    spaces isNil ifTrue:[
			spaces := String new:indent
		    ].
		    line := spaces.
		    pos := indent
		] ifFalse:[
		    line := line , ' '.
		    pos := pos + 1
		].
		thisName := nextName
	    ]
	].
	aStream nextPutAll:line withTabs
    ]

    "Modified: 9.11.1996 / 00:12:06 / cg"
    "Created: 22.3.1997 / 14:12:12 / cg"
!

printNameInHierarchy
    "return my name as printed in the hierarchy"

    ^ self name

    "Created: 22.3.1997 / 14:15:36 / cg"
!

printOutCategory:aCategory on:aPrintStream
    "print out all methods in aCategory on aPrintStream, which should understand emphasis"

    |interestingMethods sortedSelectors|

    interestingMethods := (self methodsInCategory:aCategory) asOrderedCollection.
    sortedSelectors := interestingMethods collect:[:m | self selectorAtMethod:m].
    sortedSelectors sortWith:interestingMethods.
    interestingMethods notEmptyOrNil ifTrue:[
        aPrintStream italic.
        aPrintStream nextPutAll:aCategory.
        aPrintStream normal.
        aPrintStream cr; cr.
        interestingMethods do:[:aMethod |
            aMethod source notEmptyOrNil ifTrue:[
                self printOutSource:(aMethod source) on:aPrintStream.
                aPrintStream cr; cr.
            ].
        ].
        aPrintStream cr
    ]

    "
     ClassDescription printOutCategory:'queries' on:Transcript
    "

    "Modified: / 12.6.1996 / 11:47:36 / stefan"
    "Created: / 28.1.1998 / 00:27:03 / cg"
!

printOutSource:aString on:aPrintStream
    "print out a source-string; the message-specification is printed bold,
     comments are printed italic"

    |text textIndex textSize line lineIndex lineSize inComment aCharacter|
    text := aString asStringCollection.
    aPrintStream bold.
    aPrintStream nextPutAll:(text at:1).
    aPrintStream normal.
    aPrintStream cr.
    inComment := false.
    textSize := text size.
    textIndex := 2.
    [textIndex <= textSize] whileTrue:[
	line := text at:textIndex.
	((line occurrencesOf:Character doubleQuote) == 0) ifTrue:[
	    aPrintStream nextPutAll:line
	] ifFalse:[
	    lineSize := line size.
	    lineIndex := 1.
	    [lineIndex <= lineSize] whileTrue:[
		aCharacter := line at:lineIndex.
		(aCharacter == Character doubleQuote) ifTrue:[
		    inComment ifTrue:[
			aPrintStream normal.
			aPrintStream nextPut:aCharacter.
			inComment := false
		    ] ifFalse:[
			aPrintStream nextPut:aCharacter.
			aPrintStream italic.
			inComment := true
		    ]
		] ifFalse:[
		    aPrintStream nextPut:aCharacter
		].
		lineIndex := lineIndex + 1
	    ]
	].
	aPrintStream cr.
	textIndex := textIndex + 1
    ]

    "Created: / 28.1.1998 / 00:27:25 / cg"
! !

!ClassDescription methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a string for display in inspectors"

    |cat|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    self isPrivate ifTrue:[
        aGCOrStream 
            nextPutAll:self nameWithoutPrefix;
            nextPutAll:' (private in ';
            nextPutAll:self owningClass name;
            nextPut:$).
    ] ifFalse:[
        aGCOrStream nextPutAll:self name ? '*unnamed*'.
    ].

    cat := self category.
    (cat = 'obsolete'
     or:[cat = '* obsolete *']) ifTrue:[
        "add obsolete - to make life easier ..."
        aGCOrStream nextPutAll:' (obsolete)'.
    ].
    (cat = 'removed'
     or:[cat = '* removed *']) ifTrue:[
        "add removed - to make life easier ..."
        aGCOrStream nextPutAll:' (removed)'.
    ].
    self isLoaded ifFalse:[
        aGCOrStream nextPutAll:' (autoloaded)'.
    ].

    "Modified: 15.10.1996 / 20:01:30 / cg"
    "Modified: 1.4.1997 / 15:49:13 / stefan"
! !

!ClassDescription methodsFor:'private-changes management'!

addChangeRecordForMethod:aMethod to:aStream
    "{ Pragma: +optSpace }"

    "append a method-change-record to aStream"

    self fileOutMethod:aMethod on:aStream

    "Created: 2.4.1997 / 17:31:46 / stefan"
!

addChangeRecordForMethodCategory:aMethod category:newCategory to:aStream
    "{ Pragma: +optSpace }"

    "append a methodCategory-change-record to aStream"

    |selector|

    selector := aMethod selector.
    selector notNil ifTrue:[
	aStream nextPutAll:'('.
	self printClassNameOn:aStream.
	aStream nextPutAll:(' compiledMethodAt:' , selector storeString).
	aStream nextPutAll:(') category:' , newCategory storeString).
	aStream nextPutChunkSeparator.
    ]

    "Created: 2.4.1997 / 17:31:56 / stefan"
!

addChangeRecordForMethodPackage:aMethod package:newPackageSymbol to:aStream
    "{ Pragma: +optSpace }"

    "append a methodPackage-change-record to aStream"

    |selector|

    selector := aMethod selector.
    selector notNil ifTrue:[
        aStream nextPutAll:'('.
        self printClassNameOn:aStream.
        aStream nextPutAll:(' compiledMethodAt:' , selector storeString).
        aStream nextPutAll:(') package:' , newPackageSymbol storeString).
        aStream nextPutChunkSeparator.
    ]

    "Created: / 09-10-2006 / 13:53:13 / cg"
!

addChangeRecordForMethodPrivacy:aMethod to:aStream
    "{ Pragma: +optSpace }"

    "append a method-privacy-change-record to aStream"

    |selector|

    selector := aMethod selector.
    selector notNil ifTrue:[
	aStream nextPutAll:'('.
	self printClassNameOn:aStream.
	aStream nextPutAll:(' compiledMethodAt:' , selector storeString).
	aStream nextPutAll:(') privacy:' , aMethod privacy storeString).
	aStream nextPutChunkSeparator.
    ]

    "Modified: 27.8.1995 / 22:59:56 / claus"
    "Created: 2.4.1997 / 17:32:04 / stefan"
!

addChangeRecordForRemoveSelector:aSelector to:aStream
    "{ Pragma: +optSpace }"

    "append a method-remove-record to aStream"

    self printClassNameOn:aStream.
    aStream nextPutAll:(' removeSelector:' , aSelector asSymbol storeString).
    aStream nextPutChunkSeparator.

    "Modified: 1.7.1996 / 21:27:55 / cg"
    "Created: 2.4.1997 / 17:32:31 / stefan"
!

addChangeRecordForRenameCategory:oldCategory to:newCategory to:aStream
    "{ Pragma: +optSpace }"

    "append a category-rename record to aStream"

    self printClassNameOn:aStream.
    aStream nextPutAll:(' renameCategory:' , oldCategory storeString).
    aStream nextPutAll:(' to:' , newCategory storeString).
    aStream nextPutChunkSeparator.

    "Created: 2.4.1997 / 17:32:44 / stefan"
!

addInfoRecord:aMessage to:aStream
    "{ Pragma: +optSpace }"

    "append an info-record (snapshot, class fileOut etc.) to aStream"

    aStream nextPutAll:'''---- '; nextPutAll:aMessage; nextPutAll:' '.
    Date today printOn:aStream language:#en.        "/ MUST be english !!!!
    aStream nextPutAll:' '.
    Time now printOn:aStream.
    aStream nextPutAll:' ----'''.
    aStream nextPutChunkSeparator.

    "Created: 2.4.1997 / 17:33:42 / stefan"
!

writingChangeDo:aBlock
    "{ Pragma: +optSpace }"

    "common helper to write a change record.
     Opens the changefile and executes aBlock passing the stream
     as argument. WriteErrors are caught and will lead to a warning.
     The changefile is not kept open, to force the change to go to disk
     as soon as possible - thus, in case of a crash, no changes should
     be lost due to buffering."

    self writingChangeWithTimeStamp:true do:aBlock

    "Modified: 18.11.1995 / 15:43:36 / cg"
    "Created: 2.4.1997 / 17:32:57 / stefan"
!

writingChangePerform:aSelector with:anArgument
    "{ Pragma: +optSpace }"

    self writingChangeWithTimeStamp:true perform:aSelector with:anArgument

    "Modified: 18.11.1995 / 15:44:53 / cg"
    "Created: 2.4.1997 / 17:33:03 / stefan"
!

writingChangeWithTimeStamp:doStampIt do:aBlock
    "{ Pragma: +optSpace }"

    "common helper to write a change record.
     Opens the changefile and executes aBlock passing the stream
     as argument. WriteErrors are caught and will lead to a warning.
     The changefile is not kept open, to force the change to go to disk
     as soon as possible - thus, in case of a crash, no changes should
     be lost due to buffering.
     Access to the change file is serialized via the accessLock;
     this prevents the changefile to be corrupted when multiple users
     accept in the browser in a multi-display (or timesliced) configuration"

    ChangeFileAccessLock critical:[
	|aStream|

	FileOutNameSpaceQuerySignal answer:true
	do:[
	    aStream := self changesStream.
	    aStream notNil ifTrue:[
		[
		    FileStream writeErrorSignal handle:[:ex |
			self warn:('Could not update the changes-file\\' , ex description) withCRs.
			ex return
		    ] do:[
			|didWarn|

			didWarn := false.
			EncodingError handle:[:ex |
			    didWarn ifFalse:[
				self warn:('The changeFile cannot correctly represent this change.\(ChangeFile is not utf8 encoded.)\Please start with a fresh changeFile.') withCRs.
				didWarn := true.
			    ].
			    ex proceedWith:(ex defaultValue).
			] do:[
			    doStampIt ifTrue:[
				self addChangeTimeStampTo:aStream
			    ].
			    aBlock value:aStream.
			    aStream cr.
			].
		    ].
		] ensure:[
		    aStream close
		]
	    ]
	]
    ]

    "Modified: 22.3.1997 / 17:12:40 / cg"
    "Created: 2.4.1997 / 17:33:09 / stefan"
!

writingChangeWithTimeStamp:stampIt perform:aSelector with:anArgument
    "{ Pragma: +optSpace }"

    self writingChangeWithTimeStamp:stampIt do:[:stream |
	self perform:aSelector with:anArgument with:stream.
    ]

    "Created: 2.4.1997 / 17:33:16 / stefan"
! !

!ClassDescription methodsFor:'private-helpers'!

addAllCategoriesTo:aCollection
    "helper - add categories and all superclasses categories
     to the argument, aCollection"

    |superclass|

    superclass := self superclass.
    (superclass notNil) ifTrue:[
	superclass addAllCategoriesTo:aCollection
    ].
    self addCategoriesTo:aCollection

    "Created: 1.4.1997 / 23:52:27 / stefan"
!

addCategoriesTo:aCollection
    "helper - add categories to the argument, aCollection.
     aCollection should be a set."

    aCollection addAll:(self categories).

"/ no need for tuning;
"/ its only used in the browsers new-protocol function.

"/    |prevCat|
"/
"/    self methodDictionary do:[:aMethod |
"/        |cat|
"/
"/        cat := aMethod category.
"/        cat ~~ prevCat ifTrue:[
"/            aCollection add:cat.
"/            prevCat := cat.
"/        ].
"/    ]
! !

!ClassDescription methodsFor:'protocol printOut'!

printOutCategoryProtocol:aCategory on:aPrintStream
    "{ Pragma: +optSpace }"

    |interestingMethods sortedSelectors|

    interestingMethods := (self methodsInCategory:aCategory) asOrderedCollection.
    sortedSelectors := interestingMethods collect:[:m | self selectorAtMethod:m].
    sortedSelectors sortWith:interestingMethods.
    interestingMethods notEmptyOrNil ifTrue:[
        aPrintStream italic.
        aPrintStream nextPutAll:aCategory.
        aPrintStream normal.
        aPrintStream cr; cr.
        interestingMethods do:[:aMethod |
            self printOutMethodProtocol:aMethod on:aPrintStream.
            aPrintStream cr; cr
        ].
        aPrintStream cr
    ]

    "
     ClassDescription printOutCategoryProtocol:'queries' on:Transcript
    "

    "Modified: 20.4.1996 / 18:20:26 / cg"
    "Modified: 12.6.1996 / 11:48:46 / stefan"
    "Created: 2.4.1997 / 01:10:40 / stefan"
!

printOutMethodProtocol:aMethod on:aPrintStream
    "{ Pragma: +optSpace }"

    "given the source in aString, print the methods message specification
     and any method comments - without source; used to generate documentation
     pages"

    |source comment|

    source := aMethod source.
    source isEmptyOrNil ifTrue:[^self].
    source := source asStringCollection.
    aPrintStream bold.
    aPrintStream nextPutLine:(source at:1).
    (source size >= 2) ifTrue:[
        (comment := aMethod comment) notNil ifTrue:[
            aPrintStream italic.
            aPrintStream spaces:((source at:2) indexOfNonSeparatorStartingAt:1).
            aPrintStream nextPutLine:comment.
        ]
    ].
    aPrintStream normal

    "
      Float printOutProtocolOn:Stdout
      Float printOutMethodProtocol:(Float compiledMethodAt:#coerce:) on:Transcript
    "

    "Modified: 9.11.1996 / 00:13:54 / cg"
    "Created: 2.4.1997 / 01:11:00 / stefan"
! !

!ClassDescription methodsFor:'queries'!

allCategories
    "Return a collection of all method-categories known in class
     and all superclasses. This does NOT include the metaclass categories.
     The returned collection is not sorted by any order."

    |coll|

    coll := Set new.
    self addAllCategoriesTo:coll.
    ^ coll asOrderedCollection

    "
     Point categories
     Point allCategories

     Point class categories
     Point class allCategories
    "

    "Modified: 21.3.1996 / 16:28:57 / cg"
    "Created: 1.4.1997 / 15:57:41 / stefan"
!

categories
    "Return a collection of the method-categories known in the receiver class.
     This does NOT include the metaclasses categories or the superclass categories.
     The returned collection is not sorted by any order."

    ^ self methodCategories

    "
     Point categories
     Point class categories
    "

    "Modified: 16.4.1996 / 18:06:11 / cg"
    "Modified: 12.6.1996 / 11:25:59 / stefan"
    "Created: 1.4.1997 / 15:57:18 / stefan"
!

commentOrDocumentationString
    "return either the classes documentation-method's comment
     or its plain comment or nil"

    |cls m s|

    cls := self theNonMetaclass.
    m := cls theMetaclass compiledMethodAt:#documentation.
    m notNil ifTrue:[
        "/ try documentation method's comment
        s := m comment.
    ] ifFalse:[
        "try classes comment"
        s := cls comment.
        s isString ifTrue:[
            s isEmpty ifTrue:[
                s := nil
            ] ifFalse:[
                s := s copyReplaceAll:$" with:$' ifNone:s.
                s size > 80 ifTrue:[
                    s := s asCollectionOfSubstringsSeparatedBy:$..
                    s := s asStringCollection.
                    s := s collect:[:each | (each startsWith:Character space) ifTrue:[
                                                each copyFrom:2
                                            ] ifFalse:[
                                                each
                                            ]
                                   ].
                    s := s asStringWith:('.' , Character cr).
                ].
            ]
        ] ifFalse:[
            "/ class redefines comment ?
            s := nil
        ].
    ].
    s isEmptyOrNil ifTrue:[^ s].
    ^ s withTabsExpanded

    "
     Array commentOrDocumentationString
    "
!

definesInstanceVariable:aString 
    (self directlyDefinesInstanceVariable:aString) ifTrue: [^ true].
    ^ superclass notNil and:[superclass definesInstanceVariable:aString]
!

directlyDefinesInstanceVariable:aString 
    ^ self instanceVariableNames includes:aString
!

isObsolete
    "return true, if the receiver is obsolete
     (i.e. has been replaced by a different class or was removed,
      but is still referenced by instanced)"

    |cat|

    cat := self category.

    ^ cat = 'obsolete'
      or:[cat = 'removed'
      or:[cat = '* removed *'
      or:[cat = '* obsolete *']]]

    "Modified: 10.9.1996 / 14:02:07 / cg"
    "Modified: 1.4.1997 / 15:49:49 / stefan"
!

methodCategories
    "Return a collection of the method-categories known in the receiver class.
     This does NOT include the metaclasses categories or the superclass categories.
     The returned collection is not sorted by any order."

    |newList|

    newList := Set new.
    self methodDictionary do:[:aMethod |
        newList add:(aMethod category ? '* no category *')
    ].
    ^ newList

    "
     Point methodCategories
     Point class methodCategories
    "

    "Modified: 16.4.1996 / 18:06:11 / cg"
    "Modified: 12.6.1996 / 11:25:59 / stefan"
    "Created: 1.4.1997 / 15:57:18 / stefan"
!

methodsInCategory:aCategory
    "helper for fileOut: 
     return an unsorted collection of methods from a given category"

    ^ self methodsInCategory:aCategory forWhich:[:m | true ]

    "
     ClassDescription methodsInCategory:'queries'
    "

    "Created: / 31-01-2012 / 13:53:07 / cg"
!

methodsInCategory:aCategory forWhich:methodFilter
    "helper for fileOut: return an unsorted collection of methods from a 
     given category, for which a filterblock evaluates to true"

    |interestingMethods|

    interestingMethods := OrderedCollection new.
    self methodsDo:[:aMethod |
        (methodFilter isNil
        or:[methodFilter value:aMethod]) ifTrue:[
            (aCategory = aMethod category) ifTrue:[
                interestingMethods add:aMethod.
            ]
        ]
    ].
    ^ interestingMethods

    "
     ClassDescription methodsInCategory:'queries' forWhich:[:m | m selector startsWith:'w']
    "

    "Modified (comment): / 31-01-2012 / 13:57:23 / cg"
!

privateClasses
    ^ #()
!

sourceCodeForMethod:aMethod at:aSelector
    ^ aMethod source

    "Created: / 19.6.1998 / 02:28:09 / cg"
!

topNameSpace
    "return the nameSpace of my topOwningClass (if private) or my own nameSpace."

    |ns|

    self isPrivate ifTrue:[^ self topOwningClass topNameSpace].
    ns := self nameSpace.
    ns isNil ifTrue:[
        "/ probably an unbound class
        ns := Smalltalk.         "/ What a KLUDGE
    ] ifFalse:[
        ns isNameSpace ifFalse:[
            "detect the problem, that a class has the same name as a nameSpace"
            self breakPoint:#cg.
            ns := Smalltalk.         "/ What a KLUDGE
        ]
    ].
    ^ ns.
!

whichCategoryIncludesSelector:aSelector
    "return the category under which the method for aSelector is
     classified"

    ^ (self compiledMethodAt:aSelector) category

    "Created: / 19.6.1998 / 00:25:48 / cg"
    "Modified: / 19.6.1998 / 01:00:07 / cg"
!

whichClassDefinesInstVar:aVariableName
    "return the class which defines the instance variable
     named aVariableName. This method should not be used for
     repeated searches (i.e. in the compiler/parser), since it creates
     many throw away intermediate objects."

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
	(cls instVarNames includes:aVariableName) ifTrue:[ ^ cls].
	cls := cls superclass
    ].
    ^ nil

    "
     StandardSystemView whichClassDefinesInstVar:'label'
     StandardSystemView whichClassDefinesInstVar:'paint'
     StandardSystemView whichClassDefinesInstVar:'foo'
    "

    "Created: 2.4.1997 / 01:12:27 / stefan"
!

whichSelectorsAccess:instVarName
    "return a collection of selectors for methods which access
     an instance variable"

    |set|

    (self allInstVarNames includes:instVarName) ifFalse:[
        ^ #()
    ].

    set := IdentitySet new.
    self selectorsAndMethodsDo:[:sel :mthd |
        (mthd accessesInstVar:instVarName) ifTrue:[
            set add:sel
        ]
    ].
    ^ set.

    "Created: / 19-06-1997 / 17:51:50 / cg"
    "Modified: / 23-07-2012 / 11:17:57 / cg"
! !

!ClassDescription methodsFor:'special accessing'!

setInstVarNames:aCollectionOfStrings
    "set the instance variable names from a collection of strings.
     No recompilation or updates are done and no changeList records are written.
     This is NOT for general use."

    instvars := aCollectionOfStrings collect:[:varName| varName asSymbol] as:Array.

    "
     Point instVarNames
     SortedCollection instVarNames
     SortedCollection allInstVarNames
    "
!

setInstVarNamesArray:anArrayOfSymbols
    "set the instance variable names from an Array of Symbols.
     No recompilation or updates are done and no changeList records are written.
     This is NOT for general use."

    instvars := anArrayOfSymbols.
!

setInstanceVariableString:aString
    "set the classes instvarnames string.
     No recompilation or updates are done and no changeList records are written.
     This is NOT for general use."

    instvars := aString.
! !

!ClassDescription methodsFor:'subclass creation'!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver).
     The subclass will have indexed variables if the receiving-class has."

    self isVariable ifFalse:[
	^ self class
	    name:nameSymbol
	    inEnvironment:(Class nameSpaceQuerySignal query)
	    subclassOf:self
	    instanceVariableNames:instVarNameString
	    variable:false
	    words:true
	    pointers:true
	    classVariableNames:classVarString
	    poolDictionaries:pool
	    category:cat
	    comment:nil
	    changed:true
    ].
    ^ self
	perform:(self definitionSelector)
	withArguments:(Array with:nameSymbol
			   with:instVarNameString
			   with:classVarString
			   with:pool
			   with:cat).

    "Modified: / 8.3.1997 / 00:41:08 / cg"
    "Modified: / 18.3.1999 / 18:18:25 / stefan"
!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat classInstanceVariableNames:classInstanceVariableNames
    "create a new class as a subclass of an existing class (the receiver).
     The subclass will have indexed variables if the receiving-class has."

    ^ self class
	name:nameSymbol
	inEnvironment:(Class nameSpaceQuerySignal query)
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:false
	words:true
	pointers:true
	classVariableNames:classVarString
	poolDictionaries:pool
	category:cat
	comment:nil
	changed:true
	classInstanceVariableNames:classInstanceVariableNames
!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat inEnvironment:aNameSpace
    "create a new class as a subclass of an existing class (the receiver).
     The subclass will have indexed variables if the receiving-class has."

    |rslt|

    self isVariable ifTrue:[
	Class nameSpaceQuerySignal answer:aNameSpace
	do:[
	    rslt := self
		subclass:nameSymbol
		instanceVariableNames:instVarNameString
		classVariableNames:classVarString
		poolDictionaries:pool
		category:cat
	].
	^ rslt
    ].
    ^ self class
	name:nameSymbol
	inEnvironment:aNameSpace
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:false
	words:true
	pointers:true
	classVariableNames:classVarString
	poolDictionaries:pool
	category:cat
	comment:nil
	changed:true

    "Created: 8.2.1997 / 19:41:44 / cg"
    "Modified: 31.8.1997 / 07:48:14 / cg"
!

variableByteSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable byte-sized nonpointer variables"

    self isVariable ifTrue:[
        self isBytes ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable byte subclass "%1" of variable non-byte class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:18 / cg"
    "Modified: / 6.11.1996 / 22:48:18 / cg"
    "Modified: / 18.3.1999 / 18:18:38 / stefan"
!

variableDoubleSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable double-sized nonpointer variables"

    self isVariable ifTrue:[
        self isDoubles ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable double subclass "%1" of variable non-double class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#double
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:21 / cg"
    "Modified: / 6.11.1996 / 22:48:22 / cg"
    "Modified: / 18.3.1999 / 18:18:54 / stefan"
!

variableFloatSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable float-sized nonpointer variables"

    self isVariable ifTrue:[
        self isFloats ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable float subclass "%1" of variable non-float class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#float
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:24 / cg"
    "Modified: / 6.11.1996 / 22:48:26 / cg"
    "Modified: / 18.3.1999 / 18:19:02 / stefan"
!

variableLongLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable unsigned long-long-sized nonpointer variables"

    self isVariable ifTrue:[
        self isLongLongs ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable long-long subclass "%1" of variable non-long-long class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#longLong
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Modified: / 18.3.1999 / 18:19:17 / stefan"
!

variableLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable long-sized nonpointer variables"

    self isVariable ifTrue:[
        self isLongs ifFalse:[
            self isBytes ifFalse:[
                ^ ClassBuildError raiseErrorString:
                    ('Cannot make variable long subclass "%1" of variable non-long class "%2"'
                        bindWith:nameSymbol with:self name)
            ].
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#long
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:27 / cg"
    "Modified: / 6.11.1996 / 22:48:29 / cg"
    "Modified: / 18.3.1999 / 18:19:28 / stefan"
!

variableSignedLongLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable signed long-long-sized nonpointer variables"

    self isVariable ifTrue:[
        self isSignedLongLongs ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable signed long-long subclass "%1" of variable non-signed long-long class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#signedLongLong
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Modified: / 18.3.1999 / 18:19:35 / stefan"
!

variableSignedLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable signed long-sized nonpointer variables"

    self isVariable ifTrue:[
        self isSignedLongs ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable signed long subclass "%1" of variable non-signed long class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#signedLong
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:31 / cg"
    "Modified: / 6.11.1996 / 22:48:32 / cg"
    "Modified: / 18.3.1999 / 18:19:41 / stefan"
!

variableSignedWordSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable word-sized signed nonpointer variables"

    self isVariable ifTrue:[
        self isSignedWords ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable signed word subclass "%1" of variable non-signed word class "%2"'
                    bindWith:nameSymbol with:self name)
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:#signedWord
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:34 / cg"
    "Modified: / 6.11.1996 / 22:48:35 / cg"
    "Modified: / 18.3.1999 / 18:19:51 / stefan"
!

variableSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable pointer variables"

    self isVariable ifTrue:[
        self isPointers ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable pointer subclass "%1" of variable non-pointer class "%2"'
                    bindWith:nameSymbol with:self name)
        ]
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:false
        pointers:true
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:37 / cg"
    "Modified: / 6.11.1996 / 22:48:40 / cg"
    "Modified: / 18.3.1999 / 18:20:01 / stefan"
!

variableSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat classInstanceVariableNames:classInstanceVariableNames
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable pointer variables"

    self isVariable ifTrue:[
        self isPointers ifFalse:[
            ^ ClassBuildError raiseErrorString:
                ('Cannot make variable pointer subclass "%1" of variable non-pointer class "%2"'
                    bindWith:nameSymbol with:self name)
        ]
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:false
        pointers:true
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true
        classInstanceVariableNames:classInstanceVariableNames

    "Created: / 12.10.1996 / 19:18:37 / cg"
    "Modified: / 6.11.1996 / 22:48:40 / cg"
    "Modified: / 18.3.1999 / 18:20:01 / stefan"
!

variableWordSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool category:cat
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable word-sized nonpointer variables"

    self isVariable ifTrue:[
        self isWords ifFalse:[
            self isBytes ifFalse:[
                ^ ClassBuildError raiseErrorString:
                ('Cannot make variable word subclass "%1" of variable non-word class "%2"'
                    bindWith:nameSymbol with:self name)
            ]
        ].
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:(Class nameSpaceQuerySignal query)
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:true
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:cat
        comment:nil
        changed:true

    "Created: / 12.10.1996 / 19:18:40 / cg"
    "Modified: / 6.11.1996 / 22:48:43 / cg"
    "Modified: / 18.3.1999 / 18:20:07 / stefan"
! !

!ClassDescription methodsFor:'subclass creation-private classes'!

subclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:ownerClassArg 
    "create a new class as a subclass of an existing class (the receiver).
     The subclass will have indexed variables if the receiving-class has."

    |category ownerClass|
    
    (ownerClass := ownerClassArg) isNil ifTrue:[
        self error:'Nil (undefined) owner class - proceed to define as global' mayProceed:true.
        ownerClass := Smalltalk.
    ] ifFalse:[
        category := ownerClass  category
    ].
    
    self isVariable ifFalse:[
        ^ self class
            name:nameSymbol
            inEnvironment:ownerClass 
            subclassOf:self
            instanceVariableNames:instVarNameString
            variable:false
            words:true
            pointers:true
            classVariableNames:classVarString
            poolDictionaries:pool
            category:category
            comment:nil
            changed:true.
    ].
    self isBytes ifTrue:[
        ^ self
            variableByteSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isLongs ifTrue:[
        ^ self
            variableLongSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isLongLongs ifTrue:[
        ^ self
            variableLongLongSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isFloats ifTrue:[
        ^ self
            variableFloatSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isDoubles ifTrue:[
        ^ self
            variableDoubleSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isWords ifTrue:[
        ^ self
            variableWordSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isSignedWords ifTrue:[
        ^ self
            variableSignedWordSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isSignedLongs ifTrue:[
        ^ self
            variableSignedLongSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].
    self isSignedLongLongs ifTrue:[
        ^ self
            variableSignedLongLongSubclass:nameSymbol
            instanceVariableNames:instVarNameString
            classVariableNames:classVarString
            poolDictionaries:pool
            privateIn:ownerClass 
    ].

    ^ self
        variableSubclass:nameSymbol
        instanceVariableNames:instVarNameString
        classVariableNames:classVarString
        poolDictionaries:pool
        privateIn:ownerClass 

    "Created: / 11-10-1996 / 16:30:53 / cg"
    "Modified: / 31-03-2007 / 10:20:38 / cg"
!

variableByteSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:ownerClass 
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable byte-sized nonpointer variables"

    |category|

    self isVariable ifTrue:[
        self isBytes ifFalse:[
            ^ self error:
                'cannot make a variable byte subclass of a variable non-byte class'
        ].
    ].

    ownerClass  isNil ifTrue:[
        self error:'Nil (undefined) owner class - proceed to define as global' mayProceed:true.
    ] ifFalse:[
        category := ownerClass  category
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:ownerClass 
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:false
        pointers:false
        classVariableNames:classVarString
        poolDictionaries:pool
        category:category
        comment:nil
        changed:true.

    "Created: / 11.10.1996 / 16:31:27 / cg"
    "Modified: / 4.7.1999 / 18:42:36 / cg"
!

variableDoubleSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass

    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable double-sized nonpointer variables"

    self isVariable ifTrue:[
	self isDoubles ifFalse:[
	    ^ self error:
		'cannot make a variable double subclass of a variable non-double class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#double
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:32:23 / cg"
    "Modified: / 4.7.1999 / 18:42:41 / cg"
!

variableFloatSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable float-sized nonpointer variables"

    self isVariable ifTrue:[
	self isFloats ifFalse:[
	    ^ self error:
		'cannot make a variable float subclass of a variable non-float class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#float
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:32:37 / cg"
    "Modified: / 4.7.1999 / 18:42:45 / cg"
!

variableLongLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable longlong-sized nonpointer variables"

    self isVariable ifTrue:[
	self isLongLongs ifFalse:[
	    ^ self error:
		'cannot make a variable longlong subclass of a variable non-longlong class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#longLong
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:32:48 / cg"
    "Modified: / 4.7.1999 / 18:42:49 / cg"
!

variableLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable long-sized nonpointer variables"

    self isVariable ifTrue:[
	self isLongs ifFalse:[
	    ^ self error:
		'cannot make a variable long subclass of a variable non-long class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#long
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:32:48 / cg"
    "Modified: / 4.7.1999 / 18:42:53 / cg"
!

variableSignedLongLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable signed longlong-sized nonpointer variables"

    self isVariable ifTrue:[
	self isSignedLongLongs ifFalse:[
	    ^ self error:
		'cannot make a variable signed longlong subclass of a variable non-longlong class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#signedLongLong
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:46:30 / cg"
    "Modified: / 4.7.1999 / 18:42:57 / cg"
!

variableSignedLongSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable signed long-sized nonpointer variables"

    self isVariable ifTrue:[
	self isSignedLongs ifFalse:[
	    ^ self error:
		'cannot make a variable signed long subclass of a variable non-long class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#signedLong
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:46:30 / cg"
    "Modified: / 4.7.1999 / 18:43:03 / cg"
!

variableSignedWordSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable word-sized signed nonpointer variables"

    self isVariable ifTrue:[
	self isSignedWords ifFalse:[
	    ^ self error:
		'cannot make a variable signed word subclass of a variable non-word class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:#signedWord
	words:false
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:46:44 / cg"
    "Modified: / 4.7.1999 / 18:43:06 / cg"
!

variableSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:ownerClass 
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable pointer variables"

    |category|
    
    self isVariable ifTrue:[
        self isPointers ifFalse:[
            ^ self error:
                'cannot make a variable pointer subclass of a variable non-pointer class'
        ]
    ].

    ownerClass  isNil ifTrue:[
        self error:'Nil (undefined) owner class - proceed to define as global' mayProceed:true.
    ] ifFalse:[
        category := ownerClass  category
    ].

    ^ self class
        name:nameSymbol
        inEnvironment:ownerClass 
        subclassOf:self
        instanceVariableNames:instVarNameString
        variable:true
        words:false
        pointers:true
        classVariableNames:classVarString
        poolDictionaries:pool
        category:category
        comment:nil
        changed:true.

    "Created: / 11.10.1996 / 16:54:33 / cg"
    "Modified: / 4.7.1999 / 18:43:10 / cg"
!

variableWordSubclass:nameSymbol instanceVariableNames:instVarNameString classVariableNames:classVarString poolDictionaries:pool privateIn:aClass
    "create a new class as a subclass of an existing class (the receiver)
     in which the subclass has indexable word-sized nonpointer variables"

    self isVariable ifTrue:[
	self isWords ifFalse:[
	    ^ self error:
		'cannot make a variable word subclass of a variable non-word class'
	].
    ].

    ^ self class
	name:nameSymbol
	inEnvironment:aClass
	subclassOf:self
	instanceVariableNames:instVarNameString
	variable:true
	words:true
	pointers:false
	classVariableNames:classVarString
	poolDictionaries:pool
	category:(aClass category)
	comment:nil
	changed:true.

    "Created: / 11.10.1996 / 16:54:48 / cg"
    "Modified: / 4.7.1999 / 18:43:18 / cg"
! !

!ClassDescription::PackageRedefinition methodsFor:'accessing'!

newPackage
    "answer the package of the class/method to be defined"

    ^ parameter value package
!

oldPackage
    "answer the package of the class/method to be overwritten"

    ^ parameter key package
! !

!ClassDescription::PackageRedefinition methodsFor:'default actions'!

defaultResumeValue
    "the default resume value is to return #continue.
     This causes the new method/class to be installed under the new package.
     This behavior is compatible with the default behavior when CatchMethodRedefinitions
     is false."

    "See Bug 824 before changing this"

    ^ #continue
! !

!ClassDescription::MethodRedefinitionNotification class methodsFor:'initialization'!

initialize
    NotifierString := 'attempt to redefine method from a different package'
! !

!ClassDescription::MethodRedefinitionNotification methodsFor:'accessing'!

newMethod
    "answer the new method to be defined"

    ^ parameter value
!

oldMethod
    "answer the old method to be overwritten"

    ^ parameter key
! !

!ClassDescription::ClassRedefinitionNotification class methodsFor:'initialization'!

initialize
    NotifierString := 'attempt to redefine a class from different package'
! !

!ClassDescription::ClassRedefinitionNotification methodsFor:'accessing'!

newClass
    "answer the new class to be defined"

    ^ parameter value
!

oldClass
    "answer the old class to be overwritten"

    ^ parameter key
! !

!ClassDescription class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ClassDescription initialize!
ClassDescription::MethodRedefinitionNotification initialize!
ClassDescription::ClassRedefinitionNotification initialize!
