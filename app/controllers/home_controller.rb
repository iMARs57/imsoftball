class HomeController < ApplicationController

	before_action :authenticate_user!, :only => :determine
	require "ipaddr"
	
	def remote_ip	
    	locIp = IPAddr.new("127.0.0.1")
		remIP = IPAddr.new(request.remote_ip)
    	if remIP === locIp
      		# Hard coded remote address for test
      		#IPAddr.new("123.45.67.89")
      		IPAddr.new("140.112.12.34")
    	else
      		remIP
    	end
  	end

	def determine
		
		if user_signed_in?
			session[:username] = "anonymous"
			redirect_to :action => "index"
			return
		end
		# 未授權過的session，則檢查來query本頁面的 IP 為何
  		# 看此 IP 是否為允許範圍內
  		ntuIP = IPAddr.new("140.112.0.0/16")
  		if (ntuIP === remote_ip)
  			#在此 session 標上已授權記號
    		session[:username] = "anonymous"
    		redirect_to :action => "index"
    	else
    		redirect_to "users/sign_in"
  		end

	end


	def index
		# 若此session無 已授權 標示，導回首頁
  		#if session[:username] == nil
    	#	redirect_to :action => "determine"
		#	return
  		#end
      
      # 執行秀出已授權可看的畫面內容

      if(Time.now.year < 2011)
        if Time.now.month >= 9
          @academicYear = '0' + (Time.now.year - 1911).to_s
          @thisyear = Time.now.year
        else
          @academicYear = '0' + (Time.now.year - 1912).to_s
          @thisyear = Time.now.year - 1
        end
      else
        if Time.now.month >= 9
          @academicYear = (Time.now.year - 1911).to_s
          @thisyear = Time.now.year
        else
          @academicYear = (Time.now.year - 1912).to_s
          @thisyear = Time.now.year - 1
        end
      end

      # News' kaminari setup
      @informations = Information.order('date DESC').page(params[:page]).per(6)
      # SQL for Info Board
      @panel_allGames = Game.select('games.*,
                                     cups.cup_name,
                                     teamAway.team_name AS teamAway_name,
                                     teamHome.team_name AS teamHome_name')
                            .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                            .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                            .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                            .order('game_id DESC').take(5)
      @panel_formalGames = Game.select('games.*,
                                        cups.cup_name,
                                        teamAway.team_name AS teamAway_name,
                                        teamHome.team_name AS teamHome_name')
                               .where('cups.formal = "1"')
                               .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                               .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                               .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                               .order('game_id DESC').take(5)
      @panel_officialGames = Game.select('games.*,
                                          cups.cup_name,
                                          teamAway.team_name AS teamAway_name,
                                          teamHome.team_name AS teamHome_name')
                                 .where('cups.official = "1"')
                                 .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                                 .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                                 .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                                 .order('game_id DESC').take(5)
      @panel_leagueGames = Game.select('games.*,
                                        cups.cup_name,
                                        teamAway.team_name AS teamAway_name,
                                        teamHome.team_name AS teamHome_name')
                               .where('cups.cup_name = "台大聯盟"')
                               .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                               .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                               .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                               .order('game_id DESC').take(5)
      @panel_friendlyGames = Game.select('games.*,
                                          cups.cup_name,
                                          teamAway.team_name AS teamAway_name,
                                          teamHome.team_name AS teamHome_name')
                                 .where('cups.formal = "0" AND cups.official = "0"')
                                 .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                                 .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                                 .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                                 .order('game_id DESC').take(5)
      @panel_standings_GP = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR 
                                        games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))')
                                .count('games.game_id')
      @panel_standings_W = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score > games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score < games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score > games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score < games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score > games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score < games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_L = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score < games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score > games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score < games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score > games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score < games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score > games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_D = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score = games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score = games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score = games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score = games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score = games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score = games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_WLD = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                    AND (games.home_team_id = "IM" OR 
                                         games.away_team_id = "IM" OR
                                        (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                        (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                        (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                        (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))')
      @counter = 0;
      @panel_standings_last10_W = 0
      @panel_standings_last10_L = 0
      @panel_standings_last10_D = 0
      @panel_standings_away_W = 0;
      @panel_standings_away_L = 0;
      @panel_standings_away_D = 0;
      @panel_standings_home_W = 0;
      @panel_standings_home_L = 0;
      @panel_standings_home_D = 0;
      
      @panel_standings_WLD.each do |wld|
        if wld.home_team_id == "IM" || wld.home_team_id == "IM-A" || wld.home_team_id == "IM-B"
          if wld.home_score > wld.away_score
            @panel_standings_home_W = @panel_standings_home_W + 1;
            if @counter < 10
              @panel_standings_last10_W = @panel_standings_last10_W + 1;
            end
          elsif wld.home_score < wld.away_score
            @panel_standings_home_L = @panel_standings_home_L + 1;
            if @counter < 10  
              @panel_standings_last10_L = @panel_standings_last10_L + 1;
            end
          else
            @panel_standings_home_D = @panel_standings_home_D + 1;
            if @counter < 10
              @panel_standings_last10_D = @panel_standings_last10_D + 1;
            end
          end
        else
          if wld.home_score < wld.away_score
            @panel_standings_away_W = @panel_standings_away_W + 1;
            if @counter < 10
              @panel_standings_last10_W = @panel_standings_last10_W + 1;
            end
          elsif wld.home_score > wld.away_score 
            @panel_standings_away_L = @panel_standings_away_L + 1;
            if @counter < 10
              @panel_standings_last10_L = @panel_standings_last10_L + 1;
            end
          else
            @panel_standings_away_D = @panel_standings_away_D + 1;
            if @counter < 10
              @panel_standings_last10_D = @panel_standings_last10_D + 1;
            end
          end
        end
        @counter = @counter + 1;
      end

      @panel_standings_forAvgBat = Game.find_by_sql('SELECT SUM(b.AB) AS allAB, SUM(b.H) AS allH, SUM(b.HR) AS allHR
                                                     FROM games AS g, battings AS b
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = b.game_id
                                                     AND (b.team_id = "IM" OR
                                                          b.team_id = "IM-A" OR
                                                          b.team_id = "IM-B")')[0]
      @panel_standings_forAvgDef = Game.find_by_sql('SELECT SUM(f.PO) AS allPO, SUM(f.A) AS allA, SUM(f.E) AS allE
                                                     FROM games AS g, fieldings AS f
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = f.game_id
                                                     AND (f.team_id = "IM" OR
                                                          f.team_id = "IM-A" OR
                                                          f.team_id = "IM-B")')[0]
      @panel_standings_forAvgERA = Game.find_by_sql('SELECT SUM(p.IPouts) AS allIPouts, SUM(p.ER) AS allER
                                                     FROM games AS g, pitchings AS p
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = p.game_id
                                                     AND (p.team_id = "IM" OR
                                                          p.team_id = "IM-A" OR
                                                          p.team_id = "IM-B")')[0]
      @panel_standings_AvgERA5 = (15 * @panel_standings_forAvgERA.allER.to_f / @panel_standings_forAvgERA.allIPouts.to_f).round(2)
      @panel_standings_AvgERA7 = (21 * @panel_standings_forAvgERA.allER.to_f / @panel_standings_forAvgERA.allIPouts.to_f).round(2)

      
      # Top 5 panel

      @activePLAYER = 150
      @gameNumber = Game.where('cups.year = ' + @thisyear.to_s).joins('INNER JOIN cups ON cups.cup_id = games.cup_id').count()
      





      #@panel_top5_AVG = 

                                
                                                         
	end

end
