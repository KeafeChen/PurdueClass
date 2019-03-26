#include <bits/stdc++.h>
using namespace std;
#define T 10
typedef struct node{ string a, b, c, d, e; }node;
bool exact(string a, string b){ return !a.compare(b); }
bool contain(string a, string b){ return a.find(b)!=string::npos; }
string merge(string a[], int c){
	string rst="";
	for(int i=0;i<c;rst+=a[i++]);
	return rst;
}
void exErr(string a){
	cout<<endl<<a<<endl;
	exit(1);
}
int main(){
	for(int i=1;i<T;++i){
		string fnt="testcase"+to_string(i)+".txt", fni="testin"+to_string(i)+".txt", fno="testout"+to_string(i)+".txt";
		if(!freopen(fnt.c_str(), stdin)) exErr(fnt+"not exists!");
		int tr, tc, ir, ic;
		cin>>tr>>tc;
		string db[tr][tc];
		for(int i=0;i<tr;++i) for(int j=0;j<tc;cin>>db[i][j++]);
		fclose(stdin);
		if(!freopen(fni.c_str(), stdin)) exErr(fni+"not exists!");
		cin>>ir>>ic;
		string di[ir][ic];
		for(int i=0;i<ir;++i) for(int j=0;j<ic;cin>>di[i][j++]);
		fclose(stdin);
		if(!freopen(fno.c_str(), stdout)) exErr(fno+"not exists!");
		for(int i=0;i<ir;++i){
			int f=0;
			for(int j=0;!f&&j<ic;++j)
				for(int k=0;!f&&k<tr;++k)
					if(di[i][j].compare("NULL")&&exact(di[i][j], db[k][j])){
						printf("Testcase-%d: %s\n", i, merge(db[k], tc));
						f=1;
					}
			if(!f) printf("Testcase-%d: None\n");
		}
	}
}
/*
int main(){
	for(int i=1;i<10;++i){
		int ci=0, cnt=0;
		string str="testcase"+to_string(i)+".txt", si="testin"+to_string(i)+".txt", so="testout"+to_string(i)+".txt";
		FILE *fp=fopen(str.c_str(), "r"), *fi=fopen(si.c_str(), "r");
		ofstream ofs;
		char buf[1281];
		vector<node> v, vi;
		if(!fp){
			cout<<str<<" not exists!"<<endl;
			fi->close();
			return 1;
		}
		for(node tmp;!feof(fp);++cnt){
			memset(buf, '\0', 1281);
			if(!fgets(buf, 1280, fp)) break;
			node tmp;
			memset(tmp.a, '\0', 256);
			memset(tmp.b, '\0', 256);
			memset(tmp.c, '\0', 256);
			memset(tmp.d, '\0', 256);
			memset(tmp.e, '\0', 256);
			sscanf(buf, "%s %s %s %s %s", tmp.a, tmp.b, tmp.c, tmp.d, tmp.e);
			v.push_back(tmp);
		}
		if(!fi){
			cout<<si<<" not exists!"<<endl;
			fp->close();
			return 1;
		}
		for(node tmp;!feof(fi);++ci){
			memset(buf, '\0', 1281);
			if(!fgets(buf, 1280, fp)) break;
			memset(tmp.a, '\0', 256);
			memset(tmp.b, '\0', 256);
			memset(tmp.c, '\0', 256);
			memset(tmp.d, '\0', 256);
			memset(tmp.e, '\0', 256);
			sscanf(buf, "%s %s %s %s %s", tmp.a, tmp.b, tmp.c, tmp.d, tmp.e);
			vi.push_back(tmp);
		}
		ofs.open(so);
		if(!ofs){
			cout<<so<<" not exists!"<<endl;
			fp->close();
			fi->close();
			return 1;
		}
		for(int i=0;i<ci;++i){
			bool f=0;
			vector<int> lst;
			for(int j=0;j<cnt;++j){
				f=(!run(vi[i].a, "NULL")?run(vi[i].a, v[j].a):1)&&(!run(vi[i].b, "NULL")?run(vi[i].b, v[j].b):1)&&(!run(vi[i].c, "NULL")?run(vi[i].c, v[j].c):1)&&(!run(vi[i].d, "NULL")?run(vi[i].d, v[j].d):1)&&(!run(vi[i].e, "NULL")?run(vi[i].e, v[j].e):1);
				if(f) lst.push_back(j);
			}
			if(!lst.size()) ofs<<("Test case-"+to_string(i)+":\nNone\n\n");
			else ofs<<("Test case-"+to_string(i)+":\n");
			for(int j=0;j<lst.size();++j) ofs<<j<<". "<<vi[lst[j]].a<<"\t"<<vi[lst[j]].b<<"\t"<<vi[lst[j]].c<<"\t"<<vi[lst[j]].d<<"\t"<<vi[lst[j]].e<<endl;
		}
		fp->close();
		fi->close(); 
		ofs->close();
	}
	return 0;
} 
*/
