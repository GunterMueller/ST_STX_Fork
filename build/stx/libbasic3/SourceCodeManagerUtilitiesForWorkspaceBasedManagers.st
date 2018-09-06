"
 COPYRIGHT (c) 2012 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

SourceCodeManagerUtilities subclass:#SourceCodeManagerUtilitiesForWorkspaceBasedManagers
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!SourceCodeManagerUtilitiesForWorkspaceBasedManagers class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SourceCodeManagerUtilitiesForWorkspaceBasedManagers methodsFor:'utilities-cvs'!

checkinPackage:packageToCheckIn classes:doClasses extensions:doExtensions buildSupport:doBuild askForMethodsInOtherPackages:askForMethodsInOtherPackages
    |mgr classesToCheckIn methodsToCheckIn
     methodsInOtherPackages looseMethods otherPackages
     msg classesInChangeSet checkinInfo repos pkgDir extensionsSource defClass
     path fileIsNew|

    mgr := self sourceCodeManagerFor: packageToCheckIn.

    repos := (mgr repositoryNameForPackage:packageToCheckIn) ifNil:[mgr repositoryName].

    pkgDir := packageToCheckIn asPackageId pathRelativeToTopDirectory:(mgr workDirectory). 
    pkgDir recursiveMakeDirectory.

    "/ containerFileName := self nameOfExtensionsContainer.

    methodsToCheckIn := IdentitySet new.
    methodsInOtherPackages := IdentitySet new.
    looseMethods := IdentitySet new.

    classesToCheckIn := Smalltalk allClassesInPackage: packageToCheckIn.

    "/ cg: O(n^2) algorithm
    "/  classesInChangeSet := classesToCheckIn select:[:cls | cls hasUnsavedChanges].
    "/ replaced by: O(n) algorithm
    classesInChangeSet := ChangeSet current selectClassesForWhichIncludesChangeForClassOrMetaclassOrPrivateClassFrom:classesToCheckIn. 

    "/ individual methods ...
    Smalltalk allClassesDo:[:aClass |
        aClass isMeta ifFalse:[
            methodsToCheckIn addAll:(aClass extensionsFrom:packageToCheckIn).
        ].
    ].

    self assert:doExtensions.
    self assert:doClasses.
    self assert:doBuild.

    msg := '%1 classes (%4 changed) '.
    methodsToCheckIn notEmpty ifTrue:[
        msg := msg , 'and %2 extensions '.
    ].
    msg := msg , 'of project "%3"'.

    checkinInfo := self
                getCheckinInfoFor:(msg
                                        bindWith:classesToCheckIn size
                                        with:methodsToCheckIn size
                                        with:packageToCheckIn allBold
                                        with:classesInChangeSet size)
                initialAnswer:nil
                withQuickOption:false
                withValidateConsistencyOption:true.
    checkinInfo isNil ifTrue:[
        ^ self.
    ].

    checkinInfo validateConsistency ifTrue:[
        self validateConsistencyOfPackage:packageToCheckIn.
    ].

    "/ check if any of the classes contains methods for other packages ...
    classesToCheckIn do:[:eachClass |
        eachClass instAndClassMethodsDo:[:eachMethod |
            |mPgk|

            mPgk := eachMethod package.
            (mPgk = packageToCheckIn) ifFalse:[
                mPgk == PackageId noProjectID ifTrue:[
                    looseMethods add:eachMethod
                ] ifFalse:[
                    methodsInOtherPackages add:eachMethod
                ]
            ]
        ].
    ].

    askForMethodsInOtherPackages ifTrue:[
        methodsInOtherPackages notEmpty ifTrue:[
            otherPackages := Set new.
            methodsInOtherPackages do:[:eachMethod | otherPackages add:eachMethod package].

            methodsInOtherPackages size == 1 ifTrue:[
                msg := 'The ''%4'' method in ''%5'' is contained in the ''%2'' package.'.
                msg := msg , '\\This method will remain in its package.'.
            ] ifFalse:[
                otherPackages size == 1 ifTrue:[
                    msg := 'The %1 methods from the %2 package will remain in its package.'
                ] ifFalse:[
                    msg := 'The %1 methods from %3 other packages will remain in their packages.'
                ].
                msg := msg , '\\Hint: if these are meant to belong to this package,'.
                msg := msg , '\move them first, then repeat the checkin operation.'.
            ].
            msg := msg withCRs.
            msg := msg bindWith:methodsInOtherPackages size
                           with:otherPackages first allBold
                           with:otherPackages size
                           with:methodsInOtherPackages first selector allBold
                           with:methodsInOtherPackages first mclass name allBold.
            (Dialog confirm:msg noLabel:(resources string:'Cancel')) ifFalse:[^ self].
        ].
    ].

    classesToCheckIn notEmpty ifTrue:[
        looseMethods notEmpty ifTrue:[
            looseMethods size == 1 ifTrue:[
                msg := 'The ''%2'' method in ''%3'' is unassigned (loose).'.
                msg := msg , '\\If you proceed, this method will be moved to the ''%4'' package'.
                msg := msg , '\\Hint: if this is meant to be an extension of another package,'.
                msg := msg , '\cancel and move it to the appropriate package first.'.
            ] ifFalse:[
                msg := 'There are %1 unassigned (loose) methods in classes from this project.'.
                msg := msg , '\\If you proceed, those will be moved to the ''%4'' package ?'.
                msg := msg , '\\Hint: if these are meant to be extensions of another package,'.
                msg := msg , '\cancel and move them to the appropriate package first.'.
            ].
            msg := msg withCRs.
            msg := msg bindWith:looseMethods size
                           with:(looseMethods isEmpty ifTrue:[''] ifFalse:[looseMethods first selector allBold])
                           with:(looseMethods isEmpty ifTrue:[''] ifFalse:[looseMethods first mclass name allBold])
                           with:packageToCheckIn allBold.
            (Dialog confirm:msg noLabel:(resources string:'Cancel')) ifFalse:[^ self].

            looseMethods do:[:mthd |
                mthd package:packageToCheckIn
            ].
        ].

        classesToCheckIn do:[:eachClass |
            |classFileName|

            classFileName := (Smalltalk fileNameForClass:eachClass) , '.st'.
            mgr
                withClass:eachClass 
                classFileName:classFileName 
                filedOutToTemporaryFileDo:[:tempFile |
                    path := pkgDir construct:classFileName.
                    fileIsNew := path exists not.
                    tempFile moveTo:path.
                    fileIsNew ifTrue:[
                        mgr addFile:path baseName inDirectory:path directory.
                    ].
                ].
        ].
    ].

    path := pkgDir construct:self nameOfExtensionsContainer.
    methodsToCheckIn notEmpty ifTrue:[
        extensionsSource := self sourceCodeForExtensions:methodsToCheckIn package:packageToCheckIn forManager:mgr.
        "Care for non-ASCII/non-ISO-8859 characters in extension methods"
        extensionsSource isWideString ifTrue:[
            extensionsSource := '"{ Encoding: utf8 }"' , Character cr asString , Character cr asString , extensionsSource.                
            extensionsSource := extensionsSource utf8Encoded.
        ].
        fileIsNew := path exists not.
        path contents:extensionsSource.
        fileIsNew ifTrue:[
            mgr addFile:path baseName inDirectory:path directory.
        ].
   ] ifFalse:[
        "/ there may have been extension-methods previously - if so, remove them
        path remove
    ].

    defClass := ProjectDefinition definitionClassForPackage: packageToCheckIn.
    defClass forEachFileNameAndGeneratedContentsDo:[:fileName :fileContents |
        path := pkgDir construct:fileName.
        fileIsNew := path exists not.
        path directory exists ifFalse:[
            path directory recursiveMakeDirectory. "/ for autopackage
            mgr addFile:path directory baseName inDirectory:path directory directory.
        ].
        path contents:fileContents.
        fileIsNew ifTrue:[
            mgr addFile:fileName inDirectory:path directory.
        ].
    ].

    mgr commitRepository:repos logMessage:checkinInfo logMessage.

    "Created: / 13-10-2011 / 11:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-09-2012 / 11:13:04 / cg"
! !

!SourceCodeManagerUtilitiesForWorkspaceBasedManagers class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/SourceCodeManagerUtilitiesForWorkspaceBasedManagers.st,v 1.5 2013-03-27 12:02:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/SourceCodeManagerUtilitiesForWorkspaceBasedManagers.st,v 1.5 2013-03-27 12:02:47 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id:: SourceCodeManagerUtilitiesForWorkspaceBasedManagers.st 1971 2012-09-27 19:37:25Z vranyj1                               §'
! !

