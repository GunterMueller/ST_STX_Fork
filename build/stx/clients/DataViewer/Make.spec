# $Header: /cvs/stx/stx/clients/DataViewer/Make.spec,v 1.3 2004-11-23 21:19:23 cg Exp $
#
# -------------- no need to change anything below ----------

MODULE=stx
MODULE_DIR=clients/DataViewer
LIBNAME=libDataViewer
PACKAGE=$(MODULE):$(MODULE_DIR)

#
# local objects
#
OBJS1=   \
	TDVObject.$(O) \
	NormalVectorUtilities.$(O)     \
	TextUtilities.$(O)     \
	AbstractComponent.$(O)     \
	DrawableComponent.$(O)     \
	SeparatorPlane.$(O)     \
	PlaneStandard.$(O)     \
	Data.$(O)     \
	MatrixData.$(O)     \
	LabelForZAxis.$(O) \
	FrameStandard.$(O) \
	DrawWithVertexArray.$(O)  \
	DisplayListUtilities.$(O)  \
	DataRenderer.$(O)         \
	DataRenderer3D.$(O)       \
	AxisStandard.$(O)         \
	ApplicationMatrix3D.$(O)  \
	DataViewer.$(O) \
	DataViewer3D.$(O) \



OBJS2=   DataViewer.$(O)     \
	DataViewer3D.$(O)     \
	IntegerDataGeneration.$(O) \
	AxisStandard.$(O)          \
	MyClient.$(O)              \
	Box.$(O)                   \
	DisplayListManager.$(O)    \
	MyServer.$(O)              \
	ColumnData.$(O)            \
	DrawWithDisplayLists.$(O)  \
	Presentation.$(O)          \
	ColumnDataFunc.$(O)        \
	DrawWithSinglePoints.$(O)  \
	PresentationWrapper.$(O)   \
	ColumnDataViewer3D.$(O)    \
	DrawWithVertexArray.$(O)   \
	SensorText.$(O)            \
	DataMesh.$(O)              \
	FrameStandard.$(O)         \
	DataViewer.$(O)            \
	GridStandard.$(O)

OBJS=   $(OBJS1)
