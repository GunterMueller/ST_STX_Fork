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

SharedPool subclass:#JavaConstants
	instanceVariableNames:''
	classVariableNames:'ACC_PUBLIC ACC_PRIVATE ACC_PROTECTED ACC_STATIC ACC_FINAL
		ACC_SYNCHRONIZED ACC_BRIDGE ACC_VARGARS ACC_NATIVE ACC_ABSTRACT
		ACC_STRICT ACC_SYNTHETIC ACC_SUPER ACC_INTERFACE ACC_ANNOTATION
		ACC_ENUM ACC_VOLATILE ACC_TRANSIENT ACX_OBSOLETE ACX_INITIALIZED
		ACX_INITIALIZING ACX_BREAKPNT ACX_HASHANDLER ACX_HASFINALLY
		ACX_HASFINALIZE AXC_RESOLVED ACX_HASMULTIVERS ACX_CLONEABLE ACX_HASERRORS
		ACX_R_VOID ACX_R_LONG ACX_R_DOUBLE'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaConstants class methodsFor:'documentation'!

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

!JavaConstants class methodsFor:'class initialization'!

initialize
    "Initialization code is in C to make sure stc.h and smalltalk
     visible constants are in sync"


%{
        @global(JavaConstants:ACC_PUBLIC)      = __MKSMALLINT(__ACC_PUBLIC);
        @global(JavaConstants:ACC_PRIVATE)     = __MKSMALLINT(__ACC_PRIVATE);
        @global(JavaConstants:ACC_PROTECTED)   = __MKSMALLINT(__ACC_PROTECTED);

        @global(JavaConstants:ACC_STATIC)      = __MKSMALLINT(__ACC_STATIC);
        @global(JavaConstants:ACC_FINAL)       = __MKSMALLINT(__ACC_FINAL);
        @global(JavaConstants:ACC_SYNCHRONIZED)= __MKSMALLINT(__ACC_SYNCHRONIZED);

        @global(JavaConstants:ACC_SUPER)       = __MKSMALLINT(__ACC_SUPER);
        @global(JavaConstants:ACC_VOLATILE)    = __MKSMALLINT(__ACC_VOLATILE);
        @global(JavaConstants:ACC_TRANSIENT)   = __MKSMALLINT(__ACC_TRANSIENT);
        @global(JavaConstants:ACC_NATIVE)      = __MKSMALLINT(__ACC_NATIVE);

        @global(JavaConstants:ACC_INTERFACE)   = __MKSMALLINT(__ACC_INTERFACE);
        @global(JavaConstants:ACC_ABSTRACT)    = __MKSMALLINT(__ACC_ABSTRACT);
        @global(JavaConstants:ACC_STRICT)      = __MKSMALLINT(__ACC_STRICT);
        @global(JavaConstants:ACC_SYNTHETIC)   = __MKSMALLINT(__ACC_SYNTHETIC);

        @global(JavaConstants:ACC_ENUM)        = __MKSMALLINT(__ACC_ENUM);
        @global(JavaConstants:ACC_ANNOTATION)  = __MKSMALLINT(__ACC_ANNOTATION);
        
        @global(JavaConstants:ACX_INITIALIZED) = __MKSMALLINT(__ACX_INITIALIZED);
        @global(JavaConstants:ACX_INITIALIZING)= __MKSMALLINT(__ACX_INITIALIZING);
        @global(JavaConstants:ACX_BREAKPNT)    = __MKSMALLINT(__ACX_BREAKPNT);
        @global(JavaConstants:ACX_HASHANDLER)  = __MKSMALLINT(__ACX_HASHANDLER);
        @global(JavaConstants:ACX_HASFINALLY)  = __MKSMALLINT(__ACX_HASFINALLY);
        @global(JavaConstants:ACX_RESOLVED)    = __MKSMALLINT(__ACX_RESOLVED);
        @global(JavaConstants:ACX_HASFINALIZE) = __MKSMALLINT(__ACX_HASFINALIZE);
        @global(JavaConstants:ACX_HASMULTIVERS)= __MKSMALLINT(__ACX_HASMULTIVERS);
        @global(JavaConstants:ACX_CLONEABLE)   = __MKSMALLINT(__ACX_CLONEABLE);
        @global(JavaConstants:ACX_OBSOLETE)    = __MKSMALLINT(__ACX_OBSOLETE);
        @global(JavaConstants:ACX_HASERRORS)   = __MKSMALLINT(__ACX_HASERRORS);


        @global(JavaConstants:ACX_R_VOID)= __MKSMALLINT(__ACX_R_VOID);
        @global(JavaConstants:ACX_R_LONG)= __MKSMALLINT(__ACX_R_LONG);
        @global(JavaConstants:ACX_R_DOUBLE)= __MKSMALLINT(__ACX_R_DOUBLE);
%}

    "Created: / 25-10-2011 / 09:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2011 / 16:56:17 / m"
    "Modified: / 31-01-2014 / 03:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstants class methodsFor:'constants'!

ACC_ABSTRACT

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_ABSTRACT
    ^self classVarAt:#ACC_ABSTRACT

    "Created: / 22-08-2012 / 10:53:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ACC_FINAL

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_FINAL
    ^self classVarAt:#ACC_FINAL

    "Created: / 22-08-2012 / 10:53:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ACC_PRIVATE

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_PRIVATE
    ^self classVarAt:#ACC_PRIVATE

    "Created: / 22-08-2012 / 10:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ACC_PROTECTED

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_PROTECTED
    ^self classVarAt:#ACC_PROTECTED

    "Created: / 22-08-2012 / 12:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ACC_PUBLIC

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_PUBLIC
    ^self classVarAt:#ACC_PUBLIC

    "Created: / 22-08-2012 / 10:53:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ACC_SUPER

    "/ Using crappy 'self classVarAt:#ACC_ABSTRACT' because of
    "/ yet another bug in stc
    "/ ^ACC_SUPER
    ^self classVarAt:#ACC_SUPER

    "Created: / 22-08-2012 / 10:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstants class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaConstants.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaConstants initialize!
