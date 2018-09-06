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

Object subclass:#JavaRelease
	instanceVariableNames:'javaHome sourcePath classes bundle bootClassPath'
	classVariableNames:'System SystemInitialized'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

JavaRelease class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

JavaRelease subclass:#OpenJDK6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK6 subclass:#AppleJDK6
	instanceVariableNames:'jdkHome'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK6 subclass:#OpenJDK7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK7 subclass:#OpenJDK8
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK6 subclass:#OracleJDK6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK7 subclass:#OracleJDK7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OracleJDK7 subclass:#OracleJDK8
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease subclass:#SunJDK122
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK7 subclass:#Zulu7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

JavaRelease::OpenJDK8 subclass:#Zulu8
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaRelease
!

!JavaRelease class methodsFor:'documentation'!

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
    Sub-instance of me represent a particular Java release and provides and
    access to JDK/JRE files as well and native method implementation and other
    things that are release-dependent.

    There is a guessing mechanism trying to auto-detect path to JRE/JDK. If it fails,
    you may always set javaHome manually (see #javaHome:).

    NOTE: an instance of OpenJDKx and OracleJDKx represent and provide access to both,
          plain JRE or full JDK.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        javaHome <String> ..... path to either JDK or JRE, ie., path to directory in which
                                * exists bin/java (bin\java.exe) - then javaHome is considered
                                  a path to JRE
                                __or__
                                * exists bin/javac (bin\javac.exe) - then javaHome is considered 
                                  a path JDK

    [class variables:]

    [see also:]

"
! !

!JavaRelease class methodsFor:'initialization'!

flush
    Java release: nil.
    instance := nil.
    self subclasses do:[:e|e flush].
    System := nil.
    SystemInitialized := false.

    "
        JavaRelease flush.
    "

    "Created: / 12-02-2013 / 03:20:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2016 / 20:30:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    SystemInitialized := false.

    "
        JavaRelease flush.
    "

    "Created: / 13-04-2016 / 20:30:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease class methodsFor:'instance creation'!

JDK6
    "Meta-release - return either OpenJDK or OracleJDK"

    self openJDK6 isAvailable ifTrue:[^ self openJDK6].
    self oracleJDK6 isAvailable ifTrue:[^ self oracleJDK6].
    self allSubclassesDo:[:relCls |
        | rel |

        rel := relCls instance.
        (relCls isJDK6 and:[ rel isAvailable ]) ifTrue:[^ rel ].
    ].
    self error:'no JDK6 found'

    "Created: / 16-02-2013 / 09:21:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2014 / 13:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

JDK7
    "Meta-release - return either OpenJDK or OracleJDK"

    self openJDK7 isAvailable ifTrue:[^ self openJDK7].
    self oracleJDK7 isAvailable ifTrue:[^ self oracleJDK7].
    self allSubclassesDo:[:relCls |
        | rel |

        rel := relCls instance.
        (relCls isJDK7 and:[ rel isAvailable ]) ifTrue:[^ rel ].                   ].
    self error:'no JDK7 found'

    "
        JavaRelease JDK6
        JavaRelease JDK7

    "

    "Created: / 16-02-2013 / 09:21:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2014 / 13:33:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

JDK8
    "Meta-release - return either OpenJDK or OracleJDK"

    self openJDK8 isAvailable ifTrue:[^ self openJDK7].
    self oracleJDK8 isAvailable ifTrue:[^ self oracleJDK7].
    self allSubclassesDo:[:relCls |
        | rel |

        rel := relCls instance.
        (relCls isJDK8 and:[ rel isAvailable ]) ifTrue:[^ rel ].                   ].
    self error:'no JDK8 found'

    "
        JavaRelease JDK6
        JavaRelease JDK7

    "

    "Created: / 03-04-2014 / 12:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

appleJDK6
    ^ AppleJDK6 instance

    "Created: / 06-02-2014 / 11:01:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openJDK6
    ^ OpenJDK6 instance

    "Created: / 27-10-2010 / 21:41:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-11-2011 / 18:45:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-07-2012 / 00:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openJDK7
    ^ OpenJDK7 instance.

    "Created: / 26-07-2012 / 23:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openJDK8
    ^ OpenJDK8 instance.

    "Created: / 03-04-2014 / 12:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oracleJDK6
    ^ OracleJDK6 instance

    "Created: / 12-02-2013 / 03:03:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oracleJDK7
    ^ OracleJDK7 instance

    "Created: / 12-02-2013 / 03:03:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

oracleJDK8
    ^ OracleJDK8 instance

    "Created: / 03-04-2014 / 12:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

osxJDK6
    <resource: #obsolete>
    ^ self appleJDK6

    "Modified: / 06-02-2014 / 11:01:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sunJDK122
    ^ SunJDK122 instance

    "Created: / 27-10-2010 / 21:41:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-11-2011 / 18:45:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-07-2012 / 00:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zulu7
    ^ Zulu7 instance.

    "Created: / 26-02-2015 / 16:08:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zulu8
    ^ Zulu8 instance.

    "Created: / 11-03-2015 / 11:00:47 / jv"
! !

!JavaRelease class methodsFor:'accessing'!

all
    ^(self allSubclasses
                reject: [:rel | rel isAbstract ]
                thenCollect: [:rel | rel instance ])
                asSortedCollection: [:a :b | a priority > b priority ]


    "
        JavaRelease all
    "

    "Created: / 27-07-2012 / 00:10:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allForCurrentOperatingSystem
    "Return all releases for current operating system, even those that
     are not installed / autodetected.

     For example, there's no AppleJDK for Linux or OpenJDK for Windows.
    "

    ^ self all select:[:each | each isAvailableOnCurrentOperatingSystem ]

    "
        JavaRelease allForCurrentOperatingSystem
    "

    "Created: / 07-12-2014 / 23:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

any
    <resource: #obsolete>
    | releases |

    releases := self available.
    releases isEmptyOrNil ifTrue:[ ^ nil ].
    ^ releases first initialize


    "
        JavaRelease any
    "

    "Created: / 22-11-2010 / 13:11:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-11-2011 / 14:02:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 26-07-2012 / 23:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

available
    | releases out path |

    releases := self allForCurrentOperatingSystem select: [:rel | rel isAvailable ].
    releases isEmpty ifTrue: [
        "/ none of the releases seems to be installed in a way that it is found
        "/ out of the box. Try a 'java' command...
        (path := OperatingSystem pathOfCommand:'java') notNil ifTrue:[
            out := WriteStream on:(String new:100).
            (OperatingSystem executeCommand:'java -version' outputTo:out) ifTrue:[
                out := out contents.
                releases := self all select:[:rel | rel validateJavaVersionString:out].
"/                "/ ('/System/Library/Java' asFilename) exists.
"/                releases do:[:each |
"/                    each javaHome:('/System/Library/Java/Home' asFilename).
"/                ].
            ].
        ].
        releases isEmpty ifTrue: [
            self error: 'No Java release found'. ^nil
        ].
    ].
    ^releases

    "
        JavaRelease available
    "

    "Created: / 26-07-2012 / 23:41:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2014 / 00:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

default
    | releases release |

    releases := self available.
    release := releases detect:[:each | each isJava8 not ] ifNone:[ ^ nil ].
    release initialize.
    ^ release

    "
    JavaRelease default
    "

    "Created: / 11-11-2013 / 14:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-05-2017 / 12:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forExecutable: javaExecutable
    "Returns an instance of JavaRelease for given java executable
     (java.exe on Windows, java on UNIX). Return nil if javaExecutable
     does not exits, not executable or version of that Java version is
     not recognized/suppported."

    javaExecutable notNil ifTrue:[
        | releases |
        releases := JavaRelease allSubclasses reject:[:each | each isAbstract ] thenCollect:[:each | each new ].
        releases sort:[:a :b | a priority > b priority ].
        releases do:[:release |
            (release validateJavaExecutable: javaExecutable) ifTrue:[
                release javaExecutable: javaExecutable.
                ^ release.
            ].
        ]

    ].
    ^ nil.

    "Created: / 08-04-2014 / 14:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2016 / 20:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inDirectory:javaHome
    "Returns an instance of JavaRelease for given javaHome or nil if
     given javaHome does not point to Java installation directory."

    self available do:[:each | (each javaHome = javaHome) ifTrue:[ ^ each ] ].

    javaHome notNil ifTrue:[
        | releases |
        releases := self allSubclasses reject:[:each | each isAbstract ] thenCollect:[:each | each new ].
        releases sort:[:a :b | a priority > b priority ].
        releases do:[:release |
            (release validateJavaHome: javaHome) ifTrue:[
                release javaHome: javaHome.
                ^ release.
            ].
        ]
    ].
    ^ nil.

    "Created: / 11-11-2013 / 14:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2014 / 13:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

system
    "Return the release for *system* java or nil if no system JDK/JRE
     installation is available.

     By *system* JDK/JRE we mean JDK/JRE used by `java` command found along the path"

    | javaExecutable |

    SystemInitialized ifFalse:[
        "/ On Windows, search registry first...
        OperatingSystem isMSWINDOWSlike ifTrue:[
            "Search for JDK first..."

            | entry javaVersion javaHome |
            entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit'.
            entry notNil ifTrue:[
                javaVersion := entry valueNamed:'CurrentVersion'.
                javaVersion notNil ifTrue:[
                    entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\' , javaVersion.
                    entry notNil ifTrue:[
                        javaHome := entry valueNamed:'JavaHome'.
                    ]
                ]
            ].
            javaHome isNil ifTrue:[
                "/ JDK not found, look for JRE...
                entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment'.
                entry notNil ifTrue:[
                    javaVersion := entry valueNamed:'CurrentVersion'.
                    javaVersion notNil ifTrue:[
                        entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment\' , javaVersion.
                        entry notNil ifTrue:[
                            javaHome := entry valueNamed:'JavaHome'.
                        ]
                    ]
                ].
            ].
            (javaHome notNil and:[javaHome asFilename isDirectory]) ifTrue:[
                javaVersion = '1.6' ifTrue:[
                    System := OracleJDK6 new javaHome: javaHome
                ] ifFalse:[
                javaVersion = '1.7' ifTrue:[
                    System := OracleJDK7 new javaHome: javaHome
                ] ifFalse:[
                javaVersion = '1.8' ifTrue:[
                    System := OracleJDK8 new javaHome: javaHome
                ]]]
            ].
        ] ifFalse:[
            javaExecutable isNil ifTrue:[javaExecutable := OperatingSystem pathOfCommand: 'java'].
            javaExecutable isNil ifTrue:[ ^ nil ].
            "/ On some Linux installations, /usr/bin/java -> /etc/alternatives/java -> /usr/lib/jvm/.../jre/java/bin,
            "/ care for that.
            javaExecutable := javaExecutable asFilename asAbsoluteFilename.
            javaExecutable isSymbolicLink ifTrue:[
                javaExecutable := javaExecutable physicalFilename.
                javaExecutable isNil ifTrue:[
                    "/ Broken link, ignore...
                    ^ nil
                ].
                javaExecutable := javaExecutable asAbsoluteFilename.
            ].
            System := JavaRelease forExecutable: javaExecutable.
        ].
        "/ Use the autodetected release if that's the system one...
        System notNil ifTrue:[
            System javaHome = System class instance javaHome ifTrue:[
                System := System class instance
            ].
        ].
        SystemInitialized := true.
    ].
    ^ System

    "
        System := nil
        JavaRelease system
        JavaRelease system == JavaRelease system class instance
    "

    "Created: / 11-11-2013 / 14:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2016 / 20:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease class methodsFor:'instance creation-private'!

instance
    instance isNil ifTrue:[
        instance := self new initialize
    ].
    ^instance

    "Created: / 27-07-2012 / 00:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease class methodsFor:'queries'!

isAbstract

    ^self class == JavaRelease

    "Created: / 22-11-2010 / 13:33:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJDK6
    ^ false
!

isJDK7
    ^ false
!

isJDK8
    ^ false

    "Created: / 03-04-2014 / 12:34:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'accessing'!

bootClassPath
    "Returns a default value of sun.boot.class.path"

    bootClassPath isNil ifTrue:[
        | jreHome libs |

        jreHome := self jreHome.
        jreHome notNil ifTrue:[
            libs := jreHome / (self libDirInJreHome).
            bootClassPath := OrderedCollection new.
            libs exists ifFalse:[
                self error:'no lib found in jre home directory'
            ] ifTrue:[
                libs directoryContentsAsFilenames do:[:each|
                    |pathName baseName|

                    baseName := each baseName.
                    (baseName endsWith:'.jar') ifTrue:[
                        pathName := each pathName.
                        (baseName endsWith: (self nameOf_rt_dot_jar)) ifTrue:[
                            bootClassPath addFirst: pathName
                        ] ifFalse:[
                            bootClassPath addLast: pathName
                        ]
                    ].
                ].
            ].
        ].
    ].
    ^bootClassPath.

    "
    Java release bootClassPath
    Java release jreHome
    "

    "Created: / 02-11-2011 / 12:19:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 31-07-2012 / 10:16:25 / jv"
    "Modified: / 23-01-2013 / 15:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 11-04-2013 / 14:30:16 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

bootClassPath:aCollectionOfPathes
    "Change the bootClassPath"

    bootClassPath := OrderedCollection withAll:aCollectionOfPathes.

    "
    Java release bootClassPath
    "
!

javaBinDirOnUNIX

    ^ self jreHome / 'bin'
!

javaBinDirOnWindows

    ^ self jreHome / 'bin'
!

javaBundle
    "Returns bundle representing Java code (both core + extections)"

    bundle isNil ifTrue:[
        bundle := JavaCodeBundle new
                    name: self name;
                    add: self bootBundle;
                    add: self extBundle;
                    yourself.
    ].
    ^bundle

    "Created: / 12-02-2013 / 14:56:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExecutable: aStringOrFilename
    self javaHome: (self javaHomeForJavaExecutable: aStringOrFilename)

    "Created: / 17-04-2014 / 20:04:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExecutableForJavaHome: javaHomeArg
    "For given java home (path to JRE root if JRE, or JDK root if part of full JDK) return
     path to java executable (java.exe on Windows, java on UNIX). If no executable is found
     in given root, return nil."

    | javaHomeDirectory javaExecutableName javaExecutable |

    "/ By default, java executable is either in <jdk root>/jre/bin or
    "/ <jre root>/bin. So far only AppleJDK is different...

    javaHomeArg isNil ifTrue:[ ^ nil ].
    javaHomeDirectory := javaHomeArg asFilename asAbsoluteFilename.
    javaHomeDirectory exists ifFalse:[ ^ nil ].
    javaHomeDirectory isDirectory ifFalse:[ ^ nil ].
    javaExecutableName := OperatingSystem isMSWINDOWSlike ifTrue:[ 'java.exe' ] ifFalse:[ 'java' ].

    "/ Try JDK...
    javaExecutable := javaHomeDirectory / 'jre' / 'bin' / javaExecutableName.
    javaExecutable exists ifTrue:[ ^ javaExecutable ].

    "/ Try JRE...
    javaExecutable := javaHomeDirectory / 'bin' / javaExecutableName.
    javaExecutable exists ifTrue:[ ^ javaExecutable ].

    ^ nil

    "
    JavaRelease basicNew javaExecutableForJavaHome: (OperatingSystem pathOfCommand:'java') asFilename directory directory.
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/lib/jvm/java-7-openjdk-amd64/jre'
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/lib/jvm/java-7-openjdk-amd64'
    JavaRelease basicNew javaExecutableForJavaHome: 'xxxx'
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/bin'
    "

    "Created: / 08-04-2014 / 14:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExtDirs

    "Returns a default value of java.ext.dirs property"

    OperatingSystem isUNIXlike ifTrue:[ ^ self javaExtDirsOnUNIX ].
    OperatingSystem isMSWINDOWSlike ifTrue:[ ^ self javaExtDirsOnWindows ].
    self error:'Unsupported platform'.
    ^ #()


    "
        JavaRelease openJDK6 classPath
    "

    "Modified: / 27-10-2010 / 21:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 31-08-2011 / 19:59:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExtDirsOnUNIX

    ^#()

    "Created: / 31-08-2011 / 19:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExtDirsOnWindows

    ^#()

    "Created: / 31-08-2011 / 19:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHome
    "Answer a Java home. This is either path to JRE (no JDK is found) or to
     full JDK (if JDK is installed)

     If you want path to either JRE or JDK, use
     #jreHome
     #jdkHome

     "

    javaHome isNil ifTrue:[
        javaHome := self searchForJavaHome.
    ].
    ^javaHome

    "
        JavaRelease openJDK6 javaHome
    "

    "Created: / 27-10-2010 / 18:59:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 00:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-01-2013 / 12:19:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHome: aString
     javaHome := aString.
     self searchForSourcePath.

    "
        JavaRelease openJDK6 javaHome
    "

    "Created: / 26-07-2012 / 23:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2013 / 02:58:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomeForJavaExecutable: javaExecutable
    "For given java executable (java.exe on Windows, java on UNIX) return
     a Java home (path to JRE root (if JRE) or JDK root (if part of full JDK).
     Upon failure (executable does not seem to be a part of JRE nor JDK), return
     nil."

    | javaExecutableFilename dir |

    "/ By default, java executable is either in <jdk root>/jre/bin or
    "/ <jre root>/bin. So far only AppleJDK is different...

    javaExecutable isNil ifTrue:[ ^ nil ].
    javaExecutableFilename := javaExecutable asFilename asAbsoluteFilename.
    javaExecutableFilename exists ifFalse:[ ^ nil ].
    javaExecutableFilename isExecutable ifFalse:[ ^ nil ].
    dir := javaExecutableFilename directory.
    dir baseName ~= 'bin' ifTrue:[ ^ nil ].
    dir := dir directory.
    ^ dir baseName = 'jre' ifTrue:[ dir directory pathName ] ifFalse:[ dir pathName]

    "
    JavaRelease basicNew javaHomeForJavaExecutable: (OperatingSystem pathOfCommand:'java')
    JavaRelease basicNew javaHomeForJavaExecutable: '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java'
    JavaRelease basicNew javaHomeForJavaExecutable: 'xxxx'
    JavaRelease basicNew javaHomeForJavaExecutable: '/usr'
    "

    "Created: / 08-04-2014 / 14:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2014 / 00:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomeOnWindowsFromRegistryForRelease: vsn
    "Return path to java home (either JDK or JRE) based on values in registry.
     If not on windows or registry key not found, return nil. 

     CAVEAT: This method only finds Oracle JDKs"

    |entry home |

    OperatingSystem isMSWINDOWSlike ifFalse:[ ^ nil ].
    "Search for JDK first, prefer 46 bit over 32 bit (even though it does not matter for STX:LIBJAVA)"
    entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\', vsn flags: #KEY_WOW64_64KEY.
    entry isNil ifTrue:[ 
        entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\', vsn flags: #KEY_WOW64_32KEY.
    ].
    "Search for JRE...."
    entry isNil ifTrue:[ 
        entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment\', vsn flags: #KEY_WOW64_64KEY.
    ].
    entry isNil ifTrue:[ 
        entry := OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment\', vsn flags: #KEY_WOW64_32KEY.
    ].
    entry notNil ifTrue:[
        home := entry valueNamed:'JavaHome'.
        (home notNil and:[home asFilename exists]) ifTrue:[ ^ home ].
    ].
    ^ nil

    "
    JavaRelease::OracleJDK7 new searchForJavaHome
    JavaRelease::OracleJDK8 new searchForJavaHome
    "

    "Created: / 16-02-2013 / 02:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2013 / 03:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 13-03-2015 / 15:41:40 / jv"
!

javaHomeOrNil
    "Answer a Java home"

    | home |

    home := javaHome isNil ifTrue:[ self searchForJavaHome ] ifFalse:[ javaHome ].
    ^ home

    "
        JavaRelease openJDK6 javaHome"

    "Created: / 22-11-2010 / 13:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:51:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomes

    "Answer a set of possible java homes, those directories are searched"

    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem isOSXlike ifTrue:[ ^ self javaHomesOnOSX ].
        ^ self javaHomesOnUNIX
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[ ^ self javaHomesOnWindows ].
    self error:'Unsupported platform'.
    ^ #()

    "Modified: / 22-11-2010 / 13:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnOSX
    "/ to be redefined in OSX release classes
    ^ #()
!

javaHomesOnUNIX
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

javaHomesOnWindows
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

javaLibDir
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ self javaLibDirOnWindows
    ].
    ^ self javaLibDirOnUnix
!

javaLibDirOnUnix

    ^ self jreHome / self libDirInJreHome
!

javaLibDirOnWindows

    ^ self jreHome / self libDirInJreHome
!

javaNativeLibDirOnUnix

    ^ self jreHome / self nativeLibDirInJreHome
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ self subclassResponsibility

    "Created: / 16-01-2013 / 19:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

jdkHome

    "Answers the directory where the JDK lives or nil, if no JDK is found"

    | jdkHome |

    self javaHome isNil ifTrue:[ ^ nil ].

    ^((jdkHome := self javaHome) asFilename / 'jre') exists
        ifTrue:[jdkHome]
        ifFalse:[nil].

    "
        Java release searchForJavaHome; jdkHome
    "

    "Created: / 23-01-2013 / 12:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

jniLibDirInJreHome
    "Returns the relative path to the native lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Libraries' - sigh"

    ^ 'lib'
!

jreHome

    "Answers the directory where the JRE lives"

    | javaHome jreHome |

    (javaHome := self javaHome) isNil ifTrue:[ ^ nil ].
    javaHome := javaHome asFilename.
    ^(jreHome := javaHome / 'jre') exists
        ifTrue:[jreHome]
        ifFalse:[javaHome].

    "Created: / 27-10-2010 / 21:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libDirInJreHome
    "Returns the relative path to the lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Classes' - sigh"

    ^ 'lib'
!

name

    "Answer a human readable name of the Java release such as Sun JDK 1.2.2 or OpenJDK 6"

    ^self subclassResponsibility

    "Created: / 27-10-2010 / 18:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameOf_rt_dot_jar
    "Returns the name of the class library.
     For all 'normal' systems, this is 'rt.jar';
     but under max-osx, this is 'classes.jar' - sigh"

    ^ 'rt.jar'
!

nativeLibDirInJreHome
    "Returns the relative path to the native lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Libraries' - sigh"

    ^ 'lib'
!

priority

    ^50

    "Created: / 22-11-2010 / 13:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^self subclassResponsibility

    "Created: / 27-07-2012 / 10:04:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePath
    "Returns a paths where sources are located"

    sourcePath isNil ifTrue:[
        self searchForSourcePath
    ].
    ^ sourcePath

    "
        JavaRelease openJDK6 sourcePath
        JavaRelease appleJDK6 sourcePath"

    "Created: / 27-10-2010 / 19:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:55:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'accessing - system properties'!

systemProperty_java_class_version
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

systemProperty_java_specification_version
    ^ self systemProperty_java_version
!

systemProperty_java_version
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!JavaRelease methodsFor:'comparing'!

= anotherRelease
    ^ self class == anotherRelease class
        and:[self javaHome = anotherRelease javaHome]

    "
        JavaRelease system = JavaRelease JDK7
        JavaRelease system hash = JavaRelease JDK7 hash
    "

    "Created: / 11-11-2013 / 15:56:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ self class hash bitXor:javaHome hash

    "Created: / 11-11-2013 / 15:55:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'debugging'!

dumpConfigOn: stream
    | dumper |

    dumper :=
        [:name :value :isfile|
            | values |

            '%-30s : ' printf:{ name } on: stream.
            value isString
                ifTrue:[values := { value asString }]
                ifFalse:[values := value].
            values do:[:v|
                stream nextPutAll: v asString.
                isfile ifTrue:[
                    v asFilename exists ifFalse:[
                        stream nextPutAll:' (not found!!!!!!)'
                    ].
                ]
            ] separatedBy:[stream cr; next: 30 + 3 put: Character space].
            stream cr.
        ].

    stream nextPutAll: '== Java release config =='; cr.
    dumper value: 'name' value: self name value: false.
    dumper value: 'JAVA home' value: self javaHome asString value: true.
    dumper value: 'JRE  home' value: self jreHome asString value: true.
    dumper value: 'JDK  home' value: self jdkHome asString value: true.
    dumper value: 'boot class path' value: self bootClassPath value: true.
    dumper value: 'ext dirs' value: self javaExtDirs value: true.

    "
        Java release dumpConfigOn: Transcript.
    "

    "Created: / 10-12-2011 / 12:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2013 / 10:22:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'displaying'!

displayString
    | displayString available |

    available := self isAvailable.

    available ifTrue:[
        displayString := '%1 (%2%3)' bindWith: self name
                                         with: (self jdkHome notNil ifTrue:[ 'JDK' ] ifFalse:[ 'JRE' ])
                                         with: (self isSystem ifTrue:[ ', system' ] ifFalse:[ '' ]).
        self isSystem ifTrue:[
            displayString := displayString asText allUnderlined.
        ].
    ] ifFalse:[
        displayString := self name.
    ].
    available ifTrue: [
        displayString := displayString , ((' - ', self javaHome asFilename pathName) asText colorizeAllWith: Color gray).
    ] ifFalse: [
        displayString := displayString , ((self class classResources string: ' - not found') asText colorizeAllWith: Color gray).
    ].

    ^ displayString

    "Created: / 27-07-2012 / 00:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 13:31:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-12-2014 / 14:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'object conversions'!

as_ST_String: aJavaString
    "Given a java.lang.String instance, returns a coresponding
     Smalltalk String"

    ^self subclassResponsibility

    "Created: / 08-08-1997 / 12:02:55 / cg"
    "Modified: / 04-01-1999 / 23:55:08 / cg"
    "Modified: / 22-03-2011 / 17:21:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-02-2013 / 20:01:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_String:aString
    "Given a Smalltalk string, returns corresponsing instance of
     java.lang.String"

   ^self subclassResponsibility

    "Created: / 07-08-1997 / 21:15:49 / cg"
    "Modified: / 07-02-2013 / 20:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'printing'!

printOn: aStream
    super printOn: aStream.
    aStream nextPut:$(.
    self jdkHome notNil ifTrue:[ 
        aStream nextPutAll: 'JDK'
    ] ifFalse:[ 
        aStream nextPutAll: 'JRE'
    ].
    aStream space.
    aStream nextPutAll: self javaHome asString.
    aStream nextPut:$).

    "Created: / 20-02-2015 / 13:50:43 / jv"
! !

!JavaRelease methodsFor:'private'!

bootBundle
    | src b |

    src := self sourcePath detect:[:e|e endsWith: 'src.zip'] ifNone:[nil].
    b := JavaCodeBundle new name: 'Runtime Library'.
    self bootClassPath do:[:each|
        b add: (JavaCodeLibrary new
                name: (each copyFrom: (each lastIndexOf: Filename separator) + 1);
                classes: each;
                sources: src;
                yourself)
    ].
    ^b

    "Created: / 12-02-2013 / 14:57:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extBundle
    | src b |

    src := self sourcePath detect:[:e|e endsWith: 'src.zip'] ifNone:[nil].
    b := JavaCodeBundle new name: 'Extensions'.
    self javaExtDirs do:[:extnm|
        | ext |

        ext := extnm asFilename.
        ext exists ifTrue:[
            ext directoryContentsAsFilenamesDo:[:each|
                each suffix = 'jar' ifTrue:[
                    b add: (JavaCodeLibrary new
                            name: each baseName;
                            classes: each pathName;
                            sources: src;
                            yourself)
                ]
            ].
        ].
    ].
    ^b

    "Created: / 12-02-2013 / 14:57:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

jdkBundle
    | src b jdk lib|

    (jdk := self jdkHome) isNil ifTrue:[ ^ nil ].
    src := self sourcePath detect:[:e|e asFilename pathName endsWith: 'src.zip'] ifNone:[nil].
    b := JavaCodeBundle new name: 'JDK'.
    lib := jdk asFilename / 'lib'.
    lib exists ifTrue:[
        lib directoryContentsAsFilenamesDo:[:each|
            each suffix = 'jar' ifTrue:[
                b add: (JavaCodeLibrary new
                        name: each baseName;
                        classes: each pathName;
                        sources: src;
                        yourself)
            ]
        ].
    ].
    ^b

    "
        Java release jdkBundle
    "

    "Created: / 11-11-2013 / 15:32:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'queries'!

isAvailable

    ^self javaHomeOrNil notNil

    "
        JavaRelease openJDK6 isAvailable
        JavaRelease oracleJDK6 isAvailable

        JavaRelease openJDK7 isAvailable
        JavaRelease oracleJDK7 isAvailable


        JavaRelease available
    "

    "Created: / 22-11-2010 / 13:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-02-2013 / 03:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows.
    "

    ^self subclassResponsibility

    "Created: / 07-12-2014 / 23:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCustom
    ^false

    "Created: / 27-07-2012 / 00:08:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'searching'!

searchForJavaHome

    | h |

    bundle := nil.
    h := (OperatingSystem getEnvironment:'JAVA_HOME').
    h notNil ifTrue:[
        (h endsWith: '\jre') ifTrue:[
            h := h copyTo: h size - 5
        ].
        h := h asFilename.

        "/Do not trust JAVA_HOME, it might be wrong (on Windows machine due
        "/to a registry mess
        (self validateJavaHome: h) ifTrue:[ javaHome := h. ^ javaHome ].
    ].

    self javaHomes do: [:home|
        | homeAsFilename |

        homeAsFilename := home asFilename.
        homeAsFilename exists ifTrue:
            [(self validateJavaHome: homeAsFilename) ifTrue:
                [^javaHome := home]]].

    ^nil

    "
    Java release searchForJavaHome
    Java release javaHome

    "

    "Created: / 27-10-2010 / 19:03:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2011 / 13:29:14 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 15-03-2011 / 13:47:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-07-2012 / 11:08:04 / jv"
    "Modified: / 20-02-2013 / 02:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForSourcePath

    | java_home src_zip |

    sourcePath := OrderedCollection new.
    bundle := nil.
    java_home := self javaHome.
    java_home notNil ifTrue:[
        src_zip := self javaHome asFilename / 'src.zip'.
        src_zip exists ifTrue:[sourcePath add: src_zip pathName].
    ].

    "
        JavaRelease openJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 27-10-2010 / 21:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2013 / 15:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'testing'!

is32bit
    "Return true, if JRE / JDK represented by this release is
     32bit, false otherwise.

     Note, that for STX:LIBJAVA whether the release is 32bit or 64bit does not
     matter as it does not use any of its shared objects. This method is provided
     here as a courtesy for applications which may use JavaRelease to check for
     installed JREs / JDKs.
    "

    | javaExecutable |

    javaExecutable := self jreHome / 'bin' / (OperatingSystem isMSWINDOWSlike ifTrue:[ 'java.exe' ] ifFalse:[ 'java' ]).
    ^ (OperatingSystem getObjectFileInfoFor: javaExecutable) isFor32BitArchitecture

    "Created: / 17-03-2015 / 20:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

is64bit
    "Return true, if JRE / JDK represented by this release is
     64bit, false otherwise.

     Note, that for STX:LIBJAVA whether the release is 32bit or 64bit does not
     matter as it does not use any of its shared objects. This method is provided
     here as a courtesy for applications which may use JavaRelease to check for
     installed JREs / JDKs.
    "

    | javaExecutable |

    javaExecutable := self jreHome / 'bin' / (OperatingSystem isMSWINDOWSlike ifTrue:[ 'java.exe' ] ifFalse:[ 'java' ]).
    ^ (OperatingSystem getObjectFileInfoFor: javaExecutable) isFor64BitArchitecture

    "Created: / 17-03-2015 / 20:46:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJDK
    " Returns true if this JavaRelease represents a full JDK, i.e. not just a JRE "

    ^ self jdkHome notNil

    "Created: / 26-03-2015 / 15:43:22 / az"
    "Modified (comment): / 31-03-2015 / 09:41:21 / az"
!

isJava6
    ^ false

    "Created: / 04-10-2013 / 11:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava7
    ^ false

    "Created: / 04-10-2013 / 11:11:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava8
    ^ false

    "Created: / 03-04-2014 / 12:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSystem
    ^ self == self class system

    "Created: / 15-04-2014 / 18:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2014 / 00:21:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease methodsFor:'validating'!

validateJavaExecutable: javaExecutable
    "Validates given java executable (java.exe on Windows, java on UNIX).
     Return true, if given executable represents same version as receiver,
     false otherwise."

    ^ self validateJavaHome: (self javaHomeForJavaExecutable: javaExecutable)

    "Created: / 08-04-2014 / 14:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaHome1: home

    home isNil ifTrue:[ ^ false ].

    "Just JRE"
    ( home  asFilename / 'lib' / self nameOf_rt_dot_jar ) exists ifTrue:[^true].

    "Full JDK"
    ( home asFilename / 'jre' / 'lib' / self nameOf_rt_dot_jar ) exists ifTrue:[^true].

    ^ false

    "
        JavaRelease basicNew validateJavaHome: '/usr/lib/jvm/java-6-openjdk'
        JavaRelease basicNew validateJavaHome: '/tmp'
    "

    "Created: / 12-02-2013 / 02:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaHome2: home
    self subclassResponsibility

    "Created: / 12-02-2013 / 02:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaHome: home
    | javaBinary javaVersionStream javaVersionString |

    (self validateJavaHome1: home) ifFalse:[ ^ false ].

    javaBinary := self javaExecutableForJavaHome: home.
    javaBinary isExecutable ifFalse:[ ^ false ].
    javaVersionStream := String new writeStream.
    OperatingSystem executeCommand: '"' , javaBinary pathName , '" -version' outputTo: javaVersionStream.
    javaVersionString := javaVersionStream contents.

    (self validateJavaVersionString: javaVersionString) ifFalse:[ ^ false ].

    ^ true.





    "
        JavaRelease basicNew validateJavaHome: '/usr/lib/jvm/java-6-openjdk'
        JavaRelease basicNew validateJavaHome: '/tmp'
    "

    "Created: / 27-10-2010 / 19:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-04-2014 / 14:50:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ false
! !

!JavaRelease::OpenJDK6 class methodsFor:'documentation'!

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

version_SVN
    ^ '$Id: JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
! !

!JavaRelease::OpenJDK6 class methodsFor:'queries'!

isJDK6
    ^ true
! !

!JavaRelease::OpenJDK6 methodsFor:'accessing'!

javaExtDirsOnUNIX

    ^{
        self jreHome asFilename / self libDirInJreHome / 'ext' .
        '/usr/java/packages/lib/ext' asFilename
    }

    "Created: / 31-08-2011 / 20:01:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 15:46:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaExtDirsOnWindows

    ^{
        self jreHome asFilename / self libDirInJreHome / 'ext' .
    }

    "Created: / 31-08-2011 / 20:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 15:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnUNIX
    | arch |

    arch := OperatingSystem getSystemInfo at:#machine.
    arch = 'x86_64' ifTrue:[arch := 'amd64'].
    arch = 'i686' ifTrue:[arch := 'i386'].

    ^ {
        '/usr/lib/jvm/java-6-openjdk-',arch.        "/ JDK - newer linuxes
        '/usr/lib/jvm/java-6-openjdk'  .            "/ JDK - older linuxes

        '/usr/lib/jvm/java-6-openjdk-',arch, '/jre'.  "/ JRE - newer linuxes
        '/usr/lib/jvm/java-6-openjdk/jre'  .        "/ JRE - older linuxes
    }

    "
    JavaRelease::OpenJDK6 new javaHomesOnUNIX
    "

    "Modified: / 21-02-2013 / 03:57:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows
    "raise an error: must be redefined in concrete subclass(es)"

    ^ #() "/ There is nothing like Open JDK 6 for Windows!!

    "Modified: / 06-02-2013 / 13:37:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_OpenJDK6

    "Modified: / 16-01-2013 / 19:59:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "superclass JavaRelease says that I am responsible to implement this method"

    ^ 'Open JDK 6'

    "Modified: / 27-10-2010 / 19:16:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority

    ^80
    "/^70

    "Created: / 22-11-2010 / 13:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2011 / 06:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#openJDK6

    "Created: / 27-07-2012 / 10:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK6 methodsFor:'accessing - system properties'!

systemProperty_java_class_version
    "raise an error: must be redefined in concrete subclass(es)"

    ^ '50.0'
!

systemProperty_java_version
    ^ '1.6'
! !

!JavaRelease::OpenJDK6 methodsFor:'object conversions'!

as_ST_String: aJavaString
    "Given a java.lang.String instance, returns a coresponfing
     Smalltalk String"

    | str  count  offs  start  stop |

    aJavaString isNil ifTrue: [ ^ nil ].

    "/ count := aJavaString instVarNamed:'count'.

    count := aJavaString instVarAt: 3+1"lockWord".

    "/ str := aJavaString instVarNamed:'value'

    str := aJavaString instVarAt: 1+1"lockWord".
    str size == count
        ifTrue:
            [ "cos I don't see any reason to do this"
            "/ ^ str asOneByteString.
            ^ str ].

    "/ offs := (aJavaString instVarNamed:'offset').

    offs := aJavaString instVarAt: 2+1"lockWord".

    "/ start := offs + 1.

    start := offs + 1.

    "/ stop := start + (aJavaString instVarNamed:'count') - 1.

    stop := start + count - 1.

    "/ ^ ((aJavaString instVarNamed:'value') copyFrom:start to:stop) asString

    ^ (str copyFrom: start to: stop) asOneByteString

    "Created: / 08-08-1997 / 12:02:55 / cg"
    "Modified: / 04-01-1999 / 23:55:08 / cg"
    "Modified: / 22-03-2011 / 17:21:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-02-2013 / 00:56:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_String:aString
    "Given a Smalltalk string, returns corresponsing instance of
     java.lang.String"

    "hard-coding internas of java.lang.String here is bad ..."

    |s|

    s := Java java_lang_String basicNew.
    s instVarAt:1+1"_lockWord_"  put: aString.
    s instVarAt:3+1"_lockWord_"  put: aString size.
    ^ s

    "
     Java as_String:'hello world'
    "

    "Created: / 07-08-1997 / 21:15:49 / cg"
    "Modified: / 08-02-2013 / 00:58:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK6 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    "/ Q: Is OpenJDK available on OS/X?
    ^ OperatingSystem isUNIXlike and:[ OperatingSystem isOSXlike not ]

    "Created: / 07-12-2014 / 23:56:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK6 methodsFor:'searching'!

searchForSourcePath

    | jdkHome src_zip |

    super searchForSourcePath.

    sourcePath := OrderedCollection new.
    jdkHome := self jdkHome.
    jdkHome notNil ifTrue:[
        src_zip := jdkHome asFilename / 'src.zip'.
        src_zip exists ifTrue:[sourcePath add: src_zip pathName].
    ].

    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 jdkHome
        JavaRelease openJDK6 jreHome
    "

    "Created: / 03-09-2012 / 18:38:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 12:22:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 06-02-2013 / 12:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK6 methodsFor:'testing'!

isJava6
    ^ true

    "Created: / 04-10-2013 / 11:11:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK6 methodsFor:'validating'!

validateJavaHome2: home
    "Bit of a hack, but..."
    ^OperatingSystem isUNIXlike
        and: [(home asString includesString: 'oracle') not
        and: [(home asString includesString: 'sun') not]]

    "Created: / 12-02-2013 / 02:52:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2013 / 14:22:19 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: 'java version "1.6.*OpenJDK Runtime Environment*'

    "Modified: / 03-04-2014 / 12:50:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::AppleJDK6 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
"
!

documentation
"
    JDK6 as installed on a mac, running osx
"
! !

!JavaRelease::AppleJDK6 class methodsFor:'queries'!

isJDK6
    ^ true
! !

!JavaRelease::AppleJDK6 methodsFor:'accessing'!

javaExtDirsOnUNIX

    ^{
        self jreHome asFilename / 'Extensions' .
    }
!

javaExtDirsOnWindows
    "/ never exists on windows
    ^ #()
!

javaHomesOnOSX
    ^ {
        '/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents' .
        '/System/Library/Java'
      }

    "
    JavaRelease::OsxJDK6 new javaHomesOnUNIX
    "
!

javaHomesOnWindows
    "/ never exists on windows
    ^ #()
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_AppleJDK6
!

jdkHome

    "Answers the directory where the JDK lives or nil, if no JDK is found"

    | dir vsn|

    jdkHome notNil ifTrue:[^ jdkHome].

    (dir := self javaHome) isNil ifTrue:[ ^ nil ].
    dir := dir asFilename.
    dir baseName = 'Contents' ifTrue:[
        dir := dir directory.
    ].
    vsn := dir baseName.
    (vsn startsWith:'1.6.0') ifTrue:[
        vsn := '1.6.0'
    ] ifFalse:[
        vsn := vsn copyTo:5
    ].
    '/Library/Java/JavaVirtualMachines' asFilename directoryContentsAsFilenamesDo:[:f |
        (f baseName startsWith:vsn) ifTrue:[
            (f / 'Contents') exists ifTrue:[
                (f / 'Contents' / 'Home') exists ifTrue:[
                    (f / 'Contents' / 'Home' / 'src.jar') exists ifTrue:[
                        jdkHome := f pathName.
                        ^ jdkHome
                    ].
                ].
            ].
        ].
    ].
    ^ super jdkHome

    "
     Java release jreHome
     Java release javaHome
     Java release jdkHome
    "

    "Created: / 23-01-2013 / 12:20:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

jniLibDirInJreHome
    "Returns the relative path to the native lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Classes' - sigh"

    ^ 'Libraries'
!

jreHome
    "Answers the directory where the JRE lives"

    OperatingSystem isOSXlike ifTrue:[
        ^ '/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents' asFilename.
    ].
    ^ super jreHome
!

libDirInJreHome
    "Returns the relative path to the lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Classes' - sigh"

    ^ 'Classes'
!

name
    "superclass JavaRelease says that I am responsible to implement this method"

    ^ 'Apple Java 6'

    "Modified: / 15-04-2014 / 18:50:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 13:09:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

nameOf_rt_dot_jar
    "Returns the name of the class library.
     For all 'normal' systems, this is 'rt.jar';
     but under max-osx, this is 'classes.jar' - sigh"

    ^ 'classes.jar'
!

nativeLibDirInJreHome
    "Returns the relative path to the lib directory, relative to the jreHome.
     For all 'normal' systems, this is 'lib';
     but under max-osx, this is 'Classes' - sigh"

    ^ 'Libraries'
!

priority
    OperatingSystem isOSXlike ifTrue:[^ 100].
    ^80
    "/^70

    "Created: / 22-11-2010 / 13:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2011 / 06:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#osxJDK6
! !

!JavaRelease::AppleJDK6 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    ^ OperatingSystem isOSXlike

    "Created: / 07-12-2014 / 23:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::AppleJDK6 methodsFor:'searching'!

javaExecutableForJavaHome: javaHomeArg
    "For given java home (path to JRE root if JRE, or JDK root if part of full JDK) return
     path to java executable (java.exe on Windows, java on UNIX). If no executable is found
     in given root, return nil."

    | javaHomeDirectory javaExecutableName javaExecutable |

    "/ By default, java executable is either in <jdk root>/jre/bin or
    "/ <jre root>/bin. So far only AppleJDK is different...

    javaHomeArg isNil ifTrue:[ ^ nil ].
    javaHomeDirectory := javaHomeArg asFilename asAbsoluteFilename.
    javaHomeDirectory exists ifFalse:[ ^ nil ].
    javaHomeDirectory isDirectory ifFalse:[ ^ nil ].
    javaExecutableName := OperatingSystem isMSWINDOWSlike ifTrue:[ 'java.exe' ] ifFalse:[ 'java' ].

    javaExecutable := javaHomeDirectory / 'Commands' / javaExecutableName.
    javaExecutable exists ifTrue:[ ^ javaExecutable ].

    ^ nil

    "
    JavaRelease basicNew javaExecutableForJavaHome: (OperatingSystem pathOfCommand:'java') asFilename directory directory.
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/lib/jvm/java-7-openjdk-amd64/jre'
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/lib/jvm/java-7-openjdk-amd64'
    JavaRelease basicNew javaExecutableForJavaHome: 'xxxx'
    JavaRelease basicNew javaExecutableForJavaHome: '/usr/bin'
    "

    "Created: / 08-04-2014 / 14:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomeForJavaExecutable: javaExecutable
    "For given java executable (java.exe on Windows, java on UNIX) return
     a Java home (path to JRE root (if JRE) or JDK root (if part of full JDK).
     Upon failure (executable does not seem to be a part of JRE nor JDK), return
     nil."

    | javaExecutableFilename jdk|

    "/ By default, java executable is either in <jdk root>/jre/bin or
    "/ <jre root>/bin. So far only AppleJDK is different...

    javaExecutable isNil ifTrue:[ ^ nil ].
    javaExecutableFilename := javaExecutable asFilename asAbsoluteFilename.
    javaExecutableFilename exists ifFalse:[ ^ nil ].
    javaExecutableFilename isExecutable ifFalse:[ ^ nil ].

    jdk := '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK' asFilename.
    jdk exists ifFalse:[^ nil].

    (jdk construct:'Classes') exists ifFalse:[^ nil].
    (jdk construct:'Classes/classes.jar') exists ifFalse:[^ nil].
    ^ jdk pathName

    "
    JavaRelease basicNew javaHomeForJavaExecutable: (OperatingSystem pathOfCommand:'java')
    JavaRelease basicNew javaHomeForJavaExecutable: '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java'
    JavaRelease basicNew javaHomeForJavaExecutable: 'xxxx'
    JavaRelease basicNew javaHomeForJavaExecutable: '/usr'
    "

    "Created: / 08-04-2014 / 14:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2014 / 00:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForSourcePath
    | jdkHome src_jar path|

    path := OrderedCollection new.

    jdkHome := self jdkHome.
    jdkHome notNil ifTrue:[
        jdkHome := jdkHome asFilename.
        (src_jar := jdkHome / 'Contents' / 'Home' / 'src.jar') exists ifTrue:[
            path add:src_jar.
            path add:src_jar pathName.
        ].
    ].
    super searchForSourcePath.
    sourcePath addAllFirst:path.

    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 searchForSourcePath; sourcePath
        JavaRelease appleJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 jdkHome
        JavaRelease openJDK6 jreHome
        JavaRelease appleJDK6 jdkHome
        JavaRelease appleJDK6 jreHome
    "

    "Created: / 03-09-2012 / 18:38:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 12:22:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 06-02-2013 / 12:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaHome1: home

    home isNil ifTrue:[ ^ false ].

    ( home  asFilename / 'Classes' / self nameOf_rt_dot_jar ) exists ifTrue:[^true].

    ^ false

    "
        JavaRelease basicNew validateJavaHome: '/usr/lib/jvm/java-6-openjdk'
        JavaRelease basicNew validateJavaHome: '/tmp'
    "

    "Created: / 12-02-2013 / 02:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::AppleJDK6 methodsFor:'validating'!

validateJavaHome2: home
    ^ true
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*java version "1.6.*'
! !

!JavaRelease::OpenJDK7 class methodsFor:'documentation'!

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

version_SVN
    ^ '$Id: JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
! !

!JavaRelease::OpenJDK7 class methodsFor:'queries'!

isJDK6
    ^ false
!

isJDK7
    ^ true
! !

!JavaRelease::OpenJDK7 methodsFor:'accessing'!

javaHomesOnUNIX
    | arch |

    arch := OperatingSystem getSystemInfo at:#machine.
    arch = 'x86_64' ifTrue:[arch := 'amd64'].
    arch = 'i686' ifTrue:[arch := 'i386'].

    ^ {
        '/usr/lib/jvm/java-7-openjdk-',arch.        "/ JDK - newer linuxes
        '/usr/lib/jvm/java-7-openjdk'  .            "/ JDK - older linuxes

        '/usr/lib/jvm/java-7-openjdk-',arch, '/jre'."/ JRE - newer linuxes
        '/usr/lib/jvm/java-7-openjdk/jre'  .        "/ JRE - older linuxes
    }

    "
    JavaRelease::OpenJDK7 new javaHomesOnUNIX
    "

    "Created: / 11-02-2012 / 17:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2013 / 09:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows
    "raise an error: must be redefined in concrete subclass(es)"

    ^ #() "/ not yet implemented

    "Modified: / 06-02-2013 / 13:37:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_OpenJDK7

    "Created: / 07-02-2013 / 20:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ 'Open JDK 7'

    "Created: / 27-07-2012 / 00:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2013 / 10:23:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority
    ^ super priority + 10

    "Created: / 11-02-2012 / 17:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2013 / 14:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#openJDK7

    "Created: / 27-07-2012 / 10:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK7 methodsFor:'accessing - system properties'!

systemProperty_java_class_version
    "raise an error: must be redefined in concrete subclass(es)"

    ^ '51.0'
!

systemProperty_java_version
    ^ '1.7'
! !

!JavaRelease::OpenJDK7 methodsFor:'object conversions'!

as_ST_String: aJavaString
    "Given a java.lang.String instance, returns a coresponfing
     Smalltalk String"

    Java java_lang_String instSize == 5 ifTrue:[
        "Old implementation"
        ^super as_ST_String:aJavaString
    ].
    ^aJavaString instVarAt: 1+1"_lockWord_".

    "Created: / 08-08-1997 / 12:02:55 / cg"
    "Modified: / 04-01-1999 / 23:55:08 / cg"
    "Modified: / 22-03-2011 / 17:21:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-06-2013 / 09:04:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

as_String:aString
    "Given a Smalltalk string, returns corresponsing instance of
     java.lang.String"

    |s|

    Java java_lang_String instSize == 5 ifTrue:[
        "Old implementation"
        ^super as_String:aString
    ].
    s := Java java_lang_String basicNew.
    s instVarAt:1+1"_lockWord_"  put: aString.
    ^s

    "
     Java as_String:'hello world'
    "

    "Created: / 07-08-1997 / 21:15:49 / cg"
    "Modified: / 13-06-2013 / 09:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK7 methodsFor:'searching'!

searchForSourcePath

    | jdkHome jdkHomeAlt src_zip |

    super searchForSourcePath.

    "/ Kludge for Debian packages. On Debian boxes
    "/ package openjdk-7-source installs src.zip into
    "/ `/usr/lib/jvm/java-7-openjdk-i386` instead of
    "/ into
    "/ `/usr/lib/jvm/java-7-openjdk-common`

    jdkHome := self jdkHome asString.
    (jdkHome endsWith: 'amd64') ifTrue:[
        jdkHomeAlt := ((jdkHome copyTo: jdkHome size - 5) , 'i386').
        src_zip := jdkHomeAlt asFilename / 'src.zip'.
        src_zip exists ifTrue:[
            sourcePath add: src_zip pathName.
        ].
    ].


    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 searchForSourcePath; sourcePath
        JavaRelease openJDK6 jdkHome
        JavaRelease openJDK6 jreHome
    "

    "Created: / 12-02-2014 / 10:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK7 methodsFor:'testing'!

isJava6
    ^ false

    "Created: / 04-10-2013 / 11:11:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava7
    ^ true

    "Created: / 04-10-2013 / 11:11:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK7 methodsFor:'validating'!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ (aVersionString matches: '*java version "1.7.*OpenJDK Runtime Environment*')
        and:[ (aVersionString includesString: 'Zulu') not ]

    "Modified: / 03-04-2014 / 12:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 09:29:59 / jv"
! !

!JavaRelease::OpenJDK8 class methodsFor:'queries'!

isJDK7
    ^ false

    "Created: / 03-04-2014 / 12:35:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJDK8
    ^ true

    "Created: / 03-04-2014 / 12:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK8 methodsFor:'accessing'!

javaHomesOnUNIX
    | arch |

    arch := OperatingSystem getSystemInfo at:#machine.
    arch = 'x86_64' ifTrue:[arch := 'amd64'].
    arch = 'i686' ifTrue:[arch := 'i386'].

    ^ {
        '/usr/lib/jvm/java-8-openjdk-',arch.        "/ JDK - newer linuxes
        '/usr/lib/jvm/java-8-openjdk'  .            "/ JDK - older linuxes

        '/usr/lib/jvm/java-8-openjdk-',arch, '/jre'."/ JRE - newer linuxes
        '/usr/lib/jvm/java-8-openjdk/jre'  .        "/ JRE - older linuxes
    }

    "
    JavaRelease::OpenJDK7 new javaHomesOnUNIX
    "

    "Created: / 03-04-2014 / 12:30:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_OpenJDK8

    "Created: / 03-04-2014 / 12:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ 'Open JDK 8'

    "Created: / 03-04-2014 / 12:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK8 methodsFor:'accessing - system properties'!

systemProperty_java_class_version
    "raise an error: must be redefined in concrete subclass(es)"

    ^ '52.0'
!

systemProperty_java_version
    ^ '1.8'
! !

!JavaRelease::OpenJDK8 methodsFor:'testing'!

isJava7
    ^ false

    "Created: / 03-04-2014 / 12:14:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava8
    ^ true

    "Created: / 03-04-2014 / 12:14:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OpenJDK8 methodsFor:'validating'!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ (aVersionString matches: '*openjdk version "1.8.*OpenJDK Runtime Environment*')
        and:[ (aVersionString includesString: 'Zulu') not ]

    "Created: / 03-04-2014 / 12:32:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 10:15:22 / jv"
    "Modified: / 07-04-2016 / 18:29:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK6 class methodsFor:'documentation'!

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

version_SVN
    ^ '$Id: JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
! !

!JavaRelease::OracleJDK6 methodsFor:'accessing'!

javaHomesOnUNIX

    ^ #( '/usr/lib/jvm/java-6-sun' )

    "Created: / 22-11-2010 / 13:31:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows
    |home paths |

    home := self javaHomeOnWindowsFromRegistryForRelease: '1.6'.
    home notNil ifTrue:[ ^ Array with: home ].

    paths := OrderedCollection new.
    #(
        'C:\Program Files\Java'
        'C:\Program Files (x86)\Java'
    ) do:[:rootpath|
        | root |

        root := rootpath asFilename.
        root exists ifTrue:[
            "Search for JDK first"
            root directoryContents do:[:dir|
                (dir startsWith:self javaHomeOnWindowsJDKDirectoryPrefix) ifTrue:[
                    | path |
                    (path := root / dir) isDirectory ifTrue:[
                        paths add: path
                    ].
                ].
            ].
            "Search for JDK first"
            root directoryContents do:[:dir|
                (dir startsWith:self javaHomeOnWindowsJREDirectoryPrefix) ifTrue:[
                    | path |
                    (path := root / dir) isDirectory ifTrue:[
                        paths add: path
                    ].
                ].
            ].

        ]
    ].

    ^ paths

    "
     self basicNew javaHomesOnWindows
    "

    "Modified (format): / 19-08-2011 / 00:46:40 / cg"
    "Modified: / 19-07-2012 / 11:04:44 / jv"
    "Modified: / 21-02-2013 / 03:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_SunJDK6

    "Created: / 06-02-2013 / 08:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^ 'Oracle Java 6'

    "Created: / 22-11-2010 / 13:31:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2014 / 18:49:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority

    "/There is no OpenJDK 6 for Windows yet...
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^100
    ].
    ^75

    "Created: / 22-11-2010 / 13:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2012 / 10:57:55 / jv"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#oracleJDK6

    "Created: / 27-07-2012 / 10:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2013 / 03:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK6 methodsFor:'private'!

