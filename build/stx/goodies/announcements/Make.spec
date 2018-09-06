# $Header: /cvs/stx/stx/goodies/announcements/Make.spec,v 1.2 2015-03-25 14:31:08 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_announcements.
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
MODULE_DIR=goodies/announcements
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
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
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	Announcement \
	AnnouncementClassCollection \
	Announcer \
	Subscription \
	SubscriptionCollection \
	SubscriptionRegistry \
	stx_goodies_announcements \
	StrongSubscription \
	WeakBlockSubscription \
	WeakSubscription \




COMMON_OBJS= \
    $(OUTDIR_SLASH)Announcement.$(O) \
    $(OUTDIR_SLASH)AnnouncementClassCollection.$(O) \
    $(OUTDIR_SLASH)Announcer.$(O) \
    $(OUTDIR_SLASH)Subscription.$(O) \
    $(OUTDIR_SLASH)SubscriptionCollection.$(O) \
    $(OUTDIR_SLASH)SubscriptionRegistry.$(O) \
    $(OUTDIR_SLASH)stx_goodies_announcements.$(O) \
    $(OUTDIR_SLASH)StrongSubscription.$(O) \
    $(OUTDIR_SLASH)WeakBlockSubscription.$(O) \
    $(OUTDIR_SLASH)WeakSubscription.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



