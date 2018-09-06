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

Object subclass:#JavaUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Utilities'
!

Object subclass:#Tomcat7x
	instanceVariableNames:'bootstrap'
	classVariableNames:'OldspaceIncreased'
	poolDictionaries:''
	privateIn:JavaUtilities
!

!JavaUtilities class methodsFor:'documentation'!

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

!JavaUtilities class methodsFor:'instance creation'!

tomcat

    ^self tomcat6x

    "Created: / 08-12-2011 / 00:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tomcat6x

    (Smalltalk at: #ApacheTomcat6) isNil ifTrue:[
        (Smalltalk loadPackage:'stx:libjava/examples/tomcat6') ifFalse:[
            self error:'Failed to load Tomcat 6.x package'.
        ].
    ].
    ^ (Smalltalk at: #ApacheTomcat6) new

    "Created: / 07-05-2012 / 22:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2013 / 10:05:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tomcat7x

    ^Tomcat7x new

    "Created: / 07-05-2012 / 22:11:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUtilities::Tomcat7x methodsFor:'accessing - paths'!

catalinaHome
    "Bit hacky, but..."
    
    OperatingSystem getLoginName = 'jv' ifTrue: [
        ^ '/home/jv/Projects/libjava/sources/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-7.0.27-src/output/build'
    ].
    OperatingSystem getLoginName = 'm' ifTrue: [
        ^ '/home/m/Projects/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-7.0.27-src/output/build'
    ].
     "Add your default here"
    ^ ((Smalltalk at: #'stx_libjava') packageDirectory / 'examples' / 'tomcat' 
        / 'apache-tomcat-7.0.27-src' / 'output' 
        / 'build') pathName

    "Created: / 08-12-2011 / 22:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2011 / 14:32:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2012 / 22:04:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath1

    ^ self catalinaHome , '/bin/bootstrap.jar'

    "Created: / 08-12-2011 / 22:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath2

    ^ self catalinaHome , '/lib/*.jar'

    "Created: / 08-12-2011 / 22:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePath
    OperatingSystem getLoginName = 'm' ifTrue: [
        ^ '/home/m/Projects/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-7.0.27-src/java'
    ].
    ^ '/home/jv/Projects/libjava/sources/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-7.0.27-src/java'

    "Created: / 08-12-2011 / 23:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2011 / 14:33:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2012 / 22:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUtilities::Tomcat7x methodsFor:'initialization'!

initializeVM

    Java flushAllJavaResources.
    Java initialize.
    JavaVM initializeVM.

    "Created: / 08-12-2011 / 00:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setup

    | catalinaHome java_lang_System |

    catalinaHome := self catalinaHome.
    catalinaHome asFilename exists ifFalse:[
        self error:'Catalina home does not exist'.
        ^self.
    ].

    Java addToClassPath: self classPath1.
    Java addToClassPath: self classPath2.
    Java addToSourcePath: self sourcePath.
    JavaVM booted ifFalse:[self initializeVM].
    java_lang_System := Java classForName:'java.lang.System'.

    {
        'java.util.logging.config.file'.    catalinaHome , '/conf/logging.properties' .
        'java.util.logging.manager'.        'org.apache.juli.ClassLoaderLogManager' .
        'java.endorsed.dirs'.               catalinaHome , '/endorsed' .
        'catalina.base'.                    catalinaHome .
        'catalina.home'.                    catalinaHome .
        'java.io.tmpdir'.                   catalinaHome , '/temp' .
    } pairWiseDo:[:key :value|
        java_lang_System perform: #'setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;'
            with: (Java as_String: key)
            with: (Java as_String: value)
    ].

    "Created: / 18-04-2012 / 08:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUtilities::Tomcat7x methodsFor:'start/stop'!

start

    self setup.

    (Java classForName: 'org.apache.catalina.startup.Bootstrap')
        perform: #'main([Ljava/lang/String;)V'
        with: ((Java classForName:'java.lang.String') javaArrayClass with:(Java as_String:'start'))

    "Created: / 07-12-2011 / 23:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop

    (Java classForName: 'org.apache.catalina.startup.Bootstrap')
        perform: #'main([Ljava/lang/String;)V'
        with: (String javaArrayClass with:(Java as_String:'stop'))

    "Created: / 08-12-2011 / 00:32:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUtilities class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaUtilities.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