javaHomeOnWindowsJDKDirectoryPrefix
    ^'jdk1.6'

    "Created: / 19-07-2012 / 11:04:34 / jv"
!

javaHomeOnWindowsJREDirectoryPrefix
    ^'jdk6'

    "Created: / 21-02-2013 / 03:19:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK6 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    "/ Q: Is OpenJDK available on OS/X?
    ^ true

    "Created: / 07-12-2014 / 23:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK6 methodsFor:'searching'!

searchForJavaHome
    | h |

    "Try registry first..."
     "Try registry first..."
    self class == JavaRelease::OracleJDK6 ifTrue:[ 
        h := self javaHomeOnWindowsFromRegistryForRelease: '1.6'.
        (h notNil and:[self validateJavaHome: h]) ifTrue:[ javaHome := h. ^ javaHome ].
    ].
    ^super searchForJavaHome



    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 20-02-2013 / 02:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-02-2015 / 14:08:53 / jv"
! !

!JavaRelease::OracleJDK6 methodsFor:'validating'!

validateJavaHome2: home
    | homeFromRegistry f |

    homeFromRegistry := self javaHomeOnWindowsFromRegistryForRelease: '1.6'.
    homeFromRegistry = home ifTrue:[ ^ true ].

    "JDK..."
    (f := home asFilename / 'LICENSE') exists ifTrue:[
        f readingFileDo:[:s|
            ((s nextLine = 'Please refer to http://java.com/license')
                and:[(home asFilename / 'release') exists not
                    and:[(home asFilename / 'THIRDPARTYLICENSEREADME-JAVAFX.txt') exists not]]) ifTrue:[ ^ true ]
        ].
    ].
    "JRE..."
    (f := home asFilename / 'COPYRIGHT') exists ifTrue:[
        f readingFileDo:[:s|
            (s nextLine includesString: 'Oracle') ifTrue:[
                ^(home asFilename / 'LICENSE.txt') exists
            ]
        ].
    ].
    ^false



    "
        JavaRelease::OracleJDK6 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13' asFilename
        JavaRelease::OracleJDK6 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13\jre' asFilename
        JavaRelease::OracleJDK6 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34' asFilename
        JavaRelease::OracleJDK6 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34\jre' asFilename

    "

    "Created: / 12-02-2013 / 02:52:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 14:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*java version "1.6.*Java(TM) SE Runtime Environment*'

    "Modified: / 03-04-2014 / 16:49:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK7 class methodsFor:'documentation'!

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

