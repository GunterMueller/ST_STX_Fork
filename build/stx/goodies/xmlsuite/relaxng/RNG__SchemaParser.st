"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

XMLv2::ContentHandler subclass:#SchemaParser
	instanceVariableNames:'nodeStack schema currentDefineName refs nsStack'
	classVariableNames:'BindingNamespace RNGNamespace ActionDictionary'
	poolDictionaries:''
	category:'Relax NG'
!


!SchemaParser class methodsFor:'initialization'!

initialize

    ActionDictionary := nil.
    BindingNamespace := nil.
    RNGNamespace := nil.

    "
        RNG::SchemaParser initialize
    "

    "Modified: / 02-05-2005 / 13:14:32 / janfrog"
! !

!SchemaParser class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 03-05-2005 / 11:08:10 / janfrog"
! !

!SchemaParser class methodsFor:'accessing'!

actionDictionary

    ActionDictionary ifNil:[
        ActionDictionary := Dictionary new
            add:'element'       -> #startElementDef:;
            add:'attribute'     -> #startAttributeDef:;
            add:'text'          -> #startTextDef:;
            add:'data'          -> #startDataDef:;
            add:'choice'        -> #startChoiceDef:;
            add:'optional'      -> #startOptionalDef:;
            add:'oneOrMore'     -> #startOneOrMoreDef:;
            add:'zeroOrMore'    -> #startZeroOrMoreDef:;
            add:'group'         -> #startGroupDef:;
            add:'empty'         -> #startEmptyDef:;
            add:'ref'           -> #startRefDef:;
            add:'include'       -> #startIncludeDef:;
            add:'list'          -> #startListDef:;
            yourself
    ].
    ^ActionDictionary

    "
        ActionDictionary := nil
    "

    "Created: / 30-04-2005 / 18:50:03 / janfrog"
    "Modified: / 14-05-2005 / 20:12:15 / janfrog"
!

bindingNamespace

    BindingNamespace ifNil:[
        BindingNamespace := 'http://www.volny.cz/janfrog/xmlsuite/binding'
    ].
    ^BindingNamespace

    "Created: / 02-05-2005 / 13:10:02 / janfrog"
!

rngNamespace

    RNGNamespace ifNil:[RNGNamespace := 'http://relaxng.org/ns/structure/1.0'].
    ^RNGNamespace

    "Modified: / 02-05-2005 / 13:14:05 / janfrog"
! !

!SchemaParser class methodsFor:'utilities'!

schemaFromStream:aStream

    ^self new schemaFromStream:aStream

    "Created: / 03-05-2005 / 11:06:11 / janfrog"
!

schemaFromURI:aFilename 
    ^ self new schemaFromURI:aFilename

    "Created: / 03-05-2005 / 11:05:59 / janfrog"
    "Modified: / 07-06-2005 / 11:51:31 / masca"
! !

!SchemaParser methodsFor:'SAX2 interface'!

endDocument

    "/schema rootPattern  initializeAutomaton.
    "resolving references"
    schema 
        resolveReferencesFrom:refs;
        finishLoading.

    "Created: / 01-05-2005 / 18:48:05 / janfrog"
    "Modified: / 02-05-2005 / 14:17:24 / janfrog"
    "Modified: / 07-06-2005 / 11:06:45 / masca"
!

endElement:localName namespace:namespace prefix:prefix 

    | topNode | 

    self class rngNamespace = namespace ifFalse:[^self].
    localName = 'grammar' ifTrue:[^self].
    localName = 'start' ifTrue:[^self].
    localName = 'include' ifTrue:[^self].
    localName = 'define' ifTrue:[nodeStack pop. ^self].


    topNode := nodeStack pop.

    nodeStack top addChild:topNode.
    topNode checkContents.
    topNode postParseFor:self schema.
    nsStack pop.

    "Created: / 30-04-2005 / 14:52:30 / janfrog"
    "Modified: / 14-05-2005 / 21:22:54 / janfrog"
    "Modified: / 16-05-2005 / 09:23:58 / masca"
!

