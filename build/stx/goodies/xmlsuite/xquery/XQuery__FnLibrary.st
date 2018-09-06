"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

SmalltalkFunctionLibrary subclass:#FnLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!FnLibrary class methodsFor:'function library API'!

namespaceURI

    ^'http://www.w3.org/2005/xpath-functions'

    "Created: / 01-12-2008 / 10:03:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FnLibrary methodsFor:'fn:*'!

absInContext: context withParameters: parameters forInterpreter: interpreter
   "
Summary: Returns the absolute value of $arg. If $arg is negative returns -$arg otherwise returns $arg.
If the argument is the empty sequence, the empty sequence is returned.
"

    self assert: parameters size = 1.

    parameters size = 0 ifTrue:[^XQuerySequence new:0].

    self assert: parameters size = 1.
    "/self assert: parameters first first type = XQuerySequenceItem typeNumber.

    ^XQuerySequence withNumber:(parameters first first) abs.

    "Created: / 28-08-2007 / 23:46:52 / janfrog"
    "Modified: / 05-12-2007 / 15:56:42 / janfrog"
    "Modified: / 05-10-2009 / 17:38:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

avgInContext: context withParameters: parameters forInterpreter: interpreter
"
     Summary: Returns the average of the values in the input sequence $arg, that is,
     the sum of the values divided by the number of values.

     If $arg is the empty sequence, the empty sequence is returned.

     If $arg contains values of type xs:untypedAtomic they are cast to xs:double.

     Duration values must either all be xs:yearMonthDuration values or must all be xs:dayTimeDuration values.
     For numeric values, the numeric promotion rules defined in 6.2 Operators on Numeric Values are used
     to promote all values to a single common type.
     After these operations, $arg must contain items of a single type,
     which must be one of the four numeric types, xs:yearMonthDuration or xs:dayTimeDuration or one if its subtypes.

     If the above conditions are not met, then a type error is raised [err:FORG0006]."

    |sumContext countContext|

    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    sumContext := self 
                    sumInContext: context
                    withParameters: parameters
                    forInterpreter: interpreter.
    countContext := self 
                    countInContext: context
                    withParameters: parameters
                    forInterpreter: interpreter.
    ^ XQueryContext 
        withSingleNumber:(sumContext dataContext first value 
                / countContext dataContext first value) asDouble.

    "Created: / 29-08-2007 / 07:42:02 / janfrog"
!

baseUriInContext: context withParameters: parameters forInterpreter: interpreter
"
    fn:base-uri() as xs:anyURI?
    fn:base-uri($arg as node()?) as xs:anyURI?

    Summary: Returns the value of the base-uri URI property for $arg as defined by the accessor function 
    dm:base-uri() for that kind of node in Section 5.2 base-uri AccessorDM. If $arg is not specified, 
    the behavior is identical to calling the function with the context item (.) as argument. The following 
    errors may be raised: if the context item is undefined [err:XPDY0002]XP; if the context item 
    is not a node [err:XPTY0004]XP.

    If $arg is the empty sequence, the empty sequence is returned.

    Document, element and processing-instruction nodes have a base-uri property which may be empty. 
    The base-uri property of all other node types is the empty sequence. The value of the base-uri 
    property is returned if it exists and is not empty. Otherwise, if the node has a parent, 
    the value of dm:base-uri() applied to its parent is returned, recursively. If the node does not 
    have a parent, or if the recursive ascent up the ancestor chain encounters a node whose base-uri 
    property is empty and it does not have a parent, the empty sequence is returned.

    See also fn:static-base-uri.
"
    | item baseURI |
    self assert:parameters size <= 1.

    (parameters size = 0) ifTrue: [
        self assert: interpreter focus notNil.
        item := interpreter focus contextItem.
    ] ifFalse: [
        item := parameters first first.
    ].

    baseURI := item dmBaseUri.

    ((baseURI isNil) and: [item hasParent]) ifTrue: [
        baseURI := item xpathParent first dmBaseUri.
    ].

    ^ XQuerySequence with: baseURI.

    "Created: / 25-07-2009 / 19:13:39 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-11-2009 / 21:17:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

booleanInContext: context withParameters: parameters forInterpreter: interpreter
    "
       Summary: Computes the effective boolean value of the sequence $arg.

      If $arg is the empty sequence, fn:boolean returns false.

      If $arg is a sequence whose first item is a node, fn:boolean returns true.

      If $arg is a singleton value of type xs:boolean or a derived from xs:boolean, fn:boolean returns $arg.

      If $arg is a singleton value of type xs:string or a type derived from xs:string,
      xs:anyURI or a type derived from xs:anyURI or xs:untypedAtomic, fn:boolean returns false
      if the operand value has zero length; otherwise it returns true.

      If $arg is a singleton value of any numeric type or a type derived from a numeric type,
      fn:boolean returns false if the operand value is NaN or is numerically equal to zero; otherwise it returns true.

      In all other cases, fn:boolean raises a type error [err:FORG0006].
"
    self assert: parameters size = 1.

    ^XQuerySequence withBoolean: parameters first effectiveBooleanValue

    "Created: / 28-08-2007 / 23:45:06 / janfrog"
!

