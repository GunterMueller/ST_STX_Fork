# $Header: /cvs/stx/stx/libdb/liboracle/Make.spec,v 1.6 2013-01-30 11:54:10 cg Exp $
#
# DO NOT EDIT 
# automagically generated from the projectDefinition: stx_libdb_liboracle.
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
MODULE_DIR=libdb/liboracle
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -H.         : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
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
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_OBJS= \
    $(OUTDIR_SLASH)OCI8BindDescriptor.$(O) \
    $(OUTDIR_SLASH)OCI8ColumnDescriptor.$(O) \
    $(OUTDIR_SLASH)OCI8Environment.$(O) \
    $(OUTDIR_SLASH)OCI8Handle.$(O) \
    $(OUTDIR_SLASH)OCI8Session.$(O) \
    $(OUTDIR_SLASH)OCI8Statement.$(O) \
    $(OUTDIR_SLASH)OCI8Transaction.$(O) \
    $(OUTDIR_SLASH)OCI8Variable.$(O) \
    $(OUTDIR_SLASH)OCIBuffer.$(O) \
    $(OUTDIR_SLASH)OCICursor.$(O) \
    $(OUTDIR_SLASH)OCIError.$(O) \
    $(OUTDIR_SLASH)stx_libdb_liboracle.$(O) \
    $(OUTDIR_SLASH)OCI8BindVariable.$(O) \
    $(OUTDIR_SLASH)OCI8DDStatement.$(O) \
    $(OUTDIR_SLASH)OCI8DefineVariable.$(O) \
    $(OUTDIR_SLASH)OCI8SelectDescriptor.$(O) \
    $(OUTDIR_SLASH)OCI8StatementWithVariables.$(O) \
    $(OUTDIR_SLASH)OCIContinueSignal.$(O) \
    $(OUTDIR_SLASH)OCIDateBuffer.$(O) \
    $(OUTDIR_SLASH)OCIDescriptorBuffer.$(O) \
    $(OUTDIR_SLASH)OCIEndOfCommunicationError.$(O) \
    $(OUTDIR_SLASH)OCIInvalidHandleError.$(O) \
    $(OUTDIR_SLASH)OCIInvalidOperationError.$(O) \
    $(OUTDIR_SLASH)OCILogOnError.$(O) \
    $(OUTDIR_SLASH)OCINoDataError.$(O) \
    $(OUTDIR_SLASH)OCINumberBuffer.$(O) \
    $(OUTDIR_SLASH)OCIRawBuffer.$(O) \
    $(OUTDIR_SLASH)OCISessionError.$(O) \
    $(OUTDIR_SLASH)OCIStringBuffer.$(O) \
    $(OUTDIR_SLASH)OCISuccessWithInfoSignal.$(O) \
    $(OUTDIR_SLASH)OCIUnhandledAttributeTypeError.$(O) \
    $(OUTDIR_SLASH)OCIUserInterruptError.$(O) \
    $(OUTDIR_SLASH)OCI8DMStatement.$(O) \
    $(OUTDIR_SLASH)OCI8DefaultDefineVariable.$(O) \
    $(OUTDIR_SLASH)OCI8DynamicDefineVariable.$(O) \
    $(OUTDIR_SLASH)OCI8MultipleValueBindVariable.$(O) \
    $(OUTDIR_SLASH)OCI8QueryStatement.$(O) \
    $(OUTDIR_SLASH)OCI8ReturnValueBindVariable.$(O) \
    $(OUTDIR_SLASH)OCI8SingleValueBindVariable.$(O) \
    $(OUTDIR_SLASH)OCIBooleanBuffer.$(O) \
    $(OUTDIR_SLASH)OCIInvalidDatabaseParameterError.$(O) \
    $(OUTDIR_SLASH)OCIInvalidUserParameterError.$(O) \
    $(OUTDIR_SLASH)OCIRowIdDescriptorBuffer.$(O) \


