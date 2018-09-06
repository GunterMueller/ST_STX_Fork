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

BinaryStorage examples
----------------------

These code fragments show how various objects are stored and retrieved
from a binary file.
Please, (carefully) read the documentation on binaryStorage, for a
detailed description, including examples and tuning tips.

simple objects:

  storing:

    |s|

    s := 'data.boss' asFilename writeStream binary.

    #aSymbol storeBinaryOn:s.
    'aString' storeBinaryOn:s.
    #(1 2 'three' #four (5 6 7)) storeBinaryOn:s.
    #( $a $b $c ) storeBinaryOn:s.
    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:s) inspect.
    (Object readBinaryFrom:s) inspect.
    (Object readBinaryFrom:s) inspect.
    (Object readBinaryFrom:s) inspect.
    s close


another simple object:

  storing:

    |s c|

    s := 'data.boss' asFilename writeStream binary.

    c := OrderedCollection new.
    c add:1.
    c add:(ByteArray withAll:(1 to:10)).
"/    c add:(WordArray withAll:(1 to:10)).
    c add:(FloatArray withAll:(1 to:2 by:0.1)).
    c storeBinaryOn:s.
    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:s) inspect.
    s close

----------------------------------------------------------------------------
big objects:
   the data stored is:
	   1 array with 10000 slots                  
	5000   points   
       10000     numbers in these points
	5000   assocs
	5000     numbers as key in these assocs
	5000     strings as values in these assocs

     ~ 30k Objects (about 300k object space)

  storing:

    |s a |

    s := 'data.boss' asFilename writeStream binary.

    'create time: ' print.
    (Time millisecondsToRun:[
	a := Array new:10000.
	1 to:5000 do:[:index |
	    a at:index put:(index @ index).
	].
	5000 to:10000 do:[:index |
	    a at:index put:(index -> index printString).
	].
    ]) printNL.

    'store time: ' print.
    (Time millisecondsToRun:[
	a storeBinaryOn:s.
    ]) printNL.

    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    'load time: ' print.
    (Time millisecondsToRun:[
       (Object readBinaryFrom:s) inspect.
    ]) printNL.
    s close

--- for myself only (still tuning a bit :-)
    |s a |

    s := 'data.boss' asFilename writeStream binary.

    a := Array new:10000.
    1 to:5000 do:[:index |
	a at:index put:(index @ index).
    ].
    5000 to:10000 do:[:index |
	a at:index put:(index -> index printString).
    ].

    MessageTally spyOn:[
	a storeBinaryOn:s.
    ].

    s close
----

----------------------------------------------------------------------------
complex objects:

  storing:

    |s a|

    s := 'data.boss' asFilename writeStream binary.

    a := Array new:5.
    a at:1 put:#(1 2 3 4 5).
    a at:2 put:#(1.0 2.0 3.0 4.0 5.0).
    a at:3 put:(Array with:1/2 with:1/3 with:1/4 with:1/5).
    a at:4 put:a.                      "direct self reference"
    a at:5 put:('foo' -> a).           "indirect self reference"
    a storeBinaryOn:s.

    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:s) inspect.

    s close


----------------------------------------------------------------------------
complex objects:

  storing:

    |s|

    s := 'data.boss' asFilename writeStream binary.

    (Image fromFile:'bitmaps/claus.gif') storeBinaryOn:s.

    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:s) inspect.

    s close


----------------------------------------------------------------------------
classes  (will store name only):

  storing:

    |s|

    s := 'data.boss' asFilename writeStream binary.

    Array storeBinaryOn:s.
    Image storeBinaryOn:s.

    s close

  retrieving:

    |s|

    s := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:s) inspect.
    (Object readBinaryFrom:s) inspect.

    s close


----------------------------------------------------------------------------
methods:
if the stored method consists of machine-code (i.e. a built-in method),
only class/selector are stored and the method is looked-up when the
object is read back.

  storing:

    |s|

    s := 'data.boss' asFilename writeStream binary.
    Class updateChanges:false.
    Compiler compile:'
	foo 
	  ^ Transcript showCR:''the foo method''
	'
	forClass:True.

    True storeBinaryOn:s.
    #foo storeBinaryOn:s.
    (True compiledMethodAt:#foo) storeBinaryOn:s.
    (True compiledMethodAt:#xor:) storeBinaryOn:s.
    s close.
    True removeSelector:#foo.
    Class updateChanges:true.

  retrieving:

    "you will get an interpreter warning, when evaluating this 
     (because at the time the interpreter reads this, 
      #foo is not yet implemented)
     - ignore it and just press continue"

    |s class selector method|

    s := 'data.boss' asFilename readStream binary.
    class := (Object readBinaryFrom:s).
    selector := (Object readBinaryFrom:s).
    method := (Object readBinaryFrom:s).
    class addSelector:selector withMethod:method. 
    true foo.
    True removeSelector:#foo.
    method := (Object readBinaryFrom:s).
    method inspect.
    s close.


----------------------------------------------------------------------------
methods as functions (i.e. methods which are not linked to any class)

  storing:

    |s method|

    s := 'data.boss' asFilename writeStream binary.

    Class updateChanges:false.
    method := Compiler compile:'
		  foo 
		      ^ Transcript showCR:''the foo method''
		  '
		forClass:UndefinedObject
		inCategory:'demos' 
		notifying:nil 
		install:false.

    method storeBinaryOn:s.
    s close.
    Class updateChanges:true.

  retrieving:

    |s method|

    s := 'data.boss' asFilename readStream binary.
    method := (Object readBinaryFrom:s).
    s close.
    method valueWithReceiver:nil arguments:#()

----------------------------------------------------------------------------
byte-code compiled blocks

  storing:

    |s block|

    s := 'data.boss' asFilename writeStream binary.

    Class updateChanges:false.
    Compiler compile:'foo
		      ^ [:a :b | 
			 Transcript showCR:''comparing '' , a printString , '' and '', b printString.
			 a >= b
			].'
	     forClass:UndefinedObject.
    block := nil foo.
    UndefinedObject removeSelector:#foo.

    block storeBinaryOn:s.
    s close.
    Class updateChanges:true.

  retrieving:

    |s block|

    s := 'data.boss' asFilename readStream binary.
    block := (Object readBinaryFrom:s).
    s close.
    block value:3 value:5


----------------------------------------------------------------------------
machine-code compiled blocks
    sorry, but the block will be stored as byte-code version only,
    thus, the loaded version will run somewhat slower.


    |s block|

    s := 'data.boss' asFilename writeStream binary.

    "I know of one (standard) compiled block in the system ..."

    block := (SortedCollection new) sortBlock.
    block storeBinaryOn:s.
    s close.

  retrieving:

    |s block|

    s := 'data.boss' asFilename readStream binary.
    block := (Object readBinaryFrom:s).
    s close.
    Transcript showCR:(block value:3 value:5).
    Transcript showCR:(block value:5 value:3).



