package stx.libjava.tests.mocks;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface ClassValueAnnotation {
	Class myFavouriteJavaLangClass();
}
