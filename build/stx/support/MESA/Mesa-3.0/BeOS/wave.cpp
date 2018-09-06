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

#ifndef PI
#define PI 3.14159265358979323846
#endif

#define GETCOORD(frame, x, y) (&(theMesh.coords[frame*theMesh.numCoords+(x)+(y)*(theMesh.widthX+1)]))
#define GETFACET(frame, x, y) (&(theMesh.facets[frame*theMesh.numFacets+(x)+(y)*theMesh.widthX]))

GLenum rgb, doubleBuffer, directRender;

GLint colorIndexes1[3];
GLint colorIndexes2[3];
GLenum clearMask = (GLenum)(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

GLenum smooth = GL_FALSE;
GLenum lighting = GL_TRUE;
GLenum depth = GL_TRUE;
GLenum stepMode = GL_FALSE;
GLenum spinMode = GL_FALSE;
GLint contouring = 0;

GLint widthX, widthY;
GLint checkerSize;
float height;

GLint frames, curFrame = 0, nextFrame = 0;

struct facet {
    float color[3];
    float normal[3];
};
struct coord {
    float vertex[3];
    float normal[3];
};
struct mesh {
    GLint widthX, widthY;
    GLint numFacets;
    GLint numCoords;
    GLint frames;
    struct coord *coords;
    struct facet *facets;
} theMesh;

GLubyte contourTexture1[] = {
    255, 255, 255, 255,
    255, 255, 255, 255,
    255, 255, 255, 255,
    127, 127, 127, 127,
};
GLubyte contourTexture2[] = {
    255, 255, 255, 255,
    255, 127, 127, 127,
    255, 127, 127, 127,
    255, 127, 127, 127,
};


static void Animate(void)
{
    struct coord *coord;
    struct facet *facet;
    float *lastColor;
    float *thisColor;
    GLint i, j;

    glClear(clearMask);

    if (nextFrame || !stepMode) {
	curFrame++;
    }
    if (curFrame >= theMesh.frames) {
	curFrame = 0;
    }

    if ((nextFrame || !stepMode) && spinMode) {
	glRotatef(5.0, 0.0, 0.0, 1.0);
    }
    nextFrame = 0;

    for (i = 0; i < theMesh.widthX; i++) {
	glBegin(GL_QUAD_STRIP);
	lastColor = NULL;
	for (j = 0; j < theMesh.widthY; j++) {
	    facet = GETFACET(curFrame, i, j);
	    if (!smooth && lighting) {
		glNormal3fv(facet->normal);
	    }
	    if (lighting) {
		if (rgb) {
		    thisColor = facet->color;
		    glColor3fv(facet->color);
		} else {
		    thisColor = facet->color;
		    glMaterialfv(GL_FRONT_AND_BACK, GL_COLOR_INDEXES, 
				 facet->color);
		}
	    } else {
		if (rgb) {
		    thisColor = facet->color;
		    glColor3fv(facet->color);
		} else {
		    thisColor = facet->color;
		    glIndexf(facet->color[1]);
		}
	    }

	    if (!lastColor || (thisColor[0] != lastColor[0] && smooth)) {
		if (lastColor) {
		    glEnd();
		    glBegin(GL_QUAD_STRIP);
		}
		coord = GETCOORD(curFrame, i, j);
		if (smooth && lighting) {
		    glNormal3fv(coord->normal);
		}
		glVertex3fv(coord->vertex);

		coord = GETCOORD(curFrame, i+1, j);
		if (smooth && lighting) {
		    glNormal3fv(coord->normal);
		}
		glVertex3fv(coord->vertex);
	    }

	    coord = GETCOORD(curFrame, i, j+1);
	    if (smooth && lighting) {
		glNormal3fv(coord->normal);
	    }
	    glVertex3fv(coord->vertex);

	    coord = GETCOORD(curFrame, i+1, j+1);
	    if (smooth && lighting) {
		glNormal3fv(coord->normal);
	    }
	    glVertex3fv(coord->vertex);

	    lastColor = thisColor;
	}
	glEnd();
    }

    glFlush();
}

static void InitMesh(void)
{
    struct coord *coord;
    struct facet *facet;
    float dp1[3], dp2[3];
    float *pt1, *pt2, *pt3;
    float angle, d, x, y;
    GLint numFacets, numCoords, frameNum, i, j;

    theMesh.widthX = widthX;
    theMesh.widthY = widthY;
    theMesh.frames = frames;

    numFacets = widthX * widthY;
    numCoords = (widthX + 1) * (widthY + 1);

    theMesh.numCoords = numCoords;
    theMesh.numFacets = numFacets;

    theMesh.coords = (struct coord *)malloc(frames*numCoords*
					    sizeof(struct coord));
    theMesh.facets = (struct facet *)malloc(frames*numFacets*
					    sizeof(struct facet));

    for (frameNum = 0; frameNum < frames; frameNum++) {
	for (i = 0; i <= widthX; i++) {
	    x = i / (float)widthX;
	    for (j = 0; j <= widthY; j++) {
		y = j / (float)widthY;

		d = sqrt(x*x+y*y);
		if (d == 0.0) {
		    d = 0.0001;
		}
		angle = 2 * PI * d + (2 * PI / frames * frameNum);

		coord = GETCOORD(frameNum, i, j);

		coord->vertex[0] = x - 0.5;
		coord->vertex[1] = y - 0.5;
		coord->vertex[2] = (height - height * d) * cos(angle);

		coord->normal[0] = -(height / d) * x * ((1 - d) * 2 * PI *
				   sin(angle) + cos(angle));
		coord->normal[1] = -(height / d) * y * ((1 - d) * 2 * PI *
				   sin(angle) + cos(angle));
		coord->normal[2] = -1;

		d = 1.0 / sqrt(coord->normal[0]*coord->normal[0]+
			       coord->normal[1]*coord->normal[1]+1);
		coord->normal[0] *= d;
		coord->normal[1] *= d;
		coord->normal[2] *= d;
	    }
	}
	for (i = 0; i < widthX; i++) {
	    for (j = 0; j < widthY; j++) {
		facet = GETFACET(frameNum, i, j);
		if (((i/checkerSize)%2)^(j/checkerSize)%2) {
		    if (rgb) {
			facet->color[0] = 1.0;
			facet->color[1] = 0.2;
			facet->color[2] = 0.2;
		    } else {
			facet->color[0] = colorIndexes1[0];
			facet->color[1] = colorIndexes1[1];
			facet->color[2] = colorIndexes1[2];
		    }
		} else {
		    if (rgb) {
			facet->color[0] = 0.2;
			facet->color[1] = 1.0;
			facet->color[2] = 0.2;
		    } else {
			facet->color[0] = colorIndexes2[0];
			facet->color[1] = colorIndexes2[1];
			facet->color[2] = colorIndexes2[2];
		    }
		}
		pt1 = GETCOORD(frameNum, i, j)->vertex;
		pt2 = GETCOORD(frameNum, i, j+1)->vertex;
		pt3 = GETCOORD(frameNum, i+1, j+1)->vertex;

		dp1[0] = pt2[0] - pt1[0];
		dp1[1] = pt2[1] - pt1[1];
		dp1[2] = pt2[2] - pt1[2];

		dp2[0] = pt3[0] - pt2[0];
		dp2[1] = pt3[1] - pt2[1];
		dp2[2] = pt3[2] - pt2[2];

		facet->normal[0] = dp1[1] * dp2[2] - dp1[2] * dp2[1];
		facet->normal[1] = dp1[2] * dp2[0] - dp1[0] * dp2[2];
		facet->normal[2] = dp1[0] * dp2[1] - dp1[1] * dp2[0];

		d = 1.0 / sqrt(facet->normal[0]*facet->normal[0]+
			       facet->normal[1]*facet->normal[1]+
			       facet->normal[2]*facet->normal[2]);

		facet->normal[0] *= d;
		facet->normal[1] *= d;
		facet->normal[2] *= d;
	    }
	}
    }
}

static void InitMaterials(void)
{
    static float ambient[] = {0.1, 0.1, 0.1, 1.0};
    static float diffuse[] = {0.5, 1.0, 1.0, 1.0};
    static float position[] = {90.0, 90.0, 150.0, 0.0};
    static float front_mat_shininess[] = {60.0};
    static float front_mat_specular[] = {0.2, 0.2, 0.2, 1.0};
    static float front_mat_diffuse[] = {0.5, 0.28, 0.38, 1.0};
    static float back_mat_shininess[] = {60.0};
    static float back_mat_specular[] = {0.5, 0.5, 0.2, 1.0};
    static float back_mat_diffuse[] = {1.0, 1.0, 0.2, 1.0};
    static float lmodel_ambient[] = {1.0, 1.0, 1.0, 1.0};
    static float lmodel_twoside[] = {GL_TRUE};

    glMatrixMode(GL_PROJECTION);
    gluPerspective(90.0, 1.0, 0.5, 10.0);

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glLightfv(GL_LIGHT0, GL_POSITION, position);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);
    glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE, lmodel_twoside);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    
    glMaterialfv(GL_FRONT, GL_SHININESS, front_mat_shininess);
    glMaterialfv(GL_FRONT, GL_SPECULAR, front_mat_specular);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, front_mat_diffuse);
    glMaterialfv(GL_BACK, GL_SHININESS, back_mat_shininess);
    glMaterialfv(GL_BACK, GL_SPECULAR, back_mat_specular);
    glMaterialfv(GL_BACK, GL_DIFFUSE, back_mat_diffuse);

	glColorMaterial(GL_FRONT_AND_BACK, GL_DIFFUSE);
	glEnable(GL_COLOR_MATERIAL);
}