ceilingInContext: context withParameters: parameters forInterpreter: interpreter
"
Summary: Returns the smallest (closest to negative infinity) number with no fractional part
that is not less than the value of $arg.
If the argument is the empty sequence, the empty sequence is returned.
"

    self assert: parameters size = 1.

    parameters first dataContext size = 0 ifTrue:[
        ^XQueryContext new
                    dataContextEmpty.
    ].

    self assert: parameters first dataContext size = 1.
    "/self assert: parameters first dataContext first type = XQuerySequenceItem typeNumber.

    ^XQueryContext withSingleNumber: (parameters first dataContext first value) ceiling.

    "Created: / 29-08-2007 / 08:12:37 / janfrog"
    "Modified: / 05-12-2007 / 21:00:02 / janfrog"
!

collectionInContext: context withParameters: parameters forInterpreter: interpreter

    | uriString documentAdaptors |

    self assert: parameters size <= 1 message:'Zero or one argument expected'.
    uriString := parameters size = 1 
                    ifTrue:[parameters first first value asString]
                    ifFalse:[nil].

    documentAdaptors := (interpreter documentAdaptorsFor:uriString).

    ^XQuerySequence withAll:
        (documentAdaptors collect:
            [:documentAdaptor|
                XQueryConstructedItem with:
                    (XQueryAccessedNode new 
                        documentAdaptor: documentAdaptor;
                            nodeId: documentAdaptor xpathDocument)])

    "Created: / 20-09-2007 / 10:53:03 / janfrog"
    "Modified: / 20-09-2007 / 12:16:28 / janfrog"
    "Modified: / 18-09-2008 / 16:07:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-05-2009 / 12:35:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

concatInContext:context withParameters:parameters forInterpreter:interpreter 

    | stringStream |

    stringStream := UnicodeString new writeStream.
    parameters do:
        [:paramSeq|
        paramSeq do:
            [:seqItem|
            stringStream nextPutAll: seqItem stringValue]].

    ^ XQuerySequence 
        withString:stringStream contents

    "Created: / 19-11-2007 / 14:21:46 / janfrog"
    "Modified: / 18-05-2013 / 12:40:54 / houzvjir@fel.cvut.cz"
!

containsInContext:context withParameters:parameters forInterpreter:interpreter 
    "
    Summary: Returns an xs:boolean indicating whether or not the value 
    of $arg1 contains (at the beginning, at the end, or anywhere within) 
    at least one sequence of collation units that provides a minimal match 
    to the collation units in the value of $arg2, according to the collation 
    that is used.
    "

    | string substring |

    string := parameters first first.
    substring := parameters second first.

    (string isSubtypeOf: 'xs:string') ifFalse: 
        [FunctionError raiseErrorString: 'First argument must be xs:string!!'].

    (substring isSubtypeOf: 'xs:string') ifFalse: 
        [FunctionError raiseErrorString: 'Second argument must be xs:string!!'].

    ^ XQuerySequence withBoolean: ((string stringValue findString: (substring stringValue)) ~= 0).
!

countInContext: context withParameters: parameters forInterpreter: interpreter
 "
Summary: Returns the number of items in the value of $arg.

Returns 0 if $arg is the empty sequence.
"
    self assert: parameters size = 1.

     ^XQuerySequence withNumber: parameters first size.

    "Created: / 28-08-2007 / 23:47:31 / janfrog"
!

currentTimeInContext: context withParameters: parameters forInterpreter: interpreter
    "TODO"
    self assert: parameters size = 0.

     ^XQuerySequence with: (AtomicItem withValue: (Date today asString) asType: 'xs:time').

    "Created: / 22-09-2009 / 14:35:58 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:15:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dataInContext: context withParameters: parameters forInterpreter: interpreter
"
    fn:data($arg as item()*) as xs:anyAtomicType*

    Summary: fn:data takes a sequence of items and returns a sequence of atomic values.

    The result of fn:data is the sequence of atomic values produced by applying the following rules to each 
        item in $arg:

    *If the item is an atomic value, it is returned.
    *If the item is a node:
          o If the node does not have a typed value an error is raised [err:FOTY0012].
          o Otherwise, fn:data() returns the typed value of the node as defined by the accessor function dm:typed-value 
            in Section 5.15 typed-value AccessorDM.
"
    self assert: parameters size = 1.

    ^ XQuerySequence withAll: (parameters first collect: [ :item |
        item isAtomicValue ifTrue: [
            item.
        ] ifFalse: [
            item dmTypedValue
        ].
    ])

    "Modified: / 05-12-2007 / 21:00:02 / janfrog"
    "Created: / 19-09-2009 / 16:46:49 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 15:03:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

