xquery version "1.0-ml";

module namespace ld = "http://marklogic.com/ps/lib/detail";

import module namespace slice = "http://marklogic.com/transitive-closure-slice" at "/server/lib/l-slice.xqy";


declare function ld:find-related-items-by-document($document,$db as xs:string){
	let $map := map:map()
	let $_ := 
		for $uri in (slice:getAllRelatedObjectsWithDefaultMap($document,$db))/fn:base-uri()
		let $type := fn:tokenize($uri,"/")[5]
		return 
			if (fn:not($uri = $document/fn:base-uri())) then
				let $list := 
					if (map:contains($map,$type)) then
						map:get($map,$type)
					else
						()
				let $list := ($list,$uri)
				return map:put($map,$type,$list)
			else
				()
	return $map
};

declare function ld:find-related-audits-by-uri($uri as xs:string){
	()
};


declare function ld:print-role-name($role-id as xs:unsignedLong){
   let $role-name := xdmp:eval(
  'xquery version "1.0-ml";
  import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
  declare variable $role-id as xs:unsignedLong external;
  sec:get-role-names($role-id)/text()',
  (xs:QName("role-id"),$role-id),
  <options xmlns="xdmp:eval">
    <database>{xdmp:database("Security")}</database>
  </options>)
   return <role-name>{$role-name}</role-name>
};
declare function ld:print-permission($default-permission as element(sec:permission)){
    let $capability := $default-permission/sec:capability/text()
    let $role-id := $default-permission/sec:role-id
    return 
    <permission>
        <capability>{$capability}</capability>
        {ld:print-role-name($role-id)}
    </permission>
};

declare function ld:get-permissions($document-uri as xs:string, $db as xs:string){
	let $permissions := xdmp:eval(
  'xquery version "1.0-ml";
  declare variable $document-uri as xs:string external;
  xdmp:document-get-permissions($document-uri)',
  (xs:QName("document-uri"),$document-uri),
  <options xmlns="xdmp:eval">
    <database>{xdmp:database($db)}</database>
  </options>)
  return ld:print-permission($permissions)
};

declare function ld:get-collections($document-uri as xs:string, $db as xs:string){
	let $collections := xdmp:eval(
  'xquery version "1.0-ml";
  declare variable $document-uri as xs:string external;
  xdmp:document-get-collections($document-uri)',
  (xs:QName("document-uri"),$document-uri),
  <options xmlns="xdmp:eval">
    <database>{xdmp:database($db)}</database>
  </options>)
  return $collections
};

declare function ld:get-document($document-uri as xs:string, $db as xs:string){
	let $doc := xdmp:eval(
  'xquery version "1.0-ml";
  declare variable $document-uri as xs:string external;
  fn:doc($document-uri)',
  (xs:QName("document-uri"),$document-uri),
  <options xmlns="xdmp:eval">
    <database>{xdmp:database($db)}</database>
  </options>)
  return $doc
};