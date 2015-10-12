<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" indent="no"/>

  <xsl:param name="stylesheet" select="'../styles/dark.xml'"/>

  <xsl:variable name="stylesheetName">
    <xsl:choose>
      <xsl:when test="document($stylesheet)">
        <xsl:value-of select="$stylesheet"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../styles/', $stylesheet, '.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="style" select="document($stylesheetName)/стиль"/>

  <xsl:template match="пелевин">
    strict graph {
      overlap="<xsl:value-of select="$style/общий/сжатие"/>"
      splines="true"

      bgcolor="<xsl:value-of select="$style/общий/фон"/>"

      edge [
        color="<xsl:value-of select="$style/общий/ребра/цвет"/>"
        penwidth="<xsl:value-of select="$style/общий/ребра/карандаш"/>"
      ]
      node [
        fontsize="<xsl:value-of select="$style/общий/шрифт/размер"/>"
        fontname="<xsl:value-of select="$style/общий/шрифт/название"/>"
        penwidth="<xsl:value-of select="$style/общий/вершины/карандаш"/>"
      ]

      <xsl:apply-templates/>
      <xsl:call-template name="строить-связи"/>
    }
  </xsl:template>

  <xsl:template match="произведения">
    subgraph {
      node [
        shape="<xsl:value-of select="$style/произведения/форма"/>"
        penwidth="<xsl:value-of select="$style/произведения/карандаш"/>"
        style="<xsl:value-of select="$style/произведения/стиль"/>"
        fillcolor="<xsl:value-of select="$style/произведения/заливка"/>"
        color="<xsl:value-of select="$style/произведения/цвет"/>"
        fontcolor="<xsl:value-of select="$style/произведения/шрифт/цвет"/>"
      ]

      <xsl:for-each select="сущность">
        "<xsl:value-of select="название"/>"

        <xsl:variable name="name">
          <xsl:value-of select="название"/>

          <xsl:choose>
            <xsl:when test="'true' = string($style/произведения/информация/жанр) and 'true' = string($style/произведения/информация/публикация)">
              \n(<xsl:value-of select="жанр"/>, <xsl:value-of select="публикация"/>)
            </xsl:when>
            <xsl:when test="'true' = string($style/связи/произведения/информация/публикация)">
              \n(<xsl:value-of select="публикация"/>)
            </xsl:when>
            <xsl:when test="'true' = string($style/связи/произведения/информация/жанр)">
              \n(<xsl:value-of select="жанр"/>)
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        [
          label="<xsl:value-of select="normalize-space($name)"/>"
        ]

        <xsl:if test="примечание = 'новое'">
          [
            color="<xsl:value-of select="$style/произведения/новое/цвет"/>"
          ]
        </xsl:if>
      </xsl:for-each>
    }
  </xsl:template>

  <xsl:template match="связи">
    subgraph {
      node [
        shape="<xsl:value-of select="$style/связи/персонажи/форма"/>"
        style="<xsl:value-of select="$style/связи/персонажи/стиль"/>"
        color="<xsl:value-of select="$style/связи/персонажи/цвет"/>"
        fontcolor="<xsl:value-of select="$style/связи/персонажи/шрифт/цвет"/>"
        fillcolor="<xsl:value-of select="$style/связи/персонажи/заливка"/>"
      ]

      <xsl:for-each select="сущность">
        "<xsl:value-of select="название"/>"

        <xsl:if test="тип = 'явление'">
          [
            shape="<xsl:value-of select="$style/связи/явления/форма"/>"
            style="<xsl:value-of select="$style/связи/явления/стиль"/>"
            color="<xsl:value-of select="$style/связи/явления/цвет"/>"
            fontcolor="<xsl:value-of select="$style/связи/явления/шрифт/цвет"/>"
            fillcolor="<xsl:value-of select="$style/связи/явления/заливка"/>"
          ]
        </xsl:if>
      </xsl:for-each>
    }
  </xsl:template>

  <xsl:template name="строить-связи">
    <xsl:for-each select="//произведения/сущность">
      <xsl:variable name="название"><xsl:value-of select="название"/></xsl:variable>
      <xsl:variable name="примечание"><xsl:value-of select="примечание"/></xsl:variable>

      <xsl:for-each select="//связь[text() = current()/название]/../..">
        "<xsl:value-of select="$название"/>" -- "<xsl:value-of select="название"/>"

        <xsl:if test="статус = 'гипотеза'">
          [
            penwidth="<xsl:value-of select="$style/связи/гипотеза/ребра/карандаш"/>"
            color="<xsl:value-of select="$style/связи/гипотеза/ребра/цвет"/>"
          ]

          "<xsl:value-of select="название"/>"
          [
            penwidth="<xsl:value-of select="$style/связи/гипотеза/вершины/карандаш"/>"
            style="<xsl:value-of select="$style/связи/гипотеза/вершины/стиль"/>"
          ]
        </xsl:if>

        <xsl:if test="примечание = 'новое' and $примечание = 'новое'">
          "<xsl:value-of select="$название"/>" -- "<xsl:value-of select="название"/>"
          [
            color="<xsl:value-of select="$style/связи/новое/ребра/цвет"/>"
          ]

          "<xsl:value-of select="название"/>"
          [
            color="<xsl:value-of select="$style/связи/новое/вершины/цвет"/>"
          ]
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text()"/>
</xsl:stylesheet>
