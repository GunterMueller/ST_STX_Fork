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

Object subclass:#Repository
	instanceVariableNames:'manager package url branches workingCopy preferredBranch'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!Repository class methodsFor:'documentation'!

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

!Repository class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

package: package url: url

    ^self new 
        package: package;
        url: url; 
        yourself

    "Created: / 19-08-2009 / 12:24:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Repository class methodsFor:'accessing - containers'!

classFromContainerName: aString

    | className |
    className := (aString includes: $.) 
                    ifTrue:[aString copyTo: (aString lastIndexOf:$.) - 1]
                    ifFalse:[aString].
    className replaceAll:$_ with:$:.
    ^Smalltalk classNamed: className

    "
        SVN::Repository classFromContainerName: 'Smalltalk.st'   
        SVN::Repository classFromContainerName: 'SVN__Repository.st'  
        SVN::Repository classFromContainerName: 'SVN__Repository.rb'  
        SVN::Repository classFromContainerName: 'Nothing.st'   

    "

    "Created: / 19-11-2009 / 15:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForClass: cls

    ^(self containerNameWithoutSuffixForClass: cls) , '.' , cls sourceFileSuffix

    "Created: / 19-04-2008 / 17:24:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 13-08-2009 / 15:26:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containerNameForExtensions

    ^'extensions.st'

    "Created: / 19-04-2008 / 17:25:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containerNameForExtensions: language

    ^'extensions.' , language sourceFileSuffix

    "Created: / 30-12-2009 / 22:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameWithoutSuffixForClass: cls

    ^self containerNameWithoutSuffixForClassNamed: 
        cls theNonMetaclass fullName

    "Created: / 13-08-2009 / 15:25:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

containerNameWithoutSuffixForClassNamed: clsName

    | containerName |
    containerName := clsName copyReplaceAll:$: with:$_.
    "/Transcript showCR:'Container for ',clsName,  ' is ' , containerName.
    ^containerName.

    "Created: / 13-08-2009 / 15:24:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Repository class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Repository class methodsFor:'private'!

urlForBranches: url

    | idx |
    idx := url indexOfSubCollection: '%(BRANCH)'.
    idx == 0 ifTrue:[self error:'No %(BRANCH) in url: ', url].
    (url at: idx - 1) == $/ ifTrue:[idx := idx - 1].
    ^url copyTo: idx - 1

    "Created: / 23-03-2011 / 18:46:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'accessing'!

branch

    ^self workingCopy branch

    "Created: / 19-04-2008 / 18:25:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

branchOrNil

    | branches branch |
    branches := self branches.
    branch := branches 
                detect:[:branch|branch path = preferredBranch]
                ifNone:[nil].
    branch ifNil:
        [branches size == 1 ifTrue:[branch := branches anyOne]].
    ^branch

    "Created: / 16-03-2010 / 10:47:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branches

    ^self branchesAndTags reject:[:branch|branch isTag]

    "Modified: / 14-04-2008 / 11:02:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

branchesAndTags

    ^branches value
!

manager
    ^ manager

    "Created: / 03-10-2008 / 15:41:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

manager:aRepositoryManager
    manager := aRepositoryManager.

    "Created: / 03-10-2008 / 15:41:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

package
    ^ package

    "Created: / 15-03-2008 / 20:22:51 / janfrog"
!

package:something
    package := something.

    "Created: / 15-03-2008 / 20:22:51 / janfrog"
!

packageClasses

    ^self workingCopy packageClasses

    "Created: / 19-04-2008 / 19:07:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

packageExtensions

    ^self workingCopy packageExtensions

    "Created: / 19-04-2008 / 19:07:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

preferredBranch
    ^ preferredBranch
!

preferredBranch:aString

    preferredBranch := aString.
    "branch string MUST end with a slash"
    (preferredBranch notNil and:[preferredBranch last ~~ $/]) ifTrue:[
        preferredBranch := preferredBranch , '/'
    ].

    "Modified: / 29-03-2012 / 17:24:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

trunk

    ^self branchesAndTags detect:[:b|b isTrunk] ifNone:[nil]

    "Created: / 22-11-2009 / 17:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

url
    ^ url

    "Created: / 15-03-2008 / 20:21:30 / janfrog"
    "Modified: / 14-03-2011 / 10:31:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

url:aString
    url := aString.

    "Created: / 15-03-2008 / 20:21:30 / janfrog"
!

