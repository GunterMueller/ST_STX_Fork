"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

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
"{ Package: 'stx:libjava/experiments' }"

Java subclass:#JavaMethodWrapperCompiler
	instanceVariableNames:'method source'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Experiments-Lookup'
!

!JavaMethodWrapperCompiler class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

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
    Helper class responsible for compiling wrapper methods
    that wraps/unwraps java methods. It compiles both,
    wrappers callable from smalltalk that calls Java method
    and vice versa. For details, refer documentation in
    #compileSmalltalk:toJava: and #compileJava:toSmalltalk:

    NOTE: Experimental.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        method      a __JAVA__ for which to compile a
                    wrapper.

    [class variables:]

    [see also:]

"
! !

!JavaMethodWrapperCompiler class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaMethodWrapperCompiler methodsFor:'accessing'!

method
    ^ method
!

method:aJavaMethod

    self assert: aJavaMethod isJavaMethod
         description:'Not a Java method'.
    method := aJavaMethod.

    "Modified: / 25-11-2011 / 20:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler methodsFor:'coding'!

codeArgument: index descriptor: descriptor 

    "Code one argument, whose type is described by
     a descriptor"

    | nm |
    nm := descriptor javaClassName asSymbol.
    nm == #'java.lang.Byte' ifTrue:[
        self code:'(JavaByte javaBox: arg%1) .' with: index.
        self codeCR.
        ^self.
    ].
    nm == #'java.lang.Short' ifTrue:[
        self code:'(JavaShort javaBox: arg%1) .' with: index.
        self codeCR.
        ^self.
    ].
    nm == #'java.lang.Integer' ifTrue:[
        self code:'(Integer javaBox: arg%1) .' with: index.
        self codeCR.
        ^self.
    ].
    nm == #'java.lang.Long' ifTrue:[
        self code:'(LargeInteger javaBox: arg%1) .' with: index.
        self codeCR.
        ^self.
    ].
    nm == #'java.lang.Character' ifTrue:[
        self code:'(Character javaBox: arg%1) .' with: index.
        self codeCR.
        ^self.
    ].
    nm == #'java.lang.Boolean' ifTrue:[
        self code:'(Boolean javaBox: arg%1) .' with: index.
        self codeCR.                    
        ^self.
    ].
    nm == #'LargeInteger' ifTrue:[
        "long occupies two slots"
        self code:'(arg%1) . nil .'.
        self codeCR.
        ^self.        
    ].
    nm == #'Float' ifTrue:[
        "long occupies two slots"
        self code:'(arg%1) . nil .'.
        self codeCR.
        ^self.        
    ].
    self code:'(arg%1) .'.

    "Created: / 25-11-2011 / 23:36:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeArgumentTypeCheck: index descriptor: descriptor 

    self code:'"/ typecheck for arg%1 type %2' with: index with: descriptor javaClassName.
    self code:'(JavaVM canCast: arg%1 class to: (JavaVM classForName: #''%2'') ifFalse:['
            with: index with: descriptor javaClassName.
    self codeTab; code: 'self error:''Invalid argument type''.^nil'.
    self code: ']'.
    self codeCRCR.

    "Created: / 25-11-2011 / 23:10:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeMethodHeader: selector

    selector isUnarySelector ifTrue:[
        self code: selector.
    ] ifFalse:[
        selector keywords withIndexDo:[:kw :i|
            self code: '%1: arg%2' with: kw with: i.
        ].
    ].
    source cr; cr.

    "Created: / 25-11-2011 / 20:38:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler methodsFor:'coding-helpers'!

code: string

    source nextPutAll: string

    "Created: / 25-11-2011 / 20:42:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

code: string with: arg

    source nextPutAll: (string bindWith: arg)

    "Created: / 25-11-2011 / 20:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

code: string with: arg1 with: arg2

    source nextPutAll: (string bindWith: arg1 with: arg2)

    "Created: / 25-11-2011 / 20:42:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

code: string with: arg1 with: arg2 with: arg3

    source nextPutAll: (string bindWith: arg1 with: arg2 with: arg3)

    "Created: / 25-11-2011 / 20:42:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

code: string with: arg1 with: arg2 with: arg3 with: arg4

    source nextPutAll: (string bindWith: arg1 with: arg2 with: arg3 with: arg4)

    "Created: / 25-11-2011 / 20:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCR

    source cr

    "Created: / 25-11-2011 / 20:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeCRCR

    source cr; cr.

    "Created: / 25-11-2011 / 20:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeTab

    source tab

    "Created: / 25-11-2011 / 20:47:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler methodsFor:'compiling'!

compileJava: javaSelector toSmalltalk: smalltalkSelector

    "Created: / 25-11-2011 / 20:09:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileSmalltalk: smalltalkSelector toJava: javaSelector

    "Compiles a method with smalltalk selector that calls
     java method is java object.

    Compiled method looks like:
    1) check the type of each argument, if they do not
       match, throw an error (for now, we can be smarter)
    2) box each argument, if neccessary
    3) self-send javaSelector
    4) unbox the return value (if it returns a wrapper object)
    "

    | mdescriptor |
    mdescriptor := method descriptor.

    self codeMethodHeader: smalltalkSelector.
    self code:'| retval |'; codeCRCR.
    "/code type checks
    mdescriptor parameters withIndexDo:[:descriptor :index|
        self codeArgumentTypeCheck: index descriptor: descriptor.        
    ].

    "/code self send with inlined boxing
    self code:'retval := self'; codeCR.
    self codeTab; code:'perform: '; code: javaSelector asSymbol storeString; codeCR.
    smalltalkSelector isUnarySelector ifFalse:[
        self codeTab; code: 'withArguments: { '; codeCR.
        mdescriptor parameters withIndexDo:[:descriptor :index|
            self codeArgument: index descriptor: descriptor.
        ].
        self codeTab; code: '}'.
    ].
    self code:'.'; codeCR.
    "TODO: Should code unbox here..."
    self code:'^ retval'.

    ^self compile

    "Created: / 25-11-2011 / 20:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler methodsFor:'compiling-private'!

compile

    "Actually compiles the source"

    self halt:'Not yet implemented'

    "Created: / 25-11-2011 / 20:25:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ method := nil.
    source := (String new: 100) writeStream.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 25-11-2011 / 20:24:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWrapperCompiler class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/JavaMethodWrapperCompiler.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

