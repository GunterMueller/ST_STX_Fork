"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

Object subclass:#XDRParser
	instanceVariableNames:'scanner tokenType token interfaces types defines consts programs
		definitionContextStack ignoreRedefinitions anonymousTypes
		currentEnumDefinitionList importedFiles currentFileName
		importPath constValueType'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'Net-Communication-SunRPC-XDR_IDL'
!

!XDRParser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    parser for SunRPC XDR IDL declarations.

    creates a list of XDRIDLTypes

    [author:]
        Claus Gittinger

    [see also:]
        CParser CType
        IDLType IDLDatum
        XDRIDLType
"

    "Created: / 13.5.1998 / 14:54:06 / cg"
!

examples
"
  parsing a single declaration:
  (inspect and look at types, etc.)
                                                                [exBegin]
    |parser|

    parser := XDRParser parse:'

         const PMAP_PORT = 111;      /* portmapper port number */

         const IPPROTO_TCP = 6;      /* protocol number for TCP/IP */
         const IPPROTO_UDP = 17;     /* protocol number for UDP/IP */

         struct mapping {
            unsigned int prog;
            unsigned int vers;
            unsigned int prot;
            unsigned int port;
         };

         struct *pmaplist {
            mapping map;
            pmaplist next;
         };

         struct call_result {
            unsigned int port;
            opaque res<>;
         };

         struct call_args {
            unsigned int prog;
            unsigned int vers;
            unsigned int proc;
            opaque args<>;
         };

         program PMAP_PROG {
            version PMAP_VERS {
               void
               PMAPPROC_NULL(void)         = 0;

               bool
               PMAPPROC_SET(mapping)       = 1;

               bool
               PMAPPROC_UNSET(mapping)     = 2;

               unsigned int
               PMAPPROC_GETPORT(mapping)   = 3;

               pmaplist
               PMAPPROC_DUMP(void)         = 4;

               call_result
               PMAPPROC_CALLIT(call_args)  = 5;
            } = 2;
         } = 100000;
    '
                                                                [exEnd]
"

    "Created: / 13.5.1998 / 14:54:06 / cg"
! !

!XDRParser class methodsFor:'initialization'!

initialize
    "need this to autoload XDRIDLType (since its private classes are not autoloaded...)"

    XDRType notNil ifTrue:[XDRType autoload].
    super initialize.

    "Created: / 21.12.2001 / 22:40:41 / cg"
! !

!XDRParser class methodsFor:'instance creation'!

for:aStringOrStream
    "create & return a new cparser reading from aStringOrStream"

    ^ self basicNew initializeFor:aStringOrStream

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

new    
    "create & return a new cparser"

    ^ self basicNew initialize.

    "Created: / 21.12.2001 / 22:40:41 / cg"
! !

!XDRParser class methodsFor:'parsing'!

parse:aStringOrStream
    "parse declarations and defines.
     Return the parser (which can be asked for types and defines)."

    ^ self parse:aStringOrStream withDefines:nil types:nil

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parse:aStringOrStream withDefines:defines
    "parse declarations and defines.
     Return the parser (which can be asked for types and defines)."

    ^ self parse:aStringOrStream withDefines:defines types:nil

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parse:aStringOrStream withDefines:defines types:types
    "parse declarations and defines.
     Return the parser (which can be asked for types and defines)."

    |parser|

    parser := self for:aStringOrStream.
    defines notNil ifTrue:[parser defines:defines].
    types notNil ifTrue:[parser types:types].
    parser nextToken.

    parser definitions.
    ^ parser

    "Modified: / 15.5.1998 / 21:07:18 / cg"
    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parse:aStringOrStream withTypes:types
    "parse declarations and types.
     Return the parser (which can be asked for types and defines)."

    ^ self parse:aStringOrStream withDefines:nil types:types

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parseDefinition:aStringOrStream
    "parse a single definition.
     Return a single type."

    |parser types|

    parser := self for:aStringOrStream.
    parser nextToken.

    parser definition.
    types := parser types.
    types size ~~ 1 ifTrue:[
        self error:'given code must contain exactly one declaration'.
        ^ nil.
    ].
    ^ types first

    "Modified: / 15.5.1998 / 21:07:18 / cg"
    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parsePrograms:aStringOrStream
    "parse a single definition.
     Return a single type."

    |parser|

    parser := self parse:aStringOrStream.
    ^ parser programs

    "Modified: / 15.5.1998 / 21:07:18 / cg"
    "Created: / 21.12.2001 / 22:40:41 / cg"