workingCopy

    workingCopy ifNil:
        [workingCopy := manager workingCopyForPackage: package.
        workingCopy repository: self].
    ^workingCopy.

    "Created: / 15-03-2008 / 20:30:13 / janfrog"
    "Modified: / 10-04-2010 / 12:41:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy:aWorkingCopy 

    workingCopy := aWorkingCopy.
    workingCopy repository:self.

    "Created: / 15-03-2008 / 20:30:13 / janfrog"
    "Modified: / 31-03-2008 / 12:47:43 / janfrog"
    "Modified: / 10-04-2010 / 12:40:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyIn: directory

    (workingCopy notNil and:[workingCopy path = directory])
        ifTrue:
            [^workingCopy]
        ifFalse:
            [^(manager workingCopyForPackage: package in: directory)
                repository: self;
                yourself].

    "Created: / 10-04-2010 / 12:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'accessing - containers'!

containerNameForClass:arg
    ^ self class containerNameForClass:arg
!

containerNameForExtensions: language
    ^ self class containerNameForExtensions: language

    "Created: / 30-12-2009 / 21:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'accessing - tasks'!

commitTask

    ^self workingCopy commitTask

    "Created: / 24-03-2009 / 15:14:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

updateTask

    ^self workingCopy updateTask

    "Created: / 24-03-2009 / 15:14:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Repository methodsFor:'commands'!

cat: file

    ^self cat: file revision: SVN::Revision head

    "Created: / 19-04-2008 / 10:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cat:file revision:revision 
    ^ self workingCopy isValid 
        ifTrue:[ self workingCopy cat:file revision:revision ]
        ifFalse:[ self branch cat:file revision:revision ]

    "Created: / 19-04-2008 / 10:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 10:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-01-2010 / 13:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'comparing'!

= anotherRepo

    ^self class = anotherRepo class
        and:[self url = anotherRepo url
            and:[self package = anotherRepo package]]

    "Created: / 31-03-2008 / 14:39:29 / janfrog"
!

hash

    ^url hash bitXor: package hash

    "Created: / 31-03-2008 / 14:39:57 / janfrog"
! !

!Repository methodsFor:'converting'!

configuration
    |c|

    c := Configuration newRepository.
    c
        package:package;
        url:url.
    self workingCopy branchOrNil 
        ifNotNil:[ c branch:self workingCopy branchOrNil path ].
    ^ c

    "Created: / 24-03-2010 / 22:35:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'error reporting'!

svnError: aMessage

    self error: aMessage

    "Created: / 19-03-2008 / 10:00:55 / janfrog"
! !

!Repository methodsFor:'initialization'!

initialize

    branches := CacheEntry receiver: self selector: #basicBranchesAndTags.
    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 10-04-2010 / 12:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream
        nextPut:$(;
        nextPutAll: url;
        nextPut:$).

    "Modified: / 14-04-2011 / 17:43:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'private'!

basicBranchesAndTags
    | burl topLevelDirs  branches |

    burl := self urlForBranches.
    branches := OrderedCollection new.
    topLevelDirs := ListCommand list: burl.
     "Try trunk branch"
    (topLevelDirs anySatisfy: [:entry | entry path = 'trunk' ]) 
        ifTrue: 
            [ branches add: ((Branch new)
                        repository: self;
                        path: '/trunk/') ]
        ifFalse: 
            [ branches add: ((Branch new)
                        repository: self;
                        path: '').
            ^ branches ].
     "Try  branches"
    (topLevelDirs anySatisfy: [:entry | entry path = 'branches' ]) 
        ifTrue: 
            [ (ListCommand list: burl , '/branches/') do: 
                    [:branchEntry | 
                    branches add: ((Branch new)
                                repository: self;
                                path: '/branches/' , branchEntry path) ] ].
     "Try tags"
    (topLevelDirs anySatisfy: [:entry | entry path = 'tags' ]) 
        ifTrue: 
            [ (ListCommand list: burl , '/tags/') do: 
                    [:branchEntry | 
                    branches add: ((Branch new)
                                repository: self;
                                path: '/tags/' , branchEntry path) ] ].
    ^ branches.

    "Created: / 14-04-2008 / 11:01:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:27:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 10:37:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlForBranch: path

    ^url expandPlaceholdersWith: 
        (Dictionary new     
            at: 'BRANCH' put: path;
            yourself)

    "Created: / 14-03-2011 / 09:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlForBranches

    ^self class urlForBranches: url

    "Created: / 14-03-2011 / 09:56:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-03-2011 / 18:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository methodsFor:'queries'!

exists

    ^[
        ListCommand new
            branch: self;
            url: self urlForBranches;
            execute.
        true
    ] on: SVN::SVNError do:[ false ]

    "Created: / 16-03-2008 / 12:12:17 / janfrog"
    "Modified: / 19-08-2009 / 13:08:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-03-2011 / 10:33:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Repository class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

