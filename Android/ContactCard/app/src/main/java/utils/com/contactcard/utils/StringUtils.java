/*
 * Created by Ravi Vooda on 11/22/16 1:23 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/22/16 1:23 PM
 */

package utils.com.contactcard.utils;

import java.util.ArrayList;

/**
 * Created by rvooda on 11/22/16.
 */

public class StringUtils {
    public static <T> String getStringValue(ArrayList<T> values, String separator){
        if (values.size() == 0){
            return "";
        }
        StringBuilder stringBuffer = new StringBuilder();
        for (int i = 0; i < values.size() - 1; i++) {
            stringBuffer.append(values.get(i).toString()).append(separator);
        }
        stringBuffer.append(values.get(values.size() - 1));
        return stringBuffer.toString();
    }

    public static <T> String getStringValue(T object, String defaultValue){
        if (object == null)
            return defaultValue;
        return object.toString();
    }

    public static <T> String getStringValue(T object){
        return getStringValue(object, "");
    }

    public static String getWebsiteType(int i) {
        return "Home";
    }

    public static boolean isEmpty(String string) {
        return string == null || string.trim().length() == 0;
    }
}
