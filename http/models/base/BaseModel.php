<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models.base
 */
abstract class BaseModel {
	/**
	 * @AttributeType int
	 */
	private $ID;
	public $conn = null;
	/**
	 * @AttributeType array
	 */
	public $response = array();
	/**
	 * @AttributeType models.EOwnerType
	 */
	public $ownerType;
	/**
	 * @AttributeType string
	 */
	public $name = null;
	/**
	 * @AttributeType string
	 */
	public $route = null;
	/**
	 * @AttributeType string
	 */
	public $table = null;
	/**
	 * @AttributeType array
	 */
	public $statuses = array();
	/**
	 * @AttributeType array
	 */
	public $objectTypes = array();
	/**
	 * @AttributeType array
	 */
	public $dataFields = array();
	/**
	 * @AttributeType int
	 */
	private $dateLastUpdated;
	/**
	 * @AttributeType int
	 */
	private $dateCreated;

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    $this->ID = $id;
		
		    $this->conn = new TSP_Database('database');
		    $this->response = array();
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
	 * Function to set the current record
	 * @access public
	 * @param string[] data
	 * @return array
	 * @ParamType data string[]
	 * @ReturnType array
	 */
	public abstract function set(array &$data);

	/**
	 * Function to get list records
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
	public abstract function getAll($owner = null, $type = null, array $exclude = array());

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
	public abstract function getAllWithOffset($current_page, $page_size, $owner = null, $type = null, array $exclude = array());

	/**
	 * Function to get the class variables as an array
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function toArray() {
		$data = array();
		
		$reflection = new ReflectionClass(get_called_class());
		$properties = $reflection->getProperties(ReflectionProperty::IS_PRIVATE);
		
		foreach ($properties as $index => $object)
		{
		    $funcName = 'get' . ucfirst($object->name);
		    $varName = $object->name;
		
		    $data[$varName] = $this->$funcName();
		}
		
		return $data;
	}

	/**
	 * Function to get the class variables as an object
	 * @access public
	 * @return stdClass
	 * @ReturnType stdClass
	 */
	public function toObject() {
		$data = stdClass();
		
		$reflection = new ReflectionClass(get_called_class());
		$properties = $reflection->getProperties(ReflectionProperty::IS_PRIVATE);
		
		foreach ($properties as $index => $object)
		{
		    $funcName = 'get' . ucfirst($object->name);
		    $varName = $object->name;
		
		    $data->$$varName = $this->$funcName();
		}
		
		return $data;
	}

	/**
	 * Function to add record data
	 * @access public
	 * @param string[] data
	 * @return int
	 * @ParamType data string[]
	 * @ReturnType int
	 */
	public function add(array $data = array()) {
		$fields = "";
		$values = "";
		
		foreach ($data as $key => $value)
		{
		    if (!in_array($key, $this->dataFields))
		        continue;
		    else if ($value == 'null' || $value == 'undefined')
		        continue;
		
		    if (empty($value))
		    {
		        $fields .= "`$key`, ";
		        $values .= "NULL, ";
		    }
		    else
		    {
		        $fields .= "`$key`, ";
		        $values .= "'". addslashes($value) . "', ";
		    }
		}
		
		// Save Profile into the database
		$sql = "INSERT INTO `{$this->table}` ({$fields}`date_created`) VALUES (
		            {$values}NOW())";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$this->conn->RunQuery($sql);
		
		$record_id = $this->conn->LastInsertID();
		
