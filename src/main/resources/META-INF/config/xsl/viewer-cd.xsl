<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:c="http://baxter-it.com/config/component" xmlns:conf="http://baxter-it.com/config" xmlns:log="http://baxter-it.com/config/log"
    xmlns:j="http://baxter-it.com/config/jvm" xmlns:ini="http://baxter-it.com/currency-dealing/conf/generic-properties"
    exclude-result-prefixes="xs c conf log j ini" version="2.0">

    <xsl:import href="baxterxsl:repo-base.xsl" />
    <xsl:import href="baxterxsl:viewer.xsl" />
    <xsl:import href="baxterxsl:conf-reference.xsl" />

    <xsl:param name="configurationProductId" />

    <xsl:template name="product-title">
        <xsl:text>Currency Dealing</xsl:text>
    </xsl:template>

    <xsl:template name="load-sources">
        <xsl:apply-templates select="conf:configuration-source/conf:request" mode="load-document-with-variants">
            <xsl:with-param name="prefix" select="'jvm'" />
        </xsl:apply-templates>
        <xsl:apply-templates select="conf:configuration-source/conf:request" mode="load-document-with-variants">
            <xsl:with-param name="prefix" select="'log'" />
        </xsl:apply-templates>
        <xsl:apply-templates select="conf:configuration-source/conf:request" mode="load-document-with-variants">
            <xsl:with-param name="prefix" select="'ini'" />
        </xsl:apply-templates>
        <conf:samples>
            <conf:reference id="jvmConfigUnix" type="jvm">
                <conf:parameter name="osfamily">unix</conf:parameter>
            </conf:reference>
            <conf:reference id="iniConfigSample" type="ini" />
            <conf:reference id="statConfigSample" type="statistics" />
            <conf:reference id="classpathConfigSample" type="classpath" />
        </conf:samples>
        <conf:instances>
            <xsl:apply-templates select="conf:configuration-source/conf:request/conf:parameter[@id='cd-stp']"
                mode="instances" />
            <xsl:apply-templates select="conf:configuration-source/conf:request/conf:parameter[@id='cd-mm-doc']"
                mode="instances" />
            <xsl:apply-templates select="conf:configuration-source/conf:request/conf:parameter[@id='cd-mm-tbc']"
                mode="instances" />
            <xsl:apply-templates select="conf:configuration-source/conf:request/conf:parameter[@id='cd-mm-bab']"
                mode="instances" />
            <xsl:apply-templates select="conf:configuration-source/conf:request/conf:parameter[@id='cd-mm-rum']"
                mode="instances" />
        </conf:instances>
        <c:components>
            <c:component id="cd-appserver" title="JBossAS">
                <conf:statistics />
            </c:component>
            <c:component id="cd-oh" title="FixOH">
                <conf:statistics />
            </c:component>
            <c:component id="cd-mv" title="FixMV">
                <conf:statistics />
            </c:component>
            <c:component id="cd-me" title="MatchingEngine">
                <conf:statistics />
            </c:component>
            <c:component id="cd-stp" title="Straight Through Processing"></c:component>
            <c:component id="cd-mm-doc" title="DOC MarketMaker">
                <conf:statistics />
                <conf:classpath />
            </c:component>
            <c:component id="cd-mm-tbc" title="TBC MarketMaker">
                <conf:statistics />
                <conf:classpath />
            </c:component>
            <c:component id="cd-mm-bab" title="BAB MarketMaker"></c:component>
            <c:component id="cd-mm-rum" title="RUM MarketMaker">
                <conf:statistics />
                <conf:classpath />
            </c:component>
            <c:component id="cd-umr" title="User Message Register"></c:component>
            <c:component id="cd-cdts" title="Trade Supervisor"></c:component>
            <c:component id="cd-evoc" title="Expired Validity OrderChecker"></c:component>
            <c:component id="cd-mv-cpp" title="MarketView C++ Server"></c:component>
            <c:component id="cd-pt" title="Price Table"></c:component>
            <c:component id="cd-cg" title="Chart Generator"></c:component>
            <c:component id="cd-revaluator" title="Revaluator"></c:component>
            <c:component id="cd-tds" title="Traderdeck Service"></c:component>
            <c:component id="cd-blazeds" title="BlazeDS"></c:component>
            <c:component id="cd-cpro" title="CPro"></c:component>
            <c:component id="cd-devel-mmtc" title="MMTC (devel)"></c:component>
            <c:component id="cd-abos-message-listener" title="ABOS Message Listener"></c:component>
            <c:component id="cd-algo" title="Algo Component"></c:component>
            <c:component id="cd-cdip" title="Billing tools for Currency Dealing"></c:component>
        </c:components>
    </xsl:template>

    <xsl:template match="conf:parameter" mode="instances">
        <xsl:param name="line" select="." />
        <xsl:param name="separator" select="','" />
        <xsl:if test="not(empty($line) or (''=$line))">
            <xsl:choose>
                <xsl:when test="not(contains($line, $separator))">
                    <c:component>
                        <xsl:attribute name="id" select="@id" />
                        <xsl:attribute name="instance" select="normalize-space($line)" />
                    </c:component>
                </xsl:when>
                <xsl:otherwise>
                    <c:component>
                        <xsl:attribute name="id" select="@id" />
                        <xsl:attribute name="instance" select="normalize-space(substring-before($line, $separator))" />
                    </c:component>
                    <xsl:apply-templates select="." mode="instances">
                        <xsl:with-param name="line" select="substring-after($line, $separator)" />
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="css">
        table.list {
        border: none;
        background-color: #010101;
        border-spacing:1;
        border-collapse:collapse;
        }
        table.list th {
        background-color: #080808;
        color: #FFFFFF;
        padding-left: 6px;
        padding-right: 6px;
        align: center;
        }
        table.list td {
        background-color: #EFEFEF;
        padding: 3px;
        border-bottom: 1px solid #010101;
        align: center;
        }
    </xsl:template>

    <xsl:template name="form">
        <table border="1">
            <thead>
                <tr>
                    <th>Component type</th>
                    <th>Effective instances</th>
                    <th>New instances</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>DOC MarketMaker</td>
                    <td>
                        <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-doc']" />
                    </td>
                    <td>
                        <input type="text" name="cd-mm-doc">
                            <xsl:attribute name="value">
                                <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-doc']" />
                            </xsl:attribute>
                        </input>
                    </td>
                </tr>
                <tr>
                    <td>TBC MarketMaker</td>
                    <td>
                        <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-tbc']" />
                    </td>
                    <td>
                        <input type="text" name="cd-mm-tbc">
                            <xsl:attribute name="value">
                                <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-tbc']" />
                            </xsl:attribute>
                        </input>
                    </td>
                </tr>
                <tr>
                    <td>BAB MarketMaker</td>
                    <td>
                        <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-bab']" />
                    </td>
                    <td>
                        <input type="text" name="cd-mm-bab">
                            <xsl:attribute name="value">
                                <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-bab']" />
                            </xsl:attribute>
                        </input>
                    </td>
                </tr>
                <tr>
                    <td>RUM MarketMaker</td>
                    <td>
                        <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-rum']" />
                    </td>
                    <td>
                        <input type="text" name="cd-mm-rum">
                            <xsl:attribute name="value">
                               <xsl:value-of select="/conf:request/conf:parameter[@id='cd-mm-rum']" />
                            </xsl:attribute>
                        </input>
                    </td>
                </tr>
                <tr>
                    <td>STP</td>
                    <td>
                        <xsl:value-of select="/conf:request/conf:parameter[@id='cd-stp']" />
                    </td>
                    <td>
                        <input type="text" name="cd-stp">
                            <xsl:attribute name="value">
                               <xsl:value-of select="/conf:request/conf:parameter[@id='cd-stp']" />
                            </xsl:attribute>
                        </input>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="conf:request">
        <xsl:apply-imports />

        <p>Following matrix shows you the common used configurations for CD components:</p>

        <table class="list">

            <thead>
                <tr>
                    <th>Component \ Configuration</th>
                    <th>JVM</th>
                    <th>Logging</th>
                    <th>INI</th>
                    <th>Statistics</th>
                    <th>Ext.Classpath</th>
                </tr>
            </thead>

            <tbody>

                <xsl:apply-templates select="/c:components/c:component[not(@id=/conf:instances/c:component/@id)]"
                    mode="component-row" />

                <!-- this covers following -->
                <!-- : cd-mm-doc -->
                <!-- : cd-mm-rum -->
                <!-- : cd-mm-tbc -->
                <!-- : cd-mm-bab -->
                <!-- : cd-stp -->
                <xsl:apply-templates select="/conf:instances/c:component" mode="component-row" />

            </tbody>

        </table>


    </xsl:template>

    <xsl:template match="c:component" mode="component-row">
        <tr>
            <td>
                <xsl:choose>
                    <xsl:when test="/c:components/c:component[@id=current()/@id]">
                        <xsl:value-of select="/c:components/c:component[@id=current()/@id]/@title" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@id" />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@instance">
                    <xsl:text> : </xsl:text>
                    <xsl:value-of select="@instance" />
                </xsl:if>
            </td>
            <td>
                <xsl:apply-templates select="." mode="jvm" />
            </td>
            <td>
                <xsl:apply-templates select="." mode="log" />
            </td>
            <td>
                <xsl:apply-templates select="." mode="ini" />
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="/c:components/c:component[@id=current()/@id]/conf:statistics">
                        <xsl:apply-templates select="." mode="stat" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>-</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="/c:components/c:component[@id=current()/@id]/conf:classpath">
                        <xsl:apply-templates select="." mode="classpath" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>-</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="/conf:instances/c:component" mode="jvm">
        <xsl:variable name="jvmConfig">
            <xsl:copy-of select="/conf:request" />
            <conf:reference type="jvm">
                <xsl:attribute name="componentId" select="@id" />
                <conf:parameter name="osfamily">unix</conf:parameter>
                <xsl:copy-of select="/conf:request/conf:variant" />
                <conf:variant>
                    <xsl:attribute name="id" select="@instance" />
                </conf:variant>
            </conf:reference>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="$jvmConfig/conf:reference" mode="url" />
            </xsl:attribute>
            <xsl:value-of select="@instance" />
            <xsl:text>.jvm@unix</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="c:component" mode="jvm">
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/conf:samples/conf:reference[@id='jvmConfigUnix']"
                mode="url">
                    <xsl:with-param name="componentId" select="@id" />
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:text>jvm@unix</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="/conf:instances/c:component" mode="log">
        <xsl:if test="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference">
            <xsl:variable name="ref">
                <xsl:copy-of select="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference" />
            </xsl:variable>
            <xsl:variable name="logConfig">
                <xsl:copy-of select="/conf:request" />
                <conf:reference>
                    <xsl:attribute name="type" select="$ref/conf:reference/@type" />
                    <xsl:attribute name="componentId" select="@id" />
                    <conf:parameter>
                        <xsl:attribute name="name" select="'alias'" />
                        <xsl:value-of select="$ref/conf:reference/conf:parameter[@name='alias']/text()" />
                    </conf:parameter>
                    <xsl:copy-of select="/conf:request/conf:variant" />
                    <conf:variant>
                        <xsl:attribute name="id" select="@instance" />
                    </conf:variant>
                </conf:reference>
            </xsl:variable>
            <a>
                <xsl:attribute name="href">
                    <xsl:apply-templates select="$logConfig/conf:reference" mode="url" />
                </xsl:attribute>
                <xsl:value-of select="$ref/conf:reference/conf:parameter[@name='alias']/text()" />
            </a>
        </xsl:if>
    </xsl:template>

    <xsl:template match="c:component" mode="log">
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference"
                mode="url">
                    <xsl:with-param name="componentId" select="@id" />
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when
                    test="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference/conf:parameter[@name='alias']">
                    <xsl:value-of
                        select="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference/conf:parameter" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/j:configuration/j:logging[c:component/@id=current()/@id]/conf:reference/@type" />
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>

    <xsl:template match="/conf:instances/c:component" mode="ini">
        <xsl:variable name="iniConfig">
            <xsl:copy-of select="/conf:request" />
            <conf:reference type="ini">
                <xsl:attribute name="componentId" select="@id" />
                <xsl:copy-of select="/conf:request/conf:variant" />
                <conf:variant>
                    <xsl:attribute name="id" select="@instance" />
                </conf:variant>
            </conf:reference>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="$iniConfig/conf:reference" mode="url" />
            </xsl:attribute>
            <xsl:value-of select="@instance" />
            <xsl:text>.ini</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="c:component" mode="ini">
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/conf:samples/conf:reference[@id='iniConfigSample']"
                mode="url">
                    <xsl:with-param name="componentId" select="@id" />
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:text>ini</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="/conf:instances/c:component" mode="stat">
        <xsl:variable name="statConfig">
            <xsl:copy-of select="/conf:request" />
            <conf:reference type="statistics">
                <xsl:attribute name="componentId" select="@id" />
                <xsl:copy-of select="/conf:request/conf:variant" />
                <conf:variant>
                    <xsl:attribute name="id" select="@instance" />
                </conf:variant>
            </conf:reference>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="$statConfig/conf:reference" mode="url" />
            </xsl:attribute>
            <xsl:value-of select="@instance" />
            <xsl:text>.statistics</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="c:component" mode="stat">
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/conf:samples/conf:reference[@id='statConfigSample']"
                mode="url">
                    <xsl:with-param name="componentId" select="@id" />
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:text>statistics</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="/conf:instances/c:component" mode="classpath">
        <xsl:variable name="classpathConfig">
            <xsl:copy-of select="/conf:request" />
            <conf:reference type="classpath">
                <xsl:attribute name="componentId" select="@id" />
                <xsl:copy-of select="/conf:request/conf:variant" />
                <conf:variant>
                    <xsl:attribute name="id" select="@instance" />
                </conf:variant>
            </conf:reference>
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="$classpathConfig/conf:reference" mode="url" />
            </xsl:attribute>
            <xsl:value-of select="@instance" />
            <xsl:text>.classpath</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="c:component" mode="classpath">
        <a>
            <xsl:attribute name="href">
                <xsl:apply-templates select="/conf:samples/conf:reference[@id='classpathConfigSample']"
                mode="url">
                    <xsl:with-param name="componentId" select="@id" />
                </xsl:apply-templates>
            </xsl:attribute>
            <xsl:text>classpath</xsl:text>
        </a>
    </xsl:template>

</xsl:stylesheet>
