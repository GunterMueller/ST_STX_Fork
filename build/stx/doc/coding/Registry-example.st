'From Smalltalk/X, Version:4.1.4 on 4-Mar-2002 at 20:10:22'                     !

"{ NameSpace: CodingExamples }"

Object subclass:#RegistryExample
	instanceVariableNames:'myName'
	classVariableNames:'Lobby Lobby2'
	poolDictionaries:''
	category:'examples-Registry'
!

!RegistryExample class methodsFor:'documentation'!

documentation
"
    Examples on how to use Registry and HandleRegistry for finalization.

    Registries are to be used for object which know themself how to
    perform cleanup, and provide a #finalize method for that.

    'example1' demonstrates this, by creating a registry, and registering
    some instances there. Once these are reclaimed by the garbage collector,
    this #finalize method is called for. (actually the message is sent to the executor,
    which is a shallow copy of the original object).

    HandleRegistries are to be used if someone else does the cleanup,
    and wants to keep track of the death of objects which do not perform
    cleanup themself (or do not the right cleanup).

    'example2' demonstrates the use by registering some instances and
    arbitrary other objects) in a handleRegistry and tells us about it in the
    #update:with:from: method.:
"
! !

!RegistryExample class methodsFor:'examples'!

example1
    "this creates objects, which, when destroyed print a message
     on the Transcript.
     (actually a phantom-copy is doing this, but who cares)"

    |o1 o2 o3 o4 o5|

    Transcript cr.
    Transcript showCR:'creating 5 objects (o1 .. o5)'.

    o1 := (self new name:'object1').
    o2 := (self new name:'object2').
    o3 := (self new name:'object3').
    o4 := (self new name:'object4').
    o5 := (self new name:'object5').

    Transcript showCR:'creating a registry ...'.

    Lobby isNil ifTrue:[
	Lobby := Registry new.
    ].

    Transcript showCR:'register o1 ...'.
    Lobby register:o1.
    Transcript showCR:'register o2 ...'.
    Lobby register:o2.
    Transcript showCR:'register o3 ...'.
    Lobby register:o3.
    Transcript showCR:'register o4 ...'.
    Lobby register:o4.
    Transcript showCR:'register o5 ...'.
    Lobby register:o5.

    "they are still living ..."

    Transcript showCR:'doing a GC, but all are still referenced; so nothing happens now ...'.
    ObjectMemory scavenge.

    "now, one of them should scream ..."

    Transcript showCR:'releasing ref to o3'.
    o3 := nil.
    Transcript showCR:'doing a GC; now o3 should scream ...'.
    ObjectMemory scavenge.

    "now, another one should scream ..."

    Transcript showCR:'releasing ref to o1'.
    o1 := nil.
    Transcript showCR:'doing a GC; now o1 should scream ...'.
    ObjectMemory scavenge.

    "the rest will shout sometime after this ..."

    Transcript showCR:'the others (o2, o4 and o5) will follow soon (when next garbage collect occures).'.

    "RegistryExample example1"
!

example2
    "almost like above, but uses a handleRegistry."

    |o1 o2 o3 o4 o5|

    Transcript cr.
    Transcript showCR:'creating 5 objects (o1 .. o5)'.

    o1 := (self new name:'object1').
    o2 := (self new name:'object2').
    o3 := (self new name:'object3').
    o4 := (self new name:'object4').
    o5 := (self new name:'object5').

    Transcript showCR:'creating a registry ...'.

    Lobby2 isNil ifTrue:[
	Lobby2 := HandleRegistry new.
    ].

    Lobby2 addDependent:self.
    Transcript showCR:'register o1 ...'.
    Lobby2 register:o1 as:'object1'.
    Transcript showCR:'register o2 ...'.
    Lobby2 register:o2 as:2.
    Transcript showCR:'register o3 ...'.
    Lobby2 register:o3 as:3.
    Transcript showCR:'register o4 ...'.
    Lobby2 register:o4 as:4.
    Transcript showCR:'register o5 ...'.
    Lobby2 register:o5 as:5.

    "you can register anything there .... with any handle"
    Transcript showCR:'register other objects ...'.
    Lobby2 register:(Point new) as:6.
    Lobby2 register:('/tmp' asFilename ) as:7.

    "they are still living ..."

    Transcript showCR:'doing a GC, but o1..o5 are still referenced; so only 6 and 7 will die ...'.
    ObjectMemory scavenge.

    "now, I should be informed via a change message"

    Transcript showCR:'releasing ref to o3'.
    o3 := nil.
    Transcript showCR:'doing a GC; now o3 should scream ...'.
    ObjectMemory scavenge.

    "now, again ..."

    Transcript showCR:'releasing ref to o1'.
    o1 := nil.
    Transcript showCR:'doing a GC; now o1 should scream ...'.
    ObjectMemory scavenge.

    "I'll be told about the others sometime after this ..."

    Transcript showCR:'the others (o2, o4 and o5) will follow soon (when next garbage collect occures).'.

    "RegistryExample example2"
!

update:something with:aParameter from:changedObject
    Transcript show:'change notification: '
	       ; show:something printString
	       ; show:' parameter='
	       ; showCR:aParameter printString.
! !

!RegistryExample methodsFor:'instance destruction'!

finalize
    Transcript showCR:'here is ' , myName , '. I was destroyed !!'
! !

!RegistryExample methodsFor:'printing'!

printString
    ^ self class name , '-' , myName
! !

!RegistryExample methodsFor:'setup'!

name:aString
    myName := aString
! !
