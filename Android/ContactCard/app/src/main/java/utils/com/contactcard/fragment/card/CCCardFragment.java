/*
 * Created by Ravi Vooda on 11/21/16 5:12 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 5:12 PM
 */

package utils.com.contactcard.fragment.card;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import utils.com.contactcard.R;
import utils.com.contactcard.models.CCCard;
import utils.com.contactcard.models.CCManager;
import utils.com.contactcard.utils.Data;
import utils.com.contactcard.utils.Listeners;

import static utils.com.contactcard.models.CCManager.ITEMS;

public class CCCardFragment extends Fragment {

    private Listeners.OnListFragmentInteractionListener mListener;
    private MyCardRecyclerViewAdapter adapter;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public CCCardFragment() {

    }

    private void log(String text){
        Log.d("CCCardFragment", text);
    }

    public void addContact(Intent data) {
        Uri uri = data.getData();
        try {
            final CCCard card = new CCCard(getActivity(), uri, CCCard.ContactType.Person);

            CCManager.addItem(card, new Data.RequestCallbackListener() {
                @Override
                public void onRequestComplete() {
                    Log.d("CCCardFragment", "Added Card: " + card.getFullName());
                    adapter.addCard(card);
                }

                @Override
                public void onRequestFailed() {

                }
            });

            // Now delete the card
            //getActivity().getContentResolver().delete(uri, null, null);
        } catch (IllegalArgumentException exception) {
            exception.printStackTrace();
            new AlertDialog.Builder(getActivity())
                    .setTitle("No entry")
                    .setMessage("Unable to find the new card")
                    .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            // do nothing
                        }
                    })
                    .setIcon(android.R.drawable.ic_dialog_alert)
                    .show();
        }
    }

    // TODO: Customize parameter initialization
    public static CCCardFragment newInstance(int columnCount) {
        return new CCCardFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_card_list, container, false);

        // Set the adapter
        if (view instanceof RecyclerView) {
            Context context = view.getContext();
            RecyclerView recyclerView = (RecyclerView) view;
            recyclerView.setLayoutManager(new LinearLayoutManager(context));
            adapter = new MyCardRecyclerViewAdapter(ITEMS, mListener);
            recyclerView.setAdapter(adapter);
        }
        return view;
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
}
