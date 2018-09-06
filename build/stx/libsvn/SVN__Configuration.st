"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Object subclass:#Configuration
	instanceVariableNames:'name repositories'
	classVariableNames:'Current Configurations'
	poolDictionaries:''
	category:'SVN-Configuration'
!

Object subclass:#Repository
	instanceVariableNames:'package pattern url branch'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Configuration
!

!Configuration class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!Configuration class methodsFor:'instance creation'!

named: aString

    ^self new name: aString.
    "
        self named: 'Default configuration'
    "

    "Created: / 09-01-2010 / 12:23:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2010 / 18:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

newRepository

    ^Repository new.

    "Created: / 09-03-2010 / 18:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration class methodsFor:'accessing'!

configurations
    Configurations isNil ifTrue:[
        "JV@2011-01-17: Changed to not use UserPrefs current at:ifAbsent: but 
         #svnConfigurations2 as it was in my original version. 
         Rationale: #svnConfigurations2 does the literal array decoding,
         The real config is not stored under #svnConfigurations2. Therefore
         using at:ifAbsent: ALWAYS falls into ifAbsent block.
         Using #svnConfigurations2 here is safe - the method belongs to
         libsvn as well as this class."
        Configurations := UserPreferences current svnConfigurations2.
        "/Original CVS code
        "/Configurations := UserPreferences current at:#svnConfigurations2 ifAbsent:#()
    ].
    ^ Configurations

    "Created: / 09-01-2010 / 15:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-10-2011 / 14:37:40 / cg"
    "Modified: / 17-01-2012 / 23:14:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-02-2012 / 15:11:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

configurations: aCollection"of Configuration"

    "JV@2012-02-23: Changed to not use UserPrefs current at:ifAbsent: but 
     #svnConfigurations2: as it was in my original version. 
     Rationale: #svnConfigurations2 does the literal array decoding,
     The real config is not stored under #svnConfigurations2 key anyway.
     Doing
        UserPrefs current at:#svnConfigurations2 put: ...
     Causes configuration structure __storeString__ to be saved,
     which will lead into troubles later on as libsvn may not
     be present. DONT DO THAT.
     Using #svnConfigurations2: here is safe - the method belongs to
     libsvn as well as this class.
    "    

    Configurations := aCollection.
    UserPreferences current svnConfigurations2: aCollection.

    "Created: / 11-02-2010 / 16:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2011 / 14:36:49 / cg"
    "Modified (comment): / 23-02-2012 / 15:11:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

current

    Current ifNil:[
        "/ cg: seems to be called BEFORE that method is there (sometimes?)
        (UserPreferences implements:#svnCurrentConfiguration) ifTrue:[
            Current := UserPreferences current svnCurrentConfiguration.
        ]
    ].
    ^Current

    "Created: / 09-01-2010 / 12:27:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2010 / 16:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-08-2011 / 18:29:02 / cg"
!

current: aConfiguration

    UserPreferences current svnCurrentConfiguration: aConfiguration

    "Created: / 10-03-2010 / 13:21:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultName

    ^'Default configuration'

    "Created: / 11-02-2010 / 18:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableValuesForPackage:pkg 
    |packageId packagePath|

    packageId := pkg asPackageId.
    packagePath := pkg asString copyReplaceAll:$: with:$/.
    ^ ((Dictionary new)
        at:'MODULE' put:packageId module;
        at:'DIRECTORY' put:packageId directory;
        at:'PATH' put:packagePath;
        at:'DOTTED_PATH' put:(packagePath copyReplaceAll:$/ with:$.);
        "/for compatibility, will wanish
        at:'p' put:packagePath;
        "/ Bit hakish, but works :-)
        at: 'BRANCH' put: '%(BRANCH)';
        yourself)

    "Created: / 09-03-2010 / 22:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2011 / 09:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration class methodsFor:'accessing - private'!

getConfigurations

    ^Configurations

    "Created: / 10-03-2010 / 13:24:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getCurrent

    ^Current

    "Created: / 10-03-2010 / 13:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setConfigurations: aCollection

    Configurations := aCollection asOrderedCollection.
    Current ifNotNil:
        [Current := Configurations 
                        detect:[:each|each name = Current name]
                        ifNone:[self error:'Current configuration is not in new configurations!!']].

    "Created: / 09-01-2010 / 15:37:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setCurrent: aConfiguration

    Current := aConfiguration.

    "Created: / 10-03-2010 / 13:20:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration class methodsFor:'utilities'!

