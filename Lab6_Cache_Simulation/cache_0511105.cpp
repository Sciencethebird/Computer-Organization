//
//  main.cpp
//  CO_Lab_6
//
//  Created by Sciencethebird on 2019/6/28.
//  Copyright © 2019 Sciencethebird. All rights reserved.
//

#include <iostream>
#include <math.h>
#include <bitset>
#include <deque>
#include <iomanip>
using namespace std;


struct cache_content{
    bool v;
    unsigned int  tag;
    //    unsigned int    data[16];
};
const int K=1024;

void simulate(int cache_size, int block_size, int associativity){
    unsigned int tag,index,x;
    
    int offset_bit = (int) log2(block_size); // address in block
    int index_bit = (int) log2(cache_size/block_size); // cache address
    int line = cache_size>>(offset_bit); // number of blocks
    
    
    cache_content *cache = new cache_content[line];

    for(int j=0;j<line;j++)
        cache[j].v=false;
    
    FILE * fp=fopen("Trace.txt","r");                    //read file

    if(fp == nullptr){
        cout << "can't open file" << endl;                //32 bit address
    }
    int miss_cnt = 0, hit_cnt = 0;
    while(fscanf(fp,"%x",&x)!=EOF){
        //cout<<hex<<x<<" ";
        index=(x>>offset_bit)&(line-1);
        tag=x>>(index_bit+offset_bit);
        if(cache[index].v && cache[index].tag==tag){
            cache[index].v=true;             //hit
            hit_cnt++;
        }
        else{
            cache[index].v=true;            //miss, load data
            cache[index].tag=tag;
            miss_cnt++;
        }
    }
    cout << (float)100*miss_cnt/(miss_cnt+hit_cnt)<< endl;
    fclose(fp);
    delete [] cache;
}

void simulate_ass(int cache_size, int block_size, int associativity){
    unsigned int tag,index,x;
    deque<int> missed_instr, hit_instr;
    long instr_cnt = 0;
    
    int offset_bit = (int) log2(block_size); // address in block
    int index_bit = (int) log2(cache_size/block_size/associativity);
    int line = cache_size>>(offset_bit+(int)log2(associativity) ); // number of blocks
    
    cache_content **cache = new cache_content*[line];
    for(int i = 0; i<line;i++)
            cache[i] = new cache_content[associativity];
    
    deque<deque<int>> LRU;
    deque<int> temp;
    for(int i = 0; i < associativity; i++) temp.push_back(i);
    
    for(int i=0; i<line;i++)
        LRU.push_back(temp);
 
    for(int i=0; i<line;i++)
        for(int j=0;j<associativity;j++)
            cache[i][j].v=false;
    
    FILE * fp=fopen("Trace1.txt","r");                    //read file
    
    if(fp == nullptr) cout << "can't open file" << endl;  //32 bit address
    
    int hit_cnt = 0, miss_cnt = 0;
    while(fscanf(fp,"%x",&x)!=EOF){
        //cout<<hex<<"\n"<<x<<" ";
        instr_cnt++;
        index=(x>>offset_bit)&(line-1);// extract part with line length
        tag=x>>(index_bit+offset_bit);
        /*
        cout << "\nbinary " <<bitset<32>(x)<<" " << x
             << "\nindex  " << bitset<32>(index) << " " <<index
             << "\ntag    " << bitset<32>(tag)<< " "<<tag<<endl;*/
        
        bool hit = false;
        for(int ass_index = 0; ass_index<associativity;ass_index++){
            if(cache[index][ass_index].v && cache[index][ass_index].tag==tag){
                cache[index][ass_index].v=true;//hit
                hit_instr.push_back(instr_cnt);
                int curr_idx=NULL;
                
                //find LRU index
                for(int j=0;j<associativity;j++)
                    if(LRU[index][j] == ass_index)
                        curr_idx = j;
                //change order
                if(ass_index!=LRU[index].back()){
                    LRU[index].push_back(LRU[index][curr_idx]);
                    LRU[index].erase(LRU[index].cbegin()+curr_idx);
                }
               
                hit = true;
                hit_cnt++;
                //cout <<"hit" <<endl;
                break;
            }
        }
     
        if(!hit){
            //cout <<"miss" <<endl;
            missed_instr.push_back(instr_cnt);
            miss_cnt++;
            int least_used = LRU[index].front();
            cache[index][least_used].v=true;            //miss, load data
            cache[index][least_used].tag=tag;
            if(least_used!=LRU[index].back()){
                 LRU[index].push_back(least_used);
                 LRU[index].pop_front();
            }
            //print cache
            /*
            for(int i = 0; i< cache_size/block_size/associativity; i++){
                cout << "index = " << i <<endl;
                for(int j = 0; j< associativity; j++){
                    cout <<"|"<< j << "|"<<cache[i][j].v<< " " <<cache[i][j].tag<<"|\t";
                }
                cout<< endl;
            }*/
        }
        
    }
    //cout << hit_cnt << endl;
    //cout << miss_cnt << endl;
    cout  << "Miss Rate: "<< (float)100*miss_cnt/(miss_cnt+hit_cnt)<<"%" ;
    cout << "\nHit instructions: ";
    for(int i = 0; i< hit_instr.size(); i++)
        cout << hit_instr[i] << " ";
    cout << "\nMissed instructions: ";
    for(int i = 0; i< missed_instr.size(); i++)
        cout << missed_instr[i] << " ";
    fclose(fp);
    delete [] cache;
}

int main(){
  
    simulate_ass(4*K, 16, 1);
   /*
    for(int i = 1; i<8; i++ ){
        cout <<endl<<(int)pow(2, i) << endl;
        for(int j = 2; j<7; j++){
            //cout << j << endl;
             simulate_ass(((int)pow(2, i))*K, (int)pow(2, j), 1);
            
        }
    }
    cout << "xxdxdxd" << endl;
    for(int i = 0; i<6; i++ ){
        cout <<(int)pow(2, i) << endl;
        for(int j = 0; j<4; j++){
            //cout << j << endl;
            simulate_ass(((int)pow(2, i))*K, 32, ((int)pow(2, j)));
        }
    }
    */
   
    return 0;
}

