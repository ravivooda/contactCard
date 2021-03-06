/*
 * Created by Ravi Vooda on 11/21/16 10:54 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 10:54 PM
 */

package utils.com.contactcard.models;

import android.annotation.SuppressLint;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import static android.provider.ContactsContract.Contacts._ID;
import static android.provider.ContactsContract.Data.MIMETYPE;
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
            this.street = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.STREET));
            this.city = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.CITY));
            this.state = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.REGION));
            this.postalCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE));
            if (!StringUtils.isEmpty(this.postalCode)) {
                this.postalCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POBOX));
            }
            this.country = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY));
            this.ISOCountryCode = data.getString(data.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY));
        }

        @Override
        public String toString() {
            return spaceAppendedString(street) +
                    spaceAppendedString(city) +
                    spaceAppendedString(state) +
                    spaceAppendedString(postalCode) +
                    spaceAppendedString(country);
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

    private static String spaceAppendedString(String string) {
        return string != null && string.trim().length() > 0 ? string + " " : "";
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
        Cursor data = context.getContentResolver().query(contactUri, null, null, null, null);
        if (data == null || data.getCount() == 0) {
            throw new IllegalArgumentException("Couldn't find contact with Uri: " + contactUri);
        }

        data.moveToFirst();

        this.id = data.getString(data.getColumnIndex(_ID));
        this.contactType = contactType;

        Log.d("CCCard", "ID: " + this.id);

        // Name Details
        String whereName = ContactsContract.Data.MIMETYPE + " = ? AND " + ContactsContract.CommonDataKinds.StructuredName.CONTACT_ID + " = ?";
        String[] whereNameParams = new String[] { ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE, id };
        Cursor nameCursor = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, whereName, whereNameParams, null);
        if (nameCursor != null) {
            if (nameCursor.moveToFirst()) {
                this.prefix = getStringValue(nameCursor.getString(nameCursor.getColumnIndex(PREFIX)));
                this.firstName = getStringValue(nameCursor.getString(nameCursor.getColumnIndex(GIVEN_NAME)));
                this.middleName = getStringValue(nameCursor.getString(nameCursor.getColumnIndex(MIDDLE_NAME)));
                this.lastName = getStringValue(nameCursor.getString(nameCursor.getColumnIndex(FAMILY_NAME)));
                this.suffix = getStringValue(nameCursor.getString(nameCursor.getColumnIndex(SUFFIX)));
            }
            nameCursor.close();
        }

        Log.d("CCCard", "Name: " + this.getFullName());

        // Organization Details
        String organizationWhere = ContactsContract.Data.MIMETYPE + " = ? AND " + ContactsContract.CommonDataKinds.Organization.CONTACT_ID + " = ?";
        String[] organizationWhereParams = new String[] { ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE, id };
        Cursor organizationCursor = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, organizationWhere, organizationWhereParams, null);
        if (organizationCursor != null) {
            if (organizationCursor.moveToFirst()) {
                this.organizationName = getStringValue(organizationCursor.getString(organizationCursor.getColumnIndex(COMPANY)));
                this.departmentName = getStringValue(organizationCursor.getString(organizationCursor.getColumnIndex(DEPARTMENT)));
                this.jobTitle = getStringValue(organizationCursor.getString(organizationCursor.getColumnIndex(JOB_DESCRIPTION)));
            }
            organizationCursor.close();
        }

        Log.d("CCCard", "Organization: " + this.organizationName);

        // Image Data
        String photoWhere = ContactsContract.Data.MIMETYPE + " = ? AND " + ContactsContract.CommonDataKinds.Organization.CONTACT_ID + " = ?";
        String[] photoWhereParams = new String[] { ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE, id };
        Cursor imageCursor = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, photoWhere, photoWhereParams, null);
        if (imageCursor != null) {
            if (imageCursor.moveToFirst()) {
                Uri person = ContentUris.withAppendedId(ContactsContract.Contacts.CONTENT_URI, Long.parseLong(id));
                Uri.withAppendedPath(person, ContactsContract.Contacts.Photo.CONTENT_DIRECTORY);
            }
            imageCursor.close();
        }

        // Phone Number Details
        Cursor phoneCursor = context.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?", new String[] { id }, null);
        if (phoneCursor != null) {
            while (phoneCursor.moveToNext()){
                int type = phoneCursor.getInt(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
                String phoneNumberKey = String.valueOf(ContactsContract.CommonDataKinds.Phone.getTypeLabel(context.getResources(), type, "Undefined"));
                String phoneNumberValue = phoneCursor.getString(phoneCursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

                phoneNumbers.add(new LabelledValues<>(phoneNumberKey, phoneNumberValue));
            }
            phoneCursor.close();
        }

        Log.d("CCCard", "Phone Numbers: " + this.phoneNumbers);

        // Email Details
        Cursor emailCur = context.getContentResolver().query(ContactsContract.CommonDataKinds.Email.CONTENT_URI, null, ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?", new String[]{ id }, null);
        if (emailCur != null) {
            while (emailCur.moveToNext()){
                int type = emailCur.getInt(emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                String emailKey = String.valueOf(ContactsContract.CommonDataKinds.Email.getTypeLabel(context.getResources(), type, "Undefined"));
                String emailValue = emailCur.getString(emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));

                emails.add(new LabelledValues<>(emailKey, emailValue));
            }
            emailCur.close();
        }

        Log.d("CCCard", "Emails: " + this.emails);

        // Postal Addresses
        String addressWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + MIMETYPE + " = ?";
        String[] addressWhereParams = new String[]{id, ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_ITEM_TYPE};
        Cursor addressCur = context.getContentResolver().query(ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_URI, null, addressWhere, addressWhereParams, null);
        if (addressCur != null) {
            while (addressCur.moveToNext()){
                int type = addressCur.getInt(addressCur.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.TYPE));
                String addressType = String.valueOf(ContactsContract.CommonDataKinds.StructuredPostal.getTypeLabel(context.getResources(), type, "Undefined"));
                PostalAddress postalAddress = new PostalAddress(addressCur);

                postalAddresses.add(new LabelledValues<>(addressType, postalAddress));
            }
            addressCur.close();
        }

        Log.d("CCCard", "Address: " + this.postalAddresses);

        // URL Addresses
        String websiteWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + MIMETYPE + " = ?";
        String[] websiteWhereParams = new String[]{id, ContactsContract.CommonDataKinds.Website.CONTENT_ITEM_TYPE};
        Cursor websiteCur = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, websiteWhere, websiteWhereParams, null);
        if (websiteCur != null) {
            while (websiteCur.moveToNext()){
                int type = websiteCur.getInt(websiteCur.getColumnIndex(ContactsContract.CommonDataKinds.Website.TYPE));
                String websiteKey = StringUtils.getWebsiteType(type);
                String websiteURL = websiteCur.getString(websiteCur.getColumnIndex(ContactsContract.CommonDataKinds.Website.URL));

                urlAddresses.add(new LabelledValues<>(websiteKey, websiteURL));
            }
            websiteCur.close();
        }

        Log.d("CCCard", "Websites: " + this.urlAddresses);

        // TODO: Complete Social Profiles

        // Events Details
        String eventsWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + MIMETYPE + " = ?";
        String[] eventsWhereParams = new String[]{id, ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE};
        Cursor eventsCur = context.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, eventsWhere, eventsWhereParams, null);
        if (eventsCur != null) {
            while (eventsCur.moveToNext()) {
                int type = eventsCur.getInt(eventsCur.getColumnIndex(ContactsContract.CommonDataKinds.Event.TYPE));
                String eventKey = "";
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                    eventKey = String.valueOf(ContactsContract.CommonDataKinds.Event.getTypeLabel(context.getResources(), type, "Undefined"));
                } else {
                    // eventKey = eventsCur.getString(eventsCur.getColumnIndex(ContactsContract.CommonDataKinds.Event.LABEL));
                    eventKey = type == ContactsContract.CommonDataKinds.Event.TYPE_BIRTHDAY ? "Birthday" : "Other";
                }
                String eventValue = eventsCur.getString(eventsCur.getColumnIndex(ContactsContract.CommonDataKinds.Event.START_DATE));
                @SuppressLint("SimpleDateFormat") SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    Date date = simpleDateFormat.parse(eventValue);
                    otherDates.add(new LabelledValues<>(eventKey, date));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            eventsCur.close();
        }

        Log.d("CCCard", "Events: " + this.otherDates);

        data.close();
    }
}
