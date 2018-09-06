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
"{ Package: 'stx:libjava/startup' }"

StandaloneStartup subclass:#JavaStartup
	instanceVariableNames:''
	classVariableNames:'ClassPath'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaStartup class methodsFor:'documentation'!

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

!JavaStartup class methodsFor:'constants & defaults'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."
    
    ^ #('stx' 'java_x')

    "Created: / 07-02-2011 / 10:55:08 / Marcel Hlopko <hlopik@gmail.com>"
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used."
    
    ^ 'ST_X_JAVA_X'.

    "Created: / 07-02-2011 / 10:52:50 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaStartup class methodsFor:'startup'!

main: argv 
    "Currently only -c option for classpath setting working"
    
    | class  arguments  classAndArguments  classpath  classpathFromEnv |

    classpath := OrderedCollection new.
    classpathFromEnv := OperatingSystem getEnvironment: #CLASSPATH.
    classpathFromEnv isNil ifFalse: [
        (classpathFromEnv asArrayOfSubstringsSeparatedBy: $:) do: [
            :each | 
            classpath add: each
        ]
    ].
    classAndArguments := OrderedCollection new.
    (GetOpt new)
        at: $c
            put: [
                :opt :arg | 
                (arg asArrayOfSubstringsSeparatedBy: $:) do: [:each | classpath add: each ]
            ];
        at: $? put: [:arg | self error: 'not yet implemented' ];
        default: [:arg | classAndArguments add: arg ];
        parse: argv.
    class := classAndArguments at: 1.
    arguments := classAndArguments
                removeFirst;
                yourself.
    Java flushAllJavaResources.
    self breakPoint: #mh.
    Java initialize.
    JavaVM initializeVM.
    classpath do: [:each | Java addToClassPath: each ].
    (JavaVM classForName: class) main: arguments asArray.

    "Created: / 07-02-2011 / 10:55:41 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-02-2011 / 00:55:42 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaStartup class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/startup/JavaStartup.st,v 1.6 2015-03-20 13:29:45 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

