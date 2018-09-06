/* generic.c */

/* Demo of BEOS Mesa rendering */

/*
 * See Mesa/include/GL/osmesa.h for documentation of the OSMesa functions.
 *
 * If you want to render BIG images you'll probably have to increase
 * MAX_WIDTH and MAX_HEIGHT in src/config.h.
 *
 * This program is in the public domain.
 *
 * BEOS output provided by Tinic Urou
 * 5uro@informatik.uni-hamburg.de
 */

#include <AppKit.h>
#include <InterfaceKit.h>
#include <KernelKit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "GL/osmesa.h"

/* imported from demo code */

extern 	int 			gl_width,gl_height;
extern 	void 			render_image(void);

const 	ulong 			APP_SIGNATURE = '????';

class 					MesaWindow;
class 					MesaView;
class					MesaApp;

// Lets make our life easy and make them global:

BBitmap 				*the_bitmap;
MesaView				*the_view;	
MesaWindow 			    *the_window;

class MesaView : public BView
{
	public:
	
	MesaView(BRect frame):BView(frame,"Mesa View",B_FOLLOW_NONE,B_WILL_DRAW)
	{
	};
	
	void Draw(BRect frame)
	{
		DrawBitmap(the_bitmap,BPoint(0,0));
	};					
};

class MesaWindow : public BWindow 
{
	public:
	
	MesaWindow(int width, int height):BWindow(BRect(0,0,width-1,height-1),"MesaView",B_TITLED_WINDOW,B_NOT_RESIZABLE|B_NOT_ZOOMABLE)
	{
		// Move window to right position
		MoveTo(80, 24);
		// Create bitmap view
		Lock();
		AddChild(the_view = new MesaView(BRect(0, 0, (gl_width)-1, (gl_height)-1)));
		Unlock();
	};
	
	bool QuitRequested(void)
	{
		be_app->PostMessage(B_QUIT_REQUESTED);
		return TRUE;
	};
};

class MesaApp : public BApplication 
{
	public:
	
	MesaApp():BApplication(APP_SIGNATURE)
	{
		the_window = NULL;
		the_bitmap = NULL;
	};
			
	void ReadyToRun(void)
	{
		// Allocate the bitmap		
		the_bitmap = new BBitmap(BRect(0, 0, gl_width-1, gl_height-1), B_RGB_32_BIT);

		uchar *bits = (uchar *)the_bitmap->Bits();

		memset(bits,0,the_bitmap->BytesPerRow()*gl_height);

		// Open window
		the_window = new MesaWindow((gl_width),(gl_height));
		the_window->Show();

		OSMesaContext ctx;
		unsigned char *buffer;
		double start,end;

		// Create an RGBA-mode context 
		ctx = OSMesaCreateContext( GL_RGBA, NULL );

		// Bind the buffer to the context and make it current */
		OSMesaMakeCurrent( ctx, bits, GL_UNSIGNED_BYTE, gl_width, gl_height );
		OSMesaPixelStore( OSMESA_Y_UP, 0 );

		// here is the Mesa call 
		start=system_time();
		render_image();
		end=system_time();		
		printf("Rendering took %3.1f seconds\n",(float)((end-start)/1000000));

		// destroy the context 
		OSMesaDestroyContext( ctx );
	
		the_window->Lock();
		the_view->Draw(the_view->Bounds());
		the_window->Unlock();
	};

	bool QuitRequested(void)
	{
		// Make sure that the window closes first
		if (BApplication::QuitRequested()) 
		{
			if (the_bitmap)	delete the_bitmap;
			return TRUE;
		}
		return FALSE;
	};
			
	void AboutRequested(void)
	{
		char str[256];
		sprintf(str, "MesaDemos, ported by Tinic Urou\n<5uro@informatik.uni-hamburg.de>\nFreely distributable.");
		BAlert *the_alert = new BAlert("", str, "OK");
		the_alert->Go();
	};
};

int main( int argc, char *argv[] )
{
	MesaApp *the_app;

	the_app = new MesaApp();
	the_app->Run();
	delete the_app;

	return 0;
}
