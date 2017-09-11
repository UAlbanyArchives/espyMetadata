module EspyRecordsHelper

	def type_options
		[
			['Sourced'],
			['Espy Unconfirmed'],
			['Not Executed']
		]
	end

	def jurisdiction_options
		[
			['Unknown'],
			['Local-Colonial'],
			['State'],
			['Federal'],
			['Territorial'],
			['Indian Tribunal'],
			['Other-Military']
		]
	end

	def crime_options
		[
			['Unknown'],
			['Murder'],
			['Rape'],
			['Criminal Assault'],
			['Housebrkng-Burgl'],
			['Horse Stealing'],
			['Consp to Murder'],
			['Treason'],
			['Slave Revolt'],
			['Witchcraft'],
			['Robbery-Murder'],
			['Rape-Murder'],
			['Piracy'],
			['Accessory to Mur'],
			['Desertion'],
			['Robbery'],
			['Arson'],
			['Guerilla Activit'],
			['Spying-Espionage'],
			['Murder-Rape-Rob'],
			['Burg-Att Rape'],
			['Rioting'],
			['Attempted Rape'],
			['Murder-Burglary'],
			['Kidnap-Murder'],
			['Kidnap-Murdr-Rob'],
			['Arson-Murder'],
			['Rape-Robbery'],
			['Kidnapping'],
			['Prisn Brk-Kidnap'],
			['Sodmy-Buggry-Bst'],
			['Adultery'],
			['Poisoning'],
			['Concealing Birth'],
			['Unspec Felony'],
			['Aid Runaway Slve'],
			['Counterfeiting'],
			['Attempted Murder'],
			['Forgery'],
			['Theft-Stealing'],
			['Other']
		]
	end

	def place_options
		[
			['Unknown'],
			['City-Local Juris'],
			['County-Local Jur'],
			['State-ST Prison'],
			['Other']
		]
	end

	def us_states
	    [
	      ['Alabama'],
	      ['Alaska'],
	      ['Arizona'],
	      ['Arkansas'],
	      ['California'],
	      ['Colorado'],
	      ['Connecticut'],
	      ['Delaware'],
	      ['District of Columbia'],
	      ['Florida'],
	      ['Georgia'],
	      ['Hawaii'],
	      ['Idaho'],
	      ['Illinois'],
	      ['Indiana'],
	      ['Iowa'],
	      ['Kansas'],
	      ['Kentucky'],
	      ['Louisiana'],
	      ['Maine'],
	      ['Maryland'],
	      ['Massachusetts'],
	      ['Michigan'],
	      ['Minnesota'],
	      ['Mississippi'],
	      ['Missouri'],
	      ['Montana'],
	      ['Nebraska'],
	      ['Nevada'],
	      ['New Hampshire'],
	      ['New Jersey'],
	      ['New Mexico'],
	      ['New York'],
	      ['North Carolina'],
	      ['North Dakota'],
	      ['Ohio'],
	      ['Oklahoma'],
	      ['Oregon'],
	      ['Pennsylvania'],
	      ['Rhode Island'],
	      ['South Carolina'],
	      ['South Dakota'],
	      ['Tennessee'],
	      ['Texas'],
	      ['Utah'],
	      ['Vermont'],
	      ['Virginia'],
	      ['Washington'],
	      ['West Virginia'],
	      ['Wisconsin'],
	      ['Wyoming']
	    ]
	end

	def state_names
  		names = {
		    'Alabama' => 'AL',
		    'Alaska' => 'AK',
		    'Arizona' => 'AZ',
		    'Arkansas' => 'AR',
		    'California' => 'CA',
		    'Colorado' => 'CO',
		    'Connecticut' => 'CT',
		    'Delaware' => 'DE',
		    'District of Columbia' => 'DC',
		    'Florida' => 'FL',
		    'Georgia' => 'GA',
		    'Hawaii' => 'HI',
		    'Idaho' => 'ID',
		    'Illinois' => 'IL',
		    'Indiana' => 'IN',
		    'Iowa' => 'IA',
		    'Kansas' => 'KS',
		    'Kentucky' => 'KY',
		    'Louisiana' => 'LA',
		    'Maine' => 'ME',
		    'Maryland' => 'MD',
		    'Massachusetts' => 'MA',
		    'Michigan' => 'MI',
		    'Minnesota' => 'MN',
		    'Mississippi' => 'MS',
		    'Missouri' => 'MO',
		    'Montana' => 'MT',
		    'Nebraska' => 'NE',
		    'Nevada' => 'NV',
		    'New Hampshire' => 'NH',
		    'New Jersey' => 'NJ',
		    'New Mexico' => 'NM',
		    'New York' => 'NY',
		    'North Carolina' => 'NC',
		    'North Dakota' => 'ND',
		    'Ohio' => 'OH',
		    'Oklahoma' => 'OK',
		    'Oregon' => 'OR',
		    'Pennsylvania' => 'PA',
		    'Rhode Island' => 'RI',
		    'South Carolina' => 'SC',
		    'South Dakota' => 'SD',
		    'Tennessee' => 'TN',
		    'Texas' => 'TX',
		    'Utah' => 'UT',
		    'Vermont' => 'VT',
		    'Virginia' => 'VA',
		    'Washington' => 'WA',
		    'West Virginia' => 'WV',
		    'Wisconsin' => 'WI',
		    'Wyoming' => 'WY'
	  	}
	end
end
