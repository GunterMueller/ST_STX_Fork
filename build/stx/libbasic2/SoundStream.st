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
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

FileStream subclass:#SoundStream
	instanceVariableNames:'sampleRate numberOfChannels bitsPerSample audioFormat handle1
		handle2 bufferOffset bufferSize'
	classVariableNames:'UnsupportedOperationSignal'
	poolDictionaries:''
	category:'Streams-External'
!

!SoundStream primitiveDefinitions!
%{

#include "stxOSDefs.h"

#ifdef __win32__
# ifndef NO_SOUND
#  define xxxUSE_WIN32_DIRECTSOUND
#  define USE_WIN32_WAVESOUND
# endif
#endif

#ifdef __iris__
# ifndef IRIX5
#  define USE_IRIS_AUDIO
# endif
#endif

#ifndef USE_IRIS_AUDIO
# ifndef USE_ALSA_AUDIO
#  ifdef LINUX
#   define USE_DEV_AUDIO
#  endif
# endif
#endif

#ifdef USE_IRIS_AUDIO
# define IRIS_AUDIO
# include <audio.h>
# define __ALportVal(o)  (ALport)(__externalAddressVal(o))
# define alPort handle1
#endif

#ifdef USE_ALSA_AUDIO
# ifdef LINUX
#  define ALSA_AUDIO
#  include <alsa/asoundlib.h>
#  define MAX_NR_OF_CHANNELS 8
#  define DEBUG_SOUND
#  define readHandle handle1
#  define writeHandle handle2
# endif
#endif

#ifdef USE_DEV_AUDIO
# ifdef LINUX
#  include <stdio.h>
#  include <sys/soundcard.h>
#  define DEV_AUDIO_DEFAULT_FREQ (8000)
#  define DEV_AUDIO_DEFAULT_BUFFERSIZE (16384)
#  define DEV_AUDIO
# endif

# ifdef FREEBSD
#  include <stdio.h>
#  include <sys/time.h>
#  include <sys/ioctl.h>
#  include <machine/pcaudioio.h>
#  define DEV_AUDIO_DEFAULT_FREQ (8000)
#  define DEV_AUDIO_DEFAULT_BUFFERSIZE (16384)
#  define DEV_AUDIO
# endif

# if defined(sunos) || defined(solaris)
#  include <stdio.h>
#  ifdef solaris
#   include <sys/audioio.h>
#  else
#   include <sun/audioio.h>
#  endif
#  define DEV_AUDIO_DEFAULT_FREQ (8000)
#  define DEV_AUDIO_DEFAULT_BUFFERSIZE (16384)
#  define DEV_AUDIO
# endif

# if defined(hpux)
#  include <stdio.h>
#  include <sys/ioctl.h>
#  include <sys/inode.h>
#  include <sys/audio.h>
#  include <sys/time.h>
#  include <unistd.h>
#  define DEV_AUDIO_DEFAULT_FREQ (22050)
#  define DEV_AUDIO_DEFAULT_BUFFERSIZE (16384)
#  define DEV_AUDIO
# endif
#endif /* USE_DEV_AUDIO */

#ifndef __win32__
# ifndef O_WRONLY
#  include <sys/fcntl.h>
# endif
# include <errno.h>
#endif

#ifdef __win32__
# define _WIN32

# undef INT
# undef Array
# undef Number
# undef Method
# undef Point
# undef Rectangle
# undef Block
# undef String
# undef Message
# undef Object
# undef Context
# undef Time
# undef Date
# undef Process
# undef Processor
# undef Set
# undef Signal
# undef Delay

/* # include <stdarg.h> /* */
# include <stdio.h> /* */
# include <windows.h>

# ifdef USE_WIN32_DIRECTSOUND
#  define WIN32_DIRECTSOUND
#  define CINTERFACE
#  include "dsound.h"
#  define __DirectSoundVal(o) (LPDIRECTSOUND)(__externalAddressVal(o))
#  define __DSBufferVal(o)    (LPDIRECTSOUNDBUFFER)(__externalAddressVal(o))

#  define RT_BUFFER_SIZE 4096
#  define NBUFS          4

#  define pDirectSound handle1
#  define pDSBuffer    handle2

# else /* USE WAVE... */
#  ifdef USE_WIN32_WAVESOUND
#   define WIN32_WAVE
#   define __WaveHandleVal(o)    (HWAVEOUT)(__externalAddressVal(o))
#   define MAXBUF      10        /* Maximum number of buffers */
#   define DATALEN     2048      /* Size of wave data buffer */

struct buf {
    WAVEHDR hdr;                /* Wave data header */
    char data[DATALEN];         /* Actual wave data */
    struct buf *next;           /* Next buffer in free list */
};

static struct buf *free_list = NULL;      /* List of available buffers */
static CRITICAL_SECTION free_list_lock;
static int free_buffers = 0;             /* Number of buffers in free list */
static int total_buffers = 0;            /* Total number of buffers allocated */
static HANDLE free_buffer_event;         /* Automatic-reset event triggered whenever */

#   define waveHandle handle1

#  endif /* USE_WIN32_WAVESOUND */
# endif /* USE_WIN32_DIRECTSOUND */

# ifdef __DEF_Array
#  define Array __DEF_Array
# endif
# ifdef __DEF_Number
#  define Number __DEF_Number
# endif
# ifdef __DEF_Method
#  define Method __DEF_Method
# endif
# ifdef __DEF_Point
#  define Point __DEF_Point
# endif
# ifdef __DEF_Block
#  define Block __DEF_Block
# endif
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Object
#  define Object __DEF_Object
# endif
# ifdef __DEF_Context
#  define Context __DEF_Context
# endif
# ifdef __DEF_Time
#  define Time __DEF_Time
# endif
# ifdef __DEF_Date
#  define Date __DEF_Date
# endif
#ifdef __DEF_Process
# define Process __DEF_Process
#endif
#ifdef __DEF_Processor
# define Processor __DEF_Processor
#endif
#ifdef __DEF_Set
# define Set __DEF_Set
#endif
#ifdef __DEF_Signal
# define Signal __DEF_Signal
#endif
#ifdef __DEF_Delay
# define Delay __DEF_Delay
#endif

# define INT  STX_INT
# define UINT STX_UINT

#endif /* __win32__ */

#ifdef DEBUG_SOUND
# define DPRINTF(x) console_printf x
#else
# define DPRINTF(x) /* as nothing */
#endif

%}
! !

!SoundStream primitiveFunctions!
%{
#ifdef WIN32_WAVE

static void CALLBACK
waveCallBack(HWAVE waveHandle, UINT msg, DWORD_PTR inst, DWORD_PTR p1, DWORD_PTR p2)
{
    if (msg == MM_WOM_DONE) {
	struct buf *bp = (struct buf *)p1;

	EnterCriticalSection(&free_list_lock);
	bp->next = free_list;
	free_list = bp;
	free_buffers++;
	SetEvent(free_buffer_event);
	LeaveCriticalSection(&free_list_lock);
    }
}

#endif /* WIN32_WAVE */

%}
! !

!SoundStream class methodsFor:'documentation'!

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
    Preliminary (unfinished) interface to audio device.
    Currently works with LINUXs or SUNs /dev/audio driver and
    IRIX (indy).
    On iris, the default setup is for 8 bit mono
    so I can play the standard sound files I have here.
    It needs much more work, for stereo, different sampling rates etc.

    This is an experimental class - its interface & implementation
    may change in the future.

    [author:]
	Claus Gittinger
"
! !

!SoundStream class methodsFor:'initialization'!

initialize
    UnsupportedOperationSignal isNil ifTrue:[
	UnsupportedOperationSignal := StreamError newSignalMayProceed:true.
	UnsupportedOperationSignal nameClass:self message:#unsupportedOperationSignal.
	UnsupportedOperationSignal notifierString:'unsupported operation'.
    ]
! !

!SoundStream class methodsFor:'instance creation'!

readWrite
    "create and return a new soundStream for readWrite (i.e. filtering)"

    |newStream|
    newStream := (self basicNew) initialize.
    newStream openForReadWrite isNil ifTrue:[^nil].
    ^ newStream

    "SoundStream readWrite"
!

reading
    "create and return a new soundStream for reading (i.e. recording)"

    |newStream|
    newStream := (self basicNew) initialize.
    newStream openForReading isNil ifTrue:[^nil].
    ^ newStream

    "SoundStream reading"

    "Modified: / 12.12.1997 / 16:51:56 / cg"
!

writing
    "create and return a new soundStream for writing (i.e. playback)"

    |newStream|

    newStream := (self basicNew) initialize.
    newStream openForWriting isNil ifTrue:[^nil].
    ^ newStream

    "
     SoundStream writing
    "

    "Created: / 17.11.1995 / 17:25:42 / cg"
    "Modified: / 12.12.1997 / 16:51:38 / cg"
!

writing16Bit
    "just an example, has never been tried (I also
     have no samples for this ... leave it as an exercise)"

    |newStream|

    newStream := (self basicNew) initialize.
    newStream bitsPerSample:16.
    newStream openForWriting isNil ifTrue:[^nil].
    ^ newStream

    "SoundStream writing16Bit"

    "Modified: / 12.12.1997 / 16:51:49 / cg"
    "Created: / 21.12.1998 / 00:02:17 / cg"
!

writing16BitStereo
    "just an example, has never been tried (I also
     have no samples for this ... leave it as an exercise)"

    |newStream|

    OperatingSystem getCPUType ~= 'irix' ifTrue:[
	self error:'unsupported audio mode'.
    ].
    newStream := (self basicNew) initialize.
    newStream bitsPerSample:16.
    newStream numberOfChannels:2.
    newStream openForWriting isNil ifTrue:[^nil].
    ^ newStream

    "SoundStream writing16BitStereo"

    "Modified: / 12.12.1997 / 16:51:49 / cg"
! !

!SoundStream class methodsFor:'Signal constants'!

unsupportedOperationSignal
    ^ UnsupportedOperationSignal
! !

!SoundStream class methodsFor:'conversion helpers'!

linear16ToUlaw:a16bitSignedValue
    "given a 16it signed value, encode into uLaw byte"

    |absVal sign exp mantissa byte|

