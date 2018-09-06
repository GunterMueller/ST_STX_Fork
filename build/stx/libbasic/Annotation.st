"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Annotation
	instanceVariableNames:'key arguments'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Extensions'
!

Annotation subclass:#NameSpace
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Annotation
!

Annotation subclass:#Resource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Annotation
!

Annotation subclass:#Unknown
	instanceVariableNames:'method'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Annotation
!

!Annotation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    I represent an occurrence of a pragma in a compiled method.  
    A pragma is a literal message pattern that occurs between angle brackets at the start of a method after any temporaries.  
    A common example is the primitive pragma:
        <primitive: 123 errorCode: 'errorCode'>
    but you can add your own and use them as metadata attached to a method.  
    Because pragmas are messages one can browse senders and implementors and perform them.  
    One can query a method for its pragmas by sending it the pragmas message, which answers an Array of instances of me, 
    one for each pragma in the method.
    I can provide information about the defining class, method, its selector, 
    as well as the information about the pragma keyword and its arguments. See the two 'accessing' protocols for details. 
    'accessing-method' provides information about the method the pragma is found in, 
    while 'accessing-pragma' is about the pragma itself.
    Instances are retrieved using one of the pragma search methods of the 'finding' protocol on the class side.
    To browse all methods with pragmas in the system evaluate
        SystemNavigation default browseAllSelect: [:m| m pragmas notEmpty] 
        in ST/X: Smalltalk browseAllSelect: [:m| m pragmas notEmpty]
    and to browse all nonprimitive methods with pragmas evaluate
        SystemNavigation default browseAllSelect: [:m| m primitive isZero and: [m pragmas notEmpty]]
"
! !

!Annotation class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    Smalltalk at:#Pragma put:self.

    "Modified: / 09-09-2011 / 07:16:26 / cg"
! !

!Annotation class methodsFor:'instance creation'!

for: aMethod selector: aSelector arguments: anArray
	^self new
		setMethod: aMethod;
		setKeyword: aSelector;
		setArguments: anArray;
		yourself
!

key: key arguments: arguments

    ^(self respondsTo: key)
        ifTrue:
            [self 
                perform: key 
                withArguments: arguments]
        ifFalse:
            [Annotation::Unknown new 
                key: key 
                arguments: arguments]

    "Created: / 19-05-2010 / 16:47:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-07-2010 / 16:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method:method key:key arguments:arguments

    ^
    "/ cg: do not react on all those methods inherited from Object (such as inline:)
    "/ (self respondsTo: key)
    (self class includesSelector:key) 
        ifTrue:
            [self 
                perform: key 
                withArguments: arguments]
        ifFalse:
            [Annotation::Unknown new
                method: method
                key: key 
                arguments: arguments]

    "Created: / 19-05-2010 / 16:47:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-07-2010 / 16:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-09-2011 / 04:39:17 / cg"
!

nameSpace: aString

    ^Annotation::NameSpace new nameSpaceName: aString

    "Created: / 19-05-2010 / 16:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2012 / 23:05:28 / cg"
!

namespace: aString
    <resource: #obsolete>

    ^ self nameSpace:aString

    "Created: / 19-05-2010 / 16:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resource: type

    ^Annotation::Resource new type: type value:nil

    "Created: / 16-07-2010 / 11:31:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resource:type values:value 
    ^ Annotation::Resource new type:type value:value

    "Created: / 16-07-2010 / 11:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation class methodsFor:'finding'!

allInMethod: aMethod
    "VisualWorks compatibility.
     Answer a collection of all pragmas found in the given method"

    ^ aMethod annotations
!

allNamed:aSymbol
    "Answer a collection of all pragmas found in all methods of all classes whose keyword is aSymbol."
        
    ^ Array 
        streamContents: [ :stream |
            Smalltalk allClassesDo:[:eachClass |
                self withPragmasIn: eachClass do: [ :pragma |
                    pragma keyword = aSymbol ifTrue: [ 
                        stream nextPut: pragma 
                    ] 
                ] 
            ] 
        ].

    "
     Annotation allNamed:'worldMenu'
    "
!

allNamed:aSymbol from:aSubClass to:aSuperClass
    "Answer a collection of all pragmas found in methods of all classes 
     between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol."
    
    ^ Array 
        streamContents:[:stream |
            aSubClass withAllSuperclassesDo:[:class |
                self withPragmasIn:class do:[:pragma |
                    pragma keyword = aSymbol ifTrue: [ 
                        stream nextPut: pragma 
                    ] 
                ].
                aSuperClass = class ifTrue: [ 
                    ^ stream contents 
                ] 
            ] 
        ].
!

allNamed: aSymbol from: aSubClass to: aSuperClass sortedByArgument: anInteger
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].
!

allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: aSortBlock
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol from: aSubClass to: aSuperClass) sort: aSortBlock.
!

