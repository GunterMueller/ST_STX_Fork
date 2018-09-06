"
 COPYRIGHT (c) 1997 by eXept Software AG
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

ImageReader subclass:#AVIReader
	instanceVariableNames:'riffReader frames nframes frameBuffer frameBufferSize imageBuffer
		redPalette greenPalette bluePalette flags frameDelay streamType
		depth compression colorTable numColors deltaMethod'
	classVariableNames:'MAXCOLORS UnsupportedFormatErrorSignal'
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!AVIReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    This is not yet completed, untested and highly experimental.

    This reader read frames from an AVI file; however, only a tiny subset of AVI is supported.

    This is a very first attempt in reading AVI files;
    Its very experimental, preliminary and will certainly change.
    (will introduce a new class hierarchy based upon some MovieReader ...).

    When used like an imageReader, #fromFile: will return
    the very first frame and the rest as imageFrameSequence.

    Warning: 
        right now, the complete movie is read and huge
        amounts of memory are allocated.
        The interface will be changed to allow stream operation ...

    [author:]
        Claus Gittinger

    [see also:]
        ImageReader RIFFReader
"
!

examples
"
    |reader film view tNext|

    reader := AVIReader readFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi'.      
    reader isNil ifTrue:[^ nil].
    film := reader images.
    view := StandardSystemView extent:(film first extent).
    view openAndWait.

    tNext := Time millisecondClockValue + (reader frameDelay).
    film do:[:frame |
        frame displayOn:view x:0 y:0.
        (Delay untilMilliseconds:tNext) wait.
        tNext := tNext + (reader frameDelay).
    ].
"
! !

!AVIReader class methodsFor:'class initialization'!

initialize
    MAXCOLORS := 256.

    UnsupportedFormatErrorSignal isNil ifTrue:[
        UnsupportedFormatErrorSignal := ErrorSignal newSignalMayProceed:true.
        UnsupportedFormatErrorSignal nameClass:self message:#unsupportedFormatErrorSignal.
    ].

    "
     AVIReader initialize
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 5.4.1997 / 14:37:08 / cg"
! !

!AVIReader class methodsFor:'testing'!

isValidImageFile:aFileName
    "return true, if aFileName contains an AVI-movie"

    ^ RIFFReader isRIFFFile:aFileName withType:'AVI'

    "
     AVIReader isValidImageFile:'bitmaps/magtape.xpm'                     
     AVIReader isValidImageFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi'      
    "

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 4.4.1997 / 23:15:39 / cg"
! !

!AVIReader methodsFor:'accessing'!

frameDelay
    "return the value of the instance variable 'frameDelay' (automatically generated)"

    ^ frameDelay

    "Created: 4.4.1997 / 22:35:52 / cg"
!

images
    "return a collection of all images as represented by myself"

    |image depth|

    depth := self bitsPerPixel.
    1 to:imageSequence size do:[:i |
        |frame|

        frame := imageSequence at:i.

        frame isImage ifFalse:[
            image := (Image implementorForDepth:depth) new.
            image 
                width:width 
                height:height
                photometric:photometric
                samplesPerPixel:samplesPerPixel
                bitsPerSample:bitsPerSample
                colorMap:colorMap
                bits:frame
                mask:mask.
            imageSequence at:i put:image.
        ].
    ].
    ^ imageSequence

    "Created: 4.4.1997 / 22:35:52 / cg"
    "Modified: 24.6.1997 / 15:57:17 / cg"
! !

!AVIReader methodsFor:'decoders'!

AVI_Decode_CRAM:data
"

/*
 * Routine to Decode an AVI CRAM chunk
 */

#define AVI_CRAM_C1(ip,clr,rdec) { \
 *ip++ = clr; *ip++ = clr; *ip++ = clr; *ip = clr; ip -= rdec; \
 *ip++ = clr; *ip++ = clr; *ip++ = clr; *ip = clr; ip -= rdec; \
 *ip++ = clr; *ip++ = clr; *ip++ = clr; *ip = clr; ip -= rdec; \
 *ip++ = clr; *ip++ = clr; *ip++ = clr; *ip = clr; }

#define AVI_CRAM_C2(ip,flag,cA,cB,rdec) { \
  *ip++ =(flag&0x01)?(cB):(cA); *ip++ =(flag&0x02)?(cB):(cA); \
  *ip++ =(flag&0x04)?(cB):(cA); *ip   =(flag&0x08)?(cB):(cA); ip-=rdec; \
  *ip++ =(flag&0x10)?(cB):(cA); *ip++ =(flag&0x20)?(cB):(cA); \
  *ip++ =(flag&0x40)?(cB):(cA); *ip   =(flag&0x80)?(cB):(cA); }

#define AVI_CRAM_C4(ip,flag,cA0,cA1,cB0,cB1,rdec) { \
  *ip++ =(flag&0x01)?(cB0):(cA0); *ip++ =(flag&0x02)?(cB0):(cA0); \
  *ip++ =(flag&0x04)?(cB1):(cA1); *ip   =(flag&0x08)?(cB1):(cA1); ip-=rdec; \
  *ip++ =(flag&0x10)?(cB0):(cA0); *ip++ =(flag&0x20)?(cB0):(cA0); \
  *ip++ =(flag&0x40)?(cB1):(cA1); *ip   =(flag&0x80)?(cB1):(cA1); }

