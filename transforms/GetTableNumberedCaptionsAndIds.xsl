<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//tablenumbered">
            <xsl:sort select="caption | endCaption"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="//tablenumbered">
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when test="string-length(table/caption) + string-length(table/endCaption) &gt; 0">
                <xsl:value-of select="table/caption | table/endCaption"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@id"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> {</xsl:text>
        <xsl:value-of select="@id"/>
                <xsl:text>}"
</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