allNamed: aSymbol in: aClass
    "Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol."
    
    ^ Array 
        streamContents: [ :stream |
            self withPragmasIn: aClass do: [ :pragma |
                pragma keyword = aSymbol ifTrue: [ 
                    stream nextPut: pragma 
                ] 
            ] 
        ].
!

allNamed: aSymbol in: aClass sortedByArgument: anInteger
	"Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol in: aClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].
!

allNamed: aSymbol in: aClass sortedUsing: aSortBlock
	"Answer a collection of all pragmas found in methods of aClass whose keyword is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol in: aClass) sort: aSortBlock.
! !

!Annotation class methodsFor:'private'!

keyword: aSymbol arguments: anArray
	^ self new
		setKeyword: aSymbol;
		setArguments: anArray;
		yourself.
!

withPragmasIn: aClass do: aBlock
        aClass selectorsAndMethodsDo: [ :selector :method | method annotationsDo: aBlock ].

    "Modified: / 20-08-2011 / 21:31:49 / cg"
! !

!Annotation methodsFor:'accessing'!

arguments
    ^ arguments
!

first

    ^self key

    "Created: / 10-07-2010 / 21:38:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

key
    ^ key
! !

!Annotation methodsFor:'accessing-method'!

method
        "Answer the compiled-method containing the pragma."
        
        self halt:'inimplemented'

    "Modified: / 21-08-2011 / 12:44:37 / cg"
!

methodClass
        "Answer the class of the method containing the pragma."
        
        ^ self method methodClass

    "Modified: / 21-08-2011 / 12:44:47 / cg"
!

methodSelector
        "Answer the selector of the method containing the pragma.
         Added to not confuse this with the selector (i.e. key) of the pragma's message pattern."
        
        ^ self method selector

    "Modified: / 21-08-2011 / 12:45:20 / cg"
!

selector
        "Answer the selector of the method containing the pragma.
         Do not confuse this with the selector (i.e. key) of the pragma's message pattern.
         (use methodSelector, to make this clear)"
        
        ^ self method selector

    "Modified: / 21-08-2011 / 12:45:20 / cg"
! !

!Annotation methodsFor:'accessing-pragma'!

argumentAt: anInteger
	"Answer one of the arguments of the pragma."
	
	^ self arguments at: anInteger.
!

argumentCount
    "Answer the number of arguments in the pragma."

    ^ self arguments size.
!

message
	"Answer the message of the receiving pragma."
	
	^ Message selector: self keyword arguments: self arguments. 
!

numArgs
	"Answer the number of arguments in the pragma."

	^ self arguments size.
! !

!Annotation methodsFor:'comparing'!

analogousCodeTo: anObject 
        ^self class == anObject class
          and: [self keyword == anObject keyword
          and: [self arguments = anObject arguments]]

    "Modified: / 21-08-2011 / 12:45:37 / cg"
! !

!Annotation methodsFor:'compatibility - squeak'!

keyword
    ^ self key

    "Created: / 05-09-2011 / 04:34:26 / cg"
! !

!Annotation methodsFor:'initialization'!

key:keyArg
    key := keyArg.
!

key:keyArg arguments:argumentsArg 
    key := keyArg.
    arguments := argumentsArg.
!

setArguments: anArray
    arguments := anArray

    "Modified: / 21-08-2011 / 12:45:51 / cg"
!

setKeyword: aSymbol
    key := aSymbol

    "Modified: / 21-08-2011 / 12:46:06 / cg"
!

setMethod: aCompiledMethod
        self subclassResponsibility

    "Modified: / 21-08-2011 / 12:46:16 / cg"
! !

!Annotation methodsFor:'printing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    self storeOn:aStream.

    "Modified: / 19-05-2010 / 16:25:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation methodsFor:'printing & storing'!

storeOn:aStream
    "superclass Annotation says that I am responsible to implement this method"

    aStream nextPutAll: '(Annotation key: '.
    key storeOn: aStream.
    aStream nextPutAll: ' arguments: '.
    arguments storeOn: aStream.
    aStream nextPut: $).

    "Modified: / 19-05-2010 / 16:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation methodsFor:'processing'!

annotatesClass: aClass

    ^self subclassResponsibility

    "Created: / 20-05-2010 / 11:15:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod: aMethod

    ^self subclassResponsibility

    "Created: / 20-05-2010 / 11:15:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendTo: anObject
	"Send the pragma keyword together with its arguments to anObject and answer the result."
	
	^ anObject perform: self keyword withArguments: self arguments
!

withArgumentsDo: aBlock
	"Pass the arguments of the receiving pragma into aBlock and answer the result."
	
	^ aBlock valueWithArguments: self arguments
! !

!Annotation methodsFor:'queries'!

refersToLiteral: anObject
    "return true if the receiver or recursively any array element in the
     receiver refers to aLiteral (i.e. a deep search)"

    (anObject == key) ifTrue:[ ^ true ].
    (anObject == arguments) ifTrue:[ ^ true ].
    arguments isArray ifTrue:[ ^ arguments refersToLiteral: anObject].
    ^ false

    "Created: / 26-07-2012 / 15:57:43 / cg"
