{$view_context = CerberusContexts::CONTEXT_WORKER}
{$view_fields = $view->getColumnsAvailable()}
{assign var=results value=$view->getData()}
{assign var=total value=$results[1]}
{assign var=data value=$results[0]}

{include file="devblocks:cerberusweb.core::internal/views/view_marquee.tpl" view=$view}

<table cellpadding="0" cellspacing="0" border="0" class="worklist" width="100%">
	<tr>
		<td nowrap="nowrap"><span class="title">{$view->name}</span></td>
		<td nowrap="nowrap" align="right" class="title-toolbar">
			{if $active_worker->is_superuser}<a href="javascript:;" title="{'common.add'|devblocks_translate|capitalize}" class="minimal" onclick="genericAjaxPopup('peek','c=config&a=handleSectionAction&section=workers&action=showWorkerPeek&id=0&view_id={$view->id|escape:'url'}',null,false,'500');"><span class="glyphicons glyphicons-circle-plus"></span></a>{/if}
			<a href="javascript:;" title="{'common.search'|devblocks_translate|capitalize}" class="minimal" onclick="genericAjaxPopup('search','c=internal&a=viewShowQuickSearchPopup&view_id={$view->id}',null,false,'400');"><span class="glyphicons glyphicons-search"></span></a>
			<a href="javascript:;" title="{'common.customize'|devblocks_translate|capitalize}" class="minimal" onclick="genericAjaxGet('customize{$view->id}','c=internal&a=viewCustomize&id={$view->id}');toggleDiv('customize{$view->id}','block');"><span class="glyphicons glyphicons-cogwheel"></span></a>
			<a href="javascript:;" title="{'common.subtotals'|devblocks_translate|capitalize}" class="subtotals minimal"><span class="glyphicons glyphicons-signal"></span></a>
			<a href="javascript:;" title="{'common.export'|devblocks_translate|capitalize}" class="minimal" onclick="genericAjaxGet('{$view->id}_tips','c=internal&a=viewShowExport&id={$view->id}');toggleDiv('{$view->id}_tips','block');"><span class="glyphicons glyphicons-file-export"></span></a>
			<a href="javascript:;" title="{'common.copy'|devblocks_translate|capitalize}" onclick="genericAjaxGet('{$view->id}_tips','c=internal&a=viewShowCopy&view_id={$view->id}');toggleDiv('{$view->id}_tips','block');"><span class="glyphicons glyphicons-duplicate"></span></a>
			<a href="javascript:;" title="{'common.refresh'|devblocks_translate|capitalize}" class="minimal" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewRefresh&id={$view->id}');"><span class="glyphicons glyphicons-refresh"></span></a>
			<input type="checkbox" class="select-all">
		</td>
	</tr>
</table>

<div id="{$view->id}_tips" class="block" style="display:none;margin:10px;padding:5px;">Loading...</div>
<form id="customize{$view->id}" name="customize{$view->id}" action="#" onsubmit="return false;" style="display:none;"></form>
<form id="viewForm{$view->id}" name="viewForm{$view->id}" action="{devblocks_url}{/devblocks_url}" method="post">
<input type="hidden" name="view_id" value="{$view->id}">
<input type="hidden" name="context_id" value="{$view_context}">
<input type="hidden" name="c" value="profiles">
<input type="hidden" name="a" value="handleSectionAction">
<input type="hidden" name="section" value="worker">
<input type="hidden" name="action" value="">
<input type="hidden" name="explore_from" value="0">
<input type="hidden" name="_csrf_token" value="{$session.csrf_token}">