! !

!XDRParser class methodsFor:'parsing-expressions'!

integerExpression:aStringOrStream
    "parse an integer expression ..
     Return the integer value or raise an error"

    ^ self parseIntegerExpression:aStringOrStream withDefines:nil

    "
     CParser integerExpression:'(0x8000 | 0x7FFF)' 
     CParser integerExpression:'(0x8000 - 1)'
    "

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

integerExpression:aStringOrStream withDefines:defines
    "parse an integer expression ..
     Return the integer value or raise an error"

    ^ self parseIntegerExpression:aStringOrStream withDefines:defines

    "
     |defines|

     defines := Dictionary new.
     defines at:'VAL1' put:'0x100'.
     defines at:'VAL2' put:'0x200'.
     CParser integerExpression:'(VAL1 + VAL2 - 1)' withDefines:defines   
    "

    "
     |defines|

     defines := Dictionary new.
     defines at:'VAL1' put:'0x100 // MAGIC 1'.
     defines at:'VAL2' put:'0x200 // MAGIC 2'.
     CParser integerExpression:'(VAL1 + VAL2 - 1)' withDefines:defines
    "

    "
     |parser defines|

     parser := CParser parse:'
#define FOO 0xFF00
#define BAR 1
'.
     defines := parser defines.
     CParser integerExpression:'FOO | BAR' withDefines:defines.
    "

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parseIntegerExpression:aStringOrStream
    "parse an integer expression ..
     Return the integer value or raise an error"

    ^ self parseIntegerExpression:aStringOrStream withDefines:nil

    "
     CParser parseIntegerExpression:'(0x8000 | 0x7FFF)' 
     CParser parseIntegerExpression:'(0x8000 - 1)'
    "

    "Created: / 21.12.2001 / 22:40:41 / cg"
!

parseIntegerExpression:aStringOrStream withDefines:defines
    "parse an integer expression ..
     Return the integer value or raise an error"

    ^ self parse:aStringOrStream withDefines:defines

    "
     |defines|

     defines := Dictionary new.
     defines at:'VAL1' put:'0x100'.
     defines at:'VAL2' put:'0x200'.
     CParser integerExpression:'(VAL1 + VAL2 - 1)' withDefines:defines   
    "

    "
     |defines|

     defines := Dictionary new.
     defines at:'VAL1' put:'0x100 // MAGIC 1'.
     defines at:'VAL2' put:'0x200 // MAGIC 2'.
     CParser integerExpression:'(VAL1 + VAL2 - 1)' withDefines:defines
    "

    "
     |parser defines|

     parser := CParser parse:'
#define FOO 0xFF00
#define BAR 1
'.
     defines := parser defines.
     CParser integerExpression:'FOO | BAR' withDefines:defines.
    "

    "Created: / 21.12.2001 / 22:40:41 / cg"
! !

!XDRParser methodsFor:'accessing'!

anonymousTypes
    "return the collection of anonymousTypes (after parsing).
     These are embedded types in structs/unions or enums without type-def.
     (maybe useful to get an anonymous enums value)"

    ^ anonymousTypes

    "Created: / 21.12.2001 / 22:40:38 / cg"
!

constants
    "return the collection of constants (after parsing)"

    ^ consts

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 22.12.2001 / 03:21:50 / cg"
!

constants:aDictionary
    "set the collection of constants (before parsing).
     Use this to start parsing with some predefined values
     (i.e. like compiling with -Dfoo=value)"

    consts := aDictionary

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 22.12.2001 / 03:22:09 / cg"
!

