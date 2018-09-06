"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#JamesClarkXMLTests
	instanceVariableNames:'doc'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests W3C'
!


!JamesClarkXMLTests methodsFor:'accessing'!

resources
   ^Array with:W3XMLTestSuiteResource

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
! !

!JamesClarkXMLTests methodsFor:'tests'!

test_invalid__002


	"Sections: 3.2.1"
	"Description: 
    Tests the `Proper Group/PE Nesting` validity constraint by
    fragmenting a content model between two parameter entities."


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/invalid/002.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_invalid__005


	"Sections: 2.8"
	"Description: 
    Tests the `Proper Declaration/PE Nesting` validity constraint by
    fragmenting an element declaration between two parameter entities."


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/invalid/005.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_invalid__006


	"Sections: 2.8"
	"Description: 
    Tests the `Proper Declaration/PE Nesting` validity constraint by
    fragmenting an element declaration between two parameter entities."


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/invalid/006.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_invalid_not_sa_022


	"Sections: 3.4 [62]"
	"Description: 
    Test the `Proper Conditional Section/ PE Nesting` validity constraint. "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/invalid/not-sa/022.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_ext_sa_001


	"Sections: 4.1"
	"Description: 
    Tests the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/ext-sa/001.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_ext_sa_002


	"Sections: 4.3.1 4.3.2 [77, 78]"
	"Description: 
    External entities have `text declarations`, which do
    not permit the `standalone=...` attribute that's allowed
    in XML declarations."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/ext-sa/002.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_ext_sa_003


	"Sections: 2.6 [17]"
	"Description: 
    Only one text declaration is permitted; a second one
    looks like an illegal processing instruction (target names
    of `xml` in any case are not allowed). "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/ext-sa/003.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_not_sa_001


	"Sections: 3.4 [62]"
	"Description: 
    Conditional sections must be properly terminated (`]>` used
    instead of `]]>`). "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/001.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_002


	"Sections: 2.6 [17]"
	"Description: 
    Processing instruction target names may not be `XML` 
    in any combination of cases. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/002.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_003


	"Sections: 3.4 [62]"
	"Description: 
    Conditional sections must be properly terminated (`]]>` omitted). "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/003.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_004


	"Sections: 3.4 [62]"
	"Description: 
    Conditional sections must be properly terminated (`]]>` omitted). "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/004.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_005


	"Sections: 4.1"
	"Description: 
    Tests the "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/005.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_006


	"Sections: 3.4 [62]"
	"Description: 
    Conditional sections need a '[' after the INCLUDE or IGNORE. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/006.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_007


	"Sections: 4.3.2 [79]"
	"Description: 
    A <iDOCTYPE ...> declaration may not begin any external
    entity; it's only found once, in the document entity."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/007.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_not_sa_008


	"Sections: 4.1 [69]"
	"Description: 
    In DTDs, the '%' character must be part of a parameter
    entity reference."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/008.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_not_sa_009


	"Sections: 2.8"
	"Description: 
    This test violates WFC:PE Between Declarations in Production 28a.  
    The last character of a markup declaration is not contained in the same 
    parameter-entity text replacement."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/not-sa/009.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_not_wf_sa_001


	"Sections: 3.1 [41]"
	"Description: 
    Attribute values must start with attribute names, not `?`. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/001.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_002


	"Sections: 2.3 [4]"
	"Description: 
    Names may not start with `.`; it's not a Letter. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/002.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_003


	"Sections: 2.6 [16]"
	"Description: 
    Processing Instruction target name is required."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/003.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_004


	"Sections: 2.6 [16]"
	"Description: 
    SGML-ism:  processing instructions end in '?>' not '>'. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/004.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_005


	"Sections: 2.6 [16]"
	"Description: 
    Processing instructions end in '?>' not '?'. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/005.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_006


	"Sections: 2.5 [16]"
	"Description: 
    XML comments may not contain `--` "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/006.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_007


	"Sections: 4.1 [68]"
	"Description: 
    General entity references have no whitespace after the
    entity name and before the semicolon. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/007.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_008


	"Sections: 2.3 [5]"
	"Description: 
    Entity references must include names, which don't begin
    with '.' (it's not a Letter or other name start character). "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/008.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_009


	"Sections: 4.1 [66]"
	"Description: 
    Character references may have only decimal or numeric strings."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/009.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_not_wf_sa_010


	"Sections: 4.1 [68]"
	"Description: 
    Ampersand may only appear as part of a general entity reference."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/010.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_011


	"Sections: 3.1 [41]"
	"Description: 
    SGML-ism:  attribute values must be explicitly assigned a
    value, it can't act as a boolean toggle. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/011.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_012


	"Sections: 2.3 [10]"
	"Description: 
    SGML-ism:  attribute values must be quoted in all cases. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/012.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_013


	"Sections: 2.3 [10]"
	"Description: 
    The quotes on both ends of an attribute value must match. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/013.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_014


	"Sections: 2.3 [10]"
	"Description: 
    Attribute values may not contain literal '<' characters. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/014.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_015


	"Sections: 3.1 [41]"
	"Description: 
    Attribute values need a value, not just an equals sign. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/015.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_016


	"Sections: 3.1 [41]"
	"Description: 
    Attribute values need an associated name."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/016.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_017


	"Sections: 2.7 [18]"
	"Description: 
    CDATA sections need a terminating ']]>'. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/017.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_018


	"Sections: 2.7 [19]"
	"Description: 
    CDATA sections begin with a literal '<i[CDATA[', no space."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/018.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_019


	"Sections: 3.1 [42]"
	"Description: 
    End tags may not be abbreviated as '</>'."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/019.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_020


	"Sections: 2.3 [10]"
	"Description: 
    Attribute values may not contain literal '&'
    characters except as part of an entity reference. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/020.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_021


	"Sections: 2.3 [10]"
	"Description: 
    Attribute values may not contain literal '&'
    characters except as part of an entity reference. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/021.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:11 / janfrog"
!

test_not_wf_sa_022


	"Sections: 4.1 [66]"
	"Description: 
    Character references end with semicolons, alwaysi"


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/022.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_023


	"Sections: 2.3 [5]"
	"Description: 
    Digits are not valid name start characters. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/023.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_024


	"Sections: 2.3 [5]"
	"Description: 
    Digits are not valid name start characters. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/024.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_025


	"Sections: 2.4 [14]"
	"Description: 
    Text may not contain a literal ']]>' sequence. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/025.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_026


	"Sections: 2.4 [14]"
	"Description: 
    Text may not contain a literal ']]>' sequence. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/026.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_027


	"Sections: 2.5 [15]"
	"Description: 
    Comments must be terminated with `-->`."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/027.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_028


	"Sections: 2.6 [16]"
	"Description: 
    Processing instructions must end with '?>'. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/028.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_029


	"Sections: 2.4 [14]"
	"Description: 
    Text may not contain a literal ']]>' sequence. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/029.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_030


	"Sections: 2.2 [2]"
	"Description: 
    A form feed is not a legal XML character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/030.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_031


	"Sections: 2.2 [2]"
	"Description: 
    A form feed is not a legal XML character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/031.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_032


	"Sections: 2.2 [2]"
	"Description: 
    A form feed is not a legal XML character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/032.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_033


	"Sections: 2.2 [2]"
	"Description: 
    An ESC (octal 033) is not a legal XML character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/033.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_034


	"Sections: 2.2 [2]"
	"Description: 
    A form feed is not a legal XML character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/034.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_035


	"Sections: 3.1 [43]"
	"Description: 
    The '<' character is a markup delimiter and must
    start an element, CDATA section, PI, or comment. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/035.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_036


	"Sections: 2.8 [27]"
	"Description: 
    Text may not appear after the root element. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/036.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_037


	"Sections: 2.8 [27]"
	"Description: 
    Character references may not appear after the root element. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/037.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:12 / janfrog"
!

test_not_wf_sa_038


	"Sections: 3.1"
	"Description: 
    Tests the `Unique Att Spec` WF constraint by providing
    multiple values for an attribute."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/038.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_039


	"Sections: 3"
	"Description: 
    Tests the Element Type Match WFC - end tag name must
    match start tag name."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/039.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_040


	"Sections: 2.8 [27]"
	"Description: 
    Provides two document elements."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/040.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_041


	"Sections: 2.8 [27]"
	"Description: 
    Provides two document elements."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/041.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_042


	"Sections: 3.1 [42]"
	"Description: 
     Invalid End Tag "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/042.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_043


	"Sections: 2.8 [27]"
	"Description: 
    Provides #PCDATA text after the document element. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/043.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_044


	"Sections: 2.8 [27]"
	"Description: 
    Provides two document elements."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/044.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_045


	"Sections: 3.1 [44]"
	"Description: 
    Invalid Empty Element Tag "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/045.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_046


	"Sections: 3.1 [40]"
	"Description: 
    This start (or empty element) tag was not terminated correctly. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/046.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_047


	"Sections: 3.1 [44]"
	"Description: 
    Invalid empty element tag invalid whitespace "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/047.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_048


	"Sections: 2.8 [27]"
	"Description: 
    Provides a CDATA section after the roor element."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/048.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_049


	"Sections: 3.1 [40]"
	"Description: 
    Missing start tag "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/049.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:13 / janfrog"
!

test_not_wf_sa_050


	"Sections: 2.1 [1]"
	"Description: 
    Empty document, with no root element. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/050.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_051


	"Sections: 2.7 [18]"
	"Description: 
     CDATA is invalid at top level of document."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/051.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_052


	"Sections: 4.1 [66]"
	"Description: 
    Invalid character reference. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/052.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_053


	"Sections: 3.1 [42]"
	"Description: 
    End tag does not match start tag. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/053.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_054


	"Sections: 4.2.2 [75]"
	"Description: 
     PUBLIC requires two literals."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/054.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_055


	"Sections: 2.8 [28]"
	"Description: 
    Invalid Document Type Definition format. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/055.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_056


	"Sections: 2.8 [28]"
	"Description: 
    Invalid Document Type Definition format - misplaced comment. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/056.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_057


	"Sections: 3.2 [45]"
	"Description: 
    This isn't SGML; comments can't exist in declarations. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/057.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_058


	"Sections: 3.3.1 [54]"
	"Description: 
    Invalid character , in ATTLIST enumeration "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/058.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_059


	"Sections: 3.3.1 [59]"
	"Description: 
    String literal must be in quotes. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/059.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_060


	"Sections: 3.3.1 [56]"
	"Description: 
     Invalid type NAME defined in ATTLIST."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/060.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_061


	"Sections: 4.2.2 [75]"
	"Description: 
    External entity declarations require whitespace between public
    and system IDs."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/061.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:14 / janfrog"
!

test_not_wf_sa_062


	"Sections: 4.2 [71]"
	"Description: 
    Entity declarations need space after the entity name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/062.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_063


	"Sections: 2.8 [29]"
	"Description: 
    Conditional sections may only appear in the external
    DTD subset. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/063.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_064


	"Sections: 3.3 [53]"
	"Description: 
    Space is required between attribute type and default values
    in <iATTLIST...> declarations. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/064.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_065


	"Sections: 3.3 [53]"
	"Description: 
    Space is required between attribute name and type
    in <iATTLIST...> declarations. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/065.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_066


	"Sections: 3.3 [52]"
	"Description: 
    Required whitespace is missing. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/066.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_067


	"Sections: 3.3 [53]"
	"Description: 
    Space is required between attribute type and default values
    in <iATTLIST...> declarations. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/067.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_068


	"Sections: 3.3.1 [58]"
	"Description: 
    Space is required between NOTATION keyword and list of
    enumerated choices in <iATTLIST...> declarations. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/068.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_069


	"Sections: 4.2.2 [76]"
	"Description: 
    Space is required before an NDATA entity annotation."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/069.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_070


	"Sections: 2.5 [16]"
	"Description: 
    XML comments may not contain `--` "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/070.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_071


	"Sections: 4.1 [68]"
	"Description: 
     ENTITY can't reference itself directly or indirectly."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/071.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_072


	"Sections: 4.1 [68]"
	"Description: 
    Undefined ENTITY foo. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/072.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_073


	"Sections: 4.1 [68]"
	"Description: 
    Undefined ENTITY f. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/073.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_074


	"Sections: 4.3.2"
	"Description: 
    Internal general parsed entities are only well formed if
    they match the `content` production. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/074.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_075


	"Sections: 4.1 [68]"
	"Description: 
    ENTITY can't reference itself directly or indirectly. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/075.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_076


	"Sections: 4.1 [68]"
	"Description: 
    Undefined ENTITY foo. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/076.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_077


	"Sections: 41. [68]"
	"Description: 
    Undefined ENTITY bar. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/077.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:15 / janfrog"
!

test_not_wf_sa_078


	"Sections: 4.1 [68]"
	"Description: 
    Undefined ENTITY foo. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/078.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_079


	"Sections: 4.1 [68]"
	"Description: 
    ENTITY can't reference itself directly or indirectly. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/079.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_080


	"Sections: 4.1 [68]"
	"Description: 
    ENTITY can't reference itself directly or indirectly. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/080.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_081


	"Sections: 3.1"
	"Description: 
    This tests the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/081.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_082


	"Sections: 3.1"
	"Description: 
    This tests the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/082.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_083


	"Sections: 4.2.2 [76]"
	"Description: 
    Undefined NOTATION n. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/083.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_084


	"Sections: 4.1"
	"Description: 
    Tests the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/084.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_085


	"Sections: 2.3 [13]"
	"Description: 
    Public IDs may not contain `[`. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/085.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_086


	"Sections: 2.3 [13]"
	"Description: 
    Public IDs may not contain `[`. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/086.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_087


	"Sections: 2.3 [13]"
	"Description: 
    Public IDs may not contain `[`. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/087.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_088


	"Sections: 2.3 [10]"
	"Description: 
    Attribute values are terminated by literal quote characters,
    and any entity expansion is done afterwards. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/088.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_089


	"Sections: 4.2 [74]"
	"Description: 
    Parameter entities `are` always parsed; NDATA annotations
    are not permitted."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/089.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_090


	"Sections: 2.3 [10]"
	"Description: 
    Attributes may not contain a literal `<` character;
    this one has one because of reference expansion. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/090.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_091


	"Sections: 4.2 [74]"
	"Description: 
    Parameter entities `are` always parsed; NDATA annotations
    are not permitted."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/091.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_092


	"Sections: 4.5"
	"Description: 
    The replacement text of this entity has an illegal reference,
    because the character reference is expanded immediately. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/092.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_093


	"Sections: 4.1 [66]"
	"Description: 
    Hexadecimal character references may not use the uppercase 'X'."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/093.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_094


	"Sections: 2.8 [24]"
	"Description: 
    Prolog VERSION must be lowercase. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/094.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:16 / janfrog"
!

test_not_wf_sa_095


	"Sections: 2.8 [23]"
	"Description: 
    VersionInfo must come before EncodingDecl. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/095.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_096


	"Sections: 2.9 [32]"
	"Description: 
    Space is required before the standalone declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/096.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_097


	"Sections: 2.8 [24]"
	"Description: 
    Both quotes surrounding VersionNum must be the same. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/097.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_098


	"Sections: 2.8 [23]"
	"Description: 
    Only one `version=...` string may appear in an XML declaration."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/098.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_099


	"Sections: 2.8 [23]"
	"Description: 
    Only three pseudo-attributes are in the XML declaration,
    and `valid=...` is not one of them. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/099.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_100


	"Sections: 2.9 [32]"
	"Description: 
    Only `yes` and `no` are permitted as values of `standalone`. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/100.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_101


	"Sections: 4.3.3 [81]"
	"Description: 
    Space is not permitted in an encoding name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/101.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_102


	"Sections: 2.8 [26]"
	"Description: 
    Provides an illegal XML version number; spaces are illegal."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/102.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_103


	"Sections: 4.3.2"
	"Description: 
    End-tag required for element foo. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/103.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_104


	"Sections: 4.3.2"
	"Description: 
    Internal general parsed entities are only well formed if
    they match the `content` production. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/104.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_105


	"Sections: 2.7 "
	"Description: 
    Invalid placement of CDATA section. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/105.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_106


	"Sections: 4.2"
	"Description: 
    Invalid placement of entity declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/106.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_107


	"Sections: 2.8 [28]"
	"Description: 
     Invalid document type declaration.  CDATA alone is invalid."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/107.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_108


	"Sections: 2.7 [19]"
	"Description: 
    No space in '<i[CDATA['."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/108.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:17 / janfrog"
!

test_not_wf_sa_109


	"Sections: 4.2 [70]"
	"Description: 
    Tags invalid within EntityDecl. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/109.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_110


	"Sections: 4.1 [68]"
	"Description: 
    Entity reference must be in content of element. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/110.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_111


	"Sections: 3.1 [43]"
	"Description: 
    Entiry reference must be in content of element not Start-tag. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/111.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_112


	"Sections: 2.7 [19]"
	"Description: 
    CDATA sections start '<i[CDATA[', not '<icdata['."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/112.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_113


	"Sections: 2.3 [9]"
	"Description: 
    Parameter entity values must use valid reference syntax;
    this reference is malformed."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/113.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_114


	"Sections: 2.3 [9]"
	"Description: 
    General entity values must use valid reference syntax;
    this reference is malformed."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/114.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_115


	"Sections: 4.5"
	"Description: 
    The replacement text of this entity is an illegal character
    reference, which must be rejected when it is parsed in the
    context of an attribute value."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/115.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_116


	"Sections: 4.3.2"
	"Description: 
    Internal general parsed entities are only well formed if
    they match the `content` production.  This is a partial
    character reference, not a full one. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/116.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_117


	"Sections: 4.3.2"
	"Description: 
    Internal general parsed entities are only well formed if
    they match the `content` production.  This is a partial
    character reference, not a full one. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/117.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_118


	"Sections: 4.1 [68]"
	"Description: 
    Entity reference expansion is not recursive."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/118.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_119


	"Sections: 4.3.2"
	"Description: 
    Internal general parsed entities are only well formed if
    they match the `content` production.  This is a partial
    character reference, not a full one. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/119.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_120


	"Sections: 4.5"
	"Description: 
    Character references are expanded in the replacement text of
    an internal entity, which is then parsed as usual.  Accordingly,
    & must be doubly quoted - encoded either as "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/120.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_121


	"Sections: 4.1 [68]"
	"Description: 
    A name of an ENTITY was started with an invalid character. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/121.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_122


	"Sections: 3.2.1 [47]"
	"Description: 
    Invalid syntax mixed connectors are used. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/122.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_123


	"Sections: 3.2.1 [48]"
	"Description: 
    Invalid syntax mismatched parenthesis. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/123.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_124


	"Sections: 3.2.2 [51]"
	"Description: 
    Invalid format of Mixed-content declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/124.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:18 / janfrog"
!

test_not_wf_sa_125


	"Sections: 3.2.2 [51]"
	"Description: 
    Invalid syntax extra set of parenthesis not necessary. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/125.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_126


	"Sections: 3.2.2 [51]"
	"Description: 
    Invalid syntax Mixed-content must be defined as zero or more. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/126.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_127


	"Sections: 3.2.2 [51]"
	"Description: 
    Invalid syntax Mixed-content must be defined as zero or more. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/127.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_128


	"Sections: 2.7 [18]"
	"Description: 
    Invalid CDATA syntax. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/128.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_129


	"Sections: 3.2 [45]"
	"Description: 
    Invalid syntax for Element Type Declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/129.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_130


	"Sections: 3.2 [45]"
	"Description: 
    Invalid syntax for Element Type Declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/130.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_131


	"Sections: 3.2 [45]"
	"Description: 
    Invalid syntax for Element Type Declaration. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/131.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_132


	"Sections: 3.2.1 [50]"
	"Description: 
    Invalid syntax mixed connectors used. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/132.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_133


	"Sections: 3.2.1"
	"Description: 
    Illegal whitespace before optional character causes syntax error. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/133.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_134


	"Sections: 3.2.1"
	"Description: 
    Illegal whitespace before optional character causes syntax error. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/134.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_135


	"Sections: 3.2.1 [47]"
	"Description: 
    Invalid character used as connector. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/135.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_136


	"Sections: 3.2 [45]"
	"Description: 
    Tag omission is invalid in XML. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/136.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_137


	"Sections: 3.2 [45]"
	"Description: 
    Space is required before a content model. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/137.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_138


	"Sections: 3.2.1 [48]"
	"Description: 
    Invalid syntax for content particle.  "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/138.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_139


	"Sections: 3.2.1 [46]"
	"Description: 
    The element-content model should not be empty. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/139.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:19 / janfrog"
!

test_not_wf_sa_140


	"Sections: 2.3 [4]"
	"Description: 
    Character '&#x309a;' is a CombiningChar, not a
    Letter, and so may not begin a name."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/140.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_141


	"Sections: 2.3 [5]"
	"Description: 
    Character #x0E5C is not legal in XML names. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/141.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_142


	"Sections: 2.2 [2]"
	"Description: 
    Character #x0000 is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/142.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_143


	"Sections: 2.2 [2]"
	"Description: 
    Character #x001F is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/143.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_144


	"Sections: 2.2 [2]"
	"Description: 
    Character #xFFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/144.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_145


	"Sections: 2.2 [2]"
	"Description: 
    Character #xD800 is not legal anywhere in an XML document.  (If it
    appeared in a UTF-16 surrogate pair, it'd represent half of a UCS-4
    character and so wouldn't really be in the document.) "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/145.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_146


	"Sections: 2.2 [2]"
	"Description: 
    Character references must also refer to legal XML characters;
    #x00110000 is one more than the largest legal character."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/146.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_147


	"Sections: 2.8 [22]"
	"Description: 
    XML Declaration may not be preceded by whitespace."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/147.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_148


	"Sections: 2.8 [22]"
	"Description: 
    XML Declaration may not be preceded by comments or whitespace."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/148.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_149


	"Sections: 2.8 [28]"
	"Description: 
    XML Declaration may not be within a DTD."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/149.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_150


	"Sections: 3.1 [43]"
	"Description: 
    XML declarations may not be within element content. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/150.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_151


	"Sections: 2.8 [27]"
	"Description: 
    XML declarations may not follow document content."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/151.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_152


	"Sections: 2.8 [22]"
	"Description: 
    XML declarations must include the `version=...` string."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/152.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_153


	"Sections: 4.3.2"
	"Description: 
    Text declarations may not begin internal parsed entities;
    they may only appear at the beginning of external parsed
    (parameter or general) entities. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/153.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_154


	"Sections: 2.8 2.6 [23, 17]"
	"Description: 
    '<?XML ...?>' is neither an XML declaration
    nor a legal processing instruction target name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/154.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:20 / janfrog"
!

test_not_wf_sa_155


	"Sections: 2.8 2.6 [23, 17]"
	"Description: 
    '<?xmL ...?>' is neither an XML declaration
    nor a legal processing instruction target name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/155.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_156


	"Sections: 2.8 2.6 [23, 17]"
	"Description: 
    '<?xMl ...?>' is neither an XML declaration
    nor a legal processing instruction target name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/156.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_157


	"Sections: 2.6 [17]"
	"Description: 
    '<?xmL ...?>' is not a legal processing instruction
    target name. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/157.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_158


	"Sections: 3.3 [52]"
	"Description: 
    SGML-ism:  `#NOTATION gif` can't have attributes. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/158.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_159


	"Sections: 2.3 [9]"
	"Description: 
    Uses '&' unquoted in an entity declaration,
    which is illegal syntax for an entity reference."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/159.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_160


	"Sections: 2.8"
	"Description: 
    Violates the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/160.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_161


	"Sections: 2.8"
	"Description: 
    Violates the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/161.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_162


	"Sections: 2.8"
	"Description: 
    Violates the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/162.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_163


	"Sections: 4.1 [69]"
	"Description: 
    Invalid placement of Parameter entity reference. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/163.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_164


	"Sections: 4.1 [69]"
	"Description: 
    Invalid placement of Parameter entity reference. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/164.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_165


	"Sections: 4.2 [72]"
	"Description: 
    Parameter entity declarations must have a space before
    the '%'. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/165.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_166


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/166.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:21 / janfrog"
!

test_not_wf_sa_167


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFE is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/167.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_168


	"Sections: 2.2 [2]"
	"Description: 
    An unpaired surrogate (D800) is not legal anywhere
    in an XML document."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/168.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_169


	"Sections: 2.2 [2]"
	"Description: 
    An unpaired surrogate (DC00) is not legal anywhere
    in an XML document."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/169.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_170


	"Sections: 2.2 [2]"
	"Description: 
    Four byte UTF-8 encodings can encode UCS-4 characters
    which are beyond the range of legal XML characters
    (and can't be expressed in Unicode surrogate pairs).
    This document holds such a character.  "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/170.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_171


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/171.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_172


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/172.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_173


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/173.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_174


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/174.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_175


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/175.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_176


	"Sections: 3 [39]"
	"Description: 
    Start tags must have matching end tags."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/176.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_177


	"Sections: 2.2 [2]"
	"Description: 
    Character FFFF is not legal anywhere in an XML document. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/177.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_178


	"Sections: 3.1 [41]"
	"Description: 
    Invalid syntax matching double quote is missing. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/178.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_179


	"Sections: 4.1 [66]"
	"Description: 
    Invalid syntax matching double quote is missing. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/179.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:22 / janfrog"
!

test_not_wf_sa_180


	"Sections: 4.1"
	"Description: 
    The "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/180.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_181


	"Sections: 4.3.2"
	"Description: 
    Internal parsed entities must match the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/181.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_182


	"Sections: 4.3.2"
	"Description: 
    Internal parsed entities must match the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/182.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_183


	"Sections: 3.2.2 [51]"
	"Description: 
    Mixed content declarations may not include content particles."


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/183.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_184


	"Sections: 3.2.2 [51]"
	"Description: 
    In mixed content models, element names must not be
    parenthesized. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/184.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_185


	"Sections: 4.1"
	"Description: 
    Tests the "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/185.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_not_wf_sa_186


	"Sections: 3.1 [44]"
	"Description: 
    Whitespace is required between attribute/value pairs. "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/not-wf/sa/186.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:23 / janfrog"
!

test_valid_ext_sa_001


	"Sections: 2.11"
	"Description: 
    A combination of carriage return line feed in an external entity must
    be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/001.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_ext_sa_002


	"Sections: 2.11"
	"Description: 
    A carriage return (also CRLF) in an external entity must
    be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/002.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_ext_sa_003


	"Sections: 3.1 4.1 [43] [68]"
	"Description: 
    Test demonstrates that the content of an element can be empty. In this case the external entity is an empty file. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/003.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_ext_sa_004


	"Sections: 2.11"
	"Description: 
    A carriage return (also CRLF) in an external entity must
    be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/004.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_005


	"Sections: 3.2.1 4.2.2 [48] [75]"
	"Description: 
    Test demonstrates the use of optional character and content particles within an element content.  The test also show the use of external entity. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/005.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_006


	"Sections: 2.11 3.2.1 3.2.2 4.2.2 [48] [51] [75]"
	"Description: 
    Test demonstrates the use of optional character and content particles within mixed element content.  The test also shows the use of an external entity and that a carriage control line feed in an external entity must be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/006.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_007


	"Sections: 4.2.2 4.4.3 [75]"
	"Description: 
    Test demonstrates the use of external entity and how replacement 
text is retrieved and processed. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/007.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_008


	"Sections: 4.2.2 4.3.3. 4.4.3 [75] [80]"
	"Description:  Test demonstrates the use of external 
entity and how replacement text is retrieved and processed.  Also tests the use of an 
EncodingDecl of UTF-16."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/008.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_009


	"Sections: 2.11"
	"Description: 
    A carriage return (also CRLF) in an external entity must
    be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/009.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_011


	"Sections: 2.11 4.2.2 [75]"
	"Description: 
    Test demonstrates the use of a public identifier with and external entity.  
The test also show that a carriage control line feed combination in an external 
entity must be normalized to a single newline. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/011.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_012


	"Sections: 4.2.1 4.2.2"
	"Description: 
     Test demonstrates both internal and external entities and that processing of entity references may be required to produce the correct replacement text."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/012.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_013


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that whitespace is handled by adding a single whitespace to the normalized value in the attribute list. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/013.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_ext_sa_014


	"Sections: 4.1 4.4.3 [68]"
	"Description: 
    Test demonstrates use of characters outside of normal ASCII range."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/ext-sa/014.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:38 / janfrog"
!

test_valid_not_sa_001


	"Sections: 4.2.2 [75]"
	"Description: 
    Test demonstrates the use of an ExternalID within a document type definition. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/001.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_002


	"Sections: 4.2.2 [75]"
	"Description: 
    Test demonstrates the use of an ExternalID within a document type definition. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/002.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_003


	"Sections: 4.1 [69]"
	"Description: 
    Test demonstrates the expansion of an external parameter entity that declares an attribute. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/003.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_004


	"Sections: 4.1 [69]"
	"Description: 
    Expands an external parameter entity in two different ways,
    with one of them declaring an attribute."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/004.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_005


	"Sections: 4.1 [69]"
	"Description: 
    Test demonstrates the expansion of an external parameter entity that declares an attribute. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/005.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_006


	"Sections: 3.3 [52]"
	"Description: 
    Test demonstrates that when more than one definition is provided for the same attribute of a given element type only the first declaration is binding. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/006.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_not_sa_007


	"Sections: 3.3 [52]"
	"Description: 
    Test demonstrates the use of an Attribute list declaration within an external entity. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/007.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_008


	"Sections: 4.2.2 [75]"
	"Description: 
    Test demonstrates that an external identifier may include a public identifier. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/008.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_009


	"Sections: 4.2.2 [75]"
	"Description: 
    Test demonstrates that an external identifier may include a public identifier. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/009.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_010


	"Sections: 3.3 [52]"
	"Description: 
    Test demonstrates that when more that one definition is provided for the same attribute of a given element type only the first declaration is binding. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/010.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_011


	"Sections: 4.2 4.2.1 [72] [75]"
	"Description: 
    Test demonstrates a parameter entity declaration whose parameter entity definition is an ExternalID. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/011.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_012


	"Sections: 4.3.1 [77]"
	"Description: 
    Test demonstrates an enternal parsed entity that begins with a text declaration. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/012.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_013


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditional section INCLUDE that will include its contents as part of the DTD. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/013.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_014


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditional section INCLUDE that will include its contents as part of the DTD.  The keyword is a parameter-entity reference. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/014.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:35 / janfrog"
!

test_valid_not_sa_015


	"Sections: 3.4 [63]"
	"Description: 
    Test demonstrates the use of the conditonal section IGNORE the will ignore its content from being part of the DTD.  The keyword is a parameter-entity reference. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/015.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_016


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditional section INCLUDE that will include its contents as part of the DTD.  The keyword is a parameter-entity reference."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/016.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_017


	"Sections: 4.2 [72]"
	"Description: 
    Test demonstrates a parameter entity declaration that contains an attribute list declaration. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/017.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_018


	"Sections: 4.2.2 [75]"
	"Description: 
    Test demonstrates an EnternalID whose contents contain an parameter entity declaration and a attribute list definition. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/018.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_019


	"Sections: 4.4.8"
	"Description: 
    Test demonstrates that a parameter entity will be expanded with spaces on either side. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/019.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_020


	"Sections: 4.4.8"
	"Description: 
    Parameter entities expand with spaces on either side."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/020.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_021


	"Sections: 4.2 [72]"
	"Description: 
    Test demonstrates a parameter entity declaration that contains a partial attribute list declaration. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/021.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_023


	"Sections: 2.3 4.1 [10] [69]"
	"Description: 
    Test demonstrates the use of a parameter entity reference within an attribute list declaration.
"


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/023.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_024


	"Sections: 2.8, 4.1 [69]"
	"Description: 
    Constructs an <iATTLIST...> declaration from several PEs."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/024.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_025


	"Sections: 4.2"
	"Description: 
    Test demonstrates that when more that one definition is provided for the same entity only the first declaration is binding. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/025.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:36 / janfrog"
!

test_valid_not_sa_026


	"Sections: 3.3 [52]"
	"Description: 
    Test demonstrates that when more that one definition is provided for the same attribute of a given element type only the first declaration is binding. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/026.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_not_sa_027


	"Sections: 4.1 [69]"
	"Description: 
    Test demonstrates a parameter entity reference whose value is NULL. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/027.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_not_sa_028


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditional section INCLUDE that will include its contents. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/028.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_not_sa_029


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditonal section IGNORE the will ignore its content from being used. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/029.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_not_sa_030


	"Sections: 3.4 [62]"
	"Description: 
    Test demonstrates the use of the conditonal section IGNORE the will ignore its content from being used. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/030.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_not_sa_031


	"Sections: 2.7"
	"Description: 
    Expands a general entity which contains a CDATA section with
    what looks like a markup declaration (but is just text since
    it's in a CDATA section)."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/not-sa/031.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:37 / janfrog"
!

test_valid_sa_001


	"Sections: 3.2.2 [51]"
	"Description: 
    Test demonstrates an Element Type Declaration with Mixed Content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/001.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_002


	"Sections: 3.1 [40]"
	"Description: 
    Test demonstrates that whitespace is permitted after the tag name in a Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/002.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_003


	"Sections: 3.1 [42]"
	"Description: 
    Test demonstrates that whitespace is permitted after the tag name in an End-tag."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/003.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_004


	"Sections: 3.1 [41]"
	"Description: 
    Test demonstrates a valid attribute specification within a Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/004.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_005


	"Sections: 3.1 [40]"
	"Description: 
    Test demonstrates a valid attribute specification within a Start-tag that
contains whitespace on both sides of the equal sign. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/005.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_006


	"Sections: 3.1 [41]"
	"Description: 
    Test demonstrates that the AttValue within a Start-tag can use a single quote as a delimter. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/006.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:24 / janfrog"
!

test_valid_sa_007


	"Sections: 3.1 4.6 [43]"
	"Description: 
    Test demonstrates numeric character references can be used for element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/007.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_008


	"Sections: 2.4 3.1 [43]"
	"Description: 
    Test demonstrates character references can be used for element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/008.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_009


	"Sections: 2.3 3.1 [43]"
	"Description: 
    Test demonstrates that PubidChar can be used for element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/009.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_010


	"Sections: 3.1 [40]"
	"Description: 
    Test demonstrates that whitespace is valid after the Attribute in a Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/010.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_011


	"Sections: 3.1 [40]"
	"Description: 
    Test demonstrates mutliple Attibutes within the Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/011.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_012


	"Sections: 2.3 [4]"
	"Description: 
    Uses a legal XML 1.0 name consisting of a single colon
    character (disallowed by the latest XML Namespaces draft)."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/012.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_013


	"Sections: 2.3 3.1 [13] [40]"
	"Description: 
    Test demonstrates that the Attribute in a Start-tag can consist of numerals along with special characters. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/013.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_014


	"Sections: 2.3 3.1 [13] [40]"
	"Description: 
    Test demonstrates that all lower case letters are valid for the Attribute in a Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/014.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_015


	"Sections: 2.3 3.1 [13] [40]"
	"Description: 
    Test demonstrates that all upper case letters are valid for the Attribute in a Start-tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/015.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_016


	"Sections: 2.6 3.1 [16] [43]"
	"Description: 
    Test demonstrates that Processing Instructions are valid element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/016.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_017


	"Sections: 2.6 3.1 [16] [43]"
	"Description: 
    Test demonstrates that Processing Instructions are valid element content and there can be more than one. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/017.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_018


	"Sections: 2.7 3.1 [18] [43]"
	"Description: 
    Test demonstrates that CDATA sections are valid element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/018.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_019


	"Sections: 2.7 3.1 [18] [43]"
	"Description: 
    Test demonstrates that CDATA sections are valid element content and that
ampersands may occur in their literal form. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/019.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_020


	"Sections: 2.7 3.1 [18] [43]"
	"Description: 
   Test demonstractes that CDATA sections are valid element content and that
everyting between the CDStart and CDEnd is recognized as character data not markup.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/020.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_021


	"Sections: 2.5 3.1 [15] [43]"
	"Description: 
    Test demonstrates that comments are valid element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/021.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:25 / janfrog"
!

test_valid_sa_022


	"Sections: 2.5 3.1 [15] [43]"
	"Description: 
    Test demonstrates that comments are valid element content and that all characters before the double-hypen right angle combination are considered part of thecomment. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/022.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_023


	"Sections: 3.1 [43]"
	"Description: 
    Test demonstrates that Entity References are valid element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/023.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_024


	"Sections: 3.1 4.1 [43] [66]"
	"Description: 
    Test demonstrates that Entity References are valid element content and also demonstrates a valid Entity Declaration. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/024.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_025


	"Sections: 3.2 [46]"
	"Description: 
    Test demonstrates an Element Type Declaration and that the contentspec can be of mixed content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/025.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_026


	"Sections: 3.2 [46]"
	"Description: 
    Test demonstrates an Element Type Declaration and that EMPTY is a valid contentspec. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/026.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_027


	"Sections: 3.2 [46]"
	"Description: 
    Test demonstrates an Element Type Declaration and that ANY is a valid contenspec. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/027.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_028


	"Sections: 2.8 [24]"
	"Description: 
    Test demonstrates a valid prolog that uses double quotes as delimeters around the VersionNum. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/028.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_029


	"Sections: 2.8 [24]"
	"Description: 
    Test demonstrates a valid prolog that uses single quotes as delimters around the VersionNum. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/029.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_030


	"Sections: 2.8 [25]"
	"Description: 
    Test demonstrates a valid prolog that contains whitespace on both sides of the equal sign in the VersionInfo. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/030.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_031


	"Sections: 4.3.3 [80]"
	"Description: 
    Test demonstrates a valid EncodingDecl within the prolog. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/031.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_032


	"Sections: 2.9 [32]"
	"Description: 
    Test demonstrates a valid SDDecl within the prolog. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/032.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_033


	"Sections: 2.8 [23]"
	"Description: 
    Test demonstrates that both a EncodingDecl and SDDecl are valid within the prolog. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/033.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_034


	"Sections: 3.1 [44]"
	"Description: 
    Test demonstrates the correct syntax for an Empty element tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/034.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_035


	"Sections: 3.1 [44]"
	"Description: 
    Test demonstrates that whitespace is permissible after the name in an Empty element tag. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/035.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:26 / janfrog"
!

test_valid_sa_036


	"Sections: 2.6 [16]"
	"Description: 
    Test demonstrates a valid processing instruction. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/036.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_037


	"Sections: 2.6 [15]"
	"Description: 
    Test demonstrates a valid comment and that it may appear anywhere in the document including at the end. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/037.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_038


	"Sections: 2.6 [15]"
	"Description: 
    Test demonstrates a valid comment and that it may appear anywhere in the document including the beginning. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/038.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_039


	"Sections: 2.6 [16]"
	"Description: 
    Test demonstrates a valid processing instruction and that it may appear at the beginning of the document. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/039.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_040


	"Sections: 3.3 3.3.1 [52] [54]"
	"Description: 
    Test demonstrates an Attribute List declaration that uses a StringType as the AttType. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/040.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_041


	"Sections: 3.3.1 4.1 [54] [66]"
	"Description: 
    Test demonstrates an Attribute List declaration that uses a StringType as the AttType and also expands the CDATA attribute with a character reference. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/041.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_042


	"Sections: 3.3.1 4.1 [54] [66]"
	"Description: 
    Test demonstrates an Attribute List declaration that uses a StringType as the AttType and also expands the CDATA attribute with a character reference.  The test also shows that the leading zeros in the character reference are ignored. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/042.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_043


	"Sections: 3.3"
	"Description: 
    An element's attributes may be declared before its content
    model; and attribute values may contain newlines.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/043.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_044


	"Sections: 3.1 [44]"
	"Description: 
    Test demonstrates that the empty-element tag must be use for an elements that are declared EMPTY. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/044.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_045


	"Sections: 3.3 [52]"
	"Description: 
    Tests whether more than one definition can be provided for the same attribute of a given element type with the first declaration being binding. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/045.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_046


	"Sections: 3.3 [52]"
	"Description: 
    Test demonstrates that when more than one AttlistDecl is provided for a given element type, the contents of all those provided are merged. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/046.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_047


	"Sections: 3.1 [43]"
	"Description: 
    Test demonstrates that extra whitespace is normalized into single space character. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/047.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_048


	"Sections: 2.4 3.1 [14] [43]"
	"Description: 
    Test demonstrates that character data is valid element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/048.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:27 / janfrog"
!

test_valid_sa_049


	"Sections: 2.2 [2]"
	"Description: 
    Test demonstrates that characters outside of normal ascii range can be used as element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/049.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_050


	"Sections: 2.2 [2]"
	"Description: 
    Test demonstrates that characters outside of normal ascii range can be used as element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/050.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_051


	"Sections: 2.2 [2]"
	"Description: 
    The document is encoded in UTF-16 and uses some name
    characters well outside of the normal ASCII range.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/051.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_052


	"Sections: 2.2 [2]"
	"Description: 
    The document is encoded in UTF-8 and the text inside the
    root element uses two non-ASCII characters, encoded in UTF-8
    and each of which expands to a Unicode surrogate pair."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/052.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_053


	"Sections: 4.4.2"
	"Description: 
    Tests inclusion of a well-formed internal entity, which
    holds an element required by the content model."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/053.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_054


	"Sections: 3.1 [40] [42]"
	"Description: 
    Test demonstrates that extra whitespace within Start-tags and End-tags are nomalized into single spaces. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/054.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_055


	"Sections: 2.6 2.10 [16]"
	"Description: 
    Test demonstrates that extra whitespace within a processing instruction willnormalized into s single space character. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/055.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_056


	"Sections: 3.3.1 4.1 [54] [66]"
	"Description: 
    Test demonstrates an Attribute List declaration that uses a StringType as the AttType and also expands the CDATA attribute with a character reference.  The test also shows that the leading zeros in the character reference are ignored. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/056.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_057


	"Sections: 3.2.1 [47]"
	"Description: 
    Test demonstrates an element content model whose element can occur zero or more times. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/057.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_058


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that extra whitespace be normalized into a single space character in an attribute of type NMTOKENS. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/058.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:28 / janfrog"
!

test_valid_sa_059


	"Sections: 3.2 3.3 [46] [53]"
	"Description: 
    Test demonstrates an Element Type Declaration that uses the contentspec of EMPTY.  The element cannot have any contents and must always appear as an empty element in the document.  The test also shows an Attribute-list declaration with multiple AttDef's. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/059.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_060


	"Sections: 4.1 [66]"
	"Description: 
    Test demonstrates the use of decimal Character References within element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/060.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_061


	"Sections: 4.1 [66]"
	"Description: 
    Test demonstrates the use of decimal Character References within element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/061.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_062


	"Sections: 4.1 [66]"
	"Description: 
    Test demonstrates the use of hexadecimal Character References within element.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/062.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_063


	"Sections: 2.3 [5]"
	"Description: 
    The document is encoded in UTF-8 and the name of the
    root element type uses non-ASCII characters.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/063.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_064


	"Sections: 4.1 [66]"
	"Description: 
    Tests in-line handling of two legal character references, which
    each expand to a Unicode surrogate pair."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/064.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_065


	"Sections: 4.5"
	"Description: 
    Tests ability to define an internal entity which can't
    legally be expanded (contains an unquoted "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/065.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_066


	"Sections: 4.1 [66]"
	"Description: 
    Expands a CDATA attribute with a character reference."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/066.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_067


	"Sections: 4.1 [66]"
	"Description: 
    Test demonstrates the use of decimal character references within element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/067.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_068


	"Sections: 2.11, 4.5"
	"Description: 
    Tests definition of an internal entity holding a carriage return character
    reference, which must not be normalized before reporting to the application.  Line 
    break normalization only occurs when parsing external parsed entities."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/068.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_069


	"Sections: 4.7"
	"Description: 
    Verifies that an XML parser will parse a NOTATION
    declaration; the output phase of this test ensures that
    it's reported to the application. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/069.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_070


	"Sections: 4.4.8"
	"Description: 
    Verifies that internal parameter entities are correctly
    expanded within the internal subset."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/070.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_071


	"Sections: 3.3 3.3.1 [52] [56]"
	"Description: 
    Test demonstrates that an AttlistDecl can use ID as the TokenizedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/071.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_072


	"Sections: 3.3 3.3.1 [52] [56]"
	"Description: 
    Test demonstrates that an AttlistDecl can use IDREF as the TokenizedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/072.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:29 / janfrog"
!

test_valid_sa_073


	"Sections: 3.3 3.3.1 [52] [56]"
	"Description: 
    Test demonstrates that an AttlistDecl can use IDREFS as the TokenizedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/073.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_074


	"Sections: 3.3 3.3.1 [52] [56]"
	"Description: 
    Test demonstrates that an AttlistDecl can use ENTITY as the TokenizedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/074.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_075


	"Sections: 3.3 3.3.1 [52] [56]"
	"Description: 
    Test demonstrates that an AttlistDecl can use ENTITIES as the TokenizedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/075.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_076


	"Sections: 3.3.1"
	"Description: 
    Verifies that an XML parser will parse a NOTATION
    attribute; the output phase of this test ensures that
    both notations are reported to the application. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/076.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_077


	"Sections: 3.3 3.3.1 [52] [54]"
	"Description: 
    Test demonstrates that an AttlistDecl can use an EnumeratedType within the Attribute type.  The test also shows that IMPLIED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/077.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_078


	"Sections: 3.3 3.3.1 [52] [54]"
	"Description: 
    Test demonstrates that an AttlistDecl can use an StringType of CDATA within the Attribute type.  The test also shows that REQUIRED is a valid DefaultDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/078.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_079


	"Sections: 3.3 3.3.2 [52] [60]"
	"Description: 
    Test demonstrates that an AttlistDecl can use an StringType of CDATA within the Attribute type.  The test also shows that FIXED is a valid DefaultDecl and that a value can be given to the attribute in the Start-tag as well as the AttListDecl. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/079.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_080


	"Sections: 3.3 3.3.2 [52] [60]"
	"Description: 
    Test demonstrates that an AttlistDecl can use an StringType of CDATA within the Attribute type.  The test also shows that FIXED is a valid DefaultDecl and that an value can be given to the attribute. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/080.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_081


	"Sections: 3.2.1 [50]"
	"Description: 
    Test demonstrates the use of the optional character following a name or list  to govern the number of times an element or content particles in the list occur. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/081.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_082


	"Sections: 4.2 [72]"
	"Description: 
    Tests that an external PE may be defined (but not referenced)."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/082.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_083


	"Sections: 4.2 [72]"
	"Description: 
    Tests that an external PE may be defined (but not referenced)."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/083.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_084


	"Sections: 2.10"
	"Description: 
    Test demonstrates that although whitespace can be used to set apart markup for greater readability it is not necessary. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/084.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:30 / janfrog"
!

test_valid_sa_085


	"Sections: 4"
	"Description: 
    Parameter and General entities use different namespaces,
    so there can be an entity of each type with a given name."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/085.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_086


	"Sections: 4.2"
	"Description: 
    Tests whether entities may be declared more than once,
    with the first declaration being the binding one. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/086.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_087


	"Sections: 4.5"
	"Description: 
    Tests whether character references in internal entities are
    expanded early enough, by relying on correct handling to
    make the entity be well formed."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/087.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_088


	"Sections: 4.5"
	"Description: 
    Tests whether entity references in internal entities are
    expanded late enough, by relying on correct handling to
    make the expanded text be valid.  (If it's expanded too
    early, the entity will parse as an element that's not
    valid in that context.)"


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/088.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_089


	"Sections: 4.1 [66]"
	"Description: 
    Tests entity expansion of three legal character references,
    which each expand to a Unicode surrogate pair."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/089.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_090


	"Sections: 3.3.1"
	"Description: 
    Verifies that an XML parser will parse a NOTATION
    attribute; the output phase of this test ensures that
    the notation is reported to the application. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/090.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_091


	"Sections: 3.3.1"
	"Description: 
    Verifies that an XML parser will parse an ENTITY
    attribute; the output phase of this test ensures that
    the notation is reported to the application, and for
    validating parsers it further tests that the entity
    is so reported."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/091.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_092


	"Sections: 2.3 2.10"
	"Description: 
    Test demostrates that extra whitespace is normalized into a single space character. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/092.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_093


	"Sections: 2.10"
	"Description: 
    Test demonstrates that extra whitespace is not intended for inclusion in the delivered version of the document. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/093.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_094


	"Sections: 2.8"
	"Description: 
    Attribute defaults with a DTD have special parsing rules, different
    from other strings.  That means that characters found there may look
    like an undefined parameter entity reference `within a markup
    declaration`, but they aren't ... so they can't be violating
    the "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/094.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:31 / janfrog"
!

test_valid_sa_095


	"Sections: 3.3.3"
	"Description: 
    Basically an output test, this requires extra whitespace
    to be normalized into a single space character in an
    attribute of type NMTOKENS."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/095.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_096


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that extra whitespace is normalized into a single space character in an attribute of type NMTOKENS. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/096.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_097


	"Sections: 3.3"
	"Description: 
    Basically an output test, this tests whether an externally
    defined attribute declaration (with a default) takes proper
    precedence over a subsequent internal declaration."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/097.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_098


	"Sections: 2.6 2.10 [16]"
	"Description: 
    Test demonstrates that extra whitespace within a processing instruction is converted into a single space character."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/098.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_099


	"Sections: 4.3.3 [81]"
	"Description: 
    Test demonstrates the name of the encoding can be composed of lowercase characters. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/099.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_100


	"Sections: 2.3 [12]"
	"Description: 
    Makes sure that PUBLIC identifiers may have some strange
    characters.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/100.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_101


	"Sections: 4.5"
	"Description: 
    This tests whether entity expansion is (incorrectly) done
    while processing entity declarations; if it is, the entity
    value literal will terminate prematurely."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/101.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_102


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that a CDATA attribute can pass a double quote as its value. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/102.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_103


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that an attribute can pass a less than sign as its value. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/103.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_104


	"Sections: 3.1 [40]"
	"Description: 
    Test demonstrates that extra whitespace within an Attribute of a Start-tag is normalized to a single space character. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/104.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_105


	"Sections: 3.3.3"
	"Description: 
    Basically an output test, this requires a CDATA attribute
    with a tab character to be passed through as one space."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/105.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_106


	"Sections: 3.3.3"
	"Description: 
    Basically an output test, this requires a CDATA attribute
    with a newline character to be passed through as one space."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/106.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:32 / janfrog"
!

test_valid_sa_107


	"Sections: 3.3.3"
	"Description: 
    Basically an output test, this requires a CDATA attribute
    with a return character to be passed through as one space."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/107.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_108


	"Sections: 2.11, 3.3.3"
	"Description: 
    This tests normalization of end-of-line characters (CRLF)
    within entities to LF, primarily as an output test. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/108.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_109


	"Sections: 2.3 3.1 [10][40][41]"
	"Description: 
    Test demonstrates that an attribute can have a null value. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/109.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_110


	"Sections: 3.3.3"
	"Description: 
    Basically an output test, this requires that a CDATA
    attribute with a CRLF be normalized to one space."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/110.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_111


	"Sections: 3.3.3"
	"Description: 
    Character references expanding to spaces doesn't affect
    treatment of attributes. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/111.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_112


	"Sections: 3.2.1 [48][49]"
	"Description: 
    Test demonstrates shows the use of content particles within the element content. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/112.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_113


	"Sections: 3.3 [52][53]"
	"Description: 
     Test demonstrates that it is not an error to have attributes declared for an element not itself declared."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/113.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_114


	"Sections: 2.7 [20]"
	"Description: 
    Test demonstrates that all text within a valid CDATA section is considered text and not recognized as markup. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/114.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_115


	"Sections: 3.3.3"
	"Description: 
    Test demonstrates that an entity reference is processed by recursively processing the replacement text of the entity. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/115.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:33 / janfrog"
!

test_valid_sa_116


	"Sections: 2.11"
	"Description: 
    Test demonstrates that a line break within CDATA will be normalized. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/116.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_sa_117


	"Sections: 4.5"
	"Description: 
    Test demonstrates that entity expansion is done while processing entity declarations.  "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/117.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_sa_118


	"Sections: 4.5"
	"Description: 
    Test demonstrates that entity expansion is done while processing entity declarations. "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/118.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
!

test_valid_sa_119


	"Sections: 2.5"
	"Description: 
    Comments may contain any legal XML characters;
    only the string `--` is disallowed."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'xmltest/valid/sa/119.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:34 / janfrog"
! !

!JamesClarkXMLTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__JamesClarkXMLTests.st,v 1.1.1.1 2005-11-01 22:05:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

