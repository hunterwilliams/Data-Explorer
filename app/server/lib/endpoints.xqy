xquery version "1.0-ml";

module namespace endpoints="http://example.com/ns/endpoints";

import module namespace  cu = "http://check-user" at "/server/lib/check-user.xqy" ;

declare namespace rest="http://marklogic.com/appservices/rest";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $endpoints:DEFAULT             as xs:string := "/server/controller/index.xqy";
declare variable $endpoints:LOGIN               as xs:string := "/server/controller/login.xqy";
declare variable $endpoints:LOGOUT              as xs:string := "/server/controller/logout.xqy";
declare variable $endpoints:LOGOUT-LOGIN        as xs:string := "/server/controller/logout-login.xqy";
declare variable $endpoints:LOGIN-USER          as xs:string := "/server/form-controller/login-user.xqy";
declare variable $endpoints:UPDATE-USER         as xs:string := "/server/form-controller/update-user-password.xqy";
declare variable $endpoints:UPDATE-PASSWORD     as xs:string := "/server/controller/update-password.xqy";
declare variable $endpoints:CREATE-ACCOUNT-FORM as xs:string := "/server/view/create-account-form.xqy";
declare variable $endpoints:CREATE-ACCOUNT      as xs:string := "/server/controller/create-account.xqy";
declare variable $endpoints:LIST-LOGS           as xs:string := "/server/view/list-logs.xqy";
declare variable $endpoints:GET-LOG             as xs:string := "/server/controller/get-log.xqy";
declare variable $endpoints:FILE-UPLOAD-FORM    as xs:string := "/server/view/file-upload-form.xqy";
declare variable $endpoints:UPLOAD-FILE         as xs:string := "/server/model/upload-file.xqy";
declare variable $endpoints:LIST-WORKSPACES     as xs:string := "/server/view/list-workspaces.xqy";
declare variable $endpoints:COPY-WORKSPACE      as xs:string := "/server/controller/copy-workspace-controller.xqy";
declare variable $endpoints:METRICS-CONFIG      as xs:string := "/server/model/metrics-config.xqy";
declare variable $endpoints:DOWNLOAD-METRICS    as xs:string := "/server/model/download-metrics-file.xqy";
declare variable $endpoints:UPLOAD-METRICS      as xs:string := "/server/model/upload-metrics-file.xqy";
declare variable $endpoints:ADHOC-QUERY         as xs:string := "/server/model/adhoc-query.xqy";
declare variable $endpoints:ADHOC-EDIT-QUERY    as xs:string := "/server/model/adhoc-edit-query.xqy";
declare variable $endpoints:ADHOC-EDIT-VIEW     as xs:string := "/server/model/adhoc-edit-view.xqy";
declare variable $endpoints:ADHOC-QUERY-WIZARD  as xs:string := "/server/model/adhoc-query-wizard.xqy";
declare variable $endpoints:ADHOC-NEW-QUERY  as xs:string := "/server/model/adhoc-new-query.xqy";
declare variable $endpoints:ADHOC_UPDATE_QUERY_DB  as xs:string := "/server/model/adhoc-update-query-db.xqy";
declare variable $endpoints:CREATE-NEW-QUERY-VIEW  as xs:string := "/server/controller/create-new-query-view.xqy";
declare variable $endpoints:GET-DOCTYPE-OPTIONS as xs:string := "/server/controller/get-doctype-options.xqy";
declare variable $endpoints:GET-DOCTYPES        as xs:string := "/server/controller/get-doctypes.xqy";
declare variable $endpoints:GET-QUERY-NAMES     as xs:string := "/server/controller/get-query-names.xqy";
declare variable $endpoints:GET-FORM-QUERY      as xs:string := "/server/controller/get-form-query.xqy";
declare variable $endpoints:GET-VIEW-NAMES      as xs:string := "/server/controller/get-view-names.xqy";
declare variable $endpoints:GET-EDITQUERY-PARAMS     as xs:string := "/server/controller/get-editquery-params.xqy";
declare variable $endpoints:GET-EDITVIEW-PARAMS     as xs:string := "/server/controller/get-editview-params.xqy";
declare variable $endpoints:DELETE-QUERY        as xs:string := "/server/controller/delete-query.xqy";
declare variable $endpoints:DELETE-VIEW         as xs:string := "/server/controller/delete-view.xqy";
declare variable $endpoints:GET-VIEW            as xs:string := "/server/controller/get-view.xqy";
declare variable $endpoints:DETAIL              as xs:string := "/server/controller/detail.xqy";
declare variable $endpoints:SEARCH              as xs:string := "/server/controller/search.xqy";
declare variable $endpoints:OUTPUT              as xs:string := "/server/controller/post-download.xqy";
declare variable $endpoints:ADHOC-UPDATE-DB-QV  as xs:string := "/server/controller/adhocupdatequerydb.xqy";

