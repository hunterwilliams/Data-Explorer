xquery version "1.0-ml";

import module namespace cfg = "http://www.marklogic.com/data-explore/lib/config" at "/server/lib/config.xqy";
import module namespace check-user-lib = "http://www.marklogic.com/data-explore/lib/check-user-lib"  at "/server/lib/check-user-lib.xqy";
declare variable $error:errors as node()* external;

xdmp:set-response-content-type("text/html"),
    '<!DOCTYPE html>',
    <html>
        <head>
            <title>{$cfg:app-title} - Error</title>
            <!--<link href="/css/status.css" type="text/css" rel="stylesheet"/>-->
        </head>
        <body>  
        <div id="container">
                <div id="header">
                    <a href="/"><h1>{$cfg:app-title}</h1></a>
                    <!--div id="headerImg"/-->
                    <br class="floatclear"/>
                </div>
                <div id="body" class="contentfull">
                    <div class="section" id="dbcontent">
                    <h2>Error </h2>
                    <p>There has been an error.</p>
                    {if (fn:not(check-user-lib:is-logged-in())) then
                        <p>{xdmp:quote($error:errors)}</p>
                    else if (check-user-lib:is-admin()) then
                        <p>{xdmp:quote($error:errors)}</p>
                    else
                        ()
                    }
                    </div>
                </div>
        </div>
        </body>
    </html>