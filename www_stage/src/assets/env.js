(function (window) {
    window.__env = window.__env || {};

    // API url
    //window.__env.api              = 'https://api.letaprodoit.com/pro';
    window.__env.api                = 'http://localhost:3000';

    window.__env.installed          = true; // @TODO Remove on go live

    window.__env.mobile_width       = 767; //size changed from 768 to fix ipad issue
    window.__env.table_max_width    = "1024px"; // @TODO !!!READ ME!!! if change this here change app/theme/custom-mobile.less too
    window.__env.version            = 'v1.0.0';
    window.__env.cookie_prefix      = 'iVBORw0KG';
    
    // Default Settings
    window.__env.theme              = 'theme-zero';
    window.__env.default_page_size  = 25;
    window.__env.locale             = {
        show_countries:             false, // LOAD FROM SYSTEM SETTING
        lang_code:                   'en', // LOAD FROM SYSTEM SETTING
        default_country:             'US' // LOAD FROM SYSTEM SETTING
    };
    window.__env.verbose            = true;
    window.__env.debug              = true;
    window.__env.live               = false;
}(this));