defines
    "return the collection of defines (after parsing)"

    ^ defines

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 21.12.2001 / 22:40:38 / cg"
!

defines:aDictionary
    "set the collection of defines (before parsing).
     Use this to start parsing with some predefined values
     (i.e. like compiling with -Dfoo=value)"

    defines := aDictionary

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 21.12.2001 / 22:40:38 / cg"
!

programs
    "return the collection of programs (after parsing)"

    ^ programs

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 22.12.2001 / 03:21:50 / cg"
!

types
    "return the collection of types (after parsing)"

    ^ types

    "Modified: / 15.5.1998 / 21:25:07 / cg"
    "Created: / 21.12.2001 / 22:40:38 / cg"
!

types:aDictionary
    "set the collection of types (before parsing) - useful to parse more"

    types := aDictionary

    "Created: / 21.12.2001 / 22:40:38 / cg"
! !

!XDRParser methodsFor:'accessing behaviour'!

ignoreRedefinitions
    ^ ignoreRedefinitions

    "Created: / 21.12.2001 / 22:40:38 / cg"
!

ignoreRedefinitions:aState
    ignoreRedefinitions := aState

    "Created: / 21.12.2001 / 22:40:38 / cg"
! !

!XDRParser methodsFor:'error handling'!

parseError:msg
    "a parse error occurred"

    |errMsg fileName|

    fileName := currentFileName.
    fileName isNil ifTrue:[
        scanner source isFileStream ifTrue:[
            fileName := scanner source pathName
        ] ifFalse:[
            fileName := 'in'
        ]
    ].

    errMsg := 'Parse Error [%1:%2]: ' , msg.
    errMsg := errMsg bindWith:fileName with:scanner lineNumber printString.

    self error:errMsg
! !

!XDRParser methodsFor:'initialization'!

initKnownTypes
"/    types 
"/        at:#unsigned32
"/        put:(IDLType unsignedIntType new).
"/
"/    types
"/        at:#'handle_t'
"/        put:(IDLType pointerType new
"/                name:#'handle_t';
"/                baseType:IDLType voidType new).
"/
"/    types
"/        at:#'uuid_t'
"/        put:(IDLType uuidType new
"/                name:#'uuid_t').
!

initialize
    super initialize.

    importedFiles := OrderedCollection new.

    interfaces := OrderedCollection new.

    programs := Dictionary new.
    types := Dictionary new.
    consts := Dictionary new.

    anonymousTypes := OrderedCollection new.

"/    defines isNil ifTrue:[
"/        defines := Dictionary new.
"/    ].
    ignoreRedefinitions := false.

    self initKnownTypes.

    "Modified: / 22.12.2001 / 16:53:03 / cg"
!

initializeFor:aStringOrStream
    "initialize the new scanner & prepare for reading from aStringOrStream"

    self initialize.
    scanner := self scannerClass for:aStringOrStream.

    "Created: / 21.12.2001 / 22:40:38 / cg"
    "Modified: / 21.12.2001 / 22:50:37 / cg"
!

readSource:aStringOrStream
    "prepare for reading from aStringOrStream,
     but do not reinitialize"

    scanner newSource:aStringOrStream.
    self nextToken.

    "Created: / 22.12.2001 / 04:28:17 / cg"
    "Modified: / 22.12.2001 / 04:28:31 / cg"
!

scannerClass
    ^ XDRScanner

    "Created: / 21.12.2001 / 22:40:38 / cg"
    "Modified: / 21.12.2001 / 22:50:08 / cg"
! !

!XDRParser methodsFor:'parsing'!

