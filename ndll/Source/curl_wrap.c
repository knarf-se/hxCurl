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

// for malloc
#include <stdlib.h>
// Curl related stuff
#include <curl/curl.h>
#include <curl/types.h>
#include <curl/easy.h>
// NekoVM related stuff
#include <neko.h>

// Useful macros (Yuck! C-Style Macros)
// This is the infamous double-expansion macro
#define STRINGIFY(x) #x
#define N2STR(x)	STRINGIFY(x)
// For debugging purposes
#define val_match_or_fail(v,t) if( !val_is_##t(v) ) { \
    failure("Excepted "#t" in `"__FILE__"' at line "N2STR(__LINE__)"."); \
  }

// Define the `kind' so that the VM can pass it around for us
DEFINE_KIND( k_curlHandle );

void destroyCurl ( value curl_handle )
{	// destroys the object

	// val_check_kind( curl_handle, k_curlHandle );
	curl_easy_cleanup( val_data( curl_handle ) );
}	DEFINE_PRIM(destroyCurl,1);

value newCurl ()
{	// Creates a new Curl handle and returns it as an abstract neko kind
	CURL *curl;
	curl = curl_easy_init();

	value ak_curl = alloc_abstract( k_curlHandle, curl );

	val_gc( ak_curl, destroyCurl );


	return ak_curl;
}	DEFINE_PRIM(newCurl,0);

value setUrl ( value curl_handle, value url ) {
	val_check_kind( curl_handle, k_curlHandle );
	val_match_or_fail( url, string );

	curl_easy_setopt( val_data( curl_handle ),
					CURLOPT_URL, val_string(url) );


	return val_true;
}	DEFINE_PRIM(setUrl,2);

value setPostdata ( value curl_handle, value data ) {
	val_check_kind( curl_handle, k_curlHandle );
	val_match_or_fail( data, string );

	curl_easy_setopt( val_data( curl_handle ),
					CURLOPT_POST, CURLOPT_POSTFIELDSIZE );
	curl_easy_setopt( val_data( curl_handle ),
					CURLOPT_POSTFIELDS, val_string(data) );

	return val_true;
}	DEFINE_PRIM(setPostdata,2);

// This is needed so that we know what do when libCurl calls us
typedef struct _WriteCallbackData {
		// The neko function that is going to aswer the call
	value *func;
		// Some potentially important key information
		// Note that this module does not care what this is
	value *data;
} WriteCallbackData;

static size_t
writeCallbackHelper( void *ptr, size_t size, size_t nmemb, void *usrdata )
{	// Helperfunction for write callbacks
	// Gets called when header or bodydata of a request is available from curl
	size_t realsize = size * nmemb;
	// → Convert the pointer ←
	WriteCallbackData *lump = (WriteCallbackData *)usrdata;

	// Hackish workaround for neko c ffi lack of something like memcpy
	buffer b = alloc_buffer( 0 );
	buffer_append_sub( b, ptr, realsize );

	// Convert the buffer to a `String' ( Random Array of Bytes )
	value data = buffer_to_string(b);

	// Call the given Neko function
	value ret = val_call2( *lump->func, *lump->data, data );

	// Returning anything else makes Curl believe that there was an error
	// in the callback for some reason. Maybe we should extend to this later?
	return realsize;
}

static value
setWriteCallbackHandler( value curl, value hfunc, value bfunc, value data )
{	// Sets a callback to handle the data recieved from the net
	val_check_function( hfunc, 2 );	//	Header function
	val_check_function( bfunc, 2 );	//	Body function
	// Note that the second parameter is not checked, the code does not
	// care what it is actually - it is just being passed around.
	val_check_kind( curl, k_curlHandle );

	// Warning: Ugly code follows =) {

	// *** * *** Header //
	WriteCallbackData *hlump = // \\ //
						malloc( sizeof(WriteCallbackData) );
	hlump->func = alloc_root(1);
	*hlump->func = hfunc;
	hlump->data = alloc_root(1);
	*hlump->data = data;

	// Tell Curl about it
	curl_easy_setopt( val_data(curl), CURLOPT_WRITEHEADER, (void *)hlump);

	// *** * *** Body //

	WriteCallbackData *blump = // \\ //
						malloc( sizeof(WriteCallbackData) );
	blump->func = alloc_root(1);
	*blump->func = bfunc;
	blump->data = alloc_root(1);
	*blump->data = data;
	curl_easy_setopt( val_data(curl), CURLOPT_WRITEDATA, (void *)blump);

	// Tell Curl about it
	curl_easy_setopt( val_data(curl), CURLOPT_WRITEFUNCTION,
					writeCallbackHelper );

	// } end_of( ugly_code );

	return val_null;
}	DEFINE_PRIM(setWriteCallbackHandler,4);

value
makeRequest( value curl_handle )
{	// Make the request itself, or
	// Actually perform any action

	// Alaws do typechecking! (Wish this was implicit)
	val_check_kind( curl_handle, k_curlHandle );

	// We like easy =)
	curl_easy_perform( val_data(curl_handle) );

	return val_null;
}	DEFINE_PRIM(makeRequest,1);

value
setUserAgent( value curl_handle, value ua )
{	// You should really set an user agent string
	val_match_or_fail( ua, string );
	val_check_kind( curl_handle, k_curlHandle );

   curl_easy_setopt( val_data(curl_handle), CURLOPT_USERAGENT, val_string(ua));

	return val_null;
}	DEFINE_PRIM(setUserAgent,2);

value 					// FIXME: Second parameter is ignored
enableCookies( value curl_handle, value cookie_file )
{	// Who does not want this?
	val_check_kind( curl_handle, k_curlHandle );
	char *str = "";
	// if( cookie file ){ }

	curl_easy_setopt( val_data(curl_handle), CURLOPT_COOKIEFILE, str );
	return val_null;
}	DEFINE_PRIM(enableCookies,2);






