# $Header: /cvs/stx/stx/libdb/nosql/mongoDB/Make.spec,v 1.3 2013-04-04 22:34:03 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_mongoDB.
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
MODULE_DIR=libdb/nosql/mongoDB
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
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

COMMON_CLASSES= \
	CollectionValidation \
	Mongo \
	MongoCollection \
	MongoCursor \
	MongoDatabase \
	MongoOperation \
	MongoQuery \
	ReplyOperation \
	stx_libdb_nosql_mongoDB \
	DeleteOperation \
	GetMoreOperation \
	InsertOperation \
	MongoMetaCollection \
	QueryOperation \
	UpdateOperation \
	BSON \
	BSONError \
	BSONRegex \
	LittleEndianStream \
	OID \
	BSONUndefindedType \




COMMON_OBJS= \
    $(OUTDIR_SLASH)CollectionValidation.$(O) \
    $(OUTDIR_SLASH)Mongo.$(O) \
    $(OUTDIR_SLASH)MongoCollection.$(O) \
    $(OUTDIR_SLASH)MongoCursor.$(O) \
    $(OUTDIR_SLASH)MongoDatabase.$(O) \
    $(OUTDIR_SLASH)MongoOperation.$(O) \
    $(OUTDIR_SLASH)MongoQuery.$(O) \
    $(OUTDIR_SLASH)ReplyOperation.$(O) \
    $(OUTDIR_SLASH)stx_libdb_nosql_mongoDB.$(O) \
    $(OUTDIR_SLASH)DeleteOperation.$(O) \
    $(OUTDIR_SLASH)GetMoreOperation.$(O) \
    $(OUTDIR_SLASH)InsertOperation.$(O) \
    $(OUTDIR_SLASH)MongoMetaCollection.$(O) \
    $(OUTDIR_SLASH)QueryOperation.$(O) \
    $(OUTDIR_SLASH)UpdateOperation.$(O) \
    $(OUTDIR_SLASH)BSON.$(O) \
    $(OUTDIR_SLASH)BSONError.$(O) \
    $(OUTDIR_SLASH)BSONRegex.$(O) \
    $(OUTDIR_SLASH)LittleEndianStream.$(O) \
    $(OUTDIR_SLASH)OID.$(O) \
    $(OUTDIR_SLASH)BSONUndefindedType.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



