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

ValueModel subclass:#BlockValue
	instanceVariableNames:'cachedValue arguments block'
	classVariableNames:'NeverComputed'
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!BlockValue class methodsFor:'documentation'!

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
    BlockValues depend on multiple other objects (typically valueHolders)
    and recompute a value whenever one of them changes.
    If the new value is different, it triggers itself a change to its dependents.

    Example use is to base an enableChannels value on multiple other boolean values.
    (See example for how this is done)

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    Warning:
        BlockValues only work ine one direction; changing the blockValue's value
        does not affect the original model's value.

    [author:]
        Claus Gittinger
"
!

examples
"
    checkToggle 3 shows the value of toggle1 AND toggle2
                                                                        [exBegin]
        |val1 val2 both box|

        val1 := false asValue.
        val2 := false asValue.
        both := BlockValue 
                    with:[:v1 :v2 | 
                            Transcript showCR:'evaluating ...'.
                            v1 value and:[v2 value]
                         ] 
                    arguments:(Array with:val1 with:val2).

        box := Dialog new.
        box addCheckBox:'one' on:val1.
        box addCheckBox:'two' on:val2.
        box addHorizontalLine.
        box addCheckBox:'both' on:both.
        box addOkButton.
        box open
                                                                        [exEnd]

    the same, using a convenient instance creation message:
                                                                        [exBegin]
        |val1 val2 both box|

        val1 := false asValue.
        val2 := false asValue.
        both := BlockValue forLogical:val1 and:val2.

        box := Dialog new.
        box addCheckBox:'one' on:val1.
        box addCheckBox:'two' on:val2.
        box addHorizontalLine.
        (box addCheckBox:'both' on:both) disable.
        box addOkButton.
        box open
                                                                        [exEnd]

    logical or:
                                                                        [exBegin]
        |val1 val2 both box|

        val1 := false asValue.
        val2 := false asValue.
        both := BlockValue forLogical:val1 or:val2.

        box := Dialog new.
        box addCheckBox:'one' on:val1.
        box addCheckBox:'two' on:val2.
        box addHorizontalLine.
        box addCheckBox:'both' on:both.
        box addOkButton.
        box open
                                                                        [exEnd]

    example use: enabling an element depending on two others:
                                                                        [exBegin]
        |val1 val2 enabler val3 box|

        val1 := false asValue.
        val2 := false asValue.
        val3 := false asValue.
        enabler := BlockValue forLogical:val1 and:val2.

        box := Dialog new.
        box addCheckBox:'one' on:val1.
        box addCheckBox:'two' on:val2.
        box addHorizontalLine.
        (box addCheckBox:'three (both of the above)' on:val3) enableChannel:enabler.
        box addOkButton.
        box open
                                                                        [exEnd]


    like above, using a logical-or block:
                                                                        [exBegin]
        |val1 val2 enabler val3 box|

        val1 := false asValue.
        val2 := false asValue.
        val3 := false asValue.
        enabler := BlockValue forLogical:val1 or:val2.

        box := Dialog new.
        box addCheckBox:'one' on:val1.
        box addCheckBox:'two' on:val2.
        box addHorizontalLine.
        (box addCheckBox:'three (any of the above)' on:val3) enableChannel:enabler.
        box addOkButton.
        box open
                                                                        [exEnd]


    like above, using a bunch of toggles:
                                                                        [exBegin]
        |values anyValue box|

        values := (1 to:10) collect:[:i | false asValue].
        anyValue := BlockValue forLogicalOrAll:values.
        anyValue onChangeSend:#value to:[Transcript showCR:'any is true'].

        box := Dialog new.
        values keysAndValuesDo:[:index :aValueHolder |
            box addCheckBox:index printString on:aValueHolder.
        ].
        box addHorizontalLine.
        (box addOkButton) enableChannel:anyValue.
        box open
                                                                        [exEnd]
"
! !

!BlockValue class methodsFor:'initialization'!

initialize
    NeverComputed isNil ifTrue:[
	NeverComputed := Object new.
    ]
! !

!BlockValue class methodsFor:'instance creation'!

block:aBlock arguments:aCollectionOfArguments
    "return a new BlockValue computing aBlock.
     Same as #with:arguments: for ST80 compatibility"

    ^ self with:aBlock arguments:aCollectionOfArguments

    "Created: / 20.6.1998 / 14:00:16 / cg"
!

forLogical:arg1 and:arg2
    "return a new BlockValue computing the logical AND of its args
     (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:a :b | a value and:[b value]]
        arguments:(Array with:arg1 with:arg2)

    "Created: / 16.12.1995 / 19:20:14 / cg"
    "Modified: / 30.1.2000 / 23:24:50 / cg"
!

