"{ Package: 'stx:libscm/common/patches/stx622' }"!

!Class methodsFor:'source management'!

binaryRevision
    "return the revision-ID from which the class was stc-compiled;
     nil if its an autoloaded or filedIn class.
     If a classes binary is up-to-date w.r.t. the source repository,
     the returned string is the same as the one returned by #revision."

    |owner info c|

    (owner := self owningClass) notNil ifTrue:[^ owner binaryRevision].

    revision notNil ifTrue:[
        c := revision first.
        c == $$ ifTrue:[
            "/ Here use self sourceCodeManager to use the manager configured
            "/ for class's package, not the global one
            "/ -------------v
            info := self sourceCodeManager revisionInfoFromString:revision.
            info isNil ifTrue:[^ '0'].
            ^ (info revision) ? '0'.
        ].
        c isDigit ifFalse:[
            ^ '0'
        ].
    ].

    ^ revision

    "
     Object binaryRevision
     Object class binaryRevision
    "

    "
     to find all classes which are not up-to-date:

     |classes|

     classes := Smalltalk allClasses
                    select:[:cls | cls binaryRevision notNil and:[cls binaryRevision ~= cls revision]].
     SystemBrowser browseClasses:classes title:'classes which are not up-to-date'
    "

    "Created: / 07-12-1995 / 10:58:47 / cg"
    "Modified: / 01-04-1997 / 23:33:01 / stefan"
    "Modified: / 22-10-2008 / 20:37:05 / cg"
    "Modified (format): / 05-07-2013 / 02:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'private-loading'!

executeHooks: hook
    "Execute all hooks annotate by given symbol. Currently supported
     hooks are: #preLoad, #postLoad, #preUnload."

    | cls |

    cls := self.

    [ cls notNil ] whileTrue:[
        cls class selectorsAndMethodsDo:[:selector :method|
            (method annotationAt: hook) notNil ifTrue:[
                method numArgs == 0 ifTrue:[
                    self perform: selector
                ] ifFalse:[
                    self error:'Hook for %1 must have no arguments' mayProceed: true.
                ]
            ]
        ].
        cls := cls superclass.
    ].

    "Created: / 20-11-2012 / 23:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 16:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - project information'!

fileReleaseNr
    "Returns a releaseNumber which will appear in libName.rc"

    "take the default revision from the cvs-version,
     but ignore a possibly present 'm'-flag that is set when this revision has been modified"

    "JV@2012-11-20: Original code was:

    ^ self cvsRevision last upTo:$m

    But this is too CVS specific. Modern SCMs does not use X.Y style
    revision numbers, instead it uses hashes (Git/Mercurial/Darcs/Monotone).
    Even worse, all the SCM code passes strings around, so providing compatible,
    polymorph object is not possible. Hence following hack."

    | nr |

    nr := (self cvsRevision last upTo:$m) select:[:c|c isDigit].
    nr isEmptyOrNil ifTrue:[^'0'].
    nr := (nr asInteger min: 16r7FFF) printString.
    ^nr

    "Created: / 18-08-2006 / 12:02:58 / cg"
    "Modified: / 30-08-2006 / 18:54:48 / cg"
    "Modified: / 05-07-2013 / 00:52:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - project information'!

fileRevisionNr
    "Returns a revisionNumber which will appear in libName.rc"

    "take the default revision from the cvs-version"

    "JV@2012-11-20: Original code was:

    ^ self cvsRevision first

    But this is too CVS specific. Modern SCMs does not use X.Y style
    revision numbers, instead it uses hashes (Git/Mercurial/Darcs/Monotone).
    Even worse, all the SCM code passes strings around, so providing compatible,
    polymorph object is not possible. Hence following hack."

    | nr |

    nr := self cvsRevision first select:[:c|c isDigit].
    nr isEmptyOrNil ifTrue:[^'0'].
    nr := (nr asInteger min: 16r7FFF) printString.
    ^nr


    "
    stx_libbasic fileRevisionNr
    stx_libbasic2 fileRevisionNr
    stx_libscm_mercurial fileRevisionNr
    "

    "Created: / 18-08-2006 / 12:02:39 / cg"
    "Modified: / 30-08-2006 / 18:54:39 / cg"
    "Modified: / 05-07-2013 / 00:52:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'loading'!

