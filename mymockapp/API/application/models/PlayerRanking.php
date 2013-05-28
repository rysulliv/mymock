<?php

class Application_Model_PlayerRanking
{

		public $Name;
		public $Rank;
		public $Percentage;
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
        	$collectionName = "PlayerRankings";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getPlayerRankingByName($playerRankingObj,$name,$conn)
        {
        	$playerRankingCollection = $playerRankingObj->getCollection($conn);
        	$playerRankings = $playerRankingCollection->find(array("Name"=>$name));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $playerRankings;
        }
        public function getPlayerRankings($playerRankingObj,$conn)
        {
        	$playerRankingCollection = $playerRankingObj->getCollection($conn);
        	$playerRankings = $playerRankingCollection->find(array("IsDeleted"=>false));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $playerRankings;
        }
        public function createPlayerRanking($playerRankingObj,$conn)
        {
        	$playerRankingCollection = $playerRankingObj->getCollection($conn);
        	$playerRankingCollection->insert($playerRankingObj);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        
}

