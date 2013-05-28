<?php

class Application_Model_RegisteredCount
{

		public $total;
        public $countId;
		
		
		
        function __construct()
        {
        	
        }
        public function getCollection($mongo)
		{
			$frontController = Zend_Controller_Front::getInstance();
			 
			$config       = $frontController->getParam('bootstrap')
			->getOption('mongohq');
			$databaseName   = $config['databasename'];
        	$collectionName = "RegisteredCount";
        	$collection = $mongo->$databaseName->$collectionName;
        	return $collection;
        }
        public function getCount($countObj,$conn)
        {
        	$countColection = $countObj->getCollection($conn);
        	$count = $countColection->findOne(array());
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return $count;
        }
        public function incrementCount($countObj,$conn)
        {
        	$countColection = $countObj->getCollection($conn);
        	
        	$newData = array('$inc' => array('total'=>1));
        	$countColection->update(array("countId" => "main"), $newData,array("w" => 1));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
        public function incrementCountByNumber($countObj,$number,$conn)
        {
        	$countColection = $countObj->getCollection($conn);
        	 
        	$newData = array('$inc' => array('total'=>$number));
        	$countColection->update(array("countId" => "main"), $newData,array("w" => 1));
        	if($conn->err == 'MONGO_IO_ERROR' )
        		mongo_reconnect( $conn );
        	else
        		return;
        }
       
}

