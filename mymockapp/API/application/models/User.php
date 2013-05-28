<?php

class Application_Model_User
{

		public $firstName;
		public $lastName;
		public $name;
		public $band;
		public $invites;
		public $passes;
		public $currentQuestion;
		public $spotInLine;
		public $Longitude;
		public $Latitude;
		public $facebookId;
		public $birthday;
		public $location;
		public $timezone;
		public $email;
		public $age_range;
		public $devices;
		public $CreatedOn;
		public $CreatedBy;
		public $UpdatedOn;
		public $UpdatedBy;

		
		public $IsDeleted = false;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "Users";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getUserByEmail($userObj,$email,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->find(array("email"=>$email));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $users;
        }
        public function getUserById($userObj,$id,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->findOne(array("_id"=>$id));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $users;
        }
        public function getUserByFacebookId($userObj,$id,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->findOne(array("facebookId"=>$id));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $users;
        }
        public function getUsers($userObj,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->find();
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $users;
        }
        public function createUser($userObj,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$userCollection->insert($userObj);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function updateUserPurchaseByFacebookId($userObj,$facebookId,$purchases,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->update(array("facebookId"=>$facebookId),array('$set'=>array("passes"=>$purchases)));
        	
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function incrementSpotByNumber($userObj,$facebookId,$number,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$users = $userCollection->findOne(array("facebookId"=>$facebookId));
        	//return $users['band'];
        	//check to make sure we do not take the user our of their "band"
        	if($users['band']>0)
        	{
        		
        		if($users['spotInLine']+$number > $users['band'])
        		{
        			//set user to band -1
        			$userCollection->update(array("facebookId" => $facebookId),array('$set'=>array("spotInLine"=>$users['band'])));
        		}
        		else
        		{
        			$newData = array('$inc' => array('spotInLine'=>$number));
        			$userCollection->update(array("facebookId" => $facebookId), $newData,array("w" => 1));
        		}
        	}
        	else
        	{	
	        	$newData = array('$inc' => array('spotInLine'=>$number));
	        	$userCollection->update(array("facebookId" => $facebookId), $newData,array("w" => 1));
        	}
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function incrementQuestionNumber($userObj,$facebookId,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        
        	$newData = array('$inc' => array('currentQuestion'=>1));
        	$userCollection->update(array("facebookId" => $facebookId), $newData,array("w" => 1));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function incrementInvitesNumber($userObj,$facebookId,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        
        	$newData = array('$inc' => array('invites'=>1));
        	$userCollection->update(array("facebookId" => $facebookId), $newData,array("w" => 1));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
		public function decrementSpotByNumber($userObj,$facebookId,$number,$conn)
        {
        	$userCollection = $userObj->getCollection($conn);
        	$user = $userCollection->findOne(array("facebookId"=>$facebookId));
        	if($user['spotInLine']<=10)
        	{
        		$userCollection->update(array("facebookId" => $facebookId),array('$set'=>array("spotInLine"=>1)));
        	}
        	else
        	{
	        	$newData = array('$inc' => array('spotInLine'=>$number));
	        	$userCollection->update(array("facebookId" => $facebookId), $newData,array("w" => 1));
        	}
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
}

