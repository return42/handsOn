//  -*- coding: utf-8; mode: javascript -*-
//  ----------------------------------------------------------------------------
//  Purpose:   Hover table rows in autoindex generated HTML
//  ----------------------------------------------------------------------------

$(document).ready( function() {
    $('table tr').alternate({hover:true});
    jQuery('#localREADME').load('README');
    jQuery('#localMEMO').load('MEMO.txt');
});
