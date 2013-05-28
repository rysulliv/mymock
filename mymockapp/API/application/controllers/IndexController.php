<?php

class IndexController extends Zend_Controller_Action
{
	private $_Conn;
    public function init()
    {
        $frontController = Zend_Controller_Front::getInstance();
    	$config       = $frontController->getParam('bootstrap')
    	->getOption('mongohq');
    	$mongoDns = sprintf('mongodb://%s:%s@%s:%s/%s',
    			$config['username'],
    			$config['password'],
    			$config['hostname'],
    			$config['port'],
    			$config['databasename']);
    	$this->_Conn = new mongo($mongoDns);
    }

    public function indexAction()
    {
         $this->_helper->layout->disableLayout();
         $userObj = new Application_Model_User();
         $userData = $userObj->getUsers($userObj, $this->_Conn);
         $userCount = 0;
         $league1Count = 0;
         $league2Count = 0;
         $insideCount = 0;
         foreach ($userData as $user)
         {
         	$userCount++;
         	if($user['passes']['League1']==1)
         	{
         		$league1Count++;
         	}
         	if($user['passes']['League2']==1)
         	{
         		$league2Count++;
         	}
         	if($user['passes']['Inside']==1)
         	{
         		$insideCount++;
         	}
         }
         $this->view->userCount = $userCount;
         $this->view->league1Count = $league1Count;
         $this->view->league2Count = $league2Count;
         $this->view->insideCount = $insideCount;
    }
    


}

