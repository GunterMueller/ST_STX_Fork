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

Object subclass:#JavaClassReloader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

Notification subclass:#RecompileRequest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassReloader
!

Notification subclass:#ReloadRequest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassReloader
!

JavaClassReloader subclass:#SingleClassReloader
	instanceVariableNames:'oldClass newClass mustMigrateInstances mustMigrateClass
		instFieldMapping staticFieldMapping'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassReloader
!

Object subclass:#FieldMapping
	instanceVariableNames:'old new'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClassReloader::SingleClassReloader
!

!JavaClassReloader class methodsFor:'documentation'!

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
    A main workhorse for reloading (updating) java classes
    in running system.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClassReloader class methodsFor:'reloading'!

reload: oldClass with: newClass
    "Update old class to match the definition of newClass"
    ^ self new reload: oldClass with: newClass

    "Created: / 20-02-2012 / 23:29:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-09-2013 / 15:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unload: oldClass 
    "Remove oldClass from the system"
    ^ self new unload: oldClass

    "Created: / 14-09-2013 / 15:52:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unload: oldClass ignoring: ignoredClasses
    "Remove oldClass from the system"
    ^ self new unload: oldClass ignoring: ignoredClasses

    "Created: / 10-10-2014 / 12:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader class methodsFor:'reloading-requests'!

requestRecompile: aJavaClass
    RecompileRequest newException
        parameter: aJavaClass;
        raiseRequest

    "Created: / 08-10-2013 / 19:26:20 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 20:40:09 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 01:19:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requestReload: aJavaClass
    ReloadRequest newException
        parameter: aJavaClass;
        raiseRequest

    "Created: / 08-10-2013 / 19:26:12 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 01:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader methodsFor:'reloading'!

reload: oldClass with: newClass

    | newClassToInstall recompileRequests reloadRequests |

    reloadRequests := Set new.
    recompileRequests := Set new.
    [
        newClassToInstall := SingleClassReloader new reload: oldClass with: newClass.
        "Also, reload all subclasses - fields may have changed!!"
        newClassToInstall ~~ oldClass ifTrue: [
            oldClass mergeVersionsWith: newClassToInstall.
            oldClass subclassesDo:[:oldSubclass|
                | newSubclass |

                newSubclass := oldSubclass copy.
                newSubclass setSuperclass: newClassToInstall.
                newSubclass instSize: (newClassToInstall instSize + oldSubclass fields size).
                self requestReload: newSubclass.
            ].
        ].
    ] on: RecompileRequest do:[:recompileRequest |
        "/ Catch all recompile requests
        (recompileRequests contains:[:each | each parameter == recompileRequest parameter]) ifFalse:[
            recompileRequests add: recompileRequest
        ].
        recompileRequest proceed.
    ] on: ReloadRequest do:[:reloadRequest |
        "/ Catch all reload requests
        (reloadRequests contains:[:each | each parameter == reloadRequest parameter]) ifFalse:[
            reloadRequests add: reloadRequest
        ].
        reloadRequest proceed.
    ].
    "/ Remove all reload request for classes for which there have been
    "/ recompile request as recompile implies reload...
    reloadRequests := reloadRequests reject:[:each | recompileRequests contains:[:eachRecompile | each parameter == eachRecompile parameter]].
    "/ Now execute all deferred recompile/reload requests.
    recompileRequests do:[:each | each recompile ].
    reloadRequests do:[:each | each reload ].

    ^newClassToInstall.

    "Created: / 04-04-2012 / 01:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 20:52:58 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 15-10-2013 / 01:16:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unload: oldClass ignoring: ignoredClasses

    ignoredClasses add: oldClass.
    oldClass subclassesDo:[:subclass |
        (ignoredClasses includes: subclass) ifFalse:[
            JavaVM registry unregisterClass: subclass ignoring: ignoredClasses
        ].
    ].
    oldClass innerClassesIgnoreUnloaded do:[:innerclass |
        (ignoredClasses includes: innerclass) ifFalse:[
            "/ nil out EnclosingMethod so subsequent
            "/ calls to owningClasse would return nil
            innerclass attributes removeKey: #EnclosingMethod ifAbsent:[].
            JavaVM registry unregisterClass: innerclass ignoring: ignoredClasses
        ]
    ].
    oldClass anonymousClassesIgnoreUnloaded do:[:anonymousClass |
        (ignoredClasses includes: anonymousClass) ifFalse:[
            "/ nil out EnclosingMethod so subsequent
            "/ calls class to owningClasse would return nil
            anonymousClass attributes removeKey: #EnclosingMethod ifAbsent:[].
            JavaVM registry unregisterClass: anonymousClass ignoring: ignoredClasses
        ]
    ].

    JavaVM registry allClassesDo:[:cls|
        "/ JV: Q: Should we remove all users of the interface? Let's do it, but not
        "/        sure if that's necessary/desirable
        | ifaces |

        ifaces := cls interfaces.
        ifaces notNil ifTrue:[
            (ifaces anySatisfy:[:iface | iface == oldClass]) ifTrue:[
                (ignoredClasses includes: cls) ifFalse:[
                    JavaVM registry unregisterClass: cls ignoring: ignoredClasses
                ].
            ].
        ].
        cls constantPool invalidateForClass: oldClass binaryName
    ]

    "Created: / 10-10-2014 / 12:14:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-12-2014 / 22:14:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader methodsFor:'reloading-requests'!