%{
    /*
     * so heavily used when playing sounds ...
     * made it a primitive.
     */
    if (__isSmallInteger(a16bitSignedValue)) {
	int __sign = 0;
	int __absVal = __intVal(a16bitSignedValue);
	int __exp, __mantissa, __byte;
	static char __uLawExp[] =
		    {
			0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,
			5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
			6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
			7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
			7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
			7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
			7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
		    };

	if (__absVal < 0) {
	    if (__absVal <= -32256) {
		RETURN (__MKSMALLINT(0));
	    }
	    __absVal = -__absVal;
	    __sign = 0x80;
	} else {
	    if (__absVal >= 32256) {
		RETURN (__MKSMALLINT(128));
	    }
	}

	__exp = __uLawExp[__absVal >> 8];
	__mantissa = (__absVal >> (__exp+3)) & 0xF;
	__byte = ~(__sign | (__exp<<4) | __mantissa) & 0xFF;
	RETURN (__MKSMALLINT(__byte));
    }
%}.
    "/
    "/ fallback for non-integral argument
    "/
    a16bitSignedValue isInteger ifFalse:[
	^ self uLawToLinear16:a16bitSignedValue asInteger
    ].
    ^ 0

    "
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:0)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:32256)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:-32256)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:32767)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:-32767)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:100)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:-100)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:104)
     SoundStream uLawToLinear16:(SoundStream linear16ToUlaw:-104)
    "

    "Modified: / 9.12.1997 / 16:46:24 / cg"
!

uLawToLinear16:uLawValue
    "given a uLaw byte, return the decoded signed 16bit value.
     Currently unused - but will be"

    ^ #(
	"0  "     -32256
	"1  "     -31228
	"2  "     -30200
	"3  "     -29172
	"4  "     -28143
	"5  "     -27115
	"6  "     -26087
	"7  "     -25059
	"8  "     -24031
	"9  "     -23002
	"10 "     -21974
	"11 "     -20946
	"12 "     -19918
	"13 "     -18889
	"14 "     -17861
	"15 "     -16833
	"16 "     -16062
	"17 "     -15548
	"18 "     -15033
	"19 "     -14519
	"20 "     -14005
	"21 "     -13491
	"22 "     -12977
	"23 "     -12463
	"24 "     -11949
	"25 "     -11435
	"26 "     -10920
	"27 "     -10406
	"28 "     -9892
	"29 "     -9378
	"30 "     -8864
	"31 "     -8350
	"32 "     -7964
	"33 "     -7707
	"34 "     -7450
	"35 "     -7193
	"36 "     -6936
	"37 "     -6679
	"38 "     -6422
	"39 "     -6165
	"40 "     -5908
	"41 "     -5651
	"42 "     -5394
	"43 "     -5137
	"44 "     -4880
	"45 "     -4623
	"46 "     -4365
	"47 "     -4108
	"48 "     -3916
	"49 "     -3787
	"50 "     -3659
	"51 "     -3530
	"52 "     -3402
	"53 "     -3273
	"54 "     -3144
	"55 "     -3016
	"56 "     -2887
	"57 "     -2759
	"58 "     -2630
	"59 "     -2502
	"60 "     -2373
	"61 "     -2245
	"62 "     -2116
	"63 "     -1988
	"64 "     -1891
	"65 "     -1827
	"66 "     -1763
	"67 "     -1698
	"68 "     -1634
	"69 "     -1570
	"70 "     -1506
	"71 "     -1441
	"72 "     -1377
	"73 "     -1313
	"74 "     -1249
	"75 "     -1184
	"76 "     -1120
	"77 "     -1056
	"78 "     -992
	"79 "     -927
	"80 "     -879
	"81 "     -847
	"82 "     -815
	"83 "     -783
	"84 "     -751
	"85 "     -718
	"86 "     -686
	"87 "     -654
	"88 "     -622
	"89 "     -590
	"90 "     -558
	"91 "     -526
	"92 "     -494
	"93 "     -461
	"94 "     -429
	"95 "     -397
	"96 "     -373
	"97 "     -357
	"98 "     -341
	"99 "     -325
	"100"     -309
	"101"     -293
	"102"     -277
	"103"     -261
	"104"     -245
	"105"     -228
	"106"     -212
	"107"     -196
	"108"     -180
	"109"     -164
	"110"     -148
	"111"     -132
	"112"     -120
	"113"     -112
	"114"     -104
	"115"     -96
	"116"     -88
	"117"     -80
	"118"     -72
	"119"     -64
	"120"     -56
	"121"     -48
	"122"     -40
	"123"     -32
	"124"     -24
	"125"     -16
	"126"     -8
	"127"     0
	"128"     32256
	"129"     31228
	"130"     30200
	"131"     29172
	"132"     28143
	"133"     27115
	"134"     26087
	"135"     25059
	"136"     24031
	"137"     23002
	"138"     21974
	"139"     20946
	"140"     19918
	"141"     18889
	"142"     17861
	"143"     16833
	"144"     16062
	"145"     15548
	"146"     15033
	"147"     14519
	"148"     14005
	"149"     13491
	"150"     12977
	"151"     12463
	"152"     11949
	"153"     11435
	"154"     10920
	"155"     10406
	"156"     9892
	"157"     9378
	"158"     8864
	"159"     8350
	"160"     7964
	"161"     7707
	"162"     7450
	"163"     7193
	"164"     6936
	"165"     6679
	"166"     6422
	"167"     6165
	"168"     5908
	"169"     5651
	"170"     5394
	"171"     5137
	"172"     4880
	"173"     4623
	"174"     4365
	"175"     4108
	"176"     3916
	"177"     3787
	"178"     3659
	"179"     3530
	"180"     3402
	"181"     3273
	"182"     3144
	"183"     3016
	"184"     2887
	"185"     2759
	"186"     2630
	"187"     2502
	"188"     2373
	"189"     2245
	"190"     2116
	"191"     1988
	"192"     1891
	"193"     1827
	"194"     1763
	"195"     1698
	"196"     1634
	"197"     1570
	"198"     1506
	"199"     1441
	"200"     1377
	"201"     1313
	"202"     1249
	"203"     1184
	"204"     1120
	"205"     1056
	"206"     992
	"207"     927
	"208"     879
	"209"     847
	"210"     815
	"211"     783
	"212"     751
	"213"     718
	"214"     686
	"215"     654
	"216"     622
	"217"     590
	"218"     558
	"219"     526
	"220"     494
	"221"     461
	"222"     429
	"223"     397
	"224"     373
	"225"     357
	"226"     341
	"227"     325
	"228"     309
	"229"     293
	"230"     277
	"231"     261
	"232"     245
	"233"     228
	"234"     212
	"235"     196
	"236"     180
	"237"     164
	"238"     148
	"239"     132
	"240"     120
	"241"     112
	"242"     104
	"243"     96
	"244"     88
	"245"     80
	"246"     72
	"247"     64
	"248"     56
	"249"     48
	"250"     40
	"251"     32
	"252"     24
	"253"     16
	"254"     8
	"255"     0
    ) at:(uLawValue + 1)

    "Modified: / 9.12.1997 / 16:34:17 / cg"
! !

!SoundStream class methodsFor:'default values'!

defaultAudioFormat
    OperatingSystem isMSWINDOWSlike ifTrue:[
	^ #S16
    ].
    ^ #U8
!

defaultBitsPerSample
    "minimum, supported by all audio systems"

    OperatingSystem isMSWINDOWSlike ifTrue:[
	^ 16
    ].
    ^ 8
!

defaultNumberOfChannels
    "minimum, supported by all audio systems"

    ^ 1
!

defaultSampleRate
    "minimum, supported by all audio systems"

%{
#ifdef DEV_AUDIO
    RETURN (__MKSMALLINT(DEV_AUDIO_DEFAULT_FREQ));
#endif
%}.

    ^ 8000
! !

!SoundStream class methodsFor:'playing'!

playSoundFile:aFilename
    "play a soundFile"

    |inStream soundStream count totalCount buffer startTime playTime delayedTime waitTime|

    inStream := aFilename asFilename readStream.
    inStream isNil ifTrue:[self error:'cannot open'].

    soundStream := self writing.
    soundStream isNil ifTrue:[self error:'cannot open sound device'].

    startTime := Timestamp now.
    totalCount := 0.

    buffer := ByteArray new:4096.
    [(count := inStream nextBytesInto:buffer) > 0] whileTrue:[
	totalCount := totalCount + count.
	soundStream nextPutBytes:count from:buffer.
    ].

    inStream close.
    soundStream commit.

    "/
    "/ at least the linux audio driver behaves funny, if we close too early ...
    "/
    playTime := totalCount / soundStream sampleRate.
    delayedTime := Timestamp now secondDeltaFrom: startTime.
    waitTime := playTime - delayedTime + 0.1.

    (Delay forSeconds:waitTime) wait.

    soundStream close.

    "
     SoundStream playSoundFile:'/usr/local/lib/sounds/laugh.snd'
     SoundStream playSoundFile:'/usr/local/lib/sounds/spacemusic.snd'
    "

    "Created: 17.11.1995 / 17:25:30 / cg"
    "Modified: 17.11.1995 / 17:45:40 / cg"
! !

!SoundStream methodsFor:'catching invalid methods'!

pathName:filename
    "catch pathname access - its fixed here"

    self shouldNotImplement
!

pathName:filename in:aDirectory
    "catch pathname access - its fixed here"

    self shouldNotImplement
! !

!SoundStream methodsFor:'mode setting'!

bitsPerSample
    "return the number of bits per sample - usually 8"

    ^ bitsPerSample
!

bitsPerSample:aNumber
    "set the number of bits per sample"

    bitsPerSample := aNumber
!

numberOfChannels
    "return the number of channels (1 or 2; usually 1)"

    ^ numberOfChannels
!

numberOfChannels:aNumber
    "set the number of channels"

    numberOfChannels := aNumber
!

sampleRate
    "return the sample rate"

    ^ sampleRate
!

sampleRate:aNumber
    "set the sample rate in hertz - on some
     devices, this is a nop"

    self setSampleRate:aNumber.
! !

!SoundStream methodsFor:'private'!

