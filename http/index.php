<?php
    /**
     * Enrollment Processor
     *
     * @package		Registration
     * @filename	index.php
     * @version		1.0.0
     * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
     * @copyright	Copyright 2016 RS Agency Services (www.rsagencyservices.com). All rights reserved
     * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
     * @brief		Enrollment functionality
     *
     */
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: GET,POST,OPTIONS,DELETE,PUT');
    header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');

    require_once "autoload.php";

    $full_path = TSP_Helper::arrGetVal($_SERVER, 'REQUEST_URI');

    if (isset($_POST['data']))
    {
        $post_data = json_decode($_POST['data']);
        $_POST = (array)$post_data;
    }

    processRoute($routes, $full_path);


    /**
	 * Function to process the route
	 *
	 * @since 1.0.4
	 *
	 * @param array $routes - Available routes
	 * @param string $full_path - The path being requested
	 *
	 * @return none (echo json result) 
	 */
    function processRoute($routes, $full_path)
    {
        $data = array();
    
        try{
            $path = preg_replace("{/$|^/|http\/|pro\/}", "", $full_path);
            list($operation, $params) = getOperationAndParams($path, $routes);

            if (!empty($operation))
            {
                list($class, $func) = preg_split("/\@/", $operation);

                if (class_exists($class))
                {
                    $handler = new $class();

                    if (method_exists($handler, $func))
                    {
                        $data['data'] = call_user_func_array(array($handler, $func), $params);
                        $data['response'] = $handler->response;

                        if (empty($data['response']))
                        {
                            $data['response']['error'] = null;
                            $data['response']['success'] = null;
                        }
                    }
                }
            }
        }catch(Exception $e){
            if (DEBUG)
            {
                $data['response']['admin_error'][] = $e->getMessage();
            }
            $data['response']['error'] = "Unknown error (1) occurred. Please contact your system administrator or try again at a later time.";
        }
        
        if (!empty($data))
            echo json_encode($data);
    }

    /**
	 * Function to display the main UI
	 *
	 * @since 1.0.3
	 *
	 * @param string $full_path - The path being requested
	 * @param array $routes - The routes to be searched
	 *
	 * @return array ($operation, $params) the function to call and the parameters to pass if any 
	 */
    function getOperationAndParams($path, $routes)
    {
        $operation = null;
        $params = array();

		// if the path is found in the routes table explicitly
		// it means it does not have regular expressions/paramaters
		// and its ok to store the operation
		// else we need to traverse the array and find the route
		if (isset($routes[$path]))
		{
			$operation = $routes[$path];
		}
		else 
		{
		    foreach ($routes as $route => $this_operation)
		    {
				
				$regex_route = preg_replace("/{(.*?)\}\//", "(.*?)/", $route);
				$regex_route = preg_replace("/{(.*?)\}$/", "(\w+)", $regex_route);
				$regex_route = preg_replace("/\//", "\/", $regex_route);
				
				if (preg_match("/{$regex_route}/", $path, $matches))
		        {
					$operation = $this_operation;
					
	                if (!empty($matches))
	                {
	                    unset($matches[0]);
	                    $matches = array_values($matches);
	                    $params = $matches;
	                }
					
					break;
		        }
		    } 
		}

        return array($operation, $params);           
   }

    /**
     * Function to determine the if the domain calling this script is valid
     *
     * @since 1.0.0
     *
     * @param none
     *
     * @return bool
     */
    function validDomain()
    {
        $this_domain = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : "";
        $this_domain = preg_replace("/www\./", "", $this_domain); // Remove the www.

        $valid_domains = TSP_Config::get('app.misc.valid_live_domains');

        if (TSP_Config::get('app.debug'))
            $valid_domains = TSP_Config::get('app.misc.valid_debug_domains');

        if (in_array($this_domain, $valid_domains))
            return true;

        return false;
    }
