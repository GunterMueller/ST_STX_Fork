"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_libcairo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_libcairo class methodsFor:'accessing - tests'!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    | testSuite |

    testSuite := super testSuite.
    [
        (Smalltalk at: #'stx_goodies_libcairo_tests') isNil ifTrue:[
            Smalltalk loadPackage: 'stx:goodies/libcairo/tests'.
        ].
        testSuite addTests: (Smalltalk at: #'stx_goodies_libcairo_tests') testSuite tests.
    ] on: Error do:[:ex | 
        'FAILED TO LOAD stx:goodies/libcairo/tests: ' errorPrint.
        ex  description errorPrintCR.
    ].
    ^ testSuite

    "
    stx_goodies_libcairo testSuite
    "

    "Created: / 04-03-2016 / 15:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_libcairo class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "ArrayedCollection - superclass of Cairo::CStructure"
        #'stx:libview'    "Depth1Image - extended"
    )
!

postLoadAction

    "
        stx_goodies_libcairo postLoadAction
    "

    super postLoadAction.
    OperatingSystem isUNIXlike 
        ifTrue:
            [ExternalLibraryFunction dllPath:    
                (ExternalLibraryFunction dllPath asOrderedCollection
                    add:'/usr/lib/i386-linux-gnu';
                    add:'/usr/lib';
                    add:'/usr/local/lib';
                    yourself)].

    "Created: / 10-09-2008 / 18:30:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-09-2014 / 01:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preLoadAction

    "
        stx_goodies_libcairo preLoadAction
    "

    super preLoadAction.
    NameSpace name:#Cairo

    "Created: / 10-09-2008 / 19:16:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_goodies_libcairo "
        #'stx:libview'    "GLXWorkstation - superclass of Cairo::GLXWorkstation "
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libview2'    "PluggableView - referenced by Cairo::SurfaceImage>>inspector2TabImageCairo"
        #'stx:libwidg'    "HVScrollableView - referenced by Cairo::SurfaceImage>>inspector2TabImageCairo"
    )
!

subProjects
    "list packages which are known as subprojects. 
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded; 
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_libcairo class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Cairo::Antialias'
        #'Cairo::CError'
        #'Cairo::CPrimitives'
        #'Cairo::CStructure'
        #'Cairo::ClockView'
        #'Cairo::Content'
        #'Cairo::Device'
        #'Cairo::DeviceType'
        #'Cairo::Extend'
        #'Cairo::FillRule'
        #'Cairo::Filter'
        #'Cairo::FontSlant'
        #'Cairo::FontType'
        #'Cairo::FontWeight'
        #'Cairo::Format'
        #'Cairo::HintMetrics'
        #'Cairo::HintStyle'
        #'Cairo::LineCap'
        #'Cairo::LineJoin'
        #'Cairo::Operator'
        #'Cairo::Path'
        #'Cairo::PathData'
        #'Cairo::PathDataType'
        #'Cairo::PatternType'
        #'Cairo::PdfVersion'
        #'Cairo::RectangleInt'
        #'Cairo::RectangleList'
        #'Cairo::Region'
        #'Cairo::RegionOverlap'
        #'Cairo::Status'
        #'Cairo::SubpixelOrder'
        #'Cairo::SurfaceObserverMode'
        #'Cairo::SurfaceType'
        #'Cairo::TextCluster'
        #'Cairo::TextClusterFlags'
        #'Cairo::TextExampleView'
        #'Cairo::UserDataKey'
        CairoGraphicsContextHandle
        #'stx_goodies_libcairo'
        #'Cairo::CObject'
        #'Cairo::FontExtents'
        #'Cairo::Glyph'
        #'Cairo::Matrix'
        #'Cairo::Rectangle'
        #'Cairo::TextExtents'
        CairoGraphicsContext
        CairoScaledFont
        #'Cairo::FontFace'
        #'Cairo::FontOptions'
        #'Cairo::GraphicsContext'
        #'Cairo::Pattern'
        #'Cairo::ScaledFont'
        #'Cairo::Surface'
        #'Cairo::PatternGradient'
        #'Cairo::PatternSolid'
        #'Cairo::PatternSurface'
        #'Cairo::SurfaceImage'
        #'Cairo::SurfacePDF'
        #'Cairo::SurfaceWin32'
        #'Cairo::SurfaceXlib'
        #'Cairo::PatternGradientLinear'
        #'Cairo::PatternGradientRadial'
        (#'Cairo::AbstractExamples' autoload)
        (#'Cairo::AbstractViewer' autoload)
        (#'Cairo::Examples1' autoload)
        (#'Cairo::Examples1Viewer' autoload)
        (#'Cairo::Examples2' autoload)
        (#'Cairo::Examples2Viewer' autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        GraphicsDevice cairoSurfaceFor:
        GraphicsDevice displayId
        SimpleView cairo
        SimpleView redrawWithCairo
        SimpleView redrawWithCairo:x:y:width:height:
        SimpleView redrawWithCairoBuffered
        SimpleView redrawWithCairoBuffered:
        SimpleView redrawWithCairoBuffered:x:y:width:height:
        SimpleView redrawWithCairoBufferedX:y:width:height:
        SimpleView redrawWithCairoX:y:width:height:
        DeviceGraphicsContext cairo
        Image inspector2TabImageCairo
        GraphicsContext displayDeviceLineFromX:y:toX:y:
        GraphicsContext displayDeviceRectangleX:y:width:height:
        GraphicsContext fillDeviceRectangleX:y:width:height:
        DeviceGraphicsContext cairoSurface
        GraphicsMedium cairoify
        SimpleView cairoify
        SimpleView cairoSurface
        Depth1Image bitsA1
        Depth1Image bitsA1Into:
        Depth1Image bitsA1Into:startingAt:
        Depth1Image bitsA1Into:startingAt:stride:
        Image asSurfaceWithFormat:similarTo:
    )
! !

!stx_goodies_libcairo class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'CTU FEI'

    "Created: / 10-07-2008 / 23:11:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Cairo bindings (http://www.cairographics.org)'

    "Created: / 10-07-2008 / 23:11:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2008'

    "Created: / 10-07-2008 / 23:11:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Cairo'

    "Created: / 10-07-2008 / 23:11:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!stx_goodies_libcairo class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'14              '"$"
! !

!stx_goodies_libcairo class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

