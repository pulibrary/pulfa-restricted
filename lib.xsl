<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lib="http://findingaids.princeton.edu/pulfa/2/lib" xmlns:eac="urn:isbn:1-931666-33-4"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <!--+
        | Capitalizes the string passed as the only param. 
        +-->
   <xsl:function name="lib:capitalize-first" as="xs:string">
      <xsl:param name="string" as="xs:string"/>
      <xsl:variable name="first" select="upper-case(substring($string,1, 1))" as="xs:string"/>
      <xsl:variable name="rest" select="substring($string, 2)" as="xs:string"/>
      <xsl:value-of select="concat($first, $rest)"/>
   </xsl:function>

   <!--+
        | Capitalizes each word the string passed as the onll param.
        +-->
   <xsl:function name="lib:capitalize-each" as="xs:string">
      <xsl:param name="string" as="xs:string"/>
      <xsl:value-of>
         <xsl:for-each select="tokenize($string, ' ')">
            <xsl:value-of select="concat(lib:capitalize-first(.), ' ')"/>
         </xsl:for-each>
      </xsl:value-of>
   </xsl:function>

   <xsl:function name="lib:normalize-subject-heading" as="xs:string">
      <xsl:param name="input-heading" as="item()"/>
      <xsl:variable name="no-stop" as="xs:string"
         select="if (not(matches($input-heading, '\p{Lu}\.$'))) then lib:strip-stop($input-heading) else $input-heading"/>
      <xsl:value-of select="replace($no-stop, '\s?(\-{2}|–)\s?', '--')"/>
   </xsl:function>

   <xsl:function name="lib:strip-punctuation">
      <xsl:param name="input" as="item()"/>
      <xsl:value-of select="normalize-space(replace($input, '\p{P}+', ' '))"/>
   </xsl:function>

   <!--+
      | Strip any trailing punctuation or spaces. Be careful with this: it
      | doesn't know abbreviations. Trailing quotes (",',’, ”) are kept.
      +-->
   <xsl:function name="lib:strip-stop" as="xs:string?">
      <xsl:param name="string" as="xs:string"/>
      <xsl:variable name="normalized" select="normalize-space($string)"/>
      <xsl:choose>
         <xsl:when test="ends-with($normalized, '.')">
            <xsl:value-of select="substring($normalized, 1, string-length($normalized) - 1)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$normalized"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="lib:escape-email" as="xs:string">
      <xsl:param name="addy"/>
      <xsl:value-of select="replace(replace($addy, '@', ' [at] '), '\.', ' [dot] ')"/>
   </xsl:function>

   <xsl:function name="lib:repo-code-to-label" as="xs:string?">
      <xsl:param name="code" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$code eq 'eng'">Technical and Scientific Reports</xsl:when>
         <xsl:when test="$code eq 'lae'">Latin American Ephemera Collections</xsl:when>
         <xsl:when test="$code eq 'mss'">Manuscripts Division</xsl:when>
         <xsl:when test="$code eq 'publicpolicy'">Public Policy Papers</xsl:when>
         <xsl:when test="$code eq 'univarchives'">Princeton University Archives</xsl:when>
         <xsl:when test="$code eq 'rarebooks'">Rare Book Division</xsl:when>
         <xsl:when test="$code eq 'ga'">Graphic Arts Collection</xsl:when>
      </xsl:choose>
   </xsl:function>
   
   
   <xsl:function name="lib:repo-code-to-citation" as="xs:string?">
      <xsl:param name="code" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$code eq 'eng'">Technical and Scientific Reports, Engineering Library</xsl:when>
         <xsl:when test="$code eq 'lae'">Latin American Ephemera Collections</xsl:when>
         <xsl:when test="$code eq 'mss'">Manuscripts Division, Department of Rare Books and Special Collections</xsl:when>
         <xsl:when test="$code eq 'publicpolicy'">Public Policy Papers, Department of Rare Books and Special Collections</xsl:when>
         <xsl:when test="$code eq 'univarchives'">Princeton University Archives, Department of Rare Books and Special Collections</xsl:when>
         <xsl:when test="$code eq 'rarebooks'">Rare Book Division, Department of Rare Books and Special Collections</xsl:when>
         <xsl:when test="$code eq 'ga'">Graphic Arts Collection, Department of Rare Books and Special Collections</xsl:when>
      </xsl:choose>
   </xsl:function>
   

   <xsl:function name="lib:physloc-repo-to-route" as="xs:string?">
      <xsl:param name="code" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$code eq 'eng'">Engineering Library</xsl:when>
         <xsl:when test="$code eq 'lae'">RBSC</xsl:when>
         <xsl:when test="$code eq 'mss'">RBSC</xsl:when>
         <xsl:when test="$code eq 'rarebooks'">RBSC</xsl:when>
         <xsl:when test="$code eq 'ga'">RBSC</xsl:when>
         <xsl:when test="$code eq 'publicpolicy'">MUDD</xsl:when>
         <xsl:when test="$code eq 'univarchives'">MUDD</xsl:when>
      </xsl:choose>
   </xsl:function>


   <xsl:function name="lib:physloc-code-to-label" as="xs:string?">
      <xsl:param name="code" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$code eq 'ctsn'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'ex'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'gax'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'ga'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'mss'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'njpg'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'thx'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'wa'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'hsvc'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'hsvg'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'hsvm'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'hsvr'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'mudd'">Mudd Manuscript Library</xsl:when>
         <xsl:when test="$code eq 'rcppa'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcppf'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcpph'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcpxc'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcpxg'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcpxm'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'rcpxr'">ReCAP</xsl:when>
         <xsl:when test="$code eq 'flm'">Firestone Library</xsl:when>
         <xsl:when test="$code eq 'st'">Engineering Library</xsl:when>
         <xsl:when test="$code eq 'anxb'">Annex B</xsl:when>
         <xsl:when test="$code eq 'ppl'">Plasma Physics Library</xsl:when>
      </xsl:choose>
   </xsl:function>

   <!-- This lives here because it uses the date* templates. Should probably be a regular match template -->
   <!-- RH on 10/31/2013: changed useDates to existDates for display -->
   <xsl:function name="lib:format-eac-name" as="xs:string">
      <xsl:param name="nameEntry" as="element()"/>
      <xsl:variable name="value">
         <xsl:value-of>
            <xsl:value-of select="$nameEntry/eac:part"/>
            <xsl:choose>
               <xsl:when test="$nameEntry/ancestor::eac:identity/following-sibling::eac:description/eac:existDates/eac:dateRange">
                  <xsl:text>, </xsl:text>
                  <xsl:apply-templates select="$nameEntry/../following-sibling::eac:description/eac:existDates/eac:dateRange" mode="string"/>
               </xsl:when>
               <xsl:when test="$nameEntry/ancestor::eac:identity/following-sibling::eac:description/eac:existDates/eac:date">
                  <xsl:text>, </xsl:text>
                  <xsl:apply-templates select="$nameEntry/ancestor::eac:identity/following-sibling::eac:description/eac:existDates/eac:date" mode="string"/>
               </xsl:when>
               <!--+
                   | No support for dateSet wrt names yet..not sure how it would be used.
                   | http://www3.iath.virginia.edu/eac/cpf/tagLibrary/cpfTagLibrary.html#d1e2484
                   +-->
            </xsl:choose>
         </xsl:value-of>
      </xsl:variable>
      <xsl:choose>
         <!-- no trailing stop if we end with punctuation -->
         <xsl:when test="matches($value, '\p{P}$')">
            <xsl:value-of select="normalize-space($value)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat(normalize-space($value), '.')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!--   
      Using this to matches a date plus (optionally) B.C. or A.D.:
      \d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?
      
      Still need a list for unspecified starting or ending date 
      (occurs only for geological periods):
      
      Devonian
      Jurassic
   -->
   <xsl:function name="lib:is-date-subdivision" as="xs:boolean">
      <xsl:param name="token" as="xs:string"/>
      <xsl:variable name="token" as="xs:string" select="normalize-space($token)"/>
      <xsl:choose>
         <!--+
             | Unspecified starting date:
             | To 400
             | To 1800
             | To 333 B.C.
             +-->
         <xsl:when test="matches($token,'^[Tt]o\s\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <!--+
             | Unspecified ending AND Single date without explanatory words:
             | 1989-
             | 1929
             +-->
         <xsl:when test="matches($token,'^\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?\-?$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <!--+
             | Specific century or centuries:
             | 17th century
             | 15th-18th centuries
             +-->
         <xsl:when test="matches($token,'^(\d{1,2}[snrt][tdh][-\s]){1,2}[cC]entur(y|ies)$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <!--+
             | Specific date spans with explanatory words:
             | Renaissance, 1450-1600
             | George V, 1910-1936
             +-->
         <xsl:when test="matches($token,'^.+,\s\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?\s?\-?\s?\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <!--+
             | Specific date spans without explanatory words:
             | 500-1400
             | 1789-1945
             | 221 B.C.-960 A.D.
             +-->
         <xsl:when test="matches($token,'^\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?\s?\-?\s?\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <!--+
             | Single date with explanatory words:
             | Edward VIII, 1936
             | American Invasion, 1989
             +-->
         <xsl:when test="matches($token,'^.+,\s\d{1,4}((\s[Bb]\.[Cc]\.)|(\s[Aa]\.[Dd]\.))?$')">
            <xsl:value-of select="true()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="false()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="lib:lang-code-to-label" as="xs:string?">
      <xsl:param name="lang" as="xs:string?"/>
      <xsl:choose>
         <xsl:when test="not($lang)"/>
         <xsl:when test="$lang eq 'aar'">Afar</xsl:when>
         <xsl:when test="$lang eq 'aa'">Afar</xsl:when>
         <xsl:when test="$lang eq 'abk'">Abkhazian</xsl:when>
         <xsl:when test="$lang eq 'ab'">Abkhazian</xsl:when>
         <xsl:when test="$lang eq 'ace'">Achinese</xsl:when>
         <xsl:when test="$lang eq 'ach'">Acoli</xsl:when>
         <xsl:when test="$lang eq 'ada'">Adangme</xsl:when>
         <xsl:when test="$lang eq 'ady'">Adyghe or Adygei</xsl:when>
         <xsl:when test="$lang eq 'afa'">Afro-Asiatic (Other)</xsl:when>
         <xsl:when test="$lang eq 'afh'">Afrihili</xsl:when>
         <xsl:when test="$lang eq 'afr'">Afrikaans</xsl:when>
         <xsl:when test="$lang eq 'af'">Afrikaans</xsl:when>
         <xsl:when test="$lang eq 'ain'">Ainu</xsl:when>
         <xsl:when test="$lang eq 'aka'">Akan</xsl:when>
         <xsl:when test="$lang eq 'ak'">Akan</xsl:when>
         <xsl:when test="$lang eq 'akk'">Akkadian</xsl:when>
         <xsl:when test="$lang eq 'alb'">Albanian</xsl:when>
         <xsl:when test="$lang eq 'sqi'">Albanian</xsl:when>
         <xsl:when test="$lang eq 'sq'">Albanian</xsl:when>
         <xsl:when test="$lang eq 'ale'">Aleut</xsl:when>
         <xsl:when test="$lang eq 'alg'">Algonquian languages</xsl:when>
         <xsl:when test="$lang eq 'alt'">Southern Altai</xsl:when>
         <xsl:when test="$lang eq 'amh'">Amharic</xsl:when>
         <xsl:when test="$lang eq 'am'">Amharic</xsl:when>
         <xsl:when test="$lang eq 'ang'">English, Old (ca.450-1100)</xsl:when>
         <xsl:when test="$lang eq 'anp'">Angika</xsl:when>
         <xsl:when test="$lang eq 'apa'">Apache languages</xsl:when>
         <xsl:when test="$lang eq 'ara'">Arabic</xsl:when>
         <xsl:when test="$lang eq 'ar'">Arabic</xsl:when>
         <xsl:when test="$lang eq 'arc'">Aramaic</xsl:when>
         <xsl:when test="$lang eq 'arg'">Aragonese</xsl:when>
         <xsl:when test="$lang eq 'an'">Aragonese</xsl:when>
         <xsl:when test="$lang eq 'arm'">Armenian</xsl:when>
         <xsl:when test="$lang eq 'hye'">Armenian</xsl:when>
         <xsl:when test="$lang eq 'hy'">Armenian</xsl:when>
         <xsl:when test="$lang eq 'arn'">Mapudungun or Mapuche</xsl:when>
         <xsl:when test="$lang eq 'arp'">Arapaho</xsl:when>
         <xsl:when test="$lang eq 'art'">Artificial (Other)</xsl:when>
         <xsl:when test="$lang eq 'arw'">Arawak</xsl:when>
         <xsl:when test="$lang eq 'asm'">Assamese</xsl:when>
         <xsl:when test="$lang eq 'as'">Assamese</xsl:when>
         <xsl:when test="$lang eq 'ast'">Asturian or Bable</xsl:when>
         <xsl:when test="$lang eq 'ath'">Athapascan languages</xsl:when>
         <xsl:when test="$lang eq 'aus'">Australian languages</xsl:when>
         <xsl:when test="$lang eq 'ava'">Avaric</xsl:when>
         <xsl:when test="$lang eq 'av'">Avaric</xsl:when>
         <xsl:when test="$lang eq 'ave'">Avestan</xsl:when>
         <xsl:when test="$lang eq 'ae'">Avestan</xsl:when>
         <xsl:when test="$lang eq 'awa'">Awadhi</xsl:when>
         <xsl:when test="$lang eq 'aym'">Aymara</xsl:when>
         <xsl:when test="$lang eq 'ay'">Aymara</xsl:when>
         <xsl:when test="$lang eq 'aze'">Azerbaijani</xsl:when>
         <xsl:when test="$lang eq 'az'">Azerbaijani</xsl:when>
         <xsl:when test="$lang eq 'bad'">Banda languages</xsl:when>
         <xsl:when test="$lang eq 'bai'">Bamileke languages</xsl:when>
         <xsl:when test="$lang eq 'bak'">Bashkir</xsl:when>
         <xsl:when test="$lang eq 'ba'">Bashkir</xsl:when>
         <xsl:when test="$lang eq 'bal'">Baluchi</xsl:when>
         <xsl:when test="$lang eq 'bam'">Bambara</xsl:when>
         <xsl:when test="$lang eq 'bm'">Bambara</xsl:when>
         <xsl:when test="$lang eq 'ban'">Balinese</xsl:when>
         <xsl:when test="$lang eq 'baq'">Basque</xsl:when>
         <xsl:when test="$lang eq 'eus'">Basque</xsl:when>
         <xsl:when test="$lang eq 'eu'">Basque</xsl:when>
         <xsl:when test="$lang eq 'bas'">Basa</xsl:when>
         <xsl:when test="$lang eq 'bat'">Baltic (Other)</xsl:when>
         <xsl:when test="$lang eq 'bej'">Beja</xsl:when>
         <xsl:when test="$lang eq 'bel'">Belarusian</xsl:when>
         <xsl:when test="$lang eq 'be'">Belarusian</xsl:when>
         <xsl:when test="$lang eq 'bem'">Bemba</xsl:when>
         <xsl:when test="$lang eq 'ben'">Bengali</xsl:when>
         <xsl:when test="$lang eq 'bn'">Bengali</xsl:when>
         <xsl:when test="$lang eq 'ber'">Berber (Other)</xsl:when>
         <xsl:when test="$lang eq 'bho'">Bhojpuri</xsl:when>
         <xsl:when test="$lang eq 'bih'">Bihari</xsl:when>
         <xsl:when test="$lang eq 'bh'">Bihari</xsl:when>
         <xsl:when test="$lang eq 'bik'">Bikol</xsl:when>
         <xsl:when test="$lang eq 'bin'">Bini or Edo</xsl:when>
         <xsl:when test="$lang eq 'bis'">Bislama</xsl:when>
         <xsl:when test="$lang eq 'bi'">Bislama</xsl:when>
         <xsl:when test="$lang eq 'bla'">Siksika</xsl:when>
         <xsl:when test="$lang eq 'bnt'">Bantu (Other)</xsl:when>
         <xsl:when test="$lang eq 'bos'">Bosnian</xsl:when>
         <xsl:when test="$lang eq 'bs'">Bosnian</xsl:when>
         <xsl:when test="$lang eq 'bra'">Braj</xsl:when>
         <xsl:when test="$lang eq 'bre'">Breton</xsl:when>
         <xsl:when test="$lang eq 'br'">Breton</xsl:when>
         <xsl:when test="$lang eq 'btk'">Batak languages</xsl:when>
         <xsl:when test="$lang eq 'bua'">Buriat</xsl:when>
         <xsl:when test="$lang eq 'bug'">Buginese</xsl:when>
         <xsl:when test="$lang eq 'bul'">Bulgarian</xsl:when>
         <xsl:when test="$lang eq 'bg'">Bulgarian</xsl:when>
         <xsl:when test="$lang eq 'bur'">Burmese</xsl:when>
         <xsl:when test="$lang eq 'mya'">Burmese</xsl:when>
         <xsl:when test="$lang eq 'my'">Burmese</xsl:when>
         <xsl:when test="$lang eq 'byn'">Blin or Bilin</xsl:when>
         <xsl:when test="$lang eq 'cad'">Caddo</xsl:when>
         <xsl:when test="$lang eq 'cai'">Central American Indian (Other)</xsl:when>
         <xsl:when test="$lang eq 'car'">Galibi Carib</xsl:when>
         <xsl:when test="$lang eq 'cat'">Catalan or Valencian</xsl:when>
         <xsl:when test="$lang eq 'ca'">Catalan or Valencian</xsl:when>
         <xsl:when test="$lang eq 'cau'">Caucasian (Other)</xsl:when>
         <xsl:when test="$lang eq 'ceb'">Cebuano</xsl:when>
         <xsl:when test="$lang eq 'cel'">Celtic (Other)</xsl:when>
         <xsl:when test="$lang eq 'cha'">Chamorro</xsl:when>
         <xsl:when test="$lang eq 'ch'">Chamorro</xsl:when>
         <xsl:when test="$lang eq 'chb'">Chibcha</xsl:when>
         <xsl:when test="$lang eq 'che'">Chechen</xsl:when>
         <xsl:when test="$lang eq 'ce'">Chechen</xsl:when>
         <xsl:when test="$lang eq 'chg'">Chagatai</xsl:when>
         <xsl:when test="$lang eq 'chi'">Chinese</xsl:when>
         <xsl:when test="$lang eq 'zho'">Chinese</xsl:when>
         <xsl:when test="$lang eq 'zh'">Chinese</xsl:when>
         <xsl:when test="$lang eq 'chk'">Chuukese</xsl:when>
         <xsl:when test="$lang eq 'chm'">Mari</xsl:when>
         <xsl:when test="$lang eq 'chn'">Chinook jargon</xsl:when>
         <xsl:when test="$lang eq 'cho'">Choctaw</xsl:when>
         <xsl:when test="$lang eq 'chp'">Chipewyan</xsl:when>
         <xsl:when test="$lang eq 'chr'">Cherokee</xsl:when>
         <xsl:when test="$lang eq 'chu'">Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:when>
         <xsl:when test="$lang eq 'cu'">Church Slavic or Old Slavonic or Church Slavonic or Old Bulgarian or Old Church Slavonic</xsl:when>
         <xsl:when test="$lang eq 'chv'">Chuvash</xsl:when>
         <xsl:when test="$lang eq 'cv'">Chuvash</xsl:when>
         <xsl:when test="$lang eq 'chy'">Cheyenne</xsl:when>
         <xsl:when test="$lang eq 'cmc'">Chamic languages</xsl:when>
         <xsl:when test="$lang eq 'cop'">Coptic</xsl:when>
         <xsl:when test="$lang eq 'cor'">Cornish</xsl:when>
         <xsl:when test="$lang eq 'kw'">Cornish</xsl:when>
         <xsl:when test="$lang eq 'cos'">Corsican</xsl:when>
         <xsl:when test="$lang eq 'co'">Corsican</xsl:when>
         <xsl:when test="$lang eq 'cpe'">Creoles and pidgins, English based (Other)</xsl:when>
         <xsl:when test="$lang eq 'cpf'">Creoles and pidgins, French-based (Other)</xsl:when>
         <xsl:when test="$lang eq 'cpp'">Creoles and pidgins, Portuguese-based (Other)</xsl:when>
         <xsl:when test="$lang eq 'cre'">Cree</xsl:when>
         <xsl:when test="$lang eq 'cr'">Cree</xsl:when>
         <xsl:when test="$lang eq 'crh'">Crimean Tatar or Crimean Turkish</xsl:when>
         <xsl:when test="$lang eq 'crp'">Creoles and pidgins (Other)</xsl:when>
         <xsl:when test="$lang eq 'csb'">Kashubian</xsl:when>
         <xsl:when test="$lang eq 'cus'">Cushitic (Other)</xsl:when>
         <xsl:when test="$lang eq 'cze'">Czech</xsl:when>
         <xsl:when test="$lang eq 'ces'">Czech</xsl:when>
         <xsl:when test="$lang eq 'cs'">Czech</xsl:when>
         <xsl:when test="$lang eq 'dak'">Dakota</xsl:when>
         <xsl:when test="$lang eq 'dan'">Danish</xsl:when>
         <xsl:when test="$lang eq 'da'">Danish</xsl:when>
         <xsl:when test="$lang eq 'dar'">Dargwa</xsl:when>
         <xsl:when test="$lang eq 'day'">Land Dayak languages</xsl:when>
         <xsl:when test="$lang eq 'del'">Delaware</xsl:when>
         <xsl:when test="$lang eq 'den'">Slave (Athapascan)</xsl:when>
         <xsl:when test="$lang eq 'dgr'">Dogrib</xsl:when>
         <xsl:when test="$lang eq 'din'">Dinka</xsl:when>
         <xsl:when test="$lang eq 'div'">Divehi or Dhivehi or Maldivian</xsl:when>
         <xsl:when test="$lang eq 'dv'">Divehi or Dhivehi or Maldivian</xsl:when>
         <xsl:when test="$lang eq 'doi'">Dogri</xsl:when>
         <xsl:when test="$lang eq 'dra'">Dravidian (Other)</xsl:when>
         <xsl:when test="$lang eq 'dsb'">Lower Sorbian</xsl:when>
         <xsl:when test="$lang eq 'dua'">Duala</xsl:when>
         <xsl:when test="$lang eq 'dum'">Dutch, Middle (ca.1050-1350)</xsl:when>
         <xsl:when test="$lang eq 'dut'">Dutch or Flemish</xsl:when>
         <xsl:when test="$lang eq 'nld'">Dutch or Flemish</xsl:when>
         <xsl:when test="$lang eq 'nl'">Dutch or Flemish</xsl:when>
         <xsl:when test="$lang eq 'dyu'">Dyula</xsl:when>
         <xsl:when test="$lang eq 'dzo'">Dzongkha</xsl:when>
         <xsl:when test="$lang eq 'dz'">Dzongkha</xsl:when>
         <xsl:when test="$lang eq 'efi'">Efik</xsl:when>
         <xsl:when test="$lang eq 'egy'">Egyptian (Ancient)</xsl:when>
         <xsl:when test="$lang eq 'eka'">Ekajuk</xsl:when>
         <xsl:when test="$lang eq 'elx'">Elamite</xsl:when>
         <xsl:when test="$lang eq 'eng'">English</xsl:when>
         <xsl:when test="$lang eq 'en'">English</xsl:when>
         <xsl:when test="$lang eq 'enm'">English, Middle (1100-1500)</xsl:when>
         <xsl:when test="$lang eq 'epo'">Esperanto</xsl:when>
         <xsl:when test="$lang eq 'eo'">Esperanto</xsl:when>
         <xsl:when test="$lang eq 'est'">Estonian</xsl:when>
         <xsl:when test="$lang eq 'et'">Estonian</xsl:when>
         <xsl:when test="$lang eq 'ewe'">Ewe</xsl:when>
         <xsl:when test="$lang eq 'ee'">Ewe</xsl:when>
         <xsl:when test="$lang eq 'ewo'">Ewondo</xsl:when>
         <xsl:when test="$lang eq 'fan'">Fang</xsl:when>
         <xsl:when test="$lang eq 'fao'">Faroese</xsl:when>
         <xsl:when test="$lang eq 'fo'">Faroese</xsl:when>
         <xsl:when test="$lang eq 'fat'">Fanti</xsl:when>
         <xsl:when test="$lang eq 'fij'">Fijian</xsl:when>
         <xsl:when test="$lang eq 'fj'">Fijian</xsl:when>
         <xsl:when test="$lang eq 'fil'">Filipino or Pilipino</xsl:when>
         <xsl:when test="$lang eq 'fin'">Finnish</xsl:when>
         <xsl:when test="$lang eq 'fi'">Finnish</xsl:when>
         <xsl:when test="$lang eq 'fiu'">Finno-Ugrian (Other)</xsl:when>
         <xsl:when test="$lang eq 'fon'">Fon</xsl:when>
         <xsl:when test="$lang eq 'fre'">French</xsl:when>
         <xsl:when test="$lang eq 'fra'">French</xsl:when>
         <xsl:when test="$lang eq 'fr'">French</xsl:when>
         <xsl:when test="$lang eq 'frm'">French, Middle (ca.1400-1600)</xsl:when>
         <xsl:when test="$lang eq 'fro'">French, Old (842-ca.1400)</xsl:when>
         <xsl:when test="$lang eq 'frr'">Northern Frisian</xsl:when>
         <xsl:when test="$lang eq 'frs'">Eastern Frisian</xsl:when>
         <xsl:when test="$lang eq 'fry'">Western Frisian</xsl:when>
         <xsl:when test="$lang eq 'fy'">Western Frisian</xsl:when>
         <xsl:when test="$lang eq 'ful'">Fulah</xsl:when>
         <xsl:when test="$lang eq 'ff'">Fulah</xsl:when>
         <xsl:when test="$lang eq 'fur'">Friulian</xsl:when>
         <xsl:when test="$lang eq 'gaa'">Ga</xsl:when>
         <xsl:when test="$lang eq 'gay'">Gayo</xsl:when>
         <xsl:when test="$lang eq 'gba'">Gbaya</xsl:when>
         <xsl:when test="$lang eq 'gem'">Germanic (Other)</xsl:when>
         <xsl:when test="$lang eq 'geo'">Georgian</xsl:when>
         <xsl:when test="$lang eq 'kat'">Georgian</xsl:when>
         <xsl:when test="$lang eq 'ka'">Georgian</xsl:when>
         <xsl:when test="$lang eq 'ger'">German</xsl:when>
         <xsl:when test="$lang eq 'deu'">German</xsl:when>
         <xsl:when test="$lang eq 'de'">German</xsl:when>
         <xsl:when test="$lang eq 'gez'">Geez</xsl:when>
         <xsl:when test="$lang eq 'gil'">Gilbertese</xsl:when>
         <xsl:when test="$lang eq 'gla'">Gaelic or Scottish Gaelic</xsl:when>
         <xsl:when test="$lang eq 'gd'">Gaelic or Scottish Gaelic</xsl:when>
         <xsl:when test="$lang eq 'gle'">Irish</xsl:when>
         <xsl:when test="$lang eq 'ga'">Irish</xsl:when>
         <xsl:when test="$lang eq 'glg'">Galician</xsl:when>
         <xsl:when test="$lang eq 'gl'">Galician</xsl:when>
         <xsl:when test="$lang eq 'glv'">Manx</xsl:when>
         <xsl:when test="$lang eq 'gv'">Manx</xsl:when>
         <xsl:when test="$lang eq 'gmh'">German, Middle High (ca.1050-1500)</xsl:when>
         <xsl:when test="$lang eq 'goh'">German, Old High (ca.750-1050)</xsl:when>
         <xsl:when test="$lang eq 'gon'">Gondi</xsl:when>
         <xsl:when test="$lang eq 'gor'">Gorontalo</xsl:when>
         <xsl:when test="$lang eq 'got'">Gothic</xsl:when>
         <xsl:when test="$lang eq 'grb'">Grebo</xsl:when>
         <xsl:when test="$lang eq 'grc'">Greek, Ancient (to 1453)</xsl:when>
         <xsl:when test="$lang eq 'gre'">Greek, Modern (1453-)</xsl:when>
         <xsl:when test="$lang eq 'ell'">Greek, Modern (1453-)</xsl:when>
         <xsl:when test="$lang eq 'el'">Greek, Modern (1453-)</xsl:when>
         <xsl:when test="$lang eq 'grn'">Guarani</xsl:when>
         <xsl:when test="$lang eq 'gn'">Guarani</xsl:when>
         <xsl:when test="$lang eq 'gsw'">Swiss German or Alemannic</xsl:when>
         <xsl:when test="$lang eq 'guj'">Gujarati</xsl:when>
         <xsl:when test="$lang eq 'gu'">Gujarati</xsl:when>
         <xsl:when test="$lang eq 'gwi'">Gwich'in</xsl:when>
         <xsl:when test="$lang eq 'hai'">Haida</xsl:when>
         <xsl:when test="$lang eq 'hat'">Haitian or Haitian Creole</xsl:when>
         <xsl:when test="$lang eq 'ht'">Haitian or Haitian Creole</xsl:when>
         <xsl:when test="$lang eq 'hau'">Hausa</xsl:when>
         <xsl:when test="$lang eq 'ha'">Hausa</xsl:when>
         <xsl:when test="$lang eq 'haw'">Hawaiian</xsl:when>
         <xsl:when test="$lang eq 'heb'">Hebrew</xsl:when>
         <xsl:when test="$lang eq 'he'">Hebrew</xsl:when>
         <xsl:when test="$lang eq 'her'">Herero</xsl:when>
         <xsl:when test="$lang eq 'hz'">Herero</xsl:when>
         <xsl:when test="$lang eq 'hil'">Hiligaynon</xsl:when>
         <xsl:when test="$lang eq 'him'">Himachali</xsl:when>
         <xsl:when test="$lang eq 'hin'">Hindi</xsl:when>
         <xsl:when test="$lang eq 'hi'">Hindi</xsl:when>
         <xsl:when test="$lang eq 'hit'">Hittite</xsl:when>
         <xsl:when test="$lang eq 'hmn'">Hmong</xsl:when>
         <xsl:when test="$lang eq 'hmo'">Hiri Motu</xsl:when>
         <xsl:when test="$lang eq 'ho'">Hiri Motu</xsl:when>
         <xsl:when test="$lang eq 'hsb'">Upper Sorbian</xsl:when>
         <xsl:when test="$lang eq 'hun'">Hungarian</xsl:when>
         <xsl:when test="$lang eq 'hu'">Hungarian</xsl:when>
         <xsl:when test="$lang eq 'hup'">Hupa</xsl:when>
         <xsl:when test="$lang eq 'iba'">Iban</xsl:when>
         <xsl:when test="$lang eq 'ibo'">Igbo</xsl:when>
         <xsl:when test="$lang eq 'ig'">Igbo</xsl:when>
         <xsl:when test="$lang eq 'ice'">Icelandic</xsl:when>
         <xsl:when test="$lang eq 'isl'">Icelandic</xsl:when>
         <xsl:when test="$lang eq 'is'">Icelandic</xsl:when>
         <xsl:when test="$lang eq 'ido'">Ido</xsl:when>
         <xsl:when test="$lang eq 'io'">Ido</xsl:when>
         <xsl:when test="$lang eq 'iii'">Sichuan Yi</xsl:when>
         <xsl:when test="$lang eq 'ii'">Sichuan Yi</xsl:when>
         <xsl:when test="$lang eq 'ijo'">Ijo languages</xsl:when>
         <xsl:when test="$lang eq 'iku'">Inuktitut</xsl:when>
         <xsl:when test="$lang eq 'iu'">Inuktitut</xsl:when>
         <xsl:when test="$lang eq 'ile'">Interlingue</xsl:when>
         <xsl:when test="$lang eq 'ie'">Interlingue</xsl:when>
         <xsl:when test="$lang eq 'ilo'">Iloko</xsl:when>
         <xsl:when test="$lang eq 'ina'">Interlingua (International Auxiliary Language Association)</xsl:when>
         <xsl:when test="$lang eq 'ia'">Interlingua (International Auxiliary Language Association)</xsl:when>
         <xsl:when test="$lang eq 'inc'">Indic (Other)</xsl:when>
         <xsl:when test="$lang eq 'ind'">Indonesian</xsl:when>
         <xsl:when test="$lang eq 'id'">Indonesian</xsl:when>
         <xsl:when test="$lang eq 'ine'">Indo-European (Other)</xsl:when>
         <xsl:when test="$lang eq 'inh'">Ingush</xsl:when>
         <xsl:when test="$lang eq 'ipk'">Inupiaq</xsl:when>
         <xsl:when test="$lang eq 'ik'">Inupiaq</xsl:when>
         <xsl:when test="$lang eq 'ira'">Iranian (Other)</xsl:when>
         <xsl:when test="$lang eq 'iro'">Iroquoian languages</xsl:when>
         <xsl:when test="$lang eq 'ita'">Italian</xsl:when>
         <xsl:when test="$lang eq 'it'">Italian</xsl:when>
         <xsl:when test="$lang eq 'jav'">Javanese</xsl:when>
         <xsl:when test="$lang eq 'jv'">Javanese</xsl:when>
         <xsl:when test="$lang eq 'jbo'">Lojban</xsl:when>
         <xsl:when test="$lang eq 'jpn'">Japanese</xsl:when>
         <xsl:when test="$lang eq 'ja'">Japanese</xsl:when>
         <xsl:when test="$lang eq 'jpr'">Judeo-Persian</xsl:when>
         <xsl:when test="$lang eq 'jrb'">Judeo-Arabic</xsl:when>
         <xsl:when test="$lang eq 'kaa'">Kara-Kalpak</xsl:when>
         <xsl:when test="$lang eq 'kab'">Kabyle</xsl:when>
         <xsl:when test="$lang eq 'kac'">Kachin or Jingpho</xsl:when>
         <xsl:when test="$lang eq 'kal'">Kalaallisut or Greenlandic</xsl:when>
         <xsl:when test="$lang eq 'kl'">Kalaallisut or Greenlandic</xsl:when>
         <xsl:when test="$lang eq 'kam'">Kamba</xsl:when>
         <xsl:when test="$lang eq 'kan'">Kannada</xsl:when>
         <xsl:when test="$lang eq 'kn'">Kannada</xsl:when>
         <xsl:when test="$lang eq 'kar'">Karen languages</xsl:when>
         <xsl:when test="$lang eq 'kas'">Kashmiri</xsl:when>
         <xsl:when test="$lang eq 'ks'">Kashmiri</xsl:when>
         <xsl:when test="$lang eq 'kau'">Kanuri</xsl:when>
         <xsl:when test="$lang eq 'kr'">Kanuri</xsl:when>
         <xsl:when test="$lang eq 'kaw'">Kawi</xsl:when>
         <xsl:when test="$lang eq 'kaz'">Kazakh</xsl:when>
         <xsl:when test="$lang eq 'kk'">Kazakh</xsl:when>
         <xsl:when test="$lang eq 'kbd'">Kabardian</xsl:when>
         <xsl:when test="$lang eq 'kha'">Khasi</xsl:when>
         <xsl:when test="$lang eq 'khi'">Khoisan (Other)</xsl:when>
         <xsl:when test="$lang eq 'khm'">Central Khmer</xsl:when>
         <xsl:when test="$lang eq 'km'">Central Khmer</xsl:when>
         <xsl:when test="$lang eq 'kho'">Khotanese</xsl:when>
         <xsl:when test="$lang eq 'kik'">Kikuyu or Gikuyu</xsl:when>
         <xsl:when test="$lang eq 'ki'">Kikuyu or Gikuyu</xsl:when>
         <xsl:when test="$lang eq 'kin'">Kinyarwanda</xsl:when>
         <xsl:when test="$lang eq 'rw'">Kinyarwanda</xsl:when>
         <xsl:when test="$lang eq 'kir'">Kirghiz or Kyrgyz</xsl:when>
         <xsl:when test="$lang eq 'ky'">Kirghiz or Kyrgyz</xsl:when>
         <xsl:when test="$lang eq 'kmb'">Kimbundu</xsl:when>
         <xsl:when test="$lang eq 'kok'">Konkani</xsl:when>
         <xsl:when test="$lang eq 'kom'">Komi</xsl:when>
         <xsl:when test="$lang eq 'kv'">Komi</xsl:when>
         <xsl:when test="$lang eq 'kon'">Kongo</xsl:when>
         <xsl:when test="$lang eq 'kg'">Kongo</xsl:when>
         <xsl:when test="$lang eq 'kor'">Korean</xsl:when>
         <xsl:when test="$lang eq 'ko'">Korean</xsl:when>
         <xsl:when test="$lang eq 'kos'">Kosraean</xsl:when>
         <xsl:when test="$lang eq 'kpe'">Kpelle</xsl:when>
         <xsl:when test="$lang eq 'krc'">Karachay-Balkar</xsl:when>
         <xsl:when test="$lang eq 'krl'">Karelian</xsl:when>
         <xsl:when test="$lang eq 'kro'">Kru languages</xsl:when>
         <xsl:when test="$lang eq 'kru'">Kurukh</xsl:when>
         <xsl:when test="$lang eq 'kua'">Kuanyama or Kwanyama</xsl:when>
         <xsl:when test="$lang eq 'kj'">Kuanyama or Kwanyama</xsl:when>
         <xsl:when test="$lang eq 'kum'">Kumyk</xsl:when>
         <xsl:when test="$lang eq 'kur'">Kurdish</xsl:when>
         <xsl:when test="$lang eq 'ku'">Kurdish</xsl:when>
         <xsl:when test="$lang eq 'kut'">Kutenai</xsl:when>
         <xsl:when test="$lang eq 'lad'">Ladino</xsl:when>
         <xsl:when test="$lang eq 'lah'">Lahnda</xsl:when>
         <xsl:when test="$lang eq 'lam'">Lamba</xsl:when>
         <xsl:when test="$lang eq 'lao'">Lao</xsl:when>
         <xsl:when test="$lang eq 'lo'">Lao</xsl:when>
         <xsl:when test="$lang eq 'lat'">Latin</xsl:when>
         <xsl:when test="$lang eq 'la'">Latin</xsl:when>
         <xsl:when test="$lang eq 'lav'">Latvian</xsl:when>
         <xsl:when test="$lang eq 'lv'">Latvian</xsl:when>
         <xsl:when test="$lang eq 'lez'">Lezghian</xsl:when>
         <xsl:when test="$lang eq 'lim'">Limburgan or Limburger or Limburgish</xsl:when>
         <xsl:when test="$lang eq 'li'">Limburgan or Limburger or Limburgish</xsl:when>
         <xsl:when test="$lang eq 'lin'">Lingala</xsl:when>
         <xsl:when test="$lang eq 'ln'">Lingala</xsl:when>
         <xsl:when test="$lang eq 'lit'">Lithuanian</xsl:when>
         <xsl:when test="$lang eq 'lt'">Lithuanian</xsl:when>
         <xsl:when test="$lang eq 'lol'">Mongo</xsl:when>
         <xsl:when test="$lang eq 'loz'">Lozi</xsl:when>
         <xsl:when test="$lang eq 'ltz'">Luxembourgish or Letzeburgesch</xsl:when>
         <xsl:when test="$lang eq 'lb'">Luxembourgish or Letzeburgesch</xsl:when>
         <xsl:when test="$lang eq 'lua'">Luba-Lulua</xsl:when>
         <xsl:when test="$lang eq 'lub'">Luba-Katanga</xsl:when>
         <xsl:when test="$lang eq 'lu'">Luba-Katanga</xsl:when>
         <xsl:when test="$lang eq 'lug'">Ganda</xsl:when>
         <xsl:when test="$lang eq 'lg'">Ganda</xsl:when>
         <xsl:when test="$lang eq 'lui'">Luiseno</xsl:when>
         <xsl:when test="$lang eq 'lun'">Lunda</xsl:when>
         <xsl:when test="$lang eq 'luo'">Luo (Kenya and Tanzania)</xsl:when>
         <xsl:when test="$lang eq 'lus'">Lushai</xsl:when>
         <xsl:when test="$lang eq 'mac'">Macedonian</xsl:when>
         <xsl:when test="$lang eq 'mkd'">Macedonian</xsl:when>
         <xsl:when test="$lang eq 'mk'">Macedonian</xsl:when>
         <xsl:when test="$lang eq 'mad'">Madurese</xsl:when>
         <xsl:when test="$lang eq 'mag'">Magahi</xsl:when>
         <xsl:when test="$lang eq 'mah'">Marshallese</xsl:when>
         <xsl:when test="$lang eq 'mh'">Marshallese</xsl:when>
         <xsl:when test="$lang eq 'mai'">Maithili</xsl:when>
         <xsl:when test="$lang eq 'mak'">Makasar</xsl:when>
         <xsl:when test="$lang eq 'mal'">Malayalam</xsl:when>
         <xsl:when test="$lang eq 'ml'">Malayalam</xsl:when>
         <xsl:when test="$lang eq 'man'">Mandingo</xsl:when>
         <xsl:when test="$lang eq 'mao'">Maori</xsl:when>
         <xsl:when test="$lang eq 'mri'">Maori</xsl:when>
         <xsl:when test="$lang eq 'mi'">Maori</xsl:when>
         <xsl:when test="$lang eq 'map'">Austronesian (Other)</xsl:when>
         <xsl:when test="$lang eq 'mar'">Marathi</xsl:when>
         <xsl:when test="$lang eq 'mr'">Marathi</xsl:when>
         <xsl:when test="$lang eq 'mas'">Masai</xsl:when>
         <xsl:when test="$lang eq 'may'">Malay</xsl:when>
         <xsl:when test="$lang eq 'msa'">Malay</xsl:when>
         <xsl:when test="$lang eq 'ms'">Malay</xsl:when>
         <xsl:when test="$lang eq 'mdf'">Moksha</xsl:when>
         <xsl:when test="$lang eq 'mdr'">Mandar</xsl:when>
         <xsl:when test="$lang eq 'men'">Mende</xsl:when>
         <xsl:when test="$lang eq 'mga'">Irish, Middle (900-1200)</xsl:when>
         <xsl:when test="$lang eq 'mic'">Mi'kmaq or Micmac</xsl:when>
         <xsl:when test="$lang eq 'min'">Minangkabau</xsl:when>
         <xsl:when test="$lang eq 'mis'">Miscellaneous languages</xsl:when>
         <xsl:when test="$lang eq 'mkh'">Mon-Khmer (Other)</xsl:when>
         <xsl:when test="$lang eq 'mlg'">Malagasy</xsl:when>
         <xsl:when test="$lang eq 'mg'">Malagasy</xsl:when>
         <xsl:when test="$lang eq 'mlt'">Maltese</xsl:when>
         <xsl:when test="$lang eq 'mt'">Maltese</xsl:when>
         <xsl:when test="$lang eq 'mnc'">Manchu</xsl:when>
         <xsl:when test="$lang eq 'mni'">Manipuri</xsl:when>
         <xsl:when test="$lang eq 'mno'">Manobo languages</xsl:when>
         <xsl:when test="$lang eq 'moh'">Mohawk</xsl:when>
         <xsl:when test="$lang eq 'mol'">Moldavian</xsl:when>
         <xsl:when test="$lang eq 'mo'">Moldavian</xsl:when>
         <xsl:when test="$lang eq 'mon'">Mongolian</xsl:when>
         <xsl:when test="$lang eq 'mn'">Mongolian</xsl:when>
         <xsl:when test="$lang eq 'mos'">Mossi</xsl:when>
         <xsl:when test="$lang eq 'mul'">Multiple languages</xsl:when>
         <xsl:when test="$lang eq 'mun'">Munda languages</xsl:when>
         <xsl:when test="$lang eq 'mus'">Creek</xsl:when>
         <xsl:when test="$lang eq 'mwl'">Mirandese</xsl:when>
         <xsl:when test="$lang eq 'mwr'">Marwari</xsl:when>
         <xsl:when test="$lang eq 'myn'">Mayan languages</xsl:when>
         <xsl:when test="$lang eq 'myv'">Erzya</xsl:when>
         <xsl:when test="$lang eq 'nah'">Nahuatl languages</xsl:when>
         <xsl:when test="$lang eq 'nai'">North American Indian</xsl:when>
         <xsl:when test="$lang eq 'nap'">Neapolitan</xsl:when>
         <xsl:when test="$lang eq 'nau'">Nauru</xsl:when>
         <xsl:when test="$lang eq 'na'">Nauru</xsl:when>
         <xsl:when test="$lang eq 'nav'">Navajo or Navaho</xsl:when>
         <xsl:when test="$lang eq 'nv'">Navajo or Navaho</xsl:when>
         <xsl:when test="$lang eq 'nbl'">Ndebele, South or South Ndebele</xsl:when>
         <xsl:when test="$lang eq 'nr'">Ndebele, South or South Ndebele</xsl:when>
         <xsl:when test="$lang eq 'nde'">Ndebele, North or North Ndebele</xsl:when>
         <xsl:when test="$lang eq 'nd'">Ndebele, North or North Ndebele</xsl:when>
         <xsl:when test="$lang eq 'ndo'">Ndonga</xsl:when>
         <xsl:when test="$lang eq 'ng'">Ndonga</xsl:when>
         <xsl:when test="$lang eq 'nds'">Low German or Low Saxon or German, Low or Saxon, Low</xsl:when>
         <xsl:when test="$lang eq 'nep'">Nepali</xsl:when>
         <xsl:when test="$lang eq 'ne'">Nepali</xsl:when>
         <xsl:when test="$lang eq 'new'">Nepal Bhasa or Newari</xsl:when>
         <xsl:when test="$lang eq 'nia'">Nias</xsl:when>
         <xsl:when test="$lang eq 'nic'">Niger-Kordofanian (Other)</xsl:when>
         <xsl:when test="$lang eq 'niu'">Niuean</xsl:when>
         <xsl:when test="$lang eq 'nno'">Norwegian Nynorsk or Nynorsk, Norwegian</xsl:when>
         <xsl:when test="$lang eq 'nn'">Norwegian Nynorsk or Nynorsk, Norwegian</xsl:when>
         <xsl:when test="$lang eq 'nob'">Bokmål, Norwegian or Norwegian Bokmål</xsl:when>
         <xsl:when test="$lang eq 'nb'">Bokmål, Norwegian or Norwegian Bokmål</xsl:when>
         <xsl:when test="$lang eq 'nog'">Nogai</xsl:when>
         <xsl:when test="$lang eq 'non'">Norse, Old</xsl:when>
         <xsl:when test="$lang eq 'nor'">Norwegian</xsl:when>
         <xsl:when test="$lang eq 'no'">Norwegian</xsl:when>
         <xsl:when test="$lang eq 'nso'">Pedi or Sepedi or Northern Sotho</xsl:when>
         <xsl:when test="$lang eq 'nub'">Nubian languages</xsl:when>
         <xsl:when test="$lang eq 'nwc'">Classical Newari or Old Newari or Classical Nepal Bhasa</xsl:when>
         <xsl:when test="$lang eq 'nya'">Chichewa or Chewa or Nyanja</xsl:when>
         <xsl:when test="$lang eq 'ny'">Chichewa or Chewa or Nyanja</xsl:when>
         <xsl:when test="$lang eq 'nym'">Nyamwezi</xsl:when>
         <xsl:when test="$lang eq 'nyn'">Nyankole</xsl:when>
         <xsl:when test="$lang eq 'nyo'">Nyoro</xsl:when>
         <xsl:when test="$lang eq 'nzi'">Nzima</xsl:when>
         <xsl:when test="$lang eq 'oci'">Occitan (post 1500) or Provençal</xsl:when>
         <xsl:when test="$lang eq 'oc'">Occitan (post 1500) or Provençal</xsl:when>
         <xsl:when test="$lang eq 'oji'">Ojibwa</xsl:when>
         <xsl:when test="$lang eq 'oj'">Ojibwa</xsl:when>
         <xsl:when test="$lang eq 'ori'">Oriya</xsl:when>
         <xsl:when test="$lang eq 'or'">Oriya</xsl:when>
         <xsl:when test="$lang eq 'orm'">Oromo</xsl:when>
         <xsl:when test="$lang eq 'om'">Oromo</xsl:when>
         <xsl:when test="$lang eq 'osa'">Osage</xsl:when>
         <xsl:when test="$lang eq 'oss'">Ossetian or Ossetic</xsl:when>
         <xsl:when test="$lang eq 'os'">Ossetian or Ossetic</xsl:when>
         <xsl:when test="$lang eq 'ota'">Turkish, Ottoman (1500-1928)</xsl:when>
         <xsl:when test="$lang eq 'oto'">Otomian languages</xsl:when>
         <xsl:when test="$lang eq 'paa'">Papuan (Other)</xsl:when>
         <xsl:when test="$lang eq 'pag'">Pangasinan</xsl:when>
         <xsl:when test="$lang eq 'pal'">Pahlavi</xsl:when>
         <xsl:when test="$lang eq 'pam'">Pampanga</xsl:when>
         <xsl:when test="$lang eq 'pan'">Panjabi or Punjabi</xsl:when>
         <xsl:when test="$lang eq 'pa'">Panjabi or Punjabi</xsl:when>
         <xsl:when test="$lang eq 'pap'">Papiamento</xsl:when>
         <xsl:when test="$lang eq 'pau'">Palauan</xsl:when>
         <xsl:when test="$lang eq 'peo'">Persian, Old (ca.600-400 B.C.)</xsl:when>
         <xsl:when test="$lang eq 'per'">Persian</xsl:when>
         <xsl:when test="$lang eq 'fas'">Persian</xsl:when>
         <xsl:when test="$lang eq 'fa'">Persian</xsl:when>
         <xsl:when test="$lang eq 'phi'">Philippine (Other)</xsl:when>
         <xsl:when test="$lang eq 'phn'">Phoenician</xsl:when>
         <xsl:when test="$lang eq 'pli'">Pali</xsl:when>
         <xsl:when test="$lang eq 'pi'">Pali</xsl:when>
         <xsl:when test="$lang eq 'pol'">Polish</xsl:when>
         <xsl:when test="$lang eq 'pl'">Polish</xsl:when>
         <xsl:when test="$lang eq 'pon'">Pohnpeian</xsl:when>
         <xsl:when test="$lang eq 'por'">Portuguese</xsl:when>
         <xsl:when test="$lang eq 'pt'">Portuguese</xsl:when>
         <xsl:when test="$lang eq 'pra'">Prakrit languages</xsl:when>
         <xsl:when test="$lang eq 'pro'">Provençal, Old (to 1500)</xsl:when>
         <xsl:when test="$lang eq 'pus'">Pushto</xsl:when>
         <xsl:when test="$lang eq 'ps'">Pushto</xsl:when>
         <xsl:when test="$lang eq 'que'">Quechua</xsl:when>
         <xsl:when test="$lang eq 'qu'">Quechua</xsl:when>
         <xsl:when test="$lang eq 'raj'">Rajasthani</xsl:when>
         <xsl:when test="$lang eq 'rap'">Rapanui</xsl:when>
         <xsl:when test="$lang eq 'rar'">Rarotongan or Cook Islands Maori</xsl:when>
         <xsl:when test="$lang eq 'roa'">Romance (Other)</xsl:when>
         <xsl:when test="$lang eq 'roh'">Romansh</xsl:when>
         <xsl:when test="$lang eq 'rm'">Romansh</xsl:when>
         <xsl:when test="$lang eq 'rom'">Romany</xsl:when>
         <xsl:when test="$lang eq 'rum'">Romanian</xsl:when>
         <xsl:when test="$lang eq 'ron'">Romanian</xsl:when>
         <xsl:when test="$lang eq 'ro'">Romanian</xsl:when>
         <xsl:when test="$lang eq 'run'">Rundi</xsl:when>
         <xsl:when test="$lang eq 'rn'">Rundi</xsl:when>
         <xsl:when test="$lang eq 'rup'">Aromanian or Arumanian or Macedo-Romanian</xsl:when>
         <xsl:when test="$lang eq 'rus'">Russian</xsl:when>
         <xsl:when test="$lang eq 'ru'">Russian</xsl:when>
         <xsl:when test="$lang eq 'sad'">Sandawe</xsl:when>
         <xsl:when test="$lang eq 'sag'">Sango</xsl:when>
         <xsl:when test="$lang eq 'sg'">Sango</xsl:when>
         <xsl:when test="$lang eq 'sah'">Yakut</xsl:when>
         <xsl:when test="$lang eq 'sai'">South American Indian (Other)</xsl:when>
         <xsl:when test="$lang eq 'sal'">Salishan languages</xsl:when>
         <xsl:when test="$lang eq 'sam'">Samaritan Aramaic</xsl:when>
         <xsl:when test="$lang eq 'san'">Sanskrit</xsl:when>
         <xsl:when test="$lang eq 'sa'">Sanskrit</xsl:when>
         <xsl:when test="$lang eq 'sas'">Sasak</xsl:when>
         <xsl:when test="$lang eq 'sat'">Santali</xsl:when>
         <xsl:when test="$lang eq 'scc'">Serbian</xsl:when>
         <xsl:when test="$lang eq 'srp'">Serbian</xsl:when>
         <xsl:when test="$lang eq 'sr'">Serbian</xsl:when>
         <xsl:when test="$lang eq 'scn'">Sicilian</xsl:when>
         <xsl:when test="$lang eq 'sco'">Scots</xsl:when>
         <xsl:when test="$lang eq 'scr'">Croatian</xsl:when>
         <xsl:when test="$lang eq 'hrv'">Croatian</xsl:when>
         <xsl:when test="$lang eq 'hr'">Croatian</xsl:when>
         <xsl:when test="$lang eq 'sel'">Selkup</xsl:when>
         <xsl:when test="$lang eq 'sem'">Semitic (Other)</xsl:when>
         <xsl:when test="$lang eq 'sga'">Irish, Old (to 900)</xsl:when>
         <xsl:when test="$lang eq 'sgn'">Sign Languages</xsl:when>
         <xsl:when test="$lang eq 'shn'">Shan</xsl:when>
         <xsl:when test="$lang eq 'sid'">Sidamo</xsl:when>
         <xsl:when test="$lang eq 'sin'">Sinhala or Sinhalese</xsl:when>
         <xsl:when test="$lang eq 'si'">Sinhala or Sinhalese</xsl:when>
         <xsl:when test="$lang eq 'sio'">Siouan languages</xsl:when>
         <xsl:when test="$lang eq 'sit'">Sino-Tibetan (Other)</xsl:when>
         <xsl:when test="$lang eq 'sla'">Slavic (Other)</xsl:when>
         <xsl:when test="$lang eq 'slo'">Slovak</xsl:when>
         <xsl:when test="$lang eq 'slk'">Slovak</xsl:when>
         <xsl:when test="$lang eq 'sk'">Slovak</xsl:when>
         <xsl:when test="$lang eq 'slv'">Slovenian</xsl:when>
         <xsl:when test="$lang eq 'sl'">Slovenian</xsl:when>
         <xsl:when test="$lang eq 'sma'">Southern Sami</xsl:when>
         <xsl:when test="$lang eq 'sme'">Northern Sami</xsl:when>
         <xsl:when test="$lang eq 'se'">Northern Sami</xsl:when>
         <xsl:when test="$lang eq 'smi'">Sami languages (Other)</xsl:when>
         <xsl:when test="$lang eq 'smj'">Lule Sami</xsl:when>
         <xsl:when test="$lang eq 'smn'">Inari Sami</xsl:when>
         <xsl:when test="$lang eq 'smo'">Samoan</xsl:when>
         <xsl:when test="$lang eq 'sm'">Samoan</xsl:when>
         <xsl:when test="$lang eq 'sms'">Skolt Sami</xsl:when>
         <xsl:when test="$lang eq 'sna'">Shona</xsl:when>
         <xsl:when test="$lang eq 'sn'">Shona</xsl:when>
         <xsl:when test="$lang eq 'snd'">Sindhi</xsl:when>
         <xsl:when test="$lang eq 'sd'">Sindhi</xsl:when>
         <xsl:when test="$lang eq 'snk'">Soninke</xsl:when>
         <xsl:when test="$lang eq 'sog'">Sogdian</xsl:when>
         <xsl:when test="$lang eq 'som'">Somali</xsl:when>
         <xsl:when test="$lang eq 'so'">Somali</xsl:when>
         <xsl:when test="$lang eq 'son'">Songhai languages</xsl:when>
         <xsl:when test="$lang eq 'sot'">Sotho, Southern</xsl:when>
         <xsl:when test="$lang eq 'st'">Sotho, Southern</xsl:when>
         <xsl:when test="$lang eq 'spa'">Spanish or Castilian</xsl:when>
         <xsl:when test="$lang eq 'es'">Spanish or Castilian</xsl:when>
         <xsl:when test="$lang eq 'srd'">Sardinian</xsl:when>
         <xsl:when test="$lang eq 'sc'">Sardinian</xsl:when>
         <xsl:when test="$lang eq 'srn'">Sranan Tongo</xsl:when>
         <xsl:when test="$lang eq 'srr'">Serer</xsl:when>
         <xsl:when test="$lang eq 'ssa'">Nilo-Saharan (Other)</xsl:when>
         <xsl:when test="$lang eq 'ssw'">Swati</xsl:when>
         <xsl:when test="$lang eq 'ss'">Swati</xsl:when>
         <xsl:when test="$lang eq 'suk'">Sukuma</xsl:when>
         <xsl:when test="$lang eq 'sun'">Sundanese</xsl:when>
         <xsl:when test="$lang eq 'su'">Sundanese</xsl:when>
         <xsl:when test="$lang eq 'sus'">Susu</xsl:when>
         <xsl:when test="$lang eq 'sux'">Sumerian</xsl:when>
         <xsl:when test="$lang eq 'swa'">Swahili</xsl:when>
         <xsl:when test="$lang eq 'sw'">Swahili</xsl:when>
         <xsl:when test="$lang eq 'swe'">Swedish</xsl:when>
         <xsl:when test="$lang eq 'sv'">Swedish</xsl:when>
         <xsl:when test="$lang eq 'syr'">Syriac</xsl:when>
         <xsl:when test="$lang eq 'tah'">Tahitian</xsl:when>
         <xsl:when test="$lang eq 'ty'">Tahitian</xsl:when>
         <xsl:when test="$lang eq 'tai'">Tai (Other)</xsl:when>
         <xsl:when test="$lang eq 'tam'">Tamil</xsl:when>
         <xsl:when test="$lang eq 'ta'">Tamil</xsl:when>
         <xsl:when test="$lang eq 'tat'">Tatar</xsl:when>
         <xsl:when test="$lang eq 'tt'">Tatar</xsl:when>
         <xsl:when test="$lang eq 'tel'">Telugu</xsl:when>
         <xsl:when test="$lang eq 'te'">Telugu</xsl:when>
         <xsl:when test="$lang eq 'tem'">Timne</xsl:when>
         <xsl:when test="$lang eq 'ter'">Tereno</xsl:when>
         <xsl:when test="$lang eq 'tet'">Tetum</xsl:when>
         <xsl:when test="$lang eq 'tgk'">Tajik</xsl:when>
         <xsl:when test="$lang eq 'tg'">Tajik</xsl:when>
         <xsl:when test="$lang eq 'tgl'">Tagalog</xsl:when>
         <xsl:when test="$lang eq 'tl'">Tagalog</xsl:when>
         <xsl:when test="$lang eq 'tha'">Thai</xsl:when>
         <xsl:when test="$lang eq 'th'">Thai</xsl:when>
         <xsl:when test="$lang eq 'tib'">Tibetan</xsl:when>
         <xsl:when test="$lang eq 'bod'">Tibetan</xsl:when>
         <xsl:when test="$lang eq 'bo'">Tibetan</xsl:when>
         <xsl:when test="$lang eq 'tig'">Tigre</xsl:when>
         <xsl:when test="$lang eq 'tir'">Tigrinya</xsl:when>
         <xsl:when test="$lang eq 'ti'">Tigrinya</xsl:when>
         <xsl:when test="$lang eq 'tiv'">Tiv</xsl:when>
         <xsl:when test="$lang eq 'tkl'">Tokelau</xsl:when>
         <xsl:when test="$lang eq 'tlh'">Klingon or tlhIngan-Hol</xsl:when>
         <xsl:when test="$lang eq 'tli'">Tlingit</xsl:when>
         <xsl:when test="$lang eq 'tmh'">Tamashek</xsl:when>
         <xsl:when test="$lang eq 'tog'">Tonga (Nyasa)</xsl:when>
         <xsl:when test="$lang eq 'ton'">Tonga (Tonga Islands)</xsl:when>
         <xsl:when test="$lang eq 'to'">Tonga (Tonga Islands)</xsl:when>
         <xsl:when test="$lang eq 'tpi'">Tok Pisin</xsl:when>
         <xsl:when test="$lang eq 'tsi'">Tsimshian</xsl:when>
         <xsl:when test="$lang eq 'tsn'">Tswana</xsl:when>
         <xsl:when test="$lang eq 'tn'">Tswana</xsl:when>
         <xsl:when test="$lang eq 'tso'">Tsonga</xsl:when>
         <xsl:when test="$lang eq 'ts'">Tsonga</xsl:when>
         <xsl:when test="$lang eq 'tuk'">Turkmen</xsl:when>
         <xsl:when test="$lang eq 'tk'">Turkmen</xsl:when>
         <xsl:when test="$lang eq 'tum'">Tumbuka</xsl:when>
         <xsl:when test="$lang eq 'tup'">Tupi languages</xsl:when>
         <xsl:when test="$lang eq 'tur'">Turkish</xsl:when>
         <xsl:when test="$lang eq 'tr'">Turkish</xsl:when>
         <xsl:when test="$lang eq 'tut'">Altaic (Other)</xsl:when>
         <xsl:when test="$lang eq 'tvl'">Tuvalu</xsl:when>
         <xsl:when test="$lang eq 'twi'">Twi</xsl:when>
         <xsl:when test="$lang eq 'tw'">Twi</xsl:when>
         <xsl:when test="$lang eq 'tyv'">Tuvinian</xsl:when>
         <xsl:when test="$lang eq 'udm'">Udmurt</xsl:when>
         <xsl:when test="$lang eq 'uga'">Ugaritic</xsl:when>
         <xsl:when test="$lang eq 'uig'">Uighur or Uyghur</xsl:when>
         <xsl:when test="$lang eq 'ug'">Uighur or Uyghur</xsl:when>
         <xsl:when test="$lang eq 'ukr'">Ukrainian</xsl:when>
         <xsl:when test="$lang eq 'uk'">Ukrainian</xsl:when>
         <xsl:when test="$lang eq 'umb'">Umbundu</xsl:when>
         <xsl:when test="$lang eq 'und'">Undetermined</xsl:when>
         <xsl:when test="$lang eq 'urd'">Urdu</xsl:when>
         <xsl:when test="$lang eq 'ur'">Urdu</xsl:when>
         <xsl:when test="$lang eq 'uzb'">Uzbek</xsl:when>
         <xsl:when test="$lang eq 'uz'">Uzbek</xsl:when>
         <xsl:when test="$lang eq 'vai'">Vai</xsl:when>
         <xsl:when test="$lang eq 'ven'">Venda</xsl:when>
         <xsl:when test="$lang eq 've'">Venda</xsl:when>
         <xsl:when test="$lang eq 'vie'">Vietnamese</xsl:when>
         <xsl:when test="$lang eq 'vi'">Vietnamese</xsl:when>
         <xsl:when test="$lang eq 'vol'">Volapük</xsl:when>
         <xsl:when test="$lang eq 'vo'">Volapük</xsl:when>
         <xsl:when test="$lang eq 'vot'">Votic</xsl:when>
         <xsl:when test="$lang eq 'wak'">Wakashan languages</xsl:when>
         <xsl:when test="$lang eq 'wal'">Walamo</xsl:when>
         <xsl:when test="$lang eq 'war'">Waray</xsl:when>
         <xsl:when test="$lang eq 'was'">Washo</xsl:when>
         <xsl:when test="$lang eq 'wel'">Welsh</xsl:when>
         <xsl:when test="$lang eq 'cym'">Welsh</xsl:when>
         <xsl:when test="$lang eq 'cy'">Welsh</xsl:when>
         <xsl:when test="$lang eq 'wen'">Sorbian languages</xsl:when>
         <xsl:when test="$lang eq 'wln'">Walloon</xsl:when>
         <xsl:when test="$lang eq 'wa'">Walloon</xsl:when>
         <xsl:when test="$lang eq 'wol'">Wolof</xsl:when>
         <xsl:when test="$lang eq 'wo'">Wolof</xsl:when>
         <xsl:when test="$lang eq 'xal'">Kalmyk or Oirat</xsl:when>
         <xsl:when test="$lang eq 'xho'">Xhosa</xsl:when>
         <xsl:when test="$lang eq 'xh'">Xhosa</xsl:when>
         <xsl:when test="$lang eq 'yao'">Yao</xsl:when>
         <xsl:when test="$lang eq 'yap'">Yapese</xsl:when>
         <xsl:when test="$lang eq 'yid'">Yiddish</xsl:when>
         <xsl:when test="$lang eq 'yi'">Yiddish</xsl:when>
         <xsl:when test="$lang eq 'yor'">Yoruba</xsl:when>
         <xsl:when test="$lang eq 'yo'">Yoruba</xsl:when>
         <xsl:when test="$lang eq 'ypk'">Yupik languages</xsl:when>
         <xsl:when test="$lang eq 'zap'">Zapotec</xsl:when>
         <xsl:when test="$lang eq 'zen'">Zenaga</xsl:when>
         <xsl:when test="$lang eq 'zha'">Zhuang or Chuang</xsl:when>
         <xsl:when test="$lang eq 'za'">Zhuang or Chuang</xsl:when>
         <xsl:when test="$lang eq 'znd'">Zande languages</xsl:when>
         <xsl:when test="$lang eq 'zul'">Zulu</xsl:when>
         <xsl:when test="$lang eq 'zu'">Zulu</xsl:when>
         <xsl:when test="$lang eq 'zun'">Zuni</xsl:when>
         <xsl:when test="$lang eq 'zxx'">No linguistic content</xsl:when>
         <xsl:when test="$lang eq 'nqo'">N'Ko</xsl:when>
         <xsl:when test="$lang eq 'zza'">Zaza or Dimili or Dimli or Kirdki or Kirmanjki or Zazaki</xsl:when>
         <xsl:otherwise>
            <xsl:message>
               <xsl:text>The language code </xsl:text>
               <xsl:value-of select="$lang"/>
               <xsl:text>is not a recognized value. Please supply a language code from ISO 639-B.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!--+
       | Defaults to creator, which probably makes the most sense for archives.
       +-->
   <xsl:function name="lib:role-code-to-uri" as="xs:string">
      <xsl:param name="code" as="xs:string?"/>
      <xsl:variable name="uri" as="xs:string?" select="$lib:role-lookup//role[code eq $code]/uri"/>
      <xsl:choose>
         <xsl:when test="$uri">
            <xsl:value-of select="$uri"/>
         </xsl:when>
         <xsl:otherwise>http://id.loc.gov/vocabulary/relators/cre</xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:variable name="lib:role-lookup" as="element()">
      <roles>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/act</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Actor</label>
            <code>act</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/adp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Adapter</label>
            <code>adp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/anl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Analyst</label>
            <code>anl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/anm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Animator</label>
            <code>anm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ann</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Annotator</label>
            <code>ann</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/app</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Applicant</label>
            <code>app</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/arc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Architect</label>
            <code>arc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/arr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Arranger</label>
            <code>arr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/acp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Art copyist</label>
            <code>acp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/art</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Artist</label>
            <code>art</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ard</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Artistic director</label>
            <code>ard</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/asg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Assignee</label>
            <code>asg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/asn</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Associated name</label>
            <code>asn</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/att</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Attributed name</label>
            <code>att</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/auc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Auctioneer</label>
            <code>auc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aut</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author</label>
            <code>aut</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aqt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author in quotations or text extracts</label>
            <code>aqt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aft</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author of afterword, colophon, etc.</label>
            <code>aft</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aud</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author of dialog</label>
            <code>aud</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aui</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author of introduction, etc.</label>
            <code>aui</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/aus</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Author of screenplay, etc.</label>
            <code>aus</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ant</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Bibliographic antecedent</label>
            <code>ant</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bnd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Binder</label>
            <code>bnd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bdd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Binding designer</label>
            <code>bdd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/blw</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Blurb writer</label>
            <code>blw</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bkd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Book designer</label>
            <code>bkd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bkp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Book producer</label>
            <code>bkp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bjd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Bookjacket designer</label>
            <code>bjd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bpd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Bookplate designer</label>
            <code>bpd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/bsl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Bookseller</label>
            <code>bsl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cll</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Calligrapher</label>
            <code>cll</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ctg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Cartographer</label>
            <code>ctg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cns</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Censor</label>
            <code>cns</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/chr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Choreographer</label>
            <code>chr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cng</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Cinematographer</label>
            <code>cng</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cli</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Client</label>
            <code>cli</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/clb</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Collaborator</label>
            <code>clb</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/col</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Collector</label>
            <code>col</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/clt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Collotyper</label>
            <code>clt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/clr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Colorist</label>
            <code>clr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cmm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Commentator</label>
            <code>cmm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cwt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Commentator for written text</label>
            <code>cwt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/com</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Compiler</label>
            <code>com</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cpl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Complainant</label>
            <code>cpl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cpt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Complainant-appellant</label>
            <code>cpt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cpe</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Complainant-appellee</label>
            <code>cpe</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cmp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Composer</label>
            <code>cmp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cmt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Compositor</label>
            <code>cmt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ccp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Conceptor</label>
            <code>ccp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cnd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Conductor</label>
            <code>cnd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/con</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Conservator</label>
            <code>con</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/csl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Consultant</label>
            <code>csl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/csp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Consultant to a project</label>
            <code>csp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cos</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestant</label>
            <code>cos</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cot</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestant-appellant</label>
            <code>cot</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/coe</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestant-appellee</label>
            <code>coe</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cts</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestee</label>
            <code>cts</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ctt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestee-appellant</label>
            <code>ctt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cte</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contestee-appellee</label>
            <code>cte</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ctr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contractor</label>
            <code>ctr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ctb</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Contributor</label>
            <code>ctb</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cpc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Copyright claimant</label>
            <code>cpc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cph</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Copyright holder</label>
            <code>cph</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/crr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Corrector</label>
            <code>crr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/crp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Correspondent</label>
            <code>crp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cst</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Costume designer</label>
            <code>cst</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cov</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Cover designer</label>
            <code>cov</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cre</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Creator</label>
            <code>cre</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/cur</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Curator of an exhibition</label>
            <code>cur</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dnc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Dancer</label>
            <code>dnc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dtc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Data contributor</label>
            <code>dtc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dtm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Data manager</label>
            <code>dtm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dte</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Dedicatee</label>
            <code>dte</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dto</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Dedicator</label>
            <code>dto</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dfd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Defendant</label>
            <code>dfd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dft</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Defendant-appellant</label>
            <code>dft</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dfe</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Defendant-appellee</label>
            <code>dfe</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dgg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Degree grantor</label>
            <code>dgg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dln</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Delineator</label>
            <code>dln</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dpc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Depicted</label>
            <code>dpc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dpt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Depositor</label>
            <code>dpt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dsr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Designer</label>
            <code>dsr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/drt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Director</label>
            <code>drt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dis</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Dissertant</label>
            <code>dis</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dbp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Distribution place</label>
            <code>dbp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dst</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Distributor</label>
            <code>dst</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dnr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Donor</label>
            <code>dnr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/drm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Draftsman</label>
            <code>drm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/dub</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Dubious author</label>
            <code>dub</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/edt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Editor</label>
            <code>edt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/elg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Electrician</label>
            <code>elg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/elt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Electrotyper</label>
            <code>elt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/eng</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Engineer</label>
            <code>eng</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/egr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Engraver</label>
            <code>egr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/etr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Etcher</label>
            <code>etr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/evp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Event place</label>
            <code>evp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/exp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Expert</label>
            <code>exp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/fac</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Facsimilist</label>
            <code>fac</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/fld</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Field director</label>
            <code>fld</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/flm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Film editor</label>
            <code>flm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/fpy</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>First party</label>
            <code>fpy</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/frg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Forger</label>
            <code>frg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/fmo</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Former owner</label>
            <code>fmo</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/fnd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Funder</label>
            <code>fnd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/gis</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Geographic information specialist</label>
            <code>gis</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/hnr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Honoree</label>
            <code>hnr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/hst</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Host</label>
            <code>hst</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ilu</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Illuminator</label>
            <code>ilu</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ill</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Illustrator</label>
            <code>ill</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ins</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Inscriber</label>
            <code>ins</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/itr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Instrumentalist</label>
            <code>itr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ive</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Interviewee</label>
            <code>ive</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ivr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Interviewer</label>
            <code>ivr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/inv</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Inventor</label>
            <code>inv</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lbr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Laboratory</label>
            <code>lbr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ldr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Laboratory director</label>
            <code>ldr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/led</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Lead</label>
            <code>led</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lsa</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Landscape architect</label>
            <code>lsa</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/len</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Lender</label>
            <code>len</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lil</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelant</label>
            <code>lil</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lit</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelant-appellant</label>
            <code>lit</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lie</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelant-appellee</label>
            <code>lie</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lel</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelee</label>
            <code>lel</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/let</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelee-appellant</label>
            <code>let</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lee</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Libelee-appellee</label>
            <code>lee</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lbt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Librettist</label>
            <code>lbt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lse</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Licensee</label>
            <code>lse</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lso</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Licensor</label>
            <code>lso</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lgd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Lighting designer</label>
            <code>lgd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ltg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Lithographer</label>
            <code>ltg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/lyr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Lyricist</label>
            <code>lyr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mfr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Manufacturer</label>
            <code>mfr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mrb</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Marbler</label>
            <code>mrb</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mrk</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Markup editor</label>
            <code>mrk</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mdc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Metadata contact</label>
            <code>mdc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mte</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Metal-engraver</label>
            <code>mte</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mod</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Moderator</label>
            <code>mod</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mon</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Monitor</label>
            <code>mon</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mcp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Music copyist</label>
            <code>mcp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/msd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Musical director</label>
            <code>msd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/mus</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Musician</label>
            <code>mus</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/nrt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Narrator</label>
            <code>nrt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/opn</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Opponent</label>
            <code>opn</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/orm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Organizer of meeting</label>
            <code>orm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/org</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Originator</label>
            <code>org</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/oth</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Other</label>
            <code>oth</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/own</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Owner</label>
            <code>own</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ppm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Papermaker</label>
            <code>ppm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pta</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Patent applicant</label>
            <code>pta</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pth</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Patent holder</label>
            <code>pth</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pat</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Patron</label>
            <code>pat</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prf</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Performer</label>
            <code>prf</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pma</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Permitting agency</label>
            <code>pma</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pht</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Photographer</label>
            <code>pht</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ptf</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Plaintiff</label>
            <code>ptf</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ptt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Plaintiff-appellant</label>
            <code>ptt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pte</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Plaintiff-appellee</label>
            <code>pte</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/plt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Platemaker</label>
            <code>plt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Printer</label>
            <code>prt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pop</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Printer of plates</label>
            <code>pop</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Printmaker</label>
            <code>prm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Process contact</label>
            <code>prc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pro</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Producer</label>
            <code>pro</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pmm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Production manager</label>
            <code>pmm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Production personnel</label>
            <code>prd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/prg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Programmer</label>
            <code>prg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pdr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Project director</label>
            <code>pdr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pfr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Proofreader</label>
            <code>pfr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pup</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Publication place</label>
            <code>pup</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pbl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Publisher</label>
            <code>pbl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/pbd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Publishing director</label>
            <code>pbd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ppt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Puppeteer</label>
            <code>ppt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rcp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Recipient</label>
            <code>rcp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rce</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Recording engineer</label>
            <code>rce</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/red</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Redactor</label>
            <code>red</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ren</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Renderer</label>
            <code>ren</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rpt</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Reporter</label>
            <code>rpt</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rps</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Repository</label>
            <code>rps</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rth</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Research team head</label>
            <code>rth</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rtm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Research team member</label>
            <code>rtm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/res</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Researcher</label>
            <code>res</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rsp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Respondent</label>
            <code>rsp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rst</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Respondent-appellant</label>
            <code>rst</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rse</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Respondent-appellee</label>
            <code>rse</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rpy</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Responsible party</label>
            <code>rpy</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rsg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Restager</label>
            <code>rsg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rev</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Reviewer</label>
            <code>rev</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/rbr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Rubricator</label>
            <code>rbr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sce</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Scenarist</label>
            <code>sce</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sad</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Scientific advisor</label>
            <code>sad</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/scr</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Scribe</label>
            <code>scr</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/scl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Sculptor</label>
            <code>scl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/spy</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Second party</label>
            <code>spy</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sec</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Secretary</label>
            <code>sec</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/std</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Set designer</label>
            <code>std</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sgn</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Signer</label>
            <code>sgn</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sng</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Singer</label>
            <code>sng</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sds</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Sound designer</label>
            <code>sds</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/spk</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Speaker</label>
            <code>spk</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/spn</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Sponsor</label>
            <code>spn</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/stm</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Stage manager</label>
            <code>stm</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/stn</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Standards body</label>
            <code>stn</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/str</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Stereotyper</label>
            <code>str</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/stl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Storyteller</label>
            <code>stl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/sht</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Supporting host</label>
            <code>sht</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/srv</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Surveyor</label>
            <code>srv</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/tch</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Teacher</label>
            <code>tch</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/tcd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Technical director</label>
            <code>tcd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/ths</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Thesis advisor</label>
            <code>ths</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/trc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Transcriber</label>
            <code>trc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/trl</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Translator</label>
            <code>trl</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/tyd</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Type designer</label>
            <code>tyd</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/tyg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Typographer</label>
            <code>tyg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/uvp</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>University place</label>
            <code>uvp</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/vdg</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Videographer</label>
            <code>vdg</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/voc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Vocalist</label>
            <code>voc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/wit</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Witness</label>
            <code>wit</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/wde</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Wood-engraver</label>
            <code>wde</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/wdc</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Woodcutter</label>
            <code>wdc</code>
         </role>
         <role>
            <uri>http://id.loc.gov/vocabulary/relators/wam</uri>
            <ns>http://id.loc.gov/vocabulary/relators/</ns>
            <label>Writer of accompanying material</label>
            <code>wam</code>
         </role>
      </roles>
   </xsl:variable>
</xsl:stylesheet>
