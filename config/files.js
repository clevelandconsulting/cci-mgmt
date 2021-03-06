/* Exports a function which returns an object that overrides the default &
 *   plugin file patterns (used widely through the app configuration)
 *
 * To see the default definitions for Lineman's file paths and globs, see:
 *
 *   - https://github.com/linemanjs/lineman/blob/master/config/files.coffee
 */
module.exports = function(lineman) {
  //Override file patterns here
  return {

    // As an example, to override the file patterns for
    // the order in which to load third party JS libs:
    webfonts: {
      root: "fonts"
    },
    coffee: {
	    app: [
    	 	"app/js/main.coffee",
    	 	"app/js/services/amplifyService.coffee",
    	 	"app/js/services/storageService.coffee",
    	 	"app/js/services/credentialService.coffee",
    	 	"app/js/services/apiService.coffee",
    	 	"app/js/services/authorizationService.coffee",
    	 	"app/js/factories/**/*.coffee",
    	 	"app/js/services/**/*.coffee",
    	 	"app/js/controllers/**/*.coffee",
    	 	"app/js/**/*.coffee"
    	]
    },
    js: {
    	vendor: [
    	    "vendor/bower/js-base64/base64.js",
    	    "vendor/bower/jquery/dist/jquery.js",
    	    "vendor/bower/toastr/toastr.js",
    	    "vendor/bower/underscore/underscore.js",
    	    "vendor/bower/underscore.string/lib/underscore.string.js",
    	    "vendor/bower/foundation/js/foundation.js",
    	    "vendor/bower/amplify/lib/amplify.js",
    	    "vendor/bower/amplify/lib/amplify.store.js",
         "vendor/bower/angular/angular.js",
         "vendor/bower/autofill-event/src/autofill-event.js",
         "vendor/bower/angular-route/angular-route.js",
         "vendor/js/**/*.js"  //Note that this glob remains for traditional vendor libs
     ],
     specHelpers: [
		       "vendor/bower/angular-mocks/angular-mocks.js",
         "spec/helpers/**/*.js"
     ]
    },
    sass: {
      vendor: [
         "vendor/bower/foundation/scss/normalize.scss",
         "vendor/bower/foundation/scss/foundation.scss",
         "vendor/fonts/foundation-general-enclosed/sass/general_enclosed_foundicons_ie7.scss",
         "vendor/fonts/foundation-general-enclosed/sass/general_enclosed_foundicons.scss"
      ]  
    },
    css: {
      vendor: [
         "vendor/bower/toastr/toastr.css"
      ]
    }
  };
};
