#!/usr/bin/env ruby
# coding: utf-8
# Pokémon of the Day Mastodon bot
# Written in Ruby by Alexis « Siphonay » Viguié on the 23-01-2018
# Check the attached LICENSE file

require 'rest-client'
require 'mastodon'
require 'json'
require 'open-uri'
require 'http/form_data'

client = Mastodon::REST::Client.new(
  base_url: ENV["MASTODON_INSTANCE"],
  bearer_token: ENV["MASTODON_TOKEN"]
)

client.create_app(ENV["MASTODON_APP_NAME"], ENV["MASTODON_APP_SITE"])

pokemon_id = rand(807) + 1

pokemon_info = JSON.parse(RestClient.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_id}"))

pokemon_name = pokemon_info["name"]

if pokemon_name.include? "-"
  pokemon_name = pokemon_name.slice(0..(pokemon_name.index('-')))
end

File.open("sprite.png", "wb") do |sprite_file| 
  open("#{pokemon_info["sprites"]["front_default"]}", "r") do |read_file|
    sprite_file.write(read_file.read)
  end
end

toot_media = client.upload_media(HTTP::FormData::File.new("sprite.png"))

File.delete("sprite.png")

client.create_status("The Pokémon of the day is: #{pokemon_name.capitalize}! :#{pokemon_name}\nDiscuss!", media_ids = [ toot_media.id ])
