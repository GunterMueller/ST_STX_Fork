"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ImageReader subclass:#JPEGReader
	instanceVariableNames:'jpeg_decompress_struct jpeg_compress_struct jpeg_error_mgr_struct
		colorComponents forceGrayscale forceDitherMode app1SegmentHandler
		compressQuality bytesPerRow'
	classVariableNames:'DefaultCompressQuality ErrorPrinting'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!JPEGReader primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include <stdio.h>

#ifdef sunos
# include <sys/types.h>
#endif

#include <jpeglib.h>
#include <jerror.h>

struct my_error_mgr {
	struct jpeg_error_mgr pub;
	jmp_buf setjmp_buffer;
};

%}
! !

!JPEGReader primitiveFunctions!
%{

/*
 * any local C (helper) functions
 * come here (please, define as static)
 */

static void
my_error_exit(cinfo)
    j_common_ptr cinfo;
{
    struct my_error_mgr *myerrPtr = (struct my_error_mgr *) cinfo->err;

    if (@global(ErrorPrinting) == true) {
	console_fprintf(stderr, "JPEGReader [warning]: jpeg error\n");
    }
    longjmp(myerrPtr->setjmp_buffer, 1);
}

static void
my_output_message(cinfo)
    j_common_ptr cinfo;
{
    char buffer[JMSG_LENGTH_MAX];

    if (@global(ErrorPrinting) == true) {
	console_fprintf(stderr, "libJPEG [error]: ");

       /* Create the message */
       (*cinfo->err->format_message) (cinfo, buffer);

       /* Send it to stderr, adding a newline */
       console_fprintf(stderr, "%s\n", buffer);
    }
}

/*
 * Optional progress monitor: display a percent-done figure on stderr.
 */

#ifdef PROGRESS_REPORT

void
JPG_progress_monitor (j_common_ptr cinfo)
{
  cd_progress_ptr prog = (cd_progress_ptr) cinfo->progress;
  int total_passes = prog->pub.total_passes + prog->total_extra_passes;
  int percent_done = (int) (prog->pub.pass_counter*100L/prog->pub.pass_limit);

  if (percent_done != prog->percent_done) {
    prog->percent_done = percent_done;
    if (total_passes > 1) {
      console_fprintf("\rPass %d/%d: %3d%% ",
	      prog->pub.completed_passes + prog->completed_extra_passes + 1,
	      total_passes, percent_done);
    } else {
      console_fprintf("\r %3d%% ", percent_done);
    }
    console_fflush(stderr);
  }
}


void
JPG_start_progress_monitor (j_common_ptr cinfo, cd_progress_ptr progress)
{
  /* Enable progress display, unless trace output is on */
  if (cinfo->err->trace_level == 0) {
    progress->pub.progress_monitor = progress_monitor;
    progress->completed_extra_passes = 0;
    progress->total_extra_passes = 0;
    progress->percent_done = -1;
    cinfo->progress = &progress->pub;
  }
}


void
JPG_end_progress_monitor (j_common_ptr cinfo)
{
  /* Clear away progress display */
  if (cinfo->err->trace_level == 0) {
    console_fprintf(stderr, "\r                \r");
  }
}

#endif /* PROGRESS_REPORT */


/* fetch a byte from the stream */
unsigned int
JPG_jpeg_getc (j_decompress_ptr cinfo)
/* Read next byte */
{
  struct jpeg_source_mgr *datasrc = cinfo->src;

  if (datasrc->bytes_in_buffer == 0) {
    if (! (*datasrc->fill_input_buffer) (cinfo))
      return -1;
  }
  datasrc->bytes_in_buffer--;
  return (*datasrc->next_input_byte++) & 0xFF;
}

%}
! !

!JPEGReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Reader for JPEG images.

    This uses the libpeg library to read the image

    Only writing of depth24 images is currently supported.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader PBMReader PCXReader
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader
        XBMReader XPMReader XWDReader
"
!

