class RecAppController < ApplicationController

	def index
		if logged_in?



		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end

	def playerlist

		@player = params[:player]
		@inactive = params[:inactive]

		@all_player_option = Hash.new(0)
		@allPlayer = Player.select('players.player_id, members.name').where('players.member = 1').joins('INNER JOIN members ON members.id = players.player_id').order('players.player_id')
		@allPlayer.each do |eachPlayer|
			@all_player_option[eachPlayer.player_id] = eachPlayer.name + ' (' + eachPlayer.player_id + ')'
		end

		return @all_player_option
	end

	def game_import

		require 'rubygems'
		require 'mechanize'
		require 'open-uri'


		if logged_in?

			@url = params[:sheetURL]
			if @url != nil
				# retrieve the key of google sheets
				@key = @url.split('/')[5]
				#@player_option = playerlist.to_json
				@player_option = ActiveSupport::JSON.encode(playerlist)
				mechanize = Mechanize.new
				mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				@sheetName = mechanize.get(@url).title
			end

		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end

	def game_create
		if logged_in?



		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end

	def game_edit
		if logged_in?



		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end


end
