<?php

class Application_Model_Answer
{

		public $question;
		public $userId;
		public $answer;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "Answers";
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
        public function createAnswer($answerObj,$conn)
        {
        	$answerCollection = $answerObj->getCollection($conn);
        	$answerCollection->insert($answerObj);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        
}

