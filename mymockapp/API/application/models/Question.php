<?php

class Application_Model_Question
{

		public $number;
		public $text;
		public $answers;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "Questions";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getQuestionByNumber($questionObj,$number,$conn)
        {
        	$questionCollection = $questionObj->getCollection($conn);
        	$questions = $questionCollection->findOne(array("number"=>$number));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $questions;
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
        	$answerCollection->insert($answerObj,true);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        
}