examples
"
    good quality:
                                                                [exBegin]
     |i i24 i2|

     Transcript printf:'gif original %d\n' with:( '../../goodies/bitmaps/gifImages/garfield.gif' asFilename fileSize ).
     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i24 := Depth24Image fromImage:i.
     JPEGReader save:i24 onFile:'test100.jpg'.
     i2 := Image fromFile:'test100.jpg'.
     Transcript printf:'jpg 100%% %d\n' with:( 'test100.jpg' asFilename fileSize ).
     i2 inspect
                                                                [exEnd]


    normal quality:
                                                                [exBegin]
     |i i24 i2|

     Transcript printf:'gif original %d\n' with:( '../../goodies/bitmaps/gifImages/garfield.gif' asFilename fileSize ).
     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i24 := Depth24Image fromImage:i.
     JPEGReader save:i24 onFile:'test80.jpg'.
     i2 := Image fromFile:'test80.jpg'.
     Transcript printf:'jpg 80%% %d\n' with:( 'test80.jpg' asFilename fileSize ).
     i2 inspect
                                                                [exEnd]


    low quality:
                                                                [exBegin]
     |i i24 i2|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i24 := Depth24Image fromImage:i.
     JPEGReader new save:i24 onStream:('test50.jpg' asFilename writeStream) compressQuality:50.
     i2 := Image fromFile:'test50.jpg'.
     Transcript printf:'jpg 50%% %d\n' with:( 'test50.jpg' asFilename fileSize ).
     i2 inspect
                                                                [exEnd]

    bad quality:
                                                                [exBegin]
     |i i24 i2|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i24 := Depth24Image fromImage:i.
     JPEGReader new save:i24 onStream:('test20.jpg' asFilename writeStream) compressQuality:20.
     i2 := Image fromFile:'test20.jpg'.
     Transcript printf:'jpg 20%% %d\n' with:( 'test20.jpg' asFilename fileSize ).
     i2 inspect
                                                                [exEnd]

    very bad quality:
                                                                [exBegin]
     |i i24 i2|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i24 := Depth24Image fromImage:i.
     JPEGReader new save:i24 onStream:('test10.jpg' asFilename writeStream) compressQuality:10.
     i2 := Image fromFile:'test10.jpg'.
     Transcript printf:'jpg 10%% %d\n' with:( 'test10.jpg' asFilename fileSize ).
     i2 inspect
                                                                [exEnd]
"
! !

!JPEGReader class methodsFor:'initialization'!