!JavaRelease::OracleJDK7 methodsFor:'accessing'!

javaHomesOnUNIX

    ^ #( '/usr/lib/jvm/java-7-sun' )

    "Created: / 22-11-2010 / 13:31:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2013 / 02:49:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows
    |home paths |

    home := self javaHomeOnWindowsFromRegistryForRelease: '1.7'.
    home notNil ifTrue:[ ^ Array with: home ].

    paths := OrderedCollection new.
    #(
        'C:\Program Files\Java'
        'C:\Program Files (x86)\Java'
    ) do:[:rootpath|
        | root |

        root := rootpath asFilename.
        root exists ifTrue:[
            "Search for JDK first"
            root directoryContents do:[:dir|
                (dir startsWith:self javaHomeOnWindowsJDKDirectoryPrefix) ifTrue:[
                    | path |
                    (path := root / dir) isDirectory ifTrue:[
                        paths add: path
                    ].
                ].
            ].
            "Search for JDK first"
            root directoryContents do:[:dir|
                (dir startsWith:self javaHomeOnWindowsJREDirectoryPrefix) ifTrue:[
                    | path |
                    (path := root / dir) isDirectory ifTrue:[
                        paths add: path
                    ].
                ].
            ].

        ]
    ].

    ^ paths

    "
     self basicNew javaHomesOnWindows
    "

    "Modified (format): / 19-08-2011 / 00:46:40 / cg"
    "Modified: / 19-07-2012 / 11:04:44 / jv"
    "Modified: / 21-02-2013 / 03:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_OracleJDK7

    "Created: / 06-02-2013 / 08:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2014 / 12:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^ 'Oracle Java 7'

    "Created: / 22-11-2010 / 13:31:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2014 / 18:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority
    ^65

    "Created: / 22-11-2010 / 13:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2012 / 10:57:55 / jv"
    "Modified: / 11-03-2015 / 12:31:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#oracleJDK7

    "Created: / 27-07-2012 / 10:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2013 / 03:03:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK7 methodsFor:'private'!

