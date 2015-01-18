
var date = new Date();
var dateStr = date.toLocaleTimeString();
$(".intro").append('<h3>System Status as of '+dateStr+'</h3>');

var displayNames;

$(document).ready(function() {
    $.getJSON("app_display_names.json", function(json) {
	displayNames = json;
	var jenkinsURL = "http://140.221.67.1:8080/jenkins/api/json";
	$.getJSON(jenkinsURL, function(response) { parse_jenkins(response); });
    });
});

function parse_jenkins(response) {
    jobs = response['jobs'];
    sections = [['app', 'Apps'], ['method', 'Methods'], ['service', 'Services'], ['module', 'Client builds']];
    for (var i in sections) {
	var type = sections[i][0];
	var desc = sections[i][1];
	show_table(jobs, type, desc);
    }
}

function show_table(jobs, type, desc) {
    var docWidth = $(document).width();
    var tdWidth = 320+16;
    var leftMargin = 15;
    var columns = docWidth-leftMargin > tdWidth*3 ? 3 : docWidth-leftMargin > tdWidth*2 ? 2 : 1;
    var maxWidth = tdWidth * columns;
    var divId = 'div_' + type;
    $('#dashboards').append('<div role="main" id="'+divId+'" style="max-width:'+maxWidth+'px;"></div>');
    $('#'+divId).append('<h4>'+desc+'</h4>');
    $('#'+divId).append('<table id="'+type+'"></table>');
    var icons = {
	'blue'     : 'normal',
	'red'      : 'outage',
	'yellow'   : 'issue',
	'notbuilt' : 'unknown'
    };
    var $table = $("#"+type);
    var reg = new RegExp('^'+type+'-');
    jobs = $.grep(jobs, function(j) { return j["name"].match(reg); });
    for (var i in jobs) {
	job   = jobs[i];
	name  = job["name"].replace(type+'-', "");
	url   = job["url"];
	color = job["color"].replace("_anime", "");
	disp  = get_display_name(name, type);
	icon  = icons[color];
	image = '<img class="icon" src="images/'+icon+'.png" alt="'+icon+'">';
	image = '<a target="_blank" href="'+url+'">'+image+'</a>';
	var tr = $table.find(">tbody>tr:last");
	if (!tr.length || tr.find(">td").length >= columns) {
            tr = $("<tr>");
            $table.append(tr);
	}
	cell = image + ' ' + disp + '<br/>';
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
    return display;
}