requestRecompile:aJavaClass
    ^ self class requestRecompile:aJavaClass
!

requestReload:aJavaClass
    ^ self class requestReload:aJavaClass
! !

!JavaClassReloader::RecompileRequest methodsFor:'default actions'!

defaultAction
    "the default action is to return the default value.
     Subclasses may redefine this"

    ^ self recompile

    "Created: / 15-10-2013 / 00:31:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recompile
    JavaCompiler recompile: self parameter

    "Created: / 15-10-2013 / 00:48:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::ReloadRequest methodsFor:'default actions'!

defaultAction
    "the default action is to return the default value.
     Subclasses may redefine this"

    ^ self reload

    "Created: / 15-10-2013 / 00:37:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reload
    JavaVM registry registerClass: self parameter.

    "Created: / 15-10-2013 / 00:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader methodsFor:'private'!

invalidate

    | anyInvalidated |

    anyInvalidated := false.
    JavaVM registry allClassesDo:[:class|
        anyInvalidated := (self invalidateClass: class) | anyInvalidated.
    ].
    anyInvalidated ifTrue:[ObjectMemory flushCaches].

    "
    Eclipse Compiler for Java is too smart - when a field is not accessible, it doesn't generate
    GETFIELD instructions, it generates ATHROW which throws stx.libjava.tools.compiler.CompileError
    (originally, it throws java.lang.Error, but we hacked it - see CompilerError static initializer.

    Here we recompile all classes with CompileError - just to be safe.
    "
    "/JavaCompiler recompileErroneousClassesReferringTo: newClass ignoring: oldClass.

    "Created: / 21-02-2012 / 09:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 23:27:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 18:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateClass: javaClass
    ^ javaClass ~~ oldClass and:[javaClass constantPool invalidateForClass: oldClass binaryName]

    "Created: / 21-02-2012 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 13-10-2013 / 20:43:57 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 17-10-2013 / 02:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrate
    "Possibly migrate instances and class. Return the class that should
     be installed in registry once reloader finishes his job.

     At this point, all references are already invalidated (see #reload)
     "

    mustMigrateInstances ifTrue:[
        self migrateInstances.
        mustMigrateClass ifTrue:[
            self migrateClass
        ].
        ^newClass.
    ].

    mustMigrateClass ifTrue:[
        self migrateClass.
        ^newClass.
    ].
    self updateOldClass.
    ^oldClass.

    "Created: / 20-02-2012 / 23:40:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 16-12-2012 / 17:39:26 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

migrateClass

    "/self error:'Not yet supported'

    "Created: / 21-02-2012 / 11:04:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrateInstance: object

    self assert: object class == oldClass.

    "Created: / 30-03-2012 / 19:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrateInstances

    oldClass allInstancesDo:[:i|
        self migrateInstance:i.
    ].

    "Created: / 21-02-2012 / 11:04:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepare
    "Analyze and prepare data for reloading"

    self prepareInstFieldMapping.
    self prepareStaticFieldMapping.

    "Created: / 20-02-2012 / 23:40:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepareFieldMap: fields
    | map |

    map := Dictionary new.
    fields do:[ :field | map at: field name put: field ].
    ^map

    "Created: / 21-02-2012 / 09:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepareInstFieldMapping
    "Scans both old and new class inst fields and create a mapping.
     Sets mustMigrateInstances"

    | newFields |

    mustMigrateInstances := false.
    instFieldMapping := Set new.
    newFields := self prepareFieldMap: newClass allFields.
    oldClass fields do:[:old|
        | new mapping |

        new := newFields at: old name ifAbsent:[nil].
        new notNil ifTrue:[ newFields removeKey: old name ].
        mapping := FieldMapping old: old new: new.
        mustMigrateInstances := mustMigrateInstances or:[mapping mustMigrate].
        instFieldMapping add: mapping.
    ].
    "Remaining fields are new, i.e., does not exist in
     old class. Add them to the mapping"
    newFields do:[:new|
        instFieldMapping add: (FieldMapping old: nil new: new).
        mustMigrateInstances := true
    ].

    "Created: / 21-02-2012 / 09:32:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prepareStaticFieldMapping
    "Scans both old and new class inst fields and create a mapping.
     Sets mustMigrateInstances"

    | newFields |

    mustMigrateClass := false.
    staticFieldMapping := Set new.
    newFields := self prepareFieldMap: newClass allStaticFields.
    oldClass staticFields do:[:old|
        | new mapping |

        new := newFields at: old name ifAbsent:[nil].
        new notNil ifTrue:[ newFields removeKey: old name ].
        mapping := FieldMapping old: old new: new.
        mustMigrateClass:= mustMigrateClass or:[mapping mustMigrate].
        staticFieldMapping add: mapping.
    ].
    "Remaining fields are new, i.e., does not exist in
     old class. Add them to the mapping"
    newFields do:[:new|
        staticFieldMapping add: (FieldMapping old: nil new: new).
        mustMigrateClass:= true
    ].

    "Created: / 21-02-2012 / 09:45:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateOldClass
    "At this point we know that both classes have same layout. So we can
     simply copy methods and other info from new class to old one.
     References must be flushed anyway!! We need to copy constant pool over,
     indices may have changed. And we will copy fields as well, types may
     have been generalized.

     Also, here we also track method added and removed and if either
     one is an overload, request recompile of all dependent classes.
    "

    | oldMethods oldMethodsRemoved newMethods newMethodsAdded |

    oldMethods := oldClass methodDictionary.
    oldMethodsRemoved := oldMethods values asSet.
    newMethods := newClass methodDictionary copy.
    newMethodsAdded := Set new.
    newMethods keysDo:[:selector|
        | oldM newM |

        oldM := oldMethods at: selector ifAbsent:[nil].
        newM := newMethods at: selector.
        oldM notNil ifTrue:[ 
            oldMethodsRemoved remove: oldM
        ] ifFalse:[
            newMethodsAdded add: newM.
        ].
    ].

    oldClass isInitialized ifTrue:[ newClass classInit ].

    newMethods do:[:m|m setJavaClass: oldClass].
    oldClass setAccessFlags: newClass accessFlags.    
    oldClass setAttributes: newClass attributes.
    oldClass annotations: newClass annotations.
    oldClass setMethodDictionary: newMethods constantPool: newClass constantPool.
    oldClass setSource: newClass sourceString.
    oldClass setFields: newClass fields.
    oldClass setStaticFields: newClass staticFields.
    "Flush all proxies, they may refer to old static methods"
    oldClass class setMethodDictionary: MethodDictionary new.

    oldMethodsRemoved do:[:oldMRemoved |
        oldMRemoved isJavaMethod ifTrue:[
            self requestRecompileSendersOf: oldMRemoved.
        ].
    ].
    newMethodsAdded do:[:newMAdded |
        | overloads name |

        newMAdded isStatic ifFalse:[
            overloads := Set new.
            name := newMAdded name.
            self withAllSuperclassesAndInterfacesOf: newMAdded javaClass do:[:cls|
                cls methodDictionary keysAndValuesDo:[:selector :method |
                    (method ~~ newMAdded and:[method isStatic not and:[method name = name]]) ifTrue:[
                        overloads add: method.
                    ].
                ].
            ].
            overloads do:[:overloadedM |
                self requestRecompileSendersOf: overloadedM.
            ].
        ]
    ].

    "Created: / 16-12-2012 / 17:36:52 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 19:20:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 21-09-2016 / 09:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader methodsFor:'private-helpers'!

withAllSuperclassesAndInterfacesOf: aJavaClass do: aBlock
    | queue seen |

    queue := OrderedCollection with: aJavaClass.
    seen := Set new.
    [ queue isEmpty ] whileFalse:[
        | cls |

        cls := queue removeFirst.
        (seen includes: cls) ifFalse:[
            seen add: cls.
            aBlock value: cls.
            queue addAll: cls interfaces.
            cls superclass ~~ JavaObject ifTrue:[
                queue add: cls superclass.
            ].
        ].
    ].

    "Created: / 15-10-2013 / 01:55:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader methodsFor:'reloading'!

reload
    | reloadedClass |

    self prepare.
    oldClass synchronized:[
        newClass synchronized:[
            self invalidate.
            reloadedClass := self migrate.
        ]
    ].
    ^ reloadedClass

    "Created: / 20-02-2012 / 23:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2015 / 08:47:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reload: oldClassA with: newClassA

    oldClass := oldClassA.
    newClass := newClassA.
    ^ self reload.

    "Created: / 20-02-2012 / 23:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader methodsFor:'reloading-requests'!

requestRecompileSendersOf: givenMethod
    JavaVM registry allClassesDo:[:cls|
        "/ Avoid recursive recompilation for the reloaded class itself, 
        "/ it'll go soon...
        cls == oldClass ifFalse:[ 
            | recompile |
            recompile := cls constantPool contains:[:entry |
                            entry isJavaRef
                                and:[ entry isJavaMethodRef
                                and:[entry classRef name = givenMethod javaClass binaryName
                                and:[(entry nameAndType name , entry nameAndType descriptor) = givenMethod selector]]]].
            recompile ifTrue:[
                self requestRecompile: cls.
            ].
        ]
    ].

    "Created: / 15-10-2013 / 01:52:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2015 / 05:56:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-04-2015 / 08:42:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader::FieldMapping class methodsFor:'instance creation'!

old: old new:new

    ^self new old: old new: new.

    "Created: / 21-02-2012 / 09:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader::SingleClassReloader::FieldMapping methodsFor:'accessing'!

new
    ^ new
!

new:something
    new := something.
!

old
    ^ old
!

old:something
    old := something.
!

old:oldArg new:newArg
    old := oldArg.
    new := newArg.
! !

!JavaClassReloader::SingleClassReloader::FieldMapping methodsFor:'queries'!

mustMigrate
    "Returns true if the field must be migrated, false otherwise"

    | oldD newD |

    (old isNil or:[new isNil]) ifTrue:[
        ^ true "Either one is missing, must migrate"
    ].

    old index ~~ new index ifTrue:[
        ^ true "Offsets changed, must migrate"
    ].

    oldD := old descriptor.
    newD := new descriptor.

    oldD = newD ifTrue:[
        ^false"Same descriptor, the easy case"
    ].

    (oldD first == $L and: [newD first == $L]) ifTrue:[
        (oldD = newD) ifTrue: [ ^ true ] ifFalse: [
            ^ [
                (old typeClass includesBehavior: new typeClass) not.
            ] on: JAVA java lang ClassNotFoundException do:[
                false
            ]
        ].
    ].

    1 to: (oldD size min: newD size) do:[:i|
        ((oldD at: i) == $L and: [ (newD at: i) == $L ]) ifTrue:[
            (oldD = newD) ifTrue: [ ^ true ] ifFalse: [
                ^ [
                    (old typeClass includesBehavior: new typeClass) not.
                ] on: JAVA java lang ClassNotFoundException do:[
                    false
                ]
            ].
        ].
        ((oldD at: i) ~~ $[ or: [ (newD at: i) ~~ $[ ]) ifTrue:[
            ^true"Different primitive/array types, must migrate"
        ].
    ].

    ^false

    "Created: / 21-02-2012 / 10:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2013 / 19:26:19 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 28-10-2013 / 11:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassReloader class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassReloader.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