declare variable $endpoints:ADVANCED-SEARCH         as xs:string := "/server/view/new-search.xqy";

declare variable $endpoints:SAVE-PASS  as xs:string := "/server/controller/save-pass.xqy";
declare variable $endpoints:FIND-PASS  as xs:string := "/server/controller/find-pass.xqy";

(: README https://github.com/marklogic/ml-rest-lib :)

declare variable $endpoints:ENDPOINTS as element(rest:options) :=
    <options xmlns="http://marklogic.com/appservices/rest">

        <request uri="^/$" endpoint="{$endpoints:DEFAULT}"/>
        <request uri="^/index\.htm" endpoint="{$endpoints:DEFAULT}"/>
        <request uri="^/default\.htm" endpoint="{$endpoints:DEFAULT}"/>

        <request uri="^/login-form$" endpoint="{$endpoints:LOGIN-USER}">
            <http method="GET"/>
        </request>
        <request uri="^/login$" endpoint="{$endpoints:LOGIN}">
            <param name="user-id"/>
            <param name="password"/>
            <http method="POST"/>
        </request>


        <request uri="^/logout$" endpoint="{$endpoints:LOGOUT}">
            <http method="GET"/>
            <http method="POST"/>
        </request>


        <request uri="^/update-user/(.+?)$" endpoint="{$endpoints:UPDATE-USER}">
            <uri-param name="user-id">$1</uri-param>
            <http method="GET"/>
        </request>
        <request uri="^/update-password$" endpoint="{$endpoints:UPDATE-PASSWORD}">
            <param name="user-id"/>
            <param name="password"/>
            <param name="password2"/>
            <http method="POST"/>
        </request>

        {
            if (cu:is-logged-in() and
                (cu:is-tester() or cu:is-admin())) then
              (
                <request uri="^/adhocquery$" endpoint="{$endpoints:ADHOC-QUERY}">
                    <param name="database"/>
                    <param name="doctype2"/>
                    <param name="queryName2"/>
                    <param name="viewName"/>
                    { endpoints:numbered-params("id", (1 to 15)) }
                    <param name="word"/>
                    <param name="excludedeleted"/>
                    <param name="excludeversions"/>
                    <param name="selectedfacet"/>
                    <param name="go"/>
                    <param name="pagenumber"/>
                    <param name="pagination-size"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-doctype-options$" endpoint="{$endpoints:GET-DOCTYPE-OPTIONS}">
                    <param name="db"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-doctypes$" endpoint="{$endpoints:GET-DOCTYPES}">
                    <param name="database"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-query-names$" endpoint="{$endpoints:GET-QUERY-NAMES}">
                    <param name="db"/>
                    <param name="docType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-form-query$" endpoint="{$endpoints:GET-FORM-QUERY}">
                    <param name="db"/>
                    <param name="docType"/>
                    <param name="queryName"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-view-names$" endpoint="{$endpoints:GET-VIEW-NAMES}">
                    <param name="db"/>
                    <param name="docType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-editquery-params$" endpoint="{$endpoints:GET-EDITQUERY-PARAMS}">
                    <param name="queryType"/>
                    <param name="documentType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/get-editview-params$" endpoint="{$endpoints:GET-EDITVIEW-PARAMS}">
                    <param name="viewType"/>
                    <param name="documentType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/delete-query$" endpoint="{$endpoints:DELETE-QUERY}">
                    <param name="queryType"/>
                    <param name="documentType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/delete-view$" endpoint="{$endpoints:DELETE-VIEW}">
                    <param name="viewType"/>
                    <param name="documentType"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,                
                <request uri="^/get-view$" endpoint="{$endpoints:GET-VIEW}">
                    <param name="db"/>
                    <param name="docType"/>
                    <param name="viewName"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhoc_update_query_db$" endpoint="{$endpoints:ADHOC_UPDATE_QUERY_DB}">
                    <param name="updateType"/>
                    <param name="docType"/>
                    <param name="query"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhocupdatequerydb$" endpoint="{$endpoints:ADHOC-UPDATE-DB-QV}">
                    <param name="updateType"/>
                    <param name="docType"/>
                    <param name="query"/>
                    <param name="db-list"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/search$" endpoint="{$endpoints:SEARCH}">
                    <param name="params"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                
                <request uri="^/advanced-search$" endpoint="{$endpoints:ADVANCED-SEARCH}">
                    <param name="search-text"/>
                    <param name="search-options"/>
                    <param name="search-start"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
             <request uri="^/outputs$" endpoint="{$endpoints:OUTPUT}">
                    <param name="params"/>
                    <http method="POST"/>
                    <http method="GET"/>
                    <param name="data"/>
                </request>,
                <request uri="^/detail$" endpoint="{$endpoints:DETAIL}">
                    <param name="uri"/>
                    <param name="db"/>
                    <param name="type"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>
              )
            else
              ()
        }
        {
            if (cu:is-logged-in() and cu:is-admin()) then
              (
                <request uri="^/adhoceditquery$" endpoint="{$endpoints:ADHOC-EDIT-QUERY}">
                    <param name="prefix"/>
                    <param name="rootElement"/>
                    <param name="queryName"/>
                    <param name="queryText"/>
                    <param name="submit"/>
                    {
                      endpoints:numbered-params("formLabel", (1 to 15))
                    }
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhoceditview$" endpoint="{$endpoints:ADHOC-EDIT-VIEW}">
                    <param name="prefix"/>
                    <param name="rootElement"/>
                    <param name="viewName"/>
                    <param name="submit"/>
                    {
                      endpoints:numbered-params("columnName", (1 to 15)),
                      endpoints:numbered-params("columnExpr", (1 to 15))
                    }
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhocquerywizard$" endpoint="{$endpoints:ADHOC-QUERY-WIZARD}">
                    <param name="uploadedDoc"/>
                    <param name="type"/>                  
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhocnewquery$" endpoint="{$endpoints:ADHOC-NEW-QUERY}">
                    <param name="type"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,
                <request uri="^/adhocnewview$" endpoint="{$endpoints:ADHOC-NEW-QUERY}">
                    <param name="type"/>
                    <http method="POST"/>
                    <http method="GET"/>
                </request>,                
                <request uri="^/createnewqueryview$" endpoint="{$endpoints:CREATE-NEW-QUERY-VIEW}">
                    <param name="prefix"/>
                    <param name="rootElement"/>
                    <param name="queryName"/>
                    <param name="viewName"/>
                    <param name="queryText"/>
                    <param name="database"/>   
                    <param name="submit"/>
                    {endpoints:numbered-params("formLabel", (1 to 250))}
                    {endpoints:numbered-params("formLabelHidden", (1 to 250))}
                    {endpoints:numbered-params("columnName", (1 to 250))}
                    {endpoints:numbered-params("columnExpr", (1 to 250))}                    
                    <http method="POST"/>
                    <http method="GET"/>
                </request>
          
              )
            else
              ()
        }

        {
            if (cu:is-logged-in() and fn:not(cu:is-tester())) then
            (
                <request uri="^/file-upload-form$" endpoint="{$endpoints:FILE-UPLOAD-FORM}">
                    <http method="GET"/>
                </request>
                ,
                <request uri="^/upload-file$" endpoint="{$endpoints:UPLOAD-FILE}">
                    <param name="filename"/>
                    <param name="uri"/>
                    <param name="database"/>
                    <http method="POST"/>
                </request>
                ,
                <request uri="^/get-log/(.+?)$" endpoint="{$endpoints:GET-LOG}">
                    <uri-param name="file-name">$1</uri-param>
                    <http method="GET"/>
                </request>
                ,
                <request uri="^/list-workspaces$" endpoint="{$endpoints:LIST-WORKSPACES}">
                    <http method="GET" />
                </request>
                ,
                <request uri="^/copy-workspace$" endpoint="{$endpoints:COPY-WORKSPACE}">
                    <param name="workspace"/>
                    <http method="POST"/>
                </request>
                ,
                <request uri="^/report" endpoint="/controller/report.xqy">
                    <http method="GET"/>
                    <param name="database" required="false"/>
                </request>
            )
            else
              ()
        }
        {
          if (cu:is-logged-in()) then
            <request uri="^/(.)" endpoint="{$endpoints:LOGOUT-LOGIN}">
                <http method="GET"/>
                <http method="POST"/>
            </request>
          else
            <request uri="^/(.)" endpoint="{$endpoints:LOGIN-USER}">
                <http method="GET"/>
            </request>
        }
     </options>;


declare function endpoints:options()
as element(rest:options)
{
  $endpoints:ENDPOINTS
};

declare function endpoints:request(
  $module as xs:string)
as element(rest:request)?
{
  ($endpoints:ENDPOINTS/rest:request[@endpoint = $module])[1]
};

declare function endpoints:resource-for-module($module as xs:string) as xs:string
{
	fn:string(endpoints:request($module)/@uri)
};

declare function endpoints:numbered-params($prefix as xs:string, $seq as xs:int*)
    as element(rest:param)*
{
  for $i in $seq
  return <rest:param name="{ fn:concat($prefix, fn:string($i)) }"/>
};