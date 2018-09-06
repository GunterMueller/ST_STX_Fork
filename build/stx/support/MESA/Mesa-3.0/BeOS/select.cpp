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
#include <math.h>
#include "GL/osmesa.h"
#include "GL/glu.h"


#define MAXOBJS 10000
#define MAXSELECT 100
#define MAXFEED 300
#define	SOLID 1
#define	LINE 2
#define	POINT 3


GLenum directRender;
GLint windW, windH;

GLuint selectBuf[MAXSELECT];
GLfloat feedBuf[MAXFEED];
GLint vp[4];
float zRotation = 90.0;
float zoom = 1.0;
GLint objectCount;
GLint numObjects;
struct object {
    float v1[2];
    float v2[2];
    float v3[2];
    float color[3];
} objects[MAXOBJS];
GLenum linePoly = GL_FALSE;


static void InitObjects(GLint num)
{
    GLint i;
    float x, y;

    if (num > MAXOBJS) {
	num = MAXOBJS;
    }
    if (num < 1) {
	num = 1;
    }
    objectCount = num;

    srand((unsigned int)time(NULL));
    for (i = 0; i < num; i++) {
	x = (rand() % 300) - 150;
	y = (rand() % 300) - 150;

	objects[i].v1[0] = x + (rand() % 50) - 25;
	objects[i].v2[0] = x + (rand() % 50) - 25;
	objects[i].v3[0] = x + (rand() % 50) - 25;
	objects[i].v1[1] = y + (rand() % 50) - 25;
	objects[i].v2[1] = y + (rand() % 50) - 25;
	objects[i].v3[1] = y + (rand() % 50) - 25;
	objects[i].color[0] = ((rand() % 100) + 50) / 150.0;
	objects[i].color[1] = ((rand() % 100) + 50) / 150.0;
	objects[i].color[2] = ((rand() % 100) + 50) / 150.0;
    }
}

static void Init(void)
{

    numObjects = 10;
    InitObjects(numObjects);
    glGetIntegerv(GL_VIEWPORT, vp);
}

static void Reshape(int width, int height)
{

    windW = (GLint)width;
    windH = (GLint)height;
}

static void Render(GLenum mode)
{
    GLint i;

    for (i = 0; i < objectCount; i++) {
	if (mode == GL_SELECT) {
	    glLoadName(i);
	}
	glColor3fv(objects[i].color);
	glBegin(GL_POLYGON);
	    glVertex2fv(objects[i].v1);
	    glVertex2fv(objects[i].v2);
	    glVertex2fv(objects[i].v3);
	glEnd();
    }
}

static GLint DoSelect(GLint x, GLint y)
{
    GLint hits;

    glSelectBuffer(MAXSELECT, selectBuf);
    (void)glRenderMode(GL_SELECT);
    glInitNames();
    glPushName(~0);

    glPushMatrix();

    glViewport(0, 0, windW, windH);
    glGetIntegerv(GL_VIEWPORT, vp);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPickMatrix(x, windH-y, 4, 4, vp);
    gluOrtho2D(-175, 175, -175, 175);
    glMatrixMode(GL_MODELVIEW);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glScalef(zoom, zoom, zoom);
    glRotatef(zRotation, 0, 0, 1);

    Render(GL_SELECT);

    glPopMatrix();
    
    hits = glRenderMode(GL_RENDER); 
    if (hits <= 0) {
	return -1;
    }

    return selectBuf[(hits-1)*4+3];
}

static void RecolorTri(GLint h)
{

    objects[h].color[0] = ((rand() % 100) + 50) / 150.0;
    objects[h].color[1] = ((rand() % 100) + 50) / 150.0;
    objects[h].color[2] = ((rand() % 100) + 50) / 150.0;
}

static void DeleteTri(GLint h)
{

    objects[h] = objects[objectCount-1];
    objectCount--;
}

