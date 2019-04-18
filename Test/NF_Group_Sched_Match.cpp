#include <bits/stdc++.h>
using namespace std;
#define MAXN 1005
#define INF 0x3f3f3f3f
struct E{int src, dst, c, f;};
struct NF{
    int vs, st, ed, vis[MAXN], d[MAXN], cur[MAXN];
    vector<E> edge;
    vector<int> G[MAXN];
    void addedge(int src, int dst, int c){
        edge.push_back({src, dst, c, 0}), edge.push_back({dst, src, 0, 0});
        G[src].push_back(edge.size()-2), G[dst].push_back(edge.size()-1);
    }
    bool BFS(){
        memset(vis, 0, sizeof(vis));
        queue<int>que;
        que.push(st);
        d[st]=0, vis[st]=1;
        while(que.size()){
           int u=que.front();que.pop();
            for(auto o:G[u]){
                E &e=edge[o];
                if(!vis[e.dst]&&e.c>e.f) vis[e.dst]=1, d[e.dst]=d[u]+1, que.push(e.dst);
            }
        }
        return vis[ed];
    }
    int DFS(int x, int a){
        if(x==ed||!a) return a;
        int rst=0, f;
        for(int &i=cur[x];i<G[x].size();++i){
            int ind=G[x][i];
            E &e=edge[ind];
            if(d[x]+1==d[e.dst]){
                int f=DFS(e.dst, min(a, e.c-e.f));
                if(f>0){
                    e.f+=f, edge[ind^1].f-=f, rst+=f, a-=f;
                    if(!a) break;
                }
            }
        }
        return rst;
    }
    int MXF(int s, int t){
        st=s, ed=t;
        int rst=0;
        while(BFS()){
            memset(cur, 0, sizeof(cur));
            rst+=DFS(s, INF);
        }
        return rst;
    }
};
int vis[MAXN];
int main(){
    int ch, to, ca;
    scanf("%d%d%d", &ch, &to, &ca);
    NF nf;
    nf.vs=1+ch+to+(ca+1), nf.st=0, nf.ed=nf.vs;
    for(int i=1, k;i<=ch;++i){
        scanf("%d", &k);
        for(int x;k--;scanf("%d", &x), nf.addedge(i, x+ch, 1));
        nf.addedge(nf.st, i, 1);
    }
    for(int i=1, l, r;i<=ca;++i){
        int u=ch+to+i;
        scanf("%d", &l);
        for(int x;l--;scanf("%d", &x), vis[x]=1, nf.addedge(x+ch, u, 1));
        scanf("%d", &r);
        nf.addedge(u, nf.vs, r);
    }
    vector<int>vec;
    for(int i=1;i<=to;++i){
        if(vis[i]) continue;
        vec.push_back(i);
        nf.addedge(i+ch, ch+to+ca+1, 1);
    }
    nf.addedge(ch+to+ca+1, nf.ed, vec.size());
    printf("%d\n", nf.MXF(nf.st, nf.ed));
    return 0;
} 
