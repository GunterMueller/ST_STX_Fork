"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#OASISXMLTests
	instanceVariableNames:'doc'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests W3C'
!


!OASISXMLTests methodsFor:'accessing'!

resources
   ^Array with:W3XMLTestSuiteResource

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
! !

!OASISXMLTests methodsFor:'tests'!

test_o_e2


	"Sections: 3.3.1 [58] [59] Errata [E2]"
	"Description: 
      Validity Constraint:  No duplicate tokens 
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/e2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p01fail1


	"Sections: 2.1 [1]"
	"Description: 
     S cannot occur before the prolog
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p01fail2


	"Sections: 2.1 [1]"
	"Description: 
     comments cannot occur before the prolog
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p01fail3


	"Sections: 2.1 [1]"
	"Description: 
     only one document element
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p01fail4


	"Sections: 2.1 [1]"
	"Description: 
     document element must be complete.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p01pass1


	"Sections: 2.1 [1]"
	"Description: 
     no prolog
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p01pass2


	"Sections: 2.2 [1]"
	"Description: 
     various Misc items where they can occur
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p01pass3


	"Sections: 2.1 [1]"
	"Description: 
     Misc items after the document
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p01pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p02fail1


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail10


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail10.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail11


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail11.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail12


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail12.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail13


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail13.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail14


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail14.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail15


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail15.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail16


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail16.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail17


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail17.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail18


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail18.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail19


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail19.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail2


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail20


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail20.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail21


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail21.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail22


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail22.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:57 / janfrog"
!

test_o_p02fail23


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail23.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail24


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail24.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail25


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail25.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail26


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail26.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail27


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail27.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail28


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail28.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail29


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail29.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail3


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail30


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail30.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail31


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail31.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail4


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail5


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail6


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail7


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail7.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail8


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail8.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p02fail9


	"Sections: 2.2 [2]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p02fail9.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p03fail1


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p03fail10


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail10.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:58 / janfrog"
!

test_o_p03fail11


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail11.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail12


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail12.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail13


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail13.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail14


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail14.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail15


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail15.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail16


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail16.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail17


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail17.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail18


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail18.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail19


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail19.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail2


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail20


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail20.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail21


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail21.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail22


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail22.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail23


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail23.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail24


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail24.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail25


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail25.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail26


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail26.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail27


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail27.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail28


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail28.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail29


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail29.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:58:59 / janfrog"
!

test_o_p03fail3


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03fail4


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03fail5


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03fail7


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail7.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03fail8


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail8.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03fail9


	"Sections: 2.3 [3]"
	"Description: 
    Use of illegal character within XML document.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03fail9.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p03pass1


	"Sections: 2.3 [3]"
	"Description: 
     all valid S characters
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p03pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p04fail1


	"Sections: 2.3 [4]"
	"Description: 
    Name contains invalid character.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p04fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p04fail2


	"Sections: 2.3 [4]"
	"Description: 
    Name contains invalid character.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p04fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p04fail3


	"Sections: 2.3 [4]"
	"Description: 
    Name contains invalid character.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p04fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p04pass1


	"Sections: 2.3 [4]"
	"Description: 
     names with all valid ASCII characters, and one from each
              other class in NameChar
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p04pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p05fail1


	"Sections: 2.3 [5]"
	"Description: 
     a Name cannot start with a digit
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p05fail2


	"Sections: 2.3 [5]"
	"Description: 
     a Name cannot start with a '.'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p05fail3


	"Sections: 2.3 [5]"
	"Description: 
     a Name cannot start with a `-`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p05fail4


	"Sections: 2.3 [5]"
	"Description: 
     a Name cannot start with a CombiningChar
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p05fail5


	"Sections: 2.3 [5]"
	"Description: 
     a Name cannot start with an Extender
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p05pass1


	"Sections: 2.3 [5]"
	"Description: 
     various valid Name constructions
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p05pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p06fail1


	"Sections: 2.3 [6]"
	"Description: 
     Requires at least one name.
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p06fail1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p06pass1


	"Sections: 2.3 [6]"
	"Description: 
     various satisfactions of the Names production in a NAMES
    attribute
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p06pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p07pass1


	"Sections: 2.3 [7]"
	"Description: 
     various valid Nmtoken 's in an attribute list declaration.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p07pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p08fail1


	"Sections: 2.3 [8]"
	"Description: 
     at least one Nmtoken is required.
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p08fail1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p08fail2


	"Sections: 2.3 [8]"
	"Description: 
     an invalid Nmtoken character.
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p08fail2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p08pass1


	"Sections: 2.3 [8]"
	"Description: 
     various satisfaction of an NMTOKENS attribute value.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p08pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p09fail1


	"Sections: 2.3 [9]"
	"Description: 
     EntityValue excludes '%'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p09fail2


	"Sections: 2.3 [9]"
	"Description: 
     EntityValue excludes '&'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p09fail3


	"Sections: 2.3 [9]"
	"Description: 
     incomplete character reference
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p09fail4


	"Sections: 2.3 [9]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p09fail5


	"Sections: 2.3 [9]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p09pass1


	"Sections: 2.3 [9]"
	"Description: 
     valid EntityValue's.  Except for entity references,
              markup is not recognized.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p09pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p10fail1


	"Sections: 2.3 [10]"
	"Description: 
     attribute values exclude '<'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p10fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p10fail2


	"Sections: 2.3 [10]"
	"Description: 
     attribute values exclude '&'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p10fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p10fail3


	"Sections: 2.3 [10]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p10fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:00 / janfrog"
