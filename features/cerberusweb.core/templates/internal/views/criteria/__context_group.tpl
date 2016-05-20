{$btnId = "btnGroupChooser{microtime(true)|md5}"}
<input type="hidden" name="oper" value="in">

<b>{'common.groups'|devblocks_translate|capitalize}:</b><br>

<div style="margin:0px 0px 10px 10px;">
	<button type="button" class="chooser_group" id="{$btnId}"><span class="glyphicons glyphicons-search"></span></button>
</div>

<script type="text/javascript">
$(function() {
	$('#{$btnId}').each(function() {
		ajax.chooser(this,'{CerberusContexts::CONTEXT_GROUP}','group_id', { autocomplete:true });
	})
	.first()
	.siblings('input:text')
	.focus();
});
</script>
