#include <bits/stdc++.h>
using namespace std;
struct Edge{ int src, dst; };
class AL {
    int V;
    vector<int> *adj;
    Graph(int V) {
      this->V=V;
      adj=new vector<int>[V];
    }
    void addEdge(int v, int w) { adj[v].push_back(w); }
};
class EL {
	int V, E;
	struct Edge *edge;
	Graph(int V, int E){
		this->V=V;
		this->E=E;
    this->edge=new Edge[E];
	}
	void addEdge(int a, int b, int c){
		this->edge[a].src=b;
		this->edge[a].dst=c;
	}
}
class GL {
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
            for(int j=0;j<V[i].size();++j) if(!--tv[j]) q.push(V[i][j]);
        }
        if(cnt-n) return {-1};
        return to;
    }
};
