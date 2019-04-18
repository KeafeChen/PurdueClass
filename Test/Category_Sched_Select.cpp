#include <bits/stdc++.h>
#include <unordered_map>
using namespace std;
#define INF 0x3f3f3f3f
struct Node{ int p, q; };
vector<Node> V[1001];
unordered_map<string, int> ma;
int T, N, B, cnt;
int idx(string s){
    if(!ma.count(s)) ma[s]=cnt++;
    return ma[s];
}
bool ck(int m){
    int s=0;
    for(int i=0;i<cnt;++i){
        int zb=INF, sz=V[i].size();
        for(int j=0;j<sz;++j) zb=(V[i][j].q>=m&&V[i][j].p<zb)?V[i][j].p:zb;
        if(zb==INF) return 0;
        s+=zb;
        if(s>B) return 0;
    }
    return 1;
}
int main(){
    scanf("%d", &T);
    while(T--){
        scanf("%d %d", &N, &B);
        cnt=0;
        for(int i=0;i<N;V[i++].clear());
        ma.clear();
        int mx=0;
        for(int i=0;i<N;++i){
            char s1[32], s2[32];
            int p, q;
            scanf("%s %s %d %d", s1, s2, &p, &q);
            mx=q>mx?q:mx;
            V[idx(s1)].push_back(Node{ p, q });
        }
        int l=0, r=mx, m;
        while(l<r){
            m=l+((r-l+1)>>1);
            if(ck(m)) l=m;
            else r=m-1;
        }
        printf("%d\n", l);
    }
}
