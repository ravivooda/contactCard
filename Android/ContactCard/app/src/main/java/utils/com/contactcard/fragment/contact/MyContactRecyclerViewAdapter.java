package utils.com.contactcard.fragment.contact;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.List;

import utils.com.contactcard.R;
import utils.com.contactcard.models.CCContact;
import utils.com.contactcard.utils.Listeners.OnListFragmentInteractionListener;
import utils.com.contactcard.models.CCCard;

/**
 * {@link RecyclerView.Adapter} that can display a {@link CCCard} and makes a call to the
 * specified {@link OnListFragmentInteractionListener}.
 * TODO: Replace the implementation with code for your data type.
 */
public class MyContactRecyclerViewAdapter extends RecyclerView.Adapter<MyContactRecyclerViewAdapter.ViewHolder> {

    private final List<CCContact> mValues;
    private final OnListFragmentInteractionListener mListener;

    public MyContactRecyclerViewAdapter(List<CCContact> items, OnListFragmentInteractionListener listener) {
        mValues = items;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.fragment_contact, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        holder.mCard = mValues.get(position);

        holder.mContactNameTextView.setText(holder.mCard.contactName);

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

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    public void clear() {
        mValues.clear();
    }

    public void add(CCContact ccContact) {
        mValues.add(ccContact);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        final RelativeLayout mContactLeftContainer;
        final RelativeLayout mContactRightContainer;
        final TextView mContactNameTextView;
        public CCContact mCard;

        ViewHolder(View view) {
            super(view);
            mView = view;
            mContactLeftContainer = (RelativeLayout) view.findViewById(R.id.contact_left_container);
            mContactRightContainer = (RelativeLayout) view.findViewById(R.id.contact_right_container);
            mContactNameTextView = (TextView) view.findViewById(R.id.contact_name_text_view);
        }

        @Override
        public String toString() {
            return super.toString() + " '" + mCard.toString() + "'";
        }
    }
}
