/*
* TC file format:
* n
* a1 b1
* a1 b2
* ... (n lines)
* IN file format:
* n
* a1 a2 ... an
*/
#include <bits/stdc++.h>
using namespace std;
#define T 10
class G{
    int n, cnt;
    vector<int> *V;
public:
    G(int n) {
        this->n=n;
        cnt=0;
        V=new vector<int>[n];
    }
    void add(int a, int b){ V[a].push_back(b); }
    vector<int> run(){
        vector<int> tv(n, 0), to;
        for(int i=0;i<n;++i) for(int j=0;j<V[i].size();++tv[V[i][j++]]);
        queue<int> q;
        for(int i=0;i<n;++i) if(!tv[i]) q.push(i);
        for(int i;!q.empty();++cnt){
            i=q.front();
            q.pop();
            to.push_back(i);
            for(int j=0;j<V[i].size();++j) if(--tv[V[i][j]]==0) q.push(V[i][j]);
        }
        if(cnt-n) return {-1};
        return to;
    }
};
int main(){
    for(int i=1;i<T;++i){
        cout<<"Testcase-"<<to_string(i)<<":"<<endl<<"\t";
        string st="TC-"+to_string(i)+".txt", si="IN-"+to_string(i)+".txt", s;
        ifstream ift(st), ifi(si);
        if(ift.fail()||ifi.fail()){
            cout<<"File missing!"<<endl;
            exit(1);
        }
        getline(ift, s);
        stringstream ss(s);
        int n, a, b, ni, t;
        bool flag=1;
        ss>>n;
        G g(n);
        for(;getline(ift, s);g.add(a, b)){
            ss<<s;
            ss>>a>>b;
        }
        vector<int> rst=g.run();
        getline(ifi, s);
        ss<<s;
        ss>>ni;
        if(ni-rst.size()){
            cout<<"WA"<<endl;
            continue;
        }
        getline(ifi, s);
        ss<<s;
        for(int i=0;i<ni&&flag;++i){
            ss>>t;
            if(t-rst[i]) flag=0;
        }
        cout<<(flag?"AC":"WA")<<endl;
    }
}
