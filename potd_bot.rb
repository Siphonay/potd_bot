#!/usr/bin/env ruby
# coding: utf-8
# Pokémon of the Day Mastodon bot
# Written in Ruby by Alexis « Siphonay » Viguié on the 23-01-2018
# Check the attached LICENSE file

require 'rest-client'
require 'mastodon'
require 'json'
require 'open_uri'

client = Mastodon::REST::Client.new(
  base_url: ENV["MASTODON_INSTANCE"],
  bearer_token: ENV["MASTODON_TOKEN"]
)

pokemon_id = rand(807) + 1

pokemon_info = JSON.parse(RestClient.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_id}"))

pokemon_name = pokemon_info["name"].slice(0..(pokemon_info["name"].index('-')))

pokemon_sprite = open("#{pokemon_info["sprites"]["front_default"]}", "r")

toot_media = client.upload_media(pokemon_sprite)

client.create_status("The Pokémon of the day is: #{pokemon_name.capitalize}! :#{pokemon_name}\nDiscuss!", media_ids = [ toot_media.id ])
