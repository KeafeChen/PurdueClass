#include <bits/stdc++.h>
#include <unordered_set>
using namespace std;
int main() {
    string rst="", t;
    vector<string> V;
    unordered_set<string> us;
    while(cin>>t) V.push_back(t);
    sort(V.begin(), V.end());
    for(string wd:V)
        if(wd.length()==1||us.count(wd.substr(0, wd.length()-1))){
            rst=wd.length()>rst.length()?wd:rst;
            us.insert(wd);
        }
    cout<<rst;
}
