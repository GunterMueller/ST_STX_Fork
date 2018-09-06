"{ Encoding: utf8 }"

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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ValueModel subclass:#PluggableAdaptor
	instanceVariableNames:'model getBlock putBlock updateBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!PluggableAdaptor class methodsFor:'documentation'!

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
    Allows forwarding of value/value:/change messages via blocks.
    Kind of what ST/X always did ....

    PluggableAdaptor is the most general of the adaptor models -
    any other adapter can be simulated. However, they incur certain
    overhead and complexity.
    Therefore, in many situations, an AspectAdaptor is the better choice.

    Notice:
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class.
        If you encounter any incompatibilities, please forward a note
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Gittinger
"
!

examples
"
    an adaptor for the variable x:
                                                                        [exBegin]
        |m x t|

        m := (PluggableAdaptor new)
                getBlock:[:m | x]
                putBlock:[:m :newValue | x := newValue. Transcript showCR:x]
                updateBlock:[:m :aspect :param | Transcript showCR:'changed'].
        t := Toggle new.
        t model:m.
        t label:'toggle me'.
        t open.
                                                                        [exEnd]


    an adaptor to send #destroy:
                                                                        [exBegin]
        |m t|

        m := (PluggableAdaptor new)
                getBlock:[:m | false]
                putBlock:[:m :newValue | t destroy]
                updateBlock:[:m :aspect :param | ].
        t := Button new.
        t model:m.
        t label:'close me'.
        t open.
                                                                        [exEnd]


    as above, more convenient setup:
                                                                        [exBegin]
        |m t|

        t := Button new.

        m := (PluggableAdaptor on:t) performAction:#destroy.
        t model:m.
        t label:'close me'.
        t open.
                                                                        [exEnd]

    extract values from a complex model:
                                                                        [exBegin]
        |model dialog  name pId|

        model := Plug new.
        model respondTo:#name with:[name].
        model respondTo:#name: with:[:newValue | name := newValue].
        model respondTo:#passportId with:[pId].
        model respondTo:#passportId: with:[:newValue | pId := newValue].
        name := 'John Smith'.
        pId := 56785432.

        dialog := Dialog new.

        dialog addInputFieldOn:((PluggableAdaptor on:model)
                                    getBlock:[:m | m name]
                                    putBlock:[:m :v | m name:v]
                                    updateBlock:[:m :a :p | false]).

        dialog addVerticalSpace.

        dialog addInputFieldOn:((PluggableAdaptor on:model)
                                    getBlock:[:m | m passportId printString]
                                    putBlock:[:m :v | m passportId:v asNumber]
                                    updateBlock:[:m :a :p | false]).
        dialog addAbortButton; addOkButton.
        dialog width:200; sizeFixed:true.
        dialog open.

        dialog accept value ifTrue:[
            Transcript showCR:'accepted.'.
        ].
        Transcript showCR:'  Name: ' , model name.
        Transcript showCR:'  ID  : ' , model passportId printString.
                                                                        [exEnd]



    extract values from an association into different labels:
                                                                        [exBegin]
        |assoc t l|

        assoc := 'hello' -> 'world'.

        t := HorizontalPanelView new.
        t extent:200@50.
        t horizontalLayout:#fitSpace.

        l := Label in:t.
        l model:((PluggableAdaptor on:assoc) getSelector:#key putSelector:#key:);
          labelMessage:#value; aspect:#value;
          level:-1.
        l := Label in:t.
        l model:((PluggableAdaptor on:assoc) getSelector:#value putSelector:#value:);
          labelMessage:#value; aspect:#value;
          level:-1.
        t open.

        (Delay forSeconds:3) wait.
        assoc key:'goodbye'.
        assoc changed.
                                                                        [exEnd]

    extract values from an array into different labels:
                                                                        [exBegin]
        |a t l|

        a := #('one' 'two' 'three').

        t := HorizontalPanelView new.
        t extent:200@50.
        t horizontalLayout:#fitSpace.

        l := Label in:t.
        l model:((PluggableAdaptor on:a) collectionIndex:1);
          labelMessage:#value; aspect:#value;
          level:-1;
          sizeFixed:true.
        l := Label in:t.
        l model:((PluggableAdaptor on:a) collectionIndex:2);
          labelMessage:#value; aspect:#value;
          level:-1;
          sizeFixed:true.
        l := Label in:t.
        l model:((PluggableAdaptor on:a) collectionIndex:3);
          labelMessage:#value; aspect:#value;
          level:-1;
          sizeFixed:true.
        t open.

        (Delay forSeconds:3) wait.
        a at:1 put:'1'.
        a changed.
                                                                        [exEnd]
"
! !

!PluggableAdaptor class methodsFor:'instance creation'!

on:anObject
    "create & return a new protocolAdaptor.
     Any get/put and updateBlocks are still to be defined"

    ^ self new model:anObject

    "Modified: 21.2.1997 / 18:31:22 / cg"
!

on:anObject getter:getterBlock
    ^ (self on:anObject) getter:getterBlock

    "Created: / 08-08-2004 / 21:54:04 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Modified: / 22-12-2010 / 11:29:14 / cg"
!

on:anObject getter:getterBlock setter:setterBlock
    ^ (self on:anObject) getter:getterBlock setter:setterBlock

    "Created: / 08-08-2004 / 21:53:58 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Modified: / 22-12-2010 / 11:29:18 / cg"
!

on:anObject setter:setterBlock
    ^ (self on:anObject)
        setter:setterBlock

    "Created: / 08-08-2004 / 21:54:12 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!PluggableAdaptor methodsFor:'accessing'!

getBlock
    ^ getBlock
!

putBlock
    ^ putBlock
!

setValue:newValue
    putBlock notNil ifTrue:[
	^ putBlock value:model value:newValue
    ].
    model value:newValue "/ stupid default
!

updateBlock
    ^ updateBlock
!

value
    getBlock notNil ifTrue:[
	^ getBlock value:model
    ].
    ^ model value "/ stupid default
!

valueUsingSubject:someObject
    someObject isNil ifTrue:[^ nil].

    ^ getBlock value:someObject

    "Created: 21.2.1997 / 18:28:35 / cg"
! !

!PluggableAdaptor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == model ifTrue:[
        updateBlock notNil ifTrue:[
            (updateBlock value:model value:something value:aParameter)
            ifTrue:[
                self changed:#value
            ]
        ]
    ].

    "Modified: 21.2.1997 / 18:28:52 / cg"
! !

!PluggableAdaptor methodsFor:'initialization & release'!

collectionIndex:idx
    "configure the adaptor to translate #value/#value:-messages into
     indexed accesses via #at:/#at:put:, using the supplied index"

    getBlock := [:model | model value at:idx].
    putBlock := [:model :newValue | model value at:idx put:newValue].
    updateBlock := [:model :aspect :parameter |
                        aspect isNil or:[aspect == #value]
                   ]

    "Modified: 21.2.1997 / 18:20:24 / cg"
!

getBlock:newGetBlock
    "configure the adaptor to translate #value-messages into
     evaluation of the corresponding block.
     The getBlock argument block1 is called with one argument, the model, and is
     supposed to extract & return a value from that model."

    getBlock := newGetBlock.
!

getBlock:newGetBlock putBlock:newPutBlock
    "configure the adaptor to translate #value/#value:-messages into
     evaluation of the corresponding block1/block2.
     The getBlock argument block1 is called with one argument, the model, and is
     supposed to extract & return a value from that model.
     The putBlock argument, block2 is called with 2 arguments, the model
     and the new value, and is supposed to store the new value."

    getBlock := newGetBlock.
    putBlock := newPutBlock.
!

getBlock:newGetBlock putBlock:newPutBlock updateBlock:newUpdateBlock
    "configure the adaptor to translate #value/#value:-messages into
     evaluation of the corresponding block1/block2.
     The getBlock argument block1 is called with one argument, the model, and is
     supposed to extract & return a value from that model.
     The putBlock argument, block2 is called with 2 arguments, the model
     and the new value, and is supposed to store the new value.
     The updateBlock argument, block3 is called with 3 arguments, the model,
     the aspect as changed in the model and the change parameter. It
     is called when the adaptor receives an update message from the model,
     and should return true if a new value should be fetched from the model."

    getBlock := newGetBlock.
    putBlock := newPutBlock.
    self assert:(newUpdateBlock isNil or:[newUpdateBlock numArgs == 3]).
    updateBlock := newUpdateBlock.

    "Modified: 21.2.1997 / 18:18:38 / cg"
!

getSelector:getSelector putSelector:putSelector
    "configure the adaptor to translate #value-messages into a send of
     getSelector and #value:-messages into sends of putSelector."

    getBlock := [:model | model perform:getSelector].
    putBlock := [:model :newValue | model perform:putSelector with:newValue].
    updateBlock := [:model :aspect :parameter |
                        aspect isNil
                        or:[aspect == getSelector
                        or:[aspect == #value]]
                   ]

    "Modified: 21.2.1997 / 18:21:27 / cg"
!

model
    "get the real model, into which / from which the
     real model value is converted"

    ^ model 
!

model:anObject
    "set the real model, into which / from which the
     real model value is converted"
     
    model notNil ifTrue:[
       model removeDependent:self
    ].
    model := anObject.
    model notNil ifTrue:[
        model addDependent:self
    ]
!

performAction:aSelector
    "configure the adaptor to send an aSelector-message to the model
     whenever a new value is stored via #value:"

    getBlock := [:model | nil].
    putBlock := [:model :newValue | model perform:aSelector].
    updateBlock := [:model :aspect :parameter | false]
!

putBlock:newPutBlock
    "configure the adaptor to translate#value:-messages into
     evaluation of the corresponding block2.
     The putBlock argument, block2 is called with 2 arguments, the model
     and the new value, and is supposed to store the new value."

    putBlock := newPutBlock.
!

selectValue:something
    "configure the adaptor to behave like a boolean value, returning
     true whenever the models value equals something"

"/    getBlock := [:model | model value = something].
"/    putBlock := [:model :newValue | newValue ifTrue:[model value:something]].
"/    updateBlock := [:model :aspect :parameter |
"/                        aspect isNil or:[aspect == #value]
"/                   ]

    "/ changed for vw compatibility

    |lastValue|

    lastValue := nil.

    getBlock := [:model | lastValue := (model value = something)].
    putBlock := [:model :newValue | newValue
                                        ifTrue:[model value:something]
                                        ifFalse:[model value = something
                                                     ifTrue:[model value:nil]
                                        ]
                ].
    updateBlock := [:model :aspect :parameter |
                        ((model value = something) = lastValue) not
                   ]

    "Modified: 31.12.1996 / 13:58:09 / stefan"
    "Modified: 21.2.1997 / 18:27:26 / cg"
!

subjectChannel:aValueHolder
    "setup to use aValueHolder as model"

    self model:aValueHolder

    "Modified: 21.2.1997 / 18:19:46 / cg"
! !

!PluggableAdaptor methodsFor:'utilities'!

getter:getterBlock
    self
        getter:getterBlock
        setter:[:value|self shouldNeverBeReached]

    "Created: / 08-08-2004 / 21:53:02 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

getter:getter setter:setter
    | getterBlock setterBlock |

    getterBlock := getter.
    setter numArgs == 1 ifTrue:[
    	setterBlock := [:model :value| model value:(setter  value:value)]
    ] ifFalse:[
        setterBlock := setter
    ].

    self
        getBlock:getterBlock
        putBlock:setterBlock
        updateBlock:[:model :aspect :value|true]

    "Created: / 08-08-2004 / 21:52:20 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Modified: / 14-03-2014 / 23:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setter:setterBlock
    self
        getter:[:value|self shouldNeverBeReached]
        setter:setterBlock

    "Created: / 08-08-2004 / 21:53:19 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!PluggableAdaptor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