javaHomeOnWindowsJDKDirectoryPrefix
    ^'jdk1.7'

    "Created: / 19-07-2012 / 11:04:34 / jv"
    "Modified: / 21-02-2013 / 03:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomeOnWindowsJREDirectoryPrefix
    ^'jre7'

    "Created: / 21-02-2013 / 03:19:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2014 / 12:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK7 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    ^ true

    "Created: / 07-12-2014 / 23:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK7 methodsFor:'searching'!

searchForJavaHome
    | h |

    "Try registry first..."
    self class == JavaRelease::OracleJDK7 ifTrue:[ 
        h := self javaHomeOnWindowsFromRegistryForRelease: '1.7'.
        (h notNil and:[self validateJavaHome: h]) ifTrue:[ javaHome := h. ^ javaHome ].
    ].
    ^super searchForJavaHome



    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 20-02-2013 / 02:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-02-2015 / 14:08:11 / jv"
! !

!JavaRelease::OracleJDK7 methodsFor:'validating'!

validateJavaHome2: home
    | homeFromRegistry f homeDir |

    homeFromRegistry := self javaHomeOnWindowsFromRegistryForRelease: '1.7'.
    homeFromRegistry = home ifTrue:[ ^ true ].
    homeDir :=  home asFilename.

    "JDK..."
    (f := homeDir / 'release') exists ifTrue:[
        f readingFileDo:[:s|
            s nextLine = 'JAVA_VERSION="1.7.0"' ifTrue:[ ^ true ]
        ].
    ].
    "JRE..."
    (f := homeDir / 'COPYRIGHT') exists ifTrue:[
        f readingFileDo:[:s|
            (s nextLine includesString: 'Oracle') ifTrue:[
                ^(homeDir / 'THIRDPARTYLICENSEREADME-JAVAFX.txt') exists
            ]
        ].
    ].
    ^false



    "
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13\jre' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34\jre' asFilename

    "

    "Created: / 12-02-2013 / 02:52:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2013 / 15:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-01-2014 / 21:32:54 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*java version "1.7.*Java(TM) SE Runtime Environment*'

    "Modified: / 03-04-2014 / 14:09:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK8 class methodsFor:'queries'!