setDocumentLocator:locator

    schema 
        addSource:locator getSystemId;
        rootSource:locator getSystemId.

    "Modified: / 07-06-2005 / 11:31:34 / masca"
!

startDocument

    nodeStack push:schema rootPattern node.
    refs := Set new.

    "Created: / 30-04-2005 / 14:07:08 / janfrog"
    "Modified: / 03-05-2005 / 11:08:30 / janfrog"
    "Modified: / 07-06-2005 / 11:33:43 / masca"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes

    | action ns |

    self class rngNamespace = namespace ifFalse:[^self].

    ns := attributes getValueByURI:self class rngNamespace localName:'ns'.
    ns ifNotNil:[nsStack push:ns] ifNil:[nsStack push:nsStack top].


    

    localName = 'grammar' ifTrue:[^self].
    localName = 'start' ifTrue:[^self].
    localName = 'define' ifTrue:[
        currentDefineName := attributes getValueByURI:self class rngNamespace localName:'name'.
        nodeStack push:self.
        ^self
    ].
    action := self class actionDictionary 
                at:localName
                ifAbsent:[self parsingError:'Unexpected tag: ',localName].

    self perform:action with:attributes

    "Created: / 30-04-2005 / 14:18:35 / janfrog"
    "Modified: / 03-05-2005 / 10:57:28 / janfrog"
    "Modified: / 12-05-2005 / 12:26:46 / masca"
! !

!SchemaParser methodsFor:'accessing'!

addChild:aNode

    self schema define:currentDefineName as:aNode.
    aNode inDefine:true.

    "Created: / 02-05-2005 / 14:26:33 / janfrog"
    "Modified: / 03-05-2005 / 10:52:19 / janfrog"
    "Modified: / 12-05-2005 / 12:12:29 / masca"
!

refs

    ^refs

    "Created: / 12-05-2005 / 11:50:56 / masca"
!

schema
    ^ schema

    "Created: / 30-04-2005 / 14:59:39 / janfrog"
! !

!SchemaParser methodsFor:'actions'!

startAttributeDef:anAttributes

    | patternNode name |
    patternNode := PatternNode for:ComplexTypePattern new.
    patternNode pattern isForAttribute:true.
    name := anAttributes getValueByURI:RNGNamespace localName:'name'.
    name ifNil:[self parsingError:'attribute must have name'].
    patternNode pattern 
        setNamespace:nsStack top localName:name;
        initializeBindingInfoFromAttributes:anAttributes.

    nodeStack push:patternNode

    "Created: / 30-04-2005 / 14:47:46 / janfrog"
    "Modified: / 12-05-2005 / 12:27:47 / masca"
    "Modified: / 14-05-2005 / 18:16:27 / janfrog"
!

startChoiceDef:anAttributes

    nodeStack push:ChoiceNode new

    "Created: / 30-04-2005 / 19:02:28 / janfrog"
!

startDataDef:anAttributes

    | patternNode type dataTypeLibrary |
    patternNode := PatternNode for:(PCDataPattern new).
    patternNode pattern
        initializeBindingInfoFromAttributes:anAttributes.
    dataTypeLibrary := self schema defaultDataTypeLibrary.
    type := anAttributes getValueByURI:RNGNamespace localName:'type'.
    type ifNil:[self parsingError:'No type specified'].
    patternNode pattern dataType:
        (dataTypeLibrary dataTypeWithName:type).


    nodeStack push:patternNode

    "Created: / 30-04-2005 / 17:25:59 / janfrog"
    "Modified: / 14-05-2005 / 22:38:45 / janfrog"
!

startElementDef:anAttributes

    | patternNode name |
    patternNode := PatternNode for:ComplexTypePattern new.
    name := anAttributes getValueByURI:RNGNamespace localName:'name'.
    name ifNil:[self parsingError:'element must have name'].
    patternNode pattern 
        setNamespace:nsStack top localName:name;
        initializeBindingInfoFromAttributes:anAttributes.

    nodeStack push:patternNode

    "Created: / 30-04-2005 / 14:34:13 / janfrog"
    "Modified: / 12-05-2005 / 12:27:23 / masca"
    "Modified: / 14-05-2005 / 18:16:21 / janfrog"
