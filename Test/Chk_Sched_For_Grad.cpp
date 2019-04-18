#include <queue>
#include <iostream>
using namespace std;
#define INF 0x3F3F3F3F
#define MAXN 205
struct Pt{
    int x, y;
};
struct Node{
    Pt p;
    int d;
};
int n, m, M[MAXN][MAXN], V[MAXN][MAXN], R[]={-1, 0, 0, 1}, C[]={0, -1, 1, 0};
Pt src, dst;
int Val(int r, int c){
    return r>=0&&r<n&&c>=0&&c<=m;
}
void run(){
    if(!M[src.x][src.y]||!M[dst.x][dst.y]){
        cout<<"Impossible.";
        return;
    }
    V[src.x][src.y]=1;
    queue<Node> Q;
    Node st={src, 0};
    Q.push(st);
    while(!Q.empty()){
        Node cur=Q.front();
        Pt tmp=cur.p;
        if(tmp.x==dst.x&&tmp.y==dst.y){
            cout<<cur.d;
            return;
        }
        Q.pop();
        for(int i=0;i<4;++i){
            int r=tmp.x+R[i], c=tmp.y+C[i];
            if(Val(r, c)&&M[r][c]&&!V[r][c]){
                V[r][c]=1;
                Node t={{r, c}, cur.d+1};
                Q.push(t);
            }
        }
    }
    cout<<"Impossible.";
}
int main() {
    cin>>n>>m>>src.x>>src.y>>dst.x>>dst.y;
    for(int i=0;i<n;++i) for(int j=0;j<m;cin>>M[i][j++]);
    run();
    return 0;
}
