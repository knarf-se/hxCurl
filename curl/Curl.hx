/***
	hxCurl version 0.1  ---  a binding of libCurl for haXe.
	Copyright ©2011  Frank M. Eriksson  < http://knarf.se/ >

	This software is free software: you can redistribute it and/or modify
	it under the terms of the MIT license, please see file “COPYING” or
	http://opensource.org/licenses/mit-license.php
***/

package curl;
import neko.Lib;

/**
	A simple binding of the famous library libCurl for haXe
**/
class Curl {
	var curl_handle:Dynamic;
	//	var body_callback		: String -> Void;
	//	var header_callback		: String -> Void;
	//	var progress_callback	: String -> Void;

	/**
		The useragent that you will indentify your application as.
	**/
	public var agent(default,set_ua)	: String;
	/**
		Set a new URL to use.
	**/
	public var url(default,set_url)	: String;
	//var async

	/**
		Creates a new Curl object, possible with URL and async mode set.
		Please reuse the same Curl object for added effiency (using
			persistent connections wherever possible).

		DO NOT use the same Curl object from different threads.
	**/
	public function new( ?url, ?async:Bool ) {
		curl_handle = newCurl();
		if( url != null ) {
			set_url( url );
		}
		setup_callbacks();
	}
	/**
		This function is intended for situations when you does not want to
		stick around waiting for the request to completed, or in situations
		when it (almost) never completes (Streaming). Not implemented yet.

		@todo implement the function
	**/
	public dynamic function onData( data : String ) : Void {

	}
	/**
		Should be replaced with error handling code, the default one throws an
		Exception.
	**/
	public dynamic function onError( msg : String ) : Void {
		throw msg;
	}
	/**
		Make the actual request that you have set up.
	**/
	public function action() {
		return makeRequest( curl_handle );
	}

	/**
		Get the data that has been recieved soo far.
	**/
	public function get_data() {
		return body;
	}

	/**
		Do a simple fetch of a single file by it's URL, good to use
		if your application only fetches a file or two.

		Do NOT use this if your application fetches more
		than a very 'small' amount of files!
	**/
	public static function simple_fetch( url ) : String
	{	// creates a new instance and sets it up for one download.
		var curl = new Curl( url );
		curl.agent = "test/0.1";
		curl.action();
		return curl.get_data();
	}

	//	===	===	===
	function setup_callbacks() {
		setWriteCallbackHandler( curl_handle,
				header_callback, body_callback, this );
		head = "";
		body = "";
	}

	var head: String;
	static function header_callback( self, data ) {
		self.head += Lib.nekoToHaxe(data);
	}

	var body: String;
	static function body_callback( self, data ) {
		self.body += Lib.nekoToHaxe(data);
	}

	function set_url( url:String ) {
		setUrl( curl_handle, Lib.haxeToNeko( url ));
		return url;
	}

	function set_ua( agent:String ) {
		setUserAgent( curl_handle, Lib.haxeToNeko( agent ));
		return agent;
	}

	// Import of functions exposed by the ndll \\
	// ======================================= //
	// newCurl() → Abstract kind ( curl_handle )
	private static var	newCurl = neko.Lib.load("curl_wrap","newCurl",0);
	// setWriteCallbackHandler( curl_handle, hfunc, bfunc, data ) → Void
	private static var	setWriteCallbackHandler =
						neko.Lib.load("curl_wrap","setWriteCallbackHandler",4);
	// setUrl( curl_handle, url:neko_string ) → Bool
	private static var	setUrl = neko.Lib.load("curl_wrap","setUrl",2);
	// makeRequest( curl_handle ) → Bool
	private static var makeRequest =neko.Lib.load("curl_wrap","makeRequest",1);
	// makeRequest( curl_handle ) → Bool
   private static var setUserAgent=neko.Lib.load("curl_wrap","setUserAgent",2);
	// enableCookies( curl_handle, cookie_file:neko_string ) ↓ Void
 private static var enableCookies=neko.Lib.load("curl_wrap","enableCookies",2);
}
