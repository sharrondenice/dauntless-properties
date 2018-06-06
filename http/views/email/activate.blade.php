<?php
$template = <<<END_HTML
<style>
/* Style genrated from http://tablestyler.com/ */
.datagrid table { border-collapse: collapse; text-align: left; width: 100%; } .datagrid {font: normal 12px/150% Arial, Helvetica, sans-serif; background: #fff; overflow: hidden; border: 1px solid #8C8C8C; -webkit-border-radius: 3px; -moz-border-radius: 3px; border-radius: 3px; }.datagrid table td, .datagrid table th { padding: 3px 10px; }.datagrid table thead th {background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #9E9E9E), color-stop(1, #9E9E9E) );background:-moz-linear-gradient( center top, #9E9E9E 5%, #9E9E9E 100% );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#9E9E9E', endColorstr='#9E9E9E');background-color:#9E9E9E; color:#FFFFFF; font-size: 15px; font-weight: normal; border-left: 1px solid #A3A3A3; } .datagrid table thead th:first-child { border: none; }.datagrid table tbody td { color: #7D7D7D; border-left: 1px solid #DBDBDB;font-size: 12px;font-weight: normal; }.datagrid table tbody .alt td { background: #EBEBEB; color: #7D7D7D; }.datagrid table tbody td:first-child { border-left: none; }.datagrid table tbody tr:last-child td { border-bottom: none; }
</style>
Dear {$params['first_name']} {$params['last_name']},<br>
<br>
Your account has been successfully approved and activated.<br>
<br>
Your account information is (details case-sensitive):<br>
<br>
Login URL: <a href="{$params['domain']}/#/login">{$params['domain']}/#/login</a><br>
Email: {$params['email']} (Email is case sensitive)<br>
Username: {$params['username']}<br>
Password: {$params['password2']}<br>
<br>
<br>
Best regards,<br>
{$params['company_name']}<br>
END_HTML;
