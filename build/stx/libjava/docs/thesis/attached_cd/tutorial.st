"To start Java, select following text, and press CTRL + d (or right click and select do it)"
"You can also inspect the return value by pressing CTRL + i, or print result using CTRL + p"
Java flushAllJavaResources.
Java initialize.
JavaVM initializeVM.

"To stop Java, following command has to be executed"
Java flushAllJavaResources.

"Java classpath can be inspected via:"
Java classPath.
"and directories and Jar files can be added via:"
Java addToClassPath: '/home/foo/myJavaDir/'.

"To load a class, execute:"
Java classForName: 'java.lang.Object'.
"To get existing, already loaded class, do:"
Java classNamed:'java.lang.System'.


"new instance of the class can be created using new method"
(Java classForName: 'java.lang.Object') new.
"to perform a method, perform method has to be used (arguments are passed in via with:)"
(Java classForName: 'java.lang.Object') new perform: #'toString()Ljava/lang/String;'.
(Java classForName: 'java.lang.Object') new perform: #'equals(Ljava/lang/Object;)Z' with: 'foo string'.

