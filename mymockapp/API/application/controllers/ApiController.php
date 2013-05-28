<?php

class ApiController extends Zend_Controller_Action {
	private $_Conn;
	private $_Sendgrid;
	private $airship;
	private $UA_APPKEY;
	private $UA_APPSECRET;
	private $UA_PUSHURL;
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
    	
    	$this->UA_APPSECRET= '3PfahF_gTTySVwneSJkGRA';
    	$this->UA_APPKEY = 'MeyBh5uVQ2OZPsqp5SYrGw';
    	 
    
    	
    	
    }
    public function indexAction()
    {
        //remove layout since this is a partial view
        $this->_helper->layout->disableLayout();
        $data = $this->getRequest()->getParams();
        
        // Create Airship object
        $airship = new Application_Model_UAHelper($this->UA_APPSECRET, $this->UA_APPKEY);
        //****************************************
        //Example device registration call for UA
        //****************************************
        /*
        $UA_Response = $airship->registerDevice('D2AE380876F0F02C3A9C002014A9FB911161BF980A508D9F6FF7A0CCB5AE993A', 'roger doger2',array());
        if($UA_Response !=1)
        {
        	echo "failed to register device - ".$UA_Response;
        }
        */
        //****************************************
        //Example send push notification UA
        //****************************************
        /*
        $UA_Response = $airship->sendPush(array("roger doger2"), 2, "Test Push, Sorry");
        if($UA_Response !=1)
        {
        	echo "failed to send push - ".$UA_Response;
        }
        */
        $this->_helper->json(array("status"=>"success"));
    }
    public function gettimetilllaunchAction()
    {
    	
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$numberOfSeconds= abs(time()-strtotime("15 April 2013"));
    	$this->_helper->json(array("status"=>"success","method"=>"getTimeTillLaunch","data"=>array("seconds"=>$numberOfSeconds,"flag"=>1)));
    }
    public function getplayerlistAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$playerInfoObj = new Application_Model_PlayerInfo();
    	$players = $playerInfoObj->getPlayerInfo($playerInfoObj, $this->_Conn);
    	$playerListArray = array();
    	foreach($players as $player)
    	{
    		array_push($playerListArray, $player);
    	}
    	$this->_helper->json(array("status"=>"success","method"=>"getPlayerList","data"=>$playerListArray));
    }
    public function getplayerrankingsAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	 
    	$playerInfoObj = new Application_Model_PlayerRanking();
    	$players = $playerInfoObj->getPlayerRankings($playerInfoObj, $this->_Conn);
    	$playerListArray = array();
    	foreach($players as $player)
    	{
    		array_push($playerListArray, $player);
    	}
    	$this->_helper->json(array("status"=>"success","method"=>"getPlayerRankings","data"=>$playerListArray));
    }
    public function getsettingsAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	 
    	$settingsObj = new Application_Model_Settings();
    	$settings = $settingsObj->getSettings($settingsObj, $this->_Conn);
    	$settingsArray = array();
    	foreach($settings as $setting)
    	{
    		array_push($settingsArray, $setting);
    	}
    	$this->_helper->json(array("status"=>"success","method"=>"getSettings","data"=>$settingsArray));
    }
    public function getspotinlineAction()
    {
    	 
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	//get all users to make sure this users is a registered user
    	$userObj = new Application_Model_User();
    	$user = $userObj->getUserByFacebookId($userObj, $data['facebookId'], $this->_Conn);
    	
    	if($user!=null && $user!='')
    	{
    		$inFront = $user['spotInLine']-1;
    		$countObj = new Application_Model_RegisteredCount();
    		$registeredCount = $countObj->getCount($countObj, $this->_Conn);
  			$total = $registeredCount['total'];
    		$this->_helper->json(array("status"=>"success","method"=>"getSpotInLine","data"=>array("infront"=>$inFront,"total"=>$total)));
    		
    	}
    	else
    		$this->_helper->json(array("status"=>"failure","method"=>"getSpotInLine","reason"=>"Sorry we could not find you as a user."));
    }
    public function getuserdataAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	 
    	//get all users to make sure this users is a registered user
    	$userObj = new Application_Model_User();
    	$user = $userObj->getUserByFacebookId($userObj, $data['facebookId'], $this->_Conn);
    	$this->_helper->json(array("status"=>"success","method"=>"getUserData","data"=>$user));
    	
    }
    public function getquestionAction()
    {
    
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	 
 
    	$userObj = new Application_Model_User();
    	$user = $userObj->getUserByFacebookId($userObj, $data['facebookId'], $this->_Conn);
    	 
    	if($user!=null && $user!='')
    	{
    		$questionObj = new Application_Model_Question();
    		$question = $questionObj->getQuestionByNumber($questionObj,$user['currentQuestion'], $this->_Conn);
    		if($question==null)
    		{
    			$this->_helper->json(array("status"=>"noquestion","method"=>"getQuestion"));
    		}
    		$this->_helper->json(array("status"=>"success","method"=>"getQuestion","data"=>array("text"=>$question['text'],"answers"=>$question['answers'])));
    	}
    	else
    	{
			$this->_helper->json(array("status"=>"failure","method"=>"getSpotInLine","reason"=>"Sorry we could not find you as a user."));
    	}
    		
    }
    public function answerquestionAction()
    {
    
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    
    	//get all users to make sure this users is a registered user
    	$userObj = new Application_Model_User();
    	$user = $userObj->getUserByFacebookId($userObj, $data['facebookId'], $this->_Conn);
    
    	if($user!=null && $user!='')
    	{   		
    		$answerObj = new Application_Model_Answer();
    		$answerObj->question = $data['question'];
    		$answerObj->userId = $data['facebookId'];
    		$answerObj->answer = $data['answer'];
    		
    		$answerObj->createAnswer($answerObj, $this->_Conn);
    		
    		//update user question
    		$userObj->incrementQuestionNumber($userObj, $data['facebookId'], $this->_Conn);
    		$userObj->decrementSpotByNumber($userObj,  $data['facebookId'], -10, $this->_Conn);
    		
    		$this->_helper->json(array("status"=>"success","method"=>"answerQuestion","data"=>$answerObj));
    	}
    	else
    	{
    		$this->_helper->json(array("status"=>"failure","method"=>"answerQuestion","reason"=>"Sorry we could not find you as a user."));
    	}
    
    }
    public function invitefriendAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$userObj = new Application_Model_User();
    	
    	
    	$userObj->decrementSpotByNumber($userObj, $data['facebookId'], -10, $this->_Conn);
    	$userObj->incrementInvitesNumber($userObj, $data['facebookId'], $this->_Conn);
    	
    	$user = $userObj->getUserByFacebookId($userObj, $data['facebookId'], $this->_Conn);
    	
    	$this->_helper->json(array("status"=>"success","method"=>"inviteFriend","data"=>$user));
    }
    public function automaticcountupdateAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	
    	//update the total count of users by random number(1-10)
    	$countObj = new Application_Model_RegisteredCount();
    	$registeredCount = $countObj->getCount($countObj, $this->_Conn);
    	$total = $registeredCount['total'];
    	$countObj->incrementCountByNumber($countObj,rand(1,15),$this->_Conn);
    	$registeredCount = $countObj->getCount($countObj, $this->_Conn);
    	$totalnew = $registeredCount['total'];
    	$this->_helper->json(array("status"=>"success","method"=>"updateCount","before"=>$total,"after"=>$totalnew));
    }
    public function automaticspotupdateAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	 
    	//update increase spot in line for each user by random number(1-5)
    	$userObj = new Application_Model_User();
    	$users = $userObj->getUsers($userObj, $this->_Conn);
    	foreach($users as $user)
    	{
    		$band = $userObj->incrementSpotByNumber($userObj,$user['facebookId'], rand(1, 10), $this->_Conn);
    		
    	}
    	$this->_helper->json(array("status"=>"success","method"=>"updatespot","band"=>$band));
    }
    public function checkversionAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	if($data['version']<2)
    	{
    		$airship = new Application_Model_UAHelper($this->UA_APPSECRET, $this->UA_APPKEY);
    		$UA_Response = $airship->sendPush(array("roger doger2"), 2, "Test Push, Sorry");
    	}
    }
    public function getmockdraftsAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$mockDraftObj = new Application_Model_MockDraft();
    	$mockDrafts = $mockDraftObj->getMockDraftsByFacebookId($mockDraftObj, $data['FacebookId'], $this->_Conn);
    	$draftArray = array();
    	foreach($mockDrafts as $draft)
    	{
    		array_push($draftArray, $draft);
    	}
    	
    	$this->_helper->json(array("status"=>"success","method"=>"createMockDraft","data"=>$draftArray));
    }
    public function lockmockdraftAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    
    	$mockDraftObj = new Application_Model_MockDraft();
    	$League = $data['league'];
    	$UserId = $data['userid'];
    	$time = new time();
    	$mockDraftObj->updateMockDraftSaveTimeByFacebookId($mockDraftObj, $UserId, $time, $League, $this->_Conn);
    }
    public function updateuserpurchasesAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$userObj = new Application_Model_User();
    	$jsonPasses = json_decode($data['passes']);
    	
    	$userObj->updateUserPurchaseByFacebookId($userObj, $data['userid'], $jsonPasses,$this->_Conn);
    	
    	$this->_helper->json(array("status"=>"success","method"=>"updateUserPurchases","data"=>$userObj));
    }
    public function howtoplayAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    }
    public function leagueresultsAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	
    	$settingsObj = new Application_Model_Settings();
    	$settings = $settingsObj->getSettings($settingsObj, $this->_Conn);
    	foreach ($settings as $setting)
    	{
    		$finalDraftOrder = $setting['FinalTeamPickOrder'];
    		$draftOder = $setting['TeamPickOrder'];
    		$playerPicks = $setting['PlayerPicks'];
    	}
    	foreach ($playerPicks as $pick)
    	{
    		
    	}
    	$finalDraftOrderArray = array_map('strtolower', $finalDraftOrder);
    	$draftOderArray = array_map('strtolower', $draftOder);
    	$playerPicksArray = array_map('strtolower',$playerPicks);
    	
    	//get each mock draft but for now just do 22401266
    	$mockDraftObj = new Application_Model_MockDraft();
    	$mockDrafts = $mockDraftObj->getMockDrafts($mockDraftObj, $this->_Conn);
    	foreach ($mockDrafts as $mockDraft)
    	{
    		$score = 100;
    		$picks = $mockDraft['Picks'];
    		$i=0;
    		
    		foreach ($picks as $pick)
    		{
    			
    			if($pick['Position']<=32)
    			{	
	    			//was this player in the first round?  If not -1 point
	    			if(!in_array($pick['PlayerName'], $playerPicksArray))
	    			{
	    				echo "Player ".$i." not in round ".$pick['PlayerName']." -4   |";
	    				$score = $score-4;
	    			}
	    			else
	    			{
		    			//exclusive deductions
		    			if($pick['PlayerName'] != $playerPicksArray[$i])
		    			{
		    				
		    				$x = array_search($pick['PlayerName'], $playerPicksArray);
		    				if($draftOder[$i] == $finalDraftOrder[$x])
		    				{
		    					//correct team and wrong position so -1
		    					$score = $score-1;
		    				}
		    				else
		    				{
		    					//wrong position and wrong team so -3
		    					$score = $score-3;
		    				}
		    				
		    			}
		    			else {
		    				$x = array_search($pick['PlayerName'], $playerPicksArray);
		    				if($draftOder[$i] != $finalDraftOrder[$x])
		    				{
		    					//correct position and wrong team so -2
		    					$score = $score-2;
		    				}
		    			}
	    			}
	    			$i++;
    			}
    			
    		}
    		if(count($picks)==0)
    		{
    			$score = 0;
    		}
    		$mockDraft['Score'] = $score;
    		$mockDraftObj->updateMockDraftScoreById($mockDraftObj, $mockDraft['_id'], $score, $this->_Conn);
    		echo "Score: ".$score;
    	}
    	$this->_helper->json(array("status"=>"success"));
    }
    public function savemockdraftAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	 
    	$mockDraftObj = new Application_Model_MockDraft();
    	$League = $data['league'];
    	$UserId = $data['userid'];
    	$jsonPicks = $data['picks'];
    	$jsonPicks = json_decode($jsonPicks);
    	$picksArray = array();
    	$i = 1;
    	foreach ($jsonPicks as $pick)
    	{
    		$pick = get_object_vars($pick);
    		$draftPick = new Application_Model_DraftPick();
    		$draftPick->PlayerId = $pick['PlayerId'];
    		$draftPick->PlayerName = $pick['PlayerName'];
    		$draftPick->Position = $i;
    		array_push($picksArray, $draftPick);
    		$i++;
    	}
    	$mockDraftObj->updateMockDraftByFacebookId($mockDraftObj, $UserId, $picksArray, $League, $this->_Conn);
    	
    	$this->_helper->json(array("status"=>"success","method"=>"updateMockDraft","data"=>$mockDraftObj));
    }
    public function createuserAction()
    {
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	//$data = $data['data'];
    	
    	//get number of registered users before you
    	$countObj = new Application_Model_RegisteredCount();
    	$registeredCount = $countObj->getCount($countObj, $this->_Conn);
    	$total = $registeredCount['total'];
    	
    	//get all current users to make sure we don't have dups
    	$userObj = new Application_Model_User();
    	$users = $userObj->getUsers($userObj, $this->_Conn);
    	$isDup = 0;
    	foreach ($users as $user)
    	{
    		if($user['facebookId']==$data['id'])
    		{
    			$isDup = 1;
    		}
    	}
    	
    	$userObj = new Application_Model_User();
    	$userObj->firstName = $data['firstname'];
    	$userObj->lastName = $data['lastname'];
    	$userObj->name = $data['name'];
    	$userObj->band =0;
    	$userObj->invites=0;
    	$userObj->passes = array("League0"=>0,"League1"=>0,"League2"=>0,"Inside"=>0);
    	$userObj->birthday = $data['birthday'];
    	$userObj->devices = $data['devices'];
    	$userObj->ageRange = $data['age_range'];
    	$userObj->email = $data['email'];
    	$userObj->facebookId = $data['id'];
    	$userObj->location = $data['location'];
    	$userObj->timezone = $data['timezone'];
    	$userObj->Longitude = $data['longitude'];
    	$userObj->Latitude = $data['latitude'];
    	$userObj->currentQuestion = 1;
    	$userObj->spotInLine = $total+1;
    	$userObj->CreatedOn = time();
    	$userObj->UpdatedOn = time();
    	$userObj->IsDeleted = false;
    	
    	if($isDup==0)
    	{
    		$userObj->createUser($userObj, $this->_Conn);
    		//$userData = $userObj->getUserByFacebookId($userObj, $userObj->facebookId, $this->_Conn);
    		
    		//Create there initial 3 blank drafts
    		$mockDraftObj = new Application_Model_MockDraft();
    		$mockDraftObj->League = "0";
    		$mockDraftObj->UserId = $userObj->facebookId;
    		$mockDraftObj->SaveDate = time();
    		$draftPicksArray = array();
    		for($i=1;$i<=64;$i++)
    		{
    		$draftPickObj = new Application_Model_DraftPick();
    		$draftPickObj->PlayerId = 0;
    		$draftPickObj->PlayerName = "";
    		$draftPickObj->Position = $i;
    		array_push($draftPicksArray, $draftPickObj);
    		}
    		$mockDraftObj->Picks = $draftPicksArray;
    		$mockDraftObj->createMockDraft($mockDraftObj, $this->_Conn);
    		
    		$mockDraftObj = new Application_Model_MockDraft();
    		$mockDraftObj->League = "1";
    		$mockDraftObj->UserId = $userObj->facebookId;
    		$mockDraftObj->SaveDate = time();
    		$draftPicksArray = array();
    		for($i=1;$i<=64;$i++)
    		{
    		$draftPickObj = new Application_Model_DraftPick();
    		$draftPickObj->PlayerId = 0;
    		$draftPickObj->PlayerName = "";
    		$draftPickObj->Position = $i;
    		array_push($draftPicksArray, $draftPickObj);
    		}
    		$mockDraftObj->Picks = $draftPicksArray;
    		$mockDraftObj->createMockDraft($mockDraftObj, $this->_Conn);
    		
    		$mockDraftObj = new Application_Model_MockDraft();
    		$mockDraftObj->League = "2";
    		$mockDraftObj->UserId = $userObj->facebookId;
    		$mockDraftObj->SaveDate = time();
    		$draftPicksArray = array();
    		for($i=1;$i<=64;$i++)
    		{
    		$draftPickObj = new Application_Model_DraftPick();
    		$draftPickObj->PlayerId = 0;
    		$draftPickObj->PlayerName = "";
    		$draftPickObj->Position = $i;
    		array_push($draftPicksArray, $draftPickObj);
    		}
    		$mockDraftObj->Picks = $draftPicksArray;
    		$mockDraftObj->createMockDraft($mockDraftObj, $this->_Conn);
    		
    		$countObj->incrementCount($countObj, $this->_Conn);
    	}
    	
    	$this->_helper->json(array("status"=>"success","method"=>"createuser","data"=>$userObj));
    }
	function cmp($a,$b){
	    //get which string is less or 0 if both are the same
	    $cmp = strcasecmp($a->Name, $b->Name);
	    //if the strings are the same, check name
	    return $cmp;
	}
	public function getpositionsAction()
	{
		$this->_helper->layout->disableLayout();
		$data = $this->getRequest()->getParams();
		
		$positionsObj = new Application_Model_Position();
		$positions = $positionsObj->getPositions($positionsObj, $this->_Conn);
		
		$this->_helper->json(array("status"=>"success","method"=>"getpositions","data"=>$positions['Positions']));
	}
	
    public function importmockdraftAction()
    {
    	error_reporting(E_ERROR);
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	require_once 'reader.php';
    	$playerArray = array();
    	
    	// ExcelFile($filename, $encoding);
    	$data = new Spreadsheet_Excel_Reader();
    	
    	
    	// Set output Encoding.
    	$data->setOutputEncoding('CP1252');
    	
    	$data->read('mockdrafts.xls');
    	
    	for ($i = 1; $i <= $data->sheets[0]['numRows']; $i++) {
    		//$ingredientsArray[$i] = array();
    		for ($j = 1; $j<=6; $j++)
    		{
    			if($data->sheets[0]['cells'][$i][$j]!=null)
    				{
    					
    					$tempName = $data->sheets[0]['cells'][$i][$j];
    					$tempName = explode(",", $tempName);
    					$isSaved = 0;
    					$tempArray = array();
    					//echo "Rank: ".$i." Name: ".strtolower($tempName[0])." Count: 0\n";
    					foreach ($playerArray as $player)
    					{
    						if($player['Name']==strtolower($tempName[0]) && $player['Rank']==$i)
    						{
    							$isSaved=1;
    							
    							$count = intval($player['Count'])+1;
    							$player['Count']=$count;
    							$player['Percentage'] = number_format((($count/6)*100),0);
    						}
    						array_push($tempArray, $player);
    					}
    					
    					if($isSaved==0)
    					{
    						array_push($tempArray, array("Rank"=>$i,"Name"=>strtolower($tempName[0]),"Count"=>1,"Percentage"=>number_format(((1/6)*100),2)));
 	  					}
    					$playerArray = $tempArray;
    					//echo "Name: ".strtolower($tempName[0])."   |";
    				
    				}
    		}
    	}
    	
    	usort($playerArray, 'cmp');
    	foreach ($playerArray as $player)
    	{
    		$playerRankingObj = new Application_Model_PlayerRanking();
    		$playerRankingObj->Name = $player['Name'];
    		$playerRankingObj->Rank = $player['Rank'];
    		$playerRankingObj->Percentage = $player['Percentage'];
    		$playerRankingObj->createPlayerRanking($playerRankingObj, $this->_Conn);
    		//echo "Rank: ".$player['Rank']." Name: ".$player['Name']." Count: ".$player['Count']." Percentage: ".$player['Percentage']."\n";
    	}
    	$this->_helper->json($playerArray);
    }
    public function importcombineinfoAction()
    {
    	error_reporting(E_ERROR);
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	require_once 'reader.php';
    	$playerArray = array();
    	
    	// ExcelFile($filename, $encoding);
    	$data = new Spreadsheet_Excel_Reader();
    	
    	
    	// Set output Encoding.
    	$data->setOutputEncoding('CP1252');
    	
    	$data->read('combineinfo.xls');
    	for($s=0;$s<26;$s++)
    	{
	    	for ($i = 5; $i <= $data->sheets[$s]['numRows']; $i++) {
	    	
	    		if($data->sheets[$s]['cells'][$i][5]!=null)
	    		{
	    			$LastName = $data->sheets[$s]['cells'][$i][1];
	    			$FirstName = $data->sheets[$s]['cells'][$i][4];
	    			$tenYard = $data->sheets[$s]['cells'][$i][15];
	    			$tenYardBest = "";
	    			if($tenYard == null || $tenYard==" " || $tenYard == "" || $tenYard == "   ")
	    			{
	    				$tenYardBest = "-";
	    			}
	    			else
	    			{
	    				$tenYard = explode("\r", $tenYard);
	    				$tenYardBest = $tenYard[0];
	    				foreach ($tenYard as $ten)
	    				{
	    					if($ten < $tenYardBest && $ten!=0 && $ten != null)
	    					{
	    						$tenYardBest = $ten;
	    					}
	    				}
	    			}
	    			$twentyYard = $data->sheets[$s]['cells'][$i][17];
	    			$twentyYardBest = "";
	    			if($twentyYard == null || $twentyYard==" " || $twentyYard == "" || $twentyYard == "   ")
	    			{
	    				$twentyYardBest = "-";
	    			}
	    			else
	    			{
	    				$twentyYard = explode("\r", $twentyYard);
	    				$twentyYardBest = $twentyYard[0];
	    				foreach ($twentyYard as $ten)
	    				{
	    					if($ten < $twentyYardBest && $ten!=0 && $ten != null)
	    					{
	    						$twentyYardBest = $ten;
	    					}
	    				}
	    			}
	    			$fortyYard = $data->sheets[$s]['cells'][$i][19];
	    			$fortyYardBest = "";
	    			if($fortyYard == null || $fortyYard==" " || $fortyYard == "" || $fortyYard == "   ")
	    			{
	    				$fortyYardBest = "-";
	    			}
	    			else
	    			{
	    				$fortyYard = explode("\r", $fortyYard);
	    				$fortyYardBest = $fortyYard[0];
	    				foreach ($fortyYard as $ten)
	    				{
	    					if($ten < $fortyYardBest && $ten!=0 && $ten != null)
	    					{
	    						$fortyYardBest = $ten;
	    					}
	    				}
	    			}
	    			$verticalJump = $data->sheets[$s]['cells'][$i][20];
	    			$verticalJumpBest = "";
	    			if($verticalJump == null || $verticalJump==" " || $verticalJump == "" || $verticalJump == "   ")
	    			{
	    				$verticalJumpBest = "-";
	    			}
	    			else
	    			{
	    				$verticalJump = explode("\r", $verticalJump);
	    				$verticalJumpBest = $verticalJump[0];
	    				foreach ($verticalJump as $ten)
	    				{
	    					if($ten > $verticalJumpBest && $ten!=0 && $ten != null)
	    					{
	    						$verticalJumpBest = $ten;
	    					}
	    				}
	    			}
	    			$broadJump = $data->sheets[$s]['cells'][$i][21];
	    			$broadJumpBest = "";
	    			if($broadJump == null || $broadJump==" " || $broadJump == "" || $broadJump == "   ")
	    			{
	    				$broadJumpBest = "-";
	    			}
	    			else
	    			{
	    				$broadJump = explode("\r", $broadJump);
	    				$broadJumpBest = $broadJump[0];
	    				foreach ($broadJump as $ten)
	    				{
	    					if($ten > $broadJumpBest && $ten!=0 && $ten != null)
	    					{
	    						$broadJumpBest = $ten;
	    					}
	    				}
	    			}
	    			$shuttle = $data->sheets[$s]['cells'][$i][22];
	    			$shuttleBest = "";
	    			if($shuttle == null || $shuttle==" " || $shuttle == "" || $shuttle == "   ")
	    			{
	    				$shuttleBest = "-";
	    			}
	    			else
	    			{
	    				$shuttle = explode("\r", $shuttle);
	    				$shuttleBest = $shuttle[0];
	    				foreach ($shuttle as $ten)
	    				{
	    					if($ten < $shuttleBest && $ten!=0 && $ten != null)
	    					{
	    						$shuttleBest = $ten;
	    					}
	    				}
	    			}
	    			$cone = $data->sheets[$s]['cells'][$i][26];
	    			$coneBest = "";
	    			if($cone == null || $cone==" " || $cone == "" || $cone == "   ")
	    			{
	    				$coneBest = "-";
	    			}
	    			else
	    			{
	    				$cone = explode("\r", $cone);
	    				$coneBest = $cone[0];
	    				foreach ($cone as $ten)
	    				{
	    					if($ten < $coneBest && $ten!=0 && $ten != null)
	    					{
	    						$coneBest = $ten;
	    					}
	    				}
	    			}
	    			
	    			echo "Name: ".str_replace("\r", "",strtolower($FirstName." ".$LastName))." 10 Yard ".$tenYardBest." 20 Yard ".$twentyYardBest." 40 Yard ".$fortyYardBest." Vertical ".$verticalJumpBest." Broad ".$broadJumpBest." Shuttle ".$shuttleBest." Cone ".$coneBest."\n";
	    			$playerInfoObj = new Application_Model_PlayerInfo();
	    			
	    			$playerInfoObj->updateWithCombine($playerInfoObj,str_replace("\r", "",strtolower($FirstName." ".$LastName)),$fortyYardBest,$twentyYardBest,$tenYardBest,$verticalJumpBest,$broadJumpBest,$shuttleBest,$coneBest, $this->_Conn);
	    		}
	    	}
    	}
    	$this->_helper->json($playerArray);
    }
    public function importplayerinfoAction()
    {
    	error_reporting(E_ERROR);
    	//remove layout since this is a partial view
    	$this->_helper->layout->disableLayout();
    	$data = $this->getRequest()->getParams();
    	require_once 'reader.php';
    	$playerArray = array();
    	 
    	// ExcelFile($filename, $encoding);
    	$data = new Spreadsheet_Excel_Reader();
    	 
    	 
    	// Set output Encoding.
    	$data->setOutputEncoding('CP1252');
    	 
    	$data->read('playerinfo.xls');
    	 
    	for ($i = 1; $i <= $data->sheets[0]['numRows']; $i++) {
    		
    		if($data->sheets[0]['cells'][$i][1]!=null)
    		{
    			$Name = $data->sheets[0]['cells'][$i][1];
    			if($Name[0]=="*")
    			{
    				$Name = substr($Name, 1);
    			}
    			$Name = strtolower($Name);
    			$Position = $data->sheets[0]['cells'][$i][2];
    			$School = $data->sheets[0]['cells'][$i][3];
    			$Year = $data->sheets[0]['cells'][$i][4];
    			$Height = $data->sheets[0]['cells'][$i][5];
    			$Weight = $data->sheets[0]['cells'][$i][6];
    			
    			$playerInfoObj = new Application_Model_PlayerInfo();
    			$playerInfoObj->Name = $Name;
    			$playerInfoObj->Position = $Position;
    			$playerInfoObj->School = $School;
    			$playerInfoObj->Year = $Year;
    			$playerInfoObj->Height = $Height;
    			$playerInfoObj->Weight = $Weight;
    			$playerInfoObj->Rank = $i;
    			
    			array_push($playerArray, $playerInfoObj);
    			
    			$playerInfoObj->createPlayerInfo($playerInfoObj, $this->_Conn);
    		}
    	}
    		
    	$this->_helper->json($playerArray);
    }
}