
import curl.Curl;
import neko.Lib;

class Test {
	
	public static function main() {
		Lib.println( "Theese tests requires a working internet connection." );
		Lib.println("And that the servers it tests agains is up and running.");
		Lib.println("\nIdeally you should test against a local server that " + 
				"is under your control. \nYou could also add a row to the " + 
				"`\033[1;32m/etc/hosts\033[0m' file if you want. " );
		// This is an unusual way to testcases for me, oh well.
		var r = new haxe.unit.TestRunner();
		
		r.add(new TestCurl());
		
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
	
	function testSimpleFetch() {
		var text = Curl.simple_fetch( xmp_url );
		assertTrue( text.length > 32 );
		Lib.println( text );
	}
}
