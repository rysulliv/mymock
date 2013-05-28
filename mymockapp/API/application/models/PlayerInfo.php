<?php

class Application_Model_PlayerInfo
{

		public $Name;
		public $Rank;
		public $Position;
		public $School;
		public $Year;
		public $Height;
		public $Weight;
		public $Forty="-";
		public $Twenty="-";
		public $Ten="-";
		public $Bench="-";
		public $Vertical="-";
		public $Broad="-";
		public $Shuttle="-";
		public $Cone="-";
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
        	$collectionName = "PlayerInfo";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getPlayerInfoByName($playerInfoObj,$name,$conn)
        {
        	$playerInfoCollection = $playerInfoObj->getCollection($conn);
        	$playerInfo = $playerInfoCollection->find(array("Name"=>$name));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $playerInfo;
        }
        public function getPlayerInfo($playerInfoObj,$conn)
        {
        	$playerInfoCollection = $playerInfoObj->getCollection($conn);
        	$playerInfo = $playerInfoCollection->find(array("IsDeleted"=>false));
        	$playerInfo=$playerInfo->sort(array('Rank' => 1));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $playerInfo;
        }
        public function updateWithCombine($playerInfoObj,$name,$forty,$twenty,$ten,$vertical,$broad,$shuttle,$cone,$conn)
        {
        	$playerInfoCollection = $playerInfoObj->getCollection($conn);
        	
        	$playerInfoCollection->update(array("Name"=>$name),array('$set'=>array("Forty"=>$forty,"Twenty"=>$twenty,"Ten"=>$ten,"Vertical"=>$vertical,"Broad"=>$broad,"Shuttle"=>$shuttle,"Cone"=>$cone)),array("multiple"=>false));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function createPlayerInfo($playerInfoObj,$conn)
        {
        	$playerInfoCollection = $playerInfoObj->getCollection($conn);
        	$playerInfoCollection->insert($playerInfoObj);
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        
}

