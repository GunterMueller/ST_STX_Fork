# $Header: /cvs/stx/stx/libcompat/Make.spec,v 1.56 2018-08-26 19:44:40 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libcompat.
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
MODULE_DIR=libcompat
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
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	ActionButton \
	ActionButtonView \
	ActionMenu \
	Alien \
	Author \
	BinaryStream \
	BindingReference \
	BorderDecorator \
	CEnvironment \
	CachedImage \
	CharacterAttributes \
	CharacterBlockScanner \
	CodeController \
	ColorForm \
	ColorPreferencesCollection \
	ComposedText \
	ComposedTextView \
	CompositeView \
	CompositionScanner \
	CoveragePalette \
	CustomHelp \
	DialogCompositeController \
	DisplayScanner \
	Dolphin::ClassCategoriesReader \
	Dolphin::DeafObject \
	Dolphin::Error \
	Dolphin::File \
	Dolphin::FileDialog \
	Dolphin::IXMLDOMDocument \
	Dolphin::IXMLDOMNamedNodeMap \
	Dolphin::ListPrompter \
	Dolphin::LookupTable \
	Dolphin::MessageBox \
	Dolphin::MethodCategoriesReader \
	Dolphin::Mutex \
	Dolphin::Notification \
	Dolphin::PluggableLookupTable \
	Dolphin::Prompter \
	Dolphin::SWEnvironment \
	Dolphin::SearchPolicy \
	Dolphin::SessionManager \
	Dolphin::SharedLookupTable \
	Dolphin::SharedSet \
	Dolphin::Shell \
	DragDropManager \
	DragDropManagerTracker \
	ErrorDiffusion \
	ExternalReadStream \
	ExternalWriteStream \
	FileDirectory \
	FractionalWidgetView \
	GapString \
	IOAccessor \
	ISO8859L1String \
	InputState \
	InstructionClient \
	InstructionStream \
	LabeledBooleanView \
	ListItemWrapper \
	MczInstaller \
	MemoryPolicy \
	MenuBuilder \
	MinimalShellInterface \
	MockMedium \
	MouseMenuController \
	MultiSelectionSequenceView \
	NameSpaceOrganizer \
	NetNameResolver \
	NonInteractiveCompilerErrorHandler \
	OpaqueImage \
	OrderedDither \
	PackageInfo \
	ParagraphEditor \
	PassivityWrapper \
	Pixmap \
	PluggableListView \
	PluggableTextView \
	Polyline \
	Preferences \
	ProtocolClient \
	ProvideAnswerNotification \
	RWBinaryOrTextStream \
	RasterOp \
	ReadMe::ST80_ReadMe \
	ScannerTable \
	ScheduledControllers \
	ScrollValueHolder \
	ScrollWrapper \
	SelectionInListController \
	SelectionMenu \
	SelectionTracker \
	SmartRefStream \
	SourceCodeStream \
	Squeak::ClassCommentReader \
	Squeak::TextAnchor \
	Squeak::TextColor \
	Squeak::TextEmphasis \
	Squeak::TextFontChange \
	Squeak::TextURL \
	StrikeFont \
	StringCollationPolicy \
	StringHolder \
	SystemDictionary \
	SystemOrganization \
	SystemUtils \
	SystemVersion \
	SystemWindow \
	TTFontDescription \
	TextAttributes \
	TextController \
	TextLines \
	TextList \
	TextStyle \
	TimeProfileBrowser \
	TriggerButtonController \
	TwoByteSymbol \
	UILookPolicy \
	UIManager \
	UISettings \
	UnixProcess \
	Utilities \
	V::ApplicationCoordinator \
	V::Dynalink32 \
	V::File \
	V::GDIDLL \
	V::GraphPane \
	V::MainWindow \
	V::OLEControlSitePane \
	V::OLEStructure \
	V::ViewManager \
	VAST::CwDataInterchangeConverter \
	VAST::CwGlobalMemoryTransferMechanism \
	VAST::CwMainWindow \
	VAST::CwPrimitive \
	VAST::CwTransferMechanism \
	VAST::CwWidget \
	VAST::ExError \
	VAST::LookupTable \
	VAST::OSComposite \
	VAST::OSDialogBox \
	VAST::SubApplication \
	VAST::System \
	VAST::VastSignal \
	VW5PackageExporter \
	WidgetWrapper \
	Win32Shell \
	stx_libcompat \
	DataStream \
	Dolphin::FileOpenDialog \
	Dolphin::FileSaveDialog \
	Dolphin::SharedIdentitySet \
	LookPreferences \
	MacLookPolicy \
	V::DynalinkUnderTest \
	VAST::Application \
	Win3LookPolicy \
	ReferenceStream \
	VAST::Kernel \