isJDK7
    ^ false

    "Created: / 03-04-2014 / 12:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJDK8
    ^ true

    "Created: / 03-04-2014 / 12:35:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK8 methodsFor:'accessing'!

javaHomesOnUNIX

    ^ #( '/usr/lib/jvm/java-8-sun' )

    "Created: / 03-04-2014 / 12:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNativeMethodsImplementation
    "Returns an object that imolements native methods."

    ^ JavaNativeMethodImpl_OracleJDK8

    "Created: / 03-04-2014 / 12:19:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ 'Oracle Java 8'

    "Created: / 03-04-2014 / 12:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2014 / 18:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK8 methodsFor:'private'!

javaHomeOnWindowsJDKDirectoryPrefix
    ^'jdk1.8'

    "Created: / 03-04-2014 / 12:31:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomeOnWindowsJREDirectoryPrefix
    ^'jre8'

    "Created: / 03-04-2014 / 12:31:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK8 methodsFor:'searching'!

searchForJavaHome
    | h |

    "Try registry first..."
    self class == JavaRelease::OracleJDK8 ifTrue:[ 
        h := self javaHomeOnWindowsFromRegistryForRelease: '1.8'.
        (h notNil and:[self validateJavaHome: h]) ifTrue:[ javaHome := h. ^ javaHome ].
    ].
    ^super searchForJavaHome



    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 20-02-2015 / 13:53:59 / jv"