loadAsAutoloaded:asAutoloaded
    "load the project.
     If asAutoloaded == true, install all new classes as autoloaded.
     Answer true, if new classes have been installed for this package,
     false if the package's classes have been already present."

    |newStuffHasBeenLoaded meOrMySecondIncarnation|

    self projectIsLoaded ifTrue:[
        asAutoloaded ifFalse:[
            "/ to be considered !!
"/            self isFullyLoaded ifFalse:[
"/                self hasAllExtensionsLoaded ifFalse:[
"/                    self loadExtensions.
"/                ].
"/                self loadAllAutoloadedClasses
"/            ].
        ].
        ^ false
    ].
    thisContext isRecursive ifTrue:[self breakPoint:#cg. ^ false].    "/ avoid endless loops

    newStuffHasBeenLoaded := false.

    (self infoPrinting and:[Smalltalk silentLoading not]) ifTrue:[
        "/ thisContext fullPrintAll.
        Transcript showCR:('loading %1%2...'
                            bindWith:(asAutoloaded ifTrue:['as autoloaded '] ifFalse:[''])
                            with:self name).
    ].

    self rememberOverwrittenExtensionMethods.

    self activityNotification:'Executing pre-load action'.
    self executeHooks: #preLoad.
    self preLoadAction.

    meOrMySecondIncarnation := self.

    Class withoutUpdatingChangesDo:[
        self activityNotification:'Loading prerequisities'.
        self loadPreRequisitesAsAutoloaded:asAutoloaded.

        self checkPrerequisitesForLoading.

        asAutoloaded ifFalse:[
            self loadClassLibrary.
            "/ could have overloaded my first incarnation
            meOrMySecondIncarnation := (Smalltalk at:(self name)) ? self.
            meOrMySecondIncarnation ~~ self ifTrue:[
                meOrMySecondIncarnation fetchSlotsFrom:self.
            ].
        ].

        self hasAllExtensionsLoaded ifFalse:[
            self activityNotification:'Loading extensions'.
            newStuffHasBeenLoaded := newStuffHasBeenLoaded | meOrMySecondIncarnation loadExtensions.
        ].
        self hasAllClassesLoaded ifFalse:[
            self activityNotification:'Loading classes'.
            newStuffHasBeenLoaded := newStuffHasBeenLoaded | (meOrMySecondIncarnation loadAllClassesAsAutoloaded:asAutoloaded).
        ].
"/ no, don't load subProjects here - will lead to a recursion, which leads
"/ to some classes being loaded from source (soap)
        self activityNotification:'Loading sub projects'.
        meOrMySecondIncarnation loadSubProjectsAsAutoloaded:asAutoloaded.
    ].
    self activityNotification:('Executing post-load action for %1' bindWith:self package).

    "/ mhmh - already done for dll-loaded packages
    "/ meOrMySecondIncarnation initializeAllClasses.
    meOrMySecondIncarnation postLoadAction.
    meOrMySecondIncarnation executeHooks: #postLoad.

    meOrMySecondIncarnation projectIsLoaded:true.
    meOrMySecondIncarnation ~~ self ifTrue:[
        self projectIsLoaded:true.
    ].

    self activityNotification:('Done (%1).' bindWith:self package).
    ^ newStuffHasBeenLoaded

    "Created: / 17-08-2006 / 01:01:41 / cg"
    "Modified: / 30-10-2008 / 08:16:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-09-2011 / 10:01:53 / cg"
    "Modified: / 04-07-2013 / 01:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::ChangeSetDiffTool methodsFor:'accessing'!

showVersionMethodDiffs: aBoolean
    "Ignores, this methos is only patch to ensure 
      comaptibility with more recent versions"

    "Created: / 05-07-2013 / 00:36:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::InlineMessageDialog methodsFor:'actions'!

doAbortIfWorking
    worker notNil ifTrue:[ self doAbort ].

    "Created: / 05-07-2013 / 00:38:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_common_patches_stx622 class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !