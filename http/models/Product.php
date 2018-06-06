<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Product extends BaseModel {
	/**
	 * @AttributeType int
	 */
	private $companyID;
	/**
	 * @AttributeType models.Status
	 */
	private $status;
	/**
	 * @AttributeType string
	 */
	private $title;
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
		
		    $this->ownerType   = EOwnerType::Product;
		    $this->name         = 'Product';
		    $this->route        = 'product';
		    $this->table        = 'products';
		
		    $this->statuses     = array(
		        'active'    => ESharedStatus::ProductActive,
		        'disabled'  => ESharedStatus::ProductDisabled,
		        'deleted'   => ESharedStatus::ProductDeleted,
		    );
		
		    $this->dataFields  = array(
		        'company_id',
		        'status_id',
		        'title',
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
		if (isset($data['_id']))
		    $this->setID($data['_id']);
		if (isset($data['company_id']))
		    $this->setCompanyID($data['company_id']);
		if (isset($data['status_id']))
		{
		    $status = new Status();
		    $status->getByID($data['status_id']);
		    $this->setStatus($status);
		}
		if (isset($data['title']))
		    $this->setTitle($data['title']);
		if (isset($data['description']))
		    $this->setDescription($data['description']);
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
		
		try{
		
		    $sql = "SELECT `p`.*, `c`.`title` as `company_description`, `s`.`background`, `s`.`foreground`, `s`.`description` as `status_description`
		            FROM `{$this->table}` as `p`
		            INNER JOIN `shared_statuses` as `s` ON `p`.`status_id` = `s`.`_id`
		            INNER JOIN `companies` as `c` ON `c`.`_id` = `p`.`company_id`
		            WHERE `p`.`status_id` != '{$this->statuses['deleted']}' 
		            ORDER BY `p`.`title`";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $data[] = array_map('utf8_encode', $row);
		    }
		
		    $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
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
	 * Function to get list records with offset
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
		$data = array();
		
		try{
		    session_start();
		
		    $offset = ($current_page - 1) * $page_size;
		
		    $sql = "SELECT `p`.*, `c`.`title` as `company_description`, `s`.`background`, `s`.`foreground`, `s`.`description` as `status_description`
				            FROM `{$this->table}` as `p`
				            INNER JOIN `shared_statuses` as `s` ON `p`.`status_id` = `s`.`_id`
				            INNER JOIN `companies` as `c` ON `c`.`_id` = `p`.`company_id`
				            WHERE `p`.`status_id` != '{$this->statuses['deleted']}' 
				            ORDER BY `p`.`title` LIMIT $offset, $page_size";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $records = array();
		
		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $records[] = array_map('utf8_encode', $row);
		    }
		
		    $data['records'] = $records;
		
		    $sql = "SELECT COUNT(*) as `count`
		            FROM `{$this->table}` as `p`
		            INNER JOIN `shared_statuses` as `s` ON `p`.`status_id` = `s`.`_id`
		            INNER JOIN `companies` as `c` ON `c`.`_id` = `p`.`company_id`
		            WHERE `p`.`status_id` != '{$this->statuses['deleted']}' 
		            ORDER BY `p`.`title`";
		
		    $result = $this->conn->RunQuery($sql);
		    $response = $this->conn->FetchHash($result);
		
		    $data['item_size'] = $response['count'];
		
		    $data['display_size'] = (($current_page - 1) * $page_size) + count($data['records']);
		
		    $data['number_pages'] = 1;
		
		    if ($data['item_size'] > $page_size)
		        $data['number_pages'] = ceil($data['item_size'] / $page_size);
		
		    $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
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
	 * Function to get products given client ID
	 * @access public
	 * @param int id
	 * @return array
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getProductsByClientID($id) {
		$data = array();
		
		try{
		
		    $sql = "SELECT `p`.*
		            FROM `{$this->table}` as `p`
		            INNER JOIN `products_clients` as `d` ON `d`.`product_id` = `p`.`_id`
		            WHERE `d`.`client_user_id` = '{$id}' AND `p`.`status_id` != '{$this->statuses['deleted']}' 
		            ORDER BY `p`.`title`";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    while( $row = $this->conn->FetchHash($result)){
		        $data[] = array_map('utf8_encode', $row);
		    }
		
		    $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
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
	 * @param int companyID
	 * @ParamType companyID int
	 */
	public function setCompanyID($companyID) {
		$this->companyID = $companyID;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getCompanyID() {
		return $this->companyID;
	}

	/**
	 * @access public
	 * @param models.Status status
	 * @ParamType status models.Status
	 */
	public function setStatus(Status $status) {
		$this->status = $status;
	}

	/**
	 * @access public
	 * @return models.Status
	 * @ReturnType models.Status
	 */
	public function getStatus() {
		return $this->status;
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
}
?>