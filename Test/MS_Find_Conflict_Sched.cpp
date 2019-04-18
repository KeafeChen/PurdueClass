#include <bits/stdc++.h>
using namespace std;
int N;
string s1, s2;
int M(int ar[], int t[], int l, int m, int r){
    int i=l, j=m, k=l, rst=0;
    while((i<=m-1)&&(j<=r))
        if(ar[i]<=ar[j]) t[k++]=ar[i++]; 
        else{ 
            t[k++]=ar[j++];
            rst+=(m-i); 
        } 
    for(;i<=m-1;t[k++]=ar[i++]);
    for(;j<=r;t[k++]=ar[j++]);
    for(i=l;i<=r;++i) ar[i]=t[i];
    return rst; 
} 
int S(int ar[], int t[], int l, int r){ 
    int m, rst=0; 
    if (r>l) {
        m=(r+l)/2;
        rst=S(ar, t, l, m); 
        rst+=S(ar, t, m+1, r);
        rst+=M(ar, t, l, m+1, r); 
    } 
    return rst; 
}
int run(int ar[], int sz){
    int* t=(int*)malloc(sizeof(int)*sz); 
    return S(ar, t, 0, sz-1); 
}
int main() {
    cin>>N;
    int V1[N], V2[N];
    cin>>s1;
    for(int i=0;i<N;cin>>V1[i++]);
    cin>>s2;
    for(int i=0;i<N;cin>>V2[i++]);
    int i1=run(V1, N), i2=run(V2, N);
    if(i1==i2) cout<<"Accepted!"<<endl;
    else if(i1<i2) cout<<s1<<endl;
    else cout<<s2<<endl;
    return 0;
}
