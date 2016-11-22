/*
 * Created by Ravi Vooda on 11/21/16 11:16 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 11:16 PM
 */

package utils.com.contactcard.utils;

import utils.com.contactcard.models.CCCard;

/**
 * Created by rvooda on 11/21/16.
 */

public class Data {
    public static abstract class RequestCallbackListener {
        public abstract void onRequestComplete();
        public abstract void onRequestFailed();
    }

    private static void apiGETRequest(String url, RequestCallbackListener callbackListener){
        callbackListener.onRequestComplete();
    }

    private static int lastID = 1;

    public static void addCard(CCCard ccCard, RequestCallbackListener callbackListener){
        ccCard.id = "" + lastID;
        lastID++;
        apiGETRequest("", callbackListener);
    }
}
