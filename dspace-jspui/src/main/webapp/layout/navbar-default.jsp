<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null)
    {
        navbarEmail = user.getEmail();
    }
    
    // get the browse indices
    
	BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null)
    {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption())
        {
            if (bix.getName() != null)
    			browseCurrent = bix.getName();
        }
    }
 // get the locale languages
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
%>


       <div class="navbar-header">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
         <a class="navbar-brand" href="<%= request.getContextPath() %>/"><img height="25" src="<%= request.getContextPath() %>/image/dspace-logo-only.png" alt="DSpace logo" /></a>
       </div>
       <nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
         <ul class="nav navbar-nav">
           <li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a href="<%= request.getContextPath() %>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>
                
           <li class="dropdown">
             <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
				<li class="divider"></li>
        <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
				<%-- Insert the dynamic browse indices here --%>
				
				<%
					for (int i = 0; i < bis.length; i++)
					{
						BrowseIndex bix = bis[i];
						String key = "browse.menu." + bix.getName();
					%>
				      			<li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
					<%	
					}
				%>
				    
				<%-- End of dynamic browse indices --%>

            </ul>
          </li>
          <li class="<%= ( currentPage.endsWith( "/help" ) ? "active" : "" ) %>"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") %>"><fmt:message key="jsp.layout.navbar-default.help"/></dspace:popup></li>
       </ul>

 <% if (supportedLocales != null && supportedLocales.length > 1)
     {
 %>
    <div class="nav navbar-nav navbar-right">
	 <ul class="nav navbar-nav navbar-right">
      <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.language"/><b class="caret"></b></a>
        <ul class="dropdown-menu">
 <%
    for (int i = supportedLocales.length-1; i >= 0; i--)
     {
 %>
      <li>
        <a onclick="javascript:document.repost.locale.value='<%=supportedLocales[i].toString()%>';
                  document.repost.submit();" href="<%= request.getContextPath() %>?locale=<%=supportedLocales[i].toString()%>">
         <%= supportedLocales[i].getDisplayLanguage(supportedLocales[i])%>
       </a>
      </li>
 <%
     }
 %>
     </ul>
    </li>
    </ul>
  </div>
 <%
   }
 %>
 
       <div class="nav navbar-nav navbar-right">
		<ul class="nav navbar-nav navbar-right">
         <li class="dropdown">
         <%
    if (user != null)
    {
		%>
		<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
		      <fmt:param><%= StringUtils.abbreviate(navbarEmail, 20) %></fmt:param>
		  </fmt:message> <b class="caret"></b></a>
		<%
    } else {
		%>
             <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.sign"/> <b class="caret"></b></a>
	<% } %>             
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
               <li><a href="<%= request.getContextPath() %>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
               <li><a href="<%= request.getContextPath() %>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

		<%
		  if (isAdmin)
		  {
		%>
			   <li class="divider"></li>  
               <li><a href="<%= request.getContextPath() %>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
		<%
		  }
		  if (user != null) {
		%>
		<li><a href="<%= request.getContextPath() %>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
		<% } %>
             </ul>
           </li>
          </ul>
          
	<%-- Search Box --%>
	<form method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form navbar-right">
	    <div class="form-group">
          <input type="text" class="form-control" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery" size="25"/>
        </div>
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
<%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
<%
			if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
			{
%>
              <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
<%
            }
%> --%>
	</form></div>
    </nav>
