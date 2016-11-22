/*
 * Created by Ravi Vooda on 11/21/16 10:54 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 10:54 PM
 */

package utils.com.contactcard.models;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.util.Log;

import java.util.ArrayList;
import java.util.Date;

import utils.com.contactcard.utils.StringUtils;

import static android.provider.ContactsContract.CommonDataKinds.Organization.COMPANY;
import static android.provider.ContactsContract.CommonDataKinds.Organization.DEPARTMENT;
import static android.provider.ContactsContract.CommonDataKinds.Organization.JOB_DESCRIPTION;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName.FAMILY_NAME;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName.GIVEN_NAME;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName.MIDDLE_NAME;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName.PREFIX;
import static android.provider.ContactsContract.CommonDataKinds.StructuredName.SUFFIX;
import static android.provider.ContactsContract.Contacts.HAS_PHONE_NUMBER;
import static android.provider.ContactsContract.Contacts._ID;
import static android.provider.ContactsContract.Contacts.Data.*;
import static utils.com.contactcard.utils.StringUtils.getStringValue;

/**
 * Created by rvooda on 11/21/16.
 */

public class CCCard {
    public String id = "";
    public String name = "";

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    // Contact Type
    public enum ContactType {
        Person, Organization
    }

    public ContactType contactType;

    // Name
    public String prefix = "";
    public String firstName = "";
    public String middleName = "";
    public String lastName = "";
    public String suffix = "";

    // Organization
    public String organizationName = "";
    public String departmentName = "";
    public String jobTitle = "";

    // Notes
    public String notes = "";

    // Images
    public String imageData = "";

    // Labelled Values Class
    public static class LabelledValues<T> {
        public String label;
        public T value;

        public LabelledValues (String label, T value) {
            this.label = label;
            this.value = value;
        }

        @Override
        public String toString() {
            return "" + label + ": " + value.toString();
        }
    }

    public static class PostalAddress {
        public String street = "";
        public String city = "";
        public String state = "";
        public String postalCode = "";
        public String country = "";
        public String ISOCountryCode = "";

