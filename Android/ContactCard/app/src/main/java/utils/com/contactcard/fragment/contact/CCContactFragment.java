/*
 * Created by Ravi Vooda on 11/12/16 10:19 AM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/12/16 10:19 AM
 */

package utils.com.contactcard.fragment.contact;

import android.app.ProgressDialog;
import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.LoaderManager;
import android.support.v4.content.CursorLoader;
import android.support.v4.content.Loader;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;

import utils.com.contactcard.R;
import utils.com.contactcard.activity.TabbedActivity;
import utils.com.contactcard.models.CCContact;
import utils.com.contactcard.utils.Listeners;

import static android.provider.BaseColumns._ID;
import static android.provider.ContactsContract.Contacts.CONTENT_URI;
import static android.provider.ContactsContract.Data.DISPLAY_NAME;
import static android.provider.ContactsContract.Data.LOOKUP_KEY;

/**
 * A fragment representing a list of Items.
 * <p/>
 * Activities containing this fragment MUST implement the {@link Listeners.OnListFragmentInteractionListener}
 * interface.
 */
public class CCContactFragment extends Fragment implements LoaderManager.LoaderCallbacks<Cursor>{
    private Listeners.OnListFragmentInteractionListener mListener;

    private MyContactRecyclerViewAdapter myContactRecyclerViewAdapter;

    private ProgressDialog progressDialog;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public CCContactFragment() {

    }

    // TODO: Customize parameter initialization
    @SuppressWarnings("unused")
    public static CCContactFragment newInstance(int columnCount) {
        CCContactFragment fragment = new CCContactFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_contact_list, container, false);

        // Set the adapter
        if (view instanceof RecyclerView) {
            Context context = view.getContext();
            RecyclerView recyclerView = (RecyclerView) view;
            recyclerView.setLayoutManager(new LinearLayoutManager(context));
            myContactRecyclerViewAdapter = new MyContactRecyclerViewAdapter(new ArrayList<CCContact>(), mListener);
            recyclerView.setAdapter(myContactRecyclerViewAdapter);
        }

        reloadContacts();
        return view;
    }

    public void reloadContacts(){
        getLoaderManager().initLoader(TabbedActivity.contactAddAction, null, this);
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof Listeners.OnListFragmentInteractionListener) {
            mListener = (Listeners.OnListFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnListFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        String[] projection = {
                _ID,
                LOOKUP_KEY,
                DISPLAY_NAME
        };
        Log.d("CCContactFragment", "onCreateLoader: Creating Loader");

        if (progressDialog != null) {
            progressDialog.dismiss();
            progressDialog = null;
        }

        progressDialog = new ProgressDialog(getActivity());
        progressDialog.setTitle("Loading Contacts");
        progressDialog.show();

        return new CursorLoader(getActivity(), CONTENT_URI, projection, null, null, null);
    }

    @Override
    public void onLoadFinished(Loader<Cursor> loader, Cursor data) {
        if (progressDialog != null) {
            progressDialog.dismiss();
            progressDialog = null;
        }

        myContactRecyclerViewAdapter.clear();

        if (data != null) {
            while (data.moveToNext()) {
                String localLookUpKey = data.getString(data.getColumnIndex(LOOKUP_KEY));
                String contactName = data.getString(data.getColumnIndex(DISPLAY_NAME));
                String contactID = data.getString(data.getColumnIndex(_ID));

                CCContact ccContact = new CCContact(contactID, localLookUpKey, contactName);
                Log.d("CCContactFragment", "New Contact: " + ccContact);

                myContactRecyclerViewAdapter.add(ccContact);
            }
        }
        myContactRecyclerViewAdapter.notifyDataSetChanged();
    }

    @Override
    public void onLoaderReset(Loader<Cursor> loader) {
        if (progressDialog != null) {
            progressDialog.dismiss();
            progressDialog = null;
        }

        new AlertDialog.Builder(getActivity())
                .setTitle("Error occurred in fetching contacts")
                .show();
    }
}
