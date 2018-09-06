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

JavaClassEnvironment subclass:#JavaClassRegistry
	instanceVariableNames:'vm loaders notifier lock erroneous'
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Support'
!

!JavaClassRegistry class methodsFor:'documentation'!

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
! !

!JavaClassRegistry class methodsFor:'instance creation'!

for: aJavaVM

    ^self new setVM: aJavaVM.

    "Created: / 21-12-2010 / 19:42:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new

    ^ self basicNew initialize.

    "Modified (format): / 30-10-2011 / 12:07:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaClassRegistry methodsFor:'accessing'!

classForName: className loader: classLoader ifAbsent: aBlock
    "Get class loaded by given classLoader from registry or evaluate aBlock if class is not yet registered"

    | classes class |

    self assert: (className includes: $.) not.

    "Classes loaded by primordial classloader are always
     used"

    classLoader notNil ifTrue:[
        classes := loaders at: nil ifAbsent: nil.
        class := classes at: className ifAbsent: nil.
        class notNil ifTrue:[
            ^class.
        ]
    ].

    "No bootstrap class found, search given classloader"
    classes := loaders at: classLoader ifAbsent: [^aBlock value].
    ^classes at: className ifAbsent: aBlock

    "Modified: / 21-10-2011 / 12:39:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 23-10-2011 / 11:40:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classForName: className loader: classLoader ifAbsentPut: block
    "Get class loaded by classLoader from registry. if absent block is evaluated and resulting class in registered in registry, "

    | class synchronizer |

    self assert: (className includes: $.) not.

    "/ Temporary workaround for race-condition when multiple threads are
    "/ loading same class. Note that ClassLoader.loadClass() / loadClassInternal()
    "/ is itself sychronized so we have to synchronize iff and only iff
    "/ we're loading for primordial class loader. If we synchronize
    "/ even on non-primordial loaders, we risk a deadlock. Very hacky...

    synchronizer := classLoader isNil
                        ifTrue:[ [:whatToDo | lock critical: whatToDo ] ]
                        ifFalse:[ [:whatToDo | whatToDo value ] ].

    synchronizer value:[
        "If class is already registered with the same cl, just return it"
        class := self classNamed: className loader: classLoader.
        class isNil ifTrue:[
            "Otherwise evaluate block"
            class := block value.
            (class notNil and:[classLoader isNil]) ifTrue: [ self registerClass: class ].
        ].
    ].
    ^ class

    "Created: / 21-10-2011 / 12:00:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 23-10-2011 / 11:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2011 / 17:29:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 11-08-2014 / 01:23:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed: className

    "Return a class for given classname loaded by 'current classloader' or
     nil if not yet loaded"

    ^self classNamed: className loader: JavaClassReader classLoaderQuerySignal query

    "Created: / 23-10-2011 / 12:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed: className loader: classLoader

    "Return a class for given classname loaded by given classloader or
     nil if not yet loaded"

    ^self classForName: className loader: classLoader ifAbsent:[nil].

    "Created: / 23-10-2011 / 12:23:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classes

    ^Iterator on:[:whatToDo|self allClassesDo: whatToDo]

    "Created: / 23-10-2011 / 20:14:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 18:43:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