!

refersToLiteralMatching: aMatchString
    (key isSymbol and:[aMatchString match:key])ifTrue:[ ^ true ].
    (arguments isSymbol and:[aMatchString match:arguments])ifTrue:[ ^ true ].
    arguments isArray ifTrue:[ ^ arguments refersToLiteralMatching: aMatchString].
    ^ false

    "Created: / 26-07-2012 / 16:00:58 / cg"
! !

!Annotation methodsFor:'testing'!

hasLiteral: aLiteral
        ^self keyword == aLiteral 
           or: [self arguments hasLiteral: aLiteral]

    "Modified: / 21-08-2011 / 12:46:44 / cg"
!

hasLiteralSuchThat: aBlock
        "Answer true if litBlock returns true for any literal in the receiver, even if embedded in further array structure.
         This method is only intended for private use by CompiledMethod hasLiteralSuchThat:"
        ^(aBlock value: self keyword)
           or: [self arguments hasLiteralSuchThat: aBlock]

    "Modified: / 21-08-2011 / 12:46:31 / cg"
!

isResource
    ^ false

    "Created: / 18-07-2012 / 19:28:39 / cg"
!

isUnknown
    ^ false
! !

!Annotation::NameSpace methodsFor:'accessing'!

key

    ^#namespace:

    "Created: / 19-05-2010 / 16:23:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpace
    ^ arguments first
!

nameSpace:something
    arguments := Array with:something.
! !

!Annotation::NameSpace methodsFor:'initialization'!

nameSpaceName: aString

    self nameSpace: (NameSpace name: aString)

    "Created: / 19-05-2010 / 16:02:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation::NameSpace methodsFor:'printing & storing'!

storeOn:aStream
    "superclass Annotation says that I am responsible to implement this method"

    aStream nextPutAll: '(Annotation namespace: '.
    self nameSpace name storeOn: aStream.
    aStream nextPut:$)

    "Modified: / 19-05-2010 / 16:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation::NameSpace methodsFor:'processing'!

annotatesClass:aClass

    "Nothing to do"

    "Modified: / 20-05-2010 / 11:16:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod:aMethod

    aMethod lookupObject: NamespaceAwareLookup instance

    "Modified: / 20-05-2010 / 11:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation::Resource methodsFor:'accessing'!

type
    ^ arguments at:1
!

type:typeArg value:valueArg
    valueArg isNil ifTrue:[
        key := #'resource:'.
        arguments := Array with:typeArg.
    ] ifFalse:[
        key := #'resource:values:'.
        arguments := Array with:typeArg with:valueArg.
    ].
!

value
    arguments size > 1 ifTrue:[
        ^ arguments at:2
    ].
    ^ nil
! !

!Annotation::Resource methodsFor:'printing & storing'!

storeOn:aStream
    aStream nextPutAll: '(Annotation resource: '.
    self type storeOn: aStream.
    self value notNil ifTrue: [
        aStream nextPutAll: ' value: '.
        self value storeOn: aStream
    ].    
    aStream nextPut:$)

    "Modified: / 16-07-2010 / 11:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:19:06 / cg"
    "Modified (format): / 26-07-2012 / 15:59:14 / cg"
! !

!Annotation::Resource methodsFor:'processing'!

annotatesClass:aClass

    "Nothing to do"

    "Modified: / 16-07-2010 / 11:28:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod:aMethod

    "Nothing to do"

    "Modified: / 16-07-2010 / 11:28:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation::Resource methodsFor:'testing'!

isResource
    ^ true

    "Created: / 18-07-2012 / 19:28:46 / cg"
! !

!Annotation::Unknown methodsFor:'accessing'!

method
    ^ method

    "Created: / 05-09-2011 / 04:38:33 / cg"
!

setMethod:aMethod
    method := aMethod

    "Created: / 05-09-2011 / 04:38:33 / cg"
! !

!Annotation::Unknown methodsFor:'initialization'!

method:methodArg key:keyArg arguments:argumentsArg
    method := methodArg.
    key := keyArg.
    arguments := argumentsArg.

    "Created: / 05-09-2011 / 04:39:50 / cg"
! !

!Annotation::Unknown methodsFor:'processing'!

annotatesClass:aClass

    "Nothing to do"

    "Modified: / 20-05-2010 / 11:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod:aMethod

    "Nothing to do"

    "Modified: / 20-05-2010 / 11:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Annotation::Unknown methodsFor:'queries'!

refersToLiteral: anObject
    (anObject == method) ifTrue:[ ^ true ].
    ^ super refersToLiteral: anObject
!

refersToLiteralMatching: aMatchString
    (method isSymbol and:[aMatchString match:method])ifTrue:[ ^ true ].
    ^ super refersToLiteralMatching: aMatchString

    "Created: / 26-07-2012 / 16:00:58 / cg"
! !

!Annotation::Unknown methodsFor:'testing'!

isUnknown
    ^ true
! !

!Annotation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


Annotation initialize!