dumpSettings
    "debugging interface - dump the current settings"

    |fd blockSize speed channels stereo format|

    fd := self fileDescriptor.
    fd isNil ifTrue:[
	self errorNotOpen.
	^ nil
    ].
    audioFormat == #S16 ifTrue:[
	UninterpretedBytes isBigEndian ifTrue:[
	    audioFormat := #S16_BE
	] ifFalse:[
	    audioFormat := #S16_LE
	]
    ].
    audioFormat == #U16 ifTrue:[
	UninterpretedBytes isBigEndian ifTrue:[
	    audioFormat := #U16_BE
	] ifFalse:[
	    audioFormat := #U16_LE
	]
    ].

%{
    int f = __intVal(fd);
    int __blockSize = -1;
    int __speed = -1;
    int __channels = __intVal(__INST(numberOfChannels));
    int __stereo = __channels > 1;
    int __format = -1;

    if (0) {
    }
    else if (__INST(audioFormat) == @symbol(MU_LAW)) {
#  ifdef AFMT_MU_LAW
	__format = AFMT_MU_LAW;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(A_LAW)) {
#  ifdef AFMT_A_LAW
	__format = AFMT_A_LAW;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(IMA_ADPCM)) {
#  ifdef AFMT_IMA_ADPCM
	__format = AFMT_IMA_ADPCM;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(U8)) {
#  ifdef AFMT_U8
	__format = AFMT_U8;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(S16_LE)) {
#  ifdef AFMT_S16_LE
	__format = AFMT_S16_LE;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(S16_BE)) {
#  ifdef AFMT_S16_BE
	__format = AFMT_S16_BE;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(S8)) {
#  ifdef AFMT_S8
	__format = AFMT_S8;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(U16_LE)) {
#  ifdef AFMT_U16_LE
	__format = AFMT_U16_LE;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(U16_BE)) {
#  ifdef AFMT_U16_BE
	__format = AFMT_U16_BE;
#  endif
    }
    else if (__INST(audioFormat) == @symbol(MPEG)) {
#  ifdef AFMT_MPEG
	__format = AFMT_MPEG;
#  endif
    }

#if defined(DEV_AUDIO)
    channels = nil;
    blockSize = nil;
    stereo = nil;
    speed = nil;

# if defined(SNDCTL_DSP_GETBLKSIZE)
    if (ioctl(f, SNDCTL_DSP_GETBLKSIZE, &__blockSize) >= 0) {
	blockSize = __MKSMALLINT(__blockSize);
    }
# endif
# if defined(SNDCTL_DSP_CHANNELS)
    if (ioctl(f, SNDCTL_DSP_CHANNELS, &__channels) >= 0) {
	channels = __MKSMALLINT(__channels);
	stereo = __MKSMALLINT(__channels > 1);
    }
# else
#  if defined(SNDCTL_DSP_STEREO)
    if (ioctl(f, SNDCTL_DSP_STEREO, &__stereo) >= 0) {
	stereo = __MKSMALLINT(__stereo);
    }
#  endif
# endif
# if defined(SNDCTL_DSP_SPEED)
    if (ioctl(f, SNDCTL_DSP_SPEED, &__speed) >= 0) {
	speed = __MKSMALLINT(__speed);
    }
# endif
# if defined(SNDCTL_DSP_GETFMT)
    if (ioctl(f, SNDCTL_DSP_GETFMT, &__format) >= 0) {
	format = __MKSMALLINT(__format);
    }
# else
#  if defined(SNDCTL_DSP_SETFMT) && defined(AFMT_QUERY)
    __format = AFMT_QUERY;
    if (ioctl(f, SNDCTL_DSP_SETFMT, &__format) >= 0) {
	switch (__format) {
#ifdef AFMT_MU_LAW
	    case AFMT_MU_LAW:
		format = @symbol(MU_LAW);
		break;
#endif
#ifdef AFMT_A_LAW
	    case AFMT_A_LAW:
		format = @symbol(A_LAW);
		break;
#endif
#ifdef AFMT_U8
	    case AFMT_U8:
		format = @symbol(U8);
		break;
#endif
#ifdef AFMT_S8
	    case AFMT_S8:
		format = @symbol(S8);
		break;
#endif
#ifdef AFMT_S16_LE
	    case AFMT_S16_LE:
		format = @symbol(S16_LE);
		break;
#endif
#ifdef AFMT_S16_BE
	    case AFMT_S16_BE:
		format = @symbol(S16_BE);
		break;
#endif
#ifdef AFMT_U16_LE
	    case AFMT_U16_LE:
		format = @symbol(U16_LE);
		break;
#endif
#ifdef AFMT_U16_BE
	    case AFMT_U16_BE:
		format = @symbol(U16_BE);
		break;
#endif
#ifdef AFMT_MPEG
	    case AFMT_MPEG:
		format = @symbol(MPEG);
		break;
#endif
	    default:
		format = nil;
	}
    }
#  endif
# endif
#endif /* DEV_AUDIO */
%}.
    format notNil ifTrue:[
	Transcript show:'format: '; showCR:format
    ].
    blockSize notNil ifTrue:[
	Transcript show:'blockSize: '; showCR:blockSize
    ].
    speed notNil ifTrue:[
	Transcript show:'speed: '; showCR:speed
    ].
    channels notNil ifTrue:[
	Transcript show:'channels: '; showCR:channels
    ].
    stereo notNil ifTrue:[
	Transcript show:'stereo: '; showCR:stereo
    ].

    Transcript show:'supported audioFormats: '; showCR:(self supportedAudioFormats).

    "
     self writing dumpSettings; close
    "
!

initialize
    "initialize for least common mode"

    super initialize.
    "/ transparent
    eolMode := nil.
    buffered := false.
    binary := true.
    bitsPerSample := self class defaultBitsPerSample.
    audioFormat := self class defaultAudioFormat.
    numberOfChannels := self class defaultNumberOfChannels.
    sampleRate := self class defaultSampleRate.
    pathName := nil.

    OperatingSystem isUNIXlike ifTrue:[
	'/dev/audio' asFilename exists ifTrue:[
	    "/
	    "/ sunos or linux
	    "/
	    pathName := '/dev/audio'.
	].
    ].

    "Created: 17.11.1995 / 17:28:14 / cg"
!

resetSoundCard
    "debugging interface - reset the soundCard"

    |fd|

    handle notNil ifTrue:[
	fd := self fileDescriptor.
	fd isNil ifTrue:[
	self errorNotOpen.
	    ^ nil
	]
    ].
%{
    int f = __intVal(fd);
    int __dummy;

#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd)) {
# if defined(SNDCTL_DSP_RESET)
	if (ioctl(f, SNDCTL_DSP_RESET, &__dummy) >= 0) {
	    RETURN (self);
	}
# endif
    }
#endif /* DEV_AUDIO */
%}.
    ^ UnsupportedOperationSignal raise

    "
     self writing resetSoundCard; dumpSettings; close
    "
!

setAudioFormat:aSymbol
    "set the format of the audio data as specified by aSymbol.
     Returns true if sucessfull - may fail with some formats on many sound devices."

    |fd|

    handle notNil ifTrue:[
	fd := self fileDescriptor.
	fd isNil ifTrue:[
	    self errorNotOpen.
	    ^ nil
	]
    ].
%{
    OBJ sym = aSymbol;

    if (__INST(audioFormat) == sym) {
	RETURN (self);
    }

#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd)) {
	int f = __intVal(fd);
	int __fmt = 0, __fmtWant;
	union {
	    unsigned short us;
	    unsigned char ub[2];
	} u;

	if (__isSymbol(sym)) {
	    if (sym == @symbol(U16)) {
		u.us = 0x1234;
		if (u.ub[0] == 0x34) {
/* printf("U16_LE\n"); */
		    sym = @symbol(U16_LE);
		} else {
/* printf("U16_BE\n"); */
		    sym = @symbol(U16_BE);
		}
	    } else if (sym == @symbol(S16)) {
		u.us = 0x1234;
		if (u.ub[0] == 0x34) {
/* printf("S16_LE\n"); */
		   sym = @symbol(S16_LE);
		} else {
/* printf("S16_BE\n"); */
		   sym = @symbol(S16_BE);
		}
	    }

	    if (0) {
# ifdef AFMT_MU_LAW
	    } else if (sym == @symbol(MU_LAW)) {
		__fmt = AFMT_MU_LAW;
# endif
# ifdef AFMT_A_LAW
	    } else if (sym == @symbol(A_LAW)) {
		__fmt = AFMT_A_LAW;
# endif
# ifdef AFMT_IMA_ADPCM
	    } else if (sym == @symbol(IMA_ADPCM)) {
		__fmt = AFMT_IMA_ADPCM;
# endif
# ifdef AFMT_U8
	    } else if (sym == @symbol(U8)) {
		__fmt = AFMT_U8;
# endif
# ifdef AFMT_S8
	    } else if (sym == @symbol(S8)) {
		__fmt = AFMT_S8;
# endif
# ifdef AFMT_U16_LE
	    } else if (sym == @symbol(U16_LE)) {
		__fmt = AFMT_U16_LE;
# endif
# ifdef AFMT_U16_BE
	    } else if (sym == @symbol(U16_BE)) {
		__fmt = AFMT_U16_BE;
# endif
# ifdef AFMT_S16_LE
	    } else if (sym == @symbol(S16_LE)) {
		__fmt = AFMT_S16_LE;
# endif
# ifdef AFMT_S16_BE
	    } else if (sym == @symbol(S16_BE)) {
		__fmt = AFMT_S16_BE;
# endif
# ifdef AFMT_MPEG
	    } else if (sym == @symbol(MPEG)) {
		__fmt = AFMT_MPEG;
# endif

# ifdef AUDIO_FORMAT_LINEAR16BIT
	    } else if (sym == @symbol(S16)) {
		__fmt = AUDIO_FORMAT_LINEAR16BIT;
# endif
# ifdef AUDIO_FORMAT_ULAW
	    } else if (sym == @symbol(MU_LAW)) {
		__fmt = AUDIO_FORMAT_ULAW;
# endif
# ifdef AUDIO_FORMAT_ALAW
	    } else if (sym == @symbol(A_LAW)) {
		__fmt = AUDIO_FORMAT_ALAW;
# endif
	    } else {
		console_fprintf(stderr, "bad format: %s\n", __stringVal(sym));
		goto bad;
	    }
	}

# ifdef SNDCTL_DSP_SETFMT
	__fmtWant = __fmt;

	if (ioctl(f, SNDCTL_DSP_SETFMT, &__fmt) >= 0) {
	    if (__fmt == __fmtWant) {
		__INST(audioFormat) = sym;
		RETURN (self);
	    } else {
		/* console_fprintf(stderr, "want: %x; got: %x\n", __fmtWant, __fmt); */
	    }
	} else {
		/* console_fprintf(stderr, "got err-ret from setFmp %x\n", __fmt); */
	}
# else
#  ifdef AUDIO_SET_DATA_FORMAT /* hpux */
	if (ioctl (f, AUDIO_SET_DATA_FORMAT, __fmt)) {
	    /* console_fprintf(stderr, "got err-ret from AUDIO_SET_DATA_FORMAT\n"); */
	}
#  endif
# endif /* SNDCTL_DSP_SETFMT */


bad: ;
    }
