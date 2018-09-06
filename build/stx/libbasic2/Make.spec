# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libbasic2.
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
MODULE_DIR=libbasic2
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
STCLOCALOPTIMIZATIONS=+optinline +optinline2 +inlinenew


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
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	AVLTree \
	AbstractBackgroundJob \
	ActiveObject \
	ActorStream \
	Archiver \
	AutoResizingOrderedCollection \
	BIG5EncodedString \
	BTree \
	BaseNCoder \
	Bezier \
	BinaryTree \
	BinaryTreeNode \
	BoltLock \
	CRC32Stream \
	CacheDictionary \
	CachedValue \
	CharacterSet \
	Circle \
	CollectingReadStream \
	CollectingSharedQueueStream \
	CompressionStream \
	Cons \
	ConsStream \
	Curve \
	DirectoryContents \
	DoubleLink \
	EllipticalArc \
	ExternalLong \
	FileSorter \
	FileText \
	FilteringStream \
	FourByteString \
	Future \
	GBEncodedString \
	GeometricSeries \
	HTMLUtilities \
	HalfFloatArray \
	HandlerCollection \
	Heap \
	IdentityBag \
	IncrementNotification \
	InterestConverterWithParameters \
	InternalPipeStream \
	Iterator \
	JISEncodedString \
	KSCEncodedString \
	KeywordInContextIndexBuilder \
	Lazy \
	LazyArray \
	LazyValue \
	LineSegment \
	List \
	LoggingStream \
	MacPlistBinaryDecoder \
	MappedCollection \
	MessageChannel \
	Monitor \
	MultiReadStream \
	NameLookupError \
	NumberSet \
	OperationQueue \
	PhoneticStringUtilities \
	PluggableDictionary \
	PluggableSet \
	Polygon \
	PowerSet \
	PrinterStream \
	PrintfScanf \
	PriorityQueue \
	Promise \
	Queue \
	Random \
	RandomBlumBlumShub \
	RandomKISS \
	RandomKISS2 \
	RandomMT19937 \
	RandomParkMiller \
	RandomRDRand \
	RandomTT800 \
	ReindexedCollection \
	RunArray \
	SegmentedOrderedCollection \
	SelectingReadStream \
	SequenceWithSentinel \
	SequenceableCollectionSorter \
	SerialPort \
	SharedCollection \
	Singleton \
	SmallBag \
	Socket \
	SocketAddress \
	SocketAddressInfo \
	SortedSet \
	SoundStream \
	Spline \
	SplittingWriteStream \
	Stack \
	StringPattern \
	StringUtilities \
	TSTree \
	TSTreeNode \
	TerminalSession \
	Text \
	TextClassifier \
	TextStream \
	TreeSet \
	Trie \
	URI \
	UUID \
	UndoSupport \
	UnitConverter \
	UnixPTYStream \
	ValueLink \
	VirtualArray \
	ZipArchiveConstants \
	stx_libbasic2 \
	AATree \
	AATreeNode \
	AppletalkSocketAddress \
	Arrow \
	ArrowedSpline \
	AutoResizingOrderedCollectionWithDefault \
	BZip2Stream \
	BackgroundJob \
	BackgroundPeriodicalJob \
	BackgroundQueueProcessingJob \
	Base32Coder \
	Base64Coder \
	BayesClassifier \
	Bezier2Segment \
	CacheDictionaryWithFactory \
	DecNetSocketAddress \
	EpsonFX1PrinterStream \
	FilteringLineStream \
	HPLjetIIPrinterStream \
	HTMLPrinterStream \
	HierarchicalURI \
	HostAddressLookupError \
	HostNameLookupError \
	IPSocketAddress \
	LazyCons \
	LineNumberReadStream \
	PostscriptPrinterStream \
	RandomGenerator \
	SharedQueue \
	TSMultiTree \
	TSMultiTreeNode \
	TimedPromise \
	UDSocketAddress \
	Unicode32String \
	ValueDoubleLink \
	ZipArchive \
	ZipStream \
	FileURI \
	FtpURI \
	HttpURI \
	IPv6SocketAddress \
	SftpURI \
	UnlimitedSharedQueue \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AVLTree.$(O) \
    $(OUTDIR_SLASH)AbstractBackgroundJob.$(O) \
    $(OUTDIR_SLASH)ActiveObject.$(O) \
    $(OUTDIR_SLASH)ActorStream.$(O) \
    $(OUTDIR_SLASH)Archiver.$(O) \
    $(OUTDIR_SLASH)AutoResizingOrderedCollection.$(O) \
    $(OUTDIR_SLASH)BIG5EncodedString.$(O) \
    $(OUTDIR_SLASH)BTree.$(O) \
    $(OUTDIR_SLASH)BaseNCoder.$(O) \
    $(OUTDIR_SLASH)Bezier.$(O) \
    $(OUTDIR_SLASH)BinaryTree.$(O) \
    $(OUTDIR_SLASH)BinaryTreeNode.$(O) \
    $(OUTDIR_SLASH)BoltLock.$(O) \
    $(OUTDIR_SLASH)CRC32Stream.$(O) \
    $(OUTDIR_SLASH)CacheDictionary.$(O) \
    $(OUTDIR_SLASH)CachedValue.$(O) \
    $(OUTDIR_SLASH)CharacterSet.$(O) \
    $(OUTDIR_SLASH)Circle.$(O) \
    $(OUTDIR_SLASH)CollectingReadStream.$(O) \
    $(OUTDIR_SLASH)CollectingSharedQueueStream.$(O) \
    $(OUTDIR_SLASH)CompressionStream.$(O) \
    $(OUTDIR_SLASH)Cons.$(O) \
    $(OUTDIR_SLASH)ConsStream.$(O) \
    $(OUTDIR_SLASH)Curve.$(O) \
    $(OUTDIR_SLASH)DirectoryContents.$(O) \
    $(OUTDIR_SLASH)DoubleLink.$(O) \
    $(OUTDIR_SLASH)EllipticalArc.$(O) \
    $(OUTDIR_SLASH)ExternalLong.$(O) \
    $(OUTDIR_SLASH)FileSorter.$(O) \
    $(OUTDIR_SLASH)FileText.$(O) \
    $(OUTDIR_SLASH)FilteringStream.$(O) \
    $(OUTDIR_SLASH)FourByteString.$(O) \
    $(OUTDIR_SLASH)Future.$(O) \
    $(OUTDIR_SLASH)GBEncodedString.$(O) \
    $(OUTDIR_SLASH)GeometricSeries.$(O) \
    $(OUTDIR_SLASH)HTMLUtilities.$(O) \
    $(OUTDIR_SLASH)HalfFloatArray.$(O) \
    $(OUTDIR_SLASH)HandlerCollection.$(O) \
    $(OUTDIR_SLASH)Heap.$(O) \
    $(OUTDIR_SLASH)IdentityBag.$(O) \
    $(OUTDIR_SLASH)IncrementNotification.$(O) \
    $(OUTDIR_SLASH)InterestConverterWithParameters.$(O) \
    $(OUTDIR_SLASH)InternalPipeStream.$(O) \
    $(OUTDIR_SLASH)Iterator.$(O) \
    $(OUTDIR_SLASH)JISEncodedString.$(O) \
    $(OUTDIR_SLASH)KSCEncodedString.$(O) \
    $(OUTDIR_SLASH)KeywordInContextIndexBuilder.$(O) \
    $(OUTDIR_SLASH)Lazy.$(O) \
    $(OUTDIR_SLASH)LazyArray.$(O) \
    $(OUTDIR_SLASH)LazyValue.$(O) \
    $(OUTDIR_SLASH)LineSegment.$(O) \
    $(OUTDIR_SLASH)List.$(O) \
    $(OUTDIR_SLASH)LoggingStream.$(O) \
    $(OUTDIR_SLASH)MacPlistBinaryDecoder.$(O) \
    $(OUTDIR_SLASH)MappedCollection.$(O) \
    $(OUTDIR_SLASH)MessageChannel.$(O) \
    $(OUTDIR_SLASH)Monitor.$(O) \
    $(OUTDIR_SLASH)MultiReadStream.$(O) \
    $(OUTDIR_SLASH)NameLookupError.$(O) \
    $(OUTDIR_SLASH)NumberSet.$(O) \
    $(OUTDIR_SLASH)OperationQueue.$(O) \
    $(OUTDIR_SLASH)PhoneticStringUtilities.$(O) \
    $(OUTDIR_SLASH)PluggableDictionary.$(O) \
    $(OUTDIR_SLASH)PluggableSet.$(O) \
    $(OUTDIR_SLASH)Polygon.$(O) \
    $(OUTDIR_SLASH)PowerSet.$(O) \
    $(OUTDIR_SLASH)PrinterStream.$(O) \
    $(OUTDIR_SLASH)PrintfScanf.$(O) \
    $(OUTDIR_SLASH)PriorityQueue.$(O) \
    $(OUTDIR_SLASH)Promise.$(O) \
    $(OUTDIR_SLASH)Queue.$(O) \
    $(OUTDIR_SLASH)Random.$(O) \
    $(OUTDIR_SLASH)RandomBlumBlumShub.$(O) \
    $(OUTDIR_SLASH)RandomKISS.$(O) \
    $(OUTDIR_SLASH)RandomKISS2.$(O) \
    $(OUTDIR_SLASH)RandomMT19937.$(O) \
    $(OUTDIR_SLASH)RandomParkMiller.$(O) \
    $(OUTDIR_SLASH)RandomRDRand.$(O) \
    $(OUTDIR_SLASH)RandomTT800.$(O) \
    $(OUTDIR_SLASH)ReindexedCollection.$(O) \
    $(OUTDIR_SLASH)RunArray.$(O) \
    $(OUTDIR_SLASH)SegmentedOrderedCollection.$(O) \
    $(OUTDIR_SLASH)SelectingReadStream.$(O) \
    $(OUTDIR_SLASH)SequenceWithSentinel.$(O) \
    $(OUTDIR_SLASH)SequenceableCollectionSorter.$(O) \
    $(OUTDIR_SLASH)SerialPort.$(O) \
    $(OUTDIR_SLASH)SharedCollection.$(O) \
    $(OUTDIR_SLASH)Singleton.$(O) \
    $(OUTDIR_SLASH)SmallBag.$(O) \
    $(OUTDIR_SLASH)Socket.$(O) \
    $(OUTDIR_SLASH)SocketAddress.$(O) \
    $(OUTDIR_SLASH)SocketAddressInfo.$(O) \
    $(OUTDIR_SLASH)SortedSet.$(O) \
    $(OUTDIR_SLASH)SoundStream.$(O) \
    $(OUTDIR_SLASH)Spline.$(O) \
    $(OUTDIR_SLASH)SplittingWriteStream.$(O) \
    $(OUTDIR_SLASH)Stack.$(O) \
    $(OUTDIR_SLASH)StringPattern.$(O) \
    $(OUTDIR_SLASH)StringUtilities.$(O) \
    $(OUTDIR_SLASH)TSTree.$(O) \
    $(OUTDIR_SLASH)TSTreeNode.$(O) \
    $(OUTDIR_SLASH)TerminalSession.$(O) \
    $(OUTDIR_SLASH)Text.$(O) \
    $(OUTDIR_SLASH)TextClassifier.$(O) \
    $(OUTDIR_SLASH)TextStream.$(O) \
    $(OUTDIR_SLASH)TreeSet.$(O) \
    $(OUTDIR_SLASH)Trie.$(O) \
    $(OUTDIR_SLASH)URI.$(O) \
    $(OUTDIR_SLASH)UUID.$(O) \
    $(OUTDIR_SLASH)UndoSupport.$(O) \
    $(OUTDIR_SLASH)UnitConverter.$(O) \
    $(OUTDIR_SLASH)UnixPTYStream.$(O) \
    $(OUTDIR_SLASH)ValueLink.$(O) \
    $(OUTDIR_SLASH)VirtualArray.$(O) \
    $(OUTDIR_SLASH)ZipArchiveConstants.$(O) \
    $(OUTDIR_SLASH)stx_libbasic2.$(O) \
    $(OUTDIR_SLASH)AATree.$(O) \
    $(OUTDIR_SLASH)AATreeNode.$(O) \
    $(OUTDIR_SLASH)AppletalkSocketAddress.$(O) \
    $(OUTDIR_SLASH)Arrow.$(O) \
    $(OUTDIR_SLASH)ArrowedSpline.$(O) \
    $(OUTDIR_SLASH)AutoResizingOrderedCollectionWithDefault.$(O) \
    $(OUTDIR_SLASH)BZip2Stream.$(O) \
    $(OUTDIR_SLASH)BackgroundJob.$(O) \
    $(OUTDIR_SLASH)BackgroundPeriodicalJob.$(O) \
    $(OUTDIR_SLASH)BackgroundQueueProcessingJob.$(O) \
    $(OUTDIR_SLASH)Base32Coder.$(O) \
    $(OUTDIR_SLASH)Base64Coder.$(O) \
    $(OUTDIR_SLASH)BayesClassifier.$(O) \
    $(OUTDIR_SLASH)Bezier2Segment.$(O) \
    $(OUTDIR_SLASH)CacheDictionaryWithFactory.$(O) \
    $(OUTDIR_SLASH)DecNetSocketAddress.$(O) \
    $(OUTDIR_SLASH)EpsonFX1PrinterStream.$(O) \
    $(OUTDIR_SLASH)FilteringLineStream.$(O) \
    $(OUTDIR_SLASH)HPLjetIIPrinterStream.$(O) \
    $(OUTDIR_SLASH)HTMLPrinterStream.$(O) \
    $(OUTDIR_SLASH)HierarchicalURI.$(O) \
    $(OUTDIR_SLASH)HostAddressLookupError.$(O) \
    $(OUTDIR_SLASH)HostNameLookupError.$(O) \
    $(OUTDIR_SLASH)IPSocketAddress.$(O) \
    $(OUTDIR_SLASH)LazyCons.$(O) \
    $(OUTDIR_SLASH)LineNumberReadStream.$(O) \
    $(OUTDIR_SLASH)PostscriptPrinterStream.$(O) \
    $(OUTDIR_SLASH)RandomGenerator.$(O) \
    $(OUTDIR_SLASH)SharedQueue.$(O) \
    $(OUTDIR_SLASH)TSMultiTree.$(O) \
    $(OUTDIR_SLASH)TSMultiTreeNode.$(O) \
    $(OUTDIR_SLASH)TimedPromise.$(O) \
    $(OUTDIR_SLASH)UDSocketAddress.$(O) \
    $(OUTDIR_SLASH)Unicode32String.$(O) \
    $(OUTDIR_SLASH)ValueDoubleLink.$(O) \
    $(OUTDIR_SLASH)ZipArchive.$(O) \
    $(OUTDIR_SLASH)ZipStream.$(O) \
    $(OUTDIR_SLASH)FileURI.$(O) \
    $(OUTDIR_SLASH)FtpURI.$(O) \
    $(OUTDIR_SLASH)HttpURI.$(O) \
    $(OUTDIR_SLASH)IPv6SocketAddress.$(O) \
    $(OUTDIR_SLASH)SftpURI.$(O) \
    $(OUTDIR_SLASH)UnlimitedSharedQueue.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