distinctValuesInContext:context withParameters:parameters forInterpreter:interpreter 
    "
   Summary: Returns the sequence that results from removing from $arg all but one of a set of values that are eq to one other.
   Values of type xs:untypedAtomic are compared as if they were of type xs:string. Values that cannot be compared,
   i.e. the eq operator is not defined for their types, are considered to be distinct.
   The order in which the sequence of values is returned is implementation dependent.

   If $arg is the empty sequence, the empty sequence is returned."
    
    |sequence sequenceValues result|

    self assert:(parameters size = 1).
    result := XQuerySequence new.
    sequence := parameters first.
    sequenceValues := Set new.
    sequence do:
        [:seqItem|
        |seqItemValue|
        seqItemValue := seqItem stringValue.
        (sequenceValues includes:seqItemValue)
            ifFalse:
                [result add: seqItem.
                sequenceValues add: seqItemValue]].
    ^result

    "
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    valuesCollection := OrderedCollection new.
    resultDataContext := OrderedCollection new.
    parameters first dataContext do:[:dataContextItem | 
        itemValue := dataContextItem value.
        (valuesCollection anySatisfy:[:value | itemValue = value ]) ifFalse:[
            valuesCollection add:itemValue.
            resultDataContext add:dataContextItem.
        ].
    ].
     "

    "Created: / 29-08-2007 / 08:45:39 / janfrog"
    "Modified: / 20-09-2007 / 15:47:34 / janfrog"
!

docInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Retrieves a document using an xs:anyURI, which may include a fragment identifier, supplied as an xs:string.
     If $uri is not a valid xs:anyURI, an error is raised [err:FODC0005].
     If it is a relative URI Reference, it is resolved relative to the value of the base URI property from the static context.
     The resulting absolute URI Reference is promoted to an xs:string.
     If the Available documents discussed in Section 2.1.2 Dynamic ContextXP provides a mapping from this string
     to a document node, the function returns that document node. If the Available documents provides no mapping for the string,
     an error is raised [err:FODC0005].

     If $uri is the empty sequence, the result is an empty sequence."
    
    |uriString documentAdaptors|

    self assert:parameters size = 1 message:'Exactly one argument expected'.
    uriString := parameters first first stringValue.
    documentAdaptors := (interpreter documentAdaptorsFor:uriString).
    self assert:documentAdaptors size = 1
        message:'No or more documents matches given URI. Use fn:collection() instead'.
    ^ XQuerySequence 
        with:(NodeItem withNode:documentAdaptors first xpathDocument
                documentAdaptor:documentAdaptors first)

    "Created: / 28-08-2007 / 23:41:08 / janfrog"
    "Modified: / 20-09-2007 / 10:30:15 / janfrog"
    "Modified: / 18-09-2008 / 16:07:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:16:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

documentUriInContext: context withParameters: parameters forInterpreter: interpreter

    | node |
    parameters size = 0 ifTrue:[^XQuerySequence new].
    node := parameters first first item.
    ^node isDocumentNode 
            ifTrue:
                [XQuerySequence withString:node documentURI asString]
            ifFalse:
                [XQuerySequence new]

    "Created: / 20-09-2007 / 14:43:23 / janfrog"
!

emptyInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: If the value of $arg is the empty sequence, the function returns true; otherwise, the function returns false."
    
    self assert:parameters size = 1.
    ^ XQuerySequence withBoolean: (parameters first size = 0).

    "Created: / 29-08-2007 / 09:09:33 / janfrog"
!

