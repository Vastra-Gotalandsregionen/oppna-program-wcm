<#setting locale=locale>

<#assign liferay_ui = taglibLiferayHash["/WEB-INF/tld/liferay-ui.tld"] />
<#assign liferay_util = taglibLiferayHash["/WEB-INF/tld/liferay-util.tld"] />

<#assign liferay_portlet = taglibLiferayHash["/WEB-INF/tld/liferay-portlet.tld"] />

<#assign page = themeDisplay.getLayout() />
<#assign group_id = page.getGroupId() />
<#assign company_id = themeDisplay.getCompanyId() />

<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.service.LayoutLocalService")>
<#assign layoutSetLocalService = serviceLocator.findService("com.liferay.portal.service.LayoutSetLocalService")>

<#assign blogsPortletId = "33" />
<#assign blogsPagePlid = portalUtil.getPlidFromPortletId(group_id, page.isPrivateLayout(), blogsPortletId) />
<#assign blogsLayout = layoutLocalService.getLayout(blogsPagePlid) />

<#assign urlPrefix = getUrlPrefix(themeDisplay.getScopeGroup(), themeDisplay.getPlid()) />
<#assign blogPageFriendlyUrl = urlPrefix + blogsLayout.getFriendlyURL(locale) />
<#assign blogEntryFriendlyUrlPrefix = "/-/blogs/" />

<#assign entrySummaryMaxChars = 100 />
<#assign entryTitleMaxChars = 50 />

<div class="vgr-boxed-content recent-blog-entries">
  <div class="hd">
    <span>Nyhetsblogg</span>
  </div>
  <div class="bd">
    <#if entries?has_content>
      <div class="vgr-list-view-wrap">
  		    <ul class="vgr-list-view vgr-list-view-condensed">
            <#assign ticker = 0 />
            <#list entries as entry>

              <#assign assetRenderer = entry.getAssetRenderer() />
      				<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />

      				<#if assetLinkBehavior != "showFullContent">
      					<#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
      				</#if>

              <#assign viewURL = blogPageFriendlyUrl + blogEntryFriendlyUrlPrefix + assetRenderer.getUrlTitle() />

              <#assign listItemCssClass = "vgr-list-view-item" />

              <#if ticker % 2 != 0>
                <#assign listItemCssClass = listItemCssClass + " vgr-list-view-item-odd" />
              </#if>

              <#if ticker+1 == entries?size >
                <#assign listItemCssClass = listItemCssClass + " vgr-list-view-item-last" />
              </#if>

              <#assign titleEscaped = htmlUtil.escape(entry.getTitle(locale)) />
              <#assign entryTitle = ellipsis(titleEscaped, entryTitleMaxChars) />

              <#assign summaryEscaped = htmlUtil.escape(entry.getSummary(locale)) />
              <#assign entrySummary = ellipsis(summaryEscaped, entrySummaryMaxChars) />

              <li class="${listItemCssClass}">
                <div class="hd clearfix">
                  <h3 class="title">
                    <a href="${viewURL}">
                      ${entryTitle}
                    </a>
                  </h3>
                </div>
                <div class="bd">
                    ${entrySummary}
                </div>
                <div class="ft">
                  ${dateUtil.getDate(entry.getPublishDate(), "yyyy-MM-dd", locale)}
                </div>
              </li>
              <#assign ticker = ticker + 1 />
            </#list>
          </ul>
      </div>
      <div class="rp-link-wrap rp-link-wrap-last rp-link-wrap-right">
        <a class="rp-link" href="${blogPageFriendlyUrl}">
          <span>Fler blogginl&auml;gg</span>
        </a>
      </div>
    </#if>
  </div>
</div>

<#function ellipsis myString maxChars>
  <#if myString?length gt maxChars>
    <#return myString?substring(0, maxChars) + "..." />
  <#else>
    <#return myString />
  </#if>
</#function>

<#--
	Macro getUrlPrefix
	Parameter request = the request object for the freemarker context.
	Returns urlPrefix for links.
	If no virtual host exists then the urlPrefix will be for example on the form "/web/guest". Else urlPrefix will be blank
-->
<#function getUrlPrefix scopeGroup scopePlid>
	<#local urlPrefix = "" />

  <#local scopeGroupId =  scopeGroup.getGroupId() />
	<#local scopeLayout =  layoutLocalService.getLayout(scopePlid) />

	<#local scopeLayoutSet =  layoutSetLocalService.getLayoutSet(scopeGroupId, scopeLayout.isPrivateLayout()) />
	<#local scopeLayoutSetVirtualHost = scopeLayoutSet.getVirtualHostname() />
	<#local hasVirtualHost =  false />

	<#if scopeLayoutSetVirtualHost != "">
		<#local hasVirtualHost =  true />
	</#if>

	<#if !hasVirtualHost>
		<#if scopeLayout.isPrivateLayout()>
			<#local urlPrefix =  "/group" />
		<#else>
			<#local urlPrefix =  "/web" />
		</#if>

		<#local urlPrefix =  urlPrefix + scopeGroup.getFriendlyURL() />
	</#if>

	<#return urlPrefix />
</#function>
