<?php

/**
 * @access public
 * @author Sharron Denice
 * @package controllers
 */
final class CReservation extends BaseController {

	/**
	 * 
	 * Function to get record metadata
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function getMetadata() {
		return array();
	}

    /**
     *
     * Function to get empty record data
     *
     * @since 1.0.0
     * @access public
     * @return array
     * @ReturnType array
     */
    public function getEmptydata() {
        session_start();

        $data = array();

        $this->response['success'] = array(
            'title' => 'Success',
            'message' => 'Data successfully retrieved.',
            'type' => 'success',
        );

        return $data;
    }

	/**
	 * Function to get property info given ID
	 * @since 1.0.0
	 * @internal param $none
	 * @access public
	 * @param int id
	 * @return array
	 * @ParamType id int
	 * @ReturnType array
	 */
	public function getReservationByID($id) {
		session_start();
		
		$reservation = new Reservation();
        $reservation_data = $reservation->getByID($id);
		$ID = $reservation_data['_id']; // store ID so profile doesn't overwrite ID

		$property = new Property();

        $property_data = $property->getByID($reservation->getPropertyID());
		
		$data = array_merge($reservation_data, $property_data);
		$data['_id'] = $ID; // restore company ID

		$reservation_response = $reservation->getResponse();
		$property_response = $property->getResponse();
		
		$this->response['sql'][] = array_merge($reservation_response['sql'], $property_response['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully retrieved.',
                'type' => 'success',
            );
		
		return $data;
	}

	/**
	 * Function to create a record
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
	public function createRecord($status = null, $object_type = null, $profile_type = null, array $params = array()) {
		session_start();

        $property          = TSP_Helper::arrGetVal($_POST, 'property', $params['property']);
		$property_id       = TSP_Helper::arrGetVal($_POST, 'property_id', $params['property_id']);
        $user_id           = TSP_Helper::arrGetVal($_POST, 'responsible_user_id', $params['responsible_user_id']);
		$description       = TSP_Helper::arrGetVal($_POST, 'description', $params['description']);
        $start_time        = TSP_Helper::arrGetVal($_POST, 'start_time', $params['start_time']);
        $end_time          = TSP_Helper::arrGetVal($_POST, 'end_time', $params['end_time']);

		$data = array(
            'property_id'           => $property_id,
            'responsible_user_id'   => $user_id,
            'description'           => $description,
            'start_time'            => $start_time,
            'end_time'              => $end_time,
		);

		$reservation = new Reservation();
		$ID = $reservation->add($data);
		
		$this->response = $reservation->getResponse();
		
		$data['_id'] = $ID;
		
		if (!empty($ID))
		{
            $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Reservation added successfully.',
                'type' => 'success',
            );

            // @TODO Take available time away from current property's availability
		}
		else
		{
            $this->response['error'] = array(
                'title' => 'Error',
                'message' => 'Reservation was not created. Please contact system administrator.',
                'type' => 'error',
            );
		}

		return $data;
	}

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
	public function updateRecord(array $params = array()) {
		session_start();

		$ID                = TSP_Helper::arrGetVal($_POST, '_id', $params['_id']);
		$property_id       = TSP_Helper::arrGetVal($_POST, 'property_id', $params['property_id']);
        $user_id           = TSP_Helper::arrGetVal($_POST, 'responsible_user_id', $params['responsible_user_id']);
		$description       = TSP_Helper::arrGetVal($_POST, 'description', $params['description']);
        $start_time        = TSP_Helper::arrGetVal($_POST, 'start_time', $params['start_time']);
        $end_time          = TSP_Helper::arrGetVal($_POST, 'end_time', $params['end_time']);

		$data = array(
		    '_id'               => $ID,
		    'property_id'       => $property_id,
            'user_id'           => $user_id,
		    'description'       => $description,
		    'start_time'        => $start_time,
		    'end_time'          => $end_time,
		);

		$reservation = new Reservation();
        $reservation_found = $reservation->getByID($ID);
		
		$this->response = $reservation->getResponse();
		
		if (!empty($reservation_found))
		{
            $reservation->update($data);

            $this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Reservation updated successfully.',
                'type' => 'success',
            );

            // @TODO Take available time away from current property's availability
		}
		else
		   $this->response['error'] = array(
                'title' => 'Error Occurred',
                'message' => 'Unable to update record. Please contact system administration.',
                'type' => 'error',
            );


		return $data;
	}

	/**
	 * 
	 * Function to delete a record
	 * 
	 * @since 1.0.0
	 * @access public
	 * @return array
	 * @ReturnType array
	 */
	public function deleteRecord() {
		session_start();
		
		$ID = TSP_Helper::arrGetVal($_POST, '_id');

        $reservation = new Reservation();
        $reservation->delete($ID);

        // @TODO Free up time from property when the reservation is deleted

        $data = $reservation->getResponse();

		$this->response['sql'][] = array_merge($data['sql']);
		
		$this->response['success'] = array(
                'title' => 'Success',
                'message' => 'Data successfully deleted.',
                'type' => 'success',
            );
		

		return $data;
	}

    /**
     *
     * Function to deactivate a record
     *
     * @since 1.0.0
     * @access public
     * @return array
     * @ReturnType array
     */
    public function deactivateRecord() {
        return array();
    }

    /**
     *
     * Function to activate a record
     *
     * @since 1.0.0
     * @access public
     * @return array
     * @ReturnType array
     */
    public function activateRecord() {
        return array();
    }
}
?>