<?php
/**
 * @access public
 * @author Sharron Denice
 * @package controllers.base
 */
abstract class BaseController {
	/**
	 * @AttributeType string[]
	 */
	public $response = array();

	/**
	 * 
	 * Function to get record metadata
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public abstract function getMetadata();

	/**
	 * 
	 * Function to add a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param int status
	 * @param int object_type
	 * @param int profile_type
	 * @param string[] params
	 * @return array
	 * @ParamType status int
	 * @ParamType object_type int
	 * @ParamType profile_type int
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public abstract function createRecord($status = null, $object_type = null, $profile_type = null, array $params = array());

	/**
	 * 
	 * Function to update a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @param string[] params
	 * @return array
	 * @ParamType params string[]
	 * @ReturnType array
	 */
	public abstract function updateRecord(array $params = array());

	/**
	 * 
	 * Function to delete a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public abstract function deleteRecord();

	/**
	 * 
	 * Function to activate a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public abstract function activateRecord();

	/**
	 * 
	 * Function to deactivate a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public abstract function deactivateRecord();
}
?>