forLogical:arg1 and:arg2 and:arg3
    "return a new BlockValue computing the logical AND of its args
     (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:a :b :c | a value and:[b value and:[c value]]]
        arguments:(Array with:arg1 with:arg2 with:arg3)
!

forLogical:arg1 or:arg2
    "return a new BlockValue computing the logical OR of its args
     (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:a :b | a value or:[b value]]
        arguments:(Array with:arg1 with:arg2)

    "Created: / 16.12.1995 / 19:20:14 / cg"
    "Modified: / 30.1.2000 / 23:24:46 / cg"
!

forLogical:arg1 or:arg2 or:arg3
    "return a new BlockValue computing the logical OR of its args
     (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:a :b :c | a value or:[b value or:[c value]]]
        arguments:(Array with:arg1 with:arg2 with:arg3)
!

forLogicalAndAll:argArray
    "return a new BlockValue computing the logical AND of all elements
     in the passed argArray (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:a | (argArray findFirst:[:a | a value not]) == 0]
        argumentArray:argArray asArray

    "Created: / 22.1.1997 / 19:12:44 / cg"
    "Modified: / 28.4.1998 / 20:16:38 / ca"
    "Modified: / 30.1.2000 / 23:24:40 / cg"
!

forLogicalNot:arg
    "return a new BlockValue computing the logical NOT of its arg 
     (which is usually another valueHolder)"

    ^ (self new) 
        setBlock:[:a | a value not]
        arguments:(Array with:arg)

    "
        |v1 v2|

        v1 := ValueHolder new.
        v1 value:true.

        v2 := BlockValue forLogicalNot:v1.
        v2 onChangeEvaluate:[ Transcript showCR:v2 value].
        Transcript showCR:v2 value.         'shows a false already'. 

        v1 value:true.                      'no change signalled here'.
        v1 value:false.
        v1 value:true.
    "

    "Created: / 17.8.1998 / 10:06:41 / cg"
    "Modified: / 30.1.2000 / 23:24:18 / cg"
!

forLogicalOrAll:argArray
    "return a new BlockValue computing the logical OR of all elements
     in the passed argArray (which are usually other valueHolders)"

    ^ (self new) 
        setBlock:[:arg | (arg findFirst:[:el | el value]) ~~ 0]
        argumentArray:argArray asArray

    "Created: / 22.1.1997 / 19:13:01 / cg"
    "Modified: / 28.4.1998 / 20:20:09 / ca"
    "Modified: / 30.1.2000 / 23:24:34 / cg"
!

forValue:someValue equalTo:someConstant
    "return a new BlockValue generating a true, 
     if someValue (usually another holder) contains a value equal to someConstant.
     Useful, if the other valueHolder is a radioButton group model,
     and you want to automatically enable/disable other items based on the value
     (i.e. via the enableChannel)"

    ^ (self new) 
        setBlock:[:a | a = someConstant]
        arguments:(Array with:someValue)

    "
        |v1 v2|

        v1 := ValueHolder new.
        v1 value:'blah'.

        v2 := BlockValue forValue:v1 equalTo:'hello'.
        v2 onChangeEvaluate:[ Transcript showCR:v2 value].
        Transcript showCR:v2 value.         'shows a false already'. 

        v1 value:'blah'.                      'no change signalled here'.
        v1 value:'oops'.                      'remains false'.
        v1 value:'hello'.                     'changes to true'.
        v2 value      
    "
!

with:aBlock
    "return a new BlockValue computing aBlock"

    ^ (self new) setBlock:aBlock

    "Created: 16.12.1995 / 19:16:33 / cg"
!

with:aBlock argument:anArgument
    "return a new BlockValue computing aBlock"

    ^ (self new) 
        setBlock:aBlock 
        arguments:(Array with:anArgument)

    "Created: 16.12.1995 / 19:20:14 / cg"
!

with:aBlock argument:anArgument1 argument:anArgument2
    "return a new BlockValue computing aBlock"

    ^ (self new) 
        setBlock:aBlock 
        arguments:(Array with:anArgument1 with:anArgument2)

    "Created: 16.12.1995 / 19:20:14 / cg"
!

with:aBlock argument:anArgument1 argument:anArgument2 argument:anArgument3
    "return a new BlockValue computing aBlock"

    ^ (self new) 
        setBlock:aBlock 
        arguments:(Array with:anArgument1 with:anArgument2 with:anArgument3)
!

with:aBlock argument:anArgument1 argument:anArgument2 argument:anArgument3 argument:anArgument4
    "return a new BlockValue computing aBlock"

    ^ (self new) 
        setBlock:aBlock 
        arguments:(Array with:anArgument1 with:anArgument2 with:anArgument3 with:anArgument4)
!

with:aBlock arguments:aCollectionOfArguments
    "return a new BlockValue computing aBlock"

    ^ (self new) 
        setBlock:aBlock 
        arguments:aCollectionOfArguments

    "Created: 16.12.1995 / 19:20:14 / cg"
