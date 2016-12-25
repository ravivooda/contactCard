/*
 * Created by Ravi Vooda on 11/12/16 10:19 AM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/12/16 10:19 AM
 */

package utils.com.contactcard.models;

import android.content.ContentProviderOperation;
import android.content.Context;
import android.os.Build;
import android.provider.ContactsContract;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import utils.com.contactcard.utils.Data;
import utils.com.contactcard.utils.StringUtils;

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

    public static void addCard(final CCCard item, final Data.RequestCallbackListener listener) {
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

    public static void addContact(final JSONObject data, Context context) throws Exception {
        String remoteContactID = data.optString("id", "");
        if (StringUtils.isEmpty(remoteContactID)) {
            throw new IllegalArgumentException("Could not find remote ID");
        }

        ArrayList<ContentProviderOperation> ops = new ArrayList<>();

        int contactID = ops.size(); // This seems to be the way to get the contact ID

        // Create a new contact
        ops.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
                .withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, null)
                .withValue(ContactsContract.RawContacts.ACCOUNT_NAME, null)
                .build());

        // Name
        ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
                .withValue(ContactsContract.CommonDataKinds.StructuredName.PREFIX, data.optString("prefix"))
                .withValue(ContactsContract.CommonDataKinds.StructuredName.FAMILY_NAME, data.optString("last_name"))
                .withValue(ContactsContract.CommonDataKinds.StructuredName.GIVEN_NAME, data.optString("first_name"))
                .withValue(ContactsContract.CommonDataKinds.StructuredName.MIDDLE_NAME, data.optString("middle_name"))
                .withValue(ContactsContract.CommonDataKinds.StructuredName.SUFFIX, data.optString("suffix"))
                .build());

        // Photo
        ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE)
                .build());

        // Organization
        ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE)
                .withValue(ContactsContract.CommonDataKinds.Organization.COMPANY, data.optString("company"))
                .withValue(ContactsContract.CommonDataKinds.Organization.DEPARTMENT, data.optString("department"))
                .withValue(ContactsContract.CommonDataKinds.Organization.JOB_DESCRIPTION, data.optString("job_title"))
                .build());

        // Notes
        ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE)
                .withValue(ContactsContract.CommonDataKinds.Note.NOTE, "Card ID: " + remoteContactID)
                .build());

        // Mobile Number(s)
        JSONArray phoneNumbers = data.optJSONArray("phone_numbers");
        for (int i = 0; phoneNumbers != null && i < phoneNumbers.length(); i++) {
            JSONObject phoneNumber = phoneNumbers.getJSONObject(i);
            ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
                    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, phoneNumber.optString("number"))
                    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, phoneNumber.optString("label", String.valueOf(ContactsContract.CommonDataKinds.Phone.getTypeLabel(context.getResources(), ContactsContract.CommonDataKinds.Phone.TYPE_HOME, ""))))
                    .build());
        }

        // Email(s)
        JSONArray emails = data.optJSONArray("emails");
        for (int i = 0; emails != null && i < emails.length(); i++) {
            JSONObject email = emails.getJSONObject(i);
            ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
                    .withValue(ContactsContract.CommonDataKinds.Email.ADDRESS, email.optString("email"))
                    .withValue(ContactsContract.CommonDataKinds.Email.TYPE, email.optString("label", String.valueOf(ContactsContract.CommonDataKinds.Email.getTypeLabel(context.getResources(), ContactsContract.CommonDataKinds.Email.TYPE_HOME, ""))))
                    .build());
        }

        // Postal Address
        JSONArray postalAddresses = data.optJSONArray("postal_addresses");
        for (int i = 0; postalAddresses != null && i < postalAddresses.length(); i++) {
            JSONObject postalAddress = postalAddresses.getJSONObject(i);
            ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_ITEM_TYPE)
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.STREET, postalAddress.optString("street"))
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.CITY, postalAddress.optString("city"))
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.REGION, postalAddress.optString("region"))
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE, postalAddress.optString("pincode"))
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY, postalAddress.optString("country"))
                    .withValue(ContactsContract.CommonDataKinds.StructuredPostal.TYPE, postalAddress.optString("label", String.valueOf(ContactsContract.CommonDataKinds.StructuredPostal.getTypeLabel(context.getResources(), ContactsContract.CommonDataKinds.StructuredPostal.TYPE_HOME, ""))))
                    .build());
        }

        // URL Addresses
        JSONArray urlAddresses = data.optJSONArray("url_addresses");
        for (int i = 0; urlAddresses != null && i < urlAddresses.length(); i++) {
            JSONObject urlAddress = urlAddresses.getJSONObject(i);
            ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Website.CONTENT_ITEM_TYPE)
                    .withValue(ContactsContract.CommonDataKinds.Website.URL, urlAddress.optString("url"))
                    .withValue(ContactsContract.CommonDataKinds.Website.TYPE, urlAddress.optString("label", "Home"))
                    .build());
        }

        // TODO: Complete Social Profiles

        // Events Details
        JSONArray events = data.optJSONArray("url_addresses");
        for (int i = 0; events != null && i < events.length(); i++) {
            JSONObject event = events.getJSONObject(i);
            String defaultValue = "Other";
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                defaultValue = String.valueOf(ContactsContract.CommonDataKinds.Event.getTypeLabel(context.getResources(), ContactsContract.CommonDataKinds.Event.TYPE_OTHER, ""));
            }
            ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
                    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, contactID)
                    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE)
                    .withValue(ContactsContract.CommonDataKinds.Event.START_DATE, event.optString("date"))
                    .withValue(ContactsContract.CommonDataKinds.Event.TYPE, event.optString("label", defaultValue))
                    .build());
        }

        context.getContentResolver().applyBatch(ContactsContract.AUTHORITY, ops);
        Log.d("CCManager", "Successfully added new contact with name: " + "first_name");
    }
}
