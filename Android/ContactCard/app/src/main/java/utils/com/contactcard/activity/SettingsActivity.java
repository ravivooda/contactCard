/*
 * Created by Ravi Vooda on 12/6/16 5:42 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 12/6/16 5:42 PM
 */

package utils.com.contactcard.activity;

import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;

import utils.com.contactcard.R;

/**
 * Created by rvooda on 12/6/16.
 */

public class SettingsActivity extends PreferenceActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Display the fragment as the main content
        getFragmentManager().beginTransaction().replace(android.R.id.content, new SettingsFragment()).commit();
    }

    public static class SettingsFragment extends PreferenceFragment {
        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            // Load the preferences from an XML resources
            addPreferencesFromResource(R.xml.preferences);
        }
    }
}
