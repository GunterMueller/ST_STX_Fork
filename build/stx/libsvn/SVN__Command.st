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

Object subclass:#Command
	instanceVariableNames:'transcript'
	classVariableNames:'SVNPath'
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!Command class methodsFor:'documentation'!

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

!Command class methodsFor:'instance creation'!

for: aSVNRepository

    ^self new

    "Created: / 15-03-2008 / 21:18:34 / janfrog"
    "Modified: / 15-03-2008 / 23:32:10 / janfrog"
!

new
    ^ self basicNew initialize.

    "Created: / 16-03-2008 / 07:45:22 / janfrog"
! !

!Command class methodsFor:'accessing'!

verbose

    ^UserPreferences current svnVerbose

    "Created: / 19-03-2008 / 12:29:47 / janfrog"
    "Modified: / 19-03-2009 / 14:00:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

verbose: aBoolean

    UserPreferences current svnVerbose: aBoolean

    "Created: / 19-03-2008 / 12:29:59 / janfrog"
    "Modified: / 19-03-2009 / 14:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Command class methodsFor:'executing - private'!

executable
    "Return (autodetected) svn executable to be used.
     May be overridden in preferences, see
      - UserPreferences>>svnCommand 
      - SVN::Command>>svnProgram
    "

    |h|

    OperatingSystem isMSDOSlike ifTrue:[
        SVNPath isNil ifTrue:[
            h := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\App Paths\svn.exe'.
            h notNil ifTrue:[
                SVNPath := h valueNamed:''.
            ].
        ].
        (SVNPath notEmptyOrNil and:[SVNPath asFilename exists]) ifTrue:[
            "/ path can include spaces (sigh)
            ^ '"',SVNPath,'"'
        ].
    ].
    ^ 'svn'

    "
     SVNPath := nil.
     self basicNew svnProgram   
    "

    "Modified: / 12-04-2010 / 16:14:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-08-2011 / 13:34:05 / cg"
    "Created: / 04-02-2012 / 19:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Command class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Command methodsFor:'accessing'!

transcript
    ^ transcript ? Transcript

    "Created: / 31-03-2008 / 15:37:39 / janfrog"
!

transcript:something
    transcript := something.

    "Created: / 31-03-2008 / 15:37:39 / janfrog"
! !

!Command methodsFor:'debugging support'!

printInfo:svnProcess 
    |ctx|

    ctx := thisContext.
    3 timesRepeat:[
        ctx := ctx sender
    ].
    (self transcript)
        cr;
        show:'[SVN] ';
        showCR:svnProcess asShellCommandString;
        show:'      in ';
        showCR:self svnCmdWorkdir;
        show:'[SVN] #called from ';
        showCR:ctx printString;
        showCR:'[SVN] #called from ...'.

    [ (ctx receiver class nameSpace = SVN)]
        whileTrue:[ctx := ctx sender].
    (self transcript)        
        show:'[SVN] #called from ';
        showCR:ctx printString;
        show:'[SVN] #called from ';
        showCR:ctx sender printString
! !

!Command methodsFor:'executing'!

execute


    ^self svnExecute

    "Modified: / 03-10-2008 / 17:25:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnStderrStream
    ^ (String new:64) writeStream

    "Created: / 16-03-2008 / 07:50:38 / janfrog"
!

svnStdoutStream
    ^ (String new:64) writeStream

    "Created: / 16-03-2008 / 07:50:17 / janfrog"
! !

!Command methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 15-03-2008 / 21:03:26 / janfrog"
!

svnCmdArgumentsOn:argStream 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 15-03-2008 / 21:21:11 / janfrog"
!

svnCmdWorkdir
    "raise an error: must be redefined in concrete subclass(es)"

    ^ '.'

    "Created: / 15-03-2008 / 23:41:48 / janfrog"
!

svnExecute
    |svnStdoutStream svnStderrStream svnProcess|

    svnStdoutStream := self svnStdoutStream.
    svnStderrStream := self svnStderrStream.
    svnProcess := (self svnExternalProcess)
                stdout:svnStdoutStream;
                stderr:svnStderrStream.
    self class verbose ifTrue:[
        self printInfo:svnProcess
    ].
    svnProcess
        execute;
        waitFor.
    self class verbose ifTrue:[
        svnStdoutStream contents isEmpty not ifTrue:[
            svnStdoutStream contents asStringCollection do:[:line | 
                "self transcript show:'[SVN] '; show: line; cr"
            ]
        ].
        svnStderrStream contents isEmpty not ifTrue:[
            svnStderrStream contents asStringCollection do:[:line | 
                (self transcript)
                    show:(('[SVN] ' , line) asText colorizeAllWith:Color red);
                    cr
            ]
        ].
    ].
    ^ svnProcess exitValue isZero 
        ifTrue:[
            self svnProcessCommandOutput:svnStdoutStream contents readStream
                err:svnStderrStream contents readStream
        ]
        ifFalse:[ self svnProcessCommandError:svnStderrStream contents ]

    "Modified: / 31-03-2008 / 15:39:40 / janfrog"
    "Created: / 03-10-2008 / 17:25:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-04-2009 / 22:18:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnExternalProcess
    |argStream|

    argStream := OrderedCollection new writeStream.
    self svnGlobalArgumentsOn:argStream.
    argStream nextPut:self svnCmd.
    self svnCmdArgumentsOn:argStream.
    ^ (OSProcess new)
        executable:self svnProgram;
        arguments:argStream contents;
        workdir:self svnCmdWorkdir;
        yourself

    "Modified: / 15-03-2008 / 23:41:26 / janfrog"
    "Created: / 03-10-2008 / 16:32:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnGlobalArgumentsOn: argStream

    argStream 
        nextPut:'--non-interactive'.

    "Created: / 03-10-2008 / 17:28:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProcessCommandError: errorString

    ^(SVN::SVNError raiseErrorString: errorString)

    "Created: / 03-10-2008 / 16:33:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2008 / 17:48:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-08-2010 / 18:19:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnProcessCommandOutput:svnStdoutStream err:svnStderrStream 
    self subclassResponsibility

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnProgram
    "Answer a 'svn' command to be used"

    | p |

    p := UserPreferences current svnCommand.
    p isNil ifTrue:[
        p := self class executable
    ].
    ^p

    "Modified: / 12-03-2012 / 11:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Command methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 16-03-2008 / 07:45:22 / janfrog"
! !

!Command class methodsFor:'documentation'!

version
    ^ '$Header$'

!

version_SVN
    ^ '§Id: SVN__Command.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