flushCaches

    Current := nil.
    Configurations := nil.

    "Created: / 11-02-2010 / 16:08:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration methodsFor:'accessing'!

name
    ^ name
!

name:aString
    name := aString.
!

package: package url: url

    ^repositories add:
        (Configuration::Repository 
            package: package
            url: url).

    "Created: / 11-03-2011 / 18:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package: package url: url branch: branch

    ^repositories add:
        (Configuration::Repository 
            package: package
            url: url
            branch: branch).
!

repositories
    ^ repositories
!

repositories:aCollection
    repositories := aCollection.
!

repositoryFor: packageId

    repositories do:
        [:repoConf|
        (repoConf matches: packageId)
            ifTrue:[^repoConf repositoryFor: packageId]].
    "Nothing found"
    ^nil

    "Created: / 09-01-2010 / 12:05:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration methodsFor:'comparing'!

= anotherConfig

    self class = anotherConfig class ifFalse:[^false].
    self name = anotherConfig name ifFalse:[^false].        
    self repositories asArray = anotherConfig repositories asArray ifFalse:[^false].
    ^true

    "Created: / 10-03-2010 / 13:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2012 / 14:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^name hash bitXor: repositories hash

    "Created: / 10-03-2010 / 13:34:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration methodsFor:'displaying'!

displayString

    ^name

    "Created: / 11-02-2010 / 19:13:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    name := '<unnamed>'.
    repositories := List new

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 30-04-2011 / 23:17:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-04-2011 / 23:17:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    name printOn:aStream.
    aStream nextPut:$).

    "Modified: / 09-01-2010 / 12:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository class methodsFor:'instance creation'!

package: package url: url

    ^self new 
        package: package;
        url: url; 
        yourself

    "Created: / 09-01-2010 / 12:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package: package url: url branch: branch

    ^self new 
        package: package;
        url: url; 
        branch: branch;
        yourself

    "Created: / 09-01-2010 / 14:59:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository methodsFor:'accessing'!

branch
    ^ branch
!

branch:aString
    branch := aString.
!

package
    ^ package
!

package:aString
    package := aString.
    pattern := PackagePattern for: aString

    "Modified: / 13-03-2011 / 08:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryFor: packageId

    ^(Repository 
        package: packageId asSymbol
        url: (self urlFor: packageId))
        preferredBranch: branch

    "Created: / 09-01-2010 / 12:20:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-03-2010 / 18:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

url
    ^ url
!

url:aString
    url := aString.
!

urlFor:pkg

    | placeholders repoUrl |
    placeholders := Configuration variableValuesForPackage:pkg.
    pattern match: pkg into: placeholders.
    repoUrl := url asString expandPlaceholdersWith: placeholders.
    (repoUrl includesSubString: '%(BRANCH)') ifFalse:[
        repoUrl := repoUrl , '/%(BRANCH)'.
    ].
    ^repoUrl

    "Created: / 09-01-2010 / 11:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2011 / 09:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository methodsFor:'comparing'!

= anotherConf

    ^self class == anotherConf class
        and:[package = anotherConf package
            and:[url = anotherConf url
                and:[branch = anotherConf branch]]].

    "Created: / 09-01-2010 / 11:20:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-05-2011 / 21:13:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^package hash bitXor: (url hash bitXor: branch hash)

    "Created: / 09-01-2010 / 11:21:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository methodsFor:'encoding & decoding'!

skippedInLiteralEncoding
    "return a Collection with it's elements are slots for skipping"

    ^ #(pattern)

    "Created: / 14-03-2011 / 09:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream space.
    aStream nextPutAll:'package: '.
    package printOn:aStream.
    aStream space.
    aStream nextPutAll:'pattern: '.
    pattern printOn:aStream.
    aStream space.
    aStream nextPutAll:'url: '.
    url printOn:aStream.
    aStream space.
    aStream nextPutAll:'branch: '.
    branch printOn:aStream.

    "Modified: / 18-10-2012 / 16:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration::Repository methodsFor:'queries'!

matches: packageId

    packageId ifNil:[^false].

    ^pattern matches: packageId

    "Created: / 09-01-2010 / 11:29:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2011 / 08:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Configuration class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'

!

version_SVN
    ^ '$Id$'
! !

