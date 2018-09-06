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

to send objects using Sockets, use:

on host1:    (server providing a service, sending objects)


    |sock conn a|

    'providing socket service ...' printNewline.
    sock := Socket provide:9995.
    sock notNil ifTrue:[
	  'waiting for a client ...' printNewline.
	  conn := sock accept.
	  sock close.
    ].
    conn isNil ifTrue:[
	'socket setup failed' printNewline
    ] ifFalse:[
	'connected; send objects...' printNewline.
	conn buffered:false; binary.
	#(1 2 'three' #four (5 6 7))         storeBinaryOn:conn.
	#( $a $b $c )                        storeBinaryOn:conn.
	a := Array new:3.
	a at:1 put:a.
	a at:2 put:(Array with:a).
	a                                    storeBinaryOn:conn.
	conn close.
	'done.' printNewline.
    ]

    |sock conn a|

    'providing socket service ...' printNewline.
    sock := Socket provide:9995.
    sock notNil ifTrue:[
	  'waiting for a client ...' printNewline.
	  conn := sock accept.
	  sock close.
    ].
    conn isNil ifTrue:[
	'socket setup failed' printNewline
    ] ifFalse:[
	'connected; send objects...' printNewline.
	conn buffered:false; binary.

	#(1 2 'three' #four (5 6 7))         storeBinaryOn:conn.
	#( $a $b $c )                        storeBinaryOn:conn.
	a := Array new:3.
	a at:1 put:a.
	a at:2 put:(Array with:a).
	a                                    storeBinaryOn:conn.
	conn close.
	'done.' printNewline.
    ]

reusing the manager:

    |sock conn a manager|
    'providing socket service ...' printNewline.
    sock := Socket provide:9995.
    sock notNil ifTrue:[
	  'waiting for a client ...' printNewline.
	  conn := sock accept.
	  sock close.
    ].
    conn isNil ifTrue:[
	'socket setup failed' printNewline
    ] ifFalse:[
	'connected; send objects...' printNewline.
	conn buffered:false; binary.
	manager := BinaryOutputManager new.

	(Time millisecondsToRun:[
	     1 to:1000 do:[:i |
		 (i -> i printString )       storeBinaryOn:conn manager:manager.
	     ]
	]) printNL.

	conn close.
	manager release.

	'done.' printNewline.
    ]

on host2:    (client, connecting and receiving objects)

    |conn|

    'connecting to server ...' printNewline.
    conn := Socket connectTo:9995 on:'porty' "'hp'"  "'host1'".
    conn isNil ifTrue:[
	'connect failed' printNewline
    ] ifFalse:[
	'connected' printNewline.
	conn buffered:false; binary.

	"optional:  conn readWait. "
	(BinaryInputManager readFrom:conn) inspect.
	(BinaryInputManager readFrom:conn) inspect.
	(BinaryInputManager readFrom:conn) inspect.
	conn close
    ]


alternative (read all that comes) (DOES NOT WORK -why ?):

    |conn o|

    'connecting to server ...' printNewline.
    conn := Socket connectTo:9995 on:'hp' "'host1'".
    conn isNil ifTrue:[
	'connect failed' printNewline
    ] ifFalse:[
	'connected' printNewline.
	conn buffered:false; binary.

	[conn atEnd] whileFalse:[
	    conn readWait.
	    'something arrived ...' printNewline.
	    o := Object readBinaryFrom:conn.
	    'received ' , o classNameWithArticle , '.' printNewline.
	].
	conn close
    ]

read 1000 elements:

    |conn o manager|

    'connecting to server ...' printNewline.
    conn := Socket connectTo:9995 on:'frss92' "'host1'".
    conn isNil ifTrue:[
	'connect failed' printNewline
    ] ifFalse:[
	'connected' printNewline.
	conn buffered:false; binary.
	manager := BinaryInputManager on:conn.

	1000 timesRepeat:[
	    o := manager nextObject.
	].
	conn close
    ]
