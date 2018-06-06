<?php

/**
 * @access public
 * @author Sharron Denice
 * @package models
 */
class Admin extends User {

	/**
	 * @access public
	 * @param int id
	 * @ParamType id int
	 */
	public function __construct($id = null) {
		try{
		    parent::__construct($id);
		
		    $type = new Type();
		    $type->getByID(ESharedType::Admin);
		    $this->setType($type);
		
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
}
?>