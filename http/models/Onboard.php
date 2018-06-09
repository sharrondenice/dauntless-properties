<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Onboard extends BaseModel {
	/**
	 * @AttributeType string
	 */
	private $accessKey;
	/**
	 * @AttributeType int
	 */
	private $granterID;
	/**
	 * @AttributeType models.Type
	 */
	private $type;
	/**
	 * @AttributeType string
	 */
	private $email;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = EOwnerType::User;
		    $this->name         = 'Onboarding';
		    $this->route        = 'onboard';
		    $this->table        = 'users_onboarding';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        'access_key',
		        'granter_id',
		        'type_id',
		        'email',
		    );
		} catch (Exception $e){
		    if (TSP_Config::get('app.debug'))
		        $this->response['admin_error'][] = $e->getMessage();
		
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (100) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

		}
	}

	/**
	 * Function to set the object given an array of data
	 * @access public
	 * @param string[] data
	 * @return void
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function set(array &$data) {
		if (isset($data['access_key']))
		    $this->setAccessKey($data['access_key']);
		if (isset($data['granter_id']))
		    $this->setGranterID($data['granter_id']);
		if (isset($data['type_id']))
		{
		    $type = new Type();
		    $type->getByID($data['type_id']);
		    $this->setType($type);
		}
		if (isset($data['email']))
		    $this->setEmail($data['email']);
		
		if (isset($data['_id']))
		    $this->setID($data['_id']);
		if (isset($data['date_created']))
		    $this->setDateCreated($data['date_created']);
		if (isset($data['date_last_updated']))
		    $this->setDateLastUpdated($data['date_last_updated']);
	}

	/**
	 * Function to get list of all pending users
	 * @access public
	 * @param string owner
	 * @param int type
	 * @param int[] exclude
	 * @return array
	 * @ParamType owner string
	 * @ParamType type int
	 * @ParamType exclude int[]
	 * @ReturnType array
	 */
	public function getAll($owner = null, $type = null, array $exclude = array()) {
		$data = array();
		
		$sql = "SELECT * FROM `{$this->table}` ORDER BY `date_created`";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

	/**
	 * Function to get record by current access key
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getOnboard() {
		$data = array();
		
		try{
		    $sql = "SELECT * FROM `{$this->table}` WHERE `access_key` = '".$this->getAccessKey()."'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
		} catch (Exception $e){
		    if (TSP_Config::get('app.debug'))
		    {
		        $this->response['admin_error'][] = $e->getMessage();
		    }
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

		}
		
		return $data;
	}

	/**
	 * Function to get unregistered record by current access key
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getUnregisteredOnboard() {
		$data = array();
		
		try{
		    $sql = "SELECT * FROM `{$this->table}` WHERE `access_key` = '".$this->getAccessKey()."' AND `date_last_updated` IS NULL";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);
		
		    if (!empty($data))
		        $this->set($data);
		
		} catch (Exception $e){
		    if (TSP_Config::get('app.debug'))
		    {
		        $this->response['admin_error'][] = $e->getMessage();
		    }
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unknown error (301) occurred. Please contact your system administrator or try again at a later time.',
                'type' => 'error',
            );

		}
		
		return $data;
	}

	/**
	 * @access public
	 * @param string accessKey
	 * @ParamType accessKey string
	 */
	public function setAccessKey($accessKey) {
		$this->accessKey = $accessKey;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getAccessKey() {
		return $this->accessKey;
	}

	/**
	 * @access public
	 * @param int granterID
	 * @ParamType granterID int
	 */
	public function setGranterID($granterID) {
		$this->granterID = $granterID;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getGranterID() {
		return $this->granterID;
	}

	/**
	 * @access public
	 * @param models.Type type
	 * @ParamType type models.Type
	 */
	public function setType(Type $type) {
		$this->type = $type;
	}

	/**
	 * @access public
	 * @return models.Type
	 * @ReturnType models.Type
	 */
	public function getType() {
		return $this->type;
	}

	/**
	 * @access public
	 * @param string email
	 * @ParamType email string
	 */
	public function setEmail($email) {
		$this->email = $email;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getEmail() {
		return $this->email;
	}

	/**
	 * Function to get list records
	 * @access public
	 * @param int current_page
	 * @param int page_size
	 * @param string owner
	 * @param int type
	 * @param int[] exclude
	 * @return array
	 * @ParamType current_page int
	 * @ParamType page_size int
	 * @ParamType owner string
	 * @ParamType type int
	 * @ParamType exclude int[]
	 * @ReturnType array
	 */
	public function getAllWithOffset($current_page, $page_size, $owner = null, $type = null, array $exclude = array()) {
		// @TODO set default owner if null
		// @TODO set default type if null
		
		$offset = ($current_page - 1) * $page_size;
		
		 if ($_SESSION['type_id'] == ESharedType::Admin)
		{
		    // @TODO set sql for records within the offset and range
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		
		    // @TODO set sql_count for the number of all records
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}
		                    WHERE `status_id` != '{$this->statuses['deleted']}'";
		}
		else
		{
		    // @TODO set sql for records within the offset and range that the user can see
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		    // @TODO set sql_count for the number of all records that the user can see
		    $sql_count = "SELECT COUNT(*) as `count` FROM {$this->table}
		                    WHERE `status_id` != '{$this->statuses['deleted']}'";
		}
		
		$data['records'] = $this->getBySQL($sql);
		        
		$result = $this->conn->RunQuery($sql_count);
		$response = $this->conn->FetchHash($result);
		        
		$data['item_size'] = $response['count'];
		        
		$data['display_size'] = (($current_page - 1) * $page_size) + count($data['users']);
		        
		$data['number_pages'] = 1;
		        
		if ($data['item_size'] > $page_size)
		    $data['number_pages'] = ceil($data['item_size'] / $page_size);
	}
}
?>