"{ Package: 'stx:libscm/git' }"

SCMAbstractSourceCodeManager subclass:#GitSourceCodeManager2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-StX'
!


!GitSourceCodeManager2 class methodsFor:'accessing'!

repositoryNameForPackage:packageId
    "Return the repository ULR for the given package. 
     Used for testing/debugging source code management configuration"

    ^ GitRepository discover: (Smalltalk getPackageDirectoryForPackage: packageId)

    "Modified: / 06-10-2012 / 22:04:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManager2 class methodsFor:'accessing-classes'!

commitDialogClass
    "Answer a dialog class to be used for commits"

    ^GitCommitDialog

    "Created: / 13-11-2012 / 23:59:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageRegistryClass
    "Answer the package manager class used to get
     package models"
    
    ^ GitPackageModelRegistry

    "Created: / 13-11-2012 / 23:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManager2 class methodsFor:'queries'!

isResponsibleForPackage:aStringOrSymbol
    "Returns true if the manager can handle source code for given package.
     
     Answering true does not imply that receiver is configured default
     manager for that package, it only means that it has a repository
     configured for given package."


    "No configuration yet, so let's scan the working copy"
    ^(GitRepository discover: 
        (Smalltalk getPackageDirectoryForPackage: aStringOrSymbol))
        notNil

    "Modified: / 06-10-2012 / 19:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^ 'Git+'

    "Modified: / 06-10-2012 / 17:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeNameShort
    ^ 'GIT'

    "Created: / 06-10-2012 / 17:10:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodForExtensions
    "that is the old name; now, we use extensionsVersion_<SCM>"

    ^ #'extensionsVersion_GIT'

    "Modified (comment): / 29-09-2011 / 13:27:04 / cg"
    "Modified: / 07-10-2012 / 00:04:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOfVersionMethodInClasses
    "that is the old name; now, we use version_<SCM>"

    ^ #'version_GIT'

    "Modified (comment): / 29-09-2011 / 13:27:09 / cg"
    "Modified: / 07-10-2012 / 00:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ GitSourceCodeManagementSettingsAppl2

    "Modified: / 02-10-2012 / 14:29:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForJavaScriptFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
"'function ',"aSelector,'() {
    /* Never, ever change this method. Ask JV or CG why */
    return thisContext.method().mclass().theNonMetaclass().instVarNamed("revision")
}'

    "Created: / 07-10-2012 / 00:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForRubyFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
'def self.',aSelector,'()
    # Never, ever change this method. Ask JV or CG why
    return thisContext.method().mclass().theNonMetaclass().instVarNamed("revision")
end'

    "Created: / 07-10-2012 / 00:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForSmalltalkFor:aSelector
    "do not make the thing below a single string - otherwise
     it would get expanded by the sourcecodemanager, which we do not want here"

    ^
aSelector,'
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
'

    "Created: / 07-10-2012 / 00:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManager2 class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