builtInType
    "builtInType := 
             [unsigned] int
             | [unsigned] hyper
             | [unsigned] long
             | float
             | double
             | bool
    "

    |isUnsigned|

    isUnsigned := false.

    tokenType == #unsigned ifTrue:[
        isUnsigned := true.
        self nextToken.
    ].
    tokenType == #int ifTrue:[
        self nextToken.
        isUnsigned ifTrue:[
            ^ XDRType unsignedIntType new
        ].
        ^ XDRType intType new
    ].
    tokenType == #hyper ifTrue:[
        self nextToken.
        isUnsigned ifTrue:[
            ^ XDRType unsignedHyperType new
        ].
        ^ XDRType hyperType new
    ].
    tokenType == #long ifTrue:[
        self nextToken.
        isUnsigned ifTrue:[
            ^ XDRType unsignedLongType new
        ].
        ^ XDRType longType new
    ].
    tokenType == #short ifTrue:[
        self nextToken.
        isUnsigned ifTrue:[
            ^ XDRType unsignedShortType new
        ].
        ^ XDRType shortType new
    ].
    tokenType == #char ifTrue:[
        self nextToken.
        isUnsigned ifTrue:[
            ^ XDRType unsignedCharType new
        ].
        ^ XDRType charType new
    ].

    tokenType == #bool ifTrue:[
        isUnsigned ifTrue:[
            self parseError:'''unsigned'' only valid with int or hyper types'.
        ].
        self nextToken.
        ^ XDRType booleanType new
    ].

    tokenType == #float ifTrue:[
        isUnsigned ifTrue:[
            self parseError:'''unsigned'' only valid with int or hyper types'.
        ].
        self nextToken.
        ^ XDRType floatType new
    ].

    tokenType == #double ifTrue:[
        isUnsigned ifTrue:[
            self parseError:'''unsigned'' only valid with int or hyper types'.
        ].
        self nextToken.
        ^ XDRType doubleType new
    ].

    tokenType == #void ifTrue:[
        isUnsigned ifTrue:[
            self parseError:'''unsigned'' only valid with int or hyper types'.
        ].
        self nextToken.
        ^ XDRType voidType new
    ].

    isUnsigned ifTrue:[
        ^ XDRType unsignedIntType new
    ].

    self parseError:'int, char, float or double expected (got ''' , tokenType printString , ''')'.
    ^ #Error
!

compoundType
    "compoundType := 
        'struct' <optional_name> '{' field_list '}'
        'union'  <optional_name> '{' field_list '}'
        'enum'  <optional_name> '{' field_list '}'
    "

    |typeName fields type|

    (tokenType == #enum) ifTrue:[
        self nextToken.
        typeName := self expectIdentifier.
        typeName := typeName asSymbol.
        fields := self enumBody.
        type := XDRType enumType new.
        type name:typeName.
        type fields:fields.
        self declareType:type name:typeName.
        ^ type
    ].
    (tokenType == #struct) ifTrue:[
        self nextToken.
        type := XDRType structType new.

        (tokenType == $*) ifTrue:[
            self nextToken.
            type := XDRType optionalType new type:type.
        ].

        tokenType == #Identifier ifTrue:[
            typeName := self expectIdentifier.
            typeName := typeName asSymbol.
            type name:typeName.
        ].

        self declareType:type name:typeName.

        type fields:(self structBody).
        ^  type
    ].
    (tokenType == #union) ifTrue:[
        self nextToken.
        typeName := self expectIdentifier.
        typeName := typeName asSymbol.
        type := XDRType unionType new.
        type name:typeName.
        self declareType:type name:typeName.
        type fields:(self unionBodyFor:type).
        ^  type
    ].
    self parseError:'struct, union or enum expected'.
!

constant
    ^  self expression
!

constantDef
    | constName constValue|

    self expect:#const.

    constName := self expectIdentifier.
    self expect:$=.

    constValue := self constant.

    constValue isInteger ifFalse:[
        self parseError:('const must be integer')
    ].

    "/ constValue := IDLDatum new type:type data:constValue.

    (consts includesKey:constName) ifTrue:[
        self parseError:('redefinition of ' , constName)
    ].
    consts at:constName put:constValue.
    self expect:$;.

    "Created: / 22.12.2001 / 03:16:57 / cg"
    "Modified: / 22.12.2001 / 11:45:12 / cg"
!

declaration
    |isOptional isString isOpaque name type|

    tokenType == #void ifTrue:[
        self nextToken.
        ^ XDRType field new
            type:(XDRType voidType new)
    ].

    isOpaque := isString := isOptional := false.
    tokenType == #opaque ifTrue:[
        isOpaque := true.
        self nextToken.
        type := XDRType opaqueType new.
    ] ifFalse:[
        tokenType == #string ifTrue:[
            isString := true.
            self nextToken.
            type := XDRType stringType new.
        ] ifFalse:[
            type := self typeSpecifier.
            (tokenType == $*) ifTrue:[
                self nextToken.
                type := XDRType optionalType new type:type.
                isOptional := true.
            ].
        ]
    ].

    name := self expectIdentifier.

    tokenType == $[ ifTrue:[
        isOptional ifTrue:[
            self parseError:'''*'' not allowed with []'.
        ].
        isString ifTrue:[
            self parseError:'''[]'' not allowed with string type'.
        ].
        (isString or:[isOpaque]) ifFalse:[
            type := (XDRType arrayType new) elementType:type.
        ].
        self nextToken.
        tokenType ~~ $] ifTrue:[
            type dimension:(self parseValue).
        ].
        self expect:$].
    ] ifFalse:[
        tokenType == $< ifTrue:[
            isOptional ifTrue:[
                self parseError:'''*'' not allowed with <>'.
            ].
            (isString or:[isOpaque]) ifFalse:[
                type := (XDRType arrayType new) elementType:type.
            ].
            self nextToken.
            tokenType ~~ $> ifTrue:[
                type maxSize:(self parseValue).
            ].
            self expect:$>.
        ] ifFalse:[
            (isString or:[isOpaque]) ifTrue:[
                self parseError:'dimension or maxSize required'.
            ]
        ]
    ].
    ^ XDRType field new
        type:type; name:name