#define AVI_MIN_MAX_CHECK(x,y,min_x,max_x,min_y,max_y) { \
    if (x < min_x) min_x = x; if (y > max_y) max_y = y; \
    if (x > max_x) max_x = x; if (y < min_y) min_y = y; } 

#define AVI_BLOCK_INC(x,y,imagex) { x += 4; if (x>=imagex) { x=0; y -= 4; } }

#define AVI_GET_16(data,dptr) { data = *dptr++; data |= (*dptr++) << 8; }

#define AVI_CRAM_rgbC1(ip,r,g,b) { \
 *ip++=r; *ip++=g; *ip++=b; *ip++=r; *ip++=g; *ip++=b; \
 *ip++=r; *ip++=g; *ip++=b; *ip++=r; *ip++=g; *ip  =b; }

#define AVI_CRAM_rgbC2(ip,flag,rA,gA,bA,rB,gB,bB) { \
  if (flag&0x01) {*ip++=rB; *ip++=gB; *ip++=bB;} \
  else           {*ip++=rA; *ip++=gA; *ip++=bA;} \
  if (flag&0x02) {*ip++=rB; *ip++=gB; *ip++=bB;} \
  else           {*ip++=rA; *ip++=gA; *ip++=bA;} \
  if (flag&0x04) {*ip++=rB; *ip++=gB; *ip++=bB;} \
  else           {*ip++=rA; *ip++=gA; *ip++=bA;} \
  if (flag&0x08) {*ip++=rB; *ip++=gB; *ip  =bB;} \
  else           {*ip++=rA; *ip++=gA; *ip  =bA;}  }

#define AVI_CRAM_rgbC4(ip,flag,rA,gA,bA,rB,gB,bB) { \
  if (flag&0x01) {*ip++=rB; *ip++=gB; *ip++=bB;} \
  else           {*ip++=rA; *ip++=gA; *ip++=bA;} \
  if (flag&0x02) {*ip++=rB; *ip++=gB; *ip  =bB;} \
  else           {*ip++=rA; *ip++=gA; *ip  =bA;} }

#define AVI_Get_RGBColor(r,g,b,color) \
{ register ULONG _r,_g,_b; \
  _r = (color >> 10) & 0x1f; r = (_r << 3) | (_r >> 2); \
  _g = (color >>  5) & 0x1f; g = (_g << 3) | (_g >> 2); \
  _b =  color & 0x1f;        b = (_b << 3) | (_b >> 2); \
  if (xa_gamma_flag==TRUE) { r = xa_gamma_adj[r]>>8;    \
     g = xa_gamma_adj[g]>>8; b = xa_gamma_adj[b]>>8; } }


ULONG
AVI_Decode_CRAM(image,delta,dsize,chdr,map,map_flag,imagex,imagey,imaged,
                                                xs,ys,xe,ye,special,extra)