initialize
    "install myself in the Image classes fileFormat table
     for the `.jpg' and '.jpeg' extensions."

    MIMETypes defineImageType:'image/jpeg' suffix:'jpg'  reader:self.
    MIMETypes defineImageType:nil          suffix:'jpeg' reader:self.

    "Modified: 1.2.1997 / 15:01:55 / cg"
! !

!JPEGReader class methodsFor:'defaults'!

defaultCompressQuality
    ^ DefaultCompressQuality ? 85
!

defaultCompressQuality:percent
    DefaultCompressQuality := percent.
! !

!JPEGReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     For now, only d24 images are supported."

    anImage depth == 24 ifTrue:[^ true].
    ('JPEGReader [info]: image depth is not 24.') infoPrintCR.
    ^ false.
!

isValidImageFile:aFilenameOrString
    "return true, if aFileName contains a JPG image.
     Only look at the file's name here ..."

    ^ (MIMETypes mimeTypeForSuffix:aFilenameOrString asFilename suffix) = 'image/jpeg'

    "Created: 11.4.1997 / 16:26:25 / cg"

    "
     self isValidImageFile:'xxx.jpg'
    "
! !

!JPEGReader methodsFor:'accessing'!

app1SegmentHandler:aBlock
    "set a handler block for app1 segment data (geolocation in exif format)"

    app1SegmentHandler := aBlock
!

compressQuality:compressQualityOrNilForDefault
    compressQuality := compressQualityOrNilForDefault
!

forceDitherMode:something
    "set the dither mode, to one of #none or #ordered"

    forceDitherMode := something.

    "Modified: 16.4.1997 / 20:34:59 / cg"
!

forceGrayscale:something
    "set the forceGrayscale mode; if true, grayScale images are
     returned, even if the input contains a color image."

    forceGrayscale := something.

    "Created: 16.4.1997 / 20:33:44 / cg"
    "Modified: 16.4.1997 / 20:34:29 / cg"
! !

!JPEGReader methodsFor:'private'!

app1SegmentCallback
    "return a callback function which invokes the app1SegmentHandlerBlock if defined.
     This will be called to handle the exif segment, containing geolocation tags.
     Return nil, if there is no handler blcok defined"

    |cb|

    app1SegmentHandler isNil ifTrue:[^ nil].

    cb := ExternalFunctionCallback new.
    cb returnType:#bool argumentTypes:#(pointer).
    cb generateClosure.
    cb action:[:args | self fetchApp1SegmentData. true].
    ^ cb code.  "can be passed to C."
!

create_jpeg_compress_struct
    |errMgrStructSize compressStructSize fp errorOccurred|

    self assert:(photometric == #rgb).
    self assert:(samplesPerPixel == 3).
    self assert:(bitsPerSample asArray = #(8 8 8)).

    fp := outStream filePointer.
    fp isNil ifTrue:[
	self error:'can only write to an external stream'.
	^ false.
    ].

%{
    errMgrStructSize = __mkSmallInteger(sizeof(struct my_error_mgr));
    compressStructSize = __mkSmallInteger(sizeof(struct jpeg_compress_struct));
%}.

    jpeg_error_mgr_struct := ExternalBytes unprotectedNew:errMgrStructSize.
    jpeg_compress_struct := ExternalBytes unprotectedNew:compressStructSize.
    errorOccurred := false.

%{  /* STACK: 400000 */
    struct jpeg_compress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);
    OBJ j_c_s = __INST(jpeg_compress_struct);
    FILE *f = __FILEVal(fp);
    char *outBuffer;

    if (__isExternalBytesLike(j_c_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_compress_struct *)(__externalBytesAddress(j_c_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	/*
	 * Initialize the JPEG decompression object with default error handling.
	 */
	cinfoPtr->err = jpeg_std_error(&jerrPtr->pub);

	/*
	 * prepare to handle errors smoothly ...
	 */
	jerrPtr->pub.error_exit = my_error_exit;
	if (setjmp(jerrPtr->setjmp_buffer)) {
	    /*
	     * error occurred ...
	     */
	    jpeg_destroy_compress(cinfoPtr);
	    RETURN (false);
	}

	/*
	 * use my message print function
	 */
	jerrPtr->pub.output_message = my_output_message;

	jpeg_create_compress(cinfoPtr);

	/* Specify data destination for compression */
	jpeg_stdio_dest(cinfoPtr, f);

	cinfoPtr->image_width      = __intVal(__INST(width));
	cinfoPtr->image_height     = __intVal(__INST(height));
	cinfoPtr->input_components = __intVal(__INST(samplesPerPixel));
	cinfoPtr->in_color_space   = JCS_RGB;

	jpeg_set_defaults(cinfoPtr);
	/*set the quality [0..100]  */
	jpeg_set_quality (cinfoPtr, __intVal(__INST(compressQuality)), 1);
	jpeg_start_compress(cinfoPtr, 1);


	cinfoPtr->err->trace_level = 0;
    }
%}.
    ^ true
!

create_jpeg_decompress_struct
    |errMgrStructSize decompressStructSize fp errorOccurred app1SegmentCallbackFunction|

    fp := inStream filePointer.
    fp isNil ifTrue:[
	self error:'can only read from an external stream'.
	^ false.
    ].

    app1SegmentCallbackFunction := self app1SegmentCallback.

%{
    errMgrStructSize = __mkSmallInteger(sizeof(struct my_error_mgr));
    decompressStructSize = __mkSmallInteger(sizeof(struct jpeg_decompress_struct));
%}.

    jpeg_error_mgr_struct := ExternalBytes unprotectedNew:errMgrStructSize.
    jpeg_decompress_struct := ExternalBytes unprotectedNew:decompressStructSize.
    errorOccurred := false.

%{  /* STACK: 400000 */
    struct jpeg_decompress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);
    OBJ j_d_s = __INST(jpeg_decompress_struct);
    FILE *f = __FILEVal(fp);

    if (__isExternalBytesLike(j_d_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_decompress_struct *)(__externalBytesAddress(j_d_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	/*
	 * Initialize the JPEG decompression object with default error handling.
	 */
	cinfoPtr->err = jpeg_std_error(&jerrPtr->pub);

	/*
	 * prepare to handle errors smoothly ...
	 */
	jerrPtr->pub.error_exit = my_error_exit;
	if (setjmp(jerrPtr->setjmp_buffer)) {
	    /*
	     * error occurred ...
	     */
	    jpeg_destroy_decompress(cinfoPtr);
	    RETURN (false);
	}

	/*
	 * use my message print function
	 */
	jerrPtr->pub.output_message = my_output_message;

	jpeg_create_decompress(cinfoPtr);
#if 0
	/*
	 * Insert custom COM marker processor.
	 */
	jpeg_set_marker_processor(cinfoPtr, JPEG_COM, COM_handler);
#endif
#if 0
	if (app1SegmentCallbackFunction != nil) {
	    jpeg_marker_parser_method cb = NULL;

	    if (__isExternalFunction(app1SegmentCallbackFunction)) {
		cb = (jpeg_marker_parser_method)__externalFunctionVal(app1SegmentCallbackFunction);
	    } else if (__isExternalAddress(app1SegmentCallbackFunction)) {
		cb = (jpeg_marker_parser_method)__externalAddressVal(app1SegmentCallbackFunction);
	    } else {
		/* ignore, but should report an error... */
	    }
	    jpeg_set_marker_processor(cinfoPtr, JPEG_APP0+1, cb);
	}
#endif
	/* Specify data source for decompression */
	jpeg_stdio_src(cinfoPtr, f);
# if JPEG_LIB_VERSION_MAJOR >= 9
	jpeg_save_markers (cinfoPtr, JPEG_APP0, 0xffff);
	jpeg_save_markers (cinfoPtr, JPEG_APP0+1, 0xffff);
	jpeg_save_markers (cinfoPtr, JPEG_APP0+13, 0xffff);
#endif
	/* Read file header, set default decompression parameters */
	(void) jpeg_read_header(cinfoPtr, TRUE);

	cinfoPtr->err->trace_level = 0;

#if 0
	/* colors setting */
	cinfoPtr->desired_number_of_colors = val;
	cinfoPtr->quantize_colors = TRUE;
#endif
#if 0
	/* dct setting */
	cinfoPtr->dct_method = JDCT_ISLOW;
	or: cinfoPtr->dct_method = JDCT_IFAST;
	or: cinfoPtr->dct_method = JDCT_FLOAT;
#endif

	/* dither setting */
	cinfoPtr->dither_mode = JDITHER_FS;
	if (__INST(forceDitherMode) == @symbol(none)) {
	    cinfoPtr->dither_mode = JDITHER_NONE;
	} else {
	    if (__INST(forceDitherMode) == @symbol(ordered)) {
		cinfoPtr->dither_mode = JDITHER_ORDERED;
	    }
	}

#if 0
	/* fast setting */
	cinfoPtr->two_pass_quantize = FALSE;
	cinfoPtr->dither_mode = JDITHER_ORDERED;
	cinfoPtr->desired_number_of_colors = 216;
	cinfoPtr->dct_method = JDCT_FASTEST;
	cinfoPtr->do_fancy_upsampling = FALSE;
#endif

	if (__INST(forceGrayscale) == true) {
	    /* grayscale setting */
	    cinfoPtr->out_color_space = JCS_GRAYSCALE;
	}

#if 0
	/* maxmemory setting */
	cinfoPtr->mem->max_memory_to_use = lval * 1000L;
#endif

#if 0
	/* nosmooth setting */
	cinfoPtr->do_fancy_upsampling = FALSE;
#endif

#if 0
	/* onepass setting */
	cinfoPtr->two_pass_quantize = FALSE;
#endif

	/* Calculate output image dimensions so we can allocate space */
	jpeg_calc_output_dimensions(cinfoPtr);

	__INST(width) = __mkSmallInteger(cinfoPtr->output_width);
	__INST(height) = __mkSmallInteger(cinfoPtr->output_height);
	__INST(colorComponents) = __mkSmallInteger(cinfoPtr->output_components);

	/* could now set additional values in cinfo
	 * (colormap)
	 */

    }
%}.
    ^ true
!

decompressChunkInto:aByteArray startingAt:index
%{  /* STACK: 400000 */
    struct jpeg_decompress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    char *rowPtr = NULL;
    OBJ j_d_s = __INST(jpeg_decompress_struct);
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);
    int num_scanlines;
    JSAMPROW rowPointers[4];

    if (__isByteArray(aByteArray)) {
	rowPtr = (char *)(__ByteArrayInstPtr(aByteArray)->ba_element);
    } else if (__isExternalBytesLike(aByteArray)) {
	rowPtr = __externalBytesAddress(aByteArray);
    }

    if (__isExternalBytesLike(j_d_s)
     && (rowPtr != NULL)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_decompress_struct *)(__externalBytesAddress(j_d_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	rowPtr += __intVal(index) - 1;

	rowPointers[0] = rowPtr;
	rowPointers[1] = NULL;
	rowPointers[2] = NULL;
	rowPointers[3] = NULL;

	if (cinfoPtr->output_scanline < cinfoPtr->output_height) {
	    if (setjmp(jerrPtr->setjmp_buffer)) {
		/*
		 * error occurred ...
		 */
		jpeg_destroy_decompress(cinfoPtr);
		RETURN (__mkSmallInteger(-1));
	    }
	    num_scanlines = jpeg_read_scanlines(cinfoPtr, rowPointers, 1);
	    RETURN (__mkSmallInteger(num_scanlines));
	}
	RETURN (__mkSmallInteger(0));
    }
%}.
    self halt:'bad arguments'.
!

extractApp1DataFrom:data
    (data startsWith:#[16r45 16r78 16r69 16r66 16r0] " = 'Exif' + 0-byte" ) ifTrue:[
	self extractExifDataFrom:data.
    ].

    "Created: / 12-12-2011 / 21:22:23 / cg"
!

extractExifDataFrom:data
    self halt:'ignored exif data'

    "Created: / 12-12-2011 / 21:22:32 / cg"
!

fetchApp1SegmentData
    |byte1 byte2 count|

    byte1 := self jpeg_getc.
    byte2 := self jpeg_getc.
    count := (byte1 bitShift:8) + byte2. "/ msb first
    count := count - 2. "/ count itself is included
    data := ByteArray new:count.
    1 to: count do:[:i |
	data at:i put:(self jpeg_getc).
    ].
    self breakPoint:#cg.
    app1SegmentHandler value:data.
!

finish_compress
%{  /* STACK: 400000 */
    struct jpeg_compress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_c_s = __INST(jpeg_compress_struct);
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);

    if (__isExternalBytesLike(j_c_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_compress_struct *)(__externalBytesAddress(j_c_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	if (setjmp(jerrPtr->setjmp_buffer)) {
	    jpeg_destroy_compress(cinfoPtr);
	    RETURN (false);
	}

	/* finish decompressor */
	(void) jpeg_finish_compress(cinfoPtr);
	(void) jpeg_destroy_compress(cinfoPtr);
	RETURN (true);
    }
%}
!

finish_decompress
%{  /* STACK: 400000 */
    struct jpeg_decompress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_d_s = __INST(jpeg_decompress_struct);
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);

    if (__isExternalBytesLike(j_d_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_decompress_struct *)(__externalBytesAddress(j_d_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	if (setjmp(jerrPtr->setjmp_buffer)) {
	    jpeg_destroy_decompress(cinfoPtr);
	    RETURN (false);
	}

	/* finish decompressor */
	(void) jpeg_finish_decompress(cinfoPtr);
	(void) jpeg_destroy_decompress(cinfoPtr);
	RETURN (true);
    }
%}
!

get_error_message
%{
    j_common_ptr cinfoPtr;
    OBJ j_d_s = __INST(jpeg_decompress_struct);
    char buffer[JMSG_LENGTH_MAX+1];

    if (__isExternalBytesLike(j_d_s)) {
	cinfoPtr = (j_common_ptr)(__externalBytesAddress(j_d_s));

	(*cinfoPtr->err->format_message) (cinfoPtr, buffer);
	buffer[JMSG_LENGTH_MAX] = '\0';
	RETURN ( __MKSTRING(buffer));
    }
%}.
    ^ nil
!

jpeg_getc
%{
    OBJ j_d_s = __INST(jpeg_decompress_struct);

    if (__isExternalBytesLike(j_d_s)) {
	struct jpeg_decompress_struct *cinfoPtr;
	int byte;

	cinfoPtr = (struct jpeg_decompress_struct *)(__externalBytesAddress(j_d_s));

	byte = JPG_jpeg_getc (cinfoPtr);
	RETURN( __MKSMALLINT(byte) );
    }
%}.
    self primitiveFailed
!

start_decompress
%{  /* STACK: 400000 */
    struct jpeg_decompress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_d_s = __INST(jpeg_decompress_struct);
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);

    if (__isExternalBytesLike(j_d_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_decompress_struct *)(__externalBytesAddress(j_d_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	if (setjmp(jerrPtr->setjmp_buffer)) {
	    jpeg_destroy_decompress(cinfoPtr);
	    RETURN (false);
	}

	/* Start decompressor */
	(void) jpeg_start_decompress(cinfoPtr);
	RETURN (true);
    }
%}
! !

!JPEGReader methodsFor:'reading'!

fromStream:aStream
    "read a JPG image from a stream.
     For now, we can only read from a stdio-FILE with libjpeg 
     (need to write a mem-reader to read from a Smalltalk stream).
     Therefore, any internal stream data is copied to a temporary file first,
     and libjpg asked to decompress from there.
     This should be fixed, if jpeg reading is a bottleneck in your app."

    |dataIdx bytesPerRow returnCode pos1 pos2 ok s img|

    aStream isExternalStream ifFalse:[
        "/ libJpeg can only handle real OS-streams

        s := FileStream newTemporary binary.
        [
            pos1 := aStream position.
            aStream copyToEndInto:s.
            aStream position:pos1.
            "/ s nextPutAll:aStream contents.
            s reset.
            img := self fromStream:s.
        ] ensure:[
            "/ leave the internal stream positioned correctly.
            "/ sigh: jpgreader seems to read too much (buffer-filling?);
            "/ so the position is usually beyond the actual end of the single image.
            "/ for now, you have to use workarounds (such as scanning for SOI markers)
            "/ to get individual images from a sequence.
            pos2 := s position.
            s close.
            s fileName delete.
        ].
        img notNil ifTrue:[
            aStream position:(pos1 + pos2).
        ].    
        ^ img
    ].

    inStream := aStream.
    pos1 := inStream position.

    "/ to extract app1 data (for example, exif geolocation tags),
    "/ uncomment the following and implement the exif tag reader...
    "/ Warning: this does not yet work as expected.
    "/ app1SegmentHandler := [:data | self extractApp1DataFrom:data].

    (self create_jpeg_decompress_struct not
    or:[self start_decompress not]) ifTrue:[
        ok := false.

        "/ if there was no SOI marker,
        "/ try again, skipping first 128 bytes
        "/ (seems to be generated by some jpg writers)

        inStream position:pos1.
        ((inStream nextByte ~~ 16rFF)
        or:[inStream nextByte ~~ 16rD8]) ifTrue:[
            inStream position:pos1 + 128.
            ((inStream nextByte == 16rFF)
            and:[inStream nextByte == 16rD8]) ifTrue:[
                inStream position:pos1 + 128.
                ok := self create_jpeg_decompress_struct
                      and:[self start_decompress]
            ].
        ].
        ok ifFalse:[
            'JPEGReader [info]: ' infoPrint. self get_error_message infoPrintCR.
            ^ nil
        ]
    ].

    data := ByteArray uninitializedNew:(width * height * colorComponents).
    dataIdx := 1.
    bytesPerRow := colorComponents * width.

    [(returnCode := self decompressChunkInto:data startingAt:dataIdx) > 0] whileTrue:[
        "/ got a row in the buffer ...
        dataIdx := dataIdx + bytesPerRow
    ].
    returnCode < 0 ifTrue:[
        'JPEGReader [info]: ' infoPrint. self get_error_message infoPrintCR.
        ^ nil
    ].

    (self finish_decompress) ifFalse:[
        'JPEGReader [info]: ' infoPrint. self get_error_message infoPrintCR.
        ^ nil
    ].

    colorComponents == 3 ifTrue:[
        photometric := #rgb.
        samplesPerPixel := 3.
        bitsPerSample := #(8 8 8).
    ] ifFalse:[
        photometric := #blackIs0.
        samplesPerPixel := 1.
        bitsPerSample := #(8).
    ].

    "
     JPEGReader fromFile:'../../support/libjpeg-9/testimg.jpg'
    "

    "
     |stream|
     stream := #[] readWriteStream.
     '../../support/libjpeg-9/testimg.jpg' asFilename copyToStream:stream.
     JPEGReader fromStream:stream
    "

    "
     |stream reader|

     stream := '../../support/libjpeg-9/testimg.jpg' asFilename readStream.
     reader := JPEGReader new.
     reader forceGrayscale:true.
     reader forceDitherMode:#ordered.
     reader fromStream:stream.
     ^ reader image
    "

    "Modified: / 12-12-2011 / 21:34:48 / cg"
! !

!JPEGReader methodsFor:'writing'!

compressScanlines
%{
    unsigned char *rowPtr;
    int bpr = __intVal(__INST(bytesPerRow));
    int row;
    int __height = __intVal(__INST(height));
    struct jpeg_compress_struct *cinfoPtr;
    struct my_error_mgr *jerrPtr;
    OBJ j_c_s = __INST(jpeg_compress_struct);
    OBJ j_e_m = __INST(jpeg_error_mgr_struct);
    OBJ __data = __INST(data);

    if (__isByteArray(__data)) {
	rowPtr = (char *)(__ByteArrayInstPtr(__data)->ba_element);
    } else if (__isExternalBytesLike(__data)) {
	rowPtr = __externalBytesAddress(__data);
    }

    if (__isExternalBytesLike(j_c_s)
     && __isExternalBytesLike(j_e_m)) {
	cinfoPtr = (struct jpeg_compress_struct *)(__externalBytesAddress(j_c_s));
	jerrPtr = (struct my_error_mgr *)(__externalBytesAddress(j_e_m));

	if (setjmp(jerrPtr->setjmp_buffer)) {
	    jpeg_destroy_compress(cinfoPtr);
	    RETURN (false);
	}

	for (row=0; row<__height; row++) {
	    jpeg_write_scanlines(cinfoPtr, &rowPtr, 1);
	    rowPtr += bpr;
	}
    }
%}
!

save:anImage onFile:fileName
    anImage depth ~~ 24 ifTrue:[
        Error handle:[:ex |
            ^ Image cannotRepresentImageSignal
                raiseWith:anImage
                errorString:('failed to convert image to depth24: ', ex description).
            "/ ex return.
        ] do:[
            ^ self save:(Depth24Image fromImage:anImage) onFile:fileName
        ].
    ].
    ^ super save:anImage onFile:fileName.
!

save:image onStream:aStream
    "save image in JPG-file-format onto aStream"

    image depth ~~ 24 ifTrue:[
        ^ Image cannotRepresentImageSignal
            raiseWith:image
            errorString:('JPG (currently) only supports depth24 images').
    ].

    outStream := aStream.
    outStream binary.

"/    mask := image mask.
"/    mask notNil ifTrue:[
"/        self assignTransparentPixelIn:image
"/    ].

    width := image width.
    height := image height.
    photometric := image photometric.
    samplesPerPixel := image samplesPerPixel.
    bitsPerSample := image bitsPerSample.
    colorMap := image colorMap.
    bytesPerRow := image bytesPerRow.
    data := image bits.
    compressQuality isNil ifTrue:[
        compressQuality := self class defaultCompressQuality.
    ].    

    (self create_jpeg_compress_struct not) ifTrue:[
        self error:'JPG: setup error'.
    ].

    self compressScanlines.
    self finish_compress.
! !

!JPEGReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


JPEGReader initialize!