! !

!BlockValue methodsFor:'accessing'!

setBlock:aBlock
    "set the receiver's action block"

    block := aBlock.
    arguments notNil ifTrue:[
        self release
    ].
    arguments := nil.
    cachedValue := NeverComputed.

    "Created: 16.12.1995 / 19:16:59 / cg"
    "Modified: 22.1.1997 / 19:05:54 / cg"
!

setBlock:aBlock argumentArray:anArgumentCollection
    "set the receiver's action block, and define an arguments collection
     to be passed to it.
     A change in any element of the collection will force reevaluation of the 
     action block (passing the collection as a single argument)
     - possibly generating another change from myself"

    block := aBlock.
    arguments notNil ifTrue:[
        self release
    ].
    arguments := Array with:anArgumentCollection.
    anArgumentCollection do:[:arg |
        arg notNil ifTrue:[
            arg addDependent:self
        ].
    ].
    cachedValue := NeverComputed.

    "Modified: 22.1.1997 / 19:08:51 / cg"
    "Created: 22.1.1997 / 19:22:13 / cg"
!

setBlock:aBlock arguments:aCollectionOfArguments
    "set the receiver's action block, and define arguments to be passed to it.
     A change in any of the arguments will force reevaluation of the action
     block - possibly generating another change from myself"

    block := aBlock.
    arguments notNil ifTrue:[
        self release
    ].
    arguments := aCollectionOfArguments.
    arguments do:[:arg |
        "arg maybe some constant..."
        arg notNil ifTrue:[
            arg addDependent:self
        ].
    ].
    cachedValue := NeverComputed.

    "Created: 16.12.1995 / 19:21:41 / cg"
    "Modified: 22.1.1997 / 19:08:51 / cg"
!

setValue:newValue 
    "physically set my value, without change notifications.
     This is a noop here, since my value is computed."

    ^ self


!

value
    "retrieve my value - this does not always evaluate the action block,
     since the returned value is cached internally"

    cachedValue == NeverComputed ifTrue:[
        cachedValue := self computeValue
    ].
    ^ cachedValue

    "Created: 16.12.1995 / 19:23:26 / cg"
    "Modified: 22.1.1997 / 19:06:59 / cg"
! !

!BlockValue methodsFor:'change & update'!

recomputeValue
    "reevaluate my actionBlock, and possibly send a change notification to my dependents"

    |oldValue|

    oldValue := cachedValue.
    cachedValue := self computeValue.
    oldValue ~~ cachedValue ifTrue:[
        self changed:#value
    ].
!

update:something with:aParameter from:someone
    "the one I depend on has changed - reevaluate my actionBlock,
     and possibly send a change notification to my dependents"

    self recomputeValue

    "Created: 16.12.1995 / 19:22:54 / cg"
    "Modified: 22.1.1997 / 19:07:39 / cg"
! !

!BlockValue methodsFor:'dependents access'!

release
    "release any dependencies upon the arguments"

    arguments notNil ifTrue:[
        arguments do:[:arg | arg removeDependent:self].
    ].
    super release

    "Modified: 22.1.1997 / 19:08:06 / cg"
! !

!BlockValue methodsFor:'misc'!

computeValue
    "evaluate the receiver's action block"

    |sz arg1 arg2 argValues|

    arguments isNil ifTrue:[
        ^ block value
    ].
    sz := arguments size.
    sz == 0 ifTrue:[
        ^ block value
    ].
    arg1 := (arguments at:1) value.
    sz == 1 ifTrue:[
        ^ block value:arg1
    ].
    arg2 := (arguments at:2) value.
    sz == 2 ifTrue:[
        ^ block value:arg1 value:arg2
    ].
    "/ do not evaluate arg[1-2] twice
    argValues := Array new:arguments size.
    argValues at:1 put:arg1.    "/ do not evaluate twice
    argValues at:2 put:arg2.    "/ do not evaluate twice
    3 to:arguments size do:[:i | argValues at:i put:(arguments at:i) value].

    ^ block valueWithArguments:argValues

    "Created: 16.12.1995 / 19:27:40 / cg"
    "Modified: 22.1.1997 / 19:05:57 / cg"
!

dependOn:someObject
    "arrange for the blockValue to be reevaluated, whenever someObject
     changes (i.e. sends a change notification)"

    arguments isNil ifTrue:[
        arguments := Array with:someObject
    ] ifFalse:[
        arguments := arguments copyWith:someObject
    ].
    someObject addDependent:self

    "Modified: 22.1.1997 / 19:05:26 / cg"
!

resetValue
    "evaluate the receiver's action block"

    cachedValue := self computeValue
! !

!BlockValue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


BlockValue initialize!
