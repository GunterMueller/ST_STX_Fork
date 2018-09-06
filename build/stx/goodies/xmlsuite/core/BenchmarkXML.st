"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: Smalltalk }"

Benchmark subclass:#BenchmarkXML
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Benchmarks'
!


!BenchmarkXML methodsFor:'benchmark'!

benchmarkVWDOM
    <warmup: #yourself>
    <benchmark: 'DOM - VW'>

    '/home/jv/tmp/xmark/standard.xml' asFilename readingFileDo:[ :stream |
        XML::XMLParser processDocumentStream: stream beforeScanDo: [:p | p validate: false ].
    ].
    "
    BenchmarkXML run: #benchmarkVWDOM
    "

    "Created: / 14-07-2016 / 16:21:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkVWSAX
    <warmup: #yourself>
    <benchmark: 'SAX - VW'>

    '/home/jv/tmp/xmark/standard.xml' asFilename readingFileDo:[ :stream |
        XML::SAXDriver on: stream beforeScanDo: [:p | p validate: false ].
    ].
    "
    BenchmarkXML run: #benchmarkVWSAX
    "

    "Created: / 14-07-2016 / 07:10:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkXMLSuiteDOM
    <warmup: #yourself>
    <benchmark: 'DOM - XMLSuite'>

    '/home/jv/tmp/xmark/standard.xml' asFilename readingFileDo:[ :stream |
        XMLv2::Parser new processDocumentStream: stream beforeScanDo: [:p | p validate: false ].
    ].   
    "
    BenchmarkXML run: #benchmarkXMLSuiteDOM
    "

    "Created: / 14-07-2016 / 16:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

benchmarkXMLSuiteSAX
    <warmup: #yourself>
    <benchmark: 'SAX - XMLSuite'>

    | source |

    source := XMLv2::InputSource onFile: '/home/jv/tmp/xmark/standard.xml' asFilename.
    XMLv2::XMLReader new parseInputSource: source.  

    "
    BenchmarkXML run: #benchmarkXMLSuiteSAX
    "

    "Created: / 14-07-2016 / 07:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BenchmarkXML class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

