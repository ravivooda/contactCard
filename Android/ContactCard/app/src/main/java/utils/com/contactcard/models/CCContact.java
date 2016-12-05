/*
 * Created by Ravi Vooda on 11/24/16 5:07 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/24/16 5:07 PM
 */

package utils.com.contactcard.models;

import android.content.Context;
import android.database.Cursor;
import android.provider.ContactsContract;
import android.util.Log;

import static android.provider.BaseColumns._ID;
import static android.provider.ContactsContract.Data.DISPLAY_NAME;
import static android.provider.ContactsContract.Data.LOOKUP_KEY;
import static android.provider.ContactsContract.Data.MIMETYPE;

/**
 * Created by rvooda on 11/24/16.
 */

public class CCContact {
    public final String localContactUri;

    public final String contactName;

    private final String remoteCardID;
    private final String localContactID;

    public CCContact(Context context, Cursor data) {
        this.localContactUri = data.getString(data.getColumnIndex(LOOKUP_KEY));
        this.contactName = data.getString(data.getColumnIndex(DISPLAY_NAME));
        this.localContactID = data.getString(data.getColumnIndex(_ID));

        // Fetching notes
        String notesWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + MIMETYPE + " = ?";
        String[] notesWhereParams = new String[]{localContactID, ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE};
        Cursor notesCurr= context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, notesWhere, notesWhereParams, null);
        String notes = "";
        if (notesCurr != null && notesCurr.moveToFirst()) {
            notes = notesCurr.getString(notesCurr.getColumnIndex(ContactsContract.CommonDataKinds.Note.NOTE));
            notesCurr.close();
        }

        String remoteCardID = "";
        for (String notesString : notes.split("\n")) {
            if (notesString.contains("Card ID:")) {
                remoteCardID= notesString.substring(9);
                break;
            }
        }

        this.remoteCardID = remoteCardID;

        Log.d("CCContactFragment", "Remote Card ID: " + this.remoteCardID);
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