!

test_o_p10pass1


	"Sections: 2.3 [10]"
	"Description: 
     valid attribute values
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p10pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p11fail1


	"Sections: 2.3 [11]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p11fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p11fail2


	"Sections: 2.3 [11]"
	"Description: 
     cannot contain delimiting quotes
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p11fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p11pass1


	"Sections: 2.3, 4.2.2 [11]"
	"Description: 
     system literals may not contain
    URI fragments
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p11pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:59:10 / janfrog"
!

test_o_p12fail1


	"Sections: 2.3 [12]"
	"Description: 
     '`' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail2


	"Sections: 2.3 [12]"
	"Description: 
     '\' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail3


	"Sections: 2.3 [12]"
	"Description: 
     entity references excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail4


	"Sections: 2.3 [12]"
	"Description: 
     '>' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail5


	"Sections: 2.3 [12]"
	"Description: 
     '<' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail6


	"Sections: 2.3 [12]"
	"Description: 
     built-in entity refs excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12fail7


	"Sections: 2.3 [13]"
	"Description: 
      The public ID has a tab character, which is disallowed
     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12fail7.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p12pass1


	"Sections: 2.3 [12]"
	"Description: 
     valid public IDs.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p12pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p14fail1


	"Sections: 2.4 [14]"
	"Description: 
     '<' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p14fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p14fail2


	"Sections: 2.4 [14]"
	"Description: 
     '&' excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p14fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p14fail3


	"Sections: 2.4 [14]"
	"Description: 
     `]]>` excluded
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p14fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p14pass1


	"Sections: 2.4 [14]"
	"Description: 
     valid CharData
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p14pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p15fail1


	"Sections: 2.5 [15]"
	"Description: 
     comments can't end in '-'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p15fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p15fail2


	"Sections: 2.5 [15]"
	"Description: 
     one comment per comment (contrasted with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p15fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p15fail3


	"Sections: 2.5 [15]"
	"Description: 
     can't include 2 or more adjacent '-'s
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p15fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p15pass1


	"Sections: 2.5 [15]"
	"Description: 
     valid comments
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p15pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p16fail1


	"Sections: 2.6 [16]"
	"Description: 
     `xml` is an invalid PITarget
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p16fail2


	"Sections: 2.6 [16]"
	"Description: 
     a PITarget must be present
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p16fail3


	"Sections: 2.6 [16]"
	"Description: 
     S after PITarget is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p16pass1


	"Sections: 2.6 [16] [17]"
	"Description: 
    Valid form of Processing Instruction. Shows that whitespace character data is valid before end of processing instruction.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p16pass2


	"Sections: 2.6 [16]"
	"Description: 
    Valid form of Processing Instruction. Shows that whitespace character data is valid before end of processing instruction.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p16pass3


	"Sections: 2.6 [16]"
	"Description: 
    Valid form of Processing Instruction. Shows that whitespace character data is valid before end of processing instruction.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p16pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p18fail1


	"Sections: 2.7 [18]"
	"Description: 
     no space before `CDATA`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p18fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p18fail2


	"Sections: 2.7 [18]"
	"Description: 
     no space after `CDATA`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p18fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p18fail3


	"Sections: 2.7 [18]"
	"Description: 
     CDSect's can't nest
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p18fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p18pass1


	"Sections: 2.7 [18]"
	"Description: 
     valid CDSect's.  Note that a CDStart in a CDSect is not
              recognized as such
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p18pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p22fail1


	"Sections: 2.8 [22]"
	"Description: 
     prolog must start with XML decl
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:01 / janfrog"
!

test_o_p22fail2


	"Sections: 2.8 [22]"
	"Description: 
     prolog must start with XML decl
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p22pass1


	"Sections: 2.8 [22]"
	"Description: 
     prolog can be empty
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p22pass2


	"Sections: 2.8 [22]"
	"Description: 
     XML declaration only
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p22pass3


	"Sections: 2.8 [22]"
	"Description: 
     XML decl and Misc
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p22pass4


	"Sections: 2.8 [22]"
	"Description: 
     XML decl and doctypedecl
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p22pass5


	"Sections: 2.8 [22]"
	"Description: 
     just doctypedecl
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass5.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p22pass6


	"Sections: 2.8 [22]"
	"Description: 
     S between decls is not required
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p22pass6.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:52 / janfrog"
!

test_o_p23fail1


	"Sections: 2.8 [23]"
	"Description: 
     `xml` must be lower-case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p23fail2


	"Sections: 2.8 [23]"
	"Description: 
     VersionInfo must be supplied
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p23fail3


	"Sections: 2.8 [23]"
	"Description: 
     VersionInfo must come first
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p23fail4


	"Sections: 2.8 [23]"
	"Description: 
     SDDecl must come last
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p23fail5


	"Sections: 2.8 [23]"
	"Description: 
     no SGML-type PIs
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p23pass1


	"Sections: 2.8 [23]"
	"Description: 
    Test shows a valid XML declaration along with version info.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p23pass2


	"Sections: 2.8 [23]"
	"Description: 
    Test shows a valid XML declaration along with encoding declaration.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p23pass3


	"Sections: 2.8 [23]"
	"Description: 
    Test shows a valid XML declaration along with Standalone Document Declaration.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p23pass4


	"Sections: 2.8 [23]"
	"Description: 
    Test shows a valid XML declaration, encoding declarationand Standalone Document Declaration.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p23pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p24fail1


	"Sections: 2.8 [24]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p24fail2


	"Sections: 2.8 [24]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p24pass1


	"Sections: 2.8 [24]"
	"Description: 
    Test shows a prolog that has the VersionInfo delimited by double quotes.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p24pass2


	"Sections: 2.8 [24]"
	"Description: 
    Test shows a prolog that has the VersionInfo delimited by single quotes.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p24pass3


	"Sections: 2.8 [24]"
	"Description: 
    Test shows whitespace is allowed in prolog before version info.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p24pass4


	"Sections: 2.8 [24]"
	"Description: 
    Test shows whitespace is allowed in prolog on both sides of equal sign.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p24pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p25fail1


	"Sections: 2.8 [25]"
	"Description: 
    Comment is illegal in VersionInfo.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p25fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p25pass1


	"Sections: 2.8 [25]"
	"Description: 
    Test shows whitespace is NOT necessary before or after equal sign of versioninfo.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p25pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p25pass2


	"Sections: 2.8 [25]"
	"Description: 
    Test shows whitespace can be used on both sides of equal sign of versioninfo.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p25pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p26fail1


	"Sections: 2.8 [26]"
	"Description: 
    Illegal character in VersionNum.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p26fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p26fail2


	"Sections: 2.8 [26]"
	"Description: 
    Illegal character in VersionNum.     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p26fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p26pass1


	"Sections: 2.8 [26]"
	"Description: 
     The valid version number.  We cannot test others because
              a 1.0 processor is allowed to fail them.
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p26pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p27fail1


	"Sections: 2.8 [27]"
	"Description: 
     References aren't allowed in Misc,
    even if they would resolve to valid Misc.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p27fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p27pass1


	"Sections: 2.8 [27]"
	"Description: 
    Comments are valid as the Misc part of the prolog.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p27pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p27pass2


	"Sections: 2.8 [27]"
	"Description: 
    Processing Instructions are valid as the Misc part of the prolog.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p27pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p27pass3


	"Sections: 2.8 [27]"
	"Description: 
    Whitespace is valid as the Misc part of the prolog.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p27pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p27pass4


	"Sections: 2.8 [27]"
	"Description: 
    A combination of comments, whitespaces and processing instructions are valid as the Misc part of the prolog.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p27pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:55 / janfrog"
!

test_o_p28fail1


	"Sections: 2.8 [28]"
	"Description: 
     only declarations in DTD.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p28fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p28pass1


	"Sections: 3.1 [43] [44]"
	"Description: 
    Empty-element tag must be used for element which are declared EMPTY.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p28pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p28pass3


	"Sections: 2.8 4.1 [28] [69]"
	"Description: 
    Valid doctypedecl with Parameter entity reference.  The declaration of a parameter entity must precede any reference to it.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p28pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p28pass4


	"Sections: 2.8 4.2.2 [28] [75]"
	"Description: 
    Valid doctypedecl with ExternalID as an External Entity declaration.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p28pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p28pass5


	"Sections: 2.8 4.1 [28] [69]"
	"Description: 
    Valid doctypedecl with ExternalID as an External Entity.  A parameter entity reference is also used.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p28pass5.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p29fail1


	"Sections: 2.8 [29]"
	"Description: 
     A processor must not pass unknown declaration types.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p29fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p29pass1


	"Sections: 2.8 [29]"
	"Description: 
     Valid types of markupdecl.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p29pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p30fail1


	"Sections: 2.8 [30]"
	"Description: 
     An XML declaration is not the same as a TextDecl
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p30fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p30pass1


	"Sections: 2.8 4.2.2 [30] [75]"
	"Description: 
    Valid doctypedecl with ExternalID as an External Entity.  The external entity has an element declaration.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p30pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p30pass2


	"Sections: 2.8 4.2.2 4.3.1 [30] [75] [77]"
	"Description: 
    Valid doctypedecl with ExternalID as an Enternal Entity.  The external entity begins with a Text Declaration.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p30pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p31fail1


	"Sections: 2.8 [31]"
	"Description: 
     external subset excludes doctypedecl
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p31fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p31pass1


	"Sections: 2.8 [31]"
	"Description: 
     external subset can be empty
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p31pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p31pass2


	"Sections: 2.8 3.4 4.2.2 [31] [62] [63] [75]"
	"Description: 
    Valid doctypedecl with EXternalID as Enternal Entity.  The external entity contains a parameter entity reference and condtional sections."


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p31pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p32fail1


	"Sections: 2.9 [32]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p32fail2


	"Sections: 2.9 [32]"
	"Description: 
     quote types must match
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p32fail3


	"Sections: 2.9 [32]"
	"Description: 
     initial S is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p32fail4


	"Sections: 2.9 [32]"
	"Description: 
     quotes are required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p32fail5


	"Sections: 2.9 [32]"
	"Description: 
     yes or no must be lower case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:02 / janfrog"
!

test_o_p32pass1


	"Sections: 2.9 [32]"
	"Description: 
    Double quotes can be used as delimeters for the value of a Standalone Document Declaration.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p32pass2


	"Sections: 2.9 [32]"
	"Description: 
    Single quotes can be used as delimeters for the value of a Standalone Document Declaration.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p32pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p39fail1


	"Sections: 3 [39]"
	"Description: 
     start-tag requires end-tag
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p39fail2


	"Sections: 3 [39]"
	"Description: 
     end-tag requires start-tag
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p39fail3


	"Sections: 3 [39]"
	"Description: 
    XML documents contain one or more elements"


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p39fail4


	"Sections: 2.8 [23]"
	"Description: 
     XML declarations must be correctly terminated "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p39fail5


	"Sections: 2.8 [23]"
	"Description: 
     XML declarations must be correctly terminated "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p39pass1


	"Sections: 3 3.1 [39] [44]"
	"Description: 
    Empty element tag may be used for any element which has no content.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p39pass2


	"Sections: 3 3.1 [39] [43]"
	"Description: 
    Character data is valid element content.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p39pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p40fail1


	"Sections: 3.1 [40]"
	"Description: 
     S is required between attributes
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p40fail2


	"Sections: 3.1 [40]"
	"Description: 
     tags start with names, not nmtokens
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p40fail3


	"Sections: 3.1 [40]"
	"Description: 
     tags start with names, not nmtokens
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p40fail4


	"Sections: 3.1 [40]"
	"Description: 
     no space before name
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p40pass1


	"Sections: 3.1 [40]"
	"Description: 
    Elements content can be empty.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p40pass2


	"Sections: 3.1 [40]"
	"Description: 
    Whitespace is valid within a Start-tag.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p40pass3


	"Sections: 3.1 [40] [41]"
	"Description: 
    Attributes are valid within a Start-tag.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p40pass4


	"Sections: 3.1 [40]"
	"Description: 
    Whitespace and Multiple Attributes are valid within a Start-tag.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p40pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p41fail1


	"Sections: 3.1 [41]"
	"Description: 
     quotes are required (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p41fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p41fail2


	"Sections: 3.1 [41]"
	"Description: 
     attribute name is required (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p41fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p41fail3


	"Sections: 3.1 [41]"
	"Description: 
     Eq required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p41fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p41pass1


	"Sections: 3.1 [41]"
	"Description: 
    Attributes are valid within a Start-tag.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p41pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p41pass2


	"Sections: 3.1 [41]"
	"Description: 
    Whitespace is valid within a Start-tags Attribute.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p41pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p42fail1


	"Sections: 3.1 [42]"
	"Description: 
     no space before name
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p42fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p42fail2


	"Sections: 3.1 [42]"
	"Description: 
     cannot end with `/>`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p42fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p42fail3


	"Sections: 3.1 [42]"
	"Description: 
     no NET (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p42fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p42pass1


	"Sections: 3.1 [42]"
	"Description: 
    Test shows proper syntax for an End-tag.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p42pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p42pass2


	"Sections: 3.1 [42]"
	"Description: 
    Whitespace is valid after name in End-tag.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p42pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p43fail1


	"Sections: 3.1 [43]"
	"Description: 
     no non-comment declarations
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p43fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p43fail2


	"Sections: 3.1 [43]"
	"Description: 
     no conditional sections
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p43fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p43fail3


	"Sections: 3.1 [43]"
	"Description: 
     no conditional sections
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p43fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p43pass1


	"Sections: 2.4 2.5 2.6 2.7 [15] [16] [18]"
	"Description: 
    Valid use of character data, comments, processing instructions and CDATA sections within the start and end tag.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p43pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p44fail1


	"Sections: 3.1 [44]"
	"Description: 
    Illegal space before Empty element tag.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p44fail2


	"Sections: 3.1 [44]"
	"Description: 
    Illegal space after Empty element tag.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:03 / janfrog"
!

test_o_p44fail3


	"Sections: 3.1 [44]"
	"Description: 
    Illegal comment in Empty element tag.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p44fail4


	"Sections: 3.1 [44]"
	"Description: 
    Whitespace required between attributes.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p44fail5


	"Sections: 3.1 [44]"
	"Description: 
    Duplicate attribute name is illegal.    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p44pass1


	"Sections: 3.1 [44]"
	"Description: 
    Valid display of an Empty Element Tag.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p44pass2


	"Sections: 3.1 [44]"
	"Description: 
    Empty Element Tags can contain an Attribute.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44pass2.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p44pass3


	"Sections: 3.1 [44]"
	"Description: 
    Whitespace is valid in an Empty Element Tag following the end of the attribute value.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44pass3.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p44pass4


	"Sections: 3.1 [44]"
	"Description: 
    Whitespace is valid after the name in an Empty Element Tag.     "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44pass4.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p44pass5


	"Sections: 3.1 [44]"
	"Description: 
    Whitespace and Multiple Attributes are valid in an Empty Element Tag.    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p44pass5.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p45fail1


	"Sections: 3.2 [45]"
	"Description: 
     ELEMENT must be upper case.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p45fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p45fail2


	"Sections: 3.2 [45]"
	"Description: 
     S before contentspec is required.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p45fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p45fail3


	"Sections: 3.2 [45]"
	"Description: 
     only one content spec
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p45fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p45fail4


	"Sections: 3.2 [45]"
	"Description: 
     no comments in declarations (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p45fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p45pass1


	"Sections: 3.2 [45]"
	"Description: 
     valid element declarations
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p45pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p46fail1


	"Sections: 3.2 [46]"
	"Description: 
     no parens on declared content
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46fail2


	"Sections: 3.2 [46]"
	"Description: 
     no inclusions (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46fail3


	"Sections: 3.2 [46]"
	"Description: 
     no exclusions (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46fail4


	"Sections: 3.2 [46]"
	"Description: 
     no space before occurrence
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46fail5


	"Sections: 3.2 [46]"
	"Description: 
     single group
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46fail6


	"Sections: 3.2 [46]"
	"Description: 
     can't be both declared and modeled
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p46pass1


	"Sections: 3.2 3.2.1 3.2.2 [45] [46] [47] [51]"
	"Description: 
    Valid use of contentspec, element content models, and mixed content within an element type declaration.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p46pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p47fail1


	"Sections: 3.2.1 [47]"
	"Description: 
    Invalid operator '|' must match previous operator ','"


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p47fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p47fail2


	"Sections: 3.2.1 [47]"
	"Description: 
    Illegal character '-' in Element-content model     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p47fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p47fail3


	"Sections: 3.2.1 [47]"
	"Description: 
    Optional character must follow a name or list     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p47fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p47fail4


	"Sections: 3.2.1 [47]"
	"Description: 
    Illegal space before optional character"


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p47fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p47pass1


	"Sections: 3.2 3.2.1 [45] [46] [47] "
	"Description: 
    Valid use of contentspec, element content models, choices, sequences and content particles within an element type declaration.  The optional character following a name or list governs the number of times the element or content particle may appear.     "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p47pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p48fail1


	"Sections: 3.2.1 [48]"
	"Description: 
    Illegal space before optional character    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p48fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:04 / janfrog"
!

test_o_p48fail2


	"Sections: 3.2.1 [48]"
	"Description: 
    Illegal space before optional character     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p48fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p48pass1


	"Sections: 3.2 3.2.1 [45] [46] [47]"
	"Description: 
    Valid use of contentspec, element content models, choices, sequences and content particles within an element type declaration.  The optional character following a name or list governs the number of times the element or content particle may appear.    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p48pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p49fail1


	"Sections: 3.2.1 [49]"
	"Description: 
    connectors must match     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p49fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p49pass1


	"Sections: 3.2 3.2.1 [45] [46] [47]"
	"Description: 
    Valid use of contentspec, element content models, choices, and content particles within an element type declaration.  The optional character following a name or list governs the number of times the element or content particle may appear.  Whitespace is also valid between choices.   "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p49pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p50fail1


	"Sections: 3.2.1 [50]"
	"Description: 
    connectors must match     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p50fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p50pass1


	"Sections: 3.2 3.2.1 [45] [46] [47]"
	"Description: 
    Valid use of contentspec, element content models, sequences and content particles within an element type declaration.  The optional character following a name or list governs the number of times the element or content particle may appear.  Whitespace is also valid between sequences.   "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p50pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p51fail1


	"Sections: 3.2.2 [51]"
	"Description: 
     occurrence on #PCDATA group must be *
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail2


	"Sections: 3.2.2 [51]"
	"Description: 
     occurrence on #PCDATA group must be *
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail3


	"Sections: 3.2.2 [51]"
	"Description: 
     #PCDATA must come first
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail4


	"Sections: 3.2.2 [51]"
	"Description: 
     occurrence on #PCDATA group must be *
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail5


	"Sections: 3.2.2 [51]"
	"Description: 
     only '|' connectors
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail6


	"Sections: 3.2.2 [51]"
	"Description: 
    Only '|' connectors and occurrence on #PCDATA group must be *     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51fail7


	"Sections: 3.2.2 [51]"
	"Description: 
     no nested groups
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51fail7.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p51pass1


	"Sections: 3.2.2 [51]"
	"Description: 
     valid Mixed contentspec's.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p51pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p52fail1


	"Sections: 3.3 [52]"
	"Description: 
     A name is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p52fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p52fail2


	"Sections: 3.3 [52]"
	"Description: 
     A name is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p52fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p52pass1


	"Sections: 3.3 [52]"
	"Description: 
     valid AttlistDecls: No AttDef's are required,
    and the terminating
          S is optional, multiple ATTLISTS per element are OK, and multiple
          declarations of the same attribute are OK.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p52pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p53fail1


	"Sections: 3.3 [53]"
	"Description: 
     S is required before default
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p53fail2


	"Sections: 3.3 [53]"
	"Description: 
     S is required before type
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p53fail3


	"Sections: 3.3 [53]"
	"Description: 
     type is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p53fail4


	"Sections: 3.3 [53]"
	"Description: 
     default is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p53fail5


	"Sections: 3.3 [53]"
	"Description: 
     name is requried
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p53pass1


	"Sections: 3.3 [53]"
	"Description: 
     a valid AttDef
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p53pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p54fail1


	"Sections: 3.3.1 [54]"
	"Description: 
     don't pass unknown attribute types
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p54fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:05 / janfrog"
!

test_o_p54pass1


	"Sections: 3.3.1 [54]"
	"Description: 
     the three kinds of attribute types
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p54pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p55fail1


	"Sections: 3.3.1 [55]"
	"Description: 
     must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p55fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p55pass1


	"Sections: 3.3.1 [55]"
	"Description: 
     StringType = `CDATA`
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p55pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p56fail1


	"Sections: 3.3.1 [56]"
	"Description: 
     no IDS type
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p56fail2


	"Sections: 3.3.1 [56]"
	"Description: 
     no NUMBER type
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p56fail3


	"Sections: 3.3.1 [56]"
	"Description: 
     no NAME type
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p56fail4


	"Sections: 3.3.1 [56]"
	"Description: 
     no ENTITYS type
- types must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p56fail5


	"Sections: 3.3.1 [56]"
	"Description: 
    types must be upper case     "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p56pass1


	"Sections: 3.3.1 [56]"
	"Description: 
     the 7 tokenized attribute types
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p56pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:53 / janfrog"
!

test_o_p57fail1


	"Sections: 3.3.1 [57]"
	"Description: 
     no keyword for NMTOKEN enumeration
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p57fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p57pass1


	"Sections: 3.3.1 [57]"
	"Description: 
     enumerated types are NMTOKEN or NOTATION lists
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p57pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p58fail1


	"Sections: 3.3.1 [58]"
	"Description: 
     at least one value required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail2


	"Sections: 3.3.1 [58]"
	"Description: 
     separator must be '|'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail3


	"Sections: 3.3.1 [58]"
	"Description: 
     notations are NAMEs, not NMTOKENs -- note:
    Leaving the invalid
          notation undeclared would cause a validating parser to fail without
          checking the name syntax, so the notation is declared with an
          invalid name.  A parser that reports error positions should report
          an error at the AttlistDecl on line 6, before reaching the notation
          declaration.
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail4


	"Sections: 3.3.1 [58]"
	"Description: 
     NOTATION must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail5


	"Sections: 3.3.1 [58]"
	"Description: 
     S after keyword is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail6


	"Sections: 3.3.1 [58]"
	"Description: 
     parentheses are require
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail7


	"Sections: 3.3.1 [58]"
	"Description: 
     values are unquoted
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail7.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58fail8


	"Sections: 3.3.1 [58]"
	"Description: 
     values are unquoted
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58fail8.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p58pass1


	"Sections: 3.3.1 [58]"
	"Description: 
     NOTATION enumeration has on or more items
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p58pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p59fail1


	"Sections: 3.3.1 [59]"
	"Description: 
     at least one required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p59fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p59fail2


	"Sections: 3.3.1 [59]"
	"Description: 
     separator must be `,`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p59fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p59fail3


	"Sections: 3.3.1 [59]"
	"Description: 
     values are unquoted
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p59fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:06 / janfrog"
!

test_o_p59pass1


	"Sections: 3.3.1 [59]"
	"Description: 
     NMTOKEN enumerations haveon or more items
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p59pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p60fail1


	"Sections: 3.3.2 [60]"
	"Description: 
     keywords must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p60fail2


	"Sections: 3.3.2 [60]"
	"Description: 
     S is required after #FIXED
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p60fail3


	"Sections: 3.3.2 [60]"
	"Description: 
     only #FIXED has both keyword and value
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p60fail4


	"Sections: 3.3.2 [60]"
	"Description: 
     #FIXED required value
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p60fail5


	"Sections: 3.3.2 [60]"
	"Description: 
     only one default type
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p60pass1


	"Sections: 3.3.2 [60]"
	"Description: 
     the four types of default values
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p60pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p61fail1


	"Sections: 3.4 [61]"
	"Description: 
     no other types, including TEMP, which is valid in SGML
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p61fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p61pass1


	"Sections: 3.4 [61]"
	"Description: 
     valid conditional sections are INCLUDE and IGNORE
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p61pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p62fail1


	"Sections: 3.4 [62]"
	"Description: 
     INCLUDE must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p62fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p62fail2


	"Sections: 3.4 [62]"
	"Description: 
     no spaces in terminating delimiter
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p62fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p62pass1


	"Sections: 3.4 [62]"
	"Description: 
     valid INCLUDE sections -- options S before and
    after keyword, sections can nest
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p62pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p63fail1


	"Sections: 3.4 [63]"
	"Description: 
     IGNORE must be upper case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p63fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p63fail2


	"Sections: 3.4 [63]"
	"Description: 
     delimiters must be balanced
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p63fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p63pass1


	"Sections: 3.4 [63]"
	"Description: 
     valid IGNORE sections
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p63pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p64fail1


	"Sections: 3.4 [64]"
	"Description: 
     section delimiters must balance
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p64fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p64fail2


	"Sections: 3.4 [64]"
	"Description: 
     section delimiters must balance
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p64fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p64pass1


	"Sections: 3.4 [64]"
	"Description: 
     IGNOREd sections ignore everything except section delimiters
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p64pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p66fail1


	"Sections: 4.1 [66]"
	"Description: 
     terminating ';' is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66fail2


	"Sections: 4.1 [66]"
	"Description: 
     no S after '&#'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66fail3


	"Sections: 4.1 [66]"
	"Description: 
     no hex digits in numeric reference
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66fail4


	"Sections: 4.1 [66]"
	"Description: 
     only hex digits in hex references
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66fail5


	"Sections: 4.1 [66]"
	"Description: 
     no references to non-characters
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66fail6


	"Sections: 4.1 [66]"
	"Description: 
     no references to non-characters
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:07 / janfrog"
!

test_o_p66pass1


	"Sections: 4.1 [66]"
	"Description: 
     valid character references
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p66pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p68fail1


	"Sections: 4.1 [68]"
	"Description: 
     terminating ';' is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p68fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p68fail2


	"Sections: 4.1 [68]"
	"Description: 
     no S after '&'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p68fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p68fail3


	"Sections: 4.1 [68]"
	"Description: 
     no S before ';'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p68fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p68pass1


	"Sections: 4.1 [68]"
	"Description: 
     Valid entity references.  Also ensures that a charref to
          '&' isn't interpreted as an entity reference open delimiter
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p68pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p69fail1


	"Sections: 4.1 [69]"
	"Description: 
     terminating ';' is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p69fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p69fail2


	"Sections: 4.1 [69]"
	"Description: 
     no S after '%'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p69fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p69fail3


	"Sections: 4.1 [69]"
	"Description: 
     no S before ';'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p69fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p69pass1


	"Sections: 4.1 [69]"
	"Description: 
     Valid PEReferences.
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p69pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p70fail1


	"Sections: 4.2 [70]"
	"Description: 
     This is neither
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p70fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p70pass1


	"Sections: 4.2 [70]"
	"Description: 
     An EntityDecl is either a GEDecl or a PEDecl
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p70pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p71fail1


	"Sections: 4.2 [71]"
	"Description: 
     S is required before EntityDef
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p71fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p71fail2


	"Sections: 4.2 [71]"
	"Description: 
     Entity name is a Name, not an NMToken
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p71fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p71fail3


	"Sections: 4.2 [71]"
	"Description: 
     no S after `<i`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p71fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p71fail4


	"Sections: 4.2 [71]"
	"Description: 
     S is required after `<iENTITY`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p71fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p71pass1


	"Sections: 4.2 [71]"
	"Description: 
     Valid GEDecls
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p71pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p72fail1


	"Sections: 4.2 [72]"
	"Description: 
     S is required after `<iENTITY`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p72fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p72fail2


	"Sections: 4.2 [72]"
	"Description: 
     S is required after '%'
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p72fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p72fail3


	"Sections: 4.2 [72]"
	"Description: 
     S is required after name
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p72fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p72fail4


	"Sections: 4.2 [72]"
	"Description: 
     Entity name is a name, not an NMToken
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p72fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p72pass1


	"Sections: 4.2 [72]"
	"Description: 
     Valid PEDecls
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p72pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p73fail1


	"Sections: 4.2 [73]"
	"Description: 
     No typed replacement text
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p73fail2


	"Sections: 4.2 [73]"
	"Description: 
     Only one replacement value
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p73fail3


	"Sections: 4.2 [73]"
	"Description: 
     No NDataDecl on replacement text
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:08 / janfrog"
!

test_o_p73fail4


	"Sections: 4.2 [73]"
	"Description: 
     Value is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p73fail5


	"Sections: 4.2 [73]"
	"Description: 
     No NDataDecl without value
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p73pass1


	"Sections: 4.2 [73]"
	"Description: 
     EntityDef is either Entity value or an external id,
    with an optional NDataDecl
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p73pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
!

test_o_p74fail1


	"Sections: 4.2 [74]"
	"Description: 
     no NDataDecls on parameter entities
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p74fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p74fail2


	"Sections: 4.2 [74]"
	"Description: 
     value is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p74fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p74fail3


	"Sections: 4.2 [74]"
	"Description: 
     only one value
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p74fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p74pass1


	"Sections: 4.2 [74]"
	"Description: 
     PEDef is either an entity value or an external id
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p74pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p75fail1


	"Sections: 4.2.2 [75]"
	"Description: 
     S required after `PUBLIC`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75fail2


	"Sections: 4.2.2 [75]"
	"Description: 
     S required after `SYSTEM`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75fail3


	"Sections: 4.2.2 [75]"
	"Description: 
     S required between literals
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75fail4


	"Sections: 4.2.2 [75]"
	"Description: 
     `SYSTEM` implies only one literal
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75fail5


	"Sections: 4.2.2 [75]"
	"Description: 
     only one keyword
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail5.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75fail6


	"Sections: 4.2.2 [75]"
	"Description: 
     `PUBLIC` requires two literals (contrast with SGML)
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75fail6.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p75pass1


	"Sections: 4.2.2 [75]"
	"Description: 
     valid external identifiers
    "


    self shouldnt:[
       "This test must pass in non-validating parser."
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p75pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:56 / janfrog"
!

test_o_p76fail1


	"Sections: 4.2.2 [76]"
	"Description: 
     S is required before `NDATA`
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p76fail1.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p76fail2


	"Sections: 4.2.2 [76]"
	"Description: 
     `NDATA` is upper-case
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p76fail2.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p76fail3


	"Sections: 4.2.2 [76]"
	"Description: 
     notation name is required
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p76fail3.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p76fail4


	"Sections: 4.2.2 [76]"
	"Description: 
     notation names are Names
    "


    self should:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p76fail4.xml')).
    ] raise: SAXParseError.

    "Modified: / 25-10-2005 / 14:59:09 / janfrog"
!

test_o_p76pass1


	"Sections: 4.2.2 [76]"
	"Description: 
     valid NDataDecls
    "


    self shouldnt:[
       XMLReader new parseInputSource:(InputSource onFile:(W3XMLTestSuiteResource current filesDirectory construct:'oasis/p76pass1.xml')).
    ] raise: Error.

    "Modified: / 25-10-2005 / 14:58:54 / janfrog"
! !

!OASISXMLTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__OASISXMLTests.st,v 1.1.1.1 2005-11-01 22:05:57 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