static void GrowTri(GLint h)
{
    float v[2];
    float *oldV;
    GLint i;

    v[0] = objects[h].v1[0] + objects[h].v2[0] + objects[h].v3[0];
    v[1] = objects[h].v1[1] + objects[h].v2[1] + objects[h].v3[1];
    v[0] /= 3;
    v[1] /= 3;

    for (i = 0; i < 3; i++) {
	switch (i) {
	  case 0:
	    oldV = objects[h].v1;
	    break;
	  case 1:
	    oldV = objects[h].v2;
	    break;
	  case 2:
	    oldV = objects[h].v3;
	    break;
	}
	oldV[0] = 1.5 * (oldV[0] - v[0]) + v[0];
	oldV[1] = 1.5 * (oldV[1] - v[1]) + v[1];
    }
}

static void Draw(void)
{

    glPushMatrix();

    glViewport(0, 0, windW, windH);
    glGetIntegerv(GL_VIEWPORT, vp);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-175, 175, -175, 175);
    glMatrixMode(GL_MODELVIEW);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glScalef(zoom, zoom, zoom);
    glRotatef(zRotation, 0, 0, 1);

    Render(GL_RENDER);

    glPopMatrix();

    glFlush();
}

static void DrawZoom(GLint x, GLint y)
{

    glPushMatrix();

    glViewport(0, 0, windW, windH);
    glGetIntegerv(GL_VIEWPORT, vp);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPickMatrix(x, windH-y, 4, 4, vp);
    gluOrtho2D(-175, 175, -175, 175);
    glMatrixMode(GL_MODELVIEW);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glScalef(zoom, zoom, zoom);
    glRotatef(zRotation, 0, 0, 1);

    Render(GL_RENDER);

    glPopMatrix();
}

static void DumpFeedbackVert(GLint *i, GLint n)
{
    GLint index;

    index = *i;
    if (index+7 > n) {
	*i = n;
	printf("  ???\n");
	return;
    }
    printf("  (%g %g %g), color = (%4.2f %4.2f %4.2f)\n",
	   feedBuf[index],
	   feedBuf[index+1],
	   feedBuf[index+2],
	   feedBuf[index+3],
	   feedBuf[index+4],
	   feedBuf[index+5]);
    index += 7;
    *i = index;
}

static void DrawFeedback(GLint n)
{
    GLint i;
    GLint verts;

    printf("Feedback results (%d floats):\n", n);
    for (i = 0; i < n; i++) {
	switch ((GLint)feedBuf[i]) {
	  case GL_POLYGON_TOKEN:
	    printf("Polygon");
	    i++;
	    if (i < n) {
		verts = (GLint)feedBuf[i];
		i++;
		printf(": %d vertices", verts);
	    } else {
		verts = 0;
	    }
	    printf("\n");
	    while (verts) {
		DumpFeedbackVert(&i, n);
		verts--;
	    }
	    i--;
	    break;
	  case GL_LINE_TOKEN:
	    printf("Line:\n");
	    i++;
	    DumpFeedbackVert(&i, n);
	    DumpFeedbackVert(&i, n);
	    i--;
	    break;
	  case GL_LINE_RESET_TOKEN:
	    printf("Line Reset:\n");
	    i++;
	    DumpFeedbackVert(&i, n);
	    DumpFeedbackVert(&i, n);
	    i--;
	    break;
	  default:
	    printf("%9.2f\n", feedBuf[i]);
	    break;
	}
    }
    if (i == MAXFEED) {
	printf("...\n");
    }
    printf("\n");
}

static void DoFeedback(void) 
{
    GLint x;

    glFeedbackBuffer(MAXFEED, GL_3D_COLOR, feedBuf);
    (void)glRenderMode(GL_FEEDBACK);

    glPushMatrix();

    glViewport(0, 0, windW, windH);
    glGetIntegerv(GL_VIEWPORT, vp);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-175, 175, -175, 175);
    glMatrixMode(GL_MODELVIEW);

    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glScalef(zoom, zoom, zoom);
    glRotatef(zRotation, 0, 0, 1);

    Render(GL_FEEDBACK);

    glPopMatrix();
    
    x = glRenderMode(GL_RENDER); 
    if (x == -1) {
	x = MAXFEED;
    }

    DrawFeedback((GLint)x);
}

