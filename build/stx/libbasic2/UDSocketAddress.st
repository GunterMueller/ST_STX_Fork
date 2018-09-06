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
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

SocketAddress variableByteSubclass:#UDSocketAddress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!UDSocketAddress class methodsFor:'documentation'!

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
    Instances of UDSocketAddress represent unix-domain socket names.

    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

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

!UDSocketAddress class methodsFor:'instance creation'!

allForHostName:hostName serviceName:portNrOrName type:socketTypeSymbol
    (hostName notNil and:[hostName ~= 'localhost']) ifTrue:[
        self error:'Only local connections possible with UD sockets'.
        ^ nil.
    ].

    ^ Array with:(self name:portNrOrName).
!

anyHost
    "there is nothing like a 'host' for unix domain sockets.
     answer an empty address"

    ^ self new
!

name: pathName
    ^ self new name:pathName

    "
     UDSocketAddress name:'/tmp/aUnixDomainSocket' 
    "
!

peerName:peerName port:port
    "use #name:"

    <resource: #obsolete>
    self obsoleteMethodWarning:'use name:'.
    ^ self name:peerName
! !

!UDSocketAddress class methodsFor:'queries'!

domain
    ^ #'AF_UNIX'
!

obsoleteDomainSymbol
    ^ #unix
!

peerNameFromPeer:peer
    ^ 'localhost'
!

vwDomainSymbol
    ^ #afUnix
! !

!UDSocketAddress methodsFor:'accessing'!

hostAddress
    "unix domain sockets are local and do not have a host address"

    ^ nil
!

name
    ^ self stringAt:3
!

name:pathName
    self stringAt:3 put:pathName asFilename osNameForFile.
!

port
    "compatibility with inet sockets"

    ^ self name
!

port:pathName
    "compatibility with inet sockets"

    self name:pathName
!

portOrName
    ^ self name
! !

!UDSocketAddress methodsFor:'comparing'!

sameHostAddress:aSocketAddress
    "answer true, if myself and aSocketAddress have the same host address
     (but possibly different ports).
     UnixDomainSockets are always on the same host."

    ^ aSocketAddress class == self class
! !

!UDSocketAddress methodsFor:'obsolete'!

address
    <resource: #obsolete>
    ^ nil
!

hostName
    <resource: #obsolete>
    ^ 'local'
!

hostName:hostOrPathName port:portNrOrName
    <resource: #obsolete>
    self name:hostOrPathName
! !

!UDSocketAddress methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self class name; 
            nextPut:$(; nextPutAll:self name; nextPut:$)

    "
     (self name:'/tmp/abcde') printString
    "
! !

!UDSocketAddress methodsFor:'testing'!

isLocal
    "answer true, if this address addresses a peer on the same host"

    ^ true
! !

!UDSocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

