"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestResource subclass:#XQTSTestResource
	instanceVariableNames:''
	classVariableNames:'XQTSRoot'
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSTestResource class methodsFor:'accessing'!

xqtsRoot

    "
        XQTSRoot := nil.
        self xqtsRoot 
    "

    XQTSRoot ifNil:
        [XQTSRoot := self xqtsRoots 
                        at: OperatingSystem getHostName 
                        ifAbsent:[
			Smalltalk isHeadless ifTrue:[^nil].
			Dialog requestDirectoryName:'Enter XQTS Root directory']].
    ^XQTSRoot asFilename

    "Created: / 10-11-2008 / 16:27:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xqtsRoots

    ^Dictionary withKeysAndValues:
        #(
	    'swing-hudson-lin' '/home/builder/XQTS'
            'neso'      '/home/jv/Projects/CellStore/XQTS'
            'Tibor'     '/home/honza/cellstore/xqts_1_0_2'
        )

    "Created: / 10-11-2008 / 16:29:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 15:12:17 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQTSTestResource methodsFor:'accessing'!

xqtsFile: aString

    ^self xqtsRoot construct: (aString copy replaceAll:$/ with: Filename separator)

    "Created: / 10-11-2008 / 16:31:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2008 / 17:32:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xqtsInputFile: aString

    ^self xqtsFile:'TestSources/' , aString, '.xml'

    "Created: / 10-11-2008 / 17:14:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-04-2009 / 12:54:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xqtsQueryFile: aString

    ^self xqtsFile:'Queries/XQuery/' , aString

    "Created: / 10-11-2008 / 17:13:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xqtsResultFile: aString

    ^self xqtsFile:'ExpectedTestResults/' , aString

    "Created: / 10-11-2008 / 17:13:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

xqtsRoot

    ^self class xqtsRoot

    "Created: / 10-11-2008 / 16:23:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2008 / 17:32:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !


!XQTSTestResource methodsFor:'testing'!

isAvailable

    | root |
    root := self xqtsRoot.
    ^root notNil and:[root isDirectory]

! !


!XQTSTestResource class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
