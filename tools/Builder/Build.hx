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
	Perl Foundation Artistic License in a file named ``COPYING'' along 
	with this software.  If not, see <http://www.gnu.org/licenses/> and
	<http://opensource.org/licenses/artistic-license-2.0>.
***/

import neko.Lib;
import neko.Sys;

/**
	This class serves the purpose of enabling a user to easily build the ndll
	that is specific for their system. Right now it is very simple and may or
	may not work in all cases, any kind of error handling is abscent...
**/
class Build {
	public static function main()
	{	// This is the way to Go!, I did this in C++ to before too
		// And I almost never had any global variables, either...
		new Build();
		return 0;
	}
	function new()
	{	// Create a new instance of the Build class/system
		this.run();
	}
	/*	ToDo: *	Improve errorhandling of this "buildsystem".
			  *	Make it run testcases too!
	*/
	function run()
	{	// Builds the ndll from the sources
		Lib.println( "Trying to compile the ndll from Source." );
		// Lib.print( Sys.executablePath() );
		Sys.command( "cd ndll/Source" );
		Sys.command( "mkdir -p ../" + Sys.systemName() );
		Sys.command( "gcc -c -fPIC curl_wrap.c -o curlw.o" );
		Sys.command( "gcc -lcurl -shared -Wl,-soname,libcurl_wrap.so -o " +
				"libcurl_wrap.so curlw.o" );
		Sys.command( "mv libcurl_wrap.so ../" +
				Sys.systemName() + "/curl_wrap.ndll" );
		Lib.println( "Danke Schön! (Success!)\n" );
	}
}

