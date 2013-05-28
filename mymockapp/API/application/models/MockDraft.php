<?php

class Application_Model_MockDraft
{

		public $UserId;
		public $League;
		public $Picks;
		Public $SaveDate;
		Public $Score;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "MockDraft";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getMockDraftsByFacebookId($mockDraftObj,$FacebookId,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$drafts = $mockDraftCollection->find(array("UserId"=>$FacebookId));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $drafts;
        }
        public function getMockDrafts($mockDraftObj,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$drafts = $mockDraftCollection->find();
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $drafts;
        }
        public function updateMockDraftByFacebookId($mockDraftObj,$FacebookId,$picks,$league,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$mockDraftCollection->update(array("UserId"=>$FacebookId,"League"=>$league),array('$set'=>array("Picks"=>$picks)),array("multiple"=>false));
        	//$mockDraftCollection->update(array("League"=>$league),array('$set'=>array("Picks"=>$pics)),array("multiple"=>false));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function updateMockDraftScoreById($mockDraftObj,$id,$score,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$mockDraftCollection->update(array("_id"=>$id),array('$set'=>array("Score"=>$score)),array("multiple"=>false));
        	//$mockDraftCollection->update(array("League"=>$league),array('$set'=>array("Picks"=>$pics)),array("multiple"=>false));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function updateMockDraftSaveTimeByFacebookId($mockDraftObj,$FacebookId,$time,$league,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$mockDraftCollection->update(array("UserId"=>$FacebookId,"League"=>$league),array('$set'=>array("SaveDate"=>$time)),array("multiple"=>false));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function createMockDraft($mockDraftObj,$conn)
        {
        	$mockDraftCollection = $mockDraftObj->getCollection($conn);
        	$mockDraftCollection->insert($mockDraftObj);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        
}

