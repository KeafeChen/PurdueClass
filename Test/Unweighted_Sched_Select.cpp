#include <bits/stdc++.h>
using namespace std;
#define MAX(a, b) (a>b?a:b)
typedef struct Node{
    string s;
    int st, et, nm;
}Node;
bool CMP(Node n1, Node n2) {return (n1.et<n2.et);}
int main() { 
    int n;
    cin>>n;
    Node *arr=new Node[n];
    for(int i=0;i<n;++i) cin>>arr[i].s>>arr[i].st>>arr[i].et>>arr[i].nm;
    sort(arr, arr+n, CMP);
    vector<int> dp(n);
    vector<vector<int>> lst(n);
    dp[0] = arr[0].nm;
    lst[0].push_back(0);
    for(int i=1;i<n;++i){ 
        int sum=arr[i].nm, l=-1;
        for(int j=i-1;j>=0;--j)
            if(arr[j].et<=arr[i].st){
                l=j;
                break;
            }
        if(l!=-1) sum+=dp[l];
        if(sum>dp[i-1]){
            dp[i]=sum;
            lst[i]=lst[l];
            lst[i].push_back(i);
        }else{
            dp[i]=dp[i-1];
            lst[i]=lst[i-1];
        }
    }
    for(int i=0;i<lst[n-1].size();++i){
        cout<<arr[lst[n-1][i]].s<<endl;
    }
    cout<<dp[n-1];
    return 0;
}
