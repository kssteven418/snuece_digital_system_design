#include <iostream>
#include <vector>
#include <string>
#include <fstream>
using namespace std;

int main(int argc, char *argv[]){
	
	if(argc!=2){
		cout<<"enter input parameter"<<endl;
		return 0;
	}

	ifstream f(argv[1]);
	
	//char temp[100];
	string temp;
	while(!f.eof()){
		getline(f, temp);
		if(temp[0] != '0' && temp[0] != '1') continue;
		cout<<temp[0];
	}
	cout<<endl;


	return 0;

}	
