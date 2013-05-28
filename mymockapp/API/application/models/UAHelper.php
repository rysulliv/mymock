<?php
class Application_Model_UAHelper
{
    public $UA_APPSECRET;
    public $UA_APPKEY;
    public $Response;
    

    function __construct($uasecret,$uakey)
    {
    	 $this->UA_APPKEY = $uakey;
    	 $this->UA_APPSECRET = $uasecret;
    }
    function registerDevice($deviceID,$alias,$tags)
    {
        
         
        //$this->airship = new Airship($APP_KEY, $APP_MASTER_SECRET);
        
        $contents = array();
        $contents['alias'] = $alias;
        $contents['tags'] = $tags;
        $contents['device_tokens'] = $deviceID;
        $push = array("aps" => $contents);
        $this->UA_PUSHURL = "https://go.urbanairship.com/api/device_tokens/".$deviceID."/";
        $json = json_encode($contents);
         
        $session = curl_init($this->UA_PUSHURL);
        curl_setopt($session, CURLOPT_USERPWD, $this->UA_APPKEY . ':' . $this->UA_APPSECRET);
        curl_setopt($session, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($session, CURLOPT_POST, true);
        curl_setopt($session, CURLOPT_POSTFIELDS, $json);
        curl_setopt($session, CURLOPT_HEADER, False);
        curl_setopt($session, CURLOPT_RETURNTRANSFER, True);
        curl_setopt($session, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));
        $content = curl_exec($session);
         
        // Check if any error occured
        $response = curl_getinfo($session);
        if($response['http_code'] == 201) {
        	$response = 1;
        } else if($response['http_code'] == 200) {
        	 
        	$output = 1;
        }
        else
        {
        	$output = $response['http_code'];
        }
         
        curl_close($session);
        
        return $output;
    }
    function sendPush($alias,$badge,$message,$sound="default")
    {
    
    	$contents = array(); 
		$contents['badge'] = $badge; 
		$contents['alert'] = $message; 
		$contents['sound'] = $sound; 
		$push = array("aliases"=>$alias,"aps" => $contents); 
    	$this->UA_PUSHURL = "https://go.urbanairship.com/api/push/";
    	$json = json_encode($push);
    	echo $json;
    	 
    	$session = curl_init($this->UA_PUSHURL);
    	curl_setopt($session, CURLOPT_USERPWD, $this->UA_APPKEY . ':' . $this->UA_APPSECRET);
    	//curl_setopt($session, CURLOPT_CUSTOMREQUEST, "PUT");
    	curl_setopt($session, CURLOPT_POST, true);
    	curl_setopt($session, CURLOPT_POSTFIELDS, $json);
    	curl_setopt($session, CURLOPT_HEADER, False);
    	curl_setopt($session, CURLOPT_RETURNTRANSFER, True);
    	curl_setopt($session, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));
    	$content = curl_exec($session);
    	 
    	// Check if any error occured
    	$response = curl_getinfo($session);
    	if($response['http_code'] == 200) {
    		$output = 1;
    	} 
    	else
    	{
    		$output = $response['http_code'];
    	}
    	 
    	curl_close($session);
    
    	return $output;
    }
}