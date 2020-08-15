json.array! @contacts do |contact|
  json.name contact.name
  json.email contact.email
  json.phone contact.phone
  json.description contact.description

  json.addresses contact.addresses do |address|
    json.partial! 'contacts/v2/address', address: address
  end
  
end
