# Dauntless Properties (PHP Project Demo)
-------
Dauntless Properties is a demo LAMP stack project with AngularJS UI front-end to allow authorized users to track real-estate property listings and reservations.

## FEATURES

* Installation wizard
* User authorization
* User registration
* Property management
* Property reservations (IN WORK)

## GENERAL INSTALLATION NOTES

* Download the repository from Github
* Unzip the zip file in the directory where Dauntless Properties will run
* If the zip creates a new directory called `dauntless-properties` you will need to change directories there
* Change directory to `www` in the main directory and run `php -S localhost:2000`
* Open a browser window
* Navigate to [http://localhost:2000](http://localhost:2000)
* The current API currently has data however you may also run the installation wizard at [http://localhost:2000/install](http://localhost:2000/install)
* To Get Started Immediately use the username `sharrondenice` and password `dauntless` to see sample data
* LIVE demo can be found at [https://app.letaprodoit.com/dauntless](https://app.letaprodoit.com/dauntless)
* API Code documentation can be found at [https://api.letaprodoit.com/dauntless/docs](https://api.letaprodoit.com/dauntless/docs)

### To Build The Project From Scratch

* Open a command prompt or user your IDE to run the command `npm install`. This will install all the required node_modules for debugging.
* Next change directory to `http` and run the command `composer update` This will install the required modules for the API
* Run `gulp build` to build the current workspace. All files will be outputted to the `www` directory.
* If you wish to run the API on localhost
** Update `www_stage/src/assets/env.js` to include `http://localhost:3000` as the API url
** Inside the `http` directory run `php -S localhost:3000` (Ensure your php webserver is still running at `http://localhost:2000`)
* Navigate to to `http://localhost:2000` to begin 


## KNOWN BUGS

* No known bugs

## REPORTING ISSUES

Thank you for downloading Dauntless Properties
If you find any issues, please report them in the issue tracker on our website:
[https://lab.letaprodoit.com/tracker](https://lab.letaprodoit.com/tracker)

## COPYRIGHT AND LICENSE

Copyright 2018 Sharron Denice

Software is available under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License; additional terms may apply. See [http://creativecommons.org/licenses/by-nc-nd/3.0/](Terms of Use) for details.
