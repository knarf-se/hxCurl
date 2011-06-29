/*
	(simple and naïve) Testing of the hxCurl functionality
*/
import curl.Curl;
import neko.Lib;
import neko.Sys;

class Test {
	
	public static function main() {
		// Write a welcome message that explains what this is doing
		/*
		Lib.println( "Theese tests requires a working internet connection." );
		Lib.println("And that the servers it tests against is up and running.");
		Lib.println("\nIdeally you should test against a local server that " + 
				"is under your control. \nYou could also add a row to the " + 
				"`\033[1;32m/etc/hosts\033[0m' file if you want. " );
		*/
		// This is an unusual way to testcases for me, oh well.
		var r = new haxe.unit.TestRunner();
		
		r.add( new TestCurl() );
		
		r.run();
		
		return 0;
	}
}

/**
	Unittests for the hxCurl wrapper of libCurl to haXe
**/
class TestCurl extends haxe.unit.TestCase {
	// You might want to change this
	static var xmp_url = "http://git.knarf.se/hxcurltestfile";
	static var server = "http://127.0.0.1:1337";

	/**
		Test the [Curl.simple_fetch] function against local Server.js
	**/
	function testSimpleFetchLocally() {
		var text = Curl.simple_fetch( server );
		assertTrue( text == "Hello World\n" );
	}

	/**
		Test the [Curl.setPostData] function against local Server.js
	**/
	function testSimplePostLocally() {
		var curl = new Curl( server + "/post" );
		var data = "→ Post test 123 ←";
		curl.setPostData( data );
		curl.action();
		assertTrue( curl.get_data() == data );
	}

	/**
		Test the [Curl.setHttpHeaders] function against local Server.js
	**/
	function testSetHttpHeaders() {
		var curl = new Curl( server + "/head" );
		var headers : Array<String> = new Array();
		headers.push( "Content-type: text/xml;charset=\"utf-8\"" );
		curl.setHttpHeaders( headers );
		curl.action();
		assertTrue( curl.get_data() == "ok" );
	}

	/**
		Test the [Curl.simple_fetch] function
	**//* TODO: A good idea would be to check connectivity before failing
	function testSimpleFetchOnline() {
		var text = Curl.simple_fetch( xmp_url );
		assertTrue( text.length > 32 );
		// You might want to encomment this line depending on what is fetched.
		Lib.println( text );
	}
	*/
}
