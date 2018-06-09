<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Type extends BaseModel {
	/**
	 * @AttributeType models.EOwnerType
	 */
	private $owner;
	/**
	 * @AttributeType string
	 */
	private $title;
    /**
     * @AttributeType string
     */
    private $icon;
	/**
	 * @AttributeType string
	 */
	private $description;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $this->ownerType   = null;
		    $this->name         = 'Type';
		    $this->route        = 'type_id';
		    $this->table        = 'shared_types';
		
		    $this->statuses     = array();
		
		    $this->dataFields  = array(
		        'owner',
		        'title',
		        'icon',
		        'description',
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
		if (isset($data['title']))
		    $this->setTitle($data['title']);
		if (isset($data['description']))
		    $this->setDescription($data['description']);
		
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
		
		if (!empty($exclude))
		{
		    $exclude_str = implode(",", $exclude);

            if (!empty($owner))
		        $sql = "SELECT * FROM `shared_types` WHERE `owner` = '{$owner}' AND `_id` NOT IN ($exclude_str)  ORDER BY `title`";
            else
                $sql = "SELECT * FROM `shared_types` WHERE `_id` NOT IN ($exclude_str)  ORDER BY `title`";
		}
		else
        {
            if (!empty($owner))
                $sql = "SELECT * FROM `shared_types` WHERE `owner` = '{$owner}'  ORDER BY `title`";
            else
                $sql = "SELECT * FROM `shared_types` ORDER BY `title`";
        }

		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    $data[] = array_map('utf8_encode', $row);
		}
		
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
	 * @param string title
	 * @ParamType title string
	 */
	public function setTitle($title) {
		$this->title = $title;
	}


    /**
     * @access public
     * @return string
     * @ReturnType string
     */
    public function getIcon() {
        return $this->icon;
    }

    /**
     * @access public
     * @param string title
     * @ParamType title string
     */
    public function setIcon($icon) {
        $this->icon = $icon;
    }

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getTitle() {
		return $this->title;
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