!

definition
    tokenType == #program ifTrue:[
        self programDef.
        ^  self.
    ].

    tokenType == #const ifTrue:[
        self constantDef.
        ^  self.
    ].
    self typeDef.
!

definitions
    [tokenType ~~ #EOF] whileTrue:[
        self definition.
    ].

    "Created: / 21.12.2001 / 23:00:24 / cg"
!

enumBody
    "fieldList := enumItem
                  | enumList enumItem"

    |fields enumName enumValue nextEnumValue field stillParsing|

    fields := OrderedCollection new.
    nextEnumValue := 0.

    self expect:${.
    stillParsing := true.
    [stillParsing] whileTrue:[
        enumName := self expectIdentifier.
        tokenType == $= ifTrue:[
            self expect:$=.
            enumValue := self parseValue.
        ] ifFalse:[
            enumValue := nextEnumValue.
        ].
        field := XDRType enumItem new 
                        name:(enumName asSymbol) enumValue:enumValue.
        fields add:field.
        tokenType == $, ifTrue:[
            self nextToken.
        ] ifFalse:[     
            stillParsing := false
        ].
        nextEnumValue := enumValue + 1.
    ].

    self expect:$}.
    ^ fields.
!

parseValue
    ^ self constant.
!

procedureDef
    |procedure pocedureName argType argTypes|

    procedure := XDRProcedure new.

    procedure type:(self typeSpecifier).
    pocedureName := self expectIdentifier.
    procedure name:pocedureName.
    self expect:$(.

    argTypes := OrderedCollection new.

    argType := self typeSpecifier.
    argType isXDRVoid ifTrue:[
        self expect:$).
    ] ifFalse:[
        procedure arguments:argTypes.
        argTypes add:argType.

        [ tokenType ~~ $) ] whileTrue:[
            self expect:$,.
            argTypes add:( self typeSpecifier ).
        ].

        self nextToken.
    ].
    self expect:$=.
    procedure number:(self constant).
    self expect:$;.
    ^ procedure
!

programDef
    |progName prog versions version|

    self expect:#program.
    progName := self expectIdentifier.
    prog := XDRProgram new.
    prog name:progName.        
    versions := Dictionary new.
    prog versions:versions.

    self expect:${.

    [ tokenType ~~ $} ] whileTrue:[
        version := (self versionDef).
        versions at:version name put:version.
    ].

    self nextToken.
    self expect:$=.
    prog programNumber:( self constant ).
    self expect:$;.

    programs at:progName put:prog.
