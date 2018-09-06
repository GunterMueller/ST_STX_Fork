"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/common' }"

"{ NameSpace: Smalltalk }"

SourceCodeManagerUtilities subclass:#SCMCommonSourceCodeManagerUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMCommonSourceCodeManagerUtilities class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!SCMCommonSourceCodeManagerUtilities methodsFor:'utilities-cvs'!

checkinClass:aClass withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil
    "check a class into the source repository.
     If the argument, aLogInfoOrNil isNil, ask interactively for log-message.
     If doCheckClass is true, the class is checked for send of halts etc."

   ^self checkinClasses:(Array with: aClass) withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil

    "Created: / 25-12-2011 / 23:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkinClasses:classes withInfo:aLogInfoOrNil withCheck:doCheckClass usingManager:aManagerOrNil
    | classesPerPackage |

    classesPerPackage := Dictionary new.
    classes do: [:class|
        (classesPerPackage at: class theNonMetaclass package ifAbsentPut:[Set new])
            add: class theNonMetaclass].
    classesPerPackage keysAndValuesDo:
        [:packageId :classes| | package |
        package := manager packageRegistryClass packageNamed: packageId.
        manager commitDialogClass new
                task: (package commitTask
                        classes: classes;
                        message: aLogInfoOrNil;
                        extensionMethods: #()
                        yourself);
                open].
    ^ true

    "Modified: / 06-05-2011 / 10:32:55 / cg"
    "Created: / 25-12-2011 / 23:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 00:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkinPackage:packageToCheckIn classes:doClasses extensions:doExtensions buildSupport:doBuild askForMethodsInOtherPackages:askForMethodsInOtherPackages

    | package task |
    package := manager packageRegistryClass packageNamed: packageToCheckIn.
    package isNil ifTrue:[
        Dialog warn: (resources string: 'No repository for package %1' with: packageToCheckIn).
        ^self
    ].
    task := package commitTask.
    task suppressClasses: doClasses not.
    task suppressExtensions: doExtensions not.
    task suppresBuildSupportFiles: doBuild not.

    package commitDialog
            task: task;
            open

    "Created: / 13-10-2011 / 11:16:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 22:29:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compareProject:aProject withRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly
    |diffSet|

    diffSet := self diffSetOfProject:aProject againstRepositoryVersionFrom:aDateOrNilForNewest extensionsOnly:extensionsOnly.

    (Tools::ChangeSetDiffTool new)
        diffset:diffSet;
        title:('Differences of %1' bindWith:aProject);
        open.

    "Created: / 18-01-2012 / 16:04:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffSetOfProject: package againstRepositoryVersionFrom:dateOrNil extensionsOnly:extensionsOnly

    self shouldImplement

    "Created: / 15-10-2011 / 23:26:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 01:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagClass:aClass as:tag

    Dialog warn: 'Individual class tagging not supported by SubVersion. Tag whole package instead'.

    "Modified: / 12-09-2006 / 13:03:59 / cg"
    "Created: / 15-10-2011 / 22:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagClasses:classes as:tag

    Dialog warn: 'Individual class tagging not supported by SubVersion. Tag whole package instead'.

    "Modified: / 12-09-2006 / 13:03:59 / cg"
    "Created: / 15-10-2011 / 22:49:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagPackage: package as:tag

    Dialog warn: 'Not yet implemented'

    "Created: / 12-09-2006 / 13:04:29 / cg"
    "Created: / 15-10-2011 / 22:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMCommonSourceCodeManagerUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Path: stx/libscm/common/SCMCommonSourceCodeManagerUtilities.st, Version: 1.0, User: cg, Time: 2015-11-25T18:55:35.578+01$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