#endif /* DEV_AUDIO */

%}.
    ^ UnsupportedOperationSignal raise

    "
     self writing dumpSettings; close
     self writing setAudioFormat:#'MU_LAW'; close
     self writing setAudioFormat:#'U8'; dumpSettings; close
     self writing setAudioFormat:#'MPEG'; dumpSettings; close
    "
!

setChannels:nChannels
    "set the number of channels (1 -> mono; 2 -> stereo).
     Returns true if sucessfull - may fail with many sound devices."

    |fd|

    handle notNil ifTrue:[
	fd := self fileDescriptor.
	fd isNil ifTrue:[
	    self errorNotOpen.
	    ^ nil
	]
    ].
%{

#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd) && __isSmallInteger(nChannels)) {
	int f = __intVal(fd);
	int __nCh = __intVal(nChannels);

# if defined(SNDCTL_DSP_STEREO)
	if ((__nCh == 1) || (__nCh == 2)) {
	    int __stereo = (__nCh == 2) ? 1 : 0;

	    if (ioctl(f, SNDCTL_DSP_STEREO, &__stereo) >= 0) {
		if (__stereo == 0) {
		    __INST(numberOfChannels) = __MKSMALLINT(1);
		} else {
		    __INST(numberOfChannels) = __MKSMALLINT(2);
		}
		RETURN (self);
	    }
	}
# else
#  if defined(SOUND_PCM_WRITE_CHANNELS)
	if (ioctl(f, SOUND_PCM_WRITE_CHANNELS, &__nCh) >= 0) {
	    __INST(numberOfChannels) = nChannels;
	    RETURN (self);
	}
#  else
#   ifdef AUDIO_SET_CHANNELS /* hpux */
	if (ioctl (f, AUDIO_SET_CHANNELS, __nCh)) {
	    /* console_fprintf(stderr, "got err-ret from AUDIO_SET_CHANNELS\n"); */
	    __INST(numberOfChannels) = nChannels;
	    RETURN (self);
	}
#   endif
#  endif
# endif
    }
#endif
%}.
    ^ UnsupportedOperationSignal raise

    "
     self writing setChannels:2; dumpSettings; close
     self writing setChannels:2; setSampleRate:10000; dumpSettings; close
     self writing setChannels:2; setSampleRate:40000; dumpSettings; close
    "
!

setFragmentSize:blockSize
    "set the soundDrivers fragmentSize.
     Returns true if sucessfull - may fail with many sound devices."

    |fd|

    handle notNil ifTrue:[
	fd := self fileDescriptor.
	fd isNil ifTrue:[
	    self errorNotOpen.
	    ^ nil
	]
    ].
%{
    int f = __intVal(fd);
    int __blockSize = 0;

#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd) && __isSmallInteger(blockSize)) {
	__blockSize = __intVal(blockSize);
# if defined(SNDCTL_DSP_SETFRAGMENT)
	if (ioctl(f, SNDCTL_DSP_SETFRAGMENT, &__blockSize) >= 0) {
	    /* __INST(blockSize) = blockSize; */
	    RETURN (self);
	}
# endif
# ifdef AUDIO_SET_CHANNELS /* hpux */
	if (ioctl (f, AUDIO_SET_TXBUFSIZE, __blockSize)) {
	    /* console_fprintf(stderr, "got err-ret from AUDIO_SET_TXBUFSIZE\n"); */
	    /* __INST(blockSize) = blockSize; */
	    RETURN (self);
	}
# endif
    }
#endif
%}.
    ^ UnsupportedOperationSignal raise
!

setSampleRate:hz
    "set the sample rate.
     Returns true if sucessfull - may fail with many sound devices."

    |fd|

    handle notNil ifTrue:[
	fd := self fileDescriptor.
	fd isNil ifTrue:[
	    self errorNotOpen.
	    ^ nil
	]
    ].
%{
#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd) && __isSmallInteger(hz)) {
	int f = __intVal(fd);
	int __rate = __intVal(hz);
	int __rateWant = __rate;

# if defined(SNDCTL_DSP_SPEED)
	if (ioctl(f, SNDCTL_DSP_SPEED, &__rate) >= 0) {
	    if (__rate != __rateWant) {
		console_fprintf(stderr, "SoundStream [warning]: actual rate is %d\n", __rate);
		hz = __MKSMALLINT(__rate);
	    }
	    __INST(sampleRate) = hz;
	    RETURN (self);
	}
# else
#  if defined(SOUND_PCM_WRITE_RATE)
	if (ioctl(f, SOUND_PCM_WRITE_RATE, &__rate) >= 0) {
	    if (__rate != __rateWant) {
		console_fprintf(stderr, "SoundStream [warning]: actual rate is %d\n", __rate);
		hz = __MKSMALLINT(__rate);
	    }
	    __INST(sampleRate) = hz;
	    RETURN (self);
	}
#  else
#   ifdef AUDIO_SET_SAMPLE_RATE /* hpux */
	if (ioctl (f, AUDIO_SET_SAMPLE_RATE, __rate)) {
	    /* console_fprintf(stderr, "got err-ret from AUDIO_SET_SAMPLE_RATE\n"); */
	    __INST(sampleRate) = hz;
	    RETURN (self);
	}
#   endif
#  endif
# endif
    }
#endif
%}.
    ^ UnsupportedOperationSignal raise

    "
     self writing setSampleRate:10000; dumpSettings; close
     self writing setSampleRate:1000; dumpSettings; close
     self writing setSampleRate:8000; dumpSettings; close
    "
!

supportedAudioFormats
    "return a collection of supported audio formats.
     returned symbols are:
	U8        unsigned 8bit samples
	S8        signed 8bit samples
	MU_LAW    u-law encoded 8bit samples
	A_LAW     a-law encoded 8bit samples
	IMA_ADPCM adpcm encoded
	U16       unsigned 16bit samples
	U16_LE    unsigned 16bit big endian samples
	U16_BE    unsigned 16bit big endian samples
	S16       signed 16bit little endian samples
	S16_LE    signed 16bit little endian samples
	S16_BE    signed 16bit big endian samples
	MPEG      audio mpeg encoded
    "

    |fd audioFormatMask
     supportedFormats
     supports_MU_LAW supports_A_LAW
     supports_IMA_ADPCM supports_U8
     supports_S16_LE supports_S16_BE
     supports_S8 supports_U16_LE
     supports_U16_BE supports_MPEG|

    fd := self fileDescriptor.
    fd isNil ifTrue:[
	self errorNotOpen.
	^ nil
    ].
%{
    int f = __intVal(fd);
    int __audioFormatMask = 0;

#if defined(DEV_AUDIO)
    supports_MU_LAW = true;

# if defined(SNDCTL_DSP_GETFMTS)
    if (ioctl(f, SNDCTL_DSP_GETFMTS, &__audioFormatMask) >= 0) {
	audioFormatMask = __MKSMALLINT(__audioFormatMask);

#  ifdef AFMT_MU_LAW
	supports_MU_LAW = (__audioFormatMask & AFMT_MU_LAW) ? true : false;
#  endif
#  ifdef AFMT_A_LAW
	supports_A_LAW = (__audioFormatMask & AFMT_A_LAW) ? true : false;
#  endif
#  ifdef AFMT_IMA_ADPCM
	supports_IMA_ADPCM = (__audioFormatMask & AFMT_IMA_ADPCM) ? true : false;
#  endif
#  ifdef AFMT_U8
	supports_U8 = (__audioFormatMask & AFMT_U8) ? true : false;
#  endif
#  ifdef AFMT_S16_LE
	supports_S16_LE = (__audioFormatMask & AFMT_S16_LE) ? true : false;
#  endif
#  ifdef AFMT_S16_BE
	supports_S16_BE = (__audioFormatMask & AFMT_S16_BE) ? true : false;
#  endif
#  ifdef AFMT_S8
	supports_S8 = (__audioFormatMask & AFMT_S8) ? true : false;
#  endif
#  ifdef AFMT_U16_LE
	supports_U16_LE = (__audioFormatMask & AFMT_U16_LE) ? true : false;
#  endif
#  ifdef AFMT_U16_BE
	supports_U16_BE = (__audioFormatMask & AFMT_U16_BE) ? true : false;
#  endif
#  ifdef AFMT_MPEG
	supports_MPEG = (__audioFormatMask & AFMT_MPEG) ? true : false;
#  endif
    }
# endif

# ifdef hpux
    supports_MU_LAW = true;
    supports_A_LAW = true;
    supports_S16_BE = true;
# endif
#endif /* DEV_AUDIO */

#ifdef IRIS_AUDIO
    supports_U8 = true;
    supports_U16_BE = true;
#endif

#ifdef __win32__
    supports_S16_LE = true;
#endif

%}.
    supportedFormats := IdentitySet new.
    supports_MU_LAW ifTrue:[
	supportedFormats add:#'MU_LAW'
    ].
    supports_A_LAW ifTrue:[
	supportedFormats add:#'A_LAW'
    ].
    supports_IMA_ADPCM ifTrue:[
	supportedFormats add:#'IMA_ADPCM'
    ].
    supports_S8 ifTrue:[
	supportedFormats add:#'S8'
    ].
    supports_U8 ifTrue:[
	supportedFormats add:#'U8'
    ].
    supports_S16_LE ifTrue:[
	supportedFormats add:#'S16_LE'.
	UninterpretedBytes isBigEndian ifFalse:[
	    supportedFormats add:#'S16'.
	]
    ].
    supports_S16_BE ifTrue:[
	supportedFormats add:#'S16_BE'.
	UninterpretedBytes isBigEndian ifTrue:[
	    supportedFormats add:#'S16'.
	]
    ].
    supports_U16_LE ifTrue:[
	supportedFormats add:#'U16_LE'.
	UninterpretedBytes isBigEndian ifFalse:[
	    supportedFormats add:#'U16'.
	]
    ].
    supports_U16_BE ifTrue:[
	supportedFormats add:#'U16_BE'.
	UninterpretedBytes isBigEndian ifTrue:[
	    supportedFormats add:#'U16'.
	]
    ].
    supports_MPEG ifTrue:[
	supportedFormats add:#'MPEG'
    ].
    ^ supportedFormats.

    "
     |s formats|

     s := self writing.
     formats := s supportedAudioFormats.
     s close.
     formats
    "
! !

!SoundStream protectedMethodsFor:'redefined'!

closeFile
    "a stream has been collected - close the file"

%{
#ifdef IRIS_AUDIO
    OBJ port;

    if ((port = __INST(alPort)) != nil) {
	__INST(alPort) = nil;
	ALcloseport(__ALportVal(port));
    }
    RETURN (self);
#endif /* IRIS_AUDIO */

#ifdef WIN32_DIRECTSOUND
    OBJ oDirectSound, oDSBuffer;
    LPDIRECTSOUND       t_pDirectSound;
    LPDIRECTSOUNDBUFFER t_pDSBuffer;

    if ((oDSBuffer = __INST(pDSBuffer)) != nil) {
	__INST(pDSBuffer) = nil;
	t_pDSBuffer = __DSBufferVal(oDSBuffer);
	if (t_pDSBuffer) {
	    IDirectSoundBuffer_Stop(t_pDSBuffer);
	    IDirectSoundBuffer_Release(t_pDSBuffer);
	}
    }
    if ((oDirectSound = __INST(pDirectSound)) != nil) {
	__INST(pDirectSound) = nil;
	t_pDirectSound = __DirectSoundVal(oDirectSound);
	if (t_pDirectSound) {
	    IDirectSound_Release(t_pDirectSound);
	}
    }
    RETURN (self);
#endif /* WIN32_DIRECTSOUND */

#ifdef WIN32_WAVE
    struct buf *bp, *next;
    int r;
    HWAVEOUT t_waveHandle;
    OBJ oWaveHandle;

    if ((oWaveHandle = __INST(waveHandle)) != nil) {
	t_waveHandle = __WaveHandleVal(oWaveHandle);

# ifdef NO_WAIT_IN_CLOSE
	/* Force cancellation of any pending buffers */
	(void)waveOutReset(t_waveHandle);
# endif

	/* Wait until all pending buffers have been freed */
	while (free_buffers < total_buffers) {
	    WaitForSingleObject(free_buffer_event, INFINITE);
	}

# ifndef NO_WAIT_IN_CLOSE
	/* Force cancellation of any pending buffers */
	(void)waveOutReset(t_waveHandle);
# endif

	/* Close the device */
	if ((r = waveOutClose(t_waveHandle)) != 0) {
	    console_printf("waveOutClose\n");
	    RETURN(self);
	}

	EnterCriticalSection(&free_list_lock);

	/* Free allocated buffers */
	for (bp = free_list; bp != NULL; bp = next) {
	    next = bp->next;
	    (void)free(bp);
	}
	free_list = NULL;

	LeaveCriticalSection(&free_list_lock);

	__INST(waveHandle) = nil;
    }
    RETURN (self);
# endif /* WIN32_WAVE */

#if defined(DEV_AUDIO)
    OBJ fp;
    int fd;
    FILE *f;

    if ((fp = __INST(handle)) != nil) {
	f = __FILEVal(fp);
	__INST(handle) = nil;
# ifdef LINUX
	sigsetmask(~0);
# endif
	if (__INST(buffered) == true) {
	    fflush(f);
	    fclose(f);
	} else {
	    fd = fileno(f);
	    close(fd);
	    fclose(f);
	}
# ifdef LINUX
	sigsetmask(0);
# endif
    }
    RETURN (self);
#endif /* DEV_AUDIO */
%}.
    ^ super closeFile
! !

!SoundStream methodsFor:'redefined'!

flush
    "wait until all sound has been played"

    |fd|

    fd := self fileDescriptor.
%{
#ifdef IRIS_AUDIO
    OPJ port;
    ALport p;

    if ((port = __INST(alPort)) != nil) {
        p = __ALportVal(port);
        while (ALgetfilled(p) > 0) {
            sginap(1);
        }
    }
    RETURN(self);
#endif /* IRIS_AUDIO */

#if defined(DEV_AUDIO)
    if (__isSmallInteger(fd)) {
        int f = __intVal(fd);
        /* ... */
    }
#endif /* DEV_AUDIO */
%}.
    "don't know how to wait on non-iris systems"
    ^ self
!

isOpen
    handle1 notNil ifTrue:[^ true].
    handle2 notNil ifTrue:[^ true].
    ^ handle notNil
!

nextBytes:count into:anObject startingAt:start
    "read the next count bytes into an object and return the number of
     bytes read or nil on error.
     Use with ByteArrays only."

%{
#ifdef IRIS_AUDIO
  {
    OBJ port;
    ALport p;
    int cnt, offs, nSamp;
    int objSize;
    char *cp;

    if ((port = __INST(alPort)) != nil) {
	if (__INST(mode) != _writeonly) {
	    if (__bothSmallInteger(count, start)) {
		cnt = __intVal(count);
		offs = __intVal(start) - 1;
		p = __ALportVal(port);
		objSize = _Size(anObject) - OHDR_SIZE;
		if ((offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs))) {
		    cp = (char *)__InstPtr(anObject) + OHDR_SIZE + offs;
		    if (__INST(bitsPerSample) == __MKSMALLINT(16))
			nSamp = cnt / 2;
		    else
			nSamp = cnt;
		    ALreadsamps(p, cp, nSamp);
		    RETURN ( __MKSMALLINT(cnt) );
		}
	    }
	}
    }
  }
#endif /* IRIS_AUDIO */

#if defined(DEV_AUDIO)
   /*
    * redefine to work around a bug in the linux sound driver;
    * if a write is interrupted (EINTR), it is not defined, how many
    * bytes have been read from the device.
    *
    * As a workaround, disable signals here to prevent the write from
    * being interrupted.
    */
    int cnt, offs, objSize, n;
    char *cp;
    OBJ fp;
    FILE *f;
    int fd;

    if ((fp = __INST(handle)) != nil) {
	f = __FILEVal(fp);
	if (__INST(mode) != @symbol(writeonly)) {
	    if (__bothSmallInteger(count, start)) {
		cnt = __intVal(count);
		offs = __intVal(start) - 1;

		objSize = _Size(anObject) - OHDR_SIZE;
		if ( (offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs)) ) {
		    do {
			cp = (char *)__InstPtr(anObject) + OHDR_SIZE + offs;

			n = cnt;
/*                        if (n > 4096) n = 4096; */
# ifdef LINUX
			sigsetmask(~0);
# endif
			if (__INST(buffered) == true) {
			    n = fread(cp, 1, n, f);
			} else {
			    fd = fileno(f);
			    n = read(fd, cp, n);
			}
# ifdef LINUX
			sigsetmask(0);
# endif
			__BEGIN_INTERRUPTABLE__
			__END_INTERRUPTABLE__
/* console_printf("SoundStream: read %d bytes\n", n); */
			if (n > 0) {
			    offs += n;
			    cnt -= n;
			} else {
			    if (n < 0) {
				console_fprintf(stderr, "read error: %d\n", __threadErrno);
				RETURN (count);
			    }
			}
		    } while (cnt);
		}
		RETURN (count);
	    }
	}
    }
#endif /* DEV_AUDIO */