COMMON_OBJS= \
    $(OUTDIR)ActionButton.$(O) \
    $(OUTDIR)ActionButtonView.$(O) \
    $(OUTDIR)ActionMenu.$(O) \
    $(OUTDIR)Alien.$(O) \
    $(OUTDIR)Author.$(O) \
    $(OUTDIR)BinaryStream.$(O) \
    $(OUTDIR)BindingReference.$(O) \
    $(OUTDIR)BorderDecorator.$(O) \
    $(OUTDIR)CEnvironment.$(O) \
    $(OUTDIR)CachedImage.$(O) \
    $(OUTDIR)CharacterAttributes.$(O) \
    $(OUTDIR)CharacterBlockScanner.$(O) \
    $(OUTDIR)CodeController.$(O) \
    $(OUTDIR)ColorForm.$(O) \
    $(OUTDIR)ColorPreferencesCollection.$(O) \
    $(OUTDIR)ComposedText.$(O) \
    $(OUTDIR)ComposedTextView.$(O) \
    $(OUTDIR)CompositeView.$(O) \
    $(OUTDIR)CompositionScanner.$(O) \
    $(OUTDIR)CoveragePalette.$(O) \
    $(OUTDIR)CustomHelp.$(O) \
    $(OUTDIR)DialogCompositeController.$(O) \
    $(OUTDIR)DisplayScanner.$(O) \
    $(OUTDIR)Dolphin__ClassCategoriesReader.$(O) \
    $(OUTDIR)Dolphin__DeafObject.$(O) \
    $(OUTDIR)Dolphin__Error.$(O) \
    $(OUTDIR)Dolphin__File.$(O) \
    $(OUTDIR)Dolphin__FileDialog.$(O) \
    $(OUTDIR)Dolphin__IXMLDOMDocument.$(O) \
    $(OUTDIR)Dolphin__IXMLDOMNamedNodeMap.$(O) \
    $(OUTDIR)Dolphin__ListPrompter.$(O) \
    $(OUTDIR)Dolphin__LookupTable.$(O) \
    $(OUTDIR)Dolphin__MessageBox.$(O) \
    $(OUTDIR)Dolphin__MethodCategoriesReader.$(O) \
    $(OUTDIR)Dolphin__Mutex.$(O) \
    $(OUTDIR)Dolphin__Notification.$(O) \
    $(OUTDIR)Dolphin__PluggableLookupTable.$(O) \
    $(OUTDIR)Dolphin__Prompter.$(O) \
    $(OUTDIR)Dolphin__SWEnvironment.$(O) \
    $(OUTDIR)Dolphin__SearchPolicy.$(O) \
    $(OUTDIR)Dolphin__SessionManager.$(O) \
    $(OUTDIR)Dolphin__SharedLookupTable.$(O) \
    $(OUTDIR)Dolphin__SharedSet.$(O) \
    $(OUTDIR)Dolphin__Shell.$(O) \
    $(OUTDIR)DragDropManager.$(O) \
    $(OUTDIR)DragDropManagerTracker.$(O) \
    $(OUTDIR)ErrorDiffusion.$(O) \
    $(OUTDIR)ExternalReadStream.$(O) \
    $(OUTDIR)ExternalWriteStream.$(O) \
    $(OUTDIR)FileDirectory.$(O) \
    $(OUTDIR)FractionalWidgetView.$(O) \
    $(OUTDIR)GapString.$(O) \
    $(OUTDIR)IOAccessor.$(O) \
    $(OUTDIR)ISO8859L1String.$(O) \
    $(OUTDIR)InputState.$(O) \
    $(OUTDIR)InstructionClient.$(O) \
    $(OUTDIR)InstructionStream.$(O) \
    $(OUTDIR)LabeledBooleanView.$(O) \
    $(OUTDIR)ListItemWrapper.$(O) \
    $(OUTDIR)MczInstaller.$(O) \
    $(OUTDIR)MemoryPolicy.$(O) \
    $(OUTDIR)MenuBuilder.$(O) \
    $(OUTDIR)MinimalShellInterface.$(O) \
    $(OUTDIR)MockMedium.$(O) \
    $(OUTDIR)MouseMenuController.$(O) \
    $(OUTDIR)MultiSelectionSequenceView.$(O) \
    $(OUTDIR)NameSpaceOrganizer.$(O) \
    $(OUTDIR)NetNameResolver.$(O) \
    $(OUTDIR)NonInteractiveCompilerErrorHandler.$(O) \
    $(OUTDIR)OpaqueImage.$(O) \
    $(OUTDIR)OrderedDither.$(O) \
    $(OUTDIR)PackageInfo.$(O) \
    $(OUTDIR)ParagraphEditor.$(O) \
    $(OUTDIR)PassivityWrapper.$(O) \
    $(OUTDIR)Pixmap.$(O) \
    $(OUTDIR)PluggableListView.$(O) \
    $(OUTDIR)PluggableTextView.$(O) \
    $(OUTDIR)Polyline.$(O) \
    $(OUTDIR)Preferences.$(O) \
    $(OUTDIR)ProtocolClient.$(O) \
    $(OUTDIR)ProvideAnswerNotification.$(O) \
    $(OUTDIR)RWBinaryOrTextStream.$(O) \
    $(OUTDIR)RasterOp.$(O) \
    $(OUTDIR)ReadMe__ST80_ReadMe.$(O) \
    $(OUTDIR)ScannerTable.$(O) \
    $(OUTDIR)ScheduledControllers.$(O) \
    $(OUTDIR)ScrollValueHolder.$(O) \
    $(OUTDIR)ScrollWrapper.$(O) \
    $(OUTDIR)SelectionInListController.$(O) \
    $(OUTDIR)SelectionMenu.$(O) \
    $(OUTDIR)SelectionTracker.$(O) \
    $(OUTDIR)SmartRefStream.$(O) \
    $(OUTDIR)SourceCodeStream.$(O) \
    $(OUTDIR)Squeak__ClassCommentReader.$(O) \
    $(OUTDIR)Squeak__TextAnchor.$(O) \
    $(OUTDIR)Squeak__TextColor.$(O) \
    $(OUTDIR)Squeak__TextEmphasis.$(O) \
    $(OUTDIR)Squeak__TextFontChange.$(O) \
    $(OUTDIR)Squeak__TextURL.$(O) \
    $(OUTDIR)StrikeFont.$(O) \
    $(OUTDIR)StringCollationPolicy.$(O) \
    $(OUTDIR)StringHolder.$(O) \
    $(OUTDIR)SystemDictionary.$(O) \
    $(OUTDIR)SystemOrganization.$(O) \
    $(OUTDIR)SystemUtils.$(O) \
    $(OUTDIR)SystemVersion.$(O) \
    $(OUTDIR)SystemWindow.$(O) \
    $(OUTDIR)TTFontDescription.$(O) \
    $(OUTDIR)TextAttributes.$(O) \
    $(OUTDIR)TextController.$(O) \
    $(OUTDIR)TextLines.$(O) \
    $(OUTDIR)TextList.$(O) \
    $(OUTDIR)TextStyle.$(O) \
    $(OUTDIR)TimeProfileBrowser.$(O) \
    $(OUTDIR)TriggerButtonController.$(O) \
    $(OUTDIR)TwoByteSymbol.$(O) \
    $(OUTDIR)UILookPolicy.$(O) \
    $(OUTDIR)UIManager.$(O) \
    $(OUTDIR)UISettings.$(O) \
    $(OUTDIR)UnixProcess.$(O) \
    $(OUTDIR)Utilities.$(O) \
    $(OUTDIR)V__ApplicationCoordinator.$(O) \
    $(OUTDIR)V__Dynalink32.$(O) \
    $(OUTDIR)V__File.$(O) \
    $(OUTDIR)V__GDIDLL.$(O) \
    $(OUTDIR)V__GraphPane.$(O) \
    $(OUTDIR)V__MainWindow.$(O) \
    $(OUTDIR)V__OLEControlSitePane.$(O) \
    $(OUTDIR)V__OLEStructure.$(O) \
    $(OUTDIR)V__ViewManager.$(O) \
    $(OUTDIR)CwDataInterchangeConverter.$(O) \
    $(OUTDIR)CwGlobalMemoryTransferMechanism.$(O) \
    $(OUTDIR)CwMainWindow.$(O) \
    $(OUTDIR)CwPrimitive.$(O) \
    $(OUTDIR)CwTransferMechanism.$(O) \
    $(OUTDIR)CwWidget.$(O) \
    $(OUTDIR)VAST__ExError.$(O) \
    $(OUTDIR)LookupTable.$(O) \
    $(OUTDIR)OSComposite.$(O) \
    $(OUTDIR)OSDialogBox.$(O) \
    $(OUTDIR)SubApplication.$(O) \
    $(OUTDIR)VAST__System.$(O) \
    $(OUTDIR)VAST__VastSignal.$(O) \
    $(OUTDIR)VW5PackageExporter.$(O) \
    $(OUTDIR)WidgetWrapper.$(O) \
    $(OUTDIR)Win32Shell.$(O) \
    $(OUTDIR)stx_libcompat.$(O) \
    $(OUTDIR)DataStream.$(O) \
    $(OUTDIR)Dolphin__FileOpenDialog.$(O) \
    $(OUTDIR)Dolphin__FileSaveDialog.$(O) \
    $(OUTDIR)Dolphin__SharedIdentitySet.$(O) \
    $(OUTDIR)LookPreferences.$(O) \
    $(OUTDIR)MacLookPolicy.$(O) \
    $(OUTDIR)V__DynalinkUnderTest.$(O) \
    $(OUTDIR)Application.$(O) \
    $(OUTDIR)Win3LookPolicy.$(O) \
    $(OUTDIR)ReferenceStream.$(O) \
    $(OUTDIR)Kernel.$(O) \
    $(OUTDIR)extensions.$(O) \