!

structBody
    |fields|

    fields := OrderedCollection new.
    self expect:${.

    [
        fields add:(self declaration).
        self expect:$;.
    ] doWhile:[
        tokenType ~~ $}
    ].
    self nextToken.
    ^ fields
!

typeDef
    |typeName type fields decl|

    tokenType == #typedef ifTrue:[
        self nextToken.
        decl := self declaration.
        self expect:$;.
        self declareType:decl type name:decl name.
        ^  self.
    ].

    (tokenType == #enum) ifTrue:[
        self nextToken.
        typeName := self expectIdentifier.
        typeName := typeName asSymbol.
        fields := self enumBody.
        self expect:$;.
        type := XDRType enumType new.
        type name:typeName.
        type fields:fields.
        self declareType:type name:typeName.
        ^  self
    ].
    (tokenType == #struct) ifTrue:[
        self nextToken.
        type := XDRType structType new.

       (tokenType == $*) ifTrue:[
            type := XDRType optionalType new type:type.
            self nextToken.
        ].
        typeName := self expectIdentifier.
        typeName := typeName asSymbol.
        type name:typeName.

        self declareType:type name:typeName.

        type fields:(self structBody).
        self expect:$;.
        ^  self
    ].
    (tokenType == #union) ifTrue:[
        self nextToken.
        typeName := self expectIdentifier.
        typeName := typeName asSymbol.
        type := XDRType unionType new.
        type name:typeName.
        self declareType:type name:typeName.
        type fields:(self unionBodyFor:type).
        self expect:$;.
        ^  self
    ].

    self parseError:'enum, struct or union expected'.
!

typeSpecifier
    "baseType := compoundType | builtInType
    "

    |knownType t|

    (#(#struct union enum) includes:tokenType) ifTrue:[
        ^ self compoundType.
    ].

    tokenType == #Identifier ifTrue:[
        knownType := types at:token ifAbsent:nil.
        knownType isNil ifTrue:[
            self parseError:'unknown type: ' , token.
            self nextToken.
            ^ XDRType unknownType new name:token
        ].
        self nextToken.
        ^ knownType
    ].

    t := self builtInType.
    ^ t

    "Created: / 21.12.2001 / 22:40:38 / cg"
    "Modified: / 22.12.2001 / 00:25:21 / cg"
!

unionBodyFor:aType
    |discriminant discriminantType discriminantValue fields field
     prevConstValueType|

    fields := Dictionary new.

    self expect:#switch.
    self expect:$(.
    aType discriminant:(discriminant := self declaration).
    self expect:$).
    self expect:${.

    discriminantType := discriminant type.
    [
        self expect:#case.

        prevConstValueType := constValueType.
        discriminantType isXDREnum ifTrue:[
            constValueType := discriminantType
        ].
        discriminantValue := self parseValue.
        constValueType := prevConstValueType.

        self expect:$:.
        field := self declaration.
        self expect:$;.

        field := XDRType unionField new
            type:field type; name:field name.
        field discriminantValue:discriminantValue.

        fields at:discriminantValue put:field
    ] doWhile:[
        tokenType == #case
    ].

    (tokenType == #default) ifTrue:[
        self nextToken.
        self expect:$:.
        field := self declaration.
        self expect:$;.
        field := XDRType unionField new
            type:field type; name:field name.
        aType defaultField:field.
    ].
    self expect:$}.
    ^ fields
!

versionDef
    |versionName version procedures|

    self expect:#version.
    versionName := self expectIdentifier.
    version := XDRProgramVersion new.
    version name:versionName.

    self expect:${.
    procedures := OrderedCollection new.
    version procedures:procedures.

    [ tokenType ~~ $} ] whileTrue:[
        procedures add:(self procedureDef).
    ].

    self nextToken.
    self expect:$=.
    version versionNumber:(self constant).
    self expect:$;.

    ^ version
! !

!XDRParser methodsFor:'parsing-expressions'!