! !

!JavaRelease::OracleJDK8 methodsFor:'testing'!

isJava7
    ^ false

    "Created: / 03-04-2014 / 12:16:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJava8
    ^ true

    "Created: / 03-04-2014 / 12:15:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::OracleJDK8 methodsFor:'validating'!

validateJavaHome2: home
    | homeFromRegistry f homeDir |

    homeFromRegistry := self javaHomeOnWindowsFromRegistryForRelease: '1.8'.
    homeFromRegistry = home ifTrue:[ ^ true ].
    homeDir :=  home asFilename.

    "JDK..."
    (f := homeDir / 'release') exists ifTrue:[
        f readingFileDo:[:s|
            s nextLine = 'JAVA_VERSION="1.8.0"' ifTrue:[ ^ true ]
        ].
    ].
    "JRE..."
    (f := homeDir / 'COPYRIGHT') exists ifTrue:[
        f readingFileDo:[:s|
            (s nextLine includesString: 'Oracle') ifTrue:[
                ^(homeDir / 'THIRDPARTYLICENSEREADME-JAVAFX.txt') exists
            ]
        ].
    ].
    ^false



    "
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.7.0_13\jre' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34' asFilename
        JavaRelease::OracleJDK7 new validateJavaHome: 'c:\Program Files\Java\jdk1.6.0_34\jre' asFilename

    "

    "Created: / 03-04-2014 / 12:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*java version "1.8.*Java(TM) SE Runtime Environment*'

    "Created: / 03-04-2014 / 12:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2014 / 14:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::SunJDK122 class methodsFor:'documentation'!

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