<table cellpadding="2" cellspacing="0" border="0" width="100%" class="worklistBody">

	{* Column Headers *}
	<thead>
	<tr>
		<th class="no-sort" style="text-align:center;width:40px;padding-left:0;padding-right:0;" title="{'common.photo'|devblocks_translate|capitalize}">
			<span class="glyphicons glyphicons-camera" style="color:rgb(80,80,80);"></span>
		</th>
	
		{foreach from=$view->view_columns item=header name=headers}
			{* start table header, insert column title and link *}
			<th class="{if $view->options.disable_sorting}no-sort{/if}">
			{if !$view->options.disable_sorting && !empty($view_fields.$header->db_column)}
				<a href="javascript:;" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewSortBy&id={$view->id}&sortBy={$header}');">{$view_fields.$header->db_label|capitalize}</a>
			{else}
				<a href="javascript:;" style="text-decoration:none;">{$view_fields.$header->db_label|capitalize}</a>
			{/if}
			
			{* add arrow if sorting by this column, finish table header tag *}
			{if $header==$view->renderSortBy}
				<span class="glyphicons {if $view->renderSortAsc}glyphicons-sort-by-attributes{else}glyphicons-sort-by-attributes-alt{/if}" style="font-size:14px;{if $view->options.disable_sorting}color:rgb(80,80,80);{else}color:rgb(39,123,213);{/if}"></span>
			{/if}
			</th>
		{/foreach}
	</tr>
	</thead>

	{* Column Data *}
	{foreach from=$data item=result key=idx name=results}

	{if $smarty.foreach.results.iteration % 2}
		{assign var=tableRowClass value="even"}
	{else}
		{assign var=tableRowClass value="odd"}
	{/if}
	<tbody style="cursor:pointer;">
		<tr class="{$tableRowClass}">
			<td align="center" rowspan="2" nowrap="nowrap" style="padding:5px;">
				<img src="{devblocks_url}c=avatars&context=worker&context_id={$result.w_id}{/devblocks_url}?v={$result.w_updated}" style="height:32px;width:32px;border-radius:16px;vertical-align:middle;">
			</td>
			<td colspan="{$smarty.foreach.headers.total}">
				{$worker_name = "{$result.w_first_name}{if !empty($result.w_last_name)} {$result.w_last_name}{/if}"}
				<input type="checkbox" name="row_id[]" value="{$result.w_id}" style="display:none;">
				<a href="{devblocks_url}c=profiles&a=worker&id={$result.w_id}-{$worker_name|devblocks_permalink}{/devblocks_url}" class="subject">{if $result.w_is_disabled}<strike>{$worker_name}</strike>{else}{$worker_name}{/if}</a>
				{if $active_worker->is_superuser}<button type="button" class="peek" onclick="genericAjaxPopup('peek','c=config&a=handleSectionAction&section=workers&action=showWorkerPeek&id={$result.w_id}&view_id={$view->id|escape:'url'}',null,false,'550');"><span class="glyphicons glyphicons-new-window-alt"></span></button>{/if}
			</td>
		</tr>
		<tr class="{$tableRowClass}">
		{foreach from=$view->view_columns item=column name=columns}
			{if substr($column,0,3)=="cf_"}
				{include file="devblocks:cerberusweb.core::internal/custom_fields/view/cell_renderer.tpl"}
			{elseif $column=="w_is_disabled"}
				<td>{if $result.w_is_disabled}{'common.yes'|devblocks_translate|capitalize}{else}{'common.no'|devblocks_translate|capitalize}{/if}</td>
			{elseif $column=="w_is_superuser"}
				<td>{if $result.w_is_superuser}{'common.yes'|devblocks_translate|capitalize}{else}{'common.no'|devblocks_translate|capitalize}{/if}</td>
			{elseif $column=="w_email"}
				<td><a href="javascript:;" onclick="genericAjaxPopup('peek','c=internal&a=showPeekPopup&context={CerberusContexts::CONTEXT_ADDRESS}&email={$result.w_email|escape:'url'}&view_id={$view->id}',null,false,'500');" title="{$result.w_email}">{$result.w_email|truncate:64:'...':true:true}</a></td>
			<td>
				{if $result.$column == 'M'}
				<span class="glyphicons glyphicons-male"></span>
				{elseif $result.$column == 'F'}
				<span class="glyphicons glyphicons-female"></span>
				{else}
				{/if}
			</td>
			{elseif $column=="w_calendar_id"}
				<td>
				{if $result.$column}
					{$calendar = DAO_Calendar::get($result.$column)}
					{if $calendar}
						<a href="javascript:;" onclick="genericAjaxPopup('peek','c=internal&a=showPeekPopup&context={CerberusContexts::CONTEXT_CALENDAR}&context_id={$calendar->id}&view_id={$view->id}',null,false,'500');" title="{$calendar->name}">{$calendar->name|truncate:64:'...':true:true}</a>
					{/if}
				{/if}
				</td>
			{elseif in_array($column, ['w_last_activity_date', 'w_updated'])}
				{if !empty($result.$column)}
				<td title="{$result.$column|devblocks_date}">{$result.$column|devblocks_prettytime}</td>
				{else}
				<td>never</td>
				{/if}
			{elseif $column=="w_auth_extension_id"}
				<td>
					{if isset($auth_extensions.{$result.$column})}
						{$auth_ext = $auth_extensions.{$result.$column}}
						{$auth_ext->name}
					{/if}
				</td>
			{else}
			<td>{$result.$column}</td>
			{/if}
		{/foreach}
		</tr>
	</tbody>
	{/foreach}