        public PostalAddress(Cursor data){
            this.postalCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POBOX));
            this.street = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.STREET));
            this.city = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.CITY));
            this.state = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.REGION));
            this.postalCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE));
            this.country = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY));
            this.ISOCountryCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY));
        }
    }

    public static class SocialNetworkingProfile {
        public String urlString = "";
        public String username = "";
        public String userIdentifier = "";
        public String service = "";

        public SocialNetworkingProfile(Cursor data){

        }
    }

    // Labelled Key Values
    public ArrayList<LabelledValues<String>> phoneNumbers = new ArrayList<>();
    public ArrayList<LabelledValues<String>> emails = new ArrayList<>();
    public ArrayList<LabelledValues<PostalAddress>> postalAddresses = new ArrayList<>();
    public ArrayList<LabelledValues<String>> urlAddresses = new ArrayList<>();
    public ArrayList<LabelledValues<SocialNetworkingProfile>> socialProfiles = new ArrayList<>();
    public ArrayList<LabelledValues<Date>> otherDates = new ArrayList<>();

    private String spaceAppendedString(String string) {
        return string.trim().length() > 0 ? string + " " : "";
    }

    public String getFullName(){
        return spaceAppendedString(prefix) +
                spaceAppendedString(firstName) +
                spaceAppendedString(middleName) +
                spaceAppendedString(lastName) +
                suffix.trim();
    }

    @Override
    public String toString() {
        return "Card - Name: " + getFullName() + ", Phone Number: " + phoneNumbers;
    }

    public CCCard(Context context, Uri contactUri, ContactType contactType) throws IllegalArgumentException{

        String[] PROJECTION =
                new String[]{
                        _ID,
                };
        Cursor data = context.getContentResolver().query(contactUri, null, null, null, null);
        if (data == null || data.getCount() == 0) {
            throw new IllegalArgumentException("Couldn't find contact with Uri: " + contactUri);
        }
        Log.d("CCCard", "CCCard: Data: " + data.getExtras().toString());

        this.id = data.getString(data.getColumnIndex(_ID));
        this.contactType = contactType;

        data.moveToFirst();

        // Name Details
        this.prefix = getStringValue(data.getString(data.getColumnIndex(PREFIX)));
        this.firstName = getStringValue(data.getString(data.getColumnIndex(GIVEN_NAME)));
        this.middleName = getStringValue(data.getString(data.getColumnIndex(MIDDLE_NAME)));
        this.lastName = getStringValue(data.getString(data.getColumnIndex(FAMILY_NAME)));
        this.suffix = getStringValue(data.getString(data.getColumnIndex(SUFFIX)));

        // Organization Details
        this.organizationName = getStringValue(data.getString(data.getColumnIndex(COMPANY)));
        this.departmentName = getStringValue(data.getString(data.getColumnIndex(DEPARTMENT)));
        this.jobTitle = getStringValue(data.getString(data.getColumnIndex(JOB_DESCRIPTION)));

        // TODO: Load Notes
        // TODO: Load Image Data

        // Phone Number Details
        if (Integer.parseInt(data.getString(data.getColumnIndex( HAS_PHONE_NUMBER ))) > 0) {
            Cursor phoneCursor = context.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, PROJECTION, ContactsContract.CommonDataKinds.Phone.CONTENT_URI + " = ?", new String[] { this.id }, null);
            if (phoneCursor != null) {
                while (phoneCursor.moveToNext()){
                    int type = phoneCursor.getInt(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
                    String phoneNumberKey = String.valueOf(ContactsContract.CommonDataKinds.Phone.getTypeLabel(context.getResources(), type, "Undefined"));
                    String phoneNumberValue = phoneCursor.getString(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

                    phoneNumbers.add(new LabelledValues<>(phoneNumberKey, phoneNumberValue));
                }
                phoneCursor.close();
            }
        }

        // Email Details
        Cursor emailCur = context.getContentResolver().query(ContactsContract.CommonDataKinds.Email.CONTENT_URI, PROJECTION, ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?", new String[]{id}, null);
        if (emailCur != null) {
            while (emailCur.moveToNext()){
                int type = emailCur.getInt(emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                String emailKey = String.valueOf(ContactsContract.CommonDataKinds.Email.getTypeLabel(context.getResources(), type, "Undefined"));
                String emailValue = emailCur.getString(emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));

                emails.add(new LabelledValues<>(emailKey, emailValue));
            }
            emailCur.close();
        }

        // Postal Addresses
        String addressWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + MIMETYPE + " = ?";
        String[] addressWhereParams = new String[]{id, ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_ITEM_TYPE};
        Cursor addressCur = context.getContentResolver().query(ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_URI, PROJECTION, addressWhere, addressWhereParams, null);
        if (addressCur != null) {
            while (addressCur.moveToNext()){
                int type = data.getInt(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.TYPE));
                String addressType = String.valueOf(ContactsContract.CommonDataKinds.StructuredPostal.getTypeLabel(context.getResources(), type, "Undefined"));
                PostalAddress postalAddress = new PostalAddress(addressCur);

                postalAddresses.add(new LabelledValues<>(addressType, postalAddress));
            }
            addressCur.close();
        }

        // URL Addresses
        Cursor websiteCur = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, PROJECTION, ContactsContract.CommonDataKinds.Website.CONTACT_ID + " = ?", new String[] { id }, null);
        if (websiteCur != null) {
            while (websiteCur.moveToNext()){
                int type = websiteCur.getInt(websiteCur.getColumnIndex(ContactsContract.CommonDataKinds.Website.TYPE));
                String websiteKey = StringUtils.getWebsiteType(type);
                String websiteURL = websiteCur.getString(websiteCur.getColumnIndex(ContactsContract.CommonDataKinds.Website.URL));

                urlAddresses.add(new LabelledValues<>(websiteKey, websiteURL));
            }
            websiteCur.close();
        }

        // TODO: Complete Social Profiles

        // Events Details
        Cursor eventsCur = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, PROJECTION, ContactsContract.CommonDataKinds.Event.CONTACT_ID + " = ?", new String[] { id }, null);
        if (eventsCur != null) {
            while (eventsCur.moveToNext()) {
                int type = eventsCur.getInt(eventsCur.getColumnIndex(ContactsContract.CommonDataKinds.Event.TYPE));
                String eventKey = String.valueOf(ContactsContract.CommonDataKinds.Event.getTypeLabel(context.getResources(), type, "Undefined"));
            }
            eventsCur.close();
        }

        data.close();
    }
}
