class RecordsController < ApplicationController
	def index
	
		if logged_in?

			
			
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def game
	
		if logged_in?

			@year = params[:year]
			@game_id = params[:game_id]
			
			if @year == nil && @game_id == nil
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
			elsif @year != nil && @game_id == nil 
				@game_oneyear = Game.find_by_sql('SELECT G.game_id,
														 C.year,
														 C.cup_name,
														 teamAway.team_name AS teamAwayName,
														 G.away_score,
														 G.home_score,
														 teamHome.team_name AS teamHomeName,
														 G.time,
														 G.mvp
													FROM games AS G, 
														 cups AS C, 
														 teams AS teamHome,
														 teams AS teamAway
												   WHERE G.cup_id = C.cup_id AND
														 teamHome.team_id = G.home_team_id AND
														 teamAway.team_id = G.away_team_id AND
														 C.year = "' + @year.to_s + '"
												ORDER BY G.game_id')
			else
				
				@winner = ""
				@loser = ""
				@saver = ""
				@game_onegame = Game.find_by_sql('SELECT G.game_id,
														 C.year,
														 C.cup_name,
														 teamAway.team_name AS teamAwayName,
														 teamAway.team_id AS teamAwayID,
														 G.away_score,
														 G.home_score,
														 teamHome.team_name AS teamHomeName,
														 teamHome.team_id AS teamHomeID,
														 G.time,
														 G.mvp
													FROM games AS G, 
														 cups AS C, 
														 teams AS teamHome,
														 teams AS teamAway
												   WHERE G.cup_id = C.cup_id AND
														 teamHomeID = G.home_team_id AND
														 teamAwayID = G.away_team_id AND
														 G.game_id = "' + @game_id + '"')[0]
				@game_BattingAway = Batting.find_by_sql('SELECT BAT.team_id,
																BAT."order",
																BAT.player_id,
																(BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																BAT.AB,
																BAT.H,
																BAT.B2,
																BAT.B3,
																BAT.HR,
																(BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																BAT.RBI,
																BAT.R,
																BAT.SO,
																BAT.BB,
																BAT.IBB,
																BAT.SF,
																BAT.E,
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamAwayID + '"
													   ORDER BY BAT."order"')
				@game_AllBattingAway = Batting.find_by_sql('SELECT BAT.team_id,
																   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_BattingHome = Batting.find_by_sql('SELECT BAT.team_id,
																BAT."order",
																BAT.player_id,
																(BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																BAT.AB,
																BAT.H,
																BAT.B2,
																BAT.B3,
																BAT.HR,
																(BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																BAT.RBI,
																BAT.R,
																BAT.SO,
																BAT.BB,
																BAT.IBB,
																BAT.SF,
																BAT.E,
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamHomeID + '"
													   ORDER BY BAT."order"')
				@game_AllBattingHome = Batting.find_by_sql('SELECT BAT.team_id,
																   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_PitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS REAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamAwayID + '"
														 ORDER BY PIT."order"')
				@game_AllPitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS REAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_PitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS REAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamHomeID + '"
														 ORDER BY PIT."order"')
				@game_AllPitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS REAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_FieldingAway = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS REAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS POSITION
															WHERE FIELD.POS = POSITION.POS AND
																  FIELD.game_id = "' + @game_id + '" AND
																  FIELD.team_id = "' + @game_onegame.teamAwayID + '"
														 ORDER BY POSITION.pos_num,
																  FIELD.player_id')
				@game_AllFieldingAway = Fielding.find_by_sql('SELECT FIELD.team_id,
																	 SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	 SUM(FIELD.PO) AS PO,
																	 SUM(FIELD.K) AS K,
																	 SUM(FIELD.A) AS A,
																	 SUM(FIELD.E) AS E,
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.game_id = "' + @game_id + '" AND
																	 FIELD.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_FieldingHome = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS REAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS POSITION
															WHERE FIELD.POS = POSITION.POS AND
																  FIELD.game_id = "' + @game_id + '" AND
																  FIELD.team_id = "' + @game_onegame.teamHomeID + '"
														 ORDER BY POSITION.pos_num,
																  FIELD.player_id')
				@game_AllFieldingHome = Fielding.find_by_sql('SELECT FIELD.team_id,
																	 SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	 SUM(FIELD.PO) AS PO,
																	 SUM(FIELD.K) AS K,
																	 SUM(FIELD.A) AS A,
																	 SUM(FIELD.E) AS E,
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.game_id = "' + @game_id + '" AND
																	 FIELD.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				if @game_PitchingAway.size != 0
					@game_PitchingAway.each do |pitAway|
						if pitAway.W == 1
							@winner = pitAway.player_id
						end
						if pitAway.L == 1
							@loser = pitAway.player_id
						end
						if pitAway.SV == 1
							@saver = pitAway.player_id
						end
					end
				end
				if @game_PitchingHome.size != 0
					@game_PitchingHome.each do |pitHome|
						if pitHome.W == 1
							@winner = pitHome.player_id
						end
						if pitHome.L == 1
							@loser = pitHome.player_id
						end
						if pitHome.SV == 1
							@saver = pitHome.player_id
						end
					end
				end
			end
			
		else
			session[:return_to] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def playersInYear(year)
		
		if year == "Wildcard"
			@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT BAT.player_id
													   FROM battings AS BAT,
															players AS PLY
													  WHERE BAT.player_id = PLY.player_id AND
															PLY.member = 1
												   ORDER BY BAT.player_id')
		else
			@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT BAT.player_id
													   FROM battings AS BAT,
															players AS PLY
													  WHERE BAT.player_id = PLY.player_id AND
															PLY.member = 1 AND
															BAT.game_id IN (SELECT G.game_id 
																			  FROM battings AS BAT,
																				   games AS G,
																				   cups AS C
																			 WHERE BAT.game_id = G.game_id AND
																				   G.cup_id = C.cup_id AND
																				   C.year = "' + year.to_s + '")
												   ORDER BY BAT.player_id')
		end
		
		return @playerInThisYear
	end
	helper_method :playersInYear
	
	def batting
		
		if logged_in?
		
			@activePLAYER_rate = 1
			@activePLAYER = 150
			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			@type = params[:type]
			@year = ""
			@year1 = params[:year1]
			@year2 = params[:year2]
			@player = params[:player]
			@player1 = params[:player1]
			@player2 = params[:player2]
			
			if @type == 'single'
				@player = params[:player1]
				@year = params[:year1]
			elsif @type == 'pk'
				if params[:player1] == params[:player2] && params[:year1] = params[:year2]
					@player = params[:player1]
					@year = params[:year1]
				else
					@player = "pk"
					@year = "pk"
				end
			end
			
			if @player == nil
				
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			
			elsif @player == "all"	
				
				@sorting = params[:sorting]
				@sql_year = ""
				if @year == "Wildcard"
					@sql_year = ""
				else
					@sql_year = ' AND BAT.game_id IN (SELECT G.game_id 
													    FROM battings AS BAT,
															 games AS G,
															 cups AS C 
													   WHERE BAT.game_id = G.game_id AND
															 G.cup_id = C.cup_id AND
															 C.year = "' + @year + '") '
				end
				@allBatting = Batting.find_by_sql('SELECT BAT.player_id, 
														  COUNT(BAT.game_id) AS G, 
														  SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA, 
														  SUM(BAT.AB) AS AB, 
														  SUM(BAT.H) AS H, 
														  SUM(BAT.B2) AS B2, 
														  SUM(BAT.B3) AS B3, 
														  SUM(BAT.HR) AS HR, 
														  SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB, 
														  SUM(BAT.RBI) AS RBI, 
														  SUM(BAT.R) AS R, 
														  SUM(BAT.SO) AS SO, 
														  SUM(BAT.BB) AS BB, 
														  SUM(BAT.IBB) AS IBB, 
														  SUM(BAT.SF) AS SF, 
														  SUM(BAT.E) AS E, 
														  CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
														  (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
														  CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
												     FROM battings AS BAT, 
														  players AS PLY 
												    WHERE BAT.player_id = PLY.player_id AND
														  PLY.member = 1 ' + @sql_year.to_s +
											    'GROUP BY BAT.player_id')
				@mainPlayer = ' AND BAT.player_id IN (SELECT BAT.player_id 
														FROM battings AS BAT 
													   WHERE BAT.game_id <> "0" ' + @sql_year.to_s + 
												   'GROUP BY BAT.player_id 
													  HAVING SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @gameNumberInYear[@year.to_s].to_s + ' OR
															 SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @activePLAYER.to_s + ') '
				@notMainPlayer = ' AND BAT.player_id IN (SELECT BAT.player_id 
														   FROM battings AS BAT
														  WHERE BAT.game_id <> "0" ' + @sql_year.to_s +
													  'GROUP BY BAT.player_id 
													     HAVING SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) < ' + @gameNumberInYear[@year.to_s].to_s + ' AND
																SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) < ' + @activePLAYER.to_s + ') '
				@allBattingSummary_M = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
															  FROM battings AS BAT,
																   players AS PLY
															 WHERE BAT.player_id = PLY.player_id AND
																   PLY.member = 1 ' + @mainPlayer + @sql_year)[0]
				@allBattingSummary_nM = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																    SUM(BAT.AB) AS AB,
																    SUM(BAT.H) AS H,
																    SUM(BAT.B2) AS B2,
																    SUM(BAT.B3) AS B3,
																    SUM(BAT.HR) AS HR,
																    SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																    SUM(BAT.RBI) AS RBI,
																    SUM(BAT.R) AS R,
																    SUM(BAT.SO) AS SO,
																    SUM(BAT.BB) AS BB,
																    SUM(BAT.IBB) AS IBB,
																    SUM(BAT.SF) AS SF,
																    SUM(BAT.E) AS E,
																    CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																    (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																    CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
															   FROM battings AS BAT,
																	players AS PLY
															  WHERE BAT.player_id = PLY.player_id AND
																    PLY.member = 1 ' + @notMainPlayer + @sql_year)[0]
				@allBattingSummary_all = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																     SUM(BAT.AB) AS AB,
																     SUM(BAT.H) AS H,
																     SUM(BAT.B2) AS B2,
																     SUM(BAT.B3) AS B3,
																     SUM(BAT.HR) AS HR,
																     SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																     SUM(BAT.RBI) AS RBI,
																     SUM(BAT.R) AS R,
																     SUM(BAT.SO) AS SO,
																     SUM(BAT.BB) AS BB,
																     SUM(BAT.IBB) AS IBB,
																     SUM(BAT.SF) AS SF,
																     SUM(BAT.E) AS E,
																     CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																     (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																     CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
															    FROM battings AS BAT,
																	 players AS PLY
															   WHERE BAT.player_id = PLY.player_id AND
																     PLY.member = 1 ' + @sql_year)[0]												   
				
			elsif @player == "pk"
			
			else
			
			end
			
			
		
		else
			session[:return_to] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
end
