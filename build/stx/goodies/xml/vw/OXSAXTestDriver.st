"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

SAXDriver subclass:#OXSAXTestDriver
	instanceVariableNames:'document'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Testing'
!

OXSAXTestDriver comment:'Author: Roger Whitney whitney@cs.sdsu.edu
Version: 1.0  
Date: 4/2/2000
License: Camp Smalltalk 

OXSAXTestDriver is used to test the OXSAXBuilder.

Instance Variables:
	document        <Stream>        Used to accumulate the text of an XML document

'
!


!OXSAXTestDriver methodsFor:'accessing'!

document
	^document
! !

!OXSAXTestDriver methodsFor:'content handler'!

characters: aString

	document nextPutAll: aString.
!

endDocument
	document 
		nextPutAll: 'End document';
		cr.
!

endElement: localName namespace: nameSpace prefix: nameSpacePrefix
        document 
                nextPutAll: '</';
                nextPutAll: localName asString;
                nextPut: $>;
                cr.

    "Modified: / 17-02-2017 / 10:15:13 / stefan"
!

ignorableWhitespace: aString
!

processingInstruction: target data: data

	document
		nextPutAll: '<? '; 
		nextPutAll: target;
		nextPutAll: ' ';
		nextPutAll: data;
		nextPutAll: '?>';
		cr
!

startDocument
	document 
		nextPutAll: 'Start document';
		cr.
!

startElement: localName namespace: nameSpace prefix: nameSpacePrefix attributes: atts 
        document
                nextPut:$<;
                nextPutAll: nameSpace;
                nextPut:$:;
                nextPutAll: localName asString.
        atts notNil ifTrue:[
            document space.
            atts do:[:each | 
                document
                        nextPutAll: each tag namespace;
                        nextPut: $:;
                        nextPutAll: each tag type;
                        nextPut: $=;
                        nextPutAll: each value]
            separatedBy: [document space]
        ].
        document nextPut: $>; cr

    "Modified: / 17-02-2017 / 10:01:12 / stefan"
! !

!OXSAXTestDriver methodsFor:'initialize'!

initialize
    super initialize.
    document := WriteStream on: (String new: 50)
! !

!OXSAXTestDriver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/OXSAXTestDriver.st,v 1.5 2017-02-17 10:13:54 stefan Exp $'
! !