		return $record_id;
	}

	/**
	 * Function to update record data
	 * @access public
	 * @param string[] data
	 * @return void
	 * @ParamType data string[]
	 * @ReturnType void
	 */
	public function update(array $data = array()) {
		$values = "";
		
		foreach ($data as $key => $value)
		{
		    if (!in_array($key, $this->dataFields))
		        continue;
		    else if ($value == 'null' || $value == 'undefined')
		        continue;
		
		    if (empty($value))
		        $values .= "`{$key}` = NULL, ";
		    else
            {
                $values .= "`{$key}` = '" . addslashes($value) . "', ";
            }
		}
		
		// Save Profile into the database
		$sql = "UPDATE `{$this->table}` SET 
		                            {$values}
		                            `date_last_updated` = NOW() WHERE `_id` = '{$data['_id']}'";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$this->conn->RunQuery($sql);
	}

	/**
	 * Function to delete record data
	 * @access public
	 * @param int ID
	 * @return array
	 * @ParamType ID int
	 * @ReturnType array
	 */
	public function delete($ID) {
		$data = array();
		
		try{
		    $sql = "DELETE FROM `{$this->table}` WHERE `_id` = '$ID'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql);
		
		    $this->conn->RunQuery($sql);

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $this->getName() . ' deleted successfully.',
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
	 * Function to deactivate record data
	 * @access public
	 * @param int ID
	 * @return array
	 * @ParamType ID int
	 * @ReturnType array
	 */
	public function deactivate($ID) {
		$data = array();
		
		try{
		    $sql = "UPDATE `{$this->table}` SET `status_id` = '".$this->statuses['disabled']."' WHERE `_id` = '$ID'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql);
		
		    $this->conn->RunQuery($sql);

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $this->getName() . ' deactivated successfully.',
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
	 * Function to activate record
	 * @access public
	 * @param int ID
	 * @return array
	 * @ParamType ID int
	 * @ReturnType array
	 */
	public function activate($ID) {
		$data = array();
		
		try{
		    $sql = "UPDATE `{$this->table}` SET `status_id` = '".$this->statuses['active']."' WHERE `_id` = '$ID'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql);
		
		    $this->conn->RunQuery($sql);
		
		    // Get the status color for the new state
		    $sql = "SELECT * FROM `shared_statuses` WHERE `owner` = '{$this->ownerType}' AND `_id` = '{$this->statuses['active']}'";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql);
		
		    $result = $this->conn->RunQuery($sql);
		    $data = $this->conn->FetchHash($result);

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => $this->getName() . ' activated successfully.',
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
	 * @param int ID
	 * @return array
	 * @ParamType ID int
	 * @ReturnType array
	 */
	public function getByID($ID) {
		$data = array();
		
		try{
		    $sql = "SELECT * FROM `{$this->table}` WHERE `_id` = '{$ID}'";
		
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
	 * Function to get data given a list of params
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public function getByParams(array $params) {
		$data = array();
		
		try{
		    $param_str = "";
		
		    foreach ($params as $key => $value)
		    {
		        $param_str .= "`$key` = '$value' AND ";
		    }
		
		    if (!empty($param_str))
		    {
		        $param_str = preg_replace("/( AND )$/", "", $param_str);
		
		        $sql = "SELECT * FROM `{$this->table}` WHERE $param_str";
		
		        if (TSP_Config::get('app.debug'))
		            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		        $result = $this->conn->RunQuery($sql);
		        while( $row = $this->conn->FetchHash($result)){
		            $data[] = array_map('utf8_encode', $row);
		        }
		
		        if (!empty($data))
		            $this->set($data);
		    }
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
	 * Function to get record by SQL
	 * @access public
	 * @param string sql
	 * @return array
	 * @ParamType sql string
	 * @ReturnType array
	 */
	public function getBySQL($sql) {
		$data = array();
		
		try
		{
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		
		    while( $row = $this->conn->FetchHash($result)){
		        $data[] = array_map('utf8_encode', $row);
		    }
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
	 * Function to get count given a list of params
	 * @access public
	 * @param string field
	 * @param int type
	 * @return int
	 * @ParamType field string
	 * @ParamType type int
	 * @ReturnType int
	 */
	public function getCountByField($field, $type = null) {
		$count = 0;
		
		try{
		    if ($this->getTable() == 'users' && $_SESSION['type_id'] != ESharedType::Admin)
		    {
		        // Only allow users to view their descendants and nothing more
		        $descendants = $this->getDescendants($_SESSION['_id']);
		        $descendants = $this->parseDescendantsByType($descendants, $type);
		        $descendants = implode(",", $descendants);
		
		        if (empty($descendants))
		            $descendants = "''";
		
		        $sql = "SELECT COUNT(DISTINCT {$field}) as count FROM `{$this->table}` WHERE `_id` IN ({$descendants})";
		    }
		    else if ($this->getTable() == 'products_employees' && $_SESSION['type_id'] != ESharedType::Admin)
		    {
		        // Only allow users to view their descendants and nothing more
		        $user = new User;
		        $descendants = $user->getDescendants($_SESSION['_id']);
		        $descendants = $user->parseDescendantsByType($descendants, $type);
		        $descendants = implode(",", $descendants);
		
		        if (empty($descendants))
		            $descendants = "''";
		
		        $sql = "SELECT COUNT(DISTINCT `pe`.{$field}) as count FROM `users` as `u`
		                INNER JOIN `{$this->table}` as `pe` ON `pe`.employee_id = `u`._id
		                WHERE `u`._id IN ({$descendants})";
		    }
		    else
		        $sql = "SELECT COUNT(DISTINCT {$field}) as count FROM `{$this->table}`";
		
		    if (TSP_Config::get('app.debug'))
		        $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		    $result = $this->conn->RunQuery($sql);
		    $response = $this->conn->FetchHash($result);
		
		    $count = $response['count'];
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
		
		return $count;
	}

	/**
	 * Function to get count given a list of params
	 * @access public
	 * @param string[] params
	 * @param int type
	 * @return int
	 * @ParamType params string[]
	 * @ParamType type int
	 * @ReturnType int
	 */
	public function getCountByParams(array $params, $type = null) {
		$count = 0;
		
		try{
		    $param_str = "";
		
		    foreach ($params as $key => $value)
		    {
		        $param_str .= "`$key` = '$value' AND ";
		    }
		
		    if (!empty($param_str))
		    {
		        $param_str = preg_replace("/( AND )$/", "", $param_str);
		
		        if ($this->getTable() == 'users' && $_SESSION['type_id'] != ESharedType::Admin)
		        {
		            // Only allow users to view their descendants and nothing more
		            $descendants = $this->getDescendants($_SESSION['_id']);
		            $descendants = $this->parseDescendantsByType($descendants, $type);
		            $descendants = implode(",", $descendants);
		
		            if (empty($descendants))
		                $descendants = "''";
		
		            $sql = "SELECT COUNT(*) as count FROM `{$this->table}` WHERE $param_str AND `_id` IN ({$descendants})";
		        }
		        else
		            $sql = "SELECT COUNT(*) as count FROM `{$this->table}` WHERE $param_str";
		
		        if (TSP_Config::get('app.debug'))
		            $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		        $result = $this->conn->RunQuery($sql);
		        $response = $this->conn->FetchHash($result);
		
		        $count = $response['count'];
		
		    }
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
		
		return $count;
	}

	/**
	 * Function to return the table fields of the current table
	 * @access public
	 * @param string[] excluded
	 * @return array
	 * @ParamType excluded string[]
	 * @ReturnType array
	 */
	public function getTableColumns(array $excluded) {
		$data = array();
		
		$sql = "DESCRIBE {$this->table}";
		
		if (TSP_Config::get('app.debug'))
		    $this->response['sql'][] = array('stmt' => $sql, 'params' => null);
		
		$result = $this->conn->RunQuery($sql);
		while( $row = $this->conn->FetchHash( $result)){
		    if (!in_array($row['Field'],$excluded))
		    {
		        $data[] = array(
		            'Field' => $row['Field'],
		            'Type' => $row['Type']
		        );
		    }
		}
		
		return $data;
	}

	/**
	 * @access public
	 * @param int ID
	 * @ParamType ID int
	 */
	public function setID($ID) {
		$this->ID = $ID;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getID() {
		return $this->ID;
	}

	/**
	 * @access public
	 * @param conn
	 */
	public function setConn($conn) {
		$this->conn = $conn;
	}

	/**
	 * @access public
	 */
	public function getConn() {
		return $this->conn;
	}

	/**
	 * @access public
	 * @param array response
	 * @ParamType response array
	 */
	public function setResponse(array $response) {
		$this->response = $response;
	}

	/**
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getResponse() {
		return $this->response;
	}

	/**
	 * @access public
	 * @param models.EOwnerType ownerType
	 * @ParamType ownerType models.EOwnerType
	 */
	public function setOwnerType(EOwnerType $ownerType) {
		$this->ownerType = $ownerType;
	}

	/**
	 * @access public
	 * @return models.EOwnerType
	 * @ReturnType models.EOwnerType
	 */
	public function getOwnerType() {
		return $this->ownerType;
	}

	/**
	 * @access public
	 * @param string name
	 * @ParamType name string
	 */
	public function setName($name) {
		$this->name = $name;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * @access public
	 * @param string route
	 * @ParamType route string
	 */
	public function setRoute($route) {
		$this->route = $route;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getRoute() {
		return $this->route;
	}

	/**
	 * @access public
	 * @param string table
	 * @ParamType table string
	 */
	public function setTable($table) {
		$this->table = $table;
	}

	/**
	 * @access public
	 * @return string
	 * @ReturnType string
	 */
	public function getTable() {
		return $this->table;
	}

	/**
	 * @access public
	 * @param array statuses
	 * @ParamType statuses array
	 */
	public function setStatuses(array $statuses) {
		$this->statuses = $statuses;
	}

	/**
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getStatuses() {
		return $this->statuses;
	}

	/**
	 * @access public
	 * @param array objectTypes
	 * @ParamType objectTypes array
	 */
	public function setObjectTypes(array $objectTypes) {
		$this->objectTypes = $objectTypes;
	}

	/**
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getObjectTypes() {
		return $this->objectTypes;
	}

	/**
	 * @access public
	 * @param array dataFields
	 * @ParamType dataFields array
	 */
	public function setDataFields(array $dataFields) {
		$this->dataFields = $dataFields;
	}

	/**
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getDataFields() {
		return $this->dataFields;
	}

	/**
	 * @access public
	 * @param int dateLastUpdated
	 * @ParamType dateLastUpdated int
	 */
	public function setDateLastUpdated($dateLastUpdated) {
		$this->dateLastUpdated = $dateLastUpdated;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getDateLastUpdated() {
		return $this->dateLastUpdated;
	}

	/**
	 * @access public
	 * @param int dateCreated
	 * @ParamType dateCreated int
	 */
	public function setDateCreated($dateCreated) {
		$this->dateCreated = $dateCreated;
	}

	/**
	 * @access public
	 * @return int
	 * @ReturnType int
	 */
	public function getDateCreated() {
		return $this->dateCreated;
	}
}
?>