addExpression
    "e1 { '+' | '-' } e2"

    |e1 e2 op|

    e1 := self mulExpression.
    [tokenType == $+ or:[tokenType == $-]] whileTrue:[
        op := tokenType asSymbol.
        self nextToken.
        e2 := self mulExpression.
        e1 := e1 perform:op with:e2
    ].
    ^ e1.

    "Modified: / 24.10.1998 / 17:16:32 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
!

bitAndExpression
    "e1 '&' e2"

    |e1 e2 op|

    e1 := self shiftExpression.
    [tokenType == $&] whileTrue:[
        op := tokenType asSymbol.
        self nextToken.
        e2 := self shiftExpression.
        e1 := e1 bitAnd:e2
    ].
    ^ e1.

    "Modified: / 24.10.1998 / 17:16:22 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
!

bitOrExpression
    "e1 '|' e2"

    |e1 e2 op|

    e1 := self bitAndExpression.
    [tokenType == $|] whileTrue:[
        op := tokenType asSymbol.
        self nextToken.
        e2 := self bitAndExpression.
        e1 := e1 bitOr:e2
    ].
    ^ e1.

    "Modified: / 24.10.1998 / 17:16:11 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
!

expression
    ^ self bitOrExpression
!

mulExpression
    "e1 { '*' | '/' | '%' } e2"

    |e1 e2 op|

    e1 := self primary.

    [tokenType == $* 
    or:[tokenType == $/
    or:[tokenType == $%]]] whileTrue:[
        tokenType == $* ifTrue:[
            op := #*
        ] ifFalse:[
            tokenType == $% ifTrue:[
                op := #'\\'
            ] ifFalse:[
                op := #'//'
            ]
        ].
        self nextToken.
        e2 := self primary.
        e1 := e1 perform:op with:e2
    ].
    ^ e1.

    "Modified: / 24.10.1998 / 17:15:40 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
!

primary
    "
       - primary
       ~ primary
       !! primary
     | ( expression )
     | integer
     | string
     | identifier
    "

    |e defineVal constVal id idx|

    tokenType == $- ifTrue:[
        self nextToken.
        ^ self primary negated
    ].
    tokenType == $~ ifTrue:[
        self nextToken.
        ^ self primary bitInvert
    ].
    tokenType == $!! ifTrue:[
        self nextToken.
        ^ self primary not
    ].

    tokenType == $( ifTrue:[
        self nextToken.
        e := self expression.
        self expect:$).
        ^ e
    ].
    tokenType == #Integer ifTrue:[
        e := token.
        self nextToken.
        ^ e
    ].
"/    tokenType == #String ifTrue:[
"/        e := token.
"/        self nextToken.
"/        ^ e
"/    ].
"/    tokenType == #Character ifTrue:[
"/        e := token.
"/        self nextToken.
"/        ^ e
"/    ].

    tokenType == #Identifier ifFalse:[
        self parseError:'integer or identifier expected'.
        ^ nil
    ].

    id := token.
    self nextToken.

"/    id = 'sizeof' ifTrue:[
"/        |typ|
"/
"/        tokenType ~~ $( ifTrue:[ self parseError:'''('' expected after sizeof' ].
"/        self nextToken.
"/        typ := self baseType.
"/        tokenType ~~ $) ifTrue:[ self parseError:''')'' expected' ].
"/        self nextToken.
"/        e := typ sizeof.
"/        ^ e
"/    ].

    "/ enum or define-constant
    constValueType notNil ifTrue:[
        constValueType isXDREnum ifTrue:[
            constVal := constValueType numericValueFor:id asSymbol.
            constVal notNil ifTrue:[
                ^ constVal
            ].
            self parseError:'invalid constant'.
        ].
    ].
    defineVal isNil ifTrue:[
        idx := anonymousTypes findLast:[:type |
            type isIDLEnum
            and:[type enumValues includesKey:id asSymbol]
        ].
        idx == 0 ifTrue:[
            defines notNil ifTrue:[
                defineVal := defines at:id ifAbsent:nil.
            ].
        ] ifFalse:[
            defineVal := (anonymousTypes at:idx) numericValueFor:id asSymbol.
        ].
    ].

    defineVal isNil ifTrue:[
        consts notNil ifTrue:[
            constVal := consts at:id ifAbsent:nil.
            constVal notNil ifTrue:[
                ^ constVal
            ]
        ].
    ].

    defineVal isNil ifTrue:[
        ^ IDLVariable new name:id.

        self parseError:'undefined: ' , id.
        ^ 0
    ].

    "/ for your convenience - allow numbers there ...
    defineVal isInteger ifTrue:[
        ^ defineVal
    ].
    "/ a macro ...
    e := self class parseIntegerExpression:defineVal withDefines:defines.
    ^ e

    "Modified: / 13.5.1998 / 18:23:19 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
