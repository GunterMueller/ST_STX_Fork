# $Header: /cvs/stx/stx/libdb/nosql/cassandra/Make.spec,v 1.5 2016-08-30 09:26:25 mawalch Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_cassandra.
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
MODULE_DIR=libdb/nosql/cassandra
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
STCLOCALOPTIMIZATIONS=+optspace3


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
	Cassandra::AuthenticationRequest \
	Cassandra::Cassandra \
	Cassandra::CassandraClient \
	Cassandra::CassandraConstants \
	Cassandra::CassandraError \
	Cassandra::CfDef \
	Cassandra::Column \
	Cassandra::ColumnDef \
	Cassandra::ColumnOrSuperColumn \
	Cassandra::ColumnParent \
	Cassandra::ColumnPath \
	Cassandra::CounterColumn \
	Cassandra::CounterSuperColumn \
	Cassandra::CqlMetadata \
	Cassandra::CqlPreparedResult \
	Cassandra::CqlResult \
	Cassandra::CqlRow \
	Cassandra::Deletion \
	Cassandra::EndpointDetails \
	Cassandra::IndexClause \
	Cassandra::IndexExpression \
	Cassandra::KeyCount \
	Cassandra::KeyRange \
	Cassandra::KeySlice \
	Cassandra::KsDef \
	Cassandra::Mutation \
	Cassandra::SlicePredicate \
	Cassandra::SliceRange \
	Cassandra::SuperColumn \
	Cassandra::TokenRange \
	stx_libdb_nosql_cassandra \
	Cassandra::AuthenticationException \
	Cassandra::AuthorizationException \
	Cassandra::InvalidRequestException \
	Cassandra::NotFoundException \
	Cassandra::SchemaDisagreementException \
	Cassandra::TimedOutException \
	Cassandra::UnavailableException \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Cassandra__AuthenticationRequest.$(O) \
    $(OUTDIR_SLASH)Cassandra__Cassandra.$(O) \
    $(OUTDIR_SLASH)Cassandra__CassandraClient.$(O) \
    $(OUTDIR_SLASH)CassandraConstants.$(O) \
    $(OUTDIR_SLASH)Cassandra__CassandraError.$(O) \
    $(OUTDIR_SLASH)Cassandra__CfDef.$(O) \
    $(OUTDIR_SLASH)Cassandra__Column.$(O) \
    $(OUTDIR_SLASH)Cassandra__ColumnDef.$(O) \
    $(OUTDIR_SLASH)Cassandra__ColumnOrSuperColumn.$(O) \
    $(OUTDIR_SLASH)Cassandra__ColumnParent.$(O) \
    $(OUTDIR_SLASH)Cassandra__ColumnPath.$(O) \
    $(OUTDIR_SLASH)Cassandra__CounterColumn.$(O) \
    $(OUTDIR_SLASH)Cassandra__CounterSuperColumn.$(O) \
    $(OUTDIR_SLASH)Cassandra__CqlMetadata.$(O) \
    $(OUTDIR_SLASH)Cassandra__CqlPreparedResult.$(O) \
    $(OUTDIR_SLASH)Cassandra__CqlResult.$(O) \
    $(OUTDIR_SLASH)Cassandra__CqlRow.$(O) \
    $(OUTDIR_SLASH)Cassandra__Deletion.$(O) \
    $(OUTDIR_SLASH)Cassandra__EndpointDetails.$(O) \
    $(OUTDIR_SLASH)Cassandra__IndexClause.$(O) \
    $(OUTDIR_SLASH)Cassandra__IndexExpression.$(O) \
    $(OUTDIR_SLASH)Cassandra__KeyCount.$(O) \
    $(OUTDIR_SLASH)Cassandra__KeyRange.$(O) \
    $(OUTDIR_SLASH)Cassandra__KeySlice.$(O) \
    $(OUTDIR_SLASH)Cassandra__KsDef.$(O) \
    $(OUTDIR_SLASH)Cassandra__Mutation.$(O) \
    $(OUTDIR_SLASH)Cassandra__SlicePredicate.$(O) \
    $(OUTDIR_SLASH)Cassandra__SliceRange.$(O) \
    $(OUTDIR_SLASH)Cassandra__SuperColumn.$(O) \
    $(OUTDIR_SLASH)Cassandra__TokenRange.$(O) \
    $(OUTDIR_SLASH)stx_libdb_nosql_cassandra.$(O) \
    $(OUTDIR_SLASH)Cassandra__AuthenticationException.$(O) \
    $(OUTDIR_SLASH)Cassandra__AuthorizationException.$(O) \
    $(OUTDIR_SLASH)Cassandra__InvalidRequestException.$(O) \
    $(OUTDIR_SLASH)Cassandra__NotFoundException.$(O) \
    $(OUTDIR_SLASH)Cassandra__SchemaDisagreementException.$(O) \
    $(OUTDIR_SLASH)Cassandra__TimedOutException.$(O) \
    $(OUTDIR_SLASH)Cassandra__UnavailableException.$(O) \