UBYTE *image;           /* Image Buffer. */
UBYTE *delta;           /* delta data. */
ULONG dsize;            /* delta size */
XA_CHDR *chdr;          /* color map info */
ULONG *map;             /* used if it's going to be remapped. */
ULONG map_flag;         /* whether or not to use remap_map info. */
ULONG imagex,imagey;    /* Size of image buffer. */
ULONG imaged;           /* Depth of Image. (IFF specific) */
ULONG *xs,*ys;          /* pos of changed area. */
ULONG *xe,*ye;          /* size of changed area. */
ULONG special;          /* Special Info. */
void *extra;            /* extra info needed to decode delta */
{
  ULONG row_dec,exitflag,changed,block_cnt;
  ULONG code0,code1;
  LONG x,y,min_x,max_x,min_y,max_y;
  UBYTE *dptr;

  changed = 0;
  max_x = max_y = 0;    min_x = imagex; min_y = imagey;
  dptr = delta;
  row_dec = imagex + 3;
  x = 0;
  y = imagey - 1;
  exitflag = 0;
  block_cnt = ((imagex * imagey) >> 4) + 1;

  if (map_flag == TRUE)
  {
    if (x11_bytes_pixel == 4)
    {
      while(!!exitflag)
      {
        code0 =  *dptr++;       code1 =  *dptr++;       block_cnt--;
        if ( ((code1==0) && (code0==0) && !!block_cnt) || (y<0)) exitflag = 1;
        else
        {
          if ((code1 >= 0x84) && (code1 <= 0x87)) /* skip */
          { ULONG skip = ((code1 - 0x84) << 8) + code0;
            block_cnt -= (skip-1); while(skip--) AVI_BLOCK_INC(x,y,imagex);
          }
          else /* single block encoded */
          {
            if (code1 >= 0x90) /* 8 color quadrant encoding */
            { ULONG cA0,cA1,cB0,cB1;
              ULONG *i_ptr = (ULONG *)(image + ((y * imagex + x) << 2) );
              cB0 = (ULONG)map[*dptr++];  cA0 = (ULONG)map[*dptr++];
              cB1 = (ULONG)map[*dptr++];  cA1 = (ULONG)map[*dptr++];
              AVI_CRAM_C4(i_ptr,code0,cA0,cA1,cB0,cB1,row_dec); i_ptr -=row_dec;
              cB0 = (ULONG)map[*dptr++];  cA0 = (ULONG)map[*dptr++];
              cB1 = (ULONG)map[*dptr++];  cA1 = (ULONG)map[*dptr++];
              AVI_CRAM_C4(i_ptr,code1,cA0,cA1,cB0,cB1,row_dec);
            } else if (code1 < 0x80) /* 2 color encoding */
            { register ULONG clr_A,clr_B;
              ULONG *i_ptr = (ULONG *)(image + ((y * imagex + x) << 2) );
              clr_B = (ULONG)map[*dptr++];   clr_A = (ULONG)map[*dptr++];
              AVI_CRAM_C2(i_ptr,code0,clr_A,clr_B,row_dec); i_ptr -= row_dec;
              AVI_CRAM_C2(i_ptr,code1,clr_A,clr_B,row_dec);
            }
            else /* 1 color encoding */
            { ULONG clr = (ULONG)map[code0]; 
              ULONG *i_ptr = (ULONG *)(image + ((y * imagex + x) << 2) );
              AVI_CRAM_C1(i_ptr,clr,row_dec);
            }
            AVI_MIN_MAX_CHECK(x,y,min_x,max_x,min_y,max_y);
            changed = 1; AVI_BLOCK_INC(x,y,imagex);
          } /* end of single block */
        } /* end of not term code */
      } /* end of not while exit */
    } /* end of 4 bytes pixel */
    else if (x11_bytes_pixel == 2)
    {
      while(!!exitflag)
      {
        code0 =  *dptr++;       code1 =  *dptr++;       block_cnt--;
        if ( ((code1==0) && (code0==0) && !!block_cnt) || (y<0)) exitflag = 1;
        else
        {
          if ((code1 >= 0x84) && (code1 <= 0x87)) /* skip */
          { ULONG skip = ((code1 - 0x84) << 8) + code0;
            block_cnt -= (skip-1); while(skip--) AVI_BLOCK_INC(x,y,imagex);
          } else /* single block encoded */
          {
            if (code1 >= 0x90) /* 8 color quadrant encoding */
            {
              USHORT cA0,cA1,cB0,cB1;
              USHORT *i_ptr = (USHORT *)(image + ((y * imagex + x) << 1) );
              cB0 = map[*dptr++];  cA0 = map[*dptr++];
              cB1 = map[*dptr++];  cA1 = map[*dptr++];
              AVI_CRAM_C4(i_ptr,code0,cA0,cA1,cB0,cB1,row_dec); i_ptr -=row_dec;
              cB0 = map[*dptr++];  cA0 = map[*dptr++];
              cB1 = map[*dptr++];  cA1 = map[*dptr++];
              AVI_CRAM_C4(i_ptr,code1,cA0,cA1,cB0,cB1,row_dec);
            } /* end of 8 color quadrant encoding */
            else if (code1 < 0x80) /* 2 color encoding */
            { USHORT clr_A,clr_B;
              USHORT *i_ptr = (USHORT *)(image + ((y * imagex + x) << 1) );
              clr_B = (USHORT)map[*dptr++];   clr_A = (USHORT)map[*dptr++];
              AVI_CRAM_C2(i_ptr,code0,clr_A,clr_B,row_dec); i_ptr -= row_dec;
              AVI_CRAM_C2(i_ptr,code1,clr_A,clr_B,row_dec);
            } /* end of 2 color */
            else /* 1 color encoding */
            { USHORT clr = (USHORT)map[code0];
              USHORT *i_ptr = (USHORT *)(image + ((y * imagex + x) << 1) );
              AVI_CRAM_C1(i_ptr,clr,row_dec);
            }
            AVI_MIN_MAX_CHECK(x,y,min_x,max_x,min_y,max_y);
            changed = 1; AVI_BLOCK_INC(x,y,imagex);
          } /* end of single block */
        } /* end of not term code */
      } /* end of not while exit */
    } /* end of 2 bytes pixel */
    else /* (x11_bytes_pixel == 1) */
    {
      while(!!exitflag)
      {
        code0 =  *dptr++;       code1 =  *dptr++;       block_cnt--;
        if ( ((code1==0) && (code0==0) && !!block_cnt) || (y<0)) exitflag = 1;
        else
        {
          if ((code1 >= 0x84) && (code1 <= 0x87)) /* skip */
          { ULONG skip = ((code1 - 0x84) << 8) + code0;
            block_cnt -= (skip-1); while(skip--) AVI_BLOCK_INC(x,y,imagex);
          } else /* single block encoded */
          { 
            if (code1 >= 0x90) /* 8 color quadrant encoding */
            { UBYTE cA0,cA1,cB0,cB1;
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              cB0 = (UBYTE)map[*dptr++];  cA0 = (UBYTE)map[*dptr++];
              cB1 = (UBYTE)map[*dptr++];  cA1 = (UBYTE)map[*dptr++];
              AVI_CRAM_C4(i_ptr,code0,cA0,cA1,cB0,cB1,row_dec); i_ptr -=row_dec;
              cB0 = (UBYTE)map[*dptr++];  cA0 = (UBYTE)map[*dptr++];
              cB1 = (UBYTE)map[*dptr++];  cA1 = (UBYTE)map[*dptr++];
              AVI_CRAM_C4(i_ptr,code1,cA0,cA1,cB0,cB1,row_dec);
            } 
            else if (code1 < 0x80) /* 2 color encoding */
            { UBYTE clr_A,clr_B;
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              clr_B = (UBYTE)map[*dptr++];   clr_A = (UBYTE)map[*dptr++];
              AVI_CRAM_C2(i_ptr,code0,clr_A,clr_B,row_dec); i_ptr -= row_dec;
              AVI_CRAM_C2(i_ptr,code1,clr_A,clr_B,row_dec);
            }
            else /* 1 color encoding */
            { UBYTE clr = (UBYTE)map[code0];
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              AVI_CRAM_C1(i_ptr,clr,row_dec);
            }
            AVI_MIN_MAX_CHECK(x,y,min_x,max_x,min_y,max_y);
            changed = 1; AVI_BLOCK_INC(x,y,imagex);
          } /* end of single block */
        } /* end of not term code */
      } /* end of not while exit */
    } /* end of 1 bytes pixel */
  } /* end of map is TRUE */
  else
  {
      while(!!exitflag)
      {
        code0 =  *dptr++;       code1 =  *dptr++;       block_cnt--;
        if ( ((code1==0) && (code0==0) && !!block_cnt) || (y<0)) exitflag = 1;
        else
        {
          if ((code1 >= 0x84) && (code1 <= 0x87)) /* skip */
          { ULONG skip = ((code1 - 0x84) << 8) + code0;
            block_cnt -= (skip-1); while(skip--) AVI_BLOCK_INC(x,y,imagex);
          } else /* single block encoded */
          {
            if (code1 >= 0x90) /* 8 color quadrant encoding */
            {
              UBYTE cA0,cA1,cB0,cB1;
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              cB0 = (UBYTE)*dptr++;  cA0 = (UBYTE)*dptr++;
              cB1 = (UBYTE)*dptr++;  cA1 = (UBYTE)*dptr++;
              AVI_CRAM_C4(i_ptr,code0,cA0,cA1,cB0,cB1,row_dec); i_ptr -=row_dec;
              cB0 = (UBYTE)*dptr++;  cA0 = (UBYTE)*dptr++;
              cB1 = (UBYTE)*dptr++;  cA1 = (UBYTE)*dptr++;
              AVI_CRAM_C4(i_ptr,code1,cA0,cA1,cB0,cB1,row_dec);
            } 
            else if (code1 < 0x80) /* 2 color encoding */
            { UBYTE clr_A,clr_B;
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              clr_B = (UBYTE)*dptr++;   clr_A = (UBYTE)*dptr++;
              AVI_CRAM_C2(i_ptr,code0,clr_A,clr_B,row_dec); i_ptr -= row_dec;
              AVI_CRAM_C2(i_ptr,code1,clr_A,clr_B,row_dec);
            } /* end of 2 color */
            else /* 1 color encoding */
            {
              UBYTE clr = (UBYTE)code0;
              UBYTE *i_ptr = (UBYTE *)(image + y * imagex + x);
              AVI_CRAM_C1(i_ptr,clr,row_dec);
            }
            AVI_MIN_MAX_CHECK(x,y,min_x,max_x,min_y,max_y);
            changed = 1; AVI_BLOCK_INC(x,y,imagex);
          } /* end of single block */
        } /* end of not term code */
      } /* end of not while exit */
  }
  if (xa_optimize_flag == TRUE)
  {
    if (changed) { *xs=min_x; *ys=min_y - 3; *xe=max_x + 4; *ye=max_y + 1; }
    else  { *xs = *ys = *xe = *ye = 0; return(ACT_DLTA_NOP); }
  }
  else { *xs = *ys = 0; *xe = imagex; *ye = imagey; }
  if (map_flag) return(ACT_DLTA_MAPD);
  else return(ACT_DLTA_NORM);
}

