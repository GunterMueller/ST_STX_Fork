# $Header: /cvs/stx/stx/libdb/nosql/mongoDB/bc.mak,v 1.3 2013-04-04 22:34:20 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_mongoDB.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_nosql_mongoDB
RESFILES=mongoDB.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd stx & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)BSON.$(O) BSON.$(H): BSON.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BSONError.$(O) BSONError.$(H): BSONError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BSONRegex.$(O) BSONRegex.$(H): BSONRegex.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CollectionValidation.$(O) CollectionValidation.$(H): CollectionValidation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LittleEndianStream.$(O) LittleEndianStream.$(H): LittleEndianStream.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Mongo.$(O) Mongo.$(H): Mongo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoCollection.$(O) MongoCollection.$(H): MongoCollection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoCursor.$(O) MongoCursor.$(H): MongoCursor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoDatabase.$(O) MongoDatabase.$(H): MongoDatabase.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoOperation.$(O) MongoOperation.$(H): MongoOperation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoQuery.$(O) MongoQuery.$(H): MongoQuery.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OID.$(O) OID.$(H): OID.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ReplyOperation.$(O) ReplyOperation.$(H): ReplyOperation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_mongoDB.$(O) stx_libdb_nosql_mongoDB.$(H): stx_libdb_nosql_mongoDB.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BSONUndefindedType.$(O) BSONUndefindedType.$(H): BSONUndefindedType.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\BSONError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DeleteOperation.$(O) DeleteOperation.$(H): DeleteOperation.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GetMoreOperation.$(O) GetMoreOperation.$(H): GetMoreOperation.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InsertOperation.$(O) InsertOperation.$(H): InsertOperation.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MongoMetaCollection.$(O) MongoMetaCollection.$(H): MongoMetaCollection.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)QueryOperation.$(O) QueryOperation.$(H): QueryOperation.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UpdateOperation.$(O) UpdateOperation.$(H): UpdateOperation.st $(INCLUDE_TOP)\stx\libdb\nosql\mongoDB\MongoOperation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Association.$(H) $(INCLUDE_TOP)\stx\libbasic\LookupKey.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\Date.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\TwoByteString.$(H) $(INCLUDE_TOP)\stx\libbasic2\UUID.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
