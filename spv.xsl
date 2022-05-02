<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   xmlns:exist="http://exist.sourceforge.net/NS/exist" 
   xmlns:pul="http://diglib.princeton.edu/ns/diglib/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:ead="urn:isbn:1-931666-22-9" xmlns:local="local.uri"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns:pulfa="http://library.princeton.edu/pulfa"
   xmlns:xlink="http://www.w3.org/1999/xlink" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:lib="http://findingaids.princeton.edu/pulfa/2/lib"
   xmlns:mix="http://www.loc.gov/mix/v20"
   xmlns:mets="http://www.loc.gov/METS/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:ov="http://open.vocab.org/terms/" xmlns:vc="http://www.w3.org/2006/vcard/ns#">

   <xsl:output method="html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>
	
   <!--<xsl:param name="xslt.base-uri" as="xs:string" select="'file:///C:/Users/Public/Documents/morrison'"/>-->
	<xsl:param name="xslt.base-uri" as="xs:string" select="'/Users/heberleinr/Documents/pulfa-restricted'"/>
	
   <xsl:param name="xslt.record-id" as="xs:string" select="'C1491'"/>
   <xsl:include href="lib.xsl"/> 
   <xsl:include href="includes.xsl"/> 
   
   <!-- globals ============================================================ -->
   <xsl:template match="ead:head"/>
   <xsl:template match="ead:revisiondesc"/>

   <xsl:variable name="aeon-url" select="'https://libweb10.princeton.edu/aeon/Aeon.dll'" />
   <xsl:variable name="collections-base-uri" select="concat($xslt.base-uri, '/collections')" as="xs:string"/>
<!-- RH 2022: aspace path is archdesc/did/repository/corpname; no attributes; this is a controlled value so no need for string-matching  -->   
<xsl:variable name="repo">
	<xsl:value-of select="//ead:archdesc/ead:did/ead:repository/ead:corpname"/>
</xsl:variable>
   <xsl:variable name="repohref">
      <xsl:choose>
         <xsl:when test="$repo eq 'Mudd Manuscript Library'">
            <xsl:text>http://rbsc.princeton.edu/mudd</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Manuscripts Division'">
            <xsl:text>http://rbsc.princeton.edu/divisions/manuscripts-division</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Rare Book Division'">
            <xsl:text>http://rbsc.princeton.edu/divisions/rare-book-division</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Latin American Collections'">
            <xsl:text>http://firestone.princeton.edu/latinam/ephemera.php</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Engineering Library'">
            <xsl:text>http://library.princeton.edu/engineering</xsl:text>
         </xsl:when>
<!-- RH 2022: Replace superseded link-->
      	<xsl:otherwise>https://library.princeton.edu/special-collections/</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="repocontact">
       <xsl:choose>
         <xsl:when test="$repo eq 'Mudd Manuscript Library'">
            <xsl:text>http://rbsc.princeton.edu/ask-question/</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Manuscripts Division'">
            <xsl:text>http://rbsc.princeton.edu/ask-question/</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Rare Book Division'">
            <xsl:text>http://rbsc.princeton.edu/ask-question/</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Latin American Collections'">
            <xsl:text>https://libguides.princeton.edu/laec</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Engineering Library'">
            <xsl:text>http://library.princeton.edu/engineering</xsl:text>
         </xsl:when>
         <xsl:when test="$repo eq 'Mendel Music Library'">
            <xsl:text>http://library.princeton.edu/music</xsl:text>
         </xsl:when>
       	<xsl:otherwise>https://library.princeton.edu/special-collections/</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
<!-- RH 2022 are these still used? -->
   <!--<xsl:variable name="ark" select="/ead:ead/ead:eadheader/ead:eadid/@url"/>
   <xsl:variable name="id" select="substring-after(/ead:ead/ead:eadheader/ead:eadid/@url, 'princeton.edu/')"/>
  -->
<!-- RH 2022 update link -->
   <xsl:variable name="VOYAGER_QUERY_BASE">
   	<xsl:value-of select="'https://catalog.princeton.edu/catalog'"/>
   </xsl:variable>

   <xsl:function name="pul:strip-trailspace">
      <xsl:param name="string"/>
      <xsl:choose>
         <xsl:when test="ends-with($string, ' ')">
            <xsl:variable name="len" select="string-length($string)"/>
            <xsl:value-of select="substring($string, 1, $len - 1)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:template match="/">
      <html xmlns="http://www.w3.org/1999/xhtml">
         <head>
            <base href="{$xslt.base-uri}/"/>
            <title>
                <xsl:value-of select="$repo"/><xsl:value-of select="//ead:titleproper[1]"/>
            </title>
            <xsl:call-template name="standard-head">
               <xsl:with-param name="base-uri" select="$xslt.base-uri"></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="standard-css"/>
            <link rel="stylesheet" type="text/css" href="css/classic.css" media="all"/>
            <link rel="canonical" href="{$xslt.base-uri}/{$xslt.record-id}.html"/>
         </head>
         <body>
            <xsl:call-template name="alt-nav">
               <xsl:with-param name="focus" select="'collections'"/>
               <xsl:with-param name="base-uri" select="$xslt.base-uri"/>
               <xsl:with-param name="record-id" select="$xslt.record-id"/>
            </xsl:call-template>
            
            <div class="container">
               
               <div class="content">
                  <div id="main">
                     <div id="header">
                        <h1>
                           <xsl:value-of select="//ead:archdesc/ead:did/ead:unittitle"/>
                        </h1>
                     </div>
                     <div id="mainContent">
                        
                        <xsl:call-template name="menu"/>
                        <xsl:apply-templates select="ead:ead"/>
                     </div>
                  </div>
               </div>
            </div>
            <script language="Javascript" type="text/javascript" src="js/jquery-1.12.3.min.js"><!-- # --></script>
            <script language="Javascript" type="text/javascript" src="js/local.js"><!-- # --></script>
         </body>
         
      </html>
   </xsl:template>

   <xsl:template name="nav"> </xsl:template>

   <xsl:template name="menu">
      <ul id="menu">
         <li class="menuRepoLink">
            <!--<a href="{$repohref}">-->
               <xsl:value-of select="$repo"/>
            <!--</a>-->
         </li>

         <!--<li>
            <a href="{$repocontact}">Contact</a>
         </li>-->
         <xsl:if test="//ead:archdesc/ead:did">
            <li>
               <a href="{$xslt.base-uri}/index.html#collectionDid">
                  <xsl:text>Summary Information</xsl:text>
               </a>
            </li>
         </xsl:if>
<!-- RH 2022: This will never be true, adding namespace prefix -->
         <xsl:if test="//ead:archdesc/ead:bioghist[ead:p]">
            <li>
               <a href="{$xslt.base-uri}/index.html#bioghist">
                  <xsl:choose>
<!-- RH 2022: We need to distinguish these by nested element, @encodinganalog was lost during the migration-->
<!-- RH 2022: relative path doesn't work here, changing to absolute -->
                  	<xsl:when test="//ead:archdesc/ead:did/ead:origination/(ead:persname|ead:famname)">
                        <xsl:text>Biography</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                        	<xsl:when test="//ead:archdesc/ead:did/ead:origination/ead:corpname">
                              <xsl:text>Organizational History</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>Biography/History</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:otherwise>
                  </xsl:choose>
               </a>
            </li>
         </xsl:if>
