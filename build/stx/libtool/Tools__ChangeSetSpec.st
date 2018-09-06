"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#ChangeSetSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

ChangeSetSpec subclass:#Directory
	instanceVariableNames:'directory'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetSpec
!

ChangeSetSpec subclass:#Explicit
	instanceVariableNames:'changeSet'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetSpec
!

ChangeSetSpec subclass:#File
	instanceVariableNames:'file'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetSpec
!

ChangeSetSpec subclass:#Package
	instanceVariableNames:'package'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetSpec
!

ChangeSetSpec::Directory subclass:#PackageDirectory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetSpec
!

!ChangeSetSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ChangeSetSpec class methodsFor:'instance creation'!

changeSet

    ^Explicit new

    "Created: / 03-08-2012 / 15:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSet: changeset

    ^Explicit new changeSet: changeset

    "Created: / 19-03-2012 / 23:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directory: directory

    ^Directory new package: directory

    "Created: / 19-03-2012 / 23:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file: file

    ^File new file: file

    "Created: / 19-03-2012 / 23:58:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package: package

    ^Package new package: package

    "Created: / 19-03-2012 / 23:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec class methodsFor:'accessing'!

editorSpecSelector

    ^self subclassResponsibility

    "Created: / 05-07-2011 / 23:37:03 / jv"
!

label

    ^self subclassResponsibility

    "Created: / 05-07-2011 / 23:29:33 / jv"
!

specClasses

    ^(self allSubclasses " reject:[:e|e == Explicit]") asSortedCollection:[:a :b | a name < b name ].

    "Created: / 05-07-2011 / 23:30:45 / jv"
    "Modified: / 12-11-2013 / 15:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec methodsFor:'accessing'!

changeSet

    ^self subclassResponsibility

    "Created: / 05-07-2011 / 23:13:35 / jv"
!

directory
    ^'N/A'

    "Created: / 19-03-2012 / 23:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editorSpecSelector

    ^self class editorSpecSelector

    "Created: / 06-07-2011 / 09:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file
    ^'N/A'

    "Created: / 19-03-2012 / 23:31:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    ^'N/A'

    "Created: / 19-03-2012 / 23:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec methodsFor:'testing'!

isChangeSet
    ^self isExplicit

    "Created: / 20-03-2012 / 14:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDirectory
    ^false

    "Created: / 20-03-2012 / 14:59:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExplicit
    ^false

    "Created: / 20-03-2012 / 14:58:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFile
    ^false

    "Created: / 20-03-2012 / 14:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPackage
    ^false

    "Created: / 20-03-2012 / 14:58:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::Directory class methodsFor:'accessing'!

editorSpecSelector
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ #editorSpecForDirectory

    "Modified: / 05-07-2011 / 23:37:41 / jv"
!

label
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ 'Directory'

    "Modified: / 05-07-2011 / 23:31:12 / jv"
! !

!ChangeSetSpec::Directory methodsFor:'accessing'!

changeSet
    "superclass Tools::ChangeSetSpec says that I am responsible to implement this method"

    | name |
    name := directory asString.
    name size > 50 ifTrue:[
        name := '...' , (name copyFrom: name size - 47)
    ].

    ^(ChangeSet fromDirectory: self directory)
        name: name

    "Modified (format): / 06-07-2011 / 11:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directory
    ^ directory
!

directory:aStringOrFilename
    directory := aStringOrFilename.
! !

!ChangeSetSpec::Directory methodsFor:'testing'!

isDirectory
    ^true

    "Created: / 20-03-2012 / 14:59:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::Explicit class methodsFor:'accessing'!

editorSpecSelector
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ #editorSpecForExplicit

    "Modified: / 03-08-2012 / 15:21:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ 'ChangeSet object'

    "Modified: / 03-08-2012 / 15:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::Explicit methodsFor:'accessing'!

changeSet
    "superclass Tools::ChangeSetSpec says that I am responsible to implement this method"

    changeSet isNil ifTrue:[changeSet := ChangeSet new].
    ^ changeSet

    "Modified: / 03-08-2012 / 15:22:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSet:something
    changeSet := something.
! !

!ChangeSetSpec::Explicit methodsFor:'testing'!

isExplicit
    ^true

    "Created: / 20-03-2012 / 14:59:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::File class methodsFor:'accessing'!

editorSpecSelector
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ #editorSpecForFile

    "Modified: / 19-03-2012 / 22:04:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ 'File'

    "Modified: / 19-03-2012 / 22:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::File methodsFor:'accessing'!

changeSet
    "superclass Tools::ChangeSetSpec says that I am responsible to implement this method"

    | name |
    name := file asString.
    name size > 50 ifTrue:[
        name := '...' , (name copyFrom: name size - 47)
    ].

    ^(ChangeSet fromFile: self file)
        name: name

    "Modified: / 20-03-2012 / 11:31:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file
    ^ file
!

file:something
    file := something.
! !

!ChangeSetSpec::File methodsFor:'testing'!

isFile
    ^true

    "Created: / 20-03-2012 / 14:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::Package class methodsFor:'accessing'!

editorSpecSelector
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ #editorSpecForPackage

    "Modified: / 05-07-2011 / 23:37:52 / jv"
!

label
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ 'Package (in image)'

    "Modified: / 05-07-2011 / 23:31:34 / jv"
    "Modified: / 12-11-2013 / 15:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::Package methodsFor:'accessing'!

changeSet
    "superclass Tools::ChangeSetSpec says that I am responsible to implement this method"

    ^ (ChangeSet forPackage: self package) 
        name: ('Package %1 (from image)' bindWith: package)

    "Modified: / 06-07-2011 / 11:38:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    ^ package
!

package:aStringOrSymbol
    package := aStringOrSymbol.
! !

!ChangeSetSpec::Package methodsFor:'testing'!

isPackage
    ^true

    "Created: / 20-03-2012 / 14:59:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::PackageDirectory class methodsFor:'accessing'!

label
    "superclass Tools::ChangeSetSpec class says that I am responsible to implement this method"

    ^ 'Package (in directory)'

    "Created: / 12-11-2013 / 15:17:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec::PackageDirectory methodsFor:'accessing'!

changeSet
    "superclass Tools::ChangeSetSpec says that I am responsible to implement this method"

    | name |
    name := directory asString.
    name size > 50 ifTrue:[
        name := '...' , (name copyFrom: name size - 47)
    ].

    ^(ChangeSet fromDirectory: self directory asSmalltalkXPackage: true)
        name: name

    "Created: / 12-11-2013 / 15:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2013 / 22:28:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSpec class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ChangeSetSpec.st,v 1.4 2014-03-02 22:37:29 cg Exp $'
! !

