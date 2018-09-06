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

"
BinaryStorage error & error handling demonstration
--------------------------------------------------

These code fragments demonstrate the kind of errors that may occur
when retrieving binary stored objects, and how they can be handled.

select code-fragments up-to (but exclusive) the exclamation marks 
and evaluate them using doIt ...

-> Especially have a look at examples 7..., which show how to handle erros
-> and repair things ... you may need this when retrieving objects for
-> changed classes ...




example1 (good case): store an object of some class,
	  retrieve the object
	  NO errors should occur
"

"
  creating the class:
"
    Class updateChanges:false.    "/ dont want those DemoClass things in the changeFile
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category:'examples-BinaryStorage'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

example2: store an object of some class,
	  remove the class
	  retrieve the object

 -> an error for the nonexisting class will be reported
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  remove the class:
"

    Class updateChanges:false.
    Smalltalk removeClass:DemoClass.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

example3: store an object of some class,
	  remove class, but keep some global with that name
	  retrieve the object

 -> an error for the nonexisting class will be reported
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  remove the class:
"

    Smalltalk at:#DemoClass put:#foo.
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

example4: store an object of some class,
	  change classes definition (add an instvar)
	  retrieve the object

 -> an error for the changed (i.e. incompatible) class will be reported
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2 instVar3' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

example5: store an object of some class,
	  change classes definition (make it byte indexed)
	  retrieve the object

 an error for the changed (i.e. incompatible) class will be reported
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class:
"

    Class updateChanges:false.
    Object variableByteSubclass:#DemoClass
	instanceVariableNames: 'instVar1 instVar2' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

example6: store an object of some class,
	  change classes definition (rename instvars)
	  retrieve the object

 an error for the changed (i.e. incompatible) class will be reported
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'bar foo' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|

    bos := 'data.boss' asFilename readStream binary.

    (Object readBinaryFrom:bos) inspect.
    bos close
!

"---------------------------------------------------------------------"

Now for the more interesting (and tricky) cases:


example7: store an object of some class,
	  change classes definition (rename instvars)
	  retrieve the object, specifying an error handler
	  abort the binary load

  a message will be output to the Transcript and the binary load
  aborted.
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'bar foo' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager invalidClassSignal handle:[:ex |
	|oldClass|

	oldClass := ex parameter.
	Transcript showCR:'cannot restore instance of ' , oldClass name.
	Transcript showCR:' -->' , ex signal notifierString.
	ex return   "abort the binary load"
    ] do:[
	(Object readBinaryFrom:bos) inspect.
    ].
    bos close
!

"---------------------------------------------------------------------"

example8: store an object of some class,
	  change classes definition (rename instvars)
	  retrieve the object, specifying an error handler
	  return an obsolete object

  no error will be reported, instead an obsolete object will be returned
  (at least gives you a chance to get at the objects old contents)

  However, in the example below, an error will occur later, when the inspector
  tries to get at the obsolete objects internals (the obsolete object class
  has been written to catch most messages thus preventing use of it)
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class (instvar order is changed):
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'bar foo' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager invalidClassSignal handle:[:ex |
	|oldClass|

	oldClass := ex parameter.
	Transcript showCR:'cannot restore instance of ' , oldClass name.
	Transcript showCR:' -->' , ex signal notifierString.
	ex proceed  "continue loading"
    ] do:[
	(Object readBinaryFrom:bos) inspect.
    ].
    bos close
!

"---------------------------------------------------------------------"

example9: store an object of some class,
	  change classes definition (rename instvars)
	  retrieve the object, specifying an error handler
	  return a replacement from the load

  a message will be output to the Transcript and nil returned as loaded object
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:1.
    o instVarAt:2 put:2.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'bar foo' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager requestConversionSignal handle:[:ex |
	ex proceedWith:nil "return nil instead"
    ] do:[                 
	BinaryIOManager invalidClassSignal handle:[:ex |
	    |oldClass|

	    oldClass := ex parameter.
	    Transcript showCR:'cannot restore instance of ' , oldClass name.
	    Transcript showCR:' -->' , ex signal notifierString.
	    Transcript showCR:'return it as Point'.
	    ex proceedWith:Point     "continue; return it as a Point"
	] do:[
	    (Object readBinaryFrom:bos) inspect.
	]
    ].
    bos close
!

"---------------------------------------------------------------------"

example10: store an object of some class,
	  change classes definition (rename instvars)
	  the new class knows how to convert old-style objects
	  retrieve the object, specifying an error handler 
	  and a conversion handler.

  no error will be reported, instead a converted object will be returned
  (this is the recommended way of doing things, if your objects are stored
   in some dataBase and are to be valid after class changes)
