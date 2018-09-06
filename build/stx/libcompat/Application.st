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
"{ Package: 'stx:libcompat' }"

"{ NameSpace: VAST }"

SubApplication subclass:#Application
	instanceVariableNames:''
	classVariableNames:'MissingPrerequisiteSignal'
	poolDictionaries:''
	category:'Compatibility-VisualAge'
!

Application class instanceVariableNames:'PreRequisites AppClasses AppMethods ToBeLoadedCode WasRemovedCode'

"
 The following class instance variables are inherited by this class:

	VAST::SubApplication - ParentApplication
	Object - 
"
!

!Application class methodsFor:'documentation'!

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
!

documentation
"
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    this class is provided to allow for an initial fileIn of V'Age classes.
    Classes should then be moved to their desired position in the ST/X class hierarchy.

    Except for the required protocol mimicri,
    it does not (yet) provide any functionality.

    [author:]
        Claus Gittinger
"
! !

!Application class methodsFor:'Signal constants'!

missingPrerequisiteSignal
    "return the signal which is raised when an applications
     preRequisite is missing"

    ^ MissingPrerequisiteSignal

    "Created: / 15.6.1998 / 18:09:45 / cg"
    "Modified: / 16.6.1998 / 09:35:42 / cg"
! !

!Application class methodsFor:'class initialization'!

initialize
    MissingPrerequisiteSignal isNil ifTrue:[
	MissingPrerequisiteSignal := ErrorSignal newSignalMayProceed:true.
	MissingPrerequisiteSignal nameClass:self message:#missingPrerequisiteSignal.
	MissingPrerequisiteSignal notifierString:'required application missing'.
    ]

    "
     self initialize
    "

    "Modified: / 15.6.1998 / 18:32:04 / cg"
!

initializeAfterLoad
    "invoked after an application has been loaded completely"

    ToBeLoadedCode notNil ifTrue:[
self halt.
        Parser evaluate:ToBeLoadedCode
    ].

    "Created: / 15.6.1998 / 19:04:03 / cg"
!

loaded
    "invoked after an application has been loaded and initialized completely"
!

toBeLoadedCode:aString
    ToBeLoadedCode := aString
!

wasRemovedCode:aString
    WasRemovedCode := aString
! !

!Application class methodsFor:'creating new apps'!

create:symbolNameOfNewApp
    "create a new application"

    ^ self create:symbolNameOfNewApp with:#()

    "Created: / 05-03-2012 / 14:20:22 / cg"
!

create:symbolNameOfNewApp with:prerequisiteCollection
    "create a new application"

    |newAppClass|

    newAppClass := self 
        subclass:symbolNameOfNewApp
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''
        category:'VisualAge Classes'.

    newAppClass package:symbolNameOfNewApp.
    newAppClass preRequisites:prerequisiteCollection.
    ^ newAppClass

    "Created: / 15-06-1998 / 17:29:54 / cg"
    "Modified: / 05-03-2012 / 14:21:44 / cg"
!

createSubApplication:symbolNameOfNewApp in:aString
    "create a new sub-application"

    |newAppClass|

    newAppClass := SubApplication 
        subclass:symbolNameOfNewApp
        instanceVariableNames: ''
        classVariableNames: ''
        poolDictionaries: ''.

    newAppClass package:symbolNameOfNewApp.
    newAppClass parentApplication:self.
!

errorPrerequisite:whichApp missing:missingApp
    "report an error, that some required application
     (a preRequisite) is missing"

    ^ MissingPrerequisiteSignal 
        raiseRequestWith:missingApp
        errorString:('application "%1" is required by "%2"' bindWith:missingApp with:whichApp)

    "Created: / 15-06-1998 / 17:30:16 / cg"
    "Modified: / 05-03-2012 / 14:19:15 / cg"
! !

!Application class methodsFor:'private accessing'!

preRequisites:aPreRequisiteCollection
    "set my preRequisites - a collection of required applications"

    PreRequisites := aPreRequisiteCollection

    "Created: / 15.6.1998 / 18:08:25 / cg"
    "Modified: / 16.6.1998 / 09:37:22 / cg"
! !

!Application class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Application.st,v 1.16 2017-11-09 09:04:08 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Application.st,v 1.16 2017-11-09 09:04:08 mawalch Exp $'
! !


Application initialize!
