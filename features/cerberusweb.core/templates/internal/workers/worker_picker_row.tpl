<tr data-worker-id="{$worker->id}" data-score="{$worker->__responsibility}">
	<td>
		{if $worker->__is_online}
		<div style="display:inline-block;border-radius:10px;width:10px;height:10px;background-color:rgb(0,180,0);margin-right:5px;line-height:10px;"></div>
		{else}
		<div style="display:inline-block;border-radius:10px;width:10px;height:10px;background-color:rgb(230,230,230);margin-right:5px;line-height:10px;"></div>
		{/if}
		<img src="{devblocks_url}c=avatars&context=worker&context_id={$worker->id}{/devblocks_url}?v={$worker->updated}" style="height:25px;width:25px;border-radius:25px;" align="middle">
		<a href="javascript:;" class="item no-underline"><b>{$worker->getName()}</b></a>
		<small>{$worker->title}</small>
		{if $worker->__is_selected}
		<input type="hidden" name="current_sample[]" value="{$worker->id}">
		<input type="hidden" name="initial_sample[]" value="{$worker->id}">
		{/if}
	</td>
	<td nowrap="nowrap">
		<div>
			<!--
			{$availability = $worker->__availability}
			{foreach from=$availability.blocks item=block name=blocks}
			{var_dump($block)}
			--><div style="width:{{$block.length/$availability.ticks*100}|round}px;height:10px;{if $block.available}background-color:rgb(0,200,0);{else}background-color:rgb(230,230,230);{/if}display:inline-block;{if $smarty.foreach.blocks.first && $smarty.foreach.blocks.last}border-radius:10px;{elseif $smarty.foreach.blocks.first}border-radius:10px 0px 0px 10px;{elseif $smarty.foreach.blocks.last}border-radius:0px 10px 10px 0px;{/if}" title="{$block.start|devblocks_date} - {$block.end|devblocks_date}"></div><!--
			{/foreach}-->
		</div>
	</td>
	<td nowrap="nowrap">
		{$num_assignments = $worker->__workload.records.{CerberusContexts::CONTEXT_TICKET}|default:0 + $worker->__workload.records.{CerberusContexts::CONTEXT_TASK}|default:0}
		{$num_recommendations = $worker->__workload.records.{CerberusContexts::CONTEXT_RECOMMENDATION}|default:0}
		{$num_unread_notifications = $worker->__workload.records.{CerberusContexts::CONTEXT_NOTIFICATION}|default:0}
		
		{if $num_assignments}<span style="color:green;font-weight:bold;">{$num_assignments}</span>{else}0{/if}
		<span style="color:rgb(200,200,200);"> / </span>
		{if $num_recommendations}<span style="font-weight:bold;">{$num_recommendations}</span>{else}0{/if}
		<span style="color:rgb(200,200,200);"> / </span>
		{if $num_unread_notifications}<span style="color:red;font-weight:bold;">{$num_unread_notifications}</span>{else}0{/if}
	</td>
	{if $show_responsibilities}
	<td nowrap="nowrap">
		<div style="position:relative;margin:0px 5px;width:70px;height:10px;background-color:rgb(230,230,230);border-radius:10px;display:inline-block;">
			<span style="display:inline-block;background-color:rgb(200,200,200);height:14px;width:1px;position:absolute;top:-2px;margin-left:1px;left:50%;"></span>
			<div style="position:relative;margin-left:-6px;top:-2px;left:{$worker->__responsibility}%;width:14px;height:14px;border-radius:14px;background-color:{if $worker->__responsibility < 50}rgb(230,70,70);{elseif $worker->__responsibility > 50}rgb(0,200,0);{else}rgb(175,175,175);{/if}"></div>
		</div>
	</td>
	{/if}
	<td nowrap="nowrap">
		<a href="javascript:;" class="delete" {if !$worker->__is_selected}style="display:none;"{/if}><span class="glyphicons glyphicons-circle-remove" style="font-size:14px;color:rgb(200,0,0);"></span></a>
	</td>
</tr>