<nav class="navbar navbar-default navbar-fixed-top">
    <div style="background-color: #76c7c0;">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">
                    <!-- Project name -->
                </a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav navbar-right">
                    <li class="<%= currentPage.endsWith("/home.jsp")? "active" : "" %>"><a href="<%= request.getContextPath() %>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= request.getContextPath() %>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
                            <li class="divider"></li>
                            <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
                            <%-- Insert the dynamic browse indices here --%>

                            <%
                                for (int i = 0; i < bis.length; i++)
                                {
                                    BrowseIndex bix = bis[i];
                                    String key = "browse.menu." + bix.getName();
                            %>
                            <li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
                            <%
                                }
                            %>

                            <%-- End of dynamic browse indices --%>

                        </ul>
                    </li>
                    <li class="<%= ( currentPage.endsWith( "/help" ) ? "active" : "" ) %>"><dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") %>"><fmt:message key="jsp.layout.navbar-default.help"/></dspace:popup></li>
                    <li class="dropdown">
                        <%
                            if (user != null)
                            {
                        %>
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
                            <fmt:param><%= StringUtils.abbreviate(navbarEmail, 20) %></fmt:param>
                        </fmt:message> <b class="caret"></b></a>
                        <%
                        } else {
                        %>
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.sign"/> <b class="caret"></b></a>
                        <% } %>
                        <ul class="dropdown-menu">
                            <li><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
                            <li><a href="<%= request.getContextPath() %>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
                            <li><a href="<%= request.getContextPath() %>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

                            <%
                                if (isAdmin)
                                {
                            %>
                            <li class="divider"></li>
                            <li><a href="<%= request.getContextPath() %>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
                            <%
                                }
                                if (user != null) {
                            %>
                            <li><a href="<%= request.getContextPath() %>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
                            <% } %>
                        </ul>
                    </li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </div>
    <search refresh="searchRefresh" class="ng-isolate-scope"><style>
        .typeahead-demo .custom-popup-wrapper {
            position: absolute;
            top: 100%;
            left: 0;
            z-index: 1000;
            display: none;
            background-color: #f9f9f9;
        }

        .typeahead-demo .custom-popup-wrapper>.message {
            padding: 10px 20px;
            border-bottom: 1px solid #ddd;
            color: #868686;
        }

        .typeahead-demo .custom-popup-wrapper>.dropdown-menu {
            position: static;
            float: none;
            display: block;
            min-width: 160px;
            background-color: transparent;
            border: none;
            border-radius: 0;
            box-shadow: none;
        }

        .dropdown.dropdown-lg .dropdown-menu {
            margin-top: -1px;
            padding: 6px 20px;
        }

        .input-group-btn .btn-group {
            display: flex !important;
        }

        .btn-group .btn {
            border-radius: 0;
            margin-left: -1px;
        }

        .btn-group .btn:last-child {
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
        }

        .btn-group .form-horizontal .btn[type="submit"] {
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }

        .form-horizontal .form-group {
            margin-left: 0;
            margin-right: 0;
        }

        .form-group .form-control:last-child {
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }

        .checkbox label {
            white-space: nowrap;
            text-overflow: ellipsis;
            max-width: 150px;
        }

        @media screen and (min-width: 768px) {
            .dropdown.dropdown-lg {
                position: static !important;
            }
            .dropdown.dropdown-lg .dropdown-menu {
                min-width: 65.4em;
            }
        }
    </style>

        <script type="text/ng-template" id="customTemplate.html">
            <a>
                <img ng-src="http://upload.wikimedia.org/wikipedia/commons/thumb/{{match.model.flag}}" width="16">
                <span ng-bind-html="match.label | uibTypeaheadHighlight:query"></span>
            </a>
        </script>

        <script type="text/ng-template" id="customPopupTemplate.html">
            <div class="custom-popup-wrapper"
                 ng-style="{top: position().top+'px', left: position().left+'px'}"
                 style="display: block;"
                 ng-show="isOpen() && !moveInProgress"
                 aria-hidden="{{!isOpen()}}">
                <p class="message">select location from drop down.</p>

                <ul class="dropdown-menu" role="listbox">
                    <li ng-repeat="match in matches track by $index" ng-class="{active: isActive($index) }"
                        ng-mouseenter="selectActive($index)" ng-click="selectMatch($index)" role="option" id="{{::match.id}}">
                        <div uib-typeahead-match index="$index" match="match" query="query" template-url="templateUrl"></div>
                    </li>
                </ul>
            </div>
        </script>

        <div class="panel-body">
            <form method="get" action="<%= request.getContextPath() %>/simple-search">
                <div class="container">
                    <div class="row">
                        <div class="col-sm-10"><div class="col-md-12">
                                <div class="input-group col-md-12" id="adv-search">
                                    <input type="text" class="form-control ng-pristine ng-untouched ng-valid"
                                           style="background-color: #f0f0f0" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery">
                                    <!-- ngRepeat: match in matches track by $index -->
                                </ul>
                                    <div class="input-group-btn">
                                        <div class="btn-group" role="group">
                                            <button type="submit" class="btn btn-primary">
                                                <span class="glyphicon glyphicon-search" aria-hidden="true"></span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </search>
</nav>