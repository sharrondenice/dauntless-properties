<?php

    /**
     * Enrollment Processor
     *
     * @package		Enrollment
     * @filename	autoload.php
     * @version		1.0.0
     * @author		Sharron Denice, The Software People (www.thesoftwarepeople.com)
     * @copyright	Copyright 2016 RS Agency Services (www.rsagencyservices.com). All rights reserved
     * @license		APACHE v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
     * @brief		Enrollment functionality
     *
     */

    require_once "./vendor/autoload.php";
    require "config.php";
    require_once "routes.php";

    foreach (glob( ABSPATH . "classes/*.php" ) as $filename)
    {
        if (file_exists($filename))
            include $filename;
    }
    foreach (glob( ABSPATH . "models/base/*.php" ) as $filename)
    {
        if (file_exists($filename))
            include $filename;
    }
    foreach (glob( ABSPATH . "models/*.php" ) as $filename)
    {
        if (file_exists($filename))
        {
            if (preg_match('/Invoice\.php/', $filename))
                include  ABSPATH . 'models/Quote.php';

            if (!preg_match('/Quote\.php/', $filename))
                include $filename;
        }    
    }
    foreach (glob( ABSPATH . "controllers/base/*.php" ) as $filename)
    {
        if (file_exists($filename))
            include $filename;
    }
    foreach (glob( ABSPATH . "controllers/*.php" ) as $filename)
    {
        if (file_exists($filename))
            include $filename;
    }