"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

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

to communicate using Sockets, use:

TCP connections:

on host1:    (server providing a service)


    |sock conn|

    sock := Socket newTCPserverAtPort:9995.
    sock notNil ifTrue:[
	  sock listenFor:5.
	  conn := sock accept.
	  sock close.
    ].
    ^ conn

on host2:    (client)

    |conn|

    conn := Socket newTCPclientToHost:'host1' port:9995.
    ^ conn


To send data:

    conn nextPutAll:'hello'

to receive data:

    conn next:n

its a good idea to make the Streams unbuffered with: 'conn buffered:false'
to avoid buffering by the stdio library 
(you may wonder where your data goes otherways)


example (transfering a block of bytes):

    "host 1 (server), sending data:"

    |sock conn bytes|

    bytes := ByteArray withAll:(1 to:30).
    'providing socket service ...' printNL.
    sock := Socket newTCPserverAtPort:9999.
    sock notNil ifTrue:[
	  "((optional:  sock readWait))"
	  'waiting for a client ...' printNL.
	  sock listenFor:5.
	  conn := sock accept.
	  sock close.
    ].
    conn isNil ifTrue:[
	'socket setup failed' printNL
    ] ifFalse:[
	'connected with ' print. conn peerName printNL.
	'send data ...' printNL.
	conn binary.
	conn nextPutAll:bytes.
	conn close.
	'done.' printNL.
    ]


"------------------------------------------------------------"
    "host 2 (client), receiving data:"

    |conn buffer count|

    buffer := ByteArray new:100.
    'connecting to server ...' printNL.
    conn := Socket connectTo:9999 on:'idefix' "'host1'".
    conn isNil ifTrue:[
	'connect failed' printNL
    ] ifFalse:[
	'connected; receive data ...' printNL.
	conn binary.
	conn readWait.
	count := conn nextBytes:100 into:buffer.
	'received ' print. count print. ' bytes' printNL.
	buffer printNL.
	conn close.
    ].

Smalltalk at:#MySock put:nil.
MySock := Socket newUDPserverAtPort:8888.

Datagram transfer:

    "host 1, receiving data:"

    |sock adr bytes n|

    sock := MySock. "/  := Socket newUDPserverAtPort:7777.
"/    sock bindTo:0 address:nil.
"/    'error: ' print. sock lastErrorNumber print. ' 'print.
"/    (OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.
"/    sock connectTo:'0.0.0.0' port:6666.
"/    sock bindTo:6666 address:nil.
"/    'error: ' print. sock lastErrorNumber print. ' 'print.
"/    (OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.

    adr := ByteArray new:4.
    bytes := ByteArray new:100.
    n := sock receiveFrom:adr buffer:bytes.
    'received ' print. n print. ' bytes' printNL.
    1 to:1000 do:[:i |
	(Delay forSeconds:1) wait.
'receiving ...' printNL.
	n := sock receiveFrom:nil "adr" buffer:bytes.
	'received ' print. n print. ' bytes' printNL.
	'error: ' print. sock lastErrorNumber print. ' 'print.
	(OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.
    ]

"------------------------------------------------------------"
    "host 2 , sending data:"

    |sock adr bytes n|

    sock := MySock. "/ Socket newUDPserverAtPort:7776.
"/    sock bindTo:0 address:nil.
"/    'error: ' print. sock lastErrorNumber print. ' 'print.
"/    (OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.
"/    sock connectTo:'0.0.0.0' port:6666.
"/    sock bindTo:6666 address:nil.
"/    'error: ' print. sock lastErrorNumber print. ' 'print.
"/    (OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.

    adr := (Socket ipAddressOfHost:'ibm' "'indy'").
    adr := IPSocketAddress hostAddress:adr port:7777.

    bytes := (1 to:99) asByteArray.
    1 to:1000 do:[:i |
	(Delay forSeconds:1) wait.
'sending ...' printNL.
	n := sock sendTo:adr buffer:bytes.
	'sent ' print. n print. ' bytes' printNL.
	'error: ' print. sock lastErrorNumber print. ' 'print.
	(OperatingSystem errorTextForNumber:sock lastErrorNumber) printNL.
    ]
