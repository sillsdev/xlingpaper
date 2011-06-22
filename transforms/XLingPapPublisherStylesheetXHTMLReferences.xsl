<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo ">
    <xsl:variable name="authorForm" select="//publisherStyleSheet/backMatterLayout/referencesLayout/@authorform"/>
    <xsl:variable name="titleForm" select="//publisherStyleSheet/backMatterLayout/referencesLayout/@titleform"/>
    <xsl:variable name="iso639-3codeItem" select="//publisherStyleSheet/backMatterLayout/referencesLayout/iso639-3codeItem"/>
    <!--  
        DoAuthorLayout
    -->
    <xsl:template name="DoAuthorLayout">
        <xsl:param name="referencesLayoutInfo"/>
        <xsl:param name="work"/>
        <xsl:param name="works"/>
        <xsl:param name="iPos" select="'0'"/>
        <xsl:variable name="authorLayoutToUsePosition">
            <xsl:call-template name="GetAuthorLayoutToUsePosition">
                <xsl:with-param name="referencesLayoutInfo" select="$referencesLayoutInfo"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$authorLayoutToUsePosition=0 or string-length($authorLayoutToUsePosition)=0">
                <xsl:call-template name="ReportNoPatternMatched"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$referencesLayoutInfo/refAuthorLayouts/*[position()=$authorLayoutToUsePosition]">
                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="name(.)='refAuthorItem'">
                                <span>
                                    <xsl:attribute name="style">
                                        <xsl:call-template name="OutputFontAttributes">
                                            <xsl:with-param name="language" select="."/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                    </xsl:call-template>
                                    <xsl:variable name="sAuthorName">
                                        <xsl:choose>
                                            <xsl:when test="$referencesLayoutInfo/@uselineforrepeatedauthor='yes' and $iPos &gt; 1">
                                                <xsl:text>______</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$work/.."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:value-of select="$sAuthorName"/>
                                    <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                        <xsl:with-param name="sPrecedingText" select="$sAuthorName"/>
                                    </xsl:call-template>
                                </span>
                            </xsl:when>
                            <xsl:when test="name(.)='authorRoleItem'">
                                <span>
                                    <xsl:attribute name="style">
                                        <xsl:call-template name="OutputFontAttributes">
                                            <xsl:with-param name="language" select="."/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="$work/authorRole"/>
                                    <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                        <xsl:with-param name="sPrecedingText" select="$work/authorRole"/>
                                    </xsl:call-template>
                                </span>
                            </xsl:when>
                            <xsl:when test="name(.)='refDateItem'">
                                <span>
                                    <xsl:attribute name="style">
                                        <xsl:call-template name="OutputFontAttributes">
                                            <xsl:with-param name="language" select="."/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                    </xsl:call-template>
                                    <xsl:apply-templates select="$work/refDate">
                                        <xsl:with-param name="works" select="$works"/>
                                    </xsl:apply-templates>
                                    <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                                        <xsl:with-param name="layoutInfo" select="."/>
                                        <xsl:with-param name="sPrecedingText" select="$work/refDate"/>
                                    </xsl:call-template>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--  
        DoRefCitation
    -->
    <xsl:template name="DoRefCitation">
        <xsl:param name="citation"/>
        <xsl:for-each select="$citation">
            <xsl:variable name="refer" select="id(@refToBook)"/>
            <span>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@refToBook"/>
                    </xsl:attribute>
                    <xsl:call-template name="AddAnyLinkAttributes">
                        <xsl:with-param name="override" select="$pageLayoutInfo/linkLayout/citationLinkLayout"/>
                    </xsl:call-template>
                    <xsl:value-of select="$refer/../@citename"/>
                </a>
            </span>
        </xsl:for-each>
    </xsl:template>
    <!--  
        DoUrlLayout
    -->
    <xsl:template name="DoUrlLayout">
        <!-- remove any zero width spaces in the hyperlink -->
        <a href="url({normalize-space(translate(.,'&#x200b;',''))})">
            <xsl:call-template name="AddAnyLinkAttributes">
                <xsl:with-param name="override" select="$pageLayoutInfo/linkLayout/urlLinkLayout"/>
            </xsl:call-template>
            <!--            <xsl:text>&#x20;</xsl:text>-->
            <xsl:value-of select="normalize-space(.)"/>
        </a>
    </xsl:template>
    <!--  
        DoWebPageUrlItem
    -->
    <xsl:template name="DoWebPageUrlItem">
        <xsl:param name="webPage"/>
        <span>
            <xsl:attribute name="style">
                <xsl:call-template name="OutputFontAttributes">
                    <xsl:with-param name="language" select="."/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                <xsl:with-param name="layoutInfo" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="$webPage/url"/>
            <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                <xsl:with-param name="layoutInfo" select="."/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <!--  
      OutputISO639-3Code
   -->
    <xsl:template name="OutputISO639-3Code">
        <span>
            <xsl:attribute name="style">
                <xsl:call-template name="OutputFontAttributes">
                    <xsl:with-param name="language" select="$iso639-3codeItem"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:if test="position() = 1">
                <xsl:value-of select="$iso639-3codeItem/@textbeforefirst"/>
            </xsl:if>
            <xsl:value-of select="$iso639-3codeItem/@textbefore"/>
            <xsl:choose>
                <xsl:when test="$iso639-3codeItem/@case='uppercase'">
                    <xsl:value-of select="translate(.,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$iso639-3codeItem/@text"/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$iso639-3codeItem/@textbetween"/>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:value-of select="$iso639-3codeItem/@textafterlast"/>
            </xsl:if>
        </span>
    </xsl:template>
    <!--  
        OutputReferenceItem
    -->
    <xsl:template name="OutputReferenceItem">
        <xsl:param name="item"/>
        <span>
            <xsl:attribute name="style">
                <xsl:call-template name="OutputFontAttributes">
                    <xsl:with-param name="language" select="."/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                <xsl:with-param name="layoutInfo" select="."/>
            </xsl:call-template>
            <xsl:value-of select="$item"/>
            <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                <xsl:with-param name="layoutInfo" select="."/>
                <xsl:with-param name="sPrecedingText" select="$item"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <!--  
        OutputReferenceItemNode
    -->
    <xsl:template name="OutputReferenceItemNode">
        <xsl:param name="item"/>
        <span>
            <xsl:attribute name="style">
                <xsl:call-template name="OutputFontAttributes">
                    <xsl:with-param name="language" select="."/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="DoFormatLayoutInfoTextBefore">
                <xsl:with-param name="layoutInfo" select="."/>
            </xsl:call-template>
            <xsl:apply-templates select="$item">
                <xsl:with-param name="layout" select="."/>
            </xsl:apply-templates>
            <xsl:call-template name="DoFormatLayoutInfoTextAfter">
                <xsl:with-param name="layoutInfo" select="."/>
                <xsl:with-param name="sPrecedingText" select="normalize-space($item)"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <!--  
        ReportNoPatternMatched
    -->
    <xsl:template name="ReportNoPatternMatched">
        <span style="background-color:yellow;">Sorry, but there is no matching layout for this item in the publisher style sheet.  Please add  (or have someone add) the pattern.
            <xsl:call-template name="ReportPattern"/>
        </span>
    </xsl:template>
    <!--  
        ReportNoPatternMatchedForCollCitation
    -->
    <xsl:template name="ReportNoPatternMatchedForCollCitation">
        <xsl:param name="collCitation"/>
        <span style="background-color:yellow;">Sorry, but there is no matching layout for this item in the publisher style sheet.  Please add  (or have someone add) the pattern.
            <xsl:call-template name="ReportPatternForCollCitation">
                <xsl:with-param name="collCitation" select="$collCitation"/>
            </xsl:call-template>
        </span>
    </xsl:template>
    <!--  
        ReportNoPatternMatchedForProcCitation
    -->
    <xsl:template name="ReportNoPatternMatchedForProcCitation">
        <xsl:param name="procCitation"/>
        <span style="background-color:yellow;">Sorry, but there is no matching layout for this item in the publisher style sheet.  Please add  (or have someone add) the pattern.
            <xsl:call-template name="ReportPatternForProcCitation">
                <xsl:with-param name="procCitation" select="$procCitation"/>
            </xsl:call-template>
        </span>
    </xsl:template>
</xsl:stylesheet>