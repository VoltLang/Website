$(function() {
	if (navigator.userAgent.match(/(MSIE|Trident|IEMobile)/i)) {
		$('img[src*="svg"]').attr('src', function() {
			return $(this).attr('src').replace('.svg', '.png');
		});
	}
});