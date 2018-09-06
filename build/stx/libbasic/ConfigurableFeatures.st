"{ Package: 'stx:libbasic' }"

Object subclass:#ConfigurableFeatures
	instanceVariableNames:''
	classVariableNames:'LoadedFeatures'
	poolDictionaries:''
	category:'System-Support'
!

!ConfigurableFeatures class methodsFor:'documentation'!

documentation
"
    being tired of finding '(Smalltalk at:someClass) notNil' all over the place,
    start to concentrate feature queries to this single class, which might get more
    feature methods via extensions.
    Thus, to correctly ask for a feature being present, use:
        ConfigurableFeature includesFeature:featureName
    or
        ConfigurableFeatures knownFeatures
    to ask for a list of features.

    Caveat: just started; more will be moved to this place as time goes by
"
! !

!ConfigurableFeatures class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    LoadedFeatures := Dictionary new

    "Modified: / 01-12-2014 / 11:16:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries'!

allFeatures
    "a list of features which are present in that smalltalk configuration"

    ^ self knownFeatures select:[:each | self includesFeature:each]

    "
     ConfigurableFeatures allFeatures 
    "

    "Created: / 07-09-2011 / 10:50:31 / cg"
!

includesFeature:featureName
    |querySelector|

    querySelector := ('has',featureName asUppercaseFirst) asSymbol.
    ^ self perform:querySelector ifNotUnderstood:false.

    "
     ConfigurableFeatures includesFeature:#SubversionSupport
    "

    "Created: / 07-09-2011 / 10:49:08 / cg"
!

knownFeatures
    "a list of known features; some of them might not be present in that smalltalk configuration"

    ^ self class methodDictionary keys
        collect:[:each | 
            (each startsWith:'has') ifTrue:[
                (each endsWith:':') ifFalse:[
                    each copyFrom:4
                ]
            ] ifFalse:[
                nil
            ].
        ]
        thenSelect:[:nm | nm notNil]

    "
     ConfigurableFeatures allFeatures
    "

    "Created: / 07-09-2011 / 10:51:26 / cg"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasCVSSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'CVSSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasCVSSupport
    "

    "Created: / 03-01-2012 / 15:36:54 / cg"
!

hasCVSSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'CVSSourceCodeManager'

    "Created: / 03-01-2012 / 15:42:16 / cg"
!

hasDataBaseSourceCodeManagerSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'DataBaseSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasDataBaseSourceCodeManagerSupport
    "

    "Created: / 03-01-2012 / 15:36:03 / cg"
!

hasDataBaseSourceCodeManagerSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'DataBaseSourceCodeManager'

    "Created: / 03-01-2012 / 15:36:12 / cg"
!

hasExternalLookupSupport
    "Return true, if the VM is compiled with external lookup MOP"
%{
#ifdef SUPPORT_EXTERNAL_LOOKUP
    RETURN ( true );
#endif
%}.
    ^false

    "
        ConfigurableFeatures hasExternalLookupSupport
        ConfigurableFeatures includesFeature:#ExternalLookupSupport
    "

    "Created: / 16-04-2012 / 20:00:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFileBasedSourceCodeManagerSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'FileBasedSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasFileBasedSourceCodeManagerSupport
    "

    "Created: / 21-12-2011 / 17:07:21 / cg"
!

hasFileBasedSourceCodeManagerSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'FileBasedSourceCodeManager'

    "Created: / 21-12-2011 / 17:07:08 / cg"
!

hasGitSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'GitSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasGitSupport
    "

    "Created: / 23-07-2012 / 13:37:09 / cg"
!

hasGitSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'GitSourceCodeManager'

    "
     self hasGitSupportEnabled
    "

    "Created: / 23-07-2012 / 13:37:17 / cg"
!

hasMercurialSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'MercurialSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasMercurialSupport
    "

    "Created: / 18-01-2012 / 10:58:07 / cg"
!

hasMercurialSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'MercurialSourceCodeManager'

    "
     self hasMercurialSupportEnabled
    "

    "Created: / 18-01-2012 / 10:58:12 / cg"
!

hasMonticelloSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'MonticelloSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasMonticelloSupport
    "

    "Created: / 03-01-2012 / 15:44:32 / cg"
!

hasMonticelloSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'MonticelloSourceCodeManager'

    "Created: / 03-01-2012 / 15:44:39 / cg"
!

hasPerforceSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'PerforceSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasPerforceSupport
    "

    "Created: / 03-01-2012 / 15:43:42 / cg"
!

hasPerforceSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'PerforceSourceCodeManager'

    "Created: / 03-01-2012 / 15:43:28 / cg"
!

hasRefactoryBrowser
    "Return true, if refactory browser support is available"

    (LoadedFeatures includesKey: #RefactoryBrowser) ifFalse:[ 
        "/ Called for the very first time

        #(
            #'stx:goodies/refactoryBrowser/browser'
            #'stx:goodies/refactoryBrowser/changes'
            #'stx:goodies/refactoryBrowser/helpers'
            #'stx:goodies/refactoryBrowser/lint'
            #'stx:goodies/refactoryBrowser/parser'
            #'stx:goodies/refactoryBrowser/refactoring'
        ) do:[:each | 
            (ProjectDefinition definitionClassForPackage: each) isNil ifTrue:[
                | loaded |

                loaded := [ Smalltalk loadPackage: each ] on: PackageLoadError do:[ false ].
                loaded ifFalse:[ 
                    LoadedFeatures at: #RefactoryBrowser put: false.
                    ^ false.
                ].
            ]
        ].
        LoadedFeatures at: #RefactoryBrowser put: true.
        ^ true
    ].
    ^ LoadedFeatures includesKey: #RefactoryBrowser

    "
    ConfigurableFeatures includesFeature: #RefactoryBrowser    
    "

    "Created: / 01-12-2014 / 11:16:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSCMSupportEnabledFor:aSourceCodeManagerClassName
    |scm|

    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    scm := Smalltalk at:aSourceCodeManagerClassName ifAbsent:nil.

    ^ scm notNil
        and:[ scm isLoaded 
        and:[ scm shownInBrowserMenus ]]

    "Created: / 18-01-2012 / 10:55:58 / cg"
!

hasSubversionSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'SVNSourceCodeManager' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasSubversionSupport
    "

    "Created: / 07-09-2011 / 10:40:40 / cg"
    "Modified: / 13-03-2012 / 17:19:13 / Jan Vrany <jan.vrany.fit.cvut.cz>"
!

hasSubversionSupportEnabled
    ^ self hasSCMSupportEnabledFor:#'SVNSourceCodeManager'

    "Created: / 07-09-2011 / 10:41:33 / cg"
! !

!ConfigurableFeatures class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ConfigurableFeatures.st,v 1.11 2014-12-01 11:24:54 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/ConfigurableFeatures.st,v 1.11 2014-12-01 11:24:54 vrany Exp $'
! !


ConfigurableFeatures initialize!
