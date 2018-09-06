"{ Package: 'stx:libjava/tools' }"!

!ConfigurableFeatures class methodsFor:'queries-features'!

hasGroovySupport
    "Actually, same as hasJavaToolingSupport, byt maybe
     we'll separate later"

    ^self hasJavaToolingSupport


    "
     ConfigurableFeatures hasGroovySupport
     ConfigurableFeatures includesFeature:#GroovySupport
    "

    "Created: / 18-02-2012 / 16:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasJavaToolingSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator

    ^self hasJavaSupport
	and:[(Smalltalk at:#'stx_libjava_tools') notNil]


    "
     ConfigurableFeatures hasJavaToolingSupport
     ConfigurableFeatures includesFeature:#JavaToolingSupport
    "

    "Created: / 18-02-2012 / 16:44:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibrary methodsFor:'validating'!

validate
    "Validate this Java library and raise validation warning for each
     problem. A caller may give up upon first problem of proceed to collect
     all warnings."

    classes isNil ifTrue:[ 
        JavaCodeLibraryValidationError classesNotSpecified newException
            messageText: 'No classes specified';
            parameter: self;
            raiseRequest
    ] ifFalse:[ 
        | classesFile |

        classesFile := classes asFilename.
        classesFile exists ifTrue:[ 
            (classesFile isRegularFile and:[(ZipArchive isZipArchive: classes) not]) ifTrue:[
                JavaCodeLibraryValidationWarning classesArchiveInvalid newException
                    messageText: 'Classes archive is not a valid .jar / .zip archive: ', classes;
                    parameter: self;
                    raiseRequest
            ]
        ] ifFalse:[ 
            JavaCodeLibraryValidationWarning classesDontExist newException
                messageText: ('Classes doesn''t exist: ' , classes);
                parameter: self;
                raiseRequest
        ].
    ].
    sources notNil ifTrue:[
        | sourcesFile |

        sourcesFile := sources asFilename.
        sourcesFile exists ifTrue:[ 
            (sourcesFile isRegularFile and:[(ZipArchive isZipArchive: sources) not]) ifTrue:[
                JavaCodeLibraryValidationWarning sourcesArchiveInvalid newException
                    messageText: 'Sources archive is not a valid .jar / .zip archive: ' , sources;
                    parameter: self;
                    raiseRequest
            ]
        ] ifFalse:[ 
            JavaCodeLibraryValidationWarning sourcesDontExist newException
                messageText: ('Sources dont exist: ' , sources);
                parameter: self;
                raiseRequest
        ].
    ].         
    javadoc notNil ifTrue:[
        | javadocFile |

        javadocFile := javadoc asFilename.
        javadocFile exists ifTrue:[ 
            (javadocFile isRegularFile and:[(ZipArchive isZipArchive: sources) not]) ifTrue:[
                JavaCodeLibraryValidationWarning sourcesArchiveInvalid newException
                    messageText: 'JavaDoc archive is not a valid .zip archive: ' , javadoc;
                    parameter: self;
                    raiseRequest
            ]
        ] ifFalse:[ 
            JavaCodeLibraryValidationWarning sourcesDontExist newException
                messageText: ('JavaDoc doesnt exist: ' , javadoc);
                parameter: self;
                raiseRequest
        ].
    ].

    "Created: / 19-03-2015 / 11:58:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 14:53:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaObject methodsFor:'inspecting'!

inspectorClass

    "Return an inspector class for the receiver.
     Bit ugly, but reasonably fast :-)"

    | cls nm ifaces |
    nm := (cls := self class) binaryName.

    (nm == #'java/util/ArrayList') ifTrue:[
        ^JavaListInspectorView
    ].
    (nm == #'java/util/LinkedList') ifTrue:[
        ^JavaListInspectorView
    ].
    (nm == #'java/util/HashMap') ifTrue:[
        ^JavaMapInspectorView
    ].
    (nm == #'java/util/TreeMap') ifTrue:[
        ^JavaMapInspectorView
    ].
    (nm == #'java/util/HashSet') ifTrue:[
        ^JavaSetInspectorView
    ].
    ifaces := self class allInterfaces.
    ifaces do:[:i|
        i name == #'java/util/List' ifTrue:[
            ^JavaListInspectorView
        ].
        i name == #'java/util/Map' ifTrue:[
            ^JavaMapInspectorView
        ].
        i name == #'java/util/Set' ifTrue:[
            ^JavaSetInspectorView
        ].
    ].
    ^super inspectorClass

    "Created: / 04-12-2011 / 16:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:47:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-class'!

classMenuNewGroovyClass

    | currentClass superClass code category |
    currentClass := self theSingleSelectedClass.
    currentClass notNil ifTrue:[
	superClass := currentClass theNonMetaclass superclass.
	superClass notNil ifTrue:[
	    superClass isJavaClass ifFalse:[
		superClass := Java classForName:'java.lang.Object'.
	    ]
	]
    ] ifFalse:[
	superClass := Java classForName:'java.lang.Object'.
    ].

    category := self hasCategorySelected
		    ifTrue:[self selectedCategoriesValue first]
		    ifFalse:[Compiler defaultMethodCategory]. "/ '* As yet uncategorized *'


    code := GroovyLanguage instance
		    classTemplateFor: superClass
		    in: category
		    asNamespace: false
		    private: false.

    self showCode: code.
    self setAcceptAction: [:theCode | self doAcceptGroovyClassDefinition: theCode asString ].
    self codeAspect:#newClassDefinition.

    "Created: / 18-02-2012 / 17:16:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_tools class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