</table>

<div style="padding-top:5px;">
	<div style="float:right;">
		{math assign=fromRow equation="(x*y)+1" x=$view->renderPage y=$view->renderLimit}
		{math assign=toRow equation="(x-1)+y" x=$fromRow y=$view->renderLimit}
		{math assign=nextPage equation="x+1" x=$view->renderPage}
		{math assign=prevPage equation="x-1" x=$view->renderPage}
		{math assign=lastPage equation="ceil(x/y)-1" x=$total y=$view->renderLimit}
		
		{* Sanity checks *}
		{if $toRow > $total}{assign var=toRow value=$total}{/if}
		{if $fromRow > $toRow}{assign var=fromRow value=$toRow}{/if}
		
		{if $view->renderPage > 0}
			<a href="javascript:;" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewPage&id={$view->id}&page=0');">&lt;&lt;</a>
			<a href="javascript:;" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewPage&id={$view->id}&page={$prevPage}');">&lt;{'common.previous_short'|devblocks_translate|capitalize}</a>
		{/if}
		({'views.showing_from_to'|devblocks_translate:$fromRow:$toRow:$total})
		{if $toRow < $total}
			<a href="javascript:;" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewPage&id={$view->id}&page={$nextPage}');">{'common.next'|devblocks_translate|capitalize}&gt;</a>
			<a href="javascript:;" onclick="genericAjaxGet('view{$view->id}','c=internal&a=viewPage&id={$view->id}&page={$lastPage}');">&gt;&gt;</a>
		{/if}
	</div>
	
	{if $total}
	<div style="float:left;" id="{$view->id}_actions">
		<button type="button" class="action-always-show action-explore"><span class="glyphicons glyphicons-play-button"></span> {'common.explore'|devblocks_translate|lower}</button>
		{if $active_worker && $active_worker->is_superuser}
			<button type="button" class="action-always-show action-bulkupdate" onclick="genericAjaxPopup('peek','c=config&a=handleSectionAction&section=workers&action=showWorkersBulkPanel&view_id={$view->id}&ids=' + Devblocks.getFormEnabledCheckboxValues('viewForm{$view->id}','row_id[]'),null,false,'500');"><span class="glyphicons glyphicons-folder-closed"></span></a> bulk update</button>
		{/if}
	</div>
	{/if}
</div>

<div style="clear:both;"></div>

</form>

{include file="devblocks:cerberusweb.core::internal/views/view_common_jquery_ui.tpl"}

<script type="text/javascript">
var $frm = $('#viewForm{$view->id}');
var $frm_actions = $('#{$view->id}_actions');

$frm_actions.find('button.action-explore').click(function() {
	var checkedId = $frm.find('tbody input:checkbox:checked:first').val();
	$frm.find('input:hidden[name=explore_from]').val(checkedId);
	
	$frm.find('input:hidden[name=action]').val('viewExplore');
	$frm.submit();
});

{if $pref_keyboard_shortcuts}
$frm.bind('keyboard_shortcut',function(event) {
	//console.log("{$view->id} received " + (indirect ? 'indirect' : 'direct') + " keyboard event for: " + event.keypress_event.which);
	
	var $view_actions = $('#{$view->id}_actions');
	
	var hotkey_activated = true;

	switch(event.keypress_event.which) {
		case 98: // (b) bulk update
			var $btn = $view_actions.find('button.action-bulkupdate');
		
			if(event.indirect) {
				$btn.select().focus();
				
			} else {
				$btn.click();
			}
			break;
		
		default:
			hotkey_activated = false;
			break;
	}

	if(hotkey_activated)
		event.preventDefault();
});
{/if}
</script>