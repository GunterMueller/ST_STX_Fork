"{ Package: 'stx:libbasic3' }"!

!CompiledCode methodsFor:'debugging'!

setTracelog
    "Arrange for a trace logging - enter/leave of the method will be logged using
     curent Logger"

    MessageTracer tracelogMethod:self

    "Created: / 15-03-2013 / 11:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasProjectChecker
    ^true

    "
     ConfigurableFeatures includesFeature:#ProjectChecker
    "

    "Created: / 03-04-2012 / 17:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExecutableFunction methodsFor:'queries'!

isMocked
    "Return true, if the method has been mocked (by means of MessageTracer>>mockMethod:do:"

    ^ false

    "Created: / 29-07-2014 / 09:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerAllowEditOfHistory
    "useful if you have 'beginner students', to prevent them from changing the history"

    ^self 
        at: #'history-manager.allow-edit-of-history'
        ifAbsent:false

    "Modified (Format): / 30-06-2011 / 17:07:33 / cg"
    "Modified (Comment): / 30-06-2011 / 17:09:24 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerModificationLimit
    "the time-delta within which the history manager does not treat a change as a new one"

    ^self 
        at: #'history-manager.modification-limit'
        ifAbsent: 3600 "/one hour"

    "Created: / 04-10-2008 / 11:55:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (Comment): / 30-06-2011 / 17:25:09 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerModificationLimit: sec
    "the time-delta within which the history manager does not treat a change as a new one"

    ^self 
        at: #'history-manager.modification-limit'
        put: sec

    "Created: / 04-10-2008 / 11:56:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (Comment): / 30-06-2011 / 17:25:13 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerSignature
    "the signature added by the history manager"

    ^self historyManagerSignatures
        at: (Array with: OperatingSystem getHostName with: OperatingSystem getLoginName)
        ifAbsent: [OperatingSystem getLoginName]

    "Created: / 04-10-2008 / 12:06:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-07-2011 / 10:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 17:24:21 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerSignature: aString
    "the signature added by the history manager"

    ^self historyManagerSignatures
        at: (Array with: OperatingSystem getHostName with: OperatingSystem getLoginName)
        put: aString

    "Created: / 04-10-2008 / 11:54:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (Comment): / 30-06-2011 / 17:25:31 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerSignatures
    "the signatures added by the history manager"

    ^self 
        at: #'history-manager.signatures'
        ifAbsentPut: [Dictionary new]

    "
     UserPreferences current historyManagerSignatures
    "

    "Created: / 04-10-2008 / 11:52:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-08-2009 / 11:00:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (Comment): / 30-06-2011 / 17:27:14 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-changes & history'!

historyManagerSignatures: aDictionary
    "the signatures added by the history manager"

    self 
        at: #'history-manager.signatures'
        put: aDictionary

    "Created: / 04-10-2008 / 11:52:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (Comment): / 30-06-2011 / 17:26:48 / cg"
! !

!UserPreferences methodsFor:'accessing-scm'!

managerPerMatchingModuleDefinitions

    | defs |

    defs := (self at: #'managerPerMatchingModuleDefinitionsKey' ifAbsent:[#()]).
    ^(defs collect:[:e|e decodeAsLiteralArray]) asOrderedCollection

    "
        UserPreferences current managerPerMatchingModuleDefinitions
        UserPreferences current managerPerMatchingModuleDefinitions: #().
    "

    "Created: / 09-07-2011 / 13:33:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm'!

managerPerMatchingModuleDefinitions: defs

    self at: #'managerPerMatchingModuleDefinitionsKey' 
        put: (defs collect:[:e| e literalArrayEncoding]) asArray.
    AbstractSourceCodeManager managerPerMatchingModuleDefinitions == defs ifFalse:[
        AbstractSourceCodeManager managerPerMatchingModuleDefinitions: defs.
    ]

    "Created: / 09-07-2011 / 13:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libbasic3 class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