!

shiftExpression
    "e1 { '<<' | '>>' } e2"

    |e1 e2 op|

    e1 := self addExpression.
    [tokenType == #'<<' or:[tokenType == #'>>']] whileTrue:[
        op := tokenType.
        self nextToken.
        e2 := self addExpression.
        op == #'<<' ifTrue:[
            e1 := e1 bitShift:e2
        ] ifFalse:[
            e1 := e1 bitShift:e2 negated
        ]
    ].
    ^ e1.

    "Modified: / 24.10.1998 / 17:15:53 / cg"
    "Created: / 21.12.2001 / 22:40:40 / cg"
! !

!XDRParser methodsFor:'private'!

declareType:aType name:anIdentifier
    "private - declare a typedef"

    |existing|

"/    cPlusPlus ifTrue:[
"/        existing := structs at:anIdentifier ifAbsent:nil.
"/        (existing notNil and:[existing ~~ aType]) ifTrue:[
"/            self parseError:('redefinition of: ' , anIdentifier)
"/        ].
"/        existing := unions at:anIdentifier ifAbsent:nil.
"/        (existing notNil and:[existing ~~ aType]) ifTrue:[
"/            self parseError:('redefinition of: ' , anIdentifier)
"/        ].
"/    ].

    existing := types at:anIdentifier ifAbsent:nil.
    (existing notNil and:[(existing sameTypeAs:aType) not]) ifTrue:[
        ignoreRedefinitions ifFalse:[
            self parseError:('redefinition of: ' , anIdentifier)
        ]
    ] ifFalse:[
        types at:anIdentifier put:aType.
    ].
    Verbose == true ifTrue:[
        Transcript showCR:('IDL: declare type ' , anIdentifier , ' as ' , aType class name)
    ].

    "Modified: / 15.5.1998 / 21:26:53 / cg"
    "Created: / 21.12.2001 / 22:40:41 / cg"
! !

!XDRParser methodsFor:'scanning'!

expect:expectedToken
    tokenType ~~ expectedToken ifTrue:[
        self parseError:'''' , expectedToken , ''' expected (got ' , tokenType , ')'.
        ^ false
    ].
    self nextToken.
    ^ true.

    "Modified: / 21.12.2001 / 22:49:09 / cg"
!

expectIdentifier
    |id|

    tokenType ~~ #Identifier ifTrue:[
        self parseError:'identifier expected (got ''' , tokenType , ''')'.
        ^ nil
    ].
    id := token.
    self nextToken.
    ^ id.
!

expectIdentifier:aString
    tokenType ~~ #Identifier ifTrue:[
        self parseError:'''' , aString , ''' expected (got ' , tokenType , ')'.
        ^ false
    ].
    token ~= aString ifTrue:[
        self parseError:'''' , aString , ''' expected (got ' , token , ')'.
        ^ false
    ].
    self nextToken.
    ^ true.
!

nextToken
    tokenType := scanner nextToken.
    token := scanner token.

    ^ tokenType

    "Created: / 21.12.2001 / 22:40:40 / cg"
! !

!XDRParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRParser.st,v 1.12 2018-01-19 22:42:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_XDRParser.st,v 1.12 2018-01-19 22:42:13 cg Exp $'
! !


XDRParser initialize!
