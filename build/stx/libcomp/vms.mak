#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libcomp/vms.mak,v 1.4 1999-09-18 14:11:39 cg Exp $
#
TOP=..
LIBNAME=libcomp
STCOPT="+optinline -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)Scanner.$(O) \
  $(OUTDIR)Parser.$(O) \
  $(OUTDIR)ByteCodeCompiler.$(O) \
  $(OUTDIR)Explainer.$(O) \
  $(OUTDIR)ProgramNodeEnumerator.$(O) \
  $(OUTDIR)Variable.$(O) \
  $(OUTDIR)ParseNode.$(O) \
  $(OUTDIR)PrimaryNode.$(O) \
  $(OUTDIR)VariableNode.$(O) \
  $(OUTDIR)SelfNode.$(O) \
  $(OUTDIR)SuperNode.$(O) \
  $(OUTDIR)ConstantNode.$(O) \
  $(OUTDIR)StatementNode.$(O) \
  $(OUTDIR)ReturnNode.$(O) \
  $(OUTDIR)PrimitiveNode.$(O) \
  $(OUTDIR)AssignmentNode.$(O) \
  $(OUTDIR)BlockNode.$(O) \
  $(OUTDIR)MessageNode.$(O) \
  $(OUTDIR)UnaryNode.$(O) \
  $(OUTDIR)BinaryNode.$(O) \
  $(OUTDIR)CascadeNode.$(O) \
  $(OUTDIR)UndefinedVariable.$(O) \
  $(OUTDIR)LazyMethod.$(O) \
  $(OUTDIR)SourceFileLoader.$(O) \
  $(OUTDIR)ImmutableArray.$(O) \
  $(OUTDIR)Structure.$(O) \
  $(OUTDIR)SyntaxHighlighter.$(O) \
  $(OUTDIR)ObjectFileHandle.$(O) \
  $(OUTDIR)ObjectFileLoader.$(O) \


theLib:: $(LIBNAME).olb
	write sys$output "making class objects ..."
	$(MAKE) objs
	$(MAKE) libinit
	write sys$output "classlibrary $(LIBNAME).olb made."

$(LIBNAME).olb:
	write sys$output "creating initial $(LIBNAME).olb ..."
	lib/cre $(LIBNAME).olb

objs:  $(OBJS1)



# BEGINMAKEDEPEND
$(OUTDIR)AssignmentNode.$(O) AssignmentNode.$(H): AssignmentNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)BinaryNode.$(O) BinaryNode.$(H): BinaryNode.st $(STCHDR)  ../include/MessageNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)BlockNode.$(O) BlockNode.$(H): BlockNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)ByteCodeCompiler.$(O) ByteCodeCompiler.$(H): ByteCodeCompiler.st $(STCHDR)  ../include/Parser.$(H)  ../include/Scanner.$(H)  ../include/Object.$(H) 
$(OUTDIR)CascadeNode.$(O) CascadeNode.$(H): CascadeNode.st $(STCHDR)  ../include/MessageNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)CodeStream.$(O) CodeStream.$(H): CodeStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)CompilationErrorHandler.$(O) CompilationErrorHandler.$(H): CompilationErrorHandler.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ConstantNode.$(O) ConstantNode.$(H): ConstantNode.st $(STCHDR)  ../include/PrimaryNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)Decompiler.$(O) Decompiler.$(H): Decompiler.st $(STCHDR)  ../include/ByteCodeCompiler.$(H)  ../include/Parser.$(H)  ../include/Scanner.$(H)  ../include/Object.$(H) 
$(OUTDIR)Explainer.$(O) Explainer.$(H): Explainer.st $(STCHDR)  ../include/Parser.$(H)  ../include/Scanner.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImmutableArray.$(O) ImmutableArray.$(H): ImmutableArray.st $(STCHDR)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ImmutableString.$(O) ImmutableString.$(H): ImmutableString.st $(STCHDR)  ../include/String.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)LazyMethod.$(O) LazyMethod.$(H): LazyMethod.st $(STCHDR)  ../include/Method.$(H)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)MessageNode.$(O) MessageNode.$(H): MessageNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodNode.$(O) MethodNode.$(H): MethodNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)NullScope.$(O) NullScope.$(H): NullScope.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ObjectFileHandle.$(O) ObjectFileHandle.$(H): ObjectFileHandle.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ObjectFileLoader.$(O) ObjectFileLoader.$(H): ObjectFileLoader.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ParameterNode.$(O) ParameterNode.$(H): ParameterNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)ParseNode.$(O) ParseNode.$(H): ParseNode.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Parser.$(O) Parser.$(H): Parser.st $(STCHDR)  ../include/Scanner.$(H)  ../include/Object.$(H) 
$(OUTDIR)PrimaryNode.$(O) PrimaryNode.$(H): PrimaryNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)PrimitiveNode.$(O) PrimitiveNode.$(H): PrimitiveNode.st $(STCHDR)  ../include/StatementNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProgramNodeBuilder.$(O) ProgramNodeBuilder.$(H): ProgramNodeBuilder.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ProgramNodeEnumerator.$(O) ProgramNodeEnumerator.$(H): ProgramNodeEnumerator.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ReturnNode.$(O) ReturnNode.$(H): ReturnNode.st $(STCHDR)  ../include/StatementNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)Scanner.$(O) Scanner.$(H): Scanner.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SelfNode.$(O) SelfNode.$(H): SelfNode.st $(STCHDR)  ../include/PrimaryNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)SourceFileLoader.$(O) SourceFileLoader.$(H): SourceFileLoader.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)StatementNode.$(O) StatementNode.$(H): StatementNode.st $(STCHDR)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)Structure.$(O) Structure.$(H): Structure.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SuperNode.$(O) SuperNode.$(H): SuperNode.st $(STCHDR)  ../include/SelfNode.$(H)  ../include/PrimaryNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)Switch.$(O) Switch.$(H): Switch.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SyntaxHighlighter.$(O) SyntaxHighlighter.$(H): SyntaxHighlighter.st $(STCHDR)  ../include/Parser.$(H)  ../include/Scanner.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnaryNode.$(O) UnaryNode.$(H): UnaryNode.st $(STCHDR)  ../include/MessageNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)UndefinedVariable.$(O) UndefinedVariable.$(H): UndefinedVariable.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Variable.$(O) Variable.$(H): Variable.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)VariableNode.$(O) VariableNode.$(H): VariableNode.st $(STCHDR)  ../include/PrimaryNode.$(H)  ../include/ParseNode.$(H)  ../include/Object.$(H) 
$(OUTDIR)WarningCompilationErrorHandler.$(O) WarningCompilationErrorHandler.$(H): WarningCompilationErrorHandler.st $(STCHDR) 
# ENDMAKEDEPEND