"
"
  creating the class:
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class (instvar order is changed):
"

    Class updateChanges:false.
    Object subclass:#DemoClass
	instanceVariableNames: 'bar foo' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager requestConversionSignal handle:[:ex |
	|oldObject newClass|

	newClass := ex parameter key.
	oldObject := ex parameter value.
	"
	 convert using the default cloner (which tries to
	 match instance variables ...)
	 Your new class may redefine cloneFrom: for specific
	 conversion
	"
	ex proceedWith:(newClass cloneFrom:oldObject)
    ] do:[
	BinaryIOManager invalidClassSignal handle:[:ex |
	    |oldClass|

	    oldClass := ex parameter.
	    Transcript showCR:'will convert instance of ' , oldClass name.
	    ex proceed
	] do:[
	    (Object readBinaryFrom:bos) inspect.
	]
    ].
    bos close
!

"---------------------------------------------------------------------"

example11: store an object of some class,
	  change classes definition (add an instvar)
	  the new class knows how to convert old-style objects
	  retrieve the object, specifying an error handler
	  and a converter

  no error will be reported, instead a converted object will be returned.
  Since the original object did not include the added instance variable,
  it is set to some default value.
  (this is the recommended way of doing things, if your objects are stored
   in some dataBase and are to be valid after class changes)
"
"
  creating the class:
"

    Class updateChanges:false.
    Object variableSubclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |o bos|

    o := DemoClass new:2.
    o instVarAt:1 put:'hello'.
    o instVarAt:2 put:'world'.
    o basicAt:1 put:'one'.
    o basicAt:2 put:'two'.


    bos := 'data.boss' asFilename writeStream binary.

    o storeBinaryOn:bos.
    bos close
!

"
  change the class (instvar order is changed):
"

    Class updateChanges:false.
    Object variableSubclass:#DemoClass
	instanceVariableNames: 'foo bar baz' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager requestConversionSignal handle:[:ex |
	|oldObject newClass|

	newClass := ex parameter key.
	oldObject := ex parameter value.
	"
	 convert using the default cloner (which tries to
	 match instance variables ...)
	 Your new class may redefine cloneFrom: for specific
	 conversion
	"
	ex proceedWith:(newClass cloneFrom:oldObject)
    ] do:[
	BinaryIOManager invalidClassSignal handle:[:ex |
	    ex proceed
	] do:[
	    (Object readBinaryFrom:bos) inspect.
	]
    ].
    bos close
!

"---------------------------------------------------------------------"

example12: like example11, but with multiple objects
	   store many objects of some class,
	   change classes definition (add an instvar)
	   the new class knows how to convert old-style objects
	   retrieve the objects, specifying an error handler
	   and a converter

  no error will be reported, instead a converted object will be returned.
  Since the original object did not include the added instance variable,
  it is set to some default value.
  (this is the recommended way of doing things, if your objects are stored
   in some dataBase and are to be valid after class changes)

  This example shows that the invalidClass signal is only raised once,
  while conversion is requested for each object.
"
"
  creating the class:
"

    Class updateChanges:false.
    Object variableSubclass:#DemoClass
	instanceVariableNames: 'foo bar' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  storing:
"
    |a bos|

    a := (1 to:5) collect:[:i |
	    |o|

	    o := DemoClass new:2.
	    o instVarAt:1 put:'hello'.
	    o instVarAt:2 put:'world'.
	    o basicAt:1 put:i.
	    o basicAt:2 put:'two'.
	    o
	].

    bos := 'data.boss' asFilename writeStream binary.

    a storeBinaryOn:bos.
    bos close
!

"
  change the class (instvar order is changed):
"

    Class updateChanges:false.
    Object variableSubclass:#DemoClass
	instanceVariableNames: 'foo bar baz' 
	classVariableNames: ''    
	poolDictionaries: ''
	category: 'examples'.
    Class updateChanges:true.
!

"
  retrieving:
"
    |bos|


    bos := 'data.boss' asFilename readStream binary.

    BinaryIOManager requestConversionSignal handle:[:ex |
	|oldObject newClass|

	newClass := ex parameter key.
	oldObject := ex parameter value.
	"
	 convert using the default cloner (which tries to
	 match instance variables ...)
	 Your new class may redefine cloneFrom: for specific
	 conversion
	"
	Transcript showCR:'converting  ...'.
	ex proceedWith:(newClass cloneFrom:oldObject)
    ] do:[
	BinaryIOManager invalidClassSignal handle:[:ex |
	    Transcript showCR:'invalid class encountered ...'.
	    ex proceed
	] do:[
	    (Object readBinaryFrom:bos) inspect.
	]
    ].
    bos close
!
