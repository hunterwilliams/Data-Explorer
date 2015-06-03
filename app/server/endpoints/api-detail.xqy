xquery version "1.0-ml";
import module namespace detail-lib = "http://www.marklogic.com/data-explore/lib/detail-lib" at "/server/lib/detail-lib.xqy";
import module namespace to-json = "http://marklogic.com/data-explore/lib/to-json" at "/server/lib/to-json-lib.xqy";
(: Expected output 

	{type:'DocumentType',permissions:[{'role':'test','method':'read'}],collections:['a','b'],text:'<root></root>',
      related:[
        {
          type:'Type A', items:[{uri:'abc.html',db:'Documents'}]
        }
      ]
    };

	:)

declare function local:get-json($uri as xs:string, $db as xs:string){
	let $doc         := detail-lib:get-document($uri,$db)/element()
    let $docText     := fn:normalize-space(fn:replace(xdmp:quote($doc),'"', '\\"'))
    let $doctype     := fn:local-name( $doc )
    let $collections := detail-lib:get-collections($uri,$db)
    let $permissions := detail-lib:get-permissions($uri,$db)
    let $related-map := detail-lib:find-related-items-by-document($doc,$db)
    let $related-items-json :=
        for $key in map:keys($related-map)
        let $values := to-json:seq-to-array-json(to-json:string-sequence-to-json(map:get($related-map,$key)))
        let $item := <item><type>{$key}</type><items>{$values}</items></item>

        return to-json:xml-obj-to-json($item)
    let $related-json := to-json:seq-to-array-json($related-items-json)
    let $permissions-json := to-json:seq-to-array-json(to-json:xml-obj-to-json($permissions))

    let $collections-json := to-json:seq-to-array-json(to-json:string-sequence-to-json($collections))

    let $xml := 
        <output>
            <type>{$doctype}</type>
            <collections>{$collections-json}</collections>
            <permissions>{$permissions-json}</permissions>
            <text>{$docText}</text>
            <related>{$related-json}</related>
        </output>

    let $json := to-json:xml-obj-to-json($xml)
    return $json
};

declare function local:get-details(){
    let $path := xdmp:get-original-url()
    let $tokens := fn:tokenize($path, "/")
    let $db 	:= xdmp:url-decode($tokens[4])
    let $first-part := fn:concat("/api/detail/",$db,"/")
    let $uri 	:= xdmp:url-decode(fn:substring-after($path,$first-part))
    return 
    	if (fn:count($tokens) > 4) then
    		if (detail-lib:database-exists($db)) then
    			(xdmp:set-response-code(200,"Success"),local:get-json($uri,$db))
    		else
    			(xdmp:set-response-code(400,fn:concat("Invalid Database:",$db)))
        else
        	(xdmp:set-response-code(400,"URI Parameter count too low"))
};

local:get-details()