version_SVN
    ^ '$Id: JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
! !

!JavaRelease::SunJDK122 methodsFor:'accessing'!

javaHomesOnUNIX
    "superclass JavaRelease says that I am responsible to implement this method"

    ^#(
            '/home/jv/Projects/JavaX/jdk1.2.2' "/On Jan Vrany's machine :-)
        )

    "Created: / 22-11-2010 / 13:26:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows

	^ #()

!

name
    "superclass JavaRelease says that I am responsible to implement this method"

    ^ 'Sun Java 1.2.2'

    "Modified: / 15-04-2014 / 18:50:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority

    ^10

    "Created: / 22-11-2010 / 13:34:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    "Returns instance-creation selector to get the receiver.
     See JavaRelease class, protocol instance creation"

    ^#sunJDK122

    "Created: / 27-07-2012 / 10:06:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::SunJDK122 methodsFor:'displaying'!

displayString

    ^self isAvailable ifTrue:[
        self name
    ] ifFalse:[
        (self name , ' ' , '(not available)') asText colorizeAllWith: Color gray
    ]

    "Created: / 27-07-2012 / 00:13:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::SunJDK122 methodsFor:'queries'!

isAvailable
    "We don't really support it"

    ^false

    "Created: / 27-07-2012 / 00:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows.
    "

    ^ false "/ Not supported any longer

    "Created: / 07-12-2014 / 23:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRelease::SunJDK122 methodsFor:'validating'!

