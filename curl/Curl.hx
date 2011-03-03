/***
	hxCurl version 0.1  ---  a binding of libCurl for haXe.
	Copyright ©2011  Frank M. Eriksson  < http://knarf.se/ >

	This software is free software: you can redistribute it and/or modify
	it under the terms of the Perl Foundation Artistic License 2.0 and 
	under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This software is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License and 
	the Perl Foundation Artistic License in a file named ``COPYING'' along 
	with this software.  If not, see <http://www.gnu.org/licenses/> and
	<http://opensource.org/licenses/artistic-license-2.0>.
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
	**/
	public function new( ?url, ?async:Bool ) {
		curl_handle = newCurl();
		if( url != null ) {
			set_url( url );
		}
		setup_callbacks();
	}
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
	function set_url( url:String ) {
		setUrl( curl_handle, Lib.haxeToNeko( url ));
		return url;
	}
	function set_ua( agent:String ) {
		setUserAgent( curl_handle, Lib.haxeToNeko( agent ));
		return agent;
	}
	public function get_data() {
		return body;
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

