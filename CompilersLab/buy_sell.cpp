#include<bits/stdc++.h>
#include<iostream>
#include<vector>
using namespace std;

void max_profit(vector<int> arr){
	int n = arr.size();
	int max_prof = 0;
	for(int i=0;i<n-1;i++){
		if(arr[i] > arr[i+1]){

		}
		else if(arr[i] < arr[i+1]){
			for(int j=i+1;j<n-1;j++){
				if(j == n-2){
					if(arr[j] < arr[j+1]){
						max_prof =max_prof + (arr[j+1]-arr[i]);	
						break;
					}
				}
				else if(arr[j] < arr[j+1]){
					
				}
				else if(arr[j] > arr[j+1]){
					max_prof =max_prof + (arr[j]-arr[i]);
					i = j;
					break;
				}
			}
			
		}
	}
	cout<<endl;
	cout<<"maximum profit is == "<<max_prof<<endl;
}

int main(){
	int n;
	vector<int> arr;
	cin >> n;
	for(int i=0;i<n;i++){
		int data;
		cin >> data;
		arr.push_back(data);
	}
	max_profit(arr);
}