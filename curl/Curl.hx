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

package ;
import neko.Lib;

/**
	A simple binding of the famous library libCurl for haXe
**/
class Curl {
	var curl_handle;
	//	var body_callback		: String -> Void;
	//	var header_callback		: String -> Void;
	//	var progress_callback	: String -> Void;
	
	public function new( ?url ) {
		curl_handle = newCurl();
		if( url != null ) {
			set_url( url );
		)
		setup_callbacks();
	}
	public function set_url( url:String ) {
		setUrl( curl_handle, Lib.haxeToNeko( url ));
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
	public static function simple_fetch( url )
	{	// creates a new instance and sets it up for one download.
		var curl = new Curl( url );
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

