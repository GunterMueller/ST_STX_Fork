# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjava.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libjava
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optinline +optinline2


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	GroovyCompiler \
	GroovyEvaluator \
	GroovyLanguage \
	GroovySourceFileWriter \
	JavaAnnotation \
	JavaAnnotationContainer \
	JavaAnnotationDefault \
	JavaAnnotationDictionary \
	JavaAnnotationValue \
	JavaArray \
	JavaBooleanArray \
	JavaByte \
	JavaByteCodeProcessor \
	JavaClassAccessor \
	JavaClassEnvironment \
	JavaClassQuery \
	JavaClassReloader \
	JavaCodeLibraryOrBundle \
	JavaCompilerForSmalltalkExtensionsOnly \
	JavaCompiler_Eclipse \
	JavaConstantPool \
	JavaConstants \
	JavaContext \
	JavaDecompiler \
	JavaDescriptor \
	JavaError \
	JavaExceptionTable \
	JavaField \
	JavaFinalizationRegistry \
	JavaInnerClasses \
	JavaLanguage \
	JavaLibraries \
	JavaLocalVariableTable \
	JavaLocalVariableTableEntry \
	JavaLookup \
	JavaMetaclass \
	JavaMonitor \
	JavaNameAndType2 \
	JavaNativeMemory \
	JavaNioSupport \
	JavaObject \
	JavaObjectDictionary \
	JavaPopUpView \
	JavaProcess \
	JavaRef2 \
	JavaRelease \
	JavaResolver \
	JavaShort \
	JavaSocket \
	JavaSourceCodeCache \
	JavaSourceFileWriter \
	JavaTestsLoader \
	JavaTopView \
	JavaUnresolvedCompilationError \
	JavaUnresolvedConstant \
	JavaUtilities \
	JavaVMData \
	JavaView \
	JavaZipDeflater \
	JavaZipFile \
	JavaZipInflater \
	ProxyMethod \
	ProxyMethodCompiler \
	ProxyMethodNode \
	SmalltalkAppletContext \
	SmalltalkAppletStub \
	stx_libjava \
	GroovyMetaclass \
	Java \
	JavaAnnotationArrayValue \
	JavaAnnotationClassValue \
	JavaAnnotationEnumValue \
	JavaAnnotationNestedAnnotationValue \
	JavaAnnotationPrimitiveValue \
	JavaBehavior \
	JavaByteCodeDisassembler \
	JavaByteCodeProcessorAdapter \
	JavaClassAnnotationContainer \
	JavaClassFormatError \
	JavaClassMemberRef2 \
	JavaClassReader \
	JavaClassRef2 \
	JavaClassRegistry \
	JavaCodeBundle \
	JavaCodeLibrary \
	JavaEmbeddedFrameView \
	JavaFieldAnnotationContainer \
	JavaFieldDescriptor \
	JavaFieldDescriptorWithUnionType \
	JavaInvokeDynamic2 \
	JavaMethod \
	JavaMethodAnnotationContainer \
	JavaMethodDescriptor \
	JavaMethodHandle2 \
	JavaMethodType2 \
	JavaMirror \
	JavaNativeMethodImpl_OpenJDK6 \
	JavaStringRef2 \
	JavaUnhandledExceptionError \
	JavaUnhandledThreadDeathError \
	JavaUnresolvedClassConstant \
	JavaUnresolvedStringConstant \
	JavaVM \
	ProxyMethodConditionNode \
	ProxyMethodGuardNode \
	ProxyMethodInvocationNode \
	ProxyMethodJavaFieldAccessor \
	JavaAlienMirror \
	JavaArrayMirror \
	JavaByteCodePreresolver \
	JavaClass \
	JavaClassMirror \
	JavaClassPathBundle \
	JavaFieldRef2 \
	JavaMethodAnalyzer \
	JavaMethodRef2 \
	JavaMethodWithException \
	JavaNativeMethodImpl_AppleJDK6 \
	JavaNativeMethodImpl_OpenJDK7 \
	JavaNativeMethodImpl_SunJDK6 \
	JavaPrimitiveMirror \
	ProxyMethodAndNode \
	ProxyMethodBlockInvocationNode \
	ProxyMethodJavaFieldGetter \
	ProxyMethodJavaFieldSetter \
	ProxyMethodMethodInvocationNode \
	ProxyMethodTypeCheckNode \
	GroovyClass \
	JavaInterfaceMethodRef2 \
	JavaMethodWithHandler \
	JavaNativeMethodImpl_OpenJDK8 \
	JavaNativeMethodImpl_OracleJDK7 \
	ProxyMethodJavaMethodInvocationNode \
	ProxyMethodJavaTypeCheckNode \
	JavaNativeMethod \
	JavaNativeMethodImpl_OracleJDK8 \




