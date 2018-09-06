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
"{ Package: 'stx:libscm/mercurial' }"

HGRepositoryObject subclass:#HGConfig
	instanceVariableNames:'root timestamp'
	classVariableNames:'UserConfig'
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

Object subclass:#Entry
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGConfig
!

Dictionary subclass:#Section
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGConfig
!

!HGConfig class methodsFor:'documentation'!

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

!HGConfig class methodsFor:'accessing'!

userConfig
    UserConfig isNil ifTrue:[ 
        UserConfig := self new.
    ].
    ^ UserConfig

    "
    (HGConfig userConfig get:'ui') get:'username'
    "

    "Created: / 18-02-2014 / 11:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig class methodsFor:'accessing-file templates'!

userConfigFileTemplate
    ^
'[ui]
# At least, a username is required to commit.
username = FirstName LastName <Email>
'
! !

!HGConfig class methodsFor:'accessing-files'!

userConfigFile
    "Return user config file"

    | files |

    files := self userConfigFiles.
    ^ files detect:[:e | e asFilename exists ] ifNone:[ files first ].

    "Created: / 18-02-2014 / 10:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

userConfigFiles
    "Return a list of per-user config files"

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^{
            Filename homeDirectory / '.hgrc' .
            Filename homeDirectory / 'Mercurial.ini'
        }
    ].

    OperatingSystem isUNIXlike ifTrue:[
        ^{
            Filename homeDirectory / '.hgrc' .
        }
    ].

    self error:'Unsupported operating system'

    "Created: / 06-12-2012 / 20:30:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-12-2012 / 21:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig methodsFor:'accessing'!

at: key
    ^self root at:key

    "Created: / 06-12-2012 / 20:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: key ifAbsent: block
    ^self root at:key ifAbsent: block

    "Created: / 06-12-2012 / 20:23:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: key ifAbsentPut: block
    ^self root at:key ifAbsentPut: block

    "Created: / 06-12-2012 / 20:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: key put: val
    ^self root at:key put: val

    "Created: / 06-12-2012 / 20:23:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

get: key
    ^self root get:key

    "Created: / 06-12-2012 / 20:22:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

get: key default: default
    ^self root get:key default: default

    "Created: / 07-12-2012 / 15:46:07 / jv"
! !

!HGConfig methodsFor:'accessing-common values'!

ui_username
    ^ self get:#(ui username) default: nil.

    "
    HGConfig userConfig ui_username
    "

    "Created: / 18-02-2014 / 11:24:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig methodsFor:'private'!

mustReload
    root isNil ifTrue:[ ^ true ].

    repository notNil ifTrue:[
        (self mustReloadBecauseOf: repository path / '.hg' / 'hgrc') ifTrue:[
            ^true
        ].
    ].
    HGConfig userConfigFiles do:[:e|
        (self mustReloadBecauseOf: e) ifTrue:[ ^ true ].
    ].
    ^false

    "Created: / 06-12-2012 / 21:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2012 / 16:28:33 / jv"
    "Modified: / 18-02-2014 / 11:20:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mustReloadBecauseOf: filenameOrString
    "Return true, if config must be reloaded because file is newer"

    | filename |

    filename := filenameOrString asFilename.
    "/compensate for lack of milliseconds in OS time ---v
    ^filename exists and:[(filename modificationTime + 1000) >= timestamp].

    "Created: / 07-12-2012 / 16:26:38 / jv"
    "Modified: / 18-02-2014 / 12:33:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

root
    self mustReload ifTrue:[
        | command |    
        timestamp := Timestamp now.
        command :=HGCommand showconfig.
        repository notNil ifTrue:[
            command workingDirectory: repository pathName.
        ].
        root := command execute.
    ].
    ^root

    "Created: / 06-12-2012 / 20:25:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2014 / 11:16:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig::Entry methodsFor:'accessing'!

name
    ^ name
!

value
    ^ value
! !

!HGConfig::Entry methodsFor:'initialization'!

setName: nm value: val
    name := nm.
    value := val.

    "Created: / 06-12-2012 / 19:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig::Entry methodsFor:'testing'!

isEntry
    ^true

    "Created: / 06-12-2012 / 19:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSection
    ^false

    "Created: / 06-12-2012 / 19:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig::Section methodsFor:'accessing'!

get: key

    | entry |

    entry := self.
    (key isCollection and:[key isString not]) ifTrue:[
        key do:[:e|entry := entry at: e]
    ] ifFalse:[
        entry := entry at:key.
    ].
    ^entry value

    "Created: / 06-12-2012 / 20:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 21:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

get: key default: default
    | entry |

    entry := self.
    (key isCollection and:[key isString not]) ifTrue:[
        key do:[:e|entry := entry at: e ifAbsent:[ ^ default ]]
    ] ifFalse:[
        entry := entry at:key ifAbsent:[ ^ default ].
    ].
    ^entry value

    "Created: / 06-12-2012 / 20:07:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 21:49:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
! !

!HGConfig::Section methodsFor:'initialization'!

setName: nm 
    name := nm.

    "Created: / 06-12-2012 / 19:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2014 / 12:31:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig::Section methodsFor:'testing'!

isEntry
    ^false

    "Created: / 06-12-2012 / 19:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSection
    ^true

    "Created: / 06-12-2012 / 19:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGConfig class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