<!-- RH 2022: fix paths to notes -->
         <xsl:if test="//ead:archdesc/ead:scopecontent">
            <li>
               <a href="{$xslt.base-uri}/index.html#scopecontent">
                  <!--<xsl:value-of
                            select="//ead:archdesc/ead:descgrp[@id='dacs3']/ead:scopecontent/ead:head"
                        />-->
                  <xsl:text>Description</xsl:text>
               </a>
            </li>
         </xsl:if>
         <xsl:if test="//ead:archdesc/ead:arrangement">
            <li>
               <a href="{$xslt.base-uri}/index.html#arrangement">Arrangement</a>
            </li>
         </xsl:if>
         <xsl:if test="//ead:archdesc/ead:accessrestrict">
            <li>
               <a href="{$xslt.base-uri}/index.html#accessrestrict">Information for Users</a>
            </li>
         </xsl:if>
         <!--<xsl:if test="//ead:archdesc/ead:controlaccess">
            <li>
               <a href="{$xslt.base-uri}/index.html#controlaccess">Subject Headings</a>
            </li>
         </xsl:if>-->

         <xsl:if test="//ead:archdesc/ead:dsc">
            <li>
               <a href="{$xslt.base-uri}/index.html#dsc">Contents List</a>
            </li>
         </xsl:if>


         <xsl:for-each
            select="//ead:archdesc/ead:dsc/(ead:c01[@level='series']|ead:c[@level='series']) | 
            //ead:archdesc/ead:dsc/(ead:c01[@level='subgrp']|ead:c[@level='subgrp'])">
            <xsl:variable name="sansUnitdate" select="replace(ead:did/ead:unittitle, '(.*),\s*\d\d\d\d.*', '$1', 'm')"/>
            <li>
               <a href="{$xslt.base-uri}/index.html#{@id}">
                  <xsl:value-of select="$sansUnitdate"/>
               </a>
            </li>
         </xsl:for-each>
      </ul>
   </xsl:template>

   <!-- ead:eadheader/* ======================================= -->
   <xsl:template match="ead:eadheader" exclude-result-prefixes="#all">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="ead:filedesc">
      <xsl:apply-templates select="ead:titlestmt" mode="sponsor"/>
   </xsl:template>

   <!-- hide ead:eadid/text() -->
   <xsl:template match="ead:eadid"/>

   <xsl:template match="ead:titlestmt" mode="sponsor">
      <xsl:if test="ead:sponsor">
         <p class="sponsor">
            <xsl:apply-templates select="ead:sponsor"/>
         </p>
      </xsl:if>
   </xsl:template>
   <xsl:template match="ead:profiledesc"/>
   <!--
   <xsl:template match="ead:profiledesc">
      <p class="copyright">
         <xsl:text>&#169;</xsl:text>
         <xsl:value-of select="replace(ead:creation/ead:date/@normal, '(\p{N}{4}).*', '$1', 'm')"/>
         <!-\- <xsl:value-of select="year-from-date(current-date())"/>  -\->
         <xsl:text> Princeton University Library</xsl:text>
      </p>
   </xsl:template>-->

   <!-- ead:archdesc/* ======================================== -->
   <xsl:template match="ead:archdesc">
<!-- RH 2022: Fix paths post-migration; no more dacs groupings for the notes -->
      <!--<xsl:apply-templates/>-->
      <xsl:apply-templates select="ead:did"/>
      <xsl:apply-templates select="ead:bioghist"/>
      <xsl:apply-templates select="ead:scopecontent"/>
      <xsl:apply-templates select="ead:arrangement"/>
      <xsl:apply-templates select="ead:accessrestrict | ead:userestrict | ead:phystech"/>
      <xsl:apply-templates select="ead:acqinfo | ead:appraisal | ead:accruals"/>
      <xsl:apply-templates select="ead:relatedmaterial"/>
      <xsl:apply-templates select="ead:prefercite | ead:processinfo"/>
      <!--<xsl:apply-templates select="ead:controlaccess"/>-->
      <xsl:apply-templates select="ead:dsc"/>
      <xsl:apply-templates select="ead:index"/>
      <xsl:apply-templates select="ead:odd"/>
   </xsl:template>

   <xsl:template match="ead:archdesc/ead:did">
      <h4 id="collectionDid" class="summary">Summary Information</h4>
      <dl>
         <xsl:apply-templates select="ead:origination"/>
         <xsl:apply-templates select="ead:unittitle"/>
         <xsl:apply-templates select="ead:unitdate[@type='inclusive']"/>
         <xsl:apply-templates select="ead:unitdate[@type='bulk']"/>
         <xsl:apply-templates select="ead:unitdate[not(@type)]"/>
         <xsl:apply-templates select="ead:abstract"/>
         <xsl:apply-templates select="ead:physdesc"/>
         <xsl:apply-templates select="ead:unitid"/>
         <xsl:apply-templates select="ead:repository"/>
         <xsl:apply-templates select="ead:langmaterial"/>
         <xsl:apply-templates select="ead:physloc"/>
      </dl>
   </xsl:template>

   <!-- descendants of ead:did ============================================= -->
   <xsl:template match="ead:archdesc/ead:did/ead:origination">
      <xsl:for-each select="ead:persname|ead:corpname|ead:famname|ead:name">
         <dt class="archdescLabel">
            <xsl:text>Creator: </xsl:text>
         </dt>
         <dd class="archdescData">
            <xsl:variable name="subjectName" select="replace(., '(\.| )$', '', 'm')"/>
            <xsl:variable name="voyQuery">
               <xsl:value-of select="$VOYAGER_QUERY_BASE"/>
               <xsl:text>?utf8=true&amp;search_field=all_fields&amp;q=</xsl:text>
               <xsl:value-of select="replace(normalize-space($subjectName), ' ', '+', 'm')"/>
<!-- RH 2022 Do we still need this? -->
<!--               <xsl:text>&amp;Search_Code=NAME_&amp;CNT=50</xsl:text>-->
            </xsl:variable>
            <a href="{$voyQuery}">
               <xsl:apply-templates/>
            </a>
         </dd>
      </xsl:for-each>
   </xsl:template>


   <!-- RH: ead:physdesc without children in the high level did -->
   <xsl:template match="ead:physdesc[not(ancestor::ead:dsc)]">
      <xsl:if test=".[not(ead:*)]">
         <dt class="archdescLabel">
            <xsl:text>Physical Description: </xsl:text>
         </dt>
         <dd class="archdescData">
            <xsl:apply-templates/>
         </dd>
      </xsl:if>
      <xsl:if test="ead:physfacet">
         <dt class="archdescLabel">
            <xsl:text>Physical Characteristics: </xsl:text>
         </dt>
         <dd class="archdescData">
            <xsl:apply-templates/>
         </dd>
      </xsl:if>
      <xsl:if test="ead:extent[not(@type)]">
         <dt class="archdescLabel">
            <xsl:text>Size: </xsl:text>
         </dt>
         <xsl:for-each select="ead:extent[not(@type)]">
            <dd class="archdescData">
               <xsl:apply-templates/>
            </dd>
         </xsl:for-each>
      </xsl:if>
      <xsl:if test="ead:dimensions">
         <dt class="archdescLabel">
            <xsl:text>Dimensions: </xsl:text>
         </dt>
         <dd class="archdescData">
            <xsl:apply-templates/>
         </dd>
      </xsl:if>
   </xsl:template>

   <!-- this could use some cleanup. JPS, 9/30/2008 -->
   <xsl:template match="ead:unittitle[not(ancestor::ead:dsc) and not(ancestor::ead:item)]">
      <!--        <xsl:choose>-->
      <!-- is this ever used? -->
      <!--            <xsl:when test="ancestor::*[matches(local-name(), '^c(0\d)?$')]">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>-->
      <dt class="archdescLabel">
         <xsl:text>Title and dates: </xsl:text>
      </dt>
      <dd class="archdescData">
         <xsl:apply-templates/>
      </dd>
      <!--            </xsl:otherwise>
        </xsl:choose>-->
   </xsl:template>
   <xsl:template match="ead:abstract">
      <dt class="archdescLabel">
         <xsl:text>Abstract: </xsl:text>
      </dt>
      <dd class="archdescData">
         <xsl:apply-templates/>
      </dd>
   </xsl:template>
   <xsl:template match="ead:unitid[not(ancestor::ead:dsc)]">
      <dt class="archdescLabel">
         <xsl:text>Call number: </xsl:text>
      </dt>
      <dd class="archdescData">
         <xsl:apply-templates/>
      </dd>
   </xsl:template>
   <xsl:template match="ead:note">
      <dt class="archdescLabel">
         <xsl:text>General Note: </xsl:text>
      </dt>
      <dd class="archdescData">
         <xsl:apply-templates/>
      </dd>
   </xsl:template>

   <xsl:template match="ead:physloc">
      <xsl:choose>
         <!-- is this ever used? -->
         <xsl:when test="ancestor::*[matches(local-name(), '^c(0\d)?$')]">
            <p>
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="@type='text'">
                  <dt class="archdescLabel">
                     <xsl:text>Storage note: </xsl:text>
                  </dt>
                  <dd class="archdescData">
                     <xsl:apply-templates/>
                  </dd>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when
                        test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                  and @type='code' and matches(., '^mudd$')">
                        <dt class="archdescLabel">
                           <xsl:text>Storage note: </xsl:text>
                        </dt>
                        <dd class="archdescData">This collection is stored onsite at the Mudd Manuscript Library.</dd>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                           <xsl:when
                              test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                              and @type='code' and (matches(., '^rcpph$') or matches(., '^rcppf$') or matches(., '^rcpxg$') or matches(., '^rcpxm$') 
                              or matches(., '^rcpxr$') or matches(., '^rcppa$') or matches(., '^rcpxc$'))">
                              <dt class="archdescLabel">
                                 <xsl:text>Storage note: </xsl:text>
                              </dt>
                              <dd class="archdescData">This collection is stored offsite at the ReCAP facility.</dd>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when
                                    test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                                    and @type='code' and (matches(., '^flm$') or matches(., '^flmp$') or matches(., '^wa$') or matches(., '^gax$') 
                                    or matches(., '^mss$') or matches(., '^ex$') or matches(., '^flmm$')                                    
                                    or matches(., '^ctsn$') or matches(., '^thx$'))">
                                    <dt class="archdescLabel">
                                       <xsl:text>Storage note: </xsl:text>
                                    </dt>
                                    <dd class="archdescData">This collection is stored onsite at Firestone Library.</dd>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when
                                          test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                                          and @type='code' and (matches(., '^hsvc$') or matches(., '^hsvg$') or matches(., '^hsvm$') or matches(., '^hsvr$'))">
                                          <dt class="archdescLabel">
                                             <xsl:text>Storage note: </xsl:text>
                                          </dt>
                                          <dd class="archdescData">This collection is stored in special vault facilities at Firestone Library.</dd>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:choose>
                                             <xsl:when
                                                test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                                          and @type='code' and (matches(., '^anxb$'))">
                                                <dt class="archdescLabel">
                                                   <xsl:text>Storage note: </xsl:text>
                                                </dt>
                                                <dd class="archdescData">This collection is stored offsite at Annex B (Fine Hall).</dd>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:choose>
                                                   <xsl:when
                                                      test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                                                and @type='code' and (matches(., '^st$'))">
                                                      <dt class="archdescLabel">
                                                         <xsl:text>Storage note: </xsl:text>
                                                      </dt>
                                                      <dd class="archdescData">This collection is stored onsite at the Engineering Library.</dd>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <xsl:choose>
                                                         <xsl:when
                                                            test="not(preceding-sibling::ead:physloc[@type='text'] | following-sibling::ead:physloc[@type='text']) 
                                                      and @type='code' and (matches(., '^ppl$'))">
                                                            <dt class="archdescLabel">
                                                               <xsl:text>Storage note: </xsl:text>
                                                            </dt>
                                                            <dd class="archdescData">This collection is stored onsite at the Plasma Physics Library.</dd>
                                                         </xsl:when>
                                                         <xsl:otherwise>
                                                            <xsl:choose>
                                                               <xsl:when test="not(@type)">
                                                                  <dt class="archdescLabel">
                                                                     <xsl:text>Storage note: </xsl:text>
                                                                  </dt>
                                                                  <dd class="archdescData">
                                                                     <xsl:apply-templates/>
                                                                  </dd>
                                                               </xsl:when>
                                                            </xsl:choose>
                                                         </xsl:otherwise>
                                                      </xsl:choose>
                                                   </xsl:otherwise>
                                                </xsl:choose>

                                             </xsl:otherwise>

                                          </xsl:choose>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- RH: insert "bulk" when @type='bulk' -->
   <xsl:template match="ead:archdesc/ead:did/ead:unitdate">
      <dd class="archdescData">
         <!-- RH: add "bulk" for @type='bulk' -->
         <xsl:choose>
            <xsl:when test="@type='inclusive'">
               <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="@type='bulk'">
                     <xsl:text>bulk </xsl:text>
                     <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="not(@type)">
                           <xsl:apply-templates/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </dd>
   </xsl:template>

   <!-- RH edit: keep languages from being squished together -->
   <xsl:template match="ead:langmaterial[not(ancestor::ead:dsc)]">
      <dt class="archdescLabel">
         <xsl:text>Language(s) of materials: </xsl:text>
      </dt>
      <xsl:for-each select="ead:language">
         <dd class="archdescData">
            <xsl:choose>
               <xsl:when test="@langcode='aar'">
                  <xsl:text>Afar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aa'">
                  <xsl:text>Afar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='abk'">
                  <xsl:text>Abkhazian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ab'">
                  <xsl:text>Abkhazian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ace'">
                  <xsl:text>Achinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ach'">
                  <xsl:text>Acoli</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ada'">
                  <xsl:text>Adangme</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ady'">
                  <xsl:text>Adyghe or Adygei</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afa'">
                  <xsl:text>Afro-Asiatic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afh'">
                  <xsl:text>Afrihili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afr'">
                  <xsl:text>Afrikaans</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='af'">
                  <xsl:text>Afrikaans</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ain'">
                  <xsl:text>Ainu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aka'">
                  <xsl:text>Akan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ak'">
                  <xsl:text>Akan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='akk'">
                  <xsl:text>Akkadian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alb'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sqi'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sq'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ale'">
                  <xsl:text>Aleut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alg'">
                  <xsl:text>Algonquian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alt'">
                  <xsl:text>Southern Altai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='amh'">
                  <xsl:text>Amharic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='am'">
                  <xsl:text>Amharic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ang'">
                  <xsl:text>English, Old (ca.450-1100)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='anp'">
                  <xsl:text>Angika</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='apa'">
                  <xsl:text>Apache languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ara'">
                  <xsl:text>Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ar'">
                  <xsl:text>Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arc'">
                  <xsl:text>Aramaic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arg'">
                  <xsl:text>Aragonese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='an'">
                  <xsl:text>Aragonese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arm'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hye'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hy'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arn'">
                  <xsl:text>Mapudungun or Mapuche</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arp'">
                  <xsl:text>Arapaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='art'">
                  <xsl:text>Artificial (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arw'">
                  <xsl:text>Arawak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='asm'">
                  <xsl:text>Assamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='as'">
                  <xsl:text>Assamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ast'">
                  <xsl:text>Asturian or Bable</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ath'">
                  <xsl:text>Athapascan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aus'">
                  <xsl:text>Australian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ava'">
                  <xsl:text>Avaric</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='av'">
                  <xsl:text>Avaric</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ave'">
                  <xsl:text>Avestan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ae'">
                  <xsl:text>Avestan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='awa'">
                  <xsl:text>Awadhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aym'">
                  <xsl:text>Aymara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ay'">
                  <xsl:text>Aymara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aze'">
                  <xsl:text>Azerbaijani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='az'">
                  <xsl:text>Azerbaijani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bad'">
                  <xsl:text>Banda languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bai'">
                  <xsl:text>Bamileke languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bak'">
                  <xsl:text>Bashkir</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ba'">
                  <xsl:text>Bashkir</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bal'">
                  <xsl:text>Baluchi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bam'">
                  <xsl:text>Bambara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bm'">
                  <xsl:text>Bambara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ban'">
                  <xsl:text>Balinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='baq'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eus'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eu'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bas'">
                  <xsl:text>Basa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bat'">
                  <xsl:text>Baltic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bej'">
                  <xsl:text>Beja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bel'">
                  <xsl:text>Belarusian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='be'">
                  <xsl:text>Belarusian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bem'">
                  <xsl:text>Bemba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ben'">
                  <xsl:text>Bengali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bn'">
                  <xsl:text>Bengali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ber'">
                  <xsl:text>Berber (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bho'">
                  <xsl:text>Bhojpuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bih'">
                  <xsl:text>Bihari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bh'">
                  <xsl:text>Bihari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bik'">
                  <xsl:text>Bikol</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bin'">
                  <xsl:text>Bini or Edo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bis'">
                  <xsl:text>Bislama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bi'">
                  <xsl:text>Bislama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bla'">
                  <xsl:text>Siksika</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bnt'">
                  <xsl:text>Bantu (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bos'">
                  <xsl:text>Bosnian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bs'">
                  <xsl:text>Bosnian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bra'">
                  <xsl:text>Braj</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bre'">
                  <xsl:text>Breton</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='br'">
                  <xsl:text>Breton</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='btk'">
                  <xsl:text>Batak languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bua'">
                  <xsl:text>Buriat</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bug'">
                  <xsl:text>Buginese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bul'">
                  <xsl:text>Bulgarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bg'">
                  <xsl:text>Bulgarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bur'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mya'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='my'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='byn'">
                  <xsl:text>Blin or Bilin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cad'">
                  <xsl:text>Caddo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cai'">
                  <xsl:text>Central American Indian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='car'">
                  <xsl:text>Galibi Carib</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cat'">
                  <xsl:text>Catalan or Valencian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ca'">
                  <xsl:text>Catalan or Valencian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cau'">
                  <xsl:text>Caucasian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ceb'">
                  <xsl:text>Cebuano</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cel'">
                  <xsl:text>Celtic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cha'">
                  <xsl:text>Chamorro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ch'">
                  <xsl:text>Chamorro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chb'">
                  <xsl:text>Chibcha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='che'">
                  <xsl:text>Chechen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ce'">
                  <xsl:text>Chechen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chg'">
                  <xsl:text>Chagatai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chi'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zho'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zh'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chk'">
                  <xsl:text>Chuukese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chm'">
                  <xsl:text>Mari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chn'">
                  <xsl:text>Chinook jargon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cho'">
                  <xsl:text>Choctaw</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chp'">
                  <xsl:text>Chipewyan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chr'">
                  <xsl:text>Cherokee</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chu'">
                  <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cu'">
                  <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chv'">
                  <xsl:text>Chuvash</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cv'">
                  <xsl:text>Chuvash</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chy'">
                  <xsl:text>Cheyenne</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cmc'">
                  <xsl:text>Chamic languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cop'">
                  <xsl:text>Coptic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cor'">
                  <xsl:text>Cornish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kw'">
                  <xsl:text>Cornish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cos'">
                  <xsl:text>Corsican</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='co'">
                  <xsl:text>Corsican</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpe'">
                  <xsl:text>Creoles and pidgins, English based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpf'">
                  <xsl:text>Creoles and pidgins, French-based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpp'">
                  <xsl:text>Creoles and pidgins, Portuguese-based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cre'">
                  <xsl:text>Cree</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cr'">
                  <xsl:text>Cree</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='crh'">
                  <xsl:text>Crimean Tatar or Crimean Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='crp'">
                  <xsl:text>Creoles and pidgins (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='csb'">
                  <xsl:text>Kashubian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cus'">
                  <xsl:text>Cushitic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cze'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ces'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cs'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dak'">
                  <xsl:text>Dakota</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dan'">
                  <xsl:text>Danish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='da'">
                  <xsl:text>Danish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dar'">
                  <xsl:text>Dargwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='day'">
                  <xsl:text>Land Dayak languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='del'">
                  <xsl:text>Delaware</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='den'">
                  <xsl:text>Slave (Athapascan)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dgr'">
                  <xsl:text>Dogrib</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='din'">
                  <xsl:text>Dinka</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='div'">
                  <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dv'">
                  <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='doi'">
                  <xsl:text>Dogri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dra'">
                  <xsl:text>Dravidian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dsb'">
                  <xsl:text>Lower Sorbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dua'">
                  <xsl:text>Duala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dum'">
                  <xsl:text>Dutch, Middle (ca.1050-1350)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dut'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nld'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nl'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dyu'">
                  <xsl:text>Dyula</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dzo'">
                  <xsl:text>Dzongkha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dz'">
                  <xsl:text>Dzongkha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='efi'">
                  <xsl:text>Efik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='egy'">
                  <xsl:text>Egyptian (Ancient)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eka'">
                  <xsl:text>Ekajuk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='elx'">
                  <xsl:text>Elamite</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eng'">
                  <xsl:text>English</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='en'">
                  <xsl:text>English</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='enm'">
                  <xsl:text>English, Middle (1100-1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='epo'">
                  <xsl:text>Esperanto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eo'">
                  <xsl:text>Esperanto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='est'">
                  <xsl:text>Estonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='et'">
                  <xsl:text>Estonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ewe'">
                  <xsl:text>Ewe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ee'">
                  <xsl:text>Ewe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ewo'">
                  <xsl:text>Ewondo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fan'">
                  <xsl:text>Fang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fao'">
                  <xsl:text>Faroese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fo'">
                  <xsl:text>Faroese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fat'">
                  <xsl:text>Fanti</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fij'">
                  <xsl:text>Fijian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fj'">
                  <xsl:text>Fijian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fil'">
                  <xsl:text>Filipino or Pilipino</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fin'">
                  <xsl:text>Finnish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fi'">
                  <xsl:text>Finnish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fiu'">
                  <xsl:text>Finno-Ugrian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fon'">
                  <xsl:text>Fon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fre'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fra'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fr'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frm'">
                  <xsl:text>French, Middle (ca.1400-1600)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fro'">
                  <xsl:text>French, Old (842-ca.1400)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frr'">
                  <xsl:text>Northern Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frs'">
                  <xsl:text>Eastern Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fry'">
                  <xsl:text>Western Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fy'">
                  <xsl:text>Western Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ful'">
                  <xsl:text>Fulah</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ff'">
                  <xsl:text>Fulah</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fur'">
                  <xsl:text>Friulian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gaa'">
                  <xsl:text>Ga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gay'">
                  <xsl:text>Gayo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gba'">
                  <xsl:text>Gbaya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gem'">
                  <xsl:text>Germanic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='geo'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kat'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ka'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ger'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='deu'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='de'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gez'">
                  <xsl:text>Geez</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gil'">
                  <xsl:text>Gilbertese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gla'">
                  <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gd'">
                  <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gle'">
                  <xsl:text>Irish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ga'">
                  <xsl:text>Irish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='glg'">
                  <xsl:text>Galician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gl'">
                  <xsl:text>Galician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='glv'">
                  <xsl:text>Manx</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gv'">
                  <xsl:text>Manx</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gmh'">
                  <xsl:text>German, Middle High (ca.1050-1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='goh'">
                  <xsl:text>German, Old High (ca.750-1050)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gon'">
                  <xsl:text>Gondi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gor'">
                  <xsl:text>Gorontalo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='got'">
                  <xsl:text>Gothic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grb'">
                  <xsl:text>Grebo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grc'">
                  <xsl:text>Greek, Ancient (to 1453)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gre'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ell'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='el'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grn'">
                  <xsl:text>Guarani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gn'">
                  <xsl:text>Guarani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gsw'">
                  <xsl:text>Swiss German or Alemannic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='guj'">
                  <xsl:text>Gujarati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gu'">
                  <xsl:text>Gujarati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gwi'">
                  <xsl:text>Gwich'in</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hai'">
                  <xsl:text>Haida</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hat'">
                  <xsl:text>Haitian or Haitian Creole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ht'">
                  <xsl:text>Haitian or Haitian Creole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hau'">
                  <xsl:text>Hausa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ha'">
                  <xsl:text>Hausa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='haw'">
                  <xsl:text>Hawaiian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='heb'">
                  <xsl:text>Hebrew</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='he'">
                  <xsl:text>Hebrew</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='her'">
                  <xsl:text>Herero</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hz'">
                  <xsl:text>Herero</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hil'">
                  <xsl:text>Hiligaynon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='him'">
                  <xsl:text>Himachali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hin'">
                  <xsl:text>Hindi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hi'">
                  <xsl:text>Hindi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hit'">
                  <xsl:text>Hittite</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hmn'">
                  <xsl:text>Hmong</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hmo'">
                  <xsl:text>Hiri Motu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ho'">
                  <xsl:text>Hiri Motu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hsb'">
                  <xsl:text>Upper Sorbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hun'">
                  <xsl:text>Hungarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hu'">
                  <xsl:text>Hungarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hup'">
                  <xsl:text>Hupa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iba'">
                  <xsl:text>Iban</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ibo'">
                  <xsl:text>Igbo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ig'">
                  <xsl:text>Igbo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ice'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='isl'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='is'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ido'">
                  <xsl:text>Ido</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='io'">
                  <xsl:text>Ido</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iii'">
                  <xsl:text>Sichuan Yi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ii'">
                  <xsl:text>Sichuan Yi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ijo'">
                  <xsl:text>Ijo languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iku'">
                  <xsl:text>Inuktitut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iu'">
                  <xsl:text>Inuktitut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ile'">
                  <xsl:text>Interlingue</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ie'">
                  <xsl:text>Interlingue</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ilo'">
                  <xsl:text>Iloko</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ina'">
                  <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ia'">
                  <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='inc'">
                  <xsl:text>Indic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ind'">
                  <xsl:text>Indonesian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='id'">
                  <xsl:text>Indonesian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ine'">
                  <xsl:text>Indo-European (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='inh'">
                  <xsl:text>Ingush</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ipk'">
                  <xsl:text>Inupiaq</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ik'">
                  <xsl:text>Inupiaq</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ira'">
                  <xsl:text>Iranian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iro'">
                  <xsl:text>Iroquoian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ita'">
                  <xsl:text>Italian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='it'">
                  <xsl:text>Italian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jav'">
                  <xsl:text>Javanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jv'">
                  <xsl:text>Javanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jbo'">
                  <xsl:text>Lojban</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jpn'">
                  <xsl:text>Japanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ja'">
                  <xsl:text>Japanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jpr'">
                  <xsl:text>Judeo-Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jrb'">
                  <xsl:text>Judeo-Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaa'">
                  <xsl:text>Kara-Kalpak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kab'">
                  <xsl:text>Kabyle</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kac'">
                  <xsl:text>Kachin or Jingpho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kal'">
                  <xsl:text>Kalaallisut or Greenlandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kl'">
                  <xsl:text>Kalaallisut or Greenlandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kam'">
                  <xsl:text>Kamba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kan'">
                  <xsl:text>Kannada</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kn'">
                  <xsl:text>Kannada</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kar'">
                  <xsl:text>Karen languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kas'">
                  <xsl:text>Kashmiri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ks'">
                  <xsl:text>Kashmiri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kau'">
                  <xsl:text>Kanuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kr'">
                  <xsl:text>Kanuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaw'">
                  <xsl:text>Kawi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaz'">
                  <xsl:text>Kazakh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kk'">
                  <xsl:text>Kazakh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kbd'">
                  <xsl:text>Kabardian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kha'">
                  <xsl:text>Khasi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='khi'">
                  <xsl:text>Khoisan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='khm'">
                  <xsl:text>Central Khmer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='km'">
                  <xsl:text>Central Khmer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kho'">
                  <xsl:text>Khotanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kik'">
                  <xsl:text>Kikuyu or Gikuyu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ki'">
                  <xsl:text>Kikuyu or Gikuyu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kin'">
                  <xsl:text>Kinyarwanda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rw'">
                  <xsl:text>Kinyarwanda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kir'">
                  <xsl:text>Kirghiz or Kyrgyz</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ky'">
                  <xsl:text>Kirghiz or Kyrgyz</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kmb'">
                  <xsl:text>Kimbundu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kok'">
                  <xsl:text>Konkani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kom'">
                  <xsl:text>Komi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kv'">
                  <xsl:text>Komi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kon'">
                  <xsl:text>Kongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kg'">
                  <xsl:text>Kongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kor'">
                  <xsl:text>Korean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ko'">
                  <xsl:text>Korean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kos'">
                  <xsl:text>Kosraean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kpe'">
                  <xsl:text>Kpelle</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='krc'">
                  <xsl:text>Karachay-Balkar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='krl'">
                  <xsl:text>Karelian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kro'">
                  <xsl:text>Kru languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kru'">
                  <xsl:text>Kurukh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kua'">
                  <xsl:text>Kuanyama or Kwanyama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kj'">
                  <xsl:text>Kuanyama or Kwanyama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kum'">
                  <xsl:text>Kumyk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kur'">
                  <xsl:text>Kurdish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ku'">
                  <xsl:text>Kurdish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kut'">
                  <xsl:text>Kutenai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lad'">
                  <xsl:text>Ladino</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lah'">
                  <xsl:text>Lahnda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lam'">
                  <xsl:text>Lamba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lao'">
                  <xsl:text>Lao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lo'">
                  <xsl:text>Lao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lat'">
                  <xsl:text>Latin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='la'">
                  <xsl:text>Latin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lav'">
                  <xsl:text>Latvian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lv'">
                  <xsl:text>Latvian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lez'">
                  <xsl:text>Lezghian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lim'">
                  <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='li'">
                  <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lin'">
                  <xsl:text>Lingala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ln'">
                  <xsl:text>Lingala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lit'">
                  <xsl:text>Lithuanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lt'">
                  <xsl:text>Lithuanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lol'">
                  <xsl:text>Mongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='loz'">
                  <xsl:text>Lozi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ltz'">
                  <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lb'">
                  <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lua'">
                  <xsl:text>Luba-Lulua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lub'">
                  <xsl:text>Luba-Katanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lu'">
                  <xsl:text>Luba-Katanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lug'">
                  <xsl:text>Ganda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lg'">
                  <xsl:text>Ganda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lui'">
                  <xsl:text>Luiseno</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lun'">
                  <xsl:text>Lunda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='luo'">
                  <xsl:text>Luo (Kenya and Tanzania)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lus'">
                  <xsl:text>Lushai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mac'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mkd'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mk'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mad'">
                  <xsl:text>Madurese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mag'">
                  <xsl:text>Magahi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mah'">
                  <xsl:text>Marshallese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mh'">
                  <xsl:text>Marshallese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mai'">
                  <xsl:text>Maithili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mak'">
                  <xsl:text>Makasar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mal'">
                  <xsl:text>Malayalam</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ml'">
                  <xsl:text>Malayalam</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='man'">
                  <xsl:text>Mandingo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mao'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mri'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mi'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='map'">
                  <xsl:text>Austronesian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mar'">
                  <xsl:text>Marathi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mr'">
                  <xsl:text>Marathi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mas'">
                  <xsl:text>Masai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='may'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='msa'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ms'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mdf'">
                  <xsl:text>Moksha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mdr'">
                  <xsl:text>Mandar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='men'">
                  <xsl:text>Mende</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mga'">
                  <xsl:text>Irish, Middle (900-1200)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mic'">
                  <xsl:text>Mi'kmaq or Micmac</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='min'">
                  <xsl:text>Minangkabau</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mis'">
                  <xsl:text>Miscellaneous languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mkh'">
                  <xsl:text>Mon-Khmer (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mlg'">
                  <xsl:text>Malagasy</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mg'">
                  <xsl:text>Malagasy</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mlt'">
                  <xsl:text>Maltese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mt'">
                  <xsl:text>Maltese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mnc'">
                  <xsl:text>Manchu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mni'">
                  <xsl:text>Manipuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mno'">
                  <xsl:text>Manobo languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='moh'">
                  <xsl:text>Mohawk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mol'">
                  <xsl:text>Moldavian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mo'">
                  <xsl:text>Moldavian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mon'">
                  <xsl:text>Mongolian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mn'">
                  <xsl:text>Mongolian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mos'">
                  <xsl:text>Mossi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mun'">
                  <xsl:text>Munda languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mus'">
                  <xsl:text>Creek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mwl'">
                  <xsl:text>Mirandese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mwr'">
                  <xsl:text>Marwari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='myn'">
                  <xsl:text>Mayan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='myv'">
                  <xsl:text>Erzya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nah'">
                  <xsl:text>Nahuatl languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nai'">
                  <xsl:text>North American Indian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nap'">
                  <xsl:text>Neapolitan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nau'">
                  <xsl:text>Nauru</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='na'">
                  <xsl:text>Nauru</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nav'">
                  <xsl:text>Navajo or Navaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nv'">
                  <xsl:text>Navajo or Navaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nbl'">
                  <xsl:text>Ndebele, South or South Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nr'">
                  <xsl:text>Ndebele, South or South Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nde'">
                  <xsl:text>Ndebele, North or North Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nd'">
                  <xsl:text>Ndebele, North or North Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ndo'">
                  <xsl:text>Ndonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ng'">
                  <xsl:text>Ndonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nds'">
                  <xsl:text>Low German or Low Saxon or German, Low or Saxon, Low</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nep'">
                  <xsl:text>Nepali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ne'">
                  <xsl:text>Nepali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='new'">
                  <xsl:text>Nepal Bhasa or Newari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nia'">
                  <xsl:text>Nias</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nic'">
                  <xsl:text>Niger-Kordofanian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='niu'">
                  <xsl:text>Niuean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nno'">
                  <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nn'">
                  <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nob'">
                  <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nb'">
                  <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nog'">
                  <xsl:text>Nogai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='non'">
                  <xsl:text>Norse, Old</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nor'">
                  <xsl:text>Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='no'">
                  <xsl:text>Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nso'">
                  <xsl:text>Pedi or Sepedi or Northern Sotho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nub'">
                  <xsl:text>Nubian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nwc'">
                  <xsl:text>Classical Newari or Old Newari or Classical Nepal Bhasa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nya'">
                  <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ny'">
                  <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nym'">
                  <xsl:text>Nyamwezi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nyn'">
                  <xsl:text>Nyankole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nyo'">
                  <xsl:text>Nyoro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nzi'">
                  <xsl:text>Nzima</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oci'">
                  <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oc'">
                  <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oji'">
                  <xsl:text>Ojibwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oj'">
                  <xsl:text>Ojibwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ori'">
                  <xsl:text>Oriya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='or'">
                  <xsl:text>Oriya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='orm'">
                  <xsl:text>Oromo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='om'">
                  <xsl:text>Oromo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='osa'">
                  <xsl:text>Osage</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oss'">
                  <xsl:text>Ossetian or Ossetic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='os'">
                  <xsl:text>Ossetian or Ossetic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ota'">
                  <xsl:text>Turkish, Ottoman (1500-1928)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oto'">
                  <xsl:text>Otomian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='paa'">
                  <xsl:text>Papuan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pag'">
                  <xsl:text>Pangasinan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pal'">
                  <xsl:text>Pahlavi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pam'">
                  <xsl:text>Pampanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pan'">
                  <xsl:text>Panjabi or Punjabi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pa'">
                  <xsl:text>Panjabi or Punjabi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pap'">
                  <xsl:text>Papiamento</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pau'">
                  <xsl:text>Palauan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='peo'">
                  <xsl:text>Persian, Old (ca.600-400 B.C.)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='per'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fas'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fa'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='phi'">
                  <xsl:text>Philippine (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='phn'">
                  <xsl:text>Phoenician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pli'">
                  <xsl:text>Pali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pi'">
                  <xsl:text>Pali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pol'">
                  <xsl:text>Polish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pl'">
                  <xsl:text>Polish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pon'">
                  <xsl:text>Pohnpeian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='por'">
                  <xsl:text>Portuguese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pt'">
                  <xsl:text>Portuguese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pra'">
                  <xsl:text>Prakrit languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pro'">
                  <xsl:text>Proven√É¬ßal, Old (to 1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pus'">
                  <xsl:text>Pushto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ps'">
                  <xsl:text>Pushto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='que'">
                  <xsl:text>Quechua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='qu'">
                  <xsl:text>Quechua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='raj'">
                  <xsl:text>Rajasthani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rap'">
                  <xsl:text>Rapanui</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rar'">
                  <xsl:text>Rarotongan or Cook Islands Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='roa'">
                  <xsl:text>Romance (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='roh'">
                  <xsl:text>Romansh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rm'">
                  <xsl:text>Romansh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rom'">
                  <xsl:text>Romany</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rum'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ron'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ro'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='run'">
                  <xsl:text>Rundi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rn'">
                  <xsl:text>Rundi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rup'">
                  <xsl:text>Aromanian or Arumanian or Macedo-Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rus'">
                  <xsl:text>Russian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ru'">
                  <xsl:text>Russian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sad'">
                  <xsl:text>Sandawe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sag'">
                  <xsl:text>Sango</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sg'">
                  <xsl:text>Sango</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sah'">
                  <xsl:text>Yakut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sai'">
                  <xsl:text>South American Indian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sal'">
                  <xsl:text>Salishan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sam'">
                  <xsl:text>Samaritan Aramaic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='san'">
                  <xsl:text>Sanskrit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sa'">
                  <xsl:text>Sanskrit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sas'">
                  <xsl:text>Sasak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sat'">
                  <xsl:text>Santali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scc'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srp'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sr'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scn'">
                  <xsl:text>Sicilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sco'">
                  <xsl:text>Scots</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scr'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hrv'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hr'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sel'">
                  <xsl:text>Selkup</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sem'">
                  <xsl:text>Semitic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sga'">
                  <xsl:text>Irish, Old (to 900)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sgn'">
                  <xsl:text>Sign Languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='shn'">
                  <xsl:text>Shan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sid'">
                  <xsl:text>Sidamo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sin'">
                  <xsl:text>Sinhala or Sinhalese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='si'">
                  <xsl:text>Sinhala or Sinhalese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sio'">
                  <xsl:text>Siouan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sit'">
                  <xsl:text>Sino-Tibetan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sla'">
                  <xsl:text>Slavic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slo'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slk'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sk'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slv'">
                  <xsl:text>Slovenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sl'">
                  <xsl:text>Slovenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sma'">
                  <xsl:text>Southern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sme'">
                  <xsl:text>Northern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='se'">
                  <xsl:text>Northern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smi'">
                  <xsl:text>Sami languages (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smj'">
                  <xsl:text>Lule Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smn'">
                  <xsl:text>Inari Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smo'">
                  <xsl:text>Samoan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sm'">
                  <xsl:text>Samoan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sms'">
                  <xsl:text>Skolt Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sna'">
                  <xsl:text>Shona</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sn'">
                  <xsl:text>Shona</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='snd'">
                  <xsl:text>Sindhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sd'">
                  <xsl:text>Sindhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='snk'">
                  <xsl:text>Soninke</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sog'">
                  <xsl:text>Sogdian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='som'">
                  <xsl:text>Somali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='so'">
                  <xsl:text>Somali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='son'">
                  <xsl:text>Songhai languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sot'">
                  <xsl:text>Sotho, Southern</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='st'">
                  <xsl:text>Sotho, Southern</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='spa'">
                  <xsl:text>Spanish or Castilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='es'">
                  <xsl:text>Spanish or Castilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srd'">
                  <xsl:text>Sardinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sc'">
                  <xsl:text>Sardinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srn'">
                  <xsl:text>Sranan Tongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srr'">
                  <xsl:text>Serer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ssa'">
                  <xsl:text>Nilo-Saharan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ssw'">
                  <xsl:text>Swati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ss'">
                  <xsl:text>Swati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='suk'">
                  <xsl:text>Sukuma</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sun'">
                  <xsl:text>Sundanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='su'">
                  <xsl:text>Sundanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sus'">
                  <xsl:text>Susu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sux'">
                  <xsl:text>Sumerian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='swa'">
                  <xsl:text>Swahili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sw'">
                  <xsl:text>Swahili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='swe'">
                  <xsl:text>Swedish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sv'">
                  <xsl:text>Swedish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='syr'">
                  <xsl:text>Syriac</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tah'">
                  <xsl:text>Tahitian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ty'">
                  <xsl:text>Tahitian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tai'">
                  <xsl:text>Tai (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tam'">
                  <xsl:text>Tamil</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ta'">
                  <xsl:text>Tamil</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tat'">
                  <xsl:text>Tatar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tt'">
                  <xsl:text>Tatar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tel'">
                  <xsl:text>Telugu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='te'">
                  <xsl:text>Telugu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tem'">
                  <xsl:text>Timne</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ter'">
                  <xsl:text>Tereno</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tet'">
                  <xsl:text>Tetum</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tgk'">
                  <xsl:text>Tajik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tg'">
                  <xsl:text>Tajik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tgl'">
                  <xsl:text>Tagalog</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tl'">
                  <xsl:text>Tagalog</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tha'">
                  <xsl:text>Thai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='th'">
                  <xsl:text>Thai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tib'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bod'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bo'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tig'">
                  <xsl:text>Tigre</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tir'">
                  <xsl:text>Tigrinya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ti'">
                  <xsl:text>Tigrinya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tiv'">
                  <xsl:text>Tiv</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tkl'">
                  <xsl:text>Tokelau</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tlh'">
                  <xsl:text>Klingon or tlhIngan-Hol</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tli'">
                  <xsl:text>Tlingit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tmh'">
                  <xsl:text>Tamashek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tog'">
                  <xsl:text>Tonga (Nyasa)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ton'">
                  <xsl:text>Tonga (Tonga Islands)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='to'">
                  <xsl:text>Tonga (Tonga Islands)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tpi'">
                  <xsl:text>Tok Pisin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tsi'">
                  <xsl:text>Tsimshian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tsn'">
                  <xsl:text>Tswana</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tn'">
                  <xsl:text>Tswana</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tso'">
                  <xsl:text>Tsonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ts'">
                  <xsl:text>Tsonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tuk'">
                  <xsl:text>Turkmen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tk'">
                  <xsl:text>Turkmen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tum'">
                  <xsl:text>Tumbuka</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tup'">
                  <xsl:text>Tupi languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tur'">
                  <xsl:text>Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tr'">
                  <xsl:text>Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tut'">
                  <xsl:text>Altaic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tvl'">
                  <xsl:text>Tuvalu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='twi'">
                  <xsl:text>Twi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tw'">
                  <xsl:text>Twi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tyv'">
                  <xsl:text>Tuvinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='udm'">
                  <xsl:text>Udmurt</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uga'">
                  <xsl:text>Ugaritic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uig'">
                  <xsl:text>Uighur or Uyghur</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ug'">
                  <xsl:text>Uighur or Uyghur</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ukr'">
                  <xsl:text>Ukrainian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uk'">
                  <xsl:text>Ukrainian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='umb'">
                  <xsl:text>Umbundu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='und'">
                  <xsl:text>Undetermined</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='urd'">
                  <xsl:text>Urdu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ur'">
                  <xsl:text>Urdu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uzb'">
                  <xsl:text>Uzbek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uz'">
                  <xsl:text>Uzbek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vai'">
                  <xsl:text>Vai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ven'">
                  <xsl:text>Venda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ve'">
                  <xsl:text>Venda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vie'">
                  <xsl:text>Vietnamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vi'">
                  <xsl:text>Vietnamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vol'">
                  <xsl:text>Volap√É¬ºk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vo'">
                  <xsl:text>Volap√É¬ºk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vot'">
                  <xsl:text>Votic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wak'">
                  <xsl:text>Wakashan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wal'">
                  <xsl:text>Walamo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='war'">
                  <xsl:text>Waray</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='was'">
                  <xsl:text>Washo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wel'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cym'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cy'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wen'">
                  <xsl:text>Sorbian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wln'">
                  <xsl:text>Walloon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wa'">
                  <xsl:text>Walloon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wol'">
                  <xsl:text>Wolof</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wo'">
                  <xsl:text>Wolof</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xal'">
                  <xsl:text>Kalmyk or Oirat</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xho'">
                  <xsl:text>Xhosa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xh'">
                  <xsl:text>Xhosa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yao'">
                  <xsl:text>Yao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yap'">
                  <xsl:text>Yapese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yid'">
                  <xsl:text>Yiddish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yi'">
                  <xsl:text>Yiddish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yor'">
                  <xsl:text>Yoruba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yo'">
                  <xsl:text>Yoruba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ypk'">
                  <xsl:text>Yupik languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zap'">
                  <xsl:text>Zapotec</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zen'">
                  <xsl:text>Zenaga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zha'">
                  <xsl:text>Zhuang or Chuang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='za'">
                  <xsl:text>Zhuang or Chuang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='znd'">
                  <xsl:text>Zande languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zul'">
                  <xsl:text>Zulu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zu'">
                  <xsl:text>Zulu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zun'">
                  <xsl:text>Zuni</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zxx'">
                  <xsl:text>No linguistic content</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nqo'">
                  <xsl:text>N'Ko</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zza'">
                  <xsl:text>Zaza or Dimili or Dimli or Kirdki or Kirmanjki or Zazaki</xsl:text>
               </xsl:when>
            </xsl:choose>
         </dd>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="ead:eadheader/ead:profiledesc/ead:langusage">
      <xsl:for-each select="ead:language">
         <dd class="normal">
            <xsl:choose>
               <xsl:when test="@langcode='aar'">
                  <xsl:text>Afar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aa'">
                  <xsl:text>Afar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='abk'">
                  <xsl:text>Abkhazian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ab'">
                  <xsl:text>Abkhazian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ace'">
                  <xsl:text>Achinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ach'">
                  <xsl:text>Acoli</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ada'">
                  <xsl:text>Adangme</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ady'">
                  <xsl:text>Adyghe or Adygei</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afa'">
                  <xsl:text>Afro-Asiatic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afh'">
                  <xsl:text>Afrihili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='afr'">
                  <xsl:text>Afrikaans</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='af'">
                  <xsl:text>Afrikaans</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ain'">
                  <xsl:text>Ainu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aka'">
                  <xsl:text>Akan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ak'">
                  <xsl:text>Akan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='akk'">
                  <xsl:text>Akkadian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alb'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sqi'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sq'">
                  <xsl:text>Albanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ale'">
                  <xsl:text>Aleut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alg'">
                  <xsl:text>Algonquian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='alt'">
                  <xsl:text>Southern Altai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='amh'">
                  <xsl:text>Amharic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='am'">
                  <xsl:text>Amharic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ang'">
                  <xsl:text>English, Old (ca.450-1100)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='anp'">
                  <xsl:text>Angika</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='apa'">
                  <xsl:text>Apache languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ara'">
                  <xsl:text>Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ar'">
                  <xsl:text>Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arc'">
                  <xsl:text>Aramaic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arg'">
                  <xsl:text>Aragonese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='an'">
                  <xsl:text>Aragonese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arm'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hye'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hy'">
                  <xsl:text>Armenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arn'">
                  <xsl:text>Mapudungun or Mapuche</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arp'">
                  <xsl:text>Arapaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='art'">
                  <xsl:text>Artificial (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='arw'">
                  <xsl:text>Arawak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='asm'">
                  <xsl:text>Assamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='as'">
                  <xsl:text>Assamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ast'">
                  <xsl:text>Asturian or Bable</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ath'">
                  <xsl:text>Athapascan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aus'">
                  <xsl:text>Australian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ava'">
                  <xsl:text>Avaric</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='av'">
                  <xsl:text>Avaric</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ave'">
                  <xsl:text>Avestan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ae'">
                  <xsl:text>Avestan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='awa'">
                  <xsl:text>Awadhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aym'">
                  <xsl:text>Aymara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ay'">
                  <xsl:text>Aymara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='aze'">
                  <xsl:text>Azerbaijani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='az'">
                  <xsl:text>Azerbaijani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bad'">
                  <xsl:text>Banda languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bai'">
                  <xsl:text>Bamileke languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bak'">
                  <xsl:text>Bashkir</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ba'">
                  <xsl:text>Bashkir</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bal'">
                  <xsl:text>Baluchi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bam'">
                  <xsl:text>Bambara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bm'">
                  <xsl:text>Bambara</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ban'">
                  <xsl:text>Balinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='baq'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eus'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eu'">
                  <xsl:text>Basque</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bas'">
                  <xsl:text>Basa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bat'">
                  <xsl:text>Baltic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bej'">
                  <xsl:text>Beja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bel'">
                  <xsl:text>Belarusian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='be'">
                  <xsl:text>Belarusian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bem'">
                  <xsl:text>Bemba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ben'">
                  <xsl:text>Bengali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bn'">
                  <xsl:text>Bengali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ber'">
                  <xsl:text>Berber (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bho'">
                  <xsl:text>Bhojpuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bih'">
                  <xsl:text>Bihari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bh'">
                  <xsl:text>Bihari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bik'">
                  <xsl:text>Bikol</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bin'">
                  <xsl:text>Bini or Edo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bis'">
                  <xsl:text>Bislama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bi'">
                  <xsl:text>Bislama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bla'">
                  <xsl:text>Siksika</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bnt'">
                  <xsl:text>Bantu (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bos'">
                  <xsl:text>Bosnian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bs'">
                  <xsl:text>Bosnian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bra'">
                  <xsl:text>Braj</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bre'">
                  <xsl:text>Breton</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='br'">
                  <xsl:text>Breton</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='btk'">
                  <xsl:text>Batak languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bua'">
                  <xsl:text>Buriat</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bug'">
                  <xsl:text>Buginese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bul'">
                  <xsl:text>Bulgarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bg'">
                  <xsl:text>Bulgarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bur'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mya'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='my'">
                  <xsl:text>Burmese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='byn'">
                  <xsl:text>Blin or Bilin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cad'">
                  <xsl:text>Caddo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cai'">
                  <xsl:text>Central American Indian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='car'">
                  <xsl:text>Galibi Carib</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cat'">
                  <xsl:text>Catalan or Valencian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ca'">
                  <xsl:text>Catalan or Valencian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cau'">
                  <xsl:text>Caucasian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ceb'">
                  <xsl:text>Cebuano</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cel'">
                  <xsl:text>Celtic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cha'">
                  <xsl:text>Chamorro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ch'">
                  <xsl:text>Chamorro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chb'">
                  <xsl:text>Chibcha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='che'">
                  <xsl:text>Chechen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ce'">
                  <xsl:text>Chechen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chg'">
                  <xsl:text>Chagatai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chi'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zho'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zh'">
                  <xsl:text>Chinese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chk'">
                  <xsl:text>Chuukese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chm'">
                  <xsl:text>Mari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chn'">
                  <xsl:text>Chinook jargon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cho'">
                  <xsl:text>Choctaw</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chp'">
                  <xsl:text>Chipewyan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chr'">
                  <xsl:text>Cherokee</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chu'">
                  <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cu'">
                  <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chv'">
                  <xsl:text>Chuvash</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cv'">
                  <xsl:text>Chuvash</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='chy'">
                  <xsl:text>Cheyenne</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cmc'">
                  <xsl:text>Chamic languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cop'">
                  <xsl:text>Coptic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cor'">
                  <xsl:text>Cornish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kw'">
                  <xsl:text>Cornish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cos'">
                  <xsl:text>Corsican</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='co'">
                  <xsl:text>Corsican</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpe'">
                  <xsl:text>Creoles and pidgins, English based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpf'">
                  <xsl:text>Creoles and pidgins, French-based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cpp'">
                  <xsl:text>Creoles and pidgins, Portuguese-based (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cre'">
                  <xsl:text>Cree</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cr'">
                  <xsl:text>Cree</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='crh'">
                  <xsl:text>Crimean Tatar or Crimean Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='crp'">
                  <xsl:text>Creoles and pidgins (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='csb'">
                  <xsl:text>Kashubian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cus'">
                  <xsl:text>Cushitic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cze'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ces'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cs'">
                  <xsl:text>Czech</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dak'">
                  <xsl:text>Dakota</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dan'">
                  <xsl:text>Danish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='da'">
                  <xsl:text>Danish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dar'">
                  <xsl:text>Dargwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='day'">
                  <xsl:text>Land Dayak languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='del'">
                  <xsl:text>Delaware</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='den'">
                  <xsl:text>Slave (Athapascan)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dgr'">
                  <xsl:text>Dogrib</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='din'">
                  <xsl:text>Dinka</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='div'">
                  <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dv'">
                  <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='doi'">
                  <xsl:text>Dogri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dra'">
                  <xsl:text>Dravidian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dsb'">
                  <xsl:text>Lower Sorbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dua'">
                  <xsl:text>Duala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dum'">
                  <xsl:text>Dutch, Middle (ca.1050-1350)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dut'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nld'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nl'">
                  <xsl:text>Dutch or Flemish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dyu'">
                  <xsl:text>Dyula</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dzo'">
                  <xsl:text>Dzongkha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='dz'">
                  <xsl:text>Dzongkha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='efi'">
                  <xsl:text>Efik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='egy'">
                  <xsl:text>Egyptian (Ancient)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eka'">
                  <xsl:text>Ekajuk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='elx'">
                  <xsl:text>Elamite</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eng'">
                  <xsl:text>English</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='en'">
                  <xsl:text>English</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='enm'">
                  <xsl:text>English, Middle (1100-1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='epo'">
                  <xsl:text>Esperanto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='eo'">
                  <xsl:text>Esperanto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='est'">
                  <xsl:text>Estonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='et'">
                  <xsl:text>Estonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ewe'">
                  <xsl:text>Ewe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ee'">
                  <xsl:text>Ewe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ewo'">
                  <xsl:text>Ewondo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fan'">
                  <xsl:text>Fang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fao'">
                  <xsl:text>Faroese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fo'">
                  <xsl:text>Faroese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fat'">
                  <xsl:text>Fanti</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fij'">
                  <xsl:text>Fijian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fj'">
                  <xsl:text>Fijian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fil'">
                  <xsl:text>Filipino or Pilipino</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fin'">
                  <xsl:text>Finnish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fi'">
                  <xsl:text>Finnish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fiu'">
                  <xsl:text>Finno-Ugrian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fon'">
                  <xsl:text>Fon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fre'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fra'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fr'">
                  <xsl:text>French</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frm'">
                  <xsl:text>French, Middle (ca.1400-1600)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fro'">
                  <xsl:text>French, Old (842-ca.1400)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frr'">
                  <xsl:text>Northern Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='frs'">
                  <xsl:text>Eastern Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fry'">
                  <xsl:text>Western Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fy'">
                  <xsl:text>Western Frisian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ful'">
                  <xsl:text>Fulah</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ff'">
                  <xsl:text>Fulah</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fur'">
                  <xsl:text>Friulian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gaa'">
                  <xsl:text>Ga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gay'">
                  <xsl:text>Gayo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gba'">
                  <xsl:text>Gbaya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gem'">
                  <xsl:text>Germanic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='geo'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kat'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ka'">
                  <xsl:text>Georgian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ger'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='deu'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='de'">
                  <xsl:text>German</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gez'">
                  <xsl:text>Geez</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gil'">
                  <xsl:text>Gilbertese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gla'">
                  <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gd'">
                  <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gle'">
                  <xsl:text>Irish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ga'">
                  <xsl:text>Irish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='glg'">
                  <xsl:text>Galician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gl'">
                  <xsl:text>Galician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='glv'">
                  <xsl:text>Manx</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gv'">
                  <xsl:text>Manx</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gmh'">
                  <xsl:text>German, Middle High (ca.1050-1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='goh'">
                  <xsl:text>German, Old High (ca.750-1050)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gon'">
                  <xsl:text>Gondi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gor'">
                  <xsl:text>Gorontalo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='got'">
                  <xsl:text>Gothic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grb'">
                  <xsl:text>Grebo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grc'">
                  <xsl:text>Greek, Ancient (to 1453)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gre'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ell'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='el'">
                  <xsl:text>Greek, Modern (1453-)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='grn'">
                  <xsl:text>Guarani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gn'">
                  <xsl:text>Guarani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gsw'">
                  <xsl:text>Swiss German or Alemannic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='guj'">
                  <xsl:text>Gujarati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gu'">
                  <xsl:text>Gujarati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='gwi'">
                  <xsl:text>Gwich'in</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hai'">
                  <xsl:text>Haida</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hat'">
                  <xsl:text>Haitian or Haitian Creole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ht'">
                  <xsl:text>Haitian or Haitian Creole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hau'">
                  <xsl:text>Hausa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ha'">
                  <xsl:text>Hausa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='haw'">
                  <xsl:text>Hawaiian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='heb'">
                  <xsl:text>Hebrew</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='he'">
                  <xsl:text>Hebrew</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='her'">
                  <xsl:text>Herero</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hz'">
                  <xsl:text>Herero</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hil'">
                  <xsl:text>Hiligaynon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='him'">
                  <xsl:text>Himachali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hin'">
                  <xsl:text>Hindi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hi'">
                  <xsl:text>Hindi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hit'">
                  <xsl:text>Hittite</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hmn'">
                  <xsl:text>Hmong</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hmo'">
                  <xsl:text>Hiri Motu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ho'">
                  <xsl:text>Hiri Motu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hsb'">
                  <xsl:text>Upper Sorbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hun'">
                  <xsl:text>Hungarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hu'">
                  <xsl:text>Hungarian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hup'">
                  <xsl:text>Hupa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iba'">
                  <xsl:text>Iban</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ibo'">
                  <xsl:text>Igbo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ig'">
                  <xsl:text>Igbo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ice'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='isl'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='is'">
                  <xsl:text>Icelandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ido'">
                  <xsl:text>Ido</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='io'">
                  <xsl:text>Ido</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iii'">
                  <xsl:text>Sichuan Yi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ii'">
                  <xsl:text>Sichuan Yi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ijo'">
                  <xsl:text>Ijo languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iku'">
                  <xsl:text>Inuktitut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iu'">
                  <xsl:text>Inuktitut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ile'">
                  <xsl:text>Interlingue</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ie'">
                  <xsl:text>Interlingue</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ilo'">
                  <xsl:text>Iloko</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ina'">
                  <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ia'">
                  <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='inc'">
                  <xsl:text>Indic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ind'">
                  <xsl:text>Indonesian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='id'">
                  <xsl:text>Indonesian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ine'">
                  <xsl:text>Indo-European (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='inh'">
                  <xsl:text>Ingush</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ipk'">
                  <xsl:text>Inupiaq</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ik'">
                  <xsl:text>Inupiaq</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ira'">
                  <xsl:text>Iranian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='iro'">
                  <xsl:text>Iroquoian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ita'">
                  <xsl:text>Italian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='it'">
                  <xsl:text>Italian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jav'">
                  <xsl:text>Javanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jv'">
                  <xsl:text>Javanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jbo'">
                  <xsl:text>Lojban</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jpn'">
                  <xsl:text>Japanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ja'">
                  <xsl:text>Japanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jpr'">
                  <xsl:text>Judeo-Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='jrb'">
                  <xsl:text>Judeo-Arabic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaa'">
                  <xsl:text>Kara-Kalpak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kab'">
                  <xsl:text>Kabyle</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kac'">
                  <xsl:text>Kachin or Jingpho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kal'">
                  <xsl:text>Kalaallisut or Greenlandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kl'">
                  <xsl:text>Kalaallisut or Greenlandic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kam'">
                  <xsl:text>Kamba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kan'">
                  <xsl:text>Kannada</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kn'">
                  <xsl:text>Kannada</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kar'">
                  <xsl:text>Karen languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kas'">
                  <xsl:text>Kashmiri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ks'">
                  <xsl:text>Kashmiri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kau'">
                  <xsl:text>Kanuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kr'">
                  <xsl:text>Kanuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaw'">
                  <xsl:text>Kawi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kaz'">
                  <xsl:text>Kazakh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kk'">
                  <xsl:text>Kazakh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kbd'">
                  <xsl:text>Kabardian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kha'">
                  <xsl:text>Khasi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='khi'">
                  <xsl:text>Khoisan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='khm'">
                  <xsl:text>Central Khmer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='km'">
                  <xsl:text>Central Khmer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kho'">
                  <xsl:text>Khotanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kik'">
                  <xsl:text>Kikuyu or Gikuyu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ki'">
                  <xsl:text>Kikuyu or Gikuyu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kin'">
                  <xsl:text>Kinyarwanda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rw'">
                  <xsl:text>Kinyarwanda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kir'">
                  <xsl:text>Kirghiz or Kyrgyz</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ky'">
                  <xsl:text>Kirghiz or Kyrgyz</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kmb'">
                  <xsl:text>Kimbundu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kok'">
                  <xsl:text>Konkani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kom'">
                  <xsl:text>Komi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kv'">
                  <xsl:text>Komi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kon'">
                  <xsl:text>Kongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kg'">
                  <xsl:text>Kongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kor'">
                  <xsl:text>Korean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ko'">
                  <xsl:text>Korean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kos'">
                  <xsl:text>Kosraean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kpe'">
                  <xsl:text>Kpelle</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='krc'">
                  <xsl:text>Karachay-Balkar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='krl'">
                  <xsl:text>Karelian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kro'">
                  <xsl:text>Kru languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kru'">
                  <xsl:text>Kurukh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kua'">
                  <xsl:text>Kuanyama or Kwanyama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kj'">
                  <xsl:text>Kuanyama or Kwanyama</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kum'">
                  <xsl:text>Kumyk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kur'">
                  <xsl:text>Kurdish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ku'">
                  <xsl:text>Kurdish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='kut'">
                  <xsl:text>Kutenai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lad'">
                  <xsl:text>Ladino</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lah'">
                  <xsl:text>Lahnda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lam'">
                  <xsl:text>Lamba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lao'">
                  <xsl:text>Lao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lo'">
                  <xsl:text>Lao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lat'">
                  <xsl:text>Latin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='la'">
                  <xsl:text>Latin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lav'">
                  <xsl:text>Latvian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lv'">
                  <xsl:text>Latvian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lez'">
                  <xsl:text>Lezghian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lim'">
                  <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='li'">
                  <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lin'">
                  <xsl:text>Lingala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ln'">
                  <xsl:text>Lingala</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lit'">
                  <xsl:text>Lithuanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lt'">
                  <xsl:text>Lithuanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lol'">
                  <xsl:text>Mongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='loz'">
                  <xsl:text>Lozi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ltz'">
                  <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lb'">
                  <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lua'">
                  <xsl:text>Luba-Lulua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lub'">
                  <xsl:text>Luba-Katanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lu'">
                  <xsl:text>Luba-Katanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lug'">
                  <xsl:text>Ganda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lg'">
                  <xsl:text>Ganda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lui'">
                  <xsl:text>Luiseno</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lun'">
                  <xsl:text>Lunda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='luo'">
                  <xsl:text>Luo (Kenya and Tanzania)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='lus'">
                  <xsl:text>Lushai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mac'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mkd'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mk'">
                  <xsl:text>Macedonian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mad'">
                  <xsl:text>Madurese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mag'">
                  <xsl:text>Magahi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mah'">
                  <xsl:text>Marshallese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mh'">
                  <xsl:text>Marshallese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mai'">
                  <xsl:text>Maithili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mak'">
                  <xsl:text>Makasar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mal'">
                  <xsl:text>Malayalam</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ml'">
                  <xsl:text>Malayalam</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='man'">
                  <xsl:text>Mandingo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mao'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mri'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mi'">
                  <xsl:text>Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='map'">
                  <xsl:text>Austronesian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mar'">
                  <xsl:text>Marathi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mr'">
                  <xsl:text>Marathi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mas'">
                  <xsl:text>Masai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='may'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='msa'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ms'">
                  <xsl:text>Malay</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mdf'">
                  <xsl:text>Moksha</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mdr'">
                  <xsl:text>Mandar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='men'">
                  <xsl:text>Mende</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mga'">
                  <xsl:text>Irish, Middle (900-1200)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mic'">
                  <xsl:text>Mi'kmaq or Micmac</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='min'">
                  <xsl:text>Minangkabau</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mis'">
                  <xsl:text>Miscellaneous languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mkh'">
                  <xsl:text>Mon-Khmer (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mlg'">
                  <xsl:text>Malagasy</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mg'">
                  <xsl:text>Malagasy</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mlt'">
                  <xsl:text>Maltese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mt'">
                  <xsl:text>Maltese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mnc'">
                  <xsl:text>Manchu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mni'">
                  <xsl:text>Manipuri</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mno'">
                  <xsl:text>Manobo languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='moh'">
                  <xsl:text>Mohawk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mol'">
                  <xsl:text>Moldavian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mo'">
                  <xsl:text>Moldavian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mon'">
                  <xsl:text>Mongolian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mn'">
                  <xsl:text>Mongolian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mos'">
                  <xsl:text>Mossi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mun'">
                  <xsl:text>Munda languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mus'">
                  <xsl:text>Creek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mwl'">
                  <xsl:text>Mirandese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='mwr'">
                  <xsl:text>Marwari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='myn'">
                  <xsl:text>Mayan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='myv'">
                  <xsl:text>Erzya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nah'">
                  <xsl:text>Nahuatl languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nai'">
                  <xsl:text>North American Indian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nap'">
                  <xsl:text>Neapolitan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nau'">
                  <xsl:text>Nauru</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='na'">
                  <xsl:text>Nauru</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nav'">
                  <xsl:text>Navajo or Navaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nv'">
                  <xsl:text>Navajo or Navaho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nbl'">
                  <xsl:text>Ndebele, South or South Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nr'">
                  <xsl:text>Ndebele, South or South Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nde'">
                  <xsl:text>Ndebele, North or North Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nd'">
                  <xsl:text>Ndebele, North or North Ndebele</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ndo'">
                  <xsl:text>Ndonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ng'">
                  <xsl:text>Ndonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nds'">
                  <xsl:text>Low German or Low Saxon or German, Low or Saxon, Low</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nep'">
                  <xsl:text>Nepali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ne'">
                  <xsl:text>Nepali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='new'">
                  <xsl:text>Nepal Bhasa or Newari</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nia'">
                  <xsl:text>Nias</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nic'">
                  <xsl:text>Niger-Kordofanian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='niu'">
                  <xsl:text>Niuean</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nno'">
                  <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nn'">
                  <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nob'">
                  <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nb'">
                  <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nog'">
                  <xsl:text>Nogai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='non'">
                  <xsl:text>Norse, Old</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nor'">
                  <xsl:text>Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='no'">
                  <xsl:text>Norwegian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nso'">
                  <xsl:text>Pedi or Sepedi or Northern Sotho</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nub'">
                  <xsl:text>Nubian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nwc'">
                  <xsl:text>Classical Newari or Old Newari or Classical Nepal Bhasa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nya'">
                  <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ny'">
                  <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nym'">
                  <xsl:text>Nyamwezi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nyn'">
                  <xsl:text>Nyankole</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nyo'">
                  <xsl:text>Nyoro</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nzi'">
                  <xsl:text>Nzima</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oci'">
                  <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oc'">
                  <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oji'">
                  <xsl:text>Ojibwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oj'">
                  <xsl:text>Ojibwa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ori'">
                  <xsl:text>Oriya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='or'">
                  <xsl:text>Oriya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='orm'">
                  <xsl:text>Oromo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='om'">
                  <xsl:text>Oromo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='osa'">
                  <xsl:text>Osage</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oss'">
                  <xsl:text>Ossetian or Ossetic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='os'">
                  <xsl:text>Ossetian or Ossetic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ota'">
                  <xsl:text>Turkish, Ottoman (1500-1928)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='oto'">
                  <xsl:text>Otomian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='paa'">
                  <xsl:text>Papuan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pag'">
                  <xsl:text>Pangasinan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pal'">
                  <xsl:text>Pahlavi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pam'">
                  <xsl:text>Pampanga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pan'">
                  <xsl:text>Panjabi or Punjabi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pa'">
                  <xsl:text>Panjabi or Punjabi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pap'">
                  <xsl:text>Papiamento</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pau'">
                  <xsl:text>Palauan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='peo'">
                  <xsl:text>Persian, Old (ca.600-400 B.C.)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='per'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fas'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='fa'">
                  <xsl:text>Persian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='phi'">
                  <xsl:text>Philippine (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='phn'">
                  <xsl:text>Phoenician</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pli'">
                  <xsl:text>Pali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pi'">
                  <xsl:text>Pali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pol'">
                  <xsl:text>Polish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pl'">
                  <xsl:text>Polish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pon'">
                  <xsl:text>Pohnpeian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='por'">
                  <xsl:text>Portuguese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pt'">
                  <xsl:text>Portuguese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pra'">
                  <xsl:text>Prakrit languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pro'">
                  <xsl:text>Proven√É¬ßal, Old (to 1500)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='pus'">
                  <xsl:text>Pushto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ps'">
                  <xsl:text>Pushto</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='que'">
                  <xsl:text>Quechua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='qu'">
                  <xsl:text>Quechua</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='raj'">
                  <xsl:text>Rajasthani</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rap'">
                  <xsl:text>Rapanui</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rar'">
                  <xsl:text>Rarotongan or Cook Islands Maori</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='roa'">
                  <xsl:text>Romance (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='roh'">
                  <xsl:text>Romansh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rm'">
                  <xsl:text>Romansh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rom'">
                  <xsl:text>Romany</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rum'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ron'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ro'">
                  <xsl:text>Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='run'">
                  <xsl:text>Rundi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rn'">
                  <xsl:text>Rundi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rup'">
                  <xsl:text>Aromanian or Arumanian or Macedo-Romanian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='rus'">
                  <xsl:text>Russian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ru'">
                  <xsl:text>Russian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sad'">
                  <xsl:text>Sandawe</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sag'">
                  <xsl:text>Sango</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sg'">
                  <xsl:text>Sango</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sah'">
                  <xsl:text>Yakut</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sai'">
                  <xsl:text>South American Indian (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sal'">
                  <xsl:text>Salishan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sam'">
                  <xsl:text>Samaritan Aramaic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='san'">
                  <xsl:text>Sanskrit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sa'">
                  <xsl:text>Sanskrit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sas'">
                  <xsl:text>Sasak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sat'">
                  <xsl:text>Santali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scc'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srp'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sr'">
                  <xsl:text>Serbian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scn'">
                  <xsl:text>Sicilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sco'">
                  <xsl:text>Scots</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='scr'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hrv'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='hr'">
                  <xsl:text>Croatian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sel'">
                  <xsl:text>Selkup</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sem'">
                  <xsl:text>Semitic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sga'">
                  <xsl:text>Irish, Old (to 900)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sgn'">
                  <xsl:text>Sign Languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='shn'">
                  <xsl:text>Shan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sid'">
                  <xsl:text>Sidamo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sin'">
                  <xsl:text>Sinhala or Sinhalese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='si'">
                  <xsl:text>Sinhala or Sinhalese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sio'">
                  <xsl:text>Siouan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sit'">
                  <xsl:text>Sino-Tibetan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sla'">
                  <xsl:text>Slavic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slo'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slk'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sk'">
                  <xsl:text>Slovak</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='slv'">
                  <xsl:text>Slovenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sl'">
                  <xsl:text>Slovenian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sma'">
                  <xsl:text>Southern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sme'">
                  <xsl:text>Northern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='se'">
                  <xsl:text>Northern Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smi'">
                  <xsl:text>Sami languages (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smj'">
                  <xsl:text>Lule Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smn'">
                  <xsl:text>Inari Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='smo'">
                  <xsl:text>Samoan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sm'">
                  <xsl:text>Samoan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sms'">
                  <xsl:text>Skolt Sami</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sna'">
                  <xsl:text>Shona</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sn'">
                  <xsl:text>Shona</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='snd'">
                  <xsl:text>Sindhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sd'">
                  <xsl:text>Sindhi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='snk'">
                  <xsl:text>Soninke</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sog'">
                  <xsl:text>Sogdian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='som'">
                  <xsl:text>Somali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='so'">
                  <xsl:text>Somali</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='son'">
                  <xsl:text>Songhai languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sot'">
                  <xsl:text>Sotho, Southern</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='st'">
                  <xsl:text>Sotho, Southern</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='spa'">
                  <xsl:text>Spanish or Castilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='es'">
                  <xsl:text>Spanish or Castilian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srd'">
                  <xsl:text>Sardinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sc'">
                  <xsl:text>Sardinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srn'">
                  <xsl:text>Sranan Tongo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='srr'">
                  <xsl:text>Serer</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ssa'">
                  <xsl:text>Nilo-Saharan (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ssw'">
                  <xsl:text>Swati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ss'">
                  <xsl:text>Swati</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='suk'">
                  <xsl:text>Sukuma</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sun'">
                  <xsl:text>Sundanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='su'">
                  <xsl:text>Sundanese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sus'">
                  <xsl:text>Susu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sux'">
                  <xsl:text>Sumerian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='swa'">
                  <xsl:text>Swahili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sw'">
                  <xsl:text>Swahili</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='swe'">
                  <xsl:text>Swedish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='sv'">
                  <xsl:text>Swedish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='syr'">
                  <xsl:text>Syriac</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tah'">
                  <xsl:text>Tahitian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ty'">
                  <xsl:text>Tahitian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tai'">
                  <xsl:text>Tai (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tam'">
                  <xsl:text>Tamil</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ta'">
                  <xsl:text>Tamil</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tat'">
                  <xsl:text>Tatar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tt'">
                  <xsl:text>Tatar</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tel'">
                  <xsl:text>Telugu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='te'">
                  <xsl:text>Telugu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tem'">
                  <xsl:text>Timne</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ter'">
                  <xsl:text>Tereno</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tet'">
                  <xsl:text>Tetum</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tgk'">
                  <xsl:text>Tajik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tg'">
                  <xsl:text>Tajik</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tgl'">
                  <xsl:text>Tagalog</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tl'">
                  <xsl:text>Tagalog</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tha'">
                  <xsl:text>Thai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='th'">
                  <xsl:text>Thai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tib'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bod'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='bo'">
                  <xsl:text>Tibetan</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tig'">
                  <xsl:text>Tigre</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tir'">
                  <xsl:text>Tigrinya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ti'">
                  <xsl:text>Tigrinya</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tiv'">
                  <xsl:text>Tiv</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tkl'">
                  <xsl:text>Tokelau</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tlh'">
                  <xsl:text>Klingon or tlhIngan-Hol</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tli'">
                  <xsl:text>Tlingit</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tmh'">
                  <xsl:text>Tamashek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tog'">
                  <xsl:text>Tonga (Nyasa)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ton'">
                  <xsl:text>Tonga (Tonga Islands)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='to'">
                  <xsl:text>Tonga (Tonga Islands)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tpi'">
                  <xsl:text>Tok Pisin</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tsi'">
                  <xsl:text>Tsimshian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tsn'">
                  <xsl:text>Tswana</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tn'">
                  <xsl:text>Tswana</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tso'">
                  <xsl:text>Tsonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ts'">
                  <xsl:text>Tsonga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tuk'">
                  <xsl:text>Turkmen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tk'">
                  <xsl:text>Turkmen</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tum'">
                  <xsl:text>Tumbuka</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tup'">
                  <xsl:text>Tupi languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tur'">
                  <xsl:text>Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tr'">
                  <xsl:text>Turkish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tut'">
                  <xsl:text>Altaic (Other)</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tvl'">
                  <xsl:text>Tuvalu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='twi'">
                  <xsl:text>Twi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tw'">
                  <xsl:text>Twi</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='tyv'">
                  <xsl:text>Tuvinian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='udm'">
                  <xsl:text>Udmurt</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uga'">
                  <xsl:text>Ugaritic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uig'">
                  <xsl:text>Uighur or Uyghur</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ug'">
                  <xsl:text>Uighur or Uyghur</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ukr'">
                  <xsl:text>Ukrainian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uk'">
                  <xsl:text>Ukrainian</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='umb'">
                  <xsl:text>Umbundu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='und'">
                  <xsl:text>Undetermined</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='urd'">
                  <xsl:text>Urdu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ur'">
                  <xsl:text>Urdu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uzb'">
                  <xsl:text>Uzbek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='uz'">
                  <xsl:text>Uzbek</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vai'">
                  <xsl:text>Vai</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ven'">
                  <xsl:text>Venda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ve'">
                  <xsl:text>Venda</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vie'">
                  <xsl:text>Vietnamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vi'">
                  <xsl:text>Vietnamese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vol'">
                  <xsl:text>Volap√É¬ºk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vo'">
                  <xsl:text>Volap√É¬ºk</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='vot'">
                  <xsl:text>Votic</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wak'">
                  <xsl:text>Wakashan languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wal'">
                  <xsl:text>Walamo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='war'">
                  <xsl:text>Waray</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='was'">
                  <xsl:text>Washo</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wel'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cym'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='cy'">
                  <xsl:text>Welsh</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wen'">
                  <xsl:text>Sorbian languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wln'">
                  <xsl:text>Walloon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wa'">
                  <xsl:text>Walloon</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wol'">
                  <xsl:text>Wolof</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='wo'">
                  <xsl:text>Wolof</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xal'">
                  <xsl:text>Kalmyk or Oirat</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xho'">
                  <xsl:text>Xhosa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='xh'">
                  <xsl:text>Xhosa</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yao'">
                  <xsl:text>Yao</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yap'">
                  <xsl:text>Yapese</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yid'">
                  <xsl:text>Yiddish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yi'">
                  <xsl:text>Yiddish</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yor'">
                  <xsl:text>Yoruba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='yo'">
                  <xsl:text>Yoruba</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='ypk'">
                  <xsl:text>Yupik languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zap'">
                  <xsl:text>Zapotec</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zen'">
                  <xsl:text>Zenaga</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zha'">
                  <xsl:text>Zhuang or Chuang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='za'">
                  <xsl:text>Zhuang or Chuang</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='znd'">
                  <xsl:text>Zande languages</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zul'">
                  <xsl:text>Zulu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zu'">
                  <xsl:text>Zulu</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zun'">
                  <xsl:text>Zuni</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zxx'">
                  <xsl:text>No linguistic content</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='nqo'">
                  <xsl:text>N'Ko</xsl:text>
               </xsl:when>
               <xsl:when test="@langcode='zza'">
                  <xsl:text>Zaza or Dimili or Dimli or Kirdki or Kirmanjki or Zazaki</xsl:text>
               </xsl:when>
            </xsl:choose>
         </dd>
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="ead:repository">
      <dt class="archdescLabel">
         <!--<xsl:value-of select="@label"/>-->
         <xsl:text>Location: </xsl:text>
      </dt>
      <dd class="archdescData">
         <xsl:apply-templates select="ead:corpname"/>
         <br/>
         <xsl:for-each select="ead:subarea">
            <xsl:apply-templates/>
            <br/>
         </xsl:for-each>
         <xsl:for-each select="ead:address/ead:addressline">
            <xsl:if test="position() != 1">
               <xsl:text> </xsl:text>
               <xsl:apply-templates/>
            </xsl:if>
         </xsl:for-each>
      </dd>
   </xsl:template>

   <!-- ead:bioghist ======================================================= -->
   <xsl:template match="ead:archdesc/ead:bioghist">
      <xsl:if test="ead:p">
         <h4 id="bioghist">
         	<xsl:choose>
         		<!-- RH 2022: We need to distinguish these by nested element, @encodinganalog was lost during the migration-->
         		<xsl:when test="../ead:did/ead:origination/(ead:persname|ead:famname)">
         			<xsl:text>Biography</xsl:text>
         		</xsl:when>
         		<xsl:otherwise>
         			<xsl:choose>
         				<xsl:when test="../ead:did/ead:origination/ead:corpname">
         					<xsl:text>Organizational History</xsl:text>
         				</xsl:when>
         				<xsl:otherwise>
         					<xsl:text>Biography/History</xsl:text>
         				</xsl:otherwise>
         			</xsl:choose>
         		</xsl:otherwise>
         	</xsl:choose>
         </h4>
         <xsl:apply-templates select="*[not(self::ead:dao)]"/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="ead:bioghist[not(parent::ead:archdesc)]">
      <p>Biography/History:</p>
      <xsl:apply-templates select="*[not(self::ead:dao)]"/>
   </xsl:template>

   <!-- descgrp[@id eq 'dacs3'] (scopecontent and arrangement) ============= -->
	<!-- RH 2022: Fix paths post-migration; no more dacs groupings for the notes -->
	
   <xsl:template match="ead:scopecontent">
      <h4 id="scopecontent">Description</h4>
      <xsl:apply-templates/>
      <!--<xsl:with-param name="id" select="'scopecontent'"/>
        </xsl:apply-templates>-->
   </xsl:template>

   <xsl:template match="ead:arrangement">
      <h4 id="arrangement">Arrangement</h4>
      <xsl:apply-templates select="ead:p"/>
      <xsl:choose>
         <xsl:when test="ead:list">
            <xsl:apply-templates select="ead:list"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="//ead:c[@level='series' or @level='subseries'] | //ead:c01[@level='series'] | //ead:c02[@level='subseries' ]">
               <ul class="normalIndent">
                  <xsl:for-each select="//ead:c[@level='series' or @level='subseries'] | //ead:c01[@level='series'] | //ead:c02[@level='subseries' ]">
                     <li>
                        <a>
                           <xsl:attribute name="href">
                              <xsl:value-of select="concat($xslt.base-uri, '/collections/', $xslt.record-id, '#', generate-id(.))"/>
                           </xsl:attribute>
                           <xsl:if test="self::ead:*/@level='subseries'">
                              <xsl:attribute name="style">margin-left:2em;</xsl:attribute>
                           </xsl:if>
                           <xsl:apply-templates select="ead:did/ead:unittitle"/>
                           <xsl:if test="ead:did/ead:unitdate">
                              <xsl:text>, </xsl:text>
                              <xsl:apply-templates select="ead:did/ead:unitdate"/>
                           </xsl:if>
                        </a>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
      <!--        <xsl:apply-templates/>-->
      <!--            <xsl:with-param name="id" select="'arrangement'"/>
        </xsl:apply-templates>-->
   </xsl:template>

   <!-- descgrp[id="dacs4"]/* (accessrestrict) ============================= -->
   <xsl:template match="ead:accessrestrict | ead:userestrict | ead:phystech">
      <h4 id="accessrestrict">Access and Use</h4>
      <xsl:apply-templates/>
      <!--<xsl:with-param name="id" select="'accessrestrict'"/>
        </xsl:apply-templates>-->
   </xsl:template>

   <!-- descgrp[id="dacs5"]/* (acqinfo) ==================================== -->
   <xsl:template match="ead:acqinfo | ead:appraisal | ead:accruals">
      <h4 id="acqinfo">Acquisition and Appraisal</h4>
      <xsl:apply-templates/>
      <!--            <xsl:with-param name="id" select="'acqinfo'"/>
        </xsl:apply-templates>-->
   </xsl:template>

   <!-- descgrp[id="dacs6"]/* (relatedmaterial) ============================ -->
   <xsl:template match="ead:relatedmaterial">
      <h4 id="relatedmaterial">Related Materials</h4>
      <xsl:apply-templates/>
      <!--            <xsl:with-param name="id" select="'relatedmaterial'"/>
        </xsl:apply-templates-->
   </xsl:template>

   <!-- descgrp[id="dacs7"]/* (processinfo) =============================== -->
	<xsl:template match="ead:prefercite | ead:processinfo | ead:bibliography">
      <h4 id="processinfo">Processing and Other Information</h4>
		<xsl:apply-templates select="ead:prefercite | ead:processinfo | ead:bibliography"/>
      <!--            <xsl:with-param name="id" select="'processinfo'"/>
        </xsl:apply-templates>-->

      <xsl:if test="//ead:eadheader/ead:profiledesc/ead:descrules">
         <h5>Descriptive Rules Used</h5>
         <p>
            <xsl:apply-templates select="//ead:eadheader/ead:profiledesc/ead:descrules"/>
         </p>
      </xsl:if>
      <xsl:if test="//ead:eadheader/ead:profiledesc/ead:creation">
         <h5>Encoding</h5>
         <p>
            <xsl:apply-templates select="//ead:eadheader/ead:profiledesc/ead:creation"/>
         </p>
      </xsl:if>
      <xsl:if test="//ead:eadheader/ead:profiledesc/ead:langusage">
         <h5>Language(s) of this Finding Aid</h5>
         <p>
            <xsl:apply-templates select="//ead:eadheader/ead:profiledesc/ead:langusage"/>
         </p>
      </xsl:if>
      <!-- NOTE: ead:prefercite gets its own h4 -->
      <h4 id="prefercite">Preferred Citation</h4>
      <xsl:apply-templates select="ead:prefercite"/>
      <!--
            <xsl:with-param name="id" select="'prefercite'"/>
        </xsl:apply-templates>-->
   </xsl:template>

   <!-- controlaccess/* (processinfo) ====================================== -->
   <!-- NOTE: this isn't very flexible. right now all ead:head and ead:p data 
        will appear before any of the terms. If an ead:p were every desired in
        anywhere other than prior to the list of terms this template would need
        adjustment/enhancement
   -->
   <xsl:template match="ead:controlaccess">
      <xsl:choose>
         <xsl:when test="ancestor::*[matches(local-name(), '^c(0\d)?$')]">
            <!-- when we're in the dsc -->
            <xsl:for-each select="child::*">
               <p>
                  <xsl:if test="@role">
                     <xsl:value-of select="pul:strip-trailspace(@role)"/>
                     <xsl:text>: </xsl:text>
                  </xsl:if>
                  <xsl:apply-templates/>
               </p>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <h4 id="controlaccess">Subject Headings</h4>
            <xsl:apply-templates select="ead:p"/>
            <!--
                    <xsl:with-param name="id" select="'controlaccess'"/>
                </xsl:apply-templates>-->
            <xsl:if
               test="ead:persname|ead:corpname|ead:famname|ead:name|
          ead:title|ead:subject[@source!='local']|ead:geogname|ead:genreform|ead:occupation">
               <ul class="normalIndent">
                  <xsl:for-each
                     select="ead:persname|ead:corpname|ead:famname|ead:name|
                     ead:title|ead:subject[@source!='local']|ead:geogname|
                     ead:genreform|ead:occupation">
                     <xsl:variable name="subjectTopic" select="replace(., '(\.| )$', '', 'm')"/>
                     <xsl:variable name="query">
                        <xsl:value-of select="$VOYAGER_QUERY_BASE"/>
                        <xsl:text>?utf8=true&amp;search_field=subject&amp;q=</xsl:text>
                        <xsl:value-of select="replace(normalize-space($subjectTopic), ' ', '+', 'm')"/>
                        <!--<xsl:text>&amp;CNT=50</xsl:text>-->
                     </xsl:variable>
                     <li>
                        <a href="{$query}">
                           <xsl:apply-templates select="current()"/>
                        </a>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:if>
            <xsl:if test="exists(ead:subject[@source='local'])">
               <p>Browse other finding aids related to the following terms:</p>
               <ul class="normalIndent">
                  <xsl:for-each select="ead:subject[@source='local']">
                     <xsl:variable name="searchTerm">
                        <xsl:choose>
                           <xsl:when test="exist:match">
                              <xsl:value-of select="string-join(exist:match, ' ')"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="current()"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <li>
                        <a href="{concat('search?zone1=sulocal&amp;text1=', $searchTerm)}">
                           <xsl:choose>
                              <xsl:when test="current()/(@authfilenumber | @id)='t1'">Africa</xsl:when>
                              <xsl:otherwise>
                                 <xsl:choose>
                                    <xsl:when test="(@authfilenumber | @id)='t2'">American history</xsl:when>
                                    <xsl:otherwise>
                                       <xsl:choose>
                                          <xsl:when test="(@authfilenumber | @id)='t3'">American history/20th century</xsl:when>
                                          <xsl:otherwise>
                                             <xsl:choose>
                                                <xsl:when test="(@authfilenumber | @id)='t4'">American history/Civil War and Reconstruction</xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:choose>
                                                      <xsl:when test="(@authfilenumber | @id)='t5'">American history/Colonial</xsl:when>
                                                      <xsl:otherwise>
                                                         <xsl:choose>
                                                            <xsl:when test="(@authfilenumber | @id)='t6'">American history/Early national</xsl:when>
                                                            <xsl:otherwise>
                                                               <xsl:choose>
                                                                  <xsl:when test="(@authfilenumber | @id)='t7'">American history/Gilded Age, Populism,
                                                                     Progressivism</xsl:when>
                                                                  <xsl:otherwise>
                                                                     <xsl:choose>
                                                                        <xsl:when test="(@authfilenumber | @id)='t8'">American history/Revolution</xsl:when>
                                                                        <xsl:otherwise>
                                                                           <xsl:choose>
                                                                              <xsl:when test="(@authfilenumber | @id)='t9'">American literature</xsl:when>
                                                                              <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t10'">American politics and
                                                                                government</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t11'">Ancient history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t12'">Antiquities</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t13'">Architecture</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t14'">Art history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t15'">Book history and arts</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t16'">British literature</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t17'">Cartography</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t18'">Children's books</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t19'">Classical literature</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t20'">Cold War</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t21'">Demography</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t22'">Diplomacy</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t23'">East Asian studies</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t24'">Economic history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t25'">Education</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t26'">Environmental studies</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t27'">European history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t28'">European literature</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t29'">Games and recreation</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t30'">Hellenic studies</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t31'">History of science</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t32'">International
                                                                                organizations</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t33'">Islamic manuscripts</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t34'">Journalism</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t35'">Latin American history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t36'">Latin American
                                                                                literature</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t37'">Latin American studies</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t38'">Legal history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t39'">Literature</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t40'">Medieval and Renaissance
                                                                                manuscripts</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t41'">Middle East</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t42'">Music</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t43'">Native American
                                                                                history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t44'">New Jerseyana</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t45'">Philosophy</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t46'">Photography</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t47'">Political cartoons</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t48'">Princeton University</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t49'">Public policy/20th
                                                                                century</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t50'">Publishing history</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t51'">Religion</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t52'">Russia</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t53'">Theater/Film</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t54'">Travel</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t55'">Western Americana</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t56'">Women's studies</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t57'">World War I</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                <xsl:when test="(@authfilenumber | @id)='t58'">World War II</xsl:when>
                                                                                <xsl:otherwise>
                                                                                <xsl:apply-templates select="current()"/>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                </xsl:otherwise>
                                                                                </xsl:choose>
                                                                              </xsl:otherwise>
                                                                           </xsl:choose>
                                                                        </xsl:otherwise>
                                                                     </xsl:choose>
                                                                  </xsl:otherwise>
                                                               </xsl:choose>
                                                            </xsl:otherwise>
                                                         </xsl:choose>
                                                      </xsl:otherwise>
                                                   </xsl:choose>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:otherwise>
                           </xsl:choose>
                        </a>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <!-- dsc/* (dsc) ======================================================== -->
   <xsl:template name="process-dsc-unit-elements">
      <!-- add choose: if both unitdate and unitttitle, test whether they're the same. If so, display unitdate. If not, add comma separator.
If only unitdate or only unittitle, display as is.  -->
      <xsl:choose>
         <xsl:when test="ead:did/ead:unitdate">
            <xsl:for-each select="ead:did">
               <xsl:choose>
                  <xsl:when test="ead:unittitle=ead:unitdate">
                     <xsl:if test="ead:unitdate[1]/@type='bulk'">
                        <xsl:text>bulk </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates select="ead:unitdate[1]"/>
                     <xsl:if test="ead:unitdate[position()>1]">
                        <xsl:text>, </xsl:text>
                        <xsl:if test="ead:unitdate[position()>1]/@type='bulk'">
                           <xsl:text>bulk </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="ead:unitdate[position()>1]"/>
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="ead:unittitle">
                           <xsl:apply-templates select="ead:unittitle"/>
                           <xsl:for-each select="ead:unitdate">
                              <xsl:text>, </xsl:text>
                              <xsl:if test="@type='bulk'">
                                 <xsl:text>bulk </xsl:text>
                              </xsl:if>
                              <xsl:apply-templates select="current()"/>
                           </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:if test="ead:unitdate[1]/@type='bulk'">
                              <xsl:text>bulk </xsl:text>
                           </xsl:if>
                           <xsl:apply-templates select="ead:unitdate[1]"/>
                           <xsl:if test="ead:unitdate[position()>1]">
                              <xsl:text>, </xsl:text>
                              <xsl:if test="ead:unitdate[position()>1]/@type='bulk'">
                                 <xsl:text>bulk </xsl:text>
                              </xsl:if>
                              <xsl:apply-templates select="ead:unitdate[position()>1]"/>
                           </xsl:if>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="ead:did/ead:unittitle"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template match="ead:dsc">
      <!--        <xsl:choose>
            <xsl:when test="child::ead:head">
                <h4 id="dsc">
                    <xsl:apply-templates select="ead:head"/>
                </h4>
            </xsl:when>
            <xsl:otherwise>-->
      <h4 id="dsc">Contents List</h4>
      
         
      <ol class="contents">
         <xsl:for-each select="(descendant::*)[matches(local-name(), '^c(0\d)?$')]">
            <xsl:variable name="class">
               <xsl:choose>
                  <xsl:when test="self::ead:c01">c01</xsl:when>
                  <xsl:when test="self::ead:c02">c02</xsl:when>
                  <xsl:when test="self::ead:c03">c03</xsl:when>
                  <xsl:when test="self::ead:c04">c04</xsl:when>
                  <xsl:when test="self::ead:c05">c05</xsl:when>
                  <xsl:when test="self::ead:c06">c06</xsl:when>
                  <xsl:when test="self::ead:c07">c07</xsl:when>
                  <xsl:when test="self::ead:c08">c08</xsl:when>
                  <xsl:when test="self::ead:c">
                     <xsl:choose>
                        <xsl:when test="count(ancestor::ead:c) = 0">c01</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 1">c02</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 2">c03</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 3">c04</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 4">c05</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 5">c06</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 6">c07</xsl:when>
                        <xsl:when test="count(ancestor::ead:c) = 7">c08</xsl:when>
                     </xsl:choose>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <li id="{@id}">
               <xsl:attribute name="class">
                  <xsl:choose>
                     <xsl:when test="position() mod 2 = 0">even</xsl:when>
                     <xsl:otherwise>odd</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <table class="{$class}">
                  <tr>

                     <td class="data">
                        <xsl:if test="not(ead:did/ead:container)">
                           <xsl:attribute name="colspan" select="'3'"/>
                        </xsl:if>
                        <xsl:choose>
                           <xsl:when test="not(matches(@level, 'file|item|otherlevel'))">
                              <!-- RH: add otherlevel -->
                              <h5>
                                 <!--                                            <xsl:if test="@id">
                                                <xsl:attribute name="id" select="@id"/>
                                            </xsl:if>-->
                                 <xsl:attribute name="id" select="generate-id()"/>
                                 <xsl:call-template name="process-dsc-unit-elements"/>
                              </h5>
                           </xsl:when>
                           <xsl:otherwise>
                              <p class="bold {$class}">
                                 <xsl:if test="@id">
                                    <xsl:attribute name="id" select="@id"/>
                                 </xsl:if>
                                 <xsl:call-template name="process-dsc-unit-elements"/>
                              </p>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="ead:did/ead:unitid"/>
                        <xsl:apply-templates select="ead:did/ead:physdesc"/>
                        <xsl:apply-templates select="ead:did/ead:physloc"/>
                        <xsl:apply-templates select="ead:did/ead:origination"/>
                        <xsl:apply-templates select="ead:bioghist"/>
                        <xsl:apply-templates select="ead:scopecontent"/>
                        <xsl:apply-templates select="ead:arrangement"/>
                        <xsl:apply-templates select="ead:controlaccess"/>
                        <xsl:apply-templates select="ead:dao|ead:did/ead:dao"/>
                        <xsl:apply-templates select="ead:accessrestrict"/>
                        <xsl:apply-templates select="ead:userestrict"/>
                        <xsl:apply-templates select="ead:altformavail"/>
                        <xsl:apply-templates select="ead:originalsloc"/>
                        <xsl:apply-templates select="ead:did/ead:langmaterial"/>
                        <xsl:apply-templates select="ead:did/ead:materialspec"/>
                        <xsl:apply-templates select="ead:odd"/>
                        <xsl:apply-templates select="ead:phystech"/>
                        <xsl:apply-templates select="ead:otherfindaid"/>
                        <xsl:apply-templates select="ead:custodhist"/>
                        <xsl:apply-templates select="ead:acqinfo"/>
                        <xsl:apply-templates select="ead:appraisal"/>
                        <xsl:apply-templates select="ead:accruals"/>
                        <xsl:apply-templates select="ead:relatedmaterial"/>
                        <xsl:apply-templates select="ead:bibliography"/>
                        <xsl:apply-templates select="ead:separatedmaterial"/>
                        
                        <!-- Added originalsloc, RH: langmaterial, odd, phystech, otherfindaid, custodhist, acqinfo, appraisal, accruals, relatedmaterial,
                                bibliography, separatedmaterial-->
                        <!-- any others? -->
                        <!--<p>
                           <a href="{$xslt.base-uri}/index.html#dsc">Back to Top of Contents List</a>
                        </p>-->
                     </td>
                     <xsl:if test="(ead:did/ead:container | ead:did/ead:unitid[@type='itemnumber'])">
        
                        <td class="container">
                           <xsl:for-each select="ead:did/ead:container">   
                              <xsl:choose>
                                 <xsl:when test="ead:ptr">
                                    <xsl:variable name="target_id" select="ead:ptr/@target"/>
                                    <xsl:value-of select="concat(lib:capitalize-first(//ead:dsc[@type='othertype']/ead:c[@id=$target_id]/ead:did/ead:container/@type), ' ', //ead:dsc[@type='othertype']/ead:c[@id=$target_id]/ead:did/ead:container)"/>   

                                    <xsl:if test="position() ne last()">,</xsl:if>
                                 </xsl:when>
                                 <xsl:when test="./@parent and ./@parent[not(matches(.,'^cid'))] and //ead:dsc[@type='othertype']">
                                    <xsl:variable name="sub_container" select="@parent"/>
                                    <xsl:value-of select="upper-case(substring(//ead:dsc[@type='othertype']/ead:c[@id=$sub_container]/ead:did/ead:container/@type,1,1))"/>
                                    <xsl:value-of select="substring(//ead:dsc[@type='othertype']/ead:c[@id=$sub_container]/ead:did/ead:container/@type,2)"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="//ead:dsc[@type='othertype']/ead:c[@id=$sub_container]/ead:did/ead:container"/>
                                    <xsl:if test="position() ne last()">,</xsl:if>
                                 </xsl:when>
                                 <!--<xsl:when test=".[@type='album'] | .[@type='box'] | .[@type='carton'] | .[@type='case'] | .[@type='letterbook'] | .[@type='notebook'] | .[@type='oversize'] | .[@type='package'] | .[@type='portfolio'] | .[@type='scrapbook'] | .[@type='tube'] | .[@type='volume']">
                                    <xsl:value-of select="./concat(normalize-space(upper-case(@type)), ' ', normalize-space(.))"/>
                                 </xsl:when>-->
                                 <xsl:otherwise>
                                    <xsl:if test=".[@type='album'] | .[@type='box'] | .[@type='carton'] | .[@type='case'] | .[@type='letterbook'] | .[@type='notebook'] | .[@type='oversize'] | .[@type='package'] | .[@type='portfolio'] | .[@type='scrapbook'] | .[@type='tube'] | .[@type='volume']">
                                       <xsl:value-of
                                          select="concat(upper-case(substring(pul:strip-trailspace(@type),1,1)),
                                          substring(pul:strip-trailspace(@type), 2))"/>
                                       <xsl:text> </xsl:text>
                                       <xsl:value-of select="current()"/>
                                       <xsl:if test="position() != last()">
                                          <xsl:text>, </xsl:text>
                                       </xsl:if>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:text> </xsl:text>
                              
                              <xsl:if test="not(.[@type='album'] | .[@type='box'] | .[@type='carton'] | .[@type='case'] | .[@type='letterbook'] | .[@type='notebook'] | .[@type='oversize'] | .[@type='package'] | .[@type='portfolio'] | .[@type='scrapbook'] | .[@type='tube'] | .[@type='volume'])">
                                 <xsl:value-of select="./normalize-space(upper-case(substring(@type,1,1)))"/>
                                 <xsl:value-of select="./concat(normalize-space(substring(@type,2)), ' ', normalize-space(.))"/>
                              </xsl:if>
                              
                           </xsl:for-each>
                           
                           <xsl:for-each select="ead:did/ead:unitid[@type='itemnumber']">
                              <xsl:text>Item Number: </xsl:text>
                              <xsl:choose>
                                 <xsl:when test="ead:ptr">
                                    <xsl:variable name="target_id" select="ead:ptr/@target"/>
                                    <xsl:value-of select="concat(upper-case(//ead:dsc[@type='othertype']/ead:c[@id=$target_id]/ead:did/ead:container/@type), ' ', //ead:dsc[@type='othertype']/ead:c[@id=$target_id]/ead:did/ead:container)"/>   
                                    <xsl:if test="position() ne last()">,</xsl:if>
                                 </xsl:when>
                                 <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each>
                           
                         <!--  <xsl:for-each select="ead:did/ead:container">
                              <xsl:value-of
                                 select="concat(upper-case(substring(pul:strip-trailspace(@type),1,1)),
                                            substring(pul:strip-trailspace(@type), 2))"/>
                              <xsl:text> </xsl:text>
                              <xsl:value-of select="current()"/>
                              <xsl:if test="position() != last()">
                                 <xsl:text>, </xsl:text>
                              </xsl:if>
                           </xsl:for-each>-->
                        </td>
                     </xsl:if>
                  </tr>
               </table>
            </li>
         </xsl:for-each>
      </ol>

   </xsl:template>

   <!-- controlaccess/* (processinfo) ====================================== -->
   <xsl:template match="ead:index[not(ancestor::ead:dsc)]">
      <!--Hacking a substitute for position(), which seems to not work from a 
      matching template, which used to work... Should be: 
      <xsl:variable name="position" select="position()"/>
      -->
      <xsl:variable name="position" select="count(preceding-sibling::ead:index)+1"/>
      <h4>
         <xsl:attribute name="id">
            <xsl:value-of select="concat('index', $position)"/>
         </xsl:attribute>
      </h4>
      <xsl:apply-templates select="ead:p"/>
      <!--            <xsl:with-param name="id" select="concat('index', $position)"/>
        </xsl:apply-templates>-->
      <ul>
         <xsl:apply-templates select="ead:indexentry"/>
      </ul>
   </xsl:template>

   <xsl:template match="ead:indexentry">
      <!-- This template makes recursive html:uls for each nested ead:indexentry.
           it is possible that more elements should be available to html:h6, or that
           the elements matched need further development in general
      -->
      <li>
         <xsl:if test="ead:name">
            <h6>
               <xsl:apply-templates select="ead:name"/>
            </h6>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="not(parent::ead:indexentry)">
               <!-- not sure why 'not()' works, seems likeit should be the opposite. Bug? -->
               <ul>
                  <xsl:apply-templates select="*[not(self::ead:ref) and not(self::ead:name)]"/>
                  <!-- note that this includes ead:indexentry recursively -->
                  <xsl:if test="ead:ref">
                     <xsl:text>&#160;&#8210;&#160;</xsl:text>
                     <xsl:apply-templates select="ead:ref"/>
                  </xsl:if>
               </ul>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="*[not(self::ead:ref) and not(self::ead:name)]"/>
               <xsl:if test="ead:ref">
                  <xsl:text>&#160;&#8210;&#160;</xsl:text>
                  <xsl:apply-templates select="ead:ref"/>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
      </li>
   </xsl:template>
   <!-- Headings =========================================================== -->

   <!-- odd/* (odd) ======================================================== -->
   <xsl:template match="ead:odd[not(ancestor::ead:dsc)]">
      <xsl:variable name="position" as="xs:integer" select="count(preceding-sibling::ead:odd) + 1"/>
      <h4>
         <xsl:attribute name="id">
            <xsl:value-of select="concat('odd', $position cast as xs:string)"/>
         </xsl:attribute>
      </h4>
      <xsl:apply-templates/>
      <!--            <xsl:with-param name="id" select="concat('odd', $position cast as xs:string)"/>
        </xsl:apply-templates>-->
   </xsl:template>
    
    
    <xsl:template match="ead:dao|ead:did/ead:dao">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@xlink:href"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>btn small</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="target">
                <xsl:text>_blank</xsl:text>
            </xsl:attribute>
            View PDF
        </a>
    </xsl:template>
    
   <xsl:template match="ead:accessrestrict[not(ancestor::ead:dsc)]">
      <xsl:choose>
         <xsl:when test="preceding-sibling::ead:accessrestrict">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <h5>
               <xsl:text>Access</xsl:text>
            </h5>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>
   <xsl:template match="ead:userestrict[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Restrictions on Use and Copyright Information</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:phystech[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Physical Characteristics and Technical Requirements</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:otherfindaid[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Other Finding Aid(s)</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:custodhist[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Custodial History</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:acqinfo[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Provenance and Acquisition</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:appraisal[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Appraisal</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:accruals[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Accruals</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:originalsloc[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Location of Originals</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:altformavail[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Location of Copies or Alternate Formats</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:relatedmaterial[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Related Materials</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:bibliography[not(ancestor::ead:dsc)]">

      <xsl:if test="../@id='dacs6'">
         <h5>
            <xsl:text>Publications Citing These Papers</xsl:text>
         </h5>
         <xsl:apply-templates/>
      </xsl:if>
      <xsl:if test="../@id='dacs7'">
         <h5>
            <xsl:text>Works Cited</xsl:text>
         </h5>
         <xsl:apply-templates/>
      </xsl:if>
   </xsl:template>
   <!--<xsl:template match="ead:prefercite[not(ancestor::ead:dsc)]">
        <h5>
            <xsl:text>Preferred Citation</xsl:text>
        </h5>   
        <xsl:apply-templates/>
    </xsl:template>-->
   <xsl:template match="ead:separatedmaterial[not(ancestor::ead:dsc)]">
      <h5>
         <xsl:text>Separated Material</xsl:text>
      </h5>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:processinfo[not(ancestor::ead:dsc)]">
      <xsl:if test="@id='conservation'">
         <h5>
            <xsl:text>Conservation</xsl:text>
         </h5>
         <xsl:apply-templates/>
      </xsl:if>
      <xsl:if test="@id='processing'">
         <h5>
            <xsl:text>Processing Information</xsl:text>
         </h5>
         <xsl:apply-templates/>
      </xsl:if>
   </xsl:template>



   <!--    <xsl:template match="ead:head[not(ancestor::ead:dsc)]">
        <xsl:param name="id"/>
        <xsl:choose>
            <xsl:when
                test="../../../ead:archdesc|parent::ead:bioghist|parent::ead:descgrp|parent::ead:scopecontent|
        parent::ead:arrangement|parent::ead:prefercite|ead:odd|parent::ead:controlaccess">
                <h4>
                    <xsl:if test="$id ne ''">
                        <xsl:attribute name="id" select="$id"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
            <xsl:when
                test="parent::ead:accessrestrict|parent::ead:userestrict|
        parent::ead:phystech|parent::ead:otherfindaid|parent::ead:custodhist|
        parent::ead:acqinfo|parent::ead:appraisal|parent::ead:accruals|parent::ead:originalsloc|parent::ead:altformavail|
        parent::ead:relatedmaterial|parent::ead:bibliography|parent::ead:prefercite|parent::ead:processinfo|parent::ead:separatedmaterial">
                <h5>
                    <xsl:apply-templates/>
                </h5>
            </xsl:when>
            <xsl:otherwise>
                <strong>
                    <xsl:apply-templates/>
                    <xsl:text> </xsl:text>
                </strong>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

   <!--    <xsl:template match="ead:head[ancestor::*[matches(local-name(), '^c(0\d)?$')]]">
        <p class="cHead">
            <xsl:apply-templates/>
        </p>
    </xsl:template>-->
   <!-- RH: don't link dsc-level origination -->
   <xsl:template match="ead:dsc//ead:origination">
      <p>
         <!--<xsl:choose>
                     if not check if our parent has a label -->
         <!--<xsl:when test="../@label">-->
         <!-- RH: make first letter of label uppercase -->
         <!--<xsl:value-of
                            select="pul:strip-trailspace(concat(translate(substring(../@label, 1, 1),  'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(../@label, 2)))"
                        />
                    </xsl:when>
                    <xsl:otherwise>Creator:</xsl:otherwise>
                </xsl:choose>-->
         <xsl:text>Creator: </xsl:text>
         <xsl:apply-templates select="(ead:list|ead:persname|ead:corpname|ead:famname)[position()=1]"> </xsl:apply-templates>
         <xsl:if test="(ead:list|ead:persname|ead:corpname|ead:famname)[position()>1]">
            <xsl:for-each select="(ead:list|ead:persname|ead:corpname|ead:famname)[position()>1]">
               <xsl:text>; </xsl:text>
               <xsl:apply-templates select="."/>
            </xsl:for-each>
         </xsl:if>
      </p>

   </xsl:template>

   <xsl:template match="ead:physdesc[ancestor::ead:dsc]">
      <xsl:choose>
         <xsl:when test="ead:extent[not(@type)]|ead:dimensions|ead:physfacet">
            <xsl:if test="ead:extent[not(@type)]">
               <p>Size: <xsl:apply-templates select="ead:extent[not(@type)][position()=1]"/>
                  <xsl:if test="ead:extent[not(@type)][position()>1]"><xsl:for-each select="ead:extent[not(@type)][position()>1]">,
                        <xsl:apply-templates/></xsl:for-each></xsl:if>
               </p>
            </xsl:if>
            <!-- RH: add dimensions, physfacet -->
            <xsl:if test="ead:dimensions">
               <p>Dimensions: <xsl:apply-templates select="ead:dimensions"/></p>

            </xsl:if>
            <xsl:if test="ead:physfacet">
               <p>Physical Characteristics: <xsl:apply-templates select="ead:physfacet"/></p>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="ead:extent[@type]"/>
            <xsl:if test="text()">
               <p>Physical Characteristics: <xsl:apply-templates select="text()"/></p>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="ead:controlaccess[ancestor::ead:dsc]">
      <p>
         <xsl:text>Subject headings:</xsl:text>
      </p>
      <xsl:apply-templates select="./*[1]"/>
      <xsl:for-each select="./*[position()>1]">
         <br/>
         <xsl:apply-templates/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="ead:langmaterial[ancestor::ead:dsc]">
      <p>
         <xsl:text>Language(s) of Materials: </xsl:text>
      </p>
      <p>
         <xsl:apply-templates select="ead:language[1]"/>
         <xsl:for-each select="ead:language[position()>1]">, <xsl:apply-templates select="current()"/></xsl:for-each>
      </p>
   </xsl:template>
   <xsl:template match="ead:did/ead:langmaterial[ancestor::ead:dsc]/ead:language">
      <xsl:choose>
         <xsl:when test="@langcode='aar'">
            <xsl:text>Afar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='aa'">
            <xsl:text>Afar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='abk'">
            <xsl:text>Abkhazian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ab'">
            <xsl:text>Abkhazian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ace'">
            <xsl:text>Achinese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ach'">
            <xsl:text>Acoli</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ada'">
            <xsl:text>Adangme</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ady'">
            <xsl:text>Adyghe or Adygei</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='afa'">
            <xsl:text>Afro-Asiatic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='afh'">
            <xsl:text>Afrihili</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='afr'">
            <xsl:text>Afrikaans</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='af'">
            <xsl:text>Afrikaans</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ain'">
            <xsl:text>Ainu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='aka'">
            <xsl:text>Akan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ak'">
            <xsl:text>Akan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='akk'">
            <xsl:text>Akkadian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='alb'">
            <xsl:text>Albanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sqi'">
            <xsl:text>Albanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sq'">
            <xsl:text>Albanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ale'">
            <xsl:text>Aleut</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='alg'">
            <xsl:text>Algonquian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='alt'">
            <xsl:text>Southern Altai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='amh'">
            <xsl:text>Amharic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='am'">
            <xsl:text>Amharic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ang'">
            <xsl:text>English, Old (ca.450-1100)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='anp'">
            <xsl:text>Angika</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='apa'">
            <xsl:text>Apache languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ara'">
            <xsl:text>Arabic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ar'">
            <xsl:text>Arabic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arc'">
            <xsl:text>Aramaic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arg'">
            <xsl:text>Aragonese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='an'">
            <xsl:text>Aragonese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arm'">
            <xsl:text>Armenian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hye'">
            <xsl:text>Armenian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hy'">
            <xsl:text>Armenian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arn'">
            <xsl:text>Mapudungun or Mapuche</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arp'">
            <xsl:text>Arapaho</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='art'">
            <xsl:text>Artificial (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='arw'">
            <xsl:text>Arawak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='asm'">
            <xsl:text>Assamese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='as'">
            <xsl:text>Assamese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ast'">
            <xsl:text>Asturian or Bable</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ath'">
            <xsl:text>Athapascan languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='aus'">
            <xsl:text>Australian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ava'">
            <xsl:text>Avaric</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='av'">
            <xsl:text>Avaric</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ave'">
            <xsl:text>Avestan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ae'">
            <xsl:text>Avestan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='awa'">
            <xsl:text>Awadhi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='aym'">
            <xsl:text>Aymara</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ay'">
            <xsl:text>Aymara</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='aze'">
            <xsl:text>Azerbaijani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='az'">
            <xsl:text>Azerbaijani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bad'">
            <xsl:text>Banda languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bai'">
            <xsl:text>Bamileke languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bak'">
            <xsl:text>Bashkir</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ba'">
            <xsl:text>Bashkir</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bal'">
            <xsl:text>Baluchi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bam'">
            <xsl:text>Bambara</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bm'">
            <xsl:text>Bambara</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ban'">
            <xsl:text>Balinese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='baq'">
            <xsl:text>Basque</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='eus'">
            <xsl:text>Basque</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='eu'">
            <xsl:text>Basque</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bas'">
            <xsl:text>Basa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bat'">
            <xsl:text>Baltic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bej'">
            <xsl:text>Beja</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bel'">
            <xsl:text>Belarusian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='be'">
            <xsl:text>Belarusian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bem'">
            <xsl:text>Bemba</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ben'">
            <xsl:text>Bengali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bn'">
            <xsl:text>Bengali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ber'">
            <xsl:text>Berber (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bho'">
            <xsl:text>Bhojpuri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bih'">
            <xsl:text>Bihari</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bh'">
            <xsl:text>Bihari</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bik'">
            <xsl:text>Bikol</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bin'">
            <xsl:text>Bini or Edo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bis'">
            <xsl:text>Bislama</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bi'">
            <xsl:text>Bislama</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bla'">
            <xsl:text>Siksika</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bnt'">
            <xsl:text>Bantu (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bos'">
            <xsl:text>Bosnian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bs'">
            <xsl:text>Bosnian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bra'">
            <xsl:text>Braj</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bre'">
            <xsl:text>Breton</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='br'">
            <xsl:text>Breton</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='btk'">
            <xsl:text>Batak languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bua'">
            <xsl:text>Buriat</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bug'">
            <xsl:text>Buginese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bul'">
            <xsl:text>Bulgarian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bg'">
            <xsl:text>Bulgarian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bur'">
            <xsl:text>Burmese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mya'">
            <xsl:text>Burmese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='my'">
            <xsl:text>Burmese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='byn'">
            <xsl:text>Blin or Bilin</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cad'">
            <xsl:text>Caddo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cai'">
            <xsl:text>Central American Indian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='car'">
            <xsl:text>Galibi Carib</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cat'">
            <xsl:text>Catalan or Valencian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ca'">
            <xsl:text>Catalan or Valencian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cau'">
            <xsl:text>Caucasian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ceb'">
            <xsl:text>Cebuano</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cel'">
            <xsl:text>Celtic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cha'">
            <xsl:text>Chamorro</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ch'">
            <xsl:text>Chamorro</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chb'">
            <xsl:text>Chibcha</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='che'">
            <xsl:text>Chechen</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ce'">
            <xsl:text>Chechen</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chg'">
            <xsl:text>Chagatai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chi'">
            <xsl:text>Chinese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zho'">
            <xsl:text>Chinese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zh'">
            <xsl:text>Chinese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chk'">
            <xsl:text>Chuukese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chm'">
            <xsl:text>Mari</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chn'">
            <xsl:text>Chinook jargon</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cho'">
            <xsl:text>Choctaw</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chp'">
            <xsl:text>Chipewyan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chr'">
            <xsl:text>Cherokee</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chu'">
            <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cu'">
            <xsl:text>Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chv'">
            <xsl:text>Chuvash</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cv'">
            <xsl:text>Chuvash</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='chy'">
            <xsl:text>Cheyenne</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cmc'">
            <xsl:text>Chamic languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cop'">
            <xsl:text>Coptic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cor'">
            <xsl:text>Cornish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kw'">
            <xsl:text>Cornish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cos'">
            <xsl:text>Corsican</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='co'">
            <xsl:text>Corsican</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cpe'">
            <xsl:text>Creoles and pidgins, English based (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cpf'">
            <xsl:text>Creoles and pidgins, French-based (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cpp'">
            <xsl:text>Creoles and pidgins, Portuguese-based (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cre'">
            <xsl:text>Cree</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cr'">
            <xsl:text>Cree</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='crh'">
            <xsl:text>Crimean Tatar or Crimean Turkish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='crp'">
            <xsl:text>Creoles and pidgins (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='csb'">
            <xsl:text>Kashubian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cus'">
            <xsl:text>Cushitic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cze'">
            <xsl:text>Czech</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ces'">
            <xsl:text>Czech</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cs'">
            <xsl:text>Czech</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dak'">
            <xsl:text>Dakota</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dan'">
            <xsl:text>Danish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='da'">
            <xsl:text>Danish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dar'">
            <xsl:text>Dargwa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='day'">
            <xsl:text>Land Dayak languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='del'">
            <xsl:text>Delaware</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='den'">
            <xsl:text>Slave (Athapascan)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dgr'">
            <xsl:text>Dogrib</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='din'">
            <xsl:text>Dinka</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='div'">
            <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dv'">
            <xsl:text>Divehi or Dhivehi or Maldivian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='doi'">
            <xsl:text>Dogri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dra'">
            <xsl:text>Dravidian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dsb'">
            <xsl:text>Lower Sorbian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dua'">
            <xsl:text>Duala</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dum'">
            <xsl:text>Dutch, Middle (ca.1050-1350)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dut'">
            <xsl:text>Dutch or Flemish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nld'">
            <xsl:text>Dutch or Flemish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nl'">
            <xsl:text>Dutch or Flemish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dyu'">
            <xsl:text>Dyula</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dzo'">
            <xsl:text>Dzongkha</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='dz'">
            <xsl:text>Dzongkha</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='efi'">
            <xsl:text>Efik</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='egy'">
            <xsl:text>Egyptian (Ancient)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='eka'">
            <xsl:text>Ekajuk</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='elx'">
            <xsl:text>Elamite</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='eng'">
            <xsl:text>English</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='en'">
            <xsl:text>English</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='enm'">
            <xsl:text>English, Middle (1100-1500)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='epo'">
            <xsl:text>Esperanto</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='eo'">
            <xsl:text>Esperanto</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='est'">
            <xsl:text>Estonian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='et'">
            <xsl:text>Estonian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ewe'">
            <xsl:text>Ewe</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ee'">
            <xsl:text>Ewe</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ewo'">
            <xsl:text>Ewondo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fan'">
            <xsl:text>Fang</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fao'">
            <xsl:text>Faroese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fo'">
            <xsl:text>Faroese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fat'">
            <xsl:text>Fanti</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fij'">
            <xsl:text>Fijian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fj'">
            <xsl:text>Fijian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fil'">
            <xsl:text>Filipino or Pilipino</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fin'">
            <xsl:text>Finnish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fi'">
            <xsl:text>Finnish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fiu'">
            <xsl:text>Finno-Ugrian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fon'">
            <xsl:text>Fon</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fre'">
            <xsl:text>French</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fra'">
            <xsl:text>French</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fr'">
            <xsl:text>French</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='frm'">
            <xsl:text>French, Middle (ca.1400-1600)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fro'">
            <xsl:text>French, Old (842-ca.1400)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='frr'">
            <xsl:text>Northern Frisian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='frs'">
            <xsl:text>Eastern Frisian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fry'">
            <xsl:text>Western Frisian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fy'">
            <xsl:text>Western Frisian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ful'">
            <xsl:text>Fulah</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ff'">
            <xsl:text>Fulah</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fur'">
            <xsl:text>Friulian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gaa'">
            <xsl:text>Ga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gay'">
            <xsl:text>Gayo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gba'">
            <xsl:text>Gbaya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gem'">
            <xsl:text>Germanic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='geo'">
            <xsl:text>Georgian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kat'">
            <xsl:text>Georgian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ka'">
            <xsl:text>Georgian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ger'">
            <xsl:text>German</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='deu'">
            <xsl:text>German</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='de'">
            <xsl:text>German</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gez'">
            <xsl:text>Geez</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gil'">
            <xsl:text>Gilbertese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gla'">
            <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gd'">
            <xsl:text>Gaelic or Scottish Gaelic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gle'">
            <xsl:text>Irish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ga'">
            <xsl:text>Irish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='glg'">
            <xsl:text>Galician</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gl'">
            <xsl:text>Galician</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='glv'">
            <xsl:text>Manx</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gv'">
            <xsl:text>Manx</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gmh'">
            <xsl:text>German, Middle High (ca.1050-1500)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='goh'">
            <xsl:text>German, Old High (ca.750-1050)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gon'">
            <xsl:text>Gondi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gor'">
            <xsl:text>Gorontalo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='got'">
            <xsl:text>Gothic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='grb'">
            <xsl:text>Grebo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='grc'">
            <xsl:text>Greek, Ancient (to 1453)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gre'">
            <xsl:text>Greek, Modern (1453-)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ell'">
            <xsl:text>Greek, Modern (1453-)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='el'">
            <xsl:text>Greek, Modern (1453-)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='grn'">
            <xsl:text>Guarani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gn'">
            <xsl:text>Guarani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gsw'">
            <xsl:text>Swiss German or Alemannic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='guj'">
            <xsl:text>Gujarati</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gu'">
            <xsl:text>Gujarati</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='gwi'">
            <xsl:text>Gwich'in</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hai'">
            <xsl:text>Haida</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hat'">
            <xsl:text>Haitian or Haitian Creole</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ht'">
            <xsl:text>Haitian or Haitian Creole</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hau'">
            <xsl:text>Hausa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ha'">
            <xsl:text>Hausa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='haw'">
            <xsl:text>Hawaiian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='heb'">
            <xsl:text>Hebrew</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='he'">
            <xsl:text>Hebrew</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='her'">
            <xsl:text>Herero</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hz'">
            <xsl:text>Herero</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hil'">
            <xsl:text>Hiligaynon</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='him'">
            <xsl:text>Himachali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hin'">
            <xsl:text>Hindi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hi'">
            <xsl:text>Hindi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hit'">
            <xsl:text>Hittite</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hmn'">
            <xsl:text>Hmong</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hmo'">
            <xsl:text>Hiri Motu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ho'">
            <xsl:text>Hiri Motu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hsb'">
            <xsl:text>Upper Sorbian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hun'">
            <xsl:text>Hungarian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hu'">
            <xsl:text>Hungarian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hup'">
            <xsl:text>Hupa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='iba'">
            <xsl:text>Iban</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ibo'">
            <xsl:text>Igbo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ig'">
            <xsl:text>Igbo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ice'">
            <xsl:text>Icelandic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='isl'">
            <xsl:text>Icelandic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='is'">
            <xsl:text>Icelandic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ido'">
            <xsl:text>Ido</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='io'">
            <xsl:text>Ido</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='iii'">
            <xsl:text>Sichuan Yi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ii'">
            <xsl:text>Sichuan Yi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ijo'">
            <xsl:text>Ijo languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='iku'">
            <xsl:text>Inuktitut</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='iu'">
            <xsl:text>Inuktitut</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ile'">
            <xsl:text>Interlingue</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ie'">
            <xsl:text>Interlingue</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ilo'">
            <xsl:text>Iloko</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ina'">
            <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ia'">
            <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='inc'">
            <xsl:text>Indic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ind'">
            <xsl:text>Indonesian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='id'">
            <xsl:text>Indonesian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ine'">
            <xsl:text>Indo-European (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='inh'">
            <xsl:text>Ingush</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ipk'">
            <xsl:text>Inupiaq</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ik'">
            <xsl:text>Inupiaq</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ira'">
            <xsl:text>Iranian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='iro'">
            <xsl:text>Iroquoian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ita'">
            <xsl:text>Italian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='it'">
            <xsl:text>Italian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jav'">
            <xsl:text>Javanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jv'">
            <xsl:text>Javanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jbo'">
            <xsl:text>Lojban</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jpn'">
            <xsl:text>Japanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ja'">
            <xsl:text>Japanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jpr'">
            <xsl:text>Judeo-Persian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='jrb'">
            <xsl:text>Judeo-Arabic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kaa'">
            <xsl:text>Kara-Kalpak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kab'">
            <xsl:text>Kabyle</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kac'">
            <xsl:text>Kachin or Jingpho</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kal'">
            <xsl:text>Kalaallisut or Greenlandic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kl'">
            <xsl:text>Kalaallisut or Greenlandic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kam'">
            <xsl:text>Kamba</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kan'">
            <xsl:text>Kannada</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kn'">
            <xsl:text>Kannada</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kar'">
            <xsl:text>Karen languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kas'">
            <xsl:text>Kashmiri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ks'">
            <xsl:text>Kashmiri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kau'">
            <xsl:text>Kanuri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kr'">
            <xsl:text>Kanuri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kaw'">
            <xsl:text>Kawi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kaz'">
            <xsl:text>Kazakh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kk'">
            <xsl:text>Kazakh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kbd'">
            <xsl:text>Kabardian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kha'">
            <xsl:text>Khasi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='khi'">
            <xsl:text>Khoisan (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='khm'">
            <xsl:text>Central Khmer</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='km'">
            <xsl:text>Central Khmer</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kho'">
            <xsl:text>Khotanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kik'">
            <xsl:text>Kikuyu or Gikuyu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ki'">
            <xsl:text>Kikuyu or Gikuyu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kin'">
            <xsl:text>Kinyarwanda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rw'">
            <xsl:text>Kinyarwanda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kir'">
            <xsl:text>Kirghiz or Kyrgyz</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ky'">
            <xsl:text>Kirghiz or Kyrgyz</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kmb'">
            <xsl:text>Kimbundu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kok'">
            <xsl:text>Konkani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kom'">
            <xsl:text>Komi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kv'">
            <xsl:text>Komi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kon'">
            <xsl:text>Kongo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kg'">
            <xsl:text>Kongo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kor'">
            <xsl:text>Korean</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ko'">
            <xsl:text>Korean</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kos'">
            <xsl:text>Kosraean</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kpe'">
            <xsl:text>Kpelle</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='krc'">
            <xsl:text>Karachay-Balkar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='krl'">
            <xsl:text>Karelian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kro'">
            <xsl:text>Kru languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kru'">
            <xsl:text>Kurukh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kua'">
            <xsl:text>Kuanyama or Kwanyama</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kj'">
            <xsl:text>Kuanyama or Kwanyama</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kum'">
            <xsl:text>Kumyk</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kur'">
            <xsl:text>Kurdish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ku'">
            <xsl:text>Kurdish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='kut'">
            <xsl:text>Kutenai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lad'">
            <xsl:text>Ladino</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lah'">
            <xsl:text>Lahnda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lam'">
            <xsl:text>Lamba</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lao'">
            <xsl:text>Lao</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lo'">
            <xsl:text>Lao</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lat'">
            <xsl:text>Latin</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='la'">
            <xsl:text>Latin</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lav'">
            <xsl:text>Latvian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lv'">
            <xsl:text>Latvian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lez'">
            <xsl:text>Lezghian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lim'">
            <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='li'">
            <xsl:text>Limburgan or Limburger or Limburgish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lin'">
            <xsl:text>Lingala</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ln'">
            <xsl:text>Lingala</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lit'">
            <xsl:text>Lithuanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lt'">
            <xsl:text>Lithuanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lol'">
            <xsl:text>Mongo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='loz'">
            <xsl:text>Lozi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ltz'">
            <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lb'">
            <xsl:text>Luxembourgish or Letzeburgesch</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lua'">
            <xsl:text>Luba-Lulua</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lub'">
            <xsl:text>Luba-Katanga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lu'">
            <xsl:text>Luba-Katanga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lug'">
            <xsl:text>Ganda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lg'">
            <xsl:text>Ganda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lui'">
            <xsl:text>Luiseno</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lun'">
            <xsl:text>Lunda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='luo'">
            <xsl:text>Luo (Kenya and Tanzania)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='lus'">
            <xsl:text>Lushai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mac'">
            <xsl:text>Macedonian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mkd'">
            <xsl:text>Macedonian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mk'">
            <xsl:text>Macedonian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mad'">
            <xsl:text>Madurese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mag'">
            <xsl:text>Magahi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mah'">
            <xsl:text>Marshallese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mh'">
            <xsl:text>Marshallese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mai'">
            <xsl:text>Maithili</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mak'">
            <xsl:text>Makasar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mal'">
            <xsl:text>Malayalam</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ml'">
            <xsl:text>Malayalam</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='man'">
            <xsl:text>Mandingo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mao'">
            <xsl:text>Maori</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mri'">
            <xsl:text>Maori</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mi'">
            <xsl:text>Maori</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='map'">
            <xsl:text>Austronesian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mar'">
            <xsl:text>Marathi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mr'">
            <xsl:text>Marathi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mas'">
            <xsl:text>Masai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='may'">
            <xsl:text>Malay</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='msa'">
            <xsl:text>Malay</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ms'">
            <xsl:text>Malay</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mdf'">
            <xsl:text>Moksha</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mdr'">
            <xsl:text>Mandar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='men'">
            <xsl:text>Mende</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mga'">
            <xsl:text>Irish, Middle (900-1200)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mic'">
            <xsl:text>Mi'kmaq or Micmac</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='min'">
            <xsl:text>Minangkabau</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mis'">
            <xsl:text>Miscellaneous languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mkh'">
            <xsl:text>Mon-Khmer (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mlg'">
            <xsl:text>Malagasy</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mg'">
            <xsl:text>Malagasy</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mlt'">
            <xsl:text>Maltese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mt'">
            <xsl:text>Maltese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mnc'">
            <xsl:text>Manchu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mni'">
            <xsl:text>Manipuri</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mno'">
            <xsl:text>Manobo languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='moh'">
            <xsl:text>Mohawk</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mol'">
            <xsl:text>Moldavian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mo'">
            <xsl:text>Moldavian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mon'">
            <xsl:text>Mongolian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mn'">
            <xsl:text>Mongolian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mos'">
            <xsl:text>Mossi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mun'">
            <xsl:text>Munda languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mus'">
            <xsl:text>Creek</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mwl'">
            <xsl:text>Mirandese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='mwr'">
            <xsl:text>Marwari</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='myn'">
            <xsl:text>Mayan languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='myv'">
            <xsl:text>Erzya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nah'">
            <xsl:text>Nahuatl languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nai'">
            <xsl:text>North American Indian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nap'">
            <xsl:text>Neapolitan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nau'">
            <xsl:text>Nauru</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='na'">
            <xsl:text>Nauru</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nav'">
            <xsl:text>Navajo or Navaho</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nv'">
            <xsl:text>Navajo or Navaho</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nbl'">
            <xsl:text>Ndebele, South or South Ndebele</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nr'">
            <xsl:text>Ndebele, South or South Ndebele</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nde'">
            <xsl:text>Ndebele, North or North Ndebele</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nd'">
            <xsl:text>Ndebele, North or North Ndebele</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ndo'">
            <xsl:text>Ndonga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ng'">
            <xsl:text>Ndonga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nds'">
            <xsl:text>Low German or Low Saxon or German, Low or Saxon, Low</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nep'">
            <xsl:text>Nepali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ne'">
            <xsl:text>Nepali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='new'">
            <xsl:text>Nepal Bhasa or Newari</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nia'">
            <xsl:text>Nias</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nic'">
            <xsl:text>Niger-Kordofanian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='niu'">
            <xsl:text>Niuean</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nno'">
            <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nn'">
            <xsl:text>Norwegian Nynorsk or Nynorsk, Norwegian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nob'">
            <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nb'">
            <xsl:text>Bokm√É¬•l, Norwegian or Norwegian Bokm√É¬•l</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nog'">
            <xsl:text>Nogai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='non'">
            <xsl:text>Norse, Old</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nor'">
            <xsl:text>Norwegian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='no'">
            <xsl:text>Norwegian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nso'">
            <xsl:text>Pedi or Sepedi or Northern Sotho</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nub'">
            <xsl:text>Nubian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nwc'">
            <xsl:text>Classical Newari or Old Newari or Classical Nepal Bhasa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nya'">
            <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ny'">
            <xsl:text>Chichewa or Chewa or Nyanja</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nym'">
            <xsl:text>Nyamwezi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nyn'">
            <xsl:text>Nyankole</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nyo'">
            <xsl:text>Nyoro</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nzi'">
            <xsl:text>Nzima</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oci'">
            <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oc'">
            <xsl:text>Occitan (post 1500) or Proven√É¬ßal</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oji'">
            <xsl:text>Ojibwa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oj'">
            <xsl:text>Ojibwa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ori'">
            <xsl:text>Oriya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='or'">
            <xsl:text>Oriya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='orm'">
            <xsl:text>Oromo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='om'">
            <xsl:text>Oromo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='osa'">
            <xsl:text>Osage</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oss'">
            <xsl:text>Ossetian or Ossetic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='os'">
            <xsl:text>Ossetian or Ossetic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ota'">
            <xsl:text>Turkish, Ottoman (1500-1928)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='oto'">
            <xsl:text>Otomian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='paa'">
            <xsl:text>Papuan (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pag'">
            <xsl:text>Pangasinan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pal'">
            <xsl:text>Pahlavi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pam'">
            <xsl:text>Pampanga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pan'">
            <xsl:text>Panjabi or Punjabi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pa'">
            <xsl:text>Panjabi or Punjabi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pap'">
            <xsl:text>Papiamento</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pau'">
            <xsl:text>Palauan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='peo'">
            <xsl:text>Persian, Old (ca.600-400 B.C.)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='per'">
            <xsl:text>Persian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fas'">
            <xsl:text>Persian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='fa'">
            <xsl:text>Persian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='phi'">
            <xsl:text>Philippine (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='phn'">
            <xsl:text>Phoenician</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pli'">
            <xsl:text>Pali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pi'">
            <xsl:text>Pali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pol'">
            <xsl:text>Polish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pl'">
            <xsl:text>Polish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pon'">
            <xsl:text>Pohnpeian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='por'">
            <xsl:text>Portuguese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pt'">
            <xsl:text>Portuguese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pra'">
            <xsl:text>Prakrit languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pro'">
            <xsl:text>Proven√É¬ßal, Old (to 1500)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='pus'">
            <xsl:text>Pushto</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ps'">
            <xsl:text>Pushto</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='que'">
            <xsl:text>Quechua</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='qu'">
            <xsl:text>Quechua</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='raj'">
            <xsl:text>Rajasthani</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rap'">
            <xsl:text>Rapanui</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rar'">
            <xsl:text>Rarotongan or Cook Islands Maori</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='roa'">
            <xsl:text>Romance (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='roh'">
            <xsl:text>Romansh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rm'">
            <xsl:text>Romansh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rom'">
            <xsl:text>Romany</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rum'">
            <xsl:text>Romanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ron'">
            <xsl:text>Romanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ro'">
            <xsl:text>Romanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='run'">
            <xsl:text>Rundi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rn'">
            <xsl:text>Rundi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rup'">
            <xsl:text>Aromanian or Arumanian or Macedo-Romanian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='rus'">
            <xsl:text>Russian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ru'">
            <xsl:text>Russian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sad'">
            <xsl:text>Sandawe</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sag'">
            <xsl:text>Sango</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sg'">
            <xsl:text>Sango</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sah'">
            <xsl:text>Yakut</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sai'">
            <xsl:text>South American Indian (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sal'">
            <xsl:text>Salishan languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sam'">
            <xsl:text>Samaritan Aramaic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='san'">
            <xsl:text>Sanskrit</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sa'">
            <xsl:text>Sanskrit</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sas'">
            <xsl:text>Sasak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sat'">
            <xsl:text>Santali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='scc'">
            <xsl:text>Serbian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='srp'">
            <xsl:text>Serbian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sr'">
            <xsl:text>Serbian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='scn'">
            <xsl:text>Sicilian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sco'">
            <xsl:text>Scots</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='scr'">
            <xsl:text>Croatian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hrv'">
            <xsl:text>Croatian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='hr'">
            <xsl:text>Croatian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sel'">
            <xsl:text>Selkup</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sem'">
            <xsl:text>Semitic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sga'">
            <xsl:text>Irish, Old (to 900)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sgn'">
            <xsl:text>Sign Languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='shn'">
            <xsl:text>Shan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sid'">
            <xsl:text>Sidamo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sin'">
            <xsl:text>Sinhala or Sinhalese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='si'">
            <xsl:text>Sinhala or Sinhalese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sio'">
            <xsl:text>Siouan languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sit'">
            <xsl:text>Sino-Tibetan (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sla'">
            <xsl:text>Slavic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='slo'">
            <xsl:text>Slovak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='slk'">
            <xsl:text>Slovak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sk'">
            <xsl:text>Slovak</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='slv'">
            <xsl:text>Slovenian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sl'">
            <xsl:text>Slovenian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sma'">
            <xsl:text>Southern Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sme'">
            <xsl:text>Northern Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='se'">
            <xsl:text>Northern Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='smi'">
            <xsl:text>Sami languages (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='smj'">
            <xsl:text>Lule Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='smn'">
            <xsl:text>Inari Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='smo'">
            <xsl:text>Samoan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sm'">
            <xsl:text>Samoan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sms'">
            <xsl:text>Skolt Sami</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sna'">
            <xsl:text>Shona</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sn'">
            <xsl:text>Shona</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='snd'">
            <xsl:text>Sindhi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sd'">
            <xsl:text>Sindhi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='snk'">
            <xsl:text>Soninke</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sog'">
            <xsl:text>Sogdian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='som'">
            <xsl:text>Somali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='so'">
            <xsl:text>Somali</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='son'">
            <xsl:text>Songhai languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sot'">
            <xsl:text>Sotho, Southern</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='st'">
            <xsl:text>Sotho, Southern</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='spa'">
            <xsl:text>Spanish or Castilian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='es'">
            <xsl:text>Spanish or Castilian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='srd'">
            <xsl:text>Sardinian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sc'">
            <xsl:text>Sardinian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='srn'">
            <xsl:text>Sranan Tongo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='srr'">
            <xsl:text>Serer</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ssa'">
            <xsl:text>Nilo-Saharan (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ssw'">
            <xsl:text>Swati</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ss'">
            <xsl:text>Swati</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='suk'">
            <xsl:text>Sukuma</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sun'">
            <xsl:text>Sundanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='su'">
            <xsl:text>Sundanese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sus'">
            <xsl:text>Susu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sux'">
            <xsl:text>Sumerian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='swa'">
            <xsl:text>Swahili</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sw'">
            <xsl:text>Swahili</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='swe'">
            <xsl:text>Swedish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='sv'">
            <xsl:text>Swedish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='syr'">
            <xsl:text>Syriac</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tah'">
            <xsl:text>Tahitian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ty'">
            <xsl:text>Tahitian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tai'">
            <xsl:text>Tai (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tam'">
            <xsl:text>Tamil</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ta'">
            <xsl:text>Tamil</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tat'">
            <xsl:text>Tatar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tt'">
            <xsl:text>Tatar</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tel'">
            <xsl:text>Telugu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='te'">
            <xsl:text>Telugu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tem'">
            <xsl:text>Timne</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ter'">
            <xsl:text>Tereno</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tet'">
            <xsl:text>Tetum</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tgk'">
            <xsl:text>Tajik</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tg'">
            <xsl:text>Tajik</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tgl'">
            <xsl:text>Tagalog</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tl'">
            <xsl:text>Tagalog</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tha'">
            <xsl:text>Thai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='th'">
            <xsl:text>Thai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tib'">
            <xsl:text>Tibetan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bod'">
            <xsl:text>Tibetan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='bo'">
            <xsl:text>Tibetan</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tig'">
            <xsl:text>Tigre</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tir'">
            <xsl:text>Tigrinya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ti'">
            <xsl:text>Tigrinya</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tiv'">
            <xsl:text>Tiv</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tkl'">
            <xsl:text>Tokelau</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tlh'">
            <xsl:text>Klingon or tlhIngan-Hol</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tli'">
            <xsl:text>Tlingit</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tmh'">
            <xsl:text>Tamashek</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tog'">
            <xsl:text>Tonga (Nyasa)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ton'">
            <xsl:text>Tonga (Tonga Islands)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='to'">
            <xsl:text>Tonga (Tonga Islands)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tpi'">
            <xsl:text>Tok Pisin</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tsi'">
            <xsl:text>Tsimshian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tsn'">
            <xsl:text>Tswana</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tn'">
            <xsl:text>Tswana</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tso'">
            <xsl:text>Tsonga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ts'">
            <xsl:text>Tsonga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tuk'">
            <xsl:text>Turkmen</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tk'">
            <xsl:text>Turkmen</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tum'">
            <xsl:text>Tumbuka</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tup'">
            <xsl:text>Tupi languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tur'">
            <xsl:text>Turkish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tr'">
            <xsl:text>Turkish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tut'">
            <xsl:text>Altaic (Other)</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tvl'">
            <xsl:text>Tuvalu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='twi'">
            <xsl:text>Twi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tw'">
            <xsl:text>Twi</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='tyv'">
            <xsl:text>Tuvinian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='udm'">
            <xsl:text>Udmurt</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='uga'">
            <xsl:text>Ugaritic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='uig'">
            <xsl:text>Uighur or Uyghur</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ug'">
            <xsl:text>Uighur or Uyghur</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ukr'">
            <xsl:text>Ukrainian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='uk'">
            <xsl:text>Ukrainian</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='umb'">
            <xsl:text>Umbundu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='und'">
            <xsl:text>Undetermined</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='urd'">
            <xsl:text>Urdu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ur'">
            <xsl:text>Urdu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='uzb'">
            <xsl:text>Uzbek</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='uz'">
            <xsl:text>Uzbek</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vai'">
            <xsl:text>Vai</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ven'">
            <xsl:text>Venda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ve'">
            <xsl:text>Venda</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vie'">
            <xsl:text>Vietnamese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vi'">
            <xsl:text>Vietnamese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vol'">
            <xsl:text>Volap√É¬ºk</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vo'">
            <xsl:text>Volap√É¬ºk</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='vot'">
            <xsl:text>Votic</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wak'">
            <xsl:text>Wakashan languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wal'">
            <xsl:text>Walamo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='war'">
            <xsl:text>Waray</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='was'">
            <xsl:text>Washo</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wel'">
            <xsl:text>Welsh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cym'">
            <xsl:text>Welsh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='cy'">
            <xsl:text>Welsh</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wen'">
            <xsl:text>Sorbian languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wln'">
            <xsl:text>Walloon</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wa'">
            <xsl:text>Walloon</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wol'">
            <xsl:text>Wolof</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='wo'">
            <xsl:text>Wolof</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='xal'">
            <xsl:text>Kalmyk or Oirat</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='xho'">
            <xsl:text>Xhosa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='xh'">
            <xsl:text>Xhosa</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yao'">
            <xsl:text>Yao</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yap'">
            <xsl:text>Yapese</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yid'">
            <xsl:text>Yiddish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yi'">
            <xsl:text>Yiddish</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yor'">
            <xsl:text>Yoruba</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='yo'">
            <xsl:text>Yoruba</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='ypk'">
            <xsl:text>Yupik languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zap'">
            <xsl:text>Zapotec</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zen'">
            <xsl:text>Zenaga</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zha'">
            <xsl:text>Zhuang or Chuang</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='za'">
            <xsl:text>Zhuang or Chuang</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='znd'">
            <xsl:text>Zande languages</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zul'">
            <xsl:text>Zulu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zu'">
            <xsl:text>Zulu</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zun'">
            <xsl:text>Zuni</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zxx'">
            <xsl:text>No linguistic content</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='nqo'">
            <xsl:text>N'Ko</xsl:text>
         </xsl:when>
         <xsl:when test="@langcode='zza'">
            <xsl:text>Zaza or Dimili or Dimli or Kirdki or Kirmanjki or Zazaki</xsl:text>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ead:materialspec[ancestor::ead:dsc]">
      <p>
         <xsl:text>Material-specific details: </xsl:text>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template match="ead:unitid[ancestor::ead:dsc]">
      <xsl:choose>
         <xsl:when test="@type">
            <p>
               <xsl:value-of select="./@type"/>
               <xsl:text>: </xsl:text>
               <xsl:apply-templates/>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <p>
               <xsl:text>Identifier: </xsl:text>
               <xsl:apply-templates/>
            </p>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>
   <xsl:template match="ead:odd[ancestor::ead:dsc]">
      <p>
         <xsl:text>General note: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:note[ancestor::ead:dsc]">
      <p>
         <xsl:text>General note: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:accessrestrict[ancestor::ead:dsc]">
      <p class="access-label">
         <a href="#">
            <xsl:text>Access Note </xsl:text><span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
         </a>
      </p>
      <div class="access-note">
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
      </div>
   </xsl:template>
   <xsl:template match="ead:userestrict[ancestor::ead:dsc]">
      <p>
         <xsl:text>Restrictions on Use and Copyright Information: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:phystech[ancestor::ead:dsc]">
      <p>
         <xsl:text>Physical Characteristics and Technical Requirements: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:otherfindaid[ancestor::ead:dsc]">
      <p>
         <xsl:text>Other Finding Aid(s): </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:custodhist[ancestor::ead:dsc]">
      <p>
         <xsl:text>Custodial History: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:acqinfo[ancestor::ead:dsc]">
      <p>
         <xsl:text>Provenance and Acquisition: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:appraisal[ancestor::ead:dsc]">
      <p>
         <xsl:text>Appraisal: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:accruals[ancestor::ead:dsc]">
      <p>
         <xsl:text>Accruals: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:originalsloc[ancestor::ead:dsc]">
      <p>
         <xsl:text>Location of Originals: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:altformavail[ancestor::ead:dsc]">
      <p>
         <xsl:text>Location of Copies or Alternate Formats: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:relatedmaterial[ancestor::ead:dsc]">
      <p>
         <xsl:text>Related Materials: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:bibliography[ancestor::ead:dsc]">

      <p>
         <xsl:text>Bibliography: </xsl:text>
      </p>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="ead:separatedmaterial[ancestor::ead:dsc]">
      <p>
         <xsl:text>Separated Material: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>

   <xsl:template match="ead:scopecontent[ancestor::ead:dsc]">
      <p>
         <xsl:text>Description: </xsl:text>
      </p>
      <xsl:apply-templates select="ead:p[position()=1]"/>

      <xsl:apply-templates select="ead:p[position()>1]"/>
   </xsl:template>
   <xsl:template match="ead:arrangement[ancestor::ead:dsc]">
      <p>
         <xsl:text>Arrangement: </xsl:text>
      </p>
      <xsl:apply-templates/>

   </xsl:template>

   <!-- generic lists ====================================================== -->

   <xsl:template match="ead:chronlist">
      <h5>
         <!--<xsl:apply-templates select="ead:head"/>-->
         <xsl:text>Chronology</xsl:text>
      </h5>
      <ol class="chronlist">
         <xsl:for-each select="ead:chronitem">
            <li>
               <span class="boldunderline">
                  <xsl:apply-templates select="ead:date"/>
               </span>
               <xsl:text>: </xsl:text>
               <xsl:apply-templates select="child::ead:event"/>
               <xsl:for-each select="ead:eventgrp">
                  <ul class="normalIndent">
                     <xsl:for-each select="child::ead:event">
                        <li>
                           <xsl:apply-templates select="current()"/>
                        </li>
                     </xsl:for-each>
                  </ul>
               </xsl:for-each>
            </li>
         </xsl:for-each>
      </ol>
   </xsl:template>

   <xsl:template match="ead:list[@type='simple' or not(@type)]">
      <!-- take care of the head first -->
      <!--        <xsl:if test="ead:head">
            <xsl:choose>
                <xsl:when test="ancestor::ead:p">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="ead:head"/>
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <h5>
                        <xsl:apply-templates select="ead:head"/>
                    </h5>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>-->
      <!-- then the list items -->
      <xsl:choose>
         <xsl:when test="ancestor::ead:p">
            <xsl:for-each select="ead:item[position() != last()]">
               <xsl:apply-templates/>
               <xsl:text>, </xsl:text>
            </xsl:for-each>
            <xsl:apply-templates select="ead:item[position() = last()]"/>
         </xsl:when>
         <xsl:otherwise>
            <ul class="normalIndent">
               <xsl:for-each select="ead:item">
                  <xsl:choose>
                     <xsl:when test="exists(ead:ref/@altrender)">
                        <!-- Applies to list items with references (under ead:arrangement, for ex.).
                             Could do more here with grouping to make nested lists, etc.
                             for now we'll just use margins to make the semantics visually
                             clear
                        -->
                        <xsl:if test="ead:ref[@altrender='series'] | ead:ref[@altrender='subgrp']">
                           <li class="arrangementSeries">
                              <a href="{concat('#', ead:ref/@target)}">
                                 <xsl:apply-templates select="ead:ref/ead:unittitle"/>
                                 <xsl:for-each select="ead:ref/ead:unitdate">
                                    <xsl:text>, </xsl:text>
                                    <!-- RH: add "bulk" for @type='bulk' -->
                                    <xsl:if test="@type='bulk'">
                                       <xsl:text>bulk </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="current()"/>
                                 </xsl:for-each>
                              </a>
                           </li>
                        </xsl:if>
                        <xsl:if test="ead:ref[@altrender='subseries']">
                           <li class="arrangementSubseries">
                              <a href="{concat('#', ead:ref/@target)}">
                                 <xsl:apply-templates select="ead:ref/ead:unittitle"/>
                                 <xsl:for-each select="ead:ref/ead:unitdate">
                                    <xsl:text>, </xsl:text>
                                    <!-- RH: add "bulk" for @type='bulk' -->
                                    <xsl:if test="@type='bulk'">
                                       <xsl:text>bulk </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="current()"/>
                                 </xsl:for-each>
                              </a>
                           </li>
                        </xsl:if>
                     </xsl:when>
                     <xsl:otherwise>
                        <li class="normal">
                           <xsl:apply-templates/>
                        </li>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
            </ul>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--there might not be any of these... -->
   <xsl:template match="ead:list[@type='ordered']">
      <xsl:choose>
         <xsl:when test="ancestor::ead:p">
            <xsl:for-each select="ead:item[position() != last()]">
               <xsl:apply-templates/>
               <xsl:text>, </xsl:text>
            </xsl:for-each>
            <xsl:apply-templates select="ead:item[position() = last()]"/>
         </xsl:when>
         <xsl:otherwise>
            <ol>
               <xsl:for-each select="ead:item">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ol>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- RH: add support for bibref -->
   <xsl:template match="ead:bibref">
      <xsl:for-each select=".">
         <xsl:apply-templates/>
         <br/>
      </xsl:for-each>
   </xsl:template>



   <xsl:template match="ead:p" mode="#all">
      <p>
         <xsl:if
            test="parent::ead:dsc//ead:accessrestrict|parent::ead:dsc//ead:userestrict|
                parent::ead:dsc//ead:phystech|parent::ead:dsc//ead:otherfindaid|parent::ead:dsc//ead:custodhist|
                parent::ead:dsc//ead:acqinfo|parent::ead:dsc//ead:appraisal|parent::ead:dsc//ead:accruals|
                parent::ead:dsc//ead:originalsloc|parent::ead:dsc//ead:altformavail|
                parent::ead:dsc//ead:relatedmaterial|parent::ead:dsc//ead:bibliography|parent::ead:dsc//ead:processinfo|
                parent::ead:dsc//ead:separatedmaterial">
            <xsl:attribute name="class" select="'normalIndent'"/>
         </xsl:if>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="ead:extref">
      <a href="{@xlink:href}">
         <xsl:apply-templates/>
      </a>
   </xsl:template>


   <!-- skip over these -->

   <xsl:template match="ead:emph[@render='italic']|ead:title[@render='italic']">
      <span class="italic">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="ead:emph[@render='bold']|ead:title[@render='bold']">
      <span class="bold">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="ead:emph[@render='underline']|ead:title[@render='underline']">
      <span class="underline">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="ead:emph[@render='boldunderline']|ead:title[@render='boldunderline']">
      <span class="bolditalic">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="ead:emph[@render='super']">
      <sup>
         <xsl:apply-templates/>
      </sup>
   </xsl:template>

   <xsl:template match="ead:emph[@render='sub']">
      <sub>
         <xsl:apply-templates/>
      </sub>
   </xsl:template>

   <xsl:template match="ead:blockquote">
      <blockquote>
         <xsl:apply-templates/>
      </blockquote>
   </xsl:template>

   <xsl:template match="ead:lb">
      <br>
         <xsl:apply-templates/>
      </br>
   </xsl:template>

</xsl:stylesheet>