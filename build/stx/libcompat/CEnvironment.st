"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#CEnvironment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!CEnvironment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    In ST/X, all OS command facilities are found in
    the OperatingSystem class; have a look at the getEnvironment protocol
    there.

    [author:]
        Claus Gittinger

    [see also:]
        OperatingSystem

    This is an additional goody class; therefore:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
"
! !

!CEnvironment class methodsFor:'queries'!

argv
    "return the st/x commandLine arguments as an array.
     Added for VW compatibility"

    Smalltalk isStandAloneApp ifFalse:[
        ^ (Dialog request:'Argv') asCollectionOfWords
    ].

    ^ Smalltalk commandLineArguments

    "
     CEnvironment argv
    "

    "Modified: 31.7.1997 / 18:22:34 / cg"
!

commandLine
    "return the st/x commands commandLine arguments as an array.
     Added for VW compatibility"

    ^ Smalltalk commandLine

    "
     CEnvironment commandLine
    "

    "Modified: 31.7.1997 / 18:22:34 / cg"
!

getenv:variableNameString
    "return a shell environment variables value as a string;
     ST-80 returns an empty string, if there is no such variable (sigh)"

    |val|

    val := OperatingSystem getEnvironment:variableNameString.
    val isNil ifTrue:[^ ''].
    ^ val

    "
     CEnvironment getenv:'HOME' 
    "

    "Modified: 27.1.1997 / 11:32:32 / cg"
!

install
    "ST-compatible protocol: dummy here"

    "/ whatduzitdoo ?

    "Created: 27.1.1997 / 11:31:29 / cg"
! !

!CEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/CEnvironment.st,v 1.9 2015-03-27 13:23:58 cg Exp $'
! !

