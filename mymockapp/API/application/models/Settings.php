<?php

class Application_Model_Settings
{

		public $TeamPickOrder;
		public $DataPullTime;
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "Settings";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getSettings($settingsObj,$conn)
        {
        	$settingsCollection = $settingsObj->getCollection($conn);
        	$settings = $settingsCollection->find();
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $settings;
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

