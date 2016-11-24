/*
 * Created by Ravi Vooda on 11/12/16 10:19 AM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/12/16 10:19 AM
 */

package utils.com.contactcard.models;

import java.util.ArrayList;

import utils.com.contactcard.utils.Data;

/**
 * Helper class for providing sample content for user interfaces created by
 * Android template wizards.
 * <p>
 * TODO: Replace all uses of this class before publishing your app.
 */
public class CCManager {

    /**
     * An array of my cards.
     */
    public static final ArrayList<CCCard> CC_CARDS = new ArrayList<>();

    public static void addItem(final CCCard item, final Data.RequestCallbackListener listener) {
        Data.addCard(item, new Data.RequestCallbackListener() {
            @Override
            public void onRequestComplete() {
                listener.onRequestComplete();
            }

            @Override
            public void onRequestFailed() {
                // TODO: Retry
                listener.onRequestFailed();
            }
        });
    }

    public static void updateItem(CCCard item){

    }
}
