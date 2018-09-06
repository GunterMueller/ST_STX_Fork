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

WCPathCommand subclass:#CommitCommand
	instanceVariableNames:'message url username password noAuthCache'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!CommitCommand class methodsFor:'documentation'!

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

!CommitCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CommitCommand methodsFor:'accessing'!

message
    ^ message

    "Created: / 19-03-2008 / 15:59:36 / janfrog"
!

message:aString
    message := aString.

    "Created: / 19-03-2008 / 15:59:36 / janfrog"
    "Modified: / 31-03-2008 / 14:20:11 / janfrog"
!

url
    ^ url

    "Created: / 03-10-2008 / 18:19:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

url:something
    url := something.

    "Created: / 03-10-2008 / 18:19:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitCommand methodsFor:'executing'!

execute
    ^ [ super execute ] on:SVN::AuthorizationError
        do:[:ex |
    |credentials dialog|

    credentials := Credentials new username:OperatingSystem getLoginName.
    ((dialog := CredentialsDialog new)
                model:credentials;
                subtitle: workingCopy url;
                open)
        ifFalse:
            [ex pass]
        ifTrue:
            [username := credentials username.
            password := credentials password.
            noAuthCache := dialog savePassword not.
            self execute]]

    "Created: / 03-10-2008 / 18:22:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-07-2009 / 12:09:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-02-2010 / 12:21:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CommitCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'commit'

    "Created: / 16-03-2008 / 07:47:00 / janfrog"
!

svnCmdArgumentsOn:arg

    arg nextPut:'--message'; nextPut: (message ? '').
    super svnCmdArgumentsOn:arg

    "Created: / 19-03-2008 / 15:59:13 / janfrog"
    "Modified: / 31-03-2008 / 14:13:03 / janfrog"
!

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

    "Created: / 31-10-2008 / 09:30:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandOutput:arg1 err:arg2
    "Superclass says that I am responsible to implement this method"

    ^ arg1 contents

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CommitCommand.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