"

    'AVI_Decode_CRAM' infoPrint.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 5.4.1997 / 16:06:10 / cg"
    "Modified: 11.4.1997 / 14:03:32 / cg"
! !

!AVIReader methodsFor:'helpers'!

alignHeightTo:multiple
    "make height a multiple of the argument"

    height := multiple * ((height + multiple - 1) // multiple).

    "Modified: 5.4.1997 / 14:47:36 / cg"
!

alignTo:multiple
    "make width & height a multiple of the argument"

    width := multiple * ((width + multiple - 1) // multiple).
    height := multiple * ((height + multiple - 1) // multiple).

    "Created: 5.4.1997 / 14:47:54 / cg"
!

alignWidthTo:multiple
    "make height a multiple of the argument"

    width := multiple * ((width + multiple - 1) // multiple).

    "Created: 5.4.1997 / 14:47:16 / cg"
    "Modified: 5.4.1997 / 14:47:41 / cg"
! !

!AVIReader methodsFor:'private-reading'!

getChunk_ISBJ:chunkSize
    "process (ignore) a ISBJ chunk"

    'getChunk_ISBJ -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:19:17 / cg"
!

getChunk_auds:chunkSize
    "process an auds chunk"

    |format channels rate av_bps align size|

    'getChunk_auds' infoPrint.

    format      := inStream nextShortMSB:false.
    channels    := inStream nextShortMSB:false.
    rate        := inStream nextLongMSB:false.
    av_bps      := inStream nextLongMSB:false.
    align       := inStream nextShortMSB:false.
    size        := inStream nextShortMSB:false.

    inStream skip:(chunkSize - 16).

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 5.4.1997 / 00:01:15 / cg"
    "Modified: 5.4.1997 / 14:34:36 / cg"
!

getChunk_auds_wb:chunkSize
    "process (ignore for now) an auds chunk"

    'getChunk_auds_wb -> ' infoPrint.

    self skipChunk:chunkSize

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 5.4.1997 / 13:57:56 / cg"
    "Modified: 5.4.1997 / 14:34:33 / cg"
!

getChunk_avih:chunkSize
    "process an avih chunk"

    |us_frame max_bps pad_gram flags tot_frames init_frames nstreams
     sug_bsize scale rate start length|

    'getChunk_avih' infoPrint.

    chunkSize ~~ 56 ifTrue:[
        self halt:'bad chunk size'.
    ].

    us_frame    := inStream nextLongMSB:false.
    max_bps     := inStream nextLongMSB:false.
    pad_gram    := inStream nextLongMSB:false.
    flags       := inStream nextLongMSB:false.
    tot_frames  := inStream nextLongMSB:false.
    init_frames := inStream nextLongMSB:false.
    nstreams    := inStream nextLongMSB:false.
    sug_bsize   := inStream nextLongMSB:false.
    width       := inStream nextLongMSB:false.
    height      := inStream nextLongMSB:false.
    scale       := inStream nextLongMSB:false.
    rate        := inStream nextLongMSB:false.
    start       := inStream nextLongMSB:false.
    length      := inStream nextLongMSB:false.

    riffReader streamTypes:(OrderedCollection new:nstreams).

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 4.4.1997 / 23:19:37 / cg"
    "Modified: 5.4.1997 / 14:34:30 / cg"
!

getChunk_hdrl:chunkSize
    "process (ignore) a hdrl chunk"

    'getChunk_hdrl -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:18:07 / cg"
!

getChunk_idx1:chunkSize
    "process (ignore) a idx1 chunk"

    'getChunk_idx1 -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:17:53 / cg"
!

getChunk_strf:chunkSize
    "process a strf chunk"

    |sel|

    'getChunk_strf -> ' infoPrint.

    sel := ('getChunk_' , streamType, ':') asSymbolIfInterned.
    (sel isNil or:[(self respondsTo:sel) not]) ifTrue:[
        '[' infoPrint. ('getChunk_' , streamType) infoPrint. '] ' infoPrint.
        sel := #'getChunk_Unknown:'
    ].
    self perform:sel with:chunkSize.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 4.4.1997 / 23:41:09 / cg"
    "Modified: 5.4.1997 / 15:05:00 / cg"
!

getChunk_strh:chunkSize
    "process a strh chunk"

    |fcc_type fcc_handler priority flags rate init_frames streams
     sug_bsize scale start length quality samp_size size|

    'getChunk_strh' infoPrint.

    chunkSize < 48 ifTrue:[
        self halt:'bad chunk size'.
    ].

    fcc_type    := String new:4.
                   inStream nextBytes:4 into:fcc_type.
    fcc_handler := inStream nextLongMSB:true.
    flags       := inStream nextLongMSB:false.
    priority    := inStream nextLongMSB:false.
    init_frames := inStream nextLongMSB:false.
    scale       := inStream nextLongMSB:false.
    rate        := inStream nextLongMSB:false.
    start       := inStream nextLongMSB:false.
    length      := inStream nextLongMSB:false.
    sug_bsize   := inStream nextLongMSB:false.
    quality     := inStream nextLongMSB:false.
    samp_size   := inStream nextLongMSB:false.

    size := chunkSize.
    (size bitTest:1) ifTrue:[
        size := size + 1
    ].
    inStream skip:(size - 48).

    riffReader addStream:fcc_type.
    streamType := fcc_type.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 4.4.1997 / 23:25:54 / cg"
    "Modified: 5.4.1997 / 14:34:23 / cg"
!

getChunk_strl:chunkSize
    "process (ignore) a strl chunk"

    'getChunk_strl -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:18:01 / cg"
!

getChunk_vedt:chunkSize
    "process (ignore) a vedt chunk"

    'getChunk_vedt -> ' infoPrint.

    self skipChunk:chunkSize

    "Created: 5.4.1997 / 15:17:43 / cg"
!

getChunk_vids:chunkSize
    "process a vids chunk"

    |size sz
     width height planes image_size
     xpels_meter ypels_meter num_colors imp_colors
     sel nMore|

    'getChunk_vids -> ' infoPrint.

    sz := chunkSize.
    (sz bitTest:1) ifTrue:[
        sz := sz + 1
    ].
    colorTable := true.

    size        := inStream nextLongMSB:false.
    width       := inStream nextLongMSB:false.
    height      := inStream nextLongMSB:false.
    planes      := inStream nextShortMSB:false.
    depth       := inStream nextShortMSB:false.
    compression := String new:4.
                   inStream nextBytes:4 into:compression.
    image_size  := inStream nextLongMSB:false.
    xpels_meter := inStream nextLongMSB:false.
    ypels_meter := inStream nextLongMSB:false.
    num_colors  := inStream nextLongMSB:false.
    imp_colors  := inStream nextLongMSB:false.
    sz := sz - 40.

    numColors := num_colors.
    (numColors == 0 and:[depth <= 8]) ifTrue:[
        numColors := 1 bitShift:depth.
    ].

    sel := ('setupData_vids_' , compression) asSymbolIfInterned.
    (sel isNil or:[(self respondsTo:sel) not]) ifTrue:[
        '[' infoPrint. ('setupData_vids_' , compression) infoPrint. '] ' infoPrint.
        sel := #'setupData_vids_Unknown'
    ].

    "/ setup compression-specific data
    self perform:sel.

    "/ read a colorTable - if any
    ((depth <= 8) and:[colorTable]) ifTrue:[
        redPalette := ByteArray new:256.
        greenPalette := ByteArray new:256.
        bluePalette := ByteArray new:256.

        1 to:numColors do:[:i |
            sz > 0 ifTrue:[
                bluePalette at:i put:(inStream nextByte).
                greenPalette at:i put:(inStream nextByte).
                redPalette at:i put:(inStream nextByte).
                inStream nextByte. "/ padding
                sz := sz - 4.
            ].
        ]
    ].

    "/ read more compression-specific data
    sel := ('readData_vids2_' , compression) asSymbolIfInterned.
    (sel isNil or:[(self respondsTo:sel) not]) ifTrue:[
    ] ifFalse:[
        nMore := self perform:sel.
        sz := sz  - nMore.
    ].

    inStream skip:sz.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 4.4.1997 / 23:25:54 / cg"
    "Modified: 5.4.1997 / 15:32:10 / cg"
!

getChunk_vids_dc:chunkSize
    "process a vids chunk"

    |sz data sel|

    'getChunk_vids_dc -> ' infoPrint.

    sz := chunkSize.
    (sz bitTest:1) ifTrue:[
        sz := sz + 1
    ].

    sz == 0 ifTrue:[
        "/ NOP wait frame
        ^ self
    ].

    data := ByteArray new:sz.
    inStream nextBytes:sz into:data startingAt:1.

    sel := deltaMethod.
    (self respondsTo:sel) not ifTrue:[
        '[' infoPrint. deltaMethod infoPrint. '] ' infoPrint.
        ^ self
    ].

    self perform:deltaMethod with:data.

    "
     AVIReader fromFile:'/home2/pd_stuff/movies/avi/hangldm.avi'      
    "

    "Created: 5.4.1997 / 01:01:37 / cg"
    "Modified: 5.4.1997 / 15:44:46 / cg"
!

readData_vids2_IJPG
    "more extra data here"

    |offset jsize format cspace|

    'readData_vids2_IJPG' infoPrint.

    offset := inStream nextLongMSB:false.
    jsize := inStream nextLongMSB:false.
    format := inStream nextLongMSB:false.
    cspace := inStream nextLongMSB:false.

    self JFIF_Read_IJPG_Tables.

    ^ 16 + 128.

    "Created: 5.4.1997 / 15:08:04 / cg"
!

readData_vids2_JPEG
    "more extra data here"

    |offset jsize format cspace bits hsubsamp vsubsamp|

    'readData_vids2_IJPG' infoPrint.

    offset := inStream nextLongMSB:false.
    jsize := inStream nextLongMSB:false.
    format := inStream nextLongMSB:false.
    cspace := inStream nextLongMSB:false.
    bits := inStream nextLongMSB:false.
    hsubsamp := inStream nextLongMSB:false.
    vsubsamp := inStream nextLongMSB:false.

    ^ 28.

    "Created: 5.4.1997 / 15:08:43 / cg"
!

setupData_vids_CRAM
    "CRAM specific setup"

    'setupData_vids_CRAM' infoPrint.

    "/ need to be multiple of 4
    self alignTo:4.

    depth == 8 ifTrue:[
        deltaMethod := #AVI_Decode_CRAM:
    ] ifFalse:[
        depth == 16 ifTrue:[
            deltaMethod := #AVI_Decode_CRAM16:
        ] ifFalse:[
"/            'AVI [info]: CRAM but depth ~~ 8/16 format not supported' errorPrintCR.
            UnsupportedFormatErrorSignal raiseErrorString:'CRAM but depth ~~ 8/16'.
        ]
    ]

    "Modified: 5.4.1997 / 15:42:12 / cg"
!

setupData_vids_CVID
    "CVID specific setup"

    'setupData_vids_CVID' infoPrint.

"/    'AVI [info]: Radius Cinepak format not supported' errorPrintCR.
    UnsupportedFormatErrorSignal raiseErrorString:'Radius Cinepak format not supported'.

    "Modified: 5.4.1997 / 15:42:38 / cg"
!

setupData_vids_IJPG
    "IJPG specific setup"

    'setupData_vids_IJPG' infoPrint.

    "/ need to be multiple of 4@2
    self alignWidthTo:4.
    self alignHeightTo:2.

    depth > 8 ifTrue:[
        self QT_Gen_YUV_Tabs.
    ] ifFalse:[
        colorTable := false
    ].
    self jpg_alloc_MCU_bufs:width.

    depth ~~ 24 ifTrue:[
"/    'AVI [info]: IJPG but depth ~~ 24' errorPrintCR.
        UnsupportedFormatErrorSignal raiseErrorString:'IJPG but depth ~~ 24'.
        ^ self
    ].
    deltaMethod := #JFIF_Decode_JPEG:

    "Modified: 5.4.1997 / 15:55:55 / cg"
!

setupData_vids_IV31
    "IV31 specific setup"

    'setupData_vids_IV31' infoPrint.

"/    'AVI [info]: AVI: Intel Indeo Video Codec Not Supported' errorPrintCR.
    UnsupportedFormatErrorSignal raiseErrorString:'AVI: Intel Indeo Video Codec Not Supported'.

    "Created: 5.4.1997 / 15:56:43 / cg"
!

setupData_vids_IV32
    "IV32 specific setup"

    'setupData_vids_IV32' infoPrint.

"/    'AVI [info]: AVI: Intel Indeo Video Codec Not Supported' errorPrintCR.
    UnsupportedFormatErrorSignal raiseErrorString:'AVI: Intel Indeo Video Codec Not Supported'.

    "Created: 5.4.1997 / 15:56:49 / cg"
!

setupData_vids_JPEG
    "JPEG specific setup"

    'setupData_vids_JPEG' infoPrint.

    "/ need to be multiple of 4@2
    self alignWidthTo:4.
    self alignHeightTo:2.

    depth > 8 ifTrue:[
        self QT_Gen_YUV_Tabs.
    ] ifFalse:[
        colorTable := false
    ].
    self jpg_alloc_MCU_bufs:width.

    depth ~~ 8 ifTrue:[
        depth ~~ 24 ifTrue:[
"/        'AVI [info]: JPEG but depth ~~ 8/24' errorPrintCR.
            UnsupportedFormatErrorSignal raiseErrorString:'JPEG but depth ~~ 8/24'.
            ^ self
        ]
    ].
    deltaMethod := #JFIF_Decode_JPEG:

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:55:05 / cg"
!

setupData_vids_MJPG
    "MJPG specific setup"

    'setupData_vids_MJPG' infoPrint.

    UnsupportedFormatErrorSignal raiseErrorString:'MJPG not yet supported'.

    "/ need to be multiple of 4@2
    self alignWidthTo:4.
    self alignHeightTo:2.

    depth > 8 ifTrue:[
        self QT_Gen_YUV_Tabs.
    ] ifFalse:[
        colorTable := false
    ].
    self jpg_alloc_MCU_bufs:width.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:53:08 / cg"
!

setupData_vids_MSVC
    "MSVC specific setup"

    'setupData_vids_MSVC' infoPrint.

    "/ need to be multiple of 4
    self alignTo:4.

    depth == 8 ifTrue:[
        deltaMethod := #AVI_Decode_CRAM:
    ] ifFalse:[
        depth == 16 ifTrue:[
            deltaMethod := #AVI_Decode_CRAM16:
        ] ifFalse:[
"/            'AVI [info]: MSVC but depth ~~ 8/16 format not supported' errorPrintCR.
            UnsupportedFormatErrorSignal raiseErrorString:'MSVC but depth ~~ 8/16'.
        ]
    ]

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:41:56 / cg"
!

setupData_vids_NONE
    "NONE specific setup"

    'setupData_vids_NONE' infoPrint.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:34:25 / cg"
!

setupData_vids_PACK
    "PACK specific setup"

    'setupData_vids_PACK' infoPrint.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:34:31 / cg"
!

setupData_vids_RGB
    "RGB specific setup"

    'setupData_vids_RGB' infoPrint.

    depth == 8 ifTrue:[
        deltaMethod := #AVI_Decode_RGB:
    ] ifFalse:[
        depth == 24 ifTrue:[
            deltaMethod := #AVI_Decode_RGB24:
        ] ifFalse:[
"/            'AVI [info]: RGB but depth ~~ 8/24 format not supported' errorPrintCR.
            UnsupportedFormatErrorSignal raiseErrorString:'RGB but depth ~~ 8/24'.
        ]
    ]

    "Modified: 5.4.1997 / 15:41:56 / cg"
    "Created: 5.4.1997 / 15:48:47 / cg"
!

setupData_vids_RLE4
    "RLE4 specific setup"

    'setupData_vids_RLE4' infoPrint.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:34:38 / cg"
!

setupData_vids_RLE8
    "RLE8 specific setup"

    'setupData_vids_RLE8' infoPrint.

    depth ~~ 8 ifTrue:[
"/        'AVI [info]: RLE8 but depth ~~ 8 format not supported' errorPrintCR.
        UnsupportedFormatErrorSignal raiseErrorString:'RLE8 but depth ~~ 8'.
        ^ self
    ].
    deltaMethod := #AVI_Decode_RLE8:

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:43:22 / cg"
!

setupData_vids_RT21
    "RT21 specific setup"

    'setupData_vids_RT21' infoPrint.

"/    'AVI [info]: AVI: Intel Indeo Video Codec Not Supported' errorPrintCR.
    UnsupportedFormatErrorSignal raiseErrorString:'AVI: Intel Indeo Video Codec Not Supported'.

    "Created: 5.4.1997 / 15:56:37 / cg"
!

setupData_vids_TRAN
    "TRAN specific setup"

    'setupData_vids_TRAN' infoPrint.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:34:53 / cg"
!

setupData_vids_ULTI
    "ULTI specific setup"

    'setupData_vids_ULTI' infoPrint.

    depth == 16 ifTrue:[
        deltaMethod := #AVI_Decode_ULTI:
    ] ifFalse:[
"/        'AVI [info]: ULTI depth ~~ 16 format not supported' errorPrintCR.
        UnsupportedFormatErrorSignal raiseErrorString:'ULTI depth ~~ 16'.
        ^ self.
    ].

    "/ need to be multiple of 8
    self alignTo:8.

    self AVI_ULTI_Gen_YUV.
    self AVI_Ulti_Gen_LTC.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:46:14 / cg"
!

setupData_vids_Unknown
    "ignore an unknown vids chunk"

    'setupData_vids_Unknown' infoPrint.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:32:52 / cg"
!

setupData_vids_XMPG
    "XMPG specific setup"

    'setupData_vids_XMPG' infoPrint.

    "/ need to be multiple of 4
    self alignTo:4.

    self QT_Gen_YUV_Tabs.
    self jpg_alloc_MCU_bufs:width.
    self jpg_setup_samp_limit_table.
    self mpg_init_stuff.

    deltaMethod := #MPG_Decode_I:

    "Modified: 5.4.1997 / 15:49:53 / cg"
!

setupData_vids_YUV9
    "YUV9 specific setup"

    'setupData_vids_YUV9' infoPrint.

    self QT_Gen_YUV_Tabs.
    self jpg_setup_samp_limit_table.

    "/ need to be multiple of 4
    self alignTo:4.

    deltaMethod := #AVI_Decode_YUV9:

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:49:19 / cg"
!

setupData_vids_YVU9
    "YVU9 specific setup"

    'setupData_vids_YVU9' infoPrint.

    self QT_Gen_YUV_Tabs.
    self jpg_setup_samp_limit_table.

    "/ need to be multiple of 4
    self alignTo:4.

    deltaMethod := #AVI_Decode_YUV9:

    "Modified: 5.4.1997 / 15:49:32 / cg"
!

setupData_vids_cvid
    "same as CVID"

    'setupData_vids_cvid' infoPrint.
    compression := 'CVID'.
    ^ self setupData_vids_CVID.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:35:32 / cg"
!

setupData_vids_iv31
    "same as IV31"

    'setupData_vids_iv31' infoPrint.
    compression := 'IV31'.
    ^ self setupData_vids_IV31.

    "Created: 5.4.1997 / 15:29:54 / cg"
    "Modified: 5.4.1997 / 15:35:39 / cg"
!

setupData_vids_iv32
    "same as IV32"

    'setupData_vids_iv32' infoPrint.
    compression := 'IV32'.
    ^ self setupData_vids_IV32.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:35:45 / cg"
!

setupData_vids_jpeg
    "same as JPEG"

    'setupData_vids_jpeg' infoPrint.
    compression := 'JPEG'.
    ^ self setupData_vids_JPEG.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:35:53 / cg"
!

setupData_vids_none
    "same as NONE"

    'setupData_vids_none' infoPrint.
    compression := 'NONE'.
    ^ self setupData_vids_NONE.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:02 / cg"
!

setupData_vids_pack
    "same as PACK"

    'setupData_vids_pack' infoPrint.
    compression := 'PACK'.
    ^ self setupData_vids_PACK.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:08 / cg"
!

setupData_vids_rle4
    "same as RLE4"

    'setupData_vids_rle4' infoPrint.
    compression := 'RLE4'.
    ^ self setupData_vids_RLE4.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:14 / cg"
!

setupData_vids_rle8
    "same as RLE8"

    'setupData_vids_rle8' infoPrint.
    compression := 'RLE8'.
    ^ self setupData_vids_RLE8.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:21 / cg"
!

setupData_vids_rt21
    "same as RT21"

    'setupData_vids_rt21' infoPrint.
    compression := 'RT21'.
    ^ self setupData_vids_RT21.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:28 / cg"
!

setupData_vids_tran
    "same as TRAN"

    'setupData_vids_tran' infoPrint.
    compression := 'TRAN'.
    ^ self setupData_vids_TRAN.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:35 / cg"
!

setupData_vids_xmpg
    "same as XMPG"

    'setupData_vids_xmpg' infoPrint.
    compression := 'XMPG'.
    ^ self setupData_vids_XMPG.

    "Created: 5.4.1997 / 15:29:55 / cg"
    "Modified: 5.4.1997 / 15:36:43 / cg"
!

skipChunk:chunkSize
    "skip a chunk"

    riffReader skipChunk:chunkSize
! !

!AVIReader methodsFor:'reading'!

fromStream:aStream
    "read a AVI-movie from aStream. Return a frame sequence."

    inStream := aStream.

    riffReader := RIFFReader new.
    riffReader client:self.
    riffReader processStream:inStream.

    "/ return the first frame as image

    "/ ATTENTION: the following is not true:

    colorMap := MappedPalette 
                    redVector:redPalette 
                    greenVector:greenPalette 
                    blueVector:bluePalette.

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).

    "
     AVIReader readFile:'/phys/exept/home/pd_stuff/movies/avi/drlair.avi'.      
     AVIReader readFile:'/phys/exept/home/pd_stuff/movies/avi/hangldm.avi'.      
    "

    "Created: 4.4.1997 / 22:35:53 / cg"
    "Modified: 24.6.1997 / 15:58:29 / cg"
! !

!AVIReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/AVIReader.st,v 1.14 2003-11-19 15:38:28 cg Exp $'
! !


AVIReader initialize!