erroneous
    "Return a list of classes that contain compilation errors"

    | classes |

    erroneous isNil ifTrue:[ ^ #() ].
    lock critical:[
        classes := erroneous copy.
    ].
    ^ classes.

    "
    JavaVM registry erroneous
    "

    "Created: / 20-09-2016 / 23:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2016 / 10:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemPackage: syspkg
    "Return name (as string) of system package named syspkg or nil if no such package is loaded"

    | classes syspkgSlashed |

    classes := loaders at: nil ifAbsent:[nil].
    classes isEmptyOrNil ifTrue:[ ^ #() ].
    syspkgSlashed := syspkg copyReplaceAll: $. with: $/.
    classes keysDo:[:name|
        (name startsWith:syspkgSlashed) ifTrue:[
            ^ syspkg
        ]
    ].
    ^ nil

    "Created: / 16-08-2012 / 17:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemPackages
    "Return a collection system packages (as smalltalk strings) currently loaded"

    | classes syspkgs |

    classes := loaders at: nil ifAbsent:[nil].
    classes isEmptyOrNil ifTrue:[ ^ #() ].
    syspkgs := Set new.
    classes keysDo:[:name|
        | slashpos |

        slashpos := name lastIndexOf: $/.
        slashpos ~~ 0 ifTrue:[
            | syspkg |

            syspkg := name copyTo: slashpos - 1.
            syspkg replaceAll: $/ with: $..
            syspkgs add: syspkg.
        ]
    ].
    ^syspkgs

    "Created: / 16-08-2012 / 17:32:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry methodsFor:'class loading'!

loadFile: aFilename
    "reads a class from aFilename, installs and returns it."

    | aClass |

    self breakPoint: #mh.
    aClass := JavaClassReader readFile: aFilename ignoring: Set new.
    aClass isJavaClass ifFalse:[self breakPoint:#mh].
    self registerClass: aClass.
    ^ aClass.

    "Created: / 15-04-1996 / 14:58:53 / cg"
    "Modified: / 12-05-1998 / 22:06:52 / cg"
    "Modified: / 23-10-2011 / 11:55:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadStream: javaClassDataStream loader: aJavaClassLoader
    "reads a class from aStream and returns it.
     The JavaClass is installed as global.
     If new classes are required to be loaded, aClassLoader is
     asked to do it."

    | javaClass |

    self breakPoint: #mh.
    self breakPoint: #jv.
    javaClass := JavaClassReader readStream: javaClassDataStream loader: aJavaClassLoader.
    javaClass isNil ifTrue: [
            Logger
                log: 'JavaClassReader was not able to read given data stream'
                severity: Logger severityWARN
                facility: #JVM.
            self breakPoint: #mh.
            ^ nil.
        ].
    javaClass isJavaClass ifFalse: [ self breakPoint: #mh. ].
    javaClass classLoader: aJavaClassLoader.
    self registerClass: javaClass.
    ^ javaClass

    "Modified: / 02-03-2015 / 14:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry methodsFor:'enumerating'!

allClassesDo: aBlock

    loaders do:[:classes|
        classes do:[:class|
            aBlock value: class
        ]
    ]

    "Created: / 09-04-2014 / 18:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry methodsFor:'helpers'!

addClassLoader: aJavaClassLoader

loaders at: aJavaClassLoader put: Dictionary new.
!

getClassesDefinedBy:classLoader
    ^loaders at: classLoader ifAbsent: [nil].
! !

!JavaClassRegistry methodsFor:'initialization'!

flush

    notifier stopAndRemoveAll.
    self initialize.

    "Modified: / 30-11-2013 / 07:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    loaders := WeakIdentityDictionary new.
    loaders at: nil put: Dictionary new.
    notifier := BackgroundQueueProcessingJob
                    named: 'Java class registry notifier'
                    on:[:typeAndClass|Smalltalk changed: typeAndClass first with: typeAndClass second].
    notifier priority: Processor userBackgroundPriority - 1.
    lock := RecursionLock new.
    erroneous := nil.

    "Modified: / 21-09-2016 / 10:28:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setVM: aJavaVM

    "Now, aJavaVM == JavaVM (i.e, the class JavaVM
    itself, not its instance)"

    vm := aJavaVM.

    "Created: / 21-12-2010 / 19:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-02-2013 / 17:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry methodsFor:'registering'!

registerClass: newClass
    | classes oldClass |

    ((newClass binaryName == #'$do$It$')
        and:[newClass superclass binaryName == #'groovy/lang/Script']) ifTrue:[
        "/ Mhhh...Groovy do-it. No need to register this!!
        ^ self
    ].


    self assert: (newClass binaryName includes: $.) not.
    loaders keysAndValuesDo:[:loader :classesPerLoader|
        (classesPerLoader includesKey: newClass binaryName) ifTrue:[
            loader == newClass classLoader ifTrue:[
                (oldClass := classesPerLoader at: newClass binaryName) ~~ newClass ifTrue:[
                    "Class already exists, reload & reinstall"

                    | reloadedClass |

                    self registerClassRedefined: oldClass.  
                    "/ ...if old class contained errors, unregister it from list of erroneous 
                    "/ classes...
                    oldClass hasErrors ifTrue:[ 
                        self unregisterErroneous: oldClass.  
                    ]. 
                    reloadedClass := JavaClassReloader reload: oldClass with: newClass.
                    "/OK, full reload, not just method dictionary update"
                    reloadedClass ~~ oldClass ifTrue:[
                        "/ Remove old class from classloader...
                        self unregisterClassInClassLoader: oldClass.  
                        "/ ...from reflection cache....
                        JavaVM reflection removeJavaClassObjectForClass: oldClass.                 
                        "/ ...and finally mark it obsolete...
                        oldClass beObsolete.

                        classesPerLoader
                            at: newClass binaryName
                            put: reloadedClass.
                        self registerClassInClassLoader: reloadedClass.  
                        self registerClassInSmalltalk: reloadedClass notify: false.
                    ].
                    "/ ...if old class contained errors, unregister it from erroneous as now
                    "/ it is obsolete...
                    reloadedClass hasErrors ifTrue:[ 
                        self registerErroneous: reloadedClass.  
                    ].
                    "/ ...likewise, if new class contains errors,
                    Smalltalk changed: #classDefinition with: reloadedClass.
                    ^self.
                ].
            ].
        ].
    ].

    classes := loaders at: newClass classLoader ifAbsent: nil.
    classes isNil ifTrue:[
        classes := loaders at: newClass classLoader put: Dictionary new.
    ].
    classes at: newClass binaryName  put: newClass.
    newClass isJavaClass ifTrue:[
        self registerClassInClassLoader: newClass.
        "/ Register class in system dictionary so it can be browsed
        "/ by system browser...
        self registerClassInSmalltalk: newClass notify: true.

        "/ ...register builtin classes in JavaVMData...
        newClass isBuiltInClass ifTrue:[
            self assert: newClass classLoader isNil. "/must be loaded by primordial CL...
            self registerBuiltIn: newClass.
        ].

        "/ ...and finally, if class contains compilation errors, register it as such...
        newClass hasErrors ifTrue:[ 
            self registerErroneous: newClass.
        ].
    ].
    "/ There may be classes already loaded with compile errors.
    "/ Try to recompile all erroneous classes that depends on this one...
    JavaCompiler notNil ifTrue:[
       JavaCompiler recompileErroneousClassesReferringTo: newClass ignoring: newClass.
    ].

    "Created: / 23-10-2011 / 11:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2011 / 18:40:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-09-2016 / 23:25:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerClasses: classes
    classes do:[:cls|self registerClass: cls].

    "Created: / 02-01-2013 / 17:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerClasses: classes andWait: doWait
    "Register given set of classes and if
     `doWait` is true, wait until all pending notifications
     are delivered"

    classes do:[:cls|self registerClass: cls].
    doWait ifTrue:[
        notifier waitUntilProcessed.
    ]

    "Created: / 04-08-2013 / 03:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClass: oldClass
    ^ self unregisterClass: oldClass ignoring: Set new.

    "Created: / 04-04-2012 / 02:43:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 12:12:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClass: oldClass ignoring: ignoredClasses
    | classes |

    classes := loaders at: oldClass classLoader ifAbsent: nil.
    classes notNil ifTrue:[
        "/ Check if the class is there, it could be removed meanwhile...
        (classes includesKey: oldClass binaryName) ifTrue:[
            "/ Now, invalidate references and unload all dependent clases
            "/ (JavaClassReloader will unload them by recursively call #unregisterClass:
            JavaClassReloader unload: oldClass ignoring: ignoredClasses.
            "/ Now remove it from class registry...
            classes removeKey: oldClass binaryName.
            "/ ...from class loader...
            self unregisterClassInClassLoader: oldClass.  
            "/ ...from reflection cache....
            JavaVM reflection removeJavaClassObjectForClass: oldClass.
            "/ ...and from Smalltalk dictionary
            self unregisterClassInSmalltalk: oldClass notify: true.
        ]
    ].

    "Created: / 10-10-2014 / 12:12:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClassLoader: aJavaClassLoader
    | classes |

    classes := loaders at: aJavaClassLoader ifAbsent:[ ^ self ].
    self unregisterClasses: classes values.
    loaders removeKey: aJavaClassLoader.

    "Created: / 16-12-2012 / 16:39:45 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 17-10-2013 / 10:37:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClasses: classes
    classes do:[:cls|self unregisterClass: cls].

    "Created: / 02-01-2013 / 17:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry methodsFor:'registering-private'!

registerBuiltIn: class
    | nm |

    nm := class binaryName.
    nm = #'java/lang/Object' ifTrue:[
        _java_lang_Object_CLASS := class.
        ^self.
    ].
    nm = #'java/lang/System' ifTrue:[
        _java_lang_System_CLASS := class.
        ^self.
    ].
    nm = #'java/lang/Class' ifTrue:[
        _java_lang_Class_CLASS := class.
        "/ Some more recent OpenJDK 7 (7u85-2.6.1-3) introduced 
        "/ a classLoader field in java.lang.Class instances, making
        "/ java.lang.Class.getClassLoader0() useless. To support both,
        "/ remember the offset of the `classLoader` here. It will
        "/ be used then by JavaReflectionRegistry to fill in
        "/ the field. If this particular Java runtime does not
        "/ have it (older OpenJDK7, OpenJDK6), leave it nil.
        "/ See JavaVM::ReflectionRegistry>>javaClassObjectForClass:init:.
        _java_lang_Class_classLoader_ID := _java_lang_Class_CLASS instVarIndexFor: #classLoader ifAbsent: [ nil ].

        "/ Force load of other reflective classes. This saves us a nil check in
        "/ JavaMirror>>createMethod...
        #(#'java/lang/reflect/Constructor'  #'java/lang/reflect/Method' #'java/lang/reflect/Field') do:[:e|
            vm classForName: e definedBy: nil.
        ].
        ^self.
    ].
    nm = #'java/lang/reflect/Constructor' ifTrue:[
        _java_lang_reflect_Constructor_CLASS := class.
    ].
    nm = #'java/lang/reflect/Method' ifTrue:[
        _java_lang_reflect_Method_CLASS := class.
    ].
    nm = #'java/lang/reflect/Field' ifTrue:[
        _java_lang_reflect_Field_CLASS := class.
    ].

    "Created: / 22-05-2013 / 20:40:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2015 / 15:53:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerClassInClassLoader: class
    "Registers class in it's classloader"

    "/ OpenJDK java.class.ClassLoader keeps list of all loaded classes
    "/ in a field `classes`. This method adds the class to the list.
    "/ For classes loaded by primordial class loader, `class classLoader1
    "/ returns nil.
    class classLoader notNil ifTrue:[
        class classLoader perform: #'addClass(Ljava/lang/Class;)V' with: (JavaVM reflection javaClassObjectForClass: class).  
    ].

    "Created: / 11-08-2014 / 01:37:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerClassInSmalltalk: javaclass notify: doNotify
    "Registers class in Smalltalk system dictionary and
     notifies system, so the class become visible by
     Smalltalk"

    | nameComponents accessor nsName nsNameAsSymbol ns  |

    javaclass isSynthetic ifTrue:[ ^ self ].
    nameComponents := javaclass binaryName asCollectionOfSubstringsSeparatedBy:$/.
    nameComponents size > 1 ifTrue:[
        javaclass setCategory:((nameComponents asStringWith:$/ from:1 to:(nameComponents size - 1))
                            replaceAll:$/ with:$. ).
    ] ifFalse:[
        javaclass setCategory:#'(default)'
    ].

    nameComponents size > 1 ifTrue:[
        javaclass setPackage:((nameComponents copyButLast:1) asStringWith:$/) asSymbol
    ] ifFalse:[
        javaclass setPackage:#'java/(default)'
    ].

    "/ break up the package and create nameSpaces
    "/ for each package component.
    "/ This allows java.foo.bar to be visible in ST/X
    "/ under the name JAVA::java::foo::bar

    accessor := javaclass"JavaClassAccessor fullName: aString".
    nsName := javaclass nameSpaceName.
    nsNameAsSymbol := nsName asSymbolIfInterned.
    (nsNameAsSymbol isNil or:[(ns := Smalltalk at: nsNameAsSymbol) isNil]) ifTrue:[
        Metaclass confirmationQuerySignal answer:false do:[
            Class withoutUpdatingChangesDo:[
                ns := JavaPackage fullName:(nsName contents).
            ].
        ].
    ].
    ns isNameSpace ifTrue:[
        ns at:nameComponents last asSymbol put:accessor.
        javaclass setEnvironment: ns.
        javaclass setName: (nsName , '::' , nameComponents last) asSymbol
    ] ifFalse:[
        self breakPoint: #jv
    ].

    doNotify ifTrue:[
        notifier add:(Array with: #newClass with: javaclass).
    ].

    "Created: / 04-04-2012 / 10:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 19:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerClassRedefined: class
    "Class has been redefined, so we have to invalidate
     caches in coresponding java.lang.Class. Luckily enough,
     thee seem to be support for this - all we have to is to
     increase class redefinition count."

    | classObject classObjectRedefinitionCountIndex classObjectRedefinitionCount |

    classObject := JavaVM reflection javaClassObjectForClass: class.
    classObjectRedefinitionCountIndex := classObject class instVarIndexFor: #classRedefinedCount.
    classObjectRedefinitionCount := classObject instVarAt:classObjectRedefinitionCountIndex.
    classObjectRedefinitionCount := classObjectRedefinitionCount + 1.
    classObject instVarAt:classObjectRedefinitionCountIndex put: classObjectRedefinitionCount.

    "Created: / 15-08-2014 / 15:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerErroneous: aJavaClass
    lock critical:[    
        erroneous isNil ifTrue:[ erroneous := Set new ].
        erroneous add: aJavaClass
    ].

    "Created: / 20-09-2016 / 23:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2016 / 10:31:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClassInClassLoader: class
    "Unregisters class from it's classloader"

    "/ OpenJDK java.class.ClassLoader keeps list of all loaded classes
    "/ in a field `classes`. This method removes the class from the list.
    "/ This happens for instance when class is unloaded or reloaded.
    "/ For classes loaded by primordial class loader, `class classLoader1
    "/ returns nil.
    class classLoader notNil ifTrue:[
        (class classLoader instVarNamed: #classes) 
            perform: #'remove(Ljava/lang/Object;)Z' 
            with: (JavaVM reflection javaClassObjectForClass: class).
    ].

    "Created: / 11-08-2014 / 01:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterClassInSmalltalk: javaclass notify: doNotify
    "Unregisters given class from Smalltalk system dictionary
     so the class is no longer visible from Smalltalk"

    | nameInSmalltalk nameInSmalltalkSymbol nameSpace |

    "/ Must wait here - if classes are added and removed too fast,
    "/ a race condition occur in stx:libbasic code (something is
    "/ nilled menawhile and event handler does not handle this case.
    "/ This can happen for example when running tests...
    notifier waitUntilProcessed.

    javaclass isSynthetic ifTrue:[ ^ self ].
    nameSpace := javaclass nameSpace.
    nameInSmalltalk := javaclass nameInSmalltalk.
    nameInSmalltalkSymbol := nameInSmalltalk asSymbolIfInterned.
    nameInSmalltalkSymbol notNil ifTrue:[
        Smalltalk removeKey: nameInSmalltalkSymbol
    ].
    doNotify ifTrue:[
        notifier add:(Array with: #classRemove with: javaclass).
    ].

    [ nameSpace notNil and:[nameSpace ~~ JAVA and:[nameSpace allClasses size == 0]]] whileTrue:[
        Smalltalk removeClass: nameSpace.
        nameSpace := nameSpace nameSpace.
    ].

    "Created: / 04-04-2012 / 10:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2013 / 10:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregisterErroneous: aJavaClass
    lock critical:[
        erroneous remove: aJavaClass.
        erroneous := erroneous asNilIfEmpty.
    ]

    "Created: / 20-09-2016 / 23:18:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-09-2016 / 10:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRegistry class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassRegistry.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_SVN
    ^ '§Id§'
! !

