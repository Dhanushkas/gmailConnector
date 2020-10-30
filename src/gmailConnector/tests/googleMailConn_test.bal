import ballerina/io;
import ballerina/test;
import ballerina/config;

# simple Test functions for remote functions
# 
@test:Config {
 
}
function testFunction1() {
    io:println(config:getAsString("clientSecret.clientSecret"));
    CalService|error mcl=new;
    boolean value = true;
    if(mcl is error){
      io:println("error");  
      value=false;
    }else{     
      json x=mcl->getUserProfile();
      map<json> mp = <map<json>>x;
      if(!mp.hasKey("emailAddress")){
        value=false;
      }
    }
    test:assertTrue(value, msg = "connector sucess:Profile");
    
}

@test:Config {
 
}
function testFunction2() {
    io:println(config:getAsString("clientSecret.clientSecret"));
    CalService|error mcl=new;
    boolean value = true;
    if(mcl is error){
      io:println("error");  
      value=false;
    }else{     
      json x=mcl->getLabelList();
      map<json> mp = <map<json>>x;
      if(mp.hasKey("error")){
        value=false;
        
      }
      test:assertTrue(value, msg = "Connection Success:Labels");
    }
    
}


