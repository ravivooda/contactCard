/*
 * Created by Ravi Vooda on 11/21/16 11:17 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 11:17 PM
 */

package utils.com.contactcard.utils;

import utils.com.contactcard.models.CCCard;
import utils.com.contactcard.models.CCContact;

/**
 * Created by rvooda on 11/18/16.
 */

public class Listeners {

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnListFragmentInteractionListener {
        // TODO: Update argument type and name
        void onListFragmentInteraction(CCCard item);
        void onListFragmentInteraction(CCContact item);
    }
}