!

startEmptyDef:anAttributes

    nodeStack push:EmptyNode new.
    "Nothing to do"

    "Created: / 02-05-2005 / 11:22:40 / janfrog"
!

startGroupDef:anAttributes

    nodeStack push:GroupNode new

    "Created: / 02-05-2005 / 11:16:35 / janfrog"
!

startIncludeDef:attributes 
    |href file|

    (href := attributes getValueByURI:RNGNamespace localName:'href') 
        ifNil:[ self parsingError:'No "href" attribute in include' ].
    file := Schema findFileWithName:href.
    [
        (SchemaIncludeParser for:self) schemaFromURI:file asURI.
    ] on:CircularSchemaInclusion
            do:[:ex | Transcript showCR:'[RNG:warning]: ' , ex description ]

    "Created: / 03-05-2005 / 10:59:09 / janfrog"
    "Modified: / 07-06-2005 / 12:03:24 / masca"
!

startListDef:anAttributes

    | patternNode |
    patternNode := PatternNode for:ListPattern new.
    nodeStack push:patternNode

    "Modified: / 12-05-2005 / 12:27:23 / masca"
    "Created: / 14-05-2005 / 20:13:37 / janfrog"
!

startOneOrMoreDef:anAttributes

    nodeStack push:OneOrMoreNode new

    "Created: / 30-04-2005 / 19:01:55 / janfrog"
!

startOptionalDef:anAttributes

    nodeStack push:OptionalNode new

    "Created: / 30-04-2005 / 19:02:18 / janfrog"
!

startRefDef:attributes

    | refNode name |
    refNode := RefNode new.
    name := attributes getValueByURI:RNGNamespace localName:'name'.
    name ifNil:[self parsingError:'attribute "type" not found'].
    refNode 
        name:name;
        initializeBindingInfoFromAttributes:attributes.
    self refs add:refNode.

    nodeStack push:refNode

    "Created: / 02-05-2005 / 13:48:59 / janfrog"
    "Modified: / 12-05-2005 / 17:11:24 / masca"
!

startTextDef:anAttributes

    | patternNode |
    patternNode := PatternNode for:(PCDataPattern new).
    patternNode pattern
            initializeBindingInfoFromAttributes:anAttributes.
    patternNode pattern dataType:TextDataType default.

    nodeStack push:patternNode

    "Created: / 30-04-2005 / 17:25:59 / janfrog"
    "Modified: / 14-05-2005 / 22:38:37 / janfrog"
!

startZeroOrMoreDef:anAttributes

    nodeStack push:ZeroOrMoreNode new

    "Created: / 30-04-2005 / 19:02:04 / janfrog"
! !

!SchemaParser methodsFor:'error reporting'!

parsingError:aString

    ^SchemaParsingError raiseErrorString:aString

    "Created: / 30-04-2005 / 14:46:53 / janfrog"
! !

!SchemaParser methodsFor:'initialization'!

initialize

        schema := Schema new.
        nodeStack := Stack new .
        (nsStack := Stack new) push:''.

    "Created: / 03-05-2005 / 11:08:39 / janfrog"
    "Modified: / 07-06-2005 / 11:33:59 / masca"
! !

!SchemaParser methodsFor:'utilities'!

schemaFromStream:aStream


    XMLv2::XMLReader new
        setContentHandler:self;
        parseInputSource:(XMLv2::InputSource onStream:aStream).
    ^self schema

    "Created: / 03-05-2005 / 11:05:23 / janfrog"
    "Modified: / 07-06-2005 / 11:21:22 / masca"
!

schemaFromURI:anURI

    ^anURI isRemote ifTrue:[
        self parsingError:'Remote URIs (http://..., ftp://... not yet supported'        
    ] ifFalse:[
        self 
            schemaFromStream:(Schema findFileWithName:anURI path) asFilename readStream
    ]

    "Created: / 07-06-2005 / 11:51:31 / masca"
! !

!SchemaParser class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__SchemaParser.st,v 1.1.1.1 2005-11-01 22:07:15 vranyj1 Exp $'
! !

SchemaParser initialize!
