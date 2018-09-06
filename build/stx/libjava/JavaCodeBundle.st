"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaCodeLibraryOrBundle subclass:#JavaCodeBundle
	instanceVariableNames:'libraries'
	classVariableNames:'Root'
	poolDictionaries:''
	category:'Languages-Java-Support-Libraries'
!

!JavaCodeBundle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"
    A container for several JavaCodeLibraries bundled together.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeBundle class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

standardPackageBundleFor: packageId
    "Return bundle for packageId. Assumes that that
     package has standard layout, i.e.,

     <package-dir>/java
        bin ..................... compiled .class files
        bin-tests ............... compiler .class files for JUnit tests
        src ..................... java sources
        src-tests ............... java sources for JUnit tests
        libs .................... required .jar files
        libs-src ................ (optional) sources code for .jars
    "
        
    | bundle lib pkg pkgDir javadir p libs libssrc |

    pkg := ProjectDefinition definitionClassForPackage: packageId.
    pkgDir := pkg packageDirectory.
    javadir := pkgDir / 'java'.
    bundle := JavaCodeBundle new name: pkg package.
    (p := javadir / 'bin') isDirectory ifTrue:[
        lib := JavaCodeLibrary new name: 'Java Code'.
        lib classes: p pathName.
        (p := javadir /'src') isDirectory ifTrue:[
            lib sources: p pathName.
        ].
        bundle add: lib.
    ].

    (p := javadir / 'bin-tests') isDirectory ifTrue:[
        lib := JavaCodeLibrary new name: 'JUnit Tests'.
        lib classes: p pathName.
        (p := javadir /'src-tests') isDirectory ifTrue:[
            lib sources: p pathName.
        ].
        bundle add: lib.
    ].


    libs := javadir / 'libs'.
    libssrc := javadir / 'libs-src'.
    libs isDirectory ifTrue:[
        libs directoryContentsAsFilenamesDo:[:each|
            each suffix = 'jar' ifTrue:[
                lib := JavaCodeLibrary new name: each baseName.
                lib classes: each pathName.

                (p :=  libssrc / each baseName ) exists ifTrue:[
                    lib sources: p pathName. 
                ] ifFalse:[
                "/ maven/ivy naming...
                (p :=  libssrc / (each withoutSuffix baseName , '-sources.jar') ) exists ifTrue:[
                    lib sources: p pathName.
                ] ifFalse:[
                (p :=  libssrc / (each withoutSuffix baseName , '-sources.zip') ) exists ifTrue:[
                        lib sources: p pathName.            
                ] ifFalse:[
                "/ eclipse plugin naming...
                | base underscore |
                base := each baseName.
                underscore := base indexOf: $_.
                underscore ~~ 0 ifTrue:[
                    (p := libssrc / ((base copyTo: underscore - 1) , '.source', (base copyFrom: underscore))) exists ifTrue:[
                        lib sources: p pathName.            
                    ].
                ]
                ]]].
                bundle add: lib.
            ].
        ].
    ].
    ^bundle

    "
        JavaCodeBundle standardPackageBundleFor: #'stx:libjava'
        JavaCodeBundle standardPackageBundleFor: #'stx:libjava/libs'
    "

    "Created: / 15-01-2013 / 17:05:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2015 / 22:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaCodeBundle methodsFor:'accessing'!

/ nm
    ^libraries detect:[:e|e name = nm] ifNone:[self error:'No such library or sub-bundle'].

    "Created: / 12-02-2013 / 15:07:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraries
    ^ libraries

    "Modified: / 15-01-2013 / 17:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'accessing-private'!

libraries:aCollection

    "/ To be called only when decoding from literal array
    libraries := aCollection.

    "Modified (comment): / 15-04-2014 / 13:21:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'adding & removing'!

add: libraryOrBundle

    libraries add: libraryOrBundle.
    self changed: #libraries.

    "Created: / 12-01-2013 / 16:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2013 / 15:18:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: libraryOrBundle

    libraries remove: libraryOrBundle.
    self changed: #libraries.

    "Created: / 12-01-2013 / 16:08:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2013 / 15:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'comparing'!

= another
    self class ~~ another class ifTrue:[ ^ false ].                                                
    self name ~= another name ifTrue:[ ^ false ].                                                  
    self libraries size ~~ another libraries size ifTrue:[ ^ false ].
    self libraries with: another libraries do:[:myLib :anotherLib |
        myLib ~= anotherLib ifTrue:[ ^ false ].
    ].
    ^ true

    "Created: / 14-04-2014 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'displaying'!

displayString
    ^ self name

    "Created: / 15-04-2014 / 18:58:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'enumerating'!

allLibrariesDo:aBlock 
    "Enumerate all libraries in the bundle and evaluate
     aBlock on each of them"
    
    self libraries do:[:each | 
        each allLibrariesDo:aBlock
    ]

    "Modified: / 07-03-2013 / 12:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'generating'!

classPathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    ^ self libraries do:[:each|each classPathOn: aStream].

    "Modified: / 15-01-2013 / 17:32:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePathOn:aStream
    "superclass JavaCodeLibraryOrBundle says that I am responsible to implement this method"

    ^ self libraries do:[:each|each sourcePathOn: aStream].

    "Created: / 12-01-2013 / 16:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 17:32:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    libraries := OrderedCollection new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 12-01-2013 / 16:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'inspecting'!

inspector2TabView
    <inspector2Tab>

    ^ Tools::Inspector2Tab new
            priority: 80;
            label:'Libraries';
            application:[
                JavaCodeBundleEditor new 
                    bundle: self;
                    readonly: true;
                    yourself.
            ];
            yourself

    "Created: / 15-04-2014 / 18:53:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle methodsFor:'testing'!

isBundle
    ^true

    "Created: / 25-01-2013 / 21:44:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeBundle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeBundle.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaCodeBundle.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
! !

