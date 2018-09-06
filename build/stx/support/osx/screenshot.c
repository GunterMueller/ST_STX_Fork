//
// usage: screenshot file.png [<fmt> [<left> <top> <width> <height>]]
//
#import <ApplicationServices/ApplicationServices.h>
// #include <ApplicationServices/ApplicationServices.h>

static void
usage(char** argv) {
    fprintf(stderr, "usage: %s <file> [<fmt> [<left> <top> <width> <height>]]\n", argv[0]);
    fprintf(stderr, "  where <fmt> is one of 'jpg', 'png' or 'tiff' (default is png)\n");
    fprintf(stderr, "  if the optional coordinates are missing, a full screen hardcopy is made\n");
    exit(1);
}

int main( int argc, char** argv) {
    char *fn = argv[1];
    CFStringRef type = CFSTR("public.png");
    int left=-1, top=-1, width=-1, height=-1;
    CGRect rect = CGRectInfinite;

    if (argc < 2) usage(argv);
    fn = argv[1];
    if (argc > 2) {
	if (strcmp(argv[2], "png") == 0) {
	    // type = CFSTR("public.png");
	} else {
	    if (strcmp(argv[2], "jpg") == 0) {
		type = CFSTR("public.jpeg");
	    } else {
		if (strcmp(argv[2], "tiff") == 0) {
		    type = CFSTR("public.tiff");
		} else {
		    usage(argv);
		}
	    }
	}
	if (argc > 3) {
	    if (argc != (3+4)) {
		usage(argv);
	    }
	    if (sscanf(argv[3], "%d", &left) != 1) usage(argv);
	    if (sscanf(argv[4], "%d", &top) != 1) usage(argv);
	    if (sscanf(argv[5], "%d", &width) != 1) usage(argv);
	    if (sscanf(argv[6], "%d", &height) != 1) usage(argv);
	}
    }

    if (left != -1) {
	rect = CGRectMake((CGFloat)left, (CGFloat)top, (CGFloat)width, (CGFloat)height);
    }

    CGImageRef screenShot =
		CGWindowListCreateImage( rect,
					 kCGWindowListOptionOnScreenOnly,
					 kCGNullWindowID,
					 kCGWindowImageDefault);

    CFStringRef file = CFStringCreateWithCString(NULL, fn, kCFStringEncodingMacRoman);

    CFURLRef urlRef = CFURLCreateWithFileSystemPath( kCFAllocatorDefault, file, kCFURLPOSIXPathStyle, false );
    CGImageDestinationRef idst = CGImageDestinationCreateWithURL( urlRef, type, 1, NULL );
    CGImageDestinationAddImage( idst, screenShot, NULL );
    CGImageDestinationFinalize( idst );
}
