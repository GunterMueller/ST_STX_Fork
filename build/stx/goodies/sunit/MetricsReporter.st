"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MetricsReporter
	instanceVariableNames:'packages stream classMetricNames methodMetricNames
		packageMetricNames'
	classVariableNames:'DefaultClassMetricNames DefaultMethodMetricNames
		DefaultPackageMetricNames'
	poolDictionaries:''
	category:'SUnit-Smalltalk/X-Report'
!

Object subclass:#MetricInfo
	instanceVariableNames:'shortName longName metricValue errorMessage'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MetricsReporter
!

!MetricsReporter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    this is used as a last step in jenkins automated builds.
    see examples on how to generate an xml file containing code metrics information.
    Call this after a build (see goodies/builder/quichSelfTest.st) and import from jenkins.

    Currently supported formats are:
        #xml_xradar      - an xradar metrics compatible format
                         see http://xradar.sourceforge.net/
                         (see http://grepcode.com/file/repo1.maven.org/maven2/net.sf.xradar/xradar/1.1.2/dtds/metrics.dtd)

        #xml_metrics     defaults to xradar


    By default, the following metrics are generated:
        per method: 
                none
                
        per class: 
                LOC (lines of code)

        per package: 
                LOC (lines of code)
                NOC (number of classes)
        
    [author:]
        Claus Gittinger

    [see also:]
"
!

examples
"
                                                                               [exBegin]
    MetricsReporter 
        reportPackages:{ 'stx:libjavascript' } 
        format:#xml_xradar 
        on:Transcript.
                                                                               [exEnd]
                                                                               
                                                                               [exBegin]
    String streamContents:[:stream |
        MetricsReporter 
            reportPackages:{ 'stx:libjavascript' } 
            format:#xml_xradar 
            on:stream.
    ].
                                                                               [exEnd]
                                                                               [exBegin]
    String streamContents:[:stream |
        MetricsReporter 
            reportPackages:{ 'stx:libbasic*' } 
            format:#xml_xradar 
            on:stream.
    ].
                                                                               [exEnd]
                                                                               [exBegin]
    'xradar.xml' asFilename writingFileDo:[:stream |
        MetricsReporter 
            reportPackages:{ 'stx:libjavascript' } 
            format:#xml_xradar 
            on:stream.
    ].
                                                                               [exEnd]

                                                                               [exBegin]
    'xradar.xml' asFilename writingFileDo:[:stream |
        MetricsReporter 
                reportPackages:
                        { 
                            'exept:workflow' 
                            'exept:expecco' 
                            'exept:expecco/plugins/*' 
                        } 
                format:#xml_xradar 
                on:stream.
    ].
                                                                               [exEnd]

  package xradar only:
                                                                               [exBegin]
    MetricsReporter new
            stream: Transcript;
            packages:
                    { 
                        'exept:workflow' . 
                        'exept:expecco'  .
                    };
            classMetricNames: #();    
            methodMetricNames: #();    
            packageMetricNames: #( 'LOC' 'NOM' 'NOC');    
            reportXml_xradar.
                                                                               [exEnd]
                                                                               [exBegin]
    MetricsReporter new
            stream: Transcript;
            packages:
                    { 
                        'stx:libbasic' . 
                        'stx:libbasic2' . 
                        'stx:libbasic3' . 
                    };
            classMetricNames: #();    
            methodMetricNames: #();    
            packageMetricNames: #( 'LOC' 'NOM' 'NOC');    
            report.
                                                                               [exEnd]
                                                                               [exBegin]
    MetricsReporter new
            stream: Transcript;
            packages:
                    { 
                        'stx:libbasic*' . 
                    };
            classMetricNames: #();    
            methodMetricNames: #();    
            packageMetricNames: #( 'LOC' 'NOM' 'NOC');    
            report.
                                                                               [exEnd]
                                                                               [exBegin]
    MetricsReporter new
            stream: Transcript;
            packages:
                    { 
                        'stx:*' . 
                    };
            classMetricNames: #();    
            methodMetricNames: #();    
            packageMetricNames: #( 'LOC' 'NOM' 'NOC');    
            report.
                                                                               [exEnd]
                                                                               
    Number of methods without comment (NMWNC):
                                                                               [exBegin]
    MetricsReporter new
            stream: Transcript;
            packages:
                    { 
                        'stx:libbasic' . 
                    };
            classMetricNames: #();    
            methodMetricNames: #();    
            packageMetricNames: #( 'NOM' 'NMWNC');    
            report.
                                                                               [exEnd]
"
!

format_metrics
"
<-- from http://grepcode.com/file/repo1.maven.org/maven2/net.sf.xradar/xradar/1.1.2/dtds/metrics.dtd -->
<?xml version=""1.0"" encoding=""UTF-8"" ?>

<!!ELEMENT metrics (project)* >
<!!ELEMENT project (name, measurement*, group*) >
<!!ELEMENT group (name, measurement*, class*) >
<!!ELEMENT class (name, measurement*, method*) >
<!!ELEMENT method (name, measurement*) >
<!!ELEMENT name (#PCDATA) >
<!!ELEMENT measurement (short-name, long-name, value, (members? | (minimum, median, average, standard-deviation, maximum, sum, nb-data-points))) >
<!!ELEMENT short-name (#PCDATA) >
<!!ELEMENT long-name (#PCDATA) >
<!!ELEMENT value (#PCDATA) >
<!!ELEMENT members (member*) >
<!!ELEMENT minimum (#PCDATA) >
<!!ELEMENT median (#PCDATA) >
<!!ELEMENT average (#PCDATA) >
<!!ELEMENT standard-deviation (#PCDATA) >
<!!ELEMENT maximum (#PCDATA) >
<!!ELEMENT sum (#PCDATA) >
<!!ELEMENT nb-data-points (#PCDATA) >
<!!ELEMENT member (#PCDATA) >
"
! !

!MetricsReporter class methodsFor:'defaults'!

defaultClassMetricNames
    ^ DefaultClassMetricNames ? #( 'NOM' 'LOC' )
!

defaultMethodMetricNames
    ^ DefaultMethodMetricNames ? #( "'LOC'" )
!

defaultPackageMetricNames
    ^ DefaultPackageMetricNames ? #( 'LOC' 'NOC' 'NOM')
! !

!MetricsReporter class methodsFor:'queries'!

supportedFormats
   "return a list of formats and short-info-string, as per supported format symbol"

    ^ #(
        (#'xml_xradar'        'xradar xml format')
        (#'xml_metrics'       'xml format (defaults to xradar)')
    )

    "Created: / 30-07-2011 / 10:18:18 / cg"
! !

!MetricsReporter class methodsFor:'reporting'!

reportPackages: aCollectionOfPackages format: formatSymbol on: aStream
    self new 
        reportPackages: aCollectionOfPackages format: formatSymbol on: aStream

    "    
     MetricsReporter 
         reportPackages:{ 'stx:libbasic' . 'stx:libbasic2' } 
         format:#xml_metrics 
         on:Transcript.
    "
!

reportSummaryForPackages: aCollectionOfPackages format: aSymbol on: aStream
    self new
        classMetricNames:#();
        methodMetricNames:#();   
        reportPackages: aCollectionOfPackages format: aSymbol on: aStream

    "    
     MetricsReporter 
         reportSummaryForPackages:{ 'stx:libbasic' . 'stx:libbasic2' } 
         format:#xml_metrics 
         on:Transcript.
    "
! !

!MetricsReporter methodsFor:'accessing'!

classMetricNames
    ^ classMetricNames ? (self class defaultClassMetricNames)
!

classMetricNames:aCollectionOfNames
    "to overwrite the set of class metrics, which are to be measured and reported"

    classMetricNames := aCollectionOfNames.
!

methodMetricNames
    ^ methodMetricNames ? (self class defaultMethodMetricNames )
!

methodMetricNames:aCollectionOfNames
    "to overwrite the set of method metrics, which are to be measured and reported"

    methodMetricNames := aCollectionOfNames.
!

packageMetricNames
    ^ packageMetricNames ? self class defaultPackageMetricNames
!

packageMetricNames:aCollectionOfNames
    "to overwrite the set of package metrics, which are to be measured and reported"

    packageMetricNames := aCollectionOfNames.
!

packages:aCollectionOfPackages
    "defines the packages, for which a report is generated"

    packages := aCollectionOfPackages.
!

stream:aWriteStream
    "sets the stream onto which the report is written"
    
    stream := aWriteStream.
! !

!MetricsReporter methodsFor:'metric generation'!

classMetricValue:metricName for:aClass
    |metric|

    metric := OOM::ClassMetrics type:metricName for:aClass.
    ^ self metricInfoFor:metric
!

methodMetricValue:metricName for:aMethod
    |metric|

    metric := OOM::MethodMetrics type:metricName for:aMethod.
    ^ self metricInfoFor:metric
!

metricInfoFor:metric
    |metricValue errorMessageOrNil|
    
    Error handle:[:ex |
        metricValue := 0.
        errorMessageOrNil := ex description.
    ] do:[    
        metricValue := metric metricValue
    ].
    ^ MetricInfo new
        shortName:metric class shortName 
        longName:metric class descriptiveName 
        metricValue:metricValue 
        errorMessage:errorMessageOrNil
!

packageMetricValue:metricName for:aPackageIDOrPattern
    |overAllInfo|

    aPackageIDOrPattern includesMatchCharacters ifFalse:[
        ^ self metricInfoFor:(OOM::PackageMetrics type:metricName for:aPackageIDOrPattern).
    ].
    
    Smalltalk allPackageIDs do:[:eachPackageID |
        |thisInfo|

        (eachPackageID matches:aPackageIDOrPattern) ifTrue:[
            thisInfo := self metricInfoFor:(OOM::PackageMetrics type:metricName for:eachPackageID).
            overAllInfo isNil ifTrue:[
                overAllInfo := thisInfo
            ] ifFalse:[
                "/ kludge: only works with accumulative metrics (i.e. not with averages etc.)
                overAllInfo metricValue:(overAllInfo metricValue + thisInfo metricValue).   
            ].
        ].
    ].
    ^ overAllInfo
! !

!MetricsReporter methodsFor:'reporting'!

report
    "report in the default format, which is the currently only supported format,
            xml_metrics"

    self report:#xml_metrics
!

report:formatSymbol
    "formatSymbol controls, in what format the report is written.
     currently supported formatSymbols:
            xml_metrics"

    |reportFormatSelector|

    reportFormatSelector := self reportFormatSelector:formatSymbol.
    (self respondsTo: reportFormatSelector)
        ifTrue:[self perform: reportFormatSelector]
        ifFalse:[self error:'Unsupported format: ', formatSymbol].

    "Modified (comment): / 03-08-2011 / 12:57:54 / cg"
!

reportPackages: aCollectionOfPackages format: aSymbol on: aStream

    packages := aCollectionOfPackages.
    stream := aStream.
    self report: aSymbol

    "    
     MetricsReporter 
         reportPackages:{ 'stx:libbasic' . 'stx:libbasic2' } 
         format:#xml_xradar 
         on:Transcript.
    "
! !

!MetricsReporter methodsFor:'reporting - xml-default'!

reportXml_metrics
    "invoked via perform, if the formatSymbol is #xml_metrics"
    
    "
        self new
            stream:Transcript;
            packages:#( 'exept:workflow' );
            reportXml_metrics
    "

    ^ self reportXml_xradar
! !

!MetricsReporter methodsFor:'reporting - xml-xradar'!

reportXml_xradar
    "invoked via perform, if the formatSymbol is #xml_xradar"
    
    "
        self new
            stream:Transcript;
            packages:#( 'exept:workflow' );
            reportXml_xradar
    "

    "/ need the exept-metrics package
    Smalltalk loadPackage:'exept:programming/oom'.

    packages do:[:eachPackageID |
        "/ if the package is a matchPattern, generate metrics for all loaded packages
        "/ which match that pattern.
        "/ Otherwise, make sure that this package is loaded and generate metrics for that
        "/ one only.
        eachPackageID includesMatchCharacters ifFalse:[
            Smalltalk loadPackage:eachPackageID.
        ].
    ].

    stream nextPutLine: '<?xml version="1.0"?>';
           nextPutLine: '<metrics>'.

    packages do:[:eachPackageID |
        "/ if the package is a matchPattern, generate metrics for all loaded packages
        "/ which match that pattern.
        "/ Otherwise, make sure that this package is loaded and generate metrics for that
        "/ one only.
        self reportXml_xradar_forPackage:eachPackageID
    ].
    stream nextPutLine: '</metrics>'.
!

reportXml_xradar_forClass:aClass
    stream nextPutLine: '    <class>'.
    stream nextPutLine: ('      <name>%1</name>' bindWith:aClass name).

    self methodMetricNames notEmptyOrNil ifTrue:[
        aClass instAndClassMethodsDo:[:eachMethod |
            self reportXml_xradar_forMethod:eachMethod
        ].
    ].

    self classMetricNames notEmptyOrNil ifTrue:[
        self reportXml_xradar_values:(self generateClassMetricsFor:aClass).
    ].

    stream nextPutLine: '    </class>'.
!

reportXml_xradar_forMethod:aMethod
    stream nextPutLine: '      <method>'.
    stream nextPutLine:('        <name>%1</name>' bindWith:aMethod selector).

    self reportXml_xradar_values:(self generateMethodMetricsFor:aMethod).

    stream nextPutLine: '      </method>'.
!

reportXml_xradar_forPackage:aPackageIDOrPattern
    |genMetricsForClass|

    genMetricsForClass :=
        [:aClass |
            Autoload autoloadFailedSignal handle:[:ex |
            ] do:[
                aClass autoload.
                self reportXml_xradar_forClass:aClass
            ]
        ].

    stream nextPutLine: '  <project>'.
    stream nextPutLine: ('    <name>%1</name>' bindWith:aPackageIDOrPattern).

    (self classMetricNames notEmptyOrNil 
    or:[self methodMetricNames notEmptyOrNil]) ifTrue:[
        aPackageIDOrPattern includesMatchCharacters ifTrue:[
            Smalltalk allClasses do:[:eachClass |
                (eachClass package matches:aPackageIDOrPattern) ifTrue:[ 
                    genMetricsForClass value:eachClass
                ].
            ].
        ] ifFalse:[
            Smalltalk allClassesInPackage:aPackageIDOrPattern do:genMetricsForClass.
        ].
    ].

    self reportXml_xradar_values:(self generatePackageMetricsFor:aPackageIDOrPattern).

    stream nextPutLine: '  </project>'.
!

reportXml_xradar_values:metricValues
    |metricShortName metricLongName metricValue possibleErrorMessage|

    metricValues do:[:eachMetricInfo |
        metricShortName := eachMetricInfo shortName.
        metricLongName := eachMetricInfo longName.
        metricValue := eachMetricInfo metricValue.
        possibleErrorMessage := eachMetricInfo errorMessage.
        possibleErrorMessage notNil ifTrue:[
            metricLongName := metricLongName , '(Error: ',possibleErrorMessage,')'.
        ].    

        stream nextPutLine: '    <measurement>'.
        stream nextPutLine: ('      <short-name>%1</short-name>' bindWith:metricShortName).
        stream nextPutLine: ('      <long-name>%1</long-name>' bindWith:metricLongName).
        stream nextPutLine: ('      <value>%1</value>' bindWith:metricValue).
        stream nextPutLine: '    </measurement>'.
    ]
! !

!MetricsReporter methodsFor:'reporting-private'!

generateClassMetricsFor:aClass
    ^ self classMetricNames collect:[:metricName |
        self classMetricValue:metricName for:aClass.
    ].
!

generateMethodMetricsFor:aMethod
    ^ self methodMetricNames collect:[:metricName |
        self methodMetricValue:metricName for:aMethod.
    ].
!

generatePackageMetricsFor:aPackageIDOrPattern
    ^ self packageMetricNames collect:[:metricName |
        self packageMetricValue:metricName for:aPackageIDOrPattern.
    ].
!

reportFormatSelector:format
    ^ ('report' , format asString asUppercaseFirst) asSymbol
! !

!MetricsReporter::MetricInfo methodsFor:'accessing'!

errorMessage
    ^ errorMessage
!

errorMessage:something
    errorMessage := something.
!

longName
    ^ longName
!

longName:something
    longName := something.
!

metricValue
    ^ metricValue
!

metricValue:aNumber
    metricValue := aNumber.
!

shortName
    ^ shortName
!

shortName:something
    shortName := something.
!

shortName:shortNameArg longName:longNameArg metricValue:valueArg errorMessage:errorMessageArg 
    shortName := shortNameArg.
    longName := longNameArg.
    metricValue := valueArg.
    errorMessage := errorMessageArg.
! !

!MetricsReporter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

