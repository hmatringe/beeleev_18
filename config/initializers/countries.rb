Country.new('AD').translations["en"] = 'Andorra'
Country.new('BB').translations["en"] = 'Barbados'
Country.new('ME').translations["en"] = 'Montenegro'
Country.new('RE').translations["en"] = 'Reunion'
Country.new('KR').translations["en"] = 'South Korea'
Country.new('KP').translations["en"] = 'North Korea'
Country.new('GG').translations["en"] = 'Guernsey'
Country.new('FM').translations["en"] = 'Micronesia, Federated States Of'
Country.new('MO').translations["en"] = 'Macau'
Country.new('TL').translations["en"] = 'Timor-Leste'
Country.new('VI').translations["en"] = 'US Virgin Islands'

# add kosovo
ISO3166::Country::Data['KO'] = {
  'alpha2' => 'KO',
  'name' => 'Kosovo',
  'names' => ['Kosovo'],
  'translations' => {
    'en' => 'Kosovo',
    'fr' => 'Kosovo'
  }
}

# remove unwanted countries
%w(AQ BQ BV CX CC IO TF HM BL MF SJ UM VA AN NF PN GS TK).each do |code|
  ISO3166::Country::Data.delete code
end
