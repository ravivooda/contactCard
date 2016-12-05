/*
 * Created by Ravi Vooda on 11/24/16 5:07 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/24/16 5:07 PM
 */

package utils.com.contactcard.models;

/**
 * Created by rvooda on 11/24/16.
 */

public class CCContact {
    public final String localContactUri;

    public final String contactName;

    private String remoteCardID = "";
    private final String localContactID;

    public CCContact(String contactID, String localContactUri, String contactName) {
        this.localContactID = contactID;
        this.localContactUri = localContactUri;
        this.contactName = contactName;
    }


    public String getRemoteCardID() {
        return remoteCardID;
    }

    @Override
    public String toString() {
        return "Name: " + contactName + ", With ID: " + localContactUri + "\n";
    }

    public String getLocalContactID() {
        return localContactID;
    }
}