validateJavaHome2:home
    ^ false

    "Created: / 02-04-2014 / 16:16:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: 'java version "1.2.*'
! !

!JavaRelease::Zulu7 methodsFor:'accessing'!

javaHomeOnWindowsFromRegistryForRelease: vsn
    "Return path to java home (either JDK or JRE) based on values in registry.
     If not on windows or registry key not found, return nil"

    |entry home |

    OperatingSystem isMSWINDOWSlike ifFalse:[ ^ nil ].
    entry := (OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\Azul Systems\Zulu\', vsn).
    entry notNil ifTrue:[
        home := entry valueNamed:'InstallationPath'.
        (home notNil and:[home asFilename exists]) ifTrue:[ ^ home ].
    ].
    ^nil

    "Created: / 16-02-2013 / 02:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2013 / 03:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 09:41:57 / jv"
!

javaHomesOnUNIX
    ^ {
        '/usr/lib/jvm/zulu-7-amd64'
    }

    "
    JavaRelease::Zulu7 new javaHomesOnUNIX
    "

    "Created: / 26-02-2015 / 16:08:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaHomesOnWindows
    ^ #(
        'C:\Program Files\Zulu\zulu-7'                 
    )

    "Created: / 11-03-2015 / 09:24:07 / jv"
!

name
    ^ 'Zulu 7'

    "Created: / 11-03-2015 / 09:31:17 / jv"
! !

!JavaRelease::Zulu7 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    ^ true "/ Zulu iz available for all supported operating systems

    "Created: / 11-03-2015 / 09:31:55 / jv"
! !

!JavaRelease::Zulu7 methodsFor:'searching'!

searchForJavaHome
    | h |

    "Try registry first..."
    self class == JavaRelease::Zulu7 ifTrue:[ 
        h := self javaHomeOnWindowsFromRegistryForRelease: 'zulu-7'.
        (h notNil and:[self validateJavaHome: h]) ifTrue:[ javaHome := h. ^ javaHome ].
    ].
    ^super searchForJavaHome



    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 20-02-2013 / 02:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 09:40:49 / jv"
! !

!JavaRelease::Zulu7 methodsFor:'validating'!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*openjdk version "1.7.*OpenJDK Runtime Environment (Zulu*'

    "Created: / 26-02-2015 / 16:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 09:27:16 / jv"
! !

!JavaRelease::Zulu8 methodsFor:'accessing'!

javaHomeOnWindowsFromRegistryForRelease: vsn
    "Return path to java home (either JDK or JRE) based on values in registry.
     If not on windows or registry key not found, return nil"

    |entry home |

    OperatingSystem isMSWINDOWSlike ifFalse:[ ^ nil ].
    entry := (OperatingSystem registryEntry key:'HKEY_LOCAL_MACHINE\SOFTWARE\Azul Systems\Zulu\', vsn).
    entry notNil ifTrue:[
        home := entry valueNamed:'InstallationPath'.
        (home notNil and:[home asFilename exists]) ifTrue:[ ^ home ].
    ].
    ^nil

    "Created: / 16-02-2013 / 02:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2013 / 03:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 09:41:57 / jv"
!

javaHomesOnUNIX
    ^ {
        '/usr/lib/jvm/zulu-8-amd64'
    }

    "
    JavaRelease::Zulu7 new javaHomesOnUNIX
    "

    "Created: / 26-02-2015 / 16:08:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 10:16:25 / jv"
!

javaHomesOnWindows
    ^ #(
        'C:\Program Files\Zulu\zulu-8'                 
    )

    "Created: / 11-03-2015 / 09:24:07 / jv"
! !

!JavaRelease::Zulu8 methodsFor:'queries'!

isAvailableOnCurrentOperatingSystem
    "Return if at all available for current operating system.
     For example, there's no AppleJDK for Linux or OpenJDK for Windows."

    ^ true "/ Zulu iz available for all supported operating systems

    "Created: / 11-03-2015 / 09:31:55 / jv"
! !

!JavaRelease::Zulu8 methodsFor:'searching'!

searchForJavaHome
    | h |

    "Try registry first..."
    self class == JavaRelease::Zulu8 ifTrue:[ 
        h := self javaHomeOnWindowsFromRegistryForRelease: 'zulu-8'.
        (h notNil and:[self validateJavaHome: h]) ifTrue:[ javaHome := h. ^ javaHome ].
    ].
    ^super searchForJavaHome



    "
        JavaRelease openJDK7 searchForSourcePath; sourcePath
        JavaRelease sunJDK6 searchForSourcePath; sourcePath
    "

    "Created: / 20-02-2013 / 02:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 10:16:18 / jv"
! !

!JavaRelease::Zulu8 methodsFor:'validating'!

validateJavaVersionString:aVersionString
    "Return true if aVersionString (which is what 'java -version' returns)
     matches what I expect."

    ^ aVersionString matches: '*openjdk version "1.8.*OpenJDK Runtime Environment (Zulu*'

    "Created: / 26-02-2015 / 16:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 10:16:06 / jv"
! !

!JavaRelease class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: JavaRelease.st,v 1.19 2015-03-31 07:43:05 az Exp $'
! !


JavaRelease initialize!
