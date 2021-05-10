package kr.co.itsone.route52.fragment;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.google.firebase.crashlytics.FirebaseCrashlytics;

import java.util.ArrayList;
import java.util.List;

import kr.co.itsone.route52.R;
import kr.co.itsone.route52.activity.MainActivity;
import kr.co.itsone.route52.adapter.BillAdapter;
import kr.co.itsone.route52.entity.BillEntity;

public class TableFragment extends Fragment {

    private SwipeRefreshLayout mSwipe;
    private View mView;

    public BillAdapter tableAdapter;
    private RecyclerView listTable;

    public List<BillEntity> mTables = new ArrayList<>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LayoutInflater inflaterView = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mView = inflaterView.inflate(R.layout.fragment_table, null);

        init(mView);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return mView;
    }

    private void init(View v) {
        mSwipe = v.findViewById(R.id.swipe_table);

        listTable = v.findViewById(R.id.list_table);

        listTable.setLayoutManager(new GridLayoutManager(getContext(), 3));

        tableAdapter = new BillAdapter(getActivity(), mTables, new BillAdapter.ItemClickListener() {
            @Override
            public void onSelected(int index) {
                try {
                    String selTable = mTables.get(index).getSlTableNo();

                    if(((MainActivity)getActivity()).mMode == ((MainActivity)getActivity()).MODE_NORMAL) {
                        for(int i = 0; i< ((MainActivity)getActivity()).mSales.size(); i++){
                            if(((MainActivity)getActivity()).mSales.get(i).getSlTableNo().equals(selTable)){
                                ((MainActivity)getActivity()).mSales.get(i).setSelected(true);
                                ((MainActivity)getActivity()).selectedIndex = i;
                            } else{
                                ((MainActivity)getActivity()).mSales.get(i).setSelected(false);
                            }
                        }

                        if(((MainActivity)getActivity()).mSales.get(((MainActivity)getActivity()).selectedIndex).getSlNo().equals("")) {
                            ((MainActivity)getActivity()).btnWriteOrder.setText("주문작성");
                        } else {
                            ((MainActivity)getActivity()).btnWriteOrder.setText("주문내역");
                        }

                        tableAdapter.notifyDataSetChanged();
                    } else if(((MainActivity)getActivity()).mMode == ((MainActivity)getActivity()).MODE_MOVE) {
                        for(int i = 0; i< ((MainActivity)getActivity()).mSales.size(); i++){
                            if(((MainActivity)getActivity()).mSales.get(i).getSlTableNo().equals(selTable)){
                                ((MainActivity)getActivity()).moveTable(i);
                                break;
                            }
                        }
                    } else if(((MainActivity)getActivity()).mMode == ((MainActivity)getActivity()).MODE_MERGE) {
                        for(int i = 0; i< ((MainActivity)getActivity()).mSales.size(); i++){
                            if(((MainActivity)getActivity()).mSales.get(i).getSlTableNo().equals(selTable)){
                                ((MainActivity)getActivity()).mergeTable(i);
                                break;
                            }
                        }
                    }
                } catch (Exception e) {
                    FirebaseCrashlytics.getInstance().recordException(e);
                }
            }

            @Override
            public void onDoubleClicked() {
                ((MainActivity)getActivity()).writeOrder();
            }
        });

        listTable.setAdapter(tableAdapter);

        mSwipe.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                ((MainActivity)getActivity()).selectedIndex = -1;

                ((MainActivity)getActivity()).loadBillList();

                mSwipe.setRefreshing(false);
            }
        });
    }
}
