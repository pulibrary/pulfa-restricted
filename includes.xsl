<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:output indent="yes"/>
   <xsl:strip-space elements="*"/>

   <xsl:template name="standard-head">
      <xsl:param name="base-uri"></xsl:param>
      <link href="{concat($base-uri,'/favicon.ico')}" rel="shortcut icon"></link>
      <script type="text/javascript">
        /* Google Analytics */
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-32739332-1']);
        _gaq.push(['_trackPageview']);
      
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      
      </script>
   </xsl:template>

   <xsl:template name="standard-css" as="element()*">
      <link rel="stylesheet" type="text/css" href="pulfa.css" media="all"/>
   </xsl:template>

   <xsl:template name="standard-alt" as="element()*">
      <xsl:param name="page-url" as="xs:string"/>
      <link rel="alternate" type="application/rdf+xml" href="{$page-url}.rdf"/>
      <link rel="alternate" type="application/xml" href="{$page-url}.xml"/>
   </xsl:template>
   
   <xsl:template name="standard-js" as="element()*">
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js">#</script>
      <!--<script type="text/javascript" src="global.js">#</script>-->
      <script type="text/javascript" src="pulfa.js">#</script>
   </xsl:template>

   <xsl:template name="standard-footer" as="element()*">
      <p><a rel="license" href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by/3.0/80x15.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</a>.</p>
   </xsl:template>

   <xsl:template name="standard-nav">
      <xsl:param name="focus" as="xs:string?"/>
      <xsl:param name="base-uri" as="xs:string"/>
      <div id="feedback-modal" class="modal hide fade" style="width:600px; height: 475px; max-height: 475px;">
         <div class="modal-header">
            <a href="#" class="close">&#x00D7;</a>
            <h3 style="line-height:24px;">Site Feedback</h3>
         </div>
         <iframe id="Fiframe" scrolling="no" frameborder="0" margin-height="5px" marginwidth="5px" height="100%" width="100%" src="">Sorry, your browser does not support iframes.  You can still contact us here.</iframe>
         
      </div>
      <div class="thinbar">
         <div class="container">
            <a href="http://www.princeton.edu"><img src="pu_logo_small.png" class="pulogo" border="0"/></a>
            
         </div>
      </div>
      <div class="topbar">
         <div class="fill">
            <div class="container">
               <xsl:element name="a">
                  <xsl:attribute name="class">brand</xsl:attribute>
                  <xsl:attribute name="href"><xsl:value-of select="$base-uri"/></xsl:attribute>
                  <img src="pul_bug_small.png" class="pulbug" />
                  Princeton University Library Finding Aids </xsl:element>
               <ul class="nav">
                  <li>
                     <xsl:attribute name="class" select="if ($focus eq 'topics') then 'active' else ''"/>
                     <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:value-of select="$base-uri"/>/topics</xsl:attribute>
                        <xsl:text>Topics</xsl:text>
                     </xsl:element>
                  </li>
                  <li>
                     <xsl:attribute name="class" select="if ($focus eq 'names') then 'active' else ''"/>
                     <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:value-of select="$base-uri"/>/names</xsl:attribute>
                        <xsl:text>Names</xsl:text>
                     </xsl:element>
                  </li>
                  <li>
                     <xsl:attribute name="class" select="if ($focus eq 'collections') then 'active' else ''"/>
                     <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:value-of select="$base-uri"/>/collections</xsl:attribute>
                        <xsl:text>Collections</xsl:text>
                     </xsl:element>
                  </li>
                  <li>
                     <xsl:attribute name="class" select="if ($focus eq 'repositories') then 'active' else ''"/>
                     <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:value-of select="$base-uri"/>/repositories</xsl:attribute>
                        <xsl:text>Locations</xsl:text>
                     </xsl:element>
                  </li>
               </ul>
               <xsl:if test="$focus != 'home' and $focus != 'search'">
               <div id="header-search">
                  <form id="header-search-form" action="{$base-uri}">
                     <label for="search-text">Global Search</label> 
                     <a class="header-btn header-search" href="#">
                        <span class="app-icon light"><img class="searchicon" src="magnifier.png"/></span>
                     </a>
                     <input id="search-text" type="text" name="v1" /> 
                     <input type="hidden" name="f1" value="kw"></input>
                     <input type="hidden" name="rpp" value="10"></input>
                     <input type="hidden" name="start" value="0"></input>
                     <input id="search-submit" type="submit" value="Search"/>    
                  </form>
               </div>
               </xsl:if>
            </div>
         </div>
      </div>
   </xsl:template>
   
   <xsl:template name="alt-nav">
      <xsl:param name="focus" as="xs:string?"/>
      <xsl:param name="base-uri" as="xs:string"/>
      <xsl:param name="record-id" as="xs:string"/>
      
      <div class="thinbar">
         <div class="container">
            <a href="http://www.princeton.edu"><img src="pu_logo_small.png" class="pulogo" border="0"/></a>
            
         </div>
      </div>
      <div class="topbar">
         <div class="fill">
            <div class="container">
               <xsl:element name="a">
                  <xsl:attribute name="class">brand</xsl:attribute>
                  <xsl:attribute name="href"><xsl:value-of select="$base-uri"/><xsl:value-of select="$record-id"/>.html</xsl:attribute>
                  <img src="pul_bug_small.png" class="pulbug" />
                  Princeton University Library Finding Aids </xsl:element>
            </div>
         </div>
      </div>
   </xsl:template>   
   

   <xsl:template name="search-box">
      <xsl:param name="kw" as="xs:string?"/>
      <xsl:param name="focus" as="xs:string?"/>
      <input>
         <!-- TO DO: last search? hints? context? Maybe remove this.
            <xsl:attribute name="placeholder" select="$kw"/>
         -->
         <xsl:attribute name="class">input span9</xsl:attribute>
         <xsl:attribute name="type">text</xsl:attribute>
         <xsl:attribute name="name">v1</xsl:attribute>
      </input>
      <input type="hidden" name="f1" value="kw"/>
      <input type="hidden" name="rpp" value="10"/>
      <input type="hidden" name="start" value="0"/>
      <button class="btn" type="submit">Search 
         <xsl:choose>
            <xsl:when test="$focus = 'topics'">
               This Topic
            </xsl:when>
            <xsl:when test="$focus = 'repositories'">
               This Location
            </xsl:when>
            <xsl:when test="$focus = 'search'" />
            <xsl:otherwise>
               <xsl:value-of select="concat(upper-case(substring($focus, 1, 1)), substring($focus, 2))" />
            </xsl:otherwise>
         </xsl:choose></button>
   </xsl:template>

   <xsl:template name="search-form">
      <xsl:param name="f1" as="xs:string?"/>
      <xsl:param name="v1" as="xs:string?"/>
      <xsl:param name="b1" as="xs:string?"/>
      <xsl:param name="f2" as="xs:string?"/>
      <xsl:param name="v2" as="xs:string?"/>
      <xsl:param name="b2" as="xs:string?"/>
      <xsl:param name="f3" as="xs:string?"/>
      <xsl:param name="v3" as="xs:string?"/>
      <xsl:param name="ed" as="xs:string?"/>
      <xsl:param name="ld" as="xs:string?"/>
      <xsl:param name="repo-f" as="xs:string?"/>
      <xsl:param name="su-f" as="xs:string?"/>
      <xsl:param name="cr-f" as="xs:string?"/>
      <xsl:param name="genre-f" as="xs:string?"/>
      <xsl:param name="coll-f" as="xs:string?"/>
      <xsl:param name="lang-f" as="xs:string?"/>
      <xsl:param name="has-digital-content" as="xs:string?"/>
      <xsl:param name="year" as="xs:string?"/>
      <xsl:param name="focus" as="xs:string?"/>
      
      <xsl:element name="form">
         <xsl:attribute name="id">search</xsl:attribute>
         <xsl:attribute name="method">GET</xsl:attribute>
         <xsl:attribute name="action"></xsl:attribute>
         <xsl:attribute name="class">form-stacked</xsl:attribute>
         <div class="clearfix" style="display:inline-block">
            <input id="simplebox" class="advancedSearchDropdownField input span7" type="text" name="v1" placeholder="What are you looking for?" value="{$v1}" />
            <span class="advanced" style="; display:none"> within </span><select
               class="dropdown advanced" style="width: 160px; display:none" name="f1">
               <xsl:element name="option">
                  <xsl:attribute name="value">kw</xsl:attribute>
                  <xsl:if test="$f1 = 'kw'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Keyword
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">ti</xsl:attribute>
                  <xsl:if test="$f1 = 'ti'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Title
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">sc</xsl:attribute>
                  <xsl:if test="$f1 = 'sc'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Scope &amp; and Content
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">cr</xsl:attribute>
                  <xsl:if test="$f1 = 'cr'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Author / Creator
               </xsl:element>
            </select>
            <select class="advancedSearchBoolDropdown advanced" style="width: 60px; display:none" name="b1">
               <xsl:element name="option">
                  <xsl:attribute name="value">AND</xsl:attribute>
                  <xsl:if test="$b1 = 'AND'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  and
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">OR</xsl:attribute>
                  <xsl:if test="$b1 = 'OR'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  or
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">NOT</xsl:attribute>
                  <xsl:if test="$b1 = 'NOT'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  not
               </xsl:element>
            </select>
         </div>
         <div class="advanced" style="display:none;">
            <xsl:call-template name="advanced-search2">
               <xsl:with-param name="v2" select="$v2"/>
               <xsl:with-param name="f2" select="$f2"/>
               <xsl:with-param name="b2" select="$b2"/>
               <xsl:with-param name="v3" select="$v3"/>
               <xsl:with-param name="f3" select="$f3"/>
            </xsl:call-template>
         </div>
         <div style="display:inline-block">
            <select class="dropdown" id="year" name="year" style="display: inline; width:160px;">
               <xsl:element name="option">
                  <xsl:attribute name="value">before</xsl:attribute>
                  <xsl:if test="$year = 'before'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Before or during
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">after</xsl:attribute>
                  <xsl:if test="$year = 'after'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  During or after
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">between</xsl:attribute>
                  <xsl:if test="$year = 'between'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if><xsl:text>Between</xsl:text></xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">in</xsl:attribute>
                  <xsl:if test="$year = 'in'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Exactly
               </xsl:element>
            </select>
            <input type="text" name="ed" size="4" class="span2" id="startyear" style="display: none;" value="{$ed}" placeholder="optional date" />
            <span id="betweenyear" style="display: inline;"> and </span>
            <input type="text" name="ld" size="4" class="span2" id="endyear" style="display: inline;" value="{$ld}" placeholder="optional date"/>
         </div>
         
         <input type="hidden" name="rpp" value="10"></input>
         <input type="hidden" name="start" value="0"></input>
         <!-- facets -->
         <xsl:if test="$repo-f">
            <input type="hidden" name="repo-f" value="{$repo-f}"></input>
         </xsl:if>
         <xsl:if test="$su-f">
            <input type="hidden" name="su-f" value="{$su-f}"></input>
         </xsl:if>
         <xsl:if test="$cr-f">
            <input type="hidden" name="cr-f" value="{$cr-f}"></input>
         </xsl:if>
         <xsl:if test="$genre-f">
            <input type="hidden" name="genre-f" value="{$genre-f}"></input>
         </xsl:if>
         <xsl:if test="$coll-f">
            <input type="hidden" name="coll-f" value="{$coll-f}"></input>
         </xsl:if>
         <xsl:if test="$lang-f">
            <input type="hidden" name="lang-f" value="{$lang-f}"></input>
         </xsl:if>
         <xsl:if test="$has-digital-content">
            <input type="hidden" name="has-digital-content" value="{$has-digital-content}"></input>
         </xsl:if>
         
         <div class="actions">
            <span class="help-block pull-left"><a id="toggle-as" href="" onClick="_gaq.push(['_trackEvent', 'Search', 'Click', 'Show Advanced Search']);">Show Advanced Search</a> | <a id="help-link" href="">Search Tips</a></span>
            <div class="pull-right"><button class="btn primary" type="submit">Search
               <xsl:choose>
                  <xsl:when test="$focus = 'topics'">
                     This Topic
                  </xsl:when>
                  <xsl:when test="$focus = 'repositories'">
                     This Location
                  </xsl:when>
                  <xsl:when test="$focus = 'search' or $focus = 'home'" />
                  <xsl:otherwise>
                     <xsl:value-of select="concat(upper-case(substring($focus, 1, 1)), substring($focus, 2))" />
                  </xsl:otherwise>
               </xsl:choose>
            </button>
            <button class="btn clr" type="reset">Clear</button></div>
         </div>
      </xsl:element>
   </xsl:template>

   <xsl:template name="advanced-search2">
      
      <xsl:param name="f2" as="xs:string?"/>
      <xsl:param name="v2" as="xs:string?"/>
      <xsl:param name="b2" as="xs:string?"/>
      <xsl:param name="f3" as="xs:string?"/>
      <xsl:param name="v3" as="xs:string?"/>
     
      
      <div class="clearfix">
            <input class="advancedSearchDropdownField input span7" id="v2" name="v2" maxlength="300" alt="Insert a
               search query here" value="{$v2}"/> within
            <select class="dropdown" style="width: 160px" name="f2">
               <xsl:element name="option">
                  <xsl:attribute name="value">kw</xsl:attribute>
                  <xsl:if test="$f2 = 'kw'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Keyword
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">ti</xsl:attribute>
                  <xsl:if test="$f2 = 'ti'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Title
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">sc</xsl:attribute>
                  <xsl:if test="$f2 = 'sc'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Scope and Content
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">cr</xsl:attribute>
                  <xsl:if test="$f2 = 'cr'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Author / Creator
               </xsl:element>
            </select>
            <select class="advancedSearchBoolDropdown" style="width: 60px" name="b2">
               <xsl:element name="option">
                  <xsl:attribute name="value">AND</xsl:attribute>
                  <xsl:if test="$b2 = 'AND'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  and
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">OR</xsl:attribute>
                  <xsl:if test="$b2 = 'OR'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  or
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">NOT</xsl:attribute>
                  <xsl:if test="$b2 = 'NOT'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  not
               </xsl:element>
            </select>
         
      </div>
      <div class="clearfix">
         <input class="advancedSearchDropdownField input span7" id="v3" name="v3" maxlength="300" alt="Insert a search query here" value="{$v3}"/> within <select
               class="dropdown" style="width: 160px" name="f3">
               <xsl:element name="option">
                  <xsl:attribute name="value">kw</xsl:attribute>
                  <xsl:if test="$f3 = 'kw'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Keyword
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">ti</xsl:attribute>
                  <xsl:if test="$f3 = 'ti'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Title
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">sc</xsl:attribute>
                  <xsl:if test="$f3 = 'sc'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Scope &amp; and Content
               </xsl:element>
               <xsl:element name="option">
                  <xsl:attribute name="value">cr</xsl:attribute>
                  <xsl:if test="$f3 = 'cr'">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Author / Creator
               </xsl:element>
            </select>
         
      </div>
      
   </xsl:template>

   <xsl:template name="advanced-search">
      <xsl:param name="kw" as="xs:string?"/>
      <div class="clearfix">
         <p class="advancedSearchRow">
            <input class="advancedSearchDropdownField" name="v1" size="30" maxlength="300" alt="Insert a search query here" value=""/> within <select
               class="dropdown" style="width: 160px" name="f1">
               <option value="kw">Keyword</option>
               <option value="ti">Title</option>
               <option value="sc">Scope and Content</option>
               <option value="cr">Author / Creator</option>
               <option value="su">Subject</option>
            </select>
            <select class="advancedSearchBoolDropdown" style="width: 60px" name="b1">
               <option value="AND">and</option>
               <option value="OR">or</option>
               <option value="NOT">not</option>
            </select>
         </p>
      </div>
      <div class="clearfix">
         <p class="advancedSearchRow">
            <input class="advancedSearchDropdownField" name="v2" size="30" maxlength="300" alt="Insert a
               search query here" value=""/> within
            <select class="dropdown" style="width: 160px" name="f2">
               <option value="kw">Keyword</option>
               <option value="ti">Title</option>
               <option value="sc">Scope &amp; and Content</option>
               <option value="cr">Author / Creator</option>
               <option value="su">Subject</option>
               <option value="ab">Abstract</option>
               <option value="bh">Bibliographic and Historical Notes</option>
            </select>
            <select class="advancedSearchBoolDropdown" style="width: 60px" name="b2">
               <option value="AND">and</option>
               <option value="OR">or</option>
               <option value="NOT">not</option>
            </select>
         </p>
      </div>
      <div class="clearfix">
         <p class="advancedSearchRow">
            <input class="advancedSearchDropdownField" name="v3" size="30" maxlength="300" alt="Insert a search query here" value=""/> within <select
               class="dropdown" style="width: 160px" name="f3">
               <option value="kw">Keyword</option>
               <option value="ti">Title</option>
               <option value="sc">Scope &amp; and Content</option>
               <option value="cr">Author / Creator</option>
               <option value="su">Subject</option>
               <option value="ab">Abstract</option>
               <option value="bh">Bibliographic and Historical Notes</option>
            </select>
         </p>
      </div>
      <div class="clearfix">
         <p>Dates: <select class="dropdown" id="year" name="year" style="display: inline; width:160px;">
            <option value="before">Before or during</option>
            <option value="after">During or after</option>
            <option value="between">Between</option>
            <option value="in">Exactly</option>
         </select>
            <input type="text" name="ed" size="4" class="span2" id="startyear" style="display: none;" value=""/>
            <span id="betweenyear" style="display: inline;"> and </span>
            <input type="text" name="ld" size="4" class="span2" id="endyear" style="display: inline;" value=""/>
         </p>
      </div>
      <input type="hidden" name="rpp" value="10"/>
      <input type="hidden" name="start" value="0"/>
   </xsl:template>
   

   <xsl:template name="recursion">
      <xsl:param name="counter" as="xs:integer"/>
      <xsl:param name="limit" as="xs:integer"/>
      <xsl:param name="current" as="xs:integer"/>
      <xsl:param name="self" as="xs:string"/>
      <xsl:param name="rpp" as="xs:integer"/>

      <xsl:if test="not($counter > $limit)">
         <xsl:element name="li">
            <xsl:if test="$counter eq $current">
               <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <xsl:element name="a">
               <xsl:attribute name="href">
                  <xsl:value-of select="substring-before($self, 'start')"/>
                  <xsl:analyze-string select="$self" regex="start=(\d*)">
                     <xsl:matching-substring>
                        <xsl:text>start=</xsl:text>
                        <xsl:value-of select="($counter - 1) * $rpp"/>
                        <xsl:text>&amp;rpp=</xsl:text>
                        <xsl:value-of select="$rpp"/>
                     </xsl:matching-substring>
                  </xsl:analyze-string>
               </xsl:attribute>
               <xsl:value-of select="$counter"/>
            </xsl:element>
         </xsl:element>

         <xsl:call-template name="recursion">
            <xsl:with-param name="counter">
               <xsl:value-of select="$counter + 1"/>
            </xsl:with-param>
            <xsl:with-param name="limit">
               <xsl:value-of select="$limit"/>
            </xsl:with-param>
            <xsl:with-param name="current">
               <xsl:value-of select="$current"/>
            </xsl:with-param>
            <xsl:with-param name="self">
               <xsl:value-of select="$self"/>
            </xsl:with-param>
            <xsl:with-param name="rpp">
               <xsl:value-of select="$rpp"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>

   </xsl:template>

   <xsl:template name="recurse_pages">
      <xsl:param name="num" as="xs:integer" select="1"/>
      <xsl:param name="adjacents" as="xs:integer" select="2"/>
      <xsl:param name="total" as="xs:integer"/>
      <xsl:param name="pages" as="xs:integer"/>
      <xsl:param name="current" as="xs:integer"/>
      <xsl:param name="self" as="xs:string"/>
      <xsl:param name="rpp" as="xs:integer"/>
      <xsl:param name="page_display_max" as="xs:integer"/>

      <xsl:choose>
         <xsl:when test="$page_display_max >= $pages">

            <!-- not enough pages to bother breaking it up -->
            <xsl:call-template name="recursion">
               <xsl:with-param name="counter">
                  <xsl:value-of select="$num"/>
               </xsl:with-param>
               <xsl:with-param name="limit">
                  <xsl:value-of select="$pages"/>
               </xsl:with-param>
               <xsl:with-param name="current">
                  <xsl:value-of select="$current"/>
               </xsl:with-param>
               <xsl:with-param name="self">
                  <xsl:value-of select="$self"/>
               </xsl:with-param>
               <xsl:with-param name="rpp">
                  <xsl:value-of select="$rpp"/>
               </xsl:with-param>
            </xsl:call-template>

         </xsl:when>
         <xsl:otherwise>

            <!-- close to beginning; only hide later pages -->
            <xsl:choose>
               <xsl:when test="$current lt 1 + ($adjacents * 2)">

                  <xsl:call-template name="recursion">
                     <xsl:with-param name="counter">
                        <xsl:value-of select="1"/>
                     </xsl:with-param>
                     <xsl:with-param name="limit">
                        <xsl:value-of select="3 + $adjacents * 2"/>
                     </xsl:with-param>
                     <xsl:with-param name="current">
                        <xsl:value-of select="$current"/>
                     </xsl:with-param>
                     <xsl:with-param name="self">
                        <xsl:value-of select="$self"/>
                     </xsl:with-param>
                     <xsl:with-param name="rpp">
                        <xsl:value-of select="$rpp"/>
                     </xsl:with-param>
                  </xsl:call-template>

                  <!-- spacer -->
                  <xsl:element name="li">
                     <xsl:attribute name="class">disabled</xsl:attribute>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:text>#</xsl:text>
                        </xsl:attribute>
                        <xsl:text>...</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <!-- last page -->
                  <xsl:element name="li">
                     <xsl:if test="$pages eq $current">
                        <xsl:attribute name="class">active</xsl:attribute>
                     </xsl:if>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:value-of select="substring-before($self, 'start')"/>
                           <xsl:text>start=</xsl:text>
                           <xsl:value-of select="($pages - 1) * $rpp"/>
                           <xsl:text>&amp;rpp=</xsl:text>
                           <xsl:value-of select="$rpp"/>
                        </xsl:attribute>
                        <xsl:value-of select="$pages"/>
                     </xsl:element>
                  </xsl:element>

               </xsl:when>
               <xsl:when test="$pages - ($adjacents * 2) > $current and $current > $adjacents * 2">
                  <!-- in middle; hide some front and some back -->
                  <!-- page 1 -->
                  <xsl:element name="li">
                     <xsl:if test="$current = 1">
                        <xsl:attribute name="class">active</xsl:attribute>
                     </xsl:if>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:value-of select="substring-before($self, 'start')"/>
                           <xsl:text>start=0</xsl:text>
                           <xsl:text>&amp;rpp=</xsl:text>
                           <xsl:value-of select="$rpp"/>
                        </xsl:attribute>
                        <xsl:text>1</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <!-- spacer -->
                  <xsl:element name="li">
                     <xsl:attribute name="class">disabled</xsl:attribute>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:text>#</xsl:text>
                        </xsl:attribute>
                        <xsl:text>...</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <xsl:call-template name="recursion">
                     <xsl:with-param name="counter">
                        <xsl:value-of select="$current - $adjacents"/>
                     </xsl:with-param>
                     <xsl:with-param name="limit">
                        <xsl:value-of select="$current + $adjacents"/>
                     </xsl:with-param>
                     <xsl:with-param name="current">
                        <xsl:value-of select="$current"/>
                     </xsl:with-param>
                     <xsl:with-param name="self">
                        <xsl:value-of select="$self"/>
                     </xsl:with-param>
                     <xsl:with-param name="rpp">
                        <xsl:value-of select="$rpp"/>
                     </xsl:with-param>
                  </xsl:call-template>

                  <!-- spacer -->
                  <xsl:element name="li">
                     <xsl:attribute name="class">disabled</xsl:attribute>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:text>#</xsl:text>
                        </xsl:attribute>
                        <xsl:text>...</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <!-- last page -->
                  <xsl:element name="li">
                     <xsl:if test="$pages eq $current">
                        <xsl:attribute name="class">active</xsl:attribute>
                     </xsl:if>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:value-of select="substring-before($self, 'start')"/>
                           <xsl:text>start=</xsl:text>
                           <xsl:value-of select="($pages - 1) * $rpp"/>
                           <xsl:text>&amp;rpp=</xsl:text>
                           <xsl:value-of select="$rpp"/>
                        </xsl:attribute>
                        <xsl:value-of select="$pages"/>
                     </xsl:element>
                  </xsl:element>

               </xsl:when>
               <xsl:otherwise>
                  <!-- //close to end; only hide early pages -->

                  <!-- page 1 -->
                  <xsl:element name="li">
                     <xsl:if test="$current = 1">
                        <xsl:attribute name="class">active</xsl:attribute>
                     </xsl:if>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:value-of select="substring-before($self, 'start')"/>
                           <xsl:text>start=0</xsl:text>
                           <xsl:text>&amp;rpp=</xsl:text>
                           <xsl:value-of select="$rpp"/>
                        </xsl:attribute>
                        <xsl:text>1</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <!-- spacer -->
                  <xsl:element name="li">
                     <xsl:attribute name="class">disabled</xsl:attribute>
                     <xsl:element name="a">
                        <xsl:attribute name="href">
                           <xsl:text>#</xsl:text>
                        </xsl:attribute>
                        <xsl:text>...</xsl:text>
                     </xsl:element>
                  </xsl:element>

                  <xsl:call-template name="recursion">
                     <xsl:with-param name="counter">
                        <xsl:value-of select="$pages - ($adjacents * 3)"/>
                     </xsl:with-param>
                     <xsl:with-param name="limit">
                        <xsl:value-of select="$pages"/>
                     </xsl:with-param>
                     <xsl:with-param name="current">
                        <xsl:value-of select="$current"/>
                     </xsl:with-param>
                     <xsl:with-param name="self">
                        <xsl:value-of select="$self"/>
                     </xsl:with-param>
                     <xsl:with-param name="rpp">
                        <xsl:value-of select="$rpp"/>
                     </xsl:with-param>
                  </xsl:call-template>

               </xsl:otherwise>
            </xsl:choose>

         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
