#
# DO NOT EDIT
# automatically generated from Make.proto
#
# $Header$
#
TOP=..
LIBNAME=libbasic2
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)MappedCollection.$(O) \
  $(OUTDIR)TwoByteString.$(O) \
  $(OUTDIR)JISEncodedString.$(O) \
  $(OUTDIR)Polygon.$(O) \
  $(OUTDIR)StringCollection.$(O) \
  $(OUTDIR)RecursionLock.$(O) \
  $(OUTDIR)List.$(O) \
  $(OUTDIR)Queue.$(O) \
  $(OUTDIR)SharedQueue.$(O) \
  $(OUTDIR)CacheDictionary.$(O) \
  $(OUTDIR)RunArray.$(O) \
  $(OUTDIR)Text.$(O) \
  $(OUTDIR)MessageSend.$(O) \
  $(OUTDIR)Socket.$(O) \
  $(OUTDIR)ActorStream.$(O) \
  $(OUTDIR)SoundStream.$(O) \
  $(OUTDIR)PrinterStream.$(O) \
  $(OUTDIR)PostscriptPrinterStream.$(O) \
  $(OUTDIR)TextStream.$(O) \
  $(OUTDIR)UnitConverter.$(O) \
  $(OUTDIR)Random.$(O) \
  $(OUTDIR)WordArray.$(O) \
  $(OUTDIR)SignedWordArray.$(O) \
  $(OUTDIR)IntegerArray.$(O) \
  $(OUTDIR)SignedIntegerArray.$(O) \
  $(OUTDIR)LongIntegerArray.$(O) \
  $(OUTDIR)SignedLongIntegerArray.$(O) \
  $(OUTDIR)ZipArchive.$(O) \
  $(OUTDIR)DirectoryContents.$(O) \
  $(OUTDIR)CachingRegistry.$(O) \


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
$(OUTDIR)ActorStream.$(O) ActorStream.$(H): ActorStream.st $(STCHDR)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)Arrow.$(O) Arrow.$(H): Arrow.st $(STCHDR)
$(OUTDIR)ArrowedSpline.$(O) ArrowedSpline.$(H): ArrowedSpline.st $(STCHDR)
$(OUTDIR)BIG5EncodedString.$(O) BIG5EncodedString.$(H): BIG5EncodedString.st $(STCHDR)  ../include/TwoByteString.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)Bezier.$(O) Bezier.$(H): Bezier.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)Bezier2Segment.$(O) Bezier2Segment.$(H): Bezier2Segment.st $(STCHDR)
$(OUTDIR)BitArray.$(O) BitArray.$(H): BitArray.st $(STCHDR)
$(OUTDIR)BooleanArray.$(O) BooleanArray.$(H): BooleanArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)CacheDictionary.$(O) CacheDictionary.$(H): CacheDictionary.st $(STCHDR)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)CachingRegistry.$(O) CachingRegistry.$(H): CachingRegistry.st $(STCHDR)  ../include/Registry.$(H)  ../include/Object.$(H)
$(OUTDIR)Circle.$(O) Circle.$(H): Circle.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)CollectingSharedQueueStream.$(O) CollectingSharedQueueStream.$(H): CollectingSharedQueueStream.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)Curve.$(O) Curve.$(H): Curve.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)DirectoryContents.$(O) DirectoryContents.$(H): DirectoryContents.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)EllipticalArc.$(O) EllipticalArc.$(H): EllipticalArc.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)EpsonFX1PrinterStream.$(O) EpsonFX1PrinterStream.$(H): EpsonFX1PrinterStream.st $(STCHDR)  ../include/PrinterStream.$(H)  ../include/PipeStream.$(H)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)ExternalLong.$(O) ExternalLong.$(H): ExternalLong.st $(STCHDR)  ../include/ExternalBytes.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)FileText.$(O) FileText.$(H): FileText.st $(STCHDR)  ../include/StringCollection.$(H)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)GBEncodedString.$(O) GBEncodedString.$(H): GBEncodedString.st $(STCHDR)  ../include/TwoByteString.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)HPLjetIIPrinterStream.$(O) HPLjetIIPrinterStream.$(H): HPLjetIIPrinterStream.st $(STCHDR)  ../include/PrinterStream.$(H)  ../include/PipeStream.$(H)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)HandlerCollection.$(O) HandlerCollection.$(H): HandlerCollection.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)IPSocketAddress.$(O) IPSocketAddress.$(H): IPSocketAddress.st $(STCHDR)
$(OUTDIR)IntegerArray.$(O) IntegerArray.$(H): IntegerArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)JISEncodedString.$(O) JISEncodedString.$(H): JISEncodedString.st $(STCHDR)  ../include/TwoByteString.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)KSCEncodedString.$(O) KSCEncodedString.$(H): KSCEncodedString.st $(STCHDR)  ../include/TwoByteString.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)KeyedCollection.$(O) KeyedCollection.$(H): KeyedCollection.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)LineSegment.$(O) LineSegment.$(H): LineSegment.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)List.$(O) List.$(H): List.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)LongIntegerArray.$(O) LongIntegerArray.$(H): LongIntegerArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)MappedCollection.$(O) MappedCollection.$(H): MappedCollection.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)MessageChannel.$(O) MessageChannel.$(H): MessageChannel.st $(STCHDR)  ../include/MessageSend.$(H)  ../include/Message.$(H)  ../include/Object.$(H)
$(OUTDIR)MessageSend.$(O) MessageSend.$(H): MessageSend.st $(STCHDR)  ../include/Message.$(H)  ../include/Object.$(H)
$(OUTDIR)Monitor.$(O) Monitor.$(H): Monitor.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)Polygon.$(O) Polygon.$(H): Polygon.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)PostscriptPrinterStream.$(O) PostscriptPrinterStream.$(H): PostscriptPrinterStream.st $(STCHDR)  ../include/PrinterStream.$(H)  ../include/PipeStream.$(H)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)PrinterStream.$(O) PrinterStream.$(H): PrinterStream.st $(STCHDR)  ../include/PipeStream.$(H)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)Promise.$(O) Promise.$(H): Promise.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)Queue.$(O) Queue.$(H): Queue.st $(STCHDR)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)Random.$(O) Random.$(H): Random.st $(STCHDR)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)RecursionLock.$(O) RecursionLock.$(H): RecursionLock.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)RunArray.$(O) RunArray.$(H): RunArray.st $(STCHDR)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)SequenceableCollectionSorter.$(O) SequenceableCollectionSorter.$(H): SequenceableCollectionSorter.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)SharedQueue.$(O) SharedQueue.$(H): SharedQueue.st $(STCHDR)  ../include/Queue.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)SignedIntegerArray.$(O) SignedIntegerArray.$(H): SignedIntegerArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)SignedLongIntegerArray.$(O) SignedLongIntegerArray.$(H): SignedLongIntegerArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)SignedWordArray.$(O) SignedWordArray.$(H): SignedWordArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)SocketAddress.$(O) SocketAddress.$(H): SocketAddress.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)Socket.$(O) Socket.$(H): Socket.st $(STCHDR)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)SoundStream.$(O) SoundStream.$(H): SoundStream.st $(STCHDR)  ../include/FileStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)Spline.$(O) Spline.$(H): Spline.st $(STCHDR)  ../include/Geometric.$(H)  ../include/Object.$(H)
$(OUTDIR)StringCollection.$(O) StringCollection.$(H): StringCollection.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)Text.$(O) Text.$(H): Text.st $(STCHDR)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)TextStream.$(O) TextStream.$(H): TextStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)TwoByteString.$(O) TwoByteString.$(H): TwoByteString.st $(STCHDR)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)UDSocketAddress.$(O) UDSocketAddress.$(H): UDSocketAddress.st $(STCHDR)
$(OUTDIR)UnicodeString.$(O) UnicodeString.$(H): UnicodeString.st $(STCHDR)  ../include/TwoByteString.$(H)  ../include/CharacterArray.$(H)  ../include/ByteArray.$(H)  ../include/UninterpretedBytes.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)UnitConverter.$(O) UnitConverter.$(H): UnitConverter.st $(STCHDR)  ../include/Object.$(H)
$(OUTDIR)UnixPTYStream.$(O) UnixPTYStream.$(H): UnixPTYStream.st $(STCHDR)  ../include/PipeStream.$(H)  ../include/NonPositionableExternalStream.$(H)  ../include/ExternalStream.$(H)  ../include/ReadWriteStream.$(H)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H)
$(OUTDIR)ValueLink.$(O) ValueLink.$(H): ValueLink.st $(STCHDR)  ../include/Link.$(H)  ../include/Object.$(H)
$(OUTDIR)VariableArray.$(O) VariableArray.$(H): VariableArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)VariableString.$(O) VariableString.$(H): VariableString.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)WordArray.$(O) WordArray.$(H): WordArray.st $(STCHDR)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H)
$(OUTDIR)ZipArchive.$(O) ZipArchive.$(H): ZipArchive.st $(STCHDR)  ../include/Object.$(H)
# ENDMAKEDEPEND
