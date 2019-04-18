#include <bits/stdc++.h>
using namespace std;
vector<vector<int>> dp;
int n, m;
void run(int m,int n){
    int w[10],p[10];
    for(int i=1;i<n+1;i++) scanf("%d,%d", w+i, p+i);
    for(int j=0;j<m+1;j++)
        for(i=0;i<n+1;i++)
           if(j<w[i]){
               dp[i][j]=dp[i-1][j];
               continue;
           }else if(dp[i-1][j-w[i]]+p[i]>dp[i-1][j]) dp[i][j]=dp[i-1][j-w[i]]+p[i];
           else dp[i][j]=dp[i-1][j];
}
int main(){
    printf("Number of class:\n");
    scanf("%d,%d",&m,&n);
    printf("Input name and priority:\n");
    run(m,n);
    printf("\n");
    dp.resize(n);
    for(int i=0;i<n;dp[i].resize(m));
    for(int i=0;i<=n;i++)
        for(int j=0;j<=m;j++){
           printf("%4d", dp[i][j]);
           if(m==j) printf("\n");
    }
}
