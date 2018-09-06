"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XMLReaderTests
	instanceVariableNames:'parser eventRecorder'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests-SAX2'
!


!XMLReaderTests class methodsFor:'testing'!

isAbstract

    ^self == XMLv2::XMLReaderTests

    "Created: / 06-04-2009 / 11:05:41 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLReaderTests methodsFor:'accessing'!

parserClass

    ^self subclassResponsibility

    "Created: / 06-04-2009 / 11:09:00 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLReaderTests methodsFor:'initialization'!

setUp

    parser := self parserClass new.
    eventRecorder := XMLEventRecorder new.
    parser setContentHandler: eventRecorder.

    "Created: / 06-04-2009 / 11:08:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

tearDown

    parser := nil

    "Created: / 06-04-2009 / 11:09:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XMLReaderTests methodsFor:'testing'!

test1
    |expectedOutput output|

    expectedOutput := #(
                        #(#startDocument) 
                        #(#startElement:namespace:prefix:attributes: 'root' '' '' #()) 
                        #(#characters: ' ') 
                        #(#endElement:namespace:prefix: 'root' '' '') 
                        #(#endDocument)
                      ).
    parser parseInputSource: (InputSource onString:'<root> </root>').
    output := eventRecorder eventsAsArray.
    self assert: (expectedOutput isSameSequenceAs: output).

    "Created: / 06-04-2009 / 11:12:36 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 12:19:00 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 14:09:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test2
    |expectedOutput output|

    expectedOutput := #(
                        #(#startDocument) 
                        #(#startElement:namespace:prefix:attributes: 'root' '' '' #(#('a' '' 'aa') #('b' '' 'bb'))) 
                        #(#characters: ' ') 
                        #(#endElement:namespace:prefix: 'root' '' '') 
                        #(#endDocument)
                      ).
    parser parseInputSource: (InputSource onString:'<root b="bb" a="aa"> </root>').
    output := eventRecorder eventsAsArray.
    self assert: (expectedOutput isSameSequenceAs: output).

    "Created: / 06-04-2009 / 12:19:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2009 / 14:09:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XMLReaderTests class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_SVN
    ^ '$Id$'
! !

