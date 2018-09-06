package stx.libjava.tests.mocks;


@EnumValueAnnotation(Weather.SUNNY)
@ArrayValueAnnotation(whatILikeInSTX = {"SVN", "SVN.. Really :)"})
@PrimitiveValueAnnotation(ratio = 5.5, size = 5, value = "Hello world")
@ClassValueAnnotation(myFavouriteJavaLangClass = java.lang.ArrayIndexOutOfBoundsException.class)
@stx.libjava.annotation.Package("stx:libjava/tests")
public class HeavilyAnnotatedClass {

    @EnumValueAnnotation()
    @ArrayValueAnnotation(whatILikeInSTX = {})
    @PrimitiveValueAnnotation(ratio = 0, size = 0, value = "")
    public HeavilyAnnotatedClass(@EnumValueAnnotation(Weather.SUNNY) String heavilyAnnotatedField) {
        this.heavilyAnnotatedField = heavilyAnnotatedField;
    }

    public HeavilyAnnotatedClass() {
    }

    @EnumValueAnnotation(Weather.CLOUDY)
    @ArrayValueAnnotation(whatILikeInSTX = "Changeset")
    @PrimitiveValueAnnotation(ratio = 5.5, size = 5, value = "Hello world")
    @ClassValueAnnotation(myFavouriteJavaLangClass = java.lang.String.class)
    public String heavilyAnnotatedField;


    @EnumValueAnnotation()
    @ArrayValueAnnotation(whatILikeInSTX = {})
    @PrimitiveValueAnnotation(ratio = 0, size = 0, value = "")
    @ClassValueAnnotation(myFavouriteJavaLangClass = java.lang.instrument.Instrumentation.class)
    public void heavilyAnnotatedMethod(@EnumValueAnnotation(Weather.SUNNY) String howAboutWeather) {
        heavilyAnnotatedField = "Annotation madness spreading..";
        heavilyAnnotatedField += "And that weather.. " + howAboutWeather;
        System.out.println(heavilyAnnotatedField);
    }

}