COMMON_OBJS= \
    $(OUTDIR)GroovyCompiler.$(O) \
    $(OUTDIR)GroovyEvaluator.$(O) \
    $(OUTDIR)GroovyLanguage.$(O) \
    $(OUTDIR)GroovySourceFileWriter.$(O) \
    $(OUTDIR)JavaAnnotation.$(O) \
    $(OUTDIR)JavaAnnotationContainer.$(O) \
    $(OUTDIR)JavaAnnotationDefault.$(O) \
    $(OUTDIR)JavaAnnotationDictionary.$(O) \
    $(OUTDIR)JavaAnnotationValue.$(O) \
    $(OUTDIR)JavaArray.$(O) \
    $(OUTDIR)JavaBooleanArray.$(O) \
    $(OUTDIR)JavaByte.$(O) \
    $(OUTDIR)JavaByteCodeProcessor.$(O) \
    $(OUTDIR)JavaClassAccessor.$(O) \
    $(OUTDIR)JavaClassEnvironment.$(O) \
    $(OUTDIR)JavaClassQuery.$(O) \
    $(OUTDIR)JavaClassReloader.$(O) \
    $(OUTDIR)JavaCodeLibraryOrBundle.$(O) \
    $(OUTDIR)JavaCompilerForSmalltalkExtensionsOnly.$(O) \
    $(OUTDIR)JavaCompiler_Eclipse.$(O) \
    $(OUTDIR)JavaConstantPool.$(O) \
    $(OUTDIR)JavaConstants.$(O) \
    $(OUTDIR)JavaContext.$(O) \
    $(OUTDIR)JavaDecompiler.$(O) \
    $(OUTDIR)JavaDescriptor.$(O) \
    $(OUTDIR)JavaError.$(O) \
    $(OUTDIR)JavaExceptionTable.$(O) \
    $(OUTDIR)JavaField.$(O) \
    $(OUTDIR)JavaFinalizationRegistry.$(O) \
    $(OUTDIR)JavaInnerClasses.$(O) \
    $(OUTDIR)JavaLanguage.$(O) \
    $(OUTDIR)JavaLibraries.$(O) \
    $(OUTDIR)JavaLocalVariableTable.$(O) \
    $(OUTDIR)JavaLocalVariableTableEntry.$(O) \
    $(OUTDIR)JavaLookup.$(O) \
    $(OUTDIR)JavaMetaclass.$(O) \
    $(OUTDIR)JavaMonitor.$(O) \
    $(OUTDIR)JavaNameAndType2.$(O) \
    $(OUTDIR)JavaNativeMemory.$(O) \
    $(OUTDIR)JavaNioSupport.$(O) \
    $(OUTDIR)JavaObject.$(O) \
    $(OUTDIR)JavaObjectDictionary.$(O) \
    $(OUTDIR)JavaPopUpView.$(O) \
    $(OUTDIR)JavaProcess.$(O) \
    $(OUTDIR)JavaRef2.$(O) \
    $(OUTDIR)JavaRelease.$(O) \
    $(OUTDIR)JavaResolver.$(O) \
    $(OUTDIR)JavaShort.$(O) \
    $(OUTDIR)JavaSocket.$(O) \
    $(OUTDIR)JavaSourceCodeCache.$(O) \
    $(OUTDIR)JavaSourceFileWriter.$(O) \
    $(OUTDIR)JavaTestsLoader.$(O) \
    $(OUTDIR)JavaTopView.$(O) \
    $(OUTDIR)JavaUnresolvedCompilationError.$(O) \
    $(OUTDIR)JavaUnresolvedConstant.$(O) \
    $(OUTDIR)JavaUtilities.$(O) \
    $(OUTDIR)JavaVMData.$(O) \
    $(OUTDIR)JavaView.$(O) \
    $(OUTDIR)JavaZipDeflater.$(O) \
    $(OUTDIR)JavaZipFile.$(O) \
    $(OUTDIR)JavaZipInflater.$(O) \
    $(OUTDIR)ProxyMethod.$(O) \
    $(OUTDIR)ProxyMethodCompiler.$(O) \
    $(OUTDIR)ProxyMethodNode.$(O) \
    $(OUTDIR)SmalltalkAppletContext.$(O) \
    $(OUTDIR)SmalltalkAppletStub.$(O) \
    $(OUTDIR)stx_libjava.$(O) \
    $(OUTDIR)GroovyMetaclass.$(O) \
    $(OUTDIR)Java.$(O) \
    $(OUTDIR)JavaAnnotationArrayValue.$(O) \
    $(OUTDIR)JavaAnnotationClassValue.$(O) \
    $(OUTDIR)JavaAnnotationEnumValue.$(O) \
    $(OUTDIR)JavaAnnotationNestedAnnotationValue.$(O) \
    $(OUTDIR)JavaAnnotationPrimitiveValue.$(O) \
    $(OUTDIR)JavaBehavior.$(O) \
    $(OUTDIR)JavaByteCodeDisassembler.$(O) \
    $(OUTDIR)JavaByteCodeProcessorAdapter.$(O) \
    $(OUTDIR)JavaClassAnnotationContainer.$(O) \
    $(OUTDIR)JavaClassFormatError.$(O) \
    $(OUTDIR)JavaClassMemberRef2.$(O) \
    $(OUTDIR)JavaClassReader.$(O) \
    $(OUTDIR)JavaClassRef2.$(O) \
    $(OUTDIR)JavaClassRegistry.$(O) \
    $(OUTDIR)JavaCodeBundle.$(O) \
    $(OUTDIR)JavaCodeLibrary.$(O) \
    $(OUTDIR)JavaEmbeddedFrameView.$(O) \
    $(OUTDIR)JavaFieldAnnotationContainer.$(O) \
    $(OUTDIR)JavaFieldDescriptor.$(O) \
    $(OUTDIR)JavaFieldDescriptorWithUnionType.$(O) \
    $(OUTDIR)JavaInvokeDynamic2.$(O) \
    $(OUTDIR)JavaMethod.$(O) \
    $(OUTDIR)JavaMethodAnnotationContainer.$(O) \
    $(OUTDIR)JavaMethodDescriptor.$(O) \
    $(OUTDIR)JavaMethodHandle2.$(O) \
    $(OUTDIR)JavaMethodType2.$(O) \
    $(OUTDIR)JavaMirror.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_OpenJDK6.$(O) \
    $(OUTDIR)JavaStringRef2.$(O) \
    $(OUTDIR)JavaUnhandledExceptionError.$(O) \
    $(OUTDIR)JavaUnhandledThreadDeathError.$(O) \
    $(OUTDIR)JavaUnresolvedClassConstant.$(O) \
    $(OUTDIR)JavaUnresolvedStringConstant.$(O) \
    $(OUTDIR)JavaVM.$(O) \
    $(OUTDIR)ProxyMethodConditionNode.$(O) \
    $(OUTDIR)ProxyMethodGuardNode.$(O) \
    $(OUTDIR)ProxyMethodInvocationNode.$(O) \
    $(OUTDIR)ProxyMethodJavaFieldAccessor.$(O) \
    $(OUTDIR)JavaAlienMirror.$(O) \
    $(OUTDIR)JavaArrayMirror.$(O) \
    $(OUTDIR)JavaByteCodePreresolver.$(O) \
    $(OUTDIR)JavaClass.$(O) \
    $(OUTDIR)JavaClassMirror.$(O) \
    $(OUTDIR)JavaClassPathBundle.$(O) \
    $(OUTDIR)JavaFieldRef2.$(O) \
    $(OUTDIR)JavaMethodAnalyzer.$(O) \
    $(OUTDIR)JavaMethodRef2.$(O) \
    $(OUTDIR)JavaMethodWithException.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_AppleJDK6.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_OpenJDK7.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_SunJDK6.$(O) \
    $(OUTDIR)JavaPrimitiveMirror.$(O) \
    $(OUTDIR)ProxyMethodAndNode.$(O) \
    $(OUTDIR)ProxyMethodBlockInvocationNode.$(O) \
    $(OUTDIR)ProxyMethodJavaFieldGetter.$(O) \
    $(OUTDIR)ProxyMethodJavaFieldSetter.$(O) \
    $(OUTDIR)ProxyMethodMethodInvocationNode.$(O) \
    $(OUTDIR)ProxyMethodTypeCheckNode.$(O) \
    $(OUTDIR)GroovyClass.$(O) \
    $(OUTDIR)JavaInterfaceMethodRef2.$(O) \
    $(OUTDIR)JavaMethodWithHandler.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_OpenJDK8.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_OracleJDK7.$(O) \
    $(OUTDIR)ProxyMethodJavaMethodInvocationNode.$(O) \
    $(OUTDIR)ProxyMethodJavaTypeCheckNode.$(O) \
    $(OUTDIR)JavaNativeMethod.$(O) \
    $(OUTDIR)JavaNativeMethodImpl_OracleJDK8.$(O) \
    $(OUTDIR)extensions.$(O) \



