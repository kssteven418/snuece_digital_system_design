#include <iostream>
#include <vector>
#include <string>
#include <fstream>
using namespace std;

bool check(char x){
	return x=='0' || x=='1';
}

void dpcm_decode(int mode, int* decoded, int* dpcm_decoded){
	for(int i=1; i<16; i++){
		decoded[i] = decoded[i-1] + decoded[i];
		//cout<<decoded[i]<<" ";
	}
	//cout<<endl;
	if(mode == 0){
		dpcm_decoded[0] = decoded[0];
		dpcm_decoded[1] = decoded[1];
		dpcm_decoded[2] = decoded[2];
		dpcm_decoded[3] = decoded[3];
		dpcm_decoded[4] = decoded[7];
		dpcm_decoded[5] = decoded[6];
		dpcm_decoded[6] = decoded[5];
		dpcm_decoded[7] = decoded[4];
		dpcm_decoded[8] = decoded[8];
		dpcm_decoded[9] = decoded[9];
		dpcm_decoded[10] = decoded[10];
		dpcm_decoded[11] = decoded[11];
		dpcm_decoded[12] = decoded[15];
		dpcm_decoded[13] = decoded[14];
		dpcm_decoded[14] = decoded[13];
		dpcm_decoded[15] = decoded[12];
	}
	else{
		dpcm_decoded[0] = decoded[0];
		dpcm_decoded[1] = decoded[7];
		dpcm_decoded[2] = decoded[8];
		dpcm_decoded[3] = decoded[15];
		dpcm_decoded[4] = decoded[1];
		dpcm_decoded[5] = decoded[6];
		dpcm_decoded[6] = decoded[9];
		dpcm_decoded[7] = decoded[14];
		dpcm_decoded[8] = decoded[2];
		dpcm_decoded[9] = decoded[5];
		dpcm_decoded[10] = decoded[10];
		dpcm_decoded[11] = decoded[13];
		dpcm_decoded[12] = decoded[3];
		dpcm_decoded[13] = decoded[4];
		dpcm_decoded[14] = decoded[11];
		dpcm_decoded[15] = decoded[12];
	}
}

int main(int argc, char *argv[]){

	/*****************modifyinput file*******************/
	
	if(argc!=3){
		cout<<"enter input parameter"<<endl;
		return 0;
	}
	
	int printmode = 0;
	
	string argv2 = argv[2];
	if(argv2.compare("by_num")==0) printmode = 1;
	else if (argv2.compare("by_line")==0) printmode = 0;
	else if (argv2.compare("detailed")==0) printmode = 2;
	else{
		cout<<"Mode : by_num, by_line, detailed"<<endl;
		return 0;
	}

	ifstream f(argv[1]);
	
	//char temp[100];
	string temp;
	string out;

	while(!f.eof()){
		getline(f, temp);
		if(temp[0] != '0' && temp[0] != '1') continue;
		out.append(temp);
	}
	
	//cout << out << endl;

	int count = 16;
	int decoded[16];
	int mode;
	int sign;
	int sum;
	bool started = false;
	int i = 0;
	int line_num = 0;

	while(out[i] == '0' || out[i] == '1'){
		
		//read mode
		if(count==16){
			if(started){
				
				if(printmode == 2){	
					cout << "#"<<line_num << " :: encode mode " << mode << endl;
					
					for(int k=0; k<16; k++) cout << decoded[k] << " ";
					cout<< endl;
				}

				int dpcm_decoded[16];
				dpcm_decode(mode, decoded, dpcm_decoded);
				
				for(int k=0; k<16; k++) {
					cout << dpcm_decoded[k];
					if(printmode==1) cout<<endl;
					else cout<<" ";
				}
				if(printmode != 1) cout<< endl;
				if(printmode == 2) cout<<endl;

				line_num ++;
			}

			count = 0;
			mode = out[i]-'0';

			started = true;
			i++;
		}

		else if (count==0){
		
			int first = 0;
			for(int j=0; j<8; j++){

				if(out[i] != '0' && out[i] != '1') break;
				first *= 2;
				first += (out[i++]-'0');
			}

			if(out[i] != '0' && out[i] != '1') break;
			
			decoded[count++] = first;
		}
		else{

			if(out[i] == '0') sign = 1;
			else sign = -1;
			i++;
			sum = 0;

			int num_zero = 0;
			while(true){
				if(out[i]!='1' && out[i]!='0') break;
				if(out[i] == '1') break;
				num_zero ++;
				i++;
			}
			
			if(out[i]!='1' && out[i]!='0') break;
			
			sum += num_zero * 4;
			i++;
			
			
			if(out[i]!='1' && out[i]!='0') break;
			if(out[i+1]!='1' && out[i+1]!='0') break;

			
			int r = 0;

			if(out[i]=='0' && out[i+1] == '0') r = 0;
			if(out[i]=='0' && out[i+1] == '1') r = 1;
			if(out[i]=='1' && out[i+1] == '0') r = 2;
			if(out[i]=='1' && out[i+1] == '1') r = 3;
			
			i++;
			i++;
			
			sum += r;
			sum *= sign;
			
			decoded[count ++] = sum;
			
		}
		
		
	}

	return 0;

}	
