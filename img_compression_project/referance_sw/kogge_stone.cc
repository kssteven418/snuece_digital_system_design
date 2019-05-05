#include <iostream>
#include <stdio.h>
using namespace std;

int exp(int x){
	int ret = 1;
	for(int i=0; i<x; i++) ret = ret*2;
	return ret;
}

void print(int* x, int len){
	int s = 0;
	int temp = 1;
	for(int i=0; i<len; i++){
		s += x[i]*temp;
		temp *= 2;
	}
	cout<<s<<" : ";
	for(int i=len-1; i>=0; i--)
		cout<<x[i];
	cout<<endl;
}

int main(){
	int cin = 1;
	int N = 8;
	int M = 3;
	char* _x = "00111111";
	char* _y = "01111110";
	int x[N], y[N];

	for (int i=0; i<N; i++){
		x[i] = _x[N-1-i]-'0';
		y[i] = _y[N-1-i]-'0';
	}
	
	int p[N][M+1];
	int g[N][M+1];
	int sum[N];

	for(int i=0; i<N; i++){
		p[i][0] = x[i]^y[i];
		g[i][0] = x[i]&y[i];
	}
	g[0][0] = g[0][0] | (p[0][0]&cin);

	for(int j=1; j<=M; j++){
		for(int i=0; i<N; i++){

			if(i<exp(j-1)){
				p[i][j] = p[i][j-1];
				g[i][j] = g[i][j-1];
			}
			else{
				p[i][j] = p[i][j-1]&p[i-exp(j-1)][j-1];
				g[i][j] = g[i][j-1]|(p[i][j-1]&g[i-exp(j-1)][j-1]);
			}
		}
	}

	for(int i=1; i<N; i++)
		sum[i] = g[i-1][M]^p[i][0];
	sum[0] = p[0][0]^cin;

	for(int j=0; j<M+1; j++){
		printf("step %d\n", j);
		printf("p: ");
		for(int i=N-1; i>=0; i--){
			printf("%d ", p[i][j]);
		}

		printf("\ng: ");
		for(int i=N-1; i>=0; i--){
			printf("%d ", g[i][j]);
		}
		cout<<endl;
	}
	int cout = g[N-1][M];
	printf("%d\n", cout);
	print(x, N);
	print(y, N);
	print(sum, N);
	//cout<<"cout : "<<cout<<endl;
	


	return 0;
}