endsWithInContext:context withParameters:parameters forInterpreter:interpreter 

    "Returns true if string1 ends with string2, otherwise it returns false

    Example: ends-with('XML','X')
    Result: false"

    | string1 string2 pos dif|

    parameters size ~= 2 ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string1 := parameters first first.
           (string1 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string1 := string1 stringValue.
           ]
     ifFalse: [string1 := ''].
    parameters second size ~= 0 ifTrue: 
           [string2 := parameters second first.
           (string2 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string2 := string2 stringValue.
           ]
     ifFalse: [string2 := ''].
    ((string1 isEmpty) & (string2 isEmpty)) ifTrue: [^XQuerySequence withBoolean: true].
    ((string1 size > 0) & (string2 isEmpty)) ifTrue:  [^XQuerySequence withBoolean: true].
    ((string1 isEmpty) & (string2 size > 0)) ifTrue:  [^XQuerySequence withBoolean: false].

    pos := string1 findString: string2.

    dif := string1 size - string2 size.
    ^XQuerySequence withBoolean: (pos = (string1 size - string2 size + 1)).

    "Created: / 03-05-2013 / 16:53:14 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 12:39:23 / houzvjir@fel.cvut.cz"
!

exactlyOneInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns $arg if it contains exactly one item. Otherwise, raises an error [err:FORG0005]."
    
    self assert:parameters size = 1.
    self assert:parameters first size = 1.
    ^ parameters first.

    "Created: / 29-08-2007 / 09:10:01 / janfrog"
!

existsInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: If the value of $arg is not the empty sequence, the function returns true; otherwise, the function returns false."
    
    self assert:parameters size = 1.
    ^ XQueryContext withSingleBoolean:parameters first dataContext size > 0.

    "Created: / 29-08-2007 / 09:10:43 / janfrog"
!

falseInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the xs:boolean value false. Equivalent to xs:boolean('0')."
    
    self assert:parameters size = 0.
    ^ XQuerySequence withBoolean:false.

    "Created: / 29-08-2007 / 09:10:49 / janfrog"
    "Modified: / 10-05-2009 / 18:17:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

floorInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the largest (closest to positive infinity) number with no fractional part
     that is not greater than the value of $arg.
     If the argument is the empty sequence, the empty sequence is returned."
    
    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    self assert:parameters first dataContext size = 1.
    "/self assert:parameters first dataContext first type 
    "/            = XQuerySequenceItem typeNumber.
    ^ XQueryContext 
        withSingleNumber:(parameters first dataContext first value) floor.

    "Created: / 29-08-2007 / 09:10:55 / janfrog"
    "Modified: / 05-12-2007 / 21:00:10 / janfrog"
!

hoursFromTimeInContext: context withParameters: parameters forInterpreter: interpreter

    "TODO"
    self assert: parameters size = 1.

     ^XQuerySequence new.

    "Created: / 22-09-2009 / 14:50:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

insertBeforeInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns a new sequence constructed from the value of $target with the value of $inserts
     inserted at the position specified by the value of $position.
     (The value of $target is not affected by the sequence construction.)

     If $target is the empty sequence, $inserts is returned. If $inserts is the empty sequence, $target is returned.

     The value returned by the function consists of all items of $target whose index is less than $position,
     followed by all items of $inserts, followed by the remaining elements of $target, in that sequence.

     If $position is less than one (1), the first position, the effective value of $position is one (1).
     If $position is greater than the number of items in $target, then the effective value of $position
     is equal to the number of items in $target plus 1."
    
    |index resultDataContext|

    self assert:parameters size = 3.
    parameters first dataContext size = 0 ifTrue:[
        ^ parameters third.
    ].
    parameters third dataContext size = 0 ifTrue:[
        ^ parameters first.
    ].
    self assert:parameters second dataContext size = 1.
    "/self assert:parameters second dataContext first type 
    "/            = XQuerySequenceItem typeNumber.
    index := parameters second dataContext first value.
    index < 1 ifTrue:[
        index := 1.
    ].
    index > parameters first dataContext size ifTrue:[
        index := parameters first dataContext size + 1.
    ].
    resultDataContext := OrderedCollection new 
                addAll:parameters first dataContext.
    resultDataContext addAll:parameters third dataContext beforeIndex:index.
    ^ XQueryContext new dataContext:resultDataContext.

    "Created: / 29-08-2007 / 09:11:05 / janfrog"
    "Modified: / 05-12-2007 / 21:00:17 / janfrog"
!

lastInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the context size from the dynamic context.
     If the context item is undefined, an error is raised: [err:XPDY0002]."
    
    self assert:parameters size = 0.
    self assert:interpreter focus notNil.
    ^ XQuerySequence with:
        (AtomicItem withValue:(interpreter focus contextSize) asType: 'xs:integer').

    "Created: / 29-08-2007 / 09:11:12 / janfrog"
    "Modified: / 17-04-2008 / 11:14:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:07:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

localNameInContext:context withParameters:parameters forInterpreter:interpreter 

    self assert:parameters size = 1.
    self assert:parameters first size = 1.
    self assert:parameters first first containsNode.
    self assert:parameters first first item isElementOrAttributeNode.
    ^ XQuerySequence 
        withString:(parameters first first item xpathLocalName)

    "Created: / 19-11-2007 / 14:10:25 / janfrog"
!

lowerCaseInContext: context withParameters: parameters forInterpreter: interpreter

    "Summary:Converts the string argument to lower-case

    Example: lower-case('The XML')
    Result: 'the xml'"

    | string |

   (parameters size ~= 1) ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string := parameters first first.
           (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string := string stringValue.
           ]
     ifFalse: [string := ''].


    ^ XQuerySequence withString: (string asLowercase).

    "Created: / 05-05-2013 / 19:12:23 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 15:05:42 / houzvjir@fel.cvut.cz"
!

matchesInContext:context withParameters:parameters forInterpreter:interpreter 

   "Summary:
    Returns true if the string argument matches the pattern, otherwise, it returns false

    Example: matches('Merano', 'ran')
    Result: true"

    | string substring |

   (parameters size ~= 2) ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string := parameters first first.
           (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string := string stringValue.
           ]
     ifFalse: [string := ''].

    parameters first size ~= 0 ifTrue: 
           [substring := parameters second first.
           (substring isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            substring := substring stringValue.
           ]
     ifFalse: [substring := ''].

    ^ XQuerySequence withBoolean: ((string findString: substring ) ~= 0).

    "Created: / 05-05-2013 / 18:54:15 / houzvjir@fel.cvut.cz"
    "Modified: / 19-05-2013 / 23:20:12 / houzvjir@fel.cvut.cz"
!

maxInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Selects an item from the input sequence $arg whose value is greater than or equal to the value of every other item
     in the input sequence. If there are two or more such items, then the specific item whose value is returned
     is implementation dependent."
    
    |chosenItem|

    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    parameters first dataContext do:[:dataContextItem | 
        chosenItem 
            ifNil:[ chosenItem := dataContextItem. ]
            ifNotNil:[
                chosenItem value < dataContextItem value ifTrue:[
                    chosenItem := dataContextItem.
                ].
            ].
    ].
    ^ XQueryContext new dataContextSingle:chosenItem.

    "Created: / 29-08-2007 / 09:11:19 / janfrog"
!

minInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Selects an item from the input sequence $arg whose value is greater than or equal to the value of every other item
     in the input sequence. If there are two or more such items, then the specific item whose value is returned
     is implementation dependent."
    
    |chosenItem|

    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    parameters first dataContext do:[:dataContextItem | 
        chosenItem 
            ifNil:[ chosenItem := dataContextItem. ]
            ifNotNil:[
                chosenItem value < dataContextItem value ifTrue:[
                    chosenItem := dataContextItem.
                ].
            ].
    ].
    ^ XQueryContext new dataContextSingle:chosenItem.

    "Created: / 29-08-2007 / 09:11:39 / janfrog"
!

notInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: $arg is first reduced to an effective boolean value by applying the fn:boolean() function.
     Returns true if the effective boolean value is false, and false if the effective boolean value is true."
    
    self assert:parameters size = 1.

    ^ XQuerySequence with: 
        (AtomicItem withValue: ((parameters first effectiveBooleanValue) not)
                      asType: 'xs:boolean').

    "Created: / 29-08-2007 / 09:12:12 / janfrog"
    "Modified: / 07-10-2009 / 12:15:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

oneOrMoreInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns $arg if it contains one or more items. Otherwise, raises an error [err:FORG0004]."
    
    self assert:parameters size = 1.
    self assert:parameters first dataContext size > 0.
    ^ parameters first.

    "Created: / 29-08-2007 / 09:12:25 / janfrog"
!

positionInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the context position from the dynamic context.
     If the context item is undefined, an error is raised: [err:XPDY0002]."
    
    self assert:parameters size = 0.
    self assert:interpreter focus notNil.
    ^ XQuerySequence with:
        (AtomicItem withValue: (interpreter focus contextPosition) asType: 'xs:integer').

    "Modified: / 24-11-2006 / 11:40:47 / ked"
    "Created: / 29-08-2007 / 09:12:38 / janfrog"
    "Modified: / 17-04-2008 / 11:15:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 16:25:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

putInContext:context withParameters:parameters forInterpreter:interpreter 
    "fn:put($node as node(), $uri as xs:string) as empty-sequence()
     Summary: Stores a document or element to the location specified by $uri.
     This function is normally invoked to create a resource on an external
     storage system such as a file system or a database."

    | documentURI |

    self 
        assert:parameters size = 2 message: 'Two parameters required, ', parameters size printString , ' given';
        assert:parameters first containsSingleElementOrDocument message:'First parameter must be signleton sequence with document od element node';
        assert:parameters second containsSingleString message:'Second parameter must be signleton sequence with xs:string'.


    documentURI := parameters second first value asURI.

    self
        assert: (documentURI isKindOf: FileURI) message:'For now, only file:// URIs are supported'.

    documentURI writeStreamDo:
        [:writeStream :attributes|
        writeStream nextPutAll: (XQueryResult withAll: parameters first) asDocumentWithoutComment asXMLString].

    ^ XQuerySequence new.
!

removeInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns a new sequence constructed from the value of $target with the item at the position
     specified by the value of $position removed.

     If $position is less than 1 or greater than the number of items in $target, $target is returned.
     Otherwise, the value returned by the function consists of all items of $target whose index is less than $position,
     followed by all items of $target whose index is greater than $position.
     If $target is the empty sequence, the empty sequence is returned."
    
    |index |

    self assert:parameters size = 2.
    parameters first size = 0 ifTrue:[
        ^ XQuerySequence new.
    ].
    self assert:parameters second size = 1.
    "/self assert:parameters second dataContext first type 
    "/            = XQuerySequenceItem typeNumber.
    index := parameters second first value.
    index < 1 ifTrue:[
        ^ parameters first.
    ].
    index > parameters first size ifTrue:[
        ^ parameters first.
    ].
    parameters first removeFromIndex:index toIndex:index.
    ^ parameters first.

    "Created: / 29-08-2007 / 09:12:44 / janfrog"
    "Modified: / 05-12-2007 / 21:00:24 / janfrog"
    "Modified: / 22-09-2009 / 14:42:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

reverseInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Reverses the order of items in a sequence. If $arg is the empty sequence, the empty sequence is returned."
    
    |resultDataContext|

    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    resultDataContext := OrderedCollection new 
                addAll:parameters first dataContext.
    resultDataContext reverse.
    ^ XQueryContext new dataContext:resultDataContext.

    "Created: / 29-08-2007 / 09:13:02 / janfrog"
!

rootInContext: context withParameters: parameters forInterpreter: interpreter

    | node |
    parameters size = 0 ifTrue:[^XQuerySequence new].
    node := parameters first first item.
    ^XQuerySequence with:(node xpathAncestor last)

    "Created: / 20-09-2007 / 15:14:06 / janfrog"
!

roundInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the number with no fractional part that is closest to the argument. If there are two such numbers,
     then the one that is closest to positive infinity is returned.
     If the argument is the empty sequence, the empty sequence is returned."
    
    self assert:parameters size = 1.
    parameters first dataContext size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    self assert:parameters first dataContext size = 1.
    "/self assert:parameters first dataContext first type 
    "/            = XQuerySequenceItem typeNumber.
    ^ XQueryContext 
        withSingleNumber:((parameters first dataContext first value) > 0 
                ifTrue:[ (parameters first dataContext first value) rounded. ]
                ifFalse:[ (parameters first dataContext first value) truncated. ]).

    "Created: / 29-08-2007 / 09:13:10 / janfrog"
    "Modified: / 05-12-2007 / 21:00:30 / janfrog"
!

startsWithInContext:context withParameters:parameters forInterpreter:interpreter 

    "Summary: Returns true if string1 starts with string2, otherwise it returns false

    Example: starts-with('XML','X')
    Result: true"

    | string1 string2 pos|

    parameters size ~= 2 ifTrue: [^XQuerySequence new:0].


    parameters first size ~= 0 ifTrue: 
           [string1 := parameters first first.
           (string1 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string1 := string1 stringValue.
           ]
     ifFalse: [string1 := ''].
    parameters second size ~= 0 ifTrue: 
           [string2 := parameters second first.
           (string2 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string2 := string2 stringValue.
           ]
     ifFalse: [string2 := ''].
    ((string1 isEmpty) & (string2 isEmpty)) ifTrue: [^XQuerySequence withBoolean: true].
    ((string1 size > 0) & (string2 isEmpty)) ifTrue:  [^XQuerySequence withBoolean: true].
    ((string1 isEmpty) & (string2 size > 0)) ifTrue:  [^XQuerySequence withBoolean: false].

    pos := string1 findString: string2.

    ^XQuerySequence withBoolean: (pos = 1).

    "Created: / 03-05-2013 / 16:14:32 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 12:48:05 / houzvjir@fel.cvut.cz"
!

stringInContext: context withParameters: parameters forInterpreter: interpreter
"
    Summary: Returns the value of $arg represented as a xs:string. If no argument is supplied, 
        the context item (.) is used as the default argument. The behavior of the function if the 
        argument is omitted is exactly the same as if the context item had been passed as the argument.

    If the context item is undefined, error [err:XPDY0002]XP is raised.

    If $arg is the empty sequence, the zero-length string is returned.

    If $arg is a node, the function returns the string-value of the node, as obtained using the dm:string-value accessor defined in the Section 5.13 string-value AccessorDM.

    If $arg is an atomic value, then the function returns the same string as is returned by the expression ' $arg cast as xs:string ' (see 17 Casting).
"

    "TODO TODO TODO"
    | item stringValue |
    self assert:parameters size <= 1.

    (parameters size = 0) ifTrue: [
        self assert: interpreter focus notNil.
        item := interpreter focus contextItem.
    ] ifFalse: [
        item := parameters first first.
    ].

    (item isAtomicValue) ifTrue:
    [
        stringValue := item castAs: 'xs:string'.
    ]
    ifFalse:
    [
        stringValue := item dmStringValue.
    ].

    ^ XQuerySequence withString: stringValue

    "Created: / 06-10-2009 / 17:48:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:40:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

stringLengthInContext:context withParameters:parameters forInterpreter:interpreter 

    "Summary: Returns the length of the specified string. If there is no string argument it returns the length of the string value of the current node

    Example: string-length('Beatles')
    Result: 7 "

    | string |

    parameters size ~= 1 ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string := parameters first first.
           (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string := string stringValue.
           ]
     ifFalse: [string := ''].

     string isEmpty ifTrue: [^XQuerySequence withNumber: 0].

    ^XQuerySequence withNumber: (string size).

    "Created: / 12-05-2013 / 12:12:35 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 13:20:22 / houzvjir@fel.cvut.cz"
!

subsequenceInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the contiguous sequence of items in the value of $sourceSeq beginning at the position
     indicated by the value of $startingLoc and continuing for the number of items indicated by the value of $length.

     If $sourceSeq is the empty sequence, the empty sequence is returned.

     If $startingLoc is zero or negative, the subsequence includes items from the beginning of the $sourceSeq.

     If $length is not specified, the subsequence includes items to the end of $sourceSeq.

     If $length is greater than the number of items in the value of $sourceSeq following $startingLoc, the subsequence includes items to the end of $sourceSeq.

     The first item of a sequence is located at position 1, not position 0."
    
    |start stop resultDataContext|

    self assert:(parameters size = 2 or:[ parameters size = 3 ]).
    parameters first size = 0 ifTrue:[
        ^ XQueryContext new dataContextEmpty.
    ].
    self assert:parameters second size = 1.
    "/self assert:parameters second dataContext first type 
    "/            = XQuerySequenceItem typeNumber.
    start := parameters second first value.
    start < 1 ifTrue:[
        start := 1.
    ].
    parameters size = 3 ifTrue:[
        self assert:parameters third size = 1.
        "/self assert:parameters third dataContext first type 
        "/            = XQuerySequenceItem typeNumber.
        stop := parameters third first value + start - 1.
        stop > parameters first size ifTrue:[
            stop := parameters first size.
        ].
    ] ifFalse:[
        stop := parameters first size.
    ].
    resultDataContext := parameters first copyFrom:start to:stop.
    ^ XQuerySequence withAll: resultDataContext.

    "Created: / 29-08-2007 / 09:07:19 / janfrog"
    "Modified: / 05-12-2007 / 21:00:44 / janfrog"
    "Modified: / 21-11-2009 / 19:59:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

substringAfterInContext:context withParameters:parameters forInterpreter:interpreter 

    "Summary:
    Returns the remainder of string1 after string2 occurs in it

    Example: substring-after('12/10','/')
    Result: '10'"

    | string1 string2 pos|

    parameters size ~= 2 ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string1 := parameters first first.
           (string1 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string1 := string1 stringValue.
           ]
     ifFalse: [string1 := ''].
    parameters second size ~= 0 ifTrue: 
           [string2 := parameters second first.
           (string2 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string2 := string2 stringValue.
           ]
     ifFalse: [string1 := '']. 
   (string1 size < string2 size) ifTrue: [^XQuerySequence new:0].

    pos := string1 findString: string2.
    pos := pos + string2 size.
    (pos > 0) & (pos <= (string1 size)) ifTrue: [
      ^ XQuerySequence withString: (string1 copyFrom: pos to: string1 size)
    ] ifFalse: [
      ^ XQuerySequence withString: '' 
    ]

    "Created: / 05-05-2013 / 17:21:51 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 14:38:50 / houzvjir@fel.cvut.cz"
!

substringBeforeInContext:context withParameters:parameters forInterpreter:interpreter 

    "Returns the start of string1 before string2 occurs in it

    Example: substring-before('12/10','/')
    Result: '12'"

    | string1 string2 pos|

    parameters first size ~= 0 ifTrue: 
           [string1 := parameters first first.
           (string1 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string1 := string1 stringValue.
           ]
     ifFalse: [string1 := ''].
    parameters second size ~= 0 ifTrue: 
           [string2 := parameters second first.
           (string2 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string2 := string2 stringValue.
           ]
     ifFalse: [string1 := '']. 

    pos := string1 findString: string2.
    (pos > 1) ifTrue: [
      ^ XQuerySequence withString: (string1 copyFrom: 1 to: pos-1)
    ] ifFalse: [
       ^ XQuerySequence withString: ''    "!!!!!! TODO !!!!!!!! jak vratit prazdny retezec ?!!?!!?!!?!!  "
    ]

    "Created: / 05-05-2013 / 17:39:12 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 14:48:59 / houzvjir@fel.cvut.cz"
!

substringInContext:context withParameters:parameters forInterpreter:interpreter 

    "Returns the substring from the start position to the specified length. Index of the first character is 1. If length is omitted it returns the substring from the start position to the end

    Example: substring('Beatles',1,4)
    Result: 'Beat'

    Example: substring('Beatles',2)
    Result: 'eatles'"

    | string start len |

    parameters size = 3 ifTrue:[
      start := parameters second first.
      len := parameters third first.

       parameters first size ~= 0 ifTrue: 
           [string := parameters first first.
           (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string := string stringValue.
           ]
         ifFalse: [string := '']. 
      (start isSubtypeOf: 'xs:integer') ifFalse: [^XQuerySequence new:0].
      (len isSubtypeOf: 'xs:integer') ifFalse: [^XQuerySequence new:0].
      start := start asNumber.
      len := len asNumber.
      start = 0 ifTrue: [start:=1. len>1 ifTrue: [len := len - 1]].
      start < 0 ifTrue: [len>(1-start) ifTrue:[len := len + start - 1]. start:=1.].

      ((start < 1) | (len < 0) | ((start + len - 1) > string size))  ifTrue:
          [^XQuerySequence new:0].

      ^ XQuerySequence 
          withString: (string  copyFrom: start to: start + len - 1).
    ]
    ifFalse: [
      parameters size = 2 ifTrue: [
        string := parameters first first.
        start := parameters second first.

           parameters first size ~= 0 ifTrue: 
             [string := parameters first first.
              (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
              string := string stringValue.
             ]
         ifFalse: [string := '']. 
        (start isSubtypeOf: 'xs:integer') ifFalse: 
          [FunctionError raiseErrorString: 'Second argument must be xs:integer!!'].
        start := start asNumber.

        (start < 1) ifTrue:
          [FunctionError raiseErrorString: 'Wrong values of arguments!!'].

        ^ XQuerySequence 
            withString: (string  copyFrom: start to: string size).
        ] ifFalse:  "Wrong number of arguments"
          [XQuerySequence new:0]
    ].

    "Created: / 05-05-2013 / 16:50:39 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 14:13:21 / houzvjir@fel.cvut.cz"
!

sumInContext: context withParameters: parameters forInterpreter: interpreter
   "
Summary: Returns a value obtained by adding together the values in $arg.
If $zero is not specified, then the value returned for an empty sequence is the xs:integer value 0.
If $zero is specified, then the value returned for an empty sequence is $zero.

Any values of type xs:untypedAtomic in $arg are cast to xs:double.
The items in the resulting sequence may be reordered in an arbitrary order.
The resulting sequence is referred to below as the converted sequence.

If the converted sequence is empty, then the single-argument form of the function returns the xs:integer value 0;
the two-argument form returns the value of the argument $zero
"

    | sumAccum |

    self assert: (parameters size = 1 
        or:[parameters size = 2]).

    parameters first size = 0 ifTrue:[
        parameters size = 2 ifTrue:[
            ^parameters second.
        ] ifFalse:[
            ^XQueryContext withSingleNumber: 0.
        ].
    ].

    sumAccum := AtomicItem withValue: 0 asType: 'xs:integer'.

    parameters first do:[:dataContextItem |
        sumAccum := (interpreter funcTable
                            evaluate: 'op:numeric-add'
                            inContext: context
                            withParameters: (XQuerySequence with: sumAccum with: dataContextItem)
                            forInterpreter: interpreter) first.
    ].

    ^XQuerySequence with: sumAccum.

    "Created: / 28-08-2007 / 23:43:21 / janfrog"
    "Modified: / 05-12-2007 / 15:42:27 / janfrog"
    "Modified: / 19-10-2009 / 22:35:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

translateInContext:context withParameters:parameters forInterpreter:interpreter 

    " Summary:
    Converts string1 by replacing the characters in string2 with the characters in string3

    Example: translate('12:30','30','45')
    Result: '12:45'

    Example: translate('12:30','03','54')
    Result: '12:45'

    Example: translate('12:30','0123','abcd')
    Result: 'bc:da'"

   | string1 string2 string3 pos pos1 |

    parameters size ~= 3 ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: [
            string1 := parameters first first.
            (string1 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string1 := string1 stringValue.
          ]
     ifFalse: [string1 := ''].
    parameters second size ~= 0 ifTrue: [
            string2 := parameters second first.
            (string2 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string2 := string2 stringValue.
          ]
     ifFalse: [string2 := ''].
    parameters third size ~= 0 ifTrue: [
            string3 := parameters third first.
            (string3 isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string3 := string3 stringValue.
          ]
     ifFalse: [string3 := ''].

    pos := 1.
    [  pos <= string3 size ifTrue: [
         string1 replaceAll: (string2 at:pos) with: (string3 at:pos).
       ] ifFalse: [
         pos1 := 1.
         [ pos1 := string1 findString: (string2 copyFrom:pos to:pos) startingAt:pos1.
           pos1 > 0 ifTrue: [
             pos1 > 1 ifTrue: [string1 := (string1 copyFrom: 1 to: pos1-1),
                              (string1 copyFrom: (pos1+1) to: string1 size).]
                     ifFalse: [string1 := string1 copyFrom: (pos1+1) to: string1 size.].
           ].
           (pos1 > 0)
         ] whileTrue.
       ].
       pos := pos + 1.
       pos <= string2 size
    ] whileTrue.

    ^XQuerySequence withString:string1.

    "Created: / 12-05-2013 / 13:56:49 / houzvjir@fel.cvut.cz"
    "Modified: / 19-05-2013 / 23:24:02 / houzvjir@fel.cvut.cz"
!

trueInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns the xs:boolean value true. Equivalent to xs:boolean('1')."
    
    self assert:parameters size = 0.
    ^ XQuerySequence withBoolean: true.

    "Created: / 29-08-2007 / 09:08:19 / janfrog"
    "Modified: / 10-05-2009 / 18:17:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

upperCaseInContext: context withParameters: parameters forInterpreter: interpreter
    "comment stating purpose of this message"


    | string |

   (parameters size ~= 1) ifTrue: [^XQuerySequence new:0].

    parameters first size ~= 0 ifTrue: 
           [string := parameters first first.
           (string isSubtypeOf: 'xs:string') ifFalse: [^XQuerySequence new:0].
            string := string stringValue.
           ]
     ifFalse: [string := ''].


    ^ XQuerySequence withString: (string asUppercase).

    "Created: / 05-05-2013 / 19:01:57 / houzvjir@fel.cvut.cz"
    "Modified: / 18-05-2013 / 14:54:41 / houzvjir@fel.cvut.cz"
!

zeroOrOneInContext:context withParameters:parameters forInterpreter:interpreter 
    "
     Summary: Returns $arg if it contains zero or one items. Otherwise, raises an error [err:FORG0003]."
    
    self assert:parameters size = 1.
    self assert:parameters first size < 2.
    ^ parameters first.

    "Created: / 29-08-2007 / 09:09:01 / janfrog"
! !

!FnLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass says that I am responsible to implement this method"

    ^'fn'

    "Created: / 29-08-2007 / 09:37:40 / janfrog"
!

functionLocalNames

    ^#(
        abs
        avg
        boolean
        #'base-uri'
        ceiling
        count
        collection
        concat
        contains
        #'current-time'
        data
        #'distinct-values'
        doc
        #'document-uri'
        empty
        #'ends-with'
        #'exactly-one'
        exists
        #false
        floor
        #'hours-from-time'
        #'insert-before'
        last
        #'local-name'
        #'lower-case'
        max
        matches
        min
        not
        #'one-or-more'
        position
        put
        remove
        reverse
        root
        round
        subsequence
        substring
        #'substring-after'
        #'substring-before'
        #'string-length'
        sum
        #'starts-with'
        string
        translate
        #true
        #'upper-case'
        #'zero-or-one'
    )

    "Created: / 28-08-2007 / 23:12:35 / janfrog"
    "Modified: / 19-11-2007 / 14:18:06 / janfrog"
    "Modified: / 06-10-2009 / 17:47:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 12-05-2013 / 13:49:21 / houzvjir@fel.cvut.cz"
! !

!FnLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
