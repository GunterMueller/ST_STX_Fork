#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libbasic/vms.mak,v 1.9 2001/10/31 15:02:19 cg Exp $
#
TOP=..
LIBNAME=libbasic
STCOPT="+optinline +optinline2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)Object.$(O) \
  $(OUTDIR)Autoload.$(O) \
  $(OUTDIR)Project.$(O) \
  $(OUTDIR)NameSpace.$(O) \
  $(OUTDIR)Boolean.$(O) \
  $(OUTDIR)True.$(O) \
  $(OUTDIR)False.$(O) \
  $(OUTDIR)ClassCategoryReader.$(O) \
  $(OUTDIR)Collection.$(O) \
  $(OUTDIR)Bag.$(O) \
  $(OUTDIR)SequenceableCollection.$(O) \
  $(OUTDIR)ReadOnlySequenceableCollection.$(O) \
  $(OUTDIR)ArrayedCollection.$(O) \
  $(OUTDIR)UninterpretedBytes.$(O) \
  $(OUTDIR)Array.$(O) \
  $(OUTDIR)WeakArray.$(O) \
  $(OUTDIR)ByteArray.$(O) \
  $(OUTDIR)CharacterArray.$(O) \
  $(OUTDIR)String.$(O) \
  $(OUTDIR)Symbol.$(O) \
  $(OUTDIR)DoubleArray.$(O) \
  $(OUTDIR)FloatArray.$(O) \
  $(OUTDIR)Interval.$(O) \
  $(OUTDIR)LinkedList.$(O) \
  $(OUTDIR)Semaphore.$(O) \
  $(OUTDIR)OrderedCollection.$(O) \
  $(OUTDIR)SortedCollection.$(O) \
  $(OUTDIR)Set.$(O) \
  $(OUTDIR)Dictionary.$(O) \
  $(OUTDIR)IdentityDictionary.$(O) \
  $(OUTDIR)WeakIdentityDictionary.$(O) \
  $(OUTDIR)WeakDependencyDictionary.$(O) \
  $(OUTDIR)WeakValueDictionary.$(O) \
  $(OUTDIR)IdentitySet.$(O) \
  $(OUTDIR)WeakIdentitySet.$(O) \
  $(OUTDIR)SignalSet.$(O) \
  $(OUTDIR)ExceptionHandlerSet.$(O) \
  $(OUTDIR)SemaphoreSet.$(O) \
  $(OUTDIR)Context.$(O) \
  $(OUTDIR)BlockContext.$(O) \
  $(OUTDIR)Delay.$(O) \
  $(OUTDIR)GenericException.$(O) \
  $(OUTDIR)Exception.$(O) \
  $(OUTDIR)Error.$(O) \
  $(OUTDIR)ProceedableError.$(O) \
  $(OUTDIR)SignalError.$(O) \
  $(OUTDIR)WrongProceedabilityError.$(O) \
  $(OUTDIR)Warning.$(O) \
  $(OUTDIR)ProceedError.$(O) \
  $(OUTDIR)Notification.$(O) \
  $(OUTDIR)UserNotification.$(O) \
  $(OUTDIR)NoHandlerError.$(O) \
  $(OUTDIR)RecursiveExceptionError.$(O) \
  $(OUTDIR)Behavior.$(O) \
  $(OUTDIR)ClassDescription.$(O) \
  $(OUTDIR)Class.$(O) \
  $(OUTDIR)Metaclass.$(O) \
  $(OUTDIR)PrivateMetaclass.$(O) \
  $(OUTDIR)AutoloadMetaclass.$(O) \
  $(OUTDIR)ExecutableFunction.$(O) \
  $(OUTDIR)CompiledCode.$(O) \
  $(OUTDIR)Block.$(O) \
  $(OUTDIR)VarArgBlock.$(O) \
  $(OUTDIR)CheapBlock.$(O) \
  $(OUTDIR)VarArgCheapBlock.$(O) \
  $(OUTDIR)Method.$(O) \
  $(OUTDIR)Filename.$(O) \
  $(OUTDIR)InterestConverter.$(O) \
  $(OUTDIR)WeakInterestConverter.$(O) \
  $(OUTDIR)Link.$(O) \
  $(OUTDIR)Process.$(O) \
  $(OUTDIR)Magnitude.$(O) \
  $(OUTDIR)LookupKey.$(O) \
  $(OUTDIR)Association.$(O) \
  $(OUTDIR)AbstractTime.$(O) \
  $(OUTDIR)AbsoluteTime.$(O) \
  $(OUTDIR)Time.$(O) \
  $(OUTDIR)ArithmeticValue.$(O) \
  $(OUTDIR)Number.$(O) \
  $(OUTDIR)Fraction.$(O) \
  $(OUTDIR)Integer.$(O) \
  $(OUTDIR)LargeInteger.$(O) \
  $(OUTDIR)SmallInteger.$(O) \
  $(OUTDIR)LimitedPrecisionReal.$(O) \
  $(OUTDIR)Float.$(O) \
  $(OUTDIR)ShortFloat.$(O) \
  $(OUTDIR)LongFloat.$(O) \
  $(OUTDIR)Point.$(O) \
  $(OUTDIR)Character.$(O) \
  $(OUTDIR)Date.$(O) \
  $(OUTDIR)Message.$(O) \
  $(OUTDIR)MiniDebugger.$(O) \
  $(OUTDIR)MiniInspector.$(O) \
  $(OUTDIR)ObjectMemory.$(O) \
  $(OUTDIR)ProcessorScheduler.$(O) \
  $(OUTDIR)Geometric.$(O) \
  $(OUTDIR)Rectangle.$(O) \
  $(OUTDIR)Registry.$(O) \
  $(OUTDIR)HandleRegistry.$(O) \
  $(OUTDIR)Signal.$(O) \
  $(OUTDIR)QuerySignal.$(O) \
  $(OUTDIR)Smalltalk.$(O) \
  $(OUTDIR)Stream.$(O) \
  $(OUTDIR)PeekableStream.$(O) \
  $(OUTDIR)PositionableStream.$(O) \
  $(OUTDIR)ReadStream.$(O) \
  $(OUTDIR)WriteStream.$(O) \
  $(OUTDIR)ReadWriteStream.$(O) \
  $(OUTDIR)ExternalStream.$(O) \
  $(OUTDIR)FileStream.$(O) \
  $(OUTDIR)DirectoryStream.$(O) \
  $(OUTDIR)NonPositionableExternalStream.$(O) \
  $(OUTDIR)PipeStream.$(O) \
  $(OUTDIR)FileDirectory.$(O) \
  $(OUTDIR)UndefinedObject.$(O) \
  $(OUTDIR)ExternalAddress.$(O) \
  $(OUTDIR)ExternalBytes.$(O) \
  $(OUTDIR)ExternalFunction.$(O) \
  $(OUTDIR)MethodDictionary.$(O) \
  $(OUTDIR)OSHandle.$(O) \
  $(OUTDIR)OSFileHandle.$(O) \
  $(OUTDIR)AbstractOperatingSystem.$(O) \
  $(OUTDIR)UserPreferences.$(O) \
  $(OUTDIR)OpenVMSFilename.$(O) \
  $(OUTDIR)OpenVMSFileHandle.$(O) \
  $(OUTDIR)OpenVMSOperatingSystem.$(O) \


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
$(OUTDIR)AbsoluteTime.$(O) AbsoluteTime.$(H): AbsoluteTime.st $(STCHDR)  ../include/AbstractTime.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)AbstractOperatingSystem.$(O) AbstractOperatingSystem.$(H): AbstractOperatingSystem.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)AbstractTime.$(O) AbstractTime.$(H): AbstractTime.st $(STCHDR)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)ArithmeticValue.$(O) ArithmeticValue.$(H): ArithmeticValue.st $(STCHDR)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Array.$(O) Array.$(H): Array.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ArrayedCollection.$(O) ArrayedCollection.$(H): ArrayedCollection.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Association.$(O) Association.$(H): Association.st $(STCHDR)  ../include/LookupKey.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Autoload.$(O) Autoload.$(H): Autoload.st $(STCHDR) 
$(OUTDIR)AutoloadMetaclass.$(O) AutoloadMetaclass.$(H): AutoloadMetaclass.st $(STCHDR)  ../include/Metaclass.$(H)  ../include/ClassDescription.$(H)  ../include/Behavior.$(H)  ../include/Object.$(H) 
$(OUTDIR)Bag.$(O) Bag.$(H): Bag.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Behavior.$(O) Behavior.$(H): Behavior.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Block.$(O) Block.$(H): Block.st $(STCHDR)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)BlockContext.$(O) BlockContext.$(H): BlockContext.st $(STCHDR)  ../include/Context.$(H)  ../include/Object.$(H) 
$(OUTDIR)Boolean.$(O) Boolean.$(H): Boolean.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ByteArray.$(O) ByteArray.$(H): ByteArray.st $(STCHDR)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Character.$(O) Character.$(H): Character.st $(STCHDR)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)CharacterArray.$(O) CharacterArray.$(H): CharacterArray.st $(STCHDR)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)CheapBlock.$(O) CheapBlock.$(H): CheapBlock.st $(STCHDR)  ../include/Block.$(H)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)Class.$(O) Class.$(H): Class.st $(STCHDR)  ../include/ClassDescription.$(H)  ../include/Behavior.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassCategoryReader.$(O) ClassCategoryReader.$(H): ClassCategoryReader.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ClassDescription.$(O) ClassDescription.$(H): ClassDescription.st $(STCHDR)  ../include/Behavior.$(H)  ../include/Object.$(H)  ../include/Notification.$(H)  ../include/Exception.$(H)  ../include/GenericException.$(H) 
$(OUTDIR)Collection.$(O) Collection.$(H): Collection.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)CompiledCode.$(O) CompiledCode.$(H): CompiledCode.st $(STCHDR)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)Context.$(O) Context.$(H): Context.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Date.$(O) Date.$(H): Date.st $(STCHDR)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Delay.$(O) Delay.$(H): Delay.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Dictionary.$(O) Dictionary.$(H): Dictionary.st $(STCHDR)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)DirectoryStream.$(O) DirectoryStream.$(H): DirectoryStream.st $(STCHDR)  ../include/FileStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)DoubleArray.$(O) DoubleArray.$(H): DoubleArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Error.$(O) Error.$(H): Error.st $(STCHDR)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)Exception.$(O) Exception.$(H): Exception.st $(STCHDR)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExceptionHandlerSet.$(O) ExceptionHandlerSet.$(H): ExceptionHandlerSet.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExecutableFunction.$(O) ExecutableFunction.$(H): ExecutableFunction.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ExternalAddress.$(O) ExternalAddress.$(H): ExternalAddress.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ExternalBytes.$(O) ExternalBytes.$(H): ExternalBytes.st $(STCHDR)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExternalFunction.$(O) ExternalFunction.$(H): ExternalFunction.st $(STCHDR)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExternalStream.$(O) ExternalStream.$(H): ExternalStream.st $(STCHDR)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)ExternalStream.$(O) ExternalStream.$(H): ExternalStream.st $(STCHDR)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)False.$(O) False.$(H): False.st $(STCHDR)  ../include/Boolean.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileDirectory.$(O) FileDirectory.$(H): FileDirectory.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileStream.$(O) FileStream.$(H): FileStream.st $(STCHDR)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)FileStream.$(O) FileStream.$(H): FileStream.st $(STCHDR)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)Filename.$(O) Filename.$(H): Filename.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)FixedPoint.$(O) FixedPoint.$(H): FixedPoint.st $(STCHDR)  ../include/Fraction.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Float.$(O) Float.$(H): Float.st $(STCHDR)  ../include/LimitedPrecisionReal.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)FloatArray.$(O) FloatArray.$(H): FloatArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Fraction.$(O) Fraction.$(H): Fraction.st $(STCHDR)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)GenericException.$(O) GenericException.$(H): GenericException.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Geometric.$(O) Geometric.$(H): Geometric.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HandleRegistry.$(O) HandleRegistry.$(H): HandleRegistry.st $(STCHDR)  ../include/Registry.$(H)  ../include/Object.$(H) 
$(OUTDIR)IdentityDictionary.$(O) IdentityDictionary.$(H): IdentityDictionary.st $(STCHDR)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)IdentitySet.$(O) IdentitySet.$(H): IdentitySet.st $(STCHDR)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Integer.$(O) Integer.$(H): Integer.st $(STCHDR)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)InterestConverter.$(O) InterestConverter.$(H): InterestConverter.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Interval.$(O) Interval.$(H): Interval.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)LargeInteger.$(O) LargeInteger.$(H): LargeInteger.st $(STCHDR)  ../include/Integer.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)LimitedPrecisionReal.$(O) LimitedPrecisionReal.$(H): LimitedPrecisionReal.st $(STCHDR)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Link.$(O) Link.$(H): Link.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)LinkedList.$(O) LinkedList.$(H): LinkedList.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)LongFloat.$(O) LongFloat.$(H): LongFloat.st $(STCHDR)  ../include/LimitedPrecisionReal.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)LookupKey.$(O) LookupKey.$(H): LookupKey.st $(STCHDR)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)MacFilename.$(O) MacFilename.$(H): MacFilename.st $(STCHDR)  ../include/Filename.$(H)  ../include/Object.$(H) 
$(OUTDIR)Magnitude.$(O) Magnitude.$(H): Magnitude.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Message.$(O) Message.$(H): Message.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Metaclass.$(O) Metaclass.$(H): Metaclass.st $(STCHDR)  ../include/ClassDescription.$(H)  ../include/Behavior.$(H)  ../include/Object.$(H) 
$(OUTDIR)Method.$(O) Method.$(H): Method.st $(STCHDR)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodDictionary.$(O) MethodDictionary.$(H): MethodDictionary.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)MiniDebugger.$(O) MiniDebugger.$(H): MiniDebugger.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)MiniInspector.$(O) MiniInspector.$(H): MiniInspector.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)NameSpace.$(O) NameSpace.$(H): NameSpace.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)NoHandlerError.$(O) NoHandlerError.$(H): NoHandlerError.st $(STCHDR)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)NonPositionableExternalStream.$(O) NonPositionableExternalStream.$(H): NonPositionableExternalStream.st $(STCHDR)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)Notification.$(O) Notification.$(H): Notification.st $(STCHDR)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)Number.$(O) Number.$(H): Number.st $(STCHDR)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)OSFileHandle.$(O) OSFileHandle.$(H): OSFileHandle.st $(STCHDR)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)OSHandle.$(O) OSHandle.$(H): OSHandle.st $(STCHDR)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)Object.$(O) Object.$(H): Object.st $(STCHDR) 
$(OUTDIR)ObjectMemory.$(O) ObjectMemory.$(H): ObjectMemory.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)OpenVMSFileHandle.$(O) OpenVMSFileHandle.$(H): OpenVMSFileHandle.st $(STCHDR)  ../include/OSFileHandle.$(H)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)OpenVMSFilename.$(O) OpenVMSFilename.$(H): OpenVMSFilename.st $(STCHDR)  ../include/Filename.$(H)  ../include/Object.$(H) 
$(OUTDIR)OpenVMSOperatingSystem.$(O) OpenVMSOperatingSystem.$(H): OpenVMSOperatingSystem.st $(STCHDR)  ../include/AbstractOperatingSystem.$(H)  ../include/Object.$(H) 
$(OUTDIR)OrderedCollection.$(O) OrderedCollection.$(H): OrderedCollection.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)PCFilename.$(O) PCFilename.$(H): PCFilename.st $(STCHDR)  ../include/Filename.$(H)  ../include/Object.$(H) 
$(OUTDIR)PeekableStream.$(O) PeekableStream.$(H): PeekableStream.st $(STCHDR)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)PipeStream.$(O) PipeStream.$(H): PipeStream.st $(STCHDR)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)Point.$(O) Point.$(H): Point.st $(STCHDR)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)PositionableStream.$(O) PositionableStream.$(H): PositionableStream.st $(STCHDR)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)PrivateMetaclass.$(O) PrivateMetaclass.$(H): PrivateMetaclass.st $(STCHDR)  ../include/Metaclass.$(H)  ../include/ClassDescription.$(H)  ../include/Behavior.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProceedError.$(O) ProceedError.$(H): ProceedError.st $(STCHDR)  ../include/Warning.$(H)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProceedableError.$(O) ProceedableError.$(H): ProceedableError.st $(STCHDR)  ../include/Error.$(H)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)Process.$(O) Process.$(H): Process.st $(STCHDR)  ../include/Link.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProcessorScheduler.$(O) ProcessorScheduler.$(H): ProcessorScheduler.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Project.$(O) Project.$(H): Project.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)QuerySignal.$(O) QuerySignal.$(H): QuerySignal.st $(STCHDR)  ../include/Signal.$(H)  ../include/Object.$(H) 
$(OUTDIR)ReadStream.$(O) ReadStream.$(H): ReadStream.st $(STCHDR)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)ReadWriteStream.$(O) ReadWriteStream.$(H): ReadWriteStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)Rectangle.$(O) Rectangle.$(H): Rectangle.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H) 
$(OUTDIR)RecursiveExceptionError.$(O) RecursiveExceptionError.$(H): RecursiveExceptionError.st $(STCHDR)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)Registry.$(O) Registry.$(H): Registry.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Semaphore.$(O) Semaphore.$(H): Semaphore.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SemaphoreSet.$(O) SemaphoreSet.$(H): SemaphoreSet.st $(STCHDR)  ../include/IdentitySet.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)SequenceableCollection.$(O) SequenceableCollection.$(H): SequenceableCollection.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Set.$(O) Set.$(H): Set.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ShortFloat.$(O) ShortFloat.$(H): ShortFloat.st $(STCHDR)  ../include/LimitedPrecisionReal.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Signal.$(O) Signal.$(H): Signal.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SignalError.$(O) SignalError.$(H): SignalError.st $(STCHDR)  ../include/ProceedableError.$(H)  ../include/Error.$(H)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)SignalSet.$(O) SignalSet.$(H): SignalSet.st $(STCHDR)  ../include/IdentitySet.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)SmallInteger.$(O) SmallInteger.$(H): SmallInteger.st $(STCHDR)  ../include/Integer.$(H)  ../include/Number.$(H)  ../include/ArithmeticValue.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)Smalltalk.$(O) Smalltalk.$(H): Smalltalk.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SortedCollection.$(O) SortedCollection.$(H): SortedCollection.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Stream.$(O) Stream.$(H): Stream.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)String.$(O) String.$(H): String.st $(STCHDR)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Symbol.$(O) Symbol.$(H): Symbol.st $(STCHDR)  ../include/String.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)TextCollectorStream.$(O) TextCollectorStream.$(H): TextCollectorStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)Time.$(O) Time.$(H): Time.st $(STCHDR)  ../include/AbstractTime.$(H)  ../include/Magnitude.$(H)  ../include/Object.$(H) 
$(OUTDIR)True.$(O) True.$(H): True.st $(STCHDR)  ../include/Boolean.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnboundedExternalStream.$(O) UnboundedExternalStream.$(H): UnboundedExternalStream.st $(STCHDR)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)UndefinedObject.$(O) UndefinedObject.$(H): UndefinedObject.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)UninterpretedBytes.$(O) UninterpretedBytes.$(H): UninterpretedBytes.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnixFileDescriptorHandle.$(O) UnixFileDescriptorHandle.$(H): UnixFileDescriptorHandle.st $(STCHDR)  ../include/OSFileHandle.$(H)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnixFileHandle.$(O) UnixFileHandle.$(H): UnixFileHandle.st $(STCHDR)  ../include/OSFileHandle.$(H)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnixFilename.$(O) UnixFilename.$(H): UnixFilename.st $(STCHDR)  ../include/Filename.$(H)  ../include/Object.$(H) 
$(OUTDIR)UnixOperatingSystem.$(O) UnixOperatingSystem.$(H): UnixOperatingSystem.st $(STCHDR)  ../include/AbstractOperatingSystem.$(H)  ../include/Object.$(H) 
$(OUTDIR)UserNotification.$(O) UserNotification.$(H): UserNotification.st $(STCHDR)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)UserPreferences.$(O) UserPreferences.$(H): UserPreferences.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)VarArgBlock.$(O) VarArgBlock.$(H): VarArgBlock.st $(STCHDR)  ../include/Block.$(H)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)VarArgCheapBlock.$(O) VarArgCheapBlock.$(H): VarArgCheapBlock.st $(STCHDR)  ../include/CheapBlock.$(H)  ../include/Block.$(H)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
$(OUTDIR)Warning.$(O) Warning.$(H): Warning.st $(STCHDR)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakArray.$(O) WeakArray.$(H): WeakArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakDependencyDictionary.$(O) WeakDependencyDictionary.$(H): WeakDependencyDictionary.st $(STCHDR)  ../include/WeakIdentityDictionary.$(H)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakIdentityDictionary.$(O) WeakIdentityDictionary.$(H): WeakIdentityDictionary.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakIdentitySet.$(O) WeakIdentitySet.$(H): WeakIdentitySet.st $(STCHDR)  ../include/IdentitySet.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakInterestConverter.$(O) WeakInterestConverter.$(H): WeakInterestConverter.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WeakValueDictionary.$(O) WeakValueDictionary.$(H): WeakValueDictionary.st $(STCHDR)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)WeakValueIdentityDictionary.$(O) WeakValueIdentityDictionary.$(H): WeakValueIdentityDictionary.st $(STCHDR)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)Win32FileHandle.$(O) Win32FileHandle.$(H): Win32FileHandle.st $(STCHDR)  ../include/OSFileHandle.$(H)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)Win32Handle.$(O) Win32Handle.$(H): Win32Handle.st $(STCHDR)  ../include/OSFileHandle.$(H)  ../include/OSHandle.$(H)  ../include/ExternalAddress.$(H)  ../include/Object.$(H) 
$(OUTDIR)Win32OperatingSystem.$(O) Win32OperatingSystem.$(H): Win32OperatingSystem.st $(STCHDR)  ../include/AbstractOperatingSystem.$(H)  ../include/Object.$(H) 
$(OUTDIR)Win32Process.$(O) Win32Process.$(H): Win32Process.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WriteStream.$(O) WriteStream.$(H): WriteStream.st $(STCHDR)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)WrongProceedabilityError.$(O) WrongProceedabilityError.$(H): WrongProceedabilityError.st $(STCHDR)  ../include/SignalError.$(H)  ../include/ProceedableError.$(H)  ../include/Error.$(H)  ../include/Exception.$(H)  ../include/GenericException.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND







