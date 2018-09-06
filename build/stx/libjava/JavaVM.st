"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaVM
	instanceVariableNames:''
	classVariableNames:'UnhandledJavaExceptionSignal JavaExceptionSignal
		UnimplementedInstructionSignal UnimplementedNativeMethodSignal
		BadMessageSignal InternalErrorSignal CallHandlerSignal LockTable
		LockTableAccess StackTrace EagerResolvingEnabled
		OldspaceIncreased PerfCounters MonitorTrace MonitorTraceId
		ExceptionTrace ExceptionDebug ExitDebug StandardThreadGroup
		AcquiredMonitorsPerProcess DUMMY_LONG_HIGHWORD
		DUMMY_DOUBLE_HIGHWORD FirstWindowCreationSemaphore SimulatedOS
		O_WGgraphics_originX O_WGgraphics_originY O_WGgraphics_pData
		O_FramePeer_pNativeWidget O_FramePeer_pData LastGraphics LastGC
		ExceptionDebugPatterns NullPointerExceptionDebug
		DivisionByZeroExceptionDebug IOExceptionDebug
		JavaPrivilegedAccessQuery SmalltalkClassLoader
		FinalizationEnabled FinalizationLobby ParkUnparkSemaphores
		ThreadInterrupts NativeMethodsImplementation SystemProperties'
	poolDictionaries:'JavaConstants JavaVMData'
	category:'Languages-Java-Support'
!

Object subclass:#Performance
	instanceVariableNames:'vm counters'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaVM
!

Object subclass:#ReflectionRegistry
	instanceVariableNames:'vm constantPoolMapping javaClasses javaArrayClasses'
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	privateIn:JavaVM
!

!JavaVM primitiveDefinitions!
%{

#include "thinlocks.h"

%}
! !

!JavaVM class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"Runtime support and environment for Java.
You shouldn't communicate with JavaVM directly,
use Java class instead. JavaVM is layer between
the native interpret and the rest of the system.
JavaVM implements native java virtual machine
methods called by interpret, hides java primitive
types handling, and gives the ST world ways to
control class loading and reflection"
!

