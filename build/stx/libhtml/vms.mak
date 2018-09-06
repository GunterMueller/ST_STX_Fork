#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libhtml/vms.mak,v 1.3 2000-01-20 16:51:01 cg Exp $
#
TOP=..
LIBNAME=libhtml
STCOPT="+optspace2 -warnNonStandard +optPerform"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)URL.$(O) \
  $(OUTDIR)HTMLDocGenerator.$(O) \
  $(OUTDIR)HTMLParser.$(O) \
  $(OUTDIR)HTMLDocumentInterpreter.$(O) \
  $(OUTDIR)HTMLDocumentPainter.$(O) \
  $(OUTDIR)HTMLDocumentFrame.$(O) \
  $(OUTDIR)HTMLDocumentView.$(O) \
  $(OUTDIR)HTMLElement.$(O) \
  $(OUTDIR)HTMLMarkup.$(O) \
  $(OUTDIR)HTMLAnchor.$(O) \
  $(OUTDIR)HTMLBullet.$(O) \
  $(OUTDIR)HTMLWidget.$(O) \
  $(OUTDIR)HTMLForm.$(O) \
  $(OUTDIR)HTMLApplet.$(O) \
  $(OUTDIR)HTMLImage.$(O) \
  $(OUTDIR)HTMLList.$(O) \
  $(OUTDIR)HTMLText.$(O) \
  $(OUTDIR)HTMLCRMarkupText.$(O) \
  $(OUTDIR)HTMLMarkupText.$(O) \
  $(OUTDIR)HTMLTable.$(O) \
  $(OUTDIR)HTMLTableRow.$(O) \
  $(OUTDIR)HTMLTableCol.$(O) \
  $(OUTDIR)HTMLView.$(O) \


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
$(OUTDIR)Applet.$(O) Applet.$(H): Applet.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLAnchor.$(O) HTMLAnchor.$(H): HTMLAnchor.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLApplet.$(O) HTMLApplet.$(H): HTMLApplet.st $(STCHDR)  ../include/HTMLWidget.$(H)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLBullet.$(O) HTMLBullet.$(H): HTMLBullet.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLCRMarkupText.$(O) HTMLCRMarkupText.$(H): HTMLCRMarkupText.st $(STCHDR)  ../include/HTMLText.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocGenerator.$(O) HTMLDocGenerator.$(H): HTMLDocGenerator.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocumentFrame.$(O) HTMLDocumentFrame.$(H): HTMLDocumentFrame.st $(STCHDR)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocumentInterpreter.$(O) HTMLDocumentInterpreter.$(H): HTMLDocumentInterpreter.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocumentPainter.$(O) HTMLDocumentPainter.$(H): HTMLDocumentPainter.st $(STCHDR)  ../include/HTMLDocumentInterpreter.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocumentPrinter.$(O) HTMLDocumentPrinter.$(H): HTMLDocumentPrinter.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLDocumentView.$(O) HTMLDocumentView.$(H): HTMLDocumentView.st $(STCHDR)  ../include/HTMLDocumentFrame.$(H)  ../include/View.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLElement.$(O) HTMLElement.$(H): HTMLElement.st $(STCHDR)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLFilterStream.$(O) HTMLFilterStream.$(H): HTMLFilterStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLForm.$(O) HTMLForm.$(H): HTMLForm.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLImage.$(O) HTMLImage.$(H): HTMLImage.st $(STCHDR)  ../include/HTMLAnchor.$(H)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLList.$(O) HTMLList.$(H): HTMLList.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLMarkup.$(O) HTMLMarkup.$(H): HTMLMarkup.st $(STCHDR)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLMarkupText.$(O) HTMLMarkupText.$(H): HTMLMarkupText.st $(STCHDR)  ../include/HTMLText.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLParser.$(O) HTMLParser.$(H): HTMLParser.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLScript.$(O) HTMLScript.$(H): HTMLScript.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLScriptEnvironment.$(O) HTMLScriptEnvironment.$(H): HTMLScriptEnvironment.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLStyle.$(O) HTMLStyle.$(H): HTMLStyle.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLTable.$(O) HTMLTable.$(H): HTMLTable.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLTableCol.$(O) HTMLTableCol.$(H): HTMLTableCol.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLTableRow.$(O) HTMLTableRow.$(H): HTMLTableRow.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)HTMLText.$(O) HTMLText.$(H): HTMLText.st $(STCHDR)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLView.$(O) HTMLView.$(H): HTMLView.st $(STCHDR)  ../include/ScrollableView.$(H)  ../include/SimpleView.$(H)  ../include/DisplaySurface.$(H)  ../include/GraphicsMedium.$(H)  ../include/DeviceGraphicsContext.$(H)  ../include/GraphicsContext.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLWidget.$(O) HTMLWidget.$(H): HTMLWidget.st $(STCHDR)  ../include/HTMLMarkup.$(H)  ../include/HTMLElement.$(H)  ../include/Array.$(H)  ../include/ArrayedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)HTMLWriteStream.$(O) HTMLWriteStream.$(H): HTMLWriteStream.st $(STCHDR)  ../include/WriteStream.$(H)  ../include/PositionableStream.$(H)  ../include/PeekableStream.$(H)  ../include/Stream.$(H)  ../include/Object.$(H) 
$(OUTDIR)URL.$(O) URL.$(H): URL.st $(STCHDR)  ../include/Object.$(H) 
# ENDMAKEDEPEND
