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

Command subclass:#BranchCommand
	instanceVariableNames:'branch username password noAuthCache alreadyCleaned revision'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!BranchCommand class methodsFor:'documentation'!

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

!BranchCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!BranchCommand methodsFor:'accessing'!

branch: aBranch

    branch := aBranch.

    "Created: / 19-08-2009 / 09:55:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revision
    ^ revision ? SVN::Revision head

    "Created: / 16-03-2008 / 10:00:05 / janfrog"
!

revision:aRevision
    revision := aRevision.

    "Created: / 16-03-2008 / 10:00:05 / janfrog"
!

url
    ^ branch url

    "Created: / 03-10-2008 / 16:27:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 09:55:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchCommand methodsFor:'executing'!

execute
    ^ [ super execute ] on:SVN::AuthorizationError
	do:[:ex |
    |credentials dialog|

    credentials := Credentials new username:OperatingSystem getLoginName.
    credentials := (dialog := CredentialsDialog new)
		model:credentials;
		subTitle:self url;
		open.
    credentials
	ifNil:[ ex pass ]
	ifNotNil:[
	    username := credentials username.
	    password := credentials password.
	    noAuthCache := dialog savePassword not.
	    self execute
	]
]

    "Created: / 03-10-2008 / 17:26:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-11-2008 / 08:31:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchCommand methodsFor:'executing - private'!

svnGlobalArgumentsOn: argStream

    super svnGlobalArgumentsOn: argStream.

    "/argStream nextPut:'--config-dir'; nextPut:'/tmp/.svn'; nextPut:'--no-auth-cache'.

    username ifNotNil:
	[argStream
	    nextPut: '--username';
	    nextPut: username].
    password ifNotNil:
	[argStream
	    nextPut: '--password';
	    nextPut: password].
    noAuthCache == true ifTrue:
	[argStream
	    nextPutAll:'--no-auth-cache']

    "Created: / 03-10-2008 / 17:31:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchCommand methodsFor:'initialization'!

initialize

    super initialize.
    alreadyCleaned := false

    "Created: / 08-11-2008 / 08:40:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!BranchCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__BranchCommand.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