nativeMethods
"
    all native methods:

        JavaMethod allSubInstances select:[:m |
            m isNative
        ]

    implemented methods:

        JavaMethod allSubInstances select:[:m |
            |sel|

            m isNative ifTrue:[
                sel := ('_' , m javaClass lastName , '_' , m name , ':') asSymbol.
                JavaVM class implements:sel.
            ] ifFalse:[
                false
            ]
        ]

    unimplemented methods:

        JavaMethod allSubInstances select:[:m |
            |sel|

            m isNative ifTrue:[
                sel := ('_' , m javaClass lastName , '_' , m name , ':') asSymbol.
                (JavaVM class implements:sel) not
            ] ifFalse:[
                false
            ]
        ]


    list of all native methods as in jdk1.1.3:

      X - implemented
      * - implemented to be validated
      x - implemented with limited functionality
      o - implemented as dummy (no functionality)

    X (Math::double sin (double))
    X (Math::double cos (double))
    X (Math::double tan (double))
    X (Math::double asin (double))
    X (Math::double acos (double))
    X (Math::double atan (double))
    X (Math::double exp (double))
    X (Math::double log (double))
    X (Math::double sqrt (double))
      (Math::double IEEEremainder (double double))
    X (Math::double ceil (double))
    X (Math::double floor (double))
      (Math::double rint (double))
      (Math::double atan2 (double double))
    X (Math::double pow (double double))

    X (Class::java.lang.Class forName (java.lang.String))
    X (Class::java.lang.Object newInstance ())
    * (Class::boolean isInstance (java.lang.Object))
    X (Class::boolean isAssignableFrom (java.lang.Class))
    X (Class::boolean isInterface ())
      (Class::boolean isArray ())
    X (Class::boolean isPrimitive ())
    X (Class::java.lang.String getName ())
    X (Class::java.lang.ClassLoader getClassLoader ())
    X (Class::java.lang.Class getSuperclass ())
      (Class::java.lang.Class[] getInterfaces ())
      (Class::java.lang.Class getComponentType ())
      (Class::int getModifiers ())
      (Class::java.lang.Object[] getSigners ())
      (Class::void setSigners (java.lang.Object[]))
    X (Class::java.lang.Class getPrimitiveClass (java.lang.String))
      (Class::java.lang.reflect.Field getField0 (java.lang.String int))
      (Class::java.lang.reflect.Field[] getFields0 (int))
    X (Class::java.lang.reflect.Method getMethod0 (java.lang.String java.lang.Class[] int))
    X (Class::java.lang.reflect.Method[] getMethods0 (int))
      (Class::java.lang.reflect.Constructor[] getConstructors0 (int))
      (Class::java.lang.reflect.Constructor getConstructor0 (java.lang.Class[] int))

    X (InetAddressImpl::java.lang.String getLocalHostName ())
    X (InetAddressImpl::void makeAnyLocalAddress (java.net.InetAddress))
    X (InetAddressImpl::byte[][] lookupAllHostAddr (java.lang.String))
      (InetAddressImpl::java.lang.String getHostByAddr (int))
    X (InetAddressImpl::int getInetFamily ())

    X (ResourceBundle::java.lang.Class[] getClassContext ())

    X (System::void setIn0 (java.io.InputStream))
    X (System::void setOut0 (java.io.PrintStream))
    X (System::void setErr0 (java.io.PrintStream))
    X (System::long currentTimeMillis ())
    X (System::void arraycopy (java.lang.Object int java.lang.Object int int))
    X (System::int identityHashCode (java.lang.Object))
    X (System::java.util.Properties initProperties (java.util.Properties))

    X (Thread::java.lang.Thread currentThread ())
    X (Thread::void yield ())
    X (Thread::void sleep (long))
    X (Thread::void start ())
    X (Thread::boolean isInterrupted (boolean))
    X (Thread::boolean isAlive ())
      (Thread::int countStackFrames ())
    X (Thread::void setPriority0 (int))
    X (Thread::void stop0 (java.lang.Object))
    X (Thread::void suspend0 ())
    X (Thread::void resume0 ())
    * (Thread::void interrupt0 ())

      (String::java.lang.String intern ())

    X (Float::int floatToIntBits (float))
    X (Float::float intBitsToFloat (int))

      (ObjectStreamClass::int getClassAccess (java.lang.Class))
      (ObjectStreamClass::java.lang.String[] getMethodSignatures (java.lang.Class))
      (ObjectStreamClass::int getMethodAccess (java.lang.Class java.lang.String))
      (ObjectStreamClass::java.lang.String[] getFieldSignatures (java.lang.Class))
      (ObjectStreamClass::int getFieldAccess (java.lang.Class java.lang.String))
      (ObjectStreamClass::java.io.ObjectStreamField[] getFields0 (java.lang.Class))
      (ObjectStreamClass::long getSerialVersionUID (java.lang.Class))
      (ObjectStreamClass::boolean hasWriteObject (java.lang.Class))
      (ObjectInputStream::java.lang.Class loadClass0 (java.lang.Class java.lang.String))
      (ObjectInputStream::void inputClassFields (java.lang.Object java.lang.Class int[]))
      (ObjectInputStream::java.lang.Object allocateNewObject (java.lang.Class java.lang.Class))
      (ObjectInputStream::java.lang.Object allocateNewArray (java.lang.Class int))
      (ObjectInputStream::boolean invokeObjectReader (java.lang.Object java.lang.Class))

      (SecurityManager::java.lang.Class[] getClassContext ())
    X (SecurityManager::java.lang.ClassLoader currentClassLoader ())
      (SecurityManager::int classDepth (java.lang.String))
    X (SecurityManager::int classLoaderDepth ())
      (SecurityManager::java.lang.Class currentLoadedClass0 ())

    X (ClassLoader::void init ())
    X (ClassLoader::java.lang.Class defineClass0 (java.lang.String byte[] int int))
    X (ClassLoader::void resolveClass0 (java.lang.Class))
    X (ClassLoader::java.lang.Class findSystemClass0 (java.lang.String))
    X (ClassLoader::java.io.InputStream getSystemResourceAsStream0 (java.lang.String))
      (ClassLoader::java.lang.String getSystemResourceAsName0 (java.lang.String))

    X (FileDescriptor::boolean valid ())
      (FileDescriptor::void sync ())
    X (FileDescriptor::java.io.FileDescriptor initSystemFD (java.io.FileDescriptor int))

    X (Object::java.lang.Class getClass ())
    X (Object::int hashCode ())
    X (Object::java.lang.Object clone ())
    X (Object::void notify ())
    X (Object::void notifyAll ())
    X (Object::void wait (long))

    X (FileOutputStream::void open (java.lang.String))
    X (FileOutputStream::void openAppend (java.lang.String))
    X (FileOutputStream::void write (int))
    X (FileOutputStream::void writeBytes (byte[] int int))
    X (FileOutputStream::void close ())
    X (FileInputStream::void open (java.lang.String))
    X (FileInputStream::int read ())
    X (FileInputStream::int readBytes (byte[] int int))
      (FileInputStream::long skip (long))
    X (FileInputStream::int available ())
    X (FileInputStream::void close ())

      (VM::int getState ())
      (VM::boolean threadsSuspended ())
      (VM::void unsuspendThreads ())
      (VM::void unsuspendSomeThreads ())

    X (File::boolean exists0 ())
    X (File::boolean canWrite0 ())
    X (File::boolean canRead0 ())
    X (File::boolean isFile0 ())
    X (File::boolean isDirectory0 ())
    X (File::long lastModified0 ())
    X (File::long length0 ())
    X (File::boolean mkdir0 ())
    X (File::boolean renameTo0 (java.io.File))
    X (File::boolean delete0 ())
      (File::boolean rmdir0 ())
    X (File::java.lang.String[] list0 ())
      (File::java.lang.String canonPath (java.lang.String))
    X (File::boolean isAbsolute ())

      (ObjectOutputStream::void outputClassFields (java.lang.Object java.lang.Class int[]))
      (ObjectOutputStream::boolean invokeObjectWriter (java.lang.Object java.lang.Class))

    X (Throwable::void printStackTrace0 (java.lang.Object))
    X (Throwable::java.lang.Throwable fillInStackTrace ())

    X (Double::long doubleToLongBits (double))
    X (Double::double longBitsToDouble (long))
    X (Double::double valueOf0 (java.lang.String))

    X (Runtime::void exitInternal (int))
    o (Runtime::void runFinalizersOnExit0 (boolean))
    o (Runtime::java.lang.Process execInternal (java.lang.String[] java.lang.String[]))
    X (Runtime::long freeMemory ())
    X (Runtime::long totalMemory ())
    X (Runtime::void gc ())
      (Runtime::void runFinalization ())
      (Runtime::void traceInstructions (boolean))
      (Runtime::void traceMethodCalls (boolean))
    X (Runtime::java.lang.String initializeLinkerInternal ())
    X (Runtime::java.lang.String buildLibName (java.lang.String java.lang.String))
    X (Runtime::int loadFileInternal (java.lang.String))

      (WDrawingSurfaceInfo::int lock ())
      (WDrawingSurfaceInfo::void unlock ())
      (WDrawingSurfaceInfo::int getHWnd ())
      (WDrawingSurfaceInfo::int getHBitmap ())
      (WDrawingSurfaceInfo::int getPBits ())
      (WDrawingSurfaceInfo::int getHDC ())
      (WDrawingSurfaceInfo::int getDepth ())
      (WDrawingSurfaceInfo::int getHPalette ())

    X (WDefaultFontCharset::boolean canConvert (char))

      (ColorModel::void deletepData ())
    X (WToolkit::void init (java.lang.Thread))
    X (WToolkit::void eventLoop ())
      (WToolkit::java.awt.image.ColorModel makeColorModel ())
    X (WToolkit::int getScreenResolution ())
    X (WToolkit::int getScreenWidth ())
    X (WToolkit::int getScreenHeight ())
      (WToolkit::void sync ())
    * (WToolkit::void beep ())
    X (WToolkit::void loadSystemColors (int[]))

      (WPrintJob::void end ())

    X (WDialogPeer::void create (sun.awt.windows.WComponentPeer))
    X (WDialogPeer::void _show ())
    X (WDialogPeer::void _hide ())

    X (WWindowPeer::void toFront ())
    X (WWindowPeer::void toBack ())
    X (WWindowPeer::void _setTitle (java.lang.String))
    X (WWindowPeer::void _setResizable (boolean))
    X (WWindowPeer::void create (sun.awt.windows.WComponentPeer))
    o (WWindowPeer::void updateInsets (java.awt.Insets))
      (WWindowPeer::java.awt.Component getContainerElement (java.awt.Container int))

    X (WCanvasPeer::void create (sun.awt.windows.WComponentPeer))

    X (WTextAreaPeer::void create (sun.awt.windows.WComponentPeer))
    X (WTextAreaPeer::void insertText (java.lang.String int))
      (WTextAreaPeer::void replaceText (java.lang.String int int))

    X (WTextComponentPeer::java.lang.String getText ())
    X (WTextComponentPeer::void setText (java.lang.String))
    X (WTextComponentPeer::int getSelectionStart ())
    X (WTextComponentPeer::int getSelectionEnd ())
    X (WTextComponentPeer::void select (int int))
    X (WTextComponentPeer::void enableEditing (boolean))

    X (WComponentPeer::void show ())
    X (WComponentPeer::void hide ())
    X (WComponentPeer::void enable ())
    X (WComponentPeer::void disable ())
    X (WComponentPeer::java.awt.Point getLocationOnScreen ())
    X (WComponentPeer::void reshape (int int int int))
    o (WComponentPeer::void handleEvent (java.awt.AWTEvent))
    o (WComponentPeer::void _dispose ())
    X (WComponentPeer::void _setForeground (int))
    X (WComponentPeer::void _setBackground (int))
    o (WComponentPeer::void setFont (java.awt.Font))
    o (WComponentPeer::void requestFocus ())
    o (WComponentPeer::void setCursor (java.awt.Cursor))
    o (WComponentPeer::void start ())
      (WComponentPeer::void _beginValidate ())
      (WComponentPeer::void endValidate ())
    o (WComponentPeer::void setZOrderPosition (sun.awt.windows.WComponentPeer))

    X (WFramePeer::void setMenuBar0 (sun.awt.windows.WMenuBarPeer))
    X (WFramePeer::void create (sun.awt.windows.WComponentPeer))
    X (WFramePeer::void _setIconImage (sun.awt.image.ImageRepresentation))

    o (WFontMetrics::boolean needsConversion (java.awt.Font sun.awt.FontDescriptor))
    o (WFontMetrics::int getMFCharSegmentWidth (java.awt.Font sun.awt.FontDescriptor boolean char[] int int byte[] int))
      (WFontMetrics::int bytesWidth (byte[] int int))
      (WFontMetrics::void init ())

    o (WChoicePeer::void select (int))
    o (WChoicePeer::void remove (int))
    o (WChoicePeer::void addItem (java.lang.String int))
    X (WChoicePeer::void reshape (int int int int))
    X (WChoicePeer::void create (sun.awt.windows.WComponentPeer))

    X (WLabelPeer::void setText (java.lang.String))
    o (WLabelPeer::void setAlignment (int))
    X (WLabelPeer::void create (sun.awt.windows.WComponentPeer))

    X (WMenuItemPeer::void _setLabel (java.lang.String))
    X (WMenuItemPeer::void create (sun.awt.windows.WMenuPeer))
    X (WMenuItemPeer::void enable (boolean))
    o (WMenuItemPeer::void _dispose ())
      (WMenuPeer::void addSeparator ())
      (WMenuPeer::void delItem (int))
    X (WMenuPeer::void createMenu (sun.awt.windows.WMenuBarPeer))
      (WMenuPeer::void createSubMenu (sun.awt.windows.WMenuPeer))

      (WPopupMenuPeer::void createMenu (sun.awt.windows.WComponentPeer))
      (WPopupMenuPeer::void _show (java.awt.Event))
      (WMenuBarPeer::void addMenu (java.awt.Menu))
      (WMenuBarPeer::void delMenu (int))
    X (WMenuBarPeer::void create (sun.awt.windows.WFramePeer))

      (WCheckboxMenuItemPeer::void setState (boolean))

    X (WFileDialogPeer::void show ())

    X (WCheckboxPeer::void setState (boolean))
    X (WCheckboxPeer::void setCheckboxGroup (java.awt.CheckboxGroup))
      (WCheckboxPeer::void setLabel (java.lang.String))
    X (WCheckboxPeer::void create (sun.awt.windows.WComponentPeer))

    X (WClipboard::void init ())
      (WClipboard::void setClipboardText (java.awt.datatransfer.StringSelection))
      (WClipboard::java.lang.String getClipboardText ())

    X (WListPeer::void addItem (java.lang.String int))
    X (WListPeer::void delItems (int int))
    X (WListPeer::void select (int))
      (WListPeer::void deselect (int))
      (WListPeer::void makeVisible (int))
    X (WListPeer::void setMultipleSelections (boolean))
    X (WListPeer::void create (sun.awt.windows.WComponentPeer))
    X (WListPeer::boolean isSelected (int))

    x (WScrollbarPeer::void _setValues (int int int int))
    x (WScrollbarPeer::void setLineIncrement (int))
    x (WScrollbarPeer::void setPageIncrement (int))
    x (WScrollbarPeer::void create (sun.awt.windows.WComponentPeer))

    x (ImageRepresentation::void offscreenInit (java.awt.Color))
    x (ImageRepresentation::boolean setBytePixels (int int int int java.awt.image.ColorModel byte[] int int))
    x (ImageRepresentation::boolean setIntPixels (int int int int java.awt.image.ColorModel int[] int int))
    x (ImageRepresentation::boolean finish (boolean))
    X (ImageRepresentation::void imageDraw (java.awt.Graphics int int java.awt.Color))
    x (ImageRepresentation::void imageStretch (java.awt.Graphics int int int int int int int int java.awt.Color))
    x (ImageRepresentation::void disposeImage ())

    X (WTextFieldPeer::void create (sun.awt.windows.WComponentPeer))
    X (WTextFieldPeer::void setEchoCharacter (char))

    X (WScrollPanePeer::void create (sun.awt.windows.WComponentPeer))
    o (WScrollPanePeer::int getOffset (int))
      (WScrollPanePeer::void setInsets ())
      (WScrollPanePeer::void setScrollPosition (int int))
    x (WScrollPanePeer::int _getHScrollbarHeight ())
    x (WScrollPanePeer::int _getVScrollbarWidth ())
    o (WScrollPanePeer::void setSpans (int int int int))
      (WScrollPanePeer::java.awt.Component getScrollChild ())

      (WEmbeddedFramePeer::void create (sun.awt.windows.WComponentPeer))
    X (WButtonPeer::void setLabel (java.lang.String))
    X (WButtonPeer::void create (sun.awt.windows.WComponentPeer))

    x (WColor::java.awt.Color getDefaultColor (int))

    x (GifImageDecoder::boolean parseImage (int int int int boolean int byte[] byte[] java.awt.image.IndexColorModel))

    x (WGraphics::void createFromComponent (sun.awt.windows.WComponentPeer))
    x (WGraphics::void createFromGraphics (sun.awt.windows.WGraphics))
      (WGraphics::void createFromPrintJob (sun.awt.windows.WPrintJob))
      (WGraphics::void createFromHDC (int))
    x (WGraphics::void imageCreate (sun.awt.image.ImageRepresentation))
    x (WGraphics::void pSetFont (java.awt.Font))
    X (WGraphics::void pSetForeground (int))
      (WGraphics::void _dispose ())
    x (WGraphics::void dispose ())
    x (WGraphics::void setPaintMode ())
    x (WGraphics::void setXORMode (java.awt.Color))
    o (WGraphics::java.awt.Rectangle getClipBounds ())
    o (WGraphics::void changeClip (int int int int boolean))
      (WGraphics::void removeClip ())
    X (WGraphics::void clearRect (int int int int))
    X (WGraphics::void fillRect (int int int int))
    X (WGraphics::void drawRect (int int int int))
      (WGraphics::void drawSFChars (char[] int int int int))
    x (WGraphics::int drawMFCharsSegment (java.awt.Font sun.awt.FontDescriptor char[] int int int int))
      (WGraphics::int drawMFCharsConvertedSegment (java.awt.Font sun.awt.FontDescriptor byte[] int int int))
      (WGraphics::void drawBytes (byte[] int int int int))
    X (WGraphics::void drawLine (int int int int))
    X (WGraphics::void copyArea (int int int int int int))
    o (WGraphics::void drawRoundRect (int int int int int int))
    o (WGraphics::void fillRoundRect (int int int int int int))
    X (WGraphics::void drawPolygon (int[] int[] int))
      (WGraphics::void drawPolyline (int[] int[] int))
    X (WGraphics::void fillPolygon (int[] int[] int))
    x (WGraphics::void drawOval (int int int int))
    x (WGraphics::void fillOval (int int int int))
    x (WGraphics::void drawArc (int int int int int int))
    x (WGraphics::void fillArc (int int int int int int))
      (WGraphics::void print (sun.awt.windows.WComponentPeer))
      (WGraphics::void close (sun.awt.windows.WPrintJob))
      (JPEGImageDecoder::void readImage (java.io.InputStream byte[]))
    o (OffScreenImageSource::void sendPixels ())


    additional native methods added by microsoft (sigh):

    X (java.lang.String::boolean equals (java.lang.String))
    X (java.lang.String::int length (java.lang.String))
    o (java.lang.Runtime::void setInputStreamLocalised (java.io.DataInputStream))
    o (java.lang.Runtime::void setOutputStreamLocalised (java.io.DataOutputStream))

      (java.lang.String::int compareTo (java.lang.String))
      (java.lang.String::boolean equalsIgnoreCase (java.lang.String))
      (java.lang.String::int indexOf (java.lang.String int))
      (java.lang.String::boolean startsWith (java.lang.String int))
      (java.lang.String::boolean regionMatches (int java.lang.String int int))
      (java.lang.String::boolean regionMatches (boolean int java.lang.String int int))
      (java.lang.String::int lastIndexOf (java.lang.String int))
      (java.lang.ClassLoader::void resolveClass (java.lang.Class))

      (java.lang.ClassLoader::java.lang.Class createArrayClass (java.lang.String java.lang.Class))
      (java.io.PrintStream::boolean isOutputStreamLocalised (java.io.DataOutputStream))
      (java.lang.Runtime::boolean isOutputStreamLocalised (java.io.DataOutputStream))
      (java.lang.Runtime::boolean isInputStreamLocalised (java.io.DataInputStream))
      (java.lang.ThreadGroup::void initMainThreadGroup0 (java.lang.ThreadGroup))
      (java.lang.System::void validateSecurityManager (java.lang.SecurityManager))
      (java.lang.Class::java.lang.reflect.Method getMethod2 (int java.lang.String java.lang.String))
      (java.io.ObjectOutputStream::void invokeDefaultWriteObject (java.lang.Object java.lang.Class))
      (java.io.ObjectOutputStream::void invokeWriteObject (java.lang.Object java.lang.Class))
      (java.io.ObjectInputStream::void invokeDefaultReadObject (java.lang.Object java.lang.Class))
      (java.io.ObjectInputStream::void invokeReadObject (java.lang.Object java.lang.Class))
      (java.util.TimeZone::java.util.TimeZone getWin32TimeZone ())
      (java.net.InetAddress::java.lang.Object[] lookupHostByName (java.lang.String))
      (java.net.InetAddress::java.lang.Object[] lookupHostByAddr (int))
      (java.io.ObjectStreamClass::void doMismatchedRead (java.io.ObjectInputStream java.lang.Object))
      (java.io.ObjectStreamClass::long getClassDefinedUID (java.lang.Class))
      (java.io.ObjectStreamClass::boolean findObjectMethod0 (java.lang.Class int))
      (java.lang.reflect.Method::java.lang.String getDescriptor ())
      (java.lang.reflect.Array::void setShort (java.lang.Object int unsigned short))
      (java.lang.reflect.Array::char getChar (java.lang.Object int))
      (java.lang.reflect.Array::void setChar (java.lang.Object int char))
      (java.lang.reflect.Array::void setDouble (java.lang.Object int double))
      (java.lang.reflect.Array::java.lang.Object get (java.lang.Object int))
      (java.lang.reflect.Array::void set (java.lang.Object int java.lang.Object))
      (java.lang.reflect.Array::int getInt (java.lang.Object int))
      (java.lang.reflect.Array::void setInt (java.lang.Object int int))
      (java.lang.reflect.Array::java.lang.Object multiNewArray (java.lang.Class int[]))
      (java.lang.reflect.Array::boolean getBoolean (java.lang.Object int))
      (java.lang.reflect.Array::byte getByte (java.lang.Object int))
      (java.lang.reflect.Array::float getFloat (java.lang.Object int))
      (java.lang.reflect.Array::void setBoolean (java.lang.Object int boolean))
      (java.lang.reflect.Array::long getLong (java.lang.Object int))
      (java.lang.reflect.Array::void setByte (java.lang.Object int byte))
      (java.lang.reflect.Array::void setLong (java.lang.Object int long))
      (java.lang.reflect.Array::void setFloat (java.lang.Object int float))
      (java.lang.reflect.Array::java.lang.Object newArray (java.lang.Class int))
      (java.lang.reflect.Array::int getLength (java.lang.Object))
      (java.lang.reflect.Array::unsigned short getShort (java.lang.Object int))
      (java.lang.reflect.Array::double getDouble (java.lang.Object int))
      (java.lang.reflect.Field::void setShort (java.lang.Object unsigned short))
      (java.lang.reflect.Field::char getChar (java.lang.Object))
      (java.lang.reflect.Field::void setChar (java.lang.Object char))
      (java.lang.reflect.Field::void setDouble (java.lang.Object double))
      (java.lang.reflect.Field::java.lang.Object get (java.lang.Object))
      (java.lang.reflect.Field::void set (java.lang.Object java.lang.Object))
      (java.lang.reflect.Field::int getInt (java.lang.Object))
      (java.lang.reflect.Field::void setInt (java.lang.Object int))
      (java.lang.reflect.Field::boolean getBoolean (java.lang.Object))
      (java.lang.reflect.Field::byte getByte (java.lang.Object))
      (java.lang.reflect.Field::float getFloat (java.lang.Object))
      (java.lang.reflect.Field::long getLong (java.lang.Object))
      (java.lang.reflect.Field::void setBoolean (java.lang.Object boolean))
      (java.lang.reflect.Field::void setByte (java.lang.Object byte))
      (java.lang.reflect.Field::void setLong (java.lang.Object long))
      (java.lang.reflect.Field::void setFloat (java.lang.Object float))
      (java.lang.reflect.Field::int getModifiers ())
      (java.lang.reflect.Field::unsigned short getShort (java.lang.Object))
      (java.lang.reflect.Field::double getDouble (java.lang.Object))
      (java.lang.reflect.Constructor::java.lang.Object newInstance (java.lang.Object[]))
      (java.lang.reflect.Constructor::int getModifiers ())
      (java.util.zip.Inflater::void setDictionary0 (byte[] int int))
      (java.util.zip.Inflater::int getTotalIn0 ())
      (java.util.zip.Inflater::void reset0 ())
      (java.util.zip.Inflater::void end0 ())
      (java.util.zip.Inflater::int inflate0 (byte[] int int))
      (java.util.zip.Inflater::int getTotalOut0 ())
      (java.util.zip.Inflater::int getAdler0 ())
      (java.util.zip.CRC32::void update1 (int))
      (java.util.zip.CRC32::void update (byte[] int int))

      (com.ms.security.PolicyEngine::boolean isSystemClass (java.lang.String))
      (com.ms.security.PolicyEngine::void denyPermission (com.ms.security.PermissionID))
      (com.ms.security.PolicyEngine::void revertPermission (com.ms.security.PermissionID))
      (com.ms.security.PolicyEngine::void initPolicyEngine ())
      (com.ms.security.PolicyEngine::java.lang.Class _getClassOfCaller (java.lang.Class[]))
      (com.ms.security.PolicyEngine::void internalCheckClass (java.lang.Class com.ms.security.PermissionID java.lang.Object))
      (com.ms.security.PolicyEngine::com.ms.security.PermissionDataSet getPermissionsOfClass (java.lang.Class))
      (com.ms.security.PolicyEngine::void assertPermission (com.ms.security.PermissionID))
      (com.ms.security.PolicyEngine::void deepCheck (com.ms.security.PermissionID java.lang.Object))
      (com.ms.security.PolicyEngine::void shallowCheck (com.ms.security.PermissionID java.lang.Object java.lang.Class[] int))
      (com.ms.security.PolicyEngine::java.security.Principal getPrincipalOfClass (java.lang.Class))
      (com.ms.security.permissions.ThreadPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.ThreadPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.RegistryPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.RegistryPermission::byte[] pEncodeAsn ())
      (com.ms.security.management.ZonePermissions::byte[] pEncodeAsn ())
      (com.ms.security.management.ZonePermissions::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.UIPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.UIPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.NetIOPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.NetIOPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.ReflectionPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.ReflectionPermission::boolean pDecodeAsn (byte[]))
      (com.ms.vm.WeakReference::void storeRef (int java.lang.Object))
      (com.ms.vm.WeakReference::int allocRef (java.lang.Object))
      (com.ms.vm.WeakReference::void freeRef (int))
      (com.ms.vm.WeakReference::java.lang.Object fetchRef (int))
      (com.ms.dll.DllLib::void CoTaskMemFree (int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int float[] int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int double[] int int))
      (com.ms.dll.DllLib::int numParamBytes0 (java.lang.reflect.Method))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int java.lang.Object int int))
      (com.ms.dll.DllLib::void write2 (java.lang.Object int unsigned short))
      (com.ms.dll.DllLib::void write2 (int int unsigned short))
      (com.ms.dll.DllLib::void write2 (java.lang.Object int char))
      (com.ms.dll.DllLib::void write2 (int int char))
      (com.ms.dll.DllLib::int GlobalAlloc (int int))
      (com.ms.dll.DllLib::void resize (java.lang.Object int))
      (com.ms.dll.DllLib::long read8 (java.lang.Object int))
      (com.ms.dll.DllLib::long read8 (int int))
      (com.ms.dll.DllLib::int lstrcpy (java.lang.StringBuffer int))
      (com.ms.dll.DllLib::int lstrlenA (int))
      (com.ms.dll.DllLib::int read4 (java.lang.Object int))
      (com.ms.dll.DllLib::int CoTaskMemAlloc (int))
      (com.ms.dll.DllLib::void write8 (java.lang.Object int long))
      (com.ms.dll.DllLib::int sizeOf0 (java.lang.Class))
      (com.ms.dll.DllLib::int getSystemDefaultCharSize ())
      (com.ms.dll.DllLib::void write8 (int int long))
      (com.ms.dll.DllLib::int read4 (int int))
      (com.ms.dll.DllLib::byte read1 (java.lang.Object int))
      (com.ms.dll.DllLib::byte read1 (int int))
      (com.ms.dll.DllLib::int lstrlen (int))
      (com.ms.dll.DllLib::void CopyMemoryAnsi (int java.lang.String int))
      (com.ms.dll.DllLib::void CopyMemoryAnsi (java.lang.StringBuffer int int))
      (com.ms.dll.DllLib::boolean isStruct (java.lang.reflect.Field))
      (com.ms.dll.DllLib::boolean GlobalFree (int))
      (com.ms.dll.DllLib::void internalAttemptCopyPtrToStruct (int java.lang.Object int int))
      (com.ms.dll.DllLib::int getLastError ())
      (com.ms.dll.DllLib::void write4 (java.lang.Object int int))
      (com.ms.dll.DllLib::void write4 (int int int))
      (com.ms.dll.DllLib::unsigned short read2 (java.lang.Object int))
      (com.ms.dll.DllLib::unsigned short read2 (int int))
      (com.ms.dll.DllLib::void release (java.lang.Object))
      (com.ms.dll.DllLib::void write1 (java.lang.Object int byte))
      (com.ms.dll.DllLib::void write1 (int int byte))
      (com.ms.dll.DllLib::boolean isStructCls (java.lang.Class))
      (com.ms.dll.DllLib::void prelink (java.lang.reflect.Method))
      (com.ms.dll.DllLib::void CopyMemoryUni (int java.lang.String int))
      (com.ms.dll.DllLib::void CopyMemoryUni (java.lang.StringBuffer int int))
      (com.ms.dll.DllLib::void internalAttemptCopyStructToPtr (java.lang.Object int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (int int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (byte[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (char[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (unsigned short[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (int[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (long[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (float[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (double[] int int int))
      (com.ms.dll.DllLib::void CopyWithSrcOffset (java.lang.Object int int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int int int int))
      (com.ms.dll.DllLib::int lstrlenW (int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int byte[] int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int char[] int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int unsigned short[] int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int int[] int int))
      (com.ms.dll.DllLib::void CopyWithDstOffset (int long[] int int))
      (com.ms.dll.DllLib::int internalGetStructAddr (java.lang.Object))
      (com.ms.dll.DllLib::int offsetOf (java.lang.reflect.Field))
      (com.ms.dll.DllLib::int lstrcpy (int java.lang.String))
      (com.ms.dll.DllLib::int sizeOf (java.lang.Object))
      (com.ms.lang.RegKey::com.ms.lang.RegKeyEnumValue pRegEnumValue (int))
      (com.ms.lang.RegKey::java.lang.String pRegQueryStringValue (java.lang.String))
      (com.ms.lang.RegKey::byte[] pRegQueryBinaryValue (java.lang.String))
      (com.ms.lang.RegKey::int pRegQueryIntValue (java.lang.String))
      (com.ms.lang.RegKey::void pRegSetStringValue (java.lang.String java.lang.String))
      (com.ms.lang.RegKey::void pRegSetIntValue (java.lang.String int))
      (com.ms.lang.RegKey::void pRegSetBinaryValue (java.lang.String byte[]))
      (com.ms.lang.RegKey::void pRegDeleteValue (java.lang.String))
      (com.ms.lang.RegKey::void pRegFlushKey ())
      (com.ms.lang.RegKey::void pRegDeleteKey (java.lang.String))
      (com.ms.lang.RegKey::void pRegOpenBaseKey (int))
      (com.ms.lang.RegKey::void pRegOpenKey (com.ms.lang.RegKey java.lang.String int))
      (com.ms.lang.RegKey::int pRegQueryInfoKey (com.ms.lang.RegQueryInfo))
      (com.ms.lang.RegKey::void pRegUnLoadKey (java.lang.String))
      (com.ms.lang.RegKey::void pRegCreateKey (com.ms.lang.RegKey java.lang.String))
      (com.ms.lang.RegKey::void pRegRestoreKey (java.lang.String boolean))
      (com.ms.lang.RegKey::void pRegLoadKey (java.lang.String java.lang.String))
      (com.ms.lang.RegKey::void pRegCloseKey ())
      (com.ms.lang.RegKey::java.lang.String pRegEnumKey (int))
      (com.ms.lang.RegKey::void pRegReplaceKey (java.lang.String java.lang.String java.lang.String))
      (com.ms.awt.peer.NativeServices::int pGetKeyboardLayouts (int[] int))
      (com.ms.awt.peer.NativeServices::void jpegReadByte (com.ms.awt.peer.IjpegDecoderCallback byte[] int com.ms.awt.peer.jpegInfoHeader byte[] int))
      (com.ms.awt.peer.NativeServices::int getColourDataDepth ())
      (com.ms.awt.peer.NativeServices::java.lang.String pGetFontEnumeratedFamily (int))
      (com.ms.awt.peer.NativeServices::int pNewFontEnumeration ())
      (com.ms.awt.peer.NativeServices::int getScreenClipRgn (int))
      (com.ms.awt.peer.NativeServices::int pSetKeyboardLayout (int int))
      (com.ms.awt.peer.NativeServices::void ClipboardInit (com.ms.awt.peer.IToolkit))
      (com.ms.awt.peer.NativeServices::void getDeviceCaps (int int[] int))
      (com.ms.awt.peer.NativeServices::void getAfcMetrics (int[]))
      (com.ms.awt.peer.NativeServices::void setUserLocale (int int))
      (com.ms.awt.peer.NativeServices::void getDCDI (com.ms.awt.peer.DirectColourDataInfo))
      (com.ms.awt.peer.NativeServices::int pGetNumKeyboardLayouts ())
      (com.ms.awt.peer.NativeServices::void getIndexedColours (byte[] byte[] byte[]))
      (com.ms.awt.peer.NativeServices::int getNativeFont (java.lang.String int int int))
      (com.ms.awt.peer.NativeServices::int pGetKeyboardLayout ())
      (com.ms.awt.peer.NativeServices::int getSystemLCID ())
      (com.ms.awt.peer.NativeServices::void caretSetPos (int int int))
      (com.ms.awt.peer.NativeServices::java.lang.String getLogFontFromIUnknown (com.ms.com.IUnknown com.ms.awt.peer.LogFontX))
      (com.ms.awt.peer.NativeServices::java.lang.String ClipboardGetText ())
      (com.ms.awt.peer.NativeServices::int systemMetric (int))
      (com.ms.awt.peer.NativeServices::void jpegInit (com.ms.awt.peer.IjpegDecoderCallback byte[] int com.ms.awt.peer.jpegInfoHeader))
      (com.ms.awt.peer.NativeServices::void caretHide (int))
      (com.ms.awt.peer.NativeServices::int chooseColor (int int))
      (com.ms.awt.peer.NativeServices::java.lang.String pGetKeyboardLayoutName (int))
      (com.ms.awt.peer.NativeServices::int matchFontAndLanguage (int int))
      (com.ms.awt.peer.NativeServices::java.lang.String chooseFont (com.ms.awt.peer.LogFontX java.lang.String int))
      (com.ms.awt.peer.NativeServices::java.lang.String getSystemFont (int com.ms.awt.peer.LogFontX))
      (com.ms.awt.peer.NativeServices::com.ms.com.IUnknown getIUnknownFromLogFont (java.lang.String com.ms.awt.peer.LogFontX))
      (com.ms.awt.peer.NativeServices::void caretDispose (int))
      (com.ms.awt.peer.NativeServices::void caretShow (int))
      (com.ms.awt.peer.NativeServices::void deleteObject (int))
      (com.ms.awt.peer.NativeServices::void setDebugOutput (com.ms.awt.peer.COMPrintCallback))
      (com.ms.awt.peer.NativeServices::void jpegReadInt (com.ms.awt.peer.IjpegDecoderCallback byte[] int com.ms.awt.peer.jpegInfoHeader int[] int))
      (com.ms.awt.peer.NativeServices::int getSystemColourValue (int))
      (com.ms.awt.peer.NativeServices::void caretCreate (int int int))
      (com.ms.awt.peer.NativeServices::void ClipboardSetText (java.lang.String))
      (com.ms.awt.peer.NativeServices::void println (java.lang.String))
      (com.ms.security.SecurityClassLoader::boolean getSecureState ())
      (com.ms.security.SecurityClassLoader::void setSecureState (java.lang.String java.lang.String))
      (com.ms.security.SecurityClassLoader::java.lang.Class internalDefineClass (java.lang.String byte[] int int))
      (com.ms.security.SecurityClassLoader::void markClass (java.lang.Class com.ms.security.PermissionSet java.security.Principal))
      (com.ms.security.SecurityClassLoader::java.util.Hashtable getHashTable ())
      (com.ms.security.auditing.SecurityAuditor::boolean isThreadAuditingEnabled ())
      (com.ms.security.auditing.SecurityAuditor::void disableThreadAuditing ())
      (com.ms.security.auditing.SecurityAuditor::void enableThreadAuditing ())
      (com.ms.security.auditing.SecurityAuditor::void initSecurityAuditor ())
      (com.ms.security.PermissionDataSet::byte[] pEncodeAsn ())
      (com.ms.security.PermissionDataSet::boolean pDecodeAsn (byte[]))
      (com.ms.lang.SystemX::int pAnsiToUnicode (byte[] char[] int int int))
      (com.ms.lang.SystemX::int pQueryUnicodeToAnsi (char[] int int int))
      (com.ms.lang.SystemX::void gc ())
      (com.ms.lang.SystemX::boolean arrayCompare (java.lang.Object[] int java.lang.Object[] int int))
      (com.ms.lang.SystemX::int pUnicodeToAnsi (char[] byte[] int int int))
      (com.ms.lang.SystemX::boolean isLocalCharDBCSLeadByte (byte))
      (com.ms.lang.SystemX::int pQueryAnsiToUnicode (byte[] int int int))
      (com.ms.lang.SystemX::boolean isBaseDBCS ())
      (com.ms.lang.SystemX::java.lang.reflect.Method getMethod2 (java.lang.Class int java.lang.String java.lang.String))
      (com.ms.packagemanager.JavaPackage::byte[] nativeGetSigner (java.lang.Object))
      (com.ms.packagemanager.JavaPackage::byte[] nativeGetCapabilities (java.lang.Object))
      (com.ms.com._Guid::void IIDFromString (java.lang.String com.ms.com._Guid))
      (com.ms.com._Guid::java.lang.String StringFromIID (com.ms.com._Guid))
      (com.ms.security.auditing.PrintStreamAuditor::int GetModuleHandle (java.lang.String))
      (com.ms.security.auditing.PrintStreamAuditor::int FormatMessage (int int int int java.lang.StringBuffer int int[]))
      (com.ms.security.permissions.CustomPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.CustomPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.X509Signer::boolean pLoad (byte[]))
      (com.ms.packagemanager.PackageManager::java.lang.Class nativeFindClassInNamespace (java.lang.String java.lang.String java.lang.ClassLoader))
      (com.ms.packagemanager.PackageManager::java.lang.Object nativeGetPackage (java.lang.String java.lang.String))
      (com.ms.packagemanager.PackageManager::java.lang.String[] nativeGetBeansList ())
      (com.ms.packagemanager.PackageManager::com.ms.com.IStream nativeGetFileIStream (java.lang.String java.lang.String))
      (com.ms.packagemanager.PackageManager::java.lang.Class nativeFindClass (java.lang.String java.lang.String java.lang.ClassLoader))
      (com.ms.security.permissions.UserFileIOPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.UserFileIOPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.PropertyPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.PropertyPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.ClientStoragePermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.ClientStoragePermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.ExecutionPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.ExecutionPermission::boolean pDecodeAsn (byte[]))
      (com.ms.util.EventLog::boolean DeregisterEventSource (int))
      (com.ms.util.EventLog::void reportEvent0 (unsigned short unsigned short int java.lang.String[] byte[]))
      (com.ms.util.EventLog::int RegisterEventSource (java.lang.String java.lang.String))
      (com.ms.applet.BrowserAppletFrame::void signalViewChange (int))
      (com.ms.applet.BrowserAppletFrame::java.lang.Object newInstance (int java.lang.Class boolean com.ms.security.PermissionSet))
      (com.ms.applet.BrowserAppletFrame::void showSystemStatus (int int boolean java.lang.String))
      (com.ms.applet.BrowserAppletFrame::com.ms.security.management.SecurityPolicy getSecurityPolicy0 (int java.lang.String))
      (com.ms.applet.BrowserAppletFrame::void setDownloadState (int boolean))
      (com.ms.applet.BrowserAppletFrame::int GetSystemDefaultLCID ())
      (com.ms.applet.BrowserAppletFrame::void requestResize (int int int))
      (com.ms.applet.BrowserAppletFrame::void signalObjectLoadDone (int boolean))
      (com.ms.applet.BrowserAppletFrame::com.ms.applet.BrowserAppletFrame findOfflineContext ())
      (com.ms.applet.BrowserAppletFrame::void showStatus0 (int java.lang.String))
      (com.ms.applet.BrowserAppletFrame::boolean checkGlobalOfflineMode0 ())
      (com.ms.applet.BrowserAppletFrame::void showDocument0 (int java.lang.String java.lang.String))
      (com.ms.security.permissions.SystemStreamsPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.SystemStreamsPermission::boolean pDecodeAsn (byte[]))
      (com.ms.security.permissions.FileIOPermission::byte[] pEncodeAsn ())
      (com.ms.security.permissions.FileIOPermission::boolean pDecodeAsn (byte[]))
      (com.ms.com.ComLib::int newGCHandle (java.lang.Object))
      (com.ms.com.ComLib::java.lang.Object derefGCHandle (int))
      (com.ms.com.ComLib::void dprinthelper (char[]))
      (com.ms.com.ComLib::void release (java.lang.Object))
      (com.ms.com.ComLib::int jcdwClassSizeOf (java.lang.Class))
      (com.ms.com.ComLib::int jcdwOffsetOf (java.lang.Object java.lang.String))
      (com.ms.com.ComLib::int jcdwClassOffsetOf (java.lang.Class java.lang.String))
      (com.ms.com.ComLib::boolean isJavaOwned (java.lang.Object))
      (com.ms.com.ComLib::void brk (java.lang.Object))
      (com.ms.com.ComLib::void setDataWrapperSize (java.lang.Object int))
      (com.ms.com.ComLib::void brk (int))
      (com.ms.com.ComLib::void setJCDWHomeThread (java.lang.Object java.lang.Object))
      (com.ms.com.ComLib::void propagateOwnership (java.lang.Object int))
      (com.ms.com.ComLib::void threadStartMTA (java.lang.Thread))
      (com.ms.com.ComLib::void IENVNextMarshalerJ2C (int))
      (com.ms.com.ComLib::boolean supportsInterface (java.lang.Object com.ms.com._Guid))
      (com.ms.com.ComLib::java.lang.Object ptrToStruct (java.lang.Class int))
      (com.ms.com.ComLib::int jcdwSizeOf (java.lang.Object))
      (com.ms.com.ComLib::void declareMessagePumpThread ())
      (com.ms.com.ComLib::void IENVNextMarshalerC2J (int))
      (com.ms.com.ComLib::void freeGCHandle (int))
      (com.ms.com.ComLib::boolean isEqualUnknown (java.lang.Object java.lang.Object))
      (com.ms.com.Dispatch::boolean NIsArray (java.lang.Object))
      (com.ms.com.Dispatch::java.lang.String NInvokeReal (java.lang.Object com.ms.com._Guid java.lang.String int int int int com.ms.com.Variant[] com.ms.com.Variant[] int[]))
      (com.ms.com.Dispatch::void NGetIDsOfNamesReal (java.lang.Object com.ms.com._Guid int java.lang.String[] int[]))
      (com.ms.com.ComException::int FormatMessage (int int int int java.lang.StringBuffer int int[]))
      (com.ms.com.Variant::int toInt ())
      (com.ms.com.Variant::double toDate ())
      (com.ms.com.Variant::boolean toBoolean ())
      (com.ms.com.Variant::double toDouble ())
      (com.ms.com.Variant::long toCurrency ())
      (com.ms.com.Variant::void putVariantArray (com.ms.com.Variant[]))
      (com.ms.com.Variant::com.ms.com.Variant[] getVariantArray ())
      (com.ms.com.Variant::void putByteArray (java.lang.Object))
      (com.ms.com.Variant::void putShortRef (unsigned short))
      (com.ms.com.Variant::void putIntRef (int))
      (com.ms.com.Variant::void putDoubleRef (double))
      (com.ms.com.Variant::void putDateRef (double))
      (com.ms.com.Variant::void putStringRef (java.lang.String))
      (com.ms.com.Variant::unsigned short getShortRef ())
      (com.ms.com.Variant::int getIntRef ())
      (com.ms.com.Variant::double getDoubleRef ())
      (com.ms.com.Variant::double getDateRef ())
      (com.ms.com.Variant::java.lang.String getStringRef ())
      (com.ms.com.Variant::java.lang.String internalToString ())
      (com.ms.com.Variant::void initSafeArrayByRef (com.ms.com.SafeArray int))
      (com.ms.com.Variant::java.lang.Object toCharArray ())
      (com.ms.com.Variant::java.lang.Object toDispatch ())
      (com.ms.com.Variant::byte toByte ())
      (com.ms.com.Variant::java.lang.Object getDispatch ())
      (com.ms.com.Variant::void putDispatch (java.lang.Object))
      (com.ms.com.Variant::boolean getBoolean ())
      (com.ms.com.Variant::int toError ())
      (com.ms.com.Variant::java.lang.Object toObject ())
      (com.ms.com.Variant::void initSafeArrayByVal (com.ms.com.SafeArray int))
      (com.ms.com.Variant::java.lang.Object getObject ())
      (com.ms.com.Variant::void putObject (java.lang.Object))
      (com.ms.com.Variant::com.ms.com.SafeArray toSafeArrayHelper (java.lang.Class))
      (com.ms.com.Variant::void putFloatRef (float))
      (com.ms.com.Variant::void putCurrencyRef (long))
      (com.ms.com.Variant::void putErrorRef (int))
      (com.ms.com.Variant::void putBooleanRef (boolean))
      (com.ms.com.Variant::void putObjectRef (java.lang.Object))
      (com.ms.com.Variant::void putByteRef (byte))
      (com.ms.com.Variant::java.lang.String getString ())
      (com.ms.com.Variant::void putString (java.lang.String))
      (com.ms.com.Variant::float getFloatRef ())
      (com.ms.com.Variant::long getCurrencyRef ())
      (com.ms.com.Variant::int getErrorRef ())
      (com.ms.com.Variant::boolean getBooleanRef ())
      (com.ms.com.Variant::java.lang.Object getObjectRef ())
      (com.ms.com.Variant::byte getByteRef ())
      (com.ms.com.Variant::float toFloat ())
      (com.ms.com.Variant::void putCharArray (java.lang.Object))
      (com.ms.com.Variant::void putDispatchRef (java.lang.Object))
      (com.ms.com.Variant::java.lang.Object getDispatchRef ())
      (com.ms.com.Variant::void putVariantArrayRef (com.ms.com.Variant[]))
      (com.ms.com.Variant::com.ms.com.Variant[] getVariantArrayRef ())
      (com.ms.com.Variant::void changeType (unsigned short))
      (com.ms.com.Variant::void ncloneIndirect (com.ms.com.Variant))
      (com.ms.com.Variant::void nFinalize (boolean))
      (com.ms.com.Variant::void nclone (com.ms.com.Variant))
      (com.ms.com.Variant::unsigned short toShort ())
      (com.ms.com.Variant::void putSafeArrayRefHelper (int))
      (com.ms.com.Variant::com.ms.com.Variant[] toVariantArray ())
      (com.ms.com.Variant::java.lang.Object toByteArray ())
      (com.ms.com.Variant::void TrueVariantClear ())
      (com.ms.awt.WToolkit::boolean MessageBeep (int))
      (com.ms.applet.AppletPanel::boolean StartCodeDownload (int java.lang.String java.lang.String java.lang.String))
      (com.ms.applet.AppletPanel::void securedCall0 (int java.lang.Object))
      (com.ms.applet.AppletPanel::com.ms.security.PermissionSet getDefaultPermissionsFromLoader (com.ms.vm.loader.URLClassLoader))
      (com.ms.dll.Win32Exception::int FormatMessage (int int int int java.lang.StringBuffer int int[]))
      (com.ms.awt.WGuiCallback::boolean SetEvent (int))
      (com.ms.awt.WGuiCallback::int CreateSemaphore (int int int int))
      (com.ms.awt.WGuiCallback::int ReleaseSemaphore (int int int))
      (com.ms.awt.WGuiCallback::void userYield (boolean))
      (com.ms.awt.WGuiCallback::int MsgWaitForMultipleObjects (int int[] boolean int int))
      (com.ms.awt.WGuiCallback::int CreateEvent (int boolean boolean int))
      (com.ms.activeX.ActiveXToolkit::int GetSysColor (int))
      (com.ms.awt.peer.NativeGraphics::void setPageDimension (int int))
      (com.ms.awt.peer.NativeGraphics::void setBkColour (int int))
      (com.ms.awt.peer.NativeGraphics::void getClipBounds (com.ms.awt.peer.NativeRect int int))
      (com.ms.awt.peer.NativeGraphics::void pGetCharOutline (int byte[]))
      (com.ms.awt.peer.NativeGraphics::void drawLine (int int int int))
      (com.ms.awt.peer.NativeGraphics::void setXORMode (int int int int))
      (com.ms.awt.peer.NativeGraphics::int drawString (java.lang.String int int int int int int int int[] int[]))
      (com.ms.awt.peer.NativeGraphics::int getCoClass ())
      (com.ms.awt.peer.NativeGraphics::void drawArc (int int int int int int int))
      (com.ms.awt.peer.NativeGraphics::void getInitialPageDimension (com.ms.awt.peer.NativeRect))
      (com.ms.awt.peer.NativeGraphics::void setVisRgn (int))
      (com.ms.awt.peer.NativeGraphics::void pSetForeground (int int))
      (com.ms.awt.peer.NativeGraphics::int pGetDC ())
      (com.ms.awt.peer.NativeGraphics::void drawPixels (int[] int int int))
      (com.ms.awt.peer.NativeGraphics::void drawPolygon (int[] int[] int int int int))
      (com.ms.awt.peer.NativeGraphics::void createFromImage (com.ms.awt.peer.INativeImage))
      (com.ms.awt.peer.NativeGraphics::void endPage ())
      (com.ms.awt.peer.NativeGraphics::int pGetCharOutlineSize (int))
      (com.ms.awt.peer.NativeGraphics::void pDrawBezier (int int int[] int))
      (com.ms.awt.peer.NativeGraphics::int drawBytes (byte[] int int int int int))
      (com.ms.awt.peer.NativeGraphics::void changeClip (int int int int boolean))
      (com.ms.awt.peer.NativeGraphics::int drawChars (char[] int int int int int int int int int int[] int[]))
      (com.ms.awt.peer.NativeGraphics::void drawT2Curve (float float float float float float int int))
      (com.ms.awt.peer.NativeGraphics::void createFromPrintJob (java.lang.String com.ms.awt.peer.SPJData))
      (com.ms.awt.peer.NativeGraphics::void endPrintJob ())
      (com.ms.awt.peer.NativeGraphics::void pSetOrigin (int int))
      (com.ms.awt.peer.NativeGraphics::void createFromHDC (int))
      (com.ms.awt.peer.NativeGraphics::void drawOval (int int int int int))
      (com.ms.awt.peer.NativeGraphics::int pSetFont (java.lang.String int int int))
      (com.ms.awt.peer.NativeGraphics::void setPaintMode (int int))
      (com.ms.awt.peer.NativeGraphics::void startPage ())
      (com.ms.awt.peer.NativeGraphics::void clearClip ())
      (com.ms.awt.peer.NativeGraphics::void createFromCopy (com.ms.awt.peer.INativeGraphics))
      (com.ms.awt.peer.NativeGraphics::void scanLines (int int[] int int int int))
      (com.ms.awt.peer.NativeGraphics::void drawRoundRect (int int int int int int int))
      (com.ms.awt.peer.NativeGraphics::void dispose ())
      (com.ms.awt.peer.NativeGraphics::void clearRect (int int int int int))
      (com.ms.awt.peer.NativeGraphics::void copyArea (int int int int int int))
      (com.ms.awt.peer.NativeGraphics::void createFromWindow (int))
      (com.ms.awt.peer.NativeGraphics::void drawPolyline (int[] int[] int int int))
      (com.ms.awt.peer.NativeGraphics::void drawRect (int int int int int))
      (com.ms.awt.peer.CToolkit::void callbackEventLoop (com.ms.awt.peer.IToolkitCallback))
      (com.ms.awt.peer.CToolkit::int getToolkitHwnd ())
      (com.ms.awt.peer.CToolkit::int createCompHwnd (int int))
      (com.ms.awt.peer.CNativeSystemIME::void setCompositionFont (int int))
      (com.ms.awt.peer.CNativeSystemIME::void setCompositionPos (int int int))
      (com.ms.awt.peer.CNativeSystemIME::void setOpenStatus (int int))
      (com.ms.awt.peer.CNativeSystemIME::int getOpenStatus (int))
      (com.ms.awt.peer.CNativeSystemIME::java.lang.String getCompositionString (int))
      (com.ms.awt.peer.CNativeSystemIME::java.lang.String getCompositionResultString (int))
      (com.ms.net.wininet.WininetStreamHandlerFactory::int initNative (java.lang.String))
      (com.ms.com.SafeArray::void rawGetVariantAs (int com.ms.com.Variant))
      (com.ms.com.SafeArray::void NSafeArrayInit (int))
      (com.ms.com.SafeArray::float rawGetDouble (int))
      (com.ms.com.SafeArray::void NRawBoolCopyToJavaArray (int int boolean[] int))
      (com.ms.com.SafeArray::void validateArray (int))
      (com.ms.com.SafeArray::void NSafeArrayCreateFromString (java.lang.String))
      (com.ms.com.SafeArray::void rawSetString (int java.lang.String))
      (com.ms.com.SafeArray::int getInt (int))
      (com.ms.com.SafeArray::void setInt (int int))
      (com.ms.com.SafeArray::boolean getBoolean (int))
      (com.ms.com.SafeArray::void setBoolean (int boolean))
      (com.ms.com.SafeArray::int computeOffset (int))
      (com.ms.com.SafeArray::void NSafeArrayNullInit ())
      (com.ms.com.SafeArray::void rawSetVariant (int com.ms.com.Variant))
      (com.ms.com.SafeArray::float rawGetFloat (int))
      (com.ms.com.SafeArray::float getFloat (int))
      (com.ms.com.SafeArray::void setFloat (int float))
      (com.ms.com.SafeArray::int computeOffset2 (int int))
      (com.ms.com.SafeArray::void rawSetDouble (int double))
      (com.ms.com.SafeArray::java.lang.String asString ())
      (com.ms.com.SafeArray::void NRawCopyToJavaArray (int int java.lang.Object int))
      (com.ms.com.SafeArray::void NSafeArrayCreate (int int int[] int[]))
      (com.ms.com.SafeArray::void NRawBoolCopyFromJavaArray (boolean[] int int int))
      (com.ms.com.SafeArray::void NSafeArrayDestroy (boolean boolean))
      (com.ms.com.SafeArray::int NSafeArrayCopy ())
      (com.ms.com.SafeArray::int rawGetInt (int))
      (com.ms.com.SafeArray::boolean rawGetBoolean (int))
      (com.ms.com.SafeArray::void rawSetFloat (int float))
      (com.ms.com.SafeArray::java.lang.String rawGetString (int))
      (com.ms.com.SafeArray::int NTotalNumElems ())
      (com.ms.com.SafeArray::double getDouble (int))
      (com.ms.com.SafeArray::void setDouble (int double))
      (com.ms.com.SafeArray::void Nreinit (com.ms.com.SafeArray))
      (com.ms.com.SafeArray::int getPhysicalSafeArray ())
      (com.ms.com.SafeArray::int NgetdwordAt (int))
      (com.ms.com.SafeArray::void NRawCopyFromJavaArray (java.lang.Object int int int))
      (com.ms.com.SafeArray::void rawSetBoolean (int boolean))
      (com.ms.com.SafeArray::void rawSetInt (int int))
      (com.ms.awt.peer.CNativeComponent::void invalidate (int int int int))
      (com.ms.awt.peer.CNativeComponent::void hideModal ())
      (com.ms.awt.peer.CNativeComponent::void hide ())
      (com.ms.awt.peer.CNativeComponent::void setOnTop (int))
      (com.ms.awt.peer.CNativeComponent::void registerDragDrop ())
      (com.ms.awt.peer.CNativeComponent::void endValidate ())
      (com.ms.awt.peer.CNativeComponent::void enable ())
      (com.ms.awt.peer.CNativeComponent::void disable ())
      (com.ms.awt.peer.CNativeComponent::void setTitle (java.lang.String))
      (com.ms.awt.peer.CNativeComponent::void getBounds (com.ms.awt.peer.NativeRect))
      (com.ms.awt.peer.CNativeComponent::int gethwnd ())
      (com.ms.awt.peer.CNativeComponent::void showModal ())
      (com.ms.awt.peer.CNativeComponent::void setCursor (int))
      (com.ms.awt.peer.CNativeComponent::void reshape (int int int int))
      (com.ms.awt.peer.CNativeComponent::void requestFocus ())
      (com.ms.awt.peer.CNativeComponent::void callDefWindowProc (int int int int))
      (com.ms.awt.peer.CNativeComponent::void registerCustomDropTarget (com.ms.com.IUnknown))
      (com.ms.awt.peer.CNativeComponent::void setNoActivate (boolean))
      (com.ms.awt.peer.CNativeComponent::void getPlaceOnScreen (com.ms.awt.peer.NativeRect))
      (com.ms.awt.peer.CNativeComponent::void beginValidate ())
      (com.ms.awt.peer.CNativeComponent::void clippedReshape (int int int int int))
      (com.ms.awt.peer.CNativeComponent::void setResizable (boolean))
      (com.ms.awt.peer.CNativeComponent::void setIcon (int))
      (com.ms.awt.peer.CNativeComponent::void toBack ())
      (com.ms.awt.peer.CNativeComponent::void setFrameHost (com.ms.awt.peer.IBrowserAppletFrameCallback))
      (com.ms.awt.peer.CNativeComponent::void toFront ())
      (com.ms.awt.peer.CNativeComponent::void show ())
      (com.ms.awt.peer.CNativeComponent::void updateInsets (com.ms.awt.peer.NativeInsets))
      (com.ms.awt.peer.CNativeComponent::void dispose ())
      (com.ms.awt.peer.CNativeComponent::void initFromJavaWindow (int com.ms.awt.peer.IComponentCallback com.ms.awt.peer.INativeComponent com.ms.awt.peer.IToolkit int))
      (com.ms.awt.peer.CNativeComponent::void init (int com.ms.awt.peer.IComponentCallback com.ms.awt.peer.INativeComponent com.ms.awt.peer.IToolkit))
      (com.ms.awt.peer.CNativeComponent::void beginDrag (com.ms.awt.peer.INativeDragCallback))
      (com.ms.fx.RegionConverter::int computeNativeRegion (int[]))
      (com.ms.fx.RegionConverter::int[] computeJavaRegion (int))
      (com.ms.net.wininet.URLUtils::java.lang.String canonicalizeURL (java.lang.String int))
      (com.ms.net.wininet.URLUtils::java.lang.String combineURL (java.lang.String java.lang.String int))
      (com.ms.awt.peer.NativeFontMetrics::int bytesWidth (byte[] int int))
      (com.ms.awt.peer.NativeFontMetrics::int stringWidth (java.lang.String int int[]))
      (com.ms.awt.peer.NativeFontMetrics::int charsWidth (char[] int int int int[]))
      (com.ms.awt.peer.NativeFontMetrics::java.lang.String init (com.ms.awt.peer.INativeGraphics int[] java.lang.String int int int))
      (com.ms.io.console.Console::int MessageBox (int java.lang.String java.lang.String int))
      (com.ms.awt.peer.NativeFileDialog::void show (com.ms.awt.peer.IFileDialogCallback java.lang.String java.lang.String java.lang.String int com.ms.awt.peer.INativeComponent int int))
      (com.ms.security.management.SecurityZone::byte[] pLoadCustomPermissions (int int java.lang.String))
      (com.ms.awt.peer.NativeImage::int setBytePixelsDirected (int int int int com.ms.awt.peer.DirectColourModelData byte[] int int com.ms.awt.peer.INativeImageBufferDone))
      (com.ms.awt.peer.NativeImage::void create (int int int int))
      (com.ms.awt.peer.NativeImage::int setIntPixelsIndexed (int int int int int[] int int[] int int com.ms.awt.peer.INativeImageBufferDone))
      (com.ms.awt.peer.NativeImage::int getCoClass ())
      (com.ms.awt.peer.NativeImage::int getIcon (int int int))
      (com.ms.awt.peer.NativeImage::int setBytePixelsIndexed (int int int int int[] int byte[] int int com.ms.awt.peer.INativeImageBufferDone))
      (com.ms.awt.peer.NativeImage::void sendPixels (com.ms.awt.peer.SPData))
      (com.ms.awt.peer.NativeImage::void fillPixels (com.ms.awt.peer.SPData byte[]))
      (com.ms.awt.peer.NativeImage::void dispose ())
      (com.ms.awt.peer.NativeImage::void init (int int int int int))
      (com.ms.awt.peer.NativeImage::int setIntPixelsDirected (int int int int com.ms.awt.peer.DirectColourModelData int[] int int com.ms.awt.peer.INativeImageBufferDone))
      (com.ms.awt.peer.NativeImage::void imageDrawStretched (com.ms.awt.peer.INativeGraphics int int int int int int int int int int))
      (com.ms.awt.peer.NativeImage::int finish (int))
      (com.ms.awt.peer.NativeImage::void imageDraw (int int int int int))
      (com.ms.awt.peer.NativeResource::java.lang.String loadString (int))
      (com.ms.awt.peer.NativeResource::int openDialogFromID (int))
      (com.ms.awt.peer.NativeResource::boolean attach (java.lang.String))
      (com.ms.awt.peer.NativeResource::void loadBytes (int int java.lang.String byte[] int))
      (com.ms.awt.peer.NativeResource::int getSize (int int java.lang.String))
      (com.ms.awt.peer.NativeResource::void detach ())
      (com.ms.awt.peer.NativeResource::int openDialogFromName (java.lang.String))
      (com.ms.net.wininet.WininetURLConnection::com.ms.applet.BrowserAppletFrame findOfflineContext ())
      (com.ms.com.DispatchProxy::void finalize ())
      (com.ms.com.DispatchProxy::void init (com.ms.com._Guid java.lang.reflect.Method[] int[]))
      (com.ms.net.wininet.WininetInputStream::void close ())
      (com.ms.net.wininet.WininetInputStream::int read (byte[] int int))
      (com.ms.net.wininet.WininetInputStream::int available ())
      (com.ms.net.wininet.WininetInputStream::long skip (long))
      (com.ms.net.wininet.WininetInputStream::void connect (java.lang.String boolean boolean java.lang.SecurityManager))
      (com.ms.vm.loader.CabSignatureInfo::com.ms.vm.loader.CabSignatureInfo extractFromFile0 (java.lang.String com.ms.security.management.SecurityPolicy))
      (com.ms.net.wininet.http.HttpInputStream::byte[] getResponseHeaders ())
      (com.ms.net.wininet.http.HttpInputStream::void close0 ())
      (com.ms.net.wininet.http.HttpInputStream::void connect (java.lang.String int java.lang.String boolean boolean boolean boolean byte[] byte[] java.lang.SecurityManager))
      (com.ms.vm.loader.CabCracker::int GetTempFileName (java.lang.StringBuffer java.lang.String int java.lang.StringBuffer))
      (com.ms.vm.loader.CabCracker::void getBytes0 (int int byte[]))
      (com.ms.vm.loader.CabCracker::void cleanup ())
      (com.ms.vm.loader.CabCracker::int GetTempPath (int java.lang.StringBuffer))
      (com.ms.vm.loader.CabCracker::void load0 ())


"
!

performance1
    "
     JAVA::BenchMark new loopmark
     JAVA::BenchMark new logicmark
     JAVA::BenchMark new sievemark
     JAVA::BenchMark new methodmark
     JAVA::BenchMark new stringmark
     JAVA::BenchMark new newstringmark
     JAVA::BenchMark new neweststringmark


    "
"
                    caffmark  loopmark  logicmark  sievemark  methodmark  stringmark  float  image  graphic dialog newstringmark  neweststringmark
 linux:
   P6/233 No JIT                 84         87        90          40          22                                       17              10
                      103       133        142       137          28          73       109    167     18    140

   P6/233 JIT                   479       2459       393         649          28                                       21              12
   P6/233 JIT         473      1805       3046       439         986          28                                       21              12
                      533      1808       3382       613        1003          25       105    143      1
                      668      3330       3644       740
                      793      4116       3731      1243        1365         120       103     79      2
                      914      4480       4061                  2290          68       106    158     19     34
                      941      4607       4149      1238        2434          75       101    152     18     32
                                                                             591              164
                     1087                           1836                     800       110                   35
                     1102      4592       4270      1844        2381         841       109    169     21     35
                     1177      4608       4309      1810        2432         895       532    182     20     35


 w95
   P5/200 JIT          90        95         90        95         686          18        60     54      7
                      428      1657       2385       684         957          21        61     62      9
                      541      2886       2589       823         976          18        62     55      7
                      583      3062       2635       842         861         223        65     57      8
                      616      3075       2438      1081        1324         218        64     54      8
                      718      3138       2755      1085        1200         816        63     48      9      7

                    caffmark  loopmark  logicmark  sievemark  methodmark  stringmark  float  image  graphic dialog newstringmark  neweststringmark
"
!

performance2
    "
     symantec benchmarks


    "
"
		BubbleSort    BidirBubbleSort  QuickSort  Sieve   Hanoi   Dhry   Fib   Array   Tree   Total

   ST/X+J Linux
   233Mhz P6
   No JIT          352767         354597         69585    43048  101638  28961 108839  48815

   ST/X+J Linux
   233Mhz P6
   JIT             128724         116810         20259    39733   83160  27613  52093  33166  43996  545554
		   124744         101428         17239    10052    8264  14004  38821  23252  33709  374660
   +IINC           120324                                  7265
   +IADD op2       100173          90737         18128     6996    7423  17093  48559  44209  57056  390374
   +ISUB op2                       90460         17547             5921                       57056  390461
   +ICMPEQ/NE       99785          90147                           5792                43482  56486  388255
   +ICMP            87398          78214         15784     7574    5628  12812  38481  24654  32252  302797
   +IFICMPLE        84198          74928         13814     5650          11674         23241         293118
   +IFICMPxx        76867          69738         12208                          37505  21973  32104  273569
   +IFICMPEQ/NE                                                    5580  11202         21723
   const IFICMPxx                                11856             5463  11032  37372                272726
   +lea for add/sub
   +BALOAD                                       11700     4600    5015   9431
   +BASTORE                                                3279
   +CALOAD/CASTORE                                                        8907
   regSave change   66119          60365          9997             4917  15386  37851  38202  50027  286497
		    64858          58360          9476             4889  15001  37211  36288  48313  278478
		    63146          55949          9302                   14899
		    62970          56085          9352     3226    4837   8779  37573  22815  33899  241297
   -O               43662          40292          7181     2530    4696   8170  34555  22116  32337  195539

   +IALOAD          39162          36347
   +IASTORE         32461          30663          4299             3667                19556  30563  166868

   -IALOAD/IASTORE
										34167  19347
										       19232  29726
										       18821
   +AALOAD/BALOAD
		    41490          39527          6776     3315    4077   8443  33895  19152  28018  184693
		    41291          37034          6593                          32682
   +ATHROW                                                                6449                       180079
   +IASTORE         38848          35601          6219             3796   6122         17869  30085  175106
   IINC delayed code
   +ANEWARRAY                                              3263
   +LADD/LSUB const 38719          35256                                  6062  27071                172859

							   2837                 22835
   +ISTORE into arg
									  3080
   quick L2I for ints                                                     2774  21184
   +*ASTORE / *ALOAD
    again                                                  1621    3654   1525
   +CHECKCAST                                                      3574                       25810

------------------------------------------------------------------------------------------------------------
		BubbleSort    BidirBubbleSort  QuickSort  Sieve   Hanoi   Dhry   Fib   Array   Tree   Total
   ST/X+J Win95
   200Mhz P5
   JIT              78490          77060         15220     4840    6370   9180  73160  36080         351700
				   76900         13560             5500   9010         35200         348600
										66080         69920  370750
   +IADD non consts 76620          73210         13180     3790                 63550         58880  356900
											      51740
		    77390          72450         12520     3900    6040   8950  62450  34330  57780  335810
		    77220          71950                           5270   8840                       338650
		    72390          70690                                                      48010  327370
		    74910          66740         11420                    8620  61730  33340  47350  313940
   +xALOAD/JMP_ZERO
		    71740                                  2800
		    71460          65250         11540     2750                 62180  33840  50750  311660
   +LCMP                                                                        59100
   better abs(I)
   +xALOAD/IF_ICMPx 66130          61520         12080     3300    5280   8190  56510  33830  50310  297150
   elim dummy static                                               5210                       48270
   methods                                                                                    44160
		   119020         112440         19330     3070    4560   2640  56960  37730  52790  408540
------------------------------------------------------------------------------------------------------------
		BubbleSort    BidirBubbleSort  QuickSort  Sieve   Hanoi   Dhry   Fib   Array   Tree   Total


   Sun JDK         274625         244461         52676    50653   65183  26668  78133  28572  61608  882583
   (90Mhz P5)

   Microsoft J++     9684           8452          2874     1733    3535   3665   3836   4746  25717   64242
   (90Mhz P5)

   Symantec Cafe    14541          12198          3686     1922    4527   3325   3425  12969  26829   83422
   JIT 1.02
   (90Mhz P5)

   Symantec Cafe     8292           6970          2714     1613    3345   3235   2013   4516  13180   45878
   JIT 1.2
   (90Mhz P5)
"

"
   |b|

   b := JAVA::BubbleSortAlgorithm new.
   b perform:#'setData(JJ)V' with:10000 with:0 with:0 with:0.
   Time millisecondsToRun:[
       b performTest.
   ]
"
"
   |b|

   b := JAVA::QSortAlgorithm new.
   b perform:#'setData(JJ)V' with:500000 with:0 with:0 with:0.
   Time millisecondsToRun:[
       b performTest.
   ]
"
"
   |t|

   t := JAVA::Tree new.
   t perform:#'setData(JJ)V' with:1000000 with:0 with:0 with:0.
   Time millisecondsToRun:[
       t performTest.
   ]
"
"
   |t|

   t := JAVA::Array new.
   t perform:#'setData(JJ)V' with:1000000 with:0 with:0 with:0.
   Time millisecondsToRun:[
       t performTest.
   ]
"

! !

!JavaVM class methodsFor:'initialization'!

boot

    Java initialize.
    self initializeVM.

    "Created: / 21-02-2012 / 18:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compile:source selector:smalltalkSelector asJavaMethod:javaSelector fakedSource:fakedSource in:aClass
    "install additional java protocol in smalltalk classes, req'd for java programs"

    |cloneCode|

    (aClass implements:javaSelector) ifFalse:[
        Class packageQuerySignal answer:'__temporary__'
        do:[
            aClass
                compile:source
                classified:'java support'
                logged:false.
        ].

        cloneCode := aClass compiledMethodAt:smalltalkSelector.
        cloneCode source:fakedSource.

        Class withoutUpdatingChangesDo:[
            aClass removeSelector:smalltalkSelector.
            aClass addSelector:javaSelector withMethod:cloneCode.
        ]
    ].

    "Created: / 5.11.1998 / 19:30:22 / cg"
    "Modified: / 5.11.1998 / 19:37:57 / cg"
!

deinitialize
    StandardThreadGroup := nil.

    KnownWindows notNil ifTrue: [
        KnownWindows do: [:v | v isTopView ifTrue: [ v destroy ] ]
    ].
    JavaWindowGroup := nil.
    KnownWindows := nil.
    OpenFileTable := nil.
    JavaMethods := nil.
    SystemClassLoader := nil.
    SystemProperties := nil.

    "
     JavaVM deinitialize
    "

    "Created: / 03-01-1998 / 21:28:14 / cg"
    "Modified: / 03-12-1998 / 20:33:21 / cg"
    "Modified: / 28-01-2011 / 14:11:35 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 16-11-2011 / 09:46:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

deinitializeAdditionalJavaProtocol
    "deinstall additional java protocol in smalltalk classes, req'd for java programs"

    #(
        #'clone()Ljava/lang/Object;'
        #'equals(Ljava/lang/Object;)Z'
        #'toString()Ljava/lang/String;'
        #'getClass()Ljava/lang/Class;'
     ) do:[:sel |
        (Object implements:sel) ifTrue:[
            Class withoutUpdatingChangesDo:[
                Object removeSelector:sel.
            ]
        ].
    ].

    "
     self deinitializeAdditionalJavaProtocol
    "

    "Created: / 4.2.1998 / 21:37:10 / cg"
    "Modified: / 5.12.1998 / 15:27:39 / cg"
!

flushClasses

    ClassRegistry notNil ifTrue:[
        ClassRegistry flush
    ].

    "Created: / 30-10-2011 / 16:09:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    DUMMY_LONG_HIGHWORD := 1.
    DUMMY_DOUBLE_HIGHWORD := 2.
    StandardThreadGroup := nil.
    NoAudio := true.

    "/ NoAudio := false.

    JavaConsoleStream := "Transcript"Stdout.
    FullExceptionTrace := StackTrace := false.
    WindowOPTrace := DrawOPTrace := EventTrace := ThreadTrace := false.
    MonitorTrace := ExceptionTrace := FileOpenTrace := FileIOTrace := false.
    ExceptionDebug := ExitDebug := false.
    ExceptionDebugPatterns := Set new.
    WindowCreationTrace := false.
    FileOpenConfirmation := false.
    SocketConnectConfirmation := false.
    WindowOPTrace := false.
    MonitorTrace := false.
    ThreadTrace := false.
    UnhandledJavaExceptionSignal := (Signal new) mayProceed: true.
    UnhandledJavaExceptionSignal nameClass: self
        message: #unhandledJavaExceptionSignal.
    UnhandledJavaExceptionSignal notifierString: 'unhandled java exception'.
    JavaExceptionSignal := (Signal new) mayProceed: false.
    JavaExceptionSignal nameClass: self message: #javaExceptionSignal.
    JavaExceptionSignal notifierString: 'java exception'.
    UnimplementedInstructionSignal := (Signal new) mayProceed: false.
    UnimplementedInstructionSignal nameClass: self
        message: #unimplementedInstructionSignal.
    UnimplementedInstructionSignal notifierString: 'unimplemented instruction'.
    UnimplementedNativeMethodSignal := (Signal new) mayProceed: false.
    UnimplementedNativeMethodSignal nameClass: self
        message: #unimplementedNativeMethodSignal.
    UnimplementedNativeMethodSignal
        notifierString: 'unimplemented native method'.
    BadMessageSignal := (Signal new) mayProceed: false.
    BadMessageSignal nameClass: self message: #badMessageSignal.
    BadMessageSignal notifierString: 'invalid message to JAVA object'.
    InternalErrorSignal := (Signal new) mayProceed: false.
    InternalErrorSignal nameClass: self message: #internalErrorSignal.
    InternalErrorSignal notifierString: 'internal error'.
    CallHandlerSignal := (Signal new) mayProceed: false.
    CallHandlerSignal nameClass: self message: #callHandlerSignal.
    CallHandlerSignal notifierString: 'internal signal'.
    StdinReplacementFileQuerySignal := QuerySignal new.
    StdinReplacementFileQuerySignal nameClass: self
        message: #stdinReplacementFileQuerySignal.
    StdinReplacementFileQuerySignal notifierString: 'asking for stdin stream'.
    JavaPrivilegedAccessQuery := QuerySignal new.
    JavaPrivilegedAccessQuery defaultAnswer: false.
    AssertionsEnabled := true.
    self initializeClassRegistry.
    FinalizationEnabled := true.
    EagerResolvingEnabled := false.

    ObjectMemory addDependent: self.


    "
     JavaVM initialize"

    "Created: / 02-01-1998 / 18:02:34 / cg"
    "Modified: / 02-12-1998 / 23:02:22 / cg"
    "Modified: / 09-10-2011 / 20:29:10 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-12-2011 / 21:06:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 03-09-2013 / 00:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeAdditionalJavaProtocol
    "install additional java protocol in smalltalk classes, req'd for java programs"

    "/ since we use smalltalk Arrays for JavaArray, some
    "/ additional (java-) protocol is required.
    "/ This is also useful, when Smalltalk objects are passed to
    "/ java ...
    "/ We should implement all of the java.lang.Object protocol in
    "/ Object, to be on the bright side of life; more of this later ...

    self
        compile:'__clone
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ self shallowCopy'
        selector:#'__clone'
        asJavaMethod:#'clone()Ljava/lang/Object;'
        fakedSource:'#''clone()Ljava/lang/Object;''
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ self shallowCopy'
        in:Object.

    "/ ------------------------------------------------------------

    self
        compile:'__equals:arg
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ (arg = self) ifTrue:[1] ifFalse:[0]'
        selector:#'__equals:'
        asJavaMethod:#'equals(Ljava/lang/Object;)Z'
        fakedSource:'#''equals(Ljava/lang/Object;)Z''
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ (arg = self) ifTrue:[1] ifFalse:[0]'
        in:Object.

    "/ ------------------------------------------------------------

    self
        compile:'__toString
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ Java as_String:(self displayString)'
        selector:#'__toString'
        asJavaMethod:#'toString()Ljava/lang/String;'
        fakedSource:'#''toString()Ljava/lang/String;''
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ Java as_String:(self displayString)'
        in:Object.

    "/ ------------------------------------------------------------

    self
        compile:'__getClass
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ JavaVM javaClassObjectForClass:self class'
        selector:#'__getClass'
        asJavaMethod:#'getClass()Ljava/lang/Class;'
        fakedSource:'#''getClass()Ljava/lang/Class;''
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ JavaVM javaClassObjectForClass:self class'
        in:Object.

    "/ ------------------------------------------------------------

    self
        compile:'__hashCode
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ self identityHash'
        selector:#'__hashCode'
        asJavaMethod:#'hashCode()I'
        fakedSource:'#''hashCode()I''
    "this is smalltalk code with a java selector ...
     (This source cannot be accepted in the browser,
      since it has a funny selector.)
     Has been added by JavaVM>>initializeAdditionalJavaProtocol"

    ^ self identityHash'
        in:Object.


    "
     self initializeAdditionalJavaProtocol
    "

    "Modified: / 28-01-1997 / 19:38:58 / stefan"
    "Modified: / 22-01-1998 / 21:23:40 / av"
    "Created: / 04-02-1998 / 21:35:46 / cg"
    "Modified: / 30-12-1998 / 21:07:55 / cg"
    "Modified: / 25-10-2010 / 16:26:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeBaseClasses
    "load req'd base classes"

    _java_lang_Object_CLASS := _java_lang_System_CLASS := _java_lang_Class_CLASS := nil.

    #( 'java.lang.Object' 'java.lang.Class' 'java.lang.String' 'java.lang.System' ) do: [:cName |
        (self classForName: cName definedBy: nil) isNil ifTrue: [
            AbortSignal raise.
            ^ self
        ]
    ].
    "
     self initializeBaseClasses"

    "Created: / 03-01-1998 / 21:13:28 / cg"
    "Modified: / 23-12-1999 / 19:27:42 / cg"
    "Modified: / 21-05-2013 / 16:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeClassReader
    "/Nothing to do"

    JavaClassReader initialize.

    "Created: / 06-09-2012 / 11:18:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeClassRegistry
    ClassRegistry isNil ifTrue:[
        ClassRegistry := JavaClassRegistry new.
    ] ifFalse:[
        ClassRegistry flush.
    ]

    "Created: / 03-09-2013 / 00:50:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeJavaResources
    self initializeMonitorTable.
    self initializePrimitiveClasses.
    self initializeOpenFileTable.

    "
     JavaVM releaseAllMonitors"

    "Created: / 02-01-1998 / 18:04:05 / cg"
    "Modified: / 07-01-1998 / 22:58:10 / cg"
    "Created: / 16-11-2011 / 14:23:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-08-2012 / 11:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeMonitorTable
    LockTable := WeakIdentityDictionary new:32000.
    LockTableAccess := Semaphore "RecursionLock" forMutualExclusion.
    LockTableAccess name: 'JavaVM lock table access mutex'.
    Logger
        log: 'Initializing EnteredMonitorsPerProcess'
        severity: Logger severityDEBUG
        facility: #JVM.
    EnteredMonitorsPerProcess := IdentityDictionary new.
    Logger
        log: 'Initializing AcquiredMonitorsPerProcess'
        severity: Logger severityDEBUG
        facility: #JVM.
    AcquiredMonitorsPerProcess := IdentityDictionary new.

    "
     JavaVM initializeMonitorTable"

    "Created: / 17-08-2012 / 11:30:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 13:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeNatives

    NativeMethodsImplementation := Java release javaNativeMethodsImplementation.

    "Created: / 18-02-2013 / 14:54:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeOpenFileTable
    OpenFileTable := OrderedCollection
                        with:Stdin
                        with:("JavaConsoleStream ?" Stdout)
                        with:("JavaConsoleStream ?" Stderr).
    OpenFileTableLock := RecursionLock new.

    "
     JavaVM initializeOpenFileTable
    "

    "Modified: / 06-08-1997 / 00:40:19 / cg"
    "Created: / 02-01-1998 / 18:04:32 / cg"
    "Modified: / 30-07-2012 / 18:12:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializePrimitiveClasses


    "/    #(
    "/        (#byte    'B' 1)
    "/        (#short   'S' 2)
    "/        (#int     'I' 4)
    "/        (#long    'J' 8)
    "/        (#boolean 'Z' 1)
    "/        (#char    'C' 2)
    "/        (#float   'F' 4)
    "/        (#double  'D' 8)
    "/        (#void    'V' 0)
    "/    ) triplesDo:[:nm :sig :len |
    "/        |jClass classInst|
    "/
    "/        "/
    "/        "/ create a javaClass for it.
    "/        "/
    "/        jClass := Java at:'java.lang.Class'.
    "/        jClass notNil ifTrue:[
    "/            classInst := jClass new.
    "/            JavaClasses at:nm put:classInst.
    "/            JavaClasses at:classInst put:nm.
    "/        ]
    "/    ].
    "
     self initializePrimitiveClasses"

    "Modified: / 22-10-1998 / 01:56:02 / cg"
    "Modified: / 20-12-2010 / 23:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 14:57:38 / Marcel Hlopko <hlopik@gmail.com>"
!

initializeReflection

    Reflection := ReflectionRegistry for: self.

    "Created: / 21-12-2010 / 19:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-01-2013 / 20:55:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSimulatedLibs
    "return a collection of native libs which are considered
     being already loaded. (used with jdk < 1.2)"

    LibPath := #(
                        '__builtIn__'
                        '/usr/local/lib'
                        '/usr/local/lib/java'
                ).

    SimulatedLibs := #(
                        '__builtIn__/net'
                        '__builtIn__/awt'
                        '__builtIn__/tawt'
                        '__builtIn__/winawt'
                        '__builtIn__/jpeg'
                        '__builtIn__/mmedia'
                        '__builtIn__/zip'
                        '__builtIn__/math'
                        '__builtIn__/sysresource'

                        "/ KAVA ...
                        '__builtIn__/agent'

                        "/ MS-java ...
                        '__builtIn__/msawt'
                        '__builtIn__/javart'

                        "/ 1.1.8
                        '__builtIn__/jpeg_sun'
                      ).

    "
     self initializeSimulatedLibs
    "

    "Created: / 4.1.1998 / 19:05:03 / cg"
    "Modified: / 17.11.1998 / 23:53:02 / cg"
!

initializeSimulatedNativeLibs
    "return a collection of native libs which are considered
     being already loaded (used with jdk >= 1.2)"

    OperatingSystem isOSXlike ifTrue: [
        SimulatedNativeLibs := #( 'libawt.jnilib' 
                                  'libnet.jnilib' 
                                  'libcmm.jnilib' 
                                  'libzip.jnilib' 
                                  'libnio.jnilib'
                                  'libmanagement.jnilib'    "/ Management Beans - req'd by Tomcat
                                  'libjpeg.jnilib'          "/ Some UI stuff - req'd by Tomcat !!?!!    
                                  "/ 'liblcms.so' 
                                  'libfontmanager.so'       "/ req'd by java.text.Bidi
                                  "/ 'libj2pkcs11.so'          "/ req'd by Smack and some crypto stuff
                                    ).
        ^ self.
    ].
    OperatingSystem isUNIXlike ifTrue: [
        SimulatedNativeLibs := #( 'libawt.so' 
                                  'libnet.so' 
                                  'libcmm.so' 
                                  'libzip.so' 
                                  'libnio.so'
                                  'libmanagement.so'        "/ Management Beans - req'd by Tomcat
                                  'libjpeg.so' 'liblcms.so' "/ Some UI stuff - req'd by Tomcat !!?!!
                                  'libfontmanager.so'       "/ req'd by java.text.Bidi
                                  'libj2pkcs11.so'          "/ req'd by Smack and some crypto stuff
                                    ).
        ^ self.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue: [
        SimulatedNativeLibs := #( 'awt.dll' 
                                  'net.dll' 
                                  'cmm.dll' 
                                  'zip.dll' 
                                  'nio.so'
                                  'management.dll'        "/ Management Beans - req'd by Tomcat
                                  'fontmanager.dll'       "/ req'd by java.text.Bidi
                                  'j2pkcs11.dll'          "/ req'd by Smack and some crypto stuff
                                  'dt_shmem.dll'          "/ req'd by JDI on Windows / Oracle JDK 7
                                ).
        ^ self.
    ].
    SimulatedNativeLibs := #().

    "
     self initializeSimulatedNativeLibs"

    "Modified: / 27-01-1998 / 18:43:10 / cg"
    "Modified: / 03-11-2011 / 19:00:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2011 / 23:03:35 / jv"
    "Modified: / 14-11-2013 / 14:26:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSimulatedNativeMemory

    SimulatedNativeMemory := JavaNativeMemory new.

    "Created: / 07-12-2010 / 21:07:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2010 / 23:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSystemClassLoader

    | java_lang_ClassLoader stx_libjava_ClassLoader |

    java_lang_ClassLoader := JavaVM classForName: 'java.lang.ClassLoader'.
    (SystemClassLoader := java_lang_ClassLoader instVarNamed:#scl) isNil ifTrue:[
        SystemClassLoader := java_lang_ClassLoader perform: #'getSystemClassLoader()Ljava/lang/ClassLoader;'
    ].

    stx_libjava_ClassLoader := JavaVM classForName: 'stx.libjava.ClassLoader' definedBy: SystemClassLoader.
    (SmalltalkClassLoader := stx_libjava_ClassLoader instVarNamed:#scl) isNil ifTrue:[
        SmalltalkClassLoader := stx_libjava_ClassLoader perform: #'getSmalltalkClassLoader()Ljava/lang/ClassLoader;'
    ].

    "Created: / 30-10-2011 / 12:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-12-2013 / 17:56:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSystemPropertiesInto: props
    | cpu  cpu2  os dir |

    "/ use JAVA compatible cpu-name
    cpu := OperatingSystem getCPUType.
    cpu2 := cpu.
    cpu = 'i386' ifTrue: [ cpu := 'ix86' ].
    (OperatingSystem getSystemInfo at: #machine) = 'x86_64' ifTrue: [
        cpu2 := 'amd64'
    ].
    SimulatedOS notNil ifTrue: [ os := SimulatedOS ] ifFalse: [
        os := OperatingSystem getOSType.
        os := os asUppercaseFirst.
    ].
    props addPairsFrom: {
                'java.runtime.name'.
                    'OpenJDK Runtime Environment'.
                'sun.boot.library.path'.
                    OperatingSystem isMSWINDOWSlike ifTrue: [
                        (Java release javaBinDirOnWindows) asString
                    ] ifFalse: [
                        OperatingSystem isOSXlike ifTrue:[
                            "/ JV: Why's that?
                            (Java release javaNativeLibDirOnUnix) asString 
                        ] ifFalse:[
                            (Java release javaLibDirOnUnix / cpu2) asString 
                        ].
                    ].
                'java.vm.version'.
                    Smalltalk versionString.
                'java.vm.vendor'.
                    'eXept Software AG & SWING Research Group'.
                'java.vendor.url'.
                    'http://www.exept.de & http://swing.fit.cvut.cz'.
                'path.separator'.
                    OperatingSystem pathSeparator asString.
                'java.vm.name'.
                    'Smalltalk/X'.
                'file.encoding.pkg'.
                    'sun.io'.
                'sun.java.launcher'.
                    'SUN_STANDARD'.
                'user.country'.
                    'US'.
                'sun.os.patch.level'.
                    'unknown'.
                'java.vm.specification.name'.
                    'Java Virtual Machine Specification'.
                'user.dir'.
                    Filename currentDirectory pathName.
                'java.awt.graphicsenv'.
                    'sun.awt.X11GraphicsEnvironment'.
                'java.endorsed.dirs'.
                    (Java release javaLibDir / 'endorsed') asString.
                'os.arch'.
                    cpu.
                'java.io.tmpdir'.
                    Filename tempDirectory pathName.
                'line.separator'.
                    Character cr asString.
                'java.vm.specification.vendor'.
                    'Sun Microsystems Inc.'.
                'os.name'.
                    os.
                'sun.jnu.encoding'.
                    'UTF-8'.
                'java.library.path'.
                    self defaultJavaLibraryPath.
                'java.specification.name'.
                    'Java Platform API Specification'.
                'java.class.version'.
                    Java release systemProperty_java_class_version.
                'sun.management.compiler'.
                    'Smalltalk/X jinterpreter'.
                'os.version'.
                    OperatingSystem isMSWINDOWSlike ifTrue: [
                        OperatingSystem getSystemInfo at: #release
                    ] ifFalse: [ 
                        OperatingSystem getSystemInfo at: #version 
                    ].
                'user.home'.
                    Filename homeDirectory pathName.
                'user.timezone'.
                    ''.
                'java.awt.printerjob'.
                    'sun.print.PSPrinterJob'.
                'file.encoding'.
                    'UTF-8'.
                'java.specification.version'.
                    Java release systemProperty_java_specification_version.
                'java.class.path'.
                    self defaultCLASSPATH.
                'user.name'.
                    OperatingSystem getLoginName.
                'java.vm.specification.version'.
                    '1.0'.
                 "'sun.java.command'            . 
                    'SystemProperties' ."
                'java.home'.
                    Java release jreHome pathName.
                'sun.arch.data.model'.
                    '32'.
                'user.language'.
                    Smalltalk language.
                'java.specification.vendor'.
                    'Sun Microsystems Inc.'.
                'java.vm.info'.
                    Smalltalk fullVersionString.
                'java.version'.
                    Java release systemProperty_java_version.
                'java.ext.dirs'.
                    self defaultExtDirs.
                'sun.boot.class.path'.
                    self defaultSunBootLibraryPath.
                'java.vendor'.
                    'Sun Microsystems Inc.'.
                'file.separator'.
                    Filename separatorString.
                'java.vendor.url.bug'.
                    'https://swing.fit.cvut.cz/projects/stx-libjava/newticket'.
                'sun.io.unicode.encoding'.
                    'UnicodeLittle'.
                'sun.cpu.endian'.
                '   little'.
                'sun.desktop'.
                    'gnome'.
                'sun.cpu.isalist'.
                    ''
            }.

    "/ props at:'user.dir'           put:(Filename currentDirectory pathName).
    "/props at:'awt.toolkit'        put:(self defaultWindowingToolKit).

    "/ props at: 'user.country' put: 'US'.   - already done above
    props at: 'hotjava.home' put: (self defaultHotJavaHome).

    "/ new with jdk 1.1.8
    "/ undocumented ?
    "/ suppress copyright view in appletViewer ...

    props at: 'appletviewer.version' put: '1.1'.

    "/ new with jdk 1.2

    "/ props at: 'java.awt.graphicsenv' put: 'sun.awt.X11GraphicsEnvironment'.  -- already done above
    props at: 'java.awt.fonts' put: '/usr/lib/X11/fonts'.

    "/ jws
    "/props at:'jws.home'             put:(self defaultJWSHome).
    "/ new with jws 2.0 ...
    "/props at:'jws.startcmd'         put:'jws.showwin.mainide'.
"/    props at: 'un.misc.URLClassPath.debug' put: 'true'.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        props at:'java.net.preferIPv4Stack' put: 'true'.
    ].

    "/ Java tests, sigh..."

    (dir := Smalltalk getPackageDirectoryForPackage: self package) notNil ifTrue:[
        props at: 'libjava.tests.dir' put: (dir / 'tests') pathName.
    ].
    ^ props

    "
     self initializeSystemPropertiesInto:(Dictionary new)
    "

    "Created: / 03-01-1998 / 14:26:39 / cg"
    "Modified: / 27-01-2000 / 02:20:18 / cg"
    "Modified (format): / 03-11-2011 / 12:40:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-12-2011 / 23:05:11 / jv"
    "Modified: / 13-09-2012 / 20:33:56 / m"
    "Modified: / 20-11-2013 / 23:43:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeVM

    | booter blocker errorDuringInit|

    OperatingSystem initResources.

    Java initializeRelease.

    "Interpreted Java requires a huge stack. Change default to 4MB (32bit) / 8MB (64bit).
    "
    Process defaultMaximumStackSize: ((1024 * 1024 * (ExternalAddress pointerSize // 4)) max: Process defaultMaximumStackSize).

    "Java Classes are huge and there is a (unfixed) bug in 2-phase oldspace
     compress, so try to avoid it by pre-allocating more oldspace."
    OldspaceIncreased ~~ true ifTrue:[
        ObjectMemory moreOldSpace: 64"MB"*(1024*1024).
        OldspaceIncreased := true.
    ].

    SystemProperties := nil.
    ClassRegistry := JavaClassRegistry for: self.
    ClassLoaderQuerySignal := Query new.
    JavaObject autoload.
    JavaContext autoload.
    MonitorTrace isNil ifTrue: [ self initialize ].
    MonitorTraceId := 0.
    self initializeAdditionalJavaProtocol.
    self initializeJavaResources.
    JavaConsoleStream := Transcript.
    Java initAllStaticFields.
    Java markAllClassesUninitialized.
    ZipCache := OrderedCollection new.

    ZipEntryCache := OrderedCollection new.
    ZipEntryCacheFirstFree := 0.
    ZipEntryCacheLock := RecursionLock new.

    ZipInflaters := OrderedCollection new.
    FinalizationLobby := JavaFinalizationRegistry new.
    JavaVMData classVarNames do:[:nm |
        nm first == $_ ifTrue:[
            Smalltalk at: (JavaVMData globalKeyForClassVar:nm) put: nil.
        ]
    ].
    self initializeNatives.

    "/ force re-resolving;
    "/ otherwise, class-inits would not be called
    "/ by resolver ... (sigh)

    JavaNativeMethod flushAllCachedNativeMethods.
    JavaMethod allSubInstancesDo: [ :m |
            m clearJittedCodeAndForceJittingAgain.
            "/ m checked: false; code: nil.
    ].
    ObjectMemory flushCaches.

    "/ sigh - must flush inline caches.

    JavaClass startRememberingOrderOfClassInits.
    self initializeSimulatedLibs.

    "/ < jdk 1.2

    self initializeSimulatedNativeLibs.

    "/ >= jdk 1.2

    self initializeSimulatedNativeMemory.

    "/>  jdk 6

    ThreadInterrupts := Dictionary new.
    PerfCounters := Performance for: self.


    self initializeClassReader.
    self initializeOpenFileTable.
    self initializeReflection.
    self initializeBaseClasses.
    self initializePrimitiveClasses.

    "/ Initialization spawns couple of new threads, namely
    "/ finalization handler and signal handler. Those processes
    "/ should form their own new process group. 
    blocker := Semaphore new.

    errorDuringInit := nil.
    booter := [
        [
            Error handle:[:ex |
                errorDuringInit := ex.
                ex reject.
            ] do:[
                Java initSystemClass.
                Java initializeCurrentThread.
                self initializeSystemClassLoader.
                FinalizationLobby startFinalizationProcessAt: 5.
            ].
        ] ensure:[
            blocker signal.
        ].
    ] newProcess.
    booter name:'JVM boot process'.
    booter beGroupLeader.
    booter resume.

    blocker wait.
    errorDuringInit notNil ifTrue:[
        self error:'error during boot of JVM: ',errorDuringInit description
    ].

    ObjectMemory addDependent: self.
    StartupTime := OperatingSystem getOSTime.

    JavaNativeMethod allInstancesDo:[:e|e nCallsReset ].

    "
     JavaVM initialize.
     JavaVM initializeVM."

    "Created: / 03-01-1998 / 21:29:09 / cg"
    "Modified: / 14-12-1999 / 18:58:56 / cg"
    "Modified: / 15-10-2010 / 15:27:45 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 24-02-2012 / 13:59:29 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2012 / 14:37:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-04-2014 / 12:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeVMIfNoEventThreadRunning
    |uClass updater p|

    uClass := JAVA::sun::awt::ScreenUpdater.
    uClass notNil ifTrue:[
        updater := uClass instVarNamed:'updater'.
        updater notNil ifTrue:[
            p := self stProcessForJavaThread:updater
        ].
        (updater isNil or:[p isNil or:[p isDead]]) isNil ifTrue:[
            self initializeVM.
            ^ self.
        ]
    ].

    (JavaEventThread isNil or:[JavaEventThread isDead]) ifTrue:[
        self initializeVM
    ].

    "
     JavaVM initializeVMIfNoEventThreadRunning
    "

    "Created: / 15.1.1998 / 17:32:27 / cg"
    "Modified: / 24.12.1999 / 02:18:25 / cg"
!

reboot

    Java flushAllJavaResources.
    self boot

    "Created: / 21-02-2012 / 18:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitializeSockets
    "Reopens all server-sockets (i.e., listening sockets bound to a port).
     Called upon restarting from image"

    OpenFileTable notNil ifTrue:[
        OpenFileTable do:[:each|each isSocket ifTrue:[each reOpenIfPossible]]
    ].

    "Created: / 17-08-2012 / 15:33:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitializeVM
    |classesToInit|

    self releaseAllJavaResources.

    JavaConsoleStream := Transcript.

    Java initAllStaticFields.
    Java markAllClassesUninitialized.

    self initializeOpenFileTable.

    classesToInit := JavaClass orderOfClassInits.
    JavaClass startRememberingOrderOfClassInits.

    self initializePrimitiveClasses.
"/    Java initSystemClass.

    classesToInit do:[:jClass |
        jClass classInit
    ].
    Java initSystemClass.

    "Created: / 12-11-1998 / 15:37:52 / cg"
    "Modified: / 17-11-1998 / 16:10:11 / cg"
    "Modified: / 14-09-2011 / 22:06:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitializeVMIfNoEventThreadRunning
    (JavaEventThread isNil or:[JavaEventThread isDead]) ifTrue:[
        ^ self reinitializeVM
    ].
    (JavaEventQueueThread isNil or:[JavaEventQueueThread isDead]) ifTrue:[
        ^ self reinitializeVM
    ].

    "
     JavaVM reinitializeVMIfNoEventThreadRunning
    "

    "Created: / 24.11.1998 / 15:45:49 / cg"
    "Modified: / 24.12.1999 / 02:36:41 / cg"
!

releaseAllJavaResources
    self deinitialize.
    FirstWindowCreationSemaphore := Semaphore new.
    JavaScreenUpdaterThread := JavaEventQueueThread := nil.
    LoadedLibs := nil.
    LoadedNativeLibs := nil.
    ImageStretchCache := nil.
    LastGraphics := LastGC := nil.
    SimulatedNativeMemory := nil.
    self initializePrimitiveClasses.
    self terminateAllThreads.
    "/self releaseAllMonitors.
    self releaseAllWindows.
    self releaseAllStreams.

    "
     JavaVM releaseAllJavaResources"

    "Created: / 07-01-1998 / 22:49:42 / cg"
    "Modified: / 24-12-1999 / 02:33:11 / cg"
    "Modified: / 17-12-2010 / 17:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2011 / 20:27:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

releaseAllMonitors
    LockTable := WeakIdentityDictionary new.
    LockTableAccess := Semaphore "RecursionLock" forMutualExclusion.
    LockTableAccess name: 'JavaVM lock table access mutex'.
    EnteredMonitorsPerProcess notNil ifTrue: [
        EnteredMonitorsPerProcess
            keysAndValuesDo: [:p :value | value size > 0 ifTrue: [ self breakPoint: #mh ] ]
    ].
    self releaseLeftOverMonitors.
    Logger
        log: 'Clearing EnteredMonitorsPerProcess'
        severity: Logger severityDEBUG
        facility: #JVM.
    EnteredMonitorsPerProcess := IdentityDictionary new.
    Logger
    log: 'Clearing AcquiredMonitorsPerProcess'
    severity: Logger severityDEBUG
    facility: #JVM.
        EnteredMonitorsPerProcess := IdentityDictionary new.

    "
     JavaVM releaseAllMonitors"

    "Created: / 02-01-1998 / 18:04:05 / cg"
    "Modified: / 07-01-1998 / 22:58:10 / cg"
    "Modified: / 17-11-2011 / 17:00:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 13:58:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseAllStreams
    OpenFileTable notNil ifTrue:[
	OpenFileTable do:[:aStream |
	    aStream notNil ifTrue:[
		aStream ~~ Stdin ifTrue:[
		    aStream ~~ Stdout ifTrue:[
			aStream ~~ Stderr ifTrue:[
			    aStream ~~ JavaConsoleStream ifTrue:[
				aStream isExternalStream ifTrue:[
				    aStream shutDown
				]
			    ]
			]
		    ]
		]
	    ]
	]
    ].
    self initializeOpenFileTable.

    "
     JavaVM releaseAllStreams
    "

    "Created: / 7.1.1998 / 22:57:04 / cg"
    "Modified: / 4.2.1998 / 19:53:11 / cg"
!

releaseAllWindows
    KnownWindows notNil ifTrue:[
	KnownWindows do:[:aView |
	    aView destroy
	].
	KnownWindows := nil.
    ]

    "
     self releaseAllWindows
    "

    "Created: / 7.1.1998 / 22:58:32 / cg"
!

releaseLeftOverMonitors
    "release monitors held by dead processes"

    | deadProcesses |
    deadProcesses := IdentitySet new.
    EnteredMonitorsPerProcess notNil ifTrue: [
        EnteredMonitorsPerProcess keysAndValuesDo: [
            :p :monitors |
            p isDead ifTrue: [

                monitors do: [
                    :mon |
                    Logger
                        log: 'release leftover monitor ...'
                        severity: Logger severityDEBUG
                        facility: 'JVM'.
                    mon release
                ].
                deadProcesses add: p.
            ]
        ].
        ].
    deadProcesses do: [:p | EnteredMonitorsPerProcess removeKey: p ].

    "
     JavaVM releaseLeftOverMonitors"

    "Created: / 08-01-1998 / 17:29:26 / cg"
    "Modified: / 29-11-2011 / 14:26:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 13:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releasehSmalltalkClassLoader
    SmalltalkClassLoader := nil.

    "Created: / 09-01-2013 / 15:58:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releasehSystemClassLoader
    SystemClassLoader := nil.

    "Created: / 30-07-2012 / 17:13:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shutdown
    "Shuts down Java. All pure-java threads are terminated and
     all Java classes are unloaded. 
     Use with care, shuting down running Java may have funny consequences expecially
     when a Smalltalk thread is currently executing Java code."

    Java flushAllJavaResources.

    "Created: / 12-06-2015 / 20:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemProperties
    |props|

    (props := SystemProperties) isNil ifTrue:[
        props := Dictionary new.
        self initializeSystemPropertiesInto:props.
        SystemProperties := props
    ].
    ^ props

    "Created: / 3.1.1998 / 14:25:58 / cg"
    "Modified: / 3.1.1998 / 14:32:38 / cg"
!

update:what with:aParameter from:changedObject

    "
    #earlyRestart is send first, nothing has been setup yet.
    (should be used to flush all device dependent entries)
    "
    what == #earlyRestart ifTrue:[
        self initializeMonitorTable.

        ^self.
    ].

    "#returnFromSnapshot is sent last (should be used to restart processes, reOpen
    Streams which cannot be automatically be reopened (i.e. Sockets, Pipes) and so on.
    (Notice that positionable fileStreams are already reopened and repositioned)
    "
    what == #returnFromSnapshot ifTrue:[
        self reinitializeSockets.

        ^self
    ].
    "
     JavaVM initializeVM
    "

    ObjectMemory dependents

    "Created: / 09-01-1998 / 10:30:13 / cg"
    "Modified: / 06-11-1998 / 00:40:53 / cg"
    "Modified: / 17-08-2012 / 15:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'Signal constants'!

badMessageSignal
    ^ BadMessageSignal

    "Created: / 2.1.1998 / 18:06:52 / cg"
!

callHandlerSignal
    ^ CallHandlerSignal

    "Created: / 2.1.1998 / 18:07:16 / cg"
!

classLoaderQuerySignal

    <resource: #obsolete>

    self breakPoint: #jv.

    ^JavaClassReader classLoaderQuerySignal

    "Modified: / 28-10-2011 / 22:11:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

internalErrorSignal
    ^ InternalErrorSignal

    "Created: / 2.1.1998 / 18:07:05 / cg"
!

javaExceptionSignal
    "^ JavaExceptionSignal"
    ^JavaError

    "Created: / 02-01-1998 / 18:05:58 / cg"
    "Modified: / 01-03-2011 / 21:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

privilegedAccessQuery
    ^ JavaPrivilegedAccessQuery.

    "Created: / 09-10-2011 / 20:24:49 / Marcel Hlopko <hlopik@gmail.com>"
!

stdinReplacementFileQuerySignal
    ^ StdinReplacementFileQuerySignal

    "Created: / 2.1.1998 / 18:06:52 / cg"
!

unhandledJavaExceptionSignal
    ^ UnhandledJavaExceptionSignal

    "Created: / 2.1.1998 / 18:05:19 / cg"
!

unimplementedInstructionSignal
    ^ UnimplementedInstructionSignal

    "Created: / 2.1.1998 / 18:06:15 / cg"
!

unimplementedNativeMethodSignal
    ^ UnimplementedNativeMethodSignal

    "Created: / 02-01-1998 / 18:06:40 / cg"
    "Modified: / 15-01-2013 / 22:30:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'accessing'!

addSelector:newSelector withMethod:newMethod 
    super addSelector:newSelector withMethod:newMethod.
    
    "/JavaNativeMethod may not be loaded..."
    
    (Smalltalk at:#JavaNativeMethod) notNil ifTrue:[
        JavaNativeMethod flushAllCachedNativeMethods
    ].

    "Created: / 24-12-1999 / 03:12:05 / cg"
    "Modified: / 02-02-2011 / 23:38:08 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-08-2014 / 15:52:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assertionsEnabled: aBoolean

    AssertionsEnabled := aBoolean

    "
        JavaVM assertionsEnabled: true.
        JavaVM assertionsEnabled: false.
    "

    "Created: / 24-11-2010 / 09:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classRegistry
    ^ ClassRegistry.

    "Created: / 21-10-2011 / 11:12:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extClassLoader
    ^ self systemClassLoader instVarNamed:#'parent'.

    "Created: / 30-10-2011 / 12:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 02-11-2011 / 13:20:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

finalizationEnabled

    ^FinalizationEnabled

    "Created: / 14-11-2011 / 21:14:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

finalizationLobby

    ^FinalizationLobby

    "Created: / 14-11-2011 / 12:29:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaEventQueueThread
     ^ JavaEventQueueThread

    "Created: / 24.12.1999 / 02:34:35 / cg"
!

javaEventThread
     ^ JavaEventThread

    "Created: / 8.1.1999 / 17:05:02 / cg"
!

javaScreenUpdaterThread
     ^ JavaScreenUpdaterThread

    "Created: / 8.1.1999 / 17:06:52 / cg"
!

natives
    ^ NativeMethodsImplementation

    "Created: / 16-01-2013 / 20:02:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performance
    "Return an object keeping Java performance counters"
    ^ PerfCounters

    "Modified: / 14-08-2012 / 00:39:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reflection
    ^ Reflection

    "Created: / 28-01-2011 / 15:09:19 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 16-01-2013 / 20:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registry
    ^ ClassRegistry.

    "Modified (format): / 21-10-2011 / 11:12:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smalltalkClassLoader

    ^SmalltalkClassLoader

    "Created: / 22-08-2012 / 13:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemClassLoader

    ^SystemClassLoader

    "Created: / 30-10-2011 / 12:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useSmalltalkInterpreter

    JavaMethod makeMetaMethod

    "Created: / 23-02-2011 / 12:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useVMInterpreter

    JavaMethod makeJavaMethod

    "Created: / 23-02-2011 / 12:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'accessing-builtin classes'!

builtInClassNames
    "Returns an array with (binary) names of classes known by the runtime system.
     When a builtin class is loaded and registered in class registry,
     JavaClassRegistry is sent #registerBuiltIn:

     NOTE: If you add class here, you may want to update
     JavaClassRegistry>>registerBuiltIn:.
    "
    ^#(
        #'java/lang/Object'
        #'java/lang/String'
        #'java/lang/System'
        #'java/lang/Class'

        #'java/lang/reflect/Constructor'
        #'java/lang/reflect/Method'
        #'java/lang/reflect/Field'

    )

    "Created: / 22-05-2013 / 20:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'cache management'!

flushCachesFor: aClass
    "Flush all caches for given class, including JIT-compiled code.
     Called for allow for dynamic recompilation when a reference
     is resolved"

    aClass methodDictionary do:[:mthd|
        (mthd isJavaMethod and:[mthd isNative not and:[mthd isResolved not]]) ifTrue:[
            "Stdout nextPutAll:'Flushing code for ' , mthd printString; cr."
            mthd clearJittedCodeAndForceJittingAgain.
            "/ mthd code: nil; checked: false.
        ].
    ].
    ObjectMemory flushCachesFor: aClass.

    "Created: / 17-10-2012 / 20:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'class access'!

arrayClassFor: javaClass ifAbsentPut: block
    ^self reflection arrayClassFor: javaClass ifAbsentPut: block

    "Created: / 05-07-2012 / 23:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: aString

    ^ ClassRegistry classNamed: aString asSlashedJavaClassName.

    "Modified (comment): / 21-10-2011 / 12:14:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-02-2013 / 14:17:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: aString put: aJavaClass
    <resource: #obsolete>
    
    self error: 'Should not be used anymore'.
    ^ ClassRegistry registerClass: aJavaClass

    "Modified (comment): / 21-10-2011 / 12:14:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 11-08-2014 / 01:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classForName: className
    "load class from registry - load using classLoader from query or JavaClassReader if absent"


    ^ self classForName: className asSlashedJavaClassName
        definedBy: (JavaClassReader classLoaderQuerySignal query) "? SystemClassLoader."

    "Modified: / 02-11-2011 / 16:33:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-01-2013 / 16:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classForName: className definedBy: classLoader
    "load class from registry - load using given classLoader if not nil"

    | result binaryName |

"/    classLoader isNil ifTrue:[
"/        Logger log: 'JavaVM>>classForName: ''', className , ''' definedBy: nil' severity: #trace.
"/    ].

    binaryName := className asSlashedJavaClassName.
    result := self
                classForName: binaryName
                definedBy: classLoader
                ifAbsentPut: [
                    | class  classLoaderEnsured |
                    self assert: (binaryName includes: $.) not.
                        class := self loadClassNamed: binaryName usingClassLoader: classLoader.
                        class.
                ].

    result isNil ifTrue: [
        Logger
            log: 'Class ' , className , ' couldnt be loaded'
            severity: Logger severityDEBUG
            facility: 'JVM'
    ] ifFalse: [ result := self makeArrayOf: result asDescribedBy: className. ].
    ^ result.

    "Created: / 21-10-2011 / 12:01:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-11-2011 / 16:49:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:01:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classForName: className definedBy: classLoader ifAbsentPut: aBlock
    "load class from registry - if absent evaluate given block to get loaded class"

    | result |
    className asJavaComponentClassName isJavaPrimitiveTypeDescriptor ifTrue: [
        ^ (JavaDescriptor fromString: className) javaClass.
    ].
    result := ClassRegistry
                classForName: className asSlashedJavaClassName
                loader: classLoader
                ifAbsentPut: aBlock.
    result notNil ifTrue: [
        result := self makeArrayOf: result asDescribedBy: className.
    ].
    ^ result.

    "Created: / 21-10-2011 / 12:13:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-10-2011 / 22:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-11-2011 / 16:09:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

classNamed: className
    "Return class with given name loaded by current classloader or nil if class is not yet loaded"

    ^ self classNamed: className definedBy: JavaClassReader classLoaderQuerySignal query.

    "Modified: / 21-10-2011 / 12:09:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 21-10-2011 / 13:34:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 28-10-2011 / 22:12:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed: className definedBy: classLoader
    "Return class with given name loaded by given classloader or nil if class is not yet loaded"

    | result |
    className asJavaComponentClassName isJavaPrimitiveTypeDescriptor ifTrue: [
        ^ (JavaDescriptor fromString: className) javaClass.
    ].
    result := ClassRegistry
                classForName: className asSlashedJavaClassName
                loader: classLoader
                ifAbsent: [ ^ nil ].
    ^ self makeArrayOf: result asDescribedBy: className.

    "Created: / 21-10-2011 / 11:58:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-10-2011 / 12:01:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-11-2011 / 15:36:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

loadClassesIn: directory
    "Load all classes (.class files, strictly speaking) found in given directory or .jar file.

    Returns a set of loaded classes."

    ^ self loadClassesIn: directory matching: nil.

    "Created: / 21-10-2011 / 12:40:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-05-2014 / 12:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadClassesIn: directory matching: pattern
    "Load all classes (.class files, strictly speaking) found in given directory or .jar file.
     The arguments are a string containing the name of the directory or .jar file
     and a class name pattern. Only classes matching the pattern are loaded.
     class names are matched using String>>matches:.
     ALL CLASSES ARE INSTALLED!!
     Returns a set of loaded classes."

    | dir  dirString  className  loadedClasses |
    dir := directory asFilename asAbsoluteFilename.
    loadedClasses := Set new.
    Java addToClassPath: dir pathName.
    JavaClassReader classLoaderQuerySignal answer: SystemClassLoader do:[
        dir isDirectory ifTrue:[
            dir recursiveDirectoryContentsAsFilenamesDo: [
                :filename |
                (filename isRegularFile and: [ filename suffix = #class ]) ifTrue: [
                    dirString := dir pathName.
                    className := filename withoutSuffix pathName.
                    className := className subString: dirString size + 2 to: className size.
                    className := className replaceAll: (Filename separator) with: $..
                    (pattern isNil or:[className matches: pattern]) ifTrue: [
                        (self classNamed: className) isNil ifTrue:[
                            loadedClasses add: (self classForName:className).
                        ].
                    ]
                ]
            ].
        ] ifFalse:[
            | zar |

            zar := ZipArchive oldFileNamed: dir pathName.
            zar entries do:[:entry|
            (entry endsWith:'.class') ifTrue:[
                | nm |

                nm := entry copyTo: entry size - 6.
                className := nm replaceAll: (Filename separator) with: $..
                    (pattern isNil or:[className matches: pattern]) ifTrue: [
                        (self classNamed: className) isNil ifTrue:[
                            loadedClasses add: (self classForName:className).
                        ].
                    ]
                ]
            ]
        ].
    ].
    ^ loadedClasses.

    "Modified: / 21-10-2011 / 12:52:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-05-2014 / 12:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'class loading/unloading'!

loadClassNamed: className usingClassLoader: classLoader
    "Load class with given `className` using given `classLoader`. If
     `classLoader` is nil (i.e., primordial class loader), load
     the class ourselfs"

    | class |

    JavaClassReader classLoaderQuerySignal answer: classLoader do: [
        classLoader isNil ifTrue:[
            "/ Primordial load...
            class := JavaClassReader readClass: className classPath: Java release bootClassPath
        ] ifFalse:[
            class := classLoader
                    perform: #'loadClassInternal(Ljava/lang/String;)Ljava/lang/Class;'
                    with: (Java as_String: (className asDottedJavaClassName)).
            class := self classForJavaClassObject: class.
        ].
    ].
    ^ class.

    "Created: / 14-09-2013 / 23:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2013 / 00:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unloadClass: class
    "Remove given `class` from the system, i.e., remove it from
     the class registry as well as from system dictionary (Smalltalk).

     Note, that this method also removes all dependent classes and
     invalidates all references"

    ClassRegistry unregisterClass: class.

    "Created: / 14-09-2013 / 23:25:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'debugging support'!

disableMonitorTrace
    MonitorTrace := false.

    "Created: / 22-11-2011 / 10:29:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

enableMonitorTrace
    MonitorTrace := true.

    "Created: / 22-11-2011 / 10:29:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 07-04-2012 / 08:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionDebug
    ^ ExceptionDebug

    "Created: / 27.1.1999 / 20:14:51 / cg"
!

exceptionDebug:aBoolean
    ExceptionDebug := aBoolean

    "Created: / 27.1.1999 / 20:15:00 / cg"
!

exceptionDebugPatterns

    ^ ExceptionDebugPatterns
    "
    ExceptionDebug must be set in order to ExceptionDebugPatterns work

    ExceptionDebug := true.
    ExceptionDebug := false.
    ExceptionDebugPatterns removeAll.
    ExceptionDebugPatterns add: 'java/lang/SecurityException*'.
    ExceptionDebugPatterns add: 'java/net/ConnectException*'.
    ExceptionDebugPatterns add: 'java/lang/IllegalArgumentException'.
    ExceptionDebugPatterns add: 'java/lang/IllegalAccessException'.
    ExceptionDebugPatterns add: 'java/lang/ClassNotFoundException'.
    ExceptionDebugPatterns add: 'java/io/IOException'.
    ExceptionDebugPatterns add: 'java/io/FileNotFoundException'.
    ExceptionDebugPatterns add: 'java/io/EOFException'.
    ExceptionDebugPatterns add: 'java/lang/NoSuchMethodException'.
    ExceptionDebugPatterns add: 'java/lang/ArrayIndexOutOfBoundsException'.
    ExceptionDebugPatterns add: 'java/lang/IllegalMonitorStateException'.
    ExceptionDebugPatterns add: 'org/xml/sax/SAXParseException'.
    ExceptionDebugPatterns add: 'org/apache/xerces/xni/parser/XMLParseException'.
    ExceptionDebugPatterns add: 'java/lang/InstantiationException'.
    ExceptionDebugPatterns add: 'java/lang/RuntimeException'.
    ExceptionDebugPatterns add: 'java/lang/ClassCastException'.
    ExceptionDebugPatterns add: 'java/lang/IllegalAccess*'.
    ExceptionDebugPatterns add: 'java/util/zip/ZipException'.
    ExceptionDebugPatterns add: 'java/lang/UnsatisfiedLinkError'.
    ExceptionDebugPatterns add: 'java/lang/ThreadDeath'.




    ExceptionDebug := true.
    "

    "Created: / 25-02-2011 / 08:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-06-2014 / 11:36:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionTrace:aBoolean
    ExceptionTrace := aBoolean

!

monitorTrace
    ^ MonitorTrace

    "Created: / 11-10-2013 / 11:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'debugging-dumping'!

dumpOpenExternalStream: stream on: output
    output nextPutAll: stream class printString.
    output space.
    OpenFileTable notNil ifTrue:[
        | idx |
        idx := OpenFileTable identityIndexOf: stream.
        idx ~~ 0 ifTrue:[
            output nextPutAll:'JavaVM:OpenFileTable['; nextPutAll: idx printString; nextPut:$]; space.
        ]
    ].
    ZipCache notNil ifTrue:[
        | idx |
        idx := ZipCache identityIndexOf: stream.
        idx ~~ 0 ifTrue:[
            output nextPutAll:'JavaVM:ZipCache['; nextPutAll: idx printString; nextPut:$]; space.
        ]
    ].
    stream isFileStream ifTrue:[
        output nextPutAll: stream pathName ? '?'
    ]

    "Created: / 23-07-2012 / 16:40:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpOpenExternalStreams
    ^self dumpOpenExternalStreamsOn: Stdout.

    "Created: / 23-07-2012 / 16:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpOpenExternalStreamsOn: aStream

    | nOpenStreams |

    nOpenStreams := 0.
    ExternalStream allSubInstancesDo:[:each|
        each isOpen ifTrue:[
            nOpenStreams := nOpenStreams + 1.
            self dumpOpenExternalStream: each on: aStream.
            aStream cr.
        ]
    ].
    aStream nextPutLine:
        ('SUMMARY: open=%1, java.io=%2, java.util.zip=%3'
            bindWith: nOpenStreams
                with: ((OpenFileTable ? #()) inject:0 into:[:a :s|a + (s notNil ifTrue:[1] ifFalse:[0])])
                with: ((ZipCache ? #())      inject:0 into:[:a :s|a + (s notNil ifTrue:[1] ifFalse:[0])])
        )

    "
        JavaVM dumpOpenExternalStreamsOn: Stdout
    "

    "Created: / 23-07-2012 / 16:34:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'defaults'!

audioEnabled
    ^ NoAudio not

    "Created: / 18.7.1998 / 22:31:36 / cg"
!

audioEnabled:aBoolean
    NoAudio := aBoolean not

    "Created: / 18.7.1998 / 22:31:20 / cg"
!

defaultCLASSPATH
    |s|

    s := '' writeStream.
    Java effectiveClassPath
        do:[:p | s nextPutAll:p asString ]
        separatedBy: [s nextPut: OperatingSystem pathSeparator].

    ^ s contents

    "
     self defaultCLASSPATH
    "

    "Created: / 03-01-1998 / 14:27:21 / cg"
    "Modified: / 16-01-2013 / 13:15:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultExtDirs

    ^String streamContents:[:s|
        Java javaExtDirs do:[:dir|
            s nextPutAll: dir pathName.
        ] separatedBy:[
            s nextPut: OperatingSystem pathSeparator.
        ]
    ]

    "
    JavaVM defaultExtDirs
    "

    "Created: / 31-08-2011 / 20:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultHotJavaHome
    ^ '/usr/local/java/hotjava'.

    "Modified: / 5.8.1997 / 04:13:36 / cg"
    "Created: / 3.1.1998 / 14:27:34 / cg"
!

defaultJAVAHome
    ^ Java javaHome

    "Modified: / 6.8.1997 / 00:54:44 / cg"
    "Created: / 3.1.1998 / 14:27:01 / cg"
!

defaultJWSHome
    '/phys/idefix/home2/java/JWS2_0/Java-WorkShop2.0/JWS' asFilename exists ifTrue:[
	^ '/phys/idefix/home2/java/JWS2_0/Java-WorkShop2.0/JWS'
    ].

    ^ '/usr/local/java/JWS'.

    "Created: / 3.1.1998 / 14:27:42 / cg"
    "Modified: / 3.12.1998 / 14:54:08 / cg"
!

defaultJavaLibraryPath
    |javaHome jreHome dirs libDir jniLibDir|

    javaHome := Java release javaHome asFilename.
    jreHome := Java release jreHome.
    libDir := Java release libDirInJreHome.
    jniLibDir := Java release jniLibDirInJreHome.

    dirs := Set new.
    dirs
        add: javaHome / libDir;
        add: javaHome / libDir / 'amd64';
        add: javaHome / libDir / 'i386'.

    libDir ~= jniLibDir ifTrue:[
        dirs 
            add: javaHome / jniLibDir;
            add: javaHome / jniLibDir / 'amd64';
            add: javaHome / jniLibDir / 'i386'.
    ].
    jreHome notNil ifTrue:[
        dirs 
            add: jreHome / libDir ;
            add: jreHome / libDir / 'amd64'  ;
            add: jreHome / libDir / 'i386' ;
            add: jreHome / 'bin'.
        libDir ~= jniLibDir ifTrue:[
            dirs 
                add: jreHome / jniLibDir;
                add: jreHome / jniLibDir / 'amd64';
                add: jreHome / jniLibDir / 'i386'
        ].
    ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        dirs
            add: javaHome / 'bin'.
    ].
    dirs := (dirs select:[:d| d exists]) asOrderedCollection.

    ^String streamContents:
        [:path|
        dirs
            do:[:d|path nextPutAll:d pathName]
            separatedBy:[path nextPut: OperatingSystem pathSeparator]]

    "
     JavaVM defaultJavaLibraryPath
    "

    "Created: / 10-12-2010 / 14:09:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-04-2011 / 18:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSunBootLibraryPath

    |s|

    s := '' writeStream.
    Java release bootClassPath
        do:[:p | s nextPutAll:p asString]
        separatedBy: [s nextPut: OperatingSystem pathSeparator].

    ^ s contents

    "
        JavaVM defaultSunBootLibraryPath
    "

    "Created: / 10-12-2010 / 14:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2013 / 15:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultWindowingToolKit
    "/ prefer the windows toolkit ...

    (self classForName: 'sun.awt.windows.WToolkit') notNil ifTrue: [
        ^ 'sun.awt.windows.WToolkit'.
    ].
    (Java classForName: 'sun.awt.motif.MToolkit') notNil ifTrue: [
        self halt: 'MotifToolKit: this is untested code'.
        ^ 'sun.awt.motif.MToolkit'.
    ].
    self halt: 'TinyToolKit: this is untested code'.
    ^ 'sun.awt.tiny.TinyToolkit'.

    "/    ^ 'sun.awt.win32.MToolkit'.
    "/    ^ 'sun.awt.motif.MToolkit'.
    "
     self defaultWindowingToolKit"
    "Created: / 3.1.1998 / 14:27:49 / cg"
    "Modified: / 27.1.1998 / 21:52:52 / cg"
!

fileAccessTrace
    ^ FileAccessTrace

    "Created: / 27.1.1999 / 18:55:40 / cg"
!

fileAccessTrace:aBoolean
    FileAccessTrace := aBoolean

    "Created: / 19.10.1998 / 16:01:44 / cg"
    "Modified: / 27.1.1999 / 18:55:52 / cg"
!

fileOpenConfirmation
    ^ FileOpenConfirmation

    "Created: / 19.10.1998 / 16:01:44 / cg"
!

fileOpenConfirmation:aBoolean
    FileOpenConfirmation := aBoolean

    "Created: / 19.10.1998 / 16:01:56 / cg"
!

javaConsole:aStream
    JavaConsoleStream := aStream

    "
     JavaVM javaConsole:Transcript
    "

    "Modified: / 6.8.1997 / 00:34:13 / cg"
    "Created: / 3.1.1998 / 14:27:58 / cg"
!

javaConsoleStream
    ^ JavaConsoleStream

    "Created: / 3.1.1998 / 14:32:16 / cg"
!

nullPointerExceptionDebug
    ^ NullPointerExceptionDebug

    "Created: / 27.1.1999 / 20:14:51 / cg"
!

nullPointerExceptionDebug:aBoolean
    NullPointerExceptionDebug := aBoolean

    "Created: / 27.1.1999 / 20:15:00 / cg"
!

socketConnectConfirmation
    ^ SocketConnectConfirmation

    "Created: / 19.10.1998 / 16:02:15 / cg"
!

socketConnectConfirmation:aBoolean
    SocketConnectConfirmation := aBoolean

    "Created: / 19.10.1998 / 16:02:06 / cg"
! !

!JavaVM class methodsFor:'eager resolving'!

disableEagerResolving
    EagerResolvingEnabled := false.

    "Created: / 08-12-2011 / 21:06:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

eagerResolvingEnabled
    ^ EagerResolvingEnabled.

    "Created: / 08-12-2011 / 21:05:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

enableEagerResolving
     EagerResolvingEnabled := true.

    "Created: / 08-12-2011 / 21:06:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaVM class methodsFor:'helpers'!

canCast: s to: t
    "Helper for _CHECKCAST(_R):_:/_INSTANCEOF(_R):_:"

    | sc  tc |

    "Not specified in JVM spec, sigh"
    s isJavaPrimitiveType ifTrue: [
        "FIXME"
        ^ s == t or:[(s isSubclassOf: t) or:[t isSubclassOf: s]]
    ].
     "
     Java VM Spec, 3rd edition, p 280:

     The following rules are used to determine whether an objectref that is not
     null can be cast to the resolved type: if S is the class of the object
     referred to by objectref and T is the resolved class, array, or interface type,
     checkcast determines whether objectref can be cast to type T as follows:

     - If S is an ordinary (nonarray) class, then:
     - If T is a class type, then S must be the same class as T, or a subclass
     of T.
     - If T is an interface type, then S must implement interface T.
    "
    (s isJavaArrayClass not and: [ s isInterface not ]) ifTrue: [
        ^ (s includesBehavior: t).
    ].
     "
     - If S is an interface type, then:
     - If T is a class type, then T must be Object.
     - If T is an interface type, then T must be the same interface as S or a
     superinterface of S.
    "
    s isInterface ifTrue: [
        ^ t isInterface not
            ifTrue: [ t == (self classForName: 'java.lang.Object') ]
            ifFalse: [ s includesBehavior: t ]
    ].
     "
     - If S is a class representing the array type SC[], that is, an array of com-
     ponents of type SC , then:
    "
    self assert:s isJavaArrayClass message:'S should be array type'.
    sc := s javaComponentClass.
     "
     - If T is a class type, then T must be Object.
    "
    t isJavaClassType ifTrue: [ ^ t == (self classForName: 'java.lang.Object' definedBy: nil) ].
     "
     - If T is an array type TC[], that is, an array of components of type TC ,
     then one of the following must be true:
     - TC and SC are the same primitive type.
     - TC and SC are reference types, and type SC can be cast to TC by
     recursive application of these rules.
    "
    t isJavaArrayClass ifTrue: [
        tc := t javaComponentClass.
        ^ tc isJavaPrimitiveType
            ifTrue: [ tc == sc ]
            ifFalse: [ self canCast: sc to: tc ]
    ].
     "
     - If T is an interface type, T must be one of the interfaces implemented
     by arrays (JLS3 4.10.3).
    "
    ((t name == #'java/lang/Cloneable')
        or: [ t name == #'java/lang/Serializable' ]) ifTrue: [ ^ true ].
    ^ false

    "Modified: / 09-01-1999 / 00:45:21 / cg"
    "Created: / 11-02-2011 / 08:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-10-2011 / 13:50:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-05-2013 / 12:57:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaStringObjectForString:string
    self breakPoint:#mh info:'refactor my sender to use reflection directly'.
    ^ self reflection javaStringObjectForString:string interned:false

    "Created: / 22-11-2010 / 16:31:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 00:47:49 / Marcel Hlopko <hlopik@gmail.com>"
!

javaStringObjectForString:string interned:intern

    ^self reflection javaStringObjectForString:string interned:intern.

    "Created: / 22-11-2010 / 16:28:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2010 / 17:57:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:04:21 / Marcel Hlopko <hlopik@gmail.com>"
!

javaThreadForSTProcess: stProcess
    | result |
    result := Java threadForStProcess: stProcess ifAbsent: nil.
    result == 0 ifTrue: [ self breakPoint: #mh. ^ nil].
    ^ result.

    "Modified: / 26-08-1997 / 19:56:31 / cg"
    "Created: / 03-01-1998 / 01:53:41 / cg"
    "Modified: / 09-12-2011 / 13:12:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

makeArrayOf: loadedJavaClass asDescribedBy: className
    | arrayClass  dimensions |

    className first == $[ ifFalse:[ ^ loadedJavaClass ].

    arrayClass := loadedJavaClass.
    dimensions := className occurrencesOf: $[.
    arrayClass isJavaArrayClass ifTrue: [
        "is already array (primitive arrays case, like ByteArray etc)"
        dimensions := dimensions - 1.
    ].
    dimensions timesRepeat: [ arrayClass := arrayClass javaArrayClass. ].
        ^ arrayClass.

    "Created: / 21-10-2011 / 12:18:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-05-2014 / 12:40:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newThread: name
    | thread  threadClass  i |
    threadClass := JavaVM classForName: 'java.lang.Thread'.
    thread := threadClass basicNew.
    thread instVarNamed: '_lockWord_' put: 0.
    thread instVarNamed: 'name' put: name. "/NOT a Java string, name instvar is char[]!!!!!!"
    thread instVarNamed: 'priority'
        put: (threadClass instVarNamed: 'NORM_PRIORITY').
    thread instVarNamed: 'single_step' put: 0.
    thread instVarNamed: 'daemon' put: 0.
    thread instVarNamed: 'stillborn' put: 0.
    thread instVarNamed: 'threadStatus' put: 0.
    thread instVarNamed: 'target' put: nil.
    thread instVarNamed: 'blockerLock' put:
        ((JavaVM classForName: 'java.lang.Object') basicNew
            instVarAt: 1 put: 0;
            yourself).

    "/
    "/ that on was only temporarily present in JDK1.1.3 (sigh)
    "/

    (i := thread class instVarIndexFor: 'initial_stack_memory') notNil ifTrue: [
        thread instVarAt: i put: 0.
    ].
    thread instVarNamed: 'group' put: (self standardThreadGroup).
    threadClass classLoader isNil ifTrue: [
        thread instVarNamed: 'contextClassLoader' put: self systemClassLoader
    ] ifFalse: [
        thread instVarNamed: 'contextClassLoader' put: threadClass classLoader
    ].
    ^ thread

    "Created: / 03-01-1998 / 01:47:30 / cg"
    "Modified: / 27-01-1998 / 00:54:33 / cg"
    "Modified: / 01-12-2011 / 17:43:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-09-2012 / 16:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stProcessForJavaThread: jThread
    | result |
    result := Java threadsAt: jThread ifAbsent: nil.
    result == 0 ifTrue: [ self breakPoint: #mh. ^ nil ].
    ^ result.

    "Created: / 02-01-1998 / 21:48:27 / cg"
    "Modified: / 03-01-1998 / 01:53:55 / cg"
    "Modified: / 09-12-2011 / 13:12:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

standardThreadGroup
    | standardGroup  threadClass |

    StandardThreadGroup isNil ifTrue: [
        threadClass := JavaVM classForName: 'java.lang.Thread'.
        standardGroup := (self classForName: 'java.lang.ThreadGroup') new.
        standardGroup instVarNamed: 'parent' put: nil.
        standardGroup instVarNamed: 'name' put: (Java as_String: 'main').
        standardGroup instVarNamed: 'maxPriority'
            put: (threadClass instVarNamed: 'MAX_PRIORITY').
        standardGroup instVarNamed: 'destroyed' put: 0.
        standardGroup instVarNamed: 'daemon' put: 0.
        (standardGroup class instVarIndexFor: 'vmAllowSuspension') notNil ifTrue: [
            standardGroup instVarNamed: 'vmAllowSuspension' put: 0.
        ].
        standardGroup instVarNamed: 'nthreads' put: 0.
        standardGroup instVarNamed: 'ngroups' put: 0.
        standardGroup instVarNamed: 'groups' put: nil.
        StandardThreadGroup := standardGroup.
    ].
    ^ StandardThreadGroup

    "Created: / 03-01-1998 / 01:41:54 / cg"
    "Modified: / 17-11-1998 / 22:55:30 / cg"
    "Modified: / 07-10-2013 / 11:51:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'helpers - exceptions'!

throwArrayIndexOutOfBoundsException: badIndex
    | exClass  ex |

    exClass := self classForName: 'java.lang.ArrayIndexOutOfBoundsException'.
    ex := exClass newWith_int: badIndex.
    ^ self throwException: ex

    "Created: / 14.1.1998 / 21:36:05 / cg"
    "Modified: / 20.11.1998 / 13:27:14 / cg"
!

throwArrayIndexOutOfBoundsException: theArray _: badIndex
    | exClass  ex |

    exClass := self classForName: 'java.lang.ArrayIndexOutOfBoundsException'.
    ex := exClass newWith_int: badIndex.
    ^ self throwException: ex

    "Modified: / 20.11.1998 / 13:27:14 / cg"
    "Created: / 8.1.1999 / 15:03:59 / cg"
!

throwArrayStoreException:message
    ^ self
        throwExceptionClassName:'java.lang.ArrayStoreException'
        withMessage:message

    "Modified: / 02-06-2014 / 14:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwClassCastException


    ^ self throwExceptionClassName: 'java.lang.ClassCastException'
        withMessage: 'cast failed'

    "Modified: / 07-01-1998 / 15:25:35 / cg"
    "Created: / 08-01-1999 / 18:55:31 / cg"
    "Modified (format): / 23-10-2011 / 22:33:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwClassFormatError
    ^ self throwClassFormatError: 'Invalid class format'

    "Created: / 04-01-1998 / 22:26:09 / cg"
    "Modified: / 10-11-1998 / 13:20:31 / cg"
    "Created: / 08-08-2011 / 17:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwClassFormatError: message
    ^ self
        throwExceptionClassName:'java.lang.ClassFormatError'
        withMessage: message

    "Created: / 04-01-1998 / 22:26:09 / cg"
    "Modified: / 10-11-1998 / 13:20:31 / cg"
    "Created: / 27-10-2011 / 16:20:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwClassNotFoundException
    ^ self
	throwExceptionClassName:'java.lang.ClassNotFoundException'
	withMessage:'no such class'

    "Created: / 4.1.1998 / 22:25:26 / cg"
    "Modified: / 7.1.1998 / 15:25:35 / cg"
!

throwClassNotFoundException: className
    ^ self throwExceptionClassName: 'java.lang.ClassNotFoundException'
        withMessage: 'no such class: ' , className

    "Created: / 4.1.1998 / 22:26:09 / cg"
    "Modified: / 10.11.1998 / 13:20:31 / cg"
!

throwCloneNotSupportedException
    ^ self throwCloneNotSupportedException: 'clone() not supported (object does not implement java.lang.Cloneable)'

    "Created: / 08-11-2013 / 22:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwCloneNotSupportedException: message
    ^ self
        throwExceptionClassName:'java.lang.CloneNotSupportedException'
        withMessage: message

    "Created: / 08-11-2013 / 22:39:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwDataFormatException: message
    ^ self
        throwExceptionClassName:'java.util.zip.DataFormatException'
        withMessage: message

    "Created: / 16-08-2012 / 17:55:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwDivisionByZeroException
    DivisionByZeroExceptionDebug == true ifTrue:[
	self halt:'division by zero'.
    ].
    ^ self
	throwExceptionClassName:'java.lang.ArithmeticException'
	withMessage:'division by zero'

    "Created: / 8.1.1999 / 14:28:15 / cg"
!

throwException: aJavaException
    <resource: #skipInDebuggersWalkBack>
    | con  jMsg  msg  exClass  srchCon  handlerContext  handlerPC  method  pc  hPC handler |
    ExceptionTrace ifTrue: [
        | tmpMessage |
        tmpMessage := aJavaException instVarNamed: 'detailMessage'.
        tmpMessage isNil ifTrue: [ tmpMessage := '' ] ifFalse: [
            tmpMessage := Java as_ST_String: tmpMessage
        ].
        Logger
            log: 'JAVA: exception: ' , aJavaException class binaryName , ' ('
                    , tmpMessage , ')'
            severity: Logger severityDEBUG
            facility: 'JVM'
    ].
    ExceptionDebug ifTrue: [
        "/        self internalError:('JAVA: exception: ' , aJavaException class fullName).
        (ExceptionDebugPatterns isNilOrEmptyCollection
            or: [
                ExceptionDebugPatterns
                    anySatisfy: [:pattern | pattern match: aJavaException class binaryName ]
            ])
                ifTrue: [
                    ObjectMemory debugBreakPoint3.
                    self halt: ('JAVA: exceptionDebug: ' , aJavaException class binaryName )
                ]
    ].

    "/
    "/ search stack for a javaContext which handles that exception
    "/


    srchCon := thisContext.
    [ handlerContext isNil and: [ srchCon notNil ] ] whileTrue: [
        srchCon := srchCon findSpecialHandle:true raise:false.
        srchCon notNil ifTrue:[
            (srchCon isJavaContext) ifTrue: [
                method := srchCon method.
                method exceptionTable notNil ifTrue:[
                    self assert: srchCon isHandleContext.
                ].
                pc := srchCon pc.
                (hPC := method handlerFor: aJavaException at: pc) notNil ifTrue: [
                    handlerPC := hPC.
                    handlerContext := srchCon
                ].
            ] ifFalse:[
                srchCon isHandleContext ifTrue:[
                    handler := srchCon receiver
                        handlerForSignal: aJavaException class context: srchCon originator:thisContext sender.
                    handler notNil ifTrue:[
                        "We have found a Smalltalk handler for Java exception here"
                        handlerContext := srchCon.
                    ]
                ].
            ].
        ].
    ].
    handlerContext isNil ifTrue: [
        "/
        "/ no JavaHandler ... let smalltalk handle it
        "/
        exClass := aJavaException class.
        (exClass binaryName == #'java/lang/ThreadDeath') ifTrue: [
            JavaUnhandledThreadDeathError
                raiseWith: aJavaException
                errorString: msg
                in: thisContext sender.
            ^ self.
        ].
        msg := 'Java ' , exClass binaryName.
        jMsg := aJavaException instVarNamed: 'detailMessage'.
        jMsg notNil ifTrue: [ msg := msg , ': ' , (Java as_ST_String: jMsg). ].

        "/ for our convenience: skip ST contexts
        "/ (i.e. the handler or debugger will see the javaContext first )

        con := thisContext sender.
        [ con isNil or: [ con isJavaContext ] ] whileFalse: [ con := con sender ].
        con isNil ifTrue: [ con := thisContext sender ].
        JavaUnhandledExceptionError
            raiseWith: aJavaException
            errorString: msg
            in: con.
    ] ifFalse: [
        handlerContext isJavaContext ifTrue:[
            "/
            "/ found a Java exception handler
            "/
            handlerContext setPC: handlerPC.
            handlerContext exceptionArg: aJavaException pc: handlerPC.
            handlerContext markForException.
            handlerContext unwindAndRestartForJavaException.
            self halt: 'should not be reached'.
        ] ifFalse:[
            | val |
            "/
            "/ found a Smalltalk exception handler
            "/
            "/ First, call evaluate the handler (see GenericException>>doCallHandler:
            val := handler valueWithOptionalArgument: aJavaException.
            "handler fall through - is just like a #return:(aHandlerBlock value)"

            "Java exceptions cannot be proceed (by design)  but they might be
            rejected (rethrown) - this is not supported yet - we need
            to somehow indicate that (kind of reject token object returned
            from handler?)"
            thisContext evaluateUnwindActionsUpTo:handlerContext.
            handlerContext return: val.
        ].
    ].
    Processor activeProcess == JavaScreenUpdaterThread ifTrue: [ self halt ].
    Processor activeProcess == JavaEventQueueThread ifTrue: [ self halt ].
    Processor activeProcess terminate.

    "
     ExceptionTrace := true"

    "Created: / 07-01-1998 / 15:28:22 / cg"
    "Modified: / 24-12-1999 / 02:33:25 / cg"
    "Modified: / 01-12-2011 / 18:32:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 13:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwExceptionClassName: aJavaExceptionClassName withMessage: someMessage
    | exClass  ex |

    exClass := self classForName: aJavaExceptionClassName asSlashedJavaClassName definedBy: nil.
    ex := exClass newWith_String: someMessage.
    ^ self throwException: ex

    "Created: / 07-01-1998 / 15:25:09 / cg"
    "Modified: / 14-01-1998 / 23:38:30 / cg"
    "Modified: / 30-10-2011 / 17:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2011 / 16:54:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwExceptionClassName: aJavaExceptionClassName withMessage: someMessage cause: cause
    | exClass  ex |

    exClass := self classForName: aJavaExceptionClassName asSlashedJavaClassName definedBy: nil.
    ex := exClass newWith_String: someMessage.
    ex instVarNamed: #cause put: cause.
    ^ self throwException: ex

    "Created: / 05-07-2012 / 09:01:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwExceptionForFinallyIn: context
    "Evaluates a single finally block by fake-throwing
     FinallyToken - only evaluates a finally handler in
     given method, senders are not searched"

    |method pc handlerPC token returnContext |

    self assert: context isJavaContext.

    method := context method.
    pc := context pc.
    returnContext := thisContext sender sender sender.

    (returnContext receiver class == JavaContext finallyTokenClass and:[returnContext selector == #pass ]) ifTrue:[
        token := returnContext receiver
    ] ifFalse:[
    token := JavaContext finallyTokenClass new.
        returnContext selector == #return: ifTrue:[
            token
                context: (returnContext at: 2); "/ context which should return, see GenericException>>return:
                selector: #return:;
                exception: returnContext receiver;
                value: (returnContext argAt:1).
        ] ifFalse:[
            returnContext selector == #return ifTrue:[
                token
                    context: (returnContext at: 1); "/ context which should return, see GenericException>>return
                    selector: #return;
                    exception: returnContext receiver;
                    value: (returnContext at: 2).  "/ value which should be returned, see GenericException>>return
            ] ifFalse:[
                self error:'Unhandled case, inform libjava developers (JV in particular)' .
            ].
        ].
    ].

    handlerPC := method handlerFor: nil at: pc.
    handlerPC isNil ifTrue:[ ^ self ].

    context setPC: handlerPC.
    context exceptionArg: token pc: handlerPC.
    context markForException.
    context restart.

    self halt: 'should not be reached'.

    "Created: / 03-04-2012 / 16:56:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2013 / 10:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwExceptionInInitializerError:className
    ^ self
        throwExceptionClassName:'java.lang.ExceptionInInitializerError'
        withMessage:'error when initializing class: ' , className

    "Created: / 24-11-2010 / 09:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwFileNotFoundException: message
    ^ self
        throwExceptionClassName:'java.io.FileNotFoundException'
        withMessage: message

    "Created: / 04-01-1998 / 22:26:09 / cg"
    "Modified: / 10-11-1998 / 13:20:31 / cg"
    "Created: / 10-08-2011 / 14:19:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwIOExceptionWithMessage:message
    IOExceptionDebug == true ifTrue:[
	self halt:'IO Exception'.
    ].
    ^ self
	throwExceptionClassName:'java.io.IOException'
	withMessage:message

    "Created: / 7.1.1998 / 10:34:24 / cg"
    "Modified: / 7.1.1998 / 15:26:25 / cg"
!

throwIllegalAccessError
    ^ self throwExceptionClassName: 'java.lang.IllegalAccessError'
        withMessage: 'illegal access'

    "Created: / 13-04-2011 / 23:07:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIllegalAccessException
    ^ self
	throwExceptionClassName:'java.lang.IllegalAccessException'
	withMessage:'illegal access'

    "Modified: / 7.1.1998 / 15:25:35 / cg"
    "Created: / 14.1.1998 / 23:13:44 / cg"
!

throwIllegalArgumentException: message
    ^ self
        throwExceptionClassName:'java.lang.IllegalArgumentException'
        withMessage: 'illegal argument: ', message

    "Modified: / 07-01-1998 / 15:25:35 / cg"
    "Created: / 14-01-1998 / 23:13:44 / cg"
    "Created: / 07-09-2011 / 14:18:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwIllegalMonitorStateException: message
    self throwExceptionClassName: 'java.lang.IllegalMonitorStateException'
            withMessage: message.

    "Created: / 29-11-2011 / 14:21:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwIncompatibleClassChangeError
        ^ self throwExceptionClassName: 'java.lang.IncompatibleClassChangeError'
                withMessage: 'illegal change'.

    "Created: / 11-04-2011 / 20:03:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwInstantiationException
    ^ self
	throwExceptionClassName:'java.lang.InstantiationException'
	withMessage:'cannot instantiate'

    "Modified: / 7.1.1998 / 15:25:35 / cg"
    "Created: / 14.1.1998 / 23:15:01 / cg"
!

throwInstantiationExceptionFor:aJavaClass
    ^ self
        throwExceptionClassName:'java.lang.InstantiationException'
        withMessage:('cannot instantiate: ' , aJavaClass javaName)

    "Modified: / 7.1.1998 / 15:25:35 / cg"
    "Created: / 14.1.1998 / 23:17:02 / cg"
!

throwInterruptedException: message
    ^ self throwExceptionClassName: 'java.lang.InterruptedException'
        withMessage:message

    "Created: / 30-11-2011 / 12:23:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwInterruptedIOException: message
    ^ self throwExceptionClassName: 'java.io.InterruptedIOException' withMessage:message

    "Created: / 15-08-2013 / 21:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwInvocationTargetException: message target: target
    | exClass  ex |

    exClass := self classForName: #'java/lang/reflect/InvocationTargetException' definedBy: nil.
    ex := exClass newWith_String: message.
    ex instVarNamed: #target put: target.
    ^ self throwException: ex

    "Created: / 05-07-2012 / 17:48:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwLinkageError: message
    ^ self
        throwExceptionClassName:'java.lang.LinkageError'
        withMessage: message

    "Modified: / 10-11-1998 / 13:20:31 / cg"
    "Created: / 26-11-2010 / 11:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNegativeArraySizeException: size
    ^ self
        throwExceptionClassName: 'java.lang.NegativeArraySizeException'
        withMessage: 'negative array size: ' , size printString

    "Created: / 13-05-2012 / 14:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchFieldException
  ^ self throwExceptionClassName: 'java.lang.NoSuchFieldError'
        withMessage: 'looking up a field failed'.

    "Created: / 13-04-2011 / 12:16:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNullPointerException
    self throwNullPointerException:'null pointer'

    "Created: / 09-01-1998 / 02:26:08 / cg"
    "Modified: / 28-01-1998 / 02:30:09 / cg"
    "Modified: / 15-04-2013 / 21:18:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNullPointerException:message
    NullPointerExceptionDebug == true ifTrue: [
        self halt: 'Null Pointer exception'.
    ].
    ^ self throwExceptionClassName: 'java.lang.NullPointerException'
        withMessage: message

    "Created: / 09-01-1998 / 02:26:08 / cg"
    "Modified: / 28-01-1998 / 02:30:09 / cg"
    "Modified: / 13-08-2011 / 01:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 09-12-2011 / 11:13:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwNumberFormatException
    ^ self
	throwExceptionClassName:'java.lang.NumberFormatException'
	withMessage:'bad number format'

    "Modified: / 7.1.1998 / 15:25:35 / cg"
    "Created: / 11.1.1998 / 16:08:22 / cg"
!

throwOutOfMemoryError
    ^ self
        throwExceptionClassName:'java.lang.OutOfMemoryError'
        withMessage:'Oops, out of memory!!'

    "Created: / 04-01-1998 / 22:26:09 / cg"
    "Modified: / 10-11-1998 / 13:20:31 / cg"
    "Created: / 30-08-2011 / 09:23:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwSecurityException
    JavaClassReader classLoaderQuerySignal
        answer:  nil
        do: [
            ^ self throwExceptionClassName: 'java.lang.SecurityException'
                withMessage: 'trying to load class from java.lang using different class loader?'
        ].

    "Created: / 01-11-2011 / 15:55:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwSecurityExceptionWith: message
    JavaClassReader classLoaderQuerySignal answer: nil
        do: [
            ^ self throwExceptionClassName: 'java.lang.SecurityException'
                withMessage: 'trying to load class from java.lang: ' , message.
        ].

    "Created: / 01-11-2011 / 16:28:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throwSocketException: message
    JavaClassReader classLoaderQuerySignal answer: nil
        do: [
            ^ self throwExceptionClassName: 'java.net.SocketException'
                withMessage: message
        ].

    "Created: / 01-11-2011 / 16:28:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 03-11-2011 / 23:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwZipException
    ^ self throwZipException:'error in opening zip file'.

    "Created: / 27-03-2011 / 16:25:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-07-2012 / 19:15:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwZipException: message
    ^ self throwExceptionClassName: 'java.util.zip.ZipException'
           withMessage: 'error in opening zip file'.

    "Created: / 20-07-2012 / 19:15:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'helpers - exceptions - trampolines'!

throwNoSuchMethodError
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 11-04-2011 / 20:33:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-03-2016 / 09:58:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 21-03-2016 / 01:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-03-2016 / 09:58:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

throwNoSuchMethodError: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13 _: a14 _: a15
      ^ JavaVM throwExceptionClassName: 'java.lang.NoSuchMethodError' withMessage: 'method not found'

    "Created: / 23-03-2016 / 09:36:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'helpers - io'!

commonOpenStreamUsing: aBlock
    "Helper for opening a stream. Catches 'too many files' open error
     and tries to GC to cleanup if necessary"

    | stream retry |

    retry := false.
    [ stream := aBlock value ] on:OpenError do:[:ex|
        (ex errorCode) == (OperatingSystem errorNumberFor:#EMFILE) ifTrue:[
            "Worst case, try to cleanup"
            Logger log: 'maximum number of open files reached, forcing finalization...' severity: Logger severityWARN facility: #JVM.
            [
                FinalizationLobby finalizeNow.
                Delay waitForSeconds: 5. "/Give Java finalization thread a chance to clean up
                ObjectMemory garbageCollect.
                retry := true.
                JavaVM performance printOpenExternalStreamsOn: Stderr.
            ] on: Error do:[:ex|
                Logger log: 'failed to force finalization: ', ex description severity: #error facility: #JVM
            ].
        ] ifFalse:[
            ex pass.
        ].
    ].
    retry ifTrue:[
        stream := aBlock value.
        Logger log: 'good, forced finalization solved the problem' severity: #info facility: #JVM
    ].
    ^stream

    "Created: / 23-07-2012 / 19:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2012 / 02:25:06 / jv"
    "Modified: / 02-03-2015 / 14:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'helpers - reflection'!

classForJavaClassObject:aJavaClassObject
    "given java.lang.class instance, return the real class for it."

    ^ self reflection classForJavaClassObject:aJavaClassObject

    "Created: / 23-01-1998 / 17:44:09 / cg"
    "Modified: / 03-02-2011 / 21:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:02:17 / Marcel Hlopko <hlopik@gmail.com>"
!

javaClassObjectForClass: aClass
    "given a real class, return the corresponding java.lang.class
     instance for it."

"/    | class |
"/
"/    "find reflection of StClass in the Java World"
"/    (JavaObjectDictionary new hasReflection: aClass name) ifTrue: [
"/        class := JavaObjectDictionary new reflectionOf: aClass name
"/    ] ifFalse: [ class := aClass. ].
    ^ self reflection javaClassObjectForClass: aClass.

    "Created: / 23-01-1998 / 17:43:38 / cg"
    "Modified: / 05-12-1998 / 15:29:32 / cg"
    "Modified: / 17-01-2011 / 19:24:22 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 14:31:25 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 31-07-2012 / 00:49:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaFieldObjectForField:aJavaField in:aJavaLangClass 
    "given a java field, return the corresponding java.lang.Field
     instance for it."
    "
        See OpenJDK7 source:
        jdk7/hotspot/src/share/vm/runtime/reflection.cpp,
        oop Reflection::new_field"
    
    | field  clazz  nm  slot  type  modifiers |

    clazz := aJavaLangClass.
    nm := self reflection javaStringObjectForString:aJavaField name
            interned:true.
    slot := aJavaField index.
    type := self javaClassObjectForClass:aJavaField typeClass.
    modifiers := aJavaField accessFlags.
    field := (self classForName:'java.lang.reflect.Field') new.
    field
        instVarNamed:#clazz put:clazz;
        instVarNamed:#name put:nm;
        instVarNamed:#slot put:slot;
        instVarNamed:#type put:type;
        instVarNamed:#modifiers put:modifiers;
        yourself.
    aJavaField annotations notNil ifTrue:[
        field instVarNamed:#annotations
            put:aJavaField annotations runtimeVisible rawAnnotations
    ].
    ^ field.

    "Modified: / 05-12-1998 / 15:29:32 / cg"
    "Created: / 22-11-2010 / 17:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:06:20 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 01-04-2011 / 12:11:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 25-04-2011 / 20:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodForJavaConstructorObject:constructor
    "given a java.lang.reflect.Constructor, return the corresponding method
     it."
    self breakPoint:#mh info: 'refactor my sender to call reflection directly'.
    ^ self reflection methodForJavaConstructorObject: constructor.

    "Modified: / 09-02-2011 / 00:59:43 / Marcel Hlopko <hlopik@gmail.com>"
!

methodForJavaMethodObject:aJavaMethodObject
    "
        Given an instance of java.lang.reflect.Method, answers
        real method associated with it."
   ^ self reflection methodForJavaMethodObject:aJavaMethodObject.

    "Modified: / 07-02-2011 / 09:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2011 / 16:58:05 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaVM class methodsFor:'monitors'!

getJavaMonitorFor:someObject
    | mon |

    "/    JV@2012-04-13: Removed the critical section - this method should be called
    "/                   only when interrupts are blocked
    "/    LockTableAccess
    "/        critical: [
    mon := LockTable at:someObject ifAbsent:nil.
    mon isNil ifTrue:[
        LockTable at:someObject put:(mon := JavaMonitor for:someObject)
    ].

"/        ].

    ^ mon

    "Created: / 02-01-1998 / 19:01:52 / cg"
    "Modified: / 30-11-2011 / 20:40:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-04-2012 / 00:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseMonitorsOfUnwindingContext: aJavaContext
    "Forcibly releases all monitors acquired by given context.
     Use by unwind handlers"

    | thisProcess  wasBlocked receiver lockWord |
    MonitorTrace ifTrue:[
        Logger
            log: ('UNWIND HANDLER: force-leaving ',aJavaContext acquiredMonitors size printString,'monitors acquired by: ' , aJavaContext printString )
            severity: Logger severityDEBUG
            facility: #JVM.
    ].
    thisProcess := Processor activeProcess.

    wasBlocked := OperatingSystem blockInterrupts.
    "/self assert: aJavaContext method isSynchronized.
    receiver := aJavaContext receiver.
    receiver notNil ifTrue:[
        lockWord := receiver getJavaLockWord.
    ] ifFalse:[
        lockWord := 0.
    ].
%{
    if (lockWord != __MKINT(0)) {
      __monitorExit(receiver);
    }
%}.
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    MonitorTrace ifTrue:[
        Logger
            log: ('UNWIND HANDLER: leftover monitors left for ' , aJavaContext printString )
            severity: #info
            facility: #JVM.
    ].

    "Created: / 05-04-2012 / 11:35:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 13:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sleepForTimeout: tmo state: state
    "wait"

    | thisProcess |

    thisProcess := Processor activeProcess.
    thisProcess isInterrupted ifTrue: [
        thisProcess clearInterrupted.
        self throwInterruptedException: 'process was interrupted before/during sleep !!?'
    ].
    thisProcess state: state.
    (Delay forMilliseconds: tmo) waitWithState: state.
    thisProcess isInterrupted ifTrue: [
        thisProcess clearInterrupted.
        self throwInterruptedException: 'process was interrupted before/during sleep !!?'
    ].

    "Created: / 30-12-1998 / 19:19:35 / cg"
    "Modified: / 08-01-1999 / 17:29:24 / cg"
    "Created: / 30-11-2011 / 11:04:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 26-08-2012 / 18:40:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'monitors-internal'!

inflateLockFor: obj lockword: lw
     | threadId count mon |
%{
    threadId = __MKINT( stxLockwordGetPid((unsigned INT)lw) );
    count =    __MKINT( stxLockwordGetCnt((unsigned INT)lw) );
%}.
    ^ JavaMonitor for: obj thread: threadId nestedLockCount: count.

    "Modified (format): / 27-08-2012 / 15:34:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unwindHandlerForJavaContext: aJavaContext
    "given a context which has been marked for unwind,
     retrieve the handler block. This method is called when ST
     exception raises and stack is unwinding. JavaClass instance
     has an opportunity to clean up monitors"

    ^ [
        aJavaContext shouldExecuteFinallyOnUnwind ifTrue:[
            self throwExceptionForFinallyIn: aJavaContext
        ].
        self releaseMonitorsOfUnwindingContext: aJavaContext.
    ].

    "Created: / 08-11-2011 / 12:30:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-11-2011 / 21:33:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 10-04-2012 / 11:08:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 16-08-2017 / 22:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'native - java.lang'!

_java_lang_Object_clone: this
    "Forward here as optimized code delegates to  JavaVM"

    ^ NativeMethodsImplementation _java_lang_Object_clone: this

    "Created: / 12-11-2013 / 01:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_arraycopy: nativeContext
    <resource: #obsolete>
    "Forward here as optimized code delegates to  JavaVM"

    ^ NativeMethodsImplementation _java_lang_System_arraycopy: nativeContext receiver _:(nativeContext argAt:1) _: (nativeContext argAt:2) _: (nativeContext argAt:3) _: (nativeContext argAt:4) _: (nativeContext argAt:5)

    "Modified: / 21-01-2013 / 09:18:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_System_arraycopy: this _:a1 _: a2 _: a3 _: a4 _: a5
    "Forward here as optimized code delegates to JavaVM"

    ^ NativeMethodsImplementation _java_lang_System_arraycopy: this _:a1 _: a2 _: a3 _: a4 _: a5

    "Created: / 12-11-2013 / 01:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'queries'!

booted

    | jVM |

    "/Slightly faster variant of the code below
    ^SystemClassLoader notNil and:[
        jVM := JavaVM classNamed: 'sun.misc.VM' definedBy: nil.
        jVM notNil and: [ (jVM instVarNamed: #booted) == 1 ]
    ].

"/    jVM := JavaVM classNamed: 'sun.misc.VM'.
"/    ^ jVM notNil and: [ (jVM instVarNamed: #booted) == 1 ] and: [self systemClassLoader notNil].

    "
     JavaVM booted"

    "Created: / 08-08-2011 / 10:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2011 / 22:08:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-05-2013 / 01:22:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'threads'!

clearInterrupted: process
    ThreadInterrupts removeKey: process ifAbsent: []

    "Created: / 16-08-2012 / 22:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInterrupted: process
    ^ThreadInterrupts at: process ifAbsent:[false].

    "Created: / 16-08-2012 / 22:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

park: process timeout: tout
    "A helper for sun.misc.Unsafe.park()"

    | blocked sema |

    blocked := OperatingSystem blockInterrupts.
    ParkUnparkSemaphores isNil ifTrue:[ ParkUnparkSemaphores := Dictionary new ].
    sema := ParkUnparkSemaphores at: process ifAbsentPut:[Semaphore new].
    blocked ifFalse:[ OperatingSystem unblockInterrupts ].

    Logger log: 'parking thread ', process printString severity: Logger severityDEBUG facility: #JVM.
    sema parkWithTimeoutMs: tout.
    Logger log: 'parked thread ', process printString , ' resumed' severity: Logger severityDEBUG facility: #JVM.

    "Created: / 16-08-2012 / 21:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 13:58:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInterrupted: process
    ThreadInterrupts at: process put: true

    "Created: / 16-08-2012 / 22:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

terminateAllThreads
    Java terminateAllThreads.
    JavaEventThread := nil.
    JavaScreenUpdaterThread := JavaEventQueueThread := nil.

    "Created: / 8.1.1998 / 17:43:54 / cg"
    "Modified: / 24.12.1999 / 02:33:16 / cg"
!

threadStart: nativeContext
    "start the thread"

    | jThread  jName  nm  stProcess  helper |
    jThread := nativeContext receiver.
    self assert: (jThread instVarNamed: 'priority') > 0.
    stProcess := JavaProcess for: (helper := JavaProcess newHelper)
                priority: (Processor activePriority).
    helper javaThreadObject: jThread.
    helper javaProcess: stProcess.
    jName := jThread instVarNamed: 'name'.
    jName isString ifFalse: [ nm := Java as_ST_String: jName. ] ifTrue: [
        nm := jName
    ].

    "/ kludge - remember the ScreenUpdater ...

    nm = 'Screen Updater' ifTrue: [ JavaScreenUpdaterThread := stProcess. ] ifFalse: [
        nm = 'AWT-Windows' ifTrue: [ JavaEventThread := stProcess. ] ifFalse: [
            (nm startsWith: 'AWT-EventQueue') ifTrue: [
                JavaEventQueueThread := stProcess.
            ].
        ]
    ].

    "/ when that process terminates, wakup any waiters
    "/mh 29.11.11 this makes join work
    "/mh 30.11.11 disable wait is to ensure that join can be called on thread after its finished and dont wait forever"

    stProcess
        addExitAction: [
            | jThreadMonitor |
            MonitorTrace ifTrue:[
                Logger
                    log: ('%1 is going to die, notifying all waiters and disabling waiting on its monitor'
                            bindWith: jThread printString)
                    severity: Logger severityDEBUG
                    facility: #JVM.
            ].
            jThread instVarNamed: 'threadStatus' put: 0.
            jThreadMonitor := jThread getJavaMonitor.
            jThreadMonitor disableWait.
            [ 
                jThreadMonitor 
                    acquire; 
                    notify: true. "/ notifyAll()
            ] ensure:[ 
                jThreadMonitor release.
            ].
            ThreadInterrupts notNil ifTrue:[
                ThreadInterrupts removeKey: stProcess ifAbsent:[]
            ].
        ].
    stProcess name: 'JAVA-' , nm.
    stProcess restartable: true.
    jThread instVarNamed: 'threadStatus' put: 1.
    Java addThread: jThread for: stProcess.
    stProcess resume.
    ^ nil

    "Modified: / 24-12-1999 / 03:14:33 / cg"
    "Created: / 14-12-2010 / 21:31:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2011 / 12:58:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 23:38:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unpark: process
    "A helper for sun.misc.Unsafe.unpark()"

    | blocked sema |

    blocked := OperatingSystem blockInterrupts.
    ParkUnparkSemaphores isNil ifTrue:[ ParkUnparkSemaphores := Dictionary new ].
    sema := ParkUnparkSemaphores at: process ifAbsentPut:[Semaphore new].
    blocked ifFalse:[ OperatingSystem unblockInterrupts ].

    Logger log: 'unparking thread ', process printString severity: Logger severityDEBUG facility: #JVM.
    sema signal.

    "Created: / 16-08-2012 / 21:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2015 / 13:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'vm support'!

_AALOAD: arr _: idx
    "Called from the VM (___aaload()) for unhandled cases"

    (idx between: 0 and: arr size - 1) ifFalse:[ 
        ^ JavaVM throwArrayIndexOutOfBoundsException: arr _: idx. 
    ].
    arr basicAt: idx + 1

    "Created: / 29-04-2013 / 21:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 09:59:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_AASTORE: arr _: val _: index
    "Called from the VM (___aastore()) for unhandled cases"

     (val notNil and:[arr isJavaArray])"false" ifTrue:[
        (self canCast: val class to: arr class javaComponentClass) ifFalse: [
            self throwArrayStoreException: ('Incompatible types: try to store %1 in %2' bindWith: val class javaName with: arr class javaName).
            ^ nil "Not reached"
        ].
    ].
    arr basicAt: index + 1 put: val

    "Created: / 29-04-2013 / 21:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2014 / 14:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_ANEWARRAY:cls _:size
    "Returns a new array of elements of type class."

    self assert: cls isBehavior.
    size <  0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    self assert:cls javaArrayClass isJavaArrayClass.
    ^ cls javaArrayClass new:size

    "Created: / 17-12-2010 / 14:28:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2011 / 09:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_ANEWARRAY_R:classRef _:size
    "Returns a new array of elements of type referenced by classRef.
     Sent from jitted code when classRef is not resolved during jit-compilation"

    ^ self _ANEWARRAY: classRef resolve _: size

    "Created: / 16-01-2014 / 22:26:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_ARRAYLENGTH:arr
    arr isNil ifTrue:[
        "/self halt:'should not happen'.
        self throwNullPointerException.
    ].
    ^ arr size

    "Created: / 08-01-1999 / 14:38:27 / cg"
    "Modified: / 31-05-2011 / 10:09:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_ATHROW:aJavaException

    <resource: #skipInDebuggersWalkBack>

    | message |

    aJavaException isNil ifTrue:[
        self halt:'cannot happen'
    ].
    "When an exception is handled in Smalltalk code and the stack is
     being unwound, then all intermediate Java finally blocks are executed.
     This is done by fake-throwing special FinallyToken, as there must be an
     exception instance for Java. A Java compiler compiles unconditional
     ATHROW at the end of finally block to pass execution to another handler.
     We don't want to do so, in case we're manually invoking finally blocks.
     Hence following hack: we teleport back to handler caller"
    aJavaException class == JavaContext finallyTokenClass ifTrue:[
        | sender |

        "/ First, if the method is synchronized, leave its monitor
        sender := thisContext sender.
        sender method isSynchronized ifTrue:[
            self releaseMonitorsOfUnwindingContext: thisContext sender.
        ].
        "/ Proceed to unwind or exception handler.
        aJavaException pass.
        self halt:'Should never be reached'.
    ].
    "Another kludge: ECJ compiler throws java.lang.Error in case
     there's an unresolved compilation problem. We want to open debugger
     in this case tp be more Smalltalk-like - so translate such exception
     to JavaUnresolvedCompilationError"
    aJavaException class binaryName == #'stx/libjava/tools/compiler/CompileError' ifTrue:[
        message := aJavaException getMessage.
        (message startsWith: 'Unresolved compilation problem:') ifTrue:[
            JavaUnresolvedCompilationError newException
                messageText: (message copyFrom: 'Unresolved compilation problem:' size + 1) trimSeparators;
                proceedable: true;
                raiseSignal.
            ^thisContext sender return
        ]
    ].

    self throwException:aJavaException

    "Created: / 08-01-1999 / 14:15:36 / cg"
    "Modified: / 08-11-2011 / 16:32:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-10-2013 / 12:53:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_CHECKCAST: obj _: cls
    "A principal implementation of CHECKCAST instruction. Called by the bytecode
     interpreter for unhandled cases."

    obj isNil ifTrue:[ ^ obj ].
    (self canCast: obj class to: cls) ifFalse: [
        self throwClassCastException.
        ^ nil
    ].
    ^ obj

!

_CHECKCAST_R: object _: classRef
    "An implementation of CHECKCAST instruction. Called by the jitted code
     when if the classRef hasn't been resolved at the time of jitting."
    | class |

    object isNil ifTrue: [ ^ object ].
    class := classRef resolve.
    (self canCast: object class to: class) ifFalse:[
        self throwClassCastException.
        ^nil.
    ].
    ^object.

    "Created: / 19-05-2011 / 10:12:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 09-10-2012 / 11:56:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_D2I:op1
    |v|

    v := op1 asInteger.
    v > 16r7FFFFFFF ifTrue:[
	self halt.
	v := 16r7FFFFFFF
    ] ifFalse:[
	v < 16r80000000 negated ifTrue:[
	    self halt.
	    v := 16r80000000 negated
	]
    ].
    ^ v

    "Modified: / 17.10.1998 / 21:55:49 / cg"
    "Created: / 8.1.1999 / 14:47:13 / cg"
!

_D2L:op1
    |v|

    v := op1 asInteger.
    v > 16r7FFFFFFFFFFFFFFF ifTrue:[
	self halt.
	v := 16r7FFFFFFFFFFFFFFF
    ] ifFalse:[
	v < 16r8000000000000000 negated ifTrue:[
	    self halt.
	    v := 16r8000000000000000 negated
	]
    ].
    ^ v

    "Modified: / 17.10.1998 / 21:55:49 / cg"
    "Created: / 8.1.1999 / 14:46:44 / cg"
!

_DADD:op1 _:op2
    ^ op1 asFloat + op2 asFloat

    "Created: / 8.1.1999 / 15:11:59 / cg"
!

_DDIV:op1 _:op2
    ^ op1 asFloat uncheckedDivide: op2 asFloat.

    "Created: / 08-01-1999 / 15:09:10 / cg"
    "Modified: / 06-09-2011 / 19:31:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_DMUL:op1 _:op2
    ^ op1 asFloat * op2 asFloat

    "Created: / 8.1.1999 / 14:49:52 / cg"
!

_DNEG:op
    ^ op asFloat negated

    "Created: / 8.1.1999 / 15:06:15 / cg"
!

_DSUB:op1 _:op2
    ^ op1 asFloat - op2 asFloat

    "Created: / 8.1.1999 / 15:10:59 / cg"
!

_F2I:op1
    ^ self _D2I:op1

    "Created: / 8.1.1999 / 14:47:42 / cg"
!

_F2L:op1
    ^ self _D2L:op1

    "Created: / 8.1.1999 / 14:47:53 / cg"
!

_FADD:op1 _:op2
    ^ op1 asShortFloat + op2 asShortFloat

    "Created: / 8.1.1999 / 15:11:36 / cg"
!

_FDIV:op1 _:op2

    op1 isZero ifTrue:[
        op2 isZero ifTrue:[ ^ Float NaN ]
    ].
    op2 isZero ifTrue:[
        ^ Float infinity
    ].
    ^ op1 asShortFloat / op2 asShortFloat.

    "Created: / 08-01-1999 / 15:09:32 / cg"
    "Modified: / 06-07-2012 / 13:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_FMUL:op1 _:op2
    ^ op1 asShortFloat * op2 asShortFloat

    "Created: / 8.1.1999 / 14:50:10 / cg"
!

_FNEG:op
    ^ op asShortFloat negated

    "Created: / 8.1.1999 / 15:06:33 / cg"
!

_FSUB:op1 _:op2
    ^ op1 asShortFloat - op2 asShortFloat

    "Created: / 8.1.1999 / 15:08:17 / cg"
!

_GETFIELD_R: fieldRef _: obj
    "Called by jitted code for GETFIELD insn iff fieldref is not yet resolved"

    | class offset |

    obj isNil ifTrue:[
        ^self throwNullPointerException.
    ].
    class := fieldRef classRef resolve; javaClass.
    class hasMultipleVersions ifTrue:[
        fieldRef classRef resolveForVersionOf: obj or: nil.
        fieldRef resolve.
        offset := fieldRef resolvedOffset.
        fieldRef invalidate.
    ] ifFalse:[
        fieldRef resolve.
        offset := fieldRef resolvedOffset.
    ].
    ^ obj instVarAt: offset.

    "Created: / 20-01-2014 / 14:56:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2014 / 07:55:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_GETSTATIC_R: fieldRef
    "Called by jitted code for GETSTATIC insn iff fieldref is not yet resolved"

    | class |

    fieldRef resolve.
    class := fieldRef javaClass.
    class classInitInternal.
    ^ class instVarAt: fieldRef resolvedOffset.

    "Created: / 20-01-2014 / 15:03:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 09:15:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INSTANCEOF:obj _:cls
    "A principal implementation of INSTANCEOF instruction. Called by the bytecode
     interpreter for unhandled cases."

    obj isNil ifTrue: [ ^ 0 ].
    (self canCast: obj class to: cls) ifFalse: [
        ^ 0
    ].
    ^ 1


    "Created: / 08-01-1999 / 14:52:54 / cg"
    "Modified: / 27-01-1999 / 20:56:25 / cg"
    "Modified: / 09-10-2012 / 11:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 15-10-2012 / 21:51:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INSTANCEOF_R: object _: classRef
    "An implementation of INSTANCEOF instruction. Called by the jitted code
     when if the classRef hasn't been resolved at the time of jitting."

    | class |

    object isNil ifTrue: [ ^ 0 ].
    class := classRef resolve.
     ^(self canCast: object class to: class)
        ifTrue:  [ 1 ]
        ifFalse: [ 0 ].

    "Created: / 15-10-2012 / 21:51:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver
    "Called by jitted code for sends with unresolved method ref"

    | method |

    method := methodRef resolve.


    ^ receiver perform: method selector withArguments: #()

    "Created: / 17-01-2014 / 12:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 1.
    args at: 1 put: a1.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 2.
    args at: 1 put: a1.
    args at: 2 put: a2.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 3.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 4.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 5.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 6.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 7.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 8.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 9.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 10.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 11.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 12.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEINTERFACE_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 13.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    args at:13 put: a13.
    ^ receiver perform: method selector withArguments: args


    "Created: / 17-01-2014 / 12:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver
    "Called by jitted code for sends with unresolved method ref"

    | method class |

    method := methodRef resolve.
    class  := method javaClass.

    ^ method valueWithReceiver:receiver arguments:#() selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 1.
    args at: 1 put: a1.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 2.
    args at: 1 put: a1.
    args at: 2 put: a2.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 3.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 4.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 5.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 6.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 7.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 8.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 9.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 10.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 11.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 12.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESPECIAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.

    args := Array new: 13.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    args at:13 put: a13.
    ^ method valueWithReceiver:receiver arguments:args selector:method selector search:class sender: thisContext sender


    "Created: / 17-01-2014 / 12:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef
    "Called by jitted code for sends with unresolved method ref"

    | method class |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    ^ method valueWithReceiver:class arguments:#() selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 1.
    args at: 1 put: a1.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 2.
    args at: 1 put: a1.
    args at: 2 put: a2.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 3.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 4.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 5.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 6.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 7.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 8.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 9.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 10.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 11.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 12.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender

    "Created: / 17-01-2014 / 12:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKESTATIC_R: methodRef _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
    "Called by jitted code for sends with unresolved method ref"

    | method class args |

    method := methodRef resolve.
    class  := method javaClass.
    class classInitInternal.
    args := Array new: 13.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    args at:13 put: a13.
    ^ method valueWithReceiver:class arguments:args selector:method selector search:class sender: thisContext sender


    "Created: / 17-01-2014 / 12:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver
    "Called by jitted code for sends with unresolved method ref"

    | method |

    method := methodRef resolve.


    ^ receiver perform: method selector withArguments: #()

    "Created: / 17-01-2014 / 12:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 1.
    args at: 1 put: a1.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 2.
    args at: 1 put: a1.
    args at: 2 put: a2.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:09:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 3.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 4.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 5.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 6.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 7.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:14:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 8.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 9.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 10.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 11.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 12.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    ^ receiver perform: method selector withArguments: args

    "Created: / 17-01-2014 / 12:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INVOKEVIRTUAL_R: methodRef _: receiver _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 _: a9 _: a10 _: a11 _: a12 _: a13
    "Called by jitted code for sends with unresolved method ref"

    | method args |

    method := methodRef resolve.


    args := Array new: 13.
    args at: 1 put: a1.
    args at: 2 put: a2.
    args at: 3 put: a3.
    args at: 4 put: a4.
    args at: 5 put: a5.
    args at: 6 put: a6.
    args at: 7 put: a7.
    args at: 8 put: a8.
    args at: 9 put: a9.
    args at:10 put: a10.
    args at:11 put: a11.
    args at:12 put: a12.
    args at:13 put: a13.
    ^ receiver perform: method selector withArguments: args


    "Created: / 17-01-2014 / 12:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_L2D:op1
    ^ op1 asFloat

    "Created: / 8.1.1999 / 14:46:09 / cg"
!

_L2F:op1
    ^ op1 asShortFloat

    "Created: / 8.1.1999 / 14:46:18 / cg"
    "Modified: / 8.1.1999 / 14:50:18 / cg"
!

_LADD:op1 _:op2
    |sum|

    sum := (op1 + op2) bitAnd:16rFFFFFFFFFFFFFFFF.
    ^ sum

    "Created: / 8.1.1999 / 15:07:39 / cg"
!

_LAND:op1 _:op2
    |rslt|

    (op1 < 0 or:[op2 < 0]) ifTrue:[
	self halt.
    ].
    rslt := op1 bitAnd: op2.
    ^ rslt

    "Modified: / 7.1.1998 / 21:21:53 / cg"
    "Created: / 8.1.1999 / 14:54:22 / cg"
!

_LDC_R: ref
    "Called by JIT-compiled code for non-constant
     reference (StringRef or ClassRef"

    ^ref isJavaClassRef ifTrue:[
        self javaClassObjectForClass: (ref resolve: false)
    ] ifFalse:[
        ref resolve
    ]

    "Created: / 16-10-2012 / 09:34:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_LDIV:op1 _:op2
    |quo|

    quo := op1 quo: op2.
    ^ quo

    "Created: / 8.1.1999 / 15:04:47 / cg"
!

_LMUL:op1 _:op2
    |prod o1 o2 sign|

"/ self halt.
    "/ ST's largeIntegers compute a correct result;
    "/ but here, we want the overflow to flow into the
    "/ sign bit ... (sigh)

    sign := 1.
    (o1 := op1) < 0 ifTrue:[
	sign := -1.
	o1 := o1 negated.
    ].
    (o2 := op2) < 0 ifTrue:[
	sign := sign negated.
	o2 := o2 negated.
    ].

    prod := (o1 * o2) bitAnd:16rFFFFFFFFFFFFFFFF.
    (prod bitAnd:16r8000000000000000) ~~ 0 ifTrue:[
    ].
    sign == -1 ifTrue:[
	prod := prod negated
    ].
    ^ prod

    "Created: / 8.1.1999 / 15:10:04 / cg"
!

_LNEG:op
    ^ op asInteger negated

    "Created: / 8.1.1999 / 15:06:59 / cg"
!

_LOR:op1 _:op2
    |rslt|

    (op1 < 0 or:[op2 < 0]) ifTrue:[
	self halt.
    ].
    rslt := op1 bitOr: op2.
    ^ rslt

    "Created: / 8.1.1999 / 15:05:10 / cg"
!

_LREM:op1 _:op2
    |rem|

    rem := op1 rem: op2.
    ^ rem

    "Modified: / 7.1.1998 / 00:23:11 / cg"
    "Created: / 8.1.1999 / 15:04:23 / cg"
!

_LSHL:op1 _:op2
    |rslt|

    (op1 < 0) ifTrue:[
	self halt.
    ].
    rslt := (op1 bitShift:op2) bitAnd:16rFFFFFFFFFFFFFFFF.
    ^ rslt

    "Created: / 8.1.1999 / 14:51:08 / cg"
!

_LSHR:op1 _:op2
    |rslt|

    op1 < 0 ifTrue:[
	self halt
    ].

    (op1 < 0) ifTrue:[
	self halt.
    ].
    rslt := (op1 bitShift:op2 negated) bitAnd:16rFFFFFFFFFFFFFFFF.
    ^ rslt

    "Created: / 8.1.1999 / 14:51:57 / cg"
!

_LSUB:op1 _:op2
    |diff|

    diff := (op1 - op2) bitAnd:16rFFFFFFFFFFFFFFFF.
    ^ diff

    "Created: / 8.1.1999 / 15:10:33 / cg"
!

_LUSHR:op1 _:op2
    |rslt|

    op1 < 0 ifTrue:[
	self halt
    ].

    (op1 < 0) ifTrue:[
	self halt.
    ].
    rslt := (op1 bitShift:op2 negated) bitAnd:16rFFFFFFFFFFFFFFFF.
    ^ rslt

    "Modified: / 7.1.1998 / 21:22:17 / cg"
    "Created: / 8.1.1999 / 14:51:32 / cg"
!

_LXOR:op1 _:op2
    |rslt|

    (op1 < 0 or:[op2 < 0]) ifTrue:[
	self halt.
    ].
    rslt := op1 bitXor: op2.
    ^ rslt

    "Created: / 8.1.1999 / 15:12:28 / cg"
!

_MONITORENTER: anObject
    "Called by the VM if thinlock fails to lock the object.
     Used for both a real MONITORENTER instruction and for
     when entering a synchronized method"

    anObject isNil ifTrue:[ 
        ^ self throwNullPointerException:'Attempt to acquire a lock om null reference'.
    ].
    anObject getJavaMonitor acquire.

    "Created: / 08-01-1999 / 14:23:10 / cg"
    "Modified: / 08-01-1999 / 18:47:26 / cg"
    "Modified: / 09-11-2011 / 19:23:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:52:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MONITOREXIT: anObject
    "Called by the VM if thinlock fails to unlock the object.
     Used for both a real MONITOREXIT instruction and for
     when leaving a synchronized method"

    anObject isNil ifTrue:[ 
        ^ self throwNullPointerException:'Attempt to release a lock om null reference'.
    ].
    anObject getJavaMonitor release ifFalse:[ 
        "/ ^ self throwIllegalMonitorStateException: 'Attempt to release a lock not acuired by the calling thread'
    ].

    "Created: / 08-01-1999 / 14:23:19 / cg"
    "Modified: / 08-01-1999 / 18:47:08 / cg"
    "Modified: / 09-11-2011 / 12:42:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 22:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY1: cls _: dim1

    | a1 |

    dim1 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    a1 := cls new: dim1.
    ^ a1.

    "Created: / 28-01-2014 / 10:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 15:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY1_R: clsRef _: dim1
    ^ self _MULTIANEWARRAY1: clsRef resolve _: dim1

    "Created: / 28-01-2014 / 10:04:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY2: cls _: dim1 _: dim2

    | a1 |

    dim1 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim2 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    a1 := cls new: dim1.
    1 to: dim1 do:[:i1|
        | a2 |
        a2 := (a1 class javaComponentClass new: dim2).
        a1 at: i1  put: a2.
    ].
    ^ a1.

    "Created: / 28-01-2014 / 10:03:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY2_R: clsRef _: dim1 _: dim2
    ^ self _MULTIANEWARRAY2: clsRef resolve _: dim1 _: dim2

    "Created: / 28-01-2014 / 10:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY3: cls _: dim1 _: dim2 _: dim3

    | a1 |

    dim1 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim2 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim3 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    a1 := cls new: dim1.
    1 to: dim1 do:[:i1|
        | a2 |

        a2 := a1 class javaComponentClass new: dim2.
        1 to: dim2 do:[:i2 |
            | a3 |

            a3 := a2 class javaComponentClass new: dim3.
            a2 at: i2 put: a3.
        ].
        a1 at: i1  put: a2.
    ].
    ^ a1.

    "Created: / 28-01-2014 / 10:04:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY3_R: clsRef _: dim1 _: dim2 _: dim3
    ^ self _MULTIANEWARRAY3: clsRef resolve _: dim1 _: dim2 _: dim3

    "Created: / 28-01-2014 / 10:05:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY4: cls _: dim1 _: dim2 _: dim3 _: dim4

    | a1 |

    dim1 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim2 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim3 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim4 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    a1 := cls new: dim1.
    1 to: dim1 do:[:i1|
        | a2 |

        a2 := a1 class javaComponentClass new: dim2.
        1 to: dim2 do:[:i2 |
            | a3 |

            a3 := a2 class javaComponentClass new: dim3.
            1 to: dim3 do:[:i3 |
                | a4 |

                a4 := a3 class javaComponentClass new: dim4.
                a3 at: i3 put: a4.
            ].
            a2 at: i2 put: a3.
        ].
        a1 at: i1  put: a2.
    ].
    ^ a1.

    "Created: / 28-01-2014 / 10:03:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY4_R: clsRef _: dim1 _: dim2 _: dim3 _: dim4
    ^ self _MULTIANEWARRAY4: clsRef resolve _: dim1 _: dim2 _: dim3 _: dim4

    "Created: / 28-01-2014 / 10:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY5: cls _: dim1 _: dim2 _: dim3 _: dim4 _: dim5

    | a1 |

    dim1 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim2 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim3 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim4 < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    dim5  < 0 ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'negative array size not allowed'.
        ^nil
    ].
    a1 := cls new: dim1.
    1 to: dim1 do:[:i1|
        | a2 |

        a2 := a1 class javaComponentClass new: dim2.
        1 to: dim2 do:[:i2 |
            | a3 |

            a3 := a2 class javaComponentClass new: dim3.
            1 to: dim3 do:[:i3 |
                | a4 |

                a4 := a3 class javaComponentClass new: dim4.
                1 to: dim4 do:[:i4 |
                    | a5 |

                    a5 := a4 class javaComponentClass new: dim5.
                    a4 at: i4 put: a5.
                ].
                a3 at: i3 put: a4.
            ].
            a2 at: i2 put: a3.
        ].
        a1 at: i1  put: a2.
    ].
    ^ a1.

    "Created: / 28-01-2014 / 10:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY5_R: clsRef _: dim1 _: dim2 _: dim3 _: dim4 _: dim5
    ^ self _MULTIANEWARRAY5: clsRef resolve _: dim1 _: dim2 _: dim3 _: dim4 _: dim5

    "Created: / 28-01-2014 / 10:05:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY: cls _: dims

    | allocator |

    dims isEmptyOrNil ifTrue:[
        self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                         withMessage:'zero dimensions given, should not happen!!'.
    ].

    dims do:[:d |
        d < 0 ifTrue:[
            self throwExceptionClassName:'java.lang.NegativeArraySizeException'
                             withMessage:'negative array size not allowed'.
            ^nil
        ].
    ].

    allocator := [ :arrayClass :dimIndex |
        | array |

        array := arrayClass new: (dims at: dimIndex).
        dimIndex ~~ dims size ifTrue:[
            1 to: (dims at: dimIndex) do:[:i |
                array at: i put: (allocator value: arrayClass javaComponentClass value: dimIndex + 1).
            ]
        ].
        array.
    ].

    ^ allocator value: cls value: 1.

    "Created: / 28-01-2014 / 09:46:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2014 / 14:40:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_MULTIANEWARRAY_R: clsRef _: dims

    ^ self _MULTIANEWARRAY: clsRef resolve _: dims

    "Created: / 28-01-2014 / 09:43:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2014 / 14:36:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_NEW: cls
    | inst |

    cls classInit. "/initializes the class if it is not already"
    inst := cls basicNew.
    thisContext sender method flushCode.
    ^inst.

    "Created: / 15-10-2012 / 21:53:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_NEWARRAY:type _:size
    "VM helper method NEWARRAY insn. Called only when
     size is not an SmallInt or negative"

    size < 0 ifTrue:[
        self throwNegativeArraySizeException: size.
    ]

    "Created: / 13-05-2012 / 14:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_NEW_R: clsRef
    | cls inst |

    cls := clsRef resolve. "/initializes the class if it is not already"
    inst := cls basicNew.
    thisContext sender method flushCode.
    ^inst.

    "Created: / 15-10-2012 / 21:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_PUTFIELD_R: fieldRef _: obj _: value
    "Called by jitted code for PUTFIELD insn iff fieldref is not yet resolved"

    | class offset |

    obj isNil ifTrue:[
        ^self throwNullPointerException.
    ].
    obj isNil ifTrue:[
        ^self throwNullPointerException.
    ].
    class := fieldRef classRef resolve; javaClass.
    class hasMultipleVersions ifTrue:[
        fieldRef classRef resolveForVersionOf: obj or: nil.
        fieldRef resolve.
        offset := fieldRef resolvedOffset.
        fieldRef invalidate.
    ] ifFalse:[
        fieldRef resolve.
        offset := fieldRef resolvedOffset.
    ].   
    obj instVarAt: offset put: value

    "Created: / 20-01-2014 / 15:01:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2014 / 07:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_PUTSTATIC_R: fieldRef _: value
    "Called by jitted code for PUTSTATIC insn iff fieldref is not yet resolved"

    | class |

    fieldRef resolve.
    class := fieldRef javaClass.
    class classInitInternal.
    ^ class instVarAt: fieldRef resolvedOffset put: value

    "Created: / 20-01-2014 / 15:06:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 09:16:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM class methodsFor:'windows - events'!

awtEventsForEvent: anEvent javaWindow: jWin
    "given an ST/X event, create corresponding AWT event(s) for it"

    | jEv  jEv1  jEv2  modifiers  key  keyChar  untranslatedKey  id  type  x  y  w  h  view  menu  resized  moved  eventArgs  clickCount  jRect  jKeyEventClass  jInputEventClass  jMouseEventClass  jWindowEventClass  jPaintEventClass  jComponentEventClass |

    type := anEvent type.
    eventArgs := anEvent arguments.
    key := 0.
    modifiers := 0.
    x := 0.
    y := 0.
    ((type == #exposeX:y:width:height:)
        or: [ (type == #graphicExposeX:y:width:height:) or: [ (type == #damage) ] ])
            ifTrue: [
                "/        jWindowEventClass := Java classForName:'java.awt.event.WindowEvent'.
                "/        id := (jPaintEventClass instVarNamed:'PAINT').
                jPaintEventClass := self classForName: 'java.awt.event.PaintEvent'.
                id := (jPaintEventClass instVarNamed: 'UPDATE').
                ((type == #exposeX:y:width:height:)
                    or: [ (type == #graphicExposeX:y:width:height:) ])
                        ifTrue: [
                            x := eventArgs at: 1.
                            y := eventArgs at: 2.
                            w := eventArgs at: 3.
                            h := eventArgs at: 4.
                        ]
                        ifFalse: [
                            x := eventArgs left.
                            y := eventArgs top.
                            w := eventArgs width.
                            h := eventArgs height.
                        ].
                jRect := (Java classForName: 'java.awt.Rectangle') basicNew.
                jRect instVarNamed: 'x' put: x.
                jRect instVarNamed: 'y' put: y.
                jRect instVarNamed: 'width' put: w.
                jRect instVarNamed: 'height' put: h.
                jEv := jPaintEventClass newCleared.
                jEv instVarNamed: 'id' put: id.
                jEv instVarNamed: 'updateRect' put: jRect.

"/        jEv instVarNamed:'g'         put:jWin.

                ^ Array with: jEv.
            ].
    (anEvent isKeyEvent
        or: [ anEvent isButtonEvent or: [ anEvent isPointerEnterLeaveEvent ] ])
            ifTrue: [
                jInputEventClass := Java classForName: 'java.awt.event.InputEvent'.
                anEvent hasAlt ifTrue: [
                    modifiers := modifiers bitOr: (jInputEventClass instVarNamed: 'ALT_MASK')
                ].
                anEvent hasCtrl ifTrue: [
                    modifiers := modifiers bitOr: (jInputEventClass instVarNamed: 'CTRL_MASK')
                ].
                anEvent hasMeta ifTrue: [
                    modifiers := modifiers bitOr: (jInputEventClass instVarNamed: 'META_MASK')
                ].
                anEvent hasShift ifTrue: [
                    modifiers := modifiers
                                bitOr: (jInputEventClass instVarNamed: 'SHIFT_MASK')
                ].
                anEvent hasButton1 ifTrue: [
                    modifiers := modifiers
                                bitOr: (jInputEventClass instVarNamed: 'BUTTON1_MASK')
                ].
                anEvent hasButton2 ifTrue: [
                    modifiers := modifiers
                                bitOr: (jInputEventClass instVarNamed: 'BUTTON2_MASK')
                ].
                anEvent hasButton3 ifTrue: [
                    modifiers := modifiers
                                bitOr: (jInputEventClass instVarNamed: 'BUTTON3_MASK')
                ].
                anEvent isPointerEnterLeaveEvent ifFalse: [
                    "/ ST/X does not (yet) record this information
                    "/ with pointerLeave events.
                    x := anEvent x.
                    y := anEvent y.
                ].
            ].
    anEvent isKeyEvent ifTrue: [
        jKeyEventClass := Java classForName: 'java.awt.event.KeyEvent'.
        key := 0.
        keyChar := 0.
        key := anEvent key.
        key isCharacter ifTrue: [ key := keyChar := key asciiValue ] ifFalse: [
            untranslatedKey := anEvent view device keyboardMap keyAtValue: key
                        ifAbsent: key.
            untranslatedKey == #Insert ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_INSERT'
            ].
            untranslatedKey == #Delete ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_DELETE'
                "/ 127
            ].
            untranslatedKey == #BackSpace ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_BACK_SPACE'
                "/ 8
            ].
            untranslatedKey == #Return ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_ENTER'
                "/ 13
            ].
            untranslatedKey == #Tab ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_TAB'
                "/ 9
            ].
            untranslatedKey == #Home ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_HOME'
            ].
            untranslatedKey == #End ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_END'
            ].
            (key == #PreviousPage or: [ untranslatedKey == #Prior ]) ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_PAGE_UP'
            ].
            (key == #NextPage or: [ key == #EndOfText ]) ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_PAGE_DOWN'
            ].
            untranslatedKey == #CursorUp ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_UP'
            ].
            untranslatedKey == #CursorDown ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_DOWN'
            ].
            untranslatedKey == #CursorLeft ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_LEFT'
            ].
            untranslatedKey == #CursorRight ifTrue: [
                key := jKeyEventClass instVarNamed: 'VK_RIGHT'
            ].
            (#( #F1 #F2 #F3 #F4 #F5 #F6 #F7 #F8 #F9 #F10 #F11 #F12 )
                includes: untranslatedKey)
                    ifTrue: [ key := jKeyEventClass instVarNamed: ('VK_' , untranslatedKey) ].
        ].
        (type == #keyPress:x:y:) ifTrue: [
            id := jKeyEventClass instVarNamed: 'KEY_PRESSED'
        ] ifFalse: [ id := jKeyEventClass instVarNamed: 'KEY_RELEASED' ].
        jEv := jKeyEventClass newCleared.
        jEv instVarNamed: 'modifiers' put: modifiers.
        jEv instVarNamed: 'keyCode' put: key.
        jEv instVarNamed: 'keyChar' put: keyChar.
        jEv instVarNamed: 'id' put: id.

"/        jEv instVarNamed:'x'         put:x.
"/        jEv instVarNamed:'y'         put:y.

        jEv instVarNamed: 'when' put: (OperatingSystem getMillisecondTime).
        ^ Array with: jEv
    ].
    (anEvent isButtonEvent or: [ anEvent isPointerEnterLeaveEvent ]) ifTrue: [
        jMouseEventClass := Java classForName: 'java.awt.event.MouseEvent'.
        clickCount := 1.
        (type == #buttonPress:x:y:) ifTrue: [
            id := jMouseEventClass instVarNamed: 'MOUSE_PRESSED'.
        ] ifFalse: [
            (type == #buttonRelease:x:y:) ifTrue: [
                id := jMouseEventClass instVarNamed: 'MOUSE_RELEASED'.
            ] ifFalse: [
                (type == #buttonMotion:x:y:) ifTrue: [
                    (anEvent state bitAnd: (anEvent view device anyButtonMotionMask)) == 0 ifTrue: [
                        id := jMouseEventClass instVarNamed: 'MOUSE_MOVED'.
                    ] ifFalse: [ id := jMouseEventClass instVarNamed: 'MOUSE_DRAGGED'. ].
                ] ifFalse: [
                    "/                    (type == #'pointerMotion:x:y:') ifTrue:[
                    "/                        id := jMouseEventClass instVarNamed:'MOUSE_MOVED'.
                    "/                    ] ifFalse:[
                    (type == #pointerEnter:x:y:) ifTrue: [
                        id := jMouseEventClass instVarNamed: 'MOUSE_ENTERED'.
                    ] ifFalse: [
                        (type == #pointerLeave:) ifTrue: [
                            id := jMouseEventClass instVarNamed: 'MOUSE_EXITED'.
                        ] ifFalse: [
                            (type == #buttonMultiPress:x:y:) ifTrue: [
                                id := jMouseEventClass instVarNamed: 'MOUSE_PRESSED'.
                                clickCount := 2.
                            ] ifFalse: [ self halt. ]

"/                        ]
                        ]
                    ]
                ]
            ]
        ].
        jEv := jMouseEventClass newCleared.
        jEv instVarNamed: 'modifiers' put: modifiers.
        jEv instVarNamed: 'id' put: id.
        jEv instVarNamed: 'x' put: x.
        jEv instVarNamed: 'y' put: y.
        jEv instVarNamed: 'when' put: (OperatingSystem getMillisecondTime).
        ^ Array with: jEv
    ].
    (type == #configureX:y:width:height:) ifTrue: [
        view := anEvent view.
        x := eventArgs at: 1.
        y := eventArgs at: 2.
        w := eventArgs at: 3.
        h := eventArgs at: 4.
        resized := (w ~~ view width or: [ h ~~ view height ]).
        moved := (x ~~ view left or: [ y ~~ view top ]).

"/        (view isTopView or:[view isPopUpView]) ifTrue:[
        "/ view must update its origin/extent.

        view dispatchEvent: anEvent.

"/        ].
        "/
        "/ must change the components extent
        "/ is there no cleaner way to do this ?
        "/

        view isTopView ifTrue: [
            view isPopUpView ifFalse: [
                "/
                "/ sigh - don't include the menu.
                "/
                menu := self topViewsMenu: view.
                menu notNil ifTrue: [
                    "/ must add the menus height
                    h := h - menu height
                ]
            ]
        ].
        jWin instVarNamed: 'width' put: w.
        jWin instVarNamed: 'height' put: h.
        jWin instVarNamed: 'x' put: x.
        jWin instVarNamed: 'y' put: y.
        jComponentEventClass := Java classForName: 'java.awt.event.ComponentEvent'.
        moved ifTrue: [
            id := (jComponentEventClass instVarNamed: 'COMPONENT_MOVED').
            jEv1 := jComponentEventClass newCleared.
            jEv1 instVarNamed: 'id' put: id.
        ].
        resized ifTrue: [
            id := (jComponentEventClass instVarNamed: 'COMPONENT_RESIZED').
            jEv2 := jComponentEventClass newCleared.
            jEv2 instVarNamed: 'id' put: id.
        ].
        jEv1 isNil ifTrue: [
            jEv2 isNil ifTrue: [ ^ nil ].
            ^ Array with: jEv2
        ] ifFalse: [ jEv2 isNil ifTrue: [ ^ Array with: jEv1 ] ].
        ^ Array with: jEv1 with: jEv2.
    ].
    (type == #focusIn) ifTrue: [
        "/ 'focusIn' printCR.
        jComponentEventClass := Java classForName: 'java.awt.event.FocusEvent'.
        id := (jComponentEventClass instVarNamed: 'FOCUS_GAINED').
        jEv := jComponentEventClass newCleared.
        jEv instVarNamed: 'id' put: id.
        ^ Array with: jEv.
    ].
    (type == #focusOut) ifTrue: [
        "/ 'focusOut' printCR.
        jComponentEventClass := Java classForName: 'java.awt.event.FocusEvent'.
        id := (jComponentEventClass instVarNamed: 'FOCUS_LOST').
        jEv := jComponentEventClass newCleared.
        jEv instVarNamed: 'id' put: id.
        ^ Array with: jEv.
    ].
    (type == #mapped) ifTrue: [
        "/ 'mapped' printCR.
        jComponentEventClass := Java classForName: 'java.awt.event.ComponentEvent'.
        id := (jComponentEventClass instVarNamed: 'COMPONENT_SHOWN').

"/        x := eventArgs at:1.
"/        y := eventArgs at:2.

        jEv := jComponentEventClass newCleared.
        jEv instVarNamed: 'id' put: id.
        ^ Array with: jEv.
    ].
    (type == #unmapped) ifTrue: [
        "/ 'unmapped' printCR.
        jComponentEventClass := Java classForName: 'java.awt.event.ComponentEvent'.
        id := (jComponentEventClass instVarNamed: 'COMPONENT_HIDDEN').

"/        x := eventArgs at:1.
"/        y := eventArgs at:2.

        jEv := jComponentEventClass newCleared.
        jEv instVarNamed: 'id' put: id.
        ^ Array with: jEv.
    ].
    (type == #terminate) ifTrue: [
        jWindowEventClass := Java classForName: 'java.awt.event.WindowEvent'.
         "NEW
         id := (jWindowEventClass instVarNamed:'WINDOW_CLOSING').
        " "OLD "
        id := (jWindowEventClass instVarNamed: 'WINDOW_CLOSED').

        jEv := jWindowEventClass newCleared.
        jEv instVarNamed: 'id' put: id.
        ^ Array with: jEv.
    ].
    EventTrace == true ifTrue: [ Logger log: ('JAVA: unhandled event:' , type) infoPrintCR. ].
    ^ nil.

    "Created: / 06-01-1998 / 20:38:58 / cg"
    "Modified: / 09-01-1999 / 09:29:58 / cg"
    "Modified: / 02-03-2015 / 15:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delegatesTo:someOne
    ^ false

    "Created: / 25.9.1999 / 16:11:48 / cg"
!

doWindowsEventThread
    "invoked in an endless loop by the WToolkit-eventLoop
     native method."

    | sensor  event  more |
    (JavaWindowGroup isNil or: [ KnownWindows isNil ]) ifTrue: [
        "/ '*** eventThread: no windowGroup / views ...' printCR.
        self halt: 'monitors are reimplemented, change me if you know how and why'.
        "self
            waitFor: FirstWindowCreationSemaphore
            state: #eventWait
            timeOut: nil."

        "/ Delay waitForSeconds:0.1.

        ^ self
    ].

    "/ wait for an event to arrive ...

    sensor := JavaWindowGroup sensor.
    [ sensor hasEvents or: [ sensor damageCount ~~ 0 ] ] whileFalse: [
        EventTrace ifTrue: [ '*** eventThread waiting ...' printCR. ].
        Processor activeProcess state: #eventWait.
        self
            waitFor: sensor eventSemaphore
            state: #eventWait
            timeOut: nil.
    ].
    EventTrace ifTrue: [ '*** eventThread event arrived ...' printCR. ].

    "/ EventTrace := true

    more := true.
    [ more ] whileTrue: [
        sensor hasDamage ifTrue: [
            EventTrace ifTrue: [ '*** eventThread: damage arrived ...' printCR. ].
            event := sensor nextDamage.
        ] ifFalse: [ event := sensor nextEvent. ].
        event isNil ifTrue: [
            EventTrace == true ifTrue: [ '*** eventThread: nil event ignored' printCR. ].
            ^ self
        ].
        more := self processEvent: event
    ]

    "Created: / 06-01-1998 / 21:02:40 / cg"
    "Modified: / 30-12-1998 / 19:21:36 / cg"
    "Modified: / 22-11-2011 / 13:22:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

processEvent: event
    | evQ  jEvents  jWToolKitClass  jWToolKit  jWinPeer  jWin  v  eventConsumed |

    KnownWindows isNil ifTrue: [ ^ false ].
    v := event view.
    jWinPeer := self jPeerForView: v.
    jWinPeer isNil ifTrue: [
        v isJavaView ifTrue: [
            "/ mhmh - an event for a JavaView,
            "/ which has no peer (anyMore ?)
            "/ should not happen.
        ] ifFalse: [
            "/ mhmh - an event for a subcomponent of an ST widget.
            "/ let it be handled normally.
            EventTrace ifTrue: [
                ('*** eventThread: ' , event type
                    , '-event for unknown java-view - passed to view.') printCR.
            ].
            event view dispatchEvent: event.
        ].
        ^ true
    ].

    "/ change:
    "/ in the previous version, events for ST/X widgets (i.e. buttons etc)
    "/ where not passed to java, but instead forwarded directly to the widget
    "/ by the code below.
    "/ This has changed, to pass it to Java, which eventually passes it to the
    "/ peer via the handleEvent native method (unless the event got consumed).
    "/ This is req'd to let java keep track of keyboard/mouse input for widgets.

    (event isDamage and: [ v isJavaView ]) ifTrue: [
        "/    "/ most views handle their events themself (being ST/X views) ...
        "/
        "/    v class ~~ JavaView ifTrue:[
        "/"/        v class ~~ StandardSystemView ifTrue:[
        "/"/            EventTrace ifTrue:[
        "/"/                    ('*** eventThread: event handled by view itself (' , v class name , ')') printCR.
        "/"/            ].
        "/"/            event sendEventWithFocusOn:nil.
        "/"/            ^ self.
        "/"/        ].
        "/        (event type == #'exposeX:y:width:height'
        "/        or:[event type == #'graphicsExposeX:y:width:height']) ifTrue:[
        "/            "/ send to view, but also handle in JAVA
        "/            event sendEventWithFocusOn:nil.
        "/        ]
        "/    ].
        (#( #mapped
         #unmapped
         #configureX:y:width:height:
         #exposeX:y:width:height:
         #graphicsExposeX:y:width:height: ) includes: event type) ifTrue: [
            event sendEventWithFocusOn: nil.
        ].
    ].

    "/ what a kludge - some events are passed back to
    "/ ST via the WComponent-handleEvent native method.
    "/ However, repaints are not.
    "/ In order to let ST widgets do the drawing,
    "/ selectively filter exposeEvents from Java ...

    eventConsumed := false.
    v isJavaView ifTrue: [
        "/ all events handled by Java ...
    ] ifFalse: [
        eventConsumed := true.

        "/ let widget handle it.

        event view dispatchEvent: event.

        "/ some are not passed to Java ...

        event isDamage ifTrue: [
            (v isKindOf: Button) ifTrue: [ ^ true ].
            (v isKindOf: TextView) ifTrue: [ ^ true ].
            (v isKindOf: Label) ifTrue: [ ^ true ].
            (v isKindOf: ComboBoxView) ifTrue: [ ^ true ].
            (v isKindOf: ScrollBar) ifTrue: [ ^ true ].
            (v isKindOf: Scroller) ifTrue: [ ^ true ].
            (v isKindOf: MenuPanel) ifTrue: [ ^ true ].
        ].
    ].
    jWin := jWinPeer instVarNamed: 'target'.
    EventTrace ifTrue: [
        Logger log: (('*** eventThread: event (' , event type , ') handled by JAVA: ') , jWinPeer class name ,' (' , jWin class name , ')') severity: Logger severityTRACE facility: #JVM                                  
    ].

    "/ create an event

    jEvents := self awtEventsForEvent: event javaWindow: jWin.
    jEvents isNil ifTrue: [
        EventTrace ifTrue: [
            ('*** eventThread: event ignored: ' , event type) printCR.
        ].
        ^ true
    ].

"/    v superView isNil ifTrue:[
"/        ('*** eventThread: event ignored for topView: ' , event type) printCR.
"/        ^ self
"/    ].

    jWToolKitClass := self classForName: 'java.awt.Toolkit'.

    "/ jWToolKit := jWToolKitClass perform:#getDefaultToolkit.

    jWToolKit := jWToolKitClass
                performStatic: #'getDefaultToolkit()Ljava/awt/Toolkit;'.
    jEvents do: [
        :jEv |
        jEv instVarNamed: 'source' put: jWin.
        jEv instVarNamed: 'consumed' put: 0.
        eventConsumed ifFalse: [
            "/ the first gets the original event as data
            jEv instVarNamed: 'data' put: event.
            eventConsumed := true
        ].

        "/ post it (them) to the event queue

        EventTrace == true ifTrue: [ 'postEvent to Java ...' printCR. ].
        jWToolKit "class" perform: #'postEvent(Ljava/awt/AWTEvent;)V' with: jEv.
    ].
    ^ false

    "Created: / 06-01-1998 / 20:36:36 / cg"
    "Modified: / 10-12-1998 / 19:36:59 / cg"
    "Modified: / 02-03-2015 / 15:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance class methodsFor:'documentation'!

documentation
"
    A helper class to keep performance counters for JavaVM

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaVM::Performance class methodsFor:'instance creation'!

for: aJavaVM

    ^self new setVM: aJavaVM.

    "Created: / 21-12-2010 / 19:42:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance methodsFor:'accessing'!

counters
    ^ counters
! !

!JavaVM::Performance methodsFor:'accessing-counters'!

get: name
    "Return the value of given performance counter."

    ^self set: name to: -1
!

set: name to: newValue
    "Set and return the value of given performance counter.
     If newValue >= 0, performance counter is set to given
     value and previous value is returned. If newValue < 0,
     then the current value is returned"

    | value |
    value isSymbol ifTrue:[
        self error: value.
        ^nil
    ].
    ^value

    "Modified (format): / 20-02-2013 / 00:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance methodsFor:'initialization'!

setVM: aJavaVM

    "Now, aJavaVM == JavaVM (i.e, the class JavaVM
    itself, not its instance)"

    vm := aJavaVM.
    counters := Dictionary new.

    "Created: / 21-12-2010 / 19:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-02-2013 / 00:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance methodsFor:'orinting-streams'!

printOpenExternalStream: stream number: index on: output
    "Print info about given external stream to output. Return true,
     if the instance is executor, false otherwise"

    | executor |

    executor := ((3 to: stream class instSize) allSatisfy:[:index|
        index == 6 or:[index == 7 or:[(stream instVarAt: index) isNil]]
    ]).

    '%-4d %-30s %-15s %s' printf:{
        index .
        stream class binaryName.
        executor ifTrue:['(executor)'] ifFalse:[(self printOpenExternalStreamIdentificationOf: stream)].
        executor ifTrue:[''] ifFalse:[stream isFileStream ifTrue:[stream pathName ? '??? no pathName ???'] ifFalse:['']]
    } on: output.

    ^ executor

    "
        JavaVM::Performance new printOpenExternalStreams
    "

    "Created: / 14-08-2012 / 01:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOpenExternalStreamIdentificationOf:stream
    | zc oft |

    (oft := Smalltalk at:#'JavaVMData:OpenFileTable') notNil ifTrue:[
        | idx |
        idx := oft identityIndexOf: stream.
        idx ~~ 0 ifTrue:[
            ^ 'VM   OFT[' ,idx printString, ']'.
        ].
    ].
    (zc := Smalltalk at:#'JavaVMData:ZipCache') notNil ifTrue:[
        | idx |
        zc withIndexDo:[:each :idx|
            (each instVarAt:1 "named: #file") == stream ifTrue:[
                ^ 'VM   ZC[' ,idx printString, ']'.
            ].
        ].
    ].

    ((Smalltalk at:#'Java:SourceCache') ? #()) do:[:each|
        each == stream ifTrue:[
            ^ 'Java SC'
        ].
    ].

    ((Smalltalk at:#'JavaClassReader:JavaArchiveCache') ? #()) do:[:each|
        (each instVarAt:1 "named: #file") == stream ifTrue:[
            ^ 'JCR  JAC'
        ].
    ].

    ((Smalltalk at:#'Java:SourceArchiveCache') ? #()) do:[:each|
        (each instVarAt:1 "named: #file") == stream ifTrue:[
            ^ 'Java SAC'
        ].
    ].

    ^''

    "Created: / 14-08-2012 / 01:17:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2013 / 12:15:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOpenExternalStreams
    ^self printOpenExternalStreamsOn: Transcript

    "Created: / 14-08-2012 / 01:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOpenExternalStreamsOn: aStream

    | nOpenStreams nExecutors |

    ObjectMemory garbageCollect.

    aStream nextPutLine: '=== JavaVM open external stream statistics ==='.
    aStream nextPutLine: Timestamp now printString.

    nOpenStreams := 0.
    nExecutors := 0.
    ExternalStream allSubInstancesDo:[:each|
        each isOpen ifTrue:[
            nOpenStreams := nOpenStreams + 1.
            (self printOpenExternalStream: each number: nOpenStreams on: aStream) ifTrue:[
                nExecutors := nExecutors + 1
            ].
            aStream cr.
        ]
    ].
    aStream cr.
    aStream nextPutLine:
        ('SUMMARY: open=%1, executors=%4, java.io=%2, java.util.zip=%3'
            bindWith: nOpenStreams
                with: (((Smalltalk at:#'JavaVMData:OpenFileTable') ? #()) inject:0 into:[:a :s|a + (s notNil ifTrue:[1] ifFalse:[0])])
                with: (((Smalltalk at:#'JavaVMData:ZipCache') ? #())      inject:0 into:[:a :s|a + ((s notNil and:[s file notNil]) ifTrue:[1] ifFalse:[0])])
                with: nExecutors
        ).

    aStream nextPutLine: '=============================================='.
    aStream nextPutLine: ''

    "
        JavaVM::Performance new printOpenExternalStreams
    "

    "Created: / 14-08-2012 / 00:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2013 / 12:43:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance methodsFor:'printing-counters'!

printCounters

    self printCountersOn: Transcript

    "Created: / 14-08-2012 / 00:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCountersOn: aStream

    aStream nextPutLine: '=== JavaVM performance statistics ============'.
    aStream nextPutLine: Timestamp now printString.
    self printCounters_ExecutionOn: aStream.
    aStream cr.
    self printCounters_CompilationOn: aStream.
    aStream cr.
    self printCounters_MonitorOn: aStream.
    aStream cr.
    self printCounters_TopTenNativesOn: aStream.
    aStream nextPutLine: '=============================================='.
    aStream nextPutLine: ''

    "
        JavaVM performance printCounters
    "

    "Created: / 14-08-2012 / 00:43:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-10-2012 / 18:12:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounters_CompilationOn: aStream

    "Created: / 15-10-2012 / 15:33:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2015 / 21:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounters_ExecutionOn: aStream

    "Created: / 15-10-2012 / 15:33:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2015 / 21:33:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounters_MonitorOn: aStream

    "Created: / 28-08-2012 / 10:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-04-2015 / 21:33:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounters_Top: n nativesOn: aStream

    | nativesSorted  |

    self printCounterGroup:'top ', n printString , ' (unoptimized) natives' on: aStream.
    nativesSorted := JavaNativeMethod allInstances asSortedCollection:
                        [:a :b| a nCalls > b nCalls ].
    1 to: n do:[:idx|
        | m |

        m := nativesSorted at: idx.
        aStream nextPutAll: (m nCalls printStringRadix:10 size:8 fill:Character space).
        aStream nextPutAll:'   '.
        aStream
            nextPutAll: m mclass binaryName;
            nextPutAll: ' >> ';
            nextPutAll: m selector;
            cr.
    ]

    "Created: / 27-10-2012 / 18:09:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:49:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounters_TopTenNativesOn: aStream

    self printCounters_Top: 10 nativesOn: aStream

    "Created: / 27-10-2012 / 18:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::Performance methodsFor:'printing-counters-private'!

printCounter: name on: stream

    self printCounter: name on: stream labeled: name

    "Created: / 15-10-2012 / 15:28:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounter: name on: stream labeled: label

    [
        '  %-35s : %10d' printf: { label . (self get: name) } on: stream
    ] on: Error do:[
        '  %-35s : N/A' printf: { label } on: stream
    ].
    stream cr.

    "Created: / 15-10-2012 / 15:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCounterGroup: gname on: stream

    stream nextPut:$-; nextPut:$-; space; nextPutAll: gname; space; nextPut:$-; nextPut:$-; cr.

    "Created: / 15-10-2012 / 15:29:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::ReflectionRegistry class methodsFor:'documentation'!

documentation
"
    A helper class to deal with Java reflection

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaVM::ReflectionRegistry class methodsFor:'instance creation'!

for: aJavaVM

    ^self new setVM: aJavaVM.

    "Created: / 21-12-2010 / 19:42:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaVM::ReflectionRegistry methodsFor:'initialization'!

flush
    self initialize.

    "Created: / 09-01-2013 / 16:00:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    constantPoolMapping := IdentityDictionary new.
    javaClasses := IdentityDictionary new.
    javaArrayClasses := IdentityDictionary new.

    "Created: / 21-12-2010 / 19:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 00:24:28 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 11-01-2016 / 23:13:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setVM: aJavaVM

    "Now, aJavaVM == JavaVM (i.e, the class JavaVM
    itself, not its instance)"

    vm := aJavaVM

    "Created: / 21-12-2010 / 19:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::ReflectionRegistry methodsFor:'reflection - classes'!

arrayClassFor: javaClass ifAbsentPut: block
    ^javaArrayClasses at: javaClass ifAbsentPut: block

    "Created: / 05-07-2012 / 23:21:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classForJavaClassObject: aJavaClassObject
    "
        Given an instance of java.lang.Class, answers
        real (Java) class associated with it. The instance
        of java.lang.Class should be first created by myself
        (by sending #javaClassObjectForClass:)"

    ^ javaClasses at: aJavaClassObject 
            ifAbsent: [ vm internalError: 'No class associated with given java.lang.Class!!' ].

    "Created: / 28-01-2011 / 15:22:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 21-10-2011 / 13:41:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 11-01-2016 / 16:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassObjectArrayForClasses: classes
    "
        Answers an instance of java.lang.Class[] for given
        real (Java) classes."

    | array |

    array := _java_lang_Class_CLASS javaArrayClass
                new: classes size.
    classes isNilOrEmptyCollection ifTrue: [ ^ array ].
    classes
        withIndexDo: [:cls :idx | array at: idx put: (self javaClassObjectForClass: cls) ].
    ^ array

    "Modified: / 28-01-2011 / 15:15:44 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 04-02-2011 / 22:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-05-2013 / 16:29:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassObjectForClass:aClass

    ^self javaClassObjectForClass:aClass init: true.

    "Modified: / 28-01-2011 / 15:15:44 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 12-08-2011 / 19:07:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassObjectForClass: aClass init: init
    "
        Answers an instance of java.lang.Class for given
        real (Java) class."

    | javaClassObj |

    self assert: aClass isBehavior message: 'aClass is not behavior'.
    self assert: aClass ~~ Array message: 'aClass should not be Array (old impl)'.

    javaClasses at: aClass ifPresent: [:javaClassObj | ^ javaClassObj ].

    "/ class must be initialized (with all of its superclasses ?).

    "/ false ifTrue: [ aClass isJavaClass ifTrue: [ aClass classInit ]. ].

    "/ Here, install Java lookup as Java may send a messages to that
    "/ object
    (aClass isJavaClass not and:[aClass isJavaArrayClass not and:[aClass isJavaPrimitiveType not]]) ifTrue:[
        aClass == Object ifTrue:[ self halt. ].
        aClass lookupObject: JavaLookup instance.
    ].
    javaClassObj := _java_lang_Class_CLASS new.
    "/ Some more recent OpenJDK 7 (7u85-2.6.1-3) introduced 
    "/ a classLoader field in java.lang.Class instances, making
    "/ java.lang.Class.getClassLoader0() useless. To support both,
    "/ fill in the `classLoader` field here (if defined, if not,
    "/ _java_lang_Class_classLoader_ID will be nil)
    _java_lang_Class_classLoader_ID notNil ifTrue:[ 
        javaClassObj instVarAt: _java_lang_Class_classLoader_ID put: aClass classLoader.
    ].
    self rememberJavaClassObject: javaClassObj for: aClass.
    ^ javaClassObj

    "Modified: / 28-01-2011 / 15:15:44 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 12-08-2011 / 19:07:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-09-2015 / 15:40:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassObjectForClassNamed: className
    "
        Answers an instance of java.lang.Class for given
        (java) class name. The className may be name of primitive
        type, i.e. 'int', 'double'."

    | cls |

    cls := JavaDescriptor baseTypesByTypeName at: className
                ifAbsent: [ vm classForName: className ].
    ^ self javaClassObjectForClass: cls.

    "Created: / 03-02-2011 / 21:12:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-04-2011 / 14:45:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

rememberJavaClassObject: jclass for: class


    javaClasses at: class put: jclass.
    javaClasses at: jclass put: class.
    "/ An ugly hack: when register a java.lang.Class object
    "/ for String or Unicode16String, also register the same
    "/ class for the other.
    "/ This is required because Java's char[] can be instance of
    "/ both a String or Unicode16String. getClass() on both must
    "/ return the same instance of a java.lang.Class.
    "/ Certainly not nice, but required.
    class == String ifTrue:[ 
        javaClasses at: Unicode16String put: jclass.
        javaClasses at: jclass put: Unicode16String.
    ] ifFalse:[ class == Unicode16String ifTrue:[
        javaClasses at: String put: jclass.
        javaClasses at: jclass put: String.
    ]]

    "Created: / 05-12-2011 / 09:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-03-2015 / 16:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeJavaClassObjectForClass: class
    | classObject |

    classObject := javaClasses at: class ifAbsent:[ ^ self ].

    javaClasses removeKey: class.
    javaClasses removeKey: classObject.

    "Created: / 09-08-2014 / 00:05:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::ReflectionRegistry methodsFor:'reflection - constant pool'!

constantPoolFor:javaConstantPoolObject
    ^ constantPoolMapping at:javaConstantPoolObject
        ifAbsent:[self error:'Given ConstantPool was not created by JVM']

    "Created: / 21-12-2010 / 19:56:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2011 / 14:56:54 / Marcel Hlopko <hlopik@gmail.com>"
!

javaConstantPoolObjectFor: aConstantPool

    ^constantPoolMapping at: aConstantPool ifAbsent:
        [| javaConstantPoolObject |
        javaConstantPoolObject := (vm classForName:'sun.reflect.ConstantPool') new.
        constantPoolMapping at: aConstantPool put: javaConstantPoolObject.
        constantPoolMapping at: javaConstantPoolObject put: aConstantPool.
        javaConstantPoolObject]

    "Created: / 21-12-2010 / 19:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::ReflectionRegistry methodsFor:'reflection - methods & ctors'!

classForJavaConstructorObject:constructor
     "given a java.lang.reflect.Constructor, return the corresponding class for it."

    | jclass |
    jclass := constructor instVarNamed: #clazz.
    ^self classForJavaClassObject: jclass.

    "Created: / 22-08-2012 / 12:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaMethodObjectLikeSlotsInto: jMethod forMethod: method
    "
       Fill in slots of given instance of java.lang.Method or
       java.lang.Constructor"

    | desc |

    desc := method descriptor.
    jMethod
        instVarNamed: #clazz put: (self javaClassObjectForClass: method javaClass);
        instVarNamed: #slot put: 0;
        instVarNamed: #modifiers put: method accessFlags;
        instVarNamed: #parameterTypes
            put: (self javaClassObjectArrayForClasses: desc parameterClasses);
        instVarNamed: #exceptionTypes
            put: (self javaClassObjectArrayForClasses: method javaExceptionTable);
        instVarNamed: #annotations put: (method annotations runtimeVisible bytes);
        yourself.

    method signature notNil ifTrue:[
        jMethod
            instVarNamed: #signature
            put: (self javaStringObjectForString: method signature interned: true)
    ].

    ^ jMethod

    "Created: / 11-02-2011 / 06:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 17:17:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-12-2011 / 19:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodForJavaConstructorObject:constructor
     "given a java.lang.reflect.Constructor, return the corresponding method
      it."

    | slot |
    slot := constructor instVarNamed: #slot.
    ^slot
"/    ^realMethods at: slot ifAbsent:[self error: 'No ctor found for java ctor object'].

"/    |class signature|
"/    class := self classForJavaClassObject:(constructor instVarNamed:#clazz).
"/    signature := Java as_ST_String:(constructor instVarNamed:#signature).
"/    class methodsDo:[:mthd|
"/        mthd signature = signature ifTrue:[
"/            ^mthd
"/        ].
"/    ].

    "Created: / 09-02-2011 / 10:36:07 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 01-08-2012 / 11:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodForJavaMethodObject:jmethod
     "
         Given an instance of java.lang.reflect.Method, answers
         real method associated with it.
    "

    | slot |
    slot := jmethod instVarNamed: #slot.
    ^slot
"/    ^realMethods at: slot ifAbsent:[self error: 'No method found for java method object'].

"/    |class name signature |
"/
"/    class := self classForJavaClassObject:(aJavaMethodObject instVarNamed:#clazz).
"/    name := Java as_ST_String:(aJavaMethodObject instVarNamed:#name).
"/    signature := Java as_ST_String:(aJavaMethodObject instVarNamed:#signature).
"/    class methodsDo:[:mthd|
"/        (mthd name = name and:[mthd signature = signature]) ifTrue:[
"/            ^mthd
"/        ]
"/    ].
"/    self assert: false description: 'No such method, malformed java.lang.reflect.Method object?'.
"/    ^nil.

    "Created: / 09-02-2011 / 10:32:14 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 11-01-2016 / 23:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVM::ReflectionRegistry methodsFor:'reflection - other'!

javaStringObjectForString:string
    ^ self javaStringObjectForString: string interned: false

    "Created: / 09-02-2011 / 10:34:57 / Marcel Hlopko <hlopik@gmail.com>"
!

javaStringObjectForString:string interned:intern
    | s |
    s := Java as_String: string.
    ^intern ifTrue:[Java intern: s] ifFalse:[s]

    "Modified: / 22-11-2010 / 17:57:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 09-02-2011 / 10:34:29 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaVM class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaVM.st,v 1.195 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaVM.st,v 1.195 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaVM initialize!
