// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .

//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require jquery-ui.js


states_hash =
  {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'District of Columbia': 'DC',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Guam': 'GU',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY'
  }

function getRecord(name){
  alert(name);
}


document.addEventListener("turbolinks:load", function() {
  $("#countyLookup").click(function(e){
      e.preventDefault();
      if ($('#placeInput').val()) {
        var link = "https://www.google.com/maps/embed/v1/search?q=What County " + $('#placeInput').val() + " " + $('#espy_record_state').val() + "&key=AIzaSyBDbjHsonLOLVDuZGUsLGmdf9Bh4LvyaUU";
        var frame = document.querySelector("#mapsWindow");
        frame.src = frame.src + link;
        $('#modalMap').modal()
      } else {
        if ($("#espy_record_county_name").val()) {
            $countyName = $("#espy_record_county_name").val().replace(" ", "+")
            $countyState = $("#espy_record_state_abbreviation").val()
        } else {
            $countyName = $("#espy_record_county_name").text().replace(" ", "+")
            $countyState = $("#espy_record_state_abbreviation").text()
        }
        var link = "https://www.google.com/maps/embed/v1/place?q=" + $countyName + "+County,+" + $countyState + "&zoom=9" + "&key=AIzaSyBDbjHsonLOLVDuZGUsLGmdf9Bh4LvyaUU";
        var frame = document.querySelector("#mapsWindow");
        frame.src = frame.src + link;
        $('#modalMap').modal()
      }
  }); 
});

document.addEventListener("turbolinks:load", function() {
	$('#espy_record_state').change(function() {
		var $abbr = states_hash[$(this).val()];
		$('#espy_record_state_abbreviation').val($abbr);
	});
});

document.addEventListener("turbolinks:load", function() {
	$("#fipsLookup").click(function(e){
		e.preventDefault();
		if( !$('#espy_record_state').val() ) {
			$('#espy_record_state').css({ "border": '#FF0000 1px solid'});
		} else {
			$state = $('#espy_record_state').val();
			$county = $("#espy_record_county_name").val();
			$.getJSON('/FIPS.json', function(data) {
				if (data[$state][$county]) {
					$fips = data[$state][$county]
            if ($('#espy_record_county_code').val().length == 0) {
  			  		$('#espy_record_county_code').val($fips);
            } else {
              if ($('#espy_record_county_code').val() == $fips) {
                $('#espy_record_county_code').val($fips);
                $('#espy_record_county_code').addClass("is-valid");
              } else {
                $('#espy_record_county_code').val($fips);
                $('#espy_record_county_code').addClass("is-valid");
                $('#fips').append('<small class="form-text text-muted is-invalid" style="color:red !important">County Code Corrected</small>');
              }
            }
				} else {
					$('#espy_record_county_name').css({ "border": '#FF0000 1px solid'});
				}
			  
			});
		}
	});
});

document.addEventListener("turbolinks:load", function() {
    $('#makeForm').submit(function()
    {
       if($('#used_check').attr('data-value') == 'used')
       {
          var icpsrID = $("#icpsr").val()
          var icpsrName = $("#name").text()
          alert("ERROR: Icpsr record " + icpsrID + " (" + icpsrName + ") has already been used to create an Espy record.");
          return false;
       }
    });
});
