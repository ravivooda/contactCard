/*
 * Created by Ravi Vooda on 11/21/16 5:12 PM
 * Copyright (c) 2016. All rights reserved.
 *
 * Last modified 11/21/16 5:12 PM
 */

package utils.com.contactcard.fragment.card;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import utils.com.contactcard.R;
import utils.com.contactcard.utils.Listeners;
import utils.com.contactcard.models.CCCard;
import utils.com.contactcard.utils.StringUtils;

/**
 * {@link RecyclerView.Adapter} that can display a {@link CCCard} and makes a call to the
 * specified {@link Listeners.OnListFragmentInteractionListener}.
 * TODO: Replace the implementation with code for your data type.
 */
class MyCardRecyclerViewAdapter extends RecyclerView.Adapter<MyCardRecyclerViewAdapter.ViewHolder> {

    private final List<CCCard> mValues;
    private final Listeners.OnListFragmentInteractionListener mListener;

    MyCardRecyclerViewAdapter(List<CCCard> items, Listeners.OnListFragmentInteractionListener listener) {
        mValues = items;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.fragment_card, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        holder.mCard = mValues.get(position);

        // Setting the values
        holder.mCardNameTextView.setText(holder.mCard.name);
        // TODO: Set Image View
        holder.mFullNameTextView.setText(holder.mCard.getFullName());
        holder.mPhoneNumbersTextView.setText(StringUtils.getStringValue(holder.mCard.phoneNumbers, ","));
        holder.mEmailsTextView.setText(StringUtils.getStringValue(holder.mCard.emails, ","));

        holder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != mListener) {
                    // Notify the active callbacks interface (the activity, if the
                    // fragment is attached to one) that an item has been selected.
                    mListener.onListFragmentInteraction(holder.mCard);
                }
            }
        });
    }

    void addCard(CCCard card){
        mValues.add(card);
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        final View mView;
        final TextView mCardNameTextView;
        final ImageView mImageView;
        final TextView mFullNameTextView;
        final TextView mPhoneNumbersTextView;
        final TextView mEmailsTextView;
        CCCard mCard;

        ViewHolder(View view) {
            super(view);
            mView = view;
            mCardNameTextView = (TextView) view.findViewById(R.id.card_name);
            mImageView = (ImageView) view.findViewById(R.id.card_image);
            mFullNameTextView = (TextView) view.findViewById(R.id.card_full_name_value);
            mPhoneNumbersTextView = (TextView) view.findViewById(R.id.card_phone_numbers_value);
            mEmailsTextView = (TextView) view.findViewById(R.id.card_emails_value);
        }

        @Override
        public String toString() {
            return super.toString() + " '" + mCard.toString() + "'";
        }
    }
}