%}.
    OperatingSystem getOSType = 'irix' ifFalse:[
	OperatingSystem getOSType = 'win32' ifFalse:[
	    ^ super nextPutBytes:count from:anObject startingAt:start
	].
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    (mode == #writeonly) ifTrue:[^ self errorWriteOnly].
    self primitiveFailed
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start.
     return the number of bytes written or nil on error.
     Redefined, since IRIS audio library cannot be used with stdio.
     (at least I don't know). Use with ByteArrays only."

%{
#ifdef IRIS_AUDIO
  {
    OBJ port;
    ALport p;
    int cnt, offs, nSamp;
    int objSize;
    char *cp;

    if ((port = __INST(alPort)) != nil) {
        if (__INST(mode) != @symbol(readonly)) {
            if (__bothSmallInteger(count, start)) {
                cnt = __intVal(count);
                offs = __intVal(start) - 1;
                p = __ALportVal(port);

                /*
                 * compute number of samples
                 */
                objSize = _Size(anObject) - OHDR_SIZE;
                if ( (offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs)) ) {
                    cp = (char *)__InstPtr(anObject) + OHDR_SIZE + offs;
                    if (__INST(bitsPerSample) == __MKSMALLINT(16))
                        nSamp = cnt / 2;
                    else
                        nSamp = cnt;
                    ALwritesamps(p, cp, cnt);
                    RETURN ( count );
                }
            }
        }
    }
  }
#endif /* IRIS_AUDIO */

#ifdef WIN32_DIRECTSOUND
  {
    HRESULT hr;
    DWORD status;
    LPVOID lpbuf1 = NULL;
    LPVOID lpbuf2 = NULL;
    DWORD dwsize1 = 0;
    DWORD dwsize2 = 0;
    DWORD playPos, safePos, endWrite;
    DWORD millis;
    OBJ oDirectSound, oDSBuffer;
    LPDIRECTSOUND       t_pDirectSound = (LPDIRECTSOUND)0;
    LPDIRECTSOUNDBUFFER t_pDSBuffer = (LPDIRECTSOUNDBUFFER)0;
    int t_cbBufOffset, t_cbBufSize;
    short *buf;
    int cnt, offs;

    if ((oDSBuffer = __INST(pDSBuffer)) != nil) {
        t_pDSBuffer = __DSBufferVal(oDSBuffer);
    }
    if ((oDirectSound = __INST(pDirectSound)) != nil) {
        t_pDirectSound = __DirectSoundVal(oDirectSound);
    }

    if (!t_pDSBuffer || !t_pDirectSound) {
        console_fprintf(stderr, "SoundStream not open!\n");
        RETURN (0);
    }
    t_cbBufOffset = __intVal(__INST(bufferOffset));
    t_cbBufSize = __intVal(__INST(bufferSize));

    cnt = __intVal(count);
    offs = __intVal(start) - 1;
    buf = (short *)__InstPtr(anObject) + OHDR_SIZE + offs;

    // Should be playing, right?
    hr = IDirectSoundBuffer_GetStatus(t_pDSBuffer, &status );
    if (!(status && DSBSTATUS_PLAYING)) {
        console_fprintf(stderr, "Buffer not playing!\n");
        RETURN (0);
    }

    // Sleep until we have enough room in buffer.
    hr = IDirectSoundBuffer_GetCurrentPosition(t_pDSBuffer, &playPos, &safePos );
    if( hr != DS_OK ) {
        console_fprintf(stderr, "Cannot get position!\n");
        RETURN (0);
    }
    if( playPos < t_cbBufOffset ) playPos += t_cbBufSize;

    endWrite = t_cbBufOffset + (cnt * sizeof(short));
    while ( playPos < endWrite ) {
        // Calculate number of milliseconds until we will have room, as
        // time = distance * (milliseconds/second) / ((bytes/sample) * (samples/second)),
        // rounded up.
        millis = (DWORD) (1.0 + ((endWrite - playPos) * 1000.0) / ( sizeof(short) * __intVal(__INST(sampleRate))));

        // Sleep for that long
        Sleep( millis );

        // Wake up, find out where we are now
        hr = IDirectSoundBuffer_GetCurrentPosition(t_pDSBuffer, &playPos, &safePos );
        if( hr != DS_OK ) {
            console_fprintf(stderr, "Cannot get position!\n");
            RETURN (0);
        }
        if( playPos < t_cbBufOffset ) playPos += t_cbBufSize; // unwrap offset
    }

    // Lock free space in the DS
    hr = IDirectSoundBuffer_Lock(t_pDSBuffer, t_cbBufOffset, cnt * sizeof(short), &lpbuf1, &dwsize1, &lpbuf2, &dwsize2, 0);
    if (hr == DS_OK) {
        // Copy the buffer into the DS
        CopyMemory(lpbuf1, buf, dwsize1);
        if(NULL != lpbuf2) CopyMemory(lpbuf2, buf+dwsize1, dwsize2);

        // Update our buffer offset and unlock sound buffer
        t_cbBufOffset = (t_cbBufOffset + dwsize1 + dwsize2) % t_cbBufSize;
        IDirectSoundBuffer_Unlock(t_pDSBuffer, lpbuf1, dwsize1, lpbuf2, dwsize2);
    }
    __INST(buffferOffset) = __MKSMALLINT(t_cbBufOffset);

    RETURN (count);
  }
#endif /* WIN32_DIRECTSOUND */

#ifdef WIN32_WAVE
  {
    struct buf *bp;
    int len, i, r;
    int dataLen, offs;
    short *buf;

    HWAVEOUT t_waveHandle;
    OBJ oWaveHandle;

    if ((oWaveHandle = __INST(waveHandle)) == nil) {
        RETURN(0);
    }
    t_waveHandle = __WaveHandleVal(oWaveHandle);

    dataLen = __intVal(count);
    offs = __intVal(start) - 1;
    buf = (short *)__InstPtr(anObject) + OHDR_SIZE + offs;

    while (dataLen > 0) {
        if (free_list == NULL && total_buffers < MAXBUF) {
            /* Expand available buffer space */
            bp = (struct buf *)malloc(sizeof(struct buf));
            total_buffers++;
        } else {
            if (free_list == NULL) {
                /* We must wait for a free buffer */
                while (free_list == NULL) {
                    WaitForSingleObject(free_buffer_event, INFINITE);
                }
            }
            EnterCriticalSection(&free_list_lock);
            bp = free_list;
            free_list = free_list->next;
            --free_buffers;
            LeaveCriticalSection(&free_list_lock);
            r = waveOutUnprepareHeader(t_waveHandle, &bp->hdr, sizeof(WAVEHDR));
            if (r != 0) {
                console_printf("waveOutUnprepareHeader\n");
                RETURN(self);
            }
        }
        len = min(dataLen, DATALEN);
        bp->hdr.lpData = (char *)bp->data;
        bp->hdr.dwBufferLength = len;
        bp->hdr.dwBytesRecorded = len;
        bp->hdr.dwUser = (INT)(bp);
        bp->hdr.dwFlags = 0;
        bp->hdr.dwLoops = 0;
        r = waveOutPrepareHeader(t_waveHandle, &bp->hdr, sizeof(WAVEHDR));
        if (r != 0) {
            console_printf("waveOutPrepareHeader\n");
            RETURN(self);
        }
        for (i = 0; i < len; i++) {
            bp->data[i] = buf[i];
        }
        r = waveOutWrite(t_waveHandle, &bp->hdr, sizeof(WAVEHDR));
        if (r != 0) {
            console_printf("waveOutWrite\n");
            RETURN(self);
        }
        buf += len;
        dataLen -= len;
    }
    RETURN (count);
  }
#endif /* WIN32_WAVE */

#if defined(DEV_AUDIO)
   /*
    * redefine to work around a bug in the linux sound driver;
    * if a write is interrupted (EINTR), it is not defined, how many
    * bytes have been written to the device.
    * I.e. a retry of the write may lead to ever-playing without ever
    * finishing.
    *
    * As a workaround, disable signals here to prevent the write from
    * being interrupted.
    */
    int cnt, offs, objSize, n;
    char *cp;
    OBJ fp;
    FILE *f;
    int fd;

    if ((fp = __INST(handle)) != nil) {
        f = __FILEVal(fp);
        if (__INST(mode) != @symbol(readonly)) {
            if (__bothSmallInteger(count, start)) {
                cnt = __intVal(count);
                offs = __intVal(start) - 1;

                objSize = _Size(anObject) - OHDR_SIZE;
                if ( (offs >= 0) && (cnt >= 0) && (objSize >= (cnt + offs)) ) {
                    do {
                        cp = (char *)__InstPtr(anObject) + OHDR_SIZE + offs;

                        n = cnt;
/*                        if (n > 4096) n = 4096; */
# ifdef LINUX
                        sigsetmask(~0);
# endif
                        if (__INST(buffered) == true) {
                            n = fwrite(cp, 1, n, f);
                        } else {
                            fd = fileno(f);
                            n = write(fd, cp, n);
                        }
# ifdef LINUX
                        sigsetmask(0);
# endif
                        __BEGIN_INTERRUPTABLE__
                        __END_INTERRUPTABLE__
                        if (n > 0) {
                            offs += n;
                            cnt -= n;
                        } else {
                            if (n < 0) {
                                console_fprintf(stderr, "write error: %d\n", __threadErrno);
                                RETURN (count);
                            }
                        }
                    } while (cnt);
                }
                RETURN (count);
            }
        }
    }
#endif /* DEV_AUDIO */

%}.
    ^ super nextPutBytes:count from:anObject startingAt:start
!

openWithMode:aMode attributes:attributeSpec
    |ok error|

%{
#ifdef IRIS_AUDIO
  {
    ALconfig config;
    ALport p;
    long params[] = {
	AL_INPUT_SOURCE, AL_INPUT_MIC,
	AL_INPUT_RATE, 8000,
	AL_OUTPUT_RATE, 8000,
    };

    config = ALnewconfig();
    if (__INST(numberOfChannels) == __MKSMALLINT(2))
	ALsetchannels(config, AL_STEREO);
    else
	ALsetchannels(config, AL_MONO);
    if (__INST(bitsPerSample) == __MKSMALLINT(16))
	ALsetwidth(config, AL_SAMPLE_16);
    else
	ALsetwidth(config, AL_SAMPLE_8);

    if (__isSmallInteger(__INST(sampleRate)))
	params[3] = params[5] = __intVal(__INST(sampleRate));

    ALsetparams(AL_DEFAULT_DEVICE, params, 6);
    p = ALopenport("smallchat", (char *)_stringVal(aMode), config);
    if (p) {
	OBJ t;

	t = __MKEXTERNALADDRESS(p); __INST(alPort) = t; __STORE(self, t);
    } else {
	__INST(alPort) = nil;
	goto out;
    }
    __INST(binary) = true;

    ALfreeconfig(config);
    /*
     * get the parameters actually installed
     */
    config = ALgetconfig(p);
    switch (ALgetchannels(config)) {
	default:
	    /* cannot happen */
	case AL_MONO:
	    __INST(numberOfChannels) = __MKSMALLINT(1);
	    break;
	case AL_STEREO:
	    __INST(numberOfChannels) = __MKSMALLINT(2);
	    break;
    }
    switch (ALgetwidth(config)) {
	default:
	    /* cannot happen */
	case AL_SAMPLE_8:
	    __INST(bitsPerSample) = __MKSMALLINT(8);
	    break;
	case AL_SAMPLE_16:
	    __INST(bitsPerSample) = __MKSMALLINT(16);
	    break;
	case AL_SAMPLE_24:
	    __INST(bitsPerSample) = __MKSMALLINT(24);
	    break;
    }
    ALgetparams(AL_DEFAULT_DEVICE, params, 6);
    __INST(sampleRate) = __MKSMALLINT(params[3]);

    ALfreeconfig(config);
    ok = true;
    goto out;
  }
#endif /* IRIS_AUDIO */

#ifdef WIN32_DIRECTSOUND
  {
    HRESULT result;
    LPDIRECTSOUND       t_pDirectSound;
    LPDIRECTSOUNDBUFFER t_pDSBuffer, t_pDSPrimeBuffer;
    WAVEFORMATEX        wfFormat;
    DSBUFFERDESC        dsbdDesc, primarydsbDesc;
    BYTE                *pDSBuffData;
    int                 t_cbBufSize;
    int                 dwDataLen;

    /* Create the DS object */
    if ((result = DirectSoundCreate(NULL, &t_pDirectSound, NULL)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: Cannot open default sound device!!\n");
	goto out;
    }

    /* Define the wave format structure */
    wfFormat.wFormatTag = WAVE_FORMAT_PCM;
    wfFormat.nChannels = __intVal(__INST(numberOfChannels));
    wfFormat.nSamplesPerSec = __intVal(__INST(sampleRate));
    wfFormat.wBitsPerSample = __intVal(__INST(bitsPerSample));
    wfFormat.nBlockAlign = wfFormat.nChannels * wfFormat.wBitsPerSample / 8;
    wfFormat.nAvgBytesPerSec = wfFormat.nSamplesPerSec * wfFormat.nBlockAlign;
    wfFormat.cbSize = 0;
#  if 0
    /* Setup the primary DS buffer description */
    ZeroMemory(&primarydsbDesc, sizeof(DSBUFFERDESC));
    primarydsbDesc.dwSize = sizeof(DSBUFFERDESC);
    primarydsbDesc.dwFlags = DSBCAPS_PRIMARYBUFFER;
    primarydsbDesc.dwBufferBytes = 0;
    primarydsbDesc.lpwfxFormat = NULL;

    /* Create the primary DS buffer */
    if ((result = IDirectSound_CreateSoundBuffer(t_pDirectSound, &primarydsbDesc,
						 &t_pDSPrimeBuffer, NULL)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: Cannot get the primary DS buffer address!\n");
	IDirectSound_Release(t_pDirectSound);
	goto out;
    }

    /* Set the primary DS buffer sound format.  We have to do this because
       the default primary buffer is 8-bit, 22kHz! */
    if ((result = IDirectSoundBuffer_SetFormat(t_pDSPrimeBuffer, &wfFormat)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: Cannot set the primary DS buffer to proper sound format (%x) (%d)!\n", result, result);
	IDirectSoundBuffer_Stop(t_pDSPrimeBuffer);
	IDirectSoundBuffer_Release(t_pDSPrimeBuffer);
	IDirectSound_Release(t_pDirectSound);
	goto out;
    }
#  endif /* 0 */

    /* Setup the secondary DS buffer description */
    t_cbBufSize = RT_BUFFER_SIZE * sizeof(short) * NBUFS;
    __INST(bufferSize) = __MKSMALLINT(t_cbBufSize);

    ZeroMemory(&dsbdDesc, sizeof(DSBUFFERDESC));
    dsbdDesc.dwSize = sizeof(DSBUFFERDESC);
    dsbdDesc.dwFlags = DSBCAPS_GLOBALFOCUS;
    dsbdDesc.dwBufferBytes = t_cbBufSize;
    dsbdDesc.lpwfxFormat = &wfFormat;

    /* Create the secondary DS buffer */
    if ((result = IDirectSound_CreateSoundBuffer(t_pDirectSound, &dsbdDesc, &t_pDSBuffer, NULL)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: couldn't create sound buffer!\n");
	IDirectSoundBuffer_Stop(t_pDSPrimeBuffer);
	IDirectSoundBuffer_Release(t_pDSPrimeBuffer);
	IDirectSound_Release(t_pDirectSound);
	goto out;
    }

    /* Lock the DS buffer */
    if ((result = IDirectSoundBuffer_Lock(t_pDSBuffer, 0, t_cbBufSize, (LPLPVOID)&pDSBuffData,
					  &dwDataLen, NULL, NULL, 0)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: couldn't lock sound buffer!\n");
	IDirectSoundBuffer_Stop(t_pDSBuffer);
	IDirectSoundBuffer_Stop(t_pDSPrimeBuffer);
	IDirectSoundBuffer_Release(t_pDSPrimeBuffer);
	IDirectSound_Release(t_pDirectSound);
	goto out;
    }

    /* Zero the DS buffer */
    ZeroMemory(pDSBuffData, dwDataLen);

    /* Unlock the DS buffer */
    if ((result = IDirectSoundBuffer_Unlock(t_pDSBuffer, pDSBuffData, dwDataLen, NULL, 0)) != DS_OK) {
	console_fprintf(stderr,"SoundStream: couldn't unlock sound buffer!\n");
	IDirectSoundBuffer_Stop(t_pDSBuffer);
	IDirectSoundBuffer_Stop(t_pDSPrimeBuffer);
	IDirectSoundBuffer_Release(t_pDSPrimeBuffer);
	IDirectSound_Release(t_pDirectSound);
	goto out;
    }

    __INST(bufferOffset) = __MKSMALLINT(0);  // reset last write position to start of buffer

    /* Start the buffer playback */
    if ((result = IDirectSoundBuffer_Play(t_pDSBuffer, 0, 0, DSBPLAY_LOOPING) != DS_OK)) {
	console_fprintf(stderr,"SoundStream: couldn't play sound buffer!\n");
	IDirectSoundBuffer_Stop(t_pDSBuffer);
	IDirectSoundBuffer_Stop(t_pDSPrimeBuffer);
	IDirectSoundBuffer_Release(t_pDSPrimeBuffer);
	IDirectSound_Release(t_pDirectSound);
	ok = false;
	goto out;
    }

    {
	OBJ t;

	t = __MKEXTERNALADDRESS(t_pDSBuffer); __INST(pDSBuffer) = t; __STORE(self, t);
	t = __MKEXTERNALADDRESS(t_pDirectSound); __INST(pDirectSound) = t; __STORE(self, t);
    }
    ok = true;
    goto out;
  }
#endif /* WIN32_DIRECTSOUND */

#ifdef WIN32_WAVE
  {
    PCMWAVEFORMAT waveFormat;
    int r;
    HWAVEOUT t_waveHandle;
    OBJ oWaveHandle;

    if ((oWaveHandle = __INST(waveHandle)) != nil) {
	ok = false;
	goto out;
    }

    waveFormat.wf.wFormatTag = WAVE_FORMAT_PCM;
    waveFormat.wf.nChannels = __intVal(__INST(numberOfChannels));
    waveFormat.wf.nSamplesPerSec = __intVal(__INST(sampleRate));
    waveFormat.wBitsPerSample = __intVal(__INST(bitsPerSample));
    waveFormat.wf.nBlockAlign = waveFormat.wf.nChannels * waveFormat.wBitsPerSample / 8;
    waveFormat.wf.nAvgBytesPerSec = waveFormat.wf.nSamplesPerSec * waveFormat.wf.nBlockAlign;

    r = waveOutOpen(&t_waveHandle,
		    WAVE_MAPPER,
		    (WAVEFORMAT *)&waveFormat,
		    (DWORD_PTR)waveCallBack,
		    (DWORD_PTR)0,
		    CALLBACK_FUNCTION);
    if (r != 0) {
	console_printf("waveOutOpen\n");
	ok = false;
	goto out;
    }

    (void)waveOutReset(t_waveHandle);

    free_list = NULL;
    InitializeCriticalSection(&free_list_lock);
    free_buffers = 0;
    free_buffer_event = CreateEvent(NULL, FALSE, FALSE, NULL);
    total_buffers = 0;

    {
	OBJ t;

	t = __MKEXTERNALADDRESS(t_waveHandle); __INST(waveHandle) = t; __STORE(self, t);
    }

# if 0
    /*
     * HACK: If we immediately start writing valid audio data to the device
     * then the sound is choppy in the beginning. Writing a null packet to
     * to the device first seems to fix this problem although I have no idea
     * why - DAC
     */
    {
	char null[DATALEN];
	int i;
	for (i = 0; i < DATALEN; i++) {
	    null[i] = 127;
	}
	audioWrite(null, DATALEN);
    }
# endif /* 0 */
    ok = true;
    goto out;
  }
#endif /* !WIN32_DIRECTSOUND */

#ifdef DEV_AUDIO
  {
      int __fd;
      int __mode;
      FILE *f;

      if (strcmp(__stringVal(aMode), "w") == 0) {
	  __mode = O_WRONLY;
      } else if (strcmp(__stringVal(aMode), "r") == 0) {
	  __mode = O_RDONLY;
      } else {
	  __mode = O_RDWR;
      }
      do {
	  __BEGIN_INTERRUPTABLE__
	  __fd = open((char *) __stringVal(__INST(pathName)), __mode /* |O_NDELAY */);
	  __END_INTERRUPTABLE__
      } while ((__fd < 0) && (errno == EINTR));

      if (__fd >= 0) {
	  /*
	   * make it a FILE *
	   */
	  f = fdopen(__fd, __stringVal(aMode));
	  if (! f) {
	      error = __mkSmallInteger(errno);
	      __BEGIN_INTERRUPTABLE__
	      close(__fd);
	      __END_INTERRUPTABLE__
	      ok = false;
	      goto out;
	  }
	  setbuf(f, NULL);
	  __INST(buffered) = false;
	  __INST(handle) = __MKEXTERNALADDRESS(f);
	  __STORESELF(handle);

#if defined(PCM_ENABLE_OUTPUT) && defined(PCM_ENABLE_INPUT)
# if defined(SNDCTL_DSP_SETTRIGGER)
	  if (__mode == O_RDWR) {
	      int enable_bits = ~(PCM_ENABLE_OUTPUT|PCM_ENABLE_INPUT);

	      if (ioctl(__fd, SNDCTL_DSP_SETTRIGGER, &enable_bits) == -1)
	      {
		  console_fprintf(stderr, "can't request synchronous start of fullduplex operation");
	      }
	  }
# endif
#endif
	  ok = true;
	  goto out;
      } else {
	  error = __mkSmallInteger(errno);
      }
  }
#endif /* DEV_AUDIO */

out:;
%}.
    ok == false ifTrue:[
	lastErrorNumber := error.
	self openError:error.
	"normally not reached"
	^ nil.
    ].

    ok isNil ifTrue:[
	"its a regular file open (i.e. /dev/audio) "
	^ super openWithMode:aMode attributes:attributeSpec.
    ].

    self registerForFinalization.
    ^ self.
! !

!SoundStream methodsFor:'sine wave generation'!

playSine16:freq forSeconds:seconds
    "output some tone for some time
     in S16 audioFormat - a test method"

    |buffer numSamples val scale isUnsigned|

    (audioFormat startsWith:#U16) ifFalse:[
	(audioFormat startsWith:#S16) ifFalse:[
	    self error:'must be in 16bit mode' mayProceed:true.
	    ^ self
	]
    ].

    numSamples := (self sampleRate * seconds) truncated.
    buffer := WordArray new:numSamples.

    "fill it with a sine wave"

    isUnsigned := audioFormat startsWith:#U16.

    scale := freq * 2 * (Float pi).
    1 to:numSamples do:[:i |
	val := (scale * i / self sampleRate) sin.
	val := (val * 16r7FFF) rounded bitAnd:16rFFFF.
	isUnsigned ifTrue:[
	    val := val + 32768
	].
	buffer at:i put:val
    ].

    self nextPutBytes:(numSamples*2) from:buffer startingAt:1

    "
     SoundStream writing setAudioFormat:#S16; playSine16:440 forSeconds:2; close
     SoundStream writing setAudioFormat:#S16; playSine16:880 forSeconds:2; close
     SoundStream writing setAudioFormat:#S16; playSine16:1760 forSeconds:2; close
     SoundStream writing setAudioFormat:#S16; playSine16:3520 forSeconds:2; close
     SoundStream writing tuneTone:440; close

     SoundStream writing setAudioFormat:#U16; playSine16:880 forSeconds:2; close
     SoundStream writing setAudioFormat:#U16_LE; playSine16:880 forSeconds:2; close
    "

    "Modified: / 31.1.1999 / 12:12:41 / cg"
!

testMelody
    3 timesRepeat:[
	self playSine16:220 forSeconds:0.5.
	self playSine16:440 forSeconds:0.5.
	self playSine16:880 forSeconds:0.5.
	self playSine16:1760 forSeconds:0.5.
	self playSine16:3520 forSeconds:0.5.
    ]

    "
     self writing testMelody; close
    "

    "Created: / 31.1.1999 / 12:07:45 / cg"
    "Modified: / 31.1.1999 / 12:16:09 / cg"
!

tuneTone
    ^ self tuneTone:440

    "
     SoundStream writing tuneTone; close
     SoundStream writing setSampleRate:4000; tuneTone; close
     SoundStream writing setSampleRate:8000; tuneTone; close
     SoundStream writing setSampleRate:10000; tuneTone; close
     SoundStream writing setSampleRate:20000; tuneTone; close
     SoundStream writing setSampleRate:40000; tuneTone; close

     SoundStream writing setSampleRate:40000; dumpSettings; close
     SoundStream writing setSampleRate:20000; dumpSettings; close
    "

    "Modified: / 31.1.1999 / 12:06:27 / cg"
!

tuneTone16:freq
    "output some tone for 3 seconds in S16 audioFormat - a test method"

    |buffer numSamples val scale oldFormat|

    (audioFormat startsWith:#U16) ifFalse:[
	(audioFormat startsWith:#S16) ifFalse:[
	    self error:'must be in 16bit mode' mayProceed:true.
	    ^ self
	]
    ].

    "allocate memory for 1sec playing time"
    numSamples := self sampleRate.
    buffer := WordArray new:numSamples.

    "fill it with a sine wave"

    scale := freq * 2 * (Float pi).
    1 to:numSamples do:[:i |
	val := (scale * i / numSamples) sin.
	val := (val * 16r7FFF) rounded bitAnd:16rFFFF.
	audioFormat == #U16 ifTrue:[
	    val := val + 32768
	].
	buffer at:i put:val
    ].

    oldFormat := audioFormat.
    self setAudioFormat:#S16.
    1 to:3 do:[:s |
	self nextPutBytes:(numSamples*2) from:buffer startingAt:1
    ].
    self setAudioFormat:oldFormat.

    "of course, the frequency should be below half the
     sampleRate - hear below ...

     SoundStream writing setSampleRate:4000; tuneTone16:440; close
     SoundStream writing setSampleRate:8000; tuneTone16:440; close
     SoundStream writing setSampleRate:10000; tuneTone16:440; close
     SoundStream writing setSampleRate:20000; tuneTone16:440; close
     SoundStream writing setSampleRate:40000; tuneTone16:440; close
    "

    "Modified: / 21.12.1998 / 09:11:30 / cg"
!

tuneTone8:freq
    "output some tone for 3 seconds in U8 audioFormat - a test method"

    |buffer numSamples val scale oldFormat|

    (audioFormat == #U8) ifFalse:[
	(audioFormat == #S8) ifFalse:[
	    self error:'must be in 8bit mode' mayProceed:true.
	    ^ self
	]
    ].

    "allocate memory for 1sec playing time"
    numSamples := self sampleRate.
    buffer := ByteArray new:numSamples.

    "fill it with a sine wave"

    scale := freq * 2 * (Float pi).
    1 to:numSamples do:[:i |
	val := (scale * i / numSamples) sin.
	val := (val * 127 + 128) rounded.
	buffer at:i put:val
    ].

    oldFormat := audioFormat.
    self setAudioFormat:#U8.
    1 to:3 do:[:s |
	self nextPutBytes:numSamples from:buffer startingAt:1
    ].
    self setAudioFormat:oldFormat.

    "of course, the frequency should be below half the
     sampleRate - hear below ...

     SoundStream writing tuneTone; close
     SoundStream writing setSampleRate:4000; tuneTone:440; close
     SoundStream writing setSampleRate:4000; tuneTone:2000; close
     SoundStream writing setSampleRate:8000; tuneTone:440; close
     SoundStream writing setSampleRate:8000; tuneTone:2000; close
     SoundStream writing setSampleRate:8000; tuneTone:4000; close
     SoundStream writing setSampleRate:10000; tuneTone:440; close
     SoundStream writing setSampleRate:10000; tuneTone:2000; close
     SoundStream writing setSampleRate:10000; tuneTone:4000; close
     SoundStream writing setSampleRate:20000; tuneTone:440; close
     SoundStream writing setSampleRate:20000; tuneTone:2000; close
     SoundStream writing setSampleRate:20000; tuneTone:4000; close
     SoundStream writing setSampleRate:20000; tuneTone:8000; close
     SoundStream writing setSampleRate:40000; tuneTone:440; close
     SoundStream writing setSampleRate:40000; tuneTone:2000; close
     SoundStream writing setSampleRate:40000; tuneTone:4000; close
     SoundStream writing setSampleRate:40000; tuneTone:8000; close
     SoundStream writing setSampleRate:40000; tuneTone:10000; close
    "

    "Modified: / 15.12.1997 / 13:43:05 / cg"
    "Created: / 31.1.1999 / 12:05:17 / cg"
!

tuneTone:freq
    ((audioFormat startsWith:#S16)
    or:[audioFormat startsWith:#U16]) ifTrue:[
	^ self tuneTone16:freq
    ].
    audioFormat == #MU_LAW ifTrue:[
	^ self tuneToneMU:freq
    ].
    self tuneTone8:freq

    "
     SoundStream writing tuneTone:880; close
     SoundStream writing setSampleRate:4000; tuneTone:440; close
     SoundStream writing setSampleRate:4000; tuneTone:880; close
     SoundStream writing setSampleRate:8000; tuneTone:440; close
     SoundStream writing setSampleRate:8000; tuneTone:880; close
     SoundStream writing setSampleRate:10000; tuneTone:440; close
     SoundStream writing setSampleRate:10000; tuneTone:880; close

     SoundStream writing setSampleRate:20000; tuneTone:440; close
     SoundStream writing setSampleRate:20000; tuneTone:880; close

     SoundStream writing setSampleRate:40000; tuneTone:440; close
     SoundStream writing setSampleRate:40000; tuneTone:880; close
     SoundStream writing setSampleRate:40000; tuneTone:1760; close
     SoundStream writing setSampleRate:40000; tuneTone:3520; close
     SoundStream writing setSampleRate:40000; tuneTone:7020; close
     SoundStream writing setSampleRate:40000; tuneTone:14040; close

     SoundStream writing setSampleRate:44100; tuneTone:440; close
     SoundStream writing setSampleRate:44100; tuneTone:880; close
     SoundStream writing setSampleRate:44100; tuneTone:1760; close
     SoundStream writing setSampleRate:44100; tuneTone:3520; close
     SoundStream writing setSampleRate:44100; tuneTone:7020; close
     SoundStream writing setSampleRate:44100; tuneTone:14040; close

     SoundStream writing setSampleRate:20000; dumpSettings; close
    "

    "Modified: / 31.1.1999 / 12:07:14 / cg"
!

tuneToneMU:freq
    "output some tone for 3 seconds in MU_LAW audioFormat - a test method"

    |buffer numSamples val scale oldFormat|

    "allocate memory for 1sec playing time"
    numSamples := self sampleRate.
    buffer := ByteArray new:numSamples.

    "fill it with a sine wave"

    scale := freq * 2 * (Float pi).
    1 to:numSamples do:[:i |
	val := (scale * i / numSamples) sin.
	val := (val * 16r7FFF) rounded.
	buffer at:i put:(self class linear16ToUlaw:val)
    ].

    oldFormat := audioFormat.
    self setAudioFormat:#MU_LAW.
    1 to:3 do:[:s |
	self nextPutBytes:numSamples from:buffer startingAt:1
    ].
    self setAudioFormat:oldFormat.

    "of course, the frequency should be below half the
     sampleRate - hear below ...

     SoundStream writing setSampleRate:8000; tuneToneMU:440; close
     SoundStream writing setSampleRate:10000; tuneToneMU:440; close
     SoundStream writing setSampleRate:20000; tuneToneMU:440; close
     SoundStream writing setSampleRate:40000; tuneToneMU:440; close
    "

    "Modified: / 15.12.1997 / 13:46:19 / cg"
! !

!SoundStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


SoundStream initialize!
