
var date = new Date();
var dateStr = date.toLocaleTimeString();
$(".intro").append('<h3>System Status as of '+dateStr+'</h3>');

var displayNames;

$(document).ready(function() {
    // var jenkinsURL = "jenkins.json";
    var jenkinsURL = "jenkins/api/json";
    var monitorURL = "monitor/json";
    $.getJSON("app_display_names.json", function(json) {
	displayNames = json;
	$.getJSON(jenkinsURL, function(response) { parse_jenkins(response); });
    });
    $.getJSON(monitorURL, function(json) { parse_monitor(json); });
});

function parse_monitor(json) {
    var states = [ 'normal', 'issue', 'outage' ];
    var units = $.map(json, function(x) {
	var state = (states[x[2]]) ? states[x[2]] : 'unknown';
	return {name:x[1], state:state, type:x[0]};
    });
    units = $.grep(units, function(x) { return x["type"].match("kbase") && !x["name"].match("_test"); });
    show_table(units, 'monitor', 'monitor', 'Server connections');
}

function parse_jenkins(response) {
    jobs = response['jobs'];
    sections = [['app', 'Apps'], ['method', 'Methods'], ['service', 'Services'], ['module', 'Client builds']];
    for (var i in sections) {
	var type = sections[i][0];
	var desc = sections[i][1];
	var units = parse_jenkins_jobs(jobs, type);
	show_table(units, 'jenkins', type, desc);
    }
}

function parse_jenkins_jobs(jobs, type) {
    var reg = new RegExp('^'+type+'-');
    jobs = $.grep(jobs, function(x) { return x["name"].match(reg); });
    jobs = jobs.sort(function(a, b) {
	var name_a  = a["name"].replace(type+'-', "");
	var name_b  = b["name"].replace(type+'-', "");
	var disp_a  = get_display_name(name_a, type);
	var disp_b  = get_display_name(name_b, type);
	return disp_a.localeCompare(disp_b);
    });
    var states = {
	'blue'     : 'normal',
	'red'      : 'outage',
	'yellow'   : 'issue',
	'notbuilt' : 'unknown'
    };
    var units = $.map(jobs, function(x) {
	var id    = x["name"].replace(type+'-', "");
	var url   = x["url"];
	var color = x["color"].replace("_anime", "");
	var name  = get_display_name(id, type);
	var state = states[color];
	return {id:id, url:url, name:name, state:state, type:type};
    });
    return units;
}

function show_table(units, sec, type, desc) {
    var docWidth = $(document).width();
    var tdWidth = 320+16;
    var leftMargin = 12+10;
    var columns = docWidth-leftMargin > tdWidth*3 ? 3 : docWidth-leftMargin > tdWidth*2 ? 2 : 1;
    var maxWidth = tdWidth * columns;
    var divId = 'div_' + type;
    $('.'+sec).append('<div role="main" id="'+divId+'" style="max-width:'+maxWidth+'px;"></div>');
    $('#'+divId).append('<h4>'+desc+'</h4>');
    $('#'+divId).append('<table id="'+type+'"></table>');
    var $table = $("#"+type);
    var reg = new RegExp('^'+type+'-');
    for (var i in units) {
	var unit  = units[i];
	var name  = unit["name"];
	var icon  = unit["state"];
	var url   = unit["url"];
	var image = '<img class="icon" src="images/'+icon+'.png" alt="'+icon+'">';
	if (url) image = '<a target="_blank" href="'+url+'">'+image+'</a>';
	var tr = $table.find(">tbody>tr:last");
	if (!tr.length || tr.find(">td").length >= columns) {
            tr = $("<tr>");
            $table.append(tr);
	}
	cell = image + ' ' + name + '<br/>';
	tr.append("<td>" + cell + "</td>");
    }
    // Fill the last row if it is half-empty
    var tr = $table.find(">tbody>tr:last");
    var extra = columns - tr.find(">td").length;
    for (var i = 0; i < extra; i++) {
	tr.append("<td></td>");
    }
}

function get_display_name(name, type) {
    var hash = displayNames[type];
    var display = name;
    if (hash) {
	if (hash[name]) {
	    display = hash[name];
	} else if (hash[name+"_generic"]) {
	    display = hash[name+"_generic"];
	}
    }
    if (name == 'annotate_plant_transcripts') return 'Annotate Plant Transcripts'; // Original text is too long: 'Annotate Plant Transcripts with Metabolic Functions'
    if (name == 'communities_build_functional_profile') return 'Build Metagenomic Functional Abundance';
    if (name == 'communities_build_taxonomic_profile') return 'Build Metagenomic Taxonomic Abundance';
    return display;
}
