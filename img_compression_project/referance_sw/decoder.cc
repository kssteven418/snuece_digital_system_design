#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main(){
	
	string encoded = "0011111000111111010001111000111000000001011000000100000010110001001110000000000010001100111100001110001000000100001";

	int i = 0;
	int sign = 1;
	int zero;
	int q = 4;
	int r;
	int sum;

	cout << "mode : " << encoded[i] << endl;
	i++;
	
	//first bit
	int first = 0;
	for(int j=0; j<8; j++){
		first *=2;
		first += (encoded[i++]-'0');
	}

	cout << first << " ";

	while(true){
		if(encoded[i] != '0' && encoded[i] != '1') break;
	
		
		//sign
		if (encoded[i] == '0') sign = 1;
		else sign = -1;

		i++;
		sum = 0;
		
		//num zero
		zero = 0;
		while(true){
			if(encoded[i] == '1') break;
			zero ++;
			i++;
		}

		sum += zero * q;

		i++;
		r = 0;
		if(encoded[i]=='0' && encoded[i+1] == '0') r = 0;
		if(encoded[i]=='0' && encoded[i+1] == '1') r = 1;
		if(encoded[i]=='1' && encoded[i+1] == '0') r = 2;
		if(encoded[i]=='1' && encoded[i+1] == '1') r = 3;

		i++;
		i++;

		sum += r;
		sum *= sign;

		cout << sum << " ";
		


	}

	cout << endl;
	return 0;
}
