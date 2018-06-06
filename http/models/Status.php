<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Status extends BaseModel {
	/**
	 * @AttributeType models.EOwnerType
	 */
	private $owner;
	/**
	 * @AttributeType char
	 */
	private $status;
	/**
	 * @AttributeType string
	 */
	private $description;
	/**
	 * @AttributeType string
	 */
	private $background;
	/**
	 * @AttributeType string
	 */
	private $foreground;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = null;
		    $this->name         = 'Status';
		    $this->route        = 'status_id';
		    $this->table        = 'shared_statuses';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        'owner',
		        'status_id',
		        'description',
		        'background',
		        'foreground',
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
		if (isset($data['owner']))
		{
		    $type = new EOwnerType();
		    $type->setValue($data['owner']);
		    $this->setOwner($type);
		}
		if (isset($data['description']))
		    $this->setDescription($data['description']);
		if (isset($data['background']))
		    $this->setBackground($data['background']);
		if (isset($data['foreground']))
		    $this->setForeground($data['foreground']);
		
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
		
		$sql = "SELECT * FROM `{$this->table}` WHERE `owner` = '{$owner}'  ORDER BY `description`";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
		return $data;
	}

	/**
	 * 
	 * Function to get status by owner and type
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string owner
	 * @param int type
	 * @return array
	 * @ParamType owner string
	 * @ParamType type int
	 * @ReturnType array
	 */
	public function getByOwnerType($owner, $type) {
		// Get the status color for the new state
		$sql = "SELECT * FROM `{$this->table}` WHERE `owner` = '{$owner}' AND `_id` = '{$type}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql);
		
		$result = $this->conn->RunQuery($sql);
		$data = $this->conn->FetchHash($result);
		
		return $data;
	}

	/**
	 * @access public
	 * @param models.EOwnerType owner
	 * @ParamType owner models.EOwnerType
	 */
	public function setOwner(EOwnerType $owner) {
		$this->owner = $owner;
	}

	/**
	 * @access public
	 * @return models.EOwnerType
	 * @ReturnType models.EOwnerType
	 */
	public function getOwner() {
		return $this->owner;
	}

	/**
	 * @access public
	 * @param string status
	 * @ParamType status char
	 */
	public function setStatus($status) {
		$this->status = $status;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType char
	 */
	public function getStatus() {
		return $this->status;
	}

	/**
	 * @access public
	 * @param string description
	 * @ParamType description string
	 */
	public function setDescription($description) {
		$this->description = $description;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getDescription() {
		return $this->description;
	}

	/**
	 * @access public
	 * @param string background
	 * @ParamType background string
	 */
	public function setBackground($background) {
		$this->background = $background;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getBackground() {
		return $this->background;
	}

	/**
	 * @access public
	 * @param string foreground
	 * @ParamType foreground string
	 */
	public function setForeground($foreground) {
		$this->foreground = $foreground;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getForeground() {
		return $this->foreground;
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
		    $sql_count = "SELECT COUNT(*) as `count FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}";
		}
		else
		{
		    // @TODO set sql for records within the offset and range that the user can see
		    $sql = "SELECT * FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}'  
		                    ORDER BY `c`.`title` LIMIT $offset, $page_size";
		    // @TODO set sql_count for the number of all records that the user can see
		    $sql_count = "SELECT COUNT(*) as `count FROM {$this->table}
		                    WHERE`status_id` != '{$this->statuses['deleted']}";
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