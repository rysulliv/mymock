<?php

class Application_Model_Position
{

		public $Positions;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "Positions";
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
        public function getPositions($positionsObj,$conn)
        {
        	$positionsCollection = $positionsObj->getCollection($conn);
        	$positions = $positionsCollection->findOne();
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $positions;
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