static GLenum Args(int argc, char **argv)
{
    GLint i;

    directRender = GL_TRUE;

    for (i = 1; i < argc; i++) {
	if (strcmp(argv[i], "-dr") == 0) {
	    directRender = GL_TRUE;
	} else if (strcmp(argv[i], "-ir") == 0) {
	    directRender = GL_FALSE;
	} else {
	    printf("%s (Bad option).\n", argv[i]);
	    return GL_FALSE;
	}
    }
    return GL_TRUE;
}

int 					gl_width=300,gl_height=300;

const 	ulong 			APP_SIGNATURE = '????';
const 	ulong			MSG_REDRAW = 1;

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
	
	void MouseDown(BPoint pos)
	{
	    GLint hit;
		ulong button;

		Window()->Lock();
		GetMouse(&pos,&button);
		Window()->Unlock();

	    hit = DoSelect((GLint)pos.x, (GLint)pos.y);
   	 	if (hit != -1) 
		{
			if (button & B_PRIMARY_MOUSE_BUTTON) 
			{
	    		RecolorTri(hit);
			}
			if (button & B_SECONDARY_MOUSE_BUTTON) 
			{
	    		GrowTri(hit);
			}
			if (button & B_TERTIARY_MOUSE_BUTTON) 
			{
	    		DeleteTri(hit);
			}
    	}
 	};
	
	void KeyDown(ulong aKey)
	{
		switch(aKey)
		{
			BPoint pos;
			ulong buttons;

			case 	B_LEFT_ARROW:
					zRotation += 0.5;
					break;
      		case 	B_RIGHT_ARROW:
					zRotation -= 0.5;
					break;
      		case 	'Z':
					zoom /= 0.75;
					break;
      		case 	'z':
					zoom *= 0.75;
					break;
      		case 	'f':
					DoFeedback();
					break;
      		case	'd':
					GetMouse(&pos,&buttons);
					DrawZoom((GLint)pos.x, (GLint)pos.y);
					break;
      		case 	'l':
					linePoly = (GLenum)!linePoly;
					if (linePoly) 
					{
	    				glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
					} 
					else 
					{
	    				glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
					}
					break;
		}
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
		the_view->MakeFocus();
		Unlock();
	};
	
	void MessageReceived(BMessage *msg)
	{
		switch(msg->what)
		{	
			case	MSG_REDRAW:
					Lock();
					the_view->DrawBitmap(the_bitmap,BPoint(0,0));
					Draw();
					Unlock();
					PostMessage(MSG_REDRAW);
					break;
			default:
					BWindow::MessageReceived(msg);
					break;
		}
	};
	
	bool QuitRequested(void)
	{
		be_app->PostMessage(B_QUIT_REQUESTED);
		return TRUE;
	};
};

class MesaApp : public BApplication 
{
	OSMesaContext ctx;
	
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

		unsigned char *buffer;
		double start,end;

		// Create an RGBA-mode context 
		ctx = OSMesaCreateContext( GL_RGBA, NULL );

		// Bind the buffer to the context and make it current */
		OSMesaMakeCurrent( ctx, bits, GL_UNSIGNED_BYTE, gl_width, gl_height );
		OSMesaPixelStore( OSMESA_Y_UP, 0 );

    	Init();
    	Reshape(gl_width,gl_height);
		the_window->PostMessage(MSG_REDRAW);	
	};

	bool QuitRequested(void)
	{
		// Make sure that the window closes first
		if (BApplication::QuitRequested()) 
		{
			OSMesaDestroyContext( ctx );
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

	Args(argc,argv);

	the_app = new MesaApp();
	the_app->Run();
	delete the_app;

	return 0;
}
