package stx.libjava.tests.mocks;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.CLASS)
public @interface RuntimeInvisibleAnnotation {
	String value() default "hidden";
}
