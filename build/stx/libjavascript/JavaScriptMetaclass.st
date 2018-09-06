"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Metaclass subclass:#JavaScriptMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

!JavaScriptMetaclass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptMetaclass class methodsFor:'class creation'!

classTemplateFor:aSuperClass in:categoryString asNamespace:asNameSpace private:isPrivateWanted    
    ^ String streamContents:[:s |
        isPrivateWanted ifTrue:[
            s nextPutAll:'private '.
        ] ifFalse:[
            s nextPutAll:'public '.
        ].
        s nextPutLine:'class NewClass '.
        s nextPutAll:'extends '.
        s nextPutLine:aSuperClass name.

        s nextPutAll:'{'.
        s cr.

        s tab; nextPutLine:'static var Static1, Static2;'.
        s tab; nextPutLine:'var var1, var2;'.
        s tab; nextPutLine:'var var3;'.

        s nextPutAll:'}'.
        s cr.
     ]

    "Modified: / 30-01-2011 / 17:21:51 / cg"
! !

!JavaScriptMetaclass class methodsFor:'creating classes'!

new
    "creating a new metaclass - have to set the new classes
     flags correctly to have it behave like a metaclass ...
     Not for normal applications - creating new metaclasses is a very
     tricky thing; should be left to the gurus ;-)"

    |newMetaclass|

    newMetaclass := super new.
    newMetaclass instSize:(JavaScriptClass instSize).
    newMetaclass setSuperclass:JavaScriptClass.

    ^ newMetaclass
! !

!JavaScriptMetaclass methodsFor:'compiler interface'!

programmingLanguage
    self = JavaScriptClass ifTrue:[
        "/ me myself, I am written in Smalltalk !!
        ^ super programmingLanguage
    ].
    ^ STXJavaScriptLanguage instance
!

realSubclassDefinerClass
    ^ JavaScriptCompiler
!

subclassDefinerClass
    self == JavaScriptMetaclass ifTrue:[
        ^ super subclassDefinerClass
    ].
    ^ JavaScriptCompiler
! !

!JavaScriptMetaclass methodsFor:'fileOut'!

basicFileOutDefinitionOf:aClass on:aStream withNameSpace:forceNameSpace withPackage:showPackage 
    "append an expression on aStream, which defines myself."

    |inits|

"/    self == JavaScriptClass ifTrue:[
"/        ^ super basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage
"/    ].

"/    aStream nextPutLine:'// '.
"/    aStream nextPutLine:'// @category ' , aClass category.
"/    aStream nextPutLine:'// '.
    aStream nextPutAll:'public class '.
    aStream nextPutAll:aClass name.
    aStream nextPutAll:' extends '.
    aStream nextPutAll:aClass superclass name.
    aStream cr.

    aStream nextPutLine:'{'.

    aClass classVarNames do:[:eachVarName |
        |val|

        aStream 
            tab; 
            nextPutAll:'static var '; nextPutAll:eachVarName.
        (val := aClass classVarAt:eachVarName) notNil ifTrue:[
            aStream nextPutAll:' = '.
            "number or string!!"
            val isString ifTrue:[
                aStream nextPutAll: ('"',(val withCEscapes),'"')
            ] ifFalse: [
                "/ make sure that array literals are printed in JS syntax
                (JavaScriptConstantNode value:val)
                    printOn:aStream 
                    indent:('static var ' size + eachVarName size + ' = ' size).
"/                aStream nextPutAll:(val storeString)
            ].
        ].
        aStream 
            nextPutLine:';'.
    ].

    inits := Dictionary new.

    (aClass includesSelector:#'__initialize__') ifTrue:[
        |initMthdSource tree|

        "/ sigh - parse it for the initializers
        initMthdSource := aClass sourceCodeAt:#'__initialize__'.
        Error handle:[:ex |
        ] do:[
            Warning ignoreIn:[:ex |
                tree := JavaScriptParser parseFunction:initMthdSource in:aClass.
            ].
        ].
        tree notNil ifTrue:[
            tree statements do:[:eachStatement |
                |var expr|

                (eachStatement isExpressionStatement 
                and:[eachStatement expression isAssignment]) ifTrue:[
                    var := eachStatement expression variable name.
                    expr := eachStatement expression expression.
                    inits at:var put:expr.
                ].
            ].
        ].
    ].

    aClass instVarNames do:[:eachVarName |
        |initExpr|

        aStream tab; nextPutAll:'var '; nextPutAll:eachVarName.
        (initExpr := inits at:eachVarName ifAbsent:nil) notNil ifTrue:[
            aStream nextPutAll:' = '.
            "/ make sure that array literals are printed in JS syntax
            initExpr printOn:aStream indent:(8 + 'var ' size + eachVarName size + ' = ' size).
        ].
        aStream nextPutLine:';'.
    ].
    aStream nextPutLine:'}'.

    "Modified: / 16-07-2012 / 20:40:22 / cg"
!

fileOutAllDefinitionsOn:aStream
    "append expressions on aStream, which defines myself and all of my private classes."

    myClass fileOutDefinitionOn:aStream.
    aStream cr; cr.

    "/
    "/ optional classInstanceVariables
    "/
    self instanceVariableString isBlank ifFalse:[
        myClass fileOutClassInstVarDefinitionOn:aStream.
        aStream cr; cr
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc 
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:false do:[
        Class forceNoNameSpaceQuerySignal answer:true do:[
            myClass privateClassesSorted do:[:aClass |
                 myClass class fileOutAllDefinitionsOn:aStream
            ]
        ]
    ].

    "Created: / 15-10-1996 / 11:15:19 / cg"
    "Modified: / 19-05-2010 / 16:05:38 / cg"
!

fileOutClassInstVarDefinitionOn:aStream withNameSpace:withNameSpace
!

fileOutOn:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    JavaScriptSourceFileWriter new
        fileOut:self on:outStreamArg 
        withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition 
        methodFilter:methodFilter encoder:encoderOrNil
! !

!JavaScriptMetaclass methodsFor:'queries'!

isJavaScriptMetaclass
        ^ true
!

nameInBrowser
    "return a nameString as shown in browsers"

    ^ (self name ? '_') , '()'

    "Modified: / 22-05-2017 / 13:34:41 / stefan"
! !

!JavaScriptMetaclass methodsFor:'source management'!

sourceFileSuffix
    ^ 'js'
! !

!JavaScriptMetaclass methodsFor:'ui support'!

iconInBrowserSymbol
    <resource: #programImage>

    self == JavaScriptClass ifTrue:[^ super iconInBrowserSymbol].
    ^ #javascriptClassBrowserIcon

    "Created: / 22-08-2012 / 19:38:08 / cg"
! !

!JavaScriptMetaclass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptMetaclass.st,v 1.23 2017-05-23 10:34:45 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptMetaclass.st,v 1.23 2017-05-23 10:34:45 stefan Exp $'
! !