static void InitTexture(void)
{
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
}

static void Init(void)
{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glShadeModel(GL_FLAT);
    glFrontFace(GL_CW);
    glEnable(GL_DEPTH_TEST);

    InitMaterials();
    InitTexture();
    InitMesh();

    glMatrixMode(GL_MODELVIEW);
    glTranslatef(0.0, 0.4, -1.8);
    glScalef(2.0, 2.0, 2.0);
    glRotatef(-35.0, 1.0, 0.0, 0.0);
    glRotatef(35.0, 0.0, 0.0, 1.0);
}

static void Reshape(int width, int height)
{
    glViewport(0, 0, (GLint)width, (GLint)height);
}

static GLenum Args(int argc, char **argv)
{
    GLint i;

    rgb = GL_TRUE;
    doubleBuffer = GL_FALSE;
    directRender = GL_TRUE;
    frames = 10;
    widthX = 10;
    widthY = 10;
    checkerSize = 2;
    height = 0.2;

    for (i = 1; i < argc; i++) {
	if (strcmp(argv[i], "-ci") == 0) {
	    rgb = GL_FALSE;
	} else if (strcmp(argv[i], "-rgb") == 0) {
	    rgb = GL_TRUE;
	} else if (strcmp(argv[i], "-sb") == 0) {
	    doubleBuffer = GL_FALSE;
	} else if (strcmp(argv[i], "-db") == 0) {
	    doubleBuffer = GL_TRUE;
	} else if (strcmp(argv[i], "-dr") == 0) {
	    directRender = GL_TRUE;
	} else if (strcmp(argv[i], "-ir") == 0) {
	    directRender = GL_FALSE;
	} else if (strcmp(argv[i], "-grid") == 0) {
	    if (i+2 >= argc || argv[i+1][0] == '-' || argv[i+2][0] == '-') {
		printf("-grid (No numbers).\n");
		return GL_FALSE;
	    } else {
		widthX = atoi(argv[++i]);
		widthY = atoi(argv[++i]);
	    }
	} else if (strcmp(argv[i], "-size") == 0) {
	    if (i+1 >= argc || argv[i+1][0] == '-') {
		printf("-checker (No number).\n");
		return GL_FALSE;
	    } else {
		checkerSize = atoi(argv[++i]);
	    }
	} else if (strcmp(argv[i], "-wave") == 0) {
	    if (i+1 >= argc || argv[i+1][0] == '-') {
		printf("-wave (No number).\n");
		return GL_FALSE;
	    } else {
		height = atof(argv[++i]);
	    }
	} else if (strcmp(argv[i], "-frames") == 0) {
	    if (i+1 >= argc || argv[i+1][0] == '-') {
		printf("-frames (No number).\n");
		return GL_FALSE;
	    } else {
		frames = atoi(argv[++i]);
	    }
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
	
	void KeyDown(ulong aKey)
	{
		switch(aKey)
		{
			case	'c':
			case	'C':
					contouring++;
					if (contouring == 1) 
					{
					    static GLfloat map[4] = {0, 0, 20, 0};

					    glTexImage2D(GL_TEXTURE_2D, 0, 3, 4, 4, 0, GL_LUMINANCE,
							 GL_UNSIGNED_BYTE, (GLvoid *)contourTexture1);
	    				glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
	    				glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
	    				glTexGenfv(GL_S, GL_OBJECT_PLANE, map);
	    				glTexGenfv(GL_T, GL_OBJECT_PLANE, map);
	    				glEnable(GL_TEXTURE_2D);
	    				glEnable(GL_TEXTURE_GEN_S);
	    				glEnable(GL_TEXTURE_GEN_T);
					}
					else if (contouring == 2) 
					{
	    				static GLfloat map[4] = {0, 0, 20, 0};

	    				glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR);
	    				glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR);
	    				glPushMatrix();
	    				glMatrixMode(GL_MODELVIEW);
	    				glLoadIdentity();
	    				glTexGenfv(GL_S, GL_EYE_PLANE, map);
	    				glTexGenfv(GL_T, GL_EYE_PLANE, map);
	    				glPopMatrix();
					}
					else 
					{
	    				contouring = 0;
	    				glDisable(GL_TEXTURE_GEN_S);
	    				glDisable(GL_TEXTURE_GEN_T);
	    				glDisable(GL_TEXTURE_2D);
					}
					break;
			case	's':
			case	'S':			
					smooth = (GLenum)(!smooth);
					if (smooth) 
					{
	    				glShadeModel(GL_SMOOTH);
					} 
					else 
					{
	    				glShadeModel(GL_FLAT);
					}
					break;
			case	'l':
			case	'L':
					lighting = (GLenum)(!lighting);
					if (lighting) 
					{
	    				glEnable(GL_LIGHTING);
	    				glEnable(GL_LIGHT0);
						glEnable(GL_COLOR_MATERIAL);
					} 
					else 
					{
	    				glDisable(GL_LIGHTING);
	    				glDisable(GL_LIGHT0);
						glDisable(GL_COLOR_MATERIAL);
					}
					break;
			case	'd':
			case	'D':
					depth = (GLenum)(!depth);
					if (depth) 
					{
	    				glEnable(GL_DEPTH_TEST);
	    				clearMask = (GLenum)(clearMask|GL_DEPTH_BUFFER_BIT);
					} 
					else 
					{
	    				glDisable(GL_DEPTH_TEST);
	    				clearMask = (GLenum)(clearMask&(~GL_DEPTH_BUFFER_BIT));
					}
					break;
			case	'a':
			case	'A':
					spinMode = (GLenum)(!spinMode);
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
					Animate();
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
